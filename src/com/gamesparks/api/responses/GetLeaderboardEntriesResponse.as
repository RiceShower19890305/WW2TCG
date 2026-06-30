package com.gamesparks.api.responses
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class GetLeaderboardEntriesResponse extends GSResponse
   {
      
      public function GetLeaderboardEntriesResponse(param1:Object)
      {
         super(param1);
      }
      
      public function getResults() : Object
      {
         if(data.results != null)
         {
            return data.results;
         }
         return null;
      }
   }
}

