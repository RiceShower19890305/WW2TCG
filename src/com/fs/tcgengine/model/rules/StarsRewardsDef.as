package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.Utils;
   
   public class StarsRewardsDef extends Def
   {
      
      private var mStarAmount:int;
      
      private var mPackSku:String;
      
      private var mDifficulty:int;
      
      public function StarsRewardsDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         super.doFromJSON(param1);
         if("starAmount" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.starAmount);
            this.setStarsAmount(int(_loc2_));
         }
         if("packSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.packSku);
            this.setPackSku(_loc2_);
         }
         if("difficulty" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.difficulty);
            this.setDifficulty(int(_loc2_));
         }
      }
      
      public function getStarsAmount() : int
      {
         return this.mStarAmount;
      }
      
      public function setStarsAmount(param1:int) : void
      {
         this.mStarAmount = param1;
      }
      
      public function getPackSku() : String
      {
         return this.mPackSku;
      }
      
      public function setPackSku(param1:String) : void
      {
         this.mPackSku = param1;
      }
      
      public function getDifficulty() : int
      {
         return this.mDifficulty;
      }
      
      public function setDifficulty(param1:int) : void
      {
         this.mDifficulty = param1;
      }
   }
}

