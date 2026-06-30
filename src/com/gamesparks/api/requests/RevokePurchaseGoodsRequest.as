package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class RevokePurchaseGoodsRequest extends GSRequest
   {
      
      public function RevokePurchaseGoodsRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".RevokePurchaseGoodsRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : RevokePurchaseGoodsRequest
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
               callback(new RevokePurchaseGoodsResponse(param1));
            }
         });
      }
      
      public function setScriptData(param1:Object) : RevokePurchaseGoodsRequest
      {
         data["scriptData"] = param1;
         return this;
      }
      
      public function setPlayerId(param1:String) : RevokePurchaseGoodsRequest
      {
         this.data["playerId"] = param1;
         return this;
      }
      
      public function setStoreType(param1:String) : RevokePurchaseGoodsRequest
      {
         this.data["storeType"] = param1;
         return this;
      }
      
      public function setTransactionIds(param1:Vector.<String>) : RevokePurchaseGoodsRequest
      {
         this.data["transactionIds"] = toArray(param1);
         return this;
      }
   }
}

