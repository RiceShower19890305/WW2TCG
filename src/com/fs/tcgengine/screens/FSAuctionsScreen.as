package com.fs.tcgengine.screens
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.AuctionsMng;
   import com.fs.tcgengine.controller.QuestsMng;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.auctions.Auction;
   import com.fs.tcgengine.model.auctions.Bid;
   import com.fs.tcgengine.model.rules.AuctionTicketDef;
   import com.fs.tcgengine.model.rules.RarityDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.TimerUtil;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.anims.misc.TimerAnimation;
   import com.fs.tcgengine.view.auctions.FSAuctionSlot;
   import com.fs.tcgengine.view.auctions.FSBidSlot;
   import com.fs.tcgengine.view.cards.FSCardPreview;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.buttons.FSToggleButton;
   import com.fs.tcgengine.view.components.buttons.SubcategoryToggleButton;
   import com.fs.tcgengine.view.components.misc.FSAuctionTicketsVisor;
   import com.fs.tcgengine.view.components.misc.FSGoldVisor;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.components.shop.FSShopItem;
   import com.fs.tcgengine.view.misc.FSAuctionWinAnimation;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   import feathers.controls.ScrollContainer;
   import feathers.controls.ScrollPolicy;
   import feathers.layout.HorizontalAlign;
   import feathers.layout.HorizontalLayout;
   import feathers.layout.VerticalLayout;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import starling.core.Starling;
   import starling.display.Quad;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Align;
   
   public class FSAuctionsScreen extends Screen
   {
      
      public static const SELECTED_BUTTON_TEXTURE:String = "auction_base_button_up";
      
      public static const UNSELECTED_BUTTON_TEXTURE:String = "auction_base_button_down";
      
      public static const NUM_BIDS_IN_BID_PAGE:int = 3;
      
      public static const AUCTIONS_BY_PAGE:int = 6;
      
      public static const SHOW_BID_PLACED_ANIM:Boolean = true;
      
      private var mNextPageButton:FSButton;
      
      private var mPrevPageButton:FSButton;
      
      private var mTitlesBG:Quad;
      
      private var mCategoryColumnTitleImg:FSImage;
      
      private var mNameColumnTitle:FSTextfield;
      
      private var mRarityColumnTitleImg:FSImage;
      
      private var mValueColumnTitle:FSTextfield;
      
      private var mValueTitleImg:FSImage;
      
      private var mTimeColumnTitle:FSTextfield;
      
      private var mTimeColumnTitleImg:FSImage;
      
      private var mGoldVisor:FSGoldVisor;
      
      private var mAuctionTicketsVisor:FSAuctionTicketsVisor;
      
      private var mAuctionListButton:FSButton;
      
      private var mAuctionListIcon:FSImage;
      
      private var mAuctionListTextfield:FSTextfield;
      
      private var mMyAuctionsButton:FSButton;
      
      private var mInfoButton:FSButton;
      
      private var mMyAuctionsIcon:FSImage;
      
      private var mMyAuctionsTextfield:FSTextfield;
      
      private var mAuctionListSelected:Boolean = true;
      
      private var mMyAuctionsSelected:Boolean = false;
      
      private var mAuctionsScrollContainer:ScrollContainer;
      
      private var mAuctionsInfoServerArr:Array;
      
      private var mAuctionsVec:Vector.<Auction>;
      
      private var mSelectedAuction:Auction;
      
      private var mCardNamePanel:FSImage;
      
      private var mCardNameTextfield:FSTextfield;
      
      private var mCardHolderBG:FSImage;
      
      private var mCard:FSCardPreview;
      
      private var mBidsScrollContainer:ScrollContainer;
      
      private var mBidInfoBG:Quad;
      
      private var mAuctionRoundTextfield:FSTextfield;
      
      private var mAuctionTimeBG:FSImage;
      
      private var mClassifiedInfoTextfield:FSTextfield;
      
      private var mAuctionGoldInfoPanel:FSImage;
      
      private var mBidButton:FSButton;
      
      private var mAuctionGoldInfoTextfield:FSTextfield;
      
      private var mAuctionGoldIcon:FSImage;
      
      private var mIsBidPageSelected:Boolean;
      
      private var mAuctionTimeTextfield:FSTextfield;
      
      private var mIsFinishedSelectedAuction:Boolean;
      
      private var mAuctionWinAnimation:FSAuctionWinAnimation;
      
      private var mCurrentPage:int = 0;
      
      private var mSelectedAuctionLastHighestBid:FSNumber;
      
      private var mBidButtonTextfield:FSTextfield;
      
      private var mAuctionFilterButtonsContainer:ScrollContainer;
      
      protected var mActiveFilter:int = -1;
      
      private var mAuctionsPageNumberTextfield:FSTextfield;
      
      private var myAuctionsGetServerResponse:Boolean;
      
      private var mTimerAnimation:TimerAnimation;
      
      private var mTotalAuctionsInScroll:int;
      
      private var mTotalAuctionsInVecFilter:int;
      
      private var mRefreshTimeoutId:uint;
      
      private var mAuctionsCount:int;
      
      public function FSAuctionsScreen()
      {
         mNeedsLoadingBar = true;
         mBGName = Constants.AUCTIONS_BG_NAME;
         mScreenName = Constants.AUCTIONS_SCREEN_NAME;
         this.refreshServerTime();
         super();
      }
      
      public function refreshServerTime() : void
      {
         var _loc1_:Number = this.mSelectedAuction ? this.mSelectedAuction.getRoundEndTime() : -1;
         var _loc2_:Number = ServerConnection.smServerTimeMS;
         var _loc3_:Number = TimerUtil.msToSec(_loc1_ - _loc2_);
         var _loc4_:Boolean = _loc1_ != -1 && _loc3_ > 0 && _loc3_ < 15;
         var _loc5_:Number = _loc4_ ? 1000 : 10000;
         var _loc6_:Number = 10000;
         if(_loc1_ != -1 && _loc3_ > 0)
         {
            if(_loc3_ < 5)
            {
               _loc6_ = 1000;
            }
            else if(_loc3_ < 10)
            {
               _loc6_ = 2500;
            }
            else if(_loc3_ < 15)
            {
               _loc6_ = 5000;
            }
            else if(_loc3_ < 30)
            {
               _loc6_ = 10000;
            }
         }
         clearTimeout(this.mRefreshTimeoutId);
         this.mRefreshTimeoutId = setTimeout(this.refreshServerTime,_loc6_);
         InstanceMng.getServerConnection().refreshServerTime();
      }
      
      override protected function setResourcesToLoad() : void
      {
         super.setResourcesToLoad();
         InstanceMng.getResourcesMng().addResourcesFolderByName("customBGs");
         if(!Utils.isBrowser())
         {
            InstanceMng.getResourcesMng().addSpecialScreenResources("customBGs",null,FSResourceMng.PREFIX_TEXTURE);
         }
         if(Config.getConfig().useDeckBuilderThumbnails())
         {
            InstanceMng.getResourcesMng().addResourcesFolderByName("cards_thumbs");
         }
         if(Config.getConfig().gameHasTierFrames())
         {
            InstanceMng.getResourcesMng().addResourcesFolderByName("frames");
         }
         InstanceMng.getResourcesMng().addResourcesFolderByName("framesFactionsRarities");
         InstanceMng.getResourcesMng().addResourcesFolderByName("animTime");
         InstanceMng.getResourcesMng().addResourceToLoad("misc/firework",FSResourceMng.TYPE_AUDIO);
         InstanceMng.getResourcesMng().addResourceToLoad("misc/pre_firework",FSResourceMng.TYPE_AUDIO);
         if(Config.getConfig().cardsHaveCustomAuras())
         {
            InstanceMng.getResourcesMng().addResourcesFolderByName("anims/animAuras");
         }
         InstanceMng.getResourcesMng().loadAssets();
      }
      
      override public function notifyAssetsLoaded(param1:* = null) : void
      {
         super.notifyAssetsLoaded();
         this.createUI();
         this.createAuctionList();
         if(!InstanceMng.getUserDataMng().getOwnerUserData().flagsIsAuctionHouseFirstTimeVisited())
         {
            TweenMax.delayedCall(0.5,this.checkIfAHNewUser);
         }
      }
      
      private function checkIfAHNewUser() : void
      {
         InstanceMng.getPopupMng().openAuctionHouseNewUserPopup();
         InstanceMng.getUserDataMng().getOwnerUserData().setAuctionHouseFirstTime(true);
         InstanceMng.getUserDataMng().updateFlags();
      }
      
      private function createAuctionList() : void
      {
         this.setBidPageSelected(false);
         this.setMyAuctionsSelected(false);
         this.setAuctionListSelected(true);
         InstanceMng.getServerConnection().getActiveAuctions(this.mCurrentPage * AUCTIONS_BY_PAGE,AUCTIONS_BY_PAGE,this.onGetActiveAuctionsSuccess,null,this.onGetActiveAuctionsFail);
      }
      
      private function onGetActiveAuctionsSuccess(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Auction = null;
         var _loc4_:int = 0;
         if(Boolean(param1) && mScreenFullyLoaded)
         {
            InstanceMng.getCurrentScreen().showLoadingIcon(true,true,Align.CENTER,Align.CENTER,1,null,this);
            _loc2_ = param1.data as Array;
            this.mAuctionsCount = param1.count;
            _loc2_ = InstanceMng.getAuctionsMng().cleanAuctionsArrayByExistentInPlatform(_loc2_);
            this.mAuctionsInfoServerArr = _loc2_;
            if(this.mAuctionsInfoServerArr)
            {
               _loc4_ = 0;
               while(_loc4_ < this.mAuctionsInfoServerArr.length)
               {
                  _loc3_ = new Auction(_loc2_[_loc4_],_loc4_,false);
                  this.addAuctionToVec(_loc3_);
                  _loc4_++;
               }
            }
            InstanceMng.getCurrentScreen().showLoadingIcon(false,true);
            this.createAuctionSlotUI();
         }
         this.lockUI(false);
      }
      
      public function createAuction(param1:int) : void
      {
         var _loc2_:Auction = null;
         if(Boolean(this.mAuctionsInfoServerArr) && this.mAuctionsInfoServerArr.length > 0)
         {
            if(param1 < this.mAuctionsInfoServerArr.length)
            {
               _loc2_ = new Auction(this.mAuctionsInfoServerArr[param1],param1);
               this.addAuctionToVec(_loc2_);
            }
            else
            {
               InstanceMng.getCurrentScreen().showLoadingIcon(false,true);
               this.createAuctionSlotUI();
            }
         }
      }
      
      public function createAuctionSlotUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:FSAuctionSlot = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:FSAuctionSlot = null;
         var _loc6_:Boolean = false;
         var _loc7_:Quad = null;
         this.cleanScrollContainer(this.mAuctionsScrollContainer);
         if(Boolean(this.mAuctionsVec) && this.mAuctionsVec.length > 0)
         {
            this.mAuctionsVec = this.mAuctionsVec.sort(DictionaryUtils.sortAuctionsByTime);
            if(this.mMyAuctionsSelected)
            {
               _loc3_ = 0;
               _loc4_ = int(this.mAuctionsVec.length);
            }
            else
            {
               _loc3_ = 0;
               _loc4_ = AUCTIONS_BY_PAGE;
            }
            _loc1_ = _loc3_;
            while(_loc1_ < _loc4_)
            {
               if(this.mAuctionsVec.length > _loc1_ && this.filterAppliesToAuction(this.mActiveFilter,this.mAuctionsVec[_loc1_]) && this.mTotalAuctionsInScroll < 6)
               {
                  _loc5_ = new FSAuctionSlot(this.mAuctionsVec[_loc1_],this.mMyAuctionsSelected);
                  _loc6_ = InstanceMng.getUserDataMng().getOwnerUserData().getLastBidRoundInBiddersArr(_loc5_.getAuction().getAuctionId()) != -1;
                  if(_loc6_)
                  {
                     _loc2_ = _loc5_;
                  }
                  this.addAuctionToContainer(_loc5_);
               }
               _loc1_++;
            }
            this.addAuctionScrollContainerToStage();
            if(Boolean(_loc2_) && this.mAuctionListSelected)
            {
               _loc7_ = new Quad(_loc2_.width,_loc2_.height / 3.5);
               _loc7_.alpha = 0.0001;
               _loc7_.y = _loc2_.y + _loc2_.height;
               _loc2_.addChild(_loc7_);
               if(this.mAuctionsScrollContainer)
               {
                  this.mAuctionsScrollContainer.validate();
               }
            }
            this.updatePageNumberText();
         }
         InstanceMng.getCurrentScreen().showLoadingIcon(false,true);
         this.lockUI(false);
      }
      
      private function updatePageNumberText() : void
      {
         if(Boolean(this.mAuctionsPageNumberTextfield) && Boolean(this.mAuctionsVec))
         {
            this.mAuctionsPageNumberTextfield.text = Math.ceil(this.getEndIndexCurrentPage() / AUCTIONS_BY_PAGE) + "/" + this.getNumTotalPage();
         }
      }
      
      private function filterAppliesToAuction(param1:int, param2:Auction) : Boolean
      {
         var _loc3_:Boolean = false;
         switch(param1)
         {
            case AuctionsMng.AUCTION_FILTER_ALL:
               _loc3_ = true;
               break;
            case AuctionsMng.AUCTION_FILTER_GOLD:
               if(param2.getAuctionInfo() == AuctionsMng.AUCTION_INFO_AUCTION_LOST || param2.getAuctionInfo() == AuctionsMng.AUCTION_INFO_AUCTION_SOLD)
               {
                  _loc3_ = true;
               }
               break;
            case AuctionsMng.AUCTION_FILTER_LOSS:
               if(param2.getAuctionInfo() == AuctionsMng.AUCTION_INFO_CARD_NOT_SOLD)
               {
                  _loc3_ = true;
               }
               break;
            case AuctionsMng.AUCTION_FILTER_PLACED:
               if(param2.getAuctionInfo() == AuctionsMng.AUCTION_INFO_ACTIVE)
               {
                  _loc3_ = true;
               }
               break;
            case AuctionsMng.AUCTION_FILTER_WON:
               if(param2.getAuctionInfo() == AuctionsMng.AUCTION_INFO_CARD_WON)
               {
                  _loc3_ = true;
               }
               break;
            default:
               _loc3_ = true;
         }
         return _loc3_;
      }
      
      private function onGetActiveAuctionsFail() : void
      {
         Utils.setLogText(TextManager.getText("TID_GEN_SERVER_NO_CONNECT"));
      }
      
      private function createUI() : void
      {
         if(!isFullyLoaded())
         {
            return;
         }
         this.createGoldVisor();
         this.createAuctionTicketsVisor();
         this.createAuctionManagerButtons();
         this.createTitlesBG();
         this.createTitles();
         this.createPaginatorButtons();
         this.createInfoButton();
         reAddUIVisualsOptions();
      }
      
      private function createAuctionManagerButtons() : void
      {
         this.createAuctionListButton();
         this.createMyAuctionsButton();
      }
      
      private function createInfoButton() : void
      {
         if(this.mInfoButton == null)
         {
            this.mInfoButton = new FSButton(Root.assets.getTexture("guild_info_button"));
            this.mInfoButton.x = this.mInfoButton.width + 10;
            this.mInfoButton.y = this.mPrevPageButton.y;
            this.mInfoButton.scaleWhenDown = 1;
            this.mInfoButton.enableScaleOnMouseOver(false);
            this.mInfoButton.scale = 0.75;
            this.mInfoButton.setTooltipText(TextManager.getText("TID_AUCTION_CREATE_INFO",true));
            addChild(this.mInfoButton);
         }
      }
      
      private function createMyAuctionsButton() : void
      {
         if(Boolean(this.mAuctionListButton) && this.mMyAuctionsButton == null)
         {
            this.mMyAuctionsButton = new FSButton(Root.assets.getTexture(UNSELECTED_BUTTON_TEXTURE));
            this.mMyAuctionsButton.name = "myAuctions";
            this.mMyAuctionsButton.x = this.mAuctionListButton.x + this.mAuctionListButton.width * 0.6;
            this.mMyAuctionsButton.y = this.mAuctionListButton.y;
            this.mMyAuctionsButton.addEventListener(TouchEvent.TOUCH,this.onMyAuctionsTouch);
            if(Boolean(this.mMyAuctionsButton) && this.mMyAuctionsIcon == null)
            {
               this.mMyAuctionsIcon = new FSImage(Root.assets.getTexture("icon_auction_manage"));
               this.mMyAuctionsIcon.x = this.mMyAuctionsIcon.width * 0.5;
               this.mMyAuctionsButton.addChild(this.mMyAuctionsIcon);
            }
            if(Boolean(this.mMyAuctionsButton) && Boolean(this.mMyAuctionsIcon) && this.mMyAuctionsTextfield == null)
            {
               this.mMyAuctionsTextfield = new FSTextfield(this.mMyAuctionsButton.width * 0.7,this.mMyAuctionsButton.height * 0.5,TextManager.getText("TID_GEN_MANAGE"));
               this.mMyAuctionsTextfield.alignPivot();
               this.mMyAuctionsTextfield.visible = false;
               this.mMyAuctionsTextfield.x = this.mMyAuctionsIcon.x + this.mMyAuctionsIcon.width * 1.02 + this.mMyAuctionsTextfield.width / 2;
               this.mMyAuctionsTextfield.y = this.mMyAuctionsIcon.y + this.mMyAuctionsIcon.height / 2;
               this.mMyAuctionsButton.addChild(this.mMyAuctionsTextfield);
            }
            addChild(this.mMyAuctionsButton);
            addChild(this.mAuctionListButton);
         }
      }
      
      private function createAuctionListButton() : void
      {
         if(this.mAuctionListButton == null)
         {
            this.mAuctionListButton = new FSButton(Root.assets.getTexture(SELECTED_BUTTON_TEXTURE));
            this.mAuctionListButton.name = "auctionList";
            this.mAuctionListButton.x = this.mAuctionListButton.width * 0.4;
            this.mAuctionListButton.y = this.mAuctionListButton.height / 2;
            this.mAuctionListButton.addEventListener(TouchEvent.TOUCH,this.onAuctionListTouch);
            if(Boolean(this.mAuctionListButton) && this.mAuctionListIcon == null)
            {
               this.mAuctionListIcon = new FSImage(Root.assets.getTexture("icon_auction_list"));
               this.mAuctionListIcon.x = this.mAuctionListIcon.width * 0.5;
               this.mAuctionListButton.addChild(this.mAuctionListIcon);
            }
            if(Boolean(this.mAuctionListButton) && Boolean(this.mAuctionListIcon) && this.mAuctionListTextfield == null)
            {
               this.mAuctionListTextfield = new FSTextfield(this.mAuctionListButton.width * 0.4,this.mAuctionListButton.height * 0.4,TextManager.getText("TID_AUCTIONS_AUCTIONS"));
               this.mAuctionListTextfield.alignPivot();
               this.mAuctionListTextfield.x = this.mAuctionListIcon.x + this.mAuctionListIcon.width * 1.05 + this.mAuctionListTextfield.width / 2;
               this.mAuctionListTextfield.y = this.mAuctionListIcon.y + this.mAuctionListIcon.height / 2;
               this.mAuctionListButton.addChild(this.mAuctionListTextfield);
            }
         }
      }
      
      private function unselectAndReadjustButton(param1:String) : void
      {
         switch(param1)
         {
            case "auctionList":
               this.mAuctionListSelected = false;
               this.mAuctionListTextfield.visible = false;
               this.mAuctionListButton.upState = Root.assets.getTexture(UNSELECTED_BUTTON_TEXTURE);
               this.mAuctionListButton.readjustSize();
               break;
            case "myAuctions":
               this.mMyAuctionsSelected = false;
               this.mMyAuctionsTextfield.visible = false;
               this.mMyAuctionsButton.upState = Root.assets.getTexture(UNSELECTED_BUTTON_TEXTURE);
               this.mMyAuctionsButton.readjustSize();
         }
      }
      
      private function selectAndReadjustButton(param1:String) : void
      {
         switch(param1)
         {
            case "auctionList":
               this.mAuctionListSelected = true;
               this.mAuctionListButton.upState = Root.assets.getTexture(SELECTED_BUTTON_TEXTURE);
               this.mAuctionListTextfield.visible = true;
               this.mAuctionListButton.readjustSize();
               break;
            case "myAuctions":
               this.mMyAuctionsSelected = true;
               this.mMyAuctionsButton.upState = Root.assets.getTexture(SELECTED_BUTTON_TEXTURE);
               this.mMyAuctionsTextfield.visible = true;
               this.mMyAuctionsButton.readjustSize();
         }
      }
      
      private function onMyAuctionsTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1 ? param1.getTouch(this.mMyAuctionsButton,TouchPhase.ENDED) : null;
         if(_loc2_)
         {
            this.lockUI(true);
            if(!this.mMyAuctionsSelected)
            {
               if(this.mAuctionListSelected || this.mIsBidPageSelected)
               {
                  this.unselectAndReadjustButton(this.mAuctionListButton.name);
                  this.selectAndReadjustButton(this.mMyAuctionsButton.name);
               }
               this.mMyAuctionsButton.x = this.mAuctionListButton.x + this.mAuctionListButton.width * 0.3;
            }
            this.mCurrentPage = 0;
            this.cleanAuctionList();
            this.cleanBidPage();
            this.cleanAuctionsInfo(this.getAuctionServerInfo);
            this.createMyAuctionPage();
         }
      }
      
      public function createMyAuctionPage() : void
      {
         var _loc1_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         this.setBidPageSelected(false);
         this.setAuctionListSelected(false);
         this.setMyAuctionsSelected(true);
         this.createFilterButtons();
         reAddUIVisualsOptions();
         var _loc2_:UserData = Utils.getOwnerUserData();
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
            _loc4_ = new Array();
            _loc3_ = 0;
            while(_loc3_ < _loc1_.length)
            {
               if(_loc1_[_loc3_] != "" && _loc1_[_loc3_] != "undefined")
               {
                  _loc4_[_loc4_.length] = _loc1_[_loc3_];
               }
               _loc3_++;
            }
            InstanceMng.getCurrentScreen().showLoadingIcon(true,true,Align.CENTER,Align.CENTER,1,null,this);
            InstanceMng.getServerConnection().getAuctionInfoByAuctionIdArray(_loc4_,this.onGetAuctionInfoByArraySuccess,this.onGetAuctionInfoByArrayFail);
            this.myAuctionsGetServerResponse = false;
            TweenMax.delayedCall(5,this.onMyAuctionsNotResponse);
         }
         else
         {
            this.lockUI(false);
         }
      }
      
      private function onMyAuctionsNotResponse() : void
      {
         if(!this.myAuctionsGetServerResponse)
         {
            this.lockUI(false);
            Utils.setLogText(TextManager.getText("TID_GEN_SERVER_RETRY"),true);
         }
      }
      
      private function createFilterButtons() : void
      {
         var _loc1_:HorizontalLayout = null;
         var _loc2_:SubcategoryToggleButton = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         if(Boolean(mBGSprite) && this.mAuctionFilterButtonsContainer == null)
         {
            this.mAuctionFilterButtonsContainer = new ScrollContainer();
            _loc1_ = new HorizontalLayout();
            _loc1_.gap = mBGSprite.width / 10;
            this.mAuctionFilterButtonsContainer.layout = _loc1_;
            this.mAuctionFilterButtonsContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
            this.mAuctionFilterButtonsContainer.verticalScrollPolicy = ScrollPolicy.OFF;
            this.mAuctionFilterButtonsContainer.x = mBGSprite.width * 0.05;
            this.mAuctionFilterButtonsContainer.y = mBGSprite.height * 0.12;
            addChild(this.mAuctionFilterButtonsContainer);
            _loc2_ = new SubcategoryToggleButton("auction_filter_all_off","auction_filter_all_on");
            _loc2_.setTooltipText(TextManager.getText("TID_AUCTIONS_INFO_ALL"));
            _loc2_.name = "all";
            this.mAuctionFilterButtonsContainer.addChild(_loc2_);
            _loc2_.addEventListener(TouchEvent.TOUCH,this.onAuctionFilterToggleTouch);
            this.mActiveFilter = -1;
            _loc3_ = 0;
            while(_loc3_ < 4)
            {
               if(_loc3_ == 0)
               {
                  _loc4_ = "auction_filter_gold_off";
                  _loc5_ = "auction_filter_gold_on";
                  _loc6_ = TextManager.getText("TID_AUCTIONS_INFO_GOLD");
               }
               else if(_loc3_ == 1)
               {
                  _loc4_ = "auction_filter_loss_off";
                  _loc5_ = "auction_filter_loss_on";
                  _loc6_ = TextManager.getText("TID_AUCTIONS_INFO_LOST");
               }
               else if(_loc3_ == 2)
               {
                  _loc4_ = "auction_filter_placed_off";
                  _loc5_ = "auction_filter_placed_on";
                  _loc6_ = TextManager.getText("TID_AUCTIONS_INFO_PROGRESS");
               }
               else if(_loc3_ == 3)
               {
                  _loc4_ = "auction_filter_won_off";
                  _loc5_ = "auction_filter_won_on";
                  _loc6_ = TextManager.getText("TID_AUCTIONS_INFO_WON");
               }
               _loc2_ = new SubcategoryToggleButton(_loc4_,_loc5_);
               _loc2_.setTooltipText(_loc6_);
               _loc2_.name = _loc3_.toString();
               this.mAuctionFilterButtonsContainer.addChild(_loc2_);
               _loc2_.addEventListener(TouchEvent.TOUCH,this.onAuctionFilterToggleTouch);
               _loc3_++;
            }
         }
      }
      
      private function onAuctionFilterToggleTouch(param1:TouchEvent) : void
      {
         var _loc3_:FSToggleButton = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc2_:Touch = param1.getTouch(this,TouchPhase.ENDED);
         if(_loc2_)
         {
            if(!Root.assets.isLoading)
            {
               _loc3_ = FSToggleButton(param1.currentTarget);
               _loc4_ = _loc3_.name;
               if(_loc4_ != "" || _loc4_ != null)
               {
                  if(_loc4_ == "all")
                  {
                     this.mActiveFilter = -1;
                     if(!_loc3_.isToggled())
                     {
                        _loc3_.setToggled();
                        return;
                     }
                     if(this.mAuctionFilterButtonsContainer)
                     {
                        _loc5_ = 0;
                        while(_loc5_ < this.mAuctionFilterButtonsContainer.numChildren)
                        {
                           _loc3_ = FSToggleButton(this.mAuctionFilterButtonsContainer.getChildAt(_loc5_));
                           if(Boolean(_loc3_) && !_loc3_.isToggled())
                           {
                              _loc3_.setToggled();
                           }
                           _loc5_++;
                        }
                     }
                  }
                  else
                  {
                     this.mActiveFilter = int(_loc3_.name);
                     if(_loc3_.name == _loc4_ && !_loc3_.isToggled())
                     {
                        _loc3_.setToggled();
                     }
                     _loc5_ = 0;
                     while(_loc5_ < this.mAuctionFilterButtonsContainer.numChildren)
                     {
                        _loc3_ = FSToggleButton(this.mAuctionFilterButtonsContainer.getChildAt(_loc5_));
                        if(Boolean(_loc3_) && Boolean(_loc3_.name != _loc4_) && _loc3_.isToggled())
                        {
                           _loc3_.setToggled();
                        }
                        _loc5_++;
                     }
                  }
               }
               this.mCurrentPage = 0;
               this.cleanScrollContainer(this.getAuctionScrollContainer(),this.createAuctionSlotUI);
            }
         }
      }
      
      private function onGetAuctionInfoByArrayFail() : void
      {
         this.myAuctionsGetServerResponse = true;
         TweenMax.delayedCall(3,this.createMyAuctionPage);
         InstanceMng.getCurrentScreen().showLoadingIcon(false,true);
      }
      
      private function onGetAuctionInfoByArraySuccess(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:Auction = null;
         this.myAuctionsGetServerResponse = true;
         if(InstanceMng.getCurrentScreen() is FSAuctionsScreen && InstanceMng.getCurrentScreen().isFullyLoaded())
         {
            if(param1)
            {
               _loc2_ = param1 as Array;
               _loc2_ = InstanceMng.getAuctionsMng().cleanAuctionsArrayByExistentInPlatform(_loc2_);
               if(Boolean(_loc2_) && _loc2_.length > 0)
               {
                  this.mAuctionsInfoServerArr = _loc2_;
                  _loc3_ = 0;
                  while(_loc3_ < this.mAuctionsInfoServerArr.length)
                  {
                     _loc4_ = new Auction(_loc2_[_loc3_],_loc3_,false);
                     this.addAuctionToVec(_loc4_);
                     _loc3_++;
                  }
                  this.createAuctionSlotUI();
               }
            }
            InstanceMng.getCurrentScreen().showLoadingIcon(false,true);
            this.lockUI(false);
         }
      }
      
      private function onAuctionListTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1 ? param1.getTouch(this.mAuctionListButton,TouchPhase.ENDED) : null;
         if(_loc2_)
         {
            this.refreshAuctionsList();
         }
      }
      
      private function refreshAuctionsList() : void
      {
         this.lockUI(true);
         if(!this.mAuctionListSelected)
         {
            if(this.mMyAuctionsSelected || this.mAuctionListIcon.texture == Root.assets.getTexture("icon_back"))
            {
               this.unselectAndReadjustButton(this.mMyAuctionsButton.name);
               this.selectAndReadjustButton(this.mAuctionListButton.name);
            }
            else if(this.mIsBidPageSelected)
            {
               this.setAuctionListSelected(true);
            }
            this.mMyAuctionsButton.x = this.mAuctionListButton.x + this.mAuctionListButton.width * 0.6;
         }
         this.cleanBidPage();
         this.cleanAuctionsInfo(this.getAuctionServerInfo);
         this.cleanMyAuctions();
         this.cleanAuctionList();
         this.createUI();
         this.createAuctionList();
         InstanceMng.getServerConnection().refreshServerTime();
      }
      
      private function cleanMyAuctions() : void
      {
         if(this.mAuctionFilterButtonsContainer)
         {
            this.cleanScrollContainer(this.mAuctionFilterButtonsContainer);
            this.mAuctionFilterButtonsContainer.removeFromParent();
            this.mAuctionFilterButtonsContainer = null;
         }
         this.mActiveFilter = -1;
      }
      
      private function cleanBidPage() : void
      {
         TweenMax.killDelayedCallsTo(this.checkAuctionInfo);
         if(this.mCardNamePanel)
         {
            this.mCardNamePanel.removeFromParent();
            this.mCardNamePanel = null;
         }
         if(this.mCardNameTextfield)
         {
            this.mCardNameTextfield.removeFromParent();
            this.mCardNameTextfield = null;
         }
         if(this.mCardHolderBG)
         {
            this.mCardHolderBG.removeFromParent();
            this.mCardHolderBG = null;
         }
         if(this.mCard)
         {
            InstanceMng.getResourcesMng().disposeCardBGByCardDef(this.mCard.getCardDef());
            this.mCard.removeFromParent();
            this.mCard = null;
         }
         if(this.mBidsScrollContainer)
         {
            this.mBidsScrollContainer.removeFromParent();
            this.mBidsScrollContainer = null;
         }
         if(this.mBidInfoBG)
         {
            this.mBidInfoBG.removeFromParent();
            this.mBidInfoBG = null;
         }
         if(this.mAuctionRoundTextfield)
         {
            this.mAuctionRoundTextfield.removeFromParent();
            this.mAuctionRoundTextfield = null;
         }
         if(this.mAuctionTimeBG)
         {
            this.mAuctionTimeBG.removeFromParent();
            this.mAuctionTimeBG = null;
         }
         if(this.mClassifiedInfoTextfield)
         {
            this.mClassifiedInfoTextfield.removeFromParent();
            this.mClassifiedInfoTextfield = null;
         }
         if(this.mAuctionGoldInfoPanel)
         {
            this.mAuctionGoldInfoPanel.removeFromParent();
            this.mAuctionGoldInfoPanel = null;
         }
         if(this.mBidButton)
         {
            this.mBidButton.removeFromParent();
            this.mBidButton = null;
         }
         if(this.mBidButtonTextfield)
         {
            this.mBidButtonTextfield.removeFromParent();
            this.mBidButtonTextfield = null;
         }
         if(this.mAuctionGoldInfoTextfield)
         {
            this.mAuctionGoldInfoTextfield.removeFromParent();
            this.mAuctionGoldInfoTextfield = null;
         }
         if(this.mAuctionGoldIcon)
         {
            this.mAuctionGoldIcon.removeFromParent();
            this.mAuctionGoldIcon = null;
         }
         if(this.mAuctionTimeTextfield)
         {
            this.mAuctionTimeTextfield.removeFromParent();
            this.mAuctionTimeTextfield = null;
         }
         if(this.mTimerAnimation)
         {
            this.mTimerAnimation.removeFromParent();
            this.mTimerAnimation = null;
         }
         this.mSelectedAuction = null;
         this.mIsFinishedSelectedAuction = false;
         this.cleanScrollContainer(this.mBidsScrollContainer,this.onBidPageCleanComplete);
      }
      
      private function onBidPageCleanComplete() : void
      {
         this.updateAuctionListButton();
      }
      
      private function createTitles() : void
      {
         this.createCategoryColumnTitle();
         this.createNameColumnTitle();
         this.createRarityColumnTitle();
         this.createValueColumnTitle();
         this.createValueColumnTitleImg();
         this.createTimeColumnTitle();
         this.createTimeColumnTitleImg();
      }
      
      private function createAuctionTicketsVisor(param1:Boolean = true) : void
      {
         if(Boolean(this.mGoldVisor) && this.mAuctionTicketsVisor == null)
         {
            this.mAuctionTicketsVisor = new FSAuctionTicketsVisor("auction_button_currency","",param1);
            this.mAuctionTicketsVisor.x = this.mGoldVisor.x - this.mAuctionTicketsVisor.width;
            this.mAuctionTicketsVisor.y = this.mGoldVisor.y;
            addChild(this.mAuctionTicketsVisor);
         }
      }
      
      private function createGoldVisor(param1:Boolean = true) : void
      {
         if(Boolean(mBackButton) && this.mGoldVisor == null)
         {
            this.mGoldVisor = new FSGoldVisor("auction_button_gold","",param1);
            this.mGoldVisor.x = mBackButton.x - mBackButton.width * 2;
            this.mGoldVisor.y = mBackButton.y;
            addChild(this.mGoldVisor);
         }
      }
      
      private function createTimeColumnTitleImg() : void
      {
         if(Boolean(this.mTitlesBG) && Boolean(this.mTimeColumnTitle) && this.mTimeColumnTitleImg == null)
         {
            this.mTimeColumnTitleImg = new FSImage(Root.assets.getTexture("auction_time_icon"));
            this.mTimeColumnTitleImg.alignPivot();
            this.mTimeColumnTitleImg.x = this.mTimeColumnTitle.x + this.mTimeColumnTitle.width / 2 + this.mTimeColumnTitleImg.width / 2;
            this.mTimeColumnTitleImg.y = this.mTimeColumnTitle.y;
            addChild(this.mTimeColumnTitleImg);
         }
      }
      
      private function createTimeColumnTitle() : void
      {
         if(Boolean(this.mTitlesBG) && Boolean(this.mValueTitleImg) && this.mTimeColumnTitle == null)
         {
            this.mTimeColumnTitle = new FSTextfield(this.mTitlesBG.width / 7,this.mTitlesBG.height,TextManager.getText("TID_AUCTIONS_DEADLINE"));
            this.mTimeColumnTitle.alignPivot();
            this.mTimeColumnTitle.x = this.mValueTitleImg.x + this.mValueTitleImg.width + this.mTimeColumnTitle.width / 2;
            this.mTimeColumnTitle.y = this.mValueTitleImg.y;
            addChild(this.mTimeColumnTitle);
         }
      }
      
      private function createValueColumnTitleImg() : void
      {
         if(Boolean(this.mTitlesBG) && Boolean(this.mValueColumnTitle) && this.mValueTitleImg == null)
         {
            this.mValueTitleImg = new FSImage(Root.assets.getTexture("auction_gold_icon"));
            this.mValueTitleImg.alignPivot();
            this.mValueTitleImg.x = this.mValueColumnTitle.x + this.mValueColumnTitle.width / 2 + this.mValueTitleImg.width / 2;
            this.mValueTitleImg.y = this.mValueColumnTitle.y;
            addChild(this.mValueTitleImg);
         }
      }
      
      private function createValueColumnTitle() : void
      {
         if(Boolean(this.mTitlesBG) && Boolean(this.mRarityColumnTitleImg) && this.mValueColumnTitle == null)
         {
            this.mValueColumnTitle = new FSTextfield(this.mTitlesBG.width / 7,this.mTitlesBG.height,TextManager.getText("TID_AUCTIONS_MIN_COST"));
            this.mValueColumnTitle.alignPivot();
            this.mValueColumnTitle.x = this.mRarityColumnTitleImg.x + this.mRarityColumnTitleImg.width + this.mValueColumnTitle.width;
            this.mValueColumnTitle.y = this.mRarityColumnTitleImg.y;
            addChild(this.mValueColumnTitle);
         }
      }
      
      private function createRarityColumnTitle() : void
      {
         if(Boolean(this.mTitlesBG) && Boolean(this.mNameColumnTitle) && this.mRarityColumnTitleImg == null)
         {
            this.mRarityColumnTitleImg = new FSImage(Root.assets.getTexture("auction_rarity_icon"));
            this.mRarityColumnTitleImg.alignPivot();
            this.mRarityColumnTitleImg.x = this.mNameColumnTitle.x + this.mNameColumnTitle.width + this.mRarityColumnTitleImg.width;
            this.mRarityColumnTitleImg.y = this.mNameColumnTitle.y;
            addChild(this.mRarityColumnTitleImg);
         }
      }
      
      private function createNameColumnTitle() : void
      {
         if(Boolean(this.mTitlesBG) && Boolean(this.mCategoryColumnTitleImg) && this.mNameColumnTitle == null)
         {
            this.mNameColumnTitle = new FSTextfield(this.mTitlesBG.width / 7,this.mTitlesBG.height,TextManager.getText("TID_GEN_CARD"));
            this.mNameColumnTitle.alignPivot();
            this.mNameColumnTitle.x = this.mCategoryColumnTitleImg.x + this.mNameColumnTitle.width;
            this.mNameColumnTitle.y = this.mCategoryColumnTitleImg.y;
            addChild(this.mNameColumnTitle);
         }
      }
      
      private function createCategoryColumnTitle() : void
      {
         if(Boolean(this.mTitlesBG) && this.mCategoryColumnTitleImg == null)
         {
            this.mCategoryColumnTitleImg = new FSImage(Root.assets.getTexture("auction_category_icon"));
            this.mCategoryColumnTitleImg.alignPivot();
            this.mCategoryColumnTitleImg.x = this.mTitlesBG.width / 8 - this.mCategoryColumnTitleImg.width;
            this.mCategoryColumnTitleImg.y = this.mTitlesBG.height + this.mCategoryColumnTitleImg.height * 1.2;
            addChild(this.mCategoryColumnTitleImg);
         }
      }
      
      private function createBidInfoBG() : void
      {
         if(this.mBidInfoBG == null)
         {
            this.mBidInfoBG = new Quad(mBGSprite.width,mBGSprite.height * 0.35,0);
            this.mBidInfoBG.x = 0;
            this.mBidInfoBG.y = mBGSprite.height * 0.65;
            this.mBidInfoBG.alpha = 0.3;
            addChild(this.mBidInfoBG);
            reAddUIVisualsOptions();
         }
      }
      
      private function createTitlesBG() : void
      {
         if(this.mTitlesBG == null && Boolean(mBGSprite))
         {
            this.mTitlesBG = new Quad(mBGSprite.width,mBGSprite.height * 0.08,0);
            this.mTitlesBG.x = 0;
            this.mTitlesBG.y = mBGSprite.height * 0.12;
            this.mTitlesBG.alpha = 0.5;
            addChild(this.mTitlesBG);
         }
      }
      
      public function showMap() : void
      {
         dispatchEventWith(Screen.GO_TO_MAP,true);
      }
      
      private function createPaginatorButtons() : void
      {
         this.createNextPageButton();
         this.createPrevPageButton();
         this.createPageNumberText();
      }
      
      private function createPageNumberText() : void
      {
         if(Boolean(this.mPrevPageButton) && this.mAuctionsPageNumberTextfield == null)
         {
            this.mAuctionsPageNumberTextfield = new FSTextfield(this.mPrevPageButton.width * 0.3,this.mPrevPageButton.height * 0.6,"");
            this.mAuctionsPageNumberTextfield.x = mBGSprite.width / 2 - this.mAuctionsPageNumberTextfield.width / 2;
            this.mAuctionsPageNumberTextfield.y = this.mPrevPageButton.y - this.mAuctionsPageNumberTextfield.height * 0.3;
            addChild(this.mAuctionsPageNumberTextfield);
         }
      }
      
      private function createPrevPageButton() : void
      {
         if(mBGSprite)
         {
            if(this.mPrevPageButton == null)
            {
               this.mPrevPageButton = new FSButton(Root.assets.getTexture("auction_button_left"));
               this.mPrevPageButton.x = this.mPrevPageButton.width;
               this.mPrevPageButton.y = mBGSprite.height - this.mPrevPageButton.height * 0.45;
               this.mPrevPageButton.addEventListener(Event.TRIGGERED,this.prevPageButtonTriggered);
               addChild(this.mPrevPageButton);
            }
         }
      }
      
      private function prevPageButtonTriggered() : void
      {
         if(this.mCurrentPage > 0)
         {
            --this.mCurrentPage;
            if(this.mAuctionsVec)
            {
               this.mAuctionsVec.length = 0;
               this.mAuctionsVec = null;
            }
            if(this.mAuctionsInfoServerArr)
            {
               this.mAuctionsInfoServerArr.length = 0;
               this.mAuctionsInfoServerArr = null;
            }
            InstanceMng.getServerConnection().getActiveAuctions(this.mCurrentPage * AUCTIONS_BY_PAGE,AUCTIONS_BY_PAGE,this.onGetActiveAuctionsSuccess,null,this.onGetActiveAuctionsFail);
         }
      }
      
      private function createNextPageButton() : void
      {
         if(mBGSprite)
         {
            if(this.mNextPageButton == null)
            {
               this.mNextPageButton = new FSButton(Root.assets.getTexture("auction_button_right"));
               this.mNextPageButton.x = mBGSprite.width - this.mNextPageButton.width;
               this.mNextPageButton.y = mBGSprite.height - this.mNextPageButton.height * 0.45;
               this.mNextPageButton.addEventListener(Event.TRIGGERED,this.nextPageButtonTriggered);
               addChild(this.mNextPageButton);
            }
         }
      }
      
      private function nextPageButtonTriggered() : void
      {
         if(this.mCurrentPage < this.mAuctionsCount / AUCTIONS_BY_PAGE - 1)
         {
            this.mCurrentPage += 1;
            if(this.mAuctionsVec)
            {
               this.mAuctionsVec.length = 0;
               this.mAuctionsVec = null;
            }
            if(this.mAuctionsInfoServerArr)
            {
               this.mAuctionsInfoServerArr.length = 0;
               this.mAuctionsInfoServerArr = null;
            }
            InstanceMng.getServerConnection().getActiveAuctions(this.mCurrentPage * AUCTIONS_BY_PAGE,AUCTIONS_BY_PAGE,this.onGetActiveAuctionsSuccess,null,this.onGetActiveAuctionsFail);
         }
      }
      
      private function createAuctionsScrollContainer() : void
      {
         if(Boolean(this.mAuctionListButton) && this.mAuctionsScrollContainer == null)
         {
            this.mAuctionsScrollContainer = new ScrollContainer();
            this.mAuctionsScrollContainer.layout = this.getContainerLayout();
            this.mAuctionsScrollContainer.height = mBGSprite.height * 0.7;
         }
      }
      
      private function getContainerLayout() : VerticalLayout
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.horizontalAlign = HorizontalAlign.CENTER;
         return _loc1_;
      }
      
      private function addAuctionToContainer(param1:FSAuctionSlot) : void
      {
         if(param1)
         {
            this.createAuctionsScrollContainer();
            if(this.mAuctionsScrollContainer)
            {
               this.mAuctionsScrollContainer.addChild(param1);
            }
         }
      }
      
      public function setSelectedAuction(param1:Auction) : void
      {
         this.mSelectedAuction = param1;
      }
      
      override public function unload() : void
      {
         clearTimeout(this.mRefreshTimeoutId);
         if(this.mNextPageButton)
         {
            this.mNextPageButton.removeFromParent(true);
            this.mNextPageButton = null;
         }
         if(this.mPrevPageButton)
         {
            this.mPrevPageButton.removeFromParent(true);
            this.mPrevPageButton = null;
         }
         if(this.mAuctionsPageNumberTextfield)
         {
            this.mAuctionsPageNumberTextfield.removeFromParent(true);
            this.mAuctionsPageNumberTextfield = null;
         }
         if(this.mTitlesBG)
         {
            this.mTitlesBG.removeFromParent(true);
            this.mTitlesBG = null;
         }
         if(this.mCategoryColumnTitleImg)
         {
            this.mCategoryColumnTitleImg.removeFromParent(true);
            this.mCategoryColumnTitleImg = null;
         }
         if(this.mNameColumnTitle)
         {
            this.mNameColumnTitle.removeFromParent(true);
            this.mNameColumnTitle = null;
         }
         if(this.mRarityColumnTitleImg)
         {
            this.mRarityColumnTitleImg.removeFromParent(true);
            this.mRarityColumnTitleImg = null;
         }
         if(this.mValueColumnTitle)
         {
            this.mValueColumnTitle.removeFromParent(true);
            this.mValueColumnTitle = null;
         }
         if(this.mValueTitleImg)
         {
            this.mValueTitleImg.removeFromParent(true);
            this.mValueTitleImg = null;
         }
         if(this.mTimeColumnTitle)
         {
            this.mTimeColumnTitle.removeFromParent(true);
            this.mTimeColumnTitle = null;
         }
         if(this.mTimeColumnTitleImg)
         {
            this.mTimeColumnTitleImg.removeFromParent(true);
            this.mTimeColumnTitleImg = null;
         }
         if(this.mGoldVisor)
         {
            this.mGoldVisor.removeFromParent(true);
            this.mGoldVisor = null;
         }
         if(this.mAuctionTicketsVisor)
         {
            this.mAuctionTicketsVisor.removeFromParent(true);
            this.mAuctionTicketsVisor = null;
         }
         if(this.mAuctionListButton)
         {
            this.mAuctionListButton.removeFromParent(true);
            this.mAuctionListButton = null;
         }
         if(this.mAuctionListIcon)
         {
            this.mAuctionListIcon.removeFromParent(true);
            this.mAuctionListIcon = null;
         }
         if(this.mAuctionListTextfield)
         {
            this.mAuctionListTextfield.removeFromParent(true);
            this.mAuctionListTextfield = null;
         }
         if(this.mMyAuctionsButton)
         {
            this.mMyAuctionsButton.removeFromParent(true);
            this.mMyAuctionsButton = null;
         }
         if(this.mMyAuctionsIcon)
         {
            this.mMyAuctionsIcon.removeFromParent(true);
            this.mMyAuctionsIcon = null;
         }
         if(this.mMyAuctionsTextfield)
         {
            this.mMyAuctionsTextfield.removeFromParent(true);
            this.mMyAuctionsTextfield = null;
         }
         if(this.mAuctionsScrollContainer)
         {
            this.cleanScrollContainer(this.mAuctionsScrollContainer);
            this.mAuctionsScrollContainer.removeFromParent(true);
            this.mAuctionsScrollContainer = null;
         }
         if(this.mCardNamePanel)
         {
            this.mCardNamePanel.removeFromParent(true);
            this.mCardNamePanel = null;
         }
         if(this.mCardNameTextfield)
         {
            this.mCardNameTextfield.removeFromParent(true);
            this.mCardNameTextfield = null;
         }
         if(this.mCardHolderBG)
         {
            this.mCardHolderBG.removeFromParent(true);
            this.mCardHolderBG = null;
         }
         if(this.mCard)
         {
            InstanceMng.getResourcesMng().disposeCardBGByCardDef(this.mCard.getCardDef());
            this.mCard.removeFromParent(true);
            this.mCard = null;
         }
         if(this.mBidsScrollContainer)
         {
            this.cleanScrollContainer(this.mBidsScrollContainer);
            this.mBidsScrollContainer.removeFromParent(true);
            this.mBidsScrollContainer = null;
         }
         if(this.mBidInfoBG)
         {
            this.mBidInfoBG.removeFromParent(true);
            this.mBidInfoBG = null;
         }
         if(this.mAuctionRoundTextfield)
         {
            this.mAuctionRoundTextfield.removeFromParent(true);
            this.mAuctionRoundTextfield = null;
         }
         if(this.mAuctionTimeBG)
         {
            this.mAuctionTimeBG.removeFromParent(true);
            this.mAuctionTimeBG = null;
         }
         if(this.mClassifiedInfoTextfield)
         {
            this.mClassifiedInfoTextfield.removeFromParent(true);
            this.mClassifiedInfoTextfield = null;
         }
         if(this.mAuctionGoldInfoPanel)
         {
            this.mAuctionGoldInfoPanel.removeFromParent(true);
            this.mAuctionGoldInfoPanel = null;
         }
         if(this.mBidButton)
         {
            this.mBidButton.removeFromParent(true);
            this.mBidButton = null;
         }
         if(this.mBidButtonTextfield)
         {
            this.mBidButtonTextfield.removeFromParent(true);
            this.mBidButtonTextfield = null;
         }
         if(this.mAuctionGoldInfoTextfield)
         {
            this.mAuctionGoldInfoTextfield.removeFromParent(true);
            this.mAuctionGoldInfoTextfield = null;
         }
         if(this.mAuctionGoldIcon)
         {
            this.mAuctionGoldIcon.removeFromParent(true);
            this.mAuctionGoldIcon = null;
         }
         if(this.mAuctionTimeTextfield)
         {
            this.mAuctionTimeTextfield.removeFromParent(true);
            this.mAuctionTimeTextfield = null;
         }
         if(this.mSelectedAuction)
         {
            this.mSelectedAuction = null;
         }
         if(this.mAuctionWinAnimation)
         {
            this.mAuctionWinAnimation.removeFromParent(true);
            this.mAuctionWinAnimation = null;
         }
         if(this.mTimerAnimation)
         {
            this.mTimerAnimation.removeFromParent(true);
            this.mTimerAnimation = null;
         }
         if(this.mAuctionsInfoServerArr)
         {
            this.mAuctionsInfoServerArr.length = 0;
            this.mAuctionsInfoServerArr = null;
         }
         if(this.mAuctionsVec)
         {
            this.mAuctionsVec.length = 0;
            this.mAuctionsVec = null;
         }
         if(this.mInfoButton)
         {
            this.mInfoButton.removeFromParent(true);
            this.mInfoButton = null;
         }
         if(this.mAuctionFilterButtonsContainer)
         {
            this.cleanScrollContainer(this.mAuctionFilterButtonsContainer);
            this.mAuctionFilterButtonsContainer.removeFromParent(true);
            this.mAuctionFilterButtonsContainer = null;
         }
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("cards_thumbs",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("frames",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("framesXL",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("framesFactionsRarities",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("animTime",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         Root.assets.removeTexture(FSResourceMng.DEFAULT_PHOTO_NAME + "_portrait",true);
         if(Config.getConfig().cardsHaveCustomAuras())
         {
            InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("anims/animAuras",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         }
         Root.assets.removeSound("firework");
         Root.assets.removeSound("pre_firework");
         InstanceMng.getResourcesMng().removeSpecialScreenResources("customBGs");
         InstanceMng.getResourcesMng().removeResourcesFromFolder("customBGs");
         Utils.destroyArray(this.mAuctionsInfoServerArr);
         this.mAuctionsInfoServerArr = null;
         Utils.destroyArray(this.mAuctionsVec);
         this.mAuctionsVec = null;
         Utils.destroyObject(this.mSelectedAuction);
         this.mSelectedAuction = null;
         Utils.destroyObject(this.mSelectedAuctionLastHighestBid);
         this.mSelectedAuctionLastHighestBid = null;
         super.unload();
      }
      
      public function goToBidPage() : void
      {
         this.cleanMyAuctions();
         this.cleanAuctionList();
      }
      
      public function updateAuctionListButton() : void
      {
         if(Boolean(this.mAuctionListIcon) && Boolean(this.mAuctionListTextfield))
         {
            if(this.mIsBidPageSelected)
            {
               this.mAuctionListIcon.texture = Root.assets.getTexture("icon_back");
               this.mAuctionListTextfield.text = TextManager.getText("TID_GEN_BACK");
            }
            else
            {
               this.mAuctionListIcon.texture = Root.assets.getTexture("icon_auction_list");
               this.mAuctionListTextfield.text = TextManager.getText("TID_AUCTIONS_AUCTIONS");
            }
         }
      }
      
      public function cleanScrollContainer(param1:ScrollContainer, param2:Function = null) : void
      {
         var _loc3_:Component = null;
         var _loc4_:int = 0;
         var _loc5_:Number = 0.25;
         if(Boolean(param1) && param1.numChildren > 0)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.numChildren)
            {
               _loc3_ = Component(param1.getChildAt(_loc4_));
               if(_loc3_ != null)
               {
                  SpecialFX.tweenToAlpha(_loc3_,0.001,_loc5_,0,this.removeComponentFromParent,[_loc3_]);
               }
               _loc4_++;
            }
         }
         if(param2 != null)
         {
            TweenMax.delayedCall(_loc5_ + 0.25,param2);
         }
      }
      
      private function removeComponentFromParent(param1:Component) : void
      {
         if(param1)
         {
            param1.removeFromParent();
         }
      }
      
      private function cleanAuctionList() : void
      {
         if(this.mNextPageButton)
         {
            this.mNextPageButton.removeFromParent();
            this.mNextPageButton = null;
         }
         if(this.mPrevPageButton)
         {
            this.mPrevPageButton.removeFromParent();
            this.mPrevPageButton = null;
         }
         if(this.mAuctionsPageNumberTextfield)
         {
            this.mAuctionsPageNumberTextfield.removeFromParent();
            this.mAuctionsPageNumberTextfield = null;
         }
         if(this.mTitlesBG)
         {
            this.mTitlesBG.removeFromParent();
            this.mTitlesBG = null;
         }
         if(this.mCategoryColumnTitleImg)
         {
            this.mCategoryColumnTitleImg.removeFromParent();
            this.mCategoryColumnTitleImg = null;
         }
         if(this.mNameColumnTitle)
         {
            this.mNameColumnTitle.removeFromParent();
            this.mNameColumnTitle = null;
         }
         if(this.mRarityColumnTitleImg)
         {
            this.mRarityColumnTitleImg.removeFromParent();
            this.mRarityColumnTitleImg = null;
         }
         if(this.mValueColumnTitle)
         {
            this.mValueColumnTitle.removeFromParent();
            this.mValueColumnTitle = null;
         }
         if(this.mValueTitleImg)
         {
            this.mValueTitleImg.removeFromParent();
            this.mValueTitleImg = null;
         }
         if(this.mTimeColumnTitle)
         {
            this.mTimeColumnTitle.removeFromParent();
            this.mTimeColumnTitle = null;
         }
         if(this.mTimeColumnTitleImg)
         {
            this.mTimeColumnTitleImg.removeFromParent();
            this.mTimeColumnTitleImg = null;
         }
         this.cleanScrollContainer(this.mAuctionsScrollContainer,this.getAuctionServerInfo);
         if(this.mAuctionsVec)
         {
            this.mAuctionsVec.length = 0;
            this.mAuctionsVec = null;
         }
         if(this.mAuctionsInfoServerArr)
         {
            this.mAuctionsInfoServerArr.length = 0;
            this.mAuctionsInfoServerArr = null;
         }
      }
      
      public function getAuctionServerInfo() : void
      {
         if(this.mSelectedAuction)
         {
            InstanceMng.getServerConnection().getAuctionInfoByAuctionId(this.mSelectedAuction.getAuctionId(),this.onGetAuctionSuccess,this.onGetAuctionFail);
         }
      }
      
      private function onGetAuctionSuccess(param1:Object) : void
      {
         if(Boolean(param1) && Boolean(this.mSelectedAuction))
         {
            this.mSelectedAuction.update(param1);
         }
         if(this.mIsFinishedSelectedAuction && Boolean(this.mSelectedAuction))
         {
            if(!this.mSelectedAuction.isAuctionActive() && this.mSelectedAuction.getNextRound() == -1)
            {
               this.finishAuction();
            }
            else
            {
               this.mIsFinishedSelectedAuction = false;
            }
         }
      }
      
      private function onGetAuctionFail() : void
      {
         TweenMax.delayedCall(3,this.getAuctionServerInfo);
      }
      
      public function createBidPage() : void
      {
         if(Boolean(this.mSelectedAuction) && (!this.mIsBidPageSelected || AuctionsMng.smRecoveringFromError))
         {
            AuctionsMng.smRecoveringFromError = false;
            this.createBidPageUI();
            this.checkAuctionInfo();
            this.setBidPageSelected(true);
            this.setAuctionListSelected(false);
            this.setMyAuctionsSelected(false);
            this.updateAuctionListButton();
            this.checkBidsReceived();
         }
      }
      
      private function checkBidsReceived() : void
      {
         var _loc1_:Bid = null;
         TweenMax.delayedCall(3,this.checkBidsReceived);
         if(this.mSelectedAuction)
         {
            if(this.mSelectedAuction.isWaitingBidACK())
            {
               _loc1_ = this.mSelectedAuction.getOwnerBestBid();
               this.enableBidButton(this.mSelectedAuction.canOwnerBid());
            }
         }
      }
      
      public function setAuctionListSelected(param1:Boolean) : void
      {
         this.mAuctionListSelected = param1;
      }
      
      public function setMyAuctionsSelected(param1:Boolean) : void
      {
         this.mMyAuctionsSelected = param1;
      }
      
      public function checkAuctionInfo(param1:Boolean = true) : void
      {
         if(Boolean(this.mSelectedAuction) && !this.mIsFinishedSelectedAuction)
         {
            if(param1)
            {
               InstanceMng.getServerConnection().getAuctionInfoByAuctionId(this.mSelectedAuction.getAuctionId(),this.onGetAuctionSuccess,this.onGetActiveAuctionsFail);
            }
            this.updateNextBidCost();
            this.fillBids();
            this.updateAuctionRoundTextfield();
            this.updateClassifiedTextfieldColor();
            if(this.mSelectedAuction)
            {
               this.enableBidButton(this.mSelectedAuction.canOwnerBid());
            }
         }
      }
      
      public function updateAuctionRoundTextfield() : void
      {
         if(Boolean(this.mAuctionRoundTextfield) && Boolean(this.mSelectedAuction) && this.mSelectedAuction.getRound() > 1)
         {
            this.mAuctionRoundTextfield.text = this.mSelectedAuction.getRound() == 1 ? TextManager.getText("TID_AUCTIONS_INITIAL_ROUND") : TextManager.replaceParameters(TextManager.getText("TID_AUCTIONS_KNOCKOUT_ROUND"),[this.mSelectedAuction.getRound() - 1]);
         }
      }
      
      public function updateClassifiedTextfieldColor() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Bid = null;
         if(Boolean(this.mClassifiedInfoTextfield) && Boolean(this.mSelectedAuction) && !this.mSelectedAuction.isOwnerAuctionCreator())
         {
            _loc1_ = this.mSelectedAuction.getHighestBid();
            if(this.mSelectedAuction.getBiddersAmount() > 0)
            {
               _loc2_ = this.mSelectedAuction.getOwnerBestBid(this.mSelectedAuction.getRound());
            }
            else if(this.mSelectedAuction.getRound() - 1 > 0)
            {
               _loc2_ = this.mSelectedAuction.getOwnerBestBid(this.mSelectedAuction.getRound() - 1);
            }
            if(Boolean(_loc2_) && _loc1_ == _loc2_.getBid())
            {
               this.mClassifiedInfoTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GREEN);
               this.mClassifiedInfoTextfield.text = TextManager.getText("TID_AUCTIONS_LEADER");
            }
            else if(Boolean(_loc2_) && Boolean(_loc2_.getBid() < _loc1_) && _loc2_.getRound() == this.mSelectedAuction.getRound())
            {
               this.mClassifiedInfoTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GOLD);
               this.mClassifiedInfoTextfield.text = TextManager.getText("TID_AUCTIONS_CLASSIFIED");
            }
            else if(this.mSelectedAuction.getRound() > 1 && _loc2_ == null && !this.mSelectedAuction.isOwnerHighestBidder() && !this.mSelectedAuction.isOwnerAuctionCreator() || Boolean(_loc2_) && Boolean(_loc2_.getRound() < this.mSelectedAuction.getRound()))
            {
               this.mClassifiedInfoTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_RED);
               this.mClassifiedInfoTextfield.text = this.mSelectedAuction.canOwnerBid() ? TextManager.getText("TID_AUCTIONS_NOT_CLASSIFIED") + " " + TextManager.getText("TID_AUCTIONS_BID_QUALIFY") : TextManager.getText("TID_AUCTIONS_NOT_CLASSIFIED");
            }
         }
      }
      
      public function updateNextBidCost(param1:int = -1) : void
      {
         var _loc2_:int = 0;
         var _loc3_:RarityDef = null;
         if(this.mAuctionGoldInfoTextfield)
         {
            _loc2_ = int(this.mAuctionGoldInfoTextfield.text);
            _loc3_ = RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(this.mSelectedAuction.getCardDef().getCardRarity()));
            if(param1 == -1)
            {
               if(_loc2_ < this.mSelectedAuction.getHighestBid() + _loc3_.getAuctionOffsetGold())
               {
                  this.mAuctionGoldInfoTextfield.text = int(this.mSelectedAuction.getHighestBid() + _loc3_.getAuctionOffsetGold()).toString();
               }
            }
            else if(param1 + _loc3_.getAuctionOffsetGold() > _loc2_)
            {
               this.mAuctionGoldInfoTextfield.text = int(param1 + _loc3_.getAuctionOffsetGold()).toString();
            }
         }
      }
      
      private function createBidPageUI() : void
      {
         this.createCardNamePanel();
         this.createCardNameTextfield();
         this.createCardHolder();
         this.loadCardBG();
         this.createBidsScrollContainer();
         this.fillBids();
         this.createBidInfoBG();
         this.createAuctionRoundTextfield();
         this.createAuctionTimeBG();
         this.createAuctionTimeTextfield();
         this.createClassifiedInfoTextfield();
         this.createAuctionGoldInfoPanel();
         this.createAuctionGoldIcon();
         this.createAuctionGoldInfoTextfield();
         this.createBidButton();
         this.createBidButtonTextfield();
         this.createTimerAnimation();
         this.lockUI(false);
      }
      
      private function createBidButtonTextfield() : void
      {
         if(Boolean(this.mBidButton) && this.mBidButtonTextfield == null)
         {
            this.mBidButtonTextfield = new FSTextfield(this.mBidButton.width * 0.5,this.mBidButton.height * 0.4,TextManager.getText("TID_AUCTIONS_BID") + " " + this.mSelectedAuction.getBidCost() + "x");
            this.mBidButtonTextfield.alignPivot();
            this.mBidButtonTextfield.format.horizontalAlign = Align.LEFT;
            this.mBidButtonTextfield.x = this.mBidButton.x;
            this.mBidButtonTextfield.y = this.mBidButton.y;
            addChild(this.mBidButtonTextfield);
         }
      }
      
      private function createTimerAnimation(param1:int = 0) : void
      {
         var _loc2_:Number = NaN;
         if(Boolean(this.mAuctionTimeBG) && Boolean(this.mAuctionTimeTextfield))
         {
            _loc2_ = Math.min(TimerUtil.minToMs(Config.getConfig().getMaxAuctionTimerTime()),Config.getConfig().getAuctionTimeByRound(this.mSelectedAuction.getRound()));
            if(this.mTimerAnimation == null)
            {
               this.mTimerAnimation = new TimerAnimation("time_icon_bg_stop","time_icon_bg","anim_time",this.mSelectedAuction.getAuctionTime(),_loc2_);
               this.mTimerAnimation.x = this.mAuctionTimeBG.width * 0.25;
               this.mTimerAnimation.y = this.mAuctionTimeTextfield.y + this.mTimerAnimation.height * 0.7;
               addChild(this.mTimerAnimation);
            }
            else
            {
               this.mTimerAnimation.setCurrentTime(this.mSelectedAuction.getAuctionTime());
               this.mTimerAnimation.setTotalTime(_loc2_);
            }
            this.mTimerAnimation.setUpdateTimeFunction(this.mSelectedAuction.getAuctionTime);
         }
      }
      
      private function createAuctionTimeTextfield() : void
      {
         if(Boolean(this.mAuctionTimeBG) && this.mAuctionTimeTextfield == null)
         {
            this.mAuctionTimeTextfield = new FSTextfield(this.mAuctionTimeBG.width * 0.65,this.mAuctionTimeBG.height,AuctionsMng.getAuctionTime(this.mSelectedAuction));
            this.mAuctionTimeTextfield.x = this.mAuctionTimeBG.x + this.mAuctionTimeBG.width * 0.35;
            this.mAuctionTimeTextfield.y = this.mAuctionTimeBG.y;
            this.mAuctionTimeTextfield.format.horizontalAlign = Align.LEFT;
            addChild(this.mAuctionTimeTextfield);
         }
      }
      
      private function createAuctionGoldIcon() : void
      {
         if(Boolean(this.mAuctionGoldInfoPanel) && this.mAuctionGoldIcon == null)
         {
            this.mAuctionGoldIcon = new FSImage(Root.assets.getTexture("auction_gold_icon"));
            this.mAuctionGoldIcon.x = this.mAuctionGoldInfoPanel.x;
            this.mAuctionGoldIcon.y = this.mAuctionGoldInfoPanel.y;
            addChild(this.mAuctionGoldIcon);
         }
      }
      
      private function createAuctionGoldInfoTextfield() : void
      {
         var _loc1_:String = null;
         var _loc2_:RarityDef = null;
         if(Boolean(this.mAuctionGoldInfoPanel) && this.mAuctionGoldInfoTextfield == null)
         {
            if(this.mSelectedAuction.getHighestBid() == -1 && this.mSelectedAuction.getBiddersAmount() == 0)
            {
               _loc1_ = this.mSelectedAuction.getInitialPrice().toString();
            }
            else
            {
               _loc2_ = RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(this.mSelectedAuction.getCardDef().getCardRarity()));
               _loc1_ = int(this.mSelectedAuction.getHighestBid() + _loc2_.getAuctionOffsetGold()).toString();
            }
            this.mAuctionGoldInfoTextfield = new FSTextfield(this.mAuctionGoldInfoPanel.width * 0.7,this.mAuctionGoldInfoPanel.height,_loc1_);
            this.mAuctionGoldInfoTextfield.x = this.mAuctionGoldInfoPanel.x + this.mAuctionGoldInfoPanel.width * 0.3;
            this.mAuctionGoldInfoTextfield.y = this.mAuctionGoldInfoPanel.y;
            addChild(this.mAuctionGoldInfoTextfield);
         }
      }
      
      private function createBidButton() : void
      {
         var _loc1_:Bid = null;
         if(Boolean(this.mClassifiedInfoTextfield) && this.mBidButton == null)
         {
            this.mBidButton = new FSButton(Root.assets.getTexture("auction_button_bid"));
            this.mBidButton.x = this.mClassifiedInfoTextfield.x + this.mClassifiedInfoTextfield.width * 1.45;
            this.mBidButton.y = this.mClassifiedInfoTextfield.y + this.mClassifiedInfoTextfield.height * 0.7;
            _loc1_ = this.mSelectedAuction.getOwnerBestBid();
            if(AuctionsMng.TEST_BIDS_CREATOR_CAN_BID)
            {
               this.enableBidButton(true);
            }
            else
            {
               this.enableBidButton(!this.mSelectedAuction.canOwnerBid());
            }
            this.mBidButton.addEventListener(Event.TRIGGERED,this.onBidTriggered);
            addChild(this.mBidButton);
         }
      }
      
      private function onBidTriggered(param1:Event) : void
      {
         var _loc2_:UserData = null;
         var _loc3_:AuctionTicketDef = null;
         var _loc4_:FSShopItem = null;
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            this.enableBidButton(false);
            _loc2_ = Utils.getOwnerUserData();
            if(_loc2_)
            {
               if(_loc2_.getAuctionTickets() >= this.mSelectedAuction.getBidCost())
               {
                  InstanceMng.getCurrentScreen().showLoadingIcon(true,true,Align.CENTER,Align.CENTER,1,new FSCoordinate(this.mBidButton.x,this.mBidButton.y));
                  if(!InstanceMng.getUserDataMng().getOwnerUserData().isInBlackList())
                  {
                     if(!InstanceMng.getUserDataMng().getOwnerUserData().isInDuplicatedList())
                     {
                        InstanceMng.getAuctionsMng().makeBid(this.mSelectedAuction);
                     }
                     else
                     {
                        Utils.setLogText(TextManager.getText("TID_MIGRATION_ERROR_MIGRATED"),true,false,false);
                        InstanceMng.getCurrentScreen().showLoadingIcon(false,true);
                     }
                  }
                  else
                  {
                     Utils.setLogText(TextManager.getText("TID_GEN_FRAUD_PURCHASE"),true,false,false);
                     InstanceMng.getCurrentScreen().showLoadingIcon(false,true);
                  }
               }
               else
               {
                  Utils.setLogText(TextManager.getText("TID_AUCTIONS_NOT_ENOUGH_TICKETS"),true);
                  _loc3_ = AuctionTicketDef(InstanceMng.getAuctionTicketsDefMng().getDefBySku("token_01"));
                  _loc4_ = new FSShopItem(_loc3_,false,null,true);
                  InstanceMng.getPopupMng().openShopItemPopup(_loc4_);
                  this.enableBidButton(this.mSelectedAuction.canOwnerBid());
               }
            }
            else
            {
               Utils.setLogText(TextManager.getText("TID_GEN_SERVER_RETRY"),true);
            }
         }
         else
         {
            Utils.setLogText("TID_CONNECTION_REQUIRED",true);
         }
      }
      
      private function createAuctionGoldInfoPanel() : void
      {
         if(Boolean(mBGSprite) && Boolean(this.mClassifiedInfoTextfield) && this.mAuctionGoldInfoPanel == null)
         {
            this.mAuctionGoldInfoPanel = new FSImage(Root.assets.getTexture("auction_gold_info_panel"));
            this.mAuctionGoldInfoPanel.x = this.mClassifiedInfoTextfield.x + this.mClassifiedInfoTextfield.width * 1.05;
            this.mAuctionGoldInfoPanel.y = this.mClassifiedInfoTextfield.y + this.mAuctionGoldInfoPanel.height;
            addChild(this.mAuctionGoldInfoPanel);
         }
      }
      
      private function createClassifiedInfoTextfield() : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         var _loc3_:Bid = null;
         if(Boolean(mBGSprite && this.mAuctionTimeBG) && Boolean(this.mAuctionRoundTextfield) && this.mClassifiedInfoTextfield == null)
         {
            if(this.mSelectedAuction.isOwnerAuctionCreator())
            {
               _loc1_ = TextManager.getText("TID_AUCTIONS_OWNER");
            }
            else
            {
               _loc1_ = this.mSelectedAuction.canOwnerBid() ? TextManager.getText("TID_AUCTIONS_NOT_CLASSIFIED") + " " + TextManager.getText("TID_AUCTIONS_BID_QUALIFY") : TextManager.getText("TID_AUCTIONS_NOT_CLASSIFIED");
            }
            this.mClassifiedInfoTextfield = new FSTextfield(mBGSprite.width / 3,mBGSprite.height * 0.35,_loc1_);
            _loc2_ = this.mSelectedAuction.getHighestBid();
            if(this.mSelectedAuction.getBiddersAmount() > 0)
            {
               _loc3_ = this.mSelectedAuction.getOwnerBestBid(this.mSelectedAuction.getRound());
            }
            else if(this.mSelectedAuction.getRound() - 1 > 0)
            {
               _loc3_ = this.mSelectedAuction.getOwnerBestBid(this.mSelectedAuction.getRound() - 1);
            }
            if(Boolean(_loc3_) && _loc2_ == _loc3_.getBid())
            {
               this.mClassifiedInfoTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GREEN);
            }
            else if(Boolean(_loc3_) && Boolean(_loc3_.getBid() < _loc2_) && _loc3_.getRound() == this.mSelectedAuction.getRound())
            {
               this.mClassifiedInfoTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GOLD);
            }
            else if(this.mSelectedAuction.getRound() > 1 && _loc3_ == null && !this.mSelectedAuction.isOwnerHighestBidder() || Boolean(_loc3_) && Boolean(_loc3_.getRound() < this.mSelectedAuction.getRound()))
            {
               this.mClassifiedInfoTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_RED);
            }
            this.mClassifiedInfoTextfield.x = this.mAuctionTimeBG.x + this.mAuctionTimeBG.width * 1.05;
            this.mClassifiedInfoTextfield.y = this.mAuctionRoundTextfield.y;
            addChild(this.mClassifiedInfoTextfield);
         }
      }
      
      private function createAuctionTimeBG() : void
      {
         if(Boolean(mBGSprite) && Boolean(this.mAuctionRoundTextfield) && this.mAuctionTimeBG == null)
         {
            this.mAuctionTimeBG = new FSImage(Root.assets.getTexture("auction_info_time"));
            this.mAuctionTimeBG.x = mBGSprite.width * 0.02;
            this.mAuctionTimeBG.y = this.mAuctionRoundTextfield.y + this.mAuctionRoundTextfield.height;
            addChild(this.mAuctionTimeBG);
         }
      }
      
      private function createAuctionRoundTextfield() : void
      {
         var _loc1_:String = null;
         if(Boolean(mBGSprite && this.mBidInfoBG) && Boolean(this.mAuctionRoundTextfield == null) && Boolean(this.mSelectedAuction))
         {
            _loc1_ = this.mSelectedAuction.getRound() == 1 ? TextManager.getText("TID_AUCTIONS_INITIAL_ROUND") : TextManager.replaceParameters(TextManager.getText("TID_AUCTIONS_KNOCKOUT_ROUND"),[this.mSelectedAuction.getRound() - 1]);
            this.mAuctionRoundTextfield = new FSTextfield(mBGSprite.width * 0.25,mBGSprite.height * 0.1,_loc1_);
            this.mAuctionRoundTextfield.format.horizontalAlign = Align.LEFT;
            this.mAuctionRoundTextfield.x = this.mBidInfoBG.x + this.mAuctionRoundTextfield.width * 0.1;
            this.mAuctionRoundTextfield.y = this.mBidInfoBG.y;
            addChild(this.mAuctionRoundTextfield);
         }
      }
      
      private function fillBids() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:FSBidSlot = null;
         var _loc6_:Component = null;
         var _loc1_:Array = this.mSelectedAuction.getBidsOfRound();
         var _loc7_:Boolean = false;
         var _loc8_:String = InstanceMng.getUserDataMng().getOwnerUserData().getAccountId();
         if(Boolean(_loc1_) && _loc1_.length > 0)
         {
            _loc1_ = _loc1_.sort(DictionaryUtils.sortBidsByPrice);
            _loc2_ = _loc1_.length < NUM_BIDS_IN_BID_PAGE ? int(_loc1_.length) : NUM_BIDS_IN_BID_PAGE;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               if(Boolean(this.mBidsScrollContainer) && this.mBidsScrollContainer.numChildren > 0)
               {
                  _loc4_ = 0;
                  while(_loc4_ < this.mBidsScrollContainer.numChildren)
                  {
                     _loc6_ = Component(this.mBidsScrollContainer.getChildAt(_loc4_));
                     if(_loc6_ != null)
                     {
                        if(_loc6_ is FSBidSlot)
                        {
                           if(FSBidSlot(_loc6_).getBid().getBidId() == Bid(_loc1_[_loc3_]).getBidId())
                           {
                              _loc7_ = true;
                              break;
                           }
                        }
                     }
                     _loc4_++;
                  }
               }
               if(!_loc7_)
               {
                  _loc5_ = new FSBidSlot(this.mSelectedAuction,_loc1_[_loc3_]);
                  this.addBidToContainer(_loc5_);
                  if(InstanceMng.getCurrentScreen() is FSAuctionsScreen && FSAuctionsScreen(InstanceMng.getCurrentScreen()).getSelectedAuction().canOwnerBid() && _loc5_.getBid().getBidderId() == _loc8_)
                  {
                     this.enableBidButton(true);
                  }
               }
               _loc3_++;
            }
         }
      }
      
      public function addBidToContainer(param1:FSBidSlot) : void
      {
         if(param1)
         {
            if(this.mBidsScrollContainer)
            {
               param1.alpha = 0.0001;
               this.mBidsScrollContainer.addChildAt(param1,0);
               this.mBidsScrollContainer.sortChildren(DictionaryUtils.sortBidSlotsByPrice);
               if(SHOW_BID_PLACED_ANIM && !this.mBidsScrollContainer.isScrolling)
               {
                  this.mBidsScrollContainer.validate();
                  this.mBidsScrollContainer.scrollToPosition(0,this.mBidsScrollContainer.maxVerticalScrollPosition,0);
                  this.mBidsScrollContainer.validate();
               }
               this.onBidAddedPerformOps(param1);
            }
         }
      }
      
      private function onBidAddedPerformOps(param1:FSBidSlot) : void
      {
         var _loc2_:Number = 0.85;
         SpecialFX.tweenToAlpha(param1,0.999,_loc2_,0);
         if(SHOW_BID_PLACED_ANIM)
         {
            this.mBidsScrollContainer.validate();
            this.mBidsScrollContainer.scrollToPosition(0,0,_loc2_);
         }
         TweenMax.delayedCall(_loc2_,this.onBidAddedPerformOpsStep2);
      }
      
      private function onBidAddedPerformOpsStep2() : void
      {
         if(Boolean(this.mBidsScrollContainer) && this.mBidsScrollContainer.numChildren >= 4)
         {
            this.mBidsScrollContainer.removeChildAt(this.mBidsScrollContainer.numChildren - 1);
         }
      }
      
      private function createBidsScrollContainer() : void
      {
         if(Boolean(mBGSprite) && Boolean(this.mCardHolderBG) && this.mBidsScrollContainer == null)
         {
            this.mBidsScrollContainer = new ScrollContainer();
            this.mBidsScrollContainer.layout = this.getContainerLayout();
            this.mBidsScrollContainer.verticalScrollPolicy = ScrollPolicy.OFF;
            this.mBidsScrollContainer.touchable = true;
            this.mBidsScrollContainer.height = mBGSprite.height * 0.5;
            this.mBidsScrollContainer.x = this.mCardHolderBG.x + this.mCardHolderBG.width * 0.8;
            this.mBidsScrollContainer.y = mBGSprite.y + mBGSprite.height * 0.13;
            addChild(this.mBidsScrollContainer);
         }
         if(this.mBidsScrollContainer.numChildren > 0)
         {
            this.mBidsScrollContainer.removeChildren();
         }
      }
      
      private function loadCardBG() : void
      {
         if(this.mCard == null)
         {
            InstanceMng.getResourcesMng().loadCardImagesByArray([this.mSelectedAuction.getCardDef().getSku()]);
            InstanceMng.getResourcesMng().loadAssets(this.createCard);
         }
      }
      
      private function createCard() : void
      {
         if(Boolean(this.mCardHolderBG) && this.mCard == null)
         {
            this.mCard = new FSCardPreview(this.mSelectedAuction.getCardDef().getSku());
            this.mCard.touchable = true;
            this.mCard.alignPivot();
            this.mCard.x = this.mCardHolderBG.x;
            this.mCard.y = this.mCardHolderBG.y;
            addChild(this.mCard);
         }
      }
      
      private function createCardHolder() : void
      {
         if(Boolean(this.mCardNamePanel) && this.mCardHolderBG == null)
         {
            this.mCardHolderBG = new FSImage(Root.assets.getTexture("auction_card_holder"));
            this.mCardHolderBG.alignPivot();
            this.mCardHolderBG.x = this.mCardNamePanel.x;
            this.mCardHolderBG.y = this.mCardNamePanel.y + this.mCardNamePanel.height + this.mCardNamePanel.height * 1.5;
            addChild(this.mCardHolderBG);
         }
      }
      
      private function createCardNameTextfield() : void
      {
         if(Boolean(this.mCardNamePanel) && this.mCardNameTextfield == null)
         {
            this.mCardNameTextfield = new FSTextfield(this.mCardNamePanel.width,this.mCardNamePanel.height,this.mSelectedAuction.getCardDef().getName());
            this.mCardNameTextfield.alignPivot();
            this.mCardNameTextfield.x = this.mCardNamePanel.x;
            this.mCardNameTextfield.y = this.mCardNamePanel.y;
            addChild(this.mCardNameTextfield);
         }
      }
      
      private function createCardNamePanel() : void
      {
         if(Boolean(mBGSprite) && this.mCardNamePanel == null)
         {
            this.mCardNamePanel = new FSImage(Root.assets.getTexture("auction_card_name_panel"));
            this.mCardNamePanel.alignPivot();
            this.mCardNamePanel.x = mBGSprite.x + this.mCardNamePanel.width * 0.6;
            this.mCardNamePanel.y = mBGSprite.y + this.mCardNamePanel.height * 2.5;
            addChild(this.mCardNamePanel);
         }
      }
      
      public function killServerCalls() : void
      {
         TweenMax.killDelayedCallsTo(this.checkAuctionInfo);
      }
      
      private function setBidPageSelected(param1:Boolean) : void
      {
         this.mIsBidPageSelected = param1;
      }
      
      public function addInitialTokensToTokenVisor() : void
      {
         var _loc1_:UserData = Utils.getOwnerUserData();
         if(_loc1_)
         {
            _loc1_.addAuctionTickets(Config.getConfig().getInitialAmountTokens());
         }
         InstanceMng.getUserDataMng().updateAuctionTickets();
      }
      
      public function substractTokens(param1:Auction) : void
      {
         var _loc2_:UserData = Utils.getOwnerUserData();
         if(_loc2_)
         {
            _loc2_.substractAuctionTickets(param1.getBidCost() * -1);
         }
         InstanceMng.getUserDataMng().updateAuctionTickets();
      }
      
      override public function onEnterFrame(param1:Event) : void
      {
         super.onEnterFrame(param1);
         if(this.mIsBidPageSelected)
         {
            if(Boolean(this.mSelectedAuction) && Boolean(!this.mSelectedAuction.isAuctionActive()) && this.mSelectedAuction.getNextRound() == -1)
            {
               if(!this.mIsFinishedSelectedAuction)
               {
                  this.mIsFinishedSelectedAuction = true;
                  this.getAuctionServerInfo();
               }
            }
            this.updateAuctionTimeLeft();
         }
      }
      
      public function onNewRoundRefreshUI() : void
      {
         this.updateTimerAnimationOnUpdateRound();
         this.updateClassifiedTextfieldColor();
         var _loc1_:Boolean = this.getSelectedAuction().canOwnerBid();
         this.enableBidButton(_loc1_);
         this.updateAuctionRoundTextfield();
      }
      
      private function finishAuction() : void
      {
         this.enableBidButton(false);
         if(!this.mSelectedAuction.isOwnerAuctionCreator())
         {
            if(this.mSelectedAuction.isOwnerAuctionWinner())
            {
               if(this.mClassifiedInfoTextfield)
               {
                  this.mClassifiedInfoTextfield.text = TextManager.getText("TID_AUCTIONS_AUCTION_WON");
               }
               this.createAuctionWinAnimation();
            }
            else
            {
               Utils.setLogText(TextManager.getText("TID_AUCTIONS_AUCTION_LOST"));
               if(this.mClassifiedInfoTextfield)
               {
                  this.mClassifiedInfoTextfield.text = TextManager.getText("TID_AUCTIONS_AUCTION_LOST");
               }
            }
         }
         else if(this.mSelectedAuction.isOwnerAuctionSuccessful())
         {
            Utils.setLogText(TextManager.getText("TID_AUCTIONS_OWNER_SUCCESS"));
            if(this.mClassifiedInfoTextfield)
            {
               this.mClassifiedInfoTextfield.text = TextManager.getText("TID_AUCTIONS_OWNER_SUCCESS");
            }
            InstanceMng.getQuestsMng().addActionPerformed(QuestsMng.TARGET_TYPE_AUCTION_SUCCESS,1,true,["auctionId:" + this.mSelectedAuction.getAuctionId()]);
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_AUCTIONS_OWNER_FAILED"));
            if(this.mClassifiedInfoTextfield)
            {
               this.mClassifiedInfoTextfield.text = TextManager.getText("TID_AUCTIONS_OWNER_FAILED");
            }
         }
         if(this.mTimerAnimation)
         {
            this.mTimerAnimation.stopTimerAnimation();
         }
      }
      
      private function createAuctionWinAnimation(param1:Number = 1, param2:Function = null, param3:Array = null) : void
      {
         var _loc4_:Number = 0.6 * Utils.getDefaultSpeedTime();
         if(this.mAuctionWinAnimation == null)
         {
            this.mAuctionWinAnimation = new FSAuctionWinAnimation(param2,param3);
         }
         addChild(this.mAuctionWinAnimation);
         this.mAuctionWinAnimation.x = Starling.current.stage.stageWidth / 2;
         this.mAuctionWinAnimation.y = Starling.current.stage.stageHeight / 2;
         this.mAuctionWinAnimation.performFadeIn();
         TweenMax.delayedCall(param1,this.removeAuctionWinAnimation);
      }
      
      private function removeAuctionWinAnimation() : void
      {
         var _loc1_:Number = NaN;
         TweenMax.killDelayedCallsTo(this.removeAuctionWinAnimation);
         if(Boolean(this.mAuctionWinAnimation) && Boolean(contains(this.mAuctionWinAnimation)) && this.mAuctionWinAnimation.isShown())
         {
            _loc1_ = 2 * Utils.getDefaultSpeedTime();
            this.mAuctionWinAnimation.performFadeOut(_loc1_);
            TweenMax.delayedCall(_loc1_,this.onAuctionWinAnimRemoved);
         }
      }
      
      private function onAuctionWinAnimRemoved() : void
      {
         this.mAuctionWinAnimation = null;
      }
      
      private function updateAuctionTimeLeft() : void
      {
         var _loc1_:Number = NaN;
         if(Boolean(this.mAuctionTimeTextfield) && !this.mIsFinishedSelectedAuction)
         {
            _loc1_ = this.mSelectedAuction.getAuctionTime();
            if(_loc1_ < 1)
            {
               if(InstanceMng.getCurrentScreen() is FSAuctionsScreen)
               {
                  AuctionsMng.smRecoveringFromError = true;
                  FSAuctionsScreen(InstanceMng.getCurrentScreen()).getAuctionServerInfo();
               }
            }
            else
            {
               this.mAuctionTimeTextfield.text = AuctionsMng.getAuctionTime(this.mSelectedAuction);
            }
         }
         else if(Boolean(this.mAuctionTimeTextfield && this.mIsFinishedSelectedAuction) && Boolean(!this.mSelectedAuction.isAuctionActive()) && this.mSelectedAuction.getNextRound() == -1)
         {
            this.mAuctionTimeTextfield.text = TextManager.getText("TID_AUCTIONS_AUCTION_FINISHED");
            if(this.mTimerAnimation)
            {
               this.mTimerAnimation.stopTimerAnimation();
            }
         }
      }
      
      public function isMyAuctionsSelected() : Boolean
      {
         return this.mMyAuctionsSelected;
      }
      
      private function getStartIndexCurrentPage() : int
      {
         return this.mCurrentPage * AUCTIONS_BY_PAGE;
      }
      
      private function getNumTotalPage() : int
      {
         return Math.ceil(this.mAuctionsCount / AUCTIONS_BY_PAGE);
      }
      
      private function getEndIndexCurrentPage() : int
      {
         return this.getStartIndexCurrentPage() + AUCTIONS_BY_PAGE < this.mAuctionsCount ? int(this.getStartIndexCurrentPage() + AUCTIONS_BY_PAGE) : this.mAuctionsCount;
      }
      
      public function enableBidButton(param1:Boolean) : void
      {
         if(this.mBidButton)
         {
            this.mBidButton.enabled = param1;
            this.mBidButton.touchable = param1;
         }
      }
      
      public function getLastHighestBidSelectedAuction() : int
      {
         return this.mSelectedAuctionLastHighestBid ? int(this.mSelectedAuctionLastHighestBid.value) : 0;
      }
      
      public function setLastHighestBidSelectedAuction(param1:int) : void
      {
         if(this.mSelectedAuctionLastHighestBid == null)
         {
            this.mSelectedAuctionLastHighestBid = new FSNumber();
         }
         this.mSelectedAuctionLastHighestBid.value = param1;
      }
      
      override public function getAuctionTicketsVisor() : FSAuctionTicketsVisor
      {
         return this.mAuctionTicketsVisor;
      }
      
      override public function lockUI(param1:Boolean) : void
      {
         super.lockUI(param1);
         if(this.mAuctionsScrollContainer)
         {
            this.mAuctionsScrollContainer.touchable = !param1;
         }
         if(this.mAuctionListButton)
         {
            this.mAuctionListButton.touchable = !param1;
         }
         if(this.mMyAuctionsButton)
         {
            this.mMyAuctionsButton.touchable = !param1;
         }
         if(this.mGoldVisor)
         {
            this.mGoldVisor.touchable = !param1;
         }
         if(this.mAuctionTicketsVisor)
         {
            this.mAuctionTicketsVisor.touchable = !param1;
         }
         if(mBackButton)
         {
            mBackButton.enabled = true;
         }
      }
      
      override public function removeTranslucentBG(param1:Boolean = false, param2:Boolean = false) : void
      {
         super.removeTranslucentBG(param1,param2);
         if(Boolean(mSelectedCard) && !param2)
         {
            SpecialFX.zoomOut(mSelectedCard);
            if(this.mCard)
            {
               this.mCard.setZoomedIn(false);
            }
            mSelectedCard = null;
         }
      }
      
      public function updateTimerAnimationOnUpdateRound() : void
      {
         if(this.mTimerAnimation)
         {
            this.mTimerAnimation.stopTimerAnimation();
            this.createTimerAnimation();
         }
      }
      
      public function isBidPageSelected() : Boolean
      {
         return this.mIsBidPageSelected;
      }
      
      public function getSelectedAuction() : Auction
      {
         return this.mSelectedAuction;
      }
      
      public function addAuctionScrollContainerToStage() : void
      {
         var _loc1_:FSAuctionSlot = null;
         if(Boolean(this.mAuctionsScrollContainer) && this.mAuctionsScrollContainer.numChildren > 0)
         {
            _loc1_ = FSAuctionSlot(this.mAuctionsScrollContainer.getChildAt(0));
            if(_loc1_)
            {
               this.mAuctionsScrollContainer.x = mBGSprite.width / 2 - _loc1_.width / 2;
               this.mAuctionsScrollContainer.y = (this.mAuctionListButton.y + this.mAuctionListButton.height) * 1.15;
            }
            addChild(this.mAuctionsScrollContainer);
         }
         if(this.mNextPageButton)
         {
            addChild(this.mNextPageButton);
         }
         if(this.mPrevPageButton)
         {
            addChild(this.mPrevPageButton);
         }
         if(this.mAuctionsPageNumberTextfield)
         {
            addChild(this.mAuctionsPageNumberTextfield);
         }
         reAddUIVisualsOptions();
      }
      
      public function cleanAuctionsInfo(param1:Function = null) : void
      {
         if(this.mAuctionsVec)
         {
            this.mAuctionsVec.length = 0;
            this.mAuctionsVec = null;
         }
         if(this.mAuctionsInfoServerArr)
         {
            this.mAuctionsInfoServerArr.length = 0;
            this.mAuctionsInfoServerArr = null;
         }
         if(Boolean(this.mAuctionsScrollContainer) && this.mAuctionsScrollContainer.numChildren > 0)
         {
            this.cleanScrollContainer(this.mAuctionsScrollContainer,param1);
            this.mAuctionsScrollContainer.removeFromParent();
            this.mAuctionsScrollContainer = null;
         }
      }
      
      public function addAuctionToVec(param1:Auction) : void
      {
         var _loc2_:Auction = null;
         var _loc3_:Boolean = false;
         if(this.mAuctionsVec == null)
         {
            this.mAuctionsVec = new Vector.<Auction>();
         }
         if(Boolean(this.mAuctionsVec) && this.mAuctionsVec.length > 0)
         {
            for each(_loc2_ in this.mAuctionsVec)
            {
               if(_loc2_.getAuctionId() == param1.getAuctionId())
               {
                  _loc3_ = true;
                  break;
               }
            }
         }
         if(Boolean(this.mAuctionsVec) && !_loc3_)
         {
            this.mAuctionsVec.push(param1);
         }
      }
      
      public function removeAuctionFromVector(param1:Auction) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         if(Boolean(this.mAuctionsVec) && this.mAuctionsVec.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mAuctionsVec.length)
            {
               if(param1.getAuctionId() == this.mAuctionsVec[_loc2_].getAuctionId())
               {
                  _loc3_ = true;
                  break;
               }
               _loc2_++;
            }
            if(_loc3_)
            {
               this.mAuctionsVec.splice(_loc2_,1);
            }
         }
      }
      
      public function getAuctionScrollContainer() : ScrollContainer
      {
         return this.mAuctionsScrollContainer;
      }
      
      override public function getGoldVisor() : *
      {
         return this.mGoldVisor;
      }
      
      override public function onConnectionChange(param1:Boolean = true) : void
      {
         this.refreshAuctionsList();
         if(this.mSelectedAuction != null)
         {
            this.lockUI(true);
            if(InstanceMng.getCurrentScreen() is FSAuctionsScreen)
            {
               FSAuctionsScreen(InstanceMng.getCurrentScreen()).goToBidPage();
               FSAuctionsScreen(InstanceMng.getCurrentScreen()).updateAuctionListButton();
            }
         }
         super.onConnectionChange(param1);
      }
   }
}

