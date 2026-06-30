package com.fs.tcgengine.view.anims.cards
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.utils.Utils;
   import com.greensock.TweenMax;
   
   public class BloodSplashAnimation extends CardAnimation
   {
      
      public static const EXTRA_IMAGE_NAME:String = "blood_splash";
      
      public function BloodSplashAnimation()
      {
         super();
      }
      
      override public function init() : void
      {
         super.init();
         var _loc1_:String = Constants.SOUND_HEART_BEAT;
         Utils.playSound(_loc1_,SoundManager.TYPE_SFX);
      }
      
      override protected function triggerExtraGraphicsTweening() : void
      {
         if(mAttachedToComponent != null && mExtraGraphics != null)
         {
            if(!contains(mExtraGraphics))
            {
               mExtraGraphics.alignPivot();
               mExtraGraphics.x = mAttachedToComponent.width / 2;
               mExtraGraphics.y = mAttachedToComponent.height / 2;
               mExtraGraphics.alpha = 0.999;
               mAttachedToComponent.addChild(mExtraGraphics);
               TweenMax.delayedCall(CardAnimation.getMaxDuration() / 2,removeExtraGraphicsOnComponent);
            }
         }
      }
   }
}

