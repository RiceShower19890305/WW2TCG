package com.fs.tcgengine.view.anims.cards
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.battle.FSBattlefieldUserPortrait;
   import com.greensock.TweenMax;
   import starling.core.Starling;
   
   public class APHighlightAnimation extends CardAnimation
   {
      
      public function APHighlightAnimation()
      {
         super();
      }
      
      override public function init() : void
      {
         super.init();
         Utils.playSound(Constants.SOUND_AP_TAKEN,SoundManager.TYPE_SFX);
      }
      
      override protected function triggerParticleSystem() : void
      {
         if(mParticleSystem != null)
         {
            mParticleSystem.x = FSBattlefieldUserPortrait(mAttachedToComponent.parent).x + mAttachedToComponent.x + mAttachedToComponent.width / 2;
            mParticleSystem.y = FSBattlefieldUserPortrait(mAttachedToComponent.parent).y + mAttachedToComponent.y + mAttachedToComponent.height / 2;
            InstanceMng.getCurrentScreen().addChild(mParticleSystem);
            Starling.juggler.add(mParticleSystem);
            mParticleSystem.start(0.15);
         }
         TweenMax.delayedCall(CardAnimation.getMaxDuration(),unload);
      }
   }
}

