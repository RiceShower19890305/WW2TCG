package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.TurnScoreDef;
   import flash.utils.Dictionary;
   
   public class TurnScoresDefMng extends DefMng
   {
      
      public function TurnScoresDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new TurnScoreDef();
      }
      
      public function getDefByTurnsLeft(param1:int) : TurnScoreDef
      {
         var _loc2_:TurnScoreDef = null;
         var _loc4_:TurnScoreDef = null;
         var _loc6_:TurnScoreDef = null;
         var _loc7_:int = 0;
         var _loc3_:Dictionary = getAllDefs();
         var _loc5_:int = 0;
         if(param1 == 0)
         {
            return null;
         }
         for each(_loc4_ in _loc3_)
         {
            _loc7_ = _loc4_.getTurnsLeft();
            if(_loc7_ == param1)
            {
               _loc2_ = _loc4_;
               return _loc4_;
            }
            if(_loc7_ >= _loc5_)
            {
               _loc5_ = _loc7_;
               _loc6_ = _loc4_;
            }
         }
         if(_loc2_ == null)
         {
            if(param1 >= _loc5_)
            {
               return _loc6_;
            }
         }
         return _loc2_;
      }
   }
}

