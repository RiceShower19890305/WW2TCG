package feathers.motion.effectClasses
{
   import feathers.core.IFeathersEventDispatcher;
   import starling.display.DisplayObject;
   
   public interface IEffectContext extends IFeathersEventDispatcher
   {
      
      function get target() : DisplayObject;
      
      function get duration() : Number;
      
      function get position() : Number;
      
      function set position(param1:Number) : void;
      
      function play() : void;
      
      function playReverse() : void;
      
      function pause() : void;
      
      function stop() : void;
      
      function toEnd() : void;
      
      function interrupt() : void;
   }
}

