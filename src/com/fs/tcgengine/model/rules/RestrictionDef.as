package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.Utils;
   
   public class RestrictionDef extends Def
   {
      
      private var mSubCategoryAllowedSku:Array;
      
      private var mUpgradeAllowed:Boolean;
      
      public function RestrictionDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         if("subCategoryAllowedSku" in param1)
         {
            if(param1.subCategoryAllowedSku != "")
            {
               _loc2_ = Utils.cleanMasterString(param1.subCategoryAllowedSku);
               this.setSubCategoryAllowedSku(_loc2_.split(","));
            }
         }
         if("upgradeAllowed" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.upgradeAllowed);
            this.setUpgradeAllowed(Utils.stringToBoolean(_loc2_));
         }
      }
      
      public function getSubCategoryAllowedSku() : Array
      {
         return this.mSubCategoryAllowedSku;
      }
      
      public function setSubCategoryAllowedSku(param1:Array) : void
      {
         this.mSubCategoryAllowedSku = param1;
      }
      
      public function isUpgradeAllowed() : Boolean
      {
         return this.mUpgradeAllowed;
      }
      
      public function setUpgradeAllowed(param1:Boolean) : void
      {
         this.mUpgradeAllowed = param1;
      }
   }
}

