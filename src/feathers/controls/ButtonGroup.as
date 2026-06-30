package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.ITextBaselineControl;
   import feathers.core.PropertyProxy;
   import feathers.data.IListCollection;
   import feathers.events.CollectionEventType;
   import feathers.events.FeathersEventType;
   import feathers.layout.Direction;
   import feathers.layout.FlowLayout;
   import feathers.layout.HorizontalAlign;
   import feathers.layout.HorizontalLayout;
   import feathers.layout.ILayout;
   import feathers.layout.IVirtualLayout;
   import feathers.layout.LayoutBoundsResult;
   import feathers.layout.VerticalAlign;
   import feathers.layout.VerticalLayout;
   import feathers.layout.ViewPortBounds;
   import feathers.skins.IStyleProvider;
   import flash.utils.Dictionary;
   import starling.display.DisplayObject;
   import starling.events.Event;
   
   public class ButtonGroup extends FeathersControl implements ITextBaselineControl
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      protected static const INVALIDATION_FLAG_BUTTON_FACTORY:String = "buttonFactory";
      
      protected static const LABEL_FIELD:String = "label";
      
      protected static const ENABLED_FIELD:String = "isEnabled";
      
      private static const DEFAULT_BUTTON_FIELDS:Vector.<String> = new <String>["defaultIcon","upIcon","downIcon","hoverIcon","disabledIcon","defaultSelectedIcon","selectedUpIcon","selectedDownIcon","selectedHoverIcon","selectedDisabledIcon","isSelected","isToggle","isLongPressEnabled","name"];
      
      private static const DEFAULT_BUTTON_EVENTS:Vector.<String> = new <String>[Event.TRIGGERED,Event.CHANGE,FeathersEventType.LONG_PRESS];
      
      public static const DEFAULT_CHILD_STYLE_NAME_BUTTON:String = "feathers-button-group-button";
      
      protected var buttonStyleName:String = "feathers-button-group-button";
      
      protected var firstButtonStyleName:String = "feathers-button-group-button";
      
      protected var lastButtonStyleName:String = "feathers-button-group-button";
      
      protected var activeFirstButton:Button;
      
      protected var inactiveFirstButton:Button;
      
      protected var activeLastButton:Button;
      
      protected var inactiveLastButton:Button;
      
      protected var _layoutItems:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
      
      protected var activeButtons:Vector.<Button> = new Vector.<Button>(0);
      
      protected var inactiveButtons:Vector.<Button> = new Vector.<Button>(0);
      
      protected var _buttonToItem:Dictionary = new Dictionary(true);
      
      protected var _dataProvider:IListCollection;
      
      protected var layout:ILayout;
      
      protected var _viewPortBounds:ViewPortBounds = new ViewPortBounds();
      
      protected var _layoutResult:LayoutBoundsResult = new LayoutBoundsResult();
      
      protected var _direction:String = "vertical";
      
      protected var _horizontalAlign:String = "justify";
      
      protected var _verticalAlign:String = "justify";
      
      protected var _distributeButtonSizes:Boolean = true;
      
      protected var _gap:Number = 0;
      
      protected var _firstGap:Number = NaN;
      
      protected var _lastGap:Number = NaN;
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var _buttonFactory:Function = defaultButtonFactory;
      
      protected var _firstButtonFactory:Function;
      
      protected var _lastButtonFactory:Function;
      
      protected var _buttonInitializer:Function;
      
      protected var _buttonReleaser:Function;
      
      protected var _customButtonStyleName:String;
      
      protected var _customFirstButtonStyleName:String;
      
      protected var _customLastButtonStyleName:String;
      
      protected var _buttonProperties:PropertyProxy;
      
      public function ButtonGroup()
      {
         this._buttonInitializer = this.defaultButtonInitializer;
         this._buttonReleaser = this.defaultButtonReleaser;
         super();
      }
      
      protected static function defaultButtonFactory() : Button
      {
         return new Button();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return ButtonGroup.globalStyleProvider;
      }
      
      public function get dataProvider() : IListCollection
      {
         return this._dataProvider;
      }
      
      public function set dataProvider(param1:IListCollection) : void
      {
         if(this._dataProvider == param1)
         {
            return;
         }
         if(this._dataProvider)
         {
            this._dataProvider.removeEventListener(CollectionEventType.UPDATE_ALL,this.dataProvider_updateAllHandler);
            this._dataProvider.removeEventListener(CollectionEventType.UPDATE_ITEM,this.dataProvider_updateItemHandler);
            this._dataProvider.removeEventListener(Event.CHANGE,this.dataProvider_changeHandler);
         }
         this._dataProvider = param1;
         if(this._dataProvider)
         {
            this._dataProvider.addEventListener(CollectionEventType.UPDATE_ALL,this.dataProvider_updateAllHandler);
            this._dataProvider.addEventListener(CollectionEventType.UPDATE_ITEM,this.dataProvider_updateItemHandler);
            this._dataProvider.addEventListener(Event.CHANGE,this.dataProvider_changeHandler);
         }
         this.invalidate(INVALIDATION_FLAG_DATA);
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
      
      public function get distributeButtonSizes() : Boolean
      {
         return this._distributeButtonSizes;
      }
      
      public function set distributeButtonSizes(param1:Boolean) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._distributeButtonSizes === param1)
         {
            return;
         }
         this._distributeButtonSizes = param1;
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
      
      public function get firstGap() : Number
      {
         return this._firstGap;
      }
      
      public function set firstGap(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._firstGap == param1)
         {
            return;
         }
         this._firstGap = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get lastGap() : Number
      {
         return this._lastGap;
      }
      
      public function set lastGap(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._lastGap == param1)
         {
            return;
         }
         this._lastGap = param1;
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
      
      public function get buttonFactory() : Function
      {
         return this._buttonFactory;
      }
      
      public function set buttonFactory(param1:Function) : void
      {
         if(this._buttonFactory == param1)
         {
            return;
         }
         this._buttonFactory = param1;
         this.invalidate(INVALIDATION_FLAG_BUTTON_FACTORY);
      }
      
      public function get firstButtonFactory() : Function
      {
         return this._firstButtonFactory;
      }
      
      public function set firstButtonFactory(param1:Function) : void
      {
         if(this._firstButtonFactory == param1)
         {
            return;
         }
         this._firstButtonFactory = param1;
         this.invalidate(INVALIDATION_FLAG_BUTTON_FACTORY);
      }
      
      public function get lastButtonFactory() : Function
      {
         return this._lastButtonFactory;
      }
      
      public function set lastButtonFactory(param1:Function) : void
      {
         if(this._lastButtonFactory == param1)
         {
            return;
         }
         this._lastButtonFactory = param1;
         this.invalidate(INVALIDATION_FLAG_BUTTON_FACTORY);
      }
      
      public function get buttonInitializer() : Function
      {
         return this._buttonInitializer;
      }
      
      public function set buttonInitializer(param1:Function) : void
      {
         if(this._buttonInitializer == param1)
         {
            return;
         }
         this._buttonInitializer = param1;
         this.invalidate(INVALIDATION_FLAG_BUTTON_FACTORY);
      }
      
      public function get buttonReleaser() : Function
      {
         return this._buttonReleaser;
      }
      
      public function set buttonReleaser(param1:Function) : void
      {
         if(this._buttonReleaser == param1)
         {
            return;
         }
         this._buttonReleaser = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get customButtonStyleName() : String
      {
         return this._customButtonStyleName;
      }
      
      public function set customButtonStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customButtonStyleName === param1)
         {
            return;
         }
         this._customButtonStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_BUTTON_FACTORY);
      }
      
      public function get customFirstButtonStyleName() : String
      {
         return this._customFirstButtonStyleName;
      }
      
      public function set customFirstButtonStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customFirstButtonStyleName === param1)
         {
            return;
         }
         this._customFirstButtonStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_BUTTON_FACTORY);
      }
      
      public function get customLastButtonStyleName() : String
      {
         return this._customLastButtonStyleName;
      }
      
      public function set customLastButtonStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customLastButtonStyleName === param1)
         {
            return;
         }
         this._customLastButtonStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_BUTTON_FACTORY);
      }
      
      public function get buttonProperties() : Object
      {
         if(!this._buttonProperties)
         {
            this._buttonProperties = new PropertyProxy(this.childProperties_onChange);
         }
         return this._buttonProperties;
      }
      
      public function set buttonProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         var _loc3_:String = null;
         if(this._buttonProperties == param1)
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
         if(this._buttonProperties)
         {
            this._buttonProperties.removeOnChangeCallback(this.childProperties_onChange);
         }
         this._buttonProperties = PropertyProxy(param1);
         if(this._buttonProperties)
         {
            this._buttonProperties.addOnChangeCallback(this.childProperties_onChange);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get baseline() : Number
      {
         if(!this.activeButtons || this.activeButtons.length == 0)
         {
            return this.scaledActualHeight;
         }
         var _loc1_:Button = this.activeButtons[0];
         return this.scaleY * (_loc1_.y + _loc1_.baseline);
      }
      
      override public function dispose() : void
      {
         this.dataProvider = null;
         super.dispose();
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         var _loc4_:Boolean = this.isInvalid(INVALIDATION_FLAG_BUTTON_FACTORY);
         var _loc5_:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
         if(_loc1_ || _loc3_ || _loc4_)
         {
            this.refreshButtons(_loc4_);
         }
         if(_loc1_ || _loc4_ || _loc2_)
         {
            this.refreshButtonStyles();
         }
         if(_loc1_ || _loc3_ || _loc4_)
         {
            this.commitEnabled();
         }
         if(_loc2_)
         {
            this.refreshLayoutStyles();
         }
         this.layoutButtons();
      }
      
      protected function commitEnabled() : void
      {
         var _loc3_:Button = null;
         var _loc1_:int = int(this.activeButtons.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.activeButtons[_loc2_];
            _loc3_.isEnabled = _loc3_.isEnabled && this._isEnabled;
            _loc2_++;
         }
      }
      
      protected function refreshButtonStyles() : void
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         var _loc3_:Button = null;
         for(_loc1_ in this._buttonProperties)
         {
            _loc2_ = this._buttonProperties[_loc1_];
            for each(_loc3_ in this.activeButtons)
            {
               _loc3_[_loc1_] = _loc2_;
            }
         }
      }
      
      protected function refreshLayoutStyles() : void
      {
         var _loc1_:VerticalLayout = null;
         var _loc2_:HorizontalLayout = null;
         var _loc3_:FlowLayout = null;
         if(this._direction == Direction.VERTICAL)
         {
            _loc1_ = this.layout as VerticalLayout;
            if(!_loc1_)
            {
               this.layout = _loc1_ = new VerticalLayout();
            }
            _loc1_.distributeHeights = this._distributeButtonSizes;
            _loc1_.horizontalAlign = this._horizontalAlign;
            _loc1_.verticalAlign = this._verticalAlign == VerticalAlign.JUSTIFY ? VerticalAlign.TOP : this._verticalAlign;
            _loc1_.gap = this._gap;
            _loc1_.firstGap = this._firstGap;
            _loc1_.lastGap = this._lastGap;
            _loc1_.paddingTop = this._paddingTop;
            _loc1_.paddingRight = this._paddingRight;
            _loc1_.paddingBottom = this._paddingBottom;
            _loc1_.paddingLeft = this._paddingLeft;
         }
         else if(this._distributeButtonSizes)
         {
            _loc2_ = this.layout as HorizontalLayout;
            if(!_loc2_)
            {
               this.layout = _loc2_ = new HorizontalLayout();
            }
            _loc2_.distributeWidths = true;
            _loc2_.horizontalAlign = this._horizontalAlign == HorizontalAlign.JUSTIFY ? HorizontalAlign.LEFT : this._horizontalAlign;
            _loc2_.verticalAlign = this._verticalAlign;
            _loc2_.gap = this._gap;
            _loc2_.firstGap = this._firstGap;
            _loc2_.lastGap = this._lastGap;
            _loc2_.paddingTop = this._paddingTop;
            _loc2_.paddingRight = this._paddingRight;
            _loc2_.paddingBottom = this._paddingBottom;
            _loc2_.paddingLeft = this._paddingLeft;
         }
         else
         {
            _loc3_ = this.layout as FlowLayout;
            if(!_loc3_)
            {
               this.layout = _loc3_ = new FlowLayout();
            }
            _loc3_.horizontalAlign = this._horizontalAlign == HorizontalAlign.JUSTIFY ? HorizontalAlign.LEFT : this._horizontalAlign;
            _loc3_.verticalAlign = this._verticalAlign;
            _loc3_.gap = this._gap;
            _loc3_.firstHorizontalGap = this._firstGap;
            _loc3_.lastHorizontalGap = this._lastGap;
            _loc3_.paddingTop = this._paddingTop;
            _loc3_.paddingRight = this._paddingRight;
            _loc3_.paddingBottom = this._paddingBottom;
            _loc3_.paddingLeft = this._paddingLeft;
         }
         if(this.layout is IVirtualLayout)
         {
            IVirtualLayout(this.layout).useVirtualLayout = false;
         }
      }
      
      protected function defaultButtonInitializer(param1:Button, param2:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         var _loc5_:Function = null;
         if(param2 is Object)
         {
            if(param2.hasOwnProperty(LABEL_FIELD))
            {
               param1.label = param2.label as String;
            }
            else
            {
               param1.label = param2.toString();
            }
            if(param2.hasOwnProperty(ENABLED_FIELD))
            {
               param1.isEnabled = param2.isEnabled as Boolean;
            }
            else
            {
               param1.isEnabled = this._isEnabled;
            }
            for each(_loc3_ in DEFAULT_BUTTON_FIELDS)
            {
               if(param2.hasOwnProperty(_loc3_))
               {
                  param1[_loc3_] = param2[_loc3_];
               }
            }
            for each(_loc3_ in DEFAULT_BUTTON_EVENTS)
            {
               _loc4_ = true;
               if(param2.hasOwnProperty(_loc3_))
               {
                  _loc5_ = param2[_loc3_] as Function;
                  if(_loc5_ === null)
                  {
                     continue;
                  }
                  _loc4_ = false;
                  param1.addEventListener(_loc3_,this.defaultButtonEventsListener);
               }
               if(_loc4_)
               {
                  param1.removeEventListener(_loc3_,this.defaultButtonEventsListener);
               }
            }
         }
         else
         {
            param1.label = "";
            param1.isEnabled = this._isEnabled;
         }
      }
      
      protected function defaultButtonReleaser(param1:Button, param2:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         var _loc5_:Function = null;
         param1.label = null;
         for each(_loc3_ in DEFAULT_BUTTON_FIELDS)
         {
            if(param2.hasOwnProperty(_loc3_))
            {
               param1[_loc3_] = null;
            }
         }
         for each(_loc3_ in DEFAULT_BUTTON_EVENTS)
         {
            _loc4_ = true;
            if(param2.hasOwnProperty(_loc3_))
            {
               _loc5_ = param2[_loc3_] as Function;
               if(_loc5_ !== null)
               {
                  param1.removeEventListener(_loc3_,this.defaultButtonEventsListener);
               }
            }
         }
      }
      
      protected function refreshButtons(param1:Boolean) : void
      {
         var _loc7_:Object = null;
         var _loc8_:Button = null;
         var _loc2_:Vector.<Button> = this.inactiveButtons;
         this.inactiveButtons = this.activeButtons;
         this.activeButtons = _loc2_;
         this.activeButtons.length = 0;
         this._layoutItems.length = 0;
         _loc2_ = null;
         if(param1)
         {
            this.clearInactiveButtons();
         }
         else
         {
            if(this.activeFirstButton)
            {
               this.inactiveButtons.shift();
            }
            this.inactiveFirstButton = this.activeFirstButton;
            if(this.activeLastButton)
            {
               this.inactiveButtons.pop();
            }
            this.inactiveLastButton = this.activeLastButton;
         }
         this.activeFirstButton = null;
         this.activeLastButton = null;
         var _loc3_:int = 0;
         var _loc4_:int = this._dataProvider ? this._dataProvider.length : 0;
         var _loc5_:int = _loc4_ - 1;
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc7_ = this._dataProvider.getItemAt(_loc6_);
            if(_loc6_ == 0)
            {
               _loc8_ = this.activeFirstButton = this.createFirstButton(_loc7_);
            }
            else if(_loc6_ == _loc5_)
            {
               _loc8_ = this.activeLastButton = this.createLastButton(_loc7_);
            }
            else
            {
               _loc8_ = this.createButton(_loc7_);
            }
            this.activeButtons[_loc3_] = _loc8_;
            this._layoutItems[_loc3_] = _loc8_;
            _loc3_++;
            _loc6_++;
         }
         this.clearInactiveButtons();
      }
      
      protected function clearInactiveButtons() : void
      {
         var _loc3_:Button = null;
         var _loc1_:int = int(this.inactiveButtons.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.inactiveButtons.shift();
            this.destroyButton(_loc3_);
            _loc2_++;
         }
         if(this.inactiveFirstButton)
         {
            this.destroyButton(this.inactiveFirstButton);
            this.inactiveFirstButton = null;
         }
         if(this.inactiveLastButton)
         {
            this.destroyButton(this.inactiveLastButton);
            this.inactiveLastButton = null;
         }
      }
      
      protected function createFirstButton(param1:Object) : Button
      {
         var _loc3_:Button = null;
         var _loc4_:Function = null;
         var _loc2_:Boolean = false;
         if(this.inactiveFirstButton !== null)
         {
            _loc3_ = this.inactiveFirstButton;
            this.releaseButton(_loc3_);
            this.inactiveFirstButton = null;
         }
         else
         {
            _loc2_ = true;
            _loc4_ = this._firstButtonFactory != null ? this._firstButtonFactory : this._buttonFactory;
            _loc3_ = Button(_loc4_());
            if(this._customFirstButtonStyleName)
            {
               _loc3_.styleNameList.add(this._customFirstButtonStyleName);
            }
            else if(this._customButtonStyleName)
            {
               _loc3_.styleNameList.add(this._customButtonStyleName);
            }
            else
            {
               _loc3_.styleNameList.add(this.firstButtonStyleName);
            }
            this.addChild(_loc3_);
         }
         this._buttonInitializer(_loc3_,param1);
         this._buttonToItem[_loc3_] = param1;
         if(_loc2_)
         {
            _loc3_.addEventListener(Event.TRIGGERED,this.button_triggeredHandler);
         }
         return _loc3_;
      }
      
      protected function createLastButton(param1:Object) : Button
      {
         var _loc3_:Button = null;
         var _loc4_:Function = null;
         var _loc2_:Boolean = false;
         if(this.inactiveLastButton !== null)
         {
            _loc3_ = this.inactiveLastButton;
            this.releaseButton(_loc3_);
            this.inactiveLastButton = null;
         }
         else
         {
            _loc2_ = true;
            _loc4_ = this._lastButtonFactory != null ? this._lastButtonFactory : this._buttonFactory;
            _loc3_ = Button(_loc4_());
            if(this._customLastButtonStyleName)
            {
               _loc3_.styleNameList.add(this._customLastButtonStyleName);
            }
            else if(this._customButtonStyleName)
            {
               _loc3_.styleNameList.add(this._customButtonStyleName);
            }
            else
            {
               _loc3_.styleNameList.add(this.lastButtonStyleName);
            }
            this.addChild(_loc3_);
         }
         this._buttonInitializer(_loc3_,param1);
         this._buttonToItem[_loc3_] = param1;
         if(_loc2_)
         {
            _loc3_.addEventListener(Event.TRIGGERED,this.button_triggeredHandler);
         }
         return _loc3_;
      }
      
      protected function createButton(param1:Object) : Button
      {
         var _loc3_:Button = null;
         var _loc2_:Boolean = false;
         if(this.inactiveButtons.length == 0)
         {
            _loc2_ = true;
            _loc3_ = this._buttonFactory();
            if(this._customButtonStyleName)
            {
               _loc3_.styleNameList.add(this._customButtonStyleName);
            }
            else
            {
               _loc3_.styleNameList.add(this.buttonStyleName);
            }
            this.addChild(_loc3_);
         }
         else
         {
            _loc3_ = this.inactiveButtons.shift();
            this.releaseButton(_loc3_);
         }
         this._buttonInitializer(_loc3_,param1);
         this._buttonToItem[_loc3_] = param1;
         if(_loc2_)
         {
            _loc3_.addEventListener(Event.TRIGGERED,this.button_triggeredHandler);
         }
         return _loc3_;
      }
      
      protected function releaseButton(param1:Button) : void
      {
         var _loc2_:Object = this._buttonToItem[param1];
         delete this._buttonToItem[param1];
         if(this._buttonReleaser.length == 1)
         {
            this._buttonReleaser(param1);
         }
         else
         {
            this._buttonReleaser(param1,_loc2_);
         }
      }
      
      protected function destroyButton(param1:Button) : void
      {
         param1.removeEventListener(Event.TRIGGERED,this.button_triggeredHandler);
         this.releaseButton(param1);
         this.removeChild(param1,true);
      }
      
      protected function layoutButtons() : void
      {
         var _loc3_:Button = null;
         this._viewPortBounds.x = 0;
         this._viewPortBounds.y = 0;
         this._viewPortBounds.scrollX = 0;
         this._viewPortBounds.scrollY = 0;
         this._viewPortBounds.explicitWidth = this._explicitWidth;
         this._viewPortBounds.explicitHeight = this._explicitHeight;
         this._viewPortBounds.minWidth = this._explicitMinWidth;
         this._viewPortBounds.minHeight = this._explicitMinHeight;
         this._viewPortBounds.maxWidth = this._explicitMaxWidth;
         this._viewPortBounds.maxHeight = this._explicitMaxHeight;
         this.layout.layout(this._layoutItems,this._viewPortBounds,this._layoutResult);
         var _loc1_:Number = this._layoutResult.contentWidth;
         var _loc2_:Number = this._layoutResult.contentHeight;
         this.saveMeasurements(_loc1_,_loc2_,_loc1_,_loc2_);
         for each(_loc3_ in this.activeButtons)
         {
            _loc3_.validate();
         }
      }
      
      protected function childProperties_onChange(param1:PropertyProxy, param2:String) : void
      {
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      protected function dataProvider_changeHandler(param1:Event) : void
      {
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      protected function dataProvider_updateAllHandler(param1:Event) : void
      {
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      protected function dataProvider_updateItemHandler(param1:Event, param2:int) : void
      {
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      protected function button_triggeredHandler(param1:Event) : void
      {
         if(!this._dataProvider || !this.activeButtons)
         {
            return;
         }
         var _loc2_:Button = Button(param1.currentTarget);
         var _loc3_:int = this.activeButtons.indexOf(_loc2_);
         var _loc4_:Object = this._dataProvider.getItemAt(_loc3_);
         this.dispatchEventWith(Event.TRIGGERED,false,_loc4_);
      }
      
      protected function defaultButtonEventsListener(param1:Event) : void
      {
         var _loc6_:Function = null;
         var _loc7_:int = 0;
         var _loc2_:Button = Button(param1.currentTarget);
         var _loc3_:int = this.activeButtons.indexOf(_loc2_);
         var _loc4_:Object = this._dataProvider.getItemAt(_loc3_);
         var _loc5_:String = param1.type;
         if(_loc4_.hasOwnProperty(_loc5_))
         {
            _loc6_ = _loc4_[_loc5_] as Function;
            if(_loc6_ == null)
            {
               return;
            }
            _loc7_ = _loc6_.length;
            switch(_loc7_)
            {
               case 3:
                  _loc6_(param1,param1.data,_loc4_);
                  break;
               case 2:
                  _loc6_(param1,param1.data);
                  break;
               case 1:
                  _loc6_(param1);
                  break;
               default:
                  _loc6_();
            }
         }
      }
   }
}

