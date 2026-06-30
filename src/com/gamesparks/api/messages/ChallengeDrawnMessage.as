package com.gamesparks.api.messages
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class ChallengeDrawnMessage extends GSResponse
   {
      
      public static var MESSAGE_TYPE:String = ".ChallengeDrawnMessage";
      
      public function ChallengeDrawnMessage(param1:Object)
      {
         super(param1);
      }
      
      public function getChallenge() : Challenge
      {
         if(data.challenge != null)
         {
            return new Challenge(data.challenge);
         }
         return null;
      }
      
      public function getLeaderboardData() : LeaderboardData
      {
         if(data.leaderboardData != null)
         {
            return new LeaderboardData(data.leaderboardData);
         }
         return null;
      }
      
      public function getMessageId() : String
      {
         if(data.messageId != null)
         {
            return data.messageId;
         }
         return null;
      }
      
      public function getNotification() : Boolean
      {
         if(data.notification != null)
         {
            return data.notification;
         }
         return false;
      }
      
      public function getSubTitle() : String
      {
         if(data.subTitle != null)
         {
            return data.subTitle;
         }
         return null;
      }
      
      public function getSummary() : String
      {
         if(data.summary != null)
         {
            return data.summary;
         }
         return null;
      }
      
      public function getTitle() : String
      {
         if(data.title != null)
         {
            return data.title;
         }
         return null;
      }
   }
}

