package com.fs.tcgengine.view.components.popups.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.controller.rules.PacksDefMng;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.rules.PackDef;
   import com.fs.tcgengine.model.rules.StarsRewardsDef;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSMapScreen;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.anims.misc.PackAnimation;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.map.MapSubmenu;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.popups.misc.PopupAchievements;
   import com.greensock.TweenMax;
   import feathers.controls.ScrollContainer;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   
   public class StarsReward extends Component implements FSModelUnloadableInterface
   {
      
      private var mClaimButton:FSButton;
      
      private var mBG:FSImage;
      
      private var mPackAnim:PackAnimation;
      
      private var mStarsAmountIndicatorImage:FSImage;
      
      private var mStarsAmountIndicatorTextfield:FSTextfield;
      
      private var mStarsRewardDef:StarsRewardsDef;
      
      private var mParentScrollContainer:ScrollContainer;
      
      private var mNotificationIcon:FSImage;
      
      public function StarsReward(param1:StarsRewardsDef)
      {
         super();
         this.mStarsRewardDef = param1;
         this.createUI();
      }
      
      public function setParentScrollContainer(param1:ScrollContainer) : void
      {
         this.mParentScrollContainer = param1;
      }
      
      private function createUI() : void
      {
         this.createButton();
         this.createBG();
         this.createStarRewardBG();
         this.createStarsIndicatorImage();
         this.createStarsIndicatorTextfield();
         this.showNotificationIcon(this.isClaimeable());
      }
      
      private function createButton() : void
      {
         var _loc4_:String = null;
         var _loc1_:int = InstanceMng.getUserDataMng().getOwnerUserData().get3StarLevelsCompleted();
         var _loc2_:int = this.mStarsRewardDef.getStarsAmount() - _loc1_;
         var _loc3_:String = _loc2_ <= 0 ? TextManager.getText("TID_ACHIEVEMENT_CLAIM") : TextManager.replaceParameters(TextManager.getText("TID_3STAR_MISSING"),[_loc2_]);
         _loc4_ = _loc2_ <= 0 ? FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GREEN) : FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_RED);
         if(this.mClaimButton == null)
         {
            this.mClaimButton = new FSButton(Root.assets.getTexture("3stars_reward_name"),_loc3_,null);
            this.mClaimButton.x = this.mClaimButton.width / 2;
            this.mClaimButton.y = this.mClaimButton.height / 2;
            this.mClaimButton.fontName = _loc4_;
            this.mClaimButton.fontColor = 16777215;
            this.mClaimButton.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
            this.mClaimButton.addEventListener(Event.TRIGGERED,this.onClaimTriggered);
            addChild(this.mClaimButton);
         }
      }
      
      private function onClaimTriggered(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            if(this.isClaimeable())
            {
               this.mClaimButton.enabled = false;
               this.mBG.touchable = false;
               PopupAchievements(InstanceMng.getPopupMng().getPopupShown()).lockUI(true);
               this.onClaimReward();
               FSTracker.trackStarsRewardClaimed(this.mStarsRewardDef);
            }
            else
            {
               _loc2_ = InstanceMng.getUserDataMng().getOwnerUserData().get3StarLevelsCompleted();
               _loc3_ = this.mStarsRewardDef.getStarsAmount() - _loc2_;
               Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_STARS_REWARD_REQUIREMENT"),[_loc3_]),true);
            }
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true);
         }
      }
      
      private function isClaimeable() : Boolean
      {
         var _loc1_:int = InstanceMng.getUserDataMng().getOwnerUserData().get3StarLevelsCompleted();
         var _loc2_:int = this.mStarsRewardDef.getStarsAmount() - _loc1_;
         return _loc2_ <= 0 && InstanceMng.getServerConnection().isUserLoggedIn();
      }
      
      private function createBG() : void
      {
         if(this.mBG == null)
         {
            this.mBG = new FSImage(Root.assets.getTexture("3stars_reward"));
            this.mBG.x = this.mClaimButton.x - this.mClaimButton.width / 2;
            this.mBG.y = this.mClaimButton.y + this.mClaimButton.height / 1.8;
            addChild(this.mBG);
            this.mBG.touchable = this.isClaimeable();
            this.mBG.addEventListener(TouchEvent.TOUCH,this.onBGTouch);
         }
      }
      
      private function onBGTouch(param1:TouchEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:Touch = param1 ? param1.getTouch(this,TouchPhase.ENDED) : null;
         if(_loc2_)
         {
            if(this.mParentScrollContainer != null && !this.mParentScrollContainer.isScrolling)
            {
               if(this.isClaimeable())
               {
                  this.mClaimButton.enabled = false;
                  this.mBG.touchable = false;
                  PopupAchievements(InstanceMng.getPopupMng().getPopupShown()).lockUI(true);
                  this.onClaimReward();
               }
               else
               {
                  _loc3_ = InstanceMng.getUserDataMng().getOwnerUserData().get3StarLevelsCompleted();
                  _loc4_ = this.mStarsRewardDef.getStarsAmount() - _loc3_;
                  Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_STARS_REWARD_REQUIREMENT"),[_loc4_]),true);
               }
            }
         }
      }
      
      private function createStarRewardBG() : void
      {
         var _loc1_:PackDef = null;
         if(this.mPackAnim == null)
         {
            _loc1_ = PackDef(InstanceMng.getPacksDefMng().getDefBySku(this.mStarsRewardDef.getPackSku()));
            if(_loc1_)
            {
               this.mPackAnim = new PackAnimation(_loc1_.getAnimBG());
               this.mPackAnim.touchable = false;
               this.mPackAnim.scaleX = 0.5;
               this.mPackAnim.scaleY = 0.5;
               this.mPackAnim.x = this.mBG.x + (this.mBG.width - this.mPackAnim.width) / 2 + this.mPackAnim.width / 2;
               this.mPackAnim.y = this.mBG.y + (this.mBG.height - this.mPackAnim.height) / 2 + this.mPackAnim.height / 1.5;
               this.mPackAnim.touchable = true;
               this.mPackAnim.addEventListener(TouchEvent.TOUCH,this.onBGTouch);
               addChild(this.mPackAnim);
            }
         }
      }
      
      private function createStarsIndicatorImage() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         if(this.mStarsAmountIndicatorImage == null)
         {
            _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
            _loc2_ = "3stars_icon";
            if(_loc1_ != UserDataMng.DIFFICULTY_EASY)
            {
               _loc2_ = _loc2_ + "_diff_0" + String(int(_loc1_ + 1));
            }
            this.mStarsAmountIndicatorImage = new FSImage(Root.assets.getTexture(_loc2_));
            this.mStarsAmountIndicatorImage.alignPivot();
            this.mStarsAmountIndicatorImage.scaleX = 0.75;
            this.mStarsAmountIndicatorImage.scaleY = 0.75;
            this.mStarsAmountIndicatorImage.x = this.mBG.x + this.mBG.width - this.mStarsAmountIndicatorImage.width / 2;
            this.mStarsAmountIndicatorImage.y = this.mBG.y + this.mStarsAmountIndicatorImage.height / 2;
            addChild(this.mStarsAmountIndicatorImage);
         }
      }
      
      private function createStarsIndicatorTextfield() : void
      {
         if(this.mStarsAmountIndicatorTextfield == null)
         {
            this.mStarsAmountIndicatorTextfield = new FSTextfield(this.mStarsAmountIndicatorImage.width * 0.85,this.mStarsAmountIndicatorImage.height * 0.85,this.mStarsRewardDef.getStarsAmount().toString());
            this.mStarsAmountIndicatorTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_WHITE);
            this.mStarsAmountIndicatorTextfield.alignPivot();
            this.mStarsAmountIndicatorTextfield.x = this.mStarsAmountIndicatorImage.x;
            this.mStarsAmountIndicatorTextfield.y = this.mStarsAmountIndicatorImage.y;
            addChild(this.mStarsAmountIndicatorTextfield);
            if(this.isClaimeable())
            {
               TweenMax.killTweensOf(this.mStarsAmountIndicatorImage);
               SpecialFX.createYoYoZoomTransition(this.mStarsAmountIndicatorImage,1.1,1.5,-1,null,null,false);
            }
         }
      }
      
      private function onClaimReward() : void
      {
         var _loc1_:PackDef = this.mStarsRewardDef ? PackDef(InstanceMng.getPacksDefMng().getDefBySku(this.mStarsRewardDef.getPackSku())) : null;
         if(_loc1_)
         {
            FSTracker.trackMiscAction(FSTracker.CATEGORY_3STAR_REWARD,FSTracker.ACTION_COMPLETED,{"sku":this.mStarsRewardDef.getSku()});
            if(InstanceMng.getPopupMng().getPopupShown())
            {
               PopupAchievements(InstanceMng.getPopupMng().getPopupShown()).removeStarReward(this);
            }
            InstanceMng.getUserDataMng().getOwnerUserData().addStarsRewardClaimed(this.mStarsRewardDef.getSku(),false);
            if(Boolean(InstanceMng.getPopupMng().getPopupShown()) && InstanceMng.getPopupMng().getPopupShown() is PopupAchievements)
            {
               Utils.openPack(_loc1_,PacksDefMng.PACK_STARS_REWARD);
            }
            if(InstanceMng.getCurrentScreen() is FSMapScreen)
            {
               FSMapScreen(InstanceMng.getCurrentScreen()).onAchievementRewardClaimedHideNotificationIcon();
            }
         }
         else
         {
            if(this.mClaimButton)
            {
               this.mClaimButton.enabled = this.isClaimeable();
            }
            if(this.mBG)
            {
               this.mBG.touchable = this.isClaimeable();
            }
         }
      }
      
      override public function dispose() : void
      {
         if(this.mClaimButton)
         {
            this.mClaimButton.removeFromParent(true);
            this.mClaimButton = null;
         }
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         if(this.mPackAnim)
         {
            this.mPackAnim.removeFromParent(true);
            this.mPackAnim = null;
         }
         if(this.mStarsAmountIndicatorImage)
         {
            this.mStarsAmountIndicatorImage.removeFromParent(true);
            this.mStarsAmountIndicatorImage = null;
         }
         if(this.mStarsAmountIndicatorTextfield)
         {
            this.mStarsAmountIndicatorTextfield.removeFromParent(true);
            this.mStarsAmountIndicatorTextfield = null;
         }
         if(this.mNotificationIcon)
         {
            this.mNotificationIcon.removeFromParent();
            this.mNotificationIcon.destroy();
            this.mNotificationIcon = null;
         }
         this.mParentScrollContainer = null;
         this.mStarsRewardDef = null;
         super.dispose();
      }
      
      public function destroy() : void
      {
         if(this.mClaimButton)
         {
            this.mClaimButton.removeFromParent();
            this.mClaimButton.destroy();
            this.mClaimButton = null;
         }
         if(this.mBG)
         {
            this.mBG.removeFromParent();
            this.mBG.destroy();
            this.mBG = null;
         }
         if(this.mPackAnim)
         {
            this.mPackAnim.removeFromParent();
            this.mPackAnim.destroy();
            this.mPackAnim = null;
         }
         if(this.mStarsAmountIndicatorImage)
         {
            this.mStarsAmountIndicatorImage.removeFromParent();
            this.mStarsAmountIndicatorImage.destroy();
            this.mStarsAmountIndicatorImage = null;
         }
         if(this.mStarsAmountIndicatorTextfield)
         {
            this.mStarsAmountIndicatorTextfield.removeFromParent();
            this.mStarsAmountIndicatorTextfield = null;
         }
         if(this.mNotificationIcon)
         {
            this.mNotificationIcon.removeFromParent();
            this.mNotificationIcon.destroy();
            this.mNotificationIcon = null;
         }
         this.mParentScrollContainer = null;
      }
      
      public function showNotificationIcon(param1:Boolean) : void
      {
         if(this.mNotificationIcon == null)
         {
            this.mNotificationIcon = new FSImage(Root.assets.getTexture(MapSubmenu.NOTIFICATION_NAME));
            this.mNotificationIcon.touchable = false;
            this.mNotificationIcon.alignPivot();
            this.mNotificationIcon.x = this.mPackAnim ? this.mClaimButton.x - this.mClaimButton.width / 2 + this.mNotificationIcon.width / 2 : 0;
            this.mNotificationIcon.y = this.mPackAnim ? this.mClaimButton.y + this.mClaimButton.height / 2 + this.mNotificationIcon.height / 2 : 0;
            addChild(this.mNotificationIcon);
            SpecialFX.createYoYoZoomTransition(this.mNotificationIcon,1,1,-1,null,null,false);
         }
         this.mNotificationIcon.visible = param1;
      }
      
      public function setEnabled(param1:Boolean) : void
      {
         alpha = param1 ? 1 : 0.8;
         touchable = param1;
      }
   }
}

