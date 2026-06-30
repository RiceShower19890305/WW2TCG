package feathers.layout
{
   import feathers.core.IValidating;
   import flash.errors.IllegalOperationError;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import starling.display.DisplayObject;
   import starling.events.Event;
   
   public class FlowLayout extends BaseVariableVirtualLayout implements IVariableVirtualLayout, IDragDropLayout
   {
      
      protected var _rowItems:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
      
      protected var _horizontalGap:Number = 0;
      
      protected var _verticalGap:Number = 0;
      
      protected var _firstHorizontalGap:Number = NaN;
      
      protected var _lastHorizontalGap:Number = NaN;
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var _horizontalAlign:String = "left";
      
      protected var _verticalAlign:String = "top";
      
      protected var _rowVerticalAlign:String = "top";
      
      protected var _widthCache:Array = [];
      
      protected var _heightCache:Array = [];
      
      public function FlowLayout()
      {
         super();
         this._hasVariableItemDimensions = true;
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
      
      public function get firstHorizontalGap() : Number
      {
         return this._firstHorizontalGap;
      }
      
      public function set firstHorizontalGap(param1:Number) : void
      {
         if(this._firstHorizontalGap == param1)
         {
            return;
         }
         this._firstHorizontalGap = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get lastHorizontalGap() : Number
      {
         return this._lastHorizontalGap;
      }
      
      public function set lastHorizontalGap(param1:Number) : void
      {
         if(this._lastHorizontalGap == param1)
         {
            return;
         }
         this._lastHorizontalGap = param1;
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
      
      public function get rowVerticalAlign() : String
      {
         return this._rowVerticalAlign;
      }
      
      public function set rowVerticalAlign(param1:String) : void
      {
         if(this._rowVerticalAlign == param1)
         {
            return;
         }
         this._rowVerticalAlign = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function layout(param1:Vector.<DisplayObject>, param2:ViewPortBounds = null, param3:LayoutBoundsResult = null) : LayoutBoundsResult
      {
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:int = 0;
         var _loc30_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc32_:DisplayObject = null;
         var _loc33_:Number = NaN;
         var _loc34_:Number = NaN;
         var _loc35_:Number = NaN;
         var _loc36_:Number = NaN;
         var _loc37_:int = 0;
         var _loc38_:Number = NaN;
         var _loc39_:int = 0;
         var _loc40_:ILayoutDisplayObject = null;
         var _loc41_:Number = NaN;
         var _loc42_:Number = NaN;
         var _loc4_:Number = param2 ? param2.x : 0;
         var _loc5_:Number = param2 ? param2.y : 0;
         var _loc6_:Number = param2 ? param2.minWidth : 0;
         var _loc7_:Number = param2 ? param2.minHeight : 0;
         var _loc8_:Number = param2 ? param2.maxWidth : Number.POSITIVE_INFINITY;
         var _loc9_:Number = param2 ? param2.maxHeight : Number.POSITIVE_INFINITY;
         var _loc10_:Number = param2 ? param2.explicitWidth : NaN;
         var _loc11_:Number = param2 ? param2.explicitHeight : NaN;
         var _loc12_:Boolean = _loc10_ !== _loc10_;
         var _loc13_:Boolean = true;
         var _loc14_:Number = _loc10_;
         if(_loc12_)
         {
            _loc14_ = _loc8_;
            if(_loc14_ == Number.POSITIVE_INFINITY)
            {
               _loc13_ = false;
            }
         }
         if(this._useVirtualLayout)
         {
            if(this._typicalItem is IValidating)
            {
               IValidating(this._typicalItem).validate();
            }
            _loc26_ = this._typicalItem ? this._typicalItem.width : 0;
            _loc27_ = this._typicalItem ? this._typicalItem.height : 0;
         }
         var _loc15_:int = 0;
         var _loc16_:int = int(param1.length);
         var _loc17_:Number = _loc5_ + this._paddingTop;
         var _loc18_:Number = 0;
         var _loc19_:Number = 0;
         var _loc20_:Number = this._verticalGap;
         var _loc21_:Boolean = this._firstHorizontalGap === this._firstHorizontalGap;
         var _loc22_:Boolean = this._lastHorizontalGap === this._lastHorizontalGap;
         var _loc23_:int = _loc16_ - 2;
         do
         {
            if(_loc15_ > 0)
            {
               _loc17_ += _loc19_ + _loc20_;
            }
            _loc19_ = this._useVirtualLayout ? _loc27_ : 0;
            _loc28_ = _loc4_ + this._paddingLeft;
            this._rowItems.length = 0;
            _loc29_ = 0;
            _loc30_ = 0;
            for(; _loc15_ < _loc16_; _loc15_++)
            {
               _loc32_ = param1[_loc15_];
               _loc30_ = this._horizontalGap;
               if(_loc21_ && _loc15_ == 0)
               {
                  _loc30_ = this._firstHorizontalGap;
               }
               else if(_loc22_ && _loc15_ > 0 && _loc15_ == _loc23_)
               {
                  _loc30_ = this._lastHorizontalGap;
               }
               if(this._useVirtualLayout && this._hasVariableItemDimensions)
               {
                  _loc33_ = Number(this._widthCache[_loc15_]);
                  _loc34_ = Number(this._heightCache[_loc15_]);
               }
               if(this._useVirtualLayout && !_loc32_)
               {
                  if(this._hasVariableItemDimensions)
                  {
                     if(_loc33_ !== _loc33_)
                     {
                        _loc35_ = _loc26_;
                     }
                     else
                     {
                        _loc35_ = _loc33_;
                     }
                     if(_loc34_ !== _loc34_)
                     {
                        _loc36_ = _loc27_;
                     }
                     else
                     {
                        _loc36_ = _loc34_;
                     }
                  }
                  else
                  {
                     _loc35_ = _loc26_;
                     _loc36_ = _loc27_;
                  }
               }
               else
               {
                  if(_loc32_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc32_).includeInLayout)
                  {
                     continue;
                  }
                  if(_loc32_ is IValidating)
                  {
                     IValidating(_loc32_).validate();
                  }
                  _loc35_ = _loc32_.width;
                  _loc36_ = _loc32_.height;
                  if(this._useVirtualLayout)
                  {
                     if(this._hasVariableItemDimensions)
                     {
                        if(_loc35_ != _loc33_)
                        {
                           this._widthCache[_loc15_] = _loc35_;
                           this.dispatchEventWith(Event.CHANGE);
                        }
                        if(_loc36_ != _loc34_)
                        {
                           this._heightCache[_loc15_] = _loc36_;
                           this.dispatchEventWith(Event.CHANGE);
                        }
                     }
                     else
                     {
                        if(_loc26_ >= 0)
                        {
                           _loc32_.width = _loc35_ = _loc26_;
                        }
                        if(_loc27_ >= 0)
                        {
                           _loc32_.height = _loc36_ = _loc27_;
                        }
                     }
                  }
               }
               if(_loc13_ && _loc29_ > 0 && _loc28_ + _loc35_ > _loc14_ - this._paddingRight)
               {
                  _loc37_ = _loc15_ - 1;
                  _loc30_ = this._horizontalGap;
                  if(_loc21_ && _loc37_ == 0)
                  {
                     _loc30_ = this._firstHorizontalGap;
                  }
                  else if(_loc22_ && _loc37_ > 0 && _loc37_ == _loc23_)
                  {
                     _loc30_ = this._lastHorizontalGap;
                  }
                  break;
               }
               if(_loc32_)
               {
                  this._rowItems[this._rowItems.length] = _loc32_;
                  _loc32_.x = _loc32_.pivotX + _loc28_;
               }
               _loc28_ += _loc35_ + _loc30_;
               if(_loc36_ > _loc19_)
               {
                  _loc19_ = _loc36_;
               }
               _loc29_++;
            }
            _loc31_ = _loc28_ - _loc30_ + this._paddingRight - _loc4_;
            if(_loc31_ > _loc18_)
            {
               _loc18_ = _loc31_;
            }
            _loc29_ = int(this._rowItems.length);
            if(_loc13_)
            {
               _loc38_ = 0;
               if(this._horizontalAlign === HorizontalAlign.RIGHT)
               {
                  _loc38_ = _loc14_ - _loc31_;
               }
               else if(this._horizontalAlign === HorizontalAlign.CENTER)
               {
                  _loc38_ = Math.round((_loc14_ - _loc31_) / 2);
               }
               if(_loc38_ != 0)
               {
                  _loc39_ = 0;
                  while(_loc39_ < _loc29_)
                  {
                     _loc32_ = this._rowItems[_loc39_];
                     if(!(_loc32_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc32_).includeInLayout))
                     {
                        _loc32_.x += _loc38_;
                     }
                     _loc39_++;
                  }
               }
            }
            _loc39_ = 0;
            for(; _loc39_ < _loc29_; _loc39_++)
            {
               _loc32_ = this._rowItems[_loc39_];
               _loc40_ = _loc32_ as ILayoutDisplayObject;
               if((Boolean(_loc40_)) && !_loc40_.includeInLayout)
               {
                  continue;
               }
               switch(this._rowVerticalAlign)
               {
                  case VerticalAlign.BOTTOM:
                     _loc32_.y = _loc32_.pivotY + _loc17_ + _loc19_ - _loc32_.height;
                     break;
                  case VerticalAlign.MIDDLE:
                     _loc32_.y = _loc32_.pivotY + _loc17_ + Math.round((_loc19_ - _loc32_.height) / 2);
                     break;
                  default:
                     _loc32_.y = _loc32_.pivotY + _loc17_;
               }
            }
         }
         while(_loc15_ < _loc16_);
         this._rowItems.length = 0;
         if(_loc13_ && (_loc12_ || _loc10_ < _loc18_))
         {
            _loc41_ = _loc18_;
            if(_loc41_ < _loc6_)
            {
               _loc41_ = _loc6_;
            }
            else if(_loc41_ > _loc8_)
            {
               _loc41_ = _loc8_;
            }
            _loc38_ = 0;
            if(this._horizontalAlign === HorizontalAlign.RIGHT)
            {
               _loc38_ = _loc14_ - _loc41_;
            }
            else if(this._horizontalAlign === HorizontalAlign.CENTER)
            {
               _loc38_ = Math.round((_loc14_ - _loc41_) / 2);
            }
            if(_loc38_ != 0)
            {
               _loc15_ = 0;
               while(_loc15_ < _loc16_)
               {
                  _loc32_ = param1[_loc15_];
                  if(!(!_loc32_ || _loc32_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc32_).includeInLayout))
                  {
                     _loc32_.x -= _loc38_;
                  }
                  _loc15_++;
               }
            }
         }
         else
         {
            _loc41_ = _loc18_;
         }
         if(_loc12_)
         {
            _loc14_ = _loc41_;
         }
         var _loc24_:Number = _loc17_ + _loc19_ + this._paddingBottom;
         var _loc25_:Number = _loc11_;
         if(_loc25_ !== _loc25_)
         {
            _loc25_ = _loc24_;
            if(_loc25_ < _loc7_)
            {
               _loc25_ = _loc7_;
            }
            else if(_loc25_ > _loc9_)
            {
               _loc25_ = _loc9_;
            }
         }
         if(_loc24_ < _loc25_ && this._verticalAlign != VerticalAlign.TOP)
         {
            _loc42_ = _loc25_ - _loc24_;
            if(this._verticalAlign === VerticalAlign.MIDDLE)
            {
               _loc42_ /= 2;
            }
            _loc15_ = 0;
            while(_loc15_ < _loc16_)
            {
               _loc32_ = param1[_loc15_];
               if(!(!_loc32_ || _loc32_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc32_).includeInLayout))
               {
                  _loc32_.y += _loc42_;
               }
               _loc15_++;
            }
         }
         if(!param3)
         {
            param3 = new LayoutBoundsResult();
         }
         param3.contentX = 0;
         param3.contentWidth = _loc18_;
         param3.contentY = 0;
         param3.contentHeight = _loc24_;
         param3.viewPortWidth = _loc14_;
         param3.viewPortHeight = _loc25_;
         return param3;
      }
      
      public function measureViewPort(param1:int, param2:ViewPortBounds = null, param3:Point = null) : Point
      {
         var _loc26_:Number = NaN;
         var _loc27_:int = 0;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc32_:Number = NaN;
         var _loc33_:Number = NaN;
         if(!param3)
         {
            param3 = new Point();
         }
         if(!this._useVirtualLayout)
         {
            throw new IllegalOperationError("measureViewPort() may be called only if useVirtualLayout is true.");
         }
         var _loc4_:Number = param2 ? param2.x : 0;
         var _loc5_:Number = param2 ? param2.y : 0;
         var _loc6_:Number = param2 ? param2.minWidth : 0;
         var _loc7_:Number = param2 ? param2.minHeight : 0;
         var _loc8_:Number = param2 ? param2.maxWidth : Number.POSITIVE_INFINITY;
         var _loc9_:Number = param2 ? param2.maxHeight : Number.POSITIVE_INFINITY;
         var _loc10_:Number = param2 ? param2.explicitWidth : NaN;
         var _loc11_:Number = param2 ? param2.explicitHeight : NaN;
         var _loc12_:Boolean = true;
         var _loc13_:Number = _loc10_;
         if(_loc13_ !== _loc13_)
         {
            _loc13_ = _loc8_;
            if(_loc13_ == Number.POSITIVE_INFINITY)
            {
               _loc12_ = false;
            }
         }
         if(this._typicalItem is IValidating)
         {
            IValidating(this._typicalItem).validate();
         }
         var _loc14_:Number = this._typicalItem ? this._typicalItem.width : 0;
         var _loc15_:Number = this._typicalItem ? this._typicalItem.height : 0;
         var _loc16_:int = 0;
         var _loc17_:Number = _loc5_ + this._paddingTop;
         var _loc18_:Number = 0;
         var _loc19_:Number = 0;
         var _loc20_:Number = this._verticalGap;
         var _loc21_:Boolean = this._firstHorizontalGap === this._firstHorizontalGap;
         var _loc22_:Boolean = this._lastHorizontalGap === this._lastHorizontalGap;
         var _loc23_:int = param1 - 2;
         do
         {
            if(_loc16_ > 0)
            {
               _loc17_ += _loc19_ + _loc20_;
            }
            _loc19_ = this._useVirtualLayout ? _loc15_ : 0;
            _loc26_ = _loc4_ + this._paddingLeft;
            _loc27_ = 0;
            _loc28_ = 0;
            while(_loc16_ < param1)
            {
               _loc28_ = this._horizontalGap;
               if(_loc21_ && _loc16_ == 0)
               {
                  _loc28_ = this._firstHorizontalGap;
               }
               else if(_loc22_ && _loc16_ > 0 && _loc16_ == _loc23_)
               {
                  _loc28_ = this._lastHorizontalGap;
               }
               if(this._hasVariableItemDimensions)
               {
                  _loc30_ = Number(this._widthCache[_loc16_]);
                  _loc31_ = Number(this._heightCache[_loc16_]);
                  if(_loc30_ !== _loc30_)
                  {
                     _loc32_ = _loc14_;
                  }
                  else
                  {
                     _loc32_ = _loc30_;
                  }
                  if(_loc31_ !== _loc31_)
                  {
                     _loc33_ = _loc15_;
                  }
                  else
                  {
                     _loc33_ = _loc31_;
                  }
               }
               else
               {
                  _loc32_ = _loc14_;
                  _loc33_ = _loc15_;
               }
               if(_loc12_ && _loc27_ > 0 && _loc26_ + _loc32_ > _loc13_ - this._paddingRight)
               {
                  break;
               }
               _loc26_ += _loc32_ + _loc28_;
               if(_loc33_ > _loc19_)
               {
                  _loc19_ = _loc33_;
               }
               _loc27_++;
               _loc16_++;
            }
            _loc29_ = _loc26_ - _loc28_ + this._paddingRight - _loc4_;
            if(_loc29_ > _loc18_)
            {
               _loc18_ = _loc29_;
            }
         }
         while(_loc16_ < param1);
         if(_loc12_)
         {
            if(_loc10_ !== _loc10_)
            {
               _loc13_ = _loc18_;
               if(_loc13_ < _loc6_)
               {
                  _loc13_ = _loc6_;
               }
               else if(_loc13_ > _loc8_)
               {
                  _loc13_ = _loc8_;
               }
            }
         }
         else
         {
            _loc13_ = _loc18_;
         }
         var _loc24_:Number = _loc17_ + _loc19_ + this._paddingBottom;
         var _loc25_:Number = _loc11_;
         if(_loc25_ !== _loc25_)
         {
            _loc25_ = _loc24_;
            if(_loc25_ < _loc7_)
            {
               _loc25_ = _loc7_;
            }
            else if(_loc25_ > _loc9_)
            {
               _loc25_ = _loc9_;
            }
         }
         param3.x = _loc13_;
         param3.y = _loc25_;
         return param3;
      }
      
      public function getNearestScrollPositionForIndex(param1:int, param2:Number, param3:Number, param4:Vector.<DisplayObject>, param5:Number, param6:Number, param7:Number, param8:Number, param9:Point = null) : Point
      {
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         param9 = this.calculateMaxScrollYAndRowHeightOfIndex(param1,param4,param5,param6,param7,param8,param9);
         var _loc10_:Number = param9.x;
         var _loc11_:Number = param9.y;
         param9.x = 0;
         var _loc12_:Number = _loc10_ - (param8 - _loc11_);
         if(param3 >= _loc12_ && param3 <= _loc10_)
         {
            param9.y = param3;
         }
         else
         {
            _loc13_ = Math.abs(_loc10_ - param3);
            _loc14_ = Math.abs(_loc12_ - param3);
            if(_loc14_ < _loc13_)
            {
               param9.y = _loc12_;
            }
            else
            {
               param9.y = _loc10_;
            }
         }
         return param9;
      }
      
      public function calculateNavigationDestination(param1:Vector.<DisplayObject>, param2:int, param3:uint, param4:LayoutBoundsResult) : int
      {
         var _loc5_:* = param2;
         if(param3 == Keyboard.HOME)
         {
            if(param1.length > 0)
            {
               _loc5_ = 0;
            }
         }
         else if(param3 == Keyboard.END)
         {
            _loc5_ = int(param1.length - 1);
         }
         else if(param3 == Keyboard.UP)
         {
            _loc5_--;
         }
         else if(param3 == Keyboard.DOWN)
         {
            _loc5_++;
         }
         if(_loc5_ < 0)
         {
            return 0;
         }
         if(_loc5_ >= param1.length)
         {
            return param1.length - 1;
         }
         return _loc5_;
      }
      
      public function getScrollPositionForIndex(param1:int, param2:Vector.<DisplayObject>, param3:Number, param4:Number, param5:Number, param6:Number, param7:Point = null) : Point
      {
         var _loc10_:Number = NaN;
         param7 = this.calculateMaxScrollYAndRowHeightOfIndex(param1,param2,param3,param4,param5,param6,param7);
         var _loc8_:Number = param7.x;
         var _loc9_:Number = param7.y;
         if(this._useVirtualLayout)
         {
            if(this._hasVariableItemDimensions)
            {
               _loc10_ = Number(this._heightCache[param1]);
               if(_loc10_ !== _loc10_)
               {
                  _loc10_ = this._typicalItem.height;
               }
            }
            else
            {
               _loc10_ = this._typicalItem.height;
            }
         }
         else
         {
            _loc10_ = param2[param1].height;
         }
         if(!param7)
         {
            param7 = new Point();
         }
         param7.x = 0;
         param7.y = _loc8_ - Math.round((param6 - _loc10_) / 2);
         return param7;
      }
      
      public function getDropIndex(param1:Number, param2:Number, param3:Vector.<DisplayObject>, param4:Number, param5:Number, param6:Number, param7:Number) : int
      {
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:int = 0;
         var _loc18_:DisplayObject = null;
         var _loc19_:Boolean = false;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         if(this._useVirtualLayout)
         {
            if(this._typicalItem is IValidating)
            {
               IValidating(this._typicalItem).validate();
            }
            _loc14_ = this._typicalItem ? this._typicalItem.width : 0;
            _loc15_ = this._typicalItem ? this._typicalItem.height : 0;
         }
         var _loc8_:Number = this._horizontalGap;
         var _loc9_:Number = this._verticalGap;
         var _loc10_:Number = 0;
         var _loc11_:Number = this._paddingTop;
         var _loc12_:int = 0;
         var _loc13_:int = int(param3.length);
         loop0:
         while(true)
         {
            if(_loc12_ > 0)
            {
               _loc11_ += _loc10_ + _loc9_;
            }
            _loc10_ = this._useVirtualLayout ? _loc15_ : 0;
            _loc16_ = this._paddingLeft;
            _loc17_ = 0;
            for(; _loc12_ < _loc13_; _loc12_++)
            {
               _loc18_ = param3[_loc12_];
               if(this._useVirtualLayout && this._hasVariableItemDimensions)
               {
                  _loc20_ = Number(this._widthCache[_loc12_]);
                  _loc21_ = Number(this._heightCache[_loc12_]);
               }
               if(this._useVirtualLayout && !_loc18_)
               {
                  if(this._hasVariableItemDimensions)
                  {
                     if(_loc20_ !== _loc20_)
                     {
                        _loc22_ = _loc14_;
                     }
                     else
                     {
                        _loc22_ = _loc20_;
                     }
                     if(_loc21_ !== _loc21_)
                     {
                        _loc23_ = _loc15_;
                     }
                     else
                     {
                        _loc23_ = _loc21_;
                     }
                  }
                  else
                  {
                     _loc22_ = _loc14_;
                     _loc23_ = _loc15_;
                  }
               }
               else
               {
                  if(_loc18_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc18_).includeInLayout)
                  {
                     continue;
                  }
                  if(_loc18_ is IValidating)
                  {
                     IValidating(_loc18_).validate();
                  }
                  _loc22_ = _loc18_.width;
                  _loc23_ = _loc18_.height;
                  if(this._useVirtualLayout && this._hasVariableItemDimensions)
                  {
                     if(this._hasVariableItemDimensions)
                     {
                        if(_loc22_ != _loc20_)
                        {
                           this._widthCache[_loc12_] = _loc22_;
                           this.dispatchEventWith(Event.CHANGE);
                        }
                        if(_loc23_ != _loc21_)
                        {
                           this._heightCache[_loc12_] = _loc23_;
                           this.dispatchEventWith(Event.CHANGE);
                        }
                     }
                     else
                     {
                        if(_loc14_ >= 0)
                        {
                           _loc22_ = _loc14_;
                        }
                        if(_loc15_ >= 0)
                        {
                           _loc23_ = _loc15_;
                        }
                     }
                  }
               }
               _loc19_ = _loc17_ > 0 && _loc16_ + _loc22_ > param6 - this._paddingRight;
               if(((_loc19_) || param1 < _loc16_ + _loc22_ / 2) && param2 < _loc11_ + _loc23_ + this.gap / 2)
               {
                  break loop0;
               }
               if(_loc19_)
               {
                  break;
               }
               if(_loc23_ > _loc10_)
               {
                  _loc10_ = _loc23_;
               }
               _loc16_ += _loc22_ + _loc8_;
               _loc17_++;
            }
            if(_loc12_ >= _loc13_)
            {
               return _loc13_;
            }
         }
         return _loc12_;
      }
      
      public function positionDropIndicator(param1:DisplayObject, param2:int, param3:Number, param4:Number, param5:Vector.<DisplayObject>, param6:Number, param7:Number) : void
      {
         var _loc15_:Number = NaN;
         var _loc16_:int = 0;
         var _loc17_:DisplayObject = null;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         if(param1 is IValidating)
         {
            IValidating(param1).validate();
         }
         var _loc8_:Number = this._horizontalGap;
         var _loc9_:Number = this._verticalGap;
         var _loc10_:Number = 0;
         var _loc11_:Number = this._paddingTop;
         var _loc12_:int = 0;
         var _loc13_:int = int(param5.length);
         while(true)
         {
            if(_loc12_ > 0)
            {
               if(param4 < _loc11_ + _loc19_ + _loc9_ / 2)
               {
                  break;
               }
               _loc11_ += _loc10_ + _loc9_;
            }
            _loc10_ = 0;
            _loc15_ = this._paddingLeft;
            _loc16_ = 0;
            while(_loc12_ < _loc13_)
            {
               _loc17_ = param5[_loc12_];
               _loc18_ = _loc17_.width;
               _loc19_ = _loc17_.height;
               if(_loc16_ > 0 && _loc15_ + _loc18_ > param6 - this._paddingRight)
               {
                  break;
               }
               if(_loc19_ > _loc10_)
               {
                  _loc10_ = _loc19_;
               }
               if(_loc12_ == param2)
               {
                  param1.x = _loc17_.x - param1.width / 2;
                  param1.y = _loc17_.y;
                  param1.height = _loc17_.height;
                  return;
               }
               _loc15_ += _loc18_ + _loc8_;
               _loc16_++;
               _loc12_++;
            }
            if(_loc12_ >= _loc13_)
            {
               var _loc14_:DisplayObject = param5[_loc13_ - 1];
               param1.x = _loc14_.x + _loc14_.width - param1.width / 2;
               param1.y = _loc14_.y;
               param1.height = _loc14_.height;
               return;
            }
         }
         _loc17_ = param5[_loc12_ - 1];
         param1.x = _loc17_.x + _loc17_.width - param1.width / 2;
         param1.y = _loc17_.y;
         param1.height = _loc17_.height;
      }
      
      override public function resetVariableVirtualCache() : void
      {
         this._widthCache.length = 0;
         this._heightCache.length = 0;
      }
      
      override public function resetVariableVirtualCacheAtIndex(param1:int, param2:DisplayObject = null) : void
      {
         delete this._widthCache[param1];
         delete this._heightCache[param1];
         if(param2)
         {
            this._widthCache[param1] = param2.width;
            this._heightCache[param1] = param2.height;
            this.dispatchEventWith(Event.CHANGE);
         }
      }
      
      override public function addToVariableVirtualCacheAtIndex(param1:int, param2:DisplayObject = null) : void
      {
         var _loc3_:* = param2 !== null ? param2.width : undefined;
         var _loc4_:* = param2 !== null ? param2.height : undefined;
         this._widthCache.insertAt(param1,_loc3_);
         this._heightCache.insertAt(param1,_loc4_);
      }
      
      override public function removeFromVariableVirtualCacheAtIndex(param1:int) : void
      {
         this._widthCache.removeAt(param1);
         this._heightCache.removeAt(param1);
      }
      
      public function getVisibleIndicesAtScrollPosition(param1:Number, param2:Number, param3:Number, param4:Number, param5:int, param6:Vector.<int> = null) : Vector.<int>
      {
         var _loc18_:Number = NaN;
         var _loc19_:int = 0;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
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
         if(this._typicalItem is IValidating)
         {
            IValidating(this._typicalItem).validate();
         }
         var _loc7_:Number = this._typicalItem ? this._typicalItem.width : 0;
         var _loc8_:Number = this._typicalItem ? this._typicalItem.height : 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Number = this._paddingTop;
         var _loc12_:Number = 0;
         var _loc13_:Number = this._verticalGap;
         var _loc14_:Number = param2 + param4;
         var _loc15_:Boolean = this._firstHorizontalGap === this._firstHorizontalGap;
         var _loc16_:Boolean = this._lastHorizontalGap === this._lastHorizontalGap;
         var _loc17_:int = param5 - 2;
         do
         {
            if(_loc10_ > 0)
            {
               _loc11_ += _loc12_ + _loc13_;
               if(_loc11_ >= _loc14_)
               {
                  break;
               }
            }
            _loc12_ = _loc8_;
            _loc18_ = this._paddingLeft;
            _loc19_ = 0;
            while(_loc10_ < param5)
            {
               _loc20_ = this._horizontalGap;
               if(_loc15_ && _loc10_ == 0)
               {
                  _loc20_ = this._firstHorizontalGap;
               }
               else if(_loc16_ && _loc10_ > 0 && _loc10_ == _loc17_)
               {
                  _loc20_ = this._lastHorizontalGap;
               }
               if(this._hasVariableItemDimensions)
               {
                  _loc21_ = Number(this._widthCache[_loc10_]);
                  _loc22_ = Number(this._heightCache[_loc10_]);
               }
               if(this._hasVariableItemDimensions)
               {
                  if(_loc21_ !== _loc21_)
                  {
                     _loc23_ = _loc7_;
                  }
                  else
                  {
                     _loc23_ = _loc21_;
                  }
                  if(_loc22_ !== _loc22_)
                  {
                     _loc24_ = _loc8_;
                  }
                  else
                  {
                     _loc24_ = _loc22_;
                  }
               }
               else
               {
                  _loc23_ = _loc7_;
                  _loc24_ = _loc8_;
               }
               if(_loc19_ > 0 && _loc18_ + _loc23_ > param3 - this._paddingRight)
               {
                  break;
               }
               if(_loc11_ + _loc24_ > param2)
               {
                  param6[_loc9_] = _loc10_;
                  _loc9_++;
               }
               _loc18_ += _loc23_ + _loc20_;
               if(_loc24_ > _loc12_)
               {
                  _loc12_ = _loc24_;
               }
               _loc19_++;
               _loc10_++;
            }
         }
         while(_loc10_ < param5);
         return param6;
      }
      
      protected function calculateMaxScrollYAndRowHeightOfIndex(param1:int, param2:Vector.<DisplayObject>, param3:Number, param4:Number, param5:Number, param6:Number, param7:Point = null) : Point
      {
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:int = 0;
         var _loc19_:DisplayObject = null;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         if(!param7)
         {
            param7 = new Point();
         }
         if(this._useVirtualLayout)
         {
            if(this._typicalItem is IValidating)
            {
               IValidating(this._typicalItem).validate();
            }
            _loc15_ = this._typicalItem ? this._typicalItem.width : 0;
            _loc16_ = this._typicalItem ? this._typicalItem.height : 0;
         }
         var _loc8_:Number = this._horizontalGap;
         var _loc9_:Number = this._verticalGap;
         var _loc10_:Number = 0;
         var _loc11_:Number = param4 + this._paddingTop;
         var _loc12_:int = 0;
         var _loc13_:int = int(param2.length);
         var _loc14_:Boolean = false;
         while(!_loc14_)
         {
            if(_loc12_ > 0)
            {
               _loc11_ += _loc10_ + _loc9_;
            }
            _loc10_ = this._useVirtualLayout ? _loc16_ : 0;
            _loc17_ = param3 + this._paddingLeft;
            _loc18_ = 0;
            for(; _loc12_ < _loc13_; _loc12_++)
            {
               _loc19_ = param2[_loc12_];
               if(this._useVirtualLayout && this._hasVariableItemDimensions)
               {
                  _loc20_ = Number(this._widthCache[_loc12_]);
                  _loc21_ = Number(this._heightCache[_loc12_]);
               }
               if(this._useVirtualLayout && !_loc19_)
               {
                  if(this._hasVariableItemDimensions)
                  {
                     if(_loc20_ !== _loc20_)
                     {
                        _loc22_ = _loc15_;
                     }
                     else
                     {
                        _loc22_ = _loc20_;
                     }
                     if(_loc21_ !== _loc21_)
                     {
                        _loc23_ = _loc16_;
                     }
                     else
                     {
                        _loc23_ = _loc21_;
                     }
                  }
                  else
                  {
                     _loc22_ = _loc15_;
                     _loc23_ = _loc16_;
                  }
               }
               else
               {
                  if(_loc19_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc19_).includeInLayout)
                  {
                     continue;
                  }
                  if(_loc19_ is IValidating)
                  {
                     IValidating(_loc19_).validate();
                  }
                  _loc22_ = _loc19_.width;
                  _loc23_ = _loc19_.height;
                  if(this._useVirtualLayout && this._hasVariableItemDimensions)
                  {
                     if(this._hasVariableItemDimensions)
                     {
                        if(_loc22_ != _loc20_)
                        {
                           this._widthCache[_loc12_] = _loc22_;
                           this.dispatchEventWith(Event.CHANGE);
                        }
                        if(_loc23_ != _loc21_)
                        {
                           this._heightCache[_loc12_] = _loc23_;
                           this.dispatchEventWith(Event.CHANGE);
                        }
                     }
                     else
                     {
                        if(_loc15_ >= 0)
                        {
                           _loc22_ = _loc15_;
                        }
                        if(_loc16_ >= 0)
                        {
                           _loc23_ = _loc16_;
                        }
                     }
                  }
               }
               if(_loc18_ > 0 && _loc17_ + _loc22_ > param5 - this._paddingRight)
               {
                  break;
               }
               if(_loc12_ == param1)
               {
                  _loc14_ = true;
               }
               if(_loc23_ > _loc10_)
               {
                  _loc10_ = _loc23_;
               }
               _loc17_ += _loc22_ + _loc8_;
               _loc18_++;
            }
            if(_loc12_ >= _loc13_)
            {
               break;
            }
         }
         param7.setTo(_loc11_,_loc10_);
         return param7;
      }
   }
}

