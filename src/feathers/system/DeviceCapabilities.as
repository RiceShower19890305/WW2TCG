package feathers.system
{
   import flash.display.Stage;
   import flash.system.Capabilities;
   import starling.core.Starling;
   
   public class DeviceCapabilities
   {
      
      public static var simulateDPad:Boolean = false;
      
      public static var tabletScreenPortraitWidthMinimumInches:Number = 3.5;
      
      public static var tabletScreenLandscapeWidthMinimumInches:Number = 5;
      
      public static var largePhoneScreenPortraitWidthMinimumInches:Number = 2.5;
      
      public static var largePhoneScreenLandscapeWidthMinimumInches:Number = 4.5;
      
      public static var screenPixelWidth:Number = NaN;
      
      public static var screenPixelHeight:Number = NaN;
      
      public static var dpi:int = Capabilities.screenDPI;
      
      public function DeviceCapabilities()
      {
         super();
      }
      
      public static function isTablet(param1:Stage = null) : Boolean
      {
         var _loc4_:Number = NaN;
         var _loc2_:Number = screenInchesX(param1);
         var _loc3_:Number = screenInchesY(param1);
         if(_loc2_ > _loc3_)
         {
            _loc4_ = _loc3_;
            _loc3_ = _loc2_;
            _loc2_ = _loc4_;
         }
         return _loc2_ >= tabletScreenPortraitWidthMinimumInches && _loc3_ >= tabletScreenLandscapeWidthMinimumInches;
      }
      
      public static function isLargePhone(param1:Stage = null) : Boolean
      {
         var _loc4_:Number = NaN;
         var _loc2_:Number = screenInchesX(param1);
         var _loc3_:Number = screenInchesY(param1);
         if(_loc2_ > _loc3_)
         {
            _loc4_ = _loc3_;
            _loc3_ = _loc2_;
            _loc2_ = _loc4_;
         }
         return _loc2_ >= largePhoneScreenPortraitWidthMinimumInches && _loc3_ >= largePhoneScreenLandscapeWidthMinimumInches && !isTablet(param1);
      }
      
      public static function isPhone(param1:Stage = null) : Boolean
      {
         return !isTablet(param1);
      }
      
      public static function screenInchesX(param1:Stage = null) : Number
      {
         if(param1 === null)
         {
            param1 = Starling.current.nativeStage;
         }
         var _loc2_:Number = screenPixelWidth;
         if(_loc2_ !== _loc2_)
         {
            _loc2_ = param1.fullScreenWidth;
         }
         return _loc2_ / dpi;
      }
      
      public static function screenInchesY(param1:Stage = null) : Number
      {
         if(param1 === null)
         {
            param1 = Starling.current.nativeStage;
         }
         var _loc2_:Number = screenPixelHeight;
         if(_loc2_ !== _loc2_)
         {
            _loc2_ = param1.fullScreenHeight;
         }
         return _loc2_ / dpi;
      }
   }
}

