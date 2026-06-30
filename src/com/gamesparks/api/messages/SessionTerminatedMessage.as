package com.gamesparks.api.messages
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class SessionTerminatedMessage extends GSResponse
   {
      
      public static var MESSAGE_TYPE:String = ".SessionTerminatedMessage";
      
      public function SessionTerminatedMessage(param1:Object)
      {
         super(param1);
      }
      
      public function getAuthToken() : String
      {
         if(data.authToken != null)
         {
            return data.authToken;
         }
         return null;
      }
   }
}

