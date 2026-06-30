package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.controller.AbilitiesMng;
   import com.fs.tcgengine.model.board.card.Ability;
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.PowerDef;
   import com.fs.tcgengine.view.cards.FSPower;
   
   public class PowersDefMng extends CardDefMng
   {
      
      public function PowersDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new PowerDef();
      }
      
      override public function getDefBySku(param1:String) : Def
      {
         return mDefsBySku[param1];
      }
      
      public function getDefByIndex(param1:int) : PowerDef
      {
         var _loc2_:PowerDef = null;
         var _loc3_:PowerDef = null;
         for each(_loc3_ in mDefsBySku)
         {
            if(_loc3_.getIndex() == param1)
            {
               return _loc3_;
            }
         }
         return _loc2_;
      }
      
      public function getIsPowerAbilityForFriendTargets(param1:String) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:FSPower = new FSPower(param1);
         var _loc4_:Ability = _loc3_.getAbilities()[0];
         if(_loc4_.getAbilityDef().getTargetIndex() == AbilitiesMng.TARGET_FRIENDLY || _loc4_.getAbilityDef().getTargetIndex() == AbilitiesMng.TARGET_FRIENDLY_CARD)
         {
            _loc2_ = true;
         }
         return _loc2_;
      }
      
      public function getPowerAbilityAffectsAllTargets(param1:String) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:FSPower = new FSPower(param1);
         var _loc4_:Ability = _loc3_.getAbilities()[0];
         if(_loc4_.getAbilityDef().getTargetIndex() == AbilitiesMng.TARGET_CARD)
         {
            _loc2_ = true;
         }
         return _loc2_;
      }
   }
}

