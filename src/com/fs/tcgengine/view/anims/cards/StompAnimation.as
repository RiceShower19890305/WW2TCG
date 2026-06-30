package com.fs.tcgengine.view.anims.cards
{
   import com.fs.tcgengine.InstanceMng;
   import com.greensock.TweenMax;
   import starling.core.Starling;
   
   public class StompAnimation extends CardAnimation
   {
      
      public function StompAnimation()
      {
         super();
      }
      
      override protected function triggerParticleSystem() : void
      {
         if(mParticleSystem != null)
         {
            mParticleSystem.x = mAttachedToComponent.x;
            mParticleSystem.y = mAttachedToComponent.y;
            InstanceMng.getCurrentScreen().addChild(mParticleSystem);
            Starling.juggler.add(mParticleSystem);
            mParticleSystem.start(0.5);
         }
         TweenMax.delayedCall(CardAnimation.getMaxDuration() * 2,unload);
      }
   }
}

