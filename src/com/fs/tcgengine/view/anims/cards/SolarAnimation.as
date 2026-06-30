package com.fs.tcgengine.view.anims.cards
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.view.components.battle.FSBattlefieldUserPortrait;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   import starling.core.Starling;
   import starling.utils.deg2rad;
   
   public class SolarAnimation extends CardAnimation
   {
      
      public static const EXTRA_IMAGE_NAME:String = "solar_anim";
      
      private static const DELAY_IMG_2:Number = CardAnimation.getMaxDuration() / 2;
      
      private static const DELAY_IMG_3:Number = CardAnimation.getMaxDuration() / 3;
      
      protected var mExtraGraphics2:FSImage;
      
      protected var mExtraGraphics3:FSImage;
      
      public function SolarAnimation()
      {
         super();
      }
      
      override protected function triggerExtraGraphicsTweening() : void
      {
         if(mAttachedToComponent != null && mExtraGraphics != null)
         {
            mExtraGraphics = this.configExtraGraphicImage(mExtraGraphics);
            this.mExtraGraphics2 = this.configExtraGraphicImage(this.mExtraGraphics2,CardAnimation.getMaxDuration(),DELAY_IMG_2);
            this.mExtraGraphics3 = this.configExtraGraphicImage(this.mExtraGraphics3,CardAnimation.getMaxDuration(),DELAY_IMG_3);
            if(this.mExtraGraphics2 != null)
            {
               this.mExtraGraphics2.x -= this.mExtraGraphics2.width * 0.85;
               this.mExtraGraphics2.rotation += deg2rad(5);
            }
            if(this.mExtraGraphics3 != null)
            {
               this.mExtraGraphics3.x += this.mExtraGraphics3.width * 0.85;
               this.mExtraGraphics3.rotation -= deg2rad(5);
            }
         }
      }
      
      override protected function triggerParticleSystem() : void
      {
         if(mParticleSystem != null)
         {
            mParticleSystem.x = mExtraGraphics.x;
            mParticleSystem.y = mExtraGraphics.y;
            InstanceMng.getCurrentScreen().addChild(mParticleSystem);
            Starling.juggler.add(mParticleSystem);
            mParticleSystem.start(0.5);
         }
         TweenMax.delayedCall(CardAnimation.getMaxDuration() * 2,this.unload);
      }
      
      private function configExtraGraphicImage(param1:FSImage, param2:Number = -1, param3:Number = 0) : FSImage
      {
         param2 = param2 == -1 ? CardAnimation.getMaxDuration() : param2;
         if(param1 == null)
         {
            param1 = new FSImage(Root.assets.getTexture(EXTRA_IMAGE_NAME));
         }
         param1.touchable = false;
         if(!contains(param1))
         {
            param1.alignPivot();
            if(mAttachedToComponent != null && mAttachedToComponent.parent != null && mAttachedToComponent.parent is FSBattlefieldUserPortrait)
            {
               param1.x = FSBattlefieldUserPortrait(mAttachedToComponent.parent).x + mAttachedToComponent.x + mAttachedToComponent.width / 2;
               param1.y = FSBattlefieldUserPortrait(mAttachedToComponent.parent).y + mAttachedToComponent.y + mAttachedToComponent.height / 2;
            }
            else
            {
               param1.x = mAttachedToComponent.x;
               param1.y = mAttachedToComponent.y;
            }
            param1.alpha = 0.001;
            InstanceMng.getCurrentScreen().addChild(param1);
            TweenMax.delayedCall(param3,TweenMax.fromTo,[param1,param2,{
               "alpha":0,
               "scaleX":0.5,
               "scaleY":0.5
            },{
               "alpha":1,
               "scaleX":0.999,
               "scaleY":0.999,
               "onComplete":this.removeExtraGraphics,
               "onCompleteParams":[param1,param3]
            }]);
         }
         return param1;
      }
      
      private function removeExtraGraphics(param1:FSImage, param2:Number = 0) : void
      {
         var _loc3_:Number = NaN;
         if(param1 != null)
         {
            _loc3_ = CardAnimation.getMaxDuration() - param2;
            SpecialFX.tweenToAlpha(param1,0.001,_loc3_,0);
         }
      }
      
      private function unloadExtraImages(param1:FSImage) : void
      {
         if(param1)
         {
            param1.removeFromParent();
            param1.destroy();
            param1 = null;
         }
      }
      
      override public function unload(param1:Boolean = false) : void
      {
         TweenMax.delayedCall(DELAY_IMG_2,this.unloadExtraImages,[this.mExtraGraphics2]);
         TweenMax.delayedCall(DELAY_IMG_3,this.unloadExtraImages,[this.mExtraGraphics3]);
         super.unload(param1);
      }
   }
}

