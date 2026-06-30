package com.fs.tcgengine.model.boosts
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.model.rules.BoostDef;
   
   public class BoostResetDailyQuests extends Boost
   {
      
      public function BoostResetDailyQuests(param1:BoostDef)
      {
         super(param1);
      }
      
      override public function execute() : void
      {
         InstanceMng.getUserDataMng().getOwnerUserData().resetDailyQuestsProgress(false,true);
         super.execute();
      }
   }
}

