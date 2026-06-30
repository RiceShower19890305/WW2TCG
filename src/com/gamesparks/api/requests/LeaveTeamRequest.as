package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class LeaveTeamRequest extends GSRequest
   {
      
      public function LeaveTeamRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".LeaveTeamRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : LeaveTeamRequest
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
               callback(new LeaveTeamResponse(param1));
            }
         });
      }
      
      public function setScriptData(param1:Object) : LeaveTeamRequest
      {
         data["scriptData"] = param1;
         return this;
      }
      
      public function setOwnerId(param1:String) : LeaveTeamRequest
      {
         this.data["ownerId"] = param1;
         return this;
      }
      
      public function setTeamId(param1:String) : LeaveTeamRequest
      {
         this.data["teamId"] = param1;
         return this;
      }
      
      public function setTeamType(param1:String) : LeaveTeamRequest
      {
         this.data["teamType"] = param1;
         return this;
      }
   }
}

