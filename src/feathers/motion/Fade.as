package feathers.motion
{
   import feathers.core.IFeathersControl;
   import feathers.motion.effectClasses.IEffectContext;
   import feathers.motion.effectClasses.TweenEffectContext;
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   
   public class Fade
   {
      
      protected static const SCREEN_REQUIRED_ERROR:String = "Cannot transition if both old screen and new screen are null.";
      
      public function Fade()
      {
         super();
      }
      
      public static function createFadeInEffect(param1:Number = 0.25, param2:Object = "easeOut", param3:String = "end") : Function
      {
         return createFadeBetweenEffect(0,1,param1,param2,param3);
      }
      
      public static function createFadeOutEffect(param1:Number = 0.25, param2:Object = "easeOut", param3:String = "end") : Function
      {
         return createFadeBetweenEffect(1,0,param1,param2,param3);
      }
      
      public static function createFadeToEffect(param1:Number, param2:Number = 0.25, param3:Object = "easeOut", param4:String = "end") : Function
      {
         var endAlpha:Number = param1;
         var duration:Number = param2;
         var ease:Object = param3;
         var interruptBehavior:String = param4;
         return function(param1:DisplayObject):IEffectContext
         {
            var _loc2_:* = new Tween(param1,duration,ease);
            _loc2_.fadeTo(endAlpha);
            var _loc3_:* = new TweenEffectContext(param1,_loc2_);
            _loc3_.interruptBehavior = interruptBehavior;
            return _loc3_;
         };
      }
      
      public static function createFadeFromEffect(param1:Number, param2:Number = 0.25, param3:Object = "easeOut", param4:String = "end") : Function
      {
         var startAlpha:Number = param1;
         var duration:Number = param2;
         var ease:Object = param3;
         var interruptBehavior:String = param4;
         return function(param1:DisplayObject):IEffectContext
         {
            var _loc2_:* = param1.alpha;
            if(param1 is IFeathersControl)
            {
               IFeathersControl(param1).suspendEffects();
            }
            param1.alpha = startAlpha;
            if(param1 is IFeathersControl)
            {
               IFeathersControl(param1).resumeEffects();
            }
            var _loc3_:* = new Tween(param1,duration,ease);
            _loc3_.fadeTo(_loc2_);
            var _loc4_:* = new TweenEffectContext(param1,_loc3_);
            _loc4_.interruptBehavior = interruptBehavior;
            return _loc4_;
         };
      }
      
      public static function createFadeBetweenEffect(param1:Number, param2:Number, param3:Number = 0.25, param4:Object = "easeOut", param5:String = "end") : Function
      {
         var startAlpha:Number = param1;
         var endAlpha:Number = param2;
         var duration:Number = param3;
         var ease:Object = param4;
         var interruptBehavior:String = param5;
         return function(param1:DisplayObject):IEffectContext
         {
            if(param1 is IFeathersControl)
            {
               IFeathersControl(param1).suspendEffects();
            }
            param1.alpha = startAlpha;
            if(param1 is IFeathersControl)
            {
               IFeathersControl(param1).resumeEffects();
            }
            var _loc2_:* = new Tween(param1,duration,ease);
            _loc2_.fadeTo(endAlpha);
            var _loc3_:* = new TweenEffectContext(param1,_loc2_);
            _loc3_.interruptBehavior = interruptBehavior;
            return _loc3_;
         };
      }
      
      public static function createFadeInTransition(param1:Number = 0.5, param2:Object = "easeOut", param3:Object = null) : Function
      {
         var duration:Number = param1;
         var ease:Object = param2;
         var tweenProperties:Object = param3;
         return function(param1:DisplayObject, param2:DisplayObject, param3:Function, param4:Boolean = false):IEffectContext
         {
            var _loc5_:* = undefined;
            var _loc6_:* = undefined;
            if(!param1 && !param2)
            {
               throw new ArgumentError(SCREEN_REQUIRED_ERROR);
            }
            if(param2)
            {
               param2.alpha = 0;
               _loc5_ = param2.parent;
               _loc5_.setChildIndex(param2,_loc5_.numChildren - 1);
               if(param1)
               {
                  param1.alpha = 1;
               }
               _loc6_ = new FadeTween(param2,param1,duration,ease,param3,tweenProperties);
            }
            else
            {
               param1.alpha = 1;
               _loc6_ = new FadeTween(param1,null,duration,ease,param3,tweenProperties);
            }
            if(param4)
            {
               return new TweenEffectContext(null,_loc6_);
            }
            Starling.juggler.add(_loc6_);
            return null;
         };
      }
      
      public static function createFadeOutTransition(param1:Number = 0.5, param2:Object = "easeOut", param3:Object = null) : Function
      {
         var duration:Number = param1;
         var ease:Object = param2;
         var tweenProperties:Object = param3;
         return function(param1:DisplayObject, param2:DisplayObject, param3:Function, param4:Boolean = false):IEffectContext
         {
            var _loc5_:* = undefined;
            var _loc6_:* = undefined;
            if(!param1 && !param2)
            {
               throw new ArgumentError(SCREEN_REQUIRED_ERROR);
            }
            if(param1)
            {
               _loc5_ = param1.parent;
               _loc5_.setChildIndex(param1,_loc5_.numChildren - 1);
               param1.alpha = 1;
               if(param2)
               {
                  param2.alpha = 1;
               }
               _loc6_ = new FadeTween(param1,null,duration,ease,param3,tweenProperties);
            }
            else
            {
               param2.alpha = 0;
               _loc6_ = new FadeTween(param2,null,duration,ease,param3,tweenProperties);
            }
            if(param4)
            {
               return new TweenEffectContext(null,_loc6_);
            }
            Starling.juggler.add(_loc6_);
            return null;
         };
      }
      
      public static function createCrossfadeTransition(param1:Number = 0.5, param2:Object = "easeOut", param3:Object = null) : Function
      {
         var duration:Number = param1;
         var ease:Object = param2;
         var tweenProperties:Object = param3;
         return function(param1:DisplayObject, param2:DisplayObject, param3:Function, param4:Boolean = false):IEffectContext
         {
            var _loc5_:* = undefined;
            if(!param1 && !param2)
            {
               throw new ArgumentError(SCREEN_REQUIRED_ERROR);
            }
            if(param2)
            {
               param2.alpha = 0;
               if(param1)
               {
                  param1.alpha = 1;
               }
               _loc5_ = new FadeTween(param2,param1,duration,ease,param3,tweenProperties);
            }
            else
            {
               param1.alpha = 1;
               _loc5_ = new FadeTween(param1,null,duration,ease,param3,tweenProperties);
            }
            if(param4)
            {
               return new TweenEffectContext(null,_loc5_);
            }
            Starling.juggler.add(_loc5_);
            return null;
         };
      }
   }
}

import starling.animation.Tween;
import starling.display.DisplayObject;

class FadeTween extends Tween
{
   
   private var _otherTarget:DisplayObject;
   
   private var _onCompleteCallback:Function;
   
   public function FadeTween(param1:DisplayObject, param2:DisplayObject, param3:Number, param4:Object, param5:Function, param6:Object)
   {
      var _loc7_:String = null;
      super(param1,param3,param4);
      if(param1.alpha == 0)
      {
         this.fadeTo(1);
      }
      else
      {
         this.fadeTo(0);
      }
      if(param6)
      {
         for(_loc7_ in param6)
         {
            this[_loc7_] = param6[_loc7_];
         }
      }
      if(param2)
      {
         this._otherTarget = param2;
         this.onUpdate = this.updateOtherTarget;
      }
      this._onCompleteCallback = param5;
      this.onComplete = this.cleanupTween;
   }
   
   private function updateOtherTarget() : void
   {
      var _loc1_:DisplayObject = DisplayObject(this.target);
      this._otherTarget.alpha = 1 - _loc1_.alpha;
   }
   
   private function cleanupTween() : void
   {
      this.target.alpha = 1;
      if(this._otherTarget)
      {
         this._otherTarget.alpha = 1;
      }
      if(this._onCompleteCallback !== null)
      {
         this._onCompleteCallback();
      }
   }
}
