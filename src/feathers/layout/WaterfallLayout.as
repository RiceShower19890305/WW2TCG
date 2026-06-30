package feathers.layout
{
   import feathers.core.IValidating;
   import flash.errors.IllegalOperationError;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import starling.display.DisplayObject;
   import starling.events.Event;
   
   public class WaterfallLayout extends BaseVariableVirtualLayout implements IVariableVirtualLayout
   {
      
      protected var _horizontalGap:Number = 0;
      
      protected var _verticalGap:Number = 0;
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var _horizontalAlign:String = "center";
      
      protected var _requestedColumnCount:int = 0;
      
      protected var _heightCache:Array = [];
      
      public function WaterfallLayout()
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
      
      public function layout(param1:Vector.<DisplayObject>, param2:ViewPortBounds = null, param3:LayoutBoundsResult = null) : LayoutBoundsResult
      {
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:DisplayObject = null;
         var _loc28_:int = 0;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc32_:ILayoutDisplayObject = null;
         var _loc33_:Number = NaN;
         var _loc4_:Number = param2 ? param2.x : 0;
         var _loc5_:Number = param2 ? param2.y : 0;
         var _loc6_:Number = param2 ? param2.minWidth : 0;
         var _loc7_:Number = param2 ? param2.minHeight : 0;
         var _loc8_:Number = param2 ? param2.maxWidth : Number.POSITIVE_INFINITY;
         var _loc9_:Number = param2 ? param2.maxHeight : Number.POSITIVE_INFINITY;
         var _loc10_:Number = param2 ? param2.explicitWidth : NaN;
         var _loc11_:Number = param2 ? param2.explicitHeight : NaN;
         var _loc12_:Boolean = _loc10_ !== _loc10_;
         var _loc13_:Boolean = _loc11_ !== _loc11_;
         if(this._useVirtualLayout)
         {
            if(this._typicalItem is IValidating)
            {
               IValidating(this._typicalItem).validate();
            }
            _loc25_ = this._typicalItem ? this._typicalItem.width : 0;
            _loc26_ = this._typicalItem ? this._typicalItem.height : 0;
         }
         var _loc14_:Number = 0;
         if(this._useVirtualLayout)
         {
            _loc14_ = _loc25_;
         }
         else if(param1.length > 0)
         {
            _loc27_ = param1[0];
            if(_loc27_ is IValidating)
            {
               IValidating(_loc27_).validate();
            }
            _loc14_ = _loc27_.width;
         }
         var _loc15_:Number = _loc10_;
         if(_loc12_)
         {
            if(_loc8_ < Number.POSITIVE_INFINITY)
            {
               _loc15_ = _loc8_;
            }
            else if(this._requestedColumnCount > 0)
            {
               _loc15_ = (_loc14_ + this._horizontalGap) * this._requestedColumnCount - this._horizontalGap;
            }
            else
            {
               _loc15_ = _loc14_;
            }
            _loc15_ += this._paddingLeft + this._paddingRight;
            if(_loc15_ < _loc6_)
            {
               _loc15_ = _loc6_;
            }
            else if(_loc15_ > _loc8_)
            {
               _loc15_ = _loc8_;
            }
         }
         var _loc16_:int = int((_loc15_ + this._horizontalGap - this._paddingLeft - this._paddingRight) / (_loc14_ + this._horizontalGap));
         if(this._requestedColumnCount > 0 && _loc16_ > this._requestedColumnCount)
         {
            _loc16_ = this._requestedColumnCount;
         }
         else if(_loc16_ < 1)
         {
            _loc16_ = 1;
         }
         var _loc17_:Vector.<Number> = new Vector.<Number>(0);
         var _loc18_:int = 0;
         while(_loc18_ < _loc16_)
         {
            _loc17_[_loc18_] = this._paddingTop;
            _loc18_++;
         }
         _loc17_.fixed = true;
         var _loc19_:Number = 0;
         if(this._horizontalAlign == HorizontalAlign.RIGHT)
         {
            _loc19_ = _loc15_ - this._paddingLeft - this._paddingRight - (_loc16_ * (_loc14_ + this._horizontalGap) - this._horizontalGap);
         }
         else if(this._horizontalAlign == HorizontalAlign.CENTER)
         {
            _loc19_ = Math.round((_loc15_ - this._paddingLeft - this._paddingRight - (_loc16_ * (_loc14_ + this._horizontalGap) - this._horizontalGap)) / 2);
         }
         var _loc20_:int = int(param1.length);
         var _loc21_:int = 0;
         var _loc22_:Number = _loc17_[_loc21_];
         _loc18_ = 0;
         for(; _loc18_ < _loc20_; _loc18_++)
         {
            _loc27_ = param1[_loc18_];
            if(this._useVirtualLayout && this._hasVariableItemDimensions)
            {
               _loc29_ = Number(this._heightCache[_loc18_]);
            }
            if(this._useVirtualLayout && !_loc27_)
            {
               if(!this._hasVariableItemDimensions || _loc29_ !== _loc29_)
               {
                  _loc30_ = _loc26_;
               }
               else
               {
                  _loc30_ = _loc29_;
               }
            }
            else
            {
               if(_loc27_ is ILayoutDisplayObject)
               {
                  _loc32_ = ILayoutDisplayObject(_loc27_);
                  if(!_loc32_.includeInLayout)
                  {
                     continue;
                  }
               }
               if(_loc27_ is IValidating)
               {
                  IValidating(_loc27_).validate();
               }
               _loc31_ = _loc14_ / _loc27_.width;
               _loc27_.width *= _loc31_;
               if(_loc27_ is IValidating)
               {
                  IValidating(_loc27_).validate();
               }
               if(this._useVirtualLayout)
               {
                  if(this._hasVariableItemDimensions)
                  {
                     _loc30_ = _loc27_.height;
                     if(_loc30_ != _loc29_)
                     {
                        this._heightCache[_loc18_] = _loc30_;
                        this.dispatchEventWith(Event.CHANGE);
                     }
                  }
                  else
                  {
                     _loc27_.height = _loc30_ = _loc26_;
                  }
               }
               else
               {
                  _loc30_ = _loc27_.height;
               }
            }
            _loc22_ += _loc30_;
            _loc28_ = 0;
            while(_loc28_ < _loc16_)
            {
               if(_loc28_ != _loc21_)
               {
                  _loc33_ = _loc17_[_loc28_] + _loc30_;
                  if(_loc33_ < _loc22_)
                  {
                     _loc21_ = _loc28_;
                     _loc22_ = _loc33_;
                  }
               }
               _loc28_++;
            }
            if(_loc27_)
            {
               _loc27_.x = _loc27_.pivotX + _loc4_ + _loc19_ + this._paddingLeft + _loc21_ * (_loc14_ + this._horizontalGap);
               _loc27_.y = _loc27_.pivotY + _loc5_ + _loc22_ - _loc30_;
            }
            _loc22_ += this._verticalGap;
            _loc17_[_loc21_] = _loc22_;
         }
         var _loc23_:Number = _loc17_[0];
         _loc18_ = 1;
         while(_loc18_ < _loc16_)
         {
            _loc33_ = _loc17_[_loc18_];
            if(_loc33_ > _loc23_)
            {
               _loc23_ = _loc33_;
            }
            _loc18_++;
         }
         _loc23_ -= this._verticalGap;
         _loc23_ = _loc23_ + this._paddingBottom;
         if(_loc23_ < 0)
         {
            _loc23_ = 0;
         }
         var _loc24_:Number = _loc11_;
         if(_loc13_)
         {
            _loc24_ = _loc23_;
            if(_loc24_ < _loc7_)
            {
               _loc24_ = _loc7_;
            }
            else if(_loc24_ > _loc9_)
            {
               _loc24_ = _loc9_;
            }
         }
         if(!param3)
         {
            param3 = new LayoutBoundsResult();
         }
         param3.contentX = 0;
         param3.contentWidth = _loc15_;
         param3.contentY = 0;
         param3.contentHeight = _loc23_;
         param3.viewPortWidth = _loc15_;
         param3.viewPortHeight = _loc24_;
         return param3;
      }
      
      public function measureViewPort(param1:int, param2:ViewPortBounds = null, param3:Point = null) : Point
      {
         var _loc17_:Vector.<Number> = null;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:int = 0;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
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
         if(this._typicalItem is IValidating)
         {
            IValidating(this._typicalItem).validate();
         }
         var _loc12_:Number = this._typicalItem ? this._typicalItem.width : 0;
         var _loc13_:Number = this._typicalItem ? this._typicalItem.height : 0;
         var _loc14_:Number = _loc12_;
         var _loc15_:Number = _loc4_;
         if(_loc6_)
         {
            if(_loc10_ < Number.POSITIVE_INFINITY)
            {
               _loc15_ = _loc10_;
            }
            else if(this._requestedColumnCount > 0)
            {
               _loc15_ = (_loc14_ + this._horizontalGap) * this._requestedColumnCount - this._horizontalGap;
            }
            else
            {
               _loc15_ = _loc14_;
            }
            _loc15_ += this._paddingLeft + this._paddingRight;
            if(_loc15_ < _loc8_)
            {
               _loc15_ = _loc8_;
            }
            else if(_loc15_ > _loc10_)
            {
               _loc15_ = _loc10_;
            }
         }
         var _loc16_:int = int((_loc15_ + this._horizontalGap - this._paddingLeft - this._paddingRight) / (_loc14_ + this._horizontalGap));
         if(this._requestedColumnCount > 0 && _loc16_ > this._requestedColumnCount)
         {
            _loc16_ = this._requestedColumnCount;
         }
         else if(_loc16_ < 1)
         {
            _loc16_ = 1;
         }
         if(_loc6_)
         {
            param3.x = this._paddingLeft + this._paddingRight + _loc16_ * (_loc14_ + this._horizontalGap) - this._horizontalGap;
         }
         else
         {
            param3.x = _loc4_;
         }
         if(_loc7_)
         {
            if(this._hasVariableItemDimensions)
            {
               _loc17_ = new Vector.<Number>(0);
               _loc18_ = 0;
               while(_loc18_ < _loc16_)
               {
                  _loc17_[_loc18_] = this._paddingTop;
                  _loc18_++;
               }
               _loc17_.fixed = true;
               _loc19_ = 0;
               _loc20_ = _loc17_[_loc19_];
               _loc18_ = 0;
               while(_loc18_ < param1)
               {
                  if(this._hasVariableItemDimensions)
                  {
                     _loc23_ = Number(this._heightCache[_loc18_]);
                     if(_loc23_ !== _loc23_)
                     {
                        _loc23_ = _loc13_;
                     }
                  }
                  else
                  {
                     _loc23_ = _loc13_;
                  }
                  _loc20_ += _loc23_;
                  _loc22_ = 0;
                  while(_loc22_ < _loc16_)
                  {
                     if(_loc22_ != _loc19_)
                     {
                        _loc24_ = _loc17_[_loc22_] + _loc23_;
                        if(_loc24_ < _loc20_)
                        {
                           _loc19_ = _loc22_;
                           _loc20_ = _loc24_;
                        }
                     }
                     _loc22_++;
                  }
                  _loc20_ += this._verticalGap;
                  _loc17_[_loc19_] = _loc20_;
                  _loc18_++;
               }
               _loc21_ = _loc17_[0];
               _loc18_ = 1;
               while(_loc18_ < _loc16_)
               {
                  _loc24_ = _loc17_[_loc18_];
                  if(_loc24_ > _loc21_)
                  {
                     _loc21_ = _loc24_;
                  }
                  _loc18_++;
               }
               _loc21_ -= this._verticalGap;
               _loc21_ = _loc21_ + this._paddingBottom;
               if(_loc21_ < 0)
               {
                  _loc21_ = 0;
               }
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
               param3.y = this._paddingTop + this._paddingBottom + Math.ceil(param1 / _loc16_) * (_loc13_ + this._verticalGap) - this._verticalGap;
            }
         }
         else
         {
            param3.y = _loc5_;
         }
         return param3;
      }
      
      public function getVisibleIndicesAtScrollPosition(param1:Number, param2:Number, param3:Number, param4:Number, param5:int, param6:Vector.<int> = null) : Vector.<int>
      {
         var _loc15_:Vector.<Number> = null;
         var _loc16_:int = 0;
         var _loc17_:Number = NaN;
         var _loc18_:int = 0;
         var _loc19_:Number = NaN;
         var _loc20_:int = 0;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:int = 0;
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
         var _loc9_:Number = _loc7_;
         var _loc10_:int = int((param3 + this._horizontalGap - this._paddingLeft - this._paddingRight) / (_loc9_ + this._horizontalGap));
         if(this._requestedColumnCount > 0 && _loc10_ > this._requestedColumnCount)
         {
            _loc10_ = this._requestedColumnCount;
         }
         else if(_loc10_ < 1)
         {
            _loc10_ = 1;
         }
         var _loc11_:int = 0;
         if(this._hasVariableItemDimensions)
         {
            _loc15_ = new Vector.<Number>(0);
            _loc16_ = 0;
            while(_loc16_ < _loc10_)
            {
               _loc15_[_loc16_] = this._paddingTop;
               _loc16_++;
            }
            _loc15_.fixed = true;
            _loc17_ = param2 + param4;
            _loc18_ = 0;
            _loc19_ = _loc15_[_loc18_];
            _loc16_ = 0;
            while(_loc16_ < param5)
            {
               if(this._hasVariableItemDimensions)
               {
                  _loc21_ = Number(this._heightCache[_loc16_]);
                  if(_loc21_ !== _loc21_)
                  {
                     _loc21_ = _loc8_;
                  }
               }
               else
               {
                  _loc21_ = _loc8_;
               }
               _loc19_ += _loc21_;
               _loc20_ = 0;
               while(_loc20_ < _loc10_)
               {
                  if(_loc20_ != _loc18_)
                  {
                     _loc22_ = _loc15_[_loc20_] + _loc21_;
                     if(_loc22_ < _loc19_)
                     {
                        _loc18_ = _loc20_;
                        _loc19_ = _loc22_;
                     }
                  }
                  _loc20_++;
               }
               if(_loc19_ > param2 && _loc19_ - _loc21_ < _loc17_)
               {
                  param6[_loc11_] = _loc16_;
                  _loc11_++;
               }
               _loc19_ += this._verticalGap;
               _loc15_[_loc18_] = _loc19_;
               _loc16_++;
            }
            return param6;
         }
         var _loc12_:int = Math.ceil(param4 / (_loc8_ + this._verticalGap)) + 1;
         var _loc13_:int = (param2 - this._paddingTop) / (_loc8_ + this._verticalGap);
         if(_loc13_ < 0)
         {
            _loc13_ = 0;
         }
         var _loc14_:int = _loc13_ + _loc12_;
         if(_loc14_ >= param5)
         {
            _loc14_ = param5 - 1;
         }
         _loc13_ = _loc14_ - _loc12_;
         if(_loc13_ < 0)
         {
            _loc13_ = 0;
         }
         _loc16_ = _loc13_;
         while(_loc16_ <= _loc14_)
         {
            _loc20_ = 0;
            while(_loc20_ < _loc10_)
            {
               _loc23_ = _loc16_ * _loc10_ + _loc20_;
               if(_loc23_ >= 0 && _loc16_ < param5)
               {
                  param6[_loc11_] = _loc23_;
               }
               else if(_loc23_ < 0)
               {
                  param6[_loc11_] = param5 + _loc23_;
               }
               else if(_loc23_ >= param5)
               {
                  param6[_loc11_] = _loc23_ - param5;
               }
               _loc11_++;
               _loc20_++;
            }
            _loc16_++;
         }
         return param6;
      }
      
      public function getNearestScrollPositionForIndex(param1:int, param2:Number, param3:Number, param4:Vector.<DisplayObject>, param5:Number, param6:Number, param7:Number, param8:Number, param9:Point = null) : Point
      {
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc10_:Number = this.calculateMaxScrollYOfIndex(param1,param4,param5,param6,param7,param8);
         if(this._useVirtualLayout)
         {
            if(this._hasVariableItemDimensions)
            {
               _loc12_ = Number(this._heightCache[param1]);
               if(_loc12_ !== _loc12_)
               {
                  _loc12_ = this._typicalItem.height;
               }
            }
            else
            {
               _loc12_ = this._typicalItem.height;
            }
         }
         else
         {
            _loc12_ = param4[param1].height;
         }
         if(!param9)
         {
            param9 = new Point();
         }
         param9.x = 0;
         var _loc11_:Number = _loc10_ - (param8 - _loc12_);
         if(param3 >= _loc11_ && param3 <= _loc10_)
         {
            param9.y = param3;
         }
         else
         {
            _loc13_ = Math.abs(_loc10_ - param3);
            _loc14_ = Math.abs(_loc11_ - param3);
            if(_loc14_ < _loc13_)
            {
               param9.y = _loc11_;
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
         var _loc9_:Number = NaN;
         var _loc8_:Number = this.calculateMaxScrollYOfIndex(param1,param2,param3,param4,param5,param6);
         if(this._useVirtualLayout)
         {
            if(this._hasVariableItemDimensions)
            {
               _loc9_ = Number(this._heightCache[param1]);
               if(_loc9_ !== _loc9_)
               {
                  _loc9_ = this._typicalItem.height;
               }
            }
            else
            {
               _loc9_ = this._typicalItem.height;
            }
         }
         else
         {
            _loc9_ = param2[param1].height;
         }
         if(!param7)
         {
            param7 = new Point();
         }
         param7.x = 0;
         param7.y = _loc8_ - Math.round((param6 - _loc9_) / 2);
         return param7;
      }
      
      protected function calculateMaxScrollYOfIndex(param1:int, param2:Vector.<DisplayObject>, param3:Number, param4:Number, param5:Number, param6:Number) : Number
      {
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:DisplayObject = null;
         var _loc18_:int = 0;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:ILayoutDisplayObject = null;
         var _loc23_:Number = NaN;
         if(param2.length == 0)
         {
            return 0;
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
         var _loc7_:Number = 0;
         if(this._useVirtualLayout)
         {
            _loc7_ = _loc15_;
         }
         else if(param2.length > 0)
         {
            _loc17_ = param2[0];
            if(_loc17_ is IValidating)
            {
               IValidating(_loc17_).validate();
            }
            _loc7_ = _loc17_.width;
         }
         var _loc8_:int = int((param5 + this._horizontalGap - this._paddingLeft - this._paddingRight) / (_loc7_ + this._horizontalGap));
         if(this._requestedColumnCount > 0 && _loc8_ > this._requestedColumnCount)
         {
            _loc8_ = this._requestedColumnCount;
         }
         else if(_loc8_ < 1)
         {
            _loc8_ = 1;
         }
         var _loc9_:Vector.<Number> = new Vector.<Number>(0);
         var _loc10_:int = 0;
         while(_loc10_ < _loc8_)
         {
            _loc9_[_loc10_] = this._paddingTop;
            _loc10_++;
         }
         _loc9_.fixed = true;
         var _loc11_:int = int(param2.length);
         var _loc12_:int = 0;
         var _loc13_:Number = _loc9_[_loc12_];
         _loc10_ = 0;
         for(; _loc10_ < _loc11_; _loc10_++)
         {
            _loc17_ = param2[_loc10_];
            if(this._useVirtualLayout && this._hasVariableItemDimensions)
            {
               _loc19_ = Number(this._heightCache[_loc10_]);
            }
            if(this._useVirtualLayout && !_loc17_)
            {
               if(!this._hasVariableItemDimensions || _loc19_ !== _loc19_)
               {
                  _loc20_ = _loc16_;
               }
               else
               {
                  _loc20_ = _loc19_;
               }
            }
            else
            {
               if(_loc17_ is ILayoutDisplayObject)
               {
                  _loc22_ = ILayoutDisplayObject(_loc17_);
                  if(!_loc22_.includeInLayout)
                  {
                     continue;
                  }
               }
               if(_loc17_ is IValidating)
               {
                  IValidating(_loc17_).validate();
               }
               _loc21_ = _loc7_ / _loc17_.width;
               _loc17_.width *= _loc21_;
               if(_loc17_ is IValidating)
               {
                  IValidating(_loc17_).validate();
               }
               if(this._useVirtualLayout)
               {
                  if(this._hasVariableItemDimensions)
                  {
                     _loc20_ = _loc17_.height;
                     if(_loc20_ != _loc19_)
                     {
                        this._heightCache[_loc10_] = _loc20_;
                        this.dispatchEventWith(Event.CHANGE);
                     }
                  }
                  else
                  {
                     _loc17_.height = _loc20_ = _loc16_;
                  }
               }
               else
               {
                  _loc20_ = _loc17_.height;
               }
            }
            _loc13_ += _loc20_;
            _loc18_ = 0;
            while(_loc18_ < _loc8_)
            {
               if(_loc18_ != _loc12_)
               {
                  _loc23_ = _loc9_[_loc18_] + _loc20_;
                  if(_loc23_ < _loc13_)
                  {
                     _loc12_ = _loc18_;
                     _loc13_ = _loc23_;
                  }
               }
               _loc18_++;
            }
            if(_loc10_ == param1)
            {
               return _loc13_ - _loc20_;
            }
            _loc13_ += this._verticalGap;
            _loc9_[_loc12_] = _loc13_;
         }
         var _loc14_:Number = _loc9_[0];
         _loc10_ = 1;
         while(_loc10_ < _loc8_)
         {
            _loc23_ = _loc9_[_loc10_];
            if(_loc23_ > _loc14_)
            {
               _loc14_ = _loc23_;
            }
            _loc10_++;
         }
         _loc14_ -= this._verticalGap;
         _loc14_ = _loc14_ + this._paddingBottom;
         _loc14_ = _loc14_ - param6;
         if(_loc14_ < 0)
         {
            _loc14_ = 0;
         }
         return _loc14_;
      }
   }
}

