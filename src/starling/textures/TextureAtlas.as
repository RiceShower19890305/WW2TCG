package starling.textures
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import starling.display.Image;
   import starling.utils.StringUtil;
   
   public class TextureAtlas
   {
      
      private static const NAME_REGEX:RegExp = /(.+?)\d+$/;
      
      private static var sNames:Vector.<String> = new Vector.<String>(0);
      
      private var _atlasTexture:Texture;
      
      private var _subTextures:Dictionary;
      
      private var _subTextureNames:Vector.<String>;
      
      public function TextureAtlas(param1:Texture, param2:* = null)
      {
         super();
         this._subTextures = new Dictionary();
         this._atlasTexture = param1;
         if(param2)
         {
            this.parseAtlasData(param2);
         }
      }
      
      public function dispose() : void
      {
         this._atlasTexture.dispose();
      }
      
      protected function parseAtlasData(param1:*) : void
      {
         if(param1 is XML)
         {
            this.parseAtlasXml(param1 as XML);
            return;
         }
         throw new ArgumentError("TextureAtlas only supports XML data");
      }
      
      protected function parseAtlasXml(param1:XML) : void
      {
         var _loc6_:XML = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Boolean = false;
         var _loc20_:Array = null;
         var _loc21_:String = null;
         var _loc22_:Point = null;
         var _loc2_:Number = this._atlasTexture.scale;
         var _loc3_:flash.geom.Rectangle = new flash.geom.Rectangle();
         var _loc4_:flash.geom.Rectangle = new flash.geom.Rectangle();
         var _loc5_:Dictionary = new Dictionary();
         for each(_loc6_ in param1.SubTexture)
         {
            _loc8_ = StringUtil.clean(_loc6_.@name);
            _loc9_ = Number(parseFloat(_loc6_.@x) / _loc2_ || 0);
            _loc10_ = Number(parseFloat(_loc6_.@y) / _loc2_ || 0);
            _loc11_ = Number(parseFloat(_loc6_.@width) / _loc2_ || 0);
            _loc12_ = Number(parseFloat(_loc6_.@height) / _loc2_ || 0);
            _loc13_ = Number(parseFloat(_loc6_.@frameX) / _loc2_ || 0);
            _loc14_ = Number(parseFloat(_loc6_.@frameY) / _loc2_ || 0);
            _loc15_ = Number(parseFloat(_loc6_.@frameWidth) / _loc2_ || 0);
            _loc16_ = Number(parseFloat(_loc6_.@frameHeight) / _loc2_ || 0);
            _loc17_ = Number(parseFloat(_loc6_.@pivotX) / _loc2_ || 0);
            _loc18_ = Number(parseFloat(_loc6_.@pivotY) / _loc2_ || 0);
            _loc19_ = StringUtil.parseBoolean(_loc6_.@rotated);
            _loc3_.setTo(_loc9_,_loc10_,_loc11_,_loc12_);
            _loc4_.setTo(_loc13_,_loc14_,_loc15_,_loc16_);
            if(_loc15_ > 0 && _loc16_ > 0)
            {
               this.addRegion(_loc8_,_loc3_,_loc4_,_loc19_);
            }
            else
            {
               this.addRegion(_loc8_,_loc3_,null,_loc19_);
            }
            if(_loc17_ != 0 || _loc18_ != 0)
            {
               Image.bindPivotPointToTexture(this.getTexture(_loc8_),_loc17_,_loc18_);
               _loc5_[_loc8_] = new Point(_loc17_,_loc18_);
            }
         }
         for(_loc7_ in _loc5_)
         {
            _loc20_ = _loc7_.match(NAME_REGEX);
            if((Boolean(_loc20_)) && _loc20_.length > 0)
            {
               _loc21_ = _loc20_[1];
               _loc22_ = _loc5_[_loc7_];
               for(_loc8_ in this._subTextures)
               {
                  if(_loc8_.indexOf(_loc21_) == 0 && !(_loc8_ in _loc5_))
                  {
                     Image.bindPivotPointToTexture(this._subTextures[_loc8_],_loc22_.x,_loc22_.y);
                  }
               }
            }
         }
      }
      
      public function getTexture(param1:String) : Texture
      {
         return this._subTextures[param1];
      }
      
      public function getTextures(param1:String = "", param2:Vector.<Texture> = null) : Vector.<Texture>
      {
         var _loc3_:String = null;
         if(param2 == null)
         {
            param2 = new Vector.<Texture>(0);
         }
         for each(_loc3_ in this.getNames(param1,sNames))
         {
            param2[param2.length] = this.getTexture(_loc3_);
         }
         sNames.length = 0;
         return param2;
      }
      
      public function getNames(param1:String = "", param2:Vector.<String> = null) : Vector.<String>
      {
         var _loc3_:String = null;
         if(param2 == null)
         {
            param2 = new Vector.<String>(0);
         }
         if(this._subTextureNames == null)
         {
            this._subTextureNames = new Vector.<String>(0);
            for(_loc3_ in this._subTextures)
            {
               this._subTextureNames[this._subTextureNames.length] = _loc3_;
            }
            this._subTextureNames.sort(Array.CASEINSENSITIVE);
         }
         for each(_loc3_ in this._subTextureNames)
         {
            if(_loc3_.indexOf(param1) == 0)
            {
               param2[param2.length] = _loc3_;
            }
         }
         return param2;
      }
      
      public function getRegion(param1:String) : flash.geom.Rectangle
      {
         var _loc2_:SubTexture = this._subTextures[param1];
         return _loc2_ ? _loc2_.region : null;
      }
      
      public function getFrame(param1:String) : flash.geom.Rectangle
      {
         var _loc2_:SubTexture = this._subTextures[param1];
         return _loc2_ ? _loc2_.frame : null;
      }
      
      public function getRotation(param1:String) : Boolean
      {
         var _loc2_:SubTexture = this._subTextures[param1];
         return _loc2_ ? _loc2_.rotated : false;
      }
      
      public function addRegion(param1:String, param2:flash.geom.Rectangle, param3:flash.geom.Rectangle = null, param4:Boolean = false) : void
      {
         this.addSubTexture(param1,new SubTexture(this._atlasTexture,param2,false,param3,param4));
      }
      
      public function addSubTexture(param1:String, param2:SubTexture) : void
      {
         if(param2.root != this._atlasTexture.root)
         {
            throw new ArgumentError("SubTexture\'s root must be atlas texture.");
         }
         this._subTextures[param1] = param2;
         this._subTextureNames = null;
      }
      
      public function removeRegion(param1:String) : void
      {
         var _loc2_:SubTexture = this._subTextures[param1];
         if(_loc2_)
         {
            _loc2_.dispose();
         }
         delete this._subTextures[param1];
         this._subTextureNames = null;
      }
      
      public function removeRegions(param1:String = "") : void
      {
         var _loc2_:String = null;
         for(_loc2_ in this._subTextures)
         {
            if(param1 == "" || _loc2_.indexOf(param1) == 0)
            {
               this.removeRegion(_loc2_);
            }
         }
      }
      
      public function get texture() : Texture
      {
         return this._atlasTexture;
      }
   }
}

