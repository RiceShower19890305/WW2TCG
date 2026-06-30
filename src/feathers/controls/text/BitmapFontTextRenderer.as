package feathers.controls.text
{
   import feathers.core.IFeathersControl;
   import feathers.core.ITextRenderer;
   import feathers.core.IToggle;
   import feathers.skins.IStyleProvider;
   import feathers.text.BitmapFontTextFormat;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextFormatAlign;
   import starling.display.Image;
   import starling.display.MeshBatch;
   import starling.rendering.Painter;
   import starling.styles.MeshStyle;
   import starling.text.BitmapChar;
   import starling.text.BitmapFont;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import starling.textures.Texture;
   import starling.utils.Align;
   import starling.utils.MathUtil;
   import starling.utils.Pool;
   
   public class BitmapFontTextRenderer extends BaseTextRenderer implements ITextRenderer
   {
      
      private static var CHARACTER_BUFFER:Vector.<CharLocation>;
      
      private static var CHAR_LOCATION_POOL:Vector.<CharLocation>;
      
      public static var globalStyleProvider:IStyleProvider;
      
      private static const HELPER_RESULT:MeasureTextResult = new MeasureTextResult();
      
      private static const CHARACTER_ID_SPACE:int = 32;
      
      private static const CHARACTER_ID_TAB:int = 9;
      
      private static const CHARACTER_ID_LINE_FEED:int = 10;
      
      private static const CHARACTER_ID_CARRIAGE_RETURN:int = 13;
      
      private static const FUZZY_MAX_WIDTH_PADDING:Number = 0.000001;
      
      protected var _characterBatch:MeshBatch = null;
      
      protected var _batchX:Number = 0;
      
      protected var _textFormatChanged:Boolean = true;
      
      protected var _currentFontStyles:TextFormat = null;
      
      protected var _fontStylesTextFormat:BitmapFontTextFormat;
      
      protected var _currentVerticalAlign:String;
      
      protected var _verticalAlignOffsetY:Number = 0;
      
      protected var _currentTextFormat:BitmapFontTextFormat;
      
      protected var _numLines:int = 0;
      
      protected var _textFormatForState:Object;
      
      protected var _textFormat:BitmapFontTextFormat;
      
      protected var _disabledTextFormat:BitmapFontTextFormat;
      
      protected var _selectedTextFormat:BitmapFontTextFormat;
      
      protected var _textureSmoothing:String = null;
      
      protected var _pixelSnapping:Boolean = true;
      
      protected var _breakLongWords:Boolean = false;
      
      protected var _truncateToFit:Boolean = true;
      
      protected var _truncationText:String = "...";
      
      protected var _useSeparateBatch:Boolean = true;
      
      protected var _defaultStyle:MeshStyle = null;
      
      protected var _style:MeshStyle = null;
      
      protected var _image:Image = null;
      
      private var _compilerWorkaround:Object;
      
      protected var _lastLayoutWidth:Number = 0;
      
      protected var _lastLayoutHeight:Number = 0;
      
      protected var _lastLayoutIsTruncated:Boolean = false;
      
      public function BitmapFontTextRenderer()
      {
         super();
         if(!CHAR_LOCATION_POOL)
         {
            CHAR_LOCATION_POOL = new Vector.<CharLocation>(0);
         }
         if(!CHARACTER_BUFFER)
         {
            CHARACTER_BUFFER = new Vector.<CharLocation>(0);
         }
         this.isQuickHitAreaEnabled = true;
      }
      
      public function get currentTextFormat() : BitmapFontTextFormat
      {
         return this._currentTextFormat;
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return BitmapFontTextRenderer.globalStyleProvider;
      }
      
      override public function set maxWidth(param1:Number) : void
      {
         var _loc2_:Boolean = param1 > this._explicitMaxWidth && this._lastLayoutIsTruncated;
         super.maxWidth = param1;
         if(_loc2_)
         {
            this.invalidate(INVALIDATION_FLAG_SIZE);
         }
      }
      
      public function get numLines() : int
      {
         return this._numLines;
      }
      
      public function get textFormat() : BitmapFontTextFormat
      {
         return this._textFormat;
      }
      
      public function set textFormat(param1:BitmapFontTextFormat) : void
      {
         if(this._textFormat == param1)
         {
            return;
         }
         this._textFormat = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get disabledTextFormat() : BitmapFontTextFormat
      {
         return this._disabledTextFormat;
      }
      
      public function set disabledTextFormat(param1:BitmapFontTextFormat) : void
      {
         if(this._disabledTextFormat == param1)
         {
            return;
         }
         this._disabledTextFormat = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get selectedTextFormat() : BitmapFontTextFormat
      {
         return this._selectedTextFormat;
      }
      
      public function set selectedTextFormat(param1:BitmapFontTextFormat) : void
      {
         if(this._selectedTextFormat == param1)
         {
            return;
         }
         this._selectedTextFormat = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get textureSmoothing() : String
      {
         return this._textureSmoothing;
      }
      
      public function set textureSmoothing(param1:String) : void
      {
         if(this._textureSmoothing == param1)
         {
            return;
         }
         this._textureSmoothing = param1;
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
      
      public function get breakLongWords() : Boolean
      {
         return this._breakLongWords;
      }
      
      public function set breakLongWords(param1:Boolean) : void
      {
         if(this._breakLongWords === param1)
         {
            return;
         }
         this._breakLongWords = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
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
      
      public function get useSeparateBatch() : Boolean
      {
         return this._useSeparateBatch;
      }
      
      public function set useSeparateBatch(param1:Boolean) : void
      {
         if(this._useSeparateBatch == param1)
         {
            return;
         }
         this._useSeparateBatch = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get style() : MeshStyle
      {
         return this._style;
      }
      
      public function set style(param1:MeshStyle) : void
      {
         if(this._style == param1)
         {
            return;
         }
         this._style = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get baseline() : Number
      {
         if(this._currentTextFormat === null)
         {
            return 0;
         }
         var _loc1_:BitmapFont = this._currentTextFormat.font;
         var _loc2_:Number = this._currentTextFormat.size;
         var _loc3_:Number = _loc2_ / _loc1_.size;
         if(_loc3_ !== _loc3_)
         {
            _loc3_ = 1;
         }
         var _loc4_:Number = _loc1_.baseline;
         this._compilerWorkaround = _loc4_;
         if(_loc4_ !== _loc4_)
         {
            return _loc1_.lineHeight * _loc3_;
         }
         return _loc4_ * _loc3_;
      }
      
      override public function render(param1:Painter) : void
      {
         this._characterBatch.x = this._batchX;
         this._characterBatch.y = this._verticalAlignOffsetY;
         super.render(param1);
      }
      
      public function measureText(param1:Point = null) : Point
      {
         return this.measureTextInternal(param1,true);
      }
      
      public function getTextFormatForState(param1:String) : BitmapFontTextFormat
      {
         if(this._textFormatForState === null)
         {
            return null;
         }
         return BitmapFontTextFormat(this._textFormatForState[param1]);
      }
      
      public function setTextFormatForState(param1:String, param2:BitmapFontTextFormat) : void
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
         if(this._characterBatch === null)
         {
            this._characterBatch = new MeshBatch();
            this._characterBatch.touchable = false;
            this.addChild(this._characterBatch);
         }
      }
      
      override protected function draw() : void
      {
         var _loc5_:Boolean = false;
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         if(_loc2_ || _loc3_)
         {
            this.refreshTextFormat();
         }
         if(_loc2_)
         {
            this._characterBatch.pixelSnapping = this._pixelSnapping;
            this._characterBatch.batchable = !this._useSeparateBatch;
         }
         var _loc4_:Number = this._explicitWidth;
         if(_loc4_ !== _loc4_)
         {
            _loc4_ = this._explicitMaxWidth;
         }
         if(this._wordWrap)
         {
            _loc5_ = _loc4_ != this._lastLayoutWidth;
         }
         else
         {
            _loc5_ = _loc4_ < this._lastLayoutWidth;
            _loc5_ = (_loc5_) || this._lastLayoutIsTruncated && _loc4_ != this._lastLayoutWidth;
            _loc5_ = (_loc5_) || this._currentTextFormat.align !== TextFormatAlign.LEFT;
         }
         if(_loc1_ || _loc5_ || _loc2_ || this._textFormatChanged)
         {
            this._textFormatChanged = false;
            this._characterBatch.clear();
            if(!this._currentTextFormat || this._text === null)
            {
               this.saveMeasurements(0,0,0,0);
               return;
            }
            this.layoutCharacters(HELPER_RESULT);
            if(this._style !== null)
            {
               this._characterBatch.style = this._style;
            }
            else
            {
               this._defaultStyle = this._currentTextFormat.font.getDefaultMeshStyle(this._defaultStyle,this._currentFontStyles,null);
               if(this._defaultStyle)
               {
                  this._characterBatch.style = this._defaultStyle;
               }
            }
            this._lastLayoutWidth = HELPER_RESULT.width;
            this._lastLayoutHeight = HELPER_RESULT.height;
            this._lastLayoutIsTruncated = HELPER_RESULT.isTruncated;
         }
         this.saveMeasurements(this._lastLayoutWidth,this._lastLayoutHeight,this._lastLayoutWidth,this._lastLayoutHeight);
         this._verticalAlignOffsetY = this.getVerticalAlignOffsetY();
      }
      
      protected function layoutCharacters(param1:MeasureTextResult = null) : MeasureTextResult
      {
         var _loc26_:Point = null;
         var _loc27_:String = null;
         var _loc28_:int = 0;
         var _loc29_:Number = NaN;
         var _loc30_:Boolean = false;
         var _loc31_:Boolean = false;
         var _loc32_:Number = NaN;
         var _loc33_:BitmapChar = null;
         var _loc34_:CharLocation = null;
         var _loc35_:String = null;
         if(!param1)
         {
            param1 = new MeasureTextResult();
         }
         this._numLines = 1;
         var _loc2_:BitmapFont = this._currentTextFormat.font;
         var _loc3_:Number = this._currentTextFormat.size;
         var _loc4_:Number = this._currentTextFormat.letterSpacing;
         var _loc5_:Boolean = this._currentTextFormat.isKerningEnabled;
         var _loc6_:Number = _loc3_ / _loc2_.size;
         if(_loc6_ !== _loc6_)
         {
            _loc6_ = 1;
         }
         var _loc7_:Number = _loc2_.lineHeight * _loc6_ + this._currentTextFormat.leading;
         var _loc8_:Number = _loc2_.offsetX * _loc6_;
         var _loc9_:Number = _loc2_.offsetY * _loc6_;
         var _loc10_:Boolean = this._explicitWidth === this._explicitWidth;
         var _loc11_:Boolean = this._currentTextFormat.align != TextFormatAlign.LEFT;
         var _loc12_:Number = _loc10_ ? this._explicitWidth : this._explicitMaxWidth;
         if(_loc11_ && _loc12_ == Number.POSITIVE_INFINITY)
         {
            _loc26_ = Pool.getPoint();
            this.measureText(_loc26_);
            _loc12_ = _loc26_.x;
            Pool.putPoint(_loc26_);
         }
         var _loc13_:String = this._text;
         if(this._truncateToFit)
         {
            _loc27_ = this.getTruncatedText(_loc12_);
            param1.isTruncated = _loc27_ !== _loc13_;
            _loc13_ = _loc27_;
         }
         else
         {
            param1.isTruncated = false;
         }
         CHARACTER_BUFFER.length = 0;
         var _loc14_:Number = 0;
         var _loc15_:Number = 0;
         var _loc16_:Number = 0;
         var _loc17_:Number = NaN;
         var _loc18_:Boolean = false;
         var _loc19_:Number = 0;
         var _loc20_:Number = 0;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         var _loc23_:BitmapChar = null;
         var _loc24_:int = _loc13_ ? _loc13_.length : 0;
         var _loc25_:int = 0;
         while(_loc25_ < _loc24_)
         {
            _loc18_ = false;
            _loc28_ = _loc13_.charCodeAt(_loc25_);
            if(_loc28_ == CHARACTER_ID_LINE_FEED || _loc28_ == CHARACTER_ID_CARRIAGE_RETURN)
            {
               _loc15_ -= _loc4_;
               if(_loc23_ !== null)
               {
                  _loc15_ -= (_loc23_.xAdvance - _loc23_.width) * _loc6_;
               }
               if(_loc15_ < 0)
               {
                  _loc15_ = 0;
               }
               if(this._wordWrap || _loc11_)
               {
                  this.alignBuffer(_loc12_,_loc15_,0);
                  this.addBufferToBatch(0);
               }
               if(_loc14_ < _loc15_)
               {
                  _loc14_ = _loc15_;
               }
               _loc17_ = NaN;
               _loc15_ = 0;
               _loc16_ += _loc7_;
               _loc19_ = 0;
               _loc20_ = 0;
               _loc21_ = 0;
               _loc22_ = 0;
               ++this._numLines;
            }
            else
            {
               _loc23_ = _loc2_.getChar(_loc28_);
               if(_loc23_ !== null)
               {
                  if(_loc5_ && _loc17_ === _loc17_)
                  {
                     _loc15_ += _loc23_.getKerning(_loc17_) * _loc6_;
                  }
                  _loc29_ = _loc23_.xAdvance * _loc6_;
                  if(this._wordWrap)
                  {
                     _loc30_ = _loc28_ == CHARACTER_ID_SPACE || _loc28_ == CHARACTER_ID_TAB;
                     _loc31_ = _loc17_ == CHARACTER_ID_SPACE || _loc17_ == CHARACTER_ID_TAB;
                     if(_loc30_)
                     {
                        if(!_loc31_)
                        {
                           _loc33_ = _loc2_.getChar(_loc17_);
                           _loc20_ = _loc4_ + (_loc33_.xAdvance - _loc33_.width) * _loc6_;
                        }
                        _loc20_ += _loc29_;
                     }
                     else if(_loc31_)
                     {
                        _loc19_ = _loc15_;
                        _loc21_ = 0;
                        _loc22_++;
                        _loc18_ = true;
                     }
                     if(_loc18_ && !_loc11_)
                     {
                        this.addBufferToBatch(0);
                     }
                     _loc32_ = _loc23_.width * _loc6_;
                     if(!_loc30_ && (_loc22_ > 0 || this._breakLongWords) && _loc15_ + _loc32_ - _loc12_ > FUZZY_MAX_WIDTH_PADDING)
                     {
                        if(_loc22_ == 0)
                        {
                           _loc21_ = 0;
                           _loc19_ = _loc15_;
                           _loc20_ = 0;
                           if(_loc17_ === _loc17_)
                           {
                              _loc33_ = _loc2_.getChar(_loc17_);
                              _loc20_ = _loc4_ + (_loc33_.xAdvance - _loc33_.width) * _loc6_;
                           }
                           if(!_loc11_)
                           {
                              this.addBufferToBatch(0);
                           }
                        }
                        if(_loc11_)
                        {
                           this.trimBuffer(_loc21_);
                           this.alignBuffer(_loc12_,_loc19_ - _loc20_,_loc21_);
                           this.addBufferToBatch(_loc21_);
                        }
                        this.moveBufferedCharacters(-_loc19_,_loc7_,0);
                        _loc20_ = _loc19_ - _loc20_;
                        if(_loc14_ < _loc20_)
                        {
                           _loc14_ = _loc20_;
                        }
                        _loc17_ = NaN;
                        _loc15_ -= _loc19_;
                        _loc16_ += _loc7_;
                        _loc19_ = 0;
                        _loc20_ = 0;
                        _loc21_ = 0;
                        _loc18_ = false;
                        _loc22_ = 0;
                        ++this._numLines;
                     }
                  }
                  if(this._wordWrap || _loc11_)
                  {
                     _loc34_ = CHAR_LOCATION_POOL.length > 0 ? CHAR_LOCATION_POOL.shift() : new CharLocation();
                     _loc34_.char = _loc23_;
                     _loc34_.x = _loc15_ + _loc8_ + _loc23_.xOffset * _loc6_;
                     _loc34_.y = _loc16_ + _loc9_ + _loc23_.yOffset * _loc6_;
                     _loc34_.scale = _loc6_;
                     CHARACTER_BUFFER[CHARACTER_BUFFER.length] = _loc34_;
                     _loc21_++;
                  }
                  else
                  {
                     this.addCharacterToBatch(_loc23_,_loc15_ + _loc8_ + _loc23_.xOffset * _loc6_,_loc16_ + _loc9_ + _loc23_.yOffset * _loc6_,_loc6_);
                  }
                  _loc15_ += _loc29_ + _loc4_;
                  _loc17_ = _loc28_;
               }
            }
            _loc25_++;
         }
         _loc15_ -= _loc4_;
         if(_loc23_ !== null)
         {
            _loc15_ -= (_loc23_.xAdvance - _loc23_.width) * _loc6_;
         }
         if(_loc15_ < 0)
         {
            _loc15_ = 0;
         }
         if(this._wordWrap || _loc11_)
         {
            this.alignBuffer(_loc12_,_loc15_,0);
            this.addBufferToBatch(0);
         }
         if(this._wordWrap)
         {
            while(_loc15_ > _loc12_ && !MathUtil.isEquivalent(_loc15_,_loc12_))
            {
               _loc15_ -= _loc12_;
               _loc16_ += _loc7_;
               if(_loc12_ == 0)
               {
                  break;
               }
            }
         }
         if(_loc14_ < _loc15_)
         {
            _loc14_ = _loc15_;
         }
         if(_loc11_ && !_loc10_)
         {
            _loc35_ = this._currentTextFormat.align;
            if(_loc35_ == TextFormatAlign.CENTER)
            {
               this._batchX = (_loc14_ - _loc12_) / 2;
            }
            else if(_loc35_ == TextFormatAlign.RIGHT)
            {
               this._batchX = _loc14_ - _loc12_;
            }
         }
         else
         {
            this._batchX = 0;
         }
         this._characterBatch.x = this._batchX;
         param1.width = _loc14_;
         param1.height = _loc16_ + _loc7_ - this._currentTextFormat.leading;
         return param1;
      }
      
      protected function trimBuffer(param1:int) : void
      {
         var _loc5_:CharLocation = null;
         var _loc6_:BitmapChar = null;
         var _loc7_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = CHARACTER_BUFFER.length - param1;
         var _loc4_:* = int(_loc3_ - 1);
         while(_loc4_ >= 0)
         {
            _loc5_ = CHARACTER_BUFFER[_loc4_];
            _loc6_ = _loc5_.char;
            _loc7_ = _loc6_.charID;
            if(!(_loc7_ == CHARACTER_ID_SPACE || _loc7_ == CHARACTER_ID_TAB))
            {
               break;
            }
            _loc2_++;
            _loc4_--;
         }
         if(_loc2_ > 0)
         {
            CHARACTER_BUFFER.splice(_loc4_ + 1,_loc2_);
         }
      }
      
      protected function alignBuffer(param1:Number, param2:Number, param3:int) : void
      {
         var _loc4_:String = this._currentTextFormat.align;
         if(_loc4_ == TextFormatAlign.CENTER)
         {
            this.moveBufferedCharacters(Math.round((param1 - param2) / 2),0,param3);
         }
         else if(_loc4_ == TextFormatAlign.RIGHT)
         {
            this.moveBufferedCharacters(param1 - param2,0,param3);
         }
      }
      
      protected function addBufferToBatch(param1:int) : void
      {
         var _loc5_:CharLocation = null;
         var _loc2_:int = CHARACTER_BUFFER.length - param1;
         var _loc3_:int = int(CHAR_LOCATION_POOL.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = CHARACTER_BUFFER.shift();
            this.addCharacterToBatch(_loc5_.char,_loc5_.x,_loc5_.y,_loc5_.scale);
            _loc5_.char = null;
            CHAR_LOCATION_POOL[_loc3_] = _loc5_;
            _loc3_++;
            _loc4_++;
         }
      }
      
      protected function moveBufferedCharacters(param1:Number, param2:Number, param3:int) : void
      {
         var _loc6_:CharLocation = null;
         var _loc4_:int = CHARACTER_BUFFER.length - param3;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = CHARACTER_BUFFER[_loc5_];
            _loc6_.x += param1;
            _loc6_.y += param2;
            _loc5_++;
         }
      }
      
      protected function addCharacterToBatch(param1:BitmapChar, param2:Number, param3:Number, param4:Number, param5:Painter = null) : void
      {
         var _loc6_:Texture = param1.texture;
         var _loc7_:flash.geom.Rectangle = _loc6_.frame;
         if(_loc7_)
         {
            if(_loc7_.width == 0 || _loc7_.height == 0)
            {
               return;
            }
         }
         else if(_loc6_.width == 0 || _loc6_.height == 0)
         {
            return;
         }
         var _loc8_:BitmapFont = this._currentTextFormat.font;
         if(this._image === null)
         {
            this._image = new Image(_loc6_);
         }
         else
         {
            this._image.texture = _loc6_;
            this._image.readjustSize();
         }
         this._image.scaleX = param4;
         this._image.scaleY = param4;
         this._image.x = param2;
         this._image.y = param3;
         this._image.color = this._currentTextFormat.color;
         if(this._textureSmoothing !== null)
         {
            this._image.textureSmoothing = this._textureSmoothing;
         }
         else
         {
            this._image.textureSmoothing = _loc8_.smoothing;
         }
         if(param5 !== null)
         {
            param5.pushState();
            param5.setStateTo(this._image.transformationMatrix);
            param5.batchMesh(this._image);
            param5.popState();
         }
         else
         {
            this._characterBatch.addMesh(this._image);
         }
      }
      
      protected function refreshTextFormat() : void
      {
         var _loc1_:BitmapFontTextFormat = null;
         var _loc2_:String = null;
         if(this._stateContext !== null)
         {
            if(this._textFormatForState !== null)
            {
               _loc2_ = this._stateContext.currentState;
               if(_loc2_ in this._textFormatForState)
               {
                  _loc1_ = BitmapFontTextFormat(this._textFormatForState[_loc2_]);
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
         if(_loc1_ === null)
         {
            _loc1_ = this._textFormat;
         }
         if(_loc1_ === null)
         {
            _loc1_ = this.getTextFormatFromFontStyles();
         }
         else
         {
            this._currentVerticalAlign = Align.TOP;
            if(this._currentFontStyles === null)
            {
               this._currentFontStyles = new TextFormat();
            }
            this._currentFontStyles.size = _loc1_.size;
         }
         if(this._currentTextFormat !== _loc1_)
         {
            this._currentTextFormat = _loc1_;
            this._textFormatChanged = true;
         }
      }
      
      protected function getTextFormatFromFontStyles() : BitmapFontTextFormat
      {
         var _loc1_:TextFormat = null;
         var _loc2_:BitmapFont = null;
         if(this.isInvalid(INVALIDATION_FLAG_STYLES) || this.isInvalid(INVALIDATION_FLAG_STATE))
         {
            if(this._fontStyles !== null)
            {
               _loc1_ = this._fontStyles.getTextFormatForTarget(this);
               this._currentFontStyles = _loc1_;
            }
            if(_loc1_ !== null)
            {
               this._fontStylesTextFormat = new BitmapFontTextFormat(_loc1_.font,_loc1_.size,_loc1_.color,_loc1_.horizontalAlign,_loc1_.leading);
               this._fontStylesTextFormat.isKerningEnabled = _loc1_.kerning;
               this._fontStylesTextFormat.letterSpacing = _loc1_.letterSpacing;
               this._currentVerticalAlign = _loc1_.verticalAlign;
            }
            else if(this._fontStylesTextFormat === null)
            {
               if(!TextField.getBitmapFont(BitmapFont.MINI))
               {
                  _loc2_ = new BitmapFont();
                  TextField.registerCompositor(_loc2_,_loc2_.name);
               }
               this._fontStylesTextFormat = new BitmapFontTextFormat(BitmapFont.MINI,NaN,0);
               this._currentVerticalAlign = Align.TOP;
            }
         }
         return this._fontStylesTextFormat;
      }
      
      protected function measureTextInternal(param1:Point, param2:Boolean) : Point
      {
         var _loc24_:int = 0;
         var _loc25_:Number = NaN;
         var _loc26_:Boolean = false;
         var _loc27_:Boolean = false;
         var _loc28_:Number = NaN;
         var _loc29_:BitmapChar = null;
         if(!param1)
         {
            param1 = new Point();
         }
         var _loc3_:Boolean = !param2 || this._explicitWidth !== this._explicitWidth;
         var _loc4_:Boolean = !param2 || this._explicitHeight !== this._explicitHeight;
         if(!_loc3_ && !_loc4_)
         {
            param1.x = this._explicitWidth;
            param1.y = this._explicitHeight;
            return param1;
         }
         if(this.isInvalid(INVALIDATION_FLAG_STYLES) || this.isInvalid(INVALIDATION_FLAG_STATE))
         {
            this.refreshTextFormat();
         }
         if(!this._currentTextFormat || this._text === null)
         {
            param1.setTo(0,0);
            return param1;
         }
         var _loc5_:BitmapFont = this._currentTextFormat.font;
         var _loc6_:Number = this._currentTextFormat.size;
         var _loc7_:Number = this._currentTextFormat.letterSpacing;
         var _loc8_:Boolean = this._currentTextFormat.isKerningEnabled;
         var _loc9_:Number = _loc6_ / _loc5_.size;
         if(_loc9_ !== _loc9_)
         {
            _loc9_ = 1;
         }
         var _loc10_:Number = _loc5_.lineHeight * _loc9_ + this._currentTextFormat.leading;
         var _loc11_:Number = this._explicitWidth;
         if(_loc11_ !== _loc11_)
         {
            _loc11_ = this._explicitMaxWidth;
         }
         var _loc12_:Number = 0;
         var _loc13_:Number = 0;
         var _loc14_:Number = 0;
         var _loc15_:Number = NaN;
         var _loc16_:int = this._text.length;
         var _loc17_:Number = 0;
         var _loc18_:Number = 0;
         var _loc19_:int = 0;
         var _loc20_:String = "";
         var _loc21_:String = "";
         var _loc22_:BitmapChar = null;
         var _loc23_:int = 0;
         while(_loc23_ < _loc16_)
         {
            _loc24_ = this._text.charCodeAt(_loc23_);
            if(_loc24_ == CHARACTER_ID_LINE_FEED || _loc24_ == CHARACTER_ID_CARRIAGE_RETURN)
            {
               _loc13_ -= _loc7_;
               if(_loc22_ !== null)
               {
                  _loc13_ -= (_loc22_.xAdvance - _loc22_.width) * _loc9_;
               }
               if(_loc13_ < 0)
               {
                  _loc13_ = 0;
               }
               if(_loc12_ < _loc13_)
               {
                  _loc12_ = _loc13_;
               }
               _loc15_ = NaN;
               _loc13_ = 0;
               _loc14_ += _loc10_;
               _loc17_ = 0;
               _loc19_ = 0;
               _loc18_ = 0;
            }
            else
            {
               _loc22_ = _loc5_.getChar(_loc24_);
               if(_loc22_ !== null)
               {
                  if(_loc8_ && _loc15_ === _loc15_)
                  {
                     _loc13_ += _loc22_.getKerning(_loc15_) * _loc9_;
                  }
                  _loc25_ = _loc22_.xAdvance * _loc9_;
                  if(this._wordWrap)
                  {
                     _loc26_ = _loc24_ == CHARACTER_ID_SPACE || _loc24_ == CHARACTER_ID_TAB;
                     _loc27_ = _loc15_ == CHARACTER_ID_SPACE || _loc15_ == CHARACTER_ID_TAB;
                     if(_loc26_)
                     {
                        if(!_loc27_)
                        {
                           _loc29_ = _loc5_.getChar(_loc15_);
                           _loc18_ = _loc7_ + (_loc29_.xAdvance - _loc29_.width) * _loc9_;
                        }
                        _loc18_ += _loc25_;
                     }
                     else if(_loc27_)
                     {
                        _loc17_ = _loc13_;
                        _loc19_++;
                        _loc20_ += _loc21_;
                        _loc21_ = "";
                     }
                     _loc28_ = _loc22_.width * _loc9_;
                     if(!_loc26_ && (_loc19_ > 0 || this._breakLongWords) && _loc13_ + _loc28_ > _loc11_)
                     {
                        if(_loc19_ == 0)
                        {
                           _loc17_ = _loc13_;
                           if(_loc15_ === _loc15_)
                           {
                              _loc29_ = _loc5_.getChar(_loc15_);
                              _loc18_ = _loc7_ + (_loc29_.xAdvance - _loc29_.width) * _loc9_;
                           }
                        }
                        _loc18_ = _loc17_ - _loc18_;
                        if(_loc12_ < _loc18_)
                        {
                           _loc12_ = _loc18_;
                        }
                        _loc15_ = NaN;
                        _loc13_ -= _loc17_;
                        _loc14_ += _loc10_;
                        _loc17_ = 0;
                        _loc18_ = 0;
                        _loc19_ = 0;
                        _loc20_ = "";
                     }
                  }
                  _loc13_ += _loc25_ + _loc7_;
                  _loc15_ = _loc24_;
                  _loc21_ += String.fromCharCode(_loc24_);
               }
            }
            _loc23_++;
         }
         _loc13_ -= _loc7_;
         if(_loc22_ !== null)
         {
            _loc13_ -= (_loc22_.xAdvance - _loc22_.width) * _loc9_;
         }
         if(_loc13_ < 0)
         {
            _loc13_ = 0;
         }
         if(this._wordWrap)
         {
            while(_loc13_ > _loc11_ && !MathUtil.isEquivalent(_loc13_,_loc11_))
            {
               _loc13_ -= _loc11_;
               _loc14_ += _loc10_;
               if(_loc11_ == 0)
               {
                  break;
               }
            }
         }
         if(_loc12_ < _loc13_)
         {
            _loc12_ = _loc13_;
         }
         if(_loc3_)
         {
            param1.x = _loc12_;
         }
         else
         {
            param1.x = this._explicitWidth;
         }
         if(_loc4_)
         {
            param1.y = _loc14_ + _loc10_ - this._currentTextFormat.leading;
         }
         else
         {
            param1.y = this._explicitHeight;
         }
         return param1;
      }
      
      protected function getTruncatedText(param1:Number) : String
      {
         var _loc12_:int = 0;
         var _loc13_:BitmapChar = null;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         if(!this._text)
         {
            return "";
         }
         if(param1 == Number.POSITIVE_INFINITY || this._wordWrap || this._text.indexOf(String.fromCharCode(CHARACTER_ID_LINE_FEED)) >= 0 || this._text.indexOf(String.fromCharCode(CHARACTER_ID_CARRIAGE_RETURN)) >= 0)
         {
            return this._text;
         }
         var _loc2_:BitmapFont = this._currentTextFormat.font;
         var _loc3_:Number = this._currentTextFormat.size;
         var _loc4_:Number = this._currentTextFormat.letterSpacing;
         var _loc5_:Boolean = this._currentTextFormat.isKerningEnabled;
         var _loc6_:Number = _loc3_ / _loc2_.size;
         if(_loc6_ !== _loc6_)
         {
            _loc6_ = 1;
         }
         var _loc7_:Number = 0;
         var _loc8_:Number = NaN;
         var _loc9_:int = this._text.length;
         var _loc10_:int = -1;
         var _loc11_:* = 0;
         while(_loc11_ < _loc9_)
         {
            _loc12_ = this._text.charCodeAt(_loc11_);
            _loc13_ = _loc2_.getChar(_loc12_);
            if(_loc13_ !== null)
            {
               _loc14_ = 0;
               if(_loc5_ && _loc8_ === _loc8_)
               {
                  _loc14_ = _loc13_.getKerning(_loc8_) * _loc6_;
               }
               _loc15_ = _loc13_.width * _loc6_;
               _loc7_ += _loc14_ + _loc15_;
               if(_loc7_ > param1)
               {
                  _loc16_ = Math.abs(_loc7_ - param1);
                  if(_loc16_ > FUZZY_MAX_WIDTH_PADDING)
                  {
                     _loc10_ = _loc11_;
                     _loc7_ += _loc13_.xAdvance * _loc6_ - _loc15_;
                     break;
                  }
               }
               _loc7_ += _loc4_ + _loc13_.xAdvance * _loc6_ - _loc15_;
               _loc8_ = _loc12_;
            }
            _loc11_++;
         }
         if(_loc10_ >= 0)
         {
            _loc9_ = this._truncationText.length;
            _loc11_ = 0;
            while(_loc11_ < _loc9_)
            {
               _loc12_ = this._truncationText.charCodeAt(_loc11_);
               _loc13_ = _loc2_.getChar(_loc12_);
               if(_loc13_ !== null)
               {
                  _loc14_ = 0;
                  if(_loc5_ && _loc8_ === _loc8_)
                  {
                     _loc14_ = _loc13_.getKerning(_loc8_) * _loc6_;
                  }
                  _loc7_ += _loc14_ + _loc13_.xAdvance * _loc6_ + _loc4_;
                  _loc8_ = _loc12_;
               }
               _loc11_++;
            }
            _loc7_ -= _loc4_;
            if(_loc13_ !== null)
            {
               _loc7_ -= (_loc13_.xAdvance - _loc13_.width) * _loc6_;
            }
            _loc11_ = _loc10_;
            while(_loc11_ >= 0)
            {
               _loc12_ = this._text.charCodeAt(_loc11_);
               _loc8_ = _loc11_ > 0 ? this._text.charCodeAt(_loc11_ - 1) : NaN;
               _loc13_ = _loc2_.getChar(_loc12_);
               if(_loc13_ !== null)
               {
                  _loc14_ = 0;
                  if(_loc5_ && _loc8_ === _loc8_)
                  {
                     _loc14_ = _loc13_.getKerning(_loc8_) * _loc6_;
                  }
                  _loc7_ -= _loc14_ + _loc13_.xAdvance * _loc6_ + _loc4_;
                  if(_loc7_ <= param1)
                  {
                     return this._text.substr(0,_loc11_) + this._truncationText;
                  }
               }
               _loc11_--;
            }
            return this._truncationText;
         }
         return this._text;
      }
      
      protected function getVerticalAlignOffsetY() : Number
      {
         var _loc1_:BitmapFont = this._currentTextFormat.font;
         var _loc2_:Number = this._currentTextFormat.size;
         var _loc3_:Number = _loc2_ / _loc1_.size;
         if(_loc3_ !== _loc3_)
         {
            _loc3_ = 1;
         }
         var _loc4_:Number = _loc1_.lineHeight * _loc3_ + this._currentTextFormat.leading;
         var _loc5_:Number = this._numLines * _loc4_;
         if(_loc5_ > this.actualHeight)
         {
            return 0;
         }
         if(this._currentVerticalAlign === Align.BOTTOM)
         {
            return this.actualHeight - _loc5_;
         }
         if(this._currentVerticalAlign === Align.CENTER)
         {
            return (this.actualHeight - _loc5_) / 2;
         }
         return 0;
      }
   }
}

import starling.text.BitmapChar;

class CharLocation
{
   
   public var char:BitmapChar;
   
   public var scale:Number;
   
   public var x:Number;
   
   public var y:Number;
   
   public function CharLocation()
   {
      super();
   }
}
