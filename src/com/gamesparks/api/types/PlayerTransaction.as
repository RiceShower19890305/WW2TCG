package com.gamesparks.api.types
{
   import com.gamesparks.*;
   
   public class PlayerTransaction extends GSData
   {
      
      public function PlayerTransaction(param1:Object)
      {
         super(param1);
      }
      
      public function getItems() : Vector.<PlayerTransactionItem>
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc1_:Vector.<PlayerTransactionItem> = new Vector.<PlayerTransactionItem>();
         if(data.items != null)
         {
            _loc2_ = data.items;
            for(_loc3_ in _loc2_)
            {
               _loc1_.push(new PlayerTransactionItem(_loc2_[_loc3_]));
            }
         }
         return _loc1_;
      }
      
      public function getOriginalRequestId() : String
      {
         if(data.originalRequestId != null)
         {
            return data.originalRequestId;
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
      
      public function getReason() : String
      {
         if(data.reason != null)
         {
            return data.reason;
         }
         return null;
      }
      
      public function getRevokeDate() : Date
      {
         if(data.revokeDate != null)
         {
            return RFC3339toDate(data.revokeDate);
         }
         return null;
      }
      
      public function getRevoked() : Boolean
      {
         if(data.revoked != null)
         {
            return data.revoked;
         }
         return false;
      }
      
      public function getScript() : String
      {
         if(data.script != null)
         {
            return data.script;
         }
         return null;
      }
      
      public function getScriptType() : String
      {
         if(data.scriptType != null)
         {
            return data.scriptType;
         }
         return null;
      }
      
      public function getTransactionId() : String
      {
         if(data.transactionId != null)
         {
            return data.transactionId;
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

