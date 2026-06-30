package com.fs.tcgengine.screens
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.AuctionsMng;
   import com.fs.tcgengine.controller.FSFacebookPlugin;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.controller.TutorialMapMng;
   import com.fs.tcgengine.controller.TutorialMng;
   import com.fs.tcgengine.model.auctions.Auction;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.model.rules.BundleDef;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.model.rules.MapDef;
   import com.fs.tcgengine.model.rules.TutorialMapDef;
   import com.fs.tcgengine.model.rules.WorldDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Tester;
   import com.fs.tcgengine.utils.TimerUtil;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.FSSprite3D;
   import com.fs.tcgengine.view.components.buttons.DifficultyButton;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.buttons.FSMenuButton;
   import com.fs.tcgengine.view.components.map.MapSubmenu;
   import com.fs.tcgengine.view.components.map.SubMenuButton;
   import com.fs.tcgengine.view.components.misc.FSGoldVisor;
   import com.fs.tcgengine.view.components.misc.FSTopMenuBar;
   import com.fs.tcgengine.view.components.popups.player.PlayerPortrait;
   import com.fs.tcgengine.view.map.ChooseWorldEffect;
   import com.fs.tcgengine.view.map.FSMapUnlockedEffect;
   import com.fs.tcgengine.view.map.MapPlane;
   import com.fs.tcgengine.view.map.MapPlayerPortrait;
   import com.fs.tcgengine.view.meshes.LevelItemContainer;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.popups.Popup;
   import com.fs.tcgengine.view.popups.misc.PopupRewards;
   import com.fs.tcgengine.view.popups.purchases.PopupProductDetail;
   import com.fs.tcgengine.view.popups.pvp.PopupPlayPvPOffline;
   import com.fs.tcgengine.view.popups.quests.PopupQuest;
   import com.greensock.TweenMax;
   import com.greensock.easing.Quart;
   import flash.events.MouseEvent;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.deg2rad;
   
   public class FSMapScreen extends Screen
   {
      
      public static const MAP_DRAGGED:String = "map_drag";
      
      public static var smMapsTouchable:Boolean = true;
      
      private const CAM_SPEED_FACTOR:Number = Main.smScaleFactor == 1 ? 0.85 : 0.9;
      
      private const BUTTONS_BASE_L_NAME:String = "menu_bar_button_L";
      
      private const BUTTONS_BASE_XS_NAME:String = "menu_bar_button_XS";
      
      private const DECK_BUILDER_BUTTON_NAME:String = "deckbuilder_map_icon";
      
      private const SHOP_BUTTON_NAME:String = "shop_map_icon";
      
      private const DUNGEONS_BUTTON_NAME:String = "dungeons_map_icon";
      
      private const RAIDS_BUTTON_NAME:String = "raids_map_icon";
      
      private const PVP_BUTTON_NAME:String = "pvp_map_icon";
      
      private const NOTIFICATIONS_BUTTON_NAME:String = "notifications_map_icon";
      
      private const GOLD_VISOR_BUTTON_NAME:String = "gold_button";
      
      private const SIDE_MAP_BG:String = "side_map";
      
      private const MAPS_OFFSET_SCROLLING:int = Utils.isBrowser() || Utils.isDesktop() ? 2 : 1;
      
      protected var mMapPlanesCatalog:Dictionary;
      
      private var mPlanesMaterialsAmountLoaded:int;
      
      private var mCurrentLevelItem:LevelItemContainer;
      
      private var mLastLevelPlayedItem:LevelItemContainer;
      
      private var mCurrentMapIndexOnScreen:int;
      
      private var mForwardLook:Vector3D;
      
      private var mMapMaterialsLoaded:Boolean = false;
      
      private var mSimpleResourcesLoaded:Boolean = false;
      
      protected var mAllMapsDefsArr:Array;
      
      protected var mIsSomethingNewInTheShop:Boolean;
      
      protected var mTopMenuBar:FSTopMenuBar;
      
      protected var mShopButton:FSMenuButton;
      
      protected var mNotificationIcon:FSImage;
      
      protected var mDeckBuilderButton:FSMenuButton;
      
      protected var mPvPButton:FSMenuButton;
      
      protected var mGoldVisor:FSGoldVisor;
      
      protected var mRaidsButton:FSMenuButton;
      
      protected var mDungeonsButton:FSMenuButton;
      
      private var mShowingComic:Boolean = false;
      
      private var mSideBG:FSImage;
      
      private var mWaitingToCenterTheCamOnCurrentLevel:Boolean = false;
      
      private var mTopScoresReceived:Boolean;
      
      private var mSubMenu:MapSubmenu;
      
      protected var mQuestsButton:SubMenuButton;
      
      protected var mAuctionsButton:SubMenuButton;
      
      protected var mLootButton:SubMenuButton;
      
      protected var mAchievementsIndicator:SubMenuButton;
      
      protected var mBattlePassButton:SubMenuButton;
      
      private var mIsMapUnlockedEffectActive:Boolean = true;
      
      protected var mDiffEasyButton:DifficultyButton;
      
      protected var mDiffMediumButton:DifficultyButton;
      
      protected var mDiffHardButton:DifficultyButton;
      
      private var mDiffBG:FSImage;
      
      private var mOwnerProfilePortrait:MapPlayerPortrait;
      
      private var mWaitingToTransitionPortraitToNextLevel:Boolean = false;
      
      private var mIsPortraitTransitioning:Boolean = false;
      
      private var mMapsContainer:FSSprite3D;
      
      private var mCustomOfferNewBanner:FSButton;
      
      private var mMapsBeingDragged:Boolean;
      
      private var mMapsDraggedTimer:uint;
      
      private var mIsFirstVisit:Boolean;
      
      private var mRecruitButton:FSButton;
      
      private var mMapSelectorButton:FSButton;
      
      private var mNewBanner:FSImage;
      
      public function FSMapScreen()
      {
         mNeedsLoadingBar = true;
         mScreenName = Constants.MAP_SCREEN_NAME;
         mOnlineDataSynced = false;
         addEventListener(MAP_DRAGGED,this.onMapDragged);
         super();
      }
      
      private function onMapDragged(param1:Event) : void
      {
         var _loc2_:FSSprite3D = param1.target is FSSprite3D ? FSSprite3D(param1.target) : null;
         var _loc3_:Number = Number(param1.data.d);
         var _loc4_:Boolean = param1.data.hasOwnProperty("isTween") == true && param1.data.isTween == true;
         this.dragMaps(_loc3_,_loc2_,_loc4_);
      }
      
      public function dragMaps(param1:Number, param2:FSSprite3D = null, param3:Boolean = false, param4:Boolean = false) : void
      {
         var _loc5_:MapPlane = null;
         var _loc6_:int = 0;
         var _loc7_:Boolean = true;
         _loc6_ = 0;
         while(_loc6_ < this.mMapsContainer.numChildren)
         {
            _loc5_ = MapPlane(this.mMapsContainer.getChildAt(_loc6_));
            if(_loc5_)
            {
               if(param2 != _loc5_ || _loc5_ == param2 && param3)
               {
                  if(!_loc5_.isMovable(param1))
                  {
                     _loc7_ = false;
                  }
               }
            }
            _loc6_++;
         }
         if(_loc7_)
         {
            clearTimeout(this.mMapsDraggedTimer);
            this.mMapsBeingDragged = true;
            _loc6_ = 0;
            while(_loc6_ < this.mMapsContainer.numChildren)
            {
               _loc5_ = MapPlane(this.mMapsContainer.getChildAt(_loc6_));
               if(_loc5_)
               {
                  if(param2 != _loc5_ || _loc5_ == param2 && param3)
                  {
                     if(_loc5_.isMovable(param1))
                     {
                        _loc5_.translateMap(param1,false);
                        if(param4)
                        {
                           _loc5_.setLevelItemsVisible(false);
                        }
                     }
                  }
               }
               _loc6_++;
            }
            this.mMapsDraggedTimer = setTimeout(this.updateMapsDraggedFlag,250);
         }
      }
      
      private function updateMapsDraggedFlag() : void
      {
         var _loc1_:MapPlane = null;
         var _loc2_:int = 0;
         this.mMapsBeingDragged = false;
         var _loc3_:Boolean = true;
         if(this.mMapsContainer)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mMapsContainer.numChildren)
            {
               _loc1_ = MapPlane(this.mMapsContainer.getChildAt(_loc2_));
               if(_loc1_)
               {
                  _loc1_.setLevelItemsVisible(true);
               }
               _loc2_++;
            }
         }
      }
      
      public function areMapsBeingDragged() : Boolean
      {
         return this.mMapsBeingDragged;
      }
      
      override public function lockUI(param1:Boolean) : void
      {
         if(this.mShopButton)
         {
            this.mShopButton.setEnabled(!param1);
         }
         if(this.mDeckBuilderButton)
         {
            this.mDeckBuilderButton.setEnabled(!param1);
         }
         if(this.mPvPButton)
         {
            this.mPvPButton.setEnabled(!param1);
         }
         if(this.mGoldVisor)
         {
            this.mGoldVisor.setEnabled(!param1);
         }
         if(this.mSubMenu)
         {
            this.mSubMenu.touchable = !param1;
         }
         super.lockUI(param1);
      }
      
      override protected function setupOnlineDataSyncing() : void
      {
         super.setupOnlineDataSyncing();
         if(mOnlineDataSynced && mScreenFullyLoaded)
         {
            if(this.mSimpleResourcesLoaded)
            {
               this.updateAllMapsLevels();
            }
            this.resetCameraPosition();
         }
      }
      
      public function onTopScoresInfoReceived(param1:Object) : void
      {
         var _loc5_:Object = null;
         TweenMax.killDelayedCallsTo(this.checkTopScores);
         var _loc2_:Array = param1 as Array;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Dictionary = Utils.getOwnerUserData().getTopScores();
         if(param1)
         {
            for each(_loc5_ in param1)
            {
               if(_loc7_ == null)
               {
                  _loc7_ = new Dictionary(true);
               }
               if(_loc7_[_loc5_.levelSku] == null && _loc5_.score != null)
               {
                  _loc7_[_loc5_.levelSku] = _loc5_.score;
               }
               else
               {
                  _loc7_[_loc5_.levelSku] = _loc7_[_loc5_.levelSku] < _loc5_.score ? _loc5_.score : _loc7_[_loc5_.levelSku];
               }
            }
         }
         this.mTopScoresReceived = true;
         this.enableAchievementsIndicator(true);
         FSDebug.debugTrace("Top Scores received");
         Utils.removeLog();
         Utils.getOwnerUserData().setTopScores(_loc7_);
         this.updateLevelItemStars();
         this.checkIfAnyStarsRewardsClaimeable();
         this.checkIfAnyBadgeRewardsClaimeable();
         this.checkIfAnyQuestClaimeable();
         this.checkIfAnyBattlePassQuestClaimeable();
         this.checkIfAnyCardCrafteable();
         this.checkAuctionsRewardsToClaim();
      }
      
      public function checkRewardsToClaim() : void
      {
         InstanceMng.getServerConnection().countInCollection("rewards","{\'uid\':\'" + InstanceMng.getUserDataMng().getOwnerUserData().getAccountId() + "\'}",this.onRewardsCount);
      }
      
      public function onRewardsCount(param1:int) : void
      {
         if(this.mLootButton)
         {
            this.mLootButton.showNotificationIcon(param1 > 0);
            this.mLootButton.setEnabled(param1 > 0);
         }
      }
      
      public function hideLootNotificationsIcon() : void
      {
         if(this.mLootButton)
         {
            this.mLootButton.showNotificationIcon(false);
            this.mLootButton.setEnabled(false);
         }
      }
      
      private function checkAuctionsRewardsToClaim() : void
      {
         var _loc1_:Array = null;
         var _loc2_:UserData = null;
         var _loc3_:Auction = null;
         if(this.mAuctionsButton)
         {
            _loc2_ = Utils.getOwnerUserData();
            if(_loc2_)
            {
               if(_loc2_.getAuctionIdCreatedArr() != null && _loc2_.getAuctionIdBiddedArr() == null)
               {
                  _loc1_ = _loc2_.getAuctionIdCreatedArr();
               }
               else if(_loc2_.getAuctionIdCreatedArr() == null && _loc2_.getAuctionIdBiddedArr() != null)
               {
                  _loc1_ = _loc2_.getAuctionIdBiddedArr();
               }
               else if(_loc2_.getAuctionIdCreatedArr() != null && _loc2_.getAuctionIdBiddedArr() != null)
               {
                  _loc1_ = _loc2_.getAuctionIdCreatedArr().concat(_loc2_.getAuctionIdBiddedArr());
               }
            }
            if(Boolean(_loc1_) && _loc1_.length > 0)
            {
               if(_loc1_.length > 12)
               {
                  _loc1_ = _loc1_.slice(0,12);
               }
               InstanceMng.getServerConnection().getAuctionInfoByAuctionIdArray(_loc1_,this.onGetAuctionInfoByArraySuccess);
            }
         }
      }
      
      private function onGetAuctionInfoByArraySuccess(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:Auction = null;
         if(param1)
         {
            _loc2_ = param1 as Array;
            _loc2_ = InstanceMng.getAuctionsMng().cleanAuctionsArrayByExistentInPlatform(_loc2_);
            if(Boolean(_loc2_) && _loc2_.length > 0)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc2_.length)
               {
                  _loc4_ = new Auction(_loc2_[_loc3_],0);
                  if(_loc4_.getAuctionInfo() != AuctionsMng.AUCTION_INFO_ACTIVE)
                  {
                     if(this.mAuctionsButton)
                     {
                        this.mAuctionsButton.showNotificationIcon(true);
                     }
                     break;
                  }
                  _loc3_++;
               }
            }
         }
      }
      
      private function onRaidRewardsSuccess(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         if(param1)
         {
            _loc2_ = param1 as Array;
            _loc3_ = false;
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               if(_loc2_[_loc4_].rewards != "")
               {
                  _loc3_ = true;
                  break;
               }
               _loc4_++;
            }
         }
      }
      
      public function checkIfAnyStarsRewardsClaimeable() : void
      {
         if(InstanceMng.getStarsRewardsDefMng().isAnyStarsRewardClaimeable())
         {
            if(this.mAchievementsIndicator)
            {
               this.mAchievementsIndicator.showNotificationIcon(true);
            }
         }
      }
      
      public function checkIfAnyBadgeRewardsClaimeable() : void
      {
         if(InstanceMng.getBadgesDefMng().isAnyBadgeRewardClaimeable())
         {
            if(this.mAchievementsIndicator)
            {
               this.mAchievementsIndicator.showNotificationIcon(true);
            }
         }
      }
      
      public function checkIfAnyCardCrafteable() : void
      {
         if(Config.getConfig().getDeckBuilderCraftMode())
         {
            if(InstanceMng.getCardsDefMng().isAnyCardCrafteable())
            {
               if(this.mDeckBuilderButton)
               {
                  this.mDeckBuilderButton.showDeckNotificationIcon();
               }
            }
         }
      }
      
      public function checkIfAnyQuestClaimeable() : void
      {
         var _loc1_:Boolean = InstanceMng.getQuestsMng().checkIfAnyQuestIsCompleted(false,false,true);
         if(this.mQuestsButton)
         {
            this.mQuestsButton.showNotificationIcon(_loc1_);
         }
      }
      
      public function checkIfAnyBattlePassQuestClaimeable() : void
      {
         var _loc1_:Boolean = InstanceMng.getQuestsMng().checkIfAnyQuestIsCompleted(true,false,true);
         if(this.mBattlePassButton)
         {
            this.mBattlePassButton.showNotificationIcon(_loc1_);
         }
      }
      
      public function onQuestClaimeableShowNotificationIcon() : void
      {
         if(this.mQuestsButton)
         {
            this.mQuestsButton.showNotificationIcon(true);
         }
      }
      
      public function onBattlePassQuestClaimeableShowNotificationIcon() : void
      {
         if(this.mBattlePassButton)
         {
            this.mBattlePassButton.showNotificationIcon(true);
         }
      }
      
      public function updateLevelItemStars() : void
      {
         var _loc1_:MapPlane = null;
         for each(_loc1_ in this.mMapPlanesCatalog)
         {
            _loc1_.createLevelItemStars();
         }
      }
      
      override protected function setResourcesToLoad() : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:MapDef = null;
         var _loc9_:String = null;
         var _loc10_:TutorialMapDef = null;
         var _loc11_:String = null;
         if(Utils.isMobile() || Utils.isDesktop())
         {
            super.setResourcesToLoad();
         }
         else
         {
            addResourcesFolder();
         }
         var _loc1_:Boolean = InstanceMng.getApplication().mapScreenHasBeenVisited();
         if(!_loc1_)
         {
            if(Config.HAS_GUILDS)
            {
               InstanceMng.getGuildsMng().init();
            }
            this.mIsFirstVisit = true;
         }
         InstanceMng.getServerConnection().addBackendEventHandlers();
         var _loc2_:UserData = Utils.getOwnerUserData();
         var _loc3_:int = _loc2_ ? _loc2_.getCurrentLevelIndex(UserDataMng.DIFFICULTY_EASY) : -1;
         var _loc4_:Boolean = _loc3_ == 1 && !_loc1_;
         this.fillMapPlanesCatalog();
         if(!_loc4_)
         {
            _loc5_ = this.mAllMapsDefsArr ? int(this.mAllMapsDefsArr.length) : 0;
            if(this.mMapPlanesCatalog)
            {
               _loc6_ = 1;
               while(_loc6_ <= _loc5_)
               {
                  if(this.mMapPlanesCatalog[_loc6_] == null && this.isMapEligibleToBeAdded(_loc6_))
                  {
                     _loc9_ = Utils.transformValueToString(_loc6_.toString(),2);
                     _loc8_ = MapDef(InstanceMng.getMapsDefMng().getDefBySku("map_" + _loc9_));
                     _loc7_ = _loc8_.calculateBGName();
                     InstanceMng.getResourcesMng().addResourceToLoad("maps/" + _loc7_,FSResourceMng.TYPE_TEXTURE_JPG);
                  }
                  _loc6_++;
               }
            }
         }
         if(Utils.isBrowser() || Utils.isDesktop())
         {
            this.addPopupsResources();
            this.addPopupAudioResources();
         }
         if(Config.getConfig().getTutorialON() && this.currentLevelHasTutorialMap())
         {
            InstanceMng.getResourcesMng().addResourceToLoad("tutorial/" + TutorialMng.TUTORIAL_SOLDIER_BG_NAME,FSResourceMng.TYPE_TEXTURE_PNG);
            _loc10_ = this.getCurrentTutorialMapDef();
            if(_loc10_)
            {
               _loc11_ = _loc10_.getExtraImageBG();
               if(_loc11_ != null && _loc11_ != "")
               {
                  InstanceMng.getResourcesMng().addResourceToLoad("tutorial/" + _loc11_,FSResourceMng.TYPE_TEXTURE_PNG);
               }
            }
            if(InstanceMng.getTutorialMapMng().getCurrentTutorialMapDef().getType() == TutorialMapDef.TUTORIAL_MAP_TYPE_REWARD)
            {
               InstanceMng.getResourcesMng().addResourceToLoad("tutorial/" + TutorialMapMng.IMAGE_BG_TUTORIAL_PACK_GLOW,FSResourceMng.TYPE_TEXTURE_PNG);
            }
         }
         if(Config.getConfig().cardsHaveCustomAuras())
         {
            InstanceMng.getResourcesMng().addResourcesFolderByName("anims/animAuras");
         }
         InstanceMng.getResourcesMng().loadAssets();
      }
      
      protected function currentLevelHasTutorialMap() : Boolean
      {
         return this.getCurrentTutorialMapDef() != null;
      }
      
      private function getCurrentTutorialMapDef() : TutorialMapDef
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TutorialMapDef = null;
         var _loc1_:TutorialMapDef = null;
         if(Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) && Boolean(InstanceMng.getTutorialMapMng()))
         {
            _loc2_ = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
            _loc3_ = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelIndex(_loc2_);
            _loc4_ = TutorialMapDef(InstanceMng.getTutorialMapMng().getCurrentTutorialMapDef());
            if(_loc4_ != null)
            {
               if(_loc3_ == _loc4_.getLevel())
               {
                  _loc1_ = _loc4_;
               }
            }
         }
         return _loc1_;
      }
      
      override public function addPopupsResources() : void
      {
         if(!FSPopupMng.areScreenPopupsResourcesLoaded(mScreenName))
         {
            if(Config.getConfig().hasQuests())
            {
               InstanceMng.getResourcesMng().addResourcesFolderByName("popups/questsPopup");
            }
            if(InstanceMng.getResourcesMng().isSpecialScreenResource() && !Utils.isBrowser())
            {
               InstanceMng.getResourcesMng().addSpecialScreenResources("popups/guildsPopup",null,FSResourceMng.PREFIX_TEXTURE);
            }
            InstanceMng.getResourcesMng().addResourcesFolderByName("popups/guildsPopup");
            InstanceMng.getResourcesMng().addResourcesFolderByName("popups/dailyPopup");
            InstanceMng.getResourcesMng().addResourcesFolderByName("popups/playPopup");
            if(!Config.getConfig().gameHasCustomPopups())
            {
               InstanceMng.getResourcesMng().addResourceToLoad("popups/" + Constants.POPUP_EXTENDED_NAME,FSResourceMng.TYPE_TEXTURE_PNG);
            }
            if(Config.getConfig().XLViewHasCustomBG())
            {
               InstanceMng.getResourcesMng().addSpecialScreenResources("popups/card_zoom_in_bg.png",Root.assets,FSResourceMng.PREFIX_TEXTURE);
            }
            if(Config.smPvPHasFriendlyPvP)
            {
               InstanceMng.getResourcesMng().addResourceToLoad("popups/" + PopupPlayPvPOffline.BG_NAME,FSResourceMng.TYPE_TEXTURE_PNG);
            }
         }
      }
      
      override protected function addPopupAudioResources() : void
      {
         if(!FSPopupMng.areScreenPopupsResourcesLoaded(mScreenName))
         {
            if(Config.getConfig().mapShowLoreOnPlayPopup())
            {
               InstanceMng.getResourcesMng().addResourceToLoad("misc/" + Constants.SOUND_TYPEWRITER,FSResourceMng.TYPE_AUDIO);
            }
            InstanceMng.getResourcesMng().addResourceToLoad("misc/" + Constants.SOUND_STAR_1,FSResourceMng.TYPE_AUDIO);
            InstanceMng.getResourcesMng().addResourceToLoad("misc/" + Constants.SOUND_STAR_2,FSResourceMng.TYPE_AUDIO);
            InstanceMng.getResourcesMng().addResourceToLoad("misc/" + Constants.SOUND_STAR_3,FSResourceMng.TYPE_AUDIO);
         }
      }
      
      private function calculateMapsNeededToAdvance(param1:int = -1) : int
      {
         var _loc2_:int = 0;
         var _loc5_:* = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc3_:int = InstanceMng.getMapsDefMng().getLastMapIndex();
         var _loc4_:int;
         _loc5_ = _loc4_ = param1 != -1 ? param1 : this.mCurrentMapIndexOnScreen;
         while(_loc5_ > 1)
         {
            _loc6_ += _loc6_ + 1 <= this.MAPS_OFFSET_SCROLLING ? 1 : 0;
            _loc5_--;
         }
         _loc5_ = _loc4_;
         while(_loc5_ < _loc3_)
         {
            _loc7_ += _loc7_ + 1 <= this.MAPS_OFFSET_SCROLLING ? 1 : 0;
            _loc5_++;
         }
         return int(1 + _loc7_ + _loc6_);
      }
      
      override public function notifyAssetsLoaded(param1:* = null) : void
      {
         var _loc6_:LevelDef = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Boolean = false;
         var _loc10_:Number = NaN;
         var _loc11_:Boolean = false;
         setScreenPopupsResourcesLoaded();
         var _loc2_:Boolean = InstanceMng.getApplication().mapScreenHasBeenVisited();
         var _loc3_:UserData = Utils.getOwnerUserData();
         var _loc4_:int = _loc3_ ? _loc3_.getCurrentLevelIndex(UserDataMng.DIFFICULTY_EASY) : -1;
         var _loc5_:Boolean = _loc4_ == 1 && !_loc2_;
         if(_loc5_)
         {
            if(InstanceMng.getApplication())
            {
               InstanceMng.getApplication().setMapScreenAsVisited();
            }
            super.notifyAssetsLoaded();
            InstanceMng.getApplication().initializeManagers();
            if(InstanceMng.getResourcesMng())
            {
               InstanceMng.getResourcesMng().removeDefinitions();
            }
            _loc6_ = LevelDef(InstanceMng.getLevelsDefMng().getLevelDefByLevelIndex(1));
            InstanceMng.getUserDataMng().frictionlessPlayLevel(_loc6_);
            return;
         }
         if(Boolean(Root.smCurrentLevelScore) && Root.smCurrentLevelScore.levelScore != null)
         {
            Root.smCurrentLevelScore.levelScore = null;
         }
         if(param1 != null)
         {
            _loc7_ = this.calculateMapsNeededToAdvance();
            if(param1.mapMaterialLoaded == true)
            {
               ++this.mPlanesMaterialsAmountLoaded;
               if(this.mPlanesMaterialsAmountLoaded >= _loc7_)
               {
                  this.mMapMaterialsLoaded = true;
               }
               if(this.mWaitingToCenterTheCamOnCurrentLevel == true && this.areSurroundingMapsLoaded())
               {
                  this.onWaitingToCenterCameraAssetsLoaded();
               }
            }
         }
         else
         {
            this.mSimpleResourcesLoaded = Root.assets.getTexture("mapScreen_0") != null;
            if(this.mSimpleResourcesLoaded)
            {
               if(Boolean(InstanceMng.getApplication()) && !InstanceMng.getApplication().areOnDemandDefinitionsInitialized())
               {
                  InstanceMng.getApplication().initializeManagers();
                  if(InstanceMng.getResourcesMng())
                  {
                     InstanceMng.getResourcesMng().removeDefinitions();
                  }
               }
               if(this.mSimpleResourcesLoaded)
               {
                  this.create3DMap();
               }
            }
         }
         if(Boolean(this.mMapPlanesCatalog && !mScreenFullyLoaded) && Boolean(this.mSimpleResourcesLoaded) && this.mMapMaterialsLoaded)
         {
            if(Config.PERFORM_TESTS)
            {
               setTimeout(Tester.startTest,1000);
            }
            if(InstanceMng.getQuestsMng())
            {
               InstanceMng.getQuestsMng().init();
            }
            if(Boolean(InstanceMng.getServerConnection()) && Boolean(InstanceMng.getServerConnection().isUserLoggedIn()) && Boolean(InstanceMng.getApplication()))
            {
               if(InstanceMng.getApplication().getInAppsManager().areProductsPricesUpToDate() && InstanceMng.getApplication().mapScreenHasBeenVisited())
               {
                  TweenMax.delayedCall(0.5,InstanceMng.getApplication().getInAppsManager().rollNonPayerNextAction);
               }
            }
            if(InstanceMng.getApplication())
            {
               InstanceMng.getApplication().setMapScreenAsVisited();
            }
            if(!_loc5_)
            {
               this.createUI();
               super.notifyAssetsLoaded();
               _loc8_ = _loc4_ == 1 ? 50 : 0;
               setTimeout(this.checkIfFirstLevelOfMap,_loc8_);
               this.addOwnerProfilePortrait();
               _loc9_ = Boolean(this.mCurrentLevelItem) && Boolean(this.mCurrentLevelItem.getLevelDef()) && Boolean(InstanceMng.getMapsDefMng()) ? InstanceMng.getMapsDefMng().isFirstLevelOfMap(this.mCurrentLevelItem.getLevelDef().getLevelIndex()) : false;
               if(_loc9_)
               {
                  this.centerCamerOnCurrentLevelItem();
               }
               else
               {
                  this.mWaitingToCenterTheCamOnCurrentLevel = true;
                  this.onAssetsLoadedCenterCamera();
               }
               if(!_loc2_)
               {
                  setTimeout(InstanceMng.getServerConnection().getMapRequests,_loc8_,!_loc2_);
               }
               setTimeout(this.checkIfUserGot250Gold,_loc8_);
               setTimeout(this.checkNewDifficultyUnlocked,_loc8_);
               _loc10_ = ServerConnection.smServerTimeMS != 0 && ServerConnection.smServerTimeMS != -1 ? ServerConnection.smServerTimeMS : -1;
               _loc11_ = (Boolean(_loc10_)) && Boolean(InstanceMng.getUserDataMng()) ? InstanceMng.getUserDataMng().hasToShowDailyRewards(_loc10_,true) : false;
               setTimeout(this.checkDailyRewardsPopup,_loc8_,true);
               if(!_loc11_)
               {
                  setTimeout(this.checkDailyRewardsPopup,_loc8_,false);
               }
               setTimeout(this.checkNickChanged,_loc8_);
               setTimeout(this.checkRewardsToClaim,_loc8_);
               TweenMax.delayedCall(0.5,this.checkTopScores);
               TweenMax.delayedCall(0.75,this.checkFriends);
            }
            else
            {
               super.notifyAssetsLoaded();
            }
         }
      }
      
      private function checkNewDifficultyUnlocked() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         var _loc1_:UserData = Utils.getOwnerUserData();
         if(_loc1_)
         {
            _loc2_ = Config.getConfig().getUnlockMediumDifficulty();
            _loc3_ = Config.getConfig().getUnlockHardDifficulty();
            _loc4_ = _loc1_.getCurrentLevelIndex(UserDataMng.DIFFICULTY_EASY);
            _loc5_ = _loc1_.getCurrentLevelIndex(UserDataMng.DIFFICULTY_MEDIUM);
            _loc6_ = _loc4_ == _loc2_;
            _loc7_ = _loc5_ == _loc3_;
            _loc8_ = _loc1_.flagsGetMediumDifficultyUnlockedTutorialSeen();
            _loc9_ = _loc1_.flagsGetHardDifficultyUnlockedTutorialSeen();
            _loc10_ = !_loc8_ && _loc6_ || !_loc9_ && _loc7_;
            if(!this.mShowingComic && _loc10_)
            {
               if(InstanceMng.getPopupMng())
               {
                  InstanceMng.getPopupMng().openConfirmationPopup(TextManager.getText("TID_TUTORIAL_DIFF_UNLOCKED"));
               }
               if(_loc6_)
               {
                  _loc1_.setMediumDifficultyUnlockedTutorialSeen(true);
               }
               if(_loc7_)
               {
                  _loc1_.setHardDifficultyUnlockedTutorialSeen(true);
               }
               InstanceMng.getUserDataMng().updateFlags();
            }
         }
      }
      
      private function checkNickChanged() : void
      {
         var userData:UserData = null;
         var goToNickChange:Function = null;
         var performChangeNickProcess:Function = null;
         var updateNickChangePrompted:Function = null;
         var currLevel:int = 0;
         var isFirstChangeName:Boolean = false;
         var nickIsDefault:Boolean = false;
         var lastTimePrompt:Number = NaN;
         var rawText:String = null;
         var text:String = null;
         var timeLimit:Number = NaN;
         var timeDiff:Number = NaN;
         goToNickChange = function():void
         {
            var _loc1_:Popup = null;
            if(InstanceMng.getCurrentScreen() is FSMapScreen)
            {
               _loc1_ = InstanceMng.getPopupMng().getPopupShown();
               if(_loc1_)
               {
                  _loc1_.closePopup(performChangeNickProcess);
               }
               else
               {
                  performChangeNickProcess();
               }
            }
         };
         performChangeNickProcess = function():void
         {
            updateNickChangePrompted();
            InstanceMng.getPopupMng().openEditProfilePopup();
         };
         updateNickChangePrompted = function():void
         {
            userData = InstanceMng.getUserDataMng() ? InstanceMng.getUserDataMng().getOwnerUserData() : null;
            if(userData)
            {
               userData.updateNickChangePrompt();
               InstanceMng.getUserDataMng().updateFlags();
            }
         };
         userData = Utils.getOwnerUserData();
         if(userData)
         {
            currLevel = userData.getCurrentLevelIndex(UserDataMng.DIFFICULTY_EASY);
            if(currLevel > 17)
            {
               isFirstChangeName = !userData.flagsIsFirstChangeName();
               if(isFirstChangeName)
               {
                  nickIsDefault = userData.getName().indexOf("fs_") != -1;
                  if(nickIsDefault)
                  {
                     lastTimePrompt = userData.flagsGetChangeNickPromptMS();
                     if(lastTimePrompt != -1)
                     {
                        timeLimit = TimerUtil.daysToMs(7);
                        timeDiff = ServerConnection.smServerTimeMS - lastTimePrompt;
                        FSDebug.debugTrace("Time diff: " + TimerUtil.msToSec(timeDiff - timeLimit) + " seconds");
                        if(timeDiff < timeLimit)
                        {
                           return;
                        }
                     }
                     rawText = TextManager.getText("TID_NAME_CHANGE_SUGGEST");
                     rawText = rawText == null ? "Your current nick is: %U, don\'t you want to change it?" : rawText;
                     text = TextManager.replaceParameters(rawText,[userData.getName()]);
                     if(InstanceMng.getPopupMng())
                     {
                        InstanceMng.getPopupMng().openConfirmationPopup(text,goToNickChange,updateNickChangePrompted);
                     }
                  }
               }
            }
         }
      }
      
      private function onAssetsLoadedCenterCamera() : void
      {
         var _loc1_:String = Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) ? InstanceMng.getUserDataMng().getOwnerUserData().getLastLevelPlayedSkuByDifficulty() : "level_01";
         if(_loc1_ != "" && _loc1_ != null)
         {
            this.centerCamerOnLastLevelPlayedItem();
         }
         else
         {
            this.centerCamerOnCurrentLevelItem();
         }
      }
      
      private function checkTopScores() : void
      {
         var _loc6_:int = 0;
         var _loc1_:UserData = Utils.getOwnerUserData();
         var _loc2_:Dictionary = _loc1_ ? _loc1_.getTopScores() : null;
         var _loc3_:String = _loc1_.getCurrentLevelSku();
         var _loc4_:int = _loc1_.getCurrentLevelIndex(_loc1_.getCurrentDifficulty());
         var _loc5_:int = _loc1_.getScoreByLevelSku(_loc3_);
         if(!this.mTopScoresReceived)
         {
            if(InstanceMng.getServerConnection().isUserLoggedIn() && Boolean(InstanceMng.getServerConnection()))
            {
               if(_loc2_ == null)
               {
                  InstanceMng.getServerConnection().getOwnerTopsScores(this.onTopScoresInfoReceived);
               }
               else
               {
                  _loc6_ = Boolean(this.mLastLevelPlayedItem) && Boolean(this.mLastLevelPlayedItem.getLevelDef()) ? this.mLastLevelPlayedItem.getLevelDef().getLevelIndex() : 0;
                  if(_loc6_ > 0)
                  {
                     InstanceMng.getServerConnection().getOwnerTopsScores(this.onTopScoresInfoReceived,_loc6_,false);
                  }
                  else
                  {
                     this.onTopScoresInfoReceived(null);
                  }
               }
               TweenMax.delayedCall(5,this.checkTopScores);
            }
         }
      }
      
      public function onReferralsInfoReceived() : void
      {
         this.updateRecruitButtonVisibility();
      }
      
      private function checkFriends() : void
      {
         if(InstanceMng.getUserDataMng())
         {
            if(!InstanceMng.getUserDataMng().hasRequestedFriends())
            {
               InstanceMng.getUserDataMng().setHasRequestedFriends(true);
               if(InstanceMng.getUserDataMng())
               {
                  InstanceMng.getUserDataMng().purgeFriendsData();
               }
               InstanceMng.getServerConnection().getFriendsWhoPlay();
            }
            if(Boolean(InstanceMng.getFacebookPlugin()) && Boolean(!InstanceMng.getFacebookPlugin().invitableFriendsRequested()) && InstanceMng.getUserDataMng().getOwnerUserData().flagsFBFriendsAllowed())
            {
               InstanceMng.getFacebookPlugin().getInvitableFriendsList();
            }
         }
      }
      
      private function onWaitingToCenterCameraAssetsLoaded() : void
      {
         showLoadingIcon(false,true);
         this.checkMapsToBeRemoved();
         this.mWaitingToCenterTheCamOnCurrentLevel = false;
         this.performPortraitTransition(false,true);
      }
      
      private function areSurroundingMapsLoaded() : Boolean
      {
         var _loc2_:MapPlane = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc1_:Boolean = true;
         if(this.mMapPlanesCatalog != null)
         {
            _loc4_ = this.mCurrentMapIndexOnScreen - this.MAPS_OFFSET_SCROLLING;
            while(_loc4_ <= this.mCurrentMapIndexOnScreen + this.MAPS_OFFSET_SCROLLING)
            {
               if(_loc4_ > 0 && this.isMapEligibleToBeAdded(_loc4_) && _loc4_ <= this.mAllMapsDefsArr.length)
               {
                  _loc6_ = _loc5_ = this.mMapPlanesCatalog[_loc4_] != null;
                  if(!_loc5_ || _loc5_ && !_loc6_)
                  {
                     _loc1_ = false;
                  }
               }
               _loc4_++;
            }
         }
         return _loc1_;
      }
      
      private function checkIfUserGot250Gold() : void
      {
         var _loc4_:int = 0;
         var _loc1_:UserData = Utils.getOwnerUserData();
         var _loc2_:Boolean = _loc1_ ? _loc1_.flagsGet250GoldPopupShown() : false;
         var _loc3_:Boolean = InstanceMng.getTutorialMapMng().isTutorialON();
         if(!_loc2_ && !this.mShowingComic && !_loc3_)
         {
            _loc4_ = _loc1_ ? int(_loc1_.getGold()) : 0;
            if(_loc4_ >= Config.getConfig().getCreateFirstDeckMinGoldAmount())
            {
               FSDebug.debugTrace("...User has enough gold");
               if(InstanceMng.getPopupMng())
               {
                  InstanceMng.getPopupMng().openMinimumGoldAchievedPopup();
               }
            }
         }
      }
      
      public function setMapsVisible(param1:Boolean) : void
      {
         var _loc2_:MapPlane = null;
         for each(_loc2_ in this.mMapPlanesCatalog)
         {
            _loc2_.visible = param1;
         }
      }
      
      public function removeAllMapsProfilePictures() : void
      {
         var _loc1_:MapPlane = null;
         for each(_loc1_ in this.mMapPlanesCatalog)
         {
            _loc1_.removePlayerPortraitPics();
         }
      }
      
      public function requestAllMapsProfilePictures() : void
      {
         var _loc1_:MapPlane = null;
         for each(_loc1_ in this.mMapPlanesCatalog)
         {
            _loc1_.requestPlayerPortraitPics();
         }
      }
      
      public function setMapComponentsVisible(param1:Boolean) : void
      {
         if(this.mSideBG != null)
         {
            this.mSideBG.visible = param1;
         }
         if(this.mTopMenuBar != null)
         {
            this.mTopMenuBar.visible = param1;
         }
         if(this.mAchievementsIndicator)
         {
            this.mAchievementsIndicator.visible = param1;
            this.mAchievementsIndicator.setEnabled(this.mTopScoresReceived);
         }
         if(this.mDungeonsButton)
         {
            this.mDungeonsButton.visible = param1;
         }
         if(this.mQuestsButton)
         {
            this.mQuestsButton.visible = param1;
         }
         if(this.mBattlePassButton)
         {
            this.mBattlePassButton.visible = param1;
         }
         if(this.mRaidsButton)
         {
            this.mRaidsButton.visible = param1;
         }
         if(this.mAuctionsButton)
         {
            this.mAuctionsButton.visible = param1;
         }
         if(this.mLootButton)
         {
            this.mLootButton.visible = param1;
         }
         if(mGuildsButton)
         {
            mGuildsButton.visible = param1;
         }
         if(this.mRecruitButton)
         {
            this.updateRecruitButtonVisibility(param1);
         }
         if(this.mMapSelectorButton)
         {
            this.mMapSelectorButton.visible = param1;
         }
         if(Boolean(this.mNewBanner) && Boolean(this.mMapSelectorButton))
         {
            this.mNewBanner.visible = this.mMapSelectorButton.visible;
         }
         if(mGuildsButtonVisualCounter)
         {
            mGuildsButtonVisualCounter.visible = param1;
         }
         if(mOptionsWheel)
         {
            mOptionsWheel.visible = param1;
         }
         if(mBackButton)
         {
            mBackButton.visible = param1;
         }
         if(this.mSubMenu)
         {
            this.mSubMenu.visible = param1;
         }
         var _loc2_:Boolean = this.areDifficultyButtonsVisible();
         if(this.mDiffEasyButton)
         {
            this.mDiffEasyButton.visible = param1 && _loc2_;
         }
         if(this.mDiffMediumButton)
         {
            this.mDiffMediumButton.visible = param1 && _loc2_;
         }
         if(this.mDiffHardButton)
         {
            this.mDiffHardButton.visible = param1 && _loc2_;
         }
         if(this.mDiffBG)
         {
            this.mDiffBG.visible = param1 && _loc2_;
         }
      }
      
      private function areDifficultyButtonsVisible() : Boolean
      {
         var _loc1_:UserData = Utils.getOwnerUserData();
         var _loc2_:Number = Config.getConfig().getMapShowDifficultyBarLevel();
         return _loc1_ ? _loc1_.getCurrentLevelIndex(UserDataMng.DIFFICULTY_EASY) >= _loc2_ : false;
      }
      
      private function getCurrentMapIndexOnScreen(param1:Boolean = false) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:int = -1;
         if(Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
         {
            _loc3_ = InstanceMng.getUserDataMng().getOwnerUserData().getLastLevelPlayedMapIndex();
            _loc4_ = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
            _loc5_ = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentMapIndex(_loc4_);
         }
         else
         {
            _loc3_ = 0;
            _loc4_ = 0;
            _loc5_ = 1;
         }
         return _loc3_ != -1 && !param1 ? _loc3_ : _loc5_;
      }
      
      private function checkBundles() : void
      {
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Number = NaN;
         var _loc1_:BundleDef = InstanceMng.getBundlesDefMng().getCustomOfferToShowInShop();
         var _loc2_:UserData = Utils.getOwnerUserData();
         if(Boolean(_loc1_) && Boolean(_loc2_))
         {
            _loc4_ = _loc2_.isPayingUser();
            _loc5_ = (_loc4_) || !_loc4_ && !_loc1_.shopDisplayOnlyToPayingUsers() && _loc2_.getCurrentLevelIndex(UserDataMng.DIFFICULTY_EASY) > 15;
            if(!_loc5_)
            {
               return;
            }
         }
         var _loc3_:UserData = Utils.getOwnerUserData();
         if(Boolean(_loc3_) && _loc3_.getCustomOfferNewBannerShown())
         {
            _loc6_ = _loc3_.getCustomOfferShownExpirationDate();
            if(ServerConnection.smServerTimeMS < _loc6_)
            {
               if(this.mCustomOfferNewBanner == null)
               {
                  this.mCustomOfferNewBanner = new FSButton(Root.assets.getTexture("map_info_bubble"),TextManager.getText("TID_SHOP_NEW_OFFER"));
                  this.mCustomOfferNewBanner.scaleWhenDown = 1;
                  this.mCustomOfferNewBanner.enableScaleOnMouseOver(false);
                  this.mCustomOfferNewBanner.x = this.mShopButton.x + this.mCustomOfferNewBanner.width / 2;
                  this.mCustomOfferNewBanner.y = this.mShopButton.y + this.mShopButton.height / 2 + this.mShopButton.height / 2;
                  this.mCustomOfferNewBanner.addEventListener(Event.TRIGGERED,this.showShop);
                  this.mCustomOfferNewBanner.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_DESC);
                  this.mCustomOfferNewBanner.fontColor = 0;
                  if(Utils.isBrowser() || Utils.isDesktop())
                  {
                     this.mCustomOfferNewBanner.fontSize = FSResourceMng.FONT_STD_SMALL_SIZE;
                  }
                  addChild(this.mCustomOfferNewBanner);
               }
            }
         }
      }
      
      public function checkIfFirstLevelOfMap() : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:MapDef = null;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         var _loc11_:int = 0;
         var _loc12_:Boolean = false;
         var _loc13_:Boolean = false;
         var _loc14_:FSMapUnlockedEffect = null;
         var _loc15_:Array = null;
         var _loc16_:WorldDef = null;
         var _loc17_:WorldDef = null;
         var _loc18_:ChooseWorldEffect = null;
         var _loc1_:Boolean = false;
         if(!this.mShowingComic)
         {
            if(this.mCurrentLevelItem != null)
            {
               _loc2_ = InstanceMng.getMapsDefMng().isFirstLevelOfMap(this.mCurrentLevelItem.getLevelDef().getLevelIndex());
               this.mCurrentMapIndexOnScreen = this.getCurrentMapIndexOnScreen(_loc2_);
               _loc3_ = InstanceMng.getMapsDefMng().getMapDefByIndex(this.mCurrentMapIndexOnScreen).getSku();
               _loc4_ = Config.getConfig().gameHasComic();
               _loc5_ = Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) ? InstanceMng.getUserDataMng().getOwnerUserData().isComicRead(_loc3_) : false;
               _loc6_ = InstanceMng.getComicStripsDefMng() ? InstanceMng.getComicStripsDefMng().getComicStripsDefsByMapSku(_loc3_) != null : false;
               _loc7_ = _loc4_ && !_loc5_ && _loc6_ || !_loc4_;
               _loc8_ = MapDef(InstanceMng.getMapsDefMng().getDefBySku(_loc3_));
               _loc9_ = _loc8_ != null && _loc8_.getUnlockTime() == 0;
               _loc10_ = Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) ? InstanceMng.getUserDataMng().getOwnerUserData().getHighestMapUnlockedIndex() >= _loc8_.getIndex() : false;
               _loc11_ = Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty() : UserDataMng.DIFFICULTY_EASY;
               _loc12_ = InstanceMng.getApplication().isMapIntroSeen(_loc3_);
               _loc13_ = this.checkIfhasToShowWorldChooser();
               if(!_loc13_ && !_loc12_ && !_loc5_ && _loc2_ && _loc7_ && (_loc9_ || _loc10_))
               {
                  InstanceMng.getApplication().setMapIntroAsSeen(_loc3_);
                  this.setMapComponentsVisible(false);
                  _loc1_ = true;
                  this.setMapsVisible(false);
                  if(InstanceMng.getComicsMng() != null && _loc11_ == UserDataMng.DIFFICULTY_EASY)
                  {
                     this.mShowingComic = true;
                     InstanceMng.getComicsMng().onMapUnlocked(_loc3_);
                  }
                  else
                  {
                     _loc14_ = InstanceMng.getResourcesMng().createMapUnlockedEffect(_loc8_);
                     _loc14_.init();
                     this.setIsMapUnlockedEffectActive(true);
                     InstanceMng.getCurrentScreen().addChild(_loc14_);
                  }
               }
               else
               {
                  this.setIsMapUnlockedEffectActive(false);
                  if(_loc13_)
                  {
                     _loc15_ = _loc8_.getMapWorldsAvailable();
                     if((Boolean(_loc15_)) && _loc15_.length == 2)
                     {
                        _loc16_ = WorldDef(InstanceMng.getWorldsDefMng().getDefBySku(_loc15_[0]));
                        _loc17_ = WorldDef(InstanceMng.getWorldsDefMng().getDefBySku(_loc15_[1]));
                        _loc18_ = new ChooseWorldEffect(_loc16_,_loc17_);
                        addChild(_loc18_);
                     }
                  }
               }
            }
            else
            {
               FSDebug.debugTrace("Current level item IS null");
               this.setIsMapUnlockedEffectActive(false);
            }
            return _loc1_;
         }
         return true;
      }
      
      public function createUI() : void
      {
         this.createSideBG();
         this.createTopMenuBar();
         this.createShopButton();
         this.showShopNotificationIcon();
         this.showRewardsNotificationIcon();
         this.createDeckBuilderButton();
         this.createPvPButton();
         this.createDungeonsButton();
         this.createRaidsButton();
         this.createGoldVisor();
         this.createDungeonsButton();
         this.createRaidsButton();
         this.createAuctionsButton();
         this.createQuestsButton();
         this.createBattlePassButton();
         this.createLootButton();
         this.addAllButtons();
         this.createAchievementsIndicator();
         this.createSubmenu();
         this.createReferralButton();
         this.createMapSelectorButton();
         if(InstanceMng.getApplication())
         {
            InstanceMng.getApplication().createGuildsPanel();
         }
         this.createDifficultyButtons();
         this.checkBundles();
      }
      
      public function updateRecruitButtonVisibility(param1:Boolean = true) : void
      {
         if(this.mRecruitButton)
         {
            this.mRecruitButton.visible = param1 && !this.isShowingComic() && !this.isMapUnlockedEffectActive() && ServerConnection.smServerReferralsDefs != null;
         }
      }
      
      private function createReferralButton() : void
      {
         if(Config.HAS_REFERRAL_ENGINE && Boolean(Root.assets.getTexture("recruit_button")))
         {
            if(this.mRecruitButton == null)
            {
               this.mRecruitButton = new FSButton(Root.assets.getTexture("recruit_button"));
               this.mRecruitButton.setTooltipText(TextManager.getText("TID_RECRUIT_FRIEND"));
               this.mRecruitButton.x = mGuildsButton ? mGuildsButton.x : Starling.current.stage.stageWidth - this.mRecruitButton.width / 2;
               this.mRecruitButton.y = mGuildsButton ? mGuildsButton.y - mGuildsButton.height * 1.05 : Starling.current.stage.stageHeight - this.mRecruitButton.height * 2.5;
               this.mRecruitButton.addEventListener(Event.TRIGGERED,this.onReferralTriggered);
               this.updateRecruitButtonVisibility();
               addChild(this.mRecruitButton);
            }
         }
      }
      
      private function createMapSelectorButton() : void
      {
         if(Root.assets.getTexture("map_choose_button"))
         {
            if(this.mMapSelectorButton == null)
            {
               this.mMapSelectorButton = new FSButton(Root.assets.getTexture("map_choose_button"));
               this.mMapSelectorButton.x = mGuildsButton ? mGuildsButton.x : Starling.current.stage.stageWidth - this.mMapSelectorButton.width / 2;
               this.mMapSelectorButton.y = this.mRecruitButton ? this.mRecruitButton.y - this.mRecruitButton.height * 1.05 : this.mRecruitButton.y - this.mRecruitButton.height * 1.05;
               this.mMapSelectorButton.addEventListener(Event.TRIGGERED,this.onMapsSelectorTriggered);
               addChild(this.mMapSelectorButton);
            }
         }
      }
      
      private function onMapsSelectorTriggered() : void
      {
         InstanceMng.getPopupMng().openMapSelectorPopup();
         if(InstanceMng.getCurrentScreen() is FSMapScreen)
         {
            FSMapScreen(InstanceMng.getCurrentScreen()).removeNewBanner();
         }
      }
      
      public function removeNewBanner() : void
      {
         if(this.mNewBanner)
         {
            this.mNewBanner.removeFromParent(true);
            this.mNewBanner = null;
         }
      }
      
      private function onReferralTriggered() : void
      {
         if(!InstanceMng.getUserDataMng().getOwnerUserData().isInBlackList())
         {
            if(!InstanceMng.getUserDataMng().getOwnerUserData().isInDuplicatedList())
            {
               InstanceMng.getPopupMng().openReferralPopup();
            }
            else
            {
               Utils.setLogText(TextManager.getText("TID_MIGRATION_ERROR_MIGRATED"),true,false,false);
            }
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_GEN_FRAUD_PURCHASE"),true,false,false);
         }
      }
      
      private function createDifficultyButtons() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:FSCoordinate = null;
         if(Config.getConfig().gameHasDifficultyLevels())
         {
            this.createDiffBG();
            this.createDiffEasyButton();
            this.createDiffMediumButton();
            this.createDiffHardButton();
            if(Boolean(this.mDiffEasyButton) && Boolean(this.mDiffMediumButton) && Boolean(this.mDiffHardButton))
            {
               _loc1_ = this.mDiffBG.width * 0.95;
               _loc2_ = this.mDiffBG.height;
               _loc3_ = this.mDiffEasyButton.width;
               _loc4_ = this.mDiffEasyButton.height;
               _loc5_ = (this.mDiffBG.width - _loc1_) / 8;
               _loc6_ = Utils.getXYPositionInContainer(0,_loc3_,_loc4_,_loc1_,_loc2_,3,1);
               this.mDiffEasyButton.x = this.mDiffBG.x + _loc5_ + _loc6_.getX() - _loc3_ / 2;
               this.mDiffEasyButton.y = this.mDiffBG.y - _loc4_ / 4;
               _loc6_ = Utils.getXYPositionInContainer(1,_loc3_,_loc4_,_loc1_,_loc2_,3,1);
               this.mDiffMediumButton.x = this.mDiffBG.x + _loc5_ + _loc6_.getX() - _loc3_ / 2;
               this.mDiffMediumButton.y = this.mDiffBG.y - _loc4_ / 4;
               _loc6_ = Utils.getXYPositionInContainer(2,_loc3_,_loc4_,_loc1_,_loc2_,3,1);
               this.mDiffHardButton.x = this.mDiffBG.x + _loc5_ + _loc6_.getX() - _loc3_ / 2;
               this.mDiffHardButton.y = this.mDiffBG.y - _loc4_ / 4;
            }
         }
      }
      
      private function createDiffBG() : void
      {
         var _loc1_:Boolean = false;
         if(this.mDiffBG == null)
         {
            this.mDiffBG = new FSImage(Root.assets.getTexture("map_difficulty_bg"));
            this.mDiffBG.alignPivot();
            this.mDiffBG.x = this.mSideBG.width / 2;
            this.mDiffBG.y = this.mSideBG.height - this.mDiffBG.height / 2;
            _loc1_ = this.areDifficultyButtonsVisible();
            this.mDiffBG.visible = _loc1_;
            addChild(this.mDiffBG);
         }
      }
      
      private function createDiffHardButton() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         if(this.mDiffHardButton == null)
         {
            _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
            _loc2_ = InstanceMng.getUserDataMng().getOwnerUserData() ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelIndex(UserDataMng.DIFFICULTY_MEDIUM) : 0;
            this.mDiffHardButton = new DifficultyButton("button_diff_03_lit","button_diff_03_unlit",TextManager.getText("TID_LEVEL_DIFF_3"));
            if(_loc1_ == UserDataMng.DIFFICULTY_HARD)
            {
               this.mDiffHardButton.setPressed(true);
            }
            this.mDiffHardButton.name = "buttonHard";
            if(_loc2_ < Config.getConfig().getUnlockHardDifficulty())
            {
               this.mDiffHardButton.setLockTexture("button_diff_03_lock");
            }
            _loc3_ = this.areDifficultyButtonsVisible();
            this.mDiffHardButton.visible = _loc3_;
            this.mDiffHardButton.addEventListener(TouchEvent.TOUCH,this.onDiffTouch);
            this.mDiffHardButton.addEventListener(Event.TRIGGERED,this.onDiffTriggered);
            addChild(this.mDiffHardButton);
         }
      }
      
      private function createDiffMediumButton() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         if(this.mDiffMediumButton == null)
         {
            _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
            _loc2_ = InstanceMng.getUserDataMng().getOwnerUserData() ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelIndex(UserDataMng.DIFFICULTY_EASY) : 0;
            this.mDiffMediumButton = new DifficultyButton("button_diff_02_lit","button_diff_02_unlit",TextManager.getText("TID_LEVEL_DIFF_2"));
            if(_loc1_ == UserDataMng.DIFFICULTY_MEDIUM)
            {
               this.mDiffMediumButton.setPressed(true);
            }
            this.mDiffMediumButton.name = "buttonMedium";
            if(_loc2_ < Config.getConfig().getUnlockMediumDifficulty())
            {
               this.mDiffMediumButton.setLockTexture("button_diff_02_lock");
            }
            this.mDiffMediumButton.addEventListener(TouchEvent.TOUCH,this.onDiffTouch);
            this.mDiffMediumButton.addEventListener(Event.TRIGGERED,this.onDiffTriggered);
            _loc3_ = this.areDifficultyButtonsVisible();
            this.mDiffMediumButton.visible = _loc3_;
            addChild(this.mDiffMediumButton);
         }
      }
      
      private function createDiffEasyButton() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Boolean = false;
         if(this.mDiffEasyButton == null)
         {
            _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
            this.mDiffEasyButton = new DifficultyButton("button_diff_01_lit","button_diff_01_unlit",TextManager.getText("TID_LEVEL_DIFF_1"));
            this.mDiffEasyButton.name = "buttonEasy";
            if(_loc1_ == UserDataMng.DIFFICULTY_EASY)
            {
               this.mDiffEasyButton.setPressed(true);
            }
            _loc2_ = this.areDifficultyButtonsVisible();
            this.mDiffEasyButton.visible = _loc2_;
            this.mDiffEasyButton.addEventListener(TouchEvent.TOUCH,this.onDiffTouch);
            this.mDiffEasyButton.addEventListener(Event.TRIGGERED,this.onDiffTriggered);
            addChild(this.mDiffEasyButton);
         }
      }
      
      private function onDiffTouch(param1:TouchEvent) : void
      {
         var _loc2_:Boolean = param1.getTouch(param1.target as DisplayObject,TouchPhase.HOVER) != null;
         var _loc3_:Boolean = param1.getTouch(param1.target as DisplayObject,TouchPhase.BEGAN) != null;
         var _loc4_:Boolean = param1.getTouch(param1.target as DisplayObject,TouchPhase.ENDED) != null;
         var _loc5_:Boolean = _loc2_ || _loc3_;
         if(_loc5_)
         {
            if(smMapsTouchable)
            {
               this.makePlanesTouchable(false);
            }
         }
         else if(!smMapsTouchable)
         {
            this.makePlanesTouchable(true);
         }
      }
      
      private function onDiffTriggered(param1:Event) : void
      {
         if(InstanceMng.getTutorialMapMng().isTutorialON())
         {
            InstanceMng.getTutorialMapMng().increaseCurrentStep();
         }
         var _loc2_:int = InstanceMng.getUserDataMng().getOwnerUserData() ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty() : 0;
         var _loc3_:Boolean = false;
         if(!DifficultyButton(param1.currentTarget).isLock())
         {
            if(DifficultyButton(param1.currentTarget).name == "buttonEasy")
            {
               if(_loc2_ != UserDataMng.DIFFICULTY_EASY && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
               {
                  _loc3_ = true;
                  this.mDiffEasyButton.setPressed(true);
                  this.mDiffMediumButton.setPressed(false);
                  this.mDiffHardButton.setPressed(false);
                  InstanceMng.getUserDataMng().getOwnerUserData().setCurrentDifficulty(UserDataMng.DIFFICULTY_EASY);
               }
            }
            else if(DifficultyButton(param1.currentTarget).name == "buttonMedium")
            {
               if(_loc2_ != UserDataMng.DIFFICULTY_MEDIUM && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
               {
                  _loc3_ = true;
                  this.mDiffEasyButton.setPressed(false);
                  this.mDiffMediumButton.setPressed(true);
                  this.mDiffHardButton.setPressed(false);
                  InstanceMng.getUserDataMng().getOwnerUserData().setCurrentDifficulty(UserDataMng.DIFFICULTY_MEDIUM);
               }
            }
            else if(DifficultyButton(param1.currentTarget).name == "buttonHard")
            {
               if(_loc2_ != UserDataMng.DIFFICULTY_HARD && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
               {
                  _loc3_ = true;
                  this.mDiffEasyButton.setPressed(false);
                  this.mDiffMediumButton.setPressed(false);
                  this.mDiffHardButton.setPressed(true);
                  InstanceMng.getUserDataMng().getOwnerUserData().setCurrentDifficulty(UserDataMng.DIFFICULTY_HARD);
               }
            }
            if(_loc3_)
            {
               InstanceMng.getUserDataMng().updateCurrentDifficulty();
               if(Utils.getOwnerUserData() != null)
               {
                  Utils.getOwnerUserData().resetTopScores();
               }
               this.refreshMap();
               Utils.setLogText(TextManager.getText("TID_LEVEL_DIFF_CHANGED"),false,false);
            }
         }
         else if(DifficultyButton(param1.currentTarget).name == "buttonMedium")
         {
            Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_LEVEL_DIFF_2_LOCKED"),[Config.getConfig().getUnlockMediumDifficulty() - 1]));
         }
         else if(DifficultyButton(param1.currentTarget).name == "buttonHard")
         {
            Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_LEVEL_DIFF_3_LOCKED"),[Config.getConfig().getUnlockHardDifficulty() - 1]));
         }
         param1.stopImmediatePropagation();
      }
      
      public function createSubmenu() : void
      {
         var _loc1_:Vector.<SubMenuButton> = new Vector.<SubMenuButton>();
         var _loc2_:Vector.<SubMenuButton> = new Vector.<SubMenuButton>();
         var _loc3_:Vector.<SubMenuButton> = new Vector.<SubMenuButton>();
         var _loc4_:Vector.<SubMenuButton> = new Vector.<SubMenuButton>();
         if(Config.getConfig().hasQuests())
         {
            if(this.mQuestsButton.hasNotification())
            {
               _loc4_.push(this.mQuestsButton);
            }
            else
            {
               _loc3_.push(this.mQuestsButton);
            }
         }
         if(Config.getConfig().hasBattlePass())
         {
            if(Boolean(this.mBattlePassButton) && this.mBattlePassButton.hasNotification())
            {
               _loc4_.push(this.mBattlePassButton);
            }
            else
            {
               _loc3_.push(this.mBattlePassButton);
            }
         }
         if(Config.getConfig().gameHasAuctions())
         {
            if(this.mAuctionsButton.isEnabled())
            {
               if(this.mAuctionsButton.hasNotification())
               {
                  _loc4_.push(this.mAuctionsButton);
               }
               else
               {
                  _loc3_.push(this.mAuctionsButton);
               }
            }
            else
            {
               _loc2_.push(this.mAuctionsButton);
            }
         }
         if(this.mLootButton.hasNotification())
         {
            _loc4_.push(this.mLootButton);
         }
         else
         {
            _loc3_.push(this.mLootButton);
         }
         if(this.mAchievementsIndicator.isEnabled())
         {
            if(this.mAchievementsIndicator.hasNotification())
            {
               _loc4_.push(this.mAchievementsIndicator);
            }
            else
            {
               _loc3_.push(this.mAchievementsIndicator);
            }
         }
         else
         {
            _loc2_.push(this.mAchievementsIndicator);
         }
         var _loc5_:int = 0;
         if(Boolean(_loc2_) && _loc2_.length > 0)
         {
            _loc2_.reverse();
            _loc5_ = 0;
            while(_loc5_ < _loc2_.length)
            {
               _loc1_.push(_loc2_[_loc5_]);
               _loc5_++;
            }
         }
         if(Boolean(_loc3_) && _loc3_.length > 0)
         {
            _loc3_.reverse();
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length)
            {
               _loc1_.push(_loc3_[_loc5_]);
               _loc5_++;
            }
         }
         if(Boolean(_loc4_) && _loc4_.length > 0)
         {
            _loc4_.reverse();
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               _loc1_.push(_loc4_[_loc5_]);
               _loc5_++;
            }
         }
         if(this.mSubMenu == null)
         {
            this.mSubMenu = new MapSubmenu(_loc1_);
            this.mSubMenu.name = "submenu";
            this.mSubMenu.x = this.mSubMenu.getMainButton().width / 2;
            this.mSubMenu.y = Starling.current.stage.stageHeight - this.mSubMenu.getMainButton().height / 2;
            addChild(this.mSubMenu);
         }
         else
         {
            this.mSubMenu.sortButtonsVector(_loc1_);
         }
         this.mSubMenu.validateContainer();
      }
      
      private function checkDailyRewardsPopup(param1:Boolean) : void
      {
         if(this.isEligibleForDailyReward(param1))
         {
            InstanceMng.getUserDataMng().openDailyRewardsPopup(param1);
         }
      }
      
      private function isEligibleForDailyReward(param1:Boolean) : Boolean
      {
         var _loc2_:UserData = null;
         var _loc3_:Number = NaN;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         if(Boolean(InstanceMng.getServerConnection().isUserLoggedIn() && InstanceMng.getServerConnection() && !InstanceMng.getPopupMng().isPopupLoading()) && Boolean(InstanceMng.getCurrentScreen() is FSMapScreen) && InstanceMng.getCurrentScreen().isFullyLoaded())
         {
            _loc2_ = Utils.getOwnerUserData();
            _loc3_ = ServerConnection.smServerTimeMS != 0 && ServerConnection.smServerTimeMS != -1 ? ServerConnection.smServerTimeMS : -1;
            if(_loc3_ != -1 && Boolean(_loc2_))
            {
               _loc4_ = InstanceMng.getUserDataMng() ? InstanceMng.getUserDataMng().hasToShowDailyRewards(_loc3_,param1) : false;
               if(_loc4_)
               {
                  _loc5_ = InstanceMng.getTutorialMapMng() ? !InstanceMng.getTutorialMapMng().isTutorialON() : true;
                  _loc6_ = _loc2_ ? _loc2_.getCurrentLevelIndex(UserDataMng.DIFFICULTY_EASY) > 1 : false;
                  _loc7_ = this.checkIfhasToShowWorldChooser();
                  _loc8_ = this.isMapUnlockedEffectActive();
                  _loc9_ = param1 ? _loc2_.isOldPlayerComingBack() : true;
                  return !_loc8_ && !_loc7_ && !Screen.isScreenLocked() && InstanceMng.getUserDataMng() && _loc5_ && _loc6_ && _loc9_;
               }
            }
         }
         return false;
      }
      
      public function checkIfhasToShowWorldChooser() : Boolean
      {
         var _loc2_:String = null;
         var _loc3_:MapDef = null;
         var _loc1_:Boolean = false;
         if(this.mCurrentMapIndexOnScreen > 0)
         {
            _loc2_ = InstanceMng.getMapsDefMng().getMapDefByIndex(this.mCurrentMapIndexOnScreen).getSku();
            _loc3_ = MapDef(InstanceMng.getMapsDefMng().getDefBySku(_loc2_));
            return Boolean(_loc3_) && _loc3_.isWorldMap() && !InstanceMng.getUserDataMng().getOwnerUserData().hasAlreadyChoosenWorld(_loc3_.getWorldParentIndex());
         }
         return _loc1_;
      }
      
      protected function createAchievementsIndicator() : void
      {
         if(this.mAchievementsIndicator == null)
         {
            this.mAchievementsIndicator = new SubMenuButton("button_progress","button_progress_disabled",this.onAchievementsTriggered,TextManager.getText("TID_BUTTON_PROGRESS"));
            this.mAchievementsIndicator.name = "achievementsIndicator";
            this.mAchievementsIndicator.setEnabled(this.mTopScoresReceived);
            this.enableAchievementsIndicator(true);
         }
      }
      
      private function onAchievementsTriggered() : void
      {
         var _loc1_:int = 0;
         var _loc3_:UserData = null;
         var _loc4_:Dictionary = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc2_:int = InstanceMng.getUserDataMng().getOwnerUserData() ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty() : UserDataMng.DIFFICULTY_EASY;
         if(Boolean(this.mAchievementsIndicator) && this.mAchievementsIndicator.isEnabled())
         {
            if(!Screen.isScreenLocked())
            {
               if(InstanceMng.getServerConnection().isUserLoggedIn())
               {
                  _loc3_ = Utils.getOwnerUserData();
                  _loc4_ = _loc3_ ? _loc3_.getTopScores() : null;
                  _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData() ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelIndex(_loc2_) : 1;
                  if(Boolean(_loc4_) || _loc1_ == 1)
                  {
                     if(this.mTopScoresReceived)
                     {
                        this.mAchievementsIndicator.setEnabled(false);
                        TweenMax.delayedCall(3,this.enableAchievementsIndicator,[true]);
                        InstanceMng.getPopupMng().openAchievementsPopup();
                     }
                  }
                  else if(InstanceMng.getServerConnection())
                  {
                     InstanceMng.getServerConnection().getOwnerTopsScores(this.onTopScoresInfoReceived);
                  }
               }
               else
               {
                  Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true);
               }
            }
         }
         else
         {
            _loc5_ = InstanceMng.getUserDataMng().getOwnerUserData() ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty() : UserDataMng.DIFFICULTY_EASY;
            _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData() ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelIndex(_loc5_) : 0;
            if(_loc1_ < Config.getConfig().getUnlockBadgesLevel())
            {
               _loc6_ = TextManager.replaceParameters(TextManager.getText("TID_GEN_FEATURE_LOCKED"),[Config.getConfig().getUnlockBadgesLevel()]);
               Utils.setLogText(_loc6_,true);
            }
         }
      }
      
      private function enableAchievementsIndicator(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.mAchievementsIndicator)
         {
            _loc2_ = InstanceMng.getUserDataMng().getOwnerUserData() ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty() : UserDataMng.DIFFICULTY_EASY;
            _loc3_ = InstanceMng.getUserDataMng().getOwnerUserData() ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelIndex(_loc2_) : 0;
            param1 = param1 && _loc3_ >= Config.getConfig().getUnlockBadgesLevel() || _loc2_ != UserDataMng.DIFFICULTY_EASY;
            this.mAchievementsIndicator.setEnabled(param1 && this.mTopScoresReceived);
         }
      }
      
      private function createSideBG() : void
      {
         if(this.mSideBG == null)
         {
            this.mSideBG = new FSImage(Root.assets.getTexture(this.SIDE_MAP_BG));
            this.mSideBG.touchable = false;
            addChild(this.mSideBG);
         }
      }
      
      private function createTopMenuBar() : void
      {
         if(this.mTopMenuBar == null)
         {
            this.mTopMenuBar = new FSTopMenuBar();
            this.mTopMenuBar.name = "topMenuBar";
         }
         addChild(this.mTopMenuBar);
      }
      
      protected function onBarBGSpriteTouch(param1:TouchEvent) : void
      {
         var _loc2_:Boolean = param1.getTouch(param1.target as DisplayObject,TouchPhase.HOVER) != null || param1.getTouch(param1.target as DisplayObject,TouchPhase.BEGAN) != null || param1.getTouch(param1.target as DisplayObject,TouchPhase.ENDED) != null;
         if(_loc2_)
         {
            if(smMapsTouchable)
            {
               this.makePlanesTouchable(false);
            }
         }
         else if(!smMapsTouchable)
         {
            this.makePlanesTouchable(true);
         }
      }
      
      protected function fillMapPlanesCatalog() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         if(this.mMapPlanesCatalog == null)
         {
            this.mMapPlanesCatalog = new Dictionary(true);
         }
         this.mAllMapsDefsArr = DictionaryUtils.sortDictionaryByKey(InstanceMng.getMapsDefMng().getAllDefs());
         var _loc3_:int = int(this.mAllMapsDefsArr.length);
         this.mCurrentMapIndexOnScreen = this.getCurrentMapIndexOnScreen();
      }
      
      private function create3DMap() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.mCurrentMapIndexOnScreen = this.getCurrentMapIndexOnScreen();
         var _loc1_:int = int(this.mAllMapsDefsArr.length);
         _loc2_ = 1;
         while(_loc2_ <= _loc1_)
         {
            if(this.mMapPlanesCatalog[_loc2_] == null && this.isMapEligibleToBeAdded(_loc2_))
            {
               this.addMapToCatalog(_loc2_);
            }
            _loc2_++;
         }
         this.checkIfMapsNeedToBeAdded();
      }
      
      private function addMapToCatalog(param1:int) : void
      {
         var _loc2_:String = null;
         var _loc3_:MapPlane = null;
         if(this.mMapPlanesCatalog[param1] == null)
         {
            _loc2_ = Utils.transformValueToString(param1.toString(),2);
            FSDebug.debugTrace("Creating map: " + _loc2_);
            _loc3_ = new MapPlane(_loc2_);
            this.mMapPlanesCatalog[param1] = _loc3_;
         }
      }
      
      private function removeMap(param1:int) : void
      {
         var _loc2_:MapPlane = null;
         var _loc3_:String = null;
         if(this.mMapPlanesCatalog != null)
         {
            _loc2_ = this.mMapPlanesCatalog[param1];
            if(_loc2_)
            {
               FSDebug.debugTrace("Remove map: " + param1);
               this.mMapPlanesCatalog[param1] = null;
               delete this.mMapPlanesCatalog[param1];
               _loc2_.removeFromParent();
               _loc3_ = _loc2_.getMapDef().calculateBGName();
               if(Boolean(_loc2_.getMapDef()) && this.canMapTextureBeRemoved(_loc3_))
               {
                  Root.assets.removeTexture(_loc3_);
               }
               _loc2_.dispose();
            }
         }
      }
      
      protected function isMapEligibleToBeAdded(param1:int) : Boolean
      {
         return param1 >= this.mCurrentMapIndexOnScreen - this.MAPS_OFFSET_SCROLLING && param1 <= this.mCurrentMapIndexOnScreen + this.MAPS_OFFSET_SCROLLING || param1 == this.mCurrentMapIndexOnScreen;
      }
      
      private function checkIfLevelMeshesLoaded() : void
      {
         var _loc1_:MapPlane = null;
         if(this.mMapPlanesCatalog)
         {
            for each(_loc1_ in this.mMapPlanesCatalog)
            {
               if(!_loc1_.areComponentsCreated())
               {
                  _loc1_.createMapComponents();
               }
            }
         }
      }
      
      override public function onEnterFrame(param1:Event) : void
      {
         super.onEnterFrame(param1);
         if(!this.mShowingComic)
         {
            if(Boolean(InstanceMng.getTutorialMapMng()) && isFullyLoaded())
            {
               InstanceMng.getTutorialMapMng().onEnterFrame(param1);
            }
         }
      }
      
      override public function onMouseDownHandler(param1:MouseEvent) : void
      {
         var _loc2_:MapPlane = null;
         if(this.mMapPlanesCatalog != null)
         {
            for each(_loc2_ in this.mMapPlanesCatalog)
            {
               if(_loc2_)
               {
                  TweenMax.killTweensOf(_loc2_);
               }
            }
         }
      }
      
      public function isShowingComic() : Boolean
      {
         return this.mShowingComic;
      }
      
      public function setIsShowingComic(param1:Boolean) : void
      {
         this.mShowingComic = param1;
      }
      
      public function getMapPlanesCatalog() : Dictionary
      {
         return this.mMapPlanesCatalog;
      }
      
      public function setMapPlanesCatalog(param1:Dictionary) : void
      {
         this.mMapPlanesCatalog = param1;
      }
      
      public function getMapPlaneByMapIndex(param1:int) : MapPlane
      {
         var _loc2_:MapPlane = null;
         if(this.mMapPlanesCatalog != null)
         {
            _loc2_ = this.mMapPlanesCatalog[param1];
         }
         return _loc2_;
      }
      
      public function showMenu() : void
      {
         dispatchEventWith(Screen.GO_TO_MENU,true);
      }
      
      public function resetCurrentLevelItem() : void
      {
         this.mCurrentLevelItem = null;
      }
      
      override public function unload() : void
      {
         var _loc1_:MapPlane = null;
         var _loc2_:* = undefined;
         var _loc3_:TutorialMapDef = null;
         var _loc4_:String = null;
         if(this.mDeckBuilderButton)
         {
            this.mDeckBuilderButton.removeFromParent(true);
            this.mDeckBuilderButton = null;
         }
         if(this.mTopMenuBar)
         {
            this.mTopMenuBar.removeFromParent(true);
            this.mTopMenuBar = null;
         }
         if(this.mSideBG)
         {
            this.mSideBG.removeFromParent(true);
            this.mSideBG = null;
         }
         if(this.mShopButton)
         {
            this.mShopButton.removeFromParent(true);
            this.mShopButton = null;
         }
         if(this.mPvPButton)
         {
            this.mPvPButton.removeFromParent(true);
            this.mPvPButton = null;
         }
         if(this.mGoldVisor)
         {
            this.mGoldVisor.removeFromParent(true);
            this.mGoldVisor = null;
         }
         if(this.mAchievementsIndicator)
         {
            this.mAchievementsIndicator.removeFromParent(true);
            this.mAchievementsIndicator = null;
         }
         if(this.mDungeonsButton)
         {
            this.mDungeonsButton.removeFromParent(true);
            this.mDungeonsButton = null;
         }
         if(this.mRaidsButton)
         {
            this.mRaidsButton.removeFromParent(true);
            this.mRaidsButton = null;
         }
         if(this.mAuctionsButton)
         {
            this.mAuctionsButton.removeFromParent(true);
            this.mAuctionsButton = null;
         }
         if(this.mLootButton)
         {
            this.mLootButton.removeFromParent(true);
            this.mLootButton = null;
         }
         if(this.mQuestsButton)
         {
            this.mQuestsButton.removeFromParent(true);
            this.mQuestsButton = null;
         }
         if(this.mBattlePassButton)
         {
            this.mBattlePassButton.removeFromParent(true);
            this.mBattlePassButton = null;
         }
         if(mSelectedCard)
         {
            mSelectedCard.removeFromParent(true);
            mSelectedCard = null;
         }
         if(this.mCustomOfferNewBanner)
         {
            this.mCustomOfferNewBanner.removeFromParent(true);
            this.mCustomOfferNewBanner = null;
         }
         if(this.mRecruitButton)
         {
            this.mRecruitButton.removeFromParent(true);
            this.mRecruitButton = null;
         }
         if(this.mMapSelectorButton)
         {
            this.mMapSelectorButton.removeFromParent(true);
            this.mMapSelectorButton = null;
         }
         if(this.mNewBanner)
         {
            this.mNewBanner.removeFromParent(true);
            this.mNewBanner = null;
         }
         this.mForwardLook = null;
         if(this.mMapPlanesCatalog != null)
         {
            for each(_loc1_ in this.mMapPlanesCatalog)
            {
               _loc1_.removeFromParent(true);
               _loc1_ = null;
            }
         }
         if(this.mDiffBG)
         {
            this.mDiffBG.removeFromParent(true);
            this.mDiffBG = null;
         }
         this.mCurrentMapIndexOnScreen = 0;
         this.unloadMaps();
         Utils.destroyArray(this.mAllMapsDefsArr);
         this.mAllMapsDefsArr = null;
         DictionaryUtils.clearDictionary(this.mMapPlanesCatalog);
         this.mMapPlanesCatalog = null;
         if(this.mCurrentLevelItem)
         {
            this.mCurrentLevelItem.removeFromParent(true);
            this.mCurrentLevelItem = null;
         }
         if(this.mOwnerProfilePortrait)
         {
            this.mOwnerProfilePortrait.removeFromParent(true);
            this.mOwnerProfilePortrait = null;
         }
         this.mLastLevelPlayedItem = null;
         if(Config.getConfig().gameHasComic())
         {
            InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("comic",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         }
         if(InstanceMng.getComicsMng())
         {
            InstanceMng.getComicsMng().unload();
         }
         if(Boolean(InstanceMng.getTutorialMapMng()) && this.currentLevelHasTutorialMap())
         {
            Root.assets.removeTexture(TutorialMng.TUTORIAL_SOLDIER_BG_NAME);
            Root.assets.removeTexture(TutorialMapMng.IMAGE_BG_TUTORIAL_PACK_GLOW);
            _loc3_ = this.getCurrentTutorialMapDef();
            if(_loc3_)
            {
               _loc4_ = _loc3_.getExtraImageBG();
               if(_loc4_ != null && _loc4_ != "")
               {
                  Root.assets.removeTexture(_loc4_);
               }
            }
            InstanceMng.getTutorialMapMng().unload();
         }
         if(this.mSubMenu)
         {
            if(this.isSubMenuShown())
            {
               this.closeSubMenu();
               this.mSubMenu.removeFromParent();
               this.mSubMenu.destroy();
               this.mSubMenu = null;
            }
         }
         if(this.mDiffEasyButton)
         {
            this.mDiffEasyButton.removeFromParent(true);
            this.mDiffEasyButton = null;
         }
         if(this.mDiffMediumButton)
         {
            this.mDiffMediumButton.removeFromParent(true);
            this.mDiffMediumButton = null;
         }
         if(this.mDiffHardButton)
         {
            this.mDiffHardButton.removeFromParent(true);
            this.mDiffHardButton = null;
         }
         removeEventListener(MAP_DRAGGED,this.onMapDragged);
         if(this.mMapsContainer)
         {
            this.mMapsContainer.removeFromParent(true);
            this.mMapsContainer = null;
         }
         if(this.mNotificationIcon)
         {
            this.mNotificationIcon.removeFromParent(true);
            this.mNotificationIcon = null;
         }
         if(Config.getConfig().cardsHaveCustomAuras())
         {
            InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("anims/animAuras",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         }
         super.unload();
      }
      
      protected function unloadMaps() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MapDef = null;
         if(Utils.isMobile() || Utils.isDesktop())
         {
            InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("maps",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         }
         else
         {
            _loc1_ = this.mAllMapsDefsArr ? int(this.mAllMapsDefsArr.length) : 0;
            _loc2_ = 1;
            while(_loc2_ <= _loc1_)
            {
               _loc3_ = MapDef(InstanceMng.getMapsDefMng().getDefBySku("map_" + Utils.transformValueToString(_loc2_.toString(),2)));
               Root.assets.removeTexture(_loc3_.calculateBGName());
               _loc2_++;
            }
            Root.assets.removeTexture("map_temp");
         }
      }
      
      public function setMapPlaneAsActive(param1:int, param2:Boolean = true) : void
      {
         var _loc3_:Boolean = this.mCurrentMapIndexOnScreen != param1;
         var _loc4_:Boolean = this.mCurrentMapIndexOnScreen == param1 - 1 || this.mCurrentMapIndexOnScreen == param1 + 1;
         if(_loc3_ && !_loc4_)
         {
            FSDebug.debugTrace("Conditions were not ok: mCurrentMapIndexOnScreen: " + this.mCurrentMapIndexOnScreen + " index: " + param1);
            param1 = this.mCurrentMapIndexOnScreen < param1 ? int(this.mCurrentMapIndexOnScreen + 1) : int(this.mCurrentMapIndexOnScreen - 1);
            FSDebug.debugTrace("Forcing index to be " + param1);
            _loc4_ = true;
         }
         if(_loc3_ && _loc4_)
         {
            this.mCurrentMapIndexOnScreen = param1;
            FSDebug.debugTrace("Setting map index: " + this.mCurrentMapIndexOnScreen + " as active");
            this.checkIfMapsNeedToBeAdded();
            if(param2)
            {
               this.checkMapsToBeRemoved();
            }
            this.updateLevelItemStars();
         }
         if(this.mWaitingToCenterTheCamOnCurrentLevel)
         {
            if(this.areSurroundingMapsLoaded())
            {
               this.onWaitingToCenterCameraAssetsLoaded();
            }
         }
      }
      
      private function checkMapsToBeRemoved() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MapDef = null;
         if(this.mAllMapsDefsArr)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mAllMapsDefsArr.length)
            {
               _loc3_ = MapDef(this.mAllMapsDefsArr[_loc2_].value);
               if(_loc3_)
               {
                  _loc1_ = _loc3_.getIndex();
                  if(!this.isMapEligibleToBeAdded(_loc1_))
                  {
                     this.removeMap(_loc1_);
                  }
               }
               _loc2_++;
            }
         }
      }
      
      public function centerCamerOnCurrentLevelItem() : void
      {
         if(this.mCurrentLevelItem)
         {
            this.setCameraZPosition(this.mCurrentLevelItem);
         }
      }
      
      public function centerCamerOnLastLevelPlayedItem() : void
      {
         if(this.mLastLevelPlayedItem)
         {
            this.setCameraZPosition(this.mLastLevelPlayedItem);
         }
      }
      
      public function setCameraZPosition(param1:LevelItemContainer) : void
      {
         var _loc2_:MapPlane = null;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Boolean = false;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         if(param1)
         {
            _loc2_ = param1.getMapPlaneParent();
            if(_loc2_)
            {
               _loc3_ = 0;
               _loc4_ = Root.assets.getObject("mapLevelsPositions");
               if(_loc4_)
               {
                  _loc3_ = int(_loc4_[_loc2_.getMapSuffix()][param1.getLevelIndexInMap()].y);
               }
               _loc5_ = _loc2_.y * -1;
               if(_loc3_ < 250)
               {
                  _loc6_ = _loc2_.height / 4;
               }
               else if(_loc3_ <= 500)
               {
                  _loc6_ = _loc2_.height / 6;
               }
               else if(_loc3_ > 500 && _loc3_ <= 750)
               {
                  _loc6_ = -_loc2_.height / 6;
               }
               else
               {
                  _loc6_ = -_loc2_.height / 4;
               }
               _loc7_ = _loc5_ + _loc6_;
               _loc8_ = _loc2_.isMovable(_loc7_);
               if(_loc8_)
               {
                  _loc10_ = _loc2_.getMaxBoundary();
                  if(_loc2_.isLastMap() && _loc3_ < 500)
                  {
                     _loc8_ = _loc7_ < 0 || y + _loc7_ < _loc10_;
                  }
                  else if(_loc2_.isFirstMap() && _loc3_ > 500)
                  {
                     _loc8_ = _loc2_.y + _loc7_ > _loc10_;
                  }
               }
               _loc9_ = _loc8_ ? _loc7_ : _loc5_;
               _loc2_.translateMap(_loc9_);
            }
         }
      }
      
      private function checkIfMapsNeedToBeAdded() : void
      {
         var _loc1_:MapPlane = null;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         if(this.mMapPlanesCatalog != null)
         {
            _loc4_ = this.mCurrentMapIndexOnScreen - this.MAPS_OFFSET_SCROLLING;
            while(_loc4_ <= this.mCurrentMapIndexOnScreen + this.MAPS_OFFSET_SCROLLING)
            {
               _loc3_ = MapPlane.MAP_EPISODES_PREFIX + Utils.transformValueToString(_loc4_.toString(),2);
               if(_loc4_ > 0 && this.isMapEligibleToBeAdded(_loc4_) && this.mAllMapsDefsArr != null && _loc4_ <= this.mAllMapsDefsArr.length)
               {
                  _loc5_ = this.mMapPlanesCatalog[_loc4_] != null;
                  if(!_loc5_)
                  {
                     FSDebug.debugTrace("Add map: " + _loc4_);
                     this.addMapToCatalog(_loc4_);
                  }
               }
               _loc4_++;
            }
         }
      }
      
      public function checkIfMapTextureExistsByIndex(param1:int) : Boolean
      {
         return this.mMapPlanesCatalog != null && this.mMapPlanesCatalog[param1] != null;
      }
      
      public function getCurrentMapIndex() : int
      {
         return this.mCurrentMapIndexOnScreen;
      }
      
      public function resetCameraPosition() : void
      {
         FSDebug.debugTrace("reset cam pos");
         var _loc1_:int = InstanceMng.getUserDataMng().getOwnerUserData().getLastLevelPlayedMapIndex();
         var _loc2_:int = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
         var _loc3_:int = _loc1_ != -1 ? _loc1_ : InstanceMng.getUserDataMng().getOwnerUserData().getCurrentMapIndex(_loc2_);
         this.setMapPlaneAsActive(_loc3_);
         if(_loc1_ != -1)
         {
            this.centerCamerOnLastLevelPlayedItem();
         }
         else
         {
            this.centerCamerOnCurrentLevelItem();
         }
         this.refreshLevelsVisibility();
      }
      
      public function refreshLevelsVisibility() : void
      {
         var _loc1_:MapPlane = null;
         if(this.mMapPlanesCatalog)
         {
            for each(_loc1_ in this.mMapPlanesCatalog)
            {
               if(_loc1_)
               {
                  _loc1_.checkLevelItemsMeshVisibility();
               }
            }
         }
      }
      
      public function make3DSceneVisible(param1:Boolean, param2:Number = 0) : void
      {
         var _loc3_:MapPlane = null;
         for each(_loc3_ in this.mMapPlanesCatalog)
         {
            _loc3_.setTouchable(param1);
            _loc3_.tweenLevelVisibility(param1);
         }
         if(this.mOwnerProfilePortrait)
         {
            this.mOwnerProfilePortrait.visible = param1;
         }
      }
      
      public function makePlanesTouchable(param1:Boolean) : void
      {
         var _loc2_:MapPlane = null;
         for each(_loc2_ in this.mMapPlanesCatalog)
         {
            _loc2_.setTouchable(param1);
         }
         smMapsTouchable = param1;
      }
      
      public function highlightCurrentLevelItem(param1:LevelItemContainer) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         if(this.mCurrentLevelItem != null)
         {
            this.mCurrentLevelItem.removeOwnerProfilePicture();
         }
         this.mCurrentLevelItem = param1;
         var _loc2_:Boolean = this.mCurrentLevelItem != null && Boolean(Main.smPreviousLevelItem) && Main.smPreviousLevelItem.getLevelSku() == this.mCurrentLevelItem.getLevelSku();
         if(Main.smPreviousLevelItem == null || _loc2_)
         {
            this.mCurrentLevelItem.startHighlight();
            this.performPortraitTransition(false,true);
         }
         else
         {
            _loc3_ = Config.getConfig().mapShowsLastMapLevelVisible();
            _loc4_ = InstanceMng.getMapsDefMng().isLastLevelOfMap(this.mCurrentLevelItem.getLevelDef().getLevelIndex());
            if(!_loc2_ && (!_loc3_ || _loc3_ && !_loc4_))
            {
               this.mCurrentLevelItem.zoomOut(null,null,0.001);
            }
         }
         this.addOwnerProfilePortrait(false);
      }
      
      public function updateLastLevelPlayedLevelItem(param1:LevelItemContainer) : void
      {
         this.mLastLevelPlayedItem = param1;
      }
      
      public function getCurrentLevelItem() : LevelItemContainer
      {
         return this.mCurrentLevelItem;
      }
      
      public function updateAllMapsLevels() : void
      {
         var _loc1_:MapPlane = null;
         for each(_loc1_ in this.mMapPlanesCatalog)
         {
            _loc1_.updateOwnerCurrentLevelSku();
         }
      }
      
      private function addAllButtons() : void
      {
         if(this.mShopButton != null)
         {
            this.mTopMenuBar.addChild(this.mShopButton);
         }
         if(this.mDeckBuilderButton != null)
         {
            this.mTopMenuBar.addChild(this.mDeckBuilderButton);
         }
         if(this.mPvPButton != null)
         {
            this.mTopMenuBar.addChild(this.mPvPButton);
         }
         if(this.mDungeonsButton)
         {
            this.mTopMenuBar.addChild(this.mDungeonsButton);
         }
         if(this.mRaidsButton)
         {
            this.mTopMenuBar.addChild(this.mRaidsButton);
         }
         if(this.mGoldVisor != null)
         {
            this.mTopMenuBar.addChild(this.mGoldVisor);
         }
         if(this.mLootButton)
         {
            addChild(this.mLootButton);
         }
         if(this.mAuctionsButton)
         {
            addChild(this.mAuctionsButton);
         }
         if(this.mQuestsButton)
         {
            addChild(this.mQuestsButton);
         }
         if(this.mBattlePassButton)
         {
            addChild(this.mBattlePassButton);
         }
      }
      
      private function getXPositionForTopBar(param1:int, param2:DisplayObjectContainer) : FSCoordinate
      {
         return Utils.getXYPositionInContainer(param1,param2.width,param2.height,this.mTopMenuBar.width - param2.width / 2,this.mTopMenuBar.height,6,1,true);
      }
      
      protected function createShopButton() : void
      {
         var _loc1_:String = null;
         var _loc2_:uint = 0;
         var _loc3_:FSCoordinate = null;
         if(this.mShopButton == null)
         {
            _loc1_ = InstanceMng.getTutorialMng() == null || Boolean(InstanceMng.getTutorialMng()) && Boolean(InstanceMng.getTutorialMng().isTutorialOver()) ? this.SHOP_BUTTON_NAME : this.SHOP_BUTTON_NAME + "_disabled";
            this.mShopButton = new FSMenuButton(this.BUTTONS_BASE_L_NAME,TextManager.getText("TID_GEN_MENU_SHOP"),this.showShop,_loc1_);
            _loc2_ = Config.getConfig().mapTopButtonsColor();
            this.mShopButton.setFontColor(_loc2_);
            _loc3_ = this.getXPositionForTopBar(0,this.mShopButton);
            this.mShopButton.x = this.mShopButton.width / 2 + _loc3_.mX;
            this.mShopButton.y = this.mShopButton.height / 1.9;
            this.mShopButton.addEventListener(TouchEvent.TOUCH,this.onDiffTouch);
         }
      }
      
      protected function createDeckBuilderButton() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         var _loc4_:FSCoordinate = null;
         if(this.mDeckBuilderButton == null)
         {
            _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
            _loc2_ = InstanceMng.getTutorialMng() == null || _loc1_ != UserDataMng.DIFFICULTY_EASY || Boolean(InstanceMng.getTutorialMng()) && Boolean(InstanceMng.getTutorialMng().isTutorialOver()) ? this.DECK_BUILDER_BUTTON_NAME : this.DECK_BUILDER_BUTTON_NAME + "_disabled";
            this.mDeckBuilderButton = new FSMenuButton(this.BUTTONS_BASE_L_NAME,TextManager.getText("TID_GEN_MENU_DECK"),this.showDeckBuilder,_loc2_);
            _loc3_ = Config.getConfig().mapTopButtonsColor();
            this.mDeckBuilderButton.setFontColor(_loc3_);
            _loc4_ = this.getXPositionForTopBar(1,this.mDeckBuilderButton);
            this.mDeckBuilderButton.x = this.mDeckBuilderButton.width / 2 + _loc4_.mX;
            this.mDeckBuilderButton.y = this.mShopButton.y;
            this.mDeckBuilderButton.setEnabled(true);
            this.mDeckBuilderButton.addEventListener(TouchEvent.TOUCH,this.onDiffTouch);
         }
      }
      
      protected function createPvPButton() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         var _loc4_:FSCoordinate = null;
         if(this.mPvPButton == null)
         {
            _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
            _loc2_ = InstanceMng.getTutorialMng() == null || _loc1_ != UserDataMng.DIFFICULTY_EASY || Boolean(InstanceMng.getTutorialMng()) && Boolean(InstanceMng.getTutorialMng().isTutorialOver()) ? this.PVP_BUTTON_NAME : this.PVP_BUTTON_NAME + "_disabled";
            this.mPvPButton = new FSMenuButton(this.BUTTONS_BASE_L_NAME,TextManager.getText("TID_GEN_MENU_PVP"),this.showPvP,_loc2_);
            _loc3_ = Config.getConfig().mapTopButtonsColor();
            this.mPvPButton.setFontColor(_loc3_);
            _loc4_ = this.getXPositionForTopBar(2,this.mPvPButton);
            this.mPvPButton.x = this.mPvPButton.width / 2 + _loc4_.mX;
            this.mPvPButton.y = this.mShopButton.y;
            this.mPvPButton.setEnabled(true);
            this.mPvPButton.addEventListener(TouchEvent.TOUCH,this.onDiffTouch);
         }
      }
      
      protected function createDungeonsButton() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         var _loc6_:uint = 0;
         var _loc7_:FSCoordinate = null;
         if(Config.getConfig().usesDungeons() && this.mDungeonsButton == null)
         {
            _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData() ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty() : UserDataMng.DIFFICULTY_EASY;
            _loc2_ = InstanceMng.getUserDataMng().getOwnerUserData() ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelIndex(_loc1_) : 0;
            _loc3_ = InstanceMng.getTutorialMng() == null || Boolean(InstanceMng.getTutorialMng()) && InstanceMng.getTutorialMng().isTutorialOver();
            _loc4_ = _loc3_ && _loc2_ >= Config.getConfig().getUnlockDungeonsLevel() || _loc1_ != UserDataMng.DIFFICULTY_EASY;
            _loc5_ = _loc4_ ? this.DUNGEONS_BUTTON_NAME : this.DUNGEONS_BUTTON_NAME + "_disabled";
            this.mDungeonsButton = new FSMenuButton(this.BUTTONS_BASE_L_NAME,TextManager.getText("TID_DUNGEON_NAME"),this.showDungeons,_loc5_);
            this.mDungeonsButton.name = "dungeons_button";
            _loc6_ = Config.getConfig().mapTopButtonsColor();
            this.mDungeonsButton.setFontColor(_loc6_);
            _loc7_ = this.getXPositionForTopBar(3,this.mDungeonsButton);
            this.mDungeonsButton.x = this.mDungeonsButton.width / 2 + _loc7_.mX;
            this.mDungeonsButton.y = this.mShopButton.y;
         }
      }
      
      protected function createRaidsButton() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:String = null;
         var _loc5_:uint = 0;
         var _loc6_:FSCoordinate = null;
         if(Config.getConfig().usesRaids() && this.mRaidsButton == null)
         {
            _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData() ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelIndex(UserDataMng.DIFFICULTY_EASY) : 0;
            _loc2_ = InstanceMng.getTutorialMng() == null || Boolean(InstanceMng.getTutorialMng()) && InstanceMng.getTutorialMng().isTutorialOver();
            _loc3_ = _loc2_ && _loc1_ >= Config.getConfig().getUnlockRaidsLevel();
            _loc4_ = _loc3_ ? this.RAIDS_BUTTON_NAME : this.RAIDS_BUTTON_NAME + "_disabled";
            this.mRaidsButton = new FSMenuButton(this.BUTTONS_BASE_L_NAME,TextManager.getText("TID_RAID"),this.showRaids,_loc4_);
            this.mRaidsButton.name = "raids_button";
            _loc5_ = Config.getConfig().mapTopButtonsColor();
            this.mRaidsButton.setFontColor(_loc5_);
            _loc6_ = this.getXPositionForTopBar(4,this.mRaidsButton);
            this.mRaidsButton.x = this.mRaidsButton.width / 2 + _loc6_.mX;
            this.mRaidsButton.y = this.mShopButton.y;
         }
      }
      
      public function showDeckBuilder() : void
      {
         var _loc1_:String = null;
         if(this.isSubMenuShown())
         {
            this.closeSubMenu();
         }
         if(!this.mShowingComic)
         {
            if(InstanceMng.getTutorialMng())
            {
               if(InstanceMng.getTutorialMng().isTutorialOver())
               {
                  if(!Screen.isScreenLocked())
                  {
                     dispatchEventWith(Screen.GO_TO_DECK_BUILDER,true);
                  }
                  else
                  {
                     TweenMax.delayedCall(0.1,this.showDeckBuilder);
                  }
               }
               else
               {
                  _loc1_ = TextManager.replaceParameters(TextManager.getText("TID_DECKBUILDER_LOCKED"),[InstanceMng.getTutorialMng().getFirstNonTutorialLevelIndex()]);
                  Utils.setLogText(_loc1_,true);
               }
            }
         }
      }
      
      public function showShop() : void
      {
         var _loc2_:String = null;
         var _loc1_:UserData = Utils.getOwnerUserData();
         if(_loc1_)
         {
            FSTracker.trackFirebaseEvent("VISIT_SHOP",["level"],[_loc1_.getCurrentLevelIndex(UserDataMng.DIFFICULTY_EASY)]);
         }
         if(this.isSubMenuShown())
         {
            this.closeSubMenu();
         }
         if(!this.mShowingComic)
         {
            if(InstanceMng.getTutorialMng())
            {
               if(InstanceMng.getTutorialMng().isTutorialOver())
               {
                  if(!Utils.smInternetAvailable || !InstanceMng.getServerConnection().isUserLoggedIn())
                  {
                     Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true);
                     onConnectionLost();
                  }
                  else if(Utils.smInternetAvailable || Config.isDebug())
                  {
                     if(!Screen.isScreenLocked())
                     {
                        if(InstanceMng.getUserDataMng().getOwnerUserData().getCustomOfferNewBannerShown())
                        {
                           Main.smData["shop_category"] = FSShopScreen.CATEGORY_1_OFFERS;
                        }
                        else
                        {
                           Main.smData["shop_category"] = FSShopScreen.CATEGORY_2_PACKS;
                        }
                        dispatchEventWith(Screen.GO_TO_SHOP,true);
                     }
                     else
                     {
                        FSDebug.debugTrace("Calling again showShop in 0.1s");
                        TweenMax.delayedCall(0.1,this.showShop);
                     }
                  }
                  else
                  {
                     Utils.setLogText(TextManager.getText("TID_SHOP_APPSTORE_RETRY"),true);
                  }
               }
               else
               {
                  _loc2_ = TextManager.replaceParameters(TextManager.getText("TID_SHOP_LOCKED"),[InstanceMng.getTutorialMng().getFirstNonTutorialLevelIndex()]);
                  Utils.setLogText(_loc2_,true);
               }
            }
         }
      }
      
      public function showPvP() : void
      {
         var _loc1_:String = null;
         if(this.isSubMenuShown())
         {
            this.closeSubMenu();
         }
         if(!this.mShowingComic)
         {
            if(InstanceMng.getTutorialMng())
            {
               if(InstanceMng.getTutorialMng().isTutorialOver())
               {
                  if(!Screen.isScreenLocked())
                  {
                     dispatchEventWith(Screen.GO_TO_PVP,true);
                  }
                  else
                  {
                     TweenMax.delayedCall(0.1,this.showPvP);
                  }
               }
               else
               {
                  _loc1_ = TextManager.replaceParameters(TextManager.getText("TID_PVP_LOCKED"),[InstanceMng.getTutorialMng().getFirstNonTutorialLevelIndex()]);
                  Utils.setLogText(_loc1_,true);
               }
            }
         }
      }
      
      protected function createAuctionsButton() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         if(Config.getConfig().gameHasAuctions())
         {
            if(this.mAuctionsButton == null)
            {
               _loc1_ = InstanceMng.getTutorialMng() == null || Boolean(InstanceMng.getTutorialMng()) && InstanceMng.getTutorialMng().isTutorialOver();
               this.mAuctionsButton = new SubMenuButton("button_auctions","button_auctions_disabled",this.showAuctions,TextManager.getText("TID_AUCTIONS_AUCTIONS"));
               this.mAuctionsButton.name = "auctions_button";
               _loc2_ = InstanceMng.getUserDataMng().getOwnerUserData() ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty() : UserDataMng.DIFFICULTY_EASY;
               _loc3_ = InstanceMng.getUserDataMng().getOwnerUserData() ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelIndex(_loc2_) : 0;
               _loc4_ = _loc1_ && _loc3_ >= Config.getConfig().getUnlockAuctionsLevel() || _loc2_ != UserDataMng.DIFFICULTY_EASY;
               this.mAuctionsButton.setEnabled(_loc4_);
            }
         }
      }
      
      protected function createLootButton() : void
      {
         var _loc1_:Boolean = false;
         if(this.mLootButton == null)
         {
            _loc1_ = InstanceMng.getTutorialMng() == null || Boolean(InstanceMng.getTutorialMng()) && InstanceMng.getTutorialMng().isTutorialOver();
            this.mLootButton = new SubMenuButton("button_rewards","button_rewards_disabled",this.showLoot,TextManager.getText("TID_REWARDS_NAME"));
            this.mLootButton.name = "loot_button";
            this.mLootButton.setEnabled(true);
         }
      }
      
      private function showLoot() : void
      {
         if(InstanceMng.getTutorialMapMng().isTutorialON())
         {
            InstanceMng.getTutorialMapMng().increaseCurrentStep();
         }
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            if(this.mLootButton.isEnabled())
            {
               if(!this.mShowingComic)
               {
                  if(!Screen.isScreenLocked())
                  {
                     if(this.isSubMenuShown())
                     {
                        this.closeSubMenu();
                     }
                     InstanceMng.getPopupMng().openRewardsPopup();
                  }
               }
            }
            else
            {
               Utils.setLogText(TextManager.getText("TID_GEN_LOOT_LOCKED"),true);
            }
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true);
         }
      }
      
      protected function createBattlePassButton() : void
      {
         var _loc1_:int = 0;
         var _loc2_:UserData = null;
         var _loc3_:Boolean = false;
         if(Config.getConfig().hasBattlePass())
         {
            if(this.mBattlePassButton == null)
            {
               this.mBattlePassButton = new SubMenuButton("button_challenge","button_challenge_disabled",this.showBattlePassPopup,TextManager.getText("TID_BP_BATTLEPASS"));
               this.mBattlePassButton.name = "battlePass_button";
               _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData() ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelIndex(UserDataMng.DIFFICULTY_EASY) : 0;
               _loc2_ = Utils.getOwnerUserData();
               _loc3_ = _loc2_ ? _loc2_.isBattlePassUnlocked() : false;
               this.mBattlePassButton.setEnabled(_loc3_);
            }
         }
      }
      
      private function showBattlePassPopup() : void
      {
         var _loc1_:String = null;
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            if(this.mBattlePassButton.isEnabled())
            {
               if(!this.mShowingComic)
               {
                  if(!Screen.isScreenLocked())
                  {
                     if(this.isSubMenuShown())
                     {
                        this.closeSubMenu();
                     }
                     InstanceMng.getPopupMng().openBattlePassPopup();
                  }
               }
            }
            else
            {
               _loc1_ = TextManager.replaceParameters(TextManager.getText("TID_GEN_FEATURE_LOCKED"),[Config.getConfig().getUnlockBattlePassLevel()]);
               Utils.setLogText(_loc1_,true);
            }
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true);
         }
      }
      
      protected function createQuestsButton() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         if(Config.getConfig().hasQuests())
         {
            if(this.mQuestsButton == null)
            {
               this.mQuestsButton = new SubMenuButton("button_quest","button_quest_disabled",this.showQuestPopup,TextManager.getText("TID_BUTTON_QUEST"));
               this.mQuestsButton.name = "quests_button";
               _loc1_ = InstanceMng.getTutorialMng() == null || Boolean(InstanceMng.getTutorialMng()) && InstanceMng.getTutorialMng().isTutorialOver();
               _loc2_ = InstanceMng.getUserDataMng().getOwnerUserData() ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelIndex(UserDataMng.DIFFICULTY_EASY) : 0;
               _loc3_ = _loc1_ && _loc2_ >= Config.getConfig().getUnlockQuestsLevel();
               this.mQuestsButton.setEnabled(_loc3_);
            }
         }
      }
      
      private function showQuestPopup() : void
      {
         var _loc1_:String = null;
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            if(this.mQuestsButton.isEnabled())
            {
               if(!this.mShowingComic)
               {
                  if(!Screen.isScreenLocked())
                  {
                     if(this.isSubMenuShown())
                     {
                        this.closeSubMenu();
                     }
                     if(InstanceMng.getTutorialMapMng().isTutorialON())
                     {
                        InstanceMng.getTutorialMapMng().increaseCurrentStep();
                     }
                     InstanceMng.getPopupMng().openQuestPopup();
                  }
               }
            }
            else
            {
               _loc1_ = TextManager.replaceParameters(TextManager.getText("TID_GEN_QUEST_LOCKED"),[Config.getConfig().getUnlockQuestsLevel()]);
               Utils.setLogText(_loc1_,true);
            }
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true);
         }
      }
      
      private function tutorialGrantsAccessToScreen() : Boolean
      {
         var _loc1_:Boolean = InstanceMng.getTutorialMapMng().isTutorialON();
         return !_loc1_ || _loc1_ && InstanceMng.getTutorialMapMng().isTutorialWaitingForAPopup();
      }
      
      private function showDungeons() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:String = null;
         if(!Utils.smInternetAvailable || !InstanceMng.getServerConnection().isUserLoggedIn())
         {
            Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true);
            onConnectionLost();
         }
         else
         {
            InstanceMng.getTutorialMapMng().increaseCurrentStep();
            _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData() ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty() : UserDataMng.DIFFICULTY_EASY;
            _loc2_ = InstanceMng.getUserDataMng().getOwnerUserData() ? InstanceMng.getLevelsDefMng().getLevelIndexByLevelSku(InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelSkuByDifficulty(_loc1_)) : 0;
            _loc3_ = _loc2_ >= Config.getConfig().getUnlockDungeonsLevel() || _loc1_ != UserDataMng.DIFFICULTY_EASY;
            if(_loc3_)
            {
               if(!this.mShowingComic)
               {
                  if(InstanceMng.getTutorialMng())
                  {
                     if(InstanceMng.getTutorialMng().isTutorialOver())
                     {
                        if(!Screen.isScreenLocked())
                        {
                           if(this.isSubMenuShown())
                           {
                              this.closeSubMenu();
                           }
                           dispatchEventWith(Screen.GO_TO_DUNGEONS,true);
                        }
                        else
                        {
                           TweenMax.delayedCall(0.1,this.showDungeons);
                        }
                     }
                     else
                     {
                        _loc4_ = TextManager.replaceParameters(TextManager.getText("TID_DUNGEON_LOCKED"),[InstanceMng.getTutorialMng().getFirstNonTutorialLevelIndex()]);
                        Utils.setLogText(_loc4_,true);
                     }
                  }
               }
            }
            else
            {
               _loc4_ = TextManager.replaceParameters(TextManager.getText("TID_DUNGEON_LOCKED"),[Config.getConfig().getUnlockDungeonsLevel()]);
               Utils.setLogText(_loc4_,true);
            }
         }
      }
      
      private function showAuctions() : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         InstanceMng.getTutorialMapMng().increaseCurrentStep();
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            if(this.mAuctionsButton.isEnabled())
            {
               if(!this.mShowingComic)
               {
                  if(InstanceMng.getTutorialMng())
                  {
                     if(InstanceMng.getTutorialMng().isTutorialOver())
                     {
                        if(!Screen.isScreenLocked())
                        {
                           if(this.isSubMenuShown())
                           {
                              this.closeSubMenu();
                           }
                           dispatchEventWith(Screen.GO_TO_AUCTIONS,true);
                        }
                        else
                        {
                           TweenMax.delayedCall(0.1,this.showAuctions);
                        }
                     }
                     else
                     {
                        _loc1_ = TextManager.replaceParameters(TextManager.getText("TID_DUNGEON_LOCKED"),[InstanceMng.getTutorialMng().getFirstNonTutorialLevelIndex()]);
                        Utils.setLogText(_loc1_,true);
                     }
                  }
               }
            }
            else
            {
               _loc2_ = InstanceMng.getUserDataMng().getOwnerUserData() ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty() : UserDataMng.DIFFICULTY_EASY;
               _loc3_ = InstanceMng.getUserDataMng().getOwnerUserData() ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelIndex(_loc2_) : 0;
               if(_loc3_ < Config.getConfig().getUnlockAuctionsLevel() && _loc2_ == UserDataMng.DIFFICULTY_EASY)
               {
                  _loc1_ = TextManager.replaceParameters(TextManager.getText("TID_AUCTIONS_UNLOCKED"),[Config.getConfig().getUnlockAuctionsLevel()]);
                  Utils.setLogText(_loc1_,true);
               }
            }
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true);
         }
      }
      
      private function showRaids() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Boolean = false;
         var _loc3_:String = null;
         if(!Utils.smInternetAvailable || !InstanceMng.getServerConnection().isUserLoggedIn())
         {
            Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true);
            onConnectionLost();
         }
         else
         {
            InstanceMng.getTutorialMapMng().increaseCurrentStep();
            _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData() ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelIndex(UserDataMng.DIFFICULTY_EASY) : 0;
            _loc2_ = _loc1_ >= Config.getConfig().getUnlockRaidsLevel();
            if(_loc2_)
            {
               if(!this.mShowingComic)
               {
                  if(InstanceMng.getTutorialMng())
                  {
                     if(InstanceMng.getTutorialMng().isTutorialOver())
                     {
                        if(!Screen.isScreenLocked())
                        {
                           if(this.isSubMenuShown())
                           {
                              this.closeSubMenu();
                           }
                           dispatchEventWith(Screen.GO_TO_RAIDS,true);
                        }
                        else
                        {
                           TweenMax.delayedCall(0.1,this.showRaids);
                        }
                     }
                     else
                     {
                        _loc3_ = TextManager.replaceParameters(TextManager.getText("TID_DUNGEON_LOCKED"),[InstanceMng.getTutorialMng().getFirstNonTutorialLevelIndex()]);
                        Utils.setLogText(_loc3_,true);
                     }
                  }
               }
            }
            else
            {
               _loc3_ = TextManager.replaceParameters(TextManager.getText("TID_RAID_UNLOCK_LEVEL"),[Config.getConfig().getUnlockRaidsLevel()]);
               Utils.setLogText(_loc3_,true);
            }
         }
      }
      
      protected function createGoldVisor(param1:String = "", param2:Boolean = true, param3:Number = 1) : void
      {
         var _loc4_:FSCoordinate = null;
         if(this.mGoldVisor == null)
         {
            param3 = 1.5;
            this.mGoldVisor = new FSGoldVisor(this.GOLD_VISOR_BUTTON_NAME,param1,param2,null,"",param3);
            _loc4_ = this.getXPositionForTopBar(5,this.mGoldVisor);
            this.mGoldVisor.x = this.mGoldVisor.width / 2 + _loc4_.mX;
            this.mGoldVisor.y = this.mShopButton.y;
            this.mGoldVisor.addEventListener(TouchEvent.TOUCH,this.onDiffTouch);
         }
      }
      
      override public function getGoldVisor() : *
      {
         return this.mGoldVisor;
      }
      
      private function disableButtonTemporarily(param1:FSMenuButton) : void
      {
         if(param1)
         {
            param1.setEnabled(false);
            TweenMax.delayedCall(3,this.enableButton,[param1,true]);
         }
      }
      
      private function enableButton(param1:FSMenuButton, param2:Boolean) : void
      {
         if(param1)
         {
            param1.setEnabled(param2);
         }
      }
      
      public function isWaitingToCenterCamOnCurrentLevel() : Boolean
      {
         return this.mWaitingToCenterTheCamOnCurrentLevel;
      }
      
      override public function onConnectionChange(param1:Boolean = true) : void
      {
         super.onConnectionChange(param1);
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            InstanceMng.getServerConnection().refreshServerTime();
         }
      }
      
      public function refreshMap() : void
      {
         dispatchEventWith(Screen.GO_TO_MAP,true);
      }
      
      override public function removeTranslucentBG(param1:Boolean = false, param2:Boolean = false) : void
      {
         var _loc4_:Popup = null;
         var _loc3_:Boolean = this.tutorialGrantsAccessToScreen();
         if(_loc3_)
         {
            _loc4_ = InstanceMng.getPopupMng().getPopupShown();
            if(_loc4_ == null || (Boolean(_loc4_ && _loc4_ is PopupRewards) || Boolean(!(_loc4_ is PopupProductDetail))))
            {
               super.removeTranslucentBG(param1,param2);
            }
            if(Boolean(mSelectedCard) && !param2)
            {
               SpecialFX.zoomOut(mSelectedCard);
               mSelectedCard = null;
               if(_loc4_ != null)
               {
                  _loc4_.visible = true;
               }
            }
         }
      }
      
      override protected function onBackgroundTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         var _loc3_:Popup = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         if(!Root.assets.isLoading && !Screen.smCarrousselTransitionON)
         {
            _loc2_ = param1.getTouch(this,TouchPhase.ENDED);
            if(_loc2_)
            {
               _loc3_ = InstanceMng.getPopupMng().getPopupShown();
               _loc4_ = _loc3_ is PopupQuest;
               _loc5_ = InstanceMng.getTutorialMapMng().isTutorialON();
               if((_loc5_) && (InstanceMng.getTutorialMapMng().isTutorialReward() || InstanceMng.getTutorialMapMng().isTutorialInformation()))
               {
                  InstanceMng.getTutorialMapMng().increaseCurrentStep();
               }
               if(Screen.smOpeningPack || _loc4_ || _loc3_ == null || _loc3_ != null && _loc5_)
               {
                  this.removeTranslucentBG(true);
               }
               else
               {
                  checkIfPopupsCanBeClosed();
               }
            }
         }
         else
         {
            FSDebug.debugTrace("NOT TOUCHABLE, LOADING STUFF");
         }
      }
      
      public function isSubMenuShown() : Boolean
      {
         return Boolean(this.mSubMenu) && this.mSubMenu.isExpanded();
      }
      
      public function closeSubMenu() : void
      {
         if(this.mSubMenu)
         {
            this.mSubMenu.setExpanded(false);
         }
      }
      
      public function checkSubMenuNotificationIcon() : void
      {
         var _loc3_:int = 0;
         var _loc1_:Boolean = false;
         var _loc2_:Vector.<SubMenuButton> = this.mSubMenu ? this.mSubMenu.getButtonsVector() : null;
         if(Boolean(_loc2_) && _loc2_.length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               if(_loc2_[_loc3_].hasNotification())
               {
                  _loc1_ = true;
               }
               _loc3_++;
            }
            this.mSubMenu.showNotificationIcon(_loc1_);
         }
      }
      
      public function getSubMenu() : MapSubmenu
      {
         return this.mSubMenu;
      }
      
      public function onAchievementRewardClaimedHideNotificationIcon() : void
      {
         if(this.mAchievementsIndicator)
         {
            this.mAchievementsIndicator.showNotificationIcon(false);
         }
         this.checkSubMenuNotificationIcon();
         this.checkIfAnyStarsRewardsClaimeable();
         this.checkIfAnyBadgeRewardsClaimeable();
      }
      
      public function onQuestClaimedHideNotificationIcon() : void
      {
         if(this.mQuestsButton)
         {
            this.mQuestsButton.showNotificationIcon(false);
         }
         this.checkSubMenuNotificationIcon();
         this.checkIfAnyQuestClaimeable();
      }
      
      public function onBattlePassQuestClaimedHideNotificationIcon() : void
      {
         if(this.mBattlePassButton)
         {
            this.mBattlePassButton.showNotificationIcon(false);
         }
         this.checkSubMenuNotificationIcon();
         this.checkIfAnyBattlePassQuestClaimeable();
      }
      
      public function showShopNotificationIcon() : void
      {
         if(this.mNotificationIcon == null)
         {
            if(this.mShopButton)
            {
               this.mNotificationIcon = new FSImage(Root.assets.getTexture("claim_warning"));
               this.mNotificationIcon.alignPivot();
               this.mNotificationIcon.x = this.mShopButton.x + this.mShopButton.width / 2 - this.mNotificationIcon.width / 2;
               this.mNotificationIcon.y = this.mShopButton.y - this.mShopButton.height / 2 + this.mNotificationIcon.height / 3;
               addChild(this.mNotificationIcon);
            }
         }
         this.mNotificationIcon.visible = this.mIsSomethingNewInTheShop;
      }
      
      public function showRewardsNotificationIcon() : void
      {
         if(this.mNotificationIcon == null)
         {
            if(this.mShopButton)
            {
               this.mNotificationIcon = new FSImage(Root.assets.getTexture("claim_warning"));
               this.mNotificationIcon.alignPivot();
               this.mNotificationIcon.x = this.mShopButton.x + this.mShopButton.width / 2 - this.mNotificationIcon.width / 2;
               this.mNotificationIcon.y = this.mShopButton.y - this.mShopButton.height / 2 + this.mNotificationIcon.height / 3;
               addChild(this.mNotificationIcon);
            }
         }
         this.mNotificationIcon.visible = this.mIsSomethingNewInTheShop;
      }
      
      private function onHasGift(param1:Boolean) : void
      {
         this.mIsSomethingNewInTheShop = param1;
      }
      
      public function isMapUnlockedEffectActive() : Boolean
      {
         return this.mIsMapUnlockedEffectActive;
      }
      
      public function setIsMapUnlockedEffectActive(param1:Boolean) : void
      {
         this.mIsMapUnlockedEffectActive = param1;
         this.updateRecruitButtonVisibility();
      }
      
      public function isReadyToTutorial() : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc1_:Boolean = false;
         if(Boolean(this.mCurrentLevelItem) && Boolean(this.mCurrentLevelItem.getLevelDef()))
         {
            _loc2_ = InstanceMng.getMapsDefMng().isFirstLevelOfMap(this.mCurrentLevelItem.getLevelDef().getLevelIndex());
            if(_loc2_)
            {
               if(!this.isMapUnlockedEffectActive())
               {
                  _loc1_ = true;
               }
            }
            else
            {
               _loc1_ = true;
            }
         }
         return _loc1_;
      }
      
      public function addOwnerProfilePortrait(param1:Boolean = true) : void
      {
         var path:String = null;
         var extId:String = null;
         var transitionPortrait:Function = null;
         var ownerUserData:UserData = null;
         var fbPlugin:FSFacebookPlugin = null;
         var performTransition:Boolean = param1;
         transitionPortrait = function():void
         {
            if(isOkToTransitionMapPortrait())
            {
               performPortraitTransition(false,true);
            }
            else
            {
               mWaitingToTransitionPortraitToNextLevel = true;
            }
         };
         var fake:Boolean = false;
         var isDefaultImg:Boolean = false;
         if(fake)
         {
            extId = "582075610";
            path = FSFacebookPlugin.FACEBOOK_GRAPH_PREFIX + extId + PlayerPortrait.FACEBOOK_PIC_SUFFIX;
         }
         else
         {
            ownerUserData = Utils.getOwnerUserData();
            if(ownerUserData)
            {
               fbPlugin = InstanceMng.getFacebookPlugin();
               if(fbPlugin != null && fbPlugin.isSessionOpen() || InstanceMng.getApplication().isKongregateVersion())
               {
                  path = ownerUserData.getPhotoUrl();
                  extId = ownerUserData.getExtId();
               }
               else if(Utils.isDesktop())
               {
                  path = ownerUserData.getPhotoUrl();
                  extId = ownerUserData.getExtId();
               }
               else
               {
                  isDefaultImg = true;
               }
               if(ownerUserData.flagsShowDefaultAvatar())
               {
                  isDefaultImg = true;
                  path = "";
                  extId == "";
               }
            }
         }
         if(path != null && path != "" || isDefaultImg)
         {
            if(this.mOwnerProfilePortrait == null || (this.mOwnerProfilePortrait != null && (this.mOwnerProfilePortrait.hasOwnProperty("width") && this.mOwnerProfilePortrait.width == 0) || !this.mOwnerProfilePortrait.hasOwnProperty("width")))
            {
               this.mOwnerProfilePortrait = new MapPlayerPortrait(path,extId,true,isDefaultImg);
            }
            setTimeout(transitionPortrait,500);
         }
      }
      
      public function performPortraitTransition(param1:Boolean = false, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TweenMax = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         if(Boolean(this.mMapPlanesCatalog && this.mOwnerProfilePortrait && this.mCurrentLevelItem && this.mCurrentLevelItem.getLevelMesh() && isFullyLoaded()) && Boolean(InstanceMng.getCurrentScreen() is FSMapScreen) && (this.mWaitingToTransitionPortraitToNextLevel || param2))
         {
            this.mWaitingToTransitionPortraitToNextLevel = false;
            _loc3_ = this.mOwnerProfilePortrait.hasOwnProperty("width") ? int(this.mOwnerProfilePortrait.width) : 0;
            if(Main.smPreviousLevelItem != null && Main.smPreviousLevelItem.getLevelSku() != this.mCurrentLevelItem.getLevelSku() && Main.smPreviousLevelItem.hasOwnProperty("position"))
            {
               this.mOwnerProfilePortrait.position = Main.smPreviousLevelItem.position;
               if(this.mCurrentMapIndexOnScreen == Main.smPreviousLevelItem.getParentMapIndex() + 1)
               {
                  _loc5_ = -this.calculateMapDisplacement(this.mMapPlanesCatalog[this.mCurrentMapIndexOnScreen]);
                  _loc6_ = Utils.calculateZMovement(_loc5_,this.mOwnerProfilePortrait);
                  this.mOwnerProfilePortrait.moveUp(-_loc5_);
                  this.mOwnerProfilePortrait.moveBackward(_loc6_);
               }
               this.mIsPortraitTransitioning = true;
               _loc4_ = new TweenMax(this.mOwnerProfilePortrait,2.75,{
                  "x":this.mCurrentLevelItem.x + _loc3_,
                  "y":this.mCurrentLevelItem.y,
                  "z":this.mCurrentLevelItem.z - _loc3_,
                  "ease":Quart.easeInOut,
                  "onComplete":this.onPortraitReachedDestination
               });
            }
            else
            {
               _loc7_ = this.mCurrentLevelItem.hasOwnProperty("position") && this.mCurrentLevelItem.position.hasOwnProperty("x") ? this.mCurrentLevelItem.position.x : 0;
               _loc8_ = this.mCurrentLevelItem.hasOwnProperty("position") && this.mCurrentLevelItem.position.hasOwnProperty("y") ? this.mCurrentLevelItem.position.y : 0;
               _loc9_ = this.mCurrentLevelItem.hasOwnProperty("position") && this.mCurrentLevelItem.position.hasOwnProperty("z") ? this.mCurrentLevelItem.position.z : 0;
               this.mOwnerProfilePortrait.position = new Vector3D(_loc7_ + this.mCurrentLevelItem.getLevelMesh().width / 2,_loc8_,_loc9_ - _loc3_);
            }
            if(Boolean(this.mMapPlanesCatalog && this.mCurrentLevelItem) && Boolean(this.mCurrentLevelItem.getMapPlaneParent()) && Boolean(this.mCurrentLevelItem.getMapPlaneParent().getMapDef()))
            {
               if(this.mMapPlanesCatalog[this.mCurrentLevelItem.getMapPlaneParent().getMapDef().getIndex()] != null)
               {
                  this.mMapPlanesCatalog[this.mCurrentLevelItem.getMapPlaneParent().getMapDef().getIndex()].addChild(this.mOwnerProfilePortrait);
               }
            }
         }
      }
      
      private function onPortraitReachedDestination() : void
      {
         this.resetPreviousLevelItem();
         this.mIsPortraitTransitioning = false;
         if(!Screen.isScreenLocked())
         {
            setTimeout(this.frictionlessOpenPlayPopup,0.35);
         }
      }
      
      private function frictionlessOpenPlayPopup() : void
      {
         var _loc1_:UserData = null;
         var _loc2_:LevelDef = null;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:MapDef = null;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         if(InstanceMng.getCurrentScreen() is FSMapScreen && isFullyLoaded() && !this.isSubMenuShown() && !InstanceMng.getApplication().isGuildsPanelOpen())
         {
            if(!Screen.isScreenLocked() && InstanceMng.getPopupMng().getPopupShown() == null && Boolean(this.mCurrentLevelItem))
            {
               _loc1_ = Utils.getOwnerUserData();
               if(_loc1_)
               {
                  _loc2_ = LevelDef(InstanceMng.getLevelsDefMng().getDefBySku(this.mCurrentLevelItem.getLevelSku()));
                  if(_loc2_)
                  {
                     _loc3_ = _loc1_.getCurrentDifficulty();
                     _loc4_ = _loc2_.getLevelIndex() == _loc1_.getCurrentLevelIndex(_loc3_);
                     Main.smPreviousLevelItem = _loc4_ ? this.mCurrentLevelItem : null;
                     _loc5_ = InstanceMng.getMapsDefMng().isFirstLevelOfMap(_loc2_.getLevelIndex());
                     if(_loc5_)
                     {
                        _loc6_ = Boolean(this.mCurrentLevelItem) && Boolean(this.mCurrentLevelItem.getMapPlaneParent()) ? this.mCurrentLevelItem.getMapPlaneParent().getMapDef() : null;
                        if(_loc6_)
                        {
                           _loc7_ = _loc6_.isWorldMap() && !_loc1_.hasAlreadyChoosenWorld(_loc6_.getWorldParentIndex());
                           if(!_loc7_)
                           {
                              _loc8_ = _loc1_.isMapUnlocked(_loc6_.getIndex());
                              if(_loc8_)
                              {
                                 InstanceMng.getPopupMng().openPlayLevelPopup(this.mCurrentLevelItem.getLevelSku());
                              }
                              else
                              {
                                 InstanceMng.getPopupMng().openPlayLevelPopup(this.mCurrentLevelItem.getLevelSku());
                              }
                           }
                        }
                     }
                     else
                     {
                        InstanceMng.getPopupMng().openPlayLevelPopup(this.mCurrentLevelItem.getLevelSku());
                     }
                  }
               }
            }
         }
      }
      
      private function resetPreviousLevelItem() : void
      {
         Main.smPreviousLevelItem = null;
         this.mCurrentLevelItem.zoomIn(0.35);
         this.mCurrentLevelItem.startHighlight();
      }
      
      public function isWaitingToTransitionPortraitToNextLevel() : Boolean
      {
         return this.mWaitingToTransitionPortraitToNextLevel;
      }
      
      public function isOkToTransitionMapPortrait() : Boolean
      {
         var _loc1_:Boolean = Boolean(InstanceMng.getCurrentScreen()) && !InstanceMng.getCurrentScreen().isTransparentBGShown();
         var _loc2_:Boolean = InstanceMng.getTutorialMapMng().isTutorialON();
         var _loc3_:Boolean = !_loc2_ || _loc2_ && InstanceMng.getTutorialMapMng().getCurrentTutorialMapDef().hasToWaitForPopup();
         return _loc3_ && _loc1_ && !Screen.isScreenLocked() && !this.isMapUnlockedEffectActive();
      }
      
      public function addMapPlaneToStage(param1:MapPlane) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:MapPlane = null;
         var _loc6_:MapPlane = null;
         if(this.mMapsContainer == null)
         {
            this.mMapsContainer = new FSSprite3D();
            this.mMapsContainer.touchable = true;
            this.mMapsContainer.alignPivot();
            _loc2_ = Starling.current.stage.stageWidth;
            _loc3_ = Starling.current.stage.stageHeight;
            this.mMapsContainer.x = _loc2_ / 2;
            this.mMapsContainer.y = _loc3_ / 2;
         }
         if(param1)
         {
            if(this.mMapsContainer.numChildren > 0)
            {
               _loc4_ = param1.getMapDef().getIndex();
               _loc5_ = this.mMapPlanesCatalog[_loc4_ - 1];
               _loc6_ = this.mMapPlanesCatalog[_loc4_ + 1];
               if(Boolean(_loc5_) && _loc5_.parent != null)
               {
                  param1.position = _loc5_.position;
                  param1.translateMap(this.calculateMapDisplacement(param1));
               }
               else if(Boolean(_loc6_) && _loc6_.parent != null)
               {
                  param1.position = _loc6_.position;
                  param1.translateMap(-this.calculateMapDisplacement(param1));
               }
            }
            this.mMapsContainer.addChild(param1);
         }
         addChildAt(this.mMapsContainer,0);
      }
      
      private function calculateMapDisplacement(param1:MapPlane) : Number
      {
         var _loc2_:Number = Math.cos(deg2rad(MapPlane.MAP_ROTATION));
         var _loc3_:Number = param1.height * _loc2_;
         return -_loc3_;
      }
      
      public function getMapsContainer() : FSSprite3D
      {
         return this.mMapsContainer;
      }
      
      public function isPortraitTransitioning() : Boolean
      {
         return this.mIsPortraitTransitioning;
      }
      
      public function canMapTextureBeRemoved(param1:String) : Boolean
      {
         var _loc2_:MapPlane = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this.mMapsContainer)
         {
            _loc3_ = this.mMapsContainer.numChildren;
            if(_loc3_ > 0)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc3_)
               {
                  _loc2_ = this.mMapsContainer.getChildAt(_loc4_) is MapPlane ? MapPlane(this.mMapsContainer.getChildAt(_loc4_)) : null;
                  if(_loc2_)
                  {
                     if(_loc2_.getMapDef().calculateBGName() == param1)
                     {
                        return false;
                     }
                  }
                  _loc4_++;
               }
            }
         }
         return true;
      }
      
      public function isFirstVisit() : Boolean
      {
         return this.mIsFirstVisit;
      }
      
      public function getRecruitButton() : FSButton
      {
         return this.mRecruitButton;
      }
      
      public function getMapSelectorButton() : FSButton
      {
         return this.mMapSelectorButton;
      }
      
      public function travelToMap(param1:int) : void
      {
         var _loc3_:MapDef = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:LevelDef = null;
         var _loc2_:UserData = Utils.getOwnerUserData();
         if(_loc2_)
         {
            _loc3_ = MapDef(InstanceMng.getMapsDefMng().getDefBySku("map_" + Utils.transformValueToString(param1.toString(),2)));
            _loc4_ = _loc3_.getLevelsAmount();
            _loc5_ = 1 + (param1 - 1) * _loc4_;
            _loc6_ = LevelDef(InstanceMng.getLevelsDefMng().getLevelDefByLevelIndex(_loc5_));
            if(_loc6_)
            {
               _loc2_.setLastLevelPlayedSkuByDifficulty(_loc6_.getSku());
            }
         }
         InstanceMng.getCurrentScreen().dispatchEventWith(Screen.GO_TO_MAP,true);
      }
      
      override public function addLights(param1:Boolean = false, param2:Boolean = false) : void
      {
         super.addLights(false,true);
      }
   }
}

