package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class JoinChallengeRequest extends GSRequest
   {
      
      public function JoinChallengeRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".JoinChallengeRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : JoinChallengeRequest
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
               callback(new JoinChallengeResponse(param1));
            }
         });
      }
      
      public function setScriptData(param1:Object) : JoinChallengeRequest
      {
         data["scriptData"] = param1;
         return this;
      }
      
      public function setChallengeInstanceId(param1:String) : JoinChallengeRequest
      {
         this.data["challengeInstanceId"] = param1;
         return this;
      }
      
      public function setEligibility(param1:Object) : JoinChallengeRequest
      {
         this.data["eligibility"] = param1;
         return this;
      }
      
      public function setMessage(param1:String) : JoinChallengeRequest
      {
         this.data["message"] = param1;
         return this;
      }
   }
}

