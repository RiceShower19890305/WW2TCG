package com.fs.tcgengine.view.popups.misc
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.controller.rules.PacksDefMng;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.model.rules.DailyRewardDef;
   import com.fs.tcgengine.model.rules.PackDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.TimerUtil;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.anims.misc.PackAnimation;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.components.popups.map.DailyReward;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.popups.Popup;
   import com.greensock.TweenMax;
   import flash.utils.setTimeout;
   
   public class PopupDailyRewards extends PopupStandard
   {
      
      public static const BG_NAME:String = Constants.POPUP_LARGE_NAME;
      
      protected var mDailyRewardsVector:Vector.<DailyReward>;
      
      private var mLeftPanelBodyTextfield:FSTextfield;
      
      private var mLeftImage:FSImage;
      
      private var mTopContainer:Component;
      
      protected var mDailyRewardDef:DailyRewardDef;
      
      public function PopupDailyRewards(param1:Boolean = true)
      {
         super(param1);
      }
      
      public function setupPopup(param1:DailyRewardDef) : void
      {
         this.mDailyRewardDef = param1;
         setResourcesToLoad();
      }
      
      override protected function getBackgroundName(param1:String) : void
      {
         mBGName = BG_NAME;
      }
      
      override protected function createBackground(param1:String, param2:int = 0) : void
      {
         super.createBackground(param1,1800);
         if(Boolean(mBox) && Config.getConfig().gameHasCustomPopups())
         {
            mBox.scale = Constants.POPUP_SETTINGS_SCALE_FACTOR;
         }
      }
      
      override protected function addBGToLoad() : void
      {
      }
      
      override protected function isBackgroundVisible() : Boolean
      {
         return false;
      }
      
      override protected function removeFromStage() : void
      {
         var _loc1_:int = 0;
         if(this.mDailyRewardsVector)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mDailyRewardsVector.length)
            {
               this.mDailyRewardsVector[_loc1_].removeFromParent(true);
               _loc1_++;
            }
            Utils.destroyArray(this.mDailyRewardsVector);
            this.mDailyRewardsVector = null;
         }
         if(this.mLeftPanelBodyTextfield)
         {
            this.mLeftPanelBodyTextfield.removeFromParent(true);
            this.mLeftPanelBodyTextfield = null;
         }
         if(this.mLeftImage)
         {
            this.mLeftImage.removeFromParent(true);
            this.mLeftImage = null;
         }
         this.mDailyRewardDef = null;
         InstanceMng.getPopupMng().removePopup(FSPopupMng.DAILY_REWARDS_POPUP_NAME);
         super.removeFromStage();
      }
      
      override protected function createUI() : void
      {
         if(this.mDailyRewardDef)
         {
            super.createUI();
            this.createFields();
            setMainFieldText(TextManager.getText("TID_DAILYREWARDS"));
            this.init();
         }
      }
      
      protected function init() : void
      {
         this.createLeftSection("TID_DAILYREWARDS_INFO");
         this.createRightSection();
      }
      
      protected function createDailyRewardItems(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:DailyReward = null;
         var _loc4_:int = 0;
         var _loc5_:DailyRewardDef = null;
         var _loc6_:int = 0;
         if(this.mDailyRewardsVector == null)
         {
            _loc2_ = param1 ? 4 : 31;
            this.mDailyRewardsVector = new Vector.<DailyReward>();
            _loc6_ = this.mDailyRewardDef.getDay();
            _loc4_ = 1;
            while(_loc4_ < _loc2_)
            {
               _loc5_ = DailyRewardDef(InstanceMng.getDailyRewardsDefMng().getDefByDay(_loc4_,param1));
               if(_loc5_)
               {
                  _loc3_ = new DailyReward(_loc5_,_loc4_ == _loc6_,this,_loc4_ < _loc6_);
                  this.mDailyRewardsVector.push(_loc3_);
               }
               _loc4_++;
            }
         }
      }
      
      protected function createLeftSection(param1:String) : void
      {
         if(this.mLeftPanelBodyTextfield == null)
         {
            this.mLeftPanelBodyTextfield = new FSTextfield(mInfoTextfield.width,mInfoTextfield.height * 2,TextManager.getText(param1),16777215,FSResourceMng.FONT_STD_SEMI_SMALL_SIZE);
            this.mLeftPanelBodyTextfield.x = mInfoTextfield.x;
            this.mLeftPanelBodyTextfield.y = mInfoTextfield.y + mInfoTextfield.height;
            addChild(this.mLeftPanelBodyTextfield);
         }
         if(this.mLeftImage == null)
         {
            this.mLeftImage = new FSImage(Root.assets.getTexture("daily_reward_character"));
            this.mLeftImage.x = mInfoTextfield.x + (mInfoTextfield.width - this.mLeftImage.width) / 2;
            this.mLeftImage.y = this.mLeftPanelBodyTextfield.y + this.mLeftPanelBodyTextfield.height;
            addChild(this.mLeftImage);
         }
      }
      
      private function createRightSection() : void
      {
         this.createTopContainer();
         this.createDailyRewardItems(false);
      }
      
      public function createPackImage() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:String = null;
         var _loc3_:PackDef = null;
         if(_loc1_ == null)
         {
            _loc2_ = this.mDailyRewardDef.getPackSku();
            _loc3_ = PackDef(InstanceMng.getPacksDefMng().getDefBySku(_loc2_));
            if(_loc3_)
            {
               _loc1_ = new PackAnimation(_loc3_.getAnimBG());
               _loc1_.scaleX *= 0.4;
               _loc1_.scaleY *= 0.4;
               _loc1_.touchable = false;
            }
         }
         return _loc1_;
      }
      
      public function onServerTimeACKGiveRewards(param1:Object) : void
      {
         var onPopupClosed:Function = null;
         var ownerUserData:UserData = null;
         var dailyRewardTimeMS:Number = NaN;
         var dateObj:Object = null;
         var date:Date = null;
         var dateMS:Number = NaN;
         var ownerLevel:int = 0;
         var packDef:PackDef = null;
         var isAuthorisedForNotifs:Boolean = false;
         var text:String = null;
         var data:Object = param1;
         onPopupClosed = function():void
         {
            Utils.openPack(packDef,PacksDefMng.PACK_DAILY_REWARDS);
         };
         if(data != null)
         {
            ownerUserData = Utils.getOwnerUserData();
            if(ownerUserData)
            {
               dailyRewardTimeMS = ownerUserData.getDailyRewardTimeMS();
               if(this.mDailyRewardDef)
               {
                  ownerUserData.setLastDailyRewardClaimedIndex(this.mDailyRewardDef.getDay());
                  dateObj = Utils.parseJSONData(data);
                  date = TimerUtil.convertServerUCTDateToDate(dateObj.now);
                  dateMS = date.getTime();
                  if(this.mDailyRewardDef.getDay() == 1 || !Config.smDailyRewardExpires)
                  {
                     FSDebug.debugTrace("CLAIMED! -> time: " + dateMS);
                     if(dateMS != 0 && dateMS != -1)
                     {
                        ownerUserData.setDailyRewardTimeMS(dateMS);
                     }
                     else
                     {
                        ownerUserData.setDailyRewardTimeMS(ServerConnection.smServerTimeMS);
                     }
                  }
                  ownerLevel = ownerUserData.getCurrentLevelIndex(UserDataMng.DIFFICULTY_EASY);
                  switch(this.mDailyRewardDef.getType())
                  {
                     case DailyReward.TYPE_GOLD:
                        ownerUserData.addGold(this.mDailyRewardDef.getGold());
                        closePopup();
                        break;
                     case DailyReward.TYPE_CARD:
                     case DailyReward.TYPE_PACK:
                        packDef = PackDef(InstanceMng.getPacksDefMng().getDefBySku(this.mDailyRewardDef.getPackSku()));
                        if(packDef)
                        {
                           closePopup(onPopupClosed);
                        }
                        break;
                     case DailyReward.TYPE_QUEST_COINS:
                        ownerUserData.addQuestsCoins(this.mDailyRewardDef.getQuestCoins());
                        closePopup();
                        break;
                     case DailyReward.TYPE_RAID_COINS:
                        ownerUserData.addRaidCoins(this.mDailyRewardDef.getRaidCoins());
                        closePopup();
                  }
                  InstanceMng.getUserDataMng().persistenceSaveData();
                  Utils.setLogText(TextManager.getText("TID_DAILYREWARDS_SUCCESS"));
                  FSTracker.trackDailyRewardClaimed(this.mDailyRewardDef);
               }
               if(Utils.isMobile())
               {
                  if(ownerUserData.flagsOfflinePushNotifsGranted())
                  {
                     isAuthorisedForNotifs = InstanceMng.getApplication().getOfflinePushNotificationsMng() ? Boolean(InstanceMng.getApplication().getOfflinePushNotificationsMng().isAuthorised()) : true;
                     if(isAuthorisedForNotifs || Utils.isAndroid())
                     {
                        this.scheduleNotifications();
                     }
                     else if(Boolean(this.mDailyRewardDef) && Boolean(this.mDailyRewardDef.getType() != DailyReward.TYPE_CARD) && this.mDailyRewardDef.getType() != DailyReward.TYPE_PACK)
                     {
                        text = TextManager.getText("TID_PERMISSIONS_DAILYREWARD");
                        setTimeout(InstanceMng.getPopupMng().openConfirmationPopup,Popup.TRANSITION_TIME,text,this.scheduleNotifications,this.scheduleNotifications);
                     }
                  }
               }
            }
         }
         else
         {
            InstanceMng.getServerConnection().getServerTime(this.onServerTimeACKGiveRewards);
         }
      }
      
      protected function scheduleNotifications() : void
      {
         var _loc1_:Number = TimerUtil.msToSec(Config.getConfig().getDailyRewardTimeBetweenRewards());
         InstanceMng.getApplication().scheduleNotifications(_loc1_,Constants.NOTIF_DAILY_REWARD);
      }
      
      private function createTopContainer() : void
      {
         if(mBox)
         {
            if(this.mTopContainer == null)
            {
               this.mTopContainer = new Component();
            }
            this.mTopContainer.x = mInfoTextfield.x + mInfoTextfield.width;
            this.mTopContainer.y = mInfoTextfield.y - mInfoTextfield.height / 3;
            addChild(this.mTopContainer);
         }
      }
      
      override protected function setupAcceptButton(param1:String, param2:String = "", param3:String = "") : void
      {
      }
      
      override protected function setupCloseButton() : void
      {
         super.setupCloseButton();
         if(mCloseButton)
         {
            mCloseButton.visible = false;
         }
      }
      
      override protected function createFields() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         if(mBox)
         {
            _loc1_ = mBox.width * 0.25;
            _loc2_ = mBox.height * 0.15;
            if(mInfoTextfield == null)
            {
               mInfoTextfield = new FSTextfield(_loc1_,_loc2_,"",16777215,FSResourceMng.FONT_STD_SUBTITLE_SIZE);
               mInfoTextfield.x = mBox.width * 0.025;
               mInfoTextfield.y = mBox.height * 0.075;
               addChild(mInfoTextfield);
            }
         }
      }
      
      override protected function performOnOpenDefaultOps(param1:FSCoordinate, param2:Number = 0.6) : void
      {
         super.performOnOpenDefaultOps(param1,0.85);
      }
      
      override protected function onPopupOpenTransitionOver() : void
      {
         super.onPopupOpenTransitionOver();
         Utils.playSound("unfold_epic",SoundManager.TYPE_SFX);
         this.createDailyItemsTransition();
      }
      
      private function performTransitionStep3() : void
      {
         TweenMax.delayedCall(0.25,this.createDailyItemsTransition);
      }
      
      protected function createDailyItemsTransition() : void
      {
         var _loc1_:DailyReward = null;
         var _loc2_:int = 0;
         var _loc3_:FSCoordinate = null;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(this.mDailyRewardsVector)
         {
            _loc4_ = 0;
            _loc5_ = int(this.mDailyRewardsVector.length);
            _loc6_ = _loc5_ > 3 ? 6 : 3;
            _loc7_ = _loc5_ > 3 ? 5 : 1;
            _loc2_ = 0;
            while(_loc2_ < this.mDailyRewardsVector.length)
            {
               _loc1_ = this.mDailyRewardsVector[_loc2_];
               if(_loc1_ != null && mBox != null && this.mTopContainer != null)
               {
                  _loc3_ = Utils.getXYPositionInContainer(_loc2_,_loc1_.width,_loc1_.height,mBox.width * 0.7,mBox.height * 0.95,_loc6_,_loc7_,true);
                  _loc1_.alpha = 0.0001;
                  _loc1_.x = width;
                  _loc4_ = _loc2_ * 0.05;
                  TweenMax.delayedCall(_loc4_,SpecialFX.tweenToAlpha,[_loc1_,0.999,0.7,0]);
                  SpecialFX.createTransition(_loc1_,_loc3_,0.25,_loc4_);
                  TweenMax.delayedCall(_loc4_,Utils.playSound,["unfold_card",SoundManager.TYPE_SFX]);
                  this.mTopContainer.addChild(_loc1_);
               }
               _loc2_++;
            }
         }
      }
      
      override public function onConnectionChange() : void
      {
         var _loc1_:int = 0;
         if(mCloseButton)
         {
            mCloseButton.visible = !Utils.smInternetAvailable || !InstanceMng.getServerConnection().isUserLoggedIn();
         }
         if(this.mDailyRewardsVector)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mDailyRewardsVector.length)
            {
               this.mDailyRewardsVector[_loc1_].setBGTouchable(InstanceMng.getServerConnection().isUserLoggedIn());
               _loc1_++;
            }
         }
      }
      
      override public function allowClosureTappingBG() : Boolean
      {
         return false;
      }
   }
}

