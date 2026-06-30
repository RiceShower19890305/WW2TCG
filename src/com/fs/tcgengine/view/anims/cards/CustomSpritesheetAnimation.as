package com.fs.tcgengine.view.anims.cards
{
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.model.board.card.Ability;
   import com.fs.tcgengine.model.rules.AbilityDef;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.greensock.TweenMax;
   import starling.core.Starling;
   import starling.display.MovieClip;
   import starling.events.Event;
   import starling.textures.Texture;
   
   public class CustomSpritesheetAnimation extends CardAnimation
   {
      
      protected var mMc:MovieClip;
      
      protected var mAbility:Ability;
      
      public function CustomSpritesheetAnimation(param1:Ability)
      {
         this.mAbility = param1;
         super();
      }
      
      override public function init() : void
      {
         super.init();
         this.createMovieclip();
      }
      
      protected function getSpriteSheetName() : String
      {
         return this.mAbility.getAbilityDef().getAnimIconName();
      }
      
      protected function createMovieclip() : void
      {
         var _loc1_:String = null;
         var _loc2_:Vector.<Texture> = null;
         var _loc3_:AbilityDef = null;
         var _loc4_:int = 0;
         if(this.mMc == null)
         {
            _loc1_ = this.getSpriteSheetName();
            _loc2_ = Root.assets.getTextures(_loc1_);
            if(Boolean(_loc2_) && _loc2_.length > 0)
            {
               _loc3_ = this.mAbility ? this.mAbility.getAbilityDef() : null;
               _loc4_ = Boolean(_loc3_) && _loc3_.getAnimatedBGFPS() != 0 ? _loc3_.getAnimatedBGFPS() : int(_loc2_.length);
               this.mMc = new MovieClip(_loc2_,_loc4_);
               if(this.mMc)
               {
                  this.mMc.scaleX *= Config.ANIM_SCALE;
                  this.mMc.scaleY *= Config.ANIM_SCALE;
               }
               this.setupLooping();
               this.mMc.alpha = 0.001;
               if(mAttachedToComponent is FSCard)
               {
                  FSCard(mAttachedToComponent).getAbsAnimsLayer().addChild(this.mMc);
                  FSCard(mAttachedToComponent).setAbilitiesLayerOnTop();
               }
               else
               {
                  this.mMc.x = (mAttachedToComponent.width / mAttachedToComponent.scaleX - this.mMc.width) / 2;
                  this.mMc.y = (mAttachedToComponent.height / mAttachedToComponent.scaleY - this.mMc.height) / 2;
                  mAttachedToComponent.addChild(this.mMc);
               }
               SpecialFX.tweenToAlpha(this.mMc,0.999,0.5,0,this.playAnimation);
               this.mMc.touchable = false;
            }
         }
      }
      
      protected function setupLooping() : void
      {
         if(this.mMc)
         {
            this.mMc.loop = false;
         }
      }
      
      private function playAnimation() : void
      {
         if(this.mMc)
         {
            this.mMc.play();
            Starling.juggler.add(this.mMc);
            this.mMc.addEventListener(Event.COMPLETE,this.movieCompletedHandler);
            TweenMax.delayedCall(3,this.fadeOff);
         }
      }
      
      override public function unload(param1:Boolean = false) : void
      {
         super.unload(param1);
         this.fadeOff();
      }
      
      protected function movieCompletedHandler(param1:Event) : void
      {
         if(this.mMc)
         {
            this.fadeOff();
         }
      }
      
      public function fadeOff() : void
      {
         if(this.mMc)
         {
            TweenMax.delayedCall(getTransitionTime(FADE_OFF_DELAY),SpecialFX.tweenToAlpha,[this.mMc,0,getTransitionTime(FADE_OFF_DURATION),0,this.unloadMovieclip]);
         }
      }
      
      public function unloadMovieclip() : void
      {
         if(this.mMc)
         {
            this.mMc.removeFromParent();
            Starling.juggler.remove(this.mMc);
            this.mMc.removeEventListener(Event.COMPLETE,this.movieCompletedHandler);
            this.mMc = null;
         }
      }
      
      override public function dispose() : void
      {
         this.mAbility = null;
         super.dispose();
      }
   }
}

