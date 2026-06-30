package feathers.core
{
   import feathers.events.FeathersEventType;
   import flash.utils.Dictionary;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.display.Quad;
   import starling.display.Stage;
   import starling.events.Event;
   import starling.events.ResizeEvent;
   
   public class DefaultPopUpManager implements IPopUpManager
   {
      
      protected var _popUps:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
      
      protected var _popUpToOverlay:Dictionary = new Dictionary(true);
      
      protected var _popUpToFocusManager:Dictionary = new Dictionary(true);
      
      protected var _centeredPopUps:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
      
      protected var _overlayFactory:Function = defaultOverlayFactory;
      
      protected var _ignoreRemoval:Boolean = false;
      
      protected var _root:DisplayObjectContainer;
      
      public function DefaultPopUpManager(param1:DisplayObjectContainer = null)
      {
         super();
         this.root = param1;
      }
      
      public static function defaultOverlayFactory() : DisplayObject
      {
         var _loc1_:Quad = new Quad(100,100,0);
         _loc1_.alpha = 0;
         return _loc1_;
      }
      
      public function get popUpCount() : int
      {
         return this._popUps.length;
      }
      
      public function get overlayFactory() : Function
      {
         return this._overlayFactory;
      }
      
      public function set overlayFactory(param1:Function) : void
      {
         this._overlayFactory = param1;
      }
      
      public function get root() : DisplayObjectContainer
      {
         return this._root;
      }
      
      public function set root(param1:DisplayObjectContainer) : void
      {
         var _loc5_:DisplayObject = null;
         var _loc6_:DisplayObject = null;
         if(this._root == param1)
         {
            return;
         }
         var _loc2_:int = int(this._popUps.length);
         var _loc3_:Boolean = this._ignoreRemoval;
         this._ignoreRemoval = true;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = this._popUps[_loc4_];
            _loc6_ = DisplayObject(this._popUpToOverlay[_loc5_]);
            _loc5_.removeFromParent(false);
            if(_loc6_)
            {
               _loc6_.removeFromParent(false);
            }
            _loc4_++;
         }
         this._ignoreRemoval = _loc3_;
         this._root = param1;
         _loc4_ = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = this._popUps[_loc4_];
            _loc6_ = DisplayObject(this._popUpToOverlay[_loc5_]);
            if(_loc6_)
            {
               this._root.addChild(_loc6_);
            }
            this._root.addChild(_loc5_);
            _loc4_++;
         }
      }
      
      public function addPopUp(param1:DisplayObject, param2:Boolean = true, param3:Boolean = true, param4:Function = null) : DisplayObject
      {
         var _loc5_:DisplayObject = null;
         if(param2)
         {
            if(param4 == null)
            {
               param4 = this._overlayFactory;
            }
            if(param4 == null)
            {
               param4 = defaultOverlayFactory;
            }
            _loc5_ = param4();
            _loc5_.width = this._root.stage.stageWidth;
            _loc5_.height = this._root.stage.stageHeight;
            this._root.addChild(_loc5_);
            this._popUpToOverlay[param1] = _loc5_;
         }
         this._popUps.push(param1);
         this._root.addChild(param1);
         param1.addEventListener(Event.REMOVED_FROM_STAGE,this.popUp_removedFromStageHandler);
         if(this._popUps.length == 1)
         {
            this._root.stage.addEventListener(ResizeEvent.RESIZE,this.stage_resizeHandler);
         }
         if(param2 && FocusManager.isEnabledForStage(this._root.stage) && param1 is DisplayObjectContainer)
         {
            this._popUpToFocusManager[param1] = FocusManager.pushFocusManager(DisplayObjectContainer(param1));
         }
         if(param3)
         {
            if(param1 is IFeathersControl)
            {
               param1.addEventListener(FeathersEventType.RESIZE,this.popUp_resizeHandler);
            }
            this._centeredPopUps.push(param1);
            this.centerPopUp(param1);
         }
         return param1;
      }
      
      public function removePopUp(param1:DisplayObject, param2:Boolean = false) : DisplayObject
      {
         var _loc3_:int = this._popUps.indexOf(param1);
         if(_loc3_ < 0)
         {
            throw new ArgumentError("Display object is not a pop-up.");
         }
         param1.removeFromParent(param2);
         return param1;
      }
      
      public function removeAllPopUps(param1:Boolean = false) : void
      {
         var _loc5_:DisplayObject = null;
         var _loc2_:Vector.<DisplayObject> = this._popUps.slice();
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            if(this.isPopUp(_loc5_))
            {
               this.removePopUp(_loc5_,param1);
            }
            _loc4_++;
         }
      }
      
      public function isPopUp(param1:DisplayObject) : Boolean
      {
         return this._popUps.indexOf(param1) >= 0;
      }
      
      public function isTopLevelPopUp(param1:DisplayObject) : Boolean
      {
         var _loc4_:DisplayObject = null;
         var _loc5_:DisplayObject = null;
         var _loc2_:int = this._popUps.length - 1;
         var _loc3_:* = _loc2_;
         while(_loc3_ >= 0)
         {
            _loc4_ = this._popUps[_loc3_];
            if(_loc4_ == param1)
            {
               return true;
            }
            _loc5_ = this._popUpToOverlay[_loc4_] as DisplayObject;
            if(_loc5_)
            {
               return false;
            }
            _loc3_--;
         }
         return false;
      }
      
      public function centerPopUp(param1:DisplayObject) : void
      {
         var _loc2_:Stage = this._root.stage;
         if(param1 is IValidating)
         {
            IValidating(param1).validate();
         }
         param1.x = param1.pivotX + Math.round((_loc2_.stageWidth - param1.width) / 2);
         param1.y = param1.pivotY + Math.round((_loc2_.stageHeight - param1.height) / 2);
      }
      
      protected function popUp_resizeHandler(param1:Event) : void
      {
         var _loc2_:DisplayObject = DisplayObject(param1.currentTarget);
         var _loc3_:int = this._centeredPopUps.indexOf(_loc2_);
         if(_loc3_ < 0)
         {
            return;
         }
         this.centerPopUp(_loc2_);
      }
      
      protected function popUp_removedFromStageHandler(param1:Event) : void
      {
         if(this._ignoreRemoval)
         {
            return;
         }
         var _loc2_:DisplayObject = DisplayObject(param1.currentTarget);
         _loc2_.removeEventListener(Event.REMOVED_FROM_STAGE,this.popUp_removedFromStageHandler);
         var _loc3_:int = this._popUps.indexOf(_loc2_);
         this._popUps.removeAt(_loc3_);
         var _loc4_:DisplayObject = DisplayObject(this._popUpToOverlay[_loc2_]);
         if(_loc4_)
         {
            _loc4_.removeFromParent(true);
            delete this._popUpToOverlay[_loc2_];
         }
         var _loc5_:IFocusManager = this._popUpToFocusManager[_loc2_] as IFocusManager;
         if(_loc5_)
         {
            delete this._popUpToFocusManager[_loc2_];
            FocusManager.removeFocusManager(_loc5_);
         }
         _loc3_ = this._centeredPopUps.indexOf(_loc2_);
         if(_loc3_ >= 0)
         {
            if(_loc2_ is IFeathersControl)
            {
               _loc2_.removeEventListener(FeathersEventType.RESIZE,this.popUp_resizeHandler);
            }
            this._centeredPopUps.removeAt(_loc3_);
         }
         if(this._popUps.length == 0)
         {
            this._root.stage.removeEventListener(ResizeEvent.RESIZE,this.stage_resizeHandler);
         }
      }
      
      protected function stage_resizeHandler(param1:ResizeEvent) : void
      {
         var _loc5_:DisplayObject = null;
         var _loc6_:DisplayObject = null;
         var _loc2_:Stage = this._root.stage;
         var _loc3_:int = int(this._popUps.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this._popUps[_loc4_];
            _loc6_ = DisplayObject(this._popUpToOverlay[_loc5_]);
            if(_loc6_)
            {
               _loc6_.width = _loc2_.stageWidth;
               _loc6_.height = _loc2_.stageHeight;
            }
            _loc4_++;
         }
         _loc3_ = int(this._centeredPopUps.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this._centeredPopUps[_loc4_];
            this.centerPopUp(_loc5_);
            _loc4_++;
         }
      }
   }
}

