package feathers.controls
{
   import feathers.core.IGroupedToggle;
   import feathers.core.ToggleGroup;
   import feathers.events.FeathersEventType;
   import feathers.skins.IStyleProvider;
   import feathers.utils.keyboard.KeyToSelect;
   import feathers.utils.touch.TapToSelect;
   import flash.ui.Keyboard;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import starling.text.TextFormat;
   
   public class ToggleButton extends Button implements IGroupedToggle
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      protected var tapToSelect:TapToSelect;
      
      protected var keyToSelect:KeyToSelect;
      
      protected var dpadEnterKeyToSelect:KeyToSelect;
      
      protected var _isToggle:Boolean = true;
      
      protected var _isSelected:Boolean = false;
      
      protected var _toggleGroup:ToggleGroup;
      
      protected var _defaultSelectedSkin:DisplayObject;
      
      protected var _defaultSelectedIcon:DisplayObject;
      
      protected var _scaleWhenSelected:Number = 1;
      
      public function ToggleButton()
      {
         super();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         if(ToggleButton.globalStyleProvider)
         {
            return ToggleButton.globalStyleProvider;
         }
         return Button.globalStyleProvider;
      }
      
      override public function get currentState() : String
      {
         if(this._isSelected)
         {
            return super.currentState + "AndSelected";
         }
         return super.currentState;
      }
      
      public function get isToggle() : Boolean
      {
         return this._isToggle;
      }
      
      public function set isToggle(param1:Boolean) : void
      {
         if(this._isToggle === param1)
         {
            return;
         }
         this._isToggle = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get isSelected() : Boolean
      {
         return this._isSelected;
      }
      
      public function set isSelected(param1:Boolean) : void
      {
         if(this._isSelected === param1)
         {
            return;
         }
         this._isSelected = param1;
         this.invalidate(INVALIDATION_FLAG_SELECTED);
         this.invalidate(INVALIDATION_FLAG_STATE);
         this.dispatchEventWith(Event.CHANGE);
         this.dispatchEventWith(FeathersEventType.STATE_CHANGE);
      }
      
      public function get toggleGroup() : ToggleGroup
      {
         return this._toggleGroup;
      }
      
      public function set toggleGroup(param1:ToggleGroup) : void
      {
         if(this._toggleGroup == param1)
         {
            return;
         }
         if(Boolean(this._toggleGroup) && this._toggleGroup.hasItem(this))
         {
            this._toggleGroup.removeItem(this);
         }
         this._toggleGroup = param1;
         if(Boolean(this._toggleGroup) && !this._toggleGroup.hasItem(this))
         {
            this._toggleGroup.addItem(this);
         }
      }
      
      public function get defaultSelectedSkin() : DisplayObject
      {
         return this._defaultSelectedSkin;
      }
      
      public function set defaultSelectedSkin(param1:DisplayObject) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            if(param1 !== null)
            {
               param1.dispose();
            }
            return;
         }
         if(this._defaultSelectedSkin === param1)
         {
            return;
         }
         if(this._defaultSelectedSkin !== null && this.currentSkin === this._defaultSelectedSkin)
         {
            this.removeCurrentSkin(this._defaultSelectedSkin);
            this.currentSkin = null;
         }
         this._defaultSelectedSkin = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get selectedUpSkin() : DisplayObject
      {
         return this.getSkinForState(ButtonState.UP_AND_SELECTED);
      }
      
      public function set selectedUpSkin(param1:DisplayObject) : void
      {
         this.setSkinForState(ButtonState.UP_AND_SELECTED,param1);
      }
      
      public function get selectedDownSkin() : DisplayObject
      {
         return this.getSkinForState(ButtonState.DOWN_AND_SELECTED);
      }
      
      public function set selectedDownSkin(param1:DisplayObject) : void
      {
         this.setSkinForState(ButtonState.DOWN_AND_SELECTED,param1);
      }
      
      public function get selectedHoverSkin() : DisplayObject
      {
         return this.getSkinForState(ButtonState.HOVER_AND_SELECTED);
      }
      
      public function set selectedHoverSkin(param1:DisplayObject) : void
      {
         this.setSkinForState(ButtonState.HOVER_AND_SELECTED,param1);
      }
      
      public function get selectedDisabledSkin() : DisplayObject
      {
         return this.getSkinForState(ButtonState.DISABLED_AND_SELECTED);
      }
      
      public function set selectedDisabledSkin(param1:DisplayObject) : void
      {
         this.setSkinForState(ButtonState.DISABLED_AND_SELECTED,param1);
      }
      
      public function get selectedFontStyles() : TextFormat
      {
         return this._fontStylesSet.selectedFormat;
      }
      
      public function set selectedFontStyles(param1:TextFormat) : void
      {
         var savedCallee:Function = null;
         var changeHandler:Function = null;
         var value:TextFormat = param1;
         changeHandler = function(param1:Event):void
         {
            processStyleRestriction(savedCallee);
         };
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         savedCallee = arguments.callee;
         if(value !== null)
         {
            value.removeEventListener(Event.CHANGE,changeHandler);
         }
         this._fontStylesSet.selectedFormat = value;
         if(value !== null)
         {
            value.addEventListener(Event.CHANGE,changeHandler);
         }
      }
      
      public function get defaultSelectedIcon() : DisplayObject
      {
         return this._defaultSelectedIcon;
      }
      
      public function set defaultSelectedIcon(param1:DisplayObject) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            if(param1 !== null)
            {
               param1.dispose();
            }
            return;
         }
         if(this._defaultSelectedIcon === param1)
         {
            return;
         }
         if(this._defaultSelectedIcon !== null && this.currentIcon === this._defaultSelectedIcon)
         {
            this.removeCurrentIcon(this._defaultSelectedIcon);
            this.currentIcon = null;
         }
         this._defaultSelectedIcon = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get selectedUpIcon() : DisplayObject
      {
         return this.getIconForState(ButtonState.UP_AND_SELECTED);
      }
      
      public function set selectedUpIcon(param1:DisplayObject) : void
      {
         this.setIconForState(ButtonState.UP_AND_SELECTED,param1);
      }
      
      public function get selectedDownIcon() : DisplayObject
      {
         return this.getIconForState(ButtonState.DOWN_AND_SELECTED);
      }
      
      public function set selectedDownIcon(param1:DisplayObject) : void
      {
         this.setIconForState(ButtonState.DOWN_AND_SELECTED,param1);
      }
      
      public function get selectedHoverIcon() : DisplayObject
      {
         return this.getIconForState(ButtonState.HOVER_AND_SELECTED);
      }
      
      public function set selectedHoverIcon(param1:DisplayObject) : void
      {
         this.setIconForState(ButtonState.HOVER_AND_SELECTED,param1);
      }
      
      public function get selectedDisabledIcon() : DisplayObject
      {
         return this.getIconForState(ButtonState.DISABLED_AND_SELECTED);
      }
      
      public function set selectedDisabledIcon(param1:DisplayObject) : void
      {
         this.setIconForState(ButtonState.DISABLED_AND_SELECTED,param1);
      }
      
      public function get scaleWhenSelected() : Number
      {
         return this._scaleWhenSelected;
      }
      
      public function set scaleWhenSelected(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._scaleWhenSelected == param1)
         {
            return;
         }
         this._scaleWhenSelected = param1;
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._defaultSelectedSkin) && this._defaultSelectedSkin.parent !== this)
         {
            this._defaultSelectedSkin.dispose();
         }
         if(Boolean(this._defaultSelectedIcon) && this._defaultSelectedIcon.parent !== this)
         {
            this._defaultSelectedIcon.dispose();
         }
         if(this.keyToSelect !== null)
         {
            this.keyToSelect.target = null;
         }
         if(this.dpadEnterKeyToSelect !== null)
         {
            this.dpadEnterKeyToSelect.target = null;
         }
         if(this.tapToSelect !== null)
         {
            this.tapToSelect.target = null;
         }
         super.dispose();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         if(!this.tapToSelect)
         {
            this.tapToSelect = new TapToSelect(this);
            this.longPress.tapToSelect = this.tapToSelect;
         }
         if(!this.keyToSelect)
         {
            this.keyToSelect = new KeyToSelect(this);
         }
         if(!this.dpadEnterKeyToSelect)
         {
            this.dpadEnterKeyToSelect = new KeyToSelect(this,Keyboard.ENTER);
            this.dpadEnterKeyToState.keyLocation = 4;
         }
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         if(_loc1_ || _loc2_)
         {
            this.refreshSelectionEvents();
         }
         super.draw();
      }
      
      override protected function getCurrentSkin() : DisplayObject
      {
         var _loc1_:DisplayObject = this._stateToSkin[this.currentState] as DisplayObject;
         if(_loc1_ !== null)
         {
            return _loc1_;
         }
         if(this._isSelected && this._defaultSelectedSkin !== null)
         {
            return this._defaultSelectedSkin;
         }
         return this._defaultSkin;
      }
      
      override protected function getCurrentIcon() : DisplayObject
      {
         var _loc1_:DisplayObject = this._stateToIcon[this.currentState] as DisplayObject;
         if(_loc1_ !== null)
         {
            return _loc1_;
         }
         if(this._isSelected && this._defaultSelectedIcon !== null)
         {
            return this._defaultSelectedIcon;
         }
         return this._defaultIcon;
      }
      
      override protected function getScaleForCurrentState(param1:String = null) : Number
      {
         if(param1 === null)
         {
            param1 = this.currentState;
         }
         if(param1 in this._stateToScale)
         {
            return this._stateToScale[param1];
         }
         if(this._isSelected)
         {
            return this._scaleWhenSelected;
         }
         return 1;
      }
      
      protected function refreshSelectionEvents() : void
      {
         this.tapToSelect.isEnabled = this._isEnabled && this._isToggle;
         this.tapToSelect.tapToDeselect = this._isToggle;
         this.keyToSelect.isEnabled = this._isEnabled && this._isToggle;
         this.keyToSelect.keyToDeselect = this._isToggle;
         this.dpadEnterKeyToSelect.isEnabled = this._isEnabled && this._isToggle;
         this.dpadEnterKeyToSelect.keyToDeselect = this._isToggle;
      }
   }
}

