package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.Utils;
   
   public class LevelDefMng extends DefMng
   {
      
      public function LevelDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new LevelDef();
      }
      
      public function isLastPlayableLevel(param1:LevelDef) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:Boolean = false;
         if(param1)
         {
            _loc3_ = getDefsAmount() - 1;
            _loc4_ = param1.getLevelIndex();
            _loc2_ = _loc4_ == _loc3_;
         }
         return _loc2_;
      }
      
      public function getNextLevelSku() : String
      {
         var _loc1_:int = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
         var _loc2_:int = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelIndex(_loc1_);
         var _loc3_:int = _loc2_ > 99 ? 3 : 2;
         _loc2_++;
         return "level_" + Utils.transformValueToString(_loc2_.toString(),_loc3_);
      }
      
      public function getPreviousLevelSku(param1:String = "", param2:int = -1) : String
      {
         var _loc3_:int = param2 != -1 ? param2 : InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
         var _loc4_:* = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelIndex(_loc3_);
         var _loc5_:int = _loc4_ <= 100 ? 2 : 3;
         _loc4_--;
         return "level_" + Utils.transformValueToString(_loc4_.toString(),_loc5_);
      }
      
      public function getLevelIndexByLevelSku(param1:String) : int
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc2_:int = -1;
         if(param1 != "" && param1 != null)
         {
            _loc3_ = param1.split("_");
            if(_loc3_ != null && _loc3_.length > 1)
            {
               return int(_loc3_[1]);
            }
         }
         return _loc2_;
      }
      
      public function getLevelDefByLevelIndex(param1:int) : LevelDef
      {
         var _loc2_:LevelDef = null;
         var _loc3_:int = param1 > 99 ? 3 : 2;
         var _loc4_:String = "level_" + Utils.transformValueToString(param1.toString(),_loc3_);
         return LevelDef(getDefBySku(_loc4_));
      }
      
      public function getTotalLevelsAmount() : int
      {
         return DictionaryUtils.getDictionaryLength(mDefsBySku) - 1;
      }
   }
}

