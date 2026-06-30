package com.fs.tcgengine.utils
{
   public class TimerUtil
   {
      
      private static var mDate:Date = new Date();
      
      public static const SECOND_TO_MS:Number = 1000;
      
      public static const MIN_TO_MS:Number = 60 * SECOND_TO_MS;
      
      public static const HOUR_TO_MS:Number = 60 * MIN_TO_MS;
      
      public static const DAY_TO_MS:Number = 24 * HOUR_TO_MS;
      
      public function TimerUtil()
      {
         super();
      }
      
      public static function currentTimeMillis() : Number
      {
         mDate = new Date();
         return mDate.getTime();
      }
      
      public static function hourToMs(param1:Number) : Number
      {
         return param1 * HOUR_TO_MS;
      }
      
      public static function msToHour(param1:Number) : int
      {
         return param1 / HOUR_TO_MS;
      }
      
      public static function msToDays(param1:Number) : int
      {
         return param1 / DAY_TO_MS;
      }
      
      public static function minToMs(param1:Number) : Number
      {
         return param1 * MIN_TO_MS;
      }
      
      public static function minToHours(param1:Number) : Number
      {
         return msToHour(minToMs(param1));
      }
      
      public static function msToSec(param1:Number) : Number
      {
         return param1 / SECOND_TO_MS;
      }
      
      public static function msToMin(param1:Number) : Number
      {
         return param1 / MIN_TO_MS;
      }
      
      public static function secondToMs(param1:Number) : Number
      {
         return param1 * SECOND_TO_MS;
      }
      
      public static function daysToMs(param1:Number) : Number
      {
         return param1 * 24 * HOUR_TO_MS;
      }
      
      public static function getDateInMs(param1:String) : Number
      {
         var _loc2_:Array = param1.split(":");
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(_loc2_.length > 3)
         {
            _loc3_ = int(_loc2_[3]);
            _loc4_ = int(_loc2_[4]);
         }
         var _loc5_:Date = new Date(_loc2_[2],_loc2_[1] - 1,_loc2_[0],_loc3_,_loc4_);
         return _loc5_.getTime();
      }
      
      public static function getUnixTime(param1:Date = null) : int
      {
         if(param1 == null)
         {
            param1 = new Date();
         }
         return Math.round(param1.getTime() * 0.001);
      }
      
      public static function getTimeTextFromMs(param1:Number, param2:String = null, param3:String = null, param4:String = null, param5:String = null, param6:Boolean = true, param7:Boolean = true) : String
      {
         var _loc8_:int = Math.abs(msToDays(param1));
         var _loc9_:int = Math.abs(msToHour(param1 - _loc8_ * DAY_TO_MS));
         var _loc10_:int = Math.abs(msToMin(param1 - _loc8_ * DAY_TO_MS - _loc9_ * HOUR_TO_MS));
         var _loc11_:int = Math.abs(Math.round((param1 - _loc8_ * DAY_TO_MS - _loc9_ * HOUR_TO_MS - _loc10_ * MIN_TO_MS) / 1000));
         var _loc12_:Boolean = false;
         var _loc13_:String = "";
         _loc13_ = _loc13_ + printTime(param2,_loc8_,param6,_loc12_);
         if(param7)
         {
            _loc12_ ||= param2 != null && _loc8_ > 0;
         }
         _loc13_ += printTime(param3,_loc9_,param6,_loc12_);
         if(param7)
         {
            _loc12_ ||= param3 != null && _loc9_ > 0;
         }
         _loc10_ = _loc11_ == 60 ? int(_loc10_ + 1) : _loc10_;
         _loc13_ += printTime(param4,_loc10_,param6,_loc12_);
         if(param7)
         {
            _loc12_ ||= param4 != null && _loc10_ > 0;
         }
         _loc11_ = _loc11_ == 60 ? 0 : _loc11_;
         _loc13_ += printTime(param5,_loc11_,param6,_loc12_);
         if(_loc13_ == "")
         {
            if(param5 != null)
            {
               _loc13_ += _loc11_ + " " + param5 + " ";
            }
            else if(param4 != null)
            {
               _loc13_ += _loc10_ + " " + param4 + " ";
            }
            else if(param3 != null)
            {
               _loc13_ += _loc9_ + " " + param3 + " ";
            }
            else if(param2 != null)
            {
               _loc13_ += _loc8_ + " " + param2 + " ";
            }
         }
         return _loc13_;
      }
      
      private static function printTime(param1:String, param2:int, param3:Boolean, param4:Boolean) : String
      {
         if(param1 == null)
         {
            return "";
         }
         if(param3 == false && param2 == 0 && param4 == false)
         {
            return "";
         }
         return Utils.transformValueToString(param2.toString(),2) + "" + param1 + "";
      }
      
      public static function dateFromMs(param1:Number, param2:Date = null) : Date
      {
         var _loc3_:Date = null;
         if(param2 == null)
         {
            _loc3_ = new Date();
            _loc3_.setTime(param1);
            return _loc3_;
         }
         param2.setTime(param1);
         return param2;
      }
      
      public static function convertServerUCTDateToDate(param1:String) : Date
      {
         var _loc2_:Array = param1.split(" (UTC)");
         var _loc3_:Number = Date.parse(_loc2_[0]);
         return TimerUtil.dateFromMs(_loc3_);
      }
      
      public static function getDaysBetweenDates(param1:Date, param2:Date) : Number
      {
         var _loc3_:Number = param1.getTime();
         var _loc4_:Number = param2.getTime();
         var _loc5_:Number = Math.abs(_loc3_ - _loc4_);
         return Math.round(_loc5_ / DAY_TO_MS);
      }
   }
}

