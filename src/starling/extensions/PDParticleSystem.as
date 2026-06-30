package starling.extensions
{
   import flash.display3D.Context3DBlendFactor;
   import starling.textures.Texture;
   import starling.utils.deg2rad;
   
   public class PDParticleSystem extends ParticleSystem
   {
      
      public static const EMITTER_TYPE_GRAVITY:int = 0;
      
      public static const EMITTER_TYPE_RADIAL:int = 1;
      
      private var _emitterType:int;
      
      private var _emitterXVariance:Number;
      
      private var _emitterYVariance:Number;
      
      private var _defaultDuration:Number;
      
      private var _lifespan:Number;
      
      private var _lifespanVariance:Number;
      
      private var _startSize:Number;
      
      private var _startSizeVariance:Number;
      
      private var _endSize:Number;
      
      private var _endSizeVariance:Number;
      
      private var _emitAngle:Number;
      
      private var _emitAngleVariance:Number;
      
      private var _startRotation:Number;
      
      private var _startRotationVariance:Number;
      
      private var _endRotation:Number;
      
      private var _endRotationVariance:Number;
      
      private var _speed:Number;
      
      private var _speedVariance:Number;
      
      private var _gravityX:Number;
      
      private var _gravityY:Number;
      
      private var _radialAcceleration:Number;
      
      private var _radialAccelerationVariance:Number;
      
      private var _tangentialAcceleration:Number;
      
      private var _tangentialAccelerationVariance:Number;
      
      private var _maxRadius:Number;
      
      private var _maxRadiusVariance:Number;
      
      private var _minRadius:Number;
      
      private var _minRadiusVariance:Number;
      
      private var _rotatePerSecond:Number;
      
      private var _rotatePerSecondVariance:Number;
      
      private var _startColor:ColorArgb;
      
      private var _startColorVariance:ColorArgb;
      
      private var _endColor:ColorArgb;
      
      private var _endColorVariance:ColorArgb;
      
      public function PDParticleSystem(param1:XML, param2:Texture)
      {
         super(param2);
         this.parseConfig(param1);
      }
      
      override protected function createParticle() : Particle
      {
         return new PDParticle();
      }
      
      override protected function initParticle(param1:Particle) : void
      {
         var _loc2_:PDParticle = null;
         var _loc3_:Number = NaN;
         var _loc13_:ColorArgb = null;
         var _loc14_:ColorArgb = null;
         _loc2_ = param1 as PDParticle;
         _loc3_ = this._lifespan + this._lifespanVariance * (Math.random() * 2 - 1);
         var _loc4_:Number = texture ? texture.width : 16;
         _loc2_.currentTime = 0;
         _loc2_.totalTime = _loc3_ > 0 ? _loc3_ : 0;
         if(_loc3_ <= 0)
         {
            return;
         }
         var _loc5_:Number = this.emitterX;
         var _loc6_:Number = this.emitterY;
         _loc2_.x = _loc5_ + this._emitterXVariance * (Math.random() * 2 - 1);
         _loc2_.y = _loc6_ + this._emitterYVariance * (Math.random() * 2 - 1);
         _loc2_.startX = _loc5_;
         _loc2_.startY = _loc6_;
         var _loc7_:Number = this._emitAngle + this._emitAngleVariance * (Math.random() * 2 - 1);
         var _loc8_:Number = this._speed + this._speedVariance * (Math.random() * 2 - 1);
         _loc2_.velocityX = _loc8_ * Math.cos(_loc7_);
         _loc2_.velocityY = _loc8_ * Math.sin(_loc7_);
         var _loc9_:Number = this._maxRadius + this._maxRadiusVariance * (Math.random() * 2 - 1);
         var _loc10_:Number = this._minRadius + this._minRadiusVariance * (Math.random() * 2 - 1);
         _loc2_.emitRadius = _loc9_;
         _loc2_.emitRadiusDelta = (_loc10_ - _loc9_) / _loc3_;
         _loc2_.emitRotation = this._emitAngle + this._emitAngleVariance * (Math.random() * 2 - 1);
         _loc2_.emitRotationDelta = this._rotatePerSecond + this._rotatePerSecondVariance * (Math.random() * 2 - 1);
         _loc2_.radialAcceleration = this._radialAcceleration + this._radialAccelerationVariance * (Math.random() * 2 - 1);
         _loc2_.tangentialAcceleration = this._tangentialAcceleration + this._tangentialAccelerationVariance * (Math.random() * 2 - 1);
         var _loc11_:Number = this._startSize + this._startSizeVariance * (Math.random() * 2 - 1);
         var _loc12_:Number = this._endSize + this._endSizeVariance * (Math.random() * 2 - 1);
         if(_loc11_ < 0.1)
         {
            _loc11_ = 0.1;
         }
         if(_loc12_ < 0.1)
         {
            _loc12_ = 0.1;
         }
         _loc2_.scale = _loc11_ / _loc4_;
         _loc2_.scaleDelta = (_loc12_ - _loc11_) / _loc3_ / _loc4_;
         _loc13_ = _loc2_.colorArgb;
         _loc14_ = _loc2_.colorArgbDelta;
         _loc13_.red = this._startColor.red;
         _loc13_.green = this._startColor.green;
         _loc13_.blue = this._startColor.blue;
         _loc13_.alpha = this._startColor.alpha;
         if(this._startColorVariance.red != 0)
         {
            _loc13_.red += this._startColorVariance.red * (Math.random() * 2 - 1);
         }
         if(this._startColorVariance.green != 0)
         {
            _loc13_.green += this._startColorVariance.green * (Math.random() * 2 - 1);
         }
         if(this._startColorVariance.blue != 0)
         {
            _loc13_.blue += this._startColorVariance.blue * (Math.random() * 2 - 1);
         }
         if(this._startColorVariance.alpha != 0)
         {
            _loc13_.alpha += this._startColorVariance.alpha * (Math.random() * 2 - 1);
         }
         var _loc15_:Number = this._endColor.red;
         var _loc16_:Number = this._endColor.green;
         var _loc17_:Number = this._endColor.blue;
         var _loc18_:Number = this._endColor.alpha;
         if(this._endColorVariance.red != 0)
         {
            _loc15_ += this._endColorVariance.red * (Math.random() * 2 - 1);
         }
         if(this._endColorVariance.green != 0)
         {
            _loc16_ += this._endColorVariance.green * (Math.random() * 2 - 1);
         }
         if(this._endColorVariance.blue != 0)
         {
            _loc17_ += this._endColorVariance.blue * (Math.random() * 2 - 1);
         }
         if(this._endColorVariance.alpha != 0)
         {
            _loc18_ += this._endColorVariance.alpha * (Math.random() * 2 - 1);
         }
         _loc14_.red = (_loc15_ - _loc13_.red) / _loc3_;
         _loc14_.green = (_loc16_ - _loc13_.green) / _loc3_;
         _loc14_.blue = (_loc17_ - _loc13_.blue) / _loc3_;
         _loc14_.alpha = (_loc18_ - _loc13_.alpha) / _loc3_;
         var _loc19_:Number = this._startRotation + this._startRotationVariance * (Math.random() * 2 - 1);
         var _loc20_:Number = this._endRotation + this._endRotationVariance * (Math.random() * 2 - 1);
         _loc2_.rotation = _loc19_;
         _loc2_.rotationDelta = (_loc20_ - _loc19_) / _loc3_;
      }
      
      override protected function advanceParticle(param1:Particle, param2:Number) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc3_:PDParticle = param1 as PDParticle;
         var _loc4_:Number = _loc3_.totalTime - _loc3_.currentTime;
         param2 = _loc4_ > param2 ? param2 : _loc4_;
         _loc3_.currentTime += param2;
         if(this._emitterType == EMITTER_TYPE_RADIAL)
         {
            _loc3_.emitRotation += _loc3_.emitRotationDelta * param2;
            _loc3_.emitRadius += _loc3_.emitRadiusDelta * param2;
            _loc3_.x = emitterX - Math.cos(_loc3_.emitRotation) * _loc3_.emitRadius;
            _loc3_.y = emitterY - Math.sin(_loc3_.emitRotation) * _loc3_.emitRadius;
         }
         else
         {
            _loc5_ = _loc3_.x - _loc3_.startX;
            _loc6_ = _loc3_.y - _loc3_.startY;
            _loc7_ = Math.sqrt(_loc5_ * _loc5_ + _loc6_ * _loc6_);
            if(_loc7_ < 0.01)
            {
               _loc7_ = 0.01;
            }
            _loc8_ = _loc5_ / _loc7_;
            _loc9_ = _loc6_ / _loc7_;
            _loc10_ = _loc8_;
            _loc11_ = _loc9_;
            _loc8_ *= _loc3_.radialAcceleration;
            _loc9_ *= _loc3_.radialAcceleration;
            _loc12_ = _loc10_;
            _loc10_ = -_loc11_ * _loc3_.tangentialAcceleration;
            _loc11_ = _loc12_ * _loc3_.tangentialAcceleration;
            _loc3_.velocityX += param2 * (this._gravityX + _loc8_ + _loc10_);
            _loc3_.velocityY += param2 * (this._gravityY + _loc9_ + _loc11_);
            _loc3_.x += _loc3_.velocityX * param2;
            _loc3_.y += _loc3_.velocityY * param2;
         }
         _loc3_.scale += _loc3_.scaleDelta * param2;
         _loc3_.rotation += _loc3_.rotationDelta * param2;
         _loc3_.colorArgb.red += _loc3_.colorArgbDelta.red * param2;
         _loc3_.colorArgb.green += _loc3_.colorArgbDelta.green * param2;
         _loc3_.colorArgb.blue += _loc3_.colorArgbDelta.blue * param2;
         _loc3_.colorArgb.alpha += _loc3_.colorArgbDelta.alpha * param2;
         _loc3_.color = _loc3_.colorArgb.toRgb();
         _loc3_.alpha = _loc3_.colorArgb.alpha;
      }
      
      private function updateEmissionRate() : void
      {
         emissionRate = capacity / this._lifespan;
      }
      
      protected function parseConfig(param1:XML) : void
      {
         var config:XML = param1;
         var getIntValue:Function = function(param1:XMLList):int
         {
            return parseInt(param1.attribute("value"));
         };
         var getFloatValue:Function = function(param1:XMLList):Number
         {
            return parseFloat(param1.attribute("value"));
         };
         var getColor:Function = function(param1:XMLList):ColorArgb
         {
            var _loc2_:ColorArgb = new ColorArgb();
            _loc2_.red = parseFloat(param1.attribute("red"));
            _loc2_.green = parseFloat(param1.attribute("green"));
            _loc2_.blue = parseFloat(param1.attribute("blue"));
            _loc2_.alpha = parseFloat(param1.attribute("alpha"));
            return _loc2_;
         };
         var getBlendFunc:Function = function(param1:XMLList):String
         {
            var _loc2_:int = int(getIntValue(param1));
            switch(_loc2_)
            {
               case 0:
                  return Context3DBlendFactor.ZERO;
               case 1:
                  return Context3DBlendFactor.ONE;
               case 768:
                  return Context3DBlendFactor.SOURCE_COLOR;
               case 769:
                  return Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR;
               case 770:
                  return Context3DBlendFactor.SOURCE_ALPHA;
               case 771:
                  return Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
               case 772:
                  return Context3DBlendFactor.DESTINATION_ALPHA;
               case 773:
                  return Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA;
               case 774:
                  return Context3DBlendFactor.DESTINATION_COLOR;
               case 775:
                  return Context3DBlendFactor.ONE_MINUS_DESTINATION_COLOR;
               default:
                  throw new ArgumentError("unsupported blending function: " + _loc2_);
            }
         };
         this._emitterXVariance = parseFloat(config.sourcePositionVariance.attribute("x"));
         this._emitterYVariance = parseFloat(config.sourcePositionVariance.attribute("y"));
         this._gravityX = parseFloat(config.gravity.attribute("x"));
         this._gravityY = parseFloat(config.gravity.attribute("y"));
         this._emitterType = getIntValue(config.emitterType);
         this._lifespan = Math.max(0.01,getFloatValue(config.particleLifeSpan));
         this._lifespanVariance = getFloatValue(config.particleLifespanVariance);
         this._startSize = getFloatValue(config.startParticleSize);
         this._startSizeVariance = getFloatValue(config.startParticleSizeVariance);
         this._endSize = getFloatValue(config.finishParticleSize);
         this._endSizeVariance = getFloatValue(config.FinishParticleSizeVariance);
         this._emitAngle = deg2rad(getFloatValue(config.angle));
         this._emitAngleVariance = deg2rad(getFloatValue(config.angleVariance));
         this._startRotation = deg2rad(getFloatValue(config.rotationStart));
         this._startRotationVariance = deg2rad(getFloatValue(config.rotationStartVariance));
         this._endRotation = deg2rad(getFloatValue(config.rotationEnd));
         this._endRotationVariance = deg2rad(getFloatValue(config.rotationEndVariance));
         this._speed = getFloatValue(config.speed);
         this._speedVariance = getFloatValue(config.speedVariance);
         this._radialAcceleration = getFloatValue(config.radialAcceleration);
         this._radialAccelerationVariance = getFloatValue(config.radialAccelVariance);
         this._tangentialAcceleration = getFloatValue(config.tangentialAcceleration);
         this._tangentialAccelerationVariance = getFloatValue(config.tangentialAccelVariance);
         this._maxRadius = getFloatValue(config.maxRadius);
         this._maxRadiusVariance = getFloatValue(config.maxRadiusVariance);
         this._minRadius = getFloatValue(config.minRadius);
         this._minRadiusVariance = getFloatValue(config.minRadiusVariance);
         this._rotatePerSecond = deg2rad(getFloatValue(config.rotatePerSecond));
         this._rotatePerSecondVariance = deg2rad(getFloatValue(config.rotatePerSecondVariance));
         this._startColor = getColor(config.startColor);
         this._startColorVariance = getColor(config.startColorVariance);
         this._endColor = getColor(config.finishColor);
         this._endColorVariance = getColor(config.finishColorVariance);
         blendFactorSource = getBlendFunc(config.blendFuncSource);
         blendFactorDestination = getBlendFunc(config.blendFuncDestination);
         this.defaultDuration = getFloatValue(config.duration);
         this.capacity = getIntValue(config.maxParticles);
         if(isNaN(this._endSizeVariance))
         {
            this._endSizeVariance = getFloatValue(config.finishParticleSizeVariance);
         }
         if(isNaN(this._lifespan))
         {
            this._lifespan = Math.max(0.01,getFloatValue(config.particleLifespan));
         }
         if(isNaN(this._lifespanVariance))
         {
            this._lifespanVariance = getFloatValue(config.particleLifeSpanVariance);
         }
         if(isNaN(this._minRadiusVariance))
         {
            this._minRadiusVariance = 0;
         }
         this.updateEmissionRate();
      }
      
      public function get emitterType() : int
      {
         return this._emitterType;
      }
      
      public function set emitterType(param1:int) : void
      {
         this._emitterType = param1;
      }
      
      public function get emitterXVariance() : Number
      {
         return this._emitterXVariance;
      }
      
      public function set emitterXVariance(param1:Number) : void
      {
         this._emitterXVariance = param1;
      }
      
      public function get emitterYVariance() : Number
      {
         return this._emitterYVariance;
      }
      
      public function set emitterYVariance(param1:Number) : void
      {
         this._emitterYVariance = param1;
      }
      
      public function get defaultDuration() : Number
      {
         return this._defaultDuration;
      }
      
      public function set defaultDuration(param1:Number) : void
      {
         this._defaultDuration = param1 < 0 ? Number.MAX_VALUE : param1;
      }
      
      override public function set capacity(param1:int) : void
      {
         super.capacity = param1;
         this.updateEmissionRate();
      }
      
      public function get lifespan() : Number
      {
         return this._lifespan;
      }
      
      public function set lifespan(param1:Number) : void
      {
         this._lifespan = Math.max(0.01,param1);
         this.updateEmissionRate();
      }
      
      public function get lifespanVariance() : Number
      {
         return this._lifespanVariance;
      }
      
      public function set lifespanVariance(param1:Number) : void
      {
         this._lifespanVariance = param1;
      }
      
      public function get startSize() : Number
      {
         return this._startSize;
      }
      
      public function set startSize(param1:Number) : void
      {
         this._startSize = param1;
      }
      
      public function get startSizeVariance() : Number
      {
         return this._startSizeVariance;
      }
      
      public function set startSizeVariance(param1:Number) : void
      {
         this._startSizeVariance = param1;
      }
      
      public function get endSize() : Number
      {
         return this._endSize;
      }
      
      public function set endSize(param1:Number) : void
      {
         this._endSize = param1;
      }
      
      public function get endSizeVariance() : Number
      {
         return this._endSizeVariance;
      }
      
      public function set endSizeVariance(param1:Number) : void
      {
         this._endSizeVariance = param1;
      }
      
      public function get emitAngle() : Number
      {
         return this._emitAngle;
      }
      
      public function set emitAngle(param1:Number) : void
      {
         this._emitAngle = param1;
      }
      
      public function get emitAngleVariance() : Number
      {
         return this._emitAngleVariance;
      }
      
      public function set emitAngleVariance(param1:Number) : void
      {
         this._emitAngleVariance = param1;
      }
      
      public function get startRotation() : Number
      {
         return this._startRotation;
      }
      
      public function set startRotation(param1:Number) : void
      {
         this._startRotation = param1;
      }
      
      public function get startRotationVariance() : Number
      {
         return this._startRotationVariance;
      }
      
      public function set startRotationVariance(param1:Number) : void
      {
         this._startRotationVariance = param1;
      }
      
      public function get endRotation() : Number
      {
         return this._endRotation;
      }
      
      public function set endRotation(param1:Number) : void
      {
         this._endRotation = param1;
      }
      
      public function get endRotationVariance() : Number
      {
         return this._endRotationVariance;
      }
      
      public function set endRotationVariance(param1:Number) : void
      {
         this._endRotationVariance = param1;
      }
      
      public function get speed() : Number
      {
         return this._speed;
      }
      
      public function set speed(param1:Number) : void
      {
         this._speed = param1;
      }
      
      public function get speedVariance() : Number
      {
         return this._speedVariance;
      }
      
      public function set speedVariance(param1:Number) : void
      {
         this._speedVariance = param1;
      }
      
      public function get gravityX() : Number
      {
         return this._gravityX;
      }
      
      public function set gravityX(param1:Number) : void
      {
         this._gravityX = param1;
      }
      
      public function get gravityY() : Number
      {
         return this._gravityY;
      }
      
      public function set gravityY(param1:Number) : void
      {
         this._gravityY = param1;
      }
      
      public function get radialAcceleration() : Number
      {
         return this._radialAcceleration;
      }
      
      public function set radialAcceleration(param1:Number) : void
      {
         this._radialAcceleration = param1;
      }
      
      public function get radialAccelerationVariance() : Number
      {
         return this._radialAccelerationVariance;
      }
      
      public function set radialAccelerationVariance(param1:Number) : void
      {
         this._radialAccelerationVariance = param1;
      }
      
      public function get tangentialAcceleration() : Number
      {
         return this._tangentialAcceleration;
      }
      
      public function set tangentialAcceleration(param1:Number) : void
      {
         this._tangentialAcceleration = param1;
      }
      
      public function get tangentialAccelerationVariance() : Number
      {
         return this._tangentialAccelerationVariance;
      }
      
      public function set tangentialAccelerationVariance(param1:Number) : void
      {
         this._tangentialAccelerationVariance = param1;
      }
      
      public function get maxRadius() : Number
      {
         return this._maxRadius;
      }
      
      public function set maxRadius(param1:Number) : void
      {
         this._maxRadius = param1;
      }
      
      public function get maxRadiusVariance() : Number
      {
         return this._maxRadiusVariance;
      }
      
      public function set maxRadiusVariance(param1:Number) : void
      {
         this._maxRadiusVariance = param1;
      }
      
      public function get minRadius() : Number
      {
         return this._minRadius;
      }
      
      public function set minRadius(param1:Number) : void
      {
         this._minRadius = param1;
      }
      
      public function get minRadiusVariance() : Number
      {
         return this._minRadiusVariance;
      }
      
      public function set minRadiusVariance(param1:Number) : void
      {
         this._minRadiusVariance = param1;
      }
      
      public function get rotatePerSecond() : Number
      {
         return this._rotatePerSecond;
      }
      
      public function set rotatePerSecond(param1:Number) : void
      {
         this._rotatePerSecond = param1;
      }
      
      public function get rotatePerSecondVariance() : Number
      {
         return this._rotatePerSecondVariance;
      }
      
      public function set rotatePerSecondVariance(param1:Number) : void
      {
         this._rotatePerSecondVariance = param1;
      }
      
      public function get startColor() : ColorArgb
      {
         return this._startColor;
      }
      
      public function set startColor(param1:ColorArgb) : void
      {
         this._startColor = param1;
      }
      
      public function get startColorVariance() : ColorArgb
      {
         return this._startColorVariance;
      }
      
      public function set startColorVariance(param1:ColorArgb) : void
      {
         this._startColorVariance = param1;
      }
      
      public function get endColor() : ColorArgb
      {
         return this._endColor;
      }
      
      public function set endColor(param1:ColorArgb) : void
      {
         this._endColor = param1;
      }
      
      public function get endColorVariance() : ColorArgb
      {
         return this._endColorVariance;
      }
      
      public function set endColorVariance(param1:ColorArgb) : void
      {
         this._endColorVariance = param1;
      }
   }
}

