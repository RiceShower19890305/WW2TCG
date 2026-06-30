package feathers.display
{
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import starling.display.DisplayObject;
   import starling.rendering.Painter;
   import starling.utils.MatrixUtil;
   import starling.utils.Pool;
   
   public class RenderDelegate extends DisplayObject
   {
      
      private static const HELPER_POINT:Point = new Point();
      
      protected var _target:DisplayObject;
      
      public function RenderDelegate(param1:DisplayObject)
      {
         super();
         this.target = param1;
      }
      
      public function get target() : DisplayObject
      {
         return this._target;
      }
      
      public function set target(param1:DisplayObject) : void
      {
         if(this._target === param1)
         {
            return;
         }
         this._target = param1;
         this.setRequiresRedraw();
      }
      
      override public function getBounds(param1:DisplayObject, param2:Rectangle = null) : Rectangle
      {
         param2 = this._target.getBounds(this._target,param2);
         var _loc3_:Matrix = Pool.getMatrix();
         this.getTransformationMatrix(param1,_loc3_);
         var _loc4_:Number = Number.MAX_VALUE;
         var _loc5_:Number = -Number.MAX_VALUE;
         var _loc6_:Number = Number.MAX_VALUE;
         var _loc7_:Number = -Number.MAX_VALUE;
         var _loc8_:int = 0;
         while(_loc8_ < 4)
         {
            MatrixUtil.transformCoords(_loc3_,_loc8_ % 2 == 0 ? 0 : param2.width,_loc8_ < 2 ? 0 : param2.height,HELPER_POINT);
            if(HELPER_POINT.x < _loc4_)
            {
               _loc4_ = HELPER_POINT.x;
            }
            if(HELPER_POINT.x > _loc5_)
            {
               _loc5_ = HELPER_POINT.x;
            }
            if(HELPER_POINT.y < _loc6_)
            {
               _loc6_ = HELPER_POINT.y;
            }
            if(HELPER_POINT.y > _loc7_)
            {
               _loc7_ = HELPER_POINT.y;
            }
            _loc8_++;
         }
         Pool.putMatrix(_loc3_);
         param2.setTo(_loc4_,_loc6_,_loc5_ - _loc4_,_loc7_ - _loc6_);
         return param2;
      }
      
      override public function render(param1:Painter) : void
      {
         var _loc2_:Boolean = param1.cacheEnabled;
         param1.cacheEnabled = false;
         this._target.render(param1);
         param1.cacheEnabled = _loc2_;
         param1.excludeFromCache(this);
      }
   }
}

