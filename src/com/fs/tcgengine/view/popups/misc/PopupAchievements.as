package com.fs.tcgengine.view.popups.misc
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.model.rules.BadgeDef;
   import com.fs.tcgengine.model.rules.StarsRewardsDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.battle.FSBattlefieldUserPortrait;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.components.popups.map.AchievementProgress;
   import com.fs.tcgengine.view.components.popups.map.PlayerStatisticsBar;
   import com.fs.tcgengine.view.components.popups.misc.StarsReward;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   import feathers.controls.ScrollContainer;
   import feathers.controls.ScrollPolicy;
   import feathers.events.FeathersEventType;
   import feathers.layout.Direction;
   import feathers.layout.HorizontalAlign;
   import feathers.layout.HorizontalLayout;
   import feathers.layout.TiledRowsLayout;
   import feathers.layout.VerticalAlign;
   import flash.utils.Dictionary;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.events.Event;
   
   public class PopupAchievements extends PopupStandard
   {
      
      private const STARS_BG_NAME:String = "3stars_icon";
      
      private const NEXT_REWARDS_BG_NAME:String = "3stars_socket_total";
      
      private var mStarsRewardsToShow:Vector.<StarsRewardsDef>;
      
      private var mTopContainer:Component;
      
      private var m3StarsAchievementProgress:AchievementProgress;
      
      private var mNextRewardsBG:FSImage;
      
      private var mNextRewardsTextfield:FSTextfield;
      
      private var mStarsRewardsScrollContainer:ScrollContainer;
      
      private var mStatisticsBar:PlayerStatisticsBar;
      
      private var mBottomContainer:Component;
      
      private var mScrollContainer:ScrollContainer;
      
      private var mAlternativeBottomBG:FSImage;
      
      private var mBadgesAchievementsVector:Vector.<AchievementProgress>;
      
      public function PopupAchievements(param1:Boolean = true)
      {
         super(param1);
      }
      
      override protected function getBackgroundName(param1:String) : void
      {
         mBGName = Constants.POPUP_EXTENDED_NAME;
      }
      
      override protected function createBackground(param1:String, param2:int = 0) : void
      {
         super.createBackground(param1,1220);
         if(Boolean(mBox) && Config.getConfig().gameHasCustomPopups())
         {
            mBox.scale = Constants.POPUP_EXTENDED_SCALE_FACTOR;
         }
      }
      
      override protected function setResourcesToLoad() : void
      {
         this.refreshStarsRewardsToClaim();
         var _loc1_:Screen = InstanceMng.getCurrentScreen();
         if(_loc1_ != null)
         {
            InstanceMng.getResourcesMng().addResourcesFolderByName("popups/achievementsPopup");
            this.addPortraitResources();
         }
         super.setResourcesToLoad();
      }
      
      protected function addPortraitResources() : void
      {
         var _loc1_:UserData = Utils.getOwnerUserData();
         InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + FSBattlefieldUserPortrait.FRAME_BG_NAME,FSResourceMng.TYPE_TEXTURE_PNG);
         if(Config.getConfig().battleEnemyPortraitSpecial())
         {
            InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + FSBattlefieldUserPortrait.ENEMY_FRAME_BG_NAME,FSResourceMng.TYPE_TEXTURE_PNG);
         }
         if(Config.getConfig().hasPortraits())
         {
            if(_loc1_)
            {
               if(!Config.smPortraitFramesInAtlas)
               {
                  InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + _loc1_.getCurrentPortraitBGImageName(),FSResourceMng.TYPE_TEXTURE_PNG);
               }
               InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + FSResourceMng.DEFAULT_PHOTO_NAME,FSResourceMng.TYPE_TEXTURE_PNG);
            }
         }
      }
      
      override protected function removeFromStage() : void
      {
         var _loc1_:int = 0;
         if(this.m3StarsAchievementProgress)
         {
            this.m3StarsAchievementProgress.removeFromParent(true);
            this.m3StarsAchievementProgress = null;
         }
         if(this.mNextRewardsBG)
         {
            this.mNextRewardsBG.removeFromParent(true);
            this.mNextRewardsBG = null;
         }
         if(this.mNextRewardsTextfield)
         {
            this.mNextRewardsTextfield.removeFromParent(true);
            this.mNextRewardsTextfield = null;
         }
         if(this.mStarsRewardsScrollContainer)
         {
            this.mStarsRewardsScrollContainer.removeFromParent(true);
            this.mStarsRewardsScrollContainer = null;
         }
         if(this.mTopContainer)
         {
            this.mTopContainer.removeFromParent(true);
            this.mTopContainer = null;
         }
         if(this.mBottomContainer)
         {
            this.mBottomContainer.removeFromParent(true);
            this.mBottomContainer = null;
         }
         if(this.mBadgesAchievementsVector)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mBadgesAchievementsVector.length)
            {
               this.mBadgesAchievementsVector[_loc1_].removeFromParent(true);
               _loc1_++;
            }
            Utils.destroyArray(this.mBadgesAchievementsVector);
            this.mBadgesAchievementsVector = null;
         }
         if(this.mScrollContainer)
         {
            this.mScrollContainer.removeFromParent(true);
            this.mScrollContainer = null;
         }
         if(this.mStatisticsBar)
         {
            this.mStatisticsBar.removeFromParent(true);
            this.mStatisticsBar = null;
         }
         if(this.mAlternativeBottomBG)
         {
            this.mAlternativeBottomBG.removeFromParent(true);
            this.mAlternativeBottomBG = null;
         }
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("popups/achievementsPopup",FSResourceMng.PREFIX_TEXTURE);
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("portraits",FSResourceMng.PREFIX_TEXTURE);
         if(Config.getConfig().gameHasBadges())
         {
            InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("badges",FSResourceMng.PREFIX_TEXTURE);
         }
         InstanceMng.getPopupMng().removePopup(FSPopupMng.ACHIEVEMENTS_POPUP_NAME);
         Utils.destroyArray(this.mStarsRewardsToShow);
         this.mStarsRewardsToShow = null;
         super.removeFromStage();
      }
      
      override protected function createUI() : void
      {
         super.createUI();
         if(Config.getConfig().gameHasBuildingBadges())
         {
            this.repositionItems();
         }
         this.init();
         if(InstanceMng.getTutorialMapMng().isTutorialON())
         {
            touchable = false;
         }
      }
      
      private function repositionItems() : void
      {
         mBox.y += mBox.height * 0.1;
         mCloseButton.y += mCloseButton.height * 0.4;
      }
      
      private function init() : void
      {
         this.createTopSection();
         this.createBottomSection();
         this.createStatisticsBar();
      }
      
      private function createTopSection() : void
      {
         this.createTopContainer();
         this.create3StarsAchievementProgress();
         this.fillStarsRewardsToClaim();
         this.createNextRewardsSection();
         this.create3StarsRewardsContainer();
      }
      
      private function fillStarsRewardsToClaim() : void
      {
         var _loc1_:StarsReward = null;
         var _loc2_:StarsRewardsDef = null;
         var _loc3_:int = 0;
         if(this.mStarsRewardsScrollContainer == null)
         {
            if(this.mStarsRewardsToShow)
            {
               _loc3_ = 0;
               while(_loc3_ < this.mStarsRewardsToShow.length)
               {
                  _loc2_ = this.mStarsRewardsToShow[_loc3_];
                  _loc1_ = new StarsReward(_loc2_);
                  _loc1_.setTooltipText(TextManager.replaceParameters(TextManager.getText("TID_3STAR_TOOLTIP"),[_loc2_.getStarsAmount()]));
                  this.addStarsRewardToScrollContainer(_loc1_);
                  _loc1_.setParentScrollContainer(this.mStarsRewardsScrollContainer);
                  _loc3_++;
               }
            }
         }
      }
      
      private function addStarsRewardToScrollContainer(param1:StarsReward) : void
      {
         if(this.mStarsRewardsScrollContainer == null)
         {
            this.mStarsRewardsScrollContainer = new ScrollContainer();
            this.mStarsRewardsScrollContainer.width = mBox.width * 0.9 - (this.m3StarsAchievementProgress.x + this.m3StarsAchievementProgress.width * 1.1);
            this.mStarsRewardsScrollContainer.height = param1.height * 1.05;
            this.mStarsRewardsScrollContainer.verticalScrollPolicy = ScrollPolicy.OFF;
            this.mStarsRewardsScrollContainer.layout = this.getStarsRewardsScrollContainerLayout();
            this.mStarsRewardsScrollContainer.x = this.m3StarsAchievementProgress.x + this.m3StarsAchievementProgress.width * 1.05;
            this.mStarsRewardsScrollContainer.y = (mBox.height * 0.5 - this.mStarsRewardsScrollContainer.height) / 2;
            this.mTopContainer.addChild(this.mStarsRewardsScrollContainer);
            this.mStarsRewardsScrollContainer.addEventListener(FeathersEventType.SCROLL_START,this.onScrollStart);
         }
         this.mStarsRewardsScrollContainer.addChild(param1);
      }
      
      private function onScrollStart(param1:Event) : void
      {
         var _loc2_:int = 0;
         if(this.mStarsRewardsScrollContainer)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mStarsRewardsScrollContainer.numChildren)
            {
               if(this.mStarsRewardsScrollContainer.getChildAt(_loc2_) != null && this.mStarsRewardsScrollContainer.getChildAt(_loc2_) is StarsReward)
               {
                  StarsReward(this.mStarsRewardsScrollContainer.getChildAt(_loc2_)).closeTooltip();
               }
               _loc2_++;
            }
         }
      }
      
      private function getStarsRewardsScrollContainerLayout() : HorizontalLayout
      {
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.gap = 3;
         return _loc1_;
      }
      
      private function createTopContainer() : void
      {
         if(this.mTopContainer == null)
         {
            this.mTopContainer = new Component();
         }
         this.mTopContainer.x = mBox.width * 0.06;
         this.mTopContainer.y = Config.getConfig().gameHasBuildingBadges() ? mBox.height * 0.13 : mBox.height * 0.04;
         addChild(this.mTopContainer);
      }
      
      private function create3StarsAchievementProgress() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         if(this.m3StarsAchievementProgress == null)
         {
            _loc1_ = InstanceMng.getLevelsDefMng().getTotalLevelsAmount();
            _loc2_ = InstanceMng.getUserDataMng().getOwnerUserData().get3StarLevelsCompleted();
            _loc3_ = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
            _loc4_ = this.STARS_BG_NAME;
            if(_loc3_ != UserDataMng.DIFFICULTY_EASY)
            {
               _loc4_ = _loc4_ + "_diff_0" + String(int(_loc3_ + 1));
            }
            this.m3StarsAchievementProgress = new AchievementProgress(TextManager.getText("TID_3STAR_TITLE"),_loc2_ + "/" + _loc1_,_loc4_,false);
            this.m3StarsAchievementProgress.touchable = true;
            this.m3StarsAchievementProgress.setTooltipText(TextManager.getText("TID_3STAR_REWARD_TOOLTIP"));
         }
         this.m3StarsAchievementProgress.x = 0;
         this.m3StarsAchievementProgress.y = this.m3StarsAchievementProgress.height * 0.2;
         this.m3StarsAchievementProgress.setProgress(_loc2_ / _loc1_);
         this.mTopContainer.addChild(this.m3StarsAchievementProgress);
      }
      
      private function createNextRewardsSection() : void
      {
         if(this.mNextRewardsBG == null)
         {
            this.mNextRewardsBG = new FSImage(Root.assets.getTexture(this.NEXT_REWARDS_BG_NAME));
            this.mNextRewardsBG.x = this.m3StarsAchievementProgress.x;
            this.mNextRewardsBG.y = this.m3StarsAchievementProgress.y + this.m3StarsAchievementProgress.height * 1.1;
            this.mTopContainer.addChild(this.mNextRewardsBG);
         }
      }
      
      private function create3StarsRewardsContainer() : void
      {
         var _loc1_:int = 0;
         if(this.mNextRewardsTextfield == null && Boolean(this.mNextRewardsBG))
         {
            _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
            this.mNextRewardsTextfield = new FSTextfield(this.mNextRewardsBG.width * 0.9,this.mNextRewardsBG.height * 0.9,TextManager.getText("TID_LEVEL_DIFF_" + String(int(_loc1_ + 1))));
            this.mNextRewardsTextfield.fontName = FSResourceMng.getFontByType();
            this.mNextRewardsTextfield.fontSize = FSResourceMng.FONT_STD_SUBTITLE_SIZE;
            this.mNextRewardsTextfield.x = this.mNextRewardsBG.x + (this.mNextRewardsBG.width - this.mNextRewardsTextfield.width) / 2;
            this.mNextRewardsTextfield.y = this.mNextRewardsBG.y + (this.mNextRewardsBG.height - this.mNextRewardsTextfield.height) / 2;
            this.mTopContainer.addChild(this.mNextRewardsTextfield);
         }
      }
      
      private function createBottomSection() : void
      {
         var _loc1_:int = 0;
         this.createBottomContainer();
         if(Config.getConfig().gameHasBadges())
         {
            this.createBadgesAchievements();
         }
         else if(this.mAlternativeBottomBG == null)
         {
            this.mAlternativeBottomBG = new FSImage(Root.assets.getTexture("achievement_art"));
            _loc1_ = mBox.width * 0.9;
            this.mAlternativeBottomBG.x = (_loc1_ - this.mAlternativeBottomBG.width) / 2;
            this.mAlternativeBottomBG.y = 0;
            this.mBottomContainer.addChild(this.mAlternativeBottomBG);
         }
      }
      
      private function createBottomContainer() : void
      {
         if(this.mBottomContainer == null)
         {
            this.mBottomContainer = new Component();
            this.mBottomContainer.touchable = true;
         }
         var _loc1_:int = mBox.width * 0.9;
         this.mBottomContainer.x = (mBox.width - _loc1_) / 2;
         this.mBottomContainer.y = this.mTopContainer.y + this.mTopContainer.height * 1.1;
         addChild(this.mBottomContainer);
      }
      
      private function isBadgeClaimed(param1:BadgeDef) : Boolean
      {
         return InstanceMng.getUserDataMng().getOwnerUserData().getBadgesRewardsClaimedBySku(param1.getSku());
      }
      
      private function createBadgesAchievements() : void
      {
         var _loc2_:BadgeDef = null;
         var _loc3_:AchievementProgress = null;
         var _loc4_:int = 0;
         var _loc5_:Vector.<BadgeDef> = null;
         var _loc6_:int = 0;
         var _loc1_:Dictionary = InstanceMng.getBadgesDefMng().getAllDefs();
         if(_loc1_)
         {
            for each(_loc2_ in _loc1_)
            {
               if(_loc5_ == null)
               {
                  _loc5_ = new Vector.<BadgeDef>();
               }
               if(!this.isBadgeClaimed(_loc2_))
               {
                  _loc5_.push(_loc2_);
               }
            }
            _loc5_.sort(DictionaryUtils.sortByIndexAsc);
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               _loc2_ = _loc5_[_loc6_];
               _loc4_ = InstanceMng.getUserDataMng().getOwnerUserData().getBadgesAmountByBadgeSku(_loc2_.getSku());
               _loc3_ = new AchievementProgress(_loc2_.getName(),_loc4_ + "/" + _loc2_.getAmountToUnlock(),_loc2_.getBGImageName(),true,_loc2_);
               _loc3_.setProgress(_loc4_ / _loc2_.getAmountToUnlock());
               this.addBadgeToScrollContainer(_loc3_);
               this.addBadgeToVector(_loc3_);
               _loc6_++;
            }
         }
         if(this.mScrollContainer)
         {
            this.mScrollContainer.touchable = true;
         }
      }
      
      private function addBadgeToScrollContainer(param1:AchievementProgress) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.mScrollContainer == null)
         {
            this.mScrollContainer = new ScrollContainer();
            _loc2_ = mBox.width * 0.9;
            _loc3_ = mBox.height * 0.415;
            this.mScrollContainer.width = _loc2_;
            this.mScrollContainer.height = _loc3_;
            this.mScrollContainer.layout = this.getContainerLayout(param1.height);
            this.mScrollContainer.x = (_loc2_ - this.mScrollContainer.width) / 2;
            this.mScrollContainer.y = 15;
            this.mBottomContainer.addChild(this.mScrollContainer);
         }
         this.mScrollContainer.addChild(param1);
      }
      
      private function addBadgeToVector(param1:AchievementProgress) : void
      {
         if(this.mBadgesAchievementsVector == null)
         {
            this.mBadgesAchievementsVector = new Vector.<AchievementProgress>();
         }
         this.mBadgesAchievementsVector.push(param1);
      }
      
      private function getContainerLayout(param1:int) : TiledRowsLayout
      {
         var _loc2_:TiledRowsLayout = new TiledRowsLayout();
         _loc2_.paging = Direction.NONE;
         _loc2_.horizontalGap = 5;
         _loc2_.verticalGap = -(param1 * 1.75);
         _loc2_.paddingTop = 2;
         _loc2_.paddingRight = 0;
         _loc2_.paddingBottom = -(param1 * 1.75);
         _loc2_.paddingLeft = 0;
         _loc2_.verticalAlign = VerticalAlign.TOP;
         _loc2_.tileVerticalAlign = VerticalAlign.TOP;
         _loc2_.horizontalAlign = HorizontalAlign.CENTER;
         _loc2_.tileHorizontalAlign = HorizontalAlign.CENTER;
         return _loc2_;
      }
      
      override protected function setupAcceptButton(param1:String, param2:String = "", param3:String = "") : void
      {
      }
      
      private function refreshStarsRewardsToClaim() : void
      {
         var _loc2_:StarsRewardsDef = null;
         var _loc1_:Dictionary = InstanceMng.getStarsRewardsDefMng().getAllDefs();
         var _loc3_:UserData = Utils.getOwnerUserData();
         if(_loc3_)
         {
            for each(_loc2_ in _loc1_)
            {
               if(_loc2_)
               {
                  if(!_loc3_.isStarsRewardAlreadyClaimed(_loc2_.getSku()))
                  {
                     if(this.mStarsRewardsToShow == null)
                     {
                        this.mStarsRewardsToShow = new Vector.<StarsRewardsDef>();
                     }
                     this.mStarsRewardsToShow.push(_loc2_);
                  }
               }
            }
            if(this.mStarsRewardsToShow)
            {
               this.mStarsRewardsToShow.sort(DictionaryUtils.sortByIndexAsc);
            }
         }
      }
      
      override public function onConnectionChange() : void
      {
         super.onConnectionChange();
         var _loc1_:Boolean = InstanceMng.getServerConnection().isUserLoggedIn();
         this.lockUI(!_loc1_);
      }
      
      public function removeStarReward(param1:StarsReward) : void
      {
         if(param1)
         {
            param1.removeFromParent();
            param1.destroy();
            if(this.mStarsRewardsScrollContainer)
            {
               this.mStarsRewardsScrollContainer.validate();
            }
         }
      }
      
      public function removeAchievementProgress(param1:AchievementProgress) : void
      {
         if(param1)
         {
            param1.removeFromParent();
            param1.destroy();
            if(this.mScrollContainer)
            {
               this.mScrollContainer.validate();
            }
         }
      }
      
      public function lockUI(param1:Boolean) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:int = 0;
         if(this.mScrollContainer)
         {
            _loc3_ = 0;
            while(_loc3_ < this.mScrollContainer.numChildren)
            {
               _loc2_ = this.mScrollContainer.getChildAt(_loc3_);
               if(_loc2_ != null && _loc2_ is AchievementProgress)
               {
                  AchievementProgress(_loc2_).setEnabled(!param1);
               }
               _loc3_++;
            }
         }
         if(this.mStarsRewardsScrollContainer)
         {
            _loc3_ = 0;
            while(_loc3_ < this.mStarsRewardsScrollContainer.numChildren)
            {
               _loc2_ = this.mStarsRewardsScrollContainer.getChildAt(_loc3_);
               if(_loc2_ != null && _loc2_ is StarsReward)
               {
                  StarsReward(_loc2_).setEnabled(!param1);
               }
               _loc3_++;
            }
         }
      }
      
      override protected function performOnOpenDefaultOps(param1:FSCoordinate, param2:Number = 0.6) : void
      {
         super.performOnOpenDefaultOps(param1,param2);
         this.lockUI(false);
      }
      
      private function createStatisticsBar() : void
      {
         if(this.mStatisticsBar == null)
         {
            this.mStatisticsBar = new PlayerStatisticsBar();
            this.mStatisticsBar.name = "statsBar";
         }
         this.mStatisticsBar.x = (Starling.current.stage.stageWidth - this.mStatisticsBar.width) / 2;
         this.mStatisticsBar.y = -this.mStatisticsBar.height;
         this.mStatisticsBar.visible = false;
      }
      
      override public function hideTemporarily(param1:Function = null, param2:Array = null) : void
      {
         super.hideTemporarily(param1,param2);
         if(this.mStatisticsBar)
         {
            TweenMax.delayedCall(0.25,this.setSocialBarVisible,[false]);
         }
      }
      
      private function setSocialBarVisible(param1:Boolean) : void
      {
         if(this.mStatisticsBar)
         {
            this.mStatisticsBar.visible = param1;
         }
      }
      
      private function performTransitionTweenStatsBar() : void
      {
         var _loc1_:FSCoordinate = new FSCoordinate();
         if(this.mStatisticsBar != null)
         {
            _loc1_.setX((Starling.current.stage.stageWidth - this.mStatisticsBar.width) / 2);
            _loc1_.setY(this.mStatisticsBar.height * 0.15);
            this.mStatisticsBar.x = (Starling.current.stage.stageWidth - this.mStatisticsBar.width) / 2;
            this.mStatisticsBar.y = -this.mStatisticsBar.height;
            this.mStatisticsBar.visible = true;
            InstanceMng.getCurrentScreen().addChild(this.mStatisticsBar);
            SpecialFX.createTransition(this.mStatisticsBar,_loc1_,0.5,0,this.createStatisticsBarUserPortrait);
         }
      }
      
      private function createStatisticsBarUserPortrait() : void
      {
         if(this.mStatisticsBar)
         {
            this.mStatisticsBar.createUserPortrait();
         }
         if(InstanceMng.getTutorialMapMng().isTutorialON())
         {
            touchable = true;
            InstanceMng.getTutorialMapMng().increaseCurrentStep();
         }
      }
      
      override protected function performOpeningTransition(param1:FSCoordinate = null) : void
      {
         if(this.mStatisticsBar)
         {
            y += this.mStatisticsBar.height / 3;
         }
         super.performOpeningTransition(param1);
      }
      
      override protected function onPopupOpenTransitionOver() : void
      {
         super.onPopupOpenTransitionOver();
         if(!mClosed)
         {
            this.performTransitionTweenStatsBar();
         }
      }
      
      override public function onClose(param1:Event) : void
      {
         if(param1)
         {
            param1.stopImmediatePropagation();
         }
         closePopup();
      }
      
      public function isScrollContainerScrolling() : Boolean
      {
         return this.mScrollContainer ? this.mScrollContainer.isScrolling : true;
      }
      
      public function getPlayerStatistics() : PlayerStatisticsBar
      {
         return this.mStatisticsBar;
      }
   }
}

