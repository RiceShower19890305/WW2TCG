package com.fs.tcgengine.view.components.battle
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.battle.BattleEnginePvP;
   import com.fs.tcgengine.model.rules.AbilityDef;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.model.userdata.UserBattleInfo;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.TimerUtil;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSAction;
   import com.fs.tcgengine.view.cards.FSAttachment;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.FSPower;
   import com.fs.tcgengine.view.cards.FSUnit;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import starling.events.Event;
   import starling.utils.Align;
   
   public class FSAttackButton extends Component
   {
      
      private const BG_NAME:String = "attack_button_panel";
      
      private const BUTTON_UP_NAME:String = "attack_button_2";
      
      private const BUTTON_DOWN_NAME:String = "attack_button_3";
      
      private const BUTTON_DISABLED_NAME:String = "attack_button_disabled";
      
      protected const BUTTON_ALARM_LAYER:String = "attack_button_alert";
      
      protected var mButton:FSButton;
      
      private var mBG:FSImage;
      
      protected var mBGAlertLayer:FSImage;
      
      private var mUnlockTime:Number = 0;
      
      public var mTurnsTextfield:FSTextfield;
      
      private var mHasSimpleUI:Boolean;
      
      public function FSAttackButton()
      {
         super();
         this.mHasSimpleUI = Config.getConfig().battleHasSimpleUI();
         this.init();
      }
      
      private function init() : void
      {
         this.createBG();
         this.createButton();
         this.createTurnsTextfield();
      }
      
      protected function createButton() : void
      {
         if(this.mButton == null)
         {
            this.mButton = new FSButton(Root.assets.getTexture(this.BUTTON_UP_NAME),"",Root.assets.getTexture(this.BUTTON_DOWN_NAME),false,null,Root.assets.getTexture(this.BUTTON_DISABLED_NAME));
            this.mButton.alphaWhenDisabled = 1;
         }
         this.mButton.y = this.mBG ? this.mBG.height / 1.99 : 0;
         if(this.mHasSimpleUI)
         {
            this.mButton.x = this.mBG ? this.mBG.width / 2.6 : 0;
         }
         else
         {
            this.mButton.x = 0;
            if(this.mBGAlertLayer)
            {
               this.mBGAlertLayer.x -= this.mButton.width / 2;
            }
         }
         if(Config.getConfig().attackButtonHasText())
         {
            this.mButton.fontName = FSResourceMng.getFontByType();
            this.mButton.fontColor = 16777215;
            this.mButton.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
            this.mButton.text = TextManager.getText("TID_GEN_FIGHT");
         }
         this.mButton.addEventListener(Event.TRIGGERED,this.onAttackButtonClick);
         addChild(this.mButton);
      }
      
      protected function createBG() : void
      {
         if(Config.getConfig().attackButtonHasBG())
         {
            if(this.mBG == null)
            {
               this.mBG = new FSImage(Root.assets.getTexture(this.BG_NAME));
            }
            this.mBG.touchable = false;
            addChild(this.mBG);
         }
         if(this.mBGAlertLayer == null)
         {
            this.mBGAlertLayer = new FSImage(Root.assets.getTexture(this.BUTTON_ALARM_LAYER));
            if(this.mHasSimpleUI)
            {
               this.mBGAlertLayer.alignPivot();
               this.mBGAlertLayer.x = width / 1.8;
               this.mBGAlertLayer.y = height / 2.01;
            }
            else
            {
               this.mBGAlertLayer.x = 0;
               this.mBGAlertLayer.y = -this.mBGAlertLayer.height / 2;
            }
         }
         this.mBGAlertLayer.touchable = false;
      }
      
      public function getTurnsTextfield() : FSTextfield
      {
         return this.mTurnsTextfield;
      }
      
      private function createTurnsTextfield() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:Boolean = Config.getConfig().gameTurnsSimple();
         if(_loc1_)
         {
            if(this.mTurnsTextfield == null && _loc1_)
            {
               _loc2_ = 0.75;
               _loc3_ = this.mButton.width * 0.813 - _loc2_;
               _loc4_ = this.mButton.height;
               this.mTurnsTextfield = new FSTextfield(_loc3_,_loc4_,"",16777215,FSResourceMng.FONT_STD_DEFAULT_SIZE);
               this.mTurnsTextfield.format.horizontalAlign = Align.CENTER;
               this.mTurnsTextfield.touchable = false;
               this.mTurnsTextfield.alignPivot();
               this.mTurnsTextfield.fontName = FSTurnsCounter.AMOUNT_TEXTFIELD_DEFAULT_FONT;
               this.mTurnsTextfield.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
               this.mTurnsTextfield.x = this.mButton.x + _loc2_ + (this.mButton.width - _loc3_) / 2;
               this.mTurnsTextfield.y = this.mButton.y;
            }
            if(this.mTurnsTextfield != null)
            {
               addChild(this.mTurnsTextfield);
            }
         }
      }
      
      public function updateTurnsForSimpleCounter(param1:String, param2:int = 4) : void
      {
         if(this.mTurnsTextfield != null)
         {
            this.mTurnsTextfield.text = param1;
         }
         if(int(param1) < param2 && param1 != "--")
         {
            this.startAlertEffects();
         }
         else
         {
            if(this.mTurnsTextfield.fontName != FSTurnsCounter.AMOUNT_TEXTFIELD_DEFAULT_FONT)
            {
               this.mTurnsTextfield.fontName = FSTurnsCounter.AMOUNT_TEXTFIELD_DEFAULT_FONT;
            }
            if(this.mTurnsTextfield)
            {
               TweenMax.killTweensOf(this.mTurnsTextfield);
            }
            this.mTurnsTextfield.scaleX = 1;
            this.mTurnsTextfield.scaleY = 1;
         }
         if(this.mTurnsTextfield != null)
         {
            addChild(this.mTurnsTextfield);
         }
      }
      
      protected function startAlertEffects() : void
      {
         var _loc1_:Array = null;
         if(this.mTurnsTextfield)
         {
            if(this.mTurnsTextfield.fontName != FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_RED))
            {
               this.mTurnsTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_RED);
            }
            _loc1_ = TweenMax.getTweensOf(this.mTurnsTextfield);
            if(_loc1_ == null || Boolean(_loc1_) && Boolean(_loc1_.length == 0))
            {
               SpecialFX.createYoYoZoomTransition(this.mTurnsTextfield,1.8,1,-1,null,null,false);
            }
         }
      }
      
      private function onAttackButtonClick(param1:Event) : void
      {
         var _loc3_:FSBattleScreen = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:UserBattleInfo = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         var _loc11_:Object = null;
         var _loc12_:FSCard = null;
         var _loc13_:FSPower = null;
         var _loc14_:LevelDef = null;
         var _loc15_:int = 0;
         var _loc16_:Boolean = false;
         var _loc17_:Boolean = false;
         var _loc18_:Boolean = false;
         var _loc19_:Boolean = false;
         var _loc20_:Boolean = false;
         var _loc21_:String = null;
         var _loc22_:Boolean = false;
         var _loc23_:ActionPointsCounter = null;
         var _loc2_:BattleEngine = InstanceMng.getBattleEngine();
         if(_loc2_)
         {
            if(_loc2_.isOnlineMatch() && !Utils.smInternetAvailable)
            {
               Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true);
               return;
            }
            if(_loc2_.getAbilityWaitingForTarget() != null || this.isAnyCardMoving())
            {
               return;
            }
            if(_loc2_.isOnlineMatch() && (!_loc2_.isOwnerTurn() || _loc2_.getPlayersStateId() != BattleEngine.STATE_OWNER_MOVING_CARDS))
            {
               FSDebug.debugTrace("IS ONLINE MATCH AND IS NOT OWNER TURN!");
               return;
            }
            if(InstanceMng.getCurrentScreen() is FSBattleScreen)
            {
               _loc3_ = FSBattleScreen(InstanceMng.getCurrentScreen());
               _loc3_.unHighlightAllSockets();
               if(_loc2_.isPvPMatch() || _loc2_.isOwnerTurn())
               {
                  _loc3_.suggestPlayableCardOFF();
               }
               _loc4_ = _loc3_.areCardAnimsON();
               if(_loc4_)
               {
                  FSDebug.debugTrace("Wait until the card anims are over");
                  return;
               }
               _loc5_ = InstanceMng.getBattleEngine().isSacrificeWaitingForTarget();
               if(_loc5_)
               {
                  FSDebug.debugTrace("Sacrifice is going on");
                  return;
               }
               Utils.removeLog();
               _loc6_ = _loc2_.isOwnerTurn() ? _loc2_.getOwnerBattleInfo() : _loc2_.getOpponentBattleInfo();
               _loc7_ = DictionaryUtils.getDictionaryLength(_loc6_.getPlayableCardsCatalog());
               _loc8_ = 1;
               if(_loc7_ != 0)
               {
                  _loc11_ = this.getCardWithLessSummonCost(_loc6_.getPlayableCardsCatalog());
                  _loc12_ = _loc11_ != null ? _loc11_["card"] : null;
                  _loc8_ = _loc12_ ? int(_loc11_["cost"]) : 1;
                  if(Config.getConfig().gameHasPowers())
                  {
                     _loc13_ = _loc2_.isOwnerTurn() ? _loc2_.getOwnerPower() : _loc2_.getOpponentPower();
                     if(_loc13_)
                     {
                        if(_loc13_.getCardDef().getSummonCost() < _loc8_)
                        {
                           _loc8_ = _loc13_.getCardDef().getSummonCost();
                        }
                     }
                  }
               }
               _loc9_ = _loc2_.hasAnyPromoteableCards(_loc6_.isOwnerBattleInfo());
               _loc10_ = Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) ? InstanceMng.getUserDataMng().getOwnerUserData().flagsGetAPLeftWarning() : true;
               if((_loc10_) && (_loc9_ || _loc12_ != null) && _loc2_.canPlayerDoMoreActions(_loc8_) && _loc7_ != 0 && _loc3_.isAnyCardOrPowerPlayable())
               {
                  if(!Screen.isScreenLocked())
                  {
                     _loc3_.setSelectedCard(null);
                     _loc14_ = _loc2_.getLevelDef();
                     _loc15_ = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
                     _loc16_ = _loc14_ ? _loc14_.getLevelIndex() == 1 && _loc15_ == UserDataMng.DIFFICULTY_EASY : false;
                     _loc17_ = InstanceMng.getBattleEngine().getBattleScreen().isOwnerBFSocketsFull();
                     FSDebug.debugTrace("owner bf full? " + _loc17_);
                     _loc18_ = Root.smBattleData ? Boolean(Root.smBattleData.isDungeon) : false;
                     _loc19_ = Root.smBattleData ? Boolean(Root.smBattleData.isRaid) : false;
                     _loc20_ = _loc17_ || !_loc16_ || _loc18_ || _loc19_;
                     _loc21_ = _loc20_ ? TextManager.getText("TID_GEN_ACTION_NOT_USED") : TextManager.getText("TID_GEN_ACTION_NOT_USED_FIRST_TURN");
                     InstanceMng.getPopupMng().openActionPointsLeftPopup(_loc21_,_loc2_,_loc20_);
                     _loc22_ = !InstanceMng.getBattleEngine().isPvPMatch() ? true : InstanceMng.getBattleEngine().isOwnerTurn();
                     _loc23_ = _loc3_.getActionPointsCounter(_loc22_);
                     if(_loc23_ != null)
                     {
                        _loc23_.startZoomTransition();
                     }
                  }
               }
               else if(!_loc2_.isOnlineMatch() || _loc2_.isOnlineMatch() && BattleEnginePvP(_loc2_).isAttackaAllowed())
               {
                  this.performCommonOpsBeforeAttacking();
               }
               this.updateVisualHighlights(true);
            }
         }
      }
      
      private function getCardWithLessSummonCost(param1:Dictionary) : Object
      {
         var _loc2_:Object = null;
         var _loc3_:FSCard = null;
         var _loc5_:int = 0;
         var _loc6_:AbilityDef = null;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         var _loc4_:int = 1000;
         for each(_loc3_ in param1)
         {
            _loc6_ = _loc3_ ? _loc3_.getCostModifierAbilityDef() : null;
            _loc5_ = _loc3_.getCardCostByType(_loc6_);
            if(_loc3_ is FSAction)
            {
               if(!FSAction(_loc3_).hasTargetSelectionAbsWithPlayableTargets())
               {
                  continue;
               }
               _loc7_ = FSAction(_loc3_).has0CostTargetSelectionAbsWithPlayableTargets();
               _loc5_ = _loc7_ ? 0 : _loc5_;
            }
            else if(_loc3_ is FSAttachment)
            {
               if(!FSAttachment(_loc3_).hasCardsToBeAttachedAvailable())
               {
                  continue;
               }
               _loc8_ = FSAttachment(_loc3_).has0CostTargetsToBeAttachedTo();
               _loc5_ = _loc8_ ? 0 : _loc5_;
            }
            else if(_loc3_ is FSUnit)
            {
               _loc9_ = InstanceMng.getBattleEngine().getBattleScreen().isOwnerBFSocketsFull();
               if(_loc9_)
               {
                  continue;
               }
               _loc10_ = FSUnit(_loc3_).hasPlayableSockets();
               if(!_loc10_)
               {
                  continue;
               }
            }
            if(_loc5_ < _loc4_)
            {
               _loc4_ = _loc5_;
               if(_loc2_ == null)
               {
                  _loc2_ = new Object();
               }
               _loc2_["card"] = _loc3_;
               _loc2_["cost"] = _loc4_;
            }
         }
         return _loc2_;
      }
      
      private function isAnyCardMoving() : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:FSCard = null;
         var _loc4_:Dictionary = null;
         var _loc1_:Boolean = false;
         if(InstanceMng.getBattleEngine().isOwnerTurn())
         {
            _loc4_ = InstanceMng.getBattleEngine().getOwnerBattleInfo() ? InstanceMng.getBattleEngine().getOwnerBattleInfo().getFightCards() : null;
            if(_loc4_)
            {
               for each(_loc3_ in _loc4_)
               {
                  if(_loc3_.isMoving())
                  {
                     return true;
                  }
               }
            }
         }
         else
         {
            _loc4_ = InstanceMng.getBattleEngine().getOpponentBattleInfo() ? InstanceMng.getBattleEngine().getOpponentBattleInfo().getFightCards() : null;
            if(_loc4_)
            {
               for each(_loc3_ in _loc4_)
               {
                  if(_loc3_.isMoving())
                  {
                     return true;
                  }
               }
            }
         }
         return _loc1_;
      }
      
      public function performCommonOpsBeforeAttacking(param1:Boolean = false) : void
      {
         var _loc9_:String = null;
         var _loc10_:ActionPointsCounter = null;
         var _loc2_:BattleEngine = InstanceMng.getBattleEngine();
         var _loc3_:int = _loc2_.getBattleStateId();
         var _loc4_:Boolean = _loc2_.isPvPMatch() && !_loc2_.isOnlineMatch();
         var _loc5_:Boolean = _loc2_.isOwnerTurn();
         var _loc6_:Boolean = (_loc5_) || !_loc5_ && _loc4_;
         if(!_loc6_ || _loc3_ == BattleEngine.BATTLE_STATE_ATTACKING || _loc3_ == BattleEngine.BATTLE_STATE_DEALING_CARDS || _loc3_ == BattleEngine.BATTLE_STATE_DISCARDING)
         {
            _loc9_ = "Ignoring attack button click because of a wrong requirement: Battle State ID: " + _loc3_ + " Owner turn:" + _loc5_.toString();
            FSDebug.debugTrace(_loc9_);
            FSTracker.trackMiscAction(FSTracker.CATEGORY_MISC,FSTracker.ACTION_ERROR_DETECTED,{"error":_loc9_});
            return;
         }
         FSDebug.debugTrace("<<<<<<<<<<<<<<< ATTACK BUTTON CLICKED");
         FSDebug.debugTrace("Battle State ID: " + _loc3_);
         var _loc7_:Number = TimerUtil.currentTimeMillis() + 4000;
         this.disableAttackButton(_loc7_);
         var _loc8_:Screen = InstanceMng.getCurrentScreen();
         if(_loc8_ is FSBattleScreen)
         {
            FSBattleScreen(_loc8_).lockUI(true);
            if(FSBattleScreen(_loc8_))
            {
               if(InstanceMng.getBattleEngine().isOwnerTurn())
               {
                  FSBattleScreen(_loc8_).disableFreeReshuffle(InstanceMng.getBattleEngine().getOwnerBattleInfo());
               }
               else
               {
                  FSBattleScreen(_loc8_).disableFreeReshuffle(InstanceMng.getBattleEngine().getOpponentBattleInfo());
               }
            }
            if(_loc2_.isOnlineMatch())
            {
               BattleEnginePvP(_loc2_).enableAttack(false);
               BattleEnginePvP(_loc2_).requestPvPTimer(false);
               TweenMax.killDelayedCallsTo(BattleEnginePvP(_loc2_).onPvPTurnTimeout);
            }
            if(!_loc2_.isPvPMatch())
            {
               FSBattleScreen(_loc8_).enableBoostsPanel(false);
            }
            if(Config.getConfig().gameHasSacrifice())
            {
               _loc2_.enableSacrificeButton(false);
            }
            if(Config.getConfig().gameHasPowers())
            {
               _loc2_.enableOwnerPowerButton(false);
               _loc2_.enableOpponentPowerButton(false);
            }
            _loc10_ = FSBattleScreen(_loc8_).getActionPointsCounter(InstanceMng.getBattleEngine().isOwnerTurn());
            if(_loc10_ != null)
            {
               _loc10_.stopZoomTransition();
            }
            if(!param1)
            {
               _loc2_.changePlayersState();
            }
            else
            {
               TweenMax.delayedCall(0.75,this.battleEngineChangePlayerState);
            }
         }
      }
      
      private function battleEngineChangePlayerState() : void
      {
         if(InstanceMng.getBattleEngine())
         {
            InstanceMng.getBattleEngine().changePlayersState();
         }
      }
      
      public function disableAttackButton(param1:Number = 0) : void
      {
         if(this.mButton)
         {
            this.mButton.enabled = false;
         }
         if(param1 != 0)
         {
            this.mUnlockTime = param1 > this.mUnlockTime ? param1 : this.mUnlockTime;
            this.mUnlockTime = Math.floor(this.mUnlockTime);
         }
      }
      
      public function enableAttackButton() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         FSDebug.debugTrace("ENABLING ATTACK BUTTON");
         var _loc1_:Boolean = false;
         if(this.mUnlockTime != 0)
         {
            _loc2_ = TimerUtil.currentTimeMillis();
            _loc3_ = 0;
            _loc1_ = _loc2_ >= this.mUnlockTime - _loc3_;
         }
         else
         {
            _loc1_ = true;
         }
         this.mUnlockTime = _loc1_ ? 0 : this.mUnlockTime;
         if(Boolean(this.mButton) && _loc1_)
         {
            this.mButton.enabled = true;
         }
         if(!_loc1_ && this.mUnlockTime != 0)
         {
            FSDebug.debugTrace("Attack button unable to enable, trying again in " + Math.abs(this.mUnlockTime - _loc2_) + " ms");
            setTimeout(this.enableAttackButton,Math.abs(this.mUnlockTime - _loc2_));
         }
      }
      
      public function updateVisualHighlights(param1:Boolean = false) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         if(param1 || InstanceMng.getBattleEngine().canPlayerDoMoreActions())
         {
            if(this.mBGAlertLayer)
            {
               TweenMax.killTweensOf(this.mBGAlertLayer);
               this.mBGAlertLayer.removeFromParent();
               this.mBGAlertLayer.alpha = 0.999;
               if(this.mButton)
               {
                  this.mButton.upState = Root.assets.getTexture(this.BUTTON_UP_NAME);
               }
            }
         }
         else
         {
            _loc2_ = InstanceMng.getBattleEngine().isOwnerTurn();
            _loc3_ = InstanceMng.getBattleEngine().isPvPMatch();
            _loc4_ = InstanceMng.getBattleEngine().isOnlineMatch();
            if(_loc2_ || _loc3_ && !_loc4_)
            {
               Utils.playSound("ready_to_attack",SoundManager.TYPE_SFX);
               addChildAt(this.mBGAlertLayer,1);
               if(this.mTurnsTextfield != null)
               {
                  addChild(this.mTurnsTextfield);
               }
               SpecialFX.tweenToAlpha(this.mBGAlertLayer,0.001,1);
               if(this.mButton)
               {
                  this.mButton.upState = Root.assets.getTexture(this.BUTTON_DOWN_NAME);
               }
            }
         }
      }
      
      public function getButton() : FSButton
      {
         return this.mButton;
      }
      
      public function getBG() : FSImage
      {
         return this.mBG;
      }
      
      override public function dispose() : void
      {
         if(this.mButton)
         {
            this.mButton.removeFromParent(true);
            this.mButton = null;
         }
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         if(this.mBGAlertLayer)
         {
            this.mBGAlertLayer.removeFromParent(true);
            this.mBGAlertLayer = null;
         }
         if(this.mTurnsTextfield)
         {
            this.mTurnsTextfield.removeFromParent(true);
            this.mTurnsTextfield = null;
         }
         super.dispose();
      }
   }
}

