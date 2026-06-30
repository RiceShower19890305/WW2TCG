package com.fs.tcgengine.view.anims.cards
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.FSCardAnimsMng;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.AssetsParticles;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.components.battle.FSBattlefieldUserPortrait;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.MovieClip;
   import starling.events.Event;
   import starling.extensions.ParticleSystem;
   import starling.extensions.lighting.LightSource;
   import starling.textures.Texture;
   import starling.utils.Align;
   import starling.utils.deg2rad;
   
   public class BulletsAnim extends CardAnimation
   {
      
      protected var mBulletImagesCatalog:Array;
      
      protected var mBulletExplosionAnimationsCatalog:Vector.<MovieClip>;
      
      protected var mBulletsAmount:int;
      
      protected var mBulletSoundName:String;
      
      protected var mBulletImageName:String;
      
      protected var mSpeedFactor:Number;
      
      protected var mBulletsVector:Vector.<FSImage>;
      
      protected var mBulletsLightsVector:Vector.<LightSource>;
      
      protected var m_BulletsEndPositions:Vector.<FSCoordinate>;
      
      protected var mBulletsHighlight:Vector.<FSImage>;
      
      protected var mDamageDealerCard:FSCard;
      
      protected var mBulletsParticles:Vector.<ParticleSystem>;
      
      protected var mShowMuzzleFlash:Boolean;
      
      private var mMCCount:int = 0;
      
      public function BulletsAnim(param1:FSCard, param2:int = -1, param3:String = "", param4:String = "", param5:Number = 0.04, param6:Boolean = true)
      {
         param2 = param2 == -1 ? FSCardAnimsMng.INFANTRY_BULLETS_AMOUNT : param2;
         param3 = param3 == "" ? FSCardAnimsMng.INFANTRY_GUN_FIRE_SOUND_NAME : param3;
         param4 = param4 == "" ? FSCardAnimsMng.STD_BULLET_IMAGE_NAME : param4;
         super();
         this.mDamageDealerCard = param1;
         this.mSpeedFactor = param5;
         this.mBulletsAmount = param2;
         this.mBulletSoundName = param3;
         this.mBulletImageName = param4;
         this.mShowMuzzleFlash = param6;
      }
      
      protected function createBulletsVector() : void
      {
         var _loc1_:UserData = null;
         var _loc2_:int = 0;
         var _loc3_:FSImage = null;
         var _loc4_:FSImage = null;
         var _loc5_:LightSource = null;
         var _loc6_:Number = NaN;
         var _loc7_:uint = 0;
         var _loc8_:String = null;
         if(this.mBulletsVector == null && this.mDamageDealerCard != null)
         {
            this.mBulletsVector = new Vector.<FSImage>();
            if(this.mShowMuzzleFlash)
            {
               this.mBulletsHighlight = new Vector.<FSImage>();
            }
            _loc1_ = Utils.getOwnerUserData();
            if(Boolean(_loc1_) && _loc1_.flagsGetShowLightFX())
            {
               this.mBulletsLightsVector = new Vector.<LightSource>();
            }
            _loc2_ = 0;
            _loc6_ = this.computeBulletBrightness();
            _loc7_ = this.computeBulletColor();
            _loc8_ = "muzzle_flash_";
            _loc2_ = 0;
            while(_loc2_ < this.mBulletsAmount)
            {
               _loc3_ = new FSImage(Root.assets.getTexture(this.getAmmoName()),false);
               this.mBulletsVector.push(_loc3_);
               if(this.mShowMuzzleFlash)
               {
                  _loc8_ = "muzzle_flash_" + Utils.randomInt(1,3);
                  _loc4_ = new FSImage(Root.assets.getTexture(_loc8_),false);
                  _loc4_.alignPivot();
                  this.mBulletsHighlight.push(_loc4_);
               }
               if(this.mBulletsLightsVector)
               {
                  _loc5_ = LightSource.createPointLight(_loc7_,_loc6_);
                  _loc5_.z = -50;
                  this.mBulletsLightsVector.push(_loc5_);
               }
               _loc2_++;
            }
         }
      }
      
      private function computeBulletBrightness() : Number
      {
         var _loc1_:Number = 0.75;
         if(this is InfantryBulletsAnim)
         {
            return 0.35;
         }
         if(this is AirplaneBulletsAnim)
         {
            return 0.25;
         }
         if(this is TankBulletAnim)
         {
            return 1;
         }
         return _loc1_;
      }
      
      private function computeBulletColor() : uint
      {
         var _loc1_:uint = 16112257;
         if(this is SubmarineBulletAnim || this is ShipBulletAnim)
         {
            return 3067130;
         }
         return _loc1_;
      }
      
      protected function getAmmoName() : String
      {
         return "std_ammo";
      }
      
      public function getAmmoSpeed() : Number
      {
         return 0.32 * Utils.getDefaultSpeedTime();
      }
      
      override public function setup(param1:*, param2:String = "", param3:FSImage = null) : void
      {
         this.createBulletImagesHolesVec();
         this.createBulletExplosions();
         this.createBulletsVector();
         super.setup(param1,param2,param3);
      }
      
      protected function createBulletImagesHolesVec() : void
      {
         var _loc1_:int = 0;
         var _loc2_:FSImage = null;
         if(this.mBulletImagesCatalog == null)
         {
            this.mBulletImagesCatalog = new Array();
         }
         var _loc3_:Texture = Root.assets.getTexture(this.mBulletImageName);
         _loc1_ = 0;
         while(_loc1_ < this.mBulletsAmount)
         {
            _loc2_ = new FSImage(_loc3_);
            this.mBulletImagesCatalog.push(_loc2_);
            _loc1_++;
         }
      }
      
      protected function createBulletExplosions() : void
      {
         var _loc1_:int = 0;
         var _loc3_:MovieClip = null;
         if(this.mBulletExplosionAnimationsCatalog == null)
         {
            this.mBulletExplosionAnimationsCatalog = new Vector.<MovieClip>();
         }
         var _loc2_:String = this.getBulletExplosionTextureName();
         if(_loc2_ != "")
         {
            _loc1_ = 0;
            while(_loc1_ < this.mBulletsAmount)
            {
               _loc3_ = this.createMovieclip(_loc2_);
               this.mBulletExplosionAnimationsCatalog.push(_loc3_);
               _loc1_++;
            }
         }
      }
      
      protected function getBulletExplosionTextureName() : String
      {
         return "";
      }
      
      private function createMovieclip(param1:String) : MovieClip
      {
         var _loc4_:int = 0;
         if(param1 == "")
         {
            return null;
         }
         var _loc2_:MovieClip = null;
         var _loc3_:Vector.<Texture> = Root.assets.getTextures(param1);
         if(Boolean(_loc3_) && _loc3_.length > 0)
         {
            _loc4_ = int(_loc3_.length);
            _loc2_ = new MovieClip(_loc3_,_loc4_);
            if(_loc2_)
            {
               _loc2_.scaleX *= Config.ANIM_SCALE;
               _loc2_.scaleY *= Config.ANIM_SCALE;
            }
            _loc2_.alignPivot();
            _loc2_.touchable = false;
         }
         return _loc2_;
      }
      
      override protected function triggerExtraGraphicsTweening() : void
      {
         super.triggerExtraGraphicsTweening();
         this.calculateBulletsDestinations();
         this.performBulletsAnims();
      }
      
      protected function performBulletsAnims() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:int = 0;
         var _loc3_:FSImage = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Boolean = false;
         var _loc7_:FSCoordinate = null;
         var _loc8_:Boolean = false;
         var _loc9_:String = null;
         var _loc10_:int = 0;
         if(this.mBulletsVector != null && mAttachedToComponent != null && this.mDamageDealerCard != null)
         {
            _loc6_ = false;
            _loc2_ = 0;
            while(_loc2_ < this.mBulletsVector.length)
            {
               _loc7_ = this.getBulletEndCoord(_loc2_);
               if(_loc7_ != null)
               {
                  _loc3_ = this.mBulletsVector[_loc2_];
                  _loc6_ = mAttachedToComponent != null && mAttachedToComponent.parent != null && mAttachedToComponent.parent is FSBattlefieldUserPortrait;
                  _loc4_ = this.mDamageDealerCard.x;
                  _loc5_ = this.mDamageDealerCard.y;
                  _loc8_ = this.mDamageDealerCard.getParentUserBattleInfo() ? this.mDamageDealerCard.getParentUserBattleInfo().isOwnerBattleInfo() : false;
                  _loc5_ = _loc8_ ? _loc5_ - this.mDamageDealerCard.height / 2 : _loc5_ + this.mDamageDealerCard.height / 2;
                  _loc3_.x = _loc4_;
                  _loc3_.y = _loc5_;
                  this.setupBulletOrientation(_loc3_,_loc6_,_loc4_,_loc5_,_loc7_.getX(),_loc7_.getY());
                  _loc1_ = _loc2_ * this.mSpeedFactor;
                  _loc9_ = !this is InfantryBulletsAnim ? "big_bullet_shot" : this.mBulletSoundName;
                  TweenMax.delayedCall(_loc1_,Utils.playSound,[_loc9_,SoundManager.TYPE_SFX]);
                  this.performBulletTransition(_loc3_,_loc7_,_loc1_ + 0.001,_loc2_);
                  if(this is InfantryBulletsAnim)
                  {
                     _loc10_ = Math.random() < 0.5 ? 1 : 2;
                     TweenMax.delayedCall(_loc1_ + 0.15,Utils.playSound,["bullet_drop_" + _loc10_,SoundManager.TYPE_SFX]);
                  }
               }
               _loc2_++;
            }
         }
      }
      
      protected function getBulletEndCoord(param1:int) : FSCoordinate
      {
         var _loc2_:Boolean = mAttachedToComponent != null && mAttachedToComponent.parent != null && mAttachedToComponent.parent is FSBattlefieldUserPortrait;
         return _loc2_ ? new FSCoordinate(this.m_BulletsEndPositions[param1].getX() + mAttachedToComponent.parent.x,this.m_BulletsEndPositions[param1].getY() + mAttachedToComponent.parent.y) : new FSCoordinate(this.m_BulletsEndPositions[param1].getX() + mAttachedToComponent.x - mAttachedToComponent.width / 2,this.m_BulletsEndPositions[param1].getY() + mAttachedToComponent.y - mAttachedToComponent.height / 2);
      }
      
      protected function performBulletTransition(param1:FSImage, param2:FSCoordinate, param3:Number, param4:int) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Boolean = false;
         var _loc7_:FSImage = null;
         var _loc8_:LightSource = null;
         var _loc9_:Number = NaN;
         if(!this.mDamageDealerCard.isDefeated())
         {
            _loc5_ = this.getAmmoSpeed();
            _loc6_ = this.mDamageDealerCard.getParentUserBattleInfo().isOwnerBattleInfo();
            _loc7_ = this.mBulletsHighlight ? this.mBulletsHighlight[param4] : null;
            if(_loc7_)
            {
               _loc9_ = _loc6_ ? this.mDamageDealerCard.y - this.mDamageDealerCard.height / 2 - _loc7_.height / 2.3 : this.mDamageDealerCard.y + this.mDamageDealerCard.height / 2 + _loc7_.height / 2.3;
               _loc7_.x = param1.x;
               _loc7_.y = _loc9_;
               _loc7_.scaleY = param1.scaleY;
               TweenMax.delayedCall(param3,this.addBulletImageToCurrentScreen,[_loc7_]);
               TweenMax.delayedCall(param3,SpecialFX.tweenToAlpha,[_loc7_,0.001,_loc5_ * 1.5,0]);
            }
            TweenMax.delayedCall(param3,this.addBulletImageToCurrentScreen,[param1]);
            SpecialFX.createTransition(param1,param2,_loc5_,param3,this.onBulletArrivedTarget,[param1,param4],Linear.easeNone);
            _loc8_ = this.mBulletsLightsVector ? this.mBulletsLightsVector[param4] : null;
            if(_loc8_)
            {
               _loc8_.x = param1.x;
               _loc8_.y = _loc9_;
               TweenMax.delayedCall(param3,this.addBulletImageToCurrentScreen,[null,_loc8_]);
               SpecialFX.createTransition(_loc8_,param2,_loc5_,param3,this.onLightArrivedTarget,[_loc8_],Linear.easeNone);
            }
         }
      }
      
      protected function setupBulletOrientation(param1:FSImage, param2:Boolean, param3:Number, param4:Number, param5:Number, param6:Number) : void
      {
         var _loc7_:Boolean = false;
         var _loc8_:Number = NaN;
         if(Boolean(param1) && Boolean(this.mDamageDealerCard) && Boolean(this.mDamageDealerCard.getParentUserBattleInfo()))
         {
            param1.alignPivot();
            _loc7_ = this.mDamageDealerCard.getParentUserBattleInfo().isOwnerBattleInfo();
            if(!_loc7_)
            {
               param1.scaleY = -1;
            }
            _loc8_ = Utils.getAngle(param3,param4,param5,param6);
            _loc8_ = _loc8_ - (_loc7_ ? 90 : 270);
            param1.rotation = deg2rad(_loc8_);
         }
      }
      
      protected function onBulletArrivedTarget(param1:FSImage, param2:int) : void
      {
         if(param1)
         {
            param1.removeFromParent();
         }
         this.performBulletHolesTweening(param2);
         this.performBulletExplosions(param2);
      }
      
      protected function onLightArrivedTarget(param1:LightSource) : void
      {
         if(param1)
         {
            param1.removeFromParent();
         }
      }
      
      private function performBulletExplosions(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:FSCoordinate = null;
         if(this.mBulletImagesCatalog != null)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mBulletImagesCatalog.length)
            {
               if(param1 == _loc2_)
               {
                  _loc3_ = this.m_BulletsEndPositions[_loc2_];
                  this.performBulletExplosionAnim(_loc2_,_loc3_);
               }
               _loc2_++;
            }
         }
      }
      
      protected function performBulletHolesTweening(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:FSImage = null;
         var _loc4_:FSCoordinate = null;
         var _loc5_:Number = NaN;
         if(this.mBulletImagesCatalog != null)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mBulletImagesCatalog.length)
            {
               if(_loc2_ == param1)
               {
                  _loc3_ = this.mBulletImagesCatalog[_loc2_];
                  _loc4_ = this.m_BulletsEndPositions[_loc2_];
                  _loc3_.x = _loc4_.getX() - _loc3_.width / 2;
                  _loc3_.y = _loc4_.getY() - _loc3_.height / 2;
                  _loc5_ = this.getAmmoSpeed();
                  this.addBulletHoleImageToDisplayList(_loc3_);
                  this.playExplosionSound(0);
                  this.playSpecialFXOnShoot(_loc3_);
               }
               _loc2_++;
            }
         }
      }
      
      protected function playExplosionSound(param1:Number, param2:String = "") : void
      {
         var _loc3_:int = 0;
         if(this is InfantryBulletsAnim)
         {
            _loc3_ = Utils.randomInt(1,4);
            TweenMax.delayedCall(param1,Utils.playSound,["bullet_hit_" + _loc3_,SoundManager.TYPE_SFX]);
         }
         else
         {
            param2 = param2 == "" ? Constants.SOUND_EXPLOSIONS : param2;
            TweenMax.delayedCall(param1,Utils.playSound,[param2,SoundManager.TYPE_SFX]);
         }
      }
      
      protected function performBulletExplosionAnim(param1:int, param2:FSCoordinate) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:FSCoordinate = null;
         if(this.mBulletExplosionAnimationsCatalog != null && this.mBulletExplosionAnimationsCatalog.length > param1)
         {
            _loc3_ = this.mBulletExplosionAnimationsCatalog[param1];
            if(_loc3_ != null)
            {
               _loc3_.loop = false;
               _loc4_ = this.getBulletEndCoord(param1);
               if(_loc4_)
               {
                  this.setBulletExplosionAnimationPivot(_loc3_);
                  this.setBulletExplosionAnimationFPS(_loc3_,_loc3_.fps);
                  _loc3_.x = _loc4_.getX();
                  _loc3_.y = _loc4_.getY();
                  this.playAnimation(_loc3_);
               }
            }
         }
      }
      
      protected function setBulletExplosionAnimationPivot(param1:MovieClip) : void
      {
         var _loc2_:Boolean = this.isBulletExplosionGunSmoke();
         if(param1 != null)
         {
            if(_loc2_)
            {
               param1.alignPivot(Align.CENTER,Align.BOTTOM);
               param1.scaleX = Utils.randomInt(0,1) == 0 ? 1 : -1;
            }
            else
            {
               param1.alignPivot();
            }
         }
      }
      
      protected function setBulletExplosionAnimationFPS(param1:MovieClip, param2:Number = -1) : void
      {
         var _loc3_:Boolean = this.isBulletExplosionGunSmoke();
         param2 = _loc3_ ? Utils.randomInt(param1.fps * 0.4,param1.fps * 0.66) : param2;
         if(param1 != null && param2 != -1)
         {
            param1.fps = param2;
         }
      }
      
      protected function isBulletExplosionGunSmoke() : Boolean
      {
         return false;
      }
      
      private function playAnimation(param1:MovieClip) : void
      {
         if(param1)
         {
            ++this.mMCCount;
            InstanceMng.getCurrentScreen().addChild(param1);
            param1.play();
            Starling.juggler.add(param1);
            param1.addEventListener(Event.COMPLETE,this.movieCompletedHandler);
            TweenMax.delayedCall(3,this.vanishMovieclip,[param1]);
         }
      }
      
      protected function movieCompletedHandler(param1:Event) : void
      {
         this.vanishMovieclip(param1.currentTarget as MovieClip);
      }
      
      private function vanishMovieclip(param1:MovieClip) : void
      {
         if(param1)
         {
            SpecialFX.tweenToAlpha(param1,0.001,0.5,0,this.unloadMovieclip,[param1]);
         }
         else
         {
            FSDebug.debugTrace("Could not vanish mc, not found");
         }
      }
      
      public function unloadMovieclip(param1:MovieClip) : void
      {
         --this.mMCCount;
         if(param1)
         {
            param1.removeFromParent();
            Starling.juggler.remove(param1);
            param1.removeEventListener(Event.COMPLETE,this.movieCompletedHandler);
            param1 = null;
         }
         else
         {
            FSDebug.debugTrace("Could not unload mc, not found");
         }
      }
      
      protected function calculateBulletsDestinations() : void
      {
         var _loc1_:int = 0;
         var _loc2_:FSImage = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(this.mBulletImagesCatalog != null)
         {
            _loc5_ = Number(mAttachedToComponent.width);
            _loc6_ = Number(mAttachedToComponent.height);
            _loc1_ = 0;
            while(_loc1_ < this.mBulletImagesCatalog.length)
            {
               _loc2_ = this.mBulletImagesCatalog[_loc1_];
               this.scaleBulletImage(_loc2_);
               if(mAttachedToComponent is FSCard && (Boolean(FSCard(mAttachedToComponent).getBG()) || Boolean(FSCard(mAttachedToComponent).getBGAnimated())))
               {
                  _loc5_ = FSCard(mAttachedToComponent).hasAnimatedBG() ? FSCard(mAttachedToComponent).getBGAnimated().width : FSCard(mAttachedToComponent).getBG().width;
                  _loc6_ = FSCard(mAttachedToComponent).hasAnimatedBG() ? FSCard(mAttachedToComponent).getBGAnimated().height : FSCard(mAttachedToComponent).getBG().height;
               }
               else
               {
                  _loc5_ = Number(mAttachedToComponent.width);
                  _loc6_ = Number(mAttachedToComponent.height);
               }
               _loc3_ = Utils.randomNumber(_loc5_ * 0.25,_loc5_ * 0.75);
               _loc4_ = Utils.randomNumber(_loc6_ * 0.25,_loc6_ * 0.75);
               if(this.m_BulletsEndPositions == null)
               {
                  this.m_BulletsEndPositions = new Vector.<FSCoordinate>();
               }
               this.m_BulletsEndPositions.push(new FSCoordinate(_loc3_,_loc4_));
               _loc1_++;
            }
         }
      }
      
      protected function playSpecialFXOnShoot(param1:DisplayObject) : void
      {
      }
      
      protected function scaleBulletImage(param1:FSImage) : void
      {
         param1.scaleX *= 0.5;
         param1.scaleY *= 0.5;
      }
      
      protected function playGunShotSound() : void
      {
         Utils.playSound(this.mBulletSoundName,SoundManager.TYPE_SFX);
      }
      
      protected function addBulletHoleImageToDisplayList(param1:FSImage, param2:Boolean = false) : void
      {
         if(param1 != null)
         {
            if(!contains(param1) && !param2)
            {
               addChild(param1);
            }
            this.showBulletParticles(param1.x + param1.width / 2,param1.y + param1.height / 2);
         }
      }
      
      protected function showBulletParticles(param1:Number, param2:Number, param3:String = "gunshot") : void
      {
         var _loc5_:ParticleSystem = null;
         var _loc4_:UserData = Utils.getOwnerUserData();
         if((Boolean(_loc4_)) && _loc4_.flagsGetShowLightFX())
         {
            _loc5_ = AssetsParticles.requestParticleSystem(param3);
            _loc5_.x = param1;
            _loc5_.y = param2;
            addChild(_loc5_);
            Starling.juggler.add(_loc5_);
            _loc5_.start(0.15);
            if(this.mBulletsParticles == null)
            {
               this.mBulletsParticles = new Vector.<ParticleSystem>();
            }
            this.mBulletsParticles.push(_loc5_);
         }
      }
      
      protected function addBulletImageToCurrentScreen(param1:FSImage = null, param2:LightSource = null) : void
      {
         if(InstanceMng.getCurrentScreen())
         {
            if(param1)
            {
               InstanceMng.getCurrentScreen().addChild(param1);
            }
            if(param2)
            {
               InstanceMng.getCurrentScreen().addChild(param2);
            }
         }
      }
      
      override protected function removeExtraGraphicsOnComponent() : void
      {
         var _loc1_:int = 0;
         var _loc2_:FSImage = null;
         var _loc3_:LightSource = null;
         super.removeExtraGraphicsOnComponent();
         if(this.mBulletImagesCatalog != null)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mBulletImagesCatalog.length)
            {
               _loc2_ = this.mBulletImagesCatalog[_loc1_];
               SpecialFX.tweenToAlpha(_loc2_,0.001,0.5,0,this.removeBulletImageFromDisplayList,[_loc2_]);
               _loc1_++;
            }
            Utils.destroyArray(this.mBulletImagesCatalog);
            this.mBulletImagesCatalog.length = 0;
            this.mBulletImagesCatalog = null;
         }
         if(this.mBulletsVector != null)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mBulletsVector.length)
            {
               _loc2_ = this.mBulletsVector[_loc1_];
               SpecialFX.tweenToAlpha(_loc2_,0.001,0.5,0,this.removeBulletImageFromDisplayList,[_loc2_]);
               _loc1_++;
            }
            Utils.destroyArray(this.mBulletsVector);
            this.mBulletsVector.length = 0;
            this.mBulletsVector = null;
         }
         if(this.mBulletsHighlight != null)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mBulletsHighlight.length)
            {
               _loc2_ = this.mBulletsHighlight[_loc1_];
               SpecialFX.tweenToAlpha(_loc2_,0.001,0.5,0,this.removeBulletImageFromDisplayList,[_loc2_]);
               _loc1_++;
            }
            Utils.destroyArray(this.mBulletsHighlight);
            this.mBulletsHighlight.length = 0;
            this.mBulletsHighlight = null;
         }
         if(this.mBulletsLightsVector)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mBulletsLightsVector.length)
            {
               _loc3_ = this.mBulletsLightsVector[_loc1_];
               _loc3_.removeFromParent();
               _loc1_++;
            }
            Utils.destroyArray(this.mBulletsLightsVector);
            this.mBulletsLightsVector.length = 0;
            this.mBulletsLightsVector = null;
         }
      }
      
      private function removeBulletImageFromDisplayList(param1:FSImage) : void
      {
         var _loc2_:int = 0;
         if(param1 != null)
         {
            param1.removeFromParent();
            param1.destroy();
            param1 = null;
         }
         if(this.mBulletsParticles)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mBulletsParticles.length)
            {
               this.mBulletsParticles[_loc2_].removeFromParent(true);
               Starling.juggler.remove(this.mBulletsParticles[_loc2_]);
               _loc2_++;
            }
         }
         Utils.destroyArray(this.mBulletsParticles);
         this.mBulletsParticles = null;
      }
      
      override public function dispose() : void
      {
         this.removeExtraGraphicsOnComponent();
         this.mDamageDealerCard = null;
         var _loc1_:int = 0;
         if(this.mBulletsParticles)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mBulletsParticles.length)
            {
               this.mBulletsParticles[_loc1_].removeFromParent(true);
               Starling.juggler.remove(this.mBulletsParticles[_loc1_]);
               _loc1_++;
            }
         }
         if(this.mBulletExplosionAnimationsCatalog != null)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mBulletExplosionAnimationsCatalog.length)
            {
               this.unloadMovieclip(this.mBulletExplosionAnimationsCatalog[_loc1_]);
               _loc1_++;
            }
            Utils.destroyArray(this.mBulletExplosionAnimationsCatalog);
            this.mBulletExplosionAnimationsCatalog = null;
         }
         Utils.destroyArray(this.mBulletsParticles);
         this.mBulletsParticles = null;
         Utils.destroyArray(this.m_BulletsEndPositions);
         this.m_BulletsEndPositions = null;
         super.dispose();
      }
   }
}

