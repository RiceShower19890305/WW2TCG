package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.AIMovementDef;
   import com.fs.tcgengine.model.rules.Def;
   import flash.utils.Dictionary;
   
   public class AIMovementsDefMng extends DefMng
   {
      
      public function AIMovementsDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new AIMovementDef();
      }
      
      public function getMovementByUnitsAmounts(param1:int, param2:int) : AIMovementDef
      {
         var _loc3_:AIMovementDef = null;
         var _loc4_:AIMovementDef = null;
         var _loc5_:Dictionary = getAllDefs();
         for each(_loc4_ in _loc5_)
         {
            if(_loc4_.getAIUnitsBFAmount() == param1 && _loc4_.getPlayerUnitsInBFAmount() == param2)
            {
               return _loc4_;
            }
         }
         return _loc3_;
      }
   }
}

