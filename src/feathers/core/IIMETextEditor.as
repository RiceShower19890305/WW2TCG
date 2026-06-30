package feathers.core
{
   public interface IIMETextEditor extends ITextEditor
   {
      
      function get selectionAnchorIndex() : int;
      
      function get selectionActiveIndex() : int;
   }
}

