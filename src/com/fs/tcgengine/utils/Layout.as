package com.fs.tcgengine.utils
{
   import com.fs.tcgengine.InstanceMng;
   import starling.errors.AbstractClassError;
   
   public class Layout
   {
      
      public static const SQUARE:String = "/ios";
      
      public static const RECTANGULAR:String = "/android";
      
      public static const IPAD:int = 0;
      
      public static const IPHONE4:int = 1;
      
      public static const IPHONE5:int = 2;
      
      public function Layout()
      {
         super();
         throw new AbstractClassError();
      }
      
      public static function getType(param1:int = 0, param2:int = 0) : String
      {
         var _loc6_:String = null;
         var _loc3_:int = param1 != 0 ? param1 : InstanceMng.getApplication().getFullScreenWidth();
         var _loc4_:int = param2 != 0 ? param2 : InstanceMng.getApplication().getFullScreenHeight();
         var _loc5_:Number = _loc3_ / _loc4_;
         var _loc7_:Boolean = Utils.isIOS();
         var _loc8_:Boolean = Utils.isAndroid();
         var _loc9_:Boolean = Utils.isBrowser();
         if(!Utils.isDesktop() && !_loc9_ && (_loc5_ <= 1.42 && !_loc8_ || _loc7_))
         {
            _loc6_ = SQUARE;
         }
         else
         {
            _loc6_ = RECTANGULAR;
         }
         return _loc6_;
      }
      
      public static function getAppleDevice(param1:int = 0, param2:int = 0) : int
      {
         var _loc6_:int = 0;
         var _loc3_:int = param1 != 0 ? param1 : InstanceMng.getApplication().getFullScreenWidth();
         var _loc4_:int = param2 != 0 ? param2 : InstanceMng.getApplication().getFullScreenHeight();
         var _loc5_:Number = _loc3_ / _loc4_;
         if(_loc5_ <= 1.42)
         {
            _loc6_ = IPAD;
         }
         else if(_loc5_ > 1.42 && _loc5_ <= 1.6)
         {
            _loc6_ = IPHONE4;
         }
         else if(_loc5_ > 1.6)
         {
            _loc6_ = IPHONE5;
         }
         return _loc6_;
      }
      
      public static function getResourcesSuffix(param1:int = -1, param2:int = -1, param3:Boolean = false) : String
      {
         var _loc4_:Boolean = Utils.isIphone(param1,param2);
         var _loc5_:String = getType(param1,param2);
         if(_loc4_ && param3)
         {
            _loc5_ += Utils.isIphone4(param1,param2) ? "/iPhone4/" : "/iPhone5/";
         }
         else
         {
            _loc5_ += "/";
         }
         return _loc5_;
      }
      
      public static function getResourcesOnDemandPrefix(param1:int = -1, param2:int = -1) : String
      {
         var _loc3_:Boolean = Utils.isIphone(param1,param2);
         return Main.smScaleFactor + "x" + getType(param1,param2) + "/";
      }
      
      public static function getFontReducedFactor(param1:int = -1, param2:int = -1) : Number
      {
         var _loc3_:Number = 0;
         var _loc4_:int = param1 != -1 ? param1 : InstanceMng.getApplication().getFullScreenWidth();
         var _loc5_:int = param1 != -1 ? param1 : InstanceMng.getApplication().getFullScreenHeight();
         if(Utils.isIOS())
         {
            _loc3_ = 0.9;
         }
         else if(Utils.isAndroidOrDesktop() || isBrowserVersion())
         {
            _loc3_ = 0.5;
         }
         else
         {
            _loc3_ = 1.05;
         }
         return _loc3_;
      }
      
      private static function isBrowserVersion() : Boolean
      {
         return InstanceMng.getApplication() != null && InstanceMng.getApplication().isBrowserVersion();
      }
      
      public static function getFontMultiplier(param1:int = -1, param2:int = -1) : Number
      {
         var _loc3_:int = param1 != -1 ? param1 : InstanceMng.getApplication().getFullScreenWidth();
         var _loc4_:int = param1 != -1 ? param1 : InstanceMng.getApplication().getFullScreenHeight();
         return Utils.isIphone(_loc3_,_loc4_) ? 1.4 : 1.05;
      }
      
      public static function getFinalWidth(param1:int = -1) : Number
      {
         var _loc2_:Number = 1;
         if(Utils.isIOS())
         {
            _loc2_ = 0.41667;
         }
         else if(Utils.isAndroidOrDesktop() || Utils.isBrowser())
         {
            _loc2_ = 0.46875 / 2;
         }
         return param1 != -1 ? param1 * _loc2_ : _loc2_;
      }
   }
}

