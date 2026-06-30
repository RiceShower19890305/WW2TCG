package com.gamesparks.api.responses
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class GetDownloadableResponse extends GSResponse
   {
      
      public function GetDownloadableResponse(param1:Object)
      {
         super(param1);
      }
      
      public function getLastModified() : Date
      {
         if(data.lastModified != null)
         {
            return RFC3339toDate(data.lastModified);
         }
         return null;
      }
      
      public function getShortCode() : String
      {
         if(data.shortCode != null)
         {
            return data.shortCode;
         }
         return null;
      }
      
      public function getSize() : Number
      {
         if(data.size != null)
         {
            return data.size;
         }
         return NaN;
      }
      
      public function getUrl() : String
      {
         if(data.url != null)
         {
            return data.url;
         }
         return null;
      }
   }
}

