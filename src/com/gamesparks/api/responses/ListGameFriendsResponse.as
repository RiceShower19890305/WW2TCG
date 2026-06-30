package com.gamesparks.api.responses
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class ListGameFriendsResponse extends GSResponse
   {
      
      public function ListGameFriendsResponse(param1:Object)
      {
         super(param1);
      }
      
      public function getFriends() : Vector.<Player>
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc1_:Vector.<Player> = new Vector.<Player>();
         if(data.friends != null)
         {
            _loc2_ = data.friends;
            for(_loc3_ in _loc2_)
            {
               _loc1_.push(new Player(_loc2_[_loc3_]));
            }
         }
         return _loc1_;
      }
   }
}

