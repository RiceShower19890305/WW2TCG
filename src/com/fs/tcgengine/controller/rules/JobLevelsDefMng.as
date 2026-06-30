package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.JobLevelsDef;
   
   public class JobLevelsDefMng extends DefMng
   {
      
      public function JobLevelsDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new JobLevelsDef();
      }
      
      public function getDefByIndex(param1:int) : JobLevelsDef
      {
         var _loc2_:JobLevelsDef = null;
         var _loc3_:JobLevelsDef = null;
         for each(_loc3_ in mDefsBySku)
         {
            if(_loc3_.getIndex() == param1)
            {
               return _loc3_;
            }
         }
         return _loc2_;
      }
      
      public function getJobLevelDefByJobExp(param1:Number) : JobLevelsDef
      {
         var _loc2_:JobLevelsDef = null;
         var _loc3_:JobLevelsDef = null;
         var _loc4_:JobLevelsDef = this.getLastJobLevelDef();
         for each(_loc2_ in mDefsBySku)
         {
            if(param1 >= _loc2_.getMinXP() && (param1 <= _loc2_.getMaxXP() || _loc2_.getSku() == _loc4_.getSku()))
            {
               _loc3_ = _loc2_;
               break;
            }
         }
         return _loc3_;
      }
      
      public function getLastJobLevelDef() : JobLevelsDef
      {
         var _loc1_:JobLevelsDef = null;
         var _loc2_:JobLevelsDef = null;
         for each(_loc1_ in mDefsBySku)
         {
            if(_loc2_ == null || _loc2_ != null && _loc2_.getIndex() < _loc1_.getIndex())
            {
               _loc2_ = _loc1_;
            }
         }
         return _loc2_;
      }
      
      public function getJobLevelDefByLevel(param1:int) : JobLevelsDef
      {
         var _loc2_:JobLevelsDef = null;
         var _loc3_:JobLevelsDef = null;
         for each(_loc2_ in mDefsBySku)
         {
            if(param1 == _loc2_.getLevel())
            {
               _loc3_ = _loc2_;
               break;
            }
         }
         return _loc3_;
      }
   }
}

