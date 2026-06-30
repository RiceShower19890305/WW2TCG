package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class SteamBuyGoodsRequest extends GSRequest
   {
      
      public function SteamBuyGoodsRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".SteamBuyGoodsRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : SteamBuyGoodsRequest
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
      
      public function setScriptData(param1:Object) : SteamBuyGoodsRequest
      {
         data["scriptData"] = param1;
         return this;
      }
      
      public function setCurrencyCode(param1:String) : SteamBuyGoodsRequest
      {
         this.data["currencyCode"] = param1;
         return this;
      }
      
      public function setOrderId(param1:String) : SteamBuyGoodsRequest
      {
         this.data["orderId"] = param1;
         return this;
      }
      
      public function setSubUnitPrice(param1:Number) : SteamBuyGoodsRequest
      {
         this.data["subUnitPrice"] = param1;
         return this;
      }
      
      public function setUniqueTransactionByPlayer(param1:Boolean) : SteamBuyGoodsRequest
      {
         this.data["uniqueTransactionByPlayer"] = param1;
         return this;
      }
   }
}

