package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.events.FeathersEventType;
   import feathers.layout.HorizontalAlign;
   import feathers.layout.VerticalAlign;
   import feathers.skins.IStyleProvider;
   import feathers.utils.textures.TextureCache;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.errors.IllegalOperationError;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.geom.Rectangle;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.system.ImageDecodingPolicy;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   import flash.utils.setTimeout;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.display.Mesh;
   import starling.display.Quad;
   import starling.events.EnterFrameEvent;
   import starling.events.Event;
   import starling.styles.MeshStyle;
   import starling.textures.Texture;
   import starling.utils.RectangleUtil;
   import starling.utils.ScaleMode;
   import starling.utils.SystemUtil;
   
   public class ImageLoader extends FeathersControl
   {
      
      protected static var textureQueueHead:ImageLoader;
      
      protected static var textureQueueTail:ImageLoader;
      
      public static var globalStyleProvider:IStyleProvider;
      
      private static const HELPER_RECTANGLE:flash.geom.Rectangle = new flash.geom.Rectangle();
      
      private static const HELPER_RECTANGLE2:flash.geom.Rectangle = new flash.geom.Rectangle();
      
      private static const CONTEXT_LOST_WARNING:String = "ImageLoader: Context lost while processing loaded image, retrying...";
      
      protected static const ATF_FILE_EXTENSION:String = "atf";
      
      protected var image:Image;
      
      protected var loader:Loader;
      
      protected var urlLoader:URLLoader;
      
      protected var _lastURL:String;
      
      protected var _originalTextureWidth:Number = NaN;
      
      protected var _originalTextureHeight:Number = NaN;
      
      protected var _currentTextureWidth:Number = NaN;
      
      protected var _currentTextureHeight:Number = NaN;
      
      protected var _currentTexture:Texture;
      
      protected var _isRestoringTexture:Boolean = false;
      
      protected var _texture:Texture;
      
      protected var _isTextureOwner:Boolean = false;
      
      protected var _source:Object;
      
      protected var _textureCache:TextureCache;
      
      protected var _loadingTexture:Texture;
      
      protected var _errorTexture:Texture;
      
      protected var _isLoaded:Boolean = false;
      
      private var _textureScale:Number = 1;
      
      private var _scaleFactor:Number = 1;
      
      private var _textureSmoothing:String = "bilinear";
      
      protected var _defaultStyle:MeshStyle = null;
      
      protected var _style:MeshStyle = null;
      
      private var _scale9Grid:flash.geom.Rectangle;
      
      private var _tileGrid:flash.geom.Rectangle;
      
      private var _pixelSnapping:Boolean = true;
      
      private var _color:uint = 16777215;
      
      private var _textureFormat:String = "bgra";
      
      private var _scaleContent:Boolean = true;
      
      private var _maintainAspectRatio:Boolean = true;
      
      private var _scaleMode:String = "showAll";
      
      protected var _horizontalAlign:String = "left";
      
      protected var _verticalAlign:String = "top";
      
      protected var _pendingBitmapDataTexture:BitmapData;
      
      protected var _pendingRawTextureData:ByteArray;
      
      protected var _delayTextureCreation:Boolean = false;
      
      protected var _isInTextureQueue:Boolean = false;
      
      protected var _textureQueuePrevious:ImageLoader;
      
      protected var _textureQueueNext:ImageLoader;
      
      protected var _accumulatedPrepareTextureTime:Number;
      
      protected var _textureQueueDuration:Number = Infinity;
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var _asyncTextureUpload:Boolean = true;
      
      protected var _imageDecodingOnLoad:Boolean = false;
      
      protected var _loaderContext:LoaderContext = null;
      
      public function ImageLoader()
      {
         super();
         this.isQuickHitAreaEnabled = true;
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return ImageLoader.globalStyleProvider;
      }
      
      public function get source() : Object
      {
         return this._source;
      }
      
      public function set source(param1:Object) : void
      {
         var _loc2_:Texture = null;
         if(this._source == param1)
         {
            return;
         }
         this._isRestoringTexture = false;
         if(this._isInTextureQueue)
         {
            this.removeFromTextureQueue();
         }
         if(Boolean(this._isTextureOwner) && Boolean(param1) && !(param1 is Texture))
         {
            _loc2_ = this._texture;
            this._isTextureOwner = false;
         }
         this.cleanupTexture();
         this._source = param1;
         if(_loc2_)
         {
            this._texture = _loc2_;
            this._isTextureOwner = true;
         }
         if(this.image)
         {
            this.image.visible = false;
         }
         this.cleanupLoaders(true);
         this._lastURL = null;
         if(this._source is Texture)
         {
            this._isLoaded = true;
         }
         else
         {
            this._isLoaded = false;
         }
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get textureCache() : TextureCache
      {
         return this._textureCache;
      }
      
      public function set textureCache(param1:TextureCache) : void
      {
         this._textureCache = param1;
      }
      
      public function get loadingTexture() : Texture
      {
         return this._loadingTexture;
      }
      
      public function set loadingTexture(param1:Texture) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._loadingTexture === param1)
         {
            return;
         }
         this._loadingTexture = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get errorTexture() : Texture
      {
         return this._errorTexture;
      }
      
      public function set errorTexture(param1:Texture) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._errorTexture === param1)
         {
            return;
         }
         this._errorTexture = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get isLoaded() : Boolean
      {
         return this._isLoaded;
      }
      
      public function get textureScale() : Number
      {
         return this._textureScale;
      }
      
      public function set textureScale(param1:Number) : void
      {
         if(this._textureScale == param1)
         {
            return;
         }
         this._textureScale = param1;
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
      
      public function get scaleFactor() : Number
      {
         return this._scaleFactor;
      }
      
      public function set scaleFactor(param1:Number) : void
      {
         if(this._scaleFactor == param1)
         {
            return;
         }
         this._scaleFactor = param1;
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
      
      public function get textureSmoothing() : String
      {
         return this._textureSmoothing;
      }
      
      public function set textureSmoothing(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._textureSmoothing === param1)
         {
            return;
         }
         this._textureSmoothing = param1;
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
         if(this._style)
         {
            this._defaultStyle = null;
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get scale9Grid() : flash.geom.Rectangle
      {
         return this._scale9Grid;
      }
      
      public function set scale9Grid(param1:flash.geom.Rectangle) : void
      {
         if(this._scale9Grid == param1)
         {
            return;
         }
         this._scale9Grid = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get tileGrid() : flash.geom.Rectangle
      {
         return this._tileGrid;
      }
      
      public function set tileGrid(param1:flash.geom.Rectangle) : void
      {
         if(this._tileGrid == param1)
         {
            return;
         }
         this._tileGrid = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get pixelSnapping() : Boolean
      {
         return this._pixelSnapping;
      }
      
      public function set pixelSnapping(param1:Boolean) : void
      {
         if(this._pixelSnapping == param1)
         {
            return;
         }
         this._pixelSnapping = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get color() : uint
      {
         return this._color;
      }
      
      public function set color(param1:uint) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._color == param1)
         {
            return;
         }
         this._color = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get textureFormat() : String
      {
         return this._textureFormat;
      }
      
      public function set textureFormat(param1:String) : void
      {
         if(this._textureFormat == param1)
         {
            return;
         }
         this._textureFormat = param1;
         this._lastURL = null;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get scaleContent() : Boolean
      {
         return this._scaleContent;
      }
      
      public function set scaleContent(param1:Boolean) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._scaleContent === param1)
         {
            return;
         }
         this._scaleContent = param1;
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
      }
      
      public function get maintainAspectRatio() : Boolean
      {
         return this._maintainAspectRatio;
      }
      
      public function set maintainAspectRatio(param1:Boolean) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._maintainAspectRatio === param1)
         {
            return;
         }
         this._maintainAspectRatio = param1;
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
      }
      
      public function get scaleMode() : String
      {
         return this._scaleMode;
      }
      
      public function set scaleMode(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._scaleMode === param1)
         {
            return;
         }
         this._scaleMode = param1;
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
      }
      
      public function get horizontalAlign() : String
      {
         return this._horizontalAlign;
      }
      
      public function set horizontalAlign(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._horizontalAlign === param1)
         {
            return;
         }
         this._horizontalAlign = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get verticalAlign() : String
      {
         return this._verticalAlign;
      }
      
      public function set verticalAlign(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._verticalAlign === param1)
         {
            return;
         }
         this._verticalAlign = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get originalSourceWidth() : Number
      {
         if(this._originalTextureWidth === this._originalTextureWidth)
         {
            return this._originalTextureWidth;
         }
         return 0;
      }
      
      public function get originalSourceHeight() : Number
      {
         if(this._originalTextureHeight === this._originalTextureHeight)
         {
            return this._originalTextureHeight;
         }
         return 0;
      }
      
      public function get delayTextureCreation() : Boolean
      {
         return this._delayTextureCreation;
      }
      
      public function set delayTextureCreation(param1:Boolean) : void
      {
         if(this._delayTextureCreation == param1)
         {
            return;
         }
         this._delayTextureCreation = param1;
         if(!this._delayTextureCreation)
         {
            this.processPendingTexture();
         }
      }
      
      public function get textureQueueDuration() : Number
      {
         return this._textureQueueDuration;
      }
      
      public function set textureQueueDuration(param1:Number) : void
      {
         if(this._textureQueueDuration == param1)
         {
            return;
         }
         var _loc2_:Number = this._textureQueueDuration;
         this._textureQueueDuration = param1;
         if(this._delayTextureCreation)
         {
            if((Boolean(this._pendingBitmapDataTexture || this._pendingRawTextureData)) && Boolean(_loc2_ == Number.POSITIVE_INFINITY) && this._textureQueueDuration < Number.POSITIVE_INFINITY)
            {
               this.addToTextureQueue();
            }
            else if(this._isInTextureQueue && this._textureQueueDuration == Number.POSITIVE_INFINITY)
            {
               this.removeFromTextureQueue();
            }
         }
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
      
      public function get asyncTextureUpload() : Boolean
      {
         return this._asyncTextureUpload;
      }
      
      public function set asyncTextureUpload(param1:Boolean) : void
      {
         this._asyncTextureUpload = param1;
      }
      
      public function get loaderContext() : LoaderContext
      {
         return this._loaderContext;
      }
      
      public function set loaderContext(param1:LoaderContext) : void
      {
         this._loaderContext = param1;
      }
      
      override public function dispose() : void
      {
         this._isRestoringTexture = false;
         this.cleanupLoaders(true);
         this.cleanupTexture();
         super.dispose();
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_LAYOUT);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc4_:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
         if(_loc1_)
         {
            this.commitData();
         }
         if(_loc1_ || _loc3_)
         {
            this.commitStyles();
         }
         _loc4_ = this.autoSizeIfNeeded() || _loc4_;
         if(_loc1_ || _loc2_ || _loc4_ || _loc3_)
         {
            this.layout();
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
         var _loc5_:Number = 1;
         var _loc6_:Number = 1;
         if(this._scaleContent && this._maintainAspectRatio && this._scaleMode !== ScaleMode.NONE && this._scale9Grid === null)
         {
            if(!_loc2_)
            {
               _loc5_ = this._explicitHeight / (this._currentTextureHeight * this._textureScale);
            }
            else if(this._explicitMaxHeight < this._currentTextureHeight)
            {
               _loc5_ = this._explicitMaxHeight / (this._currentTextureHeight * this._textureScale);
            }
            else if(this._explicitMinHeight > this._currentTextureHeight)
            {
               _loc5_ = this._explicitMinHeight / (this._currentTextureHeight * this._textureScale);
            }
            if(!_loc1_)
            {
               _loc6_ = this._explicitWidth / (this._currentTextureWidth * this._textureScale);
            }
            else if(this._explicitMaxWidth < this._currentTextureWidth)
            {
               _loc6_ = this._explicitMaxWidth / (this._currentTextureWidth * this._textureScale);
            }
            else if(this._explicitMinWidth > this._currentTextureWidth)
            {
               _loc6_ = this._explicitMinWidth / (this._currentTextureWidth * this._textureScale);
            }
         }
         var _loc7_:Number = this._explicitWidth;
         if(_loc1_)
         {
            if(this._currentTextureWidth === this._currentTextureWidth)
            {
               _loc7_ = this._currentTextureWidth * this._textureScale * _loc5_;
            }
            else
            {
               _loc7_ = 0;
            }
            _loc7_ += this._paddingLeft + this._paddingRight;
         }
         var _loc8_:Number = this._explicitHeight;
         if(_loc2_)
         {
            if(this._currentTextureHeight === this._currentTextureHeight)
            {
               _loc8_ = this._currentTextureHeight * this._textureScale * _loc6_;
            }
            else
            {
               _loc8_ = 0;
            }
            _loc8_ += this._paddingTop + this._paddingBottom;
         }
         if(_loc2_ && _loc4_)
         {
            _loc5_ = 1;
         }
         if(_loc1_ && _loc3_)
         {
            _loc6_ = 1;
         }
         var _loc9_:Number = this._explicitMinWidth;
         if(_loc3_)
         {
            if(this._currentTextureWidth === this._currentTextureWidth)
            {
               _loc9_ = this._currentTextureWidth * this._textureScale * _loc5_;
            }
            else
            {
               _loc9_ = 0;
            }
            _loc9_ += this._paddingLeft + this._paddingRight;
         }
         var _loc10_:Number = this._explicitMinHeight;
         if(_loc4_)
         {
            if(this._currentTextureHeight === this._currentTextureHeight)
            {
               _loc10_ = this._currentTextureHeight * this._textureScale * _loc6_;
            }
            else
            {
               _loc10_ = 0;
            }
            _loc10_ += this._paddingTop + this._paddingBottom;
         }
         return this.saveMeasurements(_loc7_,_loc8_,_loc9_,_loc10_);
      }
      
      protected function commitData() : void
      {
         var _loc1_:String = null;
         if(this._source is Texture)
         {
            this._lastURL = null;
            this._texture = Texture(this._source);
            this.refreshCurrentTexture();
         }
         else
         {
            _loc1_ = this._source as String;
            if(!_loc1_)
            {
               this._lastURL = null;
            }
            else if(_loc1_ != this._lastURL)
            {
               this._lastURL = _loc1_;
               if(this.findSourceInCache())
               {
                  return;
               }
               if(this.isATFURL(_loc1_))
               {
                  if(this.loader)
                  {
                     this.loader = null;
                  }
                  if(!this.urlLoader)
                  {
                     this.urlLoader = new URLLoader();
                     this.urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
                  }
                  this.urlLoader.addEventListener(flash.events.Event.COMPLETE,this.rawDataLoader_completeHandler);
                  this.urlLoader.addEventListener(ProgressEvent.PROGRESS,this.rawDataLoader_progressHandler);
                  this.urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.rawDataLoader_ioErrorHandler);
                  this.urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.rawDataLoader_securityErrorHandler);
                  this.urlLoader.load(new URLRequest(_loc1_));
                  return;
               }
               if(this.urlLoader)
               {
                  this.urlLoader = null;
               }
               if(!this.loader)
               {
                  this.loader = new Loader();
               }
               this.loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,this.loader_completeHandler);
               this.loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.loader_progressHandler);
               this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.loader_ioErrorHandler);
               this.loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.loader_securityErrorHandler);
               if(this._loaderContext === null)
               {
                  this._loaderContext = new LoaderContext(true);
                  this._loaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
               }
               this._imageDecodingOnLoad = this._loaderContext.imageDecodingPolicy === ImageDecodingPolicy.ON_LOAD;
               this.loader.load(new URLRequest(_loc1_),this._loaderContext);
            }
            this.refreshCurrentTexture();
         }
      }
      
      protected function commitStyles() : void
      {
         if(!this.image)
         {
            return;
         }
         this.image.textureSmoothing = this._textureSmoothing;
         this.image.color = this._color;
         this.image.scale9Grid = this._scale9Grid;
         this.image.tileGrid = this._tileGrid;
         this.image.pixelSnapping = this._pixelSnapping;
         if(this._style !== null)
         {
            this.image.style = this._style;
         }
         else
         {
            if(this._defaultStyle === null)
            {
               this._defaultStyle = Mesh.createDefaultStyle(this.image);
            }
            this.image.style = this._defaultStyle;
         }
      }
      
      protected function layout() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Quad = null;
         if(!this.image || !this._currentTexture)
         {
            return;
         }
         if(this._scaleContent)
         {
            if(this._maintainAspectRatio && this._scale9Grid === null)
            {
               HELPER_RECTANGLE.x = 0;
               HELPER_RECTANGLE.y = 0;
               HELPER_RECTANGLE.width = this._currentTextureWidth * this._textureScale;
               HELPER_RECTANGLE.height = this._currentTextureHeight * this._textureScale;
               HELPER_RECTANGLE2.x = 0;
               HELPER_RECTANGLE2.y = 0;
               HELPER_RECTANGLE2.width = this.actualWidth - this._paddingLeft - this._paddingRight;
               HELPER_RECTANGLE2.height = this.actualHeight - this._paddingTop - this._paddingBottom;
               RectangleUtil.fit(HELPER_RECTANGLE,HELPER_RECTANGLE2,this._scaleMode,false,HELPER_RECTANGLE);
               this.image.x = HELPER_RECTANGLE.x + this._paddingLeft;
               this.image.y = HELPER_RECTANGLE.y + this._paddingTop;
               this.image.width = HELPER_RECTANGLE.width;
               this.image.height = HELPER_RECTANGLE.height;
            }
            else
            {
               this.image.x = this._paddingLeft;
               this.image.y = this._paddingTop;
               this.image.width = this.actualWidth - this._paddingLeft - this._paddingRight;
               this.image.height = this.actualHeight - this._paddingTop - this._paddingBottom;
            }
         }
         else
         {
            _loc1_ = this._currentTextureWidth * this._textureScale;
            _loc2_ = this._currentTextureHeight * this._textureScale;
            if(this._horizontalAlign === HorizontalAlign.RIGHT)
            {
               this.image.x = this.actualWidth - this._paddingRight - _loc1_;
            }
            else if(this._horizontalAlign === HorizontalAlign.CENTER)
            {
               this.image.x = this._paddingLeft + (this.actualWidth - this._paddingLeft - this._paddingRight - _loc1_) / 2;
            }
            else
            {
               this.image.x = this._paddingLeft;
            }
            if(this._verticalAlign === VerticalAlign.BOTTOM)
            {
               this.image.y = this.actualHeight - this._paddingBottom - _loc2_;
            }
            else if(this._verticalAlign === VerticalAlign.MIDDLE)
            {
               this.image.y = this._paddingTop + (this.actualHeight - this._paddingTop - this._paddingBottom - _loc2_) / 2;
            }
            else
            {
               this.image.y = this._paddingTop;
            }
            this.image.width = _loc1_;
            this.image.height = _loc2_;
         }
         if((!this._scaleContent || this._maintainAspectRatio && this._scaleMode !== ScaleMode.SHOW_ALL) && (this.actualWidth != _loc1_ || this.actualHeight != _loc2_))
         {
            _loc3_ = this.image.mask as Quad;
            if(_loc3_ !== null)
            {
               _loc3_.x = 0;
               _loc3_.y = 0;
               _loc3_.width = this.actualWidth;
               _loc3_.height = this.actualHeight;
            }
            else
            {
               _loc3_ = new Quad(1,1,16711935);
               _loc3_.width = this.actualWidth;
               _loc3_.height = this.actualHeight;
               this.image.mask = _loc3_;
               this.addChild(_loc3_);
            }
         }
         else
         {
            _loc3_ = this.image.mask as Quad;
            if(_loc3_ !== null)
            {
               _loc3_.removeFromParent(true);
               this.image.mask = null;
            }
         }
      }
      
      protected function isATFURL(param1:String) : Boolean
      {
         var _loc2_:int = param1.indexOf("?");
         if(_loc2_ >= 0)
         {
            param1 = param1.substr(0,_loc2_);
         }
         return param1.toLowerCase().lastIndexOf(ATF_FILE_EXTENSION) == param1.length - 3;
      }
      
      protected function refreshCurrentTexture() : void
      {
         var _loc1_:Texture = this._isLoaded ? this._texture : null;
         if(!_loc1_)
         {
            if(Boolean(this.loader) || Boolean(this.urlLoader))
            {
               _loc1_ = this._loadingTexture;
            }
            else
            {
               _loc1_ = this._errorTexture;
            }
         }
         if(this._currentTexture == _loc1_)
         {
            return;
         }
         this._currentTexture = _loc1_;
         if(!this._currentTexture)
         {
            if(this.image)
            {
               this.removeChild(this.image,true);
               this.image = null;
               this._defaultStyle = null;
            }
            return;
         }
         var _loc2_:flash.geom.Rectangle = this._currentTexture.frame;
         if(_loc2_)
         {
            this._currentTextureWidth = _loc2_.width;
            this._currentTextureHeight = _loc2_.height;
         }
         else
         {
            this._currentTextureWidth = this._currentTexture.width;
            this._currentTextureHeight = this._currentTexture.height;
            this._originalTextureWidth = this._currentTexture.nativeWidth;
            this._originalTextureHeight = this._currentTexture.nativeHeight;
         }
         if(!this.image)
         {
            this.image = new Image(this._currentTexture);
            this.addChild(this.image);
         }
         else
         {
            this.image.texture = this._currentTexture;
            this.image.readjustSize();
         }
         this.image.visible = true;
      }
      
      protected function cleanupTexture() : void
      {
         var _loc1_:String = null;
         if(this._texture)
         {
            if(this._isTextureOwner)
            {
               if(!SystemUtil.isDesktop && !SystemUtil.isApplicationActive)
               {
                  SystemUtil.executeWhenApplicationIsActive(this._texture.dispose);
               }
               else
               {
                  this._texture.dispose();
               }
            }
            else if(this._textureCache !== null)
            {
               _loc1_ = this.sourceToTextureCacheKey(this._source);
               if(_loc1_ !== null)
               {
                  this._textureCache.releaseTexture(_loc1_);
               }
            }
         }
         if(this._pendingBitmapDataTexture)
         {
            this._pendingBitmapDataTexture.dispose();
         }
         if(this._pendingRawTextureData)
         {
            this._pendingRawTextureData.clear();
         }
         this._currentTexture = null;
         this._currentTextureWidth = NaN;
         this._currentTextureHeight = NaN;
         this._originalTextureWidth = NaN;
         this._originalTextureHeight = NaN;
         this._pendingBitmapDataTexture = null;
         this._pendingRawTextureData = null;
         this._texture = null;
         this._isTextureOwner = false;
      }
      
      protected function cleanupLoaders(param1:Boolean) : void
      {
         var _loc2_:Boolean = false;
         if(this.urlLoader)
         {
            this.urlLoader.removeEventListener(flash.events.Event.COMPLETE,this.rawDataLoader_completeHandler);
            this.urlLoader.removeEventListener(ProgressEvent.PROGRESS,this.rawDataLoader_progressHandler);
            this.urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.rawDataLoader_ioErrorHandler);
            this.urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.rawDataLoader_securityErrorHandler);
            if(param1)
            {
               try
               {
                  this.urlLoader.close();
               }
               catch(error:Error)
               {
               }
            }
            this.urlLoader = null;
         }
         if(this.loader)
         {
            this.loader.contentLoaderInfo.removeEventListener(flash.events.Event.COMPLETE,this.loader_completeHandler);
            this.loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.loader_progressHandler);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.loader_ioErrorHandler);
            this.loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.loader_securityErrorHandler);
            if(param1)
            {
               _loc2_ = false;
               if(!this._imageDecodingOnLoad)
               {
                  try
                  {
                     this.loader.close();
                     _loc2_ = true;
                  }
                  catch(error:Error)
                  {
                  }
               }
               if(!_loc2_)
               {
                  this.loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,this.orphanedLoader_completeHandler);
                  this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.orphanedLoader_errorHandler);
                  this.loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.orphanedLoader_errorHandler);
               }
            }
            this.loader = null;
         }
      }
      
      protected function findSourceInCache() : Boolean
      {
         var _loc1_:String = this.sourceToTextureCacheKey(this._source);
         if(this._textureCache !== null && !this._isRestoringTexture && _loc1_ !== null && this._textureCache.hasTexture(_loc1_))
         {
            this._texture = this._textureCache.retainTexture(_loc1_);
            this._isTextureOwner = false;
            this._isRestoringTexture = false;
            this._isLoaded = true;
            this.refreshCurrentTexture();
            this.dispatchEventWith(starling.events.Event.COMPLETE);
            return true;
         }
         return false;
      }
      
      protected function sourceToTextureCacheKey(param1:Object) : String
      {
         if(param1 is String)
         {
            return param1 as String;
         }
         return null;
      }
      
      protected function verifyCurrentStarling() : void
      {
         if(this.stage === null || Starling.current.stage === this.stage)
         {
            return;
         }
         this.stage.starling.makeCurrent();
      }
      
      protected function replaceBitmapDataTexture(param1:BitmapData) : void
      {
         var cacheKey:String = null;
         var bitmapData:BitmapData = param1;
         var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         if(!starling.contextValid)
         {
            setTimeout(this.replaceBitmapDataTexture,1,bitmapData);
            return;
         }
         if(!SystemUtil.isDesktop && !SystemUtil.isApplicationActive)
         {
            SystemUtil.executeWhenApplicationIsActive(this.replaceBitmapDataTexture,bitmapData);
            return;
         }
         this.verifyCurrentStarling();
         if(this.findSourceInCache())
         {
            bitmapData.dispose();
            this.invalidate(INVALIDATION_FLAG_DATA);
            return;
         }
         if(!this._texture)
         {
            try
            {
               this._texture = Texture.empty(bitmapData.width / this._scaleFactor,bitmapData.height / this._scaleFactor,true,false,false,this._scaleFactor,this._textureFormat);
            }
            catch(error:Error)
            {
               this.cleanupTexture();
               this.invalidate(INVALIDATION_FLAG_DATA);
               this.dispatchEventWith(starling.events.Event.IO_ERROR,false,new IOErrorEvent(IOErrorEvent.IO_ERROR,false,false,error.toString()));
               return;
            }
            this._texture.root.onRestore = this.createTextureOnRestore(this._texture,this._source,this._textureFormat,this._scaleFactor);
            if(this._textureCache)
            {
               cacheKey = this.sourceToTextureCacheKey(this._source);
               if(cacheKey !== null)
               {
                  this._textureCache.addTexture(cacheKey,this._texture,true);
               }
            }
         }
         if(this._asyncTextureUpload)
         {
            this._texture.root.uploadBitmapData(bitmapData,function():void
            {
               if(image !== null)
               {
                  image.setRequiresRedraw();
               }
               bitmapData.dispose();
               _isTextureOwner = _textureCache === null;
               _isRestoringTexture = false;
               _isLoaded = true;
               refreshCurrentTexture();
               invalidate(INVALIDATION_FLAG_DATA);
               dispatchEventWith(starling.events.Event.COMPLETE);
            });
         }
         else
         {
            this._texture.root.uploadBitmapData(bitmapData);
            if(this.image !== null)
            {
               this.image.setRequiresRedraw();
            }
            bitmapData.dispose();
            this._isTextureOwner = this._textureCache === null;
            this._isRestoringTexture = false;
            this._isLoaded = true;
            this.refreshCurrentTexture();
            this.invalidate(INVALIDATION_FLAG_DATA);
            this.dispatchEventWith(starling.events.Event.COMPLETE);
         }
      }
      
      protected function replaceRawTextureData(param1:ByteArray) : void
      {
         var cacheKey:String = null;
         var rawData:ByteArray = param1;
         var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         if(!starling.contextValid)
         {
            setTimeout(this.replaceRawTextureData,1,rawData);
            return;
         }
         if(!SystemUtil.isDesktop && !SystemUtil.isApplicationActive)
         {
            SystemUtil.executeWhenApplicationIsActive(this.replaceRawTextureData,rawData);
            return;
         }
         this.verifyCurrentStarling();
         if(this.findSourceInCache())
         {
            rawData.clear();
            this.invalidate(INVALIDATION_FLAG_DATA);
            return;
         }
         if(this._texture)
         {
            this._texture.root.uploadAtfData(rawData);
         }
         else
         {
            try
            {
               this._texture = Texture.fromAtfData(rawData,this._scaleFactor);
            }
            catch(error:Error)
            {
               this.cleanupTexture();
               this.invalidate(INVALIDATION_FLAG_DATA);
               this.dispatchEventWith(starling.events.Event.IO_ERROR,false,new IOErrorEvent(IOErrorEvent.IO_ERROR,false,false,error.toString()));
               return;
            }
            this._texture.root.onRestore = this.createTextureOnRestore(this._texture,this._source,this._textureFormat,this._scaleFactor);
            if(this._textureCache)
            {
               cacheKey = this.sourceToTextureCacheKey(this._source);
               if(cacheKey !== null)
               {
                  this._textureCache.addTexture(cacheKey,this._texture,true);
               }
            }
         }
         rawData.clear();
         this._isTextureOwner = this._textureCache === null;
         this._isRestoringTexture = false;
         this._isLoaded = true;
         this.invalidate(INVALIDATION_FLAG_DATA);
         this.dispatchEventWith(starling.events.Event.COMPLETE);
      }
      
      protected function addToTextureQueue() : void
      {
         if(!this._delayTextureCreation)
         {
            throw new IllegalOperationError("Cannot add loader to delayed texture queue if delayTextureCreation is false.");
         }
         if(this._textureQueueDuration == Number.POSITIVE_INFINITY)
         {
            throw new IllegalOperationError("Cannot add loader to delayed texture queue if textureQueueDuration is Number.POSITIVE_INFINITY.");
         }
         if(this._isInTextureQueue)
         {
            throw new IllegalOperationError("Cannot add loader to delayed texture queue more than once.");
         }
         this.addEventListener(starling.events.Event.REMOVED_FROM_STAGE,this.imageLoader_removedFromStageHandler);
         this._isInTextureQueue = true;
         if(textureQueueTail)
         {
            textureQueueTail._textureQueueNext = this;
            this._textureQueuePrevious = textureQueueTail;
            textureQueueTail = this;
         }
         else
         {
            textureQueueHead = this;
            textureQueueTail = this;
            this.preparePendingTexture();
         }
      }
      
      protected function removeFromTextureQueue() : void
      {
         if(!this._isInTextureQueue)
         {
            return;
         }
         var _loc1_:ImageLoader = this._textureQueuePrevious;
         var _loc2_:ImageLoader = this._textureQueueNext;
         this._textureQueuePrevious = null;
         this._textureQueueNext = null;
         this._isInTextureQueue = false;
         this.removeEventListener(starling.events.Event.REMOVED_FROM_STAGE,this.imageLoader_removedFromStageHandler);
         this.removeEventListener(EnterFrameEvent.ENTER_FRAME,this.processTextureQueue_enterFrameHandler);
         if(_loc1_)
         {
            _loc1_._textureQueueNext = _loc2_;
         }
         if(_loc2_)
         {
            _loc2_._textureQueuePrevious = _loc1_;
         }
         var _loc3_:Boolean = textureQueueHead == this;
         var _loc4_:Boolean = textureQueueTail == this;
         if(_loc4_)
         {
            textureQueueTail = _loc1_;
            if(_loc3_)
            {
               textureQueueHead = _loc1_;
            }
         }
         if(_loc3_)
         {
            textureQueueHead = _loc2_;
            if(_loc4_)
            {
               textureQueueTail = _loc2_;
            }
         }
         if(_loc3_ && Boolean(textureQueueHead))
         {
            textureQueueHead.preparePendingTexture();
         }
      }
      
      protected function preparePendingTexture() : void
      {
         if(this._textureQueueDuration > 0)
         {
            this._accumulatedPrepareTextureTime = 0;
            this.addEventListener(EnterFrameEvent.ENTER_FRAME,this.processTextureQueue_enterFrameHandler);
         }
         else
         {
            this.processPendingTexture();
         }
      }
      
      protected function processPendingTexture() : void
      {
         var _loc1_:BitmapData = null;
         var _loc2_:ByteArray = null;
         if(this._pendingBitmapDataTexture)
         {
            _loc1_ = this._pendingBitmapDataTexture;
            this._pendingBitmapDataTexture = null;
            this.replaceBitmapDataTexture(_loc1_);
         }
         if(this._pendingRawTextureData)
         {
            _loc2_ = this._pendingRawTextureData;
            this._pendingRawTextureData = null;
            this.replaceRawTextureData(_loc2_);
         }
         if(this._isInTextureQueue)
         {
            this.removeFromTextureQueue();
         }
      }
      
      protected function createTextureOnRestore(param1:Texture, param2:Object, param3:String, param4:Number) : Function
      {
         var texture:Texture = param1;
         var source:Object = param2;
         var format:String = param3;
         var scaleFactor:Number = param4;
         return function():void
         {
            if(_texture === texture)
            {
               texture_onRestore();
               return;
            }
            var _loc1_:* = new ImageLoader();
            _loc1_.source = source;
            _loc1_._texture = texture;
            _loc1_._textureFormat = format;
            _loc1_._scaleFactor = scaleFactor;
            _loc1_.validate();
            _loc1_.addEventListener(starling.events.Event.COMPLETE,onRestore_onComplete);
         };
      }
      
      protected function onRestore_onComplete(param1:starling.events.Event) : void
      {
         var _loc2_:ImageLoader = ImageLoader(param1.currentTarget);
         _loc2_._isTextureOwner = false;
         _loc2_._texture = null;
         _loc2_.dispose();
      }
      
      protected function texture_onRestore() : void
      {
         this._isRestoringTexture = true;
         this._lastURL = null;
         this._isLoaded = false;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      protected function processTextureQueue_enterFrameHandler(param1:EnterFrameEvent) : void
      {
         this._accumulatedPrepareTextureTime += param1.passedTime;
         if(this._accumulatedPrepareTextureTime >= this._textureQueueDuration)
         {
            this.removeEventListener(EnterFrameEvent.ENTER_FRAME,this.processTextureQueue_enterFrameHandler);
            this.processPendingTexture();
         }
      }
      
      protected function imageLoader_removedFromStageHandler(param1:starling.events.Event) : void
      {
         if(this._isInTextureQueue)
         {
            this.removeFromTextureQueue();
         }
      }
      
      protected function loader_completeHandler(param1:flash.events.Event) : void
      {
         var _loc5_:String = null;
         var _loc2_:Bitmap = Bitmap(this.loader.content);
         this.cleanupLoaders(false);
         var _loc3_:BitmapData = _loc2_.bitmapData;
         var _loc4_:Boolean = this._texture !== null && (!Texture.asyncBitmapUploadEnabled || !this._asyncTextureUpload) && this._texture.nativeWidth == _loc3_.width && this._texture.nativeHeight == _loc3_.height && this._texture.scale == this._scaleFactor && this._texture.format == this._textureFormat;
         if(!_loc4_)
         {
            this.cleanupTexture();
            if(this._textureCache)
            {
               _loc5_ = this.sourceToTextureCacheKey(this._source);
               this._textureCache.removeTexture(_loc5_);
            }
         }
         if(this._delayTextureCreation && !this._isRestoringTexture)
         {
            this._pendingBitmapDataTexture = _loc3_;
            if(this._textureQueueDuration < Number.POSITIVE_INFINITY)
            {
               this.addToTextureQueue();
            }
         }
         else
         {
            this.replaceBitmapDataTexture(_loc3_);
         }
      }
      
      protected function loader_progressHandler(param1:ProgressEvent) : void
      {
         this.dispatchEventWith(FeathersEventType.PROGRESS,false,param1.bytesLoaded / param1.bytesTotal);
      }
      
      protected function loader_ioErrorHandler(param1:IOErrorEvent) : void
      {
         this.cleanupLoaders(false);
         this.cleanupTexture();
         this.invalidate(INVALIDATION_FLAG_DATA);
         this.dispatchEventWith(FeathersEventType.ERROR,false,param1);
         this.dispatchEventWith(starling.events.Event.IO_ERROR,false,param1);
      }
      
      protected function loader_securityErrorHandler(param1:SecurityErrorEvent) : void
      {
         this.cleanupLoaders(false);
         this.cleanupTexture();
         this.invalidate(INVALIDATION_FLAG_DATA);
         this.dispatchEventWith(FeathersEventType.ERROR,false,param1);
         this.dispatchEventWith(starling.events.Event.SECURITY_ERROR,false,param1);
      }
      
      protected function orphanedLoader_completeHandler(param1:flash.events.Event) : void
      {
         var _loc2_:LoaderInfo = LoaderInfo(param1.currentTarget);
         _loc2_.removeEventListener(flash.events.Event.COMPLETE,this.orphanedLoader_completeHandler);
         _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.orphanedLoader_errorHandler);
         _loc2_.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.orphanedLoader_errorHandler);
         var _loc3_:Loader = _loc2_.loader;
         var _loc4_:Bitmap = Bitmap(_loc3_.content);
         _loc4_.bitmapData.dispose();
         _loc3_.unload();
      }
      
      protected function orphanedLoader_errorHandler(param1:flash.events.Event) : void
      {
         var _loc2_:LoaderInfo = LoaderInfo(param1.currentTarget);
         _loc2_.removeEventListener(flash.events.Event.COMPLETE,this.orphanedLoader_completeHandler);
         _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.orphanedLoader_errorHandler);
         _loc2_.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.orphanedLoader_errorHandler);
      }
      
      protected function rawDataLoader_completeHandler(param1:flash.events.Event) : void
      {
         var _loc2_:ByteArray = ByteArray(this.urlLoader.data);
         this.cleanupLoaders(false);
         if(!this._isRestoringTexture)
         {
            this.cleanupTexture();
         }
         if(this._delayTextureCreation && !this._isRestoringTexture)
         {
            this._pendingRawTextureData = _loc2_;
            if(this._textureQueueDuration < Number.POSITIVE_INFINITY)
            {
               this.addToTextureQueue();
            }
         }
         else
         {
            this.replaceRawTextureData(_loc2_);
         }
      }
      
      protected function rawDataLoader_progressHandler(param1:ProgressEvent) : void
      {
         this.dispatchEventWith(FeathersEventType.PROGRESS,false,param1.bytesLoaded / param1.bytesTotal);
      }
      
      protected function rawDataLoader_ioErrorHandler(param1:ErrorEvent) : void
      {
         this.cleanupLoaders(false);
         this.cleanupTexture();
         this.invalidate(INVALIDATION_FLAG_DATA);
         this.dispatchEventWith(FeathersEventType.ERROR,false,param1);
         this.dispatchEventWith(starling.events.Event.IO_ERROR,false,param1);
      }
      
      protected function rawDataLoader_securityErrorHandler(param1:ErrorEvent) : void
      {
         this.cleanupLoaders(false);
         this.cleanupTexture();
         this.invalidate(INVALIDATION_FLAG_DATA);
         this.dispatchEventWith(FeathersEventType.ERROR,false,param1);
         this.dispatchEventWith(starling.events.Event.SECURITY_ERROR,false,param1);
      }
   }
}

