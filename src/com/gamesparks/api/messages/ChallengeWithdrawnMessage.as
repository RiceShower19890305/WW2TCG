package com.gamesparks.api.messages
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class ChallengeWithdrawnMessage extends GSResponse
   {
      
      public static var MESSAGE_TYPE:String = ".ChallengeWithdrawnMessage";
      
      public function ChallengeWithdrawnMessage(param1:Object)
      {
         super(param1);
      }
      
      public function getChallenge() : Challenge
      {
         if(data.challenge != null)
         {
            return new Challenge(data.challenge);
         }
         return null;
      }
      
      public function getMessage() : String
      {
         if(data.message != null)
         {
            return data.message;
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
      
      public function getWho() : String
      {
         if(data.who != null)
         {
            return data.who;
         }
         return null;
      }
   }
}

