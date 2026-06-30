package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class FindMatchRequest extends GSRequest
   {
      
      public function FindMatchRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".FindMatchRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : FindMatchRequest
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
               callback(new FindMatchResponse(param1));
            }
         });
      }
      
      public function setScriptData(param1:Object) : FindMatchRequest
      {
         data["scriptData"] = param1;
         return this;
      }
      
      public function setAction(param1:String) : FindMatchRequest
      {
         this.data["action"] = param1;
         return this;
      }
      
      public function setMatchGroup(param1:String) : FindMatchRequest
      {
         this.data["matchGroup"] = param1;
         return this;
      }
      
      public function setMatchShortCode(param1:String) : FindMatchRequest
      {
         this.data["matchShortCode"] = param1;
         return this;
      }
      
      public function setSkill(param1:Number) : FindMatchRequest
      {
         this.data["skill"] = param1;
         return this;
      }
   }
}

