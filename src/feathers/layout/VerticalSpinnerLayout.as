package feathers.layout
{
   import feathers.core.IFeathersControl;
   import feathers.core.IValidating;
   import flash.errors.IllegalOperationError;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import starling.events.EventDispatcher;
   
   public class VerticalSpinnerLayout extends EventDispatcher implements ISpinnerLayout, ITrimmedVirtualLayout
   {
      
      protected var _discoveredItemsCache:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
      
      protected var _gap:Number = 0;
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var _horizontalAlign:String = "justify";
      
      protected var _verticalAlign:String = "middle";
      
      protected var _useVirtualLayout:Boolean = true;
      
      protected var _requestedRowCount:int = 0;
      
      protected var _beforeVirtualizedItemCount:int = 0;
      
      protected var _afterVirtualizedItemCount:int = 0;
      
      protected var _typicalItem:DisplayObject;
      
      protected var _resetTypicalItemDimensionsOnMeasure:Boolean = false;
      
      protected var _typicalItemWidth:Number = NaN;
      
      protected var _typicalItemHeight:Number = NaN;
      
      protected var _repeatItems:Boolean = true;
      
      protected var _selectionBounds:flash.geom.Rectangle = new flash.geom.Rectangle();
      
      public function VerticalSpinnerLayout()
      {
         super();
      }
      
      public function get gap() : Number
      {
         return this._gap;
      }
      
      public function set gap(param1:Number) : void
      {
         if(this._gap == param1)
         {
            return;
         }
         this._gap = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get padding() : Number
      {
         return this._paddingLeft;
      }
      
      public function set padding(param1:Number) : void
      {
         this.paddingRight = param1;
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
      
      public function get beforeVirtualizedItemCount() : int
      {
         return this._beforeVirtualizedItemCount;
      }
      
      public function set beforeVirtualizedItemCount(param1:int) : void
      {
         if(this._beforeVirtualizedItemCount == param1)
         {
            return;
         }
         this._beforeVirtualizedItemCount = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get afterVirtualizedItemCount() : int
      {
         return this._afterVirtualizedItemCount;
      }
      
      public function set afterVirtualizedItemCount(param1:int) : void
      {
         if(this._afterVirtualizedItemCount == param1)
         {
            return;
         }
         this._afterVirtualizedItemCount = param1;
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
      
      public function get repeatItems() : Boolean
      {
         return this._repeatItems;
      }
      
      public function set repeatItems(param1:Boolean) : void
      {
         if(this._repeatItems == param1)
         {
            return;
         }
         this._repeatItems = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get snapInterval() : Number
      {
         if(this._typicalItem === null)
         {
            return 0;
         }
         return this._typicalItem.height + this._gap;
      }
      
      public function get requiresLayoutOnScroll() : Boolean
      {
         return true;
      }
      
      public function get selectionBounds() : flash.geom.Rectangle
      {
         return this._selectionBounds;
      }
      
      public function layout(param1:Vector.<DisplayObject>, param2:ViewPortBounds = null, param3:LayoutBoundsResult = null) : LayoutBoundsResult
      {
         var _loc5_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc32_:Number = NaN;
         var _loc33_:DisplayObject = null;
         var _loc34_:Number = NaN;
         var _loc35_:ILayoutDisplayObject = null;
         var _loc36_:Number = NaN;
         var _loc37_:int = 0;
         var _loc38_:Number = NaN;
         var _loc4_:Number = param2 ? param2.scrollX : 0;
         _loc5_ = param2 ? param2.scrollY : 0;
         var _loc6_:Number = param2 ? param2.x : 0;
         var _loc7_:Number = param2 ? param2.y : 0;
         var _loc8_:Number = param2 ? param2.minWidth : 0;
         var _loc9_:Number = param2 ? param2.minHeight : 0;
         var _loc10_:Number = param2 ? param2.maxWidth : Number.POSITIVE_INFINITY;
         var _loc11_:Number = param2 ? param2.maxHeight : Number.POSITIVE_INFINITY;
         var _loc12_:Number = param2 ? param2.explicitWidth : NaN;
         var _loc13_:Number = param2 ? param2.explicitHeight : NaN;
         if(this._useVirtualLayout)
         {
            this.prepareTypicalItem(_loc12_ - this._paddingLeft - this._paddingRight);
            _loc31_ = this._typicalItem ? this._typicalItem.width : 0;
            _loc32_ = this._typicalItem ? this._typicalItem.height : 0;
         }
         if(!this._useVirtualLayout || this._horizontalAlign != HorizontalAlign.JUSTIFY || _loc12_ !== _loc12_)
         {
            this.validateItems(param1,_loc12_ - this._paddingLeft - this._paddingRight,_loc13_);
         }
         var _loc14_:Number = this._useVirtualLayout ? _loc31_ : 0;
         var _loc15_:Number = _loc7_;
         var _loc16_:Number = this._gap;
         var _loc17_:int;
         var _loc18_:int = _loc17_ = int(param1.length);
         if(this._useVirtualLayout)
         {
            if(this._beforeVirtualizedItemCount > 0)
            {
               _loc18_ += this._beforeVirtualizedItemCount;
            }
            _loc18_ += this._afterVirtualizedItemCount;
            _loc15_ += this._beforeVirtualizedItemCount * (_loc32_ + _loc16_);
         }
         this._discoveredItemsCache.length = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         for(; _loc20_ < _loc17_; _loc20_++)
         {
            _loc33_ = param1[_loc20_];
            if(_loc33_)
            {
               if(_loc33_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc33_).includeInLayout)
               {
                  continue;
               }
               _loc33_.y = _loc33_.pivotY + _loc15_;
               _loc33_.height = _loc32_;
               _loc34_ = _loc33_.width;
               if(_loc34_ > _loc14_)
               {
                  _loc14_ = _loc34_;
               }
               if(this._useVirtualLayout)
               {
                  this._discoveredItemsCache[_loc19_] = _loc33_;
                  _loc19_++;
               }
            }
            _loc15_ += _loc32_ + _loc16_;
         }
         if(this._useVirtualLayout)
         {
            _loc15_ += this._afterVirtualizedItemCount * (_loc32_ + _loc16_);
         }
         var _loc21_:Vector.<DisplayObject> = this._useVirtualLayout ? this._discoveredItemsCache : param1;
         var _loc22_:int = int(_loc21_.length);
         var _loc23_:Number = _loc14_ + this._paddingLeft + this._paddingRight;
         var _loc24_:Number = _loc12_;
         if(_loc24_ !== _loc24_)
         {
            _loc24_ = _loc23_;
            if(_loc24_ < _loc8_)
            {
               _loc24_ = _loc8_;
            }
            else if(_loc24_ > _loc10_)
            {
               _loc24_ = _loc10_;
            }
         }
         var _loc25_:Number = _loc15_ - _loc16_ - _loc7_;
         if(this._useVirtualLayout && this._beforeVirtualizedItemCount < 0)
         {
            _loc25_ -= this._beforeVirtualizedItemCount * (_loc32_ + _loc16_);
         }
         var _loc26_:Number = _loc13_;
         if(_loc26_ !== _loc26_)
         {
            if(this._requestedRowCount > 0)
            {
               _loc26_ = this._requestedRowCount * (_loc32_ + _loc16_) - _loc16_;
            }
            else
            {
               _loc26_ = _loc25_;
            }
            if(_loc26_ < _loc9_)
            {
               _loc26_ = _loc9_;
            }
            else if(_loc26_ > _loc11_)
            {
               _loc26_ = _loc11_;
            }
         }
         var _loc27_:int = Math.ceil(_loc26_ / (_loc32_ + _loc16_)) + 1;
         var _loc28_:Number = _loc27_ * (_loc32_ + _loc16_) - _loc16_;
         var _loc29_:Boolean = this._repeatItems && _loc25_ >= _loc28_;
         if(_loc29_)
         {
            _loc25_ += _loc16_;
         }
         var _loc30_:Number = this._paddingTop;
         if(this._verticalAlign === VerticalAlign.BOTTOM)
         {
            _loc30_ = _loc26_ - this._paddingBottom - _loc32_;
         }
         else if(this._verticalAlign === VerticalAlign.MIDDLE)
         {
            _loc30_ = this._paddingTop + Math.round((_loc26_ - this._paddingTop - this._paddingBottom - _loc32_) / 2);
         }
         if(!_loc29_)
         {
            _loc25_ += _loc30_ + (_loc26_ - _loc32_ - _loc30_);
         }
         if(_loc30_ != 0)
         {
            _loc20_ = 0;
            while(_loc20_ < _loc22_)
            {
               _loc33_ = _loc21_[_loc20_];
               if(!(_loc33_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc33_).includeInLayout))
               {
                  _loc33_.y += _loc30_;
               }
               _loc20_++;
            }
         }
         _loc20_ = 0;
         for(; _loc20_ < _loc22_; _loc20_++)
         {
            _loc33_ = _loc21_[_loc20_];
            _loc35_ = _loc33_ as ILayoutDisplayObject;
            if((Boolean(_loc35_)) && !_loc35_.includeInLayout)
            {
               continue;
            }
            if(_loc29_)
            {
               _loc36_ = _loc5_ - _loc30_;
               if(_loc36_ > 0)
               {
                  _loc37_ = int((_loc36_ + _loc26_) / _loc25_);
                  if(this.useVirtualLayout && this._beforeVirtualizedItemCount < 0)
                  {
                     _loc37_++;
                  }
                  _loc33_.y += _loc25_ * _loc37_;
                  if(_loc33_.y >= _loc5_ + _loc26_)
                  {
                     _loc33_.y -= _loc25_;
                  }
               }
               else if(_loc36_ < 0)
               {
                  _loc33_.y += _loc25_ * (int(_loc36_ / _loc25_) - 1);
                  if(_loc33_.y + _loc33_.height < _loc5_)
                  {
                     _loc33_.y += _loc25_;
                  }
               }
            }
            if(this._horizontalAlign == HorizontalAlign.JUSTIFY)
            {
               _loc33_.x = _loc33_.pivotX + _loc6_ + this._paddingLeft;
               _loc33_.width = _loc24_ - this._paddingLeft - this._paddingRight;
               continue;
            }
            _loc38_ = _loc24_;
            if(_loc23_ > _loc38_)
            {
               _loc38_ = _loc23_;
            }
            switch(this._horizontalAlign)
            {
               case HorizontalAlign.RIGHT:
                  _loc33_.x = _loc33_.pivotX + _loc6_ + _loc38_ - this._paddingRight - _loc33_.width;
                  break;
               case HorizontalAlign.CENTER:
                  _loc33_.x = _loc33_.pivotX + _loc6_ + this._paddingLeft + Math.round((_loc38_ - this._paddingLeft - this._paddingRight - _loc33_.width) / 2);
                  break;
               default:
                  _loc33_.x = _loc33_.pivotX + _loc6_ + this._paddingLeft;
            }
         }
         this._discoveredItemsCache.length = 0;
         this._selectionBounds.x = 0;
         this._selectionBounds.y = _loc30_;
         this._selectionBounds.width = _loc24_;
         this._selectionBounds.height = _loc32_;
         if(!param3)
         {
            param3 = new LayoutBoundsResult();
         }
         param3.contentX = 0;
         param3.contentWidth = this._horizontalAlign == HorizontalAlign.JUSTIFY ? _loc24_ : _loc23_;
         if(_loc29_)
         {
            param3.contentY = Number.NEGATIVE_INFINITY;
            param3.contentHeight = Number.POSITIVE_INFINITY;
         }
         else
         {
            param3.contentY = 0;
            param3.contentHeight = _loc25_;
         }
         param3.viewPortWidth = _loc24_;
         param3.viewPortHeight = _loc26_;
         return param3;
      }
      
      public function measureViewPort(param1:int, param2:ViewPortBounds = null, param3:Point = null) : Point
      {
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         if(!param3)
         {
            param3 = new Point();
         }
         if(!this._useVirtualLayout)
         {
            throw new IllegalOperationError("measureViewPort() may be called only if useVirtualLayout is true.");
         }
         var _loc4_:Number = param2 ? param2.explicitWidth : NaN;
         var _loc5_:Number = param2 ? param2.explicitHeight : NaN;
         var _loc6_:Boolean = _loc4_ !== _loc4_;
         var _loc7_:Boolean = _loc5_ !== _loc5_;
         if(!_loc6_ && !_loc7_)
         {
            param3.x = _loc4_;
            param3.y = _loc5_;
            return param3;
         }
         var _loc8_:Number = param2 ? param2.minWidth : 0;
         var _loc9_:Number = param2 ? param2.minHeight : 0;
         var _loc10_:Number = param2 ? param2.maxWidth : Number.POSITIVE_INFINITY;
         var _loc11_:Number = param2 ? param2.maxHeight : Number.POSITIVE_INFINITY;
         this.prepareTypicalItem(_loc4_ - this._paddingLeft - this._paddingRight);
         var _loc12_:Number = this._typicalItem ? this._typicalItem.width : 0;
         var _loc13_:Number = this._typicalItem ? this._typicalItem.height : 0;
         var _loc14_:Number = this._gap;
         var _loc15_:Number = 0;
         var _loc16_:Number = _loc12_;
         _loc15_ += (_loc13_ + _loc14_) * param1;
         _loc15_ = _loc15_ - _loc14_;
         if(_loc6_)
         {
            _loc17_ = _loc16_ + this._paddingLeft + this._paddingRight;
            if(_loc17_ < _loc8_)
            {
               _loc17_ = _loc8_;
            }
            else if(_loc17_ > _loc10_)
            {
               _loc17_ = _loc10_;
            }
            param3.x = _loc17_;
         }
         else
         {
            param3.x = _loc4_;
         }
         if(_loc7_)
         {
            if(this._requestedRowCount > 0)
            {
               _loc18_ = (_loc13_ + _loc14_) * this._requestedRowCount - _loc14_;
            }
            else
            {
               _loc18_ = _loc15_;
            }
            if(_loc18_ < _loc9_)
            {
               _loc18_ = _loc9_;
            }
            else if(_loc18_ > _loc11_)
            {
               _loc18_ = _loc11_;
            }
            param3.y = _loc18_;
         }
         else
         {
            param3.y = _loc5_;
         }
         return param3;
      }
      
      public function getVisibleIndicesAtScrollPosition(param1:Number, param2:Number, param3:Number, param4:Number, param5:int, param6:Vector.<int> = null) : Vector.<int>
      {
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         if(param6)
         {
            param6.length = 0;
         }
         else
         {
            param6 = new Vector.<int>(0);
         }
         if(!this._useVirtualLayout)
         {
            throw new IllegalOperationError("getVisibleIndicesAtScrollPosition() may be called only if useVirtualLayout is true.");
         }
         this.prepareTypicalItem(param3 - this._paddingLeft - this._paddingRight);
         var _loc7_:Number = this._typicalItem ? this._typicalItem.height : 0;
         var _loc8_:Number = this._gap;
         var _loc9_:int = 0;
         var _loc10_:Number = param5 * (_loc7_ + _loc8_) - _loc8_;
         if(this._verticalAlign === VerticalAlign.MIDDLE)
         {
            param2 -= Math.round(this._paddingTop + (param4 - _loc7_) / 2);
         }
         else if(this._verticalAlign === VerticalAlign.BOTTOM)
         {
            param2 -= param4 - _loc7_ - this._paddingBottom;
         }
         else
         {
            param2 -= this._paddingTop;
         }
         var _loc11_:int = Math.ceil(param4 / (_loc7_ + _loc8_)) + 1;
         var _loc12_:Number = _loc11_ * (_loc7_ + _loc8_) - _loc8_;
         var _loc13_:Boolean = this._repeatItems && _loc10_ >= _loc12_;
         if(_loc13_)
         {
            _loc10_ += _loc8_;
            param2 %= _loc10_;
            if(param2 < 0)
            {
               param2 += _loc10_;
            }
            _loc15_ = param2 / (_loc7_ + _loc8_);
            _loc16_ = _loc15_ + _loc11_;
         }
         else
         {
            _loc15_ = param2 / (_loc7_ + _loc8_);
            if(_loc15_ < 0)
            {
               _loc15_ = 0;
            }
            _loc16_ = _loc15_ + _loc11_;
            if(_loc16_ >= param5)
            {
               _loc16_ = param5 - 1;
            }
            _loc15_ = _loc16_ - _loc11_;
            if(_loc15_ < 0)
            {
               _loc15_ = 0;
            }
         }
         var _loc14_:int = _loc15_;
         while(_loc14_ <= _loc16_)
         {
            if(!_loc13_ || _loc14_ >= 0 && _loc14_ < param5)
            {
               param6[_loc9_] = _loc14_;
            }
            else if(_loc14_ < 0)
            {
               param6[_loc9_] = param5 + _loc14_;
            }
            else if(_loc14_ >= param5)
            {
               _loc17_ = _loc14_ - param5;
               if(_loc17_ == _loc15_)
               {
                  break;
               }
               param6[_loc9_] = _loc17_;
            }
            _loc9_++;
            _loc14_++;
         }
         return param6;
      }
      
      public function calculateNavigationDestination(param1:Vector.<DisplayObject>, param2:int, param3:uint, param4:LayoutBoundsResult) : int
      {
         var _loc9_:Number = NaN;
         var _loc10_:* = 0;
         var _loc5_:int = int(param1.length);
         var _loc6_:int = _loc5_ + this._afterVirtualizedItemCount;
         if(this._beforeVirtualizedItemCount > 0)
         {
            _loc6_ += this._beforeVirtualizedItemCount;
         }
         var _loc7_:* = param2;
         if(param3 == Keyboard.HOME)
         {
            if(_loc6_ > 0)
            {
               _loc7_ = 0;
            }
         }
         else if(param3 == Keyboard.END)
         {
            _loc7_ = int(_loc6_ - 1);
         }
         else if(param3 == Keyboard.PAGE_UP)
         {
            _loc9_ = 0;
            _loc10_ = param2;
            while(_loc10_ >= 0)
            {
               _loc9_ += this.snapInterval;
               if(_loc9_ > param4.viewPortHeight)
               {
                  break;
               }
               _loc9_ += this._gap;
               _loc7_ = int(_loc10_);
               _loc10_--;
            }
         }
         else if(param3 == Keyboard.PAGE_DOWN)
         {
            _loc9_ = 0;
            _loc10_ = param2;
            while(_loc10_ < _loc6_)
            {
               _loc9_ += this.snapInterval;
               if(_loc9_ > param4.viewPortHeight)
               {
                  break;
               }
               _loc9_ += this._gap;
               _loc7_ = int(_loc10_);
               _loc10_++;
            }
         }
         else if(param3 == Keyboard.UP)
         {
            _loc7_--;
         }
         else if(param3 == Keyboard.DOWN)
         {
            _loc7_++;
         }
         var _loc8_:Boolean = this._repeatItems && param4.contentHeight == Number.POSITIVE_INFINITY;
         if(_loc8_)
         {
            while(_loc7_ < 0)
            {
               _loc7_ += _loc6_;
            }
            while(_loc7_ >= _loc6_)
            {
               _loc7_ -= _loc6_;
            }
         }
         else if(_loc7_ < 0)
         {
            return 0;
         }
         if(_loc7_ >= _loc6_)
         {
            return _loc6_ - 1;
         }
         return _loc7_;
      }
      
      public function getNearestScrollPositionForIndex(param1:int, param2:Number, param3:Number, param4:Vector.<DisplayObject>, param5:Number, param6:Number, param7:Number, param8:Number, param9:Point = null) : Point
      {
         return this.getScrollPositionForIndex(param1,param4,param5,param6,param7,param8,param9);
      }
      
      public function getScrollPositionForIndex(param1:int, param2:Vector.<DisplayObject>, param3:Number, param4:Number, param5:Number, param6:Number, param7:Point = null) : Point
      {
         this.prepareTypicalItem(param5 - this._paddingLeft - this._paddingRight);
         var _loc8_:Number = this._typicalItem ? this._typicalItem.height : 0;
         if(!param7)
         {
            param7 = new Point();
         }
         param7.x = 0;
         param7.y = _loc8_ * param1;
         return param7;
      }
      
      protected function validateItems(param1:Vector.<DisplayObject>, param2:Number, param3:Number) : void
      {
         var _loc8_:DisplayObject = null;
         var _loc4_:Boolean = this._horizontalAlign == HorizontalAlign.JUSTIFY;
         var _loc5_:Boolean = (_loc4_) && param2 === param2;
         var _loc6_:int = int(param1.length);
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = param1[_loc7_];
            if(!(!_loc8_ || _loc8_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc8_).includeInLayout))
            {
               if(_loc5_)
               {
                  _loc8_.width = param2;
               }
               else if(_loc4_ && _loc8_ is IFeathersControl)
               {
                  _loc8_.width = NaN;
               }
               if(_loc8_ is IValidating)
               {
                  IValidating(_loc8_).validate();
               }
            }
            _loc7_++;
         }
      }
      
      protected function prepareTypicalItem(param1:Number) : void
      {
         if(!this._typicalItem)
         {
            return;
         }
         if(this._horizontalAlign == HorizontalAlign.JUSTIFY && param1 === param1)
         {
            this._typicalItem.width = param1;
         }
         else if(this._resetTypicalItemDimensionsOnMeasure)
         {
            this._typicalItem.width = this._typicalItemWidth;
         }
         if(this._resetTypicalItemDimensionsOnMeasure)
         {
            this._typicalItem.height = this._typicalItemHeight;
         }
         if(this._typicalItem is IValidating)
         {
            IValidating(this._typicalItem).validate();
         }
      }
   }
}

