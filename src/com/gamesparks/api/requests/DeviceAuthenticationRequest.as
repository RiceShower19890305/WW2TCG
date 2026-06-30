package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class DeviceAuthenticationRequest extends GSRequest
   {
      
      public function DeviceAuthenticationRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".DeviceAuthenticationRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : DeviceAuthenticationRequest
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
      
      public function setScriptData(param1:Object) : DeviceAuthenticationRequest
      {
         data["scriptData"] = param1;
         return this;
      }
      
      public function setDeviceId(param1:String) : DeviceAuthenticationRequest
      {
         this.data["deviceId"] = param1;
         return this;
      }
      
      public function setDeviceModel(param1:String) : DeviceAuthenticationRequest
      {
         this.data["deviceModel"] = param1;
         return this;
      }
      
      public function setDeviceName(param1:String) : DeviceAuthenticationRequest
      {
         this.data["deviceName"] = param1;
         return this;
      }
      
      public function setDeviceOS(param1:String) : DeviceAuthenticationRequest
      {
         this.data["deviceOS"] = param1;
         return this;
      }
      
      public function setDeviceType(param1:String) : DeviceAuthenticationRequest
      {
         this.data["deviceType"] = param1;
         return this;
      }
      
      public function setDisplayName(param1:String) : DeviceAuthenticationRequest
      {
         this.data["displayName"] = param1;
         return this;
      }
      
      public function setOperatingSystem(param1:String) : DeviceAuthenticationRequest
      {
         this.data["operatingSystem"] = param1;
         return this;
      }
      
      public function setSegments(param1:Object) : DeviceAuthenticationRequest
      {
         this.data["segments"] = param1;
         return this;
      }
   }
}

