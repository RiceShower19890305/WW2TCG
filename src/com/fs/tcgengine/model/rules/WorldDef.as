package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.Utils;
   
   public class WorldDef extends Def
   {
      
      private var mRewardsSkus:Array;
      
      public function WorldDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         super.doFromJSON(param1);
         if("rewardsSkus" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.rewardsSkus);
            this.mRewardsSkus = String(_loc2_).split(",");
         }
      }
      
      public function getRewardsSkus() : Array
      {
         return this.mRewardsSkus;
      }
   }
}

