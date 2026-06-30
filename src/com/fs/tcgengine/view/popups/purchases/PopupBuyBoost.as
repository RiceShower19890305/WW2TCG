package com.fs.tcgengine.view.popups.purchases
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.model.rules.BoostDef;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.misc.BoostItem;
   import com.fs.tcgengine.view.misc.FSImage;
   import starling.events.Event;
   
   public class PopupBuyBoost extends PopupBuyProduct
   {
      
      protected var mBoostItem:BoostItem;
      
      protected var mBoostDef:BoostDef;
      
      public function PopupBuyBoost(param1:Boolean = true)
      {
         super(param1);
      }
      
      public function setBoostItem(param1:BoostItem) : void
      {
         this.mBoostItem = param1;
         if(this.mBoostItem)
         {
            this.mBoostDef = this.mBoostItem.getBoostDef();
         }
         createUI();
      }
      
      public function setBoostDef(param1:BoostDef) : void
      {
         this.mBoostDef = param1;
      }
      
      override protected function removeFromStage() : void
      {
         Root.assets.removeTexture(BoostDef(mItemDef).getBGBuy());
         InstanceMng.getPopupMng().removePopup(FSPopupMng.BUY_BOOST_POPUP_NAME);
         super.removeFromStage();
      }
      
      override public function dispose() : void
      {
         this.mBoostItem = null;
         super.dispose();
      }
      
      override protected function onAccept(param1:Event) : void
      {
         var _loc2_:String = null;
         if(isProductValidForPurchase())
         {
            _loc2_ = BoostDef(mItemDef).getProdId();
            beginPurchase(_loc2_);
         }
         else
         {
            closePopup();
            Utils.setLogText(TextManager.getText("TID_SHOP_NOVERIFIED"),true);
         }
      }
      
      override protected function createItemImage() : void
      {
         if(mItemDef != null)
         {
            if(mItemImage == null)
            {
               mItemImage = new FSImage(Root.assets.getTexture(BoostDef(mItemDef).getBGBuy()));
            }
            else
            {
               mItemImage.texture = Root.assets.getTexture(BoostDef(mItemDef).getBGBuy());
            }
            mItemImage.x = mBox.width / 2 - mItemImage.width / 2;
            mItemImage.y = mTitleTextfield.y + mTitleTextfield.height / 2;
            addChild(mItemImage);
         }
      }
      
      override public function onPurchaseSuccesful() : void
      {
         unlockAfterPurchase();
         closePopup(this.performOpsOnSuccesfulPurchase);
      }
      
      protected function performOpsOnSuccesfulPurchase() : void
      {
         if(InstanceMng.getBattleEngine() != null && !InstanceMng.getBattleEngine().isPvPMatch())
         {
            BattleEngine.smFillAPBoostRecentlyPurchased = true;
         }
         if(this.mBoostItem)
         {
            InstanceMng.getUserDataMng().userPurchasedBoost(this.mBoostItem.getBoostDef().getSku(),1);
            this.mBoostItem.updateAmount();
         }
         else if(this.mBoostDef)
         {
            InstanceMng.getUserDataMng().userPurchasedBoost(this.mBoostDef.getSku(),1);
         }
      }
      
      override public function onPurchaseFailed() : void
      {
         unlockAfterPurchase();
      }
   }
}

