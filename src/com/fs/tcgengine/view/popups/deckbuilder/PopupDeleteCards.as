package com.fs.tcgengine.view.popups.deckbuilder
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.screens.FSDeckBuilderScreen;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.popups.misc.PopupStandard;
   import starling.events.Event;
   
   public class PopupDeleteCards extends PopupStandard
   {
      
      public function PopupDeleteCards(param1:Boolean = true)
      {
         super(param1);
      }
      
      override protected function onAccept(param1:Event) : void
      {
         super.onAccept(param1);
         if(InstanceMng.getServerConnection().isUserLoggedIn() && Utils.smInternetAvailable && InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            mOnClosedFunction = FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).getRecyclePanel().onAcceptPerformOps;
         }
      }
      
      override public function onConnectionChange() : void
      {
         super.onConnectionChange();
         if(mAcceptButton)
         {
            mAcceptButton.enabled = InstanceMng.getServerConnection().isUserLoggedIn() && Utils.smInternetAvailable;
         }
      }
   }
}

