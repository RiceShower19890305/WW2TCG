package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class ListGameFriendsRequest extends GSRequest
   {
      
      public function ListGameFriendsRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".ListGameFriendsRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : ListGameFriendsRequest
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
               callback(new ListGameFriendsResponse(param1));
            }
         });
      }
      
      public function setScriptData(param1:Object) : ListGameFriendsRequest
      {
         data["scriptData"] = param1;
         return this;
      }
   }
}

