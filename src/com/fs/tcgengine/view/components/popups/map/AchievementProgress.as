package com.fs.tcgengine.view.components.popups.map
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.controller.rules.PacksDefMng;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.rules.BadgeDef;
   import com.fs.tcgengine.model.rules.PackDef;
   import com.fs.tcgengine.model.rules.RewardDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSMapScreen;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSGaugeProgressBar;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.popups.misc.PopupAchievements;
   import com.greensock.TweenMax;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   
   public class AchievementProgress extends Component implements FSModelUnloadableInterface
   {
      
      private const BG_NAME:String = "3stars_socket";
      
      private var mContainer:Component;
      
      private var mImage:FSImage;
      
      private var mTitleTextfield:FSTextfield;
      
      private var mProgressBar:FSGaugeProgressBar;
      
      private var mTitle:String;
      
      private var mSubtitle:String;
      
      private var mImageName:String;
      
      private var mBadgeDef:BadgeDef;
      
      private var mNotificationIcon:FSImage;
      
      public function AchievementProgress(param1:String, param2:String, param3:String, param4:Boolean = true, param5:BadgeDef = null)
      {
         super();
         this.mTitle = param1;
         this.mSubtitle = param2;
         this.mImageName = param3;
         this.mBadgeDef = param5;
         this.createUI();
         touchable = param4;
         addEventListener(TouchEvent.TOUCH,this.onTouch);
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         if(this.mBadgeDef)
         {
            _loc2_ = param1 ? param1.getTouch(this,TouchPhase.ENDED) : null;
            if(_loc2_)
            {
               if(InstanceMng.getPopupMng().getPopupShown() is PopupAchievements)
               {
                  if(!PopupAchievements(InstanceMng.getPopupMng().getPopupShown()).isScrollContainerScrolling())
                  {
                     this.claimTriggered();
                  }
               }
            }
            _loc2_ = param1 ? param1.getTouch(this,TouchPhase.HOVER) : null;
            alpha = _loc2_ ? 0.8 : 1;
         }
      }
      
      private function claimTriggered() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            if(this.isClaimeable())
            {
               touchable = false;
               PopupAchievements(InstanceMng.getPopupMng().getPopupShown()).lockUI(true);
               this.onClaimReward();
            }
            else
            {
               _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData().getBadgesAmountByBadgeSku(this.mBadgeDef.getSku());
               _loc2_ = this.mBadgeDef.getAmountToUnlock() - _loc1_;
               Utils.setLogText(TextManager.getText("TID_ACHIEVEMENT_REQUIREMENT"),true);
            }
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true);
         }
      }
      
      private function isClaimeable() : Boolean
      {
         if(this.mBadgeDef == null)
         {
            return false;
         }
         var _loc1_:int = InstanceMng.getUserDataMng().getOwnerUserData().getBadgesAmountByBadgeSku(this.mBadgeDef.getSku());
         var _loc2_:int = this.mBadgeDef.getAmountToUnlock() - _loc1_;
         return _loc2_ <= 0 && InstanceMng.getServerConnection().isUserLoggedIn();
      }
      
      private function onClaimReward() : void
      {
         var _loc1_:RewardDef = this.mBadgeDef ? RewardDef(InstanceMng.getRewardsDefMng().getDefBySku(this.mBadgeDef.getRewardSku())) : null;
         var _loc2_:PackDef = _loc1_ ? PackDef(InstanceMng.getPacksDefMng().getDefBySku(_loc1_.getPackSku())) : null;
         if(_loc2_)
         {
            FSTracker.trackMiscAction(FSTracker.CATEGORY_BADGE_REWARD,FSTracker.ACTION_COMPLETED,{"sku":this.mBadgeDef.getSku()});
            if(InstanceMng.getPopupMng().getPopupShown())
            {
               PopupAchievements(InstanceMng.getPopupMng().getPopupShown()).removeAchievementProgress(this);
            }
            InstanceMng.getUserDataMng().getOwnerUserData().addBadgeRewardClaimed(this.mBadgeDef.getSku(),false);
            if(InstanceMng.getPopupMng().getPopupShown())
            {
               Utils.openPack(_loc2_,PacksDefMng.PACK_ACH_PROGRESS);
            }
            if(InstanceMng.getCurrentScreen() is FSMapScreen)
            {
               FSMapScreen(InstanceMng.getCurrentScreen()).onAchievementRewardClaimedHideNotificationIcon();
            }
         }
         else
         {
            touchable = this.isClaimeable();
         }
         this.removeNotificationIcon();
      }
      
      private function createUI() : void
      {
         this.createStarsContainer();
         this.createStarsImages();
         this.createTitleTextfield();
         this.createProgressBar();
         if(this.isClaimeable())
         {
            this.showNotificationIcon();
         }
      }
      
      private function createStarsContainer() : void
      {
         var _loc1_:FSImage = null;
         if(Root.assets.getTexture(this.BG_NAME))
         {
            if(this.mContainer == null)
            {
               this.mContainer = new Component();
               this.mContainer.touchable = true;
               _loc1_ = new FSImage(Root.assets.getTexture(this.BG_NAME));
               _loc1_.touchable = true;
               this.mContainer.addChild(_loc1_);
            }
            addChild(this.mContainer);
         }
      }
      
      private function createStarsImages() : void
      {
         if(this.mImage == null && Boolean(this.mContainer))
         {
            this.mImage = new FSImage(Root.assets.getTexture(this.mImageName));
            this.mImage.x = 3;
            this.mImage.y = (this.mContainer.height - this.mImage.height) / 2;
            this.mContainer.addChild(this.mImage);
         }
      }
      
      private function createTitleTextfield() : void
      {
         var _loc1_:String = null;
         if(Boolean(this.mTitleTextfield == null) && Boolean(this.mImage) && Boolean(this.mContainer))
         {
            this.mTitleTextfield = new FSTextfield(this.mContainer.width - this.mImage.width * 1.05,this.mContainer.height * 0.4,this.mTitle);
            this.mTitleTextfield.touchable = false;
            _loc1_ = this.isClaimeable() ? FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GREEN) : FSResourceMng.getFontByType();
            this.mTitleTextfield.fontName = _loc1_;
            this.mTitleTextfield.alignPivot();
            if(this.isClaimeable())
            {
               TweenMax.killTweensOf(this.mTitleTextfield);
               SpecialFX.createYoYoZoomTransition(this.mTitleTextfield,1.05,1.5,-1);
            }
            this.mTitleTextfield.x = this.mImage.x + this.mImage.width + this.mTitleTextfield.width / 2;
            this.mTitleTextfield.y = 0;
            this.mContainer.addChild(this.mTitleTextfield);
         }
      }
      
      private function createProgressBar() : void
      {
         if(this.mProgressBar == null && Boolean(this.mTitleTextfield))
         {
            this.mProgressBar = new FSGaugeProgressBar(this.mSubtitle);
            this.mProgressBar.touchable = false;
            this.mProgressBar.x = this.mTitleTextfield.x - this.mProgressBar.width / 2;
            this.setProgress(0);
            this.mContainer.addChild(this.mProgressBar);
         }
         if(this.mTitleTextfield)
         {
            this.mTitleTextfield.y = (this.mContainer.height - (this.mTitleTextfield.height + this.mProgressBar.height)) / 2;
         }
         if(Boolean(this.mProgressBar) && Boolean(this.mTitleTextfield))
         {
            this.mProgressBar.y = this.mTitleTextfield.y + this.mTitleTextfield.height - this.mProgressBar.height / 2;
         }
      }
      
      public function setProgress(param1:Number) : void
      {
         if(this.mProgressBar)
         {
            this.mProgressBar.setRatio(param1);
         }
      }
      
      override public function dispose() : void
      {
         if(this.mImage)
         {
            this.mImage.removeFromParent(true);
            this.mImage = null;
         }
         if(this.mTitleTextfield)
         {
            this.mTitleTextfield.removeFromParent(true);
            this.mTitleTextfield = null;
         }
         if(this.mProgressBar)
         {
            this.mProgressBar.removeFromParent();
            this.mProgressBar.destroy();
            this.mProgressBar = null;
         }
         if(this.mNotificationIcon)
         {
            this.mNotificationIcon.removeFromParent();
            this.mNotificationIcon.destroy();
            this.mNotificationIcon = null;
         }
         if(this.mContainer)
         {
            this.mContainer.removeChildren();
            this.mContainer.removeFromParent(true);
            this.mContainer = null;
         }
         this.mBadgeDef = null;
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
         super.dispose();
      }
      
      public function destroy() : void
      {
         if(this.mImage)
         {
            this.mImage.removeFromParent();
            this.mImage.destroy();
            this.mImage = null;
         }
         if(this.mTitleTextfield)
         {
            this.mTitleTextfield.removeFromParent();
            this.mTitleTextfield = null;
         }
         if(this.mProgressBar)
         {
            this.mProgressBar.removeFromParent();
            this.mProgressBar.destroy();
            this.mProgressBar = null;
         }
         if(this.mNotificationIcon)
         {
            this.mNotificationIcon.removeFromParent();
            this.mNotificationIcon.destroy();
            this.mNotificationIcon = null;
         }
         if(this.mContainer)
         {
            this.mContainer.removeChildren();
            this.mContainer.removeFromParent();
            this.mContainer = null;
         }
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
      }
      
      public function setEnabled(param1:Boolean) : void
      {
         alpha = param1 ? 1 : 0.8;
         this.mContainer.touchable = param1;
      }
      
      public function showNotificationIcon() : void
      {
         if(this.mNotificationIcon == null)
         {
            this.mNotificationIcon = new FSImage(Root.assets.getTexture("claim_warning"));
            this.mNotificationIcon.alignPivot();
            this.mNotificationIcon.x = width - this.mNotificationIcon.width / 2;
            this.mNotificationIcon.y = 0 + this.mNotificationIcon.height / 2;
            addChild(this.mNotificationIcon);
         }
      }
      
      private function removeNotificationIcon() : void
      {
         if(this.mNotificationIcon)
         {
            this.mNotificationIcon.removeFromParent();
            this.mNotificationIcon.destroy();
            this.mNotificationIcon = null;
         }
      }
   }
}

