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
   import starling.events.Event;
   import starling.utils.deg2rad;
   import starling.utils.rad2deg;
   
   public class WaterAnimation extends CardAnimation
   {
      
      private var mRotateClockWise:Boolean = true;
      
      private var mMaxReached:Boolean = false;
      
      public function WaterAnimation()
      {
         super();
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      override protected function triggerParticleSystem() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(mParticleSystem != null)
         {
            _loc1_ = !FSCard(mAttachedToComponent).isEnemyCard();
            _loc2_ = 0;
            _loc3_ = 0;
            if(mAttachedToComponent.parent != null && mAttachedToComponent.parent is FSBattlefieldUserPortrait)
            {
               _loc2_ = FSBattlefieldUserPortrait(mAttachedToComponent.parent).x;
               _loc3_ = FSBattlefieldUserPortrait(mAttachedToComponent.parent).y;
            }
            _loc2_ += mAttachedToComponent.x;
            _loc3_ += _loc1_ ? mAttachedToComponent.y : mAttachedToComponent.y + mAttachedToComponent.height;
            if(_loc1_)
            {
               mParticleSystem.rotation = deg2rad(180);
            }
            mParticleSystem.x = _loc2_;
            mParticleSystem.y = _loc3_;
            InstanceMng.getCurrentScreen().addChild(mParticleSystem);
            Starling.juggler.add(mParticleSystem);
            mParticleSystem.start(CardAnimation.getMaxDuration());
            Utils.playSound(Constants.SOUND_FLAMETHROWER,SoundManager.TYPE_SFX);
         }
         TweenMax.delayedCall(CardAnimation.getMaxDuration() * 2,unload);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         if(mParticleSystem)
         {
            _loc2_ = rad2deg(mParticleSystem.emitAngle);
            if(this.mRotateClockWise)
            {
               mParticleSystem.emitAngle += Constants.ROTATION_VALUE;
            }
            else
            {
               mParticleSystem.emitAngle -= Constants.ROTATION_VALUE;
            }
            if(_loc2_ >= 300)
            {
               this.mMaxReached = true;
            }
            if(_loc2_ <= 250)
            {
               this.mMaxReached = false;
            }
            if(_loc2_ >= 300)
            {
               this.mRotateClockWise = this.mMaxReached ? false : true;
            }
         }
      }
      
      override public function dispose() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         super.dispose();
      }
   }
}

