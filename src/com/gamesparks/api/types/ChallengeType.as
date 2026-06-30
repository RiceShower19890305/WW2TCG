package com.gamesparks.api.types
{
   import com.gamesparks.*;
   
   public class ChallengeType extends GSData
   {
      
      public function ChallengeType(param1:Object)
      {
         super(param1);
      }
      
      public function getChallengeShortCode() : String
      {
         if(data.challengeShortCode != null)
         {
            return data.challengeShortCode;
         }
         return null;
      }
      
      public function getDescription() : String
      {
         if(data.description != null)
         {
            return data.description;
         }
         return null;
      }
      
      public function getGetleaderboardName() : String
      {
         if(data.getleaderboardName != null)
         {
            return data.getleaderboardName;
         }
         return null;
      }
      
      public function getName() : String
      {
         if(data.name != null)
         {
            return data.name;
         }
         return null;
      }
      
      public function getTags() : String
      {
         if(data.tags != null)
         {
            return data.tags;
         }
         return null;
      }
   }
}

