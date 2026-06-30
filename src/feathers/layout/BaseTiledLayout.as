package feathers.layout
{
   import starling.display.DisplayObject;
   import starling.errors.AbstractClassError;
   import starling.events.Event;
   import starling.events.EventDispatcher;
   
   public class BaseTiledLayout extends EventDispatcher
   {
      
      protected var _discoveredItemsCache:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
      
      protected var _horizontalGap:Number = 0;
      
      protected var _verticalGap:Number = 0;
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var _requestedColumnCount:int = 0;
      
      protected var _requestedRowCount:int = 0;
      
      protected var _verticalAlign:String = "top";
      
      protected var _horizontalAlign:String = "center";
      
      protected var _tileVerticalAlign:String = "middle";
      
      protected var _tileHorizontalAlign:String = "center";
      
      protected var _paging:String = "none";
      
      protected var _distributeWidths:Boolean = false;
      
      protected var _distributeHeights:Boolean = false;
      
      protected var _useSquareTiles:Boolean = true;
      
      protected var _useVirtualLayout:Boolean = true;
      
      protected var _typicalItem:DisplayObject;
      
      protected var _resetTypicalItemDimensionsOnMeasure:Boolean = false;
      
      protected var _typicalItemWidth:Number = NaN;
      
      protected var _typicalItemHeight:Number = NaN;
      
      public function BaseTiledLayout()
      {
         super();
         if(Object(this).constructor == BaseTiledLayout)
         {
            throw new AbstractClassError();
         }
      }
      
      public function get gap() : Number
      {
         return this._horizontalGap;
      }
      
      public function set gap(param1:Number) : void
      {
         this.horizontalGap = param1;
         this.verticalGap = param1;
      }
      
      public function get horizontalGap() : Number
      {
         return this._horizontalGap;
      }
      
      public function set horizontalGap(param1:Number) : void
      {
         if(this._horizontalGap == param1)
         {
            return;
         }
         this._horizontalGap = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get verticalGap() : Number
      {
         return this._verticalGap;
      }
      
      public function set verticalGap(param1:Number) : void
      {
         if(this._verticalGap == param1)
         {
            return;
         }
         this._verticalGap = param1;
         this.dispatchEventWith(Event.CHANGE);
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
         if(this._paddingTop == param1)
         {
            return;
         }
         this._paddingTop = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get paddingRight() : Number
      {
         return this._paddingRight;
      }
      
      public function set paddingRight(param1:Number) : void
      {
         if(this._paddingRight == param1)
         {
            return;
         }
         this._paddingRight = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get paddingBottom() : Number
      {
         return this._paddingBottom;
      }
      
      public function set paddingBottom(param1:Number) : void
      {
         if(this._paddingBottom == param1)
         {
            return;
         }
         this._paddingBottom = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get paddingLeft() : Number
      {
         return this._paddingLeft;
      }
      
      public function set paddingLeft(param1:Number) : void
      {
         if(this._paddingLeft == param1)
         {
            return;
         }
         this._paddingLeft = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get requestedColumnCount() : int
      {
         return this._requestedColumnCount;
      }
      
      public function set requestedColumnCount(param1:int) : void
      {
         if(param1 < 0)
         {
            throw RangeError("requestedColumnCount requires a value >= 0");
         }
         if(this._requestedColumnCount == param1)
         {
            return;
         }
         this._requestedColumnCount = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get requestedRowCount() : int
      {
         return this._requestedRowCount;
      }
      
      public function set requestedRowCount(param1:int) : void
      {
         if(param1 < 0)
         {
            throw RangeError("requestedRowCount requires a value >= 0");
         }
         if(this._requestedRowCount == param1)
         {
            return;
         }
         this._requestedRowCount = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get verticalAlign() : String
      {
         return this._verticalAlign;
      }
      
      public function set verticalAlign(param1:String) : void
      {
         if(this._verticalAlign == param1)
         {
            return;
         }
         this._verticalAlign = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get horizontalAlign() : String
      {
         return this._horizontalAlign;
      }
      
      public function set horizontalAlign(param1:String) : void
      {
         if(this._horizontalAlign == param1)
         {
            return;
         }
         this._horizontalAlign = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get tileVerticalAlign() : String
      {
         return this._tileVerticalAlign;
      }
      
      public function set tileVerticalAlign(param1:String) : void
      {
         if(this._tileVerticalAlign == param1)
         {
            return;
         }
         this._tileVerticalAlign = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get tileHorizontalAlign() : String
      {
         return this._tileHorizontalAlign;
      }
      
      public function set tileHorizontalAlign(param1:String) : void
      {
         if(this._tileHorizontalAlign == param1)
         {
            return;
         }
         this._tileHorizontalAlign = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get paging() : String
      {
         return this._paging;
      }
      
      public function set paging(param1:String) : void
      {
         if(this._paging == param1)
         {
            return;
         }
         this._paging = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get distributeWidths() : Boolean
      {
         return this._distributeWidths;
      }
      
      public function set distributeWidths(param1:Boolean) : void
      {
         if(this._distributeWidths === param1)
         {
            return;
         }
         this._distributeWidths = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get distributeHeights() : Boolean
      {
         return this._distributeHeights;
      }
      
      public function set distributeHeights(param1:Boolean) : void
      {
         if(this._distributeHeights === param1)
         {
            return;
         }
         this._distributeHeights = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get useSquareTiles() : Boolean
      {
         return this._useSquareTiles;
      }
      
      public function set useSquareTiles(param1:Boolean) : void
      {
         if(this._useSquareTiles == param1)
         {
            return;
         }
         this._useSquareTiles = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get useVirtualLayout() : Boolean
      {
         return this._useVirtualLayout;
      }
      
      public function set useVirtualLayout(param1:Boolean) : void
      {
         if(this._useVirtualLayout == param1)
         {
            return;
         }
         this._useVirtualLayout = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get typicalItem() : DisplayObject
      {
         return this._typicalItem;
      }
      
      public function set typicalItem(param1:DisplayObject) : void
      {
         if(this._typicalItem == param1)
         {
            return;
         }
         this._typicalItem = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get resetTypicalItemDimensionsOnMeasure() : Boolean
      {
         return this._resetTypicalItemDimensionsOnMeasure;
      }
      
      public function set resetTypicalItemDimensionsOnMeasure(param1:Boolean) : void
      {
         if(this._resetTypicalItemDimensionsOnMeasure == param1)
         {
            return;
         }
         this._resetTypicalItemDimensionsOnMeasure = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get typicalItemWidth() : Number
      {
         return this._typicalItemWidth;
      }
      
      public function set typicalItemWidth(param1:Number) : void
      {
         if(this._typicalItemWidth == param1)
         {
            return;
         }
         this._typicalItemWidth = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get typicalItemHeight() : Number
      {
         return this._typicalItemHeight;
      }
      
      public function set typicalItemHeight(param1:Number) : void
      {
         if(this._typicalItemHeight == param1)
         {
            return;
         }
         this._typicalItemHeight = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get requiresLayoutOnScroll() : Boolean
      {
         return this._useVirtualLayout;
      }
   }
}

