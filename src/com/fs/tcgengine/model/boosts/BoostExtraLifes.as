package com.fs.tcgengine.model.boosts
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.rules.BoostDef;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.utils.Utils;
   
   public class BoostExtraLifes extends Boost
   {
      
      public function BoostExtraLifes(param1:BoostDef)
      {
         super(param1);
      }
      
      override public function execute() : void
      {
         var _loc1_:int = 0;
         var _loc2_:UserDataMng = null;
         if(Config.smLivesSystemEnabled)
         {
            _loc1_ = mBoostDef.getValue();
            _loc2_ = InstanceMng.getUserDataMng();
            _loc2_.getOwnerUserData().setLives(_loc2_.getDefaultLives());
            _loc2_.updateLives();
            Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_BOOST_LIFE_INCREASE"),[_loc1_]));
            super.execute();
         }
      }
      
      override public function onExecuted() : void
      {
         super.onExecuted();
      }
   }
}

