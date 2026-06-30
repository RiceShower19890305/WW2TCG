package feathers.controls.supportClasses
{
   import feathers.controls.AutoSizeMode;
   import feathers.controls.IScreen;
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.IValidating;
   import feathers.events.FeathersEventType;
   import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;
   import flash.errors.IllegalOperationError;
   import flash.utils.getDefinitionByName;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.display.Quad;
   import starling.errors.AbstractMethodError;
   import starling.events.Event;
   
   public class BaseScreenNavigator extends FeathersControl
   {
      
      protected static var SIGNAL_TYPE:Class;
      
      protected var _activeScreenID:String;
      
      protected var _activeScreen:DisplayObject;
      
      protected var screenContainer:DisplayObjectContainer;
      
      protected var _activeScreenExplicitWidth:Number;
      
      protected var _activeScreenExplicitHeight:Number;
      
      protected var _activeScreenExplicitMinWidth:Number;
      
      protected var _activeScreenExplicitMinHeight:Number;
      
      protected var _activeScreenExplicitMaxWidth:Number;
      
      protected var _activeScreenExplicitMaxHeight:Number;
      
      protected var _screens:Object = {};
      
      protected var _previousScreenInTransitionID:String;
      
      protected var _previousScreenInTransition:DisplayObject;
      
      protected var _nextScreenID:String = null;
      
      protected var _nextScreenTransition:Function = null;
      
      protected var _clearAfterTransition:Boolean = false;
      
      protected var _delayedTransition:Function = null;
      
      protected var _waitingForDelayedTransition:Boolean = false;
      
      protected var _clipContent:Boolean = false;
      
      protected var _autoSizeMode:String = "stage";
      
      protected var _waitingTransition:Function;
      
      private var _waitingForTransitionFrameCount:int = 1;
      
      protected var _isTransitionActive:Boolean = false;
      
      public function BaseScreenNavigator()
      {
         super();
         if(Object(this).constructor == BaseScreenNavigator)
         {
            throw new Error(FeathersControl.ABSTRACT_CLASS_ERROR);
         }
         if(!SIGNAL_TYPE)
         {
            try
            {
               SIGNAL_TYPE = Class(getDefinitionByName("org.osflash.signals.ISignal"));
            }
            catch(error:Error)
            {
            }
         }
         this.screenContainer = this;
         this.addEventListener(Event.ADDED_TO_STAGE,this.screenNavigator_addedToStageHandler);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.screenNavigator_removedFromStageHandler);
      }
      
      protected static function defaultTransition(param1:DisplayObject, param2:DisplayObject, param3:Function) : void
      {
         param3();
      }
      
      public function get activeScreenID() : String
      {
         return this._activeScreenID;
      }
      
      public function get activeScreen() : DisplayObject
      {
         return this._activeScreen;
      }
      
      public function get clipContent() : Boolean
      {
         return this._clipContent;
      }
      
      public function set clipContent(param1:Boolean) : void
      {
         if(this._clipContent == param1)
         {
            return;
         }
         this._clipContent = param1;
         if(!param1)
         {
            this.mask = null;
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get autoSizeMode() : String
      {
         return this._autoSizeMode;
      }
      
      public function set autoSizeMode(param1:String) : void
      {
         if(this._autoSizeMode == param1)
         {
            return;
         }
         this._autoSizeMode = param1;
         if(this._activeScreen)
         {
            if(this._autoSizeMode == AutoSizeMode.CONTENT)
            {
               this._activeScreen.addEventListener(Event.RESIZE,this.activeScreen_resizeHandler);
            }
            else
            {
               this._activeScreen.removeEventListener(Event.RESIZE,this.activeScreen_resizeHandler);
            }
         }
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
      
      public function get isTransitionActive() : Boolean
      {
         return this._isTransitionActive;
      }
      
      override public function dispose() : void
      {
         if(this._activeScreen)
         {
            this.cleanupActiveScreen();
            this._activeScreen = null;
            this._activeScreenID = null;
         }
         super.dispose();
      }
      
      public function removeAllScreens() : void
      {
         var _loc1_:String = null;
         if(this._isTransitionActive)
         {
            throw new IllegalOperationError("Cannot remove all screens while a transition is active.");
         }
         if(this._activeScreen)
         {
            this.clearScreenInternal(null);
            this.dispatchEventWith(FeathersEventType.CLEAR);
         }
         for(_loc1_ in this._screens)
         {
            delete this._screens[_loc1_];
         }
      }
      
      public function hasScreen(param1:String) : Boolean
      {
         return this._screens.hasOwnProperty(param1);
      }
      
      public function getScreenIDs(param1:Vector.<String> = null) : Vector.<String>
      {
         var _loc3_:String = null;
         if(param1)
         {
            param1.length = 0;
         }
         else
         {
            param1 = new Vector.<String>(0);
         }
         var _loc2_:int = 0;
         for(_loc3_ in this._screens)
         {
            param1[_loc2_] = _loc3_;
            _loc2_++;
         }
         return param1;
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         _loc1_ = this.autoSizeIfNeeded() || _loc1_;
         this.layoutChildren();
         if(_loc3_ || _loc1_)
         {
            this.refreshMask();
         }
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc1_:Boolean = this._explicitWidth !== this._explicitWidth;
         var _loc2_:Boolean = this._explicitHeight !== this._explicitHeight;
         var _loc3_:Boolean = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc4_:Boolean = this._explicitMinHeight !== this._explicitMinHeight;
         if(!_loc1_ && !_loc2_ && !_loc3_ && !_loc4_)
         {
            return false;
         }
         var _loc5_:Boolean = this._autoSizeMode === AutoSizeMode.CONTENT || this.stage === null;
         var _loc6_:IMeasureDisplayObject = this._activeScreen as IMeasureDisplayObject;
         if(_loc5_)
         {
            if(this._activeScreen !== null)
            {
               resetFluidChildDimensionsForMeasurement(this._activeScreen,this._explicitWidth,this._explicitHeight,this._explicitMinWidth,this._explicitMinHeight,this._explicitMaxWidth,this._explicitMaxHeight,this._activeScreenExplicitWidth,this._activeScreenExplicitHeight,this._activeScreenExplicitMinWidth,this._activeScreenExplicitMinHeight,this._activeScreenExplicitMaxWidth,this._activeScreenExplicitMaxHeight);
               if(this._activeScreen is IValidating)
               {
                  IValidating(this._activeScreen).validate();
               }
            }
         }
         var _loc7_:Number = this._explicitWidth;
         if(_loc1_)
         {
            if(_loc5_)
            {
               if(this._activeScreen !== null)
               {
                  _loc7_ = this._activeScreen.width;
               }
               else
               {
                  _loc7_ = 0;
               }
            }
            else
            {
               _loc7_ = this.stage.stageWidth;
            }
         }
         var _loc8_:Number = this._explicitHeight;
         if(_loc2_)
         {
            if(_loc5_)
            {
               if(this._activeScreen !== null)
               {
                  _loc8_ = this._activeScreen.height;
               }
               else
               {
                  _loc8_ = 0;
               }
            }
            else
            {
               _loc8_ = this.stage.stageHeight;
            }
         }
         var _loc9_:Number = this._explicitMinWidth;
         if(_loc3_)
         {
            if(_loc5_)
            {
               if(_loc6_ !== null)
               {
                  _loc9_ = _loc6_.minWidth;
               }
               else if(this._activeScreen !== null)
               {
                  _loc9_ = this._activeScreen.width;
               }
               else
               {
                  _loc9_ = 0;
               }
            }
            else
            {
               _loc9_ = this.stage.stageWidth;
            }
         }
         var _loc10_:Number = this._explicitMinHeight;
         if(_loc4_)
         {
            if(_loc5_)
            {
               if(_loc6_ !== null)
               {
                  _loc10_ = _loc6_.minHeight;
               }
               else if(this._activeScreen !== null)
               {
                  _loc10_ = this._activeScreen.height;
               }
               else
               {
                  _loc10_ = 0;
               }
            }
            else
            {
               _loc10_ = this.stage.stageHeight;
            }
         }
         return this.saveMeasurements(_loc7_,_loc8_,_loc9_,_loc10_);
      }
      
      protected function addScreenInternal(param1:String, param2:IScreenNavigatorItem) : void
      {
         if(this._screens.hasOwnProperty(param1))
         {
            throw new ArgumentError("Screen with id \'" + param1 + "\' already defined. Cannot add two screens with the same id.");
         }
         this._screens[param1] = param2;
      }
      
      protected function refreshMask() : void
      {
         if(!this._clipContent)
         {
            return;
         }
         var _loc1_:DisplayObject = this.mask as Quad;
         if(_loc1_)
         {
            _loc1_.width = this.actualWidth;
            _loc1_.height = this.actualHeight;
         }
         else
         {
            _loc1_ = new Quad(1,1,16711935);
            _loc1_.width = this.actualWidth;
            _loc1_.height = this.actualHeight;
            this.mask = _loc1_;
         }
      }
      
      protected function removeScreenInternal(param1:String) : IScreenNavigatorItem
      {
         if(!this._screens.hasOwnProperty(param1))
         {
            throw new ArgumentError("Screen \'" + param1 + "\' cannot be removed because it has not been added.");
         }
         if(this._isTransitionActive && (param1 == this._previousScreenInTransitionID || param1 == this._activeScreenID))
         {
            throw new IllegalOperationError("Cannot remove a screen while it is transitioning in or out.");
         }
         if(this._activeScreenID == param1)
         {
            this.clearScreenInternal(null);
            this.dispatchEventWith(FeathersEventType.CLEAR);
         }
         var _loc2_:IScreenNavigatorItem = IScreenNavigatorItem(this._screens[param1]);
         delete this._screens[param1];
         return _loc2_;
      }
      
      protected function showScreenInternal(param1:String, param2:Function, param3:Object = null) : DisplayObject
      {
         var _loc5_:String = null;
         var _loc8_:IScreen = null;
         if(!this.hasScreen(param1))
         {
            throw new ArgumentError("Screen with id \'" + param1 + "\' cannot be shown because it has not been defined.");
         }
         if(this._isTransitionActive)
         {
            this._nextScreenID = param1;
            this._nextScreenTransition = param2;
            this._clearAfterTransition = false;
            return null;
         }
         this._previousScreenInTransition = this._activeScreen;
         this._previousScreenInTransitionID = this._activeScreenID;
         if(this._activeScreen !== null)
         {
            this.cleanupActiveScreen();
         }
         this._isTransitionActive = true;
         var _loc4_:IScreenNavigatorItem = IScreenNavigatorItem(this._screens[param1]);
         this._activeScreen = _loc4_.getScreen();
         this._activeScreenID = param1;
         if(_loc4_.transitionDelayEvent !== null)
         {
            this._waitingForDelayedTransition = true;
            this._activeScreen.addEventListener(_loc4_.transitionDelayEvent,this.screen_transitionDelayHandler);
         }
         else
         {
            this._waitingForDelayedTransition = false;
         }
         for(_loc5_ in param3)
         {
            this._activeScreen[_loc5_] = param3[_loc5_];
         }
         if(this._activeScreen is IScreen)
         {
            _loc8_ = IScreen(this._activeScreen);
            _loc8_.screenID = this._activeScreenID;
            _loc8_.owner = this;
         }
         if(this._autoSizeMode === AutoSizeMode.CONTENT || !this.stage)
         {
            this._activeScreen.addEventListener(Event.RESIZE,this.activeScreen_resizeHandler);
         }
         this.prepareActiveScreen();
         var _loc6_:Boolean = this._previousScreenInTransition === this._activeScreen;
         this.screenContainer.addChild(this._activeScreen);
         if(this._activeScreen is IFeathersControl)
         {
            IFeathersControl(this._activeScreen).initializeNow();
         }
         var _loc7_:IMeasureDisplayObject = this._activeScreen as IMeasureDisplayObject;
         if(_loc7_ !== null)
         {
            this._activeScreenExplicitWidth = _loc7_.explicitWidth;
            this._activeScreenExplicitHeight = _loc7_.explicitHeight;
            this._activeScreenExplicitMinWidth = _loc7_.explicitMinWidth;
            this._activeScreenExplicitMinHeight = _loc7_.explicitMinHeight;
            this._activeScreenExplicitMaxWidth = _loc7_.explicitMaxWidth;
            this._activeScreenExplicitMaxHeight = _loc7_.explicitMaxHeight;
         }
         else
         {
            this._activeScreenExplicitWidth = this._activeScreen.width;
            this._activeScreenExplicitHeight = this._activeScreen.height;
            this._activeScreenExplicitMinWidth = this._activeScreenExplicitWidth;
            this._activeScreenExplicitMinHeight = this._activeScreenExplicitHeight;
            this._activeScreenExplicitMaxWidth = this._activeScreenExplicitWidth;
            this._activeScreenExplicitMaxHeight = this._activeScreenExplicitHeight;
         }
         this.invalidate(INVALIDATION_FLAG_SELECTED);
         if(Boolean(this._validationQueue) && !this._validationQueue.isValidating)
         {
            this._validationQueue.advanceTime(0);
         }
         else if(!this._isValidating)
         {
            this.validate();
         }
         if(_loc6_)
         {
            this._previousScreenInTransition = null;
            this._previousScreenInTransitionID = null;
            this._isTransitionActive = false;
         }
         else if(_loc4_.transitionDelayEvent !== null && this._waitingForDelayedTransition)
         {
            this._waitingForDelayedTransition = false;
            this._activeScreen.visible = false;
            this._delayedTransition = param2;
         }
         else
         {
            if(_loc4_.transitionDelayEvent !== null)
            {
               this._activeScreen.removeEventListener(_loc4_.transitionDelayEvent,this.screen_transitionDelayHandler);
            }
            this.startTransition(param2);
         }
         this.dispatchEventWith(Event.CHANGE);
         return this._activeScreen;
      }
      
      protected function clearScreenInternal(param1:Function = null) : void
      {
         if(this._activeScreen === null)
         {
            return;
         }
         if(this._isTransitionActive)
         {
            this._nextScreenID = null;
            this._clearAfterTransition = true;
            this._nextScreenTransition = param1;
            return;
         }
         this.cleanupActiveScreen();
         this._isTransitionActive = true;
         this._previousScreenInTransition = this._activeScreen;
         this._previousScreenInTransitionID = this._activeScreenID;
         this._activeScreen = null;
         this._activeScreenID = null;
         this.dispatchEventWith(FeathersEventType.TRANSITION_START);
         this._previousScreenInTransition.dispatchEventWith(FeathersEventType.TRANSITION_OUT_START);
         if(param1 !== null)
         {
            this._waitingForTransitionFrameCount = 0;
            this._waitingTransition = param1;
            this.addEventListener(Event.ENTER_FRAME,this.waitingForTransition_enterFrameHandler);
         }
         else
         {
            defaultTransition(this._previousScreenInTransition,this._activeScreen,this.transitionComplete);
         }
         this.invalidate(INVALIDATION_FLAG_SELECTED);
      }
      
      protected function prepareActiveScreen() : void
      {
         throw new AbstractMethodError();
      }
      
      protected function cleanupActiveScreen() : void
      {
         throw new AbstractMethodError();
      }
      
      protected function layoutChildren() : void
      {
         if(this._activeScreen !== null)
         {
            if(this._activeScreen.width != this.actualWidth)
            {
               this._activeScreen.width = this.actualWidth;
            }
            if(this._activeScreen.height != this.actualHeight)
            {
               this._activeScreen.height = this.actualHeight;
            }
            if(this._activeScreen is IValidating)
            {
               IValidating(this._activeScreen).validate();
            }
         }
      }
      
      protected function startTransition(param1:Function) : void
      {
         this.dispatchEventWith(FeathersEventType.TRANSITION_START);
         this._activeScreen.dispatchEventWith(FeathersEventType.TRANSITION_IN_START);
         if(this._previousScreenInTransition !== null)
         {
            this._previousScreenInTransition.dispatchEventWith(FeathersEventType.TRANSITION_OUT_START);
         }
         if(param1 !== null && param1 !== defaultTransition)
         {
            this._activeScreen.visible = false;
            this._waitingForTransitionFrameCount = 0;
            this._waitingTransition = param1;
            this.addEventListener(Event.ENTER_FRAME,this.waitingForTransition_enterFrameHandler);
         }
         else
         {
            this._activeScreen.visible = true;
            defaultTransition(this._previousScreenInTransition,this._activeScreen,this.transitionComplete);
         }
      }
      
      protected function startWaitingTransition() : void
      {
         this.removeEventListener(Event.ENTER_FRAME,this.waitingForTransition_enterFrameHandler);
         if(this._activeScreen)
         {
            this._activeScreen.visible = true;
         }
         var _loc1_:Function = this._waitingTransition;
         this._waitingTransition = null;
         _loc1_(this._previousScreenInTransition,this._activeScreen,this.transitionComplete);
      }
      
      protected function transitionComplete(param1:Boolean = false) : void
      {
         var _loc3_:IScreenNavigatorItem = null;
         var _loc4_:IMeasureDisplayObject = null;
         var _loc5_:DisplayObject = null;
         var _loc6_:DisplayObject = null;
         var _loc7_:String = null;
         var _loc8_:IScreen = null;
         var _loc9_:String = null;
         this._isTransitionActive = this._clearAfterTransition || Boolean(this._nextScreenID);
         if(param1)
         {
            if(this._activeScreen !== null)
            {
               _loc3_ = IScreenNavigatorItem(this._screens[this._activeScreenID]);
               this.cleanupActiveScreen();
               this.screenContainer.removeChild(this._activeScreen,_loc3_.canDispose);
               if(!_loc3_.canDispose)
               {
                  this._activeScreen.width = this._activeScreenExplicitWidth;
                  this._activeScreen.height = this._activeScreenExplicitHeight;
                  _loc4_ = this._activeScreen as IMeasureDisplayObject;
                  if(_loc4_ !== null)
                  {
                     _loc4_.minWidth = this._activeScreenExplicitMinWidth;
                     _loc4_.minHeight = this._activeScreenExplicitMinHeight;
                  }
               }
            }
            this._activeScreen = this._previousScreenInTransition;
            this._activeScreenID = this._previousScreenInTransitionID;
            this._previousScreenInTransition = null;
            this._previousScreenInTransitionID = null;
            this.prepareActiveScreen();
            this.dispatchEventWith(FeathersEventType.TRANSITION_CANCEL);
            this.dispatchEventWith(Event.CHANGE);
         }
         else
         {
            _loc5_ = this._activeScreen;
            _loc6_ = this._previousScreenInTransition;
            _loc7_ = this._previousScreenInTransitionID;
            _loc3_ = IScreenNavigatorItem(this._screens[_loc7_]);
            this._previousScreenInTransition = null;
            this._previousScreenInTransitionID = null;
            if(_loc6_ !== null)
            {
               _loc6_.dispatchEventWith(FeathersEventType.TRANSITION_OUT_COMPLETE);
            }
            if(_loc5_ !== null)
            {
               _loc5_.dispatchEventWith(FeathersEventType.TRANSITION_IN_COMPLETE);
            }
            this.dispatchEventWith(FeathersEventType.TRANSITION_COMPLETE);
            if(_loc6_ !== null)
            {
               if(_loc6_ is IScreen)
               {
                  _loc8_ = IScreen(_loc6_);
                  _loc8_.screenID = null;
                  _loc8_.owner = null;
               }
               _loc6_.removeEventListener(Event.RESIZE,this.activeScreen_resizeHandler);
               this.screenContainer.removeChild(_loc6_,_loc3_.canDispose);
            }
         }
         this._isTransitionActive = false;
         var _loc2_:Function = this._nextScreenTransition;
         this._nextScreenTransition = null;
         if(this._clearAfterTransition)
         {
            this._clearAfterTransition = false;
            this.clearScreenInternal(_loc2_);
         }
         else if(this._nextScreenID !== null)
         {
            _loc9_ = this._nextScreenID;
            this._nextScreenID = null;
            this.showScreenInternal(_loc9_,_loc2_);
         }
      }
      
      protected function screenNavigator_addedToStageHandler(param1:Event) : void
      {
         if(this._autoSizeMode === AutoSizeMode.STAGE)
         {
            this.invalidate(INVALIDATION_FLAG_SIZE);
         }
         this.stage.addEventListener(Event.RESIZE,this.stage_resizeHandler);
      }
      
      protected function screenNavigator_removedFromStageHandler(param1:Event) : void
      {
         this.stage.removeEventListener(Event.RESIZE,this.stage_resizeHandler);
      }
      
      protected function activeScreen_resizeHandler(param1:Event) : void
      {
         if(this._isValidating || this._autoSizeMode != AutoSizeMode.CONTENT)
         {
            return;
         }
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
      
      protected function stage_resizeHandler(param1:Event) : void
      {
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
      
      protected function screen_transitionDelayHandler(param1:Event) : void
      {
         this._activeScreen.removeEventListener(param1.type,this.screen_transitionDelayHandler);
         var _loc2_:Boolean = this._waitingForDelayedTransition;
         this._waitingForDelayedTransition = false;
         if(_loc2_)
         {
            return;
         }
         var _loc3_:Function = this._delayedTransition;
         this._delayedTransition = null;
         this.startTransition(_loc3_);
      }
      
      private function waitingForTransition_enterFrameHandler(param1:Event) : void
      {
         if(this._waitingForTransitionFrameCount < 2)
         {
            ++this._waitingForTransitionFrameCount;
            return;
         }
         this.startWaitingTransition();
      }
   }
}

