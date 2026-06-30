package feathers.utils.text
{
   public class TextInputNavigation
   {
      
      protected static const IS_WORD:RegExp = /\w/;
      
      protected static const IS_WHITESPACE:RegExp = /\s/;
      
      public function TextInputNavigation()
      {
         super();
      }
      
      public static function findPreviousWordStartIndex(param1:String, param2:int) : int
      {
         var _loc5_:Boolean = false;
         if(param2 <= 0)
         {
            return 0;
         }
         var _loc3_:Boolean = IS_WORD.test(param1.charAt(param2 - 1));
         var _loc4_:* = int(param2 - 2);
         while(_loc4_ >= 0)
         {
            _loc5_ = IS_WORD.test(param1.charAt(_loc4_));
            if(!_loc5_ && _loc3_)
            {
               return _loc4_ + 1;
            }
            _loc3_ = _loc5_;
            _loc4_--;
         }
         return 0;
      }
      
      public static function findCurrentWordStartIndex(param1:String, param2:int) : int
      {
         var _loc5_:Boolean = false;
         if(param2 <= 0)
         {
            return 0;
         }
         var _loc3_:Boolean = IS_WORD.test(param1.charAt(param2 + 1));
         var _loc4_:* = param2;
         while(_loc4_ >= 0)
         {
            _loc5_ = IS_WORD.test(param1.charAt(_loc4_));
            if(!_loc5_ && _loc4_ == param2)
            {
               return findPreviousWordStartIndex(param1,param2);
            }
            if(!_loc5_ && _loc3_)
            {
               return _loc4_ + 1;
            }
            _loc3_ = _loc5_;
            _loc4_--;
         }
         return 0;
      }
      
      public static function findCurrentWordEndIndex(param1:String, param2:int) : int
      {
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc3_:int = param1.length;
         if(param2 >= _loc3_ - 1)
         {
            return _loc3_;
         }
         var _loc4_:int = param2;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = IS_WORD.test(param1.charAt(_loc4_));
            if(!_loc5_ && _loc4_ == param2)
            {
               _loc6_ = findNextWordStartIndex(param1,param2);
               return findCurrentWordEndIndex(param1,_loc6_);
            }
            if(!_loc5_)
            {
               return _loc4_;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function findNextWordStartIndex(param1:String, param2:int) : int
      {
         var _loc6_:Boolean = false;
         var _loc3_:int = param1.length;
         if(param2 >= _loc3_ - 1)
         {
            return _loc3_;
         }
         var _loc4_:Boolean = !IS_WHITESPACE.test(param1.charAt(param2));
         var _loc5_:int = param2 + 1;
         while(_loc5_ < _loc3_)
         {
            _loc6_ = IS_WORD.test(param1.charAt(_loc5_));
            if((_loc6_) && !_loc4_)
            {
               return _loc5_;
            }
            _loc4_ = _loc6_;
            _loc5_++;
         }
         return _loc3_;
      }
   }
}

