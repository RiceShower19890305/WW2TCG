package com.gamesparks.api.messages
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class UploadCompleteMessage extends GSResponse
   {
      
      public static var MESSAGE_TYPE:String = ".UploadCompleteMessage";
      
      public function UploadCompleteMessage(param1:Object)
      {
         super(param1);
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
      
      public function getUploadData() : UploadData
      {
         if(data.uploadData != null)
         {
            return new UploadData(data.uploadData);
         }
         return null;
      }
      
      public function getUploadId() : String
      {
         if(data.uploadId != null)
         {
            return data.uploadId;
         }
         return null;
      }
   }
}

