package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.PvPRewardsDef;
   import com.fs.tcgengine.utils.DictionaryUtils;
   
   public class PvPRewardsDefMng extends DefMng
   {
      
      public function PvPRewardsDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new PvPRewardsDef();
      }
      
      public function getPvPRewards() : Array
      {
         var _loc2_:PvPRewardsDef = null;
         var _loc1_:Array = new Array();
         var _loc3_:int = 0;
         for each(_loc2_ in mDefsBySku)
         {
            _loc1_[_loc3_] = _loc2_;
            _loc3_++;
         }
         _loc1_.sort(DictionaryUtils.sortPvPRewardsByPosition);
         return _loc1_;
      }
   }
}

