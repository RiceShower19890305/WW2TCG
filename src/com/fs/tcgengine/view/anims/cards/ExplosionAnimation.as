package com.fs.tcgengine.view.anims.cards
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.AbilitiesMng;
   import com.fs.tcgengine.model.board.card.Ability;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.battle.FSBattlefieldUserPortrait;
   import com.greensock.TweenMax;
   import com.greensock.easing.Quad;
   import starling.core.Starling;
   import starling.display.MovieClip;
   import starling.extensions.lighting.LightSource;
   import starling.textures.Texture;
   
   public class ExplosionAnimation extends CardAnimation
   {
      
      public static const EXTRA_IMAGE_NAME:String = "explosion_anim_tank";
      
      public static const SPRITESHEET_ANIM_NAME:String = "explosion_m_";
      
      private var mAnimKey:String;
      
      private var mAbility:Ability;
      
      protected var mExplosionLight:LightSource;
      
      protected var mSpritesheetAnim:MovieClip;
      
      public function ExplosionAnimation(param1:String, param2:Ability)
      {
         this.mAnimKey = param1;
         this.mAbility = param2;
         super();
      }
      
      override protected function triggerExtraGraphicsTweening() : void
      {
         var _loc1_:FSCoordinate = null;
         if(mAttachedToComponent != null && mExtraGraphics != null)
         {
            if(!contains(mExtraGraphics))
            {
               mExtraGraphics.alignPivot();
               _loc1_ = this.getSpawnPosition();
               mExtraGraphics.x = _loc1_.getX();
               mExtraGraphics.y = _loc1_.getY();
               mExtraGraphics.alpha = 0.001;
               InstanceMng.getCurrentScreen().addChild(mExtraGraphics);
               TweenMax.fromTo(mExtraGraphics,CardAnimation.getMaxDuration() / 2,{
                  "alpha":0,
                  "scaleX":0.5,
                  "scaleY":0.5
               },{
                  "alpha":1,
                  "scaleX":0.85,
                  "scaleY":0.85,
                  "onComplete":removeExtraGraphicsOnComponent
               });
               SpecialFX.tweenRotate(mExtraGraphics,CardAnimation.getMaxDuration(),0,Quad.easeOut,25);
            }
         }
         this.createSpriteSheet();
      }
      
      protected function getSpawnPosition() : FSCoordinate
      {
         var _loc1_:FSCoordinate = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(mAttachedToComponent != null && mAttachedToComponent.parent != null && mAttachedToComponent.parent is FSBattlefieldUserPortrait)
         {
            _loc2_ = FSBattlefieldUserPortrait(mAttachedToComponent.parent).x + mAttachedToComponent.x;
            _loc3_ = FSBattlefieldUserPortrait(mAttachedToComponent.parent).y + mAttachedToComponent.y;
            _loc1_ = new FSCoordinate(_loc2_ + mAttachedToComponent.width / 2,_loc3_ + mAttachedToComponent.height / 2);
         }
         else
         {
            _loc4_ = Utils.randomInt(-mAttachedToComponent.width / 2,mAttachedToComponent.width / 2);
            _loc5_ = Utils.randomInt(-mAttachedToComponent.height / 2,mAttachedToComponent.height / 2);
            _loc1_ = new FSCoordinate(mAttachedToComponent.x + _loc4_,mAttachedToComponent.y + _loc5_);
         }
         return _loc1_;
      }
      
      override protected function triggerParticleSystem() : void
      {
         var _loc3_:FSCoordinate = null;
         var _loc1_:Vector.<Texture> = Root.assets.getTextures(SPRITESHEET_ANIM_NAME);
         if(_loc1_ != null && _loc1_.length > 0)
         {
            return;
         }
         var _loc2_:Number = CardAnimation.getMaxDuration() * 3.5;
         if(mParticleSystem != null)
         {
            _loc3_ = this.getSpawnPosition();
            mParticleSystem.x = _loc3_.getX();
            mParticleSystem.y = _loc3_.getY();
            this.setParticleSystemProps();
            InstanceMng.getCurrentScreen().addChild(mParticleSystem);
            Starling.juggler.add(mParticleSystem);
            mParticleSystem.start(1);
         }
         TweenMax.delayedCall(_loc2_,unload);
      }
      
      private function setParticleSystemProps() : void
      {
         if(mParticleSystem == null)
         {
            return;
         }
         switch(this.mAnimKey)
         {
            case AbilitiesMng.EXPLOSION_ANIM:
               mParticleSystem.emitterXVariance = 10;
               mParticleSystem.emitterYVariance = 10;
               break;
            case AbilitiesMng.EXPLOSION_INFANTRY_ANIM:
               mParticleSystem.emitterXVariance = 10;
               mParticleSystem.emitterYVariance = 10;
               break;
            case AbilitiesMng.EXPLOSION_TANK_ANIM:
               mParticleSystem.emitterXVariance = 25;
               mParticleSystem.emitterYVariance = 25;
               break;
            case AbilitiesMng.EXPLOSION_AIR_ANIM:
               mParticleSystem.emitterXVariance = 37.5;
               mParticleSystem.emitterYVariance = 37.5;
               break;
            case AbilitiesMng.EXPLOSION_RUSSIAN_ANIM:
               mParticleSystem.emitterXVariance = 30;
               mParticleSystem.emitterYVariance = 30;
         }
      }
      
      override public function dispose() : void
      {
         this.mAbility = null;
         this.unloadMovieclip();
         super.dispose();
      }
      
      public function unloadMovieclip() : void
      {
         if(this.mSpritesheetAnim)
         {
            this.mSpritesheetAnim.removeFromParent();
            Starling.juggler.remove(this.mSpritesheetAnim);
            this.mSpritesheetAnim = null;
         }
      }
      
      protected function createSpriteSheet(param1:String = "", param2:int = 1, param3:int = 1, param4:String = "", param5:Boolean = true) : void
      {
         param1 = param1 == "" ? SPRITESHEET_ANIM_NAME : param1;
         param4 = param4 == "" ? this.mAbility.getAbilityDef().getSoundName() : param4;
         if(param4 == null || param4 == "")
         {
            param4 = Constants.SOUND_EXPLOSION_HIT;
         }
         var _loc6_:FSCoordinate = this.getSpawnPosition();
         this.mSpritesheetAnim = Utils.createExplosionEffect(param1,_loc6_.getX(),_loc6_.getY(),true,30,param2 * 1.25,param3 * 1.25,param5,0.5,param4);
      }
   }
}

