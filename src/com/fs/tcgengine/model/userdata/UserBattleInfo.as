package com.fs.tcgengine.model.userdata
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.AbilitiesMng;
   import com.fs.tcgengine.controller.PvPConnectionMng;
   import com.fs.tcgengine.controller.QuestsMng;
   import com.fs.tcgengine.controller.RaidsMng;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.controller.rules.CategoriesDefMng;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.board.card.Ability;
   import com.fs.tcgengine.model.rules.AbilityDef;
   import com.fs.tcgengine.model.rules.ActionDef;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.CategoryDef;
   import com.fs.tcgengine.model.rules.DungeonLevelDef;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.model.rules.PassiveAbilityDef;
   import com.fs.tcgengine.model.rules.PowerDef;
   import com.fs.tcgengine.model.rules.RaidDef;
   import com.fs.tcgengine.model.rules.RaidLevelDef;
   import com.fs.tcgengine.model.rules.UnitDef;
   import com.fs.tcgengine.particles.TextParticlesMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSAction;
   import com.fs.tcgengine.view.cards.FSAttachment;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.FSCardPreview;
   import com.fs.tcgengine.view.cards.FSPower;
   import com.fs.tcgengine.view.cards.FSUnit;
   import com.fs.tcgengine.view.components.battle.ActionPointsCounter;
   import com.fs.tcgengine.view.components.battle.FSAttackButton;
   import com.fs.tcgengine.view.components.battle.FSBattlefieldUserPortrait;
   import com.fs.tcgengine.view.components.battle.PlayerHPViewer;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import flash.system.Capabilities;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import starling.core.Starling;
   import starling.display.MovieClip;
   import starling.utils.Align;
   
   public class UserBattleInfo implements FSModelUnloadableInterface
   {
      
      protected var mUserData:UserData;
      
      private var mDeck:Dictionary;
      
      private var mGraveyard:Array;
      
      private var mDeckArray:Array;
      
      protected var mFightCards:Dictionary;
      
      private var mPlayableCardsCatalog:Dictionary;
      
      private var mPlayableCardsAmountInTurn:int = 0;
      
      public var mHP:FSNumber;
      
      protected var mActionPointsLeft:FSNumber;
      
      protected var mLevelDef:LevelDef;
      
      private var mUserBattlePortrait:FSBattlefieldUserPortrait;
      
      private var mBattleEngine:BattleEngine;
      
      protected var mDealCardsAttempts:int = 0;
      
      protected var mNextTurnExtraActionPoints:int;
      
      protected var mTurnsInvulnerable:int = 0;
      
      private var mInvulnerableIcon:FSImage;
      
      private var mInvulnerableMC:MovieClip;
      
      protected var mTurnsPoison:int = 0;
      
      protected var mPoisonDamage:int = 0;
      
      private var mPoisonIcon:FSImage;
      
      private var mIsOnlineMatch:Boolean;
      
      private var mSacrificeAvailable:Boolean;
      
      private var mPowerAvailable:Boolean;
      
      private var mPower:FSPower;
      
      private var mPowerSku:String;
      
      private var mCumulativeDamage:int = 0;
      
      private var mCumulativeDamageCurrentBattle:int = 0;
      
      protected var mTurnsModifySummonCost:int = 0;
      
      protected var mModifySummonCost:int = 0;
      
      protected var mModifySummonCostAbDef:AbilityDef;
      
      protected var mApplyCostModifierAbilityOnNextCard:Boolean = false;
      
      protected var mFixedSummonCost:int = 0;
      
      protected var mTurnsFixedSummonCost:int = 0;
      
      protected var mFixedSummonCostAbDef:AbilityDef;
      
      protected var mModifySummonCostParentCard:FSCard;
      
      protected var mFixedSummonCostParentCard:FSCard;
      
      protected var mEmblemDictionary:Dictionary;
      
      private var mIsWaitingForUpdateRaidBattlesACK:Boolean = false;
      
      private var mAPGenerated:int;
      
      private var mHasDiscarded:Boolean = false;
      
      private var mDeckFactions:Dictionary;
      
      public function UserBattleInfo(param1:Boolean, param2:String, param3:Boolean = false)
      {
         super();
         this.init(param1,param2,param3);
      }
      
      protected function init(param1:Boolean, param2:String, param3:Boolean = false) : void
      {
         var _loc6_:LevelDef = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(param1)
         {
            this.mUserData = Utils.getOwnerUserData();
         }
         this.mEmblemDictionary = new Dictionary(true);
         var _loc4_:Boolean = Boolean(Root.smBattleData.isDungeon);
         var _loc5_:Boolean = Boolean(Root.smBattleData.isRaid);
         if(_loc4_)
         {
            _loc6_ = DungeonLevelDef(InstanceMng.getDungeonLevelsDefMng().getDefBySku(param2));
         }
         else if(_loc5_)
         {
            _loc6_ = RaidLevelDef(InstanceMng.getRaidLevelsDefMng().getDefBySku(param2));
         }
         else
         {
            _loc6_ = LevelDef(InstanceMng.getLevelsDefMng().getDefBySku(param2));
         }
         this.setLevelDef(_loc6_);
         if(this.mLevelDef != null)
         {
            if(this.isOwnerBattleInfo())
            {
               if(!_loc4_ || _loc4_ && InstanceMng.getDungeonsMng().ownerHasToReadHP())
               {
                  this.setHP(this.mLevelDef.getHPEncripted());
               }
               else
               {
                  this.setHP(new FSNumber(InstanceMng.getDungeonsMng().getLastPlayerHP()));
               }
            }
            else
            {
               this.setHP(this.mLevelDef.getAIHPEncripted());
            }
            _loc7_ = this.isOwnerBattleInfo() ? this.mLevelDef.getActionPointsPerTurn() : this.mLevelDef.getAIActionPointsPerTurn();
            _loc8_ = this.getAPGenerated();
            _loc7_ += _loc8_;
            this.setActionPointsLeft(_loc7_);
            this.fillCards();
            this.mFightCards = new Dictionary(true);
            return;
         }
         throw new Error("Level Definition NOT FOUND!");
      }
      
      public function resetActionPoints() : void
      {
         var _loc1_:int = this.isOwnerBattleInfo() ? this.mLevelDef.getActionPointsPerTurn() : this.mLevelDef.getAIActionPointsPerTurn();
         var _loc2_:int = this.getAPGenerated();
         _loc1_ += _loc2_;
         _loc1_ = _loc1_ + this.mNextTurnExtraActionPoints > 0 ? int(_loc1_ + this.mNextTurnExtraActionPoints) : 0;
         var _loc3_:FSAttackButton = this.mBattleEngine.getBattleScreen().getAttackButton();
         if(_loc3_ != null)
         {
            _loc3_.updateVisualHighlights(true);
         }
         var _loc4_:BattleEngine = InstanceMng.getBattleEngine();
         var _loc5_:int = _loc4_.getCurrentTurnId();
         if(_loc4_.isPvPMatch())
         {
            if(_loc4_.getOwnerMovesFirst().value == 1 && _loc4_.isOwnerTurn() && _loc5_ == 1 || !_loc4_.getOwnerMovesFirst().value == 1 && !_loc4_.isOwnerTurn() && _loc5_ == 0)
            {
               _loc1_ -= Config.getConfig().getPVPActionPointsLessFor1Player();
               if(Config.getConfig().gameHasClassSystem())
               {
                  this.increaseAPGenerated(-Config.getConfig().getPVPActionPointsLessFor1Player());
               }
               Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_PVP_ACTIONPOINTS"),[Config.getConfig().getPVPActionPointsLessFor1Player()]));
            }
         }
         this.setActionPointsLeft(_loc1_);
         this.mNextTurnExtraActionPoints = 0;
      }
      
      public function updateCardsTurnsToAttack() : void
      {
         var _loc1_:FSUnit = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         for each(_loc1_ in this.mFightCards)
         {
            _loc2_ = _loc1_.getTurnsToBeAbleToAttack();
            _loc3_ = _loc2_ > 0 ? int(_loc2_ - 1) : 0;
            _loc1_.setTurnsToBeAbleToAttack(_loc3_);
         }
      }
      
      public function updateExtraSummonCostTurns() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         _loc1_ = this.getExtraSummonCostTurns();
         _loc3_ = _loc1_ == -1;
         if(!_loc3_)
         {
            _loc2_ = _loc1_ > 0 ? int(_loc1_ - 1) : 0;
         }
         else
         {
            _loc2_ = -1;
         }
         this.setModifySummonCostTurns(_loc2_);
      }
      
      public function updateFixedSummonCostTurns() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         _loc1_ = this.getTurnsFixedSummonCost();
         _loc3_ = _loc1_ == -1;
         if(!_loc3_)
         {
            _loc2_ = _loc1_ > 0 ? int(_loc1_ - 1) : 0;
         }
         else
         {
            _loc2_ = -1;
         }
         this.setTurnsFixedSummonCost(_loc2_);
      }
      
      public function updatePoisonTurns() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:FSUnit = null;
         for each(_loc3_ in this.mFightCards)
         {
            _loc1_ = _loc3_.getPoisonTurns();
            _loc2_ = _loc1_ > 0 ? int(_loc1_ - 1) : 0;
            _loc3_.setPoisonTurns(_loc2_);
         }
         _loc1_ = this.getPoisonTurns();
         _loc2_ = _loc1_ > 0 ? int(_loc1_ - 1) : 0;
         this.setPoisonTurns(_loc2_);
      }
      
      public function updateInvulnerabilityTurns() : void
      {
         var _loc1_:FSUnit = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         for each(_loc1_ in this.mFightCards)
         {
            _loc3_ = _loc1_.getInvulnerableTurns();
            _loc2_ = _loc3_ > 0 ? int(_loc3_ - 1) : 0;
            _loc1_.setInvulnerableTurns(_loc2_);
         }
         _loc3_ = this.getInvulnerableTurns();
         _loc2_ = _loc3_ > 0 ? int(_loc3_ - 1) : 0;
         this.setInvulnerableTurns(_loc2_);
      }
      
      public function updateUnblockableTurns() : void
      {
         var _loc1_:FSUnit = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         for each(_loc1_ in this.mFightCards)
         {
            _loc3_ = _loc1_.getUnblockableTurns();
            _loc4_ = _loc3_ == -1;
            if(!_loc4_)
            {
               _loc2_ = _loc3_ > 0 ? int(_loc3_ - 1) : 0;
               _loc1_.setUnblockableTurns(_loc2_);
            }
            else if(_loc4_ && _loc1_.getUnblockableIcon() != null)
            {
               _loc1_.setUnblockableTurns(-1);
            }
         }
      }
      
      public function getExtraSummonCostTurns() : int
      {
         return this.mTurnsModifySummonCost;
      }
      
      public function getTurnsFixedSummonCost() : int
      {
         return this.mTurnsFixedSummonCost;
      }
      
      public function setModifySummonCostAbilityDef(param1:AbilityDef) : void
      {
         this.mModifySummonCostAbDef = param1;
      }
      
      public function getExtraSummonCostAbilityDef() : AbilityDef
      {
         return this.mModifySummonCostAbDef;
      }
      
      public function setTurnsFixedSummonCost(param1:int) : void
      {
         this.mTurnsFixedSummonCost = param1;
         if(this.mTurnsFixedSummonCost == 0)
         {
            this.setFixedSummonCostAbilityDef(null);
         }
      }
      
      public function isFixedSummonCostActive() : Boolean
      {
         return this.mTurnsFixedSummonCost != 0;
      }
      
      public function isModifiedCostActive() : Boolean
      {
         return this.mTurnsModifySummonCost != 0;
      }
      
      public function setFixedSummonCostAbilityDef(param1:AbilityDef) : void
      {
         this.mFixedSummonCostAbDef = param1;
      }
      
      public function getFixedSummonCostAbilityDef() : AbilityDef
      {
         return this.mFixedSummonCostAbDef;
      }
      
      public function setModifySummonCostParentCard(param1:FSCard) : void
      {
         this.mModifySummonCostParentCard = param1;
      }
      
      public function getModifySummonCostParentCard() : FSCard
      {
         return this.mModifySummonCostParentCard;
      }
      
      public function setFixedSummonCostParentCard(param1:FSCard) : void
      {
         this.mFixedSummonCostParentCard = param1;
      }
      
      public function getFixedSummonCostParentCard() : FSCard
      {
         return this.mFixedSummonCostParentCard;
      }
      
      public function setModifySummonCostTurns(param1:int) : void
      {
         this.mTurnsModifySummonCost = param1;
         if(this.mTurnsModifySummonCost == 0)
         {
            this.setModifySummonCostAbilityDef(null);
         }
      }
      
      public function setExtraSummonCost(param1:int) : void
      {
         this.mModifySummonCost = param1;
      }
      
      public function getExtraSummonCost() : int
      {
         return this.mModifySummonCost;
      }
      
      public function getFixedSummonCost() : int
      {
         return this.mFixedSummonCost;
      }
      
      public function setFixedSummonCost(param1:int) : void
      {
         this.mFixedSummonCost = param1;
      }
      
      public function getPoisonTurns() : int
      {
         return this.mTurnsPoison;
      }
      
      public function setPoisonTurns(param1:int) : void
      {
         if(this.mTurnsPoison == 1 && param1 == 0)
         {
            this.mUserBattlePortrait.removeCardAnimsByAbility(AbilitiesMng.SPECIAL_POISON,true);
         }
         this.mTurnsPoison = param1;
         if(this.mTurnsPoison == 0)
         {
            if(this.mPoisonIcon != null)
            {
               SpecialFX.tweenToAlpha(this.mPoisonIcon,0.001,2.5,0,this.onPoisonIconFaded);
            }
         }
      }
      
      public function setPoisonDamage(param1:int) : void
      {
         this.mPoisonDamage = param1;
      }
      
      public function getPoisonDamage() : int
      {
         return this.mPoisonDamage;
      }
      
      public function setPoisonIcon(param1:FSImage) : void
      {
         if(this.mPoisonIcon == null)
         {
            this.mPoisonIcon = param1;
         }
      }
      
      private function onPoisonIconFaded() : void
      {
         if(this.mPoisonIcon)
         {
            this.mPoisonIcon.removeFromParent();
            TweenMax.killTweensOf(this.mPoisonIcon);
         }
         this.mPoisonIcon = null;
         this.mPoisonDamage = 0;
      }
      
      public function takeDOTDamage() : void
      {
         this.modifyHP(new FSNumber(this.mPoisonDamage),true);
      }
      
      public function getInvulnerableTurns() : int
      {
         return this.mTurnsInvulnerable;
      }
      
      public function setInvulnerableTurns(param1:int) : void
      {
         this.mTurnsInvulnerable = param1;
         if(this.mTurnsInvulnerable == 0)
         {
            if(this.mInvulnerableIcon != null)
            {
               SpecialFX.tweenToAlpha(this.mInvulnerableIcon,0.001,2.5,0,this.onInvulnerabilityIconFaded);
            }
            else if(this.mInvulnerableMC)
            {
               this.mInvulnerableMC.stop();
               Starling.juggler.remove(this.mInvulnerableMC);
               this.mInvulnerableMC.removeFromParent();
               this.mInvulnerableMC = null;
            }
         }
      }
      
      private function onInvulnerabilityIconFaded() : void
      {
         if(this.mInvulnerableIcon)
         {
            this.mInvulnerableIcon.removeFromParent();
            TweenMax.killTweensOf(this.mInvulnerableIcon);
         }
         this.mInvulnerableIcon = null;
      }
      
      public function setInvulnerableIcon(param1:FSImage) : void
      {
         if(this.mInvulnerableIcon == null)
         {
            this.mInvulnerableIcon = param1;
         }
      }
      
      public function setInvulnerableMC(param1:MovieClip) : void
      {
         if(this.mInvulnerableMC == null)
         {
            this.mInvulnerableMC = param1;
         }
      }
      
      public function showAbilityBeingAppliedIcon(param1:Ability) : void
      {
         var _loc3_:FSImage = null;
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         var _loc2_:Boolean = !(param1.getAbilityDef().getAnimKey() == null || param1.getAbilityDef().getAnimKey() == "");
         if(param1 != null && !_loc2_)
         {
            _loc3_ = new FSImage(Root.assets.getTexture(param1.getAbilityDef().getBGXLImageName()));
            if(_loc3_ != null)
            {
               _loc4_ = InstanceMng.getAbilitiesMng().isPersistentAbilityIcon(param1);
               if(_loc4_)
               {
                  _loc3_.alignPivot();
                  _loc3_.x = this.mUserBattlePortrait.width / 2;
                  _loc3_.y = this.mUserBattlePortrait.height / 2;
                  this.mUserBattlePortrait.addChild(_loc3_);
               }
               else
               {
                  _loc3_.scaleX *= 2;
                  _loc3_.scaleY *= 2;
                  _loc3_.x = this.mUserBattlePortrait.width / 2 - _loc3_.width / 2;
                  _loc3_.y = this.mUserBattlePortrait.height / 2 - _loc3_.height / 2;
                  this.mUserBattlePortrait.addChild(_loc3_);
               }
               if(!_loc4_)
               {
                  SpecialFX.tweenToAlpha(_loc3_,0.001,2.5,0,Utils.removeImageFromParent,[_loc3_]);
               }
               else
               {
                  _loc5_ = param1.getAbilityDef().getKeyName();
                  switch(_loc5_)
                  {
                     case AbilitiesMng.SPECIAL_MASSIVERISING:
                        this.setInvulnerableIcon(_loc3_);
                        break;
                     case AbilitiesMng.SPECIAL_MASSPOISON:
                        this.setPoisonIcon(_loc3_);
                  }
               }
            }
         }
      }
      
      protected function fillCards() : void
      {
         if(this.isOwnerBattleInfo())
         {
            this.fillOwnerCards();
         }
         else
         {
            this.fillAICards();
         }
      }
      
      protected function fillOwnerCards() : void
      {
         var _loc1_:Dictionary = null;
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         if(this.mLevelDef.areDefaultCardsDefined())
         {
            _loc1_ = this.mLevelDef.getPlayerCards();
            if(Config.getConfig().gameHasPowers())
            {
               this.mPowerSku = this.mLevelDef.getPowerSku();
            }
            _loc2_ = Boolean(Root.smBattleData.isDungeon);
            if(!_loc2_)
            {
               this.mUserData.importDeck(DictionaryUtils.createCatalogCopy(_loc1_),UserData.getTutorialDeckIndex());
               this.fillDeck(this.mUserData.getDeck(UserData.getTutorialDeckIndex()));
            }
            else
            {
               this.fillDeck(_loc1_);
            }
         }
         else
         {
            _loc3_ = this is UserBattleInfoPvP ? this.mUserData.getSelectedDeckIndexPvP() : this.mUserData.getSelectedDeckIndex();
            this.fillDeck(this.mUserData.getDeck(_loc3_));
         }
      }
      
      protected function fillAICards() : void
      {
         var _loc2_:Dictionary = null;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         if(Config.getConfig().gameHasPowers())
         {
            this.mPowerSku = this.mLevelDef.getIAPowerSku();
         }
         var _loc1_:UserData = Utils.getOwnerUserData();
         if(_loc1_)
         {
            _loc3_ = _loc1_.getLevelsFailedInfoByLevelSku(this.mLevelDef.getSku());
            _loc4_ = _loc3_ >= Config.PVE_MIN_LEVEL_ATTEMPTS_TO_TRIGGER_EASY && Utils.randomInt(0,9) < Config.PVE_MIN_EASY_RANDOM_CHANCE;
            if(Root.smBattleData)
            {
               _loc7_ = Boolean(Root.smBattleData.isDungeon);
               _loc8_ = Boolean(Root.smBattleData.isRaid);
               _loc9_ = InstanceMng.getBattleEngine() ? InstanceMng.getBattleEngine().isPvPMatch() : false;
               if(!_loc7_ && !_loc8_ && !_loc9_)
               {
                  Root.smBattleData.easyMode = _loc4_;
               }
               else
               {
                  Root.smBattleData.easyMode = false;
               }
            }
            _loc5_ = this.mLevelDef.getMapWorldParentIndex();
            _loc6_ = InstanceMng.getUserDataMng().getOwnerUserData().getMapWorldChoice(_loc6_);
            _loc2_ = _loc4_ ? this.mLevelDef.getAIEasyUnits(_loc6_) : this.mLevelDef.getAIUnits(_loc6_);
            _loc2_ = _loc4_ && _loc2_ != null && DictionaryUtils.getDictionaryLength(_loc2_) > 0 ? _loc2_ : this.mLevelDef.getAIUnits(_loc6_);
            this.fillDeck(_loc2_);
            _loc2_ = _loc4_ ? this.mLevelDef.getAIEasyAttachments(_loc6_) : this.mLevelDef.getAIAttachments(_loc6_);
            _loc2_ = _loc4_ && _loc2_ != null && DictionaryUtils.getDictionaryLength(_loc2_) > 0 ? _loc2_ : this.mLevelDef.getAIAttachments(_loc6_);
            this.fillDeck(_loc2_);
            _loc2_ = _loc4_ ? this.mLevelDef.getAIEasyActions(_loc6_) : this.mLevelDef.getAIActions(_loc6_);
            _loc2_ = _loc4_ && _loc2_ != null && DictionaryUtils.getDictionaryLength(_loc2_) > 0 ? _loc2_ : this.mLevelDef.getAIActions(_loc6_);
            this.fillDeck(_loc2_);
         }
         else
         {
            this.fillDeck(this.mLevelDef.getAIUnits(UserData.WORLD_DEFAULT));
            this.fillDeck(this.mLevelDef.getAIAttachments(UserData.WORLD_DEFAULT));
            this.fillDeck(this.mLevelDef.getAIActions(UserData.WORLD_DEFAULT));
         }
      }
      
      protected function fillDeck(param1:Dictionary) : void
      {
         var _loc2_:Array = null;
         var _loc3_:* = undefined;
         var _loc4_:CardDef = null;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         if(param1 != null && DictionaryUtils.getDictionaryLength(param1) > 0)
         {
            _loc2_ = DictionaryUtils.getKeys(param1);
            _loc5_ = this.mLevelDef.areDefaultCardsDefined();
            _loc6_ = Config.getConfig().gameHasPowers();
            for each(_loc3_ in _loc2_)
            {
               _loc4_ = _loc6_ ? CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc3_)) : null;
               if(!_loc5_ && (_loc4_ != null && _loc4_ is PowerDef))
               {
                  if(this.mPowerSku == null)
                  {
                     this.mPowerSku = _loc3_;
                  }
               }
               else
               {
                  this.addCardSkuToCatalogs(_loc3_,param1[_loc3_]);
                  if(this.mDeckFactions == null)
                  {
                     this.mDeckFactions = new Dictionary(true);
                  }
                  _loc4_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc3_));
                  if(_loc4_ != null)
                  {
                     _loc7_ = _loc4_.getFactionSku();
                     if(_loc7_ != "" && _loc7_ != null)
                     {
                        this.mDeckFactions[_loc7_] = _loc7_;
                     }
                  }
               }
            }
            if(!_loc5_ && this.mPowerSku == null && Config.getConfig().gameHasPowers())
            {
               _loc8_ = 0;
               if(this.mUserData)
               {
                  _loc8_ = this is UserBattleInfoPvP ? this.mUserData.getSelectedDeckIndexPvP() : this.mUserData.getSelectedDeckIndex();
               }
               this.mPowerSku = this.mUserData ? this.mUserData.getDefaultPowerSku(_loc8_) : PowerDef(InstanceMng.getPowerDefMng().getDefByIndex(0)).getSku();
            }
         }
      }
      
      public function addCardSkuToCatalogs(param1:String, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this.mDeck == null)
         {
            this.mDeck = new Dictionary(true);
         }
         if(this.mDeck[param1] == null)
         {
            this.mDeck[param1] = param2;
         }
         else
         {
            this.mDeck[param1] += param2;
         }
         if(this.mDeckArray == null)
         {
            this.mDeckArray = new Array();
         }
         _loc3_ = 0;
         while(_loc3_ < param2)
         {
            _loc4_ = int(this.mDeckArray.length);
            this.mDeckArray[_loc4_] = param1;
            _loc3_++;
         }
      }
      
      public function isOwnerBattleInfo() : Boolean
      {
         var _loc1_:Boolean = false;
         return this.mUserData != null && this.mUserData.getIsOwner();
      }
      
      public function getUserData() : UserData
      {
         return this.mUserData;
      }
      
      public function getDeck() : Dictionary
      {
         return this.mDeck;
      }
      
      public function getDeckLength() : int
      {
         return this.mDeckArray ? int(this.mDeckArray.length) : 0;
      }
      
      public function getFightCards() : Dictionary
      {
         return this.mFightCards;
      }
      
      public function getFightCardsByAbilities(param1:Array) : Dictionary
      {
         var _loc3_:FSCard = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Vector.<Ability> = null;
         var _loc7_:Ability = null;
         var _loc8_:Boolean = false;
         var _loc2_:Dictionary = new Dictionary(true);
         if(this.mFightCards)
         {
            for each(_loc3_ in this.mFightCards)
            {
               _loc8_ = false;
               _loc6_ = _loc3_.getCompositeAbilitiesVector();
               if((Boolean(_loc6_)) && _loc6_.length > 0)
               {
                  _loc4_ = 0;
                  while(_loc4_ < _loc6_.length)
                  {
                     _loc7_ = Ability(_loc6_[_loc4_]);
                     if(_loc7_)
                     {
                        _loc5_ = 0;
                        while(_loc5_ < param1.length)
                        {
                           if(param1[_loc5_] == _loc7_.getAbilityDef().getKeyName() && !_loc8_)
                           {
                              _loc8_ = true;
                              _loc2_[_loc3_.getBFId()] = _loc3_;
                           }
                           _loc5_++;
                        }
                     }
                     _loc4_++;
                  }
               }
            }
         }
         return _loc2_;
      }
      
      public function getFightCardsByType(param1:int) : Vector.<FSCard>
      {
         var _loc3_:FSCard = null;
         var _loc2_:Vector.<FSCard> = new Vector.<FSCard>();
         for each(_loc3_ in this.mFightCards)
         {
            if(_loc3_.getType() == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function getHP() : int
      {
         return this.mHP ? int(this.mHP.value) : 0;
      }
      
      public function setHP(param1:FSNumber) : void
      {
         if(this.mHP == null)
         {
            this.mHP = new FSNumber();
         }
         var _loc2_:String = this.isOwnerBattleInfo() ? "Owner" : "Opponent";
         if(InstanceMng.getBattleEngine())
         {
            InstanceMng.getBattleEngine().storeCombatLogAction(BattleEngine.COMBAT_LOG_HP_MODIFIED,null,"",{
               "TARGET":_loc2_,
               "VALUE":this.mHP.value + " -> " + Number(param1.value)
            });
         }
         this.mHP.value = Number(param1.value);
      }
      
      public function getActionPointsLeft() : int
      {
         return this.mActionPointsLeft ? int(this.mActionPointsLeft.value) : 0;
      }
      
      public function setActionPointsLeft(param1:int) : void
      {
         if(this.mActionPointsLeft == null)
         {
            this.mActionPointsLeft = new FSNumber();
         }
         var _loc2_:int = this.isOwnerBattleInfo() ? int(this.mLevelDef.getMaxActionPoints()) : int(this.mLevelDef.getMaxAIActionPoints());
         var _loc3_:int = param1 > _loc2_ && _loc2_ > 0 ? _loc2_ : int(Number(param1));
         var _loc4_:String = this.isOwnerBattleInfo() ? "Owner" : "Opponent";
         if(Boolean(InstanceMng.getBattleEngine()) && this.mActionPointsLeft.value != _loc3_)
         {
            InstanceMng.getBattleEngine().storeCombatLogAction(BattleEngine.COMBAT_LOG_AP_MODIFIED,null,"",{
               "TARGET":_loc4_,
               "VALUE":this.mActionPointsLeft.value + " -> " + _loc3_
            });
         }
         this.mActionPointsLeft.value = param1 > _loc2_ && _loc2_ > 0 ? _loc2_ : Number(param1);
      }
      
      public function getLevelDef() : LevelDef
      {
         return this.mLevelDef;
      }
      
      public function setLevelDef(param1:LevelDef) : void
      {
         this.mLevelDef = param1;
      }
      
      public function getUserBattlePortrait() : FSBattlefieldUserPortrait
      {
         return this.mUserBattlePortrait;
      }
      
      public function setUserBattlePortrait(param1:FSBattlefieldUserPortrait) : void
      {
         this.mUserBattlePortrait = param1;
      }
      
      public function setBattleEngine(param1:BattleEngine) : void
      {
         this.mBattleEngine = param1;
      }
      
      public function getPlayableCardsCatalog() : Dictionary
      {
         return this.mPlayableCardsCatalog;
      }
      
      public function addPlayableCard(param1:FSCard) : void
      {
         if(this.mPlayableCardsCatalog == null)
         {
            this.mPlayableCardsCatalog = new Dictionary(true);
         }
         this.mPlayableCardsCatalog[param1.getPlayableCardId()] = param1;
         ++this.mPlayableCardsAmountInTurn;
      }
      
      public function resetPlayableCardsInTurn() : void
      {
         this.mPlayableCardsAmountInTurn = 0;
      }
      
      public function getPlayableCardsUsedInTurn() : int
      {
         return this.mPlayableCardsAmountInTurn;
      }
      
      public function getTurnsInvulnerable() : int
      {
         return this.mTurnsInvulnerable;
      }
      
      public function removeCardFromPlayableCardsCatalog(param1:FSCard) : void
      {
         var _loc2_:String = null;
         if(this.mPlayableCardsCatalog != null)
         {
            _loc2_ = param1.getPlayableCardId().toString();
            if(this.mPlayableCardsCatalog[_loc2_] != null && this.mPlayableCardsCatalog[_loc2_] == param1)
            {
               this.mPlayableCardsCatalog[_loc2_] = null;
               delete this.mPlayableCardsCatalog[_loc2_];
            }
         }
      }
      
      public function setFightCardOnBattlefield(param1:FSCard) : void
      {
         if(this.mFightCards == null)
         {
            this.mFightCards = new Dictionary(true);
         }
         if(this.mFightCards[param1.getBFId()] == null)
         {
            this.mFightCards[param1.getBFId()] = param1;
         }
      }
      
      public function removeFightCardFromBattlefield(param1:FSCard) : void
      {
         if(this.mFightCards != null)
         {
            if(this.mFightCards[param1.getBFId()] != null)
            {
               this.addCardToGraveyard(this.mFightCards[param1.getBFId()]);
               delete this.mFightCards[param1.getBFId()];
            }
         }
      }
      
      public function addCardToGraveyard(param1:FSCard) : void
      {
         var _loc2_:int = 0;
         if(Config.getConfig().gameHasGraveyard())
         {
            if(param1)
            {
               _loc2_ = param1.getCardDef().getCooldown();
               if(_loc2_ > 0)
               {
                  if(this.mGraveyard == null)
                  {
                     this.mGraveyard = new Array();
                  }
                  this.mGraveyard[this.mGraveyard.length] = param1.getCardDef().getSku() + ":" + this.mBattleEngine.getCurrentTurnId().toString();
               }
            }
         }
      }
      
      public function getDeckArray() : Array
      {
         return this.mDeckArray;
      }
      
      public function getRandomCardSkuFromDeck(param1:Boolean = false, param2:Boolean = false, param3:Array = null, param4:String = "", param5:Array = null, param6:String = "") : String
      {
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:CardDef = null;
         var _loc26_:Array = null;
         var _loc9_:Boolean = false;
         var _loc14_:String = "";
         var _loc15_:String = "";
         var _loc16_:Array = null;
         var _loc17_:Array = null;
         var _loc18_:Boolean = param6 != "" && param6 != null;
         var _loc19_:Boolean = param4 != "" && param4 != null;
         var _loc20_:Boolean = param5 != null && param5.length > 0;
         var _loc21_:Boolean = param3 != null && param3.length > 0;
         var _loc22_:Array = null;
         if(param1)
         {
            _loc10_ = 0;
            while(_loc10_ < this.mDeckArray.length)
            {
               _loc13_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(this.mDeckArray[_loc10_]));
               if(_loc13_ != null && this.mLevelDef.isCardAllowedInThisLevel(_loc13_))
               {
                  if(param2 && !_loc9_)
                  {
                     if(_loc13_ is UnitDef)
                     {
                        _loc22_.push(_loc13_.getSku());
                        _loc9_ = true;
                     }
                  }
                  else
                  {
                     _loc22_.push(_loc13_.getSku());
                  }
               }
               _loc10_++;
            }
            _loc22_.sort(DictionaryUtils.sortCardsSkusByValue);
            _loc7_ = _loc22_[0];
            this.removeCardFromDeck(_loc7_);
         }
         else
         {
            _loc26_ = this.filterCards(this.mDeckArray,param3,param4,param5,param6);
            if(_loc26_ != null && _loc26_.length > 0)
            {
               _loc8_ = Utils.randomInt(0,_loc26_.length - 1);
               _loc7_ = this.getCardSkuFromDeckByIndex(_loc8_,_loc26_);
            }
            else
            {
               _loc7_ = null;
            }
         }
         _loc13_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc7_));
         var _loc23_:Boolean = _loc13_ != null && _loc13_.getCategoryIndex() == CategoriesDefMng.CATEGORY_UNITS;
         if(_loc7_ != null && param2 && !_loc9_ && _loc23_)
         {
            _loc9_ = true;
         }
         var _loc24_:Boolean = !this.mLevelDef.isCardAllowedInThisLevel(_loc13_) || _loc13_ == null || _loc13_.getCategoryIndex() == CategoriesDefMng.CATEGORY_POWERS;
         var _loc25_:Boolean = param2 && !_loc9_;
         if(_loc7_ == null || _loc24_ || _loc25_)
         {
            if(_loc7_ != null && (_loc24_ || _loc25_))
            {
               this.addCardSkuToCatalogs(_loc7_,1);
            }
            if(this.mDealCardsAttempts == 20)
            {
               FSDebug.debugTrace("[getRandomCardFromDeck] - Too many attempts of getting an allowed unit, exiting...");
               return null;
            }
            ++this.mDealCardsAttempts;
            FSDebug.debugTrace("Getting an extra random card");
            _loc7_ = this.getRandomCardSkuFromDeck(param1,param2,param3,param4,param5,param6);
         }
         return _loc7_;
      }
      
      private function filterCards(param1:Array, param2:Array = null, param3:String = "", param4:Array = null, param5:String = "") : Array
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:CardDef = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:Array = null;
         var _loc13_:Array = null;
         var _loc14_:Boolean = false;
         var _loc15_:Boolean = false;
         var _loc16_:Boolean = false;
         var _loc17_:Boolean = false;
         var _loc18_:Array = null;
         var _loc19_:Boolean = false;
         var _loc20_:Boolean = false;
         if(param1 != null)
         {
            _loc10_ = "";
            _loc11_ = "";
            _loc12_ = null;
            _loc13_ = null;
            _loc14_ = param5 != "" && param5 != null;
            _loc15_ = param3 != "" && param3 != null;
            _loc16_ = param4 != null && param4.length > 0;
            _loc17_ = param2 != null && param2.length > 0;
            _loc18_ = new Array();
            _loc6_ = 0;
            for(; _loc6_ < param1.length; _loc6_++)
            {
               _loc9_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(param1[_loc6_]));
               if(_loc9_ != null)
               {
                  if(this.mLevelDef.isCardAllowedInThisLevel(_loc9_))
                  {
                     _loc10_ = _loc9_.getFactionSku();
                     _loc11_ = _loc9_.getCategorySku();
                     _loc12_ = _loc9_.getSubCategorySku();
                     _loc13_ = _loc9_.getAllAbilitiesDefsBreakdown();
                     if(!(_loc14_ && _loc10_ != param5))
                     {
                        if(!(_loc15_ && _loc11_ != param3))
                        {
                           if(_loc16_)
                           {
                              _loc19_ = false;
                              if(_loc12_)
                              {
                                 _loc7_ = 0;
                                 while(_loc7_ < _loc12_.length)
                                 {
                                    if(!_loc19_)
                                    {
                                       _loc8_ = 0;
                                       while(_loc8_ < param4.length)
                                       {
                                          if(param4[_loc8_] == _loc12_[_loc7_])
                                          {
                                             _loc19_ = true;
                                             break;
                                          }
                                          _loc8_++;
                                       }
                                    }
                                    _loc7_++;
                                 }
                              }
                              if(!_loc19_)
                              {
                                 continue;
                              }
                           }
                           if(_loc17_)
                           {
                              _loc20_ = false;
                              if(_loc13_)
                              {
                                 _loc7_ = 0;
                                 while(_loc7_ < _loc13_.length)
                                 {
                                    if(!_loc20_)
                                    {
                                       _loc8_ = 0;
                                       while(_loc8_ < param2.length)
                                       {
                                          if(param2[_loc8_] == _loc13_[_loc7_].getKeyName())
                                          {
                                             _loc20_ = true;
                                             break;
                                          }
                                          _loc8_++;
                                       }
                                    }
                                    _loc7_++;
                                 }
                              }
                              if(!_loc20_)
                              {
                                 continue;
                              }
                           }
                           _loc18_.push(_loc9_.getSku());
                        }
                     }
                  }
               }
            }
         }
         return _loc18_;
      }
      
      public function getPowerDefFromDeck() : PowerDef
      {
         var _loc1_:PowerDef = null;
         if(this.mPowerSku != null && this.mPowerSku != "")
         {
            _loc1_ = PowerDef(InstanceMng.getPowerDefMng().getDefBySku(this.mPowerSku));
         }
         if(_loc1_ == null)
         {
            FSDebug.debugTrace("== ATTENTION == Getting default power ");
            _loc1_ = this.setDefaultPowerSku();
         }
         return _loc1_;
      }
      
      public function getPowerCardFromDeck() : FSPower
      {
         if(this.mPowerSku != null && this.mPowerSku != "" && this.mPower == null)
         {
            this.mPower = new FSPower(this.mPowerSku);
         }
         return this.mPower;
      }
      
      private function setDefaultPowerSku() : PowerDef
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc1_:PowerDef = InstanceMng.getPowerDefMng().getDefByIndex(0);
         if(this.mUserData)
         {
            _loc2_ = this is UserBattleInfoPvP ? this.mUserData.getSelectedDeckIndexPvP() : this.mUserData.getSelectedDeckIndex();
            _loc3_ = this.mUserData.getDefaultPowerSku(_loc2_);
            _loc1_ = PowerDef(InstanceMng.getPowerDefMng().getDefBySku(_loc3_));
         }
         return _loc1_;
      }
      
      private function getCardSkuFromDeckByIndex(param1:int, param2:Array = null) : String
      {
         var _loc3_:String = null;
         var _loc4_:FSCard = null;
         var _loc5_:CardDef = null;
         var _loc6_:String = null;
         param2 = param2 != null ? param2 : this.mDeckArray;
         if(param2 != null && param2.length > 0)
         {
            _loc3_ = param2[param1];
         }
         if(_loc3_ != null)
         {
            _loc5_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc3_));
            _loc6_ = _loc5_ ? _loc5_.getCategorySku() : null;
            this.removeCardFromDeck(_loc3_);
            return _loc3_;
         }
         return null;
      }
      
      private function getCardFromDeckByIndex(param1:int) : FSCard
      {
         var _loc2_:String = null;
         var _loc3_:FSCard = null;
         var _loc4_:CardDef = null;
         var _loc5_:String = null;
         var _loc6_:CategoryDef = null;
         if(this.mDeckArray != null && this.mDeckArray.length > 0)
         {
            _loc2_ = this.mDeckArray[param1];
         }
         if(_loc2_ != null)
         {
            _loc4_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc2_));
            _loc5_ = _loc4_.getCategorySku();
            if(_loc5_ != null)
            {
               _loc6_ = CategoryDef(InstanceMng.getCategoriesDefMng().getDefBySku(_loc5_));
               param1 = _loc6_ != null ? _loc6_.getIndex() : 0;
            }
            else if(Capabilities.isDebugger)
            {
               throw new Error("[getCardFromDeckByIndex] - Category not found!");
            }
            switch(param1)
            {
               case FSCard.TYPE_UNIT:
                  _loc3_ = new FSUnit(_loc2_);
                  break;
               case FSCard.TYPE_ATTACHMENT:
                  _loc3_ = new FSAttachment(_loc2_);
                  break;
               case FSCard.TYPE_ACTION:
                  _loc3_ = new FSAction(_loc2_);
            }
            this.removeCardFromDeck(_loc2_);
            return _loc3_;
         }
         return null;
      }
      
      public function removeCardFromDeck(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         if(this.mDeckArray != null)
         {
            _loc3_ = false;
            _loc2_ = 0;
            while(_loc2_ < this.mDeckArray.length)
            {
               if(!_loc3_ && this.mDeckArray[_loc2_] == param1)
               {
                  this.mDeckArray.splice(_loc2_,1);
                  _loc3_ = true;
                  break;
               }
               _loc2_++;
            }
         }
         if(this.mDeck != null)
         {
            if(this.mDeck[param1] != null)
            {
               if(this.mDeck[param1] > 1)
               {
                  this.mDeck[param1] = this.mDeck[param1] - 1;
               }
               else
               {
                  delete this.mDeck[param1];
               }
            }
         }
      }
      
      public function spendActionPoints(param1:int) : void
      {
         this.setActionPointsLeft(this.getActionPointsLeft() - param1);
      }
      
      public function hasActionPointsLeft(param1:int = 1) : Boolean
      {
         var _loc2_:int = this.getActionPointsLeft();
         return param1 == 1 ? _loc2_ > 0 : _loc2_ >= param1;
      }
      
      public function modifyHP(param1:FSNumber, param2:Boolean = false) : void
      {
         var isOwner:Boolean = false;
         var onRaidPointsUpdatedSuccessfully:Function = null;
         var tweenDuration:Number = NaN;
         var raidLevelDef:RaidLevelDef = null;
         var parentRaidDef:RaidDef = null;
         var guildId:String = null;
         var accountId:String = null;
         var hpPoints:FSNumber = param1;
         var triggeredByAbility:Boolean = param2;
         onRaidPointsUpdatedSuccessfully = function(param1:FSNumber, param2:Boolean = false):void
         {
            var _loc3_:Object = null;
            if(InstanceMng.getRaidsMng())
            {
               if(param1.value > 0)
               {
                  InstanceMng.getRaidsMng().setBossHealCurrentRaid(InstanceMng.getRaidsMng().getBossHealCurrentRaid() + param1.value);
               }
               else
               {
                  InstanceMng.getRaidsMng().setBossHitCurrentRaid(InstanceMng.getRaidsMng().getBossHitCurrentRaid() + param1.value);
               }
               FSDebug.debugTrace("[modifyHP, HIT BOSS ------- (hit = " + String(-param1.value) + ")");
               if(Boolean(mBattleEngine) && Boolean(mBattleEngine.getOwnerBattleInfo()))
               {
                  mBattleEngine.getOwnerBattleInfo().setRaidCumulativeDamage(-param1.value);
                  mBattleEngine.getOwnerBattleInfo().setRaidCumulativeDamageCurrentBattle(-param1.value);
               }
               updateHPVisuals(param1,param2);
               if(Boolean(InstanceMng.getRaidsMng().getCurrentRaidDef()) && !InstanceMng.getRaidsMng().getCurrentRaidDef().getIsMultiPlayer())
               {
                  _loc3_ = new Object();
                  _loc3_.raidSku = InstanceMng.getRaidsMng().getCurrentRaidDef().getSku();
                  _loc3_.difficulty = InstanceMng.getRaidsMng().getCurrentRaidDifficulty();
                  _loc3_.damage = -param1.value;
                  InstanceMng.getRaidsMng().onRaidDamageReceivedUpdateLogic(_loc3_);
               }
            }
         };
         var updateHPVisuals:Function = function(param1:FSNumber, param2:Boolean = false):void
         {
            var _loc3_:FSNumber = null;
            var _loc4_:String = null;
            var _loc5_:uint = 0;
            var _loc6_:Function = null;
            var _loc7_:Array = null;
            var _loc8_:PlayerHPViewer = null;
            var _loc9_:FSTextfield = null;
            var _loc10_:String = null;
            var _loc11_:Boolean = false;
            var _loc12_:Boolean = false;
            var _loc13_:Boolean = false;
            if(Boolean(mBattleEngine) && Boolean(InstanceMng.getCurrentScreen() is FSBattleScreen) && InstanceMng.getCurrentScreen().isFullyLoaded())
            {
               if(isOwner)
               {
                  Utils.playSound(Constants.SOUND_HEART_BEAT,SoundManager.TYPE_SFX);
               }
               else if(!isOwner && param1.value < 0)
               {
                  Utils.playSound(Constants.SOUND_HIT_PLAYER,SoundManager.TYPE_SFX);
               }
               _loc3_ = new FSNumber();
               _loc3_.value = getHP() + param1.value > 0 ? getHP() + param1.value : 0;
               _loc4_ = param1.value >= 0 ? "+" + param1.value.toString() : param1.value.toString();
               if(param1.value >= 0)
               {
                  _loc5_ = 65280;
                  InstanceMng.getTextParticlesMng().showTextParticle(_loc4_,_loc5_,mUserBattlePortrait);
               }
               else
               {
                  _loc5_ = param2 ? TextParticlesMng.COLOR_DAMAGE_RECEIVED_ABILITY : TextParticlesMng.COLOR_DAMAGE_RECEIVED_STD;
                  _loc10_ = Math.abs(param1.value) >= Config.getConfig().battleGetActivateSFXAttackValue() ? "high_damage_hero_icon" : "damage_hero_icon";
                  InstanceMng.getTextParticlesMng().showTextParticleOnBattle(_loc4_,_loc5_,mUserBattlePortrait,-1,Align.CENTER,Align.CENTER,"",_loc10_);
                  if(Config.getConfig().hasQuests() && !isOwner)
                  {
                     _loc11_ = Boolean(Root.smBattleData.isDungeon);
                     _loc12_ = Boolean(Root.smBattleData.isRaid);
                     _loc13_ = InstanceMng.getBattleEngine().isPvPMatch();
                     if(_loc11_)
                     {
                        InstanceMng.getQuestsMng().addActionPerformed(QuestsMng.TARGET_TYPE_DEAL_DAMAGE_TO_DUNGEON_OPPONENT,Math.abs(param1.value),false,null,"",InstanceMng.getDungeonsMng().getCurrentDungeonDef().getSku(),InstanceMng.getDungeonsMng().getCurrentDungeonDifficulty());
                        InstanceMng.getQuestsMng().addActionPerformed(QuestsMng.TARGET_TYPE_DEAL_DAMAGE_TO_DUNGEON_OPPONENT_TURN,Math.abs(param1.value),false,null,"",InstanceMng.getDungeonsMng().getCurrentDungeonDef().getSku(),InstanceMng.getDungeonsMng().getCurrentDungeonDifficulty());
                     }
                     else if(_loc12_)
                     {
                        InstanceMng.getQuestsMng().addActionPerformed(QuestsMng.TARGET_TYPE_DEAL_DAMAGE_TO_RAID_OPPONENT,Math.abs(param1.value),false,null,null,InstanceMng.getRaidsMng().getCurrentRaidDef().getSku(),InstanceMng.getRaidsMng().getCurrentRaidDifficulty());
                        InstanceMng.getQuestsMng().addActionPerformed(QuestsMng.TARGET_TYPE_DEAL_DAMAGE_TO_RAID_OPPONENT_TURN,Math.abs(param1.value),false,null,null,InstanceMng.getRaidsMng().getCurrentRaidDef().getSku(),InstanceMng.getRaidsMng().getCurrentRaidDifficulty());
                     }
                     else if(!_loc13_ || _loc13_ && InstanceMng.getBattleEngine().isOnlineMatch() && !PvPConnectionMng.smPlayingFriendlyMatch)
                     {
                        InstanceMng.getQuestsMng().addActionPerformed(QuestsMng.TARGET_TYPE_DEAL_DAMAGE_TO_OPPONENT,Math.abs(param1.value),false,null,mLevelDef.getSku());
                        InstanceMng.getQuestsMng().addActionPerformed(QuestsMng.TARGET_TYPE_DEAL_DAMAGE_TO_OPPONENT_TURN,Math.abs(param1.value),false,null,mLevelDef.getSku());
                     }
                  }
               }
               setHP(_loc3_);
               _loc6_ = onHPModified;
               _loc7_ = [!param2];
               _loc8_ = mUserBattlePortrait.getHPPlayerViewer();
               _loc9_ = _loc8_ ? _loc8_.getHPTextfield() : null;
               if(_loc9_)
               {
                  SpecialFX.createTextfieldAmountTransition(_loc9_,_loc3_.value,1,true,_loc6_,_loc7_,Linear.easeIn,"",_loc8_);
               }
               if(InstanceMng.getCurrentScreen() is FSBattleScreen && isOwner)
               {
                  FSBattleScreen(InstanceMng.getCurrentScreen()).updateScoreStars();
               }
            }
         };
         var hpTweensArr:Array = TweenMax.getTweensOf(this);
         if(hpTweensArr != null && hpTweensArr.length > 0)
         {
            tweenDuration = TweenMax(hpTweensArr[0])._duration;
            TweenMax(hpTweensArr[0]).totalProgress(tweenDuration);
         }
         isOwner = this.isOwnerBattleInfo();
         if(Boolean(Root.smBattleData.isRaid) && !isOwner)
         {
            if(InstanceMng.getRaidsMng())
            {
               raidLevelDef = RaidLevelDef(this.mLevelDef);
               if(raidLevelDef)
               {
                  parentRaidDef = RaidDef(InstanceMng.getRaidsDefMng().getDefBySku(raidLevelDef.getParentRaidSku()));
                  if(parentRaidDef)
                  {
                     guildId = InstanceMng.getUserDataMng().getOwnerUserData().getGuildId();
                     accountId = InstanceMng.getUserDataMng().getOwnerUserData().getAccountId();
                     InstanceMng.getServerConnection().addScoreToRaid(-hpPoints.value,raidLevelDef.getParentRaidSku(),raidLevelDef.getDifficulty(),parentRaidDef.getIsMultiPlayer(),guildId,accountId,onRaidPointsUpdatedSuccessfully,[hpPoints,triggeredByAbility],onRaidPointsUpdatedSuccessfully,[hpPoints,triggeredByAbility]);
                  }
               }
            }
         }
         else
         {
            updateHPVisuals(hpPoints,triggeredByAbility);
            if(hpPoints.value < 0 && isOwner)
            {
               InstanceMng.getBattleEngine().flagOwnerAsHit();
            }
         }
      }
      
      private function onUpdateRaidsBattlesFail() : void
      {
         var _loc1_:RaidsMng = InstanceMng.getRaidsMng();
         var _loc2_:Object = _loc1_.getRaidsBattlesObj();
         if(Boolean(_loc1_) && Boolean(_loc2_))
         {
            this.mIsWaitingForUpdateRaidBattlesACK = false;
         }
      }
      
      private function onUpdateRaidsBattlesSuccess(param1:Object) : void
      {
         this.mIsWaitingForUpdateRaidBattlesACK = false;
      }
      
      public function onHPModified(param1:Boolean) : void
      {
         if(this.mBattleEngine)
         {
            this.mBattleEngine.checkIfBattleOver(param1);
         }
      }
      
      public function isAlive() : Boolean
      {
         return this.getHP() > 0;
      }
      
      public function addNextTurnExtraActionPoints(param1:int) : void
      {
         var _loc2_:ActionPointsCounter = null;
         var _loc3_:int = 0;
         this.mNextTurnExtraActionPoints += param1;
         if(InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            _loc2_ = FSBattleScreen(InstanceMng.getCurrentScreen()).getActionPointsCounter(this.isOwnerBattleInfo());
            if(_loc2_)
            {
               _loc3_ = this.isOwnerBattleInfo() ? this.mLevelDef.getActionPointsPerTurn() : this.mLevelDef.getAIActionPointsPerTurn();
               _loc3_ += this.getAPGenerated();
               _loc2_.updateVisualCurrentAPs(_loc3_ + this.mNextTurnExtraActionPoints);
            }
         }
      }
      
      public function getMaxActionPoints() : int
      {
         var _loc2_:ActionPointsCounter = null;
         var _loc1_:int = 0;
         if(InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            _loc2_ = FSBattleScreen(InstanceMng.getCurrentScreen()).getActionPointsCounter(this.isOwnerBattleInfo());
            if(_loc2_)
            {
               _loc1_ = _loc2_.getFullAPAmount();
            }
         }
         return _loc1_;
      }
      
      public function getNextTurnExtraActionPoints() : int
      {
         return this.mNextTurnExtraActionPoints;
      }
      
      public function updateUnableToMoveToAttackLaneTurns() : void
      {
         var _loc1_:FSUnit = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         for each(_loc1_ in this.mFightCards)
         {
            _loc3_ = _loc1_.getTurnsAmountWithoutMovingToAttackLane();
            _loc2_ = _loc3_ - 1 >= 0 ? int(_loc3_ - 1) : 0;
            _loc1_.setTurnsAmountWithoutMovingToAttackLane(_loc2_);
         }
      }
      
      public function unload() : void
      {
         if(this.mDeck)
         {
            DictionaryUtils.disposeCatalogCards(this.mDeck,false);
            DictionaryUtils.clearDictionary(this.mDeck);
            this.mDeck = null;
         }
         if(this.mDeckArray)
         {
            this.mDeckArray.length = 0;
            this.mDeckArray = null;
         }
         if(this.mFightCards)
         {
            DictionaryUtils.disposeCatalogCards(this.mFightCards,false);
            DictionaryUtils.clearDictionary(this.mFightCards);
            this.mFightCards = null;
         }
         if(this.mPlayableCardsCatalog)
         {
            DictionaryUtils.disposeCatalogCards(this.mPlayableCardsCatalog,false);
            DictionaryUtils.clearDictionary(this.mPlayableCardsCatalog);
            this.mPlayableCardsCatalog = null;
         }
         if(this.mUserBattlePortrait)
         {
            this.mUserBattlePortrait.removeFromParent(true);
            this.mUserBattlePortrait = null;
         }
         if(this.mInvulnerableIcon)
         {
            this.mInvulnerableIcon.removeFromParent(true);
            this.mInvulnerableIcon = null;
         }
         if(this.mDeckFactions)
         {
            DictionaryUtils.clearDictionary(this.mDeckFactions);
            this.mDeckFactions = null;
         }
         this.mAPGenerated = 0;
      }
      
      public function getDeckFactions() : Dictionary
      {
         return this.mDeckFactions;
      }
      
      public function setSacrificeAvailable(param1:Boolean) : void
      {
         this.mSacrificeAvailable = param1;
         if(InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            FSBattleScreen(InstanceMng.getCurrentScreen()).enableSacrificeButton(this.isOwnerBattleInfo(),param1);
         }
      }
      
      public function setPowerAvailable(param1:Boolean, param2:Boolean = false) : void
      {
         this.mPowerAvailable = param1;
         if(param2)
         {
            if(this.mBattleEngine.isOwnerTurn())
            {
               this.mBattleEngine.enableOwnerPowerButton(param1);
            }
            else
            {
               this.mBattleEngine.enableOpponentPowerButton(param1);
            }
         }
      }
      
      public function isSacrificeAvailable() : Boolean
      {
         return this.mSacrificeAvailable;
      }
      
      public function isPowerAvailable() : Boolean
      {
         return this.mPowerAvailable;
      }
      
      public function updateGraveyard() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Array = new Array();
         if(Config.getConfig().gameHasGraveyard())
         {
            if(Boolean(this.mGraveyard) && Boolean(this.mDeckArray))
            {
               _loc1_ = 0;
               while(_loc1_ < this.mGraveyard.length)
               {
                  _loc3_ = String(this.mGraveyard[_loc1_]).split(":")[0];
                  _loc4_ = int(String(this.mGraveyard[_loc1_]).split(":")[1]);
                  _loc5_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc3_)).getCooldown();
                  if(this.mBattleEngine.getCurrentTurnId() - _loc4_ > _loc5_)
                  {
                     this.addCardSkuToCatalogs(_loc3_,1);
                     _loc6_[_loc6_.length] = _loc3_;
                  }
                  _loc1_++;
               }
               _loc1_ = 0;
               while(_loc1_ < _loc6_.length)
               {
                  _loc2_ = 0;
                  while(_loc2_ < this.mGraveyard.length)
                  {
                     _loc3_ = String(this.mGraveyard[_loc2_]).split(":")[0];
                     if(_loc6_[_loc1_] == _loc3_)
                     {
                        this.mGraveyard.splice(_loc2_,1);
                        break;
                     }
                     _loc2_++;
                  }
                  _loc1_++;
               }
            }
         }
      }
      
      public function getRaidCumulativeDamage() : int
      {
         return this.mCumulativeDamage;
      }
      
      public function getRaidCumulativeDamageCurrentBattle() : int
      {
         return this.mCumulativeDamageCurrentBattle;
      }
      
      public function setRaidCumulativeDamage(param1:int) : void
      {
         this.mCumulativeDamage += param1;
      }
      
      public function setRaidCumulativeDamageCurrentBattle(param1:int) : void
      {
         this.mCumulativeDamageCurrentBattle += param1;
      }
      
      public function resetRaidCumulativeDamageCurrentBattle() : void
      {
         this.mCumulativeDamageCurrentBattle = 0;
      }
      
      public function performExtraCostUpdate(param1:AbilityDef = null, param2:FSCard = null, param3:Boolean = false, param4:Boolean = false) : void
      {
         var _loc5_:FSCard = null;
         var _loc6_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         var _loc11_:String = null;
         var _loc12_:Boolean = false;
         var _loc7_:Boolean = param1 != null ? param1.getKeyName() == AbilitiesMng.SPECIAL_FIXEDCOST : false;
         var _loc8_:Boolean = param1 != null ? param1.getKeyName() == AbilitiesMng.SPECIAL_MODIFYCOST : false;
         for each(_loc5_ in this.mPlayableCardsCatalog)
         {
            _loc11_ = _loc5_.getCostModifiedByAbility();
            _loc9_ = _loc11_ == AbilitiesMng.SPECIAL_MODIFYCOST;
            _loc10_ = _loc11_ == AbilitiesMng.SPECIAL_FIXEDCOST;
            _loc12_ = _loc9_ || _loc10_;
            if(param2 == null || param2 != null && param2 != _loc5_)
            {
               if(param1 == null)
               {
                  if(param3)
                  {
                     if(_loc10_)
                     {
                        _loc5_.updateSummonCost(null);
                     }
                  }
                  else if(param4)
                  {
                     if(_loc9_)
                     {
                        _loc5_.updateSummonCost(null);
                     }
                  }
               }
               else if(param1 != null)
               {
                  _loc6_ = param1.isCardEligibleForAbility(_loc5_);
                  if(_loc12_)
                  {
                     if(_loc10_)
                     {
                        if(_loc6_)
                        {
                           _loc5_.updateSummonCost(param1);
                        }
                        else
                        {
                           _loc5_.updateSummonCost(null);
                        }
                     }
                     else if(_loc9_)
                     {
                        if(!_loc7_)
                        {
                           if(_loc8_)
                           {
                              if(_loc6_)
                              {
                                 _loc5_.updateSummonCost(param1);
                              }
                              else
                              {
                                 _loc5_.updateSummonCost(null);
                              }
                           }
                        }
                     }
                  }
                  else if(_loc6_)
                  {
                     _loc5_.updateSummonCost(param1);
                  }
               }
            }
         }
      }
      
      public function setApplyCostModifierAbilityOnNextCard(param1:Boolean) : void
      {
         this.mApplyCostModifierAbilityOnNextCard = param1;
      }
      
      public function applyCostModifierAbilityOnNextCard() : Boolean
      {
         return this.mApplyCostModifierAbilityOnNextCard;
      }
      
      public function removeSummonCostAbilities() : void
      {
         if(!this.isModifiedCostActive() && this.isFixedSummonCostActive() || this.isModifiedCostActive() && !this.isFixedSummonCostActive())
         {
            this.setApplyCostModifierAbilityOnNextCard(false);
         }
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         if(this.isFixedSummonCostActive())
         {
            _loc1_ = true;
            this.setTurnsFixedSummonCost(0);
            this.setFixedSummonCostAbilityDef(null);
            this.setFixedSummonCostParentCard(null);
         }
         if(this.isModifiedCostActive())
         {
            _loc2_ = true;
            this.setModifySummonCostTurns(0);
            this.setModifySummonCostAbilityDef(null);
            this.setModifySummonCostParentCard(null);
         }
         this.performExtraCostUpdate(null,null,_loc1_,_loc2_);
      }
      
      public function getPassiveAbilityDef() : PassiveAbilityDef
      {
         var _loc1_:PassiveAbilityDef = null;
         var _loc2_:UserData = null;
         if(Config.getConfig().gameHasPassive())
         {
            _loc2_ = this.isOwnerBattleInfo() ? InstanceMng.getUserDataMng().getOwnerUserData() : InstanceMng.getUserDataMng().getOpponentUserData();
            _loc1_ = _loc2_ ? PassiveAbilityDef(InstanceMng.getPassiveAbilityDefMng().getDefBySku(_loc2_.getPassiveAbilitySku())) : null;
         }
         return _loc1_;
      }
      
      public function getPassiveAbilitySound() : String
      {
         var _loc1_:String = null;
         var _loc2_:PassiveAbilityDef = null;
         var _loc3_:AbilityDef = null;
         var _loc4_:Ability = null;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:UserData = null;
         if(Config.getConfig().gameHasPassive())
         {
            _loc2_ = this.getPassiveAbilityDef();
            _loc7_ = this.isOwnerBattleInfo() ? InstanceMng.getUserDataMng().getOwnerUserData() : InstanceMng.getUserDataMng().getOpponentUserData();
            if(_loc7_)
            {
               if(_loc2_)
               {
                  _loc6_ = _loc2_.getAbilitiesSkus();
                  if((Boolean(_loc6_)) && _loc6_.length > 0)
                  {
                     _loc3_ = AbilityDef(InstanceMng.getAbilitiesDefMng().getDefBySku(_loc6_[0]));
                     if(_loc3_)
                     {
                        _loc1_ = _loc3_.getSoundName();
                     }
                  }
               }
            }
         }
         return _loc1_;
      }
      
      public function hasRandomPassiveAbilities(param1:FSCard = null) : Boolean
      {
         var _loc2_:PassiveAbilityDef = null;
         var _loc3_:AbilityDef = null;
         var _loc4_:Ability = null;
         var _loc5_:Array = null;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         var _loc11_:UserData = null;
         var _loc12_:String = null;
         if(Config.getConfig().gameHasPassive())
         {
            _loc6_ = false;
            _loc11_ = this.isOwnerBattleInfo() ? InstanceMng.getUserDataMng().getOwnerUserData() : InstanceMng.getUserDataMng().getOpponentUserData();
            if(_loc11_)
            {
               _loc2_ = PassiveAbilityDef(InstanceMng.getPassiveAbilityDefMng().getDefBySku(_loc11_.getPassiveAbilitySku()));
               if(_loc2_)
               {
                  _loc12_ = _loc2_.getTriggereableByCategorySku();
                  if(Boolean(_loc12_ != "") && Boolean(param1) && param1.getCardDef().getCategorySku() != _loc12_)
                  {
                     return false;
                  }
                  if(param1 is FSAction)
                  {
                     _loc6_ = true;
                     param1 = null;
                  }
                  _loc5_ = _loc2_.getAbilitiesSkus();
                  if((Boolean(_loc5_)) && _loc5_.length > 0)
                  {
                     _loc3_ = AbilityDef(InstanceMng.getAbilitiesDefMng().getDefBySku(_loc5_[0]));
                     if(_loc3_)
                     {
                        _loc4_ = new Ability(_loc3_,param1,true);
                        if((Boolean(_loc4_)) && _loc4_.canBeExecutedAndHasTargets())
                        {
                           _loc7_ = InstanceMng.getAbilitiesMng().isRandomTargetAbility(_loc4_.getAbilityDef());
                           _loc8_ = _loc3_.getRandomDamageAmount() != 0 || _loc3_.getRandomDefenseAmount() != 0 || _loc3_.getRandomHealAmount() != 0;
                           _loc9_ = _loc3_.getChances() != null;
                           _loc10_ = _loc3_.getKeyName() == AbilitiesMng.SPECIAL_RECRUIT;
                           if(_loc7_ || _loc8_ || _loc9_ || _loc10_)
                           {
                              return true;
                           }
                        }
                     }
                  }
               }
            }
         }
         return false;
      }
      
      public function executePassive(param1:FSCard = null) : void
      {
         var _loc2_:PassiveAbilityDef = null;
         var _loc3_:AbilityDef = null;
         var _loc4_:Ability = null;
         var _loc5_:Array = null;
         var _loc6_:Boolean = false;
         var _loc7_:UserData = null;
         var _loc8_:String = null;
         if(Config.getConfig().gameHasPassive())
         {
            _loc6_ = false;
            _loc7_ = this.isOwnerBattleInfo() ? InstanceMng.getUserDataMng().getOwnerUserData() : InstanceMng.getUserDataMng().getOpponentUserData();
            if(_loc7_)
            {
               _loc2_ = PassiveAbilityDef(InstanceMng.getPassiveAbilityDefMng().getDefBySku(_loc7_.getPassiveAbilitySku()));
               if(_loc2_)
               {
                  _loc8_ = _loc2_.getTriggereableByCategorySku();
                  if(Boolean(_loc8_ != "") && Boolean(param1) && param1.getCardDef().getCategorySku() != _loc8_)
                  {
                     return;
                  }
                  if(param1 is FSAction)
                  {
                     _loc6_ = true;
                     param1 = null;
                  }
                  _loc5_ = _loc2_.getAbilitiesSkus();
                  if((Boolean(_loc5_)) && _loc5_.length > 0)
                  {
                     _loc3_ = AbilityDef(InstanceMng.getAbilitiesDefMng().getDefBySku(_loc5_[0]));
                     if(_loc3_)
                     {
                        if(_loc6_ && _loc3_.isRandomTargetAbility())
                        {
                           throw new Error("Random target abilities cannot be triggered by Actions (Passive Abilities)");
                        }
                        _loc4_ = new Ability(_loc3_,param1,true);
                        if((Boolean(_loc4_)) && _loc4_.canBeExecutedAndHasTargets())
                        {
                           if(InstanceMng.getBattleEngine())
                           {
                              InstanceMng.getBattleEngine().storeCombatLogAction(BattleEngine.COMBAT_LOG_PASSIVE_EXECUTED,null,_loc4_.getAbilityDef().getSku());
                           }
                           _loc4_.execute();
                        }
                     }
                  }
               }
            }
         }
      }
      
      public function isAnyCardBeingPromoted() : Boolean
      {
         var _loc2_:FSUnit = null;
         var _loc1_:Boolean = false;
         if(this.mFightCards)
         {
            for each(_loc2_ in this.mFightCards)
            {
               if(_loc2_.isCardBeingPromoted())
               {
                  _loc1_ = true;
                  break;
               }
            }
         }
         return _loc1_;
      }
      
      public function getGraveyardCards() : Array
      {
         return this.mGraveyard;
      }
      
      public function isAnyCardInGraveyard() : Boolean
      {
         return this.mGraveyard ? this.mGraveyard.length > 0 : false;
      }
      
      public function isCardInGraveyard(param1:FSCardPreview) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         if(Boolean(this.mGraveyard) && Boolean(this.mGraveyard.length > 0) && Boolean(param1))
         {
            _loc2_ = 0;
            while(_loc2_ < this.mGraveyard.length)
            {
               _loc3_ = String(this.mGraveyard[_loc2_]).split(":")[0];
               if(_loc3_ == param1.getCardDef().getSku())
               {
                  _loc4_ = true;
                  break;
               }
               _loc2_++;
            }
         }
         return _loc4_;
      }
      
      public function removeCardFromGraveyardLogic(param1:FSCardPreview) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         _loc2_ = 0;
         while(_loc2_ < this.mGraveyard.length)
         {
            _loc3_ = String(this.mGraveyard[_loc2_]).split(":")[0];
            if(param1.getCardDef().getSku() == _loc3_)
            {
               this.mGraveyard.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function generateEmblems(param1:FSCard) : void
      {
         var _loc2_:String = null;
         if(Config.getConfig().gameHasEmblems())
         {
            _loc2_ = param1.getCardDef().getFactionSku();
            if(this.mEmblemDictionary)
            {
               this.mEmblemDictionary[_loc2_] = int(this.mEmblemDictionary[_loc2_]) + param1.getCardDef().getEmblemGeneratedOnPlay();
            }
         }
      }
      
      public function spendEmblems(param1:CardDef) : void
      {
         var _loc2_:String = null;
         if(Config.getConfig().gameHasEmblems())
         {
            _loc2_ = param1.getFactionSku();
            if(this.mEmblemDictionary)
            {
               this.mEmblemDictionary[_loc2_] = int(this.mEmblemDictionary[_loc2_]) - UnitDef(param1).getEmblemRequiredToPromote();
            }
         }
      }
      
      public function getEmblems() : Dictionary
      {
         return this.mEmblemDictionary;
      }
      
      public function resetTimeoutsAndObjectsRaidUpdate() : void
      {
         this.mIsWaitingForUpdateRaidBattlesACK = false;
      }
      
      public function increaseAPGenerated(param1:int) : void
      {
         var _loc2_:ActionPointsCounter = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:FSBattlefieldUserPortrait = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         if(param1 != 0)
         {
            _loc2_ = this.mBattleEngine.getBattleScreen().getActionPointsCounter(this.isOwnerBattleInfo());
            if(_loc2_ == null)
            {
               FSBattleScreen(InstanceMng.getCurrentScreen()).showObjectivesPanel();
            }
            if(_loc2_)
            {
               _loc3_ = this.isOwnerBattleInfo() ? int(this.mLevelDef.getMaxActionPoints()) : int(this.mLevelDef.getMaxAIActionPoints());
               _loc4_ = _loc2_.getFullAPAmount();
               _loc5_ = _loc4_ + param1 > _loc3_ ? _loc3_ : int(_loc4_ + param1);
               _loc5_ = _loc5_ >= 0 ? _loc5_ : 0;
               param1 = _loc5_ - _loc4_;
               this.mAPGenerated += param1;
               _loc6_ = _loc5_ != _loc4_;
               _loc2_.setFullAPAmount(_loc5_);
               _loc2_.updateVisualCurrentAPs(_loc5_);
               if(_loc6_)
               {
                  _loc7_ = this.isOwnerBattleInfo() ? this.mBattleEngine.getBattleScreen().getOwnerPortrait() : this.mBattleEngine.getBattleScreen().getOpponentPortrait();
                  _loc8_ = param1 > 0 ? "+" + param1 + " MAX" : param1 + " MAX";
                  _loc9_ = param1 > 0 ? FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GREEN) : FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_RED);
                  InstanceMng.getTextParticlesMng().showTextParticleOnBattle(_loc8_,16777215,_loc7_,FSResourceMng.FONT_STD_SEMI_SMALL_SIZE,Align.CENTER,Align.CENTER,_loc9_,"frame_summon_icon",false,"up",Align.RIGHT);
               }
            }
            else
            {
               setTimeout(this.increaseAPGenerated,100,param1);
            }
         }
      }
      
      public function getAPGenerated() : int
      {
         return this.mAPGenerated;
      }
      
      public function getActionCostForAbsPanel(param1:FSCard, param2:ActionDef, param3:AbilityDef) : int
      {
         var _loc4_:int = 0;
         if(param2 != null)
         {
            _loc4_ = param2.getUpgradeCostByAbilitySku(param3.getSku());
         }
         var _loc5_:AbilityDef = param1.getCostModifierAbilityDef();
         var _loc6_:int = this.getTurnsFixedSummonCost();
         var _loc7_:int = this.getExtraSummonCostTurns();
         if(_loc7_ > 0 || _loc7_ == -1 || _loc7_ == -2)
         {
            if(Boolean(_loc5_) && _loc5_.isCardEligibleForAbility(param1))
            {
               return _loc4_ + this.getExtraSummonCost() >= 0 ? int(_loc4_ + this.getExtraSummonCost()) : 0;
            }
         }
         if(_loc6_ > 0 || _loc6_ == -1 || _loc6_ == -2)
         {
            if(Boolean(_loc5_) && _loc5_.isCardEligibleForAbility(param1))
            {
               return this.getFixedSummonCost() >= 0 ? this.getFixedSummonCost() : 0;
            }
         }
         return _loc4_;
      }
      
      public function hasDiscarded() : Boolean
      {
         return this.mHasDiscarded;
      }
      
      public function setHasDiscarded(param1:Boolean) : void
      {
         this.mHasDiscarded = param1;
      }
      
      public function destroy() : void
      {
         this.mUserData = null;
         Utils.destroyObject(this.mHP);
         this.mHP = null;
         Utils.destroyObject(this.mActionPointsLeft);
         this.mActionPointsLeft = null;
         this.mLevelDef = null;
         this.mModifySummonCostAbDef = null;
         this.mFixedSummonCostAbDef = null;
         this.mFixedSummonCostParentCard = null;
         this.mModifySummonCostParentCard = null;
         this.mBattleEngine = null;
         DictionaryUtils.clearDictionary(this.mEmblemDictionary);
         this.mEmblemDictionary = null;
         DictionaryUtils.clearDictionary(this.mDeck);
         this.mDeck = null;
         DictionaryUtils.clearDictionary(this.mFightCards);
         this.mFightCards = null;
         DictionaryUtils.clearDictionary(this.mPlayableCardsCatalog);
         this.mPlayableCardsCatalog = null;
         Utils.destroyArray(this.mGraveyard);
         this.mGraveyard = null;
         Utils.destroyArray(this.mDeckArray);
         this.mDeckArray = null;
         if(this.mUserBattlePortrait)
         {
            this.mUserBattlePortrait.removeFromParent(true);
         }
         this.mUserBattlePortrait = null;
         if(this.mInvulnerableIcon)
         {
            this.mInvulnerableIcon.removeFromParent(true);
         }
         this.mInvulnerableIcon = null;
         if(this.mInvulnerableMC)
         {
            this.mInvulnerableMC.removeFromParent(true);
         }
         this.mInvulnerableMC = null;
         if(this.mPoisonIcon)
         {
            this.mPoisonIcon.removeFromParent(true);
         }
         this.mPoisonIcon = null;
         if(this.mPower)
         {
            this.mPower.removeFromParent(true);
         }
         this.mPower = null;
      }
   }
}

