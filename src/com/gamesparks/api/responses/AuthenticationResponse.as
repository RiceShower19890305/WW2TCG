package com.gamesparks.api.responses
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class AuthenticationResponse extends GSResponse
   {
      
      public function AuthenticationResponse(param1:Object)
      {
         super(param1);
      }
      
      public function getAuthToken() : String
      {
         if(data.authToken != null)
         {
            return data.authToken;
         }
         return null;
      }
      
      public function getDisplayName() : String
      {
         if(data.displayName != null)
         {
            return data.displayName;
         }
         return null;
      }
      
      public function getNewPlayer() : Boolean
      {
         if(data.newPlayer != null)
         {
            return data.newPlayer;
         }
         return false;
      }
      
      public function getSwitchSummary() : Player
      {
         if(data.switchSummary != null)
         {
            return new Player(data.switchSummary);
         }
         return null;
      }
      
      public function getUserId() : String
      {
         if(data.userId != null)
         {
            return data.userId;
         }
         return null;
      }
   }
}

