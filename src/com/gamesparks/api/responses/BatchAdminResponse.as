package com.gamesparks.api.responses
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class BatchAdminResponse extends GSResponse
   {
      
      public function BatchAdminResponse(param1:Object)
      {
         super(param1);
      }
      
      public function getResponses() : Object
      {
         if(data.responses != null)
         {
            return data.responses;
         }
         return null;
      }
   }
}

