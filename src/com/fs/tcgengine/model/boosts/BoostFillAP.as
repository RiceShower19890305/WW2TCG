package com.fs.tcgengine.model.boosts
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.rules.BoostDef;
   import com.fs.tcgengine.model.userdata.UserBattleInfo;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.utils.Utils;
   
   public class BoostFillAP extends Boost
   {
      
      public function BoostFillAP(param1:BoostDef)
      {
         super(param1);
      }
      
      override public function execute() : void
      {
         var _loc1_:UserBattleInfo = null;
         var _loc2_:BattleEngine = InstanceMng.getBattleEngine();
         if(_loc2_ != null)
         {
            _loc1_ = _loc2_.getOwnerBattleInfo();
            if(_loc1_ != null)
            {
               BattleEngine.smFillAPBoostRecentlyPurchased = false;
               _loc1_.resetActionPoints();
               if(InstanceMng.getCurrentScreen() is FSBattleScreen)
               {
                  FSBattleScreen(InstanceMng.getCurrentScreen()).updateActionPointsLeft();
               }
               _loc2_.addBoosterUsed(mBoostDef.getSku());
               if(InstanceMng.getCurrentScreen() is FSBattleScreen)
               {
                  if(_loc2_.isOwnerPowerActive())
                  {
                     FSBattleScreen(InstanceMng.getCurrentScreen()).hideCancelPower(true);
                  }
                  FSBattleScreen(InstanceMng.getCurrentScreen()).suggestPlayableCardON();
               }
               Utils.setLogText(TextManager.getText("TID_BOOST_ACTION_RESTORED"));
               super.execute();
            }
         }
         else
         {
            InstanceMng.getUserDataMng().getOwnerUserData().addBoostToCatalog(mBoostDef.getSku(),1,true);
            InstanceMng.getUserDataMng().updateBoosts();
         }
      }
   }
}

