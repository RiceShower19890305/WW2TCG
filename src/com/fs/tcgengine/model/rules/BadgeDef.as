package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.Utils;
   
   public class BadgeDef extends Def
   {
      
      private var mAmountToUnlock:int;
      
      private var mRewardSku:String;
      
      public function BadgeDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         super.doFromJSON(param1);
         if("amountToUnlock" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.amountToUnlock);
            this.setAmountToUnlock(int(_loc2_));
         }
         if("rewardSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.rewardSku);
            this.setRewardSku(_loc2_);
         }
      }
      
      public function getAmountToUnlock() : int
      {
         return this.mAmountToUnlock;
      }
      
      public function setAmountToUnlock(param1:int) : void
      {
         this.mAmountToUnlock = param1;
      }
      
      public function getRewardSku() : String
      {
         return this.mRewardSku;
      }
      
      public function setRewardSku(param1:String) : void
      {
         this.mRewardSku = param1;
      }
   }
}

