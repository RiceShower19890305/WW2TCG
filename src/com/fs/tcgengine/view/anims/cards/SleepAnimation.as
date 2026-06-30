package com.fs.tcgengine.view.anims.cards
{
   import com.fs.tcgengine.controller.AbilitiesMng;
   import com.fs.tcgengine.view.cards.FSUnit;
   import starling.core.Starling;
   
   public class SleepAnimation extends CardAnimation
   {
      
      public function SleepAnimation()
      {
         super();
         setIsPermanent(true);
         setAbilityItBelongsTo(AbilitiesMng.SPECIAL_CAPTURED);
      }
      
      override protected function triggerParticleSystem() : void
      {
         if(mParticleSystem != null)
         {
            mParticleSystem.x = mAttachedToComponent.width / 2;
            mParticleSystem.y = mAttachedToComponent.height / 3;
            if(FSUnit(mAttachedToComponent).getAbsAnimsLayer() != null)
            {
               FSUnit(mAttachedToComponent).getAbsAnimsLayer().addChild(mParticleSystem);
            }
            Starling.juggler.add(mParticleSystem);
            mParticleSystem.start();
         }
      }
   }
}

