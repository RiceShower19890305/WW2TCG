package com.gamesparks.api.messages
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class MatchNotFoundMessage extends GSResponse
   {
      
      public static var MESSAGE_TYPE:String = ".MatchNotFoundMessage";
      
      public function MatchNotFoundMessage(param1:Object)
      {
         super(param1);
      }
      
      public function getMatchData() : Object
      {
         if(data.matchData != null)
         {
            return data.matchData;
         }
         return null;
      }
      
      public function getMatchGroup() : String
      {
         if(data.matchGroup != null)
         {
            return data.matchGroup;
         }
         return null;
      }
      
      public function getMatchShortCode() : String
      {
         if(data.matchShortCode != null)
         {
            return data.matchShortCode;
         }
         return null;
      }
      
      public function getMessageId() : String
      {
         if(data.messageId != null)
         {
            return data.messageId;
         }
         return null;
      }
      
      public function getNotification() : Boolean
      {
         if(data.notification != null)
         {
            return data.notification;
         }
         return false;
      }
      
      public function getParticipantData() : Object
      {
         if(data.participantData != null)
         {
            return data.participantData;
         }
         return null;
      }
      
      public function getParticipants() : Vector.<Participant>
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc1_:Vector.<Participant> = new Vector.<Participant>();
         if(data.participants != null)
         {
            _loc2_ = data.participants;
            for(_loc3_ in _loc2_)
            {
               _loc1_.push(new Participant(_loc2_[_loc3_]));
            }
         }
         return _loc1_;
      }
      
      public function getSubTitle() : String
      {
         if(data.subTitle != null)
         {
            return data.subTitle;
         }
         return null;
      }
      
      public function getSummary() : String
      {
         if(data.summary != null)
         {
            return data.summary;
         }
         return null;
      }
      
      public function getTitle() : String
      {
         if(data.title != null)
         {
            return data.title;
         }
         return null;
      }
   }
}

