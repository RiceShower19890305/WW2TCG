package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class ListMessageDetailRequest extends GSRequest
   {
      
      public function ListMessageDetailRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".ListMessageDetailRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : ListMessageDetailRequest
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
               callback(new ListMessageDetailResponse(param1));
            }
         });
      }
      
      public function setScriptData(param1:Object) : ListMessageDetailRequest
      {
         data["scriptData"] = param1;
         return this;
      }
      
      public function setEntryCount(param1:Number) : ListMessageDetailRequest
      {
         this.data["entryCount"] = param1;
         return this;
      }
      
      public function setInclude(param1:String) : ListMessageDetailRequest
      {
         this.data["include"] = param1;
         return this;
      }
      
      public function setOffset(param1:Number) : ListMessageDetailRequest
      {
         this.data["offset"] = param1;
         return this;
      }
      
      public function setStatus(param1:String) : ListMessageDetailRequest
      {
         this.data["status"] = param1;
         return this;
      }
   }
}

