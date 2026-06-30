package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class DismissMultipleMessagesRequest extends GSRequest
   {
      
      public function DismissMultipleMessagesRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".DismissMultipleMessagesRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : DismissMultipleMessagesRequest
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
               callback(new DismissMultipleMessagesResponse(param1));
            }
         });
      }
      
      public function setScriptData(param1:Object) : DismissMultipleMessagesRequest
      {
         data["scriptData"] = param1;
         return this;
      }
      
      public function setMessageIds(param1:Vector.<String>) : DismissMultipleMessagesRequest
      {
         this.data["messageIds"] = toArray(param1);
         return this;
      }
   }
}

