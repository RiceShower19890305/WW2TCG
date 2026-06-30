package feathers.controls.renderers
{
   import feathers.controls.ButtonState;
   import feathers.controls.ImageLoader;
   import feathers.controls.ItemRendererLayoutOrder;
   import feathers.controls.Scroller;
   import feathers.controls.ToggleButton;
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.IFocusContainer;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.IStateObserver;
   import feathers.core.ITextRenderer;
   import feathers.core.IValidating;
   import feathers.core.PropertyProxy;
   import feathers.events.FeathersEventType;
   import feathers.layout.HorizontalAlign;
   import feathers.layout.RelativePosition;
   import feathers.layout.VerticalAlign;
   import feathers.text.FontStylesSet;
   import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;
   import feathers.utils.touch.DelayedDownTouchToState;
   import flash.geom.Point;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.text.TextFormat;
   
   public class BaseDefaultItemRenderer extends ToggleButton implements IFocusContainer
   {
      
      public static const ALTERNATE_STYLE_NAME_DRILL_DOWN:String = "feathers-drill-down-item-renderer";
      
      public static const ALTERNATE_STYLE_NAME_CHECK:String = "feathers-check-item-renderer";
      
      public static const DEFAULT_CHILD_STYLE_NAME_LABEL:String = "feathers-item-renderer-label";
      
      public static const DEFAULT_CHILD_STYLE_NAME_ICON_LABEL:String = "feathers-item-renderer-icon-label";
      
      public static const DEFAULT_CHILD_STYLE_NAME_ICON_LOADER:String = "feathers-item-renderer-icon-loader";
      
      public static const DEFAULT_CHILD_STYLE_NAME_ACCESSORY_LABEL:String = "feathers-item-renderer-accessory-label";
      
      public static const DEFAULT_CHILD_STYLE_NAME_ACCESSORY_LOADER:String = "feathers-item-renderer-accessory-loader";
      
      private static const HELPER_POINT:Point = new Point();
      
      protected var iconLabelStyleName:String = "feathers-item-renderer-icon-label";
      
      protected var iconLoaderStyleName:String = "feathers-item-renderer-icon-loader";
      
      protected var accessoryLabelStyleName:String = "feathers-item-renderer-accessory-label";
      
      protected var accessoryLoaderStyleName:String = "feathers-item-renderer-accessory-loader";
      
      protected var _isChildFocusEnabled:Boolean = true;
      
      protected var skinLoader:ImageLoader;
      
      protected var iconLoader:ImageLoader;
      
      protected var iconLabel:ITextRenderer;
      
      protected var accessoryLoader:ImageLoader;
      
      protected var accessoryLabel:ITextRenderer;
      
      protected var currentAccessory:DisplayObject;
      
      protected var _skinIsFromItem:Boolean = false;
      
      protected var _iconIsFromItem:Boolean = false;
      
      protected var _accessoryIsFromItem:Boolean = false;
      
      protected var _data:Object;
      
      protected var _owner:Scroller;
      
      protected var _factoryID:String;
      
      protected var _useStateDelayTimer:Boolean = true;
      
      protected var isSelectableWithoutToggle:Boolean = true;
      
      protected var _itemHasLabel:Boolean = true;
      
      protected var _itemHasIcon:Boolean = true;
      
      protected var _itemHasAccessory:Boolean = true;
      
      protected var _itemHasSkin:Boolean = false;
      
      protected var _itemHasSelectable:Boolean = false;
      
      protected var _itemHasEnabled:Boolean = false;
      
      protected var _accessoryPosition:String = "right";
      
      protected var _layoutOrder:String = "labelIconAccessory";
      
      protected var _accessoryOffsetX:Number = 0;
      
      protected var _accessoryOffsetY:Number = 0;
      
      protected var _accessoryGap:Number = NaN;
      
      protected var _minAccessoryGap:Number = NaN;
      
      protected var _defaultAccessory:DisplayObject;
      
      protected var _stateToAccessory:Object = {};
      
      protected var accessoryTouchPointID:int = -1;
      
      protected var _stopScrollingOnAccessoryTouch:Boolean = true;
      
      protected var _isSelectableOnAccessoryTouch:Boolean = false;
      
      protected var _delayTextureCreationOnScroll:Boolean = false;
      
      protected var _labelField:String = "label";
      
      protected var _labelFunction:Function;
      
      protected var _iconField:String = "icon";
      
      protected var _iconFunction:Function;
      
      protected var _iconSourceField:String = "iconSource";
      
      protected var _iconSourceFunction:Function;
      
      protected var _iconLabelField:String = "iconLabel";
      
      protected var _iconLabelFunction:Function;
      
      protected var _customIconLoaderStyleName:String;
      
      protected var _customIconLabelStyleName:String;
      
      protected var _accessoryField:String = "accessory";
      
      protected var _accessoryFunction:Function;
      
      protected var _accessorySourceField:String = "accessorySource";
      
      protected var _accessorySourceFunction:Function;
      
      protected var _accessoryLabelField:String = "accessoryLabel";
      
      protected var _accessoryLabelFunction:Function;
      
      protected var _customAccessoryLabelStyleName:String;
      
      protected var _customAccessoryLoaderStyleName:String;
      
      protected var _skinField:String = "skin";
      
      protected var _skinFunction:Function;
      
      protected var _skinSourceField:String = "skinSource";
      
      protected var _skinSourceFunction:Function;
      
      protected var _selectableField:String = "selectable";
      
      protected var _selectableFunction:Function;
      
      protected var _enabledField:String = "enabled";
      
      protected var _enabledFunction:Function;
      
      protected var _explicitIsToggle:Boolean = false;
      
      protected var _explicitIsEnabled:Boolean;
      
      protected var _iconLoaderFactory:Function = defaultLoaderFactory;
      
      protected var _iconLabelFontStylesSet:FontStylesSet;
      
      protected var _iconLabelFactory:Function;
      
      protected var _iconLabelProperties:PropertyProxy;
      
      protected var _accessoryLoaderFactory:Function = defaultLoaderFactory;
      
      protected var _accessoryLabelFontStylesSet:FontStylesSet;
      
      protected var _accessoryLabelFactory:Function;
      
      protected var _accessoryLabelProperties:PropertyProxy;
      
      protected var _skinLoaderFactory:Function = defaultLoaderFactory;
      
      protected var _ignoreAccessoryResizes:Boolean = false;
      
      protected var _topOffset:Number = 0;
      
      protected var _rightOffset:Number = 0;
      
      protected var _bottomOffset:Number = 0;
      
      protected var _leftOffset:Number = 0;
      
      public function BaseDefaultItemRenderer()
      {
         super();
         if(this._iconLabelFontStylesSet === null)
         {
            this._iconLabelFontStylesSet = new FontStylesSet();
            this._iconLabelFontStylesSet.addEventListener(Event.CHANGE,fontStyles_changeHandler);
         }
         if(this._accessoryLabelFontStylesSet === null)
         {
            this._accessoryLabelFontStylesSet = new FontStylesSet();
            this._accessoryLabelFontStylesSet.addEventListener(Event.CHANGE,fontStyles_changeHandler);
         }
         this._explicitIsEnabled = this._isEnabled;
         this.labelStyleName = DEFAULT_CHILD_STYLE_NAME_LABEL;
         this.isFocusEnabled = false;
         this.isQuickHitAreaEnabled = false;
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.itemRenderer_removedFromStageHandler);
      }
      
      protected static function defaultLoaderFactory() : ImageLoader
      {
         return new ImageLoader();
      }
      
      public function get isChildFocusEnabled() : Boolean
      {
         return this._isEnabled && this._isChildFocusEnabled;
      }
      
      public function set isChildFocusEnabled(param1:Boolean) : void
      {
         this._isChildFocusEnabled = param1;
      }
      
      override public function set defaultIcon(param1:DisplayObject) : void
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
         this.replaceIcon(null);
         this._iconIsFromItem = false;
         super.defaultIcon = param1;
      }
      
      override public function set defaultSkin(param1:DisplayObject) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            if(param1 !== null)
            {
               param1.dispose();
            }
            return;
         }
         if(this._defaultSkin === param1)
         {
            return;
         }
         this.replaceSkin(null);
         this._skinIsFromItem = false;
         super.defaultSkin = param1;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(param1:Object) : void
      {
         if(this._data === param1)
         {
            return;
         }
         this._data = param1;
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
      
      public function get useStateDelayTimer() : Boolean
      {
         return this._useStateDelayTimer;
      }
      
      public function set useStateDelayTimer(param1:Boolean) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         this._useStateDelayTimer = param1;
      }
      
      public function get itemHasLabel() : Boolean
      {
         return this._itemHasLabel;
      }
      
      public function set itemHasLabel(param1:Boolean) : void
      {
         if(this._itemHasLabel == param1)
         {
            return;
         }
         this._itemHasLabel = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get itemHasIcon() : Boolean
      {
         return this._itemHasIcon;
      }
      
      public function set itemHasIcon(param1:Boolean) : void
      {
         if(this._itemHasIcon == param1)
         {
            return;
         }
         this._itemHasIcon = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get itemHasAccessory() : Boolean
      {
         return this._itemHasAccessory;
      }
      
      public function set itemHasAccessory(param1:Boolean) : void
      {
         if(this._itemHasAccessory == param1)
         {
            return;
         }
         this._itemHasAccessory = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get itemHasSkin() : Boolean
      {
         return this._itemHasSkin;
      }
      
      public function set itemHasSkin(param1:Boolean) : void
      {
         if(this._itemHasSkin == param1)
         {
            return;
         }
         this._itemHasSkin = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get itemHasSelectable() : Boolean
      {
         return this._itemHasSelectable;
      }
      
      public function set itemHasSelectable(param1:Boolean) : void
      {
         if(this._itemHasSelectable == param1)
         {
            return;
         }
         this._itemHasSelectable = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get itemHasEnabled() : Boolean
      {
         return this._itemHasEnabled;
      }
      
      public function set itemHasEnabled(param1:Boolean) : void
      {
         if(this._itemHasEnabled == param1)
         {
            return;
         }
         this._itemHasEnabled = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get accessoryPosition() : String
      {
         return this._accessoryPosition;
      }
      
      public function set accessoryPosition(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._accessoryPosition === param1)
         {
            return;
         }
         this._accessoryPosition = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get layoutOrder() : String
      {
         return this._layoutOrder;
      }
      
      public function set layoutOrder(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._layoutOrder === param1)
         {
            return;
         }
         this._layoutOrder = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get accessoryOffsetX() : Number
      {
         return this._accessoryOffsetX;
      }
      
      public function set accessoryOffsetX(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._accessoryOffsetX == param1)
         {
            return;
         }
         this._accessoryOffsetX = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get accessoryOffsetY() : Number
      {
         return this._accessoryOffsetY;
      }
      
      public function set accessoryOffsetY(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._accessoryOffsetY == param1)
         {
            return;
         }
         this._accessoryOffsetY = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get accessoryGap() : Number
      {
         return this._accessoryGap;
      }
      
      public function set accessoryGap(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._accessoryGap == param1)
         {
            return;
         }
         this._accessoryGap = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get minAccessoryGap() : Number
      {
         return this._minAccessoryGap;
      }
      
      public function set minAccessoryGap(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._minAccessoryGap == param1)
         {
            return;
         }
         this._minAccessoryGap = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get defaultAccessory() : DisplayObject
      {
         return this._defaultAccessory;
      }
      
      public function set defaultAccessory(param1:DisplayObject) : void
      {
         if(this._defaultAccessory === param1)
         {
            return;
         }
         this.replaceAccessory(null);
         this._accessoryIsFromItem = false;
         this._defaultAccessory = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get stopScrollingOnAccessoryTouch() : Boolean
      {
         return this._stopScrollingOnAccessoryTouch;
      }
      
      public function set stopScrollingOnAccessoryTouch(param1:Boolean) : void
      {
         this._stopScrollingOnAccessoryTouch = param1;
      }
      
      public function get isSelectableOnAccessoryTouch() : Boolean
      {
         return this._isSelectableOnAccessoryTouch;
      }
      
      public function set isSelectableOnAccessoryTouch(param1:Boolean) : void
      {
         this._isSelectableOnAccessoryTouch = param1;
      }
      
      public function get delayTextureCreationOnScroll() : Boolean
      {
         return this._delayTextureCreationOnScroll;
      }
      
      public function set delayTextureCreationOnScroll(param1:Boolean) : void
      {
         this._delayTextureCreationOnScroll = param1;
      }
      
      public function get labelField() : String
      {
         return this._labelField;
      }
      
      public function set labelField(param1:String) : void
      {
         if(this._labelField == param1)
         {
            return;
         }
         this._labelField = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get labelFunction() : Function
      {
         return this._labelFunction;
      }
      
      public function set labelFunction(param1:Function) : void
      {
         if(this._labelFunction == param1)
         {
            return;
         }
         this._labelFunction = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get iconField() : String
      {
         return this._iconField;
      }
      
      public function set iconField(param1:String) : void
      {
         if(this._iconField == param1)
         {
            return;
         }
         this._iconField = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get iconFunction() : Function
      {
         return this._iconFunction;
      }
      
      public function set iconFunction(param1:Function) : void
      {
         if(this._iconFunction == param1)
         {
            return;
         }
         this._iconFunction = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get iconSourceField() : String
      {
         return this._iconSourceField;
      }
      
      public function set iconSourceField(param1:String) : void
      {
         if(this._iconSourceField == param1)
         {
            return;
         }
         this._iconSourceField = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get iconSourceFunction() : Function
      {
         return this._iconSourceFunction;
      }
      
      public function set iconSourceFunction(param1:Function) : void
      {
         if(this._iconSourceFunction == param1)
         {
            return;
         }
         this._iconSourceFunction = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get iconLabelField() : String
      {
         return this._iconLabelField;
      }
      
      public function set iconLabelField(param1:String) : void
      {
         if(this._iconLabelField == param1)
         {
            return;
         }
         this._iconLabelField = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get iconLabelFunction() : Function
      {
         return this._iconLabelFunction;
      }
      
      public function set iconLabelFunction(param1:Function) : void
      {
         if(this._iconLabelFunction == param1)
         {
            return;
         }
         this._iconLabelFunction = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get customIconLoaderStyleName() : String
      {
         return this._customIconLoaderStyleName;
      }
      
      public function set customIconLoaderStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customIconLoaderStyleName === param1)
         {
            return;
         }
         this._customIconLoaderStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get customIconLabelStyleName() : String
      {
         return this._customIconLabelStyleName;
      }
      
      public function set customIconLabelStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customIconLabelStyleName === param1)
         {
            return;
         }
         this._customIconLabelStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
      }
      
      public function get accessoryField() : String
      {
         return this._accessoryField;
      }
      
      public function set accessoryField(param1:String) : void
      {
         if(this._accessoryField == param1)
         {
            return;
         }
         this._accessoryField = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get accessoryFunction() : Function
      {
         return this._accessoryFunction;
      }
      
      public function set accessoryFunction(param1:Function) : void
      {
         if(this._accessoryFunction == param1)
         {
            return;
         }
         this._accessoryFunction = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get accessorySourceField() : String
      {
         return this._accessorySourceField;
      }
      
      public function set accessorySourceField(param1:String) : void
      {
         if(this._accessorySourceField == param1)
         {
            return;
         }
         this._accessorySourceField = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get accessorySourceFunction() : Function
      {
         return this._accessorySourceFunction;
      }
      
      public function set accessorySourceFunction(param1:Function) : void
      {
         if(this._accessorySourceFunction == param1)
         {
            return;
         }
         this._accessorySourceFunction = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get accessoryLabelField() : String
      {
         return this._accessoryLabelField;
      }
      
      public function set accessoryLabelField(param1:String) : void
      {
         if(this._accessoryLabelField == param1)
         {
            return;
         }
         this._accessoryLabelField = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get accessoryLabelFunction() : Function
      {
         return this._accessoryLabelFunction;
      }
      
      public function set accessoryLabelFunction(param1:Function) : void
      {
         if(this._accessoryLabelFunction == param1)
         {
            return;
         }
         this._accessoryLabelFunction = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get customAccessoryLabelStyleName() : String
      {
         return this._customAccessoryLabelStyleName;
      }
      
      public function set customAccessoryLabelStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customAccessoryLabelStyleName === param1)
         {
            return;
         }
         this._customAccessoryLabelStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
      }
      
      public function get customAccessoryLoaderStyleName() : String
      {
         return this._customAccessoryLoaderStyleName;
      }
      
      public function set customAccessoryLoaderStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customAccessoryLoaderStyleName === param1)
         {
            return;
         }
         this._customAccessoryLoaderStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get skinField() : String
      {
         return this._skinField;
      }
      
      public function set skinField(param1:String) : void
      {
         if(this._skinField == param1)
         {
            return;
         }
         this._skinField = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get skinFunction() : Function
      {
         return this._skinFunction;
      }
      
      public function set skinFunction(param1:Function) : void
      {
         if(this._skinFunction == param1)
         {
            return;
         }
         this._skinFunction = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get skinSourceField() : String
      {
         return this._skinSourceField;
      }
      
      public function set skinSourceField(param1:String) : void
      {
         if(this._skinSourceField == param1)
         {
            return;
         }
         this._skinSourceField = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get skinSourceFunction() : Function
      {
         return this._skinSourceFunction;
      }
      
      public function set skinSourceFunction(param1:Function) : void
      {
         if(this._skinSourceFunction == param1)
         {
            return;
         }
         this._skinSourceFunction = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get selectableField() : String
      {
         return this._selectableField;
      }
      
      public function set selectableField(param1:String) : void
      {
         if(this._selectableField == param1)
         {
            return;
         }
         this._selectableField = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get selectableFunction() : Function
      {
         return this._selectableFunction;
      }
      
      public function set selectableFunction(param1:Function) : void
      {
         if(this._selectableFunction == param1)
         {
            return;
         }
         this._selectableFunction = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get enabledField() : String
      {
         return this._enabledField;
      }
      
      public function set enabledField(param1:String) : void
      {
         if(this._enabledField == param1)
         {
            return;
         }
         this._enabledField = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get enabledFunction() : Function
      {
         return this._enabledFunction;
      }
      
      public function set enabledFunction(param1:Function) : void
      {
         if(this._enabledFunction == param1)
         {
            return;
         }
         this._enabledFunction = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      override public function set isToggle(param1:Boolean) : void
      {
         if(this._explicitIsToggle == param1)
         {
            return;
         }
         super.isToggle = param1;
         this._explicitIsToggle = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      override public function set isEnabled(param1:Boolean) : void
      {
         if(this._explicitIsEnabled == param1)
         {
            return;
         }
         this._explicitIsEnabled = param1;
         super.isEnabled = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get iconLoaderFactory() : Function
      {
         return this._iconLoaderFactory;
      }
      
      public function set iconLoaderFactory(param1:Function) : void
      {
         if(this._iconLoaderFactory == param1)
         {
            return;
         }
         this._iconLoaderFactory = param1;
         this._iconIsFromItem = false;
         this.replaceIcon(null);
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get iconLabelFontStyles() : TextFormat
      {
         return this._iconLabelFontStylesSet.format;
      }
      
      public function set iconLabelFontStyles(param1:TextFormat) : void
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
         this._iconLabelFontStylesSet.format = value;
         if(value !== null)
         {
            value.addEventListener(Event.CHANGE,changeHandler);
         }
      }
      
      public function get iconLabelDisabledFontStyles() : TextFormat
      {
         return this._iconLabelFontStylesSet.disabledFormat;
      }
      
      public function set iconLabelDisabledFontStyles(param1:TextFormat) : void
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
         this._iconLabelFontStylesSet.disabledFormat = value;
         if(value !== null)
         {
            value.addEventListener(Event.CHANGE,changeHandler);
         }
      }
      
      public function get iconLabelSelectedFontStyles() : TextFormat
      {
         return this._iconLabelFontStylesSet.selectedFormat;
      }
      
      public function set iconLabelSelectedFontStyles(param1:TextFormat) : void
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
         this._iconLabelFontStylesSet.selectedFormat = value;
         if(value !== null)
         {
            value.addEventListener(Event.CHANGE,changeHandler);
         }
      }
      
      public function get iconLabelFactory() : Function
      {
         return this._iconLabelFactory;
      }
      
      public function set iconLabelFactory(param1:Function) : void
      {
         if(this._iconLabelFactory == param1)
         {
            return;
         }
         this._iconLabelFactory = param1;
         this._iconIsFromItem = false;
         this.replaceIcon(null);
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get iconLabelProperties() : Object
      {
         if(!this._iconLabelProperties)
         {
            this._iconLabelProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._iconLabelProperties;
      }
      
      public function set iconLabelProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         var _loc3_:String = null;
         if(this._iconLabelProperties == param1)
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
         if(this._iconLabelProperties)
         {
            this._iconLabelProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._iconLabelProperties = PropertyProxy(param1);
         if(this._iconLabelProperties)
         {
            this._iconLabelProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get accessoryLoaderFactory() : Function
      {
         return this._accessoryLoaderFactory;
      }
      
      public function set accessoryLoaderFactory(param1:Function) : void
      {
         if(this._accessoryLoaderFactory == param1)
         {
            return;
         }
         this._accessoryLoaderFactory = param1;
         this._accessoryIsFromItem = false;
         this.replaceAccessory(null);
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get accessoryLabelFontStyles() : TextFormat
      {
         return this._accessoryLabelFontStylesSet.format;
      }
      
      public function set accessoryLabelFontStyles(param1:TextFormat) : void
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
         this._accessoryLabelFontStylesSet.format = value;
         if(value !== null)
         {
            value.addEventListener(Event.CHANGE,changeHandler);
         }
      }
      
      public function get accessoryLabelDisabledFontStyles() : TextFormat
      {
         return this._accessoryLabelFontStylesSet.disabledFormat;
      }
      
      public function set accessoryLabelDisabledFontStyles(param1:TextFormat) : void
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
         this._accessoryLabelFontStylesSet.disabledFormat = value;
         if(value !== null)
         {
            value.addEventListener(Event.CHANGE,changeHandler);
         }
      }
      
      public function get accessoryLabelSelectedFontStyles() : TextFormat
      {
         return this._accessoryLabelFontStylesSet.selectedFormat;
      }
      
      public function set accessoryLabelSelectedFontStyles(param1:TextFormat) : void
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
         this._accessoryLabelFontStylesSet.selectedFormat = value;
         if(value !== null)
         {
            value.addEventListener(Event.CHANGE,changeHandler);
         }
      }
      
      public function get accessoryLabelFactory() : Function
      {
         return this._accessoryLabelFactory;
      }
      
      public function set accessoryLabelFactory(param1:Function) : void
      {
         if(this._accessoryLabelFactory == param1)
         {
            return;
         }
         this._accessoryLabelFactory = param1;
         this._accessoryIsFromItem = false;
         this.replaceAccessory(null);
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get accessoryLabelProperties() : Object
      {
         if(!this._accessoryLabelProperties)
         {
            this._accessoryLabelProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._accessoryLabelProperties;
      }
      
      public function set accessoryLabelProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         var _loc3_:String = null;
         if(this._accessoryLabelProperties == param1)
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
         if(this._accessoryLabelProperties)
         {
            this._accessoryLabelProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._accessoryLabelProperties = PropertyProxy(param1);
         if(this._accessoryLabelProperties)
         {
            this._accessoryLabelProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get skinLoaderFactory() : Function
      {
         return this._skinLoaderFactory;
      }
      
      public function set skinLoaderFactory(param1:Function) : void
      {
         if(this._skinLoaderFactory == param1)
         {
            return;
         }
         this._skinLoaderFactory = param1;
         this._skinIsFromItem = false;
         this.replaceSkin(null);
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      override public function dispose() : void
      {
         if(this._iconIsFromItem)
         {
            this.replaceIcon(null);
         }
         if(this._accessoryIsFromItem)
         {
            this.replaceAccessory(null);
         }
         if(this._skinIsFromItem)
         {
            this.replaceSkin(null);
         }
         if(this._iconLabelFontStylesSet !== null)
         {
            this._iconLabelFontStylesSet.dispose();
            this._iconLabelFontStylesSet = null;
         }
         if(this._accessoryLabelFontStylesSet !== null)
         {
            this._accessoryLabelFontStylesSet.dispose();
            this._accessoryLabelFontStylesSet = null;
         }
         super.dispose();
      }
      
      public function itemToLabel(param1:Object) : String
      {
         var _loc2_:Object = null;
         var _loc3_:IGroupedListItemRenderer = null;
         if(this._labelFunction !== null)
         {
            if(this is IListItemRenderer && this._labelFunction.length == 2)
            {
               _loc2_ = this._labelFunction(param1,IListItemRenderer(this).index);
            }
            else if(this is IGroupedListItemRenderer && this._labelFunction.length == 3)
            {
               _loc3_ = IGroupedListItemRenderer(this);
               _loc2_ = this._labelFunction(param1,_loc3_.groupIndex,_loc3_.itemIndex);
            }
            else
            {
               _loc2_ = this._labelFunction(param1);
            }
            if(_loc2_ is String)
            {
               return _loc2_ as String;
            }
            if(_loc2_ !== null)
            {
               return _loc2_.toString();
            }
         }
         else if(this._labelField !== null && param1 !== null && param1.hasOwnProperty(this._labelField))
         {
            _loc2_ = param1[this._labelField];
            if(_loc2_ is String)
            {
               return _loc2_ as String;
            }
            if(_loc2_ !== null)
            {
               return _loc2_.toString();
            }
         }
         else
         {
            if(param1 is String)
            {
               return param1 as String;
            }
            if(param1 !== null)
            {
               return param1.toString();
            }
         }
         return null;
      }
      
      protected function itemToIcon(param1:Object) : DisplayObject
      {
         var _loc2_:Object = null;
         var _loc3_:IGroupedListItemRenderer = null;
         var _loc4_:Object = null;
         if(this._iconSourceFunction !== null)
         {
            if(this is IListItemRenderer && this._iconSourceFunction.length == 2)
            {
               _loc2_ = this._iconSourceFunction(param1,IListItemRenderer(this).index);
            }
            else if(this is IGroupedListItemRenderer && this._iconSourceFunction.length == 3)
            {
               _loc3_ = IGroupedListItemRenderer(this);
               _loc2_ = this._iconSourceFunction(param1,_loc3_.groupIndex,_loc3_.itemIndex);
            }
            else
            {
               _loc2_ = this._iconSourceFunction(param1);
            }
            this.refreshIconSource(_loc2_);
            return this.iconLoader;
         }
         if(this._iconSourceField !== null && param1 !== null && param1.hasOwnProperty(this._iconSourceField))
         {
            _loc2_ = param1[this._iconSourceField];
            this.refreshIconSource(_loc2_);
            return this.iconLoader;
         }
         if(this._iconLabelFunction !== null)
         {
            if(this is IListItemRenderer && this._iconLabelFunction.length == 2)
            {
               _loc4_ = this._iconLabelFunction(param1,IListItemRenderer(this).index);
            }
            else if(this is IGroupedListItemRenderer && this._iconLabelFunction.length == 3)
            {
               _loc3_ = IGroupedListItemRenderer(this);
               _loc4_ = this._iconLabelFunction(param1,_loc3_.groupIndex,_loc3_.itemIndex);
            }
            else
            {
               _loc4_ = this._iconLabelFunction(param1);
            }
            if(_loc4_ is String)
            {
               this.refreshIconLabel(_loc4_ as String);
            }
            else
            {
               this.refreshIconLabel(_loc4_.toString());
            }
            return DisplayObject(this.iconLabel);
         }
         if(this._iconLabelField !== null && param1 !== null && param1.hasOwnProperty(this._iconLabelField))
         {
            _loc4_ = param1[this._iconLabelField];
            if(_loc4_ is String)
            {
               this.refreshIconLabel(_loc4_ as String);
            }
            else
            {
               this.refreshIconLabel(_loc4_.toString());
            }
            return DisplayObject(this.iconLabel);
         }
         if(this._iconFunction !== null)
         {
            if(this is IListItemRenderer && this._iconFunction.length == 2)
            {
               return this._iconFunction(param1,IListItemRenderer(this).index) as DisplayObject;
            }
            if(this is IGroupedListItemRenderer && this._iconFunction.length == 3)
            {
               _loc3_ = IGroupedListItemRenderer(this);
               return this._iconFunction(param1,_loc3_.groupIndex,_loc3_.itemIndex) as DisplayObject;
            }
            return this._iconFunction(param1) as DisplayObject;
         }
         if(this._iconField !== null && param1 !== null && param1.hasOwnProperty(this._iconField))
         {
            return param1[this._iconField] as DisplayObject;
         }
         return null;
      }
      
      protected function itemToAccessory(param1:Object) : DisplayObject
      {
         var _loc2_:Object = null;
         var _loc3_:IGroupedListItemRenderer = null;
         var _loc4_:Object = null;
         if(this._accessorySourceFunction !== null)
         {
            if(this is IListItemRenderer && this._accessorySourceFunction.length == 2)
            {
               _loc2_ = this._accessorySourceFunction(param1,IListItemRenderer(this).index);
            }
            else if(this is IGroupedListItemRenderer && this._accessorySourceFunction.length == 3)
            {
               _loc3_ = IGroupedListItemRenderer(this);
               _loc2_ = this._accessorySourceFunction(param1,_loc3_.groupIndex,_loc3_.itemIndex);
            }
            else
            {
               _loc2_ = this._accessorySourceFunction(param1);
            }
            this.refreshAccessorySource(_loc2_);
            return this.accessoryLoader;
         }
         if(this._accessorySourceField !== null && param1 !== null && param1.hasOwnProperty(this._accessorySourceField))
         {
            _loc2_ = param1[this._accessorySourceField];
            this.refreshAccessorySource(_loc2_);
            return this.accessoryLoader;
         }
         if(this._accessoryLabelFunction !== null)
         {
            if(this is IListItemRenderer && this._accessoryLabelFunction.length == 2)
            {
               _loc4_ = this._accessoryLabelFunction(param1,IListItemRenderer(this).index);
            }
            else if(this is IGroupedListItemRenderer && this._accessoryLabelFunction.length == 3)
            {
               _loc3_ = IGroupedListItemRenderer(this);
               _loc4_ = this._accessoryLabelFunction(param1,_loc3_.groupIndex,_loc3_.itemIndex);
            }
            else
            {
               _loc4_ = this._accessoryLabelFunction(param1);
            }
            if(_loc4_ is String)
            {
               this.refreshAccessoryLabel(_loc4_ as String);
            }
            else
            {
               this.refreshAccessoryLabel(_loc4_.toString());
            }
            return DisplayObject(this.accessoryLabel);
         }
         if(this._accessoryLabelField !== null && param1 !== null && param1.hasOwnProperty(this._accessoryLabelField))
         {
            _loc4_ = param1[this._accessoryLabelField];
            if(_loc4_ is String)
            {
               this.refreshAccessoryLabel(_loc4_ as String);
            }
            else
            {
               this.refreshAccessoryLabel(_loc4_.toString());
            }
            return DisplayObject(this.accessoryLabel);
         }
         if(this._accessoryFunction !== null)
         {
            if(this is IListItemRenderer && this._accessoryFunction.length == 2)
            {
               return this._accessoryFunction(param1,IListItemRenderer(this).index) as DisplayObject;
            }
            if(this is IGroupedListItemRenderer && this._accessoryFunction.length == 3)
            {
               _loc3_ = IGroupedListItemRenderer(this);
               return this._accessoryFunction(param1,_loc3_.groupIndex,_loc3_.itemIndex) as DisplayObject;
            }
            return this._accessoryFunction(param1) as DisplayObject;
         }
         if(this._accessoryField !== null && param1 !== null && param1.hasOwnProperty(this._accessoryField))
         {
            return param1[this._accessoryField] as DisplayObject;
         }
         return null;
      }
      
      protected function itemToSkin(param1:Object) : DisplayObject
      {
         var _loc2_:Object = null;
         var _loc3_:IGroupedListItemRenderer = null;
         if(this._skinSourceFunction !== null)
         {
            if(this is IListItemRenderer && this._skinSourceFunction.length == 2)
            {
               _loc2_ = this._skinSourceFunction(param1,IListItemRenderer(this).index);
            }
            else if(this is IGroupedListItemRenderer && this._skinSourceFunction.length == 3)
            {
               _loc3_ = IGroupedListItemRenderer(this);
               _loc2_ = this._skinSourceFunction(param1,_loc3_.groupIndex,_loc3_.itemIndex);
            }
            else
            {
               _loc2_ = this._skinSourceFunction(param1);
            }
            this.refreshSkinSource(_loc2_);
            return this.skinLoader;
         }
         if(this._skinSourceField !== null && param1 !== null && param1.hasOwnProperty(this._skinSourceField))
         {
            _loc2_ = param1[this._skinSourceField];
            this.refreshSkinSource(_loc2_);
            return this.skinLoader;
         }
         if(this._skinFunction !== null)
         {
            if(this is IListItemRenderer && this._skinFunction.length == 2)
            {
               return this._skinFunction(param1,IListItemRenderer(this).index) as DisplayObject;
            }
            if(this is IGroupedListItemRenderer && this._skinFunction.length == 3)
            {
               _loc3_ = IGroupedListItemRenderer(this);
               return this._skinFunction(param1,_loc3_.groupIndex,_loc3_.itemIndex) as DisplayObject;
            }
            return this._skinFunction(param1) as DisplayObject;
         }
         if(this._skinField !== null && param1 !== null && param1.hasOwnProperty(this._skinField))
         {
            return param1[this._skinField] as DisplayObject;
         }
         return null;
      }
      
      protected function itemToSelectable(param1:Object) : Boolean
      {
         var _loc2_:IGroupedListItemRenderer = null;
         if(this._selectableFunction !== null)
         {
            if(this is IListItemRenderer && this._selectableFunction.length == 2)
            {
               return this._selectableFunction(param1,IListItemRenderer(this).index) as Boolean;
            }
            if(this is IGroupedListItemRenderer && this._selectableFunction.length == 3)
            {
               _loc2_ = IGroupedListItemRenderer(this);
               return this._selectableFunction(param1,_loc2_.groupIndex,_loc2_.itemIndex) as Boolean;
            }
            return this._selectableFunction(param1) as Boolean;
         }
         if(this._selectableField !== null && param1 !== null && param1.hasOwnProperty(this._selectableField))
         {
            return param1[this._selectableField] as Boolean;
         }
         return true;
      }
      
      protected function itemToEnabled(param1:Object) : Boolean
      {
         var _loc2_:IGroupedListItemRenderer = null;
         if(this._enabledFunction !== null)
         {
            if(this is IListItemRenderer && this._enabledFunction.length == 2)
            {
               return this._enabledFunction(param1,IListItemRenderer(this).index) as Boolean;
            }
            if(this is IGroupedListItemRenderer && this._enabledFunction.length == 3)
            {
               _loc2_ = IGroupedListItemRenderer(this);
               return this._enabledFunction(param1,_loc2_.groupIndex,_loc2_.itemIndex) as Boolean;
            }
            return this._enabledFunction(param1) as Boolean;
         }
         if(this._enabledField !== null && param1 !== null && param1.hasOwnProperty(this._enabledField))
         {
            return param1[this._enabledField] as Boolean;
         }
         return true;
      }
      
      public function getIconLabelFontStylesForState(param1:String) : TextFormat
      {
         if(this._iconLabelFontStylesSet === null)
         {
            return null;
         }
         return this._iconLabelFontStylesSet.getFormatForState(param1);
      }
      
      public function setIconLabelFontStylesForState(param1:String, param2:TextFormat) : void
      {
         var key:String = null;
         var changeHandler:Function = null;
         var state:String = param1;
         var format:TextFormat = param2;
         changeHandler = function(param1:Event):void
         {
            processStyleRestriction(key);
         };
         key = "setIconLabelFontStylesForState--" + state;
         if(this.processStyleRestriction(key))
         {
            return;
         }
         if(format !== null)
         {
            format.removeEventListener(Event.CHANGE,changeHandler);
         }
         this._iconLabelFontStylesSet.setFormatForState(state,format);
         if(format !== null)
         {
            format.addEventListener(Event.CHANGE,changeHandler);
         }
      }
      
      public function getAccessoryLabelFontStylesForState(param1:String) : TextFormat
      {
         if(this._accessoryLabelFontStylesSet === null)
         {
            return null;
         }
         return this._accessoryLabelFontStylesSet.getFormatForState(param1);
      }
      
      public function setAccessoryLabelFontStylesForState(param1:String, param2:TextFormat) : void
      {
         var key:String = null;
         var changeHandler:Function = null;
         var state:String = param1;
         var format:TextFormat = param2;
         changeHandler = function(param1:Event):void
         {
            processStyleRestriction(key);
         };
         key = "setAccessoryLabelFontStylesForState--" + state;
         if(this.processStyleRestriction(key))
         {
            return;
         }
         if(format !== null)
         {
            format.removeEventListener(Event.CHANGE,changeHandler);
         }
         this._accessoryLabelFontStylesSet.setFormatForState(state,format);
         if(format !== null)
         {
            format.addEventListener(Event.CHANGE,changeHandler);
         }
      }
      
      public function getAccessoryForState(param1:String) : DisplayObject
      {
         return this._stateToAccessory[param1] as DisplayObject;
      }
      
      public function setAccessoryForState(param1:String, param2:DisplayObject) : void
      {
         if(param2 !== null)
         {
            this._stateToAccessory[param1] = param2;
         }
         else
         {
            delete this._stateToAccessory[param1];
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      override protected function initialize() : void
      {
         if(this.touchToState === null && this._useStateDelayTimer)
         {
            this.touchToState = new DelayedDownTouchToState(this,this.changeState);
         }
         super.initialize();
         this.tapToTrigger.customHitTest = this.hitTestWithAccessory;
         this.tapToSelect.customHitTest = this.hitTestWithAccessory;
         this.longPress.customHitTest = this.hitTestWithAccessory;
         this.touchToState.customHitTest = this.hitTestWithAccessory;
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         if(_loc2_)
         {
            this.commitData();
         }
         if(_loc1_ || _loc2_ || _loc3_)
         {
            this.refreshAccessory();
         }
         this.refreshOffsets();
         super.draw();
      }
      
      override protected function autoSizeIfNeeded() : Boolean
      {
         var _loc1_:Boolean = this._explicitWidth !== this._explicitWidth;
         var _loc2_:Boolean = this._explicitHeight !== this._explicitHeight;
         var _loc3_:Boolean = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc4_:Boolean = this._explicitMinHeight !== this._explicitMinHeight;
         if(!_loc1_ && !_loc2_ && !_loc3_ && !_loc4_)
         {
            return false;
         }
         var _loc5_:Boolean = this._ignoreAccessoryResizes;
         this._ignoreAccessoryResizes = true;
         var _loc6_:ITextRenderer = null;
         if(this._label !== null && this.labelTextRenderer !== null)
         {
            _loc6_ = this.labelTextRenderer;
            this.refreshLabelTextRendererDimensions(true);
            this.labelTextRenderer.measureText(HELPER_POINT);
         }
         if(this.currentIcon is IValidating)
         {
            IValidating(this.currentIcon).validate();
         }
         if(this.currentAccessory is IValidating)
         {
            IValidating(this.currentAccessory).validate();
         }
         resetFluidChildDimensionsForMeasurement(this.currentSkin,this._explicitWidth,this._explicitHeight,this._explicitMinWidth,this._explicitMinHeight,this._explicitMaxWidth,this._explicitMaxHeight,this._explicitSkinWidth,this._explicitSkinHeight,this._explicitSkinMinWidth,this._explicitSkinMinHeight,this._explicitSkinMaxWidth,this._explicitSkinMaxHeight);
         var _loc7_:IMeasureDisplayObject = this.currentSkin as IMeasureDisplayObject;
         var _loc8_:Number = this._explicitWidth;
         if(_loc1_)
         {
            if(_loc6_ !== null)
            {
               _loc8_ = HELPER_POINT.x;
            }
            else
            {
               _loc8_ = 0;
            }
            if(this._layoutOrder === ItemRendererLayoutOrder.LABEL_ACCESSORY_ICON)
            {
               _loc8_ = this.addAccessoryWidth(_loc8_);
               _loc8_ = this.addIconWidth(_loc8_);
            }
            else
            {
               _loc8_ = this.addIconWidth(_loc8_);
               _loc8_ = this.addAccessoryWidth(_loc8_);
            }
            _loc8_ += this._leftOffset + this._rightOffset;
            if(this.currentSkin !== null && this.currentSkin.width > _loc8_)
            {
               _loc8_ = this.currentSkin.width;
            }
         }
         var _loc9_:Number = this._explicitHeight;
         if(_loc2_)
         {
            if(_loc6_ !== null)
            {
               _loc9_ = HELPER_POINT.y;
            }
            else
            {
               _loc9_ = 0;
            }
            if(this._layoutOrder === ItemRendererLayoutOrder.LABEL_ACCESSORY_ICON)
            {
               _loc9_ = this.addAccessoryHeight(_loc9_);
               _loc9_ = this.addIconHeight(_loc9_);
            }
            else
            {
               _loc9_ = this.addIconHeight(_loc9_);
               _loc9_ = this.addAccessoryHeight(_loc9_);
            }
            _loc9_ += this._topOffset + this._bottomOffset;
            if(this.currentSkin !== null && this.currentSkin.height > _loc9_)
            {
               _loc9_ = this.currentSkin.height;
            }
         }
         var _loc10_:Number = this._explicitMinWidth;
         if(_loc3_)
         {
            if(_loc6_ !== null)
            {
               _loc10_ = HELPER_POINT.x;
            }
            else
            {
               _loc10_ = 0;
            }
            if(this._layoutOrder === ItemRendererLayoutOrder.LABEL_ACCESSORY_ICON)
            {
               _loc10_ = this.addAccessoryWidth(_loc10_);
               _loc10_ = this.addIconWidth(_loc10_);
            }
            else
            {
               _loc10_ = this.addIconWidth(_loc10_);
               _loc10_ = this.addAccessoryWidth(_loc10_);
            }
            _loc10_ += this._leftOffset + this._rightOffset;
            if(this.currentSkin !== null)
            {
               if(_loc7_ !== null)
               {
                  if(_loc7_.minWidth > _loc10_)
                  {
                     _loc10_ = _loc7_.minWidth;
                  }
               }
               else if(this._explicitSkinMinWidth > _loc10_)
               {
                  _loc10_ = this._explicitSkinMinWidth;
               }
            }
         }
         var _loc11_:Number = this._explicitMinHeight;
         if(_loc4_)
         {
            if(_loc6_ !== null)
            {
               _loc11_ = HELPER_POINT.y;
            }
            else
            {
               _loc11_ = 0;
            }
            if(this._layoutOrder === ItemRendererLayoutOrder.LABEL_ACCESSORY_ICON)
            {
               _loc11_ = this.addAccessoryHeight(_loc11_);
               _loc11_ = this.addIconHeight(_loc11_);
            }
            else
            {
               _loc11_ = this.addIconHeight(_loc11_);
               _loc11_ = this.addAccessoryHeight(_loc11_);
            }
            _loc11_ += this._topOffset + this._bottomOffset;
            if(this.currentSkin !== null)
            {
               if(_loc7_ !== null)
               {
                  if(_loc7_.minHeight > _loc11_)
                  {
                     _loc11_ = _loc7_.minHeight;
                  }
               }
               else if(this._explicitSkinMinHeight > _loc11_)
               {
                  _loc11_ = this._explicitSkinMinHeight;
               }
            }
         }
         this._ignoreAccessoryResizes = _loc5_;
         return this.saveMeasurements(_loc8_,_loc9_,_loc10_,_loc11_);
      }
      
      override protected function changeState(param1:String) : void
      {
         if(this._isEnabled && !this._isToggle && (!this.isSelectableWithoutToggle || this._itemHasSelectable && !this.itemToSelectable(this._data)))
         {
            param1 = ButtonState.UP;
         }
         super.changeState(param1);
      }
      
      protected function addIconWidth(param1:Number) : Number
      {
         var _loc4_:Number = NaN;
         if(!this.currentIcon)
         {
            return param1;
         }
         var _loc2_:Number = this.currentIcon.width;
         if(_loc2_ !== _loc2_)
         {
            return param1;
         }
         var _loc3_:Boolean = param1 === param1;
         if(!_loc3_)
         {
            param1 = 0;
         }
         if(this._iconPosition == RelativePosition.LEFT || this._iconPosition == RelativePosition.LEFT_BASELINE || this._iconPosition == RelativePosition.RIGHT || this._iconPosition == RelativePosition.RIGHT_BASELINE)
         {
            if(_loc3_)
            {
               _loc4_ = this._gap;
               if(this._gap == Number.POSITIVE_INFINITY)
               {
                  _loc4_ = this._minGap;
               }
               param1 += _loc4_;
            }
            param1 += _loc2_;
         }
         else if(_loc2_ > param1)
         {
            param1 = _loc2_;
         }
         return param1;
      }
      
      protected function addAccessoryWidth(param1:Number) : Number
      {
         var _loc4_:Number = NaN;
         if(!this.currentAccessory)
         {
            return param1;
         }
         var _loc2_:Number = this.currentAccessory.width;
         if(_loc2_ !== _loc2_)
         {
            return param1;
         }
         var _loc3_:Boolean = param1 === param1;
         if(!_loc3_)
         {
            param1 = 0;
         }
         if(this._accessoryPosition == RelativePosition.LEFT || this._accessoryPosition == RelativePosition.RIGHT)
         {
            if(_loc3_)
            {
               _loc4_ = this._accessoryGap;
               if(this._accessoryGap !== this._accessoryGap)
               {
                  _loc4_ = this._gap;
               }
               if(_loc4_ == Number.POSITIVE_INFINITY)
               {
                  if(this._minAccessoryGap !== this._minAccessoryGap)
                  {
                     _loc4_ = this._minGap;
                  }
                  else
                  {
                     _loc4_ = this._minAccessoryGap;
                  }
               }
               param1 += _loc4_;
            }
            param1 += _loc2_;
         }
         else if(_loc2_ > param1)
         {
            param1 = _loc2_;
         }
         return param1;
      }
      
      protected function addIconHeight(param1:Number) : Number
      {
         var _loc4_:Number = NaN;
         if(this.currentIcon === null)
         {
            return param1;
         }
         var _loc2_:Number = this.currentIcon.height;
         if(_loc2_ !== _loc2_)
         {
            return param1;
         }
         var _loc3_:Boolean = param1 === param1;
         if(!_loc3_)
         {
            param1 = 0;
         }
         if(this._iconPosition === RelativePosition.TOP || this._iconPosition === RelativePosition.BOTTOM)
         {
            if(_loc3_)
            {
               _loc4_ = this._gap;
               if(this._gap == Number.POSITIVE_INFINITY)
               {
                  _loc4_ = this._minGap;
               }
               param1 += _loc4_;
            }
            param1 += _loc2_;
         }
         else if(_loc2_ > param1)
         {
            param1 = _loc2_;
         }
         return param1;
      }
      
      protected function addAccessoryHeight(param1:Number) : Number
      {
         var _loc4_:Number = NaN;
         if(this.currentAccessory === null)
         {
            return param1;
         }
         var _loc2_:Number = this.currentAccessory.height;
         if(_loc2_ !== _loc2_)
         {
            return param1;
         }
         var _loc3_:Boolean = param1 === param1;
         if(!_loc3_)
         {
            param1 = 0;
         }
         if(this._accessoryPosition === RelativePosition.TOP || this._accessoryPosition === RelativePosition.BOTTOM)
         {
            if(_loc3_)
            {
               _loc4_ = this._accessoryGap;
               if(this._accessoryGap !== this._accessoryGap)
               {
                  _loc4_ = this._gap;
               }
               if(_loc4_ == Number.POSITIVE_INFINITY)
               {
                  if(this._minAccessoryGap !== this._minAccessoryGap)
                  {
                     _loc4_ = this._minGap;
                  }
                  else
                  {
                     _loc4_ = this._minAccessoryGap;
                  }
               }
               param1 += _loc4_;
            }
            param1 += _loc2_;
         }
         else if(_loc2_ > param1)
         {
            param1 = _loc2_;
         }
         return param1;
      }
      
      protected function getDataToRender() : Object
      {
         return this._data;
      }
      
      protected function commitData() : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:DisplayObject = null;
         var _loc4_:DisplayObject = null;
         var _loc1_:Object = this.getDataToRender();
         if(_loc1_ !== null)
         {
            if(this._itemHasLabel)
            {
               this._label = this.itemToLabel(_loc1_);
            }
            if(this._itemHasSkin)
            {
               _loc2_ = this.itemToSkin(_loc1_);
               this._skinIsFromItem = _loc2_ != null;
               this.replaceSkin(_loc2_);
            }
            else if(this._skinIsFromItem)
            {
               this._skinIsFromItem = false;
               this.replaceSkin(null);
            }
            if(this._itemHasIcon)
            {
               _loc3_ = this.itemToIcon(_loc1_);
               this._iconIsFromItem = _loc3_ != null;
               this.replaceIcon(_loc3_);
            }
            else if(this._iconIsFromItem)
            {
               this._iconIsFromItem = false;
               this.replaceIcon(null);
            }
            if(this._itemHasAccessory)
            {
               _loc4_ = this.itemToAccessory(_loc1_);
               this._accessoryIsFromItem = _loc4_ != null;
               this.replaceAccessory(_loc4_);
            }
            else if(this._accessoryIsFromItem)
            {
               this._accessoryIsFromItem = false;
               this.replaceAccessory(null);
            }
            if(this._itemHasSelectable)
            {
               this._isToggle = this._explicitIsToggle && this.itemToSelectable(_loc1_);
            }
            else
            {
               this._isToggle = this._explicitIsToggle;
            }
            if(this._itemHasEnabled)
            {
               this.refreshIsEnabled(this._explicitIsEnabled && this.itemToEnabled(_loc1_));
            }
            else
            {
               this.refreshIsEnabled(this._explicitIsEnabled);
            }
         }
         else
         {
            if(this._itemHasLabel)
            {
               this._label = "";
            }
            if(this._itemHasIcon || this._iconIsFromItem)
            {
               this._iconIsFromItem = false;
               this.replaceIcon(null);
            }
            if(this._itemHasSkin || this._skinIsFromItem)
            {
               this._skinIsFromItem = false;
               this.replaceSkin(null);
            }
            if(this._itemHasAccessory || this._accessoryIsFromItem)
            {
               this._accessoryIsFromItem = false;
               this.replaceAccessory(null);
            }
            if(this._itemHasSelectable)
            {
               this._isToggle = this._explicitIsToggle;
            }
            if(this._itemHasEnabled)
            {
               this.refreshIsEnabled(this._explicitIsEnabled);
            }
         }
      }
      
      protected function refreshIsEnabled(param1:Boolean) : void
      {
         if(this._isEnabled == param1)
         {
            return;
         }
         this._isEnabled = param1;
         if(this._isEnabled)
         {
            if(this._currentState == ButtonState.DISABLED)
            {
               this._currentState = ButtonState.UP;
            }
            this.touchable = true;
         }
         else
         {
            this._currentState = ButtonState.DISABLED;
            this.touchable = false;
         }
         this.setInvalidationFlag(INVALIDATION_FLAG_STATE);
         this.dispatchEventWith(FeathersEventType.STATE_CHANGE);
      }
      
      protected function replaceIcon(param1:DisplayObject) : void
      {
         if(Boolean(this.iconLoader) && this.iconLoader != param1)
         {
            this.iconLoader.removeEventListener(Event.COMPLETE,this.loader_completeOrErrorHandler);
            this.iconLoader.removeEventListener(FeathersEventType.ERROR,this.loader_completeOrErrorHandler);
            this.iconLoader.dispose();
            this.iconLoader = null;
         }
         if(Boolean(this.iconLabel) && this.iconLabel != param1)
         {
            this.iconLabel.dispose();
            this.iconLabel = null;
         }
         if(Boolean(this._itemHasIcon && this.currentIcon) && Boolean(this.currentIcon != param1) && this.currentIcon.parent == this)
         {
            this.currentIcon.removeFromParent(false);
            this.currentIcon = null;
         }
         if(this._defaultIcon !== param1)
         {
            this._defaultIcon = param1;
            this.setInvalidationFlag(INVALIDATION_FLAG_STYLES);
         }
         if(this.iconLoader !== null)
         {
            this.iconLoader.delayTextureCreation = this._delayTextureCreationOnScroll && this._owner !== null && this._owner.isScrolling;
         }
      }
      
      protected function replaceAccessory(param1:DisplayObject) : void
      {
         if(Boolean(this.accessoryLoader) && this.accessoryLoader != param1)
         {
            this.accessoryLoader.removeEventListener(Event.COMPLETE,this.loader_completeOrErrorHandler);
            this.accessoryLoader.removeEventListener(FeathersEventType.ERROR,this.loader_completeOrErrorHandler);
            this.accessoryLoader.dispose();
            this.accessoryLoader = null;
         }
         if(Boolean(this.accessoryLabel) && this.accessoryLabel != param1)
         {
            this.accessoryLabel.dispose();
            this.accessoryLabel = null;
         }
         if(Boolean(this._itemHasAccessory && this.currentAccessory) && Boolean(this.currentAccessory != param1) && this.currentAccessory.parent == this)
         {
            this.currentAccessory.removeFromParent(false);
            this.currentAccessory = null;
         }
         if(this._defaultAccessory !== param1)
         {
            this._defaultAccessory = param1;
            this.setInvalidationFlag(INVALIDATION_FLAG_STYLES);
         }
         if(this.accessoryLoader !== null)
         {
            this.accessoryLoader.delayTextureCreation = this._delayTextureCreationOnScroll && this._owner !== null && this._owner.isScrolling;
         }
      }
      
      protected function replaceSkin(param1:DisplayObject) : void
      {
         if(Boolean(this.skinLoader) && this.skinLoader != param1)
         {
            this.skinLoader.removeEventListener(Event.COMPLETE,this.loader_completeOrErrorHandler);
            this.skinLoader.removeEventListener(FeathersEventType.ERROR,this.loader_completeOrErrorHandler);
            this.skinLoader.dispose();
            this.skinLoader = null;
         }
         if(Boolean(this._itemHasSkin && this.currentSkin) && Boolean(this.currentSkin != param1) && this.currentSkin.parent == this)
         {
            this.currentSkin.removeFromParent(false);
            this.currentSkin = null;
         }
         if(this._defaultSkin !== param1)
         {
            this._defaultSkin = param1;
            this.setInvalidationFlag(INVALIDATION_FLAG_STYLES);
         }
         if(this.skinLoader !== null)
         {
            this.skinLoader.delayTextureCreation = this._delayTextureCreationOnScroll && this._owner !== null && this._owner.isScrolling;
         }
      }
      
      override protected function refreshIcon() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:String = null;
         var _loc3_:Object = null;
         super.refreshIcon();
         if(this.iconLabel !== null)
         {
            this.iconLabel.fontStyles = this._iconLabelFontStylesSet;
            _loc1_ = DisplayObject(this.iconLabel);
            for(_loc2_ in this._iconLabelProperties)
            {
               _loc3_ = this._iconLabelProperties[_loc2_];
               _loc1_[_loc2_] = _loc3_;
            }
         }
      }
      
      protected function refreshAccessory() : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc1_:DisplayObject = this.currentAccessory;
         this.currentAccessory = this.getCurrentAccessory();
         if(this.currentAccessory is IFeathersControl)
         {
            IFeathersControl(this.currentAccessory).isEnabled = this._isEnabled;
         }
         if(this.currentAccessory != _loc1_)
         {
            if(_loc1_)
            {
               if(_loc1_ is IStateObserver)
               {
                  IStateObserver(_loc1_).stateContext = null;
               }
               if(_loc1_ is IFeathersControl)
               {
                  IFeathersControl(_loc1_).removeEventListener(FeathersEventType.RESIZE,this.accessory_resizeHandler);
                  IFeathersControl(_loc1_).removeEventListener(TouchEvent.TOUCH,this.accessory_touchHandler);
               }
               this.removeChild(_loc1_,false);
            }
            if(this.currentAccessory)
            {
               if(this.currentAccessory is IStateObserver)
               {
                  IStateObserver(this.currentAccessory).stateContext = this;
               }
               this.addChild(this.currentAccessory);
               if(this.currentAccessory is IFeathersControl)
               {
                  IFeathersControl(this.currentAccessory).addEventListener(FeathersEventType.RESIZE,this.accessory_resizeHandler);
                  IFeathersControl(this.currentAccessory).addEventListener(TouchEvent.TOUCH,this.accessory_touchHandler);
               }
            }
         }
         if(this.accessoryLabel !== null)
         {
            this.accessoryLabel.fontStyles = this._accessoryLabelFontStylesSet;
            _loc2_ = DisplayObject(this.accessoryLabel);
            for(_loc3_ in this._accessoryLabelProperties)
            {
               _loc4_ = this._accessoryLabelProperties[_loc3_];
               _loc2_[_loc3_] = _loc4_;
            }
         }
      }
      
      protected function getCurrentAccessory() : DisplayObject
      {
         var _loc1_:DisplayObject = this._stateToAccessory[this.currentState] as DisplayObject;
         if(_loc1_ !== null)
         {
            return _loc1_;
         }
         return this._defaultAccessory;
      }
      
      protected function refreshIconSource(param1:Object) : void
      {
         var _loc2_:String = null;
         if(!this.iconLoader)
         {
            this.iconLoader = this._iconLoaderFactory();
            this.iconLoader.addEventListener(Event.COMPLETE,this.loader_completeOrErrorHandler);
            this.iconLoader.addEventListener(Event.IO_ERROR,this.loader_completeOrErrorHandler);
            this.iconLoader.addEventListener(Event.SECURITY_ERROR,this.loader_completeOrErrorHandler);
            _loc2_ = this._customIconLoaderStyleName != null ? this._customIconLoaderStyleName : this.iconLoaderStyleName;
            this.iconLoader.styleNameList.add(_loc2_);
         }
         this.iconLoader.source = param1;
      }
      
      protected function refreshIconLabel(param1:String) : void
      {
         var _loc2_:Function = null;
         var _loc3_:String = null;
         if(this.iconLabel === null)
         {
            _loc2_ = this._iconLabelFactory != null ? this._iconLabelFactory : FeathersControl.defaultTextRendererFactory;
            this.iconLabel = ITextRenderer(_loc2_());
            if(this.iconLabel is IStateObserver)
            {
               IStateObserver(this.iconLabel).stateContext = this;
            }
            _loc3_ = this._customIconLabelStyleName != null ? this._customIconLabelStyleName : this.iconLabelStyleName;
            this.iconLabel.styleNameList.add(_loc3_);
         }
         this.iconLabel.text = param1;
      }
      
      protected function refreshAccessorySource(param1:Object) : void
      {
         var _loc2_:String = null;
         if(!this.accessoryLoader)
         {
            this.accessoryLoader = this._accessoryLoaderFactory();
            this.accessoryLoader.addEventListener(Event.COMPLETE,this.loader_completeOrErrorHandler);
            this.accessoryLoader.addEventListener(Event.IO_ERROR,this.loader_completeOrErrorHandler);
            this.accessoryLoader.addEventListener(Event.SECURITY_ERROR,this.loader_completeOrErrorHandler);
            _loc2_ = this._customAccessoryLoaderStyleName != null ? this._customAccessoryLoaderStyleName : this.accessoryLoaderStyleName;
            this.accessoryLoader.styleNameList.add(_loc2_);
         }
         this.accessoryLoader.source = param1;
      }
      
      protected function refreshAccessoryLabel(param1:String) : void
      {
         var _loc2_:Function = null;
         var _loc3_:String = null;
         if(this.accessoryLabel === null)
         {
            _loc2_ = this._accessoryLabelFactory != null ? this._accessoryLabelFactory : FeathersControl.defaultTextRendererFactory;
            this.accessoryLabel = ITextRenderer(_loc2_());
            if(this.accessoryLabel is IStateObserver)
            {
               IStateObserver(this.accessoryLabel).stateContext = this;
            }
            _loc3_ = this._customAccessoryLabelStyleName != null ? this._customAccessoryLabelStyleName : this.accessoryLabelStyleName;
            this.accessoryLabel.styleNameList.add(_loc3_);
         }
         this.accessoryLabel.text = param1;
      }
      
      protected function refreshSkinSource(param1:Object) : void
      {
         if(!this.skinLoader)
         {
            this.skinLoader = this._skinLoaderFactory();
            this.skinLoader.addEventListener(Event.COMPLETE,this.loader_completeOrErrorHandler);
            this.skinLoader.addEventListener(FeathersEventType.ERROR,this.loader_completeOrErrorHandler);
         }
         this.skinLoader.source = param1;
      }
      
      override protected function layoutContent() : void
      {
         var _loc7_:String = null;
         var _loc1_:Boolean = this._ignoreAccessoryResizes;
         this._ignoreAccessoryResizes = true;
         var _loc2_:Boolean = this._ignoreIconResizes;
         this._ignoreIconResizes = true;
         this.refreshLabelTextRendererDimensions(false);
         var _loc3_:DisplayObject = null;
         if(this._label !== null && this.labelTextRenderer !== null)
         {
            _loc3_ = DisplayObject(this.labelTextRenderer);
         }
         var _loc4_:Boolean = Boolean(this.currentIcon) && this._iconPosition != RelativePosition.MANUAL;
         var _loc5_:Boolean = Boolean(this.currentAccessory) && this._accessoryPosition != RelativePosition.MANUAL;
         var _loc6_:Number = this._accessoryGap;
         if(_loc6_ !== _loc6_)
         {
            _loc6_ = this._gap;
         }
         if(Boolean(_loc3_) && Boolean(_loc4_) && _loc5_)
         {
            this.positionSingleChild(_loc3_);
            if(this._layoutOrder == ItemRendererLayoutOrder.LABEL_ACCESSORY_ICON)
            {
               this.positionRelativeToOthers(this.currentAccessory,_loc3_,null,this._accessoryPosition,_loc6_,null,0);
               _loc7_ = this._iconPosition;
               if(_loc7_ == RelativePosition.LEFT_BASELINE)
               {
                  _loc7_ = RelativePosition.LEFT;
               }
               else if(_loc7_ == RelativePosition.RIGHT_BASELINE)
               {
                  _loc7_ = RelativePosition.RIGHT;
               }
               this.positionRelativeToOthers(this.currentIcon,_loc3_,this.currentAccessory,_loc7_,this._gap,this._accessoryPosition,_loc6_);
            }
            else
            {
               this.positionLabelAndIcon();
               this.positionRelativeToOthers(this.currentAccessory,_loc3_,this.currentIcon,this._accessoryPosition,_loc6_,this._iconPosition,this._gap);
            }
         }
         else if(_loc3_)
         {
            this.positionSingleChild(_loc3_);
            if(_loc4_)
            {
               this.positionLabelAndIcon();
            }
            else if(_loc5_)
            {
               this.positionRelativeToOthers(this.currentAccessory,_loc3_,null,this._accessoryPosition,_loc6_,null,0);
            }
         }
         else if(_loc4_)
         {
            this.positionSingleChild(this.currentIcon);
            if(_loc5_)
            {
               this.positionRelativeToOthers(this.currentAccessory,this.currentIcon,null,this._accessoryPosition,_loc6_,null,0);
            }
         }
         else if(_loc5_)
         {
            this.positionSingleChild(this.currentAccessory);
         }
         if(this.currentAccessory)
         {
            if(!_loc5_)
            {
               this.currentAccessory.x = this._leftOffset;
               this.currentAccessory.y = this._topOffset;
            }
            this.currentAccessory.x += this._accessoryOffsetX;
            this.currentAccessory.y += this._accessoryOffsetY;
         }
         if(this.currentIcon)
         {
            if(!_loc4_)
            {
               this.currentIcon.x = this._leftOffset;
               this.currentIcon.y = this._topOffset;
            }
            this.currentIcon.x += this._iconOffsetX;
            this.currentIcon.y += this._iconOffsetY;
         }
         if(_loc3_)
         {
            this.labelTextRenderer.x += this._labelOffsetX;
            this.labelTextRenderer.y += this._labelOffsetY;
         }
         this._ignoreIconResizes = _loc2_;
         this._ignoreAccessoryResizes = _loc1_;
      }
      
      protected function refreshOffsets() : void
      {
         this._topOffset = this._paddingTop;
         this._rightOffset = this._paddingRight;
         this._bottomOffset = this._paddingBottom;
         this._leftOffset = this._paddingLeft;
      }
      
      override protected function refreshLabelTextRendererDimensions(param1:Boolean) : void
      {
         var _loc11_:Boolean = false;
         var _loc12_:Boolean = false;
         var _loc2_:Boolean = this._ignoreIconResizes;
         this._ignoreIconResizes = true;
         var _loc3_:Number = this.actualWidth;
         if(param1)
         {
            _loc3_ = this._explicitWidth;
            if(_loc3_ !== _loc3_)
            {
               _loc3_ = this._explicitMaxWidth;
            }
         }
         _loc3_ -= this._leftOffset + this._rightOffset;
         var _loc4_:Number = this.actualHeight;
         if(param1)
         {
            _loc4_ = this._explicitHeight;
            if(_loc4_ !== _loc4_)
            {
               _loc4_ = this._explicitMaxHeight;
            }
         }
         _loc4_ -= this._topOffset + this._bottomOffset;
         var _loc5_:Number = this._gap;
         if(_loc5_ == Number.POSITIVE_INFINITY)
         {
            _loc5_ = this._minGap;
         }
         var _loc6_:Number = this._accessoryGap;
         if(_loc6_ !== _loc6_)
         {
            _loc6_ = this._gap;
         }
         if(_loc6_ == Number.POSITIVE_INFINITY)
         {
            _loc6_ = this._minAccessoryGap;
            if(_loc6_ !== _loc6_)
            {
               _loc6_ = this._minGap;
            }
         }
         var _loc7_:Boolean = Boolean(this.currentIcon) && (this._iconPosition == RelativePosition.LEFT || this._iconPosition == RelativePosition.LEFT_BASELINE || this._iconPosition == RelativePosition.RIGHT || this._iconPosition == RelativePosition.RIGHT_BASELINE);
         var _loc8_:Boolean = Boolean(this.currentIcon) && (this._iconPosition == RelativePosition.TOP || this._iconPosition == RelativePosition.BOTTOM);
         var _loc9_:Boolean = Boolean(this.currentAccessory) && (this._accessoryPosition == RelativePosition.LEFT || this._accessoryPosition == RelativePosition.RIGHT);
         var _loc10_:Boolean = Boolean(this.currentAccessory) && (this._accessoryPosition == RelativePosition.TOP || this._accessoryPosition == RelativePosition.BOTTOM);
         if(this.accessoryLabel)
         {
            _loc11_ = _loc7_ && (_loc9_ || this._layoutOrder === ItemRendererLayoutOrder.LABEL_ACCESSORY_ICON);
            if(this.iconLabel)
            {
               this.iconLabel.maxWidth = _loc3_ - _loc5_;
               if(this.iconLabel.maxWidth < 0)
               {
                  this.iconLabel.maxWidth = 0;
               }
            }
            if(this.currentIcon is IValidating)
            {
               IValidating(this.currentIcon).validate();
            }
            if(_loc11_)
            {
               _loc3_ -= this.currentIcon.width + _loc5_;
            }
            if(_loc3_ < 0)
            {
               _loc3_ = 0;
            }
            this.accessoryLabel.maxWidth = _loc3_;
            this.accessoryLabel.maxHeight = _loc4_;
            if(Boolean(_loc7_) && Boolean(this.currentIcon) && !_loc11_)
            {
               _loc3_ -= this.currentIcon.width + _loc5_;
            }
            if(this.currentAccessory is IValidating)
            {
               IValidating(this.currentAccessory).validate();
            }
            if(_loc9_)
            {
               _loc3_ -= this.currentAccessory.width + _loc6_;
            }
            if(_loc10_)
            {
               _loc4_ -= this.currentAccessory.height + _loc6_;
            }
         }
         else if(this.iconLabel)
         {
            _loc12_ = _loc9_ && (_loc7_ || this._layoutOrder === ItemRendererLayoutOrder.LABEL_ICON_ACCESSORY);
            if(this.currentAccessory is IValidating)
            {
               IValidating(this.currentAccessory).validate();
            }
            if(_loc12_)
            {
               _loc3_ -= _loc6_ + this.currentAccessory.width;
            }
            if(_loc3_ < 0)
            {
               _loc3_ = 0;
            }
            this.iconLabel.maxWidth = _loc3_;
            this.iconLabel.maxHeight = _loc4_;
            if(Boolean(_loc9_) && Boolean(this.currentAccessory) && !_loc12_)
            {
               _loc3_ -= _loc6_ + this.currentAccessory.width;
            }
            if(this.currentIcon is IValidating)
            {
               IValidating(this.currentIcon).validate();
            }
            if(_loc7_)
            {
               _loc3_ -= this.currentIcon.width + _loc5_;
            }
            if(_loc8_)
            {
               _loc4_ -= this.currentIcon.height + _loc5_;
            }
         }
         else
         {
            if(this.currentIcon is IValidating)
            {
               IValidating(this.currentIcon).validate();
            }
            if(_loc7_)
            {
               _loc3_ -= _loc5_ + this.currentIcon.width;
            }
            if(_loc8_)
            {
               _loc4_ -= _loc5_ + this.currentIcon.height;
            }
            if(this.currentAccessory is IValidating)
            {
               IValidating(this.currentAccessory).validate();
            }
            if(_loc9_)
            {
               _loc3_ -= _loc6_ + this.currentAccessory.width;
            }
            if(_loc10_)
            {
               _loc4_ -= _loc6_ + this.currentAccessory.height;
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
         if(this.labelTextRenderer !== null)
         {
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
         this._ignoreIconResizes = _loc2_;
      }
      
      override protected function positionSingleChild(param1:DisplayObject) : void
      {
         if(this._horizontalAlign === HorizontalAlign.LEFT)
         {
            param1.x = this._leftOffset;
         }
         else if(this._horizontalAlign === HorizontalAlign.RIGHT)
         {
            param1.x = this.actualWidth - this._rightOffset - param1.width;
         }
         else
         {
            param1.x = this._leftOffset + Math.round((this.actualWidth - this._leftOffset - this._rightOffset - param1.width) / 2);
         }
         if(this._verticalAlign === VerticalAlign.TOP)
         {
            param1.y = this._topOffset;
         }
         else if(this._verticalAlign === VerticalAlign.BOTTOM)
         {
            param1.y = this.actualHeight - this._bottomOffset - param1.height;
         }
         else
         {
            param1.y = this._topOffset + Math.round((this.actualHeight - this._topOffset - this._bottomOffset - param1.height) / 2);
         }
      }
      
      protected function positionRelativeToOthers(param1:DisplayObject, param2:DisplayObject, param3:DisplayObject, param4:String, param5:Number, param6:String, param7:Number) : void
      {
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc8_:Number = param2.x;
         if(param3 !== null && param3.x < _loc8_)
         {
            _loc8_ = param3.x;
         }
         var _loc9_:Number = param2.y;
         if(param3 !== null && param3.y < _loc9_)
         {
            _loc9_ = param3.y;
         }
         var _loc10_:Number = param2.width;
         if(param3 !== null)
         {
            _loc10_ = param2.x + param2.width;
            _loc16_ = param3.x + param3.width;
            if(_loc16_ > _loc10_)
            {
               _loc10_ = _loc16_;
            }
            _loc10_ -= _loc8_;
         }
         var _loc11_:Number = param2.height;
         if(param3 !== null)
         {
            _loc11_ = param2.y + param2.height;
            _loc17_ = param3.y + param3.height;
            if(_loc17_ > _loc11_)
            {
               _loc11_ = _loc17_;
            }
            _loc11_ -= _loc9_;
         }
         var _loc12_:Number = _loc8_;
         var _loc13_:Number = _loc9_;
         if(param4 == RelativePosition.TOP)
         {
            if(param5 == Number.POSITIVE_INFINITY)
            {
               param1.y = this._topOffset;
               _loc13_ = this.actualHeight - this._bottomOffset - _loc11_;
            }
            else
            {
               if(this._verticalAlign == VerticalAlign.TOP)
               {
                  _loc13_ += param1.height + param5;
               }
               else if(this._verticalAlign == VerticalAlign.MIDDLE)
               {
                  _loc13_ += Math.round((param1.height + param5) / 2);
               }
               if(param3 != null)
               {
                  _loc18_ = this._topOffset + param1.height + param5;
                  if(_loc18_ > _loc13_)
                  {
                     _loc13_ = _loc18_;
                  }
               }
               param1.y = _loc13_ - param1.height - param5;
            }
         }
         else if(param4 == RelativePosition.RIGHT)
         {
            if(param5 == Number.POSITIVE_INFINITY)
            {
               _loc12_ = this._leftOffset;
               param1.x = this.actualWidth - this._rightOffset - param1.width;
            }
            else
            {
               if(this._horizontalAlign == HorizontalAlign.RIGHT)
               {
                  _loc12_ -= param1.width + param5;
               }
               else if(this._horizontalAlign == HorizontalAlign.CENTER)
               {
                  _loc12_ -= Math.round((param1.width + param5) / 2);
               }
               if(param3 !== null)
               {
                  _loc19_ = this.actualWidth - this._rightOffset - param1.width - _loc10_ - param5;
                  if(_loc19_ < _loc12_)
                  {
                     _loc12_ = _loc19_;
                  }
               }
               param1.x = _loc12_ + _loc10_ + param5;
            }
         }
         else if(param4 == RelativePosition.BOTTOM)
         {
            if(param5 == Number.POSITIVE_INFINITY)
            {
               _loc13_ = this._topOffset;
               param1.y = this.actualHeight - this._bottomOffset - param1.height;
            }
            else
            {
               if(this._verticalAlign == VerticalAlign.BOTTOM)
               {
                  _loc13_ -= param1.height + param5;
               }
               else if(this._verticalAlign == VerticalAlign.MIDDLE)
               {
                  _loc13_ -= Math.round((param1.height + param5) / 2);
               }
               if(param3 !== null)
               {
                  _loc18_ = this.actualHeight - this._bottomOffset - param1.height - _loc11_ - param5;
                  if(_loc18_ < _loc13_)
                  {
                     _loc13_ = _loc18_;
                  }
               }
               param1.y = _loc13_ + _loc11_ + param5;
            }
         }
         else if(param4 == RelativePosition.LEFT)
         {
            if(param5 == Number.POSITIVE_INFINITY)
            {
               param1.x = this._leftOffset;
               _loc12_ = this.actualWidth - this._rightOffset - _loc10_;
            }
            else
            {
               if(this._horizontalAlign == HorizontalAlign.LEFT)
               {
                  _loc12_ += param5 + param1.width;
               }
               else if(this._horizontalAlign == HorizontalAlign.CENTER)
               {
                  _loc12_ += Math.round((param5 + param1.width) / 2);
               }
               if(param3 !== null)
               {
                  _loc19_ = this._leftOffset + param1.width + param5;
                  if(_loc19_ > _loc12_)
                  {
                     _loc12_ = _loc19_;
                  }
               }
               param1.x = _loc12_ - param5 - param1.width;
            }
         }
         var _loc14_:Number = _loc12_ - _loc8_;
         var _loc15_:Number = _loc13_ - _loc9_;
         if(!param3 || param7 != Number.POSITIVE_INFINITY || !(param4 == RelativePosition.TOP && param6 == RelativePosition.TOP || param4 == RelativePosition.RIGHT && param6 == RelativePosition.RIGHT || param4 == RelativePosition.BOTTOM && param6 == RelativePosition.BOTTOM || param4 == RelativePosition.LEFT && param6 == RelativePosition.LEFT))
         {
            param2.x += _loc14_;
            param2.y += _loc15_;
         }
         if(param3)
         {
            if(param7 != Number.POSITIVE_INFINITY || !(param4 == RelativePosition.LEFT && param6 == RelativePosition.RIGHT || param4 == RelativePosition.RIGHT && param6 == RelativePosition.LEFT || param4 == RelativePosition.TOP && param6 == RelativePosition.BOTTOM || param4 == RelativePosition.BOTTOM && param6 == RelativePosition.TOP))
            {
               param3.x += _loc14_;
               param3.y += _loc15_;
            }
            if(param5 == Number.POSITIVE_INFINITY && param7 == Number.POSITIVE_INFINITY)
            {
               if(param4 == RelativePosition.RIGHT && param6 == RelativePosition.LEFT)
               {
                  param2.x = param3.x + Math.round((param1.x - param3.x + param3.width - param2.width) / 2);
               }
               else if(param4 == RelativePosition.LEFT && param6 == RelativePosition.RIGHT)
               {
                  param2.x = param1.x + Math.round((param3.x - param1.x + param1.width - param2.width) / 2);
               }
               else if(param4 == RelativePosition.RIGHT && param6 == RelativePosition.RIGHT)
               {
                  param3.x = param2.x + Math.round((param1.x - param2.x + param2.width - param3.width) / 2);
               }
               else if(param4 == RelativePosition.LEFT && param6 == RelativePosition.LEFT)
               {
                  param3.x = param1.x + Math.round((param2.x - param1.x + param1.width - param3.width) / 2);
               }
               else if(param4 == RelativePosition.BOTTOM && param6 == RelativePosition.TOP)
               {
                  param2.y = param3.y + Math.round((param1.y - param3.y + param3.height - param2.height) / 2);
               }
               else if(param4 == RelativePosition.TOP && param6 == RelativePosition.BOTTOM)
               {
                  param2.y = param1.y + Math.round((param3.y - param1.y + param1.height - param2.height) / 2);
               }
               else if(param4 == RelativePosition.BOTTOM && param6 == RelativePosition.BOTTOM)
               {
                  param3.y = param2.y + Math.round((param1.y - param2.y + param2.height - param3.height) / 2);
               }
               else if(param4 == RelativePosition.TOP && param6 == RelativePosition.TOP)
               {
                  param3.y = param1.y + Math.round((param2.y - param1.y + param1.height - param3.height) / 2);
               }
            }
         }
         if(param4 == RelativePosition.LEFT || param4 == RelativePosition.RIGHT)
         {
            if(this._verticalAlign == VerticalAlign.TOP)
            {
               param1.y = this._topOffset;
            }
            else if(this._verticalAlign == VerticalAlign.BOTTOM)
            {
               param1.y = this.actualHeight - this._bottomOffset - param1.height;
            }
            else
            {
               param1.y = this._topOffset + Math.round((this.actualHeight - this._topOffset - this._bottomOffset - param1.height) / 2);
            }
         }
         else if(param4 == RelativePosition.TOP || param4 == RelativePosition.BOTTOM)
         {
            if(this._horizontalAlign == HorizontalAlign.LEFT)
            {
               param1.x = this._leftOffset;
            }
            else if(this._horizontalAlign == HorizontalAlign.RIGHT)
            {
               param1.x = this.actualWidth - this._rightOffset - param1.width;
            }
            else
            {
               param1.x = this._leftOffset + Math.round((this.actualWidth - this._leftOffset - this._rightOffset - param1.width) / 2);
            }
         }
      }
      
      override protected function refreshSelectionEvents() : void
      {
         var _loc1_:Boolean = this._isEnabled && (this._isToggle || this.isSelectableWithoutToggle);
         if(this._itemHasSelectable)
         {
            _loc1_ &&= this.itemToSelectable(this._data);
         }
         if(this.accessoryTouchPointID >= 0)
         {
            _loc1_ &&= this._isSelectableOnAccessoryTouch;
         }
         this.tapToSelect.isEnabled = _loc1_;
         this.tapToSelect.tapToDeselect = this._isToggle;
         this.keyToSelect.isEnabled = false;
      }
      
      protected function hitTestWithAccessory(param1:Point) : Boolean
      {
         var _loc2_:DisplayObjectContainer = null;
         if(this._isQuickHitAreaEnabled || this._isSelectableOnAccessoryTouch || this.currentAccessory === null || this.currentAccessory === this.accessoryLabel || this.currentAccessory === this.accessoryLoader)
         {
            return true;
         }
         if(this.currentAccessory is DisplayObjectContainer)
         {
            _loc2_ = DisplayObjectContainer(this.currentAccessory);
            return !_loc2_.contains(this.hitTest(param1));
         }
         return this.hitTest(param1) !== this.currentAccessory;
      }
      
      protected function owner_scrollStartHandler(param1:Event) : void
      {
         if(this._delayTextureCreationOnScroll)
         {
            if(this.accessoryLoader)
            {
               this.accessoryLoader.delayTextureCreation = true;
            }
            if(this.iconLoader)
            {
               this.iconLoader.delayTextureCreation = true;
            }
         }
         if(this.accessoryTouchPointID >= 0)
         {
            this._owner.stopScrolling();
         }
      }
      
      protected function owner_scrollCompleteHandler(param1:Event) : void
      {
         if(this._delayTextureCreationOnScroll)
         {
            if(this.accessoryLoader)
            {
               this.accessoryLoader.delayTextureCreation = false;
            }
            if(this.iconLoader)
            {
               this.iconLoader.delayTextureCreation = false;
            }
         }
      }
      
      protected function itemRenderer_removedFromStageHandler(param1:Event) : void
      {
         this.accessoryTouchPointID = -1;
      }
      
      protected function accessory_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         if(!this._isEnabled)
         {
            this.accessoryTouchPointID = -1;
            return;
         }
         if(!this._stopScrollingOnAccessoryTouch || this.currentAccessory === this.accessoryLabel || this.currentAccessory === this.accessoryLoader)
         {
            return;
         }
         if(this.accessoryTouchPointID >= 0)
         {
            _loc2_ = param1.getTouch(this.currentAccessory,TouchPhase.ENDED,this.accessoryTouchPointID);
            if(!_loc2_)
            {
               return;
            }
            this.accessoryTouchPointID = -1;
            this.refreshSelectionEvents();
         }
         else
         {
            _loc2_ = param1.getTouch(this.currentAccessory,TouchPhase.BEGAN);
            if(!_loc2_)
            {
               return;
            }
            this.accessoryTouchPointID = _loc2_.id;
            this.refreshSelectionEvents();
         }
      }
      
      protected function accessory_resizeHandler(param1:Event) : void
      {
         if(this._ignoreAccessoryResizes)
         {
            return;
         }
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
      
      protected function loader_completeOrErrorHandler(param1:Event) : void
      {
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
   }
}

