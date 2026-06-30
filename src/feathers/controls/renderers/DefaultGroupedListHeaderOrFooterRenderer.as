package feathers.controls.renderers
{
   import feathers.controls.GroupedList;
   import feathers.controls.ImageLoader;
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.ITextRenderer;
   import feathers.core.IValidating;
   import feathers.core.PropertyProxy;
   import feathers.layout.HorizontalAlign;
   import feathers.layout.VerticalAlign;
   import feathers.skins.IStyleProvider;
   import feathers.text.FontStylesSet;
   import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;
   import flash.geom.Point;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import starling.text.TextFormat;
   
   public class DefaultGroupedListHeaderOrFooterRenderer extends FeathersControl implements IGroupedListHeaderRenderer, IGroupedListFooterRenderer
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      public static const DEFAULT_CHILD_STYLE_NAME_CONTENT_LABEL:String = "feathers-header-footer-renderer-content-label";
      
      private static const HELPER_POINT:Point = new Point();
      
      protected var contentLabelStyleName:String = "feathers-header-footer-renderer-content-label";
      
      protected var contentImage:ImageLoader;
      
      protected var contentLabel:ITextRenderer;
      
      protected var content:DisplayObject;
      
      protected var _data:Object;
      
      protected var _groupIndex:int = -1;
      
      protected var _layoutIndex:int = -1;
      
      protected var _owner:GroupedList;
      
      protected var _factoryID:String;
      
      protected var _horizontalAlign:String = "left";
      
      protected var _verticalAlign:String = "middle";
      
      protected var _contentField:String = "content";
      
      protected var _contentFunction:Function;
      
      protected var _contentSourceField:String = "source";
      
      protected var _contentSourceFunction:Function;
      
      protected var _contentLabelField:String = "label";
      
      protected var _contentLabelFunction:Function;
      
      protected var _contentLoaderFactory:Function = defaultImageLoaderFactory;
      
      protected var _fontStylesSet:FontStylesSet;
      
      private var _wordWrap:Boolean = false;
      
      protected var _contentLabelFactory:Function;
      
      protected var _customContentLabelStyleName:String;
      
      protected var _contentLabelProperties:PropertyProxy;
      
      protected var _explicitBackgroundWidth:Number;
      
      protected var _explicitBackgroundHeight:Number;
      
      protected var _explicitBackgroundMinWidth:Number;
      
      protected var _explicitBackgroundMinHeight:Number;
      
      protected var _explicitBackgroundMaxWidth:Number;
      
      protected var _explicitBackgroundMaxHeight:Number;
      
      protected var _explicitContentWidth:Number;
      
      protected var _explicitContentHeight:Number;
      
      protected var _explicitContentMinWidth:Number;
      
      protected var _explicitContentMinHeight:Number;
      
      protected var _explicitContentMaxWidth:Number;
      
      protected var _explicitContentMaxHeight:Number;
      
      protected var currentBackgroundSkin:DisplayObject;
      
      protected var _backgroundSkin:DisplayObject;
      
      protected var _backgroundDisabledSkin:DisplayObject;
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      public function DefaultGroupedListHeaderOrFooterRenderer()
      {
         super();
         if(this._fontStylesSet === null)
         {
            this._fontStylesSet = new FontStylesSet();
            this._fontStylesSet.addEventListener(Event.CHANGE,this.fontStyles_changeHandler);
         }
      }
      
      protected static function defaultImageLoaderFactory() : ImageLoader
      {
         return new ImageLoader();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return DefaultGroupedListHeaderOrFooterRenderer.globalStyleProvider;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(param1:Object) : void
      {
         if(this._data == param1)
         {
            return;
         }
         this._data = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get groupIndex() : int
      {
         return this._groupIndex;
      }
      
      public function set groupIndex(param1:int) : void
      {
         this._groupIndex = param1;
      }
      
      public function get layoutIndex() : int
      {
         return this._layoutIndex;
      }
      
      public function set layoutIndex(param1:int) : void
      {
         this._layoutIndex = param1;
      }
      
      public function get owner() : GroupedList
      {
         return this._owner;
      }
      
      public function set owner(param1:GroupedList) : void
      {
         if(this._owner == param1)
         {
            return;
         }
         this._owner = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get factoryID() : String
      {
         return this._factoryID;
      }
      
      public function set factoryID(param1:String) : void
      {
         this._factoryID = param1;
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
      
      public function get contentField() : String
      {
         return this._contentField;
      }
      
      public function set contentField(param1:String) : void
      {
         if(this._contentField == param1)
         {
            return;
         }
         this._contentField = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get contentFunction() : Function
      {
         return this._contentFunction;
      }
      
      public function set contentFunction(param1:Function) : void
      {
         if(this._contentFunction == param1)
         {
            return;
         }
         this._contentFunction = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get contentSourceField() : String
      {
         return this._contentSourceField;
      }
      
      public function set contentSourceField(param1:String) : void
      {
         if(this._contentSourceField == param1)
         {
            return;
         }
         this._contentSourceField = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get contentSourceFunction() : Function
      {
         return this._contentSourceFunction;
      }
      
      public function set contentSourceFunction(param1:Function) : void
      {
         if(this.contentSourceFunction == param1)
         {
            return;
         }
         this._contentSourceFunction = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get contentLabelField() : String
      {
         return this._contentLabelField;
      }
      
      public function set contentLabelField(param1:String) : void
      {
         if(this._contentLabelField == param1)
         {
            return;
         }
         this._contentLabelField = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get contentLabelFunction() : Function
      {
         return this._contentLabelFunction;
      }
      
      public function set contentLabelFunction(param1:Function) : void
      {
         if(this._contentLabelFunction == param1)
         {
            return;
         }
         this._contentLabelFunction = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get contentLoaderFactory() : Function
      {
         return this._contentLoaderFactory;
      }
      
      public function set contentLoaderFactory(param1:Function) : void
      {
         if(this._contentLoaderFactory == param1)
         {
            return;
         }
         this._contentLoaderFactory = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get fontStyles() : TextFormat
      {
         return this._fontStylesSet.format;
      }
      
      public function set fontStyles(param1:TextFormat) : void
      {
         var savedCallee:Function = null;
         var changeHandler:Function = null;
         var value:TextFormat = param1;
         changeHandler = function(param1:Event):void
         {
            processStyleRestriction(savedCallee);
         };
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         savedCallee = arguments.callee;
         if(value !== null)
         {
            value.removeEventListener(Event.CHANGE,changeHandler);
         }
         this._fontStylesSet.format = value;
         if(value !== null)
         {
            value.addEventListener(Event.CHANGE,changeHandler);
         }
      }
      
      public function get disabledFontStyles() : TextFormat
      {
         return this._fontStylesSet.disabledFormat;
      }
      
      public function set disabledFontStyles(param1:TextFormat) : void
      {
         var savedCallee:Function = null;
         var changeHandler:Function = null;
         var value:TextFormat = param1;
         changeHandler = function(param1:Event):void
         {
            processStyleRestriction(savedCallee);
         };
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         savedCallee = arguments.callee;
         if(value !== null)
         {
            value.removeEventListener(Event.CHANGE,changeHandler);
         }
         this._fontStylesSet.disabledFormat = value;
         if(value !== null)
         {
            value.addEventListener(Event.CHANGE,changeHandler);
         }
      }
      
      public function get wordWrap() : Boolean
      {
         return this._wordWrap;
      }
      
      public function set wordWrap(param1:Boolean) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         this._wordWrap = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get contentLabelFactory() : Function
      {
         return this._contentLabelFactory;
      }
      
      public function set contentLabelFactory(param1:Function) : void
      {
         if(this._contentLabelFactory == param1)
         {
            return;
         }
         this._contentLabelFactory = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get customContentLabelStyleName() : String
      {
         return this._customContentLabelStyleName;
      }
      
      public function set customContentLabelStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customContentLabelStyleName === param1)
         {
            return;
         }
         this._customContentLabelStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
      }
      
      public function get contentLabelProperties() : Object
      {
         if(!this._contentLabelProperties)
         {
            this._contentLabelProperties = new PropertyProxy(this.contentLabelProperties_onChange);
         }
         return this._contentLabelProperties;
      }
      
      public function set contentLabelProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         var _loc3_:String = null;
         if(this._contentLabelProperties == param1)
         {
            return;
         }
         if(!param1)
         {
            param1 = new PropertyProxy();
         }
         if(!(param1 is PropertyProxy))
         {
            _loc2_ = new PropertyProxy();
            for(_loc3_ in param1)
            {
               _loc2_[_loc3_] = param1[_loc3_];
            }
            param1 = _loc2_;
         }
         if(this._contentLabelProperties)
         {
            this._contentLabelProperties.removeOnChangeCallback(this.contentLabelProperties_onChange);
         }
         this._contentLabelProperties = PropertyProxy(param1);
         if(this._contentLabelProperties)
         {
            this._contentLabelProperties.addOnChangeCallback(this.contentLabelProperties_onChange);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
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
         if(this._backgroundSkin !== null && this.currentBackgroundSkin === this._backgroundSkin)
         {
            this.removeCurrentBackgroundSkin(this._backgroundSkin);
            this.currentBackgroundSkin = null;
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
         if(this._backgroundDisabledSkin !== null && this.currentBackgroundSkin === this._backgroundDisabledSkin)
         {
            this.removeCurrentBackgroundSkin(this._backgroundDisabledSkin);
            this.currentBackgroundSkin = null;
         }
         this._backgroundDisabledSkin = param1;
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
      
      public function get numLines() : int
      {
         if(this.contentLabel === null)
         {
            return 0;
         }
         return this.contentLabel.numLines;
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
         if(this.content)
         {
            this.content.removeFromParent();
         }
         if(this.contentImage)
         {
            this.contentImage.dispose();
            this.contentImage = null;
         }
         if(this.contentLabel)
         {
            DisplayObject(this.contentLabel).dispose();
            this.contentLabel = null;
         }
         if(this._fontStylesSet !== null)
         {
            this._fontStylesSet.dispose();
            this._fontStylesSet = null;
         }
         super.dispose();
      }
      
      protected function itemToContent(param1:Object) : DisplayObject
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         if(this._contentSourceFunction != null)
         {
            _loc2_ = this._contentSourceFunction(param1);
            this.refreshContentSource(_loc2_);
            return this.contentImage;
         }
         if(Boolean(this._contentSourceField != null) && Boolean(param1) && param1.hasOwnProperty(this._contentSourceField))
         {
            _loc2_ = param1[this._contentSourceField];
            this.refreshContentSource(_loc2_);
            return this.contentImage;
         }
         if(this._contentLabelFunction != null)
         {
            _loc3_ = this._contentLabelFunction(param1);
            if(_loc3_ is String)
            {
               this.refreshContentLabel(_loc3_ as String);
            }
            else if(_loc3_ !== null)
            {
               this.refreshContentLabel(_loc3_.toString());
            }
            else
            {
               this.refreshContentLabel(null);
            }
            return DisplayObject(this.contentLabel);
         }
         if(Boolean(this._contentLabelField != null) && Boolean(param1) && param1.hasOwnProperty(this._contentLabelField))
         {
            _loc3_ = param1[this._contentLabelField];
            if(_loc3_ is String)
            {
               this.refreshContentLabel(_loc3_ as String);
            }
            else if(_loc3_ !== null)
            {
               this.refreshContentLabel(_loc3_.toString());
            }
            else
            {
               this.refreshContentLabel(null);
            }
            return DisplayObject(this.contentLabel);
         }
         if(this._contentFunction != null)
         {
            return this._contentFunction(param1) as DisplayObject;
         }
         if(Boolean(this._contentField != null) && Boolean(param1) && param1.hasOwnProperty(this._contentField))
         {
            return param1[this._contentField] as DisplayObject;
         }
         if(param1 is String)
         {
            this.refreshContentLabel(param1 as String);
            return DisplayObject(this.contentLabel);
         }
         if(param1 !== null)
         {
            this.refreshContentLabel(param1.toString());
            return DisplayObject(this.contentLabel);
         }
         this.refreshContentLabel(null);
         return null;
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         var _loc4_:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
         if(_loc2_ || _loc3_)
         {
            this.refreshBackgroundSkin();
         }
         if(_loc1_)
         {
            this.commitData();
         }
         if(_loc1_ || _loc2_)
         {
            this.refreshContentLabelStyles();
         }
         if(_loc1_ || _loc3_)
         {
            this.refreshEnabled();
         }
         _loc4_ = this.autoSizeIfNeeded() || _loc4_;
         this.layoutChildren();
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc11_:Number = NaN;
         var _loc1_:Boolean = this._explicitWidth !== this._explicitWidth;
         var _loc2_:Boolean = this._explicitHeight !== this._explicitHeight;
         var _loc3_:Boolean = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc4_:Boolean = this._explicitMinHeight !== this._explicitMinHeight;
         if(!_loc1_ && !_loc2_ && !_loc3_ && !_loc4_)
         {
            return false;
         }
         var _loc5_:IMeasureDisplayObject = this.content as IMeasureDisplayObject;
         if(this.contentLabel !== null)
         {
            _loc11_ = this._explicitWidth;
            if(_loc1_)
            {
               _loc11_ = this._explicitMaxWidth;
            }
            this.contentLabel.maxWidth = _loc11_ - this._paddingLeft - this._paddingRight;
            this.contentLabel.measureText(HELPER_POINT);
         }
         else if(this.content !== null)
         {
            if(this._horizontalAlign === HorizontalAlign.JUSTIFY && this._verticalAlign === VerticalAlign.JUSTIFY)
            {
               resetFluidChildDimensionsForMeasurement(this.content,this._explicitWidth - this._paddingLeft - this._paddingRight,this._explicitHeight - this._paddingTop - this._paddingBottom,this._explicitMinWidth - this._paddingLeft - this._paddingRight,this._explicitMinHeight - this._paddingTop - this._paddingBottom,this._explicitMaxWidth - this._paddingLeft - this._paddingRight,this._explicitMaxHeight - this._paddingTop - this._paddingBottom,this._explicitContentWidth,this._explicitContentHeight,this._explicitContentMinWidth,this._explicitContentMinHeight,this._explicitContentMaxWidth,this._explicitContentMaxHeight);
            }
            else
            {
               this.content.width = this._explicitContentWidth;
               this.content.height = this._explicitContentHeight;
               if(_loc5_ !== null)
               {
                  _loc5_.minWidth = this._explicitContentMinWidth;
                  _loc5_.minHeight = this._explicitContentMinHeight;
               }
            }
            if(this.content is IValidating)
            {
               IValidating(this.content).validate();
            }
         }
         resetFluidChildDimensionsForMeasurement(this.currentBackgroundSkin,this._explicitWidth,this._explicitHeight,this._explicitMinWidth,this._explicitMinHeight,this._explicitMaxWidth,this._explicitMaxHeight,this._explicitBackgroundWidth,this._explicitBackgroundHeight,this._explicitBackgroundMinWidth,this._explicitBackgroundMinHeight,this._explicitBackgroundMaxWidth,this._explicitBackgroundMaxHeight);
         var _loc6_:IMeasureDisplayObject = this.currentBackgroundSkin as IMeasureDisplayObject;
         var _loc7_:Number = this._explicitWidth;
         if(_loc1_)
         {
            if(this.contentLabel !== null)
            {
               _loc7_ = HELPER_POINT.x;
            }
            else if(this.content !== null)
            {
               _loc7_ = this.content.width;
            }
            else
            {
               _loc7_ = 0;
            }
            _loc7_ += this._paddingLeft + this._paddingRight;
            if(this.currentBackgroundSkin !== null && this.currentBackgroundSkin.width > _loc7_)
            {
               _loc7_ = this.currentBackgroundSkin.width;
            }
         }
         var _loc8_:Number = this._explicitHeight;
         if(_loc2_)
         {
            if(this.contentLabel !== null)
            {
               _loc8_ = HELPER_POINT.y;
            }
            else if(this.content !== null)
            {
               _loc8_ = this.content.height;
            }
            else
            {
               _loc8_ = 0;
            }
            _loc8_ += this._paddingTop + this._paddingBottom;
            if(this.currentBackgroundSkin !== null && this.currentBackgroundSkin.height > _loc8_)
            {
               _loc8_ = this.currentBackgroundSkin.height;
            }
         }
         var _loc9_:Number = this._explicitMinWidth;
         if(_loc3_)
         {
            if(this.contentLabel !== null)
            {
               _loc9_ = HELPER_POINT.x;
            }
            else if(_loc5_ !== null)
            {
               _loc9_ = _loc5_.minWidth;
            }
            else if(this.content !== null)
            {
               _loc9_ = this.content.width;
            }
            else
            {
               _loc9_ = 0;
            }
            _loc9_ += this._paddingLeft + this._paddingRight;
            if(this.currentBackgroundSkin !== null)
            {
               if(_loc6_ !== null)
               {
                  if(_loc6_.minWidth > _loc9_)
                  {
                     _loc9_ = _loc6_.minWidth;
                  }
               }
               else if(this._explicitBackgroundMinWidth > _loc9_)
               {
                  _loc9_ = this._explicitBackgroundMinWidth;
               }
            }
         }
         var _loc10_:Number = this._explicitMinHeight;
         if(_loc4_)
         {
            if(this.contentLabel !== null)
            {
               _loc10_ = HELPER_POINT.y;
            }
            else if(_loc5_ !== null)
            {
               _loc10_ = _loc5_.minHeight;
            }
            else if(this.content !== null)
            {
               _loc10_ = this.content.height;
            }
            else
            {
               _loc10_ = 0;
            }
            _loc10_ += this._paddingTop + this._paddingBottom;
            if(this.currentBackgroundSkin !== null)
            {
               if(_loc6_ !== null)
               {
                  if(_loc6_.minHeight > _loc10_)
                  {
                     _loc10_ = _loc6_.minHeight;
                  }
               }
               else if(this._explicitBackgroundMinHeight > _loc10_)
               {
                  _loc10_ = this._explicitBackgroundMinHeight;
               }
            }
         }
         return this.saveMeasurements(_loc7_,_loc8_,_loc9_,_loc10_);
      }
      
      protected function refreshBackgroundSkin() : void
      {
         var _loc2_:IMeasureDisplayObject = null;
         var _loc1_:DisplayObject = this.currentBackgroundSkin;
         this.currentBackgroundSkin = this._backgroundSkin;
         if(!this._isEnabled && this._backgroundDisabledSkin !== null)
         {
            this.currentBackgroundSkin = this._backgroundDisabledSkin;
         }
         if(_loc1_ !== this.currentBackgroundSkin)
         {
            this.removeCurrentBackgroundSkin(_loc1_);
            if(this.currentBackgroundSkin !== null)
            {
               if(this.currentBackgroundSkin is IFeathersControl)
               {
                  IFeathersControl(this.currentBackgroundSkin).initializeNow();
               }
               if(this.currentBackgroundSkin is IMeasureDisplayObject)
               {
                  _loc2_ = IMeasureDisplayObject(this.currentBackgroundSkin);
                  this._explicitBackgroundWidth = _loc2_.explicitWidth;
                  this._explicitBackgroundHeight = _loc2_.explicitHeight;
                  this._explicitBackgroundMinWidth = _loc2_.explicitMinWidth;
                  this._explicitBackgroundMinHeight = _loc2_.explicitMinHeight;
                  this._explicitBackgroundMaxWidth = _loc2_.explicitMaxWidth;
                  this._explicitBackgroundMaxHeight = _loc2_.explicitMaxHeight;
               }
               else
               {
                  this._explicitBackgroundWidth = this.currentBackgroundSkin.width;
                  this._explicitBackgroundHeight = this.currentBackgroundSkin.height;
                  this._explicitBackgroundMinWidth = this._explicitBackgroundWidth;
                  this._explicitBackgroundMinHeight = this._explicitBackgroundHeight;
                  this._explicitBackgroundMaxWidth = this._explicitBackgroundWidth;
                  this._explicitBackgroundMaxHeight = this._explicitBackgroundHeight;
               }
               this.addChildAt(this.currentBackgroundSkin,0);
            }
         }
      }
      
      protected function removeCurrentBackgroundSkin(param1:DisplayObject) : void
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
      
      protected function commitData() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:IMeasureDisplayObject = null;
         if(this._owner)
         {
            _loc1_ = this.itemToContent(this._data);
            if(_loc1_ !== this.content)
            {
               if(this.content !== null)
               {
                  this.content.removeFromParent();
               }
               this.content = _loc1_;
               if(this.content !== null)
               {
                  this.addChild(this.content);
                  if(this.content is IFeathersControl)
                  {
                     IFeathersControl(this.content).initializeNow();
                  }
                  if(this.content is IMeasureDisplayObject)
                  {
                     _loc2_ = IMeasureDisplayObject(this.content);
                     this._explicitContentWidth = _loc2_.explicitWidth;
                     this._explicitContentHeight = _loc2_.explicitHeight;
                     this._explicitContentMinWidth = _loc2_.explicitMinWidth;
                     this._explicitContentMinHeight = _loc2_.explicitMinHeight;
                     this._explicitContentMaxWidth = _loc2_.explicitMaxWidth;
                     this._explicitContentMaxHeight = _loc2_.explicitMaxHeight;
                  }
                  else
                  {
                     this._explicitContentWidth = this.content.width;
                     this._explicitContentHeight = this.content.height;
                     this._explicitContentMinWidth = this._explicitContentWidth;
                     this._explicitContentMinHeight = this._explicitContentHeight;
                     this._explicitContentMaxWidth = this._explicitContentWidth;
                     this._explicitContentMaxHeight = this._explicitContentHeight;
                  }
               }
            }
         }
         else if(this.content)
         {
            this.content.removeFromParent();
            this.content = null;
         }
      }
      
      protected function refreshContentSource(param1:Object) : void
      {
         if(!this.contentImage)
         {
            this.contentImage = this._contentLoaderFactory();
         }
         this.contentImage.source = param1;
      }
      
      protected function refreshContentLabel(param1:String) : void
      {
         var _loc2_:Function = null;
         var _loc3_:String = null;
         if(param1 !== null)
         {
            if(this.contentLabel === null)
            {
               _loc2_ = this._contentLabelFactory != null ? this._contentLabelFactory : FeathersControl.defaultTextRendererFactory;
               this.contentLabel = ITextRenderer(_loc2_());
               _loc3_ = this._customContentLabelStyleName != null ? this._customContentLabelStyleName : this.contentLabelStyleName;
               FeathersControl(this.contentLabel).styleNameList.add(_loc3_);
            }
            this.contentLabel.text = param1;
         }
         else if(this.contentLabel !== null)
         {
            DisplayObject(this.contentLabel).removeFromParent(true);
            this.contentLabel = null;
         }
      }
      
      protected function refreshEnabled() : void
      {
         if(this.content is IFeathersControl)
         {
            IFeathersControl(this.content).isEnabled = this._isEnabled;
         }
      }
      
      protected function refreshContentLabelStyles() : void
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         if(this.contentLabel === null)
         {
            return;
         }
         this.contentLabel.fontStyles = this._fontStylesSet;
         this.contentLabel.wordWrap = this._wordWrap;
         for(_loc1_ in this._contentLabelProperties)
         {
            _loc2_ = this._contentLabelProperties[_loc1_];
            this.contentLabel[_loc1_] = _loc2_;
         }
      }
      
      protected function layoutChildren() : void
      {
         if(this.currentBackgroundSkin !== null)
         {
            this.currentBackgroundSkin.width = this.actualWidth;
            this.currentBackgroundSkin.height = this.actualHeight;
         }
         if(this.content === null)
         {
            return;
         }
         if(this.contentLabel !== null)
         {
            this.contentLabel.maxWidth = this.actualWidth - this._paddingLeft - this._paddingRight;
         }
         if(this.content is IValidating)
         {
            IValidating(this.content).validate();
         }
         switch(this._horizontalAlign)
         {
            case HorizontalAlign.CENTER:
               this.content.x = this._paddingLeft + (this.actualWidth - this._paddingLeft - this._paddingRight - this.content.width) / 2;
               break;
            case HorizontalAlign.RIGHT:
               this.content.x = this.actualWidth - this._paddingRight - this.content.width;
               break;
            case HorizontalAlign.JUSTIFY:
               this.content.x = this._paddingLeft;
               this.content.width = this.actualWidth - this._paddingLeft - this._paddingRight;
               break;
            default:
               this.content.x = this._paddingLeft;
         }
         switch(this._verticalAlign)
         {
            case VerticalAlign.TOP:
               this.content.y = this._paddingTop;
               break;
            case VerticalAlign.BOTTOM:
               this.content.y = this.actualHeight - this._paddingBottom - this.content.height;
               break;
            case VerticalAlign.JUSTIFY:
               this.content.y = this._paddingTop;
               this.content.height = this.actualHeight - this._paddingTop - this._paddingBottom;
               break;
            default:
               this.content.y = this._paddingTop + (this.actualHeight - this._paddingTop - this._paddingBottom - this.content.height) / 2;
         }
      }
      
      protected function fontStyles_changeHandler(param1:Event) : void
      {
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      protected function contentLabelProperties_onChange(param1:PropertyProxy, param2:String) : void
      {
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
   }
}

