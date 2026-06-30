package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.Utils;
   
   public class AuctionTicketDef extends GoldDef
   {
      
      private var mUniquePack:Boolean;
      
      public function AuctionTicketDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         super.doFromJSON(param1);
         if("uniquePack" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.uniquePack);
            this.setUniquePack(Utils.stringToBoolean(_loc2_));
         }
      }
      
      public function setUniquePack(param1:Boolean) : void
      {
         this.mUniquePack = param1;
      }
      
      public function getIsUniquePack() : Boolean
      {
         return this.mUniquePack;
      }
   }
}

