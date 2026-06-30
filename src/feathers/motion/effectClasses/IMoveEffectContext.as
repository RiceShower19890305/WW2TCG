package feathers.motion.effectClasses
{
   public interface IMoveEffectContext extends IEffectContext
   {
      
      function get oldX() : Number;
      
      function set oldX(param1:Number) : void;
      
      function get oldY() : Number;
      
      function set oldY(param1:Number) : void;
      
      function get newX() : Number;
      
      function set newX(param1:Number) : void;
      
      function get newY() : Number;
      
      function set newY(param1:Number) : void;
   }
}

