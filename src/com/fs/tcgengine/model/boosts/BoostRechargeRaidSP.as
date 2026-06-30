package com.fs.tcgengine.model.boosts
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.model.rules.BoostDef;
   import com.fs.tcgengine.screens.FSRaidsScreen;
   
   public class BoostRechargeRaidSP extends Boost
   {
      
      public function BoostRechargeRaidSP(param1:BoostDef)
      {
         super(param1);
      }
      
      override public function execute() : void
      {
         InstanceMng.getUserDataMng().getOwnerUserData().addRaidTicketsSP(Config.getConfig().getRaidTicketsSinglePlayer().value);
         var _loc1_:FSRaidsScreen = InstanceMng.getCurrentScreen() as FSRaidsScreen;
         if(_loc1_)
         {
            _loc1_.updateTicketsRaidSingleplayerTextfield();
         }
         super.execute();
      }
   }
}

