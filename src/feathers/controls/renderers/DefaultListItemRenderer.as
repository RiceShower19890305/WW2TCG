package feathers.controls.renderers
{
   import feathers.controls.List;
   import feathers.core.IFeathersControl;
   import feathers.core.IValidating;
   import feathers.events.FeathersEventType;
   import feathers.skins.IStyleProvider;
   import starling.display.DisplayObject;
   import starling.events.Event;
   
   public class DefaultListItemRenderer extends BaseDefaultItemRenderer implements IListItemRenderer, IDragAndDropItemRenderer
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      public static const ALTERNATE_STYLE_NAME_DRILL_DOWN:String = "feathers-drill-down-item-renderer";
      
      public static const ALTERNATE_STYLE_NAME_CHECK:String = "feathers-check-item-renderer";
      
      public static const DEFAULT_CHILD_STYLE_NAME_LABEL:String = "feathers-item-renderer-label";
      
      public static const DEFAULT_CHILD_STYLE_NAME_ICON_LABEL:String = "feathers-item-renderer-icon-label";
      
      public static const DEFAULT_CHILD_STYLE_NAME_ACCESSORY_LABEL:String = "feathers-item-renderer-accessory-label";
      
      protected var _index:int = -1;
      
      protected var _dragEnabled:Boolean = false;
      
      protected var _dragIcon:DisplayObject = null;
      
      protected var _dragGap:Number = NaN;
      
      protected var _ignoreDragIconResizes:Boolean = false;
      
      public function DefaultListItemRenderer()
      {
         super();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return DefaultListItemRenderer.globalStyleProvider;
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function set index(param1:int) : void
      {
         this._index = param1;
      }
      
      public function get owner() : List
      {
         return List(this._owner);
      }
      
      public function set owner(param1:List) : void
      {
         var _loc2_:List = null;
         if(this._owner === param1)
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
            _loc2_ = List(this._owner);
            this.isSelectableWithoutToggle = _loc2_.isSelectable;
            if(_loc2_.allowMultipleSelection)
            {
               this.isToggle = true;
            }
            this._owner.addEventListener(FeathersEventType.SCROLL_START,owner_scrollStartHandler);
            this._owner.addEventListener(FeathersEventType.SCROLL_COMPLETE,owner_scrollCompleteHandler);
         }
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get dragEnabled() : Boolean
      {
         return this._dragEnabled;
      }
      
      public function set dragEnabled(param1:Boolean) : void
      {
         if(this._dragEnabled === param1)
         {
            return;
         }
         this._dragEnabled = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get dragIcon() : DisplayObject
      {
         return this._dragIcon;
      }
      
      public function set dragIcon(param1:DisplayObject) : void
      {
         if(this._dragIcon === param1)
         {
            return;
         }
         if(this._dragIcon !== null)
         {
            if(this._dragIcon is IFeathersControl)
            {
               IFeathersControl(this._dragIcon).removeEventListener(FeathersEventType.RESIZE,this.dragIcon_resizeHandler);
            }
            if(this._dragIcon.parent === this)
            {
               this._dragIcon.removeFromParent(false);
            }
            this._dragIcon = null;
         }
         this._dragIcon = param1;
         if(this._dragIcon !== null)
         {
            this.addChild(this._dragIcon);
            if(this._dragIcon is IFeathersControl)
            {
               IFeathersControl(this._dragIcon).addEventListener(FeathersEventType.RESIZE,this.dragIcon_resizeHandler);
            }
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get dragGap() : Number
      {
         return this._dragGap;
      }
      
      public function set dragGap(param1:Number) : void
      {
         if(this._dragGap == param1)
         {
            return;
         }
         this._dragGap = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get dragProxy() : DisplayObject
      {
         return this._dragIcon;
      }
      
      override public function dispose() : void
      {
         this.owner = null;
         super.dispose();
      }
      
      override protected function refreshOffsets() : void
      {
         var _loc2_:Boolean = false;
         super.refreshOffsets();
         var _loc1_:Number = this._gap;
         if(this._dragGap === this._dragGap)
         {
            _loc1_ = this._dragGap;
         }
         if(this._dragEnabled && this._dragIcon !== null)
         {
            _loc2_ = this._ignoreDragIconResizes;
            this._ignoreDragIconResizes = true;
            if(this._dragIcon is IValidating)
            {
               IValidating(this._dragIcon).validate();
            }
            this._ignoreDragIconResizes = _loc2_;
            this._leftOffset += this._dragIcon.width + _loc1_;
         }
      }
      
      override protected function layoutContent() : void
      {
         var _loc1_:Boolean = false;
         super.layoutContent();
         if(this._dragIcon !== null)
         {
            if(this._dragEnabled)
            {
               _loc1_ = this._ignoreDragIconResizes;
               this._ignoreDragIconResizes = true;
               if(this._dragIcon is IValidating)
               {
                  IValidating(this._dragIcon).validate();
               }
               this._ignoreDragIconResizes = _loc1_;
               this._dragIcon.x = this._paddingLeft;
               this._dragIcon.y = this._paddingTop + (this.actualHeight - this._paddingTop - this._paddingBottom - this._dragIcon.height) / 2;
               this._dragIcon.visible = true;
            }
            else
            {
               this._dragIcon.visible = false;
            }
         }
      }
      
      protected function dragIcon_resizeHandler(param1:Event) : void
      {
         if(this._ignoreDragIconResizes)
         {
            return;
         }
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
   }
}

