package feathers.controls.renderers
{
   import feathers.controls.DataGrid;
   import feathers.controls.DataGridColumn;
   import feathers.core.IToggle;
   import feathers.layout.ILayoutDisplayObject;
   
   public interface IDataGridCellRenderer extends IToggle, ILayoutDisplayObject
   {
      
      function get data() : Object;
      
      function set data(param1:Object) : void;
      
      function get column() : DataGridColumn;
      
      function set column(param1:DataGridColumn) : void;
      
      function get columnIndex() : int;
      
      function set columnIndex(param1:int) : void;
      
      function get rowIndex() : int;
      
      function set rowIndex(param1:int) : void;
      
      function get dataField() : String;
      
      function set dataField(param1:String) : void;
      
      function get owner() : DataGrid;
      
      function set owner(param1:DataGrid) : void;
   }
}

