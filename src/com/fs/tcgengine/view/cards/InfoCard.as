package com.fs.tcgengine.view.cards
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSDeckBuilderScreen;
   import com.fs.tcgengine.screens.FSShopScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.components.shop.CraftAvailableProgressBar;
   import com.fs.tcgengine.view.misc.DeckCardsPanel;
   import com.fs.tcgengine.view.misc.FSImage;
   import feathers.controls.ScrollContainer;
   import flash.utils.Dictionary;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   
   public class InfoCard extends Component
   {
      
      private const REWARD_SOCKET_IMG_NAME:String = "amount_socket";
      
      private const GOLD_COST_SOCKET_EXTENSION_NAME:String = "recycle_cost_tab";
      
      private const RAID_COINS_COST_SOCKET_EXTENSION_NAME:String = "recycle_cost_tab_raid_coins";
      
      protected var mCard:FSCard;
      
      protected var mRewardSocket:FSImage;
      
      private var mAmountTextfield:FSTextfield;
      
      protected var mAmount:int;
      
      private var mParentContainer:ScrollContainer;
      
      protected var mIsMoving:Boolean;
      
      private var mScrollBlocked:Boolean;
      
      protected var mDeckCardsPanel:DeckCardsPanel;
      
      private var mSocketVisible:Boolean;
      
      private var mRecycleCostSocketExtension:Component;
      
      private var mRecycleGoldTextfield:FSTextfield;
      
      private var mRecycleRaidCoinsTextfield:FSTextfield;
      
      private var mShowRecycleCost:Boolean = false;
      
      private var mCardLimitSocketExtensionImage:FSImage;
      
      private var mCardLimitSocketExtensionTextfield:FSTextfield;
      
      protected var mNewCardBG:FSImage;
      
      protected var mNewCardTextfield:FSTextfield;
      
      protected var mCraftAvailableProgressBar:CraftAvailableProgressBar;
      
      protected var mCraftAvailableTextfield:FSTextfield;
      
      public function InfoCard(param1:FSCard, param2:int, param3:Boolean = true, param4:Boolean = false)
      {
         super();
         this.mCard = param1;
         this.mCard.setIsRewardCard(param4);
         this.mSocketVisible = param3;
         this.mCard.setIsInfoCard(true);
         this.mAmount = param2;
         if(this.mSocketVisible)
         {
            this.createSocketBG();
            this.createAmountTextfield();
         }
         this.placeCardInSocket();
      }
      
      public function checkIfNewCard(param1:Boolean = false) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Screen = null;
         var _loc4_:UserData = null;
         var _loc5_:int = 0;
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            _loc3_ = InstanceMng.getCurrentScreen();
            if(_loc3_ is FSShopScreen)
            {
               _loc4_ = Utils.getOwnerUserData();
               _loc2_ = (Boolean(_loc4_)) && _loc4_.getCardAmount(this.mCard.getCardDef().getSku()) == 1;
            }
            else if(_loc3_ is FSDeckBuilderScreen)
            {
               _loc2_ = InstanceMng.getUserDataMng().checkIfCardIsNewCard(this.mCard.getCardDef().getSku());
            }
            if(_loc2_)
            {
               if(this.mNewCardBG == null && !param1)
               {
                  this.mNewCardBG = new FSImage(Root.assets.getTexture("new_card_glow"));
                  this.mNewCardBG.touchable = false;
                  this.mNewCardBG.alignPivot();
                  this.mNewCardBG.x = this.mCard.x;
                  this.mNewCardBG.y = this.mCard.y;
                  addChildAt(this.mNewCardBG,getChildIndex(this.mCard) + 1);
               }
               if(this.mNewCardTextfield == null)
               {
                  _loc5_ = this.mNewCardBG ? int(this.mNewCardBG.height / 6) : int(height / 6);
                  this.mNewCardTextfield = new FSTextfield(this.mCard.width,_loc5_,TextManager.getText("TID_GEN_NEW"));
                  this.mNewCardTextfield.touchable = false;
                  this.mNewCardTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GOLD);
                  this.mNewCardTextfield.x = this.mCard.x - this.mCard.width / 2;
                  this.mNewCardTextfield.y = this.mCard.y + 5 - this.mCard.height / 2;
                  addChild(this.mNewCardTextfield);
               }
            }
         }
      }
      
      public function checkIfCraftAvailable() : void
      {
         var _loc1_:UserData = null;
         var _loc2_:Screen = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:String = null;
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            _loc1_ = Utils.getOwnerUserData();
            _loc2_ = InstanceMng.getCurrentScreen();
            _loc3_ = InstanceMng.getCardsDefMng().getFirstNeededCraftMaterialAmount(this.mCard.getCardDef());
            _loc4_ = _loc1_.getCardAmount(this.mCard.getCardDef().getSku());
            _loc5_ = !(_loc2_ is FSDeckBuilderScreen) && _loc3_ > 0;
            if(_loc5_)
            {
               if(this.mCraftAvailableProgressBar == null)
               {
                  this.mCraftAvailableProgressBar = new CraftAvailableProgressBar();
                  this.mCraftAvailableProgressBar.scale = 0.55;
                  this.mCraftAvailableProgressBar.touchable = false;
                  this.mCraftAvailableProgressBar.alignPivot();
                  this.mCraftAvailableProgressBar.x = this.mCard.x;
                  this.mCraftAvailableProgressBar.y = this.mCard.y + this.mCard.height / 1.65;
                  this.mCraftAvailableProgressBar.updateProgressBar(_loc4_,_loc3_);
                  addChildAt(this.mCraftAvailableProgressBar,getChildIndex(this.mCard) + 1);
               }
               if(this.mCraftAvailableTextfield == null)
               {
                  _loc6_ = _loc4_ >= _loc3_ ? "TID_CRAFT_AVAILABLE" : "TID_CRAFT_PROGRESS";
                  this.mCraftAvailableTextfield = new FSTextfield(this.mCraftAvailableProgressBar.width,this.mCraftAvailableProgressBar.height,TextManager.getText(_loc6_));
                  this.mCraftAvailableTextfield.touchable = false;
                  this.mCraftAvailableTextfield.alignPivot();
                  this.mCraftAvailableTextfield.x = this.mCraftAvailableProgressBar.x;
                  this.mCraftAvailableTextfield.y = this.mCraftAvailableProgressBar.y + this.mCraftAvailableProgressBar.height / 2;
                  addChild(this.mCraftAvailableTextfield);
               }
            }
         }
      }
      
      protected function checkIfNewCardGlowNeedsToBeRemoved(param1:Boolean = false) : void
      {
         var _loc2_:Dictionary = null;
         var _loc3_:int = 0;
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            if(InstanceMng.getUserDataMng().checkIfCardIsNewCard(this.mCard.getCardDef().getSku()))
            {
               if(Boolean(this.mCard && this.mCard.getCardDef() != null) && Boolean(InstanceMng.getUserDataMng()) && InstanceMng.getUserDataMng().getOwnerUserData() != null)
               {
                  if(param1)
                  {
                     _loc2_ = InstanceMng.getUserDataMng().getOwnerUserData().getNewCardsCollection();
                     if(_loc2_ != null)
                     {
                        _loc3_ = _loc2_[this.mCard.getCardDef().getSku()] > 0 ? int(_loc2_[this.mCard.getCardDef().getSku()]) : 1;
                        InstanceMng.getUserDataMng().getOwnerUserData().removeCardFromNewCardsCollection(this.mCard.getCardDef().getSku(),_loc3_);
                     }
                  }
                  this.removeNewCardGlow();
               }
            }
         }
      }
      
      protected function removeNewCardGlow() : void
      {
         if(this.mNewCardBG)
         {
            this.mNewCardBG.visible = false;
         }
         if(this.mNewCardTextfield)
         {
            this.mNewCardTextfield.removeFromParent(true);
            this.mNewCardTextfield = null;
         }
         if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).refreshNewCardsAmountsOnTabs();
         }
      }
      
      protected function placeCardInSocket() : void
      {
         if(this.mCard != null && this.mRewardSocket != null)
         {
            this.mCard.x = (this.mRewardSocket.width - this.mCard.width) / 2 + this.mCard.width / 2;
            this.mCard.y = this.mRewardSocket.height * 0.12 + this.mCard.height / 2;
         }
         else
         {
            this.mCard.x = this.mCard.width / 2;
            this.mCard.y = this.mCard.height / 2;
         }
         addChild(this.mCard);
         this.mCard.activateDropShadow(true);
         this.addEventListeners();
      }
      
      private function createAmountTextfield() : void
      {
         if(this.mAmountTextfield == null)
         {
            this.mAmountTextfield = new FSTextfield(this.mCard.width,this.mCard.height * 0.15);
            this.mAmountTextfield.fontName = FSResourceMng.getFontByType();
            this.mAmountTextfield.fontSize = FSResourceMng.FONT_STD_DEFAULT_SIZE;
            this.mAmountTextfield.color = 15852199;
            this.mAmountTextfield.x = (width - this.mAmountTextfield.width) / 2;
            this.mAmountTextfield.y = 0;
         }
         this.updateAmountTextfield();
         addChild(this.mAmountTextfield);
      }
      
      protected function updateAmountTextfield() : void
      {
         if(this.mAmountTextfield != null)
         {
            this.mAmountTextfield.text = "x" + this.mAmount.toString();
         }
      }
      
      private function createSocketBG() : void
      {
         if(this.mRewardSocket == null)
         {
            this.mRewardSocket = new FSImage(Root.assets.getTexture(this.REWARD_SOCKET_IMG_NAME));
         }
         this.mRewardSocket.visible = this.mSocketVisible;
         addChild(this.mRewardSocket);
      }
      
      public function setParentContainer(param1:ScrollContainer) : void
      {
         this.mParentContainer = param1;
      }
      
      public function setTouchable() : void
      {
         touchable = true;
      }
      
      protected function addEventListeners() : void
      {
         this.addEventListener(TouchEvent.TOUCH,this.onTouch);
      }
      
      protected function isMovable() : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc1_:Boolean = false;
         var _loc2_:Screen = InstanceMng.getCurrentScreen();
         if(_loc2_ is FSDeckBuilderScreen)
         {
            _loc3_ = InstanceMng.getCurrentScreen() is FSDeckBuilderScreen ? FSDeckBuilderScreen(_loc2_).getEdidionStatus() == FSDeckBuilderScreen.STATUS_EDITING : false;
            _loc4_ = InstanceMng.getCurrentScreen() is FSDeckBuilderScreen ? !FSDeckBuilderScreen(_loc2_).isViewAllCardsModeON() : false;
            _loc1_ = _loc3_ && _loc4_;
         }
         else
         {
            _loc1_ = false;
         }
         return _loc1_;
      }
      
      protected function onTouch(param1:TouchEvent) : void
      {
         var _loc2_:Boolean = this.isMovable();
         var _loc3_:Touch = param1.getTouch(this,TouchPhase.ENDED);
         if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen && FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).getEdidionStatus() == FSDeckBuilderScreen.STATUS_CREATION_MODE && this.mAmount == 0)
         {
            return;
         }
         _loc3_ = param1.getTouch(this,TouchPhase.HOVER);
         alpha = _loc3_ ? 0.8 : 0.999;
      }
      
      private function setParentScrollContainerEnabled(param1:Boolean) : void
      {
         if(this.mParentContainer != null)
         {
            this.mScrollBlocked = !param1;
            if(this.mScrollBlocked)
            {
               this.mParentContainer.stopScrolling();
            }
         }
      }
      
      private function showRecycleCost() : void
      {
         var _loc3_:FSImage = null;
         var _loc4_:FSImage = null;
         var _loc1_:int = this.mCard.getCardDef().getGoldOnSell();
         var _loc2_:int = this.mCard.getCardDef().getRaidCoinsOnSell();
         if(_loc1_ > 0 || _loc2_ > 0)
         {
            if(this.mShowRecycleCost)
            {
               if(this.mRecycleCostSocketExtension == null)
               {
                  this.mRecycleCostSocketExtension = new Component();
               }
               this.mRecycleCostSocketExtension.x = 0;
               this.mRecycleCostSocketExtension.y = this.mRewardSocket.y + this.mRewardSocket.height * 1.075;
               addChild(this.mRecycleCostSocketExtension);
            }
            else if(this.mRecycleCostSocketExtension)
            {
               this.mRecycleCostSocketExtension.removeFromParent();
            }
         }
         if(this.mShowRecycleCost)
         {
            if(_loc2_ > 0)
            {
               _loc3_ = new FSImage(Root.assets.getTexture(this.RAID_COINS_COST_SOCKET_EXTENSION_NAME));
               this.mRecycleCostSocketExtension.addChild(_loc3_);
               this.mRecycleRaidCoinsTextfield = new FSTextfield(_loc3_.width,_loc3_.height,"0",16777215,FSResourceMng.FONT_STD_SMALL_SIZE);
               this.mRecycleRaidCoinsTextfield.x = 0;
               this.mRecycleRaidCoinsTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_WHITE);
               this.setRaidCoinsCostPrice(_loc2_);
               this.mRecycleCostSocketExtension.addChild(this.mRecycleRaidCoinsTextfield);
            }
            if(_loc1_ != -1)
            {
               _loc4_ = new FSImage(Root.assets.getTexture(this.GOLD_COST_SOCKET_EXTENSION_NAME));
               _loc4_.x = _loc2_ > 0 ? _loc3_.x + _loc3_.width : _loc4_.width / 2;
               this.mRecycleCostSocketExtension.addChild(_loc4_);
               this.mRecycleGoldTextfield = new FSTextfield(_loc4_.width,_loc4_.height,"0",16777215,FSResourceMng.FONT_STD_SMALL_SIZE);
               this.mRecycleGoldTextfield.x = _loc4_.x;
               this.mRecycleGoldTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_WHITE);
               this.setGoldCostPrice(_loc1_);
               this.mRecycleCostSocketExtension.addChild(this.mRecycleGoldTextfield);
            }
            if(this.mRecycleCostSocketExtension)
            {
               this.mRecycleCostSocketExtension.x = this.mRewardSocket.x + (this.mRewardSocket.width - this.mRecycleCostSocketExtension.width) / 2;
            }
         }
      }
      
      private function hideCardLimitSocket() : void
      {
         if(this.mCardLimitSocketExtensionImage)
         {
            this.mCardLimitSocketExtensionImage.removeFromParent();
         }
         if(this.mCardLimitSocketExtensionTextfield)
         {
            this.mCardLimitSocketExtensionTextfield.removeFromParent();
         }
      }
      
      public function showCardLimitSocket() : void
      {
         var _loc1_:int = this.mCard.getCardDef().getMaxAmountOndeck();
         if(_loc1_ > 0)
         {
            if(this.mCardLimitSocketExtensionImage == null)
            {
               this.mCardLimitSocketExtensionImage = new FSImage(Root.assets.getTexture("decklimit_tab"));
               this.mCardLimitSocketExtensionImage.x = this.mRewardSocket.x + (this.mRewardSocket.width - this.mCardLimitSocketExtensionImage.width) / 2;
               this.mCardLimitSocketExtensionImage.y = this.mRewardSocket.y + this.mRewardSocket.height * 1.075;
            }
            addChild(this.mCardLimitSocketExtensionImage);
            if(this.mCardLimitSocketExtensionTextfield == null)
            {
               this.mCardLimitSocketExtensionTextfield = new FSTextfield(this.mCardLimitSocketExtensionImage.width,this.mCardLimitSocketExtensionImage.height,"",16777215,FSResourceMng.FONT_STD_SMALL_SIZE);
               this.mCardLimitSocketExtensionTextfield.x = this.mCardLimitSocketExtensionImage.x;
               this.mCardLimitSocketExtensionTextfield.y = this.mCardLimitSocketExtensionImage.y;
               this.mCardLimitSocketExtensionTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_WHITE);
            }
            this.mCardLimitSocketExtensionTextfield.text = TextManager.replaceParameters(TextManager.getText("TID_DECKBUILDER_CARD_LIMIT"),[_loc1_]);
            addChild(this.mCardLimitSocketExtensionTextfield);
         }
      }
      
      private function setGoldCostPrice(param1:int) : void
      {
         if(this.mRecycleGoldTextfield != null)
         {
            this.mRecycleGoldTextfield.text = param1.toString();
         }
      }
      
      private function setRaidCoinsCostPrice(param1:int) : void
      {
         if(this.mRecycleRaidCoinsTextfield != null)
         {
            this.mRecycleRaidCoinsTextfield.text = param1.toString();
         }
      }
      
      public function getAmount() : int
      {
         return this.mAmount;
      }
      
      public function setAmount(param1:int) : void
      {
         this.mAmount = param1;
         this.updateAmountTextfield();
      }
      
      public function addAmount(param1:int) : void
      {
         this.mAmount += param1;
         this.updateAmountTextfield();
      }
      
      public function getCardValue() : int
      {
         var _loc1_:int = 0;
         if(this.mCard != null)
         {
            _loc1_ = this.mCard.getCardDef().getCardValue();
         }
         return _loc1_;
      }
      
      public function setShowRecycleCost(param1:Boolean) : void
      {
         this.mShowRecycleCost = param1;
         this.showRecycleCost();
      }
      
      public function getParentCard() : FSCard
      {
         return this.mCard;
      }
      
      override public function dispose() : void
      {
         if(this.mCard)
         {
            DictionaryUtils.disposeCard(this.mCard);
            this.mCard = null;
         }
         if(this.mRewardSocket)
         {
            this.mRewardSocket.removeFromParent(true);
            this.mRewardSocket = null;
         }
         if(this.mAmountTextfield)
         {
            this.mAmountTextfield.removeFromParent(true);
            this.mAmountTextfield = null;
         }
         this.mParentContainer = null;
         this.mDeckCardsPanel = null;
         if(this.mRecycleCostSocketExtension)
         {
            this.mRecycleCostSocketExtension.removeFromParent(true);
            this.mRecycleCostSocketExtension = null;
         }
         if(this.mRecycleGoldTextfield)
         {
            this.mRecycleGoldTextfield.removeFromParent(true);
            this.mRecycleGoldTextfield = null;
         }
         if(this.mRecycleRaidCoinsTextfield)
         {
            this.mRecycleRaidCoinsTextfield.removeFromParent(true);
            this.mRecycleRaidCoinsTextfield = null;
         }
         if(this.mCardLimitSocketExtensionImage)
         {
            this.mCardLimitSocketExtensionImage.removeFromParent(true);
            this.mCardLimitSocketExtensionImage = null;
         }
         if(this.mCardLimitSocketExtensionTextfield)
         {
            this.mCardLimitSocketExtensionTextfield.removeFromParent(true);
            this.mCardLimitSocketExtensionTextfield = null;
         }
         if(this.mNewCardBG)
         {
            this.mNewCardBG.removeFromParent(true);
            this.mNewCardBG = null;
         }
         if(this.mNewCardTextfield)
         {
            this.mNewCardTextfield.removeFromParent(true);
            this.mNewCardTextfield = null;
         }
         if(this.mCraftAvailableTextfield)
         {
            this.mCraftAvailableTextfield.removeFromParent(true);
            this.mCraftAvailableTextfield = null;
         }
         if(this.mCraftAvailableProgressBar)
         {
            this.mCraftAvailableProgressBar.removeFromParent(true);
            this.mCraftAvailableProgressBar = null;
         }
         this.removeEventListener(TouchEvent.TOUCH,this.onTouch);
         super.dispose();
      }
      
      public function createFusionLayer() : void
      {
         if(this.mCard)
         {
            this.mCard.createFusionLayer();
         }
      }
   }
}

