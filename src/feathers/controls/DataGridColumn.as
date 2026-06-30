package feathers.controls
{
   import starling.events.Event;
   import starling.events.EventDispatcher;
   
   public class DataGridColumn extends EventDispatcher
   {
      
      protected var _headerText:String = null;
      
      protected var _dataField:String = null;
      
      protected var _cellRendererFactory:Function = null;
      
      protected var _customCellRendererStyleName:String = null;
      
      protected var _headerRendererFactory:Function = null;
      
      protected var _customHeaderRendererStyleName:String = null;
      
      protected var _minWidth:Number = 10;
      
      protected var _width:Number = NaN;
      
      protected var _sortCompareFunction:Function = null;
      
      protected var _sortOrder:String = "ascending";
      
      protected var _resizable:Boolean = true;
      
      public function DataGridColumn(param1:String = null, param2:String = null)
      {
         super();
         this.dataField = param1;
         this.headerText = param2;
      }
      
      public function get headerText() : String
      {
         return this._headerText;
      }
      
      public function set headerText(param1:String) : void
      {
         if(this._headerText === param1)
         {
            return;
         }
         this._headerText = param1;
         this.dispatchEventWith(Event.CHANGE);
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
         this.dispatchEventWith(Event.CHANGE);
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
      
      public function get minWidth() : Number
      {
         return this._minWidth;
      }
      
      public function set minWidth(param1:Number) : void
      {
         if(this._minWidth == param1)
         {
            return;
         }
         this._minWidth = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get width() : Number
      {
         return this._width;
      }
      
      public function set width(param1:Number) : void
      {
         if(this._width == param1)
         {
            return;
         }
         this._width = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get sortCompareFunction() : Function
      {
         return this._sortCompareFunction;
      }
      
      public function set sortCompareFunction(param1:Function) : void
      {
         if(this._sortCompareFunction === param1)
         {
            return;
         }
         this._sortCompareFunction = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get sortOrder() : String
      {
         return this._sortOrder;
      }
      
      public function set sortOrder(param1:String) : void
      {
         if(this._sortOrder === param1)
         {
            return;
         }
         this._sortOrder = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get resizable() : Boolean
      {
         return this._resizable;
      }
      
      public function set resizable(param1:Boolean) : void
      {
         if(this._resizable === param1)
         {
            return;
         }
         this._resizable = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
   }
}

