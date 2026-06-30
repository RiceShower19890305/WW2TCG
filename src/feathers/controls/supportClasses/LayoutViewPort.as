package feathers.controls.supportClasses
{
   import feathers.controls.AutoSizeMode;
   import feathers.controls.LayoutGroup;
   import feathers.core.IValidating;
   import feathers.layout.ILayoutDisplayObject;
   import starling.display.DisplayObject;
   
   public class LayoutViewPort extends LayoutGroup implements IViewPort
   {
      
      private var _actualMinVisibleWidth:Number = 0;
      
      private var _explicitMinVisibleWidth:Number;
      
      private var _maxVisibleWidth:Number = Infinity;
      
      private var _actualVisibleWidth:Number = 0;
      
      private var _explicitVisibleWidth:Number;
      
      private var _actualMinVisibleHeight:Number = 0;
      
      private var _explicitMinVisibleHeight:Number;
      
      private var _maxVisibleHeight:Number = Infinity;
      
      private var _actualVisibleHeight:Number = 0;
      
      private var _explicitVisibleHeight:Number;
      
      private var _contentX:Number = 0;
      
      private var _contentY:Number = 0;
      
      private var _horizontalScrollPosition:Number = 0;
      
      private var _verticalScrollPosition:Number = 0;
      
      public function LayoutViewPort()
      {
         super();
      }
      
      public function get minVisibleWidth() : Number
      {
         if(this._explicitMinVisibleWidth !== this._explicitMinVisibleWidth)
         {
            return this._actualMinVisibleWidth;
         }
         return this._explicitMinVisibleWidth;
      }
      
      public function set minVisibleWidth(param1:Number) : void
      {
         if(this._explicitMinVisibleWidth == param1)
         {
            return;
         }
         var _loc2_:Boolean = param1 !== param1;
         if(_loc2_ && this._explicitMinVisibleWidth !== this._explicitMinVisibleWidth)
         {
            return;
         }
         var _loc3_:Number = this._explicitMinVisibleWidth;
         this._explicitMinVisibleWidth = param1;
         if(_loc2_)
         {
            this._actualMinVisibleWidth = 0;
            this.invalidate(INVALIDATION_FLAG_SIZE);
         }
         else
         {
            this._actualMinVisibleWidth = param1;
            if(this._explicitVisibleWidth !== this._explicitVisibleWidth && (this._actualVisibleWidth < param1 || this._actualVisibleWidth == _loc3_))
            {
               this.invalidate(INVALIDATION_FLAG_SIZE);
            }
         }
      }
      
      public function get maxVisibleWidth() : Number
      {
         return this._maxVisibleWidth;
      }
      
      public function set maxVisibleWidth(param1:Number) : void
      {
         if(this._maxVisibleWidth == param1)
         {
            return;
         }
         if(param1 !== param1)
         {
            throw new ArgumentError("maxVisibleWidth cannot be NaN");
         }
         var _loc2_:Number = this._maxVisibleWidth;
         this._maxVisibleWidth = param1;
         if(this._explicitVisibleWidth !== this._explicitVisibleWidth && (this._actualVisibleWidth > param1 || this._actualVisibleWidth == _loc2_))
         {
            this.invalidate(INVALIDATION_FLAG_SIZE);
         }
      }
      
      public function get visibleWidth() : Number
      {
         if(this._explicitVisibleWidth !== this._explicitVisibleWidth)
         {
            return this._actualVisibleWidth;
         }
         return this._explicitVisibleWidth;
      }
      
      public function set visibleWidth(param1:Number) : void
      {
         if(this._explicitVisibleWidth == param1 || param1 !== param1 && this._explicitVisibleWidth !== this._explicitVisibleWidth)
         {
            return;
         }
         this._explicitVisibleWidth = param1;
         if(this._actualVisibleWidth != param1)
         {
            this.invalidate(INVALIDATION_FLAG_SIZE);
         }
      }
      
      public function get minVisibleHeight() : Number
      {
         if(this._explicitMinVisibleHeight !== this._explicitMinVisibleHeight)
         {
            return this._actualMinVisibleHeight;
         }
         return this._explicitMinVisibleHeight;
      }
      
      public function set minVisibleHeight(param1:Number) : void
      {
         if(this._explicitMinVisibleHeight == param1)
         {
            return;
         }
         var _loc2_:Boolean = param1 !== param1;
         if(_loc2_ && this._explicitMinVisibleHeight !== this._explicitMinVisibleHeight)
         {
            return;
         }
         var _loc3_:Number = this._explicitMinVisibleHeight;
         this._explicitMinVisibleHeight = param1;
         if(_loc2_)
         {
            this._actualMinVisibleHeight = 0;
            this.invalidate(INVALIDATION_FLAG_SIZE);
         }
         else
         {
            this._actualMinVisibleHeight = param1;
            if(this._explicitVisibleHeight !== this._explicitVisibleHeight && (this._actualVisibleHeight < param1 || this._actualVisibleHeight == _loc3_))
            {
               this.invalidate(INVALIDATION_FLAG_SIZE);
            }
         }
      }
      
      public function get maxVisibleHeight() : Number
      {
         return this._maxVisibleHeight;
      }
      
      public function set maxVisibleHeight(param1:Number) : void
      {
         if(this._maxVisibleHeight == param1)
         {
            return;
         }
         if(param1 !== param1)
         {
            throw new ArgumentError("maxVisibleHeight cannot be NaN");
         }
         var _loc2_:Number = this._maxVisibleHeight;
         this._maxVisibleHeight = param1;
         if(this._explicitVisibleHeight !== this._explicitVisibleHeight && (this._actualVisibleHeight > param1 || this._actualVisibleHeight == _loc2_))
         {
            this.invalidate(INVALIDATION_FLAG_SIZE);
         }
      }
      
      public function get visibleHeight() : Number
      {
         if(this._explicitVisibleHeight !== this._explicitVisibleHeight)
         {
            return this._actualVisibleHeight;
         }
         return this._explicitVisibleHeight;
      }
      
      public function set visibleHeight(param1:Number) : void
      {
         if(this._explicitVisibleHeight == param1 || param1 !== param1 && this._explicitVisibleHeight !== this._explicitVisibleHeight)
         {
            return;
         }
         this._explicitVisibleHeight = param1;
         if(this._actualVisibleHeight != param1)
         {
            this.invalidate(INVALIDATION_FLAG_SIZE);
         }
      }
      
      public function get contentX() : Number
      {
         return this._contentX;
      }
      
      public function get contentY() : Number
      {
         return this._contentY;
      }
      
      public function get horizontalScrollStep() : Number
      {
         if(this.actualWidth < this.actualHeight)
         {
            return this.actualWidth / 10;
         }
         return this.actualHeight / 10;
      }
      
      public function get verticalScrollStep() : Number
      {
         if(this.actualWidth < this.actualHeight)
         {
            return this.actualWidth / 10;
         }
         return this.actualHeight / 10;
      }
      
      public function get horizontalScrollPosition() : Number
      {
         return this._horizontalScrollPosition;
      }
      
      public function set horizontalScrollPosition(param1:Number) : void
      {
         if(this._horizontalScrollPosition == param1)
         {
            return;
         }
         this._horizontalScrollPosition = param1;
         this.invalidate(INVALIDATION_FLAG_SCROLL);
      }
      
      public function get verticalScrollPosition() : Number
      {
         return this._verticalScrollPosition;
      }
      
      public function set verticalScrollPosition(param1:Number) : void
      {
         if(this._verticalScrollPosition == param1)
         {
            return;
         }
         this._verticalScrollPosition = param1;
         this.invalidate(INVALIDATION_FLAG_SCROLL);
      }
      
      public function get requiresMeasurementOnScroll() : Boolean
      {
         return this._layout !== null && this._layout.requiresLayoutOnScroll && (this._explicitVisibleWidth !== this._explicitVisibleWidth || this._explicitVisibleHeight !== this._explicitVisibleHeight);
      }
      
      override public function dispose() : void
      {
         this.layout = null;
         super.dispose();
      }
      
      override protected function refreshViewPortBounds() : void
      {
         var _loc1_:Boolean = this._explicitVisibleWidth !== this._explicitVisibleWidth;
         var _loc2_:Boolean = this._explicitVisibleHeight !== this._explicitVisibleHeight;
         var _loc3_:Boolean = this._explicitMinVisibleWidth !== this._explicitMinVisibleWidth;
         var _loc4_:Boolean = this._explicitMinVisibleHeight !== this._explicitMinVisibleHeight;
         this.viewPortBounds.x = 0;
         this.viewPortBounds.y = 0;
         this.viewPortBounds.scrollX = this._horizontalScrollPosition;
         this.viewPortBounds.scrollY = this._verticalScrollPosition;
         if(this._autoSizeMode === AutoSizeMode.STAGE && _loc1_)
         {
            this.viewPortBounds.explicitWidth = this.stage.stageWidth;
         }
         else
         {
            this.viewPortBounds.explicitWidth = this._explicitVisibleWidth;
         }
         if(this._autoSizeMode === AutoSizeMode.STAGE && _loc2_)
         {
            this.viewPortBounds.explicitHeight = this.stage.stageHeight;
         }
         else
         {
            this.viewPortBounds.explicitHeight = this._explicitVisibleHeight;
         }
         if(_loc3_)
         {
            this.viewPortBounds.minWidth = 0;
         }
         else
         {
            this.viewPortBounds.minWidth = this._explicitMinVisibleWidth;
         }
         if(_loc4_)
         {
            this.viewPortBounds.minHeight = 0;
         }
         else
         {
            this.viewPortBounds.minHeight = this._explicitMinVisibleHeight;
         }
         this.viewPortBounds.maxWidth = this._maxVisibleWidth;
         this.viewPortBounds.maxHeight = this._maxVisibleHeight;
      }
      
      override protected function handleLayoutResult() : void
      {
         var _loc1_:Number = this._layoutResult.contentWidth;
         var _loc2_:Number = this._layoutResult.contentHeight;
         this.saveMeasurements(_loc1_,_loc2_,_loc1_,_loc2_);
         this._contentX = this._layoutResult.contentX;
         this._contentY = this._layoutResult.contentY;
         var _loc3_:Number = this._layoutResult.viewPortWidth;
         var _loc4_:Number = this._layoutResult.viewPortHeight;
         this._actualVisibleWidth = _loc3_;
         this._actualVisibleHeight = _loc4_;
         this._actualMinVisibleWidth = _loc3_;
         this._actualMinVisibleHeight = _loc4_;
      }
      
      override protected function handleManualLayout() : void
      {
         var _loc15_:DisplayObject = null;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         var _loc3_:Number = this.viewPortBounds.explicitWidth;
         var _loc4_:Number = _loc3_;
         this.doNothing();
         if(_loc4_ !== _loc4_)
         {
            _loc4_ = 0;
         }
         var _loc5_:Number;
         var _loc6_:Number = _loc5_ = this.viewPortBounds.explicitHeight;
         this.doNothing();
         if(_loc6_ !== _loc6_)
         {
            _loc6_ = 0;
         }
         this._ignoreChildChanges = true;
         var _loc7_:int = int(this.items.length);
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            _loc15_ = this.items[_loc8_];
            if(!(_loc15_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc15_).includeInLayout))
            {
               if(_loc15_ is IValidating)
               {
                  IValidating(_loc15_).validate();
               }
               _loc16_ = _loc15_.x - _loc15_.pivotX * _loc15_.scaleX;
               _loc17_ = _loc15_.y - _loc15_.pivotY * _loc15_.scaleY;
               _loc18_ = _loc16_ + _loc15_.width;
               _loc19_ = _loc17_ + _loc15_.height;
               if(_loc16_ === _loc16_ && _loc16_ < _loc1_)
               {
                  _loc1_ = _loc16_;
               }
               if(_loc17_ === _loc17_ && _loc17_ < _loc2_)
               {
                  _loc2_ = _loc17_;
               }
               if(_loc18_ === _loc18_ && _loc18_ > _loc4_)
               {
                  _loc4_ = _loc18_;
               }
               if(_loc19_ === _loc19_ && _loc19_ > _loc6_)
               {
                  _loc6_ = _loc19_;
               }
            }
            _loc8_++;
         }
         var _loc9_:Number = this.viewPortBounds.minWidth;
         var _loc10_:Number = this.viewPortBounds.maxWidth;
         var _loc11_:Number = this.viewPortBounds.minHeight;
         var _loc12_:Number = this.viewPortBounds.maxHeight;
         var _loc13_:Number = _loc4_ - _loc1_;
         if(_loc13_ < _loc9_)
         {
            _loc13_ = _loc9_;
         }
         else if(_loc13_ > _loc10_)
         {
            _loc13_ = _loc10_;
         }
         var _loc14_:Number = _loc6_ - _loc2_;
         if(_loc14_ < _loc11_)
         {
            _loc14_ = _loc11_;
         }
         else if(_loc14_ > _loc12_)
         {
            _loc14_ = _loc12_;
         }
         this._ignoreChildChanges = false;
         if(_loc3_ !== _loc3_)
         {
            this._actualVisibleWidth = _loc13_;
         }
         else
         {
            this._actualVisibleWidth = _loc3_;
         }
         if(_loc5_ !== _loc5_)
         {
            this._actualVisibleHeight = _loc14_;
         }
         else
         {
            this._actualVisibleHeight = _loc5_;
         }
         this._layoutResult.contentX = _loc1_;
         this._layoutResult.contentY = _loc2_;
         this._layoutResult.contentWidth = _loc13_;
         this._layoutResult.contentHeight = _loc14_;
         this._layoutResult.viewPortWidth = _loc13_;
         this._layoutResult.viewPortHeight = _loc14_;
      }
      
      protected function doNothing() : void
      {
      }
   }
}

