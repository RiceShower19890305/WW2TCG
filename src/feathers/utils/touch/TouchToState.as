package feathers.utils.touch
{
   import feathers.core.IStateContext;
   import flash.geom.Point;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.display.Stage;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Pool;
   
   public class TouchToState
   {
      
      protected var _target:DisplayObject;
      
      protected var _callback:Function;
      
      protected var _currentState:String = "up";
      
      protected var _upState:String = "up";
      
      protected var _downState:String = "down";
      
      protected var _hoverState:String = "hover";
      
      protected var _touchPointID:int = -1;
      
      protected var _isEnabled:Boolean = true;
      
      protected var _customHitTest:Function;
      
      protected var _hoverBeforeBegan:Boolean = false;
      
      protected var _keepDownStateOnRollOut:Boolean = false;
      
      public function TouchToState(param1:DisplayObject = null, param2:Function = null)
      {
         super();
         this.target = param1;
         this.callback = param2;
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
         if(this._target !== null)
         {
            this._target.removeEventListener(TouchEvent.TOUCH,this.target_touchHandler);
            this._target.removeEventListener(Event.REMOVED_FROM_STAGE,this.target_removedFromStageHandler);
         }
         this._target = param1;
         if(this._target !== null)
         {
            this._touchPointID = -1;
            this._currentState = this._upState;
            this._target.addEventListener(TouchEvent.TOUCH,this.target_touchHandler);
            this._target.addEventListener(Event.REMOVED_FROM_STAGE,this.target_removedFromStageHandler);
         }
      }
      
      public function get callback() : Function
      {
         return this._callback;
      }
      
      public function set callback(param1:Function) : void
      {
         if(this._callback === param1)
         {
            return;
         }
         this._callback = param1;
         if(this._callback !== null)
         {
            this._callback(this._currentState);
         }
      }
      
      public function get currentState() : String
      {
         return this._currentState;
      }
      
      public function get upState() : String
      {
         return this._upState;
      }
      
      public function set upState(param1:String) : void
      {
         this._upState = param1;
      }
      
      public function get downState() : String
      {
         return this._downState;
      }
      
      public function set downState(param1:String) : void
      {
         this._downState = param1;
      }
      
      public function get hoverState() : String
      {
         return this._hoverState;
      }
      
      public function set hoverState(param1:String) : void
      {
         this._hoverState = param1;
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
      
      public function get customHitTest() : Function
      {
         return this._customHitTest;
      }
      
      public function set customHitTest(param1:Function) : void
      {
         this._customHitTest = param1;
      }
      
      public function get keepDownStateOnRollOut() : Boolean
      {
         return this._keepDownStateOnRollOut;
      }
      
      public function set keepDownStateOnRollOut(param1:Boolean) : void
      {
         this._keepDownStateOnRollOut = param1;
      }
      
      protected function handleCustomHitTest(param1:Touch) : Boolean
      {
         if(this._customHitTest === null)
         {
            return true;
         }
         var _loc2_:Point = Pool.getPoint();
         param1.getLocation(DisplayObject(this._target),_loc2_);
         var _loc3_:Boolean = this._customHitTest(_loc2_);
         Pool.putPoint(_loc2_);
         return _loc3_;
      }
      
      protected function changeState(param1:String) : void
      {
         var _loc2_:String = this._currentState;
         if(this._target is IStateContext)
         {
            _loc2_ = IStateContext(this._target).currentState;
         }
         this._currentState = param1;
         if(_loc2_ === param1)
         {
            return;
         }
         if(this._callback !== null)
         {
            this._callback(param1);
         }
      }
      
      protected function resetTouchState() : void
      {
         this._hoverBeforeBegan = false;
         this._touchPointID = -1;
         this.changeState(this._upState);
      }
      
      protected function target_removedFromStageHandler(param1:Event) : void
      {
         this.resetTouchState();
      }
      
      protected function target_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         var _loc3_:Stage = null;
         var _loc4_:Point = null;
         var _loc5_:Boolean = false;
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
            _loc3_ = this._target.stage;
            if(_loc3_ !== null)
            {
               _loc4_ = Pool.getPoint();
               _loc2_.getLocation(_loc3_,_loc4_);
               if(this._target is DisplayObjectContainer)
               {
                  _loc5_ = DisplayObjectContainer(this._target).contains(_loc3_.hitTest(_loc4_));
               }
               else
               {
                  _loc5_ = this._target === _loc3_.hitTest(_loc4_);
               }
               _loc5_ &&= this.handleCustomHitTest(_loc2_);
               Pool.putPoint(_loc4_);
               if(_loc2_.phase === TouchPhase.MOVED)
               {
                  if(this._keepDownStateOnRollOut)
                  {
                     return;
                  }
                  if(_loc5_)
                  {
                     this.changeState(this._downState);
                     return;
                  }
                  this.changeState(this._upState);
                  return;
               }
               if(_loc2_.phase === TouchPhase.ENDED)
               {
                  if(_loc5_ && this._hoverBeforeBegan)
                  {
                     this._touchPointID = -1;
                     this.changeState(this._hoverState);
                  }
                  else
                  {
                     this.resetTouchState();
                  }
                  return;
               }
            }
         }
         else
         {
            _loc2_ = param1.getTouch(this._target,TouchPhase.BEGAN);
            if(_loc2_ !== null && this.handleCustomHitTest(_loc2_))
            {
               this.changeState(this._downState);
               this._touchPointID = _loc2_.id;
               return;
            }
            _loc2_ = param1.getTouch(this._target,TouchPhase.HOVER);
            if(_loc2_ !== null && this.handleCustomHitTest(_loc2_))
            {
               this._hoverBeforeBegan = true;
               this.changeState(this._hoverState);
               return;
            }
            this.changeState(this._upState);
         }
      }
   }
}

