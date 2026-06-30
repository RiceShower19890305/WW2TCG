package com.gamesparks.api.types
{
   import com.gamesparks.*;
   
   public class PendingMatch extends GSData
   {
      
      public function PendingMatch(param1:Object)
      {
         super(param1);
      }
      
      public function getId() : String
      {
         if(data.id != null)
         {
            return data.id;
         }
         return null;
      }
      
      public function getMatchData() : Object
      {
         if(data.matchData != null)
         {
            return data.matchData;
         }
         return null;
      }
      
      public function getMatchGroup() : String
      {
         if(data.matchGroup != null)
         {
            return data.matchGroup;
         }
         return null;
      }
      
      public function getMatchShortCode() : String
      {
         if(data.matchShortCode != null)
         {
            return data.matchShortCode;
         }
         return null;
      }
      
      public function getMatchedPlayers() : Vector.<MatchedPlayer>
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc1_:Vector.<MatchedPlayer> = new Vector.<MatchedPlayer>();
         if(data.matchedPlayers != null)
         {
            _loc2_ = data.matchedPlayers;
            for(_loc3_ in _loc2_)
            {
               _loc1_.push(new MatchedPlayer(_loc2_[_loc3_]));
            }
         }
         return _loc1_;
      }
      
      public function getSkill() : Number
      {
         if(data.skill != null)
         {
            return data.skill;
         }
         return NaN;
      }
   }
}

