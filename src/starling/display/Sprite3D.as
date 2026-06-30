package starling.display
{
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   import flash.geom.Point;
   import flash.geom.Vector3D;
   import starling.core.starling_internal;
   import starling.events.Event;
   import starling.rendering.Painter;
   import starling.utils.MathUtil;
   import starling.utils.MatrixUtil;
   import starling.utils.rad2deg;
   
   use namespace starling_internal;
   
   public class Sprite3D extends DisplayObjectContainer
   {
      
      private static const E:Number = 0.00001;
      
      private static var sHelperPoint:Vector3D = new Vector3D();
      
      private static var sHelperPointAlt:Vector3D = new Vector3D();
      
      private static var sHelperMatrix:Matrix3D = new Matrix3D();
      
      private var _rotationX:Number;
      
      private var _rotationY:Number;
      
      private var _scaleZ:Number;
      
      private var _pivotZ:Number;
      
      private var _z:Number;
      
      public function Sprite3D()
      {
         super();
         this._scaleZ = 1;
         this._rotationX = this._rotationY = this._pivotZ = this._z = 0;
         setIs3D(true);
         addEventListener(Event.ADDED,this.onAddedChild);
         addEventListener(Event.REMOVED,this.onRemovedChild);
      }
      
      override public function render(param1:Painter) : void
      {
         if(this.isFlat)
         {
            super.render(param1);
         }
         else
         {
            param1.finishMeshBatch();
            param1.pushState();
            param1.state.transformModelviewMatrix3D(transformationMatrix3D);
            super.render(param1);
            param1.finishMeshBatch();
            param1.excludeFromCache(this);
            param1.popState();
         }
      }
      
      override public function hitTest(param1:Point) : DisplayObject
      {
         if(this.isFlat)
         {
            return super.hitTest(param1);
         }
         if(!visible || !touchable)
         {
            return null;
         }
         sHelperMatrix.copyFrom(transformationMatrix3D);
         sHelperMatrix.invert();
         stage.getCameraPosition(this,sHelperPoint);
         MatrixUtil.transformCoords3D(sHelperMatrix,param1.x,param1.y,0,sHelperPointAlt);
         MathUtil.intersectLineWithXYPlane(sHelperPoint,sHelperPointAlt,param1);
         return super.hitTest(param1);
      }
      
      private function onAddedChild(param1:Event) : void
      {
         this.recursivelySetIs3D(param1.target as DisplayObject,true);
      }
      
      private function onRemovedChild(param1:Event) : void
      {
         this.recursivelySetIs3D(param1.target as DisplayObject,false);
      }
      
      private function recursivelySetIs3D(param1:DisplayObject, param2:Boolean) : void
      {
         var _loc3_:DisplayObjectContainer = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param1 is Sprite3D)
         {
            return;
         }
         if(param1 is DisplayObjectContainer)
         {
            _loc3_ = param1 as DisplayObjectContainer;
            _loc4_ = _loc3_.numChildren;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               this.recursivelySetIs3D(_loc3_.getChildAt(_loc5_),param2);
               _loc5_++;
            }
         }
         param1.setIs3D(param2);
      }
      
      override starling_internal function updateTransformationMatrices(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Matrix, param11:Matrix3D) : void
      {
         if(this.isFlat)
         {
            super.starling_internal::updateTransformationMatrices(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11);
         }
         else
         {
            this.updateTransformationMatrices3D(param1,param2,this._z,param3,param4,this._pivotZ,param5,param6,this._scaleZ,this._rotationX,this._rotationY,param9,param10,param11);
         }
      }
      
      starling_internal function updateTransformationMatrices3D(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number, param11:Number, param12:Number, param13:Matrix, param14:Matrix3D) : void
      {
         param13.identity();
         param14.identity();
         if(param7 != 1 || param8 != 1 || param9 != 1)
         {
            param14.appendScale(param7 || E,param8 || E,param9 || E);
         }
         if(param10 != 0)
         {
            param14.appendRotation(rad2deg(param10),Vector3D.X_AXIS);
         }
         if(param11 != 0)
         {
            param14.appendRotation(rad2deg(param11),Vector3D.Y_AXIS);
         }
         if(param12 != 0)
         {
            param14.appendRotation(rad2deg(param12),Vector3D.Z_AXIS);
         }
         if(param1 != 0 || param2 != 0 || param3 != 0)
         {
            param14.appendTranslation(param1,param2,param3);
         }
         if(param4 != 0 || param5 != 0 || param6 != 0)
         {
            param14.prependTranslation(-param4,-param5,-param6);
         }
      }
      
      override public function set transformationMatrix(param1:Matrix) : void
      {
         super.transformationMatrix = param1;
         this._rotationX = this._rotationY = this._pivotZ = this._z = 0;
         setTransformationChanged();
      }
      
      public function get z() : Number
      {
         return this._z;
      }
      
      public function set z(param1:Number) : void
      {
         this._z = param1;
         setTransformationChanged();
      }
      
      public function get pivotZ() : Number
      {
         return this._pivotZ;
      }
      
      public function set pivotZ(param1:Number) : void
      {
         this._pivotZ = param1;
         setTransformationChanged();
      }
      
      public function get scaleZ() : Number
      {
         return this._scaleZ;
      }
      
      public function set scaleZ(param1:Number) : void
      {
         this._scaleZ = param1;
         setTransformationChanged();
      }
      
      override public function set scale(param1:Number) : void
      {
         scaleX = scaleY = this.scaleZ = param1;
      }
      
      override public function set skewX(param1:Number) : void
      {
         throw new Error("3D objects do not support skewing");
      }
      
      override public function set skewY(param1:Number) : void
      {
         throw new Error("3D objects do not support skewing");
      }
      
      public function get rotationX() : Number
      {
         return this._rotationX;
      }
      
      public function set rotationX(param1:Number) : void
      {
         this._rotationX = MathUtil.normalizeAngle(param1);
         setTransformationChanged();
      }
      
      public function get rotationY() : Number
      {
         return this._rotationY;
      }
      
      public function set rotationY(param1:Number) : void
      {
         this._rotationY = MathUtil.normalizeAngle(param1);
         setTransformationChanged();
      }
      
      public function get rotationZ() : Number
      {
         return rotation;
      }
      
      public function set rotationZ(param1:Number) : void
      {
         rotation = param1;
      }
      
      public function get isFlat() : Boolean
      {
         return this._z > -E && this._z < E && this._rotationX > -E && this._rotationX < E && this._rotationY > -E && this._rotationY < E && this._pivotZ > -E && this._pivotZ < E;
      }
   }
}

