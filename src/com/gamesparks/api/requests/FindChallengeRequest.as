package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class FindChallengeRequest extends GSRequest
   {
      
      public function FindChallengeRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".FindChallengeRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : FindChallengeRequest
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
               callback(new FindChallengeResponse(param1));
            }
         });
      }
      
      public function setScriptData(param1:Object) : FindChallengeRequest
      {
         data["scriptData"] = param1;
         return this;
      }
      
      public function setAccessType(param1:String) : FindChallengeRequest
      {
         this.data["accessType"] = param1;
         return this;
      }
      
      public function setCount(param1:Number) : FindChallengeRequest
      {
         this.data["count"] = param1;
         return this;
      }
      
      public function setEligibility(param1:Object) : FindChallengeRequest
      {
         this.data["eligibility"] = param1;
         return this;
      }
      
      public function setOffset(param1:Number) : FindChallengeRequest
      {
         this.data["offset"] = param1;
         return this;
      }
      
      public function setShortCode(param1:Vector.<String>) : FindChallengeRequest
      {
         this.data["shortCode"] = toArray(param1);
         return this;
      }
   }
}

