package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class CancelBulkJobAdminRequest extends GSRequest
   {
      
      public function CancelBulkJobAdminRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".CancelBulkJobAdminRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : CancelBulkJobAdminRequest
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
               callback(new CancelBulkJobAdminResponse(param1));
            }
         });
      }
      
      public function setScriptData(param1:Object) : CancelBulkJobAdminRequest
      {
         data["scriptData"] = param1;
         return this;
      }
      
      public function setBulkJobIds(param1:Vector.<String>) : CancelBulkJobAdminRequest
      {
         this.data["bulkJobIds"] = toArray(param1);
         return this;
      }
   }
}

