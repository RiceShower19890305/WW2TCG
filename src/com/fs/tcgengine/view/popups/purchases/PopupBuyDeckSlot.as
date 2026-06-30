package com.fs.tcgengine.view.popups.purchases
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.model.rules.DeckSlotDef;
   import com.fs.tcgengine.screens.FSDeckBuilderScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.misc.DeckTitleDeckBuilder;
   import starling.events.Event;
   
   public class PopupBuyDeckSlot extends PopupBuyProduct
   {
      
      private var mDeckTitle:DeckTitleDeckBuilder;
      
      public function PopupBuyDeckSlot(param1:Boolean = true)
      {
         super(param1);
      }
      
      override protected function removeFromStage() : void
      {
         if(this.mDeckTitle)
         {
            this.mDeckTitle.removeFromParent(true);
            this.mDeckTitle = null;
         }
         InstanceMng.getPopupMng().removePopup(FSPopupMng.BUY_DECK_SLOT_POPUP_NAME);
         super.removeFromStage();
      }
      
      override protected function onAccept(param1:Event) : void
      {
         var _loc2_:String = null;
         if(isProductValidForPurchase())
         {
            _loc2_ = DeckSlotDef(mItemDef).getProdId();
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
         InstanceMng.getUserDataMng().userPurchasedDeck();
         var _loc1_:Screen = InstanceMng.getCurrentScreen();
         if(_loc1_ != null && _loc1_ is FSDeckBuilderScreen)
         {
            if(FSDeckBuilderScreen(_loc1_).getDeckSelector() != null)
            {
               FSDeckBuilderScreen(_loc1_).getDeckSelector().refresh();
            }
         }
      }
      
      override public function onPurchaseFailed() : void
      {
         super.onPurchaseFailed();
         closePopup();
      }
      
      override public function unlockAfterPurchase() : void
      {
         super.unlockAfterPurchase();
         if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).lockUI(false);
         }
      }
   }
}

