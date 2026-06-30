package feathers.controls.text
{
   import feathers.core.IFeathersControl;
   import feathers.core.ITextRenderer;
   import feathers.core.IToggle;
   import feathers.layout.HorizontalAlign;
   import feathers.skins.IStyleProvider;
   import feathers.utils.geom.matrixToScaleX;
   import feathers.utils.geom.matrixToScaleY;
   import feathers.utils.textures.calculateSnapshotTextureDimensions;
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.display3D.Context3DProfile;
   import flash.filters.BitmapFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.FontType;
   import flash.text.engine.ContentElement;
   import flash.text.engine.ElementFormat;
   import flash.text.engine.FontDescription;
   import flash.text.engine.FontLookup;
   import flash.text.engine.FontPosture;
   import flash.text.engine.FontWeight;
   import flash.text.engine.Kerning;
   import flash.text.engine.SpaceJustifier;
   import flash.text.engine.TabStop;
   import flash.text.engine.TextBlock;
   import flash.text.engine.TextElement;
   import flash.text.engine.TextJustifier;
   import flash.text.engine.TextLine;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.rendering.Painter;
   import starling.text.TextFormat;
   import starling.textures.ConcreteTexture;
   import starling.textures.Texture;
   import starling.utils.Align;
   import starling.utils.MathUtil;
   import starling.utils.Pool;
   import starling.utils.SystemUtil;
   
   public class TextBlockTextRenderer extends BaseTextRenderer implements ITextRenderer
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      private static const HELPER_POINT:Point = new Point();
      
      private static const HELPER_RESULT:MeasureTextResult = new MeasureTextResult();
      
      private static const HELPER_MATRIX:Matrix = new Matrix();
      
      private static var HELPER_TEXT_LINES:Vector.<TextLine> = new Vector.<TextLine>(0);
      
      protected static const MAX_TEXT_LINE_WIDTH:Number = 1000000;
      
      protected static const LINE_FEED:String = "\n";
      
      protected static const CARRIAGE_RETURN:String = "\r";
      
      protected static const FUZZY_TRUNCATION_DIFFERENCE:Number = 0.000001;
      
      protected var textBlock:TextBlock;
      
      protected var textSnapshot:Image;
      
      protected var textSnapshots:Vector.<Image>;
      
      protected var _textSnapshotScrollX:Number = 0;
      
      protected var _textSnapshotScrollY:Number = 0;
      
      protected var _textSnapshotOffsetX:Number = 0;
      
      protected var _textSnapshotOffsetY:Number = 0;
      
      protected var _textSnapshotNativeFiltersWidth:Number = 0;
      
      protected var _textSnapshotNativeFiltersHeight:Number = 0;
      
      protected var _lastGlobalScaleX:Number = 0;
      
      protected var _lastGlobalScaleY:Number = 0;
      
      protected var _lastGlobalContentScaleFactor:Number = 0;
      
      protected var _textLineContainer:Sprite;
      
      protected var _textLines:Vector.<TextLine> = new Vector.<TextLine>(0);
      
      protected var _measurementTextLineContainer:Sprite;
      
      protected var _measurementTextLines:Vector.<TextLine> = new Vector.<TextLine>(0);
      
      protected var _previousLayoutActualWidth:Number = NaN;
      
      protected var _previousLayoutActualHeight:Number = NaN;
      
      protected var _savedTextLinesWidth:Number = NaN;
      
      protected var _savedTextLinesHeight:Number = NaN;
      
      protected var _snapshotWidth:int = 0;
      
      protected var _snapshotHeight:int = 0;
      
      protected var _snapshotVisibleWidth:int = 0;
      
      protected var _snapshotVisibleHeight:int = 0;
      
      protected var _needsNewTexture:Boolean = false;
      
      protected var _needsTextureUpdate:Boolean = false;
      
      protected var _truncationOffset:int = 0;
      
      protected var _textElement:TextElement;
      
      protected var _content:ContentElement;
      
      protected var _fontStylesElementFormat:ElementFormat;
      
      protected var _currentVerticalAlign:String;
      
      protected var _currentHorizontalAlign:String;
      
      protected var _verticalAlignOffsetY:Number = 0;
      
      protected var _elementFormatForState:Object;
      
      protected var _elementFormat:ElementFormat;
      
      protected var _disabledElementFormat:ElementFormat;
      
      protected var _selectedElementFormat:ElementFormat;
      
      protected var _currentLeading:Number = 0;
      
      protected var _leading:Number = NaN;
      
      protected var _textAlign:String = null;
      
      protected var _applyNonLinearFontScaling:Boolean = true;
      
      protected var _baselineFontDescription:FontDescription;
      
      protected var _baselineFontSize:Number = 12;
      
      protected var _baselineZero:String = "roman";
      
      protected var _bidiLevel:int = 0;
      
      protected var _lineRotation:String = "rotate0";
      
      protected var _tabStops:Vector.<TabStop>;
      
      protected var _textJustifier:TextJustifier = new SpaceJustifier();
      
      protected var _userData:*;
      
      protected var _pixelSnapping:Boolean = true;
      
      protected var _maxTextureDimensions:int = 2048;
      
      protected var _nativeFilters:Array;
      
      protected var _truncationText:String = "...";
      
      protected var _truncateToFit:Boolean = true;
      
      protected var _updateSnapshotOnScaleChange:Boolean = false;
      
      protected var _lastMeasurementWidth:Number = 0;
      
      protected var _lastMeasurementHeight:Number = 0;
      
      protected var _lastMeasurementWasTruncated:Boolean = false;
      
      protected var _textBlockChanged:Boolean = true;
      
      public function TextBlockTextRenderer()
      {
         super();
         this.isQuickHitAreaEnabled = true;
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return TextBlockTextRenderer.globalStyleProvider;
      }
      
      override public function set maxWidth(param1:Number) : void
      {
         var _loc2_:Boolean = param1 > this._explicitMaxWidth && this._lastMeasurementWasTruncated;
         super.maxWidth = param1;
         if(_loc2_)
         {
            this.invalidate(INVALIDATION_FLAG_SIZE);
         }
      }
      
      public function get numLines() : int
      {
         return this._textLines.length;
      }
      
      override public function set text(param1:String) : void
      {
         if(this._text == param1)
         {
            return;
         }
         if(this._textElement === null)
         {
            this._textElement = new TextElement(param1);
         }
         this.content = this._textElement;
         super.text = param1;
      }
      
      public function get content() : ContentElement
      {
         return this._content;
      }
      
      public function set content(param1:ContentElement) : void
      {
         if(this._content === param1)
         {
            return;
         }
         if(param1 is TextElement)
         {
            this._textElement = TextElement(param1);
         }
         else
         {
            this._textElement = null;
         }
         this._content = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get currentElementFormat() : ElementFormat
      {
         if(this._textElement === null)
         {
            return null;
         }
         return this._textElement.elementFormat;
      }
      
      public function get elementFormat() : ElementFormat
      {
         return this._elementFormat;
      }
      
      public function set elementFormat(param1:ElementFormat) : void
      {
         if(this._elementFormat == param1)
         {
            return;
         }
         this._elementFormat = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get disabledElementFormat() : ElementFormat
      {
         return this._disabledElementFormat;
      }
      
      public function set disabledElementFormat(param1:ElementFormat) : void
      {
         if(this._disabledElementFormat == param1)
         {
            return;
         }
         this._disabledElementFormat = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get selectedElementFormat() : ElementFormat
      {
         return this._selectedElementFormat;
      }
      
      public function set selectedElementFormat(param1:ElementFormat) : void
      {
         if(this._selectedElementFormat == param1)
         {
            return;
         }
         this._selectedElementFormat = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get leading() : Number
      {
         return this._leading;
      }
      
      public function set leading(param1:Number) : void
      {
         if(this._leading == param1)
         {
            return;
         }
         this._leading = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get textAlign() : String
      {
         return this._textAlign;
      }
      
      public function set textAlign(param1:String) : void
      {
         if(this._textAlign == param1)
         {
            return;
         }
         this._textAlign = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get baseline() : Number
      {
         if(this._textLines.length == 0)
         {
            return 0;
         }
         return this.calculateLineAscent(this._textLines[0]);
      }
      
      public function get applyNonLinearFontScaling() : Boolean
      {
         return this._applyNonLinearFontScaling;
      }
      
      public function set applyNonLinearFontScaling(param1:Boolean) : void
      {
         if(this._applyNonLinearFontScaling == param1)
         {
            return;
         }
         this._applyNonLinearFontScaling = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get baselineFontDescription() : FontDescription
      {
         return this._baselineFontDescription;
      }
      
      public function set baselineFontDescription(param1:FontDescription) : void
      {
         if(this._baselineFontDescription == param1)
         {
            return;
         }
         this._baselineFontDescription = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get baselineFontSize() : Number
      {
         return this._baselineFontSize;
      }
      
      public function set baselineFontSize(param1:Number) : void
      {
         if(this._baselineFontSize == param1)
         {
            return;
         }
         this._baselineFontSize = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get baselineZero() : String
      {
         return this._baselineZero;
      }
      
      public function set baselineZero(param1:String) : void
      {
         if(this._baselineZero == param1)
         {
            return;
         }
         this._baselineZero = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get bidiLevel() : int
      {
         return this._bidiLevel;
      }
      
      public function set bidiLevel(param1:int) : void
      {
         if(this._bidiLevel == param1)
         {
            return;
         }
         this._bidiLevel = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get lineRotation() : String
      {
         return this._lineRotation;
      }
      
      public function set lineRotation(param1:String) : void
      {
         if(this._lineRotation == param1)
         {
            return;
         }
         this._lineRotation = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get tabStops() : Vector.<TabStop>
      {
         return this._tabStops;
      }
      
      public function set tabStops(param1:Vector.<TabStop>) : void
      {
         if(this._tabStops == param1)
         {
            return;
         }
         this._tabStops = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get textJustifier() : TextJustifier
      {
         return this._textJustifier;
      }
      
      public function set textJustifier(param1:TextJustifier) : void
      {
         if(this._textJustifier == param1)
         {
            return;
         }
         this._textJustifier = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get userData() : *
      {
         return this._userData;
      }
      
      public function set userData(param1:*) : void
      {
         if(this._userData === param1)
         {
            return;
         }
         this._userData = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
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
      
      public function get truncationText() : String
      {
         return this._truncationText;
      }
      
      public function set truncationText(param1:String) : void
      {
         if(this._truncationText == param1)
         {
            return;
         }
         this._truncationText = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get truncateToFit() : Boolean
      {
         return this._truncateToFit;
      }
      
      public function set truncateToFit(param1:Boolean) : void
      {
         if(this._truncateToFit == param1)
         {
            return;
         }
         this._truncateToFit = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
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
         this.textBlock = null;
         this._textLineContainer = null;
         this._textLines = null;
         this._measurementTextLineContainer = null;
         this._measurementTextLines = null;
         this._textElement = null;
         this._content = null;
         this._previousLayoutActualWidth = NaN;
         this._previousLayoutActualHeight = NaN;
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
            if(_loc3_ != this._lastGlobalScaleX || _loc4_ != this._lastGlobalScaleY || _loc2_.contentScaleFactor != this._lastGlobalContentScaleFactor)
            {
               this.invalidate(INVALIDATION_FLAG_SIZE);
               this.validate();
            }
         }
         if(this._needsTextureUpdate)
         {
            this._needsTextureUpdate = false;
            if(this._content !== null)
            {
               this.refreshSnapshot();
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
                     _loc15_.visible = this._snapshotWidth > 0 && this._snapshotHeight > 0 && this._content !== null;
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
      
      public function getElementFormatForState(param1:String) : ElementFormat
      {
         if(this._elementFormatForState === null)
         {
            return null;
         }
         return ElementFormat(this._elementFormatForState[param1]);
      }
      
      public function setElementFormatForState(param1:String, param2:ElementFormat) : void
      {
         if(param2)
         {
            if(!this._elementFormatForState)
            {
               this._elementFormatForState = {};
            }
            this._elementFormatForState[param1] = param2;
         }
         else
         {
            delete this._elementFormatForState[param1];
         }
         if(Boolean(this._stateContext) && this._stateContext.currentState === param1)
         {
            this.invalidate(INVALIDATION_FLAG_STATE);
         }
      }
      
      override protected function initialize() : void
      {
         if(!this.textBlock)
         {
            this.textBlock = new TextBlock();
         }
         if(!this._textLineContainer)
         {
            this._textLineContainer = new Sprite();
         }
         if(!this._measurementTextLineContainer)
         {
            this._measurementTextLineContainer = new Sprite();
         }
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
         this.commit();
         _loc1_ = this.autoSizeIfNeeded() || _loc1_;
         this.layout(_loc1_);
      }
      
      protected function commit() : void
      {
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         if(_loc2_ || _loc1_ || _loc3_)
         {
            this.refreshElementFormat();
         }
         if(_loc1_)
         {
            this._textBlockChanged = true;
            this.textBlock.applyNonLinearFontScaling = this._applyNonLinearFontScaling;
            this.textBlock.baselineFontDescription = this._baselineFontDescription;
            this.textBlock.baselineFontSize = this._baselineFontSize;
            this.textBlock.baselineZero = this._baselineZero;
            this.textBlock.bidiLevel = this._bidiLevel;
            this.textBlock.lineRotation = this._lineRotation;
            this.textBlock.tabStops = this._tabStops;
            this.textBlock.textJustifier = this._textJustifier;
            this.textBlock.userData = this._userData;
            this._textLineContainer.filters = this._nativeFilters;
         }
         if(_loc2_)
         {
            this._textBlockChanged = true;
            this.textBlock.content = this._content;
         }
      }
      
      protected function measure(param1:Point = null) : Point
      {
         var _loc6_:Boolean = false;
         if(!param1)
         {
            param1 = new Point();
         }
         var _loc2_:Boolean = this._explicitWidth !== this._explicitWidth;
         var _loc3_:Boolean = this._explicitHeight !== this._explicitHeight;
         var _loc4_:Number = this._explicitWidth;
         var _loc5_:Number = this._explicitHeight;
         if(_loc2_)
         {
            _loc4_ = this._explicitMaxWidth;
         }
         if(_loc3_)
         {
            _loc5_ = this._explicitMaxHeight;
         }
         if(this._wordWrap)
         {
            _loc6_ = _loc4_ != this._lastMeasurementWidth;
         }
         else
         {
            _loc6_ = _loc4_ < this._lastMeasurementWidth;
            _loc6_ = (_loc6_) || this._lastMeasurementWasTruncated && _loc4_ != this._lastMeasurementWidth;
         }
         if(this._textBlockChanged || _loc6_)
         {
            this.refreshTextLines(this._measurementTextLines,this._measurementTextLineContainer,_loc4_,_loc5_,HELPER_RESULT);
            this._lastMeasurementWidth = HELPER_RESULT.width;
            this._lastMeasurementHeight = HELPER_RESULT.height;
            this._lastMeasurementWasTruncated = HELPER_RESULT.isTruncated;
            this._textBlockChanged = false;
         }
         if(_loc2_)
         {
            _loc4_ = Math.ceil(this._measurementTextLineContainer.width);
            if(_loc4_ > this._explicitMaxWidth)
            {
               _loc4_ = this._explicitMaxWidth;
            }
         }
         if(_loc3_)
         {
            _loc5_ = Math.ceil(this._lastMeasurementHeight);
            if(_loc5_ <= 0 && this._textElement !== null)
            {
               _loc5_ = this._textElement.elementFormat.fontSize;
            }
         }
         param1.x = _loc4_;
         param1.y = _loc5_;
         return param1;
      }
      
      protected function layout(param1:Boolean) : void
      {
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         var _loc4_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         var _loc5_:Boolean = _loc2_ || _loc3_ || _loc4_ || this.actualWidth != this._previousLayoutActualWidth || this.actualHeight != this._previousLayoutActualHeight;
         if(_loc5_)
         {
            this._previousLayoutActualWidth = this.actualWidth;
            this._previousLayoutActualHeight = this.actualHeight;
            if(this._content !== null)
            {
               this.refreshTextLines(this._textLines,this._textLineContainer,this.actualWidth,this.actualHeight,HELPER_RESULT);
               this._savedTextLinesWidth = HELPER_RESULT.width;
               this._savedTextLinesHeight = HELPER_RESULT.height;
               this._verticalAlignOffsetY = this.getVerticalAlignOffsetY();
            }
         }
         if(_loc5_ || param1)
         {
            this.calculateSnapshotDimensions();
         }
         if(_loc5_ || this._needsNewTexture)
         {
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
         if(_loc1_ || _loc2_)
         {
            this.measure(HELPER_POINT);
         }
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
         var _loc11_:BitmapFilter = null;
         var _loc12_:flash.geom.Rectangle = null;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         if(!param2)
         {
            param2 = new flash.geom.Rectangle();
         }
         var _loc3_:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         var _loc4_:Number = _loc3_.contentScaleFactor;
         var _loc5_:Number = 0;
         var _loc6_:Number = 0;
         var _loc7_:Number = 0;
         var _loc8_:Number = 0;
         var _loc9_:int = int(this._nativeFilters.length);
         var _loc10_:int = 0;
         while(_loc10_ < _loc9_)
         {
            _loc11_ = this._nativeFilters[_loc10_];
            _loc12_ = param1.generateFilterRect(param1.rect,_loc11_);
            _loc13_ = _loc12_.x;
            _loc14_ = _loc12_.y;
            _loc15_ = _loc12_.width * _loc4_;
            _loc16_ = _loc12_.height * _loc4_;
            if(_loc5_ > _loc13_)
            {
               _loc5_ = _loc13_;
            }
            if(_loc6_ > _loc14_)
            {
               _loc6_ = _loc14_;
            }
            if(_loc7_ < _loc15_)
            {
               _loc7_ = _loc15_;
            }
            if(_loc8_ < _loc16_)
            {
               _loc8_ = _loc16_;
            }
            _loc10_++;
         }
         param2.setTo(_loc5_,_loc6_,_loc7_,_loc8_);
         return param2;
      }
      
      protected function refreshElementFormat() : void
      {
         var _loc1_:ElementFormat = null;
         var _loc2_:String = null;
         if(this._stateContext !== null)
         {
            if(this._elementFormatForState !== null)
            {
               _loc2_ = this._stateContext.currentState;
               if(_loc2_ in this._elementFormatForState)
               {
                  _loc1_ = ElementFormat(this._elementFormatForState[_loc2_]);
               }
            }
            if(_loc1_ === null && this._disabledElementFormat !== null && this._stateContext is IFeathersControl && !IFeathersControl(this._stateContext).isEnabled)
            {
               _loc1_ = this._disabledElementFormat;
            }
            if(_loc1_ === null && this._selectedElementFormat !== null && this._stateContext is IToggle && IToggle(this._stateContext).isSelected)
            {
               _loc1_ = this._selectedElementFormat;
            }
         }
         else if(!this._isEnabled && this._disabledElementFormat !== null)
         {
            _loc1_ = this._disabledElementFormat;
         }
         switch(_loc1_)
         {
            case null:
               _loc1_ = this._elementFormat;
               if(_loc1_ === null)
               {
               }
            case null:
               _loc1_ = this.getElementFormatFromFontStyles();
               break;
            default:
               this._currentVerticalAlign = Align.TOP;
               this._currentHorizontalAlign = Align.CENTER;
               this._currentLeading = 0;
         }
         if(this._textAlign !== null)
         {
            this._currentHorizontalAlign = this._textAlign;
         }
         if(this._leading === this._leading)
         {
            this._currentLeading = this._leading;
         }
         if(this._textElement === null)
         {
            return;
         }
         if(this._textElement.elementFormat !== _loc1_)
         {
            this._textBlockChanged = true;
            this._textElement.elementFormat = _loc1_;
         }
      }
      
      protected function getElementFormatFromFontStyles() : ElementFormat
      {
         var _loc1_:TextFormat = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:FontDescription = null;
         var _loc6_:Number = NaN;
         if(this.isInvalid(INVALIDATION_FLAG_STYLES) || this.isInvalid(INVALIDATION_FLAG_STATE))
         {
            if(this._fontStyles !== null)
            {
               _loc1_ = this._fontStyles.getTextFormatForTarget(this);
            }
            if(_loc1_ !== null)
            {
               _loc2_ = FontWeight.NORMAL;
               if(_loc1_.bold)
               {
                  _loc2_ = FontWeight.BOLD;
               }
               _loc3_ = FontPosture.NORMAL;
               if(_loc1_.italic)
               {
                  _loc3_ = FontPosture.ITALIC;
               }
               _loc4_ = FontLookup.DEVICE;
               if(SystemUtil.isEmbeddedFont(_loc1_.font,_loc1_.bold,_loc1_.italic,FontType.EMBEDDED_CFF))
               {
                  _loc4_ = FontLookup.EMBEDDED_CFF;
               }
               _loc5_ = new FontDescription(_loc1_.font,_loc2_,_loc3_,_loc4_);
               this._fontStylesElementFormat = new ElementFormat(_loc5_,_loc1_.size,_loc1_.color);
               if(_loc1_.kerning)
               {
                  this._fontStylesElementFormat.kerning = Kerning.ON;
               }
               else
               {
                  this._fontStylesElementFormat.kerning = Kerning.OFF;
               }
               _loc6_ = _loc1_.letterSpacing / 2;
               this._fontStylesElementFormat.trackingRight = _loc6_;
               this._fontStylesElementFormat.trackingLeft = _loc6_;
               this._currentLeading = _loc1_.leading;
               this._currentVerticalAlign = _loc1_.verticalAlign;
               this._currentHorizontalAlign = _loc1_.horizontalAlign;
            }
            else if(this._fontStylesElementFormat === null)
            {
               this._fontStylesElementFormat = new ElementFormat();
               this._currentLeading = 0;
               this._currentVerticalAlign = Align.TOP;
               this._currentHorizontalAlign = Align.LEFT;
            }
         }
         return this._fontStylesElementFormat;
      }
      
      protected function createTextureOnRestoreCallback(param1:Image) : void
      {
         var self:TextBlockTextRenderer = null;
         var texture:Texture = null;
         var snapshot:Image = param1;
         self = this;
         texture = snapshot.texture;
         texture.root.onRestore = function():void
         {
            var _loc3_:Number = NaN;
            var _loc4_:BitmapData = null;
            var _loc1_:Starling = self.stage !== null ? self.stage.starling : Starling.current;
            var _loc2_:Number = _loc1_.contentScaleFactor;
            if(texture.scale != _loc2_)
            {
               invalidate(INVALIDATION_FLAG_SIZE);
            }
            else
            {
               HELPER_MATRIX.identity();
               HELPER_MATRIX.scale(_loc2_,_loc2_);
               _loc3_ = self.getVerticalAlignOffsetY();
               _loc4_ = self.drawTextLinesRegionToBitmapData(snapshot.x,snapshot.y - _loc3_,texture.nativeWidth,texture.nativeHeight);
               texture.root.uploadBitmapData(_loc4_);
               _loc4_.dispose();
            }
         };
      }
      
      protected function drawTextLinesRegionToBitmapData(param1:Number, param2:Number, param3:Number, param4:Number, param5:BitmapData = null) : BitmapData
      {
         var _loc6_:Number = this._snapshotVisibleWidth - param1;
         var _loc7_:Number = this._snapshotVisibleHeight - param2;
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
         var _loc8_:Number = 1;
         var _loc9_:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         if((Boolean(_loc9_)) && _loc9_.supportHighResolutions)
         {
            _loc8_ = _loc9_.nativeStage.contentsScaleFactor;
         }
         HELPER_MATRIX.tx = -param1 - this._textSnapshotScrollX * _loc8_ - this._textSnapshotOffsetX;
         HELPER_MATRIX.ty = -param2 - this._textSnapshotScrollY * _loc8_ - this._textSnapshotOffsetY;
         var _loc10_:flash.geom.Rectangle = Pool.getRectangle(0,0,_loc6_,_loc7_);
         param5.draw(this._textLineContainer,HELPER_MATRIX,null,null,_loc10_);
         Pool.putRectangle(_loc10_);
         return param5;
      }
      
      protected function calculateSnapshotDimensions() : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc1_:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         var _loc2_:Number = _loc1_.contentScaleFactor;
         this._lastGlobalContentScaleFactor = _loc2_;
         if(this._savedTextLinesWidth < this.actualWidth)
         {
            _loc5_ = Math.ceil(this._savedTextLinesWidth * _loc2_);
         }
         else
         {
            _loc5_ = Math.ceil(this.actualWidth * _loc2_);
         }
         if(this._savedTextLinesHeight < this.actualHeight)
         {
            _loc6_ = Math.ceil(this._savedTextLinesHeight * _loc2_);
         }
         else
         {
            _loc6_ = Math.ceil(this.actualHeight * _loc2_);
         }
         if(this._updateSnapshotOnScaleChange)
         {
            this.getTransformationMatrix(this.stage,HELPER_MATRIX);
            this._lastGlobalScaleX = matrixToScaleX(HELPER_MATRIX);
            this._lastGlobalScaleY = matrixToScaleY(HELPER_MATRIX);
            _loc5_ *= this._lastGlobalScaleX;
            _loc6_ *= this._lastGlobalScaleY;
         }
         if(_loc5_ >= 1 && _loc6_ >= 1 && this._nativeFilters !== null && this._nativeFilters.length > 0)
         {
            _loc5_ = this._textSnapshotNativeFiltersWidth;
            _loc6_ = this._textSnapshotNativeFiltersHeight;
         }
         var _loc3_:Point = Pool.getPoint();
         calculateSnapshotTextureDimensions(_loc5_,_loc6_,this._maxTextureDimensions,_loc1_.profile !== Context3DProfile.BASELINE_CONSTRAINED,_loc3_);
         this._snapshotWidth = _loc3_.x;
         this._snapshotHeight = _loc3_.y;
         this._snapshotVisibleWidth = _loc5_;
         this._snapshotVisibleHeight = _loc6_;
         Pool.putPoint(_loc3_);
         var _loc4_:ConcreteTexture = this.textSnapshot ? this.textSnapshot.texture.root : null;
         this._needsNewTexture = this._needsNewTexture || this.textSnapshot === null || _loc4_ !== null && (_loc4_.scale != _loc2_ || this._snapshotWidth != _loc4_.nativeWidth || this._snapshotHeight != _loc4_.nativeHeight);
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
               _loc7_ = this.drawTextLinesRegionToBitmapData(_loc5_,_loc6_,_loc11_,_loc12_,_loc7_);
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
            this._lastGlobalContentScaleFactor = _loc2_;
         }
         this._needsNewTexture = false;
      }
      
      protected function calculateLineAscent(param1:TextLine) : Number
      {
         var _loc2_:Number = param1.ascent + param1.descent;
         if(param1.totalAscent > _loc2_)
         {
            _loc2_ = param1.totalAscent;
         }
         return _loc2_;
      }
      
      protected function refreshTextElementText() : void
      {
         if(this._textElement === null)
         {
            return;
         }
         var _loc1_:String = this._text;
         if(_loc1_ !== null && _loc1_.length > 0)
         {
            if(_loc1_.charAt(_loc1_.length - 1) === " ")
            {
               _loc1_ += String.fromCharCode(3);
            }
         }
         else
         {
            _loc1_ = String.fromCharCode(3);
         }
         this._textElement.text = _loc1_;
      }
      
      protected function refreshTextLines(param1:Vector.<TextLine>, param2:DisplayObjectContainer, param3:Number, param4:Number, param5:MeasureTextResult = null) : MeasureTextResult
      {
         var _loc11_:TextLine = null;
         var _loc12_:int = 0;
         var _loc13_:Boolean = false;
         var _loc14_:int = 0;
         var _loc15_:* = 0;
         var _loc16_:TextLine = null;
         var _loc17_:Number = NaN;
         var _loc18_:int = 0;
         var _loc19_:Boolean = false;
         var _loc20_:Number = NaN;
         var _loc21_:TextLine = null;
         var _loc22_:int = 0;
         var _loc23_:String = null;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:Starling = null;
         var _loc27_:Number = NaN;
         var _loc28_:BitmapData = null;
         var _loc29_:flash.geom.Rectangle = null;
         if(param3 < 0)
         {
            param3 = 0;
         }
         else if(param3 > MAX_TEXT_LINE_WIDTH)
         {
            param3 = MAX_TEXT_LINE_WIDTH;
         }
         if(param4 < 0)
         {
            param4 = 0;
         }
         var _loc6_:int = int(param1.length);
         HELPER_TEXT_LINES.length = 0;
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            HELPER_TEXT_LINES[_loc7_] = param1[_loc7_];
            _loc7_++;
         }
         param1.length = 0;
         this.refreshTextElementText();
         var _loc8_:Boolean = false;
         var _loc9_:Number = 0;
         var _loc10_:Number = 0;
         if(param3 >= 0)
         {
            _loc11_ = null;
            _loc12_ = 0;
            _loc13_ = this._truncateToFit && Boolean(this._textElement) && !this._wordWrap;
            _loc14_ = int(param1.length);
            _loc15_ = int(HELPER_TEXT_LINES.length);
            while(true)
            {
               this._truncationOffset = 0;
               _loc16_ = _loc11_;
               _loc17_ = param3;
               if(!this._wordWrap)
               {
                  _loc17_ = MAX_TEXT_LINE_WIDTH;
               }
               if(_loc15_ > 0)
               {
                  _loc21_ = HELPER_TEXT_LINES[0];
                  _loc11_ = this.textBlock.recreateTextLine(_loc21_,_loc16_,_loc17_,0,true);
                  if(_loc11_)
                  {
                     HELPER_TEXT_LINES.shift();
                     _loc15_--;
                  }
               }
               else
               {
                  _loc11_ = this.textBlock.createTextLine(_loc16_,_loc17_,0,true);
                  if(_loc11_)
                  {
                     param2.addChild(_loc11_);
                  }
               }
               if(!_loc11_)
               {
                  break;
               }
               _loc18_ = _loc11_.rawTextLength;
               _loc19_ = false;
               _loc20_ = 0;
               while(true)
               {
                  _loc20_ = _loc11_.width - param3;
                  if(!(_loc13_ && _loc20_ > FUZZY_TRUNCATION_DIFFERENCE))
                  {
                     break;
                  }
                  _loc19_ = true;
                  if(this._truncationOffset == 0)
                  {
                     _loc25_ = _loc11_.getAtomIndexAtPoint(param3,0);
                     if(_loc25_ >= 0)
                     {
                        this._truncationOffset = _loc11_.rawTextLength - _loc25_;
                     }
                  }
                  ++this._truncationOffset;
                  _loc22_ = _loc18_ - this._truncationOffset;
                  _loc23_ = this._text.substr(_loc12_,_loc22_) + this._truncationText;
                  _loc24_ = this._text.indexOf(LINE_FEED,_loc12_);
                  if(_loc24_ < 0)
                  {
                     _loc24_ = this._text.indexOf(CARRIAGE_RETURN,_loc12_);
                  }
                  if(_loc24_ >= 0)
                  {
                     _loc23_ += this._text.substr(_loc24_);
                  }
                  this._textElement.text = _loc23_;
                  _loc11_ = this.textBlock.recreateTextLine(_loc11_,null,_loc17_,0,true);
                  if(_loc22_ <= 0)
                  {
                     break;
                  }
               }
               if(_loc14_ > 0)
               {
                  _loc10_ += this._currentLeading;
               }
               if(_loc11_.width > _loc9_)
               {
                  _loc9_ = _loc11_.width;
               }
               _loc10_ += this.calculateLineAscent(_loc11_);
               _loc11_.y = _loc10_;
               _loc10_ += _loc11_.totalDescent;
               param1[_loc14_] = _loc11_;
               _loc14_++;
               _loc12_ += _loc18_;
               _loc8_ ||= _loc19_;
            }
         }
         if(param1 !== this._measurementTextLines)
         {
            this.alignTextLines(param1,param3,this._currentHorizontalAlign);
         }
         if(this._currentHorizontalAlign === Align.RIGHT)
         {
            _loc9_ = param3;
         }
         else if(this._currentHorizontalAlign === Align.CENTER)
         {
            _loc9_ = (param3 + _loc9_) / 2;
         }
         _loc15_ = int(HELPER_TEXT_LINES.length);
         _loc7_ = 0;
         while(_loc7_ < _loc15_)
         {
            _loc11_ = HELPER_TEXT_LINES[_loc7_];
            param2.removeChild(_loc11_);
            _loc7_++;
         }
         HELPER_TEXT_LINES.length = 0;
         if(param5 === null)
         {
            param5 = new MeasureTextResult(_loc9_,_loc10_,_loc8_);
         }
         else
         {
            param5.width = _loc9_;
            param5.height = _loc10_;
            param5.isTruncated = _loc8_;
         }
         if(param1 !== this._measurementTextLines)
         {
            if(param5.width >= 1 && param5.height >= 1 && this._nativeFilters !== null && this._nativeFilters.length > 0)
            {
               _loc26_ = this.stage !== null ? this.stage.starling : Starling.current;
               _loc27_ = _loc26_.contentScaleFactor;
               HELPER_MATRIX.identity();
               HELPER_MATRIX.scale(_loc27_,_loc27_);
               _loc28_ = new BitmapData(param5.width,param5.height,true,16711935);
               _loc29_ = Pool.getRectangle();
               _loc28_.draw(this._textLineContainer,HELPER_MATRIX,null,null,_loc29_);
               this.measureNativeFilters(_loc28_,_loc29_);
               _loc28_.dispose();
               _loc28_ = null;
               this._textSnapshotOffsetX = _loc29_.x;
               this._textSnapshotOffsetY = _loc29_.y;
               this._textSnapshotNativeFiltersWidth = _loc29_.width;
               this._textSnapshotNativeFiltersHeight = _loc29_.height;
               Pool.putRectangle(_loc29_);
            }
            else
            {
               this._textSnapshotOffsetX = 0;
               this._textSnapshotOffsetY = 0;
               this._textSnapshotNativeFiltersWidth = 0;
               this._textSnapshotNativeFiltersHeight = 0;
            }
         }
         return param5;
      }
      
      protected function getVerticalAlignOffsetY() : Number
      {
         if(this._savedTextLinesHeight > this.actualHeight)
         {
            return 0;
         }
         if(this._currentVerticalAlign === Align.BOTTOM)
         {
            return this.actualHeight - this._savedTextLinesHeight;
         }
         if(this._currentVerticalAlign === Align.CENTER)
         {
            return (this.actualHeight - this._savedTextLinesHeight) / 2;
         }
         return 0;
      }
      
      protected function alignTextLines(param1:Vector.<TextLine>, param2:Number, param3:String) : void
      {
         var _loc6_:TextLine = null;
         var _loc4_:int = int(param1.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = param1[_loc5_];
            if(param3 == HorizontalAlign.CENTER)
            {
               _loc6_.x = (param2 - _loc6_.width) / 2;
            }
            else if(param3 == HorizontalAlign.RIGHT)
            {
               _loc6_.x = param2 - _loc6_.width;
            }
            else
            {
               _loc6_.x = 0;
            }
            _loc5_++;
         }
      }
   }
}

