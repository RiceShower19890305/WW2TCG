package feathers.controls
{
   import feathers.controls.renderers.DefaultDataGridHeaderRenderer;
   import feathers.controls.renderers.IDataGridHeaderRenderer;
   import feathers.controls.supportClasses.DataGridDataViewPort;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.IValidating;
   import feathers.data.ArrayCollection;
   import feathers.data.IListCollection;
   import feathers.data.ListCollection;
   import feathers.data.SortOrder;
   import feathers.display.RenderDelegate;
   import feathers.dragDrop.DragData;
   import feathers.dragDrop.DragDropManager;
   import feathers.dragDrop.IDragSource;
   import feathers.dragDrop.IDropTarget;
   import feathers.events.CollectionEventType;
   import feathers.events.DragDropEvent;
   import feathers.events.FeathersEventType;
   import feathers.layout.HorizontalAlign;
   import feathers.layout.HorizontalLayout;
   import feathers.layout.HorizontalLayoutData;
   import feathers.layout.ILayout;
   import feathers.layout.IVariableVirtualLayout;
   import feathers.layout.VerticalAlign;
   import feathers.layout.VerticalLayout;
   import feathers.skins.IStyleProvider;
   import feathers.system.DeviceCapabilities;
   import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;
   import flash.errors.IllegalOperationError;
   import flash.events.KeyboardEvent;
   import flash.events.TransformGestureEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import starling.display.DisplayObject;
   import starling.display.Quad;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Pool;
   import starling.utils.SystemUtil;
   
   public class DataGrid extends Scroller implements IDragSource, IDropTarget
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      protected static const DATA_GRID_HEADER_DRAG_FORMAT:String = "feathers-data-grid-header";
      
      protected var dataViewPort:DataGridDataViewPort;
      
      protected var _headerGroup:LayoutGroup = null;
      
      protected var _headerDividerGroup:LayoutGroup = null;
      
      protected var _verticalDividerGroup:LayoutGroup = null;
      
      protected var _headerLayout:HorizontalLayout = null;
      
      protected var _headerRendererMap:Dictionary = new Dictionary(true);
      
      protected var _unrenderedHeaders:Vector.<int> = new Vector.<int>(0);
      
      protected var _headerStorage:HeaderRendererFactoryStorage = new HeaderRendererFactoryStorage();
      
      protected var _headerDividerStorage:DividerFactoryStorage = new DividerFactoryStorage();
      
      protected var _verticalDividerStorage:DividerFactoryStorage = new DividerFactoryStorage();
      
      protected var _isChildFocusEnabled:Boolean = true;
      
      protected var _reorderColumns:Boolean = false;
      
      protected var _sortableColumns:Boolean = false;
      
      protected var _resizableColumns:Boolean = false;
      
      protected var _currentColumnDropIndicatorSkin:DisplayObject = null;
      
      protected var _columnDropIndicatorSkin:DisplayObject = null;
      
      protected var _currentColumnResizeSkin:DisplayObject = null;
      
      protected var _columnResizeSkin:DisplayObject = null;
      
      protected var _currentColumnDragOverlaySkin:DisplayObject = null;
      
      protected var _columnDragOverlaySkin:DisplayObject = null;
      
      protected var _columnDragAvatarAlpha:Number = 0.8;
      
      protected var _extendedColumnDropIndicator:Boolean = false;
      
      protected var _layout:ILayout = null;
      
      protected var _updateForDataReset:Boolean = false;
      
      protected var _dataProvider:IListCollection;
      
      protected var _columns:IListCollection = null;
      
      protected var _isSelectable:Boolean = true;
      
      protected var _selectedIndex:int = -1;
      
      protected var _allowMultipleSelection:Boolean = false;
      
      protected var _selectedIndices:ListCollection = new ListCollection(new Vector.<int>(0));
      
      protected var _selectedItems:Vector.<Object> = new Vector.<Object>(0);
      
      protected var _typicalItem:Object = null;
      
      protected var _keyScrollDuration:Number = 0.25;
      
      protected var _headerBackgroundSkin:DisplayObject = null;
      
      protected var _headerBackgroundDisabledSkin:DisplayObject = null;
      
      protected var _verticalDividerFactory:Function = null;
      
      protected var _headerDividerFactory:Function = null;
      
      protected var _cellRendererFactory:Function = null;
      
      protected var _customCellRendererStyleName:String = null;
      
      protected var _headerRendererFactory:Function = null;
      
      protected var _customHeaderRendererStyleName:String = null;
      
      protected var _draggedHeaderIndex:int = -1;
      
      protected var _headerTouchID:int = -1;
      
      protected var _headerTouchX:Number;
      
      protected var _headerTouchY:Number;
      
      protected var _headerDividerTouchID:int = -1;
      
      protected var _headerDividerTouchX:Number;
      
      protected var _resizingColumnIndex:int = -1;
      
      protected var _customColumnSizes:Vector.<Number> = null;
      
      protected var pendingItemIndex:int = -1;
      
      protected var _reverseSort:Boolean = false;
      
      protected var _sortedColumn:DataGridColumn = null;
      
      public function DataGrid()
      {
         super();
         this.addEventListener(DragDropEvent.DRAG_ENTER,this.dataGrid_dragEnterHandler);
         this.addEventListener(DragDropEvent.DRAG_MOVE,this.dataGrid_dragMoveHandler);
         this.addEventListener(DragDropEvent.DRAG_DROP,this.dataGrid_dragDropHandler);
         this._selectedIndices.addEventListener(Event.CHANGE,this.selectedIndices_changeHandler);
      }
      
      protected static function defaultSortCompareFunction(param1:Object, param2:Object) : int
      {
         var _loc3_:String = param1.toString().toLowerCase();
         var _loc4_:String = param2.toString().toLowerCase();
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         return 0;
      }
      
      protected static function defaultHeaderRendererFactory() : IDataGridHeaderRenderer
      {
         return new DefaultDataGridHeaderRenderer();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return DataGrid.globalStyleProvider;
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
      
      public function get reorderColumns() : Boolean
      {
         return this._reorderColumns;
      }
      
      public function set reorderColumns(param1:Boolean) : void
      {
         this._reorderColumns = param1;
      }
      
      public function get sortableColumns() : Boolean
      {
         return this._sortableColumns;
      }
      
      public function set sortableColumns(param1:Boolean) : void
      {
         this._sortableColumns = param1;
      }
      
      public function get resizableColumns() : Boolean
      {
         return this._resizableColumns;
      }
      
      public function set resizableColumns(param1:Boolean) : void
      {
         this._resizableColumns = param1;
      }
      
      public function get columnDropIndicatorSkin() : DisplayObject
      {
         return this._columnDropIndicatorSkin;
      }
      
      public function set columnDropIndicatorSkin(param1:DisplayObject) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            if(param1 !== null)
            {
               param1.dispose();
            }
            return;
         }
         this._columnDropIndicatorSkin = param1;
      }
      
      public function get columnResizeSkin() : DisplayObject
      {
         return this._columnResizeSkin;
      }
      
      public function set columnResizeSkin(param1:DisplayObject) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            if(param1 !== null)
            {
               param1.dispose();
            }
            return;
         }
         this._columnResizeSkin = param1;
      }
      
      public function get columnDragOverlaySkin() : DisplayObject
      {
         return this._columnDragOverlaySkin;
      }
      
      public function set columnDragOverlaySkin(param1:DisplayObject) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            if(param1 !== null)
            {
               param1.dispose();
            }
            return;
         }
         this._columnDragOverlaySkin = param1;
      }
      
      public function get columnDragAvatarAlpha() : Number
      {
         return this._columnDragAvatarAlpha;
      }
      
      public function set columnDragAvatarAlpha(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         this._columnDragAvatarAlpha = param1;
      }
      
      public function get extendedColumnDropIndicator() : Boolean
      {
         return this._extendedColumnDropIndicator;
      }
      
      public function set extendedColumnDropIndicator(param1:Boolean) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         this._extendedColumnDropIndicator = param1;
      }
      
      protected function get layout() : ILayout
      {
         return this._layout;
      }
      
      protected function set layout(param1:ILayout) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._layout === param1)
         {
            return;
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
            this._dataProvider.removeEventListener(CollectionEventType.FILTER_CHANGE,this.dataProvider_filterChangeHandler);
            this._dataProvider.removeEventListener(CollectionEventType.SORT_CHANGE,this.dataProvider_sortChangeHandler);
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
            this._dataProvider.addEventListener(CollectionEventType.FILTER_CHANGE,this.dataProvider_filterChangeHandler);
            this._dataProvider.addEventListener(CollectionEventType.SORT_CHANGE,this.dataProvider_sortChangeHandler);
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
      
      public function get columns() : IListCollection
      {
         return this._columns;
      }
      
      public function set columns(param1:IListCollection) : void
      {
         if(this._columns === param1)
         {
            return;
         }
         this.setColumns(param1);
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      protected function setColumns(param1:IListCollection) : void
      {
         if(this._columns !== null)
         {
            this._columns.removeEventListener(Event.CHANGE,this.columns_changeHandler);
            this._columns.removeEventListener(CollectionEventType.RESET,this.columns_resetHandler);
            this._columns.removeEventListener(CollectionEventType.UPDATE_ALL,this.columns_updateAllHandler);
         }
         this._columns = param1;
         if(this._columns !== null)
         {
            this._columns.addEventListener(Event.CHANGE,this.columns_changeHandler);
            this._columns.addEventListener(CollectionEventType.RESET,this.columns_resetHandler);
            this._columns.addEventListener(CollectionEventType.UPDATE_ALL,this.columns_updateAllHandler);
         }
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
      
      public function get headerBackgroundSkin() : DisplayObject
      {
         return this._headerBackgroundSkin;
      }
      
      public function set headerBackgroundSkin(param1:DisplayObject) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            if(param1 !== null)
            {
               param1.dispose();
            }
            return;
         }
         if(this._headerBackgroundSkin === param1)
         {
            return;
         }
         this._headerBackgroundSkin = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get headerBackgroundDisabledSkin() : DisplayObject
      {
         return this._headerBackgroundDisabledSkin;
      }
      
      public function set headerBackgroundDisabledSkin(param1:DisplayObject) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            if(param1 !== null)
            {
               param1.dispose();
            }
            return;
         }
         if(this._headerBackgroundDisabledSkin === param1)
         {
            return;
         }
         this._headerBackgroundDisabledSkin = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get verticalDividerFactory() : Function
      {
         return this._verticalDividerFactory;
      }
      
      public function set verticalDividerFactory(param1:Function) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._verticalDividerFactory === param1)
         {
            return;
         }
         this._verticalDividerFactory = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get headerDividerFactory() : Function
      {
         return this._headerDividerFactory;
      }
      
      public function set headerDividerFactory(param1:Function) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._headerDividerFactory === param1)
         {
            return;
         }
         this._headerDividerFactory = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get cellRendererFactory() : Function
      {
         return this._cellRendererFactory;
      }
      
      public function set cellRendererFactory(param1:Function) : void
      {
         if(this._cellRendererFactory === param1)
         {
            return;
         }
         this._cellRendererFactory = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get customCellRendererStyleName() : String
      {
         return this._customCellRendererStyleName;
      }
      
      public function set customCellRendererStyleName(param1:String) : void
      {
         if(this._customCellRendererStyleName === param1)
         {
            return;
         }
         this._customCellRendererStyleName = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get headerRendererFactory() : Function
      {
         return this._headerRendererFactory;
      }
      
      public function set headerRendererFactory(param1:Function) : void
      {
         if(this._headerRendererFactory === param1)
         {
            return;
         }
         this._headerRendererFactory = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get customHeaderRendererStyleName() : String
      {
         return this._customHeaderRendererStyleName;
      }
      
      public function set customHeaderRendererStyleName(param1:String) : void
      {
         if(this._customHeaderRendererStyleName === param1)
         {
            return;
         }
         this._customHeaderRendererStyleName = param1;
         this.dispatchEventWith(Event.CHANGE);
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
      
      override public function dispose() : void
      {
         if(this._columnDropIndicatorSkin !== null && this._columnDropIndicatorSkin.parent === null)
         {
            this._columnDropIndicatorSkin.dispose();
            this._columnDropIndicatorSkin = null;
         }
         if(this._columnDragOverlaySkin !== null && this._columnDragOverlaySkin.parent === null)
         {
            this._columnDragOverlaySkin.dispose();
            this._columnDragOverlaySkin = null;
         }
         this.refreshInactiveHeaderDividers(true);
         this.refreshInactiveVerticalDividers(true);
         this._selectedIndices.removeEventListeners();
         this._selectedIndex = -1;
         this.dataProvider = null;
         this.columns = null;
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
            this.viewPort = this.dataViewPort = new DataGridDataViewPort();
            this.dataViewPort.owner = this;
            this.viewPort = this.dataViewPort;
         }
         if(this._verticalDividerGroup === null)
         {
            this._verticalDividerGroup = new LayoutGroup();
            this._verticalDividerGroup.touchable = false;
            this.addChild(this._verticalDividerGroup);
         }
         if(this._headerLayout === null)
         {
            this._headerLayout = new HorizontalLayout();
            this._headerLayout.useVirtualLayout = false;
            this._headerLayout.verticalAlign = VerticalAlign.JUSTIFY;
         }
         if(this._headerGroup === null)
         {
            this._headerGroup = new LayoutGroup();
            this.addChild(this._headerGroup);
         }
         this._headerGroup.layout = this._headerLayout;
         if(this._headerDividerGroup === null)
         {
            this._headerDividerGroup = new LayoutGroup();
            this.addChild(this._headerDividerGroup);
         }
         if(!_loc1_)
         {
            if(this._hasElasticEdges && this._verticalScrollPolicy === ScrollPolicy.AUTO && this._scrollBarDisplayMode !== ScrollBarDisplayMode.FIXED)
            {
               this._verticalScrollPolicy = ScrollPolicy.ON;
            }
            _loc2_ = new VerticalLayout();
            _loc2_.useVirtualLayout = true;
            _loc2_.horizontalAlign = HorizontalAlign.JUSTIFY;
            this.ignoreNextStyleRestriction();
            this.layout = _loc2_;
         }
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         if(_loc1_)
         {
            this.refreshHeaderStyles();
         }
         this.refreshColumns();
         this.refreshHeaderRenderers();
         this.refreshDataViewPortProperties();
         super.draw();
      }
      
      override protected function autoSizeIfNeeded() : Boolean
      {
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc1_:Boolean = this._explicitWidth !== this._explicitWidth;
         var _loc2_:Boolean = this._explicitHeight !== this._explicitHeight;
         var _loc3_:Boolean = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc4_:Boolean = this._explicitMinHeight !== this._explicitMinHeight;
         if(!_loc1_ && !_loc2_ && !_loc3_ && !_loc4_)
         {
            return false;
         }
         resetFluidChildDimensionsForMeasurement(this.currentBackgroundSkin,this._explicitWidth,this._explicitHeight,this._explicitMinWidth,this._explicitMinHeight,this._explicitMaxWidth,this._explicitMaxHeight,this._explicitBackgroundWidth,this._explicitBackgroundHeight,this._explicitBackgroundMinWidth,this._explicitBackgroundMinHeight,this._explicitBackgroundMaxWidth,this._explicitBackgroundMaxHeight);
         var _loc5_:IMeasureDisplayObject = this.currentBackgroundSkin as IMeasureDisplayObject;
         if(this.currentBackgroundSkin is IValidating)
         {
            IValidating(this.currentBackgroundSkin).validate();
         }
         var _loc6_:Number = this._explicitWidth;
         var _loc7_:Number = this._explicitHeight;
         var _loc8_:Number = this._explicitMinWidth;
         var _loc9_:Number = this._explicitMinHeight;
         if(_loc1_)
         {
            if(this._measureViewPort)
            {
               _loc6_ = this._viewPort.visibleWidth;
            }
            else
            {
               _loc6_ = 0;
            }
            _loc6_ += this._rightViewPortOffset + this._leftViewPortOffset;
            _loc10_ = this._headerGroup.width;
            if(_loc10_ > _loc6_)
            {
               _loc6_ = _loc10_;
            }
            if(this.currentBackgroundSkin !== null && this.currentBackgroundSkin.width > _loc6_)
            {
               _loc6_ = this.currentBackgroundSkin.width;
            }
         }
         if(_loc2_)
         {
            if(this._measureViewPort)
            {
               _loc7_ = this._viewPort.visibleHeight;
            }
            else
            {
               _loc7_ = 0;
            }
            _loc7_ += this._bottomViewPortOffset + this._topViewPortOffset;
            if(this.currentBackgroundSkin !== null && this.currentBackgroundSkin.height > _loc7_)
            {
               _loc7_ = this.currentBackgroundSkin.height;
            }
         }
         if(_loc3_)
         {
            if(this._measureViewPort)
            {
               _loc8_ = this._viewPort.minVisibleWidth;
            }
            else
            {
               _loc8_ = 0;
            }
            _loc8_ += this._rightViewPortOffset + this._leftViewPortOffset;
            _loc11_ = this._headerGroup.minWidth;
            if(_loc11_ > _loc8_)
            {
               _loc8_ = _loc11_;
            }
            if(this.currentBackgroundSkin !== null)
            {
               if(_loc5_ !== null)
               {
                  if(_loc5_.minWidth > _loc8_)
                  {
                     _loc8_ = _loc5_.minWidth;
                  }
               }
               else if(this._explicitBackgroundMinWidth > _loc8_)
               {
                  _loc8_ = this._explicitBackgroundMinWidth;
               }
            }
         }
         if(_loc4_)
         {
            if(this._measureViewPort)
            {
               _loc9_ = this._viewPort.minVisibleHeight;
            }
            else
            {
               _loc9_ = 0;
            }
            _loc9_ += this._bottomViewPortOffset + this._topViewPortOffset;
            if(this.currentBackgroundSkin !== null)
            {
               if(_loc5_ !== null)
               {
                  if(_loc5_.minHeight > _loc9_)
                  {
                     _loc9_ = _loc5_.minHeight;
                  }
               }
               else if(this._explicitBackgroundMinHeight > _loc9_)
               {
                  _loc9_ = this._explicitBackgroundMinHeight;
               }
            }
         }
         return this.saveMeasurements(_loc6_,_loc7_,_loc8_,_loc9_);
      }
      
      protected function refreshColumns() : void
      {
         var _loc4_:String = null;
         if(this._columns !== null || this._dataProvider === null || this._dataProvider.length == 0)
         {
            return;
         }
         var _loc1_:Array = [];
         var _loc2_:Object = this._dataProvider.getItemAt(0);
         var _loc3_:int = 0;
         for(_loc4_ in _loc2_)
         {
            _loc1_[_loc3_] = new DataGridColumn(_loc4_);
            _loc3_++;
         }
         this.setColumns(new ArrayCollection(_loc1_));
      }
      
      protected function refreshHeaderStyles() : void
      {
         this._headerGroup.backgroundSkin = this._headerBackgroundSkin;
         this._headerGroup.backgroundDisabledSkin = this._headerBackgroundDisabledSkin;
      }
      
      override protected function calculateViewPortOffsets(param1:Boolean = false, param2:Boolean = false) : void
      {
         super.calculateViewPortOffsets(param1,param2);
         this._headerLayout.paddingLeft = this._leftViewPortOffset;
         this._headerLayout.paddingRight = this._rightViewPortOffset;
         if(param2)
         {
            this._headerGroup.width = this.actualWidth;
            this._headerGroup.minWidth = this.actualMinWidth;
         }
         else
         {
            this._headerGroup.width = this._explicitWidth;
            this._headerGroup.minWidth = this._explicitMinWidth;
         }
         this._headerGroup.maxWidth = this._explicitMaxWidth;
         this._headerGroup.validate();
         this._topViewPortOffset += this._headerGroup.height;
      }
      
      override protected function layoutChildren() : void
      {
         this.validateCustomColumnSizes();
         this.layoutHeaderRenderers();
         this._headerLayout.paddingLeft = this._leftViewPortOffset;
         this._headerLayout.paddingRight = this._rightViewPortOffset;
         this._headerGroup.width = this.actualWidth;
         this._headerGroup.validate();
         this._headerGroup.x = 0;
         this._headerGroup.y = this._topViewPortOffset - this._headerGroup.height;
         this._headerDividerGroup.x = this._headerGroup.x;
         this._headerDividerGroup.y = this._headerGroup.y;
         this._headerDividerGroup.width = this._headerGroup.width;
         super.layoutChildren();
         this._verticalDividerGroup.x = this._headerGroup.x;
         this._verticalDividerGroup.y = this._headerGroup.y + this._headerGroup.height;
         this._verticalDividerGroup.width = this._headerGroup.width;
         this._verticalDividerGroup.height = this.viewPort.visibleHeight;
         this.refreshHeaderDividers();
         this.refreshVerticalDividers();
      }
      
      protected function validateCustomColumnSizes() : void
      {
         var _loc7_:DataGridColumn = null;
         var _loc8_:Number = NaN;
         if(this._customColumnSizes === null || this._customColumnSizes.length < this._columns.length)
         {
            return;
         }
         var _loc1_:Number = this.actualWidth - this._leftViewPortOffset - this._rightViewPortOffset;
         var _loc2_:int = int(this._customColumnSizes.length);
         var _loc3_:Number = 0;
         var _loc4_:Vector.<int> = new Vector.<int>(0);
         var _loc5_:int = 0;
         while(_loc5_ < _loc2_)
         {
            _loc7_ = DataGridColumn(this._columns.getItemAt(_loc5_));
            if(_loc7_.width === _loc7_.width)
            {
               _loc1_ -= _loc7_.width;
            }
            else
            {
               _loc8_ = this._customColumnSizes[_loc5_];
               _loc3_ += _loc8_;
               _loc4_[_loc5_] = _loc5_;
            }
            _loc5_++;
         }
         if(_loc3_ == _loc1_)
         {
            return;
         }
         this._customColumnSizes = this._customColumnSizes.slice();
         var _loc6_:Number = _loc1_ - _loc3_;
         this.distributeWidthToIndices(_loc6_,_loc4_,_loc3_);
         this.dataViewPort.customColumnSizes = this._customColumnSizes;
      }
      
      protected function distributeWidthToIndices(param1:Number, param2:Vector.<int>, param3:Number) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:* = 0;
         var _loc7_:int = 0;
         var _loc8_:IDataGridHeaderRenderer = null;
         var _loc9_:Number = NaN;
         var _loc10_:DataGridColumn = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         while(Math.abs(param1) > 1)
         {
            _loc4_ = param1;
            _loc5_ = int(param2.length);
            _loc6_ = int(_loc5_ - 1);
            while(_loc6_ >= 0)
            {
               _loc7_ = param2[_loc6_];
               _loc8_ = IDataGridHeaderRenderer(this._headerGroup.getChildAt(_loc7_));
               _loc9_ = Number(_loc8_.width);
               _loc10_ = DataGridColumn(this._columns.getItemAt(_loc7_));
               _loc11_ = _loc9_ / param3;
               _loc12_ = param1 * _loc11_;
               _loc13_ = this._customColumnSizes[_loc7_] + _loc12_;
               if(_loc13_ < _loc10_.minWidth)
               {
                  _loc12_ += _loc10_.minWidth - _loc13_;
                  _loc13_ = _loc10_.minWidth;
                  param2.removeAt(_loc6_);
                  param3 -= _loc9_;
               }
               this._customColumnSizes[_loc7_] = _loc13_;
               _loc4_ -= _loc12_;
               _loc6_--;
            }
            param1 = _loc4_;
         }
         if(param1 != 0)
         {
            this._customColumnSizes[this._customColumnSizes.length - 1] += param1;
         }
      }
      
      protected function layoutHeaderRenderers() : void
      {
         var _loc3_:IDataGridHeaderRenderer = null;
         var _loc4_:DataGridColumn = null;
         var _loc1_:int = 0;
         if(this._columns !== null)
         {
            _loc1_ = this._columns.length;
         }
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = IDataGridHeaderRenderer(this._headerGroup.getChildAt(_loc2_));
            _loc4_ = DataGridColumn(this._columns.getItemAt(_loc2_));
            if(_loc4_.width === _loc4_.width)
            {
               _loc3_.width = _loc4_.width;
               _loc3_.layoutData = null;
            }
            else if(this._customColumnSizes !== null && _loc2_ < this._customColumnSizes.length)
            {
               _loc3_.width = this._customColumnSizes[_loc2_];
               _loc3_.layoutData = null;
            }
            else if(_loc3_.layoutData === null)
            {
               _loc3_.layoutData = new HorizontalLayoutData(100);
            }
            _loc3_.minWidth = _loc4_.minWidth;
            _loc2_++;
         }
      }
      
      protected function refreshVerticalDividers() : void
      {
         var _loc6_:DisplayObject = null;
         var _loc7_:IDataGridHeaderRenderer = null;
         this.refreshInactiveVerticalDividers(this._verticalDividerStorage.factory !== this._verticalDividerFactory);
         this._verticalDividerStorage.factory = this._verticalDividerFactory;
         var _loc1_:int = 0;
         if(this._columns !== null)
         {
            _loc1_ = this._columns.length;
         }
         var _loc2_:int = 0;
         if(this._verticalDividerFactory !== null)
         {
            _loc2_ = _loc1_ - 1;
         }
         this._headerGroup.validate();
         var _loc3_:Vector.<DisplayObject> = this._verticalDividerStorage.activeDividers;
         var _loc4_:Vector.<DisplayObject> = this._verticalDividerStorage.inactiveDividers;
         var _loc5_:int = 0;
         while(_loc5_ < _loc2_)
         {
            _loc6_ = null;
            if(_loc4_.length > 0)
            {
               _loc6_ = _loc4_.shift();
               this._verticalDividerGroup.setChildIndex(_loc6_,_loc5_);
            }
            else
            {
               _loc6_ = DisplayObject(this._verticalDividerFactory());
               this._verticalDividerGroup.addChildAt(_loc6_,_loc5_);
            }
            _loc3_[_loc5_] = _loc6_;
            _loc6_.height = this._viewPort.visibleHeight;
            if(_loc6_ is IValidating)
            {
               IValidating(_loc6_).validate();
            }
            _loc7_ = IDataGridHeaderRenderer(this._headerGroup.getChildAt(_loc5_));
            _loc6_.x = _loc7_.x + _loc7_.width - _loc6_.width / 2;
            _loc6_.y = 0;
            _loc5_++;
         }
         this.freeInactiveVerticalDividers();
      }
      
      protected function refreshInactiveVerticalDividers(param1:Boolean) : void
      {
         var _loc2_:Vector.<DisplayObject> = this._verticalDividerStorage.inactiveDividers;
         this._verticalDividerStorage.inactiveDividers = this._verticalDividerStorage.activeDividers;
         this._verticalDividerStorage.activeDividers = _loc2_;
         if(param1)
         {
            this.freeInactiveVerticalDividers();
         }
      }
      
      protected function freeInactiveVerticalDividers() : void
      {
         var _loc4_:DisplayObject = null;
         var _loc1_:Vector.<DisplayObject> = this._verticalDividerStorage.inactiveDividers;
         var _loc2_:int = int(_loc1_.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = _loc1_.shift();
            _loc4_.removeFromParent(true);
            _loc3_++;
         }
      }
      
      protected function refreshHeaderDividers() : void
      {
         var _loc5_:DisplayObject = null;
         var _loc6_:IDataGridHeaderRenderer = null;
         this.refreshInactiveHeaderDividers(this._headerDividerStorage.factory !== this._headerDividerFactory);
         this._headerDividerStorage.factory = this._headerDividerFactory;
         var _loc1_:* = 0;
         if(this._columns !== null)
         {
            _loc1_ = this._columns.length;
            if(this._scrollBarDisplayMode !== ScrollBarDisplayMode.FIXED || this._minVerticalScrollPosition == this._maxVerticalScrollPosition)
            {
               _loc1_--;
            }
         }
         this._headerGroup.validate();
         var _loc2_:Vector.<DisplayObject> = this._headerDividerStorage.activeDividers;
         var _loc3_:Vector.<DisplayObject> = this._headerDividerStorage.inactiveDividers;
         var _loc4_:int = 0;
         while(_loc4_ < _loc1_)
         {
            _loc5_ = null;
            if(_loc3_.length > 0)
            {
               _loc5_ = _loc3_.shift();
               this._headerDividerGroup.setChildIndex(_loc5_,_loc4_);
            }
            else if(this._headerDividerFactory !== null)
            {
               _loc5_ = DisplayObject(this._headerDividerFactory());
               _loc5_.addEventListener(TouchEvent.TOUCH,this.headerDivider_touchHandler);
               this._headerDividerGroup.addChildAt(_loc5_,_loc4_);
            }
            else
            {
               _loc5_ = new Quad(3,1,16711935);
               _loc5_.alpha = 0;
               if(!SystemUtil.isDesktop)
               {
                  _loc5_.width = 22;
               }
               _loc5_.addEventListener(TouchEvent.TOUCH,this.headerDivider_touchHandler);
               this._headerDividerGroup.addChildAt(_loc5_,_loc4_);
            }
            _loc2_[_loc4_] = _loc5_;
            _loc6_ = IDataGridHeaderRenderer(this._headerGroup.getChildAt(_loc4_));
            _loc5_.height = _loc6_.height;
            if(_loc5_ is IValidating)
            {
               IValidating(_loc5_).validate();
            }
            _loc5_.x = _loc6_.x + _loc6_.width - _loc5_.width / 2;
            _loc5_.y = _loc6_.y;
            _loc4_++;
         }
         this.freeInactiveHeaderDividers();
      }
      
      protected function refreshInactiveHeaderDividers(param1:Boolean) : void
      {
         var _loc2_:Vector.<DisplayObject> = this._headerDividerStorage.inactiveDividers;
         this._headerDividerStorage.inactiveDividers = this._headerDividerStorage.activeDividers;
         this._headerDividerStorage.activeDividers = _loc2_;
         if(param1)
         {
            this.freeInactiveHeaderDividers();
         }
      }
      
      protected function freeInactiveHeaderDividers() : void
      {
         var _loc4_:DisplayObject = null;
         var _loc1_:Vector.<DisplayObject> = this._headerDividerStorage.inactiveDividers;
         var _loc2_:int = int(_loc1_.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = _loc1_.shift();
            _loc4_.removeEventListener(TouchEvent.TOUCH,this.headerDivider_touchHandler);
            _loc4_.removeFromParent(true);
            _loc3_++;
         }
      }
      
      protected function refreshHeaderRenderers() : void
      {
         this.findUnrenderedData();
         this.recoverInactiveHeaderRenderers();
         this.renderUnrenderedData();
         this.freeInactiveHeaderRenderers();
         this._updateForDataReset = false;
      }
      
      protected function findUnrenderedData() : void
      {
         var _loc8_:DataGridColumn = null;
         var _loc9_:IDataGridHeaderRenderer = null;
         var _loc10_:int = 0;
         var _loc1_:Vector.<IDataGridHeaderRenderer> = this._headerStorage.inactiveHeaderRenderers;
         this._headerStorage.inactiveHeaderRenderers = this._headerStorage.activeHeaderRenderers;
         this._headerStorage.activeHeaderRenderers = _loc1_;
         var _loc2_:Vector.<IDataGridHeaderRenderer> = this._headerStorage.activeHeaderRenderers;
         var _loc3_:Vector.<IDataGridHeaderRenderer> = this._headerStorage.inactiveHeaderRenderers;
         var _loc4_:int = 0;
         if(this._columns !== null)
         {
            _loc4_ = this._columns.length;
         }
         var _loc5_:int = int(_loc2_.length);
         var _loc6_:int = int(this._unrenderedHeaders.length);
         var _loc7_:int = 0;
         while(_loc7_ < _loc4_)
         {
            _loc8_ = DataGridColumn(this._columns.getItemAt(_loc7_));
            _loc9_ = this._headerRendererMap[_loc8_] as IDataGridHeaderRenderer;
            if(_loc9_ !== null)
            {
               _loc9_.columnIndex = _loc7_;
               _loc9_.visible = true;
               if(_loc8_ === this._sortedColumn)
               {
                  if(this._reverseSort)
                  {
                     _loc9_.sortOrder = SortOrder.DESCENDING;
                  }
                  else
                  {
                     _loc9_.sortOrder = SortOrder.ASCENDING;
                  }
               }
               else
               {
                  _loc9_.sortOrder = SortOrder.NONE;
               }
               this._headerGroup.setChildIndex(DisplayObject(_loc9_),_loc7_);
               if(this._updateForDataReset)
               {
                  _loc9_.data = null;
                  _loc9_.data = _loc8_;
               }
               _loc2_[_loc5_] = _loc9_;
               _loc5_++;
               _loc10_ = _loc3_.indexOf(_loc9_);
               if(_loc10_ < 0)
               {
                  throw new IllegalOperationError("DataGrid: header renderer map contains bad data. This may be caused by duplicate items in the columns collection, which is not allowed.");
               }
               _loc3_[_loc10_] = null;
            }
            else
            {
               this._unrenderedHeaders[_loc6_] = _loc7_;
               _loc6_++;
            }
            _loc7_++;
         }
      }
      
      protected function recoverInactiveHeaderRenderers() : void
      {
         var _loc4_:IDataGridHeaderRenderer = null;
         var _loc1_:Vector.<IDataGridHeaderRenderer> = this._headerStorage.inactiveHeaderRenderers;
         var _loc2_:int = int(_loc1_.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = _loc1_[_loc3_];
            if(!(_loc4_ === null || _loc4_.data === null))
            {
               this.dispatchEventWith(FeathersEventType.RENDERER_REMOVE,false,_loc4_);
               delete this._headerRendererMap[_loc4_.data];
            }
            _loc3_++;
         }
      }
      
      protected function renderUnrenderedData() : void
      {
         var _loc3_:int = 0;
         var _loc4_:DataGridColumn = null;
         var _loc1_:int = int(this._unrenderedHeaders.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._unrenderedHeaders.shift();
            _loc4_ = DataGridColumn(this._columns.getItemAt(_loc3_));
            this.createHeaderRenderer(_loc4_,_loc3_);
            _loc2_++;
         }
      }
      
      protected function freeInactiveHeaderRenderers() : void
      {
         var _loc4_:IDataGridHeaderRenderer = null;
         var _loc1_:Vector.<IDataGridHeaderRenderer> = this._headerStorage.inactiveHeaderRenderers;
         var _loc2_:int = int(_loc1_.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = _loc1_.shift();
            if(_loc4_ !== null)
            {
               this.destroyHeaderRenderer(_loc4_);
            }
            _loc3_++;
         }
      }
      
      protected function createHeaderRenderer(param1:DataGridColumn, param2:int) : IDataGridHeaderRenderer
      {
         var _loc3_:Function = param1.headerRendererFactory;
         if(_loc3_ === null)
         {
            _loc3_ = this._headerRendererFactory;
         }
         if(_loc3_ === null)
         {
            _loc3_ = defaultHeaderRendererFactory;
         }
         var _loc4_:String = param1.customHeaderRendererStyleName;
         if(_loc4_ === null)
         {
            _loc4_ = this._customHeaderRendererStyleName;
         }
         var _loc5_:Vector.<IDataGridHeaderRenderer> = this._headerStorage.inactiveHeaderRenderers;
         var _loc6_:Vector.<IDataGridHeaderRenderer> = this._headerStorage.activeHeaderRenderers;
         var _loc7_:IDataGridHeaderRenderer = null;
         do
         {
            if(_loc5_.length == 0)
            {
               _loc7_ = IDataGridHeaderRenderer(_loc3_());
               _loc7_.addEventListener(TouchEvent.TOUCH,this.headerRenderer_touchHandler);
               _loc7_.addEventListener(Event.TRIGGERED,this.headerRenderer_triggeredHandler);
               if(_loc4_ !== null && _loc4_.length > 0)
               {
                  _loc7_.styleNameList.add(_loc4_);
               }
               this._headerGroup.addChild(DisplayObject(_loc7_));
            }
            else
            {
               _loc7_ = _loc5_.shift();
            }
         }
         while(_loc7_ === null);
         _loc7_.data = param1;
         _loc7_.columnIndex = param2;
         _loc7_.owner = this;
         this._headerRendererMap[param1] = _loc7_;
         _loc6_[_loc6_.length] = _loc7_;
         this.dispatchEventWith(FeathersEventType.RENDERER_ADD,false,_loc7_);
         param1.addEventListener(Event.CHANGE,this.column_changeHandler);
         return _loc7_;
      }
      
      protected function destroyHeaderRenderer(param1:IDataGridHeaderRenderer) : void
      {
         if(param1.data !== null)
         {
            param1.data.removeEventListener(Event.CHANGE,this.column_changeHandler);
         }
         param1.removeEventListener(Event.TRIGGERED,this.headerRenderer_triggeredHandler);
         param1.removeEventListener(TouchEvent.TOUCH,this.headerRenderer_touchHandler);
         param1.owner = null;
         param1.data = null;
         param1.columnIndex = -1;
         this._headerGroup.removeChild(DisplayObject(param1),true);
      }
      
      protected function refreshDataViewPortProperties() : void
      {
         this.dataViewPort.isSelectable = this._isSelectable;
         this.dataViewPort.allowMultipleSelection = this._allowMultipleSelection;
         this.dataViewPort.selectedIndices = this._selectedIndices;
         this.dataViewPort.dataProvider = this._dataProvider;
         this.dataViewPort.columns = this._columns;
         this.dataViewPort.typicalItem = this._typicalItem;
         this.dataViewPort.layout = this._layout;
         this.dataViewPort.customColumnSizes = this._customColumnSizes;
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
      
      protected function column_changeHandler(param1:Event) : void
      {
         this.invalidate(INVALIDATION_FLAG_DATA);
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
      
      protected function columns_changeHandler(param1:Event) : void
      {
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      protected function columns_resetHandler(param1:Event) : void
      {
         this._updateForDataReset = true;
      }
      
      protected function columns_updateAllHandler(param1:Event) : void
      {
         this._updateForDataReset = true;
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
      
      protected function dataProvider_sortChangeHandler(param1:Event) : void
      {
         this.refreshSelectedIndicesAfterFilterOrSort();
      }
      
      protected function dataProvider_filterChangeHandler(param1:Event) : void
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
      
      protected function layout_scrollHandler(param1:Event, param2:Point) : void
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
      
      protected function headerRenderer_triggeredHandler(param1:Event) : void
      {
         var _loc2_:IDataGridHeaderRenderer = IDataGridHeaderRenderer(param1.currentTarget);
         var _loc3_:DataGridColumn = _loc2_.data;
         if(!this._sortableColumns || _loc3_.sortOrder === SortOrder.NONE)
         {
            return;
         }
         if(this._sortedColumn != _loc3_)
         {
            this._sortedColumn = _loc3_;
            this._reverseSort = _loc3_.sortOrder === SortOrder.DESCENDING;
         }
         else
         {
            this._reverseSort = !this._reverseSort;
         }
         if(this._reverseSort)
         {
            this._dataProvider.sortCompareFunction = this.reverseSortCompareFunction;
         }
         else
         {
            this._dataProvider.sortCompareFunction = this.sortCompareFunction;
         }
         this._dataProvider.refresh();
      }
      
      protected function reverseSortCompareFunction(param1:Object, param2:Object) : int
      {
         return -this.sortCompareFunction(param1,param2);
      }
      
      protected function sortCompareFunction(param1:Object, param2:Object) : int
      {
         var _loc3_:Object = param1[this._sortedColumn.dataField];
         var _loc4_:Object = param2[this._sortedColumn.dataField];
         var _loc5_:Function = this._sortedColumn.sortCompareFunction;
         if(_loc5_ === null)
         {
            _loc5_ = defaultSortCompareFunction;
         }
         return _loc5_(_loc3_,_loc4_);
      }
      
      protected function dataGrid_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         if(this._headerTouchID != -1)
         {
            _loc2_ = param1.getTouch(this,null,this._headerTouchID);
            if(_loc2_ === null)
            {
               return;
            }
            if(_loc2_.phase === TouchPhase.ENDED)
            {
               this.removeEventListener(TouchEvent.TOUCH,this.dataGrid_touchHandler);
               if(this._currentColumnDropIndicatorSkin !== null)
               {
                  this._currentColumnDropIndicatorSkin.removeFromParent(this._currentColumnDropIndicatorSkin !== this._columnDropIndicatorSkin);
                  this._currentColumnDropIndicatorSkin = null;
               }
               if(this._currentColumnDragOverlaySkin !== null)
               {
                  this._currentColumnDragOverlaySkin.removeFromParent(this._currentColumnDragOverlaySkin !== this._columnDragOverlaySkin);
                  this._currentColumnDragOverlaySkin = null;
               }
               this._headerTouchID = -1;
            }
         }
      }
      
      protected function headerRenderer_touchHandler(param1:TouchEvent) : void
      {
         var _loc3_:Touch = null;
         var _loc4_:DataGridColumn = null;
         var _loc5_:DragData = null;
         var _loc6_:DataGrid = null;
         var _loc7_:RenderDelegate = null;
         var _loc2_:IDataGridHeaderRenderer = IDataGridHeaderRenderer(param1.currentTarget);
         if(!this._isEnabled)
         {
            this._headerTouchID = -1;
            return;
         }
         if(this._headerTouchID != -1)
         {
            _loc3_ = param1.getTouch(DisplayObject(_loc2_),null,this._headerTouchID);
            if(_loc3_ === null)
            {
               return;
            }
            if(_loc3_.phase === TouchPhase.MOVED)
            {
               if(!DragDropManager.isDragging && this._reorderColumns)
               {
                  _loc4_ = DataGridColumn(this._columns.getItemAt(_loc2_.columnIndex));
                  _loc5_ = new DragData();
                  _loc5_.setDataForFormat(DATA_GRID_HEADER_DRAG_FORMAT,_loc4_);
                  _loc6_ = this;
                  _loc7_ = new RenderDelegate(DisplayObject(_loc2_));
                  _loc7_.alpha = this._columnDragAvatarAlpha;
                  DragDropManager.startDrag(this,_loc3_,_loc5_,_loc7_);
                  if(this._columnDropIndicatorSkin === null)
                  {
                     this._currentColumnDropIndicatorSkin = new Quad(1,1,0);
                  }
                  if(this._columnDropIndicatorSkin !== null)
                  {
                     this._currentColumnDropIndicatorSkin = this._columnDropIndicatorSkin;
                  }
                  this._currentColumnDropIndicatorSkin.visible = false;
                  this.addChild(this._currentColumnDropIndicatorSkin);
                  if(this._columnDragOverlaySkin === null)
                  {
                     this._currentColumnDragOverlaySkin = new Quad(1,1,16711935);
                     this._currentColumnDragOverlaySkin.alpha = 0;
                  }
                  else
                  {
                     this._currentColumnDragOverlaySkin = this._columnDragOverlaySkin;
                  }
                  this._currentColumnDragOverlaySkin.x = this._headerGroup.x + _loc2_.x;
                  this._currentColumnDragOverlaySkin.y = this._headerGroup.y + _loc2_.y;
                  this._currentColumnDragOverlaySkin.width = _loc2_.width;
                  this._currentColumnDragOverlaySkin.height = this._viewPort.y + this._viewPort.visibleHeight - this._headerGroup.y;
                  this.addChild(this._currentColumnDragOverlaySkin);
               }
            }
         }
         else if(!DragDropManager.isDragging && this._reorderColumns)
         {
            _loc3_ = param1.getTouch(DisplayObject(_loc2_),TouchPhase.BEGAN);
            if(_loc3_ === null)
            {
               return;
            }
            this._headerTouchID = _loc3_.id;
            this._headerTouchX = _loc3_.globalX;
            this._headerTouchY = _loc3_.globalX;
            this._draggedHeaderIndex = _loc2_.columnIndex;
            this.addEventListener(TouchEvent.TOUCH,this.dataGrid_touchHandler);
         }
      }
      
      protected function getHeaderDropIndex(param1:Number) : int
      {
         var _loc4_:IDataGridHeaderRenderer = null;
         var _loc5_:Point = null;
         var _loc6_:Number = NaN;
         var _loc2_:int = this._headerGroup.numChildren;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = IDataGridHeaderRenderer(this._headerGroup.getChildAt(_loc3_));
            _loc5_ = Pool.getPoint(_loc4_.width / 2,0);
            _loc4_.localToGlobal(_loc5_,_loc5_);
            _loc6_ = _loc5_.x;
            Pool.putPoint(_loc5_);
            if(param1 < _loc6_)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      protected function dataGrid_dragEnterHandler(param1:DragDropEvent) : void
      {
         if(DragDropManager.dragSource !== this || !param1.dragData.hasDataForFormat(DATA_GRID_HEADER_DRAG_FORMAT))
         {
            return;
         }
         DragDropManager.acceptDrag(this);
      }
      
      protected function dataGrid_dragMoveHandler(param1:DragDropEvent) : void
      {
         var _loc7_:DisplayObject = null;
         if(DragDropManager.dragSource !== this || !param1.dragData.hasDataForFormat(DATA_GRID_HEADER_DRAG_FORMAT))
         {
            return;
         }
         var _loc2_:Point = Pool.getPoint(param1.localX,param1.localY);
         this.localToGlobal(_loc2_,_loc2_);
         var _loc3_:Number = _loc2_.x;
         Pool.putPoint(_loc2_);
         var _loc4_:int = this.getHeaderDropIndex(_loc3_);
         var _loc5_:Boolean = _loc4_ != this._draggedHeaderIndex && _loc4_ != this._draggedHeaderIndex + 1;
         this._currentColumnDropIndicatorSkin.visible = _loc5_;
         if(!_loc5_)
         {
            return;
         }
         if(this._extendedColumnDropIndicator)
         {
            this._currentColumnDropIndicatorSkin.height = this._headerGroup.height + this._viewPort.visibleHeight;
         }
         else
         {
            this._currentColumnDropIndicatorSkin.height = this._headerGroup.height;
         }
         if(this._currentColumnDropIndicatorSkin is IValidating)
         {
            IValidating(this._currentColumnDropIndicatorSkin).validate();
         }
         var _loc6_:Number = 0;
         if(_loc4_ == this._columns.length)
         {
            _loc7_ = this._headerGroup.getChildAt(_loc4_ - 1);
            _loc6_ = _loc7_.x + _loc7_.width;
         }
         else
         {
            _loc7_ = this._headerGroup.getChildAt(_loc4_);
            _loc6_ = _loc7_.x;
         }
         this._currentColumnDropIndicatorSkin.x = this._headerGroup.x + _loc6_ - this._currentColumnDropIndicatorSkin.width / 2;
         this._currentColumnDropIndicatorSkin.y = this._headerGroup.y;
      }
      
      protected function dataGrid_dragDropHandler(param1:DragDropEvent) : void
      {
         if(DragDropManager.dragSource !== this || !param1.dragData.hasDataForFormat(DATA_GRID_HEADER_DRAG_FORMAT))
         {
            return;
         }
         var _loc2_:Point = Pool.getPoint(param1.localX,param1.localY);
         this.localToGlobal(_loc2_,_loc2_);
         var _loc3_:Number = _loc2_.x;
         Pool.putPoint(_loc2_);
         var _loc4_:* = this.getHeaderDropIndex(_loc3_);
         if(_loc4_ == this._draggedHeaderIndex || _loc4_ == this._draggedHeaderIndex + 1)
         {
            return;
         }
         if(_loc4_ > this._draggedHeaderIndex)
         {
            _loc4_--;
         }
         var _loc5_:DataGridColumn = DataGridColumn(this._columns.removeItemAt(this._draggedHeaderIndex));
         this._columns.addItemAt(_loc5_,_loc4_);
      }
      
      protected function headerDivider_touchHandler(param1:TouchEvent) : void
      {
         var _loc4_:Touch = null;
         var _loc5_:DataGridColumn = null;
         var _loc6_:IDataGridHeaderRenderer = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc2_:DisplayObject = DisplayObject(param1.currentTarget);
         if(!this._isEnabled)
         {
            this._headerDividerTouchID = -1;
            return;
         }
         var _loc3_:int = this._headerDividerStorage.activeDividers.indexOf(_loc2_);
         if(_loc3_ == this._headerDividerStorage.activeDividers.length - 1 && this._scrollBarDisplayMode === ScrollBarDisplayMode.FIXED && this._minVerticalScrollPosition != this._maxVerticalScrollPosition)
         {
            return;
         }
         if(this._headerDividerTouchID != -1)
         {
            _loc4_ = param1.getTouch(_loc2_,null,this._headerDividerTouchID);
            if(_loc4_ === null)
            {
               return;
            }
            if(_loc4_.phase === TouchPhase.ENDED)
            {
               this.calculateResizedColumnWidth();
               this._resizingColumnIndex = -1;
               this._currentColumnResizeSkin.removeFromParent(this._currentColumnResizeSkin !== this._columnResizeSkin);
               this._currentColumnResizeSkin = null;
               this._headerDividerTouchID = -1;
            }
            else if(_loc4_.phase === TouchPhase.MOVED)
            {
               _loc5_ = DataGridColumn(this._columns.getItemAt(this._resizingColumnIndex));
               _loc6_ = IDataGridHeaderRenderer(this._headerGroup.getChildAt(this._resizingColumnIndex));
               _loc7_ = _loc6_.x + _loc5_.minWidth;
               _loc8_ = this.actualWidth - this._currentColumnResizeSkin.width - this._rightViewPortOffset;
               _loc9_ = _loc4_.globalX - this._headerDividerTouchX;
               _loc10_ = _loc2_.x + _loc2_.width / 2 - this._currentColumnResizeSkin.width / 2 + _loc9_;
               if(_loc10_ < _loc7_)
               {
                  _loc10_ = _loc7_;
               }
               else if(_loc10_ > _loc8_)
               {
                  _loc10_ = _loc8_;
               }
               this._currentColumnResizeSkin.x = _loc10_;
               this._currentColumnResizeSkin.y = this._headerGroup.y;
               this._currentColumnResizeSkin.height = this.actualHeight - this._bottomViewPortOffset - this._currentColumnResizeSkin.y;
            }
         }
         else if(this._resizableColumns)
         {
            _loc4_ = param1.getTouch(_loc2_,TouchPhase.BEGAN);
            if(_loc4_ === null)
            {
               return;
            }
            _loc5_ = DataGridColumn(this._columns.getItemAt(_loc3_));
            if(!_loc5_.resizable)
            {
               return;
            }
            this._resizingColumnIndex = _loc3_;
            this._headerDividerTouchID = _loc4_.id;
            this._headerDividerTouchX = _loc4_.globalX;
            _loc6_ = IDataGridHeaderRenderer(this._headerGroup.getChildAt(_loc3_));
            if(this._columnResizeSkin === null)
            {
               this._currentColumnResizeSkin = new Quad(1,1,0);
            }
            else
            {
               this._currentColumnResizeSkin = this._columnResizeSkin;
            }
            this._currentColumnResizeSkin.height = this.actualHeight;
            this.addChild(this._currentColumnResizeSkin);
            if(this._currentColumnResizeSkin is IValidating)
            {
               IValidating(this._currentColumnResizeSkin).validate();
            }
            this._currentColumnResizeSkin.x = _loc2_.x + _loc2_.width / 2 - this._currentColumnResizeSkin.width / 2;
         }
      }
      
      protected function calculateResizedColumnWidth() : void
      {
         var _loc13_:DataGridColumn = null;
         var _loc14_:Number = NaN;
         var _loc15_:int = 0;
         var _loc1_:int = this._columns.length;
         if(this._customColumnSizes === null)
         {
            this._customColumnSizes = new Vector.<Number>(_loc1_);
         }
         else
         {
            this._customColumnSizes = this._customColumnSizes.slice();
            this._customColumnSizes.length = _loc1_;
         }
         var _loc2_:DataGridColumn = DataGridColumn(this._columns.getItemAt(this._resizingColumnIndex));
         _loc2_.width = NaN;
         var _loc3_:IDataGridHeaderRenderer = IDataGridHeaderRenderer(this._headerGroup.getChildAt(this._resizingColumnIndex));
         var _loc4_:Number = this._currentColumnResizeSkin.x + this._currentColumnResizeSkin.width / 2 - _loc3_.x;
         var _loc5_:Number = 0;
         var _loc6_:Number = Number(_loc3_.width);
         var _loc7_:Number = 0;
         var _loc8_:Vector.<int> = new Vector.<int>(0);
         var _loc9_:int = 0;
         while(_loc9_ < _loc1_)
         {
            _loc13_ = DataGridColumn(this._columns.getItemAt(_loc9_));
            if(_loc9_ != this._resizingColumnIndex)
            {
               if(_loc9_ < this._resizingColumnIndex)
               {
                  _loc3_ = IDataGridHeaderRenderer(this._headerGroup.getChildAt(_loc9_));
                  this._customColumnSizes[_loc9_] = _loc3_.width;
                  _loc5_ += _loc3_.width;
               }
               else if(_loc13_.width === _loc13_.width)
               {
                  _loc5_ += _loc13_.width;
               }
               else
               {
                  _loc5_ += _loc13_.minWidth;
                  _loc3_ = IDataGridHeaderRenderer(this._headerGroup.getChildAt(_loc9_));
                  _loc14_ = Number(_loc3_.width);
                  _loc7_ += _loc14_;
                  this._customColumnSizes[_loc9_] = _loc14_;
                  _loc8_[_loc8_.length] = _loc9_;
               }
            }
            _loc9_++;
         }
         if(_loc8_.length == 0)
         {
            _loc15_ = this._resizingColumnIndex + 1;
            _loc8_[0] = _loc15_;
            _loc2_ = DataGridColumn(this._columns.getItemAt(_loc15_));
            _loc7_ = _loc2_.width;
            _loc5_ -= _loc7_;
            _loc5_ = _loc5_ + _loc2_.minWidth;
            this._customColumnSizes[_loc15_] = _loc7_;
            _loc2_.width = NaN;
         }
         var _loc10_:Number = _loc4_;
         var _loc11_:Number = this._headerGroup.width - _loc5_ - this._leftViewPortOffset - this._rightViewPortOffset;
         if(_loc10_ > _loc11_)
         {
            _loc10_ = _loc11_;
         }
         if(_loc10_ < _loc2_.minWidth)
         {
            _loc10_ = _loc2_.minWidth;
         }
         this._customColumnSizes[this._resizingColumnIndex] = _loc10_;
         var _loc12_:Number = _loc6_ - _loc10_;
         this.distributeWidthToIndices(_loc12_,_loc8_,_loc7_);
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
      }
   }
}

import feathers.controls.renderers.IDataGridHeaderRenderer;
import starling.display.DisplayObject;

class HeaderRendererFactoryStorage
{
   
   public var activeHeaderRenderers:Vector.<IDataGridHeaderRenderer> = new Vector.<IDataGridHeaderRenderer>(0);
   
   public var inactiveHeaderRenderers:Vector.<IDataGridHeaderRenderer> = new Vector.<IDataGridHeaderRenderer>(0);
   
   public var factory:Function = null;
   
   public var customHeaderRendererStyleName:String = null;
   
   public var columnIndex:int = -1;
   
   public function HeaderRendererFactoryStorage()
   {
      super();
   }
}

class DividerFactoryStorage
{
   
   public var activeDividers:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
   
   public var inactiveDividers:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
   
   public var factory:Function = null;
   
   public function DividerFactoryStorage()
   {
      super();
   }
}
