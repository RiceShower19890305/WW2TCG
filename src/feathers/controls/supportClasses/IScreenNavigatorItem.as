package feathers.controls.supportClasses
{
   import starling.display.DisplayObject;
   
   public interface IScreenNavigatorItem
   {
      
      function get transitionDelayEvent() : String;
      
      function get canDispose() : Boolean;
      
      function getScreen() : DisplayObject;
   }
}

