package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.IStateContext;
   import feathers.core.IStateObserver;
   import feathers.core.IValidating;
   import feathers.events.FeathersEventType;
   import feathers.skins.IStyleProvider;
   import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;
   import feathers.utils.touch.TapToTrigger;
   import feathers.utils.touch.TouchToState;
   import flash.geom.Point;
   import starling.display.DisplayObject;
   
   public class BasicButton extends FeathersControl implements IStateContext
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      private static const HELPER_POINT:Point = new Point();
      
      protected var touchToState:TouchToState;
      
      protected var tapToTrigger:TapToTrigger;
      
      protected var _currentState:String = "up";
      
      protected var currentSkin:DisplayObject;
      
      protected var _keepDownStateOnRollOut:Boolean = false;
      
      protected var _defaultSkin:DisplayObject;
      
      protected var _stateToSkin:Object = {};
      
      protected var _explicitSkinWidth:Number;
      
      protected var _explicitSkinHeight:Number;
      
      protected var _explicitSkinMinWidth:Number;
      
      protected var _explicitSkinMinHeight:Number;
      
      protected var _explicitSkinMaxWidth:Number;
      
      protected var _explicitSkinMaxHeight:Number;
      
      public function BasicButton()
      {
         super();
         this.isQuickHitAreaEnabled = true;
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return BasicButton.globalStyleProvider;
      }
      
      public function get currentState() : String
      {
         return this._currentState;
      }
      
      override public function set isEnabled(param1:Boolean) : void
      {
         if(this._isEnabled === param1)
         {
            return;
         }
         super.isEnabled = param1;
         if(this._isEnabled)
         {
            if(this._currentState === ButtonState.DISABLED)
            {
               this.changeState(ButtonState.UP);
            }
         }
         else
         {
            this.changeState(ButtonState.DISABLED);
         }
      }
      
      public function get keepDownStateOnRollOut() : Boolean
      {
         return this._keepDownStateOnRollOut;
      }
      
      public function set keepDownStateOnRollOut(param1:Boolean) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         this._keepDownStateOnRollOut = param1;
         if(this.touchToState !== null)
         {
            this.touchToState.keepDownStateOnRollOut = param1;
         }
      }
      
      public function get defaultSkin() : DisplayObject
      {
         return this._defaultSkin;
      }
      
      public function set defaultSkin(param1:DisplayObject) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            if(param1 !== null)
            {
               param1.dispose();
            }
            return;
         }
         if(this._defaultSkin === param1)
         {
            return;
         }
         if(this._defaultSkin !== null && this.currentSkin === this._defaultSkin)
         {
            this.removeCurrentSkin(this._defaultSkin);
            this.currentSkin = null;
         }
         this._defaultSkin = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get upSkin() : DisplayObject
      {
         return this.getSkinForState(ButtonState.UP);
      }
      
      public function set upSkin(param1:DisplayObject) : void
      {
         this.setSkinForState(ButtonState.UP,param1);
      }
      
      public function get downSkin() : DisplayObject
      {
         return this.getSkinForState(ButtonState.DOWN);
      }
      
      public function set downSkin(param1:DisplayObject) : void
      {
         this.setSkinForState(ButtonState.DOWN,param1);
      }
      
      public function get hoverSkin() : DisplayObject
      {
         return this.getSkinForState(ButtonState.HOVER);
      }
      
      public function set hoverSkin(param1:DisplayObject) : void
      {
         this.setSkinForState(ButtonState.HOVER,param1);
      }
      
      public function get disabledSkin() : DisplayObject
      {
         return this.getSkinForState(ButtonState.DISABLED);
      }
      
      public function set disabledSkin(param1:DisplayObject) : void
      {
         this.setSkinForState(ButtonState.DISABLED,param1);
      }
      
      public function getSkinForState(param1:String) : DisplayObject
      {
         return this._stateToSkin[param1] as DisplayObject;
      }
      
      public function setSkinForState(param1:String, param2:DisplayObject) : void
      {
         var _loc3_:String = "setSkinForState--" + param1;
         if(this.processStyleRestriction(_loc3_))
         {
            if(param2 !== null)
            {
               param2.dispose();
            }
            return;
         }
         var _loc4_:DisplayObject = this._stateToSkin[param1] as DisplayObject;
         if(_loc4_ !== null && this.currentSkin === _loc4_)
         {
            this.removeCurrentSkin(_loc4_);
            this.currentSkin = null;
         }
         if(param2 !== null)
         {
            this._stateToSkin[param1] = param2;
         }
         else
         {
            delete this._stateToSkin[param1];
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      override public function dispose() : void
      {
         var _loc1_:String = null;
         var _loc2_:DisplayObject = null;
         if(this._defaultSkin !== null && this._defaultSkin.parent !== this)
         {
            this._defaultSkin.dispose();
         }
         for(_loc1_ in this._stateToSkin)
         {
            _loc2_ = this._stateToSkin[_loc1_] as DisplayObject;
            if(_loc2_ !== null && _loc2_.parent !== this)
            {
               _loc2_.dispose();
            }
         }
         if(this.touchToState !== null)
         {
            this.touchToState.target = null;
         }
         if(this.tapToTrigger !== null)
         {
            this.tapToTrigger.target = null;
         }
         super.dispose();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         if(!this.touchToState)
         {
            this.touchToState = new TouchToState(this,this.changeState);
         }
         this.touchToState.keepDownStateOnRollOut = this._keepDownStateOnRollOut;
         if(!this.tapToTrigger)
         {
            this.tapToTrigger = new TapToTrigger(this);
         }
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
         if(_loc1_ || _loc2_)
         {
            this.refreshTriggeredEvents();
            this.refreshSkin();
         }
         this.autoSizeIfNeeded();
         this.scaleSkin();
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc1_:Boolean = this._explicitWidth !== this._explicitWidth;
         var _loc2_:Boolean = this._explicitHeight !== this._explicitHeight;
         var _loc3_:Boolean = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc4_:Boolean = this._explicitMinHeight !== this._explicitMinHeight;
         if(!_loc1_ && !_loc2_ && !_loc3_ && !_loc4_)
         {
            return false;
         }
         resetFluidChildDimensionsForMeasurement(this.currentSkin,this._explicitWidth,this._explicitHeight,this._explicitMinWidth,this._explicitMinHeight,this._explicitMaxWidth,this._explicitMaxHeight,this._explicitSkinWidth,this._explicitSkinHeight,this._explicitSkinMinWidth,this._explicitSkinMinHeight,this._explicitSkinMaxWidth,this._explicitSkinMaxHeight);
         var _loc5_:IMeasureDisplayObject = this.currentSkin as IMeasureDisplayObject;
         if(this.currentSkin is IValidating)
         {
            IValidating(this.currentSkin).validate();
         }
         var _loc6_:Number = this._explicitMinWidth;
         if(_loc3_)
         {
            if(_loc5_ !== null)
            {
               _loc6_ = _loc5_.minWidth;
            }
            else if(this.currentSkin !== null)
            {
               _loc6_ = this._explicitSkinMinWidth;
            }
            else
            {
               _loc6_ = 0;
            }
         }
         var _loc7_:Number = this._explicitMinHeight;
         if(_loc4_)
         {
            if(_loc5_ !== null)
            {
               _loc7_ = _loc5_.minHeight;
            }
            else if(this.currentSkin !== null)
            {
               _loc7_ = this._explicitSkinMinHeight;
            }
            else
            {
               _loc7_ = 0;
            }
         }
         var _loc8_:Number = this._explicitWidth;
         if(_loc1_)
         {
            if(this.currentSkin !== null)
            {
               _loc8_ = this.currentSkin.width;
            }
            else
            {
               _loc8_ = 0;
            }
         }
         var _loc9_:Number = this._explicitHeight;
         if(_loc2_)
         {
            if(this.currentSkin !== null)
            {
               _loc9_ = this.currentSkin.height;
            }
            else
            {
               _loc9_ = 0;
            }
         }
         return this.saveMeasurements(_loc8_,_loc9_,_loc6_,_loc7_);
      }
      
      protected function refreshSkin() : void
      {
         var _loc2_:IMeasureDisplayObject = null;
         var _loc1_:DisplayObject = this.currentSkin;
         this.currentSkin = this.getCurrentSkin();
         if(this.currentSkin !== _loc1_)
         {
            this.removeCurrentSkin(_loc1_);
            if(this.currentSkin !== null)
            {
               if(this.currentSkin is IFeathersControl)
               {
                  IFeathersControl(this.currentSkin).initializeNow();
               }
               if(this.currentSkin is IMeasureDisplayObject)
               {
                  _loc2_ = IMeasureDisplayObject(this.currentSkin);
                  this._explicitSkinWidth = _loc2_.explicitWidth;
                  this._explicitSkinHeight = _loc2_.explicitHeight;
                  this._explicitSkinMinWidth = _loc2_.explicitMinWidth;
                  this._explicitSkinMinHeight = _loc2_.explicitMinHeight;
                  this._explicitSkinMaxWidth = _loc2_.explicitMaxWidth;
                  this._explicitSkinMaxHeight = _loc2_.explicitMaxHeight;
               }
               else
               {
                  this._explicitSkinWidth = this.currentSkin.width;
                  this._explicitSkinHeight = this.currentSkin.height;
                  this._explicitSkinMinWidth = this._explicitSkinWidth;
                  this._explicitSkinMinHeight = this._explicitSkinHeight;
                  this._explicitSkinMaxWidth = this._explicitSkinWidth;
                  this._explicitSkinMaxHeight = this._explicitSkinHeight;
               }
               if(this.currentSkin is IStateObserver)
               {
                  IStateObserver(this.currentSkin).stateContext = this;
               }
               this.addChildAt(this.currentSkin,0);
            }
         }
      }
      
      protected function getCurrentSkin() : DisplayObject
      {
         var _loc1_:DisplayObject = this._stateToSkin[this._currentState] as DisplayObject;
         if(_loc1_ !== null)
         {
            return _loc1_;
         }
         return this._defaultSkin;
      }
      
      protected function scaleSkin() : void
      {
         if(!this.currentSkin)
         {
            return;
         }
         this.currentSkin.x = 0;
         this.currentSkin.y = 0;
         if(this.currentSkin.width != this.actualWidth)
         {
            this.currentSkin.width = this.actualWidth;
         }
         if(this.currentSkin.height != this.actualHeight)
         {
            this.currentSkin.height = this.actualHeight;
         }
         if(this.currentSkin is IValidating)
         {
            IValidating(this.currentSkin).validate();
         }
      }
      
      protected function removeCurrentSkin(param1:DisplayObject) : void
      {
         var _loc2_:IMeasureDisplayObject = null;
         if(param1 === null)
         {
            return;
         }
         if(param1 is IStateObserver)
         {
            IStateObserver(param1).stateContext = null;
         }
         if(param1.parent === this)
         {
            param1.width = this._explicitSkinWidth;
            param1.height = this._explicitSkinHeight;
            if(param1 is IMeasureDisplayObject)
            {
               _loc2_ = IMeasureDisplayObject(param1);
               _loc2_.minWidth = this._explicitSkinMinWidth;
               _loc2_.minHeight = this._explicitSkinMinHeight;
               _loc2_.maxWidth = this._explicitSkinMaxWidth;
               _loc2_.maxHeight = this._explicitSkinMaxHeight;
            }
            this.removeChild(param1,false);
         }
      }
      
      protected function refreshTriggeredEvents() : void
      {
         this.tapToTrigger.isEnabled = this._isEnabled;
      }
      
      protected function changeState(param1:String) : void
      {
         if(!this._isEnabled)
         {
            param1 = ButtonState.DISABLED;
         }
         if(this._currentState === param1)
         {
            return;
         }
         this._currentState = param1;
         this.invalidate(INVALIDATION_FLAG_STATE);
         this.dispatchEventWith(FeathersEventType.STATE_CHANGE);
      }
   }
}

