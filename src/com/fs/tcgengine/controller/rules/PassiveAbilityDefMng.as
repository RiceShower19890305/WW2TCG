package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.PassiveAbilityDef;
   
   public class PassiveAbilityDefMng extends DefMng
   {
      
      public function PassiveAbilityDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new PassiveAbilityDef();
      }
      
      public function getDefByIndex(param1:int) : PassiveAbilityDef
      {
         var _loc2_:PassiveAbilityDef = null;
         var _loc3_:PassiveAbilityDef = null;
         for each(_loc3_ in mDefsBySku)
         {
            if(_loc3_.getIndex() == param1)
            {
               return _loc3_;
            }
         }
         return _loc2_;
      }
   }
}

