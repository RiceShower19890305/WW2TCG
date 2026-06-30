package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.IFocusDisplayObject;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.IValidating;
   import feathers.core.PropertyProxy;
   import feathers.events.FeathersEventType;
   import feathers.layout.Direction;
   import feathers.skins.IStyleProvider;
   import feathers.utils.math.clamp;
   import feathers.utils.math.roundDownToNearest;
   import feathers.utils.math.roundToNearest;
   import feathers.utils.math.roundUpToNearest;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import starling.display.DisplayObject;
   import starling.display.Quad;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Pool;
   
   public class SimpleScrollBar extends FeathersControl implements IDirectionalScrollBar
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      protected static const INVALIDATION_FLAG_THUMB_FACTORY:String = "thumbFactory";
      
      public static const DEFAULT_CHILD_STYLE_NAME_THUMB:String = "feathers-simple-scroll-bar-thumb";
      
      protected var thumbStyleName:String = "feathers-simple-scroll-bar-thumb";
      
      protected var _thumbExplicitWidth:Number;
      
      protected var _thumbExplicitHeight:Number;
      
      protected var _thumbExplicitMinWidth:Number;
      
      protected var _thumbExplicitMinHeight:Number;
      
      protected var thumb:DisplayObject;
      
      protected var track:Quad;
      
      protected var _direction:String = "horizontal";
      
      protected var _fixedThumbSize:Boolean = false;
      
      public var clampToRange:Boolean = false;
      
      protected var _value:Number = 0;
      
      protected var _minimum:Number = 0;
      
      protected var _maximum:Number = 0;
      
      protected var _step:Number = 0;
      
      protected var _page:Number = 0;
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var currentRepeatAction:Function;
      
      protected var _repeatTimer:Timer;
      
      protected var _repeatDelay:Number = 0.05;
      
      protected var isDragging:Boolean = false;
      
      public var liveDragging:Boolean = true;
      
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
      
      public function SimpleScrollBar()
      {
         super();
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStageHandler);
      }
      
      protected static function defaultThumbFactory() : BasicButton
      {
         return new Button();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return SimpleScrollBar.globalStyleProvider;
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
         this.invalidate(INVALIDATION_FLAG_THUMB_FACTORY);
      }
      
      public function get fixedThumbSize() : Boolean
      {
         return this._fixedThumbSize;
      }
      
      public function set fixedThumbSize(param1:Boolean) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._fixedThumbSize === param1)
         {
            return;
         }
         this._fixedThumbSize = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get value() : Number
      {
         return this._value;
      }
      
      public function set value(param1:Number) : void
      {
         if(this.clampToRange)
         {
            param1 = clamp(param1,this._minimum,this._maximum);
         }
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
         this.invalidate(INVALIDATION_FLAG_DATA);
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
            this._thumbProperties = new PropertyProxy(this.thumbProperties_onChange);
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
            this._thumbProperties.removeOnChangeCallback(this.thumbProperties_onChange);
         }
         this._thumbProperties = PropertyProxy(param1);
         if(this._thumbProperties)
         {
            this._thumbProperties.addOnChangeCallback(this.thumbProperties_onChange);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      override protected function initialize() : void
      {
         if(!this.track)
         {
            this.track = new Quad(10,10,16711935);
            this.track.alpha = 0;
            this.track.addEventListener(TouchEvent.TOUCH,this.track_touchHandler);
            this.addChild(this.track);
         }
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
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
         var _loc4_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         var _loc5_:Boolean = this.isInvalid(INVALIDATION_FLAG_THUMB_FACTORY);
         if(_loc5_)
         {
            this.createThumb();
         }
         if(_loc5_ || _loc2_)
         {
            this.refreshThumbStyles();
         }
         if(_loc1_ || _loc5_ || _loc4_)
         {
            this.refreshEnabled();
         }
         _loc3_ = this.autoSizeIfNeeded() || _loc3_;
         this.layout();
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc5_:IMeasureDisplayObject = null;
         var _loc1_:Boolean = this._explicitWidth !== this._explicitWidth;
         var _loc2_:Boolean = this._explicitHeight !== this._explicitHeight;
         var _loc3_:Boolean = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc4_:Boolean = this._explicitMinHeight !== this._explicitMinHeight;
         if(!_loc1_ && !_loc2_ && !_loc3_ && !_loc4_)
         {
            return false;
         }
         this.thumb.width = this._thumbExplicitWidth;
         this.thumb.height = this._thumbExplicitHeight;
         if(this.thumb is IMeasureDisplayObject)
         {
            _loc5_ = IMeasureDisplayObject(this.thumb);
            _loc5_.minWidth = this._thumbExplicitMinWidth;
            _loc5_.minHeight = this._thumbExplicitMinHeight;
         }
         if(this.thumb is IValidating)
         {
            IValidating(this.thumb).validate();
         }
         var _loc6_:Number = this._maximum - this._minimum;
         var _loc7_:Number = this._page;
         if(_loc7_ == 0)
         {
            _loc7_ = this._step;
         }
         if(_loc7_ > _loc6_)
         {
            _loc7_ = _loc6_;
         }
         var _loc8_:Number = this._explicitWidth;
         var _loc9_:Number = this._explicitHeight;
         var _loc10_:Number = this._explicitMinWidth;
         var _loc11_:Number = this._explicitMinHeight;
         if(_loc1_)
         {
            _loc8_ = this.thumb.width;
            if(this._direction !== Direction.VERTICAL && _loc7_ != 0)
            {
               _loc8_ *= _loc6_ / _loc7_;
            }
            _loc8_ += this._paddingLeft + this._paddingRight;
         }
         if(_loc2_)
         {
            _loc9_ = this.thumb.height;
            if(this._direction === Direction.VERTICAL && _loc7_ != 0)
            {
               _loc9_ *= _loc6_ / _loc7_;
            }
            _loc9_ += this._paddingTop + this._paddingBottom;
         }
         if(_loc3_)
         {
            if(_loc5_ !== null)
            {
               _loc10_ = _loc5_.minWidth;
            }
            else
            {
               _loc10_ = this.thumb.width;
            }
            if(this._direction !== Direction.VERTICAL && _loc7_ != 0)
            {
               _loc10_ *= _loc6_ / _loc7_;
            }
            _loc10_ += this._paddingLeft + this._paddingRight;
         }
         if(_loc4_)
         {
            if(_loc5_ !== null)
            {
               _loc11_ = _loc5_.minHeight;
            }
            else
            {
               _loc11_ = this.thumb.height;
            }
            if(this._direction === Direction.VERTICAL && _loc7_ != 0)
            {
               _loc11_ *= _loc6_ / _loc7_;
            }
            _loc11_ += this._paddingTop + this._paddingBottom;
         }
         return this.saveMeasurements(_loc8_,_loc9_,_loc10_,_loc11_);
      }
      
      protected function createThumb() : void
      {
         var _loc4_:IMeasureDisplayObject = null;
         if(this.thumb)
         {
            this.thumb.removeFromParent(true);
            this.thumb = null;
         }
         var _loc1_:Function = this._thumbFactory != null ? this._thumbFactory : defaultThumbFactory;
         var _loc2_:String = this._customThumbStyleName != null ? this._customThumbStyleName : this.thumbStyleName;
         var _loc3_:BasicButton = BasicButton(_loc1_());
         _loc3_.styleNameList.add(_loc2_);
         if(_loc3_ is IFocusDisplayObject)
         {
            _loc3_.isFocusEnabled = false;
         }
         _loc3_.keepDownStateOnRollOut = true;
         _loc3_.addEventListener(TouchEvent.TOUCH,this.thumb_touchHandler);
         this.addChild(_loc3_);
         this.thumb = _loc3_;
         if(this.thumb is IFeathersControl)
         {
            IFeathersControl(this.thumb).initializeNow();
         }
         if(this.thumb is IMeasureDisplayObject)
         {
            _loc4_ = IMeasureDisplayObject(this.thumb);
            this._thumbExplicitWidth = _loc4_.explicitWidth;
            this._thumbExplicitHeight = _loc4_.explicitHeight;
            this._thumbExplicitMinWidth = _loc4_.explicitMinWidth;
            this._thumbExplicitMinHeight = _loc4_.explicitMinHeight;
         }
         else
         {
            this._thumbExplicitWidth = this.thumb.width;
            this._thumbExplicitHeight = this.thumb.height;
            this._thumbExplicitMinWidth = this._thumbExplicitWidth;
            this._thumbExplicitMinHeight = this._thumbExplicitHeight;
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
      }
      
      protected function refreshEnabled() : void
      {
         if(this.thumb is IFeathersControl)
         {
            IFeathersControl(this.thumb).isEnabled = this._isEnabled && this._maximum > this._minimum;
         }
      }
      
      protected function layout() : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         this.track.width = this.actualWidth;
         this.track.height = this.actualHeight;
         var _loc1_:Number = this._maximum - this._minimum;
         this.thumb.visible = _loc1_ > 0;
         if(!this.thumb.visible)
         {
            return;
         }
         if(this.thumb is IValidating)
         {
            IValidating(this.thumb).validate();
         }
         var _loc2_:Number = this.actualWidth - this._paddingLeft - this._paddingRight;
         var _loc3_:Number = this.actualHeight - this._paddingTop - this._paddingBottom;
         var _loc4_:Number = this._page;
         if(this._page == 0)
         {
            _loc4_ = this._step;
         }
         else if(_loc4_ > _loc1_)
         {
            _loc4_ = _loc1_;
         }
         var _loc5_:Number = 0;
         if(this._value < this._minimum)
         {
            _loc5_ = this._minimum - this._value;
         }
         if(this._value > this._maximum)
         {
            _loc5_ = this._value - this._maximum;
         }
         if(this._direction == Direction.VERTICAL)
         {
            this.thumb.width = _loc2_;
            _loc6_ = this._thumbExplicitMinHeight;
            if(this.thumb is IMeasureDisplayObject)
            {
               _loc6_ = IMeasureDisplayObject(this.thumb).minHeight;
            }
            if(this._fixedThumbSize)
            {
               this.thumb.height = this._thumbExplicitHeight;
            }
            else
            {
               _loc9_ = _loc3_ * _loc4_ / _loc1_;
               _loc10_ = _loc3_ - _loc9_;
               if(_loc10_ > _loc9_)
               {
                  _loc10_ = _loc9_;
               }
               _loc10_ *= _loc5_ / (_loc1_ * _loc9_ / _loc3_);
               _loc9_ -= _loc10_;
               if(_loc9_ < _loc6_)
               {
                  _loc9_ = _loc6_;
               }
               this.thumb.height = _loc9_;
            }
            this.thumb.x = this._paddingLeft + (this.actualWidth - this._paddingLeft - this._paddingRight - this.thumb.width) / 2;
            _loc7_ = _loc3_ - this.thumb.height;
            _loc8_ = _loc7_ * (this._value - this._minimum) / _loc1_;
            if(_loc8_ > _loc7_)
            {
               _loc8_ = _loc7_;
            }
            else if(_loc8_ < 0)
            {
               _loc8_ = 0;
            }
            this.thumb.y = this._paddingTop + _loc8_;
         }
         else
         {
            _loc11_ = this._thumbExplicitMinWidth;
            if(this.thumb is IMeasureDisplayObject)
            {
               _loc11_ = IMeasureDisplayObject(this.thumb).minWidth;
            }
            if(this._fixedThumbSize)
            {
               this.thumb.width = this._thumbExplicitWidth;
            }
            else
            {
               _loc14_ = _loc2_ * _loc4_ / _loc1_;
               _loc15_ = _loc2_ - _loc14_;
               if(_loc15_ > _loc14_)
               {
                  _loc15_ = _loc14_;
               }
               _loc15_ *= _loc5_ / (_loc1_ * _loc14_ / _loc2_);
               _loc14_ -= _loc15_;
               if(_loc14_ < _loc11_)
               {
                  _loc14_ = _loc11_;
               }
               this.thumb.width = _loc14_;
            }
            this.thumb.height = _loc3_;
            _loc12_ = _loc2_ - this.thumb.width;
            _loc13_ = _loc12_ * (this._value - this._minimum) / _loc1_;
            if(_loc13_ > _loc12_)
            {
               _loc13_ = _loc12_;
            }
            else if(_loc13_ < 0)
            {
               _loc13_ = 0;
            }
            this.thumb.x = this._paddingLeft + _loc13_;
            this.thumb.y = this._paddingTop + (this.actualHeight - this._paddingTop - this._paddingBottom - this.thumb.height) / 2;
         }
         if(this.thumb is IValidating)
         {
            IValidating(this.thumb).validate();
         }
      }
      
      protected function locationToValue(param1:Point) : Number
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc2_:Number = 0;
         if(this._direction == Direction.VERTICAL)
         {
            _loc3_ = this.actualHeight - this.thumb.height - this._paddingTop - this._paddingBottom;
            if(_loc3_ > 0)
            {
               _loc4_ = param1.y - this._touchStartY - this._paddingTop;
               _loc5_ = Math.min(Math.max(0,this._thumbStartY + _loc4_),_loc3_);
               _loc2_ = _loc5_ / _loc3_;
            }
         }
         else
         {
            _loc6_ = this.actualWidth - this.thumb.width - this._paddingLeft - this._paddingRight;
            if(_loc6_ > 0)
            {
               _loc7_ = param1.x - this._touchStartX - this._paddingLeft;
               _loc8_ = Math.min(Math.max(0,this._thumbStartX + _loc7_),_loc6_);
               _loc2_ = _loc8_ / _loc6_;
            }
         }
         return this._minimum + _loc2_ * (this._maximum - this._minimum);
      }
      
      protected function adjustPage() : void
      {
         var _loc3_:Number = NaN;
         var _loc1_:Number = this._maximum - this._minimum;
         var _loc2_:Number = this._page;
         if(_loc2_ == 0)
         {
            _loc2_ = this._step;
         }
         if(_loc2_ > _loc1_)
         {
            _loc2_ = _loc1_;
         }
         if(this._touchValue < this._pageStartValue)
         {
            _loc3_ = Math.max(this._touchValue,this._value - _loc2_);
            if(this._step != 0 && _loc3_ != this._maximum && _loc3_ != this._minimum)
            {
               _loc3_ = roundDownToNearest(_loc3_,this._step);
            }
            _loc3_ = clamp(_loc3_,this._minimum,this._maximum);
            this.value = _loc3_;
         }
         else if(this._touchValue > this._pageStartValue)
         {
            _loc3_ = Math.min(this._touchValue,this._value + _loc2_);
            if(this._step != 0 && _loc3_ != this._maximum && _loc3_ != this._minimum)
            {
               _loc3_ = roundUpToNearest(_loc3_,this._step);
            }
            _loc3_ = clamp(_loc3_,this._minimum,this._maximum);
            this.value = _loc3_;
         }
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
      
      protected function thumbProperties_onChange(param1:PropertyProxy, param2:Object) : void
      {
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      protected function removedFromStageHandler(param1:Event) : void
      {
         this._touchPointID = -1;
         if(this._repeatTimer)
         {
            this._repeatTimer.stop();
         }
      }
      
      protected function track_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         var _loc3_:Point = null;
         if(!this._isEnabled)
         {
            this._touchPointID = -1;
            return;
         }
         if(this._touchPointID >= 0)
         {
            _loc2_ = param1.getTouch(this.track,null,this._touchPointID);
            if(_loc2_ === null)
            {
               return;
            }
            if(_loc2_.phase === TouchPhase.MOVED)
            {
               _loc3_ = _loc2_.getLocation(this,Pool.getPoint());
               this._touchValue = this.locationToValue(_loc3_);
               Pool.putPoint(_loc3_);
            }
            else if(_loc2_.phase === TouchPhase.ENDED)
            {
               this._touchPointID = -1;
               this._repeatTimer.stop();
            }
         }
         else
         {
            _loc2_ = param1.getTouch(this.track,TouchPhase.BEGAN);
            if(_loc2_ === null)
            {
               return;
            }
            this._touchPointID = _loc2_.id;
            _loc3_ = _loc2_.getLocation(this,Pool.getPoint());
            this._touchStartX = _loc3_.x;
            this._touchStartY = _loc3_.y;
            this._thumbStartX = this._touchStartX;
            this._thumbStartY = this._touchStartY;
            this._touchValue = this.locationToValue(_loc3_);
            Pool.putPoint(_loc3_);
            this._pageStartValue = this._value;
            this.adjustPage();
            this.startRepeatTimer(this.adjustPage);
         }
      }
      
      protected function thumb_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         var _loc3_:Point = null;
         var _loc4_:Number = NaN;
         if(!this._isEnabled)
         {
            return;
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
               _loc3_ = _loc2_.getLocation(this,Pool.getPoint());
               _loc4_ = this.locationToValue(_loc3_);
               Pool.putPoint(_loc3_);
               if(this._step != 0 && _loc4_ != this._maximum && _loc4_ != this._minimum)
               {
                  _loc4_ = roundToNearest(_loc4_,this._step);
               }
               this.value = _loc4_;
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
      
      protected function repeatTimer_timerHandler(param1:TimerEvent) : void
      {
         if(this._repeatTimer.currentCount < 5)
         {
            return;
         }
         this.currentRepeatAction();
      }
   }
}

