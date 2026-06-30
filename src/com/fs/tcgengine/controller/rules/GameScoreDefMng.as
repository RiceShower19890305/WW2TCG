package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.GameScoreDef;
   import flash.utils.Dictionary;
   
   public class GameScoreDefMng extends DefMng
   {
      
      public function GameScoreDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new GameScoreDef();
      }
      
      public function getDefByIndex(param1:int) : GameScoreDef
      {
         var _loc2_:GameScoreDef = null;
         var _loc3_:Dictionary = getAllDefs();
         for each(_loc2_ in _loc3_)
         {
            if(_loc2_.getIndex() == param1)
            {
               return _loc2_;
            }
         }
         return _loc2_;
      }
   }
}

