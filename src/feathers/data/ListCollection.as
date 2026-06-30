package feathers.data
{
   import feathers.events.CollectionEventType;
   import starling.events.Event;
   import starling.events.EventDispatcher;
   
   public class ListCollection extends EventDispatcher implements IListCollection
   {
      
      protected var _localDataDescriptor:ArrayListCollectionDataDescriptor;
      
      protected var _localData:Array;
      
      protected var _data:Object;
      
      protected var _dataDescriptor:IListCollectionDataDescriptor;
      
      protected var _pendingRefresh:Boolean = false;
      
      protected var _filterFunction:Function = null;
      
      protected var _sortCompareFunction:Function = null;
      
      public function ListCollection(param1:Object = null)
      {
         super();
         if(!param1)
         {
            param1 = [];
         }
         this.data = param1;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(param1:Object) : void
      {
         if(this._data == param1)
         {
            return;
         }
         this._data = param1;
         if(this._data is Array && !(this._dataDescriptor is ArrayListCollectionDataDescriptor))
         {
            this._dataDescriptor = new ArrayListCollectionDataDescriptor();
         }
         else if(this._data is Vector.<Number> && !(this._dataDescriptor is VectorNumberListCollectionDataDescriptor))
         {
            this._dataDescriptor = new VectorNumberListCollectionDataDescriptor();
         }
         else if(this._data is Vector.<int> && !(this._dataDescriptor is VectorIntListCollectionDataDescriptor))
         {
            this._dataDescriptor = new VectorIntListCollectionDataDescriptor();
         }
         else if(this._data is Vector.<uint> && !(this._dataDescriptor is VectorUintListCollectionDataDescriptor))
         {
            this._dataDescriptor = new VectorUintListCollectionDataDescriptor();
         }
         else if(this._data is Vector.<*> && !(this._dataDescriptor is VectorListCollectionDataDescriptor))
         {
            this._dataDescriptor = new VectorListCollectionDataDescriptor();
         }
         else if(this._data is XMLList && !(this._dataDescriptor is XMLListListCollectionDataDescriptor))
         {
            this._dataDescriptor = new XMLListListCollectionDataDescriptor();
         }
         if(this._data === null)
         {
            this._dataDescriptor = null;
         }
         this.dispatchEventWith(CollectionEventType.RESET);
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get dataDescriptor() : IListCollectionDataDescriptor
      {
         return this._dataDescriptor;
      }
      
      public function set dataDescriptor(param1:IListCollectionDataDescriptor) : void
      {
         if(this._dataDescriptor == param1)
         {
            return;
         }
         this._dataDescriptor = param1;
         this.dispatchEventWith(CollectionEventType.RESET);
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get filterFunction() : Function
      {
         return this._filterFunction;
      }
      
      public function set filterFunction(param1:Function) : void
      {
         if(this._filterFunction === param1)
         {
            return;
         }
         this._filterFunction = param1;
         this._pendingRefresh = true;
         this.dispatchEventWith(Event.CHANGE);
         this.dispatchEventWith(CollectionEventType.FILTER_CHANGE);
      }
      
      public function get sortCompareFunction() : Function
      {
         return this._sortCompareFunction;
      }
      
      public function set sortCompareFunction(param1:Function) : void
      {
         if(this._sortCompareFunction === param1)
         {
            return;
         }
         this._sortCompareFunction = param1;
         this._pendingRefresh = true;
         this.dispatchEventWith(Event.CHANGE);
         this.dispatchEventWith(CollectionEventType.SORT_CHANGE);
      }
      
      public function get length() : int
      {
         if(!this._dataDescriptor)
         {
            return 0;
         }
         if(this._pendingRefresh)
         {
            this.refreshFilterAndSort();
         }
         if(this._localData !== null)
         {
            return this._localDataDescriptor.getLength(this._localData);
         }
         return this._dataDescriptor.getLength(this._data);
      }
      
      public function refresh() : void
      {
         if(this._filterFunction === null && this._sortCompareFunction === null)
         {
            return;
         }
         this._pendingRefresh = true;
         this.dispatchEventWith(Event.CHANGE);
         if(this._filterFunction !== null)
         {
            this.dispatchEventWith(CollectionEventType.FILTER_CHANGE);
         }
         if(this._sortCompareFunction !== null)
         {
            this.dispatchEventWith(CollectionEventType.SORT_CHANGE);
         }
      }
      
      protected function refreshFilterAndSort() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         this._pendingRefresh = false;
         if(this._filterFunction !== null)
         {
            _loc1_ = this._localData;
            if(_loc1_ !== null)
            {
               _loc1_.length = 0;
            }
            else
            {
               _loc1_ = [];
            }
            _loc2_ = this._dataDescriptor.getLength(this._data);
            _loc3_ = 0;
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               _loc5_ = this._dataDescriptor.getItemAt(this._data,_loc4_);
               if(this._filterFunction(_loc5_))
               {
                  _loc1_[_loc3_] = _loc5_;
                  _loc3_++;
               }
               _loc4_++;
            }
            this._localData = _loc1_;
            this._localDataDescriptor = new ArrayListCollectionDataDescriptor();
         }
         else if(this._sortCompareFunction !== null)
         {
            _loc2_ = this._dataDescriptor.getLength(this._data);
            if(this._localData === null)
            {
               this._localData = new Array(_loc2_);
            }
            else
            {
               this._localData.length = _loc2_;
            }
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               this._localData[_loc4_] = this._dataDescriptor.getItemAt(this._data,_loc4_);
               _loc4_++;
            }
            this._localDataDescriptor = new ArrayListCollectionDataDescriptor();
         }
         else
         {
            this._localData = null;
            this._localDataDescriptor = null;
         }
         if(this._sortCompareFunction !== null)
         {
            this._localData.sort(this._sortCompareFunction);
         }
      }
      
      public function updateItemAt(param1:int) : void
      {
         this.dispatchEventWith(CollectionEventType.UPDATE_ITEM,false,param1);
      }
      
      public function updateAll() : void
      {
         this.dispatchEventWith(CollectionEventType.UPDATE_ALL);
      }
      
      public function getItemAt(param1:int) : Object
      {
         if(this._pendingRefresh)
         {
            this.refreshFilterAndSort();
         }
         if(this._localData !== null)
         {
            return this._localDataDescriptor.getItemAt(this._localData,param1);
         }
         return this._dataDescriptor.getItemAt(this._data,param1);
      }
      
      public function getItemIndex(param1:Object) : int
      {
         if(this._pendingRefresh)
         {
            this.refreshFilterAndSort();
         }
         if(this._localData !== null)
         {
            return this._localDataDescriptor.getItemIndex(this._localData,param1);
         }
         return this._dataDescriptor.getItemIndex(this._data,param1);
      }
      
      public function addItemAt(param1:Object, param2:int) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(this._pendingRefresh)
         {
            this.refreshFilterAndSort();
         }
         if(this._localData !== null)
         {
            if(param2 < this._localDataDescriptor.getLength(this._localData))
            {
               _loc4_ = this._localDataDescriptor.getItemAt(this._localData,param2);
               _loc5_ = this._dataDescriptor.getItemIndex(this._data,_loc4_);
            }
            else
            {
               _loc5_ = this._dataDescriptor.getLength(this._data);
            }
            this._dataDescriptor.addItemAt(this._data,param1,_loc5_);
            _loc3_ = true;
            if(this._filterFunction !== null)
            {
               _loc3_ = this._filterFunction(param1);
            }
            if(_loc3_)
            {
               _loc6_ = param2;
               if(this._sortCompareFunction !== null)
               {
                  _loc6_ = this.getSortedInsertionIndex(param1);
               }
               this._localDataDescriptor.addItemAt(this._localData,param1,_loc6_);
               this.dispatchEventWith(Event.CHANGE);
               this.dispatchEventWith(CollectionEventType.ADD_ITEM,false,_loc6_);
            }
         }
         else
         {
            this._dataDescriptor.addItemAt(this._data,param1,param2);
            this.dispatchEventWith(Event.CHANGE);
            this.dispatchEventWith(CollectionEventType.ADD_ITEM,false,param2);
         }
      }
      
      public function removeItemAt(param1:int) : Object
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         if(this._pendingRefresh)
         {
            this.refreshFilterAndSort();
         }
         if(this._localData !== null)
         {
            _loc2_ = this._localDataDescriptor.removeItemAt(this._localData,param1);
            _loc3_ = this._dataDescriptor.getItemIndex(this._data,_loc2_);
            this._dataDescriptor.removeItemAt(this._data,_loc3_);
         }
         else
         {
            _loc2_ = this._dataDescriptor.removeItemAt(this._data,param1);
         }
         this.dispatchEventWith(Event.CHANGE);
         this.dispatchEventWith(CollectionEventType.REMOVE_ITEM,false,param1);
         return _loc2_;
      }
      
      public function removeItem(param1:Object) : void
      {
         var _loc2_:int = this.getItemIndex(param1);
         if(_loc2_ >= 0)
         {
            this.removeItemAt(_loc2_);
         }
      }
      
      public function removeAll() : void
      {
         if(this._pendingRefresh)
         {
            this.refreshFilterAndSort();
         }
         if(this.length == 0)
         {
            return;
         }
         if(this._localData !== null)
         {
            this._localDataDescriptor.removeAll(this._localData);
         }
         else
         {
            this._dataDescriptor.removeAll(this._data);
         }
         this.dispatchEventWith(CollectionEventType.REMOVE_ALL);
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function setItemAt(param1:Object, param2:int) : void
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         if(this._pendingRefresh)
         {
            this.refreshFilterAndSort();
         }
         if(this._localData !== null)
         {
            _loc3_ = this._localDataDescriptor.getItemAt(this._localData,param2);
            _loc4_ = this._dataDescriptor.getItemIndex(this._data,_loc3_);
            this._dataDescriptor.setItemAt(this._data,param1,_loc4_);
            if(this._filterFunction !== null)
            {
               _loc5_ = this._filterFunction(param1);
               if(_loc5_)
               {
                  this._localDataDescriptor.setItemAt(this._localData,param1,param2);
                  this.dispatchEventWith(Event.CHANGE);
                  this.dispatchEventWith(CollectionEventType.REPLACE_ITEM,false,param2);
                  return;
               }
               this._localDataDescriptor.removeItemAt(this._localData,param2);
               this.dispatchEventWith(Event.CHANGE);
               this.dispatchEventWith(CollectionEventType.REMOVE_ITEM,false,param2);
            }
            else if(this._sortCompareFunction !== null)
            {
               this._localDataDescriptor.removeItemAt(this._localData,param2);
               _loc6_ = this.getSortedInsertionIndex(param1);
               this._localDataDescriptor.setItemAt(this._localData,param1,_loc6_);
               this.dispatchEventWith(Event.CHANGE);
               this.dispatchEventWith(CollectionEventType.REPLACE_ITEM,false,param2);
               return;
            }
         }
         else
         {
            this._dataDescriptor.setItemAt(this._data,param1,param2);
            this.dispatchEventWith(Event.CHANGE);
            this.dispatchEventWith(CollectionEventType.REPLACE_ITEM,false,param2);
         }
      }
      
      public function addItem(param1:Object) : void
      {
         this.addItemAt(param1,this.length);
      }
      
      public function push(param1:Object) : void
      {
         this.addItemAt(param1,this.length);
      }
      
      public function addAll(param1:IListCollection) : void
      {
         var _loc4_:Object = null;
         var _loc2_:int = param1.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1.getItemAt(_loc3_);
            this.addItem(_loc4_);
            _loc3_++;
         }
      }
      
      public function addAllAt(param1:IListCollection, param2:int) : void
      {
         var _loc6_:Object = null;
         var _loc3_:int = param1.length;
         var _loc4_:int = param2;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc6_ = param1.getItemAt(_loc5_);
            this.addItemAt(_loc6_,_loc4_);
            _loc4_++;
            _loc5_++;
         }
      }
      
      public function reset(param1:IListCollection) : void
      {
         var _loc4_:Object = null;
         this._dataDescriptor.removeAll(this._data);
         var _loc2_:int = param1.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1.getItemAt(_loc3_);
            this._dataDescriptor.addItemAt(this._data,_loc4_,_loc3_);
            _loc3_++;
         }
         this.dispatchEventWith(CollectionEventType.RESET);
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function pop() : Object
      {
         return this.removeItemAt(this.length - 1);
      }
      
      public function unshift(param1:Object) : void
      {
         this.addItemAt(param1,0);
      }
      
      public function shift() : Object
      {
         return this.removeItemAt(0);
      }
      
      public function contains(param1:Object) : Boolean
      {
         return this.getItemIndex(param1) >= 0;
      }
      
      public function dispose(param1:Function) : void
      {
         var _loc4_:Object = null;
         this._filterFunction = null;
         this.refreshFilterAndSort();
         var _loc2_:int = this.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.getItemAt(_loc3_);
            param1(_loc4_);
            _loc3_++;
         }
      }
      
      protected function getSortedInsertionIndex(param1:Object) : int
      {
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc2_:int = this._localDataDescriptor.getLength(this._localData);
         if(this._sortCompareFunction === null)
         {
            return _loc2_;
         }
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._localDataDescriptor.getItemAt(this._localData,_loc3_);
            _loc5_ = this._sortCompareFunction(param1,_loc4_);
            if(_loc5_ < 1)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return _loc2_;
      }
   }
}

