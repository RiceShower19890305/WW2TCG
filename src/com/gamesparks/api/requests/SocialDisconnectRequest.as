package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class SocialDisconnectRequest extends GSRequest
   {
      
      public function SocialDisconnectRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".SocialDisconnectRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : SocialDisconnectRequest
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
               callback(new SocialDisconnectResponse(param1));
            }
         });
      }
      
      public function setScriptData(param1:Object) : SocialDisconnectRequest
      {
         data["scriptData"] = param1;
         return this;
      }
      
      public function setSystemId(param1:String) : SocialDisconnectRequest
      {
         this.data["systemId"] = param1;
         return this;
      }
   }
}

