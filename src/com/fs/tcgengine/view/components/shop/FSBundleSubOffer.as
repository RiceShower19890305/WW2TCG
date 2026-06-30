package com.fs.tcgengine.view.components.shop
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.model.rules.BoostDef;
   import com.fs.tcgengine.model.rules.BundleDef;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.FactionDef;
   import com.fs.tcgengine.model.rules.HeroCharacterDef;
   import com.fs.tcgengine.model.rules.PackDef;
   import com.fs.tcgengine.model.rules.RarityDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSShopScreen;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.anims.misc.PackAnimation;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.CustomComponent;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   
   public class FSBundleSubOffer extends Component
   {
      
      private var mDef:Def;
      
      private var mTitleTextfield:FSTextfield;
      
      private var mItemImage:FSImage;
      
      private var mItemShadow:FSImage;
      
      private var mPackImage:PackAnimation;
      
      private var mCurrencyType:String;
      
      private var mCurrencyAmount:int;
      
      private var mItemFactionFrameLeft:FSImage;
      
      private var mItemFactionFrameRight:FSImage;
      
      private var mItemRarityFrame:FSImage;
      
      private var mShopItemRef:FSShopItem;
      
      private var mCardBG:CustomComponent;
      
      public function FSBundleSubOffer(param1:Def, param2:String = "", param3:int = 0, param4:FSShopItem = null)
      {
         super();
         this.mDef = param1;
         this.mCurrencyType = param2;
         this.mCurrencyAmount = param3;
         this.mShopItemRef = param4;
         this.createUI();
      }
      
      private function createUI() : void
      {
         this.createImage();
         this.createItemShadow();
         this.createTitle();
      }
      
      private function createImage() : void
      {
         var _loc1_:String = null;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         var _loc2_:Number = 0.75;
         if(this.isSkin())
         {
            _loc1_ = this.mDef.getBGImageName();
            _loc2_ = Utils.isBrowser() || Utils.isDesktop() ? 0.5 : 0.75;
         }
         else if(this.isCard())
         {
            _loc3_ = BundleDef(this.mShopItemRef.getDef()).getItemsList().length < 3;
            _loc1_ = this.mDef.getBGImageName();
            _loc2_ = _loc3_ && !Utils.isBrowser() && !Utils.isTablet() ? 0.75 : 0.5;
            this.createCardBG(_loc2_);
         }
         else if(this.isCurrency())
         {
            _loc1_ = Utils.getShopCurrencyIcons(this.mCurrencyType);
            _loc2_ = 0.85;
         }
         else if(this.isBoost())
         {
            _loc1_ = BoostDef(this.mDef).getBGBuy();
            _loc2_ = 0.7;
         }
         else
         {
            _loc1_ = this.mDef.getBGXLImageName();
            _loc2_ = 0.7;
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
               this.mItemImage.scale = _loc2_ * this.mShopItemRef.getMobileFactor();
               if(this.isCard())
               {
                  _loc4_ = Config.getConfig().getCardBGType() == "jpg";
                  this.mItemImage.width = _loc4_ ? this.mCardBG.width * 0.905 : this.mItemImage.width * 1.15;
                  this.mItemImage.height = _loc4_ ? this.mCardBG.height * 0.92 : this.mItemImage.height * 1.15;
                  if(Utils.isBrowser() && !_loc4_)
                  {
                     this.mItemImage.width *= 0.75;
                     this.mItemImage.height *= 0.75;
                  }
               }
               this.mItemImage.alignPivot();
               if(this.isCard())
               {
                  this.mItemImage.alpha = 1;
               }
               addChild(this.mItemImage);
            }
         }
         else
         {
            _loc5_ = PackDef(this.mDef).getAnimBG();
            if(this.mPackImage == null)
            {
               this.mPackImage = new PackAnimation(_loc5_);
               this.mPackImage.scale = _loc2_ * this.mShopItemRef.getMobileFactor();
               this.mPackImage.x = -this.mPackImage.width * 0.15;
               this.mPackImage.y = -this.mPackImage.height * 0.15;
               this.mPackImage.alignPivot();
               addChild(this.mPackImage);
            }
         }
         this.createExtraInfo(_loc2_);
      }
      
      private function createExtraInfo(param1:Number) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:* = undefined;
         var _loc4_:FactionDef = null;
         var _loc5_:String = null;
         var _loc6_:RarityDef = null;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         if(this.isCard())
         {
            _loc2_ = Config.getConfig().getCardBGType() == "jpg";
            _loc3_ = _loc2_ ? this.getMainImage() : this.mCardBG;
            _loc4_ = FactionDef(InstanceMng.getFactionsDefMng().getDefBySku(CardDef(this.mDef).getFactionSku()));
            _loc5_ = _loc4_ ? "shop_slot_faction_" + Utils.transformValueToString((_loc4_.getIndex() + 1).toString(),2) : "";
            if(_loc5_ != "")
            {
               if(this.mItemFactionFrameLeft == null)
               {
                  this.mItemFactionFrameLeft = new FSImage(Root.assets.getTexture(_loc5_));
                  this.mItemFactionFrameLeft.scale = param1;
                  this.mItemFactionFrameLeft.alignPivot();
                  this.mItemFactionFrameLeft.x = _loc3_.x - _loc3_.width / 2 + this.mItemFactionFrameLeft.width / 2;
                  this.mItemFactionFrameLeft.y = _loc3_.y - _loc3_.height / 2 + this.mItemFactionFrameLeft.height / 2;
                  addChild(this.mItemFactionFrameLeft);
               }
               if(this.mItemFactionFrameRight == null)
               {
                  this.mItemFactionFrameRight = new FSImage(Root.assets.getTexture(_loc5_));
                  this.mItemFactionFrameRight.scale = param1;
                  this.mItemFactionFrameRight.alignPivot();
                  this.mItemFactionFrameRight.scaleX = -param1;
                  this.mItemFactionFrameRight.x = _loc3_.x + _loc3_.width / 2 - this.mItemFactionFrameRight.width / 2;
                  this.mItemFactionFrameRight.y = _loc3_.y - _loc3_.height / 2 + this.mItemFactionFrameRight.height / 2;
                  addChild(this.mItemFactionFrameRight);
               }
            }
            _loc6_ = RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(CardDef(this.mDef).getCardRarity()));
            _loc7_ = _loc6_.getIndex();
            _loc8_ = _loc6_ ? "shop_slot_rarity_" + Utils.transformValueToString((_loc6_.getIndex() + 1).toString(),2) : "";
            if(_loc8_ != "")
            {
               if(this.mItemRarityFrame == null)
               {
                  this.mItemRarityFrame = new FSImage(Root.assets.getTexture(_loc8_));
                  this.mItemRarityFrame.scale = param1;
                  this.mItemRarityFrame.alignPivot();
                  this.mItemRarityFrame.x = _loc3_.x;
                  this.mItemRarityFrame.y = _loc3_.y - _loc3_.height / 2 + this.mItemRarityFrame.height / 3;
                  addChild(this.mItemRarityFrame);
               }
            }
            if(Config.getConfig().getCardBGType() == "png" && this.mItemImage != null)
            {
               addChild(this.mItemImage);
            }
         }
      }
      
      private function createItemShadow() : void
      {
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc1_:* = this.getMainImage();
         if(_loc1_)
         {
            if(this.mItemShadow == null)
            {
               this.mItemShadow = new FSImage(Root.assets.getTexture("shop_item_shadow"));
               this.mItemShadow.alpha = 0.85;
               this.mItemShadow.scale = 0.5 * this.mShopItemRef.getMobileFactor();
               this.mItemShadow.alignPivot();
               _loc3_ = 1.5;
               this.mItemShadow.x = _loc1_.x;
               this.mItemShadow.y = _loc1_.y + _loc1_.height / _loc3_;
            }
            _loc2_ = getChildIndex(_loc1_) >= 0 ? getChildIndex(_loc1_) : 0;
            addChildAt(this.mItemShadow,_loc2_);
         }
      }
      
      private function createTitle() : void
      {
         var _loc2_:String = null;
         var _loc3_:* = undefined;
         var _loc1_:String = "";
         if(this.isCurrency())
         {
            _loc1_ = this.mCurrencyAmount.toString();
         }
         else
         {
            _loc2_ = this.isBoost() ? " (x" + BundleDef(this.mShopItemRef.getDef()).getBoostsAmount(this.mDef.getSku()).toString() + ")" : "";
            _loc1_ = this.mDef.getName() + _loc2_;
         }
         if(this.mTitleTextfield == null)
         {
            _loc3_ = this.getMainImage();
            this.mTitleTextfield = new FSTextfield(_loc3_.width,_loc3_.height / 3,_loc1_);
            this.mTitleTextfield.fontSize = FSResourceMng.FONT_STD_BIG_TITLE_SIZE;
            this.mTitleTextfield.alignPivot();
            this.mTitleTextfield.x = _loc3_.x;
            this.mTitleTextfield.y = _loc3_.y + _loc3_.height / 2;
            addChild(this.mTitleTextfield);
         }
      }
      
      private function isCard() : Boolean
      {
         return Boolean(this.mDef) && this.mDef is CardDef;
      }
      
      private function isPack() : Boolean
      {
         return Boolean(this.mDef) && this.mDef is PackDef;
      }
      
      private function isSkin() : Boolean
      {
         return Boolean(this.mDef) && this.mDef is HeroCharacterDef;
      }
      
      private function isCurrency() : Boolean
      {
         return this.mDef == null && this.mCurrencyAmount > 0;
      }
      
      private function isBoost() : Boolean
      {
         return Boolean(this.mDef) && this.mDef is BoostDef;
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
      
      private function createCardBG(param1:Number) : void
      {
         if(this.mCardBG == null)
         {
            this.mCardBG = Utils.createCustomBox("shop_slot",446);
            this.mCardBG.alpha = 0.8;
            this.mCardBG.scale = param1;
            this.mCardBG.alignPivot();
            addChild(this.mCardBG);
         }
      }
      
      override public function dispose() : void
      {
         if(this.mTitleTextfield)
         {
            this.mTitleTextfield.removeFromParent(true);
            this.mTitleTextfield = null;
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
         if(this.mCardBG)
         {
            this.mCardBG.removeFromParent(true);
            this.mCardBG = null;
         }
         this.mDef = null;
         this.mShopItemRef = null;
         super.dispose();
      }
   }
}

