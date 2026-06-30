package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class JoinPendingMatchRequest extends GSRequest
   {
      
      public function JoinPendingMatchRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".JoinPendingMatchRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : JoinPendingMatchRequest
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
               callback(new JoinPendingMatchResponse(param1));
            }
         });
      }
      
      public function setScriptData(param1:Object) : JoinPendingMatchRequest
      {
         data["scriptData"] = param1;
         return this;
      }
      
      public function setMatchGroup(param1:String) : JoinPendingMatchRequest
      {
         this.data["matchGroup"] = param1;
         return this;
      }
      
      public function setMatchShortCode(param1:String) : JoinPendingMatchRequest
      {
         this.data["matchShortCode"] = param1;
         return this;
      }
      
      public function setPendingMatchId(param1:String) : JoinPendingMatchRequest
      {
         this.data["pendingMatchId"] = param1;
         return this;
      }
   }
}

