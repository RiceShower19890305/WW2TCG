package feathers.utils.keyboard
{
   import feathers.core.IFocusDisplayObject;
   import starling.events.Event;
   
   public class KeyToTrigger extends KeyToEvent
   {
      
      public function KeyToTrigger(param1:IFocusDisplayObject = null, param2:uint = 32)
      {
         super(param1,param2,Event.TRIGGERED);
      }
   }
}

