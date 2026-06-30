package com.gamesparks.api.responses
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class JoinChallengeResponse extends GSResponse
   {
      
      public function JoinChallengeResponse(param1:Object)
      {
         super(param1);
      }
      
      public function getJoined() : Boolean
      {
         if(data.joined != null)
         {
            return data.joined;
         }
         return false;
      }
   }
}

