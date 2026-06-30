package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class BatchAdminRequest extends GSRequest
   {
      
      public function BatchAdminRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".BatchAdminRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : BatchAdminRequest
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
               callback(new BatchAdminResponse(param1));
            }
         });
      }
      
      public function setScriptData(param1:Object) : BatchAdminRequest
      {
         data["scriptData"] = param1;
         return this;
      }
      
      public function setPlayerIds(param1:Vector.<String>) : BatchAdminRequest
      {
         this.data["playerIds"] = toArray(param1);
         return this;
      }
      
      public function setRequest(param1:Object) : BatchAdminRequest
      {
         this.data["request"] = param1;
         return this;
      }
   }
}

