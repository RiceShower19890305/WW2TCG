package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.IFocusDisplayObject;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.IStateObserver;
   import feathers.core.ITextBaselineControl;
   import feathers.core.ITextRenderer;
   import feathers.core.IValidating;
   import feathers.core.PropertyProxy;
   import feathers.events.FeathersEventType;
   import feathers.layout.HorizontalAlign;
   import feathers.layout.RelativePosition;
   import feathers.layout.VerticalAlign;
   import feathers.skins.IStyleProvider;
   import feathers.text.FontStylesSet;
   import feathers.utils.keyboard.KeyToState;
   import feathers.utils.keyboard.KeyToTrigger;
   import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;
   import feathers.utils.touch.LongPress;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import starling.rendering.Painter;
   import starling.text.TextFormat;
   import starling.utils.Pool;
   
   public class Button extends BasicButton implements IFocusDisplayObject, ITextBaselineControl
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      private static const HELPER_POINT:Point = new Point();
      
      public static const DEFAULT_CHILD_STYLE_NAME_LABEL:String = "feathers-button-label";
      
      public static const ALTERNATE_STYLE_NAME_CALL_TO_ACTION_BUTTON:String = "feathers-call-to-action-button";
      
      public static const ALTERNATE_STYLE_NAME_QUIET_BUTTON:String = "feathers-quiet-button";
      
      public static const ALTERNATE_STYLE_NAME_DANGER_BUTTON:String = "feathers-danger-button";
      
      public static const ALTERNATE_STYLE_NAME_BACK_BUTTON:String = "feathers-back-button";
      
      public static const ALTERNATE_STYLE_NAME_FORWARD_BUTTON:String = "feathers-forward-button";
      
      protected var labelStyleName:String = "feathers-button-label";
      
      protected var labelTextRenderer:ITextRenderer;
      
      protected var _explicitLabelWidth:Number;
      
      protected var _explicitLabelHeight:Number;
      
      protected var _explicitLabelMinWidth:Number;
      
      protected var _explicitLabelMinHeight:Number;
      
      protected var _explicitLabelMaxWidth:Number;
      
      protected var _explicitLabelMaxHeight:Number;
      
      protected var currentIcon:DisplayObject;
      
      protected var keyToTrigger:KeyToTrigger;
      
      protected var keyToState:KeyToState;
      
      protected var longPress:LongPress;
      
      protected var dpadEnterKeyToTrigger:KeyToTrigger;
      
      protected var dpadEnterKeyToState:KeyToState;
      
      protected var _label:String = null;
      
      protected var _hasLabelTextRenderer:Boolean = true;
      
      protected var _iconPosition:String = "left";
      
      protected var _gap:Number = 0;
      
      protected var _minGap:Number = 0;
      
      protected var _horizontalAlign:String = "center";
      
      protected var _verticalAlign:String = "middle";
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var _labelOffsetX:Number = 0;
      
      protected var _labelOffsetY:Number = 0;
      
      protected var _iconOffsetX:Number = 0;
      
      protected var _iconOffsetY:Number = 0;
      
      protected var _fontStylesSet:FontStylesSet;
      
      private var _wordWrap:Boolean = false;
      
      protected var _labelFactory:Function;
      
      protected var _customLabelStyleName:String;
      
      protected var _defaultLabelProperties:PropertyProxy;
      
      protected var _defaultIcon:DisplayObject;
      
      protected var _stateToIcon:Object = {};
      
      protected var _longPressDuration:Number = 0.5;
      
      protected var _isLongPressEnabled:Boolean = false;
      
      protected var _stateToScale:Object = {};
      
      protected var _ignoreIconResizes:Boolean = false;
      
      public function Button()
      {
         super();
         if(this._fontStylesSet === null)
         {
            this._fontStylesSet = new FontStylesSet();
            this._fontStylesSet.addEventListener(Event.CHANGE,this.fontStyles_changeHandler);
         }
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return Button.globalStyleProvider;
      }
      
      public function get label() : String
      {
         return this._label;
      }
      
      public function set label(param1:String) : void
      {
         if(this._label == param1)
         {
            return;
         }
         this._label = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get hasLabelTextRenderer() : Boolean
      {
         return this._hasLabelTextRenderer;
      }
      
      public function set hasLabelTextRenderer(param1:Boolean) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._hasLabelTextRenderer === param1)
         {
            return;
         }
         this._hasLabelTextRenderer = param1;
         this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
      }
      
      public function get iconPosition() : String
      {
         return this._iconPosition;
      }
      
      public function set iconPosition(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._iconPosition === param1)
         {
            return;
         }
         this._iconPosition = param1;
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
      
      public function get minGap() : Number
      {
         return this._minGap;
      }
      
      public function set minGap(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._minGap == param1)
         {
            return;
         }
         this._minGap = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
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
      
      public function get labelOffsetX() : Number
      {
         return this._labelOffsetX;
      }
      
      public function set labelOffsetX(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._labelOffsetX == param1)
         {
            return;
         }
         this._labelOffsetX = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get labelOffsetY() : Number
      {
         return this._labelOffsetY;
      }
      
      public function set labelOffsetY(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._labelOffsetY == param1)
         {
            return;
         }
         this._labelOffsetY = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get iconOffsetX() : Number
      {
         return this._iconOffsetX;
      }
      
      public function set iconOffsetX(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._iconOffsetX == param1)
         {
            return;
         }
         this._iconOffsetX = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get iconOffsetY() : Number
      {
         return this._iconOffsetY;
      }
      
      public function set iconOffsetY(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._iconOffsetY == param1)
         {
            return;
         }
         this._iconOffsetY = param1;
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
      
      public function get labelFactory() : Function
      {
         return this._labelFactory;
      }
      
      public function set labelFactory(param1:Function) : void
      {
         if(this._labelFactory == param1)
         {
            return;
         }
         this._labelFactory = param1;
         this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
      }
      
      public function get customLabelStyleName() : String
      {
         return this._customLabelStyleName;
      }
      
      public function set customLabelStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customLabelStyleName === param1)
         {
            return;
         }
         this._customLabelStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
      }
      
      public function get defaultLabelProperties() : Object
      {
         if(this._defaultLabelProperties === null)
         {
            this._defaultLabelProperties = new PropertyProxy(this.childProperties_onChange);
         }
         return this._defaultLabelProperties;
      }
      
      public function set defaultLabelProperties(param1:Object) : void
      {
         if(!(param1 is PropertyProxy))
         {
            param1 = PropertyProxy.fromObject(param1);
         }
         if(this._defaultLabelProperties !== null)
         {
            this._defaultLabelProperties.removeOnChangeCallback(this.childProperties_onChange);
         }
         this._defaultLabelProperties = PropertyProxy(param1);
         if(this._defaultLabelProperties !== null)
         {
            this._defaultLabelProperties.addOnChangeCallback(this.childProperties_onChange);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get defaultIcon() : DisplayObject
      {
         return this._defaultIcon;
      }
      
      public function set defaultIcon(param1:DisplayObject) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            if(param1 !== null)
            {
               param1.dispose();
            }
            return;
         }
         if(this._defaultIcon === param1)
         {
            return;
         }
         if(this._defaultIcon !== null && this.currentIcon === this._defaultIcon)
         {
            this.removeCurrentIcon(this._defaultIcon);
            this.currentIcon = null;
         }
         this._defaultIcon = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get upIcon() : DisplayObject
      {
         return this.getIconForState(ButtonState.UP);
      }
      
      public function set upIcon(param1:DisplayObject) : void
      {
         this.setIconForState(ButtonState.UP,param1);
      }
      
      public function get downIcon() : DisplayObject
      {
         return this.getIconForState(ButtonState.DOWN);
      }
      
      public function set downIcon(param1:DisplayObject) : void
      {
         this.setIconForState(ButtonState.DOWN,param1);
      }
      
      public function get hoverIcon() : DisplayObject
      {
         return this.getIconForState(ButtonState.HOVER);
      }
      
      public function set hoverIcon(param1:DisplayObject) : void
      {
         this.setIconForState(ButtonState.HOVER,param1);
      }
      
      public function get disabledIcon() : DisplayObject
      {
         return this.getIconForState(ButtonState.DISABLED);
      }
      
      public function set disabledIcon(param1:DisplayObject) : void
      {
         this.setIconForState(ButtonState.DISABLED,param1);
      }
      
      public function get longPressDuration() : Number
      {
         return this._longPressDuration;
      }
      
      public function set longPressDuration(param1:Number) : void
      {
         if(this._longPressDuration == param1)
         {
            return;
         }
         this._longPressDuration = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get isLongPressEnabled() : Boolean
      {
         return this._isLongPressEnabled;
      }
      
      public function set isLongPressEnabled(param1:Boolean) : void
      {
         if(this._isLongPressEnabled === param1)
         {
            return;
         }
         this._isLongPressEnabled = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get scaleWhenDown() : Number
      {
         return this.getScaleForState(ButtonState.DOWN);
      }
      
      public function set scaleWhenDown(param1:Number) : void
      {
         this.setScaleForState(ButtonState.DOWN,param1);
      }
      
      public function get scaleWhenHovering() : Number
      {
         return this.getScaleForState(ButtonState.HOVER);
      }
      
      public function set scaleWhenHovering(param1:Number) : void
      {
         this.setScaleForState(ButtonState.HOVER,param1);
      }
      
      public function get baseline() : Number
      {
         if(!this.labelTextRenderer)
         {
            return this.scaledActualHeight;
         }
         return this.scaleY * (this.labelTextRenderer.y + this.labelTextRenderer.baseline);
      }
      
      public function get numLines() : int
      {
         if(this.labelTextRenderer === null)
         {
            return 0;
         }
         return this.labelTextRenderer.numLines;
      }
      
      override public function render(param1:Painter) : void
      {
         var _loc3_:Matrix = null;
         var _loc2_:Number = this.getScaleForCurrentState();
         if(_loc2_ != 1)
         {
            _loc3_ = Pool.getMatrix();
            _loc3_.scale(_loc2_,_loc2_);
            _loc3_.translate(Math.round((1 - _loc2_) / 2 * this.actualWidth),Math.round((1 - _loc2_) / 2 * this.actualHeight));
            param1.state.transformModelviewMatrix(_loc3_);
            Pool.putMatrix(_loc3_);
         }
         super.render(param1);
      }
      
      override public function dispose() : void
      {
         var _loc1_:String = null;
         var _loc2_:DisplayObject = null;
         if(this._defaultIcon !== null && this._defaultIcon.parent !== this)
         {
            this._defaultIcon.dispose();
         }
         for(_loc1_ in this._stateToIcon)
         {
            _loc2_ = this._stateToIcon[_loc1_] as DisplayObject;
            if(_loc2_ !== null && _loc2_.parent !== this)
            {
               _loc2_.dispose();
            }
         }
         if(this.keyToState !== null)
         {
            this.keyToState.target = null;
         }
         if(this.keyToTrigger !== null)
         {
            this.keyToTrigger.target = null;
         }
         if(this.dpadEnterKeyToState !== null)
         {
            this.dpadEnterKeyToState.target = null;
         }
         if(this.dpadEnterKeyToTrigger !== null)
         {
            this.dpadEnterKeyToTrigger.target = null;
         }
         if(this._fontStylesSet !== null)
         {
            this._fontStylesSet.dispose();
            this._fontStylesSet = null;
         }
         super.dispose();
      }
      
      public function getFontStylesForState(param1:String) : TextFormat
      {
         if(this._fontStylesSet === null)
         {
            return null;
         }
         return this._fontStylesSet.getFormatForState(param1);
      }
      
      public function setFontStylesForState(param1:String, param2:TextFormat) : void
      {
         var key:String = null;
         var changeHandler:Function = null;
         var state:String = param1;
         var format:TextFormat = param2;
         changeHandler = function(param1:Event):void
         {
            processStyleRestriction(key);
         };
         key = "setFontStylesForState--" + state;
         if(this.processStyleRestriction(key))
         {
            return;
         }
         if(format !== null)
         {
            format.removeEventListener(Event.CHANGE,changeHandler);
         }
         this._fontStylesSet.setFormatForState(state,format);
         if(format !== null)
         {
            format.addEventListener(Event.CHANGE,changeHandler);
         }
      }
      
      public function getIconForState(param1:String) : DisplayObject
      {
         return this._stateToIcon[param1] as DisplayObject;
      }
      
      public function setIconForState(param1:String, param2:DisplayObject) : void
      {
         var _loc3_:String = "setIconForState--" + param1;
         if(this.processStyleRestriction(_loc3_))
         {
            if(param2 !== null)
            {
               param2.dispose();
            }
            return;
         }
         var _loc4_:DisplayObject = this._stateToIcon[param1] as DisplayObject;
         if(_loc4_ !== null && this.currentIcon === _loc4_)
         {
            this.removeCurrentIcon(_loc4_);
            this.currentIcon = null;
         }
         if(param2 !== null)
         {
            this._stateToIcon[param1] = param2;
         }
         else
         {
            delete this._stateToIcon[param1];
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function getScaleForState(param1:String) : Number
      {
         if(param1 in this._stateToScale)
         {
            return this._stateToScale[param1] as Number;
         }
         return NaN;
      }
      
      public function setScaleForState(param1:String, param2:Number) : void
      {
         var _loc3_:String = "setScaleForState--" + param1;
         if(this.processStyleRestriction(_loc3_))
         {
            return;
         }
         if(param2 === param2)
         {
            this._stateToScale[param1] = param2;
         }
         else
         {
            delete this._stateToScale[param1];
         }
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         if(this.keyToState === null)
         {
            this.keyToState = new KeyToState(this,this.changeState);
         }
         if(this.keyToTrigger === null)
         {
            this.keyToTrigger = new KeyToTrigger(this);
         }
         if(this.longPress === null)
         {
            this.longPress = new LongPress(this);
         }
         if(this.dpadEnterKeyToState === null)
         {
            this.dpadEnterKeyToState = new KeyToState(this,this.changeState);
            this.dpadEnterKeyToState.keyCode = Keyboard.ENTER;
            this.dpadEnterKeyToState.keyLocation = 4;
         }
         if(this.dpadEnterKeyToTrigger === null)
         {
            this.dpadEnterKeyToTrigger = new KeyToTrigger(this,Keyboard.ENTER);
            this.dpadEnterKeyToTrigger.keyLocation = 4;
         }
         this.longPress.tapToTrigger = this.tapToTrigger;
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
         var _loc4_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         var _loc5_:Boolean = this.isInvalid(INVALIDATION_FLAG_TEXT_RENDERER);
         var _loc6_:Boolean = this.isInvalid(INVALIDATION_FLAG_FOCUS);
         if(_loc5_)
         {
            this.createLabel();
         }
         if(_loc5_ || _loc4_ || _loc1_)
         {
            this.refreshLabel();
         }
         if(_loc2_ || _loc4_)
         {
            this.refreshLongPressEvents();
            this.refreshIcon();
         }
         if(_loc5_ || _loc2_ || _loc4_)
         {
            this.refreshLabelStyles();
         }
         super.draw();
         if(_loc5_ || _loc2_ || _loc4_ || _loc1_ || _loc3_)
         {
            this.layoutContent();
         }
         if(_loc3_ || _loc6_)
         {
            this.refreshFocusIndicator();
         }
      }
      
      override protected function autoSizeIfNeeded() : Boolean
      {
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
         var _loc5_:ITextRenderer = null;
         if(this._label !== null && Boolean(this.labelTextRenderer))
         {
            _loc5_ = this.labelTextRenderer;
            this.refreshLabelTextRendererDimensions(true);
            this.labelTextRenderer.measureText(HELPER_POINT);
         }
         var _loc6_:Number = this._gap;
         if(_loc6_ == Number.POSITIVE_INFINITY)
         {
            _loc6_ = this._minGap;
         }
         resetFluidChildDimensionsForMeasurement(this.currentSkin,this._explicitWidth,this._explicitHeight,this._explicitMinWidth,this._explicitMinHeight,this._explicitMaxWidth,this._explicitMaxHeight,this._explicitSkinWidth,this._explicitSkinHeight,this._explicitSkinMinWidth,this._explicitSkinMinHeight,this._explicitSkinMaxWidth,this._explicitSkinMaxHeight);
         var _loc7_:IMeasureDisplayObject = this.currentSkin as IMeasureDisplayObject;
         if(this.currentIcon is IValidating)
         {
            IValidating(this.currentIcon).validate();
         }
         if(this.currentSkin is IValidating)
         {
            IValidating(this.currentSkin).validate();
         }
         var _loc8_:Number = this._explicitMinWidth;
         if(_loc3_)
         {
            if(_loc5_ !== null)
            {
               _loc8_ = HELPER_POINT.x;
            }
            else
            {
               _loc8_ = 0;
            }
            if(this.currentIcon !== null)
            {
               if(_loc5_ !== null)
               {
                  if(this._iconPosition !== RelativePosition.TOP && this._iconPosition !== RelativePosition.BOTTOM && this._iconPosition !== RelativePosition.MANUAL)
                  {
                     _loc8_ += _loc6_;
                     if(this.currentIcon is IFeathersControl)
                     {
                        _loc8_ += IFeathersControl(this.currentIcon).minWidth;
                     }
                     else
                     {
                        _loc8_ += this.currentIcon.width;
                     }
                  }
                  else if(this.currentIcon is IFeathersControl)
                  {
                     _loc12_ = Number(IFeathersControl(this.currentIcon).minWidth);
                     if(_loc12_ > _loc8_)
                     {
                        _loc8_ = _loc12_;
                     }
                  }
                  else if(this.currentIcon.width > _loc8_)
                  {
                     _loc8_ = this.currentIcon.width;
                  }
               }
               else if(this.currentIcon is IFeathersControl)
               {
                  _loc8_ = Number(IFeathersControl(this.currentIcon).minWidth);
               }
               else
               {
                  _loc8_ = this.currentIcon.width;
               }
            }
            _loc8_ += this._paddingLeft + this._paddingRight;
            if(this.currentSkin !== null)
            {
               if(_loc7_ !== null)
               {
                  if(_loc7_.minWidth > _loc8_)
                  {
                     _loc8_ = _loc7_.minWidth;
                  }
               }
               else if(this._explicitSkinMinWidth > _loc8_)
               {
                  _loc8_ = this._explicitSkinMinWidth;
               }
            }
         }
         var _loc9_:Number = this._explicitMinHeight;
         if(_loc4_)
         {
            if(_loc5_ !== null)
            {
               _loc9_ = HELPER_POINT.y;
            }
            else
            {
               _loc9_ = 0;
            }
            if(this.currentIcon !== null)
            {
               if(_loc5_ !== null)
               {
                  if(this._iconPosition === RelativePosition.TOP || this._iconPosition === RelativePosition.BOTTOM)
                  {
                     _loc9_ += _loc6_;
                     if(this.currentIcon is IFeathersControl)
                     {
                        _loc9_ += IFeathersControl(this.currentIcon).minHeight;
                     }
                     else
                     {
                        _loc9_ += this.currentIcon.height;
                     }
                  }
                  else if(this.currentIcon is IFeathersControl)
                  {
                     _loc13_ = Number(IFeathersControl(this.currentIcon).minHeight);
                     if(_loc13_ > _loc9_)
                     {
                        _loc9_ = _loc13_;
                     }
                  }
                  else if(this.currentIcon.height > _loc9_)
                  {
                     _loc9_ = this.currentIcon.height;
                  }
               }
               else if(this.currentIcon is IFeathersControl)
               {
                  _loc9_ = Number(IFeathersControl(this.currentIcon).minHeight);
               }
               else
               {
                  _loc9_ = this.currentIcon.height;
               }
            }
            _loc9_ += this._paddingTop + this._paddingBottom;
            if(this.currentSkin !== null)
            {
               if(_loc7_ !== null)
               {
                  if(_loc7_.minHeight > _loc9_)
                  {
                     _loc9_ = _loc7_.minHeight;
                  }
               }
               else if(this._explicitSkinMinHeight > _loc9_)
               {
                  _loc9_ = this._explicitSkinMinHeight;
               }
            }
         }
         var _loc10_:Number = this._explicitWidth;
         if(_loc1_)
         {
            if(_loc5_ !== null)
            {
               _loc10_ = HELPER_POINT.x;
            }
            else
            {
               _loc10_ = 0;
            }
            if(this.currentIcon !== null)
            {
               if(_loc5_ !== null)
               {
                  if(this._iconPosition !== RelativePosition.TOP && this._iconPosition !== RelativePosition.BOTTOM && this._iconPosition !== RelativePosition.MANUAL)
                  {
                     _loc10_ += _loc6_ + this.currentIcon.width;
                  }
                  else if(this.currentIcon.width > _loc10_)
                  {
                     _loc10_ = this.currentIcon.width;
                  }
               }
               else
               {
                  _loc10_ = this.currentIcon.width;
               }
            }
            _loc10_ += this._paddingLeft + this._paddingRight;
            if(this.currentSkin !== null && this.currentSkin.width > _loc10_)
            {
               _loc10_ = this.currentSkin.width;
            }
         }
         var _loc11_:Number = this._explicitHeight;
         if(_loc2_)
         {
            if(_loc5_ !== null)
            {
               _loc11_ = HELPER_POINT.y;
            }
            else
            {
               _loc11_ = 0;
            }
            if(this.currentIcon !== null)
            {
               if(_loc5_ !== null)
               {
                  if(this._iconPosition === RelativePosition.TOP || this._iconPosition === RelativePosition.BOTTOM)
                  {
                     _loc11_ += _loc6_ + this.currentIcon.height;
                  }
                  else if(this.currentIcon.height > _loc11_)
                  {
                     _loc11_ = this.currentIcon.height;
                  }
               }
               else
               {
                  _loc11_ = this.currentIcon.height;
               }
            }
            _loc11_ += this._paddingTop + this._paddingBottom;
            if(this.currentSkin !== null && this.currentSkin.height > _loc11_)
            {
               _loc11_ = this.currentSkin.height;
            }
         }
         return this.saveMeasurements(_loc10_,_loc11_,_loc8_,_loc9_);
      }
      
      override protected function changeState(param1:String) : void
      {
         var _loc2_:String = this._currentState;
         if(_loc2_ === param1)
         {
            return;
         }
         super.changeState(param1);
         if(this.getScaleForCurrentState() != this.getScaleForCurrentState(_loc2_))
         {
            this.setRequiresRedraw();
         }
      }
      
      protected function createLabel() : void
      {
         var _loc1_:Function = null;
         var _loc2_:String = null;
         if(this.labelTextRenderer)
         {
            this.removeChild(DisplayObject(this.labelTextRenderer),true);
            this.labelTextRenderer = null;
         }
         if(this._hasLabelTextRenderer)
         {
            _loc1_ = this._labelFactory != null ? this._labelFactory : FeathersControl.defaultTextRendererFactory;
            this.labelTextRenderer = ITextRenderer(_loc1_());
            _loc2_ = this._customLabelStyleName != null ? this._customLabelStyleName : this.labelStyleName;
            this.labelTextRenderer.styleNameList.add(_loc2_);
            if(this.labelTextRenderer is IStateObserver)
            {
               IStateObserver(this.labelTextRenderer).stateContext = this;
            }
            this.addChild(DisplayObject(this.labelTextRenderer));
            this._explicitLabelWidth = this.labelTextRenderer.explicitWidth;
            this._explicitLabelHeight = this.labelTextRenderer.explicitHeight;
            this._explicitLabelMinWidth = this.labelTextRenderer.explicitMinWidth;
            this._explicitLabelMinHeight = this.labelTextRenderer.explicitMinHeight;
            this._explicitLabelMaxWidth = this.labelTextRenderer.explicitMaxWidth;
            this._explicitLabelMaxHeight = this.labelTextRenderer.explicitMaxHeight;
         }
      }
      
      protected function refreshLabel() : void
      {
         if(!this.labelTextRenderer)
         {
            return;
         }
         this.labelTextRenderer.text = this._label;
         this.labelTextRenderer.visible = this._label !== null && this._label.length > 0;
         this.labelTextRenderer.isEnabled = this._isEnabled;
      }
      
      protected function refreshIcon() : void
      {
         var _loc2_:int = 0;
         var _loc1_:DisplayObject = this.currentIcon;
         this.currentIcon = this.getCurrentIcon();
         if(this.currentIcon is IFeathersControl)
         {
            IFeathersControl(this.currentIcon).isEnabled = this._isEnabled;
         }
         if(this.currentIcon !== _loc1_)
         {
            if(_loc1_ !== null)
            {
               this.removeCurrentIcon(_loc1_);
            }
            if(this.currentIcon !== null)
            {
               if(this.currentIcon is IStateObserver)
               {
                  IStateObserver(this.currentIcon).stateContext = this;
               }
               _loc2_ = this.numChildren;
               if(this.labelTextRenderer)
               {
                  _loc2_ = this.getChildIndex(DisplayObject(this.labelTextRenderer));
               }
               this.addChildAt(this.currentIcon,_loc2_);
               if(this.currentIcon is IFeathersControl)
               {
                  IFeathersControl(this.currentIcon).addEventListener(FeathersEventType.RESIZE,this.currentIcon_resizeHandler);
               }
            }
         }
      }
      
      protected function removeCurrentIcon(param1:DisplayObject) : void
      {
         if(param1 === null)
         {
            return;
         }
         if(param1 is IFeathersControl)
         {
            IFeathersControl(param1).removeEventListener(FeathersEventType.RESIZE,this.currentIcon_resizeHandler);
         }
         if(param1 is IStateObserver)
         {
            IStateObserver(param1).stateContext = null;
         }
         if(param1.parent === this)
         {
            this.removeChild(param1,false);
         }
      }
      
      protected function getCurrentIcon() : DisplayObject
      {
         var _loc1_:DisplayObject = this._stateToIcon[this._currentState] as DisplayObject;
         if(_loc1_ !== null)
         {
            return _loc1_;
         }
         return this._defaultIcon;
      }
      
      protected function getScaleForCurrentState(param1:String = null) : Number
      {
         if(param1 === null)
         {
            param1 = this._currentState;
         }
         if(param1 in this._stateToScale)
         {
            return this._stateToScale[param1];
         }
         return 1;
      }
      
      protected function refreshLabelStyles() : void
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         if(this.labelTextRenderer === null)
         {
            return;
         }
         this.labelTextRenderer.fontStyles = this._fontStylesSet;
         this.labelTextRenderer.wordWrap = this._wordWrap;
         for(_loc1_ in this._defaultLabelProperties)
         {
            _loc2_ = this._defaultLabelProperties[_loc1_];
            this.labelTextRenderer[_loc1_] = _loc2_;
         }
      }
      
      override protected function refreshTriggeredEvents() : void
      {
         super.refreshTriggeredEvents();
         this.keyToTrigger.isEnabled = this._isEnabled;
         this.dpadEnterKeyToTrigger.isEnabled = this._isEnabled;
      }
      
      protected function refreshLongPressEvents() : void
      {
         this.longPress.isEnabled = this._isEnabled && this._isLongPressEnabled;
         this.longPress.longPressDuration = this._longPressDuration;
      }
      
      protected function layoutContent() : void
      {
         this.refreshLabelTextRendererDimensions(false);
         var _loc1_:DisplayObject = null;
         if(this._label !== null && this.labelTextRenderer !== null)
         {
            _loc1_ = DisplayObject(this.labelTextRenderer);
         }
         var _loc2_:Boolean = Boolean(this.currentIcon) && this._iconPosition != RelativePosition.MANUAL;
         if(Boolean(_loc1_) && _loc2_)
         {
            this.positionSingleChild(_loc1_);
            this.positionLabelAndIcon();
         }
         else if(_loc1_)
         {
            this.positionSingleChild(_loc1_);
         }
         else if(_loc2_)
         {
            this.positionSingleChild(this.currentIcon);
         }
         if(this.currentIcon)
         {
            if(this._iconPosition == RelativePosition.MANUAL)
            {
               this.currentIcon.x = this._paddingLeft;
               this.currentIcon.y = this._paddingTop;
            }
            this.currentIcon.x += this._iconOffsetX;
            this.currentIcon.y += this._iconOffsetY;
         }
         if(_loc1_)
         {
            this.labelTextRenderer.x += this._labelOffsetX;
            this.labelTextRenderer.y += this._labelOffsetY;
         }
      }
      
      protected function refreshLabelTextRendererDimensions(param1:Boolean) : void
      {
         var _loc5_:Number = NaN;
         var _loc2_:Boolean = this._ignoreIconResizes;
         this._ignoreIconResizes = true;
         if(this.currentIcon is IValidating)
         {
            IValidating(this.currentIcon).validate();
         }
         this._ignoreIconResizes = _loc2_;
         if(this._label === null || this.labelTextRenderer === null)
         {
            return;
         }
         var _loc3_:Number = this.actualWidth;
         var _loc4_:Number = this.actualHeight;
         if(param1)
         {
            _loc3_ = this._explicitWidth;
            if(_loc3_ !== _loc3_)
            {
               _loc3_ = this._explicitMaxWidth;
            }
            _loc4_ = this._explicitHeight;
            if(_loc4_ !== _loc4_)
            {
               _loc4_ = this._explicitMaxHeight;
            }
         }
         _loc3_ -= this._paddingLeft + this._paddingRight;
         _loc4_ -= this._paddingTop + this._paddingBottom;
         if(this.currentIcon !== null)
         {
            _loc5_ = this._gap;
            if(_loc5_ == Number.POSITIVE_INFINITY)
            {
               _loc5_ = this._minGap;
            }
            if(this._iconPosition === RelativePosition.LEFT || this._iconPosition === RelativePosition.LEFT_BASELINE || this._iconPosition === RelativePosition.RIGHT || this._iconPosition === RelativePosition.RIGHT_BASELINE)
            {
               _loc3_ -= this.currentIcon.width + _loc5_;
            }
            if(this._iconPosition === RelativePosition.TOP || this._iconPosition === RelativePosition.BOTTOM)
            {
               _loc4_ -= this.currentIcon.height + _loc5_;
            }
         }
         if(_loc3_ < 0)
         {
            _loc3_ = 0;
         }
         if(_loc4_ < 0)
         {
            _loc4_ = 0;
         }
         if(_loc3_ > this._explicitLabelMaxWidth)
         {
            _loc3_ = this._explicitLabelMaxWidth;
         }
         if(_loc4_ > this._explicitLabelMaxHeight)
         {
            _loc4_ = this._explicitLabelMaxHeight;
         }
         this.labelTextRenderer.width = this._explicitLabelWidth;
         this.labelTextRenderer.height = this._explicitLabelHeight;
         this.labelTextRenderer.minWidth = this._explicitLabelMinWidth;
         this.labelTextRenderer.minHeight = this._explicitLabelMinHeight;
         this.labelTextRenderer.maxWidth = _loc3_;
         this.labelTextRenderer.maxHeight = _loc4_;
         this.labelTextRenderer.validate();
         if(!param1)
         {
            _loc3_ = Number(this.labelTextRenderer.width);
            _loc4_ = Number(this.labelTextRenderer.height);
            this.labelTextRenderer.width = _loc3_;
            this.labelTextRenderer.height = _loc4_;
            this.labelTextRenderer.minWidth = _loc3_;
            this.labelTextRenderer.minHeight = _loc4_;
         }
      }
      
      protected function positionSingleChild(param1:DisplayObject) : void
      {
         if(this._horizontalAlign == HorizontalAlign.LEFT)
         {
            param1.x = this._paddingLeft;
         }
         else if(this._horizontalAlign == HorizontalAlign.RIGHT)
         {
            param1.x = this.actualWidth - this._paddingRight - param1.width;
         }
         else
         {
            param1.x = this._paddingLeft + Math.round((this.actualWidth - this._paddingLeft - this._paddingRight - param1.width) / 2);
         }
         if(this._verticalAlign == VerticalAlign.TOP)
         {
            param1.y = this._paddingTop;
         }
         else if(this._verticalAlign == VerticalAlign.BOTTOM)
         {
            param1.y = this.actualHeight - this._paddingBottom - param1.height;
         }
         else
         {
            param1.y = this._paddingTop + Math.round((this.actualHeight - this._paddingTop - this._paddingBottom - param1.height) / 2);
         }
      }
      
      protected function positionLabelAndIcon() : void
      {
         if(this._iconPosition == RelativePosition.TOP)
         {
            if(this._gap == Number.POSITIVE_INFINITY)
            {
               this.currentIcon.y = this._paddingTop;
               this.labelTextRenderer.y = this.actualHeight - this._paddingBottom - this.labelTextRenderer.height;
            }
            else
            {
               if(this._verticalAlign == VerticalAlign.TOP)
               {
                  this.labelTextRenderer.y += this.currentIcon.height + this._gap;
               }
               else if(this._verticalAlign == VerticalAlign.MIDDLE)
               {
                  this.labelTextRenderer.y += Math.round((this.currentIcon.height + this._gap) / 2);
               }
               this.currentIcon.y = this.labelTextRenderer.y - this.currentIcon.height - this._gap;
            }
         }
         else if(this._iconPosition == RelativePosition.RIGHT || this._iconPosition == RelativePosition.RIGHT_BASELINE)
         {
            if(this._gap == Number.POSITIVE_INFINITY)
            {
               this.labelTextRenderer.x = this._paddingLeft;
               this.currentIcon.x = this.actualWidth - this._paddingRight - this.currentIcon.width;
            }
            else
            {
               if(this._horizontalAlign == HorizontalAlign.RIGHT)
               {
                  this.labelTextRenderer.x -= this.currentIcon.width + this._gap;
               }
               else if(this._horizontalAlign == HorizontalAlign.CENTER)
               {
                  this.labelTextRenderer.x -= Math.round((this.currentIcon.width + this._gap) / 2);
               }
               this.currentIcon.x = this.labelTextRenderer.x + this.labelTextRenderer.width + this._gap;
            }
         }
         else if(this._iconPosition == RelativePosition.BOTTOM)
         {
            if(this._gap == Number.POSITIVE_INFINITY)
            {
               this.labelTextRenderer.y = this._paddingTop;
               this.currentIcon.y = this.actualHeight - this._paddingBottom - this.currentIcon.height;
            }
            else
            {
               if(this._verticalAlign == VerticalAlign.BOTTOM)
               {
                  this.labelTextRenderer.y -= this.currentIcon.height + this._gap;
               }
               else if(this._verticalAlign == VerticalAlign.MIDDLE)
               {
                  this.labelTextRenderer.y -= Math.round((this.currentIcon.height + this._gap) / 2);
               }
               this.currentIcon.y = this.labelTextRenderer.y + this.labelTextRenderer.height + this._gap;
            }
         }
         else if(this._iconPosition == RelativePosition.LEFT || this._iconPosition == RelativePosition.LEFT_BASELINE)
         {
            if(this._gap == Number.POSITIVE_INFINITY)
            {
               this.currentIcon.x = this._paddingLeft;
               this.labelTextRenderer.x = this.actualWidth - this._paddingRight - this.labelTextRenderer.width;
            }
            else
            {
               if(this._horizontalAlign == HorizontalAlign.LEFT)
               {
                  this.labelTextRenderer.x += this._gap + this.currentIcon.width;
               }
               else if(this._horizontalAlign == HorizontalAlign.CENTER)
               {
                  this.labelTextRenderer.x += Math.round((this._gap + this.currentIcon.width) / 2);
               }
               this.currentIcon.x = this.labelTextRenderer.x - this._gap - this.currentIcon.width;
            }
         }
         if(this._iconPosition == RelativePosition.LEFT || this._iconPosition == RelativePosition.RIGHT)
         {
            if(this._verticalAlign == VerticalAlign.TOP)
            {
               this.currentIcon.y = this._paddingTop;
            }
            else if(this._verticalAlign == VerticalAlign.BOTTOM)
            {
               this.currentIcon.y = this.actualHeight - this._paddingBottom - this.currentIcon.height;
            }
            else
            {
               this.currentIcon.y = this._paddingTop + Math.round((this.actualHeight - this._paddingTop - this._paddingBottom - this.currentIcon.height) / 2);
            }
         }
         else if(this._iconPosition == RelativePosition.LEFT_BASELINE || this._iconPosition == RelativePosition.RIGHT_BASELINE)
         {
            this.currentIcon.y = this.labelTextRenderer.y + this.labelTextRenderer.baseline - this.currentIcon.height;
         }
         else if(this._horizontalAlign == HorizontalAlign.LEFT)
         {
            this.currentIcon.x = this._paddingLeft;
         }
         else if(this._horizontalAlign == HorizontalAlign.RIGHT)
         {
            this.currentIcon.x = this.actualWidth - this._paddingRight - this.currentIcon.width;
         }
         else
         {
            this.currentIcon.x = this._paddingLeft + Math.round((this.actualWidth - this._paddingLeft - this._paddingRight - this.currentIcon.width) / 2);
         }
      }
      
      protected function childProperties_onChange(param1:PropertyProxy, param2:Object) : void
      {
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      protected function currentIcon_resizeHandler() : void
      {
         if(this._ignoreIconResizes)
         {
            return;
         }
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
      
      protected function fontStyles_changeHandler(param1:Event) : void
      {
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
   }
}

