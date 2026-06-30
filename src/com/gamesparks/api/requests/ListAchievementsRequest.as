package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class ListAchievementsRequest extends GSRequest
   {
      
      public function ListAchievementsRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".ListAchievementsRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : ListAchievementsRequest
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
               callback(new ListAchievementsResponse(param1));
            }
         });
      }
      
      public function setScriptData(param1:Object) : ListAchievementsRequest
      {
         data["scriptData"] = param1;
         return this;
      }
   }
}

