package feathers.controls.text
{
   import feathers.core.BaseTextEditor;
   import feathers.core.FocusManager;
   import feathers.core.IFocusDisplayObject;
   import feathers.core.IMultilineTextEditor;
   import feathers.core.INativeFocusOwner;
   import feathers.events.FeathersEventType;
   import feathers.skins.IStyleProvider;
   import feathers.system.DeviceCapabilities;
   import feathers.text.StageTextField;
   import feathers.utils.display.nativeToGlobal;
   import feathers.utils.geom.matrixToScaleX;
   import feathers.utils.geom.matrixToScaleY;
   import flash.display.BitmapData;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.SoftKeyboardEvent;
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import flash.system.Capabilities;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.text.engine.FontPosture;
   import flash.text.engine.FontWeight;
   import flash.ui.KeyLocation;
   import flash.ui.Keyboard;
   import flash.utils.getDefinitionByName;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.display.Image;
   import starling.events.Event;
   import starling.rendering.Painter;
   import starling.text.TextFormat;
   import starling.textures.ConcreteTexture;
   import starling.textures.Texture;
   import starling.utils.Align;
   import starling.utils.MatrixUtil;
   import starling.utils.Pool;
   import starling.utils.SystemUtil;
   
   public class StageTextTextEditor extends BaseTextEditor implements IMultilineTextEditor, INativeFocusOwner
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      protected static const MIN_VIEW_PORT_POSITION:Number = -8192;
      
      protected static const MAX_VIEW_PORT_POSITION:Number = 8191;
      
      protected var stageText:Object;
      
      protected var textSnapshot:Image;
      
      protected var _needsNewTexture:Boolean = false;
      
      protected var _needsTextureUpdate:Boolean = false;
      
      protected var _ignoreStageTextChanges:Boolean = false;
      
      protected var _measureTextField:TextField;
      
      protected var _stageTextIsTextField:Boolean = false;
      
      protected var _stageTextHasFocus:Boolean = false;
      
      protected var _isWaitingToSetFocus:Boolean = false;
      
      protected var _pendingSelectionBeginIndex:int = -1;
      
      protected var _pendingSelectionEndIndex:int = -1;
      
      protected var _stageTextIsComplete:Boolean = false;
      
      protected var _autoCapitalize:String = "none";
      
      protected var _autoCorrect:Boolean = false;
      
      protected var _color:uint = 4294967295;
      
      protected var _disabledColor:uint = 4294967295;
      
      protected var _displayAsPassword:Boolean = false;
      
      protected var _isEditable:Boolean = true;
      
      protected var _isSelectable:Boolean = true;
      
      protected var _fontFamily:String = null;
      
      protected var _fontPosture:String;
      
      protected var _fontSize:int = 0;
      
      protected var _fontWeight:String = null;
      
      protected var _locale:String = "en";
      
      protected var _maxChars:int = 0;
      
      protected var _multiline:Boolean = false;
      
      protected var _restrict:String;
      
      protected var _returnKeyLabel:String = "default";
      
      protected var _softKeyboardType:String = "default";
      
      protected var _textAlign:String;
      
      protected var _maintainTouchFocus:Boolean = false;
      
      protected var _lastGlobalScaleX:Number = 0;
      
      protected var _lastGlobalScaleY:Number = 0;
      
      protected var _updateSnapshotOnScaleChange:Boolean = false;
      
      protected var _clearButtonMode:String = "whileEditing";
      
      public function StageTextTextEditor()
      {
         super();
         this._stageTextIsTextField = Boolean(/^(Windows|Mac OS|Linux) .*/.exec(Capabilities.os)) || Capabilities.playerType === "Desktop" && Capabilities.isDebugger;
         this.isQuickHitAreaEnabled = true;
         this.addEventListener(starling.events.Event.REMOVED_FROM_STAGE,this.textEditor_removedFromStageHandler);
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return globalStyleProvider;
      }
      
      public function get nativeFocus() : Object
      {
         if(!this._isEditable)
         {
            return null;
         }
         return this.stageText;
      }
      
      public function get selectionBeginIndex() : int
      {
         if(this._pendingSelectionBeginIndex >= 0)
         {
            return this._pendingSelectionBeginIndex;
         }
         if(this.stageText)
         {
            return this.stageText.selectionAnchorIndex;
         }
         return 0;
      }
      
      public function get selectionEndIndex() : int
      {
         if(this._pendingSelectionEndIndex >= 0)
         {
            return this._pendingSelectionEndIndex;
         }
         if(this.stageText)
         {
            return this.stageText.selectionActiveIndex;
         }
         return 0;
      }
      
      public function get baseline() : Number
      {
         if(!this._measureTextField)
         {
            return 0;
         }
         return this._measureTextField.getLineMetrics(0).ascent;
      }
      
      public function get autoCapitalize() : String
      {
         return this._autoCapitalize;
      }
      
      public function set autoCapitalize(param1:String) : void
      {
         if(this._autoCapitalize == param1)
         {
            return;
         }
         this._autoCapitalize = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get autoCorrect() : Boolean
      {
         return this._autoCorrect;
      }
      
      public function set autoCorrect(param1:Boolean) : void
      {
         if(this._autoCorrect == param1)
         {
            return;
         }
         this._autoCorrect = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get color() : uint
      {
         return this._color;
      }
      
      public function set color(param1:uint) : void
      {
         if(this._color == param1)
         {
            return;
         }
         this._color = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get disabledColor() : uint
      {
         return this._disabledColor;
      }
      
      public function set disabledColor(param1:uint) : void
      {
         if(this._disabledColor == param1)
         {
            return;
         }
         this._disabledColor = param1;
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
      
      public function get setTouchFocusOnEndedPhase() : Boolean
      {
         return true;
      }
      
      public function get fontFamily() : String
      {
         return this._fontFamily;
      }
      
      public function set fontFamily(param1:String) : void
      {
         if(this._fontFamily == param1)
         {
            return;
         }
         this._fontFamily = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get fontPosture() : String
      {
         return this._fontPosture;
      }
      
      public function set fontPosture(param1:String) : void
      {
         if(this._fontPosture == param1)
         {
            return;
         }
         this._fontPosture = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get fontSize() : int
      {
         return this._fontSize;
      }
      
      public function set fontSize(param1:int) : void
      {
         if(this._fontSize == param1)
         {
            return;
         }
         this._fontSize = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get fontWeight() : String
      {
         return this._fontWeight;
      }
      
      public function set fontWeight(param1:String) : void
      {
         if(this._fontWeight == param1)
         {
            return;
         }
         this._fontWeight = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get locale() : String
      {
         return this._locale;
      }
      
      public function set locale(param1:String) : void
      {
         if(this._locale == param1)
         {
            return;
         }
         this._locale = param1;
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
      
      public function get returnKeyLabel() : String
      {
         return this._returnKeyLabel;
      }
      
      public function set returnKeyLabel(param1:String) : void
      {
         if(this._returnKeyLabel == param1)
         {
            return;
         }
         this._returnKeyLabel = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get softKeyboardType() : String
      {
         return this._softKeyboardType;
      }
      
      public function set softKeyboardType(param1:String) : void
      {
         if(this._softKeyboardType == param1)
         {
            return;
         }
         this._softKeyboardType = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get textAlign() : String
      {
         return this._textAlign;
      }
      
      public function set textAlign(param1:String) : void
      {
         if(this._textAlign == param1)
         {
            return;
         }
         this._textAlign = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
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
      
      public function get clearButtonMode() : String
      {
         return this._clearButtonMode;
      }
      
      public function set clearButtonMode(param1:String) : void
      {
         if(this._clearButtonMode == param1)
         {
            return;
         }
         this._clearButtonMode = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      override public function dispose() : void
      {
         var _loc1_:Starling = null;
         if(this._measureTextField !== null)
         {
            _loc1_ = this.stage !== null ? this.stage.starling : Starling.current;
            _loc1_.nativeStage.removeChild(this._measureTextField);
            this._measureTextField = null;
         }
         if(this.stageText)
         {
            this.disposeStageText();
         }
         if(this.textSnapshot)
         {
            this.textSnapshot.texture.dispose();
            this.removeChild(this.textSnapshot,true);
            this.textSnapshot = null;
         }
         super.dispose();
      }
      
      override public function render(param1:Painter) : void
      {
         var _loc2_:Matrix = null;
         var _loc3_:Boolean = false;
         if(this._stageTextHasFocus)
         {
            param1.excludeFromCache(this);
         }
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
            _loc3_ = this._text.length > 0;
            if(_loc3_)
            {
               this.refreshSnapshot();
            }
            if(this.textSnapshot)
            {
               this.textSnapshot.visible = !this._stageTextHasFocus;
               this.textSnapshot.alpha = _loc3_ ? 1 : 0;
            }
            if(!this._stageTextHasFocus)
            {
               this.stageText.visible = false;
            }
         }
         if(this.stageText !== null && Boolean(this.stageText.visible))
         {
            this.refreshViewPortAndFontSize();
         }
         if(this.textSnapshot)
         {
            this.positionSnapshot();
         }
         super.render(param1);
      }
      
      public function setFocus(param1:Point = null) : void
      {
         var starling:Starling = null;
         var positionX:Number = NaN;
         var positionY:Number = NaN;
         var lineIndex:int = 0;
         var bounds:flash.geom.Rectangle = null;
         var boundsX:Number = NaN;
         var position:Point = param1;
         if(!this._isEditable && SystemUtil.platform === "AND")
         {
            return;
         }
         if(!this._isEditable && !this._isSelectable)
         {
            return;
         }
         if(this.stage !== null && this.stageText.stage === null)
         {
            starling = this.stage !== null ? this.stage.starling : Starling.current;
            this.stageText.stage = starling.nativeStage;
         }
         if(Boolean(this.stageText) && this._stageTextIsComplete)
         {
            if(position)
            {
               positionX = position.x + 2;
               positionY = position.y + 2;
               if(positionX < 0)
               {
                  this._pendingSelectionBeginIndex = this._pendingSelectionEndIndex = 0;
               }
               else
               {
                  this._pendingSelectionBeginIndex = this._measureTextField.getCharIndexAtPoint(positionX,positionY);
                  if(this._pendingSelectionBeginIndex < 0)
                  {
                     if(this._multiline)
                     {
                        lineIndex = int(positionY / this._measureTextField.getLineMetrics(0).height);
                        try
                        {
                           this._pendingSelectionBeginIndex = this._measureTextField.getLineOffset(lineIndex) + this._measureTextField.getLineLength(lineIndex);
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
                        this._pendingSelectionBeginIndex = this._measureTextField.getCharIndexAtPoint(positionX,this._measureTextField.getLineMetrics(0).ascent / 2);
                        if(this._pendingSelectionBeginIndex < 0)
                        {
                           this._pendingSelectionBeginIndex = this._text.length;
                        }
                     }
                  }
                  else
                  {
                     bounds = this._measureTextField.getCharBoundaries(this._pendingSelectionBeginIndex);
                     boundsX = bounds.x;
                     if(Boolean(bounds) && boundsX + bounds.width - positionX < positionX - boundsX)
                     {
                        ++this._pendingSelectionBeginIndex;
                     }
                  }
                  this._pendingSelectionEndIndex = this._pendingSelectionBeginIndex;
               }
            }
            else
            {
               this._pendingSelectionBeginIndex = this._pendingSelectionEndIndex = -1;
            }
            this.stageText.visible = true;
            if(!this._isEditable)
            {
               this.stageText.editable = true;
            }
            if(!this._stageTextHasFocus)
            {
               this.stageText.assignFocus();
            }
         }
         else
         {
            this._isWaitingToSetFocus = true;
         }
      }
      
      public function clearFocus() : void
      {
         if(!this._stageTextHasFocus)
         {
            return;
         }
         var _loc1_:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         _loc1_.nativeStage.focus = null;
         if(!this.isParentChainVisible())
         {
            this.stageText.visible = false;
         }
      }
      
      public function selectRange(param1:int, param2:int) : void
      {
         if(this._stageTextIsComplete && Boolean(this.stageText))
         {
            this._pendingSelectionBeginIndex = -1;
            this._pendingSelectionEndIndex = -1;
            this.stageText.selectRange(param1,param2);
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
         var _loc4_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc5_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         if(_loc4_ || _loc5_)
         {
            this.refreshMeasureProperties();
         }
         return this.measure(param1);
      }
      
      override protected function initialize() : void
      {
         var _loc1_:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         if(this._measureTextField !== null && this._measureTextField.parent === null)
         {
            _loc1_.nativeStage.addChild(this._measureTextField);
         }
         else if(!this._measureTextField)
         {
            this._measureTextField = new TextField();
            this._measureTextField.visible = false;
            this._measureTextField.mouseEnabled = this._measureTextField.mouseWheelEnabled = false;
            this._measureTextField.autoSize = TextFieldAutoSize.LEFT;
            this._measureTextField.multiline = false;
            this._measureTextField.wordWrap = false;
            this._measureTextField.embedFonts = false;
            this._measureTextField.defaultTextFormat = new flash.text.TextFormat(null,11,0,false,false,false);
            _loc1_.nativeStage.addChild(this._measureTextField);
         }
         this.createStageText();
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
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         if(_loc2_ || _loc3_)
         {
            this.refreshMeasureProperties();
         }
         var _loc4_:Boolean = this._ignoreStageTextChanges;
         this._ignoreStageTextChanges = true;
         if(_loc1_ || _loc2_)
         {
            this.refreshStageTextProperties();
         }
         if(_loc3_)
         {
            if(this.stageText.text != this._text)
            {
               if(this._pendingSelectionBeginIndex < 0)
               {
                  this._pendingSelectionBeginIndex = this.stageText.selectionActiveIndex;
                  this._pendingSelectionEndIndex = this.stageText.selectionAnchorIndex;
               }
               this.stageText.text = this._text;
            }
         }
         this._ignoreStageTextChanges = _loc4_;
         if(_loc2_ || _loc1_)
         {
            this.stageText.editable = this._isEditable && this._isEnabled;
         }
      }
      
      protected function measure(param1:Point = null) : Point
      {
         if(!param1)
         {
            param1 = new Point();
         }
         var _loc2_:Boolean = this._explicitWidth !== this._explicitWidth;
         var _loc3_:Boolean = this._explicitHeight !== this._explicitHeight;
         this._measureTextField.autoSize = TextFieldAutoSize.LEFT;
         var _loc4_:Number = this._explicitWidth;
         if(_loc2_)
         {
            _loc4_ = this._measureTextField.textWidth;
            if(_loc4_ < this._explicitMinWidth)
            {
               _loc4_ = this._explicitMinWidth;
            }
            else if(_loc4_ > this._explicitMaxWidth)
            {
               _loc4_ = this._explicitMaxWidth;
            }
         }
         this._measureTextField.width = _loc4_ + 4;
         var _loc5_:Number = this._explicitHeight;
         if(_loc3_)
         {
            if(this._stageTextIsTextField)
            {
               _loc5_ = this._measureTextField.textHeight;
            }
            else
            {
               _loc5_ = this._measureTextField.height;
            }
            if(_loc5_ < this._explicitMinHeight)
            {
               _loc5_ = this._explicitMinHeight;
            }
            else if(_loc5_ > this._explicitMaxHeight)
            {
               _loc5_ = this._explicitMaxHeight;
            }
         }
         this._measureTextField.autoSize = TextFieldAutoSize.NONE;
         this._measureTextField.width = this.actualWidth + 4;
         this._measureTextField.height = this.actualHeight;
         param1.x = _loc4_;
         param1.y = _loc5_;
         return param1;
      }
      
      protected function layout(param1:Boolean) : void
      {
         var _loc6_:Starling = null;
         var _loc7_:flash.geom.Rectangle = null;
         var _loc8_:ConcreteTexture = null;
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc4_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         var _loc5_:Boolean = this.isInvalid(INVALIDATION_FLAG_SKIN);
         if(param1 || _loc3_ || _loc5_ || _loc2_)
         {
            _loc6_ = this.stage !== null ? this.stage.starling : Starling.current;
            this.refreshViewPortAndFontSize();
            this.refreshMeasureTextFieldDimensions();
            _loc7_ = this.stageText.viewPort;
            _loc8_ = this.textSnapshot ? this.textSnapshot.texture.root : null;
            this._needsNewTexture = this._needsNewTexture || !this.textSnapshot || _loc8_ !== null && (_loc8_.scale != _loc6_.contentScaleFactor || _loc7_.width != _loc8_.nativeWidth || _loc7_.height != _loc8_.nativeHeight);
         }
         if(!this._stageTextHasFocus && (_loc2_ || _loc3_ || _loc4_ || param1 || this._needsNewTexture))
         {
            if(!this.isParentChainVisible())
            {
               this.stageText.visible = false;
            }
            this._needsTextureUpdate = true;
            this.setRequiresRedraw();
         }
         this.doPendingActions();
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
      
      protected function refreshMeasureProperties() : void
      {
         var _loc2_:starling.text.TextFormat = null;
         this._measureTextField.displayAsPassword = this._displayAsPassword;
         this._measureTextField.maxChars = this._maxChars;
         this._measureTextField.restrict = this._restrict;
         this._measureTextField.multiline = this._multiline;
         this._measureTextField.wordWrap = this._multiline;
         var _loc1_:flash.text.TextFormat = this._measureTextField.defaultTextFormat;
         if(this._fontStyles !== null)
         {
            _loc2_ = this._fontStyles.getTextFormatForTarget(this);
         }
         if(this._fontFamily !== null)
         {
            _loc1_.font = this._fontFamily;
         }
         else if(_loc2_ !== null)
         {
            _loc1_.font = _loc2_.font;
         }
         else
         {
            _loc1_.font = null;
         }
         if(this._fontSize > 0)
         {
            _loc1_.size = this._fontSize;
         }
         else if(_loc2_ !== null)
         {
            _loc1_.size = _loc2_.size;
         }
         else
         {
            _loc1_.size = 12;
         }
         if(this._fontWeight !== null)
         {
            _loc1_.bold = this._fontWeight === FontWeight.BOLD;
         }
         else if(_loc2_ !== null)
         {
            _loc1_.bold = _loc2_.bold;
         }
         else
         {
            _loc1_.bold = false;
         }
         if(this._fontPosture !== null)
         {
            _loc1_.italic = this._fontPosture === FontPosture.ITALIC;
         }
         else if(_loc2_ !== null)
         {
            _loc1_.italic = _loc2_.italic;
         }
         else
         {
            _loc1_.italic = false;
         }
         this._measureTextField.defaultTextFormat = _loc1_;
         this._measureTextField.setTextFormat(_loc1_);
         if(this._text.length == 0)
         {
            this._measureTextField.text = " ";
         }
         else
         {
            this._measureTextField.text = this._text;
         }
      }
      
      protected function refreshStageTextProperties() : void
      {
         var _loc1_:starling.text.TextFormat = null;
         if(this.stageText.multiline != this._multiline)
         {
            if(this.stageText)
            {
               this.disposeStageText();
            }
            this.createStageText();
         }
         if(this._fontStyles !== null)
         {
            _loc1_ = this._fontStyles.getTextFormatForTarget(this);
         }
         this.stageText.autoCapitalize = this._autoCapitalize;
         this.stageText.autoCorrect = this._autoCorrect;
         if(this._isEnabled)
         {
            if(this._color == uint.MAX_VALUE)
            {
               if(_loc1_ !== null)
               {
                  this.stageText.color = _loc1_.color;
               }
               else
               {
                  this.stageText.color = 0;
               }
            }
            else
            {
               this.stageText.color = this._color;
            }
         }
         else if(this._disabledColor == uint.MAX_VALUE)
         {
            if(this._color == uint.MAX_VALUE)
            {
               if(_loc1_ !== null)
               {
                  this.stageText.color = _loc1_.color;
               }
               else
               {
                  this.stageText.color = 0;
               }
            }
            else
            {
               this.stageText.color = this._color;
            }
         }
         else
         {
            this.stageText.color = this._disabledColor;
         }
         this.stageText.displayAsPassword = this._displayAsPassword;
         var _loc2_:String = this._fontFamily;
         if(_loc2_ === null && _loc1_ !== null)
         {
            _loc2_ = _loc1_.font;
         }
         this.stageText.fontFamily = _loc2_;
         var _loc3_:String = this._fontPosture;
         if(_loc3_ === null)
         {
            if(_loc1_ !== null && _loc1_.italic)
            {
               _loc3_ = FontPosture.ITALIC;
            }
            else
            {
               _loc3_ = FontPosture.NORMAL;
            }
         }
         this.stageText.fontPosture = _loc3_;
         var _loc4_:String = this._fontWeight;
         if(_loc4_ === null)
         {
            if(_loc1_ !== null && _loc1_.bold)
            {
               _loc4_ = FontWeight.BOLD;
            }
            else
            {
               _loc4_ = FontWeight.NORMAL;
            }
         }
         this.stageText.fontWeight = _loc4_;
         this.stageText.locale = this._locale;
         this.stageText.maxChars = this._maxChars;
         this.stageText.restrict = this._restrict;
         this.stageText.returnKeyLabel = this._returnKeyLabel;
         this.stageText.softKeyboardType = this._softKeyboardType;
         var _loc5_:String = this._textAlign;
         if(_loc5_ === null)
         {
            if(_loc1_ !== null && Boolean(_loc1_.horizontalAlign))
            {
               _loc5_ = _loc1_.horizontalAlign;
            }
            else
            {
               _loc5_ = TextFormatAlign.START;
            }
         }
         this.stageText.textAlign = _loc5_;
         if("clearButtonMode" in this.stageText)
         {
            this.stageText.clearButtonMode = this._clearButtonMode;
         }
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
            _loc2_ = this._pendingSelectionEndIndex < 0 ? this._pendingSelectionBeginIndex : this._pendingSelectionEndIndex;
            this._pendingSelectionBeginIndex = -1;
            this._pendingSelectionEndIndex = -1;
            if(this.stageText.selectionAnchorIndex != _loc1_ || this.stageText.selectionActiveIndex != _loc2_)
            {
               this.selectRange(_loc1_,_loc2_);
            }
         }
      }
      
      protected function texture_onRestore() : void
      {
         var _loc1_:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         if(this.textSnapshot.texture.scale != _loc1_.contentScaleFactor)
         {
            this.invalidate(INVALIDATION_FLAG_SIZE);
         }
         else
         {
            this.refreshSnapshot();
            if(this.textSnapshot)
            {
               this.textSnapshot.visible = !this._stageTextHasFocus;
               this.textSnapshot.alpha = this._text.length > 0 ? 1 : 0;
            }
            if(!this._stageTextHasFocus)
            {
               this.stageText.visible = false;
            }
         }
      }
      
      protected function refreshSnapshot() : void
      {
         var nativeScaleFactor:Number;
         var matrix:Matrix;
         var globalScaleX:Number;
         var globalScaleY:Number;
         var viewPort:flash.geom.Rectangle = null;
         var newTexture:Texture = null;
         var bitmapData:BitmapData = null;
         var scaleFactor:Number = NaN;
         var existingTexture:Texture = null;
         var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         if(this.stage !== null && this.stageText.stage === null)
         {
            this.stageText.stage = starling.nativeStage;
         }
         if(this.stageText.stage === null)
         {
            this.invalidate(INVALIDATION_FLAG_DATA);
            return;
         }
         viewPort = this.stageText.viewPort;
         if(viewPort.width == 0 || viewPort.height == 0)
         {
            return;
         }
         nativeScaleFactor = 1;
         if(starling.supportHighResolutions)
         {
            nativeScaleFactor = starling.nativeStage.contentsScaleFactor;
         }
         try
         {
            bitmapData = new BitmapData(viewPort.width * nativeScaleFactor,viewPort.height * nativeScaleFactor,true,16711935);
            this.stageText.drawViewPortToBitmapData(bitmapData);
         }
         catch(error:Error)
         {
            bitmapData.dispose();
            bitmapData = new BitmapData(viewPort.width,viewPort.height,true,16711935);
            this.stageText.drawViewPortToBitmapData(bitmapData);
         }
         if(!this.textSnapshot || this._needsNewTexture)
         {
            scaleFactor = starling.contentScaleFactor;
            newTexture = Texture.empty(bitmapData.width / scaleFactor,bitmapData.height / scaleFactor,true,false,false,scaleFactor);
            newTexture.root.uploadBitmapData(bitmapData);
            newTexture.root.onRestore = this.texture_onRestore;
         }
         if(!this.textSnapshot)
         {
            this.textSnapshot = new Image(newTexture);
            this.textSnapshot.pixelSnapping = true;
            this.addChild(this.textSnapshot);
         }
         else if(this._needsNewTexture)
         {
            this.textSnapshot.texture.dispose();
            this.textSnapshot.texture = newTexture;
            this.textSnapshot.readjustSize();
         }
         else
         {
            existingTexture = this.textSnapshot.texture;
            existingTexture.root.uploadBitmapData(bitmapData);
            this.textSnapshot.setRequiresRedraw();
         }
         matrix = Pool.getMatrix();
         this.getTransformationMatrix(this.stage,matrix);
         globalScaleX = matrixToScaleX(matrix);
         globalScaleY = matrixToScaleY(matrix);
         Pool.putMatrix(matrix);
         if(this._updateSnapshotOnScaleChange)
         {
            this.textSnapshot.scaleX = 1 / globalScaleX;
            this.textSnapshot.scaleY = 1 / globalScaleY;
            this._lastGlobalScaleX = globalScaleX;
            this._lastGlobalScaleY = globalScaleY;
         }
         else
         {
            this.textSnapshot.scaleX = 1;
            this.textSnapshot.scaleY = 1;
         }
         if(nativeScaleFactor > 1 && bitmapData.width == viewPort.width)
         {
            this.textSnapshot.scaleX *= nativeScaleFactor;
            this.textSnapshot.scaleY *= nativeScaleFactor;
         }
         bitmapData.dispose();
         this._needsNewTexture = false;
      }
      
      protected function refreshViewPortAndFontSize() : void
      {
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Matrix3D = null;
         var _loc21_:Vector3D = null;
         var _loc22_:starling.text.TextFormat = null;
         var _loc1_:Matrix = Pool.getMatrix();
         var _loc2_:Point = Pool.getPoint();
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         if(this._stageTextIsTextField)
         {
            _loc3_ = 2;
            _loc4_ = 4;
         }
         this.getTransformationMatrix(this.stage,_loc1_);
         if(this._stageTextHasFocus || this._updateSnapshotOnScaleChange)
         {
            _loc17_ = matrixToScaleX(_loc1_);
            _loc18_ = matrixToScaleY(_loc1_);
            _loc19_ = _loc17_;
            if(_loc18_ < _loc19_)
            {
               _loc19_ = _loc18_;
            }
         }
         else
         {
            _loc17_ = 1;
            _loc18_ = 1;
            _loc19_ = 1;
         }
         var _loc5_:Number = this.getVerticalAlignmentOffsetY();
         if(this.is3D)
         {
            _loc20_ = Pool.getMatrix3D();
            _loc21_ = Pool.getPoint3D();
            this.getTransformationMatrix3D(this.stage,_loc20_);
            MatrixUtil.transformCoords3D(_loc20_,-_loc3_,-_loc3_ + _loc5_,0,_loc21_);
            _loc2_.setTo(_loc21_.x,_loc21_.y);
            Pool.putPoint3D(_loc21_);
            Pool.putMatrix3D(_loc20_);
         }
         else
         {
            MatrixUtil.transformCoords(_loc1_,-_loc3_,-_loc3_ + _loc5_,_loc2_);
         }
         var _loc6_:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         var _loc7_:Number = 1;
         if(_loc6_.supportHighResolutions)
         {
            _loc7_ = _loc6_.nativeStage.contentsScaleFactor;
         }
         var _loc8_:Number = _loc6_.contentScaleFactor / _loc7_;
         var _loc9_:flash.geom.Rectangle = _loc6_.viewPort;
         var _loc10_:flash.geom.Rectangle = this.stageText.viewPort;
         if(!_loc10_)
         {
            _loc10_ = new flash.geom.Rectangle();
         }
         var _loc11_:Number = Math.round((this.actualWidth + _loc4_) * _loc8_ * _loc17_);
         if(_loc11_ < 1 || _loc11_ !== _loc11_)
         {
            _loc11_ = 1;
         }
         var _loc12_:Number = Math.round((this.actualHeight + _loc4_) * _loc8_ * _loc18_);
         if(_loc12_ < 1 || _loc12_ !== _loc12_)
         {
            _loc12_ = 1;
         }
         _loc10_.width = _loc11_;
         _loc10_.height = _loc12_;
         var _loc13_:Number = Math.round(_loc9_.x + _loc2_.x * _loc8_);
         if(_loc13_ + _loc11_ > MAX_VIEW_PORT_POSITION)
         {
            _loc13_ = MAX_VIEW_PORT_POSITION - _loc11_;
         }
         if(_loc13_ < MIN_VIEW_PORT_POSITION)
         {
            _loc13_ = MIN_VIEW_PORT_POSITION;
         }
         var _loc14_:Number = Math.round(_loc9_.y + _loc2_.y * _loc8_);
         if(_loc14_ + _loc12_ > MAX_VIEW_PORT_POSITION)
         {
            _loc14_ = MAX_VIEW_PORT_POSITION - _loc12_;
         }
         if(_loc14_ < MIN_VIEW_PORT_POSITION)
         {
            _loc14_ = MIN_VIEW_PORT_POSITION;
         }
         _loc10_.x = _loc13_;
         _loc10_.y = _loc14_;
         this.stageText.viewPort = _loc10_;
         var _loc15_:int = 12;
         if(this._fontSize > 0)
         {
            _loc15_ = this._fontSize;
         }
         else if(this._fontStyles !== null)
         {
            _loc22_ = this._fontStyles.getTextFormatForTarget(this);
            if(_loc22_ !== null)
            {
               _loc15_ = _loc22_.size;
            }
         }
         var _loc16_:int = _loc15_ * _loc8_ * _loc19_;
         if(this.stageText.fontSize != _loc16_)
         {
            this.stageText.fontSize = _loc16_;
         }
         Pool.putPoint(_loc2_);
         Pool.putMatrix(_loc1_);
      }
      
      protected function refreshMeasureTextFieldDimensions() : void
      {
         this._measureTextField.width = this.actualWidth + 4;
         this._measureTextField.height = this.actualHeight;
      }
      
      protected function positionSnapshot() : void
      {
         var _loc1_:Matrix = Pool.getMatrix();
         this.getTransformationMatrix(this.stage,_loc1_);
         var _loc2_:Number = 0;
         if(this._stageTextIsTextField)
         {
            _loc2_ = 2;
         }
         this.textSnapshot.x = Math.round(_loc1_.tx) - _loc1_.tx - _loc2_;
         this.textSnapshot.y = Math.round(_loc1_.ty) - _loc1_.ty - _loc2_ + this.getVerticalAlignmentOffsetY();
         Pool.putMatrix(_loc1_);
      }
      
      protected function disposeStageText() : void
      {
         if(!this.stageText)
         {
            return;
         }
         this.stageText.removeEventListener(flash.events.Event.CHANGE,this.stageText_changeHandler);
         this.stageText.removeEventListener(KeyboardEvent.KEY_DOWN,this.stageText_keyDownHandler);
         this.stageText.removeEventListener(KeyboardEvent.KEY_UP,this.stageText_keyUpHandler);
         this.stageText.removeEventListener(FocusEvent.FOCUS_IN,this.stageText_focusInHandler);
         this.stageText.removeEventListener(FocusEvent.FOCUS_OUT,this.stageText_focusOutHandler);
         this.stageText.removeEventListener(flash.events.Event.COMPLETE,this.stageText_completeHandler);
         this.stageText.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE,this.stageText_softKeyboardActivateHandler);
         this.stageText.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING,this.stageText_softKeyboardActivatingHandler);
         this.stageText.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE,this.stageText_softKeyboardDeactivateHandler);
         this.stageText.stage = null;
         this.stageText.dispose();
         this.stageText = null;
      }
      
      protected function createStageText() : void
      {
         var StageTextType:Class = null;
         var initOptions:Object = null;
         var StageTextInitOptionsType:Class = null;
         this._stageTextIsComplete = false;
         try
         {
            StageTextType = Class(getDefinitionByName("flash.text.StageText"));
            StageTextInitOptionsType = Class(getDefinitionByName("flash.text.StageTextInitOptions"));
            initOptions = new StageTextInitOptionsType(this._multiline);
         }
         catch(error:Error)
         {
            StageTextType = StageTextField;
            initOptions = {"multiline":this._multiline};
         }
         this.stageText = new StageTextType(initOptions);
         this.stageText.visible = false;
         this.stageText.addEventListener(flash.events.Event.CHANGE,this.stageText_changeHandler);
         this.stageText.addEventListener(KeyboardEvent.KEY_DOWN,this.stageText_keyDownHandler);
         this.stageText.addEventListener(KeyboardEvent.KEY_UP,this.stageText_keyUpHandler);
         this.stageText.addEventListener(FocusEvent.FOCUS_IN,this.stageText_focusInHandler);
         this.stageText.addEventListener(FocusEvent.FOCUS_OUT,this.stageText_focusOutHandler);
         this.stageText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE,this.stageText_softKeyboardActivateHandler);
         this.stageText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING,this.stageText_softKeyboardActivatingHandler);
         this.stageText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE,this.stageText_softKeyboardDeactivateHandler);
         this.stageText.addEventListener(flash.events.Event.COMPLETE,this.stageText_completeHandler);
         this.stageText.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.stageText_mouseFocusChangeHandler);
         this.invalidate();
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
         if(this._measureTextField.textHeight > this.actualHeight)
         {
            return 0;
         }
         switch(_loc1_)
         {
            case Align.BOTTOM:
               return this.actualHeight - this._measureTextField.textHeight;
            case Align.CENTER:
               return (this.actualHeight - this._measureTextField.textHeight) / 2;
            default:
               return 0;
         }
      }
      
      protected function dispatchKeyFocusChangeEvent(param1:KeyboardEvent) : void
      {
         var _loc2_:FocusEvent = new FocusEvent(FocusEvent.KEY_FOCUS_CHANGE,true,false,null,param1.shiftKey,param1.keyCode);
         this.stage.starling.nativeStage.dispatchEvent(_loc2_);
      }
      
      protected function dispatchKeyboardEventToStage(param1:KeyboardEvent) : void
      {
         this.stage.starling.nativeStage.dispatchEvent(param1);
      }
      
      protected function isParentChainVisible() : Boolean
      {
         var _loc1_:DisplayObject = this;
         while(_loc1_.visible)
         {
            _loc1_ = _loc1_.parent;
            if(!_loc1_)
            {
               return true;
            }
         }
         return false;
      }
      
      protected function textEditor_removedFromStageHandler(param1:starling.events.Event) : void
      {
         this.stageText.stage = null;
      }
      
      protected function stageText_changeHandler(param1:flash.events.Event) : void
      {
         if(this._ignoreStageTextChanges)
         {
            return;
         }
         this.text = this.stageText.text;
      }
      
      protected function stageText_completeHandler(param1:flash.events.Event) : void
      {
         this.stageText.removeEventListener(flash.events.Event.COMPLETE,this.stageText_completeHandler);
         this.invalidate();
         this._stageTextIsComplete = true;
      }
      
      protected function stageText_focusInHandler(param1:FocusEvent) : void
      {
         this._stageTextHasFocus = true;
         if(!this._isEditable)
         {
            this.stageText.editable = false;
         }
         this.addEventListener(starling.events.Event.ENTER_FRAME,this.hasFocus_enterFrameHandler);
         if(this.textSnapshot)
         {
            this.textSnapshot.visible = false;
         }
         this.invalidate(INVALIDATION_FLAG_SKIN);
         this.dispatchEventWith(FeathersEventType.FOCUS_IN);
      }
      
      protected function stageText_focusOutHandler(param1:FocusEvent) : void
      {
         this._stageTextHasFocus = false;
         this.stageText.selectRange(1,1);
         this.invalidate(INVALIDATION_FLAG_DATA);
         this.invalidate(INVALIDATION_FLAG_SKIN);
         this.dispatchEventWith(FeathersEventType.FOCUS_OUT);
      }
      
      protected function hasFocus_enterFrameHandler(param1:starling.events.Event) : void
      {
         if(this._stageTextHasFocus)
         {
            if(!this.isParentChainVisible())
            {
               this.stageText.stage.focus = null;
            }
         }
         else
         {
            this.removeEventListener(starling.events.Event.ENTER_FRAME,this.hasFocus_enterFrameHandler);
         }
      }
      
      protected function stageText_mouseFocusChangeHandler(param1:FocusEvent) : void
      {
         var _loc5_:IFocusDisplayObject = null;
         var _loc6_:IFocusDisplayObject = null;
         var _loc2_:Stage = this.stage.starling.nativeStage;
         var _loc3_:Point = Pool.getPoint(_loc2_.mouseX,_loc2_.mouseY);
         nativeToGlobal(_loc3_,this.stage.starling,_loc3_);
         var _loc4_:DisplayObject = this.stage.hitTest(_loc3_);
         while(_loc4_ !== null)
         {
            _loc5_ = _loc4_ as IFocusDisplayObject;
            if(_loc5_ !== null)
            {
               _loc6_ = _loc5_.focusOwner;
               if(_loc6_ !== null)
               {
                  if(_loc6_ is DisplayObjectContainer && DisplayObjectContainer(_loc6_).contains(this))
                  {
                     param1.preventDefault();
                  }
                  break;
               }
               if(_loc5_.isFocusEnabled)
               {
                  break;
               }
            }
            _loc4_ = _loc4_.parent;
         }
         if(!this._maintainTouchFocus)
         {
            return;
         }
         param1.preventDefault();
      }
      
      protected function stageText_keyDownHandler(param1:KeyboardEvent) : void
      {
         var _loc2_:Starling = null;
         if(!this._multiline && (param1.keyCode == Keyboard.ENTER || param1.keyCode == Keyboard.NEXT))
         {
            param1.preventDefault();
            this.dispatchEventWith(FeathersEventType.ENTER);
         }
         else if(param1.keyCode == Keyboard.BACK)
         {
            param1.preventDefault();
            _loc2_ = this.stage !== null ? this.stage.starling : Starling.current;
            _loc2_.nativeStage.focus = _loc2_.nativeStage;
         }
         if(FocusManager.isEnabledForStage(this.stage))
         {
            if(param1.keyCode == Keyboard.TAB)
            {
               param1.preventDefault();
               this.dispatchKeyFocusChangeEvent(param1);
            }
            if((param1.keyLocation == KeyLocation.D_PAD || DeviceCapabilities.simulateDPad) && (param1.keyCode == Keyboard.ENTER || param1.keyCode == Keyboard.UP || param1.keyCode == Keyboard.DOWN))
            {
               param1.preventDefault();
               this.dispatchKeyboardEventToStage(param1);
            }
         }
      }
      
      protected function stageText_keyUpHandler(param1:KeyboardEvent) : void
      {
         if(!this._multiline && (param1.keyCode == Keyboard.ENTER || param1.keyCode == Keyboard.NEXT))
         {
            param1.preventDefault();
         }
         if(param1.keyCode == Keyboard.TAB && FocusManager.isEnabledForStage(this.stage))
         {
            param1.preventDefault();
         }
      }
      
      protected function stageText_softKeyboardActivateHandler(param1:SoftKeyboardEvent) : void
      {
         this.dispatchEventWith(FeathersEventType.SOFT_KEYBOARD_ACTIVATE,true);
      }
      
      protected function stageText_softKeyboardActivatingHandler(param1:SoftKeyboardEvent) : void
      {
         this.dispatchEventWith(FeathersEventType.SOFT_KEYBOARD_ACTIVATING,true);
      }
      
      protected function stageText_softKeyboardDeactivateHandler(param1:SoftKeyboardEvent) : void
      {
         this.dispatchEventWith(FeathersEventType.SOFT_KEYBOARD_DEACTIVATE,true);
      }
   }
}

