package com.gamesparks.api.responses
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class LeaveTeamResponse extends GSResponse
   {
      
      public function LeaveTeamResponse(param1:Object)
      {
         super(param1);
      }
      
      public function getMembers() : Vector.<Player>
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc1_:Vector.<Player> = new Vector.<Player>();
         if(data.members != null)
         {
            _loc2_ = data.members;
            for(_loc3_ in _loc2_)
            {
               _loc1_.push(new Player(_loc2_[_loc3_]));
            }
         }
         return _loc1_;
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

