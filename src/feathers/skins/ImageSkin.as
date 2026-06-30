package feathers.skins
{
   import feathers.core.IFeathersControl;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.IStateContext;
   import feathers.core.IStateObserver;
   import feathers.core.IToggle;
   import feathers.events.FeathersEventType;
   import flash.errors.IllegalOperationError;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.events.Event;
   import starling.textures.Texture;
   import starling.utils.Pool;
   
   public class ImageSkin extends Image implements IMeasureDisplayObject, IStateObserver
   {
      
      protected var _restrictColor:Boolean = false;
      
      protected var _defaultTexture:Texture;
      
      protected var _disabledTexture:Texture;
      
      protected var _selectedTexture:Texture;
      
      protected var _defaultColor:uint = 16777215;
      
      protected var _disabledColor:uint = 4294967295;
      
      protected var _selectedColor:uint = 4294967295;
      
      protected var _stateContext:IStateContext;
      
      protected var _explicitWidth:Number = NaN;
      
      protected var _explicitHeight:Number = NaN;
      
      protected var _explicitMinWidth:Number = NaN;
      
      protected var _explicitMaxWidth:Number = Infinity;
      
      protected var _explicitMinHeight:Number = NaN;
      
      protected var _explicitMaxHeight:Number = Infinity;
      
      protected var _minTouchWidth:Number = 0;
      
      protected var _minTouchHeight:Number = 0;
      
      protected var _stateToTexture:Object = {};
      
      protected var _stateToColor:Object = {};
      
      public function ImageSkin(param1:Texture = null)
      {
         super(param1);
         this._restrictColor = true;
         this.defaultTexture = param1;
      }
      
      public function get defaultTexture() : Texture
      {
         return this._defaultTexture;
      }
      
      public function set defaultTexture(param1:Texture) : void
      {
         if(this._defaultTexture === param1)
         {
            return;
         }
         this._defaultTexture = param1;
         this.updateTextureFromContext();
      }
      
      public function get disabledTexture() : Texture
      {
         return this._disabledTexture;
      }
      
      public function set disabledTexture(param1:Texture) : void
      {
         if(this._disabledTexture === param1)
         {
            return;
         }
         this._disabledTexture = param1;
         this.updateTextureFromContext();
      }
      
      public function get selectedTexture() : Texture
      {
         return this._selectedTexture;
      }
      
      public function set selectedTexture(param1:Texture) : void
      {
         if(this._selectedTexture === param1)
         {
            return;
         }
         this._selectedTexture = param1;
         this.updateTextureFromContext();
      }
      
      override public function set color(param1:uint) : void
      {
         if(this._restrictColor)
         {
            throw new IllegalOperationError("To set the color of an ImageSkin, use defaultColor or setColorForState().");
         }
         this.$color = param1;
      }
      
      protected function set $color(param1:uint) : void
      {
         super.color = param1;
      }
      
      public function get defaultColor() : uint
      {
         return this._defaultColor;
      }
      
      public function set defaultColor(param1:uint) : void
      {
         if(this._defaultColor == param1)
         {
            return;
         }
         this._defaultColor = param1;
         this.updateColorFromContext();
      }
      
      public function get disabledColor() : uint
      {
         return this._disabledColor;
      }
      
      public function set disabledColor(param1:uint) : void
      {
         if(this._disabledColor == param1)
         {
            return;
         }
         this._disabledColor = param1;
         this.updateColorFromContext();
      }
      
      public function get selectedColor() : uint
      {
         return this._selectedColor;
      }
      
      public function set selectedColor(param1:uint) : void
      {
         if(this._selectedColor == param1)
         {
            return;
         }
         this._selectedColor = param1;
         this.updateColorFromContext();
      }
      
      public function get stateContext() : IStateContext
      {
         return this._stateContext;
      }
      
      public function set stateContext(param1:IStateContext) : void
      {
         if(this._stateContext === param1)
         {
            return;
         }
         if(this._stateContext)
         {
            this._stateContext.removeEventListener(FeathersEventType.STATE_CHANGE,this.stateContext_stageChangeHandler);
         }
         this._stateContext = param1;
         if(this._stateContext)
         {
            this._stateContext.addEventListener(FeathersEventType.STATE_CHANGE,this.stateContext_stageChangeHandler);
         }
         this.updateTextureFromContext();
         this.updateColorFromContext();
      }
      
      public function get explicitWidth() : Number
      {
         return this._explicitWidth;
      }
      
      override public function set width(param1:Number) : void
      {
         if(this._explicitWidth == param1)
         {
            return;
         }
         if(param1 !== param1 && this._explicitWidth !== this._explicitWidth)
         {
            return;
         }
         this._explicitWidth = param1;
         if(param1 === param1)
         {
            super.width = param1;
         }
         else if(this.texture !== null)
         {
            this.scaleX = 1;
            this.readjustSize(this.texture.frameWidth);
         }
         else
         {
            this.readjustSize();
         }
         this.dispatchEventWith(Event.RESIZE);
      }
      
      public function get explicitHeight() : Number
      {
         return this._explicitHeight;
      }
      
      override public function set height(param1:Number) : void
      {
         if(this._explicitHeight == param1)
         {
            return;
         }
         if(param1 !== param1 && this._explicitHeight !== this._explicitHeight)
         {
            return;
         }
         this._explicitHeight = param1;
         if(param1 === param1)
         {
            super.height = param1;
         }
         else if(this.texture !== null)
         {
            this.scaleY = 1;
            this.readjustSize(-1,this.texture.frameHeight);
         }
         else
         {
            this.readjustSize();
         }
         this.dispatchEventWith(Event.RESIZE);
      }
      
      public function get explicitMinWidth() : Number
      {
         return this._explicitMinWidth;
      }
      
      public function get minWidth() : Number
      {
         if(this._explicitMinWidth === this._explicitMinWidth)
         {
            return this._explicitMinWidth;
         }
         return 0;
      }
      
      public function set minWidth(param1:Number) : void
      {
         if(this._explicitMinWidth == param1)
         {
            return;
         }
         if(param1 !== param1 && this._explicitMinWidth !== this._explicitMinWidth)
         {
            return;
         }
         this._explicitMinWidth = param1;
         this.dispatchEventWith(Event.RESIZE);
      }
      
      public function get explicitMaxWidth() : Number
      {
         return this._explicitMaxWidth;
      }
      
      public function get maxWidth() : Number
      {
         return this._explicitMaxWidth;
      }
      
      public function set maxWidth(param1:Number) : void
      {
         if(this._explicitMaxWidth == param1)
         {
            return;
         }
         if(param1 !== param1 && this._explicitMaxWidth !== this._explicitMaxWidth)
         {
            return;
         }
         this._explicitMaxWidth = param1;
         this.dispatchEventWith(Event.RESIZE);
      }
      
      public function get explicitMinHeight() : Number
      {
         return this._explicitMinHeight;
      }
      
      public function get minHeight() : Number
      {
         if(this._explicitMinHeight === this._explicitMinHeight)
         {
            return this._explicitMinHeight;
         }
         return 0;
      }
      
      public function set minHeight(param1:Number) : void
      {
         if(this._explicitMinHeight == param1)
         {
            return;
         }
         if(param1 !== param1 && this._explicitMinHeight !== this._explicitMinHeight)
         {
            return;
         }
         this._explicitMinHeight = param1;
         this.dispatchEventWith(Event.RESIZE);
      }
      
      public function get explicitMaxHeight() : Number
      {
         return this._explicitMaxHeight;
      }
      
      public function get maxHeight() : Number
      {
         return this._explicitMaxHeight;
      }
      
      public function set maxHeight(param1:Number) : void
      {
         if(this._explicitMaxHeight == param1)
         {
            return;
         }
         if(param1 !== param1 && this._explicitMaxHeight !== this._explicitMaxHeight)
         {
            return;
         }
         this._explicitMaxHeight = param1;
         this.dispatchEventWith(Event.RESIZE);
      }
      
      public function get minTouchWidth() : Number
      {
         return this._minTouchWidth;
      }
      
      public function set minTouchWidth(param1:Number) : void
      {
         this._minTouchWidth = param1;
      }
      
      public function get minTouchHeight() : Number
      {
         return this._minTouchHeight;
      }
      
      public function set minTouchHeight(param1:Number) : void
      {
         this._minTouchHeight = param1;
      }
      
      public function getTextureForState(param1:String) : Texture
      {
         return this._stateToTexture[param1] as Texture;
      }
      
      public function setTextureForState(param1:String, param2:Texture) : void
      {
         if(param2 !== null)
         {
            this._stateToTexture[param1] = param2;
         }
         else
         {
            delete this._stateToTexture[param1];
         }
         this.updateTextureFromContext();
      }
      
      public function getColorForState(param1:String) : uint
      {
         if(param1 in this._stateToColor)
         {
            return this._stateToColor[param1] as uint;
         }
         return uint.MAX_VALUE;
      }
      
      public function setColorForState(param1:String, param2:uint) : void
      {
         if(param2 != uint.MAX_VALUE)
         {
            this._stateToColor[param1] = param2;
         }
         else
         {
            delete this._stateToColor[param1];
         }
         this.updateColorFromContext();
      }
      
      override public function readjustSize(param1:Number = -1, param2:Number = -1) : void
      {
         super.readjustSize(param1,param2);
         if(this._explicitWidth === this._explicitWidth)
         {
            super.width = this._explicitWidth;
         }
         if(this._explicitHeight === this._explicitHeight)
         {
            super.height = this._explicitHeight;
         }
      }
      
      override public function hitTest(param1:Point) : DisplayObject
      {
         var _loc2_:flash.geom.Rectangle = null;
         var _loc3_:Boolean = false;
         var _loc4_:Number = NaN;
         if(this._minTouchWidth > 0 || this._minTouchHeight > 0)
         {
            if(!this.visible || !this.touchable)
            {
               return null;
            }
            if(Boolean(this.mask) && !this.hitTestMask(param1))
            {
               return null;
            }
            _loc2_ = Pool.getRectangle();
            this.getBounds(this,_loc2_);
            if(_loc2_.width < this._minTouchWidth)
            {
               _loc4_ = this._minTouchWidth - _loc2_.width;
               _loc2_.width += _loc4_;
               _loc2_.x -= _loc4_ / 2;
            }
            if(_loc2_.height < this._minTouchHeight)
            {
               _loc4_ = this._minTouchHeight - _loc2_.height;
               _loc2_.height += _loc4_;
               _loc2_.y -= _loc4_ / 2;
            }
            _loc3_ = _loc2_.containsPoint(param1);
            Pool.putRectangle(_loc2_);
            return _loc3_ ? this : null;
         }
         return super.hitTest(param1);
      }
      
      protected function updateTextureFromContext() : void
      {
         var _loc1_:Texture = null;
         if(this._stateContext === null)
         {
            _loc1_ = this._defaultTexture;
         }
         else
         {
            _loc1_ = this._stateToTexture[this._stateContext.currentState] as Texture;
            if(_loc1_ === null && this._disabledTexture !== null && this._stateContext is IFeathersControl && !IFeathersControl(this._stateContext).isEnabled)
            {
               _loc1_ = this._disabledTexture;
            }
            if(_loc1_ === null && this._selectedTexture !== null && this._stateContext is IToggle && IToggle(this._stateContext).isSelected)
            {
               _loc1_ = this._selectedTexture;
            }
            if(_loc1_ === null)
            {
               _loc1_ = this._defaultTexture;
            }
         }
         this.texture = _loc1_;
      }
      
      protected function updateColorFromContext() : void
      {
         if(this._stateContext === null)
         {
            if(this._defaultColor != uint.MAX_VALUE)
            {
               this.$color = this._defaultColor;
            }
            return;
         }
         var _loc1_:uint = uint.MAX_VALUE;
         var _loc2_:String = this._stateContext.currentState;
         if(_loc2_ in this._stateToColor)
         {
            _loc1_ = this._stateToColor[_loc2_] as uint;
         }
         if(_loc1_ == uint.MAX_VALUE && this._disabledColor != uint.MAX_VALUE && this._stateContext is IFeathersControl && !IFeathersControl(this._stateContext).isEnabled)
         {
            _loc1_ = this._disabledColor;
         }
         if(_loc1_ == uint.MAX_VALUE && this._selectedColor != uint.MAX_VALUE && this._stateContext is IToggle && IToggle(this._stateContext).isSelected)
         {
            _loc1_ = this._selectedColor;
         }
         if(_loc1_ == uint.MAX_VALUE)
         {
            _loc1_ = this._defaultColor;
         }
         if(_loc1_ != uint.MAX_VALUE)
         {
            this.$color = _loc1_;
         }
      }
      
      protected function stateContext_stageChangeHandler(param1:Event) : void
      {
         this.updateTextureFromContext();
         this.updateColorFromContext();
      }
   }
}

