package com.gamesparks.api.types
{
   import com.gamesparks.*;
   
   public class UploadData extends GSData
   {
      
      public function UploadData(param1:Object)
      {
         super(param1);
      }
      
      public function getFileName() : String
      {
         if(data.fileName != null)
         {
            return data.fileName;
         }
         return null;
      }
      
      public function getPlayerId() : String
      {
         if(data.playerId != null)
         {
            return data.playerId;
         }
         return null;
      }
   }
}

