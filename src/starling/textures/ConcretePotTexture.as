package starling.textures
{
   import flash.display.BitmapData;
   import flash.display3D.textures.Texture;
   import flash.display3D.textures.TextureBase;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   import flash.utils.setTimeout;
   import starling.core.Starling;
   import starling.utils.MathUtil;
   import starling.utils.execute;
   
   internal class ConcretePotTexture extends ConcreteTexture
   {
      
      private static var sMatrix:Matrix = new Matrix();
      
      private static var sRectangle:flash.geom.Rectangle = new flash.geom.Rectangle();
      
      private static var sOrigin:Point = new Point();
      
      private static var sAsyncUploadEnabled:Boolean = false;
      
      private var _textureReadyCallback:Function;
      
      public function ConcretePotTexture(param1:flash.display3D.textures.Texture, param2:String, param3:int, param4:int, param5:Boolean, param6:Boolean, param7:Boolean = false, param8:Number = 1)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8);
         if(param3 != MathUtil.getNextPowerOfTwo(param3))
         {
            throw new ArgumentError("width must be a power of two");
         }
         if(param4 != MathUtil.getNextPowerOfTwo(param4))
         {
            throw new ArgumentError("height must be a power of two");
         }
      }
      
      internal static function get asyncUploadEnabled() : Boolean
      {
         return sAsyncUploadEnabled;
      }
      
      internal static function set asyncUploadEnabled(param1:Boolean) : void
      {
         sAsyncUploadEnabled = param1;
      }
      
      override public function dispose() : void
      {
         base.removeEventListener(Event.TEXTURE_READY,this.onTextureReady);
         super.dispose();
      }
      
      override protected function createBase() : TextureBase
      {
         return Starling.context.createTexture(nativeWidth,nativeHeight,format,optimizedForRenderTexture);
      }
      
      override public function uploadBitmapData(param1:BitmapData, param2:* = null) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:* = 0;
         var _loc8_:BitmapData = null;
         var _loc9_:flash.geom.Rectangle = null;
         var _loc10_:Matrix = null;
         var _loc3_:BitmapData = null;
         var _loc4_:Boolean = param2 is Function || param2 === true;
         if(param2 is Function)
         {
            this._textureReadyCallback = param2 as Function;
         }
         if(param1.width != nativeWidth || param1.height != nativeHeight)
         {
            _loc3_ = new BitmapData(nativeWidth,nativeHeight,true,0);
            _loc3_.copyPixels(param1,param1.rect,sOrigin);
            param1 = _loc3_;
         }
         this.upload(param1,0,_loc4_);
         if(mipMapping && param1.width > 1 && param1.height > 1)
         {
            _loc5_ = param1.width >> 1;
            _loc6_ = param1.height >> 1;
            _loc7_ = 1;
            _loc8_ = new BitmapData(_loc5_,_loc6_,true,0);
            _loc9_ = sRectangle;
            _loc10_ = sMatrix;
            _loc10_.setTo(0.5,0,0,0.5,0,0);
            while(_loc5_ >= 1 || _loc6_ >= 1)
            {
               _loc9_.setTo(0,0,_loc5_,_loc6_);
               _loc8_.fillRect(_loc9_,0);
               _loc8_.draw(param1,_loc10_,null,null,null,true);
               this.upload(_loc8_,_loc7_++,false);
               _loc10_.scale(0.5,0.5);
               _loc5_ >>= 1;
               _loc6_ >>= 1;
            }
            _loc8_.dispose();
         }
         if(_loc3_)
         {
            _loc3_.dispose();
         }
         setDataUploaded();
      }
      
      override public function get isPotTexture() : Boolean
      {
         return true;
      }
      
      override public function uploadAtfData(param1:ByteArray, param2:int = 0, param3:* = null) : void
      {
         var _loc4_:Boolean = param3 is Function || param3 === true;
         if(param3 is Function)
         {
            this._textureReadyCallback = param3 as Function;
            base.addEventListener(Event.TEXTURE_READY,this.onTextureReady);
         }
         this.potBase.uploadCompressedTextureFromByteArray(param1,param2,_loc4_);
         setDataUploaded();
      }
      
      private function upload(param1:BitmapData, param2:uint, param3:Boolean) : void
      {
         if(param3)
         {
            this.uploadAsync(param1,param2);
            base.addEventListener(Event.TEXTURE_READY,this.onTextureReady);
            base.addEventListener(ErrorEvent.ERROR,this.onTextureReady);
         }
         else
         {
            this.potBase.uploadFromBitmapData(param1,param2);
         }
      }
      
      private function uploadAsync(param1:BitmapData, param2:uint) : void
      {
         var source:BitmapData = param1;
         var mipLevel:uint = param2;
         if(sAsyncUploadEnabled)
         {
            try
            {
               base["uploadFromBitmapDataAsync"](source,mipLevel);
            }
            catch(error:Error)
            {
               if(!(error.errorID == 3708 || error.errorID == 1069))
               {
                  throw error;
               }
               sAsyncUploadEnabled = false;
            }
         }
         if(!sAsyncUploadEnabled)
         {
            setTimeout(base.dispatchEvent,1,new Event(Event.TEXTURE_READY));
            this.potBase.uploadFromBitmapData(source);
         }
      }
      
      private function onTextureReady(param1:Event) : void
      {
         base.removeEventListener(Event.TEXTURE_READY,this.onTextureReady);
         base.removeEventListener(ErrorEvent.ERROR,this.onTextureReady);
         execute(this._textureReadyCallback,this,param1 as ErrorEvent);
         this._textureReadyCallback = null;
      }
      
      private function get potBase() : flash.display3D.textures.Texture
      {
         return base as flash.display3D.textures.Texture;
      }
   }
}

