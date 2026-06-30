package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class CreateChallengeRequest extends GSRequest
   {
      
      public function CreateChallengeRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".CreateChallengeRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : CreateChallengeRequest
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
               callback(new CreateChallengeResponse(param1));
            }
         });
      }
      
      public function setScriptData(param1:Object) : CreateChallengeRequest
      {
         data["scriptData"] = param1;
         return this;
      }
      
      public function setAccessType(param1:String) : CreateChallengeRequest
      {
         this.data["accessType"] = param1;
         return this;
      }
      
      public function setAutoStartJoinedChallengeOnMaxPlayers(param1:Boolean) : CreateChallengeRequest
      {
         this.data["autoStartJoinedChallengeOnMaxPlayers"] = param1;
         return this;
      }
      
      public function setChallengeMessage(param1:String) : CreateChallengeRequest
      {
         this.data["challengeMessage"] = param1;
         return this;
      }
      
      public function setChallengeShortCode(param1:String) : CreateChallengeRequest
      {
         this.data["challengeShortCode"] = param1;
         return this;
      }
      
      public function setCurrency1Wager(param1:Number) : CreateChallengeRequest
      {
         this.data["currency1Wager"] = param1;
         return this;
      }
      
      public function setCurrency2Wager(param1:Number) : CreateChallengeRequest
      {
         this.data["currency2Wager"] = param1;
         return this;
      }
      
      public function setCurrency3Wager(param1:Number) : CreateChallengeRequest
      {
         this.data["currency3Wager"] = param1;
         return this;
      }
      
      public function setCurrency4Wager(param1:Number) : CreateChallengeRequest
      {
         this.data["currency4Wager"] = param1;
         return this;
      }
      
      public function setCurrency5Wager(param1:Number) : CreateChallengeRequest
      {
         this.data["currency5Wager"] = param1;
         return this;
      }
      
      public function setCurrency6Wager(param1:Number) : CreateChallengeRequest
      {
         this.data["currency6Wager"] = param1;
         return this;
      }
      
      public function setCurrencyWagers(param1:Object) : CreateChallengeRequest
      {
         this.data["currencyWagers"] = param1;
         return this;
      }
      
      public function setEligibilityCriteria(param1:Object) : CreateChallengeRequest
      {
         this.data["eligibilityCriteria"] = param1;
         return this;
      }
      
      public function setEndTime(param1:Date) : CreateChallengeRequest
      {
         this.data["endTime"] = dateToRFC3339(param1);
         return this;
      }
      
      public function setExpiryTime(param1:Date) : CreateChallengeRequest
      {
         this.data["expiryTime"] = dateToRFC3339(param1);
         return this;
      }
      
      public function setMaxAttempts(param1:Number) : CreateChallengeRequest
      {
         this.data["maxAttempts"] = param1;
         return this;
      }
      
      public function setMaxPlayers(param1:Number) : CreateChallengeRequest
      {
         this.data["maxPlayers"] = param1;
         return this;
      }
      
      public function setMinPlayers(param1:Number) : CreateChallengeRequest
      {
         this.data["minPlayers"] = param1;
         return this;
      }
      
      public function setSilent(param1:Boolean) : CreateChallengeRequest
      {
         this.data["silent"] = param1;
         return this;
      }
      
      public function setStartTime(param1:Date) : CreateChallengeRequest
      {
         this.data["startTime"] = dateToRFC3339(param1);
         return this;
      }
      
      public function setUsersToChallenge(param1:Vector.<String>) : CreateChallengeRequest
      {
         this.data["usersToChallenge"] = toArray(param1);
         return this;
      }
   }
}

