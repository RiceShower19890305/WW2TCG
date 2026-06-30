package feathers.layout
{
   import feathers.core.IFeathersControl;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.IValidating;
   import flash.errors.IllegalOperationError;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.events.Event;
   import starling.utils.Pool;
   
   public class VerticalLayout extends BaseLinearLayout implements IVariableVirtualLayout, ITrimmedVirtualLayout, IGroupedLayout, IDragDropLayout
   {
      
      protected var _stickyHeader:Boolean = false;
      
      protected var _headerIndices:Vector.<int>;
      
      protected var _distributeHeights:Boolean = false;
      
      protected var _requestedRowCount:int = 0;
      
      protected var _maxRowCount:int = 0;
      
      protected var _scrollPositionVerticalAlign:String = "middle";
      
      protected var _headerScrollPositionVerticalAlign:String = "top";
      
      public function VerticalLayout()
      {
         super();
      }
      
      override public function get horizontalAlign() : String
      {
         return this._horizontalAlign;
      }
      
      override public function get verticalAlign() : String
      {
         return this._verticalAlign;
      }
      
      public function get stickyHeader() : Boolean
      {
         return this._stickyHeader;
      }
      
      public function set stickyHeader(param1:Boolean) : void
      {
         if(this._stickyHeader == param1)
         {
            return;
         }
         this._stickyHeader = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get headerIndices() : Vector.<int>
      {
         return this._headerIndices;
      }
      
      public function set headerIndices(param1:Vector.<int>) : void
      {
         if(this._headerIndices == param1)
         {
            return;
         }
         this._headerIndices = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get distributeHeights() : Boolean
      {
         return this._distributeHeights;
      }
      
      public function set distributeHeights(param1:Boolean) : void
      {
         if(this._distributeHeights == param1)
         {
            return;
         }
         this._distributeHeights = param1;
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
      
      public function get maxRowCount() : int
      {
         return this._maxRowCount;
      }
      
      public function set maxRowCount(param1:int) : void
      {
         if(param1 < 0)
         {
            throw RangeError("maxRowCount requires a value >= 0");
         }
         if(this._maxRowCount == param1)
         {
            return;
         }
         this._maxRowCount = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get scrollPositionVerticalAlign() : String
      {
         return this._scrollPositionVerticalAlign;
      }
      
      public function set scrollPositionVerticalAlign(param1:String) : void
      {
         this._scrollPositionVerticalAlign = param1;
      }
      
      public function get headerScrollPositionVerticalAlign() : String
      {
         return this._headerScrollPositionVerticalAlign;
      }
      
      public function set headerScrollPositionVerticalAlign(param1:String) : void
      {
         this._headerScrollPositionVerticalAlign = param1;
      }
      
      override public function get requiresLayoutOnScroll() : Boolean
      {
         return this._useVirtualLayout || Boolean(this._headerIndices) && this._stickyHeader;
      }
      
      public function layout(param1:Vector.<DisplayObject>, param2:ViewPortBounds = null, param3:LayoutBoundsResult = null) : LayoutBoundsResult
      {
         var _loc16_:Number = NaN;
         var _loc17_:Boolean = false;
         var _loc43_:Number = NaN;
         var _loc44_:Number = NaN;
         var _loc45_:DisplayObject = null;
         var _loc46_:int = 0;
         var _loc47_:Number = NaN;
         var _loc48_:ILayoutDisplayObject = null;
         var _loc49_:Number = NaN;
         var _loc50_:Number = NaN;
         var _loc51_:Number = NaN;
         var _loc52_:DisplayObject = null;
         var _loc53_:Number = NaN;
         var _loc54_:Number = NaN;
         var _loc55_:Number = NaN;
         var _loc56_:VerticalLayoutData = null;
         var _loc57_:Number = NaN;
         var _loc58_:IFeathersControl = null;
         var _loc59_:Number = NaN;
         var _loc60_:Number = NaN;
         var _loc4_:Number = param2 ? param2.scrollX : 0;
         var _loc5_:Number = param2 ? param2.scrollY : 0;
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
            _loc43_ = this._typicalItem ? this._typicalItem.width : 0;
            _loc44_ = this._typicalItem ? this._typicalItem.height : 0;
         }
         var _loc14_:Boolean = _loc12_ !== _loc12_;
         var _loc15_:Boolean = _loc13_ !== _loc13_;
         if(!_loc15_ && this._distributeHeights)
         {
            _loc16_ = this.calculateDistributedHeight(param1,_loc13_,_loc9_,_loc11_,false);
            if(this._useVirtualLayout)
            {
               _loc44_ = _loc16_;
            }
         }
         if(!this._useVirtualLayout || this._hasVariableItemDimensions || this._distributeHeights || this._horizontalAlign != HorizontalAlign.JUSTIFY || _loc14_)
         {
            this.validateItems(param1,_loc12_ - this._paddingLeft - this._paddingRight,_loc8_ - this._paddingLeft - this._paddingRight,_loc10_ - this._paddingLeft - this._paddingRight,_loc13_ - this._paddingTop - this._paddingBottom,_loc9_ - this._paddingTop - this._paddingBottom,_loc11_ - this._paddingTop - this._paddingBottom,_loc16_);
         }
         if(_loc15_ && this._distributeHeights)
         {
            _loc16_ = this.calculateDistributedHeight(param1,_loc13_,_loc9_,_loc11_,true);
         }
         _loc17_ = _loc16_ === _loc16_;
         if(!this._useVirtualLayout)
         {
            this.applyPercentHeights(param1,_loc13_,_loc9_,_loc11_);
         }
         var _loc18_:Boolean = this._firstGap === this._firstGap;
         var _loc19_:Boolean = this._lastGap === this._lastGap;
         var _loc20_:Number = this._useVirtualLayout ? _loc43_ : 0;
         var _loc21_:Number;
         var _loc22_:Number = _loc21_ = _loc7_ + this._paddingTop;
         var _loc23_:int = 0;
         var _loc24_:int;
         var _loc25_:int = _loc24_ = int(param1.length);
         var _loc26_:Number = 0;
         var _loc27_:Number = Number.POSITIVE_INFINITY;
         if(this._useVirtualLayout && !this._hasVariableItemDimensions)
         {
            _loc25_ += this._beforeVirtualizedItemCount + this._afterVirtualizedItemCount;
            _loc23_ = this._beforeVirtualizedItemCount;
            _loc22_ += this._beforeVirtualizedItemCount * (_loc44_ + this._gap);
            if(_loc18_ && this._beforeVirtualizedItemCount > 0)
            {
               _loc22_ = _loc22_ - this._gap + this._firstGap;
            }
         }
         var _loc28_:int = _loc25_ - 2;
         this._discoveredItemsCache.length = 0;
         var _loc29_:int = 0;
         var _loc30_:Number = 0;
         var _loc31_:int = -1;
         var _loc32_:int = -1;
         var _loc33_:int = 0;
         var _loc34_:Number = Number.POSITIVE_INFINITY;
         if(Boolean(this._headerIndices) && this._stickyHeader)
         {
            _loc33_ = int(this._headerIndices.length);
            if(_loc33_ > 0)
            {
               _loc31_ = 0;
               _loc32_ = this._headerIndices[_loc31_];
            }
         }
         var _loc35_:int = 0;
         while(_loc35_ < _loc24_)
         {
            if(!this._useVirtualLayout)
            {
               if(this._maxRowCount > 0 && this._maxRowCount == _loc35_)
               {
                  _loc27_ = _loc22_;
               }
               if(this._requestedRowCount > 0 && this._requestedRowCount == _loc35_)
               {
                  _loc26_ = _loc22_;
               }
            }
            _loc45_ = param1[_loc35_];
            _loc46_ = _loc35_ + _loc23_;
            if(_loc32_ == _loc46_)
            {
               if(_loc22_ < _loc5_)
               {
                  if(++_loc31_ < _loc33_)
                  {
                     _loc32_ = this._headerIndices[_loc31_];
                  }
               }
               else if(--_loc31_ >= 0)
               {
                  _loc32_ = this._headerIndices[_loc31_];
                  _loc34_ = _loc22_;
               }
            }
            _loc30_ = this._gap;
            if(_loc18_ && _loc46_ == 0)
            {
               _loc30_ = this._firstGap;
            }
            else if(_loc19_ && _loc46_ > 0 && _loc46_ == _loc28_)
            {
               _loc30_ = this._lastGap;
            }
            if(this._useVirtualLayout && this._hasVariableItemDimensions)
            {
               _loc47_ = Number(this._virtualCache[_loc46_]);
            }
            if(this._useVirtualLayout && !_loc45_)
            {
               if(!this._hasVariableItemDimensions || _loc47_ !== _loc47_)
               {
                  _loc22_ += _loc44_ + _loc30_;
               }
               else
               {
                  _loc22_ += _loc47_ + _loc30_;
               }
            }
            else
            {
               _loc48_ = _loc45_ as ILayoutDisplayObject;
               if(!(_loc48_ !== null && !_loc48_.includeInLayout))
               {
                  _loc49_ = _loc45_.pivotY;
                  if(_loc49_ != 0)
                  {
                     _loc49_ *= _loc45_.scaleY;
                  }
                  _loc45_.y = _loc49_ + _loc22_;
                  _loc50_ = _loc45_.width;
                  if(_loc17_)
                  {
                     _loc45_.height = _loc51_ = _loc16_;
                  }
                  else
                  {
                     _loc51_ = _loc45_.height;
                  }
                  if(this._useVirtualLayout)
                  {
                     if(this._hasVariableItemDimensions)
                     {
                        if(_loc51_ != _loc47_)
                        {
                           this._virtualCache[_loc46_] = _loc51_;
                           if(_loc22_ < _loc5_ && _loc47_ !== _loc47_ && _loc51_ != _loc44_)
                           {
                              this.dispatchEventWith(Event.SCROLL,false,new Point(0,_loc51_ - _loc44_));
                           }
                           this.dispatchEventWith(Event.CHANGE);
                        }
                     }
                     else if(_loc44_ >= 0)
                     {
                        _loc51_ = _loc44_;
                        if(_loc45_ !== this._typicalItem || _loc45_.height != _loc51_)
                        {
                           _loc45_.height = _loc51_;
                        }
                     }
                  }
                  _loc22_ += _loc51_ + _loc30_;
                  if(_loc50_ > _loc20_)
                  {
                     _loc20_ = _loc50_;
                  }
                  if(this._useVirtualLayout)
                  {
                     this._discoveredItemsCache[_loc29_] = _loc45_;
                     _loc29_++;
                  }
               }
            }
            _loc35_++;
         }
         if(this._useVirtualLayout && !this._hasVariableItemDimensions)
         {
            _loc22_ += this._afterVirtualizedItemCount * (_loc44_ + this._gap);
            if(_loc19_ && this._afterVirtualizedItemCount > 0)
            {
               _loc22_ = _loc22_ - this._gap + this._lastGap;
            }
         }
         if(_loc32_ >= 0)
         {
            _loc52_ = param1[_loc32_];
            this.positionStickyHeader(_loc52_,_loc5_,_loc34_);
         }
         if(!this._useVirtualLayout && this._requestedRowCount > _loc24_)
         {
            if(_loc24_ > 0)
            {
               _loc26_ = this._requestedRowCount * _loc22_ / _loc24_;
            }
            else
            {
               _loc26_ = 0;
            }
         }
         var _loc36_:Vector.<DisplayObject> = this._useVirtualLayout ? this._discoveredItemsCache : param1;
         var _loc37_:int = int(_loc36_.length);
         var _loc38_:Number = _loc20_ + this._paddingLeft + this._paddingRight;
         var _loc39_:Number = _loc12_;
         if(_loc39_ !== _loc39_)
         {
            _loc39_ = _loc38_;
            if(_loc39_ < _loc8_)
            {
               _loc39_ = _loc8_;
            }
            else if(_loc39_ > _loc10_)
            {
               _loc39_ = _loc10_;
            }
         }
         var _loc40_:Number = _loc22_ - _loc30_ + this._paddingBottom - _loc7_;
         var _loc41_:Number = _loc13_;
         if(_loc41_ !== _loc41_)
         {
            _loc41_ = _loc40_;
            if(this._requestedRowCount > 0)
            {
               if(this._useVirtualLayout)
               {
                  _loc41_ = this._requestedRowCount * (_loc44_ + this._gap) - this._gap + this._paddingTop + this._paddingBottom;
               }
               else
               {
                  _loc41_ = _loc26_;
               }
            }
            else
            {
               _loc41_ = _loc40_;
               if(this._maxRowCount > 0)
               {
                  if(this._useVirtualLayout)
                  {
                     _loc27_ = this._maxRowCount * (_loc44_ + this._gap) - this._gap + this._paddingTop + this._paddingBottom;
                  }
                  if(_loc27_ < _loc41_)
                  {
                     _loc41_ = _loc27_;
                  }
               }
            }
            if(_loc41_ < _loc9_)
            {
               _loc41_ = _loc9_;
            }
            else if(_loc41_ > _loc11_)
            {
               _loc41_ = _loc11_;
            }
         }
         if(_loc40_ < _loc41_)
         {
            _loc53_ = 0;
            if(this._verticalAlign == VerticalAlign.BOTTOM)
            {
               _loc53_ = _loc41_ - _loc40_;
            }
            else if(this._verticalAlign == VerticalAlign.MIDDLE)
            {
               _loc53_ = Math.round((_loc41_ - _loc40_) / 2);
            }
            if(_loc53_ != 0)
            {
               _loc35_ = 0;
               while(_loc35_ < _loc37_)
               {
                  _loc45_ = _loc36_[_loc35_];
                  if(!(_loc45_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc45_).includeInLayout))
                  {
                     _loc45_.y += _loc53_;
                  }
                  _loc35_++;
               }
            }
         }
         var _loc42_:Number = _loc39_ - this._paddingLeft - this._paddingRight;
         _loc35_ = 0;
         for(; _loc35_ < _loc37_; _loc35_++)
         {
            _loc45_ = _loc36_[_loc35_];
            _loc48_ = _loc45_ as ILayoutDisplayObject;
            if(_loc48_ !== null && !_loc48_.includeInLayout)
            {
               continue;
            }
            _loc54_ = _loc45_.pivotX;
            if(_loc54_ != 0)
            {
               _loc54_ *= _loc45_.scaleX;
            }
            if(this._horizontalAlign == HorizontalAlign.JUSTIFY)
            {
               _loc45_.x = _loc54_ + _loc6_ + this._paddingLeft;
               _loc45_.width = _loc42_;
               continue;
            }
            if(_loc48_ !== null)
            {
               _loc56_ = _loc48_.layoutData as VerticalLayoutData;
               if(_loc56_ !== null)
               {
                  _loc57_ = _loc56_.percentWidth;
                  if(_loc57_ === _loc57_)
                  {
                     if(_loc57_ < 0)
                     {
                        _loc57_ = 0;
                     }
                     if(_loc57_ > 100)
                     {
                        _loc57_ = 100;
                     }
                     _loc50_ = _loc57_ * _loc42_ / 100;
                     if(_loc45_ is IFeathersControl)
                     {
                        _loc58_ = IFeathersControl(_loc45_);
                        _loc59_ = Number(_loc58_.explicitMinWidth);
                        if(_loc59_ > _loc42_)
                        {
                           _loc59_ = _loc42_;
                        }
                        if(_loc50_ < _loc59_)
                        {
                           _loc50_ = _loc59_;
                        }
                        else
                        {
                           _loc60_ = Number(_loc58_.explicitMaxWidth);
                           if(_loc50_ > _loc60_)
                           {
                              _loc50_ = _loc60_;
                           }
                        }
                     }
                     _loc45_.width = _loc50_;
                  }
               }
            }
            _loc55_ = _loc39_;
            if(_loc38_ > _loc55_)
            {
               _loc55_ = _loc38_;
            }
            switch(this._horizontalAlign)
            {
               case HorizontalAlign.RIGHT:
                  _loc45_.x = _loc54_ + _loc6_ + _loc55_ - this._paddingRight - _loc45_.width;
                  break;
               case HorizontalAlign.CENTER:
                  _loc45_.x = _loc54_ + _loc6_ + this._paddingLeft + Math.round((_loc55_ - this._paddingLeft - this._paddingRight - _loc45_.width) / 2);
                  break;
               default:
                  _loc45_.x = _loc54_ + _loc6_ + this._paddingLeft;
            }
         }
         this._discoveredItemsCache.length = 0;
         if(!param3)
         {
            param3 = new LayoutBoundsResult();
         }
         param3.contentX = 0;
         param3.contentWidth = this._horizontalAlign == HorizontalAlign.JUSTIFY ? _loc39_ : _loc38_;
         param3.contentY = 0;
         param3.contentHeight = _loc40_;
         param3.viewPortWidth = _loc39_;
         param3.viewPortHeight = _loc41_;
         return param3;
      }
      
      public function measureViewPort(param1:int, param2:ViewPortBounds = null, param3:Point = null) : Point
      {
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:int = 0;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
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
         var _loc14_:Boolean = this._firstGap === this._firstGap;
         var _loc15_:Boolean = this._lastGap === this._lastGap;
         if(this._distributeHeights)
         {
            _loc16_ = (_loc13_ + this._gap) * param1;
         }
         else
         {
            _loc16_ = 0;
            _loc17_ = _loc12_;
            if(!this._hasVariableItemDimensions)
            {
               _loc16_ += (_loc13_ + this._gap) * param1;
            }
            else
            {
               _loc18_ = 0;
               while(_loc18_ < param1)
               {
                  _loc19_ = Number(this._virtualCache[_loc18_]);
                  if(_loc19_ !== _loc19_)
                  {
                     _loc16_ += _loc13_ + this._gap;
                  }
                  else
                  {
                     _loc16_ += _loc19_ + this._gap;
                  }
                  _loc18_++;
               }
            }
         }
         _loc16_ -= this._gap;
         if(_loc14_ && param1 > 1)
         {
            _loc16_ = _loc16_ - this._gap + this._firstGap;
         }
         if(_loc15_ && param1 > 2)
         {
            _loc16_ = _loc16_ - this._gap + this._lastGap;
         }
         if(_loc6_)
         {
            _loc20_ = _loc17_ + this._paddingLeft + this._paddingRight;
            if(_loc20_ < _loc8_)
            {
               _loc20_ = _loc8_;
            }
            else if(_loc20_ > _loc10_)
            {
               _loc20_ = _loc10_;
            }
            param3.x = _loc20_;
         }
         else
         {
            param3.x = _loc4_;
         }
         if(_loc7_)
         {
            if(this._requestedRowCount > 0)
            {
               _loc21_ = (_loc13_ + this._gap) * this._requestedRowCount - this._gap;
            }
            else
            {
               _loc21_ = _loc16_;
               if(this._maxRowCount > 0)
               {
                  _loc22_ = (_loc13_ + this._gap) * this._maxRowCount - this._gap;
                  if(_loc22_ < _loc21_)
                  {
                     _loc21_ = _loc22_;
                  }
               }
            }
            _loc21_ += this._paddingTop + this._paddingBottom;
            if(_loc21_ < _loc9_)
            {
               _loc21_ = _loc9_;
            }
            else if(_loc21_ > _loc11_)
            {
               _loc21_ = _loc11_;
            }
            param3.y = _loc21_;
         }
         else
         {
            param3.y = _loc5_;
         }
         return param3;
      }
      
      public function getVisibleIndicesAtScrollPosition(param1:Number, param2:Number, param3:Number, param4:Number, param5:int, param6:Vector.<int> = null) : Vector.<int>
      {
         var _loc23_:Number = NaN;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:* = 0;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc32_:Boolean = false;
         var _loc33_:int = 0;
         var _loc34_:int = 0;
         var _loc35_:int = 0;
         var _loc36_:int = 0;
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
         var _loc7_:Number = this._typicalItem ? this._typicalItem.width : 0;
         var _loc8_:Number = this._typicalItem ? this._typicalItem.height : 0;
         var _loc9_:Boolean = this._firstGap === this._firstGap;
         var _loc10_:Boolean = this._lastGap === this._lastGap;
         var _loc11_:int = 0;
         var _loc12_:int = Math.ceil(param4 / (_loc8_ + this._gap)) + 1;
         if(!this._hasVariableItemDimensions)
         {
            _loc23_ = param5 * (_loc8_ + this._gap) - this._gap;
            if(_loc9_ && param5 > 1)
            {
               _loc23_ = _loc23_ - this._gap + this._firstGap;
            }
            if(_loc10_ && param5 > 2)
            {
               _loc23_ = _loc23_ - this._gap + this._lastGap;
            }
            _loc24_ = 0;
            if(_loc23_ < param4)
            {
               if(this._verticalAlign == VerticalAlign.BOTTOM)
               {
                  _loc24_ = Math.ceil((param4 - _loc23_) / (_loc8_ + this._gap));
               }
               else if(this._verticalAlign == VerticalAlign.MIDDLE)
               {
                  _loc24_ = Math.ceil((param4 - _loc23_) / (_loc8_ + this._gap) / 2);
               }
            }
            _loc25_ = (param2 - this._paddingTop) / (_loc8_ + this._gap);
            if(_loc25_ < 0)
            {
               _loc25_ = 0;
            }
            _loc25_ -= _loc24_;
            _loc26_ = _loc25_ + _loc12_;
            if(_loc26_ >= param5)
            {
               _loc26_ = param5 - 1;
            }
            _loc25_ = _loc26_ - _loc12_;
            if(_loc25_ < 0)
            {
               _loc25_ = 0;
            }
            _loc27_ = _loc25_;
            while(_loc27_ <= _loc26_)
            {
               if(_loc27_ >= 0 && _loc27_ < param5)
               {
                  param6[_loc11_] = _loc27_;
               }
               else if(_loc27_ < 0)
               {
                  param6[_loc11_] = param5 + _loc27_;
               }
               else if(_loc27_ >= param5)
               {
                  param6[_loc11_] = _loc27_ - param5;
               }
               _loc11_++;
               _loc27_++;
            }
            return param6;
         }
         var _loc13_:int = -1;
         var _loc14_:int = -1;
         var _loc15_:int = 0;
         if(Boolean(this._headerIndices) && this._stickyHeader)
         {
            _loc15_ = int(this._headerIndices.length);
            if(_loc15_ > 0)
            {
               _loc13_ = 0;
               _loc14_ = this._headerIndices[_loc13_];
            }
         }
         var _loc16_:int = param5 - 2;
         var _loc17_:Number = param2 + param4;
         var _loc18_:Number = this._paddingTop;
         var _loc19_:Boolean = false;
         var _loc20_:Number = _loc18_;
         _loc27_ = 0;
         while(_loc27_ < param5)
         {
            if(_loc14_ == _loc27_)
            {
               if(_loc20_ < param2)
               {
                  if(++_loc13_ < _loc15_)
                  {
                     _loc14_ = this._headerIndices[_loc13_];
                  }
               }
               else if(--_loc13_ >= 0)
               {
                  _loc14_ = this._headerIndices[_loc13_];
                  _loc19_ = true;
               }
            }
            _loc28_ = this._gap;
            if(_loc9_ && _loc27_ == 0)
            {
               _loc28_ = this._firstGap;
            }
            else if(_loc10_ && _loc27_ > 0 && _loc27_ == _loc16_)
            {
               _loc28_ = this._lastGap;
            }
            _loc29_ = Number(this._virtualCache[_loc27_]);
            if(_loc29_ !== _loc29_)
            {
               _loc31_ = _loc8_;
            }
            else
            {
               _loc31_ = _loc29_;
            }
            _loc30_ = _loc20_;
            _loc20_ += _loc31_ + _loc28_;
            if(_loc20_ > param2 && _loc30_ < _loc17_)
            {
               param6[_loc11_] = _loc27_;
               _loc11_++;
            }
            if(_loc20_ >= _loc17_)
            {
               if(!_loc19_)
               {
                  if(--_loc13_ >= 0)
                  {
                     _loc14_ = this._headerIndices[_loc13_];
                  }
               }
               break;
            }
            _loc27_++;
         }
         if(_loc14_ >= 0 && param6.indexOf(_loc14_) < 0)
         {
            _loc32_ = false;
            _loc27_ = 0;
            while(_loc27_ < _loc11_)
            {
               if(_loc14_ <= param6[_loc27_])
               {
                  param6.insertAt(_loc27_,_loc14_);
                  _loc32_ = true;
                  break;
               }
               _loc27_++;
            }
            if(!_loc32_)
            {
               param6[_loc11_] = _loc14_;
            }
            _loc11_++;
         }
         var _loc21_:int = int(param6.length);
         var _loc22_:int = _loc12_ - _loc21_;
         if(_loc22_ > 0 && _loc21_ > 0)
         {
            _loc33_ = param6[0];
            _loc34_ = _loc33_ - _loc22_;
            if(_loc34_ < 0)
            {
               _loc34_ = 0;
            }
            _loc27_ = int(_loc33_ - 1);
            while(_loc27_ >= _loc34_)
            {
               if(_loc27_ != _loc14_)
               {
                  param6.insertAt(0,_loc27_);
               }
               _loc27_--;
            }
         }
         _loc21_ = int(param6.length);
         _loc22_ = _loc12_ - _loc21_;
         _loc11_ = _loc21_;
         if(_loc22_ > 0)
         {
            _loc35_ = _loc21_ > 0 ? int(param6[_loc21_ - 1] + 1) : 0;
            _loc36_ = _loc35_ + _loc22_;
            if(_loc36_ > param5)
            {
               _loc36_ = param5;
            }
            _loc27_ = _loc35_;
            while(_loc27_ < _loc36_)
            {
               if(_loc27_ != _loc14_)
               {
                  param6[_loc11_] = _loc27_;
                  _loc11_++;
               }
               _loc27_++;
            }
         }
         return param6;
      }
      
      public function getNearestScrollPositionForIndex(param1:int, param2:Number, param3:Number, param4:Vector.<DisplayObject>, param5:Number, param6:Number, param7:Number, param8:Number, param9:Point = null) : Point
      {
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc10_:Point = Pool.getPoint();
         this.calculateScrollRangeOfIndex(param1,param4,param5,param6,param7,param8,_loc10_);
         var _loc11_:Number = _loc10_.x;
         var _loc12_:Number = _loc10_.y;
         var _loc13_:Number = _loc12_ - _loc11_;
         Pool.putPoint(_loc10_);
         if(this._useVirtualLayout)
         {
            if(this._hasVariableItemDimensions)
            {
               _loc15_ = Number(this._virtualCache[param1]);
               if(_loc15_ !== _loc15_)
               {
                  _loc15_ = this._typicalItem.height;
               }
            }
            else
            {
               _loc15_ = this._typicalItem.height;
            }
         }
         else
         {
            _loc15_ = param4[param1].height;
         }
         if(!param9)
         {
            param9 = new Point();
         }
         param9.x = 0;
         var _loc14_:Number = _loc12_ - (_loc13_ - _loc15_);
         if(param3 >= _loc14_ && param3 <= _loc12_)
         {
            param9.y = param3;
         }
         else
         {
            _loc16_ = Math.abs(_loc12_ - param3);
            _loc17_ = Math.abs(_loc14_ - param3);
            if(_loc17_ < _loc16_)
            {
               param9.y = _loc14_;
            }
            else
            {
               param9.y = _loc12_;
            }
         }
         return param9;
      }
      
      public function calculateNavigationDestination(param1:Vector.<DisplayObject>, param2:int, param3:uint, param4:LayoutBoundsResult) : int
      {
         var _loc9_:Number = NaN;
         var _loc10_:int = 0;
         var _loc11_:Number = NaN;
         var _loc12_:* = 0;
         var _loc13_:int = 0;
         var _loc14_:Number = NaN;
         var _loc15_:DisplayObject = null;
         var _loc5_:int = int(param1.length);
         var _loc6_:int = _loc5_ + this._beforeVirtualizedItemCount + this._afterVirtualizedItemCount;
         if(this._useVirtualLayout)
         {
            this.prepareTypicalItem(param4.viewPortWidth - this._paddingLeft - this._paddingRight);
            _loc9_ = this._typicalItem ? this._typicalItem.height : 0;
         }
         var _loc7_:Boolean = false;
         var _loc8_:* = param2;
         if(param3 == Keyboard.HOME)
         {
            _loc7_ = true;
            if(_loc6_ > 0)
            {
               _loc8_ = 0;
            }
         }
         else if(param3 == Keyboard.END)
         {
            _loc8_ = int(_loc6_ - 1);
         }
         else if(param3 == Keyboard.PAGE_UP)
         {
            _loc7_ = true;
            _loc10_ = 0;
            if(this._useVirtualLayout && this._hasVariableItemDimensions)
            {
               _loc10_ = -this._beforeVirtualizedItemCount;
            }
            _loc11_ = 0;
            _loc12_ = param2;
            while(_loc12_ >= 0)
            {
               _loc13_ = _loc12_ + _loc10_;
               if(this._useVirtualLayout && this._hasVariableItemDimensions)
               {
                  _loc14_ = Number(this._virtualCache[_loc12_]);
               }
               if(_loc13_ < 0 || _loc13_ >= _loc5_)
               {
                  if(_loc14_ === _loc14_)
                  {
                     _loc11_ += _loc14_;
                  }
                  else
                  {
                     _loc11_ += _loc9_;
                  }
               }
               else
               {
                  _loc15_ = param1[_loc13_];
                  if(_loc15_ === null)
                  {
                     if(_loc14_ === _loc14_)
                     {
                        _loc11_ += _loc14_;
                     }
                     else
                     {
                        _loc11_ += _loc9_;
                     }
                  }
                  else
                  {
                     _loc11_ += _loc15_.height;
                  }
               }
               if(_loc11_ > param4.viewPortHeight)
               {
                  break;
               }
               _loc11_ += this._gap;
               _loc8_ = int(_loc12_);
               _loc12_--;
            }
         }
         else if(param3 == Keyboard.PAGE_DOWN)
         {
            _loc11_ = 0;
            _loc10_ = 0;
            if(this._useVirtualLayout && this._hasVariableItemDimensions)
            {
               _loc10_ = -this._beforeVirtualizedItemCount;
            }
            _loc12_ = param2;
            while(_loc12_ < _loc6_)
            {
               _loc13_ = _loc12_ + _loc10_;
               if(this._useVirtualLayout && this._hasVariableItemDimensions)
               {
                  _loc14_ = Number(this._virtualCache[_loc12_]);
               }
               if(_loc13_ < 0 || _loc13_ >= _loc5_)
               {
                  if(_loc14_ === _loc14_)
                  {
                     _loc11_ += _loc14_;
                  }
                  else
                  {
                     _loc11_ += _loc9_;
                  }
               }
               else
               {
                  _loc15_ = param1[_loc13_];
                  if(_loc15_ === null)
                  {
                     if(_loc14_ === _loc14_)
                     {
                        _loc11_ += _loc14_;
                     }
                     else
                     {
                        _loc11_ += _loc9_;
                     }
                  }
                  else
                  {
                     _loc11_ += _loc15_.height;
                  }
               }
               if(_loc11_ > param4.viewPortHeight)
               {
                  break;
               }
               _loc11_ += this._gap;
               _loc8_ = int(_loc12_);
               _loc12_++;
            }
         }
         else if(param3 == Keyboard.UP)
         {
            _loc7_ = true;
            _loc8_--;
         }
         else if(param3 == Keyboard.DOWN)
         {
            _loc8_++;
         }
         if(_loc8_ < 0)
         {
            _loc8_ = 0;
         }
         if(_loc8_ >= _loc6_)
         {
            _loc8_ = int(_loc6_ - 1);
         }
         while(this._headerIndices !== null && this._headerIndices.indexOf(_loc8_) != -1)
         {
            if(_loc7_)
            {
               if(_loc8_ == 0)
               {
                  _loc7_ = false;
                  _loc8_++;
               }
               else
               {
                  _loc8_--;
               }
            }
            else
            {
               _loc8_++;
            }
         }
         return _loc8_;
      }
      
      public function getScrollPositionForIndex(param1:int, param2:Vector.<DisplayObject>, param3:Number, param4:Number, param5:Number, param6:Number, param7:Point = null) : Point
      {
         var _loc13_:Number = NaN;
         var _loc8_:Point = Pool.getPoint();
         this.calculateScrollRangeOfIndex(param1,param2,param3,param4,param5,param6,_loc8_);
         var _loc9_:Number = _loc8_.x;
         var _loc10_:Number = _loc8_.y;
         var _loc11_:Number = _loc10_ - _loc9_;
         Pool.putPoint(_loc8_);
         if(this._useVirtualLayout)
         {
            if(this._hasVariableItemDimensions)
            {
               _loc13_ = Number(this._virtualCache[param1]);
               if(_loc13_ !== _loc13_)
               {
                  _loc13_ = this._typicalItem.height;
               }
            }
            else
            {
               _loc13_ = this._typicalItem.height;
            }
         }
         else
         {
            _loc13_ = param2[param1].height;
         }
         if(!param7)
         {
            param7 = new Point();
         }
         param7.x = 0;
         var _loc12_:String = this._scrollPositionVerticalAlign;
         if(this._headerIndices !== null && this._headerIndices.indexOf(param1) != -1)
         {
            _loc12_ = this._headerScrollPositionVerticalAlign;
         }
         switch(_loc12_)
         {
            case VerticalAlign.MIDDLE:
               _loc10_ -= Math.round((_loc11_ - _loc13_) / 2);
               break;
            case VerticalAlign.BOTTOM:
               _loc10_ -= _loc11_ - _loc13_;
         }
         param7.y = _loc10_;
         return param7;
      }
      
      public function positionDropIndicator(param1:DisplayObject, param2:int, param3:Number, param4:Number, param5:Vector.<DisplayObject>, param6:Number, param7:Number) : void
      {
         var _loc13_:DisplayObject = null;
         var _loc8_:int = 0;
         var _loc9_:int;
         var _loc10_:int = _loc9_ = int(param5.length);
         if(this._useVirtualLayout && !this._hasVariableItemDimensions)
         {
            _loc10_ += this._beforeVirtualizedItemCount + this._afterVirtualizedItemCount;
            _loc8_ = this._beforeVirtualizedItemCount;
         }
         var _loc11_:int = param2 - _loc8_;
         if(param1 is IValidating)
         {
            IValidating(param1).validate();
         }
         var _loc12_:Number = 0;
         if(param2 < _loc10_)
         {
            _loc13_ = param5[_loc11_];
            _loc12_ = _loc13_.y - param1.height / 2;
            param1.x = _loc13_.x;
            param1.width = _loc13_.width;
         }
         else
         {
            _loc13_ = param5[_loc11_ - 1];
            _loc12_ = _loc13_.y + _loc13_.height - param1.height;
            param1.x = _loc13_.x;
            param1.width = _loc13_.width;
         }
         if(_loc12_ < 0)
         {
            _loc12_ = 0;
         }
         param1.y = _loc12_;
      }
      
      public function getDropIndex(param1:Number, param2:Number, param3:Vector.<DisplayObject>, param4:Number, param5:Number, param6:Number, param7:Number) : int
      {
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:DisplayObject = null;
         var _loc21_:int = 0;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         if(this._useVirtualLayout)
         {
            this.prepareTypicalItem(param6 - this._paddingLeft - this._paddingRight);
            _loc18_ = this._typicalItem ? this._typicalItem.width : 0;
            _loc19_ = this._typicalItem ? this._typicalItem.height : 0;
         }
         var _loc8_:Boolean = this._firstGap === this._firstGap;
         var _loc9_:Boolean = this._lastGap === this._lastGap;
         var _loc10_:Number = param5 + this._paddingTop;
         var _loc11_:Number = 0;
         var _loc12_:Number = this._gap;
         var _loc13_:int = 0;
         var _loc14_:int;
         var _loc15_:int = _loc14_ = int(param3.length);
         if(this._useVirtualLayout && !this._hasVariableItemDimensions)
         {
            _loc15_ += this._beforeVirtualizedItemCount + this._afterVirtualizedItemCount;
            _loc13_ = this._beforeVirtualizedItemCount;
         }
         var _loc16_:int = _loc15_ - 2;
         var _loc17_:int = 0;
         while(_loc17_ <= _loc15_)
         {
            _loc20_ = null;
            _loc21_ = _loc17_ - _loc13_;
            if(_loc21_ >= 0 && _loc21_ < _loc14_)
            {
               _loc20_ = param3[_loc21_];
            }
            if(_loc8_ && _loc17_ == 0)
            {
               _loc12_ = this._firstGap;
            }
            else if(_loc9_ && _loc17_ > 0 && _loc17_ == _loc16_)
            {
               _loc12_ = this._lastGap;
            }
            else
            {
               _loc12_ = this._gap;
            }
            if(this._useVirtualLayout && this._hasVariableItemDimensions)
            {
               _loc22_ = Number(this._virtualCache[_loc17_]);
            }
            if(this._useVirtualLayout && !_loc20_)
            {
               if(!this._hasVariableItemDimensions || _loc22_ !== _loc22_)
               {
                  _loc11_ = _loc19_;
               }
               else
               {
                  _loc11_ = _loc22_;
               }
            }
            else
            {
               _loc10_ = _loc20_.y;
               _loc23_ = _loc20_.height;
               if(this._useVirtualLayout)
               {
                  if(this._hasVariableItemDimensions)
                  {
                     if(_loc23_ != _loc22_)
                     {
                        this._virtualCache[_loc17_] = _loc23_;
                        this.dispatchEventWith(Event.CHANGE);
                     }
                  }
                  else if(_loc19_ >= 0)
                  {
                     _loc23_ = _loc19_;
                  }
               }
               _loc11_ = _loc23_;
            }
            if(param2 < _loc10_ + _loc11_ / 2)
            {
               return _loc17_;
            }
            _loc10_ += _loc11_ + _loc12_;
            _loc17_++;
         }
         return _loc15_;
      }
      
      protected function validateItems(param1:Vector.<DisplayObject>, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : void
      {
         var _loc14_:DisplayObject = null;
         var _loc15_:IFeathersControl = null;
         var _loc16_:ILayoutDisplayObject = null;
         var _loc17_:VerticalLayoutData = null;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:IMeasureDisplayObject = null;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc9_:Boolean = param5 !== param5;
         var _loc10_:Number = param5;
         if(_loc9_)
         {
            _loc10_ = param6;
         }
         var _loc11_:Boolean = this._horizontalAlign == HorizontalAlign.JUSTIFY;
         var _loc12_:int = int(param1.length);
         var _loc13_:int = 0;
         while(_loc13_ < _loc12_)
         {
            _loc14_ = param1[_loc13_];
            if(!(!_loc14_ || _loc14_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc14_).includeInLayout))
            {
               if(_loc11_)
               {
                  _loc14_.width = param2;
                  if(_loc14_ is IFeathersControl)
                  {
                     _loc15_ = IFeathersControl(_loc14_);
                     _loc15_.minWidth = param3;
                     _loc15_.maxWidth = param4;
                  }
               }
               else if(_loc14_ is ILayoutDisplayObject)
               {
                  _loc16_ = ILayoutDisplayObject(_loc14_);
                  _loc17_ = _loc16_.layoutData as VerticalLayoutData;
                  if(_loc17_ !== null)
                  {
                     _loc18_ = _loc17_.percentWidth;
                     _loc19_ = _loc17_.percentHeight;
                     if(_loc18_ === _loc18_)
                     {
                        if(_loc18_ < 0)
                        {
                           _loc18_ = 0;
                        }
                        if(_loc18_ > 100)
                        {
                           _loc18_ = 100;
                        }
                        _loc20_ = param2 * _loc18_ / 100;
                        _loc21_ = IMeasureDisplayObject(_loc14_);
                        _loc22_ = _loc21_.explicitMinWidth;
                        if(_loc21_.explicitMinWidth === _loc21_.explicitMinWidth && _loc20_ < _loc22_)
                        {
                           _loc20_ = _loc22_;
                        }
                        if(_loc20_ > param4)
                        {
                           _loc20_ = param4;
                        }
                        _loc14_.width = _loc20_;
                        if(_loc21_.explicitWidth !== _loc21_.explicitWidth && _loc21_.maxWidth > param4)
                        {
                           _loc21_.maxWidth = param4;
                        }
                     }
                     if(_loc19_ === _loc19_)
                     {
                        _loc23_ = _loc10_ * _loc19_ / 100;
                        _loc21_ = IMeasureDisplayObject(_loc14_);
                        _loc24_ = _loc21_.explicitMinHeight;
                        if(_loc21_.explicitMinHeight === _loc21_.explicitMinHeight && _loc23_ < _loc24_)
                        {
                           _loc23_ = _loc24_;
                        }
                        _loc21_.maxHeight = _loc23_;
                        _loc14_.height = NaN;
                     }
                  }
               }
               if(this._distributeHeights)
               {
                  _loc14_.height = param8;
               }
               if(_loc14_ is IValidating)
               {
                  IValidating(_loc14_).validate();
               }
            }
            _loc13_++;
         }
      }
      
      protected function prepareTypicalItem(param1:Number) : void
      {
         var _loc3_:ILayoutDisplayObject = null;
         var _loc4_:VerticalLayoutData = null;
         var _loc5_:Number = NaN;
         if(!this._typicalItem)
         {
            return;
         }
         var _loc2_:Boolean = false;
         if(this._horizontalAlign == HorizontalAlign.JUSTIFY && param1 === param1)
         {
            _loc2_ = true;
            this._typicalItem.width = param1;
         }
         else if(this._typicalItem is ILayoutDisplayObject)
         {
            _loc3_ = ILayoutDisplayObject(this._typicalItem);
            _loc4_ = _loc3_.layoutData as VerticalLayoutData;
            if(_loc4_ !== null)
            {
               _loc5_ = _loc4_.percentWidth;
               if(_loc5_ === _loc5_)
               {
                  if(_loc5_ < 0)
                  {
                     _loc5_ = 0;
                  }
                  if(_loc5_ > 100)
                  {
                     _loc5_ = 100;
                  }
                  _loc2_ = true;
                  this._typicalItem.width = param1 * _loc5_ / 100;
               }
            }
         }
         if(!_loc2_ && this._resetTypicalItemDimensionsOnMeasure)
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
      
      protected function calculateDistributedHeight(param1:Vector.<DisplayObject>, param2:Number, param3:Number, param4:Number, param5:Boolean) : Number
      {
         var _loc12_:DisplayObject = null;
         var _loc13_:Number = NaN;
         var _loc14_:Boolean = false;
         var _loc6_:Boolean = param2 !== param2;
         var _loc7_:int = 0;
         var _loc8_:Number = 0;
         var _loc9_:int = int(param1.length);
         var _loc10_:int = 0;
         while(_loc10_ < _loc9_)
         {
            _loc12_ = param1[_loc10_];
            if(!(_loc12_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc12_).includeInLayout))
            {
               _loc7_++;
               _loc13_ = _loc12_.height;
               if(_loc13_ > _loc8_)
               {
                  _loc8_ = _loc13_;
               }
            }
            _loc10_++;
         }
         if(param5 && _loc6_)
         {
            param2 = _loc8_ * _loc7_ + this._paddingTop + this._paddingBottom + this._gap * (_loc7_ - 1);
            _loc14_ = false;
            if(param2 > param4)
            {
               param2 = param4;
               _loc14_ = true;
            }
            else if(param2 < param3)
            {
               param2 = param3;
               _loc14_ = true;
            }
            if(!_loc14_)
            {
               return _loc8_;
            }
         }
         var _loc11_:Number = param2;
         if(_loc6_ && param4 < Number.POSITIVE_INFINITY)
         {
            _loc11_ = param4;
         }
         _loc11_ = _loc11_ - this._paddingTop - this._paddingBottom - this._gap * (_loc7_ - 1);
         if(_loc7_ > 1 && this._firstGap === this._firstGap)
         {
            _loc11_ += this._gap - this._firstGap;
         }
         if(_loc7_ > 2 && this._lastGap === this._lastGap)
         {
            _loc11_ += this._gap - this._lastGap;
         }
         return _loc11_ / _loc7_;
      }
      
      protected function applyPercentHeights(param1:Vector.<DisplayObject>, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc12_:DisplayObject = null;
         var _loc13_:ILayoutDisplayObject = null;
         var _loc14_:VerticalLayoutData = null;
         var _loc15_:Number = NaN;
         var _loc16_:IFeathersControl = null;
         var _loc17_:Boolean = false;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc5_:Number = param2;
         this._discoveredItemsCache.length = 0;
         var _loc6_:Number = 0;
         var _loc7_:Number = 0;
         var _loc8_:Number = 0;
         var _loc9_:int = int(param1.length);
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         for(; _loc11_ < _loc9_; _loc11_++)
         {
            _loc12_ = param1[_loc11_];
            if(_loc12_ is ILayoutDisplayObject)
            {
               _loc13_ = ILayoutDisplayObject(_loc12_);
               if(!_loc13_.includeInLayout)
               {
                  continue;
               }
               _loc14_ = _loc13_.layoutData as VerticalLayoutData;
               if(_loc14_)
               {
                  _loc15_ = _loc14_.percentHeight;
                  if(_loc15_ === _loc15_)
                  {
                     if(_loc15_ < 0)
                     {
                        _loc15_ = 0;
                     }
                     if(_loc13_ is IFeathersControl)
                     {
                        _loc16_ = IFeathersControl(_loc13_);
                        _loc7_ += _loc16_.minHeight;
                     }
                     _loc8_ += _loc15_;
                     _loc6_ += this._gap;
                     this._discoveredItemsCache[_loc10_] = _loc12_;
                     _loc10_++;
                     continue;
                  }
               }
            }
            _loc6_ += _loc12_.height + this._gap;
         }
         _loc6_ -= this._gap;
         if(this._firstGap === this._firstGap && _loc9_ > 1)
         {
            _loc6_ += this._firstGap - this._gap;
         }
         else if(this._lastGap === this._lastGap && _loc9_ > 2)
         {
            _loc6_ += this._lastGap - this._gap;
         }
         _loc6_ += this._paddingTop + this._paddingBottom;
         if(_loc8_ < 100)
         {
            _loc8_ = 100;
         }
         if(_loc5_ !== _loc5_)
         {
            _loc5_ = _loc6_ + _loc7_;
            if(_loc5_ < param3)
            {
               _loc5_ = param3;
            }
            else if(_loc5_ > param4)
            {
               _loc5_ = param4;
            }
         }
         _loc5_ -= _loc6_;
         if(_loc5_ < 0)
         {
            _loc5_ = 0;
         }
         do
         {
            _loc17_ = false;
            _loc18_ = _loc5_ / _loc8_;
            _loc11_ = 0;
            while(_loc11_ < _loc10_)
            {
               _loc13_ = ILayoutDisplayObject(this._discoveredItemsCache[_loc11_]);
               if(_loc13_)
               {
                  _loc14_ = VerticalLayoutData(_loc13_.layoutData);
                  _loc15_ = _loc14_.percentHeight;
                  if(_loc15_ < 0)
                  {
                     _loc15_ = 0;
                  }
                  _loc19_ = _loc18_ * _loc15_;
                  if(_loc13_ is IFeathersControl)
                  {
                     _loc16_ = IFeathersControl(_loc13_);
                     _loc20_ = Number(_loc16_.explicitMinHeight);
                     if(_loc20_ > _loc5_)
                     {
                        _loc20_ = _loc5_;
                     }
                     if(_loc19_ < _loc20_)
                     {
                        _loc19_ = _loc20_;
                        _loc5_ -= _loc19_;
                        _loc8_ -= _loc15_;
                        this._discoveredItemsCache[_loc11_] = null;
                        _loc17_ = true;
                     }
                  }
                  _loc13_.height = _loc19_;
                  if(_loc13_ is IValidating)
                  {
                     IValidating(_loc13_).validate();
                  }
               }
               _loc11_++;
            }
         }
         while(_loc17_);
         this._discoveredItemsCache.length = 0;
      }
      
      protected function calculateScrollRangeOfIndex(param1:int, param2:Vector.<DisplayObject>, param3:Number, param4:Number, param5:Number, param6:Number, param7:Point) : void
      {
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:DisplayObject = null;
         var _loc26_:int = 0;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         if(this._useVirtualLayout)
         {
            this.prepareTypicalItem(param5 - this._paddingLeft - this._paddingRight);
            _loc23_ = this._typicalItem ? this._typicalItem.width : 0;
            _loc24_ = this._typicalItem ? this._typicalItem.height : 0;
         }
         var _loc8_:int = -1;
         var _loc9_:int = -1;
         var _loc10_:int = 0;
         var _loc11_:Number = 0;
         if(Boolean(this._headerIndices) && this._stickyHeader)
         {
            _loc10_ = int(this._headerIndices.length);
            if(_loc10_ > 0)
            {
               _loc8_ = 0;
               _loc9_ = this._headerIndices[_loc8_];
            }
         }
         var _loc12_:Boolean = this._firstGap === this._firstGap;
         var _loc13_:Boolean = this._lastGap === this._lastGap;
         var _loc14_:Number = param4 + this._paddingTop;
         var _loc15_:Number = 0;
         var _loc16_:Number = this._gap;
         var _loc17_:int = 0;
         var _loc18_:Number = 0;
         var _loc19_:int;
         var _loc20_:int = _loc19_ = int(param2.length);
         if(this._useVirtualLayout && !this._hasVariableItemDimensions)
         {
            _loc20_ += this._beforeVirtualizedItemCount + this._afterVirtualizedItemCount;
            if(param1 < this._beforeVirtualizedItemCount)
            {
               _loc17_ = param1 + 1;
               _loc15_ = _loc24_;
               _loc16_ = this._gap;
            }
            else
            {
               _loc17_ = this._beforeVirtualizedItemCount;
               _loc18_ = param1 - param2.length - this._beforeVirtualizedItemCount + 1;
               if(_loc18_ < 0)
               {
                  _loc18_ = 0;
               }
               _loc14_ += _loc18_ * (_loc24_ + this._gap);
            }
            _loc14_ += _loc17_ * (_loc24_ + this._gap);
         }
         param1 -= _loc17_ + _loc18_;
         var _loc21_:int = _loc20_ - 2;
         var _loc22_:int = 0;
         while(_loc22_ <= param1)
         {
            _loc25_ = param2[_loc22_];
            _loc26_ = _loc22_ + _loc17_;
            if(_loc12_ && _loc26_ == 0)
            {
               _loc16_ = this._firstGap;
            }
            else if(_loc13_ && _loc26_ > 0 && _loc26_ == _loc21_)
            {
               _loc16_ = this._lastGap;
            }
            else
            {
               _loc16_ = this._gap;
            }
            if(this._useVirtualLayout && this._hasVariableItemDimensions)
            {
               _loc27_ = Number(this._virtualCache[_loc26_]);
            }
            if(this._useVirtualLayout && !_loc25_)
            {
               if(!this._hasVariableItemDimensions || _loc27_ !== _loc27_)
               {
                  _loc15_ = _loc24_;
               }
               else
               {
                  _loc15_ = _loc27_;
               }
            }
            else
            {
               _loc28_ = _loc25_.height;
               if(this._useVirtualLayout)
               {
                  if(this._hasVariableItemDimensions)
                  {
                     if(_loc28_ != _loc27_)
                     {
                        this._virtualCache[_loc26_] = _loc28_;
                        this.dispatchEventWith(Event.CHANGE);
                     }
                  }
                  else if(_loc24_ >= 0)
                  {
                     _loc25_.height = _loc28_ = _loc24_;
                  }
               }
               _loc15_ = _loc28_;
            }
            _loc14_ += _loc15_ + _loc16_;
            if(_loc9_ == _loc26_)
            {
               _loc11_ = _loc15_;
               if(++_loc8_ < _loc10_)
               {
                  _loc9_ = this._headerIndices[_loc8_];
               }
            }
            _loc22_++;
         }
         _loc14_ -= _loc15_ + _loc16_;
         param7.x = _loc14_ - param6;
         if(this._stickyHeader && this._headerIndices !== null && this._headerIndices.indexOf(param1) == -1)
         {
            _loc14_ -= _loc11_;
         }
         param7.y = _loc14_;
      }
      
      protected function positionStickyHeader(param1:DisplayObject, param2:Number, param3:Number) : void
      {
         if(!param1 || param1.y >= param2)
         {
            return;
         }
         if(param1 is IValidating)
         {
            IValidating(param1).validate();
         }
         param3 -= param1.height;
         if(param3 > param2)
         {
            param3 = param2;
         }
         param1.y = param3;
         var _loc4_:DisplayObjectContainer = param1.parent;
         if(_loc4_)
         {
            _loc4_.setChildIndex(param1,_loc4_.numChildren - 1);
         }
      }
   }
}

