package com.fs.tcgengine.model.boosts
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.rules.BoostDef;
   import com.fs.tcgengine.utils.Utils;
   
   public class BoostIncreaseRank extends Boost
   {
      
      public function BoostIncreaseRank(param1:BoostDef)
      {
         super(param1);
         mWaitTime = 0;
      }
      
      override public function execute() : void
      {
         if(InstanceMng.getBattleEngine())
         {
            InstanceMng.getBattleEngine().setNextHandIncreasesRank(mBoostDef.getValue());
         }
         else
         {
            InstanceMng.getUserDataMng().getOwnerUserData().addBoostToCatalog(mBoostDef.getSku(),1,true);
            InstanceMng.getUserDataMng().updateBoosts();
            Utils.setLogText(TextManager.getText("TID_GEN_PURCHASES_RESTORED"));
         }
         super.execute();
      }
   }
}

