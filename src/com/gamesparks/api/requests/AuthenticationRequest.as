package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class AuthenticationRequest extends GSRequest
   {
      
      public function AuthenticationRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".AuthenticationRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : AuthenticationRequest
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
               callback(new AuthenticationResponse(param1));
            }
         });
      }
      
      public function setScriptData(param1:Object) : AuthenticationRequest
      {
         data["scriptData"] = param1;
         return this;
      }
      
      public function setPassword(param1:String) : AuthenticationRequest
      {
         this.data["password"] = param1;
         return this;
      }
      
      public function setUserName(param1:String) : AuthenticationRequest
      {
         this.data["userName"] = param1;
         return this;
      }
   }
}

