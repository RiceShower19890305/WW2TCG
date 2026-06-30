package feathers.controls
{
   import feathers.skins.IStyleProvider;
   import flash.errors.IllegalOperationError;
   
   public class Check extends ToggleButton
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      public static const DEFAULT_CHILD_STYLE_NAME_LABEL:String = "feathers-check-label";
      
      public function Check()
      {
         super();
         this.labelStyleName = DEFAULT_CHILD_STYLE_NAME_LABEL;
         super.isToggle = true;
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return Check.globalStyleProvider;
      }
      
      override public function set isToggle(param1:Boolean) : void
      {
         throw IllegalOperationError("CheckBox isToggle must always be true.");
      }
   }
}

