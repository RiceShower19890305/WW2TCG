package com.gamesparks.api.responses
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class ListLeaderboardsResponse extends GSResponse
   {
      
      public function ListLeaderboardsResponse(param1:Object)
      {
         super(param1);
      }
      
      public function getLeaderboards() : Vector.<Leaderboard>
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc1_:Vector.<Leaderboard> = new Vector.<Leaderboard>();
         if(data.leaderboards != null)
         {
            _loc2_ = data.leaderboards;
            for(_loc3_ in _loc2_)
            {
               _loc1_.push(new Leaderboard(_loc2_[_loc3_]));
            }
         }
         return _loc1_;
      }
   }
}

