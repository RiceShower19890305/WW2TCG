package com.fs.tcgengine.screens
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.controller.rules.HeroCharacterDefMng;
   import com.fs.tcgengine.model.rules.AuctionTicketDef;
   import com.fs.tcgengine.model.rules.BundleDef;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.GoldDef;
   import com.fs.tcgengine.model.rules.HeroCharacterDef;
   import com.fs.tcgengine.model.rules.PackDef;
   import com.fs.tcgengine.model.rules.PortraitDef;
   import com.fs.tcgengine.model.rules.QuestShopDef;
   import com.fs.tcgengine.model.rules.RaidShopDef;
   import com.fs.tcgengine.model.rules.ShopBoostDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.TimerUtil;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.map.SubMenuButton;
   import com.fs.tcgengine.view.components.misc.FSCurrencyVisor;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.components.shop.FSShopItem;
   import com.fs.tcgengine.view.components.shop.ShopMenuButton;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.popups.Popup;
   import com.fs.tcgengine.view.popups.misc.PopupStandard;
   import com.fs.tcgengine.view.popups.purchases.PopupShopItem;
   import com.greensock.TweenMax;
   import feathers.controls.ScrollContainer;
   import feathers.controls.ScrollPolicy;
   import feathers.layout.FlowLayout;
   import feathers.layout.HorizontalAlign;
   import feathers.layout.VerticalAlign;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import starling.events.Event;
   import starling.utils.Align;
   
   public class FSShopScreen extends Screen
   {
      
      public static const CATEGORY_1_OFFERS:int = 0;
      
      public static const CATEGORY_2_PACKS:int = 1;
      
      public static const CATEGORY_3_GOLD:int = 2;
      
      public static const CATEGORY_4_AH_TOKENS:int = 3;
      
      public static const CATEGORY_5_QUESTS:int = 4;
      
      public static const CATEGORY_6_RAIDS:int = 5;
      
      public static const CATEGORY_7_BOOSTS:int = 6;
      
      public static const CATEGORY_8_SKINS:int = 7;
      
      private var mOffersButton:ShopMenuButton;
      
      private var mPacksButton:ShopMenuButton;
      
      private var mGoldButton:ShopMenuButton;
      
      private var mAHTokensButton:ShopMenuButton;
      
      private var mQuestsButton:ShopMenuButton;
      
      private var mRaidsButton:ShopMenuButton;
      
      private var mBoostsButton:ShopMenuButton;
      
      private var mSkinsButton:ShopMenuButton;
      
      private var mMenuButtonsContainer:Component;
      
      private var mTopMenuContainer:Component;
      
      private var mItemsScrollContainer:ScrollContainer;
      
      private var mInfoTextfield:FSTextfield;
      
      private var mCategorySelected:int;
      
      private var mRaidCoinsVisor:FSCurrencyVisor;
      
      private var mQuestCoinsVisor:FSCurrencyVisor;
      
      private var mTokensVisor:FSCurrencyVisor;
      
      private var mGoldVisor:FSCurrencyVisor;
      
      private var mOffersArray:Array;
      
      private var mPacksArray:Array;
      
      private var mGoldBagsArray:Array;
      
      private var mAHTokensArray:Array;
      
      private var mQuestsProdsArray:Array;
      
      private var mRaidsProdsArray:Array;
      
      private var mBoostsArray:Array;
      
      private var mSkinsArray:Array;
      
      private var mItemBeingPurchased:FSShopItem;
      
      private var mLastPurchaseAttempt:String = "";
      
      private var mUILocked:Boolean = false;
      
      private var mWeeklyOffersCatalog:Dictionary;
      
      private var mHourlyOffersCatalog:Dictionary;
      
      private var mAllHourlyOffersArray:Array;
      
      private var mOfferObjectDefCatalog:Dictionary;
      
      private var mArrowDown:FSImage;
      
      private var mDisposableCards:Dictionary;
      
      private var mOffersAssetsLoaded:Boolean;
      
      private var mBundleOfferDef:BundleDef;
      
      private var mBundleManualOfferDef:BundleDef;
      
      private var mBundleWelcomeBackDef:BundleDef;
      
      private var mNonDisposableTextureNames:Dictionary;
      
      private var mHiddenProdItems:Vector.<FSShopItem>;
      
      private var mRefreshingOffers:Boolean = false;
      
      public function FSShopScreen()
      {
         mNeedsLoadingBar = true;
         mBGName = Constants.SHOP_BG_NAME;
         mScreenName = Constants.SHOP_SCREEN_NAME;
         var _loc1_:int = Main.smData != null && Main.smData["shop_category"] != null ? int(Main.smData["shop_category"]) : CATEGORY_2_PACKS;
         this.setCategorySelected(_loc1_,true);
         Main.smData["shop_category"] = null;
         InstanceMng.getServerConnection().isPlayerInBlackList();
         this.mBundleOfferDef = InstanceMng.getBundlesDefMng().getCustomOfferToShowInShop();
         this.mBundleManualOfferDef = InstanceMng.getBundlesDefMng().getServerManualOffer();
         this.mBundleWelcomeBackDef = InstanceMng.getBundlesDefMng().getWelcomeBackBundle();
         this.requestOffers();
         super();
      }
      
      override protected function setResourcesToLoad() : void
      {
         var _loc1_:HeroCharacterDef = null;
         var _loc2_:int = 0;
         var _loc3_:CardDef = null;
         var _loc4_:String = null;
         var _loc5_:Vector.<String> = null;
         var _loc6_:int = 0;
         super.setResourcesToLoad();
         InstanceMng.getResourcesMng().addResourcesFolderByName("customBGs");
         if(!Utils.isBrowser())
         {
            InstanceMng.getResourcesMng().addSpecialScreenResources("customBGs",null,FSResourceMng.PREFIX_TEXTURE);
         }
         InstanceMng.getResourcesMng().addResourcesFolderByName("frames");
         InstanceMng.getResourcesMng().addResourcesFolderByName("framesFactionsRarities");
         if(Config.getConfig().cardsHaveCustomAuras())
         {
            InstanceMng.getResourcesMng().addResourcesFolderByName("anims/animAuras");
         }
         this.mPacksArray = this.mPacksArray == null ? InstanceMng.getPacksDefMng().getPacksToShowInShopArray() : this.mPacksArray;
         this.mGoldBagsArray = this.mGoldBagsArray == null ? InstanceMng.getGoldDefMng().getGoldBagsToShowInShopArray() : this.mGoldBagsArray;
         this.mAHTokensArray = this.mAHTokensArray == null ? InstanceMng.getAuctionTicketsDefMng().getAuctionTicketBagsToShowInShopArray() : this.mAHTokensArray;
         this.mQuestsProdsArray = this.mQuestsProdsArray == null ? InstanceMng.getQuestShopDefMng().getItemsToShowInShop() : this.mQuestsProdsArray;
         this.mRaidsProdsArray = this.mRaidsProdsArray == null ? InstanceMng.getRaidShopDefMng().getItemsToShowInShop() : this.mRaidsProdsArray;
         this.mBoostsArray = this.mBoostsArray == null ? InstanceMng.getShopBoostsDefMng().getBoostsToShowInShopArray() : this.mBoostsArray;
         this.mSkinsArray = this.mSkinsArray == null ? InstanceMng.getHeroCharactersDefMng().getAllSkinsArr(HeroCharacterDefMng.UNLOCK_BY_SHOP) : this.mSkinsArray;
         if(this.mSkinsArray)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mSkinsArray.length)
            {
               _loc1_ = this.mSkinsArray[_loc2_];
               if(_loc1_)
               {
                  this.addItemBGIntoNonDisposableCatalog(_loc1_.getBGImageName());
                  InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + _loc1_.getBGImageName(),FSResourceMng.TYPE_TEXTURE_PNG);
               }
               _loc2_++;
            }
         }
         if(this.mRaidsProdsArray)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mRaidsProdsArray.length)
            {
               if(RaidShopDef(this.mRaidsProdsArray[_loc2_]).getType() == FSShopItem.SHOP_ITEM_TYPE_CARD)
               {
                  _loc3_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(RaidShopDef(this.mRaidsProdsArray[_loc2_]).getCardSku()));
                  _loc5_ = InstanceMng.getCardsMng().getCardTiersImageNames(_loc3_,true);
                  if(_loc5_)
                  {
                     _loc6_ = 0;
                     _loc6_ = 0;
                     while(_loc6_ < _loc5_.length)
                     {
                        this.addItemBGIntoNonDisposableCatalog(_loc5_[_loc6_]);
                        this.addItemBGIntoNonDisposableCatalog(_loc5_[_loc6_]);
                        _loc6_++;
                     }
                  }
                  InstanceMng.getResourcesMng().loadCardImagesByArray([_loc3_.getSku()],true,true);
               }
               _loc2_++;
            }
         }
         if(this.mQuestsProdsArray)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mQuestsProdsArray.length)
            {
               if(QuestShopDef(this.mQuestsProdsArray[_loc2_]).getType() == FSShopItem.SHOP_ITEM_TYPE_CARD)
               {
                  _loc3_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(QuestShopDef(this.mQuestsProdsArray[_loc2_]).getCardSku()));
                  if(_loc3_)
                  {
                     _loc5_ = InstanceMng.getCardsMng().getCardTiersImageNames(_loc3_,true);
                     if(_loc5_)
                     {
                        _loc6_ = 0;
                        while(_loc6_ < _loc5_.length)
                        {
                           this.addItemBGIntoNonDisposableCatalog(_loc5_[_loc6_]);
                           this.addItemBGIntoNonDisposableCatalog(_loc5_[_loc6_]);
                           _loc6_++;
                        }
                     }
                     InstanceMng.getResourcesMng().loadCardImagesByArray([_loc3_.getSku()],true,true);
                  }
               }
               _loc2_++;
            }
         }
         InstanceMng.getResourcesMng().loadAssets();
      }
      
      override public function notifyAssetsLoaded(param1:* = null) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         super.notifyAssetsLoaded();
         this.createUI();
         if(!InstanceMng.getApplication().getInAppsManager().areProductsPricesUpToDate())
         {
            InstanceMng.getServerConnection().getProducts(null,true);
            if(!InstanceMng.getApplication().getInAppsManager().areProductsPricesUpToDate())
            {
               Utils.setLogText(TextManager.getText("TID_GEN_REQUEST_PRODUCT"),false,false);
               showLoadingIcon(true,false,Align.RIGHT,Align.CENTER,1,null,InstanceMng.getLogPanel());
            }
         }
         if(this.mBundleOfferDef)
         {
            _loc2_ = InstanceMng.getUserDataMng().getOwnerUserData().getCustomOfferShownExpirationDate();
            _loc3_ = TimerUtil.hourToMs(0.5);
            _loc4_ = _loc2_ - ServerConnection.smServerTimeMS - _loc3_;
            _loc5_ = TimerUtil.msToSec(_loc4_);
            if(ServerConnection.smServerTimeMS < _loc2_ && _loc5_ > 0)
            {
               setTimeout(this.handleBundlesLocalNotification,1000,_loc5_);
            }
         }
      }
      
      private function createUI() : void
      {
         this.createMenuButtons();
         this.createCurrencyVisors();
         this.setCategorySelected(this.mCategorySelected);
      }
      
      private function createCurrencyVisors() : void
      {
         this.mRaidCoinsVisor = this.createCurrencyVisor(ServerConnection.CURRENCY_RAID_COINS);
         this.mQuestCoinsVisor = this.createCurrencyVisor(ServerConnection.CURRENCY_QUEST_COINS);
         if(Config.getConfig().gameHasAuctions())
         {
            this.mTokensVisor = this.createCurrencyVisor(ServerConnection.CURRENCY_AH_TOKENS);
         }
         this.mGoldVisor = this.createCurrencyVisor(ServerConnection.CURRENCY_GOLD);
      }
      
      private function createMenuButtons() : void
      {
         this.mOffersButton = this.createButton(false,"offers_button","shop_left_side_icon_offers",TextManager.getText("TID_SHOP_OFFERS"));
         this.mPacksButton = this.createButton(true,"packs_button","shop_left_side_icon_treasures",TextManager.getText("TID_SHOP_PACKS"));
         this.mGoldButton = this.createButton(false,"gold_button","shop_left_side_icon_gold",TextManager.getText("TID_GEN_CURRENCY_1"));
         if(Config.getConfig().gameHasAuctions())
         {
            this.mAHTokensButton = this.createButton(false,"ahtokens_button","shop_left_side_icon_tokens",TextManager.getText("TID_SHOP_TOKENS"));
         }
         this.mQuestsButton = this.createButton(false,"quests_button","shop_left_side_icon_quests",TextManager.getText("TID_BUTTON_QUEST"));
         this.mRaidsButton = this.createButton(false,"raids_button","shop_left_side_icon_raids",TextManager.getText("TID_RAID"));
         var _loc1_:UserData = Utils.getOwnerUserData();
         var _loc2_:Boolean = _loc1_ ? _loc1_.isPayingUser() : false;
         if(InstanceMng.getApplication().hasPermanentBoosts() && _loc2_)
         {
            this.mBoostsButton = this.createButton(false,"boosts_button","shop_left_side_icon_boosts",TextManager.getText("TID_SHOP_BOOSTS"));
         }
         if(Config.getConfig().hasSkins())
         {
            this.mSkinsButton = this.createButton(false,"skins_button","shop_left_side_icon_skins",TextManager.getText("TID_GEN_SKINS"));
         }
      }
      
      private function createButton(param1:Boolean, param2:String, param3:String, param4:String) : ShopMenuButton
      {
         var _loc5_:ShopMenuButton = new ShopMenuButton(param1,param2,param3,"shop_left_side_button_enabled","shop_left_side_button_disable",this.onButtonTriggered,param4);
         _loc5_.name = param2;
         this.addButtonIntoButtonsMenuContainer(_loc5_);
         return _loc5_;
      }
      
      private function addButtonIntoButtonsMenuContainer(param1:SubMenuButton) : void
      {
         var _loc2_:UserData = Utils.getOwnerUserData();
         var _loc3_:Boolean = _loc2_ ? _loc2_.isPayingUser() : false;
         var _loc4_:int = InstanceMng.getApplication().hasPermanentBoosts() && _loc3_ ? 6 : 5;
         var _loc5_:Boolean = Config.getConfig().hasSkins();
         var _loc6_:Boolean = Config.getConfig().gameHasAuctions();
         _loc4_ += _loc5_ ? 1 : 0;
         _loc4_ = _loc4_ + (_loc6_ ? 1 : 0);
         var _loc7_:int = param1.width * _loc4_ + 3.5 * _loc4_;
         if(this.mMenuButtonsContainer == null)
         {
            this.mMenuButtonsContainer = new Component();
            this.mMenuButtonsContainer.x = (mBGSprite.width - _loc7_) / 2;
            this.mMenuButtonsContainer.y = mBackButton.y + mBackButton.height;
            addChild(this.mMenuButtonsContainer);
         }
         var _loc8_:int = this.mMenuButtonsContainer.numChildren;
         param1.x = Utils.getXYPositionInContainer(_loc8_,param1.width,param1.height,_loc7_,param1.height,_loc4_,1,true).mX;
         this.mMenuButtonsContainer.addChild(param1);
      }
      
      private function addCurrencyVisorIntoContainer(param1:FSCurrencyVisor) : void
      {
         var _loc2_:int = width * 0.75;
         var _loc3_:int = Config.getConfig().gameHasAuctions() ? 4 : 3;
         if(this.mTopMenuContainer == null)
         {
            this.mTopMenuContainer = new Component();
            this.mTopMenuContainer.x = (width - _loc2_) / 2;
            addChild(this.mTopMenuContainer);
         }
         var _loc4_:int = this.mTopMenuContainer.numChildren;
         var _loc5_:FSCoordinate = Utils.getXYPositionInContainer(_loc4_,param1.width,param1.height,_loc2_,param1.height,_loc3_,1,true);
         param1.x = param1.width / 2 + _loc5_.mX;
         param1.y = param1.height / 1.7 + _loc5_.mY;
         this.mTopMenuContainer.addChild(param1);
      }
      
      private function onButtonTriggered(param1:Event) : void
      {
         if(this.mItemsScrollContainer)
         {
            this.mItemsScrollContainer.scrollToPosition(0,0,0.25);
         }
         FSTracker.trackFirebaseEvent("SHOP_TAB_SWITCHED",["tab"],[FSButton(param1.currentTarget).name]);
         switch(FSButton(param1.currentTarget).name)
         {
            case "offers_button":
               this.setCategorySelected(CATEGORY_1_OFFERS);
               break;
            case "packs_button":
               this.setCategorySelected(CATEGORY_2_PACKS);
               break;
            case "gold_button":
               this.setCategorySelected(CATEGORY_3_GOLD);
               break;
            case "ahtokens_button":
               this.setCategorySelected(CATEGORY_4_AH_TOKENS);
               break;
            case "quests_button":
               this.setCategorySelected(CATEGORY_5_QUESTS);
               break;
            case "raids_button":
               this.setCategorySelected(CATEGORY_6_RAIDS);
               break;
            case "boosts_button":
               this.setCategorySelected(CATEGORY_7_BOOSTS);
               break;
            case "skins_button":
               this.setCategorySelected(CATEGORY_8_SKINS);
         }
      }
      
      private function createCurrencyVisor(param1:String) : FSCurrencyVisor
      {
         var _loc2_:FSCurrencyVisor = new FSCurrencyVisor(param1);
         this.addCurrencyVisorIntoContainer(_loc2_);
         return _loc2_;
      }
      
      public function forceRefreshOffers() : void
      {
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         if(this.mCategorySelected != CATEGORY_1_OFFERS || this.mRefreshingOffers)
         {
            return;
         }
         this.mRefreshingOffers = true;
         this.mCategorySelected = CATEGORY_1_OFFERS;
         var _loc1_:Array = null;
         this.refreshButtons();
         if(Boolean(this.mItemsScrollContainer) && this.mItemsScrollContainer.numChildren > 0)
         {
            this.mItemsScrollContainer.removeChildren();
         }
         this.flushHiddenItems();
         var _loc2_:String = "";
         var _loc3_:UserData = Utils.getOwnerUserData();
         _loc3_.setCustomOfferNewBannerShown(false);
         _loc2_ = TextManager.getText("TID_SHOP_DESC_OFFERS");
         this.requestOffers();
         if(this.mBundleWelcomeBackDef)
         {
            _loc4_ = _loc3_.isCustomOfferPurchased(this.mBundleWelcomeBackDef.getSku());
            _loc5_ = this.mBundleWelcomeBackDef.isRepurchasable();
            if((_loc5_) || !_loc5_ && !_loc4_)
            {
               this.addItemIntoContainer(new FSShopItem(this.mBundleWelcomeBackDef,true));
            }
         }
         if(this.mBundleManualOfferDef)
         {
            _loc4_ = _loc3_.isCustomOfferPurchased(this.mBundleManualOfferDef.getManualId());
            _loc5_ = this.mBundleManualOfferDef.isRepurchasable();
            if((_loc5_) || !_loc5_ && !_loc4_)
            {
               this.addItemIntoContainer(new FSShopItem(this.mBundleManualOfferDef,true));
            }
         }
         if(this.mBundleOfferDef)
         {
            _loc4_ = _loc3_.isCustomOfferPurchased(this.mBundleOfferDef.getSku());
            _loc5_ = this.mBundleOfferDef.isRepurchasable();
            if((_loc5_) || !_loc5_ && !_loc4_)
            {
               this.addItemIntoContainer(new FSShopItem(this.mBundleOfferDef,true));
            }
         }
         _loc1_ = this.mOffersArray;
      }
      
      private function setCategorySelected(param1:int, param2:Boolean = false) : void
      {
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         if(param1 == CATEGORY_1_OFFERS && !this.mOffersAssetsLoaded || Boolean(this.mItemsScrollContainer && this.mItemsScrollContainer.numChildren > 0) && Boolean(param1 == this.mCategorySelected))
         {
            return;
         }
         this.mCategorySelected = param1;
         var _loc3_:Array = null;
         this.refreshButtons();
         if(Boolean(this.mItemsScrollContainer) && this.mItemsScrollContainer.numChildren > 0)
         {
            this.mItemsScrollContainer.removeChildren();
         }
         this.flushHiddenItems();
         var _loc4_:String = "";
         var _loc5_:UserData = Utils.getOwnerUserData();
         switch(this.mCategorySelected)
         {
            case CATEGORY_1_OFFERS:
               _loc5_.setCustomOfferNewBannerShown(false);
               _loc4_ = TextManager.getText("TID_SHOP_DESC_OFFERS",true);
               if(this.isAnyOfferExpired())
               {
                  this.requestOffers();
               }
               if(this.mBundleWelcomeBackDef)
               {
                  _loc6_ = _loc5_.isCustomOfferPurchased(this.mBundleWelcomeBackDef.getSku());
                  _loc7_ = this.mBundleWelcomeBackDef.isRepurchasable();
                  if((_loc7_) || !_loc7_ && !_loc6_)
                  {
                     this.addItemIntoContainer(new FSShopItem(this.mBundleWelcomeBackDef,true));
                  }
               }
               if(this.mBundleManualOfferDef)
               {
                  _loc6_ = _loc5_.isCustomOfferPurchased(this.mBundleManualOfferDef.getManualId());
                  _loc7_ = this.mBundleManualOfferDef.isRepurchasable();
                  if((_loc7_) || !_loc7_ && !_loc6_)
                  {
                     this.addItemIntoContainer(new FSShopItem(this.mBundleManualOfferDef,true));
                  }
               }
               if(this.mBundleOfferDef)
               {
                  _loc6_ = _loc5_.isCustomOfferPurchased(this.mBundleOfferDef.getSku());
                  _loc7_ = this.mBundleOfferDef.isRepurchasable();
                  if((_loc7_) || !_loc7_ && !_loc6_)
                  {
                     this.addItemIntoContainer(new FSShopItem(this.mBundleOfferDef,true));
                  }
               }
               _loc3_ = this.mOffersArray;
               break;
            case CATEGORY_2_PACKS:
               _loc4_ = TextManager.getText("TID_SHOP_DESC_TREASURES",true);
               _loc3_ = this.mPacksArray;
               break;
            case CATEGORY_3_GOLD:
               _loc4_ = TextManager.getText("TID_SHOP_DESC_GOLD",true);
               _loc3_ = this.mGoldBagsArray;
               break;
            case CATEGORY_4_AH_TOKENS:
               _loc4_ = TextManager.getText("TID_SHOP_DESC_TOKENS",true);
               _loc3_ = this.mAHTokensArray;
               break;
            case CATEGORY_5_QUESTS:
               _loc4_ = TextManager.getText("TID_SHOP_DESC_QUESTS",true);
               _loc3_ = this.mQuestsProdsArray;
               break;
            case CATEGORY_6_RAIDS:
               _loc4_ = TextManager.getText("TID_SHOP_DESC_RAIDS",true);
               _loc3_ = this.mRaidsProdsArray;
               break;
            case CATEGORY_7_BOOSTS:
               _loc4_ = TextManager.getText("TID_SHOP_DESC_BOOSTS",true);
               _loc3_ = this.mBoostsArray;
               break;
            case CATEGORY_8_SKINS:
               _loc4_ = TextManager.getText("TID_SHOP_DESC_SKINS",true);
               _loc3_ = this.mSkinsArray;
         }
         this.updateInfoText(_loc4_);
         if(!param2)
         {
            this.processItemsIntoContainer(_loc3_);
         }
      }
      
      private function refreshButtons() : void
      {
         if(this.mOffersButton)
         {
            this.mOffersButton.setIsSelected(this.mCategorySelected == CATEGORY_1_OFFERS);
         }
         if(this.mPacksButton)
         {
            this.mPacksButton.setIsSelected(this.mCategorySelected == CATEGORY_2_PACKS);
         }
         if(this.mPacksButton)
         {
            this.mGoldButton.setIsSelected(this.mCategorySelected == CATEGORY_3_GOLD);
         }
         if(this.mAHTokensButton)
         {
            this.mAHTokensButton.setIsSelected(this.mCategorySelected == CATEGORY_4_AH_TOKENS);
         }
         if(this.mQuestsButton)
         {
            this.mQuestsButton.setIsSelected(this.mCategorySelected == CATEGORY_5_QUESTS);
         }
         if(this.mRaidsButton)
         {
            this.mRaidsButton.setIsSelected(this.mCategorySelected == CATEGORY_6_RAIDS);
         }
         if(this.mBoostsButton)
         {
            this.mBoostsButton.setIsSelected(this.mCategorySelected == CATEGORY_7_BOOSTS);
         }
         if(this.mSkinsButton)
         {
            this.mSkinsButton.setIsSelected(this.mCategorySelected == CATEGORY_8_SKINS);
         }
      }
      
      private function processItemsIntoContainer(param1:Array) : void
      {
         var _loc2_:Def = null;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         if(param1)
         {
            _loc3_ = this.mCategorySelected == CATEGORY_1_OFFERS;
            _loc6_ = Config.getConfig().gameRewardedVideoCurrency();
            _loc7_ = _loc6_ == ServerConnection.CURRENCY_GOLD && this.mCategorySelected == CATEGORY_3_GOLD || _loc6_ == ServerConnection.CURRENCY_AH_TOKENS && this.mCategorySelected == CATEGORY_4_AH_TOKENS;
            _loc8_ = 0;
            while(_loc8_ < param1.length)
            {
               _loc2_ = param1[_loc8_];
               _loc4_ = this.canBeShown(_loc2_);
               _loc5_ = _loc3_ && Boolean(this.mOfferObjectDefCatalog) ? this.mOfferObjectDefCatalog[_loc2_] : null;
               if(_loc4_ && Boolean(_loc2_))
               {
                  this.addItemIntoContainer(new FSShopItem(_loc2_,_loc3_,_loc5_));
               }
               _loc8_++;
            }
            if(this.mItemsScrollContainer)
            {
               this.mItemsScrollContainer.readjustLayout();
               this.mItemsScrollContainer.validate();
            }
            this.handleArrowDown();
         }
      }
      
      private function handleArrowDown() : void
      {
         if(this.mArrowDown == null)
         {
            this.mArrowDown = new FSImage(Root.assets.getTexture("shop_arrow_down"));
            this.mArrowDown.touchable = false;
            this.mArrowDown.alignPivot();
            this.mArrowDown.x = this.mItemsScrollContainer ? this.mItemsScrollContainer.x + this.mItemsScrollContainer.width / 2 : 0;
            this.mArrowDown.y = this.mItemsScrollContainer ? this.mItemsScrollContainer.y + this.mItemsScrollContainer.height + this.mArrowDown.height / 1.75 : 0;
            addChild(this.mArrowDown);
         }
         TweenMax.killTweensOf(this.mArrowDown);
         this.mArrowDown.alpha = 0;
         if(Boolean(this.mItemsScrollContainer) && Boolean(this.mItemsScrollContainer.numChildren > 6) || this.mCategorySelected == CATEGORY_8_SKINS && this.mItemsScrollContainer.numChildren > 2)
         {
            SpecialFX.createYoYoAlphaTransition(this.mArrowDown,1);
         }
      }
      
      private function updateInfoText(param1:String) : void
      {
         if(this.mTopMenuContainer)
         {
            if(this.mInfoTextfield == null)
            {
               this.mInfoTextfield = new FSTextfield(mBGSprite.width * 0.95,this.mTopMenuContainer.height / 2,param1,16777215,FSResourceMng.FONT_STD_DEFAULT_SIZE);
               this.mInfoTextfield.x = (width - this.mInfoTextfield.width) / 2;
               this.mInfoTextfield.y = height - this.mInfoTextfield.height;
               addChild(this.mInfoTextfield);
            }
            else
            {
               this.mInfoTextfield.text = param1;
            }
         }
      }
      
      private function addItemIntoContainer(param1:FSShopItem) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:Def = null;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         if(this.mItemsScrollContainer == null && Boolean(this.mInfoTextfield))
         {
            this.mItemsScrollContainer = new ScrollContainer();
            this.mItemsScrollContainer.layout = this.getContainerLayout();
            this.mItemsScrollContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
            this.mItemsScrollContainer.verticalScrollPolicy = ScrollPolicy.ON;
            this.mItemsScrollContainer.width = width * 0.9;
            this.mItemsScrollContainer.height = mBGSprite.height * 0.9 - (this.mMenuButtonsContainer.y + this.mMenuButtonsContainer.height * 1.025);
            this.mItemsScrollContainer.x = (width - this.mItemsScrollContainer.width) / 2;
            this.mItemsScrollContainer.y = this.mMenuButtonsContainer.y + this.mMenuButtonsContainer.height * 1.15;
            addChild(this.mItemsScrollContainer);
         }
         if(this.mItemsScrollContainer)
         {
            this.mItemsScrollContainer.addChild(param1);
         }
         if(param1.getCardDef() != null)
         {
            this.addCardIntoDisposableCatalog(param1.getCardDef().getSku());
         }
         var _loc2_:UserData = Utils.getOwnerUserData();
         if(_loc2_)
         {
            _loc3_ = _loc2_.isPayingUser();
            _loc4_ = param1.getDef();
            _loc5_ = param1.getOfferGoldCost() > 0;
            if(_loc4_ is CardDef)
            {
               _loc4_ = InstanceMng.getRaritiesDefMng().getDefBySku(CardDef(_loc4_).getCardRarity());
            }
            _loc6_ = _loc3_ || _loc5_ || !_loc3_ && !_loc4_.shopDisplayOnlyToPayingUsers();
            if(!_loc6_)
            {
               param1.removeFromParent();
               if(this.mHiddenProdItems == null)
               {
                  this.mHiddenProdItems = new Vector.<FSShopItem>();
               }
               this.mHiddenProdItems.push(param1);
            }
         }
      }
      
      public function reviewVisibilityOfCurrentSectionItems() : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:Def = null;
         var _loc6_:Boolean = false;
         var _loc1_:UserData = Utils.getOwnerUserData();
         if(_loc1_)
         {
            _loc2_ = _loc1_.isPayingUser();
            _loc6_ = false;
            if(this.mHiddenProdItems)
            {
               _loc4_ = 0;
               while(_loc4_ < this.mHiddenProdItems.length)
               {
                  _loc5_ = FSShopItem(this.mHiddenProdItems[_loc4_]).getDef();
                  if(_loc5_ is CardDef)
                  {
                     _loc5_ = InstanceMng.getRaritiesDefMng().getDefBySku(CardDef(_loc5_).getCardRarity());
                  }
                  _loc3_ = _loc2_ || !_loc2_ && !_loc5_.shopDisplayOnlyToPayingUsers();
                  if(_loc3_)
                  {
                     if(Boolean(this.mItemsScrollContainer) && this.mHiddenProdItems[_loc4_].parent == null)
                     {
                        this.mItemsScrollContainer.addChild(this.mHiddenProdItems[_loc4_]);
                        _loc6_ = true;
                     }
                  }
                  _loc4_++;
               }
               if(_loc6_)
               {
                  this.mItemsScrollContainer.validate();
                  if(this.mHiddenProdItems)
                  {
                     this.mHiddenProdItems.length = 0;
                  }
               }
            }
         }
      }
      
      private function flushHiddenItems() : void
      {
         if(this.mHiddenProdItems)
         {
            Utils.destroyArray(this.mHiddenProdItems);
         }
      }
      
      private function addCardIntoDisposableCatalog(param1:String) : void
      {
         if(this.mDisposableCards == null)
         {
            this.mDisposableCards = new Dictionary(true);
         }
         if(this.mDisposableCards[param1] == null)
         {
            this.mDisposableCards[param1] = 1;
         }
      }
      
      public function addItemBGIntoNonDisposableCatalog(param1:String) : void
      {
         if(this.mNonDisposableTextureNames == null)
         {
            this.mNonDisposableTextureNames = new Dictionary(true);
         }
         if(this.mNonDisposableTextureNames[param1] == null)
         {
            this.mNonDisposableTextureNames[param1] = 1;
         }
      }
      
      private function getContainerLayout() : FlowLayout
      {
         var _loc1_:FlowLayout = new FlowLayout();
         _loc1_.verticalAlign = VerticalAlign.MIDDLE;
         _loc1_.horizontalAlign = HorizontalAlign.CENTER;
         _loc1_.verticalGap = 3;
         _loc1_.horizontalGap = 15;
         return _loc1_;
      }
      
      public function showMap() : void
      {
         dispatchEventWith(Screen.GO_TO_MAP,true);
      }
      
      override public function unload() : void
      {
         var _loc1_:Array = null;
         var _loc2_:String = null;
         var _loc3_:int = 0;
         DictionaryUtils.disposeCatalogCards(this.mDisposableCards,false,true);
         if(this.mGoldVisor)
         {
            this.mGoldVisor.removeFromParent(true);
            this.mGoldVisor = null;
         }
         if(this.mTokensVisor)
         {
            this.mTokensVisor.removeFromParent(true);
            this.mTokensVisor = null;
         }
         if(this.mQuestCoinsVisor)
         {
            this.mQuestCoinsVisor.removeFromParent(true);
            this.mQuestCoinsVisor = null;
         }
         if(this.mRaidCoinsVisor)
         {
            this.mRaidCoinsVisor.removeFromParent(true);
            this.mRaidCoinsVisor = null;
         }
         if(this.mOffersButton)
         {
            this.mOffersButton.removeFromParent(true);
            this.mOffersButton = null;
         }
         if(this.mPacksButton)
         {
            this.mPacksButton.removeFromParent(true);
            this.mPacksButton = null;
         }
         if(this.mGoldButton)
         {
            this.mGoldButton.removeFromParent(true);
            this.mGoldButton = null;
         }
         if(this.mAHTokensButton)
         {
            this.mAHTokensButton.removeFromParent(true);
            this.mAHTokensButton = null;
         }
         if(this.mQuestsButton)
         {
            this.mQuestsButton.removeFromParent(true);
            this.mQuestsButton = null;
         }
         if(this.mRaidsButton)
         {
            this.mRaidsButton.removeFromParent(true);
            this.mRaidsButton = null;
         }
         if(this.mBoostsButton)
         {
            this.mBoostsButton.removeFromParent(true);
            this.mBoostsButton = null;
         }
         if(this.mSkinsButton)
         {
            this.mSkinsButton.removeFromParent(true);
            this.mSkinsButton = null;
         }
         if(this.mMenuButtonsContainer)
         {
            this.mMenuButtonsContainer.removeFromParent(true);
            this.mMenuButtonsContainer = null;
         }
         if(this.mTopMenuContainer)
         {
            this.mTopMenuContainer.removeFromParent(true);
            this.mTopMenuContainer = null;
         }
         if(this.mItemsScrollContainer)
         {
            this.mItemsScrollContainer.removeChildren(0,-1,true);
            this.mItemsScrollContainer.removeFromParent(true);
            this.mItemsScrollContainer = null;
         }
         if(this.mInfoTextfield)
         {
            this.mInfoTextfield.removeFromParent(true);
            this.mInfoTextfield = null;
         }
         if(this.mItemBeingPurchased)
         {
            this.mItemBeingPurchased.removeFromParent(true);
            this.mItemBeingPurchased = null;
         }
         if(this.mArrowDown)
         {
            this.mArrowDown.removeFromParent(true);
            this.mArrowDown = null;
         }
         if(this.mHiddenProdItems)
         {
            Utils.destroyArray(this.mHiddenProdItems);
         }
         this.mHiddenProdItems = null;
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("frames",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("framesXL",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("framesFactionsRarities",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("portraits",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("animIcons",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         if(Config.getConfig().cardsHaveCustomAuras())
         {
            InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("anims/animAuras",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         }
         InstanceMng.getResourcesMng().removeSpecialScreenResources("customBGs");
         InstanceMng.getResourcesMng().removeResourcesFromFolder("customBGs");
         if(this.mNonDisposableTextureNames)
         {
            _loc1_ = DictionaryUtils.getKeys(this.mNonDisposableTextureNames);
            _loc2_ = "";
            if(_loc1_)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc1_.length)
               {
                  _loc2_ = _loc1_[_loc3_];
                  Root.assets.removeTexture(_loc2_);
                  _loc3_++;
               }
            }
         }
         this.mLastPurchaseAttempt = "";
         Utils.destroyArray(this.mOffersArray);
         this.mOffersArray = null;
         Utils.destroyArray(this.mPacksArray);
         this.mPacksArray = null;
         Utils.destroyArray(this.mGoldBagsArray);
         this.mGoldBagsArray = null;
         Utils.destroyArray(this.mAHTokensArray);
         this.mAHTokensArray = null;
         Utils.destroyArray(this.mQuestsProdsArray);
         this.mQuestsProdsArray = null;
         Utils.destroyArray(this.mRaidsProdsArray);
         this.mRaidsProdsArray = null;
         Utils.destroyArray(this.mBoostsArray);
         this.mBoostsArray = null;
         Utils.destroyArray(this.mSkinsArray);
         this.mSkinsArray = null;
         Utils.destroyArray(this.mAllHourlyOffersArray);
         this.mAllHourlyOffersArray = null;
         DictionaryUtils.clearDictionary(this.mWeeklyOffersCatalog);
         this.mWeeklyOffersCatalog = null;
         DictionaryUtils.clearDictionary(this.mHourlyOffersCatalog);
         this.mHourlyOffersCatalog = null;
         DictionaryUtils.clearDictionary(this.mOfferObjectDefCatalog);
         this.mOfferObjectDefCatalog = null;
         DictionaryUtils.clearDictionary(this.mDisposableCards);
         this.mDisposableCards = null;
         DictionaryUtils.clearDictionary(this.mNonDisposableTextureNames);
         this.mNonDisposableTextureNames = null;
         this.mBundleOfferDef = null;
         this.mBundleManualOfferDef = null;
         this.mBundleWelcomeBackDef = null;
         super.unload();
      }
      
      override public function removeTranslucentBG(param1:Boolean = false, param2:Boolean = false) : void
      {
         var _loc3_:Popup = InstanceMng.getPopupMng().getPopupShown();
         if(_loc3_ == null)
         {
            super.removeTranslucentBG(param1,param2);
         }
         if(Boolean(mSelectedCard) && !param2)
         {
            SpecialFX.zoomOut(mSelectedCard);
            mSelectedCard = null;
            if(_loc3_ != null)
            {
               _loc3_.visible = true;
            }
         }
      }
      
      public function beginPurchase(param1:FSShopItem, param2:Popup = null) : void
      {
         this.setItemBeingPurchased(param1);
         InstanceMng.getApplication().buyProduct(param1.getProdId(),param1.getDef().getSku());
         this.lockShopUI(true,param2);
         InstanceMng.getCurrentScreen().showLoadingIcon(true,false,Align.CENTER,Align.CENTER,1,null,param2);
      }
      
      public function getItemBeingPurchased() : FSShopItem
      {
         return this.mItemBeingPurchased;
      }
      
      public function setItemBeingPurchased(param1:FSShopItem) : void
      {
         this.mItemBeingPurchased = param1;
         if(param1)
         {
            this.mLastPurchaseAttempt = param1.getDef().getSku();
         }
      }
      
      public function getLastPurchaseAttemptSku() : String
      {
         return this.mLastPurchaseAttempt;
      }
      
      public function cleanLastPurchaseAttemptSku() : void
      {
         this.mLastPurchaseAttempt = "";
      }
      
      public function onItemPurchasedKO() : void
      {
         this.unlockAfterPurchase();
      }
      
      public function onItemPurchasedOK(param1:String) : void
      {
         var _loc2_:String = null;
         var _loc3_:Popup = null;
         if(this.mItemBeingPurchased != null)
         {
            if(param1 != null)
            {
               _loc2_ = Utils.isAndroid() ? this.mItemBeingPurchased.getProdId().toLowerCase() : this.mItemBeingPurchased.getProdId();
               if(param1.toLowerCase() == _loc2_.toLowerCase())
               {
                  _loc3_ = InstanceMng.getPopupMng().getPopupShown();
                  if(_loc3_ != null && !this.mItemBeingPurchased.isPack())
                  {
                     _loc3_.closePopup(this.mItemBeingPurchased.performOnBoughtOperations);
                  }
                  else
                  {
                     this.mItemBeingPurchased.performOnBoughtOperations();
                  }
               }
            }
         }
         this.unlockAfterPurchase();
      }
      
      public function unlockAfterPurchase() : void
      {
         if(this.mItemBeingPurchased)
         {
            this.mItemBeingPurchased.setEnabled(true);
         }
         this.setItemBeingPurchased(null);
         this.lockShopUI(false,InstanceMng.getPopupMng().getPopupShown());
         InstanceMng.getCurrentScreen().showLoadingIcon(false,false);
         this.reviewVisibilityOfCurrentSectionItems();
      }
      
      public function refreshPricesColors() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         if(this.mItemsScrollContainer != null)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mItemsScrollContainer.numChildren)
            {
               _loc1_ = this.mItemsScrollContainer.getChildAt(_loc2_);
               if(_loc1_ != null && _loc1_ is FSShopItem)
               {
                  FSShopItem(_loc1_).refreshPriceColor();
               }
               _loc2_++;
            }
         }
      }
      
      public function lockShopUI(param1:Boolean, param2:Popup = null) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         this.mUILocked = param1;
         if(this.mItemsScrollContainer != null)
         {
            this.mItemsScrollContainer.touchable = !this.mUILocked;
            _loc4_ = 0;
            while(_loc4_ < this.mItemsScrollContainer.numChildren)
            {
               _loc3_ = this.mItemsScrollContainer.getChildAt(_loc4_);
               if(_loc3_ != null)
               {
                  _loc3_.alpha = InstanceMng.getServerConnection().isUserLoggedIn() ? 0.999 : 0.5;
               }
               _loc4_++;
            }
         }
         if(param2 != null)
         {
            if(param2.hasCloseButton())
            {
               PopupStandard(param2).enableCloseButton(!param1);
            }
            if(param2 is PopupShopItem)
            {
               PopupShopItem(param2).enablePurchaseButton(!param1);
            }
         }
         if(this.mOffersButton)
         {
            this.mOffersButton.touchable = !param1;
            this.mOffersButton.setEnabled(!param1);
         }
         if(this.mPacksButton)
         {
            this.mPacksButton.touchable = !param1;
            this.mPacksButton.setEnabled(!param1);
         }
         if(this.mBoostsButton)
         {
            this.mBoostsButton.touchable = !param1;
            this.mBoostsButton.setEnabled(!param1);
         }
         if(this.mGoldVisor)
         {
            this.mGoldVisor.touchable = !param1;
         }
         if(getOptionsPanel())
         {
            getOptionsPanel().setEnabled(!param1);
         }
         if(mBackButton)
         {
            mBackButton.setEnabled(!param1);
         }
      }
      
      public function getCurrencyVisor(param1:String) : FSCurrencyVisor
      {
         var _loc2_:FSCurrencyVisor = null;
         switch(param1)
         {
            case ServerConnection.CURRENCY_GOLD:
               _loc2_ = this.mGoldVisor;
               break;
            case ServerConnection.CURRENCY_RAID_COINS:
               _loc2_ = this.mRaidCoinsVisor;
               break;
            case ServerConnection.CURRENCY_QUEST_COINS:
               _loc2_ = this.mQuestCoinsVisor;
               break;
            case ServerConnection.CURRENCY_AH_TOKENS:
               _loc2_ = this.mTokensVisor;
         }
         return _loc2_;
      }
      
      private function canBeShown(param1:Def) : Boolean
      {
         var _loc2_:Boolean = true;
         var _loc3_:Boolean = false;
         if(param1 is PackDef)
         {
            _loc3_ = PackDef(param1).isUniquePack();
            _loc2_ = !_loc3_ || _loc3_ && InstanceMng.getUserDataMng().getOwnerUserData().canActivatePack(PackDef(param1));
         }
         else if(param1 is AuctionTicketDef)
         {
            _loc3_ = AuctionTicketDef(param1).getIsUniquePack();
            _loc2_ = !_loc3_ || _loc3_ && InstanceMng.getUserDataMng().getOwnerUserData().canActivatePack(AuctionTicketDef(param1));
         }
         else if(param1 is HeroCharacterDef)
         {
            _loc2_ = !InstanceMng.getUserDataMng().getOwnerUserData().isSkinAvailable(param1.getSku());
         }
         else if(param1 is ShopBoostDef)
         {
            _loc2_ = InstanceMng.getUserDataMng().getOwnerUserData().getBoostAmount(ShopBoostDef(param1).getBoostSku()) == 0;
         }
         return _loc2_;
      }
      
      public function refreshPrices() : void
      {
         var _loc1_:Component = null;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         Utils.removeLog();
         if(this.mItemsScrollContainer)
         {
            _loc4_ = this.mItemsScrollContainer ? this.mItemsScrollContainer.numChildren : 0;
            _loc2_ = 0;
            while(_loc2_ < _loc4_)
            {
               _loc1_ = Component(this.mItemsScrollContainer.getChildAt(_loc2_));
               if(_loc1_ != null && _loc1_ is FSShopItem)
               {
                  FSShopItem(_loc1_).refreshPrice();
               }
               _loc2_++;
            }
         }
      }
      
      private function loadOfferAssets() : void
      {
         if(!Root.assets.isLoading)
         {
            showLoadingIcon(true,true);
            this.loadAssetsByCatalog(this.mHourlyOffersCatalog);
            this.loadAssetsByCatalog(this.mWeeklyOffersCatalog);
            this.loadCustomOffersAssets();
            InstanceMng.getResourcesMng().loadAssets(this.onOffersAssetsLoaded);
         }
         else
         {
            TweenMax.delayedCall(0.25,this.loadOfferAssets);
         }
      }
      
      private function loadCustomOffersAssets() : void
      {
         if(this.mBundleOfferDef)
         {
            this.loadBundleAssets(this.mBundleOfferDef);
         }
         if(this.mBundleManualOfferDef)
         {
            this.loadBundleAssets(this.mBundleManualOfferDef);
         }
         if(this.mBundleWelcomeBackDef)
         {
            this.loadBundleAssets(this.mBundleWelcomeBackDef);
         }
      }
      
      private function loadBundleAssets(param1:BundleDef) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:CardDef = null;
         var _loc5_:int = 0;
         var _loc6_:HeroCharacterDef = null;
         if(param1)
         {
            _loc2_ = param1.getCards();
            if(_loc2_ != null && _loc2_.length > 0)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc2_.length)
               {
                  _loc4_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc2_[_loc5_]));
                  if(_loc4_)
                  {
                     InstanceMng.getResourcesMng().loadCardImagesByCardDef(_loc4_,true,true);
                     this.addCardIntoDisposableCatalog(_loc4_.getSku());
                  }
                  _loc5_++;
               }
            }
            _loc3_ = param1.getSkins();
            if(Boolean(_loc3_) && _loc3_.length > 0)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc3_.length)
               {
                  _loc6_ = HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(_loc3_[_loc5_]));
                  InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + _loc6_.getBGImageName(),FSResourceMng.TYPE_TEXTURE_PNG);
                  _loc5_++;
               }
            }
         }
      }
      
      private function onOffersAssetsLoaded(param1:* = null) : void
      {
         var _loc2_:String = null;
         FSDebug.debugTrace("All OFfer Assets loaded");
         this.mOffersAssetsLoaded = true;
         showLoadingIcon(false,true);
         showLoadingIcon(false,false);
         if(isFullyLoaded() && this.mCategorySelected == CATEGORY_1_OFFERS)
         {
            this.refreshButtons();
            InstanceMng.getUserDataMng().getOwnerUserData().setCustomOfferNewBannerShown(false);
            _loc2_ = TextManager.getText("TID_SHOP_DESC_OFFERS");
            this.updateInfoText(_loc2_);
            if(this.mBundleWelcomeBackDef)
            {
               this.addItemIntoContainer(new FSShopItem(this.mBundleWelcomeBackDef,true));
            }
            if(this.mBundleManualOfferDef)
            {
               this.addItemIntoContainer(new FSShopItem(this.mBundleManualOfferDef,true));
            }
            if(this.mBundleOfferDef)
            {
               this.addItemIntoContainer(new FSShopItem(this.mBundleOfferDef,true));
            }
            this.processItemsIntoContainer(this.mOffersArray);
         }
         this.lockShopUI(false);
         TweenMax.killDelayedCallsTo(this.checkStateAfterOffersRequest);
         this.mRefreshingOffers = false;
      }
      
      private function loadAssetsByCatalog(param1:Dictionary) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Def = null;
         if(param1)
         {
            for each(_loc2_ in param1)
            {
               _loc3_ = this.getDefByServerProduct(_loc2_);
               if(Boolean(_loc2_) && _loc2_.type == 0)
               {
                  if(_loc3_ is CardDef)
                  {
                     InstanceMng.getResourcesMng().loadCardImagesByCardDef(CardDef(_loc3_),true,true);
                     this.addCardIntoDisposableCatalog(_loc3_.getSku());
                  }
               }
            }
         }
      }
      
      private function getDefByServerProduct(param1:Object) : Def
      {
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:Def = null;
         var _loc3_:String = param1.shortCode;
         var _loc4_:String = param1.sku;
         var _loc5_:Boolean = _loc3_ == "CARD_CUSTOM";
         var _loc6_:Boolean = _loc3_ == "PACK_CUSTOM";
         var _loc7_:String = _loc3_ == null || _loc5_ ? _loc4_ : _loc3_;
         var _loc8_:CardDef = _loc5_ ? CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc7_)) : CardDef(InstanceMng.getCardsDefMng().getDefByVGoodShortCode(_loc7_));
         if(_loc8_)
         {
            return _loc8_;
         }
         var _loc9_:PackDef = _loc6_ ? PackDef(InstanceMng.getPacksDefMng().getDefBySku(_loc4_)) : PackDef(InstanceMng.getPacksDefMng().getDefByVGoodShortCode(_loc7_));
         if(_loc9_)
         {
            return _loc9_;
         }
         var _loc10_:GoldDef = GoldDef(InstanceMng.getGoldDefMng().getDefByVGoodShortCode(_loc7_));
         if(_loc10_)
         {
            return _loc10_;
         }
         var _loc11_:AuctionTicketDef = AuctionTicketDef(InstanceMng.getAuctionTicketsDefMng().getDefByVGoodShortCode(_loc7_));
         if(_loc11_)
         {
            return _loc11_;
         }
         var _loc12_:PortraitDef = PortraitDef(InstanceMng.getPortraitsDefMng().getDefByVGoodShortCode(_loc7_));
         if(_loc12_)
         {
            return _loc12_;
         }
         return _loc2_;
      }
      
      private function requestOffers() : void
      {
         if(this.mItemsScrollContainer)
         {
            this.mItemsScrollContainer.removeChildren();
         }
         if(isFullyLoaded())
         {
            this.lockShopUI(true);
            showLoadingIcon(true,false);
         }
         TweenMax.delayedCall(5,this.checkStateAfterOffersRequest);
         DictionaryUtils.clearDictionary(this.mWeeklyOffersCatalog);
         DictionaryUtils.clearDictionary(this.mHourlyOffersCatalog);
         DictionaryUtils.clearDictionary(this.mOfferObjectDefCatalog);
         if(this.mOffersArray)
         {
            this.mOffersArray.length = 0;
         }
         if(this.mAllHourlyOffersArray)
         {
            this.mAllHourlyOffersArray.length = 0;
         }
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            InstanceMng.getServerConnection().getOffers(this.onOffersACK);
         }
         else
         {
            this.checkStateAfterOffersRequest();
         }
      }
      
      private function checkStateAfterOffersRequest() : void
      {
         if(this.mCategorySelected == CATEGORY_1_OFFERS && this.mUILocked)
         {
            this.lockShopUI(false);
            Utils.setLogText(TextManager.getText("TID_GEN_SERVER_RETRY"));
         }
      }
      
      private function onOffersACK(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         FSDebug.debugTrace("Processing offers...");
         if(isFullyLoaded())
         {
            if(param1 != null)
            {
               _loc3_ = param1[0]["WeeklyOffer1"];
               _loc4_ = param1[0]["WeeklyOffer2"];
               _loc5_ = param1[0]["HourlyOffer1"];
               _loc6_ = param1[0]["HourlyOffer2"];
               _loc7_ = param1[0]["HourlyOffer3"];
               _loc8_ = param1[0]["HourlyOffer4"];
               this.addToHourlyOffers(_loc5_);
               this.addToHourlyOffers(_loc6_);
               this.addToHourlyOffers(_loc7_);
               this.addToHourlyOffers(_loc8_);
               this.addToWeeklyOffers(_loc3_);
               this.addToWeeklyOffers(_loc4_);
               if(this.mHourlyOffersCatalog == null)
               {
                  this.mHourlyOffersCatalog = new Dictionary(true);
               }
               this.mHourlyOffersCatalog[0] = _loc5_;
               this.mHourlyOffersCatalog[1] = _loc6_;
               this.mHourlyOffersCatalog[2] = _loc7_;
               this.mHourlyOffersCatalog[3] = _loc8_;
               this.loadOfferAssets();
            }
         }
         else
         {
            setTimeout(this.onOffersACK,250,param1);
         }
      }
      
      private function addToWeeklyOffers(param1:Object) : void
      {
         if(this.mWeeklyOffersCatalog == null)
         {
            this.mWeeklyOffersCatalog = new Dictionary(true);
         }
         this.mWeeklyOffersCatalog[DictionaryUtils.getDictionaryLength(this.mWeeklyOffersCatalog)] = param1;
         this.processOffer(param1);
      }
      
      private function addToHourlyOffers(param1:Object) : void
      {
         if(this.mAllHourlyOffersArray == null)
         {
            this.mAllHourlyOffersArray = new Array();
         }
         this.mAllHourlyOffersArray.push(param1);
         this.processOffer(param1);
      }
      
      private function processOffer(param1:Object) : void
      {
         if(this.mOfferObjectDefCatalog == null)
         {
            this.mOfferObjectDefCatalog = new Dictionary(true);
         }
         var _loc2_:Def = this.getDefByServerProduct(param1);
         if(_loc2_)
         {
            this.mOfferObjectDefCatalog[_loc2_] = param1;
            if(this.mOffersArray == null)
            {
               this.mOffersArray = new Array();
            }
            this.mOffersArray.push(_loc2_);
         }
      }
      
      private function isAnyOfferExpired() : Boolean
      {
         var _loc2_:Object = null;
         var _loc1_:Boolean = false;
         for each(_loc2_ in this.mOfferObjectDefCatalog)
         {
            if(Boolean(_loc2_) && _loc2_.expirationTimeMS - ServerConnection.smServerTimeMS <= 0)
            {
               return true;
            }
         }
         return _loc1_;
      }
      
      public function isBGBDisposable(param1:String) : Boolean
      {
         var _loc2_:Boolean = true;
         if(this.mNonDisposableTextureNames)
         {
            return this.mNonDisposableTextureNames[param1] == null;
         }
         return _loc2_;
      }
      
      public function getNonDisposableTextureNames() : Dictionary
      {
         return this.mNonDisposableTextureNames;
      }
      
      override public function getGoldVisor() : *
      {
         return this.mGoldVisor;
      }
      
      public function isItemsScrollContainerScrolling() : Boolean
      {
         return Boolean(this.mItemsScrollContainer) && this.mItemsScrollContainer.isScrolling;
      }
      
      private function handleBundlesLocalNotification(param1:Number) : void
      {
         var scheduleNotifications:Function = null;
         var userData:UserData = null;
         var isAuthorisedForNotifs:Boolean = false;
         var text:String = null;
         var delay:Number = param1;
         scheduleNotifications = function():void
         {
            InstanceMng.getApplication().scheduleNotifications(delay,Constants.NOTIF_OFFERS_EXPIRING);
         };
         if(Utils.isMobile() && !Utils.isSimulator())
         {
            userData = Utils.getOwnerUserData();
            if(Boolean(userData) && userData.flagsOfflinePushNotifsGranted())
            {
               isAuthorisedForNotifs = InstanceMng.getApplication().getOfflinePushNotificationsMng() ? Boolean(InstanceMng.getApplication().getOfflinePushNotificationsMng().isAuthorised()) : true;
               if(isAuthorisedForNotifs || Utils.isAndroid())
               {
                  scheduleNotifications();
               }
               else
               {
                  text = TextManager.getText("TID_PERMISSIONS_OFFERS");
                  InstanceMng.getPopupMng().openConfirmationPopup(text,scheduleNotifications,scheduleNotifications);
               }
            }
         }
      }
      
      override public function addLights(param1:Boolean = false, param2:Boolean = false) : void
      {
         super.addLights(false,true);
      }
   }
}

