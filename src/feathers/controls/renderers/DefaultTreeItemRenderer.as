package feathers.controls.renderers
{
   import feathers.controls.BasicButton;
   import feathers.controls.Tree;
   import feathers.core.IFeathersControl;
   import feathers.core.IStateObserver;
   import feathers.core.IValidating;
   import feathers.events.FeathersEventType;
   import feathers.skins.IStyleProvider;
   import feathers.utils.touch.TapToTrigger;
   import flash.geom.Point;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.events.Event;
   
   public class DefaultTreeItemRenderer extends BaseDefaultItemRenderer implements ITreeItemRenderer
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      public static const DEFAULT_CHILD_STYLE_NAME_LABEL:String = "feathers-item-renderer-label";
      
      public static const DEFAULT_CHILD_STYLE_NAME_ICON_LABEL:String = "feathers-item-renderer-icon-label";
      
      public static const DEFAULT_CHILD_STYLE_NAME_ACCESSORY_LABEL:String = "feathers-item-renderer-accessory-label";
      
      protected var _ignoreDisclosureIconResizes:Boolean = false;
      
      protected var _ignoreBranchOrLeafIconResizes:Boolean = false;
      
      protected var _disclosureIconTapToTrigger:TapToTrigger = null;
      
      protected var _currentDisclosureIcon:DisplayObject = null;
      
      protected var _disclosureIcon:DisplayObject = null;
      
      protected var _disclosureOpenIcon:DisplayObject = null;
      
      protected var _disclosureClosedIcon:DisplayObject = null;
      
      protected var _currentBranchOrLeafIcon:DisplayObject = null;
      
      protected var _branchIcon:DisplayObject = null;
      
      protected var _branchOpenIcon:DisplayObject = null;
      
      protected var _branchClosedIcon:DisplayObject = null;
      
      protected var _leafIcon:DisplayObject = null;
      
      protected var _location:Vector.<int> = null;
      
      protected var _layoutIndex:int = -1;
      
      protected var _indentation:Number = 10;
      
      protected var _disclosureGap:Number = NaN;
      
      protected var _isOpen:Boolean = false;
      
      protected var _isBranch:Boolean = false;
      
      public function DefaultTreeItemRenderer()
      {
         super();
         this.addEventListener(Event.TRIGGERED,this.treeItemRenderer_triggeredHandler);
      }
      
      public function get disclosureIcon() : DisplayObject
      {
         return this._disclosureIcon;
      }
      
      public function set disclosureIcon(param1:DisplayObject) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            if(param1 !== null)
            {
               param1.dispose();
            }
            return;
         }
         if(this._disclosureIcon === param1)
         {
            return;
         }
         if(this._disclosureIcon !== null && this._currentDisclosureIcon === this._disclosureIcon)
         {
            this.removeCurrentDisclosureIcon(this._disclosureIcon);
            this._currentDisclosureIcon = null;
         }
         this._disclosureIcon = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get disclosureOpenIcon() : DisplayObject
      {
         return this._disclosureOpenIcon;
      }
      
      public function set disclosureOpenIcon(param1:DisplayObject) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            if(param1 !== null)
            {
               param1.dispose();
            }
            return;
         }
         if(this._disclosureOpenIcon === param1)
         {
            return;
         }
         if(this._disclosureOpenIcon !== null && this._currentDisclosureIcon === this._disclosureOpenIcon)
         {
            this.removeCurrentDisclosureIcon(this._disclosureOpenIcon);
            this._currentDisclosureIcon = null;
         }
         this._disclosureOpenIcon = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get disclosureClosedIcon() : DisplayObject
      {
         return this._disclosureClosedIcon;
      }
      
      public function set disclosureClosedIcon(param1:DisplayObject) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            if(param1 !== null)
            {
               param1.dispose();
            }
            return;
         }
         if(this._disclosureClosedIcon === param1)
         {
            return;
         }
         if(this._disclosureClosedIcon !== null && this._currentDisclosureIcon === this._disclosureClosedIcon)
         {
            this.removeCurrentDisclosureIcon(this._disclosureClosedIcon);
            this._currentDisclosureIcon = null;
         }
         this._disclosureClosedIcon = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get branchIcon() : DisplayObject
      {
         return this._branchIcon;
      }
      
      public function set branchIcon(param1:DisplayObject) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            if(param1 !== null)
            {
               param1.dispose();
            }
            return;
         }
         if(this._branchIcon === param1)
         {
            return;
         }
         if(this._branchIcon !== null && this._currentBranchOrLeafIcon === this._branchIcon)
         {
            this.removeCurrentBranchOrLeafIcon(this._branchIcon);
            this._currentBranchOrLeafIcon = null;
         }
         this._branchIcon = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get branchOpenIcon() : DisplayObject
      {
         return this._branchOpenIcon;
      }
      
      public function set branchOpenIcon(param1:DisplayObject) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            if(param1 !== null)
            {
               param1.dispose();
            }
            return;
         }
         if(this._branchOpenIcon === param1)
         {
            return;
         }
         if(this._branchOpenIcon !== null && this._currentBranchOrLeafIcon === this._branchOpenIcon)
         {
            this.removeCurrentBranchOrLeafIcon(this._branchOpenIcon);
            this._currentBranchOrLeafIcon = null;
         }
         this._branchOpenIcon = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get branchClosedIcon() : DisplayObject
      {
         return this._branchClosedIcon;
      }
      
      public function set branchClosedIcon(param1:DisplayObject) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            if(param1 !== null)
            {
               param1.dispose();
            }
            return;
         }
         if(this._branchOpenIcon === param1)
         {
            return;
         }
         if(this._branchClosedIcon !== null && this._currentBranchOrLeafIcon === this._branchClosedIcon)
         {
            this.removeCurrentBranchOrLeafIcon(this._branchClosedIcon);
            this._currentBranchOrLeafIcon = null;
         }
         this._branchClosedIcon = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get leafIcon() : DisplayObject
      {
         return this._leafIcon;
      }
      
      public function set leafIcon(param1:DisplayObject) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            if(param1 !== null)
            {
               param1.dispose();
            }
            return;
         }
         if(this._leafIcon === param1)
         {
            return;
         }
         if(this._leafIcon !== null && this._currentBranchOrLeafIcon === this._leafIcon)
         {
            this.removeCurrentBranchOrLeafIcon(this._leafIcon);
            this._currentBranchOrLeafIcon = null;
         }
         this._leafIcon = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return DefaultTreeItemRenderer.globalStyleProvider;
      }
      
      public function get owner() : Tree
      {
         return Tree(this._owner);
      }
      
      public function set owner(param1:Tree) : void
      {
         var _loc2_:Tree = null;
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
            _loc2_ = Tree(this._owner);
            this.isSelectableWithoutToggle = _loc2_.isSelectable;
            this._owner.addEventListener(FeathersEventType.SCROLL_START,owner_scrollStartHandler);
            this._owner.addEventListener(FeathersEventType.SCROLL_COMPLETE,owner_scrollCompleteHandler);
         }
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get location() : Vector.<int>
      {
         return this._location;
      }
      
      public function set location(param1:Vector.<int>) : void
      {
         if(this._location === param1)
         {
            return;
         }
         this._location = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get layoutIndex() : int
      {
         return this._layoutIndex;
      }
      
      public function set layoutIndex(param1:int) : void
      {
         this._layoutIndex = param1;
      }
      
      public function get indentation() : Number
      {
         return this._indentation;
      }
      
      public function set indentation(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._indentation == param1)
         {
            return;
         }
         this._indentation = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get disclosureGap() : Number
      {
         return this._disclosureGap;
      }
      
      public function set disclosureGap(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._disclosureGap == param1)
         {
            return;
         }
         this._disclosureGap = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      public function set isOpen(param1:Boolean) : void
      {
         if(this._isOpen === param1)
         {
            return;
         }
         this._isOpen = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get isBranch() : Boolean
      {
         return this._isBranch;
      }
      
      public function set isBranch(param1:Boolean) : void
      {
         if(this._isBranch === param1)
         {
            return;
         }
         this._isBranch = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      override public function dispose() : void
      {
         if(this._disclosureIcon !== null && this._disclosureIcon.parent !== this)
         {
            this._disclosureIcon.dispose();
         }
         if(this._disclosureOpenIcon !== null && this._disclosureOpenIcon.parent !== this)
         {
            this._disclosureOpenIcon.dispose();
         }
         if(this._disclosureClosedIcon !== null && this._disclosureClosedIcon.parent !== this)
         {
            this._disclosureClosedIcon.dispose();
         }
         if(this._branchIcon !== null && this._branchIcon.parent !== this)
         {
            this._branchIcon.dispose();
         }
         if(this._branchOpenIcon !== null && this._branchOpenIcon.parent !== this)
         {
            this._branchOpenIcon.dispose();
         }
         if(this._branchClosedIcon !== null && this._branchClosedIcon.parent !== this)
         {
            this._branchClosedIcon.dispose();
         }
         if(this._leafIcon !== null && this._leafIcon.parent !== this)
         {
            this._leafIcon.dispose();
         }
         this.owner = null;
         super.dispose();
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         if(_loc3_ || _loc2_ || _loc1_)
         {
            this.refreshDisclosureIcon();
            this.refreshBranchOrLeafIcon();
         }
         super.draw();
      }
      
      override protected function refreshOffsets() : void
      {
         var _loc2_:Boolean = false;
         super.refreshOffsets();
         if(this._location !== null)
         {
            this._leftOffset += this._indentation * (this._location.length - 1);
         }
         var _loc1_:Number = this._gap;
         if(this._disclosureGap === this._disclosureGap)
         {
            _loc1_ = this._disclosureGap;
         }
         if(this._currentDisclosureIcon !== null)
         {
            _loc2_ = this._ignoreDisclosureIconResizes;
            this._ignoreDisclosureIconResizes = true;
            if(this._currentDisclosureIcon is IValidating)
            {
               IValidating(this._currentDisclosureIcon).validate();
            }
            this._ignoreDisclosureIconResizes = _loc2_;
            this._leftOffset += this._currentDisclosureIcon.width + _loc1_;
            if(this._isBranch)
            {
               this._currentDisclosureIcon.visible = true;
            }
            else
            {
               this._currentDisclosureIcon.visible = false;
            }
         }
         if(this._currentBranchOrLeafIcon !== null)
         {
            _loc2_ = this._ignoreBranchOrLeafIconResizes;
            this._ignoreBranchOrLeafIconResizes = true;
            if(this._currentBranchOrLeafIcon is IValidating)
            {
               IValidating(this._currentBranchOrLeafIcon).validate();
            }
            this._ignoreBranchOrLeafIconResizes = _loc2_;
            this._leftOffset += this._currentBranchOrLeafIcon.width + _loc1_;
         }
      }
      
      override protected function layoutContent() : void
      {
         var _loc2_:Boolean = false;
         super.layoutContent();
         var _loc1_:Number = this._paddingLeft;
         if(this._location !== null)
         {
            _loc1_ += this._indentation * (this._location.length - 1);
         }
         if(this._currentDisclosureIcon !== null)
         {
            _loc2_ = this._ignoreDisclosureIconResizes;
            this._ignoreDisclosureIconResizes = true;
            if(this._currentDisclosureIcon is IValidating)
            {
               IValidating(this._currentDisclosureIcon).validate();
            }
            this._ignoreDisclosureIconResizes = _loc2_;
            this._currentDisclosureIcon.x = _loc1_;
            this._currentDisclosureIcon.y = this._paddingTop + (this.actualHeight - this._paddingTop - this._paddingBottom - this._currentDisclosureIcon.height) / 2;
            _loc1_ += this._currentDisclosureIcon.width + this._gap;
         }
         if(this._currentBranchOrLeafIcon !== null)
         {
            _loc2_ = this._ignoreBranchOrLeafIconResizes;
            this._ignoreBranchOrLeafIconResizes = true;
            if(this._currentBranchOrLeafIcon is IValidating)
            {
               IValidating(this._currentBranchOrLeafIcon).validate();
            }
            this._ignoreBranchOrLeafIconResizes = _loc2_;
            this._currentBranchOrLeafIcon.x = _loc1_;
            this._currentBranchOrLeafIcon.y = this._paddingTop + (this.actualHeight - this._paddingTop - this._paddingBottom - this._currentBranchOrLeafIcon.height) / 2;
         }
      }
      
      override protected function hitTestWithAccessory(param1:Point) : Boolean
      {
         var _loc2_:DisplayObjectContainer = null;
         if(this._currentDisclosureIcon !== null)
         {
            if(this._currentDisclosureIcon is DisplayObjectContainer)
            {
               _loc2_ = DisplayObjectContainer(this._currentDisclosureIcon);
               if(_loc2_.contains(this.hitTest(param1)))
               {
                  return false;
               }
            }
            if(this.hitTest(param1) === this._currentDisclosureIcon)
            {
               return false;
            }
         }
         return super.hitTestWithAccessory(param1);
      }
      
      protected function getCurrentDisclosureIcon() : DisplayObject
      {
         var _loc1_:DisplayObject = this._disclosureIcon;
         if(this._isOpen && this._disclosureOpenIcon !== null)
         {
            _loc1_ = this._disclosureOpenIcon;
         }
         else if(!this._isOpen && this._disclosureClosedIcon !== null)
         {
            _loc1_ = this._disclosureClosedIcon;
         }
         return _loc1_;
      }
      
      protected function getCurrentBranchOrLeafIcon() : DisplayObject
      {
         var _loc1_:DisplayObject = this._leafIcon;
         if(this._isBranch)
         {
            _loc1_ = this._branchIcon;
            if(this._isOpen && this._branchOpenIcon !== null)
            {
               _loc1_ = this._branchOpenIcon;
            }
            else if(!this._isOpen && this._branchClosedIcon !== null)
            {
               _loc1_ = this._branchClosedIcon;
            }
         }
         return _loc1_;
      }
      
      protected function removeCurrentDisclosureIcon(param1:DisplayObject) : void
      {
         if(param1 === null)
         {
            return;
         }
         if(param1 is IFeathersControl)
         {
            IFeathersControl(param1).removeEventListener(FeathersEventType.RESIZE,this.currentDisclosureIcon_resizeHandler);
         }
         param1.removeEventListener(Event.TRIGGERED,this.disclosureIcon_triggeredHandler);
         if(param1 is IStateObserver)
         {
            IStateObserver(param1).stateContext = null;
         }
         if(param1.parent === this)
         {
            this.removeChild(param1,false);
         }
      }
      
      protected function removeCurrentBranchOrLeafIcon(param1:DisplayObject) : void
      {
         if(param1 === null)
         {
            return;
         }
         if(param1 is IFeathersControl)
         {
            IFeathersControl(param1).removeEventListener(FeathersEventType.RESIZE,this.currentBranchOrLeafIcon_resizeHandler);
         }
         if(param1 is IStateObserver)
         {
            IStateObserver(param1).stateContext = null;
         }
         if(param1.parent === this)
         {
            this.removeChild(param1,false);
         }
      }
      
      protected function refreshDisclosureIcon() : void
      {
         var _loc1_:DisplayObject = this._currentDisclosureIcon;
         this._currentDisclosureIcon = this.getCurrentDisclosureIcon();
         if(this._currentDisclosureIcon is IFeathersControl)
         {
            IFeathersControl(this._currentDisclosureIcon).isEnabled = this._isEnabled;
         }
         if(this._currentDisclosureIcon !== _loc1_)
         {
            if(_loc1_ !== null)
            {
               this.removeCurrentDisclosureIcon(_loc1_);
            }
            if(this._currentDisclosureIcon !== null)
            {
               if(this._currentDisclosureIcon is IStateObserver)
               {
                  IStateObserver(this._currentDisclosureIcon).stateContext = this;
               }
               this.addChild(this._currentDisclosureIcon);
               if(!(this._currentDisclosureIcon is BasicButton))
               {
                  if(this._disclosureIconTapToTrigger !== null)
                  {
                     this._disclosureIconTapToTrigger.target = this._currentDisclosureIcon;
                  }
                  else
                  {
                     this._disclosureIconTapToTrigger = new TapToTrigger(this._currentDisclosureIcon);
                  }
               }
               this._currentDisclosureIcon.addEventListener(Event.TRIGGERED,this.disclosureIcon_triggeredHandler);
               if(this._currentDisclosureIcon is IFeathersControl)
               {
                  IFeathersControl(this._currentDisclosureIcon).addEventListener(FeathersEventType.RESIZE,this.currentDisclosureIcon_resizeHandler);
               }
            }
            else
            {
               this._disclosureIconTapToTrigger = null;
            }
         }
      }
      
      protected function refreshBranchOrLeafIcon() : void
      {
         var _loc1_:DisplayObject = this._currentBranchOrLeafIcon;
         this._currentBranchOrLeafIcon = this.getCurrentBranchOrLeafIcon();
         if(this._currentBranchOrLeafIcon is IFeathersControl)
         {
            IFeathersControl(this._currentBranchOrLeafIcon).isEnabled = this._isEnabled;
         }
         if(this._currentBranchOrLeafIcon !== _loc1_)
         {
            if(_loc1_ !== null)
            {
               this.removeCurrentBranchOrLeafIcon(_loc1_);
            }
            if(this._currentBranchOrLeafIcon !== null)
            {
               if(this._currentBranchOrLeafIcon is IStateObserver)
               {
                  IStateObserver(this._currentBranchOrLeafIcon).stateContext = this;
               }
               this.addChild(this._currentBranchOrLeafIcon);
               if(this._currentBranchOrLeafIcon is IFeathersControl)
               {
                  IFeathersControl(this._currentBranchOrLeafIcon).addEventListener(FeathersEventType.RESIZE,this.currentBranchOrLeafIcon_resizeHandler);
               }
            }
         }
      }
      
      protected function disclosureIcon_triggeredHandler(param1:Event) : void
      {
         this.owner.toggleBranch(this._data,!this._isOpen);
      }
      
      protected function treeItemRenderer_triggeredHandler(param1:Event) : void
      {
         if(this._currentDisclosureIcon !== null && !this._isQuickHitAreaEnabled || !this._isBranch)
         {
            return;
         }
         this.owner.toggleBranch(this._data,!this._isOpen);
      }
      
      protected function currentDisclosureIcon_resizeHandler() : void
      {
         if(this._ignoreDisclosureIconResizes)
         {
            return;
         }
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
      
      protected function currentBranchOrLeafIcon_resizeHandler() : void
      {
         if(this._ignoreBranchOrLeafIconResizes)
         {
            return;
         }
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
   }
}

