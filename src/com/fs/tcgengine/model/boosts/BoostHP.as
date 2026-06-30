package com.fs.tcgengine.model.boosts
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.rules.BoostDef;
   import com.fs.tcgengine.model.userdata.UserBattleInfo;
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.Utils;
   import com.greensock.TweenMax;
   
   public class BoostHP extends Boost
   {
      
      public function BoostHP(param1:BoostDef)
      {
         super(param1);
      }
      
      override public function execute() : void
      {
         var _loc1_:UserBattleInfo = null;
         var _loc3_:int = 0;
         var _loc2_:BattleEngine = InstanceMng.getBattleEngine();
         if(_loc2_ != null)
         {
            _loc1_ = _loc2_.getOwnerBattleInfo();
            if(_loc1_ != null)
            {
               _loc3_ = mBoostDef.getValue();
               _loc1_.modifyHP(new FSNumber(_loc3_),true);
            }
            Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_BOOST_HP_INCREASE"),[_loc3_]));
            super.execute();
         }
         else
         {
            InstanceMng.getUserDataMng().getOwnerUserData().addBoostToCatalog(mBoostDef.getSku(),1,true);
            InstanceMng.getUserDataMng().updateBoosts();
            Utils.setLogText(TextManager.getText("TID_GEN_PURCHASES_RESTORED"));
         }
         TweenMax.delayedCall(2,onExecuted);
      }
   }
}

