package com.fs.tcgengine.model.boosts
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.model.rules.BoostDef;
   
   public class BoostInvulnerable extends Boost
   {
      
      public function BoostInvulnerable(param1:BoostDef)
      {
         super(param1);
      }
      
      override public function execute() : void
      {
         var _loc1_:int = InstanceMng.getBattleEngine().getTurnsWithoutTakingDamage();
         InstanceMng.getBattleEngine().setTurnsWithoutTakingDamage(_loc1_ + mBoostDef.getValue());
         super.execute();
      }
   }
}

