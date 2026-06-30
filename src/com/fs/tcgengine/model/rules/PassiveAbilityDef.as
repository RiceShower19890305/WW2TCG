package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.Utils;
   
   public class PassiveAbilityDef extends Def
   {
      
      private var mAbilitySku:Array;
      
      private var mTriggereableByCategorySku:String = "";
      
      public function PassiveAbilityDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         super.doFromJSON(param1);
         if("abilitySku" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.abilitySku);
            this.mAbilitySku = _loc3_.split(",");
         }
         if("triggereableByCategorySku" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.triggereableByCategorySku);
            this.mTriggereableByCategorySku = _loc3_;
         }
      }
      
      public function getAbilitiesSkus() : Array
      {
         return this.mAbilitySku;
      }
      
      public function getTriggereableByCategorySku() : String
      {
         return this.mTriggereableByCategorySku;
      }
   }
}

