package com.fs.tcgengine.view.popups.raids
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.popups.misc.PopupStandard;
   import com.fs.tcgengine.view.raids.FSRaidBoss;
   import com.greensock.TweenMax;
   import flash.utils.Dictionary;
   import starling.events.Event;
   
   public class PopupRaidLevelCompleted extends PopupStandard
   {
      
      private const REWARDS_ASSET_NAME:String = "pvp_end_reward";
      
      private const LEVEL_STATUS_NOT_STARTED:int = 0;
      
      private const LEVEL_STATUS_COMPLETED:int = 1;
      
      private const LEVEL_STATUS_FAILED:int = -1;
      
      protected var mTitle:FSTextfield;
      
      protected var mRaidNameTextfield:FSTextfield;
      
      protected var mLevelsCompletedContainer:Component;
      
      private var mLevelsCompletedVec:Vector.<FSButton>;
      
      private var mTextInfoTextField:FSTextfield;
      
      protected var mRaidBossInfo:FSRaidBoss;
      
      public function PopupRaidLevelCompleted(param1:Boolean = true)
      {
         param1 = this is PopupRaidLevelFailed;
         super(param1);
      }
      
      override protected function getBackgroundName(param1:String) : void
      {
         mBGName = Constants.POPUP_SETTINGS_NAME;
      }
      
      override protected function createBackground(param1:String, param2:int = 0) : void
      {
         super.createBackground(param1,720);
         if(Boolean(mBox) && Config.getConfig().gameHasCustomPopups())
         {
            mBox.scale = Constants.POPUP_RAIDS_SCALE_FACTOR;
         }
      }
      
      override protected function createUI() : void
      {
         super.createUI();
         this.setupTexts();
         this.fillLevelsIndicators();
         this.createRaidBossInfo();
         this.createLevelsContainer();
         this.createTextInfo();
      }
      
      private function createRaidBossInfo() : void
      {
         if(this.mRaidBossInfo == null)
         {
            this.mRaidBossInfo = new FSRaidBoss(InstanceMng.getRaidsMng().getCurrentRaidDef(),InstanceMng.getRaidsMng().getCurrentRaidDifficulty(),true);
            this.mRaidBossInfo.init();
            this.mRaidBossInfo.pivotX = this.mRaidBossInfo.width / 2;
            this.mRaidBossInfo.x = width / 2;
            this.mRaidBossInfo.y = this.mRaidNameTextfield.y + this.mRaidNameTextfield.height * 1.15;
         }
         addChild(this.mRaidBossInfo);
      }
      
      private function createTextInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.mTextInfoTextField == null)
         {
            if(InstanceMng.getCurrentScreen() is FSBattleScreen)
            {
               if(FSBattleScreen(InstanceMng.getCurrentScreen()).getBattleEngine())
               {
                  if(FSBattleScreen(InstanceMng.getCurrentScreen()).getBattleEngine().getOwnerBattleInfo())
                  {
                     _loc1_ = FSBattleScreen(InstanceMng.getCurrentScreen()).getBattleEngine().getOwnerBattleInfo().getRaidCumulativeDamage();
                     _loc2_ = InstanceMng.getRaidsMng().getBossHitCurrentRaid() == 0 ? 0 : int(InstanceMng.getRaidsMng().getBossHitCurrentRaid() * -1);
                     _loc3_ = InstanceMng.getRaidsMng().getBossHealCurrentRaid() == 0 ? 0 : int(InstanceMng.getRaidsMng().getBossHealCurrentRaid() * -1);
                  }
               }
            }
            this.mTextInfoTextField = new FSTextfield(width * 0.75,height * 0.4,TextManager.getText("TID_DAMAGE_DONE") + ": " + _loc2_ + "\n" + TextManager.getText("TID_DAMAGE_HEAL") + ": " + _loc3_ + "\n" + TextManager.getText("TID_DAMAGE_RESULT") + ": " + _loc1_);
            this.mTextInfoTextField.pivotX = this.mTextInfoTextField.width / 2;
            this.mTextInfoTextField.x = this.mRaidBossInfo.x;
            this.mTextInfoTextField.y = this.mRaidBossInfo.y + this.mRaidBossInfo.height * 1.1;
         }
         else if(InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            this.mTextInfoTextField.text = TextManager.getText("TID_DAMAGE_DONE") + ": " + FSBattleScreen(InstanceMng.getCurrentScreen()).getBattleEngine().getOwnerBattleInfo().getRaidCumulativeDamage();
         }
         addChild(this.mTextInfoTextField);
      }
      
      private function createLevelsContainer() : void
      {
         if(this.mLevelsCompletedContainer == null && Boolean(this.mRaidNameTextfield))
         {
            this.mLevelsCompletedContainer = new Component();
            this.mLevelsCompletedContainer.x = 0;
            this.mLevelsCompletedContainer.y = this.mRaidNameTextfield.y + this.mRaidNameTextfield.height * 1.1;
            this.mLevelsCompletedContainer.width = this.mRaidNameTextfield.width;
         }
         addChild(this.mLevelsCompletedContainer);
      }
      
      private function fillLevelsIndicators() : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:FSButton = null;
         var _loc7_:String = null;
         var _loc1_:Dictionary = InstanceMng.getDungeonsMng().getCurrentLevelsStatus();
         if(_loc1_)
         {
            _loc3_ = DictionaryUtils.getKeys(_loc1_);
            _loc3_.sort(Array.NUMERIC);
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length)
            {
               _loc2_ = int(_loc1_[_loc3_[_loc5_]]);
               switch(_loc2_)
               {
                  case this.LEVEL_STATUS_NOT_STARTED:
                     _loc7_ = "phase_icon_incomplete";
                     break;
                  case this.LEVEL_STATUS_COMPLETED:
                     _loc7_ = "phase_icon_victory";
                     break;
                  case this.LEVEL_STATUS_FAILED:
                     _loc7_ = "phase_icon_defeated";
               }
               _loc6_ = new FSButton(Root.assets.getTexture(_loc7_),(_loc5_ + 1).toString());
               _loc6_.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
               _loc6_.scaleWhenDown = 1;
               _loc6_.enableScaleOnMouseOver(false);
               this.addButtonToContainer(_loc6_,_loc5_,_loc3_.length);
               _loc5_++;
            }
            if(this.mLevelsCompletedContainer)
            {
               this.mLevelsCompletedContainer.x = (mBox.width - this.mLevelsCompletedContainer.width) / 2;
            }
         }
      }
      
      private function addButtonToContainer(param1:FSButton, param2:int, param3:int) : void
      {
         var _loc4_:FSCoordinate = null;
         if(this.mLevelsCompletedVec == null)
         {
            this.mLevelsCompletedVec = new Vector.<FSButton>();
         }
         this.mLevelsCompletedVec.push(param1);
         if(this.mLevelsCompletedContainer)
         {
            _loc4_ = Utils.getXYPositionInContainer(param2,param1.width,param1.height,mBox.width * 0.9,param1.height,param3,1,true);
            param1.x = param3 == 3 ? _loc4_.getX() : param1.width / 3 + _loc4_.getX();
            param1.y = param1.height / 2 + _loc4_.getY();
            this.mLevelsCompletedContainer.addChild(param1);
         }
      }
      
      protected function onClosePerformCommonOps() : void
      {
         Utils.stopSound(Constants.SOUND_VICTORY);
         Utils.stopSound(Constants.SOUND_DEFEAT);
         if(InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            FSBattleScreen(InstanceMng.getCurrentScreen()).performCardsLeavingFX(0,this.showRaidsScreen);
         }
      }
      
      private function showRaidsScreen() : void
      {
         var goToRaids:Function = null;
         goToRaids = function():void
         {
            if(InstanceMng.getCurrentScreen() is FSBattleScreen)
            {
               FSBattleScreen(InstanceMng.getCurrentScreen()).showRaidsScreen();
            }
         };
         if(InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            TweenMax.delayedCall(0.3,goToRaids);
         }
      }
      
      protected function setupTexts() : void
      {
         this.createTitle(TextManager.getText("TID_GEN_LEVEL_VICTORY"));
         this.createRaidName();
      }
      
      protected function createTitle(param1:String) : void
      {
         if(this.mTitle == null)
         {
            this.mTitle = new FSTextfield(width * 0.9,height * 0.2);
            this.mTitle.x = (mBox.width - this.mTitle.width) / 2;
            this.mTitle.y = mBox.height * 0.035;
            this.mTitle.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GOLD);
            addChild(this.mTitle);
         }
         this.mTitle.text = param1;
      }
      
      private function createRaidName() : void
      {
         if(this.mRaidNameTextfield == null)
         {
            this.mRaidNameTextfield = new FSTextfield(this.mTitle.width,this.mTitle.height / 1.9,InstanceMng.getRaidsMng().getCurrentRaidDef().getName());
            this.mRaidNameTextfield.x = this.mTitle.x;
            this.mRaidNameTextfield.y = this.mTitle.y + this.mTitle.height * 0.9;
            addChild(this.mRaidNameTextfield);
         }
      }
      
      override protected function onAccept(param1:Event) : void
      {
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            mAcceptButton.touchable = false;
            super.onAccept(param1);
            mOnClosedFunction = this.onAcceptPerformOps;
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_GEN_UNABLE_PROCEED"),true);
            InstanceMng.getPopupMng().getPopupShown().hideTemporarily(InstanceMng.getPopupMng().openErrorPopup,[TextManager.getText("TID_CONNECTION_LOST"),true]);
         }
      }
      
      protected function onAcceptPerformOps() : void
      {
         this.onClosePerformCommonOps();
      }
      
      override protected function setupAcceptButton(param1:String, param2:String = "", param3:String = "") : void
      {
         super.setupAcceptButton(TextManager.getText("TID_GEN_NEXT"),param2,param3);
      }
      
      override protected function removeFromStage() : void
      {
         var _loc1_:int = 0;
         if(this.mTitle)
         {
            this.mTitle.removeFromParent(true);
            this.mTitle = null;
         }
         if(this.mRaidNameTextfield)
         {
            this.mRaidNameTextfield.removeFromParent(true);
            this.mRaidNameTextfield = null;
         }
         if(this.mLevelsCompletedContainer)
         {
            this.mLevelsCompletedContainer.removeFromParent(true);
            this.mLevelsCompletedContainer = null;
         }
         if(this.mTextInfoTextField)
         {
            this.mTextInfoTextField.removeFromParent(true);
            this.mTextInfoTextField = null;
         }
         if(this.mRaidBossInfo)
         {
            this.mRaidBossInfo.removeFromParent(true);
            this.mRaidBossInfo = null;
         }
         if(this.mLevelsCompletedVec)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mLevelsCompletedVec.length)
            {
               this.mLevelsCompletedVec[_loc1_].removeFromParent(true);
               _loc1_++;
            }
            Utils.destroyArray(this.mLevelsCompletedVec);
            this.mLevelsCompletedVec = null;
         }
         InstanceMng.getPopupMng().removePopup(FSPopupMng.RAID_LEVEL_COMPLETED_POPUP_NAME);
         super.removeFromStage();
      }
   }
}

