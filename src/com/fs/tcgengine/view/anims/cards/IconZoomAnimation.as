package com.fs.tcgengine.view.anims.cards
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.AbilitiesMng;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.model.board.card.Ability;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSUnit;
   import com.fs.tcgengine.view.components.battle.FSBattlefieldUserPortrait;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   import com.greensock.easing.Cubic;
   
   public class IconZoomAnimation extends CardAnimation
   {
      
      protected var mIconImage:FSImage;
      
      protected var mAbility:Ability;
      
      public function IconZoomAnimation(param1:Ability)
      {
         this.mAbility = param1;
         super();
      }
      
      override public function init() : void
      {
         super.init();
         this.createZoomIcon();
         this.triggerIconZoomTransition(this.unloadIconImage);
      }
      
      protected function triggerIconZoomTransition(param1:Function) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Number = NaN;
         if(Boolean(this.mIconImage) && Boolean(mAttachedToComponent))
         {
            this.mIconImage.alpha = 0.001;
            this.mIconImage.alignPivot();
            this.mIconImage.scaleX = 1;
            this.mIconImage.scaleY = 1;
            _loc2_ = Boolean(mAttachedToComponent.hasOwnProperty("width")) && Boolean(mAttachedToComponent.hasOwnProperty("height")) && Boolean(mAttachedToComponent.hasOwnProperty("scaleX")) && Boolean(mAttachedToComponent.hasOwnProperty("scaleY")) && Boolean(mAttachedToComponent.hasOwnProperty("height"));
            if(mAttachedToComponent is FSUnit && Boolean(FSUnit(mAttachedToComponent).getBG()))
            {
               this.mIconImage.x = _loc2_ ? FSUnit(mAttachedToComponent).getBG().x + FSUnit(mAttachedToComponent).getBG().width / 2 : 0;
               this.mIconImage.y = _loc2_ ? FSUnit(mAttachedToComponent).getBG().y + FSUnit(mAttachedToComponent).getBG().height / 2 : 0;
            }
            else
            {
               this.mIconImage.x = _loc2_ ? mAttachedToComponent.width / mAttachedToComponent.scaleX / 2 : 0;
               this.mIconImage.y = _loc2_ ? mAttachedToComponent.height / mAttachedToComponent.scaleY / 2 : 0;
            }
            mAttachedToComponent.addChild(this.mIconImage);
            SpecialFX.tweenToAlpha(this.mIconImage,0.999,0.5,0);
            this.playFXSound();
            _loc3_ = this.mIconImage.scaleX - this.mIconImage.scaleX * 0.25;
            SpecialFX.createZoomTransition(this.mIconImage,_loc3_,getTransitionTime(ZOOM_OUT_DURATION),param1,null,Cubic.easeIn);
         }
      }
      
      protected function unloadIconImage() : void
      {
         if(this.mIconImage)
         {
            if(!InstanceMng.getAbilitiesMng().isPersistentAbilityIcon(this.mAbility))
            {
               TweenMax.delayedCall(getTransitionTime(FADE_OFF_DELAY),SpecialFX.tweenToAlpha,[this.mIconImage,0.001,getTransitionTime(FADE_OFF_DURATION),0,this.removeIconZoomAnim,[this.mIconImage]]);
            }
         }
      }
      
      private function removeIconZoomAnim(param1:FSImage) : void
      {
         if(param1)
         {
            param1.removeFromParent();
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
      
      private function createZoomIcon() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         if(this.mIconImage == null)
         {
            _loc1_ = this.mAbility.getAbilityDef().getAnimIconName();
            this.mIconImage = new FSImage(Root.assets.getTexture(_loc1_));
            this.mIconImage.touchable = false;
            _loc2_ = this.mAbility.getAbilityDef().getKeyName();
            if(mAttachedToComponent)
            {
               if(mAttachedToComponent is FSUnit)
               {
                  switch(_loc2_)
                  {
                     case AbilitiesMng.SPECIAL_RISING:
                     case AbilitiesMng.SPECIAL_MASSRISING:
                     case AbilitiesMng.SPECIAL_MASSIVERISING:
                     case AbilitiesMng.SPECIAL_SELFRISING:
                        FSUnit(mAttachedToComponent).setInvulnerableIcon(this.mIconImage);
                        break;
                     case AbilitiesMng.SPECIAL_CAPTURED:
                     case AbilitiesMng.SPECIAL_MASSCAPTURED:
                        FSUnit(mAttachedToComponent).setLockingAbilityIconOnCard(this.mIconImage);
                        break;
                     case AbilitiesMng.SPECIAL_UNBLOCKABLE:
                     case AbilitiesMng.SPECIAL_MASSUNBLOCKABLE:
                     case AbilitiesMng.SPECIAL_PERMANENTUNBLOCKABLE:
                        FSUnit(mAttachedToComponent).setUnblockableIcon(this.mIconImage);
                        break;
                     case AbilitiesMng.SPECIAL_CODEINTERCEPTION:
                     case AbilitiesMng.SPECIAL_MASSCODEINTERCEPTION:
                        FSUnit(mAttachedToComponent).setCodeInterceptionIcon(this.mIconImage);
                        break;
                     case AbilitiesMng.SPECIAL_TACTICALMASTER:
                     case AbilitiesMng.SPECIAL_MASSTACTICALMASTER:
                        FSUnit(mAttachedToComponent).setTacticalMasterIcon(this.mIconImage);
                        break;
                     case AbilitiesMng.SPECIAL_POISON:
                     case AbilitiesMng.SPECIAL_MASSPOISON:
                        FSUnit(mAttachedToComponent).setPoisonIcon(this.mIconImage);
                  }
               }
               else if(Boolean(mAttachedToComponent.hasOwnProperty("parent")) && Boolean(mAttachedToComponent.parent != null) && mAttachedToComponent.parent is FSBattlefieldUserPortrait)
               {
                  switch(_loc2_)
                  {
                     case AbilitiesMng.SPECIAL_RISING:
                        FSBattlefieldUserPortrait(mAttachedToComponent.parent).getUserBattleInfo().setInvulnerableIcon(this.mIconImage);
                        break;
                     case AbilitiesMng.SPECIAL_MASSIVERISING:
                        FSBattlefieldUserPortrait(mAttachedToComponent.parent).getUserBattleInfo().setInvulnerableIcon(this.mIconImage);
                        break;
                     case AbilitiesMng.SPECIAL_POISON:
                     case AbilitiesMng.SPECIAL_MASSPOISON:
                        FSBattlefieldUserPortrait(mAttachedToComponent.parent).getUserBattleInfo().setPoisonIcon(this.mIconImage);
                  }
               }
            }
         }
      }
      
      override public function dispose() : void
      {
         this.mAbility = null;
         this.mIconImage = null;
         super.dispose();
      }
   }
}

