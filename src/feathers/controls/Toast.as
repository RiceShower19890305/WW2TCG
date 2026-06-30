package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.ITextRenderer;
   import feathers.core.IValidating;
   import feathers.core.PopUpManager;
   import feathers.data.IListCollection;
   import feathers.layout.HorizontalAlign;
   import feathers.layout.RelativePosition;
   import feathers.layout.VerticalAlign;
   import feathers.layout.VerticalLayout;
   import feathers.motion.Fade;
   import feathers.motion.effectClasses.IEffectContext;
   import feathers.skins.IStyleProvider;
   import feathers.system.DeviceCapabilities;
   import feathers.text.FontStylesSet;
   import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.events.Event;
   import starling.text.TextFormat;
   import starling.utils.Pool;
   
   public class Toast extends FeathersControl
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      public static const DEFAULT_CHILD_STYLE_NAME_MESSAGE:String = "feathers-toast-message";
      
      public static const DEFAULT_CHILD_STYLE_NAME_ACTIONS:String = "feathers-toast-actions";
      
      protected static const INVALIDATION_FLAG_ACTIONS_FACTORY:String = "actionsFactory";
      
      private static var _maxVisibleToasts:int = 1;
      
      private static var _queueMode:String = ToastQueueMode.CANCEL_TIMEOUT;
      
      private static var _toastFactory:Function = defaultToastFactory;
      
      private static var _containerFactory:Function = defaultContainerFactory;
      
      protected static var _activeToasts:Vector.<Toast> = new Vector.<Toast>(0);
      
      protected static var _queue:Vector.<Toast> = new Vector.<Toast>(0);
      
      protected static var _containers:Dictionary = new Dictionary(true);
      
      protected var messageStyleName:String = "feathers-toast-message";
      
      protected var actionsStyleName:String = "feathers-toast-actions";
      
      protected var messageTextRenderer:ITextRenderer = null;
      
      protected var actionsGroup:ButtonGroup = null;
      
      protected var _explicitMessageWidth:Number;
      
      protected var _explicitMessageHeight:Number;
      
      protected var _explicitMessageMinWidth:Number;
      
      protected var _explicitMessageMinHeight:Number;
      
      protected var _explicitMessageMaxWidth:Number;
      
      protected var _explicitMessageMaxHeight:Number;
      
      protected var _message:String = null;
      
      protected var _actions:IListCollection = null;
      
      protected var _explicitContentWidth:Number;
      
      protected var _explicitContentHeight:Number;
      
      protected var _explicitContentMinWidth:Number;
      
      protected var _explicitContentMinHeight:Number;
      
      protected var _explicitContentMaxWidth:Number;
      
      protected var _explicitContentMaxHeight:Number;
      
      protected var _content:DisplayObject = null;
      
      protected var _startTime:int = -1;
      
      protected var _timeout:Number = Infinity;
      
      protected var _openEffectContext:IEffectContext = null;
      
      protected var _openEffect:Function = Fade.createFadeInEffect();
      
      protected var _closeEffectContext:IEffectContext = null;
      
      protected var _closeEffect:Function = Fade.createFadeOutEffect();
      
      protected var _fontStylesSet:FontStylesSet = null;
      
      protected var _messageFactory:Function = null;
      
      protected var _customMessageStyleName:String;
      
      protected var _actionsFactory:Function = null;
      
      protected var _customActionsStyleName:String = null;
      
      protected var _disposeFromCloseCall:Boolean = false;
      
      protected var _disposeOnSelfClose:Boolean = true;
      
      public var _disposeContent:Boolean = true;
      
      protected var _closeData:Object = null;
      
      protected var _isClosing:Boolean = false;
      
      protected var _isOpening:Boolean = false;
      
      protected var _isOpen:Boolean = false;
      
      protected var _explicitBackgroundSkinWidth:Number;
      
      protected var _explicitBackgroundSkinHeight:Number;
      
      protected var _explicitBackgroundSkinMinWidth:Number;
      
      protected var _explicitBackgroundSkinMinHeight:Number;
      
      protected var _explicitBackgroundSkinMaxWidth:Number;
      
      protected var _explicitBackgroundSkinMaxHeight:Number;
      
      protected var _backgroundSkin:DisplayObject;
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var _horizontalAlign:String = "center";
      
      protected var _verticalAlign:String = "middle";
      
      protected var _gap:Number = 0;
      
      protected var _minGap:Number = 0;
      
      protected var _actionsPosition:String = "right";
      
      public function Toast()
      {
         super();
         if(this._fontStylesSet === null)
         {
            this._fontStylesSet = new FontStylesSet();
            this._fontStylesSet.addEventListener(Event.CHANGE,this.fontStyles_changeHandler);
         }
      }
      
      public static function get maxVisibleToasts() : int
      {
         return _maxVisibleToasts;
      }
      
      public static function set maxVisibleToasts(param1:int) : void
      {
         if(_maxVisibleToasts == param1)
         {
            return;
         }
         if(param1 <= 0)
         {
            throw new RangeError("maxVisibleToasts must be greater than 0.");
         }
         _maxVisibleToasts = param1;
         while(_activeToasts.length < _maxVisibleToasts && _queue.length > 0)
         {
            showNextInQueue();
         }
      }
      
      public static function get queueMode() : String
      {
         return _queueMode;
      }
      
      public static function set queueMode(param1:String) : void
      {
         _queueMode = param1;
      }
      
      public static function get toastFactory() : Function
      {
         return Toast._toastFactory;
      }
      
      public static function set toastFactory(param1:Function) : void
      {
         Toast._toastFactory = param1;
      }
      
      public static function get containerFactory() : Function
      {
         return Toast._containerFactory;
      }
      
      public static function set containerFactory(param1:Function) : void
      {
         Toast._containerFactory = param1;
      }
      
      public static function showContent(param1:DisplayObject, param2:Number = 4, param3:Function = null) : Toast
      {
         var _loc4_:Function = param3 !== null ? param3 : Toast._toastFactory;
         if(_loc4_ === null)
         {
            _loc4_ = defaultToastFactory;
         }
         var _loc5_:Toast = Toast(_loc4_());
         _loc5_.content = param1;
         return showToast(_loc5_,param2);
      }
      
      public static function showMessage(param1:String, param2:Number = 4, param3:Function = null) : Toast
      {
         var _loc4_:Function = param3 !== null ? param3 : Toast._toastFactory;
         if(_loc4_ === null)
         {
            _loc4_ = defaultToastFactory;
         }
         var _loc5_:Toast = Toast(_loc4_());
         _loc5_.message = param1;
         return showToast(_loc5_,param2);
      }
      
      public static function showMessageWithActions(param1:String, param2:IListCollection, param3:Number = 4, param4:Function = null) : Toast
      {
         var _loc5_:Function = param4 !== null ? param4 : Toast._toastFactory;
         if(_loc5_ === null)
         {
            _loc5_ = defaultToastFactory;
         }
         var _loc6_:Toast = Toast(_loc5_());
         _loc6_.message = param1;
         _loc6_.actions = param2;
         return showToast(_loc6_,param3);
      }
      
      public static function showToast(param1:Toast, param2:Number) : Toast
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Toast = null;
         param1.timeout = param2;
         if(_activeToasts.length >= _maxVisibleToasts)
         {
            _queue[_queue.length] = param1;
            if(_queueMode == ToastQueueMode.CANCEL_TIMEOUT)
            {
               _loc4_ = int(_activeToasts.length);
               _loc5_ = 0;
               while(_loc5_ < _loc4_)
               {
                  _loc6_ = _activeToasts[_loc5_];
                  if(_loc6_.timeout < Number.POSITIVE_INFINITY && !_loc6_.isClosing)
                  {
                     _loc6_.close(_loc6_.disposeOnSelfClose);
                     break;
                  }
                  _loc5_++;
               }
            }
            return param1;
         }
         _activeToasts[_activeToasts.length] = param1;
         param1.addEventListener(Event.CLOSE,toast_closeHandler);
         var _loc3_:DisplayObjectContainer = getContainerForStarling(Starling.current);
         _loc3_.addChild(param1);
         if(_loc3_ is IValidating)
         {
            IValidating(_loc3_).validate();
         }
         param1.open();
         return param1;
      }
      
      protected static function showNextInQueue() : void
      {
         var _loc1_:Toast = null;
         if(_queue.length == 0)
         {
            return;
         }
         do
         {
            _loc1_ = _queue.shift();
         }
         while(_queueMode == ToastQueueMode.CANCEL_TIMEOUT && _queue.length > 0 && _loc1_.timeout < Number.POSITIVE_INFINITY);
         showToast(_loc1_,_loc1_.timeout);
      }
      
      protected static function toast_closeHandler(param1:Event) : void
      {
         var _loc2_:Toast = Toast(param1.currentTarget);
         _loc2_.removeEventListener(Event.CLOSE,toast_closeHandler);
         var _loc3_:int = _activeToasts.indexOf(_loc2_);
         _activeToasts.removeAt(_loc3_);
         showNextInQueue();
      }
      
      protected static function getContainerForStarling(param1:Starling) : DisplayObjectContainer
      {
         var factory:Function;
         var container:DisplayObjectContainer;
         var starling:Starling = param1;
         if(starling in Toast._containers)
         {
            return DisplayObjectContainer(Toast._containers[starling]);
         }
         factory = Toast._containerFactory !== null ? Toast._containerFactory : defaultContainerFactory;
         container = DisplayObjectContainer(factory());
         Toast._containers[starling] = container;
         container.addEventListener(Event.REMOVED_FROM_STAGE,function(param1:Event):void
         {
            delete Toast._containers[starling];
         });
         PopUpManager.forStarling(starling).addPopUp(container,false,false);
         return container;
      }
      
      protected static function defaultToastFactory() : Toast
      {
         return new Toast();
      }
      
      protected static function defaultContainerFactory() : DisplayObjectContainer
      {
         var _loc1_:LayoutGroup = new LayoutGroup();
         _loc1_.autoSizeMode = AutoSizeMode.STAGE;
         var _loc2_:VerticalLayout = new VerticalLayout();
         _loc2_.verticalAlign = VerticalAlign.BOTTOM;
         if(DeviceCapabilities.isPhone())
         {
            _loc2_.horizontalAlign = HorizontalAlign.JUSTIFY;
         }
         else
         {
            _loc2_.horizontalAlign = HorizontalAlign.LEFT;
         }
         _loc1_.layout = _loc2_;
         return _loc1_;
      }
      
      public static function defaultActionsFactory() : ButtonGroup
      {
         return new ButtonGroup();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return Toast.globalStyleProvider;
      }
      
      public function get message() : String
      {
         return this._message;
      }
      
      public function set message(param1:String) : void
      {
         if(this._message == param1)
         {
            return;
         }
         this._message = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get actions() : IListCollection
      {
         return this._actions;
      }
      
      public function set actions(param1:IListCollection) : void
      {
         if(this._actions == param1)
         {
            return;
         }
         this._actions = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
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
         if(Boolean(this._content) && this._content.parent == this)
         {
            this._content.removeFromParent(false);
         }
         this._content = param1;
         if(this._content)
         {
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
            this.addChild(this._content);
         }
         this.invalidate(INVALIDATION_FLAG_DATA);
         this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
         this.invalidate(INVALIDATION_FLAG_ACTIONS_FACTORY);
      }
      
      public function get timeout() : Number
      {
         return this._timeout;
      }
      
      public function set timeout(param1:Number) : void
      {
         if(this._timeout == param1)
         {
            return;
         }
         this._timeout = param1;
         if(this._isOpen)
         {
            this.startTimeout();
         }
      }
      
      public function get openEffect() : Function
      {
         return this._openEffect;
      }
      
      public function set openEffect(param1:Function) : void
      {
         if(this._openEffect == param1)
         {
            return;
         }
         this._openEffect = param1;
      }
      
      public function get closeEffect() : Function
      {
         return this._closeEffect;
      }
      
      public function set closeEffect(param1:Function) : void
      {
         if(this._closeEffect == param1)
         {
            return;
         }
         this._closeEffect = param1;
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
      
      public function get messageFactory() : Function
      {
         return this._messageFactory;
      }
      
      public function set messageFactory(param1:Function) : void
      {
         if(this._messageFactory == param1)
         {
            return;
         }
         this._messageFactory = param1;
         this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
      }
      
      public function get customMessageStyleName() : String
      {
         return this._customMessageStyleName;
      }
      
      public function set customMessageStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customMessageStyleName === param1)
         {
            return;
         }
         this._customMessageStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
      }
      
      public function get actionsFactory() : Function
      {
         return this._actionsFactory;
      }
      
      public function set actionsFactory(param1:Function) : void
      {
         if(this._actionsFactory == param1)
         {
            return;
         }
         this._actionsFactory = param1;
         this.invalidate(INVALIDATION_FLAG_ACTIONS_FACTORY);
      }
      
      public function get customActionsStyleName() : String
      {
         return this._customActionsStyleName;
      }
      
      public function set customActionsStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customActionsStyleName === param1)
         {
            return;
         }
         this._customActionsStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_ACTIONS_FACTORY);
      }
      
      public function get disposeOnSelfClose() : Boolean
      {
         return this._disposeOnSelfClose;
      }
      
      public function set disposeOnSelfClose(param1:Boolean) : void
      {
         this._disposeOnSelfClose = param1;
      }
      
      public function get disposeContent() : Boolean
      {
         return this._disposeContent;
      }
      
      public function set disposeContent(param1:Boolean) : void
      {
         this._disposeContent = param1;
      }
      
      public function get isClosing() : Boolean
      {
         return this._isClosing;
      }
      
      public function get isOpening() : Boolean
      {
         return this._isOpening;
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
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
      
      public function get actionsPosition() : String
      {
         return this._actionsPosition;
      }
      
      public function set actionsPosition(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._actionsPosition === param1)
         {
            return;
         }
         this._actionsPosition = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      override public function dispose() : void
      {
         if(this._fontStylesSet !== null)
         {
            this._fontStylesSet.dispose();
            this._fontStylesSet = null;
         }
         var _loc1_:DisplayObject = this._content;
         this.content = null;
         if(_loc1_ !== null && this._disposeContent)
         {
            _loc1_.dispose();
         }
         super.dispose();
      }
      
      protected function open() : void
      {
         if(this._isOpen || this._isOpening)
         {
            return;
         }
         if(this._suspendEffectsCount == 0 && this._closeEffectContext !== null)
         {
            this._closeEffectContext.interrupt();
            this._closeEffectContext = null;
         }
         if(this._openEffect !== null)
         {
            this._isOpening = true;
            this._openEffectContext = IEffectContext(this._openEffect(this));
            this._openEffectContext.addEventListener(Event.COMPLETE,this.openEffectContext_completeHandler);
            this._openEffectContext.play();
         }
         else
         {
            this.completeOpen();
         }
      }
      
      public function close(param1:Boolean = true) : void
      {
         this.closeToast(null,param1);
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc4_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         var _loc5_:Boolean = this.isInvalid(INVALIDATION_FLAG_TEXT_RENDERER);
         var _loc6_:Boolean = this.isInvalid(INVALIDATION_FLAG_ACTIONS_FACTORY);
         if(_loc5_)
         {
            this.createMessage();
         }
         if(_loc6_)
         {
            this.createActions();
         }
         if(_loc5_ || _loc1_)
         {
            if(this.messageTextRenderer)
            {
               this.messageTextRenderer.text = this._message;
            }
         }
         if(_loc5_ || _loc3_)
         {
            this.refreshMessageStyles();
         }
         if(_loc6_ || _loc1_)
         {
            if(this.actionsGroup)
            {
               this.actionsGroup.dataProvider = this._actions;
            }
         }
         _loc2_ = this.autoSizeIfNeeded() || _loc2_;
         this.layoutChildren();
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc1_:Boolean = this._explicitWidth !== this._explicitWidth;
         var _loc2_:Boolean = this._explicitHeight !== this._explicitHeight;
         var _loc3_:Boolean = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc4_:Boolean = this._explicitMinHeight !== this._explicitMinHeight;
         if(!_loc1_ && !_loc2_ && !_loc3_ && !_loc4_)
         {
            return false;
         }
         var _loc5_:Number = this._gap;
         if(_loc5_ == Number.POSITIVE_INFINITY)
         {
            _loc5_ = this._minGap;
         }
         resetFluidChildDimensionsForMeasurement(this._backgroundSkin,this._explicitWidth,this._explicitHeight,this._explicitMinWidth,this._explicitMinHeight,this._explicitMaxWidth,this._explicitMaxHeight,this._explicitBackgroundSkinWidth,this._explicitBackgroundSkinHeight,this._explicitBackgroundSkinMinWidth,this._explicitBackgroundSkinMinHeight,this._explicitBackgroundSkinMaxWidth,this._explicitBackgroundSkinMaxHeight);
         var _loc6_:IMeasureDisplayObject = this._backgroundSkin as IMeasureDisplayObject;
         resetFluidChildDimensionsForMeasurement(this._content,this._explicitWidth,this._explicitHeight,this._explicitMinWidth,this._explicitMinHeight,this._explicitMaxWidth,this._explicitMaxHeight,this._explicitContentWidth,this._explicitContentHeight,this._explicitContentMinWidth,this._explicitContentMinHeight,this._explicitContentMaxWidth,this._explicitContentMaxHeight);
         var _loc7_:IMeasureDisplayObject = this._content as IMeasureDisplayObject;
         if(this._content is IValidating)
         {
            IValidating(this._content).validate();
         }
         var _loc8_:Point = Pool.getPoint();
         if(this.messageTextRenderer !== null)
         {
            this.refreshMessageTextRendererDimensions(true);
            this.messageTextRenderer.measureText(_loc8_);
         }
         if(this.actionsGroup)
         {
            this.actionsGroup.validate();
         }
         if(this._backgroundSkin is IValidating)
         {
            IValidating(this._backgroundSkin).validate();
         }
         var _loc9_:Number = this._explicitMinWidth;
         if(_loc3_)
         {
            if(this._content !== null)
            {
               if(_loc7_ !== null)
               {
                  _loc9_ = _loc7_.minWidth;
               }
               else
               {
                  _loc9_ = this._content.width;
               }
            }
            else if(this.messageTextRenderer !== null)
            {
               _loc9_ = _loc8_.x;
            }
            else
            {
               _loc9_ = 0;
            }
            if(this.actionsGroup !== null)
            {
               if(this.messageTextRenderer !== null)
               {
                  if(this._actionsPosition !== RelativePosition.TOP && this._actionsPosition !== RelativePosition.BOTTOM)
                  {
                     _loc9_ += _loc5_;
                     _loc9_ = _loc9_ + this.actionsGroup.minWidth;
                  }
                  else
                  {
                     _loc13_ = this.actionsGroup.minWidth;
                     if(_loc13_ > _loc9_)
                     {
                        _loc9_ = _loc13_;
                     }
                  }
               }
               else
               {
                  _loc9_ = this.actionsGroup.minWidth;
               }
            }
            _loc9_ += this._paddingLeft + this._paddingRight;
            if(this._backgroundSkin !== null)
            {
               if(_loc6_ !== null)
               {
                  if(_loc6_.minWidth > _loc9_)
                  {
                     _loc9_ = _loc6_.minWidth;
                  }
               }
               else if(this._explicitBackgroundSkinMinWidth > _loc9_)
               {
                  _loc9_ = this._explicitBackgroundSkinMinWidth;
               }
            }
         }
         var _loc10_:Number = this._explicitMinHeight;
         if(_loc4_)
         {
            if(this._content !== null)
            {
               if(_loc7_ !== null)
               {
                  _loc10_ = _loc7_.minHeight;
               }
               else
               {
                  _loc10_ = this._content.height;
               }
            }
            else if(this.messageTextRenderer !== null)
            {
               _loc10_ = _loc8_.y;
            }
            else
            {
               _loc10_ = 0;
            }
            if(this.actionsGroup !== null)
            {
               if(this.messageTextRenderer !== null)
               {
                  if(this._actionsPosition === RelativePosition.TOP || this._actionsPosition === RelativePosition.BOTTOM)
                  {
                     _loc10_ += _loc5_;
                     _loc10_ = _loc10_ + this.actionsGroup.minHeight;
                  }
                  else
                  {
                     _loc14_ = this.actionsGroup.minHeight;
                     if(_loc14_ > _loc10_)
                     {
                        _loc10_ = _loc14_;
                     }
                  }
               }
               else
               {
                  _loc10_ = this.actionsGroup.minHeight;
               }
            }
            _loc10_ += this._paddingTop + this._paddingBottom;
            if(this._backgroundSkin !== null)
            {
               if(_loc6_ !== null)
               {
                  if(_loc6_.minHeight > _loc10_)
                  {
                     _loc10_ = _loc6_.minHeight;
                  }
               }
               else if(this._explicitBackgroundSkinMinHeight > _loc10_)
               {
                  _loc10_ = this._explicitBackgroundSkinMinHeight;
               }
            }
         }
         var _loc11_:Number = this._explicitWidth;
         if(_loc1_)
         {
            if(this._content !== null)
            {
               _loc11_ = this._content.width;
            }
            else if(this.messageTextRenderer !== null)
            {
               _loc11_ = _loc8_.x;
            }
            else
            {
               _loc11_ = 0;
            }
            if(this.actionsGroup !== null)
            {
               if(this.messageTextRenderer !== null)
               {
                  if(this._actionsPosition !== RelativePosition.TOP && this._actionsPosition !== RelativePosition.BOTTOM)
                  {
                     _loc11_ += _loc5_ + this.actionsGroup.width;
                  }
                  else if(this.actionsGroup.width > _loc11_)
                  {
                     _loc11_ = this.actionsGroup.width;
                  }
               }
               else
               {
                  _loc11_ = this.actionsGroup.width;
               }
            }
            _loc11_ += this._paddingLeft + this._paddingRight;
            if(this._backgroundSkin !== null && this._backgroundSkin.width > _loc11_)
            {
               _loc11_ = this._backgroundSkin.width;
            }
         }
         var _loc12_:Number = this._explicitHeight;
         if(_loc2_)
         {
            if(this._content !== null)
            {
               _loc12_ = this._content.height;
            }
            else if(this.messageTextRenderer !== null)
            {
               _loc12_ = _loc8_.y;
            }
            else
            {
               _loc12_ = 0;
            }
            if(this.actionsGroup !== null)
            {
               if(this.messageTextRenderer !== null)
               {
                  if(this._actionsPosition === RelativePosition.TOP || this._actionsPosition === RelativePosition.BOTTOM)
                  {
                     _loc12_ += _loc5_ + this.actionsGroup.height;
                  }
                  else if(this.actionsGroup.height > _loc12_)
                  {
                     _loc12_ = this.actionsGroup.height;
                  }
               }
               else
               {
                  _loc12_ = this.actionsGroup.height;
               }
            }
            _loc12_ += this._paddingTop + this._paddingBottom;
            if(this._backgroundSkin !== null && this._backgroundSkin.height > _loc12_)
            {
               _loc12_ = this._backgroundSkin.height;
            }
         }
         Pool.putPoint(_loc8_);
         return this.saveMeasurements(_loc11_,_loc12_,_loc9_,_loc10_);
      }
      
      protected function refreshMessageTextRendererDimensions(param1:Boolean) : void
      {
         var _loc4_:Number = NaN;
         if(this.actionsGroup !== null)
         {
            this.actionsGroup.validate();
         }
         if(!this.messageTextRenderer)
         {
            return;
         }
         var _loc2_:Number = this.actualWidth;
         var _loc3_:Number = this.actualHeight;
         if(param1)
         {
            _loc2_ = this._explicitWidth;
            if(_loc2_ !== _loc2_)
            {
               _loc2_ = this._explicitMaxWidth;
            }
            _loc3_ = this._explicitHeight;
            if(_loc3_ !== _loc3_)
            {
               _loc3_ = this._explicitMaxHeight;
            }
         }
         _loc2_ -= this._paddingLeft + this._paddingRight;
         _loc3_ -= this._paddingTop + this._paddingBottom;
         if(this.actionsGroup !== null)
         {
            _loc4_ = this._gap;
            if(_loc4_ == Number.POSITIVE_INFINITY)
            {
               _loc4_ = this._minGap;
            }
            if(this._actionsPosition === RelativePosition.LEFT || this._actionsPosition === RelativePosition.RIGHT)
            {
               _loc2_ -= this.actionsGroup.width + _loc4_;
            }
            if(this._actionsPosition === RelativePosition.TOP || this._actionsPosition === RelativePosition.BOTTOM)
            {
               _loc3_ -= this.actionsGroup.height + _loc4_;
            }
         }
         if(_loc2_ < 0)
         {
            _loc2_ = 0;
         }
         if(_loc3_ < 0)
         {
            _loc3_ = 0;
         }
         if(_loc2_ > this._explicitMessageMaxWidth)
         {
            _loc2_ = this._explicitMessageMaxWidth;
         }
         if(_loc3_ > this._explicitMessageMaxHeight)
         {
            _loc3_ = this._explicitMessageMaxHeight;
         }
         this.messageTextRenderer.width = this._explicitMessageWidth;
         this.messageTextRenderer.height = this._explicitMessageHeight;
         this.messageTextRenderer.minWidth = this._explicitMessageMinWidth;
         this.messageTextRenderer.minHeight = this._explicitMessageMinHeight;
         this.messageTextRenderer.maxWidth = _loc2_;
         this.messageTextRenderer.maxHeight = _loc3_;
         this.messageTextRenderer.validate();
         if(!param1)
         {
            _loc2_ = Number(this.messageTextRenderer.width);
            _loc3_ = Number(this.messageTextRenderer.height);
            this.messageTextRenderer.width = _loc2_;
            this.messageTextRenderer.height = _loc3_;
            this.messageTextRenderer.minWidth = _loc2_;
            this.messageTextRenderer.minHeight = _loc3_;
         }
      }
      
      protected function createMessage() : void
      {
         if(this.messageTextRenderer)
         {
            this.removeChild(DisplayObject(this.messageTextRenderer),true);
            this.messageTextRenderer = null;
         }
         if(this._message === null)
         {
            return;
         }
         var _loc1_:Function = this._messageFactory != null ? this._messageFactory : FeathersControl.defaultTextRendererFactory;
         this.messageTextRenderer = ITextRenderer(_loc1_());
         this.messageTextRenderer.wordWrap = true;
         var _loc2_:String = this._customMessageStyleName != null ? this._customMessageStyleName : this.messageStyleName;
         var _loc3_:IFeathersControl = IFeathersControl(this.messageTextRenderer);
         _loc3_.styleNameList.add(_loc2_);
         _loc3_.touchable = false;
         this.addChild(DisplayObject(this.messageTextRenderer));
         this._explicitMessageWidth = this.messageTextRenderer.explicitWidth;
         this._explicitMessageHeight = this.messageTextRenderer.explicitHeight;
         this._explicitMessageMinWidth = this.messageTextRenderer.explicitMinWidth;
         this._explicitMessageMinHeight = this.messageTextRenderer.explicitMinHeight;
         this._explicitMessageMaxWidth = this.messageTextRenderer.explicitMaxWidth;
         this._explicitMessageMaxHeight = this.messageTextRenderer.explicitMaxHeight;
      }
      
      protected function refreshMessageStyles() : void
      {
         if(!this.messageTextRenderer)
         {
            return;
         }
         this.messageTextRenderer.fontStyles = this._fontStylesSet;
      }
      
      protected function createActions() : void
      {
         if(this.actionsGroup)
         {
            this.actionsGroup.removeEventListener(Event.TRIGGERED,this.actionsGroup_triggeredHandler);
            this.removeChild(this.actionsGroup,true);
            this.actionsGroup = null;
         }
         if(this._actions === null)
         {
            return;
         }
         var _loc1_:Function = this._actionsFactory !== null ? this._actionsFactory : defaultActionsFactory;
         if(_loc1_ === null)
         {
            return;
         }
         var _loc2_:String = this._customActionsStyleName != null ? this._customActionsStyleName : this.actionsStyleName;
         this.actionsGroup = ButtonGroup(_loc1_());
         this.actionsGroup.styleNameList.add(_loc2_);
         this.actionsGroup.addEventListener(Event.TRIGGERED,this.actionsGroup_triggeredHandler);
         this.addChild(this.actionsGroup);
      }
      
      protected function layoutChildren() : void
      {
         if(this._backgroundSkin)
         {
            this._backgroundSkin.width = this.actualWidth;
            this._backgroundSkin.height = this.actualHeight;
         }
         if(this._content)
         {
            this._content.x = this._paddingLeft;
            this._content.y = this._paddingTop;
            this._content.width = this.actualWidth - this._paddingLeft - this._paddingRight;
            this._content.height = this.actualHeight - this._paddingTop - this._paddingBottom;
         }
         this.refreshMessageTextRendererDimensions(false);
         if(this.actionsGroup)
         {
            this.positionSingleChild(DisplayObject(this.messageTextRenderer));
            this.positionActionsRelativeToMessage();
         }
         else if(this.messageTextRenderer)
         {
            this.positionSingleChild(DisplayObject(this.messageTextRenderer));
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
      
      protected function positionActionsRelativeToMessage() : void
      {
         if(this._actionsPosition == RelativePosition.TOP)
         {
            if(this._gap == Number.POSITIVE_INFINITY)
            {
               this.actionsGroup.y = this._paddingTop;
               this.messageTextRenderer.y = this.actualHeight - this._paddingBottom - this.messageTextRenderer.height;
            }
            else
            {
               if(this._verticalAlign == VerticalAlign.TOP)
               {
                  this.messageTextRenderer.y += this.actionsGroup.height + this._gap;
               }
               else if(this._verticalAlign == VerticalAlign.MIDDLE)
               {
                  this.messageTextRenderer.y += Math.round((this.actionsGroup.height + this._gap) / 2);
               }
               this.actionsGroup.y = this.messageTextRenderer.y - this.actionsGroup.height - this._gap;
            }
         }
         else if(this._actionsPosition == RelativePosition.RIGHT)
         {
            if(this._gap == Number.POSITIVE_INFINITY)
            {
               this.messageTextRenderer.x = this._paddingLeft;
               this.actionsGroup.x = this.actualWidth - this._paddingRight - this.actionsGroup.width;
            }
            else
            {
               if(this._horizontalAlign == HorizontalAlign.RIGHT)
               {
                  this.messageTextRenderer.x -= this.actionsGroup.width + this._gap;
               }
               else if(this._horizontalAlign == HorizontalAlign.CENTER)
               {
                  this.messageTextRenderer.x -= Math.round((this.actionsGroup.width + this._gap) / 2);
               }
               this.actionsGroup.x = this.messageTextRenderer.x + this.messageTextRenderer.width + this._gap;
            }
         }
         else if(this._actionsPosition == RelativePosition.BOTTOM)
         {
            if(this._gap == Number.POSITIVE_INFINITY)
            {
               this.messageTextRenderer.y = this._paddingTop;
               this.actionsGroup.y = this.actualHeight - this._paddingBottom - this.actionsGroup.height;
            }
            else
            {
               if(this._verticalAlign == VerticalAlign.BOTTOM)
               {
                  this.messageTextRenderer.y -= this.actionsGroup.height + this._gap;
               }
               else if(this._verticalAlign == VerticalAlign.MIDDLE)
               {
                  this.messageTextRenderer.y -= Math.round((this.actionsGroup.height + this._gap) / 2);
               }
               this.actionsGroup.y = this.messageTextRenderer.y + this.messageTextRenderer.height + this._gap;
            }
         }
         else if(this._actionsPosition == RelativePosition.LEFT)
         {
            if(this._gap == Number.POSITIVE_INFINITY)
            {
               this.actionsGroup.x = this._paddingLeft;
               this.messageTextRenderer.x = this.actualWidth - this._paddingRight - this.messageTextRenderer.width;
            }
            else
            {
               if(this._horizontalAlign == HorizontalAlign.LEFT)
               {
                  this.messageTextRenderer.x += this._gap + this.actionsGroup.width;
               }
               else if(this._horizontalAlign == HorizontalAlign.CENTER)
               {
                  this.messageTextRenderer.x += Math.round((this._gap + this.actionsGroup.width) / 2);
               }
               this.actionsGroup.x = this.messageTextRenderer.x - this._gap - this.actionsGroup.width;
            }
         }
         if(this._actionsPosition == RelativePosition.LEFT || this._actionsPosition == RelativePosition.RIGHT)
         {
            if(this._verticalAlign == VerticalAlign.TOP)
            {
               this.actionsGroup.y = this._paddingTop;
            }
            else if(this._verticalAlign == VerticalAlign.BOTTOM)
            {
               this.actionsGroup.y = this.actualHeight - this._paddingBottom - this.actionsGroup.height;
            }
            else
            {
               this.actionsGroup.y = this._paddingTop + Math.round((this.actualHeight - this._paddingTop - this._paddingBottom - this.actionsGroup.height) / 2);
            }
         }
         else if(this._horizontalAlign == HorizontalAlign.LEFT)
         {
            this.actionsGroup.x = this._paddingLeft;
         }
         else if(this._horizontalAlign == HorizontalAlign.RIGHT)
         {
            this.actionsGroup.x = this.actualWidth - this._paddingRight - this.actionsGroup.width;
         }
         else
         {
            this.actionsGroup.x = this._paddingLeft + Math.round((this.actualWidth - this._paddingLeft - this._paddingRight - this.actionsGroup.width) / 2);
         }
      }
      
      protected function startTimeout() : void
      {
         if(this._timeout == Number.POSITIVE_INFINITY)
         {
            this.removeEventListener(Event.ENTER_FRAME,this.toast_timeout_enterFrameHandler);
            return;
         }
         this._startTime = getTimer();
         this.addEventListener(Event.ENTER_FRAME,this.toast_timeout_enterFrameHandler);
      }
      
      protected function completeClose() : void
      {
         var _loc1_:Object = this._closeData;
         var _loc2_:Boolean = this._disposeFromCloseCall;
         this._closeEffectContext = null;
         this._closeData = null;
         this._disposeFromCloseCall = false;
         this._isClosing = false;
         this._isOpen = false;
         this.removeFromParent(false);
         this.dispatchEventWith(Event.CLOSE,false,_loc1_);
         if(_loc2_)
         {
            this.dispose();
         }
      }
      
      protected function completeOpen() : void
      {
         this._openEffectContext = null;
         this._isOpening = false;
         this._isOpen = true;
         this.dispatchEventWith(Event.OPEN);
         this.startTimeout();
      }
      
      protected function toast_timeout_enterFrameHandler(param1:Event) : void
      {
         var _loc2_:int = (getTimer() - this._startTime) / 1000;
         if(_loc2_ > this._timeout)
         {
            this.close(this._disposeOnSelfClose);
         }
      }
      
      protected function fontStyles_changeHandler(param1:Event) : void
      {
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      protected function closeToast(param1:Object, param2:Boolean) : void
      {
         if(!this.parent || this._isClosing)
         {
            return;
         }
         if(this._suspendEffectsCount == 0 && this._openEffectContext !== null)
         {
            this._openEffectContext.interrupt();
            this._openEffectContext = null;
         }
         this._isClosing = true;
         this._closeData = param1;
         this._disposeFromCloseCall = param2;
         this.removeEventListener(Event.ENTER_FRAME,this.toast_timeout_enterFrameHandler);
         if(this._closeEffect !== null)
         {
            this._closeEffectContext = IEffectContext(this._closeEffect(this));
            this._closeEffectContext.addEventListener(Event.COMPLETE,this.closeEffectContext_completeHandler);
            this._closeEffectContext.play();
         }
         else
         {
            this.completeClose();
         }
      }
      
      protected function actionsGroup_triggeredHandler(param1:Event, param2:Object) : void
      {
         this.closeToast(param2,this._disposeOnSelfClose);
      }
      
      protected function closeEffectContext_completeHandler(param1:Event) : void
      {
         this.completeClose();
      }
      
      protected function openEffectContext_completeHandler(param1:Event) : void
      {
         this.completeOpen();
      }
   }
}

