package com.gamesparks.api.responses
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class AroundMeLeaderboardResponse extends GSResponse
   {
      
      public function AroundMeLeaderboardResponse(param1:Object)
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
      
      public function getData() : Vector.<LeaderboardData>
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc1_:Vector.<LeaderboardData> = new Vector.<LeaderboardData>();
         if(data.data != null)
         {
            _loc2_ = data.data;
            for(_loc3_ in _loc2_)
            {
               _loc1_.push(new LeaderboardData(_loc2_[_loc3_]));
            }
         }
         return _loc1_;
      }
      
      public function getFirst() : Vector.<LeaderboardData>
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc1_:Vector.<LeaderboardData> = new Vector.<LeaderboardData>();
         if(data.first != null)
         {
            _loc2_ = data.first;
            for(_loc3_ in _loc2_)
            {
               _loc1_.push(new LeaderboardData(_loc2_[_loc3_]));
            }
         }
         return _loc1_;
      }
      
      public function getLast() : Vector.<LeaderboardData>
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc1_:Vector.<LeaderboardData> = new Vector.<LeaderboardData>();
         if(data.last != null)
         {
            _loc2_ = data.last;
            for(_loc3_ in _loc2_)
            {
               _loc1_.push(new LeaderboardData(_loc2_[_loc3_]));
            }
         }
         return _loc1_;
      }
      
      public function getLeaderboardShortCode() : String
      {
         if(data.leaderboardShortCode != null)
         {
            return data.leaderboardShortCode;
         }
         return null;
      }
      
      public function getSocial() : Boolean
      {
         if(data.social != null)
         {
            return data.social;
         }
         return false;
      }
   }
}

