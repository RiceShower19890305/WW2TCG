package com.fs.tcgengine.view.components.popups.misc
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.particles.FSPDParticleSystem;
   import com.fs.tcgengine.resources.AssetsParticles;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.popups.Popup;
   import com.fs.tcgengine.view.popups.levels.FSPopupPlayLevel;
   import com.greensock.TweenMax;
   import starling.core.Starling;
   import starling.display.MovieClip;
   
   public class FSPopupStar extends Component
   {
      
      public static const MAX_DURATION:Number = 0.25;
      
      private const SCORE_REACHED_OFF_IMG_NAME:String = "bg_star";
      
      private const SCORE_REACHED_ON_IMG_NAME:String = "popup_star_";
      
      private var mBGImage:FSImage;
      
      private var mCompletedImage:MovieClip;
      
      private var mScale:Number = 1;
      
      protected var mParticleSystem:FSPDParticleSystem;
      
      private var mParentContainer:Component;
      
      private var mStarIndex:int;
      
      public function FSPopupStar(param1:Number, param2:Component, param3:int)
      {
         super();
         this.mScale = param1;
         this.mParentContainer = param2;
         this.mStarIndex = param3;
         this.init();
      }
      
      private function init() : void
      {
         this.createBGImage();
         alignPivot();
      }
      
      private function createBGImage() : void
      {
         if(this.mBGImage == null)
         {
            this.mBGImage = new FSImage(Root.assets.getTexture(this.SCORE_REACHED_OFF_IMG_NAME));
            this.mBGImage.scaleX = this.mScale;
            this.mBGImage.scaleY = this.mScale;
            addChild(this.mBGImage);
         }
      }
      
      public function turnOnStar() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         if(this.mCompletedImage == null)
         {
            if(this.mBGImage)
            {
               _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
               this.mCompletedImage = new MovieClip(Root.assets.getTextures(this.SCORE_REACHED_ON_IMG_NAME));
               Starling.juggler.add(this.mCompletedImage);
               this.mCompletedImage.play();
               this.mCompletedImage.scaleX = this.mBGImage.scaleX;
               this.mCompletedImage.scaleY = this.mBGImage.scaleY;
               this.mCompletedImage.x = this.mBGImage.width / 2;
               this.mCompletedImage.y = this.mBGImage.height / 2;
               this.mCompletedImage.alignPivot();
               addChild(this.mCompletedImage);
               switch(this.mStarIndex)
               {
                  case 1:
                     _loc2_ = Constants.SOUND_STAR_1;
                     break;
                  case 2:
                     _loc2_ = Constants.SOUND_STAR_2;
                     break;
                  case 3:
                     _loc2_ = Constants.SOUND_STAR_3;
               }
               Utils.playSound(_loc2_,SoundManager.TYPE_SFX);
               this.createStarFX();
               this.triggerParticleSystem();
            }
         }
      }
      
      private function createStarFX() : void
      {
         this.mParticleSystem = AssetsParticles.requestParticleSystem("star");
         SpecialFX.createYoYoZoomTransition(this.mCompletedImage,this.mCompletedImage.scaleX * 1.5,FSPopupPlayLevel.STAR_ANIM_DURATION,1,this.createIdleState,null,false);
      }
      
      private function createIdleState() : void
      {
         if(this.mCompletedImage)
         {
            SpecialFX.createYoYoZoomTransition(this.mCompletedImage,this.mCompletedImage.scaleX * 1.3,2.5,-1,null,null,false);
         }
      }
      
      protected function triggerParticleSystem() : void
      {
         var _loc1_:Popup = null;
         if(this.mParticleSystem != null && Boolean(this.mParentContainer))
         {
            _loc1_ = InstanceMng.getPopupMng().getPopupShown();
            this.mParticleSystem.x = this.mParentContainer.x + x;
            this.mParticleSystem.y = this.mParentContainer.y + y;
            if(_loc1_)
            {
               _loc1_.addChild(this.mParticleSystem);
               Starling.juggler.add(this.mParticleSystem);
               this.mParticleSystem.start(MAX_DURATION);
            }
         }
         TweenMax.delayedCall(MAX_DURATION * 2,this.unload);
      }
      
      public function unload(param1:Boolean = false) : void
      {
         if(this.mParticleSystem != null)
         {
            if(this.mParticleSystem.parent != null)
            {
               SpecialFX.tweenToAlpha(this.mParticleSystem,0.001,MAX_DURATION,0,this.removeParticleSystemFromDL);
            }
         }
      }
      
      private function removeParticleSystemFromDL() : void
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
         if(this.mBGImage)
         {
            this.mBGImage.removeFromParent(true);
            this.mBGImage = null;
         }
         if(this.mCompletedImage)
         {
            Starling.juggler.remove(this.mCompletedImage);
            this.mCompletedImage.removeFromParent(true);
            this.mCompletedImage = null;
         }
         this.removeParticleSystemFromDL();
         this.mParentContainer = null;
         super.dispose();
      }
   }
}

