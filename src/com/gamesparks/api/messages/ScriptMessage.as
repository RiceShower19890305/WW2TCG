package com.gamesparks.api.messages
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class ScriptMessage extends GSResponse
   {
      
      public static var MESSAGE_TYPE:String = ".ScriptMessage";
      
      public function ScriptMessage(param1:Object)
      {
         super(param1);
      }
      
      public function getData() : Object
      {
         if(data.data != null)
         {
            return data.data;
         }
         return null;
      }
      
      public function getExtCode() : String
      {
         if(data.extCode != null)
         {
            return data.extCode;
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
   }
}

