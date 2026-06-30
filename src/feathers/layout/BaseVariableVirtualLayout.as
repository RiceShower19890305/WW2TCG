package feathers.layout
{
   import starling.display.DisplayObject;
   import starling.errors.AbstractClassError;
   import starling.events.Event;
   import starling.events.EventDispatcher;
   
   public class BaseVariableVirtualLayout extends EventDispatcher
   {
      
      protected var _virtualCache:Array = [];
      
      protected var _useVirtualLayout:Boolean = true;
      
      protected var _typicalItem:DisplayObject;
      
      protected var _hasVariableItemDimensions:Boolean = false;
      
      public function BaseVariableVirtualLayout()
      {
         super();
         if(Object(this).constructor === BaseLinearLayout)
         {
            throw new AbstractClassError();
         }
      }
      
      public function get useVirtualLayout() : Boolean
      {
         return this._useVirtualLayout;
      }
      
      public function set useVirtualLayout(param1:Boolean) : void
      {
         if(this._useVirtualLayout == param1)
         {
            return;
         }
         this._useVirtualLayout = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get typicalItem() : DisplayObject
      {
         return this._typicalItem;
      }
      
      public function set typicalItem(param1:DisplayObject) : void
      {
         if(this._typicalItem == param1)
         {
            return;
         }
         this._typicalItem = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get hasVariableItemDimensions() : Boolean
      {
         return this._hasVariableItemDimensions;
      }
      
      public function set hasVariableItemDimensions(param1:Boolean) : void
      {
         if(this._hasVariableItemDimensions == param1)
         {
            return;
         }
         this._hasVariableItemDimensions = param1;
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get requiresLayoutOnScroll() : Boolean
      {
         return this._useVirtualLayout;
      }
      
      public function resetVariableVirtualCache() : void
      {
         this._virtualCache.length = 0;
      }
      
      public function resetVariableVirtualCacheAtIndex(param1:int, param2:DisplayObject = null) : void
      {
         delete this._virtualCache[param1];
         if(param2)
         {
            this._virtualCache[param1] = param2.height;
            this.dispatchEventWith(Event.CHANGE);
         }
      }
      
      public function addToVariableVirtualCacheAtIndex(param1:int, param2:DisplayObject = null) : void
      {
         var _loc3_:* = param2 ? param2.height : undefined;
         this._virtualCache.insertAt(param1,_loc3_);
      }
      
      public function removeFromVariableVirtualCacheAtIndex(param1:int) : void
      {
         this._virtualCache.removeAt(param1);
      }
   }
}

