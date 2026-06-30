package com.gamesparks.api.responses
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class GetUploadUrlResponse extends GSResponse
   {
      
      public function GetUploadUrlResponse(param1:Object)
      {
         super(param1);
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

