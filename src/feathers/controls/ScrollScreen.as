package feathers.controls
{
   import feathers.skins.IStyleProvider;
   import feathers.utils.display.getDisplayObjectDepthFromStage;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import starling.events.Event;
   
   public class ScrollScreen extends ScrollContainer implements IScreen
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      protected var _screenID:String;
      
      protected var _owner:Object;
      
      protected var backButtonHandler:Function;
      
      protected var menuButtonHandler:Function;
      
      protected var searchButtonHandler:Function;
      
      public function ScrollScreen()
      {
         this.addEventListener(Event.ADDED_TO_STAGE,this.scrollScreen_addedToStageHandler);
         super();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return ScrollScreen.globalStyleProvider;
      }
      
      public function get screenID() : String
      {
         return this._screenID;
      }
      
      public function set screenID(param1:String) : void
      {
         this._screenID = param1;
      }
      
      public function get owner() : Object
      {
         return this._owner;
      }
      
      public function set owner(param1:Object) : void
      {
         this._owner = param1;
      }
      
      protected function scrollScreen_addedToStageHandler(param1:Event) : void
      {
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.scrollScreen_removedFromStageHandler);
         var _loc2_:int = -getDisplayObjectDepthFromStage(this);
         this.stage.starling.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN,this.scrollScreen_nativeStage_keyDownHandler,false,_loc2_,true);
      }
      
      protected function scrollScreen_removedFromStageHandler(param1:Event) : void
      {
         this.removeEventListener(Event.REMOVED_FROM_STAGE,this.scrollScreen_removedFromStageHandler);
         this.stage.starling.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN,this.scrollScreen_nativeStage_keyDownHandler);
      }
      
      protected function scrollScreen_nativeStage_keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.isDefaultPrevented())
         {
            return;
         }
         if(this.backButtonHandler != null && param1.keyCode == Keyboard.BACK)
         {
            param1.preventDefault();
            this.backButtonHandler();
         }
         if(this.menuButtonHandler != null && param1.keyCode == Keyboard.MENU)
         {
            param1.preventDefault();
            this.menuButtonHandler();
         }
         if(this.searchButtonHandler != null && param1.keyCode == Keyboard.SEARCH)
         {
            param1.preventDefault();
            this.searchButtonHandler();
         }
      }
   }
}

