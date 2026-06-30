package com.gamesparks.api.responses
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class FindPendingMatchesResponse extends GSResponse
   {
      
      public function FindPendingMatchesResponse(param1:Object)
      {
         super(param1);
      }
      
      public function getPendingMatches() : Vector.<PendingMatch>
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc1_:Vector.<PendingMatch> = new Vector.<PendingMatch>();
         if(data.pendingMatches != null)
         {
            _loc2_ = data.pendingMatches;
            for(_loc3_ in _loc2_)
            {
               _loc1_.push(new PendingMatch(_loc2_[_loc3_]));
            }
         }
         return _loc1_;
      }
   }
}

