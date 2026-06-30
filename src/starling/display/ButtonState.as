package starling.display
{
   import starling.errors.AbstractClassError;
   
   public class ButtonState
   {
      
      public static const UP:String = "up";
      
      public static const DOWN:String = "down";
      
      public static const OVER:String = "over";
      
      public static const DISABLED:String = "disabled";
      
      public function ButtonState()
      {
         super();
         throw new AbstractClassError();
      }
      
      public static function isValid(param1:String) : Boolean
      {
         return param1 == UP || param1 == DOWN || param1 == OVER || param1 == DISABLED;
      }
   }
}

