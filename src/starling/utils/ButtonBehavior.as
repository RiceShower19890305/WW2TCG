package starling.utils
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Mouse;
   import flash.ui.MouseCursor;
   import starling.display.ButtonState;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   
   public class ButtonBehavior
   {
      
      private static var sBounds:Rectangle = new Rectangle();
      
      private var _state:String;
      
      private var _target:DisplayObject;
      
      private var _triggerBounds:Rectangle;
      
      private var _minHitAreaSize:Number;
      
      private var _abortDistance:Number;
      
      private var _onStateChange:Function;
      
      private var _useHandCursor:Boolean;
      
      private var _enabled:Boolean;
      
      public function ButtonBehavior(param1:DisplayObject, param2:Function, param3:Number = 44, param4:Number = 50)
      {
         super();
         if(param1 == null)
         {
            throw new ArgumentError("target cannot be null");
         }
         if(param2 == null)
         {
            throw new ArgumentError("onStateChange cannot be null");
         }
         this._target = param1;
         this._target.addEventListener(TouchEvent.TOUCH,this.onTouch);
         this._onStateChange = param2;
         this._minHitAreaSize = param3;
         this._abortDistance = param4;
         this._triggerBounds = new Rectangle();
         this._state = ButtonState.UP;
         this._useHandCursor = true;
         this._enabled = true;
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc3_:Boolean = false;
         Mouse.cursor = this._useHandCursor && this._enabled && param1.interactsWith(this._target) ? MouseCursor.BUTTON : MouseCursor.AUTO;
         var _loc2_:Touch = param1.getTouch(this._target);
         if(this._enabled)
         {
            if(_loc2_ == null)
            {
               this.state = ButtonState.UP;
            }
            else if(_loc2_.phase == TouchPhase.HOVER)
            {
               this.state = ButtonState.OVER;
            }
            else if(_loc2_.phase == TouchPhase.BEGAN && this._state != ButtonState.DOWN)
            {
               this._triggerBounds = this._target.getBounds(this._target.stage,this._triggerBounds);
               this._triggerBounds.inflate(this._abortDistance,this._abortDistance);
               this.state = ButtonState.DOWN;
            }
            else if(_loc2_.phase == TouchPhase.MOVED)
            {
               _loc3_ = this._triggerBounds.contains(_loc2_.globalX,_loc2_.globalY);
               if(this._state == ButtonState.DOWN && !_loc3_)
               {
                  this.state = ButtonState.UP;
               }
               else if(this._state == ButtonState.UP && _loc3_)
               {
                  this.state = ButtonState.DOWN;
               }
            }
            else if(_loc2_.phase == TouchPhase.ENDED && this._state == ButtonState.DOWN)
            {
               this.state = ButtonState.UP;
               if(!_loc2_.cancelled)
               {
                  this._target.dispatchEventWith(Event.TRIGGERED,true);
               }
            }
         }
      }
      
      public function hitTest(param1:Point) : DisplayObject
      {
         if(!this._target.visible || !this._target.touchable || !this._target.hitTestMask(param1))
         {
            return null;
         }
         this._target.getBounds(this._target,sBounds);
         if(sBounds.width < this._minHitAreaSize)
         {
            sBounds.inflate((this._minHitAreaSize - sBounds.width) / 2,0);
         }
         if(sBounds.height < this._minHitAreaSize)
         {
            sBounds.inflate(0,(this._minHitAreaSize - sBounds.height) / 2);
         }
         if(sBounds.containsPoint(param1))
         {
            return this._target;
         }
         return null;
      }
      
      public function get state() : String
      {
         return this._state;
      }
      
      public function set state(param1:String) : void
      {
         if(this._state != param1)
         {
            if(!ButtonState.isValid(param1))
            {
               throw new ArgumentError("Invalid button state: " + param1);
            }
            this._state = param1;
            execute(this._onStateChange,param1);
         }
      }
      
      public function get target() : DisplayObject
      {
         return this._target;
      }
      
      public function get onStateChange() : Function
      {
         return this._onStateChange;
      }
      
      public function set onStateChange(param1:Function) : void
      {
         this._onStateChange = param1;
      }
      
      public function get useHandCursor() : Boolean
      {
         return this._useHandCursor;
      }
      
      public function set useHandCursor(param1:Boolean) : void
      {
         this._useHandCursor = param1;
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         if(this._enabled != param1)
         {
            this._enabled = param1;
            this.state = param1 ? ButtonState.UP : ButtonState.DISABLED;
         }
      }
      
      public function get minHitAreaSize() : Number
      {
         return this._minHitAreaSize;
      }
      
      public function set minHitAreaSize(param1:Number) : void
      {
         this._minHitAreaSize = param1;
      }
      
      public function get abortDistance() : Number
      {
         return this._abortDistance;
      }
      
      public function set abortDistance(param1:Number) : void
      {
         this._abortDistance = param1;
      }
   }
}

