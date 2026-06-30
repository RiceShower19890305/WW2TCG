package feathers.controls
{
   import feathers.core.IGroupedToggle;
   import feathers.core.ToggleGroup;
   import feathers.skins.IStyleProvider;
   import flash.errors.IllegalOperationError;
   import starling.events.Event;
   
   public class Radio extends ToggleButton implements IGroupedToggle
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      public static const DEFAULT_CHILD_STYLE_NAME_LABEL:String = "feathers-radio-label";
      
      public static const defaultRadioGroup:ToggleGroup = new ToggleGroup();
      
      public function Radio()
      {
         super();
         super.isToggle = true;
         this.labelStyleName = DEFAULT_CHILD_STYLE_NAME_LABEL;
         this.addEventListener(Event.ADDED_TO_STAGE,this.radio_addedToStageHandler);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.radio_removedFromStageHandler);
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return Radio.globalStyleProvider;
      }
      
      override public function set isToggle(param1:Boolean) : void
      {
         throw IllegalOperationError("Radio isToggle must always be true.");
      }
      
      override public function set toggleGroup(param1:ToggleGroup) : void
      {
         if(this._toggleGroup === param1)
         {
            return;
         }
         if(!param1 && this._toggleGroup !== defaultRadioGroup && Boolean(this.stage))
         {
            param1 = defaultRadioGroup;
         }
         super.toggleGroup = param1;
      }
      
      protected function radio_addedToStageHandler(param1:Event) : void
      {
         if(!this._toggleGroup)
         {
            this.toggleGroup = defaultRadioGroup;
         }
      }
      
      protected function radio_removedFromStageHandler(param1:Event) : void
      {
         if(this._toggleGroup == defaultRadioGroup)
         {
            this._toggleGroup.removeItem(this);
         }
      }
   }
}

