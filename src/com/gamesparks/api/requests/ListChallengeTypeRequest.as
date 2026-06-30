package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class ListChallengeTypeRequest extends GSRequest
   {
      
      public function ListChallengeTypeRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".ListChallengeTypeRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : ListChallengeTypeRequest
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
               callback(new ListChallengeTypeResponse(param1));
            }
         });
      }
      
      public function setScriptData(param1:Object) : ListChallengeTypeRequest
      {
         data["scriptData"] = param1;
         return this;
      }
   }
}

