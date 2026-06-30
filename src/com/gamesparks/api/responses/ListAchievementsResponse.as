package com.gamesparks.api.responses
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class ListAchievementsResponse extends GSResponse
   {
      
      public function ListAchievementsResponse(param1:Object)
      {
         super(param1);
      }
      
      public function getAchievements() : Vector.<Achievement>
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc1_:Vector.<Achievement> = new Vector.<Achievement>();
         if(data.achievements != null)
         {
            _loc2_ = data.achievements;
            for(_loc3_ in _loc2_)
            {
               _loc1_.push(new Achievement(_loc2_[_loc3_]));
            }
         }
         return _loc1_;
      }
   }
}

