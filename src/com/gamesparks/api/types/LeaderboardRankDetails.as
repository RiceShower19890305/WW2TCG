package com.gamesparks.api.types
{
   import com.gamesparks.*;
   
   public class LeaderboardRankDetails extends GSData
   {
      
      public function LeaderboardRankDetails(param1:Object)
      {
         super(param1);
      }
      
      public function getFriendsPassed() : Vector.<LeaderboardData>
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc1_:Vector.<LeaderboardData> = new Vector.<LeaderboardData>();
         if(data.friendsPassed != null)
         {
            _loc2_ = data.friendsPassed;
            for(_loc3_ in _loc2_)
            {
               _loc1_.push(new LeaderboardData(_loc2_[_loc3_]));
            }
         }
         return _loc1_;
      }
      
      public function getGlobalCount() : Number
      {
         if(data.globalCount != null)
         {
            return data.globalCount;
         }
         return NaN;
      }
      
      public function getGlobalFrom() : Number
      {
         if(data.globalFrom != null)
         {
            return data.globalFrom;
         }
         return NaN;
      }
      
      public function getGlobalFromPercent() : Number
      {
         if(data.globalFromPercent != null)
         {
            return data.globalFromPercent;
         }
         return NaN;
      }
      
      public function getGlobalTo() : Number
      {
         if(data.globalTo != null)
         {
            return data.globalTo;
         }
         return NaN;
      }
      
      public function getGlobalToPercent() : Number
      {
         if(data.globalToPercent != null)
         {
            return data.globalToPercent;
         }
         return NaN;
      }
      
      public function getSocialCount() : Number
      {
         if(data.socialCount != null)
         {
            return data.socialCount;
         }
         return NaN;
      }
      
      public function getSocialFrom() : Number
      {
         if(data.socialFrom != null)
         {
            return data.socialFrom;
         }
         return NaN;
      }
      
      public function getSocialFromPercent() : Number
      {
         if(data.socialFromPercent != null)
         {
            return data.socialFromPercent;
         }
         return NaN;
      }
      
      public function getSocialTo() : Number
      {
         if(data.socialTo != null)
         {
            return data.socialTo;
         }
         return NaN;
      }
      
      public function getSocialToPercent() : Number
      {
         if(data.socialToPercent != null)
         {
            return data.socialToPercent;
         }
         return NaN;
      }
      
      public function getTopNPassed() : Vector.<LeaderboardData>
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc1_:Vector.<LeaderboardData> = new Vector.<LeaderboardData>();
         if(data.topNPassed != null)
         {
            _loc2_ = data.topNPassed;
            for(_loc3_ in _loc2_)
            {
               _loc1_.push(new LeaderboardData(_loc2_[_loc3_]));
            }
         }
         return _loc1_;
      }
   }
}

