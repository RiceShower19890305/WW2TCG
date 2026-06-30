package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.IAdvancedNativeFocusOwner;
   import feathers.core.ITextBaselineControl;
   import feathers.core.PropertyProxy;
   import feathers.events.ExclusiveTouch;
   import feathers.events.FeathersEventType;
   import feathers.skins.IStyleProvider;
   import feathers.utils.math.clamp;
   import feathers.utils.math.roundToNearest;
   import feathers.utils.math.roundToPrecision;
   import flash.events.TimerEvent;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import starling.events.KeyboardEvent;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   
   public class NumericStepper extends FeathersControl implements IRange, IAdvancedNativeFocusOwner, ITextBaselineControl
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      protected static const INVALIDATION_FLAG_DECREMENT_BUTTON_FACTORY:String = "decrementButtonFactory";
      
      protected static const INVALIDATION_FLAG_INCREMENT_BUTTON_FACTORY:String = "incrementButtonFactory";
      
      protected static const INVALIDATION_FLAG_TEXT_INPUT_FACTORY:String = "textInputFactory";
      
      public static const DEFAULT_CHILD_STYLE_NAME_DECREMENT_BUTTON:String = "feathers-numeric-stepper-decrement-button";
      
      public static const DEFAULT_CHILD_STYLE_NAME_INCREMENT_BUTTON:String = "feathers-numeric-stepper-increment-button";
      
      public static const DEFAULT_CHILD_STYLE_NAME_TEXT_INPUT:String = "feathers-numeric-stepper-text-input";
      
      protected var decrementButtonStyleName:String = "feathers-numeric-stepper-decrement-button";
      
      protected var incrementButtonStyleName:String = "feathers-numeric-stepper-increment-button";
      
      protected var textInputStyleName:String = "feathers-numeric-stepper-text-input";
      
      protected var decrementButton:Button;
      
      protected var incrementButton:Button;
      
      protected var textInput:TextInput;
      
      protected var textInputExplicitWidth:Number;
      
      protected var textInputExplicitHeight:Number;
      
      protected var textInputExplicitMinWidth:Number;
      
      protected var textInputExplicitMinHeight:Number;
      
      protected var touchPointID:int = -1;
      
      protected var _textInputHasFocus:Boolean = false;
      
      protected var _value:Number = 0;
      
      protected var _minimum:Number = 0;
      
      protected var _maximum:Number = 0;
      
      protected var _step:Number = 0;
      
      protected var _useLeftAndRightKeys:Boolean = false;
      
      protected var _valueFormatFunction:Function;
      
      protected var _valueParseFunction:Function;
      
      protected var currentRepeatAction:Function;
      
      protected var _repeatTimer:Timer;
      
      protected var _repeatDelay:Number = 0.05;
      
      protected var _buttonLayoutMode:String = "splitHorizontal";
      
      protected var _buttonGap:Number = 0;
      
      protected var _textInputGap:Number = 0;
      
      protected var _decrementButtonFactory:Function;
      
      protected var _customDecrementButtonStyleName:String;
      
      protected var _decrementButtonProperties:PropertyProxy;
      
      protected var _decrementButtonLabel:String = null;
      
      protected var _incrementButtonFactory:Function;
      
      protected var _customIncrementButtonStyleName:String;
      
      protected var _incrementButtonProperties:PropertyProxy;
      
      protected var _incrementButtonLabel:String = null;
      
      protected var _textInputFactory:Function;
      
      protected var _customTextInputStyleName:String;
      
      protected var _textInputProperties:PropertyProxy;
      
      public function NumericStepper()
      {
         super();
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.numericStepper_removedFromStageHandler);
      }
      
      protected static function defaultDecrementButtonFactory() : Button
      {
         return new Button();
      }
      
      protected static function defaultIncrementButtonFactory() : Button
      {
         return new Button();
      }
      
      protected static function defaultTextInputFactory() : TextInput
      {
         return new TextInput();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return NumericStepper.globalStyleProvider;
      }
      
      public function get nativeFocus() : Object
      {
         if(this.textInput !== null)
         {
            return this.textInput.nativeFocus;
         }
         return null;
      }
      
      public function get value() : Number
      {
         return this._value;
      }
      
      public function set value(param1:Number) : void
      {
         if(this._step != 0 && param1 != this._maximum && param1 != this._minimum)
         {
            param1 = roundToPrecision(roundToNearest(param1 - this._minimum,this._step) + this._minimum,10);
         }
         param1 = clamp(param1,this._minimum,this._maximum);
         if(this._value == param1)
         {
            return;
         }
         this._value = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
         this.dispatchEventWith(Event.CHANGE);
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
      
      public function get useLeftAndRightKeys() : Boolean
      {
         return this._useLeftAndRightKeys;
      }
      
      public function set useLeftAndRightKeys(param1:Boolean) : void
      {
         this._useLeftAndRightKeys = param1;
      }
      
      public function get valueFormatFunction() : Function
      {
         return this._valueFormatFunction;
      }
      
      public function set valueFormatFunction(param1:Function) : void
      {
         if(this._valueFormatFunction == param1)
         {
            return;
         }
         this._valueFormatFunction = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get valueParseFunction() : Function
      {
         return this._valueParseFunction;
      }
      
      public function set valueParseFunction(param1:Function) : void
      {
         this._valueParseFunction = param1;
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
      
      public function get buttonLayoutMode() : String
      {
         return this._buttonLayoutMode;
      }
      
      public function set buttonLayoutMode(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._buttonLayoutMode === param1)
         {
            return;
         }
         this._buttonLayoutMode = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get buttonGap() : Number
      {
         return this._buttonGap;
      }
      
      public function set buttonGap(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._buttonGap == param1)
         {
            return;
         }
         this._buttonGap = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get textInputGap() : Number
      {
         return this._textInputGap;
      }
      
      public function set textInputGap(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._textInputGap == param1)
         {
            return;
         }
         this._textInputGap = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get decrementButtonFactory() : Function
      {
         return this._decrementButtonFactory;
      }
      
      public function set decrementButtonFactory(param1:Function) : void
      {
         if(this._decrementButtonFactory == param1)
         {
            return;
         }
         this._decrementButtonFactory = param1;
         this.invalidate(INVALIDATION_FLAG_DECREMENT_BUTTON_FACTORY);
      }
      
      public function get customDecrementButtonStyleName() : String
      {
         return this._customDecrementButtonStyleName;
      }
      
      public function set customDecrementButtonStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customDecrementButtonStyleName === param1)
         {
            return;
         }
         this._customDecrementButtonStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_DECREMENT_BUTTON_FACTORY);
      }
      
      public function get decrementButtonProperties() : Object
      {
         if(!this._decrementButtonProperties)
         {
            this._decrementButtonProperties = new PropertyProxy(this.childProperties_onChange);
         }
         return this._decrementButtonProperties;
      }
      
      public function set decrementButtonProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         var _loc3_:String = null;
         if(this._decrementButtonProperties == param1)
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
         if(this._decrementButtonProperties)
         {
            this._decrementButtonProperties.removeOnChangeCallback(this.childProperties_onChange);
         }
         this._decrementButtonProperties = PropertyProxy(param1);
         if(this._decrementButtonProperties)
         {
            this._decrementButtonProperties.addOnChangeCallback(this.childProperties_onChange);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get decrementButtonLabel() : String
      {
         return this._decrementButtonLabel;
      }
      
      public function set decrementButtonLabel(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._decrementButtonLabel === param1)
         {
            return;
         }
         this._decrementButtonLabel = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get incrementButtonFactory() : Function
      {
         return this._incrementButtonFactory;
      }
      
      public function set incrementButtonFactory(param1:Function) : void
      {
         if(this._incrementButtonFactory == param1)
         {
            return;
         }
         this._incrementButtonFactory = param1;
         this.invalidate(INVALIDATION_FLAG_INCREMENT_BUTTON_FACTORY);
      }
      
      public function get customIncrementButtonStyleName() : String
      {
         return this._customIncrementButtonStyleName;
      }
      
      public function set customIncrementButtonStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customIncrementButtonStyleName === param1)
         {
            return;
         }
         this._customIncrementButtonStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_INCREMENT_BUTTON_FACTORY);
      }
      
      public function get incrementButtonProperties() : Object
      {
         if(!this._incrementButtonProperties)
         {
            this._incrementButtonProperties = new PropertyProxy(this.childProperties_onChange);
         }
         return this._incrementButtonProperties;
      }
      
      public function set incrementButtonProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         var _loc3_:String = null;
         if(this._incrementButtonProperties == param1)
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
         if(this._incrementButtonProperties)
         {
            this._incrementButtonProperties.removeOnChangeCallback(this.childProperties_onChange);
         }
         this._incrementButtonProperties = PropertyProxy(param1);
         if(this._incrementButtonProperties)
         {
            this._incrementButtonProperties.addOnChangeCallback(this.childProperties_onChange);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get incrementButtonLabel() : String
      {
         return this._incrementButtonLabel;
      }
      
      public function set incrementButtonLabel(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._incrementButtonLabel === param1)
         {
            return;
         }
         this._incrementButtonLabel = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get textInputFactory() : Function
      {
         return this._textInputFactory;
      }
      
      public function set textInputFactory(param1:Function) : void
      {
         if(this._textInputFactory == param1)
         {
            return;
         }
         this._textInputFactory = param1;
         this.invalidate(INVALIDATION_FLAG_TEXT_INPUT_FACTORY);
      }
      
      public function get customTextInputStyleName() : String
      {
         return this._customTextInputStyleName;
      }
      
      public function set customTextInputStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customTextInputStyleName === param1)
         {
            return;
         }
         this._customTextInputStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_TEXT_INPUT_FACTORY);
      }
      
      public function get textInputProperties() : Object
      {
         if(!this._textInputProperties)
         {
            this._textInputProperties = new PropertyProxy(this.childProperties_onChange);
         }
         return this._textInputProperties;
      }
      
      public function set textInputProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         var _loc3_:String = null;
         if(this._textInputProperties == param1)
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
         if(this._textInputProperties)
         {
            this._textInputProperties.removeOnChangeCallback(this.childProperties_onChange);
         }
         this._textInputProperties = PropertyProxy(param1);
         if(this._textInputProperties)
         {
            this._textInputProperties.addOnChangeCallback(this.childProperties_onChange);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get baseline() : Number
      {
         if(!this.textInput)
         {
            return this.scaledActualHeight;
         }
         return this.scaleY * (this.textInput.y + this.textInput.baseline);
      }
      
      public function get hasFocus() : Boolean
      {
         return this._hasFocus;
      }
      
      public function setFocus() : void
      {
         if(this.textInput === null)
         {
            return;
         }
         this.textInput.setFocus();
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
         var _loc4_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         var _loc5_:Boolean = this.isInvalid(INVALIDATION_FLAG_DECREMENT_BUTTON_FACTORY);
         var _loc6_:Boolean = this.isInvalid(INVALIDATION_FLAG_INCREMENT_BUTTON_FACTORY);
         var _loc7_:Boolean = this.isInvalid(INVALIDATION_FLAG_TEXT_INPUT_FACTORY);
         var _loc8_:Boolean = this.isInvalid(INVALIDATION_FLAG_FOCUS);
         if(_loc5_)
         {
            this.createDecrementButton();
         }
         if(_loc6_)
         {
            this.createIncrementButton();
         }
         if(_loc7_)
         {
            this.createTextInput();
         }
         if(_loc5_ || _loc2_)
         {
            this.refreshDecrementButtonStyles();
         }
         if(_loc6_ || _loc2_)
         {
            this.refreshIncrementButtonStyles();
         }
         if(_loc7_ || _loc2_)
         {
            this.refreshTextInputStyles();
         }
         if(_loc7_ || _loc1_)
         {
            this.refreshTypicalText();
            this.refreshDisplayedText();
         }
         if(_loc5_ || _loc4_)
         {
            this.decrementButton.isEnabled = this._isEnabled;
         }
         if(_loc6_ || _loc4_)
         {
            this.incrementButton.isEnabled = this._isEnabled;
         }
         if(_loc7_ || _loc4_)
         {
            this.textInput.isEnabled = this._isEnabled;
         }
         _loc3_ = this.autoSizeIfNeeded() || _loc3_;
         this.layoutChildren();
         if(_loc3_ || _loc8_)
         {
            this.refreshFocusIndicator();
         }
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc1_:Boolean = this._explicitWidth !== this._explicitWidth;
         var _loc2_:Boolean = this._explicitHeight !== this._explicitHeight;
         var _loc3_:Boolean = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc4_:Boolean = this._explicitMinHeight !== this._explicitMinHeight;
         if(!_loc1_ && !_loc2_ && !_loc3_ && !_loc4_)
         {
            return false;
         }
         var _loc5_:Number = this._explicitWidth;
         var _loc6_:Number = this._explicitHeight;
         var _loc7_:Number = this._explicitMinWidth;
         var _loc8_:Number = this._explicitMinHeight;
         this.decrementButton.validate();
         this.incrementButton.validate();
         var _loc9_:Number = this.decrementButton.width;
         var _loc10_:Number = this.decrementButton.height;
         var _loc11_:Number = this.decrementButton.minWidth;
         var _loc12_:Number = this.decrementButton.minHeight;
         var _loc13_:Number = this.incrementButton.width;
         var _loc14_:Number = this.incrementButton.height;
         var _loc15_:Number = this.incrementButton.minWidth;
         var _loc16_:Number = this.incrementButton.minHeight;
         var _loc17_:Number = this.textInputExplicitWidth;
         var _loc18_:Number = this.textInputExplicitHeight;
         var _loc19_:Number = this.textInputExplicitMinWidth;
         var _loc20_:Number = this.textInputExplicitMinHeight;
         var _loc21_:Number = Number.POSITIVE_INFINITY;
         var _loc22_:Number = Number.POSITIVE_INFINITY;
         if(this._buttonLayoutMode === StepperButtonLayoutMode.RIGHT_SIDE_VERTICAL)
         {
            _loc23_ = _loc9_;
            if(_loc13_ > _loc23_)
            {
               _loc23_ = _loc13_;
            }
            _loc24_ = _loc11_;
            if(_loc15_ > _loc24_)
            {
               _loc24_ = _loc15_;
            }
            if(!_loc1_)
            {
               _loc17_ = this._explicitWidth - _loc23_ - this._textInputGap;
            }
            if(!_loc2_)
            {
               _loc18_ = this._explicitHeight;
            }
            if(!_loc3_)
            {
               _loc19_ = this._explicitMinWidth - _loc24_ - this._textInputGap;
               if(this.textInputExplicitMinWidth > _loc19_)
               {
                  _loc19_ = this.textInputExplicitMinWidth;
               }
            }
            if(!_loc4_)
            {
               _loc20_ = this._explicitMinHeight;
               if(this.textInputExplicitMinHeight > _loc20_)
               {
                  _loc20_ = this.textInputExplicitMinHeight;
               }
            }
            _loc21_ = this._explicitMaxWidth - _loc23_ - this._textInputGap;
         }
         else if(this._buttonLayoutMode === StepperButtonLayoutMode.SPLIT_VERTICAL)
         {
            if(!_loc1_)
            {
               _loc17_ = this._explicitWidth;
            }
            if(!_loc2_)
            {
               _loc18_ = this._explicitHeight - _loc10_ - _loc14_;
            }
            if(!_loc3_)
            {
               _loc19_ = this._explicitMinWidth;
               if(this.textInputExplicitMinWidth > _loc19_)
               {
                  _loc19_ = this.textInputExplicitMinWidth;
               }
            }
            if(!_loc4_)
            {
               _loc20_ = this._explicitMinHeight - _loc12_ - _loc16_;
               if(this.textInputExplicitMinHeight > _loc20_)
               {
                  _loc20_ = this.textInputExplicitMinHeight;
               }
            }
            _loc22_ = this._explicitMaxHeight - _loc10_ - _loc14_;
         }
         else
         {
            if(!_loc1_)
            {
               _loc17_ = this._explicitWidth - _loc9_ - _loc13_;
            }
            if(!_loc2_)
            {
               _loc18_ = this._explicitHeight;
            }
            if(!_loc3_)
            {
               _loc19_ = this._explicitMinWidth - _loc11_ - _loc15_;
               if(_loc19_ < this.textInputExplicitMinWidth)
               {
                  _loc19_ = this.textInputExplicitMinWidth;
               }
            }
            if(!_loc4_)
            {
               _loc20_ = this._explicitMinHeight;
               if(this.textInputExplicitMinHeight > _loc20_)
               {
                  _loc20_ = this.textInputExplicitMinHeight;
               }
            }
            _loc21_ = this._explicitMaxWidth - _loc9_ - _loc13_;
         }
         if(_loc17_ < 0)
         {
            _loc17_ = 0;
         }
         if(_loc18_ < 0)
         {
            _loc18_ = 0;
         }
         if(_loc19_ < 0)
         {
            _loc19_ = 0;
         }
         if(_loc20_ < 0)
         {
            _loc20_ = 0;
         }
         this.textInput.width = _loc17_;
         this.textInput.height = _loc18_;
         this.textInput.minWidth = _loc19_;
         this.textInput.minHeight = _loc20_;
         this.textInput.maxWidth = _loc21_;
         this.textInput.maxHeight = _loc22_;
         this.textInput.validate();
         if(this._buttonLayoutMode === StepperButtonLayoutMode.RIGHT_SIDE_VERTICAL)
         {
            if(_loc1_)
            {
               _loc5_ = this.textInput.width + _loc23_ + this._textInputGap;
            }
            if(_loc2_)
            {
               _loc6_ = _loc10_ + this._buttonGap + _loc14_;
               if(this.textInput.height > _loc6_)
               {
                  _loc6_ = this.textInput.height;
               }
            }
            if(_loc3_)
            {
               _loc7_ = this.textInput.minWidth + _loc24_ + this._textInputGap;
            }
            if(_loc4_)
            {
               _loc8_ = _loc12_ + this._buttonGap + _loc16_;
               if(this.textInput.minHeight > _loc8_)
               {
                  _loc8_ = this.textInput.minHeight;
               }
            }
         }
         else if(this._buttonLayoutMode === StepperButtonLayoutMode.SPLIT_VERTICAL)
         {
            if(_loc1_)
            {
               _loc5_ = this.textInput.width;
               if(_loc9_ > _loc5_)
               {
                  _loc5_ = _loc9_;
               }
               if(_loc13_ > _loc5_)
               {
                  _loc5_ = _loc13_;
               }
            }
            if(_loc2_)
            {
               _loc6_ = _loc10_ + this.textInput.height + _loc14_ + 2 * this._textInputGap;
            }
            if(_loc3_)
            {
               _loc7_ = this.textInput.minWidth;
               if(_loc11_ > _loc7_)
               {
                  _loc7_ = _loc11_;
               }
               if(_loc15_ > _loc7_)
               {
                  _loc7_ = _loc15_;
               }
            }
            if(_loc4_)
            {
               _loc8_ = _loc12_ + this.textInput.minHeight + _loc16_ + 2 * this._textInputGap;
            }
         }
         else
         {
            if(_loc1_)
            {
               _loc5_ = _loc9_ + this.textInput.width + _loc13_ + 2 * this._textInputGap;
            }
            if(_loc2_)
            {
               _loc6_ = this.textInput.height;
               if(_loc10_ > _loc6_)
               {
                  _loc6_ = _loc10_;
               }
               if(_loc14_ > _loc6_)
               {
                  _loc6_ = _loc14_;
               }
            }
            if(_loc3_)
            {
               _loc7_ = _loc11_ + this.textInput.minWidth + _loc15_ + 2 * this._textInputGap;
            }
            if(_loc4_)
            {
               _loc8_ = this.textInput.minHeight;
               if(_loc12_ > _loc8_)
               {
                  _loc8_ = _loc12_;
               }
               if(_loc16_ > _loc8_)
               {
                  _loc8_ = _loc16_;
               }
            }
         }
         return this.saveMeasurements(_loc5_,_loc6_,_loc7_,_loc8_);
      }
      
      protected function decrement() : void
      {
         this.value = this._value - this._step;
         this.validate();
         this.textInput.selectRange(0,this.textInput.text.length);
      }
      
      protected function increment() : void
      {
         this.value = this._value + this._step;
         this.validate();
         this.textInput.selectRange(0,this.textInput.text.length);
      }
      
      protected function toMinimum() : void
      {
         this.value = this._minimum;
         this.validate();
         this.textInput.selectRange(0,this.textInput.text.length);
      }
      
      protected function toMaximum() : void
      {
         this.value = this._maximum;
         this.validate();
         this.textInput.selectRange(0,this.textInput.text.length);
      }
      
      protected function createDecrementButton() : void
      {
         if(this.decrementButton)
         {
            this.decrementButton.removeFromParent(true);
            this.decrementButton = null;
         }
         var _loc1_:Function = this._decrementButtonFactory != null ? this._decrementButtonFactory : defaultDecrementButtonFactory;
         var _loc2_:String = this._customDecrementButtonStyleName != null ? this._customDecrementButtonStyleName : this.decrementButtonStyleName;
         this.decrementButton = Button(_loc1_());
         this.decrementButton.styleNameList.add(_loc2_);
         this.decrementButton.addEventListener(TouchEvent.TOUCH,this.decrementButton_touchHandler);
         this.addChild(this.decrementButton);
      }
      
      protected function createIncrementButton() : void
      {
         if(this.incrementButton)
         {
            this.incrementButton.removeFromParent(true);
            this.incrementButton = null;
         }
         var _loc1_:Function = this._incrementButtonFactory != null ? this._incrementButtonFactory : defaultIncrementButtonFactory;
         var _loc2_:String = this._customIncrementButtonStyleName != null ? this._customIncrementButtonStyleName : this.incrementButtonStyleName;
         this.incrementButton = Button(_loc1_());
         this.incrementButton.styleNameList.add(_loc2_);
         this.incrementButton.addEventListener(TouchEvent.TOUCH,this.incrementButton_touchHandler);
         this.addChild(this.incrementButton);
      }
      
      protected function createTextInput() : void
      {
         if(this.textInput)
         {
            this.textInput.removeFromParent(true);
            this.textInput = null;
         }
         var _loc1_:Function = this._textInputFactory != null ? this._textInputFactory : defaultTextInputFactory;
         var _loc2_:String = this._customTextInputStyleName != null ? this._customTextInputStyleName : this.textInputStyleName;
         this.textInput = TextInput(_loc1_());
         this.textInput.styleNameList.add(_loc2_);
         this.textInput.addEventListener(FeathersEventType.ENTER,this.textInput_enterHandler);
         this.textInput.addEventListener(FeathersEventType.FOCUS_IN,this.textInput_focusInHandler);
         this.textInput.addEventListener(FeathersEventType.FOCUS_OUT,this.textInput_focusOutHandler);
         this.textInput.isFocusEnabled = !this._focusManager;
         this.addChild(this.textInput);
         this.textInput.initializeNow();
         this.textInputExplicitWidth = this.textInput.explicitWidth;
         this.textInputExplicitHeight = this.textInput.explicitHeight;
         this.textInputExplicitMinWidth = this.textInput.explicitMinWidth;
         this.textInputExplicitMinHeight = this.textInput.explicitMinHeight;
      }
      
      protected function refreshDecrementButtonStyles() : void
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         for(_loc1_ in this._decrementButtonProperties)
         {
            _loc2_ = this._decrementButtonProperties[_loc1_];
            this.decrementButton[_loc1_] = _loc2_;
         }
         this.decrementButton.label = this._decrementButtonLabel;
      }
      
      protected function refreshIncrementButtonStyles() : void
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         for(_loc1_ in this._incrementButtonProperties)
         {
            _loc2_ = this._incrementButtonProperties[_loc1_];
            this.incrementButton[_loc1_] = _loc2_;
         }
         this.incrementButton.label = this._incrementButtonLabel;
      }
      
      protected function refreshTextInputStyles() : void
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         for(_loc1_ in this._textInputProperties)
         {
            _loc2_ = this._textInputProperties[_loc1_];
            this.textInput[_loc1_] = _loc2_;
         }
      }
      
      protected function refreshDisplayedText() : void
      {
         if(this._valueFormatFunction != null)
         {
            this.textInput.text = this._valueFormatFunction(this._value);
         }
         else
         {
            this.textInput.text = this._value.toString();
         }
      }
      
      protected function refreshTypicalText() : void
      {
         var _loc1_:String = "";
         var _loc2_:Number = Math.max(int(this._minimum).toString().length,int(this._maximum).toString().length,int(this._step).toString().length);
         var _loc3_:Number = Math.max(roundToPrecision(this._minimum - int(this._minimum),10).toString().length,roundToPrecision(this._maximum - int(this._maximum),10).toString().length,roundToPrecision(this._step - int(this._step),10).toString().length) - 2;
         if(_loc3_ < 0)
         {
            _loc3_ = 0;
         }
         var _loc4_:int = _loc2_ + _loc3_;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc1_ += "0";
            _loc5_++;
         }
         if(_loc3_ > 0)
         {
            _loc1_ += ".";
         }
         this.textInput.typicalText = _loc1_;
      }
      
      protected function layoutChildren() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this._buttonLayoutMode === StepperButtonLayoutMode.RIGHT_SIDE_VERTICAL)
         {
            _loc1_ = (this.actualHeight - this._buttonGap) / 2;
            this.incrementButton.y = 0;
            this.incrementButton.height = _loc1_;
            this.incrementButton.validate();
            this.decrementButton.y = _loc1_ + this._buttonGap;
            this.decrementButton.height = _loc1_;
            this.decrementButton.validate();
            _loc2_ = Math.max(this.decrementButton.width,this.incrementButton.width);
            _loc3_ = this.actualWidth - _loc2_;
            this.decrementButton.x = _loc3_;
            this.incrementButton.x = _loc3_;
            this.textInput.x = 0;
            this.textInput.y = 0;
            this.textInput.width = _loc3_ - this._textInputGap;
            this.textInput.height = this.actualHeight;
         }
         else if(this._buttonLayoutMode === StepperButtonLayoutMode.SPLIT_VERTICAL)
         {
            this.incrementButton.x = 0;
            this.incrementButton.y = 0;
            this.incrementButton.width = this.actualWidth;
            this.incrementButton.validate();
            this.decrementButton.x = 0;
            this.decrementButton.width = this.actualWidth;
            this.decrementButton.validate();
            this.decrementButton.y = this.actualHeight - this.decrementButton.height;
            this.textInput.x = 0;
            this.textInput.y = this.incrementButton.height + this._textInputGap;
            this.textInput.width = this.actualWidth;
            this.textInput.height = Math.max(0,this.actualHeight - this.decrementButton.height - this.incrementButton.height - 2 * this._textInputGap);
         }
         else
         {
            this.decrementButton.x = 0;
            this.decrementButton.y = 0;
            this.decrementButton.height = this.actualHeight;
            this.decrementButton.validate();
            this.incrementButton.y = 0;
            this.incrementButton.height = this.actualHeight;
            this.incrementButton.validate();
            this.incrementButton.x = this.actualWidth - this.incrementButton.width;
            this.textInput.x = this.decrementButton.width + this._textInputGap;
            this.textInput.width = this.actualWidth - this.decrementButton.width - this.incrementButton.width - 2 * this._textInputGap;
            this.textInput.height = this.actualHeight;
         }
         this.textInput.validate();
      }
      
      protected function startRepeatTimer(param1:Function) : void
      {
         var _loc2_:ExclusiveTouch = null;
         var _loc3_:DisplayObject = null;
         if(this.touchPointID >= 0)
         {
            _loc2_ = ExclusiveTouch.forStage(this.stage);
            _loc3_ = _loc2_.getClaim(this.touchPointID);
            if(_loc3_ != this)
            {
               if(_loc3_)
               {
                  return;
               }
               _loc2_.claimTouch(this.touchPointID,this);
            }
         }
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
      
      protected function parseTextInputValue() : void
      {
         var _loc1_:Number = NaN;
         if(this._valueParseFunction != null)
         {
            _loc1_ = this._valueParseFunction(this.textInput.text);
         }
         else
         {
            _loc1_ = parseFloat(this.textInput.text);
         }
         if(_loc1_ === _loc1_)
         {
            this.value = _loc1_;
         }
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      protected function childProperties_onChange(param1:PropertyProxy, param2:Object) : void
      {
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      protected function numericStepper_removedFromStageHandler(param1:Event) : void
      {
         this.touchPointID = -1;
      }
      
      override protected function focusInHandler(param1:Event) : void
      {
         super.focusInHandler(param1);
         this.textInput.setFocus();
         this.textInput.selectRange(0,this.textInput.text.length);
         this.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.stage_keyDownHandler);
      }
      
      override protected function focusOutHandler(param1:Event) : void
      {
         super.focusOutHandler(param1);
         this.textInput.clearFocus();
         this.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.stage_keyDownHandler);
      }
      
      protected function textInput_enterHandler(param1:Event) : void
      {
         this.parseTextInputValue();
      }
      
      protected function textInput_focusInHandler(param1:Event) : void
      {
         this._textInputHasFocus = true;
      }
      
      protected function textInput_focusOutHandler(param1:Event) : void
      {
         this._textInputHasFocus = false;
         this.parseTextInputValue();
      }
      
      protected function decrementButton_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         if(!this._isEnabled)
         {
            this.touchPointID = -1;
            return;
         }
         if(this.touchPointID >= 0)
         {
            _loc2_ = param1.getTouch(this.decrementButton,TouchPhase.ENDED,this.touchPointID);
            if(!_loc2_)
            {
               return;
            }
            this.touchPointID = -1;
            this._repeatTimer.stop();
            this.dispatchEventWith(FeathersEventType.END_INTERACTION);
         }
         else
         {
            _loc2_ = param1.getTouch(this.decrementButton,TouchPhase.BEGAN);
            if(!_loc2_)
            {
               return;
            }
            if(this._textInputHasFocus)
            {
               this.parseTextInputValue();
            }
            this.touchPointID = _loc2_.id;
            this.dispatchEventWith(FeathersEventType.BEGIN_INTERACTION);
            this.decrement();
            this.startRepeatTimer(this.decrement);
         }
      }
      
      protected function incrementButton_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         if(!this._isEnabled)
         {
            this.touchPointID = -1;
            return;
         }
         if(this.touchPointID >= 0)
         {
            _loc2_ = param1.getTouch(this.incrementButton,TouchPhase.ENDED,this.touchPointID);
            if(!_loc2_)
            {
               return;
            }
            this.touchPointID = -1;
            this._repeatTimer.stop();
            this.dispatchEventWith(FeathersEventType.END_INTERACTION);
         }
         else
         {
            _loc2_ = param1.getTouch(this.incrementButton,TouchPhase.BEGAN);
            if(!_loc2_)
            {
               return;
            }
            if(this._textInputHasFocus)
            {
               this.parseTextInputValue();
            }
            this.touchPointID = _loc2_.id;
            this.dispatchEventWith(FeathersEventType.BEGIN_INTERACTION);
            this.increment();
            this.startRepeatTimer(this.increment);
         }
      }
      
      protected function stage_keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.HOME)
         {
            param1.preventDefault();
            this.toMinimum();
         }
         else if(param1.keyCode == Keyboard.END)
         {
            param1.preventDefault();
            this.toMaximum();
         }
         else if(this._useLeftAndRightKeys)
         {
            if(param1.keyCode == Keyboard.RIGHT)
            {
               param1.preventDefault();
               this.increment();
            }
            else if(param1.keyCode == Keyboard.LEFT)
            {
               param1.preventDefault();
               this.decrement();
            }
         }
         else if(param1.keyCode == Keyboard.UP)
         {
            param1.preventDefault();
            this.increment();
         }
         else if(param1.keyCode == Keyboard.DOWN)
         {
            param1.preventDefault();
            this.decrement();
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

