package com.fs.tcgengine.view.popups.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.controller.FSFacebookPlugin;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.popups.Popup;
   import starling.events.Event;
   
   public class PopupLogoutFromFB extends PopupStandard
   {
      
      public function PopupLogoutFromFB(param1:Boolean = true)
      {
         super(param1);
      }
      
      override protected function onAccept(param1:Event) : void
      {
         super.onAccept(param1);
         var _loc2_:Popup = InstanceMng.getPopupMng().getPopupInBackground();
         if(_loc2_ != null && _loc2_ is PopupSettings)
         {
            _loc2_.closePopup();
         }
         mOnClosedFunction = this.onClosePerformOps;
      }
      
      private function onClosePerformOps() : void
      {
         var _loc1_:FSFacebookPlugin = null;
         if(Utils.smInternetAvailable)
         {
            _loc1_ = InstanceMng.getFacebookPlugin();
            if(_loc1_ != null && _loc1_.isSessionOpen())
            {
               _loc1_.logout();
            }
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true);
            InstanceMng.getCurrentScreen().onConnectionLost();
         }
      }
      
      override public function onClose(param1:Event) : void
      {
         closePopup();
      }
   }
}

