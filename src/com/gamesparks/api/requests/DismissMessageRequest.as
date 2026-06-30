package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class DismissMessageRequest extends GSRequest
   {
      
      public function DismissMessageRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".DismissMessageRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : DismissMessageRequest
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
               callback(new DismissMessageResponse(param1));
            }
         });
      }
      
      public function setScriptData(param1:Object) : DismissMessageRequest
      {
         data["scriptData"] = param1;
         return this;
      }
      
      public function setMessageId(param1:String) : DismissMessageRequest
      {
         this.data["messageId"] = param1;
         return this;
      }
   }
}

