package feathers.controls.text
{
   import feathers.core.BaseTextEditor;
   import feathers.core.FocusManager;
   import feathers.core.IFeathersControl;
   import feathers.core.INativeFocusOwner;
   import feathers.core.ITextEditor;
   import feathers.events.FeathersEventType;
   import feathers.skins.IStyleProvider;
   import feathers.utils.geom.matrixToRotation;
   import feathers.utils.geom.matrixToScaleX;
   import feathers.utils.geom.matrixToScaleY;
   import flash.display.BitmapData;
   import flash.display.Stage;
   import flash.display3D.Context3DProfile;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.SoftKeyboardEvent;
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import flash.text.FontType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.ui.Keyboard;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.rendering.Painter;
   import starling.text.TextFormat;
   import starling.textures.ConcreteTexture;
   import starling.textures.Texture;
   import starling.utils.Align;
   import starling.utils.MathUtil;
   import starling.utils.MatrixUtil;
   import starling.utils.Pool;
   import starling.utils.SystemUtil;
   
   public class TextFieldTextEditor extends BaseTextEditor implements ITextEditor, INativeFocusOwner
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      protected var textField:TextField;
      
      protected var textSnapshot:Image;
      
      protected var measureTextField:TextField;
      
      protected var _snapshotWidth:int = 0;
      
      protected var _snapshotHeight:int = 0;
      
      protected var _textFieldSnapshotClipRect:flash.geom.Rectangle = new flash.geom.Rectangle();
      
      protected var _textFieldOffsetX:Number = 0;
      
      protected var _textFieldOffsetY:Number = 0;
      
      protected var _lastGlobalScaleX:Number = 0;
      
      protected var _lastGlobalScaleY:Number = 0;
      
      protected var _needsTextureUpdate:Boolean = false;
      
      protected var _needsNewTexture:Boolean = false;
      
      protected var _previousStarlingTextFormat:starling.text.TextFormat;
      
      protected var _currentStarlingTextFormat:starling.text.TextFormat;
      
      protected var _previousTextFormat:flash.text.TextFormat;
      
      protected var _currentTextFormat:flash.text.TextFormat;
      
      protected var _textFormatForState:Object;
      
      protected var _fontStylesTextFormat:flash.text.TextFormat;
      
      protected var _textFormat:flash.text.TextFormat;
      
      protected var _disabledTextFormat:flash.text.TextFormat;
      
      protected var _embedFonts:Boolean = false;
      
      protected var _wordWrap:Boolean = false;
      
      protected var _multiline:Boolean = false;
      
      protected var _isHTML:Boolean = false;
      
      protected var _alwaysShowSelection:Boolean = false;
      
      protected var _displayAsPassword:Boolean = false;
      
      protected var _maxChars:int = 0;
      
      protected var _restrict:String;
      
      protected var _isEditable:Boolean = true;
      
      protected var _isSelectable:Boolean = true;
      
      private var _antiAliasType:String = "advanced";
      
      private var _gridFitType:String = "pixel";
      
      private var _sharpness:Number = 0;
      
      private var _thickness:Number = 0;
      
      private var _background:Boolean = false;
      
      private var _backgroundColor:uint = 16777215;
      
      private var _border:Boolean = false;
      
      private var _borderColor:uint = 0;
      
      protected var _useGutter:Boolean = false;
      
      protected var _textFieldHasFocus:Boolean = false;
      
      protected var _isWaitingToSetFocus:Boolean = false;
      
      protected var _pendingSelectionBeginIndex:int = -1;
      
      protected var _pendingSelectionEndIndex:int = -1;
      
      protected var _maintainTouchFocus:Boolean = false;
      
      protected var _updateSnapshotOnScaleChange:Boolean = false;
      
      protected var _useSnapshotDelayWorkaround:Boolean = false;
      
      protected var _softKeyboard:String = "default";
      
      protected var _resetScrollOnFocusOut:Boolean = true;
      
      public function TextFieldTextEditor()
      {
         super();
         this.isQuickHitAreaEnabled = true;
         this.addEventListener(starling.events.Event.ADDED_TO_STAGE,this.textEditor_addedToStageHandler);
         this.addEventListener(starling.events.Event.REMOVED_FROM_STAGE,this.textEditor_removedFromStageHandler);
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return globalStyleProvider;
      }
      
      public function get nativeFocus() : Object
      {
         return this.textField;
      }
      
      public function get baseline() : Number
      {
         if(!this.textField)
         {
            return 0;
         }
         var _loc1_:Number = 0;
         if(this._useGutter || this._border)
         {
            _loc1_ = 2;
         }
         return _loc1_ + this.textField.getLineMetrics(0).ascent;
      }
      
      public function get currentTextFormat() : flash.text.TextFormat
      {
         return this._currentTextFormat;
      }
      
      public function get textFormat() : flash.text.TextFormat
      {
         return this._textFormat;
      }
      
      public function set textFormat(param1:flash.text.TextFormat) : void
      {
         if(this._textFormat == param1)
         {
            return;
         }
         this._textFormat = param1;
         this._previousTextFormat = null;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get disabledTextFormat() : flash.text.TextFormat
      {
         return this._disabledTextFormat;
      }
      
      public function set disabledTextFormat(param1:flash.text.TextFormat) : void
      {
         if(this._disabledTextFormat == param1)
         {
            return;
         }
         this._disabledTextFormat = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get embedFonts() : Boolean
      {
         return this._embedFonts;
      }
      
      public function set embedFonts(param1:Boolean) : void
      {
         if(this._embedFonts == param1)
         {
            return;
         }
         this._embedFonts = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get wordWrap() : Boolean
      {
         return this._wordWrap;
      }
      
      public function set wordWrap(param1:Boolean) : void
      {
         if(this._wordWrap == param1)
         {
            return;
         }
         this._wordWrap = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get multiline() : Boolean
      {
         return this._multiline;
      }
      
      public function set multiline(param1:Boolean) : void
      {
         if(this._multiline == param1)
         {
            return;
         }
         this._multiline = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get isHTML() : Boolean
      {
         return this._isHTML;
      }
      
      public function set isHTML(param1:Boolean) : void
      {
         if(this._isHTML == param1)
         {
            return;
         }
         this._isHTML = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get alwaysShowSelection() : Boolean
      {
         return this._alwaysShowSelection;
      }
      
      public function set alwaysShowSelection(param1:Boolean) : void
      {
         if(this._alwaysShowSelection == param1)
         {
            return;
         }
         this._alwaysShowSelection = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get displayAsPassword() : Boolean
      {
         return this._displayAsPassword;
      }
      
      public function set displayAsPassword(param1:Boolean) : void
      {
         if(this._displayAsPassword == param1)
         {
            return;
         }
         this._displayAsPassword = param1;
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
      
      public function get isSelectable() : Boolean
      {
         return this._isSelectable;
      }
      
      public function set isSelectable(param1:Boolean) : void
      {
         if(this._isSelectable == param1)
         {
            return;
         }
         this._isSelectable = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get antiAliasType() : String
      {
         return this._antiAliasType;
      }
      
      public function set antiAliasType(param1:String) : void
      {
         if(this._antiAliasType == param1)
         {
            return;
         }
         this._antiAliasType = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get gridFitType() : String
      {
         return this._gridFitType;
      }
      
      public function set gridFitType(param1:String) : void
      {
         if(this._gridFitType == param1)
         {
            return;
         }
         this._gridFitType = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get sharpness() : Number
      {
         return this._sharpness;
      }
      
      public function set sharpness(param1:Number) : void
      {
         if(this._sharpness == param1)
         {
            return;
         }
         this._sharpness = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get thickness() : Number
      {
         return this._thickness;
      }
      
      public function set thickness(param1:Number) : void
      {
         if(this._thickness == param1)
         {
            return;
         }
         this._thickness = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get background() : Boolean
      {
         return this._background;
      }
      
      public function set background(param1:Boolean) : void
      {
         if(this._background == param1)
         {
            return;
         }
         this._background = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get backgroundColor() : uint
      {
         return this._backgroundColor;
      }
      
      public function set backgroundColor(param1:uint) : void
      {
         if(this._backgroundColor == param1)
         {
            return;
         }
         this._backgroundColor = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get border() : Boolean
      {
         return this._border;
      }
      
      public function set border(param1:Boolean) : void
      {
         if(this._border == param1)
         {
            return;
         }
         this._border = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get borderColor() : uint
      {
         return this._borderColor;
      }
      
      public function set borderColor(param1:uint) : void
      {
         if(this._borderColor == param1)
         {
            return;
         }
         this._borderColor = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get useGutter() : Boolean
      {
         return this._useGutter || this._border;
      }
      
      public function set useGutter(param1:Boolean) : void
      {
         if(this._useGutter == param1)
         {
            return;
         }
         this._useGutter = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get setTouchFocusOnEndedPhase() : Boolean
      {
         return false;
      }
      
      public function get selectionBeginIndex() : int
      {
         if(this._pendingSelectionBeginIndex >= 0)
         {
            return this._pendingSelectionBeginIndex;
         }
         if(this.textField)
         {
            return this.textField.selectionBeginIndex;
         }
         return 0;
      }
      
      public function get selectionEndIndex() : int
      {
         if(this._pendingSelectionEndIndex >= 0)
         {
            return this._pendingSelectionEndIndex;
         }
         if(this.textField)
         {
            return this.textField.selectionEndIndex;
         }
         return 0;
      }
      
      override public function get maintainTouchFocus() : Boolean
      {
         return this._maintainTouchFocus;
      }
      
      public function set maintainTouchFocus(param1:Boolean) : void
      {
         this._maintainTouchFocus = param1;
      }
      
      public function get updateSnapshotOnScaleChange() : Boolean
      {
         return this._updateSnapshotOnScaleChange;
      }
      
      public function set updateSnapshotOnScaleChange(param1:Boolean) : void
      {
         if(this._updateSnapshotOnScaleChange == param1)
         {
            return;
         }
         this._updateSnapshotOnScaleChange = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get useSnapshotDelayWorkaround() : Boolean
      {
         return this._useSnapshotDelayWorkaround;
      }
      
      public function set useSnapshotDelayWorkaround(param1:Boolean) : void
      {
         if(this._useSnapshotDelayWorkaround == param1)
         {
            return;
         }
         this._useSnapshotDelayWorkaround = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get softKeyboard() : String
      {
         return this._softKeyboard;
      }
      
      public function set softKeyboard(param1:String) : void
      {
         if(this._softKeyboard === param1)
         {
            return;
         }
         this._softKeyboard = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get resetScrollOnFocusOut() : Boolean
      {
         return this._resetScrollOnFocusOut;
      }
      
      public function set resetScrollOnFocusOut(param1:Boolean) : void
      {
         this._resetScrollOnFocusOut = param1;
      }
      
      override public function dispose() : void
      {
         if(this.textSnapshot)
         {
            this.textSnapshot.texture.dispose();
            this.removeChild(this.textSnapshot,true);
            this.textSnapshot = null;
         }
         if(this.textField)
         {
            if(this.textField.parent)
            {
               this.textField.parent.removeChild(this.textField);
            }
            this.textField.removeEventListener(flash.events.Event.CHANGE,this.textField_changeHandler);
            this.textField.removeEventListener(FocusEvent.FOCUS_IN,this.textField_focusInHandler);
            this.textField.removeEventListener(FocusEvent.FOCUS_OUT,this.textField_focusOutHandler);
            this.textField.removeEventListener(KeyboardEvent.KEY_DOWN,this.textField_keyDownHandler);
            this.textField.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING,this.textField_softKeyboardActivatingHandler);
            this.textField.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE,this.textField_softKeyboardActivateHandler);
            this.textField.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE,this.textField_softKeyboardDeactivateHandler);
         }
         this.textField = null;
         this.measureTextField = null;
         this.stateContext = null;
         super.dispose();
      }
      
      override public function render(param1:Painter) : void
      {
         var _loc2_:Matrix = null;
         if(this.textSnapshot !== null && this._updateSnapshotOnScaleChange)
         {
            _loc2_ = Pool.getMatrix();
            this.getTransformationMatrix(this.stage,_loc2_);
            if(matrixToScaleX(_loc2_) != this._lastGlobalScaleX || matrixToScaleY(_loc2_) != this._lastGlobalScaleY)
            {
               this.invalidate(INVALIDATION_FLAG_SIZE);
               this.validate();
            }
            Pool.putMatrix(_loc2_);
         }
         if(this._needsTextureUpdate)
         {
            this._needsTextureUpdate = false;
            if(this._useSnapshotDelayWorkaround)
            {
               this.addEventListener(starling.events.Event.ENTER_FRAME,this.refreshSnapshot_enterFrameHandler);
            }
            else
            {
               this.refreshSnapshot();
            }
            this.positionSnapshot();
         }
         if(Boolean(this.textField) && this.textField.visible)
         {
            this.transformTextField();
         }
         super.render(param1);
      }
      
      public function setFocus(param1:Point = null) : void
      {
         var starling:Starling = null;
         var nativeScaleFactor:Number = NaN;
         var scaleFactor:Number = NaN;
         var scaleX:Number = NaN;
         var scaleY:Number = NaN;
         var gutterPositionOffset:Number = NaN;
         var positionX:Number = NaN;
         var positionY:Number = NaN;
         var maxPositionX:Number = NaN;
         var maxPositionY:Number = NaN;
         var lineIndex:int = 0;
         var bounds:flash.geom.Rectangle = null;
         var boundsX:Number = NaN;
         var position:Point = param1;
         if(this.textField !== null)
         {
            starling = this.stage !== null ? this.stage.starling : Starling.current;
            if(this.textField.parent === null)
            {
               starling.nativeStage.addChild(this.textField);
            }
            if(position !== null)
            {
               nativeScaleFactor = 1;
               if(starling.supportHighResolutions)
               {
                  nativeScaleFactor = starling.nativeStage.contentsScaleFactor;
               }
               scaleFactor = starling.contentScaleFactor / nativeScaleFactor;
               scaleX = this.textField.scaleX;
               scaleY = this.textField.scaleY;
               gutterPositionOffset = 2;
               if(this._useGutter || this._border)
               {
                  gutterPositionOffset = 0;
               }
               positionX = position.x + gutterPositionOffset;
               positionY = position.y + gutterPositionOffset;
               if(positionX < gutterPositionOffset)
               {
                  positionX = gutterPositionOffset;
               }
               else
               {
                  maxPositionX = this.textField.width / scaleX - gutterPositionOffset;
                  if(positionX > maxPositionX)
                  {
                     positionX = maxPositionX;
                  }
               }
               if(positionY < gutterPositionOffset)
               {
                  positionY = gutterPositionOffset;
               }
               else
               {
                  maxPositionY = this.textField.height / scaleY - gutterPositionOffset;
                  if(positionY > maxPositionY)
                  {
                     positionY = maxPositionY;
                  }
               }
               this._pendingSelectionBeginIndex = this.getSelectionIndexAtPoint(positionX,positionY);
               if(this._pendingSelectionBeginIndex < 0)
               {
                  if(this._multiline)
                  {
                     lineIndex = this.textField.getLineIndexAtPoint(this.textField.width / 2 / scaleX,positionY);
                     try
                     {
                        this._pendingSelectionBeginIndex = this.textField.getLineOffset(lineIndex) + this.textField.getLineLength(lineIndex);
                        if(this._pendingSelectionBeginIndex != this._text.length)
                        {
                           --this._pendingSelectionBeginIndex;
                        }
                     }
                     catch(error:Error)
                     {
                        this._pendingSelectionBeginIndex = this._text.length;
                     }
                  }
                  else
                  {
                     this._pendingSelectionBeginIndex = this.getSelectionIndexAtPoint(positionX,this.textField.getLineMetrics(0).ascent / 2);
                     if(this._pendingSelectionBeginIndex < 0)
                     {
                        this._pendingSelectionBeginIndex = this._text.length;
                     }
                  }
               }
               else
               {
                  bounds = this.textField.getCharBoundaries(this._pendingSelectionBeginIndex);
                  if(bounds)
                  {
                     boundsX = bounds.x;
                     if(Boolean(bounds) && boundsX + bounds.width - positionX < positionX - boundsX)
                     {
                        ++this._pendingSelectionBeginIndex;
                     }
                  }
               }
               this._pendingSelectionEndIndex = this._pendingSelectionBeginIndex;
            }
            else
            {
               this._pendingSelectionBeginIndex = this._pendingSelectionEndIndex = -1;
            }
            if(!FocusManager.isEnabledForStage(this.stage))
            {
               starling.nativeStage.focus = this.textField;
            }
            this.textField.requestSoftKeyboard();
            if(this._textFieldHasFocus)
            {
               this.invalidate(INVALIDATION_FLAG_SELECTED);
            }
         }
         else
         {
            this._isWaitingToSetFocus = true;
         }
      }
      
      public function clearFocus() : void
      {
         if(!this._textFieldHasFocus)
         {
            return;
         }
         var _loc1_:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         var _loc2_:Stage = _loc1_.nativeStage;
         if(_loc2_.focus === this.textField)
         {
            _loc2_.focus = null;
         }
      }
      
      public function selectRange(param1:int, param2:int) : void
      {
         if(!this._isEditable && !this._isSelectable)
         {
            return;
         }
         if(this.textField)
         {
            if(!this._isValidating)
            {
               this.validate();
            }
            this.textField.setSelection(param1,param2);
         }
         else
         {
            this._pendingSelectionBeginIndex = param1;
            this._pendingSelectionEndIndex = param2;
         }
      }
      
      public function measureText(param1:Point = null) : Point
      {
         if(!param1)
         {
            param1 = new Point();
         }
         var _loc2_:Boolean = this._explicitWidth !== this._explicitWidth;
         var _loc3_:Boolean = this._explicitHeight !== this._explicitHeight;
         if(!_loc2_ && !_loc3_)
         {
            param1.x = this._explicitWidth;
            param1.y = this._explicitHeight;
            return param1;
         }
         if(!this._isInitialized)
         {
            this.initializeNow();
         }
         this.commit();
         return this.measure(param1);
      }
      
      public function getTextFormatForState(param1:String) : flash.text.TextFormat
      {
         if(this._textFormatForState === null)
         {
            return null;
         }
         return TextFormat(this._textFormatForState[param1]);
      }
      
      public function setTextFormatForState(param1:String, param2:flash.text.TextFormat) : void
      {
         if(param2)
         {
            if(!this._textFormatForState)
            {
               this._textFormatForState = {};
            }
            this._textFormatForState[param1] = param2;
         }
         else
         {
            delete this._textFormatForState[param1];
         }
         if(Boolean(this._stateContext) && this._stateContext.currentState === param1)
         {
            this.invalidate(INVALIDATION_FLAG_STATE);
         }
      }
      
      override protected function initialize() : void
      {
         this.textField = new TextField();
         this.textField.tabEnabled = false;
         this.textField.visible = false;
         this.textField.needsSoftKeyboard = true;
         this.textField.addEventListener(flash.events.Event.CHANGE,this.textField_changeHandler);
         this.textField.addEventListener(FocusEvent.FOCUS_IN,this.textField_focusInHandler);
         this.textField.addEventListener(FocusEvent.FOCUS_OUT,this.textField_focusOutHandler);
         this.textField.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.textField_mouseFocusChangeHandler);
         this.textField.addEventListener(KeyboardEvent.KEY_DOWN,this.textField_keyDownHandler);
         this.textField.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING,this.textField_softKeyboardActivatingHandler);
         this.textField.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE,this.textField_softKeyboardActivateHandler);
         this.textField.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE,this.textField_softKeyboardDeactivateHandler);
         this.measureTextField = new TextField();
         this.measureTextField.autoSize = TextFieldAutoSize.LEFT;
         this.measureTextField.selectable = false;
         this.measureTextField.tabEnabled = false;
         this.measureTextField.mouseWheelEnabled = false;
         this.measureTextField.mouseEnabled = false;
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
         this.commit();
         _loc1_ = this.autoSizeIfNeeded() || _loc1_;
         this.layout(_loc1_);
      }
      
      protected function commit() : void
      {
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         if(_loc2_ || _loc1_ || _loc3_)
         {
            this.refreshTextFormat();
            this.commitStylesAndData(this.textField);
         }
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
         var _loc5_:Point = Pool.getPoint();
         this.measure(_loc5_);
         var _loc6_:Boolean = this.saveMeasurements(_loc5_.x,_loc5_.y,_loc5_.x,_loc5_.y);
         Pool.putPoint(_loc5_);
         return _loc6_;
      }
      
      protected function measure(param1:Point = null) : Point
      {
         if(!param1)
         {
            param1 = new Point();
         }
         var _loc2_:Boolean = this._explicitWidth !== this._explicitWidth;
         var _loc3_:Boolean = this._explicitHeight !== this._explicitHeight;
         if(!_loc2_ && !_loc3_)
         {
            param1.x = this._explicitWidth;
            param1.y = this._explicitHeight;
            return param1;
         }
         this.commitStylesAndData(this.measureTextField);
         var _loc4_:Number = 4;
         if(this._useGutter || this._border)
         {
            _loc4_ = 0;
         }
         var _loc5_:Number = this._explicitWidth;
         if(_loc2_)
         {
            this.measureTextField.wordWrap = false;
            _loc5_ = this.measureTextField.width - _loc4_;
            if(_loc5_ < this._explicitMinWidth)
            {
               _loc5_ = this._explicitMinWidth;
            }
            else if(_loc5_ > this._explicitMaxWidth)
            {
               _loc5_ = this._explicitMaxWidth;
            }
         }
         var _loc6_:Number = this._explicitHeight;
         if(_loc3_)
         {
            this.measureTextField.wordWrap = this._wordWrap;
            this.measureTextField.width = _loc5_ + _loc4_;
            _loc6_ = this.measureTextField.height - _loc4_;
            if(this._useGutter || this._border)
            {
               _loc6_ += 4;
            }
            if(_loc6_ < this._explicitMinHeight)
            {
               _loc6_ = this._explicitMinHeight;
            }
            else if(_loc6_ > this._explicitMaxHeight)
            {
               _loc6_ = this._explicitMaxHeight;
            }
         }
         param1.x = _loc5_;
         param1.y = _loc6_;
         return param1;
      }
      
      protected function commitStylesAndData(param1:TextField) : void
      {
         param1.antiAliasType = this._antiAliasType;
         param1.background = this._background;
         param1.backgroundColor = this._backgroundColor;
         param1.border = this._border;
         param1.borderColor = this._borderColor;
         param1.gridFitType = this._gridFitType;
         param1.sharpness = this._sharpness;
         param1.thickness = this._thickness;
         param1.maxChars = this._maxChars;
         param1.restrict = this._restrict;
         param1.alwaysShowSelection = this._alwaysShowSelection;
         param1.displayAsPassword = this._displayAsPassword;
         param1.wordWrap = this._wordWrap;
         param1.multiline = this._multiline;
         if("softKeyboard" in param1)
         {
            param1["softKeyboard"] = this._softKeyboard;
         }
         if(!this._embedFonts && this._currentTextFormat === this._fontStylesTextFormat)
         {
            param1.embedFonts = SystemUtil.isEmbeddedFont(this._currentTextFormat.font,this._currentTextFormat.bold,this._currentTextFormat.italic,FontType.EMBEDDED);
         }
         else
         {
            param1.embedFonts = this._embedFonts;
         }
         param1.type = this._isEditable ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
         param1.selectable = this._isEnabled && (this._isEditable || this._isSelectable);
         var _loc2_:Boolean = false;
         if(param1 === this.textField)
         {
            if(this._currentTextFormat === this._fontStylesTextFormat)
            {
               _loc2_ = this._previousStarlingTextFormat !== this._currentStarlingTextFormat;
            }
            else
            {
               _loc2_ = this._previousTextFormat !== this._currentTextFormat;
            }
            this._previousStarlingTextFormat = this._currentStarlingTextFormat;
            this._previousTextFormat = this._currentTextFormat;
         }
         else
         {
            _loc2_ = true;
         }
         param1.defaultTextFormat = this._currentTextFormat;
         if(this._isHTML)
         {
            if(_loc2_ || param1.htmlText != this._text)
            {
               if(param1 == this.textField && this._pendingSelectionBeginIndex < 0)
               {
                  this._pendingSelectionBeginIndex = this.textField.selectionBeginIndex;
                  this._pendingSelectionEndIndex = this.textField.selectionEndIndex;
               }
               param1.htmlText = this._text;
            }
         }
         else if(_loc2_ || param1.text != this._text)
         {
            if(param1 == this.textField && this._pendingSelectionBeginIndex < 0)
            {
               this._pendingSelectionBeginIndex = this.textField.selectionBeginIndex;
               this._pendingSelectionEndIndex = this.textField.selectionEndIndex;
            }
            param1.text = this._text;
         }
      }
      
      protected function refreshTextFormat() : void
      {
         var _loc1_:flash.text.TextFormat = null;
         var _loc2_:String = null;
         if(this._stateContext !== null)
         {
            if(this._textFormatForState !== null)
            {
               _loc2_ = this._stateContext.currentState;
               if(_loc2_ in this._textFormatForState)
               {
                  _loc1_ = TextFormat(this._textFormatForState[_loc2_]);
               }
            }
            if(_loc1_ === null && this._disabledTextFormat !== null && this._stateContext is IFeathersControl && !IFeathersControl(this._stateContext).isEnabled)
            {
               _loc1_ = this._disabledTextFormat;
            }
         }
         else if(!this._isEnabled && this._disabledTextFormat !== null)
         {
            _loc1_ = this._disabledTextFormat;
         }
         switch(_loc1_)
         {
            case null:
               _loc1_ = this._textFormat;
               if(_loc1_ !== null)
               {
                  break;
               }
            case null:
               _loc1_ = this.getTextFormatFromFontStyles();
         }
         this._currentTextFormat = _loc1_;
      }
      
      protected function getTextFormatFromFontStyles() : flash.text.TextFormat
      {
         if(this.isInvalid(INVALIDATION_FLAG_STYLES) || this.isInvalid(INVALIDATION_FLAG_STATE))
         {
            if(this._fontStyles !== null)
            {
               this._currentStarlingTextFormat = this._fontStyles.getTextFormatForTarget(this);
            }
            else
            {
               this._currentStarlingTextFormat = null;
            }
            if(this._currentStarlingTextFormat !== null)
            {
               this._fontStylesTextFormat = this._currentStarlingTextFormat.toNativeFormat(this._fontStylesTextFormat);
            }
            else if(this._fontStylesTextFormat === null)
            {
               this._fontStylesTextFormat = new flash.text.TextFormat();
            }
         }
         return this._fontStylesTextFormat;
      }
      
      protected function getVerticalAlignment() : String
      {
         var _loc2_:starling.text.TextFormat = null;
         var _loc1_:String = null;
         if(this._fontStyles !== null)
         {
            _loc2_ = this._fontStyles.getTextFormatForTarget(this);
            if(_loc2_ !== null)
            {
               _loc1_ = _loc2_.verticalAlign;
            }
         }
         if(_loc1_ === null)
         {
            _loc1_ = Align.TOP;
         }
         return _loc1_;
      }
      
      protected function getVerticalAlignmentOffsetY() : Number
      {
         var _loc1_:String = this.getVerticalAlignment();
         var _loc2_:Number = this.textField.textHeight;
         if(_loc2_ > this.actualHeight)
         {
            return 0;
         }
         switch(_loc1_)
         {
            case Align.BOTTOM:
               return this.actualHeight - _loc2_;
            case Align.CENTER:
               return (this.actualHeight - _loc2_) / 2;
            default:
               return 0;
         }
      }
      
      protected function layout(param1:Boolean) : void
      {
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         var _loc4_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         if(param1)
         {
            this.refreshSnapshotParameters();
            this.refreshTextFieldSize();
            this.transformTextField();
            this.positionSnapshot();
         }
         this.checkIfNewSnapshotIsNeeded();
         if(!this._textFieldHasFocus && (param1 || _loc2_ || _loc3_ || _loc4_ || this._needsNewTexture))
         {
            this._needsTextureUpdate = true;
            this.setRequiresRedraw();
         }
         this.doPendingActions();
      }
      
      protected function getSelectionIndexAtPoint(param1:Number, param2:Number) : int
      {
         return this.textField.getCharIndexAtPoint(param1,param2);
      }
      
      protected function refreshTextFieldSize() : void
      {
         var _loc1_:Number = 4;
         if(this._useGutter || this._border)
         {
            _loc1_ = 0;
         }
         this.textField.width = this.actualWidth + _loc1_;
         this.textField.height = this.actualHeight + _loc1_;
      }
      
      protected function refreshSnapshotParameters() : void
      {
         var _loc5_:Matrix = null;
         this._textFieldOffsetX = 0;
         this._textFieldOffsetY = 0;
         this._textFieldSnapshotClipRect.x = 0;
         this._textFieldSnapshotClipRect.y = 0;
         var _loc1_:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         var _loc2_:Number = _loc1_.contentScaleFactor;
         var _loc3_:Number = this.actualWidth * _loc2_;
         if(this._updateSnapshotOnScaleChange)
         {
            _loc5_ = Pool.getMatrix();
            this.getTransformationMatrix(this.stage,_loc5_);
            _loc3_ *= matrixToScaleX(_loc5_);
         }
         if(_loc3_ < 0)
         {
            _loc3_ = 0;
         }
         var _loc4_:Number = this.actualHeight * _loc2_;
         if(this._updateSnapshotOnScaleChange)
         {
            _loc4_ *= matrixToScaleY(_loc5_);
            Pool.putMatrix(_loc5_);
         }
         if(_loc4_ < 0)
         {
            _loc4_ = 0;
         }
         this._textFieldSnapshotClipRect.width = _loc3_;
         this._textFieldSnapshotClipRect.height = _loc4_;
      }
      
      protected function transformTextField() : void
      {
         var _loc12_:Matrix3D = null;
         var _loc13_:Vector3D = null;
         var _loc1_:Matrix = Pool.getMatrix();
         var _loc2_:Point = Pool.getPoint();
         this.getTransformationMatrix(this.stage,_loc1_);
         var _loc3_:Number = matrixToScaleX(_loc1_);
         var _loc4_:Number = matrixToScaleY(_loc1_);
         var _loc5_:Number = _loc3_;
         if(_loc4_ < _loc5_)
         {
            _loc5_ = _loc4_;
         }
         var _loc6_:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         var _loc7_:Number = 1;
         if(_loc6_.supportHighResolutions)
         {
            _loc7_ = _loc6_.nativeStage.contentsScaleFactor;
         }
         var _loc8_:Number = _loc6_.contentScaleFactor / _loc7_;
         var _loc9_:Number = 0;
         if(!this._useGutter || this._border)
         {
            _loc9_ = 2 * _loc5_;
         }
         var _loc10_:Number = this.getVerticalAlignmentOffsetY();
         if(this.is3D)
         {
            _loc12_ = Pool.getMatrix3D();
            _loc13_ = Pool.getPoint3D();
            this.getTransformationMatrix3D(this.stage,_loc12_);
            MatrixUtil.transformCoords3D(_loc12_,-_loc9_,-_loc9_ + _loc10_,0,_loc13_);
            _loc2_.setTo(_loc13_.x,_loc13_.y);
            Pool.putPoint3D(_loc13_);
            Pool.putMatrix3D(_loc12_);
         }
         else
         {
            MatrixUtil.transformCoords(_loc1_,-_loc9_,-_loc9_ + _loc10_,_loc2_);
         }
         var _loc11_:flash.geom.Rectangle = _loc6_.viewPort;
         this.textField.x = Math.round(_loc11_.x + _loc2_.x * _loc8_);
         this.textField.y = Math.round(_loc11_.y + _loc2_.y * _loc8_);
         this.textField.rotation = matrixToRotation(_loc1_) * 180 / Math.PI;
         this.textField.scaleX = matrixToScaleX(_loc1_) * _loc8_;
         this.textField.scaleY = matrixToScaleY(_loc1_) * _loc8_;
         Pool.putPoint(_loc2_);
         Pool.putMatrix(_loc1_);
      }
      
      protected function positionSnapshot() : void
      {
         if(!this.textSnapshot)
         {
            return;
         }
         var _loc1_:Matrix = Pool.getMatrix();
         this.getTransformationMatrix(this.stage,_loc1_);
         this.textSnapshot.x = Math.round(_loc1_.tx) - _loc1_.tx;
         this.textSnapshot.y = Math.round(_loc1_.ty) - _loc1_.ty;
         this.textSnapshot.y += this.getVerticalAlignmentOffsetY();
         Pool.putMatrix(_loc1_);
      }
      
      protected function checkIfNewSnapshotIsNeeded() : void
      {
         var _loc1_:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         var _loc2_:Boolean = _loc1_.profile !== Context3DProfile.BASELINE_CONSTRAINED;
         if(_loc2_)
         {
            this._snapshotWidth = this._textFieldSnapshotClipRect.width;
            this._snapshotHeight = this._textFieldSnapshotClipRect.height;
         }
         else
         {
            this._snapshotWidth = MathUtil.getNextPowerOfTwo(this._textFieldSnapshotClipRect.width);
            this._snapshotHeight = MathUtil.getNextPowerOfTwo(this._textFieldSnapshotClipRect.height);
         }
         var _loc3_:ConcreteTexture = this.textSnapshot ? this.textSnapshot.texture.root : null;
         this._needsNewTexture = this._needsNewTexture || !this.textSnapshot || _loc3_ !== null && (_loc3_.scale != _loc1_.contentScaleFactor || this._snapshotWidth != _loc3_.nativeWidth || this._snapshotHeight != _loc3_.nativeHeight);
      }
      
      protected function doPendingActions() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this._isWaitingToSetFocus)
         {
            this._isWaitingToSetFocus = false;
            this.setFocus();
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
      
      protected function texture_onRestore() : void
      {
         var _loc1_:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         if(Boolean(this.textSnapshot) && Boolean(this.textSnapshot.texture) && this.textSnapshot.texture.scale != _loc1_.contentScaleFactor)
         {
            this.invalidate(INVALIDATION_FLAG_SIZE);
         }
         else
         {
            this.refreshSnapshot();
         }
      }
      
      protected function refreshSnapshot() : void
      {
         var _loc6_:Texture = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Texture = null;
         if(this._snapshotWidth <= 0 || this._snapshotHeight <= 0)
         {
            return;
         }
         var _loc1_:Number = 2;
         if(this._useGutter || this._border)
         {
            _loc1_ = 0;
         }
         var _loc2_:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         var _loc3_:Number = _loc2_.contentScaleFactor;
         var _loc4_:Matrix = Pool.getMatrix();
         if(this._updateSnapshotOnScaleChange)
         {
            this.getTransformationMatrix(this.stage,_loc4_);
            _loc7_ = matrixToScaleX(_loc4_);
            _loc8_ = matrixToScaleY(_loc4_);
         }
         _loc4_.identity();
         _loc4_.translate(this._textFieldOffsetX - _loc1_,this._textFieldOffsetY - _loc1_);
         _loc4_.scale(_loc3_,_loc3_);
         if(this._updateSnapshotOnScaleChange)
         {
            _loc4_.scale(_loc7_,_loc8_);
         }
         var _loc5_:BitmapData = new BitmapData(this._snapshotWidth,this._snapshotHeight,true,16711935);
         _loc5_.draw(this.textField,_loc4_,null,null,this._textFieldSnapshotClipRect);
         Pool.putMatrix(_loc4_);
         if(!this.textSnapshot || this._needsNewTexture)
         {
            _loc6_ = Texture.empty(_loc5_.width / _loc3_,_loc5_.height / _loc3_,true,false,false,_loc3_);
            _loc6_.root.uploadBitmapData(_loc5_);
            _loc6_.root.onRestore = this.texture_onRestore;
         }
         if(!this.textSnapshot)
         {
            this.textSnapshot = new Image(_loc6_);
            this.textSnapshot.pixelSnapping = true;
            this.addChild(this.textSnapshot);
         }
         else if(this._needsNewTexture)
         {
            this.textSnapshot.texture.dispose();
            this.textSnapshot.texture = _loc6_;
            this.textSnapshot.readjustSize();
         }
         else
         {
            _loc9_ = this.textSnapshot.texture;
            _loc9_.root.uploadBitmapData(_loc5_);
            this.textSnapshot.setRequiresRedraw();
         }
         if(this._updateSnapshotOnScaleChange)
         {
            this.textSnapshot.scaleX = 1 / _loc7_;
            this.textSnapshot.scaleY = 1 / _loc8_;
            this._lastGlobalScaleX = _loc7_;
            this._lastGlobalScaleY = _loc8_;
         }
         this.textSnapshot.alpha = this._text.length > 0 ? 1 : 0;
         _loc5_.dispose();
         this._needsNewTexture = false;
      }
      
      protected function textEditor_addedToStageHandler(param1:starling.events.Event) : void
      {
         var _loc2_:Starling = null;
         if(this.textField.parent === null)
         {
            _loc2_ = this.stage !== null ? this.stage.starling : Starling.current;
            _loc2_.nativeStage.addChild(this.textField);
         }
      }
      
      protected function textEditor_removedFromStageHandler(param1:starling.events.Event) : void
      {
         if(this.textField.parent)
         {
            this.textField.parent.removeChild(this.textField);
         }
      }
      
      protected function hasFocus_enterFrameHandler(param1:starling.events.Event) : void
      {
         var _loc2_:DisplayObject = null;
         if(this.textSnapshot)
         {
            this.textSnapshot.visible = !this._textFieldHasFocus;
         }
         this.textField.visible = this._textFieldHasFocus;
         if(this._textFieldHasFocus)
         {
            _loc2_ = this;
            do
            {
               if(!_loc2_.visible)
               {
                  this.clearFocus();
                  break;
               }
               _loc2_ = _loc2_.parent;
            }
            while(_loc2_);
         }
         else
         {
            this.removeEventListener(starling.events.Event.ENTER_FRAME,this.hasFocus_enterFrameHandler);
         }
      }
      
      protected function refreshSnapshot_enterFrameHandler(param1:starling.events.Event) : void
      {
         this.removeEventListener(starling.events.Event.ENTER_FRAME,this.refreshSnapshot_enterFrameHandler);
         this.refreshSnapshot();
      }
      
      protected function stage_touchHandler(param1:TouchEvent) : void
      {
         if(this._maintainTouchFocus || FocusManager.isEnabledForStage(this.stage))
         {
            return;
         }
         var _loc2_:Touch = param1.getTouch(this.stage,TouchPhase.BEGAN);
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:Point = Pool.getPoint();
         _loc2_.getLocation(this.stage,_loc3_);
         var _loc4_:Boolean = this.contains(this.stage.hitTest(_loc3_));
         Pool.putPoint(_loc3_);
         if(_loc4_)
         {
            return;
         }
         this.clearFocus();
      }
      
      protected function textField_changeHandler(param1:flash.events.Event) : void
      {
         if(this._isHTML)
         {
            this.text = this.textField.htmlText;
         }
         else
         {
            this.text = this.textField.text;
         }
      }
      
      protected function textField_focusInHandler(param1:FocusEvent) : void
      {
         this._textFieldHasFocus = true;
         this.stage.addEventListener(TouchEvent.TOUCH,this.stage_touchHandler);
         this.addEventListener(starling.events.Event.ENTER_FRAME,this.hasFocus_enterFrameHandler);
         this.dispatchEventWith(FeathersEventType.FOCUS_IN);
      }
      
      protected function textField_focusOutHandler(param1:FocusEvent) : void
      {
         this._textFieldHasFocus = false;
         this.stage.removeEventListener(TouchEvent.TOUCH,this.stage_touchHandler);
         if(this._resetScrollOnFocusOut)
         {
            this.textField.scrollH = this.textField.scrollV = 0;
         }
         this.invalidate(INVALIDATION_FLAG_DATA);
         this.dispatchEventWith(FeathersEventType.FOCUS_OUT);
      }
      
      protected function textField_mouseFocusChangeHandler(param1:FocusEvent) : void
      {
         if(!this._maintainTouchFocus)
         {
            return;
         }
         param1.preventDefault();
      }
      
      protected function textField_keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.dispatchEventWith(FeathersEventType.ENTER);
         }
         else if(!FocusManager.isEnabledForStage(this.stage) && param1.keyCode == Keyboard.TAB)
         {
            this.clearFocus();
         }
      }
      
      protected function textField_softKeyboardActivateHandler(param1:SoftKeyboardEvent) : void
      {
         this.dispatchEventWith(FeathersEventType.SOFT_KEYBOARD_ACTIVATE,true);
      }
      
      protected function textField_softKeyboardActivatingHandler(param1:SoftKeyboardEvent) : void
      {
         this.dispatchEventWith(FeathersEventType.SOFT_KEYBOARD_ACTIVATING,true);
      }
      
      protected function textField_softKeyboardDeactivateHandler(param1:SoftKeyboardEvent) : void
      {
         this.dispatchEventWith(FeathersEventType.SOFT_KEYBOARD_DEACTIVATE,true);
      }
      
      override protected function fontStylesSet_changeHandler(param1:starling.events.Event) : void
      {
         this._previousStarlingTextFormat = null;
         super.fontStylesSet_changeHandler(param1);
      }
   }
}

