package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class MatchDetailsRequest extends GSRequest
   {
      
      public function MatchDetailsRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".MatchDetailsRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : MatchDetailsRequest
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
               callback(new MatchDetailsResponse(param1));
            }
         });
      }
      
      public function setScriptData(param1:Object) : MatchDetailsRequest
      {
         data["scriptData"] = param1;
         return this;
      }
      
      public function setMatchId(param1:String) : MatchDetailsRequest
      {
         this.data["matchId"] = param1;
         return this;
      }
      
      public function setRealtimeEnabled(param1:Boolean) : MatchDetailsRequest
      {
         this.data["realtimeEnabled"] = param1;
         return this;
      }
   }
}

