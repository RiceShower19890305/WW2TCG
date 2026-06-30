package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.JobsMng;
   import com.fs.tcgengine.controller.PvPConnectionMng;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.controller.rules.CategoriesDefMng;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.FactionDef;
   import com.fs.tcgengine.model.rules.JobDef;
   import com.fs.tcgengine.model.rules.PowerDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSDeckBuilderScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.DeckBuilderCard;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.CustomComponent;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.greensock.TweenMax;
   import feathers.controls.ScrollContainer;
   import feathers.controls.ScrollPolicy;
   import feathers.layout.VerticalLayout;
   import flash.utils.Dictionary;
   import starling.events.Event;
   import starling.textures.Texture;
   
   public class DeckCardsPanel extends Component
   {
      
      public static const DECK_PANEL_NAME:String = "deck_pannel";
      
      public static const DECK_PANEL_WIDTH:int = 619;
      
      public static const MAX_SLOTS_IN_DECK_PANEL:int = 100;
      
      protected var mScrollableContainer:ScrollContainer;
      
      protected var mBG:CustomComponent;
      
      protected var mForegroundContainer:Component;
      
      private var mDeckIndex:int;
      
      protected var mSaveButton:FSButton;
      
      protected var mCancelButton:FSButton;
      
      protected var mDeckCardsAmount:CardsAmountOnDeck;
      
      protected var mDeckCardsLoaded:Dictionary;
      
      protected var mResetDeckButton:FSButton;
      
      protected var mAutoFillDeckButton:FSButton;
      
      private var mCurrentDeckCardsPowerSku:String;
      
      private var mIconPower:FSImage;
      
      private var mIsMoving:Boolean = false;
      
      private var mDeckValue:int = 0;
      
      private var mSlotsCatalog:Dictionary;
      
      public function DeckCardsPanel(param1:int)
      {
         super();
         this.mDeckIndex = param1;
         this.init();
      }
      
      protected function init() : void
      {
         this.createBGImage();
         this.createForegroundBGImage();
         this.createContainer();
         this.createDeckCardsAmount();
         this.createResetButton();
         this.createSaveButton();
         this.createCancelButton();
         this.createBgPowerIcon();
         if(this.mForegroundContainer)
         {
            this.mForegroundContainer.x = (this.mBG.width - this.mForegroundContainer.width) / 2;
            this.mForegroundContainer.y = this.mBG.y + this.mBG.height * 0.9;
         }
      }
      
      protected function createDeckCardsAmount() : void
      {
         if(this.mDeckCardsAmount == null)
         {
            this.mDeckCardsAmount = new CardsAmountOnDeck(0,true);
            this.mDeckCardsAmount.x = this.mBG.width * 0.33 - this.mDeckCardsAmount.width / 2;
            this.mDeckCardsAmount.y = this.mBG.y + this.mBG.height - this.mDeckCardsAmount.height * 1.5;
            addChild(this.mDeckCardsAmount);
         }
      }
      
      protected function createResetButton() : void
      {
         if(this.mResetDeckButton == null)
         {
            this.mResetDeckButton = new FSButton(Root.assets.getTexture("reset_button"),TextManager.getText("TID_DB_RESET"));
            this.mResetDeckButton.fontName = FSResourceMng.getFontByType();
            this.mResetDeckButton.fontColor = 16777215;
            this.mResetDeckButton.addEventListener(Event.TRIGGERED,this.onResetTriggered);
            this.mResetDeckButton.x = this.mDeckCardsAmount.x + this.mDeckCardsAmount.width * 1.05 + this.mResetDeckButton.width / 2;
            this.mResetDeckButton.y = this.mDeckCardsAmount.y + this.mDeckCardsAmount.height / 2;
            addChild(this.mResetDeckButton);
         }
      }
      
      protected function createAutoFillDeckButton() : void
      {
         var _loc1_:Texture = null;
         var _loc2_:Boolean = false;
         if(this.mAutoFillDeckButton == null)
         {
            _loc1_ = Root.assets.getTexture("suggest_button");
            _loc2_ = _loc1_ != null;
            _loc1_ = _loc2_ ? _loc1_ : Root.assets.getTexture(Constants.ACCEPT_BUTTON_UP_NAME);
            this.mAutoFillDeckButton = new FSButton(_loc1_,TextManager.getText("TID_DECKBUILDER_SUGGEST"));
            if(_loc2_)
            {
               Utils.setupButton9Scale(this.mAutoFillDeckButton,17.5,13.5,6,16,90,35);
            }
            this.mAutoFillDeckButton.name = "suggest_button";
            this.mAutoFillDeckButton.fontName = FSResourceMng.getFontByType();
            this.mAutoFillDeckButton.fontColor = 16777215;
            this.mAutoFillDeckButton.addEventListener(Event.TRIGGERED,this.onAutoFillTriggered);
            this.mAutoFillDeckButton.x = this.mBG.x + this.mBG.width / 2;
            this.mAutoFillDeckButton.y = this.mBG.x + this.mBG.height / 2;
            this.mAutoFillDeckButton.visible = this.mDeckCardsAmount.getAmount() == 0;
            addChild(this.mAutoFillDeckButton);
         }
         else
         {
            this.mAutoFillDeckButton.visible = this.mDeckCardsAmount.getAmount() == 0;
            this.mAutoFillDeckButton.touchable = this.mDeckCardsAmount.getAmount() == 0;
         }
      }
      
      private function onAutoFillTriggered(param1:Event) : void
      {
         var _loc2_:Vector.<String> = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc6_:FSCard = null;
         var _loc7_:DeckJobConfigurator = null;
         var _loc8_:JobDef = null;
         var _loc9_:String = null;
         this.mAutoFillDeckButton.visible = false;
         this.mAutoFillDeckButton.touchable = false;
         Utils.playSound("card_to_bf",SoundManager.TYPE_SFX);
         if(Config.getConfig().gameHasClassSystem())
         {
            _loc7_ = InstanceMng.getUserDataMng().getOwnerUserData().getDeckJobConfiguratorByDeck(InstanceMng.getUserDataMng().getOwnerUserData().getSelectedDeckIndex());
            if(_loc7_)
            {
               _loc8_ = JobDef(InstanceMng.getJobsDefMng().getDefBySku(_loc7_.getJobSku()));
               _loc2_ = DictionaryUtils.arrayToStringVector(InstanceMng.getUserDataMng().getOwnerUserData().createBestBasicDeckConfiguration(_loc8_));
            }
         }
         else
         {
            _loc2_ = InstanceMng.getUserDataMng().getOwnerUserData().createBestDeckConfiguration();
         }
         var _loc5_:UserData = Utils.getOwnerUserData();
         _loc4_ = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc6_ = InstanceMng.getCardsMng().createCard(_loc2_[_loc4_]);
            if(_loc6_.getType() != FSCard.TYPE_POWER)
            {
               this.addCardSlotInfo(_loc2_[_loc4_],1,0,_loc4_);
            }
            else
            {
               this.setCurrentPowerSkuToDeckCardsPanel(_loc2_[_loc4_]);
            }
            if(_loc5_)
            {
               _loc5_.removeCardFromNewCardsCollection(_loc2_[_loc4_],1,true);
            }
            _loc4_++;
         }
         if(Config.getConfig().gameHasPowers())
         {
            if(!Config.getConfig().gameHasClassSystem())
            {
               _loc9_ = this.getBestPowerForDeck(_loc8_);
               this.setCurrentPowerSkuToDeckCardsPanel(_loc9_);
            }
            this.createBgPowerIcon();
         }
         this.onRemoveFromCollectionUpdateInfo();
      }
      
      public function getSlotsAmount() : int
      {
         return DictionaryUtils.getDictionaryLength(this.mSlotsCatalog);
      }
      
      private function getBestPowerForDeck(param1:JobDef = null) : String
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         var _loc6_:Array = null;
         var _loc7_:CardDef = null;
         var _loc8_:int = 0;
         var _loc2_:String = "";
         if(Config.getConfig().gameHasClassSystem())
         {
            _loc4_ = JobsMng.getAllCardsForJob(param1);
            _loc5_ = null;
            _loc8_ = 0;
            _loc8_ = 0;
            while(_loc8_ < _loc4_.length)
            {
               _loc5_ = _loc4_[_loc8_];
               _loc6_ = _loc5_.split(":");
               _loc7_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc6_[0]));
               if(_loc7_ is PowerDef)
               {
                  if(_loc3_ == null)
                  {
                     _loc3_ = new Array();
                  }
                  _loc3_.push(_loc7_.getSku());
               }
               _loc8_++;
            }
            if(Boolean(_loc3_) && _loc3_.length > 0)
            {
               _loc3_.sort(DictionaryUtils.sortCardsSkusByValue);
               _loc2_ = _loc3_[0];
            }
            _loc2_ = _loc2_ != "" ? _loc2_ : InstanceMng.getUserDataMng().getOwnerUserData().getBestPowerDefOnCollection().getSku();
         }
         else
         {
            _loc2_ = InstanceMng.getUserDataMng().getOwnerUserData().getBestPowerDefOnCollection().getSku();
         }
         return _loc2_;
      }
      
      public function onDeckModified(param1:Boolean) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Screen = InstanceMng.getCurrentScreen();
         if(_loc2_ is FSDeckBuilderScreen && FSDeckBuilderScreen(_loc2_).getDeckCardsPanel() != null && Boolean(FSDeckBuilderScreen(_loc2_).getDeckCardsPanel().getDeckCardsAmount()))
         {
            _loc3_ = FSDeckBuilderScreen(_loc2_).getDeckCardsPanel().getDeckCardsAmount().getAmount();
            if(this.mAutoFillDeckButton)
            {
               if(param1 && _loc3_ == 0)
               {
                  this.mAutoFillDeckButton.enabled = false;
                  this.mAutoFillDeckButton.touchable = false;
                  SpecialFX.tweenToAlpha(this.mAutoFillDeckButton,0.001,0.5,0);
               }
               else if(!param1 && _loc3_ == 0)
               {
                  this.mAutoFillDeckButton.alpha = 0.001;
                  this.mAutoFillDeckButton.visible = true;
                  this.mAutoFillDeckButton.enabled = true;
                  this.mAutoFillDeckButton.touchable = true;
                  SpecialFX.tweenToAlpha(this.mAutoFillDeckButton,0.999,0.5,0);
               }
            }
         }
      }
      
      protected function onRemoveFromCollectionUpdateInfo() : void
      {
         var _loc1_:FSDeckBuilderScreen = null;
         if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen && !InstanceMng.getTutorialDeckBuilderMng().isTutorialON())
         {
            _loc1_ = FSDeckBuilderScreen(InstanceMng.getCurrentScreen());
            _loc1_.updateCollectionFilteredWithDeck();
            _loc1_.refreshTabsAmount();
            _loc1_.refreshUI();
            _loc1_.fillCollections(true);
         }
         else
         {
            InstanceMng.getTutorialDeckBuilderMng().increaseCurrentStep();
         }
      }
      
      private function onResetTriggered(param1:Event) : void
      {
         if(this.mDeckCardsAmount.getAmount() > 0)
         {
            InstanceMng.getPopupMng().openConfirmResetDeckPopup();
         }
      }
      
      public function resetDeck() : void
      {
         var _loc1_:Component = null;
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.mScrollableContainer.numChildren)
         {
            _loc1_ = Component(this.mScrollableContainer.getChildAt(_loc2_));
            if(_loc1_ != null)
            {
               if(_loc1_ is FSCardSlotInfo)
               {
                  FSCardSlotInfo(_loc1_).checkIfRemovedFromDeck(true);
               }
            }
            _loc2_++;
         }
         var _loc3_:DeckBuilderCard = InstanceMng.getCurrentScreen() is FSDeckBuilderScreen ? FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).getCardInfoByCardSku(this.mCurrentDeckCardsPowerSku) : null;
         if(_loc3_)
         {
            _loc3_.hidePowerSelectedText();
         }
         this.cleanPower();
         if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).refreshUI();
         }
         if(this.mAutoFillDeckButton)
         {
            this.mAutoFillDeckButton.alpha = 0.001;
            this.mAutoFillDeckButton.visible = true;
            this.mAutoFillDeckButton.enabled = true;
            this.mAutoFillDeckButton.touchable = true;
            SpecialFX.tweenToAlpha(this.mAutoFillDeckButton,0.999,0.5,0);
         }
         this.removeDeckCardsLoaded();
      }
      
      private function resetPower() : void
      {
         this.cleanPower();
         this.mCurrentDeckCardsPowerSku = DictionaryUtils.getKeys(DictionaryUtils.getAllPowersCatalog())[0];
         this.createBgPowerIcon();
      }
      
      public function resetPanel() : void
      {
         if(this.mDeckCardsAmount != null)
         {
            this.mDeckCardsAmount.setAmount(0);
         }
         this.mDeckValue = 0;
         if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).setEditButtonVisible(false);
         }
      }
      
      protected function createSaveButton() : void
      {
         if(this.mSaveButton == null)
         {
            this.mSaveButton = new FSButton(Root.assets.getTexture("db_save_button"));
            this.mSaveButton.fontName = FSResourceMng.getFontByType();
            this.mSaveButton.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
            this.mSaveButton.name = Constants.SAVE_BUTTON_NAME;
            this.mSaveButton.x = this.mSaveButton.width / 2;
            this.mSaveButton.y = this.mSaveButton.height / 2;
            this.mSaveButton.addEventListener(Event.TRIGGERED,this.onButtonTriggered);
         }
         this.mForegroundContainer.addChild(this.mSaveButton);
      }
      
      private function createCancelButton() : void
      {
         if(this.mCancelButton == null)
         {
            this.mCancelButton = new FSButton(Root.assets.getTexture(Constants.BACK_BUTTON_DECK_BUILDER_NAME));
            this.mCancelButton.fontName = FSResourceMng.getFontByType();
            this.mCancelButton.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
            this.mCancelButton.name = Constants.BACK_BUTTON_DECK_BUILDER_NAME;
            this.mCancelButton.x = this.mSaveButton.x + this.mSaveButton.width;
            this.mCancelButton.y = this.mSaveButton.y;
            this.mCancelButton.addEventListener(Event.TRIGGERED,this.onButtonTriggered);
         }
         this.mForegroundContainer.addChild(this.mCancelButton);
      }
      
      protected function onButtonTriggered(param1:Event) : void
      {
         var _loc2_:String = FSButton(param1.currentTarget).name;
         switch(_loc2_)
         {
            case Constants.SAVE_BUTTON_NAME:
               this.onAcceptButtonTriggered();
               if(this.mSaveButton)
               {
                  this.mSaveButton.disableTemporarily();
               }
               if(this.mCancelButton)
               {
                  this.mCancelButton.disableTemporarily();
               }
               break;
            case Constants.BACK_BUTTON_DECK_BUILDER_NAME:
               this.onCancelButtonTriggered();
               if(this.mSaveButton)
               {
                  this.mSaveButton.disableTemporarily();
               }
               if(this.mCancelButton)
               {
                  this.mCancelButton.disableTemporarily();
               }
         }
      }
      
      protected function onAcceptButtonTriggered() : void
      {
         var _loc1_:DeckJobConfigurator = null;
         var _loc2_:JobDef = null;
         var _loc3_:FSDeckBuilderScreen = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:DeckTitleDeckBuilder = null;
         if(!PvPConnectionMng.smUserInPvPQueue)
         {
            if(this.isDeckNameCorrect())
            {
               if(Config.getConfig().gameHasPowers() && (this.mCurrentDeckCardsPowerSku == null || this.mCurrentDeckCardsPowerSku == ""))
               {
                  this.mCurrentDeckCardsPowerSku = InstanceMng.getUserDataMng().getOwnerUserData().getDefaultPowerSku(this.mDeckIndex);
                  if(Config.getConfig().gameHasClassSystem())
                  {
                     _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData().getDeckJobConfiguratorByDeck(this.mDeckIndex);
                     if(_loc1_)
                     {
                        _loc2_ = JobDef(InstanceMng.getJobsDefMng().getDefBySku(_loc1_.getJobSku()));
                        this.mCurrentDeckCardsPowerSku = _loc2_.getActiveDefaultSku();
                     }
                  }
               }
               if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
               {
                  _loc3_ = FSDeckBuilderScreen(InstanceMng.getCurrentScreen());
                  _loc3_.saveCurrentDeckConfiguration(this.mDeckIndex,this.mCurrentDeckCardsPowerSku);
                  _loc4_ = "deck_" + Utils.transformValueToString(this.mDeckIndex.toString(),2);
                  _loc5_ = _loc3_.getDeckTitleLabel().text;
                  InstanceMng.getUserDataMng().getOwnerUserData().setDeckNameToCatalog(_loc4_,_loc5_);
                  if(InstanceMng.getTutorialDeckBuilderMng().isTutorialON())
                  {
                     InstanceMng.getUserDataMng().getOwnerUserData().setSelectedDeckIndex(0);
                  }
                  InstanceMng.getUserDataMng().persistenceSaveData();
                  if(Utils.isBrowser() || Utils.isDesktop())
                  {
                     Utils.setLogText(TextManager.getText("TID_DECK_SAVED_BROWSER"),false,false,false);
                  }
                  else
                  {
                     Utils.setLogText(TextManager.getText("TID_DECK_SAVED"),false,false,false);
                  }
                  _loc6_ = DeckTitleDeckBuilder(_loc3_.getDeckSelector().getDeckTitleByIndex(this.mDeckIndex));
                  if(_loc6_ != null)
                  {
                     _loc6_.updateTitleTextfield();
                  }
                  this.showForegroundAnim(false);
               }
            }
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_PVP_FEATURE_BLOCKED"),true);
         }
      }
      
      protected function onCancelButtonTriggered() : void
      {
         InstanceMng.getPopupMng().openUnsavedDataPopup();
      }
      
      private function isDeckNameCorrect() : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:Dictionary = null;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc8_:Boolean = false;
         var _loc1_:Boolean = true;
         if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            _loc3_ = "deck_" + Utils.transformValueToString(this.mDeckIndex.toString(),2);
            _loc4_ = FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).getDeckTitleLabel().text;
            _loc5_ = InstanceMng.getUserDataMng().getOwnerUserData().getDeckNames();
            if(_loc5_ != null)
            {
               _loc6_ = DictionaryUtils.getKeys(_loc5_);
               _loc2_ = 0;
               while(_loc2_ < _loc6_.length)
               {
                  if(_loc6_[_loc2_] != _loc3_)
                  {
                     if(String(_loc5_[_loc6_[_loc2_]]).toLowerCase() == _loc4_.toLowerCase())
                     {
                        Utils.setLogText(TextManager.getText("TID_DECKBUILDER_NAME_DUPLICATED"),true);
                        return false;
                     }
                  }
                  _loc2_++;
               }
            }
            if(_loc4_.length < 3)
            {
               Utils.setLogText(TextManager.getText("TID_DECKBUILDER_DECK_NAME_MIN"),true);
               return false;
            }
            _loc8_ = true;
            _loc2_ = 0;
            while(_loc2_ < _loc4_.length)
            {
               _loc7_ = _loc4_.substr(_loc2_,1);
               if(_loc7_.toLowerCase() != " ")
               {
                  _loc8_ = false;
               }
               _loc2_++;
            }
            if(_loc8_)
            {
               Utils.setLogText(TextManager.getText("TID_DECKBUILDER_DECK_NAME_INVALID"),true);
               return false;
            }
         }
         return _loc1_;
      }
      
      public function onExitPanelCommonOps() : void
      {
         if(this.mScrollableContainer != null)
         {
            this.cleanScrollContainer();
            this.cleanPower();
         }
         DictionaryUtils.clearDictionary(this.mSlotsCatalog);
         this.mSlotsCatalog = null;
         var _loc1_:FSCoordinate = new FSCoordinate(x,-(FSDeckBuilderScreen.DECK_SELECTOR_Y + height));
         SpecialFX.createTransition(this,_loc1_,0.5,0,this.onPanelHidden);
         Utils.playSound(Constants.SOUND_PANEL_DOWN,SoundManager.TYPE_SFX);
      }
      
      public function cleanPower() : void
      {
         this.mCurrentDeckCardsPowerSku = null;
         if(this.mIconPower != null)
         {
            this.mIconPower.removeFromParent();
            this.mIconPower.destroy();
            this.mIconPower = null;
         }
      }
      
      private function cleanScrollContainer() : void
      {
         var _loc1_:Component = null;
         if(this.mScrollableContainer)
         {
            while(this.mScrollableContainer.numChildren > 0)
            {
               _loc1_ = Component(this.mScrollableContainer.getChildAt(0));
               if(_loc1_ != null)
               {
                  if(_loc1_ is FSCardSlotInfo)
                  {
                     FSCardSlotInfo(_loc1_).unload();
                  }
               }
            }
            this.mScrollableContainer.removeChildren(0,-1,true);
         }
      }
      
      private function onPanelHidden() : void
      {
         var _loc1_:FSDeckBuilderScreen = null;
         var _loc2_:DeckSelector = null;
         var _loc3_:FSCoordinate = null;
         if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            _loc1_ = FSDeckBuilderScreen(InstanceMng.getCurrentScreen());
            if(_loc1_ != null)
            {
               this.mIsMoving = false;
               if(this.mScrollableContainer)
               {
                  this.mScrollableContainer.touchable = true;
               }
               _loc2_ = _loc1_.getDeckSelector();
               if(_loc2_ != null)
               {
                  _loc3_ = new FSCoordinate(_loc2_.x,FSDeckBuilderScreen.DECK_SELECTOR_Y);
                  SpecialFX.createTransition(_loc2_,_loc3_,0.5,0,this.setDeckBuilderFinishedEditing);
               }
               _loc1_.showDeckTitle(true);
               _loc1_.updateDeckTitleLabel();
               this.resetPanel();
               if(InstanceMng.getCurrentScreen())
               {
                  InstanceMng.getCurrentScreen().reAddUIVisualsOptions();
               }
               TweenMax.delayedCall(0.75,this.checkTutorialFunctionsOnHold);
            }
         }
      }
      
      private function setDeckBuilderFinishedEditing() : void
      {
         var _loc1_:FSDeckBuilderScreen = null;
         if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            _loc1_ = FSDeckBuilderScreen(InstanceMng.getCurrentScreen());
            if(_loc1_ != null)
            {
               _loc1_.onFinishEditing();
            }
         }
      }
      
      private function createContainer() : void
      {
         if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            if(this.mScrollableContainer == null)
            {
               this.mScrollableContainer = new ScrollContainer();
               this.mScrollableContainer.layout = this.getContainerLayout();
               this.mScrollableContainer.height = this.mBG.height * 0.84;
               this.mScrollableContainer.y = Utils.isAndroidOrDesktop() || Utils.isBrowser() ? this.mBG.x + this.mBG.height * 0.11 : this.mBG.x + this.mBG.height * 0.13;
               addChild(this.mScrollableContainer);
            }
         }
      }
      
      private function resetContainerPos() : void
      {
         var _loc1_:FSCardSlotInfo = null;
         if(this.mScrollableContainer != null)
         {
            _loc1_ = this.mScrollableContainer.numChildren > 0 ? FSCardSlotInfo(this.mScrollableContainer.getChildAt(0)) : null;
            if(_loc1_ != null)
            {
               this.mScrollableContainer.width = _loc1_.width;
               this.mScrollableContainer.validate();
               this.mScrollableContainer.x = -((this.mScrollableContainer.width - this.mBG.width) / 2);
            }
         }
      }
      
      private function getContainerLayout() : VerticalLayout
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.gap = 3;
         this.mScrollableContainer.layout = _loc1_;
         this.mScrollableContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
         return _loc1_;
      }
      
      private function createBGImage() : void
      {
         var _loc1_:FSDeckBuilderScreen = null;
         if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            if(this.mBG == null)
            {
               this.mBG = Utils.createCustomBox(DECK_PANEL_NAME,DECK_PANEL_WIDTH);
               this.mBG.name = DECK_PANEL_NAME;
               _loc1_ = FSDeckBuilderScreen(InstanceMng.getCurrentScreen());
               if(_loc1_ != null)
               {
                  this.mBG.x = 0;
                  this.mBG.y = _loc1_.getDeckTitleBox().y - 10;
               }
               addChild(this.mBG);
            }
         }
      }
      
      private function createForegroundBGImage() : void
      {
         var _loc1_:int = 0;
         if(this.mForegroundContainer == null)
         {
            this.mForegroundContainer = new Component();
            this.mForegroundContainer.name = "foreground_container";
            _loc1_ = getChildIndex(this.mBG);
            addChildAt(this.mForegroundContainer,_loc1_);
         }
      }
      
      public function showForegroundAnim(param1:Boolean) : void
      {
         var _loc2_:FSDeckBuilderScreen = null;
         var _loc3_:FSCoordinate = null;
         var _loc4_:Function = null;
         if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            _loc2_ = FSDeckBuilderScreen(InstanceMng.getCurrentScreen());
            if(_loc2_ != null)
            {
               if(this.mScrollableContainer)
               {
                  this.mScrollableContainer.touchable = false;
               }
               this.mIsMoving = true;
               _loc2_.lockUI(true);
               _loc3_ = new FSCoordinate();
               if(param1)
               {
                  _loc3_.setX((this.mBG.width - this.mForegroundContainer.width) / 2);
                  _loc3_.setY(this.mBG.y + this.mBG.height - this.mForegroundContainer.height * 0.15);
               }
               else
               {
                  _loc3_.setX((this.mBG.width - this.mForegroundContainer.width) / 2);
                  _loc3_.setY(this.mBG.y + this.mBG.height - this.mForegroundContainer.height);
               }
               _loc4_ = null;
               if(!param1)
               {
                  _loc4_ = this.onExitPanelCommonOps;
               }
               else
               {
                  TweenMax.delayedCall(0.75,this.deckBuilderLockUI,[false]);
                  TweenMax.delayedCall(0.75,this.checkTutorialFunctionsOnHold);
                  _loc4_ = this.resetIsMoving;
               }
               _loc2_.showDeckTitle(param1);
               SpecialFX.createTransition(this.mForegroundContainer,_loc3_,0.75,0,_loc4_);
            }
         }
      }
      
      private function deckBuilderLockUI(param1:Boolean) : void
      {
         var _loc2_:FSDeckBuilderScreen = InstanceMng.getCurrentScreen() is FSDeckBuilderScreen ? FSDeckBuilderScreen(InstanceMng.getCurrentScreen()) : null;
         if(_loc2_)
         {
            _loc2_.lockUI(param1);
         }
      }
      
      private function checkTutorialFunctionsOnHold() : void
      {
         if(Boolean(InstanceMng.getTutorialDeckBuilderMng()) && InstanceMng.getTutorialDeckBuilderMng().isTutorialON())
         {
            InstanceMng.getTutorialDeckBuilderMng().checkTutorialFunctionsOnHold();
         }
      }
      
      public function setup(param1:int, param2:Boolean = true, param3:Boolean = false) : void
      {
         var _loc5_:FSDeckBuilderScreen = null;
         var _loc6_:Number = NaN;
         this.mDeckValue = 0;
         this.mDeckIndex = param1;
         DictionaryUtils.clearDictionary(this.mDeckCardsLoaded);
         DictionaryUtils.clearDictionary(this.mSlotsCatalog);
         var _loc4_:Number = 0.1;
         TweenMax.killAll();
         InstanceMng.getCurrentScreen().resetGuildsButtonPosition();
         Utils.removeLog();
         if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            _loc5_ = FSDeckBuilderScreen(InstanceMng.getCurrentScreen());
            if(param2)
            {
               this.sortPanelByCategory();
            }
            else if(param3)
            {
               this.sortPanelByFaction();
            }
            if(!InstanceMng.getTutorialDeckBuilderMng().isTutorialON())
            {
               _loc5_.fillCollections(true);
               _loc6_ = _loc4_ > 0 ? Math.min(1,_loc4_) : 0;
            }
            TweenMax.delayedCall(_loc6_,this.showForegroundAnim,[true]);
            this.createAutoFillDeckButton();
            if(InstanceMng.getCurrentScreen())
            {
               InstanceMng.getCurrentScreen().reAddUIVisualsOptions();
            }
         }
      }
      
      public function sortPanelByCategory() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:Dictionary = null;
         var _loc3_:UserData = Utils.getOwnerUserData();
         var _loc4_:Number = 0.1;
         var _loc9_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < CategoriesDefMng.smCategoriesVec.length)
         {
            _loc8_ = _loc3_.getDeckFilteredByCategory(this.mDeckIndex,CategoriesDefMng.smCategoriesVec[_loc1_]);
            if(_loc8_ != null)
            {
               _loc5_ = DictionaryUtils.getKeys(_loc8_);
               _loc5_.sort(DictionaryUtils.sortCardsByValueAndSubcategory);
               _loc2_ = 0;
               while(_loc2_ < _loc5_.length)
               {
                  _loc6_ = _loc5_[_loc2_];
                  _loc7_ = int(_loc8_[_loc6_]);
                  this.addCardSlotInfo(_loc6_,_loc7_,_loc4_,_loc9_);
                  _loc4_ += 0.1;
                  _loc9_++;
                  _loc2_++;
               }
               this.resetContainerPos();
            }
            _loc1_++;
         }
         this.highlightCurrentPowerAfterSort();
      }
      
      private function highlightCurrentPowerAfterSort() : void
      {
         var _loc1_:UserData = null;
         var _loc2_:DeckBuilderCard = null;
         if(Config.getConfig().gameHasPowers())
         {
            _loc1_ = Utils.getOwnerUserData();
            this.mCurrentDeckCardsPowerSku = this.getPowerSkuFromDeck(_loc1_.getDeck(this.mDeckIndex));
            this.createBgPowerIcon();
            if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
            {
               _loc2_ = (InstanceMng.getCurrentScreen() as FSDeckBuilderScreen).getCardInfoByCardSku(this.mCurrentDeckCardsPowerSku);
               if(_loc2_ != null)
               {
                  _loc2_.showPowerSelectedText();
               }
            }
         }
      }
      
      private function getPowerSkuFromDeck(param1:Dictionary) : String
      {
         var _loc2_:String = null;
         var _loc5_:int = 0;
         var _loc3_:Dictionary = DictionaryUtils.getAllPowersCatalog();
         var _loc4_:Array = DictionaryUtils.getKeys(_loc3_);
         _loc5_ = 0;
         while(_loc5_ < _loc4_.length)
         {
            if(DictionaryUtils.containsKey(param1,_loc4_[_loc5_]))
            {
               _loc2_ = _loc4_[_loc5_];
               break;
            }
            _loc5_++;
         }
         return _loc2_;
      }
      
      public function sortPanelByFaction() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:Dictionary = null;
         var _loc10_:Array = null;
         var _loc12_:FactionDef = null;
         var _loc3_:UserData = Utils.getOwnerUserData();
         var _loc4_:Number = 0.1;
         var _loc9_:Dictionary = InstanceMng.getFactionsDefMng().getAllDefs();
         var _loc11_:int = 0;
         _loc5_ = DictionaryUtils.sortDictionaryByKey(_loc9_);
         _loc1_ = 0;
         while(_loc1_ < _loc5_.length)
         {
            _loc12_ = _loc9_[_loc5_[_loc1_].key];
            _loc8_ = _loc3_.getDeckFilteredByFaction(this.mDeckIndex,_loc12_.getSku());
            if(_loc8_ != null)
            {
               _loc10_ = DictionaryUtils.getKeys(_loc8_);
               _loc10_.sort(DictionaryUtils.nonDeepSortCardsSkusByValue);
               _loc2_ = 0;
               while(_loc2_ < _loc10_.length)
               {
                  _loc6_ = _loc10_[_loc2_];
                  _loc7_ = int(_loc8_[_loc6_]);
                  if(_loc6_.indexOf("power_") == -1)
                  {
                     this.addCardSlotInfo(_loc6_,_loc7_,_loc4_,_loc11_);
                     _loc4_ += 0.1;
                     _loc11_++;
                  }
                  _loc2_++;
               }
               this.resetContainerPos();
            }
            _loc1_++;
         }
         this.highlightCurrentPowerAfterSort();
      }
      
      public function addCardSlotInfo(param1:String, param2:int, param3:Number, param4:int = 0) : void
      {
         var _loc6_:CardDef = null;
         var _loc7_:Boolean = false;
         var _loc5_:FSCardSlotInfo = this.getSlotByCardSku(param1);
         if(_loc5_ == null)
         {
            _loc6_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(param1));
            _loc7_ = _loc6_ is PowerDef;
            if(!_loc7_ || _loc7_ && (InstanceMng.getCurrentScreen() as FSDeckBuilderScreen).isRecyclingMode())
            {
               this.addCardInfoToCatalog(param1,param2,_loc6_);
               _loc5_ = InstanceMng.getResourcesMng().createCardSlotInfoItem(param1,param2,this,this.mScrollableContainer);
               if(!Utils.isLowPerformanceDevice() && param4 < 10)
               {
                  _loc5_.alpha = 0.001;
                  _loc5_.touchable = false;
               }
               if(this.mScrollableContainer != null)
               {
                  this.mScrollableContainer.addChild(_loc5_);
               }
               if(this.mSlotsCatalog == null)
               {
                  this.mSlotsCatalog = new Dictionary(true);
               }
               this.mSlotsCatalog[param1] = _loc5_;
            }
            if(!Utils.isLowPerformanceDevice() && param4 < 10)
            {
               TweenMax.delayedCall(param3,SpecialFX.tweenToAlpha,[_loc5_,0.999,param3,0,this.setCardSlotTouchable,[_loc5_]]);
            }
         }
         else
         {
            this.mDeckCardsLoaded[param1] += param2;
            _loc5_.addCardAmount(param2);
            _loc5_.updateAmountTextfield();
         }
         this.updateDeckCardsAmount(param1,param2);
         if(this.mScrollableContainer.x == 0)
         {
            this.resetContainerPos();
         }
      }
      
      private function setCardSlotTouchable(param1:FSCardSlotInfo) : void
      {
         if(param1)
         {
            param1.setTouchable();
         }
      }
      
      protected function updateDeckCardsAmount(param1:String, param2:int) : void
      {
         var _loc3_:CardDef = CardDef(InstanceMng.getCardsDefMng().getDefBySku(param1));
         if(_loc3_ != null && _loc3_.getType() != FSCard.TYPE_POWER)
         {
            this.mDeckCardsAmount.addAmount(param2);
         }
      }
      
      public function addCardInfoToCatalog(param1:String, param2:int, param3:CardDef) : void
      {
         if(this.mDeckCardsLoaded == null)
         {
            this.mDeckCardsLoaded = new Dictionary(true);
         }
         if(this.mDeckCardsLoaded[param1] == null)
         {
            this.mDeckCardsLoaded[param1] = param2;
         }
         else
         {
            this.mDeckCardsLoaded[param1] += param2;
         }
         if(param3)
         {
            this.setDeckValue(this.mDeckValue + param3.getCardValue() * param2);
         }
      }
      
      public function removeCardInfoFromCatalog(param1:String, param2:int) : void
      {
         var _loc4_:int = 0;
         if(this.mDeckCardsLoaded != null)
         {
            if(this.mDeckCardsLoaded[param1] != null)
            {
               _loc4_ = int(this.mDeckCardsLoaded[param1]);
               if(_loc4_ > 1)
               {
                  this.mDeckCardsLoaded[param1] -= param2;
               }
               else
               {
                  delete this.mDeckCardsLoaded[param1];
                  if(this.mSlotsCatalog != null)
                  {
                     if(this.mSlotsCatalog[param1] != null)
                     {
                        delete this.mSlotsCatalog[param1];
                     }
                  }
               }
            }
         }
         this.updateDeckCardsAmount(param1,-param2);
         var _loc3_:CardDef = CardDef(InstanceMng.getCardsDefMng().getDefBySku(param1));
         if(_loc3_)
         {
            this.setDeckValue(this.mDeckValue - _loc3_.getCardValue() * param2);
         }
      }
      
      public function getSlotByCardSku(param1:String) : FSCardSlotInfo
      {
         return this.mSlotsCatalog != null && param1 in this.mSlotsCatalog ? this.mSlotsCatalog[param1] : null;
      }
      
      public function getScrollableContainer() : ScrollContainer
      {
         return this.mScrollableContainer;
      }
      
      public function getDeckIndex() : int
      {
         return this.mDeckIndex;
      }
      
      public function getDeckCardsAmount() : CardsAmountOnDeck
      {
         return this.mDeckCardsAmount;
      }
      
      public function setDeckCardsAmount(param1:CardsAmountOnDeck) : void
      {
         this.mDeckCardsAmount = param1;
      }
      
      public function getDeckCardsLoaded() : Dictionary
      {
         return this.mDeckCardsLoaded;
      }
      
      public function setDeckCardsLoaded(param1:Dictionary) : void
      {
         this.mDeckCardsLoaded = param1;
      }
      
      public function removeDeckCardsLoaded() : void
      {
         if(this.mDeckCardsLoaded != null)
         {
            DictionaryUtils.clearDictionary(this.mDeckCardsLoaded);
         }
         DictionaryUtils.clearDictionary(this.mSlotsCatalog);
      }
      
      public function getDeckAmountByCardSku(param1:String) : int
      {
         var _loc2_:int = 0;
         if(this.mDeckCardsLoaded != null)
         {
            if(this.mDeckCardsLoaded[param1] != null)
            {
               return this.mDeckCardsLoaded[param1];
            }
         }
         return _loc2_;
      }
      
      override public function dispose() : void
      {
         if(this.mScrollableContainer)
         {
            this.mScrollableContainer.removeFromParent(true);
            this.mScrollableContainer = null;
         }
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         if(this.mForegroundContainer)
         {
            this.mForegroundContainer.removeFromParent(true);
            this.mForegroundContainer = null;
         }
         if(this.mSaveButton)
         {
            this.mSaveButton.removeFromParent(true);
            this.mSaveButton = null;
         }
         if(this.mCancelButton)
         {
            this.mCancelButton.removeFromParent(true);
            this.mCancelButton = null;
         }
         if(this.mDeckCardsAmount)
         {
            this.mDeckCardsAmount.removeFromParent(true);
            this.mDeckCardsAmount = null;
         }
         if(this.mResetDeckButton)
         {
            this.mResetDeckButton.removeFromParent(true);
            this.mResetDeckButton = null;
         }
         if(this.mAutoFillDeckButton)
         {
            this.mAutoFillDeckButton.removeFromParent(true);
            this.mAutoFillDeckButton = null;
         }
         if(this.mIconPower)
         {
            this.mIconPower.removeFromParent(true);
            this.mIconPower = null;
         }
         DictionaryUtils.clearDictionary(this.mDeckCardsLoaded);
         this.mDeckCardsLoaded = null;
         DictionaryUtils.clearDictionary(this.mSlotsCatalog);
         this.mSlotsCatalog = null;
         super.dispose();
      }
      
      public function setCurrentPowerSkuToDeckCardsPanel(param1:String) : void
      {
         this.mCurrentDeckCardsPowerSku = param1;
      }
      
      public function getcurrentDeckPowerSku() : String
      {
         return this.mCurrentDeckCardsPowerSku;
      }
      
      public function createBgPowerIcon() : void
      {
         var _loc1_:UserData = null;
         var _loc2_:int = 0;
         var _loc3_:DeckJobConfigurator = null;
         var _loc4_:String = null;
         var _loc5_:JobDef = null;
         var _loc6_:Boolean = false;
         var _loc7_:String = null;
         var _loc8_:FSDeckBuilderScreen = null;
         if(Config.getConfig().gameHasPowers() && Config.getConfig().gameHasClassSystem() && this.mCurrentDeckCardsPowerSku == null)
         {
            _loc1_ = Utils.getOwnerUserData();
            if(_loc1_)
            {
               _loc2_ = _loc1_.getSelectedDeckIndex();
               _loc3_ = _loc1_.getDeckJobConfiguratorByDeck(_loc2_);
               if(_loc3_)
               {
                  _loc4_ = _loc3_.getJobSku();
                  _loc5_ = JobDef(InstanceMng.getJobsDefMng().getDefBySku(_loc4_));
                  if(_loc5_)
                  {
                     this.setCurrentPowerSkuToDeckCardsPanel(_loc5_.getActiveDefaultSku());
                  }
               }
            }
         }
         if(this.mCurrentDeckCardsPowerSku != null && Config.getConfig().gameHasPowers())
         {
            _loc6_ = InstanceMng.getCurrentScreen() is FSDeckBuilderScreen ? FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).getEdidionStatus() == FSDeckBuilderScreen.STATUS_EDITING : false;
            if(_loc6_)
            {
               _loc7_ = (InstanceMng.getCardsDefMng().getDefBySku(this.mCurrentDeckCardsPowerSku) as PowerDef).getBgIcon();
               _loc8_ = InstanceMng.getCurrentScreen() as FSDeckBuilderScreen;
               if(this.mIconPower == null)
               {
                  this.mIconPower = new FSImage(Root.assets.getTexture(_loc7_));
                  this.mIconPower.x = _loc8_.getDeckSelector().x;
                  this.mIconPower.y = Utils.isAndroidOrDesktop() ? this.mIconPower.y + this.mIconPower.height * 0.9 : this.mIconPower.y + this.mIconPower.height;
               }
               else
               {
                  this.mIconPower.texture = Root.assets.getTexture(_loc7_);
               }
               _loc8_.addChild(this.mIconPower);
            }
         }
      }
      
      public function isMoving() : Boolean
      {
         return this.mIsMoving;
      }
      
      public function resetIsMoving() : void
      {
         this.mIsMoving = false;
         if(this.mScrollableContainer)
         {
            this.mScrollableContainer.touchable = true;
         }
      }
      
      private function setDeckValue(param1:int) : void
      {
         this.mDeckValue = param1;
         if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).updateDeckValueTextfield();
         }
      }
      
      public function getDeckValue() : int
      {
         return this.mDeckValue;
      }
   }
}

