package com.fs.tcgengine.view.anims.cards
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.battle.FSBattlefieldUserPortrait;
   import com.greensock.TweenMax;
   import com.greensock.easing.Quad;
   import starling.core.Starling;
   
   public class WaterExplosionAnimation extends CardAnimation
   {
      
      public static const EXTRA_IMAGE_NAME:String = "explosion_water_anim";
      
      public function WaterExplosionAnimation()
      {
         super();
      }
      
      override public function init() : void
      {
         super.init();
         Utils.requestScreenShake(1,2);
      }
      
      override protected function triggerExtraGraphicsTweening() : void
      {
         if(mAttachedToComponent != null && mExtraGraphics != null)
         {
            if(!contains(mExtraGraphics))
            {
               mExtraGraphics.alignPivot();
               if(mAttachedToComponent != null && mAttachedToComponent.parent != null && mAttachedToComponent.parent is FSBattlefieldUserPortrait)
               {
                  mExtraGraphics.x = FSBattlefieldUserPortrait(mAttachedToComponent.parent).x + mAttachedToComponent.x + mAttachedToComponent.width / 2;
                  mExtraGraphics.y = FSBattlefieldUserPortrait(mAttachedToComponent.parent).y + mAttachedToComponent.y + mAttachedToComponent.height / 2;
               }
               else
               {
                  mExtraGraphics.x = mAttachedToComponent.x;
                  mExtraGraphics.y = mAttachedToComponent.y;
               }
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
      }
      
      override protected function triggerParticleSystem() : void
      {
         if(mParticleSystem != null)
         {
            mParticleSystem.x = mExtraGraphics.x;
            mParticleSystem.y = mExtraGraphics.y;
            InstanceMng.getCurrentScreen().addChild(mParticleSystem);
            Starling.juggler.add(mParticleSystem);
            InstanceMng.getCurrentScreen().addChild(mExtraGraphics);
            mParticleSystem.start(0.5);
         }
         TweenMax.delayedCall(CardAnimation.getMaxDuration() * 2,unload);
      }
   }
}

