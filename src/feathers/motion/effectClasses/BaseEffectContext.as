package feathers.motion.effectClasses
{
   import starling.animation.Juggler;
   import starling.animation.Transitions;
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.errors.AbstractClassError;
   import starling.events.Event;
   import starling.events.EventDispatcher;
   
   public class BaseEffectContext extends EventDispatcher implements IEffectContext
   {
      
      private static const MAX_POSITION:Number = 0.99999;
      
      protected var _target:DisplayObject;
      
      protected var _playTween:Tween = null;
      
      protected var _duration:Number;
      
      protected var _transition:Object = null;
      
      protected var _position:Number = 0;
      
      protected var _playing:Boolean = false;
      
      protected var _reversed:Boolean = false;
      
      protected var _juggler:Juggler = null;
      
      public function BaseEffectContext(param1:DisplayObject, param2:Number, param3:Object = null)
      {
         super();
         if(Object(this).constructor === BaseEffectContext)
         {
            throw new AbstractClassError();
         }
         this._target = param1;
         this._duration = param2;
         if(param3 === null)
         {
            param3 = Transitions.LINEAR;
         }
         this._transition = param3;
         this.prepareEffect();
      }
      
      public function get target() : DisplayObject
      {
         return this._target;
      }
      
      public function get duration() : Number
      {
         return this._duration;
      }
      
      public function get transition() : Object
      {
         return this._transition;
      }
      
      public function get juggler() : Juggler
      {
         return this._juggler;
      }
      
      public function set juggler(param1:Juggler) : void
      {
         if(this._juggler === param1)
         {
            return;
         }
         var _loc2_:Juggler = this._juggler;
         if(_loc2_ === null)
         {
            _loc2_ = Starling.juggler;
         }
         this._juggler = param1;
         if(this._playing && this._juggler !== _loc2_)
         {
            _loc2_.remove(this._playTween);
            if(this._juggler !== null)
            {
               this._juggler.add(this._playTween);
            }
            else
            {
               this._playing = false;
            }
         }
      }
      
      public function get position() : Number
      {
         return this._position;
      }
      
      public function set position(param1:Number) : void
      {
         if(param1 > MAX_POSITION)
         {
            param1 = MAX_POSITION;
         }
         this._position = param1;
         this.updateEffect();
      }
      
      public function play() : void
      {
         if(this._playing && !this._reversed)
         {
            return;
         }
         if(this._playTween !== null)
         {
            this._playTween.dispatchEventWith(Event.REMOVE_FROM_JUGGLER);
            this._playTween = null;
         }
         this._playing = true;
         this._reversed = false;
         var _loc1_:Number = this._duration * (1 - this._position);
         this._playTween = new Tween(this,_loc1_,this._transition);
         this._playTween.animate("position",1);
         this._playTween.onComplete = this.playTween_onComplete;
         var _loc2_:Juggler = this._juggler;
         if(_loc2_ === null)
         {
            _loc2_ = Starling.juggler;
         }
         _loc2_.add(this._playTween);
      }
      
      public function playReverse() : void
      {
         if(this._playing && this._reversed)
         {
            return;
         }
         if(this._playTween !== null)
         {
            this._playTween.dispatchEventWith(Event.REMOVE_FROM_JUGGLER);
            this._playTween = null;
         }
         this._playing = true;
         this._reversed = true;
         var _loc1_:Number = this._duration * this._position;
         this._playTween = new Tween(this,_loc1_,this._transition);
         this._playTween.animate("position",0);
         this._playTween.onComplete = this.playTween_onComplete;
         var _loc2_:Juggler = this._juggler;
         if(_loc2_ === null)
         {
            _loc2_ = Starling.juggler;
         }
         _loc2_.add(this._playTween);
      }
      
      public function pause() : void
      {
         if(!this._playing)
         {
            return;
         }
         if(this._playTween !== null)
         {
            this._playTween.dispatchEventWith(Event.REMOVE_FROM_JUGGLER);
            this._playTween = null;
         }
         this._playing = false;
      }
      
      public function stop() : void
      {
         this.pause();
         this.cleanupEffect();
         this.dispatchEventWith(Event.COMPLETE,false,true);
      }
      
      public function toEnd() : void
      {
         if(this._playing)
         {
            this._position = 1;
            this._playTween.advanceTime(this._playTween.totalTime);
            return;
         }
         this.position = 1;
         this.cleanupEffect();
         this.dispatchEventWith(Event.COMPLETE,false,false);
      }
      
      public function interrupt() : void
      {
         this.toEnd();
      }
      
      protected function prepareEffect() : void
      {
      }
      
      protected function updateEffect() : void
      {
      }
      
      protected function cleanupEffect() : void
      {
      }
      
      protected function playTween_onComplete() : void
      {
         this._playTween = null;
         this.cleanupEffect();
         this.dispatchEventWith(Event.COMPLETE,false,false);
      }
   }
}

