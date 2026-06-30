package feathers.controls.text
{
   import feathers.controls.supportClasses.IViewPort;
   import feathers.core.ITextEditor;
   
   public interface ITextEditorViewPort extends ITextEditor, IViewPort
   {
      
      function get paddingTop() : Number;
      
      function set paddingTop(param1:Number) : void;
      
      function get paddingRight() : Number;
      
      function set paddingRight(param1:Number) : void;
      
      function get paddingBottom() : Number;
      
      function set paddingBottom(param1:Number) : void;
      
      function get paddingLeft() : Number;
      
      function set paddingLeft(param1:Number) : void;
   }
}

