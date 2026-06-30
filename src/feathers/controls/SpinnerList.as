package feathers.controls
{
   import feathers.controls.renderers.IListItemRenderer;
   import feathers.core.IValidating;
   import feathers.data.IListCollection;
   import feathers.events.FeathersEventType;
   import feathers.layout.HorizontalAlign;
   import feathers.layout.ILayout;
   import feathers.layout.ISpinnerLayout;
   import feathers.layout.VerticalSpinnerLayout;
   import feathers.skins.IStyleProvider;
   import flash.events.KeyboardEvent;
   import flash.events.TransformGestureEvent;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import starling.display.DisplayObject;
   import starling.events.Event;
   
   public class SpinnerList extends List
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      protected var _spinnerLayout:ISpinnerLayout;
      
      protected var _selectionOverlaySkin:DisplayObject = null;
      
      protected var _showSelectionOverlay:Boolean = true;
      
      protected var _hideSelectionOverlayUnlessFocused:Boolean = false;
      
      public function SpinnerList()
      {
         super();
         this._scrollBarDisplayMode = ScrollBarDisplayMode.NONE;
         this._snapToPages = true;
         this._snapOnComplete = true;
         this.decelerationRate = DecelerationRate.FAST;
         this.addEventListener(Event.TRIGGERED,this.spinnerList_triggeredHandler);
         this.addEventListener(FeathersEventType.SCROLL_COMPLETE,this.spinnerList_scrollCompleteHandler);
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         if(SpinnerList.globalStyleProvider)
         {
            return SpinnerList.globalStyleProvider;
         }
         return List.globalStyleProvider;
      }
      
      override public function set snapToPages(param1:Boolean) : void
      {
         if(!param1)
         {
            throw new ArgumentError("SpinnerList requires snapToPages to be true.");
         }
         super.snapToPages = param1;
      }
      
      override public function set allowMultipleSelection(param1:Boolean) : void
      {
         if(param1)
         {
            throw new ArgumentError("SpinnerList requires allowMultipleSelection to be false.");
         }
         super.allowMultipleSelection = param1;
      }
      
      override public function set isSelectable(param1:Boolean) : void
      {
         if(!param1)
         {
            throw new ArgumentError("SpinnerList requires isSelectable to be true.");
         }
         super.snapToPages = param1;
      }
      
      override public function set layout(param1:ILayout) : void
      {
         if(Boolean(param1) && !(param1 is ISpinnerLayout))
         {
            throw new ArgumentError("SpinnerList requires layouts to implement the ISpinnerLayout interface.");
         }
         super.layout = param1;
         this._spinnerLayout = ISpinnerLayout(param1);
      }
      
      override public function set selectedIndex(param1:int) : void
      {
         if(param1 < 0 && this._dataProvider !== null && this._dataProvider.length > 0)
         {
            return;
         }
         if(this._selectedIndex != param1)
         {
            this.scrollToDisplayIndex(param1,0);
         }
         super.selectedIndex = param1;
      }
      
      override public function set selectedItem(param1:Object) : void
      {
         if(this._dataProvider === null)
         {
            this.selectedIndex = -1;
            return;
         }
         var _loc2_:int = this._dataProvider.getItemIndex(param1);
         if(_loc2_ < 0)
         {
            return;
         }
         this.selectedIndex = _loc2_;
      }
      
      override public function set dataProvider(param1:IListCollection) : void
      {
         if(this._dataProvider == param1)
         {
            return;
         }
         super.dataProvider = param1;
         if(!this._dataProvider || this._dataProvider.length == 0)
         {
            this.selectedIndex = -1;
         }
         else
         {
            this.selectedIndex = 0;
         }
      }
      
      public function get selectionOverlaySkin() : DisplayObject
      {
         return this._selectionOverlaySkin;
      }
      
      public function set selectionOverlaySkin(param1:DisplayObject) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            if(param1 !== null)
            {
               param1.dispose();
            }
            return;
         }
         if(this._selectionOverlaySkin === param1)
         {
            return;
         }
         if(Boolean(this._selectionOverlaySkin) && this._selectionOverlaySkin.parent == this)
         {
            this.removeRawChildInternal(this._selectionOverlaySkin);
         }
         this._selectionOverlaySkin = param1;
         if(this._selectionOverlaySkin)
         {
            this.addRawChildInternal(this._selectionOverlaySkin);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get showSelectionOverlay() : Boolean
      {
         return this._showSelectionOverlay;
      }
      
      public function set showSelectionOverlay(param1:Boolean) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._showSelectionOverlay === param1)
         {
            return;
         }
         this._showSelectionOverlay = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get hideSelectionOverlayUnlessFocused() : Boolean
      {
         return this._hideSelectionOverlayUnlessFocused;
      }
      
      public function set hideSelectionOverlayUnlessFocused(param1:Boolean) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._hideSelectionOverlayUnlessFocused === param1)
         {
            return;
         }
         this._hideSelectionOverlayUnlessFocused = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      override protected function initialize() : void
      {
         var _loc1_:VerticalSpinnerLayout = null;
         if(this._layout === null)
         {
            if(this._hasElasticEdges && this._verticalScrollPolicy === ScrollPolicy.AUTO && this._scrollBarDisplayMode !== ScrollBarDisplayMode.FIXED)
            {
               this._verticalScrollPolicy = ScrollPolicy.ON;
            }
            _loc1_ = new VerticalSpinnerLayout();
            _loc1_.useVirtualLayout = true;
            _loc1_.padding = 0;
            _loc1_.gap = 0;
            _loc1_.horizontalAlign = HorizontalAlign.JUSTIFY;
            _loc1_.requestedRowCount = 4;
            this.ignoreNextStyleRestriction();
            this.layout = _loc1_;
         }
         super.initialize();
      }
      
      override protected function refreshMinAndMaxScrollPositions() : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:Number = this.actualPageWidth;
         var _loc2_:Number = this.actualPageHeight;
         super.refreshMinAndMaxScrollPositions();
         if(this._maxVerticalScrollPosition != this._minVerticalScrollPosition)
         {
            this.actualPageHeight = this._spinnerLayout.snapInterval;
            if(!this.isScrolling && this.pendingItemIndex == -1 && this.actualPageHeight != _loc2_)
            {
               _loc3_ = this.calculateNearestPageIndexForItem(this._selectedIndex,this._verticalPageIndex,this._maxVerticalPageIndex);
               this._verticalScrollPosition = this.actualPageHeight * _loc3_;
            }
         }
         else if(this._maxHorizontalScrollPosition != this._minHorizontalScrollPosition)
         {
            this.actualPageWidth = this._spinnerLayout.snapInterval;
            if(!this.isScrolling && this.pendingItemIndex == -1 && this.actualPageWidth != _loc1_)
            {
               _loc4_ = this.calculateNearestPageIndexForItem(this._selectedIndex,this._horizontalPageIndex,this._maxHorizontalPageIndex);
               this._horizontalScrollPosition = this.actualPageWidth * _loc4_;
            }
         }
      }
      
      override protected function handlePendingScroll() : void
      {
         var _loc1_:int = 0;
         if(this.pendingItemIndex >= 0)
         {
            _loc1_ = this.pendingItemIndex;
            this.pendingItemIndex = -1;
            if(this._maxVerticalPageIndex != this._minVerticalPageIndex)
            {
               this.pendingVerticalPageIndex = this.calculateNearestPageIndexForItem(_loc1_,this._verticalPageIndex,this._maxVerticalPageIndex);
               this.hasPendingVerticalPageIndex = this.pendingVerticalPageIndex != this._verticalPageIndex;
            }
            else if(this._maxHorizontalPageIndex != this._minHorizontalPageIndex)
            {
               this.pendingHorizontalPageIndex = this.calculateNearestPageIndexForItem(_loc1_,this._horizontalPageIndex,this._maxHorizontalPageIndex);
               this.hasPendingHorizontalPageIndex = this.pendingHorizontalPageIndex != this._horizontalPageIndex;
            }
         }
         super.handlePendingScroll();
      }
      
      override protected function layoutChildren() : void
      {
         var _loc1_:flash.geom.Rectangle = null;
         super.layoutChildren();
         if(this._selectionOverlaySkin !== null)
         {
            if(this._showSelectionOverlay && this._hideSelectionOverlayUnlessFocused && this._focusManager !== null && this._isFocusEnabled)
            {
               this._selectionOverlaySkin.visible = this._hasFocus;
            }
            else
            {
               this._selectionOverlaySkin.visible = this._showSelectionOverlay;
            }
            _loc1_ = this._spinnerLayout.selectionBounds;
            this._selectionOverlaySkin.x = this._leftViewPortOffset + _loc1_.x;
            this._selectionOverlaySkin.y = this._topViewPortOffset + _loc1_.y;
            this._selectionOverlaySkin.width = _loc1_.width;
            this._selectionOverlaySkin.height = _loc1_.height;
            if(this._selectionOverlaySkin is IValidating)
            {
               IValidating(this._selectionOverlaySkin).validate();
            }
         }
      }
      
      protected function calculateNearestPageIndexForItem(param1:int, param2:int, param3:int) : int
      {
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         if(param3 != int.MAX_VALUE)
         {
            return param1;
         }
         var _loc4_:int = this._dataProvider.length;
         var _loc5_:int = param2 / _loc4_;
         var _loc6_:int = param2 % _loc4_;
         if(param1 < _loc6_)
         {
            _loc7_ = _loc5_ * _loc4_ + param1;
            _loc8_ = (_loc5_ + 1) * _loc4_ + param1;
         }
         else
         {
            _loc7_ = (_loc5_ - 1) * _loc4_ + param1;
            _loc8_ = _loc5_ * _loc4_ + param1;
         }
         if(_loc8_ - param2 < param2 - _loc7_)
         {
            return _loc8_;
         }
         return _loc7_;
      }
      
      override protected function scroller_removedFromStageHandler(param1:Event) : void
      {
         if(this._verticalAutoScrollTween)
         {
            this._verticalAutoScrollTween.advanceTime(this._verticalAutoScrollTween.totalTime);
         }
         if(this._horizontalAutoScrollTween)
         {
            this._horizontalAutoScrollTween.advanceTime(this._horizontalAutoScrollTween.totalTime);
         }
         super.scroller_removedFromStageHandler(param1);
      }
      
      protected function spinnerList_scrollCompleteHandler(param1:Event) : void
      {
         var _loc5_:int = 0;
         var _loc2_:int = this._dataProvider.length;
         if(this._maxVerticalPageIndex != this._minVerticalPageIndex)
         {
            _loc5_ = this._verticalPageIndex % _loc2_;
         }
         else if(this._maxHorizontalPageIndex != this._minHorizontalPageIndex)
         {
            _loc5_ = this._horizontalPageIndex % _loc2_;
         }
         if(_loc5_ < 0)
         {
            _loc5_ = _loc2_ + _loc5_;
         }
         var _loc3_:Object = this._dataProvider.getItemAt(_loc5_);
         var _loc4_:IListItemRenderer = this.itemToItemRenderer(_loc3_);
         if(_loc4_ !== null && !_loc4_.isEnabled)
         {
            if(this._maxVerticalPageIndex != this._minVerticalPageIndex)
            {
               this.scrollToPageIndex(this._horizontalPageIndex,this._selectedIndex,this._pageThrowDuration);
            }
            else if(this._maxHorizontalPageIndex != this._minHorizontalPageIndex)
            {
               this.scrollToPageIndex(this._selectedIndex,this._verticalPageIndex,this._pageThrowDuration);
            }
            return;
         }
         this.selectedIndex = _loc5_;
      }
      
      protected function spinnerList_triggeredHandler(param1:Event, param2:Object) : void
      {
         var _loc3_:int = this._dataProvider.getItemIndex(param2);
         this.selectedIndex = _loc3_;
         if(this._maxVerticalPageIndex != this._minVerticalPageIndex)
         {
            _loc3_ = this.calculateNearestPageIndexForItem(_loc3_,this._verticalPageIndex,this._maxVerticalPageIndex);
            this.throwToPage(this._horizontalPageIndex,_loc3_,this._pageThrowDuration);
         }
         else if(this._maxHorizontalPageIndex != this._minHorizontalPageIndex)
         {
            _loc3_ = this.calculateNearestPageIndexForItem(_loc3_,this._horizontalPageIndex,this._maxHorizontalPageIndex);
            this.throwToPage(_loc3_,this._verticalPageIndex,this._pageThrowDuration);
         }
      }
      
      override protected function dataProvider_removeItemHandler(param1:Event, param2:int) : void
      {
         var _loc3_:int = 0;
         super.dataProvider_removeItemHandler(param1,param2);
         if(this._maxVerticalPageIndex != this._minVerticalPageIndex)
         {
            _loc3_ = this.calculateNearestPageIndexForItem(this._selectedIndex,this._verticalPageIndex,this._maxVerticalPageIndex);
            if(_loc3_ > this._dataProvider.length)
            {
               _loc3_ -= this._dataProvider.length;
            }
            this.scrollToDisplayIndex(_loc3_,0);
         }
         else if(this._maxHorizontalPageIndex != this._minHorizontalPageIndex)
         {
            _loc3_ = this.calculateNearestPageIndexForItem(this._selectedIndex,this._horizontalPageIndex,this._maxHorizontalPageIndex);
            if(_loc3_ > this._dataProvider.length)
            {
               _loc3_ -= this._dataProvider.length;
            }
            this.scrollToDisplayIndex(_loc3_,0);
         }
      }
      
      override protected function dataProvider_addItemHandler(param1:Event, param2:int) : void
      {
         var _loc3_:int = 0;
         super.dataProvider_addItemHandler(param1,param2);
         if(this._maxVerticalPageIndex != this._minVerticalPageIndex)
         {
            _loc3_ = this.calculateNearestPageIndexForItem(this._selectedIndex,this._verticalPageIndex,this._maxVerticalPageIndex);
            if(_loc3_ > this._dataProvider.length)
            {
               _loc3_ -= this._dataProvider.length;
            }
            this.scrollToDisplayIndex(_loc3_,0);
         }
         else if(this._maxHorizontalPageIndex != this._minHorizontalPageIndex)
         {
            _loc3_ = this.calculateNearestPageIndexForItem(this._selectedIndex,this._horizontalPageIndex,this._maxHorizontalPageIndex);
            if(_loc3_ > this._dataProvider.length)
            {
               _loc3_ -= this._dataProvider.length;
            }
            this.scrollToDisplayIndex(_loc3_,0);
         }
      }
      
      override protected function nativeStage_keyDownHandler(param1:KeyboardEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(param1.isDefaultPrevented())
         {
            return;
         }
         if(!this._dataProvider)
         {
            return;
         }
         if(param1.keyCode == Keyboard.HOME || param1.keyCode == Keyboard.END || param1.keyCode == Keyboard.PAGE_UP || param1.keyCode == Keyboard.PAGE_DOWN || param1.keyCode == Keyboard.UP || param1.keyCode == Keyboard.DOWN || param1.keyCode == Keyboard.LEFT || param1.keyCode == Keyboard.RIGHT)
         {
            _loc2_ = this.dataViewPort.calculateNavigationDestination(this.selectedIndex,param1.keyCode);
            if(this.selectedIndex != _loc2_)
            {
               this.selectedIndex = _loc2_;
               if(this._maxVerticalPageIndex != this._minVerticalPageIndex)
               {
                  param1.preventDefault();
                  _loc3_ = this.calculateNearestPageIndexForItem(_loc2_,this._verticalPageIndex,this._maxVerticalPageIndex);
                  this.throwToPage(this._horizontalPageIndex,_loc3_,this._pageThrowDuration);
               }
               else if(this._maxHorizontalPageIndex != this._minHorizontalPageIndex)
               {
                  param1.preventDefault();
                  _loc3_ = this.calculateNearestPageIndexForItem(_loc2_,this._horizontalPageIndex,this._maxHorizontalPageIndex);
                  this.throwToPage(_loc3_,this._verticalPageIndex,this._pageThrowDuration);
               }
            }
         }
      }
      
      override protected function stage_gestureDirectionalTapHandler(param1:TransformGestureEvent) : void
      {
         var _loc4_:int = 0;
         if(param1.isDefaultPrevented())
         {
            return;
         }
         var _loc2_:uint = uint(int.MAX_VALUE);
         if(param1.offsetY < 0)
         {
            _loc2_ = Keyboard.UP;
         }
         else if(param1.offsetY > 0)
         {
            _loc2_ = Keyboard.DOWN;
         }
         else if(param1.offsetX > 0)
         {
            _loc2_ = Keyboard.RIGHT;
         }
         else if(param1.offsetX < 0)
         {
            _loc2_ = Keyboard.LEFT;
         }
         if(_loc2_ == int.MAX_VALUE)
         {
            return;
         }
         var _loc3_:int = this.dataViewPort.calculateNavigationDestination(this.selectedIndex,_loc2_);
         if(this.selectedIndex != _loc3_)
         {
            this.selectedIndex = _loc3_;
            if(this._maxVerticalPageIndex != this._minVerticalPageIndex)
            {
               param1.stopImmediatePropagation();
               _loc4_ = this.calculateNearestPageIndexForItem(_loc3_,this._verticalPageIndex,this._maxVerticalPageIndex);
               this.throwToPage(this._horizontalPageIndex,_loc4_,this._pageThrowDuration);
            }
            else if(this._maxHorizontalPageIndex != this._minHorizontalPageIndex)
            {
               param1.stopImmediatePropagation();
               _loc4_ = this.calculateNearestPageIndexForItem(_loc3_,this._horizontalPageIndex,this._maxHorizontalPageIndex);
               this.throwToPage(_loc4_,this._verticalPageIndex,this._pageThrowDuration);
            }
         }
      }
   }
}

