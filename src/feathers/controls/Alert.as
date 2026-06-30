package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.ITextRenderer;
   import feathers.core.IValidating;
   import feathers.core.PopUpManager;
   import feathers.core.PropertyProxy;
   import feathers.data.IListCollection;
   import feathers.events.FeathersEventType;
   import feathers.layout.HorizontalAlign;
   import feathers.layout.VerticalLayout;
   import feathers.skins.IStyleProvider;
   import feathers.text.FontStylesSet;
   import feathers.utils.display.getDisplayObjectDepthFromStage;
   import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import starling.text.TextFormat;
   
   public class Alert extends Panel
   {
      
      public static var overlayFactory:Function;
      
      public static var globalStyleProvider:IStyleProvider;
      
      public static const DEFAULT_CHILD_STYLE_NAME_HEADER:String = "feathers-alert-header";
      
      public static const DEFAULT_CHILD_STYLE_NAME_BUTTON_GROUP:String = "feathers-alert-button-group";
      
      public static const DEFAULT_CHILD_STYLE_NAME_MESSAGE:String = "feathers-alert-message";
      
      public static var alertFactory:Function = defaultAlertFactory;
      
      protected var messageStyleName:String = "feathers-alert-message";
      
      protected var headerHeader:Header;
      
      protected var buttonGroupFooter:ButtonGroup;
      
      protected var messageTextRenderer:ITextRenderer;
      
      protected var _message:String = null;
      
      protected var _icon:DisplayObject;
      
      protected var _gap:Number = 0;
      
      protected var _buttonsDataProvider:IListCollection = null;
      
      protected var _acceptButtonIndex:int;
      
      protected var _cancelButtonIndex:int;
      
      protected var _fontStylesSet:FontStylesSet;
      
      protected var _messageFactory:Function;
      
      protected var _messageProperties:PropertyProxy;
      
      protected var _customMessageStyleName:String;
      
      public function Alert()
      {
         super();
         this.headerStyleName = DEFAULT_CHILD_STYLE_NAME_HEADER;
         this.footerStyleName = DEFAULT_CHILD_STYLE_NAME_BUTTON_GROUP;
         if(this._fontStylesSet === null)
         {
            this._fontStylesSet = new FontStylesSet();
            this._fontStylesSet.addEventListener(Event.CHANGE,this.fontStyles_changeHandler);
         }
         this.buttonGroupFactory = defaultButtonGroupFactory;
         this.addEventListener(Event.ADDED_TO_STAGE,this.alert_addedToStageHandler);
      }
      
      public static function defaultAlertFactory() : Alert
      {
         return new Alert();
      }
      
      public static function show(param1:String, param2:String = null, param3:IListCollection = null, param4:DisplayObject = null, param5:Boolean = true, param6:Boolean = true, param7:Function = null, param8:Function = null) : Alert
      {
         var _loc9_:Function = param7;
         if(_loc9_ == null)
         {
            _loc9_ = alertFactory != null ? alertFactory : defaultAlertFactory;
         }
         var _loc10_:Alert = Alert(_loc9_());
         _loc10_.title = param2;
         _loc10_.message = param1;
         _loc10_.buttonsDataProvider = param3;
         _loc10_.icon = param4;
         _loc9_ = param8;
         if(_loc9_ == null)
         {
            _loc9_ = overlayFactory;
         }
         PopUpManager.addPopUp(_loc10_,param5,param6,_loc9_);
         return _loc10_;
      }
      
      protected static function defaultButtonGroupFactory() : ButtonGroup
      {
         return new ButtonGroup();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return Alert.globalStyleProvider;
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
      
      public function get icon() : DisplayObject
      {
         return this._icon;
      }
      
      public function set icon(param1:DisplayObject) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            if(param1 !== null)
            {
               param1.dispose();
            }
            return;
         }
         if(this._icon === param1)
         {
            return;
         }
         var _loc3_:Boolean = this.displayListBypassEnabled;
         this.displayListBypassEnabled = false;
         if(this._icon)
         {
            this._icon.removeEventListener(FeathersEventType.RESIZE,this.icon_resizeHandler);
            this.removeChild(this._icon);
         }
         this._icon = param1;
         if(this._icon)
         {
            this._icon.addEventListener(FeathersEventType.RESIZE,this.icon_resizeHandler);
            this.addChild(this._icon);
         }
         this.displayListBypassEnabled = _loc3_;
         this.invalidate(INVALIDATION_FLAG_DATA);
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
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
      }
      
      public function get buttonsDataProvider() : IListCollection
      {
         return this._buttonsDataProvider;
      }
      
      public function set buttonsDataProvider(param1:IListCollection) : void
      {
         if(this._buttonsDataProvider == param1)
         {
            return;
         }
         this._buttonsDataProvider = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get acceptButtonIndex() : int
      {
         return this._acceptButtonIndex;
      }
      
      public function set acceptButtonIndex(param1:int) : void
      {
         this._acceptButtonIndex = param1;
      }
      
      public function get cancelButtonIndex() : int
      {
         return this._cancelButtonIndex;
      }
      
      public function set cancelButtonIndex(param1:int) : void
      {
         this._cancelButtonIndex = param1;
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
      
      public function get messageProperties() : Object
      {
         if(!this._messageProperties)
         {
            this._messageProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._messageProperties;
      }
      
      public function set messageProperties(param1:Object) : void
      {
         if(this._messageProperties == param1)
         {
            return;
         }
         if(Boolean(param1) && !(param1 is PropertyProxy))
         {
            param1 = PropertyProxy.fromObject(param1);
         }
         if(this._messageProperties)
         {
            this._messageProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._messageProperties = PropertyProxy(param1);
         if(this._messageProperties)
         {
            this._messageProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
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
      
      public function get buttonGroupFactory() : Function
      {
         return super.footerFactory;
      }
      
      public function set buttonGroupFactory(param1:Function) : void
      {
         super.footerFactory = param1;
      }
      
      public function get customButtonGroupStyleName() : String
      {
         return super.customFooterStyleName;
      }
      
      public function set customButtonGroupStyleName(param1:String) : void
      {
         super.customFooterStyleName = param1;
      }
      
      public function get buttonGroupProperties() : Object
      {
         return super.footerProperties;
      }
      
      public function set buttonGroupProperties(param1:Object) : void
      {
         super.footerProperties = param1;
      }
      
      override public function dispose() : void
      {
         if(this._fontStylesSet !== null)
         {
            this._fontStylesSet.dispose();
            this._fontStylesSet = null;
         }
         super.dispose();
      }
      
      override protected function initialize() : void
      {
         var _loc1_:VerticalLayout = null;
         if(this._layout === null)
         {
            _loc1_ = new VerticalLayout();
            _loc1_.horizontalAlign = HorizontalAlign.JUSTIFY;
            this.ignoreNextStyleRestriction();
            this.layout = _loc1_;
         }
         super.initialize();
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         var _loc4_:Boolean = this.isInvalid(INVALIDATION_FLAG_TEXT_RENDERER);
         if(_loc4_)
         {
            this.createMessage();
         }
         if(_loc4_ || _loc1_)
         {
            this.messageTextRenderer.text = this._message;
         }
         if(_loc4_ || _loc2_)
         {
            this.refreshMessageStyles();
         }
         super.draw();
         if(this._icon !== null)
         {
            if(this._icon is IValidating)
            {
               IValidating(this._icon).validate();
            }
            this._icon.x = this._paddingLeft;
            this._icon.y = this._topViewPortOffset + (this._viewPort.visibleHeight - this._icon.height) / 2;
         }
      }
      
      override protected function autoSizeIfNeeded() : Boolean
      {
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         if(this._autoSizeMode === AutoSizeMode.STAGE)
         {
            return super.autoSizeIfNeeded();
         }
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
         if(this._icon is IValidating)
         {
            IValidating(this._icon).validate();
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
            _loc10_ = this.header.width + this._outerPaddingLeft + this._outerPaddingRight;
            if(_loc10_ > _loc6_)
            {
               _loc6_ = _loc10_;
            }
            if(this.footer !== null)
            {
               _loc11_ = this.footer.width + this._outerPaddingLeft + this._outerPaddingRight;
               if(_loc11_ > _loc6_)
               {
                  _loc6_ = _loc11_;
               }
            }
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
            if(this._icon !== null)
            {
               _loc12_ = this._icon.height;
               if(_loc12_ === _loc12_ && _loc12_ > _loc7_)
               {
                  _loc7_ = _loc12_;
               }
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
            _loc13_ = this.header.minWidth + this._outerPaddingLeft + this._outerPaddingRight;
            if(_loc13_ > _loc8_)
            {
               _loc8_ = _loc13_;
            }
            if(this.footer !== null)
            {
               _loc14_ = this.footer.minWidth + this._outerPaddingLeft + this._outerPaddingRight;
               if(_loc14_ > _loc8_)
               {
                  _loc8_ = _loc14_;
               }
            }
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
            if(this._icon !== null)
            {
               _loc12_ = this._icon.height;
               if(_loc12_ === _loc12_ && _loc12_ > _loc9_)
               {
                  _loc9_ = _loc12_;
               }
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
      
      override protected function createHeader() : void
      {
         super.createHeader();
         this.headerHeader = Header(this.header);
      }
      
      protected function createButtonGroup() : void
      {
         if(this.buttonGroupFooter)
         {
            this.buttonGroupFooter.removeEventListener(Event.TRIGGERED,this.buttonsFooter_triggeredHandler);
         }
         super.createFooter();
         this.buttonGroupFooter = ButtonGroup(this.footer);
         this.buttonGroupFooter.addEventListener(Event.TRIGGERED,this.buttonsFooter_triggeredHandler);
      }
      
      override protected function createFooter() : void
      {
         this.createButtonGroup();
      }
      
      protected function createMessage() : void
      {
         if(this.messageTextRenderer)
         {
            this.removeChild(DisplayObject(this.messageTextRenderer),true);
            this.messageTextRenderer = null;
         }
         var _loc1_:Function = this._messageFactory != null ? this._messageFactory : FeathersControl.defaultTextRendererFactory;
         this.messageTextRenderer = ITextRenderer(_loc1_());
         this.messageTextRenderer.wordWrap = true;
         var _loc2_:String = this._customMessageStyleName != null ? this._customMessageStyleName : this.messageStyleName;
         var _loc3_:IFeathersControl = IFeathersControl(this.messageTextRenderer);
         _loc3_.styleNameList.add(_loc2_);
         _loc3_.touchable = false;
         this.addChild(DisplayObject(this.messageTextRenderer));
      }
      
      override protected function refreshFooterStyles() : void
      {
         super.refreshFooterStyles();
         this.buttonGroupFooter.dataProvider = this._buttonsDataProvider;
      }
      
      protected function refreshMessageStyles() : void
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         this.messageTextRenderer.fontStyles = this._fontStylesSet;
         for(_loc1_ in this._messageProperties)
         {
            _loc2_ = this._messageProperties[_loc1_];
            this.messageTextRenderer[_loc1_] = _loc2_;
         }
      }
      
      override protected function calculateViewPortOffsets(param1:Boolean = false, param2:Boolean = false) : void
      {
         var _loc3_:Number = NaN;
         super.calculateViewPortOffsets(param1,param2);
         if(this._icon !== null)
         {
            if(this._icon is IValidating)
            {
               IValidating(this._icon).validate();
            }
            _loc3_ = this._icon.width;
            if(_loc3_ === _loc3_)
            {
               this._leftViewPortOffset += _loc3_ + this._gap;
            }
         }
      }
      
      protected function closeAlert(param1:Object) : void
      {
         this.removeFromParent();
         this.dispatchEventWith(Event.CLOSE,false,param1);
         this.dispose();
      }
      
      protected function buttonsFooter_triggeredHandler(param1:Event, param2:Object) : void
      {
         this.closeAlert(param2);
      }
      
      protected function icon_resizeHandler(param1:Event) : void
      {
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
      }
      
      protected function fontStyles_changeHandler(param1:Event) : void
      {
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      protected function alert_addedToStageHandler(param1:Event) : void
      {
         var _loc2_:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         var _loc3_:int = -getDisplayObjectDepthFromStage(this);
         _loc2_.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN,this.alert_nativeStage_keyDownHandler,false,_loc3_,true);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.alert_removedFromStageHandler);
      }
      
      protected function alert_removedFromStageHandler(param1:Event) : void
      {
         this.removeEventListener(Event.REMOVED_FROM_STAGE,this.alert_removedFromStageHandler);
         var _loc2_:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         _loc2_.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN,this.alert_nativeStage_keyDownHandler);
      }
      
      protected function alert_nativeStage_keyDownHandler(param1:KeyboardEvent) : void
      {
         var _loc3_:Object = null;
         if(param1.isDefaultPrevented())
         {
            return;
         }
         if(this._buttonsDataProvider === null)
         {
            return;
         }
         var _loc2_:uint = param1.keyCode;
         if(this._acceptButtonIndex != -1 && _loc2_ == Keyboard.ENTER)
         {
            param1.preventDefault();
            _loc3_ = this._buttonsDataProvider.getItemAt(this._acceptButtonIndex);
            this.closeAlert(_loc3_);
            return;
         }
         if(this._cancelButtonIndex != -1 && (_loc2_ == Keyboard.BACK || _loc2_ == Keyboard.ESCAPE))
         {
            param1.preventDefault();
            _loc3_ = this._buttonsDataProvider.getItemAt(this._cancelButtonIndex);
            this.closeAlert(_loc3_);
            return;
         }
      }
   }
}

