package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.IValidating;
   import feathers.layout.Direction;
   import feathers.skins.IStyleProvider;
   import feathers.utils.math.clamp;
   import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;
   import starling.display.DisplayObject;
   
   public class ProgressBar extends FeathersControl
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      protected var _direction:String = "horizontal";
      
      protected var _value:Number = 0;
      
      protected var _minimum:Number = 0;
      
      protected var _maximum:Number = 1;
      
      protected var _explicitBackgroundWidth:Number;
      
      protected var _explicitBackgroundHeight:Number;
      
      protected var _explicitBackgroundMinWidth:Number;
      
      protected var _explicitBackgroundMinHeight:Number;
      
      protected var _explicitBackgroundMaxWidth:Number;
      
      protected var _explicitBackgroundMaxHeight:Number;
      
      protected var currentBackground:DisplayObject;
      
      protected var _backgroundSkin:DisplayObject;
      
      protected var _backgroundDisabledSkin:DisplayObject;
      
      protected var _originalFillWidth:Number = NaN;
      
      protected var _originalFillHeight:Number = NaN;
      
      protected var currentFill:DisplayObject;
      
      protected var _fillSkin:DisplayObject;
      
      protected var _fillDisabledSkin:DisplayObject;
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      public function ProgressBar()
      {
         super();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return ProgressBar.globalStyleProvider;
      }
      
      public function get direction() : String
      {
         return this._direction;
      }
      
      public function set direction(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._direction === param1)
         {
            return;
         }
         this._direction = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get value() : Number
      {
         return this._value;
      }
      
      public function set value(param1:Number) : void
      {
         param1 = clamp(param1,this._minimum,this._maximum);
         if(this._value == param1)
         {
            return;
         }
         this._value = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get minimum() : Number
      {
         return this._minimum;
      }
      
      public function set minimum(param1:Number) : void
      {
         if(this._minimum == param1)
         {
            return;
         }
         this._minimum = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get maximum() : Number
      {
         return this._maximum;
      }
      
      public function set maximum(param1:Number) : void
      {
         if(this._maximum == param1)
         {
            return;
         }
         this._maximum = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get backgroundSkin() : DisplayObject
      {
         return this._backgroundSkin;
      }
      
      public function set backgroundSkin(param1:DisplayObject) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            if(param1 !== null)
            {
               param1.dispose();
            }
            return;
         }
         if(this._backgroundSkin === param1)
         {
            return;
         }
         if(this._backgroundSkin !== null && this.currentBackground === this._backgroundSkin)
         {
            this.removeCurrentBackground(this._backgroundSkin);
            this.currentBackground = null;
         }
         this._backgroundSkin = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get backgroundDisabledSkin() : DisplayObject
      {
         return this._backgroundDisabledSkin;
      }
      
      public function set backgroundDisabledSkin(param1:DisplayObject) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            if(param1 !== null)
            {
               param1.dispose();
            }
            return;
         }
         if(this._backgroundDisabledSkin === param1)
         {
            return;
         }
         if(this._backgroundDisabledSkin !== null && this.currentBackground === this._backgroundDisabledSkin)
         {
            this.removeCurrentBackground(this._backgroundDisabledSkin);
            this.currentBackground = null;
         }
         this._backgroundDisabledSkin = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get fillSkin() : DisplayObject
      {
         return this._fillSkin;
      }
      
      public function set fillSkin(param1:DisplayObject) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            if(param1 !== null)
            {
               param1.dispose();
            }
            return;
         }
         if(this._fillSkin === param1)
         {
            return;
         }
         if(Boolean(this._fillSkin) && this._fillSkin != this._fillDisabledSkin)
         {
            this.removeChild(this._fillSkin);
         }
         this._fillSkin = param1;
         if(Boolean(this._fillSkin) && this._fillSkin.parent != this)
         {
            this._fillSkin.visible = false;
            this.addChild(this._fillSkin);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get fillDisabledSkin() : DisplayObject
      {
         return this._fillDisabledSkin;
      }
      
      public function set fillDisabledSkin(param1:DisplayObject) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            if(param1 !== null)
            {
               param1.dispose();
            }
            return;
         }
         if(this._fillDisabledSkin === param1)
         {
            return;
         }
         if(Boolean(this._fillDisabledSkin) && this._fillDisabledSkin != this._fillSkin)
         {
            this.removeChild(this._fillDisabledSkin);
         }
         this._fillDisabledSkin = param1;
         if(Boolean(this._fillDisabledSkin) && this._fillDisabledSkin.parent != this)
         {
            this._fillDisabledSkin.visible = false;
            this.addChild(this._fillDisabledSkin);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
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
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
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
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
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
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
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
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._paddingLeft == param1)
         {
            return;
         }
         this._paddingLeft = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      override public function dispose() : void
      {
         if(this._backgroundSkin !== null && this._backgroundSkin.parent !== this)
         {
            this._backgroundSkin.dispose();
         }
         if(this._backgroundDisabledSkin !== null && this._backgroundDisabledSkin.parent !== this)
         {
            this._backgroundDisabledSkin.dispose();
         }
         super.dispose();
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
         if(_loc1_ || _loc2_)
         {
            this.refreshBackground();
            this.refreshFill();
         }
         this.autoSizeIfNeeded();
         this.layoutChildren();
         if(this.currentBackground is IValidating)
         {
            IValidating(this.currentBackground).validate();
         }
         if(this.currentFill is IValidating)
         {
            IValidating(this.currentFill).validate();
         }
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc1_:Boolean = this._explicitWidth !== this._explicitWidth;
         var _loc2_:Boolean = this._explicitHeight !== this._explicitHeight;
         var _loc3_:Boolean = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc4_:Boolean = this._explicitMinHeight !== this._explicitMinHeight;
         if(!_loc1_ && !_loc2_ && !_loc3_ && !_loc4_)
         {
            return false;
         }
         var _loc5_:IMeasureDisplayObject = this.currentBackground as IMeasureDisplayObject;
         resetFluidChildDimensionsForMeasurement(this.currentBackground,this._explicitWidth,this._explicitHeight,this._explicitMinWidth,this._explicitMinHeight,this._explicitMaxWidth,this._explicitMaxHeight,this._explicitBackgroundWidth,this._explicitBackgroundHeight,this._explicitBackgroundMinWidth,this._explicitBackgroundMinHeight,this._explicitBackgroundMaxWidth,this._explicitBackgroundMaxHeight);
         if(this.currentBackground is IValidating)
         {
            IValidating(this.currentBackground).validate();
         }
         if(this.currentFill is IValidating)
         {
            IValidating(this.currentFill).validate();
         }
         var _loc6_:Number = this._explicitMinWidth;
         if(_loc3_)
         {
            if(_loc5_ !== null)
            {
               _loc6_ = _loc5_.minWidth;
            }
            else if(this.currentBackground !== null)
            {
               _loc6_ = this._explicitBackgroundMinWidth;
            }
            else
            {
               _loc6_ = 0;
            }
            _loc10_ = this._originalFillWidth;
            if(this.currentFill is IFeathersControl)
            {
               _loc10_ = Number(IFeathersControl(this.currentFill).minWidth);
            }
            _loc10_ += this._paddingLeft + this._paddingRight;
            if(_loc10_ > _loc6_)
            {
               _loc6_ = _loc10_;
            }
         }
         var _loc7_:Number = this._explicitMinHeight;
         if(_loc4_)
         {
            if(_loc5_ !== null)
            {
               _loc7_ = _loc5_.minHeight;
            }
            else if(this.currentBackground !== null)
            {
               _loc7_ = this._explicitBackgroundMinHeight;
            }
            else
            {
               _loc7_ = 0;
            }
            _loc11_ = this._originalFillHeight;
            if(this.currentFill is IFeathersControl)
            {
               _loc11_ = Number(IFeathersControl(this.currentFill).minHeight);
            }
            _loc11_ += this._paddingTop + this._paddingBottom;
            if(_loc11_ > _loc7_)
            {
               _loc7_ = _loc11_;
            }
         }
         var _loc8_:Number = this._explicitWidth;
         if(_loc1_)
         {
            if(this.currentBackground !== null)
            {
               _loc8_ = this.currentBackground.width;
            }
            else
            {
               _loc8_ = 0;
            }
            _loc12_ = this._originalFillWidth + this._paddingLeft + this._paddingRight;
            if(_loc12_ > _loc8_)
            {
               _loc8_ = _loc12_;
            }
         }
         var _loc9_:Number = this._explicitHeight;
         if(_loc2_)
         {
            if(this.currentBackground !== null)
            {
               _loc9_ = this.currentBackground.height;
            }
            else
            {
               _loc9_ = 0;
            }
            _loc13_ = this._originalFillHeight + this._paddingTop + this._paddingBottom;
            if(_loc13_ > _loc9_)
            {
               _loc9_ = _loc13_;
            }
         }
         return this.saveMeasurements(_loc8_,_loc9_,_loc6_,_loc7_);
      }
      
      protected function refreshBackground() : void
      {
         var _loc2_:IMeasureDisplayObject = null;
         var _loc1_:DisplayObject = this.currentBackground;
         this.currentBackground = this._backgroundSkin;
         if(!this._isEnabled && this._backgroundDisabledSkin !== null)
         {
            this.currentBackground = this._backgroundDisabledSkin;
         }
         if(_loc1_ !== this.currentBackground)
         {
            this.removeCurrentBackground(_loc1_);
            if(this.currentBackground !== null)
            {
               if(this.currentBackground is IFeathersControl)
               {
                  IFeathersControl(this.currentBackground).initializeNow();
               }
               if(this.currentBackground is IMeasureDisplayObject)
               {
                  _loc2_ = IMeasureDisplayObject(this.currentBackground);
                  this._explicitBackgroundWidth = _loc2_.explicitWidth;
                  this._explicitBackgroundHeight = _loc2_.explicitHeight;
                  this._explicitBackgroundMinWidth = _loc2_.explicitMinWidth;
                  this._explicitBackgroundMinHeight = _loc2_.explicitMinHeight;
                  this._explicitBackgroundMaxWidth = _loc2_.explicitMaxWidth;
                  this._explicitBackgroundMaxHeight = _loc2_.explicitMaxHeight;
               }
               else
               {
                  this._explicitBackgroundWidth = this.currentBackground.width;
                  this._explicitBackgroundHeight = this.currentBackground.height;
                  this._explicitBackgroundMinWidth = this._explicitBackgroundWidth;
                  this._explicitBackgroundMinHeight = this._explicitBackgroundHeight;
                  this._explicitBackgroundMaxWidth = this._explicitBackgroundWidth;
                  this._explicitBackgroundMaxHeight = this._explicitBackgroundHeight;
               }
               this.addChildAt(this.currentBackground,0);
            }
         }
      }
      
      protected function removeCurrentBackground(param1:DisplayObject) : void
      {
         var _loc2_:IMeasureDisplayObject = null;
         if(param1 === null)
         {
            return;
         }
         if(param1.parent === this)
         {
            param1.width = this._explicitBackgroundWidth;
            param1.height = this._explicitBackgroundHeight;
            if(param1 is IMeasureDisplayObject)
            {
               _loc2_ = IMeasureDisplayObject(param1);
               _loc2_.minWidth = this._explicitBackgroundMinWidth;
               _loc2_.minHeight = this._explicitBackgroundMinHeight;
               _loc2_.maxWidth = this._explicitBackgroundMaxWidth;
               _loc2_.maxHeight = this._explicitBackgroundMaxHeight;
            }
            param1.removeFromParent(false);
         }
      }
      
      protected function refreshFill() : void
      {
         this.currentFill = this._fillSkin;
         if(this._fillDisabledSkin)
         {
            if(this._isEnabled)
            {
               this._fillDisabledSkin.visible = false;
            }
            else
            {
               this.currentFill = this._fillDisabledSkin;
               if(this._backgroundSkin)
               {
                  this._fillSkin.visible = false;
               }
            }
         }
         if(this.currentFill)
         {
            if(this.currentFill is IValidating)
            {
               IValidating(this.currentFill).validate();
            }
            if(this._originalFillWidth !== this._originalFillWidth)
            {
               this._originalFillWidth = this.currentFill.width;
            }
            if(this._originalFillHeight !== this._originalFillHeight)
            {
               this._originalFillHeight = this.currentFill.height;
            }
            this.currentFill.visible = true;
         }
      }
      
      protected function layoutChildren() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this.currentBackground !== null)
         {
            this.currentBackground.width = this.actualWidth;
            this.currentBackground.height = this.actualHeight;
         }
         if(this._minimum == this._maximum)
         {
            _loc1_ = 1;
         }
         else
         {
            _loc1_ = (this._value - this._minimum) / (this._maximum - this._minimum);
            if(_loc1_ < 0)
            {
               _loc1_ = 0;
            }
            else if(_loc1_ > 1)
            {
               _loc1_ = 1;
            }
         }
         if(this._direction === Direction.VERTICAL)
         {
            _loc2_ = Math.round(_loc1_ * (this.actualHeight - this._paddingTop - this._paddingBottom));
            if(_loc2_ < this._originalFillHeight)
            {
               _loc2_ = this._originalFillHeight;
               this.currentFill.visible = this._value > this._minimum;
            }
            else
            {
               this.currentFill.visible = true;
            }
            this.currentFill.width = this.actualWidth - this._paddingLeft - this._paddingRight;
            this.currentFill.height = _loc2_;
            this.currentFill.x = this._paddingLeft;
            this.currentFill.y = this.actualHeight - this._paddingBottom - this.currentFill.height;
         }
         else
         {
            _loc3_ = Math.round(_loc1_ * (this.actualWidth - this._paddingLeft - this._paddingRight));
            if(_loc3_ < this._originalFillWidth)
            {
               _loc3_ = this._originalFillWidth;
               this.currentFill.visible = this._value > this._minimum;
            }
            else
            {
               this.currentFill.visible = true;
            }
            this.currentFill.width = _loc3_;
            this.currentFill.height = this.actualHeight - this._paddingTop - this._paddingBottom;
            this.currentFill.x = this._paddingLeft;
            this.currentFill.y = this._paddingTop;
         }
      }
   }
}

