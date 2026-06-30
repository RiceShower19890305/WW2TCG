package com.gamesparks.api.responses
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class ListTeamChatResponse extends GSResponse
   {
      
      public function ListTeamChatResponse(param1:Object)
      {
         super(param1);
      }
      
      public function getMessages() : Vector.<ChatMessage>
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc1_:Vector.<ChatMessage> = new Vector.<ChatMessage>();
         if(data.messages != null)
         {
            _loc2_ = data.messages;
            for(_loc3_ in _loc2_)
            {
               _loc1_.push(new ChatMessage(_loc2_[_loc3_]));
            }
         }
         return _loc1_;
      }
   }
}

