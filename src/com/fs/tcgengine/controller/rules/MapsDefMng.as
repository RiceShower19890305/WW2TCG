package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.MapDef;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.Utils;
   
   public class MapsDefMng extends DefMng
   {
      
      private const MAP_PREFIX:String = "map_";
      
      public function MapsDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new MapDef();
      }
      
      public function getMapDefByIndex(param1:int) : MapDef
      {
         var _loc2_:MapDef = null;
         var _loc3_:String = null;
         if(param1 >= 1)
         {
            _loc3_ = this.MAP_PREFIX + Utils.transformValueToString(param1.toString(),2);
            _loc2_ = MapDef(getDefBySku(_loc3_));
         }
         return _loc2_;
      }
      
      public function getPreviousLevelsAmountByIndex(param1:int) : int
      {
         var _loc3_:int = 0;
         var _loc5_:MapDef = null;
         var _loc2_:int = 0;
         var _loc4_:int = getDefsAmount();
         if(param1 > 1)
         {
            _loc3_ = 1;
            while(_loc3_ < param1)
            {
               _loc5_ = this.getMapDefByIndex(_loc3_);
               if(_loc5_ != null)
               {
                  _loc2_ += _loc5_.getLevelsAmount();
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      public function getLastMapIndex() : int
      {
         return getDefsAmount();
      }
      
      public function getMapIndexByLevelIndex(param1:int) : int
      {
         var _loc4_:MapDef = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc2_:int = this.getLastMapIndex();
         var _loc3_:int = 0;
         if(param1 > 0)
         {
            _loc5_ = DictionaryUtils.sortDictionaryByKey(getAllDefs());
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               _loc4_ = _loc5_[_loc6_].value;
               _loc3_ += _loc4_.getLevelsAmount();
               if(param1 <= _loc3_)
               {
                  return _loc6_ + 1;
               }
               _loc6_++;
            }
         }
         return _loc2_;
      }
      
      public function isFirstLevelOfMap(param1:int) : Boolean
      {
         var _loc4_:MapDef = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         if(param1 > 0)
         {
            _loc5_ = DictionaryUtils.sortDictionaryByKey(getAllDefs());
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               _loc4_ = _loc5_[_loc6_].value;
               _loc3_ += _loc4_.getLevelsAmount();
               if(param1 == 1 || param1 == _loc3_ + 1)
               {
                  return true;
               }
               _loc6_++;
            }
         }
         return _loc2_;
      }
      
      public function isLastLevelOfMap(param1:int) : Boolean
      {
         var _loc4_:MapDef = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         if(param1 > 0)
         {
            _loc5_ = DictionaryUtils.sortDictionaryByKey(getAllDefs());
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               _loc4_ = _loc5_[_loc6_].value;
               _loc3_ += _loc4_.getLevelsAmount();
               if(param1 == _loc3_)
               {
                  return true;
               }
               _loc6_++;
            }
         }
         return _loc2_;
      }
   }
}

