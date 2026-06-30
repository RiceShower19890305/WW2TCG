package feathers.layout
{
   import starling.display.DisplayObject;
   
   public interface IDragDropLayout extends ILayout
   {
      
      function getDropIndex(param1:Number, param2:Number, param3:Vector.<DisplayObject>, param4:Number, param5:Number, param6:Number, param7:Number) : int;
      
      function positionDropIndicator(param1:DisplayObject, param2:int, param3:Number, param4:Number, param5:Vector.<DisplayObject>, param6:Number, param7:Number) : void;
   }
}

