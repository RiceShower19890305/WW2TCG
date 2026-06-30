package com.gamesparks.api.types
{
   import com.gamesparks.*;
   
   public class Location extends GSData
   {
      
      public function Location(param1:Object)
      {
         super(param1);
      }
      
      public function getCity() : String
      {
         if(data.city != null)
         {
            return data.city;
         }
         return null;
      }
      
      public function getCountry() : String
      {
         if(data.country != null)
         {
            return data.country;
         }
         return null;
      }
      
      public function getLatitide() : Number
      {
         if(data.latitide != null)
         {
            return data.latitide;
         }
         return NaN;
      }
      
      public function getLongditute() : Number
      {
         if(data.longditute != null)
         {
            return data.longditute;
         }
         return NaN;
      }
   }
}

