package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.particles.FSPDParticleSystem;
   import com.fs.tcgengine.resources.AssetsParticles;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.greensock.TweenMax;
   import com.greensock.easing.Back;
   import com.greensock.easing.Expo;
   import com.greensock.easing.Sine;
   import starling.core.Starling;
   import starling.display.MovieClip;
   import starling.textures.Texture;
   import starling.utils.deg2rad;
   
   public class FSVictoryAnimation extends Component
   {
      
      private const MAX_DURATION:Number = 0.75;
      
      protected var mBG:FSImage;
      
      protected var mChar:FSImage;
      
      protected var mCharTextureRef:Texture;
      
      protected var mBGAnimBar1:FSImage;
      
      protected var mBGAnimBar2:FSImage;
      
      protected var mBGAnimBar3:FSImage;
      
      protected var mBGAnimBar4:FSImage;
      
      protected var mTextfield:FSTextfield;
      
      protected var mIsShown:Boolean = false;
      
      protected var mFirework1:FSPDParticleSystem;
      
      protected var mFirework2:FSPDParticleSystem;
      
      protected var mFirework3:FSPDParticleSystem;
      
      protected var mOnFadeOffCompleteFunction:Function;
      
      protected var mOnFadeOffCompleteParams:Array;
      
      protected var mInfiniteFireworks:Boolean;
      
      protected var mSubBG:FSImage;
      
      private var mLevelUpEffect1:FSImage;
      
      private var mSparkleEffect1:MovieClip;
      
      private var mSparkleEffect2:MovieClip;
      
      public function FSVictoryAnimation(param1:Texture, param2:Function = null, param3:Array = null, param4:Boolean = false)
      {
         super();
         this.mCharTextureRef = param1;
         this.mOnFadeOffCompleteFunction = param2;
         this.mOnFadeOffCompleteParams = param3;
         this.mInfiniteFireworks = param4;
         this.createUI();
      }
      
      private function createUI() : void
      {
         visible = false;
         this.createChar();
         this.createSubBG();
         this.createSparkles();
         this.createBG();
         this.createSpecialFX();
         this.createTextfield();
         this.createAnimBars();
         this.createFX();
         alignPivot();
         touchable = false;
      }
      
      protected function createSpecialFX() : void
      {
         var _loc1_:Number = NaN;
         if(this.mLevelUpEffect1 == null)
         {
            this.mLevelUpEffect1 = new FSImage(Root.assets.getTexture("job_effect_1"));
            this.mLevelUpEffect1.scale = 5;
            this.mLevelUpEffect1.alignPivot();
            this.mLevelUpEffect1.x = this.mBG.x;
            this.mLevelUpEffect1.y = this.mBG.y;
         }
         if(this.mLevelUpEffect1)
         {
            _loc1_ = this.mLevelUpEffect1.scale;
            this.mLevelUpEffect1.scale = 0.1;
            addChild(this.mLevelUpEffect1);
            SpecialFX.createZoomAlphaTween(this.mLevelUpEffect1,2,1,0,0.1,_loc1_ * 1.6,null,this.onTransitionEnd);
            SpecialFX.createRotation(this.mLevelUpEffect1,360);
         }
      }
      
      private function onTransitionEnd() : void
      {
         if(this.mLevelUpEffect1)
         {
            this.mLevelUpEffect1.removeFromParent();
            this.mLevelUpEffect1.destroy();
            this.mLevelUpEffect1 = null;
         }
      }
      
      protected function createSubBG(param1:String = "victory_level_bg", param2:Number = 1) : void
      {
         var transTime:Number;
         var onArrivedDoSecondTransition:Function = null;
         var textureName:String = param1;
         var speedFactor:Number = param2;
         onArrivedDoSecondTransition = function():void
         {
            if(mSubBG)
            {
               SpecialFX.createYoYoTransition(mSubBG,new FSCoordinate(mSubBG.x,mSubBG.y + 15),2 * speedFactor,-1,null,Sine.easeInOut);
            }
         };
         if(this.mSubBG == null)
         {
            this.mSubBG = new FSImage(Root.assets.getTexture(textureName));
         }
         this.mSubBG.alignPivot();
         this.mSubBG.scale = 1.5;
         this.mSubBG.x = this.mChar.x;
         this.mSubBG.y = this.mChar.y + 15;
         this.mSubBG.alpha = 0;
         transTime = 1.5 * speedFactor;
         SpecialFX.createTransition(this.mSubBG,new FSCoordinate(this.mSubBG.x,this.mSubBG.y - 15),transTime,0,onArrivedDoSecondTransition,null,Back.easeInOut);
         SpecialFX.tweenToAlpha(this.mSubBG,1,transTime * 1.5,0.5);
         addChildAt(this.mSubBG,0);
      }
      
      protected function createSparkles() : void
      {
         var _loc1_:int = 0;
         _loc1_ = getChildIndex(this.mSubBG);
         if(this.mSparkleEffect1 == null)
         {
            this.mSparkleEffect1 = new MovieClip(Root.assets.getTextures("victory_sparkle_effect_"));
            this.mSparkleEffect1.alignPivot();
            this.mSparkleEffect1.scale = 1.5;
            this.mSparkleEffect1.rotation = deg2rad(30);
            this.mSparkleEffect1.x = this.mSubBG.x - this.mSubBG.width / 2 + this.mSparkleEffect1.width / 2;
            this.mSparkleEffect1.y = this.mSubBG.y - this.mSparkleEffect1.height / 4;
            Starling.juggler.add(this.mSparkleEffect1);
            addChildAt(this.mSparkleEffect1,_loc1_ + 1);
            this.mSparkleEffect1.play();
         }
         if(this.mSparkleEffect2 == null)
         {
            this.mSparkleEffect2 = new MovieClip(Root.assets.getTextures("victory_sparkle_effect_"));
            this.mSparkleEffect2.alignPivot();
            this.mSparkleEffect2.scale = 1.5;
            this.mSparkleEffect2.rotation = deg2rad(-30);
            this.mSparkleEffect2.x = this.mSubBG.x + this.mSubBG.width / 2 - this.mSparkleEffect2.width / 2;
            this.mSparkleEffect2.y = this.mSubBG.y - this.mSparkleEffect2.height / 4;
            Starling.juggler.add(this.mSparkleEffect2);
            addChildAt(this.mSparkleEffect2,_loc1_ + 1);
            this.mSparkleEffect2.play();
         }
      }
      
      protected function createChar(param1:String = "win_anim_char") : void
      {
         var onArrivedDoSecondTransition:Function = null;
         var noSkinTextureName:String = param1;
         onArrivedDoSecondTransition = function():void
         {
            if(mChar)
            {
               SpecialFX.createYoYoTransition(mChar,new FSCoordinate(mChar.x,mChar.y - 20),2,-1,null,Sine.easeInOut);
            }
         };
         if(this.mChar == null)
         {
            this.mChar = new FSImage(this.mCharTextureRef);
         }
         if(this.mChar)
         {
            this.mChar.alignPivot();
            SpecialFX.createZoomTransition(this.mChar,1.2,0.75,onArrivedDoSecondTransition,null,Back.easeIn);
            addChild(this.mChar);
         }
      }
      
      protected function createBG(param1:String = "victory_level_panel") : void
      {
         if(this.mBG == null)
         {
            this.mBG = new FSImage(Root.assets.getTexture(param1));
         }
         this.mBG.alignPivot();
         this.mBG.x = this.mChar ? this.mChar.x : 0;
         this.mBG.y = this.mChar ? this.mChar.y + this.mChar.height / 2 : 0;
         SpecialFX.createYoYoZoomTransition(this.mBG,1.2,2,-1,null,null,false);
         addChild(this.mBG);
      }
      
      protected function createAnimBars() : void
      {
         if(this.mBGAnimBar1 == null)
         {
            this.mBGAnimBar1 = new FSImage(Root.assets.getTexture("victory_animation"));
            this.mBGAnimBar1.scale = 4;
            this.mBGAnimBar1.pivotX = 0;
            this.mBGAnimBar1.pivotY = this.mBGAnimBar1.height;
            this.mBGAnimBar1.x = this.mBG.x + this.mBG.width / 2 - this.mBGAnimBar1.width;
            this.mBGAnimBar1.y = this.mTextfield ? this.mTextfield.y : 0;
         }
         if(this.mBGAnimBar2 == null)
         {
            this.mBGAnimBar2 = new FSImage(Root.assets.getTexture("victory_animation"));
            this.mBGAnimBar2.scale = 4;
            this.mBGAnimBar2.pivotX = 0;
            this.mBGAnimBar2.pivotY = this.mBGAnimBar2.height;
            this.mBGAnimBar2.x = this.mBGAnimBar1.x - this.mBGAnimBar2.width / 3;
            this.mBGAnimBar2.y = this.mBGAnimBar1.y;
         }
         if(this.mBGAnimBar3 == null)
         {
            this.mBGAnimBar3 = new FSImage(Root.assets.getTexture("victory_animation"));
            this.mBGAnimBar3.scale = 4;
            this.mBGAnimBar3.scaleX *= -1;
            this.mBGAnimBar3.pivotX = 0;
            this.mBGAnimBar3.pivotY = this.mBGAnimBar3.height;
            this.mBGAnimBar3.x = this.mBG.x - this.mBG.width / 2 + this.mBGAnimBar2.width;
            this.mBGAnimBar3.y = this.mBGAnimBar1.y;
         }
         if(this.mBGAnimBar4 == null)
         {
            this.mBGAnimBar4 = new FSImage(Root.assets.getTexture("victory_animation"));
            this.mBGAnimBar4.scale = 4;
            this.mBGAnimBar4.scaleX = -1;
            this.mBGAnimBar4.pivotX = 0;
            this.mBGAnimBar4.pivotY = this.mBGAnimBar4.height;
            this.mBGAnimBar4.x = this.mBGAnimBar3.x + this.mBGAnimBar4.width / 3;
            this.mBGAnimBar4.y = this.mBGAnimBar1.y;
         }
      }
      
      protected function startBarAnims() : void
      {
         var onRotationOver:Function = null;
         onRotationOver = function(param1:FSImage, param2:int, param3:int):void
         {
            if(param1)
            {
               SpecialFX.createRotation(param1,param3,param2,0,onRotationOver,[param1,param2,param3 * -1],Sine.easeInOut,0);
            }
         };
         if(Boolean(this.mBGAnimBar1) && Boolean(this.mBGAnimBar2) && Boolean(this.mBGAnimBar3) && Boolean(this.mBGAnimBar4))
         {
            addChildAt(this.mBGAnimBar1,0);
            addChildAt(this.mBGAnimBar2,0);
            addChildAt(this.mBGAnimBar3,0);
            addChildAt(this.mBGAnimBar4,0);
            this.mBGAnimBar1.rotation = deg2rad(20);
            this.mBGAnimBar2.rotation = deg2rad(40);
            this.mBGAnimBar3.rotation = deg2rad(-20);
            this.mBGAnimBar4.rotation = deg2rad(-40);
            SpecialFX.createRotation(this.mBGAnimBar1,0,3,0,onRotationOver,[this.mBGAnimBar1,3,-20],null,0);
            SpecialFX.createRotation(this.mBGAnimBar2,0,2,0,onRotationOver,[this.mBGAnimBar2,2,-40],null,0);
            SpecialFX.createRotation(this.mBGAnimBar3,0,3,0,onRotationOver,[this.mBGAnimBar3,3,20],null,0);
            SpecialFX.createRotation(this.mBGAnimBar4,0,2,0,onRotationOver,[this.mBGAnimBar4,2,40],null,0);
         }
      }
      
      protected function createTextfield(param1:String = "TID_GEN_LEVEL_VICTORY") : void
      {
         if(this.mTextfield == null)
         {
            this.mTextfield = new FSTextfield(this.mBG.width * 0.8,this.mBG.height * 0.8,TextManager.getText(param1),16777215,FSResourceMng.FONT_STD_BIG_TITLE_SIZE);
         }
         this.mTextfield.alignPivot();
         this.mTextfield.x = this.mBG.x;
         this.mTextfield.y = this.mBG.y;
         addChild(this.mTextfield);
      }
      
      public function performFadeIn() : void
      {
         this.mIsShown = true;
         visible = true;
         var _loc1_:Number = Utils.getDefaultSpeedTime();
         SpecialFX.createZoomAlphaTween(this,_loc1_,0,1,0,1,Expo.easeIn,this.startAnimsAfterFadeIn);
         Utils.playSound("unfold_rare",SoundManager.TYPE_SFX);
      }
      
      protected function startAnimsAfterFadeIn() : void
      {
         this.startBarAnims();
         this.createFX();
         this.triggerParticleSystem();
      }
      
      public function performFadeOut(param1:Number = 0.5) : void
      {
         this.mIsShown = false;
         SpecialFX.createZoomAlphaTween(this,param1,1,0,1,0,Back.easeOut,this.unload);
      }
      
      protected function createFX() : void
      {
         if(Config.getConfig().showFireworksOnVictoryAnimation())
         {
            if(this.mFirework1 == null)
            {
               this.mFirework1 = AssetsParticles.requestParticleSystem("firework1");
            }
            if(this.mFirework2 == null)
            {
               this.mFirework2 = AssetsParticles.requestParticleSystem("firework2");
            }
            if(this.mFirework3 == null)
            {
               this.mFirework3 = AssetsParticles.requestParticleSystem("firework3");
            }
         }
      }
      
      protected function triggerParticleSystem() : void
      {
         if(Config.getConfig().showFireworksOnVictoryAnimation())
         {
            if(this.mFirework1 != null)
            {
               this.startParticle(this.mFirework1);
            }
            if(this.mFirework2 != null)
            {
               this.startParticle(this.mFirework2,0.5);
            }
            if(this.mFirework3 != null)
            {
               this.startParticle(this.mFirework3,1);
            }
         }
      }
      
      protected function startParticle(param1:FSPDParticleSystem, param2:Number = 0) : void
      {
         var triggerParticle:Function = null;
         var particle:FSPDParticleSystem = param1;
         var extraDelay:Number = param2;
         triggerParticle = function():void
         {
            var _loc1_:Screen = null;
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            var _loc4_:Number = NaN;
            var _loc5_:Number = NaN;
            var _loc6_:Number = NaN;
            var _loc7_:Number = NaN;
            if(Boolean(particle) && Boolean(mBG))
            {
               particle.stop();
               particle.emitAngleVariance = 10;
               particle.endSize = 0;
               _loc1_ = InstanceMng.getCurrentScreen();
               if(_loc1_)
               {
                  _loc2_ = Utils.randomNumber(50,_loc1_.width);
                  _loc3_ = _loc1_.height;
                  _loc4_ = Utils.randomNumber(50,_loc1_.width);
                  _loc5_ = Utils.randomNumber(_loc1_.height / 2,_loc1_.height / 5);
                  particle.emitterX = _loc2_;
                  particle.emitterY = _loc3_;
                  addParticleToStage(particle);
                  _loc6_ = 0.85;
                  _loc7_ = 0.25;
                  particle.start(_loc6_ + _loc7_);
                  SpecialFX.createBezierCurvesBetweenTwoPoints(particle,new FSCoordinate(_loc2_,_loc3_),new FSCoordinate(_loc4_,_loc5_),_loc6_,Utils.randomInt(2,3),150,false,explodeParticle,[particle]);
                  Utils.playSound("pre_firework",SoundManager.TYPE_SFX);
                  TweenMax.delayedCall(_loc6_,Utils.playSound,["firework",SoundManager.TYPE_SFX]);
               }
            }
         };
         var delay:Number = Utils.randomNumber(0.25,0.65) + extraDelay;
         TweenMax.delayedCall(delay,triggerParticle);
      }
      
      protected function addParticleToStage(param1:FSPDParticleSystem) : void
      {
         var _loc2_:int = InstanceMng.getCurrentScreen().getChildIndex(InstanceMng.getCurrentScreen().getTouchableBG()) + 1;
         InstanceMng.getCurrentScreen().addChildAt(param1,_loc2_);
         Starling.juggler.add(param1);
      }
      
      private function explodeParticle(param1:FSPDParticleSystem) : void
      {
         if(param1)
         {
            param1.emitAngleVariance = 360;
            param1.endSize = 30;
            if(this.mInfiniteFireworks)
            {
               TweenMax.delayedCall(0.25,this.startParticle,[param1]);
            }
            else
            {
               TweenMax.delayedCall(0.25,this.unloadFirework,[param1]);
            }
         }
      }
      
      public function unloadFirework(param1:FSPDParticleSystem) : void
      {
         if(param1 != null)
         {
            TweenMax.killTweensOf(param1);
            TweenMax.killDelayedCallsTo(this.startParticle);
            if(param1.parent != null)
            {
               SpecialFX.tweenToAlpha(param1,0.001,this.MAX_DURATION,0,this.removeParticleSystemFromDL,[param1]);
            }
         }
      }
      
      private function removeParticleSystemFromDL(param1:FSPDParticleSystem) : void
      {
         if(param1)
         {
            param1.removeFromParent(true);
            if(param1.texture)
            {
               param1.texture.dispose();
            }
            Starling.juggler.remove(param1);
         }
         param1 = null;
      }
      
      public function unload() : void
      {
         if(this.mOnFadeOffCompleteFunction != null)
         {
            if(this.mOnFadeOffCompleteParams != null)
            {
               this.mOnFadeOffCompleteFunction.apply(null,this.mOnFadeOffCompleteParams);
            }
            else
            {
               this.mOnFadeOffCompleteFunction();
            }
         }
         visible = false;
         removeFromParent(true);
         if(this.mFirework1)
         {
            this.removeParticleSystemFromDL(this.mFirework1);
            this.mFirework1.removeFromParent(true);
            this.mFirework1 = null;
         }
         if(this.mFirework2)
         {
            this.removeParticleSystemFromDL(this.mFirework2);
            this.mFirework2.removeFromParent(true);
            this.mFirework2 = null;
         }
         if(this.mFirework3)
         {
            this.removeParticleSystemFromDL(this.mFirework3);
            this.mFirework3.removeFromParent(true);
            this.mFirework3 = null;
         }
         InstanceMng.getPopupMng().showFirstQueuedPopup();
      }
      
      override public function dispose() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         if(this.mChar)
         {
            this.mChar.removeFromParent();
            this.mChar.destroy();
            this.mChar = null;
         }
         if(this.mTextfield)
         {
            this.mTextfield.removeFromParent(true);
            this.mTextfield = null;
         }
         if(this.mBGAnimBar1)
         {
            this.mBGAnimBar1.removeFromParent(true);
            this.mBGAnimBar1 = null;
         }
         if(this.mBGAnimBar2)
         {
            this.mBGAnimBar2.removeFromParent(true);
            this.mBGAnimBar2 = null;
         }
         if(this.mBGAnimBar3)
         {
            this.mBGAnimBar3.removeFromParent(true);
            this.mBGAnimBar3 = null;
         }
         if(this.mBGAnimBar4)
         {
            this.mBGAnimBar4.removeFromParent(true);
            this.mBGAnimBar4 = null;
         }
         if(this.mFirework1)
         {
            this.mFirework1.removeFromParent();
            this.mFirework1 = null;
         }
         if(this.mFirework2)
         {
            this.mFirework2.removeFromParent();
            this.mFirework2 = null;
         }
         if(this.mFirework3)
         {
            this.mFirework3.removeFromParent();
            this.mFirework3 = null;
         }
         if(this.mSubBG)
         {
            this.mSubBG.removeFromParent();
            this.mSubBG.destroy();
            this.mSubBG = null;
         }
         if(this.mLevelUpEffect1)
         {
            this.mLevelUpEffect1.removeFromParent();
            this.mLevelUpEffect1.destroy();
            this.mLevelUpEffect1 = null;
         }
         if(this.mSparkleEffect1)
         {
            Starling.juggler.remove(this.mSparkleEffect1);
            this.mSparkleEffect1.removeFromParent();
            this.mSparkleEffect1 = null;
         }
         if(this.mSparkleEffect2)
         {
            Starling.juggler.remove(this.mSparkleEffect2);
            this.mSparkleEffect2.removeFromParent();
            this.mSparkleEffect2 = null;
         }
         this.mCharTextureRef = null;
         this.mOnFadeOffCompleteFunction = null;
         Utils.destroyArray(this.mOnFadeOffCompleteParams);
         this.mOnFadeOffCompleteParams = null;
         super.dispose();
      }
      
      public function isShown() : Boolean
      {
         return this.mIsShown;
      }
   }
}

