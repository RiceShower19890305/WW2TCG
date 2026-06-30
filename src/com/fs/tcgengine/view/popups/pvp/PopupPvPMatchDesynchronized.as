package com.fs.tcgengine.view.popups.pvp
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.screens.FSBattleScreen;
   
   public class PopupPvPMatchDesynchronized extends PopupPvPMatchOver
   {
      
      public function PopupPvPMatchDesynchronized(param1:Boolean = true)
      {
         super(param1);
      }
      
      override protected function createTitle() : void
      {
         super.createTitle();
         mTitle.text = TextManager.getText("TID_GEN_DRAW");
      }
      
      override protected function onAcceptPerformOps() : void
      {
         if(InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            FSBattleScreen(InstanceMng.getCurrentScreen()).performCardsLeavingFX(0,showPvPScreen);
         }
      }
      
      override protected function onPopupOpenTransitionOver() : void
      {
      }
      
      override protected function getGoldWon() : int
      {
         return 0;
      }
   }
}

