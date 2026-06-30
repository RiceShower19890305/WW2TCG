package feathers.utils.touch
{
   import feathers.events.FeathersEventType;
   import flash.geom.Point;
   import flash.utils.getTimer;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.display.Stage;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Pool;
   
   public class LongPress
   {
      
      protected var _target:DisplayObject;
      
      protected var _longPressDuration:Number = 0.5;
      
      protected var _touchPointID:int = -1;
      
      protected var _touchLastGlobalPosition:Point = new Point();
      
      protected var _touchBeginTime:int;
      
      protected var _isEnabled:Boolean = true;
      
      protected var _tapToTrigger:TapToTrigger;
      
      protected var _tapToSelect:TapToSelect;
      
      protected var _customHitTest:Function;
      
      public function LongPress(param1:DisplayObject = null)
      {
         super();
         this.target = param1;
      }
      
      public function get target() : DisplayObject
      {
         return this._target;
      }
      
      public function set target(param1:DisplayObject) : void
      {
         if(this._target == param1)
         {
            return;
         }
         if(this._target)
         {
            this._target.removeEventListener(TouchEvent.TOUCH,this.target_touchHandler);
            this._target.removeEventListener(Event.ENTER_FRAME,this.target_enterFrameHandler);
         }
         this._target = param1;
         if(this._target)
         {
            this._touchPointID = -1;
            this._target.addEventListener(TouchEvent.TOUCH,this.target_touchHandler);
         }
      }
      
      public function get longPressDuration() : Number
      {
         return this._longPressDuration;
      }
      
      public function set longPressDuration(param1:Number) : void
      {
         this._longPressDuration = param1;
      }
      
      public function get isEnabled() : Boolean
      {
         return this._isEnabled;
      }
      
      public function set isEnabled(param1:Boolean) : void
      {
         if(this._isEnabled === param1)
         {
            return;
         }
         this._isEnabled = param1;
         if(!param1)
         {
            this._touchPointID = -1;
         }
      }
      
      public function get tapToTrigger() : TapToTrigger
      {
         return this._tapToTrigger;
      }
      
      public function set tapToTrigger(param1:TapToTrigger) : void
      {
         this._tapToTrigger = param1;
      }
      
      public function get tapToSelect() : TapToSelect
      {
         return this._tapToSelect;
      }
      
      public function set tapToSelect(param1:TapToSelect) : void
      {
         this._tapToSelect = param1;
      }
      
      public function get customHitTest() : Function
      {
         return this._customHitTest;
      }
      
      public function set customHitTest(param1:Function) : void
      {
         this._customHitTest = param1;
      }
      
      protected function target_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         var _loc3_:Point = null;
         var _loc4_:Boolean = false;
         if(!this._isEnabled)
         {
            this._touchPointID = -1;
            return;
         }
         if(this._touchPointID >= 0)
         {
            _loc2_ = param1.getTouch(this._target,null,this._touchPointID);
            if(!_loc2_)
            {
               return;
            }
            if(_loc2_.phase == TouchPhase.MOVED)
            {
               this._touchLastGlobalPosition.x = _loc2_.globalX;
               this._touchLastGlobalPosition.y = _loc2_.globalY;
            }
            else if(_loc2_.phase == TouchPhase.ENDED)
            {
               this._target.removeEventListener(Event.ENTER_FRAME,this.target_enterFrameHandler);
               if(this._tapToTrigger)
               {
                  this._tapToTrigger.isEnabled = true;
               }
               if(this._tapToSelect)
               {
                  this._tapToSelect.isEnabled = true;
               }
               this._touchPointID = -1;
            }
            return;
         }
         _loc2_ = param1.getTouch(DisplayObject(this._target),TouchPhase.BEGAN);
         if(!_loc2_)
         {
            return;
         }
         if(this._customHitTest !== null)
         {
            _loc3_ = Pool.getPoint();
            _loc2_.getLocation(DisplayObject(this._target),_loc3_);
            _loc4_ = this._customHitTest(_loc3_);
            Pool.putPoint(_loc3_);
            if(!_loc4_)
            {
               return;
            }
         }
         this._touchPointID = _loc2_.id;
         this._touchLastGlobalPosition.x = _loc2_.globalX;
         this._touchLastGlobalPosition.y = _loc2_.globalY;
         this._touchBeginTime = getTimer();
         this._target.addEventListener(Event.ENTER_FRAME,this.target_enterFrameHandler);
      }
      
      protected function target_enterFrameHandler(param1:Event) : void
      {
         var _loc3_:Stage = null;
         var _loc4_:Boolean = false;
         var _loc2_:Number = (getTimer() - this._touchBeginTime) / 1000;
         if(_loc2_ >= this._longPressDuration)
         {
            this._target.removeEventListener(Event.ENTER_FRAME,this.target_enterFrameHandler);
            _loc3_ = this._target.stage;
            if(this._target is DisplayObjectContainer)
            {
               _loc4_ = DisplayObjectContainer(this._target).contains(_loc3_.hitTest(this._touchLastGlobalPosition));
            }
            else
            {
               _loc4_ = this._target === _loc3_.hitTest(this._touchLastGlobalPosition);
            }
            if(_loc4_)
            {
               if(this._tapToTrigger)
               {
                  this._tapToTrigger.isEnabled = false;
               }
               if(this._tapToSelect)
               {
                  this._tapToSelect.isEnabled = false;
               }
               this._target.dispatchEventWith(FeathersEventType.LONG_PRESS);
            }
         }
      }
   }
}

