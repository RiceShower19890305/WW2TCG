package com.fs.tcgengine.view.anims.cards
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.model.board.card.Ability;
   import com.fs.tcgengine.model.userdata.UserBattleInfo;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.components.battle.FSBattlefieldUserPortrait;
   import com.greensock.TweenMax;
   import flash.utils.setTimeout;
   import starling.core.Starling;
   import starling.events.Event;
   import starling.utils.rad2deg;
   
   public class FlamethrowerAnimation extends ExplosionAnimation
   {
      
      private var mRotateClockWise:Boolean = true;
      
      private var mMaxReached:Boolean = false;
      
      public function FlamethrowerAnimation(param1:String, param2:Ability)
      {
         super(param1,param2);
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      override protected function getSpawnPosition() : FSCoordinate
      {
         var _loc2_:FSCoordinate = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:Boolean = mAttachedToComponent is FSCard;
         if(!_loc1_)
         {
            _loc3_ = FSBattlefieldUserPortrait(mAttachedToComponent.parent).x + mAttachedToComponent.x;
            _loc4_ = FSBattlefieldUserPortrait(mAttachedToComponent.parent).y + mAttachedToComponent.y;
            _loc2_ = new FSCoordinate(_loc3_ + mAttachedToComponent.width / 2,_loc4_ + mAttachedToComponent.height / 2);
         }
         else
         {
            _loc2_ = new FSCoordinate(mAttachedToComponent.x,mAttachedToComponent.y);
         }
         return _loc2_;
      }
      
      override protected function createSpriteSheet(param1:String = "", param2:int = 1, param3:int = 1, param4:String = "", param5:Boolean = true) : void
      {
         var _loc6_:Boolean = false;
         var _loc7_:UserBattleInfo = null;
         var _loc8_:Boolean = false;
         var _loc9_:FSCard = null;
         var _loc10_:FSBattlefieldUserPortrait = null;
         if(mAttachedToComponent != null)
         {
            _loc6_ = mAttachedToComponent is FSCard;
            if(_loc6_)
            {
               _loc9_ = FSCard(mAttachedToComponent);
               _loc7_ = _loc9_ ? _loc9_.getParentUserBattleInfo() : null;
               _loc8_ = _loc7_ ? !_loc7_.isOwnerBattleInfo() : false;
            }
            else
            {
               _loc10_ = mAttachedToComponent.parent != null ? FSBattlefieldUserPortrait(mAttachedToComponent.parent) : null;
               _loc7_ = _loc10_ ? _loc10_.getUserBattleInfo() : null;
               _loc8_ = _loc7_ ? !_loc7_.isOwnerBattleInfo() : false;
            }
            param3 = _loc8_ ? 1 : -1;
            param4 = param4 == "" ? Constants.SOUND_FLAMETHROWER : param4;
            super.createSpriteSheet("flamethrower_anim",1,param3,param4,false);
         }
      }
      
      override protected function triggerParticleSystem() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(Config.getConfig().gameHasRealisticFlamethrower())
         {
            return;
         }
         if(mParticleSystem != null)
         {
            _loc1_ = mAttachedToComponent is FSCard && !FSCard(mAttachedToComponent).isEnemyCard();
            _loc2_ = 0;
            _loc3_ = 0;
            if(mAttachedToComponent.parent != null && mAttachedToComponent.parent is FSBattlefieldUserPortrait)
            {
               _loc2_ = FSBattlefieldUserPortrait(mAttachedToComponent.parent).x;
               _loc3_ = FSBattlefieldUserPortrait(mAttachedToComponent.parent).y;
            }
            _loc2_ += mAttachedToComponent.x;
            _loc3_ += mAttachedToComponent.y + mAttachedToComponent.height / 2;
            if(mAttachedToComponent.parent != null && mAttachedToComponent.parent is FSBattlefieldUserPortrait)
            {
               mParticleSystem.x = _loc2_ + mAttachedToComponent.width / 2;
               mParticleSystem.y = _loc3_ + mAttachedToComponent.height / 2;
            }
            else
            {
               mParticleSystem.x = _loc2_;
               mParticleSystem.y = _loc3_;
            }
            InstanceMng.getCurrentScreen().addChild(mParticleSystem);
            setTimeout(InstanceMng.getCurrentScreen().addChild,100,mParticleSystem);
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

