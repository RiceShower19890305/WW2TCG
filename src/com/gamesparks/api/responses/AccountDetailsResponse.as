package com.gamesparks.api.responses
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class AccountDetailsResponse extends GSResponse
   {
      
      public function AccountDetailsResponse(param1:Object)
      {
         super(param1);
      }
      
      public function getAchievements() : Vector.<String>
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc1_:Vector.<String> = new Vector.<String>();
         if(data.achievements != null)
         {
            _loc2_ = data.achievements;
            for(_loc3_ in _loc2_)
            {
               _loc1_.push(_loc2_[_loc3_]);
            }
         }
         return _loc1_;
      }
      
      public function getCurrencies() : Object
      {
         if(data.currencies != null)
         {
            return data.currencies;
         }
         return null;
      }
      
      public function getCurrency1() : Number
      {
         if(data.currency1 != null)
         {
            return data.currency1;
         }
         return NaN;
      }
      
      public function getCurrency2() : Number
      {
         if(data.currency2 != null)
         {
            return data.currency2;
         }
         return NaN;
      }
      
      public function getCurrency3() : Number
      {
         if(data.currency3 != null)
         {
            return data.currency3;
         }
         return NaN;
      }
      
      public function getCurrency4() : Number
      {
         if(data.currency4 != null)
         {
            return data.currency4;
         }
         return NaN;
      }
      
      public function getCurrency5() : Number
      {
         if(data.currency5 != null)
         {
            return data.currency5;
         }
         return NaN;
      }
      
      public function getCurrency6() : Number
      {
         if(data.currency6 != null)
         {
            return data.currency6;
         }
         return NaN;
      }
      
      public function getDisplayName() : String
      {
         if(data.displayName != null)
         {
            return data.displayName;
         }
         return null;
      }
      
      public function getExternalIds() : Object
      {
         if(data.externalIds != null)
         {
            return data.externalIds;
         }
         return null;
      }
      
      public function getLocation() : Location
      {
         if(data.location != null)
         {
            return new Location(data.location);
         }
         return null;
      }
      
      public function getReservedCurrencies() : Object
      {
         if(data.reservedCurrencies != null)
         {
            return data.reservedCurrencies;
         }
         return null;
      }
      
      public function getReservedCurrency1() : Object
      {
         if(data.reservedCurrency1 != null)
         {
            return data.reservedCurrency1;
         }
         return null;
      }
      
      public function getReservedCurrency2() : Object
      {
         if(data.reservedCurrency2 != null)
         {
            return data.reservedCurrency2;
         }
         return null;
      }
      
      public function getReservedCurrency3() : Object
      {
         if(data.reservedCurrency3 != null)
         {
            return data.reservedCurrency3;
         }
         return null;
      }
      
      public function getReservedCurrency4() : Object
      {
         if(data.reservedCurrency4 != null)
         {
            return data.reservedCurrency4;
         }
         return null;
      }
      
      public function getReservedCurrency5() : Object
      {
         if(data.reservedCurrency5 != null)
         {
            return data.reservedCurrency5;
         }
         return null;
      }
      
      public function getReservedCurrency6() : Object
      {
         if(data.reservedCurrency6 != null)
         {
            return data.reservedCurrency6;
         }
         return null;
      }
      
      public function getUserId() : String
      {
         if(data.userId != null)
         {
            return data.userId;
         }
         return null;
      }
      
      public function getVirtualGoods() : Object
      {
         if(data.virtualGoods != null)
         {
            return data.virtualGoods;
         }
         return null;
      }
   }
}

