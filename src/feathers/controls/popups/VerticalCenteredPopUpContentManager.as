package feathers.controls.popups
{
   import feathers.core.IFeathersControl;
   import feathers.core.IValidating;
   import feathers.core.PopUpManager;
   import feathers.events.FeathersEventType;
   import feathers.utils.display.getDisplayObjectDepthFromStage;
   import feathers.utils.geom.matrixToScaleX;
   import feathers.utils.geom.matrixToScaleY;
   import flash.errors.IllegalOperationError;
   import flash.events.KeyboardEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.display.Stage;
   import starling.events.Event;
   import starling.events.EventDispatcher;
   import starling.events.ResizeEvent;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Pool;
   
   public class VerticalCenteredPopUpContentManager extends EventDispatcher implements IPopUpContentManager
   {
      
      public var marginTop:Number = 0;
      
      public var marginRight:Number = 0;
      
      public var marginBottom:Number = 0;
      
      public var marginLeft:Number = 0;
      
      protected var _overlayFactory:Function = null;
      
      protected var content:DisplayObject;
      
      protected var touchPointID:int = -1;
      
      public function VerticalCenteredPopUpContentManager()
      {
         super();
      }
      
      public function get margin() : Number
      {
         return this.marginTop;
      }
      
      public function set margin(param1:Number) : void
      {
         this.marginTop = param1;
         this.marginRight = param1;
         this.marginBottom = param1;
         this.marginLeft = param1;
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
         if(this.isOpen)
         {
            throw new IllegalOperationError("Pop-up content is already open. Close the previous content before opening new content.");
         }
         var _loc3_:Matrix = Pool.getMatrix();
         param2.getTransformationMatrix(PopUpManager.root,_loc3_);
         param1.scaleX = matrixToScaleX(_loc3_);
         param1.scaleY = matrixToScaleY(_loc3_);
         Pool.putMatrix(_loc3_);
         this.content = param1;
         PopUpManager.addPopUp(this.content,true,false,this._overlayFactory);
         if(this.content is IFeathersControl)
         {
            this.content.addEventListener(FeathersEventType.RESIZE,this.content_resizeHandler);
         }
         this.content.addEventListener(Event.REMOVED_FROM_STAGE,this.content_removedFromStageHandler);
         this.layout();
         var _loc4_:Stage = Starling.current.stage;
         _loc4_.addEventListener(TouchEvent.TOUCH,this.stage_touchHandler);
         _loc4_.addEventListener(ResizeEvent.RESIZE,this.stage_resizeHandler);
         var _loc5_:int = -getDisplayObjectDepthFromStage(this.content);
         Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN,this.nativeStage_keyDownHandler,false,_loc5_,true);
         this.dispatchEventWith(Event.OPEN);
      }
      
      public function close() : void
      {
         if(!this.isOpen)
         {
            return;
         }
         var _loc1_:DisplayObject = this.content;
         this.content = null;
         var _loc2_:Stage = Starling.current.stage;
         _loc2_.removeEventListener(TouchEvent.TOUCH,this.stage_touchHandler);
         _loc2_.removeEventListener(ResizeEvent.RESIZE,this.stage_resizeHandler);
         Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN,this.nativeStage_keyDownHandler);
         if(_loc1_ is IFeathersControl)
         {
            _loc1_.removeEventListener(FeathersEventType.RESIZE,this.content_resizeHandler);
         }
         _loc1_.removeEventListener(Event.REMOVED_FROM_STAGE,this.content_removedFromStageHandler);
         if(_loc1_.parent)
         {
            _loc1_.removeFromParent(false);
         }
         this.dispatchEventWith(Event.CLOSE);
      }
      
      public function dispose() : void
      {
         this.close();
      }
      
      protected function layout() : void
      {
         var _loc4_:Number = NaN;
         var _loc8_:IFeathersControl = null;
         var _loc1_:Stage = Starling.current.stage;
         var _loc2_:Point = Pool.getPoint(_loc1_.stageWidth,_loc1_.stageHeight);
         PopUpManager.root.globalToLocal(_loc2_,_loc2_);
         var _loc3_:Number = _loc2_.x;
         _loc4_ = _loc2_.y;
         Pool.putPoint(_loc2_);
         var _loc5_:Number = _loc3_;
         if(_loc5_ > _loc4_)
         {
            _loc5_ = _loc4_;
         }
         _loc5_ -= this.marginLeft + this.marginRight;
         var _loc6_:Number = _loc4_ - this.marginTop - this.marginBottom;
         var _loc7_:Boolean = false;
         if(this.content is IFeathersControl)
         {
            _loc8_ = IFeathersControl(this.content);
            _loc8_.minWidth = _loc5_;
            _loc8_.maxWidth = _loc5_;
            _loc8_.maxHeight = _loc6_;
            _loc7_ = true;
         }
         if(this.content is IValidating)
         {
            IValidating(this.content).validate();
         }
         if(!_loc7_)
         {
            if(this.content.width > _loc5_)
            {
               this.content.width = _loc5_;
            }
            if(this.content.height > _loc6_)
            {
               this.content.height = _loc6_;
            }
         }
         this.content.x = Math.round((_loc3_ - this.content.width) / 2);
         this.content.y = Math.round((_loc4_ - this.content.height) / 2);
      }
      
      protected function content_resizeHandler(param1:Event) : void
      {
         this.layout();
      }
      
      protected function content_removedFromStageHandler(param1:Event) : void
      {
         this.close();
      }
      
      protected function nativeStage_keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.isDefaultPrevented())
         {
            return;
         }
         if(param1.keyCode != Keyboard.BACK && param1.keyCode != Keyboard.ESCAPE)
         {
            return;
         }
         param1.preventDefault();
         this.close();
      }
      
      protected function stage_resizeHandler(param1:ResizeEvent) : void
      {
         this.layout();
      }
      
      protected function stage_touchHandler(param1:TouchEvent) : void
      {
         var _loc3_:Touch = null;
         var _loc4_:Point = null;
         var _loc5_:DisplayObject = null;
         var _loc6_:Boolean = false;
         if(!PopUpManager.isTopLevelPopUp(this.content))
         {
            return;
         }
         var _loc2_:Stage = Starling.current.stage;
         if(this.touchPointID >= 0)
         {
            _loc3_ = param1.getTouch(_loc2_,TouchPhase.ENDED,this.touchPointID);
            if(!_loc3_)
            {
               return;
            }
            _loc4_ = Pool.getPoint();
            _loc3_.getLocation(_loc2_,_loc4_);
            _loc5_ = _loc2_.hitTest(_loc4_);
            Pool.putPoint(_loc4_);
            _loc6_ = false;
            if(this.content is DisplayObjectContainer)
            {
               _loc6_ = DisplayObjectContainer(this.content).contains(_loc5_);
            }
            else
            {
               _loc6_ = this.content == _loc5_;
            }
            if(!_loc6_)
            {
               this.touchPointID = -1;
               this.close();
            }
         }
         else
         {
            _loc3_ = param1.getTouch(_loc2_,TouchPhase.BEGAN);
            if(!_loc3_)
            {
               return;
            }
            _loc4_ = Pool.getPoint();
            _loc3_.getLocation(_loc2_,_loc4_);
            _loc5_ = _loc2_.hitTest(_loc4_);
            Pool.putPoint(_loc4_);
            _loc6_ = false;
            if(this.content is DisplayObjectContainer)
            {
               _loc6_ = DisplayObjectContainer(this.content).contains(_loc5_);
            }
            else
            {
               _loc6_ = this.content == _loc5_;
            }
            if(_loc6_)
            {
               return;
            }
            this.touchPointID = _loc3_.id;
         }
      }
   }
}

