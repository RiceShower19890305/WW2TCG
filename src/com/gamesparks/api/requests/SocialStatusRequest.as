package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class SocialStatusRequest extends GSRequest
   {
      
      public function SocialStatusRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".SocialStatusRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : SocialStatusRequest
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
               callback(new SocialStatusResponse(param1));
            }
         });
      }
      
      public function setScriptData(param1:Object) : SocialStatusRequest
      {
         data["scriptData"] = param1;
         return this;
      }
   }
}

