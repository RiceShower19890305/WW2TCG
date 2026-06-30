package feathers.motion.effectClasses
{
   import feathers.core.IFeathersControl;
   import feathers.motion.EffectInterruptBehavior;
   import starling.animation.Transitions;
   import starling.animation.Tween;
   import starling.display.DisplayObject;
   
   public class TweenEffectContext extends BaseEffectContext implements IEffectContext
   {
      
      protected var _tween:Tween = null;
      
      protected var _interruptBehavior:String = null;
      
      protected var _onStart:Function = null;
      
      protected var _onComplete:Function = null;
      
      public function TweenEffectContext(param1:DisplayObject, param2:Tween, param3:String = "end")
      {
         this._tween = param2;
         this._interruptBehavior = param3;
         var _loc4_:Function = Transitions.getTransition(Transitions.LINEAR);
         var _loc5_:Function = this._tween.transitionFunc;
         this._tween.transitionFunc = _loc4_;
         this._onStart = this._tween.onStart;
         this._onComplete = this._tween.onComplete;
         this._tween.onStart = null;
         this._tween.onComplete = null;
         if(param1 === null)
         {
            param1 = param2.target as DisplayObject;
         }
         super(param1,this._tween.totalTime + this._tween.delay,_loc5_);
      }
      
      public function get tween() : Tween
      {
         return this._tween;
      }
      
      public function get interruptBehavior() : String
      {
         return this._interruptBehavior;
      }
      
      public function set interruptBehavior(param1:String) : void
      {
         this._interruptBehavior = param1;
      }
      
      override public function interrupt() : void
      {
         if(this._interruptBehavior === EffectInterruptBehavior.STOP)
         {
            this.stop();
            return;
         }
         this.toEnd();
      }
      
      override protected function prepareEffect() : void
      {
         if(this._onStart !== null)
         {
            this._onStart.apply(null,this._tween.onStartArgs);
         }
      }
      
      override protected function updateEffect() : void
      {
         if(this._target is IFeathersControl)
         {
            IFeathersControl(this._target).suspendEffects();
         }
         var _loc1_:Number = this._tween.totalTime + this._tween.delay;
         var _loc2_:Number = this._position * _loc1_ - this._tween.delay;
         this._tween.advanceTime(_loc2_ - this._tween.currentTime);
         if(this._target is IFeathersControl)
         {
            IFeathersControl(this._target).resumeEffects();
         }
      }
      
      override protected function cleanupEffect() : void
      {
         if(this._onComplete !== null)
         {
            this._onComplete.apply(null,this._tween.onCompleteArgs);
         }
      }
   }
}

