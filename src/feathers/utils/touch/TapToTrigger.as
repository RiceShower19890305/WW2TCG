package feathers.utils.touch
{
   import starling.display.DisplayObject;
   import starling.events.Event;
   
   public class TapToTrigger extends TapToEvent
   {
      
      public function TapToTrigger(param1:DisplayObject = null)
      {
         super(param1,Event.TRIGGERED);
      }
   }
}

