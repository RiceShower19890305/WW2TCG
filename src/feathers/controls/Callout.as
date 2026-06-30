package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.IValidating;
   import feathers.core.PopUpManager;
   import feathers.events.FeathersEventType;
   import feathers.layout.HorizontalAlign;
   import feathers.layout.RelativePosition;
   import feathers.layout.VerticalAlign;
   import feathers.skins.IStyleProvider;
   import feathers.utils.display.getDisplayObjectDepthFromStage;
   import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;
   import flash.events.KeyboardEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.display.Stage;
   import starling.events.EnterFrameEvent;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Pool;
   
   public class Callout extends FeathersControl
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      public static const DEFAULT_POSITIONS:Vector.<String> = new <String>[RelativePosition.BOTTOM,RelativePosition.TOP,RelativePosition.RIGHT,RelativePosition.LEFT];
      
      protected static const INVALIDATION_FLAG_ORIGIN:String = "origin";
      
      protected static const FUZZY_CONTENT_DIMENSIONS_PADDING:Number = 0.000001;
      
      public static var stagePaddingTop:Number = 0;
      
      public static var stagePaddingRight:Number = 0;
      
      public static var stagePaddingBottom:Number = 0;
      
      public static var stagePaddingLeft:Number = 0;
      
      public static var calloutFactory:Function = defaultCalloutFactory;
      
      public static var calloutOverlayFactory:Function = PopUpManager.defaultOverlayFactory;
      
      public var closeOnTouchBeganOutside:Boolean = false;
      
      public var closeOnTouchEndedOutside:Boolean = false;
      
      public var closeOnKeys:Vector.<uint>;
      
      public var disposeOnSelfClose:Boolean = true;
      
      public var disposeContent:Boolean = true;
      
      protected var _isReadyToClose:Boolean = false;
      
      protected var _explicitContentWidth:Number;
      
      protected var _explicitContentHeight:Number;
      
      protected var _explicitContentMinWidth:Number;
      
      protected var _explicitContentMinHeight:Number;
      
      protected var _explicitContentMaxWidth:Number;
      
      protected var _explicitContentMaxHeight:Number;
      
      protected var _explicitBackgroundSkinWidth:Number;
      
      protected var _explicitBackgroundSkinHeight:Number;
      
      protected var _explicitBackgroundSkinMinWidth:Number;
      
      protected var _explicitBackgroundSkinMinHeight:Number;
      
      protected var _explicitBackgroundSkinMaxWidth:Number;
      
      protected var _explicitBackgroundSkinMaxHeight:Number;
      
      protected var _content:DisplayObject;
      
      protected var _origin:DisplayObject;
      
      protected var _supportedPositions:Vector.<String> = null;
      
      protected var _horizontalAlign:String = "center";
      
      protected var _verticalAlign:String = "middle";
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var _arrowPosition:String = "top";
      
      protected var _backgroundSkin:DisplayObject;
      
      protected var currentArrowSkin:DisplayObject;
      
      protected var _topArrowSkin:DisplayObject;
      
      protected var _rightArrowSkin:DisplayObject;
      
      protected var _bottomArrowSkin:DisplayObject;
      
      protected var _leftArrowSkin:DisplayObject;
      
      protected var _originGap:Number = 0;
      
      protected var _topArrowGap:Number = 0;
      
      protected var _bottomArrowGap:Number = 0;
      
      protected var _rightArrowGap:Number = 0;
      
      protected var _leftArrowGap:Number = 0;
      
      protected var _arrowOffset:Number = 0;
      
      protected var _lastGlobalBoundsOfOrigin:flash.geom.Rectangle;
      
      protected var _ignoreContentResize:Boolean = false;
      
      public function Callout()
      {
         super();
         this.addEventListener(Event.ADDED_TO_STAGE,this.callout_addedToStageHandler);
      }
      
      public static function get stagePadding() : Number
      {
         return Callout.stagePaddingTop;
      }
      
      public static function set stagePadding(param1:Number) : void
      {
         Callout.stagePaddingTop = param1;
         Callout.stagePaddingRight = param1;
         Callout.stagePaddingBottom = param1;
         Callout.stagePaddingLeft = param1;
      }
      
      public static function show(param1:DisplayObject, param2:DisplayObject, param3:Vector.<String> = null, param4:Boolean = true, param5:Function = null, param6:Function = null) : Callout
      {
         if(param2.stage === null)
         {
            throw new ArgumentError("Callout origin must be added to the stage.");
         }
         var _loc7_:Function = param5;
         if(_loc7_ === null)
         {
            _loc7_ = calloutFactory;
            if(_loc7_ === null)
            {
               _loc7_ = defaultCalloutFactory;
            }
         }
         var _loc8_:Callout = Callout(_loc7_());
         _loc8_.content = param1;
         _loc8_.supportedPositions = param3;
         _loc8_.origin = param2;
         _loc7_ = param6;
         if(_loc7_ === null)
         {
            _loc7_ = calloutOverlayFactory;
            if(_loc7_ === null)
            {
               _loc7_ = PopUpManager.defaultOverlayFactory;
            }
         }
         PopUpManager.addPopUp(_loc8_,param4,false,_loc7_);
         return _loc8_;
      }
      
      public static function defaultCalloutFactory() : Callout
      {
         var _loc1_:Callout = new Callout();
         _loc1_.closeOnTouchBeganOutside = true;
         _loc1_.closeOnTouchEndedOutside = true;
         _loc1_.closeOnKeys = new <uint>[Keyboard.BACK,Keyboard.ESCAPE];
         return _loc1_;
      }
      
      protected static function positionBelowOrigin(param1:Callout, param2:flash.geom.Rectangle) : void
      {
         var _loc5_:Point = null;
         var _loc6_:Stage = null;
         var _loc7_:Number = NaN;
         param1.measureWithArrowPosition(RelativePosition.TOP);
         var _loc3_:Number = param2.x;
         if(param1._horizontalAlign === HorizontalAlign.CENTER)
         {
            _loc3_ += Math.round((param2.width - param1.width) / 2);
         }
         else if(param1._horizontalAlign === HorizontalAlign.RIGHT)
         {
            _loc3_ += param2.width - param1.width;
         }
         var _loc4_:Number = _loc3_;
         if(stagePaddingLeft > _loc4_)
         {
            _loc4_ = stagePaddingLeft;
         }
         else
         {
            _loc6_ = param1.stage !== null ? param1.stage : Starling.current.stage;
            _loc7_ = _loc6_.stageWidth - param1.width - stagePaddingRight;
            if(_loc7_ < _loc4_)
            {
               _loc4_ = _loc7_;
            }
         }
         _loc5_ = Pool.getPoint(_loc4_,param2.y + param2.height);
         param1.parent.globalToLocal(_loc5_,_loc5_);
         param1.x = _loc5_.x;
         param1.y = _loc5_.y + param1._originGap;
         Pool.putPoint(_loc5_);
         if(param1._isValidating)
         {
            param1._arrowOffset = _loc3_ - _loc4_;
            param1._arrowPosition = RelativePosition.TOP;
         }
         else
         {
            param1.arrowOffset = _loc3_ - _loc4_;
            param1.arrowPosition = RelativePosition.TOP;
         }
      }
      
      protected static function positionAboveOrigin(param1:Callout, param2:flash.geom.Rectangle) : void
      {
         var _loc6_:Stage = null;
         var _loc7_:Number = NaN;
         param1.measureWithArrowPosition(RelativePosition.BOTTOM);
         var _loc3_:Number = param2.x;
         if(param1._horizontalAlign === HorizontalAlign.CENTER)
         {
            _loc3_ += Math.round((param2.width - param1.width) / 2);
         }
         else if(param1._horizontalAlign === HorizontalAlign.RIGHT)
         {
            _loc3_ += param2.width - param1.width;
         }
         var _loc4_:Number = _loc3_;
         if(stagePaddingLeft > _loc4_)
         {
            _loc4_ = stagePaddingLeft;
         }
         else
         {
            _loc6_ = param1.stage !== null ? param1.stage : Starling.current.stage;
            _loc7_ = _loc6_.stageWidth - param1.width - stagePaddingRight;
            if(_loc7_ < _loc4_)
            {
               _loc4_ = _loc7_;
            }
         }
         var _loc5_:Point = Pool.getPoint(_loc4_,param2.y - param1.height);
         param1.parent.globalToLocal(_loc5_,_loc5_);
         param1.x = _loc5_.x;
         param1.y = _loc5_.y - param1._originGap;
         Pool.putPoint(_loc5_);
         if(param1._isValidating)
         {
            param1._arrowOffset = _loc3_ - _loc4_;
            param1._arrowPosition = RelativePosition.BOTTOM;
         }
         else
         {
            param1.arrowOffset = _loc3_ - _loc4_;
            param1.arrowPosition = RelativePosition.BOTTOM;
         }
      }
      
      protected static function positionToRightOfOrigin(param1:Callout, param2:flash.geom.Rectangle) : void
      {
         var _loc6_:Stage = null;
         var _loc7_:Number = NaN;
         param1.measureWithArrowPosition(RelativePosition.LEFT);
         var _loc3_:Number = param2.y;
         if(param1._verticalAlign === VerticalAlign.MIDDLE)
         {
            _loc3_ += Math.round((param2.height - param1.height) / 2);
         }
         else if(param1._verticalAlign === VerticalAlign.BOTTOM)
         {
            _loc3_ += param2.height - param1.height;
         }
         var _loc4_:Number = _loc3_;
         if(stagePaddingTop > _loc4_)
         {
            _loc4_ = stagePaddingTop;
         }
         else
         {
            _loc6_ = param1.stage !== null ? param1.stage : Starling.current.stage;
            _loc7_ = _loc6_.stageHeight - param1.height - stagePaddingBottom;
            if(_loc7_ < _loc4_)
            {
               _loc4_ = _loc7_;
            }
         }
         var _loc5_:Point = Pool.getPoint(param2.x + param2.width,_loc4_);
         param1.parent.globalToLocal(_loc5_,_loc5_);
         param1.x = _loc5_.x + param1._originGap;
         param1.y = _loc5_.y;
         Pool.putPoint(_loc5_);
         if(param1._isValidating)
         {
            param1._arrowOffset = _loc3_ - _loc4_;
            param1._arrowPosition = RelativePosition.LEFT;
         }
         else
         {
            param1.arrowOffset = _loc3_ - _loc4_;
            param1.arrowPosition = RelativePosition.LEFT;
         }
      }
      
      protected static function positionToLeftOfOrigin(param1:Callout, param2:flash.geom.Rectangle) : void
      {
         var _loc6_:Stage = null;
         var _loc7_:Number = NaN;
         param1.measureWithArrowPosition(RelativePosition.RIGHT);
         var _loc3_:Number = param2.y;
         if(param1._verticalAlign === VerticalAlign.MIDDLE)
         {
            _loc3_ += Math.round((param2.height - param1.height) / 2);
         }
         else if(param1._verticalAlign === VerticalAlign.BOTTOM)
         {
            _loc3_ += param2.height - param1.height;
         }
         var _loc4_:Number = _loc3_;
         if(stagePaddingTop > _loc4_)
         {
            _loc4_ = stagePaddingTop;
         }
         else
         {
            _loc6_ = param1.stage !== null ? param1.stage : Starling.current.stage;
            _loc7_ = _loc6_.stageHeight - param1.height - stagePaddingBottom;
            if(_loc7_ < _loc4_)
            {
               _loc4_ = _loc7_;
            }
         }
         var _loc5_:Point = Pool.getPoint(param2.x - param1.width,_loc4_);
         param1.parent.globalToLocal(_loc5_,_loc5_);
         param1.x = _loc5_.x - param1._originGap;
         param1.y = _loc5_.y;
         Pool.putPoint(_loc5_);
         if(param1._isValidating)
         {
            param1._arrowOffset = _loc3_ - _loc4_;
            param1._arrowPosition = RelativePosition.RIGHT;
         }
         else
         {
            param1.arrowOffset = _loc3_ - _loc4_;
            param1.arrowPosition = RelativePosition.RIGHT;
         }
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return Callout.globalStyleProvider;
      }
      
      public function get content() : DisplayObject
      {
         return this._content;
      }
      
      public function set content(param1:DisplayObject) : void
      {
         var _loc2_:IMeasureDisplayObject = null;
         if(this._content == param1)
         {
            return;
         }
         if(this._content !== null)
         {
            if(this._content is IFeathersControl)
            {
               IFeathersControl(this._content).removeEventListener(FeathersEventType.RESIZE,this.content_resizeHandler);
            }
            if(this._content.parent === this)
            {
               this._content.width = this._explicitContentWidth;
               this._content.height = this._explicitContentHeight;
               if(this._content is IMeasureDisplayObject)
               {
                  _loc2_ = IMeasureDisplayObject(this._content);
                  _loc2_.minWidth = this._explicitContentMinWidth;
                  _loc2_.minHeight = this._explicitContentMinHeight;
                  _loc2_.maxWidth = this._explicitContentMaxWidth;
                  _loc2_.maxHeight = this._explicitContentMaxHeight;
               }
               this._content.removeFromParent(false);
            }
         }
         this._content = param1;
         if(this._content !== null)
         {
            if(this._content is IFeathersControl)
            {
               IFeathersControl(this._content).addEventListener(FeathersEventType.RESIZE,this.content_resizeHandler);
            }
            this.addChild(this._content);
            if(this._content is IFeathersControl)
            {
               IFeathersControl(this._content).initializeNow();
            }
            if(this._content is IMeasureDisplayObject)
            {
               _loc2_ = IMeasureDisplayObject(this._content);
               this._explicitContentWidth = _loc2_.explicitWidth;
               this._explicitContentHeight = _loc2_.explicitHeight;
               this._explicitContentMinWidth = _loc2_.explicitMinWidth;
               this._explicitContentMinHeight = _loc2_.explicitMinHeight;
               this._explicitContentMaxWidth = _loc2_.explicitMaxWidth;
               this._explicitContentMaxHeight = _loc2_.explicitMaxHeight;
            }
            else
            {
               this._explicitContentWidth = this._content.width;
               this._explicitContentHeight = this._content.height;
               this._explicitContentMinWidth = this._explicitContentWidth;
               this._explicitContentMinHeight = this._explicitContentHeight;
               this._explicitContentMaxWidth = this._explicitContentWidth;
               this._explicitContentMaxHeight = this._explicitContentHeight;
            }
         }
         this.invalidate(INVALIDATION_FLAG_SIZE);
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get origin() : DisplayObject
      {
         return this._origin;
      }
      
      public function set origin(param1:DisplayObject) : void
      {
         if(this._origin == param1)
         {
            return;
         }
         if(Boolean(param1) && !param1.stage)
         {
            throw new ArgumentError("Callout origin must have access to the stage.");
         }
         if(this._origin)
         {
            this.removeEventListener(EnterFrameEvent.ENTER_FRAME,this.callout_enterFrameHandler);
            this._origin.removeEventListener(Event.REMOVED_FROM_STAGE,this.origin_removedFromStageHandler);
         }
         this._origin = param1;
         this._lastGlobalBoundsOfOrigin = null;
         if(this._origin)
         {
            this._origin.addEventListener(Event.REMOVED_FROM_STAGE,this.origin_removedFromStageHandler);
            this.addEventListener(EnterFrameEvent.ENTER_FRAME,this.callout_enterFrameHandler);
         }
         this.invalidate(INVALIDATION_FLAG_ORIGIN);
      }
      
      public function get supportedPositions() : Vector.<String>
      {
         return this._supportedPositions;
      }
      
      public function set supportedPositions(param1:Vector.<String>) : void
      {
         this._supportedPositions = param1;
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
         this._lastGlobalBoundsOfOrigin = null;
         this.invalidate(INVALIDATION_FLAG_ORIGIN);
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
         this._lastGlobalBoundsOfOrigin = null;
         this.invalidate(INVALIDATION_FLAG_ORIGIN);
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
      
      public function get arrowPosition() : String
      {
         return this._arrowPosition;
      }
      
      public function set arrowPosition(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._arrowPosition === param1)
         {
            return;
         }
         this._arrowPosition = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get backgroundSkin() : DisplayObject
      {
         return this._backgroundSkin;
      }
      
      public function set backgroundSkin(param1:DisplayObject) : void
      {
         var _loc3_:IMeasureDisplayObject = null;
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
         if(this._backgroundSkin !== null && this._backgroundSkin.parent === this)
         {
            this._backgroundSkin.width = this._explicitBackgroundSkinWidth;
            this._backgroundSkin.height = this._explicitBackgroundSkinHeight;
            if(this._backgroundSkin is IMeasureDisplayObject)
            {
               _loc3_ = IMeasureDisplayObject(this._backgroundSkin);
               _loc3_.minWidth = this._explicitBackgroundSkinMinWidth;
               _loc3_.minHeight = this._explicitBackgroundSkinMinHeight;
               _loc3_.maxWidth = this._explicitBackgroundSkinMaxWidth;
               _loc3_.maxHeight = this._explicitBackgroundSkinMaxHeight;
            }
            this._backgroundSkin.removeFromParent(false);
         }
         this._backgroundSkin = param1;
         if(this._backgroundSkin !== null)
         {
            if(this._backgroundSkin is IFeathersControl)
            {
               IFeathersControl(this._backgroundSkin).initializeNow();
            }
            if(this._backgroundSkin is IMeasureDisplayObject)
            {
               _loc3_ = IMeasureDisplayObject(this._backgroundSkin);
               this._explicitBackgroundSkinWidth = _loc3_.explicitWidth;
               this._explicitBackgroundSkinHeight = _loc3_.explicitHeight;
               this._explicitBackgroundSkinMinWidth = _loc3_.explicitMinWidth;
               this._explicitBackgroundSkinMinHeight = _loc3_.explicitMinHeight;
               this._explicitBackgroundSkinMaxWidth = _loc3_.explicitMaxWidth;
               this._explicitBackgroundSkinMaxHeight = _loc3_.explicitMaxHeight;
            }
            else
            {
               this._explicitBackgroundSkinWidth = this._backgroundSkin.width;
               this._explicitBackgroundSkinHeight = this._backgroundSkin.height;
               this._explicitBackgroundSkinMinWidth = this._explicitBackgroundSkinWidth;
               this._explicitBackgroundSkinMinHeight = this._explicitBackgroundSkinHeight;
               this._explicitBackgroundSkinMaxWidth = this._explicitBackgroundSkinWidth;
               this._explicitBackgroundSkinMaxHeight = this._explicitBackgroundSkinHeight;
            }
            this.addChildAt(this._backgroundSkin,0);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get topArrowSkin() : DisplayObject
      {
         return this._topArrowSkin;
      }
      
      public function set topArrowSkin(param1:DisplayObject) : void
      {
         var _loc3_:int = 0;
         if(this.processStyleRestriction(arguments.callee))
         {
            if(param1 !== null)
            {
               param1.dispose();
            }
            return;
         }
         if(this._topArrowSkin === param1)
         {
            return;
         }
         if(this._topArrowSkin !== null && this._topArrowSkin.parent === this)
         {
            this._topArrowSkin.removeFromParent(false);
         }
         this._topArrowSkin = param1;
         if(this._topArrowSkin !== null)
         {
            this._topArrowSkin.visible = false;
            _loc3_ = this.getChildIndex(this._content);
            if(_loc3_ < 0)
            {
               this.addChild(this._topArrowSkin);
            }
            else
            {
               this.addChildAt(this._topArrowSkin,_loc3_);
            }
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get rightArrowSkin() : DisplayObject
      {
         return this._rightArrowSkin;
      }
      
      public function set rightArrowSkin(param1:DisplayObject) : void
      {
         var _loc3_:int = 0;
         if(this.processStyleRestriction(arguments.callee))
         {
            if(param1 !== null)
            {
               param1.dispose();
            }
            return;
         }
         if(this._rightArrowSkin === param1)
         {
            return;
         }
         if(this._rightArrowSkin !== null && this._rightArrowSkin.parent === this)
         {
            this._rightArrowSkin.removeFromParent(false);
         }
         this._rightArrowSkin = param1;
         if(this._rightArrowSkin !== null)
         {
            this._rightArrowSkin.visible = false;
            _loc3_ = this.getChildIndex(this._content);
            if(_loc3_ < 0)
            {
               this.addChild(this._rightArrowSkin);
            }
            else
            {
               this.addChildAt(this._rightArrowSkin,_loc3_);
            }
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get bottomArrowSkin() : DisplayObject
      {
         return this._bottomArrowSkin;
      }
      
      public function set bottomArrowSkin(param1:DisplayObject) : void
      {
         var _loc3_:int = 0;
         if(this.processStyleRestriction(arguments.callee))
         {
            if(param1 !== null)
            {
               param1.dispose();
            }
            return;
         }
         if(this._bottomArrowSkin === param1)
         {
            return;
         }
         if(this._bottomArrowSkin !== null && this._bottomArrowSkin.parent === this)
         {
            this._bottomArrowSkin.removeFromParent(false);
         }
         this._bottomArrowSkin = param1;
         if(this._bottomArrowSkin !== null)
         {
            this._bottomArrowSkin.visible = false;
            _loc3_ = this.getChildIndex(this._content);
            if(_loc3_ < 0)
            {
               this.addChild(this._bottomArrowSkin);
            }
            else
            {
               this.addChildAt(this._bottomArrowSkin,_loc3_);
            }
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get leftArrowSkin() : DisplayObject
      {
         return this._leftArrowSkin;
      }
      
      public function set leftArrowSkin(param1:DisplayObject) : void
      {
         var _loc3_:int = 0;
         if(this.processStyleRestriction(arguments.callee))
         {
            if(param1 !== null)
            {
               param1.dispose();
            }
            return;
         }
         if(this._leftArrowSkin === param1)
         {
            return;
         }
         if(this._leftArrowSkin !== null && this._leftArrowSkin.parent === this)
         {
            this._leftArrowSkin.removeFromParent(false);
         }
         this._leftArrowSkin = param1;
         if(this._leftArrowSkin !== null)
         {
            this._leftArrowSkin.visible = false;
            _loc3_ = this.getChildIndex(this._content);
            if(_loc3_ < 0)
            {
               this.addChild(this._leftArrowSkin);
            }
            else
            {
               this.addChildAt(this._leftArrowSkin,_loc3_);
            }
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get originGap() : Number
      {
         return this._originGap;
      }
      
      public function set originGap(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._originGap == param1)
         {
            return;
         }
         this._originGap = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get topArrowGap() : Number
      {
         return this._topArrowGap;
      }
      
      public function set topArrowGap(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._topArrowGap == param1)
         {
            return;
         }
         this._topArrowGap = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get bottomArrowGap() : Number
      {
         return this._bottomArrowGap;
      }
      
      public function set bottomArrowGap(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._bottomArrowGap == param1)
         {
            return;
         }
         this._bottomArrowGap = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get rightArrowGap() : Number
      {
         return this._rightArrowGap;
      }
      
      public function set rightArrowGap(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._rightArrowGap == param1)
         {
            return;
         }
         this._rightArrowGap = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get leftArrowGap() : Number
      {
         return this._leftArrowGap;
      }
      
      public function set leftArrowGap(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._leftArrowGap == param1)
         {
            return;
         }
         this._leftArrowGap = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get arrowOffset() : Number
      {
         return this._arrowOffset;
      }
      
      public function set arrowOffset(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._arrowOffset == param1)
         {
            return;
         }
         this._arrowOffset = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      override public function dispose() : void
      {
         this.origin = null;
         var _loc1_:DisplayObject = this._content;
         this.content = null;
         if(_loc1_ !== null && this.disposeContent)
         {
            _loc1_.dispose();
         }
         super.dispose();
      }
      
      public function close(param1:Boolean = false) : void
      {
         if(this.parent)
         {
            this.removeFromParent(false);
            this.dispatchEventWith(Event.CLOSE);
         }
         if(param1)
         {
            this.dispose();
         }
      }
      
      override protected function initialize() : void
      {
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.callout_removedFromStageHandler);
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         var _loc4_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc5_:Boolean = this.isInvalid(INVALIDATION_FLAG_ORIGIN);
         if(_loc2_)
         {
            this._lastGlobalBoundsOfOrigin = null;
            _loc5_ = true;
         }
         if(_loc5_)
         {
            this.positionRelativeToOrigin();
         }
         if(_loc4_ || _loc3_)
         {
            this.refreshArrowSkin();
         }
         if(_loc3_ || _loc1_)
         {
            this.refreshEnabled();
         }
         _loc2_ = this.autoSizeIfNeeded() || _loc2_;
         this.layoutChildren();
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         return this.measureWithArrowPosition(this._arrowPosition);
      }
      
      protected function measureWithArrowPosition(param1:String) : Boolean
      {
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc32_:Number = NaN;
         var _loc2_:Boolean = this._explicitWidth !== this._explicitWidth;
         var _loc3_:Boolean = this._explicitHeight !== this._explicitHeight;
         var _loc4_:Boolean = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc5_:Boolean = this._explicitMinHeight !== this._explicitMinHeight;
         if(!_loc2_ && !_loc3_ && !_loc4_ && !_loc5_)
         {
            return false;
         }
         var _loc6_:Number = this._explicitMaxWidth;
         var _loc7_:Number = this._explicitMaxHeight;
         if(this.stage !== null)
         {
            _loc19_ = this.stage.stageWidth - stagePaddingLeft - stagePaddingRight;
            if(_loc6_ > _loc19_)
            {
               _loc6_ = _loc19_;
            }
            _loc20_ = this.stage.stageHeight - stagePaddingTop - stagePaddingBottom;
            if(_loc7_ > _loc20_)
            {
               _loc7_ = _loc20_;
            }
         }
         if(this._backgroundSkin !== null)
         {
            _loc21_ = this._backgroundSkin.width;
            _loc22_ = this._backgroundSkin.height;
         }
         var _loc8_:IMeasureDisplayObject = this._backgroundSkin as IMeasureDisplayObject;
         resetFluidChildDimensionsForMeasurement(this._backgroundSkin,this._explicitWidth,this._explicitHeight,this._explicitMinWidth,this._explicitMinHeight,_loc6_,_loc7_,this._explicitBackgroundSkinWidth,this._explicitBackgroundSkinHeight,this._explicitBackgroundSkinMinWidth,this._explicitBackgroundSkinMinHeight,this._explicitBackgroundSkinMaxWidth,this._explicitBackgroundSkinMaxHeight);
         if(this._backgroundSkin is IValidating)
         {
            IValidating(this._backgroundSkin).validate();
         }
         var _loc9_:Number = 0;
         var _loc10_:Number = 0;
         if(param1 === RelativePosition.LEFT && this._leftArrowSkin !== null)
         {
            _loc9_ = this._leftArrowSkin.width + this._leftArrowGap + this._originGap;
            _loc10_ = this._leftArrowSkin.height;
         }
         else if(param1 === RelativePosition.RIGHT && this._rightArrowSkin !== null)
         {
            _loc9_ = this._rightArrowSkin.width + this._rightArrowGap + this._originGap;
            _loc10_ = this._rightArrowSkin.height;
         }
         var _loc11_:Number = 0;
         var _loc12_:Number = 0;
         if(param1 === RelativePosition.TOP && this._topArrowSkin !== null)
         {
            _loc11_ = this._topArrowSkin.width;
            _loc12_ = this._topArrowSkin.height + this._topArrowGap + this._originGap;
         }
         else if(param1 === RelativePosition.BOTTOM && this._bottomArrowSkin !== null)
         {
            _loc11_ = this._bottomArrowSkin.width;
            _loc12_ = this._bottomArrowSkin.height + this._bottomArrowGap + this._originGap;
         }
         var _loc13_:Boolean = this._ignoreContentResize;
         this._ignoreContentResize = true;
         if(this._content !== null)
         {
            _loc23_ = this._content.width;
            _loc24_ = this._content.height;
         }
         var _loc14_:IMeasureDisplayObject = this._content as IMeasureDisplayObject;
         resetFluidChildDimensionsForMeasurement(this._content,this._explicitWidth - _loc9_ - this._paddingLeft - this._paddingRight,this._explicitHeight - _loc12_ - this._paddingTop - this._paddingBottom,this._explicitMinWidth - _loc9_ - this._paddingLeft - this._paddingRight,this._explicitMinHeight - _loc12_ - this._paddingTop - this._paddingBottom,_loc6_ - _loc10_ - this._paddingLeft - this._paddingRight,_loc7_ - _loc12_ - this._paddingTop - this._paddingBottom,this._explicitContentWidth,this._explicitContentHeight,this._explicitContentMinWidth,this._explicitContentMinHeight,this._explicitContentMaxWidth,this._explicitContentMaxHeight);
         if(this._content is IValidating)
         {
            IValidating(this._content).validate();
         }
         this._ignoreContentResize = _loc13_;
         var _loc15_:Number = this._explicitWidth;
         if(_loc2_)
         {
            _loc25_ = 0;
            if(this._content !== null)
            {
               _loc25_ = this._content.width;
            }
            if(_loc11_ > _loc25_)
            {
               _loc25_ = _loc11_;
            }
            _loc15_ = _loc25_ + this._paddingLeft + this._paddingRight;
            _loc26_ = 0;
            if(this._backgroundSkin !== null)
            {
               _loc26_ = this._backgroundSkin.width;
            }
            if(_loc26_ > _loc15_)
            {
               _loc15_ = _loc26_;
            }
            _loc15_ += _loc9_;
            if(_loc15_ > _loc6_)
            {
               _loc15_ = _loc6_;
            }
         }
         var _loc16_:Number = this._explicitHeight;
         if(_loc3_)
         {
            _loc27_ = 0;
            if(this._content !== null)
            {
               _loc27_ = this._content.height;
            }
            if(_loc10_ > _loc25_)
            {
               _loc27_ = _loc10_;
            }
            _loc16_ = _loc27_ + this._paddingTop + this._paddingBottom;
            _loc28_ = 0;
            if(this._backgroundSkin !== null)
            {
               _loc28_ = this._backgroundSkin.height;
            }
            if(_loc28_ > _loc16_)
            {
               _loc16_ = _loc28_;
            }
            _loc16_ += _loc12_;
            if(_loc16_ > _loc7_)
            {
               _loc16_ = _loc7_;
            }
         }
         var _loc17_:Number = this._explicitMinWidth;
         if(_loc4_)
         {
            _loc29_ = 0;
            if(_loc14_ !== null)
            {
               _loc29_ = _loc14_.minWidth;
            }
            else if(this._content !== null)
            {
               _loc29_ = this._content.width;
            }
            if(_loc11_ > _loc29_)
            {
               _loc29_ = _loc11_;
            }
            _loc17_ = _loc29_ + this._paddingLeft + this._paddingRight;
            _loc30_ = 0;
            if(_loc8_ !== null)
            {
               _loc30_ = _loc8_.minWidth;
            }
            else if(this._backgroundSkin !== null)
            {
               _loc30_ = this._explicitBackgroundSkinMinWidth;
            }
            if(_loc30_ > _loc17_)
            {
               _loc17_ = _loc30_;
            }
            _loc17_ += _loc9_;
            if(_loc17_ > _loc6_)
            {
               _loc17_ = _loc6_;
            }
         }
         var _loc18_:Number = this._explicitHeight;
         if(_loc5_)
         {
            _loc31_ = 0;
            if(_loc14_ !== null)
            {
               _loc31_ = _loc14_.minHeight;
            }
            else if(this._content !== null)
            {
               _loc31_ = this._content.height;
            }
            if(_loc10_ > _loc31_)
            {
               _loc31_ = _loc10_;
            }
            _loc18_ = _loc31_ + this._paddingTop + this._paddingBottom;
            _loc32_ = 0;
            if(_loc8_ !== null)
            {
               _loc32_ = _loc8_.minHeight;
            }
            else if(this._backgroundSkin !== null)
            {
               _loc32_ = this._explicitBackgroundSkinMinHeight;
            }
            if(_loc32_ > _loc18_)
            {
               _loc18_ = _loc32_;
            }
            _loc18_ += _loc12_;
            if(_loc18_ > _loc7_)
            {
               _loc18_ = _loc7_;
            }
         }
         if(this._backgroundSkin !== null)
         {
            this._backgroundSkin.width = _loc21_;
            this._backgroundSkin.height = _loc22_;
         }
         if(this._content !== null)
         {
            _loc13_ = this._ignoreContentResize;
            this._ignoreContentResize = true;
            this._content.width = _loc23_;
            this._content.height = _loc24_;
            this._ignoreContentResize = _loc13_;
         }
         return this.saveMeasurements(_loc15_,_loc16_,_loc17_,_loc18_);
      }
      
      protected function refreshArrowSkin() : void
      {
         this.currentArrowSkin = null;
         if(this._arrowPosition == RelativePosition.BOTTOM)
         {
            this.currentArrowSkin = this._bottomArrowSkin;
         }
         else if(this._bottomArrowSkin)
         {
            this._bottomArrowSkin.visible = false;
         }
         if(this._arrowPosition == RelativePosition.TOP)
         {
            this.currentArrowSkin = this._topArrowSkin;
         }
         else if(this._topArrowSkin)
         {
            this._topArrowSkin.visible = false;
         }
         if(this._arrowPosition == RelativePosition.LEFT)
         {
            this.currentArrowSkin = this._leftArrowSkin;
         }
         else if(this._leftArrowSkin)
         {
            this._leftArrowSkin.visible = false;
         }
         if(this._arrowPosition == RelativePosition.RIGHT)
         {
            this.currentArrowSkin = this._rightArrowSkin;
         }
         else if(this._rightArrowSkin)
         {
            this._rightArrowSkin.visible = false;
         }
         if(this.currentArrowSkin)
         {
            this.currentArrowSkin.visible = true;
         }
      }
      
      protected function refreshEnabled() : void
      {
         if(this._content is IFeathersControl)
         {
            IFeathersControl(this._content).isEnabled = this._isEnabled;
         }
      }
      
      protected function layoutChildren() : void
      {
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Boolean = false;
         var _loc1_:Number = 0;
         if(this._leftArrowSkin !== null && this._arrowPosition === RelativePosition.LEFT)
         {
            _loc1_ = this._leftArrowSkin.width + this._leftArrowGap;
         }
         var _loc2_:Number = 0;
         if(this._topArrowSkin !== null && this._arrowPosition === RelativePosition.TOP)
         {
            _loc2_ = this._topArrowSkin.height + this._topArrowGap;
         }
         var _loc3_:Number = 0;
         if(this._rightArrowSkin !== null && this._arrowPosition === RelativePosition.RIGHT)
         {
            _loc3_ = this._rightArrowSkin.width + this._rightArrowGap;
         }
         var _loc4_:Number = 0;
         if(this._bottomArrowSkin !== null && this._arrowPosition === RelativePosition.BOTTOM)
         {
            _loc4_ = this._bottomArrowSkin.height + this._bottomArrowGap;
         }
         var _loc5_:Number = this.actualWidth - _loc1_ - _loc3_;
         var _loc6_:Number = this.actualHeight - _loc2_ - _loc4_;
         if(this._backgroundSkin !== null)
         {
            this._backgroundSkin.x = _loc1_;
            this._backgroundSkin.y = _loc2_;
            this._backgroundSkin.width = _loc5_;
            this._backgroundSkin.height = _loc6_;
         }
         if(this.currentArrowSkin !== null)
         {
            _loc7_ = _loc5_ - this._paddingLeft - this._paddingRight;
            _loc8_ = _loc6_ - this._paddingTop - this._paddingBottom;
            if(this._arrowPosition === RelativePosition.LEFT)
            {
               this._leftArrowSkin.x = _loc1_ - this._leftArrowSkin.width - this._leftArrowGap;
               _loc9_ = this._arrowOffset + _loc2_ + this._paddingTop;
               if(this._verticalAlign === VerticalAlign.MIDDLE)
               {
                  _loc9_ += Math.round((_loc8_ - this._leftArrowSkin.height) / 2);
               }
               else if(this._verticalAlign === VerticalAlign.BOTTOM)
               {
                  _loc9_ += _loc8_ - this._leftArrowSkin.height;
               }
               _loc10_ = _loc2_ + this._paddingTop;
               if(_loc10_ > _loc9_)
               {
                  _loc9_ = _loc10_;
               }
               else
               {
                  _loc11_ = _loc2_ + this._paddingTop + _loc8_ - this._leftArrowSkin.height;
                  if(_loc11_ < _loc9_)
                  {
                     _loc9_ = _loc11_;
                  }
               }
               this._leftArrowSkin.y = _loc9_;
            }
            else if(this._arrowPosition === RelativePosition.RIGHT)
            {
               this._rightArrowSkin.x = _loc1_ + _loc5_ + this._rightArrowGap;
               _loc12_ = this._arrowOffset + _loc2_ + this._paddingTop;
               if(this._verticalAlign === VerticalAlign.MIDDLE)
               {
                  _loc12_ += Math.round((_loc8_ - this._rightArrowSkin.height) / 2);
               }
               else if(this._verticalAlign === VerticalAlign.BOTTOM)
               {
                  _loc12_ += _loc8_ - this._rightArrowSkin.height;
               }
               _loc13_ = _loc2_ + this._paddingTop;
               if(_loc13_ > _loc12_)
               {
                  _loc12_ = _loc13_;
               }
               else
               {
                  _loc14_ = _loc2_ + this._paddingTop + _loc8_ - this._rightArrowSkin.height;
                  if(_loc14_ < _loc12_)
                  {
                     _loc12_ = _loc14_;
                  }
               }
               this._rightArrowSkin.y = _loc12_;
            }
            else if(this._arrowPosition === RelativePosition.BOTTOM)
            {
               _loc15_ = this._arrowOffset + _loc1_ + this._paddingLeft;
               if(this._horizontalAlign === HorizontalAlign.CENTER)
               {
                  _loc15_ += Math.round((_loc7_ - this._bottomArrowSkin.width) / 2);
               }
               else if(this._horizontalAlign === HorizontalAlign.RIGHT)
               {
                  _loc15_ += _loc7_ - this._bottomArrowSkin.width;
               }
               _loc16_ = _loc1_ + this._paddingLeft;
               if(_loc16_ > _loc15_)
               {
                  _loc15_ = _loc16_;
               }
               else
               {
                  _loc17_ = _loc1_ + this._paddingLeft + _loc7_ - this._bottomArrowSkin.width;
                  if(_loc17_ < _loc15_)
                  {
                     _loc15_ = _loc17_;
                  }
               }
               this._bottomArrowSkin.x = _loc15_;
               this._bottomArrowSkin.y = _loc2_ + _loc6_ + this._bottomArrowGap;
            }
            else
            {
               _loc18_ = this._arrowOffset + _loc1_ + this._paddingLeft;
               if(this._horizontalAlign === HorizontalAlign.CENTER)
               {
                  _loc18_ += Math.round((_loc7_ - this._topArrowSkin.width) / 2);
               }
               else if(this._horizontalAlign === HorizontalAlign.RIGHT)
               {
                  _loc18_ += _loc7_ - this._topArrowSkin.width;
               }
               _loc19_ = _loc1_ + this._paddingLeft;
               if(_loc19_ > _loc18_)
               {
                  _loc18_ = _loc19_;
               }
               else
               {
                  _loc20_ = _loc1_ + this._paddingLeft + _loc7_ - this._topArrowSkin.width;
                  if(_loc20_ < _loc18_)
                  {
                     _loc18_ = _loc20_;
                  }
               }
               this._topArrowSkin.x = _loc18_;
               this._topArrowSkin.y = _loc2_ - this._topArrowSkin.height - this._topArrowGap;
            }
         }
         if(this._content !== null)
         {
            this._content.x = _loc1_ + this._paddingLeft;
            this._content.y = _loc2_ + this._paddingTop;
            _loc21_ = this._ignoreContentResize;
            this._ignoreContentResize = true;
            this._content.width = _loc5_ - this._paddingLeft - this._paddingRight;
            this._content.height = _loc6_ - this._paddingTop - this._paddingBottom;
            if(this._content is IValidating)
            {
               IValidating(this._content).validate();
            }
            this._ignoreContentResize = _loc21_;
         }
      }
      
      protected function positionRelativeToOrigin() : void
      {
         var _loc11_:String = null;
         if(this._origin === null)
         {
            return;
         }
         var _loc1_:Stage = this.stage !== null ? this.stage : Starling.current.stage;
         var _loc2_:flash.geom.Rectangle = Pool.getRectangle();
         this._origin.getBounds(_loc1_,_loc2_);
         var _loc3_:Boolean = this._lastGlobalBoundsOfOrigin != null;
         if(_loc3_ && this._lastGlobalBoundsOfOrigin.equals(_loc2_))
         {
            Pool.putRectangle(_loc2_);
            return;
         }
         if(!_loc3_)
         {
            this._lastGlobalBoundsOfOrigin = new flash.geom.Rectangle();
         }
         this._lastGlobalBoundsOfOrigin.x = _loc2_.x;
         this._lastGlobalBoundsOfOrigin.y = _loc2_.y;
         this._lastGlobalBoundsOfOrigin.width = _loc2_.width;
         this._lastGlobalBoundsOfOrigin.height = _loc2_.height;
         Pool.putRectangle(_loc2_);
         var _loc4_:Vector.<String> = this._supportedPositions;
         if(_loc4_ === null)
         {
            _loc4_ = DEFAULT_POSITIONS;
         }
         var _loc5_:Number = -1;
         var _loc6_:Number = -1;
         var _loc7_:Number = -1;
         var _loc8_:Number = -1;
         var _loc9_:int = int(_loc4_.length);
         var _loc10_:int = 0;
         while(_loc10_ < _loc9_)
         {
            _loc11_ = _loc4_[_loc10_];
            switch(_loc11_)
            {
               case RelativePosition.TOP:
                  this.measureWithArrowPosition(RelativePosition.BOTTOM);
                  _loc5_ = this._lastGlobalBoundsOfOrigin.y - this.actualHeight;
                  if(_loc5_ >= stagePaddingTop)
                  {
                     positionAboveOrigin(this,this._lastGlobalBoundsOfOrigin);
                     return;
                  }
                  if(_loc5_ < 0)
                  {
                     _loc5_ = 0;
                  }
                  break;
               case RelativePosition.RIGHT:
                  this.measureWithArrowPosition(RelativePosition.LEFT);
                  _loc6_ = _loc1_.stageWidth - actualWidth - (this._lastGlobalBoundsOfOrigin.x + this._lastGlobalBoundsOfOrigin.width);
                  if(_loc6_ >= stagePaddingRight)
                  {
                     positionToRightOfOrigin(this,this._lastGlobalBoundsOfOrigin);
                     return;
                  }
                  if(_loc6_ < 0)
                  {
                     _loc6_ = 0;
                  }
                  break;
               case RelativePosition.LEFT:
                  this.measureWithArrowPosition(RelativePosition.RIGHT);
                  _loc8_ = this._lastGlobalBoundsOfOrigin.x - this.actualWidth;
                  if(_loc8_ >= stagePaddingLeft)
                  {
                     positionToLeftOfOrigin(this,this._lastGlobalBoundsOfOrigin);
                     return;
                  }
                  if(_loc8_ < 0)
                  {
                     _loc8_ = 0;
                  }
                  break;
               default:
                  this.measureWithArrowPosition(RelativePosition.TOP);
                  _loc7_ = _loc1_.stageHeight - this.actualHeight - (this._lastGlobalBoundsOfOrigin.y + this._lastGlobalBoundsOfOrigin.height);
                  if(_loc7_ >= stagePaddingBottom)
                  {
                     positionBelowOrigin(this,this._lastGlobalBoundsOfOrigin);
                     return;
                  }
                  if(_loc7_ < 0)
                  {
                     _loc7_ = 0;
                  }
            }
            _loc10_++;
         }
         if(_loc7_ != -1 && _loc7_ >= _loc5_ && _loc7_ >= _loc6_ && _loc7_ >= _loc8_)
         {
            positionBelowOrigin(this,this._lastGlobalBoundsOfOrigin);
         }
         else if(_loc5_ != -1 && _loc5_ >= _loc6_ && _loc5_ >= _loc8_)
         {
            positionAboveOrigin(this,this._lastGlobalBoundsOfOrigin);
         }
         else if(_loc6_ != -1 && _loc6_ >= _loc8_)
         {
            positionToRightOfOrigin(this,this._lastGlobalBoundsOfOrigin);
         }
         else
         {
            positionToLeftOfOrigin(this,this._lastGlobalBoundsOfOrigin);
         }
      }
      
      protected function callout_addedToStageHandler(param1:Event) : void
      {
         var _loc2_:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         var _loc3_:int = -getDisplayObjectDepthFromStage(this);
         _loc2_.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN,this.callout_nativeStage_keyDownHandler,false,_loc3_,true);
         this.stage.addEventListener(TouchEvent.TOUCH,this.stage_touchHandler);
         this._isReadyToClose = false;
         this.addEventListener(EnterFrameEvent.ENTER_FRAME,this.callout_oneEnterFrameHandler);
      }
      
      protected function callout_removedFromStageHandler(param1:Event) : void
      {
         this.stage.removeEventListener(TouchEvent.TOUCH,this.stage_touchHandler);
         var _loc2_:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         _loc2_.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN,this.callout_nativeStage_keyDownHandler);
      }
      
      protected function callout_oneEnterFrameHandler(param1:Event) : void
      {
         this.removeEventListener(EnterFrameEvent.ENTER_FRAME,this.callout_oneEnterFrameHandler);
         this._isReadyToClose = true;
      }
      
      protected function callout_enterFrameHandler(param1:EnterFrameEvent) : void
      {
         this.positionRelativeToOrigin();
      }
      
      protected function stage_touchHandler(param1:TouchEvent) : void
      {
         var _loc3_:Touch = null;
         var _loc2_:DisplayObject = DisplayObject(param1.target);
         if(!this._isReadyToClose || !this.closeOnTouchEndedOutside && !this.closeOnTouchBeganOutside || this.contains(_loc2_) || PopUpManager.isPopUp(this) && !PopUpManager.isTopLevelPopUp(this))
         {
            return;
         }
         if(this._origin == _loc2_ || this._origin is DisplayObjectContainer && DisplayObjectContainer(this._origin).contains(_loc2_))
         {
            return;
         }
         if(this.closeOnTouchBeganOutside)
         {
            _loc3_ = param1.getTouch(this.stage,TouchPhase.BEGAN);
            if(_loc3_)
            {
               this.close(this.disposeOnSelfClose);
               return;
            }
         }
         if(this.closeOnTouchEndedOutside)
         {
            _loc3_ = param1.getTouch(this.stage,TouchPhase.ENDED);
            if(_loc3_)
            {
               this.close(this.disposeOnSelfClose);
               return;
            }
         }
      }
      
      protected function callout_nativeStage_keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.isDefaultPrevented())
         {
            return;
         }
         if(!this.closeOnKeys || this.closeOnKeys.indexOf(param1.keyCode) < 0)
         {
            return;
         }
         param1.preventDefault();
         this.close(this.disposeOnSelfClose);
      }
      
      protected function origin_removedFromStageHandler(param1:Event) : void
      {
         this.close(this.disposeOnSelfClose);
      }
      
      protected function content_resizeHandler(param1:Event) : void
      {
         if(this._ignoreContentResize)
         {
            return;
         }
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
   }
}

