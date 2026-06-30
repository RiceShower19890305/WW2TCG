package com.gamesparks.api.types
{
   import com.gamesparks.*;
   
   public class PlayerMessage extends GSData
   {
      
      public function PlayerMessage(param1:Object)
      {
         super(param1);
      }
      
      public function getId() : String
      {
         if(data.id != null)
         {
            return data.id;
         }
         return null;
      }
      
      public function getMessage() : Object
      {
         if(data.message != null)
         {
            return data.message;
         }
         return null;
      }
      
      public function getSeen() : Boolean
      {
         if(data.seen != null)
         {
            return data.seen;
         }
         return false;
      }
      
      public function getStatus() : String
      {
         if(data.status != null)
         {
            return data.status;
         }
         return null;
      }
      
      public function getWhen() : Date
      {
         if(data.when != null)
         {
            return RFC3339toDate(data.when);
         }
         return null;
      }
   }
}

