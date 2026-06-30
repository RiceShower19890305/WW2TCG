package feathers.layout
{
   import feathers.core.IFeathersControl;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.IValidating;
   import flash.errors.IllegalOperationError;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import starling.display.DisplayObject;
   import starling.events.Event;
   
   public class HorizontalLayout extends BaseLinearLayout implements IVariableVirtualLayout, ITrimmedVirtualLayout, IDragDropLayout
   {
      
      protected var _distributeWidths:Boolean = false;
      
      protected var _requestedColumnCount:int = 0;
      
      protected var _maxColumnCount:int = 0;
      
      protected var _scrollPositionHorizontalAlign:String = "center";
      
      public function HorizontalLayout()
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
      
      public function get distributeWidths() : Boolean
      {
         return this._distributeWidths;
      }
      
      public function set distributeWidths(param1:Boolean) : void
      {
         if(this._distributeWidths == param1)
         {
            return;
         }
         this._distributeWidths = param1;
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
      
      public function get maxColumnCount() : int
      {
         return this._maxColumnCount;
      }
      
      public function set maxColumnCount(param1:int) : void
      {
         if(param1 < 0)
         {
            throw RangeError("maxColumnCount requires a value >= 0");
         }
         if(this._maxColumnCount == param1)
         {
            return;
         }
         this._maxColumnCount = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get scrollPositionHorizontalAlign() : String
      {
         return this._scrollPositionHorizontalAlign;
      }
      
      public function set scrollPositionHorizontalAlign(param1:String) : void
      {
         this._scrollPositionHorizontalAlign = param1;
      }
      
      public function layout(param1:Vector.<DisplayObject>, param2:ViewPortBounds = null, param3:LayoutBoundsResult = null) : LayoutBoundsResult
      {
         var _loc16_:Number = NaN;
         var _loc37_:Number = NaN;
         var _loc38_:Number = NaN;
         var _loc39_:DisplayObject = null;
         var _loc40_:int = 0;
         var _loc41_:Number = NaN;
         var _loc42_:ILayoutDisplayObject = null;
         var _loc43_:Number = NaN;
         var _loc44_:Number = NaN;
         var _loc45_:Number = NaN;
         var _loc46_:Number = NaN;
         var _loc47_:Number = NaN;
         var _loc48_:Number = NaN;
         var _loc49_:HorizontalLayoutData = null;
         var _loc50_:Number = NaN;
         var _loc51_:IFeathersControl = null;
         var _loc52_:Number = NaN;
         var _loc53_:Number = NaN;
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
            this.prepareTypicalItem(_loc13_ - this._paddingTop - this._paddingBottom);
            _loc37_ = this._typicalItem ? this._typicalItem.width : 0;
            _loc38_ = this._typicalItem ? this._typicalItem.height : 0;
         }
         var _loc14_:Boolean = _loc12_ !== _loc12_;
         var _loc15_:Boolean = _loc13_ !== _loc13_;
         if(!_loc14_ && this._distributeWidths)
         {
            _loc16_ = this.calculateDistributedWidth(param1,_loc12_,_loc8_,_loc10_,false);
            if(this._useVirtualLayout)
            {
               _loc37_ = _loc16_;
            }
         }
         if(!this._useVirtualLayout || this._hasVariableItemDimensions || this._distributeWidths || this._verticalAlign != VerticalAlign.JUSTIFY || _loc15_)
         {
            this.validateItems(param1,_loc13_ - this._paddingTop - this._paddingBottom,_loc9_ - this._paddingTop - this._paddingBottom,_loc11_ - this._paddingTop - this._paddingBottom,_loc12_ - this._paddingLeft - this._paddingRight,_loc8_ - this._paddingLeft - this._paddingRight,_loc10_ - this._paddingLeft - this._paddingRight,_loc16_);
         }
         if(_loc14_ && this._distributeWidths)
         {
            _loc16_ = this.calculateDistributedWidth(param1,_loc12_,_loc8_,_loc10_,true);
         }
         var _loc17_:Boolean = _loc16_ === _loc16_;
         if(!this._useVirtualLayout)
         {
            this.applyPercentWidths(param1,_loc12_,_loc8_,_loc10_);
         }
         var _loc18_:Boolean = this._firstGap === this._firstGap;
         var _loc19_:Boolean = this._lastGap === this._lastGap;
         var _loc20_:Number = this._useVirtualLayout ? _loc38_ : 0;
         var _loc21_:Number = _loc6_ + this._paddingLeft;
         var _loc22_:int;
         var _loc23_:int = _loc22_ = int(param1.length);
         var _loc24_:Number = 0;
         var _loc25_:Number = Number.POSITIVE_INFINITY;
         if(this._useVirtualLayout && !this._hasVariableItemDimensions)
         {
            _loc23_ += this._beforeVirtualizedItemCount + this._afterVirtualizedItemCount;
            _loc21_ += this._beforeVirtualizedItemCount * (_loc37_ + this._gap);
            if(_loc18_ && this._beforeVirtualizedItemCount > 0)
            {
               _loc21_ = _loc21_ - this._gap + this._firstGap;
            }
         }
         var _loc26_:int = _loc23_ - 2;
         this._discoveredItemsCache.length = 0;
         var _loc27_:int = 0;
         var _loc28_:Number = 0;
         var _loc29_:int = 0;
         while(_loc29_ < _loc22_)
         {
            if(!this._useVirtualLayout)
            {
               if(this._maxColumnCount > 0 && this._maxColumnCount == _loc29_)
               {
                  _loc25_ = _loc21_;
               }
               if(this._requestedColumnCount > 0 && this._requestedColumnCount == _loc29_)
               {
                  _loc24_ = _loc21_;
               }
            }
            _loc39_ = param1[_loc29_];
            _loc40_ = _loc29_ + this._beforeVirtualizedItemCount;
            _loc28_ = this._gap;
            if(_loc18_ && _loc40_ == 0)
            {
               _loc28_ = this._firstGap;
            }
            else if(_loc19_ && _loc40_ > 0 && _loc40_ == _loc26_)
            {
               _loc28_ = this._lastGap;
            }
            if(this._useVirtualLayout && this._hasVariableItemDimensions)
            {
               _loc41_ = Number(this._virtualCache[_loc40_]);
            }
            if(this._useVirtualLayout && !_loc39_)
            {
               if(!this._hasVariableItemDimensions || _loc41_ !== _loc41_)
               {
                  _loc21_ += _loc37_ + _loc28_;
               }
               else
               {
                  _loc21_ += _loc41_ + _loc28_;
               }
            }
            else
            {
               _loc42_ = _loc39_ as ILayoutDisplayObject;
               if(!(_loc42_ !== null && !_loc42_.includeInLayout))
               {
                  _loc43_ = _loc39_.pivotX;
                  if(_loc43_ != 0)
                  {
                     _loc43_ *= _loc39_.scaleX;
                  }
                  _loc39_.x = _loc43_ + _loc21_;
                  if(_loc17_)
                  {
                     _loc39_.width = _loc44_ = _loc16_;
                  }
                  else
                  {
                     _loc44_ = _loc39_.width;
                  }
                  _loc45_ = _loc39_.height;
                  if(this._useVirtualLayout)
                  {
                     if(this._hasVariableItemDimensions)
                     {
                        if(_loc44_ != _loc41_)
                        {
                           this._virtualCache[_loc40_] = _loc44_;
                           if(_loc21_ < _loc4_ && _loc41_ !== _loc41_ && _loc44_ != _loc37_)
                           {
                              this.dispatchEventWith(Event.SCROLL,false,new Point(_loc44_ - _loc37_,0));
                           }
                           this.dispatchEventWith(Event.CHANGE);
                        }
                     }
                     else if(_loc37_ >= 0)
                     {
                        _loc44_ = _loc37_;
                        if(_loc39_ !== this._typicalItem || _loc39_.width != _loc44_)
                        {
                           _loc39_.width = _loc44_;
                        }
                     }
                  }
                  _loc21_ += _loc44_ + _loc28_;
                  if(_loc45_ > _loc20_)
                  {
                     _loc20_ = _loc45_;
                  }
                  if(this._useVirtualLayout)
                  {
                     this._discoveredItemsCache[_loc27_] = _loc39_;
                     _loc27_++;
                  }
               }
            }
            _loc29_++;
         }
         if(this._useVirtualLayout && !this._hasVariableItemDimensions)
         {
            _loc21_ += this._afterVirtualizedItemCount * (_loc37_ + this._gap);
            if(_loc19_ && this._afterVirtualizedItemCount > 0)
            {
               _loc21_ = _loc21_ - this._gap + this._lastGap;
            }
         }
         if(!this._useVirtualLayout && this._requestedColumnCount > _loc22_)
         {
            if(_loc22_ > 0)
            {
               _loc24_ = this._requestedColumnCount * _loc21_ / _loc22_;
            }
            else
            {
               _loc24_ = 0;
            }
         }
         var _loc30_:Vector.<DisplayObject> = this._useVirtualLayout ? this._discoveredItemsCache : param1;
         var _loc31_:int = int(_loc30_.length);
         var _loc32_:Number = _loc20_ + this._paddingTop + this._paddingBottom;
         var _loc33_:Number = _loc13_;
         if(_loc33_ !== _loc33_)
         {
            _loc33_ = _loc32_;
            if(_loc33_ < _loc9_)
            {
               _loc33_ = _loc9_;
            }
            else if(_loc33_ > _loc11_)
            {
               _loc33_ = _loc11_;
            }
         }
         var _loc34_:Number = _loc21_ - _loc28_ + this._paddingRight - _loc6_;
         var _loc35_:Number = _loc12_;
         if(_loc35_ !== _loc35_)
         {
            if(this._requestedColumnCount > 0)
            {
               if(this._useVirtualLayout)
               {
                  _loc35_ = (_loc37_ + this._gap) * this._requestedColumnCount - this._gap + this._paddingLeft + this._paddingRight;
               }
               else
               {
                  _loc35_ = _loc24_;
               }
            }
            else
            {
               _loc35_ = _loc34_;
               if(this._maxColumnCount > 0)
               {
                  if(this._useVirtualLayout)
                  {
                     _loc25_ = (_loc37_ + this._gap) * this._maxColumnCount - this._gap + this._paddingLeft + this._paddingRight;
                  }
                  if(_loc25_ < _loc35_)
                  {
                     _loc35_ = _loc25_;
                  }
               }
            }
            if(_loc35_ < _loc8_)
            {
               _loc35_ = _loc8_;
            }
            else if(_loc35_ > _loc10_)
            {
               _loc35_ = _loc10_;
            }
         }
         if(_loc34_ < _loc35_)
         {
            _loc46_ = 0;
            if(this._horizontalAlign == HorizontalAlign.RIGHT)
            {
               _loc46_ = _loc35_ - _loc34_;
            }
            else if(this._horizontalAlign == HorizontalAlign.CENTER)
            {
               _loc46_ = Math.round((_loc35_ - _loc34_) / 2);
            }
            if(_loc46_ != 0)
            {
               _loc29_ = 0;
               while(_loc29_ < _loc31_)
               {
                  _loc39_ = _loc30_[_loc29_];
                  if(!(_loc39_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc39_).includeInLayout))
                  {
                     _loc39_.x += _loc46_;
                  }
                  _loc29_++;
               }
            }
         }
         var _loc36_:Number = _loc33_ - this._paddingTop - this._paddingBottom;
         _loc29_ = 0;
         for(; _loc29_ < _loc31_; _loc29_++)
         {
            _loc39_ = _loc30_[_loc29_];
            _loc42_ = _loc39_ as ILayoutDisplayObject;
            if(_loc42_ !== null && !_loc42_.includeInLayout)
            {
               continue;
            }
            _loc47_ = _loc39_.pivotY;
            if(_loc47_ != 0)
            {
               _loc47_ *= _loc39_.scaleY;
            }
            if(this._verticalAlign == VerticalAlign.JUSTIFY)
            {
               _loc39_.y = _loc47_ + _loc7_ + this._paddingTop;
               _loc39_.height = _loc36_;
               continue;
            }
            if(_loc42_ !== null)
            {
               _loc49_ = _loc42_.layoutData as HorizontalLayoutData;
               if(_loc49_ !== null)
               {
                  _loc50_ = _loc49_.percentHeight;
                  if(_loc50_ === _loc50_)
                  {
                     if(_loc50_ < 0)
                     {
                        _loc50_ = 0;
                     }
                     if(_loc50_ > 100)
                     {
                        _loc50_ = 100;
                     }
                     _loc45_ = _loc50_ * _loc36_ / 100;
                     if(_loc39_ is IFeathersControl)
                     {
                        _loc51_ = IFeathersControl(_loc39_);
                        _loc52_ = Number(_loc51_.explicitMinHeight);
                        if(_loc52_ > _loc36_)
                        {
                           _loc52_ = _loc36_;
                        }
                        if(_loc45_ < _loc52_)
                        {
                           _loc45_ = _loc52_;
                        }
                        else
                        {
                           _loc53_ = Number(_loc51_.explicitMaxHeight);
                           if(_loc45_ > _loc53_)
                           {
                              _loc45_ = _loc53_;
                           }
                        }
                     }
                     _loc39_.height = _loc45_;
                  }
               }
            }
            _loc48_ = _loc33_;
            if(_loc32_ > _loc48_)
            {
               _loc48_ = _loc32_;
            }
            switch(this._verticalAlign)
            {
               case VerticalAlign.BOTTOM:
                  _loc39_.y = _loc47_ + _loc7_ + _loc48_ - this._paddingBottom - _loc39_.height;
                  break;
               case VerticalAlign.MIDDLE:
                  _loc39_.y = _loc47_ + _loc7_ + this._paddingTop + Math.round((_loc48_ - this._paddingTop - this._paddingBottom - _loc39_.height) / 2);
                  break;
               default:
                  _loc39_.y = _loc47_ + _loc7_ + this._paddingTop;
            }
         }
         this._discoveredItemsCache.length = 0;
         if(!param3)
         {
            param3 = new LayoutBoundsResult();
         }
         param3.contentX = 0;
         param3.contentWidth = _loc34_;
         param3.contentY = 0;
         param3.contentHeight = this._verticalAlign == VerticalAlign.JUSTIFY ? _loc33_ : _loc32_;
         param3.viewPortWidth = _loc35_;
         param3.viewPortHeight = _loc33_;
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
         this.prepareTypicalItem(_loc5_ - this._paddingTop - this._paddingBottom);
         var _loc12_:Number = this._typicalItem ? this._typicalItem.width : 0;
         var _loc13_:Number = this._typicalItem ? this._typicalItem.height : 0;
         var _loc14_:Boolean = this._firstGap === this._firstGap;
         var _loc15_:Boolean = this._lastGap === this._lastGap;
         if(this._distributeWidths)
         {
            _loc16_ = (_loc12_ + this._gap) * param1;
         }
         else
         {
            _loc16_ = 0;
            _loc17_ = _loc13_;
            if(!this._hasVariableItemDimensions)
            {
               _loc16_ += (_loc12_ + this._gap) * param1;
            }
            else
            {
               _loc18_ = 0;
               while(_loc18_ < param1)
               {
                  _loc19_ = Number(this._virtualCache[_loc18_]);
                  if(_loc19_ !== _loc19_)
                  {
                     _loc16_ += _loc12_ + this._gap;
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
            if(this._requestedColumnCount > 0)
            {
               _loc20_ = (_loc12_ + this._gap) * this._requestedColumnCount - this._gap + this._paddingLeft + this._paddingRight;
            }
            else
            {
               _loc20_ = _loc16_ + this._paddingLeft + this._paddingRight;
               if(this._maxColumnCount > 0)
               {
                  _loc21_ = (_loc12_ + this._gap) * this._maxColumnCount - this._gap + this._paddingLeft + this._paddingRight;
                  if(_loc21_ < _loc20_)
                  {
                     _loc20_ = _loc21_;
                  }
               }
            }
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
            _loc22_ = _loc17_ + this._paddingTop + this._paddingBottom;
            if(_loc22_ < _loc9_)
            {
               _loc22_ = _loc9_;
            }
            else if(_loc22_ > _loc11_)
            {
               _loc22_ = _loc11_;
            }
            param3.y = _loc22_;
         }
         else
         {
            param3.y = _loc5_;
         }
         return param3;
      }
      
      public function getVisibleIndicesAtScrollPosition(param1:Number, param2:Number, param3:Number, param4:Number, param5:int, param6:Vector.<int> = null) : Vector.<int>
      {
         var _loc18_:Number = NaN;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:* = 0;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:int = 0;
         var _loc28_:int = 0;
         var _loc29_:int = 0;
         var _loc30_:int = 0;
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
         this.prepareTypicalItem(param4 - this._paddingTop - this._paddingBottom);
         var _loc7_:Number = this._typicalItem ? this._typicalItem.width : 0;
         var _loc8_:Number = this._typicalItem ? this._typicalItem.height : 0;
         var _loc9_:Boolean = this._firstGap === this._firstGap;
         var _loc10_:Boolean = this._lastGap === this._lastGap;
         var _loc11_:int = 0;
         var _loc12_:int = Math.ceil(param3 / (_loc7_ + this._gap)) + 1;
         if(!this._hasVariableItemDimensions)
         {
            _loc18_ = param5 * (_loc7_ + this._gap) - this._gap;
            if(_loc9_ && param5 > 1)
            {
               _loc18_ = _loc18_ - this._gap + this._firstGap;
            }
            if(_loc10_ && param5 > 2)
            {
               _loc18_ = _loc18_ - this._gap + this._lastGap;
            }
            _loc19_ = 0;
            if(_loc18_ < param3)
            {
               if(this._horizontalAlign == HorizontalAlign.RIGHT)
               {
                  _loc19_ = Math.ceil((param3 - _loc18_) / (_loc7_ + this._gap));
               }
               else if(this._horizontalAlign == HorizontalAlign.CENTER)
               {
                  _loc19_ = Math.ceil((param3 - _loc18_) / (_loc7_ + this._gap) / 2);
               }
            }
            _loc20_ = (param1 - this._paddingLeft) / (_loc7_ + this._gap);
            if(_loc20_ < 0)
            {
               _loc20_ = 0;
            }
            _loc20_ -= _loc19_;
            _loc21_ = _loc20_ + _loc12_;
            if(_loc21_ >= param5)
            {
               _loc21_ = param5 - 1;
            }
            _loc20_ = _loc21_ - _loc12_;
            if(_loc20_ < 0)
            {
               _loc20_ = 0;
            }
            _loc22_ = _loc20_;
            while(_loc22_ <= _loc21_)
            {
               if(_loc22_ >= 0 && _loc22_ < param5)
               {
                  param6[_loc11_] = _loc22_;
               }
               else if(_loc22_ < 0)
               {
                  param6[_loc11_] = param5 + _loc22_;
               }
               else if(_loc22_ >= param5)
               {
                  param6[_loc11_] = _loc22_ - param5;
               }
               _loc11_++;
               _loc22_++;
            }
            return param6;
         }
         var _loc13_:int = param5 - 2;
         var _loc14_:Number = param1 + param3;
         var _loc15_:Number = this._paddingLeft;
         _loc22_ = 0;
         while(_loc22_ < param5)
         {
            _loc23_ = this._gap;
            if(_loc9_ && _loc22_ == 0)
            {
               _loc23_ = this._firstGap;
            }
            else if(_loc10_ && _loc22_ > 0 && _loc22_ == _loc13_)
            {
               _loc23_ = this._lastGap;
            }
            _loc24_ = Number(this._virtualCache[_loc22_]);
            if(_loc24_ !== _loc24_)
            {
               _loc26_ = _loc7_;
            }
            else
            {
               _loc26_ = _loc24_;
            }
            _loc25_ = _loc15_;
            _loc15_ += _loc26_ + _loc23_;
            if(_loc15_ > param1 && _loc25_ < _loc14_)
            {
               param6[_loc11_] = _loc22_;
               _loc11_++;
            }
            if(_loc15_ >= _loc14_)
            {
               break;
            }
            _loc22_++;
         }
         var _loc16_:int = int(param6.length);
         var _loc17_:int = _loc12_ - _loc16_;
         if(_loc17_ > 0 && _loc16_ > 0)
         {
            _loc27_ = param6[0];
            _loc28_ = _loc27_ - _loc17_;
            if(_loc28_ < 0)
            {
               _loc28_ = 0;
            }
            _loc22_ = int(_loc27_ - 1);
            while(_loc22_ >= _loc28_)
            {
               param6.insertAt(0,_loc22_);
               _loc22_--;
            }
         }
         _loc11_ = _loc16_ = int(param6.length);
         _loc17_ = _loc12_ - _loc16_;
         if(_loc17_ > 0)
         {
            _loc29_ = _loc16_ > 0 ? int(param6[_loc16_ - 1] + 1) : 0;
            _loc30_ = _loc29_ + _loc17_;
            if(_loc30_ > param5)
            {
               _loc30_ = param5;
            }
            _loc22_ = _loc29_;
            while(_loc22_ < _loc30_)
            {
               param6[_loc11_] = _loc22_;
               _loc11_++;
               _loc22_++;
            }
         }
         return param6;
      }
      
      public function getNearestScrollPositionForIndex(param1:int, param2:Number, param3:Number, param4:Vector.<DisplayObject>, param5:Number, param6:Number, param7:Number, param8:Number, param9:Point = null) : Point
      {
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc10_:Number = this.calculateMaxScrollXOfIndex(param1,param4,param5,param6,param7,param8);
         if(this._useVirtualLayout)
         {
            if(this._hasVariableItemDimensions)
            {
               _loc12_ = Number(this._virtualCache[param1]);
               if(_loc12_ !== _loc12_)
               {
                  _loc12_ = this._typicalItem.width;
               }
            }
            else
            {
               _loc12_ = this._typicalItem.width;
            }
         }
         else
         {
            _loc12_ = param4[param1].width;
         }
         if(!param9)
         {
            param9 = new Point();
         }
         var _loc11_:Number = _loc10_ - (param7 - _loc12_);
         if(param2 >= _loc11_ && param2 <= _loc10_)
         {
            param9.x = param2;
         }
         else
         {
            _loc13_ = Math.abs(_loc10_ - param2);
            _loc14_ = Math.abs(_loc11_ - param2);
            if(_loc14_ < _loc13_)
            {
               param9.x = _loc11_;
            }
            else
            {
               param9.x = _loc10_;
            }
         }
         param9.y = 0;
         return param9;
      }
      
      public function calculateNavigationDestination(param1:Vector.<DisplayObject>, param2:int, param3:uint, param4:LayoutBoundsResult) : int
      {
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:int = 0;
         var _loc11_:* = 0;
         var _loc12_:int = 0;
         var _loc13_:Number = NaN;
         var _loc14_:DisplayObject = null;
         var _loc5_:int = int(param1.length);
         var _loc6_:int = _loc5_ + this._beforeVirtualizedItemCount + this._afterVirtualizedItemCount;
         if(this._useVirtualLayout)
         {
            this.prepareTypicalItem(param4.viewPortHeight - this._paddingTop - this._paddingBottom);
            _loc8_ = this._typicalItem ? this._typicalItem.width : 0;
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
            _loc10_ = 0;
            if(this._useVirtualLayout && this._hasVariableItemDimensions)
            {
               _loc10_ = -this._beforeVirtualizedItemCount;
            }
            _loc11_ = param2;
            while(_loc11_ >= 0)
            {
               _loc12_ = _loc11_ + _loc10_;
               if(this._useVirtualLayout && this._hasVariableItemDimensions)
               {
                  _loc13_ = Number(this._virtualCache[_loc11_]);
               }
               if(_loc12_ < 0 || _loc12_ >= _loc5_)
               {
                  if(_loc13_ === _loc13_)
                  {
                     _loc9_ += _loc13_;
                  }
                  else
                  {
                     _loc9_ += _loc8_;
                  }
               }
               else
               {
                  _loc14_ = param1[_loc12_];
                  if(_loc14_ === null)
                  {
                     if(_loc13_ === _loc13_)
                     {
                        _loc9_ += _loc13_;
                     }
                     else
                     {
                        _loc9_ += _loc8_;
                     }
                  }
                  else
                  {
                     _loc9_ += _loc14_.width;
                  }
               }
               if(_loc9_ > param4.viewPortWidth)
               {
                  break;
               }
               _loc9_ += this._gap;
               _loc7_ = int(_loc11_);
               _loc11_--;
            }
         }
         else if(param3 == Keyboard.PAGE_DOWN)
         {
            _loc9_ = 0;
            _loc10_ = 0;
            if(this._useVirtualLayout && this._hasVariableItemDimensions)
            {
               _loc10_ = -this._beforeVirtualizedItemCount;
            }
            _loc11_ = param2;
            while(_loc11_ < _loc6_)
            {
               _loc12_ = _loc11_ + _loc10_;
               if(this._useVirtualLayout && this._hasVariableItemDimensions)
               {
                  _loc13_ = Number(this._virtualCache[_loc11_]);
               }
               if(_loc12_ < 0 || _loc12_ >= _loc5_)
               {
                  if(_loc13_ === _loc13_)
                  {
                     _loc9_ += _loc13_;
                  }
                  else
                  {
                     _loc9_ += _loc8_;
                  }
               }
               else
               {
                  _loc14_ = param1[_loc12_];
                  if(_loc14_ === null)
                  {
                     if(_loc13_ === _loc13_)
                     {
                        _loc9_ += _loc13_;
                     }
                     else
                     {
                        _loc9_ += _loc8_;
                     }
                  }
                  else
                  {
                     _loc9_ += _loc14_.width;
                  }
               }
               if(_loc9_ > param4.viewPortWidth)
               {
                  break;
               }
               _loc9_ += this._gap;
               _loc7_ = int(_loc11_);
               _loc11_++;
            }
         }
         else if(param3 == Keyboard.LEFT)
         {
            _loc7_--;
         }
         else if(param3 == Keyboard.RIGHT)
         {
            _loc7_++;
         }
         if(_loc7_ < 0)
         {
            return 0;
         }
         if(_loc7_ >= _loc6_)
         {
            return _loc6_ - 1;
         }
         return _loc7_;
      }
      
      public function getScrollPositionForIndex(param1:int, param2:Vector.<DisplayObject>, param3:Number, param4:Number, param5:Number, param6:Number, param7:Point = null) : Point
      {
         var _loc9_:Number = NaN;
         var _loc8_:Number = this.calculateMaxScrollXOfIndex(param1,param2,param3,param4,param5,param6);
         if(this._useVirtualLayout)
         {
            if(this._hasVariableItemDimensions)
            {
               _loc9_ = Number(this._virtualCache[param1]);
               if(_loc9_ !== _loc9_)
               {
                  _loc9_ = this._typicalItem.width;
               }
            }
            else
            {
               _loc9_ = this._typicalItem.width;
            }
         }
         else
         {
            _loc9_ = param2[param1].width;
         }
         if(this._scrollPositionHorizontalAlign == HorizontalAlign.CENTER)
         {
            _loc8_ -= Math.round((param5 - _loc9_) / 2);
         }
         else if(this._scrollPositionHorizontalAlign == HorizontalAlign.RIGHT)
         {
            _loc8_ -= param5 - _loc9_;
         }
         param7.x = _loc8_;
         param7.y = 0;
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
         param1.y = this._paddingTop;
         var _loc12_:Number = 0;
         if(param2 < _loc10_)
         {
            _loc13_ = param5[_loc11_];
            _loc12_ = _loc13_.x - param1.width / 2;
            param1.y = _loc13_.y;
            param1.height = _loc13_.height;
         }
         else
         {
            _loc13_ = param5[_loc11_ - 1];
            _loc12_ = _loc13_.x + _loc13_.width - param1.width;
            param1.y = _loc13_.y;
            param1.height = _loc13_.height;
         }
         if(_loc12_ < 0)
         {
            _loc12_ = 0;
         }
         param1.x = _loc12_;
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
            this.prepareTypicalItem(param7 - this._paddingTop - this._paddingBottom);
            _loc18_ = this._typicalItem ? this._typicalItem.width : 0;
            _loc19_ = this._typicalItem ? this._typicalItem.height : 0;
         }
         var _loc8_:Boolean = this._firstGap === this._firstGap;
         var _loc9_:Boolean = this._lastGap === this._lastGap;
         var _loc10_:Number = param4 + this._paddingLeft;
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
                  _loc11_ = _loc18_;
               }
               else
               {
                  _loc11_ = _loc22_;
               }
            }
            else
            {
               _loc10_ = _loc20_.x;
               _loc23_ = _loc20_.width;
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
                  else if(_loc18_ >= 0)
                  {
                     _loc23_ = _loc18_;
                  }
               }
               _loc11_ = _loc23_;
            }
            if(param1 < _loc10_ + _loc11_ / 2)
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
         var _loc15_:DisplayObject = null;
         var _loc16_:IFeathersControl = null;
         var _loc17_:ILayoutDisplayObject = null;
         var _loc18_:HorizontalLayoutData = null;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:IMeasureDisplayObject = null;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc9_:Boolean = param5 !== param5;
         var _loc10_:Boolean = param2 !== param2;
         var _loc11_:Number = param5;
         if(_loc9_)
         {
            _loc11_ = param6;
         }
         var _loc12_:Boolean = this._verticalAlign == VerticalAlign.JUSTIFY;
         var _loc13_:int = int(param1.length);
         var _loc14_:int = 0;
         while(_loc14_ < _loc13_)
         {
            _loc15_ = param1[_loc14_];
            if(!(!_loc15_ || _loc15_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc15_).includeInLayout))
            {
               if(this._distributeWidths)
               {
                  _loc15_.width = param8;
               }
               if(_loc12_)
               {
                  _loc15_.height = param2;
                  if(_loc15_ is IFeathersControl)
                  {
                     _loc16_ = IFeathersControl(_loc15_);
                     _loc16_.minHeight = param3;
                     _loc16_.maxHeight = param4;
                  }
               }
               else if(_loc15_ is ILayoutDisplayObject)
               {
                  _loc17_ = ILayoutDisplayObject(_loc15_);
                  _loc18_ = _loc17_.layoutData as HorizontalLayoutData;
                  if(_loc18_ !== null)
                  {
                     _loc19_ = _loc18_.percentWidth;
                     _loc20_ = _loc18_.percentHeight;
                     if(_loc19_ === _loc19_)
                     {
                        if(_loc19_ < 0)
                        {
                           _loc19_ = 0;
                        }
                        if(_loc19_ > 100)
                        {
                           _loc19_ = 100;
                        }
                        _loc21_ = _loc11_ * _loc19_ / 100;
                        _loc22_ = IMeasureDisplayObject(_loc15_);
                        _loc23_ = _loc22_.explicitMinWidth;
                        if(_loc22_.explicitMinWidth === _loc22_.explicitMinWidth && _loc21_ < _loc23_)
                        {
                           _loc21_ = _loc23_;
                        }
                        _loc22_.maxWidth = _loc21_;
                        _loc15_.width = NaN;
                     }
                     if(_loc20_ === _loc20_)
                     {
                        if(_loc20_ < 0)
                        {
                           _loc20_ = 0;
                        }
                        if(_loc20_ > 100)
                        {
                           _loc20_ = 100;
                        }
                        _loc24_ = param2 * _loc20_ / 100;
                        _loc22_ = IMeasureDisplayObject(_loc15_);
                        _loc25_ = _loc22_.explicitMinHeight;
                        if(_loc22_.explicitMinHeight === _loc22_.explicitMinHeight && _loc24_ < _loc25_)
                        {
                           _loc24_ = _loc25_;
                        }
                        if(_loc24_ > param4)
                        {
                           _loc24_ = param4;
                        }
                        _loc15_.height = _loc24_;
                        if(_loc22_.explicitHeight !== _loc22_.explicitHeight && _loc22_.maxHeight > param4)
                        {
                           _loc22_.maxHeight = param4;
                        }
                     }
                  }
               }
               if(_loc15_ is IValidating)
               {
                  IValidating(_loc15_).validate();
               }
            }
            _loc14_++;
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
         if(this._resetTypicalItemDimensionsOnMeasure)
         {
            this._typicalItem.width = this._typicalItemWidth;
         }
         var _loc2_:Boolean = false;
         if(this._verticalAlign == VerticalAlign.JUSTIFY && param1 === param1)
         {
            _loc2_ = true;
            this._typicalItem.height = param1;
         }
         else if(this._typicalItem is ILayoutDisplayObject)
         {
            _loc3_ = ILayoutDisplayObject(this._typicalItem);
            _loc4_ = _loc3_.layoutData as VerticalLayoutData;
            if(_loc4_ !== null)
            {
               _loc5_ = _loc4_.percentHeight;
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
                  this._typicalItem.height = param1 * _loc5_ / 100;
               }
            }
         }
         if(!_loc2_ && this._resetTypicalItemDimensionsOnMeasure)
         {
            this._typicalItem.height = this._typicalItemHeight;
         }
         if(this._typicalItem is IValidating)
         {
            IValidating(this._typicalItem).validate();
         }
      }
      
      protected function calculateDistributedWidth(param1:Vector.<DisplayObject>, param2:Number, param3:Number, param4:Number, param5:Boolean) : Number
      {
         var _loc12_:DisplayObject = null;
         var _loc13_:Number = NaN;
         var _loc14_:Boolean = false;
         var _loc6_:Boolean = param2 !== param2;
         var _loc7_:Number = 0;
         var _loc8_:int = 0;
         var _loc9_:int = int(param1.length);
         var _loc10_:int = 0;
         while(_loc10_ < _loc9_)
         {
            _loc12_ = param1[_loc10_];
            if(!(_loc12_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc12_).includeInLayout))
            {
               _loc8_++;
               _loc13_ = _loc12_.width;
               if(_loc13_ > _loc7_)
               {
                  _loc7_ = _loc13_;
               }
            }
            _loc10_++;
         }
         if(param5 && _loc6_)
         {
            param2 = _loc7_ * _loc8_ + this._paddingLeft + this._paddingRight + this._gap * (_loc8_ - 1);
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
               return _loc7_;
            }
         }
         var _loc11_:Number = param2;
         if(_loc6_ && param4 < Number.POSITIVE_INFINITY)
         {
            _loc11_ = param4;
         }
         _loc11_ = _loc11_ - this._paddingLeft - this._paddingRight - this._gap * (_loc8_ - 1);
         if(_loc8_ > 1 && this._firstGap === this._firstGap)
         {
            _loc11_ += this._gap - this._firstGap;
         }
         if(_loc8_ > 2 && this._lastGap === this._lastGap)
         {
            _loc11_ += this._gap - this._lastGap;
         }
         return _loc11_ / _loc8_;
      }
      
      protected function applyPercentWidths(param1:Vector.<DisplayObject>, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc12_:DisplayObject = null;
         var _loc13_:ILayoutDisplayObject = null;
         var _loc14_:HorizontalLayoutData = null;
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
               _loc14_ = _loc13_.layoutData as HorizontalLayoutData;
               if(_loc14_)
               {
                  _loc15_ = _loc14_.percentWidth;
                  if(_loc15_ === _loc15_)
                  {
                     if(_loc15_ < 0)
                     {
                        _loc15_ = 0;
                     }
                     if(_loc13_ is IFeathersControl)
                     {
                        _loc16_ = IFeathersControl(_loc13_);
                        _loc7_ += _loc16_.minWidth;
                     }
                     _loc8_ += _loc15_;
                     _loc6_ += this._gap;
                     this._discoveredItemsCache[_loc10_] = _loc12_;
                     _loc10_++;
                     continue;
                  }
               }
            }
            _loc6_ += _loc12_.width + this._gap;
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
         _loc6_ += this._paddingLeft + this._paddingRight;
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
                  _loc14_ = HorizontalLayoutData(_loc13_.layoutData);
                  _loc15_ = _loc14_.percentWidth;
                  if(_loc15_ < 0)
                  {
                     _loc15_ = 0;
                  }
                  _loc19_ = _loc18_ * _loc15_;
                  if(_loc13_ is IFeathersControl)
                  {
                     _loc16_ = IFeathersControl(_loc13_);
                     _loc20_ = Number(_loc16_.explicitMinWidth);
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
                  _loc13_.width = _loc19_;
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
      
      protected function calculateMaxScrollXOfIndex(param1:int, param2:Vector.<DisplayObject>, param3:Number, param4:Number, param5:Number, param6:Number) : Number
      {
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:DisplayObject = null;
         var _loc21_:int = 0;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         if(this._useVirtualLayout)
         {
            this.prepareTypicalItem(param6 - this._paddingTop - this._paddingBottom);
            _loc18_ = this._typicalItem ? this._typicalItem.width : 0;
            _loc19_ = this._typicalItem ? this._typicalItem.height : 0;
         }
         var _loc7_:Boolean = this._firstGap === this._firstGap;
         var _loc8_:Boolean = this._lastGap === this._lastGap;
         var _loc9_:Number = param3 + this._paddingLeft;
         var _loc10_:Number = 0;
         var _loc11_:Number = this._gap;
         var _loc12_:int = 0;
         var _loc13_:Number = 0;
         var _loc14_:int;
         var _loc15_:int = _loc14_ = int(param2.length);
         if(this._useVirtualLayout && !this._hasVariableItemDimensions)
         {
            _loc15_ += this._beforeVirtualizedItemCount + this._afterVirtualizedItemCount;
            if(param1 < this._beforeVirtualizedItemCount)
            {
               _loc12_ = param1 + 1;
               _loc10_ = _loc18_;
               _loc11_ = this._gap;
            }
            else
            {
               _loc12_ = this._beforeVirtualizedItemCount;
               _loc13_ = param1 - param2.length - this._beforeVirtualizedItemCount + 1;
               if(_loc13_ < 0)
               {
                  _loc13_ = 0;
               }
               _loc9_ += _loc13_ * (_loc18_ + this._gap);
            }
            _loc9_ += _loc12_ * (_loc18_ + this._gap);
         }
         param1 -= _loc12_ + _loc13_;
         var _loc16_:int = _loc15_ - 2;
         var _loc17_:int = 0;
         while(_loc17_ <= param1)
         {
            _loc20_ = param2[_loc17_];
            _loc21_ = _loc17_ + _loc12_;
            if(_loc7_ && _loc21_ == 0)
            {
               _loc11_ = this._firstGap;
            }
            else if(_loc8_ && _loc21_ > 0 && _loc21_ == _loc16_)
            {
               _loc11_ = this._lastGap;
            }
            else
            {
               _loc11_ = this._gap;
            }
            if(this._useVirtualLayout && this._hasVariableItemDimensions)
            {
               _loc22_ = Number(this._virtualCache[_loc21_]);
            }
            if(this._useVirtualLayout && !_loc20_)
            {
               if(!this._hasVariableItemDimensions || _loc22_ !== _loc22_)
               {
                  _loc10_ = _loc18_;
               }
               else
               {
                  _loc10_ = _loc22_;
               }
            }
            else
            {
               _loc23_ = _loc20_.width;
               if(this._useVirtualLayout)
               {
                  if(this._hasVariableItemDimensions)
                  {
                     if(_loc23_ != _loc22_)
                     {
                        this._virtualCache[_loc21_] = _loc23_;
                        this.dispatchEventWith(Event.CHANGE);
                     }
                  }
                  else if(_loc18_ >= 0)
                  {
                     _loc20_.width = _loc23_ = _loc18_;
                  }
               }
               _loc10_ = _loc23_;
            }
            _loc9_ += _loc10_ + _loc11_;
            _loc17_++;
         }
         return _loc9_ - (_loc10_ + _loc11_);
      }
   }
}

