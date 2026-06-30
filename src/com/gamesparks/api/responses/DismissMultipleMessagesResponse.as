package com.gamesparks.api.responses
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class DismissMultipleMessagesResponse extends GSResponse
   {
      
      public function DismissMultipleMessagesResponse(param1:Object)
      {
         super(param1);
      }
      
      public function getFailedDismissals() : Vector.<String>
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc1_:Vector.<String> = new Vector.<String>();
         if(data.failedDismissals != null)
         {
            _loc2_ = data.failedDismissals;
            for(_loc3_ in _loc2_)
            {
               _loc1_.push(_loc2_[_loc3_]);
            }
         }
         return _loc1_;
      }
      
      public function getMessagesDismissed() : Number
      {
         if(data.messagesDismissed != null)
         {
            return data.messagesDismissed;
         }
         return NaN;
      }
   }
}

