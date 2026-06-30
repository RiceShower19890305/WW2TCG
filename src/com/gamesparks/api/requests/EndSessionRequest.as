package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class EndSessionRequest extends GSRequest
   {
      
      public function EndSessionRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".EndSessionRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : EndSessionRequest
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
               callback(new EndSessionResponse(param1));
            }
         });
      }
      
      public function setScriptData(param1:Object) : EndSessionRequest
      {
         data["scriptData"] = param1;
         return this;
      }
   }
}

