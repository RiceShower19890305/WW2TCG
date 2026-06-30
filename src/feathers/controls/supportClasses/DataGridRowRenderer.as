package feathers.controls.supportClasses
{
   import feathers.controls.DataGrid;
   import feathers.controls.DataGridColumn;
   import feathers.controls.LayoutGroup;
   import feathers.controls.renderers.DefaultDataGridCellRenderer;
   import feathers.controls.renderers.IDataGridCellRenderer;
   import feathers.core.IToggle;
   import feathers.data.IListCollection;
   import feathers.events.CollectionEventType;
   import feathers.events.FeathersEventType;
   import feathers.layout.HorizontalLayout;
   import feathers.layout.HorizontalLayoutData;
   import feathers.layout.VerticalAlign;
   import feathers.utils.touch.TapToSelect;
   import feathers.utils.touch.TapToTrigger;
   import flash.errors.IllegalOperationError;
   import flash.utils.Dictionary;
   import starling.display.DisplayObject;
   import starling.events.Event;
   
   public class DataGridRowRenderer extends LayoutGroup implements IToggle
   {
      
      protected var _tapToTrigger:TapToTrigger = null;
      
      protected var _tapToSelect:TapToSelect = null;
      
      protected var _unrenderedData:Vector.<int> = new Vector.<int>(0);
      
      protected var _cellRendererMap:Dictionary = new Dictionary(true);
      
      protected var _defaultStorage:CellRendererFactoryStorage = new CellRendererFactoryStorage();
      
      protected var _additionalStorage:Vector.<CellRendererFactoryStorage> = null;
      
      protected var _index:int = -1;
      
      protected var _owner:DataGrid = null;
      
      protected var _data:Object = null;
      
      protected var _updateForDataReset:Boolean = false;
      
      protected var _columns:IListCollection = null;
      
      protected var _isSelected:Boolean;
      
      private var _customColumnSizes:Vector.<Number> = null;
      
      public function DataGridRowRenderer()
      {
         super();
      }
      
      protected static function defaultCellRendererFactory() : IDataGridCellRenderer
      {
         return new DefaultDataGridCellRenderer();
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function set index(param1:int) : void
      {
         if(this._index == param1)
         {
            return;
         }
         this._index = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get owner() : DataGrid
      {
         return this._owner;
      }
      
      public function set owner(param1:DataGrid) : void
      {
         if(this._owner === param1)
         {
            return;
         }
         this._owner = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(param1:Object) : void
      {
         if(this._data === param1)
         {
            return;
         }
         this._data = param1;
         if(param1 === null)
         {
            this._updateForDataReset = true;
         }
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
         this._updateForDataReset = true;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get isSelected() : Boolean
      {
         return this._isSelected;
      }
      
      public function set isSelected(param1:Boolean) : void
      {
         if(this._isSelected === param1)
         {
            return;
         }
         this._isSelected = param1;
         this.invalidate(INVALIDATION_FLAG_SELECTED);
         this.dispatchEventWith(Event.CHANGE);
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
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
      }
      
      public function getCellRendererForColumn(param1:int) : IDataGridCellRenderer
      {
         var _loc2_:DataGridColumn = DataGridColumn(this._columns.getItemAt(param1));
         var _loc3_:CellRendererFactoryStorage = this.factoryToStorage(_loc2_.cellRendererFactory);
         var _loc4_:Vector.<IDataGridCellRenderer> = _loc3_.activeCellRenderers;
         if(param1 < 0 || param1 > _loc4_.length)
         {
            return null;
         }
         return IDataGridCellRenderer(_loc4_[param1]);
      }
      
      override public function dispose() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:CellRendererFactoryStorage = null;
         this.refreshInactiveCellRenderers(this._defaultStorage,true);
         if(this._additionalStorage !== null)
         {
            _loc1_ = int(this._additionalStorage.length);
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc3_ = this._additionalStorage[_loc2_];
               this.refreshInactiveCellRenderers(_loc3_,true);
               _loc2_++;
            }
         }
         this.owner = null;
         this.data = null;
         this.columns = null;
         super.dispose();
      }
      
      override protected function initialize() : void
      {
         var _loc1_:HorizontalLayout = null;
         super.initialize();
         if(this._layout === null)
         {
            _loc1_ = new HorizontalLayout();
            _loc1_.verticalAlign = VerticalAlign.MIDDLE;
            _loc1_.useVirtualLayout = false;
            this._layout = _loc1_;
         }
         if(this._tapToTrigger === null)
         {
            this._tapToTrigger = new TapToTrigger(this);
         }
         if(this._tapToSelect === null)
         {
            this._tapToSelect = new TapToSelect(this);
         }
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this._ignoreChildChanges;
         this._ignoreChildChanges = true;
         this.preLayout();
         this._ignoreChildChanges = _loc1_;
         this.refreshSelectionEvents();
         super.draw();
      }
      
      protected function preLayout() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:CellRendererFactoryStorage = null;
         this.refreshInactiveCellRenderers(this._defaultStorage,false);
         if(this._additionalStorage !== null)
         {
            _loc1_ = int(this._additionalStorage.length);
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc3_ = this._additionalStorage[_loc2_];
               this.refreshInactiveCellRenderers(_loc3_,false);
               _loc2_++;
            }
         }
         this.findUnrenderedData();
         this.recoverInactiveCellRenderers(this._defaultStorage);
         if(this._additionalStorage !== null)
         {
            _loc1_ = int(this._additionalStorage.length);
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc3_ = this._additionalStorage[_loc2_];
               this.recoverInactiveCellRenderers(_loc3_);
               _loc2_++;
            }
         }
         this.renderUnrenderedData();
         this.freeInactiveCellRenderers(this._defaultStorage);
         if(this._additionalStorage !== null)
         {
            _loc1_ = int(this._additionalStorage.length);
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc3_ = this._additionalStorage[_loc2_];
               this.freeInactiveCellRenderers(_loc3_);
               _loc2_++;
            }
         }
      }
      
      protected function refreshSelectionEvents() : void
      {
         this._tapToSelect.isEnabled = this._isEnabled;
         this._tapToSelect.tapToDeselect = this._owner.allowMultipleSelection;
      }
      
      protected function createCellRenderer(param1:int, param2:DataGridColumn) : IDataGridCellRenderer
      {
         var _loc7_:Function = null;
         var _loc8_:String = null;
         var _loc3_:IDataGridCellRenderer = null;
         var _loc4_:CellRendererFactoryStorage = this.factoryToStorage(param2.cellRendererFactory);
         var _loc5_:Vector.<IDataGridCellRenderer> = _loc4_.activeCellRenderers;
         var _loc6_:Vector.<IDataGridCellRenderer> = _loc4_.inactiveCellRenderers;
         do
         {
            if(_loc6_.length == 0)
            {
               _loc7_ = param2.cellRendererFactory;
               if(_loc7_ === null)
               {
                  _loc7_ = this._owner.cellRendererFactory;
               }
               if(_loc7_ === null)
               {
                  _loc7_ = defaultCellRendererFactory;
               }
               _loc3_ = IDataGridCellRenderer(_loc7_());
               _loc8_ = param2.customCellRendererStyleName;
               if(_loc8_ === null)
               {
                  _loc8_ = this._owner.customCellRendererStyleName;
               }
               if(_loc8_ !== null && _loc8_.length > 0)
               {
                  _loc3_.styleNameList.add(_loc8_);
               }
               this.addChildAt(DisplayObject(_loc3_),param1);
            }
            else
            {
               _loc3_ = _loc6_.shift();
            }
         }
         while(_loc3_ === null);
         this.refreshCellRendererProperties(_loc3_,param1,param2);
         param2.addEventListener(Event.CHANGE,this.column_changeHandler);
         this._cellRendererMap[param2] = _loc3_;
         _loc5_[_loc5_.length] = _loc3_;
         this._owner.dispatchEventWith(FeathersEventType.RENDERER_ADD,false,_loc3_);
         return _loc3_;
      }
      
      protected function destroyCellRenderer(param1:IDataGridCellRenderer) : void
      {
         if(param1.column !== null)
         {
            param1.column.removeEventListener(Event.CHANGE,this.column_changeHandler);
         }
         param1.data = null;
         param1.owner = null;
         param1.rowIndex = -1;
         param1.columnIndex = -1;
         this.removeChild(DisplayObject(param1),true);
      }
      
      protected function factoryToStorage(param1:Function) : CellRendererFactoryStorage
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:CellRendererFactoryStorage = null;
         if(param1 !== null)
         {
            if(this._additionalStorage === null)
            {
               this._additionalStorage = new Vector.<CellRendererFactoryStorage>(0);
            }
            _loc2_ = int(this._additionalStorage.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = this._additionalStorage[_loc3_];
               if(_loc4_.factory === param1)
               {
                  return _loc4_;
               }
               _loc3_++;
            }
            _loc4_ = new CellRendererFactoryStorage(param1);
            this._additionalStorage[this._additionalStorage.length] = _loc4_;
            return _loc4_;
         }
         return this._defaultStorage;
      }
      
      protected function refreshInactiveCellRenderers(param1:CellRendererFactoryStorage, param2:Boolean) : void
      {
         var _loc3_:Vector.<IDataGridCellRenderer> = param1.inactiveCellRenderers;
         param1.inactiveCellRenderers = param1.activeCellRenderers;
         param1.activeCellRenderers = _loc3_;
         if(param1.activeCellRenderers.length > 0)
         {
            throw new IllegalOperationError("DataGridRowRenderer: active cell renderers should be empty.");
         }
         if(param2)
         {
            this.recoverInactiveCellRenderers(param1);
            this.freeInactiveCellRenderers(param1);
         }
      }
      
      protected function findUnrenderedData() : void
      {
         var _loc5_:DataGridColumn = null;
         var _loc6_:IDataGridCellRenderer = null;
         var _loc7_:CellRendererFactoryStorage = null;
         var _loc8_:Vector.<IDataGridCellRenderer> = null;
         var _loc9_:Vector.<IDataGridCellRenderer> = null;
         var _loc10_:int = 0;
         var _loc1_:IListCollection = this._owner.columns;
         var _loc2_:int = _loc1_.length;
         var _loc3_:int = int(this._unrenderedData.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            if(!(_loc4_ < 0 || _loc4_ >= _loc2_))
            {
               _loc5_ = DataGridColumn(_loc1_.getItemAt(_loc4_));
               _loc6_ = this._cellRendererMap[_loc5_] as IDataGridCellRenderer;
               if(_loc6_ !== null)
               {
                  this.refreshCellRendererProperties(_loc6_,_loc4_,_loc5_);
                  _loc7_ = this.factoryToStorage(_loc5_.cellRendererFactory);
                  _loc8_ = _loc7_.activeCellRenderers;
                  _loc9_ = _loc7_.inactiveCellRenderers;
                  _loc8_[_loc8_.length] = _loc6_;
                  _loc10_ = _loc9_.indexOf(_loc6_);
                  if(_loc10_ < 0)
                  {
                     throw new IllegalOperationError("DataGridRowRenderer: cell renderer map contains bad data. This may be caused by duplicate items in the data provider, which is not allowed.");
                  }
                  _loc9_[_loc10_] = null;
               }
               else
               {
                  this._unrenderedData[_loc3_] = _loc4_;
                  _loc3_++;
               }
            }
            _loc4_++;
         }
      }
      
      protected function recoverInactiveCellRenderers(param1:CellRendererFactoryStorage) : void
      {
         var _loc5_:IDataGridCellRenderer = null;
         var _loc2_:Vector.<IDataGridCellRenderer> = param1.inactiveCellRenderers;
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            if(!(_loc5_ === null || _loc5_.column === null))
            {
               this._owner.dispatchEventWith(FeathersEventType.RENDERER_REMOVE,false,_loc5_);
               delete this._cellRendererMap[_loc5_.column];
            }
            _loc4_++;
         }
      }
      
      protected function renderUnrenderedData() : void
      {
         var _loc4_:int = 0;
         var _loc5_:DataGridColumn = null;
         var _loc6_:IDataGridCellRenderer = null;
         var _loc1_:IListCollection = this._owner.columns;
         var _loc2_:int = int(this._unrenderedData.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._unrenderedData.shift();
            _loc5_ = DataGridColumn(_loc1_.getItemAt(_loc3_));
            _loc6_ = this.createCellRenderer(_loc4_,_loc5_);
            _loc3_++;
         }
      }
      
      protected function freeInactiveCellRenderers(param1:CellRendererFactoryStorage) : void
      {
         var _loc7_:IDataGridCellRenderer = null;
         var _loc2_:Vector.<IDataGridCellRenderer> = param1.activeCellRenderers;
         var _loc3_:Vector.<IDataGridCellRenderer> = param1.inactiveCellRenderers;
         var _loc4_:int = int(_loc2_.length);
         var _loc5_:int = int(_loc3_.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = _loc3_.shift();
            if(_loc7_ !== null)
            {
               this.destroyCellRenderer(_loc7_);
            }
            _loc6_++;
         }
      }
      
      protected function refreshCellRendererProperties(param1:IDataGridCellRenderer, param2:int, param3:DataGridColumn) : void
      {
         var _loc4_:HorizontalLayoutData = null;
         if(this._updateForDataReset)
         {
            param1.data = null;
            param1.column = null;
         }
         param1.owner = this._owner;
         param1.data = this._data;
         param1.rowIndex = this._index;
         param1.column = param3;
         param1.columnIndex = param2;
         param1.isSelected = this._isSelected;
         param1.dataField = param3.dataField;
         param1.minWidth = param3.minWidth;
         if(param3.width === param3.width)
         {
            param1.width = param3.width;
            param1.layoutData = null;
         }
         else if(this._customColumnSizes !== null && param2 < this._customColumnSizes.length)
         {
            param1.width = this._customColumnSizes[param2];
            param1.layoutData = null;
         }
         else
         {
            _loc4_ = param1.layoutData as HorizontalLayoutData;
            if(_loc4_ === null)
            {
               param1.layoutData = new HorizontalLayoutData(100,NaN);
            }
            else
            {
               _loc4_.percentWidth = 100;
               _loc4_.percentHeight = NaN;
            }
         }
         this.setChildIndex(DisplayObject(param1),param2);
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
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      protected function column_changeHandler(param1:Event) : void
      {
         this.invalidate(INVALIDATION_FLAG_DATA);
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
      }
   }
}

import feathers.controls.renderers.IDataGridCellRenderer;

class CellRendererFactoryStorage
{
   
   public var activeCellRenderers:Vector.<IDataGridCellRenderer> = new Vector.<IDataGridCellRenderer>(0);
   
   public var inactiveCellRenderers:Vector.<IDataGridCellRenderer> = new Vector.<IDataGridCellRenderer>(0);
   
   public var factory:Function;
   
   public function CellRendererFactoryStorage(param1:Function = null)
   {
      super();
      this.factory = param1;
   }
}
