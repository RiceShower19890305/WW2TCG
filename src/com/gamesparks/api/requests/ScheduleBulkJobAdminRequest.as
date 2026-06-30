package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class ScheduleBulkJobAdminRequest extends GSRequest
   {
      
      public function ScheduleBulkJobAdminRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".ScheduleBulkJobAdminRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : ScheduleBulkJobAdminRequest
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
               callback(new ScheduleBulkJobAdminResponse(param1));
            }
         });
      }
      
      public function setScriptData(param1:Object) : ScheduleBulkJobAdminRequest
      {
         data["scriptData"] = param1;
         return this;
      }
      
      public function setData(param1:Object) : ScheduleBulkJobAdminRequest
      {
         this.data["data"] = param1;
         return this;
      }
      
      public function setModuleShortCode(param1:String) : ScheduleBulkJobAdminRequest
      {
         this.data["moduleShortCode"] = param1;
         return this;
      }
      
      public function setPlayerQuery(param1:Object) : ScheduleBulkJobAdminRequest
      {
         this.data["playerQuery"] = param1;
         return this;
      }
      
      public function setScheduledTime(param1:Date) : ScheduleBulkJobAdminRequest
      {
         this.data["scheduledTime"] = dateToRFC3339(param1);
         return this;
      }
      
      public function setScript(param1:String) : ScheduleBulkJobAdminRequest
      {
         this.data["script"] = param1;
         return this;
      }
   }
}

