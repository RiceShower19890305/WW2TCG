package com.fs.tcgengine.view.components.shop
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.controller.rules.PacksDefMng;
   import com.fs.tcgengine.model.boosts.Boost;
   import com.fs.tcgengine.model.rules.AuctionTicketDef;
   import com.fs.tcgengine.model.rules.BoostDef;
   import com.fs.tcgengine.model.rules.BundleDef;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.EditionDef;
   import com.fs.tcgengine.model.rules.FactionDef;
   import com.fs.tcgengine.model.rules.GoldDef;
   import com.fs.tcgengine.model.rules.HeroCharacterDef;
   import com.fs.tcgengine.model.rules.PackDef;
   import com.fs.tcgengine.model.rules.QuestShopDef;
   import com.fs.tcgengine.model.rules.RaidShopDef;
   import com.fs.tcgengine.model.rules.RarityDef;
   import com.fs.tcgengine.model.rules.ShopBoostDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSShopScreen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.TimerUtil;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.anims.misc.PackAnimation;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.CustomComponent;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.misc.FSSkinBoughtAnimation;
   import com.greensock.TweenMax;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import starling.core.Starling;
   import starling.display.Quad;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.textures.Texture;
   import starling.utils.Align;
   
   public class FSShopItem extends Component
   {
      
      public static const SHOP_ITEM_TYPE_PACK:int = 1;
      
      public static const SHOP_ITEM_TYPE_CARD:int = 0;
      
      public static const SHOP_ITEM_TYPE_RAID_COINS:int = 2;
      
      public static const BUY_BUTTON_GOLD_NAME:String = "buy_gold_button";
      
      public static const BUY_BUTTON_TOKENS_NAME:String = "buy_tokens_button";
      
      public static const HOURLY_OFFER:int = 0;
      
      public static const WEEKLY_OFFER:int = 1;
      
      protected var mBG:CustomComponent;
      
      private var mTitleTextfield:FSTextfield;
      
      protected var mSubtitleTextfield:FSTextfield;
      
      protected var mPriceTextfield:FSTextfield;
      
      private var mPriceCurrencyIcon:FSImage;
      
      private var mItemImage:FSImage;
      
      private var mItemShadow:FSImage;
      
      private var mPackImage:PackAnimation;
      
      private var mItemRarityQuad:Quad;
      
      private var mItemFactionFrameLeft:FSImage;
      
      private var mItemFactionFrameRight:FSImage;
      
      private var mItemRarityFrame:FSImage;
      
      protected var mDef:Def;
      
      protected var mValidPriceReceivedFromAppstore:Boolean;
      
      private var mCardsRewarded:Dictionary;
      
      private var mSkinBoughtAnimation:FSSkinBoughtAnimation;
      
      private var mIsOffer:Boolean;
      
      private var mOfferInfo:Object;
      
      private var mOfferType:int;
      
      private var mOfferExpirationTimeLeft:Number;
      
      private var mOfferExpirationTime:Number;
      
      private var mOfferExpired:Boolean = false;
      
      private var mHoverHelperPoint:Point;
      
      private var mIsHovered:Boolean;
      
      private var mIsMouseHeldDown:Boolean;
      
      private var mOnlyLogic:Boolean;
      
      private var mDiscountLabel:FSButton;
      
      private var mBundleSubOffers:Vector.<FSBundleSubOffer>;
      
      public function FSShopItem(param1:Def, param2:Boolean = false, param3:Object = null, param4:Boolean = false)
      {
         var _loc5_:Number = NaN;
         super();
         this.mDef = param1;
         this.mIsOffer = param2;
         this.mOnlyLogic = param4;
         if(this.mIsOffer)
         {
            this.mOfferInfo = param3;
            this.mOfferType = this.calculateOfferType(param3);
            if(this.isBundle())
            {
               if(BundleDef(this.mDef).isManualOffer())
               {
                  this.mOfferExpirationTime = BundleDef(this.mDef).getExpirationTimeMS();
               }
               else
               {
                  _loc5_ = InstanceMng.getUserDataMng().getOwnerUserData().getCustomOfferShownExpirationDate();
                  this.mOfferExpirationTime = _loc5_;
               }
            }
            else
            {
               this.mOfferExpirationTime = param3 ? Number(param3.expirationTimeMS) : 0;
            }
            addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
         this.createUI();
         Utils.alignComponentAndFixPosition(this);
      }
      
      protected function createUI() : void
      {
         if(!this.mOnlyLogic)
         {
            this.createBG();
            this.createExtraInfo();
            this.createTitle();
            this.createSubtitle();
            this.createPrice();
            this.createDiscount();
         }
         this.refreshPrice();
         if(!this.mOnlyLogic)
         {
            this.createImage();
            this.createItemShadow();
            addEventListener(TouchEvent.TOUCH,this.onTouch);
         }
      }
      
      private function createDiscount() : void
      {
         var _loc1_:String = null;
         if(this.isBundle() && this.mDiscountLabel == null)
         {
            _loc1_ = "";
            this.mDiscountLabel = new FSButton(Root.assets.getTexture("shop_offer_discount"),"-" + BundleDef(this.mDef).getDiscount() + "%");
            this.mDiscountLabel.fontSize = FSResourceMng.FONT_STD_DEFAULT_SIZE;
            this.mDiscountLabel.scaleWhenDown = 1;
            this.mDiscountLabel.enableScaleOnMouseOver(false);
            this.mDiscountLabel.alignPivot();
            this.mDiscountLabel.x = this.mBG.x + this.mBG.width / 2 - this.mDiscountLabel.width * 0.8;
            this.mDiscountLabel.y = this.mBG.y - this.mBG.height / 2 + this.mDiscountLabel.height / 2;
            addChild(this.mDiscountLabel);
         }
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         var _loc3_:Touch = null;
         if(param1)
         {
            _loc2_ = param1.getTouch(this);
            _loc3_ = param1.getTouch(this,TouchPhase.HOVER);
            if(Utils.isDesktop() || Utils.isBrowser())
            {
               scale = _loc2_ ? 1.025 : 1;
            }
            if(this.mBG)
            {
               this.mBG.alpha = _loc3_ ? 1 : 0.8;
            }
            if(param1.getTouch(this,TouchPhase.BEGAN))
            {
               this.mIsMouseHeldDown = true;
            }
            else if(param1.getTouch(this,TouchPhase.ENDED))
            {
               this.onMouseUp();
               this.mIsMouseHeldDown = false;
            }
            else if(Boolean(_loc2_) && _loc2_.phase != TouchPhase.HOVER)
            {
               if(this.mHoverHelperPoint == null)
               {
                  this.mHoverHelperPoint = new Point();
               }
               this.mHoverHelperPoint.x = _loc2_.globalX;
               this.mHoverHelperPoint.y = _loc2_.globalY;
               this.globalToLocal(this.mHoverHelperPoint,this.mHoverHelperPoint);
               this.mIsMouseHeldDown = this.hitTest(this.mHoverHelperPoint) != null;
            }
         }
      }
      
      private function onMouseUp() : void
      {
         var _loc1_:Boolean = false;
         if(!this.mIsMouseHeldDown || FSShopScreen(InstanceMng.getCurrentScreen()).isItemsScrollContainerScrolling())
         {
            return;
         }
         if(!InstanceMng.getUserDataMng().getOwnerUserData().isInBlackList())
         {
            if(!InstanceMng.getUserDataMng().getOwnerUserData().isInDuplicatedList())
            {
               _loc1_ = this.mIsOffer && !this.mOfferExpired || !this.mIsOffer;
               if(_loc1_)
               {
                  if(!this.isGoldBag() && !this.isTokensBag())
                  {
                     InstanceMng.getPopupMng().openShopItemPopup(this);
                  }
                  else
                  {
                     this.beginRealMoneyPurchase();
                  }
               }
               else
               {
                  Utils.setLogText(TextManager.getText("TID_SHOP_OFFER_EXPIRED2"),true);
               }
            }
            else
            {
               Utils.setLogText(TextManager.getText("TID_MIGRATION_ERROR_MIGRATED"),true,false,false);
               this.setEnabled(true);
            }
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_GEN_FRAUD_PURCHASE"),true,false,false);
            this.setEnabled(true);
         }
      }
      
      public function beginRealMoneyPurchase() : void
      {
         if(this.isProductValidForPurchase() && Boolean(this.mDef))
         {
            if(InstanceMng.getCurrentScreen() is FSShopScreen)
            {
               FSShopScreen(InstanceMng.getCurrentScreen()).beginPurchase(this);
            }
            else
            {
               FSDebug.debugTrace("Buy product: " + this.mDef.getProdId());
               InstanceMng.getApplication().buyProduct(this.mDef.getProdId(),this.mDef.getSku());
            }
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_SHOP_NOVERIFIED"),true);
         }
      }
      
      public function setEnabled(param1:Boolean) : void
      {
         var _loc2_:Boolean = this.isBooster() && this.isBoostPurchaseable() || !this.isBooster();
         touchable = param1 && _loc2_;
         alpha = touchable ? 1 : 0.5;
      }
      
      private function createBG() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         if(this.mBG == null)
         {
            if(this.isBundle())
            {
               if(BundleDef(this.mDef).getItemsList().length > 2)
               {
                  this.mBG = Utils.createCustomBox("shop_slot_xlarge",1549);
               }
               else
               {
                  this.mBG = Utils.createCustomBox("shop_slot_large",992);
               }
            }
            else if(this.isCard() || this.isQuestCard() || this.isRaidsCard())
            {
               _loc2_ = Config.getConfig().getCardBGType() == "jpg";
               _loc3_ = _loc2_ ? 380 : 446;
               this.mBG = Utils.createCustomBox("shop_slot",_loc3_);
            }
            else
            {
               this.mBG = Utils.createCustomBox("shop_slot",446);
            }
            this.mBG.alpha = 0.8;
            _loc1_ = !this.isBundle() || this.isBundle() && BundleDef(this.mDef).getItemsList().length < 3;
            if(_loc1_ && (Utils.isMobile() && !Utils.isTablet() || !Utils.isMobile() && this.isSkin()))
            {
               this.mBG.scale = 1.5;
            }
            this.mBG.alignPivot();
            this.mBG.x = this.mBG.width / 2;
            this.mBG.y = this.mBG.height / 2;
            addChild(this.mBG);
         }
         this.createRarityQuad();
      }
      
      public function isBundle() : Boolean
      {
         return this.mDef is BundleDef;
      }
      
      private function createRarityQuad() : void
      {
         var _loc1_:int = 0;
         var _loc2_:RarityDef = null;
         var _loc3_:Array = null;
         if(this.isSkin() || this.isCard() || this.isQuestCard())
         {
            _loc1_ = this.getItemRarity();
            _loc2_ = RarityDef(InstanceMng.getRaritiesDefMng().getRarityDefByIndex(_loc1_));
            if(_loc1_ >= 3)
            {
               if(this.mItemRarityQuad == null)
               {
                  this.mItemRarityQuad = new Quad(this.mBG.width * 0.905,this.mBG.height * 0.92,0);
                  this.mItemRarityQuad.alignPivot();
                  this.mItemRarityQuad.x = this.mBG.x;
                  this.mItemRarityQuad.y = this.mBG.y;
                  this.mItemRarityQuad.alpha = 0.3;
                  if(!this.isQuestCard())
                  {
                     SpecialFX.createYoYoAlphaTransition(this.mItemRarityQuad,1,2.75);
                  }
                  _loc3_ = _loc2_.getSkinBGColors();
                  this.mItemRarityQuad.setVertexColor(0,_loc3_[0]);
                  this.mItemRarityQuad.setVertexColor(1,_loc3_[1]);
                  this.mItemRarityQuad.setVertexColor(2,_loc3_[2]);
                  this.mItemRarityQuad.setVertexColor(3,_loc3_[2]);
                  if(!this.isSkin())
                  {
                     this.mItemRarityQuad.alpha = 1;
                     this.mItemRarityQuad.setVertexAlpha(0,0.5);
                     this.mItemRarityQuad.setVertexAlpha(1,0.5);
                     this.mItemRarityQuad.setVertexAlpha(2,0);
                     this.mItemRarityQuad.setVertexAlpha(3,0);
                  }
                  addChildAt(this.mItemRarityQuad,getChildIndex(this.mBG) + 1);
               }
            }
         }
      }
      
      private function createTitle() : void
      {
         var _loc1_:String = "";
         var _loc2_:CardDef = this.getCardDef();
         if(this.mDef is QuestShopDef)
         {
            _loc1_ = _loc2_ ? "" : this.mDef.getName();
         }
         else if(this.mDef is RaidShopDef)
         {
            _loc1_ = _loc2_ ? _loc2_.getName() : this.getPackDef().getName();
            _loc1_ = Boolean(_loc2_) && _loc2_.isCraftMaterial() ? "" : _loc1_;
         }
         else
         {
            _loc1_ = this.mDef ? this.mDef.getName() : "";
         }
         if(this.mTitleTextfield == null)
         {
            this.mTitleTextfield = new FSTextfield(this.mBG.width * 0.88,this.mBG.height / 7,_loc1_);
            this.mTitleTextfield.alignPivot();
            this.mTitleTextfield.x = this.mBG.x;
            this.mTitleTextfield.y = this.mBG.y - this.mBG.height / 2 + this.mTitleTextfield.height;
            addChild(this.mTitleTextfield);
         }
      }
      
      private function createSubtitle() : void
      {
         var _loc2_:Number = NaN;
         var _loc1_:String = this.getSubtitleText();
         if(_loc1_ != "")
         {
            if(this.mSubtitleTextfield == null)
            {
               _loc2_ = FSResourceMng.FONT_STD_DEFAULT_SIZE;
               this.mSubtitleTextfield = new FSTextfield(this.mTitleTextfield.width,this.mTitleTextfield.height * 0.75,_loc1_,16777215,_loc2_);
               this.mSubtitleTextfield.alignPivot();
               this.mSubtitleTextfield.x = this.mTitleTextfield.x;
               this.mSubtitleTextfield.y = this.mTitleTextfield.y + this.mTitleTextfield.height / 2 + this.mSubtitleTextfield.height / 3;
               addChild(this.mSubtitleTextfield);
            }
            this.mSubtitleTextfield.color = this.getSubtitleFontColor();
         }
      }
      
      private function createPrice() : void
      {
         if(this.mPriceTextfield == null)
         {
            this.mPriceTextfield = new FSTextfield(this.mBG.width * 0.6,this.mTitleTextfield.height,"");
            this.mPriceTextfield.alignPivot();
            this.mPriceTextfield.x = this.mTitleTextfield.x;
            this.mPriceTextfield.y = this.mBG.y + this.mBG.height / 2 - this.mPriceTextfield.height;
            addChild(this.mPriceTextfield);
         }
         this.refreshPrice();
      }
      
      public function costsInGameCurrency() : Boolean
      {
         return this.mDef is PackDef && PackDef(this.mDef).costsGold() || this.mDef is HeroCharacterDef && HeroCharacterDef(this.mDef).getCostsGold() || this.mDef is RaidShopDef && RaidShopDef(this.mDef).getCost() || this.mDef is QuestShopDef && Boolean(QuestShopDef(this.mDef).getCost()) || this.isOffer() && this.getOfferGoldCost() > 0;
      }
      
      public function getInGameCurrencyCost() : int
      {
         var _loc1_:int = 0;
         if(this.mDef is PackDef)
         {
            if(PackDef(this.mDef).costsGold())
            {
               _loc1_ = PackDef(this.mDef).getGold();
            }
         }
         else if(this.mDef is HeroCharacterDef)
         {
            if(HeroCharacterDef(this.mDef).getCostsGold())
            {
               _loc1_ = HeroCharacterDef(this.mDef).getGold();
            }
         }
         else if(this.mDef is RaidShopDef)
         {
            _loc1_ = RaidShopDef(this.mDef).getCost();
         }
         else if(this.mDef is QuestShopDef)
         {
            _loc1_ = QuestShopDef(this.mDef).getCost();
         }
         if(this.mIsOffer && this.getOfferGoldCost() > 0)
         {
            _loc1_ = this.getOfferGoldCost();
         }
         return _loc1_;
      }
      
      private function getInGameCurrencyType() : String
      {
         var _loc1_:String = "";
         if(this.mDef is PackDef)
         {
            if(PackDef(this.mDef).costsGold())
            {
               _loc1_ = ServerConnection.CURRENCY_GOLD;
            }
         }
         else if(this.mDef is HeroCharacterDef)
         {
            if(HeroCharacterDef(this.mDef).getCostsGold())
            {
               _loc1_ = ServerConnection.CURRENCY_GOLD;
            }
         }
         else if(this.mDef is RaidShopDef)
         {
            _loc1_ = ServerConnection.CURRENCY_RAID_COINS;
         }
         else if(this.mDef is QuestShopDef)
         {
            _loc1_ = ServerConnection.CURRENCY_QUEST_COINS;
         }
         if(this.mIsOffer && this.getOfferGoldCost() > 0)
         {
            _loc1_ = ServerConnection.CURRENCY_GOLD;
         }
         return _loc1_;
      }
      
      public function refreshPrice() : void
      {
         var _loc4_:String = null;
         var _loc5_:Boolean = false;
         var _loc6_:UserData = null;
         var _loc7_:Boolean = false;
         var _loc1_:Boolean = false;
         var _loc2_:String = "";
         var _loc3_:int = 0;
         if(this.mDef is PackDef)
         {
            if(PackDef(this.mDef).costsGold())
            {
               _loc3_ = PackDef(this.mDef).getGold();
               _loc1_ = true;
               _loc2_ = ServerConnection.CURRENCY_GOLD;
            }
         }
         else if(this.mDef is HeroCharacterDef)
         {
            if(HeroCharacterDef(this.mDef).getCostsGold())
            {
               _loc3_ = HeroCharacterDef(this.mDef).getGold();
               _loc1_ = true;
               _loc2_ = ServerConnection.CURRENCY_GOLD;
            }
         }
         else if(this.mDef is RaidShopDef)
         {
            _loc3_ = RaidShopDef(this.mDef).getCost();
            _loc1_ = true;
            _loc2_ = ServerConnection.CURRENCY_RAID_COINS;
         }
         else if(this.mDef is QuestShopDef)
         {
            _loc3_ = QuestShopDef(this.mDef).getCost();
            _loc1_ = true;
            _loc2_ = ServerConnection.CURRENCY_QUEST_COINS;
         }
         if(this.mIsOffer && this.getOfferGoldCost() > 0)
         {
            _loc3_ = this.getOfferGoldCost();
            _loc1_ = true;
            _loc2_ = ServerConnection.CURRENCY_GOLD;
         }
         if(!_loc1_)
         {
            _loc4_ = InstanceMng.getApplication().getInAppsManager().getPriceOfProd(this);
            _loc5_ = _loc4_ != null && _loc4_ != "" && _loc4_ != "N.A.";
            this.setProductValidForPurchase(_loc5_);
            _loc4_ = _loc5_ ? _loc4_ : "N.A.";
         }
         else
         {
            this.setProductValidForPurchase(true);
         }
         if(this.mPriceTextfield)
         {
            this.mPriceTextfield.text = _loc3_.toString();
            if(!_loc1_)
            {
               this.mPriceTextfield.text = _loc4_;
            }
            else
            {
               _loc6_ = Utils.getOwnerUserData();
               _loc7_ = _loc6_ ? _loc6_.hasEnoughCurrency(_loc2_,_loc3_) : false;
               this.mPriceTextfield.color = !_loc7_ ? 16711680 : 16777215;
               this.createCurrencyIcon();
            }
         }
      }
      
      public function refreshPriceColor() : void
      {
         var _loc1_:String = this.getInGameCurrencyType();
         var _loc2_:Number = this.getInGameCurrencyCost();
         var _loc3_:UserData = Utils.getOwnerUserData();
         var _loc4_:Boolean = _loc3_ ? _loc3_.hasEnoughCurrency(_loc1_,_loc2_) : false;
         if(this.mPriceTextfield)
         {
            this.mPriceTextfield.color = !_loc4_ ? 16711680 : 16777215;
         }
      }
      
      private function createCurrencyIcon() : void
      {
         var _loc1_:String = "";
         if(this.mDef is PackDef)
         {
            if(PackDef(this.mDef).costsGold())
            {
               _loc1_ = "gold_icon";
            }
         }
         else if(this.mDef is HeroCharacterDef)
         {
            if(HeroCharacterDef(this.mDef).getCostsGold())
            {
               _loc1_ = "gold_icon";
            }
         }
         else if(this.mDef is RaidShopDef)
         {
            _loc1_ = "raid_coin_icon";
         }
         else if(this.mDef is QuestShopDef)
         {
            _loc1_ = "gem_quest_icon";
         }
         if(this.mIsOffer)
         {
            _loc1_ = this.getOfferGoldCost() > 0 ? "gold_icon" : "";
         }
         if(_loc1_ != "")
         {
            if(this.mPriceTextfield)
            {
               this.mPriceTextfield.width = this.mTitleTextfield.width / 2;
               this.mPriceTextfield.alignPivot();
               this.mPriceTextfield.x = this.mTitleTextfield.x - this.mPriceTextfield.width / 2;
               this.mPriceTextfield.format.horizontalAlign = Align.RIGHT;
            }
            if(this.mPriceCurrencyIcon == null)
            {
               this.mPriceCurrencyIcon = new FSImage(Root.assets.getTexture(_loc1_));
               this.mPriceCurrencyIcon.alignPivot();
               this.mPriceCurrencyIcon.scale = 0.75;
               this.mPriceCurrencyIcon.x = this.mPriceTextfield.x + this.mPriceTextfield.width / 2 + this.mPriceCurrencyIcon.width / 2;
               this.mPriceCurrencyIcon.y = this.mPriceTextfield.y;
               addChild(this.mPriceCurrencyIcon);
            }
            else
            {
               this.mPriceCurrencyIcon.texture = Root.assets.getTexture(_loc1_);
            }
         }
         else
         {
            if(this.mPriceCurrencyIcon)
            {
               this.mPriceCurrencyIcon.removeFromParent();
            }
            if(this.mPriceTextfield)
            {
               this.mPriceTextfield.width = this.mTitleTextfield.width;
               this.mPriceTextfield.alignPivot();
               this.mPriceTextfield.x = this.mTitleTextfield.x;
               this.mPriceTextfield.format.horizontalAlign = Align.CENTER;
            }
         }
      }
      
      public function getOfferGoldCost() : Number
      {
         return Boolean(this.mIsOffer) && Boolean(this.mOfferInfo) && Boolean(this.mOfferInfo["gold"]) ? Number(this.mOfferInfo["gold"]) : 0;
      }
      
      private function createImage() : void
      {
         var _loc1_:String = null;
         var _loc2_:Number = NaN;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:CardDef = null;
         var _loc6_:String = null;
         var _loc7_:PackDef = null;
         var _loc8_:Array = null;
         var _loc9_:FSBundleSubOffer = null;
         var _loc10_:int = 0;
         if(this.mDef)
         {
            if(!this.isBundle())
            {
               _loc2_ = 1;
               _loc3_ = Utils.isDesktop() && Config.getConfig().getCardBGType() == "png";
               if(this.isSkin())
               {
                  _loc1_ = this.mDef.getBGImageName();
                  _loc2_ = Boolean(this.mBG) && Config.getConfig().battleHasSimpleUI() ? this.mBG.scale * 0.6 : 1;
               }
               else if(this.isQuestCard() || this.isRaidsCard())
               {
                  _loc1_ = this.mDef.getBGXLImageName();
                  _loc2_ = _loc3_ ? 1.5 : 1;
               }
               else if(this.isCard())
               {
                  _loc1_ = Config.getConfig().XLViewUsesXLTextures() ? this.mDef.getBGXLImageName() : this.mDef.getBGImageName();
                  _loc2_ = Utils.isMobile() && !Utils.isDesktop() ? 1 : 0.7;
                  _loc2_ = _loc3_ ? 1.5 : _loc2_;
               }
               else if(this.isGoldBag() || this.isTokensBag() || this.isBooster())
               {
                  _loc1_ = this.mDef.getBGXLImageName();
                  _loc2_ = 1;
               }
               else
               {
                  _loc1_ = this.mDef.getBGXLImageName();
                  _loc2_ = Utils.isMobile() && !Utils.isDesktop() ? 1 : 0.7;
               }
               if(InstanceMng.getCurrentScreen() is FSShopScreen)
               {
                  FSShopScreen(InstanceMng.getCurrentScreen()).addItemBGIntoNonDisposableCatalog(_loc1_);
               }
               if(!this.isPack())
               {
                  if(this.mItemImage == null)
                  {
                     this.mItemImage = new FSImage(Root.assets.getTexture(_loc1_));
                     this.mItemImage.scale = _loc2_ * this.getMobileFactor();
                     this.mItemImage.alignPivot();
                     if(this.isCard() || this.isQuestCard() || this.isRaidsCard())
                     {
                        _loc4_ = Config.getConfig().getCardBGType() == "jpg";
                        this.mItemImage.width = _loc4_ && Boolean(this.mBG) ? this.mBG.width * 0.905 : this.mItemImage.width * 0.65;
                        this.mItemImage.height = _loc4_ && Boolean(this.mBG) ? this.mBG.height * 0.92 : this.mItemImage.height * 0.65;
                        if(this.isOffer() && !_loc4_)
                        {
                           this.mItemImage.width = this.mItemImage.width = this.mItemImage.width * 1.25;
                           this.mItemImage.height = this.mItemImage.height = this.mItemImage.height * 1.25;
                        }
                        if((Utils.isBrowser() || Utils.isAndroid() && Main.smScaleFactor == 4) && !_loc4_)
                        {
                           this.mItemImage.width *= Utils.isBrowser() ? 1.85 : 1.25;
                           this.mItemImage.height *= Utils.isBrowser() ? 1.85 : 1.25;
                        }
                        this.mItemImage.alpha = 1;
                        this.mItemImage.alignPivot();
                        this.mItemImage.y = this.mBG ? this.mBG.y : 0;
                     }
                     else
                     {
                        this.mItemImage.y = this.mPriceTextfield ? this.mPriceTextfield.y - this.mPriceTextfield.height / 2 - this.mItemImage.height / 2 : 0;
                     }
                     this.mItemImage.x = this.mTitleTextfield ? this.mTitleTextfield.x : 0;
                     if(Boolean(this.mItemRarityQuad) && !this.isQuestCard())
                     {
                        if(Config.getConfig().getCardBGType() == "png")
                        {
                           addChild(this.mItemImage);
                        }
                        else
                        {
                           addChildAt(this.mItemImage,getChildIndex(this.mItemRarityQuad) + 1);
                        }
                     }
                     else if(this.mBG)
                     {
                        _loc5_ = this.getCardDef();
                        if((Boolean(_loc5_)) && Config.getConfig().getCardBGType() == "png")
                        {
                           addChild(this.mItemImage);
                        }
                        else
                        {
                           addChildAt(this.mItemImage,getChildIndex(this.mBG) + 1);
                        }
                     }
                  }
               }
               else
               {
                  _loc6_ = this.getPackSku();
                  _loc7_ = PackDef(InstanceMng.getPacksDefMng().getDefBySku(_loc6_));
                  if(this.mPackImage == null)
                  {
                     this.mPackImage = new PackAnimation(_loc7_.getAnimBG());
                     this.mPackImage.scale = _loc2_;
                     this.mPackImage.alignPivot();
                     this.mPackImage.y = this.mPriceTextfield ? this.mPriceTextfield.y - this.mPriceTextfield.height / 2 - this.mPackImage.height / 2 : -this.mPackImage.height / 2;
                     this.mPackImage.x = this.mTitleTextfield ? this.mTitleTextfield.x : 0;
                     addChildAt(this.mPackImage,getChildIndex(this.mBG) + 1);
                  }
               }
            }
            else if(!this.mOnlyLogic)
            {
               _loc8_ = BundleDef(this.mDef).getItemsList();
               if((Boolean(_loc8_)) && _loc8_.length > 0)
               {
                  _loc10_ = 0;
                  while(_loc10_ < _loc8_.length)
                  {
                     if(_loc8_[_loc10_] is Def)
                     {
                        _loc9_ = new FSBundleSubOffer(_loc8_[_loc10_],"",0,this);
                     }
                     else
                     {
                        _loc9_ = new FSBundleSubOffer(null,_loc8_[_loc10_]["currency"],_loc8_[_loc10_]["amount"],this);
                     }
                     if(this.mBundleSubOffers == null)
                     {
                        this.mBundleSubOffers = new Vector.<FSBundleSubOffer>();
                     }
                     this.mBundleSubOffers.push(_loc9_);
                     _loc10_++;
                  }
                  this.addSubOffersToContainer();
               }
            }
         }
      }
      
      private function addSubOffersToContainer() : void
      {
         var _loc1_:FSBundleSubOffer = null;
         var _loc2_:FSCoordinate = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(this.mBundleSubOffers)
         {
            _loc3_ = 0;
            _loc4_ = this.mBG.width;
            _loc5_ = this.mPriceTextfield.y - this.mPriceTextfield.height / 2 - this.mTitleTextfield.y + this.mTitleTextfield.height / 2;
            _loc6_ = 0;
            while(_loc6_ < this.mBundleSubOffers.length)
            {
               _loc1_ = this.mBundleSubOffers[_loc6_];
               _loc2_ = Utils.getXYPositionInContainer(_loc3_,_loc4_ / this.mBundleSubOffers.length,_loc1_.height,_loc4_,_loc5_,this.mBundleSubOffers.length,1,true);
               _loc1_.x = _loc2_.mX + _loc1_.width;
               _loc1_.y = _loc2_.mY + _loc1_.height * 0.75;
               addChildAt(_loc1_,getChildIndex(this.mBG) + 1);
               _loc3_++;
               _loc6_++;
            }
         }
      }
      
      public function getPackSku() : String
      {
         var _loc1_:String = "";
         if(this.mDef is PackDef)
         {
            _loc1_ = this.mDef.getSku();
         }
         else if(this.isBundle())
         {
            _loc1_ = BundleDef(this.mDef).getChestBG();
         }
         else if(this.isQuestPack())
         {
            _loc1_ = QuestShopDef(this.mDef).getPackSku();
         }
         else if(this.isRaidsPack())
         {
            _loc1_ = RaidShopDef(this.mDef).getPackSku();
         }
         return _loc1_;
      }
      
      private function createItemShadow() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         if(!this.isSkin() && !this.isCard() && !this.isQuestCard() && !this.isRaidsCard())
         {
            _loc1_ = this.getMainImage();
            if(_loc1_)
            {
               if(this.mItemShadow == null)
               {
                  this.mItemShadow = new FSImage(Root.assets.getTexture("shop_item_shadow"));
                  this.mItemShadow.alpha = 0.85;
                  this.mItemShadow.scale = 0.75 * this.getMobileFactor();
                  this.mItemShadow.alignPivot();
                  _loc3_ = 2.25;
                  this.mItemShadow.x = _loc1_.x;
                  this.mItemShadow.y = _loc1_.y + _loc1_.height / _loc3_;
               }
               _loc2_ = getChildIndex(_loc1_) >= 0 ? getChildIndex(_loc1_) : 0;
               addChildAt(this.mItemShadow,_loc2_);
            }
         }
      }
      
      private function getMainImage() : *
      {
         var _loc1_:* = undefined;
         if(this.mItemImage)
         {
            return this.mItemImage;
         }
         if(this.mPackImage)
         {
            return this.mPackImage;
         }
         return null;
      }
      
      private function createExtraInfo() : void
      {
         var _loc1_:FactionDef = null;
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:RarityDef = null;
         var _loc5_:String = null;
         if(!this.mOnlyLogic && (this.isSkin() || this.isCard() || this.isQuestCard()))
         {
            _loc1_ = this.getCardFactionDef();
            _loc2_ = _loc1_ ? "shop_slot_faction_" + Utils.transformValueToString((_loc1_.getIndex() + 1).toString(),2) : "";
            if(!this.isSkin() && _loc2_ != "")
            {
               if(this.mItemFactionFrameLeft == null)
               {
                  this.mItemFactionFrameLeft = new FSImage(Root.assets.getTexture(_loc2_));
                  this.mItemFactionFrameLeft.scale *= this.getMobileFactor();
                  this.mItemFactionFrameLeft.alignPivot();
                  this.mItemFactionFrameLeft.x = this.mBG.x - this.mBG.width / 2 + this.mItemFactionFrameLeft.width / 2;
                  this.mItemFactionFrameLeft.y = this.mBG.y - this.mBG.height / 2 + this.mItemFactionFrameLeft.height / 2;
                  addChild(this.mItemFactionFrameLeft);
               }
               if(this.mItemFactionFrameRight == null)
               {
                  this.mItemFactionFrameRight = new FSImage(Root.assets.getTexture(_loc2_));
                  this.mItemFactionFrameRight.alignPivot();
                  this.mItemFactionFrameRight.scale *= this.getMobileFactor();
                  this.mItemFactionFrameRight.scaleX *= -1;
                  this.mItemFactionFrameRight.x = this.mBG.x + this.mBG.width / 2 - this.mItemFactionFrameRight.width / 2;
                  this.mItemFactionFrameRight.y = this.mBG.y - this.mBG.height / 2 + this.mItemFactionFrameRight.height / 2;
                  addChild(this.mItemFactionFrameRight);
               }
            }
            _loc3_ = this.getItemRarity();
            _loc4_ = RarityDef(InstanceMng.getRaritiesDefMng().getRarityDefByIndex(_loc3_));
            _loc5_ = _loc4_ ? "shop_slot_rarity_" + Utils.transformValueToString((_loc4_.getIndex() + 1).toString(),2) : "";
            if(_loc5_ != "")
            {
               if(this.mItemRarityFrame == null)
               {
                  this.mItemRarityFrame = new FSImage(Root.assets.getTexture(_loc5_));
                  this.mItemRarityFrame.alignPivot();
                  this.mItemRarityFrame.x = this.mBG.x;
                  this.mItemRarityFrame.y = this.mBG.y - this.mBG.height / 2 + this.mItemRarityFrame.height / 3;
                  addChild(this.mItemRarityFrame);
               }
            }
         }
      }
      
      public function isOffer() : Boolean
      {
         return this.mIsOffer;
      }
      
      public function isPack() : Boolean
      {
         return Boolean(this.mDef) && (this.mDef is PackDef || this.isQuestPack() || this.isRaidsPack());
      }
      
      public function isCard() : Boolean
      {
         return Boolean(this.mDef) && this.mDef is CardDef;
      }
      
      public function isSkin() : Boolean
      {
         return Boolean(this.mDef) && this.mDef is HeroCharacterDef;
      }
      
      public function isGoldBag() : Boolean
      {
         return Boolean(this.mDef) && this.mDef is GoldDef;
      }
      
      public function isTokensBag() : Boolean
      {
         return Boolean(this.mDef) && this.mDef is AuctionTicketDef;
      }
      
      public function isQuestCard() : Boolean
      {
         return Boolean(this.mDef) && this.mDef is QuestShopDef && QuestShopDef(this.mDef).getCardSku() != null;
      }
      
      public function isQuestPack() : Boolean
      {
         return this.mDef && this.mDef is QuestShopDef && QuestShopDef(this.mDef).getPackSku() != "" && QuestShopDef(this.mDef).getPackSku() != null;
      }
      
      public function isRaidsCard() : Boolean
      {
         return Boolean(this.mDef) && this.mDef is RaidShopDef && RaidShopDef(this.mDef).getCardSku() != null;
      }
      
      public function isRaidsPack() : Boolean
      {
         return this.mDef && this.mDef is RaidShopDef && RaidShopDef(this.mDef).getPackSku() != "" && RaidShopDef(this.mDef).getPackSku() != null;
      }
      
      public function isBooster() : Boolean
      {
         return Boolean(this.mDef) && (this.mDef is ShopBoostDef || this.mDef is BoostDef);
      }
      
      public function isEditionPack() : Boolean
      {
         var _loc1_:PackDef = this.getPackDef();
         return Boolean(_loc1_) && _loc1_.getEditionSku() != null;
      }
      
      public function getItemRarity() : int
      {
         var _loc1_:int = 0;
         var _loc2_:RarityDef = null;
         var _loc3_:CardDef = this.getCardDef();
         if(this.isCard() || this.isSkin() || this.isQuestCard())
         {
            if(this.isCard())
            {
               _loc2_ = RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(CardDef(this.mDef).getCardRarity()));
            }
            else if(this.isSkin())
            {
               _loc2_ = RarityDef(InstanceMng.getRaritiesDefMng().getRarityDefByIndex(HeroCharacterDef(this.mDef).getSkinRarityIndex()));
            }
            else if(this.isQuestCard() && Boolean(_loc3_))
            {
               _loc2_ = RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(_loc3_.getCardRarity()));
            }
         }
         return _loc2_ ? _loc2_.getIndex() : 0;
      }
      
      private function getCardFactionDef() : FactionDef
      {
         var _loc1_:FactionDef = null;
         var _loc2_:CardDef = this.getCardDef();
         if(this.isCard() || this.isQuestCard() || this.isRaidsCard())
         {
            if(this.isCard())
            {
               _loc1_ = FactionDef(InstanceMng.getFactionsDefMng().getDefBySku(CardDef(this.mDef).getFactionSku()));
            }
            else if(this.isQuestCard())
            {
               _loc1_ = FactionDef(InstanceMng.getFactionsDefMng().getDefBySku(_loc2_.getFactionSku()));
            }
            else if(this.isRaidsCard())
            {
               _loc1_ = FactionDef(InstanceMng.getFactionsDefMng().getDefBySku(_loc2_.getFactionSku()));
            }
         }
         return _loc1_;
      }
      
      public function getPackDef() : PackDef
      {
         var _loc1_:String = this.getPackSku();
         return PackDef(InstanceMng.getPacksDefMng().getDefBySku(_loc1_));
      }
      
      public function getCardDef() : CardDef
      {
         var _loc1_:CardDef = null;
         if(this.isCard() || this.isQuestCard() || this.isRaidsCard())
         {
            if(this.isCard())
            {
               _loc1_ = CardDef(this.getDef());
            }
            else if(this.isQuestCard())
            {
               _loc1_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(QuestShopDef(this.getDef()).getCardSku()));
            }
            else if(this.isRaidsCard())
            {
               _loc1_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(RaidShopDef(this.getDef()).getCardSku()));
            }
         }
         return _loc1_;
      }
      
      private function needsToShowSubtitle() : Boolean
      {
         var _loc1_:Boolean = false;
         return this.isGoldBag() || this.isTokensBag() || this.isBooster() || this.isEditionPack() || this.isBundle();
      }
      
      private function isUnique() : Boolean
      {
         var _loc2_:PackDef = null;
         var _loc1_:Boolean = false;
         if(this.isPack())
         {
            _loc2_ = this.getPackDef();
            return _loc2_.isUniquePack();
         }
         if(this.isTokensBag())
         {
            return AuctionTicketDef(this.mDef).getIsUniquePack();
         }
         return _loc1_;
      }
      
      private function getDescriptionText() : String
      {
         return this.getDef() ? this.getDef().getDesc() : "";
      }
      
      public function getSubtitleText(param1:Boolean = false) : String
      {
         var _loc3_:PackDef = null;
         var _loc4_:String = null;
         var _loc5_:EditionDef = null;
         var _loc6_:String = null;
         var _loc2_:String = "";
         if(this.needsToShowSubtitle())
         {
            if(this.isBundle())
            {
               _loc2_ = this.getDescriptionText();
            }
            else if(this.isEditionPack())
            {
               _loc3_ = this.getPackDef();
               _loc4_ = _loc3_.getEditionSku();
               _loc5_ = EditionDef(InstanceMng.getEditionsDefMng().getDefBySku(_loc4_));
               _loc2_ = param1 ? TextManager.getText(_loc5_.getGameNameLarge()) : _loc5_.getName();
               _loc2_ = _loc2_ != "" && _loc2_ != null ? "(" + _loc2_ + ")" : _loc2_;
            }
            else if(this.isTokensBag())
            {
               _loc2_ = AuctionTicketDef(this.mDef).getTokens().toString();
            }
            else if(this.isGoldBag())
            {
               _loc2_ = GoldDef(this.mDef).getGold().toString();
            }
            else if(this.isBooster())
            {
               _loc2_ = ShopBoostDef(this.mDef).isRepurchasable() ? "" : TextManager.getText("TID_BOOST_PERMANENT");
            }
         }
         if(this.isUnique())
         {
            _loc2_ = TextManager.getText("TID_SHOP_ONE_TIME");
         }
         if(this.mIsOffer)
         {
            if(this.isBundle() && BundleDef(this.getDef()).isWelcomeBackBundle())
            {
               _loc2_ = TextManager.getText("TID_BUNDLE_WELCOME_BACK",true);
            }
            else
            {
               _loc6_ = this.mOfferType == HOURLY_OFFER ? "" : TextManager.getText("TID_SHOP_OFFER_WEEK") + " ";
               _loc2_ = "< " + _loc6_ + this.getTimeTextLeft() + " >";
            }
         }
         return _loc2_ == null ? "" : _loc2_;
      }
      
      public function getSubtitleFontColor() : uint
      {
         var _loc1_:uint = 16777215;
         if(this.needsToShowSubtitle())
         {
            if(this.isEditionPack())
            {
               _loc1_ = 16777215;
            }
            else if(this.isTokensBag())
            {
               _loc1_ = 4635632;
            }
            else if(this.isGoldBag())
            {
               _loc1_ = 16766720;
            }
            else if(this.isBooster())
            {
               _loc1_ = 8836376;
            }
         }
         _loc1_ = this.mIsOffer ? 16711680 : _loc1_;
         if(this.mIsOffer)
         {
            _loc1_ = this.mOfferType == WEEKLY_OFFER ? 10025880 : 16730184;
         }
         return this.isUnique() ? 16766720 : _loc1_;
      }
      
      public function getDef() : Def
      {
         return this.mDef;
      }
      
      public function getItemTexture() : Texture
      {
         return this.mItemImage != null ? this.mItemImage.texture : null;
      }
      
      override public function dispose() : void
      {
         var _loc1_:int = 0;
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
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
         if(this.mPriceTextfield)
         {
            this.mPriceTextfield.removeFromParent(true);
            this.mPriceTextfield = null;
         }
         if(this.mPriceCurrencyIcon)
         {
            this.mPriceCurrencyIcon.removeFromParent(true);
            this.mPriceCurrencyIcon = null;
         }
         if(this.mItemImage)
         {
            this.mItemImage.removeFromParent(true);
            this.mItemImage = null;
         }
         if(this.mItemShadow)
         {
            this.mItemShadow.removeFromParent(true);
            this.mItemShadow = null;
         }
         if(this.mPackImage)
         {
            this.mPackImage.removeFromParent(true);
            this.mPackImage = null;
         }
         if(this.mItemRarityQuad)
         {
            this.mItemRarityQuad.removeFromParent(true);
            this.mItemRarityQuad = null;
         }
         if(this.mItemFactionFrameLeft)
         {
            this.mItemFactionFrameLeft.removeFromParent(true);
            this.mItemFactionFrameLeft = null;
         }
         if(this.mItemFactionFrameRight)
         {
            this.mItemFactionFrameRight.removeFromParent(true);
            this.mItemFactionFrameRight = null;
         }
         if(this.mItemRarityFrame)
         {
            this.mItemRarityFrame.removeFromParent(true);
            this.mItemRarityFrame = null;
         }
         DictionaryUtils.clearDictionary(this.mCardsRewarded);
         this.mCardsRewarded = null;
         if(this.mSkinBoughtAnimation)
         {
            this.mSkinBoughtAnimation.removeFromParent(true);
            this.mSkinBoughtAnimation = null;
         }
         if(this.mDiscountLabel)
         {
            this.mDiscountLabel.removeFromParent(true);
            this.mDiscountLabel = null;
         }
         if(this.mBundleSubOffers)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mBundleSubOffers.length)
            {
               this.mBundleSubOffers[_loc1_].removeFromParent(true);
               _loc1_++;
            }
            Utils.destroyArray(this.mBundleSubOffers);
            this.mBundleSubOffers = null;
         }
         this.mHoverHelperPoint = null;
         this.mOfferInfo = null;
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
         super.dispose();
      }
      
      public function isProductValidForPurchase() : Boolean
      {
         return this.mValidPriceReceivedFromAppstore;
      }
      
      public function setProductValidForPurchase(param1:Boolean) : void
      {
         var _loc2_:Boolean = this.isBooster() && this.isBoostPurchaseable() || !this.isBooster();
         this.mValidPriceReceivedFromAppstore = param1 && _loc2_;
      }
      
      public function getProdId() : String
      {
         var _loc1_:String = null;
         if(this.mDef != null)
         {
            if(this.mDef is CardDef)
            {
               _loc1_ = CardDef(this.mDef).getProdId();
            }
            else if(this.mDef is PackDef)
            {
               _loc1_ = PackDef(this.mDef).getProdId();
            }
            else if(this.mDef is ShopBoostDef)
            {
               _loc1_ = ShopBoostDef(this.mDef).getProdId();
            }
            else
            {
               _loc1_ = this.mDef.getProdId();
            }
         }
         return _loc1_;
      }
      
      public function performOnBoughtOperations(param1:Boolean = true, param2:Boolean = false) : void
      {
         var _loc3_:Boolean = true;
         var _loc4_:CardDef = this.getCardDef();
         if(this.isBundle())
         {
            this.onBundlePurchasedPerformOps(param1);
         }
         else if(this.isCard() || this.isQuestCard() || this.isRaidsCard())
         {
            this.onCardPurchasedPerformOps(param1,param2);
            if(this.isRaidsCard() && this.getInGameCurrencyType() != ServerConnection.CURRENCY_REAL)
            {
               InstanceMng.getServerConnection().addRaidsCardShopInstance(RaidShopDef(this.mDef).getCardSku(),_loc4_.getName(),this.getInGameCurrencyCost(),param2);
            }
         }
         else if(this.isBooster())
         {
            this.onBoosterPurchased(param1);
         }
         else if(this.isTokensBag())
         {
            InstanceMng.getUserDataMng().getOwnerUserData().addAuctionTickets(AuctionTicketDef(this.mDef).getTokens());
            if(AuctionTicketDef(this.mDef).getIsUniquePack())
            {
               InstanceMng.getUserDataMng().getOwnerUserData().addPackIdToUniquePacksArr(AuctionTicketDef(this.mDef).getSku());
            }
         }
         else if(this.isGoldBag())
         {
            if(GoldDef(this.mDef).getTokens() > 0)
            {
               InstanceMng.getUserDataMng().getOwnerUserData().addAuctionTickets(GoldDef(this.mDef).getTokens());
            }
            InstanceMng.getUserDataMng().getOwnerUserData().addGold(GoldDef(this.mDef).getGold());
            InstanceMng.getServerConnection().shareGoldPurchasedWithGuild(GoldDef(this.mDef).getGold(),GoldDef(this.mDef));
         }
         else if(this.isSkin())
         {
            this.onSkinPurchasedSuccessfully();
         }
         else if(this.isPack())
         {
            this.onPackPurchasedPerformOps();
            _loc3_ = false;
         }
         if(this.isUnique())
         {
            removeFromParent();
         }
         if(_loc3_)
         {
            InstanceMng.getUserDataMng().persistenceSaveData();
         }
      }
      
      private function trackPurchase(param1:Boolean = false) : void
      {
         var _loc2_:Number = this.getInGameCurrencyCost();
         var _loc3_:String = this.getInGameCurrencyType();
         var _loc4_:String = "";
         var _loc5_:CardDef = this.getCardDef();
         var _loc6_:Object = new Object();
         _loc6_.sku = this.mDef ? this.mDef.getSku() : "";
         _loc6_.cost = _loc2_;
         _loc6_.currency = _loc3_;
         _loc6_.sku += param1 ? " (x10)" : "";
         _loc6_.cost *= param1 ? 10 : 1;
         if(_loc5_ != null)
         {
            _loc6_.cardSku = _loc5_.getSku();
         }
         switch(_loc3_)
         {
            case ServerConnection.CURRENCY_GOLD:
               _loc4_ = FSTracker.ACTION_GOLD_PACK_PURCHASED;
               break;
            case ServerConnection.CURRENCY_QUEST_COINS:
               _loc4_ = FSTracker.ACTION_QUESTCOIN_PACK_PURCHASED;
               break;
            case ServerConnection.CURRENCY_RAID_COINS:
               _loc4_ = FSTracker.ACTION_RAIDCOINS_PACK_PURCHASED;
         }
         if(this.isSkin() && _loc3_ == ServerConnection.CURRENCY_GOLD)
         {
            _loc4_ = FSTracker.ACTION_SKIN_GOLD_PURCHASE;
         }
         FSTracker.trackMiscAction(FSTracker.CATEGORY_SHOP,_loc4_,_loc6_);
      }
      
      public function beginInGameCurrencyPurchase(param1:Boolean = true, param2:Boolean = false) : void
      {
         var currencyAmount:Number;
         var currencyType:String;
         var onInGameCurrencyProductPurchased:Function = null;
         var notifyViaLog:Boolean = param1;
         var isx10Purchase:Boolean = param2;
         onInGameCurrencyProductPurchased = function():void
         {
            trackPurchase(isx10Purchase);
            performOnBoughtOperations(true,isx10Purchase);
         };
         if(InstanceMng.getCurrentScreen() is FSShopScreen)
         {
            FSShopScreen(InstanceMng.getCurrentScreen()).setItemBeingPurchased(this);
         }
         currencyAmount = this.getInGameCurrencyCost();
         currencyType = this.getInGameCurrencyType();
         currencyAmount *= isx10Purchase ? 10 : 1;
         InstanceMng.getUserDataMng().getOwnerUserData().substractCurrency(currencyType,-currencyAmount,onInGameCurrencyProductPurchased,null,this.onPurchaseFailed,[currencyType]);
      }
      
      private function onPackPurchasedPerformOps(param1:Boolean = false) : void
      {
         var _loc2_:PackDef = this.getPackDef();
         if(_loc2_.getTokens() > 0)
         {
            InstanceMng.getUserDataMng().getOwnerUserData().addAuctionTickets(_loc2_.getTokens());
         }
         if(_loc2_.isUniquePack())
         {
            InstanceMng.getUserDataMng().getOwnerUserData().addPackIdToUniquePacksArr(_loc2_.getSku());
         }
         if(param1)
         {
            Utils.setLogText(TextManager.getText("TID_SHOP_PACK_SUCCESS"));
         }
         Utils.openPack(_loc2_,this.getOrigin(),this,false,_loc2_.getAnimBG());
      }
      
      private function onBundlePurchasedPerformOps(param1:Boolean = false) : void
      {
         InstanceMng.getUserDataMng().handleBundlePurchased(BundleDef(this.mDef),this);
      }
      
      private function onCardPurchasedPerformOps(param1:Boolean = false, param2:Boolean = false) : void
      {
         var _loc3_:CardDef = this.getCardDef();
         var _loc4_:String = _loc3_.getSku();
         var _loc5_:String = param2 ? ":10" : ":1";
         InstanceMng.getUserDataMng().getOwnerUserData().addCardToCollection(_loc4_ + _loc5_);
         InstanceMng.getUserDataMng().getOwnerUserData().addCardToNewCardsCollection(_loc4_ + _loc5_);
         if(param1)
         {
            Utils.setLogText(TextManager.getText("TID_SHOP_CARD_SUCCESS"));
         }
         if(InstanceMng.getCurrentScreen() is FSShopScreen)
         {
            FSShopScreen(InstanceMng.getCurrentScreen()).unlockAfterPurchase();
         }
      }
      
      private function onSkinPurchasedSuccessfully() : void
      {
         InstanceMng.getUserDataMng().getOwnerUserData().addSkinToCatalog(this.mDef.getSku());
         this.createSkinBoughtAnimation(this.mDef.getBGImageName(),2);
         Utils.setLogText(TextManager.getText("TID_SKIN_RECEIVED"));
         var _loc1_:String = this.getInGameCurrencyType() == ServerConnection.CURRENCY_REAL ? FSTracker.ACTION_SKIN_PURCHASE : FSTracker.ACTION_SKIN_GOLD_PURCHASE;
         removeFromParent();
      }
      
      private function onPurchaseFailed(param1:String = "") : void
      {
         if(InstanceMng.getCurrentScreen() is FSShopScreen)
         {
            FSShopScreen(InstanceMng.getCurrentScreen()).lockShopUI(false,InstanceMng.getPopupMng().getPopupShown());
            this.setEnabled(true);
            if(param1 != "")
            {
               Utils.showNotEnoughCurrencyMessage(param1);
            }
         }
      }
      
      public function createSkinBoughtAnimation(param1:String, param2:Number = 1, param3:Function = null, param4:Array = null) : void
      {
         var _loc5_:Number = 0.6 * Utils.getDefaultSpeedTime();
         if(this.mSkinBoughtAnimation == null)
         {
            this.mSkinBoughtAnimation = new FSSkinBoughtAnimation(param1,param3,param4);
         }
         InstanceMng.getCurrentScreen().addChild(this.mSkinBoughtAnimation);
         this.mSkinBoughtAnimation.x = Starling.current.stage.stageWidth / 2;
         this.mSkinBoughtAnimation.y = Starling.current.stage.stageHeight / 2;
         this.mSkinBoughtAnimation.performFadeIn();
         TweenMax.delayedCall(param2,this.removeSkinBoughtAnimation);
      }
      
      private function removeSkinBoughtAnimation() : void
      {
         var onSkinBoughtAnimRemoved:Function = null;
         var speed:Number = NaN;
         onSkinBoughtAnimRemoved = function():void
         {
            mSkinBoughtAnimation = null;
            if(InstanceMng.getCurrentScreen() is FSShopScreen)
            {
               FSShopScreen(InstanceMng.getCurrentScreen()).unlockAfterPurchase();
            }
         };
         TweenMax.killDelayedCallsTo(this.removeSkinBoughtAnimation);
         if(Boolean(this.mSkinBoughtAnimation) && this.mSkinBoughtAnimation.isShown())
         {
            speed = 2 * Utils.getDefaultSpeedTime();
            this.mSkinBoughtAnimation.performFadeOut(speed);
            TweenMax.delayedCall(speed,onSkinBoughtAnimRemoved);
         }
      }
      
      private function onBoosterPurchased(param1:Boolean = true) : void
      {
         var _loc5_:int = 0;
         var _loc6_:BoostDef = null;
         var _loc7_:Boost = null;
         if(param1)
         {
            Utils.setLogText(TextManager.getText("TID_SHOP_BOOST_SUCCESS"),false,false,false);
         }
         var _loc2_:ShopBoostDef = this.mDef != null && this.mDef is ShopBoostDef ? ShopBoostDef(this.mDef) : null;
         var _loc3_:String = this.mDef != null && this.mDef is BoostDef ? this.mDef.getSku() : "";
         var _loc4_:String = _loc2_ ? _loc2_.getBoostSku() : _loc3_;
         if(Boolean(_loc4_ != "") && Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
         {
            _loc5_ = InstanceMng.getUserDataMng().getOwnerUserData().getBoostAmount(_loc4_);
            if(this.mDef != null && this.mDef is ShopBoostDef && (ShopBoostDef(this.mDef).isRepurchasable() || !ShopBoostDef(this.mDef).isRepurchasable() && _loc5_ == 0))
            {
               InstanceMng.getUserDataMng().getOwnerUserData().addBoostToCatalog(_loc4_,1);
               InstanceMng.getUserDataMng().updateBoosts();
            }
            if(Boolean(InstanceMng.getBoostsDefMng()) && Boolean(InstanceMng.getBoostsMng()) && (Boolean(_loc2_) && Boolean(_loc2_.getExecuteOnBuy())) || _loc2_ == null && _loc3_ != "")
            {
               _loc6_ = BoostDef(InstanceMng.getBoostsDefMng().getDefBySku(_loc4_));
               _loc7_ = _loc6_ ? InstanceMng.getBoostsMng().getBoost(_loc6_) : null;
               if(_loc7_ != null)
               {
                  _loc7_.execute();
               }
            }
            else if(Boolean(this.mDef) && param1)
            {
               Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_BOOST_BOUGHT"),[this.mDef.getName()]));
            }
         }
      }
      
      public function isBoostPurchaseable() : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc1_:Boolean = true;
         var _loc2_:ShopBoostDef = this.mDef is ShopBoostDef ? ShopBoostDef(this.mDef) : null;
         if(Boolean(_loc2_) && !_loc2_.isRepurchasable())
         {
            _loc4_ = _loc2_.getBoostSku();
            _loc3_ = InstanceMng.getUserDataMng().getOwnerUserData().getBoostAmount(_loc4_);
            _loc1_ = _loc3_ == 0;
         }
         else
         {
            _loc3_ = InstanceMng.getUserDataMng().getOwnerUserData().getBoostAmount(this.mDef.getSku());
            _loc1_ = _loc3_ == 0;
         }
         return _loc1_;
      }
      
      public function getOrigin() : String
      {
         var _loc1_:String = PacksDefMng.PACK_SHOP;
         if(this.isRaidsPack())
         {
            _loc1_ = PacksDefMng.PACK_RAIDS;
         }
         if(this.isQuestPack())
         {
            _loc1_ = PacksDefMng.PACK_QUESTS;
         }
         if(this.isOffer())
         {
            _loc1_ = PacksDefMng.PACK_SHOP_OFFER;
         }
         return _loc1_;
      }
      
      private function getTimeTextLeft() : String
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         if(this.mOfferType == WEEKLY_OFFER)
         {
            return "";
         }
         this.mOfferExpirationTimeLeft = this.mOfferExpirationTime - ServerConnection.smServerTimeMS;
         this.mOfferExpired = this.mOfferExpirationTimeLeft <= 0;
         var _loc1_:String = "";
         if(this.mOfferExpirationTimeLeft != -1 && this.mOfferExpirationTimeLeft > 0)
         {
            _loc2_ = TimerUtil.msToDays(this.mOfferExpirationTimeLeft) > 0;
            _loc3_ = TimerUtil.msToHour(this.mOfferExpirationTimeLeft) > 0;
            _loc4_ = TimerUtil.msToMin(this.mOfferExpirationTimeLeft) > 0;
            if(this.isBundle() && _loc2_)
            {
               _loc5_ = _loc2_ ? " " + TextManager.getText("TID_GEN_TIME_DAYS",true) + " " : null;
               _loc6_ = _loc3_ ? " " + TextManager.getText("TID_GEN_TIME_HOURS",true) : null;
               _loc7_ = !_loc2_ && !_loc3_ ? " " + TextManager.getText("TID_GEN_TIME_MINUTES",true) : null;
               _loc8_ = !_loc2_ && !_loc3_ && !_loc4_ ? " " + TextManager.getText("TID_GEN_TIME_SECONDS",true) : null;
               _loc1_ = " " + TimerUtil.getTimeTextFromMs(this.mOfferExpirationTimeLeft,_loc5_,_loc6_,_loc7_,_loc8_);
            }
            else
            {
               _loc1_ = TimerUtil.getTimeTextFromMs(this.mOfferExpirationTimeLeft,null,":",":","",true,false);
            }
         }
         else
         {
            _loc1_ = TimerUtil.getTimeTextFromMs(this.mOfferExpirationTimeLeft,null,":",":","",true,false);
         }
         return _loc1_;
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         if(this.mOfferType == HOURLY_OFFER)
         {
            if(this.mSubtitleTextfield)
            {
               this.mSubtitleTextfield.text = !this.mOfferExpired ? this.getSubtitleText() : "-----";
            }
            if(this.mOfferExpired && this.isBundle() && parent != null)
            {
               removeFromParent();
            }
         }
         if(this.mOfferExpired && Boolean(parent))
         {
            if(InstanceMng.getCurrentScreen() is FSShopScreen)
            {
               FSShopScreen(InstanceMng.getCurrentScreen()).forceRefreshOffers();
            }
         }
      }
      
      private function calculateOfferType(param1:Object) : int
      {
         var _loc2_:int = 0;
         if(param1)
         {
            _loc2_ = Boolean(param1.isHourly) || this.isBundle() ? 0 : 1;
         }
         return _loc2_;
      }
      
      public function getOfferType() : int
      {
         return this.mOfferType;
      }
      
      public function isOfferExpired() : Boolean
      {
         return this.mIsOffer && this.mOfferExpired;
      }
      
      public function getMobileFactor() : Number
      {
         var _loc1_:Boolean = !this.isBundle() || this.isBundle() && BundleDef(this.mDef).getItemsList().length < 3;
         return _loc1_ && !this.isSkin() && Utils.isMobile() && !Utils.isTablet() ? 1.5 : 1;
      }
   }
}

