package com.gamesparks.api.responses
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class FindChallengeResponse extends GSResponse
   {
      
      public function FindChallengeResponse(param1:Object)
      {
         super(param1);
      }
      
      public function getChallengeInstances() : Vector.<Challenge>
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc1_:Vector.<Challenge> = new Vector.<Challenge>();
         if(data.challengeInstances != null)
         {
            _loc2_ = data.challengeInstances;
            for(_loc3_ in _loc2_)
            {
               _loc1_.push(new Challenge(_loc2_[_loc3_]));
            }
         }
         return _loc1_;
      }
   }
}

