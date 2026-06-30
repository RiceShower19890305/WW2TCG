package com.fs.tcgengine.view.components
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.particles.FSPDParticleSystem;
   import com.fs.tcgengine.resources.AssetsParticles;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import feathers.controls.Callout;
   import feathers.controls.ScrollContainer;
   import feathers.controls.supportClasses.LayoutViewPort;
   import mx.utils.StringUtil;
   import starling.core.Starling;
   import starling.display.Quad;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.extensions.ColorArgb;
   
   public class Component extends FSSprite3D
   {
      
      private const TWEEN_FX_SPEED:Number = 0.5;
      
      private var mBoundsQuad:Quad;
      
      protected var mCurrentTween:TweenMax;
      
      protected var mHighlightParticleSystem:FSPDParticleSystem;
      
      protected var mHighlightRequested:Boolean = false;
      
      private var mTooltip:Callout;
      
      private var mTooltipText:String;
      
      public function Component()
      {
         super();
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         this.drawBounds();
      }
      
      override public function set width(param1:Number) : void
      {
         super.width = param1;
         if(this.mBoundsQuad)
         {
            this.mBoundsQuad.width = param1;
         }
      }
      
      override public function set height(param1:Number) : void
      {
         super.height = param1;
         if(this.mBoundsQuad)
         {
            this.mBoundsQuad.height = param1;
         }
      }
      
      override public function set x(param1:Number) : void
      {
         super.x = param1;
         if(this.mBoundsQuad)
         {
            this.mBoundsQuad.x = param1;
         }
      }
      
      override public function set y(param1:Number) : void
      {
         super.y = param1;
         if(this.mBoundsQuad)
         {
            this.mBoundsQuad.y = param1;
         }
      }
      
      override public function set scaleX(param1:Number) : void
      {
         super.scaleX = param1;
         if(this.mBoundsQuad)
         {
            this.mBoundsQuad.scaleX = param1;
         }
      }
      
      override public function set scaleY(param1:Number) : void
      {
         super.scaleY = param1;
         if(this.mBoundsQuad)
         {
            this.mBoundsQuad.scaleY = param1;
         }
      }
      
      public function getVisualComponentCoords() : FSCoordinate
      {
         return new FSCoordinate(x,y);
      }
      
      public function drawBounds(param1:Boolean = true) : void
      {
         var _loc2_:uint = Math.random() * 16777215;
         if(this.mBoundsQuad == null)
         {
            this.mBoundsQuad = Utils.getObjectBoundsQuad(this,_loc2_);
            this.mBoundsQuad.alignPivot();
            this.mBoundsQuad.touchable = false;
         }
         if(param1)
         {
            if(!contains(this.mBoundsQuad))
            {
               InstanceMng.getCurrentScreen().addChild(this.mBoundsQuad);
            }
         }
         else if(contains(this.mBoundsQuad))
         {
            this.mBoundsQuad.removeFromParent();
         }
         if(this.mBoundsQuad)
         {
            this.mBoundsQuad.x = x;
            this.mBoundsQuad.y = y;
            this.mBoundsQuad.scaleX = scaleX;
            this.mBoundsQuad.scaleY = scaleY;
            this.mBoundsQuad.width = width;
            this.mBoundsQuad.height = height;
         }
      }
      
      public function setTooltipText(param1:String) : void
      {
         this.mTooltipText = param1 != null && param1 != "" ? StringUtil.trim(param1) : "";
         if(this.mTooltipText != "" && this.mTooltipText != null)
         {
            addEventListener(TouchEvent.TOUCH,this.onTouch);
         }
         else if(hasEventListener(TouchEvent.TOUCH))
         {
            removeEventListener(TouchEvent.TOUCH,this.onTouch);
         }
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this);
         var _loc3_:Boolean = !Utils.isDesktop() && param1.getTouch(this,TouchPhase.MOVED) == null || Utils.isDesktop() && Boolean(param1.getTouch(this,TouchPhase.HOVER));
         if(Boolean(_loc2_) && _loc3_)
         {
            this.showTooltip();
         }
         else
         {
            this.closeTooltip();
         }
      }
      
      private function showTooltip() : void
      {
         if(this.mTooltip == null && this.mTooltipText != "" && this.mTooltipText != null && stage != null)
         {
            if(parent)
            {
               FSDebug.debugTrace("parent: " + parent);
               if(parent is LayoutViewPort && parent.parent != null)
               {
                  FSDebug.debugTrace("is scrolling? " + ScrollContainer(parent.parent).isScrolling);
               }
            }
            if(parent != null && parent is LayoutViewPort && parent.parent is ScrollContainer && ScrollContainer(parent.parent).isScrolling)
            {
               return;
            }
            this.mTooltip = Callout.show(Utils.getTooltipContent(this.mTooltipText),this,null,false);
            this.mTooltip.closeOnTouchEndedOutside = true;
            this.mTooltip.closeOnTouchBeganOutside = true;
            this.mTooltip.disposeContent = false;
            this.mTooltip.maxWidth = Starling.current.stage.stageWidth / 3;
            this.mTooltip.touchable = false;
            this.mTooltip.alpha = 0.001;
            SpecialFX.tweenToAlpha(this.mTooltip,0.999,0.25,0);
         }
         else if(Utils.isMobile())
         {
            if(Boolean(this.mTooltip) && this.mTooltip.parent == null)
            {
               this.removeTooltip();
               this.showTooltip();
            }
         }
      }
      
      public function closeTooltip() : void
      {
         if(this.mTooltip)
         {
            SpecialFX.tweenToAlpha(this.mTooltip,0.001,0.25,0,this.removeTooltip);
         }
      }
      
      private function removeTooltip() : void
      {
         if(this.mTooltip)
         {
            this.mTooltip.close();
            this.mTooltip.removeFromParent(true);
            this.mTooltip = null;
         }
      }
      
      override public function dispose() : void
      {
         FSDebug.debugTrace("Disposing: " + this);
         if(this.mTooltip)
         {
            this.mTooltip.removeFromParent(true);
         }
         this.mTooltip = null;
         if(this.mBoundsQuad)
         {
            this.mBoundsQuad.removeFromParent(true);
            this.mBoundsQuad = null;
         }
         this.deactivateHighlightTween();
         this.removeCustomEventListeners();
         TweenMax.killTweensOf(this);
         this.removeParticleSystem(true);
         removeChildren(0,-1,true);
         removeFromParent();
         this.removeTooltip();
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
         super.dispose();
      }
      
      protected function removeCustomEventListeners() : void
      {
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
      }
      
      public function activateHighlightTween(param1:uint = 65280, param2:Boolean = true, param3:Number = 1, param4:ColorArgb = null, param5:ColorArgb = null, param6:Boolean = false) : void
      {
         this.mCurrentTween = SpecialFX.tweenToColor(this,1,param1);
      }
      
      public function deactivateHighlightTween(param1:Boolean = false) : void
      {
         if(this.mCurrentTween != null)
         {
            this.mCurrentTween.progress(0);
            this.mCurrentTween.kill();
            this.mCurrentTween = null;
         }
      }
      
      private function resetFilter() : void
      {
         if(filter)
         {
            filter.dispose();
            filter = null;
         }
      }
      
      public function isSpecialHighlightingOn() : Boolean
      {
         return this.mHighlightParticleSystem != null;
      }
      
      public function activateSpecialHighlightParticle(param1:ColorArgb = null, param2:ColorArgb = null) : void
      {
         if(this.mHighlightParticleSystem == null)
         {
            this.mHighlightParticleSystem = AssetsParticles.requestParticleSystem("card_highlight");
         }
         if(param1 != null && param2 != null)
         {
            this.mHighlightParticleSystem.startColor = param1;
            this.mHighlightParticleSystem.endColor = param2;
         }
         this.mHighlightParticleSystem.alpha = 0.001;
         SpecialFX.tweenHighlightSocketToAlpha(this.mHighlightParticleSystem,1,0.5);
         this.mHighlightParticleSystem.x = 0;
         this.mHighlightParticleSystem.y = 0;
         addChild(this.mHighlightParticleSystem);
         Starling.juggler.add(this.mHighlightParticleSystem);
         this.mHighlightParticleSystem.start();
         this.tweenParticlePart1();
      }
      
      protected function tweenParticlePart1(param1:Number = -1, param2:Number = -1, param3:Boolean = true) : void
      {
         var _loc4_:Number = NaN;
         if(this.mHighlightParticleSystem)
         {
            param1 = param1 != -1 ? param1 : width;
            param2 = param2 != -1 ? param2 : height;
            _loc4_ = Starling.current.contentScaleFactor;
            if(Utils.isDesktop() || Utils.isBrowser())
            {
               this.mHighlightParticleSystem.scale = 1 / _loc4_;
            }
            if((Utils.isAndroidOrDesktop() || Utils.isBrowser()) && param3)
            {
               param1 *= _loc4_;
               param2 *= _loc4_;
            }
            TweenMax.fromTo(this.mHighlightParticleSystem,this.TWEEN_FX_SPEED,{
               "emitterX":0,
               "emitterY":0
            },{
               "emitterX":param1,
               "emitterY":0,
               "onComplete":this.tweenParticlePart2,
               "onCompleteParams":[param1,param2],
               "ease":Linear.easeNone
            });
         }
      }
      
      protected function tweenParticlePart2(param1:Number = -1, param2:Number = -1) : void
      {
         if(this.mHighlightParticleSystem)
         {
            param1 = param1 != -1 ? param1 : width;
            param2 = param2 != -1 ? param2 : height;
            TweenMax.fromTo(this.mHighlightParticleSystem,this.TWEEN_FX_SPEED,{
               "emitterX":param1,
               "emitterY":0
            },{
               "emitterX":param1,
               "emitterY":param2,
               "onComplete":this.tweenParticlePart3,
               "onCompleteParams":[param1,param2],
               "ease":Linear.easeNone
            });
         }
      }
      
      protected function tweenParticlePart3(param1:Number = -1, param2:Number = -1) : void
      {
         if(this.mHighlightParticleSystem)
         {
            param1 = param1 != -1 ? param1 : width;
            param2 = param2 != -1 ? param2 : height;
            TweenMax.fromTo(this.mHighlightParticleSystem,this.TWEEN_FX_SPEED,{
               "emitterX":param1,
               "emitterY":param2
            },{
               "emitterX":0,
               "emitterY":param2,
               "onComplete":this.tweenParticlePart4,
               "onCompleteParams":[param1,param2],
               "ease":Linear.easeNone
            });
         }
      }
      
      protected function tweenParticlePart4(param1:Number = -1, param2:Number = -1) : void
      {
         if(this.mHighlightParticleSystem)
         {
            param1 = param1 != -1 ? param1 : width;
            param2 = param2 != -1 ? param2 : height;
            TweenMax.fromTo(this.mHighlightParticleSystem,this.TWEEN_FX_SPEED,{
               "emitterX":0,
               "emitterY":param2
            },{
               "emitterX":0,
               "emitterY":0,
               "onComplete":this.tweenParticlePart1,
               "onCompleteParams":[param1,param2,false],
               "ease":Linear.easeNone
            });
         }
      }
      
      public function deactivateSpecialHighlightParticle() : void
      {
         if(Boolean(this.mHighlightParticleSystem) && !this.mHighlightRequested)
         {
            SpecialFX.tweenHighlightSocketToAlpha(this.mHighlightParticleSystem,0,0.5,this.removeParticleSystem,[true]);
         }
      }
      
      protected function removeParticleSystem(param1:Boolean = false) : void
      {
         if(Boolean(this.mHighlightParticleSystem) && !this.mHighlightRequested)
         {
            this.mHighlightParticleSystem.stop();
            this.mHighlightParticleSystem.removeFromParent(param1);
            Starling.juggler.remove(this.mHighlightParticleSystem);
            TweenMax.killTweensOf(this.tweenParticlePart1);
            TweenMax.killTweensOf(this.tweenParticlePart2);
            TweenMax.killTweensOf(this.tweenParticlePart3);
            TweenMax.killTweensOf(this.tweenParticlePart4);
            this.mHighlightParticleSystem = null;
         }
      }
   }
}

