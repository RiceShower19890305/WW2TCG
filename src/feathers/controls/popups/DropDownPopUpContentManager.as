package feathers.controls.popups
{
   import feathers.core.IFeathersControl;
   import feathers.core.IValidating;
   import feathers.core.PopUpManager;
   import feathers.core.ValidationQueue;
   import feathers.display.RenderDelegate;
   import feathers.events.FeathersEventType;
   import feathers.layout.RelativePosition;
   import feathers.utils.display.getDisplayObjectDepthFromStage;
   import feathers.utils.geom.matrixToScaleX;
   import feathers.utils.geom.matrixToScaleY;
   import flash.errors.IllegalOperationError;
   import flash.events.KeyboardEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.display.Quad;
   import starling.display.Stage;
   import starling.events.Event;
   import starling.events.EventDispatcher;
   import starling.events.ResizeEvent;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Pool;
   
   public class DropDownPopUpContentManager extends EventDispatcher implements IPopUpContentManager
   {
      
      protected var content:DisplayObject;
      
      protected var source:DisplayObject;
      
      protected var _delegate:RenderDelegate;
      
      protected var _openCloseTweenTarget:DisplayObject;
      
      protected var _openCloseTween:Tween;
      
      protected var _isModal:Boolean = false;
      
      protected var _overlayFactory:Function;
      
      protected var _gap:Number = 0;
      
      protected var _openCloseDuration:Number = 0.2;
      
      protected var _openCloseEase:Object = "easeOut";
      
      protected var _actualDirection:String;
      
      protected var _primaryDirection:String = "bottom";
      
      protected var _fitContentMinWidthToOrigin:Boolean = true;
      
      protected var _lastOriginX:Number;
      
      protected var _lastOriginY:Number;
      
      public function DropDownPopUpContentManager()
      {
         super();
      }
      
      public function get isOpen() : Boolean
      {
         return this.content !== null;
      }
      
      public function get isModal() : Boolean
      {
         return this._isModal;
      }
      
      public function set isModal(param1:Boolean) : void
      {
         this._isModal = param1;
      }
      
      public function get overlayFactory() : Function
      {
         return this._overlayFactory;
      }
      
      public function set overlayFactory(param1:Function) : void
      {
         this._overlayFactory = param1;
      }
      
      public function get gap() : Number
      {
         return this._gap;
      }
      
      public function set gap(param1:Number) : void
      {
         this._gap = param1;
      }
      
      public function get openCloseDuration() : Number
      {
         return this._openCloseDuration;
      }
      
      public function set openCloseDuration(param1:Number) : void
      {
         this._openCloseDuration = param1;
      }
      
      public function get openCloseEase() : Object
      {
         return this._openCloseEase;
      }
      
      public function set openCloseEase(param1:Object) : void
      {
         this._openCloseEase = param1;
      }
      
      public function get primaryDirection() : String
      {
         return this._primaryDirection;
      }
      
      public function set primaryDirection(param1:String) : void
      {
         switch(param1)
         {
            case "up":
               param1 = RelativePosition.TOP;
               break;
            case "down":
               param1 = RelativePosition.BOTTOM;
         }
         this._primaryDirection = param1;
      }
      
      public function get fitContentMinWidthToOrigin() : Boolean
      {
         return this._fitContentMinWidthToOrigin;
      }
      
      public function set fitContentMinWidthToOrigin(param1:Boolean) : void
      {
         this._fitContentMinWidthToOrigin = param1;
      }
      
      public function open(param1:DisplayObject, param2:DisplayObject) : void
      {
         var _loc6_:Quad = null;
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
         this.source = param2;
         PopUpManager.addPopUp(param1,this._isModal,false,this._overlayFactory);
         if(param1 is IFeathersControl)
         {
            param1.addEventListener(FeathersEventType.RESIZE,this.content_resizeHandler);
         }
         param1.addEventListener(Event.REMOVED_FROM_STAGE,this.content_removedFromStageHandler);
         this.layout();
         if(this._openCloseTween !== null)
         {
            this._openCloseTween.advanceTime(this._openCloseTween.totalTime);
         }
         if(this._openCloseDuration > 0)
         {
            this._delegate = new RenderDelegate(param1);
            this._delegate.scaleX = param1.scaleX;
            this._delegate.scaleY = param1.scaleY;
            param1.visible = false;
            PopUpManager.addPopUp(this._delegate,false,false);
            this._delegate.x = param1.x;
            if(this._actualDirection === RelativePosition.TOP)
            {
               this._delegate.y = param1.y + param1.height;
            }
            else
            {
               this._delegate.y = param1.y - param1.height;
            }
            _loc6_ = new Quad(1,1,16711935);
            _loc6_.width = param1.width / param1.scaleX;
            _loc6_.height = 0;
            this._delegate.mask = _loc6_;
            _loc6_.height = 0;
            this._openCloseTween = new Tween(this._delegate,this._openCloseDuration,this._openCloseEase);
            this._openCloseTweenTarget = param1;
            this._openCloseTween.animate("y",param1.y);
            this._openCloseTween.onUpdate = this.openCloseTween_onUpdate;
            this._openCloseTween.onComplete = this.openTween_onComplete;
            Starling.juggler.add(this._openCloseTween);
         }
         var _loc4_:Stage = this.source.stage;
         _loc4_.addEventListener(TouchEvent.TOUCH,this.stage_touchHandler);
         _loc4_.addEventListener(ResizeEvent.RESIZE,this.stage_resizeHandler);
         _loc4_.addEventListener(Event.ENTER_FRAME,this.stage_enterFrameHandler);
         var _loc5_:int = -getDisplayObjectDepthFromStage(this.content);
         Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN,this.nativeStage_keyDownHandler,false,_loc5_,true);
         this.dispatchEventWith(Event.OPEN);
      }
      
      public function close() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc3_:Quad = null;
         if(!this.isOpen)
         {
            return;
         }
         if(this._openCloseTween !== null)
         {
            this._openCloseTween.advanceTime(this._openCloseTween.totalTime);
         }
         _loc1_ = this.content;
         this.source = null;
         this.content = null;
         var _loc2_:Stage = _loc1_.stage;
         _loc2_.removeEventListener(TouchEvent.TOUCH,this.stage_touchHandler);
         _loc2_.removeEventListener(ResizeEvent.RESIZE,this.stage_resizeHandler);
         _loc2_.removeEventListener(Event.ENTER_FRAME,this.stage_enterFrameHandler);
         _loc2_.starling.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN,this.nativeStage_keyDownHandler);
         if(_loc1_ is IFeathersControl)
         {
            _loc1_.removeEventListener(FeathersEventType.RESIZE,this.content_resizeHandler);
         }
         _loc1_.removeEventListener(Event.REMOVED_FROM_STAGE,this.content_removedFromStageHandler);
         if(_loc1_.parent)
         {
            _loc1_.removeFromParent(false);
         }
         if(this._openCloseDuration > 0)
         {
            this._delegate = new RenderDelegate(_loc1_);
            this._delegate.scaleX = _loc1_.scaleX;
            this._delegate.scaleY = _loc1_.scaleY;
            PopUpManager.addPopUp(this._delegate,false,false);
            this._delegate.x = _loc1_.x;
            this._delegate.y = _loc1_.y;
            _loc3_ = new Quad(1,1,16711935);
            _loc3_.width = _loc1_.width / _loc1_.scaleX;
            _loc3_.height = _loc1_.height / _loc1_.scaleY;
            this._delegate.mask = _loc3_;
            this._openCloseTween = new Tween(this._delegate,this._openCloseDuration,this._openCloseEase);
            this._openCloseTweenTarget = _loc1_;
            if(this._actualDirection === RelativePosition.TOP)
            {
               this._openCloseTween.animate("y",_loc1_.y + _loc1_.height);
            }
            else
            {
               this._openCloseTween.animate("y",_loc1_.y - _loc1_.height);
            }
            this._openCloseTween.onUpdate = this.openCloseTween_onUpdate;
            this._openCloseTween.onComplete = this.closeTween_onComplete;
            Starling.juggler.add(this._openCloseTween);
         }
         else
         {
            this.dispatchEventWith(Event.CLOSE);
         }
      }
      
      public function dispose() : void
      {
         this.openCloseDuration = 0;
         this.close();
      }
      
      protected function layout() : void
      {
         if(this.source is IValidating)
         {
            IValidating(this.source).validate();
            if(!this.isOpen)
            {
               return;
            }
         }
         var _loc1_:Rectangle = this.source.getBounds(PopUpManager.root);
         var _loc2_:Number = _loc1_.width;
         var _loc3_:Boolean = false;
         var _loc4_:IFeathersControl = this.content as IFeathersControl;
         if(Boolean(this._fitContentMinWidthToOrigin) && Boolean(_loc4_) && _loc4_.minWidth < _loc2_)
         {
            _loc4_.minWidth = _loc2_;
            _loc3_ = true;
         }
         if(this.content is IValidating)
         {
            _loc4_.validate();
         }
         if(!_loc3_ && this._fitContentMinWidthToOrigin && this.content.width < _loc2_)
         {
            this.content.width = _loc2_;
         }
         var _loc5_:Stage = this.source.stage;
         var _loc6_:ValidationQueue = ValidationQueue.forStarling(_loc5_.starling);
         if((Boolean(_loc6_)) && !_loc6_.isValidating)
         {
            _loc6_.advanceTime(0);
         }
         _loc1_ = this.source.getBounds(PopUpManager.root);
         this._lastOriginX = _loc1_.x;
         this._lastOriginY = _loc1_.y;
         var _loc7_:Point = new Point(_loc5_.stageWidth,_loc5_.stageHeight);
         PopUpManager.root.globalToLocal(_loc7_,_loc7_);
         var _loc8_:Number = _loc7_.y - this.content.height - (_loc1_.y + _loc1_.height + this._gap);
         if(this._primaryDirection == RelativePosition.BOTTOM && _loc8_ >= 0)
         {
            this.layoutBelow(_loc1_,_loc7_);
            return;
         }
         var _loc9_:Number = _loc1_.y - this._gap - this.content.height;
         if(_loc9_ >= 0)
         {
            this.layoutAbove(_loc1_,_loc7_);
            return;
         }
         if(this._primaryDirection == RelativePosition.TOP && _loc8_ >= 0)
         {
            this.layoutBelow(_loc1_,_loc7_);
            return;
         }
         if(_loc9_ >= _loc8_)
         {
            this.layoutAbove(_loc1_,_loc7_);
         }
         else
         {
            this.layoutBelow(_loc1_,_loc7_);
         }
         var _loc10_:Number = _loc7_.y - (_loc1_.y + _loc1_.height);
         if(_loc4_)
         {
            if(_loc4_.maxHeight > _loc10_)
            {
               _loc4_.maxHeight = _loc10_;
            }
         }
         else if(this.content.height > _loc10_)
         {
            this.content.height = _loc10_;
         }
      }
      
      protected function layoutAbove(param1:Rectangle, param2:Point) : void
      {
         this._actualDirection = RelativePosition.TOP;
         this.content.x = this.calculateXPosition(param1,param2);
         this.content.y = param1.y - this.content.height - this._gap;
      }
      
      protected function layoutBelow(param1:Rectangle, param2:Point) : void
      {
         this._actualDirection = RelativePosition.BOTTOM;
         this.content.x = this.calculateXPosition(param1,param2);
         this.content.y = param1.y + param1.height + this._gap;
      }
      
      protected function calculateXPosition(param1:Rectangle, param2:Point) : Number
      {
         var _loc3_:Number = param1.x;
         var _loc4_:Number = _loc3_ + param1.width - this.content.width;
         var _loc5_:Number = param2.x - this.content.width;
         var _loc6_:Number = _loc3_;
         if(_loc6_ > _loc5_)
         {
            if(_loc4_ >= 0)
            {
               _loc6_ = _loc4_;
            }
            else
            {
               _loc6_ = _loc5_;
            }
         }
         if(_loc6_ < 0)
         {
            _loc6_ = 0;
         }
         return _loc6_;
      }
      
      protected function openCloseTween_onUpdate() : void
      {
         var _loc1_:DisplayObject = this._delegate.mask;
         if(this._actualDirection === RelativePosition.TOP)
         {
            _loc1_.height = (this._openCloseTweenTarget.height - (this._delegate.y - this._openCloseTweenTarget.y)) / this._openCloseTweenTarget.scaleY;
            _loc1_.y = 0;
         }
         else
         {
            _loc1_.height = (this._openCloseTweenTarget.height - (this._openCloseTweenTarget.y - this._delegate.y)) / this._openCloseTweenTarget.scaleY;
            _loc1_.y = this._openCloseTweenTarget.height / this._openCloseTweenTarget.scaleY - _loc1_.height;
         }
      }
      
      protected function openCloseTween_onComplete() : void
      {
         this._openCloseTween = null;
         this._delegate.removeFromParent(true);
         this._delegate = null;
      }
      
      protected function openTween_onComplete() : void
      {
         this.openCloseTween_onComplete();
         this.content.visible = true;
      }
      
      protected function closeTween_onComplete() : void
      {
         this.openCloseTween_onComplete();
         this.dispatchEventWith(Event.CLOSE);
      }
      
      protected function content_resizeHandler(param1:Event) : void
      {
         this.layout();
      }
      
      protected function stage_enterFrameHandler(param1:Event) : void
      {
         var _loc2_:Rectangle = Pool.getRectangle();
         this.source.getBounds(PopUpManager.root,_loc2_);
         var _loc3_:Number = _loc2_.x;
         var _loc4_:Number = _loc2_.y;
         Pool.putRectangle(_loc2_);
         if(_loc4_ != this._lastOriginX || _loc4_ != this._lastOriginY)
         {
            this.layout();
         }
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
         var _loc2_:DisplayObject = DisplayObject(param1.target);
         if(this.content == _loc2_ || this.content is DisplayObjectContainer && DisplayObjectContainer(this.content).contains(_loc2_))
         {
            return;
         }
         if(this.source == _loc2_ || this.source is DisplayObjectContainer && DisplayObjectContainer(this.source).contains(_loc2_))
         {
            return;
         }
         if(!PopUpManager.isTopLevelPopUp(this.content))
         {
            return;
         }
         var _loc3_:Stage = Stage(param1.currentTarget);
         var _loc4_:Touch = param1.getTouch(_loc3_,TouchPhase.BEGAN);
         if(!_loc4_)
         {
            return;
         }
         this.close();
      }
   }
}

