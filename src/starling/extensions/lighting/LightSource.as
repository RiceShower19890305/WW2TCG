package starling.extensions.lighting
{
   import flash.display3D.Context3DTextureFormat;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.display.Sprite3D;
   import starling.display.Stage;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.textures.Texture;
   
   public class LightSource extends Sprite3D
   {
      
      private static const LightBulbAtlas:Class = LightSource_LightBulbAtlas;
      
      private static const ATLAS_TEXTURE_DATA_NAME:String = "starling.extensions.lighting.LightSource.atlasTexture";
      
      public static const TYPE_POINT:String = "point";
      
      public static const TYPE_AMBIENT:String = "ambient";
      
      public static const TYPE_DIRECTIONAL:String = "directional";
      
      private static var sMovement:Point = new Point();
      
      private static var sInstances:Dictionary = new Dictionary();
      
      private static var sRegion:flash.geom.Rectangle = new flash.geom.Rectangle();
      
      private var _type:String;
      
      private var _color:uint;
      
      private var _active:Boolean;
      
      private var _brightness:Number;
      
      private var _lightBulb:Image;
      
      public function LightSource(param1:String = "point", param2:uint = 16777215, param3:Number = 1)
      {
         super();
         this._type = param1;
         this._color = param2;
         this._active = true;
         this._brightness = param3;
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private static function getBulbTexture(param1:String) : Texture
      {
         var _loc2_:Texture = Starling.painter.sharedData[ATLAS_TEXTURE_DATA_NAME];
         if(_loc2_ == null)
         {
            _loc2_ = Texture.fromEmbeddedAsset(LightBulbAtlas,false,false,2,Context3DTextureFormat.BGRA_PACKED);
            Starling.painter.sharedData[ATLAS_TEXTURE_DATA_NAME] = _loc2_;
         }
         sRegion.x = sRegion.y = 0;
         sRegion.width = _loc2_.width / 3;
         sRegion.height = _loc2_.height;
         if(param1 == TYPE_AMBIENT)
         {
            sRegion.x = sRegion.width;
         }
         else if(param1 == TYPE_DIRECTIONAL)
         {
            sRegion.x = sRegion.width * 2;
         }
         return Texture.fromTexture(_loc2_,sRegion);
      }
      
      internal static function getActiveInstances(param1:Stage, param2:Vector.<LightSource> = null) : Vector.<LightSource>
      {
         var _loc4_:int = 0;
         var _loc5_:LightSource = null;
         if(param2 == null)
         {
            param2 = new Vector.<LightSource>(0);
         }
         else
         {
            param2.length = 0;
         }
         var _loc3_:Vector.<LightSource> = sInstances[param1];
         if(_loc3_)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc5_ = _loc3_[_loc4_];
               if(_loc5_._brightness > 0 && _loc5_._active)
               {
                  param2[param2.length] = _loc5_;
               }
               _loc4_++;
            }
         }
         return param2;
      }
      
      public static function createPointLight(param1:uint = 16777215, param2:Number = 1) : LightSource
      {
         return new LightSource(TYPE_POINT,param1,param2);
      }
      
      public static function createAmbientLight(param1:uint = 16777215, param2:Number = 1) : LightSource
      {
         return new LightSource(TYPE_AMBIENT,param1,param2);
      }
      
      public static function createDirectionalLight(param1:uint = 16777215, param2:Number = 1) : LightSource
      {
         return new LightSource(TYPE_DIRECTIONAL,param1,param2);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         var _loc2_:Stage = this.stage;
         var _loc3_:Vector.<LightSource> = sInstances[_loc2_];
         if(_loc3_ == null)
         {
            _loc3_ = new <LightSource>[this];
            sInstances[_loc2_] = _loc3_;
         }
         else if(_loc3_.indexOf(this) == -1)
         {
            _loc3_[_loc3_.length] = this;
         }
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         var _loc2_:Stage = this.stage;
         var _loc3_:Vector.<LightSource> = sInstances[_loc2_];
         var _loc4_:int = _loc3_ ? int(_loc3_.indexOf(this)) : -1;
         if(_loc4_ != -1)
         {
            _loc3_.removeAt(_loc4_);
         }
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this,TouchPhase.MOVED);
         if(_loc2_)
         {
            _loc2_.getMovement(parent,sMovement);
            if(param1.shiftKey)
            {
               this.z += sMovement.y;
               this.rotation += sMovement.x * 0.02;
            }
            else
            {
               this.x += sMovement.x;
               this.y += sMovement.y;
            }
         }
         _loc2_ = param1.getTouch(this,TouchPhase.ENDED);
         if(Boolean(_loc2_) && _loc2_.tapCount == 2)
         {
            this.isActive = !this._active;
         }
      }
      
      public function get color() : uint
      {
         return this._color;
      }
      
      public function set color(param1:uint) : void
      {
         if(this._color != param1)
         {
            this._color = param1;
            setRequiresRedraw();
            if(Boolean(this._lightBulb) && this._brightness > 0)
            {
               this._lightBulb.color = this._color;
            }
         }
      }
      
      public function get brightness() : Number
      {
         return this._brightness;
      }
      
      public function set brightness(param1:Number) : void
      {
         if(this._brightness != param1)
         {
            this._brightness = param1;
            setRequiresRedraw();
            if(this._lightBulb)
            {
               if(param1 == 0)
               {
                  this._lightBulb.color = 0;
                  this._lightBulb.alpha = 1;
               }
               else
               {
                  this._lightBulb.color = this._color;
                  this._lightBulb.alpha = 0.2 + 0.8 * param1;
               }
            }
         }
      }
      
      public function get showLightBulb() : Boolean
      {
         return this._lightBulb ? this._lightBulb.visible : false;
      }
      
      public function set showLightBulb(param1:Boolean) : void
      {
         if(param1 == this.showLightBulb)
         {
            return;
         }
         if(this._lightBulb == null)
         {
            this._lightBulb = new Image(getBulbTexture(this._type));
            this._lightBulb.alignPivot();
            this._lightBulb.color = this._color;
            this._lightBulb.alpha = this._brightness;
            this._lightBulb.useHandCursor = true;
            addChild(this._lightBulb);
            addEventListener(TouchEvent.TOUCH,this.onTouch);
         }
         this._lightBulb.visible = param1;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function set type(param1:String) : void
      {
         if(this._type != param1)
         {
            this._type = param1;
            if(this._lightBulb)
            {
               this._lightBulb.texture = getBulbTexture(param1);
            }
            setRequiresRedraw();
         }
      }
      
      public function get isActive() : Boolean
      {
         return this._active;
      }
      
      public function set isActive(param1:Boolean) : void
      {
         if(this._active != param1)
         {
            this._active = param1;
            if(this._lightBulb)
            {
               this._lightBulb.color = param1 ? this._color : 0;
            }
            setRequiresRedraw();
         }
      }
   }
}

