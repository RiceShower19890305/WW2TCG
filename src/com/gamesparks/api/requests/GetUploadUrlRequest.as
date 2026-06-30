package com.gamesparks.api.requests
{
   import com.gamesparks.*;
   import com.gamesparks.api.responses.*;
   
   public class GetUploadUrlRequest extends GSRequest
   {
      
      public function GetUploadUrlRequest(param1:GS)
      {
         super(param1);
         data["@class"] = ".GetUploadUrlRequest";
      }
      
      public function setTimeoutSeconds(param1:int = 10) : GetUploadUrlRequest
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
               callback(new GetUploadUrlResponse(param1));
            }
         });
      }
      
      public function setScriptData(param1:Object) : GetUploadUrlRequest
      {
         data["scriptData"] = param1;
         return this;
      }
      
      public function setUploadData(param1:Object) : GetUploadUrlRequest
      {
         this.data["uploadData"] = param1;
         return this;
      }
   }
}

