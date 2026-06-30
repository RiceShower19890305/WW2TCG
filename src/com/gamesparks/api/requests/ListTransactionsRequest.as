package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class ListTransactionsRequest extends GSRequest
   {
      
      public function ListTransactionsRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".ListTransactionsRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : ListTransactionsRequest
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
               callback(new ListTransactionsResponse(param1));
            }
         });
      }
      
      public function setScriptData(param1:Object) : ListTransactionsRequest
      {
         data["scriptData"] = param1;
         return this;
      }
      
      public function setDateFrom(param1:Date) : ListTransactionsRequest
      {
         this.data["dateFrom"] = dateToRFC3339(param1);
         return this;
      }
      
      public function setDateTo(param1:Date) : ListTransactionsRequest
      {
         this.data["dateTo"] = dateToRFC3339(param1);
         return this;
      }
      
      public function setEntryCount(param1:Number) : ListTransactionsRequest
      {
         this.data["entryCount"] = param1;
         return this;
      }
      
      public function setInclude(param1:String) : ListTransactionsRequest
      {
         this.data["include"] = param1;
         return this;
      }
      
      public function setOffset(param1:Number) : ListTransactionsRequest
      {
         this.data["offset"] = param1;
         return this;
      }
   }
}

