package com.fs.tcgengine.view.deckbuilder
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.PvPConnectionMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.controller.rules.CategoriesDefMng;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSDeckBuilderScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.misc.DeckCardsPanel;
   import com.fs.tcgengine.view.misc.FSImage;
   import starling.events.Event;
   
   public class RecycleCardsPanel extends DeckCardsPanel
   {
      
      private const WATERMARK_BG_IMAGE_NAME:String = "trash_icon";
      
      private var mWatermarkBG:FSImage;
      
      protected var mDeleteDuplicatedsButton:FSButton;
      
      protected var mDeleteDuplicatedsExceptCraftButton:FSButton;
      
      private var mRecycleRaidCoinsCount:RecycleRaidCoinsCount;
      
      public function RecycleCardsPanel(param1:int)
      {
         super(param1);
      }
      
      override protected function init() : void
      {
         super.init();
         this.createWatermarkImage();
      }
      
      override protected function createResetButton() : void
      {
      }
      
      private function createWatermarkImage() : void
      {
         var _loc1_:int = 0;
         if(this.mWatermarkBG == null)
         {
            this.mWatermarkBG = new FSImage(Root.assets.getTexture(this.WATERMARK_BG_IMAGE_NAME));
            this.mWatermarkBG.touchable = false;
            this.mWatermarkBG.x = (mBG.width - this.mWatermarkBG.width) / 2;
            this.mWatermarkBG.y = mBG.height / 2;
            _loc1_ = getChildIndex(mScrollableContainer);
            addChildAt(this.mWatermarkBG,_loc1_);
         }
      }
      
      override protected function createAutoFillDeckButton() : void
      {
         if(this.mDeleteDuplicatedsButton == null)
         {
            this.mDeleteDuplicatedsButton = new FSButton(Root.assets.getTexture("suggest_button"),TextManager.getText("TID_DECKBUILDER_ADD"));
            Utils.setupButton9Scale(this.mDeleteDuplicatedsButton,17.5,13.5,6,16,90,35);
            this.mDeleteDuplicatedsButton.setTooltipText(TextManager.replaceParameters(TextManager.getText("TID_DECKBUILDER_ADD_TOOLTIP"),[DeckCardsPanel.MAX_SLOTS_IN_DECK_PANEL]));
            this.mDeleteDuplicatedsButton.fontName = FSResourceMng.getFontByType();
            this.mDeleteDuplicatedsButton.fontColor = 16777215;
            this.mDeleteDuplicatedsButton.addEventListener(Event.TRIGGERED,this.onDeleteDuplicatedsTriggered);
            this.mDeleteDuplicatedsButton.x = mBG.x + mBG.width / 2;
            this.mDeleteDuplicatedsButton.y = mBG.x + mBG.height / 2;
            this.mDeleteDuplicatedsButton.visible = mDeckCardsAmount.getAmount() == 0;
            addChild(this.mDeleteDuplicatedsButton);
         }
         else
         {
            this.mDeleteDuplicatedsButton.visible = mDeckCardsAmount.getAmount() == 0;
         }
      }
      
      private function createAddExtraNonCraftMaterialCards() : void
      {
         if(this.mDeleteDuplicatedsExceptCraftButton == null)
         {
            this.mDeleteDuplicatedsExceptCraftButton = new FSButton(Root.assets.getTexture("suggest_button"),TextManager.getText("TID_DECKBUILDER_ADD_NOCRAFT"));
            Utils.setupButton9Scale(this.mDeleteDuplicatedsExceptCraftButton,17.5,13.5,6,16,90,35);
            this.mDeleteDuplicatedsExceptCraftButton.setTooltipText(TextManager.replaceParameters(TextManager.getText("TID_DECKBUILDER_ADD_NOCRAFT_TOOLTIP"),[DeckCardsPanel.MAX_SLOTS_IN_DECK_PANEL]));
            this.mDeleteDuplicatedsExceptCraftButton.fontName = FSResourceMng.getFontByType();
            this.mDeleteDuplicatedsExceptCraftButton.fontColor = 16777215;
            this.mDeleteDuplicatedsExceptCraftButton.addEventListener(Event.TRIGGERED,this.onDeleteDuplicatedsNonCraftTriggered);
            this.mDeleteDuplicatedsExceptCraftButton.x = this.mDeleteDuplicatedsButton.x;
            this.mDeleteDuplicatedsExceptCraftButton.y = this.mDeleteDuplicatedsButton.y + this.mDeleteDuplicatedsButton.height * 1.5;
            this.mDeleteDuplicatedsExceptCraftButton.visible = mDeckCardsAmount.getAmount() == 0;
            addChild(this.mDeleteDuplicatedsExceptCraftButton);
         }
         else
         {
            this.mDeleteDuplicatedsExceptCraftButton.visible = mDeckCardsAmount.getAmount() == 0;
         }
      }
      
      private function onDeleteDuplicatedsTriggered(param1:Event) : void
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         this.mDeleteDuplicatedsButton.visible = false;
         this.mDeleteDuplicatedsExceptCraftButton.visible = false;
         var _loc2_:UserData = Utils.getOwnerUserData();
         var _loc3_:Vector.<String> = _loc2_.getDuplicatedsCardsFromCollection();
         _loc5_ = 0;
         while(_loc5_ < _loc3_.length)
         {
            addCardSlotInfo(_loc3_[_loc5_],1,0);
            if(_loc2_)
            {
               _loc2_.removeCardFromNewCardsCollection(_loc3_[_loc5_],1,true);
            }
            _loc5_++;
         }
         if(_loc3_.length > 0)
         {
            onRemoveFromCollectionUpdateInfo();
         }
         else
         {
            this.mDeleteDuplicatedsButton.visible = true;
            this.mDeleteDuplicatedsExceptCraftButton.visible = true;
         }
      }
      
      private function onDeleteDuplicatedsNonCraftTriggered(param1:Event) : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         this.mDeleteDuplicatedsButton.visible = false;
         this.mDeleteDuplicatedsExceptCraftButton.visible = false;
         var _loc2_:Vector.<String> = InstanceMng.getUserDataMng().getOwnerUserData().getDuplicatedsCardsFromCollection(true);
         var _loc5_:UserData = Utils.getOwnerUserData();
         _loc4_ = 0;
         while(_loc4_ < _loc2_.length)
         {
            addCardSlotInfo(_loc2_[_loc4_],1,0);
            if(_loc5_)
            {
               _loc5_.removeCardFromNewCardsCollection(_loc2_[_loc4_],1,true);
            }
            _loc4_++;
         }
         if(_loc2_.length > 0)
         {
            onRemoveFromCollectionUpdateInfo();
         }
         else
         {
            this.mDeleteDuplicatedsButton.visible = true;
            this.mDeleteDuplicatedsExceptCraftButton.visible = true;
         }
      }
      
      override protected function createDeckCardsAmount() : void
      {
         if(mDeckCardsAmount == null)
         {
            mDeckCardsAmount = new RecycleGoldCount(0);
            mDeckCardsAmount.x = mBG.width * 0.33 - mDeckCardsAmount.width / 2;
            mDeckCardsAmount.y = mBG.y + mBG.height - mDeckCardsAmount.height * 0.95;
            addChild(mDeckCardsAmount);
         }
         if(this.mRecycleRaidCoinsCount == null)
         {
            this.mRecycleRaidCoinsCount = new RecycleRaidCoinsCount(0);
            this.mRecycleRaidCoinsCount.x = mDeckCardsAmount.x + mDeckCardsAmount.width;
            this.mRecycleRaidCoinsCount.y = mDeckCardsAmount.y;
            addChild(this.mRecycleRaidCoinsCount);
         }
      }
      
      override public function onDeckModified(param1:Boolean) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Screen = InstanceMng.getCurrentScreen();
         if(_loc2_ is FSDeckBuilderScreen && FSDeckBuilderScreen(_loc2_).getRecyclePanel() != null && Boolean(FSDeckBuilderScreen(_loc2_).getRecyclePanel().getDeckCardsAmount()))
         {
            _loc3_ = FSDeckBuilderScreen(_loc2_).getRecyclePanel().getDeckCardsAmount().getAmount();
            if(this.mDeleteDuplicatedsButton)
            {
               if(param1 && _loc3_ == 0)
               {
                  this.mDeleteDuplicatedsButton.visible = false;
               }
               else if(!param1 && _loc3_ == 0)
               {
                  this.mDeleteDuplicatedsButton.visible = true;
               }
            }
            if(this.mDeleteDuplicatedsExceptCraftButton)
            {
               if(param1 && _loc3_ == 0)
               {
                  this.mDeleteDuplicatedsExceptCraftButton.visible = false;
               }
               else if(!param1 && _loc3_ == 0)
               {
                  this.mDeleteDuplicatedsExceptCraftButton.visible = true;
               }
            }
         }
      }
      
      override protected function createSaveButton() : void
      {
         super.createSaveButton();
         if(mSaveButton != null)
         {
            mSaveButton.upState = Root.assets.getTexture("db_icon_recycle");
            mSaveButton.downState = Root.assets.getTexture("db_icon_recycle");
            mSaveButton.overState = Root.assets.getTexture("db_icon_recycle");
            mSaveButton.disabledState = Root.assets.getTexture("db_icon_recycle");
         }
      }
      
      override protected function updateDeckCardsAmount(param1:String, param2:int) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:CardDef = CardDef(InstanceMng.getCardsDefMng().getDefBySku(param1));
         if(_loc4_ != null)
         {
            _loc5_ = _loc4_.getGoldOnSell();
            if(_loc5_ != -1)
            {
               _loc3_ = _loc4_.getGoldOnSell() * param2;
            }
            _loc6_ = _loc4_.getRaidCoinsOnSell() * param2;
         }
         mDeckCardsAmount.addAmount(_loc3_);
         this.mRecycleRaidCoinsCount.addAmount(_loc6_);
      }
      
      override protected function onAcceptButtonTriggered() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            if(!PvPConnectionMng.smUserInPvPQueue)
            {
               _loc1_ = DictionaryUtils.getDictionaryLength(mDeckCardsLoaded);
               if(_loc1_ > 0)
               {
                  _loc2_ = DictionaryUtils.getCardsAmountPerCatalog(InstanceMng.getUserDataMng().getOwnerUserData().getCardCollection());
                  _loc3_ = DictionaryUtils.getCardsAmountPerCatalog(mDeckCardsLoaded);
                  _loc4_ = _loc2_ - _loc3_ >= Config.getConfig().getMinCardsAmountForRecycling();
                  if(!_loc4_)
                  {
                     Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_DECKBUILDER_RECYCLE_BELOW_MIN"),[Config.getConfig().getMinCardsAmountForRecycling()]),true);
                  }
                  else
                  {
                     _loc5_ = DictionaryUtils.getCardsAmountPerCatalog(DictionaryUtils.getCatalogFilteredByCategory(InstanceMng.getUserDataMng().getOwnerUserData().getCardCollection(),CategoriesDefMng.CATEGORY_POWERS));
                     _loc6_ = DictionaryUtils.getCardsAmountPerCatalog(DictionaryUtils.getCatalogFilteredByCategory(mDeckCardsLoaded,CategoriesDefMng.CATEGORY_POWERS));
                     if(_loc6_ > 0 && _loc5_ - _loc6_ <= 0)
                     {
                        Utils.setLogText(TextManager.getText("TID_DECKBUILDER_CARD_POWER"));
                     }
                     else
                     {
                        _loc7_ = this.mRecycleRaidCoinsCount.getAmount();
                        if(_loc7_ == 0)
                        {
                           InstanceMng.getPopupMng().openDeleteCardsPopup(TextManager.replaceParameters(TextManager.getText("TID_SELL_CONFIRMATION"),[mDeckCardsAmount.getAmount()]));
                        }
                        else
                        {
                           InstanceMng.getPopupMng().openDeleteCardsPopup(TextManager.replaceParameters(TextManager.getText("TID_SELL_CONFIRMATION_RAID_POINTS"),[mDeckCardsAmount.getAmount(),_loc7_]));
                        }
                     }
                  }
               }
               else
               {
                  Utils.setLogText(TextManager.getText("TID_DECKBUILDER_RECYCLE_ADD_FIRST"),true);
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
            InstanceMng.getCurrentScreen().onConnectionLost();
         }
      }
      
      public function onAcceptPerformOps() : void
      {
         var _loc1_:UserData = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:FSDeckBuilderScreen = null;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Array = null;
         var _loc11_:String = null;
         var _loc12_:int = 0;
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen && FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).isRecyclingMode())
            {
               _loc1_ = Utils.getOwnerUserData();
               _loc2_ = mDeckCardsAmount ? mDeckCardsAmount.getAmount() : 0;
               _loc3_ = this.mRecycleRaidCoinsCount ? this.mRecycleRaidCoinsCount.getAmount() : 0;
               _loc4_ = FSDeckBuilderScreen(InstanceMng.getCurrentScreen());
               _loc4_.lockUI(true);
               _loc5_ = _loc4_.deleteCurrentCardsOnRecyclePanel();
               if(_loc5_ != null)
               {
                  _loc6_ = int(_loc5_.gold);
                  _loc7_ = int(_loc5_.raidCoins);
                  _loc8_ = int(_loc5_.cardsDeleted);
                  _loc9_ = DictionaryUtils.getCardsAmountPerCatalog(mDeckCardsLoaded);
                  if(_loc2_ != _loc6_ || _loc3_ != _loc7_ || _loc8_ != _loc9_)
                  {
                     FSDebug.debugTrace("Currency to receive doesn\'t match the amount calculated!: Gold:( " + _loc2_ + "/" + _loc6_ + ") | Raid Coins: ( " + _loc3_ + "/" + _loc7_ + ")");
                     Utils.setLogText("Error");
                  }
                  else
                  {
                     if(_loc2_ != 0)
                     {
                        _loc1_.addGold(_loc2_);
                     }
                     if(_loc3_ != 0)
                     {
                        _loc1_.addRaidCoins(_loc3_);
                     }
                     InstanceMng.getUserDataMng().persistenceSaveData();
                     Utils.setLogText(TextManager.getText("TID_DECKBUILDER_RECYCLED"));
                     _loc10_ = DictionaryUtils.dictionaryToArray(mDeckCardsLoaded);
                     _loc11_ = "";
                     if(_loc10_)
                     {
                        _loc12_ = 0;
                        while(_loc12_ < _loc10_.length)
                        {
                           _loc11_ += _loc10_[_loc12_];
                           if(_loc12_ != _loc10_.length - 1)
                           {
                              _loc11_ += ",";
                           }
                           _loc12_++;
                        }
                     }
                     Utils.setStat(Constants.STAT_CARDS_RECYCLED,_loc9_);
                     InstanceMng.getServerConnection().addCardsDeletedInstance(_loc11_,_loc2_,_loc9_);
                     FSTracker.trackMiscAction(FSTracker.CATEGORY_DECK_BUILDER,FSTracker.ACTION_CARDS_DELETED);
                     removeDeckCardsLoaded();
                     showForegroundAnim(false);
                  }
               }
            }
            else
            {
               Utils.setLogText(TextManager.getText("TID_GEN_SERVER_RETRY"),true);
            }
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true);
         }
      }
      
      override protected function onCancelButtonTriggered() : void
      {
         InstanceMng.getPopupMng().openUnsavedDataPopup();
      }
      
      override public function setup(param1:int, param2:Boolean = true, param3:Boolean = false) : void
      {
         var _loc4_:FSDeckBuilderScreen = null;
         if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            _loc4_ = FSDeckBuilderScreen(InstanceMng.getCurrentScreen());
            if(_loc4_ != null)
            {
               _loc4_.updateDeckTitleLabel(-1,TextManager.getText("TID_DECKBUILDER_RECYCLE_PANEL"));
            }
            showForegroundAnim(true);
            this.createAutoFillDeckButton();
            this.createAddExtraNonCraftMaterialCards();
            if(InstanceMng.getCurrentScreen())
            {
               InstanceMng.getCurrentScreen().reAddUIVisualsOptions();
            }
         }
      }
      
      override public function resetPanel() : void
      {
         if(this.mRecycleRaidCoinsCount != null)
         {
            this.mRecycleRaidCoinsCount.setAmount(0);
         }
         super.resetPanel();
      }
      
      override public function dispose() : void
      {
         if(this.mWatermarkBG)
         {
            this.mWatermarkBG.removeFromParent(true);
            this.mWatermarkBG = null;
         }
         if(this.mDeleteDuplicatedsButton)
         {
            this.mDeleteDuplicatedsButton.removeFromParent(true);
            this.mDeleteDuplicatedsButton = null;
         }
         if(this.mDeleteDuplicatedsExceptCraftButton)
         {
            this.mDeleteDuplicatedsExceptCraftButton.removeFromParent(true);
            this.mDeleteDuplicatedsExceptCraftButton = null;
         }
         if(this.mRecycleRaidCoinsCount)
         {
            this.mRecycleRaidCoinsCount.removeFromParent(true);
            this.mRecycleRaidCoinsCount = null;
         }
         super.dispose();
      }
   }
}

