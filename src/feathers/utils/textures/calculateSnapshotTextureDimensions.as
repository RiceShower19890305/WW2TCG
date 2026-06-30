package feathers.utils.textures
{
   import flash.geom.Point;
   import starling.utils.MathUtil;
   
   public function calculateSnapshotTextureDimensions(param1:Number, param2:Number, param3:Number, param4:Boolean, param5:Point = null) : Point
   {
      var _loc6_:Number = param1;
      var _loc7_:Number = param2;
      if(!param4)
      {
         if(_loc6_ > param3)
         {
            _loc6_ = int(_loc6_ / param3) * param3 + MathUtil.getNextPowerOfTwo(_loc6_ % param3);
         }
         else
         {
            _loc6_ = MathUtil.getNextPowerOfTwo(_loc6_);
         }
      }
      else if(_loc6_ > param3)
      {
         _loc6_ = int(_loc6_ / param3) * param3 + _loc6_ % param3;
      }
      if(!param4)
      {
         if(_loc7_ > param3)
         {
            _loc7_ = int(_loc7_ / param3) * param3 + MathUtil.getNextPowerOfTwo(_loc7_ % param3);
         }
         else
         {
            _loc7_ = MathUtil.getNextPowerOfTwo(_loc7_);
         }
      }
      else if(_loc7_ > param3)
      {
         _loc7_ = int(_loc7_ / param3) * param3 + _loc7_ % param3;
      }
      if(param5 === null)
      {
         param5 = new Point(_loc6_,_loc7_);
      }
      else
      {
         param5.setTo(_loc6_,_loc7_);
      }
      return param5;
   }
}

