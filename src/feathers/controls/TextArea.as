package feathers.controls
{
   import feathers.controls.text.ITextEditorViewPort;
   import feathers.controls.text.TextFieldTextEditorViewPort;
   import feathers.core.FeathersControl;
   import feathers.core.IAdvancedNativeFocusOwner;
   import feathers.core.IFeathersControl;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.INativeFocusOwner;
   import feathers.core.IStateContext;
   import feathers.core.IStateObserver;
   import feathers.core.ITextRenderer;
   import feathers.core.PopUpManager;
   import feathers.core.PropertyProxy;
   import feathers.events.FeathersEventType;
   import feathers.skins.IStyleProvider;
   import feathers.text.FontStylesSet;
   import flash.events.KeyboardEvent;
   import flash.geom.Point;
   import flash.ui.Mouse;
   import flash.ui.MouseCursor;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.text.TextFormat;
   import starling.utils.Pool;
   
   public class TextArea extends Scroller implements IAdvancedNativeFocusOwner, IStateContext
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      public static const DEFAULT_CHILD_STYLE_NAME_TEXT_EDITOR:String = "feathers-text-area-text-editor";
      
      public static const DEFAULT_CHILD_STYLE_NAME_PROMPT:String = "feathers-text-input-prompt";
      
      public static const DEFAULT_CHILD_STYLE_NAME_ERROR_CALLOUT:String = "feathers-text-area-error-callout";
      
      protected static const INVALIDATION_FLAG_ERROR_CALLOUT_FACTORY:String = "errorCalloutFactory";
      
      protected static const INVALIDATION_FLAG_PROMPT_FACTORY:String = "promptFactory";
      
      protected var textEditorViewPort:ITextEditorViewPort;
      
      protected var callout:TextCallout;
      
      protected var promptTextRenderer:ITextRenderer;
      
      protected var textEditorStyleName:String = "feathers-text-area-text-editor";
      
      protected var promptStyleName:String = "feathers-text-input-prompt";
      
      protected var errorCalloutStyleName:String = "feathers-text-area-error-callout";
      
      protected var _textEditorHasFocus:Boolean = false;
      
      protected var _isWaitingToSetFocus:Boolean = false;
      
      protected var _pendingSelectionBeginIndex:int = -1;
      
      protected var _pendingSelectionEndIndex:int = -1;
      
      protected var _textAreaTouchPointID:int = -1;
      
      protected var _oldMouseCursor:String = null;
      
      protected var _ignoreTextChanges:Boolean = false;
      
      protected var _currentState:String = "enabled";
      
      protected var _text:String = "";
      
      protected var _prompt:String = null;
      
      protected var _maxChars:int = 0;
      
      protected var _restrict:String;
      
      protected var _isEditable:Boolean = true;
      
      protected var _errorString:String = null;
      
      protected var _stateToSkin:Object = {};
      
      protected var _fontStylesSet:FontStylesSet;
      
      protected var _textEditorFactory:Function;
      
      protected var _customTextEditorStyleName:String;
      
      protected var _textEditorProperties:PropertyProxy;
      
      protected var _promptFontStylesSet:FontStylesSet;
      
      protected var _promptFactory:Function;
      
      protected var _customPromptStyleName:String;
      
      protected var _customErrorCalloutStyleName:String;
      
      protected var _innerPaddingTop:Number = 0;
      
      protected var _innerPaddingRight:Number = 0;
      
      protected var _innerPaddingBottom:Number = 0;
      
      protected var _innerPaddingLeft:Number = 0;
      
      public function TextArea()
      {
         super();
         if(this._fontStylesSet === null)
         {
            this._fontStylesSet = new FontStylesSet();
            this._fontStylesSet.addEventListener(Event.CHANGE,this.fontStyles_changeHandler);
         }
         if(this._promptFontStylesSet === null)
         {
            this._promptFontStylesSet = new FontStylesSet();
            this._promptFontStylesSet.addEventListener(Event.CHANGE,this.fontStyles_changeHandler);
         }
         this._measureViewPort = false;
         this.addEventListener(TouchEvent.TOUCH,this.textArea_touchHandler);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.textArea_removedFromStageHandler);
      }
      
      public function get nativeFocus() : Object
      {
         if(this.textEditorViewPort is INativeFocusOwner)
         {
            return INativeFocusOwner(this.textEditorViewPort).nativeFocus;
         }
         return null;
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return TextArea.globalStyleProvider;
      }
      
      override public function get isFocusEnabled() : Boolean
      {
         if(this._isEditable)
         {
            return this._isEnabled && this._isFocusEnabled;
         }
         return super.isFocusEnabled;
      }
      
      public function get hasFocus() : Boolean
      {
         if(!this._focusManager)
         {
            return this._textEditorHasFocus;
         }
         return this._hasFocus;
      }
      
      override public function set isEnabled(param1:Boolean) : void
      {
         super.isEnabled = param1;
         this.refreshState();
      }
      
      public function get currentState() : String
      {
         return this._currentState;
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function set text(param1:String) : void
      {
         if(!param1)
         {
            param1 = "";
         }
         if(this._text == param1)
         {
            return;
         }
         this._text = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get prompt() : String
      {
         return this._prompt;
      }
      
      public function set prompt(param1:String) : void
      {
         if(this._prompt == param1)
         {
            return;
         }
         this._prompt = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get maxChars() : int
      {
         return this._maxChars;
      }
      
      public function set maxChars(param1:int) : void
      {
         if(this._maxChars == param1)
         {
            return;
         }
         this._maxChars = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get restrict() : String
      {
         return this._restrict;
      }
      
      public function set restrict(param1:String) : void
      {
         if(this._restrict == param1)
         {
            return;
         }
         this._restrict = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get isEditable() : Boolean
      {
         return this._isEditable;
      }
      
      public function set isEditable(param1:Boolean) : void
      {
         if(this._isEditable == param1)
         {
            return;
         }
         this._isEditable = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get errorString() : String
      {
         return this._errorString;
      }
      
      public function set errorString(param1:String) : void
      {
         if(this._errorString === param1)
         {
            return;
         }
         this._errorString = param1;
         this.refreshState();
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      override public function get backgroundDisabledSkin() : DisplayObject
      {
         return this.getSkinForState(TextInputState.DISABLED);
      }
      
      override public function set backgroundDisabledSkin(param1:DisplayObject) : void
      {
         this.setSkinForState(TextInputState.DISABLED,param1);
      }
      
      public function get backgroundFocusedSkin() : DisplayObject
      {
         return this.getSkinForState(TextInputState.FOCUSED);
      }
      
      public function set backgroundFocusedSkin(param1:DisplayObject) : void
      {
         this.setSkinForState(TextInputState.FOCUSED,param1);
      }
      
      public function get backgroundErrorSkin() : DisplayObject
      {
         return this.getSkinForState(TextInputState.ERROR);
      }
      
      public function set backgroundErrorSkin(param1:DisplayObject) : void
      {
         this.setSkinForState(TextInputState.ERROR,param1);
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
      
      public function get textEditorFactory() : Function
      {
         return this._textEditorFactory;
      }
      
      public function set textEditorFactory(param1:Function) : void
      {
         if(this._textEditorFactory == param1)
         {
            return;
         }
         this._textEditorFactory = param1;
         this.invalidate(INVALIDATION_FLAG_TEXT_EDITOR);
      }
      
      public function get customTextEditorStyleName() : String
      {
         return this._customTextEditorStyleName;
      }
      
      public function set customTextEditorStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customTextEditorStyleName === param1)
         {
            return;
         }
         this._customTextEditorStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
      }
      
      public function get textEditorProperties() : Object
      {
         if(!this._textEditorProperties)
         {
            this._textEditorProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._textEditorProperties;
      }
      
      public function set textEditorProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         var _loc3_:String = null;
         if(this._textEditorProperties == param1)
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
         if(this._textEditorProperties)
         {
            this._textEditorProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._textEditorProperties = PropertyProxy(param1);
         if(this._textEditorProperties)
         {
            this._textEditorProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get promptFontStyles() : TextFormat
      {
         return this._promptFontStylesSet.format;
      }
      
      public function set promptFontStyles(param1:TextFormat) : void
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
         this._promptFontStylesSet.format = value;
         if(value !== null)
         {
            value.addEventListener(Event.CHANGE,changeHandler);
         }
      }
      
      public function get promptDisabledFontStyles() : TextFormat
      {
         return this._promptFontStylesSet.disabledFormat;
      }
      
      public function set promptDisabledFontStyles(param1:TextFormat) : void
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
         this._promptFontStylesSet.disabledFormat = value;
         if(value !== null)
         {
            value.addEventListener(Event.CHANGE,changeHandler);
         }
      }
      
      public function get promptFactory() : Function
      {
         return this._promptFactory;
      }
      
      public function set promptFactory(param1:Function) : void
      {
         if(this._promptFactory == param1)
         {
            return;
         }
         this._promptFactory = param1;
         this.invalidate(INVALIDATION_FLAG_PROMPT_FACTORY);
      }
      
      public function get customPromptStyleName() : String
      {
         return this._customPromptStyleName;
      }
      
      public function set customPromptStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customPromptStyleName === param1)
         {
            return;
         }
         this._customPromptStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
      }
      
      public function get customErrorCalloutStyleName() : String
      {
         return this._customErrorCalloutStyleName;
      }
      
      public function set customErrorCalloutStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customErrorCalloutStyleName === param1)
         {
            return;
         }
         this._customErrorCalloutStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_ERROR_CALLOUT_FACTORY);
      }
      
      public function get innerPadding() : Number
      {
         return this._innerPaddingTop;
      }
      
      public function set innerPadding(param1:Number) : void
      {
         this.innerPaddingTop = param1;
         this.innerPaddingRight = param1;
         this.innerPaddingBottom = param1;
         this.innerPaddingLeft = param1;
      }
      
      public function get innerPaddingTop() : Number
      {
         return this._innerPaddingTop;
      }
      
      public function set innerPaddingTop(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._innerPaddingTop == param1)
         {
            return;
         }
         this._innerPaddingTop = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get innerPaddingRight() : Number
      {
         return this._innerPaddingRight;
      }
      
      public function set innerPaddingRight(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._innerPaddingRight == param1)
         {
            return;
         }
         this._innerPaddingRight = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get paddinnerPaddingBottomingBottom() : Number
      {
         return this._innerPaddingBottom;
      }
      
      public function set innerPaddingBottom(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._innerPaddingBottom == param1)
         {
            return;
         }
         this._innerPaddingBottom = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get innerPaddingLeft() : Number
      {
         return this._innerPaddingLeft;
      }
      
      public function set innerPaddingLeft(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._innerPaddingLeft == param1)
         {
            return;
         }
         this._innerPaddingLeft = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get selectionBeginIndex() : int
      {
         if(this._pendingSelectionBeginIndex >= 0)
         {
            return this._pendingSelectionBeginIndex;
         }
         if(this.textEditorViewPort)
         {
            return this.textEditorViewPort.selectionBeginIndex;
         }
         return 0;
      }
      
      public function get selectionEndIndex() : int
      {
         if(this._pendingSelectionEndIndex >= 0)
         {
            return this._pendingSelectionEndIndex;
         }
         if(this.textEditorViewPort)
         {
            return this.textEditorViewPort.selectionEndIndex;
         }
         return 0;
      }
      
      public function setFocus() : void
      {
         if(this._textEditorHasFocus)
         {
            return;
         }
         if(this.textEditorViewPort)
         {
            this._isWaitingToSetFocus = false;
            this.textEditorViewPort.setFocus();
         }
         else
         {
            this._isWaitingToSetFocus = true;
            this.invalidate(INVALIDATION_FLAG_SELECTED);
         }
      }
      
      public function clearFocus() : void
      {
         this._isWaitingToSetFocus = false;
         if(!this.textEditorViewPort || !this._textEditorHasFocus)
         {
            return;
         }
         this.textEditorViewPort.clearFocus();
      }
      
      public function selectRange(param1:int, param2:int = -1) : void
      {
         if(param2 < 0)
         {
            param2 = param1;
         }
         if(param1 < 0)
         {
            throw new RangeError("Expected begin index greater than or equal to 0. Received " + param1 + ".");
         }
         if(param2 > this._text.length)
         {
            throw new RangeError("Expected begin index less than " + this._text.length + ". Received " + param2 + ".");
         }
         if(this.textEditorViewPort !== null && (this._isValidating || !this.isInvalid()))
         {
            this._pendingSelectionBeginIndex = -1;
            this._pendingSelectionEndIndex = -1;
            this.textEditorViewPort.selectRange(param1,param2);
         }
         else
         {
            this._pendingSelectionBeginIndex = param1;
            this._pendingSelectionEndIndex = param2;
            this.invalidate(INVALIDATION_FLAG_SELECTED);
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:String = null;
         var _loc2_:DisplayObject = null;
         for(_loc1_ in this._stateToSkin)
         {
            _loc2_ = this._stateToSkin[_loc1_] as DisplayObject;
            if(_loc2_ !== null && _loc2_.parent !== this)
            {
               _loc2_.dispose();
            }
         }
         if(this._fontStylesSet !== null)
         {
            this._fontStylesSet.dispose();
            this._fontStylesSet = null;
         }
         if(this._promptFontStylesSet !== null)
         {
            this._promptFontStylesSet.dispose();
            this._promptFontStylesSet = null;
         }
         super.dispose();
      }
      
      public function getFontStylesForState(param1:String) : TextFormat
      {
         if(this._fontStylesSet === null)
         {
            return null;
         }
         return this._fontStylesSet.getFormatForState(param1);
      }
      
      public function setFontStylesForState(param1:String, param2:TextFormat) : void
      {
         var key:String = null;
         var changeHandler:Function = null;
         var state:String = param1;
         var format:TextFormat = param2;
         changeHandler = function(param1:Event):void
         {
            processStyleRestriction(key);
         };
         key = "setFontStylesForState--" + state;
         if(this.processStyleRestriction(key))
         {
            return;
         }
         if(format !== null)
         {
            format.removeEventListener(Event.CHANGE,changeHandler);
         }
         this._fontStylesSet.setFormatForState(state,format);
         if(format !== null)
         {
            format.addEventListener(Event.CHANGE,changeHandler);
         }
      }
      
      public function getPromptFontStylesForState(param1:String) : TextFormat
      {
         if(this._promptFontStylesSet === null)
         {
            return null;
         }
         return this._promptFontStylesSet.getFormatForState(param1);
      }
      
      public function setPromptFontStylesForState(param1:String, param2:TextFormat) : void
      {
         var key:String = null;
         var changeHandler:Function = null;
         var state:String = param1;
         var format:TextFormat = param2;
         changeHandler = function(param1:Event):void
         {
            processStyleRestriction(key);
         };
         key = "setPromptFontStylesForState--" + state;
         if(this.processStyleRestriction(key))
         {
            return;
         }
         if(format !== null)
         {
            format.removeEventListener(Event.CHANGE,changeHandler);
         }
         this._promptFontStylesSet.setFormatForState(state,format);
         if(format !== null)
         {
            format.addEventListener(Event.CHANGE,changeHandler);
         }
      }
      
      public function getSkinForState(param1:String) : DisplayObject
      {
         return this._stateToSkin[param1] as DisplayObject;
      }
      
      public function setSkinForState(param1:String, param2:DisplayObject) : void
      {
         var _loc3_:String = "setSkinForState--" + param1;
         if(this.processStyleRestriction(_loc3_))
         {
            if(param2 !== null)
            {
               param2.dispose();
            }
            return;
         }
         if(param2 !== null)
         {
            this._stateToSkin[param1] = param2;
         }
         else
         {
            delete this._stateToSkin[param1];
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      override protected function draw() : void
      {
         var _loc6_:Boolean = false;
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_TEXT_EDITOR);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc4_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         var _loc5_:Boolean = this.isInvalid(INVALIDATION_FLAG_PROMPT_FACTORY);
         if(_loc1_)
         {
            this.createTextEditor();
         }
         if(_loc5_ || this._prompt !== null && !this.promptTextRenderer)
         {
            this.createPrompt();
         }
         if(_loc1_ || _loc3_)
         {
            this.refreshTextEditorProperties();
         }
         if(_loc1_ || _loc2_)
         {
            _loc6_ = this._ignoreTextChanges;
            this._ignoreTextChanges = true;
            this.textEditorViewPort.text = this._text;
            this._ignoreTextChanges = _loc6_;
         }
         if(_loc5_ || _loc3_)
         {
            this.refreshPromptProperties();
         }
         if(this.promptTextRenderer)
         {
            if(_loc5_ || _loc2_ || _loc3_)
            {
               this.promptTextRenderer.visible = Boolean(this._prompt) && this._text.length == 0;
            }
            if(_loc5_ || _loc4_)
            {
               this.promptTextRenderer.isEnabled = this._isEnabled;
            }
         }
         if(_loc1_ || _loc4_)
         {
            this.textEditorViewPort.isEnabled = this._isEnabled;
            if(!this._isEnabled && Mouse.supportsNativeCursor && Boolean(this._oldMouseCursor))
            {
               Mouse.cursor = this._oldMouseCursor;
               this._oldMouseCursor = null;
            }
         }
         super.draw();
         if(_loc4_ || _loc3_)
         {
            this.refreshErrorCallout();
         }
         this.doPendingActions();
      }
      
      protected function createTextEditor() : void
      {
         if(this.textEditorViewPort)
         {
            this.textEditorViewPort.removeEventListener(Event.CHANGE,this.textEditor_changeHandler);
            this.textEditorViewPort.removeEventListener(FeathersEventType.FOCUS_IN,this.textEditor_focusInHandler);
            this.textEditorViewPort.removeEventListener(FeathersEventType.FOCUS_OUT,this.textEditor_focusOutHandler);
            this.textEditorViewPort = null;
         }
         if(this._textEditorFactory != null)
         {
            this.textEditorViewPort = ITextEditorViewPort(this._textEditorFactory());
         }
         else
         {
            this.textEditorViewPort = new TextFieldTextEditorViewPort();
         }
         var _loc1_:String = this._customTextEditorStyleName != null ? this._customTextEditorStyleName : this.textEditorStyleName;
         this.textEditorViewPort.styleNameList.add(_loc1_);
         if(this.textEditorViewPort is IStateObserver)
         {
            IStateObserver(this.textEditorViewPort).stateContext = this;
         }
         this.textEditorViewPort.addEventListener(Event.CHANGE,this.textEditor_changeHandler);
         this.textEditorViewPort.addEventListener(FeathersEventType.FOCUS_IN,this.textEditor_focusInHandler);
         this.textEditorViewPort.addEventListener(FeathersEventType.FOCUS_OUT,this.textEditor_focusOutHandler);
         var _loc2_:ITextEditorViewPort = ITextEditorViewPort(this._viewPort);
         this.viewPort = this.textEditorViewPort;
         if(_loc2_)
         {
            _loc2_.dispose();
         }
      }
      
      protected function createPrompt() : void
      {
         if(this.promptTextRenderer)
         {
            this.removeChild(DisplayObject(this.promptTextRenderer),true);
            this.promptTextRenderer = null;
         }
         if(this._prompt === null)
         {
            return;
         }
         var _loc1_:Function = this._promptFactory != null ? this._promptFactory : FeathersControl.defaultTextRendererFactory;
         this.promptTextRenderer = ITextRenderer(_loc1_());
         var _loc2_:String = this._customPromptStyleName != null ? this._customPromptStyleName : this.promptStyleName;
         this.promptTextRenderer.styleNameList.add(_loc2_);
         this.addChild(DisplayObject(this.promptTextRenderer));
      }
      
      protected function createErrorCallout() : void
      {
         if(this.callout !== null)
         {
            this.callout.removeFromParent(true);
            this.callout = null;
         }
         if(this._errorString === null)
         {
            return;
         }
         this.callout = new TextCallout();
         var _loc1_:String = this._customErrorCalloutStyleName != null ? this._customErrorCalloutStyleName : this.errorCalloutStyleName;
         this.callout.styleNameList.add(_loc1_);
         this.callout.closeOnKeys = null;
         this.callout.closeOnTouchBeganOutside = false;
         this.callout.closeOnTouchEndedOutside = false;
         this.callout.touchable = false;
         this.callout.origin = this;
         PopUpManager.addPopUp(this.callout,false,false);
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
      
      protected function doPendingActions() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this._isWaitingToSetFocus || Boolean(this._focusManager) && Boolean(this._focusManager.focus == this))
         {
            this._isWaitingToSetFocus = false;
            if(!this._textEditorHasFocus)
            {
               this.textEditorViewPort.setFocus();
            }
         }
         if(this._pendingSelectionBeginIndex >= 0)
         {
            _loc1_ = this._pendingSelectionBeginIndex;
            _loc2_ = this._pendingSelectionEndIndex;
            this._pendingSelectionBeginIndex = -1;
            this._pendingSelectionEndIndex = -1;
            this.selectRange(_loc1_,_loc2_);
         }
      }
      
      protected function refreshTextEditorProperties() : void
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         this.textEditorViewPort.fontStyles = this._fontStylesSet;
         this.textEditorViewPort.maxChars = this._maxChars;
         this.textEditorViewPort.restrict = this._restrict;
         this.textEditorViewPort.isEditable = this._isEditable;
         this.textEditorViewPort.paddingTop = this._innerPaddingTop;
         this.textEditorViewPort.paddingRight = this._innerPaddingRight;
         this.textEditorViewPort.paddingBottom = this._innerPaddingBottom;
         this.textEditorViewPort.paddingLeft = this._innerPaddingLeft;
         for(_loc1_ in this._textEditorProperties)
         {
            _loc2_ = this._textEditorProperties[_loc1_];
            this.textEditorViewPort[_loc1_] = _loc2_;
         }
      }
      
      protected function refreshPromptProperties() : void
      {
         if(!this.promptTextRenderer)
         {
            return;
         }
         this.promptTextRenderer.text = this._prompt;
         this.promptTextRenderer.fontStyles = this._promptFontStylesSet;
      }
      
      override protected function refreshBackgroundSkin() : void
      {
         var _loc2_:IMeasureDisplayObject = null;
         var _loc1_:DisplayObject = this.currentBackgroundSkin;
         this.currentBackgroundSkin = this.getCurrentBackgroundSkin();
         switch(_loc1_)
         {
            default:
               if(_loc1_ is IStateObserver)
               {
                  IStateObserver(_loc1_).stateContext = null;
               }
               this.removeChild(_loc1_,false);
            case null:
               if(this.currentBackgroundSkin !== null)
               {
                  if(this.currentBackgroundSkin is IStateObserver)
                  {
                     IStateObserver(this.currentBackgroundSkin).stateContext = this;
                  }
                  this.addChildAt(this.currentBackgroundSkin,0);
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
                     break;
                  }
                  this._explicitBackgroundWidth = this.currentBackgroundSkin.width;
                  this._explicitBackgroundHeight = this.currentBackgroundSkin.height;
                  this._explicitBackgroundMinWidth = this._explicitBackgroundWidth;
                  this._explicitBackgroundMinHeight = this._explicitBackgroundHeight;
               }
               break;
            case this.currentBackgroundSkin:
         }
      }
      
      override protected function getCurrentBackgroundSkin() : DisplayObject
      {
         var _loc1_:DisplayObject = this._stateToSkin[this._currentState] as DisplayObject;
         if(_loc1_ !== null)
         {
            return _loc1_;
         }
         return this._backgroundSkin;
      }
      
      protected function refreshState() : void
      {
         if(this._isEnabled)
         {
            if(this._textEditorHasFocus)
            {
               this.changeState(TextInputState.FOCUSED);
            }
            else if(this._errorString !== null)
            {
               this.changeState(TextInputState.ERROR);
            }
            else
            {
               this.changeState(TextInputState.ENABLED);
            }
         }
         else
         {
            this.changeState(TextInputState.DISABLED);
         }
      }
      
      protected function refreshErrorCallout() : void
      {
         if(this._textEditorHasFocus && this.callout === null && this._errorString !== null && this._errorString.length > 0)
         {
            this.createErrorCallout();
         }
         else if(this.callout !== null && (!this._textEditorHasFocus || this._errorString === null || this._errorString.length == 0))
         {
            this.callout.removeFromParent(true);
            this.callout = null;
         }
         if(this.callout !== null)
         {
            this.callout.text = this._errorString;
         }
      }
      
      override protected function layoutChildren() : void
      {
         super.layoutChildren();
         if(this.promptTextRenderer !== null)
         {
            this.promptTextRenderer.x = this._leftViewPortOffset + this._innerPaddingLeft;
            this.promptTextRenderer.y = this._topViewPortOffset + this._innerPaddingTop;
            this.promptTextRenderer.width = this.actualWidth - this._leftViewPortOffset - this._rightViewPortOffset - this._innerPaddingLeft - this._innerPaddingRight;
            this.promptTextRenderer.height = this.actualHeight - this._topViewPortOffset - this._bottomViewPortOffset - this._innerPaddingTop - this._innerPaddingBottom;
         }
      }
      
      protected function setFocusOnTextEditorWithTouch(param1:Touch) : void
      {
         if(!this.isFocusEnabled)
         {
            return;
         }
         var _loc2_:Point = Pool.getPoint();
         param1.getLocation(this.stage,_loc2_);
         var _loc3_:Boolean = this.contains(this.stage.hitTest(_loc2_));
         if(!this._textEditorHasFocus && _loc3_)
         {
            this.globalToLocal(_loc2_,_loc2_);
            _loc2_.x -= this._paddingLeft;
            _loc2_.y -= this._paddingTop;
            this._isWaitingToSetFocus = false;
            this.textEditorViewPort.setFocus(_loc2_);
         }
         Pool.putPoint(_loc2_);
      }
      
      protected function textArea_touchHandler(param1:TouchEvent) : void
      {
         var _loc4_:Touch = null;
         if(!this._isEnabled)
         {
            this._textAreaTouchPointID = -1;
            return;
         }
         var _loc2_:DisplayObject = DisplayObject(this.horizontalScrollBar);
         var _loc3_:DisplayObject = DisplayObject(this.verticalScrollBar);
         if(this._textAreaTouchPointID >= 0)
         {
            _loc4_ = param1.getTouch(this,TouchPhase.ENDED,this._textAreaTouchPointID);
            if(!_loc4_ || _loc4_.isTouching(_loc3_) || _loc4_.isTouching(_loc2_))
            {
               return;
            }
            this.removeEventListener(Event.SCROLL,this.textArea_scrollHandler);
            this._textAreaTouchPointID = -1;
            if(this.textEditorViewPort.setTouchFocusOnEndedPhase)
            {
               this.setFocusOnTextEditorWithTouch(_loc4_);
            }
         }
         else
         {
            _loc4_ = param1.getTouch(this,TouchPhase.BEGAN);
            if(_loc4_)
            {
               if(_loc4_.isTouching(_loc3_) || _loc4_.isTouching(_loc2_))
               {
                  return;
               }
               this._textAreaTouchPointID = _loc4_.id;
               if(!this.textEditorViewPort.setTouchFocusOnEndedPhase)
               {
                  this.setFocusOnTextEditorWithTouch(_loc4_);
               }
               this.addEventListener(Event.SCROLL,this.textArea_scrollHandler);
               return;
            }
            _loc4_ = param1.getTouch(this,TouchPhase.HOVER);
            if(_loc4_)
            {
               if(_loc4_.isTouching(_loc3_) || _loc4_.isTouching(_loc2_))
               {
                  return;
               }
               if(Mouse.supportsNativeCursor && !this._oldMouseCursor)
               {
                  this._oldMouseCursor = Mouse.cursor;
                  Mouse.cursor = MouseCursor.IBEAM;
               }
               return;
            }
            if(Mouse.supportsNativeCursor && Boolean(this._oldMouseCursor))
            {
               Mouse.cursor = this._oldMouseCursor;
               this._oldMouseCursor = null;
            }
         }
      }
      
      protected function textArea_scrollHandler(param1:Event) : void
      {
         this.removeEventListener(Event.SCROLL,this.textArea_scrollHandler);
         this._textAreaTouchPointID = -1;
      }
      
      protected function textArea_removedFromStageHandler(param1:Event) : void
      {
         if(!this._focusManager && this._textEditorHasFocus)
         {
            this.clearFocus();
         }
         this._isWaitingToSetFocus = false;
         this._textEditorHasFocus = false;
         this._textAreaTouchPointID = -1;
         this.removeEventListener(Event.SCROLL,this.textArea_scrollHandler);
         if(Mouse.supportsNativeCursor && Boolean(this._oldMouseCursor))
         {
            Mouse.cursor = this._oldMouseCursor;
            this._oldMouseCursor = null;
         }
      }
      
      override protected function focusInHandler(param1:Event) : void
      {
         if(!this._focusManager)
         {
            return;
         }
         super.focusInHandler(param1);
         this.setFocus();
      }
      
      override protected function focusOutHandler(param1:Event) : void
      {
         if(!this._focusManager)
         {
            return;
         }
         super.focusOutHandler(param1);
         this.textEditorViewPort.clearFocus();
         this.invalidate(INVALIDATION_FLAG_STATE);
      }
      
      override protected function nativeStage_keyDownHandler(param1:KeyboardEvent) : void
      {
         if(this._isEditable)
         {
            return;
         }
         super.nativeStage_keyDownHandler(param1);
      }
      
      protected function textEditor_changeHandler(param1:Event) : void
      {
         if(this._ignoreTextChanges)
         {
            return;
         }
         this.text = this.textEditorViewPort.text;
      }
      
      protected function textEditor_focusInHandler(param1:Event) : void
      {
         this._textEditorHasFocus = true;
         this.refreshState();
         this.refreshErrorCallout();
         this._touchPointID = -1;
         this.invalidate(INVALIDATION_FLAG_STATE);
         if(Boolean(this._focusManager) && Boolean(this.isFocusEnabled) && this._focusManager.focus !== this)
         {
            this._focusManager.focus = this;
         }
         else if(!this._focusManager)
         {
            this.dispatchEventWith(FeathersEventType.FOCUS_IN);
         }
      }
      
      protected function textEditor_focusOutHandler(param1:Event) : void
      {
         this._textEditorHasFocus = false;
         this.refreshState();
         this.refreshErrorCallout();
         this.invalidate(INVALIDATION_FLAG_STATE);
         if(Boolean(this._focusManager) && this._focusManager.focus === this)
         {
            this._focusManager.focus = null;
         }
         else if(!this._focusManager)
         {
            this.dispatchEventWith(FeathersEventType.FOCUS_OUT);
         }
      }
      
      protected function fontStyles_changeHandler(param1:Event) : void
      {
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
   }
}

