package com.fs.tcgengine.view.popups.dungeons
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.screens.FSDungeonsScreen;
   import com.fs.tcgengine.screens.FSRaidsScreen;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.popups.misc.PopupStandard;
   import com.greensock.TweenMax;
   import starling.events.Event;
   import starling.utils.Align;
   
   public class PopupRaidPaymentConfirmation extends PopupStandard
   {
      
      private var mGoldCost:int;
      
      private var mServerResponseReceived:Boolean = false;
      
      public function PopupRaidPaymentConfirmation(param1:Boolean = true)
      {
         super(param1);
      }
      
      public function setGoldCost(param1:int = 0) : void
      {
         var _loc2_:String = null;
         this.mGoldCost = param1;
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
         if(mOnClosedFunction == null)
         {
            if(InstanceMng.getCurrentScreen() is FSRaidsScreen)
            {
               FSRaidsScreen(InstanceMng.getCurrentScreen()).enableRightPanel(true);
            }
         }
         if(mAcceptButton)
         {
            mAcceptButton.enabled = false;
         }
         if(InstanceMng.getCurrentScreen() is FSRaidsScreen)
         {
            FSRaidsScreen(InstanceMng.getCurrentScreen()).disableChooseButtonTemporarily();
            FSRaidsScreen(InstanceMng.getCurrentScreen()).unlockRaidSlotsInfo();
         }
      }
      
      private function performOnAcceptOps() : void
      {
         this.mServerResponseReceived = false;
         InstanceMng.getCurrentScreen().showLoadingIcon(true,false);
         TweenMax.delayedCall(3,this.checkIfServerTimeACK);
         InstanceMng.getServerConnection().getServerTime(this.onServerTimeACK);
      }
      
      private function onServerTimeACK(param1:Object) : void
      {
         if(!this.mServerResponseReceived)
         {
            onConnectionChange();
            this.mServerResponseReceived = true;
            InstanceMng.getCurrentScreen().showLoadingIcon(false,false,Align.CENTER,Align.CENTER,1,null,this);
            TweenMax.killDelayedCallsTo(this.checkIfServerTimeACK);
            if(InstanceMng.getCurrentScreen() is FSRaidsScreen)
            {
               FSRaidsScreen(InstanceMng.getCurrentScreen()).onPaymentCompleted(this.mGoldCost);
            }
         }
      }
      
      private function checkIfServerTimeACK() : void
      {
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
         super.setupAcceptButton(_loc4_,param2,param3);
      }
      
      override public function allowClosureTappingBG() : Boolean
      {
         return false;
      }
      
      override protected function removeFromStage() : void
      {
         super.removeFromStage();
         InstanceMng.getPopupMng().removePopup(FSPopupMng.RAID_PAYMENT_CONFIRMATION);
      }
   }
}

