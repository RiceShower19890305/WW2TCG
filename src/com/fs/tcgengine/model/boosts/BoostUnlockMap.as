package com.fs.tcgengine.model.boosts
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.model.rules.BoostDef;
   
   public class BoostUnlockMap extends Boost
   {
      
      public function BoostUnlockMap(param1:BoostDef)
      {
         super(param1);
      }
      
      override public function execute() : void
      {
         InstanceMng.getUserDataMng().onMapUnlockedPerformOperations();
         super.execute();
      }
   }
}

