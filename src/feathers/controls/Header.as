package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.ITextRenderer;
   import feathers.core.IValidating;
   import feathers.core.PropertyProxy;
   import feathers.events.FeathersEventType;
   import feathers.layout.HorizontalAlign;
   import feathers.layout.HorizontalLayout;
   import feathers.layout.LayoutBoundsResult;
   import feathers.layout.VerticalAlign;
   import feathers.layout.ViewPortBounds;
   import feathers.skins.IStyleProvider;
   import feathers.system.DeviceCapabilities;
   import feathers.text.FontStylesSet;
   import feathers.utils.display.ScreenDensityScaleCalculator;
   import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;
   import flash.display.Stage;
   import flash.display.StageDisplayState;
   import flash.events.FullScreenEvent;
   import flash.geom.Point;
   import flash.system.Capabilities;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import starling.text.TextFormat;
   import starling.utils.Pool;
   
   public class Header extends FeathersControl
   {
      
      protected static var iOSStatusBarScaledHeight:Number;
      
      public static var globalStyleProvider:IStyleProvider;
      
      protected static const INVALIDATION_FLAG_LEFT_CONTENT:String = "leftContent";
      
      protected static const INVALIDATION_FLAG_RIGHT_CONTENT:String = "rightContent";
      
      protected static const INVALIDATION_FLAG_CENTER_CONTENT:String = "centerContent";
      
      protected static const IOS_STATUS_BAR_HEIGHT:Number = 20;
      
      protected static const IOS_NOTCH_STATUS_BAR_HEIGHT:Number = 44;
      
      protected static const IOS_NAME_PREFIX:String = "iOS ";
      
      protected static const OLD_IOS_NAME_PREFIX:String = "iPhone OS ";
      
      protected static const STATUS_BAR_MIN_IOS_VERSION:int = 7;
      
      public static const DEFAULT_CHILD_STYLE_NAME_ITEM:String = "feathers-header-item";
      
      public static const DEFAULT_CHILD_STYLE_NAME_TITLE:String = "feathers-header-title";
      
      private static const HELPER_BOUNDS:ViewPortBounds = new ViewPortBounds();
      
      private static const HELPER_LAYOUT_RESULT:LayoutBoundsResult = new LayoutBoundsResult();
      
      protected var titleTextRenderer:ITextRenderer;
      
      protected var titleStyleName:String = "feathers-header-title";
      
      protected var itemStyleName:String = "feathers-header-item";
      
      protected var leftItemsWidth:Number = 0;
      
      protected var rightItemsWidth:Number = 0;
      
      protected var _layout:HorizontalLayout;
      
      protected var _title:String = null;
      
      protected var _titleFactory:Function;
      
      protected var _disposeItems:Boolean = true;
      
      protected var _ignoreItemResizing:Boolean = false;
      
      protected var _leftItems:Vector.<DisplayObject>;
      
      protected var _centerItems:Vector.<DisplayObject>;
      
      protected var _rightItems:Vector.<DisplayObject>;
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var _gap:Number = 0;
      
      protected var _titleGap:Number = NaN;
      
      protected var _useExtraPaddingForOSStatusBar:Boolean = false;
      
      protected var _verticalAlign:String = "middle";
      
      protected var currentBackgroundSkin:DisplayObject;
      
      protected var _explicitBackgroundWidth:Number;
      
      protected var _explicitBackgroundHeight:Number;
      
      protected var _explicitBackgroundMinWidth:Number;
      
      protected var _explicitBackgroundMinHeight:Number;
      
      protected var _explicitBackgroundMaxWidth:Number;
      
      protected var _explicitBackgroundMaxHeight:Number;
      
      protected var _backgroundSkin:DisplayObject;
      
      protected var _backgroundDisabledSkin:DisplayObject;
      
      protected var _fontStylesSet:FontStylesSet;
      
      protected var _wordWrap:Boolean = false;
      
      protected var _customTitleStyleName:String;
      
      protected var _titleProperties:PropertyProxy;
      
      protected var _titleAlign:String = "center";
      
      public function Header()
      {
         super();
         if(this._fontStylesSet === null)
         {
            this._fontStylesSet = new FontStylesSet();
            this._fontStylesSet.addEventListener(Event.CHANGE,this.fontStyles_changeHandler);
         }
         this.addEventListener(Event.ADDED_TO_STAGE,this.header_addedToStageHandler);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.header_removedFromStageHandler);
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return Header.globalStyleProvider;
      }
      
      public function get title() : String
      {
         return this._title;
      }
      
      public function set title(param1:String) : void
      {
         if(this._title === param1)
         {
            return;
         }
         this._title = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get titleFactory() : Function
      {
         return this._titleFactory;
      }
      
      public function set titleFactory(param1:Function) : void
      {
         if(this._titleFactory == param1)
         {
            return;
         }
         this._titleFactory = param1;
         this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
      }
      
      public function get disposeItems() : Boolean
      {
         return this._disposeItems;
      }
      
      public function set disposeItems(param1:Boolean) : void
      {
         this._disposeItems = param1;
      }
      
      public function get leftItems() : Vector.<DisplayObject>
      {
         return this._leftItems;
      }
      
      public function set leftItems(param1:Vector.<DisplayObject>) : void
      {
         var _loc2_:DisplayObject = null;
         if(this._leftItems == param1)
         {
            return;
         }
         if(this._leftItems)
         {
            for each(_loc2_ in this._leftItems)
            {
               if(_loc2_ is IFeathersControl)
               {
                  IFeathersControl(_loc2_).styleNameList.remove(this.itemStyleName);
                  _loc2_.removeEventListener(FeathersEventType.RESIZE,this.item_resizeHandler);
               }
               _loc2_.removeFromParent();
            }
         }
         this._leftItems = param1;
         if(this._leftItems)
         {
            for each(_loc2_ in this._leftItems)
            {
               if(_loc2_ is IFeathersControl)
               {
                  _loc2_.addEventListener(FeathersEventType.RESIZE,this.item_resizeHandler);
               }
            }
         }
         this.invalidate(INVALIDATION_FLAG_LEFT_CONTENT);
      }
      
      public function get centerItems() : Vector.<DisplayObject>
      {
         return this._centerItems;
      }
      
      public function set centerItems(param1:Vector.<DisplayObject>) : void
      {
         var _loc2_:DisplayObject = null;
         if(this._centerItems == param1)
         {
            return;
         }
         if(this._centerItems)
         {
            for each(_loc2_ in this._centerItems)
            {
               if(_loc2_ is IFeathersControl)
               {
                  IFeathersControl(_loc2_).styleNameList.remove(this.itemStyleName);
                  _loc2_.removeEventListener(FeathersEventType.RESIZE,this.item_resizeHandler);
               }
               _loc2_.removeFromParent();
            }
         }
         this._centerItems = param1;
         if(this._centerItems)
         {
            for each(_loc2_ in this._centerItems)
            {
               if(_loc2_ is IFeathersControl)
               {
                  _loc2_.addEventListener(FeathersEventType.RESIZE,this.item_resizeHandler);
               }
            }
         }
         this.invalidate(INVALIDATION_FLAG_CENTER_CONTENT);
      }
      
      public function get rightItems() : Vector.<DisplayObject>
      {
         return this._rightItems;
      }
      
      public function set rightItems(param1:Vector.<DisplayObject>) : void
      {
         var _loc2_:DisplayObject = null;
         if(this._rightItems == param1)
         {
            return;
         }
         if(this._rightItems)
         {
            for each(_loc2_ in this._rightItems)
            {
               if(_loc2_ is IFeathersControl)
               {
                  IFeathersControl(_loc2_).styleNameList.remove(this.itemStyleName);
                  _loc2_.removeEventListener(FeathersEventType.RESIZE,this.item_resizeHandler);
               }
               _loc2_.removeFromParent();
            }
         }
         this._rightItems = param1;
         if(this._rightItems)
         {
            for each(_loc2_ in this._rightItems)
            {
               if(_loc2_ is IFeathersControl)
               {
                  _loc2_.addEventListener(FeathersEventType.RESIZE,this.item_resizeHandler);
               }
            }
         }
         this.invalidate(INVALIDATION_FLAG_RIGHT_CONTENT);
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
      
      public function get gap() : Number
      {
         return this._gap;
      }
      
      public function set gap(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._gap == param1)
         {
            return;
         }
         this._gap = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get titleGap() : Number
      {
         return this._titleGap;
      }
      
      public function set titleGap(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._titleGap == param1)
         {
            return;
         }
         this._titleGap = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get useExtraPaddingForOSStatusBar() : Boolean
      {
         return this._useExtraPaddingForOSStatusBar;
      }
      
      public function set useExtraPaddingForOSStatusBar(param1:Boolean) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._useExtraPaddingForOSStatusBar === param1)
         {
            return;
         }
         this._useExtraPaddingForOSStatusBar = param1;
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
         if(this._wordWrap === param1)
         {
            return;
         }
         this._wordWrap = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get customTitleStyleName() : String
      {
         return this._customTitleStyleName;
      }
      
      public function set customTitleStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customTitleStyleName === param1)
         {
            return;
         }
         this._customTitleStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
      }
      
      public function get titleProperties() : Object
      {
         if(!this._titleProperties)
         {
            this._titleProperties = new PropertyProxy(this.titleProperties_onChange);
         }
         return this._titleProperties;
      }
      
      public function set titleProperties(param1:Object) : void
      {
         if(this._titleProperties == param1)
         {
            return;
         }
         if(Boolean(param1) && !(param1 is PropertyProxy))
         {
            param1 = PropertyProxy.fromObject(param1);
         }
         if(this._titleProperties)
         {
            this._titleProperties.removeOnChangeCallback(this.titleProperties_onChange);
         }
         this._titleProperties = PropertyProxy(param1);
         if(this._titleProperties)
         {
            this._titleProperties.addOnChangeCallback(this.titleProperties_onChange);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get titleAlign() : String
      {
         return this._titleAlign;
      }
      
      public function set titleAlign(param1:String) : void
      {
         switch(param1)
         {
            case "preferLeft":
               param1 = HorizontalAlign.LEFT;
               break;
            case "preferRight":
               param1 = HorizontalAlign.RIGHT;
         }
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._titleAlign === param1)
         {
            return;
         }
         this._titleAlign = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get numLines() : int
      {
         if(this.titleTextRenderer === null)
         {
            return 0;
         }
         return this.titleTextRenderer.numLines;
      }
      
      override public function dispose() : void
      {
         var _loc1_:DisplayObject = null;
         if(this._backgroundSkin !== null && this._backgroundSkin.parent !== this)
         {
            this._backgroundSkin.dispose();
         }
         if(this._backgroundDisabledSkin !== null && this._backgroundDisabledSkin.parent !== this)
         {
            this._backgroundDisabledSkin.dispose();
         }
         if(this._disposeItems)
         {
            for each(_loc1_ in this._leftItems)
            {
               _loc1_.dispose();
            }
            for each(_loc1_ in this._centerItems)
            {
               _loc1_.dispose();
            }
            for each(_loc1_ in this._rightItems)
            {
               _loc1_.dispose();
            }
         }
         this.leftItems = null;
         this.rightItems = null;
         this.centerItems = null;
         if(this._fontStylesSet !== null)
         {
            this._fontStylesSet.dispose();
            this._fontStylesSet = null;
         }
         super.dispose();
      }
      
      override protected function initialize() : void
      {
         var _loc1_:HorizontalLayout = null;
         if(this._layout === null)
         {
            _loc1_ = new HorizontalLayout();
            _loc1_.useVirtualLayout = false;
            _loc1_.verticalAlign = VerticalAlign.MIDDLE;
            this._layout = _loc1_;
         }
      }
      
      override protected function draw() : void
      {
         var _loc10_:DisplayObject = null;
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc4_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         var _loc5_:Boolean = this.isInvalid(INVALIDATION_FLAG_LEFT_CONTENT);
         var _loc6_:Boolean = this.isInvalid(INVALIDATION_FLAG_RIGHT_CONTENT);
         var _loc7_:Boolean = this.isInvalid(INVALIDATION_FLAG_CENTER_CONTENT);
         var _loc8_:Boolean = this.isInvalid(INVALIDATION_FLAG_TEXT_RENDERER);
         if(_loc8_)
         {
            this.createTitle();
         }
         if(_loc8_ || _loc2_)
         {
            this.titleTextRenderer.text = this._title;
         }
         if(_loc4_ || _loc3_)
         {
            this.refreshBackground();
         }
         if(_loc8_ || _loc3_ || _loc1_)
         {
            this.refreshLayout();
         }
         if(_loc8_ || _loc3_)
         {
            this.refreshTitleStyles();
         }
         var _loc9_:Boolean = this._ignoreItemResizing;
         this._ignoreItemResizing = true;
         if(_loc5_)
         {
            if(this._leftItems)
            {
               for each(_loc10_ in this._leftItems)
               {
                  if(_loc10_ is IFeathersControl)
                  {
                     IFeathersControl(_loc10_).styleNameList.add(this.itemStyleName);
                  }
                  this.addChild(_loc10_);
               }
            }
         }
         if(_loc6_)
         {
            if(this._rightItems)
            {
               for each(_loc10_ in this._rightItems)
               {
                  if(_loc10_ is IFeathersControl)
                  {
                     IFeathersControl(_loc10_).styleNameList.add(this.itemStyleName);
                  }
                  this.addChild(_loc10_);
               }
            }
         }
         if(_loc7_)
         {
            if(this._centerItems)
            {
               for each(_loc10_ in this._centerItems)
               {
                  if(_loc10_ is IFeathersControl)
                  {
                     IFeathersControl(_loc10_).styleNameList.add(this.itemStyleName);
                  }
                  this.addChild(_loc10_);
               }
            }
         }
         this._ignoreItemResizing = _loc9_;
         if(_loc4_ || _loc8_)
         {
            this.refreshEnabled();
         }
         _loc1_ = this.autoSizeIfNeeded() || _loc1_;
         this.layoutBackground();
         if(_loc1_ || _loc5_ || _loc6_ || _loc7_ || _loc3_)
         {
            this.leftItemsWidth = 0;
            this.rightItemsWidth = 0;
            if(this._leftItems)
            {
               this.layoutLeftItems();
            }
            if(this._rightItems)
            {
               this.layoutRightItems();
            }
            if(this._centerItems)
            {
               this.layoutCenterItems();
            }
         }
         if(_loc8_ || _loc1_ || _loc3_ || _loc2_ || _loc5_ || _loc6_ || _loc7_)
         {
            this.layoutTitle();
         }
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:DisplayObject = null;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Point = null;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc1_:Boolean = this._explicitWidth !== this._explicitWidth;
         var _loc2_:Boolean = this._explicitHeight !== this._explicitHeight;
         var _loc3_:Boolean = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc4_:Boolean = this._explicitMinHeight !== this._explicitMinHeight;
         if(!_loc1_ && !_loc2_ && !_loc3_ && !_loc4_)
         {
            return false;
         }
         resetFluidChildDimensionsForMeasurement(this.currentBackgroundSkin,this._explicitWidth,this._explicitHeight,this._explicitMinWidth,this._explicitMinHeight,this._explicitMaxWidth,this._explicitMaxHeight,this._explicitBackgroundWidth,this._explicitBackgroundHeight,this._explicitBackgroundMinWidth,this._explicitBackgroundMinHeight,this._explicitBackgroundMaxWidth,this._explicitBackgroundMaxHeight);
         var _loc5_:IMeasureDisplayObject = this.currentBackgroundSkin as IMeasureDisplayObject;
         if(this.currentBackgroundSkin is IValidating)
         {
            IValidating(this.currentBackgroundSkin).validate();
         }
         var _loc6_:Number = this.calculateExtraOSStatusBarPadding();
         var _loc7_:Number = 0;
         var _loc8_:Number = 0;
         var _loc9_:Boolean = this._leftItems !== null && this._leftItems.length > 0;
         var _loc10_:Boolean = this._rightItems !== null && this._rightItems.length > 0;
         var _loc11_:Boolean = this._centerItems !== null && this._centerItems.length > 0;
         var _loc12_:Boolean = this._ignoreItemResizing;
         this._ignoreItemResizing = true;
         if(_loc9_)
         {
            _loc17_ = int(this._leftItems.length);
            _loc18_ = 0;
            while(_loc18_ < _loc17_)
            {
               _loc19_ = this._leftItems[_loc18_];
               if(_loc19_ is IValidating)
               {
                  IValidating(_loc19_).validate();
               }
               _loc20_ = _loc19_.width;
               if(_loc20_ === _loc20_)
               {
                  _loc7_ += _loc20_;
                  if(_loc18_ > 0)
                  {
                     _loc7_ += this._gap;
                  }
               }
               _loc21_ = _loc19_.height;
               if(_loc21_ === _loc21_ && _loc21_ > _loc8_)
               {
                  _loc8_ = _loc21_;
               }
               _loc18_++;
            }
         }
         if(_loc11_)
         {
            _loc17_ = int(this._centerItems.length);
            _loc18_ = 0;
            while(_loc18_ < _loc17_)
            {
               _loc19_ = this._centerItems[_loc18_];
               if(_loc19_ is IValidating)
               {
                  IValidating(_loc19_).validate();
               }
               _loc20_ = _loc19_.width;
               if(_loc20_ === _loc20_)
               {
                  _loc7_ += _loc20_;
                  if(_loc18_ > 0)
                  {
                     _loc7_ += this._gap;
                  }
               }
               _loc21_ = _loc19_.height;
               if(_loc21_ === _loc21_ && _loc21_ > _loc8_)
               {
                  _loc8_ = _loc21_;
               }
               _loc18_++;
            }
         }
         if(_loc10_)
         {
            _loc17_ = int(this._rightItems.length);
            _loc18_ = 0;
            while(_loc18_ < _loc17_)
            {
               _loc19_ = this._rightItems[_loc18_];
               if(_loc19_ is IValidating)
               {
                  IValidating(_loc19_).validate();
               }
               _loc20_ = _loc19_.width;
               if(_loc20_ === _loc20_)
               {
                  _loc7_ += _loc20_;
                  if(_loc18_ > 0)
                  {
                     _loc7_ += this._gap;
                  }
               }
               _loc21_ = _loc19_.height;
               if(_loc21_ === _loc21_ && _loc21_ > _loc8_)
               {
                  _loc8_ = _loc21_;
               }
               _loc18_++;
            }
         }
         this._ignoreItemResizing = _loc12_;
         if(this._titleAlign === HorizontalAlign.CENTER && _loc11_)
         {
            if(_loc9_)
            {
               _loc7_ += this._gap;
            }
            if(_loc10_)
            {
               _loc7_ += this._gap;
            }
         }
         else if(this._title !== null)
         {
            _loc22_ = this._titleGap;
            if(_loc22_ !== _loc22_)
            {
               _loc22_ = this._gap;
            }
            _loc23_ = this._explicitWidth;
            if(_loc1_)
            {
               _loc23_ = this._explicitMaxWidth;
            }
            _loc23_ -= _loc7_;
            if(_loc9_)
            {
               _loc23_ -= _loc22_;
            }
            if(_loc11_)
            {
               _loc23_ -= _loc22_;
            }
            if(_loc10_)
            {
               _loc23_ -= _loc22_;
            }
            if(_loc23_ < 0)
            {
               _loc23_ = 0;
            }
            this.titleTextRenderer.maxWidth = _loc23_;
            _loc24_ = Pool.getPoint();
            this.titleTextRenderer.measureText(_loc24_);
            _loc25_ = _loc24_.x;
            _loc26_ = _loc24_.y;
            Pool.putPoint(_loc24_);
            if(_loc25_ === _loc25_)
            {
               if(_loc9_)
               {
                  _loc25_ += _loc22_;
               }
               if(_loc10_)
               {
                  _loc25_ += _loc22_;
               }
            }
            else
            {
               _loc25_ = 0;
            }
            _loc7_ += _loc25_;
            if(_loc26_ === _loc26_ && _loc26_ > _loc8_)
            {
               _loc8_ = _loc26_;
            }
         }
         var _loc13_:Number = this._explicitWidth;
         if(_loc1_)
         {
            _loc13_ = _loc7_ + this._paddingLeft + this._paddingRight;
            if(this.currentBackgroundSkin !== null && this.currentBackgroundSkin.width > _loc13_)
            {
               _loc13_ = this.currentBackgroundSkin.width;
            }
         }
         var _loc14_:Number = this._explicitHeight;
         if(_loc2_)
         {
            _loc14_ = _loc8_;
            _loc14_ = _loc14_ + (this._paddingTop + this._paddingBottom);
            if(this.currentBackgroundSkin !== null && this.currentBackgroundSkin.height > _loc14_)
            {
               _loc14_ = this.currentBackgroundSkin.height;
            }
            if(_loc6_ > 0)
            {
               if(_loc14_ < this._explicitMinHeight)
               {
                  _loc14_ = this._explicitMinHeight;
               }
               _loc14_ += _loc6_;
            }
         }
         var _loc15_:Number = this._explicitMinWidth;
         if(_loc3_)
         {
            _loc15_ = _loc7_ + this._paddingLeft + this._paddingRight;
            if(this.currentBackgroundSkin !== null)
            {
               if(_loc5_ !== null)
               {
                  if(_loc5_.minWidth > _loc15_)
                  {
                     _loc15_ = _loc5_.minWidth;
                  }
               }
               else if(this._explicitBackgroundMinWidth > _loc15_)
               {
                  _loc15_ = this._explicitBackgroundMinWidth;
               }
            }
         }
         var _loc16_:Number = this._explicitMinHeight;
         if(_loc4_)
         {
            _loc16_ = _loc8_;
            _loc16_ = _loc16_ + (this._paddingTop + this._paddingBottom);
            if(this.currentBackgroundSkin !== null)
            {
               if(_loc5_ !== null)
               {
                  if(_loc5_.minHeight > _loc16_)
                  {
                     _loc16_ = _loc5_.minHeight;
                  }
               }
               else if(this._explicitBackgroundMinHeight > _loc16_)
               {
                  _loc16_ = this._explicitBackgroundMinHeight;
               }
            }
            if(_loc6_ > 0)
            {
               _loc16_ += _loc6_;
            }
         }
         return this.saveMeasurements(_loc13_,_loc14_,_loc15_,_loc16_);
      }
      
      protected function createTitle() : void
      {
         if(this.titleTextRenderer)
         {
            this.removeChild(DisplayObject(this.titleTextRenderer),true);
            this.titleTextRenderer = null;
         }
         var _loc1_:Function = this._titleFactory != null ? this._titleFactory : FeathersControl.defaultTextRendererFactory;
         this.titleTextRenderer = ITextRenderer(_loc1_());
         var _loc2_:IFeathersControl = IFeathersControl(this.titleTextRenderer);
         var _loc3_:String = this._customTitleStyleName != null ? this._customTitleStyleName : this.titleStyleName;
         _loc2_.styleNameList.add(_loc3_);
         this.addChild(DisplayObject(_loc2_));
      }
      
      protected function refreshBackground() : void
      {
         var _loc2_:IMeasureDisplayObject = null;
         var _loc1_:DisplayObject = this.currentBackgroundSkin;
         this.currentBackgroundSkin = this._backgroundSkin;
         if(!this._isEnabled && this._backgroundDisabledSkin !== null)
         {
            this.currentBackgroundSkin = this._backgroundDisabledSkin;
         }
         if(this.currentBackgroundSkin !== _loc1_)
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
      
      protected function refreshLayout() : void
      {
         this._layout.gap = this._gap;
         this._layout.paddingTop = this._paddingTop + this.calculateExtraOSStatusBarPadding();
         this._layout.paddingBottom = this._paddingBottom;
         this._layout.verticalAlign = this._verticalAlign;
      }
      
      protected function refreshEnabled() : void
      {
         this.titleTextRenderer.isEnabled = this._isEnabled;
      }
      
      protected function refreshTitleStyles() : void
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         this.titleTextRenderer.fontStyles = this._fontStylesSet;
         this.titleTextRenderer.wordWrap = this._wordWrap;
         for(_loc1_ in this._titleProperties)
         {
            _loc2_ = this._titleProperties[_loc1_];
            this.titleTextRenderer[_loc1_] = _loc2_;
         }
      }
      
      protected function calculateExtraOSStatusBarPadding() : Number
      {
         var _loc4_:ScreenDensityScaleCalculator = null;
         if(!this._useExtraPaddingForOSStatusBar)
         {
            return 0;
         }
         var _loc1_:String = Capabilities.os;
         if(_loc1_.indexOf(IOS_NAME_PREFIX) != -1)
         {
            _loc1_ = _loc1_.substring(IOS_NAME_PREFIX.length,_loc1_.indexOf("."));
         }
         else
         {
            if(_loc1_.indexOf(OLD_IOS_NAME_PREFIX) == -1)
            {
               return 0;
            }
            _loc1_ = _loc1_.substring(OLD_IOS_NAME_PREFIX.length,_loc1_.indexOf("."));
         }
         if(parseInt(_loc1_,10) < STATUS_BAR_MIN_IOS_VERSION)
         {
            return 0;
         }
         var _loc2_:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         var _loc3_:Stage = _loc2_.nativeStage;
         if(_loc3_.displayState !== StageDisplayState.NORMAL)
         {
            return 0;
         }
         if(iOSStatusBarScaledHeight !== iOSStatusBarScaledHeight)
         {
            _loc4_ = new ScreenDensityScaleCalculator();
            _loc4_.addScaleForDensity(168,1);
            _loc4_.addScaleForDensity(326,2);
            _loc4_.addScaleForDensity(401,3);
            if(this.hasNotch())
            {
               iOSStatusBarScaledHeight = IOS_NOTCH_STATUS_BAR_HEIGHT * _loc4_.getScale(DeviceCapabilities.dpi);
            }
            else
            {
               iOSStatusBarScaledHeight = IOS_STATUS_BAR_HEIGHT * _loc4_.getScale(DeviceCapabilities.dpi);
            }
         }
         return iOSStatusBarScaledHeight / _loc2_.contentScaleFactor;
      }
      
      protected function hasNotch() : Boolean
      {
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc1_:String = Capabilities.os;
         var _loc2_:Vector.<String> = new <String>["iPhone10,3","iPhone10,6","iPhone11,2","iPhone11,4","iPhone11,6","iPhone11,8"];
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            _loc6_ = _loc1_.lastIndexOf(_loc5_);
            if(_loc6_ != -1 && _loc6_ == _loc1_.length - _loc5_.length)
            {
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      protected function layoutBackground() : void
      {
         if(!this.currentBackgroundSkin)
         {
            return;
         }
         this.currentBackgroundSkin.width = this.actualWidth;
         this.currentBackgroundSkin.height = this.actualHeight;
      }
      
      protected function layoutLeftItems() : void
      {
         var _loc1_:DisplayObject = null;
         for each(_loc1_ in this._leftItems)
         {
            if(_loc1_ is IValidating)
            {
               IValidating(_loc1_).validate();
            }
         }
         HELPER_BOUNDS.x = HELPER_BOUNDS.y = 0;
         HELPER_BOUNDS.scrollX = HELPER_BOUNDS.scrollY = 0;
         HELPER_BOUNDS.explicitWidth = this.actualWidth;
         HELPER_BOUNDS.explicitHeight = this.actualHeight;
         this._layout.horizontalAlign = HorizontalAlign.LEFT;
         this._layout.paddingRight = 0;
         this._layout.paddingLeft = this._paddingLeft;
         this._layout.layout(this._leftItems,HELPER_BOUNDS,HELPER_LAYOUT_RESULT);
         this.leftItemsWidth = HELPER_LAYOUT_RESULT.contentWidth;
         if(this.leftItemsWidth !== this.leftItemsWidth)
         {
            this.leftItemsWidth = 0;
         }
      }
      
      protected function layoutRightItems() : void
      {
         var _loc1_:DisplayObject = null;
         for each(_loc1_ in this._rightItems)
         {
            if(_loc1_ is IValidating)
            {
               IValidating(_loc1_).validate();
            }
         }
         HELPER_BOUNDS.x = HELPER_BOUNDS.y = 0;
         HELPER_BOUNDS.scrollX = HELPER_BOUNDS.scrollY = 0;
         HELPER_BOUNDS.explicitWidth = this.actualWidth;
         HELPER_BOUNDS.explicitHeight = this.actualHeight;
         this._layout.horizontalAlign = HorizontalAlign.RIGHT;
         this._layout.paddingRight = this._paddingRight;
         this._layout.paddingLeft = 0;
         this._layout.layout(this._rightItems,HELPER_BOUNDS,HELPER_LAYOUT_RESULT);
         this.rightItemsWidth = HELPER_LAYOUT_RESULT.contentWidth;
         if(this.rightItemsWidth !== this.rightItemsWidth)
         {
            this.rightItemsWidth = 0;
         }
      }
      
      protected function layoutCenterItems() : void
      {
         var _loc1_:DisplayObject = null;
         for each(_loc1_ in this._centerItems)
         {
            if(_loc1_ is IValidating)
            {
               IValidating(_loc1_).validate();
            }
         }
         HELPER_BOUNDS.x = HELPER_BOUNDS.y = 0;
         HELPER_BOUNDS.scrollX = HELPER_BOUNDS.scrollY = 0;
         HELPER_BOUNDS.explicitWidth = this.actualWidth;
         HELPER_BOUNDS.explicitHeight = this.actualHeight;
         this._layout.horizontalAlign = HorizontalAlign.CENTER;
         this._layout.paddingRight = this._paddingRight;
         this._layout.paddingLeft = this._paddingLeft;
         this._layout.layout(this._centerItems,HELPER_BOUNDS,HELPER_LAYOUT_RESULT);
      }
      
      protected function layoutTitle() : void
      {
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc1_:Boolean = this._leftItems !== null && this._leftItems.length > 0;
         var _loc2_:Boolean = this._rightItems !== null && this._rightItems.length > 0;
         var _loc3_:Boolean = this._centerItems !== null && this._centerItems.length > 0;
         if(this._titleAlign === HorizontalAlign.CENTER && _loc3_)
         {
            this.titleTextRenderer.visible = false;
            return;
         }
         if(this._titleAlign === HorizontalAlign.LEFT && _loc1_ && _loc3_)
         {
            this.titleTextRenderer.visible = false;
            return;
         }
         if(this._titleAlign === HorizontalAlign.RIGHT && _loc2_ && _loc3_)
         {
            this.titleTextRenderer.visible = false;
            return;
         }
         this.titleTextRenderer.visible = true;
         var _loc4_:Number = this._titleGap;
         if(_loc4_ !== _loc4_)
         {
            _loc4_ = this._gap;
         }
         var _loc5_:Number = this._paddingLeft;
         if(_loc1_)
         {
            _loc5_ = this.leftItemsWidth + _loc4_;
         }
         var _loc6_:Number = this._paddingRight;
         if(_loc2_)
         {
            _loc6_ = this.rightItemsWidth + _loc4_;
         }
         if(this._titleAlign === HorizontalAlign.LEFT)
         {
            _loc8_ = this.actualWidth - _loc5_ - _loc6_;
            if(_loc8_ < 0)
            {
               _loc8_ = 0;
            }
            this.titleTextRenderer.maxWidth = _loc8_;
            this.titleTextRenderer.validate();
            this.titleTextRenderer.x = _loc5_;
         }
         else if(this._titleAlign === HorizontalAlign.RIGHT)
         {
            _loc8_ = this.actualWidth - _loc5_ - _loc6_;
            if(_loc8_ < 0)
            {
               _loc8_ = 0;
            }
            this.titleTextRenderer.maxWidth = _loc8_;
            this.titleTextRenderer.validate();
            this.titleTextRenderer.x = this.actualWidth - this.titleTextRenderer.width - _loc6_;
         }
         else
         {
            _loc9_ = this.actualWidth - this._paddingLeft - this._paddingRight;
            if(_loc9_ < 0)
            {
               _loc9_ = 0;
            }
            _loc10_ = this.actualWidth - _loc5_ - _loc6_;
            if(_loc10_ < 0)
            {
               _loc10_ = 0;
            }
            this.titleTextRenderer.maxWidth = _loc10_;
            this.titleTextRenderer.validate();
            _loc11_ = this._paddingLeft + Math.round((_loc9_ - this.titleTextRenderer.width) / 2);
            if(_loc5_ > _loc11_ || _loc11_ + this.titleTextRenderer.width > this.actualWidth - _loc6_)
            {
               this.titleTextRenderer.x = _loc5_ + Math.round((_loc10_ - this.titleTextRenderer.width) / 2);
            }
            else
            {
               this.titleTextRenderer.x = _loc11_;
            }
         }
         var _loc7_:Number = this._paddingTop + this.calculateExtraOSStatusBarPadding();
         switch(this._verticalAlign)
         {
            case VerticalAlign.TOP:
               this.titleTextRenderer.y = _loc7_;
               break;
            case VerticalAlign.BOTTOM:
               this.titleTextRenderer.y = this.actualHeight - this._paddingBottom - this.titleTextRenderer.height;
               break;
            default:
               this.titleTextRenderer.y = _loc7_ + Math.round((this.actualHeight - _loc7_ - this._paddingBottom - this.titleTextRenderer.height) / 2);
         }
      }
      
      protected function header_addedToStageHandler(param1:Event) : void
      {
         var _loc2_:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         _loc2_.nativeStage.addEventListener("fullScreen",this.nativeStage_fullScreenHandler);
      }
      
      protected function header_removedFromStageHandler(param1:Event) : void
      {
         var _loc2_:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         _loc2_.nativeStage.removeEventListener("fullScreen",this.nativeStage_fullScreenHandler);
      }
      
      protected function nativeStage_fullScreenHandler(param1:FullScreenEvent) : void
      {
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
      
      protected function fontStyles_changeHandler(param1:Event) : void
      {
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      protected function titleProperties_onChange(param1:PropertyProxy, param2:String) : void
      {
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      protected function item_resizeHandler(param1:Event) : void
      {
         if(this._ignoreItemResizing)
         {
            return;
         }
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
   }
}

