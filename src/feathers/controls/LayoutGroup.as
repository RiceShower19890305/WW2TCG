package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.IValidating;
   import feathers.events.FeathersEventType;
   import feathers.layout.ILayout;
   import feathers.layout.ILayoutDisplayObject;
   import feathers.layout.IVirtualLayout;
   import feathers.layout.LayoutBoundsResult;
   import feathers.layout.ViewPortBounds;
   import feathers.skins.IStyleProvider;
   import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;
   import flash.geom.Point;
   import starling.core.starling_internal;
   import starling.display.DisplayObject;
   import starling.display.Quad;
   import starling.events.Event;
   import starling.filters.FragmentFilter;
   import starling.rendering.Painter;
   
   public class LayoutGroup extends FeathersControl
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      protected static const INVALIDATION_FLAG_CLIPPING:String = "clipping";
      
      public static const ALTERNATE_STYLE_NAME_TOOLBAR:String = "feathers-toolbar-layout-group";
      
      protected var items:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
      
      protected var viewPortBounds:ViewPortBounds = new ViewPortBounds();
      
      protected var _layoutResult:LayoutBoundsResult = new LayoutBoundsResult();
      
      protected var _layout:ILayout;
      
      protected var _clipContent:Boolean = false;
      
      protected var _explicitBackgroundWidth:Number;
      
      protected var _explicitBackgroundHeight:Number;
      
      protected var _explicitBackgroundMinWidth:Number;
      
      protected var _explicitBackgroundMinHeight:Number;
      
      protected var _explicitBackgroundMaxWidth:Number;
      
      protected var _explicitBackgroundMaxHeight:Number;
      
      protected var currentBackgroundSkin:DisplayObject;
      
      protected var _backgroundSkin:DisplayObject;
      
      protected var _backgroundDisabledSkin:DisplayObject;
      
      protected var _autoSizeMode:String = "content";
      
      protected var _ignoreChildChanges:Boolean = false;
      
      protected var _ignoreChildChangesButSetFlags:Boolean = false;
      
      public function LayoutGroup()
      {
         super();
         this.addEventListener(Event.ADDED_TO_STAGE,this.layoutGroup_addedToStageHandler);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.layoutGroup_removedFromStageHandler);
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return LayoutGroup.globalStyleProvider;
      }
      
      public function get layout() : ILayout
      {
         return this._layout;
      }
      
      public function set layout(param1:ILayout) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._layout == param1)
         {
            return;
         }
         if(this._layout)
         {
            this._layout.removeEventListener(Event.CHANGE,this.layout_changeHandler);
         }
         this._layout = param1;
         if(this._layout)
         {
            if(this._layout is IVirtualLayout)
            {
               IVirtualLayout(this._layout).useVirtualLayout = false;
            }
            this._layout.addEventListener(Event.CHANGE,this.layout_changeHandler);
            this.invalidate(INVALIDATION_FLAG_LAYOUT);
         }
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
      }
      
      public function get clipContent() : Boolean
      {
         return this._clipContent;
      }
      
      public function set clipContent(param1:Boolean) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._clipContent === param1)
         {
            return;
         }
         this._clipContent = param1;
         if(!param1)
         {
            this.mask = null;
         }
         this.invalidate(INVALIDATION_FLAG_CLIPPING);
      }
      
      public function get backgroundSkin() : DisplayObject
      {
         return this._backgroundSkin;
      }
      
      public function set backgroundSkin(param1:DisplayObject) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            if(param1 !== null)
            {
               param1.dispose();
            }
            return;
         }
         if(this._backgroundSkin === param1)
         {
            return;
         }
         if(this._backgroundSkin !== null && this.currentBackgroundSkin === this._backgroundSkin)
         {
            this.removeCurrentBackgroundSkin(this._backgroundSkin);
            this.currentBackgroundSkin = null;
         }
         this._backgroundSkin = param1;
         this.invalidate(INVALIDATION_FLAG_SKIN);
      }
      
      public function get backgroundDisabledSkin() : DisplayObject
      {
         return this._backgroundDisabledSkin;
      }
      
      public function set backgroundDisabledSkin(param1:DisplayObject) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            if(param1 !== null)
            {
               param1.dispose();
            }
            return;
         }
         if(this._backgroundDisabledSkin === param1)
         {
            return;
         }
         if(this._backgroundDisabledSkin !== null && this.currentBackgroundSkin === this._backgroundDisabledSkin)
         {
            this.removeCurrentBackgroundSkin(this._backgroundDisabledSkin);
            this.currentBackgroundSkin = null;
         }
         this._backgroundDisabledSkin = param1;
         this.invalidate(INVALIDATION_FLAG_SKIN);
      }
      
      public function get autoSizeMode() : String
      {
         return this._autoSizeMode;
      }
      
      public function set autoSizeMode(param1:String) : void
      {
         if(this._autoSizeMode == param1)
         {
            return;
         }
         this._autoSizeMode = param1;
         if(this.stage !== null)
         {
            if(this._autoSizeMode === AutoSizeMode.STAGE)
            {
               this.stage.addEventListener(Event.RESIZE,this.stage_resizeHandler);
            }
            else
            {
               this.stage.removeEventListener(Event.RESIZE,this.stage_resizeHandler);
            }
         }
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
      
      override public function addChildAt(param1:DisplayObject, param2:int) : DisplayObject
      {
         if(param1 is IFeathersControl)
         {
            param1.addEventListener(FeathersEventType.RESIZE,this.child_resizeHandler);
         }
         if(param1 is ILayoutDisplayObject)
         {
            param1.addEventListener(FeathersEventType.LAYOUT_DATA_CHANGE,this.child_layoutDataChangeHandler);
         }
         var _loc3_:int = this.items.indexOf(param1);
         if(_loc3_ == param2)
         {
            return param1;
         }
         if(_loc3_ >= 0)
         {
            this.items.removeAt(_loc3_);
         }
         this.items.insertAt(param2,param1);
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
         return super.addChildAt(param1,param2);
      }
      
      override public function removeChildAt(param1:int, param2:Boolean = false) : DisplayObject
      {
         if(param1 >= 0 && param1 < this.items.length)
         {
            this.items.removeAt(param1);
         }
         var _loc3_:DisplayObject = super.removeChildAt(param1,param2);
         if(_loc3_ is IFeathersControl)
         {
            _loc3_.removeEventListener(FeathersEventType.RESIZE,this.child_resizeHandler);
         }
         if(_loc3_ is ILayoutDisplayObject)
         {
            _loc3_.removeEventListener(FeathersEventType.LAYOUT_DATA_CHANGE,this.child_layoutDataChangeHandler);
         }
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
         return _loc3_;
      }
      
      override public function setChildIndex(param1:DisplayObject, param2:int) : void
      {
         super.setChildIndex(param1,param2);
         var _loc3_:int = this.items.indexOf(param1);
         if(_loc3_ == param2)
         {
            return;
         }
         this.items.removeAt(_loc3_);
         this.items.insertAt(param2,param1);
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
      }
      
      override public function swapChildrenAt(param1:int, param2:int) : void
      {
         super.swapChildrenAt(param1,param2);
         var _loc3_:DisplayObject = this.items[param1];
         var _loc4_:DisplayObject = this.items[param2];
         this.items[param1] = _loc4_;
         this.items[param2] = _loc3_;
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
      }
      
      override public function sortChildren(param1:Function) : void
      {
         super.sortChildren(param1);
         this.items.sort(param1);
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
      }
      
      override public function hitTest(param1:Point) : DisplayObject
      {
         var _loc2_:Number = param1.x;
         var _loc3_:Number = param1.y;
         var _loc4_:DisplayObject = super.hitTest(param1);
         if(_loc4_)
         {
            if(!this._isEnabled)
            {
               return this;
            }
            return _loc4_;
         }
         if(!this.visible || !this.touchable)
         {
            return null;
         }
         if(Boolean(this.currentBackgroundSkin) && this._hitArea.contains(_loc2_,_loc3_))
         {
            return this;
         }
         return null;
      }
      
      override public function render(param1:Painter) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:FragmentFilter = null;
         if(this.currentBackgroundSkin !== null && this.currentBackgroundSkin.visible && this.currentBackgroundSkin.alpha > 0)
         {
            this.currentBackgroundSkin.setRequiresRedraw();
            _loc2_ = this.currentBackgroundSkin.mask;
            _loc3_ = this.currentBackgroundSkin.filter;
            param1.pushState();
            param1.setStateTo(this.currentBackgroundSkin.transformationMatrix,this.currentBackgroundSkin.alpha,this.currentBackgroundSkin.blendMode);
            if(_loc2_ !== null)
            {
               param1.drawMask(_loc2_);
            }
            if(_loc3_ !== null)
            {
               _loc3_.render(param1);
            }
            else
            {
               this.currentBackgroundSkin.render(param1);
            }
            if(_loc2_ !== null)
            {
               param1.eraseMask(_loc2_);
            }
            param1.popState();
         }
         super.render(param1);
      }
      
      override public function dispose() : void
      {
         if(this.currentBackgroundSkin !== null)
         {
            this.currentBackgroundSkin.starling_internal::setParent(null);
         }
         if(this._backgroundSkin !== null && this._backgroundSkin.parent !== this)
         {
            this._backgroundSkin.dispose();
         }
         if(this._backgroundDisabledSkin !== null && this._backgroundDisabledSkin.parent !== this)
         {
            this._backgroundDisabledSkin.dispose();
         }
         this.layout = null;
         super.dispose();
      }
      
      public function readjustLayout() : void
      {
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
      }
      
      override public function validate() : void
      {
         var _loc1_:Boolean = this._ignoreChildChangesButSetFlags;
         this._ignoreChildChangesButSetFlags = true;
         super.validate();
         this._ignoreChildChangesButSetFlags = _loc1_;
      }
      
      override protected function initialize() : void
      {
         if(this.stage !== null)
         {
            if(this.stage.starling.root === this)
            {
               this.autoSizeMode = AutoSizeMode.STAGE;
            }
         }
         super.initialize();
      }
      
      override protected function draw() : void
      {
         var _loc7_:Boolean = false;
         this._ignoreChildChangesButSetFlags = false;
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_LAYOUT);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_CLIPPING);
         var _loc4_:Boolean = this.isInvalid(INVALIDATION_FLAG_SCROLL);
         var _loc5_:Boolean = this.isInvalid(INVALIDATION_FLAG_SKIN);
         var _loc6_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         if(Boolean(!_loc1_ && _loc4_) && Boolean(this._layout) && this._layout.requiresLayoutOnScroll)
         {
            _loc1_ = true;
         }
         if(_loc5_ || _loc6_)
         {
            this.refreshBackgroundSkin();
         }
         if(_loc2_ || _loc1_ || _loc5_ || _loc6_)
         {
            this.refreshViewPortBounds();
            if(this._layout)
            {
               _loc7_ = this._ignoreChildChanges;
               this._ignoreChildChanges = true;
               this._layout.layout(this.items,this.viewPortBounds,this._layoutResult);
               this._ignoreChildChanges = _loc7_;
            }
            else
            {
               this.handleManualLayout();
            }
            this.handleLayoutResult();
            this.refreshBackgroundLayout();
            this.validateChildren();
         }
         if(_loc2_ || _loc3_)
         {
            this.refreshClipRect();
         }
      }
      
      protected function refreshBackgroundSkin() : void
      {
         var _loc2_:IMeasureDisplayObject = null;
         var _loc1_:DisplayObject = this.currentBackgroundSkin;
         this.currentBackgroundSkin = this.getCurrentBackgroundSkin();
         if(this.currentBackgroundSkin !== _loc1_)
         {
            this.removeCurrentBackgroundSkin(_loc1_);
            if(this.currentBackgroundSkin !== null)
            {
               if(this.currentBackgroundSkin is IFeathersControl)
               {
                  IFeathersControl(this.currentBackgroundSkin).initializeNow();
               }
               if(this.currentBackgroundSkin is IMeasureDisplayObject)
               {
                  _loc2_ = IMeasureDisplayObject(this.currentBackgroundSkin);
                  this._explicitBackgroundWidth = _loc2_.explicitWidth;
                  this._explicitBackgroundHeight = _loc2_.explicitHeight;
                  this._explicitBackgroundMinWidth = _loc2_.explicitMinWidth;
                  this._explicitBackgroundMinHeight = _loc2_.explicitMinHeight;
                  this._explicitBackgroundMaxWidth = _loc2_.explicitMaxWidth;
                  this._explicitBackgroundMaxHeight = _loc2_.explicitMaxHeight;
               }
               else
               {
                  this._explicitBackgroundWidth = this.currentBackgroundSkin.width;
                  this._explicitBackgroundHeight = this.currentBackgroundSkin.height;
                  this._explicitBackgroundMinWidth = this._explicitBackgroundWidth;
                  this._explicitBackgroundMinHeight = this._explicitBackgroundHeight;
                  this._explicitBackgroundMaxWidth = this._explicitBackgroundWidth;
                  this._explicitBackgroundMaxHeight = this._explicitBackgroundHeight;
               }
               this.currentBackgroundSkin.starling_internal::setParent(this);
            }
         }
      }
      
      protected function removeCurrentBackgroundSkin(param1:DisplayObject) : void
      {
         var _loc2_:IMeasureDisplayObject = null;
         if(param1 === null)
         {
            return;
         }
         if(param1.parent === this)
         {
            param1.width = this._explicitBackgroundWidth;
            param1.height = this._explicitBackgroundHeight;
            if(param1 is IMeasureDisplayObject)
            {
               _loc2_ = IMeasureDisplayObject(param1);
               _loc2_.minWidth = this._explicitBackgroundMinWidth;
               _loc2_.minHeight = this._explicitBackgroundMinHeight;
               _loc2_.maxWidth = this._explicitBackgroundMaxWidth;
               _loc2_.maxHeight = this._explicitBackgroundMaxHeight;
            }
            this.setRequiresRedraw();
            param1.starling_internal::setParent(null);
         }
      }
      
      protected function getCurrentBackgroundSkin() : DisplayObject
      {
         if(!this._isEnabled && this._backgroundDisabledSkin !== null)
         {
            return this._backgroundDisabledSkin;
         }
         return this._backgroundSkin;
      }
      
      protected function refreshBackgroundLayout() : void
      {
         if(this.currentBackgroundSkin === null)
         {
            return;
         }
         if(this.currentBackgroundSkin.width != this.actualWidth || this.currentBackgroundSkin.height != this.actualHeight)
         {
            this.currentBackgroundSkin.width = this.actualWidth;
            this.currentBackgroundSkin.height = this.actualHeight;
         }
      }
      
      protected function refreshViewPortBounds() : void
      {
         var _loc1_:Boolean = this._explicitWidth !== this._explicitWidth;
         var _loc2_:Boolean = this._explicitHeight !== this._explicitHeight;
         var _loc3_:Boolean = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc4_:Boolean = this._explicitMinHeight !== this._explicitMinHeight;
         resetFluidChildDimensionsForMeasurement(this.currentBackgroundSkin,this._explicitWidth,this._explicitHeight,this._explicitMinWidth,this._explicitMinHeight,this._explicitMaxWidth,this._explicitMaxHeight,this._explicitBackgroundWidth,this._explicitBackgroundHeight,this._explicitBackgroundMinWidth,this._explicitBackgroundMinHeight,this._explicitBackgroundMaxWidth,this._explicitBackgroundMaxHeight);
         this.viewPortBounds.x = 0;
         this.viewPortBounds.y = 0;
         this.viewPortBounds.scrollX = 0;
         this.viewPortBounds.scrollY = 0;
         if(_loc1_ && this._autoSizeMode === AutoSizeMode.STAGE && this.stage !== null)
         {
            this.viewPortBounds.explicitWidth = this.stage.stageWidth;
         }
         else
         {
            this.viewPortBounds.explicitWidth = this._explicitWidth;
         }
         if(_loc2_ && this._autoSizeMode === AutoSizeMode.STAGE && this.stage !== null)
         {
            this.viewPortBounds.explicitHeight = this.stage.stageHeight;
         }
         else
         {
            this.viewPortBounds.explicitHeight = this._explicitHeight;
         }
         var _loc5_:Number = this._explicitMinWidth;
         if(_loc3_)
         {
            _loc5_ = 0;
         }
         var _loc6_:Number = this._explicitMinHeight;
         if(_loc4_)
         {
            _loc6_ = 0;
         }
         if(this.currentBackgroundSkin !== null)
         {
            if(this.currentBackgroundSkin.width > _loc5_)
            {
               _loc5_ = this.currentBackgroundSkin.width;
            }
            if(this.currentBackgroundSkin.height > _loc6_)
            {
               _loc6_ = this.currentBackgroundSkin.height;
            }
         }
         this.viewPortBounds.minWidth = _loc5_;
         this.viewPortBounds.minHeight = _loc6_;
         this.viewPortBounds.maxWidth = this._explicitMaxWidth;
         this.viewPortBounds.maxHeight = this._explicitMaxHeight;
      }
      
      protected function handleLayoutResult() : void
      {
         var _loc1_:Number = this._layoutResult.viewPortWidth;
         var _loc2_:Number = this._layoutResult.viewPortHeight;
         this.saveMeasurements(_loc1_,_loc2_,_loc1_,_loc2_);
      }
      
      protected function handleManualLayout() : void
      {
         var _loc6_:DisplayObject = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc1_:Number = this.viewPortBounds.explicitWidth;
         if(_loc1_ !== _loc1_)
         {
            _loc1_ = 0;
         }
         var _loc2_:Number = this.viewPortBounds.explicitHeight;
         if(_loc2_ !== _loc2_)
         {
            _loc2_ = 0;
         }
         var _loc3_:Boolean = this._ignoreChildChanges;
         this._ignoreChildChanges = true;
         var _loc4_:int = int(this.items.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = this.items[_loc5_];
            if(!(_loc6_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc6_).includeInLayout))
            {
               if(_loc6_ is IValidating)
               {
                  IValidating(_loc6_).validate();
               }
               _loc7_ = _loc6_.x - _loc6_.pivotX + _loc6_.width;
               _loc8_ = _loc6_.y - _loc6_.pivotY + _loc6_.height;
               if(_loc7_ === _loc7_ && _loc7_ > _loc1_)
               {
                  _loc1_ = _loc7_;
               }
               if(_loc8_ === _loc8_ && _loc8_ > _loc2_)
               {
                  _loc2_ = _loc8_;
               }
            }
            _loc5_++;
         }
         this._ignoreChildChanges = _loc3_;
         this._layoutResult.contentX = 0;
         this._layoutResult.contentY = 0;
         this._layoutResult.contentWidth = _loc1_;
         this._layoutResult.contentHeight = _loc2_;
         if(this.viewPortBounds.explicitWidth === this.viewPortBounds.explicitWidth)
         {
            this._layoutResult.viewPortWidth = this.viewPortBounds.explicitWidth;
         }
         else
         {
            _loc9_ = this.viewPortBounds.minWidth;
            if(_loc1_ < _loc9_)
            {
               _loc1_ = _loc9_;
            }
            _loc10_ = this.viewPortBounds.maxWidth;
            if(_loc1_ > _loc10_)
            {
               _loc1_ = _loc10_;
            }
            this._layoutResult.viewPortWidth = _loc1_;
         }
         if(this.viewPortBounds.explicitHeight === this.viewPortBounds.explicitHeight)
         {
            this._layoutResult.viewPortHeight = this.viewPortBounds.explicitHeight;
         }
         else
         {
            _loc11_ = this.viewPortBounds.minHeight;
            if(_loc2_ < _loc11_)
            {
               _loc2_ = _loc11_;
            }
            _loc12_ = this.viewPortBounds.maxHeight;
            if(_loc2_ > _loc12_)
            {
               _loc2_ = _loc12_;
            }
            this._layoutResult.viewPortHeight = _loc2_;
         }
      }
      
      protected function validateChildren() : void
      {
         var _loc3_:DisplayObject = null;
         if(this.currentBackgroundSkin is IValidating)
         {
            IValidating(this.currentBackgroundSkin).validate();
         }
         var _loc1_:int = int(this.items.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.items[_loc2_];
            if(_loc3_ is IValidating)
            {
               IValidating(_loc3_).validate();
            }
            _loc2_++;
         }
      }
      
      protected function refreshClipRect() : void
      {
         if(!this._clipContent)
         {
            return;
         }
         var _loc1_:Quad = this.mask as Quad;
         if(_loc1_)
         {
            _loc1_.x = 0;
            _loc1_.y = 0;
            _loc1_.width = this.actualWidth;
            _loc1_.height = this.actualHeight;
         }
         else
         {
            _loc1_ = new Quad(1,1,16711935);
            _loc1_.width = this.actualWidth;
            _loc1_.height = this.actualHeight;
            this.mask = _loc1_;
         }
      }
      
      protected function layoutGroup_addedToStageHandler(param1:Event) : void
      {
         if(this._autoSizeMode === AutoSizeMode.STAGE)
         {
            this.invalidate(INVALIDATION_FLAG_SIZE);
            this.stage.addEventListener(Event.RESIZE,this.stage_resizeHandler);
         }
      }
      
      protected function layoutGroup_removedFromStageHandler(param1:Event) : void
      {
         this.stage.removeEventListener(Event.RESIZE,this.stage_resizeHandler);
      }
      
      protected function layout_changeHandler(param1:Event) : void
      {
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
      }
      
      protected function child_resizeHandler(param1:Event) : void
      {
         if(this._ignoreChildChanges)
         {
            return;
         }
         if(this._ignoreChildChangesButSetFlags)
         {
            this.setInvalidationFlag(INVALIDATION_FLAG_LAYOUT);
            return;
         }
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
      }
      
      protected function child_layoutDataChangeHandler(param1:Event) : void
      {
         if(this._ignoreChildChanges)
         {
            return;
         }
         if(this._ignoreChildChangesButSetFlags)
         {
            this.setInvalidationFlag(INVALIDATION_FLAG_LAYOUT);
            return;
         }
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
      }
      
      protected function stage_resizeHandler(param1:Event) : void
      {
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
      }
   }
}

