package feathers.controls.renderers
{
   import feathers.controls.Tree;
   import feathers.core.IToggle;
   
   public interface ITreeItemRenderer extends IToggle
   {
      
      function get data() : Object;
      
      function set data(param1:Object) : void;
      
      function get owner() : Tree;
      
      function set owner(param1:Tree) : void;
      
      function get location() : Vector.<int>;
      
      function set location(param1:Vector.<int>) : void;
      
      function get layoutIndex() : int;
      
      function set layoutIndex(param1:int) : void;
      
      function get factoryID() : String;
      
      function set factoryID(param1:String) : void;
      
      function get isBranch() : Boolean;
      
      function set isBranch(param1:Boolean) : void;
      
      function get isOpen() : Boolean;
      
      function set isOpen(param1:Boolean) : void;
   }
}

