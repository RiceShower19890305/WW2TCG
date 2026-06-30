package feathers.controls
{
   import feathers.controls.renderers.DefaultTreeItemRenderer;
   import feathers.controls.renderers.ITreeItemRenderer;
   import feathers.controls.supportClasses.TreeDataViewPort;
   import feathers.data.ArrayCollection;
   import feathers.data.IHierarchicalCollection;
   import feathers.events.CollectionEventType;
   import feathers.layout.HorizontalAlign;
   import feathers.layout.ILayout;
   import feathers.layout.IVariableVirtualLayout;
   import feathers.layout.VerticalAlign;
   import feathers.layout.VerticalLayout;
   import feathers.skins.IStyleProvider;
   import feathers.system.DeviceCapabilities;
   import flash.events.KeyboardEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import starling.events.Event;
   import starling.utils.Pool;
   
   public class Tree extends Scroller
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      protected var dataViewPort:TreeDataViewPort;
      
      protected var _dataProvider:IHierarchicalCollection = null;
      
      protected var _isSelectable:Boolean = true;
      
      protected var _helperLocation:Vector.<int> = new Vector.<int>(0);
      
      protected var _selectedItem:Object = null;
      
      protected var _layout:ILayout;
      
      protected var _itemRendererType:Class = DefaultTreeItemRenderer;
      
      protected var _itemRendererFactories:Object;
      
      protected var _itemRendererFactory:Function;
      
      protected var _factoryIDFunction:Function;
      
      protected var _typicalItem:Object = null;
      
      protected var _customItemRendererStyleName:String;
      
      protected var _keyScrollDuration:Number = 0.25;
      
      protected var pendingLocation:Vector.<int> = null;
      
      protected var _openBranches:ArrayCollection = new ArrayCollection();
      
      public function Tree()
      {
         super();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return Tree.globalStyleProvider;
      }
      
      override public function get isFocusEnabled() : Boolean
      {
         return (this._isSelectable || this._minHorizontalScrollPosition != this._maxHorizontalScrollPosition || this._minVerticalScrollPosition != this._maxVerticalScrollPosition) && this._isEnabled && this._isFocusEnabled;
      }
      
      public function get dataProvider() : IHierarchicalCollection
      {
         return this._dataProvider;
      }
      
      public function set dataProvider(param1:IHierarchicalCollection) : void
      {
         if(this._dataProvider === param1)
         {
            return;
         }
         if(this._dataProvider !== null)
         {
            this._dataProvider.removeEventListener(CollectionEventType.REMOVE_ITEM,this.dataProvider_removeItemHandler);
            this._dataProvider.removeEventListener(CollectionEventType.REMOVE_ALL,this.dataProvider_removeAllHandler);
            this._dataProvider.removeEventListener(CollectionEventType.REPLACE_ITEM,this.dataProvider_replaceItemHandler);
            this._dataProvider.removeEventListener(CollectionEventType.RESET,this.dataProvider_resetHandler);
            this._dataProvider.removeEventListener(Event.CHANGE,this.dataProvider_changeHandler);
         }
         this._dataProvider = param1;
         if(this._dataProvider !== null)
         {
            this._dataProvider.addEventListener(CollectionEventType.REMOVE_ITEM,this.dataProvider_removeItemHandler);
            this._dataProvider.addEventListener(CollectionEventType.REMOVE_ALL,this.dataProvider_removeAllHandler);
            this._dataProvider.addEventListener(CollectionEventType.REPLACE_ITEM,this.dataProvider_replaceItemHandler);
            this._dataProvider.addEventListener(CollectionEventType.RESET,this.dataProvider_resetHandler);
            this._dataProvider.addEventListener(Event.CHANGE,this.dataProvider_changeHandler);
         }
         this.horizontalScrollPosition = 0;
         this.verticalScrollPosition = 0;
         this.selectedItem = null;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get isSelectable() : Boolean
      {
         return this._isSelectable;
      }
      
      public function set isSelectable(param1:Boolean) : void
      {
         if(this._isSelectable === param1)
         {
            return;
         }
         this._isSelectable = param1;
         if(!this._isSelectable)
         {
            this.selectedItem = null;
         }
         this.invalidate(INVALIDATION_FLAG_SELECTED);
      }
      
      public function get selectedLocation() : Vector.<int>
      {
         return this.getSelectedLocation();
      }
      
      public function set selectedLocation(param1:Vector.<int>) : void
      {
         var _loc2_:Object = this._dataProvider.getItemAtLocation(param1);
         this.selectedItem = _loc2_;
      }
      
      public function get selectedItem() : Object
      {
         return this._selectedItem;
      }
      
      public function set selectedItem(param1:Object) : void
      {
         var _loc2_:Vector.<int> = null;
         if(this._selectedItem === param1)
         {
            return;
         }
         if(this._dataProvider === null)
         {
            param1 = null;
         }
         if(param1 !== null)
         {
            _loc2_ = this._dataProvider.getItemLocation(param1,this._helperLocation);
            if(_loc2_ === null || _loc2_.length == 0)
            {
               param1 = null;
            }
         }
         if(this._selectedItem === param1)
         {
            return;
         }
         this._selectedItem = param1;
         this.invalidate(INVALIDATION_FLAG_SELECTED);
         this.dispatchEventWith(Event.CHANGE);
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
         if(this._layout !== null)
         {
            this._layout.removeEventListener(Event.SCROLL,this.layout_scrollHandler);
         }
         this._layout = param1;
         if(this._layout is IVariableVirtualLayout)
         {
            this._layout.addEventListener(Event.SCROLL,this.layout_scrollHandler);
         }
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
      }
      
      public function get itemRendererType() : Class
      {
         return this._itemRendererType;
      }
      
      public function set itemRendererType(param1:Class) : void
      {
         if(this._itemRendererType === param1)
         {
            return;
         }
         this._itemRendererType = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get itemRendererFactory() : Function
      {
         return this._itemRendererFactory;
      }
      
      public function set itemRendererFactory(param1:Function) : void
      {
         if(this._itemRendererFactory === param1)
         {
            return;
         }
         this._itemRendererFactory = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get factoryIDFunction() : Function
      {
         return this._factoryIDFunction;
      }
      
      public function set factoryIDFunction(param1:Function) : void
      {
         if(this._factoryIDFunction === param1)
         {
            return;
         }
         this._factoryIDFunction = param1;
         if(param1 !== null && this._itemRendererFactories === null)
         {
            this._itemRendererFactories = {};
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get typicalItem() : Object
      {
         return this._typicalItem;
      }
      
      public function set typicalItem(param1:Object) : void
      {
         if(this._typicalItem === param1)
         {
            return;
         }
         this._typicalItem = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get customItemRendererStyleName() : String
      {
         return this._customItemRendererStyleName;
      }
      
      public function set customItemRendererStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customItemRendererStyleName === param1)
         {
            return;
         }
         this._customItemRendererStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get keyScrollDuration() : Number
      {
         return this._keyScrollDuration;
      }
      
      public function set keyScrollDuration(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._keyScrollDuration == param1)
         {
            return;
         }
         this._keyScrollDuration = param1;
      }
      
      override public function dispose() : void
      {
         this._selectedItem = null;
         this.dataProvider = null;
         this.layout = null;
         super.dispose();
      }
      
      public function getItemRendererFactoryWithID(param1:String) : Function
      {
         if(Boolean(this._itemRendererFactories) && param1 in this._itemRendererFactories)
         {
            return this._itemRendererFactories[param1] as Function;
         }
         return null;
      }
      
      public function setItemRendererFactoryWithID(param1:String, param2:Function) : void
      {
         if(param1 === null)
         {
            this.itemRendererFactory = param2;
            return;
         }
         if(this._itemRendererFactories === null)
         {
            this._itemRendererFactories = {};
         }
         if(param2 !== null)
         {
            this._itemRendererFactories[param1] = param2;
         }
         else
         {
            delete this._itemRendererFactories[param1];
         }
      }
      
      public function itemToItemRenderer(param1:Object) : ITreeItemRenderer
      {
         return this.dataViewPort.itemToItemRenderer(param1);
      }
      
      public function toggleBranch(param1:Object, param2:Boolean) : void
      {
         if(this._dataProvider === null || !this._dataProvider.isBranch(param1))
         {
            throw new ArgumentError("toggleBranch() may not open an item that is not a branch.");
         }
         var _loc3_:int = this._openBranches.getItemIndex(param1);
         if(param2)
         {
            if(_loc3_ != -1)
            {
               return;
            }
            this._openBranches.addItem(param1);
            this.dispatchEventWith(Event.OPEN,false,param1);
         }
         else
         {
            if(_loc3_ == -1)
            {
               return;
            }
            this._openBranches.removeItem(param1);
            this.dispatchEventWith(Event.CLOSE,false,param1);
         }
      }
      
      public function isBranchOpen(param1:Object) : Boolean
      {
         if(this._dataProvider === null || !this._dataProvider.isBranch(param1))
         {
            return false;
         }
         return this._openBranches.getItemIndex(param1) != -1;
      }
      
      public function getSelectedLocation(param1:Vector.<int> = null) : Vector.<int>
      {
         if(param1 === null)
         {
            param1 = new Vector.<int>(0);
         }
         else
         {
            param1.length = 0;
         }
         if(this._dataProvider === null || this._selectedItem === null)
         {
            return param1;
         }
         return this._dataProvider.getItemLocation(this._selectedItem,param1);
      }
      
      override public function scrollToPosition(param1:Number, param2:Number, param3:Number = NaN) : void
      {
         this.pendingLocation = null;
         super.scrollToPosition(param1,param2,param3);
      }
      
      override public function scrollToPageIndex(param1:int, param2:int, param3:Number = NaN) : void
      {
         this.pendingLocation = null;
         super.scrollToPageIndex(param1,param2,param3);
      }
      
      public function scrollToDisplayLocation(param1:Vector.<int>, param2:Number = 0) : void
      {
         var locationsEqual:Boolean = false;
         var location:Vector.<int> = param1;
         var animationDuration:Number = param2;
         this.hasPendingHorizontalPageIndex = false;
         this.hasPendingVerticalPageIndex = false;
         this.pendingHorizontalScrollPosition = NaN;
         this.pendingVerticalScrollPosition = NaN;
         if(this.pendingLocation !== null && this.pendingLocation.length == location.length && this.pendingScrollDuration == animationDuration)
         {
            locationsEqual = this.pendingLocation.every(function(param1:int, param2:int, param3:Vector.<int>):Boolean
            {
               return param1 == location[param2];
            });
            if(locationsEqual)
            {
               return;
            }
         }
         this.pendingLocation = location;
         this.pendingScrollDuration = animationDuration;
         this.invalidate(INVALIDATION_FLAG_PENDING_SCROLL);
      }
      
      override protected function initialize() : void
      {
         var _loc2_:VerticalLayout = null;
         var _loc1_:Boolean = this._layout !== null;
         super.initialize();
         if(!this.dataViewPort)
         {
            this.viewPort = this.dataViewPort = new TreeDataViewPort();
            this.dataViewPort.owner = this;
            this.dataViewPort.addEventListener(Event.CHANGE,this.dataViewPort_changeHandler);
            this.viewPort = this.dataViewPort;
         }
         if(!_loc1_)
         {
            if(this._hasElasticEdges && this._verticalScrollPolicy === ScrollPolicy.AUTO && this._scrollBarDisplayMode !== ScrollBarDisplayMode.FIXED)
            {
               this._verticalScrollPolicy = ScrollPolicy.ON;
            }
            _loc2_ = new VerticalLayout();
            _loc2_.useVirtualLayout = true;
            _loc2_.padding = 0;
            _loc2_.gap = 0;
            _loc2_.horizontalAlign = HorizontalAlign.JUSTIFY;
            _loc2_.verticalAlign = VerticalAlign.TOP;
            this.ignoreNextStyleRestriction();
            this.layout = _loc2_;
         }
      }
      
      override protected function draw() : void
      {
         this.refreshDataViewPortProperties();
         super.draw();
      }
      
      override protected function handlePendingScroll() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Point = null;
         var _loc3_:Point = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(this.pendingLocation !== null)
         {
            _loc1_ = null;
            if(this._dataProvider !== null)
            {
               _loc1_ = this._dataProvider.getItemAtLocation(this.pendingLocation);
            }
            if(_loc1_ is Object)
            {
               _loc2_ = Pool.getPoint();
               _loc3_ = this.dataViewPort.getScrollPositionForLocation(this.pendingLocation,_loc2_);
               this.pendingLocation = null;
               if(_loc3_ === null)
               {
                  Pool.putPoint(_loc2_);
               }
               else
               {
                  _loc4_ = _loc2_.x;
                  _loc5_ = _loc2_.y;
                  Pool.putPoint(_loc2_);
                  if(_loc4_ < this._minHorizontalScrollPosition)
                  {
                     _loc4_ = this._minHorizontalScrollPosition;
                  }
                  else if(_loc4_ > this._maxHorizontalScrollPosition)
                  {
                     _loc4_ = this._maxHorizontalScrollPosition;
                  }
                  if(_loc5_ < this._minVerticalScrollPosition)
                  {
                     _loc5_ = this._minVerticalScrollPosition;
                  }
                  else if(_loc5_ > this._maxVerticalScrollPosition)
                  {
                     _loc5_ = this._maxVerticalScrollPosition;
                  }
                  this.throwTo(_loc4_,_loc5_,this.pendingScrollDuration);
               }
            }
         }
         super.handlePendingScroll();
      }
      
      protected function refreshDataViewPortProperties() : void
      {
         this.dataViewPort.isSelectable = this._isSelectable;
         this.dataViewPort.selectedItem = this._selectedItem;
         this.dataViewPort.dataProvider = this._dataProvider;
         this.dataViewPort.typicalItem = this._typicalItem;
         this.dataViewPort.openBranches = this._openBranches;
         this.dataViewPort.itemRendererType = this._itemRendererType;
         this.dataViewPort.itemRendererFactory = this._itemRendererFactory;
         this.dataViewPort.itemRendererFactories = this._itemRendererFactories;
         this.dataViewPort.factoryIDFunction = this._factoryIDFunction;
         this.dataViewPort.customItemRendererStyleName = this._customItemRendererStyleName;
         this.dataViewPort.layout = this._layout;
      }
      
      protected function validateSelectedItemIsInCollection() : void
      {
         if(this._selectedItem === null)
         {
            return;
         }
         var _loc1_:Vector.<int> = this._dataProvider.getItemLocation(this._selectedItem,this._helperLocation);
         if(_loc1_ === null || _loc1_.length == 0)
         {
            this.selectedItem = null;
         }
      }
      
      protected function dataViewPort_changeHandler(param1:Event) : void
      {
         this.selectedItem = this.dataViewPort.selectedItem;
      }
      
      protected function dataProvider_changeHandler(param1:Event) : void
      {
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      protected function dataProvider_resetHandler(param1:Event) : void
      {
         this.horizontalScrollPosition = 0;
         this.verticalScrollPosition = 0;
         this.selectedItem = null;
      }
      
      protected function dataProvider_removeAllHandler(param1:Event) : void
      {
         this.selectedItem = null;
      }
      
      protected function dataProvider_removeItemHandler(param1:Event, param2:Array) : void
      {
         this.validateSelectedItemIsInCollection();
      }
      
      protected function dataProvider_filterChangeHandler(param1:Event) : void
      {
         this.validateSelectedItemIsInCollection();
      }
      
      protected function dataProvider_replaceItemHandler(param1:Event, param2:Array) : void
      {
         this.validateSelectedItemIsInCollection();
      }
      
      private function layout_scrollHandler(param1:Event, param2:Point) : void
      {
         var _loc3_:IVariableVirtualLayout = IVariableVirtualLayout(this._layout);
         if(!this.isScrolling || !_loc3_.useVirtualLayout || !_loc3_.hasVariableItemDimensions)
         {
            return;
         }
         var _loc4_:Number = param2.x;
         this._startHorizontalScrollPosition += _loc4_;
         this._horizontalScrollPosition += _loc4_;
         if(this._horizontalAutoScrollTween)
         {
            this._targetHorizontalScrollPosition += _loc4_;
            this.throwTo(this._targetHorizontalScrollPosition,NaN,this._horizontalAutoScrollTween.totalTime - this._horizontalAutoScrollTween.currentTime);
         }
         var _loc5_:Number = param2.y;
         this._startVerticalScrollPosition += _loc5_;
         this._verticalScrollPosition += _loc5_;
         if(this._verticalAutoScrollTween)
         {
            this._targetVerticalScrollPosition += _loc5_;
            this.throwTo(NaN,this._targetVerticalScrollPosition,this._verticalAutoScrollTween.totalTime - this._verticalAutoScrollTween.currentTime);
         }
      }
      
      override protected function nativeStage_keyDownHandler(param1:KeyboardEvent) : void
      {
         if(!this._isSelectable)
         {
            super.nativeStage_keyDownHandler(param1);
            return;
         }
         if(param1.isDefaultPrevented())
         {
            return;
         }
         if(!this._dataProvider)
         {
            return;
         }
         if(this._selectedItem !== null && (param1.keyCode == Keyboard.SPACE || (param1.keyLocation == 4 || DeviceCapabilities.simulateDPad) && param1.keyCode == Keyboard.ENTER))
         {
            this.dispatchEventWith(Event.TRIGGERED,false,this.selectedItem);
         }
      }
   }
}

