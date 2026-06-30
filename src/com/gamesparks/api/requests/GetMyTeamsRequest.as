package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class GetMyTeamsRequest extends GSRequest
   {
      
      public function GetMyTeamsRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".GetMyTeamsRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : GetMyTeamsRequest
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
               callback(new GetMyTeamsResponse(param1));
            }
         });
      }
      
      public function setScriptData(param1:Object) : GetMyTeamsRequest
      {
         data["scriptData"] = param1;
         return this;
      }
      
      public function setOwnedOnly(param1:Boolean) : GetMyTeamsRequest
      {
         this.data["ownedOnly"] = param1;
         return this;
      }
      
      public function setTeamTypes(param1:Vector.<String>) : GetMyTeamsRequest
      {
         this.data["teamTypes"] = toArray(param1);
         return this;
      }
   }
}

