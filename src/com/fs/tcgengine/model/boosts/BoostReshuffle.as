package com.fs.tcgengine.model.boosts
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.rules.BoostDef;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.utils.Utils;
   
   public class BoostReshuffle extends Boost
   {
      
      public function BoostReshuffle(param1:BoostDef)
      {
         super(param1);
      }
      
      override public function execute() : void
      {
         var _loc1_:FSBattleScreen = null;
         if(InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            _loc1_ = FSBattleScreen(InstanceMng.getCurrentScreen());
            _loc1_.enableBoostsPanel(false);
            _loc1_.lockUI(true);
            _loc1_.returnOwnerCardsToDeck(this);
            _loc1_.suggestPlayableCardOFF();
            super.execute();
         }
         else
         {
            InstanceMng.getUserDataMng().getOwnerUserData().addBoostToCatalog(mBoostDef.getSku(),1,true);
            InstanceMng.getUserDataMng().updateBoosts();
            Utils.setLogText(TextManager.getText("TID_GEN_PURCHASES_RESTORED"));
         }
      }
      
      override public function onExecuted() : void
      {
         Utils.setLogText(TextManager.getText("TID_BOOST_RESHUFFLED"));
         var _loc1_:FSBattleScreen = FSBattleScreen(InstanceMng.getCurrentScreen());
         _loc1_.enableAfterFreeReshuffle();
      }
   }
}

