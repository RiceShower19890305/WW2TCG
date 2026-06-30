package com.fs.tcgengine.view.popups.purchases
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSShopScreen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import starling.textures.Texture;
   
   public class PopupProductDetail extends PopupShopItem
   {
      
      private var mProductType:int;
      
      private var mSku:String;
      
      private var mAmount:int;
      
      private var mDescription:String;
      
      private var mDetailsProvided:Boolean;
      
      private var mAssetsLoading:Boolean;
      
      public function PopupProductDetail(param1:Boolean = true)
      {
         super(param1);
      }
      
      override protected function setResourcesToLoad() : void
      {
         var _loc1_:CardDef = null;
         if(this.mProductType == 0 && Boolean(this.mSku))
         {
            if(!this.mAssetsLoading)
            {
               InstanceMng.getCurrentScreen().showLoadingIcon(true,true);
               if(!(InstanceMng.getCurrentScreen() is FSShopScreen))
               {
                  if(Root.assets.getTextureAtlas("framesFactionsRarities_0") == null)
                  {
                     InstanceMng.getResourcesMng().addResourcesFolderByName("framesFactionsRarities");
                  }
                  if(Root.assets.getTextureAtlas("frames_0") == null)
                  {
                     InstanceMng.getResourcesMng().addResourcesFolderByName("frames");
                  }
               }
               _loc1_ = CardDef(this.getProductDef());
               InstanceMng.getResourcesMng().loadCardImagesByCardDef(_loc1_,false);
               InstanceMng.getResourcesMng().loadAssets(this.notifyAssetsLoaded);
               this.mAssetsLoading = true;
            }
         }
         else
         {
            super.setResourcesToLoad();
         }
      }
      
      override public function notifyAssetsLoaded() : void
      {
         super.notifyAssetsLoaded();
         InstanceMng.getCurrentScreen().showLoadingIcon(false,true);
      }
      
      public function setupProduct(param1:int, param2:String, param3:int, param4:String) : void
      {
         this.mProductType = param1;
         this.mSku = param2;
         this.mAmount = param3;
         this.mDescription = param4;
         this.mDetailsProvided = true;
         this.setResourcesToLoad();
      }
      
      override protected function fulfilsCondition() : Boolean
      {
         return this.mDetailsProvided;
      }
      
      override protected function isPack() : Boolean
      {
         return this.mProductType == 1;
      }
      
      private function isGold() : Boolean
      {
         return this.mProductType == 3;
      }
      
      override protected function isCard() : Boolean
      {
         return this.mProductType == 0;
      }
      
      override protected function getRawItemTexture() : Texture
      {
         return this.mProductType == 3 ? Root.assets.getTexture("large_gold_reward") : null;
      }
      
      override protected function getProductSku() : String
      {
         return this.mSku;
      }
      
      override protected function onNoDefFoundGetTitle() : String
      {
         return this.isGold() ? TextManager.getText("TID_GEN_CURRENCY_1") : "";
      }
      
      override protected function getProductDef() : Def
      {
         var _loc1_:Def = null;
         if(this.isPack())
         {
            _loc1_ = InstanceMng.getPacksDefMng().getDefBySku(this.mSku);
         }
         else
         {
            _loc1_ = InstanceMng.getCardsDefMng().getDefBySku(this.mSku);
         }
         return _loc1_;
      }
      
      override protected function getSubtitleText() : String
      {
         var _loc1_:String = super.getSubtitleText();
         return this.isGold() ? this.mAmount.toString() : _loc1_;
      }
      
      override protected function getSubtitleColor() : uint
      {
         var _loc1_:uint = super.getSubtitleColor();
         return this.isGold() ? 16181514 : _loc1_;
      }
      
      override protected function createDescription() : void
      {
         var _loc2_:Number = NaN;
         var _loc1_:String = this.mDescription;
         if(_loc1_ != "")
         {
            if(mDescriptionTextfield == null)
            {
               _loc2_ = mSubtitleTextfield ? mBox.height - (mSubtitleTextfield.y + mSubtitleTextfield.height) : mBox.height - (mTitleTextfield.y + mTitleTextfield.height);
               mDescriptionTextfield = new FSTextfield(mTitleTextfield.width,_loc2_,_loc1_);
               mDescriptionTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_DESC);
               mDescriptionTextfield.fontSize = FSResourceMng.FONT_STD_DEFAULT_SIZE;
               mDescriptionTextfield.alignPivot();
               mDescriptionTextfield.x = mTitleTextfield.x;
               mDescriptionTextfield.y = mSubtitleTextfield ? mSubtitleTextfield.y + mSubtitleTextfield.height / 2 + mDescriptionTextfield.height / 2 : mTitleTextfield.y + mTitleTextfield.height / 2 + mDescriptionTextfield.height / 2;
            }
            addChild(mDescriptionTextfield);
         }
      }
      
      override protected function createPackRaritiesInfo() : void
      {
         super.createPackRaritiesInfo();
         if(mPackRaritiesContainer)
         {
            mPackRaritiesContainer.y = mSubtitleTextfield ? mSubtitleTextfield.y + mSubtitleTextfield.height / 1.75 : mTitleTextfield.y;
            if(mDescriptionTextfield)
            {
               mDescriptionTextfield.height = mBox.height * 0.2;
               mDescriptionTextfield.y = height - mDescriptionTextfield.height;
            }
         }
      }
      
      override protected function removeFromStage() : void
      {
         if(mCard)
         {
            DictionaryUtils.disposeCard(mCard.getParentCard());
         }
         InstanceMng.getPopupMng().removePopup(FSPopupMng.PRODUCT_DETAIL_POPUP_NAME);
         super.removeFromStage();
      }
   }
}

