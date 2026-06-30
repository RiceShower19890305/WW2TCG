package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.RankDef;
   import com.fs.tcgengine.utils.DictionaryUtils;
   
   public class RanksDefMng extends DefMng
   {
      
      public function RanksDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new RankDef();
      }
      
      public function getDefByIndex(param1:int) : RankDef
      {
         var _loc2_:RankDef = null;
         var _loc3_:RankDef = null;
         for each(_loc3_ in mDefsBySku)
         {
            if(_loc3_.getIndex() == param1)
            {
               return _loc3_;
            }
         }
         return _loc2_;
      }
      
      public function getDefByCurrentLevel(param1:int) : RankDef
      {
         var _loc2_:RankDef = null;
         var _loc3_:RankDef = null;
         var _loc5_:int = 0;
         var _loc4_:Array = DictionaryUtils.sortDictionaryByKey(mDefsBySku);
         _loc5_ = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc3_ = Object(_loc4_[_loc5_]).value;
            if(_loc3_.getGainedOnLevel() > param1)
            {
               return _loc2_;
            }
            _loc2_ = _loc3_;
            _loc5_++;
         }
         return _loc2_;
      }
      
      public function getMaxAmountOfBadgesBySku(param1:String) : int
      {
         var _loc2_:int = 0;
         var _loc3_:RankDef = null;
         for each(_loc3_ in mDefsBySku)
         {
            if(_loc3_.getBadgeSku() == param1)
            {
               _loc2_++;
            }
         }
         return _loc2_;
      }
   }
}

