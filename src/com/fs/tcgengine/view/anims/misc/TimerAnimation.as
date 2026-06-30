package com.fs.tcgengine.view.anims.misc
{
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.utils.TimerUtil;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   import starling.core.Starling;
   import starling.display.MovieClip;
   import starling.events.Event;
   import starling.textures.Texture;
   
   public class TimerAnimation extends Component implements FSModelUnloadableInterface
   {
      
      private var mTimerImageName:String;
      
      private var mTimerImageAnimationName:String;
      
      private var mTimerMCName:String;
      
      private var mTimerImage:FSImage;
      
      private var mTimerMC:MovieClip;
      
      private var mTotalTime:Number;
      
      private var mCurrentTime:Number;
      
      private var mUpdateTimeFunction:Function;
      
      private var mScale:Number = -1;
      
      public function TimerAnimation(param1:String, param2:String = null, param3:String = null, param4:Number = -1, param5:Number = -1)
      {
         super();
         this.mTimerImageName = param1;
         this.mTimerImageAnimationName = param2;
         this.mTimerMCName = param3;
         this.mTotalTime = param5;
         this.mCurrentTime = param4;
         this.init();
      }
      
      public function setUpdateTimeFunction(param1:Function) : void
      {
         this.mUpdateTimeFunction = param1;
      }
      
      private function init() : void
      {
         this.createUI();
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function createUI() : void
      {
         this.createTimerImage();
      }
      
      private function createTimerMC(param1:int = 0) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Vector.<Texture> = null;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         if(this.mTimerImage)
         {
            if(Boolean(this.mTimerImageAnimationName) && this.mTimerImageAnimationName != "")
            {
               this.mTimerImage.texture = Root.assets.getTexture(this.mTimerImageAnimationName);
            }
            _loc2_ = this.mCurrentTime < this.mTotalTime ? TimerUtil.msToSec(this.mCurrentTime) : TimerUtil.msToSec(this.mTotalTime);
            _loc3_ = TimerUtil.msToSec(this.mTotalTime);
            _loc4_ = Root.assets.getTextures(this.mTimerMCName + "_");
            _loc5_ = Number(_loc4_.length / _loc3_);
            _loc6_ = (1 - _loc2_ / _loc3_) * _loc4_.length;
            if(this.mTimerMC == null)
            {
               if(Boolean(_loc4_) && _loc4_.length > 0)
               {
                  _loc5_ = Number(_loc4_.length / _loc3_);
                  if(this.mTimerMC == null)
                  {
                     this.mTimerMC = new MovieClip(_loc4_,_loc5_);
                     if(this.mScale != -1)
                     {
                        this.mTimerMC.scale *= this.mScale;
                     }
                     this.mTimerMC.touchable = false;
                  }
                  Starling.juggler.add(this.mTimerMC);
                  this.mTimerMC.currentFrame = _loc6_ >= 0 && _loc6_ < this.mTimerMC.numFrames ? _loc6_ : 0;
                  this.mTimerMC.play();
                  this.mTimerMC.alignPivot();
                  this.mTimerMC.x = this.mTimerImage.x;
                  this.mTimerMC.y = this.mTimerImage.y;
                  addChild(this.mTimerMC);
               }
               else if(param1 < 3)
               {
                  TweenMax.delayedCall(0.1,this.createTimerMC,[param1 + 1]);
               }
            }
            else
            {
               this.mTimerMC.currentFrame = Math.min(_loc4_.length - 1,_loc6_);
               this.mTimerMC.fps = _loc5_;
               this.mTimerMC.play();
            }
         }
      }
      
      public function setCurrentTime(param1:Number) : void
      {
         this.mCurrentTime = param1;
         this.createTimerMC();
      }
      
      public function setTotalTime(param1:Number) : void
      {
         this.mTotalTime = param1;
         this.createTimerMC();
      }
      
      public function playTimerAnimation() : void
      {
         this.createTimerMC();
      }
      
      private function createTimerImage() : void
      {
         if(this.mTimerImage == null)
         {
            this.mTimerImage = new FSImage(Root.assets.getTexture(this.mTimerImageName));
            this.mTimerImage.alignPivot();
            addChild(this.mTimerImage);
         }
      }
      
      public function onEnterFrame(param1:Event) : void
      {
         if(this.mCurrentTime < this.mTotalTime)
         {
            if(Boolean(this.mTimerMCName) && this.mTimerMCName != "")
            {
               this.createTimerMC();
            }
         }
         if(this.mUpdateTimeFunction != null)
         {
            this.mCurrentTime = this.mUpdateTimeFunction();
         }
      }
      
      public function stopTimerAnimation() : void
      {
         if(this.mTimerMC)
         {
            removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            this.mTimerMC.stop();
            Starling.juggler.remove(this.mTimerMC);
            this.mTimerMC.removeFromParent();
            this.mTimerMC = null;
         }
      }
      
      public function scaleTimer(param1:Number) : void
      {
         this.mTimerImage.scale *= param1;
         this.mScale = param1;
      }
      
      override public function dispose() : void
      {
         this.destroy();
         super.dispose();
      }
      
      public function destroy() : void
      {
         if(this.mTimerImage)
         {
            this.mTimerImage.removeFromParent();
            this.mTimerImage = null;
         }
         if(this.mTimerMC)
         {
            this.mTimerMC.removeFromParent();
            this.mTimerMC = null;
         }
         this.mUpdateTimeFunction = null;
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      public function isActive() : Boolean
      {
         if(this.mTimerMC)
         {
            return this.mTimerMC.isPlaying;
         }
         return false;
      }
   }
}

