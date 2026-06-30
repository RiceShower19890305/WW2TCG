package com.fs.tcgengine.screens
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.JobsMng;
   import com.fs.tcgengine.controller.PvPConnectionMng;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.controller.rules.CategoriesDefMng;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.EditionDef;
   import com.fs.tcgengine.model.rules.JobDef;
   import com.fs.tcgengine.model.rules.PowerDef;
   import com.fs.tcgengine.model.rules.TutorialDeckBuilderDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.DeckBuilderCard;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.InfoCard;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.buttons.FSToggleButton;
   import com.fs.tcgengine.view.components.misc.FSCurrencyVisor;
   import com.fs.tcgengine.view.components.misc.FSTextInput;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.components.shop.ShopMenuButton;
   import com.fs.tcgengine.view.deckbuilder.RecycleCardsPanel;
   import com.fs.tcgengine.view.misc.DeckCardsPanel;
   import com.fs.tcgengine.view.misc.DeckCraftInfoPanel;
   import com.fs.tcgengine.view.misc.DeckJobConfigurator;
   import com.fs.tcgengine.view.misc.DeckSelector;
   import com.fs.tcgengine.view.misc.DeckTitleDeckBuilder;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.misc.JobPanel;
   import com.greensock.TweenMax;
   import feathers.controls.ScrollContainer;
   import feathers.controls.ScrollPolicy;
   import feathers.events.FeathersEventType;
   import feathers.layout.HorizontalAlign;
   import feathers.layout.HorizontalLayout;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import starling.core.Starling;
   import starling.display.Quad;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Align;
   
   public class FSDeckBuilderScreen extends Screen
   {
      
      public static const COLLECTION_CONTAINER_WIDTH:int = Starling.current.stage.stageWidth * 0.63;
      
      public static const COLLECTION_CONTAINER_HEIGHT:int = Starling.current.stage.stageHeight * 0.629;
      
      public static const DECK_SELECTOR_Y:int = Starling.current.stage.stageHeight * 0.135;
      
      public static const DECK_TITLE_BOX_Y:int = Starling.current.stage.stageHeight * 0.07;
      
      public static const STATUS_NOT_EDITING:int = 0;
      
      public static const STATUS_EDITING:int = 1;
      
      public static const STATUS_CREATION_MODE:int = 2;
      
      public static const FILTER_OFF_NAME:String = "db_filter_off";
      
      public static const FILTER_ON_NAME:String = "db_filter_on";
      
      public static const VIEW_ALL_CARDS_FILTER_ON_NAME:String = "db_button_craft_on";
      
      public static const VIEW_ALL_CARDS_FILTER_OFF_NAME:String = "db_button_craft_off";
      
      public static const CRAFT_MODE_ON:Boolean = Config.getConfig().getDeckBuilderCraftMode();
      
      private const DECK_TITLE_NAME:String = "deck_title_edit";
      
      private const UNITS_TAB_BG_NAME:String = "tab_unit";
      
      private const ATTACHMENTS_TAB_BG_NAME:String = "tab_item";
      
      private const ORDERS_TAB_BG_NAME:String = "tab_order";
      
      private const POWERS_TAB_BG_NAME:String = "tab_power";
      
      private const COST_FILTER:String = "cost_filter";
      
      private const FACTIONS_FILTER:String = "factions_filter";
      
      private const SUBCATEGORIES_FILTER:String = "subcategories_filter";
      
      private const RARITIES_FILTER:String = "rarities_filter";
      
      private const EDITION_FILTER:String = "edition_filter";
      
      private const FAVOURITE_FILTER:String = "favourite_filter";
      
      private const NEW_FILTER:String = "new_filter";
      
      private const ABILITY_FILTER:String = "ability_filter";
      
      private const ALL_CARDS_FILTER:String = "allcards_filter";
      
      private const FILTERS_CONTAINER_POSITION_FACTOR:Number = 0.875;
      
      private var mCollectionContainer:Component;
      
      private var mInvisibleQuad:Quad;
      
      private var mDeckSelector:DeckSelector;
      
      private var mDeckTitleBox:FSImage;
      
      private var mDeckTitleTextInput:FSTextInput;
      
      private var mDeckTitleLabel:FSTextfield;
      
      protected var mDeckCardsPanel:DeckCardsPanel;
      
      protected var mDeckCraftInfoPanel:DeckCraftInfoPanel;
      
      private var mUnitsCollection:Dictionary;
      
      private var mAttachmentsCollection:Dictionary;
      
      private var mOrdersCollection:Dictionary;
      
      private var mPowersCollection:Dictionary;
      
      protected var mUnitsTab:ShopMenuButton;
      
      private var mAttachmentsTab:ShopMenuButton;
      
      private var mActionsTab:ShopMenuButton;
      
      private var mPowersTab:ShopMenuButton;
      
      protected var mCategorySelected:int;
      
      private var mUIInitialized:Boolean = false;
      
      protected var mSubcategoriesToShowCatalog:Dictionary;
      
      protected var mSearchFilter:String;
      
      protected var mRaritiesToShowCatalog:Dictionary;
      
      protected var mSummonCostToShowCatalog:Dictionary;
      
      protected var mEditionsToShowCatalog:Dictionary;
      
      protected var mSubfilterButtonsContainer:ScrollContainer;
      
      protected var mSubfiltersContainer:Component;
      
      private var mCurrentCollectionOnFilters:Dictionary;
      
      protected var mFactionsToShowCatalog:Dictionary;
      
      protected var mFiltersContainer:ScrollContainer;
      
      protected var mSubFiltersContainerBG1:Quad;
      
      protected var mSubFiltersContainerBG2:Quad;
      
      private var mEdidionStatus:int;
      
      private var mEditButton:FSButton;
      
      private var mCollectionFilteredWithDeck:Dictionary;
      
      private var mCardInfoCatalog:Dictionary;
      
      private var mExitRequested:Boolean = false;
      
      private var mRecycleButton:FSButton;
      
      protected var mRecyclePanel:RecycleCardsPanel;
      
      private var mIsRecyclingMode:Boolean = false;
      
      private var mCardInTransition:Boolean = false;
      
      private var mIsLocked:Boolean = false;
      
      private var mGoldVisor:FSCurrencyVisor;
      
      protected var mCurrentPage:int = 0;
      
      private var mInitialCardsLoaded:Boolean = false;
      
      protected var mDownArrow:FSButton;
      
      protected var mUpArrow:FSButton;
      
      private var mPageIndicatorTextfield:FSTextfield;
      
      private var mDeckValueIndicatorTextfield:FSTextfield;
      
      private var mViewAllCraftableCardsButton:FSToggleButton;
      
      private var mTutorialRequested:Boolean = false;
      
      private var mCollectionScrollerHovered:Boolean;
      
      private var mCollectionScrollable:Boolean = true;
      
      private var mCollectionRarities:Dictionary;
      
      private var mIsCraftFilterON:Boolean = false;
      
      private var mIsAnyCardCrafteable:Boolean;
      
      private var mIsCraftingON:Boolean = false;
      
      private var mCraftPanelShown:Boolean = false;
      
      private var mSummonCostFilterButton:ShopMenuButton;
      
      private var mFactionFilterButton:ShopMenuButton;
      
      private var mSubCategoriesFilterButton:ShopMenuButton;
      
      private var mRaritiesFilterButton:ShopMenuButton;
      
      private var mEditionFilterButton:ShopMenuButton;
      
      private var mAbilityFilterButton:ShopMenuButton;
      
      private var mFavouritesFilterButton:ShopMenuButton;
      
      private var mNewCardsFilterButton:ShopMenuButton;
      
      private var mAllCardsFilterButton:ShopMenuButton;
      
      private var mJobPanel:JobPanel;
      
      private var mRaidCoinsText:FSTextfield;
      
      private var mCurrentPageCardsSorted:Array;
      
      private var mCurrentJobDefSelected:JobDef;
      
      private var mFilteringOnlyNewCards:Boolean = false;
      
      private var mFilteringOnlyFavouriteCards:Boolean = false;
      
      private var mCurrentHoveredCard:FSCard;
      
      private var mFilteringAllCards:Boolean = false;
      
      public function FSDeckBuilderScreen()
      {
         this.initializeSummonCostsFilters();
         this.mFactionsToShowCatalog = this.initializeSubfilters(this.mFactionsToShowCatalog,InstanceMng.getFactionsDefMng().getAllDefs(),this.FACTIONS_FILTER);
         this.mSubcategoriesToShowCatalog = this.initializeSubfilters(this.mSubcategoriesToShowCatalog,InstanceMng.getSubCategoriesDefMng().getAllDefs(),this.SUBCATEGORIES_FILTER);
         this.mRaritiesToShowCatalog = this.initializeSubfilters(this.mRaritiesToShowCatalog,InstanceMng.getRaritiesDefMng().getAllDefs(),this.RARITIES_FILTER);
         this.mEditionsToShowCatalog = this.initializeSubfilters(this.mEditionsToShowCatalog,InstanceMng.getEditionsDefMng().getGameEditionsInfo(),this.EDITION_FILTER);
         mNeedsLoadingBar = true;
         mBGName = Constants.DECK_BUILDER_BG_NAME;
         mScreenName = Constants.DECK_BUILDER_SCREEN_NAME;
         this.performCheckDefaultPowers();
         this.fillCollections();
         this.checkIfAnyCardCrafteable();
         if(InstanceMng.getServerConnection())
         {
            InstanceMng.getServerConnection().addUserActionBlock();
         }
         super();
      }
      
      private function performCheckDefaultPowers() : void
      {
         var _loc1_:UserData = null;
         var _loc2_:PowerDef = null;
         var _loc3_:int = 0;
         if(Config.getConfig().gameHasPowers())
         {
            _loc1_ = Utils.getOwnerUserData();
            if(Boolean(_loc1_) && Boolean(InstanceMng.getServerConnection()) && InstanceMng.getServerConnection().isUserLoggedIn())
            {
               _loc2_ = InstanceMng.getPowerDefMng() ? InstanceMng.getPowerDefMng().getDefByIndex(0) : null;
               if(_loc2_)
               {
                  _loc3_ = Boolean(_loc1_.getCardCollection()) && Boolean(_loc1_.getCardCollection()[_loc2_.getSku()]) ? int(_loc1_.getCardCollection()[_loc2_.getSku()]) : 0;
                  if(_loc3_ == 0)
                  {
                     _loc1_.addCardToCollection(_loc2_.getSku() + ":1");
                     InstanceMng.getUserDataMng().updateCollection();
                  }
               }
            }
         }
      }
      
      public function checkIfAnyCardCrafteable(param1:Boolean = false) : void
      {
         if(Config.getConfig().getDeckBuilderCraftMode() && param1)
         {
            InstanceMng.getCardsDefMng().isAnyCardCrafteable();
         }
         this.mIsAnyCardCrafteable = Config.getConfig().getDeckBuilderCraftMode() && Root.smCraftsAvailable;
      }
      
      public function getIsAnyCardCrafteable() : Boolean
      {
         return this.mIsAnyCardCrafteable;
      }
      
      override protected function setResourcesToLoad() : void
      {
         super.setResourcesToLoad();
         if(Config.getConfig().useDeckBuilderThumbnails())
         {
            InstanceMng.getResourcesMng().addResourcesFolderByName("cards_thumbs");
         }
         if(Config.getConfig().gameHasPowers())
         {
            InstanceMng.getResourcesMng().addResourcesFolderByName("powers_thumbs");
         }
         InstanceMng.getResourcesMng().addResourceToLoad("misc/" + Constants.SOUND_PANEL_DOWN,FSResourceMng.TYPE_AUDIO);
         if(Config.getConfig().gameHasTierFrames())
         {
            InstanceMng.getResourcesMng().addResourcesFolderByName("frames");
         }
         InstanceMng.getResourcesMng().addResourcesFolderByName("framesFactionsRarities");
         if(Config.getConfig().cardsHaveCustomAuras())
         {
            InstanceMng.getResourcesMng().addResourcesFolderByName("anims/animAuras");
         }
         InstanceMng.getResourcesMng().addResourceToLoad("misc/firework",FSResourceMng.TYPE_AUDIO);
         InstanceMng.getResourcesMng().addResourceToLoad("misc/pre_firework",FSResourceMng.TYPE_AUDIO);
         InstanceMng.getResourcesMng().loadAssets();
      }
      
      override public function notifyAssetsLoaded(param1:* = null) : void
      {
         var _loc3_:Dictionary = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:JobDef = null;
         var _loc7_:int = 0;
         if(!this.mUIInitialized)
         {
            super.notifyAssetsLoaded();
            this.createUI();
            _loc3_ = InstanceMng.getUserDataMng().getOwnerUserData().getDeck(0);
            _loc4_ = false;
            if(Config.getConfig().gameHasClassSystem())
            {
               _loc6_ = JobDef(InstanceMng.getJobsDefMng().getDefBySku("job_01"));
               _loc4_ = JobsMng.haveEnoughCardsForJob(_loc6_);
            }
            else
            {
               _loc7_ = DictionaryUtils.getCatalogCardsAmountCheckingRestrictions(InstanceMng.getUserDataMng().getOwnerUserData().getCardCollection(),true,Config.getConfig().getDeckCardsAmount());
               _loc4_ = _loc7_ >= Config.getConfig().getDeckCardsAmount();
            }
            _loc5_ = _loc4_ && (_loc3_ == null || _loc3_ != null && DictionaryUtils.getDictionaryLength(_loc3_) == 0);
            this.mTutorialRequested = !InstanceMng.getUserDataMng().getOwnerUserData().flagsGetDeckBuilderTutorialShown() && _loc5_;
         }
         var _loc2_:Boolean = !this.mInitialCardsLoaded;
         if(_loc2_)
         {
            this.mInitialCardsLoaded = true;
         }
         this.createCollectionContainer(_loc2_);
      }
      
      private function createUI() : void
      {
         this.createTabs();
         this.createDeckSelector();
         this.createDeckTitle();
         this.createGoldVisor();
         this.createCollectionContainer(false,false);
         this.createFilterButtonsContainer();
         this.createBottomFilters();
         this.createUpAndDownArrows();
         this.createViewAllFilterButton();
         this.createRecycleButton();
         this.createCurrentPageTextfield();
         this.createDeckValueTextfield();
         this.mUIInitialized = true;
         reAddUIVisualsOptions();
      }
      
      private function createFilterButtonsContainer() : void
      {
         var _loc1_:HorizontalLayout = null;
         if(this.mFiltersContainer == null)
         {
            this.mFiltersContainer = new ScrollContainer();
            this.mFiltersContainer.name = "faction_filter_container";
            _loc1_ = new HorizontalLayout();
            _loc1_.horizontalAlign = HorizontalAlign.LEFT;
            this.mFiltersContainer.layout = _loc1_;
            this.mFiltersContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
            this.mFiltersContainer.verticalScrollPolicy = ScrollPolicy.OFF;
            this.mFiltersContainer.x = this.mUnitsTab.x;
            this.mFiltersContainer.y = Starling.current.stage.stageHeight - this.mFiltersContainer.height;
            addChild(this.mFiltersContainer);
         }
      }
      
      private function setFilterButtonsTouchable(param1:Boolean) : void
      {
         if(this.mFiltersContainer)
         {
            this.mFiltersContainer.touchable = param1;
         }
         if(this.mSubfilterButtonsContainer)
         {
            this.mSubfilterButtonsContainer.touchable = param1;
         }
      }
      
      private function createBottomFilters() : void
      {
         if(Config.getConfig().getShowSummonCost())
         {
            this.mSummonCostFilterButton = this.createFilterButton("db_filter_icon_cost",this.COST_FILTER,false,TextManager.getText("TID_FILTER_SUMMON_COST"));
         }
         if(Config.getConfig().deckBuilderShowsFactionButtons())
         {
            this.mFactionFilterButton = this.createFilterButton("db_filter_icon_faction",this.FACTIONS_FILTER,false,TextManager.getText("TID_FILTER_FACTION"));
         }
         if(Config.getConfig().deckBuilderShowsSCategoriesButtons())
         {
            this.mSubCategoriesFilterButton = this.createFilterButton("db_filter_icon_scategory",this.SUBCATEGORIES_FILTER,false,TextManager.getText("TID_FILTER_SCATEGORIES"));
         }
         this.mRaritiesFilterButton = this.createFilterButton("db_filter_icon_rarity",this.RARITIES_FILTER,false,TextManager.getText("TID_FILTER_RARITY"));
         if(InstanceMng.getEditionsDefMng().getGameEditionsAmount() > 0)
         {
            this.mEditionFilterButton = this.createFilterButton("db_filter_icon_edition",this.EDITION_FILTER,false,TextManager.getText("TID_FILTER_GAME_EDITION"));
         }
         this.mFavouritesFilterButton = this.createFilterButton("db_filter_icon_favourite",this.FAVOURITE_FILTER,false,TextManager.getText("TID_FILTER_FAVOURITES"));
         this.mNewCardsFilterButton = this.createFilterButton("db_filter_icon_new",this.NEW_FILTER,false,TextManager.getText("TID_FILTER_NEW_CARDS"));
         this.mAbilityFilterButton = this.createFilterButton("db_filter_icon_ability",this.ABILITY_FILTER,false,TextManager.getText("TID_FILTER_ABILITY_DESC"));
         this.mAllCardsFilterButton = this.createFilterButton("db_icon_view_all",this.ALL_CARDS_FILTER,false,TextManager.getText("TID_GEN_VIEW_CARDS"));
      }
      
      private function initializeSummonCostsFilters() : void
      {
         this.mSummonCostToShowCatalog = new Dictionary(true);
         var _loc1_:int = 0;
         while(_loc1_ <= 7)
         {
            this.mSummonCostToShowCatalog[_loc1_] = true;
            _loc1_++;
         }
      }
      
      private function initializeSubfilters(param1:Dictionary, param2:Dictionary, param3:String = "") : Dictionary
      {
         var _loc5_:Def = null;
         param1 = new Dictionary(true);
         var _loc4_:Array = DictionaryUtils.sortDictionaryByKey(param2);
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_.length)
         {
            _loc5_ = param2[_loc4_[_loc6_].key];
            if(param3 != this.EDITION_FILTER)
            {
               param1[_loc5_.getSku()] = true;
            }
            else
            {
               param1[EditionDef(_loc5_).getGameIndex()] = true;
            }
            _loc6_++;
         }
         return param1;
      }
      
      private function onSummonCostToggleTouch(param1:Event) : void
      {
         var _loc2_:ShopMenuButton = ShopMenuButton(FSButton(param1.currentTarget).parent);
         this.onSubfilterToggled(_loc2_,this.mSummonCostToShowCatalog);
         this.mSummonCostFilterButton.updateText(_loc2_.getButtonText());
      }
      
      private function createFilterButton(param1:String, param2:String = "", param3:Boolean = false, param4:String = "") : ShopMenuButton
      {
         var _loc5_:ShopMenuButton = new ShopMenuButton(param3,param2,param1,FILTER_ON_NAME,FILTER_OFF_NAME,this.onFilterButtonTriggered,"",Align.CENTER,0);
         if(param4 != "" && Boolean(param4))
         {
            _loc5_.setTooltipText(param4);
         }
         _loc5_.name = param2;
         this.mFiltersContainer.height = _loc5_.height * 1.05;
         this.mFiltersContainer.y = Starling.current.stage.stageHeight - _loc5_.height * 1.05;
         this.mFiltersContainer.addChild(_loc5_);
         return _loc5_;
      }
      
      private function onFilterButtonTriggered(param1:Event) : void
      {
         var _loc2_:String = null;
         var _loc3_:ShopMenuButton = null;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         if(this.mFiltersContainer)
         {
            _loc2_ = ShopMenuButton(FSButton(param1.currentTarget).parent).name;
            ShopMenuButton(FSButton(param1.currentTarget).parent).setIsSelected(true);
            ShopMenuButton(FSButton(param1.currentTarget).parent).closeTooltip();
            _loc5_ = 0;
            while(_loc5_ < this.mFiltersContainer.numChildren)
            {
               _loc3_ = ShopMenuButton(this.mFiltersContainer.getChildAt(_loc5_));
               _loc4_ = _loc3_ != null && (_loc3_.name != this.ABILITY_FILTER || _loc3_.name == this.ABILITY_FILTER && this.mSearchFilter == "");
               if(Boolean(_loc3_ && _loc3_.name != ShopMenuButton(FSButton(param1.currentTarget).parent).name && _loc3_.name != this.FAVOURITE_FILTER && _loc3_.name != this.NEW_FILTER) && Boolean(_loc3_.name != this.ALL_CARDS_FILTER) && _loc4_)
               {
                  _loc3_.setIsSelected(false);
               }
               _loc5_++;
            }
         }
         if(_loc2_ != this.FAVOURITE_FILTER && _loc2_ != this.NEW_FILTER && _loc2_ != this.ALL_CARDS_FILTER)
         {
            this.showSubFiltersBySection(_loc2_);
         }
         else if(_loc2_ == this.NEW_FILTER)
         {
            this.onNewCardsToggleTouch(param1);
         }
         else if(_loc2_ == this.FAVOURITE_FILTER)
         {
            this.onFavouritesToggleTouch(param1);
         }
         else if(_loc2_ == this.ALL_CARDS_FILTER)
         {
            this.onAllCardsToggleTouch(param1);
         }
      }
      
      private function showSubFiltersBySection(param1:String) : void
      {
         this.createSubfilterButtonsContainer();
         switch(param1)
         {
            case this.COST_FILTER:
               this.createSubfilterButtons(param1,"db_filter_icon_cost",this.onSummonCostToggleTouch,this.mSummonCostToShowCatalog);
               break;
            case this.FACTIONS_FILTER:
               this.createSubfilterButtons(param1,"db_filter_icon_faction",this.onFactionToggleTouch,this.mFactionsToShowCatalog,InstanceMng.getFactionsDefMng().getAllDefs());
               break;
            case this.SUBCATEGORIES_FILTER:
               this.createSubfilterButtons(param1,"db_filter_icon_scategory",this.onSubcategoryToggleTouch,this.mSubcategoriesToShowCatalog,InstanceMng.getSubCategoriesDefMng().getAllDefs());
               break;
            case this.RARITIES_FILTER:
               this.createSubfilterButtons(param1,"db_filter_icon_rarity",this.onRaritiesToggleTouch,this.mRaritiesToShowCatalog,InstanceMng.getRaritiesDefMng().getAllDefs());
               break;
            case this.EDITION_FILTER:
               if(InstanceMng.getEditionsDefMng().getGameEditionsAmount() > 0)
               {
                  this.createSubfilterButtons(param1,"db_filter_icon_edition",this.onEditionsToggleTouch,this.mEditionsToShowCatalog,InstanceMng.getEditionsDefMng().getGameEditionsInfo());
               }
               break;
            case this.ABILITY_FILTER:
               this.createSubfilterButtons(param1,"db_filter_icon_scategory",this.onAbilitiesFilterToggleTouch,null);
         }
         this.addFiltersDoneButton();
         addChild(this.mSubfiltersContainer);
         if(this.mFiltersContainer)
         {
            SpecialFX.createTransition(this.mSubfiltersContainer,new FSCoordinate(0,Starling.current.stage.stageHeight - this.mSubfiltersContainer.height),0.25);
         }
      }
      
      private function setupCraftInfoPanel() : void
      {
         this.showCraftInfoPanel();
         this.showDeckTitle(false);
         this.setEditButtonVisible(false);
      }
      
      public function isCraftFilterON() : Boolean
      {
         return this.mIsCraftFilterON;
      }
      
      public function setCraftFilterON(param1:Boolean) : void
      {
         this.mIsCraftFilterON = param1;
      }
      
      private function createCurrentPageTextfield() : void
      {
         if(this.mPageIndicatorTextfield == null)
         {
            this.mPageIndicatorTextfield = new FSTextfield(COLLECTION_CONTAINER_WIDTH / 3,FSResourceMng.FONT_STD_BIG_TITLE_SIZE,"",16777215,FSResourceMng.FONT_STD_SUBTITLE_SIZE);
            this.mPageIndicatorTextfield.x = this.mUpArrow.x + this.mPageIndicatorTextfield.width / 2;
            this.mPageIndicatorTextfield.y = this.mUpArrow.y - this.mUpArrow.height / 2;
            this.mPageIndicatorTextfield.format.verticalAlign = Align.BOTTOM;
            addChild(this.mPageIndicatorTextfield);
         }
      }
      
      private function createDeckValueTextfield() : void
      {
         if(this.mDeckValueIndicatorTextfield == null && Config.PVP_SHOW_DECK_VALUE)
         {
            this.mDeckValueIndicatorTextfield = new FSTextfield(COLLECTION_CONTAINER_WIDTH / 3,FSResourceMng.FONT_STD_BIG_TITLE_SIZE,"",16777215,FSResourceMng.FONT_STD_SUBTITLE_SIZE);
            this.mDeckValueIndicatorTextfield.x = this.mUpArrow.x - this.mDeckValueIndicatorTextfield.width * 1.5;
            this.mDeckValueIndicatorTextfield.y = this.mUpArrow.y - this.mUpArrow.height / 2;
            this.mDeckValueIndicatorTextfield.format.verticalAlign = Align.BOTTOM;
            addChild(this.mDeckValueIndicatorTextfield);
         }
      }
      
      private function updatePageTextfield() : void
      {
         var _loc1_:int = 0;
         if(this.mPageIndicatorTextfield)
         {
            _loc1_ = this.getTotalPages() == 0 ? 1 : this.getTotalPages();
            this.mPageIndicatorTextfield.text = TextManager.getText("TID_DECKBUILDER_PAGE",true) + ": " + (this.mCurrentPage + 1) + "/" + _loc1_;
         }
      }
      
      public function updateDeckValueTextfield() : void
      {
         var _loc1_:UserData = null;
         var _loc2_:int = 0;
         if(this.mDeckValueIndicatorTextfield)
         {
            if(this.mEdidionStatus == STATUS_EDITING)
            {
               _loc1_ = Utils.getOwnerUserData();
               _loc2_ = this.mDeckCardsPanel ? this.mDeckCardsPanel.getDeckValue() : -1;
               if(_loc2_ != -1)
               {
                  this.mDeckValueIndicatorTextfield.text = TextManager.getText("TID_DECKVALUE",true) + " " + _loc2_;
               }
            }
            else
            {
               this.mDeckValueIndicatorTextfield.text = "";
            }
         }
      }
      
      protected function createUpAndDownArrows() : void
      {
         if(this.mUpArrow == null)
         {
            this.mUpArrow = new FSButton(Root.assets.getTexture("db_arrow_up"));
            this.mUpArrow.x = this.mCollectionContainer.x + COLLECTION_CONTAINER_WIDTH / 2;
            this.mUpArrow.y = this.mCollectionContainer.y - this.mUpArrow.height / 1.25;
            addChild(this.mUpArrow);
            this.mUpArrow.addEventListener(Event.TRIGGERED,this.onUpArrowTriggered);
         }
         if(this.mDownArrow == null)
         {
            this.mDownArrow = new FSButton(Root.assets.getTexture("db_arrow_down"));
            this.mDownArrow.name = "down_arrow";
            this.mDownArrow.x = this.mUpArrow.x;
            this.mDownArrow.y = this.mCollectionContainer.y + COLLECTION_CONTAINER_HEIGHT + this.mDownArrow.height / 1.45;
            if(Utils.isAndroidOrDesktop())
            {
               this.mDownArrow.y += 2;
            }
            addChild(this.mDownArrow);
            this.mDownArrow.addEventListener(Event.TRIGGERED,this.onDownArrowTriggered);
         }
      }
      
      private function onDownArrowTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1 ? param1.getTouch(this,TouchPhase.HOVER) : null;
         if(_loc2_)
         {
            this.goToNextPage();
         }
      }
      
      private function onUpArrowTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1 ? param1.getTouch(this,TouchPhase.HOVER) : null;
         if(_loc2_)
         {
            this.goToPrevPage();
         }
      }
      
      private function onUpArrowTriggered(param1:Event) : void
      {
         this.goToPrevPage();
      }
      
      public function goToPrevPage(param1:Boolean = true) : void
      {
         var _loc2_:Boolean = false;
         FSDebug.debugTrace("GOING TO PREV PAGE");
         if(this.mCollectionScrollable && !Root.assets.isLoading)
         {
            _loc2_ = false;
            if(this.mCurrentPage > 0)
            {
               --this.mCurrentPage;
               this.fillCollectionContainer(true);
               this.refreshArrowButtonsState();
               _loc2_ = true;
            }
            else if(this.isTopOK())
            {
               this.onPrevPageSwitchCategory();
               _loc2_ = true;
            }
         }
      }
      
      public function resetContainerAndFill() : void
      {
         this.setFilterButtonsTouchable(false);
         this.mCurrentPage = 0;
         this.fillCollectionContainer(true);
      }
      
      public function goToNextPage(param1:Boolean = true) : void
      {
         var _loc2_:int = 0;
         FSDebug.debugTrace("GOING TO NEXT PAGE");
         if(this.mCollectionScrollable && !Root.assets.isLoading)
         {
            _loc2_ = this.getTotalPages();
            if(this.mCurrentPage < _loc2_ - 1)
            {
               ++this.mCurrentPage;
               this.fillCollectionContainer(true);
               this.refreshArrowButtonsState();
            }
            else if(this.isBottomOK())
            {
               this.onNextPageSwitchCategory();
            }
         }
      }
      
      private function onNextPageSwitchCategory() : void
      {
         var _loc1_:Boolean = Config.getConfig().gameHasAttachments();
         var _loc2_:Boolean = Config.getConfig().gameHasPowers();
         switch(this.mCategorySelected)
         {
            case CategoriesDefMng.CATEGORY_UNITS:
               this.mCategorySelected = _loc1_ ? CategoriesDefMng.CATEGORY_ATTACHMENTS : CategoriesDefMng.CATEGORY_ACTIONS;
               break;
            case CategoriesDefMng.CATEGORY_ATTACHMENTS:
               this.mCategorySelected = CategoriesDefMng.CATEGORY_ACTIONS;
               break;
            case CategoriesDefMng.CATEGORY_ACTIONS:
               this.mCategorySelected = _loc2_ ? CategoriesDefMng.CATEGORY_POWERS : CategoriesDefMng.CATEGORY_ACTIONS;
         }
         this.updateUIByCategorySelected();
      }
      
      private function onPrevPageSwitchCategory() : void
      {
         var _loc1_:Boolean = Config.getConfig().gameHasAttachments();
         switch(this.mCategorySelected)
         {
            case CategoriesDefMng.CATEGORY_ATTACHMENTS:
               this.mCategorySelected = CategoriesDefMng.CATEGORY_UNITS;
               break;
            case CategoriesDefMng.CATEGORY_ACTIONS:
               this.mCategorySelected = _loc1_ ? CategoriesDefMng.CATEGORY_ATTACHMENTS : CategoriesDefMng.CATEGORY_UNITS;
               break;
            case CategoriesDefMng.CATEGORY_POWERS:
               this.mCategorySelected = CategoriesDefMng.CATEGORY_ACTIONS;
         }
         var _loc2_:int = this.calculateTotalPagesByCategory(this.mCategorySelected);
         var _loc3_:int = _loc2_ > 0 ? int(_loc2_ - 1) : 0;
         this.updateUIByCategorySelected(_loc3_);
      }
      
      private function onDownArrowTriggered(param1:Event) : void
      {
         this.goToNextPage();
      }
      
      private function refreshArrowButtonsState() : void
      {
         if(this.mDownArrow)
         {
            this.mDownArrow.enabled = this.isBottomOK();
         }
         if(this.mUpArrow)
         {
            this.mUpArrow.enabled = this.isTopOK();
         }
      }
      
      private function isTopOK() : Boolean
      {
         return this.mCategorySelected != CategoriesDefMng.CATEGORY_UNITS || this.mCategorySelected == CategoriesDefMng.CATEGORY_UNITS && this.mCurrentPage > 0;
      }
      
      private function isBottomOK() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = this.getTotalPages();
         switch(this.mCategorySelected)
         {
            case CategoriesDefMng.CATEGORY_UNITS:
               _loc1_ = true;
               break;
            case CategoriesDefMng.CATEGORY_ATTACHMENTS:
               _loc1_ = true;
               break;
            case CategoriesDefMng.CATEGORY_ACTIONS:
               _loc1_ = Config.getConfig().gameHasPowers() ? true : this.mCurrentPage < _loc2_ - 1;
               break;
            case CategoriesDefMng.CATEGORY_POWERS:
               _loc1_ = this.mCurrentPage < _loc2_ - 1;
         }
         return _loc1_;
      }
      
      protected function getTotalPages() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = this.getContainerColumnsAmountAllowed() * 2;
         var _loc3_:Array = DictionaryUtils.getKeys(this.mCurrentCollectionOnFilters);
         var _loc4_:int = _loc3_ ? int(_loc3_.length) : 0;
         return int(Math.ceil(_loc4_ / _loc2_));
      }
      
      protected function calculateTotalPagesByCategory(param1:int) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = this.getContainerColumnsAmountAllowed() * 2;
         var _loc4_:Dictionary = this.calculateCollectionByCategory(true,param1);
         var _loc5_:Array = DictionaryUtils.getKeys(this.mCurrentCollectionOnFilters);
         var _loc6_:int = _loc5_ ? int(_loc5_.length) : 0;
         return int(Math.ceil(_loc6_ / _loc3_));
      }
      
      private function createRecycleButton() : void
      {
         if(this.mRecycleButton == null)
         {
            this.mRecycleButton = new FSButton(Root.assets.getTexture("db_icon_recycle"));
            this.mRecycleButton.name = "recycle_button";
            this.mRecycleButton.x = this.mViewAllCraftableCardsButton.x + this.mViewAllCraftableCardsButton.width + this.mRecycleButton.width / 2;
            this.mRecycleButton.y = this.mViewAllCraftableCardsButton.y + this.mRecycleButton.height / 2;
            addChild(this.mRecycleButton);
            this.mRecycleButton.addEventListener(Event.TRIGGERED,this.onRecycleTriggered);
         }
      }
      
      public function isViewAllCardsModeON() : Boolean
      {
         return this.mFilteringAllCards;
      }
      
      private function onRecycleTriggered(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:FSCoordinate = null;
         if(this.mFilteringAllCards)
         {
            Utils.setLogText(TextManager.getText("TID_DECKBUILDER_VIEWALL"),true);
            return;
         }
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            if(!PvPConnectionMng.smUserInPvPQueue)
            {
               _loc2_ = DictionaryUtils.getCardsAmountPerCatalog(InstanceMng.getUserDataMng().getOwnerUserData().getCardCollection());
               if(_loc2_ > Config.getConfig().getDeckCardsAmount())
               {
                  if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen && FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).getEdidionStatus() == FSDeckBuilderScreen.STATUS_CREATION_MODE && !this.isViewAllCardsModeON())
                  {
                     Utils.setLogText(TextManager.getText("TID_DECKBUILDER_VIEWALL"),true);
                  }
                  else
                  {
                     this.onStartEditingDeck();
                     this.lockUI(true);
                     _loc3_ = new FSCoordinate(this.mDeckSelector.x,Starling.current.stage.stageHeight);
                     SpecialFX.createTransition(this.mDeckSelector,_loc3_,0.5,0,this.showRecyclePanel);
                  }
               }
               else
               {
                  Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_DECKBUILDER_RECYCLE_USE"),[Config.getConfig().getMinCardsAmountForRecycling()]),true);
               }
            }
            else
            {
               Utils.setLogText(TextManager.getText("TID_PVP_FEATURE_BLOCKED"),true);
            }
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true);
            onConnectionLost();
         }
      }
      
      private function showRecyclePanel() : void
      {
         if(this.mRecyclePanel == null)
         {
            this.mRecyclePanel = new RecycleCardsPanel(0);
         }
         this.showRecycleButton(false);
         this.mRecyclePanel.x = this.mDeckTitleBox.x - (this.mRecyclePanel.width - this.mDeckTitleBox.width) / 2;
         this.mRecyclePanel.y = -this.mRecyclePanel.height;
         addChild(this.mRecyclePanel);
         this.sortRecyclePanel();
         addChild(this.mDeckTitleBox);
         addChild(this.mDeckTitleLabel);
         this.setEdidionStatus(STATUS_EDITING);
         this.setIsRecyclingMode(true);
      }
      
      protected function sortRecyclePanel() : void
      {
         var _loc1_:FSCoordinate = new FSCoordinate(this.mRecyclePanel.x,Starling.current.stage.stageHeight * 0.08);
         SpecialFX.createTransition(this.mRecyclePanel,_loc1_,0.5,0,this.setupRecyclePanel,[0,true]);
      }
      
      protected function setupRecyclePanel(param1:int, param2:Boolean = true, param3:Boolean = false) : void
      {
         if(this.mRecyclePanel)
         {
            this.mRecyclePanel.setup(param1,param2,param3);
         }
      }
      
      private function createViewAllFilterButton() : void
      {
         this.mViewAllCraftableCardsButton = new FSToggleButton(VIEW_ALL_CARDS_FILTER_OFF_NAME,VIEW_ALL_CARDS_FILTER_ON_NAME,TextManager.getText("TID_CRAFT"));
         this.mViewAllCraftableCardsButton.setToggled();
         this.mViewAllCraftableCardsButton.setFontSize(FSResourceMng.FONT_STD_DEFAULT_SIZE);
         this.mViewAllCraftableCardsButton.name = "view_all_craftable_cards";
         this.mViewAllCraftableCardsButton.setTooltipText(TextManager.getText("TID_GEN_VIEW_CRAFT_CARDS"));
         this.mViewAllCraftableCardsButton.x = this.mDeckSelector.x + this.mViewAllCraftableCardsButton.width * 0.15;
         this.mViewAllCraftableCardsButton.y = Starling.current.stage.stageHeight - this.mViewAllCraftableCardsButton.height * 1.25;
         addChild(this.mViewAllCraftableCardsButton);
         this.mViewAllCraftableCardsButton.addEventListener(TouchEvent.TOUCH,this.onViewAllCraftableCardsToggled);
         if(this.mIsAnyCardCrafteable)
         {
            this.mViewAllCraftableCardsButton.showDeckNotificationIcon();
         }
      }
      
      private function onViewAllCraftableCardsToggled(param1:TouchEvent) : void
      {
         var showDeckSelectorAgain:Function = null;
         var loadCollections:Boolean = false;
         var touch:Touch = null;
         var coord:FSCoordinate = null;
         var e:TouchEvent = param1;
         showDeckSelectorAgain = function(param1:Boolean):void
         {
            var deckSelector:DeckSelector;
            var onDeckSelectorTransitionFinished:Function = null;
            var coord:FSCoordinate = null;
            var loadColls:Boolean = param1;
            onDeckSelectorTransitionFinished = function(param1:Boolean, param2:Boolean):void
            {
               if(param1)
               {
                  fillCollections();
                  resetContainerAndFill();
               }
               showRecycleButton(param2);
            };
            Utils.playSound(Constants.SOUND_PANEL_DOWN,SoundManager.TYPE_SFX);
            deckSelector = getDeckSelector();
            if(deckSelector != null)
            {
               showDeckTitle(true);
               coord = new FSCoordinate(deckSelector.x,FSDeckBuilderScreen.DECK_SELECTOR_Y);
               SpecialFX.createTransition(deckSelector,coord,0.5,0,onDeckSelectorTransitionFinished,[loadColls,true]);
            }
         };
         if(this.mViewAllCraftableCardsButton.isEnabled() && !Root.assets.isLoading)
         {
            loadCollections = true;
            touch = e.getTouch(this,TouchPhase.ENDED);
            if(touch)
            {
               if(this.mEdidionStatus != STATUS_CREATION_MODE)
               {
                  this.mFilteringAllCards = false;
                  if(this.mAllCardsFilterButton)
                  {
                     this.mAllCardsFilterButton.setIsSelected(false);
                  }
                  if(this.mEdidionStatus == STATUS_EDITING)
                  {
                     Utils.setLogText(TextManager.getText("TID_DECKBUILDER_VIEWALL"),true);
                     return;
                  }
                  this.setEdidionStatus(STATUS_CREATION_MODE);
                  if(this.mViewAllCraftableCardsButton.isEnabled() && Config.getConfig().getDeckBuilderCraftMode())
                  {
                     this.mViewAllCraftableCardsButton.updateText(TextManager.getText("TID_GEN_BUTTON_CANCEL"));
                     if(this.mDeckCraftInfoPanel)
                     {
                        this.mDeckCraftInfoPanel.setCraftFilterButtonVisible(true);
                     }
                     if(this.mIsAnyCardCrafteable)
                     {
                        this.mViewAllCraftableCardsButton.hideDeckNotificationIcon();
                     }
                  }
                  loadCollections = false;
                  this.mDeckSelector.movePanelDown(this.setupCraftInfoPanel);
               }
               else
               {
                  this.setEdidionStatus(STATUS_NOT_EDITING);
                  if(this.mViewAllCraftableCardsButton.isEnabled() && Config.getConfig().getDeckBuilderCraftMode())
                  {
                     this.mViewAllCraftableCardsButton.updateText(TextManager.getText("TID_CRAFT"));
                     if(this.mDeckCraftInfoPanel)
                     {
                        this.mDeckCraftInfoPanel.setCraftFilterButtonVisible(false);
                     }
                     if(Boolean(this.mDeckCraftInfoPanel) && !this.mDeckCraftInfoPanel.isCraftButtonToggled())
                     {
                        this.mDeckCraftInfoPanel.setCraftButtonToggled();
                        this.mIsCraftFilterON = false;
                     }
                     if(this.mIsAnyCardCrafteable)
                     {
                        this.mViewAllCraftableCardsButton.showDeckNotificationIcon();
                     }
                     if(this.mDeckCraftInfoPanel != null)
                     {
                        this.lockUI(true);
                        coord = new FSCoordinate(this.mDeckCraftInfoPanel.x,-this.mDeckCraftInfoPanel.height);
                        SpecialFX.createTransition(this.mDeckCraftInfoPanel,coord,0.5,0,showDeckSelectorAgain,[loadCollections]);
                     }
                  }
               }
            }
         }
      }
      
      private function setCardsAvailablesForFusion() : void
      {
         var _loc1_:DeckBuilderCard = null;
         if(Config.getConfig().gameHasFusionCards())
         {
            if(!this.isViewAllCardsModeON() && (CRAFT_MODE_ON && this.mEdidionStatus == STATUS_CREATION_MODE))
            {
               this.mCollectionRarities = InstanceMng.getRaritiesDefMng().getAllDefs();
               for each(_loc1_ in this.mCardInfoCatalog)
               {
                  if(_loc1_.getCardDef().isFusion() && DictionaryUtils.isCardAvailableToFusion(_loc1_.getCardDef()))
                  {
                     _loc1_.createFusionLayer();
                  }
               }
            }
         }
      }
      
      private function setCardsAvailablesForCrafting() : void
      {
         var _loc1_:DeckBuilderCard = null;
         if(!this.isViewAllCardsModeON() && (CRAFT_MODE_ON && this.mEdidionStatus == STATUS_CREATION_MODE))
         {
            this.mCollectionRarities = InstanceMng.getRaritiesDefMng().getAllDefs();
            for each(_loc1_ in this.mCardInfoCatalog)
            {
               if(!_loc1_.getCardDef().isFusion() && DictionaryUtils.isCardAvailableToCraft(_loc1_.getCardDef()))
               {
                  _loc1_.createFusionLayer();
               }
            }
         }
      }
      
      private function isSubFilterButtonToggled(param1:String, param2:Dictionary) : Boolean
      {
         var _loc4_:Boolean = false;
         var _loc3_:Boolean = true;
         if(param2)
         {
            if(param1 == "all")
            {
               for each(_loc4_ in param2)
               {
                  _loc3_ &&= _loc4_;
               }
            }
            else
            {
               _loc3_ = param2[param1] == true;
            }
         }
         return _loc3_;
      }
      
      private function createSubfilterButtons(param1:String, param2:String, param3:Function, param4:Dictionary, param5:Dictionary = null) : void
      {
         var filterButton:ShopMenuButton = null;
         var def:Def = null;
         var i:int = 0;
         var abilityNameTextInput:FSTextInput = null;
         var onAbilityNameTextInputEnter:Function = null;
         var text:String = null;
         var labelText:String = null;
         var l:FSTextfield = null;
         var keys:Array = null;
         var filterName:String = null;
         var section:String = param1;
         var filterPrefix:String = param2;
         var onTriggerFunction:Function = param3;
         var catalog:Dictionary = param4;
         var defsCatalog:Dictionary = param5;
         onAbilityNameTextInputEnter = function(param1:Event):void
         {
            mSearchFilter = Boolean(param1) && Boolean(param1.currentTarget) ? FSTextInput(param1.currentTarget).text : "";
            resetContainerAndFill();
            labelText = mSearchFilter != "" && Boolean(mSearchFilter) ? TextManager.getText("TID_FILTER_ABILITY") + "\'" + mSearchFilter + "\'" : TextManager.getText("TID_FILTER_ABILITY_DESC");
            if(l)
            {
               l.text = labelText;
            }
            if(mAbilityFilterButton)
            {
               mAbilityFilterButton.setTooltipText(labelText.toUpperCase());
            }
         };
         var suffix:String = "";
         var bName:String = "";
         var isToggled:Boolean = false;
         if(section != this.ABILITY_FILTER)
         {
            text = section != this.COST_FILTER ? "" : "ALL";
            isToggled = this.isSubFilterButtonToggled("all",catalog);
            filterButton = new ShopMenuButton(isToggled,"all",filterPrefix,"db_button_on","db_button_off",onTriggerFunction,text,Align.CENTER,0);
            filterButton.scale = 0.75;
            filterButton.y = filterButton.height / 2;
            this.mSubfilterButtonsContainer.addChild(filterButton);
         }
         switch(section)
         {
            case this.COST_FILTER:
               i = 0;
               while(i < 7)
               {
                  text = i < 6 ? (i + 1).toString() : "7+";
                  isToggled = this.isSubFilterButtonToggled((i + 1).toString(),catalog);
                  filterButton = new ShopMenuButton(isToggled,(i + 1).toString(),"db_filter_icon_cost","db_button_on","db_button_off",this.onSummonCostToggleTouch,text,Align.CENTER,0);
                  filterButton.scaleX = 0.75;
                  filterButton.scaleY = 0.75;
                  this.mSubfilterButtonsContainer.addChild(filterButton);
                  i++;
               }
               break;
            case this.ABILITY_FILTER:
               labelText = this.mSearchFilter != "" && Boolean(this.mSearchFilter) ? TextManager.getText("TID_FILTER_ABILITY") + "\'" + this.mSearchFilter + "\'" : TextManager.getText("TID_FILTER_ABILITY_DESC");
               l = new FSTextfield(width / 2.35,this.mRecycleButton.height,labelText);
               l.fontSize = FSResourceMng.FONT_STD_SEMI_SMALL_SIZE;
               this.mSubfilterButtonsContainer.addChild(l);
               abilityNameTextInput = new FSTextInput();
               abilityNameTextInput.restrict = "^ ";
               abilityNameTextInput.text = this.mSearchFilter != "" && Boolean(this.mSearchFilter) ? this.mSearchFilter : "";
               abilityNameTextInput.setSize(width / 4,this.mRecycleButton.height);
               abilityNameTextInput.maxChars = 20;
               abilityNameTextInput.addEventListener(FeathersEventType.ENTER,onAbilityNameTextInputEnter);
               abilityNameTextInput.addEventListener(FeathersEventType.FOCUS_OUT,onAbilityNameTextInputEnter);
               this.mSubfilterButtonsContainer.addChild(abilityNameTextInput);
               if(Utils.isDesktop())
               {
                  abilityNameTextInput.setFocus();
               }
               break;
            default:
               keys = DictionaryUtils.sortDictionaryByKey(defsCatalog);
               i = 0;
               while(i < keys.length)
               {
                  def = defsCatalog[keys[i].key];
                  suffix = section != this.EDITION_FILTER ? Utils.transformValueToString((def.getIndex() + 1).toString(),2) : Utils.transformValueToString((EditionDef(def).getGameIndex() + 1).toString(),2);
                  filterName = filterPrefix + "_" + suffix;
                  bName = section != this.EDITION_FILTER ? def.getSku() : EditionDef(def).getGameIndex().toString();
                  isToggled = this.isSubFilterButtonToggled(bName,catalog);
                  filterButton = new ShopMenuButton(isToggled,bName,filterName,"db_button_on","db_button_off",onTriggerFunction,"",Align.CENTER,0);
                  filterButton.scale = 0.75;
                  this.mSubfilterButtonsContainer.addChild(filterButton);
                  i++;
               }
         }
         this.mSubfilterButtonsContainer.validate();
         if(this.mSubfilterButtonsContainer)
         {
            this.mSubfilterButtonsContainer.y = (this.mSubfiltersContainer.height - this.mSubfilterButtonsContainer.height) / 2;
         }
      }
      
      private function addFiltersDoneButton() : void
      {
         var onDoneTriggered:Function = null;
         onDoneTriggered = function():void
         {
            if(mFiltersContainer)
            {
               SpecialFX.createTransition(mSubfiltersContainer,new FSCoordinate(0,Starling.current.stage.stageHeight),0.2);
            }
            if(mSearchFilter == "")
            {
               mAbilityFilterButton.setIsSelected(false);
            }
         };
         var doneButton:FSButton = new FSButton(Root.assets.getTexture("db_filter_done"),TextManager.getText("TID_GEN_DONE"));
         Utils.setupButton9Scale(doneButton,17.5,13.5,6,16,53.75,28.75);
         doneButton.fontSize = FSResourceMng.FONT_STD_SUBTITLE_SIZE;
         doneButton.addEventListener(Event.TRIGGERED,onDoneTriggered);
         this.mSubfilterButtonsContainer.addChild(doneButton);
      }
      
      protected function createSubfilterButtonsContainer() : void
      {
         var _loc1_:HorizontalLayout = null;
         if(this.mSubfiltersContainer == null)
         {
            this.mSubfiltersContainer = new Component();
            this.mSubfiltersContainer.y = Starling.current.stage.stageHeight;
            addChild(this.mSubfiltersContainer);
         }
         else
         {
            this.mSubfiltersContainer.y = Starling.current.stage.stageHeight;
         }
         if(this.mSubFiltersContainerBG1 == null)
         {
            this.mSubFiltersContainerBG1 = new Quad(Starling.current.stage.stageWidth,Starling.current.stage.stageHeight * (1 - this.FILTERS_CONTAINER_POSITION_FACTOR) * 0.25,0);
            this.mSubFiltersContainerBG1.setVertexAlpha(0,0);
            this.mSubFiltersContainerBG1.setVertexAlpha(1,0);
            this.mSubFiltersContainerBG1.setVertexAlpha(2,0.85);
            this.mSubFiltersContainerBG1.setVertexAlpha(3,0.85);
            this.mSubfiltersContainer.addChild(this.mSubFiltersContainerBG1);
         }
         if(this.mSubFiltersContainerBG2 == null)
         {
            this.mSubFiltersContainerBG2 = new Quad(this.mSubFiltersContainerBG1.width,Starling.current.stage.stageHeight * (1 - this.FILTERS_CONTAINER_POSITION_FACTOR) * 0.75,0);
            this.mSubFiltersContainerBG2.alpha = 0.85;
            this.mSubFiltersContainerBG2.x = this.mSubFiltersContainerBG1.x;
            this.mSubFiltersContainerBG2.y = this.mSubFiltersContainerBG1.y + this.mSubFiltersContainerBG1.height;
            this.mSubfiltersContainer.addChild(this.mSubFiltersContainerBG2);
         }
         if(this.mSubfilterButtonsContainer == null)
         {
            this.mSubfilterButtonsContainer = new ScrollContainer();
            this.mSubfilterButtonsContainer.name = "faction_filter_container";
            _loc1_ = new HorizontalLayout();
            _loc1_.gap = 8;
            _loc1_.horizontalAlign = HorizontalAlign.CENTER;
            this.mSubfilterButtonsContainer.layout = _loc1_;
            this.mSubfilterButtonsContainer.paddingBottom = 0;
            this.mSubfilterButtonsContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
            this.mSubfilterButtonsContainer.verticalScrollPolicy = ScrollPolicy.OFF;
            this.mSubfilterButtonsContainer.width = this.mSubFiltersContainerBG1.width;
            this.mSubfiltersContainer.addChild(this.mSubfilterButtonsContainer);
         }
         else
         {
            this.mSubfilterButtonsContainer.removeChildren();
         }
      }
      
      protected function onSubfilterToggled(param1:ShopMenuButton, param2:Dictionary = null, param3:String = "") : void
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         if(!Root.assets.isLoading)
         {
            if(param2 == null && param3 != "" && param3 != null)
            {
               this.mSearchFilter = param3;
               param1.setIsSelected(this.mSearchFilter != "");
               return;
            }
            _loc4_ = param1.name;
            if(_loc4_ != "" || _loc4_ != null)
            {
               if(_loc4_ == "all")
               {
                  if(!param1.isSelected())
                  {
                     param1.setIsSelected(true);
                  }
                  if(this.mSubfilterButtonsContainer)
                  {
                     _loc5_ = 0;
                     while(_loc5_ < this.mSubfilterButtonsContainer.numChildren)
                     {
                        param1 = this.mSubfilterButtonsContainer.getChildAt(_loc5_) is ShopMenuButton ? ShopMenuButton(this.mSubfilterButtonsContainer.getChildAt(_loc5_)) : null;
                        if(param1)
                        {
                           if(param1.name != "all")
                           {
                              param2[param1.name] = true;
                           }
                           param1.setIsSelected(true);
                        }
                        _loc5_++;
                     }
                  }
               }
               else
               {
                  if(param2[_loc4_] != null)
                  {
                     param2[_loc4_] = true;
                  }
                  if(param1.name == _loc4_ && !param1.isSelected())
                  {
                     param1.setIsSelected(true);
                  }
                  _loc5_ = 0;
                  while(_loc5_ < this.mSubfilterButtonsContainer.numChildren)
                  {
                     param1 = this.mSubfilterButtonsContainer.getChildAt(_loc5_) is ShopMenuButton ? ShopMenuButton(this.mSubfilterButtonsContainer.getChildAt(_loc5_)) : null;
                     if(param1)
                     {
                        if(param1.name != _loc4_)
                        {
                           if(param1.name != "all")
                           {
                              param2[param1.name] = false;
                           }
                           if(param1.isSelected())
                           {
                              if(param1 != this.mAbilityFilterButton || param1 == this.mAbilityFilterButton && this.mSearchFilter == "")
                              {
                                 param1.setIsSelected(false);
                              }
                           }
                        }
                     }
                     _loc5_++;
                  }
               }
            }
            this.resetContainerAndFill();
         }
      }
      
      private function onFactionToggleTouch(param1:Event) : void
      {
         var _loc2_:ShopMenuButton = ShopMenuButton(FSButton(param1.currentTarget).parent);
         this.onSubfilterToggled(_loc2_,this.mFactionsToShowCatalog);
         this.mFactionFilterButton.updateButtonTexture(_loc2_.getButtonTextureName());
      }
      
      protected function onSubcategoryToggleTouch(param1:Event) : void
      {
         var _loc2_:ShopMenuButton = ShopMenuButton(FSButton(param1.currentTarget).parent);
         this.onSubfilterToggled(_loc2_,this.mSubcategoriesToShowCatalog);
         this.mSubCategoriesFilterButton.updateButtonTexture(_loc2_.getButtonTextureName());
      }
      
      protected function onRaritiesToggleTouch(param1:Event) : void
      {
         var _loc2_:ShopMenuButton = ShopMenuButton(FSButton(param1.currentTarget).parent);
         this.onSubfilterToggled(_loc2_,this.mRaritiesToShowCatalog);
         this.mRaritiesFilterButton.updateButtonTexture(_loc2_.getButtonTextureName());
      }
      
      protected function onAbilitiesFilterToggleTouch(param1:Event) : void
      {
         var _loc2_:ShopMenuButton = ShopMenuButton(FSButton(param1.currentTarget).parent);
         this.onSubfilterToggled(_loc2_,null,this.mSearchFilter);
      }
      
      protected function onEditionsToggleTouch(param1:Event) : void
      {
         var _loc2_:ShopMenuButton = null;
         if(this.mEditionFilterButton)
         {
            _loc2_ = ShopMenuButton(FSButton(param1.currentTarget).parent);
            this.onSubfilterToggled(_loc2_,this.mEditionsToShowCatalog);
            this.mEditionFilterButton.updateButtonTexture(_loc2_.getButtonTextureName());
         }
      }
      
      protected function onNewCardsToggleTouch(param1:Event) : void
      {
         var _loc2_:ShopMenuButton = ShopMenuButton(FSButton(param1.currentTarget).parent);
         this.mFilteringOnlyNewCards = !this.mFilteringOnlyNewCards;
         _loc2_.setIsSelected(this.mFilteringOnlyNewCards);
         this.resetContainerAndFill();
      }
      
      protected function onFavouritesToggleTouch(param1:Event) : void
      {
         var _loc2_:ShopMenuButton = ShopMenuButton(FSButton(param1.currentTarget).parent);
         this.mFilteringOnlyFavouriteCards = !this.mFilteringOnlyFavouriteCards;
         _loc2_.setIsSelected(this.mFilteringOnlyFavouriteCards);
         this.resetContainerAndFill();
      }
      
      protected function onAllCardsToggleTouch(param1:Event) : void
      {
         var _loc2_:ShopMenuButton = null;
         if(this.mEdidionStatus == STATUS_NOT_EDITING)
         {
            _loc2_ = ShopMenuButton(FSButton(param1.currentTarget).parent);
            this.mFilteringAllCards = !this.mFilteringAllCards;
            _loc2_.setIsSelected(this.mFilteringAllCards);
            this.fillCollections(true);
         }
      }
      
      private function createTabs() : void
      {
         this.createUnitsTab();
         this.createAttachmentsTab();
         this.createActionsTab();
         this.createPowersTab();
         this.mCategorySelected = CategoriesDefMng.CATEGORY_UNITS;
         this.updateUIByCategorySelected();
      }
      
      protected function createUnitsTab() : void
      {
         var _loc1_:int = 0;
         if(this.mUnitsTab == null)
         {
            _loc1_ = DictionaryUtils.getCardsAmountPerCatalog(this.mUnitsCollection);
            this.mUnitsTab = new ShopMenuButton(true,this.UNITS_TAB_BG_NAME,"db_icon_cat_01","db_button_top_on","db_button_top_off",this.onTabTouch,_loc1_.toString(),Align.CENTER,0.45);
            this.mUnitsTab.x = COLLECTION_CONTAINER_WIDTH / 45;
            this.mUnitsTab.y = Starling.current.stage.stageHeight * 0.015;
            if(!Config.getConfig().gameHasAttachments())
            {
               this.mUnitsTab.x += 30;
            }
            this.mUnitsTab.setTooltipText(TextManager.getText("TID_CATEGORY_NAME_1_PLURAL",true));
            addChild(this.mUnitsTab);
         }
      }
      
      private function createAttachmentsTab() : void
      {
         var _loc1_:int = 0;
         if(Config.getConfig().gameHasAttachments())
         {
            if(this.mAttachmentsTab == null)
            {
               _loc1_ = DictionaryUtils.getCardsAmountPerCatalog(this.mAttachmentsCollection);
               this.mAttachmentsTab = new ShopMenuButton(true,this.ATTACHMENTS_TAB_BG_NAME,"db_icon_cat_02","db_button_top_on","db_button_top_off",this.onTabTouch,_loc1_.toString(),Align.CENTER,0.45);
               this.mAttachmentsTab.x = this.mUnitsTab.x + this.mUnitsTab.width + 5;
               this.mAttachmentsTab.y = this.mUnitsTab.y;
               this.mAttachmentsTab.setTooltipText(TextManager.getText("TID_CATEGORY_NAME_2_PLURAL",true));
               addChild(this.mAttachmentsTab);
            }
         }
      }
      
      protected function createActionsTab() : void
      {
         var _loc1_:int = 0;
         if(this.mActionsTab == null)
         {
            _loc1_ = DictionaryUtils.getCardsAmountPerCatalog(this.mOrdersCollection);
            this.mActionsTab = new ShopMenuButton(true,this.ORDERS_TAB_BG_NAME,"db_icon_cat_03","db_button_top_on","db_button_top_off",this.onTabTouch,_loc1_.toString(),Align.CENTER,0.45);
            this.mActionsTab.x = this.mAttachmentsTab ? this.mAttachmentsTab.x + this.mAttachmentsTab.width + 5 : this.mUnitsTab.x + this.mUnitsTab.width + 5;
            this.mActionsTab.y = this.mUnitsTab.y;
            this.mActionsTab.setTooltipText(TextManager.getText("TID_CATEGORY_NAME_3_PLURAL",true));
            addChild(this.mActionsTab);
         }
      }
      
      protected function createPowersTab() : void
      {
         var _loc1_:int = 0;
         if(Config.getConfig().gameHasPowers())
         {
            if(this.mPowersTab == null)
            {
               _loc1_ = DictionaryUtils.getCardsAmountPerCatalog(this.mPowersCollection);
               this.mPowersTab = new ShopMenuButton(true,this.POWERS_TAB_BG_NAME,"db_icon_cat_04","db_button_top_on","db_button_top_off",this.onTabTouch,_loc1_.toString(),Align.CENTER,0.45);
               this.mPowersTab.x = this.mActionsTab ? this.mActionsTab.x + this.mActionsTab.width + 5 : this.mUnitsTab.x + this.mUnitsTab.width + 5;
               this.mPowersTab.y = this.mUnitsTab.y;
               this.mPowersTab.setTooltipText(TextManager.getText("TID_CATEGORY_NAME_4",true));
               addChild(this.mPowersTab);
            }
         }
      }
      
      private function onTabTouch(param1:Event) : void
      {
         var _loc2_:FSButton = FSButton(param1.currentTarget);
         var _loc3_:Boolean = false;
         if(!Root.assets.isLoading)
         {
            Utils.playSound(Constants.SOUND_CLICK,SoundManager.TYPE_SFX);
            switch(_loc2_.name)
            {
               case this.UNITS_TAB_BG_NAME:
                  _loc3_ = this.mCategorySelected != CategoriesDefMng.CATEGORY_UNITS;
                  this.mCategorySelected = CategoriesDefMng.CATEGORY_UNITS;
                  break;
               case this.ATTACHMENTS_TAB_BG_NAME:
                  _loc3_ = this.mCategorySelected != CategoriesDefMng.CATEGORY_ATTACHMENTS;
                  this.mCategorySelected = CategoriesDefMng.CATEGORY_ATTACHMENTS;
                  break;
               case this.ORDERS_TAB_BG_NAME:
                  _loc3_ = this.mCategorySelected != CategoriesDefMng.CATEGORY_ACTIONS;
                  this.mCategorySelected = CategoriesDefMng.CATEGORY_ACTIONS;
                  break;
               case this.POWERS_TAB_BG_NAME:
                  _loc3_ = this.mCategorySelected != CategoriesDefMng.CATEGORY_POWERS;
                  this.mCategorySelected = CategoriesDefMng.CATEGORY_POWERS;
            }
            if(_loc3_)
            {
               this.updateUIByCategorySelected();
            }
         }
      }
      
      public function refreshTabsAmount() : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc1_:int = DictionaryUtils.getCardsAmountPerCatalog(this.mCurrentCollectionOnFilters);
         var _loc2_:String = _loc1_.toString();
         switch(this.mCategorySelected)
         {
            case CategoriesDefMng.CATEGORY_UNITS:
               if(this.mEdidionStatus == STATUS_CREATION_MODE || this.isViewAllCardsModeON())
               {
                  _loc3_ = InstanceMng.getUserDataMng().getOwnerUserData().getUnitsAmount();
                  _loc2_ = _loc3_ + "/" + _loc2_;
               }
               if(this.mUnitsTab)
               {
                  this.mUnitsTab.updateText(_loc2_);
               }
               this.updateTabAmountByCategory(CategoriesDefMng.CATEGORY_ATTACHMENTS);
               this.updateTabAmountByCategory(CategoriesDefMng.CATEGORY_ACTIONS);
               this.updateTabAmountByCategory(CategoriesDefMng.CATEGORY_POWERS);
               break;
            case CategoriesDefMng.CATEGORY_ATTACHMENTS:
               if(this.mEdidionStatus == STATUS_CREATION_MODE || this.isViewAllCardsModeON())
               {
                  _loc4_ = InstanceMng.getUserDataMng().getOwnerUserData().getAttachmentsAmount();
                  _loc2_ = _loc4_ + "/" + _loc2_;
               }
               if(this.mAttachmentsTab)
               {
                  this.mAttachmentsTab.updateText(_loc2_);
               }
               this.updateTabAmountByCategory(CategoriesDefMng.CATEGORY_UNITS);
               this.updateTabAmountByCategory(CategoriesDefMng.CATEGORY_ACTIONS);
               this.updateTabAmountByCategory(CategoriesDefMng.CATEGORY_POWERS);
               break;
            case CategoriesDefMng.CATEGORY_ACTIONS:
               if(this.mEdidionStatus == STATUS_CREATION_MODE || this.isViewAllCardsModeON())
               {
                  _loc5_ = InstanceMng.getUserDataMng().getOwnerUserData().getActionsAmount();
                  _loc2_ = _loc5_ + "/" + _loc2_;
               }
               if(this.mActionsTab)
               {
                  this.mActionsTab.updateText(_loc2_);
               }
               this.updateTabAmountByCategory(CategoriesDefMng.CATEGORY_UNITS);
               this.updateTabAmountByCategory(CategoriesDefMng.CATEGORY_ATTACHMENTS);
               this.updateTabAmountByCategory(CategoriesDefMng.CATEGORY_POWERS);
               break;
            case CategoriesDefMng.CATEGORY_POWERS:
               if(this.mEdidionStatus == STATUS_CREATION_MODE || this.isViewAllCardsModeON())
               {
                  _loc6_ = InstanceMng.getUserDataMng().getOwnerUserData().getPowersAmount();
                  _loc2_ = _loc6_ + "/" + _loc2_;
               }
               if(this.mPowersTab)
               {
                  this.mPowersTab.updateText(_loc2_);
               }
               this.updateTabAmountByCategory(CategoriesDefMng.CATEGORY_UNITS);
               this.updateTabAmountByCategory(CategoriesDefMng.CATEGORY_ATTACHMENTS);
               this.updateTabAmountByCategory(CategoriesDefMng.CATEGORY_ACTIONS);
         }
      }
      
      public function refreshNewCardsAmountsOnTabs() : void
      {
         var _loc1_:Dictionary = null;
         if(Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
         {
            _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData().getNewCardsCollection();
            if(this.mUnitsTab)
            {
               this.mUnitsTab.updateNewCardsAmount(DictionaryUtils.getCardsAmountPerCatalog(DictionaryUtils.getCatalogFilteredByCategory(_loc1_,CategoriesDefMng.CATEGORY_UNITS)));
            }
            if(this.mAttachmentsTab)
            {
               this.mAttachmentsTab.updateNewCardsAmount(DictionaryUtils.getCardsAmountPerCatalog(DictionaryUtils.getCatalogFilteredByCategory(_loc1_,CategoriesDefMng.CATEGORY_ATTACHMENTS)));
            }
            if(this.mActionsTab)
            {
               this.mActionsTab.updateNewCardsAmount(DictionaryUtils.getCardsAmountPerCatalog(DictionaryUtils.getCatalogFilteredByCategory(_loc1_,CategoriesDefMng.CATEGORY_ACTIONS)));
            }
            if(this.mPowersTab)
            {
               this.mPowersTab.updateNewCardsAmount(DictionaryUtils.getCardsAmountPerCatalog(DictionaryUtils.getCatalogFilteredByCategory(_loc1_,CategoriesDefMng.CATEGORY_POWERS)));
            }
         }
      }
      
      private function updateTabAmountByCategory(param1:int) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         switch(param1)
         {
            case CategoriesDefMng.CATEGORY_UNITS:
               if(this.mUnitsTab)
               {
                  _loc2_ = DictionaryUtils.getCardsAmountPerCatalog(this.mUnitsCollection).toString();
                  this.mUnitsTab.updateText(_loc2_);
               }
               break;
            case CategoriesDefMng.CATEGORY_ATTACHMENTS:
               if(this.mAttachmentsTab)
               {
                  _loc3_ = DictionaryUtils.getCardsAmountPerCatalog(this.mAttachmentsCollection).toString();
                  this.mAttachmentsTab.updateText(_loc3_);
               }
               break;
            case CategoriesDefMng.CATEGORY_ACTIONS:
               if(this.mActionsTab)
               {
                  _loc4_ = DictionaryUtils.getCardsAmountPerCatalog(this.mOrdersCollection).toString();
                  this.mActionsTab.updateText(_loc4_);
               }
               break;
            case CategoriesDefMng.CATEGORY_POWERS:
               if(this.mPowersTab)
               {
                  _loc5_ = DictionaryUtils.getCardsAmountPerCatalog(this.mPowersCollection).toString();
                  this.mPowersTab.updateText(_loc5_);
               }
         }
      }
      
      protected function updateUIByCategorySelected(param1:int = 0) : void
      {
         if(this.mUnitsTab)
         {
            this.mUnitsTab.setIsSelected(this.mCategorySelected == CategoriesDefMng.CATEGORY_UNITS);
         }
         if(this.mAttachmentsTab)
         {
            this.mAttachmentsTab.setIsSelected(this.mCategorySelected == CategoriesDefMng.CATEGORY_ATTACHMENTS);
         }
         if(this.mActionsTab)
         {
            this.mActionsTab.setIsSelected(this.mCategorySelected == CategoriesDefMng.CATEGORY_ACTIONS);
         }
         if(this.mPowersTab)
         {
            this.mPowersTab.setIsSelected(this.mCategorySelected == CategoriesDefMng.CATEGORY_POWERS);
         }
         this.mCurrentPage = param1;
         if(this.mCollectionContainer != null)
         {
            this.fillCollectionContainer(true);
         }
      }
      
      public function lockTabs(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ShopMenuButton = null;
         if(this.mUnitsTab)
         {
            this.mUnitsTab.touchable = !param1;
         }
         if(this.mAttachmentsTab)
         {
            this.mAttachmentsTab.touchable = !param1;
         }
         if(this.mActionsTab)
         {
            this.mActionsTab.touchable = !param1;
         }
         if(this.mSubfilterButtonsContainer)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mSubfilterButtonsContainer.numChildren)
            {
               _loc3_ = this.mSubfilterButtonsContainer.getChildAt(_loc2_) is ShopMenuButton ? ShopMenuButton(this.mSubfilterButtonsContainer.getChildAt(_loc2_)) : null;
               if(_loc3_)
               {
                  _loc3_.touchable = !param1;
               }
               _loc2_++;
            }
         }
      }
      
      override public function lockUI(param1:Boolean) : void
      {
         this.mIsLocked = param1;
         this.lockTabs(param1);
         if(this.mCollectionContainer)
         {
            this.mCollectionContainer.touchable = !param1;
         }
         if(this.mUpArrow)
         {
            this.mUpArrow.touchable = !param1;
         }
         if(this.mDownArrow)
         {
            this.mDownArrow.touchable = !param1;
         }
         if(this.mSubfilterButtonsContainer)
         {
            this.mSubfilterButtonsContainer.touchable = !param1;
         }
         if(this.mEditButton)
         {
            this.mEditButton.enabled = !param1;
         }
         if(this.mDeckSelector)
         {
            this.mDeckSelector.touchable = !param1;
         }
         if(this.mDeckCardsPanel)
         {
            this.mDeckCardsPanel.touchable = !param1;
         }
         if(this.mRecycleButton)
         {
            this.mRecycleButton.enabled = !param1;
         }
         if(this.mFiltersContainer)
         {
            this.mFiltersContainer.touchable = !param1;
         }
         if(this.mViewAllCraftableCardsButton)
         {
            this.mViewAllCraftableCardsButton.touchable = !param1;
         }
      }
      
      private function createDeckTitle() : void
      {
         if(this.mDeckTitleBox == null)
         {
            this.mDeckTitleBox = new FSImage(Root.assets.getTexture(this.DECK_TITLE_NAME));
            this.mDeckTitleBox.x = this.mDeckSelector.x + (this.mDeckSelector.width - this.mDeckTitleBox.width) / 2;
            this.mDeckTitleBox.y = DECK_TITLE_BOX_Y;
            addChild(this.mDeckTitleBox);
         }
         this.createDeckTitleLabel();
         this.createEditTitleButton();
      }
      
      private function createEditTitleButton() : void
      {
         if(this.mEditButton == null && Boolean(Root.assets.getTexture(Constants.EDIT_BUTTON_NAME)))
         {
            this.mEditButton = new FSButton(Root.assets.getTexture(Constants.EDIT_BUTTON_NAME));
            this.mEditButton.x = this.mDeckTitleBox.x + this.mDeckTitleBox.width - this.mEditButton.width / 2;
            this.mEditButton.y = this.mDeckTitleBox.y + (this.mDeckTitleBox.height - this.mEditButton.height) / 2 + this.mEditButton.height / 2;
            this.mEditButton.addEventListener(Event.TRIGGERED,this.onEditClicked);
         }
         if(this.mEditButton)
         {
            this.mEditButton.visible = false;
            addChild(this.mEditButton);
         }
      }
      
      private function createDeckTitleTextInput() : void
      {
         if(this.mDeckTitleTextInput == null)
         {
            this.mDeckTitleTextInput = new FSTextInput();
            this.mDeckTitleTextInput.maxChars = Config.getConfig().getMaxDeckNameChars();
            this.mDeckTitleTextInput.width = this.mDeckTitleBox.width * 0.9;
            this.mDeckTitleTextInput.height = this.mDeckTitleBox.height * 0.6;
            this.mDeckTitleTextInput.x = this.mDeckTitleBox.x + (this.mDeckTitleBox.width - this.mDeckTitleTextInput.width) / 2;
            this.mDeckTitleTextInput.y = this.mDeckTitleBox.y + (this.mDeckTitleBox.height - this.mDeckTitleTextInput.height) / 2;
            this.mDeckTitleTextInput.addEventListener(FeathersEventType.ENTER,this.inputEnterHandler);
            this.mDeckTitleTextInput.addEventListener(FeathersEventType.FOCUS_OUT,this.inputFocusOutHandler);
            this.mDeckTitleTextInput.addEventListener(FeathersEventType.FOCUS_IN,this.inputFocusInHandler);
         }
         this.mDeckTitleTextInput.text = this.mDeckTitleLabel.text.toUpperCase();
         addChild(this.mDeckTitleTextInput);
         this.mDeckTitleTextInput.textEditorProperties.restrict = "a-z A-Z 0-9";
         if(Utils.isDesktop())
         {
            this.mDeckTitleTextInput.setFocus();
         }
      }
      
      private function createDeckTitleLabel() : void
      {
         if(this.mDeckTitleLabel == null)
         {
            this.mDeckTitleLabel = new FSTextfield(this.mDeckTitleBox.width * 0.9,this.mDeckTitleBox.height / 1.5,TextManager.getText("TID_LEVEL_DECK_MYDECKS"),16777215);
            this.mDeckTitleLabel.touchable = true;
            this.mDeckTitleLabel.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GOLD);
            this.mDeckTitleLabel.x = this.mDeckTitleBox.x + (this.mDeckTitleBox.width - this.mDeckTitleLabel.width) / 2;
            this.mDeckTitleLabel.y = this.mDeckTitleBox.y + (this.mDeckTitleBox.height - this.mDeckTitleLabel.height) / 2 + 2;
            addChild(this.mDeckTitleLabel);
            this.mDeckTitleLabel.addEventListener(TouchEvent.TOUCH,this.onDeckTitleTouch);
         }
      }
      
      private function onEditClicked(param1:Event) : void
      {
         this.editDeckTitle();
      }
      
      private function editDeckTitle() : void
      {
         if(this.mEditButton)
         {
            this.mEditButton.visible = false;
         }
         this.createDeckTitleTextInput();
         this.mDeckTitleLabel.visible = false;
      }
      
      private function onDeckTitleTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         if(!this.mIsRecyclingMode)
         {
            _loc2_ = param1.getTouch(this,TouchPhase.ENDED);
            if(_loc2_)
            {
               if(this.mEdidionStatus == STATUS_EDITING && !this.isViewAllCardsModeON())
               {
                  this.editDeckTitle();
               }
            }
         }
      }
      
      public function onStartEditingDeck() : void
      {
         if(this.mViewAllCraftableCardsButton)
         {
            this.mViewAllCraftableCardsButton.setEnabled(false);
            this.mViewAllCraftableCardsButton.visible = false;
         }
      }
      
      private function inputEnterHandler(param1:Event) : void
      {
         this.onSaveTextInputData();
      }
      
      private function inputFocusOutHandler(param1:Event) : void
      {
         this.onSaveTextInputData();
      }
      
      private function inputFocusInHandler(param1:Event) : void
      {
         this.mDeckTitleTextInput.selectRange(0,this.mDeckTitleTextInput.text.length);
      }
      
      private function onSaveTextInputData() : void
      {
         if(this.mDeckTitleTextInput != null)
         {
            if(this.mDeckTitleLabel != null)
            {
               this.mDeckTitleLabel.text = this.mDeckTitleTextInput.text.toUpperCase();
               this.mDeckTitleLabel.touchable = true;
               this.mDeckTitleTextInput.removeFromParent();
               this.mDeckTitleLabel.visible = true;
               if(this.mEditButton)
               {
                  this.mEditButton.visible = true;
               }
            }
         }
      }
      
      public function updateDeckTitleLabel(param1:int = -1, param2:String = "") : void
      {
         if(this.mDeckTitleLabel != null)
         {
            if(param1 == -1)
            {
               param2 = param2 == "" ? TextManager.getText("TID_LEVEL_DECK_MYDECKS") : param2;
            }
            else
            {
               param2 = InstanceMng.getUserDataMng().getOwnerUserData() ? InstanceMng.getUserDataMng().getOwnerUserData().getDeckName(param1) : "";
            }
            this.mDeckTitleLabel.text = param2 ? param2.toUpperCase() : "";
         }
      }
      
      public function setEditButtonVisible(param1:Boolean) : void
      {
         if(this.mEditButton != null)
         {
            this.mEditButton.visible = param1;
            addChild(this.mEditButton);
         }
      }
      
      private function createDeckSelector() : void
      {
         if(this.mDeckSelector == null)
         {
            this.mDeckSelector = new DeckSelector();
            this.mDeckSelector.name = "deck_selector";
            this.mDeckSelector.x = Starling.current.stage.stageWidth - this.mDeckSelector.width * 1.05;
            this.mDeckSelector.y = DECK_SELECTOR_Y;
         }
         this.mDeckSelector.refresh();
         addChild(this.mDeckSelector);
      }
      
      protected function createGoldVisor(param1:Boolean = true) : void
      {
         if(this.mGoldVisor == null)
         {
            this.mGoldVisor = new FSCurrencyVisor(ServerConnection.CURRENCY_GOLD);
            this.mGoldVisor.x = this.mDeckSelector.x + this.mGoldVisor.width * 0.4;
            this.mGoldVisor.y = this.mGoldVisor.height / 2;
            addChild(this.mGoldVisor);
         }
      }
      
      public function fillCollections(param1:Boolean = false) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:DeckJobConfigurator = null;
         var _loc4_:JobDef = null;
         if(InstanceMng.getUserDataMng().getOwnerUserData())
         {
            if(this.mEdidionStatus == STATUS_CREATION_MODE || this.mFilteringAllCards)
            {
               _loc2_ = this.mEdidionStatus == STATUS_CREATION_MODE;
               this.mUnitsCollection = DictionaryUtils.getAllUnitsCatalog(_loc2_);
               this.mAttachmentsCollection = DictionaryUtils.getAllAttachmentsCatalog(_loc2_);
               this.mOrdersCollection = DictionaryUtils.getAllActionsCatalog(_loc2_);
               this.mPowersCollection = DictionaryUtils.getAllPowersCatalog(_loc2_);
            }
            else if(Config.getConfig().gameHasClassSystem() && this.mEdidionStatus == STATUS_EDITING && !this.isViewAllCardsModeON())
            {
               _loc3_ = InstanceMng.getUserDataMng().getOwnerUserData().getDeckJobConfiguratorByDeck(InstanceMng.getUserDataMng().getOwnerUserData().getSelectedDeckIndex());
               if(_loc3_)
               {
                  _loc4_ = JobDef(InstanceMng.getJobsDefMng().getDefBySku(_loc3_.getJobSku()));
                  if(_loc4_)
                  {
                     this.mUnitsCollection = DictionaryUtils.getCatalogFilteredByCategory(JobsMng.getAllCardsForJobDic(_loc4_),CategoriesDefMng.CATEGORY_UNITS);
                     this.mAttachmentsCollection = DictionaryUtils.getCatalogFilteredByCategory(JobsMng.getAllCardsForJobDic(_loc4_),CategoriesDefMng.CATEGORY_ATTACHMENTS);
                     this.mOrdersCollection = DictionaryUtils.getCatalogFilteredByCategory(JobsMng.getAllCardsForJobDic(_loc4_),CategoriesDefMng.CATEGORY_ACTIONS);
                     this.mPowersCollection = DictionaryUtils.getCatalogFilteredByCategory(JobsMng.getAllCardsForJobDic(_loc4_),CategoriesDefMng.CATEGORY_POWERS);
                     this.mPowersCollection = DictionaryUtils.filterCatalogByPowersBelongingToClass(this.mPowersCollection,_loc4_);
                  }
               }
            }
            else
            {
               this.mUnitsCollection = this.getOnlyVisibleCards(InstanceMng.getUserDataMng().getOwnerUserData().getCollectionFilteredByCategory(CategoriesDefMng.CATEGORY_UNITS));
               this.mAttachmentsCollection = this.getOnlyVisibleCards(InstanceMng.getUserDataMng().getOwnerUserData().getCollectionFilteredByCategory(CategoriesDefMng.CATEGORY_ATTACHMENTS));
               this.mOrdersCollection = this.getOnlyVisibleCards(InstanceMng.getUserDataMng().getOwnerUserData().getCollectionFilteredByCategory(CategoriesDefMng.CATEGORY_ACTIONS));
               this.mPowersCollection = this.getOnlyVisibleCards(InstanceMng.getUserDataMng().getOwnerUserData().getCollectionFilteredByCategory(CategoriesDefMng.CATEGORY_POWERS));
            }
            if(param1)
            {
               if(!Root.assets.isLoading)
               {
                  this.fillCollectionContainer(true);
               }
               else
               {
                  TweenMax.delayedCall(0.25,this.fillCollections,[true]);
               }
            }
         }
      }
      
      private function getOnlyVisibleCards(param1:Dictionary, param2:Boolean = true) : Dictionary
      {
         var _loc5_:int = 0;
         var _loc6_:CardDef = null;
         var _loc3_:Array = DictionaryUtils.getKeys(param1);
         var _loc4_:Dictionary = new Dictionary(true);
         _loc5_ = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc6_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc3_[_loc5_]));
            if(_loc6_.getIsVisible() && (_loc6_.isFusion() == param2 || !_loc6_.isFusion()))
            {
               _loc4_[_loc3_[_loc5_]] = param1[_loc3_[_loc5_]];
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      private function updateCollectionByCategorySelected(param1:Boolean = false) : Dictionary
      {
         var _loc2_:Dictionary = null;
         switch(this.mCategorySelected)
         {
            case CategoriesDefMng.CATEGORY_UNITS:
               _loc2_ = this.mUnitsCollection;
               break;
            case CategoriesDefMng.CATEGORY_ATTACHMENTS:
               _loc2_ = this.mAttachmentsCollection;
               break;
            case CategoriesDefMng.CATEGORY_ACTIONS:
               _loc2_ = this.mOrdersCollection;
               break;
            case CategoriesDefMng.CATEGORY_POWERS:
               _loc2_ = this.mPowersCollection;
         }
         if(param1)
         {
            this.mCurrentCollectionOnFilters = DictionaryUtils.filterCatalog(_loc2_,this.mIsCraftFilterON,false,this.mRaritiesToShowCatalog,this.mFactionsToShowCatalog,this.mSubcategoriesToShowCatalog,this.mEditionsToShowCatalog,this.mSummonCostToShowCatalog,this.mFilteringOnlyFavouriteCards,this.mFilteringOnlyNewCards,this.mSearchFilter,this.mSearchFilter);
         }
         else
         {
            this.mCurrentCollectionOnFilters = DictionaryUtils.filterCatalog(_loc2_,this.mIsCraftFilterON,true,this.mRaritiesToShowCatalog,this.mFactionsToShowCatalog,this.mSubcategoriesToShowCatalog,this.mEditionsToShowCatalog,this.mSummonCostToShowCatalog,this.mFilteringOnlyFavouriteCards,this.mFilteringOnlyNewCards,this.mSearchFilter,this.mSearchFilter);
         }
         return this.mCurrentCollectionOnFilters;
      }
      
      private function calculateCollectionByCategory(param1:Boolean = false, param2:int = 0) : Dictionary
      {
         var _loc3_:Dictionary = null;
         switch(param2)
         {
            case CategoriesDefMng.CATEGORY_UNITS:
               _loc3_ = this.mUnitsCollection;
               break;
            case CategoriesDefMng.CATEGORY_ATTACHMENTS:
               _loc3_ = this.mAttachmentsCollection;
               break;
            case CategoriesDefMng.CATEGORY_ACTIONS:
               _loc3_ = this.mOrdersCollection;
               break;
            case CategoriesDefMng.CATEGORY_POWERS:
               _loc3_ = this.mOrdersCollection;
         }
         if(param1)
         {
            this.mCurrentCollectionOnFilters = DictionaryUtils.filterCatalog(_loc3_,this.mIsCraftFilterON,false,this.mRaritiesToShowCatalog,this.mFactionsToShowCatalog,this.mSubcategoriesToShowCatalog,this.mEditionsToShowCatalog,this.mSummonCostToShowCatalog,this.mFilteringOnlyFavouriteCards,this.mFilteringOnlyNewCards,this.mSearchFilter,this.mSearchFilter);
         }
         else
         {
            this.mCurrentCollectionOnFilters = DictionaryUtils.filterCatalog(_loc3_,this.mIsCraftFilterON,true,this.mRaritiesToShowCatalog,this.mFactionsToShowCatalog,this.mSubcategoriesToShowCatalog,this.mEditionsToShowCatalog,this.mSummonCostToShowCatalog,this.mFilteringOnlyFavouriteCards,this.mFilteringOnlyNewCards,this.mSearchFilter,this.mSearchFilter);
         }
         return _loc3_;
      }
      
      private function requestNewCollectionData() : void
      {
         this.updateCollectionByCategorySelected(true);
         var _loc1_:Array = this.getCurrentPageCards();
         if(_loc1_ != null)
         {
            InstanceMng.getResourcesMng().loadCardImagesByArray(_loc1_);
         }
         InstanceMng.getResourcesMng().loadAssets();
      }
      
      public function updateCollectionFilteredWithDeck() : void
      {
         var _loc1_:Dictionary = this.mEdidionStatus == STATUS_EDITING && !this.isViewAllCardsModeON() ? this.getCurrentCardsPanel().getDeckCardsLoaded() : null;
         this.mCollectionFilteredWithDeck = DictionaryUtils.filterCatalogByCardsAlreadyOnDeck(this.mCurrentCollectionOnFilters,_loc1_);
      }
      
      private function updateSubcategoriesFiltersState() : void
      {
         var _loc1_:Boolean = this.mCategorySelected != CategoriesDefMng.CATEGORY_ACTIONS;
         if(this.mSubCategoriesFilterButton)
         {
            this.mSubCategoriesFilterButton.setEnabled(_loc1_);
         }
      }
      
      private function getCurrentPageCards() : Array
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:Array = DictionaryUtils.dictionaryToArray(this.mCurrentCollectionOnFilters,true);
         this.mCurrentPageCardsSorted = null;
         if(_loc1_ != null)
         {
            _loc1_.sort(DictionaryUtils.sortCardsSkusByValue);
            _loc2_ = this.getContainerColumnsAmountAllowed() * 2;
            _loc3_ = _loc2_ * this.mCurrentPage;
            _loc4_ = 0;
            if(this.mCurrentPageCardsSorted == null)
            {
               this.mCurrentPageCardsSorted = new Array();
            }
            else
            {
               this.mCurrentPageCardsSorted.length = 0;
            }
            _loc5_ = _loc3_;
            while(_loc5_ < _loc1_.length)
            {
               if(_loc4_ < _loc2_)
               {
                  this.mCurrentPageCardsSorted.push(_loc1_[_loc5_]);
                  _loc4_++;
               }
               _loc5_++;
            }
         }
         return this.mCurrentPageCardsSorted;
      }
      
      private function fillCollectionContainer(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         var _loc3_:FSCard = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Dictionary = null;
         this.updateSubcategoriesFiltersState();
         this.lockUI(true);
         if(this.mCollectionContainer)
         {
            this.mCollectionContainer.removeChildren();
            this.triggerTouchWorkaround();
            if(param1)
            {
               if(Boolean(this.mDeckCraftInfoPanel) && Boolean(this.mDeckCraftInfoPanel.getCraftFilterButton()))
               {
                  this.mDeckCraftInfoPanel.getCraftFilterButton().touchable = false;
               }
               showLoadingIcon(true,true,Align.LEFT,Align.TOP,1,null,this.mCollectionContainer);
               DictionaryUtils.disposeCatalogCards(this.mCardInfoCatalog);
               DictionaryUtils.clearDictionary(this.mCardInfoCatalog);
               this.mCardInfoCatalog = null;
               this.requestNewCollectionData();
               return;
            }
            showLoadingIcon(false,true);
            if(Boolean(this.mDeckCraftInfoPanel) && Boolean(this.mDeckCraftInfoPanel.getCraftFilterButton()))
            {
               this.mDeckCraftInfoPanel.getCraftFilterButton().touchable = true;
            }
            if(this.mTutorialRequested)
            {
               if(InstanceMng.getTutorialDeckBuilderMng())
               {
                  InstanceMng.getTutorialDeckBuilderMng().startTutorial();
                  this.mTutorialRequested = false;
               }
            }
            this.setFilterButtonsTouchable(true);
            this.updateCollectionByCategorySelected(true);
            this.updateCollectionFilteredWithDeck();
            this.updatePageTextfield();
            if(this.mCurrentPageCardsSorted)
            {
               _loc7_ = this.getContainerColumnsAmountAllowed() * 2;
               _loc8_ = 0;
               _loc9_ = 0;
               _loc10_ = Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) ? InstanceMng.getUserDataMng().getOwnerUserData().getCardCollection() : null;
               if(_loc10_)
               {
                  _loc6_ = _loc8_;
                  while(_loc6_ < this.mCurrentPageCardsSorted.length)
                  {
                     if(_loc9_ < _loc7_)
                     {
                        _loc5_ = String(this.mCurrentPageCardsSorted[_loc6_]).split(":");
                        _loc4_ = _loc5_[0];
                        _loc2_ = this.mEdidionStatus != STATUS_CREATION_MODE && !this.isViewAllCardsModeON() ? int(_loc5_[1]) : int(_loc10_[_loc4_]);
                        this.addCardToContainer(_loc4_,_loc2_,_loc6_ < _loc7_,_loc9_ * 0.03,_loc9_);
                        if(this.mDeckCardsPanel != null && Config.getConfig().gameHasPowers())
                        {
                           if(this.mDeckCardsPanel.getcurrentDeckPowerSku() != null && this.mDeckCardsPanel.getcurrentDeckPowerSku() != "" && this.mDeckCardsPanel.getcurrentDeckPowerSku() == _loc4_)
                           {
                              this.getCardInfoByCardSku(this.mDeckCardsPanel.getcurrentDeckPowerSku()).showPowerSelectedText();
                           }
                        }
                        _loc9_++;
                     }
                     _loc6_++;
                  }
               }
               this.refreshUI();
            }
            else
            {
               this.lockUI(false);
               this.refreshArrowButtonsState();
            }
         }
      }
      
      private function triggerTouchWorkaround() : void
      {
         if(this.mInvisibleQuad == null)
         {
            this.mInvisibleQuad = new Quad(COLLECTION_CONTAINER_WIDTH,COLLECTION_CONTAINER_HEIGHT);
            this.mInvisibleQuad.touchable = true;
            this.mInvisibleQuad.alpha = 0.000001;
         }
         if(this.mCollectionContainer)
         {
            this.mCollectionContainer.addChild(this.mInvisibleQuad);
         }
      }
      
      public function refreshUI() : void
      {
         this.showRecycleCostOnCollection(this.mIsRecyclingMode);
         this.refreshTabsAmount();
         this.refreshNewCardsAmountsOnTabs();
         this.refreshArrowButtonsState();
         this.setCardsAvailablesForCrafting();
         this.setCardsAvailablesForFusion();
         this.lockUI(false);
         if(Boolean(this.mViewAllCraftableCardsButton) && this.mIsAnyCardCrafteable == false)
         {
            this.mViewAllCraftableCardsButton.hideDeckNotificationIcon();
         }
         if(Boolean(this.mDeckCraftInfoPanel) && Boolean(this.mDeckCraftInfoPanel.getCraftFilterButton()) && !this.mIsAnyCardCrafteable)
         {
            this.mDeckCraftInfoPanel.getCraftFilterButton().hideDeckNotificationIcon();
         }
      }
      
      public function addCardToContainer(param1:String, param2:int, param3:Boolean, param4:Number, param5:int) : void
      {
         var _loc6_:DeckBuilderCard = null;
         var _loc8_:FSCoordinate = null;
         var _loc11_:FSCard = null;
         var _loc12_:Boolean = false;
         var _loc13_:int = 0;
         var _loc7_:int = 0;
         if(this.mCardInfoCatalog != null && this.mCardInfoCatalog[param1] != null)
         {
            _loc6_ = DeckBuilderCard(this.mCardInfoCatalog[param1]);
            _loc7_ = this.mCollectionFilteredWithDeck[param1] != null ? int(this.mCollectionFilteredWithDeck[param1]) : param2;
            if(this.cardNeedsToShowMaxAmountSocket(_loc6_.getCardDef()))
            {
               _loc6_.createMaxAmountSocket();
            }
            else
            {
               _loc6_.removeMaxAmountSocket();
            }
            _loc6_.setAmount(_loc7_);
         }
         else
         {
            _loc11_ = InstanceMng.getCardsMng().createCard(param1);
            _loc12_ = false;
            if(this.mEdidionStatus != STATUS_CREATION_MODE)
            {
               _loc7_ = Boolean(this.mCollectionFilteredWithDeck) && this.mCollectionFilteredWithDeck[param1] != null ? int(this.mCollectionFilteredWithDeck[param1]) : param2;
               _loc12_ = this.cardNeedsToShowMaxAmountSocket(_loc11_.getCardDef());
               _loc6_ = new DeckBuilderCard(_loc11_,_loc7_,true,_loc12_);
               if(this.mEdidionStatus == STATUS_EDITING && !this.isRecyclingMode())
               {
                  _loc6_.showCardLimitSocket();
               }
            }
            else
            {
               _loc7_ = param2;
               _loc6_ = new DeckBuilderCard(_loc11_,_loc7_,true,_loc12_);
            }
            if(this.mEdidionStatus == STATUS_CREATION_MODE || this.isViewAllCardsModeON())
            {
               _loc6_.alpha = param2 > 0 ? 0.999 : 0.55;
            }
         }
         if(param3 && this.mEdidionStatus != STATUS_CREATION_MODE && !this.isViewAllCardsModeON())
         {
            _loc6_.alpha = 0.001;
            _loc6_.touchable = false;
            TweenMax.delayedCall(param4,SpecialFX.tweenToAlpha,[_loc6_,0.999,param4,0,this.setDeckBuilderCardTouchable,[_loc6_]]);
         }
         else
         {
            _loc6_.touchable = true;
         }
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         _loc9_ = this.mCollectionContainer != null ? COLLECTION_CONTAINER_WIDTH : 0;
         _loc10_ = this.mCollectionContainer != null ? COLLECTION_CONTAINER_HEIGHT : 0;
         _loc8_ = Utils.getXYPositionInContainer(param5,_loc6_.width,_loc6_.height,_loc9_,_loc10_,this.getContainerColumnsAmountAllowed(),2,true);
         _loc6_.x = _loc8_.getX();
         _loc6_.y = _loc8_.getY();
         this.mCollectionContainer.addChild(_loc6_);
         if(InstanceMng.getTutorialDeckBuilderMng().isTutorialON())
         {
            if(isTransparentBGShown())
            {
               _loc13_ = getChildIndex(mTouchableBG) - 1;
               _loc13_ = _loc13_ >= 0 ? _loc13_ : 0;
               addChildAt(this.mCollectionContainer,_loc13_);
            }
         }
         this.addToCardInfoCatalog(param1,_loc6_);
      }
      
      protected function setDeckBuilderCardTouchable(param1:DeckBuilderCard) : void
      {
         if(param1)
         {
            param1.setTouchable();
         }
      }
      
      public function cardNeedsToShowMaxAmountSocket(param1:CardDef) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = param1.getMaxAmountOndeck();
         var _loc4_:int = Boolean(this.mCollectionFilteredWithDeck) && this.mCollectionFilteredWithDeck[param1.getSku()] != null ? int(this.mCollectionFilteredWithDeck[param1.getSku()]) : 0;
         var _loc5_:int = this.mCurrentCollectionOnFilters ? int(this.mCurrentCollectionOnFilters[param1.getSku()]) : 0;
         var _loc6_:int = _loc5_ - _loc4_;
         return this.mCollectionFilteredWithDeck && this.mCollectionFilteredWithDeck[param1.getSku()] != null && this.mCollectionFilteredWithDeck[param1.getSku()] == 0 || _loc6_ >= _loc3_ && !this.isRecyclingMode();
      }
      
      private function addToCardInfoCatalog(param1:String, param2:InfoCard) : void
      {
         if(this.mCardInfoCatalog == null)
         {
            this.mCardInfoCatalog = new Dictionary(true);
         }
         this.mCardInfoCatalog[param1] = param2;
      }
      
      public function getCardInfoByCardSku(param1:String) : DeckBuilderCard
      {
         var _loc2_:DeckBuilderCard = null;
         if(this.mCardInfoCatalog != null)
         {
            if(this.mCardInfoCatalog[param1] != null)
            {
               return this.mCardInfoCatalog[param1];
            }
         }
         return _loc2_;
      }
      
      public function removeCardInfoByCardSku(param1:String) : void
      {
         if(this.mCardInfoCatalog != null)
         {
            if(this.mCardInfoCatalog[param1] != null)
            {
               delete this.mCardInfoCatalog[param1];
            }
         }
      }
      
      private function createCollectionContainer(param1:Boolean = false, param2:Boolean = true) : void
      {
         if(this.mCollectionContainer == null)
         {
            this.mCollectionContainer = new Component();
            this.triggerTouchWorkaround();
            if(!Utils.isMobile())
            {
               this.mCollectionContainer.touchable = true;
               touchable = true;
            }
            this.mCollectionContainer.name = "collection_container";
            this.mCollectionContainer.x = this.getCollectionContainerPosX();
            this.mCollectionContainer.y = this.getCollectionContainerPosY();
            this.mCollectionContainer.width = COLLECTION_CONTAINER_WIDTH;
            this.mCollectionContainer.height = COLLECTION_CONTAINER_HEIGHT;
            this.mCollectionContainer.addEventListener(TouchEvent.TOUCH,this.onCollectionTouch);
         }
         addChild(this.mCollectionContainer);
         if(param2)
         {
            this.fillCollectionContainer(param1);
         }
         if(Utils.isDesktop() || Utils.isBrowser())
         {
            Starling.current.nativeStage.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel,false,0,true);
         }
      }
      
      public function getCardsContainer() : Component
      {
         return this.mCollectionContainer;
      }
      
      private function onCollectionTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this.mCollectionContainer,TouchPhase.HOVER);
         this.mCollectionScrollerHovered = _loc2_ != null;
      }
      
      protected function onMouseWheel(param1:MouseEvent) : void
      {
         if(this.mCollectionScrollerHovered && !Root.assets.isLoading)
         {
            if(!this.isAnyCardMoving())
            {
               if(param1.delta < 0)
               {
                  this.goToNextPage();
               }
               else
               {
                  this.goToPrevPage();
               }
            }
         }
      }
      
      public function getCollectionContainerPosX() : int
      {
         return Starling.current.stage.stageWidth * 0.0255;
      }
      
      public function getCollectionContainerPosY() : int
      {
         return Starling.current.stage.stageHeight * 0.2;
      }
      
      public function setCollectionContainerScrollable(param1:Boolean) : void
      {
         this.mCollectionScrollable = param1;
      }
      
      private function isAnyCardMoving() : Boolean
      {
         var _loc2_:DeckBuilderCard = null;
         var _loc3_:int = 0;
         var _loc1_:Boolean = false;
         _loc3_ = 0;
         while(_loc3_ < this.mCollectionContainer.numChildren)
         {
            if(this.mCollectionContainer.getChildAt(_loc3_) is DeckBuilderCard)
            {
               if(DeckBuilderCard(this.mCollectionContainer.getChildAt(_loc3_)) != null && DeckBuilderCard(this.mCollectionContainer.getChildAt(_loc3_)).isMoving())
               {
                  return true;
               }
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      private function getContainerColumnsAmountAllowed() : int
      {
         return Utils.isIOS() && !Utils.isIphone() ? 3 : 4;
      }
      
      public function showCraftInfoPanel() : void
      {
         if(this.mDeckCraftInfoPanel == null)
         {
            this.mDeckCraftInfoPanel = new DeckCraftInfoPanel();
            this.mDeckCraftInfoPanel.name = "deck_craft_panel";
         }
         if(this.mDeckCraftInfoPanel)
         {
            this.mDeckCraftInfoPanel.setCraftFilterButtonVisible(true);
         }
         this.mDeckCraftInfoPanel.x = this.mDeckTitleBox.x - (this.mDeckCraftInfoPanel.width - this.mDeckTitleBox.width) / 2;
         this.mDeckCraftInfoPanel.y = -this.mDeckCraftInfoPanel.height;
         addChild(this.mDeckCraftInfoPanel);
         addChild(this.mDeckTitleBox);
         addChild(this.mDeckTitleLabel);
         this.showRecycleButton(false);
         var _loc1_:FSCoordinate = new FSCoordinate(this.mDeckCraftInfoPanel.x,Starling.current.stage.stageHeight * 0.1);
         SpecialFX.createTransition(this.mDeckCraftInfoPanel,_loc1_,0.5,0,this.onCraftInfoPanelShown);
         this.fillCollections();
         this.resetContainerAndFill();
      }
      
      private function onCraftInfoPanelShown() : void
      {
         InstanceMng.getCurrentScreen().reAddUIVisualsOptions();
         var _loc1_:UserData = Utils.getOwnerUserData();
         var _loc2_:Boolean = _loc1_.flagsGetCraftTutorialSeenON();
         if(!_loc2_)
         {
            _loc1_.setCraftTutorialSeenON(true);
            InstanceMng.getUserDataMng().persistenceSaveData();
            InstanceMng.getPopupMng().openGetImageAndTextPopup(TextManager.getText("TID_CRAFT_TUTORIAL"),"craft_tutorial_image");
         }
      }
      
      public function showDeckPanel(param1:int) : void
      {
         if(this.mDeckCardsPanel == null)
         {
            this.mDeckCardsPanel = new DeckCardsPanel(param1);
            this.mDeckCardsPanel.name = "deck_panel";
         }
         this.mDeckCardsPanel.x = this.mDeckTitleBox.x - (this.mDeckCardsPanel.width - this.mDeckTitleBox.width) / 2;
         this.mDeckCardsPanel.y = -this.mDeckCardsPanel.height;
         addChild(this.mDeckCardsPanel);
         this.sortDeckPanel(param1);
         addChild(this.mDeckTitleBox);
         addChild(this.mDeckTitleLabel);
         this.mDeckTitleLabel.visible = true;
         this.showRecycleButton(false);
         this.setEdidionStatus(STATUS_EDITING);
      }
      
      private function sortDeckPanel(param1:int) : void
      {
         var _loc2_:FSCoordinate = new FSCoordinate(this.mDeckCardsPanel.x,Starling.current.stage.stageHeight * 0.08);
         var _loc3_:Boolean = Config.getConfig().deckBuilderSortByCategory();
         var _loc4_:Boolean = Config.getConfig().deckBuilderSortByFaction();
         SpecialFX.createTransition(this.mDeckCardsPanel,_loc2_,0.5,0,this.setupDeckCardsPanel,[param1,_loc3_,_loc4_]);
      }
      
      protected function setupDeckCardsPanel(param1:int, param2:Boolean = true, param3:Boolean = false) : void
      {
         if(this.mDeckCardsPanel)
         {
            this.mDeckCardsPanel.setup(param1,param2,param3);
         }
      }
      
      public function showDeckTitle(param1:Boolean) : void
      {
         var onComplete:Function = null;
         var value:Boolean = param1;
         onComplete = function():void
         {
            mDeckTitleBox.visible = value;
            mDeckTitleLabel.visible = value;
         };
         var alpha:Number = value ? 0.999 : 0.001;
         if(value)
         {
            this.mDeckTitleBox.visible = true;
            this.mDeckTitleLabel.visible = true;
         }
         if(this.mDeckTitleBox != null)
         {
            SpecialFX.tweenToAlpha(this.mDeckTitleBox,alpha,0.5,0);
         }
         if(this.mDeckTitleLabel != null)
         {
            SpecialFX.tweenToAlpha(this.mDeckTitleLabel,alpha,0.5,0,onComplete);
         }
      }
      
      public function showRecycleButton(param1:Boolean) : void
      {
         if(this.mRecycleButton != null)
         {
            this.mRecycleButton.visible = param1;
         }
      }
      
      public function onFinishEditing() : void
      {
         if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).updateCurrentJobSelected(null);
         }
         this.lockUI(false);
         if(this.mDeckSelector != null)
         {
            this.mDeckSelector.refresh();
         }
         this.setEdidionStatus(STATUS_NOT_EDITING);
         this.setIsRecyclingMode(false);
         this.mCurrentPage = 0;
         this.mViewAllCraftableCardsButton.setEnabled(true);
         this.mViewAllCraftableCardsButton.visible = true;
         this.fillCollections(true);
         this.showRecycleButton(true);
      }
      
      public function showMenu() : void
      {
         dispatchEventWith(Screen.GO_TO_MENU,true);
      }
      
      public function showMap() : void
      {
         dispatchEventWith(Screen.GO_TO_MAP,true);
      }
      
      override public function unload() : void
      {
         if(InstanceMng.getUserDataMng())
         {
            InstanceMng.getUserDataMng().updateNewCardsCollection();
            InstanceMng.getUserDataMng().updateFavouriteCardsCollection();
         }
         Starling.current.nativeStage.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         DictionaryUtils.disposeCatalogCards(this.mCardInfoCatalog);
         if(this.mCollectionContainer)
         {
            this.mCollectionContainer.removeChildren(0,-1,true);
            this.mCollectionContainer.removeFromParent(true);
            this.mCollectionContainer = null;
         }
         if(this.mInvisibleQuad)
         {
            this.mInvisibleQuad.removeFromParent(true);
            this.mInvisibleQuad = null;
         }
         if(this.mSubfilterButtonsContainer)
         {
            this.mSubfilterButtonsContainer.removeChildren(0,-1,true);
            this.mSubfilterButtonsContainer.removeFromParent(true);
            this.mSubfilterButtonsContainer = null;
         }
         if(this.mJobPanel)
         {
            this.mJobPanel.unload();
            this.mJobPanel.removeFromParent();
            this.mJobPanel = null;
         }
         if(this.mDeckCraftInfoPanel)
         {
            this.mDeckCraftInfoPanel.removeFromParent(true);
            this.mDeckCraftInfoPanel = null;
         }
         DictionaryUtils.clearDictionary(this.mUnitsCollection);
         this.mUnitsCollection = null;
         DictionaryUtils.clearDictionary(this.mAttachmentsCollection);
         this.mAttachmentsCollection = null;
         DictionaryUtils.clearDictionary(this.mOrdersCollection);
         this.mOrdersCollection = null;
         DictionaryUtils.clearDictionary(this.mPowersCollection);
         this.mPowersCollection = null;
         DictionaryUtils.clearDictionary(this.mCurrentCollectionOnFilters);
         this.mCurrentCollectionOnFilters = null;
         DictionaryUtils.clearDictionary(this.mFactionsToShowCatalog);
         this.mFactionsToShowCatalog = null;
         DictionaryUtils.clearDictionary(this.mSummonCostToShowCatalog);
         this.mSummonCostToShowCatalog = null;
         DictionaryUtils.clearDictionary(this.mCollectionFilteredWithDeck);
         this.mCollectionFilteredWithDeck = null;
         DictionaryUtils.clearDictionary(this.mCardInfoCatalog);
         this.mCardInfoCatalog = null;
         DictionaryUtils.clearDictionary(this.mSubcategoriesToShowCatalog);
         this.mSubcategoriesToShowCatalog = null;
         DictionaryUtils.clearDictionary(this.mRaritiesToShowCatalog);
         this.mRaritiesToShowCatalog = null;
         DictionaryUtils.clearDictionary(this.mEditionsToShowCatalog);
         this.mEditionsToShowCatalog = null;
         this.mCollectionRarities = null;
         this.mCurrentJobDefSelected = null;
         if(this.mDeckSelector)
         {
            this.mDeckSelector.removeFromParent(false);
            this.mDeckSelector = null;
         }
         if(this.mDeckTitleBox)
         {
            this.mDeckTitleBox.removeFromParent(true);
            this.mDeckTitleBox = null;
         }
         if(this.mDeckTitleTextInput)
         {
            this.mDeckTitleTextInput.removeFromParent(true);
            this.mDeckTitleTextInput = null;
         }
         if(this.mDeckTitleLabel)
         {
            this.mDeckTitleLabel.removeFromParent(true);
            this.mDeckTitleLabel = null;
         }
         if(this.mDeckCardsPanel)
         {
            this.mDeckCardsPanel.removeFromParent(true);
            this.mDeckCardsPanel = null;
         }
         if(this.mEditButton)
         {
            this.mEditButton.removeFromParent(true);
            this.mEditButton = null;
         }
         mSelectedCard = null;
         if(this.mUnitsTab)
         {
            this.mUnitsTab.removeFromParent(true);
            this.mUnitsTab = null;
         }
         if(this.mAttachmentsTab)
         {
            this.mAttachmentsTab.removeFromParent(true);
            this.mAttachmentsTab = null;
         }
         if(this.mActionsTab)
         {
            this.mActionsTab.removeFromParent(true);
            this.mActionsTab = null;
         }
         if(this.mRecyclePanel)
         {
            this.mRecyclePanel.removeFromParent(true);
            this.mRecyclePanel = null;
         }
         if(this.mRecycleButton)
         {
            this.mRecycleButton.removeFromParent(true);
            this.mRecycleButton = null;
         }
         if(this.mRecyclePanel)
         {
            this.mRecyclePanel.removeFromParent(true);
            this.mRecyclePanel = null;
         }
         if(this.mGoldVisor)
         {
            this.mGoldVisor.removeFromParent(true);
            this.mGoldVisor = null;
         }
         if(this.mDownArrow)
         {
            this.mDownArrow.removeFromParent(true);
            this.mDownArrow = null;
         }
         if(this.mUpArrow)
         {
            this.mUpArrow.removeFromParent(true);
            this.mUpArrow = null;
         }
         if(this.mPageIndicatorTextfield)
         {
            this.mPageIndicatorTextfield.removeFromParent(true);
            this.mPageIndicatorTextfield = null;
         }
         if(this.mDeckValueIndicatorTextfield)
         {
            this.mDeckValueIndicatorTextfield.removeFromParent(true);
            this.mDeckValueIndicatorTextfield = null;
         }
         if(this.mViewAllCraftableCardsButton)
         {
            this.mViewAllCraftableCardsButton.removeFromParent(true);
            this.mViewAllCraftableCardsButton = null;
         }
         if(this.mSummonCostFilterButton)
         {
            this.mSummonCostFilterButton.removeFromParent(true);
            this.mSummonCostFilterButton = null;
         }
         if(this.mRaidCoinsText)
         {
            this.mRaidCoinsText.removeFromParent(true);
            this.mRaidCoinsText = null;
         }
         if(this.mAbilityFilterButton)
         {
            this.mAbilityFilterButton.removeFromParent(true);
            this.mAbilityFilterButton = null;
         }
         if(this.mAllCardsFilterButton)
         {
            this.mAllCardsFilterButton.removeFromParent(true);
            this.mAllCardsFilterButton = null;
         }
         Utils.destroyArray(this.mCurrentPageCardsSorted);
         this.mCurrentPageCardsSorted = null;
         if(this.mSubfiltersContainer)
         {
            this.mSubfiltersContainer.removeFromParent(true);
            this.mSubfiltersContainer = null;
         }
         if(this.mFiltersContainer)
         {
            this.mFiltersContainer.removeFromParent(true);
            this.mFiltersContainer = null;
         }
         if(this.mSubFiltersContainerBG1)
         {
            this.mSubFiltersContainerBG1.removeFromParent(true);
            this.mSubFiltersContainerBG1 = null;
         }
         if(this.mSubFiltersContainerBG2)
         {
            this.mSubFiltersContainerBG2.removeFromParent(true);
            this.mSubFiltersContainerBG2 = null;
         }
         if(this.mFactionFilterButton)
         {
            this.mFactionFilterButton.removeFromParent(true);
            this.mFactionFilterButton = null;
         }
         if(this.mSubCategoriesFilterButton)
         {
            this.mSubCategoriesFilterButton.removeFromParent(true);
            this.mSubCategoriesFilterButton = null;
         }
         if(this.mRaritiesFilterButton)
         {
            this.mRaritiesFilterButton.removeFromParent(true);
            this.mRaritiesFilterButton = null;
         }
         if(this.mEditionFilterButton)
         {
            this.mEditionFilterButton.removeFromParent(true);
            this.mEditionFilterButton = null;
         }
         if(this.mFavouritesFilterButton)
         {
            this.mFavouritesFilterButton.removeFromParent(true);
            this.mFavouritesFilterButton = null;
         }
         if(this.mAbilityFilterButton)
         {
            this.mAbilityFilterButton.removeFromParent(true);
            this.mAbilityFilterButton = null;
         }
         if(this.mAllCardsFilterButton)
         {
            this.mAllCardsFilterButton.removeFromParent(true);
            this.mAllCardsFilterButton = null;
         }
         if(this.mNewCardsFilterButton)
         {
            this.mNewCardsFilterButton.removeFromParent(true);
            this.mNewCardsFilterButton = null;
         }
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("frames",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("framesXL",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("framesFactionsRarities",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("animIcons",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("powers_thumbs",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("cards_thumbs",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("portraits",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         if(Config.getConfig().cardsHaveCustomAuras())
         {
            InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("anims/animAuras",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         }
         Utils.removeSound(Constants.SOUND_PANEL_DOWN);
         Root.assets.removeSound("firework");
         Root.assets.removeSound("pre_firework");
         super.unload();
      }
      
      public function saveCurrentDeckConfiguration(param1:int, param2:String = "") : void
      {
         var _loc5_:CardDef = null;
         if(param2 != "" && param2 != null)
         {
            _loc5_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(param2));
            this.mDeckCardsPanel.addCardInfoToCatalog(param2,1,_loc5_);
         }
         var _loc3_:Dictionary = this.mDeckCardsPanel.getDeckCardsLoaded();
         var _loc4_:Array = DictionaryUtils.dictionaryToArray(_loc3_);
         InstanceMng.getUserDataMng().getOwnerUserData().setDeck(_loc4_,param1);
         FSTracker.trackMiscAction(FSTracker.CATEGORY_DECK_BUILDER,FSTracker.ACTION_DECK_EDITED);
      }
      
      public function deleteCurrentCardsOnRecyclePanel() : Object
      {
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:CardDef = null;
         var _loc10_:Object = null;
         var _loc12_:Object = null;
         var _loc1_:UserData = Utils.getOwnerUserData();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Dictionary = this.getCurrentCardsPanel().getDeckCardsLoaded();
         var _loc11_:int = 0;
         for(_loc12_ in _loc6_)
         {
            _loc7_ = _loc12_ as String;
            _loc8_ = int(_loc6_[_loc7_]);
            _loc9_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc7_));
            _loc2_ = _loc9_.getGoldOnSell() * _loc8_;
            _loc3_ = _loc9_.getRaidCoinsOnSell() * _loc8_;
            _loc4_ += _loc2_ > 0 ? _loc2_ : 0;
            _loc5_ += _loc3_ > 0 ? _loc3_ : 0;
            _loc1_.removeCardFromCollection(_loc7_,_loc8_);
            _loc11_ += _loc8_;
         }
         if(_loc4_ > 0 || _loc5_ > 0 || _loc11_ > 0)
         {
            if(_loc10_ == null)
            {
               _loc10_ = new Object();
            }
            _loc10_.gold = _loc4_;
            _loc10_.raidCoins = _loc5_;
            _loc10_.cardsDeleted = _loc11_;
         }
         return _loc10_;
      }
      
      public function showRecycleCostOnCollection(param1:Boolean) : void
      {
         var _loc2_:InfoCard = null;
         if(this.mCardInfoCatalog != null)
         {
            for each(_loc2_ in this.mCardInfoCatalog)
            {
               _loc2_.setShowRecycleCost(param1);
            }
         }
      }
      
      override public function onEnterFrame(param1:Event) : void
      {
         super.onEnterFrame(param1);
         InstanceMng.getTutorialDeckBuilderMng().onEnterFrame(param1);
      }
      
      override public function removeTranslucentBG(param1:Boolean = false, param2:Boolean = false) : void
      {
         var _loc3_:TutorialDeckBuilderDef = null;
         if(InstanceMng.getTutorialDeckBuilderMng().isTutorialON())
         {
            _loc3_ = InstanceMng.getTutorialDeckBuilderMng().getCurrentTutorialDef();
            if(Boolean(_loc3_) && !_loc3_.isClickable())
            {
               InstanceMng.getTutorialDeckBuilderMng().increaseCurrentStep();
            }
         }
         else
         {
            if(Boolean(this.mJobPanel) && this.mJobPanel.preventFromClosing())
            {
               return;
            }
            super.removeTranslucentBG(param1,param2);
            if(Boolean(mSelectedCard) && !param2)
            {
               SpecialFX.zoomOut(mSelectedCard);
               mSelectedCard = null;
            }
            if(Boolean(param1) && Boolean(this.mJobPanel) && !this.mJobPanel.preventFromClosing())
            {
               this.mJobPanel.unload();
               this.mJobPanel.removeFromParent();
               this.mJobPanel = null;
               if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
               {
                  FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).lockUI(false);
               }
            }
            if(Boolean(this.mViewAllCraftableCardsButton) && this.mEdidionStatus != STATUS_EDITING)
            {
               this.mViewAllCraftableCardsButton.setEnabled(true);
               this.mViewAllCraftableCardsButton.visible = true;
            }
         }
      }
      
      public function getDeckSelector() : DeckSelector
      {
         return this.mDeckSelector;
      }
      
      public function setDeckSelector(param1:DeckSelector) : void
      {
         this.mDeckSelector = param1;
      }
      
      public function getDeckTitleBox() : FSImage
      {
         return this.mDeckTitleBox;
      }
      
      public function setDeckTitleBox(param1:FSImage) : void
      {
         this.mDeckTitleBox = param1;
      }
      
      public function getEdidionStatus() : int
      {
         return this.mEdidionStatus;
      }
      
      public function setEdidionStatus(param1:int) : void
      {
         this.mEdidionStatus = param1;
         if(this.mAllCardsFilterButton)
         {
            this.mAllCardsFilterButton.setEnabled(this.mEdidionStatus == STATUS_NOT_EDITING);
            this.mAllCardsFilterButton.touchable = this.mEdidionStatus == STATUS_NOT_EDITING;
            this.mAllCardsFilterButton.alpha = this.mEdidionStatus == STATUS_NOT_EDITING ? 1 : 0.55;
         }
         this.updateDeckValueTextfield();
      }
      
      public function getDeckCardsPanel() : DeckCardsPanel
      {
         return this.mDeckCardsPanel;
      }
      
      public function getDeckTitleLabel() : FSTextfield
      {
         return this.mDeckTitleLabel;
      }
      
      public function setDeckTitleLabel(param1:FSTextfield) : void
      {
         this.mDeckTitleLabel = param1;
      }
      
      public function isFactionAllowed(param1:String) : Boolean
      {
         var _loc2_:Boolean = true;
         if(this.mFactionsToShowCatalog != null)
         {
            if(this.mFactionsToShowCatalog[param1] != null)
            {
               return this.mFactionsToShowCatalog[param1];
            }
         }
         return _loc2_;
      }
      
      public function isExitRequested() : Boolean
      {
         return this.mExitRequested;
      }
      
      public function setExitRequested(param1:Boolean) : void
      {
         this.mExitRequested = param1;
      }
      
      public function isRecyclingMode() : Boolean
      {
         return this.mIsRecyclingMode;
      }
      
      public function setIsRecyclingMode(param1:Boolean) : void
      {
         this.mIsRecyclingMode = param1;
         this.showRecycleCostOnCollection(this.mIsRecyclingMode);
      }
      
      public function getRecyclePanel() : RecycleCardsPanel
      {
         return this.mRecyclePanel;
      }
      
      public function getCurrentCardsPanel() : DeckCardsPanel
      {
         return this.mIsRecyclingMode ? this.mRecyclePanel : this.mDeckCardsPanel;
      }
      
      public function isLocked() : Boolean
      {
         return this.mIsLocked;
      }
      
      public function setCraftingON(param1:Boolean) : void
      {
         this.mIsCraftingON = param1;
      }
      
      public function getCraftingON() : Boolean
      {
         return this.mIsCraftingON;
      }
      
      public function setCraftPanelShown(param1:Boolean) : void
      {
         this.mCraftPanelShown = param1;
      }
      
      public function getCraftPanelShown() : Boolean
      {
         return this.mCraftPanelShown;
      }
      
      public function openJobPanel(param1:DeckTitleDeckBuilder) : void
      {
         if(!InstanceMng.getTutorialDeckBuilderMng().isTutorialON())
         {
            createTranslucentBG(true,0.85);
         }
         if(this.mJobPanel == null)
         {
            this.mJobPanel = new JobPanel(param1);
            this.mJobPanel.name = "job_panel";
         }
         this.mJobPanel.setupPanel(param1);
         addChild(this.mJobPanel);
      }
      
      public function setJobPanelPreventFromClosing(param1:Boolean) : void
      {
         if(this.mJobPanel)
         {
            this.mJobPanel.setPreventFromClosing(param1);
         }
      }
      
      public function updateJobSkinAfterBuy() : void
      {
         if(this.mJobPanel)
         {
            this.mJobPanel.updateJobSkinAfterBuy();
         }
      }
      
      public function updateRaidCoinsVisor() : void
      {
         if(this.mRaidCoinsText)
         {
            this.mRaidCoinsText.text = InstanceMng.getUserDataMng().getOwnerUserData().getRaidCoins().toString();
         }
      }
      
      public function updateCurrentJobSelected(param1:JobDef) : void
      {
         this.mCurrentJobDefSelected = param1;
      }
      
      public function getCurrentJobSelected() : JobDef
      {
         return this.mCurrentJobDefSelected;
      }
      
      public function getJobPanel() : JobPanel
      {
         return this.mJobPanel;
      }
      
      public function getCraftInfoPanel() : DeckCraftInfoPanel
      {
         return this.mDeckCraftInfoPanel;
      }
      
      override public function getGoldVisor() : *
      {
         return this.mGoldVisor;
      }
      
      override public function addLights(param1:Boolean = false, param2:Boolean = false) : void
      {
         super.addLights(false,true);
      }
   }
}

