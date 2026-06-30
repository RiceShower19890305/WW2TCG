package feathers.controls.popups
{
   import feathers.controls.Button;
   import feathers.controls.Header;
   import feathers.controls.Panel;
   import feathers.core.PopUpManager;
   import feathers.layout.HorizontalAlign;
   import feathers.layout.VerticalLayout;
   import feathers.utils.display.getDisplayObjectDepthFromStage;
   import feathers.utils.geom.matrixToScaleX;
   import feathers.utils.geom.matrixToScaleY;
   import flash.errors.IllegalOperationError;
   import flash.events.KeyboardEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.Stage;
   import starling.events.Event;
   import starling.events.EventDispatcher;
   import starling.events.ResizeEvent;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Pool;
   
   public class BottomDrawerPopUpContentManager extends EventDispatcher implements IPersistentPopUpContentManager, IPopUpContentManagerWithPrompt
   {
      
      protected var panel:Panel;
      
      protected var content:DisplayObject;
      
      protected var isClosing:Boolean = false;
      
      public var panelFactory:Function = null;
      
      public var customPanelStyleName:String = null;
      
      public var closeButtonFactory:Function = null;
      
      public var customCloseButtonStyleName:String = null;
      
      protected var _prompt:String;
      
      protected var _closeButtonLabel:String = "Done";
      
      protected var _openOrCloseDuration:Number = 0.5;
      
      protected var _openOrCloseEase:Object = "easeOut";
      
      protected var _overlayFactory:Function = null;
      
      protected var touchPointID:int = -1;
      
      protected var openTween:Tween;
      
      protected var closeTween:Tween;
      
      public function BottomDrawerPopUpContentManager()
      {
         super();
      }
      
      protected static function defaultPanelFactory() : Panel
      {
         return new Panel();
      }
      
      protected static function defaultCloseButtonFactory() : Button
      {
         return new Button();
      }
      
      public function get isOpen() : Boolean
      {
         return this.content !== null;
      }
      
      public function get prompt() : String
      {
         return this._prompt;
      }
      
      public function set prompt(param1:String) : void
      {
         this._prompt = param1;
      }
      
      public function get closeButtonLabel() : String
      {
         return this._closeButtonLabel;
      }
      
      public function set closeButtonLabel(param1:String) : void
      {
         this._closeButtonLabel = param1;
      }
      
      public function get openOrCloseDuration() : Number
      {
         return this._openOrCloseDuration;
      }
      
      public function set openOrCloseDuration(param1:Number) : void
      {
         this._openOrCloseDuration = param1;
      }
      
      public function get openOrCloseEase() : Object
      {
         return this._openOrCloseEase;
      }
      
      public function set openOrCloseEase(param1:Object) : void
      {
         this._openOrCloseEase = param1;
      }
      
      public function get overlayFactory() : Function
      {
         return this._overlayFactory;
      }
      
      public function set overlayFactory(param1:Function) : void
      {
         this._overlayFactory = param1;
      }
      
      public function open(param1:DisplayObject, param2:DisplayObject) : void
      {
         var _loc5_:Matrix = null;
         if(this.isOpen)
         {
            throw new IllegalOperationError("Pop-up content is already open. Close the previous content before opening new content.");
         }
         this.content = param1;
         var _loc3_:VerticalLayout = new VerticalLayout();
         _loc3_.horizontalAlign = HorizontalAlign.JUSTIFY;
         var _loc4_:Function = this.panelFactory !== null ? this.panelFactory : defaultPanelFactory;
         this.panel = Panel(_loc4_());
         if(this.customPanelStyleName)
         {
            this.panel.styleNameList.add(this.customPanelStyleName);
         }
         this.panel.title = this._prompt;
         this.panel.layout = _loc3_;
         this.panel.headerFactory = this.headerFactory;
         this.panel.touchable = false;
         this.panel.addChild(param1);
         _loc5_ = Pool.getMatrix();
         param2.getTransformationMatrix(PopUpManager.root,_loc5_);
         this.panel.scaleX = matrixToScaleX(_loc5_);
         this.panel.scaleY = matrixToScaleY(_loc5_);
         Pool.putMatrix(_loc5_);
         PopUpManager.addPopUp(this.panel,true,false,this._overlayFactory);
         this.layout();
         this.panel.addEventListener(Event.REMOVED_FROM_STAGE,this.panel_removedFromStageHandler);
         var _loc6_:Stage = Starling.current.stage;
         _loc6_.addEventListener(TouchEvent.TOUCH,this.stage_touchHandler);
         _loc6_.addEventListener(ResizeEvent.RESIZE,this.stage_resizeHandler);
         var _loc7_:int = -getDisplayObjectDepthFromStage(this.panel);
         Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN,this.nativeStage_keyDownHandler,false,_loc7_,true);
         this.panel.y = this.panel.stage.stageHeight;
         this.openTween = new Tween(this.panel,this.openOrCloseDuration,this.openOrCloseEase);
         this.openTween.moveTo(0,this.panel.stage.stageHeight - this.panel.height);
         this.openTween.onComplete = this.openTween_onComplete;
         Starling.juggler.add(this.openTween);
      }
      
      public function close() : void
      {
         if(!this.isOpen || this.isClosing)
         {
            return;
         }
         if(this.openTween)
         {
            Starling.juggler.remove(this.openTween);
            this.openTween = null;
         }
         if(this.content.stage)
         {
            this.isClosing = true;
            this.panel.touchable = false;
            this.closeTween = new Tween(this.panel,this.openOrCloseDuration,this.openOrCloseEase);
            this.closeTween.moveTo(0,this.panel.stage.stageHeight);
            this.closeTween.onComplete = this.closeTween_onComplete;
            Starling.juggler.add(this.closeTween);
         }
         else
         {
            this.cleanup();
            this.dispatchEventWith(Event.CLOSE);
         }
      }
      
      public function dispose() : void
      {
         this.close();
      }
      
      protected function headerFactory() : Header
      {
         var _loc1_:Header = new Header();
         var _loc2_:Function = this.closeButtonFactory !== null ? this.closeButtonFactory : defaultCloseButtonFactory;
         var _loc3_:Button = Button(_loc2_());
         if(this.customCloseButtonStyleName !== null)
         {
            _loc3_.styleNameList.add(this.customCloseButtonStyleName);
         }
         _loc3_.label = this.closeButtonLabel;
         _loc3_.addEventListener(Event.TRIGGERED,this.closeButton_triggeredHandler);
         _loc1_.rightItems = new <DisplayObject>[_loc3_];
         return _loc1_;
      }
      
      protected function layout() : void
      {
         this.panel.width = this.panel.stage.stageWidth;
         this.panel.x = 0;
         this.panel.maxHeight = this.panel.stage.stageHeight;
         this.panel.validate();
         this.panel.y = this.panel.stage.stageHeight - this.panel.height;
      }
      
      protected function cleanup() : void
      {
         var _loc1_:Stage = Starling.current.stage;
         _loc1_.removeEventListener(TouchEvent.TOUCH,this.stage_touchHandler);
         _loc1_.removeEventListener(ResizeEvent.RESIZE,this.stage_resizeHandler);
         Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN,this.nativeStage_keyDownHandler);
         if(this.panel)
         {
            this.panel.removeEventListener(Event.REMOVED_FROM_STAGE,this.panel_removedFromStageHandler);
            if(this.panel.contains(this.content))
            {
               this.panel.removeChild(this.content,false);
            }
            this.panel.removeFromParent(true);
            this.panel = null;
         }
         this.content = null;
      }
      
      protected function openTween_onComplete() : void
      {
         this.openTween = null;
         this.panel.touchable = true;
         this.dispatchEventWith(Event.OPEN);
      }
      
      protected function closeTween_onComplete() : void
      {
         this.isClosing = false;
         this.closeTween = null;
         this.cleanup();
         this.dispatchEventWith(Event.CLOSE);
      }
      
      protected function closeButton_triggeredHandler(param1:Event) : void
      {
         this.close();
      }
      
      protected function panel_removedFromStageHandler(param1:Event) : void
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
         if(this.closeTween)
         {
            this.closeTween.advanceTime(this.closeTween.totalTime);
            return;
         }
         if(this.openTween)
         {
            Starling.juggler.remove(this.openTween);
            this.openTween = null;
         }
         this.layout();
      }
      
      protected function stage_touchHandler(param1:TouchEvent) : void
      {
         var _loc3_:Touch = null;
         var _loc4_:Point = null;
         var _loc5_:DisplayObject = null;
         if(!PopUpManager.isTopLevelPopUp(this.panel))
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
            if(!this.panel.contains(_loc5_))
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
            if(this.panel.contains(_loc5_))
            {
               return;
            }
            this.touchPointID = _loc3_.id;
         }
      }
   }
}

