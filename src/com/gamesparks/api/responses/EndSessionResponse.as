package com.gamesparks.api.responses
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class EndSessionResponse extends GSResponse
   {
      
      public function EndSessionResponse(param1:Object)
      {
         super(param1);
      }
      
      public function getSessionDuration() : Number
      {
         if(data.sessionDuration != null)
         {
            return data.sessionDuration;
         }
         return NaN;
      }
   }
}

