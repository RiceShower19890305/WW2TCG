package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class UpdateMessageRequest extends GSRequest
   {
      
      public function UpdateMessageRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".UpdateMessageRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : UpdateMessageRequest
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
               callback(new UpdateMessageResponse(param1));
            }
         });
      }
      
      public function setScriptData(param1:Object) : UpdateMessageRequest
      {
         data["scriptData"] = param1;
         return this;
      }
      
      public function setMessageId(param1:String) : UpdateMessageRequest
      {
         this.data["messageId"] = param1;
         return this;
      }
      
      public function setStatus(param1:String) : UpdateMessageRequest
      {
         this.data["status"] = param1;
         return this;
      }
   }
}

