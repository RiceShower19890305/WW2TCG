package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class FindPendingMatchesRequest extends GSRequest
   {
      
      public function FindPendingMatchesRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".FindPendingMatchesRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : FindPendingMatchesRequest
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
               callback(new FindPendingMatchesResponse(param1));
            }
         });
      }
      
      public function setScriptData(param1:Object) : FindPendingMatchesRequest
      {
         data["scriptData"] = param1;
         return this;
      }
      
      public function setMatchGroup(param1:String) : FindPendingMatchesRequest
      {
         this.data["matchGroup"] = param1;
         return this;
      }
      
      public function setMatchShortCode(param1:String) : FindPendingMatchesRequest
      {
         this.data["matchShortCode"] = param1;
         return this;
      }
      
      public function setMaxMatchesToFind(param1:Number) : FindPendingMatchesRequest
      {
         this.data["maxMatchesToFind"] = param1;
         return this;
      }
   }
}

