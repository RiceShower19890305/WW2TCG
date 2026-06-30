package feathers.controls
{
   import feathers.controls.popups.DropDownPopUpContentManager;
   import feathers.controls.popups.IPopUpContentManager;
   import feathers.core.PropertyProxy;
   import feathers.data.ArrayCollection;
   import feathers.data.IAutoCompleteSource;
   import feathers.data.IListCollection;
   import feathers.events.FeathersEventType;
   import feathers.skins.IStyleProvider;
   import feathers.utils.display.getDisplayObjectDepthFromStage;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import flash.utils.getTimer;
   import starling.events.Event;
   import starling.events.EventDispatcher;
   import starling.events.KeyboardEvent;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   
   public class AutoComplete extends TextInput
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      protected static const INVALIDATION_FLAG_LIST_FACTORY:String = "listFactory";
      
      public static const DEFAULT_CHILD_STYLE_NAME_LIST:String = "feathers-auto-complete-list";
      
      protected var listStyleName:String = "feathers-auto-complete-list";
      
      protected var list:List;
      
      protected var _listCollection:IListCollection;
      
      protected var _originalText:String;
      
      protected var _source:IAutoCompleteSource;
      
      protected var _autoCompleteDelay:Number = 0.5;
      
      protected var _minimumAutoCompleteLength:int = 2;
      
      protected var _popUpContentManager:IPopUpContentManager;
      
      protected var _listFactory:Function;
      
      protected var _customListStyleName:String;
      
      protected var _listProperties:PropertyProxy;
      
      protected var _ignoreAutoCompleteChanges:Boolean = false;
      
      protected var _lastChangeTime:int = 0;
      
      protected var _listHasFocus:Boolean = false;
      
      protected var _listTouchPointID:int = -1;
      
      protected var _triggered:Boolean = false;
      
      protected var _isOpenListPending:Boolean = false;
      
      protected var _isCloseListPending:Boolean = false;
      
      public function AutoComplete()
      {
         super();
         this.addEventListener(Event.CHANGE,this.autoComplete_changeHandler);
      }
      
      protected static function defaultListFactory() : List
      {
         return new List();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         if(AutoComplete.globalStyleProvider)
         {
            return AutoComplete.globalStyleProvider;
         }
         return TextInput.globalStyleProvider;
      }
      
      public function get source() : IAutoCompleteSource
      {
         return this._source;
      }
      
      public function set source(param1:IAutoCompleteSource) : void
      {
         if(this._source == param1)
         {
            return;
         }
         if(this._source)
         {
            this._source.removeEventListener(Event.COMPLETE,this.dataProvider_completeHandler);
         }
         this._source = param1;
         if(this._source)
         {
            this._source.addEventListener(Event.COMPLETE,this.dataProvider_completeHandler);
         }
      }
      
      public function get autoCompleteDelay() : Number
      {
         return this._autoCompleteDelay;
      }
      
      public function set autoCompleteDelay(param1:Number) : void
      {
         this._autoCompleteDelay = param1;
      }
      
      public function get minimumAutoCompleteLength() : Number
      {
         return this._minimumAutoCompleteLength;
      }
      
      public function set minimumAutoCompleteLength(param1:Number) : void
      {
         this._minimumAutoCompleteLength = param1;
      }
      
      public function get popUpContentManager() : IPopUpContentManager
      {
         return this._popUpContentManager;
      }
      
      public function set popUpContentManager(param1:IPopUpContentManager) : void
      {
         var _loc3_:EventDispatcher = null;
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._popUpContentManager === param1)
         {
            return;
         }
         if(this._popUpContentManager is EventDispatcher)
         {
            _loc3_ = EventDispatcher(this._popUpContentManager);
            _loc3_.removeEventListener(Event.OPEN,this.popUpContentManager_openHandler);
            _loc3_.removeEventListener(Event.CLOSE,this.popUpContentManager_closeHandler);
         }
         this._popUpContentManager = param1;
         if(this._popUpContentManager is EventDispatcher)
         {
            _loc3_ = EventDispatcher(this._popUpContentManager);
            _loc3_.addEventListener(Event.OPEN,this.popUpContentManager_openHandler);
            _loc3_.addEventListener(Event.CLOSE,this.popUpContentManager_closeHandler);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get listFactory() : Function
      {
         return this._listFactory;
      }
      
      public function set listFactory(param1:Function) : void
      {
         if(this._listFactory == param1)
         {
            return;
         }
         this._listFactory = param1;
         this.invalidate(INVALIDATION_FLAG_LIST_FACTORY);
      }
      
      public function get customListStyleName() : String
      {
         return this._customListStyleName;
      }
      
      public function set customListStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customListStyleName === param1)
         {
            return;
         }
         this._customListStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_LIST_FACTORY);
      }
      
      public function get listProperties() : Object
      {
         if(!this._listProperties)
         {
            this._listProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._listProperties;
      }
      
      public function set listProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         var _loc3_:String = null;
         if(this._listProperties == param1)
         {
            return;
         }
         if(!param1)
         {
            param1 = new PropertyProxy();
         }
         if(!(param1 is PropertyProxy))
         {
            _loc2_ = new PropertyProxy();
            for(_loc3_ in param1)
            {
               _loc2_[_loc3_] = param1[_loc3_];
            }
            param1 = _loc2_;
         }
         if(this._listProperties)
         {
            this._listProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._listProperties = PropertyProxy(param1);
         if(this._listProperties)
         {
            this._listProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function openList() : void
      {
         this._isCloseListPending = false;
         if(this._popUpContentManager.isOpen)
         {
            return;
         }
         if(!this._isValidating && this.isInvalid())
         {
            this._isOpenListPending = true;
            return;
         }
         this._isOpenListPending = false;
         this._popUpContentManager.open(this.list,this);
         this.list.validate();
         if(this._focusManager)
         {
            this.stage.addEventListener(starling.events.KeyboardEvent.KEY_UP,this.stage_keyUpHandler);
         }
      }
      
      public function closeList() : void
      {
         this._isOpenListPending = false;
         if(!this._popUpContentManager.isOpen)
         {
            return;
         }
         if(!this._isValidating && this.isInvalid())
         {
            this._isCloseListPending = true;
            return;
         }
         if(this._listHasFocus)
         {
            this.list.dispatchEventWith(FeathersEventType.FOCUS_OUT);
         }
         this._isCloseListPending = false;
         this.list.validate();
         this._popUpContentManager.close();
      }
      
      override public function dispose() : void
      {
         this.source = null;
         if(this.list)
         {
            this.closeList();
            this.list.dispose();
            this.list = null;
         }
         if(this._popUpContentManager)
         {
            this._popUpContentManager.dispose();
            this._popUpContentManager = null;
         }
         super.dispose();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this._listCollection = new ArrayCollection();
         if(this._popUpContentManager === null)
         {
            this.ignoreNextStyleRestriction();
            this.popUpContentManager = new DropDownPopUpContentManager();
         }
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_LIST_FACTORY);
         super.draw();
         if(_loc2_)
         {
            this.createList();
         }
         if(_loc2_ || _loc1_)
         {
            this.refreshListProperties();
         }
         this.handlePendingActions();
      }
      
      protected function createList() : void
      {
         if(this.list)
         {
            this.list.removeFromParent(false);
            this.list.dispose();
            this.list = null;
         }
         var _loc1_:Function = this._listFactory != null ? this._listFactory : defaultListFactory;
         var _loc2_:String = this._customListStyleName != null ? this._customListStyleName : this.listStyleName;
         this.list = List(_loc1_());
         this.list.focusOwner = this;
         this.list.isFocusEnabled = false;
         this.list.isChildFocusEnabled = false;
         this.list.styleNameList.add(_loc2_);
         this.list.addEventListener(Event.CHANGE,this.list_changeHandler);
         this.list.addEventListener(Event.TRIGGERED,this.list_triggeredHandler);
         this.list.addEventListener(TouchEvent.TOUCH,this.list_touchHandler);
         this.list.addEventListener(Event.REMOVED_FROM_STAGE,this.list_removedFromStageHandler);
      }
      
      protected function refreshListProperties() : void
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         for(_loc1_ in this._listProperties)
         {
            _loc2_ = this._listProperties[_loc1_];
            this.list[_loc1_] = _loc2_;
         }
      }
      
      protected function handlePendingActions() : void
      {
         if(this._isOpenListPending)
         {
            this.openList();
         }
         if(this._isCloseListPending)
         {
            this.closeList();
         }
      }
      
      override protected function focusInHandler(param1:Event) : void
      {
         var _loc2_:int = -getDisplayObjectDepthFromStage(this);
         this.stage.starling.nativeStage.addEventListener(flash.events.KeyboardEvent.KEY_DOWN,this.nativeStage_keyDownHandler,false,_loc2_,true);
         super.focusInHandler(param1);
      }
      
      override protected function focusOutHandler(param1:Event) : void
      {
         this.stage.starling.nativeStage.removeEventListener(flash.events.KeyboardEvent.KEY_DOWN,this.nativeStage_keyDownHandler);
         super.focusOutHandler(param1);
      }
      
      protected function nativeStage_keyDownHandler(param1:flash.events.KeyboardEvent) : void
      {
         var _loc6_:Boolean = false;
         if(!this._popUpContentManager.isOpen)
         {
            return;
         }
         if(param1.isDefaultPrevented())
         {
            return;
         }
         var _loc2_:Boolean = param1.keyCode == Keyboard.DOWN;
         var _loc3_:Boolean = param1.keyCode == Keyboard.UP;
         if(!_loc2_ && !_loc3_)
         {
            return;
         }
         var _loc4_:int = this.list.selectedIndex;
         var _loc5_:int = this.list.dataProvider.length - 1;
         if(_loc4_ < 0)
         {
            param1.preventDefault();
            this._originalText = this._text;
            if(_loc2_)
            {
               this.list.selectedIndex = 0;
            }
            else
            {
               this.list.selectedIndex = _loc5_;
            }
            this.list.scrollToDisplayIndex(this.list.selectedIndex,this.list.keyScrollDuration);
            this._listHasFocus = true;
            this.list.dispatchEventWith(FeathersEventType.FOCUS_IN);
         }
         else if(_loc2_ && _loc4_ == _loc5_ || _loc3_ && _loc4_ == 0)
         {
            param1.preventDefault();
            _loc6_ = this._ignoreAutoCompleteChanges;
            this._ignoreAutoCompleteChanges = true;
            this.text = this._originalText;
            this._ignoreAutoCompleteChanges = _loc6_;
            this.list.selectedIndex = -1;
            this.selectRange(this.text.length,this.text.length);
            this._listHasFocus = false;
            this.list.dispatchEventWith(FeathersEventType.FOCUS_OUT);
         }
      }
      
      protected function autoComplete_changeHandler(param1:Event) : void
      {
         if(this._ignoreAutoCompleteChanges || !this._source || !this.hasFocus)
         {
            return;
         }
         if(this.text.length < this._minimumAutoCompleteLength)
         {
            this.removeEventListener(Event.ENTER_FRAME,this.autoComplete_enterFrameHandler);
            this.closeList();
            return;
         }
         if(this._autoCompleteDelay == 0)
         {
            this.removeEventListener(Event.ENTER_FRAME,this.autoComplete_enterFrameHandler);
            this._source.load(this.text,this._listCollection);
         }
         else
         {
            this._lastChangeTime = getTimer();
            this.addEventListener(Event.ENTER_FRAME,this.autoComplete_enterFrameHandler);
         }
      }
      
      protected function autoComplete_enterFrameHandler() : void
      {
         var _loc1_:int = getTimer();
         var _loc2_:Number = (_loc1_ - this._lastChangeTime) / 1000;
         if(_loc2_ < this._autoCompleteDelay)
         {
            return;
         }
         this.removeEventListener(Event.ENTER_FRAME,this.autoComplete_enterFrameHandler);
         this._source.load(this.text,this._listCollection);
      }
      
      protected function dataProvider_completeHandler(param1:Event, param2:IListCollection) : void
      {
         this.list.dataProvider = param2;
         if(param2.length == 0)
         {
            if(this._popUpContentManager.isOpen)
            {
               this.closeList();
            }
            return;
         }
         this.openList();
      }
      
      protected function list_changeHandler(param1:Event) : void
      {
         if(!this.list.selectedItem)
         {
            return;
         }
         var _loc2_:Boolean = this._ignoreAutoCompleteChanges;
         this._ignoreAutoCompleteChanges = true;
         this.text = this.list.selectedItem.toString();
         this.selectRange(this.text.length,this.text.length);
         this._ignoreAutoCompleteChanges = _loc2_;
      }
      
      protected function popUpContentManager_openHandler(param1:Event) : void
      {
         this.dispatchEventWith(Event.OPEN);
      }
      
      protected function popUpContentManager_closeHandler(param1:Event) : void
      {
         this.dispatchEventWith(Event.CLOSE);
      }
      
      protected function list_removedFromStageHandler(param1:Event) : void
      {
         if(this._focusManager)
         {
            this.list.stage.removeEventListener(starling.events.KeyboardEvent.KEY_UP,this.stage_keyUpHandler);
         }
      }
      
      protected function list_triggeredHandler(param1:Event) : void
      {
         if(!this._isEnabled)
         {
            return;
         }
         if(this._listTouchPointID == -1)
         {
            this.closeList();
            this.selectRange(this.text.length,this.text.length);
            return;
         }
         this._triggered = true;
      }
      
      protected function list_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this.list);
         if(_loc2_ === null)
         {
            return;
         }
         if(_loc2_.phase === TouchPhase.BEGAN)
         {
            this._listTouchPointID = _loc2_.id;
            this._triggered = false;
         }
         if(_loc2_.phase === TouchPhase.ENDED && this._triggered)
         {
            this._listTouchPointID = -1;
            this.closeList();
            this.selectRange(this.text.length,this.text.length);
         }
      }
      
      protected function stage_keyUpHandler(param1:starling.events.KeyboardEvent) : void
      {
         if(!this._popUpContentManager.isOpen)
         {
            return;
         }
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.closeList();
            this.selectRange(this.text.length,this.text.length);
         }
      }
   }
}

