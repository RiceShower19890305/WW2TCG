package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.Utils;
   
   public class RaidShopDef extends Def
   {
      
      private var mType:int;
      
      private var mCardSku:String;
      
      private var mPackSku:String;
      
      private var mCost:FSNumber;
      
      public function RaidShopDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         super.doFromJSON(param1);
         if("type" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.type);
            this.mType = int(_loc2_);
         }
         if("cardSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.cardSku);
            this.mCardSku = _loc2_;
         }
         if("packSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.packSku);
            this.mPackSku = _loc2_;
         }
         if("cost" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.cost);
            this.setCost(int(_loc2_));
         }
      }
      
      private function setCost(param1:int) : void
      {
         if(this.mCost == null)
         {
            this.mCost = new FSNumber();
         }
         this.mCost.value = Number(param1);
      }
      
      public function getType() : int
      {
         return this.mType;
      }
      
      public function getCardSku() : String
      {
         return this.mCardSku;
      }
      
      public function getPackSku() : String
      {
         return this.mPackSku;
      }
      
      public function getCost() : int
      {
         return this.mCost ? int(this.mCost.value) : 0;
      }
   }
}

