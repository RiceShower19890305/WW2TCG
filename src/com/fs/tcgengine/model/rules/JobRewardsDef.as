package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.Utils;
   
   public class JobRewardsDef extends Def
   {
      
      private var mJobSku:String;
      
      private var mJobLevelSku:String;
      
      private var mJobRewardType:int;
      
      private var mJobRewardSku:String;
      
      private var mChestBG:String;
      
      public function JobRewardsDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         super.doFromJSON(param1);
         if("jobSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.jobSku);
            this.mJobSku = _loc2_;
         }
         if("jobLevelsSKu" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.jobLevelsSKu);
            this.mJobLevelSku = _loc2_;
         }
         if("rewardType" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.rewardType);
            this.mJobRewardType = int(_loc2_);
         }
         if("reward" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.reward);
            this.mJobRewardSku = _loc2_;
         }
         if("chestBG" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.chestBG);
            this.mChestBG = _loc2_;
         }
      }
      
      public function getJobSku() : String
      {
         return this.mJobSku;
      }
      
      public function getJobLevelSku() : String
      {
         return this.mJobLevelSku;
      }
      
      public function getJobRewardType() : int
      {
         return this.mJobRewardType;
      }
      
      public function getJobRewardSku() : String
      {
         return this.mJobRewardSku;
      }
      
      public function getChestBG() : String
      {
         return this.mChestBG;
      }
   }
}

