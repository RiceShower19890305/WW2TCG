package com.fs.tcgengine.view.anims.cards
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.AbilitiesMng;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.model.board.card.Ability;
   import com.fs.tcgengine.model.rules.AbilityDef;
   import com.fs.tcgengine.model.userdata.UserBattleInfo;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.FSUnit;
   import com.fs.tcgengine.view.components.battle.FSBattlefieldUserPortrait;
   import com.greensock.TweenMax;
   import com.greensock.easing.Cubic;
   import starling.core.Starling;
   import starling.display.MovieClip;
   import starling.textures.Texture;
   
   public class MovieClipZoomAnimation extends CardAnimation
   {
      
      protected var mMC:MovieClip;
      
      protected var mAbility:Ability;
      
      public function MovieClipZoomAnimation(param1:Ability)
      {
         this.mAbility = param1;
         setIsPermanent(true);
         super();
      }
      
      override public function init() : void
      {
         super.init();
         this.createZoomMC();
         this.triggerIconZoomTransition();
      }
      
      protected function triggerIconZoomTransition() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Boolean = false;
         if(Boolean(this.mMC) && Boolean(mAttachedToComponent))
         {
            this.mMC.alpha = 0.001;
            if(this.mMC)
            {
               this.mMC.scaleX *= Config.ANIM_SCALE;
               this.mMC.scaleY *= Config.ANIM_SCALE;
            }
            if(mAttachedToComponent is FSCard)
            {
               FSCard(mAttachedToComponent).getAbsAnimsLayer().addChild(this.mMC);
            }
            else
            {
               this.mMC.alignPivot();
               _loc2_ = Boolean(mAttachedToComponent.hasOwnProperty("width")) && Boolean(mAttachedToComponent.hasOwnProperty("height")) && Boolean(mAttachedToComponent.hasOwnProperty("scaleX")) && Boolean(mAttachedToComponent.hasOwnProperty("scaleY")) && Boolean(mAttachedToComponent.hasOwnProperty("height"));
               this.mMC.x = _loc2_ ? mAttachedToComponent.width / mAttachedToComponent.scaleX * 0.35 : 0;
               this.mMC.y = _loc2_ ? mAttachedToComponent.height / mAttachedToComponent.scaleY * 0.35 : 0;
               mAttachedToComponent.addChild(this.mMC);
            }
            SpecialFX.tweenToAlpha(this.mMC,0.999,0.5,0);
            this.playFXSound();
            _loc1_ = this.mMC.scaleX * Config.getConfig().gameGetMovieclipAnimScaleFactor();
            SpecialFX.createZoomTransition(this.mMC,_loc1_,getTransitionTime(ZOOM_OUT_DURATION),null,null,Cubic.easeIn);
         }
      }
      
      public function removeZoomAnim() : void
      {
         if(this.mMC)
         {
            this.mMC.stop();
            Starling.juggler.remove(this.mMC);
            this.mMC.removeFromParent();
            this.mMC = null;
         }
      }
      
      private function playFXSound() : void
      {
         var _loc1_:String = this.mAbility.getAbilityDef().getSoundName();
         if(_loc1_ == null || _loc1_ == "")
         {
            _loc1_ = Constants.SOUND_ICON_ZOOM_ANIM;
         }
         Utils.playSound(_loc1_,SoundManager.TYPE_SFX);
      }
      
      private function createZoomMC(param1:int = 0) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:Vector.<Texture> = null;
         var _loc5_:String = null;
         var _loc6_:AbilityDef = null;
         var _loc7_:int = 0;
         if(this.mMC == null)
         {
            _loc2_ = this.mAbility.getAbilityDef().getAnimIconName();
            _loc3_ = 24;
            _loc4_ = Root.assets.getTextures(_loc2_ + "_");
            if((Boolean(_loc4_)) && _loc4_.length > 0)
            {
               if(this.mMC == null)
               {
                  _loc6_ = this.mAbility ? this.mAbility.getAbilityDef() : null;
                  _loc7_ = _loc6_.getAnimatedBGFPS() != 0 ? _loc6_.getAnimatedBGFPS() : _loc3_;
                  this.mMC = new MovieClip(_loc4_,_loc7_);
                  this.mMC.touchable = false;
               }
               Starling.juggler.add(this.mMC);
               this.mMC.play();
               addChild(this.mMC);
            }
            else if(param1 < 3)
            {
               TweenMax.delayedCall(0.1,this.createZoomMC,[param1 + 1]);
            }
            _loc5_ = this.mAbility.getAbilityDef().getKeyName();
            if(mAttachedToComponent)
            {
               if(mAttachedToComponent is FSUnit)
               {
                  switch(_loc5_)
                  {
                     case AbilitiesMng.SPECIAL_RISING:
                     case AbilitiesMng.SPECIAL_MASSRISING:
                     case AbilitiesMng.SPECIAL_MASSIVERISING:
                     case AbilitiesMng.SPECIAL_SELFRISING:
                        FSUnit(mAttachedToComponent).setInvulnerableMC(this.mMC);
                        break;
                     case AbilitiesMng.SPECIAL_CAPTURED:
                     case AbilitiesMng.SPECIAL_MASSCAPTURED:
                        FSUnit(mAttachedToComponent).setLockingAbilityMcOnCard(this.mMC);
                  }
               }
               else
               {
                  switch(_loc5_)
                  {
                     case AbilitiesMng.SPECIAL_RISING:
                     case AbilitiesMng.SPECIAL_MASSRISING:
                     case AbilitiesMng.SPECIAL_MASSIVERISING:
                     case AbilitiesMng.SPECIAL_SELFRISING:
                        UserBattleInfo(FSBattlefieldUserPortrait(mAttachedToComponent.parent).getUserBattleInfo()).setInvulnerableMC(this.mMC);
                  }
               }
            }
         }
      }
   }
}

