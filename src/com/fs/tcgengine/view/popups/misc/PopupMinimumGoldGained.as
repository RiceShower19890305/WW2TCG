package com.fs.tcgengine.view.popups.misc
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.Utils;
   import starling.events.Event;
   
   public class PopupMinimumGoldGained extends PopupStandard
   {
      
      public function PopupMinimumGoldGained(param1:Boolean = true)
      {
         super(param1);
      }
      
      override protected function removeFromStage() : void
      {
         InstanceMng.getPopupMng().removePopup(FSPopupMng.GOLD_MIN_ACHIEVED_POPUP_NAME);
         super.removeFromStage();
      }
      
      override protected function onPopupOpenTransitionOver() : void
      {
         if(!mClosed)
         {
            InstanceMng.getUserDataMng().getOwnerUserData().set250GoldPopupShown(true);
            InstanceMng.getUserDataMng().updateFlags();
         }
         super.onPopupOpenTransitionOver();
      }
      
      override protected function setupAcceptButton(param1:String, param2:String = "", param3:String = "") : void
      {
         super.setupAcceptButton(TextManager.getText("TID_GEN_MENU_SHOP"),Constants.ACCEPT_GREEN_BUTTON_UP_NAME);
         if(mAcceptButton)
         {
            Utils.setupButton9Scale(mAcceptButton,7.5,15,10,5,88.5,31.75);
         }
      }
      
      override protected function onAccept(param1:Event) : void
      {
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            super.onAccept(param1);
            mOnClosedFunction = this.onAcceptPerformOps;
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true);
            InstanceMng.getCurrentScreen().onConnectionLost();
         }
      }
      
      private function onAcceptPerformOps() : void
      {
         InstanceMng.getCurrentScreen().dispatchEventWith(Screen.GO_TO_SHOP,true);
      }
      
      override public function allowClosureTappingBG() : Boolean
      {
         return false;
      }
   }
}

