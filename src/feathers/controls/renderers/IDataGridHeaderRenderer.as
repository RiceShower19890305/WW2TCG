package feathers.controls.renderers
{
   import feathers.controls.DataGrid;
   import feathers.controls.DataGridColumn;
   import feathers.core.IFeathersControl;
   import feathers.layout.ILayoutDisplayObject;
   
   public interface IDataGridHeaderRenderer extends IFeathersControl, ILayoutDisplayObject
   {
      
      function get data() : DataGridColumn;
      
      function set data(param1:DataGridColumn) : void;
      
      function get columnIndex() : int;
      
      function set columnIndex(param1:int) : void;
      
      function get owner() : DataGrid;
      
      function set owner(param1:DataGrid) : void;
      
      function get sortOrder() : String;
      
      function set sortOrder(param1:String) : void;
   }
}

