package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class ListBulkJobsAdminRequest extends GSRequest
   {
      
      public function ListBulkJobsAdminRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".ListBulkJobsAdminRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : ListBulkJobsAdminRequest
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
               callback(new ListBulkJobsAdminResponse(param1));
            }
         });
      }
      
      public function setScriptData(param1:Object) : ListBulkJobsAdminRequest
      {
         data["scriptData"] = param1;
         return this;
      }
      
      public function setBulkJobIds(param1:Vector.<String>) : ListBulkJobsAdminRequest
      {
         this.data["bulkJobIds"] = toArray(param1);
         return this;
      }
   }
}

