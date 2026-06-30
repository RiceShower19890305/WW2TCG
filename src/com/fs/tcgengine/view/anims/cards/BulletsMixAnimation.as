package com.fs.tcgengine.view.anims.cards
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.components.battle.FSBattlefieldUserPortrait;
   import com.greensock.TweenMax;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   
   public class BulletsMixAnimation extends BulletsAnim
   {
      
      private const SHOOT_SPEED:Number = 0.15;
      
      public function BulletsMixAnimation(param1:FSCard, param2:int = -1, param3:String = "", param4:String = "", param5:Number = 0.2, param6:Boolean = true)
      {
         super(param1,10,param3,param4,this.SHOOT_SPEED,param6);
      }
      
      override public function init() : void
      {
         super.init();
         Utils.playSound(Constants.SOUND_GUNSHOTS,SoundManager.TYPE_SFX);
      }
      
      override protected function playGunShotSound() : void
      {
      }
      
      override protected function playSpecialFXOnShoot(param1:DisplayObject) : void
      {
         if(mParticleSystem)
         {
            if(mAttachedToComponent != null && mAttachedToComponent.parent != null && mAttachedToComponent.parent is FSBattlefieldUserPortrait)
            {
               mParticleSystem.emitterX = FSBattlefieldUserPortrait(mAttachedToComponent.parent).x + mAttachedToComponent.x + param1.x + param1.width / 2;
               mParticleSystem.emitterY = FSBattlefieldUserPortrait(mAttachedToComponent.parent).y + mAttachedToComponent.y + param1.y + param1.height / 2;
            }
            else
            {
               mParticleSystem.emitterX = mAttachedToComponent.x + param1.x + param1.width / 2;
               mParticleSystem.emitterY = mAttachedToComponent.y + param1.y + param1.height / 2;
            }
            mParticleSystem.start(0.05);
         }
      }
      
      override protected function triggerParticleSystem() : void
      {
         if(mParticleSystem != null)
         {
            InstanceMng.getCurrentScreen().addChild(mParticleSystem);
            Starling.juggler.add(mParticleSystem);
         }
         TweenMax.delayedCall(CardAnimation.getMaxDuration() * 2,unload);
      }
      
      override protected function getBulletExplosionTextureName() : String
      {
         return "bullet_smoke_";
      }
      
      override protected function isBulletExplosionGunSmoke() : Boolean
      {
         return true;
      }
   }
}

