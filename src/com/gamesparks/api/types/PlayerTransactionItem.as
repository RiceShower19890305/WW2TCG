package com.gamesparks.api.types
{
   import com.gamesparks.*;
   
   public class PlayerTransactionItem extends GSData
   {
      
      public function PlayerTransactionItem(param1:Object)
      {
         super(param1);
      }
      
      public function getAmount() : Number
      {
         if(data.amount != null)
         {
            return data.amount;
         }
         return NaN;
      }
      
      public function getNewValue() : Number
      {
         if(data.newValue != null)
         {
            return data.newValue;
         }
         return NaN;
      }
      
      public function getType() : String
      {
         if(data.type != null)
         {
            return data.type;
         }
         return null;
      }
   }
}

