package feathers.controls.popups
{
   import feathers.controls.Callout;
   import feathers.core.PopUpManager;
   import feathers.utils.geom.matrixToScaleX;
   import feathers.utils.geom.matrixToScaleY;
   import flash.errors.IllegalOperationError;
   import flash.geom.Matrix;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import starling.events.EventDispatcher;
   import starling.utils.Pool;
   
   public class CalloutPopUpContentManager extends EventDispatcher implements IPopUpContentManager
   {
      
      public var calloutFactory:Function;
      
      public var supportedPositions:Vector.<String> = Callout.DEFAULT_POSITIONS;
      
      public var isModal:Boolean = true;
      
      protected var _overlayFactory:Function = null;
      
      protected var content:DisplayObject;
      
      protected var callout:Callout;
      
      public function CalloutPopUpContentManager()
      {
         super();
      }
      
      public function get overlayFactory() : Function
      {
         return this._overlayFactory;
      }
      
      public function set overlayFactory(param1:Function) : void
      {
         this._overlayFactory = param1;
      }
      
      public function get isOpen() : Boolean
      {
         return this.content !== null;
      }
      
      public function open(param1:DisplayObject, param2:DisplayObject) : void
      {
         var scaledCalloutFactory:Function;
         var matrix:Matrix;
         var contentScaleX:Number = NaN;
         var contentScaleY:Number = NaN;
         var originalCalloutFactory:Function = null;
         var content:DisplayObject = param1;
         var source:DisplayObject = param2;
         if(this.isOpen)
         {
            throw new IllegalOperationError("Pop-up content is already open. Close the previous content before opening new content.");
         }
         scaledCalloutFactory = this.calloutFactory;
         matrix = Pool.getMatrix();
         source.getTransformationMatrix(PopUpManager.root,matrix);
         contentScaleX = matrixToScaleX(matrix);
         contentScaleY = matrixToScaleY(matrix);
         Pool.putMatrix(matrix);
         if(contentScaleX != 1 || contentScaleY != 1)
         {
            originalCalloutFactory = this.calloutFactory;
            if(originalCalloutFactory === null)
            {
               originalCalloutFactory = Callout.calloutFactory;
            }
            scaledCalloutFactory = function():Callout
            {
               var _loc1_:Callout = null;
               _loc1_ = originalCalloutFactory();
               _loc1_.scaleX = contentScaleX;
               _loc1_.scaleY = contentScaleY;
               return _loc1_;
            };
         }
         this.content = content;
         this.callout = Callout.show(content,source,this.supportedPositions,this.isModal,scaledCalloutFactory,this._overlayFactory);
         this.callout.addEventListener(Event.REMOVED_FROM_STAGE,this.callout_removedFromStageHandler);
         this.dispatchEventWith(Event.OPEN);
      }
      
      public function close() : void
      {
         if(!this.isOpen)
         {
            return;
         }
         this.callout.close();
      }
      
      public function dispose() : void
      {
         this.close();
      }
      
      protected function cleanup() : void
      {
         this.content = null;
         this.callout.content = null;
         this.callout.removeEventListener(Event.REMOVED_FROM_STAGE,this.callout_removedFromStageHandler);
         this.callout = null;
      }
      
      protected function callout_removedFromStageHandler(param1:Event) : void
      {
         this.cleanup();
         this.dispatchEventWith(Event.CLOSE);
      }
   }
}

