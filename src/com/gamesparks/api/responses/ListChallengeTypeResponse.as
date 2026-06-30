package com.gamesparks.api.responses
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class ListChallengeTypeResponse extends GSResponse
   {
      
      public function ListChallengeTypeResponse(param1:Object)
      {
         super(param1);
      }
      
      public function getChallengeTemplates() : Vector.<ChallengeType>
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc1_:Vector.<ChallengeType> = new Vector.<ChallengeType>();
         if(data.challengeTemplates != null)
         {
            _loc2_ = data.challengeTemplates;
            for(_loc3_ in _loc2_)
            {
               _loc1_.push(new ChallengeType(_loc2_[_loc3_]));
            }
         }
         return _loc1_;
      }
   }
}

