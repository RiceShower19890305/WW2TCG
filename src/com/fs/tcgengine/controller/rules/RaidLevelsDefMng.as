package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.model.rules.RaidLevelDef;
   import com.fs.tcgengine.utils.Utils;
   
   public class RaidLevelsDefMng extends DefMng
   {
      
      public function RaidLevelsDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new RaidLevelDef();
      }
      
      public function getLevelDefByLevelIndex(param1:int) : LevelDef
      {
         var _loc2_:LevelDef = null;
         param1 += 1;
         var _loc3_:int = param1 > 99 ? 3 : 2;
         var _loc4_:String = "raidLevel_" + Utils.transformValueToString(param1.toString(),_loc3_);
         return RaidLevelDef(getDefBySku(_loc4_));
      }
   }
}

