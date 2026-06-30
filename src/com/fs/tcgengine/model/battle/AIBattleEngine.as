package com.fs.tcgengine.model.battle
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.AbilitiesMng;
   import com.fs.tcgengine.controller.PvPConnectionMng;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.board.card.Ability;
   import com.fs.tcgengine.model.rules.AIMovementDef;
   import com.fs.tcgengine.model.rules.AbilityDef;
   import com.fs.tcgengine.model.rules.ActionDef;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.model.rules.PowerDef;
   import com.fs.tcgengine.model.rules.UnitDef;
   import com.fs.tcgengine.model.userdata.UserBattleInfo;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSAction;
   import com.fs.tcgengine.view.cards.FSAttachment;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.FSPower;
   import com.fs.tcgengine.view.cards.FSUnit;
   import com.fs.tcgengine.view.components.battle.FSBattlefieldUserPortrait;
   import com.fs.tcgengine.view.socket.FSCardSocket;
   import com.greensock.TweenMax;
   import flash.utils.Dictionary;
   import starling.core.Starling;
   import starling.utils.deg2rad;
   
   public class AIBattleEngine implements FSModelUnloadableInterface
   {
      
      private const MOVE_UNIT:int = 0;
      
      private const MOVE_ATTACHMENT:int = 1;
      
      private const MOVE_ACTION:int = 2;
      
      private const MOVE_UPGRADE_UNIT:int = 3;
      
      private const MOVE_EXECUTE_POWER:int = 4;
      
      private const MOVE_EXECUTE_SACRIFICE:int = 5;
      
      private const MAX_STEP_ATTEMPTS:int = 10;
      
      private const MAX_GLOBAL_STEP_ATTEMPTS:int = 40;
      
      private var mBattleScreen:FSBattleScreen;
      
      private var mBattleEngine:BattleEngine;
      
      private var mOwnerBattleInfo:UserBattleInfo;
      
      private var mAIBattleInfo:UserBattleInfo;
      
      private var mGlobalMovementsDone:int = 0;
      
      private var mMoveUnitAlreadyDone:int = 0;
      
      private var mMoveAttachmentAlreadyDone:int = 0;
      
      private var mMoveActionAlreadyDone:int = 0;
      
      private var mMoveUpgradeAlreadyDone:int = 0;
      
      private var mMoveExecutePowerAlreadyDone:int = 0;
      
      private var mMoveExecuteSacrificeAlreadyDone:int = 0;
      
      private var mExecutePowerSuccess:Boolean = false;
      
      private var mExecuteSacrificeSuccess:Boolean = false;
      
      private var mCurrentDelay:Number = 0;
      
      private var mAPSpentThisTurn:int;
      
      public function AIBattleEngine()
      {
         super();
      }
      
      public function setupAI(param1:BattleEngine) : void
      {
         if(param1 != null)
         {
            this.mBattleEngine = param1;
            this.mBattleScreen = this.mBattleEngine.getBattleScreen();
            this.mAIBattleInfo = this.mBattleEngine.getOpponentBattleInfo();
            this.mOwnerBattleInfo = this.mBattleEngine.getOwnerBattleInfo();
            return;
         }
         throw new Error("[setupAI] needs a valid BattleScreen for initializing");
      }
      
      public function performNextStep(param1:Boolean = false) : void
      {
         var _loc8_:FSUnit = null;
         if(this.mBattleEngine == null || Boolean(this.mBattleEngine) && Boolean(this.mBattleEngine.getBattleStateId() == BattleEngine.BATTLE_STATE_BATTLE_OVER))
         {
            return;
         }
         if(this.mGlobalMovementsDone == 0)
         {
            this.mAPSpentThisTurn = 0;
         }
         var _loc2_:int = this.mAIBattleInfo ? this.mAIBattleInfo.getActionPointsLeft() : 0;
         var _loc3_:Boolean = false;
         var _loc4_:int = this.getNextAIMovementIndex(param1);
         if(Config.TRACE_BATTLE_LOGS)
         {
            FSDebug.debugTrace("[performNextStep] - Next move index: " + _loc4_);
         }
         var _loc5_:Boolean = this.mGlobalMovementsDone >= this.MAX_GLOBAL_STEP_ATTEMPTS || this.mMoveUnitAlreadyDone == this.MAX_STEP_ATTEMPTS && this.mMoveActionAlreadyDone == this.MAX_STEP_ATTEMPTS && (this.mMoveAttachmentAlreadyDone = this.MAX_STEP_ATTEMPTS) && this.mMoveUpgradeAlreadyDone == this.MAX_STEP_ATTEMPTS && this.mMoveExecutePowerAlreadyDone == this.MAX_STEP_ATTEMPTS;
         var _loc6_:Boolean = Config.getConfig().gameHasPowers() && PvPConnectionMng.isPlayingVSAI();
         var _loc7_:Boolean = Config.getConfig().gameHasSacrifice() && PvPConnectionMng.isPlayingVSAI();
         if((_loc6_ || _loc7_) && _loc5_ && this.mGlobalMovementsDone < this.MAX_GLOBAL_STEP_ATTEMPTS + 10 && _loc2_ > 0 && (this.mMoveExecutePowerAlreadyDone < this.MAX_STEP_ATTEMPTS || !this.mExecutePowerSuccess))
         {
            if(_loc6_)
            {
               _loc4_ = this.getNextAIPowerMovementIndex();
            }
            else if(_loc7_)
            {
               _loc4_ = this.getNextAISacrificeMovementIndex();
            }
         }
         else if(_loc5_ && this.mMoveExecutePowerAlreadyDone == this.MAX_STEP_ATTEMPTS || _loc2_ == 0 || this.mGlobalMovementsDone >= this.MAX_GLOBAL_STEP_ATTEMPTS)
         {
            if(Config.TRACE_BATTLE_LOGS)
            {
               FSDebug.debugTrace("notifying AI anims over (lastactionpoint)");
            }
            this.notifyAIAnimationsOver();
            return;
         }
         ++this.mGlobalMovementsDone;
         switch(_loc4_)
         {
            case this.MOVE_UNIT:
               if(this.mMoveUnitAlreadyDone < this.MAX_STEP_ATTEMPTS)
               {
                  ++this.mMoveUnitAlreadyDone;
                  this.moveUnitToSocket();
                  _loc3_ = true;
               }
               break;
            case this.MOVE_ATTACHMENT:
               if(this.mMoveAttachmentAlreadyDone < this.MAX_STEP_ATTEMPTS)
               {
                  ++this.mMoveAttachmentAlreadyDone;
                  this.moveAttachment();
                  _loc3_ = true;
               }
               break;
            case this.MOVE_ACTION:
               if(this.mMoveActionAlreadyDone < this.MAX_STEP_ATTEMPTS)
               {
                  ++this.mMoveActionAlreadyDone;
                  this.moveAction();
                  _loc3_ = true;
               }
               break;
            case this.MOVE_UPGRADE_UNIT:
               if(this.mMoveUpgradeAlreadyDone < this.MAX_STEP_ATTEMPTS && this.mBattleEngine.getLevelDef().isUpgradeAllowed())
               {
                  ++this.mMoveUpgradeAlreadyDone;
                  this.moveUpgrade();
                  _loc3_ = true;
               }
               break;
            case this.MOVE_EXECUTE_POWER:
               if(this.mMoveExecutePowerAlreadyDone < this.MAX_STEP_ATTEMPTS && !this.mExecutePowerSuccess)
               {
                  ++this.mMoveExecutePowerAlreadyDone;
                  this.moveExecutePower();
                  _loc3_ = true;
               }
               break;
            case this.MOVE_EXECUTE_SACRIFICE:
               if(this.mMoveExecuteSacrificeAlreadyDone < this.MAX_STEP_ATTEMPTS && !this.mExecuteSacrificeSuccess)
               {
                  ++this.mMoveExecuteSacrificeAlreadyDone;
                  _loc8_ = this.getSacrificeTarget();
                  if(_loc8_)
                  {
                     this.moveExecuteSacrifice(_loc8_);
                     _loc3_ = true;
                  }
               }
         }
         if(!_loc3_)
         {
            this.performNextStep();
         }
      }
      
      private function getSacrificeTarget() : FSUnit
      {
         var _loc3_:FSUnit = null;
         var _loc1_:FSUnit = null;
         var _loc2_:Dictionary = this.mAIBattleInfo.getFightCards();
         if(_loc2_)
         {
            for each(_loc3_ in _loc2_)
            {
               if(_loc3_.getDamage() <= 1 || _loc3_.getDefense() == 1)
               {
                  return _loc3_;
               }
            }
         }
         return _loc1_;
      }
      
      private function getPowerSocketTarget(param1:Ability, param2:Vector.<FSCardSocket>) : FSCardSocket
      {
         var _loc4_:int = 0;
         var _loc5_:FSUnit = null;
         var _loc6_:Boolean = false;
         var _loc3_:FSCardSocket = null;
         if(Boolean(param1) && param1.getAbilityDef().getKeyName() == "BOT_POWER")
         {
            _loc4_ = 0;
            _loc4_ = 0;
            while(_loc4_ < param2.length)
            {
               _loc5_ = FSUnit(param2[_loc4_].getParentCard());
               if(_loc5_)
               {
                  _loc6_ = _loc5_.getInvulnerableTurns() > 0;
                  if(!_loc6_)
                  {
                     _loc3_ = _loc3_ == null || _loc3_ != null && _loc5_.getDefense() < FSUnit(_loc3_.getParentCard()).getDefense() ? param2[_loc4_] : _loc3_;
                  }
               }
               _loc4_++;
            }
         }
         else
         {
            _loc3_ = param2[0];
         }
         return _loc3_ != null ? _loc3_ : param2[0];
      }
      
      private function getRandomCardOnBF() : FSUnit
      {
         var _loc3_:FSUnit = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:Dictionary = this.mBattleScreen.getOpponentBFSocketCatalog();
         var _loc2_:Array = DictionaryUtils.dictionaryToArray(_loc1_);
         if(Boolean(_loc2_) && _loc2_.length > 0)
         {
            _loc5_ = Utils.randomInt(0,_loc2_.length - 1);
            _loc3_ = FSCardSocket(_loc1_[_loc5_]).getParentCard() as FSUnit;
         }
         return _loc3_;
      }
      
      private function getNextAIPowerMovementIndex() : int
      {
         var _loc7_:PowerDef = null;
         var _loc8_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc1_:int = -1;
         var _loc2_:AIMovementDef = this.getNextAIMovement();
         var _loc3_:Number = _loc2_ ? _loc2_.getPowerChance() : 0;
         _loc3_ = PvPConnectionMng.isPlayingVSAI() ? 100 : _loc3_;
         _loc3_ = Config.getConfig().gameHasPowers() ? _loc3_ : 0;
         var _loc4_:int = this.mAIBattleInfo ? this.mAIBattleInfo.getActionPointsLeft() : 0;
         var _loc5_:Boolean = this.mAIBattleInfo.getLevelDef().getIAUsePowers();
         var _loc6_:String = this.getOpponentPowerSku();
         var _loc9_:Dictionary = new Dictionary(true);
         if(_loc5_ && _loc6_ != null && _loc6_ != "")
         {
            _loc7_ = PowerDef(InstanceMng.getPowerDefMng().getDefBySku(_loc6_));
            if(_loc7_)
            {
               _loc8_ = _loc7_.getSummonCost();
            }
            if(_loc8_ <= _loc4_)
            {
               _loc11_ = 0;
               while(_loc11_ < _loc3_)
               {
                  _loc9_[_loc10_] = this.MOVE_EXECUTE_POWER;
                  _loc10_++;
                  _loc11_++;
               }
            }
         }
         var _loc12_:Number = Utils.randomInt(0,99);
         return int(_loc9_[_loc12_]);
      }
      
      private function getNextAISacrificeMovementIndex() : int
      {
         var _loc5_:int = 0;
         var _loc6_:Dictionary = null;
         var _loc7_:FSCard = null;
         var _loc1_:int = this.MOVE_UNIT;
         var _loc2_:LevelDef = Boolean(InstanceMng.getBattleEngine()) && Boolean(InstanceMng.getBattleEngine().getLevelDef()) ? InstanceMng.getBattleEngine().getLevelDef() : null;
         var _loc3_:int = _loc2_ ? int(_loc2_.getRowsAmount() * _loc2_.getColumnsAmount()) : 3;
         var _loc4_:int = DictionaryUtils.getDictionaryLength(this.mAIBattleInfo.getFightCards());
         if(_loc4_ == _loc3_)
         {
            _loc5_ = this.mAIBattleInfo ? this.mAIBattleInfo.getActionPointsLeft() : 0;
            if(_loc5_ > 0)
            {
               _loc6_ = this.mAIBattleInfo.getFightCards();
               if(_loc6_)
               {
                  for each(_loc7_ in _loc6_)
                  {
                     if(_loc7_.getDamage() <= 1 || _loc7_.getDefense() == 1)
                     {
                        return this.MOVE_EXECUTE_SACRIFICE;
                     }
                  }
               }
            }
         }
         return _loc1_;
      }
      
      private function getNextAIMovement(param1:Boolean = false) : AIMovementDef
      {
         var _loc2_:LevelDef = Boolean(InstanceMng.getBattleEngine()) && Boolean(InstanceMng.getBattleEngine().getLevelDef()) ? InstanceMng.getBattleEngine().getLevelDef() : null;
         var _loc3_:int = _loc2_ ? int(_loc2_.getRowsAmount() * _loc2_.getColumnsAmount()) : 3;
         var _loc4_:int = !param1 ? DictionaryUtils.getDictionaryLength(this.mAIBattleInfo.getFightCards()) : _loc3_;
         var _loc5_:int = !param1 ? DictionaryUtils.getDictionaryLength(this.mOwnerBattleInfo.getFightCards()) : _loc3_;
         return InstanceMng.getAIMovementsDefMng().getMovementByUnitsAmounts(_loc4_,_loc5_);
      }
      
      private function getNextAIMovementIndex(param1:Boolean = false) : int
      {
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc2_:int = -1;
         var _loc3_:AIMovementDef = this.getNextAIMovement(param1);
         var _loc4_:Number = _loc3_ ? _loc3_.getActionChance() : 0;
         var _loc5_:Number = _loc3_ ? _loc3_.getAttachmentChance() : 0;
         var _loc6_:Number = _loc3_ ? _loc3_.getUpgradeChance() : 0;
         var _loc7_:Number = _loc3_ ? _loc3_.getUnitChance() : 0;
         var _loc8_:Dictionary = new Dictionary(true);
         _loc10_ = 0;
         while(_loc10_ < _loc4_)
         {
            _loc8_[_loc9_] = this.MOVE_ACTION;
            _loc9_++;
            _loc10_++;
         }
         _loc10_ = 0;
         while(_loc10_ < _loc5_)
         {
            _loc8_[_loc9_] = this.MOVE_ATTACHMENT;
            _loc9_++;
            _loc10_++;
         }
         _loc10_ = 0;
         while(_loc10_ < _loc6_)
         {
            _loc8_[_loc9_] = this.MOVE_UPGRADE_UNIT;
            _loc9_++;
            _loc10_++;
         }
         _loc10_ = 0;
         while(_loc10_ < _loc7_)
         {
            _loc8_[_loc9_] = this.MOVE_UNIT;
            _loc9_++;
            _loc10_++;
         }
         var _loc11_:Number = Utils.randomInt(0,99);
         return int(_loc8_[_loc11_]);
      }
      
      private function moveAttachment() : void
      {
         var _loc2_:FSCardSocket = null;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc1_:FSAttachment = this.selectAttachmentCard();
         if(_loc1_ != null)
         {
            _loc2_ = this.getRandomAttachableSocketForCard(_loc1_);
            if(_loc2_ != null)
            {
               _loc3_ = _loc2_.getParentCard().getCardDef().getTier();
               _loc1_.changeCardDefTemporarily(_loc3_);
               _loc4_ = InstanceMng.getBattleEngine().replayCard(_loc1_,_loc2_,false,true);
               this.mCurrentDelay = InstanceMng.getBattleEngine().getReproductionDelayTimeForCard(_loc1_) + _loc4_;
               if(this.mAIBattleInfo.getActionPointsLeft() == 0)
               {
                  TweenMax.delayedCall(this.mCurrentDelay,this.notifyAIAnimationsOver);
               }
               else
               {
                  this.mCurrentDelay += this.calculateExtraDelay();
                  TweenMax.delayedCall(this.mCurrentDelay,this.performNextStep);
               }
               return;
            }
            this.performNextStep(true);
            return;
         }
         this.performNextStep(true);
      }
      
      private function calculateExtraDelay() : Number
      {
         return PvPConnectionMng.REAL_TIME && PvPConnectionMng.REAL_TIME_RELEASED && PvPConnectionMng.smPlayingAgainstBOT ? Utils.randomInt(0,2) : 0;
      }
      
      private function moveExecuteSacrifice(param1:FSUnit) : void
      {
         var _loc2_:Boolean = this.mAIBattleInfo.getLevelDef().getIAUseSacrifice();
         var _loc3_:int = this.mAIBattleInfo.getActionPointsLeft();
         var _loc4_:int = Config.getConfig().getSacrificeCost();
         var _loc5_:Number = Config.getConfig().getSacrificeDuration();
         var _loc6_:Boolean = Config.getConfig().gameHasSacrifice();
         if(Boolean(!this.mExecuteSacrificeSuccess && _loc6_ && _loc2_ && param1 && param1.isAlive()) && Boolean(param1.isOnBF()) && this.mAIBattleInfo.isSacrificeAvailable())
         {
            if(_loc3_ >= _loc4_)
            {
               InstanceMng.getBattleEngine().getBattleScreen().createLightning();
               InstanceMng.getBattleEngine().setSacrificeWaitingForTarget(true);
               this.mCurrentDelay = Config.getConfig().getSacrificeDuration() + Config.getConfig().getDefaultDeathAnimDuration() * 2;
               param1.onSacrificeTargetSelected();
               this.mMoveUnitAlreadyDone = 0;
               this.mMoveAttachmentAlreadyDone = 0;
               this.mMoveActionAlreadyDone = 0;
               this.mMoveUpgradeAlreadyDone = 0;
               this.mMoveExecutePowerAlreadyDone = 0;
               this.mMoveExecuteSacrificeAlreadyDone = 0;
               this.mGlobalMovementsDone = 0;
               if(_loc3_ - _loc4_ == 0)
               {
                  TweenMax.delayedCall(this.mCurrentDelay,this.notifyAIAnimationsOver);
               }
               else
               {
                  this.mCurrentDelay += this.calculateExtraDelay();
                  TweenMax.delayedCall(this.mCurrentDelay,this.performNextStep);
               }
               return;
            }
            if(_loc3_ > 0)
            {
               this.performNextStep(true);
            }
         }
         else
         {
            this.performNextStep();
         }
      }
      
      private function getOpponentPowerSku() : String
      {
         return PvPConnectionMng.isPlayingVSAI() ? this.mAIBattleInfo.getPowerDefFromDeck().getSku() : this.mAIBattleInfo.getLevelDef().getPowerSku();
      }
      
      private function getOpponentPower() : FSPower
      {
         var _loc1_:FSPower = null;
         if(PvPConnectionMng.isPlayingVSAI())
         {
            _loc1_ = this.mAIBattleInfo.getPowerCardFromDeck();
         }
         else
         {
            _loc1_ = this.mAIBattleInfo.getLevelDef().getPowerSku() ? this.mBattleScreen.createAIPower(this.mAIBattleInfo.getLevelDef().getPowerSku()) : null;
         }
         return _loc1_;
      }
      
      private function moveExecutePower() : void
      {
         var _loc2_:int = 0;
         var _loc3_:Ability = null;
         var _loc4_:int = 0;
         var _loc5_:Vector.<Ability> = null;
         var _loc6_:int = 0;
         var _loc7_:Vector.<FSBattlefieldUserPortrait> = null;
         var _loc8_:Vector.<FSCardSocket> = null;
         var _loc1_:FSPower = this.getOpponentPower();
         if(_loc1_ != null)
         {
            _loc1_.setParentUserBattleInfo(this.mAIBattleInfo);
            _loc2_ = this.mAIBattleInfo.getActionPointsLeft();
            _loc5_ = _loc1_.getAbilities();
            _loc3_ = _loc5_[0];
            _loc4_ = _loc1_.getCardDef().getSummonCost();
            if(_loc2_ >= _loc4_ && _loc4_ != -1)
            {
               _loc7_ = _loc3_.getParentCard().getPlayablePortraits();
               _loc8_ = _loc3_.getParentCard().getPlayableSocketsByAbilityOnCard(_loc3_);
               if(_loc8_ != null && _loc8_.length > 0 || _loc7_ != null && _loc7_.length > 0)
               {
                  _loc1_.visible = true;
                  _loc1_.alpha = 0.999;
                  this.mCurrentDelay = InstanceMng.getBattleEngine().getReproductionDelayTimeForCard(_loc1_,false);
                  this.onActionSelected(_loc1_,_loc3_,_loc4_,this.mCurrentDelay);
                  this.mCurrentDelay = InstanceMng.getBattleEngine().getReproductionDelayTimeForCard(_loc1_,false,_loc3_.getAbilityDef().getSku()) + Config.getConfig().getDefaultDeathAnimDuration();
                  _loc1_.createDeathAnimation();
                  TweenMax.delayedCall(this.mCurrentDelay + 0.2,SpecialFX.tweenToAlpha,[_loc1_,0.001,1,0]);
                  if(_loc1_.getShadow() != null)
                  {
                     TweenMax.delayedCall(this.mCurrentDelay + 0.2,SpecialFX.tweenToAlpha,[_loc1_.getShadow(),0.001,1,0]);
                  }
                  this.mExecutePowerSuccess = true;
                  if(_loc2_ - _loc4_ == 0)
                  {
                     TweenMax.delayedCall(this.mCurrentDelay,this.notifyAIAnimationsOver);
                  }
                  else
                  {
                     this.mCurrentDelay += this.calculateExtraDelay();
                     TweenMax.delayedCall(this.mCurrentDelay,this.performNextStep);
                  }
                  return;
               }
               this.performNextStep(true);
            }
            else if(_loc2_ > 0)
            {
               this.performNextStep(true);
            }
            return;
         }
         this.performNextStep(true);
      }
      
      private function moveAction() : void
      {
         var _loc1_:FSAction = null;
         var _loc2_:int = 0;
         var _loc3_:Ability = null;
         var _loc4_:int = 0;
         var _loc5_:Vector.<Ability> = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:AbilityDef = null;
         var _loc9_:Boolean = false;
         var _loc10_:Vector.<FSBattlefieldUserPortrait> = null;
         var _loc11_:Vector.<FSCardSocket> = null;
         _loc1_ = this.selectActionCard();
         if(_loc1_ != null)
         {
            _loc2_ = this.mAIBattleInfo.getActionPointsLeft();
            _loc5_ = _loc1_.getAbilities();
            _loc7_ = Utils.randomInt(0,_loc5_.length - 1);
            _loc3_ = _loc5_[_loc7_];
            _loc4_ = ActionDef(_loc1_.getCardDef()).getUpgradeCostByAbilitySku(_loc3_.getAbilityDef().getSku());
            if(_loc5_.length == 1)
            {
               _loc8_ = null;
               if(this.mAIBattleInfo)
               {
                  _loc9_ = false;
                  if(this.mAIBattleInfo.isModifiedCostActive())
                  {
                     _loc8_ = this.mAIBattleInfo.getExtraSummonCostAbilityDef();
                     if((Boolean(_loc8_)) && _loc8_.isCardEligibleForAbility(_loc1_))
                     {
                        _loc4_ += _loc4_ + this.mAIBattleInfo.getExtraSummonCost() >= 0 ? this.mAIBattleInfo.getExtraSummonCost() : 0;
                        _loc9_ = true;
                     }
                  }
                  if(!_loc9_ && this.mAIBattleInfo.isFixedSummonCostActive())
                  {
                     _loc8_ = this.mAIBattleInfo.getFixedSummonCostAbilityDef();
                     if((Boolean(_loc8_)) && _loc8_.isCardEligibleForAbility(_loc1_))
                     {
                        _loc4_ = _loc1_.getCardSummonCost();
                     }
                  }
               }
            }
            if(_loc2_ >= _loc4_ && _loc4_ != -1)
            {
               _loc10_ = _loc3_.getParentCard().getPlayablePortraits();
               _loc11_ = _loc3_.getParentCard().getPlayableSocketsByAbilityOnCard(_loc3_);
               if(_loc11_ != null && _loc11_.length > 0 || _loc10_ != null && _loc10_.length > 0)
               {
                  _loc1_.visible = true;
                  _loc1_.alpha = 0.999;
                  this.mCurrentDelay = InstanceMng.getBattleEngine().getReproductionDelayTimeForCard(_loc1_,false);
                  this.onActionSelected(_loc1_,_loc3_,_loc4_,this.mCurrentDelay);
                  this.mCurrentDelay = InstanceMng.getBattleEngine().getReproductionDelayTimeForCard(_loc1_,false,_loc3_.getAbilityDef().getSku()) + Config.getConfig().getDefaultDeathAnimDuration();
                  if(_loc2_ - _loc4_ == 0)
                  {
                     TweenMax.delayedCall(this.mCurrentDelay,this.notifyAIAnimationsOver);
                  }
                  else
                  {
                     this.mCurrentDelay += this.calculateExtraDelay();
                     TweenMax.delayedCall(this.mCurrentDelay,this.performNextStep);
                  }
                  return;
               }
               this.performNextStep(true);
            }
            else if(_loc2_ > 0)
            {
               this.performNextStep(true);
            }
            return;
         }
         this.performNextStep(true);
      }
      
      private function onActionSelected(param1:FSCard, param2:Ability, param3:int, param4:Number) : void
      {
         param2.getParentCard().unHighlightAllPlayableItems();
         param1.touchable = false;
         this.mBattleScreen.addChild(param1);
         this.mBattleScreen.setEnemyActionBeingTriggered(param1);
         param1.scaleX = 1.5;
         param1.scaleY = 1.5;
         param1.rotationX = deg2rad(30);
         param1.rotationY = deg2rad(-180);
         SpecialFX.create3DRotation(param1,Config.getConfig().getDefaultActionMoveToCenterAnimDuration() * 2,0,0);
         var _loc5_:int = Starling.current.stage.stageWidth * 0.4;
         var _loc6_:int = _loc5_ + this.mBattleScreen.getBFWidth() / 2;
         var _loc7_:int = this.mBattleScreen.getBFHeight();
         var _loc8_:FSCoordinate = new FSCoordinate(_loc6_,_loc7_);
         param1.x = _loc6_;
         param1.y = -param1.height;
         param1.requestShowShadow(1.5,false);
         SpecialFX.createTransition(param1,_loc8_,Config.getConfig().getDefaultActionMoveToCenterAnimDuration(),0,this.addAICardToBattleScreen,[param1]);
         Utils.setLogText(param2.getAbilityDef().getDesc(),false,false,false);
         InstanceMng.getBattleEngine().setActionUpgradeCostSelected(param3);
         TweenMax.delayedCall(param4,this.onActionSelectedPerformAbilityHighlights,[param2]);
      }
      
      private function addAICardToBattleScreen(param1:FSCard) : void
      {
         if(this.mBattleScreen)
         {
            this.mBattleScreen.addChild(param1);
         }
      }
      
      private function onActionSelectedPerformAbilityHighlights(param1:Ability) : void
      {
         if(param1)
         {
            param1.highlightPossibleTargetsForAbility();
            param1.onPlayableItemsHighlighted();
         }
      }
      
      private function moveUpgrade() : void
      {
         var _loc3_:FSUnit = null;
         var _loc1_:Dictionary = this.mAIBattleInfo.getFightCards();
         var _loc2_:Boolean = false;
         if(_loc1_ != null)
         {
            _loc3_ = this.getRandomPromoteableBFCard();
            if(_loc3_ == null)
            {
               this.performNextStep(true);
               return;
            }
            _loc2_ = true;
            _loc3_.promoteCard(Utils.getNextTierCardDef(_loc3_.getCardDef().getSku()).getSku());
            this.mCurrentDelay = InstanceMng.getBattleEngine().getReproductionDelayTimeForCard(_loc3_,true);
            if(this.mAIBattleInfo.getActionPointsLeft() == 0)
            {
               TweenMax.delayedCall(this.mCurrentDelay,this.notifyAIAnimationsOver);
            }
            else
            {
               this.mCurrentDelay += this.calculateExtraDelay();
               TweenMax.delayedCall(this.mCurrentDelay,this.performNextStep);
            }
         }
         if(!_loc2_)
         {
            this.performNextStep(true);
         }
      }
      
      private function moveUnitToSocket(param1:Vector.<FSUnit> = null, param2:int = 1) : void
      {
         var _loc3_:FSUnit = null;
         var _loc4_:FSCardSocket = null;
         var _loc5_:int = 0;
         var _loc6_:AbilityDef = null;
         var _loc7_:int = 0;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc10_:Number = NaN;
         _loc3_ = this.selectUnitCard(param1);
         if(_loc3_ != null)
         {
            _loc5_ = this.mAIBattleInfo.getActionPointsLeft();
            _loc6_ = _loc3_.getCostModifierAbilityDef();
            _loc7_ = _loc3_.getCardCostByType(_loc6_);
            if(_loc5_ >= _loc7_)
            {
               _loc4_ = this.getBestEmptySocketForCard(_loc3_);
               if(_loc4_ == null)
               {
                  _loc9_ = UnitDef(_loc3_.getCardDef()).getBeginsOnAttackLane();
                  if(_loc9_)
                  {
                     if(param1 == null)
                     {
                        param1 = new Vector.<FSUnit>();
                     }
                     param1.push(_loc3_);
                     this.moveUnitToSocket(param1,param2 + 1);
                  }
                  else
                  {
                     this.performNextStep(true);
                  }
                  return;
               }
               _loc8_ = this.mBattleEngine.isCardAttachableToSocket(_loc3_,_loc4_);
               if(_loc8_)
               {
                  this.mBattleScreen.addChild(_loc3_);
                  _loc10_ = InstanceMng.getBattleEngine().replayCard(_loc3_,_loc4_,false,true);
                  this.mCurrentDelay = InstanceMng.getBattleEngine().getReproductionDelayTimeForCard(_loc3_) + _loc10_;
                  if(this.mAIBattleInfo.getActionPointsLeft() == 0)
                  {
                     TweenMax.delayedCall(this.mCurrentDelay,this.notifyAIAnimationsOver);
                  }
                  else
                  {
                     this.mCurrentDelay += this.calculateExtraDelay();
                     TweenMax.delayedCall(this.mCurrentDelay,this.performNextStep);
                  }
               }
               else
               {
                  FSDebug.debugTrace("NON-ATTACHABLE");
               }
            }
            else if(param2 >= 5)
            {
               if(_loc5_ > 0)
               {
                  this.performNextStep(true);
               }
            }
            else
            {
               if(param1 == null)
               {
                  param1 = new Vector.<FSUnit>();
               }
               param1.push(_loc3_);
               this.moveUnitToSocket(param1,param2 + 1);
            }
         }
         else
         {
            this.performNextStep(true);
         }
      }
      
      private function getEmptyAttackLaneSocket() : FSCardSocket
      {
         var _loc2_:FSCardSocket = null;
         var _loc1_:Dictionary = this.mBattleScreen.getOpponentBFSocketCatalog();
         return this.getBestSuitableEmptySocket(true);
      }
      
      private function getBFSocketByColumnIndex(param1:int, param2:Boolean, param3:Boolean) : FSCardSocket
      {
         var _loc4_:FSCardSocket = null;
         var _loc5_:FSCardSocket = null;
         var _loc6_:Dictionary = param2 ? this.mBattleScreen.getOwnerBFSocketCatalog() : this.mBattleScreen.getOpponentBFSocketCatalog();
         for each(_loc5_ in _loc6_)
         {
            if(_loc5_.getColumnIndex() == param1 && (param3 && !_loc5_.isSupportSocket() || !param3))
            {
               return _loc5_;
            }
         }
         return _loc4_;
      }
      
      private function getBestEmptySocketForCard(param1:FSUnit) : FSCardSocket
      {
         var _loc2_:FSCardSocket = null;
         var _loc3_:Boolean = false;
         var _loc4_:Vector.<FSCardSocket> = null;
         if(param1 != null)
         {
            _loc3_ = UnitDef(param1.getCardDef()).getBeginsOnAttackLane();
            if(_loc3_)
            {
               _loc2_ = this.getEmptyAttackLaneSocket();
            }
            else
            {
               _loc4_ = this.getRecommendedEmptySocketsCatalog();
               if(_loc4_ != null)
               {
                  _loc2_ = _loc4_[0];
               }
               else
               {
                  _loc2_ = this.getBestSuitableEmptySocket();
                  if(_loc2_ == null)
                  {
                     _loc2_ = this.getEmptyRandomSupportSocket();
                  }
               }
            }
         }
         return _loc2_;
      }
      
      private function getRecommendedEmptySocketsCatalog() : Vector.<FSCardSocket>
      {
         var _loc1_:Vector.<FSCardSocket> = null;
         var _loc2_:FSCardSocket = null;
         var _loc3_:FSCard = null;
         var _loc6_:int = 0;
         var _loc4_:Vector.<FSCard> = this.mOwnerBattleInfo.getFightCardsByType(FSCard.TYPE_UNIT);
         var _loc5_:int = _loc4_ ? int(_loc4_.length) : 0;
         if(_loc4_ != null)
         {
            _loc4_.sort(DictionaryUtils.sortCardsArrByValue);
         }
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc3_ = _loc4_[_loc6_];
            _loc2_ = this.getEmptySupportSocketByEnemyCard(_loc3_);
            if(_loc2_ != null)
            {
               if(_loc1_ == null)
               {
                  _loc1_ = new Vector.<FSCardSocket>();
               }
               if(!Utils.checkIfItemAlreadyExistsInCatalog(_loc2_,_loc1_))
               {
                  _loc1_.push(_loc2_);
               }
            }
            _loc6_++;
         }
         return _loc1_;
      }
      
      private function isOnExcludedVector(param1:Vector.<FSUnit>, param2:FSUnit) : Boolean
      {
         var _loc4_:int = 0;
         var _loc3_:Boolean = false;
         if(param1 != null)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.length)
            {
               if(param1[_loc4_] == param2)
               {
                  return true;
               }
               _loc4_++;
            }
         }
         return _loc3_;
      }
      
      private function getRandomPromoteableBFCard() : FSUnit
      {
         var _loc2_:FSUnit = null;
         var _loc4_:FSUnit = null;
         var _loc5_:Vector.<FSCard> = null;
         var _loc1_:Dictionary = this.mAIBattleInfo.getFightCards();
         var _loc3_:int = 0;
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_.canBePromoted())
            {
               if(_loc5_ == null)
               {
                  _loc5_ = new Vector.<FSCard>();
               }
               _loc5_.push(_loc2_);
            }
         }
         if(_loc5_ == null)
         {
            return null;
         }
         _loc5_.sort(DictionaryUtils.sortCardsArrByLowerHP);
         return FSUnit(_loc5_[0]);
      }
      
      private function selectUnitCard(param1:Vector.<FSUnit>) : FSUnit
      {
         var _loc2_:FSUnit = null;
         var _loc4_:FSCard = null;
         var _loc3_:Dictionary = this.mAIBattleInfo.getPlayableCardsCatalog();
         var _loc5_:Array = new Array();
         var _loc6_:Array = new Array();
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.isUnit() && !this.isOnExcludedVector(param1,FSUnit(_loc4_)) && !InstanceMng.getBattleEngine().existCardWithSameName(_loc4_.getCardDef()) && InstanceMng.getBattleEngine().canCardBePlayedByFaction(_loc4_.getCardDef()))
            {
               _loc5_.push(_loc4_);
            }
         }
         if(_loc5_.length > 0)
         {
            _loc5_.sort(DictionaryUtils.sortCardsArrByValue);
            _loc2_ = FSUnit(this.getRandomCardFromArrayWithSameCardValue(_loc5_));
         }
         return _loc2_;
      }
      
      private function selectActionCard() : FSAction
      {
         var _loc1_:FSAction = null;
         var _loc3_:FSCard = null;
         var _loc2_:Dictionary = this.mAIBattleInfo.getPlayableCardsCatalog();
         var _loc4_:Array = new Array();
         var _loc5_:Array = new Array();
         var _loc6_:Boolean = false;
         for each(_loc3_ in _loc2_)
         {
            _loc6_ = _loc3_ is FSAction;
            if((_loc6_) && FSAction(_loc3_).hasPlayableItems())
            {
               _loc4_.push(_loc3_);
            }
         }
         if(_loc4_.length > 0)
         {
            _loc4_.sortOn(["mCardDef"],Array.DESCENDING);
            _loc1_ = FSAction(this.getRandomCardFromArrayWithSameCardValue(_loc4_));
         }
         return _loc1_;
      }
      
      private function selectAttachmentCard() : FSAttachment
      {
         var _loc1_:FSAttachment = null;
         var _loc3_:FSCard = null;
         var _loc7_:FSCardSocket = null;
         var _loc2_:Dictionary = this.mAIBattleInfo.getPlayableCardsCatalog();
         var _loc4_:Array = new Array();
         var _loc5_:Array = new Array();
         var _loc6_:Boolean = false;
         for each(_loc3_ in _loc2_)
         {
            _loc6_ = _loc3_ is FSAttachment;
            if(_loc6_)
            {
               _loc7_ = this.getRandomAttachableSocketForCard(FSAttachment(_loc3_));
               if(_loc7_ != null)
               {
                  _loc4_.push(_loc3_);
               }
            }
         }
         if(_loc4_.length > 0)
         {
            _loc4_.sortOn(["mCardDef"],Array.DESCENDING);
            _loc1_ = FSAttachment(this.getRandomCardFromArrayWithSameCardValue(_loc4_));
         }
         return _loc1_;
      }
      
      private function getRandomAttachableSocketForCard(param1:FSAttachment) : FSCardSocket
      {
         var _loc2_:FSCardSocket = null;
         var _loc3_:FSCard = null;
         var _loc4_:FSCardSocket = null;
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         var _loc9_:Vector.<FSCard> = null;
         var _loc5_:Dictionary = this.mAIBattleInfo.getFightCards();
         var _loc6_:int = this.mAIBattleInfo.getActionPointsLeft();
         if(_loc5_ != null)
         {
            for each(_loc3_ in _loc5_)
            {
               _loc4_ = _loc3_.getAttachedToSocket();
               if(_loc4_ != null)
               {
                  _loc8_ = param1.getCardSummonCost();
                  _loc7_ = _loc6_ >= _loc8_;
                  if((_loc7_) && param1.isCardAttachableToSocket(_loc4_,false))
                  {
                     if(_loc9_ == null)
                     {
                        _loc9_ = new Vector.<FSCard>();
                     }
                     _loc9_.push(_loc4_.getParentCard());
                  }
               }
            }
            if(_loc9_ != null && _loc9_.length > 0)
            {
               _loc9_.sort(DictionaryUtils.sortCardsArrByValue);
               _loc2_ = _loc9_[0].getAttachedToSocket();
            }
         }
         return _loc2_;
      }
      
      private function getRandomCardFromArrayWithSameCardValue(param1:Array) : FSCard
      {
         var _loc2_:FSCard = null;
         var _loc4_:FSCard = null;
         var _loc5_:FSCard = null;
         var _loc6_:FSCard = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc3_:Array = new Array();
         if(param1 != null)
         {
            _loc4_ = param1[0];
            _loc3_.push(_loc4_);
            if(_loc4_ != null)
            {
               _loc7_ = 1;
               while(_loc7_ < param1.length)
               {
                  _loc5_ = param1[_loc7_];
                  if(_loc5_.getCardCostByType(_loc5_.getCostModifierAbilityDef()) == 0)
                  {
                     return _loc5_;
                  }
                  if(_loc5_.getCardDef().getCardValue() == _loc4_.getCardDef().getCardValue())
                  {
                     _loc3_.push(_loc5_);
                  }
                  _loc7_++;
               }
            }
         }
         if(_loc3_ != null)
         {
            _loc8_ = _loc3_.length > 0 ? int(_loc3_.length) : 1;
            _loc9_ = Utils.randomInt(0,_loc8_ - 1);
            _loc2_ = _loc3_[_loc9_];
         }
         return _loc2_;
      }
      
      private function getEmptyRandomSupportSocket() : FSCardSocket
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:FSCardSocket = null;
         var _loc1_:Array = this.getEmptyRandomSupportSocketsArr();
         var _loc5_:Boolean = false;
         _loc3_ = 0;
         while(_loc3_ < _loc1_.length)
         {
            if(_loc5_)
            {
               _loc3_ = 0;
               _loc5_ = false;
            }
            _loc4_ = this.getBFSocketByColumnIndex(FSCardSocket(_loc1_[_loc3_]).getColumnIndex(),false,true);
            if((Boolean(_loc4_)) && !_loc4_.isEmpty())
            {
               _loc5_ = true;
               _loc1_.splice(_loc3_,1);
            }
            _loc3_++;
         }
         return Utils.getRandomItemFromArr(_loc1_);
      }
      
      private function getEmptyRandomSupportSocketsArr() : Array
      {
         var _loc1_:FSCardSocket = null;
         var _loc2_:Dictionary = this.mBattleScreen.getOpponentBFSocketCatalog();
         var _loc3_:Array = new Array();
         for each(_loc1_ in _loc2_)
         {
            if(_loc1_.isEmpty() && _loc1_.isSupportSocket())
            {
               _loc3_.push(_loc1_);
            }
         }
         return _loc3_;
      }
      
      private function getBestColumnIndicesToPlaceCard(param1:Dictionary, param2:Boolean, param3:int, param4:Array, param5:Boolean) : int
      {
         var _loc6_:FSCardSocket = null;
         if(param1)
         {
            for each(_loc6_ in param1)
            {
               if(param2)
               {
                  if(!_loc6_.isEmpty())
                  {
                     if(_loc6_.getParentCard().getCardDef().getCardValue() > param3)
                     {
                        param3 = _loc6_.getColumnIndex();
                     }
                     param4.push(_loc6_.getColumnIndex());
                  }
               }
               else if(param5)
               {
                  if(!_loc6_.isSupportSocket())
                  {
                     param4.push(_loc6_.getColumnIndex());
                  }
               }
               else
               {
                  param4.push(_loc6_.getColumnIndex());
               }
            }
         }
         return param3;
      }
      
      private function getBestSuitableEmptySocket(param1:Boolean = false) : FSCardSocket
      {
         var _loc2_:FSCardSocket = null;
         var _loc4_:FSCardSocket = null;
         var _loc7_:int = 0;
         var _loc3_:Dictionary = this.mBattleScreen ? this.mBattleScreen.getOwnerBFSocketCatalog() : null;
         var _loc5_:Array = new Array();
         var _loc6_:int = -1;
         _loc6_ = this.getBestColumnIndicesToPlaceCard(_loc3_,true,_loc6_,_loc5_,param1);
         if(_loc6_ == -1)
         {
            _loc6_ = this.getBestColumnIndicesToPlaceCard(_loc3_,false,_loc6_,_loc5_,param1);
         }
         if(_loc5_ != null && _loc5_.length > 0 && _loc6_ != -1)
         {
            _loc2_ = this.getBFSocketByColumnIndex(_loc6_,false,param1);
            if(_loc2_ != null && _loc2_.isEmpty() && (!param1 || param1 && !_loc2_.isSupportSocket()))
            {
               return _loc2_;
            }
            if(_loc5_ != null && _loc5_.length > 0)
            {
               _loc5_.sort(Utils.randomize);
               _loc7_ = 0;
               while(_loc7_ < _loc5_.length)
               {
                  _loc2_ = this.getBFSocketByColumnIndex(_loc5_[_loc7_],false,param1);
                  if(_loc2_ != null && _loc2_.isEmpty())
                  {
                     return _loc2_;
                  }
                  _loc7_++;
               }
               _loc2_ = null;
            }
            if(_loc2_ == null)
            {
               _loc2_ = Utils.getRandomItemFromArr(this.getEmptyRandomSupportSocketsArr());
            }
         }
         else if(Boolean(_loc5_) && _loc5_.length > 0)
         {
            _loc2_ = this.getBFSocketByColumnIndex(int(Utils.getRandomItemFromArr(_loc5_)),false,param1);
            if(_loc2_ != null && _loc2_.isEmpty())
            {
               return _loc2_;
            }
            _loc2_ = Utils.getRandomItemFromArr(this.getEmptyRandomSupportSocketsArr());
         }
         else if(!param1)
         {
            _loc2_ = Utils.getRandomItemFromArr(this.getEmptyRandomSupportSocketsArr());
         }
         return _loc2_;
      }
      
      public function getEmptySupportSocketByEnemyCard(param1:FSCard) : FSCardSocket
      {
         var _loc3_:FSCoordinate = null;
         var _loc4_:FSCardSocket = null;
         var _loc6_:FSCardSocket = null;
         var _loc2_:FSCardSocket = null;
         var _loc5_:Dictionary = this.mBattleScreen ? this.mBattleScreen.getOpponentBFSocketCatalog() : null;
         if(param1 != null)
         {
            _loc3_ = param1.getAttachedToSocket() ? param1.getAttachedToSocket().getBFCoords() : null;
            if(_loc5_)
            {
               for each(_loc4_ in _loc5_)
               {
                  if(_loc4_.getBFCoords().isInSameCol(_loc3_))
                  {
                     if(_loc4_.isSupportSocket() && _loc4_.isEmpty())
                     {
                        if(!PvPConnectionMng.isPlayingVSAI())
                        {
                           return _loc4_;
                        }
                        _loc6_ = this.getBFSocketByColumnIndex(_loc4_.getColumnIndex(),false,true);
                        if((Boolean(_loc6_)) && _loc6_.isEmpty())
                        {
                           return _loc4_;
                        }
                     }
                  }
               }
            }
         }
         return _loc2_;
      }
      
      public function setAbilityWaitingForTarget(param1:Ability, param2:Vector.<FSCardSocket>, param3:Vector.<UserBattleInfo>) : void
      {
         var eligibleItem:Array = null;
         var originalPlayableSockets:Vector.<FSCardSocket> = null;
         var playableSocketsLength:int = 0;
         var playableUserBattleInfoLength:int = 0;
         var indexSocket:int = 0;
         var indexUserInfo:int = 0;
         var randomSelection:int = 0;
         var socket:FSCardSocket = null;
         var abWaitingForTarget:Ability = param1;
         var playableSocketsVector:Vector.<FSCardSocket> = param2;
         var playableUserBattleInfoVector:Vector.<UserBattleInfo> = param3;
         var willTheOpponentDie:Function = function():Boolean
         {
            var _loc1_:int = 0;
            var _loc2_:int = 0;
            var _loc3_:int = 0;
            if(playableUserBattleInfoVector != null && playableUserBattleInfoVector.length > 0)
            {
               _loc2_ = abWaitingForTarget.getAbilityDef().getHeal();
               _loc3_ = 0;
               while(_loc3_ < playableUserBattleInfoVector.length)
               {
                  if(playableUserBattleInfoVector[_loc3_].isOwnerBattleInfo())
                  {
                     _loc1_ = playableUserBattleInfoVector[_loc3_].getHP();
                     return _loc1_ + _loc2_ <= 0;
                  }
                  _loc3_++;
               }
            }
            return false;
         };
         var willAnyCardDie:Function = function():Boolean
         {
            var _loc1_:FSCard = null;
            var _loc2_:int = 0;
            var _loc3_:int = 0;
            var _loc4_:Boolean = false;
            var _loc5_:int = 0;
            if(playableSocketsVector != null && playableSocketsVector.length > 0)
            {
               _loc2_ = abWaitingForTarget.getAbilityDef().getHeal();
               _loc3_ = abWaitingForTarget.getAbilityDef().getDefense();
               _loc5_ = 0;
               while(_loc5_ < playableSocketsVector.length)
               {
                  _loc1_ = playableSocketsVector[_loc5_].getParentCard();
                  if(_loc1_)
                  {
                     _loc3_ = playableSocketsVector[_loc5_].getParentCard().getDefense();
                     _loc4_ = _loc3_ < 0 ? _loc1_.getDefense() + _loc3_ <= 0 : _loc1_.getDefense() + _loc2_ <= 0;
                     if(_loc4_)
                     {
                        return true;
                     }
                  }
                  _loc5_++;
               }
            }
            return false;
         };
         if(abWaitingForTarget != null)
         {
            eligibleItem = new Array();
            originalPlayableSockets = new Vector.<FSCardSocket>();
            originalPlayableSockets = playableSocketsVector ? originalPlayableSockets.concat(playableSocketsVector) : null;
            playableSocketsLength = playableSocketsVector != null ? int(playableSocketsVector.length) : 0;
            playableUserBattleInfoLength = playableUserBattleInfoVector != null ? int(playableUserBattleInfoVector.length) : 0;
            indexSocket = -1;
            indexUserInfo = -1;
            if(playableSocketsLength > 0)
            {
               indexSocket = Utils.randomInt(0,playableSocketsLength - 1);
            }
            if(playableUserBattleInfoLength > 0)
            {
               indexUserInfo = Utils.randomInt(0,playableUserBattleInfoLength - 1);
            }
            randomSelection = indexSocket != -1 && indexUserInfo != -1 ? Utils.randomInt(0,1) : (indexSocket != -1 ? 0 : 1);
            if(indexSocket != -1 && indexUserInfo != -1)
            {
               randomSelection = willTheOpponentDie() ? 1 : 0;
            }
            switch(randomSelection)
            {
               case 0:
                  playableSocketsVector = this.filterPlayableSockets(abWaitingForTarget,playableSocketsVector);
                  if(playableSocketsVector == null || Boolean(playableSocketsVector) && Boolean(playableSocketsVector.length == 0))
                  {
                     if(playableUserBattleInfoLength > 0)
                     {
                        randomSelection = 1;
                        if(playableUserBattleInfoVector)
                        {
                           eligibleItem.push(playableUserBattleInfoVector[indexUserInfo]);
                        }
                     }
                     else
                     {
                        playableSocketsVector = this.filterPlayableSockets(abWaitingForTarget,originalPlayableSockets,true);
                     }
                  }
                  if(InstanceMng.getAbilitiesMng().abilityAffectsMultipleTargets(abWaitingForTarget))
                  {
                     for each(socket in playableSocketsVector)
                     {
                        eligibleItem.push(socket.getParentCard());
                     }
                  }
                  else if(Boolean(playableSocketsVector) && playableSocketsVector.length > 0)
                  {
                     if(PvPConnectionMng.isPlayingVSAI() && abWaitingForTarget != null && abWaitingForTarget.getParentCard() != null && abWaitingForTarget.getParentCard() is FSPower)
                     {
                        eligibleItem.push(this.getPowerSocketTarget(abWaitingForTarget,playableSocketsVector).getParentCard());
                     }
                     else
                     {
                        eligibleItem.push(playableSocketsVector[0].getParentCard());
                     }
                  }
                  break;
               case 1:
                  if(playableUserBattleInfoVector)
                  {
                     eligibleItem.push(playableUserBattleInfoVector[indexUserInfo]);
                  }
            }
            if(eligibleItem.length == 0)
            {
               FSDebug.debugTrace("NO ITEMS TO USE");
            }
            abWaitingForTarget.onTargetSelected(eligibleItem);
         }
      }
      
      private function filterPlayableSockets(param1:Ability, param2:Vector.<FSCardSocket>, param3:Boolean = false) : Vector.<FSCardSocket>
      {
         var arr:Array = null;
         var i:int = 0;
         var cardSocket:FSCardSocket = null;
         var card:FSCard = null;
         var targetTierIndex:int = 0;
         var abDef:AbilityDef = null;
         var keyName:String = null;
         var def:int = 0;
         var heal:int = 0;
         var isDestroy:Boolean = false;
         var someCardWillDie:Boolean = false;
         var affectsCardHealth:Boolean = false;
         var affectsItems:Boolean = false;
         var hasRising:Boolean = false;
         var cardWillDie:Boolean = false;
         var hasAttachments:Boolean = false;
         var ab:Ability = param1;
         var playableSockets:Vector.<FSCardSocket> = param2;
         var ignoreFilters:Boolean = param3;
         var pushCard:Function = function(param1:FSCard):void
         {
            if(arr == null)
            {
               arr = new Array();
            }
            arr.push(param1);
         };
         var returnValue:Vector.<FSCardSocket> = null;
         if(playableSockets != null)
         {
            abDef = ab.getAbilityDef();
            keyName = abDef.getKeyName();
            def = abDef.getDefense();
            heal = abDef.getHeal();
            isDestroy = abDef.getDestroy();
            someCardWillDie = false;
            affectsCardHealth = isDestroy || def < 0 || heal < 0;
            affectsItems = keyName == AbilitiesMng.SPECIAL_SABOTAGE;
            for each(cardSocket in playableSockets)
            {
               if(cardSocket != null)
               {
                  card = cardSocket.getParentCard();
                  if(card != null)
                  {
                     targetTierIndex = abDef.getTargetTierIndex();
                     if(targetTierIndex == 0 || targetTierIndex == card.getCardDef().getTier())
                     {
                        if(ignoreFilters)
                        {
                           pushCard(card);
                        }
                        else
                        {
                           if(affectsCardHealth)
                           {
                              hasRising = FSUnit(card).getInvulnerableTurns() > 0;
                              if(!hasRising && !someCardWillDie)
                              {
                                 cardWillDie = def < 0 ? card.getDefense() + def <= 0 : card.getDefense() + heal <= 0;
                                 if(cardWillDie)
                                 {
                                    someCardWillDie = true;
                                    if(arr != null)
                                    {
                                       arr.length = 0;
                                    }
                                    pushCard(card);
                                 }
                                 else
                                 {
                                    pushCard(card);
                                 }
                              }
                           }
                           if(affectsItems)
                           {
                              hasAttachments = FSUnit(card).hasAttachments();
                              if(hasAttachments)
                              {
                                 pushCard(card);
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
         if(arr != null)
         {
            if(affectsCardHealth)
            {
               if(isDestroy)
               {
                  arr.sort(DictionaryUtils.sortCardsArrByDefense);
               }
               else
               {
                  arr.sort(DictionaryUtils.sortCardsArrByAbilityPower);
               }
            }
            else if(keyName == AbilitiesMng.SPECIAL_SPY || keyName == AbilitiesMng.SPECIAL_MASSSPY || keyName == AbilitiesMng.SPECIAL_UNITSPY)
            {
               arr.sort(DictionaryUtils.sortCardsArrByAbilitiesAmount);
            }
            else
            {
               arr.sort(DictionaryUtils.sortCardsArrByValue);
            }
            i = 0;
            while(i < arr.length)
            {
               if(returnValue == null)
               {
                  returnValue = new Vector.<FSCardSocket>();
               }
               returnValue.push(FSCard(arr[i]).getAttachedToSocket());
               i++;
            }
         }
         return returnValue;
      }
      
      public function notifyAIAnimationsOver() : void
      {
         if(this.mBattleEngine)
         {
            this.mBattleEngine.changePlayersState();
            this.mMoveUnitAlreadyDone = 0;
            this.mMoveAttachmentAlreadyDone = 0;
            this.mMoveActionAlreadyDone = 0;
            this.mMoveUpgradeAlreadyDone = 0;
            this.mMoveExecutePowerAlreadyDone = 0;
            this.mMoveExecuteSacrificeAlreadyDone = 0;
            this.mGlobalMovementsDone = 0;
            this.mExecutePowerSuccess = false;
            this.mExecuteSacrificeSuccess = false;
         }
      }
      
      public function getAIBattleInfo() : UserBattleInfo
      {
         return this.mAIBattleInfo;
      }
      
      public function unload() : void
      {
         this.mBattleScreen = null;
         this.mBattleEngine = null;
         this.mOwnerBattleInfo = null;
         this.mAIBattleInfo = null;
      }
      
      public function destroy() : void
      {
         this.unload();
      }
   }
}

