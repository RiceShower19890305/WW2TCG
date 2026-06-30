package com.gamesparks.api.responses
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class PushRegistrationResponse extends GSResponse
   {
      
      public function PushRegistrationResponse(param1:Object)
      {
         super(param1);
      }
      
      public function getRegistrationId() : String
      {
         if(data.registrationId != null)
         {
            return data.registrationId;
         }
         return null;
      }
   }
}

