package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.controller.JobsMng;
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.JobDef;
   import com.fs.tcgengine.model.rules.JobRewardsDef;
   
   public class JobRewardsDefMng extends DefMng
   {
      
      public function JobRewardsDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new JobRewardsDef();
      }
      
      public function getJobRewardDefByJob(param1:JobDef, param2:int = -1) : JobRewardsDef
      {
         var _loc3_:JobRewardsDef = null;
         var _loc4_:JobRewardsDef = null;
         var _loc5_:JobRewardsDef = null;
         var _loc6_:String = null;
         if(param2 == -1)
         {
            _loc6_ = JobsMng.getJobLevelSku(param1);
         }
         else
         {
            _loc6_ = JobsMng.getJobLevelSkuByLevel(param2);
         }
         for each(_loc3_ in mDefsBySku)
         {
            if(_loc3_.getJobLevelSku() == _loc6_ && _loc3_.getJobSku() == null)
            {
               _loc5_ = _loc3_;
            }
            if(_loc3_.getJobSku() == param1.getSku() && _loc3_.getJobLevelSku() == _loc6_)
            {
               _loc4_ = _loc3_;
               break;
            }
         }
         return _loc4_ == null ? _loc5_ : _loc4_;
      }
   }
}

