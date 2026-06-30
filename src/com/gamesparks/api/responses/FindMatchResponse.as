package com.gamesparks.api.responses
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class FindMatchResponse extends GSResponse
   {
      
      public function FindMatchResponse(param1:Object)
      {
         super(param1);
      }
      
      public function getAccessToken() : String
      {
         if(data.accessToken != null)
         {
            return data.accessToken;
         }
         return null;
      }
      
      public function getHost() : String
      {
         if(data.host != null)
         {
            return data.host;
         }
         return null;
      }
      
      public function getMatchData() : Object
      {
         if(data.matchData != null)
         {
            return data.matchData;
         }
         return null;
      }
      
      public function getMatchId() : String
      {
         if(data.matchId != null)
         {
            return data.matchId;
         }
         return null;
      }
      
      public function getOpponents() : Vector.<Player>
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc1_:Vector.<Player> = new Vector.<Player>();
         if(data.opponents != null)
         {
            _loc2_ = data.opponents;
            for(_loc3_ in _loc2_)
            {
               _loc1_.push(new Player(_loc2_[_loc3_]));
            }
         }
         return _loc1_;
      }
      
      public function getPeerId() : Number
      {
         if(data.peerId != null)
         {
            return data.peerId;
         }
         return NaN;
      }
      
      public function getPlayerId() : String
      {
         if(data.playerId != null)
         {
            return data.playerId;
         }
         return null;
      }
      
      public function getPort() : Number
      {
         if(data.port != null)
         {
            return data.port;
         }
         return NaN;
      }
   }
}

