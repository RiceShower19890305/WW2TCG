package com.fs.tcgengine.model.boosts
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.model.rules.BoostDef;
   
   public class BoostPurchaseBattlePass extends Boost
   {
      
      public function BoostPurchaseBattlePass(param1:BoostDef)
      {
         super(param1);
      }
      
      override public function execute() : void
      {
         InstanceMng.getUserDataMng().handleBattlePassPurchased();
         super.execute();
      }
   }
}

