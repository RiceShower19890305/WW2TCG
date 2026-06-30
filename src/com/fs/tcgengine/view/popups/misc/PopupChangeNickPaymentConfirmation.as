package com.fs.tcgengine.view.popups.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.screens.FSDungeonsScreen;
   import com.fs.tcgengine.screens.FSPvPScreen;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.popups.Popup;
   import com.greensock.TweenMax;
   import starling.events.Event;
   import starling.utils.Align;
   
   public class PopupChangeNickPaymentConfirmation extends PopupStandard
   {
      
      private var mGoldCost:int;
      
      private var mServerResponseReceived:Boolean = false;
      
      private var mNewName:String;
      
      private var mParentPopup:Popup;
      
      public function PopupChangeNickPaymentConfirmation(param1:Boolean = true)
      {
         super(param1);
      }
      
      public function setGoldCost(param1:int = 0) : void
      {
         var _loc2_:String = null;
         this.mGoldCost = param1;
         if(!InstanceMng.getUserDataMng().getOwnerUserData().flagsIsFirstChangeName())
         {
            this.mGoldCost = 0;
         }
         if(mAcceptButton)
         {
            _loc2_ = this.mGoldCost == 0 ? TextManager.getText("TID_GEN_FREE") : this.mGoldCost.toString();
            mAcceptButton.text = _loc2_;
         }
      }
      
      override protected function onAccept(param1:Event) : void
      {
         closePopup(this.performOnAcceptOps);
      }
      
      override public function onClose(param1:Event) : void
      {
         super.onClose(param1);
         if(mAcceptButton)
         {
            mAcceptButton.enabled = false;
         }
         if(this.mParentPopup is PopupEditProfile)
         {
            PopupEditProfile(this.mParentPopup).resetOriginalName();
         }
      }
      
      private function performOnAcceptOps() : void
      {
         this.mServerResponseReceived = false;
         InstanceMng.getCurrentScreen().showLoadingIcon(true,false);
         InstanceMng.getServerConnection().checkIfNickAvailable(this.mNewName.toLowerCase(),this.payChangeNickCost,null,this.onNickChangeFailed);
      }
      
      private function onNickChangeFailed() : void
      {
         if(InstanceMng.getPopupMng().getPopupInBackground() is PopupEditProfile)
         {
            PopupEditProfile(InstanceMng.getPopupMng().getPopupInBackground()).onNickNotAvailableCommonOps();
         }
      }
      
      private function payChangeNickCost() : void
      {
         var onNickChangePayed:Function = null;
         onNickChangePayed = function():void
         {
            if(InstanceMng.getPopupMng().getPopupInBackground() is PopupEditProfile)
            {
               PopupEditProfile(InstanceMng.getPopupMng().getPopupInBackground()).onNickAvailableCommonOps();
            }
            FSTracker.trackMiscAction(FSTracker.CATEGORY_MISC,FSTracker.ACTION_NICK_CHANGED,{
               "oldNick":InstanceMng.getUserDataMng().getOwnerUserData().getName(),
               "newNick":mNewName
            });
            InstanceMng.getUserDataMng().getOwnerUserData().setName(mNewName.toLowerCase());
            if(mNewName != "" && mNewName != null)
            {
               InstanceMng.getServerConnection().updateNick(mNewName);
            }
            if(InstanceMng.getCurrentScreen() is FSPvPScreen)
            {
               FSPvPScreen(InstanceMng.getCurrentScreen()).updateCustomizePlayerInfo();
            }
            Utils.setLogText(TextManager.getText("TID_DATA_SAVED"));
            if(InstanceMng.getPopupMng().getPopupInBackground() is PopupEditProfile)
            {
               PopupEditProfile(InstanceMng.getPopupMng().getPopupInBackground()).setFutureName(null);
            }
            if(!InstanceMng.getUserDataMng().getOwnerUserData().flagsIsFirstChangeName() && mGoldCost == 0)
            {
               InstanceMng.getUserDataMng().getOwnerUserData().setFirstChangeName(true);
            }
            InstanceMng.getUserDataMng().persistenceSaveData();
         };
         if(this.mGoldCost != 0)
         {
            InstanceMng.getUserDataMng().getOwnerUserData().substractGold(-this.mGoldCost,onNickChangePayed,null,Utils.showNotEnoughCurrencyMessage,[ServerConnection.CURRENCY_GOLD]);
         }
         else
         {
            onNickChangePayed();
         }
      }
      
      private function onServerTimeACK(param1:Object) : void
      {
         if(!this.mServerResponseReceived)
         {
            onConnectionChange();
            this.mServerResponseReceived = true;
            InstanceMng.getCurrentScreen().showLoadingIcon(false,false,Align.CENTER,Align.CENTER,1,null,this);
            TweenMax.killDelayedCallsTo(this.checkIfServerTimeACK);
            this.payChangeNickCost();
         }
      }
      
      private function checkIfServerTimeACK() : void
      {
         Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true);
         InstanceMng.getCurrentScreen().onConnectionLost();
         Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true);
         if(InstanceMng.getCurrentScreen() is FSDungeonsScreen)
         {
            FSDungeonsScreen(InstanceMng.getCurrentScreen()).disableChooseButtonTemporarily();
         }
         InstanceMng.getCurrentScreen().showLoadingIcon(false,false,Align.CENTER,Align.CENTER,1,null,this);
      }
      
      override protected function setupAcceptButton(param1:String, param2:String = "", param3:String = "") : void
      {
         var _loc4_:String = this.mGoldCost == 0 ? TextManager.getText("TID_GEN_FREE") : this.mGoldCost.toString();
         super.setupAcceptButton(_loc4_,"buy_gold_button","buy_gold_button");
      }
      
      override public function allowClosureTappingBG() : Boolean
      {
         return false;
      }
      
      public function setNewName(param1:String) : void
      {
         this.mNewName = param1;
      }
      
      public function setParentPopup(param1:Popup) : void
      {
         this.mParentPopup = param1;
      }
      
      override public function dispose() : void
      {
         this.mParentPopup = null;
         super.dispose();
      }
   }
}

