package feathers.controls
{
   import feathers.controls.popups.CalloutPopUpContentManager;
   import feathers.controls.popups.DropDownPopUpContentManager;
   import feathers.controls.popups.IPersistentPopUpContentManager;
   import feathers.controls.popups.IPopUpContentManager;
   import feathers.controls.popups.IPopUpContentManagerWithPrompt;
   import feathers.controls.popups.VerticalCenteredPopUpContentManager;
   import feathers.core.FeathersControl;
   import feathers.core.IFocusDisplayObject;
   import feathers.core.ITextBaselineControl;
   import feathers.core.IToggle;
   import feathers.core.PropertyProxy;
   import feathers.data.IListCollection;
   import feathers.events.CollectionEventType;
   import feathers.events.FeathersEventType;
   import feathers.skins.IStyleProvider;
   import feathers.system.DeviceCapabilities;
   import flash.ui.Keyboard;
   import starling.core.Starling;
   import starling.events.Event;
   import starling.events.EventDispatcher;
   import starling.events.KeyboardEvent;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.SystemUtil;
   
   public class PickerList extends FeathersControl implements IFocusDisplayObject, ITextBaselineControl
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      protected static const INVALIDATION_FLAG_BUTTON_FACTORY:String = "buttonFactory";
      
      protected static const INVALIDATION_FLAG_LIST_FACTORY:String = "listFactory";
      
      public static const DEFAULT_CHILD_STYLE_NAME_BUTTON:String = "feathers-picker-list-button";
      
      public static const DEFAULT_CHILD_STYLE_NAME_LIST:String = "feathers-picker-list-list";
      
      protected var buttonStyleName:String = "feathers-picker-list-button";
      
      protected var listStyleName:String = "feathers-picker-list-list";
      
      protected var button:Button;
      
      protected var list:List;
      
      protected var buttonExplicitWidth:Number;
      
      protected var buttonExplicitHeight:Number;
      
      protected var buttonExplicitMinWidth:Number;
      
      protected var buttonExplicitMinHeight:Number;
      
      protected var _dataProvider:IListCollection;
      
      protected var _ignoreSelectionChanges:Boolean = false;
      
      protected var _selectedIndex:int = -1;
      
      protected var _prompt:String;
      
      protected var _labelField:String = "label";
      
      protected var _labelFunction:Function;
      
      protected var _popUpContentManager:IPopUpContentManager;
      
      protected var _typicalItem:Object = null;
      
      protected var _buttonFactory:Function;
      
      protected var _customButtonStyleName:String;
      
      protected var _buttonProperties:PropertyProxy;
      
      protected var _listFactory:Function;
      
      protected var _customListStyleName:String;
      
      protected var _listProperties:PropertyProxy;
      
      protected var _toggleButtonOnOpenAndClose:Boolean = false;
      
      protected var _itemRendererFactory:Function = null;
      
      protected var _customItemRendererStyleName:String;
      
      protected var _triggered:Boolean = false;
      
      protected var _isOpenListPending:Boolean = false;
      
      protected var _isCloseListPending:Boolean = false;
      
      protected var _buttonHasFocus:Boolean = false;
      
      protected var _buttonTouchPointID:int = -1;
      
      protected var _listIsOpenOnTouchBegan:Boolean = false;
      
      public function PickerList()
      {
         super();
      }
      
      protected static function defaultButtonFactory() : Button
      {
         return new Button();
      }
      
      protected static function defaultListFactory() : List
      {
         return new List();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return PickerList.globalStyleProvider;
      }
      
      public function get dataProvider() : IListCollection
      {
         return this._dataProvider;
      }
      
      public function set dataProvider(param1:IListCollection) : void
      {
         if(this._dataProvider == param1)
         {
            return;
         }
         var _loc2_:int = this.selectedIndex;
         var _loc3_:Object = this.selectedItem;
         if(this._dataProvider)
         {
            this._dataProvider.removeEventListener(CollectionEventType.RESET,this.dataProvider_multipleEventHandler);
            this._dataProvider.removeEventListener(CollectionEventType.ADD_ITEM,this.dataProvider_multipleEventHandler);
            this._dataProvider.removeEventListener(CollectionEventType.REMOVE_ITEM,this.dataProvider_multipleEventHandler);
            this._dataProvider.removeEventListener(CollectionEventType.REMOVE_ALL,this.dataProvider_multipleEventHandler);
            this._dataProvider.removeEventListener(CollectionEventType.REPLACE_ITEM,this.dataProvider_multipleEventHandler);
            this._dataProvider.removeEventListener(CollectionEventType.UPDATE_ITEM,this.dataProvider_updateItemHandler);
         }
         this._dataProvider = param1;
         if(this._dataProvider)
         {
            this._dataProvider.addEventListener(CollectionEventType.RESET,this.dataProvider_multipleEventHandler);
            this._dataProvider.addEventListener(CollectionEventType.ADD_ITEM,this.dataProvider_multipleEventHandler);
            this._dataProvider.addEventListener(CollectionEventType.REMOVE_ITEM,this.dataProvider_multipleEventHandler);
            this._dataProvider.addEventListener(CollectionEventType.REMOVE_ALL,this.dataProvider_multipleEventHandler);
            this._dataProvider.addEventListener(CollectionEventType.REPLACE_ITEM,this.dataProvider_multipleEventHandler);
            this._dataProvider.addEventListener(CollectionEventType.UPDATE_ITEM,this.dataProvider_updateItemHandler);
         }
         if(!this._dataProvider || this._dataProvider.length == 0)
         {
            this.selectedIndex = -1;
         }
         else
         {
            this.selectedIndex = 0;
         }
         if(this.selectedIndex == _loc2_ && this.selectedItem != _loc3_)
         {
            this.dispatchEventWith(Event.CHANGE);
         }
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get selectedIndex() : int
      {
         return this._selectedIndex;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         if(this._selectedIndex == param1)
         {
            return;
         }
         this._selectedIndex = param1;
         this.invalidate(INVALIDATION_FLAG_SELECTED);
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get selectedItem() : Object
      {
         if(!this._dataProvider || this._selectedIndex < 0 || this._selectedIndex >= this._dataProvider.length)
         {
            return null;
         }
         return this._dataProvider.getItemAt(this._selectedIndex);
      }
      
      public function set selectedItem(param1:Object) : void
      {
         if(!this._dataProvider)
         {
            this.selectedIndex = -1;
            return;
         }
         this.selectedIndex = this._dataProvider.getItemIndex(param1);
      }
      
      public function get prompt() : String
      {
         return this._prompt;
      }
      
      public function set prompt(param1:String) : void
      {
         if(this._prompt == param1)
         {
            return;
         }
         this._prompt = param1;
         this.invalidate(INVALIDATION_FLAG_SELECTED);
      }
      
      public function get labelField() : String
      {
         return this._labelField;
      }
      
      public function set labelField(param1:String) : void
      {
         if(this._labelField == param1)
         {
            return;
         }
         this._labelField = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get labelFunction() : Function
      {
         return this._labelFunction;
      }
      
      public function set labelFunction(param1:Function) : void
      {
         this._labelFunction = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
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
      
      public function get typicalItem() : Object
      {
         return this._typicalItem;
      }
      
      public function set typicalItem(param1:Object) : void
      {
         if(this._typicalItem == param1)
         {
            return;
         }
         this._typicalItem = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get buttonFactory() : Function
      {
         return this._buttonFactory;
      }
      
      public function set buttonFactory(param1:Function) : void
      {
         if(this._buttonFactory == param1)
         {
            return;
         }
         this._buttonFactory = param1;
         this.invalidate(INVALIDATION_FLAG_BUTTON_FACTORY);
      }
      
      public function get customButtonStyleName() : String
      {
         return this._customButtonStyleName;
      }
      
      public function set customButtonStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customButtonStyleName === param1)
         {
            return;
         }
         this._customButtonStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_BUTTON_FACTORY);
      }
      
      public function get buttonProperties() : Object
      {
         if(!this._buttonProperties)
         {
            this._buttonProperties = new PropertyProxy(this.childProperties_onChange);
         }
         return this._buttonProperties;
      }
      
      public function set buttonProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         var _loc3_:String = null;
         if(this._buttonProperties == param1)
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
         if(this._buttonProperties)
         {
            this._buttonProperties.removeOnChangeCallback(this.childProperties_onChange);
         }
         this._buttonProperties = PropertyProxy(param1);
         if(this._buttonProperties)
         {
            this._buttonProperties.addOnChangeCallback(this.childProperties_onChange);
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
            this._listProperties = new PropertyProxy(this.childProperties_onChange);
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
            this._listProperties.removeOnChangeCallback(this.childProperties_onChange);
         }
         this._listProperties = PropertyProxy(param1);
         if(this._listProperties)
         {
            this._listProperties.addOnChangeCallback(this.childProperties_onChange);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get toggleButtonOnOpenAndClose() : Boolean
      {
         return this._toggleButtonOnOpenAndClose;
      }
      
      public function set toggleButtonOnOpenAndClose(param1:Boolean) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._toggleButtonOnOpenAndClose === param1)
         {
            return;
         }
         this._toggleButtonOnOpenAndClose = param1;
         if(this.button is IToggle)
         {
            if(this._toggleButtonOnOpenAndClose && this._popUpContentManager.isOpen)
            {
               IToggle(this.button).isSelected = true;
            }
            else
            {
               IToggle(this.button).isSelected = false;
            }
         }
      }
      
      public function get itemRendererFactory() : Function
      {
         return this._itemRendererFactory;
      }
      
      public function set itemRendererFactory(param1:Function) : void
      {
         if(this._itemRendererFactory === param1)
         {
            return;
         }
         this._itemRendererFactory = param1;
         this.invalidate(INVALIDATION_FLAG_LIST_FACTORY);
      }
      
      public function get customItemRendererStyleName() : String
      {
         return this._customItemRendererStyleName;
      }
      
      public function set customItemRendererStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customItemRendererStyleName === param1)
         {
            return;
         }
         this._customItemRendererStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_LIST_FACTORY);
      }
      
      public function get baseline() : Number
      {
         if(!this.button)
         {
            return this.scaledActualHeight;
         }
         return this.scaleY * (this.button.y + this.button.baseline);
      }
      
      public function itemToLabel(param1:Object) : String
      {
         var _loc2_:Object = null;
         if(this._labelFunction !== null)
         {
            _loc2_ = this._labelFunction(param1);
            if(_loc2_ is String)
            {
               return _loc2_ as String;
            }
            if(_loc2_ !== null)
            {
               return _loc2_.toString();
            }
         }
         else if(this._labelField !== null && param1 !== null && param1.hasOwnProperty(this._labelField))
         {
            _loc2_ = param1[this._labelField];
            if(_loc2_ is String)
            {
               return _loc2_ as String;
            }
            if(_loc2_ !== null)
            {
               return _loc2_.toString();
            }
         }
         else
         {
            if(param1 is String)
            {
               return param1 as String;
            }
            if(param1 !== null)
            {
               return param1.toString();
            }
         }
         return null;
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
         if(this._popUpContentManager is IPopUpContentManagerWithPrompt)
         {
            IPopUpContentManagerWithPrompt(this._popUpContentManager).prompt = this._prompt;
         }
         this._popUpContentManager.open(this.list,this);
         this.list.scrollToDisplayIndex(this._selectedIndex);
         this.list.validate();
         if(this.list.focusManager)
         {
            this.list.focusManager.focus = this.list;
            this.stage.addEventListener(KeyboardEvent.KEY_UP,this.stage_keyUpHandler);
            this.list.addEventListener(FeathersEventType.FOCUS_OUT,this.list_focusOutHandler);
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
         this._isCloseListPending = false;
         this.list.validate();
         this._popUpContentManager.close();
      }
      
      override public function dispose() : void
      {
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
         this._selectedIndex = -1;
         this.dataProvider = null;
         super.dispose();
      }
      
      override public function showFocus() : void
      {
         if(!this.button)
         {
            return;
         }
         this.button.showFocus();
      }
      
      override public function hideFocus() : void
      {
         if(!this.button)
         {
            return;
         }
         this.button.hideFocus();
      }
      
      override protected function initialize() : void
      {
         var _loc1_:Starling = null;
         var _loc2_:IPopUpContentManager = null;
         if(this._popUpContentManager === null)
         {
            _loc1_ = this.stage !== null ? this.stage.starling : Starling.current;
            if(SystemUtil.isDesktop)
            {
               _loc2_ = new DropDownPopUpContentManager();
            }
            else if(DeviceCapabilities.isTablet(_loc1_.nativeStage))
            {
               _loc2_ = new CalloutPopUpContentManager();
            }
            else
            {
               _loc2_ = new VerticalCenteredPopUpContentManager();
            }
            this.ignoreNextStyleRestriction();
            this.popUpContentManager = _loc2_;
         }
         super.initialize();
      }
      
      override protected function draw() : void
      {
         var _loc8_:Boolean = false;
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         var _loc4_:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
         var _loc5_:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
         var _loc6_:Boolean = this.isInvalid(INVALIDATION_FLAG_BUTTON_FACTORY);
         var _loc7_:Boolean = this.isInvalid(INVALIDATION_FLAG_LIST_FACTORY);
         if(_loc6_)
         {
            this.createButton();
         }
         if(_loc7_)
         {
            this.createList();
         }
         if(_loc6_ || _loc2_ || _loc4_)
         {
            if(this._explicitWidth !== this._explicitWidth)
            {
               this.button.width = NaN;
            }
            if(this._explicitHeight !== this._explicitHeight)
            {
               this.button.height = NaN;
            }
         }
         if(_loc6_ || _loc2_)
         {
            this.refreshButtonProperties();
         }
         if(_loc7_ || _loc2_)
         {
            this.refreshListProperties();
         }
         if(_loc7_ || _loc1_)
         {
            _loc8_ = this._ignoreSelectionChanges;
            this._ignoreSelectionChanges = true;
            this.list.dataProvider = this._dataProvider;
            this._ignoreSelectionChanges = _loc8_;
         }
         if(_loc6_ || _loc7_ || _loc3_)
         {
            this.button.isEnabled = this._isEnabled;
            this.list.isEnabled = this._isEnabled;
         }
         if(_loc6_ || _loc1_ || _loc4_)
         {
            this.refreshButtonLabel();
         }
         if(_loc7_ || _loc1_ || _loc4_)
         {
            _loc8_ = this._ignoreSelectionChanges;
            this._ignoreSelectionChanges = true;
            this.list.selectedIndex = this._selectedIndex;
            this._ignoreSelectionChanges = _loc8_;
         }
         this.autoSizeIfNeeded();
         this.layout();
         if(this.list.stage)
         {
            this.list.validate();
         }
         this.handlePendingActions();
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
         var _loc5_:Number = this._explicitWidth;
         if(_loc5_ !== _loc5_)
         {
            _loc5_ = this.buttonExplicitWidth;
         }
         var _loc6_:Number = this._explicitHeight;
         if(_loc6_ !== _loc6_)
         {
            _loc6_ = this.buttonExplicitHeight;
         }
         var _loc7_:Number = this._explicitMinWidth;
         if(_loc7_ !== _loc7_)
         {
            _loc7_ = this.buttonExplicitMinWidth;
         }
         var _loc8_:Number = this._explicitMinHeight;
         if(_loc8_ !== _loc8_)
         {
            _loc8_ = this.buttonExplicitMinHeight;
         }
         if(this._typicalItem !== null)
         {
            this.button.label = this.itemToLabel(this._typicalItem);
         }
         this.button.width = _loc5_;
         this.button.height = _loc6_;
         this.button.minWidth = _loc7_;
         this.button.minHeight = _loc8_;
         this.button.validate();
         if(this._typicalItem !== null)
         {
            this.refreshButtonLabel();
         }
         var _loc9_:Number = this._explicitWidth;
         var _loc10_:Number = this._explicitHeight;
         var _loc11_:Number = this._explicitMinWidth;
         var _loc12_:Number = this._explicitMinHeight;
         if(_loc1_)
         {
            _loc9_ = this.button.width;
         }
         if(_loc2_)
         {
            _loc10_ = this.button.height;
         }
         if(_loc3_)
         {
            _loc11_ = this.button.minWidth;
         }
         if(_loc4_)
         {
            _loc12_ = this.button.minHeight;
         }
         return this.saveMeasurements(_loc9_,_loc10_,_loc11_,_loc12_);
      }
      
      protected function createButton() : void
      {
         if(this.button)
         {
            this.button.removeFromParent(true);
            this.button = null;
         }
         var _loc1_:Function = this._buttonFactory != null ? this._buttonFactory : defaultButtonFactory;
         var _loc2_:String = this._customButtonStyleName != null ? this._customButtonStyleName : this.buttonStyleName;
         this.button = Button(_loc1_());
         if(this.button is ToggleButton)
         {
            ToggleButton(this.button).isToggle = false;
         }
         this.button.styleNameList.add(_loc2_);
         this.button.addEventListener(TouchEvent.TOUCH,this.button_touchHandler);
         this.button.addEventListener(Event.TRIGGERED,this.button_triggeredHandler);
         this.addChild(this.button);
         this.button.initializeNow();
         this.buttonExplicitWidth = this.button.explicitWidth;
         this.buttonExplicitHeight = this.button.explicitHeight;
         this.buttonExplicitMinWidth = this.button.explicitMinWidth;
         this.buttonExplicitMinHeight = this.button.explicitMinHeight;
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
         this.list.styleNameList.add(_loc2_);
         if(this._customItemRendererStyleName !== null)
         {
            this.list.customItemRendererStyleName = this._customItemRendererStyleName;
         }
         if(this._itemRendererFactory !== null)
         {
            this.list.itemRendererFactory = this._itemRendererFactory;
         }
         this.list.addEventListener(Event.CHANGE,this.list_changeHandler);
         this.list.addEventListener(Event.TRIGGERED,this.list_triggeredHandler);
         this.list.addEventListener(TouchEvent.TOUCH,this.list_touchHandler);
         this.list.addEventListener(Event.REMOVED_FROM_STAGE,this.list_removedFromStageHandler);
      }
      
      protected function refreshButtonLabel() : void
      {
         if(this._selectedIndex >= 0)
         {
            this.button.label = this.itemToLabel(this.selectedItem);
         }
         else
         {
            this.button.label = this._prompt;
         }
      }
      
      protected function refreshButtonProperties() : void
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         for(_loc1_ in this._buttonProperties)
         {
            _loc2_ = this._buttonProperties[_loc1_];
            this.button[_loc1_] = _loc2_;
         }
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
      
      protected function layout() : void
      {
         this.button.width = this.actualWidth;
         this.button.height = this.actualHeight;
         this.button.validate();
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
         super.focusInHandler(param1);
         this._buttonHasFocus = true;
         this.button.dispatchEventWith(FeathersEventType.FOCUS_IN);
      }
      
      override protected function focusOutHandler(param1:Event) : void
      {
         if(this._buttonHasFocus)
         {
            this.button.dispatchEventWith(FeathersEventType.FOCUS_OUT);
            this._buttonHasFocus = false;
         }
         super.focusOutHandler(param1);
      }
      
      protected function childProperties_onChange(param1:PropertyProxy, param2:String) : void
      {
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      protected function button_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         if(this._buttonTouchPointID >= 0)
         {
            _loc2_ = param1.getTouch(this.button,TouchPhase.ENDED,this._buttonTouchPointID);
            if(!_loc2_)
            {
               return;
            }
            this._buttonTouchPointID = -1;
            this._listIsOpenOnTouchBegan = false;
         }
         else
         {
            _loc2_ = param1.getTouch(this.button,TouchPhase.BEGAN);
            if(!_loc2_)
            {
               return;
            }
            this._buttonTouchPointID = _loc2_.id;
            this._listIsOpenOnTouchBegan = this._popUpContentManager.isOpen;
         }
      }
      
      protected function button_triggeredHandler(param1:Event) : void
      {
         if(Boolean(this._focusManager) && this._listIsOpenOnTouchBegan)
         {
            return;
         }
         if(this._popUpContentManager.isOpen)
         {
            this.closeList();
            return;
         }
         this.openList();
      }
      
      protected function list_changeHandler(param1:Event) : void
      {
         if(this._ignoreSelectionChanges || this._popUpContentManager is IPersistentPopUpContentManager)
         {
            return;
         }
         this.selectedIndex = this.list.selectedIndex;
      }
      
      protected function popUpContentManager_openHandler(param1:Event) : void
      {
         if(this._toggleButtonOnOpenAndClose && this.button is IToggle)
         {
            IToggle(this.button).isSelected = true;
         }
         this.list.revealScrollBars();
         this.dispatchEventWith(Event.OPEN);
      }
      
      protected function popUpContentManager_closeHandler(param1:Event) : void
      {
         if(this._popUpContentManager is IPersistentPopUpContentManager)
         {
            this.selectedIndex = this.list.selectedIndex;
         }
         if(this._toggleButtonOnOpenAndClose && this.button is IToggle)
         {
            IToggle(this.button).isSelected = false;
         }
         this.dispatchEventWith(Event.CLOSE);
      }
      
      protected function list_removedFromStageHandler(param1:Event) : void
      {
         if(this._focusManager)
         {
            this.list.stage.removeEventListener(KeyboardEvent.KEY_UP,this.stage_keyUpHandler);
            this.list.removeEventListener(FeathersEventType.FOCUS_OUT,this.list_focusOutHandler);
         }
      }
      
      protected function list_focusOutHandler(param1:Event) : void
      {
         if(!this._popUpContentManager.isOpen)
         {
            return;
         }
         this.closeList();
      }
      
      protected function list_triggeredHandler(param1:Event) : void
      {
         if(!this._isEnabled || this._popUpContentManager is IPersistentPopUpContentManager)
         {
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
            this._triggered = false;
         }
         if(_loc2_.phase === TouchPhase.ENDED && this._triggered)
         {
            this.closeList();
         }
      }
      
      protected function dataProvider_multipleEventHandler(param1:Event) : void
      {
         this.validate();
      }
      
      protected function dataProvider_updateItemHandler(param1:Event, param2:int) : void
      {
         if(param2 == this._selectedIndex)
         {
            this.invalidate(INVALIDATION_FLAG_SELECTED);
         }
      }
      
      protected function stage_keyUpHandler(param1:KeyboardEvent) : void
      {
         if(!this._popUpContentManager.isOpen)
         {
            return;
         }
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.closeList();
         }
      }
   }
}

