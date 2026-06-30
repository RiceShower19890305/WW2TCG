package com.fs.tcgengine.view.anims.cards
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.particles.FSPDParticleSystem;
   import com.fs.tcgengine.resources.AssetsParticles;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSAttachment;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.FSShopInfoCard;
   import com.fs.tcgengine.view.cards.FSUnit;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.battle.FSBattlefieldUserPortrait;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   import flash.utils.setTimeout;
   import starling.core.Starling;
   
   public class CardAnimation extends Component
   {
      
      protected const ZOOM_OUT_DURATION:int = 0;
      
      protected const FADE_OFF_DELAY:int = 1;
      
      protected const FADE_OFF_DURATION:int = 2;
      
      protected const TRANSITION_DURATION:int = 3;
      
      protected var mAttachedToComponent:*;
      
      protected var mParticleSystem:FSPDParticleSystem;
      
      protected var mExtraGraphics:FSImage;
      
      protected var mIsPermanent:Boolean;
      
      protected var mBelongsToAbilityKeyname:String;
      
      public function CardAnimation()
      {
         super();
      }
      
      public static function getMaxDuration() : Number
      {
         return 1 * Utils.getDefaultSpeedTime();
      }
      
      protected function getTransitionTime(param1:int) : Number
      {
         var _loc2_:Number = 1;
         switch(param1)
         {
            case this.ZOOM_OUT_DURATION:
               _loc2_ = 0.75 * Utils.getDefaultSpeedTime();
               break;
            case this.FADE_OFF_DELAY:
               _loc2_ = 1 * Utils.getDefaultSpeedTime();
               break;
            case this.FADE_OFF_DURATION:
               _loc2_ = 2 * Utils.getDefaultSpeedTime();
               break;
            case this.TRANSITION_DURATION:
               _loc2_ = this.getTransitionTime(this.ZOOM_OUT_DURATION) + this.getTransitionTime(this.FADE_OFF_DELAY) + this.getTransitionTime(this.FADE_OFF_DURATION);
         }
         return _loc2_;
      }
      
      public function setup(param1:*, param2:String = "", param3:FSImage = null) : void
      {
         var _loc4_:FSCard = null;
         if(param1 != null)
         {
            if(param1 is FSCard)
            {
               _loc4_ = FSCard(param1);
               if(_loc4_.getType() == FSCard.TYPE_ATTACHMENT)
               {
                  param1 = FSAttachment(_loc4_).getAttachedToSocket() ? FSAttachment(_loc4_).getAttachedToSocket().getParentCard() : null;
               }
            }
            else if(Boolean(param1.parent) && param1.parent is FSBattlefieldUserPortrait)
            {
               FSBattlefieldUserPortrait(param1.parent).addPortraitAnimationAttached(this);
            }
            if(param1)
            {
               this.setAttachedToComponent(param1);
            }
         }
         if(param2 != "")
         {
            this.setParticleSystem(AssetsParticles.requestParticleSystem(param2));
         }
         if(param3 != null)
         {
            this.setExtraGraphics(param3);
         }
         this.init();
      }
      
      public function init() : void
      {
         if(this.mAttachedToComponent != null)
         {
            this.triggerExtraGraphicsTweening();
            this.triggerParticleSystem();
            if(this.mAttachedToComponent is FSUnit)
            {
               if(FSUnit(this.mAttachedToComponent).getAbsAnimsLayer())
               {
                  FSUnit(this.mAttachedToComponent).getAbsAnimsLayer().addChild(this);
               }
            }
            else if(Boolean(this.mAttachedToComponent.parent) && this.mAttachedToComponent.parent is FSBattlefieldUserPortrait)
            {
               this.mAttachedToComponent.parent.addChild(this);
            }
         }
      }
      
      protected function triggerParticleSystem() : void
      {
         var _loc1_:Number = getMaxDuration() * 2;
         if(this.mParticleSystem != null)
         {
            if(this.mAttachedToComponent is FSUnit)
            {
               this.mParticleSystem.x = this.mAttachedToComponent.x;
               this.mParticleSystem.y = this.mAttachedToComponent.y;
               InstanceMng.getCurrentScreen().addChild(this.mParticleSystem);
            }
            else if(this.mAttachedToComponent is FSShopInfoCard)
            {
               this.mParticleSystem.x = this.mAttachedToComponent.width / 4;
               this.mParticleSystem.y = this.mAttachedToComponent.height / 3;
               this.mAttachedToComponent.addChildAt(this.mParticleSystem,0);
            }
            else
            {
               if(Boolean(this.mAttachedToComponent.parent) && this.mAttachedToComponent.parent is FSBattlefieldUserPortrait)
               {
                  this.mParticleSystem.x = FSBattlefieldUserPortrait(this.mAttachedToComponent.parent).x;
                  this.mParticleSystem.y = FSBattlefieldUserPortrait(this.mAttachedToComponent.parent).y;
               }
               this.mParticleSystem.x += this.mExtraGraphics == null ? FSBattlefieldUserPortrait(this.mAttachedToComponent.parent).x + this.mAttachedToComponent.x + this.mAttachedToComponent.width / 2 : this.mAttachedToComponent.x + this.mExtraGraphics.x;
               this.mParticleSystem.y += this.mExtraGraphics == null ? this.mAttachedToComponent.y + this.mAttachedToComponent.height / 2 : this.mAttachedToComponent.y + this.mExtraGraphics.y;
               InstanceMng.getCurrentScreen().addChild(this.mParticleSystem);
            }
            Starling.juggler.add(this.mParticleSystem);
            this.mParticleSystem.start(_loc1_);
         }
         TweenMax.delayedCall(_loc1_ * 2,this.unload);
      }
      
      protected function triggerExtraGraphicsTweening() : void
      {
         if(this.mAttachedToComponent != null && this.mExtraGraphics != null && !contains(this.mExtraGraphics))
         {
            addChild(this.mExtraGraphics);
         }
      }
      
      public function unload(param1:Boolean = false) : void
      {
         if(this.mParticleSystem != null)
         {
            if(this.mAttachedToComponent != null)
            {
               SpecialFX.tweenToAlpha(this.mParticleSystem,0.001,getMaxDuration(),0,this.removeParticleSystemFromDL);
            }
         }
         if(this.mAttachedToComponent != null && this.mAttachedToComponent.parent != null && this.mAttachedToComponent.parent is FSBattlefieldUserPortrait || this.mAttachedToComponent != null && this.mAttachedToComponent.name == "SHIELD" || param1)
         {
            setTimeout(this.removeExtraGraphicsOnComponent,1000);
         }
         removeEventListeners();
      }
      
      public function removeParticleSystemFromDL() : void
      {
         if(this.mParticleSystem)
         {
            this.mParticleSystem.removeFromParent(true);
            Starling.juggler.remove(this.mParticleSystem);
         }
         this.mParticleSystem = null;
      }
      
      override public function dispose() : void
      {
         this.unload();
         super.dispose();
      }
      
      protected function removeExtraGraphicsOnComponent() : void
      {
         var _loc1_:Number = NaN;
         if(this.mExtraGraphics != null)
         {
            _loc1_ = getMaxDuration();
            SpecialFX.tweenToAlpha(this.mExtraGraphics,0.001,_loc1_,0,this.removeExtraGraphicsFromDisplayList);
         }
      }
      
      protected function removeExtraGraphicsFromDisplayList() : void
      {
         if(this.mExtraGraphics != null)
         {
            this.mExtraGraphics.removeFromParent();
         }
      }
      
      public function setAttachedToComponent(param1:*) : void
      {
         this.mAttachedToComponent = param1;
      }
      
      public function setParticleSystem(param1:FSPDParticleSystem) : void
      {
         this.mParticleSystem = param1;
         if(this.mParticleSystem)
         {
            this.mParticleSystem.touchable = false;
         }
      }
      
      public function getExtraGraphics() : FSImage
      {
         return this.mExtraGraphics;
      }
      
      public function setExtraGraphics(param1:FSImage) : void
      {
         if(param1.texture != null)
         {
            this.mExtraGraphics = param1;
            if(this.mExtraGraphics)
            {
               this.mExtraGraphics.touchable = false;
            }
         }
      }
      
      public function setIsPermanent(param1:Boolean) : void
      {
         this.mIsPermanent = param1;
      }
      
      public function isPermanent() : Boolean
      {
         return this.mIsPermanent;
      }
      
      public function setAbilityItBelongsTo(param1:String) : void
      {
         this.mBelongsToAbilityKeyname = param1;
      }
      
      public function getAbilityItBelongsTo() : String
      {
         return this.mBelongsToAbilityKeyname;
      }
   }
}

