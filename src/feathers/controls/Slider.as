package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.IFocusDisplayObject;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.IValidating;
   import feathers.core.PropertyProxy;
   import feathers.events.ExclusiveTouch;
   import feathers.events.FeathersEventType;
   import feathers.layout.Direction;
   import feathers.skins.IStyleProvider;
   import feathers.utils.math.clamp;
   import feathers.utils.math.roundDownToNearest;
   import feathers.utils.math.roundToNearest;
   import feathers.utils.math.roundUpToNearest;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import starling.events.KeyboardEvent;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Pool;
   
   public class Slider extends FeathersControl implements IDirectionalScrollBar, IFocusDisplayObject
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      protected static const INVALIDATION_FLAG_THUMB_FACTORY:String = "thumbFactory";
      
      protected static const INVALIDATION_FLAG_MINIMUM_TRACK_FACTORY:String = "minimumTrackFactory";
      
      protected static const INVALIDATION_FLAG_MAXIMUM_TRACK_FACTORY:String = "maximumTrackFactory";
      
      public static const DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK:String = "feathers-slider-minimum-track";
      
      public static const DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK:String = "feathers-slider-maximum-track";
      
      public static const DEFAULT_CHILD_STYLE_NAME_THUMB:String = "feathers-slider-thumb";
      
      protected var minimumTrackStyleName:String = "feathers-slider-minimum-track";
      
      protected var maximumTrackStyleName:String = "feathers-slider-maximum-track";
      
      protected var thumbStyleName:String = "feathers-slider-thumb";
      
      protected var thumb:DisplayObject;
      
      protected var minimumTrack:DisplayObject;
      
      protected var maximumTrack:DisplayObject;
      
      protected var _minimumTrackSkinExplicitWidth:Number;
      
      protected var _minimumTrackSkinExplicitHeight:Number;
      
      protected var _minimumTrackSkinExplicitMinWidth:Number;
      
      protected var _minimumTrackSkinExplicitMinHeight:Number;
      
      protected var _maximumTrackSkinExplicitWidth:Number;
      
      protected var _maximumTrackSkinExplicitHeight:Number;
      
      protected var _maximumTrackSkinExplicitMinWidth:Number;
      
      protected var _maximumTrackSkinExplicitMinHeight:Number;
      
      protected var _direction:String = "horizontal";
      
      protected var _value:Number = 0;
      
      protected var _minimum:Number = 0;
      
      protected var _maximum:Number = 0;
      
      protected var _step:Number = 0;
      
      protected var _page:Number = NaN;
      
      protected var isDragging:Boolean = false;
      
      public var liveDragging:Boolean = true;
      
      protected var _showThumb:Boolean = true;
      
      protected var _thumbOffset:Number = 0;
      
      protected var _minimumPadding:Number = 0;
      
      protected var _maximumPadding:Number = 0;
      
      protected var _trackLayoutMode:String = "single";
      
      protected var _trackScaleMode:String = "directional";
      
      protected var _trackInteractionMode:String = "toValue";
      
      protected var currentRepeatAction:Function;
      
      protected var _repeatTimer:Timer;
      
      protected var _repeatDelay:Number = 0.05;
      
      protected var _minimumTrackFactory:Function;
      
      protected var _customMinimumTrackStyleName:String;
      
      protected var _minimumTrackProperties:PropertyProxy;
      
      protected var _maximumTrackFactory:Function;
      
      protected var _customMaximumTrackStyleName:String;
      
      protected var _maximumTrackProperties:PropertyProxy;
      
      protected var _thumbFactory:Function;
      
      protected var _customThumbStyleName:String;
      
      protected var _thumbProperties:PropertyProxy;
      
      protected var _touchPointID:int = -1;
      
      protected var _touchStartX:Number = NaN;
      
      protected var _touchStartY:Number = NaN;
      
      protected var _thumbStartX:Number = NaN;
      
      protected var _thumbStartY:Number = NaN;
      
      protected var _touchValue:Number;
      
      protected var _pageStartValue:Number;
      
      public function Slider()
      {
         super();
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.slider_removedFromStageHandler);
      }
      
      protected static function defaultThumbFactory() : BasicButton
      {
         return new Button();
      }
      
      protected static function defaultMinimumTrackFactory() : BasicButton
      {
         return new Button();
      }
      
      protected static function defaultMaximumTrackFactory() : BasicButton
      {
         return new Button();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return Slider.globalStyleProvider;
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
         this.invalidate(INVALIDATION_FLAG_MINIMUM_TRACK_FACTORY);
         this.invalidate(INVALIDATION_FLAG_MAXIMUM_TRACK_FACTORY);
         this.invalidate(INVALIDATION_FLAG_THUMB_FACTORY);
      }
      
      public function get value() : Number
      {
         return this._value;
      }
      
      public function set value(param1:Number) : void
      {
         if(this._step != 0 && param1 != this._maximum && param1 != this._minimum)
         {
            param1 = roundToNearest(param1 - this._minimum,this._step) + this._minimum;
         }
         param1 = clamp(param1,this._minimum,this._maximum);
         if(this._value == param1)
         {
            return;
         }
         this._value = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
         if(this.liveDragging || !this.isDragging)
         {
            this.dispatchEventWith(Event.CHANGE);
         }
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
      
      public function get step() : Number
      {
         return this._step;
      }
      
      public function set step(param1:Number) : void
      {
         if(this._step == param1)
         {
            return;
         }
         this._step = param1;
      }
      
      public function get page() : Number
      {
         return this._page;
      }
      
      public function set page(param1:Number) : void
      {
         if(this._page == param1)
         {
            return;
         }
         this._page = param1;
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
      
      public function get thumbOffset() : Number
      {
         return this._thumbOffset;
      }
      
      public function set thumbOffset(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._thumbOffset == param1)
         {
            return;
         }
         this._thumbOffset = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get minimumPadding() : Number
      {
         return this._minimumPadding;
      }
      
      public function set minimumPadding(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._minimumPadding == param1)
         {
            return;
         }
         this._minimumPadding = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get maximumPadding() : Number
      {
         return this._maximumPadding;
      }
      
      public function set maximumPadding(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._maximumPadding == param1)
         {
            return;
         }
         this._maximumPadding = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get trackLayoutMode() : String
      {
         return this._trackLayoutMode;
      }
      
      public function set trackLayoutMode(param1:String) : void
      {
         if(param1 === "minMax")
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
         this.invalidate(INVALIDATION_FLAG_STYLES);
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
      
      public function get trackInteractionMode() : String
      {
         return this._trackInteractionMode;
      }
      
      public function set trackInteractionMode(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         this._trackInteractionMode = param1;
      }
      
      public function get repeatDelay() : Number
      {
         return this._repeatDelay;
      }
      
      public function set repeatDelay(param1:Number) : void
      {
         if(this._repeatDelay == param1)
         {
            return;
         }
         this._repeatDelay = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get minimumTrackFactory() : Function
      {
         return this._minimumTrackFactory;
      }
      
      public function set minimumTrackFactory(param1:Function) : void
      {
         if(this._minimumTrackFactory == param1)
         {
            return;
         }
         this._minimumTrackFactory = param1;
         this.invalidate(INVALIDATION_FLAG_MINIMUM_TRACK_FACTORY);
      }
      
      public function get customMinimumTrackStyleName() : String
      {
         return this._customMinimumTrackStyleName;
      }
      
      public function set customMinimumTrackStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customMinimumTrackStyleName === param1)
         {
            return;
         }
         this._customMinimumTrackStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_MINIMUM_TRACK_FACTORY);
      }
      
      public function get minimumTrackProperties() : Object
      {
         if(!this._minimumTrackProperties)
         {
            this._minimumTrackProperties = new PropertyProxy(this.childProperties_onChange);
         }
         return this._minimumTrackProperties;
      }
      
      public function set minimumTrackProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         var _loc3_:String = null;
         if(this._minimumTrackProperties == param1)
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
         if(this._minimumTrackProperties)
         {
            this._minimumTrackProperties.removeOnChangeCallback(this.childProperties_onChange);
         }
         this._minimumTrackProperties = PropertyProxy(param1);
         if(this._minimumTrackProperties)
         {
            this._minimumTrackProperties.addOnChangeCallback(this.childProperties_onChange);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get maximumTrackFactory() : Function
      {
         return this._maximumTrackFactory;
      }
      
      public function set maximumTrackFactory(param1:Function) : void
      {
         if(this._maximumTrackFactory == param1)
         {
            return;
         }
         this._maximumTrackFactory = param1;
         this.invalidate(INVALIDATION_FLAG_MAXIMUM_TRACK_FACTORY);
      }
      
      public function get customMaximumTrackStyleName() : String
      {
         return this._customMaximumTrackStyleName;
      }
      
      public function set customMaximumTrackStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customMaximumTrackStyleName === param1)
         {
            return;
         }
         this._customMaximumTrackStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_MAXIMUM_TRACK_FACTORY);
      }
      
      public function get maximumTrackProperties() : Object
      {
         if(!this._maximumTrackProperties)
         {
            this._maximumTrackProperties = new PropertyProxy(this.childProperties_onChange);
         }
         return this._maximumTrackProperties;
      }
      
      public function set maximumTrackProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         var _loc3_:String = null;
         if(this._maximumTrackProperties == param1)
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
         if(this._maximumTrackProperties)
         {
            this._maximumTrackProperties.removeOnChangeCallback(this.childProperties_onChange);
         }
         this._maximumTrackProperties = PropertyProxy(param1);
         if(this._maximumTrackProperties)
         {
            this._maximumTrackProperties.addOnChangeCallback(this.childProperties_onChange);
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
      
      override public function hitTest(param1:Point) : DisplayObject
      {
         var _loc2_:DisplayObject = super.hitTest(param1);
         if(_loc2_ !== null && this._trackInteractionMode === TrackInteractionMode.TO_VALUE)
         {
            return this.thumb;
         }
         return _loc2_;
      }
      
      override protected function initialize() : void
      {
         if(this._value < this._minimum)
         {
            this.value = this._minimum;
         }
         else if(this._value > this._maximum)
         {
            this.value = this._maximum;
         }
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         var _loc4_:Boolean = this.isInvalid(INVALIDATION_FLAG_FOCUS);
         var _loc5_:Boolean = this.isInvalid(INVALIDATION_FLAG_LAYOUT);
         var _loc6_:Boolean = this.isInvalid(INVALIDATION_FLAG_THUMB_FACTORY);
         var _loc7_:Boolean = this.isInvalid(INVALIDATION_FLAG_MINIMUM_TRACK_FACTORY);
         var _loc8_:Boolean = this.isInvalid(INVALIDATION_FLAG_MAXIMUM_TRACK_FACTORY);
         if(_loc6_)
         {
            this.createThumb();
         }
         if(_loc7_)
         {
            this.createMinimumTrack();
         }
         if(_loc8_ || _loc5_)
         {
            this.createMaximumTrack();
         }
         if(_loc6_ || _loc1_)
         {
            this.refreshThumbStyles();
         }
         if(_loc7_ || _loc1_)
         {
            this.refreshMinimumTrackStyles();
         }
         if((_loc8_ || _loc5_ || _loc1_) && Boolean(this.maximumTrack))
         {
            this.refreshMaximumTrackStyles();
         }
         if(_loc3_ || _loc6_ || _loc7_ || _loc8_)
         {
            this.refreshEnabled();
         }
         _loc2_ = this.autoSizeIfNeeded() || _loc2_;
         this.layoutChildren();
         if(_loc2_ || _loc4_)
         {
            this.refreshFocusIndicator();
         }
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         if(this._direction === Direction.VERTICAL)
         {
            return this.measureVertical();
         }
         return this.measureHorizontal();
      }
      
      protected function measureVertical() : Boolean
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
         if(_loc2_)
         {
            this.minimumTrack.height = this._minimumTrackSkinExplicitHeight;
         }
         else if(_loc5_)
         {
            this.minimumTrack.height = this._explicitHeight;
         }
         if(this.minimumTrack is IMeasureDisplayObject)
         {
            _loc10_ = IMeasureDisplayObject(this.minimumTrack);
            if(_loc4_)
            {
               _loc10_.minHeight = this._minimumTrackSkinExplicitMinHeight;
            }
            else if(_loc5_)
            {
               _loc11_ = this._explicitMinHeight;
               if(this._minimumTrackSkinExplicitMinHeight > _loc11_)
               {
                  _loc11_ = this._minimumTrackSkinExplicitMinHeight;
               }
               _loc10_.minHeight = _loc11_;
            }
         }
         if(!_loc5_)
         {
            if(_loc2_)
            {
               this.maximumTrack.height = this._maximumTrackSkinExplicitHeight;
            }
            if(this.maximumTrack is IMeasureDisplayObject)
            {
               _loc12_ = IMeasureDisplayObject(this.maximumTrack);
               if(_loc4_)
               {
                  _loc12_.minHeight = this._maximumTrackSkinExplicitMinHeight;
               }
            }
         }
         if(this.minimumTrack is IValidating)
         {
            IValidating(this.minimumTrack).validate();
         }
         if(this.maximumTrack is IValidating)
         {
            IValidating(this.maximumTrack).validate();
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
            _loc6_ = this.minimumTrack.width;
            if(!_loc5_ && this.maximumTrack.width > _loc6_)
            {
               _loc6_ = this.maximumTrack.width;
            }
            if(this.thumb.width > _loc6_)
            {
               _loc6_ = this.thumb.width;
            }
         }
         if(_loc2_)
         {
            _loc7_ = this.minimumTrack.height;
            if(!_loc5_)
            {
               if(this.maximumTrack.height > _loc7_)
               {
                  _loc7_ = this.maximumTrack.height;
               }
               _loc7_ += this.thumb.height / 2;
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
               _loc8_ = this.minimumTrack.width;
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
               else if(this.maximumTrack.width > _loc8_)
               {
                  _loc8_ = this.maximumTrack.width;
               }
            }
            if(this.thumb is IMeasureDisplayObject)
            {
               _loc13_ = IMeasureDisplayObject(this.thumb);
               if(_loc13_.minWidth > _loc8_)
               {
                  _loc8_ = _loc13_.minWidth;
               }
            }
            else if(this.thumb.width > _loc8_)
            {
               _loc8_ = this.thumb.width;
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
               _loc9_ = this.minimumTrack.height;
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
               else
               {
                  _loc9_ = this.maximumTrack.height;
               }
               if(this.thumb is IMeasureDisplayObject)
               {
                  _loc9_ += IMeasureDisplayObject(this.thumb).minHeight / 2;
               }
               else
               {
                  _loc9_ += this.thumb.height / 2;
               }
            }
         }
         return this.saveMeasurements(_loc6_,_loc7_,_loc8_,_loc9_);
      }
      
      protected function measureHorizontal() : Boolean
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
            this.minimumTrack.width = this._minimumTrackSkinExplicitWidth;
         }
         else if(_loc5_)
         {
            this.minimumTrack.width = this._explicitWidth;
         }
         if(this.minimumTrack is IMeasureDisplayObject)
         {
            _loc10_ = IMeasureDisplayObject(this.minimumTrack);
            if(_loc3_)
            {
               _loc10_.minWidth = this._minimumTrackSkinExplicitMinWidth;
            }
            else if(_loc5_)
            {
               _loc11_ = this._explicitMinWidth;
               if(this._minimumTrackSkinExplicitMinWidth > _loc11_)
               {
                  _loc11_ = this._minimumTrackSkinExplicitMinWidth;
               }
               _loc10_.minWidth = _loc11_;
            }
         }
         if(!_loc5_)
         {
            if(_loc1_)
            {
               this.maximumTrack.width = this._maximumTrackSkinExplicitWidth;
            }
            if(this.maximumTrack is IMeasureDisplayObject)
            {
               _loc12_ = IMeasureDisplayObject(this.maximumTrack);
               if(_loc3_)
               {
                  _loc12_.minWidth = this._maximumTrackSkinExplicitMinWidth;
               }
            }
         }
         if(this.minimumTrack is IValidating)
         {
            IValidating(this.minimumTrack).validate();
         }
         if(this.maximumTrack is IValidating)
         {
            IValidating(this.maximumTrack).validate();
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
            _loc6_ = this.minimumTrack.width;
            if(!_loc5_)
            {
               if(this.maximumTrack.width > _loc6_)
               {
                  _loc6_ = this.maximumTrack.width;
               }
               _loc6_ += this.thumb.width / 2;
            }
         }
         if(_loc2_)
         {
            _loc7_ = this.minimumTrack.height;
            if(!_loc5_ && this.maximumTrack.height > _loc7_)
            {
               _loc7_ = this.maximumTrack.height;
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
               _loc8_ = this.minimumTrack.width;
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
               else if(this.maximumTrack.width > _loc8_)
               {
                  _loc8_ = this.maximumTrack.width;
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
               _loc9_ = this.minimumTrack.height;
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
               else if(this.maximumTrack.height > _loc9_)
               {
                  _loc9_ = this.maximumTrack.height;
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
         if(this.thumb)
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
      
      protected function createMinimumTrack() : void
      {
         var _loc4_:IMeasureDisplayObject = null;
         if(this.minimumTrack)
         {
            this.minimumTrack.removeFromParent(true);
            this.minimumTrack = null;
         }
         var _loc1_:Function = this._minimumTrackFactory != null ? this._minimumTrackFactory : defaultMinimumTrackFactory;
         var _loc2_:String = this._customMinimumTrackStyleName != null ? this._customMinimumTrackStyleName : this.minimumTrackStyleName;
         var _loc3_:BasicButton = BasicButton(_loc1_());
         _loc3_.styleNameList.add(_loc2_);
         _loc3_.keepDownStateOnRollOut = true;
         _loc3_.addEventListener(TouchEvent.TOUCH,this.track_touchHandler);
         this.addChildAt(_loc3_,0);
         this.minimumTrack = _loc3_;
         if(this.minimumTrack is IFeathersControl)
         {
            IFeathersControl(this.minimumTrack).initializeNow();
         }
         if(this.minimumTrack is IMeasureDisplayObject)
         {
            _loc4_ = IMeasureDisplayObject(this.minimumTrack);
            this._minimumTrackSkinExplicitWidth = _loc4_.explicitWidth;
            this._minimumTrackSkinExplicitHeight = _loc4_.explicitHeight;
            this._minimumTrackSkinExplicitMinWidth = _loc4_.explicitMinWidth;
            this._minimumTrackSkinExplicitMinHeight = _loc4_.explicitMinHeight;
         }
         else
         {
            this._minimumTrackSkinExplicitWidth = this.minimumTrack.width;
            this._minimumTrackSkinExplicitHeight = this.minimumTrack.height;
            this._minimumTrackSkinExplicitMinWidth = this._minimumTrackSkinExplicitWidth;
            this._minimumTrackSkinExplicitMinHeight = this._minimumTrackSkinExplicitHeight;
         }
      }
      
      protected function createMaximumTrack() : void
      {
         var _loc4_:IMeasureDisplayObject = null;
         if(this.maximumTrack !== null)
         {
            this.maximumTrack.removeFromParent(true);
            this.maximumTrack = null;
         }
         if(this._trackLayoutMode === TrackLayoutMode.SINGLE)
         {
            return;
         }
         var _loc1_:Function = this._maximumTrackFactory != null ? this._maximumTrackFactory : defaultMaximumTrackFactory;
         var _loc2_:String = this._customMaximumTrackStyleName != null ? this._customMaximumTrackStyleName : this.maximumTrackStyleName;
         var _loc3_:BasicButton = BasicButton(_loc1_());
         _loc3_.styleNameList.add(_loc2_);
         _loc3_.keepDownStateOnRollOut = true;
         _loc3_.addEventListener(TouchEvent.TOUCH,this.track_touchHandler);
         this.addChildAt(_loc3_,1);
         this.maximumTrack = _loc3_;
         if(this.maximumTrack is IFeathersControl)
         {
            IFeathersControl(this.maximumTrack).initializeNow();
         }
         if(this.maximumTrack is IMeasureDisplayObject)
         {
            _loc4_ = IMeasureDisplayObject(this.maximumTrack);
            this._maximumTrackSkinExplicitWidth = _loc4_.explicitWidth;
            this._maximumTrackSkinExplicitHeight = _loc4_.explicitHeight;
            this._maximumTrackSkinExplicitMinWidth = _loc4_.explicitMinWidth;
            this._maximumTrackSkinExplicitMinHeight = _loc4_.explicitMinHeight;
         }
         else
         {
            this._maximumTrackSkinExplicitWidth = this.maximumTrack.width;
            this._maximumTrackSkinExplicitHeight = this.maximumTrack.height;
            this._maximumTrackSkinExplicitMinWidth = this._maximumTrackSkinExplicitWidth;
            this._maximumTrackSkinExplicitMinHeight = this._maximumTrackSkinExplicitHeight;
         }
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
      
      protected function refreshMinimumTrackStyles() : void
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         for(_loc1_ in this._minimumTrackProperties)
         {
            _loc2_ = this._minimumTrackProperties[_loc1_];
            this.minimumTrack[_loc1_] = _loc2_;
         }
      }
      
      protected function refreshMaximumTrackStyles() : void
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         if(!this.maximumTrack)
         {
            return;
         }
         for(_loc1_ in this._maximumTrackProperties)
         {
            _loc2_ = this._maximumTrackProperties[_loc1_];
            this.maximumTrack[_loc1_] = _loc2_;
         }
      }
      
      protected function refreshEnabled() : void
      {
         if(this.thumb is IFeathersControl)
         {
            IFeathersControl(this.thumb).isEnabled = this._isEnabled;
         }
         if(this.minimumTrack is IFeathersControl)
         {
            IFeathersControl(this.minimumTrack).isEnabled = this._isEnabled;
         }
         if(this.maximumTrack is IFeathersControl)
         {
            IFeathersControl(this.maximumTrack).isEnabled = this._isEnabled;
         }
      }
      
      protected function layoutChildren() : void
      {
         this.layoutThumb();
         if(this._trackLayoutMode == TrackLayoutMode.SPLIT)
         {
            this.layoutTrackWithMinMax();
         }
         else
         {
            this.layoutTrackWithSingle();
         }
      }
      
      protected function layoutThumb() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this.thumb is IValidating)
         {
            IValidating(this.thumb).validate();
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
         if(this._direction == Direction.VERTICAL)
         {
            _loc2_ = this.actualHeight - this.thumb.height - this._minimumPadding - this._maximumPadding;
            this.thumb.x = Math.round((this.actualWidth - this.thumb.width) / 2) + this._thumbOffset;
            this.thumb.y = Math.round(this._maximumPadding + _loc2_ * (1 - _loc1_));
         }
         else
         {
            _loc3_ = this.actualWidth - this.thumb.width - this._minimumPadding - this._maximumPadding;
            this.thumb.x = Math.round(this._minimumPadding + _loc3_ * _loc1_);
            this.thumb.y = Math.round((this.actualHeight - this.thumb.height) / 2) + this._thumbOffset;
         }
      }
      
      protected function layoutTrackWithMinMax() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         if(this._direction === Direction.VERTICAL)
         {
            _loc1_ = Math.round(this.thumb.y + this.thumb.height / 2);
            this.maximumTrack.y = 0;
            this.maximumTrack.height = _loc1_;
            this.minimumTrack.y = _loc1_;
            this.minimumTrack.height = this.actualHeight - _loc1_;
            if(this._trackScaleMode === TrackScaleMode.EXACT_FIT)
            {
               this.maximumTrack.x = 0;
               this.maximumTrack.width = this.actualWidth;
               this.minimumTrack.x = 0;
               this.minimumTrack.width = this.actualWidth;
            }
            else
            {
               this.maximumTrack.width = this._maximumTrackSkinExplicitWidth;
               this.minimumTrack.width = this._minimumTrackSkinExplicitWidth;
            }
            if(this.minimumTrack is IValidating)
            {
               IValidating(this.minimumTrack).validate();
            }
            if(this.maximumTrack is IValidating)
            {
               IValidating(this.maximumTrack).validate();
            }
            if(this._trackScaleMode === TrackScaleMode.DIRECTIONAL)
            {
               this.maximumTrack.x = Math.round((this.actualWidth - this.maximumTrack.width) / 2);
               this.minimumTrack.x = Math.round((this.actualWidth - this.minimumTrack.width) / 2);
            }
         }
         else
         {
            _loc2_ = Math.round(this.thumb.x + this.thumb.width / 2);
            this.minimumTrack.x = 0;
            this.minimumTrack.width = _loc2_;
            this.maximumTrack.x = _loc2_;
            this.maximumTrack.width = this.actualWidth - _loc2_;
            if(this._trackScaleMode === TrackScaleMode.EXACT_FIT)
            {
               this.minimumTrack.y = 0;
               this.minimumTrack.height = this.actualHeight;
               this.maximumTrack.y = 0;
               this.maximumTrack.height = this.actualHeight;
            }
            else
            {
               this.minimumTrack.height = this._minimumTrackSkinExplicitHeight;
               this.maximumTrack.height = this._maximumTrackSkinExplicitHeight;
            }
            if(this.minimumTrack is IValidating)
            {
               IValidating(this.minimumTrack).validate();
            }
            if(this.maximumTrack is IValidating)
            {
               IValidating(this.maximumTrack).validate();
            }
            if(this._trackScaleMode === TrackScaleMode.DIRECTIONAL)
            {
               this.minimumTrack.y = Math.round((this.actualHeight - this.minimumTrack.height) / 2);
               this.maximumTrack.y = Math.round((this.actualHeight - this.maximumTrack.height) / 2);
            }
         }
      }
      
      protected function layoutTrackWithSingle() : void
      {
         if(this._direction === Direction.VERTICAL)
         {
            this.minimumTrack.y = 0;
            this.minimumTrack.height = this.actualHeight;
            if(this._trackScaleMode === TrackScaleMode.EXACT_FIT)
            {
               this.minimumTrack.x = 0;
               this.minimumTrack.width = this.actualWidth;
            }
            else
            {
               this.minimumTrack.width = this._minimumTrackSkinExplicitWidth;
            }
            if(this.minimumTrack is IValidating)
            {
               IValidating(this.minimumTrack).validate();
            }
            if(this._trackScaleMode === TrackScaleMode.DIRECTIONAL)
            {
               this.minimumTrack.x = Math.round((this.actualWidth - this.minimumTrack.width) / 2);
            }
         }
         else
         {
            this.minimumTrack.x = 0;
            this.minimumTrack.width = this.actualWidth;
            if(this._trackScaleMode === TrackScaleMode.EXACT_FIT)
            {
               this.minimumTrack.y = 0;
               this.minimumTrack.height = this.actualHeight;
            }
            else
            {
               this.minimumTrack.height = this._minimumTrackSkinExplicitHeight;
            }
            if(this.minimumTrack is IValidating)
            {
               IValidating(this.minimumTrack).validate();
            }
            if(this._trackScaleMode === TrackScaleMode.DIRECTIONAL)
            {
               this.minimumTrack.y = Math.round((this.actualHeight - this.minimumTrack.height) / 2);
            }
         }
      }
      
      protected function locationToValue(param1:Point) : Number
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         if(this._direction == Direction.VERTICAL)
         {
            _loc3_ = this.actualHeight - this.thumb.height - this._minimumPadding - this._maximumPadding;
            _loc4_ = param1.y - this._touchStartY - this._maximumPadding;
            _loc5_ = Math.min(Math.max(0,this._thumbStartY + _loc4_),_loc3_);
            _loc2_ = 1 - _loc5_ / _loc3_;
         }
         else
         {
            _loc6_ = this.actualWidth - this.thumb.width - this._minimumPadding - this._maximumPadding;
            _loc7_ = param1.x - this._touchStartX - this._minimumPadding;
            _loc8_ = Math.min(Math.max(0,this._thumbStartX + _loc7_),_loc6_);
            _loc2_ = _loc8_ / _loc6_;
         }
         return this._minimum + _loc2_ * (this._maximum - this._minimum);
      }
      
      protected function startRepeatTimer(param1:Function) : void
      {
         this.currentRepeatAction = param1;
         if(this._repeatDelay > 0)
         {
            if(!this._repeatTimer)
            {
               this._repeatTimer = new Timer(this._repeatDelay * 1000);
               this._repeatTimer.addEventListener(TimerEvent.TIMER,this.repeatTimer_timerHandler);
            }
            else
            {
               this._repeatTimer.reset();
               this._repeatTimer.delay = this._repeatDelay * 1000;
            }
            this._repeatTimer.start();
         }
      }
      
      protected function adjustPage() : void
      {
         var _loc2_:Number = NaN;
         var _loc1_:Number = this._page;
         if(_loc1_ !== _loc1_)
         {
            _loc1_ = this._step;
         }
         if(this._touchValue < this._pageStartValue)
         {
            _loc2_ = Math.max(this._touchValue,this._value - _loc1_);
            if(this._step != 0 && _loc2_ != this._maximum && _loc2_ != this._minimum)
            {
               _loc2_ = roundDownToNearest(_loc2_,this._step);
            }
            this.value = _loc2_;
         }
         else if(this._touchValue > this._pageStartValue)
         {
            _loc2_ = Math.min(this._touchValue,this._value + _loc1_);
            if(this._step != 0 && _loc2_ != this._maximum && _loc2_ != this._minimum)
            {
               _loc2_ = roundUpToNearest(_loc2_,this._step);
            }
            this.value = _loc2_;
         }
      }
      
      protected function childProperties_onChange(param1:PropertyProxy, param2:Object) : void
      {
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      protected function slider_removedFromStageHandler(param1:Event) : void
      {
         this._touchPointID = -1;
         var _loc2_:Boolean = this.isDragging;
         this.isDragging = false;
         if(_loc2_ && !this.liveDragging)
         {
            this.dispatchEventWith(Event.CHANGE);
         }
      }
      
      override protected function focusInHandler(param1:Event) : void
      {
         super.focusInHandler(param1);
         this.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.stage_keyDownHandler);
      }
      
      override protected function focusOutHandler(param1:Event) : void
      {
         super.focusOutHandler(param1);
         this.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.stage_keyDownHandler);
      }
      
      protected function track_touchHandler(param1:TouchEvent) : void
      {
         var _loc3_:Touch = null;
         var _loc4_:Point = null;
         if(!this._isEnabled)
         {
            this._touchPointID = -1;
            return;
         }
         var _loc2_:DisplayObject = DisplayObject(param1.currentTarget);
         if(this._touchPointID >= 0)
         {
            _loc3_ = param1.getTouch(_loc2_,null,this._touchPointID);
            if(_loc3_ === null)
            {
               return;
            }
            if(_loc3_.phase === TouchPhase.MOVED)
            {
               _loc4_ = _loc3_.getLocation(this,Pool.getPoint());
               this._touchValue = this.locationToValue(_loc4_);
               Pool.putPoint(_loc4_);
               if(!this._showThumb || this._trackInteractionMode !== TrackInteractionMode.BY_PAGE)
               {
                  this.value = this._touchValue;
               }
            }
            else if(_loc3_.phase === TouchPhase.ENDED)
            {
               if(this._repeatTimer !== null)
               {
                  this._repeatTimer.stop();
               }
               this._touchPointID = -1;
               this.isDragging = false;
               if(!this.liveDragging)
               {
                  this.dispatchEventWith(Event.CHANGE);
               }
               this.dispatchEventWith(FeathersEventType.END_INTERACTION);
            }
         }
         else
         {
            _loc3_ = param1.getTouch(_loc2_,TouchPhase.BEGAN);
            if(_loc3_ === null)
            {
               return;
            }
            _loc4_ = _loc3_.getLocation(this,Pool.getPoint());
            this._touchPointID = _loc3_.id;
            if(this._direction == Direction.VERTICAL)
            {
               this._thumbStartX = _loc4_.x;
               this._thumbStartY = Math.min(this.actualHeight - this.thumb.height - this._maximumPadding,Math.max(this._minimumPadding,_loc4_.y - this.thumb.height / 2));
            }
            else
            {
               this._thumbStartX = Math.min(this.actualWidth - this.thumb.width - this._maximumPadding,Math.max(this._minimumPadding,_loc4_.x - this.thumb.width / 2));
               this._thumbStartY = _loc4_.y;
            }
            this._touchStartX = _loc4_.x;
            this._touchStartY = _loc4_.y;
            this._touchValue = this.locationToValue(_loc4_);
            Pool.putPoint(_loc4_);
            this._pageStartValue = this._value;
            this.isDragging = true;
            this.dispatchEventWith(FeathersEventType.BEGIN_INTERACTION);
            if(this._showThumb && this._trackInteractionMode === TrackInteractionMode.BY_PAGE)
            {
               this.adjustPage();
               this.startRepeatTimer(this.adjustPage);
            }
            else
            {
               this.value = this._touchValue;
            }
         }
      }
      
      protected function thumb_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         var _loc3_:Point = null;
         var _loc4_:ExclusiveTouch = null;
         var _loc5_:DisplayObject = null;
         if(!this._isEnabled)
         {
            this._touchPointID = -1;
            return;
         }
         if(this._trackInteractionMode === TrackInteractionMode.TO_VALUE)
         {
            _loc2_ = param1.getTouch(this.thumb,null,this._touchPointID);
            if(_loc2_ !== null)
            {
               _loc3_ = _loc2_.getLocation(this.thumb,Pool.getPoint());
               if(this.thumb.hitTest(_loc3_) === null)
               {
                  Pool.putPoint(_loc3_);
                  this.track_touchHandler(param1);
                  return;
               }
               Pool.putPoint(_loc3_);
            }
         }
         if(this._touchPointID >= 0)
         {
            _loc2_ = param1.getTouch(this.thumb,null,this._touchPointID);
            if(_loc2_ === null)
            {
               return;
            }
            if(_loc2_.phase === TouchPhase.MOVED)
            {
               _loc4_ = ExclusiveTouch.forStage(this.stage);
               _loc5_ = _loc4_.getClaim(this._touchPointID);
               if(_loc5_ != this)
               {
                  if(_loc5_)
                  {
                     return;
                  }
                  _loc4_.claimTouch(this._touchPointID,this);
               }
               _loc3_ = _loc2_.getLocation(this,Pool.getPoint());
               this.value = this.locationToValue(_loc3_);
               Pool.putPoint(_loc3_);
            }
            else if(_loc2_.phase === TouchPhase.ENDED)
            {
               this._touchPointID = -1;
               this.isDragging = false;
               if(!this.liveDragging)
               {
                  this.dispatchEventWith(Event.CHANGE);
               }
               this.dispatchEventWith(FeathersEventType.END_INTERACTION);
            }
         }
         else
         {
            _loc2_ = param1.getTouch(this.thumb,TouchPhase.BEGAN);
            if(_loc2_ === null)
            {
               return;
            }
            _loc3_ = _loc2_.getLocation(this,Pool.getPoint());
            this._touchPointID = _loc2_.id;
            this._thumbStartX = this.thumb.x;
            this._thumbStartY = this.thumb.y;
            this._touchStartX = _loc3_.x;
            this._touchStartY = _loc3_.y;
            Pool.putPoint(_loc3_);
            this.isDragging = true;
            this.dispatchEventWith(FeathersEventType.BEGIN_INTERACTION);
         }
      }
      
      protected function stage_keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.HOME)
         {
            param1.preventDefault();
            this.value = this._minimum;
            return;
         }
         if(param1.keyCode == Keyboard.END)
         {
            param1.preventDefault();
            this.value = this._maximum;
            return;
         }
         var _loc2_:Number = this._page;
         if(_loc2_ !== _loc2_)
         {
            _loc2_ = this._step;
         }
         if(this._direction == Direction.VERTICAL)
         {
            if(param1.keyCode == Keyboard.UP)
            {
               param1.preventDefault();
               if(param1.shiftKey)
               {
                  this.value += _loc2_;
               }
               else
               {
                  this.value += this._step;
               }
            }
            else if(param1.keyCode == Keyboard.DOWN)
            {
               param1.preventDefault();
               if(param1.shiftKey)
               {
                  this.value -= _loc2_;
               }
               else
               {
                  this.value -= this._step;
               }
            }
         }
         else if(param1.keyCode == Keyboard.LEFT)
         {
            param1.preventDefault();
            if(param1.shiftKey)
            {
               this.value -= _loc2_;
            }
            else
            {
               this.value -= this._step;
            }
         }
         else if(param1.keyCode == Keyboard.RIGHT)
         {
            param1.preventDefault();
            if(param1.shiftKey)
            {
               this.value += _loc2_;
            }
            else
            {
               this.value += this._step;
            }
         }
      }
      
      protected function repeatTimer_timerHandler(param1:TimerEvent) : void
      {
         var _loc2_:ExclusiveTouch = ExclusiveTouch.forStage(this.stage);
         var _loc3_:DisplayObject = _loc2_.getClaim(this._touchPointID);
         if(Boolean(_loc3_) && _loc3_ != this)
         {
            return;
         }
         if(this._repeatTimer.currentCount < 5)
         {
            return;
         }
         this.currentRepeatAction();
      }
   }
}

