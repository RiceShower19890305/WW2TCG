package feathers.controls.text
{
   import feathers.controls.Scroller;
   import feathers.skins.IStyleProvider;
   import feathers.utils.geom.matrixToRotation;
   import feathers.utils.geom.matrixToScaleX;
   import feathers.utils.geom.matrixToScaleY;
   import feathers.utils.math.roundToNearest;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import starling.core.Starling;
   import starling.utils.MatrixUtil;
   import starling.utils.Pool;
   
   public class TextFieldTextEditorViewPort extends TextFieldTextEditor implements ITextEditorViewPort
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      private var _ignoreScrolling:Boolean = false;
      
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
      
      protected var _scrollStep:int = 0;
      
      private var _horizontalScrollPosition:Number = 0;
      
      private var _verticalScrollPosition:Number = 0;
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      public function TextFieldTextEditorViewPort()
      {
         super();
         this.multiline = true;
         this.wordWrap = true;
         this.resetScrollOnFocusOut = false;
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return globalStyleProvider;
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
            this._actualVisibleWidth = param1;
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
            this._actualVisibleHeight = param1;
            this.invalidate(INVALIDATION_FLAG_SIZE);
         }
      }
      
      public function get contentX() : Number
      {
         return 0;
      }
      
      public function get contentY() : Number
      {
         return 0;
      }
      
      public function get horizontalScrollStep() : Number
      {
         return this._scrollStep;
      }
      
      public function get verticalScrollStep() : Number
      {
         return this._scrollStep;
      }
      
      public function get horizontalScrollPosition() : Number
      {
         return this._horizontalScrollPosition;
      }
      
      public function set horizontalScrollPosition(param1:Number) : void
      {
         this._horizontalScrollPosition = param1;
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
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
      
      public function get requiresMeasurementOnScroll() : Boolean
      {
         return false;
      }
      
      override public function get baseline() : Number
      {
         return super.baseline + this._paddingTop + this._verticalScrollPosition;
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
         this.invalidate(INVALIDATION_FLAG_STYLES);
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
         this.invalidate(INVALIDATION_FLAG_STYLES);
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
         this.invalidate(INVALIDATION_FLAG_STYLES);
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
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      override public function setFocus(param1:Point = null) : void
      {
         if(param1 !== null)
         {
            param1.x -= this._paddingLeft;
            param1.y -= this._paddingTop;
         }
         super.setFocus(param1);
      }
      
      override protected function autoSizeIfNeeded() : Boolean
      {
         var _loc1_:Boolean = super.autoSizeIfNeeded();
         var _loc2_:Boolean = this._explicitVisibleWidth !== this._explicitVisibleWidth;
         var _loc3_:Boolean = this._explicitVisibleHeight !== this._explicitVisibleHeight;
         var _loc4_:Boolean = this._explicitMinVisibleWidth !== this._explicitMinVisibleWidth;
         var _loc5_:Boolean = this._explicitMinVisibleHeight !== this._explicitMinVisibleHeight;
         if(!_loc2_ && !_loc3_ && !_loc4_ && !_loc5_)
         {
            return _loc1_;
         }
         if(_loc2_)
         {
            this._actualVisibleWidth = this.actualWidth;
         }
         if(_loc3_)
         {
            this._actualVisibleHeight = this.actualHeight;
         }
         if(_loc4_)
         {
            this._actualMinVisibleWidth = this.actualMinWidth;
         }
         if(_loc5_)
         {
            this._actualMinVisibleHeight = this.actualMinHeight;
         }
         return _loc1_;
      }
      
      override protected function measure(param1:Point = null) : Point
      {
         if(!param1)
         {
            param1 = new Point();
         }
         var _loc2_:Boolean = this._explicitVisibleWidth !== this._explicitVisibleWidth;
         this.commitStylesAndData(this.measureTextField);
         var _loc3_:Number = 4;
         if(this._useGutter)
         {
            _loc3_ = 0;
         }
         var _loc4_:Number = this._explicitVisibleWidth;
         this.measureTextField.width = _loc4_ - this._paddingLeft - this._paddingRight + _loc3_;
         if(_loc2_)
         {
            _loc4_ = this.measureTextField.width + this._paddingLeft + this._paddingRight - _loc3_;
            if(this._explicitMinVisibleWidth === this._explicitMinVisibleWidth && _loc4_ < this._explicitMinVisibleWidth)
            {
               _loc4_ = this._explicitMinVisibleWidth;
            }
            else if(_loc4_ > this._maxVisibleWidth)
            {
               _loc4_ = this._maxVisibleWidth;
            }
         }
         var _loc5_:Number = this.measureTextField.height + this._paddingTop + this._paddingBottom - _loc3_;
         if(this._useGutter)
         {
            _loc5_ += 4;
         }
         if(this._explicitVisibleHeight === this._explicitVisibleHeight)
         {
            if(_loc5_ < this._explicitVisibleHeight)
            {
               _loc5_ = this._explicitVisibleHeight;
            }
         }
         else if(this._explicitMinVisibleHeight === this._explicitMinVisibleHeight)
         {
            if(_loc5_ < this._explicitMinVisibleHeight)
            {
               _loc5_ = this._explicitMinVisibleHeight;
            }
         }
         param1.x = _loc4_;
         param1.y = _loc5_;
         return param1;
      }
      
      override protected function refreshSnapshotParameters() : void
      {
         var _loc7_:Matrix = null;
         var _loc1_:Number = this._actualVisibleWidth - this._paddingLeft - this._paddingRight;
         if(_loc1_ !== _loc1_)
         {
            if(this._maxVisibleWidth < Number.POSITIVE_INFINITY)
            {
               _loc1_ = this._maxVisibleWidth - this._paddingLeft - this._paddingRight;
            }
            else
            {
               _loc1_ = this._actualMinVisibleWidth - this._paddingLeft - this._paddingRight;
            }
         }
         var _loc2_:Number = this._actualVisibleHeight - this._paddingTop - this._paddingBottom;
         if(_loc2_ !== _loc2_)
         {
            if(this._maxVisibleHeight < Number.POSITIVE_INFINITY)
            {
               _loc2_ = this._maxVisibleHeight - this._paddingTop - this._paddingBottom;
            }
            else
            {
               _loc2_ = this._actualMinVisibleHeight - this._paddingTop - this._paddingBottom;
            }
         }
         this._textFieldOffsetX = 0;
         this._textFieldOffsetY = 0;
         this._textFieldSnapshotClipRect.x = 0;
         this._textFieldSnapshotClipRect.y = 0;
         var _loc3_:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         var _loc4_:Number = _loc3_.contentScaleFactor;
         var _loc5_:Number = _loc1_ * _loc4_;
         if(this._updateSnapshotOnScaleChange)
         {
            _loc7_ = Pool.getMatrix();
            this.getTransformationMatrix(this.stage,_loc7_);
            _loc5_ *= matrixToScaleX(_loc7_);
         }
         if(_loc5_ < 0)
         {
            _loc5_ = 0;
         }
         var _loc6_:Number = _loc2_ * _loc4_;
         if(this._updateSnapshotOnScaleChange)
         {
            _loc6_ *= matrixToScaleY(_loc7_);
            Pool.putMatrix(_loc7_);
         }
         if(_loc6_ < 0)
         {
            _loc6_ = 0;
         }
         this._textFieldSnapshotClipRect.width = _loc5_;
         this._textFieldSnapshotClipRect.height = _loc6_;
      }
      
      override protected function refreshTextFieldSize() : void
      {
         var _loc1_:Boolean = this._ignoreScrolling;
         var _loc2_:Number = 4;
         if(this._useGutter)
         {
            _loc2_ = 0;
         }
         this._ignoreScrolling = true;
         this.textField.width = this._actualVisibleWidth - this._paddingLeft - this._paddingRight + _loc2_;
         var _loc3_:Number = this._actualVisibleHeight - this._paddingTop - this._paddingBottom + _loc2_;
         if(this.textField.height != _loc3_)
         {
            this.textField.height = _loc3_;
         }
         var _loc4_:Scroller = Scroller(this.parent);
         this.textField.scrollV = Math.round(1 + (this.textField.maxScrollV - 1) * (this._verticalScrollPosition / _loc4_.maxVerticalScrollPosition));
         this._ignoreScrolling = _loc1_;
      }
      
      override protected function commitStylesAndData(param1:TextField) : void
      {
         super.commitStylesAndData(param1);
         if(param1 == this.textField)
         {
            this._scrollStep = param1.getLineMetrics(0).height;
         }
      }
      
      override protected function transformTextField() : void
      {
         var _loc1_:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         var _loc2_:Number = 1;
         if(_loc1_.supportHighResolutions)
         {
            _loc2_ = _loc1_.nativeStage.contentsScaleFactor;
         }
         var _loc3_:Number = _loc1_.contentScaleFactor / _loc2_;
         var _loc4_:Matrix = Pool.getMatrix();
         var _loc5_:Point = Pool.getPoint();
         this.getTransformationMatrix(this.stage,_loc4_);
         MatrixUtil.transformCoords(_loc4_,0,0,_loc5_);
         var _loc6_:Number = matrixToScaleX(_loc4_) * _loc3_;
         var _loc7_:Number = matrixToScaleY(_loc4_) * _loc3_;
         var _loc8_:Number = Math.round(this._paddingLeft * _loc6_);
         var _loc9_:Number = Math.round((this._paddingTop + this._verticalScrollPosition) * _loc7_);
         var _loc10_:Rectangle = _loc1_.viewPort;
         var _loc11_:Number = 2;
         if(this._useGutter)
         {
            _loc11_ = 0;
         }
         this.textField.x = _loc8_ + Math.round(_loc10_.x + _loc5_.x * _loc3_ - _loc11_ * _loc6_);
         this.textField.y = _loc9_ + Math.round(_loc10_.y + _loc5_.y * _loc3_ - _loc11_ * _loc7_);
         this.textField.rotation = matrixToRotation(_loc4_) * 180 / Math.PI;
         this.textField.scaleX = _loc6_;
         this.textField.scaleY = _loc7_;
         Pool.putPoint(_loc5_);
         Pool.putMatrix(_loc4_);
      }
      
      override protected function positionSnapshot() : void
      {
         var _loc1_:Matrix = null;
         if(!this.textSnapshot)
         {
            return;
         }
         _loc1_ = Pool.getMatrix();
         this.getTransformationMatrix(this.stage,_loc1_);
         this.textSnapshot.x = this._paddingLeft + Math.round(_loc1_.tx) - _loc1_.tx;
         this.textSnapshot.y = this._paddingTop + this._verticalScrollPosition + Math.round(_loc1_.ty) - _loc1_.ty;
         Pool.putMatrix(_loc1_);
      }
      
      override protected function checkIfNewSnapshotIsNeeded() : void
      {
         super.checkIfNewSnapshotIsNeeded();
         this._needsNewTexture = this._needsNewTexture || this.isInvalid(INVALIDATION_FLAG_SCROLL);
      }
      
      override protected function textField_focusInHandler(param1:FocusEvent) : void
      {
         this.textField.addEventListener(Event.SCROLL,this.textField_scrollHandler);
         super.textField_focusInHandler(param1);
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
      
      override protected function textField_focusOutHandler(param1:FocusEvent) : void
      {
         this.textField.removeEventListener(Event.SCROLL,this.textField_scrollHandler);
         super.textField_focusOutHandler(param1);
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
      
      protected function textField_scrollHandler(param1:Event) : void
      {
         var _loc5_:Number = NaN;
         var _loc2_:Number = this.textField.scrollH;
         var _loc3_:Number = this.textField.scrollV;
         if(this._ignoreScrolling)
         {
            return;
         }
         var _loc4_:Scroller = Scroller(this.parent);
         if(_loc4_.maxVerticalScrollPosition > 0 && this.textField.maxScrollV > 1)
         {
            _loc5_ = _loc4_.maxVerticalScrollPosition * (_loc3_ - 1) / (this.textField.maxScrollV - 1);
            _loc4_.verticalScrollPosition = roundToNearest(_loc5_,this._scrollStep);
         }
      }
   }
}

