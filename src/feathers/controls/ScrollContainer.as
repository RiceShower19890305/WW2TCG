package feathers.controls
{
   import feathers.controls.supportClasses.LayoutViewPort;
   import feathers.core.IFeathersControl;
   import feathers.core.IFocusContainer;
   import feathers.events.FeathersEventType;
   import feathers.layout.ILayout;
   import feathers.layout.ILayoutDisplayObject;
   import feathers.layout.IVirtualLayout;
   import feathers.skins.IStyleProvider;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.events.Event;
   
   public class ScrollContainer extends Scroller implements IScrollContainer, IFocusContainer
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      public static const ALTERNATE_STYLE_NAME_TOOLBAR:String = "feathers-toolbar-scroll-container";
      
      protected var displayListBypassEnabled:Boolean = true;
      
      protected var layoutViewPort:LayoutViewPort;
      
      protected var _isChildFocusEnabled:Boolean = true;
      
      protected var _layout:ILayout;
      
      protected var _autoSizeMode:String = "content";
      
      protected var _ignoreChildChanges:Boolean = false;
      
      protected var _ignoreChildChangesButSetFlags:Boolean = false;
      
      public function ScrollContainer()
      {
         super();
         this.layoutViewPort = new LayoutViewPort();
         this.viewPort = this.layoutViewPort;
         this.addEventListener(Event.ADDED_TO_STAGE,this.scrollContainer_addedToStageHandler);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.scrollContainer_removedFromStageHandler);
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return ScrollContainer.globalStyleProvider;
      }
      
      public function get isChildFocusEnabled() : Boolean
      {
         return this._isEnabled && this._isChildFocusEnabled;
      }
      
      public function set isChildFocusEnabled(param1:Boolean) : void
      {
         this._isChildFocusEnabled = param1;
      }
      
      public function get layout() : ILayout
      {
         return this._layout;
      }
      
      public function set layout(param1:ILayout) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._layout === param1)
         {
            return;
         }
         this._layout = param1;
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
      }
      
      public function get autoSizeMode() : String
      {
         return this._autoSizeMode;
      }
      
      public function set autoSizeMode(param1:String) : void
      {
         if(this._autoSizeMode == param1)
         {
            return;
         }
         this._autoSizeMode = param1;
         this._measureViewPort = this._autoSizeMode != AutoSizeMode.STAGE;
         if(this.stage !== null)
         {
            if(this._autoSizeMode === AutoSizeMode.STAGE)
            {
               this.stage.addEventListener(Event.RESIZE,this.scrollContainer_stage_resizeHandler);
            }
            else
            {
               this.stage.removeEventListener(Event.RESIZE,this.scrollContainer_stage_resizeHandler);
            }
         }
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
      
      override public function get numChildren() : int
      {
         if(!this.displayListBypassEnabled)
         {
            return super.numChildren;
         }
         return DisplayObjectContainer(this.viewPort).numChildren;
      }
      
      public function get numRawChildren() : int
      {
         var _loc1_:Boolean = this.displayListBypassEnabled;
         this.displayListBypassEnabled = false;
         var _loc2_:int = super.numChildren;
         this.displayListBypassEnabled = _loc1_;
         return _loc2_;
      }
      
      override public function getChildByName(param1:String) : DisplayObject
      {
         if(!this.displayListBypassEnabled)
         {
            return super.getChildByName(param1);
         }
         return DisplayObjectContainer(this.viewPort).getChildByName(param1);
      }
      
      public function getRawChildByName(param1:String) : DisplayObject
      {
         var _loc2_:Boolean = this.displayListBypassEnabled;
         this.displayListBypassEnabled = false;
         var _loc3_:DisplayObject = super.getChildByName(param1);
         this.displayListBypassEnabled = _loc2_;
         return _loc3_;
      }
      
      override public function getChildAt(param1:int) : DisplayObject
      {
         if(!this.displayListBypassEnabled)
         {
            return super.getChildAt(param1);
         }
         return DisplayObjectContainer(this.viewPort).getChildAt(param1);
      }
      
      public function getRawChildAt(param1:int) : DisplayObject
      {
         var _loc2_:Boolean = this.displayListBypassEnabled;
         this.displayListBypassEnabled = false;
         var _loc3_:DisplayObject = super.getChildAt(param1);
         this.displayListBypassEnabled = _loc2_;
         return _loc3_;
      }
      
      public function addRawChild(param1:DisplayObject) : DisplayObject
      {
         var _loc2_:Boolean = this.displayListBypassEnabled;
         this.displayListBypassEnabled = false;
         if(param1.parent == this)
         {
            super.setChildIndex(param1,super.numChildren);
         }
         else
         {
            param1 = super.addChildAt(param1,super.numChildren);
         }
         this.displayListBypassEnabled = _loc2_;
         return param1;
      }
      
      override public function addChild(param1:DisplayObject) : DisplayObject
      {
         return this.addChildAt(param1,this.numChildren);
      }
      
      override public function addChildAt(param1:DisplayObject, param2:int) : DisplayObject
      {
         if(!this.displayListBypassEnabled)
         {
            return super.addChildAt(param1,param2);
         }
         var _loc3_:DisplayObject = DisplayObjectContainer(this.viewPort).addChildAt(param1,param2);
         if(_loc3_ is IFeathersControl)
         {
            _loc3_.addEventListener(Event.RESIZE,this.child_resizeHandler);
         }
         if(_loc3_ is ILayoutDisplayObject)
         {
            _loc3_.addEventListener(FeathersEventType.LAYOUT_DATA_CHANGE,this.child_layoutDataChangeHandler);
         }
         this.invalidate(INVALIDATION_FLAG_SIZE);
         return _loc3_;
      }
      
      public function addRawChildAt(param1:DisplayObject, param2:int) : DisplayObject
      {
         var _loc3_:Boolean = this.displayListBypassEnabled;
         this.displayListBypassEnabled = false;
         param1 = super.addChildAt(param1,param2);
         this.displayListBypassEnabled = _loc3_;
         return param1;
      }
      
      public function removeRawChild(param1:DisplayObject, param2:Boolean = false) : DisplayObject
      {
         var _loc3_:Boolean = this.displayListBypassEnabled;
         this.displayListBypassEnabled = false;
         var _loc4_:int = super.getChildIndex(param1);
         if(_loc4_ >= 0)
         {
            super.removeChildAt(_loc4_,param2);
         }
         this.displayListBypassEnabled = _loc3_;
         return param1;
      }
      
      override public function removeChildAt(param1:int, param2:Boolean = false) : DisplayObject
      {
         if(!this.displayListBypassEnabled)
         {
            return super.removeChildAt(param1,param2);
         }
         var _loc3_:DisplayObject = DisplayObjectContainer(this.viewPort).removeChildAt(param1,param2);
         if(_loc3_ is IFeathersControl)
         {
            _loc3_.removeEventListener(Event.RESIZE,this.child_resizeHandler);
         }
         if(_loc3_ is ILayoutDisplayObject)
         {
            _loc3_.removeEventListener(FeathersEventType.LAYOUT_DATA_CHANGE,this.child_layoutDataChangeHandler);
         }
         this.invalidate(INVALIDATION_FLAG_SIZE);
         return _loc3_;
      }
      
      public function removeRawChildAt(param1:int, param2:Boolean = false) : DisplayObject
      {
         var _loc3_:Boolean = this.displayListBypassEnabled;
         this.displayListBypassEnabled = false;
         var _loc4_:DisplayObject = super.removeChildAt(param1,param2);
         this.displayListBypassEnabled = _loc3_;
         return _loc4_;
      }
      
      override public function getChildIndex(param1:DisplayObject) : int
      {
         if(!this.displayListBypassEnabled)
         {
            return super.getChildIndex(param1);
         }
         return DisplayObjectContainer(this.viewPort).getChildIndex(param1);
      }
      
      public function getRawChildIndex(param1:DisplayObject) : int
      {
         var _loc2_:Boolean = this.displayListBypassEnabled;
         this.displayListBypassEnabled = false;
         var _loc3_:int = super.getChildIndex(param1);
         this.displayListBypassEnabled = _loc2_;
         return _loc3_;
      }
      
      override public function setChildIndex(param1:DisplayObject, param2:int) : void
      {
         if(!this.displayListBypassEnabled)
         {
            super.setChildIndex(param1,param2);
            return;
         }
         DisplayObjectContainer(this.viewPort).setChildIndex(param1,param2);
      }
      
      public function setRawChildIndex(param1:DisplayObject, param2:int) : void
      {
         var _loc3_:Boolean = this.displayListBypassEnabled;
         this.displayListBypassEnabled = false;
         super.setChildIndex(param1,param2);
         this.displayListBypassEnabled = _loc3_;
      }
      
      public function swapRawChildren(param1:DisplayObject, param2:DisplayObject) : void
      {
         var _loc3_:int = this.getRawChildIndex(param1);
         var _loc4_:int = this.getRawChildIndex(param2);
         if(_loc3_ < 0 || _loc4_ < 0)
         {
            throw new ArgumentError("Not a child of this container");
         }
         var _loc5_:Boolean = this.displayListBypassEnabled;
         this.displayListBypassEnabled = false;
         this.swapRawChildrenAt(_loc3_,_loc4_);
         this.displayListBypassEnabled = _loc5_;
      }
      
      override public function swapChildrenAt(param1:int, param2:int) : void
      {
         if(!this.displayListBypassEnabled)
         {
            super.swapChildrenAt(param1,param2);
            return;
         }
         DisplayObjectContainer(this.viewPort).swapChildrenAt(param1,param2);
      }
      
      public function swapRawChildrenAt(param1:int, param2:int) : void
      {
         var _loc3_:Boolean = this.displayListBypassEnabled;
         this.displayListBypassEnabled = false;
         super.swapChildrenAt(param1,param2);
         this.displayListBypassEnabled = _loc3_;
      }
      
      override public function sortChildren(param1:Function) : void
      {
         if(!this.displayListBypassEnabled)
         {
            super.sortChildren(param1);
            return;
         }
         DisplayObjectContainer(this.viewPort).sortChildren(param1);
      }
      
      public function sortRawChildren(param1:Function) : void
      {
         var _loc2_:Boolean = this.displayListBypassEnabled;
         this.displayListBypassEnabled = false;
         super.sortChildren(param1);
         this.displayListBypassEnabled = _loc2_;
      }
      
      public function readjustLayout() : void
      {
         this.layoutViewPort.readjustLayout();
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
      
      override public function validate() : void
      {
         var _loc1_:Boolean = this._ignoreChildChangesButSetFlags;
         this._ignoreChildChangesButSetFlags = true;
         super.validate();
         this._ignoreChildChangesButSetFlags = _loc1_;
      }
      
      override protected function initialize() : void
      {
         if(this.stage !== null)
         {
            if(this.stage.starling.root === this)
            {
               this.autoSizeMode = AutoSizeMode.STAGE;
            }
         }
         super.initialize();
      }
      
      override protected function draw() : void
      {
         this._ignoreChildChangesButSetFlags = false;
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_LAYOUT);
         if(_loc1_)
         {
            if(this._layout is IVirtualLayout)
            {
               IVirtualLayout(this._layout).useVirtualLayout = false;
            }
            this.layoutViewPort.layout = this._layout;
         }
         var _loc2_:Boolean = this._ignoreChildChanges;
         this._ignoreChildChanges = true;
         super.draw();
         this._ignoreChildChanges = _loc2_;
      }
      
      override protected function autoSizeIfNeeded() : Boolean
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc1_:Boolean = this._explicitWidth !== this._explicitWidth;
         var _loc2_:Boolean = this._explicitHeight !== this._explicitHeight;
         var _loc3_:Boolean = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc4_:Boolean = this._explicitMinHeight !== this._explicitMinHeight;
         if(!_loc1_ && !_loc2_ && !_loc3_ && !_loc4_)
         {
            return false;
         }
         if(this._autoSizeMode === AutoSizeMode.STAGE && this.stage !== null)
         {
            _loc5_ = this.stage.stageWidth;
            _loc6_ = this.stage.stageHeight;
            return this.saveMeasurements(_loc5_,_loc6_,_loc5_,_loc6_);
         }
         return super.autoSizeIfNeeded();
      }
      
      protected function scrollContainer_addedToStageHandler(param1:Event) : void
      {
         if(this._autoSizeMode === AutoSizeMode.STAGE)
         {
            this.invalidate(INVALIDATION_FLAG_SIZE);
            this.stage.addEventListener(Event.RESIZE,this.scrollContainer_stage_resizeHandler);
         }
      }
      
      protected function scrollContainer_removedFromStageHandler(param1:Event) : void
      {
         this.stage.removeEventListener(Event.RESIZE,this.scrollContainer_stage_resizeHandler);
      }
      
      protected function child_resizeHandler(param1:Event) : void
      {
         if(this._ignoreChildChanges)
         {
            return;
         }
         if(this._ignoreChildChangesButSetFlags)
         {
            this.setInvalidationFlag(INVALIDATION_FLAG_SIZE);
            return;
         }
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
      
      protected function child_layoutDataChangeHandler(param1:Event) : void
      {
         if(this._ignoreChildChanges)
         {
            return;
         }
         if(this._ignoreChildChangesButSetFlags)
         {
            this.setInvalidationFlag(INVALIDATION_FLAG_SIZE);
            return;
         }
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
      
      protected function scrollContainer_stage_resizeHandler(param1:Event) : void
      {
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
   }
}

