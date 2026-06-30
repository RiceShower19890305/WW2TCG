package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class WindowsBuyGoodsRequest extends GSRequest
   {
      
      public function WindowsBuyGoodsRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".WindowsBuyGoodsRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : WindowsBuyGoodsRequest
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
      
      public function setScriptData(param1:Object) : WindowsBuyGoodsRequest
      {
         data["scriptData"] = param1;
         return this;
      }
      
      public function setCurrencyCode(param1:String) : WindowsBuyGoodsRequest
      {
         this.data["currencyCode"] = param1;
         return this;
      }
      
      public function setPlatform(param1:String) : WindowsBuyGoodsRequest
      {
         this.data["platform"] = param1;
         return this;
      }
      
      public function setReceipt(param1:String) : WindowsBuyGoodsRequest
      {
         this.data["receipt"] = param1;
         return this;
      }
      
      public function setSubUnitPrice(param1:Number) : WindowsBuyGoodsRequest
      {
         this.data["subUnitPrice"] = param1;
         return this;
      }
      
      public function setUniqueTransactionByPlayer(param1:Boolean) : WindowsBuyGoodsRequest
      {
         this.data["uniqueTransactionByPlayer"] = param1;
         return this;
      }
   }
}

