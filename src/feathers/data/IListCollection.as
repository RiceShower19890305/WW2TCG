package feathers.data
{
   import feathers.core.IFeathersEventDispatcher;
   
   public interface IListCollection extends IFeathersEventDispatcher
   {
      
      function get length() : int;
      
      function get filterFunction() : Function;
      
      function set filterFunction(param1:Function) : void;
      
      function get sortCompareFunction() : Function;
      
      function set sortCompareFunction(param1:Function) : void;
      
      function refresh() : void;
      
      function updateItemAt(param1:int) : void;
      
      function updateAll() : void;
      
      function getItemAt(param1:int) : Object;
      
      function getItemIndex(param1:Object) : int;
      
      function addItemAt(param1:Object, param2:int) : void;
      
      function removeItemAt(param1:int) : Object;
      
      function removeItem(param1:Object) : void;
      
      function removeAll() : void;
      
      function setItemAt(param1:Object, param2:int) : void;
      
      function addItem(param1:Object) : void;
      
      function addAll(param1:IListCollection) : void;
      
      function addAllAt(param1:IListCollection, param2:int) : void;
      
      function reset(param1:IListCollection) : void;
      
      function push(param1:Object) : void;
      
      function pop() : Object;
      
      function unshift(param1:Object) : void;
      
      function shift() : Object;
      
      function contains(param1:Object) : Boolean;
      
      function dispose(param1:Function) : void;
   }
}

