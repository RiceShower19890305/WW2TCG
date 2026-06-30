package feathers.core
{
   public interface IFocusDisplayObject extends IFeathersDisplayObject
   {
      
      function get focusManager() : IFocusManager;
      
      function set focusManager(param1:IFocusManager) : void;
      
      function get isFocusEnabled() : Boolean;
      
      function set isFocusEnabled(param1:Boolean) : void;
      
      function get nextTabFocus() : IFocusDisplayObject;
      
      function set nextTabFocus(param1:IFocusDisplayObject) : void;
      
      function get previousTabFocus() : IFocusDisplayObject;
      
      function set previousTabFocus(param1:IFocusDisplayObject) : void;
      
      function get nextUpFocus() : IFocusDisplayObject;
      
      function set nextUpFocus(param1:IFocusDisplayObject) : void;
      
      function get nextRightFocus() : IFocusDisplayObject;
      
      function set nextRightFocus(param1:IFocusDisplayObject) : void;
      
      function get nextDownFocus() : IFocusDisplayObject;
      
      function set nextDownFocus(param1:IFocusDisplayObject) : void;
      
      function get nextLeftFocus() : IFocusDisplayObject;
      
      function set nextLeftFocus(param1:IFocusDisplayObject) : void;
      
      function get focusOwner() : IFocusDisplayObject;
      
      function set focusOwner(param1:IFocusDisplayObject) : void;
      
      function get isShowingFocus() : Boolean;
      
      function get maintainTouchFocus() : Boolean;
      
      function showFocus() : void;
      
      function hideFocus() : void;
   }
}

