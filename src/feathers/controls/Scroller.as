package feathers.controls
{
   import feathers.controls.supportClasses.IViewPort;
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.IFocusDisplayObject;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.IValidating;
   import feathers.core.PropertyProxy;
   import feathers.events.ExclusiveTouch;
   import feathers.events.FeathersEventType;
   import feathers.layout.Direction;
   import feathers.layout.RelativePosition;
   import feathers.system.DeviceCapabilities;
   import feathers.utils.display.getDisplayObjectDepthFromStage;
   import feathers.utils.math.roundDownToNearest;
   import feathers.utils.math.roundToNearest;
   import feathers.utils.math.roundUpToNearest;
   import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;
   import flash.errors.IllegalOperationError;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TransformGestureEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.display.Quad;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.MathUtil;
   import starling.utils.Pool;
   
   public class Scroller extends FeathersControl implements IFocusDisplayObject
   {
      
      protected static const INVALIDATION_FLAG_SCROLL_BAR_RENDERER:String = "scrollBarRenderer";
      
      protected static const INVALIDATION_FLAG_PENDING_SCROLL:String = "pendingScroll";
      
      protected static const INVALIDATION_FLAG_PENDING_REVEAL_SCROLL_BARS:String = "pendingRevealScrollBars";
      
      protected static const INVALIDATION_FLAG_PENDING_PULL_VIEW:String = "pendingPullView";
      
      protected static const INVALIDATION_FLAG_CLIPPING:String = "clipping";
      
      private static const MINIMUM_VELOCITY:Number = 0.02;
      
      private static const CURRENT_VELOCITY_WEIGHT:Number = 2.33;
      
      private static const VELOCITY_WEIGHTS:Vector.<Number> = new <Number>[1,1.33,1.66,2];
      
      private static const MAXIMUM_SAVED_VELOCITY_COUNT:int = 4;
      
      public static const DEFAULT_CHILD_STYLE_NAME_HORIZONTAL_SCROLL_BAR:String = "feathers-scroller-horizontal-scroll-bar";
      
      public static const DEFAULT_CHILD_STYLE_NAME_VERTICAL_SCROLL_BAR:String = "feathers-scroller-vertical-scroll-bar";
      
      protected static const PAGE_INDEX_EPSILON:Number = 0.01;
      
      protected var horizontalScrollBarStyleName:String = "feathers-scroller-horizontal-scroll-bar";
      
      protected var verticalScrollBarStyleName:String = "feathers-scroller-vertical-scroll-bar";
      
      protected var horizontalScrollBar:IScrollBar;
      
      protected var verticalScrollBar:IScrollBar;
      
      protected var _topViewPortOffset:Number;
      
      protected var _rightViewPortOffset:Number;
      
      protected var _bottomViewPortOffset:Number;
      
      protected var _leftViewPortOffset:Number;
      
      protected var _hasHorizontalScrollBar:Boolean = false;
      
      protected var _hasVerticalScrollBar:Boolean = false;
      
      protected var _horizontalScrollBarTouchPointID:int = -1;
      
      protected var _verticalScrollBarTouchPointID:int = -1;
      
      protected var _touchPointID:int = -1;
      
      protected var _startTouchX:Number;
      
      protected var _startTouchY:Number;
      
      protected var _startHorizontalScrollPosition:Number;
      
      protected var _startVerticalScrollPosition:Number;
      
      protected var _currentTouchX:Number;
      
      protected var _currentTouchY:Number;
      
      protected var _previousTouchTime:int;
      
      protected var _previousTouchX:Number;
      
      protected var _previousTouchY:Number;
      
      protected var _velocityX:Number = 0;
      
      protected var _velocityY:Number = 0;
      
      protected var _previousVelocityX:Vector.<Number> = new Vector.<Number>(0);
      
      protected var _previousVelocityY:Vector.<Number> = new Vector.<Number>(0);
      
      protected var _pendingVelocityChange:Boolean = false;
      
      protected var _lastViewPortWidth:Number = 0;
      
      protected var _lastViewPortHeight:Number = 0;
      
      protected var _hasViewPortBoundsChanged:Boolean = false;
      
      protected var _horizontalAutoScrollTween:Tween;
      
      protected var _verticalAutoScrollTween:Tween;
      
      protected var _topPullTween:Tween;
      
      protected var _rightPullTween:Tween;
      
      protected var _bottomPullTween:Tween;
      
      protected var _leftPullTween:Tween;
      
      protected var _isDraggingHorizontally:Boolean = false;
      
      protected var _isDraggingVertically:Boolean = false;
      
      protected var ignoreViewPortResizing:Boolean = false;
      
      protected var _viewPort:IViewPort;
      
      protected var _explicitViewPortWidth:Number;
      
      protected var _explicitViewPortHeight:Number;
      
      protected var _explicitViewPortMinWidth:Number;
      
      protected var _explicitViewPortMinHeight:Number;
      
      protected var _measureViewPort:Boolean = true;
      
      protected var _snapToPages:Boolean = false;
      
      protected var _snapOnComplete:Boolean = false;
      
      protected var _horizontalScrollBarFactory:Function = defaultScrollBarFactory;
      
      protected var _customHorizontalScrollBarStyleName:String;
      
      protected var _horizontalScrollBarProperties:PropertyProxy;
      
      protected var _verticalScrollBarPosition:String = "right";
      
      protected var _horizontalScrollBarPosition:String = "bottom";
      
      protected var _verticalScrollBarFactory:Function = defaultScrollBarFactory;
      
      protected var _customVerticalScrollBarStyleName:String;
      
      protected var _verticalScrollBarProperties:PropertyProxy;
      
      protected var actualHorizontalScrollStep:Number = 1;
      
      protected var explicitHorizontalScrollStep:Number = NaN;
      
      protected var _targetHorizontalScrollPosition:Number;
      
      protected var _horizontalScrollPosition:Number = 0;
      
      protected var _minHorizontalScrollPosition:Number = 0;
      
      protected var _maxHorizontalScrollPosition:Number = 0;
      
      protected var _horizontalPageIndex:int = 0;
      
      protected var _minHorizontalPageIndex:int = 0;
      
      protected var _maxHorizontalPageIndex:int = 0;
      
      protected var _horizontalScrollPolicy:String = "auto";
      
      protected var actualVerticalScrollStep:Number = 1;
      
      protected var explicitVerticalScrollStep:Number = NaN;
      
      protected var _verticalMouseWheelScrollStep:Number = NaN;
      
      protected var _targetVerticalScrollPosition:Number;
      
      protected var _verticalScrollPosition:Number = 0;
      
      protected var _minVerticalScrollPosition:Number = 0;
      
      protected var _maxVerticalScrollPosition:Number = 0;
      
      protected var _verticalPageIndex:int = 0;
      
      protected var _minVerticalPageIndex:int = 0;
      
      protected var _maxVerticalPageIndex:int = 0;
      
      protected var _verticalScrollPolicy:String = "auto";
      
      protected var _clipContent:Boolean = true;
      
      protected var actualPageWidth:Number = 0;
      
      protected var explicitPageWidth:Number = NaN;
      
      protected var actualPageHeight:Number = 0;
      
      protected var explicitPageHeight:Number = NaN;
      
      protected var _hasElasticEdges:Boolean = true;
      
      protected var _elasticity:Number = 0.33;
      
      protected var _throwElasticity:Number = 0.05;
      
      protected var _scrollBarDisplayMode:String = "float";
      
      protected var _interactionMode:String = "touch";
      
      protected var _explicitBackgroundWidth:Number;
      
      protected var _explicitBackgroundHeight:Number;
      
      protected var _explicitBackgroundMinWidth:Number;
      
      protected var _explicitBackgroundMinHeight:Number;
      
      protected var _explicitBackgroundMaxWidth:Number;
      
      protected var _explicitBackgroundMaxHeight:Number;
      
      protected var currentBackgroundSkin:DisplayObject;
      
      protected var _backgroundSkin:DisplayObject;
      
      protected var _backgroundDisabledSkin:DisplayObject;
      
      protected var _autoHideBackground:Boolean = false;
      
      protected var _minimumDragDistance:Number = 0.04;
      
      protected var _minimumPageThrowVelocity:Number = 5;
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var _horizontalScrollBarHideTween:Tween;
      
      protected var _verticalScrollBarHideTween:Tween;
      
      protected var _hideScrollBarAnimationDuration:Number = 0.2;
      
      protected var _hideScrollBarAnimationEase:Object = "easeOut";
      
      protected var _elasticSnapDuration:Number = 0.5;
      
      protected var _logDecelerationRate:Number = -0.0020020026706730793;
      
      protected var _decelerationRate:Number = 0.998;
      
      protected var _fixedThrowDuration:Number = 2.996998998998728;
      
      protected var _useFixedThrowDuration:Boolean = true;
      
      protected var _pageThrowDuration:Number = 0.5;
      
      protected var _mouseWheelScrollDuration:Number = 0.35;
      
      protected var _verticalMouseWheelScrollDirection:String = "vertical";
      
      protected var _throwEase:Object = defaultThrowEase;
      
      protected var _snapScrollPositionsToPixels:Boolean = true;
      
      protected var _horizontalScrollBarIsScrolling:Boolean = false;
      
      protected var _verticalScrollBarIsScrolling:Boolean = false;
      
      protected var _isScrolling:Boolean = false;
      
      protected var _isScrollingStopped:Boolean = false;
      
      protected var pendingHorizontalScrollPosition:Number = NaN;
      
      protected var pendingVerticalScrollPosition:Number = NaN;
      
      protected var hasPendingHorizontalPageIndex:Boolean = false;
      
      protected var hasPendingVerticalPageIndex:Boolean = false;
      
      protected var pendingHorizontalPageIndex:int;
      
      protected var pendingVerticalPageIndex:int;
      
      protected var pendingScrollDuration:Number;
      
      protected var isScrollBarRevealPending:Boolean = false;
      
      protected var _revealScrollBarsDuration:Number = 1;
      
      protected var _isTopPullViewPending:Boolean = false;
      
      protected var _isTopPullViewActive:Boolean = false;
      
      protected var _topPullView:DisplayObject = null;
      
      protected var _topPullViewDisplayMode:String = "drag";
      
      protected var _topPullViewRatio:Number = 0;
      
      protected var _isRightPullViewPending:Boolean = false;
      
      protected var _isRightPullViewActive:Boolean = false;
      
      protected var _rightPullView:DisplayObject = null;
      
      protected var _rightPullViewDisplayMode:String = "drag";
      
      protected var _rightPullViewRatio:Number = 0;
      
      protected var _isBottomPullViewPending:Boolean = false;
      
      protected var _isBottomPullViewActive:Boolean = false;
      
      protected var _bottomPullView:DisplayObject = null;
      
      protected var _bottomPullViewDisplayMode:String = "drag";
      
      protected var _bottomPullViewRatio:Number = 0;
      
      protected var _isLeftPullViewPending:Boolean = false;
      
      protected var _isLeftPullViewActive:Boolean = false;
      
      protected var _leftPullView:DisplayObject = null;
      
      protected var _leftPullViewRatio:Number = 0;
      
      protected var _leftPullViewDisplayMode:String = "drag";
      
      protected var _horizontalAutoScrollTweenEndRatio:Number = 1;
      
      protected var _verticalAutoScrollTweenEndRatio:Number = 1;
      
      public function Scroller()
      {
         super();
         this.addEventListener(starling.events.Event.ADDED_TO_STAGE,this.scroller_addedToStageHandler);
         this.addEventListener(starling.events.Event.REMOVED_FROM_STAGE,this.scroller_removedFromStageHandler);
      }
      
      protected static function defaultScrollBarFactory() : IScrollBar
      {
         return new SimpleScrollBar();
      }
      
      protected static function defaultThrowEase(param1:Number) : Number
      {
         param1--;
         return 1 - param1 * param1 * param1 * param1;
      }
      
      override public function get isFocusEnabled() : Boolean
      {
         return (this._maxVerticalScrollPosition != this._minVerticalScrollPosition || this._maxHorizontalScrollPosition != this._minHorizontalScrollPosition) && super.isFocusEnabled;
      }
      
      public function get viewPort() : IViewPort
      {
         return this._viewPort;
      }
      
      public function set viewPort(param1:IViewPort) : void
      {
         if(this._viewPort == param1)
         {
            return;
         }
         if(this._viewPort !== null)
         {
            this._viewPort.removeEventListener(FeathersEventType.RESIZE,this.viewPort_resizeHandler);
            this.removeRawChildInternal(DisplayObject(this._viewPort));
         }
         this._viewPort = param1;
         if(this._viewPort !== null)
         {
            this._viewPort.addEventListener(FeathersEventType.RESIZE,this.viewPort_resizeHandler);
            this.addRawChildAtInternal(DisplayObject(this._viewPort),0);
            if(this._viewPort is IFeathersControl)
            {
               IFeathersControl(this._viewPort).initializeNow();
            }
            this._explicitViewPortWidth = this._viewPort.explicitWidth;
            this._explicitViewPortHeight = this._viewPort.explicitHeight;
            this._explicitViewPortMinWidth = this._viewPort.explicitMinWidth;
            this._explicitViewPortMinHeight = this._viewPort.explicitMinHeight;
         }
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
      
      public function get measureViewPort() : Boolean
      {
         return this._measureViewPort;
      }
      
      public function set measureViewPort(param1:Boolean) : void
      {
         if(this._measureViewPort == param1)
         {
            return;
         }
         this._measureViewPort = param1;
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
      
      public function get snapToPages() : Boolean
      {
         return this._snapToPages;
      }
      
      public function set snapToPages(param1:Boolean) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._snapToPages === param1)
         {
            return;
         }
         this._snapToPages = param1;
         this.invalidate(INVALIDATION_FLAG_SCROLL);
      }
      
      public function get horizontalScrollBarFactory() : Function
      {
         return this._horizontalScrollBarFactory;
      }
      
      public function set horizontalScrollBarFactory(param1:Function) : void
      {
         if(this._horizontalScrollBarFactory == param1)
         {
            return;
         }
         this._horizontalScrollBarFactory = param1;
         this.invalidate(INVALIDATION_FLAG_SCROLL_BAR_RENDERER);
      }
      
      public function get customHorizontalScrollBarStyleName() : String
      {
         return this._customHorizontalScrollBarStyleName;
      }
      
      public function set customHorizontalScrollBarStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customHorizontalScrollBarStyleName === param1)
         {
            return;
         }
         this._customHorizontalScrollBarStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_SCROLL_BAR_RENDERER);
      }
      
      public function get horizontalScrollBarProperties() : Object
      {
         if(!this._horizontalScrollBarProperties)
         {
            this._horizontalScrollBarProperties = new PropertyProxy(this.childProperties_onChange);
         }
         return this._horizontalScrollBarProperties;
      }
      
      public function set horizontalScrollBarProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         var _loc3_:String = null;
         if(this._horizontalScrollBarProperties == param1)
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
         if(this._horizontalScrollBarProperties)
         {
            this._horizontalScrollBarProperties.removeOnChangeCallback(this.childProperties_onChange);
         }
         this._horizontalScrollBarProperties = PropertyProxy(param1);
         if(this._horizontalScrollBarProperties)
         {
            this._horizontalScrollBarProperties.addOnChangeCallback(this.childProperties_onChange);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get verticalScrollBarPosition() : String
      {
         return this._verticalScrollBarPosition;
      }
      
      public function set verticalScrollBarPosition(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._verticalScrollBarPosition === param1)
         {
            return;
         }
         this._verticalScrollBarPosition = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get horizontalScrollBarPosition() : String
      {
         return this._horizontalScrollBarPosition;
      }
      
      public function set horizontalScrollBarPosition(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._horizontalScrollBarPosition === param1)
         {
            return;
         }
         this._horizontalScrollBarPosition = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get verticalScrollBarFactory() : Function
      {
         return this._verticalScrollBarFactory;
      }
      
      public function set verticalScrollBarFactory(param1:Function) : void
      {
         if(this._verticalScrollBarFactory == param1)
         {
            return;
         }
         this._verticalScrollBarFactory = param1;
         this.invalidate(INVALIDATION_FLAG_SCROLL_BAR_RENDERER);
      }
      
      public function get customVerticalScrollBarStyleName() : String
      {
         return this._customVerticalScrollBarStyleName;
      }
      
      public function set customVerticalScrollBarStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customVerticalScrollBarStyleName === param1)
         {
            return;
         }
         this._customVerticalScrollBarStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_SCROLL_BAR_RENDERER);
      }
      
      public function get verticalScrollBarProperties() : Object
      {
         if(!this._verticalScrollBarProperties)
         {
            this._verticalScrollBarProperties = new PropertyProxy(this.childProperties_onChange);
         }
         return this._verticalScrollBarProperties;
      }
      
      public function set verticalScrollBarProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         var _loc3_:String = null;
         if(this._horizontalScrollBarProperties == param1)
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
         if(this._verticalScrollBarProperties)
         {
            this._verticalScrollBarProperties.removeOnChangeCallback(this.childProperties_onChange);
         }
         this._verticalScrollBarProperties = PropertyProxy(param1);
         if(this._verticalScrollBarProperties)
         {
            this._verticalScrollBarProperties.addOnChangeCallback(this.childProperties_onChange);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get horizontalScrollStep() : Number
      {
         return this.actualHorizontalScrollStep;
      }
      
      public function set horizontalScrollStep(param1:Number) : void
      {
         if(this.explicitHorizontalScrollStep == param1)
         {
            return;
         }
         this.explicitHorizontalScrollStep = param1;
         this.invalidate(INVALIDATION_FLAG_SCROLL);
      }
      
      public function get horizontalScrollPosition() : Number
      {
         return this._horizontalScrollPosition;
      }
      
      public function set horizontalScrollPosition(param1:Number) : void
      {
         if(this._horizontalScrollPosition == param1)
         {
            return;
         }
         if(param1 !== param1)
         {
            throw new ArgumentError("horizontalScrollPosition cannot be NaN.");
         }
         this._horizontalScrollPosition = param1;
         this.invalidate(INVALIDATION_FLAG_SCROLL);
      }
      
      public function get minHorizontalScrollPosition() : Number
      {
         return this._minHorizontalScrollPosition;
      }
      
      public function get maxHorizontalScrollPosition() : Number
      {
         return this._maxHorizontalScrollPosition;
      }
      
      public function get horizontalPageIndex() : int
      {
         if(this.hasPendingHorizontalPageIndex)
         {
            return this.pendingHorizontalPageIndex;
         }
         return this._horizontalPageIndex;
      }
      
      public function set horizontalPageIndex(param1:int) : void
      {
         if(!this._snapToPages)
         {
            throw new IllegalOperationError("The horizontalPageIndex may not be set if snapToPages is false.");
         }
         this.hasPendingHorizontalPageIndex = false;
         this.pendingHorizontalScrollPosition = NaN;
         if(this._horizontalPageIndex == param1)
         {
            return;
         }
         if(!this.isInvalid())
         {
            if(param1 < this._minHorizontalPageIndex)
            {
               param1 = this._minHorizontalPageIndex;
            }
            else if(param1 > this._maxHorizontalPageIndex)
            {
               param1 = this._maxHorizontalPageIndex;
            }
            this._horizontalScrollPosition = this.actualPageWidth * param1;
         }
         else
         {
            this.hasPendingHorizontalPageIndex = true;
            this.pendingHorizontalPageIndex = param1;
            this.pendingScrollDuration = 0;
         }
         this.invalidate(INVALIDATION_FLAG_SCROLL);
      }
      
      public function get minHorizontalPageIndex() : int
      {
         return this._minHorizontalPageIndex;
      }
      
      public function get maxHorizontalPageIndex() : int
      {
         return this._maxHorizontalPageIndex;
      }
      
      public function get horizontalPageCount() : int
      {
         if(this._maxHorizontalPageIndex == int.MAX_VALUE || this._minHorizontalPageIndex == int.MIN_VALUE)
         {
            return int.MAX_VALUE;
         }
         return this._maxHorizontalPageIndex - this._minHorizontalPageIndex + 1;
      }
      
      public function get horizontalScrollPolicy() : String
      {
         return this._horizontalScrollPolicy;
      }
      
      public function set horizontalScrollPolicy(param1:String) : void
      {
         if(this._horizontalScrollPolicy == param1)
         {
            return;
         }
         this._horizontalScrollPolicy = param1;
         this.invalidate(INVALIDATION_FLAG_SCROLL);
         this.invalidate(INVALIDATION_FLAG_SCROLL_BAR_RENDERER);
      }
      
      public function get verticalScrollStep() : Number
      {
         return this.actualVerticalScrollStep;
      }
      
      public function set verticalScrollStep(param1:Number) : void
      {
         if(this.explicitVerticalScrollStep == param1)
         {
            return;
         }
         this.explicitVerticalScrollStep = param1;
         this.invalidate(INVALIDATION_FLAG_SCROLL);
      }
      
      public function get verticalMouseWheelScrollStep() : Number
      {
         return this._verticalMouseWheelScrollStep;
      }
      
      public function set verticalMouseWheelScrollStep(param1:Number) : void
      {
         if(this._verticalMouseWheelScrollStep == param1)
         {
            return;
         }
         this._verticalMouseWheelScrollStep = param1;
         this.invalidate(INVALIDATION_FLAG_SCROLL);
      }
      
      public function get verticalScrollPosition() : Number
      {
         return this._verticalScrollPosition;
      }
      
      public function set verticalScrollPosition(param1:Number) : void
      {
         if(this._verticalScrollPosition == param1)
         {
            return;
         }
         if(param1 !== param1)
         {
            throw new ArgumentError("verticalScrollPosition cannot be NaN.");
         }
         this._verticalScrollPosition = param1;
         this.invalidate(INVALIDATION_FLAG_SCROLL);
      }
      
      public function get minVerticalScrollPosition() : Number
      {
         return this._minVerticalScrollPosition;
      }
      
      public function get maxVerticalScrollPosition() : Number
      {
         return this._maxVerticalScrollPosition;
      }
      
      public function get verticalPageIndex() : int
      {
         if(this.hasPendingVerticalPageIndex)
         {
            return this.pendingVerticalPageIndex;
         }
         return this._verticalPageIndex;
      }
      
      public function set verticalPageIndex(param1:int) : void
      {
         if(!this._snapToPages)
         {
            throw new IllegalOperationError("The verticalPageIndex may not be set if snapToPages is false.");
         }
         this.hasPendingVerticalPageIndex = false;
         this.pendingVerticalScrollPosition = NaN;
         if(this._verticalPageIndex == param1)
         {
            return;
         }
         if(!this.isInvalid())
         {
            if(param1 < this._minVerticalPageIndex)
            {
               param1 = this._minVerticalPageIndex;
            }
            else if(param1 > this._maxVerticalPageIndex)
            {
               param1 = this._maxVerticalPageIndex;
            }
            this._verticalScrollPosition = this.actualPageHeight * param1;
         }
         else
         {
            this.hasPendingVerticalPageIndex = true;
            this.pendingVerticalPageIndex = param1;
            this.pendingScrollDuration = 0;
         }
         this.invalidate(INVALIDATION_FLAG_SCROLL);
      }
      
      public function get minVerticalPageIndex() : int
      {
         return this._minVerticalPageIndex;
      }
      
      public function get maxVerticalPageIndex() : int
      {
         return this._maxVerticalPageIndex;
      }
      
      public function get verticalPageCount() : int
      {
         if(this._maxVerticalPageIndex == int.MAX_VALUE || this._minVerticalPageIndex == int.MIN_VALUE)
         {
            return int.MAX_VALUE;
         }
         return this._maxVerticalPageIndex - this._minVerticalPageIndex + 1;
      }
      
      public function get verticalScrollPolicy() : String
      {
         return this._verticalScrollPolicy;
      }
      
      public function set verticalScrollPolicy(param1:String) : void
      {
         if(this._verticalScrollPolicy == param1)
         {
            return;
         }
         this._verticalScrollPolicy = param1;
         this.invalidate(INVALIDATION_FLAG_SCROLL);
         this.invalidate(INVALIDATION_FLAG_SCROLL_BAR_RENDERER);
      }
      
      public function get clipContent() : Boolean
      {
         return this._clipContent;
      }
      
      public function set clipContent(param1:Boolean) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._clipContent === param1)
         {
            return;
         }
         this._clipContent = param1;
         if(!param1 && Boolean(this._viewPort))
         {
            this._viewPort.mask = null;
         }
         this.invalidate(INVALIDATION_FLAG_CLIPPING);
      }
      
      public function get pageWidth() : Number
      {
         return this.actualPageWidth;
      }
      
      public function set pageWidth(param1:Number) : void
      {
         if(this.explicitPageWidth == param1)
         {
            return;
         }
         var _loc2_:Boolean = param1 !== param1;
         if(_loc2_ && this.explicitPageWidth !== this.explicitPageWidth)
         {
            return;
         }
         this.explicitPageWidth = param1;
         if(_loc2_)
         {
            this.actualPageWidth = 0;
         }
         else
         {
            this.actualPageWidth = this.explicitPageWidth;
         }
      }
      
      public function get pageHeight() : Number
      {
         return this.actualPageHeight;
      }
      
      public function set pageHeight(param1:Number) : void
      {
         if(this.explicitPageHeight == param1)
         {
            return;
         }
         var _loc2_:Boolean = param1 !== param1;
         if(_loc2_ && this.explicitPageHeight !== this.explicitPageHeight)
         {
            return;
         }
         this.explicitPageHeight = param1;
         if(_loc2_)
         {
            this.actualPageHeight = 0;
         }
         else
         {
            this.actualPageHeight = this.explicitPageHeight;
         }
      }
      
      public function get hasElasticEdges() : Boolean
      {
         return this._hasElasticEdges;
      }
      
      public function set hasElasticEdges(param1:Boolean) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         this._hasElasticEdges = param1;
      }
      
      public function get elasticity() : Number
      {
         return this._elasticity;
      }
      
      public function set elasticity(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         this._elasticity = param1;
      }
      
      public function get throwElasticity() : Number
      {
         return this._throwElasticity;
      }
      
      public function set throwElasticity(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         this._throwElasticity = param1;
      }
      
      public function get scrollBarDisplayMode() : String
      {
         return this._scrollBarDisplayMode;
      }
      
      public function set scrollBarDisplayMode(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._scrollBarDisplayMode === param1)
         {
            return;
         }
         this._scrollBarDisplayMode = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get interactionMode() : String
      {
         return this._interactionMode;
      }
      
      public function set interactionMode(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._interactionMode === param1)
         {
            return;
         }
         this._interactionMode = param1;
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
      
      public function get autoHideBackground() : Boolean
      {
         return this._autoHideBackground;
      }
      
      public function set autoHideBackground(param1:Boolean) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._autoHideBackground === param1)
         {
            return;
         }
         this._autoHideBackground = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get minimumDragDistance() : Number
      {
         return this._minimumDragDistance;
      }
      
      public function set minimumDragDistance(param1:Number) : void
      {
         this._minimumDragDistance = param1;
      }
      
      public function get minimumPageThrowVelocity() : Number
      {
         return this._minimumPageThrowVelocity;
      }
      
      public function set minimumPageThrowVelocity(param1:Number) : void
      {
         this._minimumPageThrowVelocity = param1;
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
      
      public function get hideScrollBarAnimationDuration() : Number
      {
         return this._hideScrollBarAnimationDuration;
      }
      
      public function set hideScrollBarAnimationDuration(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         this._hideScrollBarAnimationDuration = param1;
      }
      
      public function get hideScrollBarAnimationEase() : Object
      {
         return this._hideScrollBarAnimationEase;
      }
      
      public function set hideScrollBarAnimationEase(param1:Object) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         this._hideScrollBarAnimationEase = param1;
      }
      
      public function get elasticSnapDuration() : Number
      {
         return this._elasticSnapDuration;
      }
      
      public function set elasticSnapDuration(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         this._elasticSnapDuration = param1;
      }
      
      public function get decelerationRate() : Number
      {
         return this._decelerationRate;
      }
      
      public function set decelerationRate(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._decelerationRate == param1)
         {
            return;
         }
         this._decelerationRate = param1;
         this._logDecelerationRate = Math.log(this._decelerationRate);
         this._fixedThrowDuration = -0.1 / Math.log(Math.pow(this._decelerationRate,1000 / 60));
      }
      
      public function get useFixedThrowDuration() : Boolean
      {
         return this._useFixedThrowDuration;
      }
      
      public function set useFixedThrowDuration(param1:Boolean) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         this._useFixedThrowDuration = param1;
      }
      
      public function get pageThrowDuration() : Number
      {
         return this._pageThrowDuration;
      }
      
      public function set pageThrowDuration(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         this._pageThrowDuration = param1;
      }
      
      public function get mouseWheelScrollDuration() : Number
      {
         return this._mouseWheelScrollDuration;
      }
      
      public function set mouseWheelScrollDuration(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         this._mouseWheelScrollDuration = param1;
      }
      
      public function get verticalMouseWheelScrollDirection() : String
      {
         return this._verticalMouseWheelScrollDirection;
      }
      
      public function set verticalMouseWheelScrollDirection(param1:String) : void
      {
         this._verticalMouseWheelScrollDirection = param1;
      }
      
      public function get throwEase() : Object
      {
         return this._throwEase;
      }
      
      public function set throwEase(param1:Object) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(param1 == null)
         {
            param1 = defaultThrowEase;
         }
         this._throwEase = param1;
      }
      
      public function get snapScrollPositionsToPixels() : Boolean
      {
         return this._snapScrollPositionsToPixels;
      }
      
      public function set snapScrollPositionsToPixels(param1:Boolean) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._snapScrollPositionsToPixels === param1)
         {
            return;
         }
         this._snapScrollPositionsToPixels = param1;
         this.invalidate(INVALIDATION_FLAG_SCROLL);
      }
      
      public function get isScrolling() : Boolean
      {
         return this._isScrolling;
      }
      
      public function get revealScrollBarsDuration() : Number
      {
         return this._revealScrollBarsDuration;
      }
      
      public function set revealScrollBarsDuration(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         this._revealScrollBarsDuration = param1;
      }
      
      public function get isTopPullViewActive() : Boolean
      {
         return this._isTopPullViewActive;
      }
      
      public function set isTopPullViewActive(param1:Boolean) : void
      {
         if(this._isTopPullViewActive === param1)
         {
            return;
         }
         if(this._topPullView === null)
         {
            return;
         }
         this._isTopPullViewActive = param1;
         this._isTopPullViewPending = true;
         this.invalidate(INVALIDATION_FLAG_PENDING_PULL_VIEW);
      }
      
      public function get topPullView() : DisplayObject
      {
         return this._topPullView;
      }
      
      public function set topPullView(param1:DisplayObject) : void
      {
         if(this._topPullView !== null)
         {
            this._topPullView.mask.dispose();
            this._topPullView.mask = null;
            if(this._topPullView.parent === this)
            {
               this.removeRawChildInternal(this._topPullView,false);
            }
         }
         this._topPullView = param1;
         if(this._topPullView !== null)
         {
            this._topPullView.mask = new Quad(1,1,16711935);
            this._topPullView.visible = false;
            this.addRawChildInternal(this._topPullView);
         }
         else
         {
            this.isTopPullViewActive = false;
         }
      }
      
      public function get topPullViewDisplayMode() : String
      {
         return this._topPullViewDisplayMode;
      }
      
      public function set topPullViewDisplayMode(param1:String) : void
      {
         if(this._topPullViewDisplayMode === param1)
         {
            return;
         }
         this._topPullViewDisplayMode = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      protected function get topPullViewRatio() : Number
      {
         return this._topPullViewRatio;
      }
      
      protected function set topPullViewRatio(param1:Number) : void
      {
         if(this._topPullViewRatio == param1)
         {
            return;
         }
         this._topPullViewRatio = param1;
         if(!this._isTopPullViewActive && this._topPullView !== null)
         {
            this._topPullView.dispatchEventWith(FeathersEventType.PULLING,false,param1);
         }
      }
      
      public function get isRightPullViewActive() : Boolean
      {
         return this._isRightPullViewActive;
      }
      
      public function set isRightPullViewActive(param1:Boolean) : void
      {
         if(this._isRightPullViewActive === param1)
         {
            return;
         }
         if(this._rightPullView === null)
         {
            return;
         }
         this._isRightPullViewActive = param1;
         this._isRightPullViewPending = true;
         this.invalidate(INVALIDATION_FLAG_PENDING_PULL_VIEW);
      }
      
      public function get rightPullView() : DisplayObject
      {
         return this._rightPullView;
      }
      
      public function set rightPullView(param1:DisplayObject) : void
      {
         if(this._rightPullView !== null)
         {
            this._rightPullView.mask.dispose();
            this._rightPullView.mask = null;
            if(this._rightPullView.parent === this)
            {
               this.removeRawChildInternal(this._rightPullView,false);
            }
         }
         this._rightPullView = param1;
         if(this._rightPullView !== null)
         {
            this._rightPullView.mask = new Quad(1,1,16711935);
            this._rightPullView.visible = false;
            this.addRawChildInternal(this._rightPullView);
         }
         else
         {
            this.isRightPullViewActive = false;
         }
      }
      
      public function get rightPullViewDisplayMode() : String
      {
         return this._rightPullViewDisplayMode;
      }
      
      public function set rightPullViewDisplayMode(param1:String) : void
      {
         if(this._rightPullViewDisplayMode === param1)
         {
            return;
         }
         this._rightPullViewDisplayMode = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      protected function get rightPullViewRatio() : Number
      {
         return this._rightPullViewRatio;
      }
      
      protected function set rightPullViewRatio(param1:Number) : void
      {
         if(this._rightPullViewRatio == param1)
         {
            return;
         }
         this._rightPullViewRatio = param1;
         if(!this._isRightPullViewActive && this._rightPullView !== null)
         {
            this._rightPullView.dispatchEventWith(FeathersEventType.PULLING,false,param1);
         }
      }
      
      public function get isBottomPullViewActive() : Boolean
      {
         return this._isBottomPullViewActive;
      }
      
      public function set isBottomPullViewActive(param1:Boolean) : void
      {
         if(this._isBottomPullViewActive === param1)
         {
            return;
         }
         if(this._bottomPullView === null)
         {
            return;
         }
         this._isBottomPullViewActive = param1;
         this._isBottomPullViewPending = true;
         this.invalidate(INVALIDATION_FLAG_PENDING_PULL_VIEW);
      }
      
      public function get bottomPullView() : DisplayObject
      {
         return this._bottomPullView;
      }
      
      public function set bottomPullView(param1:DisplayObject) : void
      {
         if(this._bottomPullView !== null)
         {
            this._bottomPullView.mask.dispose();
            this._bottomPullView.mask = null;
            if(this._bottomPullView.parent === this)
            {
               this.removeRawChildInternal(this._bottomPullView,false);
            }
         }
         this._bottomPullView = param1;
         if(this._bottomPullView !== null)
         {
            this._bottomPullView.mask = new Quad(1,1,16711935);
            this._bottomPullView.visible = false;
            this.addRawChildInternal(this._bottomPullView);
         }
         else
         {
            this.isBottomPullViewActive = false;
         }
      }
      
      public function get bottomPullViewDisplayMode() : String
      {
         return this._bottomPullViewDisplayMode;
      }
      
      public function set bottomPullViewDisplayMode(param1:String) : void
      {
         if(this._bottomPullViewDisplayMode === param1)
         {
            return;
         }
         this._bottomPullViewDisplayMode = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      protected function get bottomPullViewRatio() : Number
      {
         return this._bottomPullViewRatio;
      }
      
      protected function set bottomPullViewRatio(param1:Number) : void
      {
         if(this._bottomPullViewRatio == param1)
         {
            return;
         }
         this._bottomPullViewRatio = param1;
         if(!this._isBottomPullViewActive && this._bottomPullView !== null)
         {
            this._bottomPullView.dispatchEventWith(FeathersEventType.PULLING,false,param1);
         }
      }
      
      public function get isLeftPullViewActive() : Boolean
      {
         return this._isLeftPullViewActive;
      }
      
      public function set isLeftPullViewActive(param1:Boolean) : void
      {
         if(this._isLeftPullViewActive === param1)
         {
            return;
         }
         if(this._leftPullView === null)
         {
            return;
         }
         this._isLeftPullViewActive = param1;
         this._isLeftPullViewPending = true;
         this.invalidate(INVALIDATION_FLAG_PENDING_PULL_VIEW);
      }
      
      public function get leftPullView() : DisplayObject
      {
         return this._leftPullView;
      }
      
      public function set leftPullView(param1:DisplayObject) : void
      {
         if(this._leftPullView !== null)
         {
            this._leftPullView.mask.dispose();
            this._leftPullView.mask = null;
            if(this._leftPullView.parent === this)
            {
               this.removeRawChildInternal(this._leftPullView,false);
            }
         }
         this._leftPullView = param1;
         if(this._leftPullView !== null)
         {
            this._leftPullView.mask = new Quad(1,1,16711935);
            this._leftPullView.visible = false;
            this.addRawChildInternal(this._leftPullView);
         }
         else
         {
            this.isLeftPullViewActive = false;
         }
      }
      
      protected function get leftPullViewRatio() : Number
      {
         return this._leftPullViewRatio;
      }
      
      protected function set leftPullViewRatio(param1:Number) : void
      {
         if(this._leftPullViewRatio == param1)
         {
            return;
         }
         this._leftPullViewRatio = param1;
         if(!this._isLeftPullViewActive && this._leftPullView !== null)
         {
            this._leftPullView.dispatchEventWith(FeathersEventType.PULLING,false,param1);
         }
      }
      
      public function get leftPullViewDisplayMode() : String
      {
         return this._leftPullViewDisplayMode;
      }
      
      public function set leftPullViewDisplayMode(param1:String) : void
      {
         if(this._leftPullViewDisplayMode === param1)
         {
            return;
         }
         this._leftPullViewDisplayMode = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      override public function dispose() : void
      {
         var _loc1_:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         _loc1_.nativeStage.removeEventListener(MouseEvent.MOUSE_WHEEL,this.nativeStage_mouseWheelHandler);
         _loc1_.nativeStage.removeEventListener("orientationChange",this.nativeStage_orientationChangeHandler);
         if(this._backgroundSkin !== null && this._backgroundSkin.parent !== this)
         {
            this._backgroundSkin.dispose();
         }
         if(this._backgroundDisabledSkin !== null && this._backgroundDisabledSkin.parent !== this)
         {
            this._backgroundDisabledSkin.dispose();
         }
         super.dispose();
      }
      
      public function stopScrolling() : void
      {
         if(this._horizontalAutoScrollTween)
         {
            Starling.juggler.remove(this._horizontalAutoScrollTween);
            this._horizontalAutoScrollTween = null;
         }
         if(this._verticalAutoScrollTween)
         {
            Starling.juggler.remove(this._verticalAutoScrollTween);
            this._verticalAutoScrollTween = null;
         }
         this._isScrollingStopped = true;
         this._velocityX = 0;
         this._velocityY = 0;
         this._previousVelocityX.length = 0;
         this._previousVelocityY.length = 0;
         this.hideHorizontalScrollBar();
         this.hideVerticalScrollBar();
      }
      
      public function scrollToPosition(param1:Number, param2:Number, param3:Number = NaN) : void
      {
         var _loc4_:Point = null;
         if(param3 !== param3)
         {
            if(this._useFixedThrowDuration)
            {
               param3 = this._fixedThrowDuration;
            }
            else
            {
               _loc4_ = Pool.getPoint(param1 - this._horizontalScrollPosition,param2 - this._verticalScrollPosition);
               param3 = this.calculateDynamicThrowDuration(_loc4_.length * this._logDecelerationRate + MINIMUM_VELOCITY);
               Pool.putPoint(_loc4_);
            }
         }
         this.hasPendingHorizontalPageIndex = false;
         this.hasPendingVerticalPageIndex = false;
         if(this.pendingHorizontalScrollPosition == param1 && this.pendingVerticalScrollPosition == param2 && this.pendingScrollDuration == param3)
         {
            return;
         }
         this.pendingHorizontalScrollPosition = param1;
         this.pendingVerticalScrollPosition = param2;
         this.pendingScrollDuration = param3;
         this.invalidate(INVALIDATION_FLAG_PENDING_SCROLL);
      }
      
      public function scrollToPageIndex(param1:int, param2:int, param3:Number = NaN) : void
      {
         if(param3 !== param3)
         {
            param3 = this._pageThrowDuration;
         }
         this.pendingHorizontalScrollPosition = NaN;
         this.pendingVerticalScrollPosition = NaN;
         this.hasPendingHorizontalPageIndex = this._horizontalPageIndex !== param1;
         this.hasPendingVerticalPageIndex = this._verticalPageIndex !== param2;
         if(!this.hasPendingHorizontalPageIndex && !this.hasPendingVerticalPageIndex)
         {
            return;
         }
         this.pendingHorizontalPageIndex = param1;
         this.pendingVerticalPageIndex = param2;
         this.pendingScrollDuration = param3;
         this.invalidate(INVALIDATION_FLAG_PENDING_SCROLL);
      }
      
      public function revealScrollBars() : void
      {
         this.isScrollBarRevealPending = true;
         this.invalidate(INVALIDATION_FLAG_PENDING_REVEAL_SCROLL_BARS);
      }
      
      override public function hitTest(param1:Point) : DisplayObject
      {
         var _loc2_:Number = param1.x;
         var _loc3_:Number = param1.y;
         var _loc4_:DisplayObject = super.hitTest(param1);
         if((this._isDraggingHorizontally || this._isDraggingVertically) && this.viewPort is DisplayObjectContainer && DisplayObjectContainer(this.viewPort).contains(_loc4_))
         {
            _loc4_ = DisplayObject(this.viewPort);
         }
         if(_loc4_ === null)
         {
            if(!this.visible || !this.touchable)
            {
               return null;
            }
            return this._hitArea.contains(_loc2_,_loc3_) ? this : null;
         }
         return _loc4_;
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_LAYOUT);
         var _loc4_:Boolean = this.isInvalid(INVALIDATION_FLAG_SCROLL);
         var _loc5_:Boolean = this.isInvalid(INVALIDATION_FLAG_CLIPPING);
         var _loc6_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc7_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         var _loc8_:Boolean = this.isInvalid(INVALIDATION_FLAG_SCROLL_BAR_RENDERER);
         var _loc9_:Boolean = this.isInvalid(INVALIDATION_FLAG_PENDING_SCROLL);
         var _loc10_:Boolean = this.isInvalid(INVALIDATION_FLAG_PENDING_REVEAL_SCROLL_BARS);
         var _loc11_:Boolean = this.isInvalid(INVALIDATION_FLAG_PENDING_PULL_VIEW);
         if(_loc8_)
         {
            this.createScrollBars();
         }
         if(_loc1_ || _loc6_ || _loc7_)
         {
            this.refreshBackgroundSkin();
         }
         if(_loc8_ || _loc6_)
         {
            this.refreshScrollBarStyles();
            this.refreshInteractionModeEvents();
         }
         if(_loc8_ || _loc7_)
         {
            this.refreshEnabled();
         }
         if(this.horizontalScrollBar)
         {
            this.horizontalScrollBar.validate();
         }
         if(this.verticalScrollBar)
         {
            this.verticalScrollBar.validate();
         }
         var _loc12_:Number = this._maxHorizontalScrollPosition;
         var _loc13_:Number = this._maxVerticalScrollPosition;
         var _loc14_:Boolean = _loc4_ && this._viewPort.requiresMeasurementOnScroll || _loc2_ || _loc1_ || _loc6_ || _loc8_ || _loc7_ || _loc3_;
         this.refreshViewPort(_loc14_);
         if(_loc12_ != this._maxHorizontalScrollPosition)
         {
            this.refreshHorizontalAutoScrollTweenEndRatio();
            _loc4_ = true;
         }
         if(_loc13_ != this._maxVerticalScrollPosition)
         {
            this.refreshVerticalAutoScrollTweenEndRatio();
            _loc4_ = true;
         }
         if(_loc4_)
         {
            this.dispatchEventWith(starling.events.Event.SCROLL);
         }
         this.showOrHideChildren();
         this.layoutChildren();
         if(_loc4_ || _loc1_ || _loc6_ || _loc8_)
         {
            this.refreshScrollBarValues();
         }
         if(_loc14_ || _loc4_ || _loc5_)
         {
            this.refreshMask();
         }
         this.refreshFocusIndicator();
         if(_loc9_)
         {
            this.handlePendingScroll();
         }
         if(_loc10_)
         {
            this.handlePendingRevealScrollBars();
         }
         if(_loc11_)
         {
            this.handlePendingPullView();
         }
      }
      
      protected function refreshViewPort(param1:Boolean) : void
      {
         var _loc3_:Starling = null;
         var _loc4_:Number = NaN;
         if(this._snapScrollPositionsToPixels)
         {
            _loc3_ = this.stage !== null ? this.stage.starling : Starling.current;
            _loc4_ = 1 / _loc3_.contentScaleFactor;
            this._viewPort.horizontalScrollPosition = Math.round(this._horizontalScrollPosition / _loc4_) * _loc4_;
            this._viewPort.verticalScrollPosition = Math.round(this._verticalScrollPosition / _loc4_) * _loc4_;
         }
         else
         {
            this._viewPort.horizontalScrollPosition = this._horizontalScrollPosition;
            this._viewPort.verticalScrollPosition = this._verticalScrollPosition;
         }
         if(!param1)
         {
            this._viewPort.validate();
            this.refreshScrollValues();
            return;
         }
         var _loc2_:int = 0;
         while(true)
         {
            this._hasViewPortBoundsChanged = false;
            if(this._measureViewPort)
            {
               this.calculateViewPortOffsets(true,false);
               this.refreshViewPortBoundsForMeasurement();
            }
            this.calculateViewPortOffsets(false,false);
            this.autoSizeIfNeeded();
            this.calculateViewPortOffsets(false,true);
            this.refreshViewPortBoundsForLayout();
            this.refreshScrollValues();
            if(++_loc2_ >= 10)
            {
               break;
            }
            if(!this._hasViewPortBoundsChanged)
            {
               this._lastViewPortWidth = this._viewPort.width;
               this._lastViewPortHeight = this._viewPort.height;
               return;
            }
         }
         throw new Error(getQualifiedClassName(this) + " stuck in an infinite loop during measurement and validation. This may be an issue with the layout or children, such as custom item renderers.");
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
         resetFluidChildDimensionsForMeasurement(this.currentBackgroundSkin,this._explicitWidth,this._explicitHeight,this._explicitMinWidth,this._explicitMinHeight,this._explicitMaxWidth,this._explicitMaxHeight,this._explicitBackgroundWidth,this._explicitBackgroundHeight,this._explicitBackgroundMinWidth,this._explicitBackgroundMinHeight,this._explicitBackgroundMaxWidth,this._explicitBackgroundMaxHeight);
         var _loc5_:IMeasureDisplayObject = this.currentBackgroundSkin as IMeasureDisplayObject;
         if(this.currentBackgroundSkin is IValidating)
         {
            IValidating(this.currentBackgroundSkin).validate();
         }
         var _loc6_:Number = this._explicitWidth;
         var _loc7_:Number = this._explicitHeight;
         var _loc8_:Number = this._explicitMinWidth;
         var _loc9_:Number = this._explicitMinHeight;
         if(_loc1_)
         {
            if(this._measureViewPort)
            {
               _loc6_ = this._viewPort.visibleWidth;
            }
            else
            {
               _loc6_ = 0;
            }
            _loc6_ += this._rightViewPortOffset + this._leftViewPortOffset;
            if(this.currentBackgroundSkin !== null && this.currentBackgroundSkin.width > _loc6_)
            {
               _loc6_ = this.currentBackgroundSkin.width;
            }
         }
         if(_loc2_)
         {
            if(this._measureViewPort)
            {
               _loc7_ = this._viewPort.visibleHeight;
            }
            else
            {
               _loc7_ = 0;
            }
            _loc7_ += this._bottomViewPortOffset + this._topViewPortOffset;
            if(this.currentBackgroundSkin !== null && this.currentBackgroundSkin.height > _loc7_)
            {
               _loc7_ = this.currentBackgroundSkin.height;
            }
         }
         if(_loc3_)
         {
            if(this._measureViewPort)
            {
               _loc8_ = this._viewPort.minVisibleWidth;
            }
            else
            {
               _loc8_ = 0;
            }
            _loc8_ += this._rightViewPortOffset + this._leftViewPortOffset;
            if(this.currentBackgroundSkin !== null)
            {
               if(_loc5_ !== null)
               {
                  if(_loc5_.minWidth > _loc8_)
                  {
                     _loc8_ = _loc5_.minWidth;
                  }
               }
               else if(this._explicitBackgroundMinWidth > _loc8_)
               {
                  _loc8_ = this._explicitBackgroundMinWidth;
               }
            }
         }
         if(_loc4_)
         {
            if(this._measureViewPort)
            {
               _loc9_ = this._viewPort.minVisibleHeight;
            }
            else
            {
               _loc9_ = 0;
            }
            _loc9_ += this._bottomViewPortOffset + this._topViewPortOffset;
            if(this.currentBackgroundSkin !== null)
            {
               if(_loc5_ !== null)
               {
                  if(_loc5_.minHeight > _loc9_)
                  {
                     _loc9_ = _loc5_.minHeight;
                  }
               }
               else if(this._explicitBackgroundMinHeight > _loc9_)
               {
                  _loc9_ = this._explicitBackgroundMinHeight;
               }
            }
         }
         return this.saveMeasurements(_loc6_,_loc7_,_loc8_,_loc9_);
      }
      
      protected function createScrollBars() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         if(this.horizontalScrollBar)
         {
            this.horizontalScrollBar.removeEventListener(FeathersEventType.BEGIN_INTERACTION,this.horizontalScrollBar_beginInteractionHandler);
            this.horizontalScrollBar.removeEventListener(FeathersEventType.END_INTERACTION,this.horizontalScrollBar_endInteractionHandler);
            this.horizontalScrollBar.removeEventListener(starling.events.Event.CHANGE,this.horizontalScrollBar_changeHandler);
            this.removeRawChildInternal(DisplayObject(this.horizontalScrollBar),true);
            this.horizontalScrollBar = null;
         }
         if(this.verticalScrollBar)
         {
            this.verticalScrollBar.removeEventListener(FeathersEventType.BEGIN_INTERACTION,this.verticalScrollBar_beginInteractionHandler);
            this.verticalScrollBar.removeEventListener(FeathersEventType.END_INTERACTION,this.verticalScrollBar_endInteractionHandler);
            this.verticalScrollBar.removeEventListener(starling.events.Event.CHANGE,this.verticalScrollBar_changeHandler);
            this.removeRawChildInternal(DisplayObject(this.verticalScrollBar),true);
            this.verticalScrollBar = null;
         }
         if(this._scrollBarDisplayMode != ScrollBarDisplayMode.NONE && this._horizontalScrollPolicy != ScrollPolicy.OFF && this._horizontalScrollBarFactory != null)
         {
            this.horizontalScrollBar = IScrollBar(this._horizontalScrollBarFactory());
            if(this.horizontalScrollBar is IDirectionalScrollBar)
            {
               IDirectionalScrollBar(this.horizontalScrollBar).direction = Direction.HORIZONTAL;
            }
            _loc1_ = this._customHorizontalScrollBarStyleName != null ? this._customHorizontalScrollBarStyleName : this.horizontalScrollBarStyleName;
            this.horizontalScrollBar.styleNameList.add(_loc1_);
            this.horizontalScrollBar.addEventListener(starling.events.Event.CHANGE,this.horizontalScrollBar_changeHandler);
            this.horizontalScrollBar.addEventListener(FeathersEventType.BEGIN_INTERACTION,this.horizontalScrollBar_beginInteractionHandler);
            this.horizontalScrollBar.addEventListener(FeathersEventType.END_INTERACTION,this.horizontalScrollBar_endInteractionHandler);
            this.addRawChildInternal(DisplayObject(this.horizontalScrollBar));
         }
         if(this._scrollBarDisplayMode != ScrollBarDisplayMode.NONE && this._verticalScrollPolicy != ScrollPolicy.OFF && this._verticalScrollBarFactory != null)
         {
            this.verticalScrollBar = IScrollBar(this._verticalScrollBarFactory());
            if(this.verticalScrollBar is IDirectionalScrollBar)
            {
               IDirectionalScrollBar(this.verticalScrollBar).direction = Direction.VERTICAL;
            }
            _loc2_ = this._customVerticalScrollBarStyleName != null ? this._customVerticalScrollBarStyleName : this.verticalScrollBarStyleName;
            this.verticalScrollBar.styleNameList.add(_loc2_);
            this.verticalScrollBar.addEventListener(starling.events.Event.CHANGE,this.verticalScrollBar_changeHandler);
            this.verticalScrollBar.addEventListener(FeathersEventType.BEGIN_INTERACTION,this.verticalScrollBar_beginInteractionHandler);
            this.verticalScrollBar.addEventListener(FeathersEventType.END_INTERACTION,this.verticalScrollBar_endInteractionHandler);
            this.addRawChildInternal(DisplayObject(this.verticalScrollBar));
         }
      }
      
      protected function refreshBackgroundSkin() : void
      {
         var _loc2_:IMeasureDisplayObject = null;
         var _loc1_:DisplayObject = this.getCurrentBackgroundSkin();
         if(this.currentBackgroundSkin !== _loc1_)
         {
            this.removeCurrentBackgroundSkin(this.currentBackgroundSkin);
            this.currentBackgroundSkin = _loc1_;
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
               this.addRawChildAtInternal(this.currentBackgroundSkin,0);
            }
         }
      }
      
      protected function getCurrentBackgroundSkin() : DisplayObject
      {
         var _loc1_:DisplayObject = this._backgroundSkin;
         if(!this._isEnabled && this._backgroundDisabledSkin !== null)
         {
            _loc1_ = this._backgroundDisabledSkin;
         }
         return _loc1_;
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
            this.removeRawChildInternal(param1);
         }
      }
      
      protected function refreshScrollBarStyles() : void
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         if(this.horizontalScrollBar)
         {
            for(_loc1_ in this._horizontalScrollBarProperties)
            {
               _loc2_ = this._horizontalScrollBarProperties[_loc1_];
               this.horizontalScrollBar[_loc1_] = _loc2_;
            }
            if(this._horizontalScrollBarHideTween)
            {
               Starling.juggler.remove(this._horizontalScrollBarHideTween);
               this._horizontalScrollBarHideTween = null;
            }
            this.horizontalScrollBar.alpha = this._scrollBarDisplayMode == ScrollBarDisplayMode.FLOAT ? 0 : 1;
         }
         if(this.verticalScrollBar)
         {
            for(_loc1_ in this._verticalScrollBarProperties)
            {
               _loc2_ = this._verticalScrollBarProperties[_loc1_];
               this.verticalScrollBar[_loc1_] = _loc2_;
            }
            if(this._verticalScrollBarHideTween)
            {
               Starling.juggler.remove(this._verticalScrollBarHideTween);
               this._verticalScrollBarHideTween = null;
            }
            this.verticalScrollBar.alpha = this._scrollBarDisplayMode == ScrollBarDisplayMode.FLOAT ? 0 : 1;
         }
      }
      
      protected function refreshEnabled() : void
      {
         if(this._viewPort)
         {
            this._viewPort.isEnabled = this._isEnabled;
         }
         if(this.horizontalScrollBar)
         {
            this.horizontalScrollBar.isEnabled = this._isEnabled;
         }
         if(this.verticalScrollBar)
         {
            this.verticalScrollBar.isEnabled = this._isEnabled;
         }
      }
      
      override protected function refreshFocusIndicator() : void
      {
         if(this._focusIndicatorSkin)
         {
            if(this._hasFocus && this._showFocus)
            {
               if(this._focusIndicatorSkin.parent != this)
               {
                  this.addRawChildInternal(this._focusIndicatorSkin);
               }
               else
               {
                  this.setRawChildIndexInternal(this._focusIndicatorSkin,this.numRawChildrenInternal - 1);
               }
            }
            else if(this._focusIndicatorSkin.parent == this)
            {
               this.removeRawChildInternal(this._focusIndicatorSkin,false);
            }
            this._focusIndicatorSkin.x = this._focusPaddingLeft;
            this._focusIndicatorSkin.y = this._focusPaddingTop;
            this._focusIndicatorSkin.width = this.actualWidth - this._focusPaddingLeft - this._focusPaddingRight;
            this._focusIndicatorSkin.height = this.actualHeight - this._focusPaddingTop - this._focusPaddingBottom;
         }
      }
      
      protected function refreshViewPortBoundsForMeasurement() : void
      {
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc1_:Number = this._leftViewPortOffset + this._rightViewPortOffset;
         var _loc2_:Number = this._topViewPortOffset + this._bottomViewPortOffset;
         resetFluidChildDimensionsForMeasurement(this.currentBackgroundSkin,this._explicitWidth,this._explicitHeight,this._explicitMinWidth,this._explicitMinHeight,this._explicitMaxWidth,this._explicitMaxHeight,this._explicitBackgroundWidth,this._explicitBackgroundHeight,this._explicitBackgroundMinWidth,this._explicitBackgroundMinHeight,this._explicitBackgroundMaxWidth,this._explicitBackgroundMaxHeight);
         var _loc3_:IMeasureDisplayObject = this.currentBackgroundSkin as IMeasureDisplayObject;
         if(this.currentBackgroundSkin is IValidating)
         {
            IValidating(this.currentBackgroundSkin).validate();
         }
         var _loc4_:Number = this._explicitMinWidth;
         if(_loc4_ !== _loc4_ || this._explicitViewPortMinWidth > _loc4_)
         {
            _loc4_ = this._explicitViewPortMinWidth;
         }
         if(_loc4_ !== _loc4_ || this._explicitWidth > _loc4_)
         {
            _loc4_ = this._explicitWidth;
         }
         if(this.currentBackgroundSkin !== null)
         {
            _loc7_ = this.currentBackgroundSkin.width;
            if(_loc3_ !== null)
            {
               _loc7_ = _loc3_.minWidth;
            }
            if(_loc4_ !== _loc4_ || _loc7_ > _loc4_)
            {
               _loc4_ = _loc7_;
            }
         }
         _loc4_ -= _loc1_;
         var _loc5_:Number = this._explicitMinHeight;
         if(_loc5_ !== _loc5_ || this._explicitViewPortMinHeight > _loc5_)
         {
            _loc5_ = this._explicitViewPortMinHeight;
         }
         if(_loc5_ !== _loc5_ || this._explicitHeight > _loc5_)
         {
            _loc5_ = this._explicitHeight;
         }
         if(this.currentBackgroundSkin !== null)
         {
            _loc8_ = this.currentBackgroundSkin.height;
            if(_loc3_ !== null)
            {
               _loc8_ = _loc3_.minHeight;
            }
            if(_loc5_ !== _loc5_ || _loc8_ > _loc5_)
            {
               _loc5_ = _loc8_;
            }
         }
         _loc5_ -= _loc2_;
         var _loc6_:Boolean = this.ignoreViewPortResizing;
         this.ignoreViewPortResizing = true;
         this._viewPort.visibleWidth = this._explicitWidth - _loc1_;
         this._viewPort.minVisibleWidth = this._explicitMinWidth - _loc1_;
         this._viewPort.maxVisibleWidth = this._explicitMaxWidth - _loc1_;
         this._viewPort.minWidth = _loc4_;
         this._viewPort.visibleHeight = this._explicitHeight - _loc2_;
         this._viewPort.minVisibleHeight = this._explicitMinHeight - _loc2_;
         this._viewPort.maxVisibleHeight = this._explicitMaxHeight - _loc2_;
         this._viewPort.minHeight = _loc5_;
         this._viewPort.validate();
         this.ignoreViewPortResizing = _loc6_;
      }
      
      protected function refreshViewPortBoundsForLayout() : void
      {
         var _loc1_:Number = this._leftViewPortOffset + this._rightViewPortOffset;
         var _loc2_:Number = this._topViewPortOffset + this._bottomViewPortOffset;
         var _loc3_:Boolean = this.ignoreViewPortResizing;
         this.ignoreViewPortResizing = true;
         var _loc4_:Number = this.actualWidth - _loc1_;
         if(this._viewPort.visibleWidth != _loc4_)
         {
            this._viewPort.visibleWidth = _loc4_;
         }
         this._viewPort.minVisibleWidth = this.actualMinWidth - _loc1_;
         this._viewPort.maxVisibleWidth = this._explicitMaxWidth - _loc1_;
         this._viewPort.minWidth = _loc4_;
         var _loc5_:Number = this.actualHeight - _loc2_;
         if(this._viewPort.visibleHeight != _loc5_)
         {
            this._viewPort.visibleHeight = _loc5_;
         }
         this._viewPort.minVisibleHeight = this.actualMinHeight - _loc2_;
         this._viewPort.maxVisibleHeight = this._explicitMaxHeight - _loc2_;
         this._viewPort.minHeight = _loc5_;
         this.ignoreViewPortResizing = _loc3_;
         this._viewPort.validate();
      }
      
      protected function refreshScrollValues() : void
      {
         this.refreshScrollSteps();
         var _loc1_:Number = this._maxHorizontalScrollPosition;
         var _loc2_:Number = this._maxVerticalScrollPosition;
         this.refreshMinAndMaxScrollPositions();
         var _loc3_:Boolean = this._maxHorizontalScrollPosition != _loc1_ || this._maxVerticalScrollPosition != _loc2_;
         if(_loc3_ && this._touchPointID < 0)
         {
            this.clampScrollPositions();
         }
         this.refreshPageCount();
         this.refreshPageIndices();
      }
      
      protected function clampScrollPositions() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         if(!this._horizontalAutoScrollTween)
         {
            if(this._snapToPages)
            {
               this._horizontalScrollPosition = roundToNearest(this._horizontalScrollPosition,this.actualPageWidth);
            }
            _loc1_ = this._horizontalScrollPosition;
            if(_loc1_ < this._minHorizontalScrollPosition)
            {
               _loc1_ = this._minHorizontalScrollPosition;
            }
            else if(_loc1_ > this._maxHorizontalScrollPosition)
            {
               _loc1_ = this._maxHorizontalScrollPosition;
            }
            this.horizontalScrollPosition = _loc1_;
         }
         if(!this._verticalAutoScrollTween)
         {
            if(this._snapToPages)
            {
               this._verticalScrollPosition = roundToNearest(this._verticalScrollPosition,this.actualPageHeight);
            }
            _loc2_ = this._verticalScrollPosition;
            if(_loc2_ < this._minVerticalScrollPosition)
            {
               _loc2_ = this._minVerticalScrollPosition;
            }
            else if(_loc2_ > this._maxVerticalScrollPosition)
            {
               _loc2_ = this._maxVerticalScrollPosition;
            }
            this.verticalScrollPosition = _loc2_;
         }
      }
      
      protected function refreshScrollSteps() : void
      {
         if(this.explicitHorizontalScrollStep !== this.explicitHorizontalScrollStep)
         {
            if(this._viewPort)
            {
               this.actualHorizontalScrollStep = this._viewPort.horizontalScrollStep;
            }
            else
            {
               this.actualHorizontalScrollStep = 1;
            }
         }
         else
         {
            this.actualHorizontalScrollStep = this.explicitHorizontalScrollStep;
         }
         if(this.explicitVerticalScrollStep !== this.explicitVerticalScrollStep)
         {
            if(this._viewPort)
            {
               this.actualVerticalScrollStep = this._viewPort.verticalScrollStep;
            }
            else
            {
               this.actualVerticalScrollStep = 1;
            }
         }
         else
         {
            this.actualVerticalScrollStep = this.explicitVerticalScrollStep;
         }
      }
      
      protected function refreshMinAndMaxScrollPositions() : void
      {
         var _loc1_:Number = this.actualWidth - (this._leftViewPortOffset + this._rightViewPortOffset);
         var _loc2_:Number = this.actualHeight - (this._topViewPortOffset + this._bottomViewPortOffset);
         if(this.explicitPageWidth !== this.explicitPageWidth)
         {
            this.actualPageWidth = _loc1_;
         }
         if(this.explicitPageHeight !== this.explicitPageHeight)
         {
            this.actualPageHeight = _loc2_;
         }
         if(this._viewPort)
         {
            this._minHorizontalScrollPosition = this._viewPort.contentX;
            if(this._viewPort.width == Number.POSITIVE_INFINITY)
            {
               this._maxHorizontalScrollPosition = Number.POSITIVE_INFINITY;
            }
            else
            {
               this._maxHorizontalScrollPosition = this._minHorizontalScrollPosition + this._viewPort.width - _loc1_;
            }
            if(this._maxHorizontalScrollPosition < this._minHorizontalScrollPosition)
            {
               this._maxHorizontalScrollPosition = this._minHorizontalScrollPosition;
            }
            this._minVerticalScrollPosition = this._viewPort.contentY;
            if(this._viewPort.height == Number.POSITIVE_INFINITY)
            {
               this._maxVerticalScrollPosition = Number.POSITIVE_INFINITY;
            }
            else
            {
               this._maxVerticalScrollPosition = this._minVerticalScrollPosition + this._viewPort.height - _loc2_;
            }
            if(this._maxVerticalScrollPosition < this._minVerticalScrollPosition)
            {
               this._maxVerticalScrollPosition = this._minVerticalScrollPosition;
            }
         }
         else
         {
            this._minHorizontalScrollPosition = 0;
            this._minVerticalScrollPosition = 0;
            this._maxHorizontalScrollPosition = 0;
            this._maxVerticalScrollPosition = 0;
         }
      }
      
      protected function refreshPageCount() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         if(this._snapToPages)
         {
            _loc1_ = this._maxHorizontalScrollPosition - this._minHorizontalScrollPosition;
            if(_loc1_ == Number.POSITIVE_INFINITY)
            {
               if(this._minHorizontalScrollPosition == Number.NEGATIVE_INFINITY)
               {
                  this._minHorizontalPageIndex = int.MIN_VALUE;
               }
               else
               {
                  this._minHorizontalPageIndex = 0;
               }
               this._maxHorizontalPageIndex = int.MAX_VALUE;
            }
            else
            {
               this._minHorizontalPageIndex = 0;
               _loc3_ = _loc1_ / this.actualPageWidth;
               _loc4_ = Math.round(_loc3_);
               if(MathUtil.isEquivalent(_loc3_,_loc4_,PAGE_INDEX_EPSILON))
               {
                  this._maxHorizontalPageIndex = _loc4_;
               }
               else
               {
                  this._maxHorizontalPageIndex = Math.ceil(_loc3_);
               }
            }
            _loc2_ = this._maxVerticalScrollPosition - this._minVerticalScrollPosition;
            if(_loc2_ == Number.POSITIVE_INFINITY)
            {
               if(this._minVerticalScrollPosition == Number.NEGATIVE_INFINITY)
               {
                  this._minVerticalPageIndex = int.MIN_VALUE;
               }
               else
               {
                  this._minVerticalPageIndex = 0;
               }
               this._maxVerticalPageIndex = int.MAX_VALUE;
            }
            else
            {
               this._minVerticalPageIndex = 0;
               _loc3_ = _loc2_ / this.actualPageHeight;
               _loc4_ = Math.round(_loc3_);
               if(MathUtil.isEquivalent(_loc3_,_loc4_,PAGE_INDEX_EPSILON))
               {
                  this._maxVerticalPageIndex = _loc4_;
               }
               else
               {
                  this._maxVerticalPageIndex = Math.ceil(_loc3_);
               }
            }
         }
         else
         {
            this._maxHorizontalPageIndex = 0;
            this._maxHorizontalPageIndex = 0;
            this._minVerticalPageIndex = 0;
            this._maxVerticalPageIndex = 0;
         }
      }
      
      protected function refreshPageIndices() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(!this._horizontalAutoScrollTween && !this.hasPendingHorizontalPageIndex)
         {
            if(this._snapToPages)
            {
               if(this._horizontalScrollPosition == this._maxHorizontalScrollPosition)
               {
                  this._horizontalPageIndex = this._maxHorizontalPageIndex;
               }
               else if(this._horizontalScrollPosition == this._minHorizontalScrollPosition)
               {
                  this._horizontalPageIndex = this._minHorizontalPageIndex;
               }
               else
               {
                  if(this._minHorizontalScrollPosition == Number.NEGATIVE_INFINITY && this._horizontalScrollPosition < 0)
                  {
                     _loc2_ = this._horizontalScrollPosition / this.actualPageWidth;
                  }
                  else if(this._maxHorizontalScrollPosition == Number.POSITIVE_INFINITY && this._horizontalScrollPosition >= 0)
                  {
                     _loc2_ = this._horizontalScrollPosition / this.actualPageWidth;
                  }
                  else
                  {
                     _loc3_ = this._horizontalScrollPosition - this._minHorizontalScrollPosition;
                     _loc2_ = _loc3_ / this.actualPageWidth;
                  }
                  _loc1_ = Math.round(_loc2_);
                  if(_loc2_ != _loc1_ && MathUtil.isEquivalent(_loc2_,_loc1_,PAGE_INDEX_EPSILON))
                  {
                     this._horizontalPageIndex = _loc1_;
                  }
                  else
                  {
                     this._horizontalPageIndex = Math.floor(_loc2_);
                  }
               }
            }
            else
            {
               this._horizontalPageIndex = this._minHorizontalPageIndex;
            }
            if(this._horizontalPageIndex < this._minHorizontalPageIndex)
            {
               this._horizontalPageIndex = this._minHorizontalPageIndex;
            }
            if(this._horizontalPageIndex > this._maxHorizontalPageIndex)
            {
               this._horizontalPageIndex = this._maxHorizontalPageIndex;
            }
         }
         if(!this._verticalAutoScrollTween && !this.hasPendingVerticalPageIndex)
         {
            if(this._snapToPages)
            {
               if(this._verticalScrollPosition == this._maxVerticalScrollPosition)
               {
                  this._verticalPageIndex = this._maxVerticalPageIndex;
               }
               else if(this._verticalScrollPosition == this._minVerticalScrollPosition)
               {
                  this._verticalPageIndex = this._minVerticalPageIndex;
               }
               else
               {
                  if(this._minVerticalScrollPosition == Number.NEGATIVE_INFINITY && this._verticalScrollPosition < 0)
                  {
                     _loc2_ = this._verticalScrollPosition / this.actualPageHeight;
                  }
                  else if(this._maxVerticalScrollPosition == Number.POSITIVE_INFINITY && this._verticalScrollPosition >= 0)
                  {
                     _loc2_ = this._verticalScrollPosition / this.actualPageHeight;
                  }
                  else
                  {
                     _loc4_ = this._verticalScrollPosition - this._minVerticalScrollPosition;
                     _loc2_ = _loc4_ / this.actualPageHeight;
                  }
                  _loc1_ = Math.round(_loc2_);
                  if(_loc2_ != _loc1_ && MathUtil.isEquivalent(_loc2_,_loc1_,PAGE_INDEX_EPSILON))
                  {
                     this._verticalPageIndex = _loc1_;
                  }
                  else
                  {
                     this._verticalPageIndex = Math.floor(_loc2_);
                  }
               }
            }
            else
            {
               this._verticalPageIndex = this._minVerticalScrollPosition;
            }
            if(this._verticalPageIndex < this._minVerticalScrollPosition)
            {
               this._verticalPageIndex = this._minVerticalScrollPosition;
            }
            if(this._verticalPageIndex > this._maxVerticalPageIndex)
            {
               this._verticalPageIndex = this._maxVerticalPageIndex;
            }
         }
      }
      
      protected function refreshScrollBarValues() : void
      {
         if(this.horizontalScrollBar)
         {
            this.horizontalScrollBar.minimum = this._minHorizontalScrollPosition;
            this.horizontalScrollBar.maximum = this._maxHorizontalScrollPosition;
            this.horizontalScrollBar.value = this._horizontalScrollPosition;
            this.horizontalScrollBar.page = (this._maxHorizontalScrollPosition - this._minHorizontalScrollPosition) * this.actualPageWidth / this._viewPort.width;
            this.horizontalScrollBar.step = this.actualHorizontalScrollStep;
         }
         if(this.verticalScrollBar)
         {
            this.verticalScrollBar.minimum = this._minVerticalScrollPosition;
            this.verticalScrollBar.maximum = this._maxVerticalScrollPosition;
            this.verticalScrollBar.value = this._verticalScrollPosition;
            this.verticalScrollBar.page = (this._maxVerticalScrollPosition - this._minVerticalScrollPosition) * this.actualPageHeight / this._viewPort.height;
            this.verticalScrollBar.step = this.actualVerticalScrollStep;
         }
      }
      
      protected function showOrHideChildren() : void
      {
         var _loc1_:int = this.numRawChildrenInternal;
         if(this.verticalScrollBar)
         {
            this.verticalScrollBar.visible = this._hasVerticalScrollBar;
            this.verticalScrollBar.touchable = this._hasVerticalScrollBar && this._interactionMode != ScrollInteractionMode.TOUCH;
            this.setRawChildIndexInternal(DisplayObject(this.verticalScrollBar),_loc1_ - 1);
         }
         if(this.horizontalScrollBar)
         {
            this.horizontalScrollBar.visible = this._hasHorizontalScrollBar;
            this.horizontalScrollBar.touchable = this._hasHorizontalScrollBar && this._interactionMode != ScrollInteractionMode.TOUCH;
            if(this.verticalScrollBar)
            {
               this.setRawChildIndexInternal(DisplayObject(this.horizontalScrollBar),_loc1_ - 2);
            }
            else
            {
               this.setRawChildIndexInternal(DisplayObject(this.horizontalScrollBar),_loc1_ - 1);
            }
         }
         if(this.currentBackgroundSkin)
         {
            if(this._autoHideBackground)
            {
               this.currentBackgroundSkin.visible = this._viewPort.width <= this.actualWidth || this._viewPort.height <= this.actualHeight || this._horizontalScrollPosition < 0 || this._horizontalScrollPosition > this._maxHorizontalScrollPosition || this._verticalScrollPosition < 0 || this._verticalScrollPosition > this._maxVerticalScrollPosition;
            }
            else
            {
               this.currentBackgroundSkin.visible = true;
            }
         }
      }
      
      protected function calculateViewPortOffsetsForFixedHorizontalScrollBar(param1:Boolean = false, param2:Boolean = false) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(Boolean(this.horizontalScrollBar) && (this._measureViewPort || param2))
         {
            _loc3_ = param2 ? this.actualWidth : this._explicitWidth;
            if(!param2 && !param1 && _loc3_ !== _loc3_)
            {
               _loc3_ = this._viewPort.visibleWidth + this._leftViewPortOffset + this._rightViewPortOffset;
            }
            _loc4_ = this._viewPort.width + this._leftViewPortOffset + this._rightViewPortOffset;
            if(param1 || this._horizontalScrollPolicy === ScrollPolicy.ON || (_loc4_ > _loc3_ || _loc4_ > this._explicitMaxWidth) && this._horizontalScrollPolicy !== ScrollPolicy.OFF)
            {
               this._hasHorizontalScrollBar = true;
               if(this._scrollBarDisplayMode === ScrollBarDisplayMode.FIXED)
               {
                  if(this._horizontalScrollBarPosition === RelativePosition.TOP)
                  {
                     this._topViewPortOffset += this.horizontalScrollBar.height;
                  }
                  else
                  {
                     this._bottomViewPortOffset += this.horizontalScrollBar.height;
                  }
               }
            }
            else
            {
               this._hasHorizontalScrollBar = false;
            }
         }
         else
         {
            this._hasHorizontalScrollBar = false;
         }
      }
      
      protected function calculateViewPortOffsetsForFixedVerticalScrollBar(param1:Boolean = false, param2:Boolean = false) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(Boolean(this.verticalScrollBar) && (this._measureViewPort || param2))
         {
            _loc3_ = param2 ? this.actualHeight : this._explicitHeight;
            if(!param2 && !param1 && _loc3_ !== _loc3_)
            {
               _loc3_ = this._viewPort.visibleHeight + this._topViewPortOffset + this._bottomViewPortOffset;
            }
            _loc4_ = this._viewPort.height + this._topViewPortOffset + this._bottomViewPortOffset;
            if(param1 || this._verticalScrollPolicy === ScrollPolicy.ON || (_loc4_ > _loc3_ || _loc4_ > this._explicitMaxHeight) && this._verticalScrollPolicy !== ScrollPolicy.OFF)
            {
               this._hasVerticalScrollBar = true;
               if(this._scrollBarDisplayMode === ScrollBarDisplayMode.FIXED)
               {
                  if(this._verticalScrollBarPosition === RelativePosition.LEFT)
                  {
                     this._leftViewPortOffset += this.verticalScrollBar.width;
                  }
                  else
                  {
                     this._rightViewPortOffset += this.verticalScrollBar.width;
                  }
               }
            }
            else
            {
               this._hasVerticalScrollBar = false;
            }
         }
         else
         {
            this._hasVerticalScrollBar = false;
         }
      }
      
      protected function calculateViewPortOffsets(param1:Boolean = false, param2:Boolean = false) : void
      {
         this._topViewPortOffset = this._paddingTop;
         this._rightViewPortOffset = this._paddingRight;
         this._bottomViewPortOffset = this._paddingBottom;
         this._leftViewPortOffset = this._paddingLeft;
         this.calculateViewPortOffsetsForFixedHorizontalScrollBar(param1,param2);
         this.calculateViewPortOffsetsForFixedVerticalScrollBar(param1,param2);
         if(this._scrollBarDisplayMode == ScrollBarDisplayMode.FIXED && this._hasVerticalScrollBar && !this._hasHorizontalScrollBar)
         {
            this.calculateViewPortOffsetsForFixedHorizontalScrollBar(param1,param2);
         }
      }
      
      protected function refreshInteractionModeEvents() : void
      {
         if(this._interactionMode == ScrollInteractionMode.TOUCH || this._interactionMode == ScrollInteractionMode.TOUCH_AND_SCROLL_BARS)
         {
            this.addEventListener(TouchEvent.TOUCH,this.scroller_touchHandler);
         }
         else
         {
            this.removeEventListener(TouchEvent.TOUCH,this.scroller_touchHandler);
         }
         if((this._interactionMode == ScrollInteractionMode.MOUSE || this._interactionMode == ScrollInteractionMode.TOUCH_AND_SCROLL_BARS) && this._scrollBarDisplayMode == ScrollBarDisplayMode.FLOAT)
         {
            if(this.horizontalScrollBar)
            {
               this.horizontalScrollBar.addEventListener(TouchEvent.TOUCH,this.horizontalScrollBar_touchHandler);
            }
            if(this.verticalScrollBar)
            {
               this.verticalScrollBar.addEventListener(TouchEvent.TOUCH,this.verticalScrollBar_touchHandler);
            }
         }
         else
         {
            if(this.horizontalScrollBar)
            {
               this.horizontalScrollBar.removeEventListener(TouchEvent.TOUCH,this.horizontalScrollBar_touchHandler);
            }
            if(this.verticalScrollBar)
            {
               this.verticalScrollBar.removeEventListener(TouchEvent.TOUCH,this.verticalScrollBar_touchHandler);
            }
         }
      }
      
      protected function layoutChildren() : void
      {
         var _loc3_:Starling = null;
         var _loc4_:Number = NaN;
         var _loc1_:Number = this.actualWidth - this._leftViewPortOffset - this._rightViewPortOffset;
         var _loc2_:Number = this.actualHeight - this._topViewPortOffset - this._bottomViewPortOffset;
         if(this.currentBackgroundSkin !== null)
         {
            this.currentBackgroundSkin.width = this.actualWidth;
            this.currentBackgroundSkin.height = this.actualHeight;
         }
         if(this._snapScrollPositionsToPixels)
         {
            _loc3_ = this.stage !== null ? this.stage.starling : Starling.current;
            _loc4_ = 1 / _loc3_.contentScaleFactor;
            this._viewPort.x = Math.round((this._leftViewPortOffset - this._horizontalScrollPosition) / _loc4_) * _loc4_;
            this._viewPort.y = Math.round((this._topViewPortOffset - this._verticalScrollPosition) / _loc4_) * _loc4_;
         }
         else
         {
            this._viewPort.x = this._leftViewPortOffset - this._horizontalScrollPosition;
            this._viewPort.y = this._topViewPortOffset - this._verticalScrollPosition;
         }
         this.layoutPullViews();
         this.layoutScrollBars();
      }
      
      protected function layoutScrollBars() : void
      {
         var _loc1_:Number = this.actualWidth - this._leftViewPortOffset - this._rightViewPortOffset;
         var _loc2_:Number = this.actualHeight - this._topViewPortOffset - this._bottomViewPortOffset;
         if(this.horizontalScrollBar !== null)
         {
            this.horizontalScrollBar.validate();
         }
         if(this.verticalScrollBar !== null)
         {
            this.verticalScrollBar.validate();
         }
         if(this.horizontalScrollBar !== null)
         {
            if(this._horizontalScrollBarPosition === RelativePosition.TOP)
            {
               this.horizontalScrollBar.y = this._paddingTop;
            }
            else
            {
               this.horizontalScrollBar.y = this._topViewPortOffset + _loc2_;
            }
            this.horizontalScrollBar.x = this._leftViewPortOffset;
            if(this._scrollBarDisplayMode !== ScrollBarDisplayMode.FIXED)
            {
               this.horizontalScrollBar.y -= this.horizontalScrollBar.height;
               if((Boolean(this._hasVerticalScrollBar) || Boolean(this._verticalScrollBarHideTween)) && Boolean(this.verticalScrollBar))
               {
                  this.horizontalScrollBar.width = _loc1_ - this.verticalScrollBar.width;
               }
               else
               {
                  this.horizontalScrollBar.width = _loc1_;
               }
            }
            else
            {
               this.horizontalScrollBar.width = _loc1_;
            }
         }
         if(this.verticalScrollBar !== null)
         {
            if(this._verticalScrollBarPosition === RelativePosition.LEFT)
            {
               this.verticalScrollBar.x = this._paddingLeft;
            }
            else
            {
               this.verticalScrollBar.x = this._leftViewPortOffset + _loc1_;
            }
            this.verticalScrollBar.y = this._topViewPortOffset;
            if(this._scrollBarDisplayMode !== ScrollBarDisplayMode.FIXED)
            {
               this.verticalScrollBar.x -= this.verticalScrollBar.width;
               if((Boolean(this._hasHorizontalScrollBar) || Boolean(this._horizontalScrollBarHideTween)) && Boolean(this.horizontalScrollBar))
               {
                  this.verticalScrollBar.height = _loc2_ - this.horizontalScrollBar.height;
               }
               else
               {
                  this.verticalScrollBar.height = _loc2_;
               }
            }
            else
            {
               this.verticalScrollBar.height = _loc2_;
            }
         }
      }
      
      protected function layoutPullViews() : void
      {
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc1_:* = this.getRawChildIndexInternal(DisplayObject(this._viewPort));
         if(this._topPullView !== null)
         {
            if(this._topPullView is IValidating)
            {
               IValidating(this._topPullView).validate();
            }
            this._topPullView.x = this._topPullView.pivotX * this._topPullView.scaleX + (this.actualWidth - this._topPullView.width) / 2;
            if(this._topPullTween === null)
            {
               _loc3_ = this._topPullView.height;
               _loc4_ = this._topPullViewRatio;
               if(this._verticalScrollPosition < this._minVerticalScrollPosition)
               {
                  _loc5_ = (this._minVerticalScrollPosition - this._verticalScrollPosition) / _loc3_;
                  if(_loc5_ > _loc4_)
                  {
                     _loc4_ = _loc5_;
                  }
               }
               if(this._isTopPullViewActive && _loc4_ < 1)
               {
                  _loc4_ = 1;
               }
               if(_loc4_ > 0)
               {
                  if(this._topPullViewDisplayMode === PullViewDisplayMode.FIXED)
                  {
                     this._topPullView.y = this._topViewPortOffset + this._topPullView.pivotY * this._topPullView.scaleY;
                  }
                  else
                  {
                     this._topPullView.y = this._topViewPortOffset + this._topPullView.pivotY * this._topPullView.scaleY + _loc4_ * _loc3_ - _loc3_;
                  }
                  this._topPullView.visible = true;
                  this.refreshTopPullViewMask();
               }
               else
               {
                  this._topPullView.visible = false;
               }
            }
            _loc2_ = this.getRawChildIndexInternal(this._topPullView);
            if(this._topPullViewDisplayMode === PullViewDisplayMode.FIXED && this._hasElasticEdges)
            {
               if(_loc1_ < _loc2_)
               {
                  this.setRawChildIndexInternal(this._topPullView,_loc1_);
                  _loc1_++;
               }
            }
            else if(_loc1_ > _loc2_)
            {
               this.removeRawChildInternal(this._topPullView);
               this.addRawChildAtInternal(this._topPullView,_loc1_);
               _loc1_--;
            }
         }
         if(this._rightPullView !== null)
         {
            if(this._rightPullView is IValidating)
            {
               IValidating(this._rightPullView).validate();
            }
            this._rightPullView.y = this._rightPullView.pivotY * this._rightPullView.scaleY + (this.actualHeight - this._rightPullView.height) / 2;
            if(this._rightPullTween === null)
            {
               _loc3_ = this._rightPullView.width;
               _loc4_ = this._rightPullViewRatio;
               if(this._horizontalScrollPosition > this._maxHorizontalScrollPosition)
               {
                  _loc5_ = (this._horizontalScrollPosition - this._maxHorizontalScrollPosition) / _loc3_;
                  if(_loc5_ > _loc4_)
                  {
                     _loc4_ = _loc5_;
                  }
               }
               if(this._isRightPullViewActive && _loc4_ < 1)
               {
                  _loc4_ = 1;
               }
               if(_loc4_ > 0)
               {
                  if(this._rightPullViewDisplayMode === PullViewDisplayMode.FIXED)
                  {
                     this._rightPullView.x = this._rightPullView.pivotX * this._rightPullView.scaleX + this.actualWidth - this._rightViewPortOffset - _loc3_;
                  }
                  else
                  {
                     this._rightPullView.x = this._rightPullView.pivotX * this._rightPullView.scaleX + this.actualWidth - this._rightViewPortOffset - _loc4_ * _loc3_;
                  }
                  this._rightPullView.visible = true;
                  this.refreshRightPullViewMask();
               }
               else
               {
                  this._rightPullView.visible = false;
               }
            }
            _loc2_ = this.getRawChildIndexInternal(this._rightPullView);
            if(this._rightPullViewDisplayMode === PullViewDisplayMode.FIXED && this._hasElasticEdges)
            {
               if(_loc1_ < _loc2_)
               {
                  this.setRawChildIndexInternal(this._rightPullView,_loc1_);
                  _loc1_++;
               }
            }
            else if(_loc1_ > _loc2_)
            {
               this.removeRawChildInternal(this._rightPullView);
               this.addRawChildAtInternal(this._rightPullView,_loc1_);
               _loc1_--;
            }
         }
         if(this._bottomPullView !== null)
         {
            if(this._bottomPullView is IValidating)
            {
               IValidating(this._bottomPullView).validate();
            }
            this._bottomPullView.x = this._bottomPullView.pivotX * this._bottomPullView.scaleX + (this.actualWidth - this._bottomPullView.width) / 2;
            if(this._bottomPullTween === null)
            {
               _loc3_ = this._bottomPullView.height;
               _loc4_ = this._bottomPullViewRatio;
               if(this._verticalScrollPosition > this._maxVerticalScrollPosition)
               {
                  _loc5_ = (this._verticalScrollPosition - this._maxVerticalScrollPosition) / _loc3_;
                  if(_loc5_ > _loc4_)
                  {
                     _loc4_ = _loc5_;
                  }
               }
               if(this._isBottomPullViewActive && _loc4_ < 1)
               {
                  _loc4_ = 1;
               }
               if(_loc4_ > 0)
               {
                  if(this._bottomPullViewDisplayMode === PullViewDisplayMode.FIXED)
                  {
                     this._bottomPullView.y = this._bottomPullView.pivotY * this._bottomPullView.scaleY + this.actualHeight - this._bottomViewPortOffset - _loc3_;
                  }
                  else
                  {
                     this._bottomPullView.y = this._bottomPullView.pivotY * this._bottomPullView.scaleY + this.actualHeight - this._bottomViewPortOffset - _loc4_ * _loc3_;
                  }
                  this._bottomPullView.visible = true;
                  this.refreshBottomPullViewMask();
               }
               else
               {
                  this._bottomPullView.visible = false;
               }
            }
            _loc2_ = this.getRawChildIndexInternal(this._bottomPullView);
            if(this._bottomPullViewDisplayMode === PullViewDisplayMode.FIXED && this._hasElasticEdges)
            {
               if(_loc1_ < _loc2_)
               {
                  this.setRawChildIndexInternal(this._bottomPullView,_loc1_);
                  _loc1_++;
               }
            }
            else if(_loc1_ > _loc2_)
            {
               this.removeRawChildInternal(this._bottomPullView);
               this.addRawChildAtInternal(this._bottomPullView,_loc1_);
               _loc1_--;
            }
         }
         if(this._leftPullView !== null)
         {
            if(this._leftPullView is IValidating)
            {
               IValidating(this._leftPullView).validate();
            }
            this._leftPullView.y = this._leftPullView.pivotY * this._leftPullView.scaleY + (this.actualHeight - this._leftPullView.height) / 2;
            if(this._leftPullTween === null)
            {
               _loc3_ = this._leftPullView.width;
               _loc4_ = this._leftPullViewRatio;
               if(this._horizontalScrollPosition < this._minHorizontalScrollPosition)
               {
                  _loc5_ = (this._minHorizontalScrollPosition - this._horizontalScrollPosition) / _loc3_;
                  if(_loc5_ > _loc4_)
                  {
                     _loc4_ = _loc5_;
                  }
               }
               if(this._isLeftPullViewActive && _loc4_ < 1)
               {
                  _loc4_ = 1;
               }
               if(_loc4_ > 0)
               {
                  if(this._leftPullViewDisplayMode === PullViewDisplayMode.FIXED)
                  {
                     this._leftPullView.x = this._leftViewPortOffset + this._leftPullView.pivotX * this._leftPullView.scaleX;
                  }
                  else
                  {
                     this._leftPullView.x = this._leftViewPortOffset + this._leftPullView.pivotX * this._leftPullView.scaleX + _loc4_ * _loc3_ - _loc3_;
                  }
                  this._leftPullView.visible = true;
                  this.refreshLeftPullViewMask();
               }
               else
               {
                  this._leftPullView.visible = false;
               }
            }
            _loc2_ = this.getRawChildIndexInternal(this._leftPullView);
            if(this._leftPullViewDisplayMode === PullViewDisplayMode.FIXED && this._hasElasticEdges)
            {
               if(_loc1_ < _loc2_)
               {
                  this.setRawChildIndexInternal(this._leftPullView,_loc1_);
               }
            }
            else if(_loc1_ > _loc2_)
            {
               this.removeRawChildInternal(this._leftPullView);
               this.addRawChildAtInternal(this._leftPullView,_loc1_);
            }
         }
      }
      
      protected function refreshTopPullViewMask() : void
      {
         var _loc1_:Number = this._topPullView.height / this._topPullView.scaleY;
         var _loc2_:DisplayObject = this._topPullView.mask;
         var _loc3_:Number = _loc1_ + (this._topPullView.y - this._topPullView.pivotY * this._topPullView.scaleY - this._paddingTop) / this._topPullView.scaleY;
         if(_loc3_ < 0)
         {
            _loc3_ = 0;
         }
         else if(_loc3_ > _loc1_)
         {
            _loc3_ = _loc1_;
         }
         _loc2_.width = this._topPullView.width / this._topPullView.scaleX;
         _loc2_.height = _loc3_;
         _loc2_.x = 0;
         _loc2_.y = _loc1_ - _loc3_;
      }
      
      protected function refreshRightPullViewMask() : void
      {
         var _loc1_:Number = this._rightPullView.width / this._rightPullView.scaleX;
         var _loc2_:DisplayObject = this._rightPullView.mask;
         var _loc3_:Number = this.actualWidth - this._rightViewPortOffset - (this._rightPullView.x - this._rightPullView.pivotX / this._rightPullView.scaleX) / this._rightPullView.scaleX;
         if(_loc3_ < 0)
         {
            _loc3_ = 0;
         }
         else if(_loc3_ > _loc1_)
         {
            _loc3_ = _loc1_;
         }
         _loc2_.width = _loc3_;
         _loc2_.height = this._rightPullView.height / this._rightPullView.scaleY;
         _loc2_.x = 0;
         _loc2_.y = 0;
      }
      
      protected function refreshBottomPullViewMask() : void
      {
         var _loc1_:Number = this._bottomPullView.height / this._bottomPullView.scaleY;
         var _loc2_:DisplayObject = this._bottomPullView.mask;
         var _loc3_:Number = this.actualHeight - this._bottomViewPortOffset - (this._bottomPullView.y - this._bottomPullView.pivotY / this._bottomPullView.scaleY) / this._bottomPullView.scaleY;
         if(_loc3_ < 0)
         {
            _loc3_ = 0;
         }
         else if(_loc3_ > _loc1_)
         {
            _loc3_ = _loc1_;
         }
         _loc2_.width = this._bottomPullView.width / this._bottomPullView.scaleX;
         _loc2_.height = _loc3_;
         _loc2_.x = 0;
         _loc2_.y = 0;
      }
      
      protected function refreshLeftPullViewMask() : void
      {
         var _loc1_:Number = this._leftPullView.width / this._leftPullView.scaleX;
         var _loc2_:DisplayObject = this._leftPullView.mask;
         var _loc3_:Number = _loc1_ + (this._leftPullView.x - this._leftPullView.pivotX * this._leftPullView.scaleX - this._paddingLeft) / this._leftPullView.scaleX;
         if(_loc3_ < 0)
         {
            _loc3_ = 0;
         }
         else if(_loc3_ > _loc1_)
         {
            _loc3_ = _loc1_;
         }
         _loc2_.width = _loc3_;
         _loc2_.height = this._leftPullView.height / this._leftPullView.scaleY;
         _loc2_.x = _loc1_ - _loc3_;
         _loc2_.y = 0;
      }
      
      protected function refreshMask() : void
      {
         if(!this._clipContent)
         {
            return;
         }
         var _loc1_:Number = this.actualWidth - this._leftViewPortOffset - this._rightViewPortOffset;
         if(_loc1_ < 0)
         {
            _loc1_ = 0;
         }
         var _loc2_:Number = this.actualHeight - this._topViewPortOffset - this._bottomViewPortOffset;
         if(_loc2_ < 0)
         {
            _loc2_ = 0;
         }
         var _loc3_:Quad = this._viewPort.mask as Quad;
         if(!_loc3_)
         {
            _loc3_ = new Quad(1,1,1044735);
            this._viewPort.mask = _loc3_;
         }
         _loc3_.x = this._horizontalScrollPosition;
         _loc3_.y = this._verticalScrollPosition;
         _loc3_.width = _loc1_;
         _loc3_.height = _loc2_;
      }
      
      protected function get numRawChildrenInternal() : int
      {
         if(this is IScrollContainer)
         {
            return IScrollContainer(this).numRawChildren;
         }
         return this.numChildren;
      }
      
      protected function addRawChildInternal(param1:DisplayObject) : DisplayObject
      {
         if(this is IScrollContainer)
         {
            return IScrollContainer(this).addRawChild(param1);
         }
         return this.addChild(param1);
      }
      
      protected function addRawChildAtInternal(param1:DisplayObject, param2:int) : DisplayObject
      {
         if(this is IScrollContainer)
         {
            return IScrollContainer(this).addRawChildAt(param1,param2);
         }
         return this.addChildAt(param1,param2);
      }
      
      protected function removeRawChildInternal(param1:DisplayObject, param2:Boolean = false) : DisplayObject
      {
         if(this is IScrollContainer)
         {
            return IScrollContainer(this).removeRawChild(param1,param2);
         }
         return this.removeChild(param1,param2);
      }
      
      protected function removeRawChildAtInternal(param1:int, param2:Boolean = false) : DisplayObject
      {
         if(this is IScrollContainer)
         {
            return IScrollContainer(this).removeRawChildAt(param1,param2);
         }
         return this.removeChildAt(param1,param2);
      }
      
      protected function getRawChildIndexInternal(param1:DisplayObject) : int
      {
         if(this is IScrollContainer)
         {
            return IScrollContainer(this).getRawChildIndex(param1);
         }
         return this.getChildIndex(param1);
      }
      
      protected function setRawChildIndexInternal(param1:DisplayObject, param2:int) : void
      {
         if(this is IScrollContainer)
         {
            IScrollContainer(this).setRawChildIndex(param1,param2);
            return;
         }
         this.setChildIndex(param1,param2);
      }
      
      protected function updateHorizontalScrollFromTouchPosition(param1:Number) : void
      {
         var _loc2_:Number = this._startTouchX - param1;
         var _loc3_:Number = this._startHorizontalScrollPosition + _loc2_;
         var _loc4_:Number = this._minHorizontalScrollPosition;
         if(this._isLeftPullViewActive && this._hasElasticEdges)
         {
            _loc4_ -= this._leftPullView.width;
         }
         var _loc5_:Number = this._maxHorizontalScrollPosition;
         if(this._isRightPullViewActive && this._hasElasticEdges)
         {
            _loc5_ += this._rightPullView.width;
         }
         if(_loc3_ < _loc4_)
         {
            _loc3_ -= (_loc3_ - _loc4_) * (1 - this._elasticity);
            if(this._leftPullView !== null && _loc3_ < _loc4_)
            {
               if(this._isLeftPullViewActive)
               {
                  this.leftPullViewRatio = 1;
               }
               else
               {
                  this.leftPullViewRatio = (_loc4_ - _loc3_) / this._leftPullView.width;
               }
            }
            if(this._rightPullView !== null && !this._isRightPullViewActive)
            {
               this.rightPullViewRatio = 0;
            }
            if(!this._hasElasticEdges || this._isRightPullViewActive && this._minHorizontalScrollPosition == this._maxHorizontalScrollPosition)
            {
               _loc3_ = _loc4_;
            }
         }
         else if(_loc3_ > _loc5_)
         {
            _loc3_ -= (_loc3_ - _loc5_) * (1 - this._elasticity);
            if(this._rightPullView !== null && _loc3_ > _loc5_)
            {
               if(this._isRightPullViewActive)
               {
                  this.rightPullViewRatio = 1;
               }
               else
               {
                  this.rightPullViewRatio = (_loc3_ - _loc5_) / this._rightPullView.width;
               }
            }
            if(this._leftPullView !== null && !this._isLeftPullViewActive)
            {
               this.leftPullViewRatio = 0;
            }
            if(!this._hasElasticEdges || this._isLeftPullViewActive && this._minHorizontalScrollPosition == this._maxHorizontalScrollPosition)
            {
               _loc3_ = _loc5_;
            }
         }
         else
         {
            if(this._leftPullView !== null && !this._isLeftPullViewActive)
            {
               this.leftPullViewRatio = 0;
            }
            if(this._rightPullView !== null && !this._isRightPullViewActive)
            {
               this.rightPullViewRatio = 0;
            }
         }
         if(this._leftPullViewRatio > 0)
         {
            if(this._leftPullTween !== null)
            {
               this._leftPullTween.dispatchEventWith(starling.events.Event.REMOVE_FROM_JUGGLER);
               this._leftPullTween = null;
            }
            this.invalidate(INVALIDATION_FLAG_SCROLL);
         }
         if(this._rightPullViewRatio > 0)
         {
            if(this._rightPullTween !== null)
            {
               this._rightPullTween.dispatchEventWith(starling.events.Event.REMOVE_FROM_JUGGLER);
               this._rightPullTween = null;
            }
            this.invalidate(INVALIDATION_FLAG_SCROLL);
         }
         this.horizontalScrollPosition = _loc3_;
      }
      
      protected function updateVerticalScrollFromTouchPosition(param1:Number) : void
      {
         var _loc2_:Number = this._startTouchY - param1;
         var _loc3_:Number = this._startVerticalScrollPosition + _loc2_;
         var _loc4_:Number = this._minVerticalScrollPosition;
         if(this._isTopPullViewActive && this._hasElasticEdges)
         {
            _loc4_ -= this._topPullView.height;
         }
         var _loc5_:Number = this._maxVerticalScrollPosition;
         if(this._isBottomPullViewActive && this._hasElasticEdges)
         {
            _loc5_ += this._bottomPullView.height;
         }
         if(_loc3_ < _loc4_)
         {
            _loc3_ -= (_loc3_ - _loc4_) * (1 - this._elasticity);
            if(this._topPullView !== null && _loc3_ < _loc4_)
            {
               if(this._isTopPullViewActive)
               {
                  this.topPullViewRatio = 1;
               }
               else
               {
                  this.topPullViewRatio = (_loc4_ - _loc3_) / this._topPullView.height;
               }
            }
            if(this._bottomPullView !== null && !this._isBottomPullViewActive)
            {
               this.bottomPullViewRatio = 0;
            }
            if(!this._hasElasticEdges || this._isBottomPullViewActive && this._minVerticalScrollPosition == this._maxVerticalScrollPosition)
            {
               _loc3_ = _loc4_;
            }
         }
         else if(_loc3_ > _loc5_)
         {
            _loc3_ -= (_loc3_ - _loc5_) * (1 - this._elasticity);
            if(this._bottomPullView !== null && _loc3_ > _loc5_)
            {
               if(this._isBottomPullViewActive)
               {
                  this.bottomPullViewRatio = 1;
               }
               else
               {
                  this.bottomPullViewRatio = (_loc3_ - _loc5_) / this._bottomPullView.height;
               }
            }
            if(this._topPullView !== null && !this._isTopPullViewActive)
            {
               this.topPullViewRatio = 0;
            }
            if(!this._hasElasticEdges || this._isTopPullViewActive && this._minVerticalScrollPosition == this._maxVerticalScrollPosition)
            {
               _loc3_ = _loc5_;
            }
         }
         else
         {
            if(this._topPullView !== null && !this._isTopPullViewActive)
            {
               this.topPullViewRatio = 0;
            }
            if(this._bottomPullView !== null && !this._isBottomPullViewActive)
            {
               this.bottomPullViewRatio = 0;
            }
         }
         if(this._topPullViewRatio > 0)
         {
            if(this._topPullTween !== null)
            {
               this._topPullTween.dispatchEventWith(starling.events.Event.REMOVE_FROM_JUGGLER);
               this._topPullTween = null;
            }
            this.invalidate(INVALIDATION_FLAG_SCROLL);
         }
         if(this._bottomPullViewRatio > 0)
         {
            if(this._bottomPullTween !== null)
            {
               this._bottomPullTween.dispatchEventWith(starling.events.Event.REMOVE_FROM_JUGGLER);
               this._bottomPullTween = null;
            }
            this.invalidate(INVALIDATION_FLAG_SCROLL);
         }
         this.verticalScrollPosition = _loc3_;
      }
      
      protected function throwTo(param1:Number = NaN, param2:Number = NaN, param3:Number = 0.5) : void
      {
         var _loc4_:Boolean = false;
         if(param1 === param1)
         {
            if(this._snapToPages && param1 > this._minHorizontalScrollPosition && param1 < this._maxHorizontalScrollPosition)
            {
               param1 = roundToNearest(param1,this.actualPageWidth);
            }
            if(this._horizontalAutoScrollTween)
            {
               Starling.juggler.remove(this._horizontalAutoScrollTween);
               this._horizontalAutoScrollTween = null;
            }
            if(this._horizontalScrollPosition != param1)
            {
               _loc4_ = true;
               this.revealHorizontalScrollBar();
               this.startScroll();
               if(param3 == 0)
               {
                  this.horizontalScrollPosition = param1;
               }
               else
               {
                  this._startHorizontalScrollPosition = this._horizontalScrollPosition;
                  this._targetHorizontalScrollPosition = param1;
                  this._horizontalAutoScrollTween = new Tween(this,param3,this._throwEase);
                  this._horizontalAutoScrollTween.animate("horizontalScrollPosition",param1);
                  if(this._snapScrollPositionsToPixels)
                  {
                     this._horizontalAutoScrollTween.onUpdate = this.horizontalAutoScrollTween_onUpdate;
                  }
                  this._horizontalAutoScrollTween.onComplete = this.horizontalAutoScrollTween_onComplete;
                  Starling.juggler.add(this._horizontalAutoScrollTween);
                  this.refreshHorizontalAutoScrollTweenEndRatio();
               }
            }
            else
            {
               this.finishScrollingHorizontally();
            }
         }
         if(param2 === param2)
         {
            if(this._snapToPages && param2 > this._minVerticalScrollPosition && param2 < this._maxVerticalScrollPosition)
            {
               param2 = roundToNearest(param2,this.actualPageHeight);
            }
            if(this._verticalAutoScrollTween)
            {
               Starling.juggler.remove(this._verticalAutoScrollTween);
               this._verticalAutoScrollTween = null;
            }
            if(this._verticalScrollPosition != param2)
            {
               _loc4_ = true;
               this.revealVerticalScrollBar();
               this.startScroll();
               if(param3 == 0)
               {
                  this.verticalScrollPosition = param2;
               }
               else
               {
                  this._startVerticalScrollPosition = this._verticalScrollPosition;
                  this._targetVerticalScrollPosition = param2;
                  this._verticalAutoScrollTween = new Tween(this,param3,this._throwEase);
                  this._verticalAutoScrollTween.animate("verticalScrollPosition",param2);
                  if(this._snapScrollPositionsToPixels)
                  {
                     this._verticalAutoScrollTween.onUpdate = this.verticalAutoScrollTween_onUpdate;
                  }
                  this._verticalAutoScrollTween.onComplete = this.verticalAutoScrollTween_onComplete;
                  Starling.juggler.add(this._verticalAutoScrollTween);
                  this.refreshVerticalAutoScrollTweenEndRatio();
               }
            }
            else
            {
               this.finishScrollingVertically();
            }
         }
         if(_loc4_ && param3 == 0)
         {
            this.completeScroll();
         }
      }
      
      protected function throwToPage(param1:int, param2:int, param3:Number = 0.5) : void
      {
         var _loc4_:Number = this._horizontalScrollPosition;
         if(param1 >= this._minHorizontalPageIndex)
         {
            _loc4_ = this.actualPageWidth * param1;
         }
         if(_loc4_ < this._minHorizontalScrollPosition)
         {
            _loc4_ = this._minHorizontalScrollPosition;
         }
         if(_loc4_ > this._maxHorizontalScrollPosition)
         {
            _loc4_ = this._maxHorizontalScrollPosition;
         }
         var _loc5_:Number = this._verticalScrollPosition;
         if(param2 >= this._minVerticalPageIndex)
         {
            _loc5_ = this.actualPageHeight * param2;
         }
         if(_loc5_ < this._minVerticalScrollPosition)
         {
            _loc5_ = this._minVerticalScrollPosition;
         }
         if(_loc5_ > this._maxVerticalScrollPosition)
         {
            _loc5_ = this._maxVerticalScrollPosition;
         }
         if(param1 >= this._minHorizontalPageIndex)
         {
            this._horizontalPageIndex = param1;
         }
         if(param2 >= this._minVerticalPageIndex)
         {
            this._verticalPageIndex = param2;
         }
         this.throwTo(_loc4_,_loc5_,param3);
      }
      
      protected function calculateDynamicThrowDuration(param1:Number) : Number
      {
         return Math.log(MINIMUM_VELOCITY / Math.abs(param1)) / this._logDecelerationRate / 1000;
      }
      
      protected function calculateThrowDistance(param1:Number) : Number
      {
         return (param1 - MINIMUM_VELOCITY) / this._logDecelerationRate;
      }
      
      protected function finishScrollingHorizontally() : void
      {
         var _loc1_:Number = this._minHorizontalScrollPosition;
         if(this._isLeftPullViewActive && this._hasElasticEdges)
         {
            _loc1_ -= this._leftPullView.width;
         }
         var _loc2_:Number = this._maxHorizontalScrollPosition;
         if(this._isRightPullViewActive && this._hasElasticEdges)
         {
            _loc2_ += this._rightPullView.width;
         }
         var _loc3_:Number = NaN;
         if(this._horizontalScrollPosition < _loc1_)
         {
            _loc3_ = _loc1_;
         }
         else if(this._horizontalScrollPosition > _loc2_)
         {
            _loc3_ = _loc2_;
         }
         this._isDraggingHorizontally = false;
         if(_loc3_ !== _loc3_)
         {
            this.completeScroll();
         }
         else if(Math.abs(_loc3_ - this._horizontalScrollPosition) < 1)
         {
            this.horizontalScrollPosition = _loc3_;
            this.completeScroll();
         }
         else
         {
            this.throwTo(_loc3_,NaN,this._elasticSnapDuration);
         }
         this.restoreHorizontalPullViews();
      }
      
      protected function finishScrollingVertically() : void
      {
         var _loc1_:Number = this._minVerticalScrollPosition;
         if(this._isTopPullViewActive && this._hasElasticEdges)
         {
            _loc1_ -= this._topPullView.height;
         }
         var _loc2_:Number = this._maxVerticalScrollPosition;
         if(this._isBottomPullViewActive && this._hasElasticEdges)
         {
            _loc2_ += this._bottomPullView.height;
         }
         var _loc3_:Number = NaN;
         if(this._verticalScrollPosition < _loc1_)
         {
            _loc3_ = _loc1_;
         }
         else if(this._verticalScrollPosition > _loc2_)
         {
            _loc3_ = _loc2_;
         }
         this._isDraggingVertically = false;
         if(_loc3_ !== _loc3_)
         {
            this.completeScroll();
         }
         else if(Math.abs(_loc3_ - this._verticalScrollPosition) < 1)
         {
            this.verticalScrollPosition = _loc3_;
            this.completeScroll();
         }
         else
         {
            this.throwTo(NaN,_loc3_,this._elasticSnapDuration);
         }
         this.restoreVerticalPullViews();
      }
      
      protected function restoreVerticalPullViews() : void
      {
         var _loc1_:Number = NaN;
         if(this._topPullView !== null && this._topPullViewRatio > 0)
         {
            if(this._topPullTween !== null)
            {
               this._topPullTween.dispatchEventWith(starling.events.Event.REMOVE_FROM_JUGGLER);
               this._topPullTween = null;
            }
            if(this._topPullViewDisplayMode === PullViewDisplayMode.DRAG)
            {
               _loc1_ = this._topViewPortOffset + this._topPullView.pivotY * this._topPullView.scaleY;
               if(!this._isTopPullViewActive)
               {
                  _loc1_ -= this._topPullView.height;
               }
               if(this._topPullView.y != _loc1_)
               {
                  this._topPullTween = new Tween(this._topPullView,this._elasticSnapDuration,this._throwEase);
                  this._topPullTween.animate("y",_loc1_);
                  this._topPullTween.onUpdate = this.refreshTopPullViewMask;
                  this._topPullTween.onComplete = this.topPullTween_onComplete;
                  Starling.juggler.add(this._topPullTween);
               }
            }
            else
            {
               this.topPullTween_onComplete();
            }
         }
         if(this._bottomPullView !== null && this._bottomPullViewRatio > 0)
         {
            if(this._bottomPullTween !== null)
            {
               this._bottomPullTween.dispatchEventWith(starling.events.Event.REMOVE_FROM_JUGGLER);
               this._bottomPullTween = null;
            }
            if(this._bottomPullViewDisplayMode === PullViewDisplayMode.DRAG)
            {
               _loc1_ = this.actualHeight - this._bottomViewPortOffset + this._bottomPullView.pivotY * this._bottomPullView.scaleY;
               if(this._isBottomPullViewActive)
               {
                  _loc1_ -= this._bottomPullView.height;
               }
               if(this._bottomPullView.y != _loc1_)
               {
                  this._bottomPullTween = new Tween(this._bottomPullView,this._elasticSnapDuration,this._throwEase);
                  this._bottomPullTween.animate("y",_loc1_);
                  this._bottomPullTween.onUpdate = this.refreshBottomPullViewMask;
                  this._bottomPullTween.onComplete = this.bottomPullTween_onComplete;
                  Starling.juggler.add(this._bottomPullTween);
               }
            }
            else
            {
               this.bottomPullTween_onComplete();
            }
         }
      }
      
      protected function restoreHorizontalPullViews() : void
      {
         var _loc1_:Number = NaN;
         if(this._leftPullView !== null && this._leftPullViewRatio > 0)
         {
            if(this._leftPullTween !== null)
            {
               this._leftPullTween.dispatchEventWith(starling.events.Event.REMOVE_FROM_JUGGLER);
               this._leftPullTween = null;
            }
            if(this._leftPullViewDisplayMode === PullViewDisplayMode.DRAG)
            {
               _loc1_ = this._leftViewPortOffset + this._leftPullView.pivotX * this._leftPullView.scaleX;
               if(!this._isLeftPullViewActive)
               {
                  _loc1_ -= this._leftPullView.width;
               }
               if(this._leftPullView.x != _loc1_)
               {
                  this._leftPullTween = new Tween(this._leftPullView,this._elasticSnapDuration,this._throwEase);
                  this._leftPullTween.animate("x",_loc1_);
                  this._leftPullTween.onUpdate = this.refreshLeftPullViewMask;
                  this._leftPullTween.onComplete = this.leftPullTween_onComplete;
                  Starling.juggler.add(this._leftPullTween);
               }
            }
            else
            {
               this.leftPullTween_onComplete();
            }
         }
         if(this._rightPullView !== null && this._rightPullViewRatio > 0)
         {
            if(this._rightPullTween !== null)
            {
               this._rightPullTween.dispatchEventWith(starling.events.Event.REMOVE_FROM_JUGGLER);
               this._rightPullTween = null;
            }
            if(this._rightPullViewDisplayMode === PullViewDisplayMode.DRAG)
            {
               _loc1_ = this.actualWidth - this._rightViewPortOffset + this._rightPullView.pivotX * this._rightPullView.scaleX;
               if(this._isRightPullViewActive)
               {
                  _loc1_ -= this._rightPullView.width;
               }
               if(this._rightPullView.x != _loc1_)
               {
                  this._rightPullTween = new Tween(this._rightPullView,this._elasticSnapDuration,this._throwEase);
                  this._rightPullTween.animate("x",_loc1_);
                  this._rightPullTween.onUpdate = this.refreshRightPullViewMask;
                  this._rightPullTween.onComplete = this.rightPullTween_onComplete;
                  Starling.juggler.add(this._rightPullTween);
               }
            }
            else
            {
               this.rightPullTween_onComplete();
            }
         }
      }
      
      protected function throwHorizontally(param1:Number) : void
      {
         var _loc4_:Starling = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:int = 0;
         if(this._snapToPages && !this._snapOnComplete)
         {
            _loc4_ = this.stage !== null ? this.stage.starling : Starling.current;
            _loc5_ = 1000 * param1 / (DeviceCapabilities.dpi / _loc4_.contentScaleFactor);
            if(_loc5_ > this._minimumPageThrowVelocity)
            {
               _loc6_ = roundDownToNearest(this._horizontalScrollPosition,this.actualPageWidth);
            }
            else if(_loc5_ < -this._minimumPageThrowVelocity)
            {
               _loc6_ = roundUpToNearest(this._horizontalScrollPosition,this.actualPageWidth);
            }
            else
            {
               _loc7_ = this._maxHorizontalScrollPosition % this.actualPageWidth;
               _loc8_ = this._maxHorizontalScrollPosition - _loc7_;
               if(_loc7_ < this.actualPageWidth && this._horizontalScrollPosition >= _loc8_)
               {
                  _loc9_ = this._horizontalScrollPosition - _loc8_;
                  if(_loc5_ > this._minimumPageThrowVelocity)
                  {
                     _loc6_ = _loc8_ + roundDownToNearest(_loc9_,_loc7_);
                  }
                  else if(_loc5_ < -this._minimumPageThrowVelocity)
                  {
                     _loc6_ = _loc8_ + roundUpToNearest(_loc9_,_loc7_);
                  }
                  else
                  {
                     _loc6_ = _loc8_ + roundToNearest(_loc9_,_loc7_);
                  }
               }
               else
               {
                  _loc6_ = roundToNearest(this._horizontalScrollPosition,this.actualPageWidth);
               }
            }
            if(_loc6_ < this._minHorizontalScrollPosition)
            {
               _loc6_ = this._minHorizontalScrollPosition;
            }
            else if(_loc6_ > this._maxHorizontalScrollPosition)
            {
               _loc6_ = this._maxHorizontalScrollPosition;
            }
            if(_loc6_ == this._maxHorizontalScrollPosition)
            {
               _loc10_ = this._maxHorizontalPageIndex;
            }
            else if(this._minHorizontalScrollPosition == Number.NEGATIVE_INFINITY)
            {
               _loc10_ = Math.round(_loc6_ / this.actualPageWidth);
            }
            else
            {
               _loc10_ = Math.round((_loc6_ - this._minHorizontalScrollPosition) / this.actualPageWidth);
            }
            this.throwToPage(_loc10_,-1,this._pageThrowDuration);
            return;
         }
         var _loc2_:Number = Math.abs(param1);
         if(!this._snapToPages && _loc2_ <= MINIMUM_VELOCITY)
         {
            this.finishScrollingHorizontally();
            return;
         }
         var _loc3_:Number = this._fixedThrowDuration;
         if(!this._useFixedThrowDuration)
         {
            _loc3_ = this.calculateDynamicThrowDuration(param1);
         }
         this.throwTo(this._horizontalScrollPosition + this.calculateThrowDistance(param1),NaN,_loc3_);
      }
      
      protected function throwVertically(param1:Number) : void
      {
         var _loc4_:Starling = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:int = 0;
         if(this._snapToPages && !this._snapOnComplete)
         {
            _loc4_ = this.stage !== null ? this.stage.starling : Starling.current;
            _loc5_ = 1000 * param1 / (DeviceCapabilities.dpi / _loc4_.contentScaleFactor);
            if(_loc5_ > this._minimumPageThrowVelocity)
            {
               _loc6_ = roundDownToNearest(this._verticalScrollPosition,this.actualPageHeight);
            }
            else if(_loc5_ < -this._minimumPageThrowVelocity)
            {
               _loc6_ = roundUpToNearest(this._verticalScrollPosition,this.actualPageHeight);
            }
            else
            {
               _loc7_ = this._maxVerticalScrollPosition % this.actualPageHeight;
               _loc8_ = this._maxVerticalScrollPosition - _loc7_;
               if(_loc7_ < this.actualPageHeight && this._verticalScrollPosition >= _loc8_)
               {
                  _loc9_ = this._verticalScrollPosition - _loc8_;
                  if(_loc5_ > this._minimumPageThrowVelocity)
                  {
                     _loc6_ = _loc8_ + roundDownToNearest(_loc9_,_loc7_);
                  }
                  else if(_loc5_ < -this._minimumPageThrowVelocity)
                  {
                     _loc6_ = _loc8_ + roundUpToNearest(_loc9_,_loc7_);
                  }
                  else
                  {
                     _loc6_ = _loc8_ + roundToNearest(_loc9_,_loc7_);
                  }
               }
               else
               {
                  _loc6_ = roundToNearest(this._verticalScrollPosition,this.actualPageHeight);
               }
            }
            if(_loc6_ < this._minVerticalScrollPosition)
            {
               _loc6_ = this._minVerticalScrollPosition;
            }
            else if(_loc6_ > this._maxVerticalScrollPosition)
            {
               _loc6_ = this._maxVerticalScrollPosition;
            }
            if(_loc6_ == this._maxVerticalScrollPosition)
            {
               _loc10_ = this._maxVerticalPageIndex;
            }
            else if(this._minVerticalScrollPosition == Number.NEGATIVE_INFINITY)
            {
               _loc10_ = Math.round(_loc6_ / this.actualPageHeight);
            }
            else
            {
               _loc10_ = Math.round((_loc6_ - this._minVerticalScrollPosition) / this.actualPageHeight);
            }
            this.throwToPage(-1,_loc10_,this._pageThrowDuration);
            return;
         }
         var _loc2_:Number = Math.abs(param1);
         if(!this._snapToPages && _loc2_ <= MINIMUM_VELOCITY)
         {
            this.finishScrollingVertically();
            return;
         }
         var _loc3_:Number = this._fixedThrowDuration;
         if(!this._useFixedThrowDuration)
         {
            _loc3_ = this.calculateDynamicThrowDuration(param1);
         }
         this.throwTo(NaN,this._verticalScrollPosition + this.calculateThrowDistance(param1),_loc3_);
      }
      
      protected function horizontalAutoScrollTween_onUpdateWithEndRatio() : void
      {
         var _loc1_:Number = this._horizontalAutoScrollTween.transitionFunc(this._horizontalAutoScrollTween.currentTime / this._horizontalAutoScrollTween.totalTime);
         if(_loc1_ >= this._horizontalAutoScrollTweenEndRatio && this._horizontalAutoScrollTween.currentTime < this._horizontalAutoScrollTween.totalTime)
         {
            if(!this._hasElasticEdges)
            {
               if(this._horizontalScrollPosition < this._minHorizontalScrollPosition)
               {
                  this._horizontalScrollPosition = this._minHorizontalScrollPosition;
               }
               else if(this._horizontalScrollPosition > this._maxHorizontalScrollPosition)
               {
                  this._horizontalScrollPosition = this._maxHorizontalScrollPosition;
               }
            }
            Starling.juggler.remove(this._horizontalAutoScrollTween);
            this._horizontalAutoScrollTween = null;
            this.finishScrollingHorizontally();
            return;
         }
         if(this._snapScrollPositionsToPixels)
         {
            this.horizontalAutoScrollTween_onUpdate();
         }
      }
      
      protected function verticalAutoScrollTween_onUpdateWithEndRatio() : void
      {
         var _loc1_:Number = this._verticalAutoScrollTween.transitionFunc(this._verticalAutoScrollTween.currentTime / this._verticalAutoScrollTween.totalTime);
         if(_loc1_ >= this._verticalAutoScrollTweenEndRatio && this._verticalAutoScrollTween.currentTime < this._verticalAutoScrollTween.totalTime)
         {
            if(!this._hasElasticEdges)
            {
               if(this._verticalScrollPosition < this._minVerticalScrollPosition)
               {
                  this._verticalScrollPosition = this._minVerticalScrollPosition;
               }
               else if(this._verticalScrollPosition > this._maxVerticalScrollPosition)
               {
                  this._verticalScrollPosition = this._maxVerticalScrollPosition;
               }
            }
            Starling.juggler.remove(this._verticalAutoScrollTween);
            this._verticalAutoScrollTween = null;
            this.finishScrollingVertically();
            return;
         }
         if(this._snapScrollPositionsToPixels)
         {
            this.verticalAutoScrollTween_onUpdate();
         }
      }
      
      protected function refreshHorizontalAutoScrollTweenEndRatio() : void
      {
         var _loc1_:Number = this._minHorizontalScrollPosition;
         if(this._isLeftPullViewActive && this._hasElasticEdges)
         {
            _loc1_ -= this._leftPullView.width;
         }
         var _loc2_:Number = this._maxHorizontalScrollPosition;
         if(this._isRightPullViewActive && this._hasElasticEdges)
         {
            _loc2_ += this._rightPullView.width;
         }
         var _loc3_:Number = Math.abs(this._targetHorizontalScrollPosition - this._startHorizontalScrollPosition);
         var _loc4_:Number = 0;
         if(this._targetHorizontalScrollPosition > _loc2_)
         {
            _loc4_ = (this._targetHorizontalScrollPosition - _loc2_) / _loc3_;
         }
         else if(this._targetHorizontalScrollPosition < _loc1_)
         {
            _loc4_ = (_loc1_ - this._targetHorizontalScrollPosition) / _loc3_;
         }
         if(_loc4_ > 0)
         {
            if(this._hasElasticEdges)
            {
               this._horizontalAutoScrollTweenEndRatio = 1 - _loc4_ + _loc4_ * this._throwElasticity;
            }
            else
            {
               this._horizontalAutoScrollTweenEndRatio = 1 - _loc4_;
            }
         }
         else
         {
            this._horizontalAutoScrollTweenEndRatio = 1;
         }
         if(this._horizontalAutoScrollTween)
         {
            if(this._horizontalAutoScrollTweenEndRatio < 1)
            {
               this._horizontalAutoScrollTween.onUpdate = this.horizontalAutoScrollTween_onUpdateWithEndRatio;
            }
            else if(this._snapScrollPositionsToPixels)
            {
               this._horizontalAutoScrollTween.onUpdate = this.horizontalAutoScrollTween_onUpdate;
            }
         }
      }
      
      protected function refreshVerticalAutoScrollTweenEndRatio() : void
      {
         var _loc1_:Number = this._minVerticalScrollPosition;
         if(this._isTopPullViewActive && this._hasElasticEdges)
         {
            _loc1_ -= this._topPullView.height;
         }
         var _loc2_:Number = this._maxVerticalScrollPosition;
         if(this._isBottomPullViewActive && this._hasElasticEdges)
         {
            _loc2_ += this._bottomPullView.height;
         }
         var _loc3_:Number = Math.abs(this._targetVerticalScrollPosition - this._startVerticalScrollPosition);
         var _loc4_:Number = 0;
         if(this._targetVerticalScrollPosition > _loc2_)
         {
            _loc4_ = (this._targetVerticalScrollPosition - _loc2_) / _loc3_;
         }
         else if(this._targetVerticalScrollPosition < _loc1_)
         {
            _loc4_ = (_loc1_ - this._targetVerticalScrollPosition) / _loc3_;
         }
         if(_loc4_ > 0)
         {
            if(this._hasElasticEdges)
            {
               this._verticalAutoScrollTweenEndRatio = 1 - _loc4_ + _loc4_ * this._throwElasticity;
            }
            else
            {
               this._verticalAutoScrollTweenEndRatio = 1 - _loc4_;
            }
         }
         else
         {
            this._verticalAutoScrollTweenEndRatio = 1;
         }
         if(this._verticalAutoScrollTween)
         {
            if(this._verticalAutoScrollTweenEndRatio < 1)
            {
               this._verticalAutoScrollTween.onUpdate = this.verticalAutoScrollTween_onUpdateWithEndRatio;
            }
            else if(this._snapScrollPositionsToPixels)
            {
               this._verticalAutoScrollTween.onUpdate = this.verticalAutoScrollTween_onUpdate;
            }
         }
      }
      
      protected function hideHorizontalScrollBar(param1:Number = 0) : void
      {
         if(!this.horizontalScrollBar || this._scrollBarDisplayMode != ScrollBarDisplayMode.FLOAT || Boolean(this._horizontalScrollBarHideTween))
         {
            return;
         }
         if(this.horizontalScrollBar.alpha == 0)
         {
            return;
         }
         if(this._hideScrollBarAnimationDuration == 0 && param1 == 0)
         {
            this.horizontalScrollBar.alpha = 0;
         }
         else
         {
            this._horizontalScrollBarHideTween = new Tween(this.horizontalScrollBar,this._hideScrollBarAnimationDuration,this._hideScrollBarAnimationEase);
            this._horizontalScrollBarHideTween.fadeTo(0);
            this._horizontalScrollBarHideTween.delay = param1;
            this._horizontalScrollBarHideTween.onComplete = this.horizontalScrollBarHideTween_onComplete;
            Starling.juggler.add(this._horizontalScrollBarHideTween);
         }
      }
      
      protected function hideVerticalScrollBar(param1:Number = 0) : void
      {
         if(!this.verticalScrollBar || this._scrollBarDisplayMode != ScrollBarDisplayMode.FLOAT || Boolean(this._verticalScrollBarHideTween))
         {
            return;
         }
         if(this.verticalScrollBar.alpha == 0)
         {
            return;
         }
         if(this._hideScrollBarAnimationDuration == 0 && param1 == 0)
         {
            this.verticalScrollBar.alpha = 0;
         }
         else
         {
            this._verticalScrollBarHideTween = new Tween(this.verticalScrollBar,this._hideScrollBarAnimationDuration,this._hideScrollBarAnimationEase);
            this._verticalScrollBarHideTween.fadeTo(0);
            this._verticalScrollBarHideTween.delay = param1;
            this._verticalScrollBarHideTween.onComplete = this.verticalScrollBarHideTween_onComplete;
            Starling.juggler.add(this._verticalScrollBarHideTween);
         }
      }
      
      protected function revealHorizontalScrollBar() : void
      {
         if(!this.horizontalScrollBar || this._scrollBarDisplayMode != ScrollBarDisplayMode.FLOAT)
         {
            return;
         }
         if(this._horizontalScrollBarHideTween)
         {
            Starling.juggler.remove(this._horizontalScrollBarHideTween);
            this._horizontalScrollBarHideTween = null;
         }
         this.horizontalScrollBar.alpha = 1;
      }
      
      protected function revealVerticalScrollBar() : void
      {
         if(!this.verticalScrollBar || this._scrollBarDisplayMode != ScrollBarDisplayMode.FLOAT)
         {
            return;
         }
         if(this._verticalScrollBarHideTween)
         {
            Starling.juggler.remove(this._verticalScrollBarHideTween);
            this._verticalScrollBarHideTween = null;
         }
         this.verticalScrollBar.alpha = 1;
      }
      
      protected function startScroll() : void
      {
         if(this._isScrolling)
         {
            return;
         }
         this._isScrolling = true;
         this.dispatchEventWith(FeathersEventType.SCROLL_START);
      }
      
      protected function completeScroll() : void
      {
         if(Boolean(!this._isScrolling || this._verticalAutoScrollTween || this._horizontalAutoScrollTween || this._isDraggingHorizontally || this._isDraggingVertically) || Boolean(this._horizontalScrollBarIsScrolling) || this._verticalScrollBarIsScrolling)
         {
            return;
         }
         this._isScrolling = false;
         this.hideHorizontalScrollBar();
         this.hideVerticalScrollBar();
         this.validate();
         this.dispatchEventWith(FeathersEventType.SCROLL_COMPLETE);
      }
      
      protected function handlePendingScroll() : void
      {
         if(this.pendingHorizontalScrollPosition === this.pendingHorizontalScrollPosition || this.pendingVerticalScrollPosition === this.pendingVerticalScrollPosition)
         {
            this.throwTo(this.pendingHorizontalScrollPosition,this.pendingVerticalScrollPosition,this.pendingScrollDuration);
            this.pendingHorizontalScrollPosition = NaN;
            this.pendingVerticalScrollPosition = NaN;
         }
         if(this.hasPendingHorizontalPageIndex && this.hasPendingVerticalPageIndex)
         {
            this.throwToPage(this.pendingHorizontalPageIndex,this.pendingVerticalPageIndex,this.pendingScrollDuration);
         }
         else if(this.hasPendingHorizontalPageIndex)
         {
            this.throwToPage(this.pendingHorizontalPageIndex,this._verticalPageIndex,this.pendingScrollDuration);
         }
         else if(this.hasPendingVerticalPageIndex)
         {
            this.throwToPage(this._horizontalPageIndex,this.pendingVerticalPageIndex,this.pendingScrollDuration);
         }
         this.hasPendingHorizontalPageIndex = false;
         this.hasPendingVerticalPageIndex = false;
      }
      
      protected function handlePendingRevealScrollBars() : void
      {
         if(!this.isScrollBarRevealPending)
         {
            return;
         }
         this.isScrollBarRevealPending = false;
         if(this._scrollBarDisplayMode != ScrollBarDisplayMode.FLOAT)
         {
            return;
         }
         this.revealHorizontalScrollBar();
         this.revealVerticalScrollBar();
         this.hideHorizontalScrollBar(this._revealScrollBarsDuration);
         this.hideVerticalScrollBar(this._revealScrollBarsDuration);
      }
      
      protected function handlePendingPullView() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         if(this._isTopPullViewPending)
         {
            this._isTopPullViewPending = false;
            if(this._isTopPullViewActive)
            {
               if(this._topPullTween !== null)
               {
                  this._topPullTween.dispatchEventWith(starling.events.Event.REMOVE_FROM_JUGGLER);
                  this._topPullTween = null;
               }
               if(this._topPullView is IValidating)
               {
                  IValidating(this._topPullView).validate();
               }
               this._topPullView.visible = true;
               this._topPullViewRatio = 1;
               if(this._topPullViewDisplayMode === PullViewDisplayMode.DRAG)
               {
                  _loc1_ = this._topViewPortOffset + this._topPullView.pivotY * this._topPullView.scaleY;
                  if(this.isCreated)
                  {
                     this._topPullView.y = _loc1_ - this._topPullView.height;
                     this._topPullTween = new Tween(this._topPullView,this._elasticSnapDuration,this._throwEase);
                     this._topPullTween.animate("y",_loc1_);
                     this._topPullTween.onUpdate = this.refreshTopPullViewMask;
                     this._topPullTween.onComplete = this.topPullTween_onComplete;
                     Starling.juggler.add(this._topPullTween);
                  }
                  else
                  {
                     this._topPullView.y = _loc1_;
                  }
               }
            }
            else if(this._isScrolling)
            {
               this.restoreVerticalPullViews();
            }
            else
            {
               this.finishScrollingVertically();
            }
         }
         if(this._isRightPullViewPending)
         {
            this._isRightPullViewPending = false;
            if(this._isRightPullViewActive)
            {
               if(this._rightPullTween !== null)
               {
                  this._rightPullTween.dispatchEventWith(starling.events.Event.REMOVE_FROM_JUGGLER);
                  this._rightPullTween = null;
               }
               if(this._rightPullView is IValidating)
               {
                  IValidating(this._rightPullView).validate();
               }
               this._rightPullView.visible = true;
               this._rightPullViewRatio = 1;
               if(this._rightPullViewDisplayMode === PullViewDisplayMode.DRAG)
               {
                  _loc2_ = this.actualWidth - this._rightViewPortOffset + this._rightPullView.pivotX * this._rightPullView.scaleX - this._rightPullView.width;
                  if(this.isCreated)
                  {
                     this._rightPullView.x = _loc2_ + this._rightPullView.width;
                     this._rightPullTween = new Tween(this._rightPullView,this._elasticSnapDuration,this._throwEase);
                     this._rightPullTween.animate("x",_loc2_);
                     this._rightPullTween.onUpdate = this.refreshRightPullViewMask;
                     this._rightPullTween.onComplete = this.rightPullTween_onComplete;
                     Starling.juggler.add(this._rightPullTween);
                  }
                  else
                  {
                     this._rightPullView.x = _loc2_;
                  }
               }
            }
            else if(this._isScrolling)
            {
               this.restoreHorizontalPullViews();
            }
            else
            {
               this.finishScrollingHorizontally();
            }
         }
         if(this._isBottomPullViewPending)
         {
            this._isBottomPullViewPending = false;
            if(this._isBottomPullViewActive)
            {
               if(this._bottomPullTween !== null)
               {
                  this._bottomPullTween.dispatchEventWith(starling.events.Event.REMOVE_FROM_JUGGLER);
                  this._bottomPullTween = null;
               }
               if(this._bottomPullView is IValidating)
               {
                  IValidating(this._bottomPullView).validate();
               }
               this._bottomPullView.visible = true;
               this._bottomPullViewRatio = 1;
               if(this._bottomPullViewDisplayMode === PullViewDisplayMode.DRAG)
               {
                  _loc1_ = this.actualHeight - this._bottomViewPortOffset + this._bottomPullView.pivotY * this._bottomPullView.scaleY - this._bottomPullView.height;
                  if(this.isCreated)
                  {
                     this._bottomPullView.y = _loc1_ + this._bottomPullView.height;
                     this._bottomPullTween = new Tween(this._bottomPullView,this._elasticSnapDuration,this._throwEase);
                     this._bottomPullTween.animate("y",_loc1_);
                     this._bottomPullTween.onUpdate = this.refreshBottomPullViewMask;
                     this._bottomPullTween.onComplete = this.bottomPullTween_onComplete;
                     Starling.juggler.add(this._bottomPullTween);
                  }
                  else
                  {
                     this._bottomPullView.y = _loc1_;
                  }
               }
            }
            else if(this._isScrolling)
            {
               this.restoreVerticalPullViews();
            }
            else
            {
               this.finishScrollingVertically();
            }
         }
         if(this._isLeftPullViewPending)
         {
            this._isLeftPullViewPending = false;
            if(this._isLeftPullViewActive)
            {
               if(this._leftPullTween !== null)
               {
                  this._leftPullTween.dispatchEventWith(starling.events.Event.REMOVE_FROM_JUGGLER);
                  this._leftPullTween = null;
               }
               if(this._leftPullView is IValidating)
               {
                  IValidating(this._leftPullView).validate();
               }
               this._leftPullView.visible = true;
               this._leftPullViewRatio = 1;
               if(this._leftPullViewDisplayMode === PullViewDisplayMode.DRAG)
               {
                  _loc2_ = this._leftViewPortOffset + this._leftPullView.pivotX * this._leftPullView.scaleX;
                  if(this.isCreated)
                  {
                     this._leftPullView.x = _loc2_ - this._leftPullView.width;
                     this._leftPullTween = new Tween(this._leftPullView,this._elasticSnapDuration,this._throwEase);
                     this._leftPullTween.animate("x",_loc2_);
                     this._leftPullTween.onUpdate = this.refreshLeftPullViewMask;
                     this._leftPullTween.onComplete = this.leftPullTween_onComplete;
                     Starling.juggler.add(this._leftPullTween);
                  }
                  else
                  {
                     this._leftPullView.x = _loc2_;
                  }
               }
            }
            else if(this._isScrolling)
            {
               this.restoreHorizontalPullViews();
            }
            else
            {
               this.finishScrollingHorizontally();
            }
         }
      }
      
      protected function checkForDrag() : void
      {
         var _loc4_:ExclusiveTouch = null;
         if(this._isScrollingStopped)
         {
            return;
         }
         var _loc1_:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         var _loc2_:Number = (this._currentTouchX - this._startTouchX) / (DeviceCapabilities.dpi / _loc1_.contentScaleFactor);
         var _loc3_:Number = (this._currentTouchY - this._startTouchY) / (DeviceCapabilities.dpi / _loc1_.contentScaleFactor);
         if(!this._isDraggingHorizontally && (this._horizontalScrollPolicy === ScrollPolicy.ON || this._horizontalScrollPolicy === ScrollPolicy.AUTO && this._minHorizontalScrollPosition != this._maxHorizontalScrollPosition || this._leftPullView !== null && (this._currentTouchX > this._startTouchX || this._horizontalScrollPosition < this._minHorizontalScrollPosition) || this._rightPullView !== null && (this._currentTouchX < this._startTouchX || this._horizontalScrollPosition > this._minHorizontalScrollPosition)) && (_loc2_ <= -this._minimumDragDistance && (this._hasElasticEdges || this._horizontalScrollPosition < this._maxHorizontalScrollPosition || this._rightPullView !== null) || _loc2_ >= this._minimumDragDistance && (this._hasElasticEdges || this._horizontalScrollPosition > this._minHorizontalScrollPosition || this._leftPullView !== null)))
         {
            if(this.horizontalScrollBar)
            {
               this.revealHorizontalScrollBar();
            }
            this._startTouchX = this._currentTouchX;
            this._startHorizontalScrollPosition = this._horizontalScrollPosition;
            this._isDraggingHorizontally = true;
            if(!this._isDraggingVertically)
            {
               this.dispatchEventWith(FeathersEventType.BEGIN_INTERACTION);
               _loc4_ = ExclusiveTouch.forStage(this.stage);
               _loc4_.removeEventListener(starling.events.Event.CHANGE,this.exclusiveTouch_changeHandler);
               _loc4_.claimTouch(this._touchPointID,this);
               this.startScroll();
            }
         }
         if(!this._isDraggingVertically && (this._verticalScrollPolicy == ScrollPolicy.ON || this._verticalScrollPolicy == ScrollPolicy.AUTO && this._minVerticalScrollPosition != this._maxVerticalScrollPosition || this._topPullView !== null && (this._currentTouchY > this._startTouchY || this._verticalScrollPosition < this._minVerticalScrollPosition) || this._bottomPullView !== null && (this._currentTouchY < this._startTouchY || this._verticalScrollPosition > this._minVerticalScrollPosition)) && (_loc3_ <= -this._minimumDragDistance && (this._hasElasticEdges || this._verticalScrollPosition < this._maxVerticalScrollPosition || this._bottomPullView !== null) || _loc3_ >= this._minimumDragDistance && (this._hasElasticEdges || this._verticalScrollPosition > this._minVerticalScrollPosition || this._topPullView !== null)))
         {
            if(this.verticalScrollBar)
            {
               this.revealVerticalScrollBar();
            }
            this._startTouchY = this._currentTouchY;
            this._startVerticalScrollPosition = this._verticalScrollPosition;
            this._isDraggingVertically = true;
            if(!this._isDraggingHorizontally)
            {
               _loc4_ = ExclusiveTouch.forStage(this.stage);
               _loc4_.removeEventListener(starling.events.Event.CHANGE,this.exclusiveTouch_changeHandler);
               _loc4_.claimTouch(this._touchPointID,this);
               this.dispatchEventWith(FeathersEventType.BEGIN_INTERACTION);
               this.startScroll();
            }
         }
         if(this._isDraggingHorizontally && !this._horizontalAutoScrollTween)
         {
            this.updateHorizontalScrollFromTouchPosition(this._currentTouchX);
         }
         if(this._isDraggingVertically && !this._verticalAutoScrollTween)
         {
            this.updateVerticalScrollFromTouchPosition(this._currentTouchY);
         }
      }
      
      protected function saveVelocity() : void
      {
         this._pendingVelocityChange = false;
         if(this._isScrollingStopped)
         {
            return;
         }
         var _loc1_:int = getTimer();
         var _loc2_:int = _loc1_ - this._previousTouchTime;
         if(_loc2_ > 0)
         {
            this._previousVelocityX[this._previousVelocityX.length] = this._velocityX;
            if(this._previousVelocityX.length > MAXIMUM_SAVED_VELOCITY_COUNT)
            {
               this._previousVelocityX.shift();
            }
            this._previousVelocityY[this._previousVelocityY.length] = this._velocityY;
            if(this._previousVelocityY.length > MAXIMUM_SAVED_VELOCITY_COUNT)
            {
               this._previousVelocityY.shift();
            }
            this._velocityX = (this._currentTouchX - this._previousTouchX) / _loc2_;
            this._velocityY = (this._currentTouchY - this._previousTouchY) / _loc2_;
            this._previousTouchTime = _loc1_;
            this._previousTouchX = this._currentTouchX;
            this._previousTouchY = this._currentTouchY;
         }
      }
      
      protected function viewPort_resizeHandler(param1:starling.events.Event) : void
      {
         if(this.ignoreViewPortResizing || this._viewPort.width == this._lastViewPortWidth && this._viewPort.height == this._lastViewPortHeight)
         {
            return;
         }
         this._lastViewPortWidth = this._viewPort.width;
         this._lastViewPortHeight = this._viewPort.height;
         if(this._isValidating)
         {
            this._hasViewPortBoundsChanged = true;
         }
         else
         {
            this.invalidate(INVALIDATION_FLAG_SIZE);
         }
      }
      
      protected function childProperties_onChange(param1:PropertyProxy, param2:String) : void
      {
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      protected function verticalScrollBar_changeHandler(param1:starling.events.Event) : void
      {
         this.verticalScrollPosition = this.verticalScrollBar.value;
      }
      
      protected function horizontalScrollBar_changeHandler(param1:starling.events.Event) : void
      {
         this.horizontalScrollPosition = this.horizontalScrollBar.value;
      }
      
      protected function horizontalScrollBar_beginInteractionHandler(param1:starling.events.Event) : void
      {
         if(this._horizontalAutoScrollTween)
         {
            Starling.juggler.remove(this._horizontalAutoScrollTween);
            this._horizontalAutoScrollTween = null;
         }
         this._isDraggingHorizontally = false;
         this._horizontalScrollBarIsScrolling = true;
         this.dispatchEventWith(FeathersEventType.BEGIN_INTERACTION);
         if(!this._isScrolling)
         {
            this.startScroll();
         }
      }
      
      protected function horizontalScrollBar_endInteractionHandler(param1:starling.events.Event) : void
      {
         this._horizontalScrollBarIsScrolling = false;
         this.dispatchEventWith(FeathersEventType.END_INTERACTION);
         this.completeScroll();
      }
      
      protected function verticalScrollBar_beginInteractionHandler(param1:starling.events.Event) : void
      {
         if(this._verticalAutoScrollTween)
         {
            Starling.juggler.remove(this._verticalAutoScrollTween);
            this._verticalAutoScrollTween = null;
         }
         this._isDraggingVertically = false;
         this._verticalScrollBarIsScrolling = true;
         this.dispatchEventWith(FeathersEventType.BEGIN_INTERACTION);
         if(!this._isScrolling)
         {
            this.startScroll();
         }
      }
      
      protected function verticalScrollBar_endInteractionHandler(param1:starling.events.Event) : void
      {
         this._verticalScrollBarIsScrolling = false;
         this.dispatchEventWith(FeathersEventType.END_INTERACTION);
         this.completeScroll();
      }
      
      protected function horizontalAutoScrollTween_onUpdate() : void
      {
         var _loc1_:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         var _loc2_:Number = 1 / _loc1_.contentScaleFactor;
         var _loc3_:Number = Math.round((this._leftViewPortOffset - this._horizontalScrollPosition) / _loc2_) * _loc2_;
         var _loc4_:Number = Math.round((this._leftViewPortOffset - this._targetHorizontalScrollPosition) / _loc2_) * _loc2_;
         if(_loc3_ == _loc4_)
         {
            this._horizontalAutoScrollTween.advanceTime(this._horizontalAutoScrollTween.totalTime);
         }
      }
      
      protected function horizontalAutoScrollTween_onComplete() : void
      {
         if(this._horizontalAutoScrollTween !== null)
         {
            this._horizontalAutoScrollTween.onUpdate = null;
            this._horizontalAutoScrollTween.onComplete = null;
            this._horizontalAutoScrollTween = null;
         }
         this.invalidate(INVALIDATION_FLAG_SCROLL);
         this.finishScrollingHorizontally();
      }
      
      protected function verticalAutoScrollTween_onUpdate() : void
      {
         var _loc1_:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         var _loc2_:Number = 1 / _loc1_.contentScaleFactor;
         var _loc3_:Number = Math.round((this._topViewPortOffset - this._verticalScrollPosition) / _loc2_) * _loc2_;
         var _loc4_:Number = Math.round((this._topViewPortOffset - this._targetVerticalScrollPosition) / _loc2_) * _loc2_;
         if(_loc3_ == _loc4_)
         {
            this._verticalAutoScrollTween.advanceTime(this._verticalAutoScrollTween.totalTime);
         }
      }
      
      protected function verticalAutoScrollTween_onComplete() : void
      {
         if(this._verticalAutoScrollTween !== null)
         {
            this._verticalAutoScrollTween.onUpdate = null;
            this._verticalAutoScrollTween.onComplete = null;
            this._verticalAutoScrollTween = null;
         }
         this.invalidate(INVALIDATION_FLAG_SCROLL);
         this.finishScrollingVertically();
      }
      
      protected function topPullTween_onComplete() : void
      {
         this._topPullTween = null;
         if(this._isTopPullViewActive)
         {
            this._topPullViewRatio = 1;
         }
         else
         {
            this._topPullViewRatio = 0;
         }
         this.invalidate(INVALIDATION_FLAG_SCROLL);
      }
      
      protected function rightPullTween_onComplete() : void
      {
         this._rightPullTween = null;
         if(this._isRightPullViewActive)
         {
            this._rightPullViewRatio = 1;
         }
         else
         {
            this._rightPullViewRatio = 0;
         }
         this.invalidate(INVALIDATION_FLAG_SCROLL);
      }
      
      protected function bottomPullTween_onComplete() : void
      {
         this._bottomPullTween = null;
         if(this._isBottomPullViewActive)
         {
            this._bottomPullViewRatio = 1;
         }
         else
         {
            this._bottomPullViewRatio = 0;
         }
         this.invalidate(INVALIDATION_FLAG_SCROLL);
      }
      
      protected function leftPullTween_onComplete() : void
      {
         this._leftPullTween = null;
         if(this._isLeftPullViewActive)
         {
            this._leftPullViewRatio = 1;
         }
         else
         {
            this._leftPullViewRatio = 0;
         }
         this.invalidate(INVALIDATION_FLAG_SCROLL);
      }
      
      protected function horizontalScrollBarHideTween_onComplete() : void
      {
         this._horizontalScrollBarHideTween = null;
      }
      
      protected function verticalScrollBarHideTween_onComplete() : void
      {
         this._verticalScrollBarHideTween = null;
      }
      
      protected function scroller_touchHandler(param1:TouchEvent) : void
      {
         if(!this._isEnabled || this.stage === null)
         {
            this._touchPointID = -1;
            return;
         }
         if(this._touchPointID != -1)
         {
            return;
         }
         var _loc2_:Touch = param1.getTouch(this,TouchPhase.BEGAN);
         if(_loc2_ === null)
         {
            return;
         }
         if(this._interactionMode == ScrollInteractionMode.TOUCH_AND_SCROLL_BARS && (param1.interactsWith(DisplayObject(this.horizontalScrollBar)) || param1.interactsWith(DisplayObject(this.verticalScrollBar))))
         {
            return;
         }
         var _loc3_:Point = _loc2_.getLocation(this,Pool.getPoint());
         var _loc4_:Number = _loc3_.x;
         var _loc5_:Number = _loc3_.y;
         Pool.putPoint(_loc3_);
         if(_loc4_ < this._leftViewPortOffset || _loc5_ < this._topViewPortOffset || _loc4_ >= this.actualWidth - this._rightViewPortOffset || _loc5_ >= this.actualHeight - this._bottomViewPortOffset)
         {
            return;
         }
         var _loc6_:ExclusiveTouch = ExclusiveTouch.forStage(this.stage);
         if(_loc6_.getClaim(_loc2_.id))
         {
            return;
         }
         if(this._horizontalAutoScrollTween !== null && this._horizontalScrollPolicy !== ScrollPolicy.OFF)
         {
            Starling.juggler.remove(this._horizontalAutoScrollTween);
            this._horizontalAutoScrollTween = null;
         }
         if(this._verticalAutoScrollTween !== null && this._verticalScrollPolicy !== ScrollPolicy.OFF)
         {
            Starling.juggler.remove(this._verticalAutoScrollTween);
            this._verticalAutoScrollTween = null;
         }
         this._touchPointID = _loc2_.id;
         this._velocityX = 0;
         this._velocityY = 0;
         this._previousVelocityX.length = 0;
         this._previousVelocityY.length = 0;
         this._previousTouchTime = getTimer();
         this._previousTouchX = this._startTouchX = this._currentTouchX = _loc4_;
         this._previousTouchY = this._startTouchY = this._currentTouchY = _loc5_;
         this._startHorizontalScrollPosition = this._horizontalScrollPosition;
         this._startVerticalScrollPosition = this._verticalScrollPosition;
         this._isScrollingStopped = false;
         if(!this._isScrolling || !this._snapToPages)
         {
            this._isDraggingVertically = false;
            this._isDraggingHorizontally = false;
         }
         if(this._isScrolling)
         {
            this.completeScroll();
         }
         this.addEventListener(starling.events.Event.ENTER_FRAME,this.scroller_enterFrameHandler);
         this.stage.addEventListener(TouchEvent.TOUCH,this.stage_touchHandler);
         _loc6_.addEventListener(starling.events.Event.CHANGE,this.exclusiveTouch_changeHandler);
      }
      
      protected function scroller_enterFrameHandler(param1:starling.events.Event) : void
      {
         this.saveVelocity();
      }
      
      protected function stage_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         var _loc3_:Point = null;
         var _loc4_:Boolean = false;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Boolean = false;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:int = 0;
         var _loc12_:Number = NaN;
         var _loc13_:int = 0;
         var _loc14_:Number = NaN;
         if(this._touchPointID < 0)
         {
            return;
         }
         _loc2_ = param1.getTouch(this.stage,null,this._touchPointID);
         if(_loc2_ === null)
         {
            return;
         }
         if(_loc2_.phase === TouchPhase.MOVED)
         {
            _loc3_ = _loc2_.getLocation(this,Pool.getPoint());
            this._currentTouchX = _loc3_.x;
            this._currentTouchY = _loc3_.y;
            Pool.putPoint(_loc3_);
            this.checkForDrag();
            this._pendingVelocityChange = true;
         }
         else if(_loc2_.phase === TouchPhase.ENDED)
         {
            if(this._pendingVelocityChange)
            {
               this.saveVelocity();
            }
            if(!this._isDraggingHorizontally && !this._isDraggingVertically)
            {
               ExclusiveTouch.forStage(this.stage).removeEventListener(starling.events.Event.CHANGE,this.exclusiveTouch_changeHandler);
            }
            this.removeEventListener(starling.events.Event.ENTER_FRAME,this.scroller_enterFrameHandler);
            this.stage.removeEventListener(TouchEvent.TOUCH,this.stage_touchHandler);
            this._touchPointID = -1;
            this.dispatchEventWith(FeathersEventType.END_INTERACTION);
            if(!this._isTopPullViewActive && this._isDraggingVertically && this._topPullView !== null && this._topPullViewRatio >= 1)
            {
               this._isTopPullViewActive = true;
               this._topPullView.dispatchEventWith(starling.events.Event.UPDATE);
               this.dispatchEventWith(starling.events.Event.UPDATE,false,this._topPullView);
            }
            if(!this._isRightPullViewActive && this._isDraggingHorizontally && this._rightPullView !== null && this._rightPullViewRatio >= 1)
            {
               this._isRightPullViewActive = true;
               this._rightPullView.dispatchEventWith(starling.events.Event.UPDATE);
               this.dispatchEventWith(starling.events.Event.UPDATE,false,this._rightPullView);
            }
            if(!this._isBottomPullViewActive && this._isDraggingVertically && this._bottomPullView !== null && this._bottomPullViewRatio >= 1)
            {
               this._isBottomPullViewActive = true;
               this._bottomPullView.dispatchEventWith(starling.events.Event.UPDATE);
               this.dispatchEventWith(starling.events.Event.UPDATE,false,this._bottomPullView);
            }
            if(!this._isLeftPullViewActive && this._isDraggingHorizontally && this._leftPullView !== null && this._leftPullViewRatio >= 1)
            {
               this._isLeftPullViewActive = true;
               this._leftPullView.dispatchEventWith(starling.events.Event.UPDATE);
               this.dispatchEventWith(starling.events.Event.UPDATE,false,this._leftPullView);
            }
            _loc4_ = false;
            _loc5_ = this._minHorizontalScrollPosition;
            if(this._isLeftPullViewActive && this._hasElasticEdges)
            {
               _loc5_ -= this._leftPullView.width;
            }
            _loc6_ = this._maxHorizontalScrollPosition;
            if(this._isRightPullViewActive && this._hasElasticEdges)
            {
               _loc6_ += this._rightPullView.width;
            }
            if(this._horizontalScrollPosition < _loc5_ || this._horizontalScrollPosition > _loc6_)
            {
               _loc4_ = true;
               this.finishScrollingHorizontally();
            }
            _loc7_ = false;
            _loc8_ = this._minVerticalScrollPosition;
            if(this._isTopPullViewActive && this._hasElasticEdges)
            {
               _loc8_ -= this._topPullView.height;
            }
            _loc9_ = this._maxVerticalScrollPosition;
            if(this._isBottomPullViewActive && this._hasElasticEdges)
            {
               _loc9_ += this._bottomPullView.height;
            }
            if(this._verticalScrollPosition < _loc8_ || this._verticalScrollPosition > _loc9_)
            {
               _loc7_ = true;
               this.finishScrollingVertically();
            }
            if(_loc4_ && _loc7_)
            {
               return;
            }
            if(!_loc4_)
            {
               if(this._isDraggingHorizontally)
               {
                  _loc10_ = this._velocityX * CURRENT_VELOCITY_WEIGHT;
                  _loc11_ = int(this._previousVelocityX.length);
                  _loc12_ = CURRENT_VELOCITY_WEIGHT;
                  _loc13_ = 0;
                  while(_loc13_ < _loc11_)
                  {
                     _loc14_ = VELOCITY_WEIGHTS[_loc13_];
                     _loc10_ += this._previousVelocityX.shift() * _loc14_;
                     _loc12_ += _loc14_;
                     _loc13_++;
                  }
                  this.throwHorizontally(_loc10_ / _loc12_);
               }
               else
               {
                  this.hideHorizontalScrollBar();
               }
            }
            if(!_loc7_)
            {
               if(this._isDraggingVertically)
               {
                  _loc10_ = this._velocityY * CURRENT_VELOCITY_WEIGHT;
                  _loc11_ = int(this._previousVelocityY.length);
                  _loc12_ = CURRENT_VELOCITY_WEIGHT;
                  _loc13_ = 0;
                  while(_loc13_ < _loc11_)
                  {
                     _loc14_ = VELOCITY_WEIGHTS[_loc13_];
                     _loc10_ += this._previousVelocityY.shift() * _loc14_;
                     _loc12_ += _loc14_;
                     _loc13_++;
                  }
                  this.throwVertically(_loc10_ / _loc12_);
               }
               else
               {
                  this.hideVerticalScrollBar();
               }
            }
         }
      }
      
      protected function exclusiveTouch_changeHandler(param1:starling.events.Event, param2:int) : void
      {
         var _loc3_:ExclusiveTouch = null;
         if(this._touchPointID < 0 || this._touchPointID != param2 || this._isDraggingHorizontally || this._isDraggingVertically)
         {
            return;
         }
         _loc3_ = ExclusiveTouch.forStage(this.stage);
         if(_loc3_.getClaim(param2) == this)
         {
            return;
         }
         this._touchPointID = -1;
         this.removeEventListener(starling.events.Event.ENTER_FRAME,this.scroller_enterFrameHandler);
         this.stage.removeEventListener(TouchEvent.TOUCH,this.stage_touchHandler);
         _loc3_.removeEventListener(starling.events.Event.CHANGE,this.exclusiveTouch_changeHandler);
         this.dispatchEventWith(FeathersEventType.END_INTERACTION);
      }
      
      protected function nativeStage_mouseWheelHandler(param1:MouseEvent) : void
      {
         var _loc2_:Starling = null;
         var _loc3_:Number = NaN;
         var _loc4_:flash.geom.Rectangle = null;
         var _loc5_:Number = NaN;
         var _loc6_:Point = null;
         var _loc7_:Boolean = false;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         if(!this._isEnabled)
         {
            this._touchPointID = -1;
            return;
         }
         if(this._verticalMouseWheelScrollDirection === Direction.VERTICAL && (this._maxVerticalScrollPosition == this._minVerticalScrollPosition || this._verticalScrollPolicy == ScrollPolicy.OFF) || this._verticalMouseWheelScrollDirection === Direction.HORIZONTAL && (this._maxHorizontalScrollPosition == this._minHorizontalScrollPosition || this._horizontalScrollPolicy == ScrollPolicy.OFF))
         {
            return;
         }
         _loc2_ = this.stage !== null ? this.stage.starling : Starling.current;
         _loc3_ = 1;
         if(_loc2_.supportHighResolutions)
         {
            _loc3_ = _loc2_.nativeStage.contentsScaleFactor;
         }
         _loc4_ = _loc2_.viewPort;
         _loc5_ = _loc3_ / _loc2_.contentScaleFactor;
         _loc6_ = Pool.getPoint((param1.stageX - _loc4_.x) * _loc5_,(param1.stageY - _loc4_.y) * _loc5_);
         _loc7_ = this.stage !== null && this.contains(this.stage.hitTest(_loc6_));
         if(!_loc7_)
         {
            Pool.putPoint(_loc6_);
         }
         else
         {
            this.globalToLocal(_loc6_,_loc6_);
            _loc8_ = _loc6_.x;
            _loc9_ = _loc6_.y;
            Pool.putPoint(_loc6_);
            if(_loc8_ < this._leftViewPortOffset || _loc9_ < this._topViewPortOffset || _loc8_ >= this.actualWidth - this._rightViewPortOffset || _loc9_ >= this.actualHeight - this._bottomViewPortOffset)
            {
               return;
            }
            _loc10_ = this._horizontalScrollPosition;
            _loc11_ = this._verticalScrollPosition;
            _loc12_ = this._verticalMouseWheelScrollStep;
            if(this._verticalMouseWheelScrollDirection == Direction.HORIZONTAL)
            {
               if(_loc12_ !== _loc12_)
               {
                  _loc12_ = this.actualHorizontalScrollStep;
               }
               _loc10_ -= param1.delta * _loc12_;
               if(_loc10_ < this._minHorizontalScrollPosition)
               {
                  _loc10_ = this._minHorizontalScrollPosition;
               }
               else if(_loc10_ > this._maxHorizontalScrollPosition)
               {
                  _loc10_ = this._maxHorizontalScrollPosition;
               }
            }
            else
            {
               if(_loc12_ !== _loc12_)
               {
                  _loc12_ = this.actualVerticalScrollStep;
               }
               _loc11_ -= param1.delta * _loc12_;
               if(_loc11_ < this._minVerticalScrollPosition)
               {
                  _loc11_ = this._minVerticalScrollPosition;
               }
               else if(_loc11_ > this._maxVerticalScrollPosition)
               {
                  _loc11_ = this._maxVerticalScrollPosition;
               }
            }
            this.throwTo(_loc10_,_loc11_,this._mouseWheelScrollDuration);
         }
      }
      
      protected function nativeStage_orientationChangeHandler(param1:flash.events.Event) : void
      {
         if(this._touchPointID < 0)
         {
            return;
         }
         this._startTouchX = this._previousTouchX = this._currentTouchX;
         this._startTouchY = this._previousTouchY = this._currentTouchY;
         this._startHorizontalScrollPosition = this._horizontalScrollPosition;
         this._startVerticalScrollPosition = this._verticalScrollPosition;
      }
      
      protected function horizontalScrollBar_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:Touch = null;
         var _loc4_:Point = null;
         var _loc5_:Boolean = false;
         if(!this._isEnabled)
         {
            this._horizontalScrollBarTouchPointID = -1;
            return;
         }
         _loc2_ = DisplayObject(param1.currentTarget);
         if(this._horizontalScrollBarTouchPointID >= 0)
         {
            _loc3_ = param1.getTouch(_loc2_,TouchPhase.ENDED,this._horizontalScrollBarTouchPointID);
            if(!_loc3_)
            {
               return;
            }
            this._horizontalScrollBarTouchPointID = -1;
            _loc4_ = _loc3_.getLocation(_loc2_,Pool.getPoint());
            _loc5_ = this.horizontalScrollBar.hitTest(_loc4_) !== null;
            Pool.putPoint(_loc4_);
            if(!_loc5_)
            {
               this.hideHorizontalScrollBar();
            }
         }
         else
         {
            _loc3_ = param1.getTouch(_loc2_,TouchPhase.BEGAN);
            if(_loc3_)
            {
               this._horizontalScrollBarTouchPointID = _loc3_.id;
               return;
            }
            if(this._isScrolling)
            {
               return;
            }
            _loc3_ = param1.getTouch(_loc2_,TouchPhase.HOVER);
            if(_loc3_)
            {
               this.revealHorizontalScrollBar();
               return;
            }
            this.hideHorizontalScrollBar();
         }
      }
      
      protected function verticalScrollBar_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:Touch = null;
         var _loc4_:Point = null;
         var _loc5_:Boolean = false;
         if(!this._isEnabled)
         {
            this._verticalScrollBarTouchPointID = -1;
            return;
         }
         _loc2_ = DisplayObject(param1.currentTarget);
         if(this._verticalScrollBarTouchPointID >= 0)
         {
            _loc3_ = param1.getTouch(_loc2_,TouchPhase.ENDED,this._verticalScrollBarTouchPointID);
            if(!_loc3_)
            {
               return;
            }
            this._verticalScrollBarTouchPointID = -1;
            _loc4_ = _loc3_.getLocation(_loc2_,Pool.getPoint());
            _loc5_ = this.verticalScrollBar.hitTest(_loc4_) !== null;
            Pool.putPoint(_loc4_);
            if(!_loc5_)
            {
               this.hideVerticalScrollBar();
            }
         }
         else
         {
            _loc3_ = param1.getTouch(_loc2_,TouchPhase.BEGAN);
            if(_loc3_)
            {
               this._verticalScrollBarTouchPointID = _loc3_.id;
               return;
            }
            if(this._isScrolling)
            {
               return;
            }
            _loc3_ = param1.getTouch(_loc2_,TouchPhase.HOVER);
            if(_loc3_)
            {
               this.revealVerticalScrollBar();
               return;
            }
            this.hideVerticalScrollBar();
         }
      }
      
      protected function scroller_addedToStageHandler(param1:starling.events.Event) : void
      {
         var _loc2_:Starling = null;
         _loc2_ = this.stage !== null ? this.stage.starling : Starling.current;
         _loc2_.nativeStage.addEventListener(MouseEvent.MOUSE_WHEEL,this.nativeStage_mouseWheelHandler,false,0,true);
         _loc2_.nativeStage.addEventListener("orientationChange",this.nativeStage_orientationChangeHandler,false,0,true);
      }
      
      protected function scroller_removedFromStageHandler(param1:starling.events.Event) : void
      {
         var _loc2_:Starling = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:ExclusiveTouch = null;
         _loc2_ = this.stage !== null ? this.stage.starling : Starling.current;
         _loc2_.nativeStage.removeEventListener(MouseEvent.MOUSE_WHEEL,this.nativeStage_mouseWheelHandler);
         _loc2_.nativeStage.removeEventListener("orientationChange",this.nativeStage_orientationChangeHandler);
         if(this._touchPointID >= 0)
         {
            _loc5_ = ExclusiveTouch.forStage(this.stage);
            _loc5_.removeEventListener(starling.events.Event.CHANGE,this.exclusiveTouch_changeHandler);
         }
         this._touchPointID = -1;
         this._horizontalScrollBarTouchPointID = -1;
         this._verticalScrollBarTouchPointID = -1;
         this._isDraggingHorizontally = false;
         this._isDraggingVertically = false;
         this._velocityX = 0;
         this._velocityY = 0;
         this._previousVelocityX.length = 0;
         this._previousVelocityY.length = 0;
         this._horizontalScrollBarIsScrolling = false;
         this._verticalScrollBarIsScrolling = false;
         this.removeEventListener(starling.events.Event.ENTER_FRAME,this.scroller_enterFrameHandler);
         this.stage.removeEventListener(TouchEvent.TOUCH,this.stage_touchHandler);
         if(this._verticalAutoScrollTween)
         {
            Starling.juggler.remove(this._verticalAutoScrollTween);
            this._verticalAutoScrollTween = null;
         }
         if(this._horizontalAutoScrollTween)
         {
            Starling.juggler.remove(this._horizontalAutoScrollTween);
            this._horizontalAutoScrollTween = null;
         }
         if(this._topPullTween)
         {
            this._topPullTween.dispatchEventWith(starling.events.Event.REMOVE_FROM_JUGGLER);
            this._topPullTween = null;
         }
         if(this._rightPullTween)
         {
            this._rightPullTween.dispatchEventWith(starling.events.Event.REMOVE_FROM_JUGGLER);
            this._rightPullTween = null;
         }
         if(this._bottomPullTween)
         {
            this._bottomPullTween.dispatchEventWith(starling.events.Event.REMOVE_FROM_JUGGLER);
            this._bottomPullTween = null;
         }
         if(this._leftPullTween)
         {
            this._leftPullTween.dispatchEventWith(starling.events.Event.REMOVE_FROM_JUGGLER);
            this._leftPullTween = null;
         }
         _loc3_ = this._horizontalScrollPosition;
         _loc4_ = this._verticalScrollPosition;
         if(this._horizontalScrollPosition < this._minHorizontalScrollPosition)
         {
            this._horizontalScrollPosition = this._minHorizontalScrollPosition;
         }
         else if(this._horizontalScrollPosition > this._maxHorizontalScrollPosition)
         {
            this._horizontalScrollPosition = this._maxHorizontalScrollPosition;
         }
         if(this._verticalScrollPosition < this._minVerticalScrollPosition)
         {
            this._verticalScrollPosition = this._minVerticalScrollPosition;
         }
         else if(this._verticalScrollPosition > this._maxVerticalScrollPosition)
         {
            this._verticalScrollPosition = this._maxVerticalScrollPosition;
         }
         if(_loc3_ != this._horizontalScrollPosition || _loc4_ != this._verticalScrollPosition)
         {
            this.dispatchEventWith(starling.events.Event.SCROLL);
         }
         this.completeScroll();
      }
      
      override protected function focusInHandler(param1:starling.events.Event) : void
      {
         var _loc2_:int = 0;
         super.focusInHandler(param1);
         _loc2_ = -getDisplayObjectDepthFromStage(this);
         this.stage.starling.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN,this.nativeStage_keyDownHandler,false,_loc2_,true);
         this.stage.starling.nativeStage.addEventListener("gestureDirectionalTap",this.stage_gestureDirectionalTapHandler,false,_loc2_,true);
      }
      
      override protected function focusOutHandler(param1:starling.events.Event) : void
      {
         super.focusOutHandler(param1);
         if(this.stage != null && this.stage.starling != null && this.stage.starling.nativeStage != null)
         {
            this.stage.starling.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN,this.nativeStage_keyDownHandler);
            this.stage.starling.nativeStage.removeEventListener("gestureDirectionalTap",this.stage_gestureDirectionalTapHandler);
         }
      }
      
      protected function nativeStage_keyDownHandler(param1:KeyboardEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(param1.isDefaultPrevented())
         {
            return;
         }
         _loc2_ = this._horizontalScrollPosition;
         _loc3_ = this._verticalScrollPosition;
         if(param1.keyCode == Keyboard.HOME)
         {
            _loc3_ = this._minVerticalScrollPosition;
         }
         else if(param1.keyCode == Keyboard.END)
         {
            _loc3_ = this._maxVerticalScrollPosition;
         }
         else if(param1.keyCode == Keyboard.PAGE_UP)
         {
            _loc3_ = Math.max(this._minVerticalScrollPosition,this._verticalScrollPosition - this.viewPort.visibleHeight);
         }
         else if(param1.keyCode == Keyboard.PAGE_DOWN)
         {
            _loc3_ = Math.min(this._maxVerticalScrollPosition,this._verticalScrollPosition + this.viewPort.visibleHeight);
         }
         else if(param1.keyCode == Keyboard.UP)
         {
            _loc3_ = Math.max(this._minVerticalScrollPosition,this._verticalScrollPosition - this.verticalScrollStep);
         }
         else if(param1.keyCode == Keyboard.DOWN)
         {
            _loc3_ = Math.min(this._maxVerticalScrollPosition,this._verticalScrollPosition + this.verticalScrollStep);
         }
         else if(param1.keyCode == Keyboard.LEFT)
         {
            _loc2_ = Math.max(this._minHorizontalScrollPosition,this._horizontalScrollPosition - this.horizontalScrollStep);
         }
         else if(param1.keyCode == Keyboard.RIGHT)
         {
            _loc2_ = Math.min(this._maxHorizontalScrollPosition,this._horizontalScrollPosition + this.horizontalScrollStep);
         }
         if(this._horizontalScrollPosition != _loc2_ && this._horizontalScrollPolicy != ScrollPolicy.OFF)
         {
            param1.preventDefault();
            this.horizontalScrollPosition = _loc2_;
         }
         if(this._verticalScrollPosition != _loc3_ && this._verticalScrollPolicy != ScrollPolicy.OFF)
         {
            param1.preventDefault();
            this.verticalScrollPosition = _loc3_;
         }
      }
      
      protected function stage_gestureDirectionalTapHandler(param1:TransformGestureEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(param1.isDefaultPrevented())
         {
            return;
         }
         _loc2_ = this._horizontalScrollPosition;
         _loc3_ = this._verticalScrollPosition;
         if(param1.offsetY < 0)
         {
            _loc3_ = Math.max(this._minVerticalScrollPosition,this._verticalScrollPosition - this.verticalScrollStep);
         }
         else if(param1.offsetY > 0)
         {
            _loc3_ = Math.min(this._maxVerticalScrollPosition,this._verticalScrollPosition + this.verticalScrollStep);
         }
         else if(param1.offsetX < 0)
         {
            _loc2_ = Math.max(this._maxHorizontalScrollPosition,this._horizontalScrollPosition - this.horizontalScrollStep);
         }
         else if(param1.offsetX > 0)
         {
            _loc2_ = Math.min(this._maxHorizontalScrollPosition,this._horizontalScrollPosition + this.horizontalScrollStep);
         }
         if(this._horizontalScrollPosition != _loc2_)
         {
            param1.stopImmediatePropagation();
            this.horizontalScrollPosition = _loc2_;
         }
         if(this._verticalScrollPosition != _loc3_)
         {
            param1.stopImmediatePropagation();
            this.verticalScrollPosition = _loc3_;
         }
      }
   }
}

