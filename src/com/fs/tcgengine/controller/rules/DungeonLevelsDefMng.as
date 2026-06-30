package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.DungeonLevelDef;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.utils.Utils;
   
   public class DungeonLevelsDefMng extends DefMng
   {
      
      public function DungeonLevelsDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new DungeonLevelDef();
      }
      
      public function getLevelDefByLevelIndex(param1:int) : LevelDef
      {
         var _loc2_:LevelDef = null;
         param1 += 1;
         var _loc3_:int = param1 > 99 ? 3 : 2;
         var _loc4_:String = "dungeonLevel_" + Utils.transformValueToString(param1.toString(),_loc3_);
         return DungeonLevelDef(getDefBySku(_loc4_));
      }
   }
}

