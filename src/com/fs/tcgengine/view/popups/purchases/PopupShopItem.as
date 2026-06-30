package com.fs.tcgengine.view.popups.purchases
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.model.rules.BundleDef;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.HeroCharacterDef;
   import com.fs.tcgengine.model.rules.PackDef;
   import com.fs.tcgengine.model.rules.QuestShopDef;
   import com.fs.tcgengine.model.rules.RaidShopDef;
   import com.fs.tcgengine.model.rules.RarityDef;
   import com.fs.tcgengine.model.rules.ShopBoostDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSDeckBuilderScreen;
   import com.fs.tcgengine.screens.FSShopScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.anims.misc.PackAnimation;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.FSShopInfoCard;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.buttons.FSPurchaseButton;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.components.shop.FSShopItem;
   import com.fs.tcgengine.view.components.shop.ShopItemSlotInfo;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.misc.JobPanel;
   import com.fs.tcgengine.view.popups.misc.PopupStandard;
   import com.greensock.easing.Back;
   import com.greensock.easing.Quad;
   import feathers.layout.HorizontalAlign;
   import feathers.layout.HorizontalLayout;
   import flash.utils.setTimeout;
   import starling.events.Event;
   import starling.textures.Texture;
   import starling.utils.Align;
   
   public class PopupShopItem extends PopupStandard
   {
      
      protected var mShopItem:FSShopItem;
      
      protected var mItemImage:FSImage;
      
      protected var mItemShadow:FSImage;
      
      protected var mPackAnimation:PackAnimation;
      
      protected var mCard:FSShopInfoCard;
      
      protected var mTitleTextfield:FSTextfield;
      
      protected var mSubtitleTextfield:FSTextfield;
      
      protected var mDescriptionTextfield:FSTextfield;
      
      protected var mPackRaritiesContainer:Component;
      
      protected var mPurchaseButton:FSPurchaseButton;
      
      protected var mPurchaseButtonx10:FSPurchaseButton;
      
      protected var mInfoButton:FSButton;
      
      public function PopupShopItem(param1:Boolean = true)
      {
         super(true);
      }
      
      override protected function setResourcesToLoad() : void
      {
         if(this.fulfilsCondition())
         {
            super.setResourcesToLoad();
         }
      }
      
      override protected function createBackground(param1:String, param2:int = 1000) : void
      {
         param2 = Boolean(this.mShopItem) && this.mShopItem.isBundle() ? 1590 : param2;
         super.createBackground(param1,param2);
      }
      
      override protected function setupAcceptButton(param1:String, param2:String = "", param3:String = "") : void
      {
      }
      
      override protected function getBackgroundName(param1:String) : void
      {
         mBGName = Constants.POPUP_EXTENDED_NAME;
      }
      
      override protected function createUI() : void
      {
         super.createUI();
         this.createMainComponents();
      }
      
      public function setupPopup(param1:FSShopItem) : void
      {
         this.mShopItem = param1;
         this.setResourcesToLoad();
         if(Boolean(this.mShopItem) && this.mShopItem.isOffer())
         {
            addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         if(Boolean(this.mShopItem) && this.mShopItem.getOfferType() == FSShopItem.HOURLY_OFFER)
         {
            if(this.mSubtitleTextfield)
            {
               this.mSubtitleTextfield.text = !this.mShopItem.isOfferExpired() ? this.mShopItem.getSubtitleText() : TextManager.getText("TID_SHOP_OFFER_EXPIRED");
            }
         }
      }
      
      private function createMainComponents() : void
      {
         if(this.fulfilsCondition())
         {
            this.createItemImage();
            this.createTitle();
            this.createSubtitle();
            this.createPurchaseButton();
            this.createDescription();
            this.createPackRaritiesInfo();
            this.createInfoButton();
         }
         if(this.allowedToShowPurchaseButton())
         {
            if(this.mPurchaseButton)
            {
               addChild(this.mPurchaseButton);
            }
            if(this.mPurchaseButtonx10)
            {
               addChild(this.mPurchaseButtonx10);
            }
         }
      }
      
      private function createInfoButton() : void
      {
         var _loc1_:Def = null;
         var _loc2_:String = null;
         if(this.mShopItem)
         {
            _loc1_ = this.mShopItem.getDef();
            if(_loc1_ is PackDef)
            {
               _loc2_ = PackDef(_loc1_).getChancesTooltipText();
               if(_loc2_ != null && _loc2_ != "")
               {
                  if(this.mInfoButton == null)
                  {
                     this.mInfoButton = new FSButton(Root.assets.getTexture("quest_info_button"));
                     this.mInfoButton.x = this.mInfoButton.width / 2;
                     this.mInfoButton.y = this.mInfoButton.height / 2;
                     this.mInfoButton.scaleWhenDown = 1;
                     this.mInfoButton.enableScaleOnMouseOver(false);
                     this.mInfoButton.setTooltipText(_loc2_);
                     addChild(this.mInfoButton);
                  }
               }
            }
         }
      }
      
      protected function fulfilsCondition() : Boolean
      {
         return this.mShopItem != null;
      }
      
      private function createPurchaseButton() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Def = null;
         var _loc3_:Number = NaN;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         if(this.mShopItem)
         {
            _loc1_ = false;
            _loc2_ = this.mShopItem.getDef();
            _loc4_ = "";
            _loc5_ = "";
            if(_loc2_ is PackDef)
            {
               if(PackDef(_loc2_).costsGold())
               {
                  _loc5_ = ServerConnection.CURRENCY_GOLD;
                  _loc3_ = PackDef(_loc2_).getGold();
                  _loc1_ = true;
               }
            }
            else if(_loc2_ is HeroCharacterDef)
            {
               if(HeroCharacterDef(_loc2_).getCostsGold())
               {
                  _loc5_ = ServerConnection.CURRENCY_GOLD;
                  _loc3_ = HeroCharacterDef(_loc2_).getGold();
                  _loc1_ = true;
               }
            }
            else if(_loc2_ is RaidShopDef)
            {
               _loc5_ = ServerConnection.CURRENCY_RAID_COINS;
               _loc3_ = RaidShopDef(_loc2_).getCost();
               _loc1_ = true;
            }
            else if(_loc2_ is QuestShopDef)
            {
               _loc5_ = ServerConnection.CURRENCY_QUEST_COINS;
               _loc3_ = QuestShopDef(_loc2_).getCost();
               _loc1_ = true;
            }
            if(this.mShopItem.isOffer() && this.mShopItem.getOfferGoldCost() > 0)
            {
               _loc5_ = ServerConnection.CURRENCY_GOLD;
               _loc3_ = this.mShopItem.getOfferGoldCost();
               _loc1_ = true;
            }
            if(!_loc1_)
            {
               _loc4_ = InstanceMng.getApplication().getInAppsManager().getPriceOfProd(this.mShopItem);
               _loc6_ = _loc4_ != null && _loc4_ != "" && _loc4_ != "N.A";
               _loc4_ = _loc6_ ? _loc4_ : "N.A";
            }
            if(this.mPurchaseButton == null)
            {
               this.mPurchaseButton = new FSPurchaseButton(_loc5_,_loc3_,this.onPurchaseButtonTriggered,null,_loc4_,Align.LEFT);
               if(this.allowedToShowPurchaseButton())
               {
                  addChild(this.mPurchaseButton);
               }
            }
            if(this.mPurchaseButton)
            {
               this.mPurchaseButton.x = mBox.x + mBox.width / 2;
               this.mPurchaseButton.y = mBox.y + mBox.height;
            }
            if(this.mShopItem.isRaidsCard())
            {
               if(this.mShopItem.getCardDef().isCraftMaterial())
               {
                  if(this.mPurchaseButtonx10 == null)
                  {
                     this.mPurchaseButtonx10 = new FSPurchaseButton(_loc5_,_loc3_ * 10,this.onPurchasex10ButtonTriggered,null,_loc4_,Align.LEFT);
                     this.mPurchaseButtonx10.text = _loc3_ * 10 + " (x10)";
                     _loc7_ = (mBox.width - (this.mPurchaseButton.width + this.mPurchaseButtonx10.width)) / 2;
                     this.mPurchaseButtonx10.x = mBox.x + mBox.width - this.mPurchaseButtonx10.width / 2 - _loc7_ / 2;
                     this.mPurchaseButtonx10.y = mBox.y + mBox.height;
                     if(this.mPurchaseButton)
                     {
                        this.mPurchaseButton.x = mBox.x + this.mPurchaseButton.width / 2 + _loc7_ / 2;
                        this.mPurchaseButton.y = mBox.y + mBox.height;
                     }
                     if(this.allowedToShowPurchaseButton())
                     {
                        addChild(this.mPurchaseButtonx10);
                     }
                  }
               }
            }
            if((this.mShopItem.isSkin() || this.mShopItem.isBundle()) && !(InstanceMng.getCurrentScreen() is FSShopScreen))
            {
               this.mPurchaseButton.removeFromParent();
               this.mPurchaseButton.alpha = 0;
            }
            if(_loc2_ is ShopBoostDef && Boolean(this.mPurchaseButton))
            {
               if(!this.mShopItem.isBoostPurchaseable())
               {
                  this.mPurchaseButton.setEnabled(false);
               }
            }
         }
      }
      
      private function onPurchasex10ButtonTriggered() : void
      {
         this.startPurchase(true);
      }
      
      private function onPurchaseButtonTriggered() : void
      {
         this.startPurchase();
      }
      
      private function startPurchase(param1:Boolean = false) : void
      {
         var _loc2_:Boolean = this.mShopItem.isOffer() && !this.mShopItem.isOfferExpired() || !this.mShopItem.isOffer();
         if(!_loc2_)
         {
            Utils.setLogText(TextManager.getText("TID_SHOP_OFFER_EXPIRED2"),true);
            closePopup();
            return;
         }
         if(!InstanceMng.getServerConnection().isUserLoggedIn())
         {
            Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true);
            return;
         }
         if(InstanceMng.getCurrentScreen() is FSShopScreen && !this.mShopItem.isPack())
         {
            closePopup();
         }
         this.mPurchaseButton.setEnabled(false);
         if(this.mPurchaseButtonx10)
         {
            this.mPurchaseButtonx10.setEnabled(false);
         }
         this.mShopItem.setEnabled(false);
         mCloseButton.setEnabled(false);
         if(this.mShopItem.costsInGameCurrency())
         {
            this.mShopItem.beginInGameCurrencyPurchase(true,param1);
         }
         else
         {
            this.mShopItem.beginRealMoneyPurchase();
         }
      }
      
      protected function createPackRaritiesInfo() : void
      {
         var _loc1_:PackDef = null;
         var _loc2_:BundleDef = null;
         var _loc3_:Vector.<ShopItemSlotInfo> = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:FSCoordinate = null;
         var _loc7_:ShopItemSlotInfo = null;
         var _loc8_:Number = NaN;
         var _loc9_:int = 0;
         if(this.isPack() || this.isBundle())
         {
            _loc1_ = PackDef(this.getProductDef());
            _loc2_ = Boolean(this.mShopItem) && this.mShopItem.isBundle() ? BundleDef(this.mShopItem.getDef()) : null;
            if(this.mPackRaritiesContainer != null)
            {
               this.mPackRaritiesContainer.removeChildren();
               this.mPackRaritiesContainer.removeFromParent();
            }
            if(this.mPackRaritiesContainer == null)
            {
               this.mPackRaritiesContainer = new Component();
            }
            _loc3_ = this.isPack() ? InstanceMng.getPacksDefMng().fillPackInfoContainer(_loc1_) : InstanceMng.getPacksDefMng().fillBundleInfoContainer(_loc2_);
            _loc4_ = this.mSubtitleTextfield ? mBox.height * 0.95 - (this.mSubtitleTextfield.y + this.mSubtitleTextfield.height) : mBox.height * 0.95 - (this.mTitleTextfield.y + this.mTitleTextfield.height);
            _loc8_ = this.getShopItemSlotTextSizeFactor(_loc3_.length);
            if(Boolean(_loc3_) && _loc3_.length > 0)
            {
               _loc9_ = 0;
               while(_loc9_ < _loc3_.length)
               {
                  _loc7_ = _loc3_[_loc9_];
                  if(_loc7_)
                  {
                     _loc7_.resizeTextfieldWidth(_loc8_);
                     _loc5_ = _loc3_.length * _loc7_.width;
                     _loc6_ = Utils.getXYPositionInContainer(_loc9_,_loc7_.width,_loc7_.height,_loc5_,_loc4_,_loc3_.length,1,true);
                     _loc7_.x = _loc6_.mX;
                     _loc7_.y = _loc6_.mY;
                     this.mPackRaritiesContainer.addChild(_loc7_);
                  }
                  _loc9_++;
               }
            }
            this.mPackRaritiesContainer.x = this.mTitleTextfield.x - _loc5_ / 2;
            this.mPackRaritiesContainer.y = this.mSubtitleTextfield ? this.mSubtitleTextfield.y + this.mSubtitleTextfield.height / 1.75 : this.mTitleTextfield.y + this.mTitleTextfield.height / 1.75;
            addChild(this.mPackRaritiesContainer);
         }
      }
      
      private function getShopItemSlotTextSizeFactor(param1:int) : Number
      {
         var _loc2_:Number = 1.35;
         switch(param1)
         {
            case 1:
               _loc2_ = 3;
               break;
            case 2:
               _loc2_ = 2.25;
               break;
            case 3:
               _loc2_ = 2;
               break;
            case 4:
               _loc2_ = 1.5;
               break;
            case 5:
               _loc2_ = 1.35;
               break;
            default:
               _loc2_ = 1.25;
         }
         return _loc2_;
      }
      
      private function getContainerLayout() : HorizontalLayout
      {
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.horizontalAlign = HorizontalAlign.CENTER;
         _loc1_.paddingLeft = 20;
         return _loc1_;
      }
      
      override protected function removeFromStage() : void
      {
         var _loc1_:JobPanel = null;
         if(this.mTitleTextfield)
         {
            this.mTitleTextfield.removeFromParent(true);
            this.mTitleTextfield = null;
         }
         if(this.mSubtitleTextfield)
         {
            this.mSubtitleTextfield.removeFromParent(true);
            this.mSubtitleTextfield = null;
         }
         if(this.mDescriptionTextfield)
         {
            this.mDescriptionTextfield.removeFromParent(true);
            this.mDescriptionTextfield = null;
         }
         if(this.mInfoButton)
         {
            this.mInfoButton.removeFromParent(true);
            this.mInfoButton = null;
         }
         if(this.mItemImage)
         {
            this.mItemImage.removeFromParent();
            this.mItemImage.destroy();
            this.mItemImage = null;
         }
         if(this.mPackAnimation)
         {
            this.mPackAnimation.removeFromParent();
            this.mPackAnimation.destroy();
            this.mPackAnimation = null;
         }
         if(this.mCard)
         {
            this.mCard.removeFromParent();
            this.mCard.destroy();
            this.mCard = null;
         }
         if(this.mItemShadow)
         {
            this.mItemShadow.removeFromParent();
            this.mItemShadow.destroy();
            this.mItemShadow = null;
         }
         if(this.mPackRaritiesContainer)
         {
            this.mPackRaritiesContainer.removeFromParent(true);
            this.mPackRaritiesContainer = null;
         }
         if(this.mPurchaseButton)
         {
            this.mPurchaseButton.removeFromParent(true);
            this.mPurchaseButton = null;
         }
         if(this.mPurchaseButtonx10)
         {
            this.mPurchaseButtonx10.removeFromParent(true);
            this.mPurchaseButtonx10 = null;
         }
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         InstanceMng.getPopupMng().removePopup(FSPopupMng.SHOP_ITEM_POPUP_NAME);
         super.removeFromStage();
         if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            InstanceMng.getCurrentScreen().createTranslucentBG(true,0.8);
            _loc1_ = FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).getJobPanel();
            if(_loc1_)
            {
               InstanceMng.getCurrentScreen().addChildAt(InstanceMng.getCurrentScreen().getTouchableBG(),InstanceMng.getCurrentScreen().getChildIndex(_loc1_));
            }
         }
      }
      
      protected function createItemImage() : void
      {
         if(this.fulfilsCondition() && Boolean(mBox))
         {
            if(this.isPack() || this.isBundle())
            {
               this.createPackAnimation();
            }
            else if(this.isCard())
            {
               this.createCard();
            }
            else
            {
               this.createRawItemImage();
            }
         }
         this.createItemShadow();
      }
      
      protected function isPack() : Boolean
      {
         return Boolean(this.mShopItem) && this.mShopItem.isPack();
      }
      
      protected function isBundle() : Boolean
      {
         return Boolean(this.mShopItem) && this.mShopItem.isBundle();
      }
      
      protected function isCard() : Boolean
      {
         return Boolean(this.mShopItem) && (this.mShopItem.isCard() || this.mShopItem.isQuestCard() || this.mShopItem.isRaidsCard());
      }
      
      protected function getRawItemTexture() : Texture
      {
         return this.mShopItem ? this.mShopItem.getItemTexture() : null;
      }
      
      protected function getProductSku() : String
      {
         var _loc1_:String = null;
         if(this.mShopItem)
         {
            _loc1_ = this.isPack() || this.isBundle() ? this.mShopItem.getPackSku() : this.mShopItem.getCardDef().getSku();
         }
         return _loc1_;
      }
      
      private function createRawItemImage() : void
      {
         var _loc1_:Texture = this.getRawItemTexture();
         if(_loc1_)
         {
            if(this.mItemImage == null)
            {
               this.mItemImage = new FSImage(_loc1_);
            }
            else
            {
               this.mItemImage.texture = _loc1_;
            }
         }
         if(this.mItemImage)
         {
            this.mItemImage.alignPivot();
            this.mItemImage.x = mBox.x + mBox.width / 2;
            this.mItemImage.y = 0;
            addChild(this.mItemImage);
            this.mItemImage.visible = false;
         }
      }
      
      private function createPackAnimation() : void
      {
         var _loc1_:String = this.getProductSku();
         var _loc2_:PackDef = PackDef(InstanceMng.getPacksDefMng().getDefBySku(_loc1_));
         if(_loc1_)
         {
            if(this.mPackAnimation == null)
            {
               this.mPackAnimation = new PackAnimation(_loc2_.getAnimBG());
               this.mPackAnimation.alignPivot();
               this.mPackAnimation.x = mBox.x + mBox.width / 2;
               this.mPackAnimation.y = 0;
               addChild(this.mPackAnimation);
            }
            else
            {
               addChild(this.mPackAnimation);
            }
            this.mPackAnimation.visible = false;
         }
      }
      
      private function createCard() : void
      {
         var _loc2_:FSCard = null;
         var _loc1_:String = this.getProductSku();
         if(this.mCard == null)
         {
            _loc2_ = _loc1_ != "" ? InstanceMng.getCardsMng().createCard(_loc1_) : null;
            if(_loc2_)
            {
               this.mCard = InstanceMng.getResourcesMng().createShopInfoCard(_loc2_,1,false,false,true);
               this.mCard.alignPivot();
            }
         }
         if(this.mCard)
         {
            this.mCard.x = mBox.x + mBox.width / 2;
            this.mCard.y = 0;
            addChild(this.mCard);
            this.mCard.visible = false;
         }
      }
      
      private function getMainImage() : *
      {
         var _loc1_:* = undefined;
         if(this.mItemImage)
         {
            return this.mItemImage;
         }
         if(this.mPackAnimation)
         {
            return this.mPackAnimation;
         }
         if(this.mCard)
         {
            return this.mCard;
         }
         return null;
      }
      
      private function createItemShadow() : void
      {
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc1_:* = this.getMainImage();
         if(Boolean(_loc1_) && this.fulfilsCondition())
         {
            if(this.mItemShadow == null)
            {
               this.mItemShadow = new FSImage(Root.assets.getTexture("shop_item_shadow"));
               this.mItemShadow.alignPivot();
               this.mItemShadow.visible = false;
               _loc3_ = this.isCard() ? 1.25 : 2;
               this.mItemShadow.x = _loc1_.x;
               this.mItemShadow.y = _loc1_.y + _loc1_.height / _loc3_;
            }
            _loc2_ = getChildIndex(_loc1_) - 1 >= 0 ? int(getChildIndex(_loc1_) - 1) : 0;
            addChildAt(this.mItemShadow,_loc2_);
         }
      }
      
      private function createTitle() : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:Def = this.getProductDef();
         if(this.mTitleTextfield == null)
         {
            _loc3_ = mBox ? int(mBox.width * 0.95) : int(width);
            _loc4_ = mBox ? int(mBox.height * 0.15) : int(height * 0.15);
            this.mTitleTextfield = new FSTextfield(_loc3_,_loc4_,"",16777215,FSResourceMng.FONT_STD_TITLE_SIZE);
            this.mTitleTextfield.alignPivot();
            this.mTitleTextfield.x = mBox ? mBox.width / 2 : width / 2;
            this.mTitleTextfield.y = this.mItemShadow ? this.mItemShadow.y + this.mTitleTextfield.height / 2 : 0;
         }
         if(this.mTitleTextfield)
         {
            addChild(this.mTitleTextfield);
         }
         var _loc2_:String = "";
         if(this.isCard())
         {
            _loc2_ = _loc1_ ? _loc1_.getName() : "";
            _loc4_ = mBox ? int(mBox.height * 0.25) : int(height * 0.25);
            this.mTitleTextfield.height = _loc4_;
            this.mTitleTextfield.y = this.mItemShadow ? this.mItemShadow.y + this.mTitleTextfield.height / 2 : 0;
            this.mTitleTextfield.alignPivot();
         }
         else if(Boolean(this.mShopItem) && this.mShopItem.isBundle())
         {
            _loc2_ = this.mShopItem ? BundleDef(this.mShopItem.getDef()).getName() : "";
         }
         else
         {
            _loc2_ = Boolean(_loc1_) && Boolean(_loc1_.getName()) ? _loc1_.getName().toUpperCase() : this.onNoDefFoundGetTitle();
         }
         if(this.mTitleTextfield)
         {
            this.mTitleTextfield.text = _loc2_;
         }
      }
      
      protected function onNoDefFoundGetTitle() : String
      {
         return "";
      }
      
      protected function getProductDef() : Def
      {
         var _loc1_:Def = null;
         if(this.mShopItem)
         {
            _loc1_ = this.isCard() ? this.mShopItem.getCardDef() : this.mShopItem.getPackDef();
         }
         return _loc1_;
      }
      
      protected function getSubtitleText() : String
      {
         var _loc2_:RarityDef = null;
         var _loc3_:int = 0;
         var _loc4_:CardDef = null;
         var _loc1_:String = this.mShopItem ? this.mShopItem.getSubtitleText(true) : "";
         if(_loc1_ == "" && this.isCard() || Boolean(this.mShopItem) && Boolean(this.mShopItem.isSkin()))
         {
            if(Boolean(this.mShopItem) && this.mShopItem.isSkin())
            {
               _loc3_ = this.mShopItem.getItemRarity();
               _loc2_ = RarityDef(InstanceMng.getRaritiesDefMng().getRarityDefByIndex(_loc3_));
            }
            else
            {
               _loc4_ = CardDef(this.getProductDef());
               if(_loc4_)
               {
                  _loc2_ = RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(_loc4_.getCardRarity()));
               }
            }
            if(_loc2_)
            {
               _loc1_ = _loc2_.getName();
            }
         }
         return _loc1_;
      }
      
      protected function getSubtitleColor() : uint
      {
         var _loc2_:RarityDef = null;
         var _loc3_:int = 0;
         var _loc4_:CardDef = null;
         var _loc1_:uint = this.mShopItem ? this.mShopItem.getSubtitleFontColor() : 16777215;
         if(this.isCard() || Boolean(this.mShopItem) && Boolean(this.mShopItem.isSkin()))
         {
            if(Boolean(this.mShopItem) && this.mShopItem.isSkin())
            {
               _loc3_ = this.mShopItem.getItemRarity();
               _loc2_ = RarityDef(InstanceMng.getRaritiesDefMng().getRarityDefByIndex(_loc3_));
            }
            else
            {
               _loc4_ = CardDef(this.getProductDef());
               if(_loc4_)
               {
                  _loc2_ = RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(_loc4_.getCardRarity()));
               }
            }
            if(_loc2_)
            {
               _loc1_ = InstanceMng.getRaritiesDefMng().getRarityColor(_loc2_.getIndex());
            }
         }
         return _loc1_;
      }
      
      private function createSubtitle() : void
      {
         var _loc1_:String = this.getSubtitleText();
         var _loc2_:uint = this.getSubtitleColor();
         if(_loc1_ != "")
         {
            if(this.mSubtitleTextfield == null)
            {
               this.mSubtitleTextfield = new FSTextfield(this.mTitleTextfield.width,this.mTitleTextfield.height * 0.8,_loc1_,_loc2_,FSResourceMng.FONT_STD_SUBTITLE_SIZE);
               this.mSubtitleTextfield.alignPivot();
               this.mSubtitleTextfield.x = this.mTitleTextfield.x;
               this.mSubtitleTextfield.y = this.mTitleTextfield.y + this.mTitleTextfield.height / 2 + this.mSubtitleTextfield.height / 4;
            }
            addChild(this.mSubtitleTextfield);
         }
      }
      
      protected function getDescriptionText() : String
      {
         return Boolean(this.mShopItem) && Boolean(this.mShopItem.getDef()) ? this.mShopItem.getDef().getDesc() : "";
      }
      
      protected function createDescription() : void
      {
         var _loc1_:String = null;
         var _loc2_:Number = NaN;
         if(Boolean(this.mShopItem) && (this.mShopItem.isBooster() || this.mShopItem.isTokensBag() || this.mShopItem.isSkin()))
         {
            _loc1_ = this.getDescriptionText();
            if(_loc1_ != "")
            {
               if(this.mDescriptionTextfield == null)
               {
                  _loc2_ = this.mSubtitleTextfield ? mBox.height - (this.mSubtitleTextfield.y + this.mSubtitleTextfield.height) - this.mPurchaseButton.height / 2 : mBox.height - (this.mTitleTextfield.y + this.mTitleTextfield.height) - this.mPurchaseButton.height / 2;
                  this.mDescriptionTextfield = new FSTextfield(this.mTitleTextfield.width,_loc2_,_loc1_);
                  this.mDescriptionTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_DESC);
                  this.mDescriptionTextfield.alignPivot();
                  this.mDescriptionTextfield.x = this.mTitleTextfield.x;
                  this.mDescriptionTextfield.y = this.mSubtitleTextfield ? this.mSubtitleTextfield.y + this.mSubtitleTextfield.height / 2 + this.mDescriptionTextfield.height / 2 : this.mTitleTextfield.y + this.mTitleTextfield.height / 2 + this.mDescriptionTextfield.height / 2;
               }
               addChild(this.mDescriptionTextfield);
            }
         }
      }
      
      override protected function onPopupOpenTransitionOver() : void
      {
         super.onPopupOpenTransitionOver();
         var _loc1_:* = this.getMainImage();
         this.createItemIntro(_loc1_,this.onZoomCompleteCreateYoYoTransition);
         this.createItemIntro(this.mItemShadow,this.onZoomCompleteCreateYoYoZoomTransition);
      }
      
      private function createItemIntro(param1:*, param2:Function) : void
      {
         if(param1)
         {
            param1.scale = 0;
            param1.visible = true;
            SpecialFX.createZoomTransition(param1,1,0.5,param2,[param1],Back.easeOut);
         }
      }
      
      private function onZoomCompleteCreateYoYoTransition(param1:*) : void
      {
         var _loc2_:FSCoordinate = null;
         if(param1)
         {
            _loc2_ = new FSCoordinate(param1.x,param1.y + param1.height / 10);
            SpecialFX.createYoYoTransition(param1,_loc2_,2,-1,null,Quad.easeInOut);
         }
      }
      
      private function onZoomCompleteCreateYoYoZoomTransition(param1:*) : void
      {
         var _loc2_:FSCoordinate = null;
         if(param1)
         {
            _loc2_ = new FSCoordinate(param1.x,param1.y + param1.height / 10);
            SpecialFX.createYoYoZoomTransition(param1,0.7,2,-1,null,null,false,Quad.easeInOut);
         }
      }
      
      override protected function performOpeningTransition(param1:FSCoordinate = null) : void
      {
         var _loc3_:Number = NaN;
         var _loc2_:* = this.getMainImage();
         if(_loc2_)
         {
            _loc3_ = _loc2_.height / 3;
            y += _loc3_;
         }
         super.performOpeningTransition(param1);
      }
      
      public function disablePurchaseButtonTemporarily(param1:int = 2) : void
      {
         if(this.mPurchaseButton)
         {
            this.enablePurchaseButton(false);
            setTimeout(this.enablePurchaseButton,param1 * 1000,true);
            Utils.setLogText(TextManager.getText("TID_GEN_WAIT") + " (" + param1 + " " + TextManager.getText("TID_GEN_TIME_SECONDS_ABR") + ")");
         }
      }
      
      public function enablePurchaseButton(param1:Boolean) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         if(this.mShopItem)
         {
            _loc2_ = this.mShopItem.isBooster() && this.mShopItem.isBoostPurchaseable() || !this.mShopItem.isBooster();
            _loc3_ = Screen.smOpeningPack;
            _loc4_ = isClosing();
            if(this.mPurchaseButton)
            {
               this.mPurchaseButton.setEnabled(!_loc4_ && !_loc3_ && param1 && _loc2_);
            }
            if(this.mPurchaseButtonx10)
            {
               this.mPurchaseButtonx10.setEnabled(!_loc4_ && !_loc3_ && param1 && _loc2_);
            }
         }
      }
      
      public function getPackAnimation() : PackAnimation
      {
         return this.mPackAnimation;
      }
      
      public function onPurchaseSuccesful() : void
      {
         this.unlockAfterPurchase();
         closePopup(this.performOpsOnSuccesfulPurchase);
      }
      
      private function performOpsOnSuccesfulPurchase() : void
      {
         if(this.mShopItem)
         {
            this.mShopItem.performOnBoughtOperations();
         }
      }
      
      public function onPurchaseFailed() : void
      {
         this.unlockAfterPurchase();
      }
      
      public function unlockAfterPurchase() : void
      {
         this.lockPopup(false);
         InstanceMng.getCurrentScreen().showLoadingIcon(false,false);
      }
      
      protected function lockPopup(param1:Boolean) : void
      {
         if(hasCloseButton())
         {
            enableCloseButton(!param1);
         }
         if(hasAcceptButton())
         {
            enableAcceptButton(!param1);
         }
      }
      
      private function allowedToShowPurchaseButton() : Boolean
      {
         return Boolean(this.mShopItem) && (!this.mShopItem.isSkin() || this.mShopItem.isSkin() && InstanceMng.getCurrentScreen() is FSShopScreen);
      }
      
      public function getProductId() : String
      {
         return this.mShopItem ? this.mShopItem.getProdId() : "";
      }
   }
}

