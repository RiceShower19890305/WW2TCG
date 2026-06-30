package com.gamesparks.api.responses
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class GetPropertySetResponse extends GSResponse
   {
      
      public function GetPropertySetResponse(param1:Object)
      {
         super(param1);
      }
      
      public function getPropertySet() : Object
      {
         if(data.propertySet != null)
         {
            return data.propertySet;
         }
         return null;
      }
   }
}

