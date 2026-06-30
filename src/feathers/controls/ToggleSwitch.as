package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.IFocusDisplayObject;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.IStateContext;
   import feathers.core.ITextBaselineControl;
   import feathers.core.ITextRenderer;
   import feathers.core.IToggle;
   import feathers.core.IValidating;
   import feathers.core.PropertyProxy;
   import feathers.events.ExclusiveTouch;
   import feathers.events.FeathersEventType;
   import feathers.skins.IStyleProvider;
   import feathers.system.DeviceCapabilities;
   import feathers.text.FontStylesSet;
   import flash.geom.Point;
   import flash.ui.KeyLocation;
   import flash.ui.Keyboard;
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.Quad;
   import starling.events.Event;
   import starling.events.KeyboardEvent;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.text.TextFormat;
   import starling.utils.SystemUtil;
   
   public class ToggleSwitch extends FeathersControl implements IToggle, IFocusDisplayObject, ITextBaselineControl, IStateContext
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      private static const HELPER_POINT:Point = new Point();
      
      private static const MINIMUM_DRAG_DISTANCE:Number = 0.04;
      
      protected static const INVALIDATION_FLAG_THUMB_FACTORY:String = "thumbFactory";
      
      protected static const INVALIDATION_FLAG_ON_TRACK_FACTORY:String = "onTrackFactory";
      
      protected static const INVALIDATION_FLAG_OFF_TRACK_FACTORY:String = "offTrackFactory";
      
      public static const DEFAULT_CHILD_STYLE_NAME_OFF_LABEL:String = "feathers-toggle-switch-off-label";
      
      public static const DEFAULT_CHILD_STYLE_NAME_ON_LABEL:String = "feathers-toggle-switch-on-label";
      
      public static const DEFAULT_CHILD_STYLE_NAME_OFF_TRACK:String = "feathers-toggle-switch-off-track";
      
      public static const DEFAULT_CHILD_STYLE_NAME_ON_TRACK:String = "feathers-toggle-switch-on-track";
      
      public static const DEFAULT_CHILD_STYLE_NAME_THUMB:String = "feathers-toggle-switch-thumb";
      
      protected var onLabelStyleName:String = "feathers-toggle-switch-on-label";
      
      protected var offLabelStyleName:String = "feathers-toggle-switch-off-label";
      
      protected var onTrackStyleName:String = "feathers-toggle-switch-on-track";
      
      protected var offTrackStyleName:String = "feathers-toggle-switch-off-track";
      
      protected var thumbStyleName:String = "feathers-toggle-switch-thumb";
      
      protected var thumb:DisplayObject;
      
      protected var onTextRenderer:ITextRenderer;
      
      protected var offTextRenderer:ITextRenderer;
      
      protected var onTrack:DisplayObject;
      
      protected var offTrack:DisplayObject;
      
      protected var _currentState:String = "notSelected";
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var _showLabels:Boolean = true;
      
      protected var _showThumb:Boolean = true;
      
      protected var _trackLayoutMode:String = "single";
      
      protected var _trackScaleMode:String = "directional";
      
      protected var _defaultLabelProperties:PropertyProxy;
      
      protected var _disabledLabelProperties:PropertyProxy;
      
      protected var _onLabelProperties:PropertyProxy;
      
      protected var _offLabelProperties:PropertyProxy;
      
      protected var _labelFactory:Function;
      
      protected var _onLabelFontStylesSet:FontStylesSet;
      
      protected var _onLabelFactory:Function;
      
      protected var _customOnLabelStyleName:String;
      
      protected var _offLabelFontStylesSet:FontStylesSet;
      
      protected var _offLabelFactory:Function;
      
      protected var _customOffLabelStyleName:String;
      
      protected var _onTrackSkinExplicitWidth:Number;
      
      protected var _onTrackSkinExplicitHeight:Number;
      
      protected var _onTrackSkinExplicitMinWidth:Number;
      
      protected var _onTrackSkinExplicitMinHeight:Number;
      
      protected var _offTrackSkinExplicitWidth:Number;
      
      protected var _offTrackSkinExplicitHeight:Number;
      
      protected var _offTrackSkinExplicitMinWidth:Number;
      
      protected var _offTrackSkinExplicitMinHeight:Number;
      
      protected var _isSelected:Boolean = false;
      
      protected var _toggleThumbSelection:Boolean = false;
      
      protected var _toggleDuration:Number = 0.15;
      
      protected var _toggleEase:Object = "easeOut";
      
      protected var _onText:String = "ON";
      
      protected var _offText:String = "OFF";
      
      protected var _toggleTween:Tween;
      
      protected var _ignoreTapHandler:Boolean = false;
      
      protected var _touchPointID:int = -1;
      
      protected var _thumbStartX:Number;
      
      protected var _touchStartX:Number;
      
      protected var _animateSelectionChange:Boolean = false;
      
      protected var _onTrackFactory:Function;
      
      protected var _customOnTrackStyleName:String;
      
      protected var _onTrackProperties:PropertyProxy;
      
      protected var _offTrackFactory:Function;
      
      protected var _customOffTrackStyleName:String;
      
      protected var _offTrackProperties:PropertyProxy;
      
      protected var _thumbFactory:Function;
      
      protected var _customThumbStyleName:String;
      
      protected var _thumbProperties:PropertyProxy;
      
      public function ToggleSwitch()
      {
         super();
         if(this._onLabelFontStylesSet === null)
         {
            this._onLabelFontStylesSet = new FontStylesSet();
            this._onLabelFontStylesSet.addEventListener(Event.CHANGE,this.fontStyles_changeHandler);
         }
         if(this._offLabelFontStylesSet === null)
         {
            this._offLabelFontStylesSet = new FontStylesSet();
            this._offLabelFontStylesSet.addEventListener(Event.CHANGE,this.fontStyles_changeHandler);
         }
         this.addEventListener(TouchEvent.TOUCH,this.toggleSwitch_touchHandler);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.toggleSwitch_removedFromStageHandler);
      }
      
      protected static function defaultThumbFactory() : BasicButton
      {
         return new Button();
      }
      
      protected static function defaultOnTrackFactory() : BasicButton
      {
         return new Button();
      }
      
      protected static function defaultOffTrackFactory() : BasicButton
      {
         return new Button();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return ToggleSwitch.globalStyleProvider;
      }
      
      public function get currentState() : String
      {
         return this._currentState;
      }
      
      override public function set isEnabled(param1:Boolean) : void
      {
         if(this._isEnabled === param1)
         {
            return;
         }
         super.isEnabled = param1;
         this.resetState();
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
      
      public function get showLabels() : Boolean
      {
         return this._showLabels;
      }
      
      public function set showLabels(param1:Boolean) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._showLabels === param1)
         {
            return;
         }
         this._showLabels = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get showThumb() : Boolean
      {
         return this._showThumb;
      }
      
      public function set showThumb(param1:Boolean) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._showThumb === param1)
         {
            return;
         }
         this._showThumb = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get trackLayoutMode() : String
      {
         return this._trackLayoutMode;
      }
      
      public function set trackLayoutMode(param1:String) : void
      {
         if(param1 === "onOff")
         {
            param1 = TrackLayoutMode.SPLIT;
         }
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._trackLayoutMode === param1)
         {
            return;
         }
         this._trackLayoutMode = param1;
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
      }
      
      public function get trackScaleMode() : String
      {
         return this._trackScaleMode;
      }
      
      public function set trackScaleMode(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._trackScaleMode === param1)
         {
            return;
         }
         this._trackScaleMode = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get defaultLabelProperties() : Object
      {
         if(!this._defaultLabelProperties)
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
         if(this._defaultLabelProperties)
         {
            this._defaultLabelProperties.removeOnChangeCallback(this.childProperties_onChange);
         }
         this._defaultLabelProperties = PropertyProxy(param1);
         if(this._defaultLabelProperties)
         {
            this._defaultLabelProperties.addOnChangeCallback(this.childProperties_onChange);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get disabledLabelProperties() : Object
      {
         if(!this._disabledLabelProperties)
         {
            this._disabledLabelProperties = new PropertyProxy(this.childProperties_onChange);
         }
         return this._disabledLabelProperties;
      }
      
      public function set disabledLabelProperties(param1:Object) : void
      {
         if(!(param1 is PropertyProxy))
         {
            param1 = PropertyProxy.fromObject(param1);
         }
         if(this._disabledLabelProperties)
         {
            this._disabledLabelProperties.removeOnChangeCallback(this.childProperties_onChange);
         }
         this._disabledLabelProperties = PropertyProxy(param1);
         if(this._disabledLabelProperties)
         {
            this._disabledLabelProperties.addOnChangeCallback(this.childProperties_onChange);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get onLabelProperties() : Object
      {
         if(!this._onLabelProperties)
         {
            this._onLabelProperties = new PropertyProxy(this.childProperties_onChange);
         }
         return this._onLabelProperties;
      }
      
      public function set onLabelProperties(param1:Object) : void
      {
         if(!(param1 is PropertyProxy))
         {
            param1 = PropertyProxy.fromObject(param1);
         }
         if(this._onLabelProperties)
         {
            this._onLabelProperties.removeOnChangeCallback(this.childProperties_onChange);
         }
         this._onLabelProperties = PropertyProxy(param1);
         if(this._onLabelProperties)
         {
            this._onLabelProperties.addOnChangeCallback(this.childProperties_onChange);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get offLabelProperties() : Object
      {
         if(!this._offLabelProperties)
         {
            this._offLabelProperties = new PropertyProxy(this.childProperties_onChange);
         }
         return this._offLabelProperties;
      }
      
      public function set offLabelProperties(param1:Object) : void
      {
         if(!(param1 is PropertyProxy))
         {
            param1 = PropertyProxy.fromObject(param1);
         }
         if(this._offLabelProperties)
         {
            this._offLabelProperties.removeOnChangeCallback(this.childProperties_onChange);
         }
         this._offLabelProperties = PropertyProxy(param1);
         if(this._offLabelProperties)
         {
            this._offLabelProperties.addOnChangeCallback(this.childProperties_onChange);
         }
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
      
      public function get onLabelFontStyles() : TextFormat
      {
         return this._onLabelFontStylesSet.format;
      }
      
      public function set onLabelFontStyles(param1:TextFormat) : void
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
         this._onLabelFontStylesSet.format = value;
         if(value !== null)
         {
            value.addEventListener(Event.CHANGE,changeHandler);
         }
      }
      
      public function get onLabelDisabledFontStyles() : TextFormat
      {
         return this._onLabelFontStylesSet.disabledFormat;
      }
      
      public function set onLabelDisabledFontStyles(param1:TextFormat) : void
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
         this._onLabelFontStylesSet.disabledFormat = value;
         if(value !== null)
         {
            value.addEventListener(Event.CHANGE,changeHandler);
         }
      }
      
      public function get onLabelSelectedFontStyles() : TextFormat
      {
         return this._onLabelFontStylesSet.selectedFormat;
      }
      
      public function set onLabelSelectedFontStyles(param1:TextFormat) : void
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
         this._onLabelFontStylesSet.selectedFormat = value;
         if(value !== null)
         {
            value.addEventListener(Event.CHANGE,changeHandler);
         }
      }
      
      public function get onLabelFactory() : Function
      {
         return this._onLabelFactory;
      }
      
      public function set onLabelFactory(param1:Function) : void
      {
         if(this._onLabelFactory == param1)
         {
            return;
         }
         this._onLabelFactory = param1;
         this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
      }
      
      public function get customOnLabelStyleName() : String
      {
         return this._customOnLabelStyleName;
      }
      
      public function set customOnLabelStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customOnLabelStyleName === param1)
         {
            return;
         }
         this._customOnLabelStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
      }
      
      public function get offLabelFontStyles() : TextFormat
      {
         return this._offLabelFontStylesSet.format;
      }
      
      public function set offLabelFontStyles(param1:TextFormat) : void
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
         this._offLabelFontStylesSet.format = value;
         if(value !== null)
         {
            value.addEventListener(Event.CHANGE,changeHandler);
         }
      }
      
      public function get offLabelDisabledFontStyles() : TextFormat
      {
         return this._offLabelFontStylesSet.disabledFormat;
      }
      
      public function set offLabelDisabledFontStyles(param1:TextFormat) : void
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
         this._offLabelFontStylesSet.disabledFormat = value;
         if(value !== null)
         {
            value.addEventListener(Event.CHANGE,changeHandler);
         }
      }
      
      public function get offLabelSelectedFontStyles() : TextFormat
      {
         return this._offLabelFontStylesSet.selectedFormat;
      }
      
      public function set offLabelSelectedFontStyles(param1:TextFormat) : void
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
         this._offLabelFontStylesSet.selectedFormat = value;
         if(value !== null)
         {
            value.addEventListener(Event.CHANGE,changeHandler);
         }
      }
      
      public function get offLabelFactory() : Function
      {
         return this._offLabelFactory;
      }
      
      public function set offLabelFactory(param1:Function) : void
      {
         if(this._offLabelFactory == param1)
         {
            return;
         }
         this._offLabelFactory = param1;
         this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
      }
      
      public function get customOffLabelStyleName() : String
      {
         return this._customOffLabelStyleName;
      }
      
      public function set customOffLabelStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customOffLabelStyleName === param1)
         {
            return;
         }
         this._customOffLabelStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
      }
      
      public function get isSelected() : Boolean
      {
         return this._isSelected;
      }
      
      public function set isSelected(param1:Boolean) : void
      {
         this._animateSelectionChange = false;
         if(this._isSelected == param1)
         {
            return;
         }
         this._isSelected = param1;
         this.resetState();
         this.invalidate(INVALIDATION_FLAG_SELECTED);
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get toggleThumbSelection() : Boolean
      {
         return this._toggleThumbSelection;
      }
      
      public function set toggleThumbSelection(param1:Boolean) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._toggleThumbSelection === param1)
         {
            return;
         }
         this._toggleThumbSelection = param1;
         this.invalidate(INVALIDATION_FLAG_SELECTED);
      }
      
      public function get toggleDuration() : Number
      {
         return this._toggleDuration;
      }
      
      public function set toggleDuration(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         this._toggleDuration = param1;
      }
      
      public function get toggleEase() : Object
      {
         return this._toggleEase;
      }
      
      public function set toggleEase(param1:Object) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         this._toggleEase = param1;
      }
      
      public function get onText() : String
      {
         return this._onText;
      }
      
      public function set onText(param1:String) : void
      {
         if(param1 === null)
         {
            param1 = "";
         }
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._onText === param1)
         {
            return;
         }
         this._onText = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get offText() : String
      {
         return this._offText;
      }
      
      public function set offText(param1:String) : void
      {
         if(param1 === null)
         {
            param1 = "";
         }
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._offText === param1)
         {
            return;
         }
         this._offText = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get onTrackFactory() : Function
      {
         return this._onTrackFactory;
      }
      
      public function set onTrackFactory(param1:Function) : void
      {
         if(this._onTrackFactory == param1)
         {
            return;
         }
         this._onTrackFactory = param1;
         this.invalidate(INVALIDATION_FLAG_ON_TRACK_FACTORY);
      }
      
      public function get customOnTrackStyleName() : String
      {
         return this._customOnTrackStyleName;
      }
      
      public function set customOnTrackStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customOnTrackStyleName === param1)
         {
            return;
         }
         this._customOnTrackStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_ON_TRACK_FACTORY);
      }
      
      public function get onTrackProperties() : Object
      {
         if(!this._onTrackProperties)
         {
            this._onTrackProperties = new PropertyProxy(this.childProperties_onChange);
         }
         return this._onTrackProperties;
      }
      
      public function set onTrackProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         var _loc3_:String = null;
         if(this._onTrackProperties == param1)
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
         if(this._onTrackProperties)
         {
            this._onTrackProperties.removeOnChangeCallback(this.childProperties_onChange);
         }
         this._onTrackProperties = PropertyProxy(param1);
         if(this._onTrackProperties)
         {
            this._onTrackProperties.addOnChangeCallback(this.childProperties_onChange);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get offTrackFactory() : Function
      {
         return this._offTrackFactory;
      }
      
      public function set offTrackFactory(param1:Function) : void
      {
         if(this._offTrackFactory == param1)
         {
            return;
         }
         this._offTrackFactory = param1;
         this.invalidate(INVALIDATION_FLAG_OFF_TRACK_FACTORY);
      }
      
      public function get customOffTrackStyleName() : String
      {
         return this._customOffTrackStyleName;
      }
      
      public function set customOffTrackStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customOffTrackStyleName === param1)
         {
            return;
         }
         this._customOffTrackStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_OFF_TRACK_FACTORY);
      }
      
      public function get offTrackProperties() : Object
      {
         if(!this._offTrackProperties)
         {
            this._offTrackProperties = new PropertyProxy(this.childProperties_onChange);
         }
         return this._offTrackProperties;
      }
      
      public function set offTrackProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         var _loc3_:String = null;
         if(this._offTrackProperties == param1)
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
         if(this._offTrackProperties)
         {
            this._offTrackProperties.removeOnChangeCallback(this.childProperties_onChange);
         }
         this._offTrackProperties = PropertyProxy(param1);
         if(this._offTrackProperties)
         {
            this._offTrackProperties.addOnChangeCallback(this.childProperties_onChange);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get thumbFactory() : Function
      {
         return this._thumbFactory;
      }
      
      public function set thumbFactory(param1:Function) : void
      {
         if(this._thumbFactory == param1)
         {
            return;
         }
         this._thumbFactory = param1;
         this.invalidate(INVALIDATION_FLAG_THUMB_FACTORY);
      }
      
      public function get customThumbStyleName() : String
      {
         return this._customThumbStyleName;
      }
      
      public function set customThumbStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customThumbStyleName === param1)
         {
            return;
         }
         this._customThumbStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_THUMB_FACTORY);
      }
      
      public function get thumbProperties() : Object
      {
         if(!this._thumbProperties)
         {
            this._thumbProperties = new PropertyProxy(this.childProperties_onChange);
         }
         return this._thumbProperties;
      }
      
      public function set thumbProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         var _loc3_:String = null;
         if(this._thumbProperties == param1)
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
         if(this._thumbProperties)
         {
            this._thumbProperties.removeOnChangeCallback(this.childProperties_onChange);
         }
         this._thumbProperties = PropertyProxy(param1);
         if(this._thumbProperties)
         {
            this._thumbProperties.addOnChangeCallback(this.childProperties_onChange);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get baseline() : Number
      {
         if(!this.onTextRenderer)
         {
            return this.scaledActualHeight;
         }
         return this.scaleY * (this.onTextRenderer.y + this.onTextRenderer.baseline);
      }
      
      public function setSelectionWithAnimation(param1:Boolean) : void
      {
         if(this._isSelected == param1)
         {
            return;
         }
         this.isSelected = param1;
         this._animateSelectionChange = true;
      }
      
      public function getOnLabelFontStylesForState(param1:String) : TextFormat
      {
         if(this._onLabelFontStylesSet === null)
         {
            return null;
         }
         return this._onLabelFontStylesSet.getFormatForState(param1);
      }
      
      public function setOnLabelFontStylesForState(param1:String, param2:TextFormat) : void
      {
         var key:String = null;
         var changeHandler:Function = null;
         var state:String = param1;
         var format:TextFormat = param2;
         changeHandler = function(param1:Event):void
         {
            processStyleRestriction(key);
         };
         key = "setOnLabelFontStylesForState--" + state;
         if(this.processStyleRestriction(key))
         {
            return;
         }
         if(format !== null)
         {
            format.removeEventListener(Event.CHANGE,changeHandler);
         }
         this._onLabelFontStylesSet.setFormatForState(state,format);
         if(format !== null)
         {
            format.addEventListener(Event.CHANGE,changeHandler);
         }
      }
      
      public function getOffLabelFontStylesForState(param1:String) : TextFormat
      {
         if(this._offLabelFontStylesSet === null)
         {
            return null;
         }
         return this._offLabelFontStylesSet.getFormatForState(param1);
      }
      
      public function setOffLabelFontStylesForState(param1:String, param2:TextFormat) : void
      {
         var key:String = null;
         var changeHandler:Function = null;
         var state:String = param1;
         var format:TextFormat = param2;
         changeHandler = function(param1:Event):void
         {
            processStyleRestriction(key);
         };
         key = "setOffLabelFontStylesForState--" + state;
         if(this.processStyleRestriction(key))
         {
            return;
         }
         if(format !== null)
         {
            format.removeEventListener(Event.CHANGE,changeHandler);
         }
         this._offLabelFontStylesSet.setFormatForState(state,format);
         if(format !== null)
         {
            format.addEventListener(Event.CHANGE,changeHandler);
         }
      }
      
      override public function dispose() : void
      {
         if(this._onLabelFontStylesSet !== null)
         {
            this._onLabelFontStylesSet.dispose();
            this._onLabelFontStylesSet = null;
         }
         if(this._offLabelFontStylesSet !== null)
         {
            this._offLabelFontStylesSet.dispose();
            this._offLabelFontStylesSet = null;
         }
         super.dispose();
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
         var _loc4_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         var _loc5_:Boolean = this.isInvalid(INVALIDATION_FLAG_FOCUS);
         var _loc6_:Boolean = this.isInvalid(INVALIDATION_FLAG_LAYOUT);
         var _loc7_:Boolean = this.isInvalid(INVALIDATION_FLAG_TEXT_RENDERER);
         var _loc8_:Boolean = this.isInvalid(INVALIDATION_FLAG_THUMB_FACTORY);
         var _loc9_:Boolean = this.isInvalid(INVALIDATION_FLAG_ON_TRACK_FACTORY);
         var _loc10_:Boolean = this.isInvalid(INVALIDATION_FLAG_OFF_TRACK_FACTORY);
         if(_loc8_)
         {
            this.createThumb();
         }
         if(_loc9_)
         {
            this.createOnTrack();
         }
         if(_loc10_ || _loc6_)
         {
            this.createOffTrack();
         }
         if(_loc7_)
         {
            this.createLabels();
         }
         if(_loc7_ || _loc2_ || _loc4_)
         {
            this.refreshOnLabelStyles();
            this.refreshOffLabelStyles();
         }
         if(_loc8_ || _loc2_)
         {
            this.refreshThumbStyles();
         }
         if(_loc9_ || _loc2_)
         {
            this.refreshOnTrackStyles();
         }
         if((_loc10_ || _loc6_ || _loc2_) && Boolean(this.offTrack))
         {
            this.refreshOffTrackStyles();
         }
         if(_loc4_ || _loc6_ || _loc8_ || _loc9_ || _loc9_ || _loc7_)
         {
            this.refreshEnabled();
         }
         _loc3_ = this.autoSizeIfNeeded() || _loc3_;
         if(_loc3_ || _loc2_ || _loc1_)
         {
            this.updateSelection();
         }
         this.layoutChildren();
         if(_loc3_ || _loc5_)
         {
            this.refreshFocusIndicator();
         }
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc10_:IMeasureDisplayObject = null;
         var _loc11_:Number = NaN;
         var _loc12_:IMeasureDisplayObject = null;
         var _loc13_:IMeasureDisplayObject = null;
         var _loc1_:Boolean = this._explicitWidth !== this._explicitWidth;
         var _loc2_:Boolean = this._explicitHeight !== this._explicitHeight;
         var _loc3_:Boolean = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc4_:Boolean = this._explicitMinHeight !== this._explicitMinHeight;
         if(!_loc1_ && !_loc2_ && !_loc3_ && !_loc4_)
         {
            return false;
         }
         var _loc5_:Boolean = this._trackLayoutMode === TrackLayoutMode.SINGLE;
         if(_loc1_)
         {
            this.onTrack.width = this._onTrackSkinExplicitWidth;
         }
         else if(_loc5_)
         {
            this.onTrack.width = this._explicitWidth;
         }
         if(this.onTrack is IMeasureDisplayObject)
         {
            _loc10_ = IMeasureDisplayObject(this.onTrack);
            if(_loc3_)
            {
               _loc10_.minWidth = this._onTrackSkinExplicitMinWidth;
            }
            else if(_loc5_)
            {
               _loc11_ = this._explicitMinWidth;
               if(this._onTrackSkinExplicitMinWidth > _loc11_)
               {
                  _loc11_ = this._onTrackSkinExplicitMinWidth;
               }
               _loc10_.minWidth = _loc11_;
            }
         }
         if(!_loc5_)
         {
            if(_loc1_)
            {
               this.offTrack.width = this._offTrackSkinExplicitWidth;
            }
            if(this.offTrack is IMeasureDisplayObject)
            {
               _loc12_ = IMeasureDisplayObject(this.offTrack);
               if(_loc3_)
               {
                  _loc12_.minWidth = this._offTrackSkinExplicitMinWidth;
               }
            }
         }
         if(this.onTrack is IValidating)
         {
            IValidating(this.onTrack).validate();
         }
         if(this.offTrack is IValidating)
         {
            IValidating(this.offTrack).validate();
         }
         if(this.thumb is IValidating)
         {
            IValidating(this.thumb).validate();
         }
         var _loc6_:Number = this._explicitWidth;
         var _loc7_:Number = this._explicitHeight;
         var _loc8_:Number = this._explicitMinWidth;
         var _loc9_:Number = this._explicitMinHeight;
         if(_loc1_)
         {
            _loc6_ = this.onTrack.width;
            if(!_loc5_)
            {
               if(this.offTrack.width > _loc6_)
               {
                  _loc6_ = this.offTrack.width;
               }
               _loc6_ += this.thumb.width / 2;
            }
         }
         if(_loc2_)
         {
            _loc7_ = this.onTrack.height;
            if(!_loc5_ && this.offTrack.height > _loc7_)
            {
               _loc7_ = this.offTrack.height;
            }
            if(this.thumb.height > _loc7_)
            {
               _loc7_ = this.thumb.height;
            }
         }
         if(_loc3_)
         {
            if(_loc10_ !== null)
            {
               _loc8_ = _loc10_.minWidth;
            }
            else
            {
               _loc8_ = this.onTrack.width;
            }
            if(!_loc5_)
            {
               if(_loc12_ !== null)
               {
                  if(_loc12_.minWidth > _loc8_)
                  {
                     _loc8_ = _loc12_.minWidth;
                  }
               }
               else if(this.offTrack.width > _loc8_)
               {
                  _loc8_ = this.offTrack.width;
               }
               if(this.thumb is IMeasureDisplayObject)
               {
                  _loc8_ += IMeasureDisplayObject(this.thumb).minWidth / 2;
               }
               else
               {
                  _loc8_ += this.thumb.width / 2;
               }
            }
         }
         if(_loc4_)
         {
            if(_loc10_ !== null)
            {
               _loc9_ = _loc10_.minHeight;
            }
            else
            {
               _loc9_ = this.onTrack.height;
            }
            if(!_loc5_)
            {
               if(_loc12_ !== null)
               {
                  if(_loc12_.minHeight > _loc9_)
                  {
                     _loc9_ = _loc12_.minHeight;
                  }
               }
               else if(this.offTrack.height > _loc9_)
               {
                  _loc9_ = this.offTrack.height;
               }
            }
            if(this.thumb is IMeasureDisplayObject)
            {
               _loc13_ = IMeasureDisplayObject(this.thumb);
               if(_loc13_.minHeight > _loc9_)
               {
                  _loc9_ = _loc13_.minHeight;
               }
            }
            else if(this.thumb.height > _loc9_)
            {
               _loc9_ = this.thumb.height;
            }
         }
         return this.saveMeasurements(_loc6_,_loc7_,_loc8_,_loc9_);
      }
      
      protected function createThumb() : void
      {
         if(this.thumb !== null)
         {
            this.thumb.removeFromParent(true);
            this.thumb = null;
         }
         var _loc1_:Function = this._thumbFactory != null ? this._thumbFactory : defaultThumbFactory;
         var _loc2_:String = this._customThumbStyleName != null ? this._customThumbStyleName : this.thumbStyleName;
         var _loc3_:BasicButton = BasicButton(_loc1_());
         _loc3_.styleNameList.add(_loc2_);
         _loc3_.keepDownStateOnRollOut = true;
         _loc3_.addEventListener(TouchEvent.TOUCH,this.thumb_touchHandler);
         this.addChild(_loc3_);
         this.thumb = _loc3_;
      }
      
      protected function createOnTrack() : void
      {
         var _loc4_:IMeasureDisplayObject = null;
         if(this.onTrack !== null)
         {
            this.onTrack.removeFromParent(true);
            this.onTrack = null;
         }
         var _loc1_:Function = this._onTrackFactory != null ? this._onTrackFactory : defaultOnTrackFactory;
         var _loc2_:String = this._customOnTrackStyleName != null ? this._customOnTrackStyleName : this.onTrackStyleName;
         var _loc3_:BasicButton = BasicButton(_loc1_());
         _loc3_.styleNameList.add(_loc2_);
         _loc3_.keepDownStateOnRollOut = true;
         this.addChildAt(_loc3_,0);
         this.onTrack = _loc3_;
         if(this.onTrack is IFeathersControl)
         {
            IFeathersControl(this.onTrack).initializeNow();
         }
         if(this.onTrack is IMeasureDisplayObject)
         {
            _loc4_ = IMeasureDisplayObject(this.onTrack);
            this._onTrackSkinExplicitWidth = _loc4_.explicitWidth;
            this._onTrackSkinExplicitHeight = _loc4_.explicitHeight;
            this._onTrackSkinExplicitMinWidth = _loc4_.explicitMinWidth;
            this._onTrackSkinExplicitMinHeight = _loc4_.explicitMinHeight;
         }
         else
         {
            this._onTrackSkinExplicitWidth = this.onTrack.width;
            this._onTrackSkinExplicitHeight = this.onTrack.height;
            this._onTrackSkinExplicitMinWidth = this._onTrackSkinExplicitWidth;
            this._onTrackSkinExplicitMinHeight = this._onTrackSkinExplicitHeight;
         }
      }
      
      protected function createOffTrack() : void
      {
         var _loc4_:IMeasureDisplayObject = null;
         if(this.offTrack !== null)
         {
            this.offTrack.removeFromParent(true);
            this.offTrack = null;
         }
         if(this._trackLayoutMode === TrackLayoutMode.SINGLE)
         {
            return;
         }
         var _loc1_:Function = this._offTrackFactory != null ? this._offTrackFactory : defaultOffTrackFactory;
         var _loc2_:String = this._customOffTrackStyleName != null ? this._customOffTrackStyleName : this.offTrackStyleName;
         var _loc3_:BasicButton = BasicButton(_loc1_());
         _loc3_.styleNameList.add(_loc2_);
         _loc3_.keepDownStateOnRollOut = true;
         this.addChildAt(_loc3_,1);
         this.offTrack = _loc3_;
         if(this.offTrack is IFeathersControl)
         {
            IFeathersControl(this.offTrack).initializeNow();
         }
         if(this.offTrack is IMeasureDisplayObject)
         {
            _loc4_ = IMeasureDisplayObject(this.offTrack);
            this._offTrackSkinExplicitWidth = _loc4_.explicitWidth;
            this._offTrackSkinExplicitHeight = _loc4_.explicitHeight;
            this._offTrackSkinExplicitMinWidth = _loc4_.explicitMinWidth;
            this._offTrackSkinExplicitMinHeight = _loc4_.explicitMinHeight;
         }
         else
         {
            this._offTrackSkinExplicitWidth = this.offTrack.width;
            this._offTrackSkinExplicitHeight = this.offTrack.height;
            this._offTrackSkinExplicitMinWidth = this._offTrackSkinExplicitWidth;
            this._offTrackSkinExplicitMinHeight = this._offTrackSkinExplicitHeight;
         }
      }
      
      protected function createLabels() : void
      {
         if(this.offTextRenderer)
         {
            this.removeChild(DisplayObject(this.offTextRenderer),true);
            this.offTextRenderer = null;
         }
         if(this.onTextRenderer)
         {
            this.removeChild(DisplayObject(this.onTextRenderer),true);
            this.onTextRenderer = null;
         }
         var _loc1_:int = this.getChildIndex(this.thumb);
         var _loc2_:Function = this._offLabelFactory;
         if(_loc2_ == null)
         {
            _loc2_ = this._labelFactory;
         }
         if(_loc2_ == null)
         {
            _loc2_ = FeathersControl.defaultTextRendererFactory;
         }
         this.offTextRenderer = ITextRenderer(_loc2_());
         this.offTextRenderer.stateContext = this;
         var _loc3_:String = this._customOffLabelStyleName != null ? this._customOffLabelStyleName : this.offLabelStyleName;
         this.offTextRenderer.styleNameList.add(_loc3_);
         var _loc4_:Quad = new Quad(1,1,16711935);
         _loc4_.width = 0;
         _loc4_.height = 0;
         this.offTextRenderer.mask = _loc4_;
         this.addChildAt(DisplayObject(this.offTextRenderer),_loc1_);
         var _loc5_:Function = this._onLabelFactory;
         if(_loc5_ == null)
         {
            _loc5_ = this._labelFactory;
         }
         if(_loc5_ == null)
         {
            _loc5_ = FeathersControl.defaultTextRendererFactory;
         }
         this.onTextRenderer = ITextRenderer(_loc5_());
         this.onTextRenderer.stateContext = this;
         var _loc6_:String = this._customOnLabelStyleName != null ? this._customOnLabelStyleName : this.onLabelStyleName;
         this.onTextRenderer.styleNameList.add(_loc6_);
         _loc4_ = new Quad(1,1,16711935);
         _loc4_.width = 0;
         _loc4_.height = 0;
         this.onTextRenderer.mask = _loc4_;
         this.addChildAt(DisplayObject(this.onTextRenderer),_loc1_);
      }
      
      protected function changeState(param1:String) : void
      {
         if(this._currentState === param1)
         {
            return;
         }
         this._currentState = param1;
         this.invalidate(INVALIDATION_FLAG_STATE);
         this.dispatchEventWith(FeathersEventType.STATE_CHANGE);
      }
      
      protected function resetState() : void
      {
         if(this._isEnabled)
         {
            if(this._isSelected)
            {
               this.changeState(ToggleState.SELECTED);
            }
            else
            {
               this.changeState(ToggleState.NOT_SELECTED);
            }
         }
         else if(this._isSelected)
         {
            this.changeState(ToggleState.SELECTED_AND_DISABLED);
         }
         else
         {
            this.changeState(ToggleState.DISABLED);
         }
      }
      
      protected function layoutChildren() : void
      {
         if(this.thumb is IValidating)
         {
            IValidating(this.thumb).validate();
         }
         this.thumb.y = (this.actualHeight - this.thumb.height) / 2;
         var _loc1_:Number = Math.max(0,this.actualWidth - this.thumb.width - this._paddingLeft - this._paddingRight);
         var _loc2_:Number = Math.max(this.onTextRenderer.height,this.offTextRenderer.height);
         var _loc3_:DisplayObject = this.onTextRenderer.mask;
         _loc3_.width = _loc1_;
         _loc3_.height = _loc2_;
         this.onTextRenderer.y = (this.actualHeight - _loc2_) / 2;
         _loc3_ = this.offTextRenderer.mask;
         _loc3_.width = _loc1_;
         _loc3_.height = _loc2_;
         this.offTextRenderer.y = (this.actualHeight - _loc2_) / 2;
         this.layoutTracks();
      }
      
      protected function layoutTracks() : void
      {
         var _loc1_:Number = Math.max(0,this.actualWidth - this.thumb.width - this._paddingLeft - this._paddingRight);
         var _loc2_:Number = this.thumb.x - this._paddingLeft;
         var _loc3_:Number = _loc1_ - _loc2_ - (_loc1_ - this.onTextRenderer.width) / 2;
         var _loc4_:DisplayObject = this.onTextRenderer.mask;
         _loc4_.x = _loc3_;
         this.onTextRenderer.x = this._paddingLeft - _loc3_;
         var _loc5_:Number = -_loc2_ - (_loc1_ - this.offTextRenderer.width) / 2;
         _loc4_ = this.offTextRenderer.mask;
         _loc4_.x = _loc5_;
         this.offTextRenderer.x = this.actualWidth - this._paddingRight - _loc1_ - _loc5_;
         if(this._trackLayoutMode == TrackLayoutMode.SPLIT)
         {
            this.layoutTrackWithOnOff();
         }
         else
         {
            this.layoutTrackWithSingle();
         }
      }
      
      protected function updateSelection() : void
      {
         var _loc2_:IToggle = null;
         if(this.thumb is IToggle)
         {
            _loc2_ = IToggle(this.thumb);
            if(this._toggleThumbSelection)
            {
               _loc2_.isSelected = this._isSelected;
            }
            else
            {
               _loc2_.isSelected = false;
            }
         }
         if(this.thumb is IValidating)
         {
            IValidating(this.thumb).validate();
         }
         var _loc1_:Number = this._paddingLeft;
         if(this._isSelected)
         {
            _loc1_ = this.actualWidth - this.thumb.width - this._paddingRight;
         }
         if(this._toggleTween)
         {
            Starling.juggler.remove(this._toggleTween);
            this._toggleTween = null;
         }
         if(this._animateSelectionChange)
         {
            this._toggleTween = new Tween(this.thumb,this._toggleDuration,this._toggleEase);
            this._toggleTween.animate("x",_loc1_);
            this._toggleTween.onUpdate = this.selectionTween_onUpdate;
            this._toggleTween.onComplete = this.selectionTween_onComplete;
            Starling.juggler.add(this._toggleTween);
         }
         else
         {
            this.thumb.x = _loc1_;
         }
         this._animateSelectionChange = false;
      }
      
      protected function refreshOnLabelStyles() : void
      {
         var _loc1_:PropertyProxy = null;
         var _loc2_:DisplayObject = null;
         var _loc3_:String = null;
         var _loc4_:Object = null;
         if(!this._showLabels || !this._showThumb)
         {
            this.onTextRenderer.visible = false;
            return;
         }
         this.onTextRenderer.fontStyles = this._onLabelFontStylesSet;
         if(!this._isEnabled)
         {
            _loc1_ = this._disabledLabelProperties;
         }
         if(!_loc1_ && Boolean(this._onLabelProperties))
         {
            _loc1_ = this._onLabelProperties;
         }
         if(!_loc1_)
         {
            _loc1_ = this._defaultLabelProperties;
         }
         this.onTextRenderer.text = this._onText;
         if(_loc1_)
         {
            _loc2_ = DisplayObject(this.onTextRenderer);
            for(_loc3_ in _loc1_)
            {
               _loc4_ = _loc1_[_loc3_];
               _loc2_[_loc3_] = _loc4_;
            }
         }
         this.onTextRenderer.validate();
         this.onTextRenderer.visible = true;
      }
      
      protected function refreshOffLabelStyles() : void
      {
         var _loc1_:PropertyProxy = null;
         var _loc2_:DisplayObject = null;
         var _loc3_:String = null;
         var _loc4_:Object = null;
         if(!this._showLabels || !this._showThumb)
         {
            this.offTextRenderer.visible = false;
            return;
         }
         this.offTextRenderer.fontStyles = this._offLabelFontStylesSet;
         if(!this._isEnabled)
         {
            _loc1_ = this._disabledLabelProperties;
         }
         if(!_loc1_ && Boolean(this._offLabelProperties))
         {
            _loc1_ = this._offLabelProperties;
         }
         if(!_loc1_)
         {
            _loc1_ = this._defaultLabelProperties;
         }
         this.offTextRenderer.text = this._offText;
         if(_loc1_)
         {
            _loc2_ = DisplayObject(this.offTextRenderer);
            for(_loc3_ in _loc1_)
            {
               _loc4_ = _loc1_[_loc3_];
               _loc2_[_loc3_] = _loc4_;
            }
         }
         this.offTextRenderer.validate();
         this.offTextRenderer.visible = true;
      }
      
      protected function refreshThumbStyles() : void
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         for(_loc1_ in this._thumbProperties)
         {
            _loc2_ = this._thumbProperties[_loc1_];
            this.thumb[_loc1_] = _loc2_;
         }
         this.thumb.visible = this._showThumb;
      }
      
      protected function refreshOnTrackStyles() : void
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         for(_loc1_ in this._onTrackProperties)
         {
            _loc2_ = this._onTrackProperties[_loc1_];
            this.onTrack[_loc1_] = _loc2_;
         }
      }
      
      protected function refreshOffTrackStyles() : void
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         if(!this.offTrack)
         {
            return;
         }
         for(_loc1_ in this._offTrackProperties)
         {
            _loc2_ = this._offTrackProperties[_loc1_];
            this.offTrack[_loc1_] = _loc2_;
         }
      }
      
      protected function refreshEnabled() : void
      {
         if(this.thumb is IFeathersControl)
         {
            IFeathersControl(this.thumb).isEnabled = this._isEnabled;
         }
         if(this.onTrack is IFeathersControl)
         {
            IFeathersControl(this.onTrack).isEnabled = this._isEnabled;
         }
         if(this.offTrack is IFeathersControl)
         {
            IFeathersControl(this.offTrack).isEnabled = this._isEnabled;
         }
         this.onTextRenderer.isEnabled = this._isEnabled;
         this.offTextRenderer.isEnabled = this._isEnabled;
      }
      
      protected function layoutTrackWithOnOff() : void
      {
         var _loc1_:Number = Math.round(this.thumb.x + this.thumb.width / 2);
         this.onTrack.x = 0;
         this.onTrack.width = _loc1_;
         this.offTrack.x = _loc1_;
         this.offTrack.width = this.actualWidth - _loc1_;
         if(this._trackScaleMode === TrackScaleMode.EXACT_FIT)
         {
            this.onTrack.y = 0;
            this.onTrack.height = this.actualHeight;
            this.offTrack.y = 0;
            this.offTrack.height = this.actualHeight;
         }
         if(this.onTrack is IValidating)
         {
            IValidating(this.onTrack).validate();
         }
         if(this.offTrack is IValidating)
         {
            IValidating(this.offTrack).validate();
         }
         if(this._trackScaleMode === TrackScaleMode.DIRECTIONAL)
         {
            this.onTrack.y = Math.round((this.actualHeight - this.onTrack.height) / 2);
            this.offTrack.y = Math.round((this.actualHeight - this.offTrack.height) / 2);
         }
      }
      
      protected function layoutTrackWithSingle() : void
      {
         this.onTrack.x = 0;
         this.onTrack.width = this.actualWidth;
         if(this._trackScaleMode === TrackScaleMode.EXACT_FIT)
         {
            this.onTrack.y = 0;
            this.onTrack.height = this.actualHeight;
         }
         else
         {
            this.onTrack.height = this._onTrackSkinExplicitHeight;
         }
         if(this.onTrack is IValidating)
         {
            IValidating(this.onTrack).validate();
         }
         if(this._trackScaleMode === TrackScaleMode.DIRECTIONAL)
         {
            this.onTrack.y = Math.round((this.actualHeight - this.onTrack.height) / 2);
         }
      }
      
      protected function childProperties_onChange(param1:PropertyProxy, param2:Object) : void
      {
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      protected function toggleSwitch_removedFromStageHandler(param1:Event) : void
      {
         this._touchPointID = -1;
      }
      
      override protected function focusInHandler(param1:Event) : void
      {
         super.focusInHandler(param1);
         this.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.stage_keyDownHandler);
         this.stage.addEventListener(KeyboardEvent.KEY_UP,this.stage_keyUpHandler);
      }
      
      override protected function focusOutHandler(param1:Event) : void
      {
         super.focusOutHandler(param1);
         this.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.stage_keyDownHandler);
         this.stage.removeEventListener(KeyboardEvent.KEY_UP,this.stage_keyUpHandler);
      }
      
      protected function toggleSwitch_touchHandler(param1:TouchEvent) : void
      {
         if(this._ignoreTapHandler)
         {
            this._ignoreTapHandler = false;
            return;
         }
         if(!this._isEnabled)
         {
            this._touchPointID = -1;
            return;
         }
         var _loc2_:Touch = param1.getTouch(this,TouchPhase.ENDED);
         if(!_loc2_)
         {
            return;
         }
         this._touchPointID = -1;
         _loc2_.getLocation(this.stage,HELPER_POINT);
         var _loc3_:Boolean = this.contains(this.stage.hitTest(HELPER_POINT));
         if(_loc3_)
         {
            this.setSelectionWithAnimation(!this._isSelected);
         }
      }
      
      protected function thumb_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         var _loc3_:Number = NaN;
         var _loc4_:ExclusiveTouch = null;
         var _loc5_:DisplayObject = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         if(!this._isEnabled)
         {
            this._touchPointID = -1;
            return;
         }
         if(this._touchPointID >= 0)
         {
            _loc2_ = param1.getTouch(this.thumb,null,this._touchPointID);
            if(!_loc2_)
            {
               return;
            }
            _loc2_.getLocation(this,HELPER_POINT);
            _loc3_ = this.actualWidth - this._paddingLeft - this._paddingRight - this.thumb.width;
            if(_loc2_.phase == TouchPhase.MOVED)
            {
               _loc4_ = ExclusiveTouch.forStage(this.stage);
               _loc5_ = _loc4_.getClaim(this._touchPointID);
               if(_loc5_ !== this)
               {
                  if(_loc5_)
                  {
                     return;
                  }
                  _loc4_.claimTouch(this._touchPointID,this);
               }
               _loc6_ = HELPER_POINT.x - this._touchStartX;
               _loc7_ = Math.min(Math.max(this._paddingLeft,this._thumbStartX + _loc6_),this._paddingLeft + _loc3_);
               this.thumb.x = _loc7_;
               this.layoutTracks();
            }
            else if(_loc2_.phase == TouchPhase.ENDED)
            {
               _loc8_ = Math.abs(HELPER_POINT.x - this._touchStartX);
               _loc9_ = _loc8_ / DeviceCapabilities.dpi;
               if(_loc9_ > MINIMUM_DRAG_DISTANCE || SystemUtil.isDesktop && _loc8_ >= 1)
               {
                  this._touchPointID = -1;
                  this._ignoreTapHandler = true;
                  this.setSelectionWithAnimation(this.thumb.x > this._paddingLeft + _loc3_ / 2);
                  this.invalidate(INVALIDATION_FLAG_SELECTED);
               }
            }
         }
         else
         {
            _loc2_ = param1.getTouch(this.thumb,TouchPhase.BEGAN);
            if(!_loc2_)
            {
               return;
            }
            _loc2_.getLocation(this,HELPER_POINT);
            this._touchPointID = _loc2_.id;
            this._thumbStartX = this.thumb.x;
            this._touchStartX = HELPER_POINT.x;
         }
      }
      
      protected function stage_keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ESCAPE)
         {
            this._touchPointID = -1;
         }
         if(this._touchPointID != -1 || !(param1.keyCode == Keyboard.SPACE || param1.keyCode == Keyboard.ENTER && (param1.keyLocation == KeyLocation.D_PAD || DeviceCapabilities.simulateDPad)))
         {
            return;
         }
         this._touchPointID = int.MAX_VALUE;
      }
      
      protected function stage_keyUpHandler(param1:KeyboardEvent) : void
      {
         if(this._touchPointID != int.MAX_VALUE || !(param1.keyCode == Keyboard.SPACE || param1.keyCode == Keyboard.ENTER && (param1.keyLocation == KeyLocation.D_PAD || DeviceCapabilities.simulateDPad)))
         {
            return;
         }
         this._touchPointID = -1;
         this.setSelectionWithAnimation(!this._isSelected);
      }
      
      protected function selectionTween_onUpdate() : void
      {
         this.layoutTracks();
      }
      
      protected function selectionTween_onComplete() : void
      {
         this._toggleTween = null;
      }
      
      protected function fontStyles_changeHandler(param1:Event) : void
      {
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
   }
}

