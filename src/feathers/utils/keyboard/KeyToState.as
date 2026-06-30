package feathers.utils.keyboard
{
   import feathers.core.IFocusDisplayObject;
   import feathers.core.IStateContext;
   import feathers.events.FeathersEventType;
   import feathers.system.DeviceCapabilities;
   import starling.display.Stage;
   import starling.events.Event;
   import starling.events.KeyboardEvent;
   
   public class KeyToState
   {
      
      protected var _stage:Stage;
      
      protected var _hasFocus:Boolean = false;
      
      protected var _target:IFocusDisplayObject;
      
      protected var _callback:Function;
      
      protected var _keyCode:uint = 32;
      
      protected var _cancelKeyCode:uint = 27;
      
      protected var _keyLocation:uint = 4294967295;
      
      protected var _isEnabled:Boolean = true;
      
      protected var _currentState:String = "up";
      
      protected var _upState:String = "up";
      
      protected var _downState:String = "down";
      
      public function KeyToState(param1:IFocusDisplayObject = null, param2:Function = null)
      {
         super();
         this.target = param1;
         this.callback = param2;
      }
      
      public function get target() : IFocusDisplayObject
      {
         return this._target;
      }
      
      public function set target(param1:IFocusDisplayObject) : void
      {
         if(this._target === param1)
         {
            return;
         }
         if(param1 !== null && !(param1 is IFocusDisplayObject))
         {
            throw new ArgumentError("Target of KeyToState must implement IFocusDisplayObject");
         }
         if(this._stage !== null)
         {
            this._stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.stage_keyDownHandler);
            this._stage.removeEventListener(KeyboardEvent.KEY_UP,this.stage_keyUpHandler);
            this._stage = null;
         }
         if(this._target !== null)
         {
            this._target.removeEventListener(FeathersEventType.FOCUS_IN,this.target_focusInHandler);
            this._target.removeEventListener(FeathersEventType.FOCUS_OUT,this.target_focusOutHandler);
            this._target.removeEventListener(Event.REMOVED_FROM_STAGE,this.target_removedFromStageHandler);
         }
         this._target = param1;
         if(this._target !== null)
         {
            this._currentState = this._upState;
            this._target.addEventListener(FeathersEventType.FOCUS_IN,this.target_focusInHandler);
            this._target.addEventListener(FeathersEventType.FOCUS_OUT,this.target_focusOutHandler);
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
      
      public function get keyCode() : uint
      {
         return this._keyCode;
      }
      
      public function set keyCode(param1:uint) : void
      {
         this._keyCode = param1;
      }
      
      public function get cancelKeyCode() : uint
      {
         return this._cancelKeyCode;
      }
      
      public function set cancelKeyCode(param1:uint) : void
      {
         this._cancelKeyCode = param1;
      }
      
      public function get keyLocation() : uint
      {
         return this._keyLocation;
      }
      
      public function set keyLocation(param1:uint) : void
      {
         this._keyLocation = param1;
      }
      
      public function get isEnabled() : Boolean
      {
         return this._isEnabled;
      }
      
      public function set isEnabled(param1:Boolean) : void
      {
         this._isEnabled = param1;
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
      
      protected function focusOut() : void
      {
         this._hasFocus = false;
         if(this._stage !== null)
         {
            this._stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.stage_keyDownHandler);
            this._stage.removeEventListener(KeyboardEvent.KEY_UP,this.stage_keyUpHandler);
            this._stage = null;
         }
         this.changeState(this._upState);
      }
      
      protected function target_focusInHandler(param1:Event) : void
      {
         this._hasFocus = true;
         this._stage = this._target.stage;
         this._stage.addEventListener(KeyboardEvent.KEY_DOWN,this.stage_keyDownHandler);
      }
      
      protected function target_focusOutHandler(param1:Event) : void
      {
         this.focusOut();
      }
      
      protected function target_removedFromStageHandler(param1:Event) : void
      {
         this.focusOut();
      }
      
      protected function stage_keyDownHandler(param1:KeyboardEvent) : void
      {
         if(!this._isEnabled)
         {
            return;
         }
         if(param1.currentTarget !== this._stage)
         {
            return;
         }
         if(param1.keyCode == this._cancelKeyCode)
         {
            this._stage.removeEventListener(KeyboardEvent.KEY_UP,this.stage_keyUpHandler);
            this.changeState(this._upState);
            return;
         }
         if(param1.keyCode != this._keyCode)
         {
            return;
         }
         if(this._keyLocation != uint.MAX_VALUE && !(param1.keyLocation == this._keyLocation || this._keyLocation == 4 && DeviceCapabilities.simulateDPad))
         {
            return;
         }
         this._stage.addEventListener(KeyboardEvent.KEY_UP,this.stage_keyUpHandler);
         this.changeState(this._downState);
      }
      
      protected function stage_keyUpHandler(param1:KeyboardEvent) : void
      {
         if(!this._isEnabled)
         {
            return;
         }
         if(param1.keyCode != this._keyCode)
         {
            return;
         }
         if(this._keyLocation != uint.MAX_VALUE && !(param1.keyLocation == this._keyLocation || this._keyLocation == 4 && DeviceCapabilities.simulateDPad))
         {
            return;
         }
         var _loc2_:Stage = Stage(param1.currentTarget);
         _loc2_.removeEventListener(KeyboardEvent.KEY_UP,this.stage_keyUpHandler);
         if(this._stage !== _loc2_)
         {
            return;
         }
         this.changeState(this._upState);
      }
   }
}

