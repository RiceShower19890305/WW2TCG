package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.Utils;
   
   public class JobLevelsDef extends Def
   {
      
      private var mMinXP:FSNumber;
      
      private var mMaxXP:FSNumber;
      
      private var mLevel:int;
      
      public function JobLevelsDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         super.doFromJSON(param1);
         if("minXP" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.minXP);
            this.setMinXP(Number(_loc2_));
         }
         if("maxXP" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.maxXP);
            this.setMaxXP(Number(_loc2_));
         }
         if("level" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.level);
            this.mLevel = int(_loc2_);
         }
      }
      
      private function setMinXP(param1:Number) : void
      {
         if(this.mMinXP == null)
         {
            this.mMinXP = new FSNumber();
         }
         this.mMinXP.value = param1;
      }
      
      public function getMinXP() : Number
      {
         return this.mMinXP ? this.mMinXP.value : 0;
      }
      
      private function setMaxXP(param1:Number) : void
      {
         if(this.mMaxXP == null)
         {
            this.mMaxXP = new FSNumber();
         }
         this.mMaxXP.value = param1;
      }
      
      public function getMaxXP() : Number
      {
         return this.mMaxXP ? this.mMaxXP.value : 0;
      }
      
      public function getLevel() : int
      {
         return this.mLevel;
      }
   }
}

