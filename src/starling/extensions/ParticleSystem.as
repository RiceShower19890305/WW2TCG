package starling.extensions
{
   import flash.display3D.Context3DBlendFactor;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import starling.animation.IAnimatable;
   import starling.display.BlendMode;
   import starling.display.DisplayObject;
   import starling.display.Mesh;
   import starling.events.Event;
   import starling.rendering.IndexData;
   import starling.rendering.MeshEffect;
   import starling.rendering.Painter;
   import starling.rendering.VertexData;
   import starling.styles.MeshStyle;
   import starling.textures.Texture;
   import starling.utils.MatrixUtil;
   
   public class ParticleSystem extends Mesh implements IAnimatable
   {
      
      public static const MAX_NUM_PARTICLES:int = 16383;
      
      private static var sHelperMatrix:Matrix = new Matrix();
      
      private static var sHelperPoint:Point = new Point();
      
      private var _effect:MeshEffect;
      
      private var _vertexData:VertexData = new VertexData();
      
      private var _indexData:IndexData = new IndexData();
      
      private var _requiresSync:Boolean;
      
      private var _batchable:Boolean;
      
      private var _particles:Vector.<Particle>;
      
      private var _frameTime:Number;
      
      private var _numParticles:int;
      
      private var _emissionRate:Number;
      
      private var _emissionTime:Number;
      
      private var _emitterX:Number;
      
      private var _emitterY:Number;
      
      private var _blendFactorSource:String;
      
      private var _blendFactorDestination:String;
      
      public function ParticleSystem(param1:Texture = null)
      {
         super(this._vertexData,this._indexData);
         this._particles = new Vector.<Particle>(0,false);
         this._frameTime = 0;
         this._emitterX = this._emitterY = 0;
         this._emissionTime = 0;
         this._emissionRate = 10;
         this._blendFactorSource = Context3DBlendFactor.ONE;
         this._blendFactorDestination = Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
         this._batchable = false;
         this.capacity = 128;
         this.texture = param1;
         this.updateBlendMode();
      }
      
      override public function dispose() : void
      {
         this._effect.dispose();
         super.dispose();
      }
      
      override public function hitTest(param1:Point) : DisplayObject
      {
         return null;
      }
      
      private function updateBlendMode() : void
      {
         var _loc1_:Boolean = texture ? texture.premultipliedAlpha : true;
         if(this._blendFactorSource == Context3DBlendFactor.ONE && this._blendFactorDestination == Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA)
         {
            this._vertexData.premultipliedAlpha = _loc1_;
            if(!_loc1_)
            {
               this._blendFactorSource = Context3DBlendFactor.SOURCE_ALPHA;
            }
         }
         else
         {
            this._vertexData.premultipliedAlpha = false;
         }
         blendMode = this._blendFactorSource + ", " + this._blendFactorDestination;
         BlendMode.register(blendMode,this._blendFactorSource,this._blendFactorDestination);
      }
      
      protected function createParticle() : Particle
      {
         return new Particle();
      }
      
      protected function initParticle(param1:Particle) : void
      {
         param1.x = this._emitterX;
         param1.y = this._emitterY;
         param1.currentTime = 0;
         param1.totalTime = 1;
         param1.color = Math.random() * 16777215;
      }
      
      protected function advanceParticle(param1:Particle, param2:Number) : void
      {
         param1.y += param2 * 250;
         param1.alpha = 1 - param1.currentTime / param1.totalTime;
         param1.currentTime += param2;
      }
      
      private function setRequiresSync() : void
      {
         this._requiresSync = true;
      }
      
      private function syncBuffers() : void
      {
         this._effect.uploadVertexData(this._vertexData);
         this._effect.uploadIndexData(this._indexData);
         this._requiresSync = false;
      }
      
      public function start(param1:Number = 1.7976931348623157e+308) : void
      {
         if(this._emissionRate != 0)
         {
            this._emissionTime = param1;
         }
      }
      
      public function stop(param1:Boolean = false) : void
      {
         this._emissionTime = 0;
         if(param1)
         {
            this.clear();
         }
      }
      
      public function clear() : void
      {
         this._numParticles = 0;
      }
      
      override public function getBounds(param1:DisplayObject, param2:flash.geom.Rectangle = null) : flash.geom.Rectangle
      {
         if(param2 == null)
         {
            param2 = new flash.geom.Rectangle();
         }
         getTransformationMatrix(param1,sHelperMatrix);
         MatrixUtil.transformCoords(sHelperMatrix,0,0,sHelperPoint);
         param2.x = sHelperPoint.x;
         param2.y = sHelperPoint.y;
         param2.width = param2.height = 0;
         return param2;
      }
      
      public function advanceTime(param1:Number) : void
      {
         var _loc3_:Particle = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc14_:Particle = null;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         setRequiresRedraw();
         this.setRequiresSync();
         var _loc2_:int = 0;
         var _loc4_:int = this.capacity;
         while(_loc2_ < this._numParticles)
         {
            _loc3_ = this._particles[_loc2_] as Particle;
            if(_loc3_.currentTime < _loc3_.totalTime)
            {
               this.advanceParticle(_loc3_,param1);
               _loc2_++;
            }
            else
            {
               if(_loc2_ != this._numParticles - 1)
               {
                  _loc14_ = this._particles[int(this._numParticles - 1)] as Particle;
                  this._particles[int(this._numParticles - 1)] = _loc3_;
                  this._particles[_loc2_] = _loc14_;
               }
               --this._numParticles;
               if(this._numParticles == 0 && this._emissionTime == 0)
               {
                  dispatchEventWith(Event.COMPLETE);
               }
            }
         }
         if(this._emissionTime > 0)
         {
            _loc15_ = 1 / this._emissionRate;
            this._frameTime += param1;
            while(this._frameTime > 0)
            {
               if(this._numParticles < _loc4_)
               {
                  _loc3_ = this._particles[this._numParticles] as Particle;
                  this.initParticle(_loc3_);
                  if(_loc3_.totalTime > 0)
                  {
                     this.advanceParticle(_loc3_,this._frameTime);
                     ++this._numParticles;
                  }
               }
               this._frameTime -= _loc15_;
            }
            if(this._emissionTime != Number.MAX_VALUE)
            {
               this._emissionTime = this._emissionTime > param1 ? this._emissionTime - param1 : 0;
            }
            if(this._numParticles == 0 && this._emissionTime == 0)
            {
               dispatchEventWith(Event.COMPLETE);
            }
         }
         var _loc5_:int = 0;
         var _loc11_:Number = texture ? texture.width / 2 : 5;
         var _loc12_:Number = texture ? texture.height / 2 : 5;
         var _loc13_:int = 0;
         while(_loc13_ < this._numParticles)
         {
            _loc5_ = _loc13_ * 4;
            _loc3_ = this._particles[_loc13_] as Particle;
            _loc6_ = _loc3_.rotation;
            _loc9_ = _loc11_ * _loc3_.scale;
            _loc10_ = _loc12_ * _loc3_.scale;
            _loc7_ = _loc3_.x;
            _loc8_ = _loc3_.y;
            this._vertexData.colorize("color",_loc3_.color,_loc3_.alpha,_loc5_,4);
            if(_loc6_)
            {
               _loc16_ = Math.cos(_loc6_);
               _loc17_ = Math.sin(_loc6_);
               _loc18_ = _loc16_ * _loc9_;
               _loc19_ = _loc16_ * _loc10_;
               _loc20_ = _loc17_ * _loc9_;
               _loc21_ = _loc17_ * _loc10_;
               this._vertexData.setPoint(_loc5_,"position",_loc7_ - _loc18_ + _loc21_,_loc8_ - _loc20_ - _loc19_);
               this._vertexData.setPoint(_loc5_ + 1,"position",_loc7_ + _loc18_ + _loc21_,_loc8_ + _loc20_ - _loc19_);
               this._vertexData.setPoint(_loc5_ + 2,"position",_loc7_ - _loc18_ - _loc21_,_loc8_ - _loc20_ + _loc19_);
               this._vertexData.setPoint(_loc5_ + 3,"position",_loc7_ + _loc18_ - _loc21_,_loc8_ + _loc20_ + _loc19_);
            }
            else
            {
               this._vertexData.setPoint(_loc5_,"position",_loc7_ - _loc9_,_loc8_ - _loc10_);
               this._vertexData.setPoint(_loc5_ + 1,"position",_loc7_ + _loc9_,_loc8_ - _loc10_);
               this._vertexData.setPoint(_loc5_ + 2,"position",_loc7_ - _loc9_,_loc8_ + _loc10_);
               this._vertexData.setPoint(_loc5_ + 3,"position",_loc7_ + _loc9_,_loc8_ + _loc10_);
            }
            _loc13_++;
         }
      }
      
      override public function render(param1:Painter) : void
      {
         if(this._numParticles != 0)
         {
            if(this._batchable)
            {
               param1.batchMesh(this);
            }
            else
            {
               param1.finishMeshBatch();
               param1.drawCount += 1;
               param1.prepareToDraw();
               param1.excludeFromCache(this);
               if(this._requiresSync)
               {
                  this.syncBuffers();
               }
               style.updateEffect(this._effect,param1.state);
               this._effect.render(0,this._numParticles * 2);
            }
         }
      }
      
      public function populate(param1:int) : void
      {
         var _loc3_:Particle = null;
         var _loc2_:int = this.capacity;
         param1 = Math.min(param1,_loc2_ - this._numParticles);
         var _loc4_:int = 0;
         while(_loc4_ < param1)
         {
            _loc3_ = this._particles[this._numParticles + _loc4_];
            this.initParticle(_loc3_);
            this.advanceParticle(_loc3_,Math.random() * _loc3_.totalTime);
            _loc4_++;
         }
         this._numParticles += param1;
      }
      
      public function get capacity() : int
      {
         return this._vertexData.numVertices / 4;
      }
      
      public function set capacity(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc7_:int = 0;
         var _loc3_:int = this.capacity;
         var _loc4_:int = param1 > MAX_NUM_PARTICLES ? MAX_NUM_PARTICLES : param1;
         var _loc5_:VertexData = new VertexData(style.vertexFormat,4);
         var _loc6_:Texture = this.texture;
         if(_loc6_)
         {
            _loc6_.setupVertexPositions(_loc5_);
            _loc6_.setupTextureCoordinates(_loc5_);
         }
         else
         {
            _loc5_.setPoint(0,"position",0,0);
            _loc5_.setPoint(1,"position",10,0);
            _loc5_.setPoint(2,"position",0,10);
            _loc5_.setPoint(3,"position",10,10);
         }
         _loc2_ = _loc3_;
         while(_loc2_ < _loc4_)
         {
            _loc7_ = _loc2_ * 4;
            _loc5_.copyTo(this._vertexData,_loc7_);
            this._indexData.addQuad(_loc7_,_loc7_ + 1,_loc7_ + 2,_loc7_ + 3);
            this._particles[_loc2_] = this.createParticle();
            _loc2_++;
         }
         if(_loc4_ < _loc3_)
         {
            this._particles.length = _loc4_;
            this._indexData.numIndices = _loc4_ * 6;
            this._vertexData.numVertices = _loc4_ * 4;
         }
         this._indexData.trim();
         this._vertexData.trim();
         this.setRequiresSync();
      }
      
      public function get isEmitting() : Boolean
      {
         return this._emissionTime > 0 && this._emissionRate > 0;
      }
      
      public function get numParticles() : int
      {
         return this._numParticles;
      }
      
      public function get emissionRate() : Number
      {
         return this._emissionRate;
      }
      
      public function set emissionRate(param1:Number) : void
      {
         this._emissionRate = param1;
      }
      
      public function get emitterX() : Number
      {
         return this._emitterX;
      }
      
      public function set emitterX(param1:Number) : void
      {
         this._emitterX = param1;
      }
      
      public function get emitterY() : Number
      {
         return this._emitterY;
      }
      
      public function set emitterY(param1:Number) : void
      {
         this._emitterY = param1;
      }
      
      public function get blendFactorSource() : String
      {
         return this._blendFactorSource;
      }
      
      public function set blendFactorSource(param1:String) : void
      {
         this._blendFactorSource = param1;
         this.updateBlendMode();
      }
      
      public function get blendFactorDestination() : String
      {
         return this._blendFactorDestination;
      }
      
      public function set blendFactorDestination(param1:String) : void
      {
         this._blendFactorDestination = param1;
         this.updateBlendMode();
      }
      
      override public function set texture(param1:Texture) : void
      {
         var _loc2_:int = 0;
         super.texture = param1;
         if(param1)
         {
            _loc2_ = this._vertexData.numVertices - 4;
            while(_loc2_ >= 0)
            {
               param1.setupVertexPositions(this._vertexData,_loc2_);
               param1.setupTextureCoordinates(this._vertexData,_loc2_);
               _loc2_ -= 4;
            }
         }
         this.updateBlendMode();
      }
      
      override public function setStyle(param1:MeshStyle = null, param2:Boolean = true) : void
      {
         super.setStyle(param1,param2);
         if(this._effect)
         {
            this._effect.dispose();
         }
         this._effect = style.createEffect();
         this._effect.onRestore = this.setRequiresSync;
      }
      
      public function get batchable() : Boolean
      {
         return this._batchable;
      }
      
      public function set batchable(param1:Boolean) : void
      {
         this._batchable = param1;
         setRequiresRedraw();
      }
   }
}

