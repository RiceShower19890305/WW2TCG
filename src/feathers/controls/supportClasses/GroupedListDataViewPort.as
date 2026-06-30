package feathers.controls.supportClasses
{
   import feathers.controls.GroupedList;
   import feathers.controls.Scroller;
   import feathers.controls.renderers.IGroupedListFooterRenderer;
   import feathers.controls.renderers.IGroupedListHeaderRenderer;
   import feathers.controls.renderers.IGroupedListItemRenderer;
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.IValidating;
   import feathers.core.PropertyProxy;
   import feathers.data.IHierarchicalCollection;
   import feathers.events.CollectionEventType;
   import feathers.events.FeathersEventType;
   import feathers.layout.IGroupedLayout;
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
   
   public class GroupedListDataViewPort extends FeathersControl implements IViewPort
   {
      
      private static const INVALIDATION_FLAG_ITEM_RENDERER_FACTORY:String = "itemRendererFactory";
      
      private static const FIRST_ITEM_RENDERER_FACTORY_ID:String = "GroupedListDataViewPort-first";
      
      private static const SINGLE_ITEM_RENDERER_FACTORY_ID:String = "GroupedListDataViewPort-single";
      
      private static const LAST_ITEM_RENDERER_FACTORY_ID:String = "GroupedListDataViewPort-last";
      
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
      
      private var _layoutItems:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
      
      private var _typicalItemIsInDataProvider:Boolean = false;
      
      private var _typicalItemRenderer:IGroupedListItemRenderer;
      
      private var _unrenderedItems:Vector.<int> = new Vector.<int>(0);
      
      private var _defaultItemRendererStorage:ItemRendererFactoryStorage = new ItemRendererFactoryStorage();
      
      private var _itemStorageMap:Object = {};
      
      private var _itemRendererMap:Dictionary = new Dictionary(true);
      
      private var _unrenderedHeaders:Vector.<int> = new Vector.<int>(0);
      
      private var _defaultHeaderRendererStorage:HeaderRendererFactoryStorage = new HeaderRendererFactoryStorage();
      
      private var _headerStorageMap:Object;
      
      private var _headerRendererMap:Dictionary = new Dictionary(true);
      
      private var _unrenderedFooters:Vector.<int> = new Vector.<int>(0);
      
      private var _defaultFooterRendererStorage:FooterRendererFactoryStorage = new FooterRendererFactoryStorage();
      
      private var _footerStorageMap:Object;
      
      private var _footerRendererMap:Dictionary = new Dictionary(true);
      
      private var _headerIndices:Vector.<int> = new Vector.<int>(0);
      
      private var _footerIndices:Vector.<int> = new Vector.<int>(0);
      
      private var _owner:GroupedList;
      
      private var _updateForDataReset:Boolean = false;
      
      private var _dataProvider:IHierarchicalCollection;
      
      private var _isSelectable:Boolean = true;
      
      private var _selectedGroupIndex:int = -1;
      
      private var _selectedItemIndex:int = -1;
      
      private var _itemRendererType:Class;
      
      private var _itemRendererFactory:Function;
      
      private var _itemRendererFactories:Object;
      
      private var _factoryIDFunction:Function;
      
      private var _customItemRendererStyleName:String;
      
      private var _typicalItem:Object = null;
      
      private var _itemRendererProperties:PropertyProxy;
      
      private var _firstItemRendererType:Class;
      
      private var _firstItemRendererFactory:Function;
      
      private var _customFirstItemRendererStyleName:String;
      
      private var _lastItemRendererType:Class;
      
      private var _lastItemRendererFactory:Function;
      
      private var _customLastItemRendererStyleName:String;
      
      private var _singleItemRendererType:Class;
      
      private var _singleItemRendererFactory:Function;
      
      private var _customSingleItemRendererStyleName:String;
      
      private var _headerRendererType:Class;
      
      private var _headerRendererFactory:Function;
      
      private var _headerRendererFactories:Object;
      
      private var _headerFactoryIDFunction:Function;
      
      private var _customHeaderRendererStyleName:String;
      
      private var _headerRendererProperties:PropertyProxy;
      
      private var _footerRendererType:Class;
      
      private var _footerRendererFactory:Function;
      
      private var _footerRendererFactories:Object;
      
      private var _footerFactoryIDFunction:Function;
      
      private var _customFooterRendererStyleName:String;
      
      private var _footerRendererProperties:PropertyProxy;
      
      private var _ignoreLayoutChanges:Boolean = false;
      
      private var _ignoreRendererResizing:Boolean = false;
      
      private var _layout:ILayout;
      
      private var _horizontalScrollPosition:Number = 0;
      
      private var _verticalScrollPosition:Number = 0;
      
      private var _minimumItemCount:int;
      
      private var _minimumHeaderCount:int;
      
      private var _minimumFooterCount:int;
      
      private var _minimumFirstAndLastItemCount:int;
      
      private var _minimumSingleItemCount:int;
      
      private var _ignoreSelectionChanges:Boolean = false;
      
      public function GroupedListDataViewPort()
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
      
      public function get owner() : GroupedList
      {
         return this._owner;
      }
      
      public function set owner(param1:GroupedList) : void
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
            this._dataProvider.removeEventListener(CollectionEventType.RESET,this.dataProvider_resetHandler);
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
            this.setSelectedLocation(-1,-1);
         }
         this.invalidate(INVALIDATION_FLAG_SELECTED);
      }
      
      public function get selectedGroupIndex() : int
      {
         return this._selectedGroupIndex;
      }
      
      public function get selectedItemIndex() : int
      {
         return this._selectedItemIndex;
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
      
      public function get firstItemRendererType() : Class
      {
         return this._firstItemRendererType;
      }
      
      public function set firstItemRendererType(param1:Class) : void
      {
         if(this._firstItemRendererType == param1)
         {
            return;
         }
         this._firstItemRendererType = param1;
         this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
      }
      
      public function get firstItemRendererFactory() : Function
      {
         return this._firstItemRendererFactory;
      }
      
      public function set firstItemRendererFactory(param1:Function) : void
      {
         if(this._firstItemRendererFactory === param1)
         {
            return;
         }
         this._firstItemRendererFactory = param1;
         this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
      }
      
      public function get customFirstItemRendererStyleName() : String
      {
         return this._customFirstItemRendererStyleName;
      }
      
      public function set customFirstItemRendererStyleName(param1:String) : void
      {
         if(this._customFirstItemRendererStyleName == param1)
         {
            return;
         }
         this._customFirstItemRendererStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
      }
      
      public function get lastItemRendererType() : Class
      {
         return this._lastItemRendererType;
      }
      
      public function set lastItemRendererType(param1:Class) : void
      {
         if(this._lastItemRendererType == param1)
         {
            return;
         }
         this._lastItemRendererType = param1;
         this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
      }
      
      public function get lastItemRendererFactory() : Function
      {
         return this._lastItemRendererFactory;
      }
      
      public function set lastItemRendererFactory(param1:Function) : void
      {
         if(this._lastItemRendererFactory === param1)
         {
            return;
         }
         this._lastItemRendererFactory = param1;
         this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
      }
      
      public function get customLastItemRendererStyleName() : String
      {
         return this._customLastItemRendererStyleName;
      }
      
      public function set customLastItemRendererStyleName(param1:String) : void
      {
         if(this._customLastItemRendererStyleName == param1)
         {
            return;
         }
         this._customLastItemRendererStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
      }
      
      public function get singleItemRendererType() : Class
      {
         return this._singleItemRendererType;
      }
      
      public function set singleItemRendererType(param1:Class) : void
      {
         if(this._singleItemRendererType == param1)
         {
            return;
         }
         this._singleItemRendererType = param1;
         this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
      }
      
      public function get singleItemRendererFactory() : Function
      {
         return this._singleItemRendererFactory;
      }
      
      public function set singleItemRendererFactory(param1:Function) : void
      {
         if(this._singleItemRendererFactory === param1)
         {
            return;
         }
         this._singleItemRendererFactory = param1;
         this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
      }
      
      public function get customSingleItemRendererStyleName() : String
      {
         return this._customSingleItemRendererStyleName;
      }
      
      public function set customSingleItemRendererStyleName(param1:String) : void
      {
         if(this._customSingleItemRendererStyleName == param1)
         {
            return;
         }
         this._customSingleItemRendererStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
      }
      
      public function get headerRendererType() : Class
      {
         return this._headerRendererType;
      }
      
      public function set headerRendererType(param1:Class) : void
      {
         if(this._headerRendererType == param1)
         {
            return;
         }
         this._headerRendererType = param1;
         this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
      }
      
      public function get headerRendererFactory() : Function
      {
         return this._headerRendererFactory;
      }
      
      public function set headerRendererFactory(param1:Function) : void
      {
         if(this._headerRendererFactory === param1)
         {
            return;
         }
         this._headerRendererFactory = param1;
         this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
      }
      
      public function get headerRendererFactories() : Object
      {
         return this._headerRendererFactories;
      }
      
      public function set headerRendererFactories(param1:Object) : void
      {
         if(this._headerRendererFactories === param1)
         {
            return;
         }
         this._headerRendererFactories = param1;
         if(param1 !== null)
         {
            this._headerStorageMap = {};
         }
         this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
      }
      
      public function get headerFactoryIDFunction() : Function
      {
         return this._headerFactoryIDFunction;
      }
      
      public function set headerFactoryIDFunction(param1:Function) : void
      {
         if(this._headerFactoryIDFunction === param1)
         {
            return;
         }
         this._headerFactoryIDFunction = param1;
         this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
      }
      
      public function get customHeaderRendererStyleName() : String
      {
         return this._customHeaderRendererStyleName;
      }
      
      public function set customHeaderRendererStyleName(param1:String) : void
      {
         if(this._customHeaderRendererStyleName == param1)
         {
            return;
         }
         this._customHeaderRendererStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
      }
      
      public function get headerRendererProperties() : PropertyProxy
      {
         return this._headerRendererProperties;
      }
      
      public function set headerRendererProperties(param1:PropertyProxy) : void
      {
         if(this._headerRendererProperties == param1)
         {
            return;
         }
         if(this._headerRendererProperties)
         {
            this._headerRendererProperties.removeOnChangeCallback(this.childProperties_onChange);
         }
         this._headerRendererProperties = PropertyProxy(param1);
         if(this._headerRendererProperties)
         {
            this._headerRendererProperties.addOnChangeCallback(this.childProperties_onChange);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get footerRendererType() : Class
      {
         return this._footerRendererType;
      }
      
      public function set footerRendererType(param1:Class) : void
      {
         if(this._footerRendererType == param1)
         {
            return;
         }
         this._footerRendererType = param1;
         this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
      }
      
      public function get footerRendererFactory() : Function
      {
         return this._footerRendererFactory;
      }
      
      public function set footerRendererFactory(param1:Function) : void
      {
         if(this._footerRendererFactory === param1)
         {
            return;
         }
         this._footerRendererFactory = param1;
         this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
      }
      
      public function get footerRendererFactories() : Object
      {
         return this._footerRendererFactories;
      }
      
      public function set footerRendererFactories(param1:Object) : void
      {
         if(this._footerRendererFactories === param1)
         {
            return;
         }
         this._footerRendererFactories = param1;
         if(param1 !== null)
         {
            this._footerStorageMap = {};
         }
         this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
      }
      
      public function get footerFactoryIDFunction() : Function
      {
         return this._footerFactoryIDFunction;
      }
      
      public function set footerFactoryIDFunction(param1:Function) : void
      {
         if(this._footerFactoryIDFunction === param1)
         {
            return;
         }
         this._footerFactoryIDFunction = param1;
         this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
      }
      
      public function get customFooterRendererStyleName() : String
      {
         return this._customFooterRendererStyleName;
      }
      
      public function set customFooterRendererStyleName(param1:String) : void
      {
         if(this._customFooterRendererStyleName == param1)
         {
            return;
         }
         this._customFooterRendererStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
      }
      
      public function get footerRendererProperties() : PropertyProxy
      {
         return this._footerRendererProperties;
      }
      
      public function set footerRendererProperties(param1:PropertyProxy) : void
      {
         if(this._footerRendererProperties == param1)
         {
            return;
         }
         if(this._footerRendererProperties)
         {
            this._footerRendererProperties.removeOnChangeCallback(this.childProperties_onChange);
         }
         this._footerRendererProperties = PropertyProxy(param1);
         if(this._footerRendererProperties)
         {
            this._footerRendererProperties.addOnChangeCallback(this.childProperties_onChange);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
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
               _loc2_.hasVariableItemDimensions = true;
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
      
      public function setSelectedLocation(param1:int, param2:int) : void
      {
         if(this._selectedGroupIndex == param1 && this._selectedItemIndex == param2)
         {
            return;
         }
         if(param1 < 0 && param2 >= 0 || param1 >= 0 && param2 < 0)
         {
            throw new ArgumentError("To deselect items, group index and item index must both be < 0.");
         }
         this._selectedGroupIndex = param1;
         this._selectedItemIndex = param2;
         this.invalidate(INVALIDATION_FLAG_SELECTED);
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function calculateNavigationDestination(param1:int, param2:int, param3:uint, param4:Vector.<int>) : void
      {
         var _loc5_:int = this.locationToDisplayIndex(param1,param2);
         var _loc6_:int = this._layout.calculateNavigationDestination(this._layoutItems,_loc5_,param3,this._layoutResult);
         this.displayIndexToLocation(_loc6_,param4);
      }
      
      public function getScrollPositionForIndex(param1:int, param2:int, param3:Point = null) : Point
      {
         if(!param3)
         {
            param3 = new Point();
         }
         var _loc4_:int = this.locationToDisplayIndex(param1,param2);
         return this._layout.getScrollPositionForIndex(_loc4_,this._layoutItems,0,0,this._actualVisibleWidth,this._actualVisibleHeight,param3);
      }
      
      public function getNearestScrollPositionForIndex(param1:int, param2:int, param3:Point = null) : Point
      {
         if(!param3)
         {
            param3 = new Point();
         }
         var _loc4_:int = this.locationToDisplayIndex(param1,param2);
         return this._layout.getNearestScrollPositionForIndex(_loc4_,this._horizontalScrollPosition,this._verticalScrollPosition,this._layoutItems,0,0,this._actualVisibleWidth,this._actualVisibleHeight,param3);
      }
      
      public function itemToItemRenderer(param1:Object) : IGroupedListItemRenderer
      {
         if(param1 is XML || param1 is XMLList)
         {
            return IGroupedListItemRenderer(this._itemRendererMap[param1.toXMLString()]);
         }
         return IGroupedListItemRenderer(this._itemRendererMap[param1]);
      }
      
      public function headerDataToHeaderRenderer(param1:Object) : IGroupedListHeaderRenderer
      {
         if(param1 is XML || param1 is XMLList)
         {
            return IGroupedListHeaderRenderer(this._headerRendererMap[param1.toXMLString()]);
         }
         return IGroupedListHeaderRenderer(this._headerRendererMap[param1]);
      }
      
      public function footerDataToFooterRenderer(param1:Object) : IGroupedListFooterRenderer
      {
         if(param1 is XML || param1 is XMLList)
         {
            return IGroupedListFooterRenderer(this._footerRendererMap[param1.toXMLString()]);
         }
         return IGroupedListFooterRenderer(this._footerRendererMap[param1]);
      }
      
      override public function dispose() : void
      {
         this.refreshInactiveRenderers(true);
         this.owner = null;
         this.dataProvider = null;
         this.layout = null;
         super.dispose();
      }
      
      override protected function draw() : void
      {
         var _loc12_:Boolean = false;
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
            this.refreshInactiveRenderers(_loc5_);
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
            this.refreshHeaderRendererStyles();
            this.refreshFooterRendererStyles();
            this.refreshItemRendererStyles();
         }
         if(_loc4_ || _loc9_)
         {
            _loc12_ = this._ignoreSelectionChanges;
            this._ignoreSelectionChanges = true;
            this.refreshSelection();
            this._ignoreSelectionChanges = _loc12_;
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
      
      private function validateRenderers() : void
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
      
      private function invalidateParent(param1:String = "all") : void
      {
         Scroller(this.parent).invalidate(param1);
      }
      
      private function refreshLayoutTypicalItem() : void
      {
         var _loc8_:int = 0;
         var _loc9_:IGroupedListItemRenderer = null;
         var _loc10_:Boolean = false;
         var _loc11_:String = null;
         var _loc1_:IVirtualLayout = this._layout as IVirtualLayout;
         if(!_loc1_ || !_loc1_.useVirtualLayout)
         {
            if(!this._typicalItemIsInDataProvider && Boolean(this._typicalItemRenderer))
            {
               this.destroyItemRenderer(this._typicalItemRenderer);
               this._typicalItemRenderer = null;
            }
            return;
         }
         var _loc2_:Boolean = false;
         var _loc3_:Object = this._typicalItem;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(this._dataProvider)
         {
            if(_loc3_ !== null)
            {
               this._dataProvider.getItemLocation(_loc3_,HELPER_VECTOR);
               if(HELPER_VECTOR.length > 1)
               {
                  _loc2_ = true;
                  _loc6_ = HELPER_VECTOR[0];
                  _loc7_ = HELPER_VECTOR[1];
                  HELPER_VECTOR.length = 0;
               }
            }
            else
            {
               _loc4_ = this._dataProvider.getLengthAtLocation();
               if(_loc4_ > 0)
               {
                  _loc8_ = 0;
                  while(_loc8_ < _loc4_)
                  {
                     LOCATION_HELPER_VECTOR.length = 1;
                     LOCATION_HELPER_VECTOR[0] = _loc8_;
                     _loc5_ = this._dataProvider.getLengthAtLocation(LOCATION_HELPER_VECTOR);
                     if(_loc5_ > 0)
                     {
                        _loc2_ = true;
                        _loc6_ = _loc8_;
                        LOCATION_HELPER_VECTOR.length = 2;
                        LOCATION_HELPER_VECTOR[1] = 0;
                        _loc3_ = this._dataProvider.getItemAtLocation(LOCATION_HELPER_VECTOR);
                        break;
                     }
                     _loc8_++;
                  }
                  LOCATION_HELPER_VECTOR.length = 0;
               }
            }
         }
         if(_loc3_ !== null || _loc2_)
         {
            _loc9_ = this.itemToItemRenderer(_loc3_);
            if(_loc9_)
            {
               _loc9_.groupIndex = _loc6_;
               _loc9_.itemIndex = _loc7_;
            }
            if(!_loc9_ && Boolean(this._typicalItemRenderer))
            {
               _loc10_ = !this._typicalItemIsInDataProvider;
               if(_loc10_)
               {
                  _loc11_ = this.getFactoryID(_loc3_,_loc6_,_loc7_);
                  if(this._typicalItemRenderer.factoryID !== _loc11_)
                  {
                     _loc10_ = false;
                  }
               }
               if(_loc10_)
               {
                  _loc9_ = this._typicalItemRenderer;
                  _loc9_.data = _loc3_;
                  _loc9_.groupIndex = _loc6_;
                  _loc9_.itemIndex = _loc7_;
               }
            }
            if(!_loc9_)
            {
               _loc9_ = this.createItemRenderer(_loc3_,0,0,0,false,!_loc2_);
               if(!this._typicalItemIsInDataProvider && Boolean(this._typicalItemRenderer))
               {
                  this.destroyItemRenderer(this._typicalItemRenderer);
                  this._typicalItemRenderer = null;
               }
            }
         }
         _loc1_.typicalItem = DisplayObject(_loc9_);
         this._typicalItemRenderer = _loc9_;
         this._typicalItemIsInDataProvider = _loc2_;
         if(Boolean(this._typicalItemRenderer) && !this._typicalItemIsInDataProvider)
         {
            this._typicalItemRenderer.addEventListener(FeathersEventType.RESIZE,this.itemRenderer_resizeHandler);
         }
      }
      
      private function refreshItemRendererStyles() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:IGroupedListItemRenderer = null;
         for each(_loc1_ in this._layoutItems)
         {
            _loc2_ = _loc1_ as IGroupedListItemRenderer;
            if(_loc2_)
            {
               this.refreshOneItemRendererStyles(_loc2_);
            }
         }
      }
      
      private function refreshHeaderRendererStyles() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:IGroupedListHeaderRenderer = null;
         for each(_loc1_ in this._layoutItems)
         {
            _loc2_ = _loc1_ as IGroupedListHeaderRenderer;
            if(_loc2_)
            {
               this.refreshOneHeaderRendererStyles(_loc2_);
            }
         }
      }
      
      private function refreshFooterRendererStyles() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:IGroupedListFooterRenderer = null;
         for each(_loc1_ in this._layoutItems)
         {
            _loc2_ = _loc1_ as IGroupedListFooterRenderer;
            if(_loc2_)
            {
               this.refreshOneFooterRendererStyles(_loc2_);
            }
         }
      }
      
      private function refreshOneItemRendererStyles(param1:IGroupedListItemRenderer) : void
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
      
      private function refreshOneHeaderRendererStyles(param1:IGroupedListHeaderRenderer) : void
      {
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc2_:DisplayObject = DisplayObject(param1);
         for(_loc3_ in this._headerRendererProperties)
         {
            _loc4_ = this._headerRendererProperties[_loc3_];
            _loc2_[_loc3_] = _loc4_;
         }
      }
      
      private function refreshOneFooterRendererStyles(param1:IGroupedListFooterRenderer) : void
      {
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc2_:DisplayObject = DisplayObject(param1);
         for(_loc3_ in this._footerRendererProperties)
         {
            _loc4_ = this._footerRendererProperties[_loc3_];
            _loc2_[_loc3_] = _loc4_;
         }
      }
      
      private function refreshSelection() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:IGroupedListItemRenderer = null;
         for each(_loc1_ in this._layoutItems)
         {
            _loc2_ = _loc1_ as IGroupedListItemRenderer;
            if(_loc2_)
            {
               _loc2_.isSelected = _loc2_.groupIndex == this._selectedGroupIndex && _loc2_.itemIndex == this._selectedItemIndex;
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
      
      private function refreshInactiveRenderers(param1:Boolean) : void
      {
         var _loc2_:String = null;
         var _loc3_:ItemRendererFactoryStorage = null;
         var _loc4_:HeaderRendererFactoryStorage = null;
         var _loc5_:FooterRendererFactoryStorage = null;
         var _loc6_:Object = null;
         this.refreshInactiveItemRenderers(this._defaultItemRendererStorage,param1);
         for(_loc2_ in this._itemStorageMap)
         {
            _loc3_ = ItemRendererFactoryStorage(this._itemStorageMap[_loc2_]);
            this.refreshInactiveItemRenderers(_loc3_,param1);
         }
         this.refreshInactiveHeaderRenderers(this._defaultHeaderRendererStorage,param1);
         for(_loc2_ in this._headerStorageMap)
         {
            _loc4_ = HeaderRendererFactoryStorage(this._headerStorageMap[_loc2_]);
            this.refreshInactiveHeaderRenderers(_loc4_,param1);
         }
         this.refreshInactiveFooterRenderers(this._defaultFooterRendererStorage,param1);
         for(_loc2_ in this._footerStorageMap)
         {
            _loc5_ = FooterRendererFactoryStorage(this._footerStorageMap[_loc2_]);
            this.refreshInactiveFooterRenderers(_loc5_,param1);
         }
         if(param1 && Boolean(this._typicalItemRenderer))
         {
            if(this._typicalItemIsInDataProvider)
            {
               _loc6_ = this._typicalItemRenderer.data;
               if(_loc6_ is XML || _loc6_ is XMLList)
               {
                  delete this._itemRendererMap[_loc6_.toXMLString()];
               }
               else
               {
                  delete this._itemRendererMap[_loc6_];
               }
            }
            this.destroyItemRenderer(this._typicalItemRenderer);
            this._typicalItemRenderer = null;
            this._typicalItemIsInDataProvider = false;
         }
         this._headerIndices.length = 0;
         this._footerIndices.length = 0;
      }
      
      private function refreshInactiveItemRenderers(param1:ItemRendererFactoryStorage, param2:Boolean) : void
      {
         var _loc3_:Vector.<IGroupedListItemRenderer> = param1.inactiveItemRenderers;
         param1.inactiveItemRenderers = param1.activeItemRenderers;
         param1.activeItemRenderers = _loc3_;
         if(param1.activeItemRenderers.length > 0)
         {
            throw new IllegalOperationError("GroupedListDataViewPort: active item renderers should be empty.");
         }
         if(param2)
         {
            this.recoverInactiveItemRenderers(param1);
            this.freeInactiveItemRenderers(param1,0);
         }
      }
      
      private function refreshInactiveHeaderRenderers(param1:HeaderRendererFactoryStorage, param2:Boolean) : void
      {
         var _loc3_:Vector.<IGroupedListHeaderRenderer> = param1.inactiveHeaderRenderers;
         param1.inactiveHeaderRenderers = param1.activeHeaderRenderers;
         param1.activeHeaderRenderers = _loc3_;
         if(param1.activeHeaderRenderers.length > 0)
         {
            throw new IllegalOperationError("GroupedListDataViewPort: active header renderers should be empty.");
         }
         if(param2)
         {
            this.recoverInactiveHeaderRenderers(param1);
            this.freeInactiveHeaderRenderers(param1,0);
         }
      }
      
      private function refreshInactiveFooterRenderers(param1:FooterRendererFactoryStorage, param2:Boolean) : void
      {
         var _loc3_:Vector.<IGroupedListFooterRenderer> = param1.inactiveFooterRenderers;
         param1.inactiveFooterRenderers = param1.activeFooterRenderers;
         param1.activeFooterRenderers = _loc3_;
         if(param1.activeFooterRenderers.length > 0)
         {
            throw new IllegalOperationError("GroupedListDataViewPort: active footer renderers should be empty.");
         }
         if(param2)
         {
            this.recoverInactiveFooterRenderers(param1);
            this.freeInactiveFooterRenderers(param1,0);
         }
      }
      
      private function refreshRenderers() : void
      {
         var _loc1_:ItemRendererFactoryStorage = null;
         var _loc2_:Vector.<IGroupedListItemRenderer> = null;
         var _loc3_:Vector.<IGroupedListItemRenderer> = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:HeaderRendererFactoryStorage = null;
         var _loc8_:FooterRendererFactoryStorage = null;
         if(this._typicalItemRenderer)
         {
            if(this._typicalItemIsInDataProvider)
            {
               _loc1_ = this.factoryIDToStorage(this._typicalItemRenderer.factoryID,this._typicalItemRenderer.groupIndex,this._typicalItemRenderer.itemIndex);
               _loc2_ = _loc1_.inactiveItemRenderers;
               _loc3_ = _loc1_.activeItemRenderers;
               _loc4_ = _loc2_.indexOf(this._typicalItemRenderer);
               if(_loc4_ >= 0)
               {
                  _loc2_.removeAt(_loc4_);
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
         this.recoverInactiveItemRenderers(this._defaultItemRendererStorage);
         if(this._itemStorageMap)
         {
            for(_loc6_ in this._itemStorageMap)
            {
               _loc1_ = ItemRendererFactoryStorage(this._itemStorageMap[_loc6_]);
               this.recoverInactiveItemRenderers(_loc1_);
            }
         }
         this.recoverInactiveHeaderRenderers(this._defaultHeaderRendererStorage);
         if(this._headerStorageMap)
         {
            for(_loc6_ in this._headerStorageMap)
            {
               _loc7_ = HeaderRendererFactoryStorage(this._headerStorageMap[_loc6_]);
               this.recoverInactiveHeaderRenderers(_loc7_);
            }
         }
         this.recoverInactiveFooterRenderers(this._defaultFooterRendererStorage);
         if(this._footerStorageMap)
         {
            for(_loc6_ in this._footerStorageMap)
            {
               _loc8_ = FooterRendererFactoryStorage(this._footerStorageMap[_loc6_]);
               this.recoverInactiveFooterRenderers(_loc8_);
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
         this.freeInactiveHeaderRenderers(this._defaultHeaderRendererStorage,this._minimumHeaderCount);
         if(this._headerStorageMap)
         {
            for(_loc6_ in this._headerStorageMap)
            {
               _loc7_ = HeaderRendererFactoryStorage(this._headerStorageMap[_loc6_]);
               this.freeInactiveHeaderRenderers(_loc7_,1);
            }
         }
         this.freeInactiveFooterRenderers(this._defaultFooterRendererStorage,this._minimumFooterCount);
         if(this._footerStorageMap)
         {
            for(_loc6_ in this._footerStorageMap)
            {
               _loc8_ = FooterRendererFactoryStorage(this._footerStorageMap[_loc6_]);
               this.freeInactiveFooterRenderers(_loc8_,1);
            }
         }
         this._updateForDataReset = false;
      }
      
      private function findUnrenderedData() : void
      {
         var _loc11_:Object = null;
         var _loc12_:int = 0;
         var _loc13_:Point = null;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Object = null;
         var _loc19_:int = 0;
         var _loc20_:Object = null;
         var _loc21_:Object = null;
         var _loc22_:int = 0;
         var _loc1_:int = this._dataProvider ? this._dataProvider.getLengthAtLocation() : 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         LOCATION_HELPER_VECTOR.length = 1;
         var _loc7_:int = 0;
         while(_loc7_ < _loc1_)
         {
            LOCATION_HELPER_VECTOR[0] = _loc7_;
            _loc11_ = this._dataProvider.getItemAtLocation(LOCATION_HELPER_VECTOR);
            if(this._owner.groupToHeaderData(_loc11_) !== null)
            {
               this._headerIndices[_loc3_] = _loc2_;
               _loc2_++;
               _loc3_++;
            }
            _loc12_ = this._dataProvider.getLengthAtLocation(LOCATION_HELPER_VECTOR);
            _loc2_ += _loc12_;
            _loc6_ += _loc12_;
            if(_loc12_ == 0)
            {
               _loc5_++;
            }
            if(this._owner.groupToFooterData(_loc11_) !== null)
            {
               this._footerIndices[_loc4_] = _loc2_;
               _loc2_++;
               _loc4_++;
            }
            _loc7_++;
         }
         LOCATION_HELPER_VECTOR.length = 0;
         this._layoutItems.length = _loc2_;
         if(this._layout is IGroupedLayout)
         {
            IGroupedLayout(this._layout).headerIndices = this._headerIndices;
         }
         var _loc8_:IVirtualLayout = this._layout as IVirtualLayout;
         var _loc9_:Boolean = (Boolean(_loc8_)) && _loc8_.useVirtualLayout;
         if(_loc9_)
         {
            _loc13_ = Pool.getPoint();
            _loc8_.measureViewPort(_loc2_,this._viewPortBounds,_loc13_);
            _loc14_ = _loc13_.x;
            _loc15_ = _loc13_.y;
            Pool.putPoint(_loc13_);
            _loc8_.getVisibleIndicesAtScrollPosition(this._horizontalScrollPosition,this._verticalScrollPosition,_loc14_,_loc15_,_loc2_,HELPER_VECTOR);
            _loc6_ /= _loc1_;
            if(this._typicalItemRenderer)
            {
               _loc16_ = Number(this._typicalItemRenderer.height);
               if(this._typicalItemRenderer.width < _loc16_)
               {
                  _loc16_ = Number(this._typicalItemRenderer.width);
               }
               _loc17_ = _loc14_;
               if(_loc15_ > _loc14_)
               {
                  _loc17_ = _loc15_;
               }
               this._minimumFirstAndLastItemCount = this._minimumSingleItemCount = this._minimumHeaderCount = this._minimumFooterCount = Math.ceil(_loc17_ / (_loc16_ * _loc6_));
               this._minimumHeaderCount = Math.min(this._minimumHeaderCount,_loc3_);
               this._minimumFooterCount = Math.min(this._minimumFooterCount,_loc4_);
               this._minimumSingleItemCount = Math.min(this._minimumSingleItemCount,_loc5_);
               this._minimumItemCount = Math.ceil(_loc17_ / _loc16_) + 1;
            }
            else
            {
               this._minimumFirstAndLastItemCount = 1;
               this._minimumHeaderCount = 1;
               this._minimumFooterCount = 1;
               this._minimumSingleItemCount = 1;
               this._minimumItemCount = 1;
            }
         }
         var _loc10_:int = 0;
         _loc7_ = 0;
         while(_loc7_ < _loc1_)
         {
            LOCATION_HELPER_VECTOR.length = 1;
            LOCATION_HELPER_VECTOR[0] = _loc7_;
            _loc11_ = this._dataProvider.getItemAtLocation(LOCATION_HELPER_VECTOR);
            LOCATION_HELPER_VECTOR.length = 0;
            _loc18_ = this._owner.groupToHeaderData(_loc11_);
            if(_loc18_ !== null)
            {
               if(_loc9_ && HELPER_VECTOR.indexOf(_loc10_) < 0)
               {
                  this._layoutItems[_loc10_] = null;
               }
               else
               {
                  this.findRendererForHeader(_loc18_,_loc7_,_loc10_);
               }
               _loc10_++;
            }
            LOCATION_HELPER_VECTOR.length = 1;
            LOCATION_HELPER_VECTOR[0] = _loc7_;
            _loc12_ = this._dataProvider.getLengthAtLocation(LOCATION_HELPER_VECTOR);
            LOCATION_HELPER_VECTOR.length = 0;
            _loc19_ = 0;
            while(_loc19_ < _loc12_)
            {
               if(_loc9_ && HELPER_VECTOR.indexOf(_loc10_) < 0)
               {
                  if(Boolean(this._typicalItemRenderer && this._typicalItemIsInDataProvider) && Boolean(this._typicalItemRenderer.groupIndex == _loc7_) && this._typicalItemRenderer.itemIndex == _loc19_)
                  {
                     this._typicalItemRenderer.layoutIndex = _loc10_;
                  }
                  this._layoutItems[_loc10_] = null;
               }
               else
               {
                  LOCATION_HELPER_VECTOR.length = 2;
                  LOCATION_HELPER_VECTOR[0] = _loc7_;
                  LOCATION_HELPER_VECTOR[1] = _loc19_;
                  _loc21_ = this._dataProvider.getItemAtLocation(LOCATION_HELPER_VECTOR);
                  LOCATION_HELPER_VECTOR.length = 0;
                  this.findRendererForItem(_loc21_,_loc7_,_loc19_,_loc10_);
               }
               _loc10_++;
               _loc19_++;
            }
            _loc20_ = this._owner.groupToFooterData(_loc11_);
            if(_loc20_ !== null)
            {
               if(_loc9_ && HELPER_VECTOR.indexOf(_loc10_) < 0)
               {
                  this._layoutItems[_loc10_] = null;
               }
               else
               {
                  this.findRendererForFooter(_loc20_,_loc7_,_loc10_);
               }
               _loc10_++;
            }
            _loc7_++;
         }
         LOCATION_HELPER_VECTOR.length = 0;
         if(this._typicalItemRenderer)
         {
            if(_loc9_ && this._typicalItemIsInDataProvider)
            {
               _loc22_ = HELPER_VECTOR.indexOf(this._typicalItemRenderer.layoutIndex);
               if(_loc22_ >= 0)
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
      
      private function findRendererForItem(param1:Object, param2:int, param3:int, param4:int) : void
      {
         var _loc6_:String = null;
         var _loc7_:ItemRendererFactoryStorage = null;
         var _loc8_:Vector.<IGroupedListItemRenderer> = null;
         var _loc9_:Vector.<IGroupedListItemRenderer> = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc5_:IGroupedListItemRenderer = this.itemToItemRenderer(param1);
         if(this._factoryIDFunction !== null && _loc5_ !== null)
         {
            _loc6_ = this.getFactoryID(_loc5_.data,param2,param3);
            if(_loc6_ !== _loc5_.factoryID)
            {
               _loc5_ = null;
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
         if(_loc5_ !== null)
         {
            _loc5_.groupIndex = param2;
            _loc5_.itemIndex = param3;
            _loc5_.layoutIndex = param4;
            if(this._updateForDataReset)
            {
               _loc5_.data = null;
               _loc5_.data = param1;
            }
            if(this._typicalItemRenderer !== _loc5_)
            {
               _loc7_ = this.factoryIDToStorage(_loc5_.factoryID,_loc5_.groupIndex,_loc5_.itemIndex);
               _loc8_ = _loc7_.activeItemRenderers;
               _loc9_ = _loc7_.inactiveItemRenderers;
               _loc8_[_loc8_.length] = _loc5_;
               _loc10_ = _loc9_.indexOf(_loc5_);
               if(_loc10_ < 0)
               {
                  throw new IllegalOperationError("GroupedListDataViewPort: item renderer map contains bad data. This may be caused by duplicate items in the data provider, which is not allowed.");
               }
               _loc9_.removeAt(_loc10_);
            }
            _loc5_.visible = true;
            this._layoutItems[param4] = DisplayObject(_loc5_);
         }
         else
         {
            _loc11_ = int(this._unrenderedItems.length);
            this._unrenderedItems[_loc11_] = param2;
            _loc11_++;
            this._unrenderedItems[_loc11_] = param3;
            _loc11_++;
            this._unrenderedItems[_loc11_] = param4;
         }
      }
      
      private function findRendererForHeader(param1:Object, param2:int, param3:int) : void
      {
         var _loc5_:String = null;
         var _loc6_:HeaderRendererFactoryStorage = null;
         var _loc7_:Vector.<IGroupedListHeaderRenderer> = null;
         var _loc8_:Vector.<IGroupedListHeaderRenderer> = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc4_:IGroupedListHeaderRenderer = this.headerDataToHeaderRenderer(param1);
         if(this._headerFactoryIDFunction !== null && _loc4_ !== null)
         {
            _loc5_ = this.getHeaderFactoryID(_loc4_.data,param2);
            if(_loc5_ !== _loc4_.factoryID)
            {
               _loc4_ = null;
               if(param1 is XML || param1 is XMLList)
               {
                  delete this._headerRendererMap[param1.toXMLString()];
               }
               else
               {
                  delete this._headerRendererMap[param1];
               }
            }
         }
         if(_loc4_ !== null)
         {
            _loc4_.groupIndex = param2;
            _loc4_.layoutIndex = param3;
            if(this._updateForDataReset)
            {
               _loc4_.data = null;
               _loc4_.data = param1;
            }
            _loc6_ = this.headerFactoryIDToStorage(_loc4_.factoryID);
            _loc7_ = _loc6_.activeHeaderRenderers;
            _loc8_ = _loc6_.inactiveHeaderRenderers;
            _loc7_[_loc7_.length] = _loc4_;
            _loc9_ = _loc8_.indexOf(_loc4_);
            if(_loc9_ < 0)
            {
               throw new IllegalOperationError("GroupedListDataViewPort: header renderer map contains bad data. This may be caused by duplicate headers in the data provider, which is not allowed.");
            }
            _loc8_.removeAt(_loc9_);
            _loc4_.visible = true;
            this._layoutItems[param3] = DisplayObject(_loc4_);
         }
         else
         {
            _loc10_ = int(this._unrenderedHeaders.length);
            this._unrenderedHeaders[_loc10_] = param2;
            _loc10_++;
            this._unrenderedHeaders[_loc10_] = param3;
         }
      }
      
      private function findRendererForFooter(param1:Object, param2:int, param3:int) : void
      {
         var _loc5_:String = null;
         var _loc6_:FooterRendererFactoryStorage = null;
         var _loc7_:Vector.<IGroupedListFooterRenderer> = null;
         var _loc8_:Vector.<IGroupedListFooterRenderer> = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc4_:IGroupedListFooterRenderer = this.footerDataToFooterRenderer(param1);
         if(this._footerFactoryIDFunction !== null && _loc4_ !== null)
         {
            _loc5_ = this.getFooterFactoryID(_loc4_.data,param2);
            if(_loc5_ !== _loc4_.factoryID)
            {
               _loc4_ = null;
               if(param1 is XML || param1 is XMLList)
               {
                  delete this._footerRendererMap[param1.toXMLString()];
               }
               else
               {
                  delete this._footerRendererMap[param1];
               }
            }
         }
         if(_loc4_ !== null)
         {
            _loc4_.groupIndex = param2;
            _loc4_.layoutIndex = param3;
            if(this._updateForDataReset)
            {
               _loc4_.data = null;
               _loc4_.data = param1;
            }
            _loc6_ = this.footerFactoryIDToStorage(_loc4_.factoryID);
            _loc7_ = _loc6_.activeFooterRenderers;
            _loc8_ = _loc6_.inactiveFooterRenderers;
            _loc7_[_loc7_.length] = _loc4_;
            _loc9_ = _loc8_.indexOf(_loc4_);
            if(_loc9_ < 0)
            {
               throw new IllegalOperationError("GroupedListDataViewPort: footer renderer map contains bad data. This may be caused by duplicate footers in the data provider, which is not allowed.");
            }
            _loc8_.removeAt(_loc9_);
            _loc4_.visible = true;
            this._layoutItems[param3] = DisplayObject(_loc4_);
         }
         else
         {
            _loc10_ = int(this._unrenderedFooters.length);
            this._unrenderedFooters[_loc10_] = param2;
            _loc10_++;
            this._unrenderedFooters[_loc10_] = param3;
         }
      }
      
      private function renderUnrenderedData() : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc7_:IGroupedListItemRenderer = null;
         var _loc8_:IGroupedListHeaderRenderer = null;
         var _loc9_:IGroupedListFooterRenderer = null;
         LOCATION_HELPER_VECTOR.length = 2;
         var _loc1_:int = int(this._unrenderedItems.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._unrenderedItems.shift();
            _loc4_ = this._unrenderedItems.shift();
            _loc5_ = this._unrenderedItems.shift();
            LOCATION_HELPER_VECTOR[0] = _loc3_;
            LOCATION_HELPER_VECTOR[1] = _loc4_;
            _loc6_ = this._dataProvider.getItemAtLocation(LOCATION_HELPER_VECTOR);
            _loc7_ = this.createItemRenderer(_loc6_,_loc3_,_loc4_,_loc5_,true,false);
            this._layoutItems[_loc5_] = DisplayObject(_loc7_);
            _loc2_ += 3;
         }
         LOCATION_HELPER_VECTOR.length = 1;
         _loc1_ = int(this._unrenderedHeaders.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._unrenderedHeaders.shift();
            _loc5_ = this._unrenderedHeaders.shift();
            LOCATION_HELPER_VECTOR[0] = _loc3_;
            _loc6_ = this._dataProvider.getItemAtLocation(LOCATION_HELPER_VECTOR);
            _loc6_ = this._owner.groupToHeaderData(_loc6_);
            _loc8_ = this.createHeaderRenderer(_loc6_,_loc3_,_loc5_,false);
            this._layoutItems[_loc5_] = DisplayObject(_loc8_);
            _loc2_ += 2;
         }
         _loc1_ = int(this._unrenderedFooters.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._unrenderedFooters.shift();
            _loc5_ = this._unrenderedFooters.shift();
            LOCATION_HELPER_VECTOR[0] = _loc3_;
            _loc6_ = this._dataProvider.getItemAtLocation(LOCATION_HELPER_VECTOR);
            _loc6_ = this._owner.groupToFooterData(_loc6_);
            _loc9_ = this.createFooterRenderer(_loc6_,_loc3_,_loc5_,false);
            this._layoutItems[_loc5_] = DisplayObject(_loc9_);
            _loc2_ += 2;
         }
         LOCATION_HELPER_VECTOR.length = 0;
      }
      
      private function recoverInactiveItemRenderers(param1:ItemRendererFactoryStorage) : void
      {
         var _loc5_:IGroupedListItemRenderer = null;
         var _loc6_:Object = null;
         var _loc2_:Vector.<IGroupedListItemRenderer> = param1.inactiveItemRenderers;
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            if(!(!_loc5_ || _loc5_.groupIndex < 0))
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
      
      private function recoverInactiveHeaderRenderers(param1:HeaderRendererFactoryStorage) : void
      {
         var _loc5_:IGroupedListHeaderRenderer = null;
         var _loc6_:Object = null;
         var _loc2_:Vector.<IGroupedListHeaderRenderer> = param1.inactiveHeaderRenderers;
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            if(_loc5_)
            {
               this._owner.dispatchEventWith(FeathersEventType.RENDERER_REMOVE,false,_loc5_);
               _loc6_ = _loc5_.data;
               if(_loc6_ is XML || _loc6_ is XMLList)
               {
                  delete this._headerRendererMap[_loc6_.toXMLString()];
               }
               else
               {
                  delete this._headerRendererMap[_loc6_];
               }
            }
            _loc4_++;
         }
      }
      
      private function recoverInactiveFooterRenderers(param1:FooterRendererFactoryStorage) : void
      {
         var _loc5_:IGroupedListFooterRenderer = null;
         var _loc6_:Object = null;
         var _loc2_:Vector.<IGroupedListFooterRenderer> = param1.inactiveFooterRenderers;
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            if(_loc5_)
            {
               this._owner.dispatchEventWith(FeathersEventType.RENDERER_REMOVE,false,_loc5_);
               _loc6_ = _loc5_.data;
               if(_loc6_ is XML || _loc6_ is XMLList)
               {
                  delete this._footerRendererMap[_loc6_.toXMLString()];
               }
               else
               {
                  delete this._footerRendererMap[_loc6_];
               }
            }
            _loc4_++;
         }
      }
      
      private function freeInactiveItemRenderers(param1:ItemRendererFactoryStorage, param2:int) : void
      {
         var _loc9_:IGroupedListItemRenderer = null;
         var _loc3_:Vector.<IGroupedListItemRenderer> = param1.inactiveItemRenderers;
         var _loc4_:Vector.<IGroupedListItemRenderer> = param1.activeItemRenderers;
         var _loc5_:int = int(_loc4_.length);
         var _loc6_:int = param2 - _loc5_;
         if(_loc6_ > _loc3_.length)
         {
            _loc6_ = int(_loc3_.length);
         }
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc9_ = _loc3_.shift();
            _loc9_.data = null;
            _loc9_.groupIndex = -1;
            _loc9_.itemIndex = -1;
            _loc9_.layoutIndex = -1;
            _loc9_.visible = false;
            _loc4_[_loc5_] = _loc9_;
            _loc5_++;
            _loc7_++;
         }
         var _loc8_:int = int(_loc3_.length);
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc9_ = _loc3_.shift();
            if(_loc9_)
            {
               this.destroyItemRenderer(_loc9_);
            }
            _loc7_++;
         }
      }
      
      private function freeInactiveHeaderRenderers(param1:HeaderRendererFactoryStorage, param2:int) : void
      {
         var _loc9_:IGroupedListHeaderRenderer = null;
         var _loc3_:Vector.<IGroupedListHeaderRenderer> = param1.inactiveHeaderRenderers;
         var _loc4_:Vector.<IGroupedListHeaderRenderer> = param1.activeHeaderRenderers;
         var _loc5_:int = int(_loc4_.length);
         var _loc6_:int = param2 - _loc5_;
         if(_loc6_ > _loc3_.length)
         {
            _loc6_ = int(_loc3_.length);
         }
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc9_ = _loc3_.shift();
            _loc9_.visible = false;
            _loc9_.data = null;
            _loc9_.groupIndex = -1;
            _loc9_.layoutIndex = -1;
            _loc4_[_loc5_] = _loc9_;
            _loc5_++;
            _loc7_++;
         }
         var _loc8_:int = int(_loc3_.length);
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc9_ = _loc3_.shift();
            if(_loc9_)
            {
               this.destroyHeaderRenderer(_loc9_);
            }
            _loc7_++;
         }
      }
      
      private function freeInactiveFooterRenderers(param1:FooterRendererFactoryStorage, param2:int) : void
      {
         var _loc9_:IGroupedListFooterRenderer = null;
         var _loc3_:Vector.<IGroupedListFooterRenderer> = param1.inactiveFooterRenderers;
         var _loc4_:Vector.<IGroupedListFooterRenderer> = param1.activeFooterRenderers;
         var _loc5_:int = int(_loc4_.length);
         var _loc6_:int = param2 - _loc5_;
         if(_loc6_ > _loc3_.length)
         {
            _loc6_ = int(_loc3_.length);
         }
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc9_ = _loc3_.shift();
            _loc9_.visible = false;
            _loc9_.data = null;
            _loc9_.groupIndex = -1;
            _loc9_.layoutIndex = -1;
            _loc4_[_loc5_] = _loc9_;
            _loc5_++;
            _loc7_++;
         }
         var _loc8_:int = int(_loc3_.length);
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc9_ = _loc3_.shift();
            if(_loc9_)
            {
               this.destroyFooterRenderer(_loc9_);
            }
            _loc7_++;
         }
      }
      
      private function createItemRenderer(param1:Object, param2:int, param3:int, param4:int, param5:Boolean, param6:Boolean) : IGroupedListItemRenderer
      {
         var _loc13_:IGroupedListItemRenderer = null;
         var _loc14_:IFeathersControl = null;
         var _loc15_:Class = null;
         var _loc7_:String = this.getFactoryID(param1,param2,param3);
         var _loc8_:Function = this.factoryIDToFactory(_loc7_,param2,param3);
         var _loc9_:ItemRendererFactoryStorage = this.factoryIDToStorage(_loc7_,param2,param3);
         var _loc10_:String = this.indexToCustomStyleName(param2,param3);
         var _loc11_:Vector.<IGroupedListItemRenderer> = _loc9_.inactiveItemRenderers;
         var _loc12_:Vector.<IGroupedListItemRenderer> = _loc9_.activeItemRenderers;
         if(!param5 || param6 || _loc11_.length == 0)
         {
            if(_loc8_ !== null)
            {
               _loc13_ = IGroupedListItemRenderer(_loc8_());
            }
            else
            {
               _loc15_ = this.indexToItemRendererType(param2,param3);
               _loc13_ = IGroupedListItemRenderer(new _loc15_());
            }
            _loc14_ = IFeathersControl(_loc13_);
            if(Boolean(_loc10_) && _loc10_.length > 0)
            {
               _loc14_.styleNameList.add(_loc10_);
            }
            this.addChild(DisplayObject(_loc13_));
         }
         else
         {
            _loc13_ = _loc11_.shift();
         }
         _loc13_.data = param1;
         _loc13_.groupIndex = param2;
         _loc13_.itemIndex = param3;
         _loc13_.layoutIndex = param4;
         _loc13_.owner = this._owner;
         _loc13_.factoryID = _loc7_;
         _loc13_.visible = true;
         if(!param6)
         {
            if(param1 is XML || param1 is XMLList)
            {
               this._itemRendererMap[param1.toXMLString()] = _loc13_;
            }
            else
            {
               this._itemRendererMap[param1] = _loc13_;
            }
            _loc12_.push(_loc13_);
            _loc13_.addEventListener(Event.TRIGGERED,this.renderer_triggeredHandler);
            _loc13_.addEventListener(Event.CHANGE,this.renderer_changeHandler);
            _loc13_.addEventListener(FeathersEventType.RESIZE,this.itemRenderer_resizeHandler);
            this._owner.dispatchEventWith(FeathersEventType.RENDERER_ADD,false,_loc13_);
         }
         return _loc13_;
      }
      
      private function createHeaderRenderer(param1:Object, param2:int, param3:int, param4:Boolean = false) : IGroupedListHeaderRenderer
      {
         var _loc10_:IGroupedListHeaderRenderer = null;
         var _loc11_:IFeathersControl = null;
         var _loc5_:String = this.getHeaderFactoryID(param1,param2);
         var _loc6_:Function = this.headerFactoryIDToFactory(_loc5_);
         var _loc7_:HeaderRendererFactoryStorage = this.headerFactoryIDToStorage(_loc5_);
         var _loc8_:Vector.<IGroupedListHeaderRenderer> = _loc7_.inactiveHeaderRenderers;
         var _loc9_:Vector.<IGroupedListHeaderRenderer> = _loc7_.activeHeaderRenderers;
         if(param4 || _loc8_.length == 0)
         {
            if(_loc6_ !== null)
            {
               _loc10_ = IGroupedListHeaderRenderer(_loc6_());
            }
            else
            {
               _loc10_ = IGroupedListHeaderRenderer(new this._headerRendererType());
            }
            _loc11_ = IFeathersControl(_loc10_);
            if(Boolean(this._customHeaderRendererStyleName) && this._customHeaderRendererStyleName.length > 0)
            {
               _loc11_.styleNameList.add(this._customHeaderRendererStyleName);
            }
            this.addChild(DisplayObject(_loc10_));
         }
         else
         {
            _loc10_ = _loc8_.shift();
         }
         _loc10_.data = param1;
         _loc10_.groupIndex = param2;
         _loc10_.layoutIndex = param3;
         _loc10_.owner = this._owner;
         _loc10_.factoryID = _loc5_;
         _loc10_.visible = true;
         if(!param4)
         {
            if(param1 is XML || param1 is XMLList)
            {
               this._headerRendererMap[param1.toXMLString()] = _loc10_;
            }
            else
            {
               this._headerRendererMap[param1] = _loc10_;
            }
            _loc9_.push(_loc10_);
            _loc10_.addEventListener(FeathersEventType.RESIZE,this.headerRenderer_resizeHandler);
            this._owner.dispatchEventWith(FeathersEventType.RENDERER_ADD,false,_loc10_);
         }
         return _loc10_;
      }
      
      private function createFooterRenderer(param1:Object, param2:int, param3:int, param4:Boolean = false) : IGroupedListFooterRenderer
      {
         var _loc10_:IGroupedListFooterRenderer = null;
         var _loc11_:IFeathersControl = null;
         var _loc5_:String = this.getFooterFactoryID(param1,param2);
         var _loc6_:Function = this.footerFactoryIDToFactory(_loc5_);
         var _loc7_:FooterRendererFactoryStorage = this.footerFactoryIDToStorage(_loc5_);
         var _loc8_:Vector.<IGroupedListFooterRenderer> = _loc7_.inactiveFooterRenderers;
         var _loc9_:Vector.<IGroupedListFooterRenderer> = _loc7_.activeFooterRenderers;
         if(param4 || _loc8_.length == 0)
         {
            if(_loc6_ !== null)
            {
               _loc10_ = IGroupedListFooterRenderer(_loc6_());
            }
            else
            {
               _loc10_ = IGroupedListFooterRenderer(new this._footerRendererType());
            }
            _loc11_ = IFeathersControl(_loc10_);
            if(Boolean(this._customFooterRendererStyleName) && this._customFooterRendererStyleName.length > 0)
            {
               _loc11_.styleNameList.add(this._customFooterRendererStyleName);
            }
            this.addChild(DisplayObject(_loc10_));
         }
         else
         {
            _loc10_ = _loc8_.shift();
         }
         _loc10_.data = param1;
         _loc10_.groupIndex = param2;
         _loc10_.layoutIndex = param3;
         _loc10_.owner = this._owner;
         _loc10_.factoryID = _loc5_;
         _loc10_.visible = true;
         if(!param4)
         {
            if(param1 is XML || param1 is XMLList)
            {
               this._footerRendererMap[param1.toXMLString()] = _loc10_;
            }
            else
            {
               this._footerRendererMap[param1] = _loc10_;
            }
            _loc9_[_loc9_.length] = _loc10_;
            _loc10_.addEventListener(FeathersEventType.RESIZE,this.footerRenderer_resizeHandler);
            this._owner.dispatchEventWith(FeathersEventType.RENDERER_ADD,false,_loc10_);
         }
         return _loc10_;
      }
      
      private function destroyItemRenderer(param1:IGroupedListItemRenderer) : void
      {
         param1.removeEventListener(Event.TRIGGERED,this.renderer_triggeredHandler);
         param1.removeEventListener(Event.CHANGE,this.renderer_changeHandler);
         param1.removeEventListener(FeathersEventType.RESIZE,this.itemRenderer_resizeHandler);
         param1.owner = null;
         param1.data = null;
         this.removeChild(DisplayObject(param1),true);
      }
      
      private function destroyHeaderRenderer(param1:IGroupedListHeaderRenderer) : void
      {
         param1.removeEventListener(FeathersEventType.RESIZE,this.headerRenderer_resizeHandler);
         param1.owner = null;
         param1.data = null;
         this.removeChild(DisplayObject(param1),true);
      }
      
      private function destroyFooterRenderer(param1:IGroupedListFooterRenderer) : void
      {
         param1.removeEventListener(FeathersEventType.RESIZE,this.footerRenderer_resizeHandler);
         param1.owner = null;
         param1.data = null;
         this.removeChild(DisplayObject(param1),true);
      }
      
      private function groupToHeaderDisplayIndex(param1:int) : int
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Object = null;
         LOCATION_HELPER_VECTOR.length = 1;
         LOCATION_HELPER_VECTOR[0] = param1;
         var _loc2_:Object = this._dataProvider.getItemAtLocation(LOCATION_HELPER_VECTOR);
         var _loc3_:Object = this._owner.groupToHeaderData(_loc2_);
         if(!_loc3_)
         {
            LOCATION_HELPER_VECTOR.length = 0;
            return -1;
         }
         LOCATION_HELPER_VECTOR.length = 1;
         var _loc4_:int = 0;
         var _loc5_:int = this._dataProvider.getLengthAtLocation();
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            LOCATION_HELPER_VECTOR[0] = _loc6_;
            _loc2_ = this._dataProvider.getItemAtLocation(LOCATION_HELPER_VECTOR);
            _loc3_ = this._owner.groupToHeaderData(_loc2_);
            if(_loc3_)
            {
               if(param1 == _loc6_)
               {
                  LOCATION_HELPER_VECTOR.length = 0;
                  return _loc4_;
               }
               _loc4_++;
            }
            _loc7_ = this._dataProvider.getLengthAtLocation(LOCATION_HELPER_VECTOR);
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc4_++;
               _loc8_++;
            }
            _loc9_ = this._owner.groupToFooterData(_loc2_);
            if(_loc9_)
            {
               _loc4_++;
            }
            _loc6_++;
         }
         LOCATION_HELPER_VECTOR.length = 0;
         return -1;
      }
      
      private function groupToFooterDisplayIndex(param1:int) : int
      {
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         LOCATION_HELPER_VECTOR.length = 1;
         LOCATION_HELPER_VECTOR[0] = param1;
         var _loc2_:Object = this._dataProvider.getItemAtLocation(LOCATION_HELPER_VECTOR);
         var _loc3_:Object = this._owner.groupToFooterData(_loc2_);
         if(!_loc3_)
         {
            LOCATION_HELPER_VECTOR.length = 0;
            return -1;
         }
         LOCATION_HELPER_VECTOR.length = 1;
         var _loc4_:int = 0;
         var _loc5_:int = this._dataProvider.getLengthAtLocation();
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            LOCATION_HELPER_VECTOR[0] = _loc6_;
            _loc2_ = this._dataProvider.getItemAtLocation(LOCATION_HELPER_VECTOR);
            _loc7_ = this._owner.groupToHeaderData(_loc2_);
            if(_loc7_)
            {
               _loc4_++;
            }
            _loc8_ = this._dataProvider.getLengthAtLocation(LOCATION_HELPER_VECTOR);
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
               _loc4_++;
               _loc9_++;
            }
            _loc3_ = this._owner.groupToFooterData(_loc2_);
            if(_loc3_)
            {
               if(param1 == _loc6_)
               {
                  LOCATION_HELPER_VECTOR.length = 0;
                  return _loc4_;
               }
               _loc4_++;
            }
            _loc6_++;
         }
         LOCATION_HELPER_VECTOR.length = 0;
         return -1;
      }
      
      private function displayIndexToLocation(param1:int, param2:Vector.<int>) : void
      {
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc9_:Object = null;
         var _loc10_:int = 0;
         param2.length = 2;
         LOCATION_HELPER_VECTOR.length = 1;
         var _loc3_:int = 0;
         var _loc4_:int = this._dataProvider.getLengthAtLocation();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            LOCATION_HELPER_VECTOR[0] = _loc5_;
            _loc6_ = this._dataProvider.getItemAtLocation(LOCATION_HELPER_VECTOR);
            _loc7_ = this._owner.groupToHeaderData(_loc6_);
            if(_loc7_ !== null)
            {
               _loc3_++;
            }
            _loc8_ = this._dataProvider.getLengthAtLocation(LOCATION_HELPER_VECTOR);
            _loc3_ += _loc8_;
            if(_loc3_ > param1)
            {
               _loc10_ = param1 - (_loc3_ - _loc8_);
               if(_loc10_ == -1)
               {
                  param2[0] = -1;
                  param2[1] = -1;
               }
               else
               {
                  param2[0] = _loc5_;
                  param2[1] = _loc10_;
               }
               LOCATION_HELPER_VECTOR.length = 0;
               return;
            }
            _loc9_ = this._owner.groupToFooterData(_loc6_);
            if(_loc9_ !== null)
            {
               _loc3_++;
            }
            _loc5_++;
         }
         param2[0] = -1;
         param2[1] = -1;
         LOCATION_HELPER_VECTOR.length = 0;
      }
      
      private function locationToDisplayIndex(param1:int, param2:int) : int
      {
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Object = null;
         LOCATION_HELPER_VECTOR.length = 1;
         var _loc3_:int = 0;
         var _loc4_:int = this._dataProvider.getLengthAtLocation();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            if(param2 < 0 && param1 == _loc5_)
            {
               LOCATION_HELPER_VECTOR.length = 0;
               return _loc3_;
            }
            LOCATION_HELPER_VECTOR[0] = _loc5_;
            _loc6_ = this._dataProvider.getItemAtLocation(LOCATION_HELPER_VECTOR);
            _loc7_ = this._owner.groupToHeaderData(_loc6_);
            if(_loc7_)
            {
               _loc3_++;
            }
            _loc8_ = this._dataProvider.getLengthAtLocation(LOCATION_HELPER_VECTOR);
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
               if(param1 == _loc5_ && param2 == _loc9_)
               {
                  LOCATION_HELPER_VECTOR.length = 0;
                  return _loc3_;
               }
               _loc3_++;
               _loc9_++;
            }
            _loc10_ = this._owner.groupToFooterData(_loc6_);
            if(_loc10_)
            {
               _loc3_++;
            }
            _loc5_++;
         }
         LOCATION_HELPER_VECTOR.length = 0;
         return -1;
      }
      
      private function indexToItemRendererType(param1:int, param2:int) : Class
      {
         var _loc3_:int = 0;
         if(this._dataProvider !== null && this._dataProvider.getLengthAtLocation() > 0)
         {
            LOCATION_HELPER_VECTOR.length = 1;
            LOCATION_HELPER_VECTOR[0] = param1;
            _loc3_ = this._dataProvider.getLengthAtLocation(LOCATION_HELPER_VECTOR);
            LOCATION_HELPER_VECTOR.length = 0;
         }
         if(param2 == 0)
         {
            if(this._singleItemRendererType !== null && _loc3_ == 1)
            {
               return this._singleItemRendererType;
            }
            if(this._firstItemRendererType !== null)
            {
               return this._firstItemRendererType;
            }
         }
         if(this._lastItemRendererType !== null && param2 == _loc3_ - 1)
         {
            return this._lastItemRendererType;
         }
         return this._itemRendererType;
      }
      
      private function indexToCustomStyleName(param1:int, param2:int) : String
      {
         var _loc3_:int = 0;
         if(this._dataProvider !== null && this._dataProvider.getLengthAtLocation() > 0)
         {
            LOCATION_HELPER_VECTOR.length = 1;
            LOCATION_HELPER_VECTOR[0] = param1;
            _loc3_ = this._dataProvider.getLengthAtLocation(LOCATION_HELPER_VECTOR);
            LOCATION_HELPER_VECTOR.length = 0;
         }
         if(param2 == 0)
         {
            if(this._customSingleItemRendererStyleName !== null && _loc3_ == 1)
            {
               return this._customSingleItemRendererStyleName;
            }
            if(this._customFirstItemRendererStyleName !== null)
            {
               return this._customFirstItemRendererStyleName;
            }
         }
         if(this._customLastItemRendererStyleName !== null && param2 == _loc3_ - 1)
         {
            return this._customLastItemRendererStyleName;
         }
         return this._customItemRendererStyleName;
      }
      
      private function getFactoryID(param1:Object, param2:int, param3:int) : String
      {
         var _loc4_:String = null;
         if(this._factoryIDFunction !== null)
         {
            if(this._factoryIDFunction.length == 1)
            {
               _loc4_ = this._factoryIDFunction(param1);
            }
            else
            {
               _loc4_ = this._factoryIDFunction(param1,param2,param3);
            }
         }
         if(_loc4_ !== null)
         {
            return _loc4_;
         }
         var _loc5_:int = 0;
         if(this._dataProvider !== null && this._dataProvider.getLengthAtLocation() > 0)
         {
            LOCATION_HELPER_VECTOR.length = 1;
            LOCATION_HELPER_VECTOR[0] = param2;
            _loc5_ = this._dataProvider.getLengthAtLocation(LOCATION_HELPER_VECTOR);
            LOCATION_HELPER_VECTOR.length = 0;
         }
         if(param3 == 0)
         {
            if((this._singleItemRendererType !== null || this._singleItemRendererFactory !== null || this._customSingleItemRendererStyleName !== null) && _loc5_ == 1)
            {
               return SINGLE_ITEM_RENDERER_FACTORY_ID;
            }
            if(this._firstItemRendererType !== null || this._firstItemRendererFactory !== null || this._customFirstItemRendererStyleName !== null)
            {
               return FIRST_ITEM_RENDERER_FACTORY_ID;
            }
         }
         if((this._lastItemRendererType !== null || this._lastItemRendererFactory !== null || this._customLastItemRendererStyleName !== null) && param3 == _loc5_ - 1)
         {
            return LAST_ITEM_RENDERER_FACTORY_ID;
         }
         return null;
      }
      
      private function factoryIDToFactory(param1:String, param2:int, param3:int) : Function
      {
         switch(param1)
         {
            case null:
               return this._itemRendererFactory;
            case FIRST_ITEM_RENDERER_FACTORY_ID:
               if(this._firstItemRendererFactory !== null)
               {
                  return this._firstItemRendererFactory;
               }
               return this._itemRendererFactory;
               break;
            case LAST_ITEM_RENDERER_FACTORY_ID:
               if(this._lastItemRendererFactory !== null)
               {
                  return this._lastItemRendererFactory;
               }
               return this._itemRendererFactory;
               break;
            case SINGLE_ITEM_RENDERER_FACTORY_ID:
               if(this._singleItemRendererFactory !== null)
               {
                  return this._singleItemRendererFactory;
               }
               return this._itemRendererFactory;
               break;
            default:
               if(param1 in this._itemRendererFactories)
               {
                  return this._itemRendererFactories[param1] as Function;
               }
               throw new ReferenceError("Cannot find item renderer factory for ID \"" + param1 + "\".");
         }
      }
      
      private function factoryIDToStorage(param1:String, param2:int, param3:int) : ItemRendererFactoryStorage
      {
         var _loc4_:ItemRendererFactoryStorage = null;
         if(param1 !== null)
         {
            if(param1 in this._itemStorageMap)
            {
               return ItemRendererFactoryStorage(this._itemStorageMap[param1]);
            }
            _loc4_ = new ItemRendererFactoryStorage();
            this._itemStorageMap[param1] = _loc4_;
            return _loc4_;
         }
         return this._defaultItemRendererStorage;
      }
      
      private function getHeaderFactoryID(param1:Object, param2:int) : String
      {
         if(this._headerFactoryIDFunction === null)
         {
            return null;
         }
         if(this._headerFactoryIDFunction.length == 1)
         {
            return this._headerFactoryIDFunction(param1);
         }
         return this._headerFactoryIDFunction(param1,param2);
      }
      
      private function getFooterFactoryID(param1:Object, param2:int) : String
      {
         if(this._footerFactoryIDFunction === null)
         {
            return null;
         }
         if(this._footerFactoryIDFunction.length == 1)
         {
            return this._footerFactoryIDFunction(param1);
         }
         return this._footerFactoryIDFunction(param1,param2);
      }
      
      private function headerFactoryIDToFactory(param1:String) : Function
      {
         if(param1 !== null)
         {
            if(param1 in this._headerRendererFactories)
            {
               return this._headerRendererFactories[param1] as Function;
            }
            throw new ReferenceError("Cannot find header renderer factory for ID \"" + param1 + "\".");
         }
         return this._headerRendererFactory;
      }
      
      private function headerFactoryIDToStorage(param1:String) : HeaderRendererFactoryStorage
      {
         var _loc2_:HeaderRendererFactoryStorage = null;
         if(param1 !== null)
         {
            if(param1 in this._headerStorageMap)
            {
               return HeaderRendererFactoryStorage(this._headerStorageMap[param1]);
            }
            _loc2_ = new HeaderRendererFactoryStorage();
            this._headerStorageMap[param1] = _loc2_;
            return _loc2_;
         }
         return this._defaultHeaderRendererStorage;
      }
      
      private function footerFactoryIDToFactory(param1:String) : Function
      {
         if(param1 !== null)
         {
            if(param1 in this._footerRendererFactories)
            {
               return this._footerRendererFactories[param1] as Function;
            }
            throw new ReferenceError("Cannot find footer renderer factory for ID \"" + param1 + "\".");
         }
         return this._footerRendererFactory;
      }
      
      private function footerFactoryIDToStorage(param1:String) : FooterRendererFactoryStorage
      {
         var _loc2_:FooterRendererFactoryStorage = null;
         if(param1 !== null)
         {
            if(param1 in this._footerStorageMap)
            {
               return FooterRendererFactoryStorage(this._footerStorageMap[param1]);
            }
            _loc2_ = new FooterRendererFactoryStorage();
            this._footerStorageMap[param1] = _loc2_;
            return _loc2_;
         }
         return this._defaultFooterRendererStorage;
      }
      
      private function childProperties_onChange(param1:PropertyProxy, param2:String) : void
      {
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      private function dataProvider_changeHandler(param1:Event) : void
      {
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      private function dataProvider_addItemHandler(param1:Event, param2:Array) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc3_:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
         if(!_loc3_ || !_loc3_.hasVariableItemDimensions)
         {
            return;
         }
         var _loc4_:int = param2[0] as int;
         if(param2.length > 1)
         {
            _loc5_ = param2[1] as int;
            _loc6_ = this.locationToDisplayIndex(_loc4_,_loc5_);
            _loc3_.addToVariableVirtualCacheAtIndex(_loc6_);
         }
         else
         {
            _loc7_ = this.groupToHeaderDisplayIndex(_loc4_);
            if(_loc7_ >= 0)
            {
               _loc3_.addToVariableVirtualCacheAtIndex(_loc7_);
            }
            LOCATION_HELPER_VECTOR.length = 1;
            LOCATION_HELPER_VECTOR[0] = _loc4_;
            _loc8_ = this._dataProvider.getLengthAtLocation(LOCATION_HELPER_VECTOR);
            LOCATION_HELPER_VECTOR.length = 0;
            if(_loc8_ > 0)
            {
               _loc10_ = _loc7_;
               if(_loc10_ < 0)
               {
                  _loc10_ = this.locationToDisplayIndex(_loc4_,0);
               }
               _loc8_ += _loc10_;
               _loc11_ = _loc10_;
               while(_loc11_ < _loc8_)
               {
                  _loc3_.addToVariableVirtualCacheAtIndex(_loc10_);
                  _loc11_++;
               }
            }
            _loc9_ = this.groupToFooterDisplayIndex(_loc4_);
            if(_loc9_ >= 0)
            {
               _loc3_.addToVariableVirtualCacheAtIndex(_loc9_);
            }
         }
      }
      
      private function dataProvider_removeItemHandler(param1:Event, param2:Array) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc3_:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
         if(!_loc3_ || !_loc3_.hasVariableItemDimensions)
         {
            return;
         }
         var _loc4_:int = param2[0] as int;
         if(param2.length > 1)
         {
            _loc5_ = param2[1] as int;
            _loc6_ = this.locationToDisplayIndex(_loc4_,_loc5_);
            _loc3_.removeFromVariableVirtualCacheAtIndex(_loc6_);
         }
         else
         {
            _loc3_.resetVariableVirtualCache();
         }
      }
      
      private function dataProvider_replaceItemHandler(param1:Event, param2:Array) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc3_:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
         if(!_loc3_ || !_loc3_.hasVariableItemDimensions)
         {
            return;
         }
         var _loc4_:int = param2[0] as int;
         if(param2.length > 1)
         {
            _loc5_ = param2[1] as int;
            _loc6_ = this.locationToDisplayIndex(_loc4_,_loc5_);
            _loc3_.resetVariableVirtualCacheAtIndex(_loc6_);
         }
         else
         {
            _loc3_.resetVariableVirtualCache();
         }
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
      
      private function dataProvider_updateItemHandler(param1:Event, param2:Array) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:IGroupedListItemRenderer = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Object = null;
         var _loc10_:IVariableVirtualLayout = null;
         var _loc11_:IGroupedListHeaderRenderer = null;
         var _loc12_:IGroupedListFooterRenderer = null;
         var _loc3_:int = param2[0] as int;
         if(param2.length > 1)
         {
            _loc4_ = param2[1] as int;
            LOCATION_HELPER_VECTOR.length = 2;
            LOCATION_HELPER_VECTOR[0] = _loc3_;
            LOCATION_HELPER_VECTOR[1] = _loc4_;
            _loc5_ = this._dataProvider.getItemAtLocation(LOCATION_HELPER_VECTOR);
            LOCATION_HELPER_VECTOR.length = 0;
            _loc6_ = this.itemToItemRenderer(_loc5_);
            if(_loc6_ !== null)
            {
               _loc6_.data = null;
               _loc6_.data = _loc5_;
               if(this._explicitVisibleWidth !== this._explicitVisibleWidth || this._explicitVisibleHeight !== this._explicitVisibleHeight)
               {
                  this.invalidate(INVALIDATION_FLAG_SIZE);
                  this.invalidateParent(INVALIDATION_FLAG_SIZE);
               }
            }
         }
         else
         {
            LOCATION_HELPER_VECTOR.length = 1;
            LOCATION_HELPER_VECTOR[0] = _loc3_;
            _loc7_ = this._dataProvider.getLengthAtLocation(LOCATION_HELPER_VECTOR);
            LOCATION_HELPER_VECTOR.length = 2;
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               LOCATION_HELPER_VECTOR[1] = _loc8_;
               _loc5_ = this._dataProvider.getItemAtLocation(LOCATION_HELPER_VECTOR);
               if(_loc5_ !== null)
               {
                  _loc6_ = this.itemToItemRenderer(_loc5_);
                  if(_loc6_ !== null)
                  {
                     _loc6_.data = null;
                     _loc6_.data = _loc5_;
                  }
               }
               _loc8_++;
            }
            LOCATION_HELPER_VECTOR.length = 1;
            _loc9_ = this._dataProvider.getItemAtLocation(LOCATION_HELPER_VECTOR);
            LOCATION_HELPER_VECTOR.length = 0;
            _loc5_ = this._owner.groupToHeaderData(_loc9_);
            if(_loc5_)
            {
               _loc11_ = this.headerDataToHeaderRenderer(_loc5_);
               if(_loc11_)
               {
                  _loc11_.data = null;
                  _loc11_.data = _loc5_;
               }
            }
            _loc5_ = this._owner.groupToFooterData(_loc9_);
            if(_loc5_)
            {
               _loc12_ = this.footerDataToFooterRenderer(_loc5_);
               if(_loc12_)
               {
                  _loc12_.data = null;
                  _loc12_.data = _loc5_;
               }
            }
            this.invalidate(INVALIDATION_FLAG_DATA);
            _loc10_ = this._layout as IVariableVirtualLayout;
            if(_loc10_ === null || !_loc10_.hasVariableItemDimensions)
            {
               return;
            }
            _loc10_.resetVariableVirtualCache();
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
      
      private function itemRenderer_resizeHandler(param1:Event) : void
      {
         if(this._ignoreRendererResizing)
         {
            return;
         }
         if(param1.currentTarget === this._typicalItemRenderer && !this._typicalItemIsInDataProvider)
         {
            return;
         }
         var _loc2_:IGroupedListItemRenderer = IGroupedListItemRenderer(param1.currentTarget);
         if(_loc2_.layoutIndex < 0)
         {
            return;
         }
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
         this.invalidateParent(INVALIDATION_FLAG_LAYOUT);
         var _loc3_:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
         if(!_loc3_ || !_loc3_.hasVariableItemDimensions)
         {
            return;
         }
         _loc3_.resetVariableVirtualCacheAtIndex(_loc2_.layoutIndex,DisplayObject(_loc2_));
      }
      
      private function headerRenderer_resizeHandler(param1:Event) : void
      {
         if(this._ignoreRendererResizing)
         {
            return;
         }
         var _loc2_:IGroupedListHeaderRenderer = IGroupedListHeaderRenderer(param1.currentTarget);
         if(_loc2_.layoutIndex < 0)
         {
            return;
         }
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
         this.invalidateParent(INVALIDATION_FLAG_LAYOUT);
         var _loc3_:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
         if(!_loc3_ || !_loc3_.hasVariableItemDimensions)
         {
            return;
         }
         _loc3_.resetVariableVirtualCacheAtIndex(_loc2_.layoutIndex,DisplayObject(_loc2_));
      }
      
      private function footerRenderer_resizeHandler(param1:Event) : void
      {
         if(this._ignoreRendererResizing)
         {
            return;
         }
         var _loc2_:IGroupedListFooterRenderer = IGroupedListFooterRenderer(param1.currentTarget);
         if(_loc2_.layoutIndex < 0)
         {
            return;
         }
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
         this.invalidateParent(INVALIDATION_FLAG_LAYOUT);
         var _loc3_:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
         if(!_loc3_ || !_loc3_.hasVariableItemDimensions)
         {
            return;
         }
         _loc3_.resetVariableVirtualCacheAtIndex(_loc2_.layoutIndex,DisplayObject(_loc2_));
      }
      
      private function renderer_triggeredHandler(param1:Event) : void
      {
         var _loc2_:IGroupedListItemRenderer = IGroupedListItemRenderer(param1.currentTarget);
         this.parent.dispatchEventWith(Event.TRIGGERED,false,_loc2_.data);
      }
      
      private function renderer_changeHandler(param1:Event) : void
      {
         if(this._ignoreSelectionChanges)
         {
            return;
         }
         var _loc2_:IGroupedListItemRenderer = IGroupedListItemRenderer(param1.currentTarget);
         if(!this._isSelectable || this._owner.isScrolling)
         {
            _loc2_.isSelected = false;
            return;
         }
         if(_loc2_.isSelected)
         {
            this.setSelectedLocation(_loc2_.groupIndex,_loc2_.itemIndex);
         }
         else
         {
            this.setSelectedLocation(-1,-1);
         }
      }
   }
}

import feathers.controls.renderers.IGroupedListFooterRenderer;
import feathers.controls.renderers.IGroupedListHeaderRenderer;
import feathers.controls.renderers.IGroupedListItemRenderer;

class ItemRendererFactoryStorage
{
   
   public var activeItemRenderers:Vector.<IGroupedListItemRenderer> = new Vector.<IGroupedListItemRenderer>(0);
   
   public var inactiveItemRenderers:Vector.<IGroupedListItemRenderer> = new Vector.<IGroupedListItemRenderer>(0);
   
   public function ItemRendererFactoryStorage()
   {
      super();
   }
}

class HeaderRendererFactoryStorage
{
   
   public var activeHeaderRenderers:Vector.<IGroupedListHeaderRenderer> = new Vector.<IGroupedListHeaderRenderer>(0);
   
   public var inactiveHeaderRenderers:Vector.<IGroupedListHeaderRenderer> = new Vector.<IGroupedListHeaderRenderer>(0);
   
   public function HeaderRendererFactoryStorage()
   {
      super();
   }
}

class FooterRendererFactoryStorage
{
   
   public var activeFooterRenderers:Vector.<IGroupedListFooterRenderer> = new Vector.<IGroupedListFooterRenderer>(0);
   
   public var inactiveFooterRenderers:Vector.<IGroupedListFooterRenderer> = new Vector.<IGroupedListFooterRenderer>(0);
   
   public function FooterRendererFactoryStorage()
   {
      super();
   }
}
