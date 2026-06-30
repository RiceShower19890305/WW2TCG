package feathers.data
{
   import feathers.core.IFeathersEventDispatcher;
   
   public interface IHierarchicalCollection extends IFeathersEventDispatcher
   {
      
      function isBranch(param1:Object) : Boolean;
      
      function getLength(... rest) : int;
      
      function getLengthAtLocation(param1:Vector.<int> = null) : int;
      
      function updateItemAt(param1:int, ... rest) : void;
      
      function updateAll() : void;
      
      function getItemAt(param1:int, ... rest) : Object;
      
      function getItemAtLocation(param1:Vector.<int>) : Object;
      
      function getItemLocation(param1:Object, param2:Vector.<int> = null) : Vector.<int>;
      
      function addItemAt(param1:Object, param2:int, ... rest) : void;
      
      function addItemAtLocation(param1:Object, param2:Vector.<int>) : void;
      
      function removeItemAt(param1:int, ... rest) : Object;
      
      function removeItemAtLocation(param1:Vector.<int>) : Object;
      
      function removeItem(param1:Object) : void;
      
      function removeAll() : void;
      
      function setItemAt(param1:Object, param2:int, ... rest) : void;
      
      function setItemAtLocation(param1:Object, param2:Vector.<int>) : void;
      
      function dispose(param1:Function, param2:Function) : void;
   }
}

