package feathers.controls.supportClasses
{
   import feathers.controls.DataGrid;
   import feathers.controls.Scroller;
   import feathers.controls.renderers.IDataGridCellRenderer;
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.IValidating;
   import feathers.data.IListCollection;
   import feathers.data.ListCollection;
   import feathers.events.CollectionEventType;
   import feathers.events.FeathersEventType;
   import feathers.layout.ILayout;
   import feathers.layout.IVariableVirtualLayout;
   import feathers.layout.IVirtualLayout;
   import feathers.layout.LayoutBoundsResult;
   import feathers.layout.ViewPortBounds;
   import flash.errors.IllegalOperationError;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import starling.utils.Pool;
   
   public class DataGridDataViewPort extends FeathersControl implements IViewPort
   {
      
      private static const INVALIDATION_FLAG_ROW_RENDERER_FACTORY:String = "rowRendererFactory";
      
      private static const HELPER_VECTOR:Vector.<int> = new Vector.<int>(0);
      
      private var _viewPortBounds:ViewPortBounds = new ViewPortBounds();
      
      private var _layoutResult:LayoutBoundsResult = new LayoutBoundsResult();
      
      private var _typicalRowIsInDataProvider:Boolean = false;
      
      private var _typicalRowRenderer:DataGridRowRenderer;
      
      private var _rows:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
      
      private var _rowRendererMap:Dictionary = new Dictionary(true);
      
      private var _unrenderedRows:Vector.<int> = new Vector.<int>(0);
      
      private var _rowStorage:RowRendererFactoryStorage = new RowRendererFactoryStorage();
      
      private var _minimumRowCount:int = 0;
      
      private var _actualMinVisibleWidth:Number = 0;
      
      private var _explicitMinVisibleWidth:Number;
      
      private var _maxVisibleWidth:Number = Infinity;
      
      private var _actualVisibleWidth:Number = 0;
      
      private var _explicitVisibleWidth:Number = NaN;
      
      private var _actualMinVisibleHeight:Number = 0;
      
      private var _explicitMinVisibleHeight:Number;
      
      private var _maxVisibleHeight:Number = Infinity;
      
      private var _actualVisibleHeight:Number = 0;
      
      private var _explicitVisibleHeight:Number = NaN;
      
      protected var _contentX:Number = 0;
      
      protected var _contentY:Number = 0;
      
      private var _horizontalScrollPosition:Number = 0;
      
      private var _verticalScrollPosition:Number = 0;
      
      private var _owner:DataGrid = null;
      
      private var _updateForDataReset:Boolean = false;
      
      private var _dataProvider:IListCollection = null;
      
      protected var _columns:IListCollection = null;
      
      private var _ignoreLayoutChanges:Boolean = false;
      
      private var _ignoreRendererResizing:Boolean = false;
      
      private var _layout:ILayout = null;
      
      private var _typicalItem:Object = null;
      
      private var _customColumnSizes:Vector.<Number> = null;
      
      private var _ignoreSelectionChanges:Boolean = false;
      
      private var _isSelectable:Boolean = true;
      
      private var _allowMultipleSelection:Boolean = false;
      
      private var _selectedIndices:ListCollection;
      
      public function DataGridDataViewPort()
      {
         super();
      }
      
      public function get minVisibleWidth() : Number
      {
         if(this._explicitMinVisibleWidth !== this._explicitMinVisibleWidth)
         {
            return this._actualMinVisibleWidth;
         }
         return this._explicitMinVisibleWidth;
      }
      
      public function set minVisibleWidth(param1:Number) : void
      {
         if(this._explicitMinVisibleWidth == param1)
         {
            return;
         }
         var _loc2_:Boolean = param1 !== param1;
         if(_loc2_ && this._explicitMinVisibleWidth !== this._explicitMinVisibleWidth)
         {
            return;
         }
         var _loc3_:Number = this._explicitMinVisibleWidth;
         this._explicitMinVisibleWidth = param1;
         if(_loc2_)
         {
            this._actualMinVisibleWidth = 0;
            this.invalidate(INVALIDATION_FLAG_SIZE);
         }
         else
         {
            this._actualMinVisibleWidth = param1;
            if(this._explicitVisibleWidth !== this._explicitVisibleWidth && (this._actualVisibleWidth < param1 || this._actualVisibleWidth == _loc3_))
            {
               this.invalidate(INVALIDATION_FLAG_SIZE);
            }
         }
      }
      
      public function get maxVisibleWidth() : Number
      {
         return this._maxVisibleWidth;
      }
      
      public function set maxVisibleWidth(param1:Number) : void
      {
         if(this._maxVisibleWidth == param1)
         {
            return;
         }
         if(param1 !== param1)
         {
            throw new ArgumentError("maxVisibleWidth cannot be NaN");
         }
         var _loc2_:Number = this._maxVisibleWidth;
         this._maxVisibleWidth = param1;
         if(this._explicitVisibleWidth !== this._explicitVisibleWidth && (this._actualVisibleWidth > param1 || this._actualVisibleWidth == _loc2_))
         {
            this.invalidate(INVALIDATION_FLAG_SIZE);
         }
      }
      
      public function get visibleWidth() : Number
      {
         return this._actualVisibleWidth;
      }
      
      public function set visibleWidth(param1:Number) : void
      {
         if(this._explicitVisibleWidth == param1 || param1 !== param1 && this._explicitVisibleWidth !== this._explicitVisibleWidth)
         {
            return;
         }
         this._explicitVisibleWidth = param1;
         if(this._actualVisibleWidth != param1)
         {
            this.invalidate(INVALIDATION_FLAG_SIZE);
         }
      }
      
      public function get minVisibleHeight() : Number
      {
         if(this._explicitMinVisibleHeight !== this._explicitMinVisibleHeight)
         {
            return this._actualMinVisibleHeight;
         }
         return this._explicitMinVisibleHeight;
      }
      
      public function set minVisibleHeight(param1:Number) : void
      {
         if(this._explicitMinVisibleHeight == param1)
         {
            return;
         }
         var _loc2_:Boolean = param1 !== param1;
         if(_loc2_ && this._explicitMinVisibleHeight !== this._explicitMinVisibleHeight)
         {
            return;
         }
         var _loc3_:Number = this._explicitMinVisibleHeight;
         this._explicitMinVisibleHeight = param1;
         if(_loc2_)
         {
            this._actualMinVisibleHeight = 0;
            this.invalidate(INVALIDATION_FLAG_SIZE);
         }
         else
         {
            this._actualMinVisibleHeight = param1;
            if(this._explicitVisibleHeight !== this._explicitVisibleHeight && (this._actualVisibleHeight < param1 || this._actualVisibleHeight == _loc3_))
            {
               this.invalidate(INVALIDATION_FLAG_SIZE);
            }
         }
      }
      
      public function get maxVisibleHeight() : Number
      {
         return this._maxVisibleHeight;
      }
      
      public function set maxVisibleHeight(param1:Number) : void
      {
         if(this._maxVisibleHeight == param1)
         {
            return;
         }
         if(param1 !== param1)
         {
            throw new ArgumentError("maxVisibleHeight cannot be NaN");
         }
         var _loc2_:Number = this._maxVisibleHeight;
         this._maxVisibleHeight = param1;
         if(this._explicitVisibleHeight !== this._explicitVisibleHeight && (this._actualVisibleHeight > param1 || this._actualVisibleHeight == _loc2_))
         {
            this.invalidate(INVALIDATION_FLAG_SIZE);
         }
      }
      
      public function get visibleHeight() : Number
      {
         return this._actualVisibleHeight;
      }
      
      public function set visibleHeight(param1:Number) : void
      {
         if(this._explicitVisibleHeight == param1 || param1 !== param1 && this._explicitVisibleHeight !== this._explicitVisibleHeight)
         {
            return;
         }
         this._explicitVisibleHeight = param1;
         if(this._actualVisibleHeight != param1)
         {
            this.invalidate(INVALIDATION_FLAG_SIZE);
         }
      }
      
      public function get contentX() : Number
      {
         return this._contentX;
      }
      
      public function get contentY() : Number
      {
         return this._contentY;
      }
      
      public function get horizontalScrollPosition() : Number
      {
         return this._horizontalScrollPosition;
      }
      
      public function set horizontalScrollPosition(param1:Number) : void
      {
         if(this._horizontalScrollPosition == param1)
         {
            return;
         }
         this._horizontalScrollPosition = param1;
         this.invalidate(INVALIDATION_FLAG_SCROLL);
      }
      
      public function get verticalScrollPosition() : Number
      {
         return this._verticalScrollPosition;
      }
      
      public function set verticalScrollPosition(param1:Number) : void
      {
         if(this._verticalScrollPosition == param1)
         {
            return;
         }
         this._verticalScrollPosition = param1;
         this.invalidate(INVALIDATION_FLAG_SCROLL);
      }
      
      public function get horizontalScrollStep() : Number
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:IVirtualLayout = this._layout as IVirtualLayout;
         if(_loc2_ === null || !_loc2_.useVirtualLayout)
         {
            if(this._rows.length > 0)
            {
               _loc1_ = this._rows[0] as DisplayObject;
            }
         }
         switch(_loc1_)
         {
            case null:
               _loc1_ = this._typicalRowRenderer as DisplayObject;
               if(_loc1_ !== null)
               {
                  break;
               }
            case null:
               return 0;
         }
         var _loc3_:Number = _loc1_.width;
         var _loc4_:Number = _loc1_.height;
         if(_loc3_ < _loc4_)
         {
            return _loc3_;
         }
         return _loc4_;
      }
      
      public function get verticalScrollStep() : Number
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:IVirtualLayout = this._layout as IVirtualLayout;
         if(_loc2_ === null || !_loc2_.useVirtualLayout)
         {
            if(this._rows.length > 0)
            {
               _loc1_ = this._rows[0] as DisplayObject;
            }
         }
         switch(_loc1_)
         {
            case null:
               _loc1_ = this._typicalRowRenderer as DisplayObject;
               if(_loc1_ !== null)
               {
                  break;
               }
            case null:
               return 0;
         }
         var _loc3_:Number = _loc1_.width;
         var _loc4_:Number = _loc1_.height;
         if(_loc3_ < _loc4_)
         {
            return _loc3_;
         }
         return _loc4_;
      }
      
      public function get owner() : DataGrid
      {
         return this._owner;
      }
      
      public function set owner(param1:DataGrid) : void
      {
         this._owner = param1;
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
            this._dataProvider.removeEventListener(Event.CHANGE,this.dataProvider_changeHandler);
            this._dataProvider.removeEventListener(CollectionEventType.RESET,this.dataProvider_resetHandler);
            this._dataProvider.removeEventListener(CollectionEventType.FILTER_CHANGE,this.dataProvider_filterChangeHandler);
            this._dataProvider.removeEventListener(CollectionEventType.ADD_ITEM,this.dataProvider_addItemHandler);
            this._dataProvider.removeEventListener(CollectionEventType.REMOVE_ITEM,this.dataProvider_removeItemHandler);
            this._dataProvider.removeEventListener(CollectionEventType.REPLACE_ITEM,this.dataProvider_replaceItemHandler);
            this._dataProvider.removeEventListener(CollectionEventType.UPDATE_ITEM,this.dataProvider_updateItemHandler);
            this._dataProvider.removeEventListener(CollectionEventType.UPDATE_ALL,this.dataProvider_updateAllHandler);
         }
         this._dataProvider = param1;
         if(this._dataProvider)
         {
            this._dataProvider.addEventListener(Event.CHANGE,this.dataProvider_changeHandler);
            this._dataProvider.addEventListener(CollectionEventType.RESET,this.dataProvider_resetHandler);
            this._dataProvider.addEventListener(CollectionEventType.FILTER_CHANGE,this.dataProvider_filterChangeHandler);
            this._dataProvider.addEventListener(CollectionEventType.ADD_ITEM,this.dataProvider_addItemHandler);
            this._dataProvider.addEventListener(CollectionEventType.REMOVE_ITEM,this.dataProvider_removeItemHandler);
            this._dataProvider.addEventListener(CollectionEventType.REPLACE_ITEM,this.dataProvider_replaceItemHandler);
            this._dataProvider.addEventListener(CollectionEventType.UPDATE_ITEM,this.dataProvider_updateItemHandler);
            this._dataProvider.addEventListener(CollectionEventType.UPDATE_ALL,this.dataProvider_updateAllHandler);
         }
         if(this._layout is IVariableVirtualLayout)
         {
            IVariableVirtualLayout(this._layout).resetVariableVirtualCache();
         }
         this._updateForDataReset = true;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get columns() : IListCollection
      {
         return this._columns;
      }
      
      public function set columns(param1:IListCollection) : void
      {
         if(this._columns == param1)
         {
            return;
         }
         if(this._columns)
         {
            this._columns.removeEventListener(Event.CHANGE,this.columns_changeHandler);
         }
         this._columns = param1;
         if(this._columns)
         {
            this._columns.addEventListener(Event.CHANGE,this.columns_changeHandler);
         }
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get layout() : ILayout
      {
         return this._layout;
      }
      
      public function set layout(param1:ILayout) : void
      {
         if(this._layout == param1)
         {
            return;
         }
         if(this._layout)
         {
            this._layout.removeEventListener(Event.CHANGE,this.layout_changeHandler);
         }
         this._layout = param1;
         if(this._layout)
         {
            if(this._layout is IVariableVirtualLayout)
            {
               IVariableVirtualLayout(this._layout).resetVariableVirtualCache();
            }
            this._layout.addEventListener(Event.CHANGE,this.layout_changeHandler);
         }
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
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
      
      public function get customColumnSizes() : Vector.<Number>
      {
         return this._customColumnSizes;
      }
      
      public function set customColumnSizes(param1:Vector.<Number>) : void
      {
         if(this._customColumnSizes === param1)
         {
            return;
         }
         this._customColumnSizes = param1;
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
         if(!param1)
         {
            this.selectedIndices = null;
         }
      }
      
      public function get allowMultipleSelection() : Boolean
      {
         return this._allowMultipleSelection;
      }
      
      public function set allowMultipleSelection(param1:Boolean) : void
      {
         this._allowMultipleSelection = param1;
      }
      
      public function get selectedIndices() : ListCollection
      {
         return this._selectedIndices;
      }
      
      public function set selectedIndices(param1:ListCollection) : void
      {
         if(this._selectedIndices == param1)
         {
            return;
         }
         if(this._selectedIndices)
         {
            this._selectedIndices.removeEventListener(Event.CHANGE,this.selectedIndices_changeHandler);
         }
         this._selectedIndices = param1;
         if(this._selectedIndices)
         {
            this._selectedIndices.addEventListener(Event.CHANGE,this.selectedIndices_changeHandler);
         }
         this.invalidate(INVALIDATION_FLAG_SELECTED);
      }
      
      public function get requiresMeasurementOnScroll() : Boolean
      {
         return this._layout.requiresLayoutOnScroll && (this._explicitVisibleWidth !== this._explicitVisibleWidth || this._explicitVisibleHeight !== this._explicitVisibleHeight);
      }
      
      public function calculateNavigationDestination(param1:int, param2:uint) : int
      {
         return this._layout.calculateNavigationDestination(this._rows,param1,param2,this._layoutResult);
      }
      
      public function getScrollPositionForIndex(param1:int, param2:Point = null) : Point
      {
         if(!param2)
         {
            param2 = new Point();
         }
         return this._layout.getScrollPositionForIndex(param1,this._rows,0,0,this._actualVisibleWidth,this._actualVisibleHeight,param2);
      }
      
      public function getNearestScrollPositionForIndex(param1:int, param2:Point = null) : Point
      {
         if(!param2)
         {
            param2 = new Point();
         }
         return this._layout.getNearestScrollPositionForIndex(param1,this._horizontalScrollPosition,this._verticalScrollPosition,this._rows,0,0,this._actualVisibleWidth,this._actualVisibleHeight,param2);
      }
      
      public function itemToCellRenderer(param1:Object, param2:int) : IDataGridCellRenderer
      {
         var _loc3_:DataGridRowRenderer = this._rowRendererMap[param1] as DataGridRowRenderer;
         if(_loc3_ === null)
         {
            return null;
         }
         return _loc3_.getCellRendererForColumn(param2);
      }
      
      override public function dispose() : void
      {
         this.refreshInactiveRowRenderers(true);
         this.owner = null;
         this.layout = null;
         this.dataProvider = null;
         this.columns = null;
         super.dispose();
      }
      
      override protected function draw() : void
      {
         var _loc12_:Boolean = false;
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_SCROLL);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
         var _loc4_:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
         var _loc5_:Boolean = this.isInvalid(INVALIDATION_FLAG_ROW_RENDERER_FACTORY);
         var _loc6_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc7_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         var _loc8_:Boolean = this.isInvalid(INVALIDATION_FLAG_LAYOUT);
         if(Boolean(!_loc8_ && _loc2_) && Boolean(this._layout) && this._layout.requiresLayoutOnScroll)
         {
            _loc8_ = true;
         }
         var _loc9_:Boolean = _loc3_ || _loc1_ || _loc8_ || _loc5_;
         var _loc10_:Boolean = this._ignoreRendererResizing;
         this._ignoreRendererResizing = true;
         var _loc11_:Boolean = this._ignoreLayoutChanges;
         this._ignoreLayoutChanges = true;
         if(_loc2_ || _loc3_)
         {
            this.refreshViewPortBounds();
         }
         if(_loc9_)
         {
            this.refreshInactiveRowRenderers(false);
         }
         if(_loc1_ || _loc8_ || _loc5_)
         {
            this.refreshLayoutTypicalItem();
         }
         if(_loc9_)
         {
            this.refreshRowRenderers();
         }
         if(_loc4_ || _loc9_)
         {
            _loc12_ = this._ignoreSelectionChanges;
            this._ignoreSelectionChanges = true;
            this.refreshSelection();
            this._ignoreSelectionChanges = _loc12_;
         }
         if(_loc7_ || _loc9_)
         {
            this.refreshEnabled();
         }
         this._ignoreLayoutChanges = _loc11_;
         if(_loc7_ || _loc4_ || _loc6_ || _loc9_)
         {
            this._layout.layout(this._rows,this._viewPortBounds,this._layoutResult);
         }
         this._ignoreRendererResizing = _loc10_;
         this._contentX = this._layoutResult.contentX;
         this._contentY = this._layoutResult.contentY;
         this.saveMeasurements(this._layoutResult.contentWidth,this._layoutResult.contentHeight,this._layoutResult.contentWidth,this._layoutResult.contentHeight);
         this._actualVisibleWidth = this._layoutResult.viewPortWidth;
         this._actualVisibleHeight = this._layoutResult.viewPortHeight;
         this._actualMinVisibleWidth = this._layoutResult.viewPortWidth;
         this._actualMinVisibleHeight = this._layoutResult.viewPortHeight;
         this.validateRowRenderers();
      }
      
      private function refreshViewPortBounds() : void
      {
         var _loc1_:Boolean = this._explicitMinVisibleWidth !== this._explicitMinVisibleWidth;
         var _loc2_:Boolean = this._explicitMinVisibleHeight !== this._explicitMinVisibleHeight;
         this._viewPortBounds.x = 0;
         this._viewPortBounds.y = 0;
         this._viewPortBounds.scrollX = this._horizontalScrollPosition;
         this._viewPortBounds.scrollY = this._verticalScrollPosition;
         this._viewPortBounds.explicitWidth = this._explicitVisibleWidth;
         this._viewPortBounds.explicitHeight = this._explicitVisibleHeight;
         if(_loc1_)
         {
            this._viewPortBounds.minWidth = 0;
         }
         else
         {
            this._viewPortBounds.minWidth = this._explicitMinVisibleWidth;
         }
         if(_loc2_)
         {
            this._viewPortBounds.minHeight = 0;
         }
         else
         {
            this._viewPortBounds.minHeight = this._explicitMinVisibleHeight;
         }
         this._viewPortBounds.maxWidth = this._maxVisibleWidth;
         this._viewPortBounds.maxHeight = this._maxVisibleHeight;
      }
      
      private function refreshInactiveRowRenderers(param1:Boolean) : void
      {
         var _loc2_:Vector.<DataGridRowRenderer> = this._rowStorage.inactiveRowRenderers;
         this._rowStorage.inactiveRowRenderers = this._rowStorage.activeRowRenderers;
         this._rowStorage.activeRowRenderers = _loc2_;
         if(this._rowStorage.activeRowRenderers.length > 0)
         {
            throw new IllegalOperationError("DataGridDataViewPort: active row renderers should be empty.");
         }
         if(param1)
         {
            this.recoverInactiveRowRenderers();
            this.freeInactiveRowRenderers(0);
            if(this._typicalRowRenderer !== null)
            {
               if(this._typicalRowIsInDataProvider)
               {
                  delete this._rowRendererMap[this._typicalRowRenderer.data];
               }
               this.destroyRowRenderer(this._typicalRowRenderer);
               this._typicalRowRenderer = null;
               this._typicalRowIsInDataProvider = false;
            }
         }
         this._rows.length = 0;
      }
      
      private function recoverInactiveRowRenderers() : void
      {
         var _loc4_:DataGridRowRenderer = null;
         var _loc1_:Vector.<DataGridRowRenderer> = this._rowStorage.inactiveRowRenderers;
         var _loc2_:int = int(_loc1_.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = _loc1_[_loc3_];
            if(!(_loc4_ === null || _loc4_.data === null))
            {
               this._owner.dispatchEventWith(FeathersEventType.RENDERER_REMOVE,false,_loc4_);
               delete this._rowRendererMap[_loc4_.data];
            }
            _loc3_++;
         }
      }
      
      private function freeInactiveRowRenderers(param1:int) : void
      {
         var _loc8_:DataGridRowRenderer = null;
         var _loc2_:Vector.<DataGridRowRenderer> = this._rowStorage.inactiveRowRenderers;
         var _loc3_:Vector.<DataGridRowRenderer> = this._rowStorage.activeRowRenderers;
         var _loc4_:int = int(_loc3_.length);
         var _loc5_:int = int(_loc2_.length);
         var _loc6_:int = param1 - _loc4_;
         if(_loc6_ > _loc5_)
         {
            _loc6_ = _loc5_;
         }
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = _loc2_.shift();
            if(_loc8_ === null)
            {
               _loc6_++;
               if(_loc5_ < _loc6_)
               {
                  _loc6_ = _loc5_;
               }
            }
            else
            {
               _loc8_.data = null;
               _loc8_.columns = null;
               _loc8_.index = -1;
               _loc8_.visible = false;
               _loc8_.customColumnSizes = null;
               _loc3_[_loc4_] = _loc8_;
               _loc4_++;
            }
            _loc7_++;
         }
         _loc5_ -= _loc6_;
         _loc7_ = 0;
         while(_loc7_ < _loc5_)
         {
            _loc8_ = _loc2_.shift();
            if(_loc8_ !== null)
            {
               this.destroyRowRenderer(_loc8_);
            }
            _loc7_++;
         }
      }
      
      private function createRowRenderer(param1:Object, param2:int, param3:Boolean, param4:Boolean) : DataGridRowRenderer
      {
         var _loc5_:Vector.<DataGridRowRenderer> = this._rowStorage.inactiveRowRenderers;
         var _loc6_:Vector.<DataGridRowRenderer> = this._rowStorage.activeRowRenderers;
         var _loc7_:DataGridRowRenderer = null;
         do
         {
            if(!param3 || param4 || _loc5_.length == 0)
            {
               _loc7_ = new DataGridRowRenderer();
               this.addChild(DisplayObject(_loc7_));
            }
            else
            {
               _loc7_ = _loc5_.shift();
            }
         }
         while(_loc7_ === null);
         _loc7_.data = param1;
         _loc7_.columns = this._columns;
         _loc7_.index = param2;
         _loc7_.owner = this._owner;
         _loc7_.customColumnSizes = this._customColumnSizes;
         if(!param4)
         {
            this._rowRendererMap[param1] = _loc7_;
            _loc6_[_loc6_.length] = _loc7_;
            _loc7_.addEventListener(Event.TRIGGERED,this.rowRenderer_triggeredHandler);
            _loc7_.addEventListener(Event.CHANGE,this.rowRenderer_changeHandler);
            _loc7_.addEventListener(FeathersEventType.RESIZE,this.rowRenderer_resizeHandler);
            this._owner.dispatchEventWith(FeathersEventType.RENDERER_ADD,false,_loc7_);
         }
         return _loc7_;
      }
      
      private function destroyRowRenderer(param1:DataGridRowRenderer) : void
      {
         param1.removeEventListener(Event.TRIGGERED,this.rowRenderer_triggeredHandler);
         param1.removeEventListener(Event.CHANGE,this.rowRenderer_changeHandler);
         param1.removeEventListener(FeathersEventType.RESIZE,this.rowRenderer_resizeHandler);
         param1.data = null;
         param1.columns = null;
         param1.index = -1;
         this.removeChild(DisplayObject(param1),true);
         param1.owner = null;
      }
      
      private function refreshLayoutTypicalItem() : void
      {
         var _loc5_:DataGridRowRenderer = null;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc1_:IVirtualLayout = this._layout as IVirtualLayout;
         if(_loc1_ === null || !_loc1_.useVirtualLayout)
         {
            if(!this._typicalRowIsInDataProvider && this._typicalRowRenderer !== null)
            {
               this.destroyRowRenderer(this._typicalRowRenderer);
               this._typicalRowRenderer = null;
            }
            return;
         }
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:Object = this._typicalItem;
         if(_loc4_ !== null)
         {
            if(this._dataProvider !== null)
            {
               _loc2_ = this._dataProvider.getItemIndex(_loc4_);
               _loc3_ = _loc2_ >= 0;
            }
            if(_loc2_ < 0)
            {
               _loc2_ = 0;
            }
         }
         else if(this._dataProvider !== null && this._dataProvider.length > 0)
         {
            _loc3_ = true;
            _loc4_ = this._dataProvider.getItemAt(0);
         }
         if(_loc4_ !== null || _loc3_)
         {
            _loc5_ = this._rowRendererMap[_loc4_] as DataGridRowRenderer;
            if(_loc5_ !== null)
            {
               _loc5_.index = _loc2_;
            }
            if(_loc5_ === null && this._typicalRowRenderer !== null)
            {
               _loc6_ = !this._typicalRowIsInDataProvider;
               _loc7_ = this._typicalRowIsInDataProvider && Boolean(this._dataProvider) && this._dataProvider.getItemIndex(this._typicalRowRenderer.data) < 0;
               if(!_loc6_ && _loc7_)
               {
                  _loc6_ = true;
               }
               if(_loc6_)
               {
                  if(this._typicalRowIsInDataProvider)
                  {
                     delete this._rowRendererMap[this._typicalRowRenderer.data];
                  }
                  _loc5_ = this._typicalRowRenderer;
                  _loc5_.data = _loc4_;
                  _loc5_.index = _loc2_;
                  if(_loc3_)
                  {
                     this._rowRendererMap[_loc4_] = _loc5_;
                  }
               }
            }
            if(_loc5_ === null)
            {
               _loc5_ = this.createRowRenderer(_loc4_,_loc2_,false,!_loc3_);
               if(!this._typicalRowIsInDataProvider && this._typicalRowRenderer !== null)
               {
                  this.destroyRowRenderer(this._typicalRowRenderer);
                  this._typicalRowRenderer = null;
               }
            }
         }
         _loc1_.typicalItem = DisplayObject(_loc5_);
         this._typicalRowRenderer = _loc5_;
         this._typicalRowIsInDataProvider = _loc3_;
         if(this._typicalRowRenderer !== null && !this._typicalRowIsInDataProvider)
         {
            this._typicalRowRenderer.addEventListener(FeathersEventType.RESIZE,this.rowRenderer_resizeHandler);
         }
      }
      
      private function refreshRowRenderers() : void
      {
         var _loc1_:Vector.<DataGridRowRenderer> = null;
         var _loc2_:Vector.<DataGridRowRenderer> = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this._typicalRowRenderer !== null && this._typicalRowIsInDataProvider)
         {
            _loc1_ = this._rowStorage.inactiveRowRenderers;
            _loc2_ = this._rowStorage.activeRowRenderers;
            _loc3_ = _loc1_.indexOf(this._typicalRowRenderer);
            if(_loc3_ >= 0)
            {
               _loc1_[_loc3_] = null;
            }
            _loc4_ = int(_loc2_.length);
            if(_loc4_ == 0)
            {
               _loc2_[_loc4_] = this._typicalRowRenderer;
            }
         }
         this.findUnrenderedRowData();
         this.recoverInactiveRowRenderers();
         this.renderUnrenderedRowData();
         this.freeInactiveRowRenderers(this._minimumRowCount);
      }
      
      private function findUnrenderedRowData() : void
      {
         var _loc7_:Point = null;
         var _loc8_:int = 0;
         var _loc9_:Object = null;
         var _loc10_:DataGridRowRenderer = null;
         var _loc11_:Vector.<DataGridRowRenderer> = null;
         var _loc12_:Vector.<DataGridRowRenderer> = null;
         var _loc13_:int = 0;
         var _loc1_:int = 0;
         if(this._dataProvider !== null)
         {
            _loc1_ = this._dataProvider.length;
         }
         var _loc2_:IVirtualLayout = this._layout as IVirtualLayout;
         var _loc3_:Boolean = Boolean(_loc2_) && _loc2_.useVirtualLayout;
         if(_loc3_)
         {
            _loc7_ = Pool.getPoint();
            _loc2_.measureViewPort(_loc1_,this._viewPortBounds,_loc7_);
            _loc2_.getVisibleIndicesAtScrollPosition(this._horizontalScrollPosition,this._verticalScrollPosition,_loc7_.x,_loc7_.y,_loc1_,HELPER_VECTOR);
            Pool.putPoint(_loc7_);
         }
         this._rows.length = _loc1_;
         var _loc4_:int = _loc1_;
         if(_loc3_)
         {
            _loc4_ = int(HELPER_VECTOR.length);
         }
         if(Boolean(_loc3_ && this._typicalRowIsInDataProvider) && Boolean(this._typicalRowRenderer) && HELPER_VECTOR.indexOf(this._typicalRowRenderer.index) >= 0)
         {
            this._minimumRowCount = _loc4_ + 1;
         }
         else
         {
            this._minimumRowCount = _loc4_;
         }
         var _loc5_:int = int(this._unrenderedRows.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc8_ = _loc6_;
            if(_loc3_)
            {
               _loc8_ = HELPER_VECTOR[_loc6_];
            }
            if(!(_loc8_ < 0 || _loc8_ >= _loc1_))
            {
               _loc9_ = this._dataProvider.getItemAt(_loc8_);
               _loc10_ = this._rowRendererMap[_loc9_] as DataGridRowRenderer;
               if(_loc10_ !== null)
               {
                  _loc10_.index = _loc8_;
                  _loc10_.visible = true;
                  _loc10_.customColumnSizes = this._customColumnSizes;
                  if(this._updateForDataReset)
                  {
                     _loc10_.data = null;
                     _loc10_.data = _loc9_;
                  }
                  if(this._typicalRowRenderer !== _loc10_)
                  {
                     _loc11_ = this._rowStorage.activeRowRenderers;
                     _loc12_ = this._rowStorage.inactiveRowRenderers;
                     _loc11_[_loc11_.length] = _loc10_;
                     _loc13_ = _loc12_.indexOf(_loc10_);
                     if(_loc13_ < 0)
                     {
                        throw new IllegalOperationError("DataGridDataViewPort: row renderer map contains bad data. This may be caused by duplicate items in the data provider, which is not allowed.");
                     }
                     _loc12_[_loc13_] = null;
                  }
                  this._rows[_loc8_] = DisplayObject(_loc10_);
               }
               else
               {
                  this._unrenderedRows[_loc5_] = _loc8_;
                  _loc5_++;
               }
            }
            _loc6_++;
         }
         if(this._typicalRowRenderer !== null)
         {
            if(_loc3_ && this._typicalRowIsInDataProvider)
            {
               _loc8_ = HELPER_VECTOR.indexOf(this._typicalRowRenderer.index);
               if(_loc8_ >= 0)
               {
                  this._typicalRowRenderer.visible = true;
               }
               else
               {
                  this._typicalRowRenderer.visible = false;
               }
            }
            else
            {
               this._typicalRowRenderer.visible = this._typicalRowIsInDataProvider;
            }
         }
         HELPER_VECTOR.length = 0;
      }
      
      private function renderUnrenderedRowData() : void
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:DataGridRowRenderer = null;
         var _loc1_:int = int(this._unrenderedRows.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._unrenderedRows.shift();
            _loc4_ = this._dataProvider.getItemAt(_loc3_);
            _loc5_ = this.createRowRenderer(_loc4_,_loc3_,true,false);
            _loc5_.visible = true;
            this._rows[_loc3_] = DisplayObject(_loc5_);
            _loc2_++;
         }
      }
      
      private function refreshSelection() : void
      {
         var _loc3_:DataGridRowRenderer = null;
         var _loc1_:int = int(this._rows.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._rows[_loc2_] as DataGridRowRenderer;
            if(_loc3_ !== null)
            {
               _loc3_.isSelected = this._selectedIndices.getItemIndex(_loc3_.index) >= 0;
            }
            _loc2_++;
         }
      }
      
      private function refreshEnabled() : void
      {
         var _loc3_:IFeathersControl = null;
         var _loc1_:int = int(this._rows.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._rows[_loc2_] as IFeathersControl;
            if(_loc3_ !== null)
            {
               _loc3_.isEnabled = this._isEnabled;
            }
            _loc2_++;
         }
      }
      
      private function validateRowRenderers() : void
      {
         var _loc3_:IValidating = null;
         var _loc1_:int = int(this._rows.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._rows[_loc2_] as IValidating;
            if(_loc3_ !== null)
            {
               _loc3_.validate();
            }
            _loc2_++;
         }
      }
      
      private function invalidateParent(param1:String = "all") : void
      {
         Scroller(this.parent).invalidate(param1);
      }
      
      private function columns_changeHandler(param1:Event) : void
      {
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      private function dataProvider_changeHandler(param1:Event) : void
      {
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      private function dataProvider_addItemHandler(param1:Event, param2:int) : void
      {
         var _loc3_:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
         if(!_loc3_ || !_loc3_.hasVariableItemDimensions)
         {
            return;
         }
         _loc3_.addToVariableVirtualCacheAtIndex(param2);
      }
      
      private function dataProvider_removeItemHandler(param1:Event, param2:int) : void
      {
         var _loc3_:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
         if(!_loc3_ || !_loc3_.hasVariableItemDimensions)
         {
            return;
         }
         _loc3_.removeFromVariableVirtualCacheAtIndex(param2);
      }
      
      private function dataProvider_replaceItemHandler(param1:Event, param2:int) : void
      {
         var _loc3_:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
         if(!_loc3_ || !_loc3_.hasVariableItemDimensions)
         {
            return;
         }
         _loc3_.resetVariableVirtualCacheAtIndex(param2);
      }
      
      private function dataProvider_resetHandler(param1:Event) : void
      {
         this._updateForDataReset = true;
         var _loc2_:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
         if(!_loc2_ || !_loc2_.hasVariableItemDimensions)
         {
            return;
         }
         _loc2_.resetVariableVirtualCache();
      }
      
      private function dataProvider_filterChangeHandler(param1:Event) : void
      {
         var _loc2_:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
         if(!_loc2_ || !_loc2_.hasVariableItemDimensions)
         {
            return;
         }
         _loc2_.resetVariableVirtualCache();
      }
      
      private function dataProvider_updateItemHandler(param1:Event, param2:int) : void
      {
         var _loc3_:Object = this._dataProvider.getItemAt(param2);
         var _loc4_:DataGridRowRenderer = this._rowRendererMap[_loc3_] as DataGridRowRenderer;
         if(_loc4_ === null)
         {
            return;
         }
         _loc4_.data = null;
         _loc4_.data = _loc3_;
         if(this._explicitVisibleWidth !== this._explicitVisibleWidth || this._explicitVisibleHeight !== this._explicitVisibleHeight)
         {
            this.invalidate(INVALIDATION_FLAG_SIZE);
            this.invalidateParent(INVALIDATION_FLAG_SIZE);
         }
      }
      
      private function dataProvider_updateAllHandler(param1:Event) : void
      {
         this._updateForDataReset = true;
         this.invalidate(INVALIDATION_FLAG_DATA);
         var _loc2_:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
         if(!_loc2_ || !_loc2_.hasVariableItemDimensions)
         {
            return;
         }
         _loc2_.resetVariableVirtualCache();
      }
      
      private function rowRenderer_triggeredHandler(param1:Event) : void
      {
         var _loc2_:DataGridRowRenderer = DataGridRowRenderer(param1.currentTarget);
         this.parent.dispatchEventWith(Event.TRIGGERED,false,_loc2_.data);
      }
      
      private function rowRenderer_changeHandler(param1:Event) : void
      {
         var _loc5_:int = 0;
         if(this._ignoreSelectionChanges)
         {
            return;
         }
         var _loc2_:DataGridRowRenderer = DataGridRowRenderer(param1.currentTarget);
         if(!this._isSelectable || this._owner.isScrolling)
         {
            _loc2_.isSelected = false;
            return;
         }
         var _loc3_:Boolean = _loc2_.isSelected;
         var _loc4_:int = _loc2_.index;
         if(this._allowMultipleSelection)
         {
            _loc5_ = this._selectedIndices.getItemIndex(_loc4_);
            if(_loc3_ && _loc5_ < 0)
            {
               this._selectedIndices.addItem(_loc4_);
            }
            else if(!_loc3_ && _loc5_ >= 0)
            {
               this._selectedIndices.removeItemAt(_loc5_);
            }
         }
         else if(_loc3_)
         {
            this._selectedIndices.data = new <int>[_loc4_];
         }
         else
         {
            this._selectedIndices.removeAll();
         }
      }
      
      private function rowRenderer_resizeHandler(param1:Event) : void
      {
         if(this._ignoreRendererResizing)
         {
            return;
         }
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
         this.invalidateParent(INVALIDATION_FLAG_LAYOUT);
         if(param1.currentTarget === this._typicalRowRenderer && !this._typicalRowIsInDataProvider)
         {
            return;
         }
         var _loc2_:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
         if(!_loc2_ || !_loc2_.hasVariableItemDimensions)
         {
            return;
         }
         var _loc3_:DataGridRowRenderer = DataGridRowRenderer(param1.currentTarget);
         _loc2_.resetVariableVirtualCacheAtIndex(_loc3_.index,DisplayObject(_loc3_));
      }
      
      private function layout_changeHandler(param1:Event) : void
      {
         if(this._ignoreLayoutChanges)
         {
            return;
         }
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
         this.invalidateParent(INVALIDATION_FLAG_LAYOUT);
      }
      
      private function selectedIndices_changeHandler(param1:Event) : void
      {
         this.invalidate(INVALIDATION_FLAG_SELECTED);
      }
   }
}

class RowRendererFactoryStorage
{
   
   public var activeRowRenderers:Vector.<DataGridRowRenderer> = new Vector.<DataGridRowRenderer>(0);
   
   public var inactiveRowRenderers:Vector.<DataGridRowRenderer> = new Vector.<DataGridRowRenderer>(0);
   
   public function RowRendererFactoryStorage()
   {
      super();
   }
}
