package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class PsnBuyGoodsRequest extends GSRequest
   {
      
      public function PsnBuyGoodsRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".PsnBuyGoodsRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : PsnBuyGoodsRequest
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
      
      public function setScriptData(param1:Object) : PsnBuyGoodsRequest
      {
         data["scriptData"] = param1;
         return this;
      }
      
      public function setAuthorizationCode(param1:String) : PsnBuyGoodsRequest
      {
         this.data["authorizationCode"] = param1;
         return this;
      }
      
      public function setCurrencyCode(param1:String) : PsnBuyGoodsRequest
      {
         this.data["currencyCode"] = param1;
         return this;
      }
      
      public function setEntitlementLabel(param1:String) : PsnBuyGoodsRequest
      {
         this.data["entitlementLabel"] = param1;
         return this;
      }
      
      public function setRedirectUri(param1:String) : PsnBuyGoodsRequest
      {
         this.data["redirectUri"] = param1;
         return this;
      }
      
      public function setSubUnitPrice(param1:Number) : PsnBuyGoodsRequest
      {
         this.data["subUnitPrice"] = param1;
         return this;
      }
      
      public function setUniqueTransactionByPlayer(param1:Boolean) : PsnBuyGoodsRequest
      {
         this.data["uniqueTransactionByPlayer"] = param1;
         return this;
      }
      
      public function setUseCount(param1:Number) : PsnBuyGoodsRequest
      {
         this.data["useCount"] = param1;
         return this;
      }
   }
}

