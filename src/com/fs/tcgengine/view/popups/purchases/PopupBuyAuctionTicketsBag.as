package com.fs.tcgengine.view.popups.purchases
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.model.rules.AuctionTicketDef;
   import com.fs.tcgengine.screens.FSShopScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.shop.FSShopItem;
   import starling.events.Event;
   
   public class PopupBuyAuctionTicketsBag extends PopupBuyGoldBag
   {
      
      public function PopupBuyAuctionTicketsBag(param1:Boolean = true)
      {
         super(param1);
      }
      
      override protected function removeFromStage() : void
      {
         super.removeFromStage();
         InstanceMng.getPopupMng().removePopup(FSPopupMng.AUCTION_TICKET_BUY);
      }
      
      override protected function createShopButton(param1:String) : void
      {
         super.createShopButton(FSShopItem.BUY_BUTTON_TOKENS_NAME);
      }
      
      override protected function onEligibleToVisitShopProceed() : void
      {
         Main.smData["shop_category"] = FSShopScreen.CATEGORY_4_AH_TOKENS;
         InstanceMng.getCurrentScreen().dispatchEventWith(Screen.GO_TO_SHOP,true);
      }
      
      override protected function onAccept(param1:Event) : void
      {
         var _loc2_:String = null;
         if(isProductValidForPurchase())
         {
            _loc2_ = AuctionTicketDef(mItemDef).getProdId();
            beginPurchase(_loc2_);
         }
         else
         {
            closePopup();
            Utils.setLogText(TextManager.getText("TID_SHOP_NOVERIFIED"),true);
         }
      }
      
      override protected function performOpsOnSuccesfulPurchase() : void
      {
         InstanceMng.getUserDataMng().getOwnerUserData().addAuctionTickets(AuctionTicketDef(mItemDef).getTokens());
      }
   }
}

