package com.gamesparks
{
   public class GSData
   {
      
      public var data:Object = new Object();
      
      public function GSData(param1:Object)
      {
         super();
         this.data = param1;
      }
      
      public function getAttribute(param1:String) : Object
      {
         return this.data[param1];
      }
      
      public function setAttribute(param1:String, param2:Object) : GSData
      {
         this.data[param1] = param2;
         return this;
      }
      
      protected function dateToRFC3339(param1:Date) : String
      {
         var _loc2_:String = param1.getUTCMonth() + 1 < 10 ? "0" + (param1.getUTCMonth() + 1) : "" + (param1.getUTCMonth() + 1);
         var _loc3_:String = param1.getUTCDate() < 10 ? "0" + param1.getUTCDate() : "" + param1.getUTCDate();
         var _loc4_:String = param1.getUTCHours() < 10 ? "0" + param1.getUTCHours() : "" + param1.getUTCHours();
         var _loc5_:String = param1.getUTCMinutes() < 10 ? "0" + param1.getUTCMinutes() : "" + param1.getUTCMinutes();
         return param1.getUTCFullYear() + "-" + _loc2_ + "-" + _loc3_ + "T" + _loc4_ + ":" + _loc5_ + "Z";
      }
      
      protected function RFC3339toDate(param1:String) : Date
      {
         var _loc10_:Number = NaN;
         var _loc12_:int = 0;
         var _loc13_:Array = null;
         var _loc14_:Number = NaN;
         var _loc2_:Array = param1.split("T");
         var _loc3_:Array = _loc2_[0].split("-");
         var _loc4_:int = int(_loc3_[0]);
         var _loc5_:int = int(_loc3_[1] - 1);
         var _loc6_:int = int(_loc3_[2]);
         var _loc7_:Array = _loc2_[1].split(":");
         var _loc8_:int = int(_loc7_[0]);
         var _loc9_:int = int(_loc7_[1]);
         var _loc11_:String = _loc7_[2];
         if(_loc11_.charAt(_loc11_.length - 1) == "Z")
         {
            _loc12_ = 0;
            _loc10_ = parseFloat(_loc11_.slice(0,_loc11_.length - 1));
         }
         else
         {
            if(_loc11_.indexOf("+") != -1)
            {
               _loc13_ = _loc11_.split("+");
               _loc12_ = 1;
            }
            else
            {
               if(_loc11_.indexOf("-") == -1)
               {
                  throw new Error("Invalid Format: cannot parse RFC3339 String.");
               }
               _loc13_ = _loc11_.split("-");
               _loc12_ = -1;
            }
            _loc10_ = parseFloat(_loc13_[0]);
            _loc14_ = 0;
            if(_loc7_[3])
            {
               _loc14_ = parseFloat(_loc13_[1]) * 3600000;
               _loc14_ = _loc14_ + parseFloat(_loc7_[3]) * 60000;
            }
            else
            {
               _loc14_ = parseFloat(_loc13_[1]) * 60000;
            }
            _loc12_ *= _loc14_;
         }
         return new Date(Date.UTC(_loc4_,_loc5_,_loc6_,_loc8_,_loc9_,_loc10_) + _loc12_);
      }
   }
}

