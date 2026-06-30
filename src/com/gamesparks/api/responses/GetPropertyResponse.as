package com.gamesparks.api.responses
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class GetPropertyResponse extends GSResponse
   {
      
      public function GetPropertyResponse(param1:Object)
      {
         super(param1);
      }
      
      public function getProperty() : Object
      {
         if(data.property != null)
         {
            return data.property;
         }
         return null;
      }
   }
}

