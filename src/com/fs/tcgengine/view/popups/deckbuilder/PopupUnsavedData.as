package com.fs.tcgengine.view.popups.deckbuilder
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.screens.FSDeckBuilderScreen;
   import com.fs.tcgengine.view.popups.misc.PopupStandard;
   import starling.events.Event;
   
   public class PopupUnsavedData extends PopupStandard
   {
      
      public function PopupUnsavedData(param1:Boolean = true)
      {
         super(param1);
      }
      
      override protected function onAccept(param1:Event) : void
      {
         var _loc2_:FSDeckBuilderScreen = null;
         super.onAccept(param1);
         if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            _loc2_ = FSDeckBuilderScreen(InstanceMng.getCurrentScreen());
            if(_loc2_ != null)
            {
               if(_loc2_.isExitRequested())
               {
                  mOnClosedFunction = _loc2_.showMap;
               }
               else if(_loc2_.getCurrentCardsPanel() != null)
               {
                  mOnClosedFunction = this.onClosePerformOps;
               }
            }
         }
      }
      
      private function onClosePerformOps() : void
      {
         var _loc1_:FSDeckBuilderScreen = null;
         if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            _loc1_ = FSDeckBuilderScreen(InstanceMng.getCurrentScreen());
            if(_loc1_ != null)
            {
               if(_loc1_.getCurrentCardsPanel())
               {
                  _loc1_.getCurrentCardsPanel().removeDeckCardsLoaded();
                  _loc1_.getCurrentCardsPanel().showForegroundAnim(false);
               }
            }
         }
      }
      
      override public function onClose(param1:Event) : void
      {
         var _loc2_:FSDeckBuilderScreen = null;
         closePopup();
         if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            _loc2_ = FSDeckBuilderScreen(InstanceMng.getCurrentScreen());
            if(_loc2_ != null)
            {
               _loc2_.setExitRequested(false);
            }
         }
      }
   }
}

