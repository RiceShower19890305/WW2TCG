package com.fs.tcgengine.view.popups.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.CustomComponent;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.components.popups.map.ReferralProgressBar;
   import com.fs.tcgengine.view.components.popups.map.ReferralRewardInfo;
   import com.fs.tcgengine.view.misc.FSImage;
   import feathers.controls.ScrollContainer;
   import feathers.controls.ScrollPolicy;
   import feathers.layout.HorizontalLayout;
   import flash.desktop.Clipboard;
   import flash.desktop.ClipboardFormats;
   import flash.events.MouseEvent;
   import starling.core.Starling;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Align;
   
   public class PopupReferral extends PopupStandard
   {
      
      public static const BG_NAME:String = "daily_popup";
      
      public static const REFERRAL_TYPE_STD_RECRUIT:int = -1;
      
      public static const REFERRAL_TYPE_RECRUIT:int = 0;
      
      public static const REFERRAL_TYPE_PLAY_PVP:int = 1;
      
      public static const REFERRAL_TYPE_PLAY_RAIDS:int = 2;
      
      private var mReferralCodeTextfield:FSTextfield;
      
      private var mReferralsDoneLabel:FSTextfield;
      
      private var mReferralsRulesLabel:FSTextfield;
      
      private var mRedeemCodeButton:FSButton;
      
      private var mShareCodeButton:FSButton;
      
      private var mReferralProgressType0:ReferralProgressBar;
      
      private var mReferralProgressType1:ReferralProgressBar;
      
      private var mReferralProgressType2:ReferralProgressBar;
      
      private var mRewardsBG:CustomComponent;
      
      private var mScrollContainer:ScrollContainer;
      
      private var mRecruitCodeBG:FSImage;
      
      public function PopupReferral(param1:Boolean = true)
      {
         super(param1);
      }
      
      override protected function getBackgroundName(param1:String) : void
      {
         mBGName = BG_NAME;
      }
      
      override protected function createBackground(param1:String, param2:int = 0) : void
      {
         super.createBackground(param1,2000);
      }
      
      override protected function setupAcceptButton(param1:String, param2:String = "", param3:String = "") : void
      {
      }
      
      override protected function removeFromStage() : void
      {
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("framesFactionsRarities",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("frames",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         InstanceMng.getPopupMng().removePopup(FSPopupMng.REFERRAL_POPUP_NAME);
         super.removeFromStage();
      }
      
      override protected function createUI() : void
      {
         super.createUI();
         this.createProgressBars();
         this.createRewardsBG();
         this.fillRewards();
         this.createReferralsDoneSection();
         this.createRulesSection();
         this.createButtonsSection();
         this.createYourReferralCodeSection();
      }
      
      private function fillRewards() : void
      {
         var processDefs:Function = function(param1:Array, param2:int):void
         {
            var _loc3_:int = 0;
            var _loc4_:ReferralRewardInfo = null;
            var _loc5_:Object = null;
            if(param1)
            {
               _loc3_ = 0;
               while(_loc3_ < param1.length)
               {
                  _loc5_ = param1[_loc3_];
                  _loc4_ = new ReferralRewardInfo(param2,_loc5_["amount"],_loc5_);
                  addRewardToScrollContainer(_loc4_);
                  _loc3_++;
               }
            }
         };
         var rewardsDefs0:Array = Boolean(ServerConnection.smServerReferralsDefs) && ServerConnection.smServerReferralsDefs.hasOwnProperty(REFERRAL_TYPE_RECRUIT) ? ServerConnection.smServerReferralsDefs[REFERRAL_TYPE_RECRUIT]["amounts"] : null;
         var rewardsDefs1:Array = Boolean(ServerConnection.smServerReferralsDefs) && ServerConnection.smServerReferralsDefs.hasOwnProperty(REFERRAL_TYPE_PLAY_PVP) ? ServerConnection.smServerReferralsDefs[REFERRAL_TYPE_PLAY_PVP]["amounts"] : null;
         var rewardsDefs2:Array = Boolean(ServerConnection.smServerReferralsDefs) && ServerConnection.smServerReferralsDefs.hasOwnProperty(REFERRAL_TYPE_PLAY_RAIDS) ? ServerConnection.smServerReferralsDefs[REFERRAL_TYPE_PLAY_RAIDS]["amounts"] : null;
         processDefs(rewardsDefs0,REFERRAL_TYPE_RECRUIT);
         processDefs(rewardsDefs1,REFERRAL_TYPE_PLAY_PVP);
         processDefs(rewardsDefs2,REFERRAL_TYPE_PLAY_RAIDS);
      }
      
      private function createProgressBars() : void
      {
         var _loc3_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:FSCoordinate = null;
         var _loc1_:int = InstanceMng.getUserDataMng() ? InstanceMng.getUserDataMng().referralGetMaxByType(REFERRAL_TYPE_RECRUIT) : 0;
         var _loc2_:int = InstanceMng.getUserDataMng() ? InstanceMng.getUserDataMng().referralGetMaxByType(REFERRAL_TYPE_PLAY_PVP) : 0;
         _loc3_ = InstanceMng.getUserDataMng() ? InstanceMng.getUserDataMng().referralGetMaxByType(REFERRAL_TYPE_PLAY_RAIDS) : 0;
         var _loc4_:UserData = Utils.getOwnerUserData();
         var _loc5_:int = _loc4_ ? _loc4_.getReferralsAmount(REFERRAL_TYPE_RECRUIT) : 0;
         var _loc6_:int = _loc4_ ? _loc4_.getReferralsAmount(REFERRAL_TYPE_PLAY_PVP) : 0;
         _loc7_ = _loc4_ ? _loc4_.getReferralsAmount(REFERRAL_TYPE_PLAY_RAIDS) : 0;
         var _loc9_:int = mBox.width * 0.95;
         if(this.mReferralProgressType0 == null)
         {
            this.mReferralProgressType0 = new ReferralProgressBar(REFERRAL_TYPE_RECRUIT);
            _loc8_ = Utils.getXYPositionInContainer(0,this.mReferralProgressType0.width,this.mReferralProgressType0.height,_loc9_,this.mReferralProgressType0.height,3,1,true);
            this.mReferralProgressType0.x = _loc8_.getX();
            this.mReferralProgressType0.y = this.mReferralProgressType0.height / 4;
            this.mReferralProgressType0.updateProgressBar(_loc5_,_loc1_);
            addChild(this.mReferralProgressType0);
         }
         if(this.mReferralProgressType1 == null)
         {
            this.mReferralProgressType1 = new ReferralProgressBar(REFERRAL_TYPE_PLAY_PVP);
            _loc8_ = Utils.getXYPositionInContainer(1,this.mReferralProgressType1.width,this.mReferralProgressType1.height,_loc9_,this.mReferralProgressType1.height,3,1,true);
            this.mReferralProgressType1.x = _loc8_.getX();
            this.mReferralProgressType1.y = this.mReferralProgressType0.y;
            this.mReferralProgressType1.updateProgressBar(_loc6_,_loc2_);
            addChild(this.mReferralProgressType1);
         }
         if(this.mReferralProgressType2 == null)
         {
            this.mReferralProgressType2 = new ReferralProgressBar(REFERRAL_TYPE_PLAY_RAIDS);
            _loc8_ = Utils.getXYPositionInContainer(2,this.mReferralProgressType2.width,this.mReferralProgressType2.height,_loc9_,this.mReferralProgressType2.height,3,1,true);
            this.mReferralProgressType2.x = _loc8_.getX();
            this.mReferralProgressType2.y = this.mReferralProgressType0.y;
            this.mReferralProgressType2.updateProgressBar(_loc7_,_loc3_);
            addChild(this.mReferralProgressType2);
         }
      }
      
      private function createRewardsBG() : void
      {
         if(this.mRewardsBG == null)
         {
            this.mRewardsBG = Utils.createCustomBox("recruit_reward_socket",1708);
            this.mRewardsBG.x = (mBox.width - this.mRewardsBG.width) / 2;
            this.mRewardsBG.y = this.mReferralProgressType0.y + this.mReferralProgressType0.height * 1.05;
            addChild(this.mRewardsBG);
         }
      }
      
      private function createReferralsDoneSection() : void
      {
         var _loc3_:String = null;
         var _loc1_:UserData = Utils.getOwnerUserData();
         var _loc2_:int = _loc1_ ? _loc1_.getReferralsAmount(REFERRAL_TYPE_RECRUIT,true) : 0;
         if(this.mReferralsDoneLabel == null)
         {
            _loc3_ = _loc2_ > 0 ? " " + TextManager.getText("TID_RECRUIT_GOOD_JOB",true) : " :(";
            this.mReferralsDoneLabel = new FSTextfield(mBox.width * 0.55,mBox.height / 12,TextManager.replaceParameters(TextManager.getText("TID_RECRUIT_AMOUNT",true) + _loc3_,[_loc2_]));
            this.mReferralsDoneLabel.fontSize = FSResourceMng.FONT_STD_SEMI_SMALL_SIZE;
            this.mReferralsDoneLabel.format.horizontalAlign = Align.LEFT;
            this.mReferralsDoneLabel.x = 30;
            this.mReferralsDoneLabel.y = mBox.height - this.mReferralsDoneLabel.height * 1.2;
            addChild(this.mReferralsDoneLabel);
         }
      }
      
      private function createRulesSection() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc1_:String = TextManager.replaceParameters(TextManager.getText("TID_RECRUIT_INFO",true),[Config.smReferralGoldPerRecruitment,Config.getConfig().getUnlockGuildsLevel() - 1]);
         if(this.mReferralsRulesLabel == null)
         {
            _loc2_ = this.mRewardsBG.y + this.mRewardsBG.height * 1.025;
            _loc3_ = this.mReferralsDoneLabel.y - _loc2_;
            this.mReferralsRulesLabel = new FSTextfield(mBox.width * 0.66,_loc3_,_loc1_);
            this.mReferralsRulesLabel.fontSize = FSResourceMng.FONT_STD_SEMI_SMALL_SIZE;
            this.mReferralsRulesLabel.format.horizontalAlign = Align.LEFT;
            this.mReferralsRulesLabel.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_DESC);
            this.mReferralsRulesLabel.x = this.mReferralsDoneLabel.x;
            this.mReferralsRulesLabel.y = _loc2_;
            addChild(this.mReferralsRulesLabel);
         }
      }
      
      private function isEligibleToRedeemCode() : Boolean
      {
         var _loc1_:UserData = Utils.getOwnerUserData();
         var _loc2_:int = _loc1_ ? _loc1_.getCurrentLevelIndex(UserDataMng.DIFFICULTY_EASY) : 0;
         var _loc3_:Boolean = _loc1_ ? _loc1_.flagsReferralCodeRedeemed() : true;
         return !_loc3_ && _loc2_ < Config.getConfig().getUnlockGuildsLevel();
      }
      
      private function createButtonsSection() : void
      {
         if(this.mShareCodeButton == null)
         {
            this.mShareCodeButton = new FSButton(Root.assets.getTexture("button_green_large"),TextManager.getText("TID_RECRUIT_SHARE"));
            Utils.setupButton9Scale(this.mShareCodeButton,15,15,2.5,5,130.5,33.75);
            this.mShareCodeButton.addEventListener(Event.TRIGGERED,this.onShareCodeTriggered);
            if(Utils.isBrowser() || Utils.isDesktop())
            {
               this.mShareCodeButton.addEventListener(TouchEvent.TOUCH,this.onShareCodeTouched);
            }
            this.mShareCodeButton.fontSize = FSResourceMng.FONT_STD_SUBTITLE_SIZE;
            this.mShareCodeButton.x = mBox.width - this.mShareCodeButton.width / 2 * 1.25;
            this.mShareCodeButton.y = mBox.height - this.mShareCodeButton.height / 1.25;
            addChild(this.mShareCodeButton);
         }
         if(this.mRedeemCodeButton == null)
         {
            this.mRedeemCodeButton = new FSButton(Root.assets.getTexture("button_blue_large"),"");
            Utils.setupButton9Scale(this.mRedeemCodeButton,15,15,2.5,5,130.5,33.75);
            this.mRedeemCodeButton.addEventListener(Event.TRIGGERED,this.onRedeemCodeTriggered);
            if(Utils.isBrowser() || Utils.isDesktop())
            {
               this.mRedeemCodeButton.addEventListener(TouchEvent.TOUCH,this.onRedeemCodeTouched);
            }
            this.mRedeemCodeButton.fontSize = FSResourceMng.FONT_STD_SUBTITLE_SIZE;
            this.mRedeemCodeButton.x = this.mShareCodeButton.x;
            this.mRedeemCodeButton.y = this.mShareCodeButton.y - this.mShareCodeButton.height * 1.1;
            addChild(this.mRedeemCodeButton);
            this.refreshRedeemCodeButtonText();
         }
      }
      
      private function createYourReferralCodeSection() : void
      {
         if(this.mRecruitCodeBG == null)
         {
            this.mRecruitCodeBG = new FSImage(Root.assets.getTexture("recruit_code_socket"));
            addChild(this.mRecruitCodeBG);
         }
         var _loc1_:String = InstanceMng.getUserDataMng() ? InstanceMng.getUserDataMng().getOwnerUserData().getReferralCode() : "";
         if(this.mReferralCodeTextfield == null)
         {
            this.mReferralCodeTextfield = new FSTextfield(this.mRecruitCodeBG.width * 0.85,this.mReferralsDoneLabel.height * 0.85,TextManager.getText("TID_RECRUIT_CODE") + " " + _loc1_);
            addChild(this.mReferralCodeTextfield);
         }
         this.refreshReferralCodePosition();
      }
      
      private function refreshRedeemCodeButtonText() : void
      {
         var _loc1_:Boolean = this.isEligibleToRedeemCode();
         var _loc2_:String = _loc1_ ? TextManager.getText("TID_RECRUIT_REDEEM") : TextManager.getText("TID_RECRUIT_CODE_COPY");
         if(this.mRedeemCodeButton)
         {
            this.mRedeemCodeButton.text = _loc2_;
         }
      }
      
      private function refreshReferralCodePosition() : void
      {
         if(Boolean(this.mRecruitCodeBG) && Boolean(this.mShareCodeButton) && Boolean(this.mReferralCodeTextfield))
         {
            this.mRecruitCodeBG.alignPivot();
            this.mRecruitCodeBG.x = this.mShareCodeButton.x;
            this.mRecruitCodeBG.y = this.mRedeemCodeButton.y - this.mRedeemCodeButton.height;
            this.mReferralCodeTextfield.x = this.mRecruitCodeBG.x - this.mRecruitCodeBG.width / 2 + (this.mRecruitCodeBG.width - this.mReferralCodeTextfield.width) / 2;
            this.mReferralCodeTextfield.y = this.mRecruitCodeBG.y - this.mRecruitCodeBG.height / 2 + (this.mRecruitCodeBG.height - this.mReferralCodeTextfield.height) / 2;
         }
      }
      
      private function addRewardToScrollContainer(param1:ReferralRewardInfo) : void
      {
         var _loc2_:int = 0;
         if(this.mScrollContainer == null)
         {
            this.mScrollContainer = new ScrollContainer();
            _loc2_ = this.mRewardsBG.width * 0.95;
            this.mScrollContainer.width = _loc2_;
            this.mScrollContainer.height = param1.height;
            this.mScrollContainer.verticalScrollPolicy = ScrollPolicy.OFF;
            this.mScrollContainer.layout = this.getRewardsScrollContainerLayout();
            this.mScrollContainer.x = this.mRewardsBG.x + (this.mRewardsBG.width - _loc2_) / 2;
            this.mScrollContainer.y = this.mRewardsBG.y + (this.mRewardsBG.height - this.mScrollContainer.height) / 2;
            addChild(this.mScrollContainer);
         }
         this.mScrollContainer.addChild(param1);
      }
      
      private function getRewardsScrollContainerLayout() : HorizontalLayout
      {
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.gap = 3;
         _loc1_.paddingLeft = 20;
         _loc1_.verticalAlign = Align.CENTER;
         return _loc1_;
      }
      
      private function onRedeemCodeTriggered() : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc1_:Boolean = this.isEligibleToRedeemCode();
         if(_loc1_)
         {
            hideTemporarily(InstanceMng.getPopupMng().openRedeemReferralCodePopup);
         }
         else if(Utils.isMobile() || Utils.isDesktop())
         {
            _loc2_ = InstanceMng.getUserDataMng() ? InstanceMng.getUserDataMng().getOwnerUserData().getReferralCode() : "";
            _loc3_ = InstanceMng.getApplication().isFacebookBrowser() ? Utils.getShareGameText() : _loc2_;
            Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT,_loc3_);
            InstanceMng.getTextParticlesMng().showTextParticle(TextManager.getText("TID_RECRUIT_CODE_COPIED"),16777215,this.mRecruitCodeBG,-1,Align.CENTER,"",200,0.75);
         }
      }
      
      private function onShareCodeTriggered() : void
      {
         FSTracker.trackMiscAction(FSTracker.CATEGORY_REFERRALS,FSTracker.ACTION_SHARING_GAME);
         Utils.shareGame(false);
      }
      
      private function onShareCodeTouched(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1 ? param1.getTouch(this.mShareCodeButton) : null;
         if(!_loc2_)
         {
            return;
         }
         if(_loc2_.phase == TouchPhase.BEGAN)
         {
            Starling.current.nativeStage.addEventListener(MouseEvent.MOUSE_UP,this.copyShareCode);
         }
      }
      
      private function onRedeemCodeTouched(param1:TouchEvent) : void
      {
         var _loc3_:Touch = null;
         var _loc2_:Boolean = this.isEligibleToRedeemCode();
         if(!this.isEligibleToRedeemCode())
         {
            _loc3_ = param1 ? param1.getTouch(this.mRedeemCodeButton) : null;
            if(!_loc3_)
            {
               return;
            }
            if(_loc3_.phase == TouchPhase.BEGAN)
            {
               Starling.current.nativeStage.addEventListener(MouseEvent.MOUSE_UP,this.copyShareCode);
            }
         }
      }
      
      private function copyShareCode(param1:MouseEvent) : void
      {
         Starling.current.nativeStage.removeEventListener(MouseEvent.MOUSE_UP,this.copyShareCode);
         var _loc2_:String = "http://onelink.to/" + Config.getConfig().getStorageNamespace();
         var _loc3_:String = Utils.isDesktop() ? _loc2_ + " - " + Utils.getShareGameText() : Utils.getShareGameText();
         Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT,_loc3_);
         Utils.setLogText(TextManager.getText("TID_RECRUIT_CODE_COPIED"));
         InstanceMng.getTextParticlesMng().showTextParticle(TextManager.getText("TID_RECRUIT_CODE_COPIED"),16777215,this.mRecruitCodeBG,-1,Align.CENTER,"",200,0.75);
      }
      
      public function onCodeRedeemedSuccessfully() : void
      {
         InstanceMng.getUserDataMng().getOwnerUserData().setReferralCodeRedeemed(true);
         InstanceMng.getUserDataMng().updateFlags();
         this.refreshRedeemCodeButtonText();
      }
      
      public function isScrollContainerScrolling() : Boolean
      {
         return Boolean(this.mScrollContainer) && this.mScrollContainer.isScrolling;
      }
   }
}

