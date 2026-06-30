package feathers.layout
{
   import feathers.core.IValidating;
   import flash.errors.IllegalOperationError;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import starling.display.DisplayObject;
   
   public class TiledRowsLayout extends BaseTiledLayout implements IVirtualLayout, IDragDropLayout
   {
      
      public function TiledRowsLayout()
      {
         super();
      }
      
      override public function get requestedColumnCount() : int
      {
         return this._requestedColumnCount;
      }
      
      override public function get requestedRowCount() : int
      {
         return this._requestedRowCount;
      }
      
      override public function get paging() : String
      {
         return this._paging;
      }
      
      override public function get distributeWidths() : Boolean
      {
         return this._distributeWidths;
      }
      
      override public function get distributeHeights() : Boolean
      {
         return this._distributeHeights;
      }
      
      override public function set distributeHeights(param1:Boolean) : void
      {
         super.distributeHeights = param1;
         if(param1)
         {
            this.useSquareTiles = false;
         }
      }
      
      public function layout(param1:Vector.<DisplayObject>, param2:ViewPortBounds = null, param3:LayoutBoundsResult = null) : LayoutBoundsResult
      {
         var _loc31_:Number = NaN;
         var _loc32_:Number = NaN;
         var _loc33_:int = 0;
         var _loc34_:DisplayObject = null;
         var _loc35_:Number = NaN;
         var _loc36_:Number = NaN;
         var _loc37_:Number = NaN;
         var _loc38_:Number = NaN;
         var _loc39_:Vector.<DisplayObject> = null;
         var _loc40_:int = 0;
         var _loc41_:int = 0;
         var _loc42_:Number = NaN;
         var _loc43_:Number = NaN;
         if(!param3)
         {
            param3 = new LayoutBoundsResult();
         }
         if(param1.length == 0)
         {
            param3.contentX = 0;
            param3.contentY = 0;
            param3.contentWidth = this._paddingLeft + this._paddingRight;
            param3.contentHeight = this._paddingTop + this._paddingBottom;
            param3.viewPortWidth = param3.contentWidth;
            param3.viewPortHeight = param3.contentHeight;
            return param3;
         }
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
            this.prepareTypicalItem();
            _loc31_ = this._typicalItem ? this._typicalItem.width : 0;
            _loc32_ = this._typicalItem ? this._typicalItem.height : 0;
         }
         this.validateItems(param1);
         this._discoveredItemsCache.length = 0;
         var _loc14_:int = int(param1.length);
         var _loc15_:Number = 0;
         var _loc16_:Number = 0;
         if(this._useVirtualLayout)
         {
            _loc15_ = _loc31_;
            _loc16_ = _loc32_;
         }
         else
         {
            _loc33_ = 0;
            while(_loc33_ < _loc14_)
            {
               _loc34_ = param1[_loc33_];
               if(_loc34_)
               {
                  if(!(_loc34_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc34_).includeInLayout))
                  {
                     _loc35_ = _loc34_.width;
                     _loc36_ = _loc34_.height;
                     if(_loc35_ > _loc15_)
                     {
                        _loc15_ = _loc35_;
                     }
                     if(_loc36_ > _loc16_)
                     {
                        _loc16_ = _loc36_;
                     }
                  }
               }
               _loc33_++;
            }
         }
         if(_loc15_ < 0)
         {
            _loc15_ = 0;
         }
         if(_loc16_ < 0)
         {
            _loc16_ = 0;
         }
         if(this._useSquareTiles)
         {
            if(_loc15_ > _loc16_)
            {
               _loc16_ = _loc15_;
            }
            else if(_loc16_ > _loc15_)
            {
               _loc15_ = _loc16_;
            }
         }
         var _loc17_:int = this.calculateHorizontalTileCount(_loc15_,_loc12_,_loc10_,this._paddingLeft + this._paddingRight,this._horizontalGap,this._requestedColumnCount,_loc14_);
         if(_loc12_ === _loc12_)
         {
            _loc37_ = _loc12_;
         }
         else
         {
            _loc37_ = this._paddingLeft + this._paddingRight + (_loc15_ + this._horizontalGap) * _loc17_ - this._horizontalGap;
            if(_loc37_ < _loc8_)
            {
               _loc37_ = _loc8_;
            }
            else if(_loc37_ > _loc10_)
            {
               _loc37_ = _loc10_;
            }
         }
         if(this._distributeWidths)
         {
            _loc15_ = (_loc37_ - this._paddingLeft - this._paddingRight - _loc17_ * this._horizontalGap + this._horizontalGap) / _loc17_;
            if(this._useSquareTiles)
            {
               _loc16_ = _loc15_;
            }
         }
         var _loc18_:int = this.calculateVerticalTileCount(_loc16_,_loc13_,_loc11_,this._paddingTop + this._paddingBottom,this._verticalGap,this._requestedRowCount,_loc14_,_loc17_,this._distributeHeights && !this._useSquareTiles);
         if(_loc13_ === _loc13_)
         {
            _loc38_ = _loc13_;
         }
         else
         {
            _loc38_ = this._paddingTop + this._paddingBottom + (_loc16_ + this._verticalGap) * _loc18_ - this._verticalGap;
            if(_loc38_ < _loc9_)
            {
               _loc38_ = _loc9_;
            }
            else if(_loc38_ > _loc11_)
            {
               _loc38_ = _loc11_;
            }
         }
         if(this._distributeHeights && !this._useSquareTiles)
         {
            _loc16_ = (_loc38_ - this._paddingTop - this._paddingBottom - _loc18_ * this._verticalGap + this._verticalGap) / _loc18_;
         }
         var _loc19_:Number = _loc17_ * (_loc15_ + this._horizontalGap) - this._horizontalGap + this._paddingLeft + this._paddingRight;
         var _loc20_:Number = _loc18_ * (_loc16_ + this._verticalGap) - this._verticalGap + this._paddingTop + this._paddingBottom;
         var _loc21_:Number = _loc6_ + this._paddingLeft;
         var _loc22_:Number = _loc7_ + this._paddingTop;
         var _loc23_:int = _loc17_ * _loc18_;
         var _loc24_:int = 0;
         var _loc25_:int = _loc23_;
         var _loc26_:Number = _loc21_;
         var _loc27_:Number = _loc21_;
         var _loc28_:Number = _loc22_;
         var _loc29_:int = 0;
         var _loc30_:int = 0;
         _loc33_ = 0;
         while(_loc33_ < _loc14_)
         {
            _loc34_ = param1[_loc33_];
            if(!(_loc34_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc34_).includeInLayout))
            {
               if(_loc29_ != 0 && _loc29_ % _loc17_ == 0)
               {
                  _loc27_ = _loc26_;
                  _loc28_ += _loc16_ + this._verticalGap;
               }
               if(_loc29_ == _loc25_)
               {
                  if(this._paging !== Direction.NONE)
                  {
                     _loc39_ = this._useVirtualLayout ? this._discoveredItemsCache : param1;
                     _loc40_ = this._useVirtualLayout ? 0 : int(_loc29_ - _loc23_);
                     _loc41_ = this._useVirtualLayout ? int(this._discoveredItemsCache.length - 1) : int(_loc29_ - 1);
                     this.applyHorizontalAlign(_loc39_,_loc40_,_loc41_,_loc19_,_loc37_);
                     this.applyVerticalAlign(_loc39_,_loc40_,_loc41_,_loc20_,_loc38_);
                     this._discoveredItemsCache.length = 0;
                     _loc30_ = 0;
                  }
                  _loc24_++;
                  _loc25_ += _loc23_;
                  if(this._paging === Direction.HORIZONTAL)
                  {
                     _loc27_ = _loc26_ = _loc21_ + _loc37_ * _loc24_;
                     _loc28_ = _loc22_;
                  }
                  else if(this._paging === Direction.VERTICAL)
                  {
                     _loc28_ = _loc22_ + _loc38_ * _loc24_;
                  }
               }
               if(_loc34_)
               {
                  switch(this._tileHorizontalAlign)
                  {
                     case HorizontalAlign.JUSTIFY:
                        _loc34_.x = _loc34_.pivotX + _loc27_;
                        _loc34_.width = _loc15_;
                        break;
                     case HorizontalAlign.LEFT:
                        _loc34_.x = _loc34_.pivotX + _loc27_;
                        break;
                     case HorizontalAlign.RIGHT:
                        _loc34_.x = _loc34_.pivotX + _loc27_ + _loc15_ - _loc34_.width;
                        break;
                     default:
                        _loc34_.x = _loc34_.pivotX + _loc27_ + Math.round((_loc15_ - _loc34_.width) / 2);
                  }
                  switch(this._tileVerticalAlign)
                  {
                     case VerticalAlign.JUSTIFY:
                        _loc34_.y = _loc34_.pivotY + _loc28_;
                        _loc34_.height = _loc16_;
                        break;
                     case VerticalAlign.TOP:
                        _loc34_.y = _loc34_.pivotY + _loc28_;
                        break;
                     case VerticalAlign.BOTTOM:
                        _loc34_.y = _loc34_.pivotY + _loc28_ + _loc16_ - _loc34_.height;
                        break;
                     default:
                        _loc34_.y = _loc34_.pivotY + _loc28_ + Math.round((_loc16_ - _loc34_.height) / 2);
                  }
                  if(this._useVirtualLayout)
                  {
                     this._discoveredItemsCache[_loc30_] = _loc34_;
                     _loc30_++;
                  }
               }
               _loc27_ += _loc15_ + this._horizontalGap;
               _loc29_++;
            }
            _loc33_++;
         }
         if(this._paging !== Direction.NONE)
         {
            _loc39_ = this._useVirtualLayout ? this._discoveredItemsCache : param1;
            _loc40_ = this._useVirtualLayout ? 0 : int(_loc25_ - _loc23_);
            _loc41_ = this._useVirtualLayout ? int(_loc39_.length - 1) : int(_loc33_ - 1);
            this.applyHorizontalAlign(_loc39_,_loc40_,_loc41_,_loc19_,_loc37_);
            this.applyVerticalAlign(_loc39_,_loc40_,_loc41_,_loc20_,_loc38_);
         }
         if(this._paging === Direction.HORIZONTAL)
         {
            _loc42_ = Math.ceil(_loc14_ / _loc23_) * _loc37_;
         }
         else
         {
            _loc42_ = _loc19_;
         }
         if(this._paging === Direction.HORIZONTAL)
         {
            _loc43_ = _loc38_;
         }
         else if(this._paging === Direction.VERTICAL)
         {
            _loc43_ = Math.ceil(_loc14_ / _loc23_) * _loc38_;
         }
         else
         {
            _loc43_ = _loc28_ + _loc16_ + this._paddingBottom;
            if(_loc43_ < _loc20_)
            {
               _loc43_ = _loc20_;
            }
         }
         if(this._paging === Direction.NONE)
         {
            _loc39_ = this._useVirtualLayout ? this._discoveredItemsCache : param1;
            _loc41_ = _loc39_.length - 1;
            this.applyHorizontalAlign(_loc39_,0,_loc41_,_loc42_,_loc37_);
            this.applyVerticalAlign(_loc39_,0,_loc41_,_loc43_,_loc38_);
         }
         this._discoveredItemsCache.length = 0;
         param3.contentX = 0;
         param3.contentY = 0;
         param3.contentWidth = _loc42_;
         param3.contentHeight = _loc43_;
         param3.viewPortWidth = _loc37_;
         param3.viewPortHeight = _loc38_;
         return param3;
      }
      
      public function measureViewPort(param1:int, param2:ViewPortBounds = null, param3:Point = null) : Point
      {
         var _loc31_:Number = NaN;
         var _loc32_:Number = NaN;
         var _loc33_:Number = NaN;
         var _loc34_:Number = NaN;
         var _loc35_:Number = NaN;
         var _loc36_:Number = NaN;
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
         var _loc8_:Number = param2 ? param2.x : 0;
         var _loc9_:Number = param2 ? param2.y : 0;
         var _loc10_:Number = param2 ? param2.minWidth : 0;
         var _loc11_:Number = param2 ? param2.minHeight : 0;
         var _loc12_:Number = param2 ? param2.maxWidth : Number.POSITIVE_INFINITY;
         var _loc13_:Number = param2 ? param2.maxHeight : Number.POSITIVE_INFINITY;
         this.prepareTypicalItem();
         var _loc14_:Number = this._typicalItem ? this._typicalItem.width : 0;
         var _loc15_:Number = this._typicalItem ? this._typicalItem.height : 0;
         var _loc16_:Number = _loc14_;
         var _loc17_:Number = _loc15_;
         if(_loc16_ < 0)
         {
            _loc16_ = 0;
         }
         if(_loc17_ < 0)
         {
            _loc17_ = 0;
         }
         if(this._useSquareTiles)
         {
            if(_loc16_ > _loc17_)
            {
               _loc17_ = _loc16_;
            }
            else if(_loc17_ > _loc16_)
            {
               _loc16_ = _loc17_;
            }
         }
         var _loc18_:int = this.calculateHorizontalTileCount(_loc16_,_loc4_,_loc12_,this._paddingLeft + this._paddingRight,this._horizontalGap,this._requestedColumnCount,param1);
         var _loc19_:int = this.calculateVerticalTileCount(_loc17_,_loc5_,_loc13_,this._paddingTop + this._paddingBottom,this._verticalGap,this._requestedRowCount,param1,_loc18_,this._distributeHeights && !this._useSquareTiles);
         if(_loc4_ === _loc4_)
         {
            _loc31_ = _loc4_;
         }
         else
         {
            _loc31_ = this._paddingLeft + this._paddingRight + (_loc16_ + this._horizontalGap) * _loc18_ - this._horizontalGap;
            if(_loc31_ < _loc10_)
            {
               _loc31_ = _loc10_;
            }
            else if(_loc31_ > _loc12_)
            {
               _loc31_ = _loc12_;
            }
         }
         if(_loc5_ === _loc5_)
         {
            _loc32_ = _loc5_;
         }
         else
         {
            _loc32_ = this._paddingTop + this._paddingBottom + (_loc17_ + this._verticalGap) * _loc19_ - this._verticalGap;
            if(_loc32_ < _loc11_)
            {
               _loc32_ = _loc11_;
            }
            else if(_loc32_ > _loc13_)
            {
               _loc32_ = _loc13_;
            }
         }
         var _loc20_:Number = _loc18_ * (_loc16_ + this._horizontalGap) - this._horizontalGap + this._paddingLeft + this._paddingRight;
         var _loc21_:Number = _loc19_ * (_loc17_ + this._verticalGap) - this._verticalGap + this._paddingTop + this._paddingBottom;
         var _loc22_:Number = _loc8_ + this._paddingLeft;
         var _loc23_:Number = _loc9_ + this._paddingTop;
         var _loc24_:int = _loc18_ * _loc19_;
         var _loc25_:int = 0;
         var _loc26_:int = _loc24_;
         var _loc27_:Number = _loc22_;
         var _loc28_:Number = _loc22_;
         var _loc29_:Number = _loc23_;
         var _loc30_:int = 0;
         while(_loc30_ < param1)
         {
            if(_loc30_ != 0 && _loc30_ % _loc18_ == 0)
            {
               _loc28_ = _loc27_;
               _loc29_ += _loc17_ + this._verticalGap;
            }
            if(_loc30_ == _loc26_)
            {
               _loc25_++;
               _loc26_ += _loc24_;
               if(this._paging === Direction.HORIZONTAL)
               {
                  _loc28_ = _loc27_ = _loc22_ + _loc31_ * _loc25_;
                  _loc29_ = _loc23_;
               }
               else if(this._paging === Direction.VERTICAL)
               {
                  _loc29_ = _loc23_ + _loc32_ * _loc25_;
               }
            }
            _loc30_++;
         }
         if(this._paging === Direction.HORIZONTAL)
         {
            _loc33_ = Math.ceil(param1 / _loc24_) * _loc31_;
         }
         else
         {
            _loc33_ = _loc20_;
         }
         if(this._paging === Direction.HORIZONTAL)
         {
            _loc34_ = _loc32_;
         }
         else if(this._paging === Direction.VERTICAL)
         {
            _loc34_ = Math.ceil(param1 / _loc24_) * _loc32_;
         }
         else
         {
            _loc34_ = _loc29_ + _loc17_ + this._paddingBottom;
            if(_loc34_ < _loc21_)
            {
               _loc34_ = _loc21_;
            }
         }
         if(_loc6_)
         {
            _loc35_ = _loc33_;
            if(_loc35_ < _loc10_)
            {
               _loc35_ = _loc10_;
            }
            else if(_loc35_ > _loc12_)
            {
               _loc35_ = _loc12_;
            }
            param3.x = _loc35_;
         }
         else
         {
            param3.x = _loc4_;
         }
         if(_loc7_)
         {
            _loc36_ = _loc34_;
            if(_loc36_ < _loc11_)
            {
               _loc36_ = _loc11_;
            }
            else if(_loc36_ > _loc13_)
            {
               _loc36_ = _loc13_;
            }
            param3.y = _loc36_;
         }
         else
         {
            param3.y = _loc5_;
         }
         return param3;
      }
      
      public function getVisibleIndicesAtScrollPosition(param1:Number, param2:Number, param3:Number, param4:Number, param5:int, param6:Vector.<int> = null) : Vector.<int>
      {
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
         if(this._paging === Direction.HORIZONTAL)
         {
            this.getVisibleIndicesAtScrollPositionWithHorizontalPaging(param1,param2,param3,param4,param5,param6);
         }
         else if(this._paging === Direction.VERTICAL)
         {
            this.getVisibleIndicesAtScrollPositionWithVerticalPaging(param1,param2,param3,param4,param5,param6);
         }
         else
         {
            this.getVisibleIndicesAtScrollPositionWithoutPaging(param1,param2,param3,param4,param5,param6);
         }
         return param6;
      }
      
      public function calculateNavigationDestination(param1:Vector.<DisplayObject>, param2:int, param3:uint, param4:LayoutBoundsResult) : int
      {
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:int = 0;
         var _loc19_:DisplayObject = null;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:int = 0;
         var _loc5_:int = int(param1.length);
         if(param3 == Keyboard.HOME)
         {
            return 0;
         }
         if(param3 == Keyboard.END)
         {
            return _loc5_ - 1;
         }
         if(this._useVirtualLayout)
         {
            this.prepareTypicalItem();
            _loc16_ = this._typicalItem ? this._typicalItem.width : 0;
            _loc17_ = this._typicalItem ? this._typicalItem.height : 0;
         }
         this.validateItems(param1);
         this._discoveredItemsCache.length = 0;
         var _loc6_:Number = 0;
         var _loc7_:Number = 0;
         if(this._useVirtualLayout)
         {
            _loc6_ = _loc16_;
            _loc7_ = _loc17_;
         }
         else
         {
            _loc18_ = 0;
            while(_loc18_ < _loc5_)
            {
               _loc19_ = param1[_loc18_];
               if(_loc19_)
               {
                  if(!(_loc19_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc19_).includeInLayout))
                  {
                     _loc20_ = _loc19_.width;
                     _loc21_ = _loc19_.height;
                     if(_loc20_ > _loc6_)
                     {
                        _loc6_ = _loc20_;
                     }
                     if(_loc21_ > _loc7_)
                     {
                        _loc7_ = _loc21_;
                     }
                  }
               }
               _loc18_++;
            }
         }
         if(_loc6_ < 0)
         {
            _loc6_ = 0;
         }
         if(_loc7_ < 0)
         {
            _loc7_ = 0;
         }
         if(this._useSquareTiles)
         {
            if(_loc6_ > _loc7_)
            {
               _loc7_ = _loc6_;
            }
            else if(_loc7_ > _loc6_)
            {
               _loc6_ = _loc7_;
            }
         }
         var _loc8_:Number = param4.viewPortWidth;
         var _loc9_:int;
         var _loc10_:int = _loc9_ = this.calculateHorizontalTileCount(_loc6_,_loc8_,Number.POSITIVE_INFINITY,this._paddingLeft + this._paddingRight,this._horizontalGap,this._requestedColumnCount,_loc5_);
         var _loc11_:int = this.calculateVerticalTileCount(_loc7_,param4.viewPortHeight,Number.POSITIVE_INFINITY,this._paddingTop + this._paddingBottom,this._verticalGap,this._requestedRowCount,_loc5_,_loc10_,this._distributeHeights && !this._useSquareTiles);
         var _loc12_:int = Math.ceil(_loc5_ / _loc9_);
         var _loc13_:* = int(param2 / _loc10_);
         var _loc14_:* = int(param2 % _loc10_);
         if(this._paging === Direction.HORIZONTAL)
         {
            _loc12_ = _loc11_;
            _loc22_ = _loc10_ * _loc11_;
            _loc23_ = Math.ceil(_loc5_ / _loc22_);
            _loc9_ *= _loc23_;
            while(_loc13_ >= _loc12_)
            {
               _loc13_ -= _loc12_;
               _loc14_ += _loc10_;
            }
         }
         if(param3 == Keyboard.PAGE_UP)
         {
            if(this._paging === Direction.HORIZONTAL)
            {
               _loc14_ -= _loc10_;
            }
            else
            {
               _loc13_ -= _loc11_;
            }
         }
         else if(param3 == Keyboard.PAGE_DOWN)
         {
            if(this._paging === Direction.HORIZONTAL)
            {
               _loc14_ += _loc10_;
            }
            else
            {
               _loc13_ += _loc11_;
            }
         }
         else if(param3 == Keyboard.UP)
         {
            _loc13_--;
         }
         else if(param3 == Keyboard.DOWN)
         {
            _loc13_++;
         }
         else if(param3 == Keyboard.LEFT)
         {
            _loc14_--;
         }
         else if(param3 == Keyboard.RIGHT)
         {
            _loc14_++;
         }
         if(_loc13_ < 0)
         {
            _loc13_ = 0;
         }
         else if(_loc13_ >= _loc12_)
         {
            _loc13_ = int(_loc12_ - 1);
         }
         if(_loc14_ < 0)
         {
            _loc14_ = 0;
         }
         else if(_loc14_ >= _loc9_)
         {
            _loc14_ = int(_loc9_ - 1);
         }
         if(this._paging === Direction.HORIZONTAL)
         {
            while(_loc14_ >= _loc10_)
            {
               _loc14_ -= _loc10_;
               _loc13_ += _loc12_;
            }
         }
         var _loc15_:int = _loc13_ * _loc10_ + _loc14_;
         if(_loc15_ >= _loc5_)
         {
            _loc15_ = _loc5_ - 1;
         }
         return _loc15_;
      }
      
      public function getNearestScrollPositionForIndex(param1:int, param2:Number, param3:Number, param4:Vector.<DisplayObject>, param5:Number, param6:Number, param7:Number, param8:Number, param9:Point = null) : Point
      {
         return this.calculateScrollPositionForIndex(param1,param4,param5,param6,param7,param8,param9,true,param2,param3);
      }
      
      public function getScrollPositionForIndex(param1:int, param2:Vector.<DisplayObject>, param3:Number, param4:Number, param5:Number, param6:Number, param7:Point = null) : Point
      {
         return this.calculateScrollPositionForIndex(param1,param2,param3,param4,param5,param6,param7,false);
      }
      
      public function getDropIndex(param1:Number, param2:Number, param3:Vector.<DisplayObject>, param4:Number, param5:Number, param6:Number, param7:Number) : int
      {
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:int = 0;
         var _loc27_:DisplayObject = null;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc30_:int = 0;
         if(this._useVirtualLayout)
         {
            this.prepareTypicalItem();
            _loc24_ = this._typicalItem ? this._typicalItem.width : 0;
            _loc25_ = this._typicalItem ? this._typicalItem.height : 0;
         }
         var _loc8_:int = int(param3.length);
         var _loc9_:Number = this._useVirtualLayout ? _loc24_ : 0;
         var _loc10_:Number = this._useVirtualLayout ? _loc25_ : 0;
         if(!this._useVirtualLayout)
         {
            _loc26_ = 0;
            while(_loc26_ < _loc8_)
            {
               _loc27_ = param3[_loc26_];
               if(_loc27_)
               {
                  if(!(_loc27_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc27_).includeInLayout))
                  {
                     _loc28_ = _loc27_.width;
                     _loc29_ = _loc27_.height;
                     if(_loc28_ > _loc9_)
                     {
                        _loc9_ = _loc28_;
                     }
                     if(_loc29_ > _loc10_)
                     {
                        _loc10_ = _loc29_;
                     }
                  }
               }
               _loc26_++;
            }
         }
         if(_loc9_ < 0)
         {
            _loc9_ = 0;
         }
         if(_loc10_ < 0)
         {
            _loc10_ = 0;
         }
         if(this._useSquareTiles)
         {
            if(_loc9_ > _loc10_)
            {
               _loc10_ = _loc9_;
            }
            else if(_loc10_ > _loc9_)
            {
               _loc9_ = _loc10_;
            }
         }
         var _loc11_:int = (param6 - this._paddingLeft - this._paddingRight + this._horizontalGap) / (_loc9_ + this._horizontalGap);
         if(_loc11_ < 1)
         {
            _loc11_ = 1;
         }
         else if(this._requestedColumnCount > 0 && _loc11_ > this._requestedColumnCount)
         {
            _loc11_ = this._requestedColumnCount;
         }
         var _loc12_:int = (param7 - this._paddingTop - this._paddingBottom + this._verticalGap) / (_loc10_ + this._verticalGap);
         if(_loc12_ < 1)
         {
            _loc12_ = 1;
         }
         else if(this._requestedRowCount > 0 && _loc12_ > this._requestedRowCount)
         {
            _loc12_ = this._requestedRowCount;
         }
         var _loc13_:Number = _loc11_ * _loc12_;
         var _loc14_:Number = param4 + this._paddingLeft;
         var _loc15_:int = _loc11_;
         if(_loc15_ > _loc8_)
         {
            _loc15_ = _loc8_;
         }
         if(this._horizontalAlign == HorizontalAlign.RIGHT)
         {
            _loc14_ = param4 + this._paddingLeft + (param6 - this._paddingLeft - this._paddingRight) - (_loc15_ * (_loc9_ + this._horizontalGap) - this._horizontalGap);
         }
         else if(this._horizontalAlign == HorizontalAlign.CENTER)
         {
            _loc14_ = param4 + this._paddingLeft + (param6 - this._paddingLeft - this._paddingRight - (_loc15_ * (_loc9_ + this._horizontalGap) - this._horizontalGap)) / 2;
         }
         var _loc16_:Number = param5 + this._paddingTop;
         if(this._paging != Direction.NONE || _loc8_ <= _loc13_)
         {
            _loc30_ = _loc12_;
            if(_loc8_ <= _loc13_)
            {
               _loc30_ = Math.ceil(_loc8_ / _loc15_);
            }
            if(this._verticalAlign == VerticalAlign.BOTTOM)
            {
               _loc16_ = param5 + this._paddingTop + (param7 - this._paddingTop - this._paddingBottom) - (_loc30_ * (_loc10_ + this._verticalGap) - this._verticalGap);
            }
            else if(this._verticalAlign == VerticalAlign.MIDDLE)
            {
               _loc16_ = param5 + this._paddingTop + (param7 - this._paddingTop - this._paddingBottom - (_loc30_ * (_loc10_ + this._verticalGap) - this._verticalGap)) / 2;
            }
         }
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = int((_loc8_ - 1) / _loc11_);
         var _loc20_:int = _loc13_;
         var _loc21_:Number = _loc14_;
         var _loc22_:Number = _loc14_;
         var _loc23_:Number = _loc16_;
         _loc26_ = 0;
         while(_loc26_ < _loc8_)
         {
            _loc27_ = param3[_loc26_];
            if(!(_loc27_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc27_).includeInLayout))
            {
               if(_loc26_ != 0 && _loc26_ % _loc11_ == 0)
               {
                  if(param1 < _loc21_ + param6 && param2 < _loc23_ + _loc10_ + this._verticalGap / 2)
                  {
                     return _loc26_;
                  }
                  _loc22_ = _loc21_;
                  _loc23_ += _loc10_ + this._verticalGap;
                  _loc18_++;
               }
               if(_loc26_ == _loc20_)
               {
                  _loc17_++;
                  _loc20_ += _loc13_;
                  if(this._paging === Direction.HORIZONTAL)
                  {
                     _loc22_ = _loc21_ = _loc14_ + param6 * _loc17_;
                     _loc23_ = _loc16_;
                  }
                  else if(this._paging === Direction.VERTICAL)
                  {
                     _loc23_ = _loc16_ + param7 * _loc17_;
                  }
               }
               if(param1 < _loc22_ + _loc9_ / 2 && (param2 < _loc23_ + _loc10_ + this._verticalGap / 2 || _loc18_ == _loc19_))
               {
                  return _loc26_;
               }
               _loc22_ += _loc9_ + this._horizontalGap;
            }
            _loc26_++;
         }
         return _loc26_;
      }
      
      public function positionDropIndicator(param1:DisplayObject, param2:int, param3:Number, param4:Number, param5:Vector.<DisplayObject>, param6:Number, param7:Number) : void
      {
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:int = 0;
         var _loc28_:DisplayObject = null;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:int = 0;
         if(this._useVirtualLayout)
         {
            this.prepareTypicalItem();
            _loc25_ = this._typicalItem ? this._typicalItem.width : 0;
            _loc26_ = this._typicalItem ? this._typicalItem.height : 0;
         }
         var _loc8_:int = int(param5.length);
         var _loc9_:Number = this._useVirtualLayout ? _loc25_ : 0;
         var _loc10_:Number = this._useVirtualLayout ? _loc26_ : 0;
         if(!this._useVirtualLayout)
         {
            _loc27_ = 0;
            while(_loc27_ < _loc8_)
            {
               _loc28_ = param5[_loc27_];
               if(_loc28_)
               {
                  if(!(_loc28_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc28_).includeInLayout))
                  {
                     _loc29_ = _loc28_.width;
                     _loc30_ = _loc28_.height;
                     if(_loc29_ > _loc9_)
                     {
                        _loc9_ = _loc29_;
                     }
                     if(_loc30_ > _loc10_)
                     {
                        _loc10_ = _loc30_;
                     }
                  }
               }
               _loc27_++;
            }
         }
         if(_loc9_ < 0)
         {
            _loc9_ = 0;
         }
         if(_loc10_ < 0)
         {
            _loc10_ = 0;
         }
         if(this._useSquareTiles)
         {
            if(_loc9_ > _loc10_)
            {
               _loc10_ = _loc9_;
            }
            else if(_loc10_ > _loc9_)
            {
               _loc9_ = _loc10_;
            }
         }
         var _loc11_:int = (param6 - this._paddingLeft - this._paddingRight + this._horizontalGap) / (_loc9_ + this._horizontalGap);
         if(_loc11_ < 1)
         {
            _loc11_ = 1;
         }
         else if(this._requestedColumnCount > 0 && _loc11_ > this._requestedColumnCount)
         {
            _loc11_ = this._requestedColumnCount;
         }
         var _loc12_:int = (param7 - this._paddingTop - this._paddingBottom + this._verticalGap) / (_loc10_ + this._verticalGap);
         if(_loc12_ < 1)
         {
            _loc12_ = 1;
         }
         else if(this._requestedRowCount > 0 && _loc12_ > this._requestedRowCount)
         {
            _loc12_ = this._requestedRowCount;
         }
         var _loc13_:Number = _loc11_ * _loc12_;
         var _loc14_:Number = this._paddingLeft;
         var _loc15_:int = _loc11_;
         if(_loc15_ > _loc8_)
         {
            _loc15_ = _loc8_;
         }
         if(this._horizontalAlign == HorizontalAlign.RIGHT)
         {
            _loc14_ = this._paddingLeft + (param6 - this._paddingLeft - this._paddingRight) - (_loc15_ * (_loc9_ + this._horizontalGap) - this._horizontalGap);
         }
         else if(this._horizontalAlign == HorizontalAlign.CENTER)
         {
            _loc14_ = this._paddingLeft + (param6 - this._paddingLeft - this._paddingRight - (_loc15_ * (_loc9_ + this._horizontalGap) - this._horizontalGap)) / 2;
         }
         var _loc16_:Number = this._paddingTop;
         if(this._paging != Direction.NONE || _loc8_ <= _loc13_)
         {
            _loc31_ = _loc12_;
            if(_loc8_ <= _loc13_)
            {
               _loc31_ = Math.ceil(_loc8_ / _loc15_);
            }
            if(this._verticalAlign == VerticalAlign.BOTTOM)
            {
               _loc16_ = this._paddingTop + (param7 - this._paddingTop - this._paddingBottom) - (_loc31_ * (_loc10_ + this._verticalGap) - this._verticalGap);
            }
            else if(this._verticalAlign == VerticalAlign.MIDDLE)
            {
               _loc16_ = this._paddingTop + (param7 - this._paddingTop - this._paddingBottom - (_loc31_ * (_loc10_ + this._verticalGap) - this._verticalGap)) / 2;
            }
         }
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = int((_loc8_ - 1) / _loc11_);
         var _loc20_:int = _loc13_;
         var _loc21_:Number = _loc14_;
         var _loc22_:Number = _loc14_;
         var _loc23_:Number = _loc16_;
         var _loc24_:int = 0;
         _loc27_ = 0;
         while(_loc27_ < _loc8_)
         {
            _loc28_ = param5[_loc27_];
            if(!(_loc28_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc28_).includeInLayout))
            {
               if(_loc27_ != 0 && _loc27_ % _loc11_ == 0)
               {
                  _loc22_ = _loc21_;
                  _loc23_ += _loc10_ + this._verticalGap;
                  _loc24_ = 0;
                  _loc18_++;
               }
               if(_loc27_ == _loc20_)
               {
                  _loc17_++;
                  _loc20_ += _loc13_;
                  if(this._paging === Direction.HORIZONTAL)
                  {
                     _loc22_ = _loc21_ = _loc14_ + param6 * _loc17_;
                     _loc23_ = _loc16_;
                  }
                  else if(this._paging === Direction.VERTICAL)
                  {
                     _loc23_ = _loc16_ + param7 * _loc17_;
                  }
               }
               if(param3 < _loc22_ + _loc9_ / 2 && (param4 < _loc23_ + _loc10_ + this._verticalGap / 2 || _loc18_ == _loc19_))
               {
                  param1.x = _loc22_ - param1.width / 2;
                  param1.y = _loc23_;
                  param1.height = _loc10_;
                  return;
               }
               _loc22_ += _loc9_ + this._horizontalGap;
               if(_loc24_ > 0 && param3 < _loc22_ + _loc9_ / 2 && param3 < _loc21_ + param6 && _loc22_ + _loc9_ > param6 - this._paddingRight && param4 < _loc23_ + _loc10_ + this._verticalGap / 2)
               {
                  param1.x = _loc22_ - this._horizontalGap - param1.width / 2;
                  param1.y = _loc23_;
                  param1.height = _loc10_;
                  return;
               }
               _loc24_++;
            }
            _loc27_++;
         }
         param1.x = _loc22_ - param1.width / 2;
         param1.y = _loc23_;
         param1.height = _loc10_;
      }
      
      protected function applyHorizontalAlign(param1:Vector.<DisplayObject>, param2:int, param3:int, param4:Number, param5:Number) : void
      {
         var _loc7_:int = 0;
         var _loc8_:DisplayObject = null;
         if(param4 >= param5)
         {
            return;
         }
         var _loc6_:Number = 0;
         if(this._horizontalAlign === HorizontalAlign.RIGHT)
         {
            _loc6_ = param5 - param4;
         }
         else if(this._horizontalAlign !== HorizontalAlign.LEFT)
         {
            _loc6_ = Math.round((param5 - param4) / 2);
         }
         if(_loc6_ != 0)
         {
            _loc7_ = param2;
            while(_loc7_ <= param3)
            {
               _loc8_ = param1[_loc7_];
               if(!(_loc8_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc8_).includeInLayout))
               {
                  _loc8_.x += _loc6_;
               }
               _loc7_++;
            }
         }
      }
      
      protected function applyVerticalAlign(param1:Vector.<DisplayObject>, param2:int, param3:int, param4:Number, param5:Number) : void
      {
         var _loc7_:int = 0;
         var _loc8_:DisplayObject = null;
         if(param4 >= param5)
         {
            return;
         }
         var _loc6_:Number = 0;
         if(this._verticalAlign === VerticalAlign.BOTTOM)
         {
            _loc6_ = param5 - param4;
         }
         else if(this._verticalAlign === VerticalAlign.MIDDLE)
         {
            _loc6_ = Math.round((param5 - param4) / 2);
         }
         if(_loc6_ != 0)
         {
            _loc7_ = param2;
            while(_loc7_ <= param3)
            {
               _loc8_ = param1[_loc7_];
               if(!(_loc8_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc8_).includeInLayout))
               {
                  _loc8_.y += _loc6_;
               }
               _loc7_++;
            }
         }
      }
      
      protected function getVisibleIndicesAtScrollPositionWithHorizontalPaging(param1:Number, param2:Number, param3:Number, param4:Number, param5:int, param6:Vector.<int>) : void
      {
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:int = 0;
         var _loc28_:int = 0;
         this.prepareTypicalItem();
         var _loc7_:Number = this._typicalItem ? this._typicalItem.width : 0;
         var _loc8_:Number = this._typicalItem ? this._typicalItem.height : 0;
         var _loc9_:Number = _loc7_;
         var _loc10_:Number = _loc8_;
         if(_loc9_ < 0)
         {
            _loc9_ = 0;
         }
         if(_loc10_ < 0)
         {
            _loc10_ = 0;
         }
         if(this._useSquareTiles)
         {
            if(_loc9_ > _loc10_)
            {
               _loc10_ = _loc9_;
            }
            else if(_loc10_ > _loc9_)
            {
               _loc9_ = _loc10_;
            }
         }
         var _loc11_:int = this.calculateHorizontalTileCount(_loc9_,param3,param3,this._paddingLeft + this._paddingRight,this._horizontalGap,this._requestedColumnCount,param5);
         if(this._distributeWidths)
         {
            _loc9_ = (param3 - this._paddingLeft - this._paddingRight - _loc11_ * this._horizontalGap + this._horizontalGap) / _loc11_;
            if(this._useSquareTiles)
            {
               _loc10_ = _loc9_;
            }
         }
         var _loc12_:int = this.calculateVerticalTileCount(_loc10_,param4,param4,this._paddingTop + this._paddingBottom,this._verticalGap,this._requestedRowCount,param5,_loc11_,this._distributeHeights && !this._useSquareTiles);
         if(this._distributeHeights && !this._useSquareTiles)
         {
            _loc10_ = (param4 - this._paddingTop - this._paddingBottom - _loc12_ * this._verticalGap + this._verticalGap) / _loc12_;
         }
         var _loc13_:int = _loc11_ * _loc12_;
         var _loc14_:int = _loc13_ + 2 * _loc12_;
         if(_loc14_ > param5)
         {
            _loc14_ = param5;
         }
         var _loc15_:int = Math.round(param1 / param3);
         var _loc16_:int = _loc15_ * _loc13_;
         var _loc17_:Number = _loc11_ * (_loc9_ + this._horizontalGap) - this._horizontalGap;
         var _loc18_:Number = 0;
         var _loc19_:Number = 0;
         if(_loc17_ < param3)
         {
            if(this._horizontalAlign === HorizontalAlign.RIGHT)
            {
               _loc18_ = param3 - this._paddingLeft - this._paddingRight - _loc17_;
               _loc19_ = 0;
            }
            else if(this._horizontalAlign === HorizontalAlign.CENTER)
            {
               _loc18_ = _loc19_ = Math.round((param3 - this._paddingLeft - this._paddingRight - _loc17_) / 2);
            }
            else
            {
               _loc18_ = 0;
               _loc19_ = param3 - this._paddingLeft - this._paddingRight - _loc17_;
            }
         }
         var _loc20_:int = 0;
         var _loc21_:Number = _loc15_ * param3;
         var _loc22_:Number = param1 - _loc21_;
         if(_loc22_ < 0)
         {
            _loc22_ = -_loc22_ - this._paddingRight - _loc19_;
            if(_loc22_ < 0)
            {
               _loc22_ = 0;
            }
            _loc20_ = -Math.floor(_loc22_ / (_loc9_ + this._horizontalGap)) - 1;
            _loc16_ += -_loc13_ + _loc11_ + _loc20_;
         }
         else if(_loc22_ > 0)
         {
            _loc22_ = _loc22_ - this._paddingLeft - _loc18_;
            if(_loc22_ < 0)
            {
               _loc22_ = 0;
            }
            _loc20_ = Math.floor(_loc22_ / (_loc9_ + this._horizontalGap));
            _loc16_ += _loc20_;
         }
         if(_loc16_ < 0)
         {
            _loc16_ = 0;
            _loc20_ = 0;
         }
         if(_loc16_ + _loc14_ >= param5)
         {
            _loc23_ = int(param6.length);
            _loc24_ = _loc16_ = param5 - _loc14_;
            while(_loc24_ < param5)
            {
               param6[_loc23_] = _loc24_;
               _loc23_++;
               _loc24_++;
            }
         }
         else
         {
            _loc25_ = 0;
            _loc26_ = (_loc11_ + _loc20_) % _loc11_;
            _loc27_ = int(_loc16_ / _loc13_) * _loc13_;
            _loc24_ = _loc16_;
            _loc28_ = 0;
            do
            {
               if(_loc24_ < param5)
               {
                  param6[_loc28_] = _loc24_;
                  _loc28_++;
               }
               if(++_loc25_ == _loc12_)
               {
                  _loc25_ = 0;
                  if(++_loc26_ == _loc11_)
                  {
                     _loc26_ = 0;
                     _loc27_ += _loc13_;
                  }
                  _loc24_ = _loc27_ + _loc26_ - _loc11_;
               }
               _loc24_ += _loc11_;
            }
            while(_loc28_ < _loc14_ && _loc27_ < param5);
         }
      }
      
      protected function getVisibleIndicesAtScrollPositionWithVerticalPaging(param1:Number, param2:Number, param3:Number, param4:Number, param5:int, param6:Vector.<int>) : void
      {
         this.prepareTypicalItem();
         var _loc7_:Number = this._typicalItem ? this._typicalItem.width : 0;
         var _loc8_:Number = this._typicalItem ? this._typicalItem.height : 0;
         var _loc9_:Number = _loc7_;
         var _loc10_:Number = _loc8_;
         if(_loc9_ < 0)
         {
            _loc9_ = 0;
         }
         if(_loc10_ < 0)
         {
            _loc10_ = 0;
         }
         if(this._useSquareTiles)
         {
            if(_loc9_ > _loc10_)
            {
               _loc10_ = _loc9_;
            }
            else if(_loc10_ > _loc9_)
            {
               _loc9_ = _loc10_;
            }
         }
         var _loc11_:int = this.calculateHorizontalTileCount(_loc9_,param3,param3,this._paddingLeft + this._paddingRight,this._horizontalGap,this._requestedColumnCount,param5);
         if(this._distributeWidths)
         {
            _loc9_ = (param3 - this._paddingLeft - this._paddingRight - _loc11_ * this._horizontalGap + this._horizontalGap) / _loc11_;
            if(this._useSquareTiles)
            {
               _loc10_ = _loc9_;
            }
         }
         var _loc12_:int = this.calculateVerticalTileCount(_loc10_,param4,param4,this._paddingTop + this._paddingBottom,this._verticalGap,this._requestedRowCount,param5,_loc11_,this._distributeHeights && !this._useSquareTiles);
         if(this._distributeHeights && !this._useSquareTiles)
         {
            _loc10_ = (param4 - this._paddingTop - this._paddingBottom - _loc12_ * this._verticalGap + this._verticalGap) / _loc12_;
         }
         var _loc13_:int = _loc11_ * _loc12_;
         var _loc14_:int = _loc13_ + 2 * _loc11_;
         if(_loc14_ > param5)
         {
            _loc14_ = param5;
         }
         var _loc15_:int = Math.round(param2 / param4);
         var _loc16_:int = _loc15_ * _loc13_;
         var _loc17_:Number = _loc12_ * (_loc10_ + this._verticalGap) - this._verticalGap;
         var _loc18_:Number = 0;
         var _loc19_:Number = 0;
         if(_loc17_ < param4)
         {
            if(this._verticalAlign === VerticalAlign.BOTTOM)
            {
               _loc18_ = param4 - this._paddingTop - this._paddingBottom - _loc17_;
               _loc19_ = 0;
            }
            else if(this._verticalAlign === VerticalAlign.MIDDLE)
            {
               _loc18_ = _loc19_ = Math.round((param4 - this._paddingTop - this._paddingBottom - _loc17_) / 2);
            }
            else
            {
               _loc18_ = 0;
               _loc19_ = param4 - this._paddingTop - this._paddingBottom - _loc17_;
            }
         }
         var _loc20_:int = 0;
         var _loc21_:Number = _loc15_ * param4;
         var _loc22_:Number = param2 - _loc21_;
         if(_loc22_ < 0)
         {
            _loc22_ = -_loc22_ - this._paddingBottom - _loc19_;
            if(_loc22_ < 0)
            {
               _loc22_ = 0;
            }
            _loc20_ = -Math.floor(_loc22_ / (_loc10_ + this._verticalGap)) - 1;
            _loc16_ += _loc11_ * _loc20_;
         }
         else if(_loc22_ > 0)
         {
            _loc22_ = _loc22_ - this._paddingTop - _loc18_;
            if(_loc22_ < 0)
            {
               _loc22_ = 0;
            }
            _loc20_ = Math.floor(_loc22_ / (_loc10_ + this._verticalGap));
            _loc16_ += _loc11_ * _loc20_;
         }
         if(_loc16_ < 0)
         {
            _loc16_ = 0;
            _loc20_ = 0;
         }
         var _loc23_:int = _loc16_ + _loc14_;
         if(_loc23_ > param5)
         {
            _loc23_ = param5;
         }
         _loc16_ = _loc23_ - _loc14_;
         var _loc24_:int = int(param6.length);
         var _loc25_:int = _loc16_;
         while(_loc25_ < _loc23_)
         {
            param6[_loc24_] = _loc25_;
            _loc24_++;
            _loc25_++;
         }
      }
      
      protected function getVisibleIndicesAtScrollPositionWithoutPaging(param1:Number, param2:Number, param3:Number, param4:Number, param5:int, param6:Vector.<int>) : void
      {
         var _loc20_:int = 0;
         this.prepareTypicalItem();
         var _loc7_:Number = this._typicalItem ? this._typicalItem.width : 0;
         var _loc8_:Number = this._typicalItem ? this._typicalItem.height : 0;
         var _loc9_:Number = _loc7_;
         var _loc10_:Number = _loc8_;
         if(_loc9_ < 0)
         {
            _loc9_ = 0;
         }
         if(_loc10_ < 0)
         {
            _loc10_ = 0;
         }
         if(this._useSquareTiles)
         {
            if(_loc9_ > _loc10_)
            {
               _loc10_ = _loc9_;
            }
            else if(_loc10_ > _loc9_)
            {
               _loc9_ = _loc10_;
            }
         }
         var _loc11_:int = this.calculateHorizontalTileCount(_loc9_,param3,param3,this._paddingLeft + this._paddingRight,this._horizontalGap,this._requestedColumnCount,param5);
         if(this._distributeWidths)
         {
            _loc9_ = (param3 - this._paddingLeft - this._paddingRight - _loc11_ * this._horizontalGap + this._horizontalGap) / _loc11_;
            if(this._useSquareTiles)
            {
               _loc10_ = _loc9_;
            }
         }
         if(this._distributeHeights && !this._useSquareTiles)
         {
            _loc20_ = this.calculateVerticalTileCount(_loc10_,param4,param4,this._paddingTop + this._paddingBottom,this._verticalGap,this._requestedRowCount,param5,_loc11_,this._distributeHeights && !this._useSquareTiles);
            _loc10_ = (param4 - this._paddingTop - this._paddingBottom - _loc20_ * this._verticalGap + this._verticalGap) / _loc20_;
         }
         _loc20_ = Math.ceil((param4 + this._verticalGap) / (_loc10_ + this._verticalGap)) + 1;
         var _loc12_:int = _loc20_ * _loc11_;
         if(_loc12_ > param5)
         {
            _loc12_ = param5;
         }
         var _loc13_:int = 0;
         var _loc14_:Number = Math.ceil(param5 / _loc11_) * (_loc10_ + this._verticalGap) - this._verticalGap;
         if(_loc14_ < param4)
         {
            if(this._verticalAlign === VerticalAlign.BOTTOM)
            {
               _loc13_ = Math.ceil((param4 - _loc14_) / (_loc10_ + this._verticalGap));
            }
            else if(this._verticalAlign === VerticalAlign.MIDDLE)
            {
               _loc13_ = Math.ceil((param4 - _loc14_) / (_loc10_ + this._verticalGap) / 2);
            }
         }
         var _loc15_:int = -_loc13_ + Math.floor((param2 - this._paddingTop + this._verticalGap) / (_loc10_ + this._verticalGap));
         var _loc16_:int = _loc15_ * _loc11_;
         if(_loc16_ < 0)
         {
            _loc16_ = 0;
         }
         var _loc17_:int = _loc16_ + _loc12_;
         if(_loc17_ > param5)
         {
            _loc17_ = param5;
         }
         _loc16_ = _loc17_ - _loc12_;
         var _loc18_:int = int(param6.length);
         var _loc19_:int = _loc16_;
         while(_loc19_ < _loc17_)
         {
            param6[_loc18_] = _loc19_;
            _loc18_++;
            _loc19_++;
         }
      }
      
      protected function validateItems(param1:Vector.<DisplayObject>) : void
      {
         var _loc4_:DisplayObject = null;
         var _loc2_:int = int(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1[_loc3_];
            if(!(_loc4_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc4_).includeInLayout))
            {
               if(_loc4_ is IValidating)
               {
                  IValidating(_loc4_).validate();
               }
            }
            _loc3_++;
         }
      }
      
      protected function prepareTypicalItem() : void
      {
         if(!this._typicalItem)
         {
            return;
         }
         if(this._resetTypicalItemDimensionsOnMeasure)
         {
            this._typicalItem.width = this._typicalItemWidth;
            this._typicalItem.height = this._typicalItemHeight;
         }
         if(this._typicalItem is IValidating)
         {
            IValidating(this._typicalItem).validate();
         }
      }
      
      public function calculateScrollPositionForIndex(param1:int, param2:Vector.<DisplayObject>, param3:Number, param4:Number, param5:Number, param6:Number, param7:Point = null, param8:Boolean = false, param9:Number = 0, param10:Number = 0) : Point
      {
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:int = 0;
         var _loc18_:DisplayObject = null;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:int = 0;
         var _loc22_:Number = NaN;
         var _loc23_:int = 0;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         if(!param7)
         {
            param7 = new Point();
         }
         if(this._useVirtualLayout)
         {
            this.prepareTypicalItem();
            _loc15_ = this._typicalItem ? this._typicalItem.width : 0;
            _loc16_ = this._typicalItem ? this._typicalItem.height : 0;
         }
         var _loc11_:int = int(param2.length);
         var _loc12_:Number = this._useVirtualLayout ? _loc15_ : 0;
         var _loc13_:Number = this._useVirtualLayout ? _loc16_ : 0;
         if(!this._useVirtualLayout)
         {
            _loc17_ = 0;
            while(_loc17_ < _loc11_)
            {
               _loc18_ = param2[_loc17_];
               if(_loc18_)
               {
                  if(!(_loc18_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc18_).includeInLayout))
                  {
                     _loc19_ = _loc18_.width;
                     _loc20_ = _loc18_.height;
                     if(_loc19_ > _loc12_)
                     {
                        _loc12_ = _loc19_;
                     }
                     if(_loc20_ > _loc13_)
                     {
                        _loc13_ = _loc20_;
                     }
                  }
               }
               _loc17_++;
            }
         }
         if(_loc12_ < 0)
         {
            _loc12_ = 0;
         }
         if(_loc13_ < 0)
         {
            _loc13_ = 0;
         }
         if(this._useSquareTiles)
         {
            if(_loc12_ > _loc13_)
            {
               _loc13_ = _loc12_;
            }
            else if(_loc13_ > _loc12_)
            {
               _loc12_ = _loc13_;
            }
         }
         var _loc14_:int = (param5 - this._paddingLeft - this._paddingRight + this._horizontalGap) / (_loc12_ + this._horizontalGap);
         if(_loc14_ < 1)
         {
            _loc14_ = 1;
         }
         else if(this._requestedColumnCount > 0 && _loc14_ > this._requestedColumnCount)
         {
            _loc14_ = this._requestedColumnCount;
         }
         if(this._paging !== Direction.NONE)
         {
            _loc21_ = (param6 - this._paddingTop - this._paddingBottom + this._verticalGap) / (_loc13_ + this._verticalGap);
            if(_loc21_ < 1)
            {
               _loc21_ = 1;
            }
            _loc22_ = _loc14_ * _loc21_;
            _loc23_ = param1 / _loc22_;
            if(this._paging === Direction.HORIZONTAL)
            {
               param7.x = _loc23_ * param5;
               param7.y = 0;
            }
            else
            {
               param7.x = 0;
               param7.y = _loc23_ * param6;
            }
         }
         else
         {
            _loc24_ = this._paddingTop + (_loc13_ + this._verticalGap) * int(param1 / _loc14_);
            if(param8)
            {
               _loc25_ = _loc24_ - (param6 - _loc13_);
               if(param10 >= _loc25_ && param10 <= _loc24_)
               {
                  _loc24_ = param10;
               }
               else
               {
                  _loc26_ = Math.abs(_loc24_ - param10);
                  _loc27_ = Math.abs(_loc25_ - param10);
                  if(_loc27_ < _loc26_)
                  {
                     _loc24_ = _loc25_;
                  }
               }
            }
            else
            {
               _loc24_ -= Math.round((param6 - _loc13_) / 2);
            }
            param7.x = 0;
            param7.y = _loc24_;
         }
         return param7;
      }
      
      protected function calculateHorizontalTileCount(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:int, param7:int) : int
      {
         var _loc8_:int = 0;
         if(param6 > 0 && this._distributeWidths)
         {
            return param6;
         }
         if(param2 === param2)
         {
            _loc8_ = (param2 - param4 + param5) / (param1 + param5);
            if(param6 > 0 && _loc8_ > param6)
            {
               return param6;
            }
            if(_loc8_ > param7)
            {
               _loc8_ = param7;
            }
            if(_loc8_ < 1)
            {
               _loc8_ = 1;
            }
            return _loc8_;
         }
         if(param6 > 0)
         {
            _loc8_ = param6;
         }
         else
         {
            _loc8_ = param7;
         }
         var _loc9_:int = int.MAX_VALUE;
         if(param3 === param3 && param3 < Number.POSITIVE_INFINITY)
         {
            _loc9_ = (param3 - param4 + param5) / (param1 + param5);
            if(_loc9_ < 1)
            {
               _loc9_ = 1;
            }
         }
         if(_loc8_ > _loc9_)
         {
            _loc8_ = _loc9_;
         }
         if(_loc8_ < 1)
         {
            _loc8_ = 1;
         }
         return _loc8_;
      }
      
      protected function calculateVerticalTileCount(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:int, param7:int, param8:int, param9:Boolean) : int
      {
         var _loc11_:int = 0;
         var _loc10_:int = Math.ceil(param7 / param8);
         if(param9)
         {
            if(param6 > 0 && _loc10_ > param6)
            {
               return param6;
            }
            return _loc10_;
         }
         if(param2 === param2)
         {
            _loc11_ = (param2 - param4 + param5) / (param1 + param5);
            if(param6 > 0 && _loc11_ > param6)
            {
               return param6;
            }
            if(_loc11_ > _loc10_)
            {
               _loc11_ = _loc10_;
            }
            if(_loc11_ < 1)
            {
               _loc11_ = 1;
            }
            return _loc11_;
         }
         if(param6 > 0)
         {
            _loc11_ = param6;
         }
         else
         {
            _loc11_ = _loc10_;
         }
         var _loc12_:int = int.MAX_VALUE;
         if(param3 === param3 && param3 < Number.POSITIVE_INFINITY)
         {
            _loc12_ = (param3 - param4 + param5) / (param1 + param5);
            if(_loc12_ < 1)
            {
               _loc12_ = 1;
            }
         }
         if(_loc11_ > _loc12_)
         {
            _loc11_ = _loc12_;
         }
         if(_loc11_ < 1)
         {
            _loc11_ = 1;
         }
         return _loc11_;
      }
   }
}

