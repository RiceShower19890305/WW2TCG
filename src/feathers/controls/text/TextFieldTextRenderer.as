package feathers.controls.text
{
   import feathers.core.IFeathersControl;
   import feathers.core.ITextRenderer;
   import feathers.core.IToggle;
   import feathers.skins.IStyleProvider;
   import feathers.utils.geom.matrixToScaleX;
   import feathers.utils.geom.matrixToScaleY;
   import feathers.utils.math.roundUpToNearest;
   import feathers.utils.textures.calculateSnapshotTextureDimensions;
   import flash.display.BitmapData;
   import flash.display3D.Context3DProfile;
   import flash.filters.BitmapFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.FontType;
   import flash.text.StyleSheet;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.events.Event;
   import starling.rendering.Painter;
   import starling.text.TextFormat;
   import starling.textures.ConcreteTexture;
   import starling.textures.Texture;
   import starling.utils.Align;
   import starling.utils.MathUtil;
   import starling.utils.Pool;
   import starling.utils.SystemUtil;
   
   public class TextFieldTextRenderer extends BaseTextRenderer implements ITextRenderer
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      private static const HELPER_POINT:Point = new Point();
      
      private static const HELPER_MATRIX:Matrix = new Matrix();
      
      private static const HELPER_RECTANGLE:flash.geom.Rectangle = new flash.geom.Rectangle();
      
      protected var textField:TextField;
      
      protected var textSnapshot:Image;
      
      protected var textSnapshots:Vector.<Image>;
      
      protected var _textSnapshotOffsetX:Number = 0;
      
      protected var _textSnapshotOffsetY:Number = 0;
      
      protected var _previousActualWidth:Number = NaN;
      
      protected var _previousActualHeight:Number = NaN;
      
      protected var _snapshotWidth:int = 0;
      
      protected var _snapshotHeight:int = 0;
      
      protected var _snapshotVisibleWidth:int = 0;
      
      protected var _snapshotVisibleHeight:int = 0;
      
      protected var _needsTextureUpdate:Boolean = false;
      
      protected var _needsNewTexture:Boolean = false;
      
      protected var _hasMeasured:Boolean = false;
      
      protected var _isHTML:Boolean = false;
      
      protected var _currentTextFormat:flash.text.TextFormat;
      
      protected var _fontStylesTextFormat:flash.text.TextFormat;
      
      protected var _currentVerticalAlign:String;
      
      protected var _verticalAlignOffsetY:Number = 0;
      
      protected var _textFormatForState:Object;
      
      protected var _textFormat:flash.text.TextFormat;
      
      protected var _disabledTextFormat:flash.text.TextFormat;
      
      protected var _selectedTextFormat:flash.text.TextFormat;
      
      protected var _styleSheet:StyleSheet;
      
      protected var _embedFonts:Boolean = false;
      
      protected var _pixelSnapping:Boolean = true;
      
      private var _antiAliasType:String = "advanced";
      
      private var _background:Boolean = false;
      
      private var _backgroundColor:uint = 16777215;
      
      private var _border:Boolean = false;
      
      private var _borderColor:uint = 0;
      
      private var _condenseWhite:Boolean = false;
      
      private var _displayAsPassword:Boolean = false;
      
      private var _gridFitType:String = "pixel";
      
      private var _sharpness:Number = 0;
      
      private var _thickness:Number = 0;
      
      protected var _maxTextureDimensions:int = 2048;
      
      protected var _nativeFilters:Array;
      
      protected var _useGutter:Boolean = false;
      
      protected var _lastGlobalScaleX:Number = 0;
      
      protected var _lastGlobalScaleY:Number = 0;
      
      protected var _lastContentScaleFactor:Number = 0;
      
      protected var _updateSnapshotOnScaleChange:Boolean = false;
      
      protected var _useSnapshotDelayWorkaround:Boolean = false;
      
      public function TextFieldTextRenderer()
      {
         if(this._text === null)
         {
            this._text = "";
         }
         super();
         this.isQuickHitAreaEnabled = true;
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return TextFieldTextRenderer.globalStyleProvider;
      }
      
      override public function set text(param1:String) : void
      {
         if(param1 === null)
         {
            param1 = "";
         }
         super.text = param1;
      }
      
      public function get isHTML() : Boolean
      {
         return this._isHTML;
      }
      
      public function set isHTML(param1:Boolean) : void
      {
         if(this._isHTML == param1)
         {
            return;
         }
         this._isHTML = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get numLines() : int
      {
         if(this.textField === null)
         {
            return 0;
         }
         return this.textField.numLines;
      }
      
      public function get currentTextFormat() : flash.text.TextFormat
      {
         return this._currentTextFormat;
      }
      
      public function get textFormat() : flash.text.TextFormat
      {
         return this._textFormat;
      }
      
      public function set textFormat(param1:flash.text.TextFormat) : void
      {
         if(this._textFormat == param1)
         {
            return;
         }
         this._textFormat = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get disabledTextFormat() : flash.text.TextFormat
      {
         return this._disabledTextFormat;
      }
      
      public function set disabledTextFormat(param1:flash.text.TextFormat) : void
      {
         if(this._disabledTextFormat == param1)
         {
            return;
         }
         this._disabledTextFormat = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get selectedTextFormat() : flash.text.TextFormat
      {
         return this._selectedTextFormat;
      }
      
      public function set selectedTextFormat(param1:flash.text.TextFormat) : void
      {
         if(this._selectedTextFormat == param1)
         {
            return;
         }
         this._selectedTextFormat = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get styleSheet() : StyleSheet
      {
         return this._styleSheet;
      }
      
      public function set styleSheet(param1:StyleSheet) : void
      {
         if(this._styleSheet == param1)
         {
            return;
         }
         this._styleSheet = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get embedFonts() : Boolean
      {
         return this._embedFonts;
      }
      
      public function set embedFonts(param1:Boolean) : void
      {
         if(this._embedFonts == param1)
         {
            return;
         }
         this._embedFonts = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get baseline() : Number
      {
         if(!this.textField)
         {
            return 0;
         }
         var _loc1_:Number = 0;
         if(this._useGutter || this._border)
         {
            _loc1_ = 2;
         }
         return _loc1_ + this.textField.getLineMetrics(0).ascent;
      }
      
      public function get pixelSnapping() : Boolean
      {
         return this._pixelSnapping;
      }
      
      public function set pixelSnapping(param1:Boolean) : void
      {
         if(this._pixelSnapping === param1)
         {
            return;
         }
         this._pixelSnapping = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get antiAliasType() : String
      {
         return this._antiAliasType;
      }
      
      public function set antiAliasType(param1:String) : void
      {
         if(this._antiAliasType == param1)
         {
            return;
         }
         this._antiAliasType = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get background() : Boolean
      {
         return this._background;
      }
      
      public function set background(param1:Boolean) : void
      {
         if(this._background == param1)
         {
            return;
         }
         this._background = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get backgroundColor() : uint
      {
         return this._backgroundColor;
      }
      
      public function set backgroundColor(param1:uint) : void
      {
         if(this._backgroundColor == param1)
         {
            return;
         }
         this._backgroundColor = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get border() : Boolean
      {
         return this._border;
      }
      
      public function set border(param1:Boolean) : void
      {
         if(this._border == param1)
         {
            return;
         }
         this._border = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get borderColor() : uint
      {
         return this._borderColor;
      }
      
      public function set borderColor(param1:uint) : void
      {
         if(this._borderColor == param1)
         {
            return;
         }
         this._borderColor = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get condenseWhite() : Boolean
      {
         return this._condenseWhite;
      }
      
      public function set condenseWhite(param1:Boolean) : void
      {
         if(this._condenseWhite == param1)
         {
            return;
         }
         this._condenseWhite = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get displayAsPassword() : Boolean
      {
         return this._displayAsPassword;
      }
      
      public function set displayAsPassword(param1:Boolean) : void
      {
         if(this._displayAsPassword == param1)
         {
            return;
         }
         this._displayAsPassword = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get gridFitType() : String
      {
         return this._gridFitType;
      }
      
      public function set gridFitType(param1:String) : void
      {
         if(this._gridFitType == param1)
         {
            return;
         }
         this._gridFitType = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get sharpness() : Number
      {
         return this._sharpness;
      }
      
      public function set sharpness(param1:Number) : void
      {
         if(this._sharpness == param1)
         {
            return;
         }
         this._sharpness = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get thickness() : Number
      {
         return this._thickness;
      }
      
      public function set thickness(param1:Number) : void
      {
         if(this._thickness == param1)
         {
            return;
         }
         this._thickness = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get maxTextureDimensions() : int
      {
         return this._maxTextureDimensions;
      }
      
      public function set maxTextureDimensions(param1:int) : void
      {
         var _loc2_:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         if(_loc2_.profile === Context3DProfile.BASELINE_CONSTRAINED)
         {
            param1 = MathUtil.getNextPowerOfTwo(param1);
         }
         if(this._maxTextureDimensions == param1)
         {
            return;
         }
         this._maxTextureDimensions = param1;
         this._needsNewTexture = true;
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
      
      public function get nativeFilters() : Array
      {
         return this._nativeFilters;
      }
      
      public function set nativeFilters(param1:Array) : void
      {
         if(this._nativeFilters == param1)
         {
            return;
         }
         this._nativeFilters = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get useGutter() : Boolean
      {
         return this._useGutter || this._border;
      }
      
      public function set useGutter(param1:Boolean) : void
      {
         if(this._useGutter == param1)
         {
            return;
         }
         this._useGutter = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get updateSnapshotOnScaleChange() : Boolean
      {
         return this._updateSnapshotOnScaleChange;
      }
      
      public function set updateSnapshotOnScaleChange(param1:Boolean) : void
      {
         if(this._updateSnapshotOnScaleChange == param1)
         {
            return;
         }
         this._updateSnapshotOnScaleChange = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get useSnapshotDelayWorkaround() : Boolean
      {
         return this._useSnapshotDelayWorkaround;
      }
      
      public function set useSnapshotDelayWorkaround(param1:Boolean) : void
      {
         if(this._useSnapshotDelayWorkaround == param1)
         {
            return;
         }
         this._useSnapshotDelayWorkaround = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      override public function dispose() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Image = null;
         if(this.textSnapshot)
         {
            this.textSnapshot.texture.dispose();
            this.removeChild(this.textSnapshot,true);
            this.textSnapshot = null;
         }
         if(this.textSnapshots)
         {
            _loc1_ = int(this.textSnapshots.length);
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc3_ = this.textSnapshots[_loc2_];
               _loc3_.texture.dispose();
               this.removeChild(_loc3_,true);
               _loc2_++;
            }
            this.textSnapshots = null;
         }
         this.textField = null;
         this._previousActualWidth = NaN;
         this._previousActualHeight = NaN;
         this._needsNewTexture = false;
         this._snapshotWidth = 0;
         this._snapshotHeight = 0;
         super.dispose();
      }
      
      override public function render(param1:Painter) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Image = null;
         var _loc2_:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         if(this._updateSnapshotOnScaleChange)
         {
            this.getTransformationMatrix(this.stage,HELPER_MATRIX);
            _loc3_ = matrixToScaleX(HELPER_MATRIX);
            _loc4_ = matrixToScaleY(HELPER_MATRIX);
            if(_loc3_ != this._lastGlobalScaleX || _loc4_ != this._lastGlobalScaleY || _loc2_.contentScaleFactor != this._lastContentScaleFactor)
            {
               this.invalidate(INVALIDATION_FLAG_SIZE);
               this.validate();
            }
         }
         if(this._needsTextureUpdate)
         {
            this._needsTextureUpdate = false;
            if(this._text.length > 0)
            {
               if(this._useSnapshotDelayWorkaround)
               {
                  this.addEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
               }
               else
               {
                  this.refreshSnapshot();
               }
            }
         }
         if(this.textSnapshot !== null)
         {
            _loc5_ = _loc2_.contentScaleFactor;
            if(!this._nativeFilters || this._nativeFilters.length == 0)
            {
               _loc11_ = 0;
               _loc12_ = 0;
            }
            else
            {
               _loc11_ = this._textSnapshotOffsetX / _loc5_;
               _loc12_ = this._textSnapshotOffsetY / _loc5_;
            }
            _loc12_ += this._verticalAlignOffsetY * _loc5_;
            _loc6_ = -1;
            _loc7_ = this._snapshotWidth;
            _loc8_ = this._snapshotHeight;
            _loc9_ = _loc11_;
            _loc10_ = _loc12_;
            do
            {
               _loc13_ = _loc7_;
               if(_loc13_ > this._maxTextureDimensions)
               {
                  _loc13_ = this._maxTextureDimensions;
               }
               do
               {
                  _loc14_ = _loc8_;
                  if(_loc14_ > this._maxTextureDimensions)
                  {
                     _loc14_ = this._maxTextureDimensions;
                  }
                  if(_loc6_ < 0)
                  {
                     _loc15_ = this.textSnapshot;
                     _loc15_.visible = this._text.length > 0 && this._snapshotWidth > 0 && this._snapshotHeight > 0;
                  }
                  else
                  {
                     _loc15_ = this.textSnapshots[_loc6_];
                  }
                  _loc15_.pixelSnapping = this._pixelSnapping;
                  _loc15_.x = _loc9_ / _loc5_;
                  _loc15_.y = _loc10_ / _loc5_;
                  _loc6_++;
                  _loc10_ += _loc14_;
               }
               while(_loc8_ -= _loc14_, _loc8_ > 0);
               _loc9_ += _loc13_;
               _loc7_ -= _loc13_;
               _loc10_ = _loc12_;
               _loc8_ = this._snapshotHeight;
            }
            while(_loc7_ > 0);
         }
         super.render(param1);
      }
      
      public function measureText(param1:Point = null) : Point
      {
         if(!param1)
         {
            param1 = new Point();
         }
         var _loc2_:Boolean = this._explicitWidth !== this._explicitWidth;
         var _loc3_:Boolean = this._explicitHeight !== this._explicitHeight;
         if(!_loc2_ && !_loc3_)
         {
            param1.x = this._explicitWidth;
            param1.y = this._explicitHeight;
            return param1;
         }
         if(!this._isInitialized)
         {
            this.initializeNow();
         }
         this.commit();
         return this.measure(param1);
      }
      
      public function getTextFormatForState(param1:String) : flash.text.TextFormat
      {
         if(this._textFormatForState === null)
         {
            return null;
         }
         return TextFormat(this._textFormatForState[param1]);
      }
      
      public function setTextFormatForState(param1:String, param2:flash.text.TextFormat) : void
      {
         if(param2)
         {
            if(!this._textFormatForState)
            {
               this._textFormatForState = {};
            }
            this._textFormatForState[param1] = param2;
         }
         else
         {
            delete this._textFormatForState[param1];
         }
         if(Boolean(this._stateContext) && this._stateContext.currentState === param1)
         {
            this.invalidate(INVALIDATION_FLAG_STATE);
         }
      }
      
      override protected function initialize() : void
      {
         var _loc1_:Starling = null;
         var _loc2_:Number = NaN;
         if(this.textField === null)
         {
            this.textField = new TextField();
            _loc1_ = this.stage !== null ? this.stage.starling : Starling.current;
            _loc2_ = _loc1_.contentScaleFactor;
            this.textField.scaleX = _loc2_;
            this.textField.scaleY = _loc2_;
            this.textField.mouseEnabled = this.textField.mouseWheelEnabled = false;
            this.textField.selectable = false;
            this.textField.multiline = true;
         }
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
         this.commit();
         this._hasMeasured = false;
         _loc1_ = this.autoSizeIfNeeded() || _loc1_;
         this._verticalAlignOffsetY = this.getVerticalAlignOffsetY();
         this.layout(_loc1_);
      }
      
      protected function commit() : void
      {
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         if(_loc1_ || _loc3_)
         {
            this.refreshTextFormat();
         }
         if(_loc1_)
         {
            this.textField.antiAliasType = this._antiAliasType;
            this.textField.background = this._background;
            this.textField.backgroundColor = this._backgroundColor;
            this.textField.border = this._border;
            this.textField.borderColor = this._borderColor;
            this.textField.condenseWhite = this._condenseWhite;
            this.textField.displayAsPassword = this._displayAsPassword;
            this.textField.gridFitType = this._gridFitType;
            this.textField.sharpness = this._sharpness;
            this.textField.thickness = this._thickness;
            this.textField.filters = this._nativeFilters;
         }
         if(_loc2_ || _loc1_ || _loc3_)
         {
            this.textField.wordWrap = this._wordWrap;
            if(this._styleSheet)
            {
               this.textField.embedFonts = this._embedFonts;
               this.textField.styleSheet = this._styleSheet;
            }
            else
            {
               if(!this._embedFonts && this._currentTextFormat === this._fontStylesTextFormat)
               {
                  this.textField.embedFonts = SystemUtil.isEmbeddedFont(this._currentTextFormat.font,this._currentTextFormat.bold,this._currentTextFormat.italic,FontType.EMBEDDED);
               }
               else
               {
                  this.textField.embedFonts = this._embedFonts;
               }
               this.textField.styleSheet = null;
               this.textField.defaultTextFormat = this._currentTextFormat;
            }
            if(this._isHTML)
            {
               this.textField.htmlText = this._text;
            }
            else
            {
               this.textField.text = this._text;
            }
         }
      }
      
      protected function measure(param1:Point = null) : Point
      {
         var _loc9_:Number = NaN;
         if(!param1)
         {
            param1 = new Point();
         }
         var _loc2_:Boolean = this._explicitWidth !== this._explicitWidth;
         var _loc3_:Boolean = this._explicitHeight !== this._explicitHeight;
         this.textField.autoSize = TextFieldAutoSize.LEFT;
         this.textField.wordWrap = false;
         var _loc4_:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         var _loc5_:Number = _loc4_.contentScaleFactor;
         var _loc6_:Number = 4;
         if(this._useGutter || this._border)
         {
            _loc6_ = 0;
         }
         var _loc7_:Number = this._explicitWidth;
         if(_loc2_)
         {
            _loc9_ = this.textField.width;
            _loc7_ = this.textField.width / _loc5_ - _loc6_;
            if(_loc7_ < this._explicitMinWidth)
            {
               _loc7_ = this._explicitMinWidth;
            }
            else if(_loc7_ > this._explicitMaxWidth)
            {
               _loc7_ = this._explicitMaxWidth;
            }
         }
         if(!_loc2_ || this.textField.width / _loc5_ - _loc6_ > _loc7_)
         {
            this.textField.width = _loc7_ + _loc6_;
            this.textField.wordWrap = this._wordWrap;
         }
         var _loc8_:Number = this._explicitHeight;
         if(_loc3_)
         {
            _loc8_ = this.textField.height / _loc5_ - _loc6_;
            _loc8_ = roundUpToNearest(_loc8_,0.05);
            if(_loc8_ < this._explicitMinHeight)
            {
               _loc8_ = this._explicitMinHeight;
            }
            else if(_loc8_ > this._explicitMaxHeight)
            {
               _loc8_ = this._explicitMaxHeight;
            }
         }
         this.textField.autoSize = TextFieldAutoSize.NONE;
         this.textField.width = this.actualWidth + _loc6_;
         this.textField.height = this.actualHeight + _loc6_;
         param1.x = _loc7_;
         param1.y = _loc8_;
         this._hasMeasured = true;
         return param1;
      }
      
      protected function layout(param1:Boolean) : void
      {
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         var _loc4_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         var _loc5_:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         var _loc6_:Number = _loc5_.contentScaleFactor;
         var _loc7_:Number = 4;
         if(this._useGutter || this._border)
         {
            _loc7_ = 0;
         }
         if(!this._hasMeasured && this._wordWrap)
         {
            this.textField.autoSize = TextFieldAutoSize.LEFT;
            this.textField.wordWrap = false;
            if(this.textField.width / _loc6_ - _loc7_ > this.actualWidth)
            {
               this.textField.wordWrap = true;
            }
            this.textField.autoSize = TextFieldAutoSize.NONE;
            this.textField.width = this.actualWidth + _loc7_;
         }
         if(param1)
         {
            this.textField.width = this.actualWidth + _loc7_;
            this.textField.height = this.actualHeight + _loc7_;
            this.calculateSnapshotDimensions();
         }
         if(_loc2_ || _loc3_ || _loc4_ || this._needsNewTexture || this.actualWidth != this._previousActualWidth || this.actualHeight != this._previousActualHeight)
         {
            this._previousActualWidth = this.actualWidth;
            this._previousActualHeight = this.actualHeight;
            this._needsTextureUpdate = true;
            this.setRequiresRedraw();
         }
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc1_:Boolean = this._explicitWidth !== this._explicitWidth;
         var _loc2_:Boolean = this._explicitHeight !== this._explicitHeight;
         var _loc3_:Boolean = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc4_:Boolean = this._explicitMinHeight !== this._explicitMinHeight;
         if(!_loc1_ && !_loc2_ && !_loc3_ && !_loc4_)
         {
            return false;
         }
         this.measure(HELPER_POINT);
         var _loc5_:Number = this._explicitWidth;
         if(_loc1_)
         {
            _loc5_ = HELPER_POINT.x;
         }
         var _loc6_:Number = this._explicitHeight;
         if(_loc2_)
         {
            _loc6_ = HELPER_POINT.y;
         }
         var _loc7_:Number = this._explicitMinWidth;
         if(_loc3_)
         {
            if(_loc1_)
            {
               _loc7_ = 0;
            }
            else
            {
               _loc7_ = _loc5_;
            }
         }
         var _loc8_:Number = this._explicitMinHeight;
         if(_loc4_)
         {
            _loc8_ = _loc6_;
         }
         return this.saveMeasurements(_loc5_,_loc6_,_loc7_,_loc8_);
      }
      
      protected function measureNativeFilters(param1:BitmapData, param2:flash.geom.Rectangle = null) : flash.geom.Rectangle
      {
         var _loc9_:BitmapFilter = null;
         var _loc10_:flash.geom.Rectangle = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         if(!param2)
         {
            param2 = new flash.geom.Rectangle();
         }
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         var _loc6_:Number = 0;
         var _loc7_:int = int(this._nativeFilters.length);
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            _loc9_ = this._nativeFilters[_loc8_];
            _loc10_ = param1.generateFilterRect(param1.rect,_loc9_);
            _loc11_ = _loc10_.x;
            _loc12_ = _loc10_.y;
            _loc13_ = _loc10_.width;
            _loc14_ = _loc10_.height;
            if(_loc3_ > _loc11_)
            {
               _loc3_ = _loc11_;
            }
            if(_loc4_ > _loc12_)
            {
               _loc4_ = _loc12_;
            }
            if(_loc5_ < _loc13_)
            {
               _loc5_ = _loc13_;
            }
            if(_loc6_ < _loc14_)
            {
               _loc6_ = _loc14_;
            }
            _loc8_++;
         }
         param2.setTo(_loc3_,_loc4_,_loc5_,_loc6_);
         return param2;
      }
      
      protected function refreshTextFormat() : void
      {
         var _loc1_:flash.text.TextFormat = null;
         var _loc2_:String = null;
         if(this._stateContext !== null)
         {
            if(this._textFormatForState !== null)
            {
               _loc2_ = this._stateContext.currentState;
               if(_loc2_ in this._textFormatForState)
               {
                  _loc1_ = TextFormat(this._textFormatForState[_loc2_]);
               }
            }
            if(_loc1_ === null && this._disabledTextFormat !== null && this._stateContext is IFeathersControl && !IFeathersControl(this._stateContext).isEnabled)
            {
               _loc1_ = this._disabledTextFormat;
            }
            if(_loc1_ === null && this._selectedTextFormat !== null && this._stateContext is IToggle && IToggle(this._stateContext).isSelected)
            {
               _loc1_ = this._selectedTextFormat;
            }
         }
         else if(!this._isEnabled && this._disabledTextFormat !== null)
         {
            _loc1_ = this._disabledTextFormat;
         }
         switch(_loc1_)
         {
            case null:
               _loc1_ = this._textFormat;
               if(_loc1_ === null)
               {
               }
            case null:
               _loc1_ = this.getTextFormatFromFontStyles();
               break;
            default:
               this._currentVerticalAlign = Align.TOP;
         }
         this._currentTextFormat = _loc1_;
      }
      
      protected function getTextFormatFromFontStyles() : flash.text.TextFormat
      {
         var _loc1_:starling.text.TextFormat = null;
         if(this.isInvalid(INVALIDATION_FLAG_STYLES) || this.isInvalid(INVALIDATION_FLAG_STATE))
         {
            if(this._fontStyles !== null)
            {
               _loc1_ = this._fontStyles.getTextFormatForTarget(this);
            }
            if(_loc1_ !== null)
            {
               this._fontStylesTextFormat = _loc1_.toNativeFormat(this._fontStylesTextFormat);
               this._currentVerticalAlign = _loc1_.verticalAlign;
            }
            else if(this._fontStylesTextFormat === null)
            {
               this._fontStylesTextFormat = new flash.text.TextFormat();
               this._currentVerticalAlign = Align.TOP;
            }
         }
         return this._fontStylesTextFormat;
      }
      
      protected function getVerticalAlignOffsetY() : Number
      {
         var _loc1_:Number = this.textField.textHeight;
         if(_loc1_ > this.actualHeight)
         {
            return 0;
         }
         if(this._currentVerticalAlign === Align.BOTTOM)
         {
            return this.actualHeight - _loc1_;
         }
         if(this._currentVerticalAlign === Align.CENTER)
         {
            return (this.actualHeight - _loc1_) / 2;
         }
         return 0;
      }
      
      protected function createTextureOnRestoreCallback(param1:Image) : void
      {
         var self:TextFieldTextRenderer = null;
         var texture:Texture = null;
         var snapshot:Image = param1;
         self = this;
         texture = snapshot.texture;
         texture.root.onRestore = function():void
         {
            var _loc1_:Starling = self.stage !== null ? self.stage.starling : Starling.current;
            var _loc2_:Number = _loc1_.contentScaleFactor;
            HELPER_MATRIX.identity();
            HELPER_MATRIX.scale(_loc2_,_loc2_);
            var _loc3_:Number = self.getVerticalAlignOffsetY();
            var _loc4_:BitmapData = self.drawTextFieldRegionToBitmapData(snapshot.x,snapshot.y - _loc3_,texture.nativeWidth,texture.nativeHeight);
            texture.root.uploadBitmapData(_loc4_);
            _loc4_.dispose();
         };
      }
      
      protected function drawTextFieldRegionToBitmapData(param1:Number, param2:Number, param3:Number, param4:Number, param5:BitmapData = null) : BitmapData
      {
         var _loc6_:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         var _loc7_:Number = _loc6_.contentScaleFactor;
         var _loc8_:Number = this._snapshotVisibleWidth - param1;
         var _loc9_:Number = this._snapshotVisibleHeight - param2;
         if(!param5 || param5.width != param3 || param5.height != param4)
         {
            if(param5)
            {
               param5.dispose();
            }
            param5 = new BitmapData(param3,param4,true,16711935);
         }
         else
         {
            param5.fillRect(param5.rect,16711935);
         }
         var _loc10_:Number = 2 * _loc7_;
         if(this._useGutter || this._border)
         {
            _loc10_ = 0;
         }
         HELPER_MATRIX.tx = -(param1 + _loc10_) - this._textSnapshotOffsetX;
         HELPER_MATRIX.ty = -(param2 + _loc10_) - this._textSnapshotOffsetY;
         HELPER_RECTANGLE.setTo(0,0,_loc8_,_loc9_);
         param5.draw(this.textField,HELPER_MATRIX,null,null,HELPER_RECTANGLE);
         return param5;
      }
      
      protected function calculateSnapshotDimensions() : void
      {
         var _loc7_:BitmapData = null;
         var _loc1_:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         var _loc2_:Number = _loc1_.contentScaleFactor;
         this._lastContentScaleFactor = _loc2_;
         var _loc3_:Number = Math.ceil(this.textField.width);
         var _loc4_:Number = Math.ceil(this.textField.height);
         if(this._updateSnapshotOnScaleChange)
         {
            this.getTransformationMatrix(this.stage,HELPER_MATRIX);
            this._lastGlobalScaleX = matrixToScaleX(HELPER_MATRIX);
            this._lastGlobalScaleY = matrixToScaleY(HELPER_MATRIX);
            _loc3_ *= this._lastGlobalScaleX;
            _loc4_ *= this._lastGlobalScaleY;
         }
         if(_loc3_ >= 1 && _loc4_ >= 1 && this._nativeFilters !== null && this._nativeFilters.length > 0)
         {
            HELPER_MATRIX.identity();
            HELPER_MATRIX.scale(_loc2_,_loc2_);
            _loc7_ = new BitmapData(_loc3_,_loc4_,true,16711935);
            _loc7_.draw(this.textField,HELPER_MATRIX,null,null,HELPER_RECTANGLE);
            this.measureNativeFilters(_loc7_,HELPER_RECTANGLE);
            _loc7_.dispose();
            _loc7_ = null;
            this._textSnapshotOffsetX = HELPER_RECTANGLE.x;
            this._textSnapshotOffsetY = HELPER_RECTANGLE.y;
            _loc3_ = HELPER_RECTANGLE.width;
            _loc4_ = HELPER_RECTANGLE.height;
         }
         var _loc5_:Point = Pool.getPoint();
         calculateSnapshotTextureDimensions(_loc3_,_loc4_,this._maxTextureDimensions,_loc1_.profile !== Context3DProfile.BASELINE_CONSTRAINED,_loc5_);
         this._snapshotWidth = _loc5_.x;
         this._snapshotHeight = _loc5_.y;
         this._snapshotVisibleWidth = _loc3_;
         this._snapshotVisibleHeight = _loc4_;
         Pool.putPoint(_loc5_);
         var _loc6_:ConcreteTexture = this.textSnapshot ? this.textSnapshot.texture.root : null;
         this._needsNewTexture = this._needsNewTexture || this.textSnapshot === null || _loc6_ !== null && (_loc6_.scale != _loc2_ || this._snapshotWidth != _loc6_.nativeWidth || this._snapshotHeight != _loc6_.nativeHeight);
      }
      
      protected function refreshSnapshot() : void
      {
         var _loc7_:BitmapData = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Texture = null;
         var _loc14_:Image = null;
         var _loc15_:Texture = null;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         if(this._snapshotWidth <= 0 || this._snapshotHeight <= 0)
         {
            return;
         }
         var _loc1_:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         var _loc2_:Number = _loc1_.contentScaleFactor;
         if(this._updateSnapshotOnScaleChange)
         {
            this.getTransformationMatrix(this.stage,HELPER_MATRIX);
            _loc9_ = matrixToScaleX(HELPER_MATRIX);
            _loc10_ = matrixToScaleY(HELPER_MATRIX);
         }
         HELPER_MATRIX.identity();
         HELPER_MATRIX.scale(_loc2_,_loc2_);
         if(this._updateSnapshotOnScaleChange)
         {
            HELPER_MATRIX.scale(_loc9_,_loc10_);
         }
         var _loc3_:Number = this._snapshotWidth;
         var _loc4_:Number = this._snapshotHeight;
         var _loc5_:Number = 0;
         var _loc6_:Number = 0;
         var _loc8_:int = -1;
         do
         {
            _loc11_ = _loc3_;
            if(_loc11_ > this._maxTextureDimensions)
            {
               _loc11_ = this._maxTextureDimensions;
            }
            do
            {
               _loc12_ = _loc4_;
               if(_loc12_ > this._maxTextureDimensions)
               {
                  _loc12_ = this._maxTextureDimensions;
               }
               _loc7_ = this.drawTextFieldRegionToBitmapData(_loc5_,_loc6_,_loc11_,_loc12_,_loc7_);
               if(!this.textSnapshot || this._needsNewTexture)
               {
                  _loc13_ = Texture.empty(_loc7_.width / _loc2_,_loc7_.height / _loc2_,true,false,false,_loc2_);
                  _loc13_.root.uploadBitmapData(_loc7_);
               }
               _loc14_ = null;
               if(_loc8_ >= 0)
               {
                  if(!this.textSnapshots)
                  {
                     this.textSnapshots = new Vector.<Image>(0);
                  }
                  else if(this.textSnapshots.length > _loc8_)
                  {
                     _loc14_ = this.textSnapshots[_loc8_];
                  }
               }
               else
               {
                  _loc14_ = this.textSnapshot;
               }
               if(!_loc14_)
               {
                  _loc14_ = new Image(_loc13_);
                  _loc14_.pixelSnapping = true;
                  this.addChild(_loc14_);
               }
               else if(this._needsNewTexture)
               {
                  _loc14_.texture.dispose();
                  _loc14_.texture = _loc13_;
                  _loc14_.readjustSize();
               }
               else
               {
                  _loc15_ = _loc14_.texture;
                  _loc15_.root.uploadBitmapData(_loc7_);
                  this.textSnapshot.setRequiresRedraw();
               }
               if(_loc13_)
               {
                  this.createTextureOnRestoreCallback(_loc14_);
               }
               if(_loc8_ >= 0)
               {
                  this.textSnapshots[_loc8_] = _loc14_;
               }
               else
               {
                  this.textSnapshot = _loc14_;
               }
               _loc14_.x = _loc5_ / _loc2_;
               _loc14_.y = _loc6_ / _loc2_;
               if(this._updateSnapshotOnScaleChange)
               {
                  _loc14_.scaleX = 1 / _loc9_;
                  _loc14_.scaleY = 1 / _loc10_;
               }
               else
               {
                  _loc14_.scale = 1;
               }
               _loc8_++;
               _loc6_ += _loc12_;
            }
            while(_loc4_ -= _loc12_, _loc4_ > 0);
            _loc5_ += _loc11_;
            _loc3_ -= _loc11_;
            _loc6_ = 0;
            _loc4_ = this._snapshotHeight;
         }
         while(_loc3_ > 0);
         _loc7_.dispose();
         if(this.textSnapshots)
         {
            _loc16_ = int(this.textSnapshots.length);
            _loc17_ = _loc8_;
            while(_loc17_ < _loc16_)
            {
               _loc14_ = this.textSnapshots[_loc17_];
               _loc14_.texture.dispose();
               _loc14_.removeFromParent(true);
               _loc17_++;
            }
            if(_loc8_ == 0)
            {
               this.textSnapshots = null;
            }
            else
            {
               this.textSnapshots.length = _loc8_;
            }
         }
         if(this._updateSnapshotOnScaleChange)
         {
            this._lastGlobalScaleX = _loc9_;
            this._lastGlobalScaleY = _loc10_;
            this._lastContentScaleFactor = _loc2_;
         }
         this._needsNewTexture = false;
      }
      
      protected function enterFrameHandler(param1:Event) : void
      {
         this.removeEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
         this.refreshSnapshot();
      }
   }
}

