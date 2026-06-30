package com.fs.tcgengine.resources
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.Utils;
   import flash.media.Sound;
   import flash.utils.getQualifiedClassName;
   import starling.textures.Texture;
   import starling.textures.TextureAtlas;
   import starling.textures.TextureOptions;
   import starling.utils.AssetManager;
   
   public class FSAssetManager extends AssetManager
   {
      
      public function FSAssetManager(param1:Number = -1, param2:Boolean = false)
      {
         super(param1,param2);
      }
      
      public function removeAssetsFromFolder(... rest) : void
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         for each(_loc2_ in rest)
         {
            if(getQualifiedClassName(_loc2_) == "flash.filesystem::File")
            {
               if(!_loc2_["exists"])
               {
                  log("File or directory not found: \'" + _loc2_["url"] + "\'");
               }
               else if(!_loc2_["isHidden"])
               {
                  if(_loc2_["isDirectory"])
                  {
                     this.removeAssetsFromFolder.apply(this,_loc2_["getDirectoryListing"]());
                  }
                  else
                  {
                     _loc3_ = _loc2_["extension"].toLowerCase();
                     this.removeWithName(_loc2_["url"]);
                  }
               }
            }
            else if(_loc2_ is String)
            {
               this.removeWithName(_loc2_);
            }
            else
            {
               log("Ignoring unsupported asset type: " + getQualifiedClassName(_loc2_));
            }
         }
      }
      
      public function removeDefinitions(... rest) : void
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         for each(_loc2_ in rest)
         {
            if(getQualifiedClassName(_loc2_) == "flash.filesystem::File")
            {
               if(!_loc2_["exists"])
               {
                  log("File or directory not found: \'" + _loc2_["url"] + "\'");
               }
               else if(!_loc2_["isHidden"])
               {
                  if(_loc2_["isDirectory"])
                  {
                     this.removeDefinitions.apply(this,_loc2_["getDirectoryListing"]());
                  }
                  else
                  {
                     _loc3_ = _loc2_["extension"].toLowerCase();
                     removeXml(getName(_loc2_["url"]));
                  }
               }
            }
         }
      }
      
      public function removeWithName(param1:Object, param2:String = null) : String
      {
         if(param2 == null)
         {
            param2 = getName(param1);
         }
         FSDebug.debugTrace("Autoremove from folder: " + param2);
         var _loc3_:String = String(param1).substring(String(param1).lastIndexOf(".") + 1);
         var _loc4_:Boolean = _loc3_.toLowerCase() == "mp3";
         if(_loc4_)
         {
            this.removeSound(param2);
            return param2;
         }
         var _loc5_:Boolean = _loc3_.toLowerCase() == "xml";
         if(!_loc5_)
         {
            this.removeTexture(param2,true);
         }
         else
         {
            removeTextureAtlas(param2,true);
         }
         return param2;
      }
      
      override protected function loadRawAsset(param1:Object, param2:Function, param3:Function) : void
      {
         var _loc4_:String = null;
         if(Utils.isBrowser() && param1 is String)
         {
            _loc4_ = "?v=" + Utils.getAppVersion();
            super.loadRawAsset(param1 + _loc4_,param2,param3);
         }
         else
         {
            super.loadRawAsset(param1,param2,param3);
         }
      }
      
      override public function removeTexture(param1:String, param2:Boolean = true) : void
      {
         if(param1 != "")
         {
            super.removeTexture(param1,param2);
         }
      }
      
      override public function addTexture(param1:String, param2:Texture) : void
      {
         if(getTexture(param1) == null)
         {
            super.addTexture(param1,param2);
         }
         else
         {
            FSDebug.debugTrace("Skipping \'addTexture\' since it\'s already on memory: " + param1);
         }
      }
      
      override public function addTextureAtlas(param1:String, param2:TextureAtlas) : void
      {
         if(getTextureAtlas(param1) == null)
         {
            super.addTextureAtlas(param1,param2);
         }
         else
         {
            FSDebug.debugTrace("Skipping \'addTextureAtlas\' since it\'s already on memory: " + param1);
         }
      }
      
      override public function addSound(param1:String, param2:Sound) : void
      {
         if(getSound(param1) == null)
         {
            super.addSound(param1,param2);
         }
         else
         {
            FSDebug.debugTrace("Skipping \'addSound\' since it\'s already on memory: " + param1);
            param2 = null;
         }
      }
      
      public function getTexturesLength() : int
      {
         return _textures ? DictionaryUtils.getDictionaryLength(_textures) : 0;
      }
      
      public function getSoundsLength() : int
      {
         return _sounds ? DictionaryUtils.getDictionaryLength(_sounds) : 0;
      }
      
      public function getTexturesNames() : Array
      {
         return _textures ? DictionaryUtils.getKeys(_textures) : null;
      }
      
      public function getSoundsNames() : Array
      {
         return _sounds ? DictionaryUtils.getKeys(_sounds) : null;
      }
      
      public function getTextureNameByTexture(param1:Texture) : String
      {
         var _loc3_:Array = null;
         var _loc4_:Texture = null;
         var _loc5_:int = 0;
         var _loc6_:Vector.<Texture> = null;
         var _loc7_:Vector.<String> = null;
         var _loc8_:TextureAtlas = null;
         var _loc2_:String = "";
         if(_textures)
         {
            _loc3_ = DictionaryUtils.getKeys(_textures);
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length)
            {
               if(_textures[_loc3_[_loc5_]] == param1)
               {
                  return _loc3_[_loc5_];
               }
               _loc5_++;
            }
         }
         for each(_loc8_ in _atlases)
         {
            _loc6_ = _loc8_.getTextures();
            _loc7_ = _loc8_.getNames();
            _loc5_ = 0;
            while(_loc5_ < _loc7_.length)
            {
               if(_loc8_.getTexture(_loc7_[_loc5_]) == param1)
               {
                  return _loc7_[_loc5_];
               }
               _loc5_++;
            }
         }
         return _loc2_;
      }
      
      override public function removeSound(param1:String) : void
      {
         super.removeSound(param1);
         if(Utils.isAndroid() && Config.STORE_AUDIO_PATHS)
         {
            InstanceMng.getResourcesMng().unloadAndroidSound(param1);
         }
      }
      
      override public function enqueueWithName(param1:Object, param2:String = null, param3:TextureOptions = null) : String
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         if(Utils.isAndroid() && Config.STORE_AUDIO_PATHS)
         {
            _loc4_ = "/audio";
            _loc5_ = param1.hasOwnProperty("url") ? String(param1.url) : "";
            if(_loc5_ != "" && String(_loc5_).indexOf(".mp3") != -1)
            {
               _loc6_ = _loc5_.indexOf("/soundtrack/") != -1;
               if(!_loc6_)
               {
                  _loc7_ = _loc5_.indexOf(_loc4_);
                  if(_loc7_ != -1)
                  {
                     InstanceMng.getResourcesMng().addAudioRef(getName(param1),String(param1.url).substring(_loc7_),param1);
                     return param2;
                  }
               }
            }
         }
         return super.enqueueWithName(param1,param2,param3);
      }
   }
}

