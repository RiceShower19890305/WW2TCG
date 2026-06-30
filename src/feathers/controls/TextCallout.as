package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.ITextRenderer;
   import feathers.core.IToolTip;
   import feathers.core.PopUpManager;
   import feathers.skins.IStyleProvider;
   import feathers.text.FontStylesSet;
   import flash.ui.Keyboard;
   import starling.display.DisplayObject;
   import starling.events.EnterFrameEvent;
   import starling.events.Event;
   import starling.text.TextFormat;
   
   public class TextCallout extends Callout implements IToolTip
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      public static const DEFAULT_CHILD_STYLE_NAME_TEXT_RENDERER:String = "feathers-text-callout-text-renderer";
      
      public static var calloutFactory:Function = defaultCalloutFactory;
      
      protected var textRenderer:ITextRenderer;
      
      protected var textRendererStyleName:String = "feathers-text-callout-text-renderer";
      
      protected var _text:String;
      
      protected var _wordWrap:Boolean = true;
      
      protected var _fontStylesSet:FontStylesSet;
      
      protected var _textRendererFactory:Function;
      
      protected var _customTextRendererStyleName:String;
      
      public function TextCallout()
      {
         super();
         this.isQuickHitAreaEnabled = true;
         if(this._fontStylesSet === null)
         {
            this._fontStylesSet = new FontStylesSet();
            this._fontStylesSet.addEventListener(Event.CHANGE,this.fontStyles_changeHandler);
         }
      }
      
      public static function defaultCalloutFactory() : TextCallout
      {
         var _loc1_:TextCallout = new TextCallout();
         _loc1_.closeOnTouchBeganOutside = true;
         _loc1_.closeOnTouchEndedOutside = true;
         _loc1_.closeOnKeys = new <uint>[Keyboard.BACK,Keyboard.ESCAPE];
         return _loc1_;
      }
      
      public static function show(param1:String, param2:DisplayObject, param3:Vector.<String> = null, param4:Boolean = true, param5:Function = null, param6:Function = null) : TextCallout
      {
         if(!param2.stage)
         {
            throw new ArgumentError("TextCallout origin must be added to the stage.");
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
         var _loc8_:TextCallout = TextCallout(_loc7_());
         _loc8_.text = param1;
         _loc8_.supportedPositions = param3;
         _loc8_.origin = param2;
         _loc7_ = param6;
         if(_loc7_ == null)
         {
            _loc7_ = calloutOverlayFactory;
            if(_loc7_ == null)
            {
               _loc7_ = PopUpManager.defaultOverlayFactory;
            }
         }
         PopUpManager.addPopUp(_loc8_,param4,false,_loc7_);
         _loc8_.validate();
         return _loc8_;
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function set text(param1:String) : void
      {
         if(this._text === param1)
         {
            return;
         }
         this._text = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get wordWrap() : Boolean
      {
         return this._wordWrap;
      }
      
      public function set wordWrap(param1:Boolean) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._wordWrap === param1)
         {
            return;
         }
         this._wordWrap = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
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
      
      public function get textRendererFactory() : Function
      {
         return this._textRendererFactory;
      }
      
      public function set textRendererFactory(param1:Function) : void
      {
         if(this._textRendererFactory == param1)
         {
            return;
         }
         this._textRendererFactory = param1;
         this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
      }
      
      public function get customTextRendererStyleName() : String
      {
         return this._customTextRendererStyleName;
      }
      
      public function set customTextRendererStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customTextRendererStyleName === param1)
         {
            return;
         }
         this._customTextRendererStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         if(TextCallout.globalStyleProvider !== null)
         {
            return TextCallout.globalStyleProvider;
         }
         return Callout.globalStyleProvider;
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
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc4_:Boolean = this.isInvalid(INVALIDATION_FLAG_TEXT_RENDERER);
         if(_loc4_)
         {
            this.createTextRenderer();
         }
         if(_loc4_ || _loc1_ || _loc2_)
         {
            this.refreshTextRendererData();
         }
         if(_loc4_ || _loc3_)
         {
            this.refreshTextRendererStyles();
         }
         super.draw();
      }
      
      protected function createTextRenderer() : void
      {
         if(this.textRenderer !== null)
         {
            this.removeChild(DisplayObject(this.textRenderer),true);
            this.textRenderer = null;
         }
         var _loc1_:Function = this._textRendererFactory != null ? this._textRendererFactory : FeathersControl.defaultTextRendererFactory;
         this.textRenderer = ITextRenderer(_loc1_());
         var _loc2_:String = this._customTextRendererStyleName !== null ? this._customTextRendererStyleName : this.textRendererStyleName;
         this.textRenderer.styleNameList.add(_loc2_);
         this.content = DisplayObject(this.textRenderer);
      }
      
      protected function refreshTextRendererData() : void
      {
         this.textRenderer.text = this._text;
         this.textRenderer.visible = Boolean(this._text) && this._text.length > 0;
      }
      
      protected function refreshTextRendererStyles() : void
      {
         this.textRenderer.wordWrap = this._wordWrap;
         this.textRenderer.fontStyles = this._fontStylesSet;
      }
      
      override protected function callout_enterFrameHandler(param1:EnterFrameEvent) : void
      {
         if(this.isCreated)
         {
            this.positionRelativeToOrigin();
         }
      }
      
      protected function fontStyles_changeHandler(param1:Event) : void
      {
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
   }
}

