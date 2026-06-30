package com.gamesparks.api.types
{
   import com.gamesparks.*;
   
   public class Achievement extends GSData
   {
      
      public function Achievement(param1:Object)
      {
         super(param1);
      }
      
      public function getDescription() : String
      {
         if(data.description != null)
         {
            return data.description;
         }
         return null;
      }
      
      public function getEarned() : Boolean
      {
         if(data.earned != null)
         {
            return data.earned;
         }
         return false;
      }
      
      public function getName() : String
      {
         if(data.name != null)
         {
            return data.name;
         }
         return null;
      }
      
      public function getPropertySet() : Object
      {
         if(data.propertySet != null)
         {
            return data.propertySet;
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
   }
}

