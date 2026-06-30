package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.Utils;
   
   public class PvPRewardsDef extends Def
   {
      
      private var mPosition:Array;
      
      private var mPackSku:String;
      
      private var mGold:FSNumber;
      
      public function PvPRewardsDef()
      {
         super();
      }
      
      override public function fromJSON(param1:Object) : Boolean
      {
         var _loc3_:String = null;
         super.fromJSON(param1);
         var _loc2_:Boolean = true;
         if(_loc2_)
         {
            if("position" in param1)
            {
               _loc3_ = Utils.cleanMasterString(param1.position);
               this.setPosition(_loc3_.split(","));
            }
            if("packSku" in param1)
            {
               _loc3_ = Utils.cleanMasterString(param1.packSku);
               this.setPackSku(_loc3_);
            }
            if("gold" in param1)
            {
               _loc3_ = Utils.cleanMasterString(param1.gold);
               this.setGold(int(_loc3_));
            }
         }
         return _loc2_;
      }
      
      private function setGold(param1:int) : void
      {
         if(this.mGold == null)
         {
            this.mGold = new FSNumber();
         }
         this.mGold.value = param1;
      }
      
      private function setPackSku(param1:String) : void
      {
         this.mPackSku = param1;
      }
      
      private function setPosition(param1:Array) : void
      {
         this.mPosition = param1;
      }
      
      public function getStartPosition() : int
      {
         return int(this.mPosition[0]);
      }
      
      public function getEndPosition() : int
      {
         return int(this.mPosition[this.mPosition.length - 1]);
      }
      
      public function getPackSku() : String
      {
         return this.mPackSku;
      }
      
      public function getGold() : int
      {
         return this.mGold ? int(this.mGold.value) : 0;
      }
   }
}

