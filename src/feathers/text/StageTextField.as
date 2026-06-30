package feathers.text
{
   import flash.display.BitmapData;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.text.engine.FontPosture;
   import flash.text.engine.FontWeight;
   
   public final class StageTextField extends EventDispatcher
   {
      
      private var _textField:TextField;
      
      private var _textFormat:TextFormat;
      
      private var _isComplete:Boolean = false;
      
      private var _autoCapitalize:String = "none";
      
      private var _autoCorrect:Boolean = false;
      
      private var _color:uint = 0;
      
      private var _fontFamily:String = null;
      
      private var _locale:String = "en";
      
      private var _returnKeyLabel:String = "default";
      
      private var _softKeyboardType:String = "default";
      
      private var _textAlign:String = "start";
      
      private var _viewPort:flash.geom.Rectangle = new flash.geom.Rectangle();
      
      public function StageTextField(param1:Object = null)
      {
         super();
         this.initialize(param1);
      }
      
      public function get autoCapitalize() : String
      {
         return this._autoCapitalize;
      }
      
      public function set autoCapitalize(param1:String) : void
      {
         this._autoCapitalize = param1;
      }
      
      public function get autoCorrect() : Boolean
      {
         return this._autoCorrect;
      }
      
      public function set autoCorrect(param1:Boolean) : void
      {
         this._autoCorrect = param1;
      }
      
      public function get color() : uint
      {
         return this._textFormat.color as uint;
      }
      
      public function set color(param1:uint) : void
      {
         if(this._textFormat.color == param1)
         {
            return;
         }
         this._textFormat.color = param1;
         this._textField.defaultTextFormat = this._textFormat;
         this._textField.setTextFormat(this._textFormat);
      }
      
      public function get displayAsPassword() : Boolean
      {
         return this._textField.displayAsPassword;
      }
      
      public function set displayAsPassword(param1:Boolean) : void
      {
         this._textField.displayAsPassword = param1;
      }
      
      public function get editable() : Boolean
      {
         return this._textField.type == TextFieldType.INPUT;
      }
      
      public function set editable(param1:Boolean) : void
      {
         this._textField.type = param1 ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
      }
      
      public function get fontFamily() : String
      {
         return this._textFormat.font;
      }
      
      public function set fontFamily(param1:String) : void
      {
         if(this._textFormat.font == param1)
         {
            return;
         }
         this._textFormat.font = param1;
         this._textField.defaultTextFormat = this._textFormat;
         this._textField.setTextFormat(this._textFormat);
      }
      
      public function get fontPosture() : String
      {
         return this._textFormat.italic ? FontPosture.ITALIC : FontPosture.NORMAL;
      }
      
      public function set fontPosture(param1:String) : void
      {
         if(this.fontPosture == param1)
         {
            return;
         }
         this._textFormat.italic = param1 == FontPosture.ITALIC;
         this._textField.defaultTextFormat = this._textFormat;
         this._textField.setTextFormat(this._textFormat);
      }
      
      public function get fontSize() : int
      {
         return this._textFormat.size as int;
      }
      
      public function set fontSize(param1:int) : void
      {
         if(this._textFormat.size == param1)
         {
            return;
         }
         this._textFormat.size = param1;
         this._textField.defaultTextFormat = this._textFormat;
         this._textField.setTextFormat(this._textFormat);
      }
      
      public function get fontWeight() : String
      {
         return this._textFormat.bold ? FontWeight.BOLD : FontWeight.NORMAL;
      }
      
      public function set fontWeight(param1:String) : void
      {
         if(this.fontWeight == param1)
         {
            return;
         }
         this._textFormat.bold = param1 == FontWeight.BOLD;
         this._textField.defaultTextFormat = this._textFormat;
         this._textField.setTextFormat(this._textFormat);
      }
      
      public function get locale() : String
      {
         return this._locale;
      }
      
      public function set locale(param1:String) : void
      {
         this._locale = param1;
      }
      
      public function get maxChars() : int
      {
         return this._textField.maxChars;
      }
      
      public function set maxChars(param1:int) : void
      {
         this._textField.maxChars = param1;
      }
      
      public function get multiline() : Boolean
      {
         return this._textField.multiline;
      }
      
      public function get restrict() : String
      {
         return this._textField.restrict;
      }
      
      public function set restrict(param1:String) : void
      {
         this._textField.restrict = param1;
      }
      
      public function get returnKeyLabel() : String
      {
         return this._returnKeyLabel;
      }
      
      public function set returnKeyLabel(param1:String) : void
      {
         this._returnKeyLabel = param1;
      }
      
      public function get selectionActiveIndex() : int
      {
         return this._textField.selectionBeginIndex;
      }
      
      public function get selectionAnchorIndex() : int
      {
         return this._textField.selectionEndIndex;
      }
      
      public function get softKeyboardType() : String
      {
         return this._softKeyboardType;
      }
      
      public function set softKeyboardType(param1:String) : void
      {
         this._softKeyboardType = param1;
      }
      
      public function get stage() : Stage
      {
         return this._textField.stage;
      }
      
      public function set stage(param1:Stage) : void
      {
         if(this._textField.stage == param1)
         {
            return;
         }
         if(this._textField.stage)
         {
            this._textField.parent.removeChild(this._textField);
         }
         if(param1)
         {
            param1.addChild(this._textField);
            this.dispatchCompleteIfPossible();
         }
      }
      
      public function get text() : String
      {
         return this._textField.text;
      }
      
      public function set text(param1:String) : void
      {
         this._textField.text = param1;
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
         if(param1 == TextFormatAlign.START)
         {
            param1 = TextFormatAlign.LEFT;
         }
         else if(param1 == TextFormatAlign.END)
         {
            param1 = TextFormatAlign.RIGHT;
         }
         this._textFormat.align = param1;
         this._textField.defaultTextFormat = this._textFormat;
         this._textField.setTextFormat(this._textFormat);
      }
      
      public function get viewPort() : flash.geom.Rectangle
      {
         return this._viewPort;
      }
      
      public function set viewPort(param1:flash.geom.Rectangle) : void
      {
         if(!param1 || param1.width < 0 || param1.height < 0)
         {
            throw new RangeError("The Rectangle value is not valid.");
         }
         this._viewPort = param1;
         this._textField.x = this._viewPort.x;
         this._textField.y = this._viewPort.y;
         this._textField.width = this._viewPort.width;
         this._textField.height = this._viewPort.height;
         this.dispatchCompleteIfPossible();
      }
      
      public function get visible() : Boolean
      {
         return this._textField.visible;
      }
      
      public function set visible(param1:Boolean) : void
      {
         this._textField.visible = param1;
      }
      
      public function assignFocus() : void
      {
         if(!this._textField.parent)
         {
            return;
         }
         this._textField.stage.focus = this._textField;
      }
      
      public function dispose() : void
      {
         this.stage = null;
         this._textField = null;
         this._textFormat = null;
      }
      
      public function drawViewPortToBitmapData(param1:BitmapData) : void
      {
         if(!param1)
         {
            throw new Error("The bitmap is null.");
         }
         if(param1.width != this._viewPort.width || param1.height != this._viewPort.height)
         {
            throw new ArgumentError("The bitmap\'s width or height is different from view port\'s width or height.");
         }
         param1.draw(this._textField);
      }
      
      public function selectRange(param1:int, param2:int) : void
      {
         this._textField.setSelection(param1,param2);
      }
      
      private function dispatchCompleteIfPossible() : void
      {
         if(!this._textField.stage || this._viewPort.isEmpty())
         {
            this._isComplete = false;
         }
         if(Boolean(this._textField.stage) && !this._viewPort.isEmpty())
         {
            this._isComplete = true;
            this.dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      private function initialize(param1:Object) : void
      {
         this._textField = new TextField();
         this._textField.type = TextFieldType.INPUT;
         var _loc2_:Boolean = Boolean(param1) && param1.hasOwnProperty("multiline") && Boolean(param1.multiline);
         this._textField.multiline = _loc2_;
         this._textField.wordWrap = _loc2_;
         this._textField.addEventListener(Event.CHANGE,this.textField_eventHandler);
         this._textField.addEventListener(FocusEvent.FOCUS_IN,this.textField_eventHandler);
         this._textField.addEventListener(FocusEvent.FOCUS_OUT,this.textField_eventHandler);
         this._textField.addEventListener(KeyboardEvent.KEY_DOWN,this.textField_eventHandler);
         this._textField.addEventListener(KeyboardEvent.KEY_UP,this.textField_eventHandler);
         this._textField.addEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.textField_keyFocusChangeHandler);
         this._textFormat = new TextFormat(null,11,0,false,false,false);
         this._textField.defaultTextFormat = this._textFormat;
      }
      
      private function textField_eventHandler(param1:Event) : void
      {
         this.dispatchEvent(param1);
      }
      
      private function textField_keyFocusChangeHandler(param1:FocusEvent) : void
      {
         param1.preventDefault();
         param1.stopImmediatePropagation();
         param1.stopPropagation();
      }
   }
}

