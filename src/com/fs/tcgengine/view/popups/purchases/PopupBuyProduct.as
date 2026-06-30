package com.fs.tcgengine.view.popups.purchases
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.popups.misc.PopupStandard;
   import starling.events.Event;
   import starling.textures.Texture;
   import starling.utils.Align;
   
   public class PopupBuyProduct extends PopupStandard
   {
      
      protected var mItemDef:Def;
      
      protected var mItemImage:FSImage;
      
      protected var mTitleTextfield:FSTextfield;
      
      protected var mItemDescription:FSTextfield;
      
      public function PopupBuyProduct(param1:Boolean = true)
      {
         super(param1);
      }
      
      override protected function setResourcesToLoad() : void
      {
         if(this.mItemDef)
         {
            super.setResourcesToLoad();
         }
      }
      
      override protected function getBackgroundName(param1:String) : void
      {
         mBGName = Constants.POPUP_EXTENDED_NAME;
      }
      
      override protected function createUI() : void
      {
         if(this.mItemDef)
         {
            super.createUI();
            this.createTitle();
            this.createItemImage();
            this.refreshAcceptButtonState();
            this.createProdDesc();
            this.checkIfProdsRequested();
            if(mAcceptButton)
            {
               addChild(mAcceptButton);
            }
         }
      }
      
      protected function checkIfProdsRequested() : void
      {
         if(!InstanceMng.getApplication().getInAppsManager().areProductsPricesUpToDate())
         {
            InstanceMng.getServerConnection().getProducts(null,true);
            Utils.setLogText(TextManager.getText("TID_GEN_REQUEST_PRODUCT"),false,true);
            InstanceMng.getCurrentScreen().showLoadingIcon(true,false,Align.RIGHT,Align.CENTER,1,null,InstanceMng.getLogPanel());
         }
      }
      
      public function setupPopup(param1:Def) : void
      {
         this.mItemDef = param1;
         this.createUI();
      }
      
      override protected function removeFromStage() : void
      {
         if(this.mTitleTextfield)
         {
            this.mTitleTextfield.removeFromParent(true);
            this.mTitleTextfield = null;
         }
         if(this.mItemImage)
         {
            this.mItemImage.removeFromParent(this.removeTextureItemDef());
            this.mItemImage = null;
         }
         if(this.mItemDescription)
         {
            this.mItemDescription.removeFromParent(true);
            this.mItemDescription = null;
         }
         if(this.removeTextureItemDef())
         {
            Root.assets.removeTexture(this.mItemDef.getBGImageName());
         }
         super.removeFromStage();
      }
      
      private function createTitle() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.mTitleTextfield == null)
         {
            _loc1_ = mBox ? int(mBox.width) : int(width);
            _loc2_ = mBox ? int(mBox.height * 0.15) : int(height * 0.15);
            this.mTitleTextfield = new FSTextfield(_loc1_,_loc2_,"",16777215,FSResourceMng.FONT_STD_TITLE_SIZE);
            this.mTitleTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GOLD);
            this.mTitleTextfield.x = 0;
            this.mTitleTextfield.y = 0;
            addChild(this.mTitleTextfield);
         }
         this.mTitleTextfield.text = Boolean(this.mItemDef) && Boolean(this.mItemDef.getName()) ? this.mItemDef.getName().toUpperCase() : "";
         addChild(this.mTitleTextfield);
      }
      
      protected function createItemImage() : void
      {
         if(this.mItemDef != null)
         {
            if(this.mItemImage == null)
            {
               this.mItemImage = new FSImage(Root.assets.getTexture(this.mItemDef.getBGImageName()));
            }
            else
            {
               this.mItemImage.texture = Root.assets.getTexture(this.mItemDef.getBGImageName());
            }
            this.mItemImage.x = mBox.width / 2 - this.mItemImage.width / 2;
            this.mItemImage.y = this.mTitleTextfield.y + this.mTitleTextfield.height / 2;
            addChild(this.mItemImage);
         }
      }
      
      protected function createProdDesc() : void
      {
         var _loc1_:String = null;
         if(this.mItemDescription == null)
         {
            _loc1_ = Boolean(this.mItemDef) && this.mItemDef.getDesc() != null ? this.mItemDef.getDesc() : "";
            this.mItemDescription = new FSTextfield(mBox.width * 0.8,mBox.height * 0.4,_loc1_);
            this.mItemDescription.x = (mBox.width - this.mItemDescription.width) / 2;
            this.mItemDescription.y = mBox.height / 2.15;
         }
         addChild(this.mItemDescription);
      }
      
      override protected function onAccept(param1:Event) : void
      {
      }
      
      protected function isProductValidForPurchase() : Boolean
      {
         var _loc1_:String = this.getPrice();
         return _loc1_ != null && _loc1_ != "" && _loc1_ != "N.A";
      }
      
      protected function getPrice() : String
      {
         return InstanceMng.getApplication().getInAppsManager().getPriceByDef(this.mItemDef);
      }
      
      protected function beginPurchase(param1:String) : void
      {
         if(!InstanceMng.getUserDataMng().getOwnerUserData().isInBlackList())
         {
            if(!InstanceMng.getUserDataMng().getOwnerUserData().isInDuplicatedList())
            {
               FSDebug.debugTrace("Buy product: " + param1);
               InstanceMng.getApplication().buyProduct(param1,this.mItemDef.getSku());
               this.lockPopup(true);
               InstanceMng.getCurrentScreen().showLoadingIcon(true,false,Align.CENTER,Align.CENTER,1,null,this);
            }
            else
            {
               Utils.setLogText(TextManager.getText("TID_MIGRATION_ERROR_MIGRATED"),true,false,false);
               closePopup();
            }
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_GEN_FRAUD_PURCHASE"),true,false,false);
            closePopup();
         }
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
      
      override public function onClose(param1:Event) : void
      {
         super.onAccept(param1);
         Utils.removeLog();
      }
      
      protected function onAcceptPerformOps() : void
      {
      }
      
      override protected function setupAcceptButton(param1:String, param2:String = "", param3:String = "") : void
      {
         super.setupAcceptButton(param1,param2);
         mAcceptButton.fontSize = FSResourceMng.FONT_STD_SUBTITLE_SIZE;
      }
      
      protected function refreshAcceptButtonState() : void
      {
         var _loc1_:Texture = null;
         var _loc2_:String = null;
         if(this.mItemDef != null && Boolean(mAcceptButton))
         {
            _loc1_ = Root.assets.getTexture(Constants.ACCEPT_BUTTON_UP_NAME);
            mAcceptButton.upState = _loc1_;
            mAcceptButton.downState = _loc1_;
            mAcceptButton.overState = _loc1_;
            mAcceptButton.disabledState = _loc1_;
            mAcceptButton.fontName = FSResourceMng.getFontByType();
            mAcceptButton.fontSize = FSResourceMng.FONT_STD_SUBTITLE_SIZE;
            mAcceptButton.fontColor = 16777215;
            _loc2_ = InstanceMng.getServerConnection() ? InstanceMng.getApplication().getInAppsManager().getPriceByDef(this.mItemDef) : "N.A";
            _loc2_ = _loc2_ != null && _loc2_ != "" ? _loc2_ : "N.A.";
            mAcceptButton.text = _loc2_;
         }
         addChild(mAcceptButton);
      }
      
      public function refreshPrices() : void
      {
         if(this.isProductValidForPurchase())
         {
            this.refreshAcceptButtonState();
         }
      }
      
      public function onPurchaseSuccesful() : void
      {
         this.unlockAfterPurchase();
      }
      
      public function onPurchaseFailed() : void
      {
         this.unlockAfterPurchase();
      }
      
      public function removeTextureItemDef() : Boolean
      {
         return true;
      }
      
      public function getProductId() : String
      {
         return this.mItemDef ? this.mItemDef.getProdId() : "";
      }
   }
}

