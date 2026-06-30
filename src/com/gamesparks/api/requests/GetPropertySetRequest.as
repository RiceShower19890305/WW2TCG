package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class GetPropertySetRequest extends GSRequest
   {
      
      public function GetPropertySetRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".GetPropertySetRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : GetPropertySetRequest
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
               callback(new GetPropertySetResponse(param1));
            }
         });
      }
      
      public function setScriptData(param1:Object) : GetPropertySetRequest
      {
         data["scriptData"] = param1;
         return this;
      }
      
      public function setPropertySetShortCode(param1:String) : GetPropertySetRequest
      {
         this.data["propertySetShortCode"] = param1;
         return this;
      }
   }
}

