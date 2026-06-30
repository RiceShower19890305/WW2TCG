package com.fs.tcgengine.model.boosts
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.rules.BoostDef;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.utils.Utils;
   
   public class BoostFillLives extends Boost
   {
      
      public function BoostFillLives(param1:BoostDef)
      {
         super(param1);
      }
      
      override public function execute() : void
      {
         var _loc1_:UserDataMng = null;
         var _loc2_:int = 0;
         if(Config.smLivesSystemEnabled)
         {
            _loc1_ = InstanceMng.getUserDataMng();
            _loc2_ = _loc1_.getDefaultLives();
            _loc1_.getOwnerUserData().setLives(_loc1_.getDefaultLives());
            _loc1_.updateLives();
            Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_BOOST_LIFE_INCREASE"),[_loc2_]));
            super.execute();
         }
      }
   }
}

