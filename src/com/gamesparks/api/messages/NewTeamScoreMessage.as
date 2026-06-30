package com.gamesparks.api.messages
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class NewTeamScoreMessage extends GSResponse
   {
      
      public static var MESSAGE_TYPE:String = ".NewTeamScoreMessage";
      
      public function NewTeamScoreMessage(param1:Object)
      {
         super(param1);
      }
      
      public function getLeaderboardData() : LeaderboardData
      {
         if(data.leaderboardData != null)
         {
            return new LeaderboardData(data.leaderboardData);
         }
         return null;
      }
      
      public function getLeaderboardName() : String
      {
         if(data.leaderboardName != null)
         {
            return data.leaderboardName;
         }
         return null;
      }
      
      public function getLeaderboardShortCode() : String
      {
         if(data.leaderboardShortCode != null)
         {
            return data.leaderboardShortCode;
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
      
      public function getRankDetails() : LeaderboardRankDetails
      {
         if(data.rankDetails != null)
         {
            return new LeaderboardRankDetails(data.rankDetails);
         }
         return null;
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

