package feathers.controls.renderers
{
   import feathers.controls.DataGrid;
   import feathers.controls.DataGridColumn;
   import feathers.events.FeathersEventType;
   import feathers.skins.IStyleProvider;
   
   public class DefaultDataGridCellRenderer extends BaseDefaultItemRenderer implements IDataGridCellRenderer
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      public static const ALTERNATE_STYLE_NAME_CHECK:String = "feathers-check-item-renderer";
      
      public static const DEFAULT_CHILD_STYLE_NAME_LABEL:String = "feathers-item-renderer-label";
      
      public static const DEFAULT_CHILD_STYLE_NAME_ICON_LABEL:String = "feathers-item-renderer-icon-label";
      
      public static const DEFAULT_CHILD_STYLE_NAME_ACCESSORY_LABEL:String = "feathers-item-renderer-accessory-label";
      
      protected var _rowIndex:int = -1;
      
      protected var _columnIndex:int = -1;
      
      protected var _dataField:String = null;
      
      protected var _column:DataGridColumn = null;
      
      public function DefaultDataGridCellRenderer()
      {
         super();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return DefaultDataGridCellRenderer.globalStyleProvider;
      }
      
      public function get rowIndex() : int
      {
         return this._rowIndex;
      }
      
      public function set rowIndex(param1:int) : void
      {
         if(this._rowIndex == param1)
         {
            return;
         }
         this._rowIndex = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get columnIndex() : int
      {
         return this._columnIndex;
      }
      
      public function set columnIndex(param1:int) : void
      {
         if(this._columnIndex == param1)
         {
            return;
         }
         this._columnIndex = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get dataField() : String
      {
         return this._dataField;
      }
      
      public function set dataField(param1:String) : void
      {
         if(this._dataField === param1)
         {
            return;
         }
         this._dataField = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get column() : DataGridColumn
      {
         return this._column;
      }
      
      public function set column(param1:DataGridColumn) : void
      {
         if(this._column === param1)
         {
            return;
         }
         this._column = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get owner() : DataGrid
      {
         return DataGrid(this._owner);
      }
      
      public function set owner(param1:DataGrid) : void
      {
         var _loc2_:DataGrid = null;
         if(this._owner === param1)
         {
            return;
         }
         if(this._owner)
         {
            this._owner.removeEventListener(FeathersEventType.SCROLL_START,owner_scrollStartHandler);
            this._owner.removeEventListener(FeathersEventType.SCROLL_COMPLETE,owner_scrollCompleteHandler);
         }
         this._owner = param1;
         if(this._owner)
         {
            _loc2_ = DataGrid(this._owner);
            this.isSelectableWithoutToggle = _loc2_.isSelectable;
            if(_loc2_.allowMultipleSelection)
            {
               this.isToggle = true;
            }
            this._owner.addEventListener(FeathersEventType.SCROLL_START,owner_scrollStartHandler);
            this._owner.addEventListener(FeathersEventType.SCROLL_COMPLETE,owner_scrollCompleteHandler);
         }
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      override public function dispose() : void
      {
         this.owner = null;
         super.dispose();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this.touchToState.target = this.parent;
      }
      
      override protected function getDataToRender() : Object
      {
         if(this._data === null || this._dataField === null)
         {
            return this._data;
         }
         return this._data[this._dataField];
      }
   }
}

