package com.gamesparks.api.types
{
   import com.gamesparks.*;
   
   public class Leaderboard extends GSData
   {
      
      public function Leaderboard(param1:Object)
      {
         super(param1);
      }
      
      public function getDescription() : String
      {
         if(data.description != null)
         {
            return data.description;
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
      
      public function getPropertySet() : Object
      {
         if(data.propertySet != null)
         {
            return data.propertySet;
         }
         return null;
      }
      
      public function getShortCode() : String
      {
         if(data.shortCode != null)
         {
            return data.shortCode;
         }
         return null;
      }
   }
}

