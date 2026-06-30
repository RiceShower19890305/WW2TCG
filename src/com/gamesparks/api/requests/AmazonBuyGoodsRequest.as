package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class AmazonBuyGoodsRequest extends GSRequest
   {
      
      public function AmazonBuyGoodsRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".AmazonBuyGoodsRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : AmazonBuyGoodsRequest
      {
         this.timeoutSeconds = param1;
         return this;
      }
      
      override public function send(param1:Function) : String
      {
         var callback:Function = param1;
         return super.send(function(param1:Object):void
         {
            if(callback != null)
            {
               callback(new BuyVirtualGoodResponse(param1));
            }
         });
      }
      
      public function setScriptData(param1:Object) : AmazonBuyGoodsRequest
      {
         data["scriptData"] = param1;
         return this;
      }
      
      public function setAmazonUserId(param1:String) : AmazonBuyGoodsRequest
      {
         this.data["amazonUserId"] = param1;
         return this;
      }
      
      public function setCurrencyCode(param1:String) : AmazonBuyGoodsRequest
      {
         this.data["currencyCode"] = param1;
         return this;
      }
      
      public function setReceiptId(param1:String) : AmazonBuyGoodsRequest
      {
         this.data["receiptId"] = param1;
         return this;
      }
      
      public function setSubUnitPrice(param1:Number) : AmazonBuyGoodsRequest
      {
         this.data["subUnitPrice"] = param1;
         return this;
      }
      
      public function setUniqueTransactionByPlayer(param1:Boolean) : AmazonBuyGoodsRequest
      {
         this.data["uniqueTransactionByPlayer"] = param1;
         return this;
      }
   }
}

