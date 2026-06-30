package com.fs.tcgengine.view.anims.cards
{
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.FSCardAnimsMng;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.components.battle.FSBattlefieldUserPortrait;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   import starling.events.Event;
   import starling.utils.deg2rad;
   
   public class ArrowDamageAnimation extends BulletsAnim
   {
      
      private var mImpactImage:FSImage;
      
      private var mShakeRequested:Boolean = false;
      
      public function ArrowDamageAnimation(param1:FSCard, param2:int = -1, param3:String = "", param4:String = "", param5:Number = 0.04, param6:Boolean = true)
      {
         param3 = param3 == "" ? FSCardAnimsMng.ARROW_SOUND_NAME : param3;
         param4 = param4 == "" ? FSCardAnimsMng.ARROW_DAMAGE_ANIM : param4;
         super(param1,param2,param3,param4,param5,param6);
      }
      
      override protected function getAmmoName() : String
      {
         return "arrow_nailed";
      }
      
      protected function getImpactImageName() : String
      {
         return "impact_effect";
      }
      
      override protected function scaleBulletImage(param1:FSImage) : void
      {
         param1.scaleX *= 0.8;
         param1.scaleY *= 0.8;
      }
      
      override protected function setupBulletOrientation(param1:FSImage, param2:Boolean, param3:Number, param4:Number, param5:Number, param6:Number) : void
      {
         var _loc7_:Boolean = false;
         var _loc8_:Number = NaN;
         if(param1)
         {
            param1.alignPivot();
            _loc7_ = mDamageDealerCard.getParentUserBattleInfo().isOwnerBattleInfo();
            if(!_loc7_)
            {
               param1.scaleY = -1;
            }
            if(param2)
            {
               _loc8_ = Utils.getAngle(param3,param4,param5,param6);
               _loc8_ = _loc8_ - (_loc7_ ? 90 : 270);
               param1.rotation = deg2rad(_loc8_);
            }
         }
      }
      
      override protected function triggerExtraGraphicsTweening() : void
      {
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this.performArrowHolesTweening();
      }
      
      private function getCoordinatesForImpact(param1:int) : FSCoordinate
      {
         var _loc2_:FSImage = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(mBulletImagesCatalog != null)
         {
            _loc5_ = Number(mAttachedToComponent.width);
            _loc6_ = Number(mAttachedToComponent.height);
            _loc2_ = mBulletsVector[param1];
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
            if(mAttachedToComponent != null && mAttachedToComponent.parent != null && mAttachedToComponent.parent is FSBattlefieldUserPortrait)
            {
               _loc3_ = Utils.randomNumber(mAttachedToComponent.x + _loc5_ * 0.15,mAttachedToComponent.x + _loc5_ * 0.85 - _loc2_.width);
               _loc4_ = Utils.randomNumber(mAttachedToComponent.y + _loc6_ * 0.15,mAttachedToComponent.y + _loc6_ * 0.85 - _loc2_.height);
            }
            else
            {
               _loc3_ = Utils.randomNumber(_loc5_ * 0.15,_loc5_ * 0.85 - _loc2_.width);
               _loc4_ = Utils.randomNumber(_loc6_ * 0.15,_loc6_ * 0.85 - _loc2_.height);
            }
         }
         return new FSCoordinate(_loc3_,_loc4_);
      }
      
      protected function performArrowHolesTweening() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:int = 0;
         var _loc3_:FSImage = null;
         var _loc4_:FSCoordinate = null;
         if(mBulletImagesCatalog != null)
         {
            _loc2_ = 0;
            while(_loc2_ < mBulletImagesCatalog.length)
            {
               _loc3_ = mBulletImagesCatalog[_loc2_];
               _loc3_.visible = false;
               _loc4_ = this.getCoordinatesForImpact(_loc2_);
               _loc3_.x = _loc4_.getX();
               _loc3_.y = _loc4_.getY();
               _loc1_ = _loc2_ * mSpeedFactor;
               this.performImpactTweenning(_loc4_);
               TweenMax.delayedCall(_loc1_,addBulletHoleImageToDisplayList,[_loc3_]);
               TweenMax.delayedCall(_loc1_,playGunShotSound);
               TweenMax.delayedCall(_loc1_,playSpecialFXOnShoot,[_loc3_]);
               _loc2_++;
            }
         }
      }
      
      private function performImpactTweenning(param1:FSCoordinate) : void
      {
         this.createImpactImage(param1);
         SpecialFX.createYoYoZoomTransition(this.mImpactImage,2,0.5,1,this.onCompleteTransition);
      }
      
      private function onCompleteTransition() : void
      {
         var _loc1_:int = 0;
         if(this.mImpactImage)
         {
            this.mImpactImage.removeFromParent();
            this.mImpactImage.destroy();
            this.mImpactImage = null;
         }
         if(mBulletImagesCatalog)
         {
            _loc1_ = 0;
            while(_loc1_ < mBulletImagesCatalog.length)
            {
               if(mBulletImagesCatalog[_loc1_])
               {
                  mBulletImagesCatalog[_loc1_].visible = true;
               }
               _loc1_++;
            }
         }
         this.requestArrowShake(0.5);
         this.shakeNailedArrow();
      }
      
      private function createImpactImage(param1:FSCoordinate) : void
      {
         if(this.mImpactImage == null)
         {
            this.mImpactImage = new FSImage(Root.assets.getTexture(this.getImpactImageName()),false);
            this.mImpactImage.alignPivot();
            this.mImpactImage.x = param1.getX();
            this.mImpactImage.y = param1.getY();
            addChild(this.mImpactImage);
         }
      }
      
      public function onEnterFrame(param1:Event) : void
      {
         if(this.mShakeRequested)
         {
            this.shakeNailedArrow();
         }
      }
      
      public function shakeNailedArrow(param1:Number = 1) : void
      {
         var _loc4_:int = 0;
         var _loc5_:FSImage = null;
         var _loc2_:Number = Utils.randomNumber(-param1,param1);
         var _loc3_:Number = Utils.randomNumber(-param1,param1);
         if(mBulletImagesCatalog)
         {
            _loc4_ = 0;
            while(_loc4_ < mBulletImagesCatalog.length)
            {
               _loc5_ = mBulletImagesCatalog[_loc4_];
               if(_loc5_)
               {
                  if(_loc5_.x + _loc2_ > _loc5_.x - 1 && _loc5_.x + _loc2_ < _loc5_.x + 1)
                  {
                     _loc5_.x += _loc2_;
                  }
                  if(_loc5_.y + _loc3_ > -1 && _loc5_.y + _loc3_ < 1)
                  {
                     _loc5_.y += _loc3_;
                  }
               }
               _loc4_++;
            }
         }
      }
      
      public function requestArrowShake(param1:Number = 1) : void
      {
         this.mShakeRequested = true;
         TweenMax.killDelayedCallsTo(this.requestArrowShake);
         TweenMax.delayedCall(param1,this.stopShake);
      }
      
      private function stopShake() : void
      {
         var _loc1_:int = 0;
         var _loc2_:FSImage = null;
         this.mShakeRequested = false;
         if(mBulletsVector)
         {
            _loc1_ = 0;
            while(_loc1_ < mBulletsVector.length)
            {
               _loc2_ = mBulletsVector[_loc1_];
               if(_loc2_)
               {
                  _loc2_.x = 0;
                  _loc2_.y = 0;
               }
               _loc1_++;
            }
         }
      }
      
      override public function unload(param1:Boolean = false) : void
      {
         if(mParticleSystem != null)
         {
            if(mAttachedToComponent != null)
            {
               SpecialFX.tweenToAlpha(mParticleSystem,0.001,CardAnimation.getMaxDuration(),0,removeParticleSystemFromDL);
            }
         }
         if(mAttachedToComponent != null && mAttachedToComponent.parent != null && mAttachedToComponent.parent is FSBattlefieldUserPortrait || mAttachedToComponent != null && mAttachedToComponent.name == "SHIELD" || param1)
         {
            TweenMax.delayedCall(1,removeExtraGraphicsOnComponent);
         }
      }
      
      override protected function createBulletsVector() : void
      {
         var _loc1_:int = 0;
         var _loc2_:FSImage = null;
         var _loc3_:FSImage = null;
         if(mBulletsVector == null && mDamageDealerCard != null)
         {
            mBulletsVector = new Vector.<FSImage>();
            mBulletsHighlight = new Vector.<FSImage>();
            _loc1_ = 0;
            _loc1_ = 0;
            while(_loc1_ < mBulletsAmount)
            {
               _loc2_ = new FSImage(Root.assets.getTexture(this.getAmmoName()),false);
               mBulletsVector.push(_loc2_);
               _loc3_ = new FSImage(Root.assets.getTexture("impact_effect"),false);
               _loc3_.alignPivot();
               mBulletsHighlight.push(_loc3_);
               _loc1_++;
            }
         }
      }
      
      override public function dispose() : void
      {
         if(this.mImpactImage)
         {
            this.mImpactImage.removeFromParent();
            this.mImpactImage.destroy();
         }
         this.mImpactImage = null;
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         super.dispose();
      }
   }
}

