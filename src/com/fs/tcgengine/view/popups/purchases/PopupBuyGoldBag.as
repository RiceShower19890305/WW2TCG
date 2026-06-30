package com.fs.tcgengine.view.popups.purchases
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.model.rules.GoldDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSDungeonsScreen;
   import com.fs.tcgengine.screens.FSShopScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.shop.FSShopItem;
   import com.greensock.TweenMax;
   import starling.events.Event;
   
   public class PopupBuyGoldBag extends PopupBuyProduct
   {
      
      private var mGoToShopButton:FSButton;
      
      public function PopupBuyGoldBag(param1:Boolean = true)
      {
         super(param1);
      }
      
      override protected function createUI() : void
      {
         if(Boolean(mItemDef) && mFullyLoaded)
         {
            super.createUI();
            this.createShopButton(FSShopItem.BUY_BUTTON_GOLD_NAME);
         }
      }
      
      protected function createShopButton(param1:String) : void
      {
         if(mAcceptButton)
         {
            mAcceptButton.readjustSize();
            mAcceptButton.alignPivot();
            mAcceptButton.x = mBox.x + mBox.width * 0.3;
            mAcceptButton.y = mBox.height - mAcceptButton.height / 3;
         }
         if(this.mGoToShopButton == null)
         {
            this.mGoToShopButton = new FSButton(Root.assets.getTexture(param1),TextManager.getText("TID_GEN_MORE_OPTIONS"));
            this.mGoToShopButton.fontSize = FSResourceMng.FONT_STD_SUBTITLE_SIZE;
            this.mGoToShopButton.readjustSize();
            this.mGoToShopButton.alignPivot();
            this.mGoToShopButton.x = mBox.x + mBox.width * 0.7;
            this.mGoToShopButton.y = mAcceptButton.y;
            this.mGoToShopButton.addEventListener(Event.TRIGGERED,this.onGoToShopButton);
            addChild(this.mGoToShopButton);
         }
         this.mGoToShopButton.enabled = InstanceMng.getServerConnection().isUserLoggedIn();
      }
      
      private function onGoToShopButton(param1:Event) : void
      {
         var _loc2_:String = null;
         if(InstanceMng.getCurrentScreen())
         {
            if(InstanceMng.getTutorialMng())
            {
               if(InstanceMng.getTutorialMng().isTutorialOver())
               {
                  if(!Utils.smInternetAvailable || !InstanceMng.getServerConnection().isUserLoggedIn())
                  {
                     Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true);
                     InstanceMng.getCurrentScreen().onConnectionLost();
                  }
                  else if(Utils.smInternetAvailable || Config.isDebug())
                  {
                     if(!Screen.isScreenLocked())
                     {
                        if(this.mGoToShopButton)
                        {
                           this.mGoToShopButton.disableTemporarily(4);
                        }
                        closePopup(this.onEligibleToVisitShopProceed);
                     }
                     else
                     {
                        TweenMax.delayedCall(0.1,this.onGoToShopButton,[null]);
                     }
                  }
                  else
                  {
                     Utils.setLogText(TextManager.getText("TID_SHOP_APPSTORE_RETRY"),true);
                  }
               }
               else
               {
                  _loc2_ = TextManager.replaceParameters(TextManager.getText("TID_SHOP_LOCKED"),[InstanceMng.getTutorialMng().getFirstNonTutorialLevelIndex()]);
                  Utils.setLogText(_loc2_,true);
               }
            }
         }
      }
      
      protected function onEligibleToVisitShopProceed() : void
      {
         Main.smData["shop_category"] = FSShopScreen.CATEGORY_3_GOLD;
         InstanceMng.getCurrentScreen().dispatchEventWith(Screen.GO_TO_SHOP,true);
      }
      
      override public function onClose(param1:Event) : void
      {
         super.onClose(param1);
         if(Boolean(InstanceMng.getCurrentScreen()) && InstanceMng.getCurrentScreen() is FSDungeonsScreen)
         {
            FSDungeonsScreen(InstanceMng.getCurrentScreen()).disableChooseButtonTemporarily();
            FSDungeonsScreen(InstanceMng.getCurrentScreen()).enableRightPanel(true);
         }
      }
      
      override protected function removeFromStage() : void
      {
         if(this.mGoToShopButton)
         {
            this.mGoToShopButton.removeFromParent(true);
            this.mGoToShopButton = null;
         }
         InstanceMng.getPopupMng().removePopup(FSPopupMng.BUY_GOLD_BAG_POPUP_NAME);
         super.removeFromStage();
      }
      
      override protected function onAccept(param1:Event) : void
      {
         var _loc2_:String = null;
         if(isProductValidForPurchase())
         {
            _loc2_ = GoldDef(mItemDef).getProdId();
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
      
      protected function performOpsOnSuccesfulPurchase() : void
      {
         var _loc1_:int = GoldDef(mItemDef).getGold();
         InstanceMng.getUserDataMng().getOwnerUserData().addGold(_loc1_);
         InstanceMng.getServerConnection().shareGoldPurchasedWithGuild(_loc1_,GoldDef(mItemDef));
         if(InstanceMng.getCurrentScreen() != null && InstanceMng.getCurrentScreen() is FSDungeonsScreen)
         {
            FSDungeonsScreen(InstanceMng.getCurrentScreen()).disableChooseButtonTemporarily();
         }
      }
      
      override public function onPurchaseFailed() : void
      {
         super.onPurchaseFailed();
         closePopup();
         if(InstanceMng.getCurrentScreen() != null && InstanceMng.getCurrentScreen() is FSDungeonsScreen)
         {
            FSDungeonsScreen(InstanceMng.getCurrentScreen()).disableChooseButtonTemporarily();
         }
      }
      
      override protected function lockPopup(param1:Boolean) : void
      {
         super.lockPopup(param1);
         if(this.mGoToShopButton)
         {
            this.mGoToShopButton.enabled = !param1;
         }
      }
   }
}

