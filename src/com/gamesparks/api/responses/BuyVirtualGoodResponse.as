package com.gamesparks.api.responses
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class BuyVirtualGoodResponse extends GSResponse
   {
      
      public function BuyVirtualGoodResponse(param1:Object)
      {
         super(param1);
      }
      
      public function getBoughtItems() : Vector.<Boughtitem>
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc1_:Vector.<Boughtitem> = new Vector.<Boughtitem>();
         if(data.boughtItems != null)
         {
            _loc2_ = data.boughtItems;
            for(_loc3_ in _loc2_)
            {
               _loc1_.push(new Boughtitem(_loc2_[_loc3_]));
            }
         }
         return _loc1_;
      }
      
      public function getCurrenciesAdded() : Object
      {
         if(data.currenciesAdded != null)
         {
            return data.currenciesAdded;
         }
         return null;
      }
      
      public function getCurrency1Added() : Number
      {
         if(data.currency1Added != null)
         {
            return data.currency1Added;
         }
         return NaN;
      }
      
      public function getCurrency2Added() : Number
      {
         if(data.currency2Added != null)
         {
            return data.currency2Added;
         }
         return NaN;
      }
      
      public function getCurrency3Added() : Number
      {
         if(data.currency3Added != null)
         {
            return data.currency3Added;
         }
         return NaN;
      }
      
      public function getCurrency4Added() : Number
      {
         if(data.currency4Added != null)
         {
            return data.currency4Added;
         }
         return NaN;
      }
      
      public function getCurrency5Added() : Number
      {
         if(data.currency5Added != null)
         {
            return data.currency5Added;
         }
         return NaN;
      }
      
      public function getCurrency6Added() : Number
      {
         if(data.currency6Added != null)
         {
            return data.currency6Added;
         }
         return NaN;
      }
      
      public function getCurrencyConsumed() : Number
      {
         if(data.currencyConsumed != null)
         {
            return data.currencyConsumed;
         }
         return NaN;
      }
      
      public function getCurrencyShortCode() : String
      {
         if(data.currencyShortCode != null)
         {
            return data.currencyShortCode;
         }
         return null;
      }
      
      public function getCurrencyType() : Number
      {
         if(data.currencyType != null)
         {
            return data.currencyType;
         }
         return NaN;
      }
      
      public function getInvalidItems() : Vector.<String>
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc1_:Vector.<String> = new Vector.<String>();
         if(data.invalidItems != null)
         {
            _loc2_ = data.invalidItems;
            for(_loc3_ in _loc2_)
            {
               _loc1_.push(_loc2_[_loc3_]);
            }
         }
         return _loc1_;
      }
      
      public function getTransactionIds() : Vector.<String>
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc1_:Vector.<String> = new Vector.<String>();
         if(data.transactionIds != null)
         {
            _loc2_ = data.transactionIds;
            for(_loc3_ in _loc2_)
            {
               _loc1_.push(_loc2_[_loc3_]);
            }
         }
         return _loc1_;
      }
   }
}

