package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class ListChallengeRequest extends GSRequest
   {
      
      public function ListChallengeRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".ListChallengeRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : ListChallengeRequest
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
               callback(new ListChallengeResponse(param1));
            }
         });
      }
      
      public function setScriptData(param1:Object) : ListChallengeRequest
      {
         data["scriptData"] = param1;
         return this;
      }
      
      public function setEntryCount(param1:Number) : ListChallengeRequest
      {
         this.data["entryCount"] = param1;
         return this;
      }
      
      public function setOffset(param1:Number) : ListChallengeRequest
      {
         this.data["offset"] = param1;
         return this;
      }
      
      public function setShortCode(param1:String) : ListChallengeRequest
      {
         this.data["shortCode"] = param1;
         return this;
      }
      
      public function setState(param1:String) : ListChallengeRequest
      {
         this.data["state"] = param1;
         return this;
      }
      
      public function setStates(param1:Vector.<String>) : ListChallengeRequest
      {
         this.data["states"] = toArray(param1);
         return this;
      }
   }
}

