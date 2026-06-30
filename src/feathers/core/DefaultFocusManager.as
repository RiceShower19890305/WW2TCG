package feathers.core
{
   import feathers.controls.supportClasses.LayoutViewPort;
   import feathers.events.FeathersEventType;
   import feathers.layout.RelativePosition;
   import feathers.system.DeviceCapabilities;
   import feathers.utils.focus.isBetterFocusForRelativePosition;
   import flash.display.InteractiveObject;
   import flash.display.Stage;
   import flash.errors.IllegalOperationError;
   import flash.events.FocusEvent;
   import flash.events.IEventDispatcher;
   import flash.events.KeyboardEvent;
   import flash.events.TransformGestureEvent;
   import flash.geom.Rectangle;
   import flash.system.Capabilities;
   import flash.ui.KeyLocation;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.events.Event;
   import starling.events.EventDispatcher;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Pool;
   
   public class DefaultFocusManager extends EventDispatcher implements IFocusManager
   {
      
      protected static var NATIVE_STAGE_TO_FOCUS_TARGET:Dictionary = new Dictionary(true);
      
      protected var _starling:Starling;
      
      protected var _nativeFocusTarget:NativeFocusTarget;
      
      protected var _root:DisplayObjectContainer;
      
      protected var _isEnabled:Boolean = false;
      
      protected var _savedFocus:IFocusDisplayObject;
      
      protected var _focus:IFocusDisplayObject;
      
      public function DefaultFocusManager(param1:DisplayObjectContainer)
      {
         super();
         if(!param1.stage)
         {
            throw new ArgumentError("Focus manager root must be added to the stage.");
         }
         this._root = param1;
         this._starling = param1.stage.starling;
      }
      
      public function get root() : DisplayObjectContainer
      {
         return this._root;
      }
      
      public function get isEnabled() : Boolean
      {
         return this._isEnabled;
      }
      
      public function set isEnabled(param1:Boolean) : void
      {
         var _loc2_:IFocusDisplayObject = null;
         if(this._isEnabled == param1)
         {
            return;
         }
         this._isEnabled = param1;
         if(this._isEnabled)
         {
            this._nativeFocusTarget = NATIVE_STAGE_TO_FOCUS_TARGET[this._starling.nativeStage] as NativeFocusTarget;
            if(!this._nativeFocusTarget)
            {
               this._nativeFocusTarget = new NativeFocusTarget();
               this._starling.nativeStage.addChild(this._nativeFocusTarget);
            }
            else
            {
               ++this._nativeFocusTarget.referenceCount;
            }
            this.setFocusManager(this._root);
            this._root.addEventListener(Event.ADDED,this.topLevelContainer_addedHandler);
            this._root.addEventListener(Event.REMOVED,this.topLevelContainer_removedHandler);
            this._root.addEventListener(TouchEvent.TOUCH,this.topLevelContainer_touchHandler);
            this._starling.nativeStage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.stage_keyFocusChangeHandler,false,0,true);
            this._starling.nativeStage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.stage_mouseFocusChangeHandler,false,0,true);
            this._starling.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN,this.stage_keyDownHandler,false,0,true);
            this._starling.nativeStage.addEventListener("gestureDirectionalTap",this.stage_gestureDirectionalTapHandler,false,0,true);
            if(Boolean(this._savedFocus) && !this._savedFocus.stage)
            {
               this._savedFocus = null;
            }
            this.focus = this._savedFocus;
            this._savedFocus = null;
         }
         else
         {
            --this._nativeFocusTarget.referenceCount;
            if(this._nativeFocusTarget.referenceCount <= 0)
            {
               this._nativeFocusTarget.parent.removeChild(this._nativeFocusTarget);
               delete NATIVE_STAGE_TO_FOCUS_TARGET[this._starling.nativeStage];
            }
            this._nativeFocusTarget = null;
            this._root.removeEventListener(Event.ADDED,this.topLevelContainer_addedHandler);
            this._root.removeEventListener(Event.REMOVED,this.topLevelContainer_removedHandler);
            this._root.removeEventListener(TouchEvent.TOUCH,this.topLevelContainer_touchHandler);
            this._starling.nativeStage.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.stage_keyFocusChangeHandler);
            this._starling.nativeStage.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.stage_mouseFocusChangeHandler);
            this._starling.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN,this.stage_keyDownHandler);
            this._starling.nativeStage.removeEventListener("gestureDirectionalTap",this.stage_gestureDirectionalTapHandler);
            _loc2_ = this.focus;
            this.focus = null;
            this._savedFocus = _loc2_;
         }
      }
      
      public function get focus() : IFocusDisplayObject
      {
         return this._focus;
      }
      
      public function set focus(param1:IFocusDisplayObject) : void
      {
         var _loc5_:Object = null;
         var _loc6_:IAdvancedNativeFocusOwner = null;
         if(this._focus === param1)
         {
            return;
         }
         var _loc2_:Boolean = false;
         var _loc3_:IFeathersDisplayObject = this._focus;
         if(this._isEnabled && param1 !== null && param1.isFocusEnabled && param1.focusManager === this)
         {
            this._focus = param1;
            _loc2_ = true;
         }
         else
         {
            this._focus = null;
         }
         var _loc4_:Stage = this._starling.nativeStage;
         if(_loc3_ is INativeFocusOwner)
         {
            _loc5_ = INativeFocusOwner(_loc3_).nativeFocus;
            if(_loc5_ === null && _loc4_ !== null)
            {
               _loc5_ = _loc4_.focus;
            }
            if(_loc5_ is IEventDispatcher)
            {
               IEventDispatcher(_loc5_).removeEventListener(FocusEvent.FOCUS_OUT,this.nativeFocus_focusOutHandler);
            }
         }
         if(_loc3_ !== null)
         {
            _loc3_.dispatchEventWith(FeathersEventType.FOCUS_OUT);
         }
         if(_loc2_ && this._focus !== param1)
         {
            return;
         }
         if(this._isEnabled)
         {
            if(this._focus !== null)
            {
               _loc5_ = null;
               if(this._focus is INativeFocusOwner)
               {
                  _loc5_ = INativeFocusOwner(this._focus).nativeFocus;
                  if(_loc5_ is InteractiveObject)
                  {
                     _loc4_.focus = InteractiveObject(_loc5_);
                  }
                  else if(_loc5_ !== null)
                  {
                     if(!(this._focus is IAdvancedNativeFocusOwner))
                     {
                        throw new IllegalOperationError("If nativeFocus does not return an InteractiveObject, class must implement IAdvancedNativeFocusOwner interface");
                     }
                     _loc6_ = IAdvancedNativeFocusOwner(this._focus);
                     if(!_loc6_.hasFocus)
                     {
                        _loc6_.setFocus();
                     }
                  }
               }
               if(_loc5_ === null)
               {
                  _loc5_ = this._nativeFocusTarget;
                  _loc4_.focus = this._nativeFocusTarget;
               }
               if(_loc5_ is IEventDispatcher)
               {
                  IEventDispatcher(_loc5_).addEventListener(FocusEvent.FOCUS_OUT,this.nativeFocus_focusOutHandler,false,0,true);
               }
               this._focus.dispatchEventWith(FeathersEventType.FOCUS_IN);
            }
            else
            {
               _loc4_.focus = null;
            }
         }
         else
         {
            this._savedFocus = param1;
         }
         this.dispatchEventWith(Event.CHANGE);
      }
      
      protected function setFocusManager(param1:DisplayObject) : void
      {
         var _loc2_:IFocusDisplayObject = null;
         var _loc3_:DisplayObjectContainer = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:DisplayObject = null;
         var _loc7_:IFocusExtras = null;
         var _loc8_:Vector.<DisplayObject> = null;
         if(param1 is IFocusDisplayObject)
         {
            _loc2_ = IFocusDisplayObject(param1);
            _loc2_.focusManager = this;
         }
         if(param1 is DisplayObjectContainer && !(param1 is IFocusDisplayObject) || param1 is IFocusContainer && IFocusContainer(param1).isChildFocusEnabled)
         {
            _loc3_ = DisplayObjectContainer(param1);
            _loc4_ = _loc3_.numChildren;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc6_ = _loc3_.getChildAt(_loc5_);
               this.setFocusManager(_loc6_);
               _loc5_++;
            }
            if(_loc3_ is IFocusExtras)
            {
               _loc7_ = IFocusExtras(_loc3_);
               _loc8_ = _loc7_.focusExtrasBefore;
               if(_loc8_)
               {
                  _loc4_ = int(_loc8_.length);
                  _loc5_ = 0;
                  while(_loc5_ < _loc4_)
                  {
                     _loc6_ = _loc8_[_loc5_];
                     this.setFocusManager(_loc6_);
                     _loc5_++;
                  }
               }
               _loc8_ = _loc7_.focusExtrasAfter;
               if(_loc8_)
               {
                  _loc4_ = int(_loc8_.length);
                  _loc5_ = 0;
                  while(_loc5_ < _loc4_)
                  {
                     _loc6_ = _loc8_[_loc5_];
                     this.setFocusManager(_loc6_);
                     _loc5_++;
                  }
               }
            }
         }
      }
      
      protected function clearFocusManager(param1:DisplayObject) : void
      {
         var _loc2_:IFocusDisplayObject = null;
         var _loc3_:DisplayObjectContainer = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:DisplayObject = null;
         var _loc7_:IFocusExtras = null;
         var _loc8_:Vector.<DisplayObject> = null;
         if(param1 is IFocusDisplayObject)
         {
            _loc2_ = IFocusDisplayObject(param1);
            if(_loc2_.focusManager == this)
            {
               if(this._focus == _loc2_)
               {
                  this.focus = _loc2_.focusOwner;
               }
               _loc2_.focusManager = null;
            }
         }
         if(param1 is DisplayObjectContainer)
         {
            _loc3_ = DisplayObjectContainer(param1);
            _loc4_ = _loc3_.numChildren;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc6_ = _loc3_.getChildAt(_loc5_);
               this.clearFocusManager(_loc6_);
               _loc5_++;
            }
            if(_loc3_ is IFocusExtras)
            {
               _loc7_ = IFocusExtras(_loc3_);
               _loc8_ = _loc7_.focusExtrasBefore;
               if(_loc8_)
               {
                  _loc4_ = int(_loc8_.length);
                  _loc5_ = 0;
                  while(_loc5_ < _loc4_)
                  {
                     _loc6_ = _loc8_[_loc5_];
                     this.clearFocusManager(_loc6_);
                     _loc5_++;
                  }
               }
               _loc8_ = _loc7_.focusExtrasAfter;
               if(_loc8_)
               {
                  _loc4_ = int(_loc8_.length);
                  _loc5_ = 0;
                  while(_loc5_ < _loc4_)
                  {
                     _loc6_ = _loc8_[_loc5_];
                     this.clearFocusManager(_loc6_);
                     _loc5_++;
                  }
               }
            }
         }
      }
      
      protected function findPreviousContainerFocus(param1:DisplayObjectContainer, param2:DisplayObject, param3:Boolean) : IFocusDisplayObject
      {
         var _loc5_:IFocusExtras = null;
         var _loc6_:Vector.<DisplayObject> = null;
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         var _loc9_:* = 0;
         var _loc10_:DisplayObject = null;
         var _loc11_:IFocusDisplayObject = null;
         var _loc12_:IFocusDisplayObject = null;
         if(param1 is LayoutViewPort)
         {
            param1 = param1.parent;
         }
         var _loc4_:Boolean = param2 == null;
         if(param1 is IFocusExtras)
         {
            _loc5_ = IFocusExtras(param1);
            _loc6_ = _loc5_.focusExtrasAfter;
            if(_loc6_)
            {
               _loc7_ = false;
               if(param2)
               {
                  _loc8_ = _loc6_.indexOf(param2) - 1;
                  _loc4_ = _loc8_ >= -1;
                  _loc7_ = !_loc4_;
               }
               else
               {
                  _loc8_ = _loc6_.length - 1;
               }
               if(!_loc7_)
               {
                  _loc9_ = _loc8_;
                  while(_loc9_ >= 0)
                  {
                     _loc10_ = _loc6_[_loc9_];
                     _loc11_ = this.findPreviousChildFocus(_loc10_);
                     if(this.isValidFocus(_loc11_))
                     {
                        return _loc11_;
                     }
                     _loc9_--;
                  }
               }
            }
         }
         if(Boolean(param2) && !_loc4_)
         {
            _loc8_ = param1.getChildIndex(param2) - 1;
            _loc4_ = _loc8_ >= -1;
         }
         else
         {
            _loc8_ = param1.numChildren - 1;
         }
         _loc9_ = _loc8_;
         while(_loc9_ >= 0)
         {
            _loc10_ = param1.getChildAt(_loc9_);
            _loc11_ = this.findPreviousChildFocus(_loc10_);
            if(this.isValidFocus(_loc11_))
            {
               return _loc11_;
            }
            _loc9_--;
         }
         if(param1 is IFocusExtras)
         {
            _loc6_ = _loc5_.focusExtrasBefore;
            if(_loc6_)
            {
               _loc7_ = false;
               if(Boolean(param2) && !_loc4_)
               {
                  _loc8_ = _loc6_.indexOf(param2) - 1;
                  _loc4_ = _loc8_ >= -1;
                  _loc7_ = !_loc4_;
               }
               else
               {
                  _loc8_ = _loc6_.length - 1;
               }
               if(!_loc7_)
               {
                  _loc9_ = _loc8_;
                  while(_loc9_ >= 0)
                  {
                     _loc10_ = _loc6_[_loc9_];
                     _loc11_ = this.findPreviousChildFocus(_loc10_);
                     if(this.isValidFocus(_loc11_))
                     {
                        return _loc11_;
                     }
                     _loc9_--;
                  }
               }
            }
         }
         if(param3 && param1 != this._root)
         {
            if(param1 is IFocusDisplayObject)
            {
               _loc12_ = IFocusDisplayObject(param1);
               if(this.isValidFocus(_loc12_))
               {
                  return _loc12_;
               }
            }
            return this.findPreviousContainerFocus(param1.parent,param1,true);
         }
         return null;
      }
      
      protected function findNextContainerFocus(param1:DisplayObjectContainer, param2:DisplayObject, param3:Boolean) : IFocusDisplayObject
      {
         var _loc5_:IFocusExtras = null;
         var _loc6_:Vector.<DisplayObject> = null;
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:DisplayObject = null;
         var _loc12_:IFocusDisplayObject = null;
         if(param1 is LayoutViewPort)
         {
            param1 = param1.parent;
         }
         var _loc4_:Boolean = param2 == null;
         if(param1 is IFocusExtras)
         {
            _loc5_ = IFocusExtras(param1);
            _loc6_ = _loc5_.focusExtrasBefore;
            if(_loc6_)
            {
               _loc7_ = false;
               if(param2)
               {
                  _loc8_ = _loc6_.indexOf(param2) + 1;
                  _loc4_ = _loc8_ > 0;
                  _loc7_ = !_loc4_;
               }
               else
               {
                  _loc8_ = 0;
               }
               if(!_loc7_)
               {
                  _loc9_ = int(_loc6_.length);
                  _loc10_ = _loc8_;
                  while(_loc10_ < _loc9_)
                  {
                     _loc11_ = _loc6_[_loc10_];
                     _loc12_ = this.findNextChildFocus(_loc11_);
                     if(this.isValidFocus(_loc12_))
                     {
                        return _loc12_;
                     }
                     _loc10_++;
                  }
               }
            }
         }
         if(Boolean(param2) && !_loc4_)
         {
            _loc8_ = param1.getChildIndex(param2) + 1;
            _loc4_ = _loc8_ > 0;
         }
         else
         {
            _loc8_ = 0;
         }
         _loc9_ = param1.numChildren;
         _loc10_ = _loc8_;
         while(_loc10_ < _loc9_)
         {
            _loc11_ = param1.getChildAt(_loc10_);
            _loc12_ = this.findNextChildFocus(_loc11_);
            if(this.isValidFocus(_loc12_))
            {
               return _loc12_;
            }
            _loc10_++;
         }
         if(param1 is IFocusExtras)
         {
            _loc6_ = _loc5_.focusExtrasAfter;
            if(_loc6_)
            {
               _loc7_ = false;
               if(Boolean(param2) && !_loc4_)
               {
                  _loc8_ = _loc6_.indexOf(param2) + 1;
                  _loc4_ = _loc8_ > 0;
                  _loc7_ = !_loc4_;
               }
               else
               {
                  _loc8_ = 0;
               }
               if(!_loc7_)
               {
                  _loc9_ = int(_loc6_.length);
                  _loc10_ = _loc8_;
                  while(_loc10_ < _loc9_)
                  {
                     _loc11_ = _loc6_[_loc10_];
                     _loc12_ = this.findNextChildFocus(_loc11_);
                     if(this.isValidFocus(_loc12_))
                     {
                        return _loc12_;
                     }
                     _loc10_++;
                  }
               }
            }
         }
         if(param3 && param1 != this._root)
         {
            return this.findNextContainerFocus(param1.parent,param1,true);
         }
         return null;
      }
      
      protected function findPreviousChildFocus(param1:DisplayObject) : IFocusDisplayObject
      {
         var _loc2_:DisplayObjectContainer = null;
         var _loc3_:IFocusDisplayObject = null;
         var _loc4_:IFocusDisplayObject = null;
         if(param1 is DisplayObjectContainer && !(param1 is IFocusDisplayObject) || param1 is IFocusContainer && IFocusContainer(param1).isChildFocusEnabled)
         {
            _loc2_ = DisplayObjectContainer(param1);
            _loc3_ = this.findPreviousContainerFocus(_loc2_,null,false);
            if(_loc3_)
            {
               return _loc3_;
            }
         }
         if(param1 is IFocusDisplayObject)
         {
            _loc4_ = IFocusDisplayObject(param1);
            if(this.isValidFocus(_loc4_))
            {
               return _loc4_;
            }
         }
         return null;
      }
      
      protected function findNextChildFocus(param1:DisplayObject) : IFocusDisplayObject
      {
         var _loc2_:IFocusDisplayObject = null;
         var _loc3_:DisplayObjectContainer = null;
         var _loc4_:IFocusDisplayObject = null;
         if(param1 is IFocusDisplayObject)
         {
            _loc2_ = IFocusDisplayObject(param1);
            if(this.isValidFocus(_loc2_))
            {
               return _loc2_;
            }
         }
         if(param1 is DisplayObjectContainer && !(param1 is IFocusDisplayObject) || param1 is IFocusContainer && IFocusContainer(param1).isChildFocusEnabled)
         {
            _loc3_ = DisplayObjectContainer(param1);
            _loc4_ = this.findNextContainerFocus(_loc3_,null,false);
            if(_loc4_)
            {
               return _loc4_;
            }
         }
         return null;
      }
      
      protected function findFocusAtRelativePosition(param1:DisplayObjectContainer, param2:String) : IFocusDisplayObject
      {
         var _loc8_:IFocusDisplayObject = null;
         var _loc3_:Vector.<IFocusDisplayObject> = new Vector.<IFocusDisplayObject>(0);
         this.findAllFocusableObjects(param1,_loc3_);
         if(this._focus === null)
         {
            if(_loc3_.length > 0)
            {
               return _loc3_[0];
            }
            return null;
         }
         var _loc4_:flash.geom.Rectangle = this._focus.getBounds(this._focus.stage,Pool.getRectangle());
         var _loc5_:IFocusDisplayObject = null;
         var _loc6_:int = int(_loc3_.length);
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = _loc3_[_loc7_];
            if(_loc8_ !== this._focus)
            {
               if(isBetterFocusForRelativePosition(_loc8_,_loc5_,_loc4_,param2))
               {
                  _loc5_ = _loc8_;
               }
            }
            _loc7_++;
         }
         Pool.putRectangle(_loc4_);
         if(_loc5_ === null)
         {
            return this._focus;
         }
         return _loc5_;
      }
      
      protected function findAllFocusableObjects(param1:DisplayObject, param2:Vector.<IFocusDisplayObject>) : void
      {
         var _loc3_:IFocusDisplayObject = null;
         var _loc4_:IFocusExtras = null;
         var _loc5_:Vector.<DisplayObject> = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:DisplayObject = null;
         var _loc9_:DisplayObjectContainer = null;
         if(param1 is IFocusDisplayObject)
         {
            _loc3_ = IFocusDisplayObject(param1);
            if(this.isValidFocus(_loc3_))
            {
               param2[param2.length] = _loc3_;
            }
         }
         if(param1 is IFocusExtras)
         {
            _loc4_ = IFocusExtras(param1);
            _loc5_ = _loc4_.focusExtrasBefore;
            _loc6_ = int(_loc5_.length);
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc8_ = _loc5_[_loc7_];
               this.findAllFocusableObjects(_loc8_,param2);
               _loc7_++;
            }
         }
         if(param1 is IFocusDisplayObject)
         {
            if(param1 is IFocusContainer && IFocusContainer(param1).isChildFocusEnabled)
            {
               _loc9_ = DisplayObjectContainer(param1);
               _loc6_ = _loc9_.numChildren;
               _loc7_ = 0;
               while(_loc7_ < _loc6_)
               {
                  _loc8_ = _loc9_.getChildAt(_loc7_);
                  this.findAllFocusableObjects(_loc8_,param2);
                  _loc7_++;
               }
            }
         }
         else if(param1 is DisplayObjectContainer)
         {
            _loc9_ = DisplayObjectContainer(param1);
            _loc6_ = _loc9_.numChildren;
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc8_ = _loc9_.getChildAt(_loc7_);
               this.findAllFocusableObjects(_loc8_,param2);
               _loc7_++;
            }
         }
         if(param1 is IFocusExtras)
         {
            _loc5_ = _loc4_.focusExtrasAfter;
            _loc6_ = int(_loc5_.length);
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc8_ = _loc5_[_loc7_];
               this.findAllFocusableObjects(_loc8_,param2);
               _loc7_++;
            }
         }
      }
      
      protected function isValidFocus(param1:IFocusDisplayObject) : Boolean
      {
         if(param1 === null || param1.focusManager !== this)
         {
            return false;
         }
         if(!param1.isFocusEnabled)
         {
            if(param1.focusOwner === null || !this.isValidFocus(param1.focusOwner))
            {
               return false;
            }
         }
         var _loc2_:IFeathersControl = param1 as IFeathersControl;
         if(_loc2_ !== null && !_loc2_.isEnabled)
         {
            return false;
         }
         return true;
      }
      
      protected function stage_mouseFocusChangeHandler(param1:FocusEvent) : void
      {
         if(param1.relatedObject)
         {
            this.focus = null;
            return;
         }
         param1.preventDefault();
      }
      
      protected function stage_keyDownHandler(param1:KeyboardEvent) : void
      {
         var _loc2_:IFocusDisplayObject = null;
         var _loc4_:String = null;
         if(param1.keyLocation != KeyLocation.D_PAD && !DeviceCapabilities.simulateDPad)
         {
            return;
         }
         if(param1.keyCode != Keyboard.UP && param1.keyCode != Keyboard.DOWN && param1.keyCode != Keyboard.LEFT && param1.keyCode != Keyboard.RIGHT)
         {
            return;
         }
         if(param1.isDefaultPrevented())
         {
            return;
         }
         var _loc3_:IFocusDisplayObject = this._focus;
         if(_loc3_ !== null && _loc3_.focusOwner !== null)
         {
            _loc2_ = _loc3_.focusOwner;
         }
         else
         {
            _loc4_ = RelativePosition.RIGHT;
            switch(param1.keyCode)
            {
               case Keyboard.UP:
                  _loc4_ = RelativePosition.TOP;
                  if(_loc3_ !== null && _loc3_.nextUpFocus !== null)
                  {
                     _loc2_ = _loc3_.nextUpFocus;
                  }
                  break;
               case Keyboard.RIGHT:
                  _loc4_ = RelativePosition.RIGHT;
                  if(_loc3_ !== null && _loc3_.nextRightFocus !== null)
                  {
                     _loc2_ = _loc3_.nextRightFocus;
                  }
                  break;
               case Keyboard.DOWN:
                  _loc4_ = RelativePosition.BOTTOM;
                  if(_loc3_ !== null && _loc3_.nextDownFocus !== null)
                  {
                     _loc2_ = _loc3_.nextDownFocus;
                  }
                  break;
               case Keyboard.LEFT:
                  _loc4_ = RelativePosition.LEFT;
                  if(_loc3_ !== null && _loc3_.nextLeftFocus !== null)
                  {
                     _loc2_ = _loc3_.nextLeftFocus;
                  }
            }
            if(_loc2_ === null)
            {
               _loc2_ = this.findFocusAtRelativePosition(this._root,_loc4_);
            }
         }
         if(_loc2_ !== this._focus)
         {
            param1.preventDefault();
            this.focus = _loc2_;
         }
         if(this._focus)
         {
            this._focus.showFocus();
         }
      }
      
      protected function stage_gestureDirectionalTapHandler(param1:TransformGestureEvent) : void
      {
         if(param1.isDefaultPrevented())
         {
            return;
         }
         var _loc2_:String = null;
         if(param1.offsetY < 0)
         {
            _loc2_ = RelativePosition.TOP;
         }
         else if(param1.offsetY > 0)
         {
            _loc2_ = RelativePosition.BOTTOM;
         }
         else if(param1.offsetX > 0)
         {
            _loc2_ = RelativePosition.RIGHT;
         }
         else if(param1.offsetX < 0)
         {
            _loc2_ = RelativePosition.LEFT;
         }
         if(_loc2_ === null)
         {
            return;
         }
         var _loc3_:IFocusDisplayObject = this.findFocusAtRelativePosition(this._root,_loc2_);
         if(_loc3_ !== this._focus)
         {
            param1.preventDefault();
            this.focus = _loc3_;
         }
         if(this._focus)
         {
            this._focus.showFocus();
         }
      }
      
      protected function stage_keyFocusChangeHandler(param1:FocusEvent) : void
      {
         var _loc2_:IFocusDisplayObject = null;
         if(param1.keyCode != Keyboard.TAB && param1.keyCode != 0)
         {
            return;
         }
         var _loc3_:IFocusDisplayObject = this._focus;
         if(Boolean(_loc3_) && Boolean(_loc3_.focusOwner))
         {
            _loc2_ = _loc3_.focusOwner;
         }
         else if(param1.shiftKey)
         {
            if(_loc3_)
            {
               if(_loc3_.previousTabFocus)
               {
                  _loc2_ = _loc3_.previousTabFocus;
               }
               else
               {
                  _loc2_ = this.findPreviousContainerFocus(_loc3_.parent,DisplayObject(_loc3_),true);
               }
            }
            if(!_loc2_)
            {
               _loc2_ = this.findPreviousContainerFocus(this._root,null,false);
            }
         }
         else
         {
            if(_loc3_)
            {
               if(_loc3_.nextTabFocus)
               {
                  _loc2_ = _loc3_.nextTabFocus;
               }
               else if(_loc3_ is IFocusContainer && IFocusContainer(_loc3_).isChildFocusEnabled)
               {
                  _loc2_ = this.findNextContainerFocus(DisplayObjectContainer(_loc3_),null,true);
               }
               else
               {
                  _loc2_ = this.findNextContainerFocus(_loc3_.parent,DisplayObject(_loc3_),true);
               }
            }
            if(!_loc2_)
            {
               _loc2_ = this.findNextContainerFocus(this._root,null,false);
            }
         }
         if(_loc2_)
         {
            param1.preventDefault();
         }
         this.focus = _loc2_;
         if(this._focus)
         {
            this._focus.showFocus();
         }
      }
      
      protected function topLevelContainer_addedHandler(param1:Event) : void
      {
         this.setFocusManager(DisplayObject(param1.target));
      }
      
      protected function topLevelContainer_removedHandler(param1:Event) : void
      {
         this.clearFocusManager(DisplayObject(param1.target));
      }
      
      protected function topLevelContainer_touchHandler(param1:TouchEvent) : void
      {
         var _loc5_:IFocusDisplayObject = null;
         var _loc6_:IFocusDisplayObject = null;
         var _loc7_:DisplayObject = null;
         var _loc8_:IFocusDisplayObject = null;
         if(Capabilities.os.indexOf("tvOS") != -1)
         {
            return;
         }
         var _loc2_:Touch = param1.getTouch(this._root,TouchPhase.BEGAN);
         if(!_loc2_)
         {
            return;
         }
         if(this._focus !== null && this._focus.maintainTouchFocus)
         {
            return;
         }
         var _loc3_:IFocusDisplayObject = null;
         var _loc4_:DisplayObject = _loc2_.target;
         do
         {
            if(_loc4_ is IFocusDisplayObject)
            {
               _loc5_ = IFocusDisplayObject(_loc4_);
               if(this.isValidFocus(_loc5_))
               {
                  if(!_loc3_ || !(_loc5_ is IFocusContainer) || !IFocusContainer(_loc5_).isChildFocusEnabled)
                  {
                     _loc3_ = _loc5_;
                  }
               }
            }
         }
         while(_loc4_ = _loc4_.parent, _loc4_);
         if(this._focus !== null && _loc3_ !== null)
         {
            _loc6_ = this._focus.focusOwner;
            if(_loc6_ === _loc3_)
            {
               return;
            }
            _loc7_ = DisplayObject(_loc3_);
            while(_loc7_ != null)
            {
               _loc8_ = _loc7_ as IFocusDisplayObject;
               if(_loc8_ !== null)
               {
                  _loc6_ = _loc8_.focusOwner;
                  if(_loc6_ !== null)
                  {
                     if(_loc6_ === this._focus)
                     {
                        _loc3_ = _loc6_;
                     }
                     break;
                  }
                  if(_loc8_.isFocusEnabled)
                  {
                     break;
                  }
               }
               _loc7_ = _loc7_.parent;
            }
         }
         this.focus = _loc3_;
      }
      
      protected function nativeFocus_focusOutHandler(param1:FocusEvent) : void
      {
         var _loc2_:Object = param1.currentTarget;
         var _loc3_:Stage = this._starling.nativeStage;
         if(_loc3_.focus !== null && _loc3_.focus !== _loc2_)
         {
            if(_loc2_ is IEventDispatcher)
            {
               IEventDispatcher(_loc2_).removeEventListener(FocusEvent.FOCUS_OUT,this.nativeFocus_focusOutHandler);
            }
         }
         else if(this._focus !== null)
         {
            if(this._focus is INativeFocusOwner && INativeFocusOwner(this._focus).nativeFocus !== _loc2_)
            {
               return;
            }
            if(_loc2_ is InteractiveObject)
            {
               _loc3_.focus = InteractiveObject(_loc2_);
            }
            else
            {
               IAdvancedNativeFocusOwner(this._focus).setFocus();
            }
         }
      }
   }
}

import flash.display.Sprite;

class NativeFocusTarget extends Sprite
{
   
   public var referenceCount:int = 1;
   
   public function NativeFocusTarget()
   {
      super();
      this.tabEnabled = true;
      this.mouseEnabled = false;
      this.mouseChildren = false;
      this.alpha = 0;
   }
}
