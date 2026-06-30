package com.gamesparks.api.responses
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class ListTeamsResponse extends GSResponse
   {
      
      public function ListTeamsResponse(param1:Object)
      {
         super(param1);
      }
      
      public function getTeams() : Vector.<Team>
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc1_:Vector.<Team> = new Vector.<Team>();
         if(data.teams != null)
         {
            _loc2_ = data.teams;
            for(_loc3_ in _loc2_)
            {
               _loc1_.push(new Team(_loc2_[_loc3_]));
            }
         }
         return _loc1_;
      }
   }
}

