package starling.display
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import starling.styles.MeshStyle;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import starling.textures.Texture;
   import starling.utils.ButtonBehavior;
   import starling.utils.SystemUtil;
   
   public class Button extends DisplayObjectContainer
   {
      
      protected var _upState:Texture;
      
      protected var _downState:Texture;
      
      protected var _overState:Texture;
      
      protected var _disabledState:Texture;
      
      protected var _contents:Sprite;
      
      protected var _body:Image;
      
      protected var _textField:TextField;
      
      protected var _textBounds:Rectangle;
      
      protected var _overlay:Sprite;
      
      private var _behavior:ButtonBehavior;
      
      private var _scaleWhenDown:Number;
      
      private var _scaleWhenOver:Number;
      
      private var _alphaWhenDown:Number;
      
      private var _alphaWhenDisabled:Number;
      
      public function Button(param1:Texture, param2:String = "", param3:Texture = null, param4:Texture = null, param5:Texture = null)
      {
         super();
         if(param1 == null)
         {
            throw new ArgumentError("Texture \'upState\' cannot be null");
         }
         this._upState = param1;
         this._downState = param3;
         this._overState = param4;
         this._disabledState = param5;
         this._behavior = new ButtonBehavior(this,this.onStateChange,SystemUtil.isDesktop ? 16 : 44);
         this._body = new Image(param1);
         this._body.pixelSnapping = true;
         this._scaleWhenDown = param3 ? 1 : 0.9;
         this._scaleWhenOver = this._alphaWhenDown = 1;
         this._alphaWhenDisabled = param5 ? 1 : 0.5;
         this._textBounds = new Rectangle(0,0,this._body.width,this._body.height);
         this._contents = new Sprite();
         this._contents.addChild(this._body);
         addChild(this._contents);
         this.setStateTexture(param1);
         this.touchGroup = true;
         this.text = param2;
      }
      
      override public function dispose() : void
      {
         if(this._textField)
         {
            this._textField.dispose();
         }
         super.dispose();
      }
      
      private function onStateChange(param1:String) : void
      {
         this._contents.x = this._contents.y = 0;
         this._contents.scaleX = this._contents.scaleY = this._contents.alpha = 1;
         switch(param1)
         {
            case ButtonState.DOWN:
               this.setStateTexture(this._downState);
               this.setContentScale(this._scaleWhenDown);
               this._contents.alpha = this._alphaWhenDown;
               break;
            case ButtonState.UP:
               this.setStateTexture(this._upState);
               break;
            case ButtonState.OVER:
               this.setStateTexture(this._overState);
               this.setContentScale(this._scaleWhenOver);
               break;
            case ButtonState.DISABLED:
               this.setStateTexture(this._disabledState);
               this._contents.alpha = this._alphaWhenDisabled;
         }
      }
      
      override public function hitTest(param1:Point) : DisplayObject
      {
         return this._behavior.hitTest(param1);
      }
      
      public function readjustSize() : void
      {
         var _loc1_:Number = this._body.width;
         var _loc2_:Number = this._body.height;
         this._body.readjustSize();
         var _loc3_:Number = this._body.width / _loc1_;
         var _loc4_:Number = this._body.height / _loc2_;
         this._textBounds.x *= _loc3_;
         this._textBounds.y *= _loc4_;
         this._textBounds.width *= _loc3_;
         this._textBounds.height *= _loc4_;
         if(this._textField)
         {
            this.createTextField();
         }
      }
      
      private function createTextField() : void
      {
         if(this._textField == null)
         {
            this._textField = new TextField(this._textBounds.width,this._textBounds.height);
            this._textField.pixelSnapping = this._body.pixelSnapping;
            this._textField.touchable = false;
            this._textField.autoScale = true;
            this._textField.batchable = true;
         }
         this._textField.width = this._textBounds.width;
         this._textField.height = this._textBounds.height;
         this._textField.x = this._textBounds.x;
         this._textField.y = this._textBounds.y;
      }
      
      public function get state() : String
      {
         return this._behavior.state;
      }
      
      public function set state(param1:String) : void
      {
         this._behavior.state = param1;
      }
      
      private function setContentScale(param1:Number) : void
      {
         this._contents.scaleX = this._contents.scaleY = param1;
         this._contents.x = (1 - param1) / 2 * this._body.width;
         this._contents.y = (1 - param1) / 2 * this._body.height;
      }
      
      private function setStateTexture(param1:Texture) : void
      {
         this._body.texture = param1 ? param1 : this._upState;
         if(Boolean(this._body.pivotX) || Boolean(this._body.pivotY))
         {
            pivotX = this._body.pivotX;
            pivotY = this._body.pivotY;
            this._body.pivotX = 0;
            this._body.pivotY = 0;
         }
      }
      
      public function get scaleWhenDown() : Number
      {
         return this._scaleWhenDown;
      }
      
      public function set scaleWhenDown(param1:Number) : void
      {
         this._scaleWhenDown = param1;
      }
      
      public function get scaleWhenOver() : Number
      {
         return this._scaleWhenOver;
      }
      
      public function set scaleWhenOver(param1:Number) : void
      {
         this._scaleWhenOver = param1;
      }
      
      public function get alphaWhenDown() : Number
      {
         return this._alphaWhenDown;
      }
      
      public function set alphaWhenDown(param1:Number) : void
      {
         this._alphaWhenDown = param1;
      }
      
      public function get alphaWhenDisabled() : Number
      {
         return this._alphaWhenDisabled;
      }
      
      public function set alphaWhenDisabled(param1:Number) : void
      {
         this._alphaWhenDisabled = param1;
      }
      
      public function get enabled() : Boolean
      {
         return this._behavior.enabled;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         this._behavior.enabled = param1;
      }
      
      public function get text() : String
      {
         return this._textField ? this._textField.text : "";
      }
      
      public function set text(param1:String) : void
      {
         if(param1.length == 0)
         {
            if(this._textField)
            {
               this._textField.text = param1;
               this._textField.removeFromParent();
            }
         }
         else
         {
            this.createTextField();
            this._textField.text = param1;
            if(this._textField.parent == null)
            {
               this._contents.addChild(this._textField);
            }
         }
      }
      
      public function get textFormat() : TextFormat
      {
         if(this._textField == null)
         {
            this.createTextField();
         }
         return this._textField.format;
      }
      
      public function set textFormat(param1:TextFormat) : void
      {
         if(this._textField == null)
         {
            this.createTextField();
         }
         this._textField.format = param1;
      }
      
      public function get textStyle() : MeshStyle
      {
         if(this._textField == null)
         {
            this.createTextField();
         }
         return this._textField.style;
      }
      
      public function set textStyle(param1:MeshStyle) : void
      {
         if(this._textField == null)
         {
            this.createTextField();
         }
         this._textField.style = param1;
      }
      
      public function get style() : MeshStyle
      {
         return this._body.style;
      }
      
      public function set style(param1:MeshStyle) : void
      {
         this._body.style = param1;
      }
      
      public function get upState() : Texture
      {
         return this._upState;
      }
      
      public function set upState(param1:Texture) : void
      {
         var _loc2_:String = null;
         if(param1 == null)
         {
            throw new ArgumentError("Texture \'upState\' cannot be null");
         }
         if(this._upState != param1)
         {
            this._upState = param1;
            _loc2_ = this._behavior.state;
            if(_loc2_ == ButtonState.UP || _loc2_ == ButtonState.DISABLED && this._disabledState == null || _loc2_ == ButtonState.DOWN && this._downState == null || _loc2_ == ButtonState.OVER && this._overState == null)
            {
               this.setStateTexture(param1);
            }
         }
      }
      
      public function get downState() : Texture
      {
         return this._downState;
      }
      
      public function set downState(param1:Texture) : void
      {
         if(this._downState != param1)
         {
            this._downState = param1;
            if(this.state == ButtonState.DOWN)
            {
               this.setStateTexture(param1);
            }
         }
      }
      
      public function get overState() : Texture
      {
         return this._overState;
      }
      
      public function set overState(param1:Texture) : void
      {
         if(this._overState != param1)
         {
            this._overState = param1;
            if(this.state == ButtonState.OVER)
            {
               this.setStateTexture(param1);
            }
         }
      }
      
      public function get disabledState() : Texture
      {
         return this._disabledState;
      }
      
      public function set disabledState(param1:Texture) : void
      {
         if(this._disabledState != param1)
         {
            this._disabledState = param1;
            if(this.state == ButtonState.DISABLED)
            {
               this.setStateTexture(param1);
            }
         }
      }
      
      public function get textBounds() : Rectangle
      {
         return this._textBounds;
      }
      
      public function set textBounds(param1:Rectangle) : void
      {
         this._textBounds.copyFrom(param1);
         this.createTextField();
      }
      
      public function get color() : uint
      {
         return this._body.color;
      }
      
      public function set color(param1:uint) : void
      {
         this._body.color = param1;
      }
      
      public function get textureSmoothing() : String
      {
         return this._body.textureSmoothing;
      }
      
      public function set textureSmoothing(param1:String) : void
      {
         this._body.textureSmoothing = param1;
      }
      
      public function get overlay() : Sprite
      {
         if(this._overlay == null)
         {
            this._overlay = new Sprite();
         }
         this._contents.addChild(this._overlay);
         return this._overlay;
      }
      
      override public function get useHandCursor() : Boolean
      {
         return this._behavior.useHandCursor;
      }
      
      override public function set useHandCursor(param1:Boolean) : void
      {
         this._behavior.useHandCursor = param1;
      }
      
      public function get pixelSnapping() : Boolean
      {
         return this._body.pixelSnapping;
      }
      
      public function set pixelSnapping(param1:Boolean) : void
      {
         this._body.pixelSnapping = param1;
         if(this._textField)
         {
            this._textField.pixelSnapping = param1;
         }
      }
      
      override public function set width(param1:Number) : void
      {
         var _loc2_:Number = param1 / (this.scaleX || 1);
         var _loc3_:Number = _loc2_ / (this._body.width || 1);
         this._body.width = _loc2_;
         this._textBounds.x *= _loc3_;
         this._textBounds.width *= _loc3_;
         if(this._textField)
         {
            this._textField.width = _loc2_;
         }
      }
      
      override public function set height(param1:Number) : void
      {
         var _loc2_:Number = param1 / (this.scaleY || 1);
         var _loc3_:Number = _loc2_ / (this._body.height || 1);
         this._body.height = _loc2_;
         this._textBounds.y *= _loc3_;
         this._textBounds.height *= _loc3_;
         if(this._textField)
         {
            this._textField.height = _loc2_;
         }
      }
      
      public function get scale9Grid() : Rectangle
      {
         return this._body.scale9Grid;
      }
      
      public function set scale9Grid(param1:Rectangle) : void
      {
         this._body.scale9Grid = param1;
      }
      
      public function get minHitAreaSize() : Number
      {
         return this._behavior.minHitAreaSize;
      }
      
      public function set minHitAreaSize(param1:Number) : void
      {
         this._behavior.minHitAreaSize = param1;
      }
      
      public function get abortDistance() : Number
      {
         return this._behavior.abortDistance;
      }
      
      public function set abortDistance(param1:Number) : void
      {
         this._behavior.abortDistance = param1;
      }
   }
}

