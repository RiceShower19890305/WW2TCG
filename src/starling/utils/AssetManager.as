package starling.utils
{
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.net.FileReference;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.system.ImageDecodingPolicy;
   import flash.system.LoaderContext;
   import flash.system.System;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   import starling.core.Starling;
   import starling.events.Event;
   import starling.events.EventDispatcher;
   import starling.text.BitmapFont;
   import starling.text.TextField;
   import starling.textures.AtfData;
   import starling.textures.Texture;
   import starling.textures.TextureAtlas;
   import starling.textures.TextureOptions;
   
   public class AssetManager extends EventDispatcher
   {
      
      private static const HTTP_RESPONSE_STATUS:String = "httpResponseStatus";
      
      private static var sNames:Vector.<String> = new Vector.<String>(0);
      
      private static const NAME_REGEX:RegExp = /([^\?\/\\]+?)(?:\.([\w\-]+))?(?:\?.*)?$/;
      
      private var _starling:Starling;
      
      private var _numLostTextures:int;
      
      private var _numRestoredTextures:int;
      
      private var _numLoadingQueues:int;
      
      private var _defaultTextureOptions:TextureOptions;
      
      private var _registerBitmapFontsWithFontFace:Boolean;
      
      private var _checkPolicyFile:Boolean;
      
      private var _keepAtlasXmls:Boolean;
      
      private var _keepFontXmls:Boolean;
      
      private var _numConnections:int;
      
      private var _verbose:Boolean;
      
      private var _queue:Array;
      
      protected var _textures:Dictionary;
      
      protected var _atlases:Dictionary;
      
      protected var _sounds:Dictionary;
      
      protected var _xmls:Dictionary;
      
      protected var _objects:Dictionary;
      
      protected var _byteArrays:Dictionary;
      
      protected var _bitmapFonts:Dictionary;
      
      public function AssetManager(param1:Number = 1, param2:Boolean = false)
      {
         super();
         this._defaultTextureOptions = new TextureOptions(param1,param2);
         this._textures = new Dictionary();
         this._atlases = new Dictionary();
         this._sounds = new Dictionary();
         this._xmls = new Dictionary();
         this._objects = new Dictionary();
         this._byteArrays = new Dictionary();
         this._bitmapFonts = new Dictionary();
         this._numConnections = 3;
         this._verbose = true;
         this._queue = [];
      }
      
      public function dispose() : void
      {
         var _loc1_:Texture = null;
         var _loc2_:TextureAtlas = null;
         var _loc3_:XML = null;
         var _loc4_:ByteArray = null;
         var _loc5_:BitmapFont = null;
         for each(_loc1_ in this._textures)
         {
            _loc1_.dispose();
         }
         for each(_loc2_ in this._atlases)
         {
            _loc2_.dispose();
         }
         for each(_loc3_ in this._xmls)
         {
            System.disposeXML(_loc3_);
         }
         for each(_loc4_ in this._byteArrays)
         {
            _loc4_.clear();
         }
         for each(_loc5_ in this._bitmapFonts)
         {
            _loc5_.dispose();
         }
      }
      
      public function getTexture(param1:String) : Texture
      {
         var _loc2_:TextureAtlas = null;
         var _loc3_:Texture = null;
         if(param1 in this._textures)
         {
            return this._textures[param1];
         }
         for each(_loc2_ in this._atlases)
         {
            _loc3_ = _loc2_.getTexture(param1);
            if(_loc3_)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public function getTextures(param1:String = "", param2:Vector.<Texture> = null) : Vector.<Texture>
      {
         var _loc3_:String = null;
         if(param2 == null)
         {
            param2 = new Vector.<Texture>(0);
         }
         for each(_loc3_ in this.getTextureNames(param1,sNames))
         {
            param2[param2.length] = this.getTexture(_loc3_);
         }
         sNames.length = 0;
         return param2;
      }
      
      public function getTextureNames(param1:String = "", param2:Vector.<String> = null) : Vector.<String>
      {
         var _loc3_:TextureAtlas = null;
         param2 = this.getDictionaryKeys(this._textures,param1,param2);
         for each(_loc3_ in this._atlases)
         {
            _loc3_.getNames(param1,param2);
         }
         param2.sort(Array.CASEINSENSITIVE);
         return param2;
      }
      
      public function getTextureAtlas(param1:String) : TextureAtlas
      {
         return this._atlases[param1] as TextureAtlas;
      }
      
      public function getTextureAtlasNames(param1:String = "", param2:Vector.<String> = null) : Vector.<String>
      {
         return this.getDictionaryKeys(this._atlases,param1,param2);
      }
      
      public function getSound(param1:String) : Sound
      {
         return this._sounds[param1];
      }
      
      public function getSoundNames(param1:String = "", param2:Vector.<String> = null) : Vector.<String>
      {
         return this.getDictionaryKeys(this._sounds,param1,param2);
      }
      
      public function playSound(param1:String, param2:Number = 0, param3:int = 0, param4:SoundTransform = null) : SoundChannel
      {
         if(param1 in this._sounds)
         {
            return this.getSound(param1).play(param2,param3,param4);
         }
         return null;
      }
      
      public function getXml(param1:String) : XML
      {
         return this._xmls[param1];
      }
      
      public function getXmlNames(param1:String = "", param2:Vector.<String> = null) : Vector.<String>
      {
         return this.getDictionaryKeys(this._xmls,param1,param2);
      }
      
      public function getObject(param1:String) : Object
      {
         return this._objects[param1];
      }
      
      public function getObjectNames(param1:String = "", param2:Vector.<String> = null) : Vector.<String>
      {
         return this.getDictionaryKeys(this._objects,param1,param2);
      }
      
      public function getByteArray(param1:String) : ByteArray
      {
         return this._byteArrays[param1];
      }
      
      public function getByteArrayNames(param1:String = "", param2:Vector.<String> = null) : Vector.<String>
      {
         return this.getDictionaryKeys(this._byteArrays,param1,param2);
      }
      
      public function getBitmapFont(param1:String) : BitmapFont
      {
         return this._bitmapFonts[param1] as BitmapFont;
      }
      
      public function getBitmapFontNames(param1:String = "", param2:Vector.<String> = null) : Vector.<String>
      {
         return this.getDictionaryKeys(this._bitmapFonts,param1,param2);
      }
      
      public function addTexture(param1:String, param2:Texture) : void
      {
         this.log("Adding texture \'" + param1 + "\'");
         if(param1 in this._textures && param2 != this._textures[param1])
         {
            this.log("Warning: name was already in use; the previous texture will be replaced.");
            this._textures[param1].dispose();
         }
         this._textures[param1] = param2;
      }
      
      public function addTextureAtlas(param1:String, param2:TextureAtlas) : void
      {
         this.log("Adding texture atlas \'" + param1 + "\'");
         if(param1 in this._atlases && param2 != this._atlases[param1])
         {
            this.log("Warning: name was already in use; the previous atlas will be replaced.");
            this._atlases[param1].dispose();
         }
         this._atlases[param1] = param2;
      }
      
      public function addSound(param1:String, param2:Sound) : void
      {
         this.log("Adding sound \'" + param1 + "\'");
         if(param1 in this._sounds && param2 != this._sounds[param1])
         {
            this.log("Warning: name was already in use; the previous sound will be replaced.");
         }
         this._sounds[param1] = param2;
      }
      
      public function addXml(param1:String, param2:XML) : void
      {
         this.log("Adding XML \'" + param1 + "\'");
         if(param1 in this._xmls && param2 != this._xmls[param1])
         {
            this.log("Warning: name was already in use; the previous XML will be replaced.");
            System.disposeXML(this._xmls[param1]);
         }
         this._xmls[param1] = param2;
      }
      
      public function addObject(param1:String, param2:Object) : void
      {
         this.log("Adding object \'" + param1 + "\'");
         if(param1 in this._objects && param2 != this._objects[param1])
         {
            this.log("Warning: name was already in use; the previous object will be replaced.");
         }
         this._objects[param1] = param2;
      }
      
      public function addByteArray(param1:String, param2:ByteArray) : void
      {
         this.log("Adding byte array \'" + param1 + "\'");
         if(param1 in this._byteArrays && param2 != this._byteArrays[param1])
         {
            this.log("Warning: name was already in use; the previous byte array will be replaced.");
            this._byteArrays[param1].clear();
         }
         this._byteArrays[param1] = param2;
      }
      
      public function addBitmapFont(param1:String, param2:BitmapFont) : void
      {
         this.log("Adding bitmap font \'" + param1 + "\'");
         if(param1 in this._bitmapFonts && param2 != this._bitmapFonts[param1])
         {
            this.log("Warning: name was already in use; the previous font will be replaced.");
            this._bitmapFonts[param1].dispose();
         }
         this._bitmapFonts[param1] = param2;
      }
      
      public function removeTexture(param1:String, param2:Boolean = true) : void
      {
         this.log("Removing texture \'" + param1 + "\'");
         if(param2 && param1 in this._textures)
         {
            this._textures[param1].dispose();
         }
         delete this._textures[param1];
      }
      
      public function removeTextureAtlas(param1:String, param2:Boolean = true) : void
      {
         this.log("Removing texture atlas \'" + param1 + "\'");
         if(param2 && param1 in this._atlases)
         {
            this._atlases[param1].dispose();
         }
         delete this._atlases[param1];
      }
      
      public function removeSound(param1:String) : void
      {
         this.log("Removing sound \'" + param1 + "\'");
         delete this._sounds[param1];
      }
      
      public function removeXml(param1:String, param2:Boolean = true) : void
      {
         this.log("Removing xml \'" + param1 + "\'");
         if(param2 && param1 in this._xmls)
         {
            System.disposeXML(this._xmls[param1]);
         }
         delete this._xmls[param1];
      }
      
      public function removeObject(param1:String) : void
      {
         this.log("Removing object \'" + param1 + "\'");
         delete this._objects[param1];
      }
      
      public function removeByteArray(param1:String, param2:Boolean = true) : void
      {
         this.log("Removing byte array \'" + param1 + "\'");
         if(param2 && param1 in this._byteArrays)
         {
            this._byteArrays[param1].clear();
         }
         delete this._byteArrays[param1];
      }
      
      public function removeBitmapFont(param1:String, param2:Boolean = true) : void
      {
         this.log("Removing bitmap font \'" + param1 + "\'");
         if(param2 && param1 in this._bitmapFonts)
         {
            this._bitmapFonts[param1].dispose();
         }
         delete this._bitmapFonts[param1];
      }
      
      public function purgeQueue() : void
      {
         this._queue.length = 0;
         dispatchEventWith(Event.CANCEL);
      }
      
      public function purge() : void
      {
         this.log("Purging all assets, emptying queue");
         this.purgeQueue();
         this.dispose();
         this._textures = new Dictionary();
         this._atlases = new Dictionary();
         this._sounds = new Dictionary();
         this._xmls = new Dictionary();
         this._objects = new Dictionary();
         this._byteArrays = new Dictionary();
         this._bitmapFonts = new Dictionary();
      }
      
      public function enqueue(... rest) : void
      {
         var rawAsset:Object = null;
         var typeXml:XML = null;
         var childNode:XML = null;
         var rawAssets:Array = rest;
         for each(rawAsset in rawAssets)
         {
            if(rawAsset is Array)
            {
               this.enqueue.apply(this,rawAsset);
            }
            else if(rawAsset is Class)
            {
               typeXml = describeType(rawAsset);
               if(this._verbose)
               {
                  this.log("Looking for static embedded assets in \'" + typeXml.@name.split("::").pop() + "\'");
               }
               for each(childNode in typeXml.constant.(@type == "Class"))
               {
                  this.enqueueWithName(rawAsset[childNode.@name],childNode.@name);
               }
               for each(childNode in typeXml.variable.(@type == "Class"))
               {
                  this.enqueueWithName(rawAsset[childNode.@name],childNode.@name);
               }
            }
            else if(getQualifiedClassName(rawAsset) == "flash.filesystem::File")
            {
               if(!rawAsset["exists"])
               {
                  this.log("File or directory not found: \'" + rawAsset["url"] + "\'");
               }
               else if(!rawAsset["isHidden"])
               {
                  if(rawAsset["isDirectory"])
                  {
                     this.enqueue.apply(this,rawAsset["getDirectoryListing"]());
                  }
                  else
                  {
                     this.enqueueWithName(rawAsset);
                  }
               }
            }
            else if(rawAsset is String || rawAsset is URLRequest)
            {
               this.enqueueWithName(rawAsset);
            }
            else
            {
               this.log("Ignoring unsupported asset type: " + getQualifiedClassName(rawAsset));
            }
         }
      }
      
      public function enqueueWithName(param1:Object, param2:String = null, param3:TextureOptions = null) : String
      {
         if(param2 == null)
         {
            param2 = this.getName(param1);
         }
         if(param3 == null)
         {
            param3 = this._defaultTextureOptions.clone();
         }
         else
         {
            param3 = param3.clone();
         }
         this.log("Enqueuing \'" + param2 + "\'");
         if(getQualifiedClassName(param1) == "flash.filesystem::File")
         {
            param1 = decodeURI(param1["url"]);
         }
         this._queue.push({
            "name":param2,
            "asset":param1,
            "options":param3
         });
         return param2;
      }
      
      public function loadQueue(param1:Function) : void
      {
         var PROGRESS_PART_ASSETS:Number = NaN;
         var PROGRESS_PART_XMLS:Number = NaN;
         var i:int = 0;
         var canceled:Boolean = false;
         var xmls:Vector.<XML> = null;
         var assetInfos:Array = null;
         var assetCount:int = 0;
         var assetProgress:Array = null;
         var assetIndex:int = 0;
         var processXml:Function = null;
         var cancel:Function = null;
         var onProgress:Function = param1;
         var loadNextQueueElement:Function = function():void
         {
            var _loc1_:int = 0;
            if(assetIndex < assetInfos.length)
            {
               _loc1_ = assetIndex++;
               loadQueueElement(_loc1_,assetInfos[_loc1_]);
            }
         };
         var loadQueueElement:Function = function(param1:int, param2:Object):void
         {
            var onElementProgress:Function;
            var onElementLoaded:Function;
            var index:int = param1;
            var assetInfo:Object = param2;
            if(canceled)
            {
               return;
            }
            onElementProgress = function(param1:Number):void
            {
               updateAssetProgress(index,param1 * 0.8);
            };
            onElementLoaded = function():void
            {
               updateAssetProgress(index,1);
               --assetCount;
               if(assetCount > 0)
               {
                  loadNextQueueElement();
               }
               else
               {
                  processXmls();
               }
            };
            processRawAsset(assetInfo.name,assetInfo.asset,assetInfo.options,xmls,onElementProgress,onElementLoaded);
         };
         var updateAssetProgress:Function = function(param1:int, param2:Number):void
         {
            assetProgress[param1] = param2;
            var _loc3_:Number = 0;
            var _loc4_:int = int(assetProgress.length);
            i = 0;
            while(i < _loc4_)
            {
               _loc3_ += assetProgress[i];
               ++i;
            }
            onProgress(_loc3_ / _loc4_ * PROGRESS_PART_ASSETS);
         };
         var processXmls:Function = function():void
         {
            xmls.sort(function(param1:XML, param2:XML):int
            {
               return param1.localName() == "TextureAtlas" ? -1 : 1;
            });
            setTimeout(processXml,1,0);
         };
         processXml = function(param1:int):void
         {
            var _loc2_:Texture = null;
            var _loc3_:String = null;
            var _loc4_:String = null;
            var _loc8_:BitmapFont = null;
            if(canceled)
            {
               return;
            }
            if(param1 == xmls.length)
            {
               finish();
               return;
            }
            var _loc5_:XML = xmls[param1];
            var _loc6_:String = _loc5_.localName();
            var _loc7_:Number = (param1 + 1) / (xmls.length + 1);
            if(_loc6_ == "TextureAtlas")
            {
               _loc3_ = getName(_loc5_.@imagePath.toString());
               _loc2_ = getTexture(_loc3_);
               if(_loc2_)
               {
                  addTextureAtlas(_loc3_,new TextureAtlas(_loc2_,_loc5_));
               }
               else
               {
                  log("Cannot create atlas: texture \'" + _loc3_ + "\' is missing.");
               }
               if(_keepAtlasXmls)
               {
                  addXml(_loc3_,_loc5_);
               }
               else
               {
                  System.disposeXML(_loc5_);
               }
            }
            else
            {
               if(_loc6_ != "font")
               {
                  throw new Error("XML contents not recognized: " + _loc6_);
               }
               _loc3_ = getName(_loc5_.pages.page.@file.toString());
               _loc4_ = _registerBitmapFontsWithFontFace ? _loc5_.info.@face.toString() : _loc3_;
               _loc2_ = getTexture(_loc3_);
               if(_loc2_)
               {
                  _loc8_ = new BitmapFont(_loc2_,_loc5_);
                  addBitmapFont(_loc4_,_loc8_);
                  TextField.registerCompositor(_loc8_,_loc4_);
               }
               else
               {
                  log("Cannot create bitmap font: texture \'" + _loc3_ + "\' is missing.");
               }
               if(_keepFontXmls)
               {
                  addXml(_loc3_,_loc5_);
               }
               else
               {
                  System.disposeXML(_loc5_);
               }
            }
            onProgress(PROGRESS_PART_ASSETS + PROGRESS_PART_XMLS * _loc7_);
            setTimeout(processXml,1,param1 + 1);
         };
         cancel = function():void
         {
            removeEventListener(Event.CANCEL,cancel);
            --_numLoadingQueues;
            canceled = true;
         };
         var finish:Function = function():void
         {
            setTimeout(function():void
            {
               if(!canceled)
               {
                  cancel();
                  onProgress(1);
               }
            },1);
         };
         if(onProgress == null)
         {
            throw new ArgumentError("Argument \'onProgress\' must not be null");
         }
         if(this._queue.length == 0)
         {
            onProgress(1);
            return;
         }
         this._starling = Starling.current;
         if(this._starling == null || this._starling.context == null)
         {
            throw new Error("The Starling instance needs to be ready before assets can be loaded.");
         }
         PROGRESS_PART_ASSETS = 0.9;
         PROGRESS_PART_XMLS = 1 - PROGRESS_PART_ASSETS;
         canceled = false;
         xmls = new Vector.<XML>(0);
         assetInfos = this._queue.concat();
         assetCount = int(this._queue.length);
         assetProgress = [];
         assetIndex = 0;
         i = 0;
         while(i < assetCount)
         {
            assetProgress[i] = 0;
            i++;
         }
         i = 0;
         while(i < this._numConnections)
         {
            loadNextQueueElement();
            i++;
         }
         this._queue.length = 0;
         ++this._numLoadingQueues;
         addEventListener(Event.CANCEL,cancel);
      }
      
      private function processRawAsset(param1:String, param2:Object, param3:TextureOptions, param4:Vector.<XML>, param5:Function, param6:Function) : void
      {
         var canceled:Boolean = false;
         var process:Function = null;
         var progress:Function = null;
         var cancel:Function = null;
         var name:String = param1;
         var rawAsset:Object = param2;
         var options:TextureOptions = param3;
         var xmls:Vector.<XML> = param4;
         var onProgress:Function = param5;
         var onComplete:Function = param6;
         process = function(param1:Object):void
         {
            var texture:Texture = null;
            var bytes:ByteArray = null;
            var asset:Object = param1;
            var object:Object = null;
            var xml:XML = null;
            _starling.makeCurrent();
            if(!canceled)
            {
               if(asset == null)
               {
                  onComplete();
               }
               else if(asset is Sound)
               {
                  addSound(name,asset as Sound);
                  onComplete();
               }
               else if(asset is XML)
               {
                  xml = asset as XML;
                  if(xml.localName() == "TextureAtlas" || xml.localName() == "font")
                  {
                     xmls.push(xml);
                  }
                  else
                  {
                     addXml(name,xml);
                  }
                  onComplete();
               }
               else
               {
                  if(_starling.context.driverInfo == "Disposed")
                  {
                     log("Context lost while processing assets, retrying ...");
                     setTimeout(process,1,asset);
                     return;
                  }
                  if(asset is Bitmap)
                  {
                     options.onReady = prependCallback(options.onReady,function():void
                     {
                        addTexture(name,texture);
                        onComplete();
                     });
                     texture = Texture.fromData(asset,options);
                     texture.root.onRestore = function():void
                     {
                        ++_numLostTextures;
                        loadRawAsset(rawAsset,null,function(param1:Object):void
                        {
                           var asset:Object = param1;
                           try
                           {
                              if(asset == null)
                              {
                                 throw new Error("Reload failed");
                              }
                              texture.root.uploadBitmap(asset as Bitmap);
                              asset.bitmapData.dispose();
                           }
                           catch(e:Error)
                           {
                              log("Texture restoration failed for \'" + name + "\': " + e.message);
                           }
                           ++_numRestoredTextures;
                           Starling.current.stage.setRequiresRedraw();
                           if(_numLostTextures == _numRestoredTextures)
                           {
                              dispatchEventWith(Event.TEXTURES_RESTORED);
                           }
                        });
                     };
                  }
                  else if(asset is ByteArray)
                  {
                     bytes = asset as ByteArray;
                     if(AtfData.isAtfData(bytes))
                     {
                        options.onReady = prependCallback(options.onReady,function():void
                        {
                           addTexture(name,texture);
                           onComplete();
                        });
                        texture = Texture.fromData(bytes,options);
                        texture.root.onRestore = function():void
                        {
                           ++_numLostTextures;
                           loadRawAsset(rawAsset,null,function(param1:Object):void
                           {
                              var asset:Object = param1;
                              try
                              {
                                 if(asset == null)
                                 {
                                    throw new Error("Reload failed");
                                 }
                                 texture.root.uploadAtfData(asset as ByteArray,0,false);
                                 asset.clear();
                              }
                              catch(e:Error)
                              {
                                 log("Texture restoration failed for \'" + name + "\': " + e.message);
                              }
                              ++_numRestoredTextures;
                              Starling.current.stage.setRequiresRedraw();
                              if(_numLostTextures == _numRestoredTextures)
                              {
                                 dispatchEventWith(Event.TEXTURES_RESTORED);
                              }
                           });
                        };
                        bytes.clear();
                     }
                     else if(byteArrayStartsWith(bytes,"{") || byteArrayStartsWith(bytes,"["))
                     {
                        try
                        {
                           object = JSON.parse(bytes.readUTFBytes(bytes.length));
                        }
                        catch(e:Error)
                        {
                           log("Could not parse JSON: " + e.message);
                           dispatchEventWith(Event.PARSE_ERROR,false,name);
                        }
                        if(object)
                        {
                           addObject(name,object);
                        }
                        bytes.clear();
                        onComplete();
                     }
                     else if(byteArrayStartsWith(bytes,"<"))
                     {
                        try
                        {
                           xml = new XML(bytes);
                        }
                        catch(e:Error)
                        {
                           log("Could not parse XML: " + e.message);
                           dispatchEventWith(Event.PARSE_ERROR,false,name);
                        }
                        process(xml);
                        bytes.clear();
                     }
                     else
                     {
                        addByteArray(name,bytes);
                        onComplete();
                     }
                  }
                  else
                  {
                     addObject(name,asset);
                     onComplete();
                  }
               }
            }
            asset = null;
            bytes = null;
            removeEventListener(Event.CANCEL,cancel);
         };
         progress = function(param1:Number):void
         {
            if(!canceled)
            {
               onProgress(param1);
            }
         };
         cancel = function():void
         {
            canceled = true;
         };
         canceled = false;
         addEventListener(Event.CANCEL,cancel);
         this.loadRawAsset(rawAsset,progress,process);
      }
      
      protected function loadRawAsset(param1:Object, param2:Function, param3:Function) : void
      {
         var extension:String = null;
         var loaderInfo:LoaderInfo = null;
         var urlLoader:URLLoader = null;
         var url:String = null;
         var onIoError:Function = null;
         var onSecurityError:Function = null;
         var onHttpResponseStatus:Function = null;
         var onLoadProgress:Function = null;
         var onUrlLoaderComplete:Function = null;
         var onLoaderComplete:Function = null;
         var complete:Function = null;
         var rawAsset:Object = param1;
         var onProgress:Function = param2;
         var onComplete:Function = param3;
         onIoError = function(param1:IOErrorEvent):void
         {
            log("IO error: " + param1.text);
            dispatchEventWith(Event.IO_ERROR,false,url);
            complete(null);
         };
         onSecurityError = function(param1:SecurityErrorEvent):void
         {
            log("security error: " + param1.text);
            dispatchEventWith(Event.SECURITY_ERROR,false,url);
            complete(null);
         };
         onHttpResponseStatus = function(param1:HTTPStatusEvent):void
         {
            var _loc2_:Array = null;
            var _loc3_:String = null;
            if(extension == null)
            {
               _loc2_ = param1["responseHeaders"];
               _loc3_ = getHttpHeader(_loc2_,"Content-Type");
               if(Boolean(_loc3_) && Boolean(/(audio|image)\//.exec(_loc3_)))
               {
                  extension = _loc3_.split("/").pop();
               }
            }
         };
         onLoadProgress = function(param1:ProgressEvent):void
         {
            if(onProgress != null && param1.bytesTotal > 0)
            {
               onProgress(param1.bytesLoaded / param1.bytesTotal);
            }
         };
         onUrlLoaderComplete = function(param1:Object):void
         {
            var _loc3_:Sound = null;
            var _loc4_:LoaderContext = null;
            var _loc5_:Loader = null;
            var _loc2_:ByteArray = transformData(urlLoader.data as ByteArray,url);
            if(_loc2_ == null)
            {
               complete(null);
               return;
            }
            if(extension)
            {
               extension = extension.toLowerCase();
            }
            switch(extension)
            {
               case "mpeg":
               case "mp3":
                  _loc3_ = new Sound();
                  _loc3_.loadCompressedDataFromByteArray(_loc2_,_loc2_.length);
                  _loc2_.clear();
                  complete(_loc3_);
                  break;
               case "jpg":
               case "jpeg":
               case "png":
               case "gif":
                  _loc4_ = new LoaderContext(_checkPolicyFile);
                  _loc5_ = new Loader();
                  _loc4_.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
                  loaderInfo = _loc5_.contentLoaderInfo;
                  loaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onIoError);
                  loaderInfo.addEventListener(Event.COMPLETE,onLoaderComplete);
                  _loc5_.loadBytes(_loc2_,_loc4_);
                  break;
               default:
                  complete(_loc2_);
            }
         };
         onLoaderComplete = function(param1:Object):void
         {
            urlLoader.data.clear();
            complete(param1.target.content);
         };
         complete = function(param1:Object):void
         {
            if(urlLoader)
            {
               urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,onIoError);
               urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
               urlLoader.removeEventListener(HTTP_RESPONSE_STATUS,onHttpResponseStatus);
               urlLoader.removeEventListener(ProgressEvent.PROGRESS,onLoadProgress);
               urlLoader.removeEventListener(Event.COMPLETE,onUrlLoaderComplete);
            }
            if(loaderInfo)
            {
               loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onIoError);
               loaderInfo.removeEventListener(Event.COMPLETE,onLoaderComplete);
            }
            if(SystemUtil.isDesktop)
            {
               onComplete(param1);
            }
            else
            {
               SystemUtil.executeWhenApplicationIsActive(onComplete,param1);
            }
         };
         extension = null;
         loaderInfo = null;
         urlLoader = null;
         var urlRequest:URLRequest = null;
         url = null;
         if(rawAsset is Class)
         {
            setTimeout(complete,1,new rawAsset());
         }
         else if(rawAsset is String || rawAsset is URLRequest)
         {
            urlRequest = rawAsset as URLRequest || new URLRequest(rawAsset as String);
            url = urlRequest.url;
            extension = this.getExtensionFromUrl(url);
            urlLoader = new URLLoader();
            urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
            urlLoader.addEventListener(IOErrorEvent.IO_ERROR,onIoError);
            urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
            urlLoader.addEventListener(HTTP_RESPONSE_STATUS,onHttpResponseStatus);
            urlLoader.addEventListener(ProgressEvent.PROGRESS,onLoadProgress);
            urlLoader.addEventListener(Event.COMPLETE,onUrlLoaderComplete);
            urlLoader.load(urlRequest);
         }
      }
      
      protected function getName(param1:Object) : String
      {
         var _loc2_:String = null;
         if(param1 is String)
         {
            _loc2_ = param1 as String;
         }
         else if(param1 is URLRequest)
         {
            _loc2_ = (param1 as URLRequest).url;
         }
         else if(param1 is FileReference)
         {
            _loc2_ = (param1 as FileReference).name;
         }
         if(_loc2_)
         {
            _loc2_ = _loc2_.replace(/%20/g," ");
            _loc2_ = this.getBasenameFromUrl(_loc2_);
            if(_loc2_)
            {
               return _loc2_;
            }
            throw new ArgumentError("Could not extract name from String \'" + param1 + "\'");
         }
         _loc2_ = getQualifiedClassName(param1);
         throw new ArgumentError("Cannot extract names for objects of type \'" + _loc2_ + "\'");
      }
      
      protected function transformData(param1:ByteArray, param2:String) : ByteArray
      {
         return param1;
      }
      
      protected function log(param1:String) : void
      {
         if(this._verbose)
         {
         }
      }
      
      private function byteArrayStartsWith(param1:ByteArray, param2:String) : Boolean
      {
         var _loc7_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = int(param1.length);
         var _loc5_:int = param2.charCodeAt(0);
         if(_loc4_ >= 4 && (param1[0] == 0 && param1[1] == 0 && param1[2] == 254 && param1[3] == 255) || param1[0] == 255 && param1[1] == 254 && param1[2] == 0 && param1[3] == 0)
         {
            _loc3_ = 4;
         }
         else if(_loc4_ >= 3 && param1[0] == 239 && param1[1] == 187 && param1[2] == 191)
         {
            _loc3_ = 3;
         }
         else if(_loc4_ >= 2 && (param1[0] == 254 && param1[1] == 255) || param1[0] == 255 && param1[1] == 254)
         {
            _loc3_ = 2;
         }
         var _loc6_:int = _loc3_;
         while(_loc6_ < _loc4_)
         {
            _loc7_ = int(param1[_loc6_]);
            if(!(_loc7_ == 0 || _loc7_ == 10 || _loc7_ == 13 || _loc7_ == 32))
            {
               return _loc7_ == _loc5_;
            }
            _loc6_++;
         }
         return false;
      }
      
      private function getDictionaryKeys(param1:Dictionary, param2:String = "", param3:Vector.<String> = null) : Vector.<String>
      {
         var _loc4_:String = null;
         if(param3 == null)
         {
            param3 = new Vector.<String>(0);
         }
         for(_loc4_ in param1)
         {
            if(_loc4_.indexOf(param2) == 0)
            {
               param3[param3.length] = _loc4_;
            }
         }
         param3.sort(Array.CASEINSENSITIVE);
         return param3;
      }
      
      private function getHttpHeader(param1:Array, param2:String) : String
      {
         var _loc3_:Object = null;
         if(param1)
         {
            for each(_loc3_ in param1)
            {
               if(_loc3_.name == param2)
               {
                  return _loc3_.value;
               }
            }
         }
         return null;
      }
      
      protected function getBasenameFromUrl(param1:String) : String
      {
         var _loc2_:Array = NAME_REGEX.exec(param1);
         if(Boolean(_loc2_) && _loc2_.length > 0)
         {
            return _loc2_[1];
         }
         return null;
      }
      
      protected function getExtensionFromUrl(param1:String) : String
      {
         var _loc2_:Array = NAME_REGEX.exec(param1);
         if(Boolean(_loc2_) && _loc2_.length > 1)
         {
            return _loc2_[2];
         }
         return null;
      }
      
      private function prependCallback(param1:Function, param2:Function) : Function
      {
         var oldCallback:Function = param1;
         var newCallback:Function = param2;
         if(oldCallback == null)
         {
            return newCallback;
         }
         if(newCallback == null)
         {
            return oldCallback;
         }
         return function():void
         {
            newCallback();
            oldCallback();
         };
      }
      
      protected function get queue() : Array
      {
         return this._queue;
      }
      
      public function get numQueuedAssets() : int
      {
         return this._queue.length;
      }
      
      public function get verbose() : Boolean
      {
         return this._verbose;
      }
      
      public function set verbose(param1:Boolean) : void
      {
         this._verbose = param1;
      }
      
      public function get isLoading() : Boolean
      {
         return this._numLoadingQueues > 0;
      }
      
      public function get useMipMaps() : Boolean
      {
         return this._defaultTextureOptions.mipMapping;
      }
      
      public function set useMipMaps(param1:Boolean) : void
      {
         this._defaultTextureOptions.mipMapping = param1;
      }
      
      public function get scaleFactor() : Number
      {
         return this._defaultTextureOptions.scale;
      }
      
      public function set scaleFactor(param1:Number) : void
      {
         this._defaultTextureOptions.scale = param1;
      }
      
      public function get textureFormat() : String
      {
         return this._defaultTextureOptions.format;
      }
      
      public function set textureFormat(param1:String) : void
      {
         this._defaultTextureOptions.format = param1;
      }
      
      public function get forcePotTextures() : Boolean
      {
         return this._defaultTextureOptions.forcePotTexture;
      }
      
      public function set forcePotTextures(param1:Boolean) : void
      {
         this._defaultTextureOptions.forcePotTexture = param1;
      }
      
      public function get checkPolicyFile() : Boolean
      {
         return this._checkPolicyFile;
      }
      
      public function set checkPolicyFile(param1:Boolean) : void
      {
         this._checkPolicyFile = param1;
      }
      
      public function get keepAtlasXmls() : Boolean
      {
         return this._keepAtlasXmls;
      }
      
      public function set keepAtlasXmls(param1:Boolean) : void
      {
         this._keepAtlasXmls = param1;
      }
      
      public function get keepFontXmls() : Boolean
      {
         return this._keepFontXmls;
      }
      
      public function set keepFontXmls(param1:Boolean) : void
      {
         this._keepFontXmls = param1;
      }
      
      public function get numConnections() : int
      {
         return this._numConnections;
      }
      
      public function set numConnections(param1:int) : void
      {
         this._numConnections = param1;
      }
      
      public function get registerBitmapFontsWithFontFace() : Boolean
      {
         return this._registerBitmapFontsWithFontFace;
      }
      
      public function set registerBitmapFontsWithFontFace(param1:Boolean) : void
      {
         this._registerBitmapFontsWithFontFace = param1;
      }
   }
}

