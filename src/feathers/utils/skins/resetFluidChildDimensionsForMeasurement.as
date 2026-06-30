package feathers.utils.skins
{
   import feathers.core.IMeasureDisplayObject;
   import starling.display.DisplayObject;
   
   public function resetFluidChildDimensionsForMeasurement(param1:DisplayObject, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number, param11:Number, param12:Number, param13:Number) : void
   {
      var _loc17_:Number = NaN;
      var _loc18_:Number = NaN;
      var _loc19_:Number = NaN;
      var _loc20_:Number = NaN;
      if(param1 === null)
      {
         return;
      }
      var _loc14_:Boolean = param2 !== param2;
      var _loc15_:Boolean = param3 !== param3;
      if(_loc14_)
      {
         param1.width = param8;
      }
      else
      {
         param1.width = param2;
      }
      if(_loc15_)
      {
         param1.height = param9;
      }
      else
      {
         param1.height = param3;
      }
      var _loc16_:IMeasureDisplayObject = param1 as IMeasureDisplayObject;
      if(_loc16_ !== null)
      {
         compilerWorkaround = _loc17_ = param4;
         if(_loc17_ !== _loc17_ || param10 > _loc17_)
         {
            _loc17_ = param10;
         }
         _loc16_.minWidth = _loc17_;
         compilerWorkaround = _loc18_ = param5;
         if(_loc18_ !== _loc18_ || param11 > _loc18_)
         {
            _loc18_ = param11;
         }
         _loc16_.minHeight = _loc18_;
         compilerWorkaround = _loc19_ = param6;
         if(_loc19_ !== _loc19_ || param12 < _loc19_)
         {
            _loc19_ = param12;
         }
         _loc16_.maxWidth = _loc19_;
         compilerWorkaround = _loc20_ = param7;
         if(_loc20_ !== _loc20_ || param13 < _loc20_)
         {
            _loc20_ = param13;
         }
         _loc16_.maxHeight = _loc20_;
      }
   }
}

var compilerWorkaround:Object;
