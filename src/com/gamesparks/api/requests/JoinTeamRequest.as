package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class JoinTeamRequest extends GSRequest
   {
      
      public function JoinTeamRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".JoinTeamRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : JoinTeamRequest
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
               callback(new JoinTeamResponse(param1));
            }
         });
      }
      
      public function setScriptData(param1:Object) : JoinTeamRequest
      {
         data["scriptData"] = param1;
         return this;
      }
      
      public function setOwnerId(param1:String) : JoinTeamRequest
      {
         this.data["ownerId"] = param1;
         return this;
      }
      
      public function setTeamId(param1:String) : JoinTeamRequest
      {
         this.data["teamId"] = param1;
         return this;
      }
      
      public function setTeamType(param1:String) : JoinTeamRequest
      {
         this.data["teamType"] = param1;
         return this;
      }
   }
}

