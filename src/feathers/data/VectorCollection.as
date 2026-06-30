package feathers.data
{
   import feathers.events.CollectionEventType;
   import starling.events.Event;
   import starling.events.EventDispatcher;
   
   public class VectorCollection extends EventDispatcher implements IListCollection
   {
      
      protected var _filterAndSortData:Object;
      
      protected var _vectorData:Object;
      
      protected var _pendingRefresh:Boolean = false;
      
      protected var _filterFunction:Function = null;
      
      protected var _sortCompareFunction:Function = null;
      
      public function VectorCollection(param1:Object = null)
      {
         super();
         if(param1 === null)
         {
            param1 = new Vector.<*>(0);
         }
         else if(!(param1 is Vector.<*>))
         {
            throw new ArgumentError("VectorCollection data must be of type Vector");
         }
         this._vectorData = param1;
      }
      
      public function get vectorData() : Object
      {
         return this._vectorData;
      }
      
      public function set vectorData(param1:Object) : void
      {
         if(this._vectorData === param1)
         {
            return;
         }
         if(param1 !== null && !(param1 is Vector.<*>))
         {
            throw new ArgumentError("VectorCollection vectorData must be of type Vector");
         }
         this._vectorData = param1 as Vector.<*>;
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
         if(this._pendingRefresh)
         {
            this.refreshFilterAndSort();
         }
         if(this._filterAndSortData !== null)
         {
            return (this._filterAndSortData as Vector.<*>).length;
         }
         return (this._vectorData as Vector.<*>).length;
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
         var _loc1_:Vector.<*> = null;
         var _loc2_:Vector.<*> = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         this._pendingRefresh = false;
         if(this._filterFunction !== null)
         {
            _loc1_ = this._filterAndSortData as Vector.<*>;
            if(_loc1_ !== null)
            {
               _loc1_.length = 0;
            }
            else
            {
               _loc1_ = new Vector.<*>(0);
            }
            _loc2_ = this._vectorData as Vector.<*>;
            _loc3_ = int(_loc2_.length);
            _loc4_ = 0;
            _loc5_ = 0;
            while(_loc5_ < _loc3_)
            {
               _loc6_ = _loc2_[_loc5_];
               if(this._filterFunction(_loc6_))
               {
                  _loc1_[_loc4_] = _loc6_;
                  _loc4_++;
               }
               _loc5_++;
            }
            this._filterAndSortData = _loc1_;
         }
         else if(this._sortCompareFunction !== null)
         {
            _loc3_ = int(this._vectorData.length);
            _loc1_ = this._filterAndSortData as Vector.<*>;
            if(_loc1_ !== null)
            {
               _loc1_.length = _loc3_;
               _loc5_ = 0;
               while(_loc5_ < _loc3_)
               {
                  _loc1_[_loc5_] = this._vectorData[_loc5_];
                  _loc5_++;
               }
            }
            else
            {
               _loc1_ = this._vectorData.slice();
            }
            this._filterAndSortData = _loc1_;
         }
         else
         {
            this._filterAndSortData = null;
         }
         if(this._sortCompareFunction !== null)
         {
            this._filterAndSortData.sort(this._sortCompareFunction);
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
         if(this._filterAndSortData !== null)
         {
            return this._filterAndSortData[param1];
         }
         return (this._vectorData as Vector.<*>)[param1];
      }
      
      public function getItemIndex(param1:Object) : int
      {
         if(this._pendingRefresh)
         {
            this.refreshFilterAndSort();
         }
         if(this._filterAndSortData !== null)
         {
            return (this._filterAndSortData as Vector.<*>).indexOf(param1);
         }
         return (this._vectorData as Vector.<*>).indexOf(param1);
      }
      
      public function addItemAt(param1:Object, param2:int) : void
      {
         var _loc5_:Boolean = false;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(this._pendingRefresh)
         {
            this.refreshFilterAndSort();
         }
         var _loc3_:Vector.<*> = this._filterAndSortData as Vector.<*>;
         var _loc4_:Vector.<*> = this._vectorData as Vector.<*>;
         if(this._filterAndSortData !== null)
         {
            if(param2 < _loc3_.length)
            {
               _loc6_ = _loc3_[param2];
               _loc7_ = _loc4_.indexOf(_loc6_);
            }
            else
            {
               _loc7_ = int(_loc4_.length);
            }
            _loc4_.insertAt(_loc7_,param1);
            _loc5_ = true;
            if(this._filterFunction !== null)
            {
               _loc5_ = this._filterFunction(param1);
            }
            if(_loc5_)
            {
               _loc8_ = param2;
               if(this._sortCompareFunction !== null)
               {
                  _loc8_ = this.getSortedInsertionIndex(param1);
               }
               _loc3_.insertAt(_loc8_,param1);
               this.dispatchEventWith(Event.CHANGE);
               this.dispatchEventWith(CollectionEventType.ADD_ITEM,false,_loc8_);
            }
         }
         else
         {
            _loc4_.insertAt(param2,param1);
            this.dispatchEventWith(Event.CHANGE);
            this.dispatchEventWith(CollectionEventType.ADD_ITEM,false,param2);
         }
      }
      
      public function removeItemAt(param1:int) : Object
      {
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         if(this._pendingRefresh)
         {
            this.refreshFilterAndSort();
         }
         var _loc2_:Vector.<*> = this._filterAndSortData as Vector.<*>;
         var _loc3_:Vector.<*> = this._vectorData as Vector.<*>;
         if(this._filterAndSortData !== null)
         {
            _loc4_ = _loc2_.removeAt(param1);
            _loc5_ = _loc3_.indexOf(_loc4_);
            _loc3_.removeAt(_loc5_);
         }
         else
         {
            _loc4_ = _loc3_.removeAt(param1);
         }
         this.dispatchEventWith(Event.CHANGE);
         this.dispatchEventWith(CollectionEventType.REMOVE_ITEM,false,param1);
         return _loc4_;
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
         if(this._filterAndSortData !== null)
         {
            (this._filterAndSortData as Vector.<*>).length = 0;
         }
         else
         {
            (this._vectorData as Vector.<*>).length = 0;
         }
         this.dispatchEventWith(CollectionEventType.REMOVE_ALL);
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function setItemAt(param1:Object, param2:int) : void
      {
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         if(this._pendingRefresh)
         {
            this.refreshFilterAndSort();
         }
         var _loc3_:Vector.<*> = this._filterAndSortData as Vector.<*>;
         var _loc4_:Vector.<*> = this._vectorData as Vector.<*>;
         if(this._filterAndSortData !== null)
         {
            _loc5_ = _loc3_[param2];
            _loc6_ = _loc4_.indexOf(_loc5_);
            _loc4_[_loc6_] = param1;
            if(this._filterFunction !== null)
            {
               _loc7_ = this._filterFunction(param1);
               if(_loc7_)
               {
                  _loc3_[param2] = param1;
                  this.dispatchEventWith(Event.CHANGE);
                  this.dispatchEventWith(CollectionEventType.REPLACE_ITEM,false,param2);
                  return;
               }
               _loc3_.removeAt(param2);
               this.dispatchEventWith(Event.CHANGE);
               this.dispatchEventWith(CollectionEventType.REMOVE_ITEM,false,param2);
               return;
            }
            if(this._sortCompareFunction !== null)
            {
               this._filterAndSortData.removeAt(param2);
               _loc8_ = this.getSortedInsertionIndex(param1);
               this._filterAndSortData[_loc8_] = param1;
               this.dispatchEventWith(Event.CHANGE);
               this.dispatchEventWith(CollectionEventType.REPLACE_ITEM,false,param2);
               return;
            }
         }
         else
         {
            _loc4_[param2] = param1;
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
         var _loc6_:Object = null;
         var _loc2_:int = param1.length;
         var _loc3_:Vector.<*> = this._vectorData as Vector.<*>;
         var _loc4_:int = int(_loc3_.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc2_)
         {
            _loc6_ = param1.getItemAt(_loc5_);
            _loc3_[_loc4_] = _loc6_;
            _loc4_++;
            _loc5_++;
         }
      }
      
      public function addAllAt(param1:IListCollection, param2:int) : void
      {
         var _loc7_:Object = null;
         var _loc3_:int = param1.length;
         var _loc4_:int = param2;
         var _loc5_:Vector.<*> = this._vectorData as Vector.<*>;
         var _loc6_:int = 0;
         while(_loc6_ < _loc3_)
         {
            _loc7_ = param1.getItemAt(_loc6_);
            _loc5_.insertAt(_loc4_,_loc7_);
            _loc4_++;
            _loc6_++;
         }
      }
      
      public function reset(param1:IListCollection) : void
      {
         var _loc5_:Object = null;
         var _loc2_:Vector.<*> = this._vectorData as Vector.<*>;
         _loc2_.length = 0;
         var _loc3_:int = param1.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1.getItemAt(_loc4_);
            _loc2_[_loc4_] = _loc5_;
            _loc4_++;
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
         return (this._vectorData as Vector.<*>).indexOf(param1) != -1;
      }
      
      public function dispose(param1:Function) : void
      {
         var _loc5_:Object = null;
         this._filterFunction = null;
         this.refreshFilterAndSort();
         var _loc2_:Vector.<*> = this._vectorData as Vector.<*>;
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            param1(_loc5_);
            _loc4_++;
         }
      }
      
      protected function getSortedInsertionIndex(param1:Object) : int
      {
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc2_:int = int(this._filterAndSortData.length);
         if(this._sortCompareFunction === null)
         {
            return _loc2_;
         }
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._filterAndSortData[_loc3_];
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

