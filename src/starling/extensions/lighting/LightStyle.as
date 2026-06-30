package starling.extensions.lighting
{
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   import flash.geom.Point;
   import flash.geom.Vector3D;
   import starling.core.Starling;
   import starling.display.Mesh;
   import starling.display.Stage;
   import starling.rendering.MeshEffect;
   import starling.rendering.RenderState;
   import starling.rendering.VertexData;
   import starling.rendering.VertexDataFormat;
   import starling.styles.MeshStyle;
   import starling.textures.Texture;
   import starling.utils.Color;
   import starling.utils.MatrixUtil;
   
   public class LightStyle extends MeshStyle
   {
      
      public static const VERTEX_FORMAT:VertexDataFormat = LightEffect.VERTEX_FORMAT;
      
      public static const MAX_SHININESS:int = 32;
      
      public static const MAX_NUM_LIGHTS:int = 8;
      
      private var _normalTexture:Texture;
      
      private var _material:Material;
      
      private var sPoint:Point = new Point();
      
      private var sPoint3D:Vector3D = new Vector3D();
      
      private var sMatrix:Matrix = new Matrix();
      
      private var sMatrix3D:Matrix3D = new Matrix3D();
      
      private var sMatrixAlt3D:Matrix3D = new Matrix3D();
      
      private var sMaterial:Material = new Material();
      
      private var sLights:Vector.<LightSource> = new Vector.<LightSource>(0);
      
      public function LightStyle(param1:Texture = null)
      {
         super();
         this._normalTexture = param1;
         this._material = new Material();
      }
      
      private function setNormalTexCoords(param1:int, param2:Number, param3:Number) : void
      {
         if(this._normalTexture)
         {
            this._normalTexture.setTexCoords(vertexData,param1,"normalTexCoords",param2,param3);
         }
         else
         {
            vertexData.setPoint(param1,"normalTexCoords",param2,param3);
         }
         setRequiresRedraw();
      }
      
      override public function setTexCoords(param1:int, param2:Number, param3:Number) : void
      {
         this.setNormalTexCoords(param1,param2,param3);
         super.setTexCoords(param1,param2,param3);
      }
      
      override public function copyFrom(param1:MeshStyle) : void
      {
         var _loc2_:LightStyle = param1 as LightStyle;
         if(_loc2_)
         {
            this._normalTexture = _loc2_._normalTexture;
            this._material.copyFrom(_loc2_._material);
         }
         super.copyFrom(param1);
      }
      
      override public function batchVertexData(param1:MeshStyle, param2:int = 0, param3:Matrix = null, param4:int = 0, param5:int = -1) : void
      {
         var _loc6_:LightStyle = null;
         var _loc7_:VertexData = null;
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         super.batchVertexData(param1,param2,param3,param4,param5);
         if(param3)
         {
            _loc6_ = param1 as LightStyle;
            _loc7_ = _loc6_.vertexData;
            this.sMatrix.setTo(param3.a,param3.b,param3.c,param3.d,0,0);
            vertexData.copyAttributeTo(_loc7_,param2,"xAxis",this.sMatrix,param4,param5);
            vertexData.copyAttributeTo(_loc7_,param2,"yAxis",this.sMatrix,param4,param5);
            if(param3.a * param3.d < 0)
            {
               if(param5 < 0)
               {
                  param5 = vertexData.numVertices - param4;
               }
               _loc8_ = 0;
               while(_loc8_ < param5)
               {
                  _loc9_ = vertexData.getFloat(param4 + _loc8_,"zScale");
                  _loc7_.setFloat(param2 + _loc8_,"zScale",_loc9_ * -1);
                  _loc8_++;
               }
            }
         }
      }
      
      override public function canBatchWith(param1:MeshStyle) : Boolean
      {
         var _loc3_:Texture = null;
         var _loc2_:LightStyle = param1 as LightStyle;
         if(Boolean(_loc2_) && Boolean(super.canBatchWith(param1)))
         {
            _loc3_ = _loc2_._normalTexture;
            if(this._normalTexture == null && _loc3_ == null)
            {
               return true;
            }
            if(Boolean(this._normalTexture) && Boolean(_loc3_))
            {
               return this._normalTexture.base == _loc3_.base;
            }
            return false;
         }
         return false;
      }
      
      override public function createEffect() : MeshEffect
      {
         return new LightEffect();
      }
      
      override public function updateEffect(param1:MeshEffect, param2:RenderState) : void
      {
         var _loc7_:LightSource = null;
         var _loc8_:uint = 0;
         var _loc9_:Vector3D = null;
         var _loc3_:LightEffect = param1 as LightEffect;
         _loc3_.normalTexture = this._normalTexture;
         var _loc4_:Stage = target.stage || Starling.current.stage;
         var _loc5_:Vector.<LightSource> = LightSource.getActiveInstances(_loc4_,this.sLights);
         _loc3_.numLights = _loc5_.length;
         if(param2.is3D)
         {
            this.sMatrixAlt3D.copyFrom(param2.modelviewMatrix3D);
         }
         else
         {
            MatrixUtil.convertTo3D(param2.modelviewMatrix,this.sMatrixAlt3D);
         }
         this.sMatrixAlt3D.invert();
         this.sPoint3D.copyFrom(_loc4_.cameraPosition);
         MatrixUtil.transformPoint3D(this.sMatrixAlt3D,this.sPoint3D,_loc3_.cameraPosition);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc7_ = _loc5_[_loc6_];
            _loc8_ = Color.multiply(_loc7_.color,_loc7_.brightness);
            _loc7_.getTransformationMatrix3D(null,this.sMatrix3D);
            this.sMatrix3D.append(this.sMatrixAlt3D);
            if(_loc7_.type == LightSource.TYPE_POINT)
            {
               _loc9_ = MatrixUtil.transformCoords3D(this.sMatrix3D,0,0,0,this.sPoint3D);
            }
            else
            {
               this.sPoint3D.setTo(0,0,0);
               this.sMatrix3D.copyColumnFrom(3,this.sPoint3D);
               _loc9_ = MatrixUtil.transformCoords3D(this.sMatrix3D,-1,0,0,this.sPoint3D);
            }
            _loc3_.setLightAt(_loc6_,_loc7_.type,_loc8_,_loc9_);
            _loc6_++;
         }
         super.updateEffect(param1,param2);
      }
      
      override public function get vertexFormat() : VertexDataFormat
      {
         return VERTEX_FORMAT;
      }
      
      override protected function onTargetAssigned(param1:Mesh) : void
      {
         var _loc2_:int = vertexData.numVertices;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            getTexCoords(_loc3_,this.sPoint);
            this.setNormalTexCoords(_loc3_,this.sPoint.x,this.sPoint.y);
            this.setVertexMaterial(_loc3_,this._material);
            vertexData.setPoint(_loc3_,"xAxis",1,0);
            vertexData.setPoint(_loc3_,"yAxis",0,1);
            vertexData.setFloat(_loc3_,"zScale",1);
            _loc3_++;
         }
      }
      
      public function get normalTexture() : Texture
      {
         return this._normalTexture;
      }
      
      public function set normalTexture(param1:Texture) : void
      {
         var _loc2_:int = 0;
         if(param1 != this._normalTexture)
         {
            if(target)
            {
               _loc2_ = 0;
               while(_loc2_ < vertexData.numVertices)
               {
                  getTexCoords(_loc2_,this.sPoint);
                  if(param1)
                  {
                     param1.setTexCoords(vertexData,_loc2_,"normalTexCoords",this.sPoint.x,this.sPoint.y);
                  }
                  _loc2_++;
               }
            }
            this._normalTexture = param1;
            setRequiresRedraw();
         }
      }
      
      private function setVertexMaterial(param1:int, param2:Material) : void
      {
         vertexData.setUnsignedInt(param1,"material",param2.encode());
         setRequiresRedraw();
      }
      
      private function getVertexMaterial(param1:int, param2:Material = null) : Material
      {
         if(param2 == null)
         {
            param2 = new Material();
         }
         param2.decode(vertexData.getUnsignedInt(param1,"material"));
         return param2;
      }
      
      public function getAmbientRatio(param1:int) : Number
      {
         return this.getVertexMaterial(param1).ambientRatio;
      }
      
      public function setAmbientRatio(param1:int, param2:Number) : void
      {
         this.getVertexMaterial(param1,this.sMaterial);
         if(this.sMaterial.ambientRatio != param2)
         {
            this.sMaterial.ambientRatio = param2;
            this.setVertexMaterial(param1,this.sMaterial);
         }
      }
      
      public function getDiffuseRatio(param1:int) : Number
      {
         return this.getVertexMaterial(param1).diffuseRatio;
      }
      
      public function setDiffuseRatio(param1:int, param2:Number) : void
      {
         this.getVertexMaterial(param1,this.sMaterial);
         if(this.sMaterial.diffuseRatio != param2)
         {
            this.sMaterial.diffuseRatio = param2;
            this.setVertexMaterial(param1,this.sMaterial);
         }
      }
      
      public function getSpecularRatio(param1:int) : Number
      {
         return this.getVertexMaterial(param1).specularRatio;
      }
      
      public function setSpecularRatio(param1:int, param2:Number) : void
      {
         this.getVertexMaterial(param1,this.sMaterial);
         if(this.sMaterial.specularRatio != param2)
         {
            this.sMaterial.specularRatio = param2;
            this.setVertexMaterial(param1,this.sMaterial);
         }
      }
      
      public function getShininess(param1:int) : Number
      {
         return this.getVertexMaterial(param1).shininess;
      }
      
      public function setShininess(param1:int, param2:Number) : void
      {
         this.getVertexMaterial(param1,this.sMaterial);
         if(this.sMaterial.shininess != param2)
         {
            this.sMaterial.shininess = param2;
            this.setVertexMaterial(param1,this.sMaterial);
         }
      }
      
      public function get ambientRatio() : Number
      {
         return this._material.ambientRatio;
      }
      
      public function set ambientRatio(param1:Number) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this._material.ambientRatio = param1;
         if(vertexData)
         {
            _loc2_ = 0;
            _loc3_ = vertexData.numVertices;
            while(_loc2_ < _loc3_)
            {
               this.setAmbientRatio(_loc2_,param1);
               _loc2_++;
            }
         }
      }
      
      public function get diffuseRatio() : Number
      {
         return this._material.diffuseRatio;
      }
      
      public function set diffuseRatio(param1:Number) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this._material.diffuseRatio = param1;
         if(vertexData)
         {
            _loc2_ = 0;
            _loc3_ = vertexData.numVertices;
            while(_loc2_ < _loc3_)
            {
               this.setDiffuseRatio(_loc2_,param1);
               _loc2_++;
            }
         }
      }
      
      public function get specularRatio() : Number
      {
         return this._material.specularRatio;
      }
      
      public function set specularRatio(param1:Number) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this._material.specularRatio = param1;
         if(vertexData)
         {
            _loc2_ = 0;
            _loc3_ = vertexData.numVertices;
            while(_loc2_ < _loc3_)
            {
               this.setSpecularRatio(_loc2_,param1);
               _loc2_++;
            }
         }
      }
      
      public function get shininess() : Number
      {
         return this._material.shininess;
      }
      
      public function set shininess(param1:Number) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this._material.shininess = param1;
         if(vertexData)
         {
            _loc2_ = 0;
            _loc3_ = vertexData.numVertices;
            while(_loc2_ < _loc3_)
            {
               this.setShininess(_loc2_,param1);
               _loc2_++;
            }
         }
      }
   }
}

import starling.utils.MathUtil;

class Material
{
   
   public var ambientRatio:Number;
   
   public var diffuseRatio:Number;
   
   public var specularRatio:Number;
   
   public var shininess:Number;
   
   public function Material(param1:Number = 0.5, param2:Number = 0.5, param3:Number = 0.1, param4:Number = 1)
   {
      super();
      this.ambientRatio = param1;
      this.diffuseRatio = param2;
      this.specularRatio = param3;
      this.shininess = param4;
   }
   
   public function copyFrom(param1:Material) : void
   {
      this.ambientRatio = param1.ambientRatio;
      this.diffuseRatio = param1.diffuseRatio;
      this.specularRatio = param1.specularRatio;
      this.shininess = param1.shininess;
   }
   
   public function decode(param1:uint) : void
   {
      this.ambientRatio = (param1 & 0xFF) / 255;
      this.diffuseRatio = (param1 >> 8 & 0xFF) / 255;
      this.specularRatio = (param1 >> 16 & 0xFF) / 255;
      this.shininess = (param1 >> 24 & 0xFF) / 255 * LightStyle.MAX_SHININESS;
   }
   
   public function encode() : uint
   {
      var _loc1_:Number = LightStyle.MAX_SHININESS;
      var _loc2_:uint = MathUtil.clamp(this.ambientRatio * 255,0,255);
      var _loc3_:uint = MathUtil.clamp(this.diffuseRatio * 255,0,255);
      var _loc4_:uint = MathUtil.clamp(this.specularRatio * 255,0,255);
      var _loc5_:uint = MathUtil.clamp(this.shininess / _loc1_ * 255,0,255);
      return _loc2_ | _loc3_ << 8 | _loc4_ << 16 | _loc5_ << 24;
   }
}
