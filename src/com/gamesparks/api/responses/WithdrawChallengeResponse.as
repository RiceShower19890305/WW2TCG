package com.gamesparks.api.responses
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class WithdrawChallengeResponse extends GSResponse
   {
      
      public function WithdrawChallengeResponse(param1:Object)
      {
         super(param1);
      }
      
      public function getChallengeInstanceId() : String
      {
         if(data.challengeInstanceId != null)
         {
            return data.challengeInstanceId;
         }
         return null;
      }
   }
}

