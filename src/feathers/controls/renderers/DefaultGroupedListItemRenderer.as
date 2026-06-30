package feathers.controls.renderers
{
   import feathers.controls.GroupedList;
   import feathers.events.FeathersEventType;
   import feathers.skins.IStyleProvider;
   
   public class DefaultGroupedListItemRenderer extends BaseDefaultItemRenderer implements IGroupedListItemRenderer
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      public static const ALTERNATE_STYLE_NAME_DRILL_DOWN:String = "feathers-drill-down-item-renderer";
      
      public static const ALTERNATE_STYLE_NAME_CHECK:String = "feathers-check-item-renderer";
      
      public static const DEFAULT_CHILD_STYLE_NAME_LABEL:String = "feathers-item-renderer-label";
      
      public static const DEFAULT_CHILD_STYLE_NAME_ICON_LABEL:String = "feathers-item-renderer-icon-label";
      
      public static const DEFAULT_CHILD_STYLE_NAME_ACCESSORY_LABEL:String = "feathers-item-renderer-accessory-label";
      
      protected var _groupIndex:int = -1;
      
      protected var _itemIndex:int = -1;
      
      protected var _layoutIndex:int = -1;
      
      public function DefaultGroupedListItemRenderer()
      {
         super();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return DefaultGroupedListItemRenderer.globalStyleProvider;
      }
      
      public function get groupIndex() : int
      {
         return this._groupIndex;
      }
      
      public function set groupIndex(param1:int) : void
      {
         this._groupIndex = param1;
      }
      
      public function get itemIndex() : int
      {
         return this._itemIndex;
      }
      
      public function set itemIndex(param1:int) : void
      {
         this._itemIndex = param1;
      }
      
      public function get layoutIndex() : int
      {
         return this._layoutIndex;
      }
      
      public function set layoutIndex(param1:int) : void
      {
         this._layoutIndex = param1;
      }
      
      public function get owner() : GroupedList
      {
         return GroupedList(this._owner);
      }
      
      public function set owner(param1:GroupedList) : void
      {
         var _loc2_:GroupedList = null;
         if(this._owner == param1)
         {
            return;
         }
         if(this._owner)
         {
            this._owner.removeEventListener(FeathersEventType.SCROLL_START,owner_scrollStartHandler);
            this._owner.removeEventListener(FeathersEventType.SCROLL_COMPLETE,owner_scrollCompleteHandler);
         }
         this._owner = param1;
         if(this._owner)
         {
            _loc2_ = GroupedList(this._owner);
            this.isSelectableWithoutToggle = _loc2_.isSelectable;
            this._owner.addEventListener(FeathersEventType.SCROLL_START,owner_scrollStartHandler);
            this._owner.addEventListener(FeathersEventType.SCROLL_COMPLETE,owner_scrollCompleteHandler);
         }
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      override public function dispose() : void
      {
         this.owner = null;
         super.dispose();
      }
   }
}

