package com.fs.tcgengine.model.boosts
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.model.rules.BoostDef;
   
   public class BoostBestHand extends Boost
   {
      
      public function BoostBestHand(param1:BoostDef)
      {
         super(param1);
      }
      
      override public function execute() : void
      {
         if(InstanceMng.getBattleEngine())
         {
            InstanceMng.getBattleEngine().setNextHandDealTopCards(true);
         }
         super.execute();
      }
   }
}

