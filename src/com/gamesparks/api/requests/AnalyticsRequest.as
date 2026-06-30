package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class AnalyticsRequest extends GSRequest
   {
      
      public function AnalyticsRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".AnalyticsRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : AnalyticsRequest
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
               callback(new AnalyticsResponse(param1));
            }
         });
      }
      
      public function setScriptData(param1:Object) : AnalyticsRequest
      {
         data["scriptData"] = param1;
         return this;
      }
      
      public function setData(param1:Object) : AnalyticsRequest
      {
         this.data["data"] = param1;
         return this;
      }
      
      public function setEnd(param1:Boolean) : AnalyticsRequest
      {
         this.data["end"] = param1;
         return this;
      }
      
      public function setKey(param1:String) : AnalyticsRequest
      {
         this.data["key"] = param1;
         return this;
      }
      
      public function setStart(param1:Boolean) : AnalyticsRequest
      {
         this.data["start"] = param1;
         return this;
      }
   }
}

