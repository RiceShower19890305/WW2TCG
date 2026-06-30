package feathers.controls.text
{
   import feathers.core.FocusManager;
   import feathers.core.IIMETextEditor;
   import feathers.core.INativeFocusOwner;
   import feathers.events.FeathersEventType;
   import feathers.skins.IStyleProvider;
   import feathers.utils.text.TextEditorIMEClient;
   import feathers.utils.text.TextInputNavigation;
   import feathers.utils.text.TextInputRestrict;
   import flash.desktop.Clipboard;
   import flash.desktop.ClipboardFormats;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.TextEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextFormatAlign;
   import flash.text.engine.TextElement;
   import flash.text.engine.TextLine;
   import flash.text.ime.CompositionAttributeRange;
   import flash.ui.Keyboard;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.Quad;
   import starling.events.Event;
   import starling.events.KeyboardEvent;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.rendering.Painter;
   import starling.utils.Pool;
   
   public class TextBlockTextEditor extends TextBlockTextRenderer implements IIMETextEditor, INativeFocusOwner
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      public static const TEXT_ALIGN_LEFT:String = "left";
      
      public static const TEXT_ALIGN_CENTER:String = "center";
      
      public static const TEXT_ALIGN_RIGHT:String = "right";
      
      protected var _ignoreNextTextInputEvent:Boolean = false;
      
      protected var _imeText:String;
      
      protected var _imeCursorIndex:int = -1;
      
      protected var _selectionSkin:DisplayObject;
      
      protected var _cursorDelay:Number = 0.53;
      
      protected var _cursorDelayID:uint = 4294967295;
      
      protected var _cursorSkin:DisplayObject;
      
      protected var _unmaskedText:String;
      
      protected var _displayAsPassword:Boolean = false;
      
      protected var _passwordCharCode:int = 42;
      
      protected var _isEditable:Boolean = true;
      
      protected var _isSelectable:Boolean = true;
      
      protected var _maxChars:int = 0;
      
      protected var _restrict:TextInputRestrict;
      
      protected var _selectionBeginIndex:int = 0;
      
      protected var _selectionEndIndex:int = 0;
      
      protected var _selectionAnchorIndex:int = 0;
      
      protected var touchPointID:int = -1;
      
      protected var _nativeFocus:Sprite;
      
      protected var _isWaitingToSetFocus:Boolean = false;
      
      public function TextBlockTextEditor()
      {
         super();
         this._text = "";
         this._textElement = new TextElement(this._text);
         this._content = this._textElement;
         this.isQuickHitAreaEnabled = true;
         this.truncateToFit = false;
         this.addEventListener(TouchEvent.TOUCH,this.textEditor_touchHandler);
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return globalStyleProvider;
      }
      
      public function get selectionSkin() : DisplayObject
      {
         return this._selectionSkin;
      }
      
      public function set selectionSkin(param1:DisplayObject) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._selectionSkin == param1)
         {
            return;
         }
         if(Boolean(this._selectionSkin) && this._selectionSkin.parent == this)
         {
            this._selectionSkin.removeFromParent();
         }
         this._selectionSkin = param1;
         if(this._selectionSkin)
         {
            this._selectionSkin.visible = false;
            this.addChildAt(this._selectionSkin,0);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get cursorSkin() : DisplayObject
      {
         return this._cursorSkin;
      }
      
      public function set cursorSkin(param1:DisplayObject) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._cursorSkin === param1)
         {
            return;
         }
         if(this._cursorSkin !== null && this._cursorSkin.parent === this)
         {
            this._cursorSkin.removeFromParent();
         }
         this._cursorSkin = param1;
         if(this._cursorSkin !== null)
         {
            this._cursorSkin.visible = false;
            this.addChild(this._cursorSkin);
         }
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
         if(this._displayAsPassword)
         {
            this._unmaskedText = this._text;
            this.refreshMaskedText();
         }
         else
         {
            this._text = this._unmaskedText;
            this._unmaskedText = null;
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get passwordCharCode() : int
      {
         return this._passwordCharCode;
      }
      
      public function set passwordCharCode(param1:int) : void
      {
         if(this._passwordCharCode == param1)
         {
            return;
         }
         this._passwordCharCode = param1;
         if(this._displayAsPassword)
         {
            this.refreshMaskedText();
         }
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
         return false;
      }
      
      override public function get text() : String
      {
         if(this._displayAsPassword)
         {
            return this._unmaskedText;
         }
         return this._text;
      }
      
      override public function set text(param1:String) : void
      {
         if(param1 === null)
         {
            param1 = "";
         }
         var _loc2_:String = this._text;
         if(this._displayAsPassword)
         {
            _loc2_ = this._unmaskedText;
         }
         if(_loc2_ == param1)
         {
            return;
         }
         if(this._displayAsPassword)
         {
            this._unmaskedText = param1;
            this.refreshMaskedText();
         }
         else
         {
            super.text = param1;
         }
         var _loc3_:int = this._text.length;
         if(this._selectionAnchorIndex > _loc3_)
         {
            this._selectionAnchorIndex = _loc3_;
         }
         if(this._selectionBeginIndex > _loc3_)
         {
            this.selectRange(_loc3_,_loc3_);
         }
         else if(this._selectionEndIndex > _loc3_)
         {
            this.selectRange(this._selectionBeginIndex,_loc3_);
         }
         this.dispatchEventWith(starling.events.Event.CHANGE);
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
         if(!this._restrict)
         {
            return null;
         }
         return this._restrict.restrict;
      }
      
      public function set restrict(param1:String) : void
      {
         if(Boolean(this._restrict) && this._restrict.restrict === param1)
         {
            return;
         }
         if(!this._restrict && param1 === null)
         {
            return;
         }
         if(param1 === null)
         {
            this._restrict = null;
         }
         else if(this._restrict)
         {
            this._restrict.restrict = param1;
         }
         else
         {
            this._restrict = new TextInputRestrict(param1);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get selectionBeginIndex() : int
      {
         return this._selectionBeginIndex;
      }
      
      public function get selectionEndIndex() : int
      {
         return this._selectionEndIndex;
      }
      
      public function get selectionAnchorIndex() : int
      {
         return this._selectionAnchorIndex;
      }
      
      public function get selectionActiveIndex() : int
      {
         if(this._selectionAnchorIndex == this._selectionBeginIndex)
         {
            return this._selectionEndIndex;
         }
         return this._selectionBeginIndex;
      }
      
      public function get nativeFocus() : Object
      {
         return this._nativeFocus;
      }
      
      public function setFocus(param1:Point = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Starling = null;
         if(this._hasFocus && !param1)
         {
            return;
         }
         if(this._nativeFocus !== null)
         {
            if(this._nativeFocus.parent === null)
            {
               _loc3_ = this.stage !== null ? this.stage.starling : Starling.current;
               _loc3_.nativeStage.addChild(this._nativeFocus);
            }
            _loc2_ = -1;
            if(param1 !== null)
            {
               _loc2_ = this.getSelectionIndexAtPoint(param1.x,param1.y);
            }
            if(_loc2_ >= 0)
            {
               this.selectRange(_loc2_,_loc2_);
            }
            this.focusIn();
         }
         else
         {
            this._isWaitingToSetFocus = true;
         }
      }
      
      public function clearFocus() : void
      {
         if(!this._hasFocus)
         {
            return;
         }
         this._hasFocus = false;
         this._cursorSkin.visible = false;
         this._selectionSkin.visible = false;
         this.refreshCursorBlink();
         this.stage.removeEventListener(TouchEvent.TOUCH,this.stage_touchHandler);
         this.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.stage_keyDownHandler);
         this.removeEventListener(starling.events.Event.ENTER_FRAME,this.hasFocus_enterFrameHandler);
         var _loc1_:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         var _loc2_:Stage = _loc1_.nativeStage;
         if(_loc2_.focus === this._nativeFocus)
         {
            _loc2_.focus = null;
         }
         this.dispatchEventWith(FeathersEventType.FOCUS_OUT);
      }
      
      public function selectRange(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         if(!this._isEditable && !this._isSelectable)
         {
            return;
         }
         if(param2 < param1)
         {
            _loc3_ = param2;
            param2 = param1;
            param1 = _loc3_;
         }
         this._selectionBeginIndex = param1;
         this._selectionEndIndex = param2;
         if(param1 == param2)
         {
            this._selectionAnchorIndex = param1;
            if(param1 < 0)
            {
               this._cursorSkin.visible = false;
            }
            else
            {
               this._cursorSkin.visible = this._hasFocus && this._isEditable;
            }
            this._selectionSkin.visible = false;
         }
         else
         {
            this._cursorSkin.visible = false;
            this._selectionSkin.visible = true;
         }
         this.refreshCursorBlink();
         this.invalidate(INVALIDATION_FLAG_SELECTED);
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._nativeFocus) && Boolean(this._nativeFocus.parent))
         {
            this._nativeFocus.parent.removeChild(this._nativeFocus);
         }
         this._nativeFocus = null;
         super.dispose();
      }
      
      override public function render(param1:Painter) : void
      {
         var _loc2_:Number = this._textSnapshotOffsetX;
         var _loc3_:Number = this._cursorSkin.x;
         this._cursorSkin.x -= this._textSnapshotScrollX;
         super.render(param1);
         this._textSnapshotOffsetX = _loc2_;
         this._cursorSkin.x = _loc3_;
      }
      
      override protected function initialize() : void
      {
         if(!this._nativeFocus)
         {
            this._nativeFocus = new TextEditorIMEClient(this,this.imeClientStartCallback,this.imeClientUpdateCallback,this.imeClientConfirmCallback);
            this._nativeFocus.tabEnabled = false;
            this._nativeFocus.tabChildren = false;
            this._nativeFocus.mouseEnabled = false;
            this._nativeFocus.mouseChildren = false;
            this._nativeFocus.needsSoftKeyboard = true;
         }
         this._nativeFocus.addEventListener(flash.events.Event.CUT,this.nativeFocus_cutHandler,false,0,true);
         this._nativeFocus.addEventListener(flash.events.Event.COPY,this.nativeFocus_copyHandler,false,0,true);
         this._nativeFocus.addEventListener(flash.events.Event.PASTE,this.nativeFocus_pasteHandler,false,0,true);
         this._nativeFocus.addEventListener(flash.events.Event.SELECT_ALL,this.nativeFocus_selectAllHandler,false,0,true);
         this._nativeFocus.addEventListener(TextEvent.TEXT_INPUT,this.nativeFocus_textInputHandler,false,0,true);
         if(this._cursorSkin === null)
         {
            this.ignoreNextStyleRestriction();
            this.cursorSkin = new Quad(1,1,0);
         }
         if(this._selectionSkin === null)
         {
            this.ignoreNextStyleRestriction();
            this.selectionSkin = new Quad(1,1,0);
         }
         super.initialize();
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
         super.draw();
         if(_loc1_ || _loc2_)
         {
            this.positionCursorAtCharIndex(this.getCursorIndexFromSelectionRange());
            this.positionSelectionBackground();
         }
      }
      
      override protected function refreshTextElementText() : void
      {
         if(this._textElement === null)
         {
            return;
         }
         var _loc1_:String = this._text;
         if(this._imeText !== null)
         {
            _loc1_ = this._imeText;
         }
         if(_loc1_)
         {
            this._textElement.text = _loc1_;
            if(_loc1_ !== null && _loc1_.charAt(_loc1_.length - 1) == " ")
            {
               this._textElement.text += String.fromCharCode(3);
            }
         }
         else
         {
            this._textElement.text = String.fromCharCode(3);
         }
      }
      
      override protected function refreshTextLines(param1:Vector.<TextLine>, param2:DisplayObjectContainer, param3:Number, param4:Number, param5:MeasureTextResult = null) : MeasureTextResult
      {
         param5 = super.refreshTextLines(param1,param2,param3,param4,param5);
         if(param1 !== this._measurementTextLines && param2.width > param3)
         {
            this.alignTextLines(param1,param3,TextFormatAlign.LEFT);
         }
         return param5;
      }
      
      protected function refreshMaskedText() : void
      {
         var _loc1_:String = "";
         var _loc2_:int = this._unmaskedText.length;
         var _loc3_:String = String.fromCharCode(this._passwordCharCode);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc1_ += _loc3_;
            _loc4_++;
         }
         super.text = _loc1_;
      }
      
      protected function focusIn() : void
      {
         var _loc3_:Starling = null;
         var _loc1_:Boolean = (this._isEditable || this._isSelectable) && this._selectionBeginIndex >= 0 && this._selectionBeginIndex != this._selectionEndIndex;
         var _loc2_:Boolean = this._isEditable && this._selectionBeginIndex >= 0 && this._selectionBeginIndex == this._selectionEndIndex;
         this._cursorSkin.visible = _loc2_;
         this._selectionSkin.visible = _loc1_;
         this.refreshCursorBlink();
         if(!FocusManager.isEnabledForStage(this.stage))
         {
            _loc3_ = this.stage !== null ? this.stage.starling : Starling.current;
            _loc3_.nativeStage.focus = this._nativeFocus;
         }
         if(this._isEditable)
         {
            this._nativeFocus.requestSoftKeyboard();
         }
         if(this._hasFocus)
         {
            return;
         }
         this._hasFocus = true;
         this.stage.addEventListener(TouchEvent.TOUCH,this.stage_touchHandler);
         this.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.stage_keyDownHandler);
         this.addEventListener(starling.events.Event.ENTER_FRAME,this.hasFocus_enterFrameHandler);
         this.dispatchEventWith(FeathersEventType.FOCUS_IN);
      }
      
      protected function refreshCursorBlink() : void
      {
         var _loc1_:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         if(this._cursorDelayID == uint.MAX_VALUE && this._cursorSkin.visible)
         {
            this._cursorSkin.alpha = 1;
            this._cursorDelayID = _loc1_.juggler.delayCall(this.toggleCursorSkin,this._cursorDelay);
         }
         else if(this._cursorDelayID != uint.MAX_VALUE && !this._cursorSkin.visible)
         {
            _loc1_.juggler.removeByID(this._cursorDelayID);
            this._cursorDelayID = uint.MAX_VALUE;
         }
      }
      
      protected function toggleCursorSkin() : void
      {
         if(this._cursorSkin.alpha > 0)
         {
            this._cursorSkin.alpha = 0;
         }
         else
         {
            this._cursorSkin.alpha = 1;
         }
         var _loc1_:Starling = this.stage !== null ? this.stage.starling : Starling.current;
         this._cursorDelayID = _loc1_.juggler.delayCall(this.toggleCursorSkin,this._cursorDelay);
      }
      
      protected function getSelectionIndexAtPoint(param1:Number, param2:Number) : int
      {
         if(!this._text || this._textLines.length == 0)
         {
            return 0;
         }
         var _loc3_:TextLine = this._textLines[0];
         if(param1 - _loc3_.x <= 0)
         {
            if(this._bidiLevel == 1)
            {
               return this._text.length;
            }
            return 0;
         }
         if(param1 - _loc3_.x >= _loc3_.width)
         {
            if(this._bidiLevel == 1)
            {
               return 0;
            }
            return this._text.length;
         }
         var _loc4_:int = _loc3_.getAtomIndexAtPoint(param1,param2);
         if(_loc4_ < 0)
         {
            _loc4_ = _loc3_.getAtomIndexAtPoint(param1,_loc3_.ascent / 2);
         }
         if(_loc4_ < 0)
         {
            return this._text.length;
         }
         if(_loc4_ > this._text.length)
         {
            _loc4_ = this._text.length;
         }
         var _loc5_:flash.geom.Rectangle = _loc3_.getAtomBounds(_loc4_);
         if(param1 - _loc3_.x - _loc5_.x > _loc5_.width / 2)
         {
            return _loc4_ + 1;
         }
         return _loc4_;
      }
      
      protected function getXPositionOfCharIndex(param1:int) : Number
      {
         var _loc2_:String = this._text;
         if(this._imeText !== null)
         {
            _loc2_ = this._imeText;
         }
         if(!_loc2_ || this._textLines.length == 0)
         {
            if(this._currentHorizontalAlign == TextFormatAlign.CENTER)
            {
               return Math.round(this.actualWidth / 2);
            }
            if(this._currentHorizontalAlign == TextFormatAlign.RIGHT)
            {
               return this.actualWidth;
            }
            return 0;
         }
         var _loc3_:TextLine = this._textLines[0];
         if(param1 === _loc2_.length)
         {
            if(this._bidiLevel == 1)
            {
               return _loc3_.x;
            }
            return _loc3_.x + _loc3_.width;
         }
         var _loc4_:int = _loc3_.getAtomIndexAtCharIndex(param1);
         var _loc5_:flash.geom.Rectangle = _loc3_.getAtomBounds(_loc4_);
         var _loc6_:Number = _loc3_.x + _loc5_.x;
         if(this._bidiLevel == 1)
         {
            _loc6_ += _loc5_.width;
         }
         return _loc6_;
      }
      
      protected function positionCursorAtCharIndex(param1:int) : void
      {
         var _loc7_:TextLine = null;
         if(param1 < 0)
         {
            param1 = 0;
         }
         var _loc2_:Number = this.getXPositionOfCharIndex(param1);
         _loc2_ = int(_loc2_ - this._cursorSkin.width / 2);
         this._cursorSkin.x = _loc2_;
         this._cursorSkin.y = this._verticalAlignOffsetY;
         if(this._textLines.length > 0)
         {
            _loc7_ = this._textLines[0];
            this._cursorSkin.height = this.calculateLineAscent(_loc7_) + _loc7_.totalDescent;
         }
         else
         {
            this._cursorSkin.height = this.currentElementFormat.fontSize;
         }
         var _loc3_:Number = _loc2_ + this._cursorSkin.width - this.actualWidth;
         var _loc4_:String = this._text;
         if(this._imeText !== null)
         {
            _loc4_ = this._imeText;
         }
         var _loc5_:Number = this.getXPositionOfCharIndex(_loc4_.length) - this.actualWidth;
         if(_loc5_ < 0)
         {
            _loc5_ = 0;
         }
         var _loc6_:Number = this._textSnapshotScrollX;
         if(this._textSnapshotScrollX < _loc3_)
         {
            this._textSnapshotScrollX = _loc3_;
         }
         else if(this._textSnapshotScrollX > _loc2_)
         {
            this._textSnapshotScrollX = _loc2_;
         }
         if(this._textSnapshotScrollX > _loc5_)
         {
            this._textSnapshotScrollX = _loc5_;
         }
         if(this._textSnapshotScrollX != _loc6_)
         {
            this.invalidate(INVALIDATION_FLAG_DATA);
         }
      }
      
      protected function getCursorIndexFromSelectionRange() : int
      {
         if(this._imeCursorIndex >= 0)
         {
            return this._imeCursorIndex;
         }
         var _loc1_:int = this._selectionEndIndex;
         if(this.touchPointID >= 0 && this._selectionAnchorIndex >= 0 && this._selectionAnchorIndex == this._selectionEndIndex)
         {
            _loc1_ = this._selectionBeginIndex;
         }
         return _loc1_;
      }
      
      protected function positionSelectionBackground() : void
      {
         var _loc6_:TextLine = null;
         var _loc1_:String = this._text;
         if(this._imeText !== null)
         {
            _loc1_ = this._imeText;
         }
         var _loc2_:int = this._selectionBeginIndex;
         if(_loc2_ > _loc1_.length)
         {
            _loc2_ = _loc1_.length;
         }
         var _loc3_:Number = this.getXPositionOfCharIndex(_loc2_) - this._textSnapshotScrollX;
         if(_loc3_ < 0)
         {
            _loc3_ = 0;
         }
         var _loc4_:int = this._selectionEndIndex;
         if(_loc4_ > _loc1_.length)
         {
            _loc4_ = _loc1_.length;
         }
         var _loc5_:Number = this.getXPositionOfCharIndex(_loc4_) - this._textSnapshotScrollX;
         if(_loc5_ < 0)
         {
            _loc5_ = 0;
         }
         else if(_loc5_ > this.actualWidth)
         {
            _loc5_ = this.actualWidth;
         }
         this._selectionSkin.x = _loc3_;
         this._selectionSkin.width = _loc5_ - _loc3_;
         this._selectionSkin.y = this._verticalAlignOffsetY;
         if(this._textLines.length > 0)
         {
            _loc6_ = this._textLines[0];
            this._selectionSkin.height = this.calculateLineAscent(_loc6_) + _loc6_.totalDescent;
         }
         else
         {
            this._selectionSkin.height = this.currentElementFormat.fontSize;
         }
      }
      
      protected function getSelectedText() : String
      {
         if(this._selectionBeginIndex == this._selectionEndIndex)
         {
            return null;
         }
         return this._text.substr(this._selectionBeginIndex,this._selectionEndIndex - this._selectionBeginIndex);
      }
      
      protected function deleteSelectedText() : void
      {
         var _loc1_:String = this._text;
         if(this._displayAsPassword)
         {
            _loc1_ = this._unmaskedText;
         }
         this.text = _loc1_.substr(0,this._selectionBeginIndex) + _loc1_.substr(this._selectionEndIndex);
         this.validate();
         this.selectRange(this._selectionBeginIndex,this._selectionBeginIndex);
      }
      
      protected function replaceSelectedText(param1:String) : void
      {
         var _loc2_:String = this._text;
         if(this._displayAsPassword)
         {
            _loc2_ = this._unmaskedText;
         }
         var _loc3_:String = _loc2_.substr(0,this._selectionBeginIndex) + param1 + _loc2_.substr(this._selectionEndIndex);
         if(this._maxChars > 0 && _loc3_.length > this._maxChars)
         {
            return;
         }
         this.text = _loc3_;
         this.validate();
         var _loc4_:int = this._selectionBeginIndex + param1.length;
         this.selectRange(_loc4_,_loc4_);
      }
      
      protected function imeClientStartCallback() : void
      {
      }
      
      protected function imeClientUpdateCallback(param1:String, param2:Vector.<CompositionAttributeRange>, param3:int, param4:int) : void
      {
         var _loc5_:String = this._text;
         if(this._displayAsPassword)
         {
            _loc5_ = this._unmaskedText;
         }
         this._imeText = _loc5_.substr(0,this._selectionBeginIndex) + param1 + _loc5_.substr(this._selectionEndIndex);
         this._imeCursorIndex = this._selectionBeginIndex + param3;
         this._cursorSkin.visible = this._hasFocus;
         this._selectionSkin.visible = false;
         this.setInvalidationFlag(INVALIDATION_FLAG_DATA);
         this.validate();
      }
      
      protected function imeClientConfirmCallback(param1:String = null, param2:Boolean = false) : void
      {
         this._ignoreNextTextInputEvent = true;
      }
      
      protected function hasFocus_enterFrameHandler(param1:starling.events.Event) : void
      {
         var _loc2_:DisplayObject = this;
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
      
      protected function textEditor_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         var _loc3_:Point = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(!this._isEnabled || !this._isEditable && !this._isSelectable)
         {
            this.touchPointID = -1;
            return;
         }
         if(this.touchPointID >= 0)
         {
            _loc2_ = param1.getTouch(this,null,this.touchPointID);
            _loc3_ = Pool.getPoint();
            _loc2_.getLocation(this,_loc3_);
            _loc3_.x += this._textSnapshotScrollX;
            this.selectRange(this._selectionAnchorIndex,this.getSelectionIndexAtPoint(_loc3_.x,_loc3_.y));
            Pool.putPoint(_loc3_);
            if(_loc2_.phase == TouchPhase.ENDED)
            {
               this.touchPointID = -1;
            }
         }
         else
         {
            _loc2_ = param1.getTouch(this,TouchPhase.BEGAN);
            if(!_loc2_)
            {
               return;
            }
            if(_loc2_.tapCount == 2)
            {
               _loc4_ = TextInputNavigation.findCurrentWordStartIndex(this._text,this._selectionBeginIndex);
               _loc5_ = TextInputNavigation.findCurrentWordEndIndex(this._text,this._selectionEndIndex);
               this.selectRange(_loc4_,_loc5_);
               return;
            }
            if(_loc2_.tapCount > 2)
            {
               this.selectRange(0,this._text.length);
               return;
            }
            this.touchPointID = _loc2_.id;
            _loc3_ = Pool.getPoint();
            _loc2_.getLocation(this,_loc3_);
            _loc3_.x += this._textSnapshotScrollX;
            if(param1.shiftKey)
            {
               if(this._selectionAnchorIndex < 0)
               {
                  this._selectionAnchorIndex = this._selectionBeginIndex;
               }
               this.selectRange(this._selectionAnchorIndex,this.getSelectionIndexAtPoint(_loc3_.x,_loc3_.y));
            }
            else
            {
               this.setFocus(_loc3_);
            }
            Pool.putPoint(_loc3_);
         }
      }
      
      protected function stage_touchHandler(param1:TouchEvent) : void
      {
         if(FocusManager.isEnabledForStage(this.stage))
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
      
      protected function stage_keyDownHandler(param1:KeyboardEvent) : void
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         if(!this._isEnabled || !this._isEditable && !this._isSelectable || this.touchPointID >= 0 || param1.isDefaultPrevented())
         {
            return;
         }
         var _loc2_:uint = param1.charCode;
         if(param1.ctrlKey && (_loc2_ == 97 || _loc2_ == 99 || _loc2_ == 118 || _loc2_ == 120))
         {
            return;
         }
         var _loc3_:int = -1;
         if(!FocusManager.isEnabledForStage(this.stage) && param1.keyCode == Keyboard.TAB)
         {
            this.clearFocus();
            return;
         }
         if(param1.keyCode == Keyboard.HOME || param1.keyCode == Keyboard.UP)
         {
            _loc3_ = 0;
            if(param1.shiftKey)
            {
               this.selectRange(_loc3_,this._selectionAnchorIndex);
               return;
            }
         }
         else if(param1.keyCode == Keyboard.END || param1.keyCode == Keyboard.DOWN)
         {
            _loc3_ = this._text.length;
            if(param1.shiftKey)
            {
               this.selectRange(this._selectionAnchorIndex,_loc3_);
               return;
            }
         }
         else if(param1.keyCode == Keyboard.LEFT)
         {
            if(param1.shiftKey)
            {
               if(this._selectionAnchorIndex >= 0 && this._selectionAnchorIndex == this._selectionBeginIndex && this._selectionBeginIndex != this._selectionEndIndex)
               {
                  _loc3_ = this._selectionEndIndex - 1;
                  this.selectRange(this._selectionBeginIndex,_loc3_);
               }
               else
               {
                  _loc3_ = this._selectionBeginIndex - 1;
                  if(_loc3_ < 0)
                  {
                     _loc3_ = 0;
                  }
                  this.selectRange(_loc3_,this._selectionEndIndex);
               }
               return;
            }
            if(this._selectionBeginIndex != this._selectionEndIndex)
            {
               _loc3_ = this._selectionBeginIndex;
            }
            else
            {
               if(param1.altKey || param1.ctrlKey)
               {
                  _loc3_ = TextInputNavigation.findPreviousWordStartIndex(this._text,this._selectionBeginIndex);
               }
               else
               {
                  _loc3_ = this._selectionBeginIndex - 1;
               }
               if(_loc3_ < 0)
               {
                  _loc3_ = 0;
               }
            }
         }
         else if(param1.keyCode == Keyboard.RIGHT)
         {
            if(param1.shiftKey)
            {
               if(this._selectionAnchorIndex >= 0 && this._selectionAnchorIndex == this._selectionEndIndex && this._selectionBeginIndex != this._selectionEndIndex)
               {
                  _loc3_ = this._selectionBeginIndex + 1;
                  this.selectRange(_loc3_,this._selectionEndIndex);
               }
               else
               {
                  _loc3_ = this._selectionEndIndex + 1;
                  if(_loc3_ < 0 || _loc3_ > this._text.length)
                  {
                     _loc3_ = this._text.length;
                  }
                  this.selectRange(this._selectionBeginIndex,_loc3_);
               }
               return;
            }
            if(this._selectionBeginIndex != this._selectionEndIndex)
            {
               _loc3_ = this._selectionEndIndex;
            }
            else
            {
               if(param1.altKey || param1.ctrlKey)
               {
                  _loc3_ = TextInputNavigation.findNextWordStartIndex(this._text,this._selectionEndIndex);
               }
               else
               {
                  _loc3_ = this._selectionEndIndex + 1;
               }
               if(_loc3_ < 0 || _loc3_ > this._text.length)
               {
                  _loc3_ = this._text.length;
               }
            }
         }
         if(_loc3_ < 0)
         {
            if(param1.keyCode == Keyboard.ENTER)
            {
               this.dispatchEventWith(FeathersEventType.ENTER);
               return;
            }
            if(!this._isEditable)
            {
               return;
            }
            _loc4_ = this._text;
            if(this._displayAsPassword)
            {
               _loc4_ = this._unmaskedText;
            }
            if(param1.keyCode == Keyboard.DELETE)
            {
               if(param1.altKey || param1.ctrlKey)
               {
                  _loc5_ = TextInputNavigation.findNextWordStartIndex(this._text,this._selectionEndIndex);
                  this.text = _loc4_.substr(0,this._selectionBeginIndex) + _loc4_.substr(_loc5_);
               }
               else if(this._selectionBeginIndex != this._selectionEndIndex)
               {
                  this.deleteSelectedText();
               }
               else if(this._selectionEndIndex < _loc4_.length)
               {
                  this.text = _loc4_.substr(0,this._selectionBeginIndex) + _loc4_.substr(this._selectionEndIndex + 1);
               }
            }
            else if(param1.keyCode == Keyboard.BACKSPACE)
            {
               if(param1.altKey || param1.ctrlKey)
               {
                  _loc3_ = TextInputNavigation.findPreviousWordStartIndex(this._text,this._selectionBeginIndex);
                  this.text = _loc4_.substr(0,_loc3_) + _loc4_.substr(this._selectionEndIndex);
               }
               else if(this._selectionBeginIndex != this._selectionEndIndex)
               {
                  this.deleteSelectedText();
               }
               else if(this._selectionBeginIndex > 0)
               {
                  _loc3_ = this._selectionBeginIndex - 1;
                  this.text = _loc4_.substr(0,this._selectionBeginIndex - 1) + _loc4_.substr(this._selectionEndIndex);
               }
            }
         }
         if(_loc3_ >= 0)
         {
            this.validate();
            this.selectRange(_loc3_,_loc3_);
         }
      }
      
      protected function nativeFocus_textInputHandler(param1:TextEvent) : void
      {
         if(this._ignoreNextTextInputEvent)
         {
            this._ignoreNextTextInputEvent = false;
            return;
         }
         if(!this._isEditable || !this._isEnabled)
         {
            return;
         }
         this._imeText = null;
         this._imeCursorIndex = -1;
         var _loc2_:String = param1.text;
         if(_loc2_ === CARRIAGE_RETURN || _loc2_ === LINE_FEED)
         {
            return;
         }
         var _loc3_:int = _loc2_.charCodeAt(0);
         if(!this._restrict || this._restrict.isCharacterAllowed(_loc3_))
         {
            this.replaceSelectedText(_loc2_);
         }
      }
      
      protected function nativeFocus_selectAllHandler(param1:flash.events.Event) : void
      {
         if(!this._isEnabled || !this._isEditable && !this._isSelectable)
         {
            return;
         }
         this._selectionAnchorIndex = 0;
         this.selectRange(0,this._text.length);
      }
      
      protected function nativeFocus_cutHandler(param1:flash.events.Event) : void
      {
         if(!this._isEnabled || !this._isEditable && !this._isSelectable || this._selectionBeginIndex == this._selectionEndIndex || this._displayAsPassword)
         {
            return;
         }
         Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT,this.getSelectedText());
         if(!this._isEditable)
         {
            return;
         }
         this.deleteSelectedText();
      }
      
      protected function nativeFocus_copyHandler(param1:flash.events.Event) : void
      {
         if(!this._isEnabled || !this._isEditable && !this._isSelectable || this._selectionBeginIndex == this._selectionEndIndex || this._displayAsPassword)
         {
            return;
         }
         Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT,this.getSelectedText());
      }
      
      protected function nativeFocus_pasteHandler(param1:flash.events.Event) : void
      {
         if(!this._isEditable || !this._isEnabled)
         {
            return;
         }
         var _loc2_:String = Clipboard.generalClipboard.getData(ClipboardFormats.TEXT_FORMAT) as String;
         if(_loc2_ === null)
         {
            return;
         }
         _loc2_ = _loc2_.replace(/[\n\r]/g,"");
         if(this._restrict)
         {
            _loc2_ = this._restrict.filterText(_loc2_);
         }
         this.replaceSelectedText(_loc2_);
      }
   }
}

