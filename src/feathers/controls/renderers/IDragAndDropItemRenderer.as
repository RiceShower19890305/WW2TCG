package feathers.controls.renderers
{
   import starling.display.DisplayObject;
   
   public interface IDragAndDropItemRenderer
   {
      
      function get dragEnabled() : Boolean;
      
      function set dragEnabled(param1:Boolean) : void;
      
      function get dragProxy() : DisplayObject;
   }
}

