package com.fs.tcgengine.view.anims.cards
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.model.rules.FactionDef;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   import com.greensock.easing.Quad;
   import starling.core.Starling;
   
   public class CardShiningPromoteAnimation extends CardAnimation
   {
      
      public static const EXTRA_IMAGE_NAME:String = "explosion_anim_tank";
      
      public static const SHINE1_IMG:String = "shine1";
      
      public static const SHINE2_IMG:String = "shine2";
      
      private var mAnimKey:String;
      
      private var mShine1:FSImage;
      
      private var mShine2:FSImage;
      
      public function CardShiningPromoteAnimation()
      {
         super();
      }
      
      override public function init() : void
      {
         super.init();
         Utils.requestScreenShake(Config.getConfig().getDefaultPromoteAnimDuration(),1.5);
         if(Root.assets.getTexture(SHINE1_IMG))
         {
            this.createShine1();
            this.createShine2();
         }
      }
      
      private function createShine1() : void
      {
         if(this.mShine1 == null)
         {
            this.mShine1 = new FSImage(Root.assets.getTexture(SHINE1_IMG));
            this.mShine1.alignPivot();
            this.mShine1.x = mAttachedToComponent.x;
            this.mShine1.y = mAttachedToComponent.y;
            this.mShine1.alpha = 0.999;
            InstanceMng.getCurrentScreen().addChild(this.mShine1);
            TweenMax.fromTo(this.mShine1,CardAnimation.getMaxDuration(),{
               "alpha":0.999,
               "scaleX":0.5,
               "scaleY":0.5
            },{
               "alpha":0.0001,
               "scaleX":0.85,
               "scaleY":0.85,
               "onComplete":removeExtraGraphicsOnComponent
            });
         }
      }
      
      private function createShine2() : void
      {
         if(this.mShine2 == null)
         {
            this.mShine2 = new FSImage(Root.assets.getTexture(SHINE1_IMG));
            this.mShine2.alignPivot();
            this.mShine2.x = mAttachedToComponent.x;
            this.mShine2.y = mAttachedToComponent.y;
            this.mShine2.alpha = 0.999;
            InstanceMng.getCurrentScreen().addChild(this.mShine2);
            TweenMax.fromTo(this.mShine2,CardAnimation.getMaxDuration() * 3,{
               "alpha":0.999,
               "scaleX":0.5,
               "scaleY":0.5
            },{
               "alpha":0.0001,
               "scaleX":0.85,
               "scaleY":0.85
            });
         }
      }
      
      override protected function triggerExtraGraphicsTweening() : void
      {
         if(mAttachedToComponent != null && mExtraGraphics != null)
         {
            if(!contains(mExtraGraphics))
            {
               mExtraGraphics.alignPivot();
               mExtraGraphics.x = mAttachedToComponent.x;
               mExtraGraphics.y = mAttachedToComponent.y;
               mExtraGraphics.alpha = 0.001;
               InstanceMng.getCurrentScreen().addChild(mExtraGraphics);
               TweenMax.fromTo(mExtraGraphics,CardAnimation.getMaxDuration() / 2,{
                  "alpha":0,
                  "scaleX":0.5,
                  "scaleY":0.5
               },{
                  "alpha":1,
                  "scaleX":0.85,
                  "scaleY":0.85,
                  "onComplete":removeExtraGraphicsOnComponent
               });
               SpecialFX.tweenRotate(mExtraGraphics,CardAnimation.getMaxDuration(),0,Quad.easeOut,25);
            }
         }
      }
      
      override protected function triggerParticleSystem() : void
      {
         if(mParticleSystem != null)
         {
            mParticleSystem.x = mExtraGraphics ? mExtraGraphics.x : Number(mAttachedToComponent.x);
            mParticleSystem.y = mExtraGraphics ? mExtraGraphics.y : Number(mAttachedToComponent.y);
            this.setParticleSystemProps();
            InstanceMng.getCurrentScreen().addChild(mParticleSystem);
            Starling.juggler.add(mParticleSystem);
            mParticleSystem.start(0.5);
         }
         TweenMax.delayedCall(CardAnimation.getMaxDuration() * 2,this.unload);
      }
      
      private function setParticleSystemProps() : void
      {
         var _loc1_:FactionDef = FactionDef(InstanceMng.getFactionsDefMng().getDefBySku(FSCard(mAttachedToComponent).getCardDef().getFactionSku()));
         if(_loc1_)
         {
            InstanceMng.getResourcesMng().morphParticleSystemProps(mParticleSystem,_loc1_.getIndex());
         }
         this.decreasemaxRadius();
      }
      
      private function decreasemaxRadius() : void
      {
         if(Boolean(mParticleSystem) && mParticleSystem.maxRadius < 120)
         {
            mParticleSystem.maxRadius += 1;
            TweenMax.delayedCall(0.003,this.decreasemaxRadius);
         }
      }
      
      override public function unload(param1:Boolean = false) : void
      {
         if(this.mShine1)
         {
            this.mShine1.removeFromParent();
            this.mShine1.destroy();
            this.mShine1 = null;
         }
         if(this.mShine2)
         {
            this.mShine2.removeFromParent();
            this.mShine2.destroy();
            this.mShine2 = null;
         }
         super.unload(param1);
      }
   }
}

