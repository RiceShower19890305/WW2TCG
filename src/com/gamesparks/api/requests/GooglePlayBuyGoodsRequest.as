package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class GooglePlayBuyGoodsRequest extends GSRequest
   {
      
      public function GooglePlayBuyGoodsRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".GooglePlayBuyGoodsRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : GooglePlayBuyGoodsRequest
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
      
      public function setScriptData(param1:Object) : GooglePlayBuyGoodsRequest
      {
         data["scriptData"] = param1;
         return this;
      }
      
      public function setCurrencyCode(param1:String) : GooglePlayBuyGoodsRequest
      {
         this.data["currencyCode"] = param1;
         return this;
      }
      
      public function setSignature(param1:String) : GooglePlayBuyGoodsRequest
      {
         this.data["signature"] = param1;
         return this;
      }
      
      public function setSignedData(param1:String) : GooglePlayBuyGoodsRequest
      {
         this.data["signedData"] = param1;
         return this;
      }
      
      public function setSubUnitPrice(param1:Number) : GooglePlayBuyGoodsRequest
      {
         this.data["subUnitPrice"] = param1;
         return this;
      }
      
      public function setUniqueTransactionByPlayer(param1:Boolean) : GooglePlayBuyGoodsRequest
      {
         this.data["uniqueTransactionByPlayer"] = param1;
         return this;
      }
   }
}

