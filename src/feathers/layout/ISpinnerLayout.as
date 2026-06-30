package feathers.layout
{
   import flash.geom.Rectangle;
   
   public interface ISpinnerLayout extends ILayout
   {
      
      function get snapInterval() : Number;
      
      function get selectionBounds() : Rectangle;
   }
}

