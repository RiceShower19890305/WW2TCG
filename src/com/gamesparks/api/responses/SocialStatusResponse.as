package com.gamesparks.api.responses
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class SocialStatusResponse extends GSResponse
   {
      
      public function SocialStatusResponse(param1:Object)
      {
         super(param1);
      }
      
      public function getStatuses() : Vector.<SocialStatus>
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc1_:Vector.<SocialStatus> = new Vector.<SocialStatus>();
         if(data.statuses != null)
         {
            _loc2_ = data.statuses;
            for(_loc3_ in _loc2_)
            {
               _loc1_.push(new SocialStatus(_loc2_[_loc3_]));
            }
         }
         return _loc1_;
      }
   }
}

