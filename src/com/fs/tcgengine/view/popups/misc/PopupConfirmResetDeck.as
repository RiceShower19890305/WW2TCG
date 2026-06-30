package com.fs.tcgengine.view.popups.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.screens.FSDeckBuilderScreen;
   import starling.events.Event;
   
   public class PopupConfirmResetDeck extends PopupStandard
   {
      
      public function PopupConfirmResetDeck(param1:Boolean = true)
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
         if(Boolean(InstanceMng.getCurrentScreen()) && InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).getCurrentCardsPanel().resetDeck();
         }
      }
   }
}

