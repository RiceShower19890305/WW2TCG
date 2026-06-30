package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class ListInviteFriendsRequest extends GSRequest
   {
      
      public function ListInviteFriendsRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".ListInviteFriendsRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : ListInviteFriendsRequest
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
               callback(new ListInviteFriendsResponse(param1));
            }
         });
      }
      
      public function setScriptData(param1:Object) : ListInviteFriendsRequest
      {
         data["scriptData"] = param1;
         return this;
      }
   }
}

