package feathers.controls
{
   import feathers.controls.renderers.DefaultListItemRenderer;
   import feathers.controls.renderers.IListItemRenderer;
   import feathers.controls.supportClasses.ListDataViewPort;
   import feathers.core.IFocusContainer;
   import feathers.core.PropertyProxy;
   import feathers.data.IListCollection;
   import feathers.data.ListCollection;
   import feathers.dragDrop.IDragSource;
   import feathers.dragDrop.IDropTarget;
   import feathers.events.CollectionEventType;
   import feathers.layout.HorizontalAlign;
   import feathers.layout.ILayout;
   import feathers.layout.ISpinnerLayout;
   import feathers.layout.IVariableVirtualLayout;
   import feathers.layout.VerticalAlign;
   import feathers.layout.VerticalLayout;
   import feathers.skins.IStyleProvider;
   import feathers.system.DeviceCapabilities;
   import flash.events.KeyboardEvent;
   import flash.events.TransformGestureEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import starling.utils.Pool;
   
   public class List extends Scroller implements IFocusContainer, IDragSource, IDropTarget
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      protected static const DEFAULT_DRAG_FORMAT:String = "feathers-list-item";
      
      protected var dataViewPort:ListDataViewPort;
      
      protected var _isChildFocusEnabled:Boolean = true;
      
      protected var _layout:ILayout;
      
      protected var _addedItems:Dictionary = null;
      
      protected var _removedItems:Dictionary = null;
      
      protected var _dataProvider:IListCollection;
      
      protected var _isSelectable:Boolean = true;
      
      protected var _selectedIndex:int = -1;
      
      protected var _allowMultipleSelection:Boolean = false;
      
      protected var _selectedIndices:ListCollection = new ListCollection(new Vector.<int>(0));
      
      protected var _selectedItems:Vector.<Object> = new Vector.<Object>(0);
      
      protected var _itemRendererType:Class = DefaultListItemRenderer;
      
      protected var _itemRendererFactories:Object;
      
      protected var _itemRendererFactory:Function;
      
      protected var _factoryIDFunction:Function;
      
      protected var _typicalItem:Object = null;
      
      protected var _customItemRendererStyleName:String;
      
      protected var _itemRendererProperties:PropertyProxy;
      
      protected var _keyScrollDuration:Number = 0.25;
      
      protected var _dragFormat:String = "feathers-list-item";
      
      protected var _dragEnabled:Boolean = false;
      
      protected var _dropEnabled:Boolean = false;
      
      protected var _dropIndicatorSkin:DisplayObject = null;
      
      protected var _minimumAutoScrollDistance:Number = 0.2;
      
      protected var pendingItemIndex:int = -1;
      
      public function List()
      {
         super();
         this._selectedIndices.addEventListener(Event.CHANGE,this.selectedIndices_changeHandler);
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return List.globalStyleProvider;
      }
      
      override public function get isFocusEnabled() : Boolean
      {
         return (this._isSelectable || this._minHorizontalScrollPosition != this._maxHorizontalScrollPosition || this._minVerticalScrollPosition != this._maxVerticalScrollPosition) && this._isEnabled && this._isFocusEnabled;
      }
      
      public function get isChildFocusEnabled() : Boolean
      {
         return this._isEnabled && this._isChildFocusEnabled;
      }
      
      public function set isChildFocusEnabled(param1:Boolean) : void
      {
         this._isChildFocusEnabled = param1;
      }
      
      public function get layout() : ILayout
      {
         return this._layout;
      }
      
      public function set layout(param1:ILayout) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._layout == param1)
         {
            return;
         }
         if(!(this is SpinnerList) && param1 is ISpinnerLayout)
         {
            throw new ArgumentError("Layouts that implement the ISpinnerLayout interface should be used with the SpinnerList component.");
         }
         if(this._layout)
         {
            this._layout.removeEventListener(Event.SCROLL,this.layout_scrollHandler);
         }
         this._layout = param1;
         if(this._layout is IVariableVirtualLayout)
         {
            this._layout.addEventListener(Event.SCROLL,this.layout_scrollHandler);
         }
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
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
         if(this._dataProvider)
         {
            this._dataProvider.removeEventListener(CollectionEventType.SORT_CHANGE,this.dataProvider_sortChangeHandler);
            this._dataProvider.removeEventListener(CollectionEventType.FILTER_CHANGE,this.dataProvider_filterChangeHandler);
            this._dataProvider.removeEventListener(CollectionEventType.ADD_ITEM,this.dataProvider_addItemHandler);
            this._dataProvider.removeEventListener(CollectionEventType.REMOVE_ITEM,this.dataProvider_removeItemHandler);
            this._dataProvider.removeEventListener(CollectionEventType.REMOVE_ALL,this.dataProvider_removeAllHandler);
            this._dataProvider.removeEventListener(CollectionEventType.REPLACE_ITEM,this.dataProvider_replaceItemHandler);
            this._dataProvider.removeEventListener(CollectionEventType.RESET,this.dataProvider_resetHandler);
            this._dataProvider.removeEventListener(Event.CHANGE,this.dataProvider_changeHandler);
         }
         this._dataProvider = param1;
         if(this._dataProvider)
         {
            this._dataProvider.addEventListener(CollectionEventType.SORT_CHANGE,this.dataProvider_sortChangeHandler);
            this._dataProvider.addEventListener(CollectionEventType.FILTER_CHANGE,this.dataProvider_filterChangeHandler);
            this._dataProvider.addEventListener(CollectionEventType.ADD_ITEM,this.dataProvider_addItemHandler);
            this._dataProvider.addEventListener(CollectionEventType.REMOVE_ITEM,this.dataProvider_removeItemHandler);
            this._dataProvider.addEventListener(CollectionEventType.REMOVE_ALL,this.dataProvider_removeAllHandler);
            this._dataProvider.addEventListener(CollectionEventType.REPLACE_ITEM,this.dataProvider_replaceItemHandler);
            this._dataProvider.addEventListener(CollectionEventType.RESET,this.dataProvider_resetHandler);
            this._dataProvider.addEventListener(Event.CHANGE,this.dataProvider_changeHandler);
         }
         this.horizontalScrollPosition = 0;
         this.verticalScrollPosition = 0;
         this.selectedIndex = -1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get isSelectable() : Boolean
      {
         return this._isSelectable;
      }
      
      public function set isSelectable(param1:Boolean) : void
      {
         if(this._isSelectable == param1)
         {
            return;
         }
         this._isSelectable = param1;
         if(!this._isSelectable)
         {
            this.selectedIndex = -1;
         }
         this.invalidate(INVALIDATION_FLAG_SELECTED);
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
         if(param1 >= 0)
         {
            this._selectedIndices.data = new <int>[param1];
         }
         else
         {
            this._selectedIndices.removeAll();
         }
         this.invalidate(INVALIDATION_FLAG_SELECTED);
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
      
      public function get allowMultipleSelection() : Boolean
      {
         return this._allowMultipleSelection;
      }
      
      public function set allowMultipleSelection(param1:Boolean) : void
      {
         if(this._allowMultipleSelection == param1)
         {
            return;
         }
         this._allowMultipleSelection = param1;
         this.invalidate(INVALIDATION_FLAG_SELECTED);
      }
      
      public function get selectedIndices() : Vector.<int>
      {
         return this._selectedIndices.data as Vector.<int>;
      }
      
      public function set selectedIndices(param1:Vector.<int>) : void
      {
         var _loc2_:Vector.<int> = this._selectedIndices.data as Vector.<int>;
         if(_loc2_ == param1)
         {
            return;
         }
         if(!param1)
         {
            if(this._selectedIndices.length == 0)
            {
               return;
            }
            this._selectedIndices.removeAll();
         }
         else
         {
            if(!this._allowMultipleSelection && param1.length > 0)
            {
               param1.length = 1;
            }
            this._selectedIndices.data = param1;
         }
         this.invalidate(INVALIDATION_FLAG_SELECTED);
      }
      
      public function get selectedItems() : Vector.<Object>
      {
         return this._selectedItems;
      }
      
      public function set selectedItems(param1:Vector.<Object>) : void
      {
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         if(!param1 || !this._dataProvider)
         {
            this.selectedIndex = -1;
            return;
         }
         var _loc2_:Vector.<int> = new Vector.<int>(0);
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1[_loc4_];
            _loc6_ = this._dataProvider.getItemIndex(_loc5_);
            if(_loc6_ >= 0)
            {
               _loc2_.push(_loc6_);
            }
            _loc4_++;
         }
         this.selectedIndices = _loc2_;
      }
      
      public function getSelectedItems(param1:Vector.<Object> = null) : Vector.<Object>
      {
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         if(param1 !== null)
         {
            param1.length = 0;
         }
         else
         {
            param1 = new Vector.<Object>(0);
         }
         if(!this._dataProvider)
         {
            return param1;
         }
         var _loc2_:int = this._selectedIndices.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._selectedIndices.getItemAt(_loc3_) as int;
            _loc5_ = this._dataProvider.getItemAt(_loc4_);
            param1[_loc3_] = _loc5_;
            _loc3_++;
         }
         return param1;
      }
      
      public function get itemRendererType() : Class
      {
         return this._itemRendererType;
      }
      
      public function set itemRendererType(param1:Class) : void
      {
         if(this._itemRendererType == param1)
         {
            return;
         }
         this._itemRendererType = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
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
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get factoryIDFunction() : Function
      {
         return this._factoryIDFunction;
      }
      
      public function set factoryIDFunction(param1:Function) : void
      {
         if(this._factoryIDFunction === param1)
         {
            return;
         }
         this._factoryIDFunction = param1;
         if(param1 !== null && this._itemRendererFactories === null)
         {
            this._itemRendererFactories = {};
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
         this.invalidate(INVALIDATION_FLAG_DATA);
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
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get itemRendererProperties() : Object
      {
         if(!this._itemRendererProperties)
         {
            this._itemRendererProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._itemRendererProperties;
      }
      
      public function set itemRendererProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         var _loc3_:String = null;
         if(this._itemRendererProperties == param1)
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
         if(this._itemRendererProperties)
         {
            this._itemRendererProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._itemRendererProperties = PropertyProxy(param1);
         if(this._itemRendererProperties)
         {
            this._itemRendererProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get keyScrollDuration() : Number
      {
         return this._keyScrollDuration;
      }
      
      public function set keyScrollDuration(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         this._keyScrollDuration = param1;
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
         this.invalidate(INVALIDATION_FLAG_DATA);
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
         this.invalidate(INVALIDATION_FLAG_DATA);
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
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get dropIndicatorSkin() : DisplayObject
      {
         return this._dropIndicatorSkin;
      }
      
      public function set dropIndicatorSkin(param1:DisplayObject) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            if(param1 !== null)
            {
               param1.dispose();
            }
            return;
         }
         this._dropIndicatorSkin = param1;
      }
      
      public function get minimumAutoScrollDistance() : Number
      {
         return this._minimumAutoScrollDistance;
      }
      
      public function set minimumAutoScrollDistance(param1:Number) : void
      {
         if(this._minimumAutoScrollDistance == param1)
         {
            return;
         }
         this._minimumAutoScrollDistance = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      override public function scrollToPosition(param1:Number, param2:Number, param3:Number = NaN) : void
      {
         this.pendingItemIndex = -1;
         super.scrollToPosition(param1,param2,param3);
      }
      
      override public function scrollToPageIndex(param1:int, param2:int, param3:Number = NaN) : void
      {
         this.pendingItemIndex = -1;
         super.scrollToPageIndex(param1,param2,param3);
      }
      
      public function scrollToDisplayIndex(param1:int, param2:Number = 0) : void
      {
         this.hasPendingHorizontalPageIndex = false;
         this.hasPendingVerticalPageIndex = false;
         this.pendingHorizontalScrollPosition = NaN;
         this.pendingVerticalScrollPosition = NaN;
         if(this.pendingItemIndex == param1 && this.pendingScrollDuration == param2)
         {
            return;
         }
         this.pendingItemIndex = param1;
         this.pendingScrollDuration = param2;
         this.invalidate(INVALIDATION_FLAG_PENDING_SCROLL);
      }
      
      public function getItemRendererFactoryWithID(param1:String) : Function
      {
         if(Boolean(this._itemRendererFactories) && param1 in this._itemRendererFactories)
         {
            return this._itemRendererFactories[param1] as Function;
         }
         return null;
      }
      
      public function setItemRendererFactoryWithID(param1:String, param2:Function) : void
      {
         if(param1 === null)
         {
            this.itemRendererFactory = param2;
            return;
         }
         if(this._itemRendererFactories === null)
         {
            this._itemRendererFactories = {};
         }
         if(param2 !== null)
         {
            this._itemRendererFactories[param1] = param2;
         }
         else
         {
            delete this._itemRendererFactories[param1];
         }
      }
      
      public function itemToItemRenderer(param1:Object) : IListItemRenderer
      {
         return this.dataViewPort.itemToItemRenderer(param1);
      }
      
      public function addItemWithEffect(param1:Object, param2:int, param3:Function) : void
      {
         this._dataProvider.addItemAt(param1,param2);
         if(this._addedItems === null)
         {
            this._addedItems = new Dictionary();
         }
         this._addedItems[param1] = param3;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function removeItemWithEffect(param1:Object, param2:Function) : void
      {
         if(this._removedItems === null)
         {
            this._removedItems = new Dictionary();
         }
         this._removedItems[param1] = param2;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      override public function dispose() : void
      {
         this._selectedIndices.removeEventListeners();
         this._selectedIndex = -1;
         this.dataProvider = null;
         this.layout = null;
         super.dispose();
      }
      
      override protected function initialize() : void
      {
         var _loc2_:VerticalLayout = null;
         var _loc1_:Boolean = this._layout !== null;
         super.initialize();
         if(!this.dataViewPort)
         {
            this.viewPort = this.dataViewPort = new ListDataViewPort();
            this.dataViewPort.owner = this;
            this.viewPort = this.dataViewPort;
         }
         if(!_loc1_)
         {
            if(this._hasElasticEdges && this._verticalScrollPolicy === ScrollPolicy.AUTO && this._scrollBarDisplayMode !== ScrollBarDisplayMode.FIXED)
            {
               this._verticalScrollPolicy = ScrollPolicy.ON;
            }
            _loc2_ = new VerticalLayout();
            _loc2_.useVirtualLayout = true;
            _loc2_.padding = 0;
            _loc2_.gap = 0;
            _loc2_.horizontalAlign = HorizontalAlign.JUSTIFY;
            _loc2_.verticalAlign = VerticalAlign.TOP;
            this.ignoreNextStyleRestriction();
            this.layout = _loc2_;
         }
      }
      
      override protected function draw() : void
      {
         this.refreshDataViewPortProperties();
         super.draw();
      }
      
      protected function refreshDataViewPortProperties() : void
      {
         this.dataViewPort.isSelectable = this._isSelectable;
         this.dataViewPort.allowMultipleSelection = this._allowMultipleSelection;
         this.dataViewPort.selectedIndices = this._selectedIndices;
         this.dataViewPort.dataProvider = this._dataProvider;
         this.dataViewPort.itemRendererType = this._itemRendererType;
         this.dataViewPort.itemRendererFactory = this._itemRendererFactory;
         this.dataViewPort.itemRendererFactories = this._itemRendererFactories;
         this.dataViewPort.factoryIDFunction = this._factoryIDFunction;
         this.dataViewPort.itemRendererProperties = this._itemRendererProperties;
         this.dataViewPort.customItemRendererStyleName = this._customItemRendererStyleName;
         this.dataViewPort.typicalItem = this._typicalItem;
         this.dataViewPort.layout = this._layout;
         this.dataViewPort.addedItems = this._addedItems;
         this.dataViewPort.removedItems = this._removedItems;
         this.dataViewPort.dragFormat = this._dragFormat;
         this.dataViewPort.dragEnabled = this._dragEnabled;
         this.dataViewPort.dropEnabled = this._dropEnabled;
         this.dataViewPort.dropIndicatorSkin = this._dropIndicatorSkin;
         this.dataViewPort.minimumAutoScrollDistance = this._minimumAutoScrollDistance;
         this._addedItems = null;
         this._removedItems = null;
      }
      
      override protected function handlePendingScroll() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Point = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(this.pendingItemIndex >= 0)
         {
            _loc1_ = null;
            if(this._dataProvider !== null)
            {
               _loc1_ = this._dataProvider.getItemAt(this.pendingItemIndex);
            }
            if(_loc1_ is Object)
            {
               _loc2_ = Pool.getPoint();
               this.dataViewPort.getScrollPositionForIndex(this.pendingItemIndex,_loc2_);
               this.pendingItemIndex = -1;
               _loc3_ = _loc2_.x;
               _loc4_ = _loc2_.y;
               Pool.putPoint(_loc2_);
               if(_loc3_ < this._minHorizontalScrollPosition)
               {
                  _loc3_ = this._minHorizontalScrollPosition;
               }
               else if(_loc3_ > this._maxHorizontalScrollPosition)
               {
                  _loc3_ = this._maxHorizontalScrollPosition;
               }
               if(_loc4_ < this._minVerticalScrollPosition)
               {
                  _loc4_ = this._minVerticalScrollPosition;
               }
               else if(_loc4_ > this._maxVerticalScrollPosition)
               {
                  _loc4_ = this._maxVerticalScrollPosition;
               }
               this.throwTo(_loc3_,_loc4_,this.pendingScrollDuration);
            }
         }
         super.handlePendingScroll();
      }
      
      override protected function nativeStage_keyDownHandler(param1:KeyboardEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Point = null;
         if(!this._isSelectable)
         {
            super.nativeStage_keyDownHandler(param1);
            return;
         }
         if(param1.isDefaultPrevented())
         {
            return;
         }
         if(!this._dataProvider)
         {
            return;
         }
         if(this._selectedIndex != -1 && (param1.keyCode == Keyboard.SPACE || (param1.keyLocation == 4 || DeviceCapabilities.simulateDPad) && param1.keyCode == Keyboard.ENTER))
         {
            this.dispatchEventWith(Event.TRIGGERED,false,this.selectedItem);
         }
         if(param1.keyCode == Keyboard.HOME || param1.keyCode == Keyboard.END || param1.keyCode == Keyboard.PAGE_UP || param1.keyCode == Keyboard.PAGE_DOWN || param1.keyCode == Keyboard.UP || param1.keyCode == Keyboard.DOWN || param1.keyCode == Keyboard.LEFT || param1.keyCode == Keyboard.RIGHT)
         {
            _loc2_ = this.dataViewPort.calculateNavigationDestination(this.selectedIndex,param1.keyCode);
            if(this.selectedIndex != _loc2_)
            {
               param1.preventDefault();
               this.selectedIndex = _loc2_;
               _loc3_ = Pool.getPoint();
               this.dataViewPort.getNearestScrollPositionForIndex(this.selectedIndex,_loc3_);
               this.scrollToPosition(_loc3_.x,_loc3_.y,this._keyScrollDuration);
               Pool.putPoint(_loc3_);
            }
         }
      }
      
      override protected function stage_gestureDirectionalTapHandler(param1:TransformGestureEvent) : void
      {
         var _loc4_:Point = null;
         if(param1.isDefaultPrevented())
         {
            return;
         }
         var _loc2_:uint = uint(int.MAX_VALUE);
         if(param1.offsetY < 0)
         {
            _loc2_ = Keyboard.UP;
         }
         else if(param1.offsetY > 0)
         {
            _loc2_ = Keyboard.DOWN;
         }
         else if(param1.offsetX > 0)
         {
            _loc2_ = Keyboard.RIGHT;
         }
         else if(param1.offsetX < 0)
         {
            _loc2_ = Keyboard.LEFT;
         }
         if(_loc2_ == int.MAX_VALUE)
         {
            return;
         }
         var _loc3_:int = this.dataViewPort.calculateNavigationDestination(this.selectedIndex,_loc2_);
         if(this.selectedIndex != _loc3_)
         {
            param1.stopImmediatePropagation();
            this.selectedIndex = _loc3_;
            _loc4_ = Pool.getPoint();
            this.dataViewPort.getNearestScrollPositionForIndex(this.selectedIndex,_loc4_);
            this.scrollToPosition(_loc4_.x,_loc4_.y,this._keyScrollDuration);
            Pool.putPoint(_loc4_);
         }
      }
      
      protected function dataProvider_changeHandler(param1:Event) : void
      {
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      protected function dataProvider_resetHandler(param1:Event) : void
      {
         this.horizontalScrollPosition = 0;
         this.verticalScrollPosition = 0;
         this._selectedIndices.removeAll();
      }
      
      protected function dataProvider_addItemHandler(param1:Event, param2:int) : void
      {
         var _loc7_:int = 0;
         if(this._selectedIndex == -1)
         {
            return;
         }
         var _loc3_:Boolean = false;
         var _loc4_:Vector.<int> = new Vector.<int>(0);
         var _loc5_:int = this._selectedIndices.length;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = this._selectedIndices.getItemAt(_loc6_) as int;
            if(_loc7_ >= param2)
            {
               _loc7_++;
               _loc3_ = true;
            }
            _loc4_.push(_loc7_);
            _loc6_++;
         }
         if(_loc3_)
         {
            this._selectedIndices.data = _loc4_;
         }
      }
      
      protected function dataProvider_removeAllHandler(param1:Event) : void
      {
         this.selectedIndex = -1;
      }
      
      protected function dataProvider_removeItemHandler(param1:Event, param2:int) : void
      {
         var _loc7_:* = 0;
         if(this._selectedIndex == -1)
         {
            return;
         }
         var _loc3_:Boolean = false;
         var _loc4_:Vector.<int> = new Vector.<int>(0);
         var _loc5_:int = this._selectedIndices.length;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = this._selectedIndices.getItemAt(_loc6_) as int;
            if(_loc7_ == param2)
            {
               _loc3_ = true;
            }
            else
            {
               if(_loc7_ > param2)
               {
                  _loc7_--;
                  _loc3_ = true;
               }
               _loc4_.push(_loc7_);
            }
            _loc6_++;
         }
         if(_loc3_)
         {
            this._selectedIndices.data = _loc4_;
         }
      }
      
      protected function refreshSelectedIndicesAfterFilterOrSort() : void
      {
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(this._selectedIndex == -1)
         {
            return;
         }
         var _loc1_:Boolean = false;
         var _loc2_:Vector.<int> = new Vector.<int>(0);
         var _loc3_:int = 0;
         var _loc4_:int = int(this._selectedItems.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = this._selectedItems[_loc5_];
            _loc7_ = this._selectedIndices.getItemAt(_loc5_) as int;
            _loc8_ = this._dataProvider.getItemIndex(_loc6_);
            if(_loc8_ >= 0)
            {
               if(_loc8_ != _loc7_)
               {
                  _loc1_ = true;
               }
               _loc2_[_loc3_] = _loc8_;
               _loc3_++;
            }
            else
            {
               _loc1_ = true;
            }
            _loc5_++;
         }
         if(_loc1_)
         {
            this._selectedIndices.data = _loc2_;
         }
      }
      
      protected function dataProvider_filterChangeHandler(param1:Event) : void
      {
         this.refreshSelectedIndicesAfterFilterOrSort();
      }
      
      protected function dataProvider_sortChangeHandler(param1:Event) : void
      {
         this.refreshSelectedIndicesAfterFilterOrSort();
      }
      
      protected function dataProvider_replaceItemHandler(param1:Event, param2:int) : void
      {
         if(this._selectedIndex == -1)
         {
            return;
         }
         var _loc3_:int = this._selectedIndices.getItemIndex(param2);
         if(_loc3_ >= 0)
         {
            this._selectedIndices.removeItemAt(_loc3_);
         }
      }
      
      protected function selectedIndices_changeHandler(param1:Event) : void
      {
         this.getSelectedItems(this._selectedItems);
         if(this._selectedIndices.length > 0)
         {
            this._selectedIndex = this._selectedIndices.getItemAt(0) as int;
         }
         else
         {
            if(this._selectedIndex < 0)
            {
               return;
            }
            this._selectedIndex = -1;
         }
         this.dispatchEventWith(Event.CHANGE);
      }
      
      private function layout_scrollHandler(param1:Event, param2:Point) : void
      {
         var _loc3_:IVariableVirtualLayout = IVariableVirtualLayout(this._layout);
         if(!this.isScrolling || !_loc3_.useVirtualLayout || !_loc3_.hasVariableItemDimensions)
         {
            return;
         }
         var _loc4_:Number = param2.x;
         this._startHorizontalScrollPosition += _loc4_;
         this._horizontalScrollPosition += _loc4_;
         if(this._horizontalAutoScrollTween)
         {
            this._targetHorizontalScrollPosition += _loc4_;
            this.throwTo(this._targetHorizontalScrollPosition,NaN,this._horizontalAutoScrollTween.totalTime - this._horizontalAutoScrollTween.currentTime);
         }
         var _loc5_:Number = param2.y;
         this._startVerticalScrollPosition += _loc5_;
         this._verticalScrollPosition += _loc5_;
         if(this._verticalAutoScrollTween)
         {
            this._targetVerticalScrollPosition += _loc5_;
            this.throwTo(NaN,this._targetVerticalScrollPosition,this._verticalAutoScrollTween.totalTime - this._verticalAutoScrollTween.currentTime);
         }
      }
   }
}

