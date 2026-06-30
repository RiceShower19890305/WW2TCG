package com.fs.tcgengine.view.popups.misc
{
   import com.fs.tcgengine.controller.PvPConnectionMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.utils.Utils;
   import starling.events.Event;
   
   public class PopupConfirmLeavePvPQueue extends PopupStandard
   {
      
      public function PopupConfirmLeavePvPQueue(param1:Boolean = true)
      {
         super(param1);
      }
      
      override protected function onAccept(param1:Event) : void
      {
         super.onAccept(param1);
         mOnClosedFunction = this.onClosedPerformOps;
      }
      
      private function onClosedPerformOps() : void
      {
         PvPConnectionMng.removeFromPvPQueue(true);
         Utils.setLogText(TextManager.getText("TID_PVP_QUEUE_LEFT"));
      }
   }
}

