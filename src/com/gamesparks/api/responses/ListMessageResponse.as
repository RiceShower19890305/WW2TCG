package com.gamesparks.api.responses
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class ListMessageResponse extends GSResponse
   {
      
      public function ListMessageResponse(param1:Object)
      {
         super(param1);
      }
      
      public function getMessageList() : Vector.<Object>
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc1_:Vector.<Object> = new Vector.<Object>();
         if(data.messageList != null)
         {
            _loc2_ = data.messageList;
            for(_loc3_ in _loc2_)
            {
               _loc1_.push(_loc2_[_loc3_]);
            }
         }
         return _loc1_;
      }
   }
}

