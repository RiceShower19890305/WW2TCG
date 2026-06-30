package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class RegistrationRequest extends GSRequest
   {
      
      public function RegistrationRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".RegistrationRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : RegistrationRequest
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
               callback(new RegistrationResponse(param1));
            }
         });
      }
      
      public function setScriptData(param1:Object) : RegistrationRequest
      {
         data["scriptData"] = param1;
         return this;
      }
      
      public function setDisplayName(param1:String) : RegistrationRequest
      {
         this.data["displayName"] = param1;
         return this;
      }
      
      public function setPassword(param1:String) : RegistrationRequest
      {
         this.data["password"] = param1;
         return this;
      }
      
      public function setSegments(param1:Object) : RegistrationRequest
      {
         this.data["segments"] = param1;
         return this;
      }
      
      public function setUserName(param1:String) : RegistrationRequest
      {
         this.data["userName"] = param1;
         return this;
      }
   }
}

