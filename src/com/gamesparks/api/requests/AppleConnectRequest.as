package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class AppleConnectRequest extends GSRequest
   {
      
      public function AppleConnectRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".SignInWithAppleConnectRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : AppleConnectRequest
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
      
      public function setScriptData(param1:Object) : AppleConnectRequest
      {
         data["scriptData"] = param1;
         return this;
      }
      
      public function setAuthorizationCode(param1:String) : AppleConnectRequest
      {
         this.data["authorizationCode"] = param1;
         return this;
      }
      
      public function setClientId(param1:String) : AppleConnectRequest
      {
         this.data["clientId"] = param1;
         return this;
      }
      
      public function setDoNotLinkToCurrentPlayer(param1:Boolean) : AppleConnectRequest
      {
         this.data["doNotLinkToCurrentPlayer"] = param1;
         return this;
      }
      
      public function setErrorOnSwitch(param1:Boolean) : AppleConnectRequest
      {
         this.data["errorOnSwitch"] = param1;
         return this;
      }
      
      public function setSegments(param1:Object) : AppleConnectRequest
      {
         this.data["segments"] = param1;
         return this;
      }
      
      public function setSwitchIfPossible(param1:Boolean) : AppleConnectRequest
      {
         this.data["switchIfPossible"] = param1;
         return this;
      }
      
      public function setSyncDisplayName(param1:Boolean) : AppleConnectRequest
      {
         this.data["syncDisplayName"] = param1;
         return this;
      }
   }
}

