package feathers.motion.effectClasses
{
   public interface IResizeEffectContext extends IEffectContext
   {
      
      function get oldWidth() : Number;
      
      function set oldWidth(param1:Number) : void;
      
      function get oldHeight() : Number;
      
      function set oldHeight(param1:Number) : void;
      
      function get newWidth() : Number;
      
      function set newWidth(param1:Number) : void;
      
      function get newHeight() : Number;
      
      function set newHeight(param1:Number) : void;
   }
}

