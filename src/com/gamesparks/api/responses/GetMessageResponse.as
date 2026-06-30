package com.gamesparks.api.responses
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class GetMessageResponse extends GSResponse
   {
      
      public function GetMessageResponse(param1:Object)
      {
         super(param1);
      }
      
      public function getMessage() : Object
      {
         if(data.message != null)
         {
            return data.message;
         }
         return null;
      }
      
      public function getStatus() : String
      {
         if(data.status != null)
         {
            return data.status;
         }
         return null;
      }
   }
}

