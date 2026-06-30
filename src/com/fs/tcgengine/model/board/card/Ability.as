package com.fs.tcgengine.model.board.card
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.AbilitiesMng;
   import com.fs.tcgengine.controller.FSSoundFXMng;
   import com.fs.tcgengine.controller.PvPConnectionMng;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.battle.BattleEnginePvP;
   import com.fs.tcgengine.model.rules.AbilityDef;
   import com.fs.tcgengine.model.userdata.UserBattleInfo;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.particles.TextParticlesMng;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.TimerUtil;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.anims.cards.BulletsAnim;
   import com.fs.tcgengine.view.anims.cards.CardAnimation;
   import com.fs.tcgengine.view.cards.FSAction;
   import com.fs.tcgengine.view.cards.FSAttachment;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.FSEvent;
   import com.fs.tcgengine.view.cards.FSPower;
   import com.fs.tcgengine.view.cards.FSUnit;
   import com.fs.tcgengine.view.components.battle.ActionPointsCounter;
   import com.fs.tcgengine.view.components.battle.FSBattlefieldUserPortrait;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.socket.FSCardSocket;
   import com.greensock.TweenMax;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import starling.extensions.ColorArgb;
   import starling.utils.Align;
   
   public class Ability implements FSModelUnloadableInterface
   {
      
      protected var mAbilityDef:AbilityDef;
      
      private var mTurnsAlive:int;
      
      protected var mParentCard:FSCard;
      
      protected var mParentAbilityDef:AbilityDef;
      
      protected var mIsPassive:Boolean;
      
      public function Ability(param1:AbilityDef, param2:FSCard, param3:Boolean = false)
      {
         super();
         this.mParentCard = param2;
         this.mIsPassive = param3;
         this.setAbilityDef(param1);
      }
      
      private function trackCombatLogAbilityExecuted(param1:Array) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc2_:String = "";
         if(param1)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               if(param1[_loc3_] is FSCard)
               {
                  _loc4_ = FSCard(param1[_loc3_]).getCardDef() ? FSCard(param1[_loc3_]).getCardDef().getSku() + " (" + FSCard(param1[_loc3_]).getCardDef().getName(false,true) + ")" : "???";
                  _loc4_ = _loc4_ + (FSCard(param1[_loc3_]).getAttachedToSocket() ? " BF Coords: " + FSCard(param1[_loc3_]).getAttachedToSocket().getCoordsString() : "");
                  _loc2_ += _loc2_ == "" ? _loc4_ : ", " + _loc4_;
               }
               else if(param1[_loc3_] is UserBattleInfo)
               {
                  _loc5_ = UserBattleInfo(param1[_loc3_]).isOwnerBattleInfo() ? "Owner" : "Opponent";
                  _loc2_ += _loc2_ == "" ? _loc5_ : ", " + _loc5_;
               }
               _loc3_++;
            }
         }
         if(InstanceMng.getBattleEngine())
         {
            InstanceMng.getBattleEngine().storeCombatLogAction(BattleEngine.COMBAT_LOG_ABILITY_EXECUTED,this.mParentCard,this.mAbilityDef.getSku(),{"Targets":_loc2_});
         }
      }
      
      public function execute(param1:Boolean = true) : void
      {
         var _loc2_:Array = null;
         if(!InstanceMng.getAbilitiesMng().isTargetSelectionAbility(this.getAbilityDef()))
         {
            this.temporarilyLockWhileTriggeringAb(param1);
            if(InstanceMng.getBattleEngine().isOnlineMatch() && !InstanceMng.getBattleEngine().isOwnerTurn() && this.mAbilityDef.isRandomTargetAbility() && !PvPConnectionMng.isPlayingVSAI())
            {
               _loc2_ = [BattleEnginePvP(InstanceMng.getBattleEngine()).getAbilityRandomTargetBySaveObject(InstanceMng.getBattleEngine().isOwnerTurn(),this.getParentCard().getId(),this)];
            }
            else
            {
               _loc2_ = InstanceMng.getAbilitiesMng().getEligibleTargetsByTargetIndex(this.mAbilityDef,this.mParentCard,this.mAbilityDef.getCostRange());
            }
            this.performAbilityOperations(_loc2_);
            this.updatePvPRandomTargets(_loc2_);
            this.trackCombatLogAbilityExecuted(_loc2_);
         }
         else
         {
            this.highlightPossibleTargetsForAbility();
            this.onPlayableItemsHighlighted();
            if(this.areAnyItemsHighlighted())
            {
               if(InstanceMng.getCurrentScreen() is FSBattleScreen)
               {
                  (InstanceMng.getCurrentScreen() as FSBattleScreen).suggestPlayableCardOFF();
               }
               this.showLogMessageForTargetSelectionAbility();
            }
         }
      }
      
      private function isParentCardPower() : Boolean
      {
         return Boolean(this.mParentCard) && this.mParentCard is FSPower;
      }
      
      private function temporarilyLockWhileTriggeringAb(param1:Boolean = true) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc2_:BattleEngine = InstanceMng.getBattleEngine();
         if(Boolean(_loc2_) && (_loc2_.isOwnerTurn() || _loc2_.isPvPMatch() && !_loc2_.isOnlineMatch()))
         {
            if(this.mAbilityDef.getTriggerIndex() == AbilitiesMng.TRIGGERS_ON_PLAY)
            {
               InstanceMng.getBattleEngine().enableSideDeck(false);
               _loc3_ = TimerUtil.currentTimeMillis();
               _loc4_ = TimerUtil.secondToMs(Config.getConfig().getDefaultAbilityAnimDuration());
               _loc5_ = _loc3_ + _loc4_;
               this.disableAttackButton(_loc5_);
               InstanceMng.getBattleEngine().enableSacrificeButton(false);
               InstanceMng.getBattleEngine().enableOwnerPowerButton(false);
               InstanceMng.getBattleEngine().enableOpponentPowerButton(false);
               this.enableCard(false);
               setTimeout(InstanceMng.getBattleEngine().enableSacrificeButton,_loc4_,[true]);
               setTimeout(InstanceMng.getBattleEngine().enableOwnerPowerButton,_loc4_,[true]);
               setTimeout(InstanceMng.getBattleEngine().enableOpponentPowerButton,_loc4_,[true]);
               if(param1)
               {
                  setTimeout(this.enableCard,_loc4_,[true]);
               }
               setTimeout(this.enableAttackButton,_loc4_);
               setTimeout(this.enableSideDeck,_loc4_,[true]);
            }
         }
      }
      
      private function enableSideDeck(param1:Boolean) : void
      {
         if(InstanceMng.getBattleEngine())
         {
            InstanceMng.getBattleEngine().enableSideDeck(param1);
         }
      }
      
      private function enableCard(param1:Boolean) : void
      {
         if(this.mParentCard)
         {
            this.mParentCard.touchable = param1;
         }
      }
      
      public function disableAttackButton(param1:Number = 0) : void
      {
         if(InstanceMng.getBattleEngine())
         {
            InstanceMng.getBattleEngine().disableAttackButton(param1);
         }
      }
      
      public function enableAttackButton() : void
      {
         if(InstanceMng.getBattleEngine())
         {
            InstanceMng.getBattleEngine().enableAttackButton();
         }
      }
      
      private function updatePvPRandomTargets(param1:Array) : void
      {
         var _loc3_:String = null;
         var _loc4_:FSCard = null;
         var _loc5_:UserBattleInfo = null;
         var _loc2_:BattleEngine = InstanceMng.getBattleEngine();
         if(_loc2_ != null && _loc2_.isOnlineMatch() && _loc2_.isOwnerTurn())
         {
            if(this.mAbilityDef != null && this.mAbilityDef.isRandomTargetAbility() && param1 != null && param1.length > 0)
            {
               if(param1[0] is FSCard)
               {
                  _loc4_ = param1[0];
                  _loc3_ = _loc4_.getParentUserBattleInfo().isOwnerBattleInfo() ? "owner_" : "opponent_";
                  _loc3_ += "card_" + _loc4_.getAttachedToSocket().getSocketIndex();
                  BattleEnginePvP(_loc2_).onRandomUnitTargetSelected(this.getParentCard(),_loc3_);
               }
               else
               {
                  _loc5_ = UserBattleInfo(param1[0]);
                  _loc3_ = _loc5_.isOwnerBattleInfo() ? "owner_" : "opponent_";
                  _loc3_ += "portrait";
                  BattleEnginePvP(_loc2_).onRandomUnitTargetSelected(this.getParentCard(),_loc3_);
               }
            }
         }
      }
      
      private function updatePvPRandomPropertyChanged(param1:*, param2:int = 0, param3:int = 0, param4:int = 0, param5:int = 0, param6:int = 0) : void
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         if(InstanceMng.getBattleEngine().isOnlineMatch() && (InstanceMng.getBattleEngine().isOwnerTurn() || !InstanceMng.getBattleEngine().isOwnerTurn() && PvPConnectionMng.isPlayingVSAI()))
         {
            _loc7_ = this.mAbilityDef.getDefaultDamage();
            _loc8_ = this.mAbilityDef.getDefaultDefense();
            _loc9_ = this.mAbilityDef.getDefaultHeal();
            _loc10_ = this.mAbilityDef.getRandomDamageAmount();
            _loc11_ = this.mAbilityDef.getRandomDefenseAmount();
            _loc12_ = this.mAbilityDef.getRandomHealAmount();
            _loc13_ = _loc10_ != 0 ? int(param2 - _loc7_) : 0;
            _loc14_ = _loc11_ != 0 ? int(param3 - _loc8_) : 0;
            _loc15_ = _loc12_ != 0 ? int(param4 - _loc9_) : 0;
            if(_loc10_ != 0 || _loc11_ != 0 || _loc12_ != 0)
            {
               BattleEnginePvP(InstanceMng.getBattleEngine()).onRandomUnitAbilityPropertyTriggered(this.getParentCard(),param1,_loc13_,_loc14_,_loc15_,param5,param6);
            }
         }
      }
      
      public function areAnyItemsHighlighted() : Boolean
      {
         var _loc2_:Vector.<FSCardSocket> = null;
         var _loc3_:Vector.<FSBattlefieldUserPortrait> = null;
         var _loc1_:Boolean = false;
         _loc2_ = this.getParentCard().getPlayableSockets();
         _loc3_ = this.getParentCard().getPlayablePortraits();
         return _loc2_ != null && _loc2_.length > 0 || _loc3_ != null && _loc3_.length > 0;
      }
      
      public function showLogMessageForTargetSelectionAbility(param1:Boolean = true) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:FSBattleScreen = null;
         var _loc7_:FSImage = null;
         var _loc8_:int = 0;
         var _loc2_:BattleEngine = InstanceMng.getBattleEngine();
         if(Boolean(this.mAbilityDef) && Boolean(_loc2_))
         {
            _loc3_ = this.mParentCard && this.mParentCard.getParentUserBattleInfo() && this.mParentCard.getParentUserBattleInfo().isOwnerBattleInfo() || _loc2_.isPvPMatch() && !_loc2_.isOnlineMatch();
            if(_loc3_)
            {
               _loc4_ = this.mAbilityDef.getTargetIndex();
               _loc5_ = "";
               switch(_loc4_)
               {
                  case AbilitiesMng.TARGET_FRIENDLY_PLAYER:
                  case AbilitiesMng.TARGET_ENEMY_PLAYER:
                  case AbilitiesMng.TARGET_ALL_CARDS_DECK:
                  case AbilitiesMng.TARGET_ALL_ENEMY_CARDS_DECK:
                  case AbilitiesMng.TARGET_ALL_FRIENDLY_CARDS_DECK:
                  case AbilitiesMng.TARGET_NEXT_CARD_DECK:
                  case AbilitiesMng.TARGET_NEXT_ENEMY_CARD_DECK:
                  case AbilitiesMng.TARGET_NEXT_FRIENDLY_CARD_DECK:
                     _loc5_ = TextManager.getText("TID_LOG_TARGET_PLAYER");
                     break;
                  case AbilitiesMng.TARGET_FRIENDLY:
                  case AbilitiesMng.TARGET_ALL_FRIENDLY:
                     _loc5_ = TextManager.getText("TID_LOG_TARGET_FRIENDLY");
                     break;
                  case AbilitiesMng.TARGET_ENEMY:
                  case AbilitiesMng.TARGET_ALL_ENEMY:
                     _loc5_ = TextManager.getText("TID_LOG_TARGET_ENEMY");
                     break;
                  case AbilitiesMng.TARGET_FRIENDLY_CARD:
                  case AbilitiesMng.TARGET_FRIENDLY_CARD_COST_LOWER_THAN:
                  case AbilitiesMng.TARGET_FRIENDLY_CARD_COST_HIGHER_THAN:
                  case AbilitiesMng.TARGET_FRIENDLY_CARD_ATTACK_LOWER_THAN:
                  case AbilitiesMng.TARGET_FRIENDLY_CARD_ATTACK_HIGHER_THAN:
                  case AbilitiesMng.TARGET_FRIENDLY_CARD_DEFENSE_LOWER_THAN:
                  case AbilitiesMng.TARGET_FRIENDLY_CARD_DEFENSE_HIGHER_THAN:
                  case AbilitiesMng.TARGET_FRIENDLY_CARDS_BY_ABILITY:
                  case AbilitiesMng.TARGET_ALL_FRIENDLY_CARDS:
                  case AbilitiesMng.TARGET_FRIENDLY_RANDOM_CARD:
                  case AbilitiesMng.TARGET_ALL_FRIENDLY_CARD_COST_LOWER_THAN:
                  case AbilitiesMng.TARGET_ALL_FRIENDLY_CARD_COST_HIGHER_THAN:
                  case AbilitiesMng.TARGET_ALL_FRIENDLY_CARD_ATTACK_LOWER_THAN:
                  case AbilitiesMng.TARGET_ALL_FRIENDLY_CARD_ATTACK_HIGHER_THAN:
                  case AbilitiesMng.TARGET_ALL_FRIENDLY_CARD_DEFENSE_LOWER_THAN:
                  case AbilitiesMng.TARGET_ALL_FRIENDLY_CARD_DEFENSE_HIGHER_THAN:
                  case AbilitiesMng.TARGET_ALL_FRIENDLY_CARDS_BY_ABILITY:
                  case AbilitiesMng.TARGET_FRIENDLY_SUPPORT_LANE_CARDS:
                  case AbilitiesMng.TARGET_FRIENDLY_ATTACK_LANE_CARDS:
                  case AbilitiesMng.TARGET_FRIENDLY_SUPPORT_LANE_CARD:
                  case AbilitiesMng.TARGET_FRIENDLY_ATTACK_LANE_CARD:
                  case AbilitiesMng.TARGET_FRIENDLY_CARD_HIGHER_HEALTH:
                  case AbilitiesMng.TARGET_FRIENDLY_CARD_HIGHER_HEALTH_SUPPORT_LANE:
                  case AbilitiesMng.TARGET_FRIENDLY_CARD_HIGHER_HEALTH_FRONT_LANE:
                  case AbilitiesMng.TARGET_FRIENDLY_CARD_LOWER_HEALTH:
                  case AbilitiesMng.TARGET_FRIENDLY_CARD_LOWER_HEALTH_SUPPORT_LANE:
                  case AbilitiesMng.TARGET_FRIENDLY_CARD_LOWER_HEALTH_FRONT_LANE:
                  case AbilitiesMng.TARGET_FRIENDLY_CARD_HIGHER_ATTACK:
                  case AbilitiesMng.TARGET_FRIENDLY_CARD_HIGHER_ATTACK_SUPPORT_LANE:
                  case AbilitiesMng.TARGET_FRIENDLY_CARD_HIGHER_ATTACK_FRONT_LANE:
                  case AbilitiesMng.TARGET_FRIENDLY_CARD_LOWER_ATTACK:
                  case AbilitiesMng.TARGET_FRIENDLY_CARD_LOWER_ATTACK_SUPPORT_LANE:
                  case AbilitiesMng.TARGET_FRIENDLY_CARD_LOWER_ATTACK_FRONT_LANE:
                     _loc5_ = TextManager.getText("TID_LOG_TARGET_FRIENDLYCARD");
                     break;
                  case AbilitiesMng.TARGET_ENEMY_CARD:
                  case AbilitiesMng.TARGET_ENEMY_CARD_COST_LOWER_THAN:
                  case AbilitiesMng.TARGET_ENEMY_CARD_COST_HIGHER_THAN:
                  case AbilitiesMng.TARGET_ENEMY_CARD_ATTACK_LOWER_THAN:
                  case AbilitiesMng.TARGET_ENEMY_CARD_ATTACK_HIGHER_THAN:
                  case AbilitiesMng.TARGET_ENEMY_CARD_DEFENSE_LOWER_THAN:
                  case AbilitiesMng.TARGET_ENEMY_CARD_DEFENSE_HIGHER_THAN:
                  case AbilitiesMng.TARGET_ENEMY_CARDS_BY_ABILITY:
                  case AbilitiesMng.TARGET_ALL_ENEMY_CARDS:
                  case AbilitiesMng.TARGET_ENEMY_RANDOM_CARD:
                  case AbilitiesMng.TARGET_ALL_ENEMY_CARD_COST_LOWER_THAN:
                  case AbilitiesMng.TARGET_ALL_ENEMY_CARD_COST_HIGHER_THAN:
                  case AbilitiesMng.TARGET_ALL_ENEMY_CARD_ATTACK_LOWER_THAN:
                  case AbilitiesMng.TARGET_ALL_ENEMY_CARD_ATTACK_HIGHER_THAN:
                  case AbilitiesMng.TARGET_ALL_ENEMY_CARD_DEFENSE_LOWER_THAN:
                  case AbilitiesMng.TARGET_ALL_ENEMY_CARD_DEFENSE_HIGHER_THAN:
                  case AbilitiesMng.TARGET_ALL_ENEMY_CARDS_BY_ABILITY:
                  case AbilitiesMng.TARGET_ENEMY_SUPPORT_LANE_CARDS:
                  case AbilitiesMng.TARGET_ENEMY_ATTACK_LANE_CARDS:
                  case AbilitiesMng.TARGET_ENEMY_SUPPORT_LANE_CARD:
                  case AbilitiesMng.TARGET_ENEMY_ATTACK_LANE_CARD:
                  case AbilitiesMng.TARGET_ENEMY_CARD_HIGHER_HEALTH:
                  case AbilitiesMng.TARGET_ENEMY_CARD_HIGHER_HEALTH_SUPPORT_LANE:
                  case AbilitiesMng.TARGET_ENEMY_CARD_HIGHER_HEALTH_FRONT_LANE:
                  case AbilitiesMng.TARGET_ENEMY_CARD_LOWER_HEALTH:
                  case AbilitiesMng.TARGET_ENEMY_CARD_LOWER_HEALTH_SUPPORT_LANE:
                  case AbilitiesMng.TARGET_ENEMY_CARD_LOWER_HEALTH_FRONT_LANE:
                  case AbilitiesMng.TARGET_ENEMY_CARD_HIGHER_ATTACK:
                  case AbilitiesMng.TARGET_ENEMY_CARD_HIGHER_ATTACK_SUPPORT_LANE:
                  case AbilitiesMng.TARGET_ENEMY_CARD_HIGHER_ATTACK_FRONT_LANE:
                  case AbilitiesMng.TARGET_ENEMY_CARD_LOWER_ATTACK:
                  case AbilitiesMng.TARGET_ENEMY_CARD_LOWER_ATTACK_SUPPORT_LANE:
                  case AbilitiesMng.TARGET_ENEMY_CARD_LOWER_ATTACK_FRONT_LANE:
                     _loc5_ = TextManager.getText("TID_LOG_TARGET_ENEMYCARD");
                     break;
                  case AbilitiesMng.TARGET_CARD:
                  case AbilitiesMng.TARGET_CARDS_BY_ABILITY:
                  case AbilitiesMng.TARGET_ALL:
                  case AbilitiesMng.TARGET_ALL_CARDS:
                  case AbilitiesMng.TARGET_RANDOM_CARD:
                  case AbilitiesMng.TARGET_RANDOM_CARD_COST_LOWER_THAN:
                  case AbilitiesMng.TARGET_RANDOM_CARD_COST_HIGHER_THAN:
                  case AbilitiesMng.TARGET_ALL_CARDS_COST_LOWER_THAN:
                  case AbilitiesMng.TARGET_ALL_CARDS_COST_HIGHER_THAN:
                  case AbilitiesMng.TARGET_RANDOM_CARD_ATTACK_LOWER_THAN:
                  case AbilitiesMng.TARGET_RANDOM_CARD_ATTACK_HIGHER_THAN:
                  case AbilitiesMng.TARGET_ALL_CARDS_ATTACK_LOWER_THAN:
                  case AbilitiesMng.TARGET_ALL_CARDS_ATTACK_HIGHER_THAN:
                  case AbilitiesMng.TARGET_RANDOM_CARD_DEFENSE_LOWER_THAN:
                  case AbilitiesMng.TARGET_RANDOM_CARD_DEFENSE_HIGHER_THAN:
                  case AbilitiesMng.TARGET_ALL_CARDS_DEFENSE_LOWER_THAN:
                  case AbilitiesMng.TARGET_ALL_CARDS_DEFENSE_HIGHER_THAN:
                  case AbilitiesMng.TARGET_ALL_CARDS_BY_ABILITY:
                  case AbilitiesMng.TARGET_ALL_SUPPORT_LANE_CARDS:
                  case AbilitiesMng.TARGET_ALL_ATTACK_LANE_CARDS:
                  case AbilitiesMng.TARGET_ALL_SUPPORT_LANE_CARD:
                  case AbilitiesMng.TARGET_ALL_ATTACK_LANE_CARD:
                  case AbilitiesMng.TARGET_CARD_HIGHER_HEALTH_ALL_CARDS:
                  case AbilitiesMng.TARGET_CARD_LOWER_HEALTH_ALL_CARDS:
                  case AbilitiesMng.TARGET_CARD_HIGHER_ATTACK_ALL_CARDS:
                  case AbilitiesMng.TARGET_CARD_LOWER_ATTACK_ALL_CARDS:
                     _loc5_ = TextManager.getText("TID_LOG_TARGET_CARD");
                     break;
                  case AbilitiesMng.TARGET_ENEMY_CARD_COST_LOWER_THAN:
                     _loc5_ = TextManager.getText("TID_LOG_TARGET_ENEMYCARD");
                     break;
                  case AbilitiesMng.TARGET_FRIENDLY_CARDS_EXCEPT_ITSELF:
                  case AbilitiesMng.TARGET_FRIENDLY_SUPPORT_LANE_CARDS_EXCEPT_ITSELF:
                  case AbilitiesMng.TARGET_FRIENDLY_ATTACK_LANE_CARDS_EXCEPT_ITSELF:
                  case AbilitiesMng.TARGET_FRIENDLY_SUPPORT_LANE_CARD_EXCEPT_ITSELF:
                  case AbilitiesMng.TARGET_FRIENDLY_ATTACK_LANE_CARD_EXCEPT_ITSELF:
                     _loc5_ = TextManager.getText("TID_LOG_TARGET_OTHER");
               }
               _loc5_ += " - " + this.mAbilityDef.getDesc();
               _loc6_ = InstanceMng.getCurrentScreen() is FSBattleScreen && Boolean(FSBattleScreen(InstanceMng.getCurrentScreen())) ? FSBattleScreen(InstanceMng.getCurrentScreen()) : null;
               if(_loc6_)
               {
                  if(Config.getConfig().battleUseDeckBG())
                  {
                     if(param1)
                     {
                        if(_loc2_.isOwnerTurn())
                        {
                           _loc6_.showOwnerLockedDeckSocketsBG(true);
                        }
                        else
                        {
                           _loc6_.showOpponentLockedDeckSocketsBG(true);
                        }
                     }
                     InstanceMng.getLogPanel().alpha = 0;
                     _loc7_ = _loc2_.isOwnerTurn() ? _loc6_.getOwnerLockedDeckSocketsBG() : _loc6_.getOpponentLockedDeckSocketsBG();
                     Utils.setLogText(_loc5_,false,true,false,true,0.5,Align.CENTER,Align.TOP,_loc7_);
                     SpecialFX.createZoomAlphaTween(InstanceMng.getLogPanel(),0.5,0.001,0.999,3,1,null,this.createLogPanelTweening);
                  }
                  else
                  {
                     _loc8_ = InstanceMng.getLevelsDefMng().getLevelIndexByLevelSku(InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelSkuByDifficulty(UserDataMng.DIFFICULTY_EASY));
                     if(_loc8_ > 10)
                     {
                        Utils.setLogText(_loc5_,false,true,false,true,0.999,Align.CENTER,Align.TOP,null,true);
                     }
                     else
                     {
                        InstanceMng.getLogPanel().alpha = 0;
                        Utils.setLogText(_loc5_,false,true,false,true,0.5,Align.CENTER,Align.CENTER,null,true);
                        SpecialFX.createZoomAlphaTween(InstanceMng.getLogPanel(),0.5,0.001,0.999,3,1,null,this.createLogPanelTweening,[true]);
                     }
                  }
               }
            }
         }
      }
      
      private function createLogPanelTweening(param1:Boolean = false) : void
      {
         var _loc2_:FSCoordinate = null;
         if(InstanceMng.getLogPanel())
         {
            InstanceMng.getLogPanel().alpha = 1;
            InstanceMng.getLogPanel().getTextfield().alpha = 1;
            InstanceMng.getLogPanel().getBG().alpha = 1;
            SpecialFX.createYoYoAlphaTransition(InstanceMng.getLogPanel().getTextfield(),0.75,0.5);
            if(param1)
            {
               _loc2_ = new FSCoordinate(InstanceMng.getLogPanel().x,InstanceMng.getLogPanel().height / 2);
               SpecialFX.createTransition(InstanceMng.getLogPanel(),_loc2_,1,0,this.stopLogAlphaTweening);
            }
         }
      }
      
      private function stopLogAlphaTweening() : void
      {
         if(Boolean(InstanceMng.getLogPanel()) && Boolean(InstanceMng.getLogPanel().getBG()))
         {
            TweenMax.killTweensOf(InstanceMng.getLogPanel().getBG());
            TweenMax.killTweensOf(InstanceMng.getLogPanel());
            InstanceMng.getLogPanel().getBG().alpha = 0.999;
         }
      }
      
      public function performAbilityOperations(param1:Array) : void
      {
         var _loc2_:String = null;
         this.playAbilitySound();
         this.increaseTurnsAlive();
         if(param1 != null)
         {
            _loc2_ = this.mAbilityDef.getKeyName();
            switch(_loc2_)
            {
               case AbilitiesMng.SPECIAL_DISCIPLINE:
                  this.performDiscipline(param1);
                  break;
               case AbilitiesMng.SPECIAL_AFFINITY:
                  this.performAffinity(param1);
                  break;
               default:
                  this.performDefaultOps(param1);
            }
            this.onAbilitiesPerformed(param1);
         }
      }
      
      private function playAbilitySound() : void
      {
         var _loc1_:String = null;
         if(this.mAbilityDef != null)
         {
            _loc1_ = this.mAbilityDef.getSoundName();
            if(_loc1_ != null && _loc1_ != "")
            {
               Utils.playSound(_loc1_,SoundManager.TYPE_SFX);
            }
         }
      }
      
      private function performAffinity(param1:Array) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:FSCard = null;
         var _loc6_:int = 0;
         var _loc7_:FSCard = null;
         var _loc8_:FSCard = null;
         var _loc9_:Number = NaN;
         var _loc10_:int = 0;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc4_:Boolean = true;
         var _loc5_:int = param1 ? int(param1.length) : 0;
         if(Config.getConfig().battlePerformAttackLogicOnTargetReached())
         {
            _loc9_ = Config.getConfig().getDefaultReachTargetTransitionTime();
            FSDebug.debugTrace("Performing affinity in: " + _loc9_ + " seconds");
            TweenMax.delayedCall(_loc9_,this.performAffinityOps,[param1,false]);
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc2_ = param1[_loc6_];
               if(_loc2_ is FSCard)
               {
                  _loc3_ = FSCard(_loc2_);
                  _loc4_ = this.getAbilityDef().isCardEligibleForAbility(_loc3_);
                  if(_loc4_)
                  {
                     _loc10_ = this.getAbilityDef().getDefense();
                     _loc7_ = _loc10_ < 0 ? _loc3_.getFightingWithCard() : this.getParentCard();
                     _loc8_ = _loc7_ == _loc3_.getFightingWithCard() ? _loc3_ : _loc3_.getFightingWithCard();
                     if(_loc7_)
                     {
                        _loc11_ = _loc7_.isAttacking() ? Align.BOTTOM : Align.TOP;
                        _loc12_ = _loc11_ == Align.BOTTOM ? Align.TOP : Align.BOTTOM;
                        if(!_loc7_.isEnemyCard())
                        {
                           Utils.playSound(Constants.SOUND_NICE,SoundManager.TYPE_SFX);
                           InstanceMng.getTextParticlesMng().showTextParticleOnBattle("",16777215,_loc7_,-1,Align.CENTER,_loc11_,"",AbilitiesMng.AFFINITY_BG,true);
                        }
                        if(!_loc8_.isEnemyCard())
                        {
                           Utils.playSound(Constants.SOUND_WEAK,SoundManager.TYPE_SFX);
                           InstanceMng.getTextParticlesMng().showTextParticleOnBattle("",16777215,_loc8_,-1,Align.CENTER,_loc11_,"",AbilitiesMng.COUNTER_AFFINITY_BG,true);
                        }
                     }
                  }
               }
               _loc6_++;
            }
         }
         else
         {
            this.performAffinityOps(param1);
         }
      }
      
      private function performAffinityOps(param1:Array, param2:Boolean = true) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:FSCard = null;
         var _loc7_:int = 0;
         var _loc8_:FSCard = null;
         var _loc9_:FSCard = null;
         var _loc10_:Boolean = false;
         var _loc11_:int = 0;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc5_:Boolean = true;
         var _loc6_:int = param1 ? int(param1.length) : 0;
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc3_ = param1[_loc7_];
            if(_loc3_)
            {
               if(_loc3_ is FSCard)
               {
                  _loc4_ = FSCard(_loc3_);
                  _loc5_ = this.getAbilityDef().isCardEligibleForAbility(_loc4_);
                  _loc10_ = _loc3_ is FSUnit && FSUnit(_loc3_).getInvulnerableTurns() > 0;
                  if(!_loc10_)
                  {
                     if(_loc5_)
                     {
                        _loc11_ = this.getAbilityDef().getDefense();
                        _loc4_.addDefense(_loc11_);
                        if(param2)
                        {
                           _loc8_ = _loc11_ < 0 ? _loc4_.getFightingWithCard() : this.getParentCard();
                           _loc9_ = _loc8_ == _loc4_.getFightingWithCard() ? _loc4_ : _loc4_.getFightingWithCard();
                           _loc12_ = _loc8_.isAttacking() ? Align.BOTTOM : Align.TOP;
                           _loc13_ = _loc12_ == Align.BOTTOM ? Align.TOP : Align.BOTTOM;
                           if(!_loc8_.isEnemyCard())
                           {
                              Utils.playSound(Constants.SOUND_NICE,SoundManager.TYPE_SFX);
                              InstanceMng.getTextParticlesMng().showTextParticleOnBattle("",16777215,_loc8_,-1,Align.CENTER,_loc12_,"",AbilitiesMng.AFFINITY_BG,true);
                           }
                           if(!_loc9_.isEnemyCard())
                           {
                              Utils.playSound(Constants.SOUND_WEAK,SoundManager.TYPE_SFX);
                              InstanceMng.getTextParticlesMng().showTextParticleOnBattle("",16777215,_loc9_,-1,Align.CENTER,_loc12_,"",AbilitiesMng.COUNTER_AFFINITY_BG,true);
                           }
                        }
                        InstanceMng.getCardAnimsMng().requestDebuffAnimation(_loc3_);
                        _loc4_.updateStatsAfterAttack(_loc4_.getDefense());
                     }
                  }
               }
            }
            _loc7_++;
         }
      }
      
      private function performDiscipline(param1:Array) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:FSCard = null;
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc10_:String = null;
         var _loc11_:uint = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:Vector.<FSAttachment> = null;
         var _loc18_:FSAttachment = null;
         var _loc19_:Ability = null;
         var _loc20_:Vector.<Ability> = null;
         var _loc4_:Boolean = true;
         var _loc5_:int = param1 ? int(param1.length) : 0;
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc2_ = param1[_loc6_];
            if(_loc2_ is FSCard)
            {
               _loc3_ = FSCard(_loc2_);
               _loc3_ = this.getUnitFromAttachment(_loc3_);
               _loc4_ = this.getAbilityDef().isCardEligibleForAbility(_loc3_);
               if(_loc4_)
               {
                  _loc7_ = this.mAbilityDef.resetsDefense();
                  _loc8_ = this.mAbilityDef.resetsDamage();
                  _loc9_ = this.mAbilityDef.resetsAbilities();
                  _loc11_ = _loc3_.getDieOnEndTurn() ? TextParticlesMng.COLOR_INACTIVE : TextParticlesMng.COLOR_HEAL_RECEIVED;
                  if(_loc7_)
                  {
                     _loc12_ = _loc3_ is FSUnit ? FSUnit(_loc3_).getUpdatedCompositeDefense() : _loc3_.getDefense();
                     _loc13_ = _loc3_.getDefense() <= _loc12_ ? int(_loc12_ - _loc3_.getDefense()) : 0;
                     _loc3_.addDefense(_loc13_);
                     _loc10_ = _loc13_ >= 0 ? "+" + _loc13_.toString() : _loc13_.toString();
                     if(!_loc3_.getDieOnEndTurn())
                     {
                        _loc11_ = _loc13_ >= 0 ? _loc11_ : TextParticlesMng.COLOR_DAMAGE_RECEIVED_STD;
                     }
                     InstanceMng.getTextParticlesMng().showTextParticle(_loc10_,_loc11_,_loc3_,-1,Align.RIGHT);
                  }
                  if(_loc8_)
                  {
                     _loc14_ = _loc3_.getCardDef().getDamage();
                     _loc15_ = _loc3_.getOriginalDamage();
                     _loc16_ = _loc14_ - _loc3_.getOriginalDamage();
                     _loc3_.addDamage(_loc16_);
                     _loc10_ = _loc16_ >= 0 ? "+" + _loc16_.toString() : _loc16_.toString();
                     if(!_loc3_.getDieOnEndTurn())
                     {
                        _loc11_ = _loc16_ >= 0 ? _loc11_ : TextParticlesMng.COLOR_DAMAGE_RECEIVED_STD;
                     }
                     InstanceMng.getTextParticlesMng().showTextParticle(_loc10_,_loc11_,_loc3_,-1,Align.LEFT);
                  }
                  if(_loc9_)
                  {
                     this.performSpy(_loc3_);
                     _loc3_.addAbilities();
                     _loc17_ = null;
                     _loc17_ = _loc3_.getAttachments();
                     if(_loc17_ != null)
                     {
                        for each(_loc18_ in _loc17_)
                        {
                           _loc18_.addAbilities();
                        }
                     }
                     _loc3_.createAbilitiesIcons();
                  }
                  InstanceMng.getCardAnimsMng().requestHealAnimation(_loc2_);
                  _loc3_.updateStatsAfterAttack(_loc3_.getDefense());
                  _loc3_.showAbilityBeingAppliedIcon(this);
               }
            }
            _loc6_++;
         }
      }
      
      protected function performSpy(param1:FSCard) : void
      {
         var _loc2_:Vector.<FSAttachment> = null;
         var _loc3_:FSAttachment = null;
         var _loc4_:Ability = null;
         var _loc5_:Vector.<Ability> = null;
         param1.removeAbilityIcons();
         if(param1 is FSUnit)
         {
            this.removeCardAbilitiesEffects(FSUnit(param1));
            _loc2_ = null;
            _loc2_ = param1.getAttachments();
            if(_loc2_ != null)
            {
               for each(_loc3_ in _loc2_)
               {
                  _loc3_.removeAbilityIcons();
                  _loc3_.nullifyAbilities();
               }
            }
         }
         param1.nullifyAbilities();
      }
      
      private function removeCardAbilitiesEffects(param1:FSUnit) : void
      {
         var _loc2_:Vector.<Ability> = null;
         var _loc3_:Ability = null;
         var _loc4_:String = null;
         if(param1)
         {
            _loc2_ = param1.getCompositeAbilitiesVector();
            if(_loc2_)
            {
               for each(_loc3_ in _loc2_)
               {
                  if(!_loc3_)
                  {
                     continue;
                  }
                  _loc4_ = _loc3_.getAbilityDef().getKeyName();
                  switch(_loc4_)
                  {
                     case AbilitiesMng.SPECIAL_PERMANENTUNBLOCKABLE:
                        param1.setUnblockableTurns(0);
                        break;
                     case AbilitiesMng.SPECIAL_RISING:
                        param1.setInvulnerableTurns(0);
                        break;
                     case AbilitiesMng.SPECIAL_POISON:
                        param1.setPoisonTurns(0);
                  }
               }
            }
            param1.setInvulnerableTurns(0);
            param1.setPoisonTurns(0);
            param1.setUnblockableTurns(0);
            param1.setTurnsToBeAbleToAttack(0);
            param1.setTurnsAmountWithoutMovingToAttackLane(0);
         }
      }
      
      private function performDefaultOps(param1:Array) : void
      {
         var execAbilityForCard:Function;
         var execAbilityForUserBattleInfo:Function;
         var item:* = undefined;
         var card:FSCard = null;
         var uInfo:UserBattleInfo = null;
         var destroy:Boolean = false;
         var defense:FSNumber = null;
         var damage:FSNumber = null;
         var heal:FSNumber = null;
         var defenseFactor:Number = NaN;
         var damageFactor:Number = NaN;
         var multiplierCards:int = 0;
         var numCards:int = 0;
         var userBattleInfo:UserBattleInfo = null;
         var i:int = 0;
         var animDuration:Number = NaN;
         var abTriggererAnim:CardAnimation = null;
         var attackerIsSniper:Boolean = false;
         var pvpObj:Object = null;
         var pvpTargetObj:Object = null;
         var rndDamage:int = 0;
         var rndDefense:int = 0;
         var rndHeal:int = 0;
         var cardIsInvulnerable:Boolean = false;
         var abIsHarmful:Boolean = false;
         var cardStatsWillVary:Boolean = false;
         var eligibleItems:Array = param1;
         var cardIsEligible:Boolean = true;
         var eligibleItemsLength:int = eligibleItems ? int(eligibleItems.length) : 0;
         i = 0;
         while(i < eligibleItemsLength)
         {
            defense = new FSNumber();
            damage = new FSNumber();
            heal = new FSNumber();
            item = eligibleItems[i];
            multiplierCards = this.mAbilityDef.getMultiplierByCard();
            destroy = this.mAbilityDef.getDestroy();
            damage.value = this.mAbilityDef.getDamage();
            defense.value = this.mAbilityDef.getDefense();
            damageFactor = this.mAbilityDef.getDamageFactor();
            defenseFactor = this.mAbilityDef.getDefenseFactor();
            heal.value = this.mAbilityDef.getHeal();
            switch(multiplierCards)
            {
               case AbilitiesMng.MULTIPLIER_BY_CARDS_BATTLEFIELD:
                  userBattleInfo = InstanceMng.getBattleEngine().isOwnerTurn() ? InstanceMng.getBattleEngine().getOwnerBattleInfo() : InstanceMng.getBattleEngine().getOpponentBattleInfo();
                  numCards = DictionaryUtils.getDictionaryLength(this.getElegibleCards(userBattleInfo.getFightCards()));
                  damage.value *= numCards;
                  defense.value *= numCards;
                  damageFactor *= numCards;
                  defenseFactor *= numCards;
                  heal.value *= numCards;
                  break;
               case AbilitiesMng.MULTIPLIER_BY_CARDS_DECK:
                  userBattleInfo = InstanceMng.getBattleEngine().isOwnerTurn() ? InstanceMng.getBattleEngine().getOwnerBattleInfo() : InstanceMng.getBattleEngine().getOpponentBattleInfo();
                  numCards = DictionaryUtils.getDictionaryLength(this.getElegibleCards(userBattleInfo.getPlayableCardsCatalog()));
                  damage.value *= numCards;
                  defense.value *= numCards;
                  damageFactor *= numCards;
                  defenseFactor *= numCards;
                  heal.value *= numCards;
            }
            this.updatePvPRandomPropertyChanged(item,damage.value,defense.value,heal.value,i,eligibleItemsLength);
            if(!this.mIsPassive && !PvPConnectionMng.isPlayingVSAI() && InstanceMng.getBattleEngine().isOnlineMatch() && !InstanceMng.getBattleEngine().isOwnerTurn())
            {
               pvpObj = this.getParentCard() ? BattleEnginePvP(InstanceMng.getBattleEngine()).getPvPObjectByCardId(this.getParentCard().getId()) : null;
               if(pvpObj)
               {
                  pvpTargetObj = PvPConnectionMng.getRandomAttributeTargetPvPObject(item,pvpObj);
                  if(pvpTargetObj is Object && pvpTargetObj != null && pvpTargetObj.hasOwnProperty("mRandomDamage") && pvpTargetObj["mRandomDamage"] != null)
                  {
                     rndDamage = PvPConnectionMng.getRandomAttributeFromTarget(item,"mRandomDamage",pvpObj);
                     damage.value = this.mAbilityDef.getDefaultDamage() + rndDamage;
                  }
                  if(pvpTargetObj is Object && pvpTargetObj != null && pvpTargetObj.hasOwnProperty("mRandomDefense") && pvpTargetObj["mRandomDefense"] != null)
                  {
                     rndDefense = PvPConnectionMng.getRandomAttributeFromTarget(item,"mRandomDefense",pvpObj);
                     defense.value = this.mAbilityDef.getDefaultDefense() + rndDefense;
                  }
                  if(pvpTargetObj is Object && pvpTargetObj != null && pvpTargetObj.hasOwnProperty("mRandomHeal") && pvpTargetObj["mRandomHeal"] != null)
                  {
                     rndHeal = PvPConnectionMng.getRandomAttributeFromTarget(item,"mRandomHeal",pvpObj);
                     heal.value = this.mAbilityDef.getDefaultHeal() + rndHeal;
                  }
               }
            }
            animDuration = this.mAbilityDef.getAnimDuration() > 0 ? this.mAbilityDef.getAnimDuration() * Utils.getDefaultSpeedTime() : 0;
            abTriggererAnim = this.mParentCard ? InstanceMng.getCardAnimsMng().requestCardAnimDamageDealed(this.mParentCard) : null;
            attackerIsSniper = this.mParentCard ? this.mParentCard.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_SNIPER) != null : false;
            animDuration = abTriggererAnim != null && abTriggererAnim is BulletsAnim && !attackerIsSniper ? BulletsAnim(abTriggererAnim).getAmmoSpeed() : animDuration;
            if(item is FSCard)
            {
               card = FSCard(item);
               card = this.getUnitFromAttachment(card);
               cardIsEligible = this.getAbilityDef().isCardEligibleForAbility(card);
               if(cardIsEligible)
               {
                  execAbilityForCard = function(param1:Ability, param2:FSCard, param3:*, param4:Boolean, param5:FSNumber, param6:FSNumber, param7:FSNumber, param8:Number, param9:Number, param10:Boolean):void
                  {
                     var _loc11_:String = null;
                     var _loc12_:uint = 0;
                     var _loc13_:uint = 0;
                     var _loc14_:Boolean = false;
                     var _loc15_:int = 0;
                     var _loc16_:Number = NaN;
                     var _loc17_:Number = NaN;
                     var _loc18_:int = 0;
                     var _loc19_:uint = 0;
                     if(mParentCard != param2)
                     {
                        if((param6.value < 0 || param9 < 0) && param10)
                        {
                           param2.performAttackMovement(false,null,null,null,true);
                        }
                     }
                     if(param4)
                     {
                        _loc11_ = param10 ? "-" + param2.getDefense() : "-0";
                        if(param10)
                        {
                           param2.addDefense(param2.getDefense() * -1);
                        }
                        InstanceMng.getTextParticlesMng().showTextParticle(_loc11_,TextParticlesMng.COLOR_DAMAGE_RECEIVED_ABILITY,param2,-1,Align.RIGHT);
                        InstanceMng.getCardAnimsMng().requestDebuffAnimation(param3);
                     }
                     else
                     {
                        if(param5.value != 0)
                        {
                           _loc14_ = param2.getDamage() + param5.value < 0;
                           if(!_loc14_)
                           {
                              param2.addDamage(param5.value);
                           }
                           else
                           {
                              param2.addDamage(-param2.getDamage());
                           }
                           if(InstanceMng.getBattleEngine().isCardEligibleToBeZoomedOutAfterCombat(param2))
                           {
                              SpecialFX.zoomOut(param2);
                           }
                           _loc13_ = param5.value > 0 ? TextParticlesMng.COLOR_HEAL_RECEIVED : TextParticlesMng.COLOR_DAMAGE_RECEIVED_ABILITY;
                           _loc13_ = param2.getDieOnEndTurn() ? TextParticlesMng.COLOR_INACTIVE : _loc13_;
                           _loc11_ = param5.value > 0 ? "+" + param5.value.toString() : param5.value.toString();
                           InstanceMng.getTextParticlesMng().showTextParticle(_loc11_,_loc13_,param2,-1,Align.LEFT);
                           if(param5.value < 0)
                           {
                              InstanceMng.getCardAnimsMng().requestDebuffAnimation(param3);
                           }
                        }
                        _loc15_ = Config.getConfig().battleGetMaxAddition();
                        if(param8 != 0)
                        {
                           _loc16_ = int(Math.floor(param2.getDamage() * param8));
                           _loc16_ = _loc16_ > _loc15_ ? _loc15_ : _loc16_;
                           _loc14_ = param2.getDamage() + _loc16_ < 0;
                           if(!_loc14_)
                           {
                              param2.addDamage(_loc16_);
                           }
                           else
                           {
                              param2.addDamage(-param2.getDamage());
                           }
                           if(InstanceMng.getBattleEngine().isCardEligibleToBeZoomedOutAfterCombat(param2))
                           {
                              SpecialFX.zoomOut(param2);
                           }
                           _loc13_ = _loc16_ > 0 ? TextParticlesMng.COLOR_HEAL_RECEIVED : TextParticlesMng.COLOR_DAMAGE_RECEIVED_ABILITY;
                           _loc13_ = param2.getDieOnEndTurn() ? TextParticlesMng.COLOR_INACTIVE : _loc13_;
                           _loc11_ = _loc16_ > 0 ? "+" + _loc16_.toString() : _loc16_.toString();
                           InstanceMng.getTextParticlesMng().showTextParticle(_loc11_,_loc13_,param2,-1,Align.LEFT);
                           if(_loc16_ < 0)
                           {
                              InstanceMng.getCardAnimsMng().requestDebuffAnimation(param3);
                           }
                        }
                        if(param6.value != 0)
                        {
                           if(param10)
                           {
                              param2.addDefense(param6.value);
                           }
                           _loc12_ = param6.value > 0 ? TextParticlesMng.COLOR_HEAL_RECEIVED : TextParticlesMng.COLOR_DAMAGE_RECEIVED_ABILITY;
                           _loc12_ = param2.getDieOnEndTurn() ? TextParticlesMng.COLOR_INACTIVE : _loc12_;
                           _loc11_ = param6.value > 0 ? "+" + param6.value.toString() : param6.value.toString();
                           if(!param10 && param6.value < 0)
                           {
                              _loc11_ = "-0";
                           }
                           InstanceMng.getTextParticlesMng().showTextParticle(_loc11_,_loc12_,param2,-1,Align.RIGHT);
                           if(param6.value >= 0)
                           {
                              InstanceMng.getCardAnimsMng().requestHealAnimation(param3);
                           }
                           else
                           {
                              InstanceMng.getCardAnimsMng().requestDebuffAnimation(param3);
                           }
                        }
                        if(param9 != 0)
                        {
                           _loc17_ = int(Math.floor(param2.getDefense() * param9));
                           _loc17_ = _loc17_ > _loc15_ ? _loc15_ : _loc17_;
                           if(param10)
                           {
                              param2.addDefense(_loc17_);
                           }
                           _loc12_ = _loc17_ > 0 ? TextParticlesMng.COLOR_HEAL_RECEIVED : TextParticlesMng.COLOR_DAMAGE_RECEIVED_ABILITY;
                           _loc12_ = param2.getDieOnEndTurn() ? TextParticlesMng.COLOR_INACTIVE : _loc12_;
                           _loc11_ = _loc17_ > 0 ? "+" + _loc17_.toString() : _loc17_.toString();
                           if(!param10 && _loc17_ < 0)
                           {
                              _loc11_ = "-0";
                           }
                           InstanceMng.getTextParticlesMng().showTextParticle(_loc11_,_loc12_,param2,-1,Align.RIGHT);
                           if(_loc17_ >= 0)
                           {
                              InstanceMng.getCardAnimsMng().requestHealAnimation(param3);
                           }
                           else
                           {
                              InstanceMng.getCardAnimsMng().requestDebuffAnimation(param3);
                           }
                        }
                        if(param7.value != 0)
                        {
                           _loc18_ = param2 is FSUnit ? FSUnit(param2).getUpdatedCompositeDefense() : param2.getDefense();
                           if(_loc18_ < param2.getDefense() && param7.value > 0)
                           {
                              param7.value = 0;
                           }
                           else if(param7.value > 0)
                           {
                              param7.value = param2.getDefense() + param7.value <= _loc18_ ? param7.value : _loc18_ - param2.getDefense();
                           }
                           else
                           {
                              param7.value = param2.getDefense() + param7.value <= 0 ? -param2.getDefense() : param7.value;
                           }
                           if(param10)
                           {
                              param2.addDefense(param7.value);
                           }
                           _loc11_ = param7.value >= 0 ? "+" + param7.value.toString() : param7.value.toString();
                           if(!param10 && param7.value < 0)
                           {
                              _loc11_ = "-0";
                           }
                           _loc19_ = param7.value >= 0 ? TextParticlesMng.COLOR_HEAL_RECEIVED : TextParticlesMng.COLOR_DAMAGE_RECEIVED_STD;
                           _loc19_ = param2.getDieOnEndTurn() ? TextParticlesMng.COLOR_INACTIVE : _loc19_;
                           InstanceMng.getTextParticlesMng().showTextParticle(_loc11_,_loc19_,param2,-1,Align.RIGHT);
                           if(param7.value != 0)
                           {
                              if(param7.value > 0)
                              {
                                 InstanceMng.getCardAnimsMng().requestHealAnimation(param3);
                              }
                              else
                              {
                                 InstanceMng.getCardAnimsMng().requestDebuffAnimation(param3);
                              }
                           }
                        }
                     }
                     param2.updateStatsAfterAttack(param2.getDefense());
                     param2.showAbilityBeingAppliedIcon(param1);
                  };
                  card.deactivateHighlightTween();
                  cardIsInvulnerable = card is FSUnit && FSUnit(card).getInvulnerableTurns() > 0;
                  abIsHarmful = destroy || defense.value < 0 || heal.value < 0;
                  cardStatsWillVary = abIsHarmful && !cardIsInvulnerable || !abIsHarmful;
                  this.activateEligibleCardFX(card);
                  TweenMax.delayedCall(animDuration,execAbilityForCard,[this,card,item,destroy,damage,defense,heal,damageFactor,defenseFactor,cardStatsWillVary]);
               }
            }
            if(item is UserBattleInfo)
            {
               execAbilityForUserBattleInfo = function(param1:UserBattleInfo, param2:FSNumber):void
               {
                  var _loc3_:Boolean = false;
                  if(param2.value != 0)
                  {
                     _loc3_ = param2.value < 0 && (param1.isOwnerBattleInfo() && InstanceMng.getBattleEngine().getTurnsWithoutTakingDamage() > 0 || param1.getInvulnerableTurns() > 0);
                     if(!_loc3_)
                     {
                        param1.modifyHP(param2,true);
                        if(param2.value >= 0)
                        {
                           InstanceMng.getCardAnimsMng().requestHealAnimation(param1.getUserBattlePortrait().getFrameContainer());
                        }
                        else
                        {
                           InstanceMng.getCardAnimsMng().requestDebuffAnimation(param1.getUserBattlePortrait().getFrameContainer());
                        }
                     }
                     else
                     {
                        param1.getUserBattlePortrait().performInvulnerableAnim();
                        TweenMax.delayedCall(Config.getConfig().getDefaultAbilityAnimDuration(),checkIfBattleEngineBattleOver,[false]);
                     }
                  }
               };
               uInfo = UserBattleInfo(item);
               uInfo.getUserBattlePortrait().showAbilityBeingAppliedIcon(this);
               if(Config.getConfig().getShowAbilitiesAnimations())
               {
                  InstanceMng.getCardAnimsMng().requestCardAnimAbility(this,uInfo.getUserBattlePortrait().getFrameContainer());
               }
               setTimeout(execAbilityForUserBattleInfo,animDuration,uInfo,heal);
            }
            i++;
         }
      }
      
      private function getElegibleCards(param1:Dictionary) : Dictionary
      {
         var _loc2_:FSCard = null;
         var _loc4_:String = null;
         var _loc3_:Boolean = false;
         var _loc5_:Dictionary = new Dictionary(true);
         var _loc6_:int = 0;
         for each(_loc2_ in param1)
         {
            _loc3_ = this.mAbilityDef.getCategorySku() == null || this.mAbilityDef.getCategorySku() == _loc2_.getCardDef().getCategorySku();
            if(_loc3_)
            {
               _loc3_ = Utils.isAnySubcategorySkuAllowed(this.mAbilityDef.getSubCategorySku(),_loc2_.getCardDef().getSubCategorySku());
            }
            if(_loc3_)
            {
               _loc4_ = this.mAbilityDef.getFactionSku();
               _loc3_ = _loc4_ == null || _loc4_ == "" || _loc4_ == _loc2_.getCardDef().getFactionSku();
            }
            if(_loc3_)
            {
               _loc3_ = Utils.isAnyGroupIdAllowed(this.mAbilityDef.getGroupsIds(),_loc2_.getCardDef().getGroupsIds());
            }
            if(_loc3_)
            {
               _loc5_[_loc6_] = _loc2_;
               _loc6_++;
            }
         }
         return _loc5_;
      }
      
      private function checkIfBattleEngineBattleOver(param1:Boolean) : void
      {
         if(InstanceMng.getBattleEngine())
         {
            InstanceMng.getBattleEngine().checkIfBattleOver(param1);
         }
      }
      
      public function hasAnimation() : Boolean
      {
         return this.mAbilityDef.getAnimKey() != null && this.mAbilityDef.getAnimKey() != "";
      }
      
      protected function getUnitFromAttachment(param1:FSCard) : FSCard
      {
         var _loc2_:FSCardSocket = null;
         var _loc3_:FSUnit = null;
         if(!param1.isUnit())
         {
            if(param1 is FSAttachment)
            {
               _loc2_ = FSAttachment(param1).getAttachedToSocket();
               if(_loc2_ != null)
               {
                  _loc3_ = FSUnit(_loc2_.getParentCard());
                  if(_loc3_ != null)
                  {
                     param1 = _loc3_;
                  }
               }
            }
         }
         return param1;
      }
      
      protected function activateEligibleCardFX(param1:FSCard) : void
      {
         var _loc2_:ColorArgb = new ColorArgb(0.4,0.1,0.9,1);
         var _loc3_:ColorArgb = new ColorArgb(0.4,0,0.9,0);
         param1.activateHighlightTween(13959381,false,1,_loc2_,_loc3_);
         TweenMax.delayedCall(Config.getConfig().getDefaultHighlightDeactivationAnimDuration(),this.deactivateCardHighlightTween,[param1]);
         if(Config.getConfig().getShowAbilitiesAnimations())
         {
            InstanceMng.getCardAnimsMng().requestCardAnimAbility(this,param1);
         }
      }
      
      private function deactivateCardHighlightTween(param1:FSCard) : void
      {
         if(param1)
         {
            param1.deactivateHighlightTween();
         }
      }
      
      protected function onAbilitiesPerformed(param1:Array) : void
      {
         var _loc2_:UserBattleInfo = null;
         var _loc3_:int = 0;
         var _loc4_:UserBattleInfo = null;
         if(Config.TRACE_BATTLE_LOGS)
         {
            FSDebug.debugTrace("Ability Triggered: " + this.getAbilityDef().getDesc());
         }
         if(param1 != null && param1.length > 0)
         {
            if(this.mParentCard != null && (this.mParentCard is FSAction && !(this.mParentCard is FSEvent)))
            {
               if(param1[0] is FSCard)
               {
                  this.mParentCard.setAttachedToSocket(null,false,this.mParentCard.isEnemyCard());
               }
               else
               {
                  _loc2_ = UserBattleInfo(param1[0]);
                  this.mParentCard.setAttachedToSocket(null,false,this.mParentCard.isEnemyCard());
               }
            }
         }
         else if(this.mParentCard != null && this.mParentCard is FSAction && param1 != null && param1.length == 0)
         {
            this.mParentCard.setAttachedToSocket(null,false,this.mParentCard.isEnemyCard());
         }
         if(InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            _loc3_ = InstanceMng.getBattleEngine().getPlayersStateId();
            if(_loc3_ != BattleEngine.STATE_OWNER_TRIGGER_ON_END_ABILITIES && _loc3_ != BattleEngine.STATE_OPPONENT_TRIGGER_ON_END_ABILITIES)
            {
               (InstanceMng.getCurrentScreen() as FSBattleScreen).suggestPlayableCardON();
            }
            _loc4_ = InstanceMng.getBattleEngine().isOwnerTurn() ? InstanceMng.getBattleEngine().getOwnerBattleInfo() : InstanceMng.getBattleEngine().getOpponentBattleInfo();
            if(Config.getConfig().gameHasPowers() && this.isParentCardPower())
            {
               InstanceMng.getBattleEngine().setPowerWaitingForTarget(false);
               _loc4_.setPowerAvailable(false,true);
            }
         }
      }
      
      public function highlightPossibleTargetsForAbility(param1:Boolean = false) : Boolean
      {
         var _loc4_:FSBattleScreen = null;
         var _loc5_:int = 0;
         var _loc6_:FSCard = null;
         var _loc7_:Boolean = false;
         var _loc8_:Vector.<UserBattleInfo> = null;
         var _loc9_:Vector.<FSCardSocket> = null;
         var _loc10_:FSCardSocket = null;
         var _loc11_:int = 0;
         var _loc12_:Boolean = false;
         var _loc13_:Vector.<FSCardSocket> = null;
         var _loc14_:int = 0;
         var _loc15_:ColorArgb = null;
         var _loc16_:ColorArgb = null;
         var _loc2_:Boolean = false;
         var _loc3_:BattleEngine = InstanceMng.getBattleEngine();
         if(Boolean(_loc3_) && InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            _loc4_ = FSBattleScreen(InstanceMng.getCurrentScreen());
            _loc6_ = this.getParentCard();
            if(Boolean(_loc3_) && Boolean(_loc4_) && Boolean(_loc6_))
            {
               _loc7_ = _loc3_.isOwnerTurn();
               _loc8_ = _loc6_ ? _loc6_.fillUserBattleInfosPlayableByAbilitiesOnCard() : null;
               if(_loc8_ != null)
               {
                  _loc2_ = true;
               }
               _loc9_ = _loc6_ ? _loc6_.fillSocketsPlayableByAbilitiesOnCard() : null;
               if(_loc9_ != null)
               {
                  _loc2_ = true;
                  if(!param1)
                  {
                     _loc11_ = _loc9_ ? int(_loc9_.length) : 0;
                     _loc5_ = 0;
                     while(_loc5_ < _loc11_)
                     {
                        _loc10_ = _loc9_[_loc5_];
                        _loc6_.addCardSocketToPlayableSocketsVector(_loc10_);
                        _loc5_++;
                     }
                  }
               }
               if(_loc2_ && !param1)
               {
                  _loc12_ = _loc7_ || _loc3_.isPvPMatch() && !_loc3_.isOnlineMatch();
                  if(_loc12_)
                  {
                     _loc13_ = _loc6_.getPlayableSockets();
                     _loc14_ = _loc13_ ? int(_loc13_.length) : 0;
                     _loc5_ = 0;
                     while(_loc5_ < _loc14_)
                     {
                        _loc10_ = _loc13_[_loc5_];
                        if((Boolean(_loc10_)) && !_loc10_.isEmpty())
                        {
                           _loc15_ = new ColorArgb(0.4,0.1,0.9,1);
                           _loc16_ = new ColorArgb(0.4,0,0.9,0);
                           _loc10_.activateHighlightTween(65280,true,1,_loc15_,_loc16_);
                        }
                        _loc5_++;
                     }
                  }
                  _loc6_.highlightPlayablePortraitsVector(_loc8_);
               }
            }
         }
         return _loc2_;
      }
      
      public function onPlayableItemsHighlighted() : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:FSCardSocket = null;
         var _loc4_:Boolean = false;
         var _loc5_:Vector.<FSCardSocket> = null;
         var _loc6_:Vector.<UserBattleInfo> = null;
         var _loc7_:Vector.<FSCardSocket> = null;
         var _loc1_:BattleEngine = InstanceMng.getBattleEngine();
         if(_loc1_)
         {
            _loc2_ = _loc1_.isOwnerTurn();
            _loc4_ = false;
            _loc5_ = this.getParentCard() ? this.getParentCard().getPlayableSockets() : null;
            _loc6_ = this.getParentCard() ? this.getParentCard().fillUserBattleInfosPlayableByAbilitiesOnCard() : null;
            _loc4_ = _loc5_ != null && _loc5_.length > 0 || _loc6_ != null && _loc6_.length > 0;
            if(_loc4_)
            {
               _loc7_ = _loc2_ || _loc1_.isPvPMatch() ? _loc5_ : null;
               _loc1_.enableBFCards(false,_loc7_);
               _loc1_.enableSideDeck(false);
               this.disableAttackButton();
               if(Config.getConfig().gameHasSacrifice())
               {
                  _loc1_.enableSacrificeButton(false);
               }
               else if(Config.getConfig().gameHasPowers() && !(this.mParentCard is FSPower))
               {
                  if(_loc2_)
                  {
                     _loc1_.enableOwnerPowerButton(false);
                  }
                  else
                  {
                     _loc1_.enableOpponentPowerButton(false);
                  }
               }
               _loc1_.setAbilityWaitingForTarget(this,_loc5_,_loc6_);
            }
            else if(_loc1_.isOnlineMatch() && !_loc2_)
            {
               _loc1_.setAbilityWaitingForTarget(this,_loc5_,_loc6_);
            }
            else
            {
               this.onTargetSelected(null);
            }
         }
      }
      
      public function onTargetSelected(param1:Array) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:AbilityDef = null;
         var _loc4_:Number = NaN;
         if(InstanceMng.getBattleEngine())
         {
            if(Boolean(this.mParentCard) && !(this.mParentCard is FSPower))
            {
               this.mParentCard.executePassive();
            }
            this.trackCombatLogAbilityExecuted(param1);
            Utils.removeLog();
            if(InstanceMng.getBattleEngine().getBattleScreen())
            {
               InstanceMng.getBattleEngine().getBattleScreen().closeAbilitiesChooserPanel();
            }
            this.performAbilityOperations(param1);
            if(this.mParentCard != null)
            {
               InstanceMng.getSoundFXMng().playCardSound(this.mParentCard,FSSoundFXMng.CARD_MOVED_TO_BF);
               this.mParentCard.unHighlightPlayableSocketsVector();
               this.mParentCard.unHighlightPlayablePortraitsVector();
            }
            _loc2_ = Boolean(this.mParentCard) && this.mParentCard is FSAction;
            _loc3_ = this.mParentCard ? this.mParentCard.getCostModifierAbilityDef() : null;
            if(!_loc2_ && Boolean(this.mParentCard))
            {
               InstanceMng.getBattleEngine().notifyActionDone(this.mParentCard.getCardCostByType(_loc3_));
            }
            if(this.mParentCard)
            {
               this.mParentCard.updateAbilitiesAppliedOnNextCard(true,this);
            }
            if(InstanceMng.getBattleEngine().getBattleScreen())
            {
               InstanceMng.getBattleEngine().getBattleScreen().suggestPlayableCardON();
            }
            InstanceMng.getBattleEngine().setAbilityWaitingForTarget(null,null,null);
            _loc4_ = Config.getConfig().getShowAbilitiesAnimations() && this.hasAnimation() ? CardAnimation.getMaxDuration() : 0.01;
            _loc4_ = _loc4_ + (this.getAbilityDef() ? InstanceMng.getAbilitiesDefMng().getOnTargetSelectedExtraDelay(this.getAbilityDef().getKeyName()) : 0);
            TweenMax.delayedCall(_loc4_,this.onTargetSelectedAnimationComplete);
         }
      }
      
      private function onTargetSelectedAnimationComplete() : void
      {
         var _loc2_:ActionPointsCounter = null;
         var _loc1_:BattleEngine = InstanceMng.getBattleEngine();
         if(_loc1_)
         {
            if(_loc1_.getBattleScreen())
            {
               _loc1_.getBattleScreen().setCardAnimsON(false);
            }
            _loc1_.resetUILock();
            _loc1_.checkCardsKilledInCombat();
            _loc1_.checkIfBattleOver(false);
            if(_loc1_.getBattleScreen())
            {
               _loc1_.getBattleScreen().setEnemyActionBeingTriggered(null);
            }
            if(Config.getConfig().gameHasPowers() && Boolean(_loc1_.getBattleScreen()))
            {
               _loc2_ = _loc1_.getBattleScreen().getActionPointsCounter(_loc1_.isOwnerTurn());
               if(_loc2_)
               {
                  if(_loc1_.isOwnerTurn())
                  {
                     if(Boolean(_loc1_.getOwnerPower()) && Boolean(_loc1_.getOwnerBattleInfo()))
                     {
                        if(_loc2_.getAPLeft() >= _loc1_.getOwnerPower().getCardCostByType() && _loc1_.getOwnerBattleInfo().isPowerAvailable())
                        {
                           _loc1_.enableOwnerPowerButton(true);
                        }
                     }
                  }
                  else if(Boolean(_loc1_.getOpponentPower()) && Boolean(_loc1_.getOpponentBattleInfo()))
                  {
                     if(_loc2_.getAPLeft() >= _loc1_.getOpponentPower().getCardCostByType() && _loc1_.getOpponentBattleInfo().isPowerAvailable())
                     {
                        _loc1_.enableOpponentPowerButton(true);
                     }
                  }
               }
            }
         }
      }
      
      public function canBeExecuted(param1:FSCard = null) : Boolean
      {
         var _loc2_:Boolean = false;
         _loc2_ = this.isAlive() && InstanceMng.getAbilitiesMng().isAbilityTriggereable(this);
         return param1 != null ? _loc2_ && this.getAbilityDef().isCardEligibleForAbility(param1) : _loc2_;
      }
      
      private function isAlive() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = this.mAbilityDef.getDuration();
         _loc1_ = _loc2_ != -1 && _loc2_ != -2 ? this.mTurnsAlive < _loc2_ : true;
         return Boolean(this.mParentCard) && this.mParentCard is FSPower ? true : _loc1_;
      }
      
      public function canBeExecutedAndHasTargets(param1:FSCard = null) : Boolean
      {
         var _loc5_:int = 0;
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = this.isAlive() && InstanceMng.getAbilitiesMng().isAbilityTriggereable(this);
         if(!_loc3_)
         {
            return false;
         }
         var _loc4_:Array = InstanceMng.getAbilitiesMng().getEligibleTargetsByTargetIndex(this.mAbilityDef,this.getParentCard(),this.mAbilityDef.getCostRange());
         if(_loc4_ != null && _loc4_.length > 0)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               if(param1 == null || param1 != null && param1 == _loc4_[_loc5_])
               {
                  if(!(_loc4_[_loc5_] is FSCard))
                  {
                     return true;
                  }
                  if(this.getAbilityDef().isCardEligibleForAbility(_loc4_[_loc5_]))
                  {
                     return true;
                  }
               }
               _loc5_++;
            }
         }
         return _loc2_;
      }
      
      public function getAbilityDef() : AbilityDef
      {
         return this.mAbilityDef;
      }
      
      public function setAbilityDef(param1:AbilityDef) : void
      {
         this.mAbilityDef = param1;
      }
      
      public function getTurnsAlive() : int
      {
         return this.mTurnsAlive;
      }
      
      public function setTurnsAlive(param1:int) : void
      {
         this.mTurnsAlive = param1;
      }
      
      public function increaseTurnsAlive() : void
      {
         this.mTurnsAlive += 1;
      }
      
      public function getParentCard() : FSCard
      {
         return this.mParentCard;
      }
      
      public function isAbilityPassive() : Boolean
      {
         return this.mIsPassive;
      }
      
      public function destroy() : void
      {
         this.mParentCard = null;
      }
      
      public function setParentAbilityRef(param1:AbilityDef) : void
      {
         this.mParentAbilityDef = param1;
      }
      
      public function getParentAbilityRef() : AbilityDef
      {
         return this.mParentAbilityDef;
      }
   }
}

