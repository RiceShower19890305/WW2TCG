package feathers.utils.focus
{
   import feathers.core.IFocusDisplayObject;
   import feathers.layout.RelativePosition;
   import flash.geom.Rectangle;
   import starling.utils.Pool;
   
   public function isBetterFocusForRelativePosition(param1:IFocusDisplayObject, param2:IFocusDisplayObject, param3:Rectangle, param4:String) : Boolean
   {
      var _loc13_:Number = NaN;
      var _loc14_:Number = NaN;
      var _loc15_:Number = NaN;
      var _loc16_:Boolean = false;
      var _loc5_:Rectangle = param1.getBounds(param1.stage,Pool.getRectangle());
      var _loc6_:Number = Number(calculateMinPrimaryAxisDistanceForRelativePosition(param3,_loc5_,param4));
      if(_loc6_ == Number.POSITIVE_INFINITY)
      {
         return false;
      }
      var _loc7_:Number = Number(calculateMaxPrimaryAxisDistanceForRelativePosition(param3,_loc5_,param4));
      var _loc8_:Number = Number(calculateSecondaryAxisDistanceForRelativePosition(param3,_loc5_,param4));
      var _loc9_:Boolean = Boolean(itemsAreOnSameAxis(param3,_loc5_,param4));
      if(param2 === null)
      {
         _loc13_ = Number.POSITIVE_INFINITY;
         _loc14_ = Number.POSITIVE_INFINITY;
         _loc15_ = Number.POSITIVE_INFINITY;
         _loc16_ = false;
      }
      else
      {
         param2.getBounds(param2.stage,_loc5_);
         _loc13_ = Number(calculateMinPrimaryAxisDistanceForRelativePosition(param3,_loc5_,param4));
         _loc14_ = Number(calculateMaxPrimaryAxisDistanceForRelativePosition(param3,_loc5_,param4));
         _loc15_ = Number(calculateSecondaryAxisDistanceForRelativePosition(param3,_loc5_,param4));
         _loc16_ = Boolean(itemsAreOnSameAxis(param3,_loc5_,param4));
      }
      Pool.putRectangle(_loc5_);
      if(_loc9_ && _loc16_)
      {
         return _loc6_ > 0 && _loc6_ < _loc13_;
      }
      var _loc10_:Boolean = param4 === RelativePosition.TOP || param4 === RelativePosition.BOTTOM;
      if(_loc9_)
      {
         if(!_loc10_)
         {
            return true;
         }
         if(_loc6_ > 0 && _loc6_ < _loc14_)
         {
            return true;
         }
      }
      else if(_loc16_)
      {
         if(!_loc10_)
         {
            return false;
         }
         if(_loc13_ > 0 && _loc13_ < _loc7_)
         {
            return false;
         }
      }
      var _loc11_:Number = 13 * _loc6_ * _loc6_ + _loc8_ * _loc8_;
      var _loc12_:Number = 13 * _loc13_ * _loc13_ + _loc15_ * _loc15_;
      return _loc11_ < _loc12_;
   }
}

import feathers.layout.RelativePosition;
import flash.geom.Rectangle;

function calculateSecondaryAxisDistanceForRelativePosition(param1:Rectangle, param2:Rectangle, param3:String):Number
{
   if(param3 === RelativePosition.TOP || param3 === RelativePosition.BOTTOM)
   {
      return Math.abs(param1.x + param1.width / 2 - (param2.x + param2.width / 2));
   }
   return Math.abs(param1.y + param1.height / 2 - (param2.y + param2.height / 2));
}
function calculateMaxPrimaryAxisDistanceForRelativePosition(param1:Rectangle, param2:Rectangle, param3:String):Number
{
   var _loc4_:Number = NaN;
   switch(param3)
   {
      case RelativePosition.TOP:
         if(param1.bottom > param2.bottom || param1.y >= param2.bottom)
         {
            _loc4_ = param1.bottom - param2.y;
            if(_loc4_ > 0)
            {
               return _loc4_;
            }
         }
         break;
      case RelativePosition.RIGHT:
         if(param1.x < param2.x || param1.right <= param2.x)
         {
            _loc4_ = param2.right - param1.x;
            if(_loc4_ > 0)
            {
               return _loc4_;
            }
         }
         break;
      case RelativePosition.BOTTOM:
         if(param1.y < param2.y || param1.bottom <= param2.y)
         {
            _loc4_ = param2.bottom - param1.y;
            if(_loc4_ > 0)
            {
               return _loc4_;
            }
         }
         break;
      case RelativePosition.LEFT:
         if(param1.right > param2.right || param1.x >= param2.right)
         {
            _loc4_ = param1.right - param2.x;
            if(_loc4_ > 0)
            {
               return _loc4_;
            }
         }
   }
   return Number.POSITIVE_INFINITY;
}
function calculateMinPrimaryAxisDistanceForRelativePosition(param1:Rectangle, param2:Rectangle, param3:String):Number
{
   var _loc4_:Number = NaN;
   switch(param3)
   {
      case RelativePosition.TOP:
         if(param1.bottom > param2.bottom || param1.y >= param2.bottom)
         {
            _loc4_ = param1.bottom - param2.bottom;
            if(_loc4_ > 0)
            {
               return _loc4_;
            }
         }
         break;
      case RelativePosition.RIGHT:
         if(param1.x < param2.x || param1.right <= param2.x)
         {
            _loc4_ = param2.x - param1.x;
            if(_loc4_ > 0)
            {
               return _loc4_;
            }
         }
         break;
      case RelativePosition.BOTTOM:
         if(param1.y < param2.y || param1.bottom <= param2.y)
         {
            _loc4_ = param2.y - param1.y;
            if(_loc4_ > 0)
            {
               return _loc4_;
            }
         }
         break;
      case RelativePosition.LEFT:
         if(param1.right > param2.right || param1.x >= param2.right)
         {
            _loc4_ = param1.right - param2.right;
            if(_loc4_ > 0)
            {
               return _loc4_;
            }
         }
   }
   return Number.POSITIVE_INFINITY;
}
function itemsAreOnSameAxis(param1:Rectangle, param2:Rectangle, param3:String):Boolean
{
   if(param3 === RelativePosition.TOP || param3 === RelativePosition.BOTTOM)
   {
      return param1.x <= param2.right && param2.x <= param1.right;
   }
   return param1.y <= param2.bottom && param2.y <= param1.bottom;
}
