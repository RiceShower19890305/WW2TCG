package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class NXConnectRequest extends GSRequest
   {
      
      public function NXConnectRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".NXConnectRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : NXConnectRequest
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
      
      public function setScriptData(param1:Object) : NXConnectRequest
      {
         data["scriptData"] = param1;
         return this;
      }
      
      public function setAccountPerLoginId(param1:Boolean) : NXConnectRequest
      {
         this.data["accountPerLoginId"] = param1;
         return this;
      }
      
      public function setDisplayName(param1:String) : NXConnectRequest
      {
         this.data["displayName"] = param1;
         return this;
      }
      
      public function setDoNotLinkToCurrentPlayer(param1:Boolean) : NXConnectRequest
      {
         this.data["doNotLinkToCurrentPlayer"] = param1;
         return this;
      }
      
      public function setErrorOnSwitch(param1:Boolean) : NXConnectRequest
      {
         this.data["errorOnSwitch"] = param1;
         return this;
      }
      
      public function setNsaIdToken(param1:String) : NXConnectRequest
      {
         this.data["nsaIdToken"] = param1;
         return this;
      }
      
      public function setSegments(param1:Object) : NXConnectRequest
      {
         this.data["segments"] = param1;
         return this;
      }
      
      public function setSwitchIfPossible(param1:Boolean) : NXConnectRequest
      {
         this.data["switchIfPossible"] = param1;
         return this;
      }
      
      public function setSyncDisplayName(param1:Boolean) : NXConnectRequest
      {
         this.data["syncDisplayName"] = param1;
         return this;
      }
   }
}

