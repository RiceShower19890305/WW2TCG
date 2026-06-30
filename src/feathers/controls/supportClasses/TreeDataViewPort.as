package feathers.controls.supportClasses
{
   import feathers.controls.Scroller;
   import feathers.controls.Tree;
   import feathers.controls.renderers.ITreeItemRenderer;
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.IValidating;
   import feathers.data.IHierarchicalCollection;
   import feathers.data.IListCollection;
   import feathers.events.FeathersEventType;
   import feathers.layout.ILayout;
   import feathers.layout.IVariableVirtualLayout;
   import feathers.layout.IVirtualLayout;
   import feathers.layout.LayoutBoundsResult;
   import feathers.layout.ViewPortBounds;
   import flash.errors.IllegalOperationError;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import starling.utils.Pool;
   
   public class TreeDataViewPort extends FeathersControl implements IViewPort
   {
      
      private static const INVALIDATION_FLAG_ITEM_RENDERER_FACTORY:String = "itemRendererFactory";
      
      private static const HELPER_VECTOR:Vector.<int> = new Vector.<int>(0);
      
      private static const LOCATION_HELPER_VECTOR:Vector.<int> = new Vector.<int>(0);
      
      private var _viewPortBounds:ViewPortBounds = new ViewPortBounds();
      
      private var _layoutResult:LayoutBoundsResult = new LayoutBoundsResult();
      
      private var _actualMinVisibleWidth:Number = 0;
      
      private var _explicitMinVisibleWidth:Number;
      
      private var _maxVisibleWidth:Number = Infinity;
      
      private var _actualVisibleWidth:Number = NaN;
      
      private var _explicitVisibleWidth:Number = NaN;
      
      private var _actualMinVisibleHeight:Number = 0;
      
      private var _explicitMinVisibleHeight:Number;
      
      private var _maxVisibleHeight:Number = Infinity;
      
      private var _actualVisibleHeight:Number;
      
      private var _explicitVisibleHeight:Number = NaN;
      
      protected var _contentX:Number = 0;
      
      protected var _contentY:Number = 0;
      
      private var _owner:Tree = null;
      
      private var _updateForDataReset:Boolean = false;
      
      private var _dataProvider:IHierarchicalCollection = null;
      
      private var _ignoreLayoutChanges:Boolean = false;
      
      private var _ignoreRendererResizing:Boolean = false;
      
      private var _layout:ILayout = null;
      
      private var _horizontalScrollPosition:Number = 0;
      
      private var _verticalScrollPosition:Number = 0;
      
      private var _ignoreSelectionChanges:Boolean = false;
      
      private var _isSelectable:Boolean = true;
      
      private var _selectedItem:Object = null;
      
      private var _typicalItem:Object = null;
      
      private var _itemRendererType:Class;
      
      private var _itemRendererFactory:Function;
      
      private var _itemRendererFactories:Object;
      
      private var _factoryIDFunction:Function;
      
      private var _customItemRendererStyleName:String;
      
      private var _openBranches:IListCollection;
      
      private var _typicalItemIsInDataProvider:Boolean = false;
      
      private var _typicalItemRenderer:ITreeItemRenderer;
      
      private var _layoutItems:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
      
      private var _unrenderedItems:Array = [];
      
      private var _defaultItemRendererStorage:ItemRendererFactoryStorage = new ItemRendererFactoryStorage();
      
      private var _itemStorageMap:Object = {};
      
      private var _itemRendererMap:Dictionary = new Dictionary(true);
      
      private var _minimumItemCount:int;
      
      private var _displayIndex:int;
      
      public function TreeDataViewPort()
      {
         super();
      }
      
      public function get minVisibleWidth() : Number
      {
         if(this._explicitMinVisibleWidth !== this._explicitMinVisibleWidth)
         {
            return this._actualMinVisibleWidth;
         }
         return this._explicitMinVisibleWidth;
      }
      
      public function set minVisibleWidth(param1:Number) : void
      {
         if(this._explicitMinVisibleWidth == param1)
         {
            return;
         }
         var _loc2_:Boolean = param1 !== param1;
         if(_loc2_ && this._explicitMinVisibleWidth !== this._explicitMinVisibleWidth)
         {
            return;
         }
         var _loc3_:Number = this._explicitMinVisibleWidth;
         this._explicitMinVisibleWidth = param1;
         if(_loc2_)
         {
            this._actualMinVisibleWidth = 0;
            this.invalidate(INVALIDATION_FLAG_SIZE);
         }
         else
         {
            this._actualMinVisibleWidth = param1;
            if(this._explicitVisibleWidth !== this._explicitVisibleWidth && (this._actualVisibleWidth < param1 || this._actualVisibleWidth == _loc3_))
            {
               this.invalidate(INVALIDATION_FLAG_SIZE);
            }
         }
      }
      
      public function get maxVisibleWidth() : Number
      {
         return this._maxVisibleWidth;
      }
      
      public function set maxVisibleWidth(param1:Number) : void
      {
         if(this._maxVisibleWidth == param1)
         {
            return;
         }
         if(param1 !== param1)
         {
            throw new ArgumentError("maxVisibleWidth cannot be NaN");
         }
         var _loc2_:Number = this._maxVisibleWidth;
         this._maxVisibleWidth = param1;
         if(this._explicitVisibleWidth !== this._explicitVisibleWidth && (this._actualVisibleWidth > param1 || this._actualVisibleWidth == _loc2_))
         {
            this.invalidate(INVALIDATION_FLAG_SIZE);
         }
      }
      
      public function get visibleWidth() : Number
      {
         return this._actualVisibleWidth;
      }
      
      public function set visibleWidth(param1:Number) : void
      {
         if(this._explicitVisibleWidth == param1 || param1 !== param1 && this._explicitVisibleWidth !== this._explicitVisibleWidth)
         {
            return;
         }
         this._explicitVisibleWidth = param1;
         if(this._actualVisibleWidth != param1)
         {
            this.invalidate(INVALIDATION_FLAG_SIZE);
         }
      }
      
      public function get minVisibleHeight() : Number
      {
         if(this._explicitMinVisibleHeight !== this._explicitMinVisibleHeight)
         {
            return this._actualMinVisibleHeight;
         }
         return this._explicitMinVisibleHeight;
      }
      
      public function set minVisibleHeight(param1:Number) : void
      {
         if(this._explicitMinVisibleHeight == param1)
         {
            return;
         }
         var _loc2_:Boolean = param1 !== param1;
         if(_loc2_ && this._explicitMinVisibleHeight !== this._explicitMinVisibleHeight)
         {
            return;
         }
         var _loc3_:Number = this._explicitMinVisibleHeight;
         this._explicitMinVisibleHeight = param1;
         if(_loc2_)
         {
            this._actualMinVisibleHeight = 0;
            this.invalidate(INVALIDATION_FLAG_SIZE);
         }
         else
         {
            this._actualMinVisibleHeight = param1;
            if(this._explicitVisibleHeight !== this._explicitVisibleHeight && (this._actualVisibleHeight < param1 || this._actualVisibleHeight == _loc3_))
            {
               this.invalidate(INVALIDATION_FLAG_SIZE);
            }
         }
      }
      
      public function get maxVisibleHeight() : Number
      {
         return this._maxVisibleHeight;
      }
      
      public function set maxVisibleHeight(param1:Number) : void
      {
         if(this._maxVisibleHeight == param1)
         {
            return;
         }
         if(param1 !== param1)
         {
            throw new ArgumentError("maxVisibleHeight cannot be NaN");
         }
         var _loc2_:Number = this._maxVisibleHeight;
         this._maxVisibleHeight = param1;
         if(this._explicitVisibleHeight !== this._explicitVisibleHeight && (this._actualVisibleHeight > param1 || this._actualVisibleHeight == _loc2_))
         {
            this.invalidate(INVALIDATION_FLAG_SIZE);
         }
      }
      
      public function get visibleHeight() : Number
      {
         return this._actualVisibleHeight;
      }
      
      public function set visibleHeight(param1:Number) : void
      {
         if(this._explicitVisibleHeight == param1 || param1 !== param1 && this._explicitVisibleHeight !== this._explicitVisibleHeight)
         {
            return;
         }
         this._explicitVisibleHeight = param1;
         if(this._actualVisibleHeight != param1)
         {
            this.invalidate(INVALIDATION_FLAG_SIZE);
         }
      }
      
      public function get contentX() : Number
      {
         return this._contentX;
      }
      
      public function get contentY() : Number
      {
         return this._contentY;
      }
      
      public function get horizontalScrollStep() : Number
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:IVirtualLayout = this._layout as IVirtualLayout;
         if(_loc2_ === null || !_loc2_.useVirtualLayout)
         {
            if(this._layoutItems.length > 0)
            {
               _loc1_ = this._layoutItems[0] as DisplayObject;
            }
         }
         switch(_loc1_)
         {
            case null:
               _loc1_ = this._typicalItemRenderer as DisplayObject;
               if(_loc1_ !== null)
               {
                  break;
               }
            case null:
               return 0;
         }
         var _loc3_:Number = _loc1_.width;
         var _loc4_:Number = _loc1_.height;
         if(_loc3_ < _loc4_)
         {
            return _loc3_;
         }
         return _loc4_;
      }
      
      public function get verticalScrollStep() : Number
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:IVirtualLayout = this._layout as IVirtualLayout;
         if(_loc2_ === null || !_loc2_.useVirtualLayout)
         {
            if(this._layoutItems.length > 0)
            {
               _loc1_ = this._layoutItems[0] as DisplayObject;
            }
         }
         switch(_loc1_)
         {
            case null:
               _loc1_ = this._typicalItemRenderer as DisplayObject;
               if(_loc1_ !== null)
               {
                  break;
               }
            case null:
               return 0;
         }
         var _loc3_:Number = _loc1_.width;
         var _loc4_:Number = _loc1_.height;
         if(_loc3_ < _loc4_)
         {
            return _loc3_;
         }
         return _loc4_;
      }
      
      public function get owner() : Tree
      {
         return this._owner;
      }
      
      public function set owner(param1:Tree) : void
      {
         this._owner = param1;
      }
      
      public function get dataProvider() : IHierarchicalCollection
      {
         return this._dataProvider;
      }
      
      public function set dataProvider(param1:IHierarchicalCollection) : void
      {
         if(this._dataProvider == param1)
         {
            return;
         }
         if(this._dataProvider)
         {
            this._dataProvider.removeEventListener(Event.CHANGE,this.dataProvider_changeHandler);
         }
         this._dataProvider = param1;
         if(this._dataProvider)
         {
            this._dataProvider.addEventListener(Event.CHANGE,this.dataProvider_changeHandler);
         }
         if(this._layout is IVariableVirtualLayout)
         {
            IVariableVirtualLayout(this._layout).resetVariableVirtualCache();
         }
         this._updateForDataReset = true;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get layout() : ILayout
      {
         return this._layout;
      }
      
      public function set layout(param1:ILayout) : void
      {
         var _loc2_:IVariableVirtualLayout = null;
         if(this._layout == param1)
         {
            return;
         }
         if(this._layout)
         {
            this._layout.removeEventListener(Event.CHANGE,this.layout_changeHandler);
         }
         this._layout = param1;
         if(this._layout)
         {
            if(this._layout is IVariableVirtualLayout)
            {
               _loc2_ = IVariableVirtualLayout(this._layout);
               _loc2_.resetVariableVirtualCache();
            }
            this._layout.addEventListener(Event.CHANGE,this.layout_changeHandler);
         }
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
      }
      
      public function get horizontalScrollPosition() : Number
      {
         return this._horizontalScrollPosition;
      }
      
      public function set horizontalScrollPosition(param1:Number) : void
      {
         if(this._horizontalScrollPosition == param1)
         {
            return;
         }
         this._horizontalScrollPosition = param1;
         this.invalidate(INVALIDATION_FLAG_SCROLL);
      }
      
      public function get verticalScrollPosition() : Number
      {
         return this._verticalScrollPosition;
      }
      
      public function set verticalScrollPosition(param1:Number) : void
      {
         if(this._verticalScrollPosition == param1)
         {
            return;
         }
         this._verticalScrollPosition = param1;
         this.invalidate(INVALIDATION_FLAG_SCROLL);
      }
      
      public function get requiresMeasurementOnScroll() : Boolean
      {
         return this._layout.requiresLayoutOnScroll && (this._explicitVisibleWidth !== this._explicitVisibleWidth || this._explicitVisibleHeight !== this._explicitVisibleHeight);
      }
      
      public function get isSelectable() : Boolean
      {
         return this._isSelectable;
      }
      
      public function set isSelectable(param1:Boolean) : void
      {
         if(this._isSelectable == param1)
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
      
      public function get selectedItem() : Object
      {
         return this._selectedItem;
      }
      
      public function set selectedItem(param1:Object) : void
      {
         if(this._selectedItem == param1)
         {
            return;
         }
         this._selectedItem = param1;
         this.invalidate(INVALIDATION_FLAG_SELECTED);
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get typicalItem() : Object
      {
         return this._typicalItem;
      }
      
      public function set typicalItem(param1:Object) : void
      {
         if(this._typicalItem == param1)
         {
            return;
         }
         this._typicalItem = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get itemRendererType() : Class
      {
         return this._itemRendererType;
      }
      
      public function set itemRendererType(param1:Class) : void
      {
         if(this._itemRendererType == param1)
         {
            return;
         }
         this._itemRendererType = param1;
         this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
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
         this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
      }
      
      public function get itemRendererFactories() : Object
      {
         return this._itemRendererFactories;
      }
      
      public function set itemRendererFactories(param1:Object) : void
      {
         if(this._itemRendererFactories === param1)
         {
            return;
         }
         this._itemRendererFactories = param1;
         this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
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
         this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
      }
      
      public function get customItemRendererStyleName() : String
      {
         return this._customItemRendererStyleName;
      }
      
      public function set customItemRendererStyleName(param1:String) : void
      {
         if(this._customItemRendererStyleName == param1)
         {
            return;
         }
         this._customItemRendererStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
      }
      
      public function get openBranches() : IListCollection
      {
         return this._openBranches;
      }
      
      public function set openBranches(param1:IListCollection) : void
      {
         if(this._openBranches == param1)
         {
            return;
         }
         if(this._openBranches !== null)
         {
            this._openBranches.removeEventListener(Event.CHANGE,this.openBranches_changeHandler);
         }
         this._openBranches = param1;
         if(this._openBranches !== null)
         {
            this._openBranches.addEventListener(Event.CHANGE,this.openBranches_changeHandler);
         }
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function calculateNavigationDestination(param1:Vector.<int>, param2:uint, param3:Vector.<int>) : void
      {
         var _loc4_:int = this.locationToDisplayIndex(param1,false);
         if(_loc4_ == -1)
         {
            throw new ArgumentError("Cannot calculate navigation destination for location: " + param1);
         }
         var _loc5_:int = this._layout.calculateNavigationDestination(this._layoutItems,_loc4_,param2,this._layoutResult);
         this.displayIndexToLocation(_loc5_,param3);
      }
      
      public function getScrollPositionForLocation(param1:Vector.<int>, param2:Point = null) : Point
      {
         if(!param2)
         {
            param2 = new Point();
         }
         var _loc3_:int = this.locationToDisplayIndex(param1,true);
         if(_loc3_ == -1)
         {
            throw new ArgumentError("Cannot calculate scroll position for location: " + param1);
         }
         return this._layout.getScrollPositionForIndex(_loc3_,this._layoutItems,0,0,this._actualVisibleWidth,this._actualVisibleHeight,param2);
      }
      
      public function getNearestScrollPositionForIndex(param1:Vector.<int>, param2:Point = null) : Point
      {
         if(!param2)
         {
            param2 = new Point();
         }
         var _loc3_:int = this.locationToDisplayIndex(param1,true);
         if(_loc3_ == -1)
         {
            throw new ArgumentError("Cannot calculate nearest scroll position for location: " + param1);
         }
         return this._layout.getNearestScrollPositionForIndex(_loc3_,this._horizontalScrollPosition,this._verticalScrollPosition,this._layoutItems,0,0,this._actualVisibleWidth,this._actualVisibleHeight,param2);
      }
      
      public function itemToItemRenderer(param1:Object) : ITreeItemRenderer
      {
         if(param1 is XML || param1 is XMLList)
         {
            return ITreeItemRenderer(this._itemRendererMap[param1.toXMLString()]);
         }
         return ITreeItemRenderer(this._itemRendererMap[param1]);
      }
      
      override public function dispose() : void
      {
         var _loc1_:String = null;
         this.refreshInactiveItemRenderers(null,true);
         if(this._itemStorageMap)
         {
            for(_loc1_ in this._itemStorageMap)
            {
               this.refreshInactiveItemRenderers(_loc1_,true);
            }
         }
         this.owner = null;
         this.dataProvider = null;
         this.layout = null;
         super.dispose();
      }
      
      override protected function draw() : void
      {
         var _loc12_:String = null;
         var _loc13_:Boolean = false;
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_SCROLL);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
         var _loc4_:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
         var _loc5_:Boolean = this.isInvalid(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
         var _loc6_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc7_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         var _loc8_:Boolean = this.isInvalid(INVALIDATION_FLAG_LAYOUT);
         if(Boolean(!_loc8_ && _loc2_) && Boolean(this._layout) && this._layout.requiresLayoutOnScroll)
         {
            _loc8_ = true;
         }
         var _loc9_:Boolean = _loc3_ || _loc1_ || _loc8_ || _loc5_;
         var _loc10_:Boolean = this._ignoreRendererResizing;
         this._ignoreRendererResizing = true;
         var _loc11_:Boolean = this._ignoreLayoutChanges;
         this._ignoreLayoutChanges = true;
         if(_loc2_ || _loc3_)
         {
            this.refreshViewPortBounds();
         }
         if(_loc9_)
         {
            this.refreshInactiveItemRenderers(null,_loc5_);
            if(this._itemStorageMap)
            {
               for(_loc12_ in this._itemStorageMap)
               {
                  this.refreshInactiveItemRenderers(_loc12_,_loc5_);
               }
            }
         }
         if(_loc1_ || _loc8_ || _loc5_)
         {
            this.refreshLayoutTypicalItem();
         }
         if(_loc9_)
         {
            this.refreshItemRenderers();
         }
         if(_loc4_ || _loc9_)
         {
            _loc13_ = this._ignoreSelectionChanges;
            this._ignoreSelectionChanges = true;
            this.refreshSelection();
            this._ignoreSelectionChanges = _loc13_;
         }
         if(_loc7_ || _loc9_)
         {
            this.refreshEnabled();
         }
         this._ignoreLayoutChanges = _loc11_;
         if(_loc7_ || _loc4_ || _loc6_ || _loc9_)
         {
            this._layout.layout(this._layoutItems,this._viewPortBounds,this._layoutResult);
         }
         this._ignoreRendererResizing = _loc10_;
         this._contentX = this._layoutResult.contentX;
         this._contentY = this._layoutResult.contentY;
         this.saveMeasurements(this._layoutResult.contentWidth,this._layoutResult.contentHeight,this._layoutResult.contentWidth,this._layoutResult.contentHeight);
         this._actualVisibleWidth = this._layoutResult.viewPortWidth;
         this._actualVisibleHeight = this._layoutResult.viewPortHeight;
         this._actualMinVisibleWidth = this._layoutResult.viewPortWidth;
         this._actualMinVisibleHeight = this._layoutResult.viewPortHeight;
         this.validateRenderers();
      }
      
      private function displayIndexToLocation(param1:int, param2:Vector.<int>) : void
      {
      }
      
      private function locationToDisplayIndex(param1:Vector.<int>, param2:Boolean) : int
      {
         this._displayIndex = -1;
         var _loc3_:Object = this.locationToDisplayIndexAtBranch(new Vector.<int>(0),param1,param2);
         if(_loc3_ !== null)
         {
            return this._displayIndex;
         }
         return -1;
      }
      
      private function locationToDisplayIndexAtBranch(param1:Vector.<int>, param2:Vector.<int>, param3:Boolean) : Object
      {
         var child:Object = null;
         var every:Boolean = false;
         var result:Object = null;
         var locationOfBranch:Vector.<int> = param1;
         var locationToFind:Vector.<int> = param2;
         var returnNearestIfBranchNotOpen:Boolean = param3;
         var childCount:int = this._dataProvider.getLengthAtLocation(locationOfBranch);
         var i:int = 0;
         while(i < childCount)
         {
            ++this._displayIndex;
            locationOfBranch[locationOfBranch.length] = i;
            child = this._dataProvider.getItemAtLocation(locationOfBranch);
            if(locationOfBranch.length == locationToFind.length)
            {
               every = locationOfBranch.every(function(param1:int, param2:int, param3:Vector.<int>):Boolean
               {
                  return param1 === locationToFind[param2];
               });
               if(every)
               {
                  return child;
               }
            }
            if(this._dataProvider.isBranch(child))
            {
               if(this.owner.isBranchOpen(child))
               {
                  result = this.locationToDisplayIndexAtBranch(locationOfBranch,locationToFind,returnNearestIfBranchNotOpen);
                  if(result)
                  {
                     return result;
                  }
               }
               else if(returnNearestIfBranchNotOpen)
               {
                  every = locationOfBranch.every(function(param1:int, param2:int, param3:Vector.<int>):Boolean
                  {
                     return param1 === locationToFind[param2];
                  });
                  if(every)
                  {
                     return child;
                  }
               }
            }
            --locationOfBranch.length;
            i++;
         }
         return null;
      }
      
      private function refreshViewPortBounds() : void
      {
         var _loc1_:Boolean = this._explicitMinVisibleWidth !== this._explicitMinVisibleWidth;
         var _loc2_:Boolean = this._explicitMinVisibleHeight !== this._explicitMinVisibleHeight;
         this._viewPortBounds.x = 0;
         this._viewPortBounds.y = 0;
         this._viewPortBounds.scrollX = this._horizontalScrollPosition;
         this._viewPortBounds.scrollY = this._verticalScrollPosition;
         this._viewPortBounds.explicitWidth = this._explicitVisibleWidth;
         this._viewPortBounds.explicitHeight = this._explicitVisibleHeight;
         if(_loc1_)
         {
            this._viewPortBounds.minWidth = 0;
         }
         else
         {
            this._viewPortBounds.minWidth = this._explicitMinVisibleWidth;
         }
         if(_loc2_)
         {
            this._viewPortBounds.minHeight = 0;
         }
         else
         {
            this._viewPortBounds.minHeight = this._explicitMinVisibleHeight;
         }
         this._viewPortBounds.maxWidth = this._maxVisibleWidth;
         this._viewPortBounds.maxHeight = this._maxVisibleHeight;
      }
      
      private function refreshLayoutTypicalItem() : void
      {
         var _loc5_:ITreeItemRenderer = null;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:String = null;
         var _loc9_:Object = null;
         var _loc1_:IVirtualLayout = this._layout as IVirtualLayout;
         if(_loc1_ === null || !_loc1_.useVirtualLayout)
         {
            if(!this._typicalItemIsInDataProvider && this._typicalItemRenderer !== null)
            {
               this.destroyItemRenderer(this._typicalItemRenderer);
               this._typicalItemRenderer = null;
            }
            return;
         }
         var _loc2_:Vector.<int> = null;
         var _loc3_:Boolean = false;
         var _loc4_:Object = this._typicalItem;
         if(_loc4_ !== null)
         {
            if(this._dataProvider !== null)
            {
               _loc2_ = this._dataProvider.getItemLocation(_loc4_);
               _loc3_ = _loc2_ !== null && _loc2_.length > 0;
            }
         }
         else if(this._dataProvider !== null && this._dataProvider.getLengthAtLocation() > 0)
         {
            _loc3_ = true;
            _loc4_ = this._dataProvider.getItemAt(0);
            _loc2_ = new <int>[0];
         }
         if(_loc4_ !== null || _loc3_)
         {
            _loc5_ = this.itemToItemRenderer(_loc4_);
            if(_loc5_ !== null)
            {
               _loc5_.location = _loc2_;
            }
            if(_loc5_ === null && this._typicalItemRenderer !== null)
            {
               _loc6_ = !this._typicalItemIsInDataProvider;
               _loc7_ = this._typicalItemIsInDataProvider && this._dataProvider !== null && this._dataProvider.getItemLocation(this._typicalItemRenderer.data) === null;
               if(!_loc6_ && _loc7_)
               {
                  _loc6_ = true;
               }
               if(_loc6_)
               {
                  _loc8_ = null;
                  if(this._factoryIDFunction !== null)
                  {
                     _loc8_ = this.getFactoryID(_loc4_,_loc2_);
                  }
                  if(this._typicalItemRenderer.factoryID !== _loc8_)
                  {
                     _loc6_ = false;
                  }
               }
               if(_loc6_)
               {
                  if(this._typicalItemIsInDataProvider)
                  {
                     _loc9_ = this._typicalItemRenderer.data;
                     if(_loc9_ is XML || _loc9_ is XMLList)
                     {
                        delete this._itemRendererMap[_loc9_.toXMLString()];
                     }
                     else
                     {
                        delete this._itemRendererMap[_loc9_];
                     }
                  }
                  _loc5_ = this._typicalItemRenderer;
                  _loc5_.data = _loc4_;
                  _loc5_.location = _loc2_;
                  if(_loc3_)
                  {
                     if(_loc4_ is XML || _loc4_ is XMLList)
                     {
                        this._itemRendererMap[_loc4_.toXMLString()] = _loc5_;
                     }
                     else
                     {
                        this._itemRendererMap[_loc4_] = _loc5_;
                     }
                  }
               }
            }
            if(_loc5_ === null)
            {
               _loc5_ = this.createItemRenderer(_loc4_,_loc2_,0,false,!_loc3_);
               if(!this._typicalItemIsInDataProvider && this._typicalItemRenderer !== null)
               {
                  this.destroyItemRenderer(this._typicalItemRenderer);
                  this._typicalItemRenderer = null;
               }
            }
         }
         _loc1_.typicalItem = DisplayObject(_loc5_);
         this._typicalItemRenderer = _loc5_;
         this._typicalItemIsInDataProvider = _loc3_;
         if(this._typicalItemRenderer !== null && !this._typicalItemIsInDataProvider)
         {
            this._typicalItemRenderer.addEventListener(FeathersEventType.RESIZE,this.itemRenderer_resizeHandler);
         }
      }
      
      private function refreshItemRenderers() : void
      {
         var _loc1_:ItemRendererFactoryStorage = null;
         var _loc2_:Vector.<ITreeItemRenderer> = null;
         var _loc3_:Vector.<ITreeItemRenderer> = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         if(this._typicalItemRenderer !== null && this._typicalItemIsInDataProvider)
         {
            _loc1_ = this.factoryIDToStorage(this._typicalItemRenderer.factoryID);
            _loc2_ = _loc1_.inactiveItemRenderers;
            _loc3_ = _loc1_.activeItemRenderers;
            _loc4_ = _loc2_.indexOf(this._typicalItemRenderer);
            if(_loc4_ >= 0)
            {
               _loc2_[_loc4_] = null;
            }
            _loc5_ = int(_loc3_.length);
            if(_loc5_ == 0)
            {
               _loc3_[_loc5_] = this._typicalItemRenderer;
            }
         }
         this.findUnrenderedData();
         this.recoverInactiveItemRenderers(this._defaultItemRendererStorage);
         if(this._itemStorageMap)
         {
            for(_loc6_ in this._itemStorageMap)
            {
               _loc1_ = ItemRendererFactoryStorage(this._itemStorageMap[_loc6_]);
               this.recoverInactiveItemRenderers(_loc1_);
            }
         }
         this.renderUnrenderedData();
         this.freeInactiveItemRenderers(this._defaultItemRendererStorage,this._minimumItemCount);
         if(this._itemStorageMap)
         {
            for(_loc6_ in this._itemStorageMap)
            {
               _loc1_ = ItemRendererFactoryStorage(this._itemStorageMap[_loc6_]);
               this.freeInactiveItemRenderers(_loc1_,1);
            }
         }
         this._updateForDataReset = false;
      }
      
      private function findTotalLayoutCount(param1:Vector.<int>) : int
      {
         var _loc5_:Object = null;
         var _loc2_:int = 0;
         if(this._dataProvider !== null)
         {
            _loc2_ = this._dataProvider.getLengthAtLocation(param1);
         }
         var _loc3_:int = _loc2_;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            param1[param1.length] = _loc4_;
            _loc5_ = this._dataProvider.getItemAtLocation(param1);
            if(this._dataProvider.isBranch(_loc5_) && this._openBranches.contains(_loc5_))
            {
               _loc3_ += this.findTotalLayoutCount(param1);
            }
            --param1.length;
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function findUnrenderedDataForLocation(param1:Vector.<int>, param2:int) : int
      {
         var _loc7_:Object = null;
         var _loc3_:IVirtualLayout = this._layout as IVirtualLayout;
         var _loc4_:Boolean = _loc3_ !== null && _loc3_.useVirtualLayout;
         var _loc5_:int = 0;
         if(this._dataProvider !== null)
         {
            _loc5_ = this._dataProvider.getLengthAtLocation(param1);
         }
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            param1[param1.length] = _loc6_;
            _loc7_ = this._dataProvider.getItemAtLocation(param1);
            if(_loc4_ && HELPER_VECTOR.indexOf(param2) == -1)
            {
               if(this._typicalItemRenderer !== null && this._typicalItemIsInDataProvider && this._typicalItemRenderer.data === _loc7_)
               {
                  this._typicalItemRenderer.layoutIndex = param2;
               }
               this._layoutItems[param2] = null;
            }
            else
            {
               this.findRendererForItem(_loc7_,param1.slice(),param2);
            }
            param2++;
            if(this._dataProvider.isBranch(_loc7_) && this._openBranches.contains(_loc7_))
            {
               param2 = this.findUnrenderedDataForLocation(param1,param2);
            }
            --param1.length;
            _loc6_++;
         }
         return param2;
      }
      
      private function findUnrenderedData() : void
      {
         var _loc4_:Point = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:int = 0;
         LOCATION_HELPER_VECTOR.length = 0;
         var _loc1_:int = this.findTotalLayoutCount(LOCATION_HELPER_VECTOR);
         LOCATION_HELPER_VECTOR.length = 0;
         this._layoutItems.length = _loc1_;
         var _loc2_:IVirtualLayout = this._layout as IVirtualLayout;
         var _loc3_:Boolean = _loc2_ !== null && _loc2_.useVirtualLayout;
         if(_loc3_)
         {
            _loc4_ = Pool.getPoint();
            _loc2_.measureViewPort(_loc1_,this._viewPortBounds,_loc4_);
            _loc5_ = _loc4_.x;
            _loc6_ = _loc4_.y;
            Pool.putPoint(_loc4_);
            _loc2_.getVisibleIndicesAtScrollPosition(this._horizontalScrollPosition,this._verticalScrollPosition,_loc5_,_loc6_,_loc1_,HELPER_VECTOR);
            if(this._typicalItemRenderer !== null)
            {
               _loc7_ = Number(this._typicalItemRenderer.height);
               if(this._typicalItemRenderer.width < _loc7_)
               {
                  _loc7_ = Number(this._typicalItemRenderer.width);
               }
               _loc8_ = _loc5_;
               if(_loc6_ > _loc5_)
               {
                  _loc8_ = _loc6_;
               }
               this._minimumItemCount = Math.ceil(_loc8_ / _loc7_) + 1;
            }
            else
            {
               this._minimumItemCount = 1;
            }
         }
         LOCATION_HELPER_VECTOR.length = 0;
         this.findUnrenderedDataForLocation(LOCATION_HELPER_VECTOR,0);
         LOCATION_HELPER_VECTOR.length = 0;
         if(this._typicalItemRenderer !== null)
         {
            if(_loc3_ && this._typicalItemIsInDataProvider)
            {
               _loc9_ = HELPER_VECTOR.indexOf(this._typicalItemRenderer.layoutIndex);
               if(_loc9_ >= 0)
               {
                  this._typicalItemRenderer.visible = true;
               }
               else
               {
                  this._typicalItemRenderer.visible = false;
               }
            }
            else
            {
               this._typicalItemRenderer.visible = this._typicalItemIsInDataProvider;
            }
         }
         HELPER_VECTOR.length = 0;
      }
      
      private function findRendererForItem(param1:Object, param2:Vector.<int>, param3:int) : void
      {
         var _loc5_:String = null;
         var _loc6_:ItemRendererFactoryStorage = null;
         var _loc7_:Vector.<ITreeItemRenderer> = null;
         var _loc8_:Vector.<ITreeItemRenderer> = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc4_:ITreeItemRenderer = this.itemToItemRenderer(param1);
         if(this._factoryIDFunction !== null && _loc4_ !== null)
         {
            _loc5_ = this.getFactoryID(_loc4_.data,param2);
            if(_loc5_ !== _loc4_.factoryID)
            {
               _loc4_ = null;
               if(param1 is XML || param1 is XMLList)
               {
                  delete this._itemRendererMap[param1.toXMLString()];
               }
               else
               {
                  delete this._itemRendererMap[param1];
               }
            }
         }
         if(_loc4_ !== null)
         {
            _loc4_.location = param2;
            _loc4_.layoutIndex = param3;
            _loc4_.isOpen = this._dataProvider.isBranch(param1) && this._openBranches.contains(param1);
            if(this._updateForDataReset)
            {
               _loc4_.data = null;
               _loc4_.data = param1;
            }
            if(this._typicalItemRenderer !== _loc4_)
            {
               _loc6_ = this.factoryIDToStorage(_loc4_.factoryID);
               _loc7_ = _loc6_.activeItemRenderers;
               _loc8_ = _loc6_.inactiveItemRenderers;
               _loc7_[_loc7_.length] = _loc4_;
               _loc9_ = _loc8_.indexOf(_loc4_);
               if(_loc9_ < 0)
               {
                  throw new IllegalOperationError("TreeDataViewPort: item renderer map contains bad data. This may be caused by duplicate items in the data provider, which is not allowed.");
               }
               _loc8_.removeAt(_loc9_);
            }
            _loc4_.visible = true;
            this._layoutItems[param3] = DisplayObject(_loc4_);
         }
         else
         {
            _loc10_ = int(this._unrenderedItems.length);
            this._unrenderedItems[_loc10_] = param2;
            _loc10_++;
            this._unrenderedItems[_loc10_] = param3;
         }
      }
      
      private function renderUnrenderedData() : void
      {
         var _loc3_:Vector.<int> = null;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:ITreeItemRenderer = null;
         LOCATION_HELPER_VECTOR.length = 2;
         var _loc1_:int = int(this._unrenderedItems.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._unrenderedItems.shift();
            _loc4_ = this._unrenderedItems.shift();
            _loc5_ = this._dataProvider.getItemAtLocation(_loc3_);
            _loc6_ = this.createItemRenderer(_loc5_,_loc3_,_loc4_,true,false);
            _loc6_.visible = true;
            this._layoutItems[_loc4_] = DisplayObject(_loc6_);
            _loc2_ += 2;
         }
         LOCATION_HELPER_VECTOR.length = 0;
      }
      
      private function refreshInactiveItemRenderers(param1:String, param2:Boolean) : void
      {
         var _loc4_:ItemRendererFactoryStorage = null;
         var _loc5_:Object = null;
         if(param1 !== null)
         {
            _loc4_ = ItemRendererFactoryStorage(this._itemStorageMap[param1]);
         }
         else
         {
            _loc4_ = this._defaultItemRendererStorage;
         }
         var _loc3_:Vector.<ITreeItemRenderer> = _loc4_.inactiveItemRenderers;
         _loc4_.inactiveItemRenderers = _loc4_.activeItemRenderers;
         _loc4_.activeItemRenderers = _loc3_;
         if(_loc4_.activeItemRenderers.length > 0)
         {
            throw new IllegalOperationError("TreeDataViewPort: active renderers should be empty.");
         }
         if(param2)
         {
            this.recoverInactiveItemRenderers(_loc4_);
            this.freeInactiveItemRenderers(_loc4_,0);
            if(Boolean(this._typicalItemRenderer) && this._typicalItemRenderer.factoryID === param1)
            {
               if(this._typicalItemIsInDataProvider)
               {
                  _loc5_ = this._typicalItemRenderer.data;
                  if(_loc5_ is XML || _loc5_ is XMLList)
                  {
                     delete this._itemRendererMap[_loc5_.toXMLString()];
                  }
                  else
                  {
                     delete this._itemRendererMap[_loc5_];
                  }
               }
               this.destroyItemRenderer(this._typicalItemRenderer);
               this._typicalItemRenderer = null;
               this._typicalItemIsInDataProvider = false;
            }
         }
         this._layoutItems.length = 0;
      }
      
      private function recoverInactiveItemRenderers(param1:ItemRendererFactoryStorage) : void
      {
         var _loc5_:ITreeItemRenderer = null;
         var _loc6_:Object = null;
         var _loc2_:Vector.<ITreeItemRenderer> = param1.inactiveItemRenderers;
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            if(!(_loc5_ === null || _loc5_.data === null))
            {
               this._owner.dispatchEventWith(FeathersEventType.RENDERER_REMOVE,false,_loc5_);
               _loc6_ = _loc5_.data;
               if(_loc6_ is XML || _loc6_ is XMLList)
               {
                  delete this._itemRendererMap[_loc6_.toXMLString()];
               }
               else
               {
                  delete this._itemRendererMap[_loc6_];
               }
            }
            _loc4_++;
         }
      }
      
      private function freeInactiveItemRenderers(param1:ItemRendererFactoryStorage, param2:int) : void
      {
         var _loc9_:ITreeItemRenderer = null;
         var _loc3_:Vector.<ITreeItemRenderer> = param1.inactiveItemRenderers;
         var _loc4_:Vector.<ITreeItemRenderer> = param1.activeItemRenderers;
         var _loc5_:int = int(_loc4_.length);
         var _loc6_:int = int(_loc3_.length);
         var _loc7_:int = param2 - _loc5_;
         if(_loc7_ > _loc6_)
         {
            _loc7_ = _loc6_;
         }
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            _loc9_ = _loc3_.shift();
            if(!_loc9_)
            {
               _loc7_++;
               if(_loc6_ < _loc7_)
               {
                  _loc7_ = _loc6_;
               }
            }
            else
            {
               _loc9_.data = null;
               _loc9_.location = null;
               _loc9_.visible = false;
               _loc4_[_loc5_] = _loc9_;
               _loc5_++;
            }
            _loc8_++;
         }
         _loc6_ -= _loc7_;
         _loc8_ = 0;
         while(_loc8_ < _loc6_)
         {
            _loc9_ = _loc3_.shift();
            if(_loc9_)
            {
               this.destroyItemRenderer(_loc9_);
            }
            _loc8_++;
         }
      }
      
      private function createItemRenderer(param1:Object, param2:Vector.<int>, param3:int, param4:Boolean, param5:Boolean) : ITreeItemRenderer
      {
         var _loc11_:ITreeItemRenderer = null;
         var _loc6_:String = null;
         if(this._factoryIDFunction !== null)
         {
            _loc6_ = this.getFactoryID(param1,param2);
         }
         var _loc7_:Function = this.factoryIDToFactory(_loc6_);
         var _loc8_:ItemRendererFactoryStorage = this.factoryIDToStorage(_loc6_);
         var _loc9_:Vector.<ITreeItemRenderer> = _loc8_.inactiveItemRenderers;
         var _loc10_:Vector.<ITreeItemRenderer> = _loc8_.activeItemRenderers;
         do
         {
            if(!param4 || param5 || _loc9_.length == 0)
            {
               if(_loc7_ !== null)
               {
                  _loc11_ = ITreeItemRenderer(_loc7_());
               }
               else
               {
                  _loc11_ = ITreeItemRenderer(new this._itemRendererType());
               }
               if(Boolean(this._customItemRendererStyleName) && this._customItemRendererStyleName.length > 0)
               {
                  _loc11_.styleNameList.add(this._customItemRendererStyleName);
               }
               this.addChild(DisplayObject(_loc11_));
            }
            else
            {
               _loc11_ = _loc9_.shift();
            }
         }
         while(!_loc11_);
         _loc11_.data = param1;
         _loc11_.owner = this._owner;
         _loc11_.factoryID = _loc6_;
         _loc11_.location = param2;
         _loc11_.layoutIndex = param3;
         var _loc12_:Boolean = this._dataProvider !== null && this._dataProvider.isBranch(param1);
         _loc11_.isBranch = _loc12_;
         _loc11_.isOpen = _loc12_ && this._openBranches.contains(param1);
         if(!param5)
         {
            if(param1 is XML || param1 is XMLList)
            {
               this._itemRendererMap[param1.toXMLString()] = _loc11_;
            }
            else
            {
               this._itemRendererMap[param1] = _loc11_;
            }
            _loc10_[_loc10_.length] = _loc11_;
            _loc11_.addEventListener(Event.TRIGGERED,this.itemRenderer_triggeredHandler);
            _loc11_.addEventListener(Event.CHANGE,this.itemRenderer_changeHandler);
            _loc11_.addEventListener(FeathersEventType.RESIZE,this.itemRenderer_resizeHandler);
            this._owner.dispatchEventWith(FeathersEventType.RENDERER_ADD,false,_loc11_);
         }
         return _loc11_;
      }
      
      private function destroyItemRenderer(param1:ITreeItemRenderer) : void
      {
         param1.removeEventListener(Event.TRIGGERED,this.itemRenderer_triggeredHandler);
         param1.removeEventListener(Event.CHANGE,this.itemRenderer_changeHandler);
         param1.removeEventListener(FeathersEventType.RESIZE,this.itemRenderer_resizeHandler);
         param1.owner = null;
         param1.data = null;
         param1.location = null;
         param1.layoutIndex = -1;
         param1.factoryID = null;
         this.removeChild(DisplayObject(param1),true);
      }
      
      private function getFactoryID(param1:Object, param2:Vector.<int>) : String
      {
         if(this._factoryIDFunction === null)
         {
            return null;
         }
         if(this._factoryIDFunction.length == 2)
         {
            return this._factoryIDFunction(param1,param2);
         }
         return this._factoryIDFunction(param1);
      }
      
      private function factoryIDToFactory(param1:String) : Function
      {
         if(param1 !== null)
         {
            if(param1 in this._itemRendererFactories)
            {
               return this._itemRendererFactories[param1] as Function;
            }
            throw new ReferenceError("Cannot find item renderer factory for ID \"" + param1 + "\".");
         }
         return this._itemRendererFactory;
      }
      
      private function factoryIDToStorage(param1:String) : ItemRendererFactoryStorage
      {
         var _loc2_:ItemRendererFactoryStorage = null;
         if(param1 !== null)
         {
            if(param1 in this._itemStorageMap)
            {
               return ItemRendererFactoryStorage(this._itemStorageMap[param1]);
            }
            _loc2_ = new ItemRendererFactoryStorage();
            this._itemStorageMap[param1] = _loc2_;
            return _loc2_;
         }
         return this._defaultItemRendererStorage;
      }
      
      private function invalidateParent(param1:String = "all") : void
      {
         Scroller(this.parent).invalidate(param1);
      }
      
      private function refreshSelection() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:ITreeItemRenderer = null;
         for each(_loc1_ in this._layoutItems)
         {
            _loc2_ = _loc1_ as ITreeItemRenderer;
            if(_loc2_ !== null)
            {
               _loc2_.isSelected = _loc2_.data === this._selectedItem;
            }
         }
      }
      
      private function refreshEnabled() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:IFeathersControl = null;
         for each(_loc1_ in this._layoutItems)
         {
            _loc2_ = _loc1_ as IFeathersControl;
            if(_loc2_ !== null)
            {
               _loc2_.isEnabled = this._isEnabled;
            }
         }
      }
      
      private function validateRenderers() : void
      {
         var _loc3_:IValidating = null;
         var _loc1_:int = int(this._layoutItems.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._layoutItems[_loc2_] as IValidating;
            if(_loc3_ !== null)
            {
               _loc3_.validate();
            }
            _loc2_++;
         }
      }
      
      private function layout_changeHandler(param1:Event) : void
      {
         if(this._ignoreLayoutChanges)
         {
            return;
         }
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
         this.invalidateParent(INVALIDATION_FLAG_LAYOUT);
      }
      
      private function dataProvider_changeHandler(param1:Event) : void
      {
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      private function itemRenderer_triggeredHandler(param1:Event) : void
      {
         var _loc2_:ITreeItemRenderer = ITreeItemRenderer(param1.currentTarget);
         this.parent.dispatchEventWith(Event.TRIGGERED,false,_loc2_.data);
      }
      
      private function itemRenderer_changeHandler(param1:Event) : void
      {
         if(this._ignoreSelectionChanges)
         {
            return;
         }
         var _loc2_:ITreeItemRenderer = ITreeItemRenderer(param1.currentTarget);
         if(!this._isSelectable || this._owner.isScrolling)
         {
            _loc2_.isSelected = false;
            return;
         }
         var _loc3_:Boolean = Boolean(_loc2_.isSelected);
         if(_loc3_)
         {
            this.selectedItem = _loc2_.data;
         }
         else
         {
            this.selectedItem = null;
         }
      }
      
      private function itemRenderer_resizeHandler(param1:Event) : void
      {
         if(this._ignoreRendererResizing)
         {
            return;
         }
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
         this.invalidateParent(INVALIDATION_FLAG_LAYOUT);
         if(param1.currentTarget === this._typicalItemRenderer && !this._typicalItemIsInDataProvider)
         {
            return;
         }
         var _loc2_:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
         if(!_loc2_ || !_loc2_.hasVariableItemDimensions)
         {
            return;
         }
         var _loc3_:ITreeItemRenderer = ITreeItemRenderer(param1.currentTarget);
         _loc2_.resetVariableVirtualCacheAtIndex(_loc3_.layoutIndex,DisplayObject(_loc3_));
      }
      
      private function openBranches_changeHandler(param1:Event) : void
      {
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
   }
}

import feathers.controls.renderers.ITreeItemRenderer;

class ItemRendererFactoryStorage
{
   
   public var activeItemRenderers:Vector.<ITreeItemRenderer> = new Vector.<ITreeItemRenderer>(0);
   
   public var inactiveItemRenderers:Vector.<ITreeItemRenderer> = new Vector.<ITreeItemRenderer>(0);
   
   public function ItemRendererFactoryStorage()
   {
      super();
   }
}
