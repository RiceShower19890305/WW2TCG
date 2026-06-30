package feathers.utils.text
{
   import feathers.core.IIMETextEditor;
   import flash.display.Sprite;
   import flash.events.IMEEvent;
   import flash.geom.Rectangle;
   import flash.text.ime.CompositionAttributeRange;
   import flash.text.ime.IIMEClient;
   import starling.core.Starling;
   import starling.display.Stage;
   
   public class TextEditorIMEClient extends Sprite implements IIMEClient
   {
      
      protected var _textEditor:IIMETextEditor;
      
      protected var _startCallback:Function;
      
      protected var _updateCallback:Function;
      
      protected var _confirmCallback:Function;
      
      protected var _compositionStartIndex:int = -1;
      
      protected var _compositionEndIndex:int = -1;
      
      public function TextEditorIMEClient(param1:IIMETextEditor, param2:Function, param3:Function, param4:Function)
      {
         super();
         this._textEditor = param1;
         this._startCallback = param2;
         this._updateCallback = param3;
         this._confirmCallback = param4;
         this.addEventListener(IMEEvent.IME_START_COMPOSITION,this.imeStartCompositionHandler);
      }
      
      public function get verticalTextLayout() : Boolean
      {
         return false;
      }
      
      public function get compositionStartIndex() : int
      {
         return this._compositionStartIndex;
      }
      
      public function get compositionEndIndex() : int
      {
         return this._compositionEndIndex;
      }
      
      public function get selectionAnchorIndex() : int
      {
         return this._textEditor.selectionAnchorIndex;
      }
      
      public function get selectionActiveIndex() : int
      {
         return this._textEditor.selectionActiveIndex;
      }
      
      public function getTextBounds(param1:int, param2:int) : Rectangle
      {
         var _loc3_:Stage = this._textEditor.stage;
         if(_loc3_ === null)
         {
            return new Rectangle();
         }
         var _loc4_:Rectangle = this._textEditor.getBounds(_loc3_);
         var _loc5_:Starling = this._textEditor.stage !== null ? this._textEditor.stage.starling : Starling.current;
         var _loc6_:Number = 1;
         if(_loc5_.supportHighResolutions)
         {
            _loc6_ = _loc5_.nativeStage.contentsScaleFactor;
         }
         var _loc7_:Number = _loc5_.contentScaleFactor / _loc6_;
         _loc4_.x *= _loc7_;
         _loc4_.y *= _loc7_;
         _loc4_.width *= _loc7_;
         _loc4_.height *= _loc7_;
         var _loc8_:Rectangle = _loc5_.viewPort;
         _loc4_.x += _loc8_.x;
         _loc4_.y += _loc8_.y;
         return _loc4_;
      }
      
      public function confirmComposition(param1:String = null, param2:Boolean = false) : void
      {
         this._confirmCallback(param1,param2);
      }
      
      public function updateComposition(param1:String, param2:Vector.<CompositionAttributeRange>, param3:int, param4:int) : void
      {
         this._compositionStartIndex = param3;
         this._compositionEndIndex = param4;
         this._updateCallback(param1,param2,param3,param4);
      }
      
      public function selectRange(param1:int, param2:int) : void
      {
         this._textEditor.selectRange(param1,param2);
      }
      
      public function getTextInRange(param1:int, param2:int) : String
      {
         return this._textEditor.text.substring(param1,param2);
      }
      
      protected function imeStartCompositionHandler(param1:IMEEvent) : void
      {
         param1.imeClient = this;
         this._startCallback();
      }
   }
}

