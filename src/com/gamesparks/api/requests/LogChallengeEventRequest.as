package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class LogChallengeEventRequest extends GSRequest
   {
      
      public function LogChallengeEventRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".LogChallengeEventRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : LogChallengeEventRequest
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
               callback(new LogChallengeEventResponse(param1));
            }
         });
      }
      
      public function setNumberEventAttribute(param1:String, param2:Number) : LogChallengeEventRequest
      {
         this.data[param1] = param2;
         return this;
      }
      
      public function setStringEventAttribute(param1:String, param2:String) : LogChallengeEventRequest
      {
         this.data[param1] = param2;
         return this;
      }
      
      public function setJSONEventAttribute(param1:String, param2:Object) : LogChallengeEventRequest
      {
         this.data[param1] = param2;
         return this;
      }
      
      public function setChallengeInstanceId(param1:String) : LogChallengeEventRequest
      {
         this.data["challengeInstanceId"] = param1;
         return this;
      }
      
      public function setEventKey(param1:String) : LogChallengeEventRequest
      {
         this.data["eventKey"] = param1;
         return this;
      }
   }
}

