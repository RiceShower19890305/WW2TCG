package com.fs.tcgengine.view.popups.purchases
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.controller.rules.PacksDefMng;
   import com.fs.tcgengine.model.rules.GoldDef;
   import com.fs.tcgengine.model.rules.PackDef;
   import com.fs.tcgengine.screens.FSDungeonsScreen;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.misc.FSImage;
   import starling.events.Event;
   
   public class PopupBuyVIPPack extends PopupBuyProduct
   {
      
      public function PopupBuyVIPPack(param1:Boolean = true)
      {
         super(param1);
      }
      
      override public function openPopup(param1:FSCoordinate = null) : void
      {
         super.openPopup(param1);
         InstanceMng.getUserDataMng().updateLastTimeVIPOfferSeenMS();
      }
      
      override protected function createItemImage() : void
      {
         if(mItemDef != null)
         {
            if(mItemImage == null)
            {
               mItemImage = new FSImage(Root.assets.getTexture(mItemDef.getBGImageName()));
            }
            else
            {
               mItemImage.texture = Root.assets.getTexture(mItemDef.getBGImageName());
            }
            mItemImage.x = mBox.width / 2 - mItemImage.width / 2;
            mItemImage.y = mTitleTextfield.y + mTitleTextfield.height / 1.5;
            addChild(mItemImage);
         }
      }
      
      override protected function createProdDesc() : void
      {
         var _loc1_:String = null;
         super.createProdDesc();
         if(mItemDescription)
         {
            _loc1_ = mItemDef.getDesc() != null ? mItemDef.getDesc() : "";
            if(Utils.isBrowser())
            {
               _loc1_ = InstanceMng.getApplication().isKongregateVersion() ? TextManager.getText(mItemDef.getDescTID() + "_KONG",true) : TextManager.getText(mItemDef.getDescTID() + "_FB",true);
            }
            mItemDescription.text = _loc1_;
         }
      }
      
      override protected function onAccept(param1:Event) : void
      {
         var _loc2_:String = null;
         if(isProductValidForPurchase())
         {
            _loc2_ = mItemDef.getProdId();
            beginPurchase(_loc2_);
         }
         else
         {
            closePopup();
            Utils.setLogText(TextManager.getText("TID_SHOP_NOVERIFIED"),true);
         }
      }
      
      override public function onPurchaseSuccesful() : void
      {
         super.onPurchaseSuccesful();
         closePopup(this.performOpsOnSuccesfulPurchase);
      }
      
      private function performOpsOnSuccesfulPurchase() : void
      {
         var _loc1_:int = 0;
         if(mItemDef is PackDef)
         {
            if(PackDef(mItemDef).getTokens() > 0)
            {
               InstanceMng.getUserDataMng().getOwnerUserData().addAuctionTickets(PackDef(mItemDef).getTokens());
            }
            Utils.setLogText(TextManager.getText("TID_SHOP_PACK_SUCCESS"));
            Utils.openPack(PackDef(mItemDef),PacksDefMng.PACK_ANY);
         }
         else if(mItemDef is GoldDef)
         {
            if(GoldDef(mItemDef).getTokens() > 0)
            {
               InstanceMng.getUserDataMng().getOwnerUserData().addAuctionTickets(GoldDef(mItemDef).getTokens());
            }
            Utils.setLogText(TextManager.getText("TID_SHOP_GOLD_BAG_SUCCESS"));
            _loc1_ = GoldDef(mItemDef).getGold();
            InstanceMng.getUserDataMng().getOwnerUserData().addGold(_loc1_);
            InstanceMng.getServerConnection().shareGoldPurchasedWithGuild(_loc1_,GoldDef(mItemDef));
            if(InstanceMng.getCurrentScreen() != null && InstanceMng.getCurrentScreen() is FSDungeonsScreen)
            {
               FSDungeonsScreen(InstanceMng.getCurrentScreen()).disableChooseButtonTemporarily();
            }
         }
      }
   }
}

