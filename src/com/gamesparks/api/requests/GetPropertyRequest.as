package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class GetPropertyRequest extends GSRequest
   {
      
      public function GetPropertyRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".GetPropertyRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : GetPropertyRequest
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
               callback(new GetPropertyResponse(param1));
            }
         });
      }
      
      public function setScriptData(param1:Object) : GetPropertyRequest
      {
         data["scriptData"] = param1;
         return this;
      }
      
      public function setPropertyShortCode(param1:String) : GetPropertyRequest
      {
         this.data["propertyShortCode"] = param1;
         return this;
      }
   }
}

