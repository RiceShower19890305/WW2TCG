package com.fs.tcgengine.utils
{
   import flash.utils.ByteArray;
   
   public class ProfanityFilter
   {
      
      private static var instance:ProfanityFilter;
      
      private var profanity_EN:Class;
      
      private var pWords:Array;
      
      private var asteriskMarks:Array;
      
      public function ProfanityFilter()
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         this.profanity_EN = ProfanityFilter_profanity_EN;
         super();
         this.pWords = [];
         this.pWords = this.pWords.concat(this.getTextFromBAClass(this.profanity_EN).split(","));
         this.asteriskMarks = [];
         var _loc1_:int = 0;
         while(_loc1_ < 30)
         {
            _loc2_ = "";
            _loc3_ = 0;
            while(_loc3_ < _loc1_)
            {
               _loc2_ += "*";
               _loc3_++;
            }
            this.asteriskMarks[_loc1_] = _loc2_;
            _loc1_++;
         }
      }
      
      public static function get $() : ProfanityFilter
      {
         if(!instance)
         {
            instance = new ProfanityFilter();
         }
         return instance;
      }
      
      private function getTextFromBAClass(param1:Class) : String
      {
         var _loc2_:ByteArray = new param1();
         _loc2_.position = 0;
         return _loc2_.readUTFBytes(_loc2_.bytesAvailable);
      }
      
      public function filterString(param1:String) : String
      {
         var _loc3_:* = 0;
         param1 = param1 != null ? param1 : "";
         var _loc2_:String = param1;
         param1 = param1.toLowerCase();
         if(Boolean(this.pWords) && Boolean(this.asteriskMarks))
         {
            _loc3_ = int(this.pWords.length - 1);
            while(_loc3_ >= 0)
            {
               param1 = param1.replace(this.pWords[_loc3_],this.asteriskMarks[this.pWords[_loc3_].length]);
               _loc3_--;
            }
         }
         return param1.indexOf("*") != -1 ? param1 : _loc2_;
      }
   }
}

