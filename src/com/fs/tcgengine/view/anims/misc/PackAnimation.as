package com.fs.tcgengine.view.anims.misc
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.particles.FSPDParticleSystem;
   import com.fs.tcgengine.resources.AssetsParticles;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   import com.greensock.easing.Back;
   import starling.core.Starling;
   
   public class PackAnimation extends Component implements FSModelUnloadableInterface
   {
      
      private var mPackBottom:FSImage;
      
      private var mPackClosed:FSImage;
      
      private var mPackOpen:FSImage;
      
      private var mChestBG:String;
      
      private var mSpecialEffect:FSImage;
      
      private var mParticleFX:FSPDParticleSystem;
      
      public function PackAnimation(param1:String)
      {
         super();
         this.restart(param1);
      }
      
      public function restart(param1:String) : void
      {
         this.mChestBG = param1;
         this.createUI();
         touchable = false;
         if(this.mPackOpen)
         {
            addChild(this.mPackOpen);
         }
         if(this.mPackBottom)
         {
            addChild(this.mPackBottom);
         }
         if(this.mPackClosed)
         {
            addChild(this.mPackClosed);
         }
      }
      
      private function createUI() : void
      {
         if(this.mChestBG)
         {
            this.createBottom();
            this.createTopOpen();
            this.createTopClosed();
         }
      }
      
      private function createBottom() : void
      {
         if(this.mPackBottom == null)
         {
            this.mPackBottom = new FSImage(Root.assets.getTexture(this.mChestBG + "_anim_01"));
         }
         else
         {
            this.mPackBottom.texture = Root.assets.getTexture(this.mChestBG + "_anim_01");
         }
         this.mPackBottom.scale = 1.3;
         this.mPackBottom.alignPivot();
         this.mPackBottom.alpha = 1;
         this.mPackBottom.x = 0;
         addChild(this.mPackBottom);
      }
      
      private function createTopOpen() : void
      {
         if(this.mPackOpen == null)
         {
            this.mPackOpen = new FSImage(Root.assets.getTexture(this.mChestBG + "_anim_03"));
         }
         else
         {
            this.mPackOpen.texture = Root.assets.getTexture(this.mChestBG + "_anim_03");
         }
         this.mPackOpen.scale = 1.3;
         this.mPackOpen.y = this.mPackBottom.y - this.mPackOpen.height / 2.75;
         this.mPackOpen.alignPivot();
         addChildAt(this.mPackOpen,getChildIndex(this.mPackBottom));
      }
      
      private function createTopClosed() : void
      {
         if(this.mPackClosed == null)
         {
            this.mPackClosed = new FSImage(Root.assets.getTexture(this.mChestBG + "_anim_02"));
         }
         else
         {
            this.mPackClosed.texture = Root.assets.getTexture(this.mChestBG + "_anim_02");
         }
         this.mPackClosed.scale = 1.3;
         this.mPackClosed.y = this.mPackBottom.y - this.mPackClosed.height * 0.7;
         this.mPackClosed.alignPivot();
         addChild(this.mPackClosed);
      }
      
      public function performOpeningAnimation(param1:Function = null, param2:Array = null) : void
      {
         var _loc3_:Number = 0.65;
         var _loc4_:Number = 0.5 * _loc3_;
         var _loc5_:Number = 0.6 * _loc3_;
         var _loc6_:Number = 0.3 * _loc3_;
         var _loc7_:Number = 0.85 * _loc3_;
         if(Boolean(this.mPackClosed) && Boolean(this.mPackOpen))
         {
            Utils.playSound(Constants.SOUND_UNFOLD_PACK,SoundManager.TYPE_SFX);
            this.performHighlightFX();
            TweenMax.to(this.mPackClosed,_loc4_,{
               "delay":_loc5_ / 3.25,
               "alpha":0
            });
            TweenMax.to(this.mPackClosed,_loc5_,{
               "y":-this.mPackClosed.height,
               "scaleY":0.5
            });
            TweenMax.to(this.mPackOpen,_loc6_,{"scale":1.3});
            TweenMax.to(this.mPackOpen,_loc7_,{
               "ease":Back.easeOut,
               "y":-this.mPackClosed.height * 0.82,
               "onComplete":param1,
               "onCompleteParams":param2
            });
         }
      }
      
      private function createSpecialFX() : void
      {
         if(this.mSpecialEffect == null)
         {
            this.mSpecialEffect = new FSImage(Root.assets.getTexture("job_effect_1"));
            this.mSpecialEffect.scale = 5;
            this.mSpecialEffect.alignPivot();
         }
         this.mSpecialEffect.visible = false;
      }
      
      private function performHighlightFX() : void
      {
         var _loc1_:Number = NaN;
         this.createSpecialFX();
         this.createParticleSystem();
         if(this.mSpecialEffect)
         {
            this.mSpecialEffect.visible = true;
            _loc1_ = this.mSpecialEffect.scale;
            this.mSpecialEffect.scale = 0.1;
            addChild(this.mSpecialEffect);
            SpecialFX.createZoomAlphaTween(this.mSpecialEffect,1,0.999,0.001,0.1,_loc1_ * 1.6,null,this.onTransitionEnd);
            SpecialFX.createRotation(this.mSpecialEffect,360);
         }
      }
      
      private function onTransitionEnd() : void
      {
         if(this.mSpecialEffect)
         {
            this.mSpecialEffect.removeFromParent();
            this.mSpecialEffect.destroy();
            this.mSpecialEffect = null;
         }
      }
      
      private function createParticleSystem() : void
      {
         if(!Utils.isLowPerformanceDevice())
         {
            if(this.mParticleFX == null)
            {
               this.mParticleFX = AssetsParticles.requestParticleSystem("pack_unfold");
            }
            this.mParticleFX.emitterY = -this.mPackBottom.height / 3;
            this.mParticleFX.emitterXVariance = this.mPackBottom.width * 0.35;
            this.mParticleFX.alpha = 1;
            addChild(this.mParticleFX);
            Starling.juggler.add(this.mParticleFX);
            this.mParticleFX.start();
         }
      }
      
      public function fadeParticles() : void
      {
         if(this.mParticleFX)
         {
            SpecialFX.tweenToAlpha(this.mParticleFX,0,2,0,this.removeParticleSystemFromParent);
         }
      }
      
      private function removeParticleSystemFromParent() : void
      {
         if(this.mParticleFX)
         {
            this.mParticleFX.stop();
            this.mParticleFX.removeFromParent(true);
            Starling.juggler.remove(this.mParticleFX);
            this.mParticleFX = null;
         }
      }
      
      override public function dispose() : void
      {
         if(this.mPackBottom)
         {
            this.mPackBottom.removeFromParent(true);
            this.mPackBottom = null;
         }
         if(this.mPackClosed)
         {
            this.mPackClosed.removeFromParent(true);
            this.mPackClosed = null;
         }
         if(this.mPackOpen)
         {
            this.mPackOpen.removeFromParent(true);
            this.mPackOpen = null;
         }
         if(this.mSpecialEffect)
         {
            this.mSpecialEffect.removeFromParent(true);
            this.mSpecialEffect = null;
         }
         this.removeParticleSystemFromParent();
         super.dispose();
      }
      
      public function destroy() : void
      {
         if(this.mPackBottom)
         {
            this.mPackBottom.removeFromParent();
            this.mPackBottom.destroy();
            this.mPackBottom = null;
         }
         if(this.mPackClosed)
         {
            this.mPackClosed.removeFromParent();
            this.mPackClosed.destroy();
            this.mPackClosed = null;
         }
         if(this.mPackOpen)
         {
            this.mPackOpen.removeFromParent();
            this.mPackOpen.destroy();
            this.mPackOpen = null;
         }
         if(this.mSpecialEffect)
         {
            this.mSpecialEffect.removeFromParent();
            this.mSpecialEffect.destroy();
            this.mSpecialEffect = null;
         }
         this.removeParticleSystemFromParent();
      }
   }
}

