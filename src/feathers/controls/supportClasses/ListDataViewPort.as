package feathers.controls.supportClasses
{
   import feathers.controls.List;
   import feathers.controls.Scroller;
   import feathers.controls.renderers.IDragAndDropItemRenderer;
   import feathers.controls.renderers.IListItemRenderer;
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.IValidating;
   import feathers.core.PropertyProxy;
   import feathers.data.IListCollection;
   import feathers.data.ListCollection;
   import feathers.display.RenderDelegate;
   import feathers.dragDrop.DragData;
   import feathers.dragDrop.DragDropManager;
   import feathers.events.CollectionEventType;
   import feathers.events.DragDropEvent;
   import feathers.events.ExclusiveTouch;
   import feathers.events.FeathersEventType;
   import feathers.layout.IDragDropLayout;
   import feathers.layout.ILayout;
   import feathers.layout.ISpinnerLayout;
   import feathers.layout.ITrimmedVirtualLayout;
   import feathers.layout.IVariableVirtualLayout;
   import feathers.layout.IVirtualLayout;
   import feathers.layout.LayoutBoundsResult;
   import feathers.layout.ViewPortBounds;
   import feathers.motion.effectClasses.IEffectContext;
   import feathers.system.DeviceCapabilities;
   import flash.errors.IllegalOperationError;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.events.EnterFrameEvent;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Pool;
   
   public class ListDataViewPort extends FeathersControl implements IViewPort
   {
      
      private static const INVALIDATION_FLAG_ITEM_RENDERER_FACTORY:String = "itemRendererFactory";
      
      private static const HELPER_VECTOR:Vector.<int> = new Vector.<int>(0);
      
      private var _viewPortBounds:ViewPortBounds = new ViewPortBounds();
      
      private var _layoutResult:LayoutBoundsResult = new LayoutBoundsResult();
      
      private var _actualMinVisibleWidth:Number = 0;
      
      private var _explicitMinVisibleWidth:Number;
      
      private var _maxVisibleWidth:Number = Infinity;
      
      private var actualVisibleWidth:Number = 0;
      
      private var explicitVisibleWidth:Number = NaN;
      
      private var _actualMinVisibleHeight:Number = 0;
      
      private var _explicitMinVisibleHeight:Number;
      
      private var _maxVisibleHeight:Number = Infinity;
      
      private var actualVisibleHeight:Number = 0;
      
      private var explicitVisibleHeight:Number = NaN;
      
      protected var _contentX:Number = 0;
      
      protected var _contentY:Number = 0;
      
      private var _typicalItemIsInDataProvider:Boolean = false;
      
      private var _typicalItemRenderer:IListItemRenderer;
      
      private var _unrenderedData:Array = [];
      
      private var _layoutItems:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
      
      private var _defaultStorage:ItemRendererFactoryStorage = new ItemRendererFactoryStorage();
      
      private var _storageMap:Object;
      
      private var _rendererMap:Dictionary = new Dictionary(true);
      
      private var _minimumItemCount:int;
      
      private var _layoutIndexOffset:int = 0;
      
      private var _layoutIndexRolloverIndex:int = -1;
      
      private var _owner:List;
      
      private var _updateForDataReset:Boolean = false;
      
      private var _dataProvider:IListCollection;
      
      private var _itemRendererType:Class;
      
      private var _itemRendererFactory:Function;
      
      private var _itemRendererFactories:Object;
      
      private var _factoryIDFunction:Function;
      
      private var _customItemRendererStyleName:String;
      
      private var _typicalItem:Object = null;
      
      private var _itemRendererProperties:PropertyProxy;
      
      private var _ignoreLayoutChanges:Boolean = false;
      
      private var _ignoreRendererResizing:Boolean = false;
      
      private var _layout:ILayout;
      
      private var _horizontalScrollPosition:Number = 0;
      
      private var _verticalScrollPosition:Number = 0;
      
      private var _ignoreSelectionChanges:Boolean = false;
      
      private var _isSelectable:Boolean = true;
      
      private var _allowMultipleSelection:Boolean = false;
      
      private var _selectedIndices:ListCollection;
      
      protected var _addItemEffectContexts:Vector.<IEffectContext> = null;
      
      protected var _removeItemEffectContexts:Vector.<IEffectContext> = null;
      
      protected var _addedItems:Dictionary = null;
      
      protected var _removedItems:Dictionary = null;
      
      protected var _dragTouchPointID:int = -1;
      
      protected var _dragFormat:String;
      
      protected var _dragEnabled:Boolean = false;
      
      protected var _dropEnabled:Boolean = false;
      
      protected var _minimumAutoScrollDistance:Number = 0.04;
      
      protected var _droppedOnSelf:Boolean = false;
      
      protected var _explicitDropIndicatorWidth:Number = NaN;
      
      protected var _explicitDropIndicatorHeight:Number = NaN;
      
      protected var _dropIndicatorSkin:DisplayObject = null;
      
      protected var _startDragX:Number;
      
      protected var _startDragY:Number;
      
      protected var _dragLocalX:Number = -1;
      
      protected var _dragLocalY:Number = -1;
      
      protected var _acceptedDrag:Boolean = false;
      
      protected var _minimumDragDropDistance:Number = 0.04;
      
      public function ListDataViewPort()
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
            if(this.explicitVisibleWidth !== this.explicitVisibleWidth && (this.actualVisibleWidth < param1 || this.actualVisibleWidth == _loc3_))
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
         if(this.explicitVisibleWidth !== this.explicitVisibleWidth && (this.actualVisibleWidth > param1 || this.actualVisibleWidth == _loc2_))
         {
            this.invalidate(INVALIDATION_FLAG_SIZE);
         }
      }
      
      public function get visibleWidth() : Number
      {
         return this.actualVisibleWidth;
      }
      
      public function set visibleWidth(param1:Number) : void
      {
         if(this.explicitVisibleWidth == param1 || param1 !== param1 && this.explicitVisibleWidth !== this.explicitVisibleWidth)
         {
            return;
         }
         this.explicitVisibleWidth = param1;
         if(this.actualVisibleWidth != param1)
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
            if(this.explicitVisibleHeight !== this.explicitVisibleHeight && (this.actualVisibleHeight < param1 || this.actualVisibleHeight == _loc3_))
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
         if(this.explicitVisibleHeight !== this.explicitVisibleHeight && (this.actualVisibleHeight > param1 || this.actualVisibleHeight == _loc2_))
         {
            this.invalidate(INVALIDATION_FLAG_SIZE);
         }
      }
      
      public function get visibleHeight() : Number
      {
         return this.actualVisibleHeight;
      }
      
      public function set visibleHeight(param1:Number) : void
      {
         if(this.explicitVisibleHeight == param1 || param1 !== param1 && this.explicitVisibleHeight !== this.explicitVisibleHeight)
         {
            return;
         }
         this.explicitVisibleHeight = param1;
         if(this.actualVisibleHeight != param1)
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
      
      public function get owner() : List
      {
         return this._owner;
      }
      
      public function set owner(param1:List) : void
      {
         if(this._owner == param1)
         {
            return;
         }
         if(this._owner)
         {
            this._owner.removeEventListener(DragDropEvent.DRAG_ENTER,this.dragEnterHandler);
            this._owner.removeEventListener(DragDropEvent.DRAG_MOVE,this.dragMoveHandler);
            this._owner.removeEventListener(DragDropEvent.DRAG_EXIT,this.dragExitHandler);
            this._owner.removeEventListener(DragDropEvent.DRAG_DROP,this.dragDropHandler);
            this._owner.removeEventListener(DragDropEvent.DRAG_COMPLETE,this.dragCompleteHandler);
         }
         this._owner = param1;
         if(this._owner)
         {
            this._owner.addEventListener(DragDropEvent.DRAG_ENTER,this.dragEnterHandler);
            this._owner.addEventListener(DragDropEvent.DRAG_MOVE,this.dragMoveHandler);
            this._owner.addEventListener(DragDropEvent.DRAG_EXIT,this.dragExitHandler);
            this._owner.addEventListener(DragDropEvent.DRAG_DROP,this.dragDropHandler);
            this._owner.addEventListener(DragDropEvent.DRAG_COMPLETE,this.dragCompleteHandler);
         }
      }
      
      public function get dataProvider() : IListCollection
      {
         return this._dataProvider;
      }
      
      public function set dataProvider(param1:IListCollection) : void
      {
         if(this._dataProvider == param1)
         {
            return;
         }
         if(this._dataProvider)
         {
            this._dataProvider.removeEventListener(Event.CHANGE,this.dataProvider_changeHandler);
            this._dataProvider.removeEventListener(CollectionEventType.RESET,this.dataProvider_resetHandler);
            this._dataProvider.removeEventListener(CollectionEventType.FILTER_CHANGE,this.dataProvider_filterChangeHandler);
            this._dataProvider.removeEventListener(CollectionEventType.ADD_ITEM,this.dataProvider_addItemHandler);
            this._dataProvider.removeEventListener(CollectionEventType.REMOVE_ITEM,this.dataProvider_removeItemHandler);
            this._dataProvider.removeEventListener(CollectionEventType.REPLACE_ITEM,this.dataProvider_replaceItemHandler);
            this._dataProvider.removeEventListener(CollectionEventType.UPDATE_ITEM,this.dataProvider_updateItemHandler);
            this._dataProvider.removeEventListener(CollectionEventType.UPDATE_ALL,this.dataProvider_updateAllHandler);
         }
         this._dataProvider = param1;
         if(this._dataProvider)
         {
            this._dataProvider.addEventListener(Event.CHANGE,this.dataProvider_changeHandler);
            this._dataProvider.addEventListener(CollectionEventType.RESET,this.dataProvider_resetHandler);
            this._dataProvider.addEventListener(CollectionEventType.FILTER_CHANGE,this.dataProvider_filterChangeHandler);
            this._dataProvider.addEventListener(CollectionEventType.ADD_ITEM,this.dataProvider_addItemHandler);
            this._dataProvider.addEventListener(CollectionEventType.REMOVE_ITEM,this.dataProvider_removeItemHandler);
            this._dataProvider.addEventListener(CollectionEventType.REPLACE_ITEM,this.dataProvider_replaceItemHandler);
            this._dataProvider.addEventListener(CollectionEventType.UPDATE_ITEM,this.dataProvider_updateItemHandler);
            this._dataProvider.addEventListener(CollectionEventType.UPDATE_ALL,this.dataProvider_updateAllHandler);
         }
         if(this._layout is IVariableVirtualLayout)
         {
            IVariableVirtualLayout(this._layout).resetVariableVirtualCache();
         }
         this._updateForDataReset = true;
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
         if(param1 !== null)
         {
            this._storageMap = {};
         }
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
      
      public function get itemRendererProperties() : PropertyProxy
      {
         return this._itemRendererProperties;
      }
      
      public function set itemRendererProperties(param1:PropertyProxy) : void
      {
         if(this._itemRendererProperties == param1)
         {
            return;
         }
         if(this._itemRendererProperties)
         {
            this._itemRendererProperties.removeOnChangeCallback(this.childProperties_onChange);
         }
         this._itemRendererProperties = PropertyProxy(param1);
         if(this._itemRendererProperties)
         {
            this._itemRendererProperties.addOnChangeCallback(this.childProperties_onChange);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get layout() : ILayout
      {
         return this._layout;
      }
      
      public function set layout(param1:ILayout) : void
      {
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
               IVariableVirtualLayout(this._layout).resetVariableVirtualCache();
            }
            this._layout.addEventListener(Event.CHANGE,this.layout_changeHandler);
         }
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
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
         if(!param1)
         {
            this.selectedIndices = null;
         }
      }
      
      public function get allowMultipleSelection() : Boolean
      {
         return this._allowMultipleSelection;
      }
      
      public function set allowMultipleSelection(param1:Boolean) : void
      {
         this._allowMultipleSelection = param1;
      }
      
      public function get selectedIndices() : ListCollection
      {
         return this._selectedIndices;
      }
      
      public function set selectedIndices(param1:ListCollection) : void
      {
         if(this._selectedIndices == param1)
         {
            return;
         }
         if(this._selectedIndices)
         {
            this._selectedIndices.removeEventListener(Event.CHANGE,this.selectedIndices_changeHandler);
         }
         this._selectedIndices = param1;
         if(this._selectedIndices)
         {
            this._selectedIndices.addEventListener(Event.CHANGE,this.selectedIndices_changeHandler);
         }
         this.invalidate(INVALIDATION_FLAG_SELECTED);
      }
      
      public function get addedItems() : Dictionary
      {
         return this._addedItems;
      }
      
      public function set addedItems(param1:Dictionary) : void
      {
         if(this._addedItems === param1)
         {
            return;
         }
         this._addedItems = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get removedItems() : Dictionary
      {
         return this._removedItems;
      }
      
      public function set removedItems(param1:Dictionary) : void
      {
         if(this._removedItems === param1)
         {
            return;
         }
         this._removedItems = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get dragFormat() : String
      {
         return this._dragFormat;
      }
      
      public function set dragFormat(param1:String) : void
      {
         this._dragFormat = param1;
      }
      
      public function get dragEnabled() : Boolean
      {
         return this._dragEnabled;
      }
      
      public function set dragEnabled(param1:Boolean) : void
      {
         this._dragEnabled = param1;
      }
      
      public function get dropEnabled() : Boolean
      {
         return this._dropEnabled;
      }
      
      public function set dropEnabled(param1:Boolean) : void
      {
         this._dropEnabled = param1;
      }
      
      public function get minimumAutoScrollDistance() : Number
      {
         return this._minimumAutoScrollDistance;
      }
      
      public function set minimumAutoScrollDistance(param1:Number) : void
      {
         this._minimumAutoScrollDistance = param1;
      }
      
      public function get dropIndicatorSkin() : DisplayObject
      {
         return this._dropIndicatorSkin;
      }
      
      public function set dropIndicatorSkin(param1:DisplayObject) : void
      {
         var _loc2_:IMeasureDisplayObject = null;
         if(this._dropIndicatorSkin === param1)
         {
            return;
         }
         this._dropIndicatorSkin = param1;
         if(this._dropIndicatorSkin is IMeasureDisplayObject)
         {
            _loc2_ = IMeasureDisplayObject(this._dropIndicatorSkin);
            this._explicitDropIndicatorWidth = _loc2_.explicitWidth;
            this._explicitDropIndicatorHeight = _loc2_.explicitHeight;
         }
         else if(this._dropIndicatorSkin)
         {
            this._explicitDropIndicatorWidth = this._dropIndicatorSkin.width;
            this._explicitDropIndicatorHeight = this._dropIndicatorSkin.height;
         }
      }
      
      public function get minimumDragDropDistance() : Number
      {
         return this._minimumDragDropDistance;
      }
      
      public function set minimumDragDropDistance(param1:Number) : void
      {
         this._minimumDragDropDistance = param1;
      }
      
      public function get requiresMeasurementOnScroll() : Boolean
      {
         return this._layout.requiresLayoutOnScroll && (this.explicitVisibleWidth !== this.explicitVisibleWidth || this.explicitVisibleHeight !== this.explicitVisibleHeight);
      }
      
      public function calculateNavigationDestination(param1:int, param2:uint) : int
      {
         return this._layout.calculateNavigationDestination(this._layoutItems,param1,param2,this._layoutResult);
      }
      
      public function getScrollPositionForIndex(param1:int, param2:Point = null) : Point
      {
         if(!param2)
         {
            param2 = new Point();
         }
         return this._layout.getScrollPositionForIndex(param1,this._layoutItems,0,0,this.actualVisibleWidth,this.actualVisibleHeight,param2);
      }
      
      public function getNearestScrollPositionForIndex(param1:int, param2:Point = null) : Point
      {
         if(!param2)
         {
            param2 = new Point();
         }
         return this._layout.getNearestScrollPositionForIndex(param1,this._horizontalScrollPosition,this._verticalScrollPosition,this._layoutItems,0,0,this.actualVisibleWidth,this.actualVisibleHeight,param2);
      }
      
      public function itemToItemRenderer(param1:Object) : IListItemRenderer
      {
         return IListItemRenderer(this._rendererMap[param1]);
      }
      
      override public function dispose() : void
      {
         var _loc1_:String = null;
         if(this._dropIndicatorSkin !== null && this._dropIndicatorSkin.parent === null)
         {
            this._dropIndicatorSkin.dispose();
            this._dropIndicatorSkin = null;
         }
         this.refreshInactiveRenderers(null,true);
         if(this._storageMap)
         {
            for(_loc1_ in this._storageMap)
            {
               this.refreshInactiveRenderers(_loc1_,true);
            }
         }
         this.owner = null;
         this.layout = null;
         this.dataProvider = null;
         super.dispose();
      }
      
      override public function hitTest(param1:Point) : DisplayObject
      {
         var _loc2_:DisplayObject = super.hitTest(param1);
         if(Boolean(_loc2_) && this._acceptedDrag)
         {
            return this._owner;
         }
         return _loc2_;
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
            this.refreshInactiveRenderers(null,_loc5_);
            if(this._storageMap)
            {
               for(_loc12_ in this._storageMap)
               {
                  this.refreshInactiveRenderers(_loc12_,_loc5_);
               }
            }
         }
         if(_loc1_ || _loc8_ || _loc5_)
         {
            this.refreshLayoutTypicalItem();
         }
         if(_loc9_)
         {
            this.refreshRenderers();
         }
         if(_loc6_ || _loc9_)
         {
            this.refreshItemRendererStyles();
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
         this.actualVisibleWidth = this._layoutResult.viewPortWidth;
         this.actualVisibleHeight = this._layoutResult.viewPortHeight;
         this._actualMinVisibleWidth = this._layoutResult.viewPortWidth;
         this._actualMinVisibleHeight = this._layoutResult.viewPortHeight;
         this.validateItemRenderers();
         this.handlePendingItemRendererEffects();
         if(_loc2_ && this.hasEventListener(Event.ENTER_FRAME,this.dragScroll_enterFrameHandler))
         {
            this.refreshDropIndicator(this._dragLocalX,this._dragLocalY);
         }
      }
      
      private function handlePendingItemRendererEffects() : void
      {
         var _loc1_:Object = null;
         var _loc2_:IListItemRenderer = null;
         var _loc3_:Function = null;
         var _loc4_:IEffectContext = null;
         if(this._addedItems !== null)
         {
            if(this._addItemEffectContexts === null)
            {
               this._addItemEffectContexts = new Vector.<IEffectContext>(0);
            }
            for(_loc1_ in this._addedItems)
            {
               _loc2_ = this._rendererMap[_loc1_] as IListItemRenderer;
               if(_loc2_ !== null)
               {
                  this.interruptRemoveItemEffects(_loc2_,false);
                  _loc3_ = this._addedItems[_loc1_] as Function;
                  _loc4_ = IEffectContext(_loc3_(_loc2_));
                  _loc4_.addEventListener(Event.COMPLETE,this.addedItemEffectContext_completeHandler);
                  this._addItemEffectContexts[this._addItemEffectContexts.length] = _loc4_;
                  _loc4_.play();
               }
            }
            this._addedItems = null;
         }
         if(this._removedItems !== null)
         {
            if(this._removeItemEffectContexts === null)
            {
               this._removeItemEffectContexts = new Vector.<IEffectContext>(0);
            }
            for(_loc1_ in this._removedItems)
            {
               _loc2_ = this._rendererMap[_loc1_] as IListItemRenderer;
               if(_loc2_ !== null)
               {
                  this.interruptRemoveItemEffects(_loc2_,true);
                  this.interruptAddItemEffects(_loc2_);
                  _loc3_ = this._removedItems[_loc1_] as Function;
                  _loc4_ = IEffectContext(_loc3_(_loc2_));
                  _loc4_.addEventListener(Event.COMPLETE,this.removedItemEffectContext_completeHandler);
                  this._removeItemEffectContexts[this._removeItemEffectContexts.length] = _loc4_;
                  _loc4_.play();
               }
            }
            this._removedItems = null;
         }
      }
      
      private function interruptAddItemEffects(param1:IListItemRenderer) : void
      {
         var _loc4_:IEffectContext = null;
         if(this._addItemEffectContexts === null)
         {
            return;
         }
         var _loc2_:* = int(this._addItemEffectContexts.length);
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._addItemEffectContexts[_loc3_];
            if(_loc4_.target === param1)
            {
               _loc4_.interrupt();
               _loc3_--;
               _loc2_--;
            }
            _loc3_++;
         }
      }
      
      private function interruptRemoveItemEffects(param1:IListItemRenderer, param2:Boolean) : void
      {
         var _loc5_:IEffectContext = null;
         if(this._removeItemEffectContexts === null)
         {
            return;
         }
         var _loc3_:* = int(this._removeItemEffectContexts.length);
         var _loc4_:* = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this._removeItemEffectContexts[_loc4_];
            if(_loc5_.target === param1)
            {
               if(param2)
               {
                  _loc5_.stop();
               }
               else
               {
                  _loc5_.interrupt();
               }
               _loc4_--;
               _loc3_--;
            }
            _loc4_++;
         }
      }
      
      private function invalidateParent(param1:String = "all") : void
      {
         Scroller(this.parent).invalidate(param1);
      }
      
      private function validateItemRenderers() : void
      {
         var _loc3_:IValidating = null;
         var _loc1_:int = int(this._layoutItems.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._layoutItems[_loc2_] as IValidating;
            if(_loc3_)
            {
               _loc3_.validate();
            }
            _loc2_++;
         }
      }
      
      private function refreshLayoutTypicalItem() : void
      {
         var _loc5_:IListItemRenderer = null;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:String = null;
         var _loc1_:IVirtualLayout = this._layout as IVirtualLayout;
         if(!_loc1_ || !_loc1_.useVirtualLayout)
         {
            if(!this._typicalItemIsInDataProvider && Boolean(this._typicalItemRenderer))
            {
               this.destroyRenderer(this._typicalItemRenderer);
               this._typicalItemRenderer = null;
            }
            return;
         }
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:Object = this._typicalItem;
         if(_loc4_ !== null)
         {
            if(this._dataProvider)
            {
               _loc2_ = this._dataProvider.getItemIndex(_loc4_);
               _loc3_ = _loc2_ >= 0;
            }
            if(_loc2_ < 0)
            {
               _loc2_ = 0;
            }
         }
         else if(Boolean(this._dataProvider) && this._dataProvider.length > 0)
         {
            _loc3_ = true;
            _loc4_ = this._dataProvider.getItemAt(0);
         }
         if(_loc4_ !== null || _loc3_)
         {
            _loc5_ = IListItemRenderer(this._rendererMap[_loc4_]);
            if(_loc5_)
            {
               _loc5_.index = _loc2_;
               if(_loc5_ is IDragAndDropItemRenderer)
               {
                  IDragAndDropItemRenderer(_loc5_).dragEnabled = this._dragEnabled;
               }
            }
            if(!_loc5_ && Boolean(this._typicalItemRenderer))
            {
               _loc6_ = !this._typicalItemIsInDataProvider;
               _loc7_ = this._typicalItemIsInDataProvider && Boolean(this._dataProvider) && this._dataProvider.getItemIndex(this._typicalItemRenderer.data) < 0;
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
                     delete this._rendererMap[this._typicalItemRenderer.data];
                  }
                  _loc5_ = this._typicalItemRenderer;
                  _loc5_.data = _loc4_;
                  _loc5_.index = _loc2_;
                  if(_loc3_)
                  {
                     this._rendererMap[_loc4_] = _loc5_;
                  }
               }
            }
            if(!_loc5_)
            {
               _loc5_ = this.createRenderer(_loc4_,_loc2_,false,!_loc3_);
               if(!this._typicalItemIsInDataProvider && Boolean(this._typicalItemRenderer))
               {
                  this.destroyRenderer(this._typicalItemRenderer);
                  this._typicalItemRenderer = null;
               }
            }
         }
         _loc1_.typicalItem = DisplayObject(_loc5_);
         this._typicalItemRenderer = _loc5_;
         this._typicalItemIsInDataProvider = _loc3_;
         if(Boolean(this._typicalItemRenderer) && !this._typicalItemIsInDataProvider)
         {
            this._typicalItemRenderer.addEventListener(FeathersEventType.RESIZE,this.renderer_resizeHandler);
         }
      }
      
      private function refreshItemRendererStyles() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:IListItemRenderer = null;
         for each(_loc1_ in this._layoutItems)
         {
            _loc2_ = _loc1_ as IListItemRenderer;
            if(_loc2_)
            {
               this.refreshOneItemRendererStyles(_loc2_);
            }
         }
      }
      
      private function refreshOneItemRendererStyles(param1:IListItemRenderer) : void
      {
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc2_:DisplayObject = DisplayObject(param1);
         for(_loc3_ in this._itemRendererProperties)
         {
            _loc4_ = this._itemRendererProperties[_loc3_];
            _loc2_[_loc3_] = _loc4_;
         }
      }
      
      private function refreshSelection() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:IListItemRenderer = null;
         for each(_loc1_ in this._layoutItems)
         {
            _loc2_ = _loc1_ as IListItemRenderer;
            if(_loc2_)
            {
               _loc2_.isSelected = this._selectedIndices.getItemIndex(_loc2_.index) >= 0;
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
            if(_loc2_)
            {
               _loc2_.isEnabled = this._isEnabled;
            }
         }
      }
      
      private function refreshViewPortBounds() : void
      {
         var _loc1_:Boolean = this._explicitMinVisibleWidth !== this._explicitMinVisibleWidth;
         var _loc2_:Boolean = this._explicitMinVisibleHeight !== this._explicitMinVisibleHeight;
         this._viewPortBounds.x = 0;
         this._viewPortBounds.y = 0;
         this._viewPortBounds.scrollX = this._horizontalScrollPosition;
         this._viewPortBounds.scrollY = this._verticalScrollPosition;
         this._viewPortBounds.explicitWidth = this.explicitVisibleWidth;
         this._viewPortBounds.explicitHeight = this.explicitVisibleHeight;
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
      
      private function refreshInactiveRenderers(param1:String, param2:Boolean) : void
      {
         var _loc4_:ItemRendererFactoryStorage = null;
         if(param1 !== null)
         {
            _loc4_ = ItemRendererFactoryStorage(this._storageMap[param1]);
         }
         else
         {
            _loc4_ = this._defaultStorage;
         }
         var _loc3_:Vector.<IListItemRenderer> = _loc4_.inactiveItemRenderers;
         _loc4_.inactiveItemRenderers = _loc4_.activeItemRenderers;
         _loc4_.activeItemRenderers = _loc3_;
         if(_loc4_.activeItemRenderers.length > 0)
         {
            throw new IllegalOperationError("ListDataViewPort: active renderers should be empty.");
         }
         if(param2)
         {
            this.recoverInactiveRenderers(_loc4_);
            this.freeInactiveRenderers(_loc4_,0);
            if(Boolean(this._typicalItemRenderer) && this._typicalItemRenderer.factoryID === param1)
            {
               if(this._typicalItemIsInDataProvider)
               {
                  delete this._rendererMap[this._typicalItemRenderer.data];
               }
               this.destroyRenderer(this._typicalItemRenderer);
               this._typicalItemRenderer = null;
               this._typicalItemIsInDataProvider = false;
            }
         }
         this._layoutItems.length = 0;
      }
      
      private function refreshRenderers() : void
      {
         var _loc1_:ItemRendererFactoryStorage = null;
         var _loc2_:Vector.<IListItemRenderer> = null;
         var _loc3_:Vector.<IListItemRenderer> = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         if(this._typicalItemRenderer)
         {
            if(this._typicalItemIsInDataProvider)
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
            this.refreshOneItemRendererStyles(this._typicalItemRenderer);
         }
         this.findUnrenderedData();
         this.recoverInactiveRenderers(this._defaultStorage);
         if(this._storageMap)
         {
            for(_loc6_ in this._storageMap)
            {
               _loc1_ = ItemRendererFactoryStorage(this._storageMap[_loc6_]);
               this.recoverInactiveRenderers(_loc1_);
            }
         }
         this.renderUnrenderedData();
         this.freeInactiveRenderers(this._defaultStorage,this._minimumItemCount);
         if(this._storageMap)
         {
            for(_loc6_ in this._storageMap)
            {
               _loc1_ = ItemRendererFactoryStorage(this._storageMap[_loc6_]);
               this.freeInactiveRenderers(_loc1_,1);
            }
         }
         this._updateForDataReset = false;
      }
      
      private function findUnrenderedData() : void
      {
         var _loc7_:Point = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:ITrimmedVirtualLayout = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:Object = null;
         var _loc18_:IListItemRenderer = null;
         var _loc19_:String = null;
         var _loc20_:ItemRendererFactoryStorage = null;
         var _loc21_:Vector.<IListItemRenderer> = null;
         var _loc22_:Vector.<IListItemRenderer> = null;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc1_:int = this._dataProvider ? this._dataProvider.length : 0;
         var _loc2_:IVirtualLayout = this._layout as IVirtualLayout;
         var _loc3_:Boolean = Boolean(_loc2_) && _loc2_.useVirtualLayout;
         if(_loc3_)
         {
            _loc7_ = Pool.getPoint();
            _loc2_.measureViewPort(_loc1_,this._viewPortBounds,_loc7_);
            _loc2_.getVisibleIndicesAtScrollPosition(this._horizontalScrollPosition,this._verticalScrollPosition,_loc7_.x,_loc7_.y,_loc1_,HELPER_VECTOR);
            Pool.putPoint(_loc7_);
         }
         var _loc4_:int = _loc3_ ? int(HELPER_VECTOR.length) : _loc1_;
         if(Boolean(_loc3_ && this._typicalItemIsInDataProvider) && Boolean(this._typicalItemRenderer) && HELPER_VECTOR.indexOf(this._typicalItemRenderer.index) >= 0)
         {
            this._minimumItemCount = _loc4_ + 1;
         }
         else
         {
            this._minimumItemCount = _loc4_;
         }
         var _loc5_:Boolean = this._layout is ITrimmedVirtualLayout && _loc3_ && (!(this._layout is IVariableVirtualLayout) || !IVariableVirtualLayout(this._layout).hasVariableItemDimensions) && _loc4_ > 0;
         if(_loc5_)
         {
            _loc9_ = _loc8_ = HELPER_VECTOR[0];
            _loc10_ = 1;
            while(_loc10_ < _loc4_)
            {
               _loc12_ = HELPER_VECTOR[_loc10_];
               if(_loc12_ < _loc8_)
               {
                  _loc8_ = _loc12_;
               }
               if(_loc12_ > _loc9_)
               {
                  _loc9_ = _loc12_;
               }
               _loc10_++;
            }
            if(this._layout is ISpinnerLayout && _loc8_ == 0 && _loc9_ == this._dataProvider.length - 1 && HELPER_VECTOR[0] > HELPER_VECTOR[HELPER_VECTOR.length - 1])
            {
               _loc13_ = HELPER_VECTOR[0] - this._dataProvider.length;
               _loc14_ = HELPER_VECTOR[HELPER_VECTOR.length - 1];
               _loc15_ = _loc13_;
               _loc16_ = _loc1_ - 1 - _loc14_ + _loc15_;
               this._layoutItems.length = HELPER_VECTOR.length;
               this._layoutIndexOffset = -_loc15_;
               this._layoutIndexRolloverIndex = HELPER_VECTOR[0];
            }
            else
            {
               _loc15_ = _loc8_ - 1;
               if(_loc15_ < 0)
               {
                  _loc15_ = 0;
               }
               _loc16_ = _loc1_ - 1 - _loc9_;
               this._layoutItems.length = _loc1_ - _loc15_ - _loc16_;
               this._layoutIndexOffset = -_loc15_;
               this._layoutIndexRolloverIndex = -1;
            }
            _loc11_ = ITrimmedVirtualLayout(this._layout);
            _loc11_.beforeVirtualizedItemCount = _loc15_;
            _loc11_.afterVirtualizedItemCount = _loc16_;
         }
         else
         {
            this._layoutIndexOffset = 0;
            this._layoutItems.length = _loc1_;
         }
         var _loc6_:int = int(this._unrenderedData.length);
         _loc10_ = 0;
         while(_loc10_ < _loc4_)
         {
            _loc12_ = _loc3_ ? HELPER_VECTOR[_loc10_] : int(_loc10_);
            if(!(_loc12_ < 0 || _loc12_ >= _loc1_))
            {
               _loc17_ = this._dataProvider.getItemAt(_loc12_);
               _loc18_ = IListItemRenderer(this._rendererMap[_loc17_]);
               if(this._factoryIDFunction !== null && _loc18_ !== null)
               {
                  _loc19_ = this.getFactoryID(_loc18_.data,_loc12_);
                  if(_loc19_ !== _loc18_.factoryID)
                  {
                     _loc18_ = null;
                     delete this._rendererMap[_loc17_];
                  }
               }
               if(_loc18_ !== null)
               {
                  _loc18_.index = _loc12_;
                  if(_loc18_ is IDragAndDropItemRenderer)
                  {
                     IDragAndDropItemRenderer(_loc18_).dragEnabled = this._dragEnabled;
                  }
                  _loc18_.visible = true;
                  if(this._updateForDataReset)
                  {
                     _loc18_.data = null;
                     _loc18_.data = _loc17_;
                  }
                  if(this._typicalItemRenderer !== _loc18_)
                  {
                     _loc20_ = this.factoryIDToStorage(_loc18_.factoryID);
                     _loc21_ = _loc20_.activeItemRenderers;
                     _loc22_ = _loc20_.inactiveItemRenderers;
                     _loc21_[_loc21_.length] = _loc18_;
                     _loc23_ = _loc22_.indexOf(_loc18_);
                     if(_loc23_ < 0)
                     {
                        throw new IllegalOperationError("ListDataViewPort: renderer map contains bad data. This may be caused by duplicate items in the data provider, which is not allowed.");
                     }
                     _loc22_[_loc23_] = null;
                  }
                  if(this._layoutIndexRolloverIndex == -1 || _loc12_ < this._layoutIndexRolloverIndex)
                  {
                     _loc24_ = _loc12_ + this._layoutIndexOffset;
                  }
                  else
                  {
                     _loc24_ = _loc12_ - this._dataProvider.length + this._layoutIndexOffset;
                  }
                  this._layoutItems[_loc24_] = DisplayObject(_loc18_);
               }
               else
               {
                  this._unrenderedData[_loc6_] = _loc17_;
                  _loc6_++;
               }
            }
            _loc10_++;
         }
         if(this._typicalItemRenderer)
         {
            if(_loc3_ && this._typicalItemIsInDataProvider)
            {
               _loc12_ = HELPER_VECTOR.indexOf(this._typicalItemRenderer.index);
               if(_loc12_ >= 0)
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
      
      private function renderUnrenderedData() : void
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:IListItemRenderer = null;
         var _loc6_:int = 0;
         var _loc1_:int = int(this._unrenderedData.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._unrenderedData.shift();
            _loc4_ = this._dataProvider.getItemIndex(_loc3_);
            _loc5_ = this.createRenderer(_loc3_,_loc4_,true,false);
            _loc5_.visible = true;
            if(this._layoutIndexRolloverIndex == -1 || _loc4_ < this._layoutIndexRolloverIndex)
            {
               _loc6_ = _loc4_ + this._layoutIndexOffset;
            }
            else
            {
               _loc6_ = _loc4_ - this._dataProvider.length + this._layoutIndexOffset;
            }
            this._layoutItems[_loc6_] = DisplayObject(_loc5_);
            _loc2_++;
         }
      }
      
      private function recoverInactiveRenderers(param1:ItemRendererFactoryStorage) : void
      {
         var _loc5_:IListItemRenderer = null;
         var _loc2_:Vector.<IListItemRenderer> = param1.inactiveItemRenderers;
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            if(!(!_loc5_ || _loc5_.index < 0))
            {
               this._owner.dispatchEventWith(FeathersEventType.RENDERER_REMOVE,false,_loc5_);
               delete this._rendererMap[_loc5_.data];
            }
            _loc4_++;
         }
      }
      
      private function freeInactiveRenderers(param1:ItemRendererFactoryStorage, param2:int) : void
      {
         var _loc9_:IListItemRenderer = null;
         var _loc3_:Vector.<IListItemRenderer> = param1.inactiveItemRenderers;
         var _loc4_:Vector.<IListItemRenderer> = param1.activeItemRenderers;
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
               _loc9_.index = -1;
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
               this.destroyRenderer(_loc9_);
            }
            _loc8_++;
         }
      }
      
      private function createRenderer(param1:Object, param2:int, param3:Boolean, param4:Boolean) : IListItemRenderer
      {
         var _loc10_:IListItemRenderer = null;
         var _loc5_:String = null;
         if(this._factoryIDFunction !== null)
         {
            _loc5_ = this.getFactoryID(param1,param2);
         }
         var _loc6_:Function = this.factoryIDToFactory(_loc5_);
         var _loc7_:ItemRendererFactoryStorage = this.factoryIDToStorage(_loc5_);
         var _loc8_:Vector.<IListItemRenderer> = _loc7_.inactiveItemRenderers;
         var _loc9_:Vector.<IListItemRenderer> = _loc7_.activeItemRenderers;
         do
         {
            if(!param3 || param4 || _loc8_.length == 0)
            {
               if(_loc6_ !== null)
               {
                  _loc10_ = IListItemRenderer(_loc6_());
               }
               else
               {
                  _loc10_ = IListItemRenderer(new this._itemRendererType());
               }
               if(Boolean(this._customItemRendererStyleName) && this._customItemRendererStyleName.length > 0)
               {
                  _loc10_.styleNameList.add(this._customItemRendererStyleName);
               }
               this.addChild(DisplayObject(_loc10_));
            }
            else
            {
               _loc10_ = _loc8_.shift();
            }
         }
         while(!_loc10_);
         _loc10_.data = param1;
         _loc10_.index = param2;
         _loc10_.owner = this._owner;
         _loc10_.factoryID = _loc5_;
         if(_loc10_ is IDragAndDropItemRenderer)
         {
            IDragAndDropItemRenderer(_loc10_).dragEnabled = this._dragEnabled;
         }
         if(!param4)
         {
            this._rendererMap[param1] = _loc10_;
            _loc9_[_loc9_.length] = _loc10_;
            _loc10_.addEventListener(Event.TRIGGERED,this.renderer_triggeredHandler);
            _loc10_.addEventListener(Event.CHANGE,this.renderer_changeHandler);
            _loc10_.addEventListener(FeathersEventType.RESIZE,this.renderer_resizeHandler);
            _loc10_.addEventListener(TouchEvent.TOUCH,this.itemRenderer_drag_touchHandler);
            this._owner.dispatchEventWith(FeathersEventType.RENDERER_ADD,false,_loc10_);
         }
         return _loc10_;
      }
      
      private function destroyRenderer(param1:IListItemRenderer) : void
      {
         param1.removeEventListener(Event.TRIGGERED,this.renderer_triggeredHandler);
         param1.removeEventListener(Event.CHANGE,this.renderer_changeHandler);
         param1.removeEventListener(FeathersEventType.RESIZE,this.renderer_resizeHandler);
         param1.removeEventListener(TouchEvent.TOUCH,this.itemRenderer_drag_touchHandler);
         param1.owner = null;
         param1.data = null;
         param1.factoryID = null;
         this.removeChild(DisplayObject(param1),true);
      }
      
      private function getFactoryID(param1:Object, param2:int) : String
      {
         if(this._factoryIDFunction === null)
         {
            return null;
         }
         if(this._factoryIDFunction.length == 1)
         {
            return this._factoryIDFunction(param1);
         }
         return this._factoryIDFunction(param1,param2);
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
            if(param1 in this._storageMap)
            {
               return ItemRendererFactoryStorage(this._storageMap[param1]);
            }
            _loc2_ = new ItemRendererFactoryStorage();
            this._storageMap[param1] = _loc2_;
            return _loc2_;
         }
         return this._defaultStorage;
      }
      
      protected function refreshDropIndicator(param1:Number, param2:Number) : void
      {
         if(!this._dropIndicatorSkin || !(this._layout is IDragDropLayout))
         {
            return;
         }
         var _loc3_:IDragDropLayout = IDragDropLayout(this._layout);
         this._dropIndicatorSkin.width = this._explicitDropIndicatorWidth;
         this._dropIndicatorSkin.height = this._explicitDropIndicatorHeight;
         var _loc4_:Number = this._horizontalScrollPosition + param1;
         var _loc5_:Number = this._verticalScrollPosition + param2;
         var _loc6_:int = _loc3_.getDropIndex(_loc4_,_loc5_,this._layoutItems,0,0,this.actualVisibleWidth,this.actualVisibleHeight);
         _loc3_.positionDropIndicator(this._dropIndicatorSkin,_loc6_,_loc4_,_loc5_,this._layoutItems,this.actualVisibleWidth,this.actualVisibleHeight);
         this.addChild(this._dropIndicatorSkin);
      }
      
      private function childProperties_onChange(param1:PropertyProxy, param2:String) : void
      {
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      private function dataProvider_changeHandler(param1:Event) : void
      {
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      private function dataProvider_addItemHandler(param1:Event, param2:int) : void
      {
         var _loc3_:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
         if(!_loc3_ || !_loc3_.hasVariableItemDimensions)
         {
            return;
         }
         _loc3_.addToVariableVirtualCacheAtIndex(param2);
      }
      
      private function dataProvider_removeItemHandler(param1:Event, param2:int) : void
      {
         var _loc3_:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
         if(!_loc3_ || !_loc3_.hasVariableItemDimensions)
         {
            return;
         }
         _loc3_.removeFromVariableVirtualCacheAtIndex(param2);
      }
      
      private function dataProvider_replaceItemHandler(param1:Event, param2:int) : void
      {
         var _loc3_:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
         if(!_loc3_ || !_loc3_.hasVariableItemDimensions)
         {
            return;
         }
         _loc3_.resetVariableVirtualCacheAtIndex(param2);
      }
      
      private function dataProvider_resetHandler(param1:Event) : void
      {
         this._updateForDataReset = true;
         var _loc2_:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
         if(!_loc2_ || !_loc2_.hasVariableItemDimensions)
         {
            return;
         }
         _loc2_.resetVariableVirtualCache();
      }
      
      private function dataProvider_filterChangeHandler(param1:Event) : void
      {
         var _loc2_:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
         if(!_loc2_ || !_loc2_.hasVariableItemDimensions)
         {
            return;
         }
         _loc2_.resetVariableVirtualCache();
      }
      
      private function dataProvider_updateItemHandler(param1:Event, param2:int) : void
      {
         var _loc3_:Object = this._dataProvider.getItemAt(param2);
         var _loc4_:IListItemRenderer = IListItemRenderer(this._rendererMap[_loc3_]);
         if(_loc4_ === null)
         {
            return;
         }
         _loc4_.data = null;
         _loc4_.data = _loc3_;
         if(this.explicitVisibleWidth !== this.explicitVisibleWidth || this.explicitVisibleHeight !== this.explicitVisibleHeight)
         {
            this.invalidate(INVALIDATION_FLAG_SIZE);
            this.invalidateParent(INVALIDATION_FLAG_SIZE);
         }
      }
      
      private function dataProvider_updateAllHandler(param1:Event) : void
      {
         this._updateForDataReset = true;
         this.invalidate(INVALIDATION_FLAG_DATA);
         var _loc2_:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
         if(!_loc2_ || !_loc2_.hasVariableItemDimensions)
         {
            return;
         }
         _loc2_.resetVariableVirtualCache();
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
      
      private function renderer_resizeHandler(param1:Event) : void
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
         var _loc3_:IListItemRenderer = IListItemRenderer(param1.currentTarget);
         _loc2_.resetVariableVirtualCacheAtIndex(_loc3_.index,DisplayObject(_loc3_));
      }
      
      private function renderer_triggeredHandler(param1:Event) : void
      {
         var _loc2_:IListItemRenderer = IListItemRenderer(param1.currentTarget);
         this.parent.dispatchEventWith(Event.TRIGGERED,false,_loc2_.data);
      }
      
      private function renderer_changeHandler(param1:Event) : void
      {
         var _loc5_:int = 0;
         if(this._ignoreSelectionChanges)
         {
            return;
         }
         var _loc2_:IListItemRenderer = IListItemRenderer(param1.currentTarget);
         if(!this._isSelectable || this._owner.isScrolling)
         {
            _loc2_.isSelected = false;
            return;
         }
         var _loc3_:Boolean = Boolean(_loc2_.isSelected);
         var _loc4_:int = _loc2_.index;
         if(this._allowMultipleSelection)
         {
            _loc5_ = this._selectedIndices.getItemIndex(_loc4_);
            if(_loc3_ && _loc5_ < 0)
            {
               this._selectedIndices.addItem(_loc4_);
            }
            else if(!_loc3_ && _loc5_ >= 0)
            {
               this._selectedIndices.removeItemAt(_loc5_);
            }
         }
         else if(_loc3_)
         {
            this._selectedIndices.data = new <int>[_loc4_];
         }
         else
         {
            this._selectedIndices.removeAll();
         }
      }
      
      private function selectedIndices_changeHandler(param1:Event) : void
      {
         this.invalidate(INVALIDATION_FLAG_SELECTED);
      }
      
      private function addedItemEffectContext_completeHandler(param1:Event) : void
      {
         var _loc2_:IEffectContext = IEffectContext(param1.currentTarget);
         _loc2_.removeEventListener(Event.COMPLETE,this.addedItemEffectContext_completeHandler);
         var _loc3_:int = this._addItemEffectContexts.indexOf(_loc2_);
         this._addItemEffectContexts.removeAt(_loc3_);
      }
      
      private function removedItemEffectContext_completeHandler(param1:Event) : void
      {
         var _loc2_:IEffectContext = IEffectContext(param1.currentTarget);
         _loc2_.removeEventListener(Event.COMPLETE,this.removedItemEffectContext_completeHandler);
         var _loc3_:int = this._removeItemEffectContexts.indexOf(_loc2_);
         this._removeItemEffectContexts.removeAt(_loc3_);
         if(param1.data === true)
         {
            return;
         }
         var _loc4_:IListItemRenderer = IListItemRenderer(_loc2_.target);
         this._dataProvider.removeItem(_loc4_.data);
         this._owner.dispatchEventWith(FeathersEventType.RENDERER_REMOVE,false,_loc4_);
         delete this._rendererMap[_loc4_.data];
         var _loc5_:ItemRendererFactoryStorage = this.factoryIDToStorage(_loc4_.factoryID);
         var _loc6_:Vector.<IListItemRenderer> = _loc5_.activeItemRenderers;
         var _loc7_:int = _loc6_.indexOf(_loc4_);
         _loc6_.removeAt(_loc7_);
         this.destroyRenderer(_loc4_);
      }
      
      protected function dragEnterHandler(param1:DragDropEvent) : void
      {
         this._acceptedDrag = false;
         if(!this._dropEnabled)
         {
            return;
         }
         if(!param1.dragData.hasDataForFormat(this._dragFormat))
         {
            return;
         }
         DragDropManager.acceptDrag(this._owner);
         this.refreshDropIndicator(param1.localX,param1.localY);
         this._acceptedDrag = true;
         this._dragLocalX = param1.localX;
         this._dragLocalY = param1.localY;
         this.addEventListener(Event.ENTER_FRAME,this.dragScroll_enterFrameHandler);
      }
      
      protected function dragMoveHandler(param1:DragDropEvent) : void
      {
         if(!this._dropEnabled)
         {
            return;
         }
         if(!param1.dragData.hasDataForFormat(this._dragFormat))
         {
            return;
         }
         this.refreshDropIndicator(param1.localX,param1.localY);
         this._dragLocalX = param1.localX;
         this._dragLocalY = param1.localY;
      }
      
      protected function dragScroll_enterFrameHandler(param1:EnterFrameEvent) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc2_:Starling = this.stage.starling;
         var _loc3_:Number = this._minimumAutoScrollDistance * (DeviceCapabilities.dpi / _loc2_.contentScaleFactor);
         var _loc4_:Number = param1.passedTime * 500;
         if(this._owner.maxVerticalScrollPosition > this._owner.minVerticalScrollPosition)
         {
            if(this._verticalScrollPosition < this._owner.maxVerticalScrollPosition && this._dragLocalY > this.visibleHeight - _loc3_)
            {
               _loc4_ *= 1 - (this.visibleHeight - this._dragLocalY) / _loc3_;
            }
            else if(this._verticalScrollPosition > this._owner.minVerticalScrollPosition && this._dragLocalY < _loc3_)
            {
               _loc4_ *= -(1 - this._dragLocalY / _loc3_);
            }
            else
            {
               _loc4_ = 0;
            }
            if(_loc4_ != 0)
            {
               _loc5_ = this._owner.verticalScrollPosition + _loc4_;
               if(_loc5_ > this._owner.maxVerticalScrollPosition)
               {
                  _loc5_ = this._owner.maxVerticalScrollPosition;
               }
               else if(_loc5_ < this._owner.minVerticalScrollPosition)
               {
                  _loc5_ = this._owner.minVerticalScrollPosition;
               }
               this._owner.verticalScrollPosition = _loc5_;
            }
         }
         if(this._owner.maxHorizontalScrollPosition > this._owner.minHorizontalScrollPosition)
         {
            if(this._horizontalScrollPosition < this._owner.maxHorizontalScrollPosition && this._dragLocalX > this.visibleWidth - _loc3_)
            {
               _loc4_ *= 1 - (this.visibleWidth - this._dragLocalX) / _loc3_;
            }
            else if(this._horizontalScrollPosition > this._owner.minHorizontalScrollPosition && this._dragLocalX < _loc3_)
            {
               _loc4_ *= -(1 - this._dragLocalX / _loc3_);
            }
            else
            {
               _loc4_ = 0;
            }
            if(_loc4_ != 0)
            {
               _loc6_ = this._owner.horizontalScrollPosition + _loc4_;
               if(_loc6_ > this._owner.maxHorizontalScrollPosition)
               {
                  _loc6_ = this._owner.maxHorizontalScrollPosition;
               }
               else if(_loc5_ < this._owner.minHorizontalScrollPosition)
               {
                  _loc6_ = this._owner.minHorizontalScrollPosition;
               }
               this._owner.horizontalScrollPosition = _loc6_;
            }
         }
      }
      
      protected function dragExitHandler(param1:DragDropEvent) : void
      {
         this._acceptedDrag = false;
         if(this._dropIndicatorSkin)
         {
            this._dropIndicatorSkin.removeFromParent(false);
         }
         this._dragLocalX = -1;
         this._dragLocalY = -1;
         this.removeEventListener(Event.ENTER_FRAME,this.dragScroll_enterFrameHandler);
      }
      
      protected function dragDropHandler(param1:DragDropEvent) : void
      {
         var _loc5_:IDragDropLayout = null;
         var _loc6_:int = 0;
         this._acceptedDrag = false;
         if(this._dropIndicatorSkin)
         {
            this._dropIndicatorSkin.removeFromParent(false);
         }
         this._dragLocalX = -1;
         this._dragLocalY = -1;
         this.removeEventListener(Event.ENTER_FRAME,this.dragScroll_enterFrameHandler);
         var _loc2_:Object = param1.dragData.getDataForFormat(this._dragFormat);
         var _loc3_:int = this._dataProvider.length;
         if(this._layout is IDragDropLayout)
         {
            _loc5_ = IDragDropLayout(this._layout);
            _loc3_ = _loc5_.getDropIndex(this._horizontalScrollPosition + param1.localX,this._verticalScrollPosition + param1.localY,this._layoutItems,0,0,this.actualVisibleWidth,this.actualVisibleHeight);
         }
         var _loc4_:int = 0;
         if(param1.dragSource == this._owner)
         {
            _loc6_ = this._dataProvider.getItemIndex(_loc2_);
            if(_loc6_ < _loc3_)
            {
               _loc4_ = -1;
            }
            this._dataProvider.removeItem(_loc2_);
            this._droppedOnSelf = true;
         }
         this._dataProvider.addItemAt(_loc2_,_loc3_ + _loc4_);
      }
      
      protected function dragCompleteHandler(param1:DragDropEvent) : void
      {
         if(!param1.isDropped)
         {
            return;
         }
         if(this._droppedOnSelf)
         {
            this._droppedOnSelf = false;
            return;
         }
         var _loc2_:Object = param1.dragData.getDataForFormat(this._dragFormat);
         this._dataProvider.removeItem(_loc2_);
      }
      
      protected function itemRenderer_drag_touchHandler(param1:TouchEvent) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:Touch = null;
         var _loc5_:ExclusiveTouch = null;
         var _loc6_:Point = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Starling = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:DragData = null;
         var _loc13_:RenderDelegate = null;
         if(!this._dragEnabled || !this.stage)
         {
            this._dragTouchPointID = -1;
            return;
         }
         var _loc2_:IListItemRenderer = IListItemRenderer(param1.currentTarget);
         if(DragDropManager.isDragging)
         {
            this._dragTouchPointID = -1;
            return;
         }
         if(_loc2_ is IDragAndDropItemRenderer)
         {
            _loc3_ = IDragAndDropItemRenderer(_loc2_).dragProxy;
            if(_loc3_)
            {
               _loc4_ = param1.getTouch(_loc3_,null,this._dragTouchPointID);
               if(!_loc4_)
               {
                  return;
               }
            }
         }
         if(this._dragTouchPointID != -1)
         {
            _loc5_ = ExclusiveTouch.forStage(this.stage);
            if(_loc5_.getClaim(this._dragTouchPointID))
            {
               this._dragTouchPointID = -1;
               return;
            }
            _loc4_ = param1.getTouch(DisplayObject(_loc2_),null,this._dragTouchPointID);
            if(_loc4_.phase == TouchPhase.MOVED)
            {
               _loc6_ = _loc4_.getLocation(this,Pool.getPoint());
               _loc7_ = _loc6_.x;
               _loc8_ = _loc6_.y;
               Pool.putPoint(_loc6_);
               _loc9_ = this.stage.starling;
               _loc10_ = (_loc7_ - this._startDragX) / (DeviceCapabilities.dpi / _loc9_.contentScaleFactor);
               _loc11_ = (_loc8_ - this._startDragY) / (DeviceCapabilities.dpi / _loc9_.contentScaleFactor);
               if(Math.abs(_loc11_) > this._minimumDragDropDistance || Math.abs(_loc10_) > this._minimumDragDropDistance)
               {
                  _loc12_ = new DragData();
                  _loc12_.setDataForFormat(this._dragFormat,_loc2_.data);
                  _loc13_ = new RenderDelegate(DisplayObject(_loc2_));
                  _loc13_.touchable = false;
                  _loc13_.alpha = 0.8;
                  this._droppedOnSelf = false;
                  _loc6_ = _loc4_.getLocation(DisplayObject(_loc2_),Pool.getPoint());
                  DragDropManager.startDrag(this._owner,_loc4_,_loc12_,DisplayObject(_loc13_),-_loc6_.x,-_loc6_.y);
                  Pool.putPoint(_loc6_);
                  _loc5_.claimTouch(this._dragTouchPointID,DisplayObject(_loc2_));
                  this._dragTouchPointID = -1;
               }
            }
            else if(_loc4_.phase == TouchPhase.ENDED)
            {
               this._dragTouchPointID = -1;
            }
         }
         else
         {
            _loc4_ = param1.getTouch(DisplayObject(_loc2_),TouchPhase.BEGAN);
            if(!_loc4_)
            {
               return;
            }
            this._dragTouchPointID = _loc4_.id;
            _loc6_ = _loc4_.getLocation(this,Pool.getPoint());
            this._startDragX = _loc6_.x;
            this._startDragY = _loc6_.y;
            Pool.putPoint(_loc6_);
         }
      }
   }
}

import feathers.controls.renderers.IListItemRenderer;

class ItemRendererFactoryStorage
{
   
   public var activeItemRenderers:Vector.<IListItemRenderer> = new Vector.<IListItemRenderer>(0);
   
   public var inactiveItemRenderers:Vector.<IListItemRenderer> = new Vector.<IListItemRenderer>(0);
   
   public function ItemRendererFactoryStorage()
   {
      super();
   }
}
