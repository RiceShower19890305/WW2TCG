package com.gamesparks.api.types
{
   import com.gamesparks.*;
   
   public class Team extends GSData
   {
      
      public function Team(param1:Object)
      {
         super(param1);
      }
      
      public function getOwner() : Player
      {
         if(data.owner != null)
         {
            return new Player(data.owner);
         }
         return null;
      }
      
      public function getTeamId() : String
      {
         if(data.teamId != null)
         {
            return data.teamId;
         }
         return null;
      }
      
      public function getTeamName() : String
      {
         if(data.teamName != null)
         {
            return data.teamName;
         }
         return null;
      }
      
      public function getTeamType() : String
      {
         if(data.teamType != null)
         {
            return data.teamType;
         }
         return null;
      }
   }
}

