package feathers.controls.text
{
   import feathers.core.FeathersControl;
   import feathers.core.IStateContext;
   import feathers.core.IStateObserver;
   import feathers.events.FeathersEventType;
   import feathers.text.FontStylesSet;
   import starling.events.Event;
   
   public class BaseTextRenderer extends FeathersControl implements IStateObserver
   {
      
      protected var _text:String = null;
      
      protected var _stateContext:IStateContext;
      
      protected var _wordWrap:Boolean = false;
      
      protected var _fontStyles:FontStylesSet;
      
      public function BaseTextRenderer()
      {
         super();
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function set text(param1:String) : void
      {
         if(this._text == param1)
         {
            return;
         }
         this._text = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get stateContext() : IStateContext
      {
         return this._stateContext;
      }
      
      public function set stateContext(param1:IStateContext) : void
      {
         if(this._stateContext === param1)
         {
            return;
         }
         if(this._stateContext)
         {
            this._stateContext.removeEventListener(FeathersEventType.STATE_CHANGE,this.stateContext_stateChangeHandler);
         }
         this._stateContext = param1;
         if(this._stateContext)
         {
            this._stateContext.addEventListener(FeathersEventType.STATE_CHANGE,this.stateContext_stateChangeHandler);
         }
         this.invalidate(INVALIDATION_FLAG_STATE);
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
      
      public function get fontStyles() : FontStylesSet
      {
         return this._fontStyles;
      }
      
      public function set fontStyles(param1:FontStylesSet) : void
      {
         if(this._fontStyles === param1)
         {
            return;
         }
         if(this._fontStyles !== null)
         {
            this._fontStyles.removeEventListener(Event.CHANGE,this.fontStylesSet_changeHandler);
         }
         this._fontStyles = param1;
         if(this._fontStyles !== null)
         {
            this._fontStyles.addEventListener(Event.CHANGE,this.fontStylesSet_changeHandler);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      override public function dispose() : void
      {
         this.stateContext = null;
         this.fontStyles = null;
         super.dispose();
      }
      
      protected function stateContext_stateChangeHandler(param1:Event) : void
      {
         this.invalidate(INVALIDATION_FLAG_STATE);
      }
      
      protected function fontStylesSet_changeHandler(param1:Event) : void
      {
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
   }
}

