package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class ListTeamsRequest extends GSRequest
   {
      
      public function ListTeamsRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".ListTeamsRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : ListTeamsRequest
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
               callback(new ListTeamsResponse(param1));
            }
         });
      }
      
      public function setScriptData(param1:Object) : ListTeamsRequest
      {
         data["scriptData"] = param1;
         return this;
      }
      
      public function setEntryCount(param1:Number) : ListTeamsRequest
      {
         this.data["entryCount"] = param1;
         return this;
      }
      
      public function setOffset(param1:Number) : ListTeamsRequest
      {
         this.data["offset"] = param1;
         return this;
      }
      
      public function setTeamNameFilter(param1:String) : ListTeamsRequest
      {
         this.data["teamNameFilter"] = param1;
         return this;
      }
      
      public function setTeamTypeFilter(param1:String) : ListTeamsRequest
      {
         this.data["teamTypeFilter"] = param1;
         return this;
      }
   }
}

