package com.fs.tcgengine.view.popups.dungeons
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.screens.FSDungeonsScreen;
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.popups.misc.PopupStandard;
   import com.greensock.TweenMax;
   import starling.events.Event;
   import starling.utils.Align;
   
   public class PopupDungeonPaymentConfirmation extends PopupStandard
   {
      
      private var mGoldCost:FSNumber;
      
      private var mServerResponseReceived:Boolean = false;
      
      public function PopupDungeonPaymentConfirmation(param1:Boolean = true)
      {
         if(this.mGoldCost == null)
         {
            this.mGoldCost = new FSNumber();
         }
         super(param1);
      }
      
      public function setGoldCost(param1:FSNumber) : void
      {
         var _loc2_:String = null;
         if(this.mGoldCost == null)
         {
            this.mGoldCost = new FSNumber();
         }
         this.mGoldCost.value = param1.value;
         if(mAcceptButton)
         {
            _loc2_ = this.mGoldCost.value == 0 ? TextManager.getText("TID_GEN_FREE") : this.mGoldCost.value.toString();
            mAcceptButton.text = _loc2_;
         }
      }
      
      override protected function onAccept(param1:Event) : void
      {
         if(InstanceMng.getCurrentScreen() is FSDungeonsScreen)
         {
            FSDungeonsScreen(InstanceMng.getCurrentScreen()).enableRightPanel(false);
         }
         closePopup(this.performOnAcceptOps);
      }
      
      override public function onClose(param1:Event) : void
      {
         super.onClose(param1);
         if(mOnClosedFunction == null)
         {
            if(InstanceMng.getCurrentScreen() is FSDungeonsScreen)
            {
               FSDungeonsScreen(InstanceMng.getCurrentScreen()).enableRightPanel(true);
            }
         }
         if(mAcceptButton)
         {
            mAcceptButton.enabled = false;
         }
         if(InstanceMng.getCurrentScreen() is FSDungeonsScreen)
         {
            FSDungeonsScreen(InstanceMng.getCurrentScreen()).disableChooseButtonTemporarily();
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
            if(InstanceMng.getCurrentScreen() is FSDungeonsScreen)
            {
               FSDungeonsScreen(InstanceMng.getCurrentScreen()).onPaymentCompleted(this.mGoldCost);
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
         var _loc4_:String = Boolean(this.mGoldCost) && this.mGoldCost.value == 0 ? TextManager.getText("TID_GEN_FREE") : this.mGoldCost.value.toString();
         super.setupAcceptButton(_loc4_,param2,param3);
      }
      
      override public function allowClosureTappingBG() : Boolean
      {
         return false;
      }
      
      override protected function removeFromStage() : void
      {
         super.removeFromStage();
      }
   }
}

