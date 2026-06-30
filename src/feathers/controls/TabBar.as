package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.IFocusDisplayObject;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.ITextBaselineControl;
   import feathers.core.IValidating;
   import feathers.core.PropertyProxy;
   import feathers.core.ToggleGroup;
   import feathers.data.IListCollection;
   import feathers.dragDrop.DragData;
   import feathers.dragDrop.DragDropManager;
   import feathers.dragDrop.IDragSource;
   import feathers.dragDrop.IDropTarget;
   import feathers.events.CollectionEventType;
   import feathers.events.DragDropEvent;
   import feathers.events.ExclusiveTouch;
   import feathers.events.FeathersEventType;
   import feathers.layout.Direction;
   import feathers.layout.HorizontalAlign;
   import feathers.layout.HorizontalLayout;
   import feathers.layout.LayoutBoundsResult;
   import feathers.layout.VerticalAlign;
   import feathers.layout.VerticalLayout;
   import feathers.layout.ViewPortBounds;
   import feathers.skins.IStyleProvider;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import starling.events.KeyboardEvent;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Pool;
   
   public class TabBar extends FeathersControl implements IFocusDisplayObject, ITextBaselineControl, IDragSource, IDropTarget
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      protected static const INVALIDATION_FLAG_TAB_FACTORY:String = "tabFactory";
      
      private static const DEFAULT_TAB_FIELDS:Vector.<String> = new <String>["upIcon","downIcon","hoverIcon","disabledIcon","defaultSelectedIcon","selectedUpIcon","selectedDownIcon","selectedHoverIcon","selectedDisabledIcon","name"];
      
      protected static const DEFAULT_DRAG_FORMAT:String = "feathers-tab-bar-item";
      
      public static const DEFAULT_CHILD_STYLE_NAME_TAB:String = "feathers-tab-bar-tab";
      
      protected var tabStyleName:String = "feathers-tab-bar-tab";
      
      protected var firstTabStyleName:String = "feathers-tab-bar-tab";
      
      protected var lastTabStyleName:String = "feathers-tab-bar-tab";
      
      protected var toggleGroup:ToggleGroup;
      
      protected var activeFirstTab:ToggleButton;
      
      protected var inactiveFirstTab:ToggleButton;
      
      protected var activeLastTab:ToggleButton;
      
      protected var inactiveLastTab:ToggleButton;
      
      protected var _layoutItems:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
      
      protected var activeTabs:Vector.<ToggleButton> = new Vector.<ToggleButton>(0);
      
      protected var inactiveTabs:Vector.<ToggleButton> = new Vector.<ToggleButton>(0);
      
      protected var _tabToItem:Dictionary = new Dictionary(true);
      
      protected var _dataProvider:IListCollection;
      
      protected var verticalLayout:VerticalLayout;
      
      protected var horizontalLayout:HorizontalLayout;
      
      protected var _viewPortBounds:ViewPortBounds = new ViewPortBounds();
      
      protected var _layoutResult:LayoutBoundsResult = new LayoutBoundsResult();
      
      protected var _direction:String = "horizontal";
      
      protected var _horizontalAlign:String = "justify";
      
      protected var _verticalAlign:String = "justify";
      
      protected var _selectionSkin:DisplayObject;
      
      protected var _selectionChangeTween:Tween;
      
      protected var _selectionChangeDuration:Number = 0.25;
      
      protected var _selectionChangeEase:Object = "easeOut";
      
      protected var _distributeTabSizes:Boolean = true;
      
      protected var _gap:Number = 0;
      
      protected var _firstGap:Number = NaN;
      
      protected var _lastGap:Number = NaN;
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var _tabFactory:Function = defaultTabFactory;
      
      protected var _firstTabFactory:Function;
      
      protected var _lastTabFactory:Function;
      
      protected var _tabInitializer:Function;
      
      protected var _tabReleaser:Function;
      
      protected var _labelField:String = "label";
      
      protected var _labelFunction:Function;
      
      protected var _enabledField:String = "isEnabled";
      
      protected var _iconField:String = "defaultIcon";
      
      protected var _iconFunction:Function;
      
      protected var _enabledFunction:Function;
      
      protected var _ignoreSelectionChanges:Boolean = false;
      
      protected var _selectedIndex:int = -1;
      
      protected var _selectedItem:Object = null;
      
      protected var _customTabStyleName:String;
      
      protected var _customFirstTabStyleName:String;
      
      protected var _customLastTabStyleName:String;
      
      protected var _tabProperties:PropertyProxy;
      
      protected var _animateSelectionChange:Boolean = false;
      
      protected var _dragFormat:String = "feathers-tab-bar-item";
      
      protected var _dragTouchPointID:int = -1;
      
      protected var _droppedOnSelf:Boolean = false;
      
      protected var _dragEnabled:Boolean = false;
      
      protected var _dropEnabled:Boolean = false;
      
      protected var _explicitDropIndicatorWidth:Number = NaN;
      
      protected var _explicitDropIndicatorHeight:Number = NaN;
      
      protected var _dropIndicatorSkin:DisplayObject = null;
      
      protected var _focusedTabIndex:int = -1;
      
      public function TabBar()
      {
         this._tabInitializer = this.defaultTabInitializer;
         this._tabReleaser = this.defaultTabReleaser;
         super();
      }
      
      protected static function defaultTabFactory() : ToggleButton
      {
         return new ToggleButton();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return TabBar.globalStyleProvider;
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
            this._dataProvider.removeEventListener(CollectionEventType.ADD_ITEM,this.dataProvider_addItemHandler);
            this._dataProvider.removeEventListener(CollectionEventType.REMOVE_ITEM,this.dataProvider_removeItemHandler);
            this._dataProvider.removeEventListener(CollectionEventType.REMOVE_ALL,this.dataProvider_removeAllHandler);
            this._dataProvider.removeEventListener(CollectionEventType.REPLACE_ITEM,this.dataProvider_replaceItemHandler);
            this._dataProvider.removeEventListener(CollectionEventType.FILTER_CHANGE,this.dataProvider_filterChangeHandler);
            this._dataProvider.removeEventListener(CollectionEventType.SORT_CHANGE,this.dataProvider_sortChangeHandler);
            this._dataProvider.removeEventListener(CollectionEventType.UPDATE_ITEM,this.dataProvider_updateItemHandler);
            this._dataProvider.removeEventListener(CollectionEventType.UPDATE_ALL,this.dataProvider_updateAllHandler);
            this._dataProvider.removeEventListener(CollectionEventType.RESET,this.dataProvider_resetHandler);
         }
         this._dataProvider = param1;
         if(this._dataProvider)
         {
            this._dataProvider.addEventListener(CollectionEventType.ADD_ITEM,this.dataProvider_addItemHandler);
            this._dataProvider.addEventListener(CollectionEventType.REMOVE_ITEM,this.dataProvider_removeItemHandler);
            this._dataProvider.addEventListener(CollectionEventType.REMOVE_ALL,this.dataProvider_removeAllHandler);
            this._dataProvider.addEventListener(CollectionEventType.REPLACE_ITEM,this.dataProvider_replaceItemHandler);
            this._dataProvider.addEventListener(CollectionEventType.FILTER_CHANGE,this.dataProvider_filterChangeHandler);
            this._dataProvider.addEventListener(CollectionEventType.SORT_CHANGE,this.dataProvider_sortChangeHandler);
            this._dataProvider.addEventListener(CollectionEventType.UPDATE_ITEM,this.dataProvider_updateItemHandler);
            this._dataProvider.addEventListener(CollectionEventType.UPDATE_ALL,this.dataProvider_updateAllHandler);
            this._dataProvider.addEventListener(CollectionEventType.RESET,this.dataProvider_resetHandler);
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
      
      public function get direction() : String
      {
         return this._direction;
      }
      
      public function set direction(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._direction === param1)
         {
            return;
         }
         this._direction = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get horizontalAlign() : String
      {
         return this._horizontalAlign;
      }
      
      public function set horizontalAlign(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._horizontalAlign === param1)
         {
            return;
         }
         this._horizontalAlign = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get verticalAlign() : String
      {
         return this._verticalAlign;
      }
      
      public function set verticalAlign(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._verticalAlign === param1)
         {
            return;
         }
         this._verticalAlign = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get selectionSkin() : DisplayObject
      {
         return this._selectionSkin;
      }
      
      public function set selectionSkin(param1:DisplayObject) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            if(param1 !== null)
            {
               param1.dispose();
            }
            return;
         }
         if(this._selectionSkin === param1)
         {
            return;
         }
         if(this._selectionSkin !== null && this._selectionSkin.parent === this)
         {
            this._selectionSkin.removeFromParent(false);
         }
         this._selectionSkin = param1;
         if(this._selectionSkin !== null)
         {
            this._selectionSkin.touchable = false;
            this.addChild(this._selectionSkin);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get selectionChangeDuration() : Number
      {
         return this._selectionChangeDuration;
      }
      
      public function set selectionChangeDuration(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         this._selectionChangeDuration = param1;
      }
      
      public function get selectionChangeEase() : Object
      {
         return this._selectionChangeEase;
      }
      
      public function set selectionChangeEase(param1:Object) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         this._selectionChangeEase = param1;
      }
      
      public function get distributeTabSizes() : Boolean
      {
         return this._distributeTabSizes;
      }
      
      public function set distributeTabSizes(param1:Boolean) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._distributeTabSizes === param1)
         {
            return;
         }
         this._distributeTabSizes = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get gap() : Number
      {
         return this._gap;
      }
      
      public function set gap(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._gap == param1)
         {
            return;
         }
         this._gap = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get firstGap() : Number
      {
         return this._firstGap;
      }
      
      public function set firstGap(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._firstGap == param1)
         {
            return;
         }
         this._firstGap = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get lastGap() : Number
      {
         return this._lastGap;
      }
      
      public function set lastGap(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._lastGap == param1)
         {
            return;
         }
         this._lastGap = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get padding() : Number
      {
         return this._paddingTop;
      }
      
      public function set padding(param1:Number) : void
      {
         this.paddingTop = param1;
         this.paddingRight = param1;
         this.paddingBottom = param1;
         this.paddingLeft = param1;
      }
      
      public function get paddingTop() : Number
      {
         return this._paddingTop;
      }
      
      public function set paddingTop(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._paddingTop == param1)
         {
            return;
         }
         this._paddingTop = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get paddingRight() : Number
      {
         return this._paddingRight;
      }
      
      public function set paddingRight(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._paddingRight == param1)
         {
            return;
         }
         this._paddingRight = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get paddingBottom() : Number
      {
         return this._paddingBottom;
      }
      
      public function set paddingBottom(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._paddingBottom == param1)
         {
            return;
         }
         this._paddingBottom = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get paddingLeft() : Number
      {
         return this._paddingLeft;
      }
      
      public function set paddingLeft(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._paddingLeft == param1)
         {
            return;
         }
         this._paddingLeft = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get tabFactory() : Function
      {
         return this._tabFactory;
      }
      
      public function set tabFactory(param1:Function) : void
      {
         if(this._tabFactory == param1)
         {
            return;
         }
         this._tabFactory = param1;
         this.invalidate(INVALIDATION_FLAG_TAB_FACTORY);
      }
      
      public function get firstTabFactory() : Function
      {
         return this._firstTabFactory;
      }
      
      public function set firstTabFactory(param1:Function) : void
      {
         if(this._firstTabFactory == param1)
         {
            return;
         }
         this._firstTabFactory = param1;
         this.invalidate(INVALIDATION_FLAG_TAB_FACTORY);
      }
      
      public function get lastTabFactory() : Function
      {
         return this._lastTabFactory;
      }
      
      public function set lastTabFactory(param1:Function) : void
      {
         if(this._lastTabFactory == param1)
         {
            return;
         }
         this._lastTabFactory = param1;
         this.invalidate(INVALIDATION_FLAG_TAB_FACTORY);
      }
      
      public function get tabInitializer() : Function
      {
         return this._tabInitializer;
      }
      
      public function set tabInitializer(param1:Function) : void
      {
         if(this._tabInitializer == param1)
         {
            return;
         }
         this._tabInitializer = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get tabReleaser() : Function
      {
         return this._tabReleaser;
      }
      
      public function set tabReleaser(param1:Function) : void
      {
         if(this._tabReleaser == param1)
         {
            return;
         }
         this._tabReleaser = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
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
         if(this._labelFunction == param1)
         {
            return;
         }
         this._labelFunction = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get enabledField() : String
      {
         return this._enabledField;
      }
      
      public function set enabledField(param1:String) : void
      {
         if(this._enabledField == param1)
         {
            return;
         }
         this._enabledField = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get iconField() : String
      {
         return this._iconField;
      }
      
      public function set iconField(param1:String) : void
      {
         if(this._iconField == param1)
         {
            return;
         }
         this._iconField = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get iconFunction() : Function
      {
         return this._iconFunction;
      }
      
      public function set iconFunction(param1:Function) : void
      {
         if(this._iconFunction == param1)
         {
            return;
         }
         this._iconFunction = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get enabledFunction() : Function
      {
         return this._enabledFunction;
      }
      
      public function set enabledFunction(param1:Function) : void
      {
         if(this._enabledFunction == param1)
         {
            return;
         }
         this._enabledFunction = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get selectedIndex() : int
      {
         return this._selectedIndex;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         this._animateSelectionChange = false;
         if(this._selectedIndex == param1)
         {
            return;
         }
         this._selectedIndex = param1;
         this.refreshSelectedItem();
         this.invalidate(INVALIDATION_FLAG_SELECTED);
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get selectedItem() : Object
      {
         return this._selectedItem;
      }
      
      public function set selectedItem(param1:Object) : void
      {
         if(this._selectedItem === param1)
         {
            return;
         }
         if(this._dataProvider === null)
         {
            this.selectedIndex = -1;
            return;
         }
         var _loc2_:int = this._dataProvider.getItemIndex(param1);
         if(_loc2_ == -1)
         {
            this.selectedIndex = -1;
         }
         else if(this._selectedIndex != _loc2_)
         {
            this.selectedIndex = _loc2_;
         }
         else
         {
            this._animateSelectionChange = false;
            this._selectedItem = param1;
            this.invalidate(INVALIDATION_FLAG_SELECTED);
            this.dispatchEventWith(Event.CHANGE);
         }
      }
      
      public function get customTabStyleName() : String
      {
         return this._customTabStyleName;
      }
      
      public function set customTabStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customTabStyleName === param1)
         {
            return;
         }
         this._customTabStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_TAB_FACTORY);
      }
      
      public function get customFirstTabStyleName() : String
      {
         return this._customFirstTabStyleName;
      }
      
      public function set customFirstTabStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customFirstTabStyleName === param1)
         {
            return;
         }
         this._customFirstTabStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_TAB_FACTORY);
      }
      
      public function get customLastTabStyleName() : String
      {
         return this._customLastTabStyleName;
      }
      
      public function set customLastTabStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customLastTabStyleName === param1)
         {
            return;
         }
         this._customLastTabStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_TAB_FACTORY);
      }
      
      public function get tabProperties() : Object
      {
         if(!this._tabProperties)
         {
            this._tabProperties = new PropertyProxy(this.childProperties_onChange);
         }
         return this._tabProperties;
      }
      
      public function set tabProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         var _loc3_:String = null;
         if(this._tabProperties == param1)
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
         if(this._tabProperties)
         {
            this._tabProperties.removeOnChangeCallback(this.childProperties_onChange);
         }
         this._tabProperties = PropertyProxy(param1);
         if(this._tabProperties)
         {
            this._tabProperties.addOnChangeCallback(this.childProperties_onChange);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get baseline() : Number
      {
         if(!this.activeTabs || this.activeTabs.length == 0)
         {
            return this.scaledActualHeight;
         }
         var _loc1_:ToggleButton = this.activeTabs[0];
         return this.scaleY * (_loc1_.y + _loc1_.baseline);
      }
      
      public function get dragFormat() : String
      {
         return this._dragFormat;
      }
      
      public function set dragFormat(param1:String) : void
      {
         if(!param1)
         {
            param1 = DEFAULT_DRAG_FORMAT;
         }
         if(this._dragFormat == param1)
         {
            return;
         }
         this._dragFormat = param1;
      }
      
      public function get dragEnabled() : Boolean
      {
         return this._dragEnabled;
      }
      
      public function set dragEnabled(param1:Boolean) : void
      {
         if(this._dragEnabled == param1)
         {
            return;
         }
         this._dragEnabled = param1;
         if(this._dragEnabled)
         {
            this.addEventListener(DragDropEvent.DRAG_COMPLETE,this.dragCompleteHandler);
         }
         else
         {
            this.removeEventListener(DragDropEvent.DRAG_COMPLETE,this.dragCompleteHandler);
         }
      }
      
      public function get dropEnabled() : Boolean
      {
         return this._dropEnabled;
      }
      
      public function set dropEnabled(param1:Boolean) : void
      {
         if(this._dropEnabled == param1)
         {
            return;
         }
         this._dropEnabled = param1;
         if(this._dropEnabled)
         {
            this.addEventListener(DragDropEvent.DRAG_ENTER,this.dragEnterHandler);
            this.addEventListener(DragDropEvent.DRAG_MOVE,this.dragMoveHandler);
            this.addEventListener(DragDropEvent.DRAG_EXIT,this.dragExitHandler);
            this.addEventListener(DragDropEvent.DRAG_DROP,this.dragDropHandler);
         }
         else
         {
            this.removeEventListener(DragDropEvent.DRAG_ENTER,this.dragEnterHandler);
            this.removeEventListener(DragDropEvent.DRAG_MOVE,this.dragMoveHandler);
            this.removeEventListener(DragDropEvent.DRAG_EXIT,this.dragExitHandler);
            this.removeEventListener(DragDropEvent.DRAG_DROP,this.dragDropHandler);
         }
      }
      
      public function get dropIndicatorSkin() : DisplayObject
      {
         return this._dropIndicatorSkin;
      }
      
      public function set dropIndicatorSkin(param1:DisplayObject) : void
      {
         var _loc3_:IMeasureDisplayObject = null;
         if(this.processStyleRestriction(arguments.callee))
         {
            if(param1 !== null)
            {
               param1.dispose();
            }
            return;
         }
         this._dropIndicatorSkin = param1;
         if(this._dropIndicatorSkin is IMeasureDisplayObject)
         {
            _loc3_ = IMeasureDisplayObject(this._dropIndicatorSkin);
            this._explicitDropIndicatorWidth = _loc3_.explicitWidth;
            this._explicitDropIndicatorHeight = _loc3_.explicitHeight;
         }
         else if(this._dropIndicatorSkin)
         {
            this._explicitDropIndicatorWidth = this._dropIndicatorSkin.width;
            this._explicitDropIndicatorHeight = this._dropIndicatorSkin.height;
         }
      }
      
      override public function dispose() : void
      {
         var _loc3_:ToggleButton = null;
         if(this._dropIndicatorSkin !== null && this._dropIndicatorSkin.parent === null)
         {
            this._dropIndicatorSkin.dispose();
            this._dropIndicatorSkin = null;
         }
         this._selectedIndex = -1;
         this._ignoreSelectionChanges = true;
         var _loc1_:int = int(this.activeTabs.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.activeTabs.shift();
            this.destroyTab(_loc3_);
            _loc2_++;
         }
         this.dataProvider = null;
         super.dispose();
      }
      
      public function setSelectedIndexWithAnimation(param1:int) : void
      {
         if(this._selectedIndex == param1)
         {
            return;
         }
         this._selectedIndex = param1;
         this.refreshSelectedItem();
         this._animateSelectionChange = true;
         this.invalidate(INVALIDATION_FLAG_SELECTED);
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function setSelectedItemWithAnimation(param1:Object) : void
      {
         if(this.selectedItem == param1)
         {
            return;
         }
         var _loc2_:int = -1;
         if(this._dataProvider !== null)
         {
            _loc2_ = this._dataProvider.getItemIndex(param1);
         }
         this.setSelectedIndexWithAnimation(_loc2_);
      }
      
      override protected function initialize() : void
      {
         this.toggleGroup = new ToggleGroup();
         this.toggleGroup.isSelectionRequired = true;
         this.toggleGroup.addEventListener(Event.CHANGE,this.toggleGroup_changeHandler);
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         var _loc4_:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
         var _loc5_:Boolean = this.isInvalid(INVALIDATION_FLAG_TAB_FACTORY);
         var _loc6_:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
         if(_loc1_ || _loc5_ || _loc3_)
         {
            this.refreshTabs(_loc5_);
         }
         if(_loc1_ || _loc5_ || _loc2_)
         {
            this.refreshTabStyles();
         }
         if(_loc1_ || _loc5_ || _loc4_)
         {
            this.commitSelection();
         }
         if(_loc1_ || _loc5_ || _loc3_)
         {
            this.commitEnabled();
         }
         if(_loc2_)
         {
            this.refreshLayoutStyles();
         }
         this.layoutTabs();
      }
      
      protected function commitSelection() : void
      {
         this.toggleGroup.selectedIndex = this._selectedIndex;
      }
      
      protected function commitEnabled() : void
      {
         var _loc1_:ToggleButton = null;
         for each(_loc1_ in this.activeTabs)
         {
            _loc1_.isEnabled = _loc1_.isEnabled && this._isEnabled;
         }
      }
      
      protected function refreshTabStyles() : void
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         var _loc3_:ToggleButton = null;
         for(_loc1_ in this._tabProperties)
         {
            _loc2_ = this._tabProperties[_loc1_];
            for each(_loc3_ in this.activeTabs)
            {
               _loc3_[_loc1_] = _loc2_;
            }
         }
      }
      
      protected function refreshLayoutStyles() : void
      {
         if(this._direction == Direction.VERTICAL)
         {
            if(this.horizontalLayout)
            {
               this.horizontalLayout = null;
            }
            if(!this.verticalLayout)
            {
               this.verticalLayout = new VerticalLayout();
               this.verticalLayout.useVirtualLayout = false;
            }
            this.verticalLayout.distributeHeights = this._distributeTabSizes;
            this.verticalLayout.horizontalAlign = this._horizontalAlign;
            this.verticalLayout.verticalAlign = this._verticalAlign == VerticalAlign.JUSTIFY ? VerticalAlign.TOP : this._verticalAlign;
            this.verticalLayout.gap = this._gap;
            this.verticalLayout.firstGap = this._firstGap;
            this.verticalLayout.lastGap = this._lastGap;
            this.verticalLayout.paddingTop = this._paddingTop;
            this.verticalLayout.paddingRight = this._paddingRight;
            this.verticalLayout.paddingBottom = this._paddingBottom;
            this.verticalLayout.paddingLeft = this._paddingLeft;
         }
         else
         {
            if(this.verticalLayout)
            {
               this.verticalLayout = null;
            }
            if(!this.horizontalLayout)
            {
               this.horizontalLayout = new HorizontalLayout();
               this.horizontalLayout.useVirtualLayout = false;
            }
            this.horizontalLayout.distributeWidths = this._distributeTabSizes;
            this.horizontalLayout.horizontalAlign = this._horizontalAlign == HorizontalAlign.JUSTIFY ? HorizontalAlign.LEFT : this._horizontalAlign;
            this.horizontalLayout.verticalAlign = this._verticalAlign;
            this.horizontalLayout.gap = this._gap;
            this.horizontalLayout.firstGap = this._firstGap;
            this.horizontalLayout.lastGap = this._lastGap;
            this.horizontalLayout.paddingTop = this._paddingTop;
            this.horizontalLayout.paddingRight = this._paddingRight;
            this.horizontalLayout.paddingBottom = this._paddingBottom;
            this.horizontalLayout.paddingLeft = this._paddingLeft;
         }
      }
      
      protected function commitTabData(param1:ToggleButton, param2:Object) : void
      {
         if(param2 !== null)
         {
            if(this._labelFunction !== null)
            {
               param1.label = this._labelFunction(param2);
            }
            else if(this._labelField !== null && param2 !== null && this._labelField in param2)
            {
               param1.label = param2[this._labelField];
            }
            else if(param2 is String)
            {
               param1.label = param2 as String;
            }
            else
            {
               param1.label = param2.toString();
            }
            if(this._iconFunction !== null)
            {
               param1.defaultIcon = this._iconFunction(param2);
            }
            else if(this._iconField !== null && param2 !== null && this._iconField in param2)
            {
               param1.defaultIcon = param2[this._iconField] as DisplayObject;
            }
            if(this._enabledFunction !== null)
            {
               param1.isEnabled = this._enabledFunction(param2);
            }
            else if(this._enabledField !== null && param2 !== null && this._enabledField in param2)
            {
               param1.isEnabled = param2[this._enabledField] as Boolean;
            }
            else
            {
               param1.isEnabled = this._isEnabled;
            }
            if(this._tabInitializer !== null)
            {
               this._tabInitializer(param1,param2);
            }
         }
         else
         {
            param1.label = "";
            param1.isEnabled = this._isEnabled;
         }
      }
      
      protected function defaultTabInitializer(param1:ToggleButton, param2:Object) : void
      {
         var _loc3_:String = null;
         if(param2 !== null)
         {
            for each(_loc3_ in DEFAULT_TAB_FIELDS)
            {
               if(param2.hasOwnProperty(_loc3_))
               {
                  param1[_loc3_] = param2[_loc3_];
               }
            }
         }
      }
      
      protected function defaultTabReleaser(param1:ToggleButton, param2:Object) : void
      {
         var _loc3_:String = null;
         for each(_loc3_ in DEFAULT_TAB_FIELDS)
         {
            if(param2.hasOwnProperty(_loc3_))
            {
               param1[_loc3_] = null;
            }
         }
      }
      
      protected function refreshTabs(param1:Boolean) : void
      {
         var _loc9_:Object = null;
         var _loc10_:ToggleButton = null;
         var _loc11_:int = 0;
         var _loc2_:Boolean = this._ignoreSelectionChanges;
         this._ignoreSelectionChanges = true;
         var _loc3_:int = this.toggleGroup.selectedIndex;
         this.toggleGroup.removeAllItems();
         var _loc4_:Vector.<ToggleButton> = this.inactiveTabs;
         this.inactiveTabs = this.activeTabs;
         this.activeTabs = _loc4_;
         this.activeTabs.length = 0;
         this._layoutItems.length = 0;
         _loc4_ = null;
         if(param1)
         {
            this.clearInactiveTabs();
         }
         else
         {
            if(this.activeFirstTab)
            {
               this.inactiveTabs.shift();
            }
            this.inactiveFirstTab = this.activeFirstTab;
            if(this.activeLastTab)
            {
               this.inactiveTabs.pop();
            }
            this.inactiveLastTab = this.activeLastTab;
         }
         this.activeFirstTab = null;
         this.activeLastTab = null;
         var _loc5_:int = 0;
         var _loc6_:int = this._dataProvider ? this._dataProvider.length : 0;
         var _loc7_:int = _loc6_ - 1;
         var _loc8_:int = 0;
         while(_loc8_ < _loc6_)
         {
            _loc9_ = this._dataProvider.getItemAt(_loc8_);
            if(_loc8_ == 0)
            {
               _loc10_ = this.activeFirstTab = this.createFirstTab(_loc9_);
            }
            else if(_loc8_ == _loc7_)
            {
               _loc10_ = this.activeLastTab = this.createLastTab(_loc9_);
            }
            else
            {
               _loc10_ = this.createTab(_loc9_);
            }
            this.toggleGroup.addItem(_loc10_);
            this.activeTabs[_loc5_] = _loc10_;
            this._layoutItems[_loc5_] = _loc10_;
            _loc5_++;
            _loc8_++;
         }
         this.clearInactiveTabs();
         this._ignoreSelectionChanges = _loc2_;
         if(_loc3_ >= 0)
         {
            _loc11_ = this.activeTabs.length - 1;
            if(_loc3_ < _loc11_)
            {
               _loc11_ = _loc3_;
            }
            this._ignoreSelectionChanges = _loc3_ == _loc11_;
            this.toggleGroup.selectedIndex = _loc11_;
            this._ignoreSelectionChanges = _loc2_;
         }
      }
      
      protected function clearInactiveTabs() : void
      {
         var _loc3_:ToggleButton = null;
         var _loc1_:int = int(this.inactiveTabs.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.inactiveTabs.shift();
            this.destroyTab(_loc3_);
            _loc2_++;
         }
         if(this.inactiveFirstTab)
         {
            this.destroyTab(this.inactiveFirstTab);
            this.inactiveFirstTab = null;
         }
         if(this.inactiveLastTab)
         {
            this.destroyTab(this.inactiveLastTab);
            this.inactiveLastTab = null;
         }
      }
      
      protected function createFirstTab(param1:Object) : ToggleButton
      {
         var _loc3_:ToggleButton = null;
         var _loc4_:Function = null;
         var _loc2_:Boolean = false;
         if(this.inactiveFirstTab !== null)
         {
            _loc3_ = this.inactiveFirstTab;
            this.releaseTab(_loc3_);
            this.inactiveFirstTab = null;
         }
         else
         {
            _loc2_ = true;
            _loc4_ = this._firstTabFactory != null ? this._firstTabFactory : this._tabFactory;
            _loc3_ = ToggleButton(_loc4_());
            if(this._customFirstTabStyleName)
            {
               _loc3_.styleNameList.add(this._customFirstTabStyleName);
            }
            else if(this._customTabStyleName)
            {
               _loc3_.styleNameList.add(this._customTabStyleName);
            }
            else
            {
               _loc3_.styleNameList.add(this.firstTabStyleName);
            }
            _loc3_.isToggle = true;
            this.addChild(_loc3_);
         }
         this.commitTabData(_loc3_,param1);
         this._tabToItem[_loc3_] = param1;
         if(_loc2_)
         {
            this.addTabListeners(_loc3_);
         }
         return _loc3_;
      }
      
      protected function createLastTab(param1:Object) : ToggleButton
      {
         var _loc3_:ToggleButton = null;
         var _loc4_:Function = null;
         var _loc2_:Boolean = false;
         if(this.inactiveLastTab !== null)
         {
            _loc3_ = this.inactiveLastTab;
            this.releaseTab(_loc3_);
            this.inactiveLastTab = null;
         }
         else
         {
            _loc2_ = true;
            _loc4_ = this._lastTabFactory != null ? this._lastTabFactory : this._tabFactory;
            _loc3_ = ToggleButton(_loc4_());
            if(this._customLastTabStyleName)
            {
               _loc3_.styleNameList.add(this._customLastTabStyleName);
            }
            else if(this._customTabStyleName)
            {
               _loc3_.styleNameList.add(this._customTabStyleName);
            }
            else
            {
               _loc3_.styleNameList.add(this.lastTabStyleName);
            }
            _loc3_.isToggle = true;
            this.addChild(_loc3_);
         }
         this.commitTabData(_loc3_,param1);
         this._tabToItem[_loc3_] = param1;
         if(_loc2_)
         {
            this.addTabListeners(_loc3_);
         }
         return _loc3_;
      }
      
      protected function createTab(param1:Object) : ToggleButton
      {
         var _loc3_:ToggleButton = null;
         var _loc2_:Boolean = false;
         if(this.inactiveTabs.length == 0)
         {
            _loc2_ = true;
            _loc3_ = ToggleButton(this._tabFactory());
            if(this._customTabStyleName)
            {
               _loc3_.styleNameList.add(this._customTabStyleName);
            }
            else
            {
               _loc3_.styleNameList.add(this.tabStyleName);
            }
            _loc3_.isToggle = true;
            this.addChild(_loc3_);
         }
         else
         {
            _loc3_ = this.inactiveTabs.shift();
            this.releaseTab(_loc3_);
         }
         this.commitTabData(_loc3_,param1);
         this._tabToItem[_loc3_] = param1;
         if(_loc2_)
         {
            this.addTabListeners(_loc3_);
         }
         return _loc3_;
      }
      
      protected function addTabListeners(param1:ToggleButton) : void
      {
         param1.addEventListener(Event.TRIGGERED,this.tab_triggeredHandler);
         param1.addEventListener(TouchEvent.TOUCH,this.tab_drag_touchHandler);
      }
      
      protected function releaseTab(param1:ToggleButton) : void
      {
         var _loc2_:Object = this._tabToItem[param1];
         delete this._tabToItem[param1];
         if(this._labelFunction !== null || this._labelField in _loc2_)
         {
            param1.label = null;
         }
         if(this._iconFunction !== null || this._iconField in _loc2_)
         {
            param1.defaultIcon = null;
         }
         if(this._tabReleaser !== null)
         {
            if(this._tabReleaser.length == 1)
            {
               this._tabReleaser(param1);
            }
            else
            {
               this._tabReleaser(param1,_loc2_);
            }
         }
      }
      
      protected function destroyTab(param1:ToggleButton) : void
      {
         this.toggleGroup.removeItem(param1);
         this.releaseTab(param1);
         param1.removeEventListener(Event.TRIGGERED,this.tab_triggeredHandler);
         param1.removeEventListener(TouchEvent.TOUCH,this.tab_drag_touchHandler);
         this.removeChild(param1,true);
      }
      
      protected function layoutTabs() : void
      {
         var _loc3_:ToggleButton = null;
         this._viewPortBounds.x = 0;
         this._viewPortBounds.y = 0;
         this._viewPortBounds.scrollX = 0;
         this._viewPortBounds.scrollY = 0;
         this._viewPortBounds.explicitWidth = this._explicitWidth;
         this._viewPortBounds.explicitHeight = this._explicitHeight;
         this._viewPortBounds.minWidth = this._explicitMinWidth;
         this._viewPortBounds.minHeight = this._explicitMinHeight;
         this._viewPortBounds.maxWidth = this._explicitMaxWidth;
         this._viewPortBounds.maxHeight = this._explicitMaxHeight;
         if(this.verticalLayout)
         {
            this.verticalLayout.layout(this._layoutItems,this._viewPortBounds,this._layoutResult);
         }
         else if(this.horizontalLayout)
         {
            this.horizontalLayout.layout(this._layoutItems,this._viewPortBounds,this._layoutResult);
         }
         var _loc1_:Number = this._layoutResult.contentWidth;
         var _loc2_:Number = this._layoutResult.contentHeight;
         this.saveMeasurements(_loc1_,_loc2_,_loc1_,_loc2_);
         for each(_loc3_ in this.activeTabs)
         {
            _loc3_.validate();
         }
         if(this._selectionSkin !== null)
         {
            this.setChildIndex(this._selectionSkin,this.numChildren - 1);
            if(this._selectionChangeTween !== null)
            {
               this._selectionChangeTween.advanceTime(this._selectionChangeTween.totalTime);
            }
            if(this._selectedIndex >= 0)
            {
               this._selectionSkin.visible = true;
               _loc3_ = this.activeTabs[this._selectedIndex];
               if(this._animateSelectionChange)
               {
                  this._selectionChangeTween = new Tween(this._selectionSkin,this._selectionChangeDuration,this._selectionChangeEase);
                  if(this._direction === Direction.VERTICAL)
                  {
                     this._selectionChangeTween.animate("y",_loc3_.y);
                     this._selectionChangeTween.animate("height",_loc3_.height);
                  }
                  else
                  {
                     this._selectionChangeTween.animate("x",_loc3_.x);
                     this._selectionChangeTween.animate("width",_loc3_.width);
                  }
                  this._selectionChangeTween.onComplete = this.selectionChangeTween_onComplete;
                  Starling.juggler.add(this._selectionChangeTween);
               }
               else if(this._direction === Direction.VERTICAL)
               {
                  this._selectionSkin.y = _loc3_.y;
                  this._selectionSkin.height = _loc3_.height;
               }
               else
               {
                  this._selectionSkin.x = _loc3_.x;
                  this._selectionSkin.width = _loc3_.width;
               }
            }
            else
            {
               this._selectionSkin.visible = false;
            }
            this._animateSelectionChange = false;
            if(this._selectionSkin is IValidating)
            {
               IValidating(this._selectionSkin).validate();
            }
         }
      }
      
      override public function showFocus() : void
      {
         if(!this._hasFocus)
         {
            return;
         }
         this._showFocus = true;
         this.showFocusedTab();
         this.invalidate(INVALIDATION_FLAG_FOCUS);
      }
      
      override public function hideFocus() : void
      {
         if(!this._hasFocus)
         {
            return;
         }
         this._showFocus = false;
         this.hideFocusedTab();
         this.invalidate(INVALIDATION_FLAG_FOCUS);
      }
      
      protected function hideFocusedTab() : void
      {
         if(this._focusedTabIndex < 0)
         {
            return;
         }
         var _loc1_:ToggleButton = this.activeTabs[this._focusedTabIndex];
         _loc1_.hideFocus();
      }
      
      protected function showFocusedTab() : void
      {
         if(!this._showFocus || this._focusedTabIndex < 0)
         {
            return;
         }
         var _loc1_:ToggleButton = this.activeTabs[this._focusedTabIndex];
         _loc1_.showFocus();
      }
      
      protected function focusedTabFocusIn() : void
      {
         if(this._focusedTabIndex < 0)
         {
            return;
         }
         var _loc1_:ToggleButton = this.activeTabs[this._focusedTabIndex];
         _loc1_.dispatchEventWith(FeathersEventType.FOCUS_IN);
      }
      
      protected function focusedTabFocusOut() : void
      {
         if(this._focusedTabIndex < 0)
         {
            return;
         }
         var _loc1_:ToggleButton = this.activeTabs[this._focusedTabIndex];
         _loc1_.dispatchEventWith(FeathersEventType.FOCUS_OUT);
      }
      
      protected function refreshSelectedItem() : void
      {
         if(this._selectedIndex == -1)
         {
            this._selectedItem = null;
         }
         else
         {
            this._selectedItem = this._dataProvider.getItemAt(this._selectedIndex);
         }
      }
      
      protected function getDropIndex(param1:DragDropEvent) : int
      {
         var _loc7_:ToggleButton = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc2_:Point = Pool.getPoint(param1.localX,param1.localY);
         this.localToGlobal(_loc2_,_loc2_);
         var _loc3_:Number = _loc2_.x;
         var _loc4_:Number = _loc2_.y;
         Pool.putPoint(_loc2_);
         var _loc5_:int = int(this.activeTabs.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = this.activeTabs[_loc6_];
            if(this._direction === Direction.HORIZONTAL)
            {
               _loc2_ = Pool.getPoint(_loc7_.width / 2,0);
            }
            else
            {
               _loc2_ = Pool.getPoint(0,_loc7_.height / 2);
            }
            _loc7_.localToGlobal(_loc2_,_loc2_);
            _loc8_ = _loc2_.x;
            _loc9_ = _loc2_.y;
            Pool.putPoint(_loc2_);
            if(this._direction === Direction.VERTICAL)
            {
               if(_loc4_ < _loc9_)
               {
                  return _loc6_;
               }
            }
            else if(_loc3_ < _loc8_)
            {
               return _loc6_;
            }
            _loc6_++;
         }
         return _loc5_;
      }
      
      protected function refreshDropIndicator(param1:DragDropEvent) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:ToggleButton = null;
         var _loc5_:Number = NaN;
         if(!this._dropIndicatorSkin)
         {
            return;
         }
         var _loc2_:int = this.getDropIndex(param1);
         if(this._direction == Direction.VERTICAL)
         {
            _loc3_ = 0;
            if(_loc2_ == this.activeTabs.length)
            {
               _loc3_ = this.actualHeight - this._dropIndicatorSkin.height;
            }
            else if(_loc2_ == 0)
            {
               _loc3_ = 0;
            }
            else
            {
               _loc4_ = this.activeTabs[_loc2_];
               _loc3_ = _loc4_.y - (this._gap + this._dropIndicatorSkin.height) / 2;
            }
            this._dropIndicatorSkin.x = 0;
            this._dropIndicatorSkin.y = _loc3_;
            this._dropIndicatorSkin.width = this.actualWidth;
            this._dropIndicatorSkin.height = this._explicitDropIndicatorHeight;
         }
         else
         {
            _loc5_ = 0;
            if(_loc2_ == this.activeTabs.length)
            {
               _loc5_ = this.actualWidth - this._dropIndicatorSkin.width;
            }
            else if(_loc2_ == 0)
            {
               _loc5_ = 0;
            }
            else
            {
               _loc4_ = this.activeTabs[_loc2_];
               _loc5_ = _loc4_.x - (this._gap + this._dropIndicatorSkin.width) / 2;
            }
            this._dropIndicatorSkin.x = _loc5_;
            this._dropIndicatorSkin.y = 0;
            this._dropIndicatorSkin.width = this._explicitDropIndicatorWidth;
            this._dropIndicatorSkin.height = this.actualHeight;
         }
         this.addChild(this._dropIndicatorSkin);
      }
      
      protected function childProperties_onChange(param1:PropertyProxy, param2:String) : void
      {
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      protected function selectionChangeTween_onComplete() : void
      {
         this._selectionChangeTween = null;
      }
      
      override protected function focusInHandler(param1:Event) : void
      {
         super.focusInHandler(param1);
         this._focusedTabIndex = this._selectedIndex;
         this.focusedTabFocusIn();
         this.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.stage_keyDownHandler);
      }
      
      override protected function focusOutHandler(param1:Event) : void
      {
         super.focusOutHandler(param1);
         this.hideFocusedTab();
         this.focusedTabFocusOut();
         this.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.stage_keyDownHandler);
      }
      
      protected function stage_keyDownHandler(param1:KeyboardEvent) : void
      {
         if(!this._isEnabled)
         {
            return;
         }
         if(!this._dataProvider || this._dataProvider.length == 0)
         {
            return;
         }
         var _loc2_:* = this._focusedTabIndex;
         var _loc3_:int = this._dataProvider.length - 1;
         if(param1.keyCode == Keyboard.HOME)
         {
            this.selectedIndex = _loc2_ = 0;
         }
         else if(param1.keyCode == Keyboard.END)
         {
            this.selectedIndex = _loc2_ = _loc3_;
         }
         else if(param1.keyCode == Keyboard.PAGE_UP)
         {
            _loc2_--;
            if(_loc2_ < 0)
            {
               _loc2_ = _loc3_;
            }
            this.selectedIndex = _loc2_;
         }
         else if(param1.keyCode == Keyboard.PAGE_DOWN)
         {
            if(++_loc2_ > _loc3_)
            {
               _loc2_ = 0;
            }
            this.selectedIndex = _loc2_;
         }
         else if(param1.keyCode == Keyboard.UP || param1.keyCode == Keyboard.LEFT)
         {
            _loc2_--;
            if(_loc2_ < 0)
            {
               _loc2_ = _loc3_;
            }
         }
         else if(param1.keyCode == Keyboard.DOWN || param1.keyCode == Keyboard.RIGHT)
         {
            if(++_loc2_ > _loc3_)
            {
               _loc2_ = 0;
            }
         }
         if(_loc2_ >= 0 && _loc2_ != this._focusedTabIndex)
         {
            this.hideFocusedTab();
            this.focusedTabFocusOut();
            this._focusedTabIndex = _loc2_;
            this.focusedTabFocusIn();
            this.showFocusedTab();
         }
      }
      
      protected function tab_triggeredHandler(param1:Event) : void
      {
         if(!this._dataProvider || !this.activeTabs)
         {
            return;
         }
         var _loc2_:ToggleButton = ToggleButton(param1.currentTarget);
         var _loc3_:int = this.activeTabs.indexOf(_loc2_);
         var _loc4_:Object = this._dataProvider.getItemAt(_loc3_);
         this.dispatchEventWith(Event.TRIGGERED,false,_loc4_);
      }
      
      protected function dragEnterHandler(param1:DragDropEvent) : void
      {
         if(!this._dropEnabled)
         {
            return;
         }
         if(!param1.dragData.hasDataForFormat(this._dragFormat))
         {
            return;
         }
         DragDropManager.acceptDrag(this);
         this.refreshDropIndicator(param1);
      }
      
      protected function dragMoveHandler(param1:DragDropEvent) : void
      {
         if(!this._dropEnabled)
         {
            return;
         }
         if(!param1.dragData.hasDataForFormat(this._dragFormat))
         {
            return;
         }
         this.refreshDropIndicator(param1);
      }
      
      protected function dragExitHandler(param1:DragDropEvent) : void
      {
         if(this._dropIndicatorSkin)
         {
            this._dropIndicatorSkin.removeFromParent(false);
         }
      }
      
      protected function dragDropHandler(param1:DragDropEvent) : void
      {
         var _loc5_:int = 0;
         if(this._dropIndicatorSkin)
         {
            this._dropIndicatorSkin.removeFromParent(false);
         }
         var _loc2_:* = this.getDropIndex(param1);
         var _loc3_:Object = param1.dragData.getDataForFormat(this._dragFormat);
         var _loc4_:Boolean = this._selectedItem == _loc3_;
         if(param1.dragSource == this)
         {
            _loc5_ = this._dataProvider.getItemIndex(_loc3_);
            this._dataProvider.removeItemAt(_loc5_);
            this._droppedOnSelf = true;
            if(_loc2_ > _loc5_)
            {
               _loc2_--;
            }
         }
         this._dataProvider.addItemAt(_loc3_,_loc2_);
         if(_loc4_)
         {
            this.selectedIndex = _loc2_;
         }
      }
      
      protected function dragCompleteHandler(param1:DragDropEvent) : void
      {
         if(!param1.isDropped)
         {
            return;
         }
         if(this._droppedOnSelf)
         {
            this._droppedOnSelf = false;
            return;
         }
         var _loc2_:Object = param1.dragData.getDataForFormat(this._dragFormat);
         this._dataProvider.removeItem(_loc2_);
      }
      
      protected function tab_drag_touchHandler(param1:TouchEvent) : void
      {
         var _loc3_:ExclusiveTouch = null;
         var _loc4_:Touch = null;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc7_:DragData = null;
         var _loc8_:ToggleButton = null;
         var _loc9_:Point = null;
         if(!this._dragEnabled)
         {
            this._dragTouchPointID = -1;
            return;
         }
         if(DragDropManager.isDragging)
         {
            this._dragTouchPointID = -1;
            return;
         }
         var _loc2_:ToggleButton = ToggleButton(param1.currentTarget);
         if(this._dragTouchPointID != -1)
         {
            _loc3_ = ExclusiveTouch.forStage(_loc2_.stage);
            if(_loc3_.getClaim(this._dragTouchPointID))
            {
               this._dragTouchPointID = -1;
               return;
            }
            _loc4_ = param1.getTouch(_loc2_,null,this._dragTouchPointID);
            if(_loc4_.phase == TouchPhase.MOVED)
            {
               _loc5_ = this.activeTabs.indexOf(_loc2_);
               _loc6_ = this._dataProvider.getItemAt(_loc5_);
               _loc7_ = new DragData();
               _loc7_.setDataForFormat(this._dragFormat,_loc6_);
               _loc8_ = this.createTab(_loc6_);
               _loc8_.width = _loc2_.width;
               _loc8_.height = _loc2_.height;
               _loc8_.alpha = 0.8;
               _loc9_ = Pool.getPoint();
               _loc4_.getLocation(_loc2_,_loc9_);
               this._droppedOnSelf = false;
               DragDropManager.startDrag(this,_loc4_,_loc7_,_loc8_,-_loc9_.x,-_loc9_.y);
               Pool.putPoint(_loc9_);
               _loc3_.claimTouch(this._dragTouchPointID,_loc2_);
               this._dragTouchPointID = -1;
            }
            else if(_loc4_.phase == TouchPhase.ENDED)
            {
               this._dragTouchPointID = -1;
            }
         }
         else
         {
            _loc4_ = param1.getTouch(_loc2_,TouchPhase.BEGAN);
            if(!_loc4_)
            {
               return;
            }
            this._dragTouchPointID = _loc4_.id;
         }
      }
      
      protected function toggleGroup_changeHandler(param1:Event) : void
      {
         if(this._ignoreSelectionChanges)
         {
            return;
         }
         this.setSelectedIndexWithAnimation(this.toggleGroup.selectedIndex);
      }
      
      protected function dataProvider_addItemHandler(param1:Event, param2:int) : void
      {
         if(this._selectedIndex >= param2)
         {
            this.selectedIndex += 1;
            this.invalidate(INVALIDATION_FLAG_SELECTED);
         }
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      protected function dataProvider_removeAllHandler(param1:Event) : void
      {
         this.selectedIndex = -1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      protected function dataProvider_removeItemHandler(param1:Event, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(this._selectedIndex > param2)
         {
            --this.selectedIndex;
         }
         else if(this._selectedIndex == param2)
         {
            _loc3_ = this._selectedIndex;
            _loc4_ = _loc3_;
            _loc5_ = this._dataProvider.length - 1;
            if(_loc4_ > _loc5_)
            {
               _loc4_ = _loc5_;
            }
            if(_loc3_ == _loc4_)
            {
               this.refreshSelectedItem();
               this.invalidate(INVALIDATION_FLAG_SELECTED);
               this.dispatchEventWith(Event.CHANGE);
            }
            else
            {
               this.selectedIndex = _loc4_;
            }
         }
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      protected function dataProvider_resetHandler(param1:Event) : void
      {
         if(this._dataProvider.length > 0)
         {
            if(this._selectedIndex != 0)
            {
               this.selectedIndex = 0;
            }
            else
            {
               this.refreshSelectedItem();
               this.invalidate(INVALIDATION_FLAG_SELECTED);
               this.dispatchEventWith(Event.CHANGE);
            }
         }
         else if(this._selectedIndex >= 0)
         {
            this.selectedIndex = -1;
         }
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      protected function dataProvider_replaceItemHandler(param1:Event, param2:int) : void
      {
         if(this._selectedIndex == param2)
         {
            this.refreshSelectedItem();
            this.invalidate(INVALIDATION_FLAG_SELECTED);
            this.dispatchEventWith(Event.CHANGE);
         }
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      protected function refreshSelectedIndicesAfterFilterOrSort() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc1_:int = this._dataProvider.getItemIndex(this._selectedItem);
         if(_loc1_ == -1)
         {
            _loc2_ = this._selectedIndex;
            _loc3_ = this._dataProvider.length - 1;
            if(_loc2_ > _loc3_)
            {
               _loc2_ = _loc3_;
            }
            if(_loc2_ != -1)
            {
               this.selectedItem = this._dataProvider.getItemAt(_loc2_);
            }
            else
            {
               this.selectedIndex = -1;
            }
         }
         else if(_loc1_ != this._selectedIndex)
         {
            this.selectedIndex = _loc1_;
         }
      }
      
      protected function dataProvider_sortChangeHandler(param1:Event) : void
      {
         this.refreshSelectedIndicesAfterFilterOrSort();
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      protected function dataProvider_filterChangeHandler(param1:Event) : void
      {
         this.refreshSelectedIndicesAfterFilterOrSort();
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      protected function dataProvider_updateItemHandler(param1:Event, param2:int) : void
      {
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      protected function dataProvider_updateAllHandler(param1:Event) : void
      {
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
   }
}

