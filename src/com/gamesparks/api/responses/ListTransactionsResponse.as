package com.gamesparks.api.responses
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class ListTransactionsResponse extends GSResponse
   {
      
      public function ListTransactionsResponse(param1:Object)
      {
         super(param1);
      }
      
      public function getTransactionList() : Vector.<PlayerTransaction>
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc1_:Vector.<PlayerTransaction> = new Vector.<PlayerTransaction>();
         if(data.transactionList != null)
         {
            _loc2_ = data.transactionList;
            for(_loc3_ in _loc2_)
            {
               _loc1_.push(new PlayerTransaction(_loc2_[_loc3_]));
            }
         }
         return _loc1_;
      }
   }
}

