package com.fs.tcgengine.view.popups.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.screens.FSDungeonsScreen;
   import starling.events.Event;
   
   public class PopupConfirmLeaveDungeonScreen extends PopupStandard
   {
      
      public function PopupConfirmLeaveDungeonScreen(param1:Boolean = true)
      {
         super(param1);
      }
      
      override protected function onAccept(param1:Event) : void
      {
         super.onAccept(param1);
         mOnClosedFunction = this.onClosedPerformOps;
         if(InstanceMng.getCurrentScreen() is FSDungeonsScreen)
         {
            FSDungeonsScreen(InstanceMng.getCurrentScreen()).disableChooseButtonTemporarily();
         }
      }
      
      private function onClosedPerformOps() : void
      {
         if(InstanceMng.getCurrentScreen() is FSDungeonsScreen)
         {
            FSDungeonsScreen(InstanceMng.getCurrentScreen()).showMap();
         }
      }
   }
}

