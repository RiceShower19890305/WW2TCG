package feathers.utils.display
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import starling.core.Starling;
   
   public function nativeToGlobal(param1:Point, param2:Starling = null, param3:Point = null) : Point
   {
      if(param2 === null)
      {
         param2 = Starling.current;
      }
      var _loc4_:Number = 1;
      if(param2.supportHighResolutions)
      {
         _loc4_ = param2.nativeStage.contentsScaleFactor;
      }
      var _loc5_:Number = param2.contentScaleFactor / _loc4_;
      var _loc6_:Rectangle = param2.viewPort;
      var _loc7_:Number = (param1.x - _loc6_.x) / _loc5_;
      var _loc8_:Number = (param1.y - _loc6_.y) / _loc5_;
      if(param3 === null)
      {
         param3 = new Point(_loc7_,_loc8_);
      }
      else
      {
         param3.setTo(_loc7_,_loc8_);
      }
      return param3;
   }
}

