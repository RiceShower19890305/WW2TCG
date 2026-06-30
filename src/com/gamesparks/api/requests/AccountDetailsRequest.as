package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class AccountDetailsRequest extends GSRequest
   {
      
      public function AccountDetailsRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".AccountDetailsRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : AccountDetailsRequest
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
               callback(new AccountDetailsResponse(param1));
            }
         });
      }
      
      public function setScriptData(param1:Object) : AccountDetailsRequest
      {
         data["scriptData"] = param1;
         return this;
      }
   }
}

