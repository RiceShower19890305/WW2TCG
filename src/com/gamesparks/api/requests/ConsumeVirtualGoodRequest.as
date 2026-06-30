package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class ConsumeVirtualGoodRequest extends GSRequest
   {
      
      public function ConsumeVirtualGoodRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".ConsumeVirtualGoodRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : ConsumeVirtualGoodRequest
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
               callback(new ConsumeVirtualGoodResponse(param1));
            }
         });
      }
      
      public function setScriptData(param1:Object) : ConsumeVirtualGoodRequest
      {
         data["scriptData"] = param1;
         return this;
      }
      
      public function setQuantity(param1:Number) : ConsumeVirtualGoodRequest
      {
         this.data["quantity"] = param1;
         return this;
      }
      
      public function setShortCode(param1:String) : ConsumeVirtualGoodRequest
      {
         this.data["shortCode"] = param1;
         return this;
      }
   }
}

