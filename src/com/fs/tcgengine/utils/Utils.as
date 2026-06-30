package com.fs.tcgengine.utils
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.QuestsMng;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.controller.rules.BoostsDefMng;
   import com.fs.tcgengine.controller.rules.BundlesDefMng;
   import com.fs.tcgengine.controller.rules.CardDefMng;
   import com.fs.tcgengine.controller.rules.CategoriesDefMng;
   import com.fs.tcgengine.controller.rules.DeckSlotDefMng;
   import com.fs.tcgengine.controller.rules.GoldDefMng;
   import com.fs.tcgengine.controller.rules.PacksDefMng;
   import com.fs.tcgengine.controller.rules.ShopBoostDefMng;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.board.card.Ability;
   import com.fs.tcgengine.model.quests.Quest;
   import com.fs.tcgengine.model.rules.ActionDef;
   import com.fs.tcgengine.model.rules.AttachmentDef;
   import com.fs.tcgengine.model.rules.AuctionTicketDef;
   import com.fs.tcgengine.model.rules.BoostDef;
   import com.fs.tcgengine.model.rules.BundleDef;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.CategoryDef;
   import com.fs.tcgengine.model.rules.DeckSlotDef;
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.FactionDef;
   import com.fs.tcgengine.model.rules.GoldDef;
   import com.fs.tcgengine.model.rules.HeroCharacterDef;
   import com.fs.tcgengine.model.rules.PackDef;
   import com.fs.tcgengine.model.rules.RarityDef;
   import com.fs.tcgengine.model.rules.RewardDef;
   import com.fs.tcgengine.model.rules.ShopBoostDef;
   import com.fs.tcgengine.model.rules.SubCategoryDef;
   import com.fs.tcgengine.model.rules.UnitDef;
   import com.fs.tcgengine.model.userdata.UserBattleInfo;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSBattleScreenPvP;
   import com.fs.tcgengine.screens.FSMenuScreen;
   import com.fs.tcgengine.screens.FSShopScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.CustomComponent;
   import com.fs.tcgengine.view.components.FSSprite3D;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.components.shop.FSShopItem;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.misc.RewardsEffect;
   import com.fs.tcgengine.view.popups.misc.PopupError;
   import com.fs.tcgengine.view.popups.misc.PopupSettingsConfirmation;
   import com.fs.tcgengine.view.popups.purchases.PopupShopItem;
   import com.greensock.TweenMax;
   import feathers.controls.Label;
   import feathers.controls.text.BitmapFontTextRenderer;
   import feathers.system.DeviceCapabilities;
   import feathers.text.BitmapFontTextFormat;
   import flash.desktop.Clipboard;
   import flash.desktop.ClipboardFormats;
   import flash.desktop.NativeApplication;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.globalization.CurrencyFormatter;
   import flash.globalization.LocaleID;
   import flash.globalization.NumberFormatter;
   import flash.net.SharedObject;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.ApplicationDomain;
   import flash.system.Capabilities;
   import flash.system.ImageDecodingPolicy;
   import flash.system.LoaderContext;
   import flash.system.Security;
   import flash.system.SecurityDomain;
   import flash.system.System;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import starling.core.Starling;
   import starling.display.DisplayObjectContainer;
   import starling.display.MovieClip;
   import starling.display.Quad;
   import starling.display.Sprite3D;
   import starling.events.Event;
   import starling.events.TouchEvent;
   import starling.extensions.lighting.LightSource;
   import starling.text.TextField;
   import starling.textures.Texture;
   
   public class Utils
   {
      
      private static const DEVICE_MOBILE:int = 0;
      
      private static const DEVICE_OTHERS:int = 1;
      
      private static const NO:int = 0;
      
      private static const YES:int = 1;
      
      private static var smDeviceType:int = -1;
      
      public static var smInternetAvailable:Boolean = false;
      
      public static var smRawInternetAvailable:Boolean = false;
      
      private static var smIsLowPerformanceDevice:int = -1;
      
      private static var smLastGCCallTimestamp:Number = -1;
      
      private static var smShakeMagnitude:Number = 1;
      
      public static var smShakeRequested:Boolean = false;
      
      private static var smNumberFormatArr:Array = [" K"," M"," B"," T"];
      
      public function Utils()
      {
         super();
      }
      
      public static function stringToBoolean(param1:String) : Boolean
      {
         return param1 == "1" || param1 == "true" ? true : false;
      }
      
      public static function createInputTextfield(param1:String, param2:int, param3:int, param4:String = "") : flash.text.TextField
      {
         var _loc5_:flash.text.TextField = new flash.text.TextField();
         param4 = param4 == "" ? FSResourceMng.getFontByType() : param4;
         var _loc6_:TextFormat = new TextFormat(param4,FSResourceMng.FONT_STD_TITLE_SIZE,6908265);
         _loc6_.align = TextFormatAlign.CENTER;
         _loc5_.defaultTextFormat = _loc6_;
         _loc5_.multiline = false;
         _loc5_.width = param2;
         _loc5_.height = param3;
         _loc5_.type = TextFieldType.INPUT;
         _loc5_.background = true;
         _loc5_.backgroundColor = 15657130;
         _loc5_.border = true;
         _loc5_.borderColor = 12433259;
         _loc5_.alpha = 0.8;
         _loc5_.text = param1.toUpperCase();
         return _loc5_;
      }
      
      public static function checkFlashTextFieldGlyphs(param1:flash.text.TextField, param2:String, param3:String) : void
      {
         var _loc4_:String = null;
         var _loc5_:TextFormat = null;
         var _loc6_:String = null;
         if(param1 == null || (param2 == null || param2 == ""))
         {
            return;
         }
         param1.text = param2.toUpperCase();
         if(FSResourceMng.getAllFonts()[param3] != null)
         {
            _loc5_ = new TextFormat();
            _loc5_.size = param1.defaultTextFormat.size;
            _loc4_ = param2.split("\r").join("");
            if(FSResourceMng.getAllFonts()[param3].hasGlyphs(_loc4_))
            {
               _loc5_.font = param3;
               param1.setTextFormat(_loc5_);
               param1.embedFonts = true;
               return;
            }
            _loc6_ = FSResourceMng.getAllFonts()["System Font Bold"] ? FSResourceMng.getAllFonts()["System Font Bold"].fontName : "_sans";
            _loc5_.font = _loc6_;
            _loc5_.leading = 0;
            param1.setTextFormat(_loc5_);
            param1.embedFonts = false;
            return;
         }
      }
      
      public static function refreshTextfieldIfTextHasGlyphs(param1:starling.text.TextField, param2:String, param3:String) : Boolean
      {
         var _loc5_:RegExp = null;
         var _loc6_:String = null;
         if(param1 == null || (param2 == null || param2 == ""))
         {
            return false;
         }
         var _loc4_:String = param2;
         param3 = Boolean(param3) && param3.indexOf("game_font") != -1 ? "std_white" : param3;
         if(FSResourceMng.getAllFonts()[param3] != null)
         {
            if(param2.indexOf("\r") != -1)
            {
               _loc4_ = param2.split("\r").join("");
            }
            if(_loc4_.indexOf("\n") != -1)
            {
               _loc4_ = _loc4_.split("\n").join("");
            }
            _loc5_ = /\r/gi;
            _loc4_.replace(_loc5_,"");
            if(!FSResourceMng.getAllFonts()[param3].hasGlyphs(_loc4_))
            {
               _loc6_ = FSResourceMng.getAllFonts()["System Font Bold"] ? FSResourceMng.getAllFonts()["System Font Bold"].fontName : "_sans";
               if(param1 is FSTextfield)
               {
                  FSTextfield(param1).setSkipGlyphsCheck(true);
               }
               param1.format.font = _loc6_;
               param1.text = param2;
               if(param1 is FSTextfield)
               {
                  FSTextfield(param1).setSkipGlyphsCheck(false);
               }
               return true;
            }
         }
         return false;
      }
      
      public static function textHasGlyphs(param1:String) : Boolean
      {
         var _loc2_:String = null;
         if(param1 == "" || param1 == null)
         {
            return false;
         }
         var _loc3_:String = "std_white";
         if(FSResourceMng.getAllFonts()[_loc3_] != null)
         {
            _loc2_ = param1.split("\r").join("");
            _loc2_ = param1.split("\n").join("");
            if(!FSResourceMng.getAllFonts()[_loc3_].hasGlyphs(_loc2_))
            {
               return true;
            }
         }
         return false;
      }
      
      public static function getXYPositionInContainer(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:Boolean = false) : FSCoordinate
      {
         var _loc9_:FSCoordinate = null;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc10_:int = param4 - param2 * param6;
         var _loc11_:int = param5 - param3 * param7;
         var _loc12_:int = _loc10_ / (param6 + 1);
         var _loc13_:int = _loc11_ / (param7 + 1);
         var _loc14_:int = !param8 ? int(-(param4 / 2 - param2 / 2 - _loc12_)) : _loc12_;
         var _loc15_:int = !param8 ? int(-(param5 / 2 - param3 / 2 - _loc13_)) : _loc13_;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         _loc19_ = param1 / param6;
         _loc18_ = param1 % param6;
         _loc16_ = _loc14_ + (param2 + _loc12_) * _loc18_;
         _loc17_ = _loc15_ + (param3 + _loc13_) * _loc19_;
         return new FSCoordinate(_loc16_,_loc17_);
      }
      
      public static function calculateScaleFactor(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int) : Number
      {
         var _loc7_:Number = 1;
         var _loc8_:Number = 1;
         var _loc9_:int = param3 - param1 * param5;
         var _loc10_:int = param4 - param2 * param6;
         var _loc11_:int = _loc9_ / (param5 + 1);
         var _loc12_:int = _loc10_ / (param6 + 1);
         _loc7_ = _loc11_ / param1;
         _loc8_ = _loc12_ / param2;
         return 1 + Math.min(_loc7_,_loc8_);
      }
      
      public static function randomNumber(param1:Number = 0, param2:Number = 1) : Number
      {
         return param1 + (param2 - param1) * Math.random();
      }
      
      public static function randomInt(param1:int = 0, param2:int = 1) : int
      {
         return Math.floor(Math.random() * (1 + param2 - param1)) + param1;
      }
      
      public static function getRandomItemFromArr(param1:Array) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:int = param1 != null && param1.length > 0 ? randomInt(0,param1.length - 1) : -1;
         if(_loc3_ != -1)
         {
            _loc2_ = param1[_loc3_];
         }
         return _loc2_;
      }
      
      public static function checkIfItemAlreadyExistsInCatalog(param1:*, param2:*) : Boolean
      {
         var _loc4_:int = 0;
         var _loc3_:Boolean = false;
         if(param2 != null && param1 != null)
         {
            _loc4_ = 0;
            while(_loc4_ < param2.length)
            {
               if(param2[_loc4_] == param1)
               {
                  return true;
               }
               _loc4_++;
            }
         }
         return _loc3_;
      }
      
      public static function transformValueToString(param1:String, param2:int) : String
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         _loc3_ = param1;
         if(param1 != null && param1.length != param2)
         {
            _loc4_ = param1.length;
            while(_loc4_ < param2)
            {
               _loc3_ = "0" + _loc3_;
               _loc4_++;
            }
         }
         return _loc3_;
      }
      
      public static function isAndroidOrDesktop() : Boolean
      {
         return isAndroid() || isDesktop();
      }
      
      public static function isAndroid() : Boolean
      {
         return Capabilities.version.substr(0,3) == "AND";
      }
      
      public static function isIOS() : Boolean
      {
         return Capabilities.version.substr(0,3) == "IOS";
      }
      
      public static function isDesktop() : Boolean
      {
         return !isBrowser() && (Capabilities.version.substr(0,3) == "WIN" || Capabilities.version.substr(0,3) == "MAC");
      }
      
      public static function isMobile() : Boolean
      {
         var _loc1_:Boolean = false;
         if(smDeviceType == -1)
         {
            smDeviceType = isAndroid() || isIOS() ? DEVICE_MOBILE : DEVICE_OTHERS;
         }
         return smDeviceType == DEVICE_MOBILE && !Utils.isDesktop();
      }
      
      public static function isLowPerformanceDevice() : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc1_:Boolean = false;
         if(smIsLowPerformanceDevice == -1)
         {
            _loc2_ = Capabilities.manufacturer.indexOf("iOS") != -1;
            _loc3_ = Capabilities.os;
            _loc4_ = _loc3_.toLowerCase();
            if(_loc4_.indexOf("ipad3,") >= 0)
            {
               _loc1_ = true;
            }
            else if(_loc4_.indexOf("iphone3,") >= 0)
            {
               _loc1_ = true;
            }
            else if(Utils.isAndroid())
            {
               _loc1_ = true;
            }
            else if(Utils.isDesktop())
            {
               _loc1_ = false;
            }
            smIsLowPerformanceDevice = _loc1_ == true ? YES : NO;
            FSDebug.debugTrace(_loc4_);
         }
         else
         {
            _loc1_ = smIsLowPerformanceDevice == YES;
         }
         return _loc1_;
      }
      
      public static function getNameSpace() : String
      {
         var _loc1_:XML = NativeApplication.nativeApplication.applicationDescriptor;
         var _loc2_:Namespace = _loc1_.namespace();
         return _loc1_._loc2_::id[0];
      }
      
      public static function getAppVersion() : String
      {
         var _loc1_:XML = null;
         var _loc2_:Namespace = null;
         if(Boolean(InstanceMng.getApplication()) && InstanceMng.getApplication().isBrowserVersion())
         {
            return "1.5.4.729";
         }
         _loc1_ = NativeApplication.nativeApplication.applicationDescriptor;
         _loc2_ = _loc1_.namespace();
         return _loc1_._loc2_::versionNumber[0];
      }
      
      public static function getBundleId() : String
      {
         var _loc1_:XML = null;
         var _loc2_:Namespace = null;
         var _loc3_:String = null;
         if(isMobile())
         {
            _loc1_ = NativeApplication.nativeApplication.applicationDescriptor;
            _loc2_ = _loc1_.namespace();
            _loc3_ = _loc1_._loc2_::id[0];
            return _loc3_.replace(".debug","");
         }
         return "";
      }
      
      public static function getObjectBoundsQuad(param1:DisplayObjectContainer, param2:uint = 16711680) : Quad
      {
         var _loc3_:Quad = null;
         if(param1 != null)
         {
            _loc3_ = new Quad(param1.bounds.width,param1.bounds.height,param2);
            _loc3_.alpha = 0.2;
         }
         return _loc3_;
      }
      
      public static function isAnySubcategorySkuAllowed(param1:Array, param2:Array) : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc3_:Boolean = false;
         if(param1 == null)
         {
            return true;
         }
         if(param2 == null)
         {
            return false;
         }
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            _loc6_ = param1[_loc4_];
            _loc5_ = 0;
            while(_loc5_ < param2.length)
            {
               _loc7_ = param2[_loc5_];
               if(_loc6_ == _loc7_)
               {
                  return true;
               }
               _loc5_++;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function isAnyGroupIdAllowed(param1:Array, param2:Array) : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc3_:Boolean = false;
         if(param1 == null)
         {
            return true;
         }
         if(param2 == null)
         {
            return false;
         }
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            _loc6_ = param1[_loc4_];
            _loc5_ = 0;
            while(_loc5_ < param2.length)
            {
               _loc7_ = param2[_loc5_];
               if(_loc6_ == _loc7_)
               {
                  return true;
               }
               _loc5_++;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function createAbilitiesVectorCopy(param1:Vector.<Ability>) : Vector.<Ability>
      {
         var _loc3_:Ability = null;
         var _loc2_:Vector.<Ability> = null;
         if(param1 != null)
         {
            _loc2_ = new Vector.<Ability>();
            for each(_loc3_ in param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public static function createQuestsVectorCopy(param1:Vector.<Quest>) : Vector.<Quest>
      {
         var _loc3_:Quest = null;
         var _loc2_:Vector.<Quest> = null;
         if(param1 != null)
         {
            _loc2_ = new Vector.<Quest>();
            for each(_loc3_ in param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public static function mergeAbilitiesVectors(param1:Vector.<Ability>, param2:Vector.<Ability>) : Vector.<Ability>
      {
         var _loc4_:Ability = null;
         var _loc3_:Vector.<Ability> = null;
         if(param1 != null)
         {
            _loc3_ = param1;
            if(param2 != null)
            {
               for each(_loc4_ in param2)
               {
                  _loc3_.push(_loc4_);
               }
            }
         }
         else if(param2 != null)
         {
            _loc3_ = param2;
            if(param1 != null)
            {
               for each(_loc4_ in param1)
               {
                  _loc3_.push(_loc4_);
               }
            }
         }
         return _loc3_;
      }
      
      public static function getRandomSoundTrack() : String
      {
         var _loc1_:String = null;
         var _loc2_:String = "track_";
         var _loc3_:int = randomInt(2,5);
         var _loc4_:String = transformValueToString(_loc3_.toString(),2);
         return _loc2_ + _loc4_;
      }
      
      public static function cleanMasterString(param1:String) : String
      {
         return param1 != null ? ("_" + param1).substr(1) : "";
      }
      
      public static function generateRandomString(param1:uint = 1, param2:String = "abcdefghijklmnopqrstuvwxyz0123456789") : String
      {
         var _loc3_:Array = param2.split("");
         var _loc4_:int = int(_loc3_.length);
         var _loc5_:String = "";
         var _loc6_:uint = 0;
         while(_loc6_ < param1)
         {
            _loc5_ += _loc3_[int(Math.floor(Math.random() * _loc4_))];
            _loc6_++;
         }
         return _loc5_;
      }
      
      public static function generateRandomUserName() : String
      {
         var _loc1_:String = "FS_";
         return (_loc1_ + generateRandomString(Config.getConfig().getMaxPlayerNameChars() - _loc1_.length)).toLowerCase();
      }
      
      public static function shuffleVector(param1:Vector) : void
      {
         var _loc2_:* = 0;
         var _loc3_:Number = NaN;
         var _loc4_:* = undefined;
         if(param1.length > 1)
         {
            _loc2_ = int(param1.length - 1);
            while(_loc2_ > 0)
            {
               _loc3_ = randomInt(0,param1.length);
               _loc4_ = param1[_loc3_];
               param1[_loc3_] = param1[_loc2_];
               param1[_loc2_] = _loc4_;
               _loc2_--;
            }
         }
      }
      
      public static function randomize(param1:*, param2:*) : int
      {
         return Math.random() < 0.5 ? -1 : 1;
      }
      
      public static function vectorToArray(param1:*) : Array
      {
         var _loc3_:* = undefined;
         var _loc2_:Array = null;
         for each(_loc3_ in param1)
         {
            if(_loc2_ == null)
            {
               _loc2_ = new Array();
            }
            _loc2_.push(_loc3_);
         }
         return _loc2_;
      }
      
      public static function callGC() : void
      {
         var _loc1_:Number = TimerUtil.currentTimeMillis();
         if(smLastGCCallTimestamp == -1 || smLastGCCallTimestamp < _loc1_ - TimerUtil.secondToMs(5))
         {
            FSDebug.debugTrace("Calling GC");
            System.pauseForGCIfCollectionImminent();
            smLastGCCallTimestamp = _loc1_;
         }
      }
      
      public static function isIphone(param1:int = -1, param2:int = -1) : Boolean
      {
         var _loc6_:int = 0;
         var _loc3_:int = param1 != -1 ? param1 : InstanceMng.getApplication().getFullScreenWidth();
         var _loc4_:int = param2 != -1 ? param2 : InstanceMng.getApplication().getFullScreenHeight();
         var _loc5_:Boolean = false;
         if(isIOS())
         {
            _loc6_ = Layout.getAppleDevice(_loc3_,_loc4_);
            _loc5_ = _loc6_ == Layout.IPHONE4 || _loc6_ == Layout.IPHONE5;
         }
         return _loc5_;
      }
      
      public static function isIphone4(param1:int = -1, param2:int = -1) : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc3_:Boolean = false;
         if(isIOS())
         {
            _loc4_ = param1 != -1 ? param1 : InstanceMng.getApplication().getFullScreenWidth();
            _loc5_ = param2 != -1 ? param2 : InstanceMng.getApplication().getFullScreenHeight();
            _loc6_ = Layout.getAppleDevice(_loc4_,_loc5_);
            _loc3_ = _loc6_ == Layout.IPHONE4;
         }
         return _loc3_;
      }
      
      public static function isIphone5(param1:int = -1, param2:int = -1) : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc3_:Boolean = false;
         if(isIOS())
         {
            _loc4_ = param1 != -1 ? param1 : InstanceMng.getApplication().getFullScreenWidth();
            _loc5_ = param2 != -1 ? param2 : InstanceMng.getApplication().getFullScreenHeight();
            _loc6_ = Layout.getAppleDevice(_loc4_,_loc5_);
            _loc3_ = _loc6_ == Layout.IPHONE5;
         }
         return _loc3_;
      }
      
      public static function isBrowser() : Boolean
      {
         return Boolean(InstanceMng.getApplication()) && InstanceMng.getApplication().isBrowserVersion();
      }
      
      public static function isIpad3() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = Capabilities.manufacturer.indexOf("iOS") != -1;
         var _loc3_:String = Capabilities.os;
         var _loc4_:String = _loc3_.toLowerCase();
         if(_loc4_.indexOf("ipad3,") >= 0)
         {
            _loc1_ = true;
         }
         return _loc1_;
      }
      
      public static function getShopItemByProdId(param1:String) : Def
      {
         var _loc2_:Def = null;
         var _loc3_:PacksDefMng = InstanceMng.getPacksDefMng();
         var _loc4_:CardDefMng = InstanceMng.getUnitsDefMng();
         var _loc5_:CardDefMng = InstanceMng.getAttachmentsDefMng();
         var _loc6_:CardDefMng = InstanceMng.getActionsDefMng();
         var _loc7_:BoostsDefMng = InstanceMng.getBoostsDefMng();
         var _loc8_:ShopBoostDefMng = InstanceMng.getShopBoostsDefMng();
         var _loc9_:DeckSlotDefMng = InstanceMng.getDeckSlotsDefMng();
         var _loc10_:GoldDefMng = InstanceMng.getGoldDefMng();
         var _loc11_:BundlesDefMng = InstanceMng.getBundlesDefMng();
         if(_loc3_)
         {
            _loc2_ = _loc3_.getDefByProdId(param1);
            if(_loc2_ != null)
            {
               return _loc2_;
            }
         }
         if(_loc4_)
         {
            _loc2_ = _loc4_.getDefByProdId(param1);
            if(_loc2_ != null)
            {
               return _loc2_;
            }
         }
         if(_loc5_)
         {
            _loc2_ = _loc5_.getDefByProdId(param1);
            if(_loc2_ != null)
            {
               return _loc2_;
            }
         }
         if(_loc6_)
         {
            _loc2_ = _loc6_.getDefByProdId(param1);
            if(_loc2_ != null)
            {
               return _loc2_;
            }
         }
         if(_loc7_)
         {
            _loc2_ = _loc7_.getDefByProdId(param1);
            if(_loc2_ != null)
            {
               return _loc2_;
            }
         }
         if(_loc8_)
         {
            _loc2_ = _loc8_.getDefByProdId(param1);
            if(_loc2_ != null)
            {
               return _loc2_;
            }
         }
         if(_loc9_)
         {
            _loc2_ = _loc9_.getDefByProdId(param1);
            if(_loc2_ != null)
            {
               return _loc2_;
            }
         }
         if(_loc10_)
         {
            _loc2_ = _loc10_.getDefByProdId(param1);
            if(_loc2_ != null)
            {
               return _loc2_;
            }
         }
         if(_loc11_)
         {
            _loc2_ = _loc11_.getDefByProdId(param1);
            if(_loc2_ != null)
            {
               return _loc2_;
            }
         }
         return _loc2_;
      }
      
      public static function getShopItemByShortCode(param1:String) : Def
      {
         var _loc2_:Def = null;
         var _loc3_:UnitDef = UnitDef(InstanceMng.getUnitsDefMng().getDefByVGoodShortCode(param1));
         if(_loc3_)
         {
            return _loc3_;
         }
         var _loc4_:AttachmentDef = AttachmentDef(InstanceMng.getAttachmentsDefMng().getDefByVGoodShortCode(param1));
         if(_loc4_)
         {
            return _loc4_;
         }
         var _loc5_:ActionDef = ActionDef(InstanceMng.getActionsDefMng().getDefByVGoodShortCode(param1));
         if(_loc5_)
         {
            return _loc5_;
         }
         var _loc6_:PackDef = PackDef(InstanceMng.getPacksDefMng().getDefByVGoodShortCode(param1));
         if(_loc6_)
         {
            return _loc6_;
         }
         var _loc7_:GoldDef = GoldDef(InstanceMng.getGoldDefMng().getDefByVGoodShortCode(param1));
         if(_loc7_)
         {
            return _loc7_;
         }
         var _loc8_:AuctionTicketDef = AuctionTicketDef(InstanceMng.getAuctionTicketsDefMng().getDefByVGoodShortCode(param1));
         if(_loc8_)
         {
            return _loc8_;
         }
         var _loc9_:ShopBoostDef = ShopBoostDef(InstanceMng.getShopBoostsDefMng().getDefByVGoodShortCode(param1));
         if(_loc9_)
         {
            return _loc9_;
         }
         var _loc10_:BoostDef = BoostDef(InstanceMng.getBoostsDefMng().getDefByVGoodShortCode(param1));
         if(_loc10_)
         {
            return _loc10_;
         }
         var _loc11_:BundleDef = BundleDef(InstanceMng.getBundlesDefMng().getDefByVGoodShortCode(param1));
         if(_loc11_)
         {
            return _loc11_;
         }
         var _loc12_:DeckSlotDef = DeckSlotDef(InstanceMng.getDeckSlotsDefMng().getDefByVGoodShortCode(param1));
         if(_loc12_)
         {
            return _loc12_;
         }
         var _loc13_:HeroCharacterDef = HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefByVGoodShortCode(param1));
         if(_loc13_)
         {
            return _loc13_;
         }
         return _loc2_;
      }
      
      public static function isTablet(param1:Stage = null) : Boolean
      {
         var gcd:Function;
         var w:Number = NaN;
         var h:Number = NaN;
         var r:Number = NaN;
         var currentAspectRatio:Number = NaN;
         var aspectRatio16_9:Number = NaN;
         var stageParam:Stage = param1;
         var stageToCheck:Stage = stageParam == null ? Starling.current.nativeStage : stageParam;
         if(isDesktop())
         {
            gcd = function(param1:Number, param2:Number):Number
            {
               return param2 == 0 ? param1 : Number(gcd(param2,param1 % param2));
            };
            w = Capabilities.screenResolutionX;
            h = Capabilities.screenResolutionY;
            r = gcd(w,h);
            currentAspectRatio = w / h;
            aspectRatio16_9 = 1920 / 1080;
            return currentAspectRatio != aspectRatio16_9;
         }
         if(isBrowser())
         {
            return true;
         }
         return DeviceCapabilities.isTablet(stageToCheck);
      }
      
      public static function setStat(param1:String, param2:Number) : void
      {
         if(InstanceMng.getApplication().isKongregateVersion() || isDesktop())
         {
            InstanceMng.getApplication().submitStat(param1,param2);
         }
      }
      
      public static function HexToRGB(param1:uint) : Object
      {
         var _loc2_:Object = new Object();
         _loc2_.r = param1 >> 16 & 0xFF;
         _loc2_.g = param1 >> 8 & 0xFF;
         _loc2_.b = param1 & 0xFF;
         return _loc2_;
      }
      
      public static function RGBToHEX(param1:Object) : String
      {
         var _loc2_:int = param1.r << 16 | param1.g << 8 | param1.b;
         var _loc3_:String = _loc2_.toString(16);
         return "#" + (_loc3_.length < 6 ? "0" + _loc3_ : _loc3_);
      }
      
      public static function godModeAddCardsToCollection(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(Boolean(param1) && param1 != "")
         {
            _loc2_ = param1.split(",");
            if(Boolean(_loc2_) && _loc2_.length > 0)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc2_.length)
               {
                  InstanceMng.getUserDataMng().getOwnerUserData().addCardToCollection(_loc2_[_loc5_]);
                  _loc5_++;
               }
            }
         }
      }
      
      public static function godModeRemoveCardsToCollection(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(Boolean(param1) && param1 != "")
         {
            _loc2_ = param1.split(",");
            if(Boolean(_loc2_) && _loc2_.length > 0)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc2_.length)
               {
                  InstanceMng.getUserDataMng().getOwnerUserData().removeCardFromCollection(_loc2_[_loc5_].split(":")[0],_loc2_[_loc5_].split(":")[1]);
                  _loc5_++;
               }
            }
         }
      }
      
      public static function godModeAddCardsToDeck(param1:int, param2:String) : void
      {
         godModeAddCardsToCollection(param2);
         InstanceMng.getUserDataMng().getOwnerUserData().setDeck(param2.split(","),param1);
      }
      
      public static function godModeAddAllCardsToCollection(param1:String = "") : void
      {
         var _loc6_:CardDef = null;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc11_:Boolean = false;
         var _loc12_:Dictionary = null;
         var _loc13_:Dictionary = null;
         if(Config.getConfig().gameHasAttachments())
         {
            _loc12_ = InstanceMng.getAttachmentsDefMng().getAllDefs();
         }
         if(Config.getConfig().gameHasPowers())
         {
            _loc13_ = InstanceMng.getPowerDefMng().getAllDefs();
         }
         var _loc2_:Dictionary = InstanceMng.getUnitsDefMng().getAllDefs();
         var _loc3_:Dictionary = InstanceMng.getActionsDefMng().getAllDefs();
         var _loc4_:UserData = Utils.getOwnerUserData();
         var _loc5_:Array = new Array();
         var _loc10_:int = 2;
         for each(_loc6_ in _loc2_)
         {
            if(_loc6_.getTier() == 1 && _loc6_.getEnhanceLevel() == 0 && _loc6_.getIsVisible())
            {
               _loc9_ = Math.min(_loc10_,_loc6_.getMaxAmountOndeck());
               _loc11_ = param1 == "" || param1 != "" && Boolean(_loc6_.getEditionSku());
               if(_loc11_)
               {
                  _loc5_[_loc8_] = _loc6_.getSku() + ":" + _loc9_;
                  _loc8_++;
               }
            }
         }
         if(_loc12_)
         {
            for each(_loc6_ in _loc12_)
            {
               if(_loc6_.getTier() == 1 && _loc6_.getEnhanceLevel() == 0 && _loc6_.getIsVisible())
               {
                  _loc9_ = Math.min(_loc10_,_loc6_.getMaxAmountOndeck());
                  _loc11_ = param1 == "" || param1 != "" && Boolean(_loc6_.getEditionSku());
                  if(_loc11_)
                  {
                     _loc5_[_loc8_] = _loc6_.getSku() + ":" + _loc9_;
                     _loc8_++;
                  }
               }
            }
         }
         if(_loc13_)
         {
            for each(_loc6_ in _loc13_)
            {
               if(_loc6_.getTier() == 1 && _loc6_.getEnhanceLevel() == 0 && _loc6_.getIsVisible())
               {
                  _loc9_ = Math.min(_loc10_,_loc6_.getMaxAmountOndeck());
                  _loc11_ = param1 == "" || param1 != "" && Boolean(_loc6_.getEditionSku());
                  if(_loc11_)
                  {
                     _loc5_[_loc8_] = _loc6_.getSku() + ":" + _loc9_;
                     _loc8_++;
                  }
               }
            }
         }
         for each(_loc6_ in _loc3_)
         {
            if(_loc6_.getEnhanceLevel() == 0 && _loc6_.getIsVisible())
            {
               _loc9_ = Math.min(_loc10_,_loc6_.getMaxAmountOndeck());
               _loc11_ = param1 == "" || param1 != "" && Boolean(_loc6_.getEditionSku());
               if(_loc11_)
               {
                  _loc5_[_loc8_] = _loc6_.getSku() + ":" + _loc9_;
                  _loc8_++;
               }
            }
         }
         if(_loc5_.length > 0)
         {
            _loc4_.purgeCardsCollection();
            _loc4_.setCardCollection(_loc5_);
         }
         FSDebug.debugTrace("All cards added to the user\'s collection");
      }
      
      public static function getDefaultSpeedTime() : Number
      {
         return Config.getConfig().getDefaultGeneralSpeedFactor();
      }
      
      public static function getAngle(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return Math.atan2(param2 - param4,param1 - param3) * (180 / Math.PI);
      }
      
      public static function getDeviceInfo() : Object
      {
         var _loc1_:Object = {};
         if(InstanceMng.getServerConnection())
         {
            InstanceMng.getServerConnection().addCommonEntityAttributes(_loc1_);
         }
         _loc1_["Cap_cpuArchitecture"] = Capabilities.cpuArchitecture;
         _loc1_["Cap_avHardwareDisable"] = Capabilities.avHardwareDisable;
         _loc1_["Cap_hasAudio"] = Capabilities.hasAudio;
         _loc1_["Cap_hasAudioEncoder"] = Capabilities.hasAudioEncoder;
         _loc1_["Cap_hasEmbeddedVideo"] = Capabilities.hasEmbeddedVideo;
         _loc1_["Cap_hasMP3"] = Capabilities.hasMP3;
         _loc1_["Cap_language"] = Capabilities.language;
         _loc1_["Cap_localFileReadDisable"] = Capabilities.localFileReadDisable;
         _loc1_["Cap_manufacturer"] = Capabilities.manufacturer;
         _loc1_["Cap_pixelAspectRatio"] = Capabilities.pixelAspectRatio;
         _loc1_["Cap_playerType"] = Capabilities.playerType;
         _loc1_["Cap_screenColor"] = Capabilities.screenColor;
         _loc1_["Cap_screenDPI"] = Capabilities.screenDPI;
         _loc1_["Cap_screenResolutionX"] = Capabilities.screenResolutionX;
         _loc1_["Cap_screenResolutionY"] = Capabilities.screenResolutionY;
         _loc1_["Cap_osVersion"] = Capabilities.version.toString();
         if(isMobile())
         {
            _loc1_ = InstanceMng.getApplication().getDeviceExtraInfo(_loc1_);
         }
         return _loc1_;
      }
      
      private static function getSoundManagerInstance() : *
      {
         return SoundManager.getInstance();
      }
      
      public static function playSound(param1:String, param2:int) : void
      {
         if(getSoundManagerInstance())
         {
            getSoundManagerInstance().playSound(param1,param2);
         }
      }
      
      public static function getLastMusic() : String
      {
         if(getSoundManagerInstance())
         {
            return getSoundManagerInstance().getLastMusic();
         }
         return "";
      }
      
      public static function stopSound(param1:String) : void
      {
         if(getSoundManagerInstance())
         {
            getSoundManagerInstance().stopSound(param1);
         }
      }
      
      public static function resumeAllSounds() : void
      {
         if(getSoundManagerInstance())
         {
            getSoundManagerInstance().resumeAll();
         }
      }
      
      public static function pauseAllSounds() : void
      {
         if(getSoundManagerInstance())
         {
            getSoundManagerInstance().pauseAll();
         }
      }
      
      public static function stopAllSounds(param1:Boolean = false, param2:Boolean = false) : void
      {
         if(getSoundManagerInstance())
         {
            getSoundManagerInstance().stopAll(param1,param2);
         }
      }
      
      public static function getTrackList() : Vector.<String>
      {
         if(getSoundManagerInstance())
         {
            return getSoundManagerInstance().getTrackList();
         }
         return null;
      }
      
      public static function loadNextTrack(param1:Boolean = false) : void
      {
         if(getSoundManagerInstance())
         {
            getSoundManagerInstance().loadNextTrack(param1);
         }
      }
      
      public static function addTrackList(param1:Vector.<String>) : void
      {
         if(getSoundManagerInstance())
         {
            getSoundManagerInstance().addTrackList(param1);
         }
      }
      
      public static function isSFXOn() : Boolean
      {
         if(getSoundManagerInstance())
         {
            return getSoundManagerInstance().isSfxOn();
         }
         return false;
      }
      
      public static function isMusicOn() : Boolean
      {
         if(getSoundManagerInstance())
         {
            return getSoundManagerInstance().isMusicOn();
         }
         return false;
      }
      
      public static function setSFXOn(param1:Boolean) : void
      {
         if(getSoundManagerInstance())
         {
            getSoundManagerInstance().setSfxOn(param1);
         }
      }
      
      public static function setMusicOn(param1:Boolean) : void
      {
         if(getSoundManagerInstance())
         {
            getSoundManagerInstance().setMusicOn(param1);
         }
      }
      
      public static function removeSound(param1:String) : void
      {
         if(getSoundManagerInstance())
         {
            getSoundManagerInstance().removeSound(param1);
         }
      }
      
      public static function parseJSONData(param1:*) : Object
      {
         return param1 != null && param1 != "" ? {"now":new Date(param1).toString()} : null;
      }
      
      public static function getNextTierCardDef(param1:String) : CardDef
      {
         var _loc2_:CardDef = CardDef(InstanceMng.getCardsDefMng().getDefBySku(param1));
         var _loc3_:CardDef = null;
         if(Boolean(_loc2_) && Boolean(_loc2_.getUpgradeSku() != null) && _loc2_.getUpgradeSku() != "")
         {
            _loc3_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc2_.getUpgradeSku()));
         }
         return _loc3_;
      }
      
      public static function getTopTierCardDef(param1:String) : CardDef
      {
         var _loc3_:String = null;
         var _loc2_:CardDef = null;
         _loc2_ = getNextTierCardDef(param1);
         if(_loc2_)
         {
            _loc3_ = _loc2_.getUpgradeSku();
            if(_loc3_ != "" && _loc3_ != null)
            {
               _loc2_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc3_));
            }
         }
         return _loc2_;
      }
      
      public static function getPreviousTierCardDef(param1:String) : CardDef
      {
         var _loc2_:CardDef = CardDef(InstanceMng.getCardsDefMng().getDefBySku(param1));
         var _loc3_:CardDef = null;
         return CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc2_.getPreviousUpgradeSku()));
      }
      
      public static function getBaseTierCardDef(param1:String) : CardDef
      {
         var _loc3_:String = null;
         var _loc2_:CardDef = null;
         _loc2_ = getPreviousTierCardDef(param1);
         if(_loc2_)
         {
            _loc3_ = _loc2_.getPreviousUpgradeSku();
            if(_loc3_ != "" && _loc3_ != null)
            {
               _loc2_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc3_));
            }
         }
         return _loc2_;
      }
      
      public static function getTooltipContent(param1:String) : *
      {
         var _loc2_:* = null;
         if(!textHasGlyphs(param1))
         {
            _loc2_ = new BitmapFontTextRenderer();
            _loc2_.text = param1;
            _loc2_.textFormat = new BitmapFontTextFormat(FSResourceMng.getFontByType(),FSResourceMng.FONT_STD_SEMI_SMALL_SIZE,16777215,TextFormatAlign.CENTER);
            _loc2_.wordWrap = true;
         }
         else
         {
            _loc2_ = new Label();
            _loc2_.text = param1;
            Label(_loc2_).wordWrap = true;
            Label(_loc2_).styleNameList.add("custom-label");
         }
         return _loc2_;
      }
      
      public static function coolFormat(param1:Number, param2:int) : String
      {
         var _loc5_:Number = NaN;
         var _loc3_:Number = param1 / 100 / 10;
         var _loc4_:Boolean = _loc3_ * 10 % 10 == 0;
         var _loc6_:String = "";
         if(_loc3_ < 1000)
         {
            if(_loc3_ > 99.9 || _loc4_ || !_loc4_ && _loc3_ > 9.99)
            {
               _loc5_ = _loc3_ * 10 / 10;
            }
            else
            {
               _loc5_ = _loc3_;
            }
            _loc6_ = _loc5_.toFixed(2) + "";
            if(_loc5_ > 1)
            {
               _loc6_ += "" + smNumberFormatArr[param2];
            }
            else
            {
               _loc6_ = param1.toString();
            }
         }
         else
         {
            _loc6_ = coolFormat(_loc3_,param2 + 1);
         }
         return _loc6_;
      }
      
      public static function formatNumber(param1:Number) : String
      {
         var _loc4_:String = null;
         var _loc2_:String = String(param1);
         var _loc3_:String = "";
         while(_loc2_.length > 3)
         {
            _loc4_ = _loc2_.substr(-3);
            _loc2_ = _loc2_.substr(0,_loc2_.length - 3);
            _loc3_ = "." + _loc4_ + _loc3_;
         }
         _loc3_ = _loc2_ + _loc3_;
         return _loc2_.length ? (_loc3_) : _loc3_;
      }
      
      public static function removeImageFromParent(param1:FSImage) : void
      {
         if(param1)
         {
            param1.removeFromParent();
         }
      }
      
      public static function drawShapeOnScreen(param1:Number, param2:Number, param3:int = 5) : void
      {
         var _loc4_:Quad = new Quad(5,5,16711680);
         _loc4_.alignPivot();
         _loc4_.x = param1;
         _loc4_.y = param2;
         if(Boolean(InstanceMng.getApplication()) && Boolean(InstanceMng.getApplication().getStarling()) && Boolean(InstanceMng.getApplication().getStarling().stage))
         {
            InstanceMng.getApplication().getStarling().stage.addChild(_loc4_);
         }
         TweenMax.delayedCall(param3,removeShape,[_loc4_]);
      }
      
      private static function removeShape(param1:Quad) : void
      {
         param1.removeFromParent();
      }
      
      public static function rollCoins(param1:FSNumber, param2:FSNumber) : FSNumber
      {
         var _loc3_:FSNumber = null;
         if(param1.value == -1)
         {
            _loc3_ = param2;
         }
         else
         {
            _loc3_ = new FSNumber(Utils.randomInt(param1.value,param2.value));
         }
         return _loc3_;
      }
      
      public static function scaleBitmapData(param1:BitmapData, param2:Number) : BitmapData
      {
         param2 = Math.abs(param2);
         var _loc3_:int = int(int(param1.width * param2) || 1);
         var _loc4_:int = int(int(param1.height * param2) || 1);
         var _loc5_:Boolean = param1.transparent;
         var _loc6_:BitmapData = new BitmapData(_loc3_,_loc4_,_loc5_);
         var _loc7_:Matrix = new Matrix();
         _loc7_.scale(param2,param2);
         _loc6_.draw(param1,_loc7_);
         return _loc6_;
      }
      
      public static function isSeasonActive(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:Boolean = false;
         if(ServerConnection.smServerTimeMS != -1 && param1 != -1 && param2 != -1)
         {
            _loc3_ = ServerConnection.smServerTimeMS > param1 && ServerConnection.smServerTimeMS < param2;
         }
         return _loc3_;
      }
      
      public static function getSeasonTimeLeftString(param1:Number, param2:Number, param3:Boolean) : String
      {
         var _loc7_:Boolean = false;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc4_:String = "";
         var _loc5_:Number = -1;
         if(ServerConnection.smServerTimeMS != -1 && param1 != -1 && param2 != -1)
         {
            _loc5_ = ServerConnection.smServerTimeMS < param1 ? param1 - ServerConnection.smServerTimeMS : param2 - ServerConnection.smServerTimeMS;
         }
         var _loc6_:String = "";
         if(param3 || !param3 && param1 > ServerConnection.smServerTimeMS)
         {
            if(_loc5_ != -1 && _loc5_ > 0)
            {
               _loc7_ = TimerUtil.msToDays(_loc5_) > 0;
               _loc8_ = _loc7_ ? TextManager.getText("TID_GEN_TIME_DAYS_ABR",true) + " " : null;
               _loc9_ = _loc7_ ? TextManager.getText("TID_GEN_TIME_HOURS_ABR",true) + " " : ":";
               _loc10_ = _loc7_ ? null : ":";
               _loc11_ = _loc7_ ? null : "";
               _loc6_ = " " + TimerUtil.getTimeTextFromMs(_loc5_,_loc8_,_loc9_,_loc10_,_loc11_);
            }
            else if(_loc5_ < 0)
            {
               _loc5_ *= -1;
               _loc7_ = TimerUtil.msToDays(_loc5_) > 0;
               _loc8_ = _loc7_ ? TextManager.getText("TID_GEN_TIME_DAYS_ABR",true) + " " : null;
               _loc9_ = _loc7_ ? TextManager.getText("TID_GEN_TIME_HOURS_ABR",true) + " " : ":";
               _loc10_ = _loc7_ ? null : ":";
               _loc11_ = _loc7_ ? null : "";
               _loc6_ = " " + TimerUtil.getTimeTextFromMs(_loc5_,_loc8_,_loc9_,_loc10_,_loc11_);
            }
         }
         _loc6_ = _loc6_ == null ? "" : _loc6_;
         return _loc5_ != -1 && _loc5_ > 0 ? _loc6_ : " ???";
      }
      
      public static function showSyncIcon(param1:Boolean, param2:String = "left", param3:String = "top") : void
      {
         var _loc4_:Screen = InstanceMng.getCurrentScreen();
         if(_loc4_ != null)
         {
            _loc4_.showLoadingIcon(param1,false,param2,param3,1);
         }
      }
      
      public static function encodeBase64(param1:String) : String
      {
         return String(InstanceMng.getApplication().getBase64().encode(param1));
      }
      
      public static function decodeBase64(param1:String) : Number
      {
         return Number(InstanceMng.getApplication().getBase64().decode(param1));
      }
      
      public static function decodeBase64Str(param1:String) : String
      {
         return String(InstanceMng.getApplication().getBase64().decode(param1));
      }
      
      public static function parseQueryToJSON(param1:String) : Object
      {
         param1 = param1 == "" ? "{}" : param1;
         var _loc2_:RegExp = /'/g;
         var _loc3_:String = param1.replace(_loc2_,"\"");
         return JSON.parse(_loc3_);
      }
      
      public static function requestScreenShake(param1:Number = 1, param2:Number = 3) : void
      {
         smShakeRequested = true;
         smShakeMagnitude = param2;
         TweenMax.killDelayedCallsTo(requestScreenShake);
         TweenMax.delayedCall(param1,stopShake);
      }
      
      public static function shakeScreen() : void
      {
         var _loc5_:Component = null;
         var _loc1_:Boolean = Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) ? InstanceMng.getUserDataMng().getOwnerUserData().flagsGetScreenShakeON() : false;
         if(!_loc1_)
         {
            return;
         }
         var _loc2_:Number = Utils.randomNumber(-smShakeMagnitude,smShakeMagnitude);
         var _loc3_:Number = Utils.randomNumber(-smShakeMagnitude,smShakeMagnitude);
         var _loc4_:Screen = InstanceMng.getCurrentScreen();
         if(_loc4_ != null)
         {
            _loc5_ = _loc4_;
            if(_loc5_)
            {
               if(_loc5_.x + _loc2_ > -smShakeMagnitude && _loc5_.x + _loc2_ < smShakeMagnitude)
               {
                  _loc5_.x += _loc2_;
               }
               if(_loc5_.y + _loc3_ > -smShakeMagnitude && _loc5_.y + _loc3_ < smShakeMagnitude)
               {
                  _loc5_.y += _loc3_;
               }
            }
         }
      }
      
      public static function stopShake() : void
      {
         smShakeRequested = false;
         if(InstanceMng.getCurrentScreen())
         {
            InstanceMng.getCurrentScreen().x = 0;
            InstanceMng.getCurrentScreen().y = 0;
         }
      }
      
      public static function getDataId(param1:Object) : String
      {
         var _loc2_:String = "";
         if(param1)
         {
            _loc2_ = param1.hasOwnProperty("_id") && Boolean(param1["_id"].hasOwnProperty("$oid")) ? param1._id.$oid : null;
         }
         return _loc2_;
      }
      
      public static function getRewardsToClaimSummary(param1:RewardDef) : Object
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Dictionary = null;
         var _loc7_:Array = null;
         var _loc8_:PackDef = null;
         var _loc2_:Object = null;
         if(param1)
         {
            if(param1)
            {
               if(param1.getGold() > 0)
               {
                  if(_loc2_ == null)
                  {
                     _loc2_ = new Object();
                  }
                  _loc2_.hasGold = true;
                  _loc2_.gold = param1.getGold();
               }
               if(param1.getRaidCoins() > 0)
               {
                  if(_loc2_ == null)
                  {
                     _loc2_ = new Object();
                  }
                  _loc2_.hasRaidCoins = true;
                  _loc2_.raidCoins = param1.getRaidCoins();
               }
               _loc6_ = param1.getCards();
               if(_loc6_)
               {
                  if(_loc2_ == null)
                  {
                     _loc2_ = new Object();
                  }
                  _loc2_.hasCards = true;
                  _loc7_ = DictionaryUtils.getKeys(_loc6_);
                  _loc4_ = 0;
                  while(_loc4_ < _loc7_.length)
                  {
                     _loc2_.cards = _loc2_.cards ? _loc2_.cards + "," + _loc7_[_loc4_] : _loc7_[_loc4_];
                     _loc4_++;
                  }
               }
               if(param1.getPackSku())
               {
                  _loc8_ = PackDef(InstanceMng.getPacksDefMng().getDefBySku(param1.getPackSku()));
                  if(_loc8_.areCardsPredefined())
                  {
                     if(_loc2_ == null)
                     {
                        _loc2_ = new Object();
                     }
                     _loc2_.hasPacks = true;
                     _loc2_.packs = param1.getPackSku();
                  }
               }
            }
            if(Boolean(_loc2_ != null) && Boolean(_loc2_.hasCards) && Boolean(_loc2_.cards))
            {
               _loc2_.cards = DictionaryUtils.sortCardArrByCardValue(String(_loc2_.cards).split(","));
            }
         }
         else
         {
            FSDebug.debugTrace("There are no rewards to claim");
         }
         return _loc2_;
      }
      
      public static function getBundleRewardsToClaimSummary(param1:BundleDef) : Object
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:Object = null;
         if(param1)
         {
            if(param1.getGold() > 0)
            {
               if(_loc2_ == null)
               {
                  _loc2_ = new Object();
               }
               _loc2_.hasGold = true;
               _loc2_.gold = param1.getGold();
            }
            if(param1.getRaidPoints() > 0)
            {
               if(_loc2_ == null)
               {
                  _loc2_ = new Object();
               }
               _loc2_.hasRaidPoints = true;
               _loc2_.raidPoints = param1.getRaidPoints();
            }
            if(param1.getQuestPoints() > 0)
            {
               if(_loc2_ == null)
               {
                  _loc2_ = new Object();
               }
               _loc2_.hasQuestPoints = true;
               _loc2_.questPoints = param1.getQuestPoints();
            }
            if(param1.getAHTokens() > 0)
            {
               if(_loc2_ == null)
               {
                  _loc2_ = new Object();
               }
               _loc2_.hasAHTokens = true;
               _loc2_.AHTokens = param1.getAHTokens();
            }
            if(param1.getCards())
            {
               if(_loc2_ == null)
               {
                  _loc2_ = new Object();
               }
               _loc2_.hasCards = true;
               _loc2_.cards = param1.getCards().join(",");
            }
            if(param1.getPacks())
            {
               if(_loc2_ == null)
               {
                  _loc2_ = new Object();
               }
               _loc2_.hasPacks = true;
               _loc2_.packs = param1.getPacks().join(",");
            }
            if(param1.getSkins())
            {
               if(_loc2_ == null)
               {
                  _loc2_ = new Object();
               }
               _loc2_.hasSkins = true;
               _loc2_.skins = param1.getSkins().join(",");
            }
            if(param1.getBoosts())
            {
               if(_loc2_ == null)
               {
                  _loc2_ = new Object();
               }
               _loc2_.hasBoosts = true;
               _loc2_.boosts = param1.getBoosts().join(",");
            }
            if(Boolean(_loc2_ != null) && Boolean(_loc2_.hasCards) && Boolean(_loc2_.cards))
            {
               _loc2_.cards = DictionaryUtils.sortCardArrByCardValue(String(_loc2_.cards).split(","));
            }
         }
         else
         {
            FSDebug.debugTrace("There are no rewards to claim");
         }
         return _loc2_;
      }
      
      public static function calculateZMovement(param1:Number, param2:FSSprite3D) : Number
      {
         return -Math.tan(Math.abs(param2.rotationX)) * param1;
      }
      
      public static function getSWFCoordinates(param1:Number, param2:Number) : FSCoordinate
      {
         var _loc3_:Number = Utils.getMapScaleFactor();
         var _loc4_:FSCoordinate = new FSCoordinate();
         _loc4_.mX = param1 * (_loc3_ / Main.smScaleFactor);
         _loc4_.mY = param2 * (_loc3_ / Main.smScaleFactor);
         return _loc4_;
      }
      
      public static function getMapScaleFactor() : Number
      {
         return Utils.isIOS() ? 1 : Constants.SCALE_ANDROID * (Main.smScaleFactor / 2);
      }
      
      public static function showNotEnoughCurrencyMessage(param1:String, param2:Boolean = false) : void
      {
         var _loc4_:GoldDef = null;
         var _loc3_:String = "";
         switch(param1)
         {
            case ServerConnection.CURRENCY_GOLD:
               _loc3_ = "TID_GOLD_NOT_ENOUGH";
               if(param2)
               {
                  _loc4_ = GoldDef(InstanceMng.getGoldDefMng().getDefBySku("gold_01"));
                  if(_loc4_)
                  {
                     InstanceMng.getPopupMng().openBuyGoldBagPopup(_loc4_);
                  }
               }
               break;
            case ServerConnection.CURRENCY_QUEST_COINS:
               _loc3_ = "TID_QUEST_POINTS_NOT_ENOUGH";
               break;
            case ServerConnection.CURRENCY_RAID_COINS:
               _loc3_ = "TID_RAID_POINTS_NOT_ENOUGH";
         }
         Utils.setLogText(TextManager.getText(_loc3_),true);
      }
      
      public static function getConf(param1:String) : *
      {
         return Config.smServerConfig ? Config.smServerConfig[param1] : null;
      }
      
      public static function openPack(param1:PackDef, param2:String, param3:FSShopItem = null, param4:Boolean = false, param5:String = "") : void
      {
         var _loc6_:Object = null;
         Screen.smOpeningPack = true;
         _loc6_ = getCardsRolled(_loc6_,param2,param1,param3);
         param5 = param5 == "" ? param1.getSku() : param5;
         if(Boolean(InstanceMng.getPopupMng().getPopupShown()) && !(InstanceMng.getPopupMng().getPopupShown() is PopupShopItem))
         {
            InstanceMng.getPopupMng().getPopupShown().hideTemporarily(unfoldPack,[param2,_loc6_,param4,param5]);
         }
         else
         {
            unfoldPack(param2,_loc6_,param4,param5);
         }
      }
      
      public static function claimBundleRewards(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:UserData = null;
         var _loc4_:Number = NaN;
         var _loc5_:Array = null;
         if(param1)
         {
            _loc3_ = Utils.getOwnerUserData();
            _loc4_ = 0;
            if(param1["hasGold"])
            {
               _loc3_.addGold(param1["gold"]);
            }
            if(param1["hasRaidPoints"])
            {
               _loc3_.addRaidCoins(param1["raidPoints"]);
            }
            if(param1["hasQuestPoints"])
            {
               _loc3_.addQuestsCoins(param1["questPoints"]);
            }
            if(param1["hasAHTokens"])
            {
               _loc3_.addAuctionTickets(param1["AHTokens"]);
            }
            if(param1["hasPortraits"])
            {
               _loc5_ = param1["portraits"].split(",");
               _loc2_ = 0;
               while(_loc2_ < _loc5_.length)
               {
                  _loc3_.addPortraitToCatalog(_loc5_[_loc2_]);
                  _loc2_++;
               }
            }
            if(param1["hasSkins"])
            {
               _loc5_ = param1["skins"].split(",");
               _loc2_ = 0;
               while(_loc2_ < _loc5_.length)
               {
                  _loc3_.addSkinToCatalog(_loc5_[_loc2_]);
                  _loc2_++;
               }
            }
            if(param1["hasBoosts"])
            {
               _loc5_ = param1["boosts"].split(",");
               _loc2_ = 0;
               while(_loc2_ < _loc5_.length)
               {
                  _loc3_.addBoostToCatalog(String(_loc5_[_loc2_]).split(":")[0],String(_loc5_[_loc2_]).split(":")[1]);
                  _loc2_++;
               }
            }
            if(param1["hasCards"])
            {
               _loc5_ = param1["cards"].split(",");
               _loc2_ = 0;
               while(_loc2_ < _loc5_.length)
               {
                  _loc3_.addCardToCollection(_loc5_[_loc2_] + ":1");
                  _loc3_.addCardToNewCardsCollection(_loc5_[_loc2_] + ":1");
                  _loc2_++;
               }
            }
         }
         InstanceMng.getUserDataMng().persistenceSaveData();
      }
      
      public static function openBundle(param1:BundleDef, param2:String, param3:FSShopItem = null, param4:Boolean = false, param5:String = "") : void
      {
         Screen.smOpeningPack = true;
         var _loc6_:Object = getBundleRewardsToClaimSummary(param1);
         param5 = param5 == "" ? param1.getSku() : param5;
         claimBundleRewards(_loc6_);
         if(Boolean(InstanceMng.getPopupMng().getPopupShown()) && !(InstanceMng.getPopupMng().getPopupShown() is PopupShopItem))
         {
            InstanceMng.getPopupMng().getPopupShown().hideTemporarily(unfoldPack,[param2,_loc6_,param4,param5]);
         }
         else
         {
            unfoldPack(param2,_loc6_,param4,param5);
         }
      }
      
      private static function getCardsRolled(param1:Object, param2:String, param3:PackDef, param4:FSShopItem) : Object
      {
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:Dictionary = rollCardsPack(param3,param2,param4);
         if(_loc7_)
         {
            if(param1 == null)
            {
               param1 = new Object();
            }
            param1.hasCards = true;
            for each(_loc5_ in _loc7_)
            {
               param1.cards = param1.cards ? param1.cards + "," + _loc5_ : _loc5_;
            }
         }
         if(Boolean(param1 != null) && Boolean(param1.hasCards) && Boolean(param1.cards))
         {
            param1.cards = DictionaryUtils.sortCardArrByCardValue(String(param1.cards).split(","));
         }
         return param1;
      }
      
      public static function rollCardsPack(param1:PackDef, param2:String, param3:FSShopItem = null, param4:Boolean = false) : Dictionary
      {
         var returnValue:Dictionary = null;
         var i:int = 0;
         var j:int = 0;
         var cardsArr:Array = null;
         var raritiesPackCatalogs:Object = null;
         var raritiesAmountCatalog:Dictionary = null;
         var mixedRaritiesAmountCatalog:Dictionary = null;
         var raritiesAmountCatalogKeys:Array = null;
         var mixedRaritiesAmountCatalogKeys:Array = null;
         var raritySku:String = null;
         var eligibleCards:Dictionary = null;
         var eligibleCardsArr:Array = null;
         var randomValue:Number = NaN;
         var randomSkuChosen:String = null;
         var count:int = 0;
         var factionSkuFilter:String = null;
         var categorySkuFilter:String = null;
         var editionSkuFilter:String = null;
         var categoryIndex:int = 0;
         var subcategories:Array = null;
         var finalRarities:Dictionary = null;
         var stdRaritiesFound:int = 0;
         var mixedRandomRaritySku:String = null;
         var raritiesArr:Array = null;
         var packDef:PackDef = param1;
         var origin:String = param2;
         var shopItem:FSShopItem = param3;
         var isTest:Boolean = param4;
         var trackPackPurchase:Function = function(param1:String):void
         {
            var _loc2_:int = 0;
            if(param1)
            {
               if(shopItem)
               {
                  _loc2_ = shopItem.getInGameCurrencyCost();
                  if(shopItem.isQuestPack())
                  {
                     FSTracker.getInstance().trackQuestItemPurchase(packDef.getSku(),shopItem.getInGameCurrencyCost().toString(),param1);
                  }
                  else if(shopItem.isRaidsPack())
                  {
                     FSTracker.getInstance().trackRaidsPackPurchase(packDef.getSku(),shopItem.getInGameCurrencyCost().toString(),param1);
                  }
               }
               InstanceMng.getServerConnection().addPackPurchasedInstance(packDef.getSku(),_loc2_,param1,origin);
            }
         };
         var cardsToTrack:String = "";
         if(packDef)
         {
            cardsArr = packDef.getSpecialCardsArr();
            if(cardsArr != null)
            {
               i = 0;
               while(i < cardsArr.length)
               {
                  if(returnValue == null)
                  {
                     returnValue = new Dictionary(true);
                  }
                  returnValue[count] = String(cardsArr[i]).split(":")[0];
                  count++;
                  cardsToTrack += String(cardsArr[i]).split(":")[0] + ",";
                  i++;
               }
            }
            else
            {
               if(returnValue == null)
               {
                  returnValue = new Dictionary(true);
               }
               raritiesPackCatalogs = InstanceMng.getPacksDefMng().getPackRaritiesCatalogs(packDef);
               raritiesAmountCatalog = raritiesPackCatalogs.rarities;
               mixedRaritiesAmountCatalog = raritiesPackCatalogs.mixedRarities;
               raritiesAmountCatalogKeys = DictionaryUtils.getKeys(raritiesAmountCatalog);
               mixedRaritiesAmountCatalogKeys = DictionaryUtils.getKeys(mixedRaritiesAmountCatalog);
               raritiesAmountCatalogKeys.sort();
               mixedRaritiesAmountCatalogKeys.sort();
               count = 0;
               factionSkuFilter = packDef ? packDef.getFactionSku() : null;
               categorySkuFilter = packDef ? packDef.getCategorySku() : null;
               editionSkuFilter = packDef ? packDef.getEditionSku() : null;
               categoryIndex = categorySkuFilter ? CategoryDef(InstanceMng.getCategoriesDefMng().getDefBySku(categorySkuFilter)).getIndex() : -1;
               subcategories = categorySkuFilter ? packDef.getSubCategoriesArr() : null;
               finalRarities = new Dictionary(true);
               i = 0;
               while(i < raritiesAmountCatalogKeys.length)
               {
                  raritySku = raritiesAmountCatalogKeys[i];
                  eligibleCards = InstanceMng.getCardsDefMng().getAllCardsDefs(raritySku,1,factionSkuFilter,categoryIndex,editionSkuFilter,subcategories);
                  eligibleCardsArr = DictionaryUtils.getKeys(eligibleCards);
                  j = 0;
                  while(j < raritiesAmountCatalog[raritySku])
                  {
                     randomSkuChosen = Utils.getRandomItemFromArr(eligibleCardsArr);
                     if(randomSkuChosen != null)
                     {
                        finalRarities[raritySku] = isNaN(finalRarities[raritySku]) ? 1 : finalRarities[raritySku] + 1;
                        returnValue[count] = randomSkuChosen;
                        count++;
                        cardsToTrack += randomSkuChosen + ",";
                     }
                     j++;
                  }
                  i++;
               }
               stdRaritiesFound = count;
               i = 0;
               while(i < mixedRaritiesAmountCatalogKeys.length)
               {
                  mixedRandomRaritySku = getRandomRarityByChance(mixedRaritiesAmountCatalog[i + stdRaritiesFound + 1]);
                  if(mixedRandomRaritySku != null)
                  {
                     finalRarities[mixedRandomRaritySku] = isNaN(finalRarities[mixedRandomRaritySku]) ? 1 : finalRarities[mixedRandomRaritySku] + 1;
                     eligibleCards = InstanceMng.getCardsDefMng().getAllCardsDefs(mixedRandomRaritySku,1,factionSkuFilter,categoryIndex,editionSkuFilter,subcategories);
                     eligibleCardsArr = DictionaryUtils.getKeys(eligibleCards);
                     randomSkuChosen = Utils.getRandomItemFromArr(eligibleCardsArr);
                     returnValue[count] = randomSkuChosen;
                     count++;
                     cardsToTrack += randomSkuChosen + ",";
                  }
                  i++;
               }
               returnValue = DictionaryUtils.sortByCardValue(returnValue);
            }
            if(!isTest)
            {
               FSDebug.debugTrace("PACK TEST Results");
               raritiesArr = DictionaryUtils.getKeys(finalRarities);
               j = 0;
               while(j < raritiesArr.length)
               {
                  FSDebug.debugTrace(raritiesArr[j] + ": " + finalRarities[raritiesArr[j]]);
                  j++;
               }
               if(Config.getConfig().hasQuests())
               {
                  InstanceMng.getQuestsMng().addActionPerformed(QuestsMng.TARGET_TYPE_UNFOLD_PACK,1,false,[QuestsMng.TARGET_PACK_SKU + ":" + packDef.getSku()]);
               }
               trackPackPurchase(cardsToTrack);
            }
         }
         if(!isTest)
         {
            onPackUnfolded(returnValue,origin);
         }
         return returnValue;
      }
      
      private static function onPackUnfolded(param1:Dictionary, param2:String) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         if(param2 == PacksDefMng.PACK_REWARD_PREDEFINED)
         {
            return;
         }
         Utils.setStat(Constants.STAT_PACKS_UNFOLDED,1);
         var _loc6_:Array = new Array();
         var _loc7_:UserData = Utils.getOwnerUserData();
         for each(_loc4_ in param1)
         {
            _loc5_ = _loc4_ + ":1";
            _loc7_.addCardToCollection(_loc5_);
            _loc7_.addCardToNewCardsCollection(_loc5_);
         }
         if(param2 != PacksDefMng.PACK_QUEST_REWARD)
         {
            InstanceMng.getUserDataMng().persistenceSaveData();
         }
      }
      
      private static function getRandomRarityByChance(param1:Dictionary) : String
      {
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc2_:String = "";
         var _loc3_:Dictionary = new Dictionary(true);
         var _loc4_:Array = DictionaryUtils.getKeys(param1);
         var _loc9_:int = 0;
         _loc8_ = 0;
         while(_loc8_ < _loc4_.length)
         {
            _loc6_ = _loc4_[_loc8_];
            _loc5_ = int(param1[_loc6_]);
            _loc7_ = 0;
            while(_loc7_ < _loc5_)
            {
               _loc3_[_loc9_] = _loc6_;
               _loc9_++;
               _loc7_++;
            }
            _loc8_++;
         }
         var _loc10_:Number = Utils.randomInt(0,99);
         return _loc3_[_loc10_];
      }
      
      private static function unfoldPack(param1:String, param2:Object, param3:Boolean, param4:String = "") : void
      {
         if(Screen.smRewardEffect == null)
         {
            Screen.smRewardEffect = new RewardsEffect(param1,param2,param3,param4);
         }
         else
         {
            Screen.smRewardEffect.restart(param1,param2,param3,param4);
         }
         InstanceMng.getCurrentScreen().addChild(Screen.smRewardEffect);
         if(InstanceMng.getCurrentScreen() is FSShopScreen)
         {
            FSShopScreen(InstanceMng.getCurrentScreen()).unlockAfterPurchase();
         }
      }
      
      public static function onPackUnfoldedCleanRewardEffect() : void
      {
         if(Screen.smRewardEffect)
         {
            Screen.smRewardEffect.removeFromParent(true);
            Screen.smRewardEffect = null;
         }
      }
      
      public static function getShopCurrencyIcons(param1:String) : String
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case ServerConnection.CURRENCY_GOLD:
               _loc2_ = "large_gold_reward";
               break;
            case ServerConnection.CURRENCY_RAID_COINS:
               _loc2_ = "large_raidpoints_reward";
               break;
            case ServerConnection.CURRENCY_QUEST_COINS:
               _loc2_ = "large_questpoints";
               break;
            case ServerConnection.CURRENCY_AH_TOKENS:
               _loc2_ = "auction_token_large";
         }
         return _loc2_;
      }
      
      public static function getDailyKeyTime() : Number
      {
         return Config.smDayKey != null && Config.smDayKey.hasOwnProperty("value") && Config.smDayKey.value != -1 ? Config.smDayKey.value + TimerUtil.daysToMs(1) : -1;
      }
      
      public static function getDailyKeyTimeResetText() : String
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc1_:String = "";
         var _loc2_:Number = getDailyKeyTime();
         var _loc3_:Number = _loc2_ != -1 ? _loc2_ - ServerConnection.smServerTimeMS : -1;
         if(_loc3_ != -1)
         {
            if(TimerUtil.msToHour(_loc3_) < 1)
            {
               if(TimerUtil.msToMin(_loc3_) < 1)
               {
                  _loc1_ = TimerUtil.getTimeTextFromMs(_loc3_,null,null,null,TextManager.getText("TID_GEN_TIME_SECONDS_ABR"));
               }
               else
               {
                  _loc1_ = TimerUtil.getTimeTextFromMs(_loc3_,null,null,TextManager.getText("TID_GEN_TIME_MINUTES_ABR"));
               }
            }
            else
            {
               _loc4_ = TimerUtil.msToDays(_loc3_) > 0 ? TextManager.getText("TID_GEN_TIME_DAYS_ABR") : null;
               _loc5_ = TimerUtil.msToDays(_loc3_) < 1 ? TextManager.getText("TID_GEN_TIME_HOURS_ABR") : null;
               _loc1_ = TimerUtil.getTimeTextFromMs(_loc3_,_loc4_,_loc5_,null,null);
            }
         }
         return _loc1_ != null ? _loc1_ : "";
      }
      
      public static function createCustomBox(param1:String, param2:int, param3:Boolean = false, param4:Boolean = true) : *
      {
         return new CustomComponent(param1,param2,param3,param4);
      }
      
      public static function capitalizeFirstLetter(param1:String) : String
      {
         var _loc2_:String = param1.substr(0,1);
         var _loc3_:String = param1.substr(1,param1.length);
         return _loc2_.toUpperCase() + _loc3_.toLowerCase();
      }
      
      public static function isSimulator() : Boolean
      {
         return Capabilities.cpuArchitecture != "ARM" && Capabilities.cpuArchitecture != "ARM64";
      }
      
      public static function destroyArray(param1:*) : void
      {
         var _loc2_:int = 0;
         if(param1)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               if(param1[_loc2_] is FSModelUnloadableInterface)
               {
                  param1[_loc2_].destroy();
               }
               param1[_loc2_] = null;
               _loc2_++;
            }
            param1.length = null;
            param1 = null;
         }
      }
      
      public static function destroyObject(param1:FSModelUnloadableInterface) : void
      {
         if(param1 != null)
         {
            param1.destroy();
         }
         param1 = null;
      }
      
      public static function addStringToStringsVector(param1:Vector.<String>, param2:String) : Vector.<String>
      {
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         if(param1 == null)
         {
            param1 = new Vector.<String>();
         }
         if(param2 != "" && param2 != null)
         {
            _loc4_ = false;
            if(param1.length > 0)
            {
               _loc3_ = 0;
               while(_loc3_ < param1.length)
               {
                  if(param1[_loc3_] == param2)
                  {
                     _loc4_ = true;
                  }
                  _loc3_++;
               }
               if(!_loc4_)
               {
                  param1.push(param2);
               }
            }
            else
            {
               param1.push(param2);
            }
         }
         return param1;
      }
      
      public static function objectToString(param1:Object) : String
      {
         var _loc3_:String = null;
         var _loc2_:String = "";
         for(_loc3_ in param1)
         {
            _loc2_ += _loc3_ + ":" + param1[_loc3_];
         }
         return _loc2_;
      }
      
      public static function hasDuplicate(param1:Array) : Boolean
      {
         var _loc3_:* = undefined;
         var _loc2_:Dictionary = new Dictionary();
         for each(_loc3_ in param1)
         {
            if(_loc2_[_loc3_])
            {
               return true;
            }
            _loc2_[_loc3_] = true;
         }
         return false;
      }
      
      public static function getCardDescriptionForShare(param1:CardDef) : String
      {
         var _loc2_:String = null;
         var _loc13_:SubCategoryDef = null;
         var _loc14_:SubCategoryDef = null;
         var _loc3_:String = param1.getName() + " \n";
         var _loc4_:RarityDef = RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(param1.getCardRarity()));
         var _loc5_:String = TextManager.getText("TID_RARITY",true) + ": " + _loc4_.getName() + " \n";
         var _loc6_:String = "";
         var _loc7_:String = "";
         var _loc8_:String = "";
         var _loc9_:String = "";
         var _loc10_:String = "";
         var _loc11_:FactionDef = FactionDef(InstanceMng.getFactionsDefMng().getDefBySku(param1.getFactionSku()));
         if(_loc11_)
         {
            _loc9_ = TextManager.getText("TID_COMBAT_TYPE") + ": " + _loc11_.getName() + " \n";
         }
         if(param1.getCategoryIndex() == CategoriesDefMng.CATEGORY_UNITS && UnitDef(param1).getCombatSize() != "")
         {
            _loc6_ = TextManager.getText("TID_COMBAT_SIZE") + " " + TextManager.getText(UnitDef(param1).getCombatSize()) + " \n";
            _loc13_ = SubCategoryDef(InstanceMng.getSubCategoriesDefMng().getDefBySku(UnitDef(param1).getStrongSubcategorySku()));
            if(_loc13_)
            {
               _loc7_ = TextManager.getText("TID_COMBAT_STRONG") + ": " + _loc13_.getName() + " \n";
            }
            _loc14_ = SubCategoryDef(InstanceMng.getSubCategoriesDefMng().getDefBySku(UnitDef(param1).getWeakSubcategorySku()));
            if(_loc14_)
            {
               _loc8_ = TextManager.getText("TID_COMBAT_WEAK") + ": " + _loc14_.getName() + " \n";
            }
         }
         else
         {
            _loc10_ = param1.getDesc();
         }
         var _loc12_:String = " \n" + Config.getConfig().getShareHashtag();
         return _loc3_ + _loc6_ + _loc9_ + _loc7_ + _loc8_ + _loc10_ + _loc12_;
      }
      
      public static function getCardsPath() : String
      {
         return InstanceMng.getApplication().getCDNDomain() + Config.getConfig().getStorageNamespace() + "/share/cards/";
      }
      
      public static function shareGame(param1:Boolean = false) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(Utils.isMobile())
         {
            InstanceMng.getApplication().shareGame();
         }
         else if(Utils.isDesktop())
         {
            if(!param1)
            {
               _loc2_ = "http://onelink.to/" + Config.getConfig().getStorageNamespace();
               _loc3_ = _loc2_ + " - " + getShareGameText();
               Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT,_loc3_);
               Utils.setLogText(TextManager.getText("TID_RECRUIT_CODE_COPIED"));
            }
            else
            {
               onGoToAppStoreTriggered();
            }
         }
         else if(InstanceMng.getApplication().isFacebookBrowser())
         {
            if(InstanceMng.getFacebookPlugin())
            {
               InstanceMng.getFacebookPlugin().shareGame();
            }
         }
         else if(InstanceMng.getApplication().getKongregatePlugin())
         {
            InstanceMng.getApplication().getKongregatePlugin().shareGame();
         }
      }
      
      public static function getShareGameText() : String
      {
         var _loc1_:UserData = Utils.getOwnerUserData();
         var _loc2_:String = _loc1_ ? _loc1_.getReferralCode() : "";
         var _loc3_:String = TextManager.getText("TID_INVITE_FRIENDS_TRY",true);
         _loc3_ += _loc2_ != "" ? " " + TextManager.replaceParameters(TextManager.getText("TID_RECRUIT_CODE_USE",true),[_loc2_.toUpperCase()]) : "";
         if(isBrowser() || Utils.isDesktop())
         {
            _loc3_ += " " + Config.getConfig().getShareHashtag();
         }
         return _loc3_;
      }
      
      public static function formatNumberToLocale(param1:Number) : String
      {
         var _loc2_:NumberFormatter = new NumberFormatter(LocaleID.DEFAULT);
         return _loc2_.formatNumber(param1);
      }
      
      public static function relogin() : void
      {
         var onScreenUnloaded:Function = null;
         onScreenUnloaded = function():void
         {
            InstanceMng.deleteUserDataMng();
            InstanceMng.getApplication().destroyOnlineUserDataMng();
            InstanceMng.getServerConnection().initializeBackEnd();
         };
         if(InstanceMng.getCurrentScreen() != null && !(InstanceMng.getCurrentScreen() is FSMenuScreen))
         {
            InstanceMng.getCurrentScreen().dispatchEventWith(Screen.GO_TO_MENU,true);
         }
         Main.smGamePlayable = false;
         if(InstanceMng.getCurrentScreen() is FSMenuScreen)
         {
            FSMenuScreen(InstanceMng.getCurrentScreen()).refreshButtons();
         }
         setTimeout(onScreenUnloaded,1000);
      }
      
      public static function loadImageByURL(param1:String, param2:Function) : void
      {
         var loaded:Function = null;
         var url:String = param1;
         var onSuccessFunction:Function = param2;
         loaded = function(param1:flash.events.Event):void
         {
            var _loc2_:Bitmap = Boolean(param1) && Boolean(param1.target) && Boolean(param1.target.content) ? param1.target.content : null;
            if(Boolean(_loc2_) && Boolean(onSuccessFunction) && Boolean(_loc2_.bitmapData))
            {
               onSuccessFunction(_loc2_.bitmapData);
            }
            if(Boolean(param1) && Boolean(param1.target))
            {
               param1.target.removeEventListener(flash.events.Event.COMPLETE,loaded);
            }
         };
         var urlReq:URLRequest = new URLRequest(url);
         var img:Loader = new Loader();
         img.load(urlReq);
         img.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,loaded);
      }
      
      public static function resetComponent(param1:*) : void
      {
         if(!Config.USE_CARD_POOLING)
         {
            return;
         }
         param1.removeEventListeners(TouchEvent.TOUCH);
         TweenMax.killTweensOf(param1);
         param1.alpha = 1;
         param1.filter = null;
         param1.visible = true;
         param1.scale = 1;
         param1.name = "";
         param1.touchable = true;
         param1.pivotX = 0;
         param1.pivotY = 0;
         if(!(param1 is Sprite3D))
         {
            param1.skewX = 0;
            param1.skewY = 0;
         }
         if(param1 is Sprite3D)
         {
            param1.rotationX = 0;
            param1.rotationY = 0;
         }
         param1.x = param1.y = 0;
      }
      
      public static function getDefaultCurrency() : String
      {
         var _loc1_:LocaleID = new LocaleID(LocaleID.DEFAULT);
         var _loc2_:CurrencyFormatter = Boolean(_loc1_) && Boolean(_loc1_.name != "") && _loc1_.name != null ? new CurrencyFormatter(_loc1_.name) : new CurrencyFormatter("en-US");
         return _loc2_.currencyISOCode;
      }
      
      public static function loadProfilePicture(param1:String, param2:Function) : void
      {
         var onProfilePicturePathReceived:Function;
         var t:Texture = null;
         var extId:String = param1;
         var onSuccessReturnTextureFunction:Function = param2;
         t = null;
         var userData:UserData = Utils.getOwnerUserData();
         var ownerExtId:String = userData ? userData.getExtId() : "";
         var avatarOK:Boolean = userData != null && (!userData.flagsShowDefaultAvatar() || userData.flagsShowDefaultAvatar() && ownerExtId != extId);
         var extIdOK:Boolean = extId != "sample" && extId != "" && extId != null && avatarOK;
         if(extIdOK)
         {
            onProfilePicturePathReceived = function(param1:String):void
            {
               var loader:Loader = null;
               var loaderContext:LoaderContext = null;
               var IOLoadingError:Function = null;
               var securityLoadingError:Function = null;
               var completeHandler:Function = null;
               var urlPic:String = param1;
               var createLoader:Function = function():void
               {
                  if(Security.sandboxType == Security.REMOTE)
                  {
                     loaderContext = new LoaderContext(true,ApplicationDomain.currentDomain,SecurityDomain.currentDomain);
                  }
                  else
                  {
                     loaderContext = new LoaderContext(true,ApplicationDomain.currentDomain);
                  }
                  loaderContext.checkPolicyFile = true;
                  loaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
                  loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,completeHandler);
                  loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,IOLoadingError);
                  loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityLoadingError);
               };
               IOLoadingError = function(param1:IOErrorEvent):void
               {
                  onSuccessReturnTextureFunction = null;
                  FSDebug.debugTrace("[ IOLoadingError ] Err: " + param1.toString());
               };
               securityLoadingError = function(param1:SecurityErrorEvent):void
               {
                  onSuccessReturnTextureFunction = null;
                  FSDebug.debugTrace("[ SecurityErrorEvent ] Err: " + param1.toString());
               };
               completeHandler = function(param1:flash.events.Event):void
               {
                  var _loc2_:String = null;
                  var _loc3_:Bitmap = null;
                  var _loc4_:Number = NaN;
                  var _loc5_:Number = NaN;
                  if(param1.target is LoaderInfo)
                  {
                     _loc2_ = LoaderInfo(param1.target).url;
                     if(_loc2_ != null)
                     {
                        _loc3_ = Bitmap(loader.content);
                        _loc4_ = _loc3_.width > _loc3_.height ? _loc3_.width : _loc3_.height;
                        _loc5_ = _loc4_ > 1024 ? 1024 / _loc4_ : -1;
                        if(_loc5_ != -1)
                        {
                           _loc3_.bitmapData = Utils.scaleBitmapData(_loc3_.bitmapData,_loc5_);
                        }
                        t = Texture.fromBitmap(_loc3_);
                        unloadLoaders();
                     }
                  }
                  if(onSuccessReturnTextureFunction != null)
                  {
                     onSuccessReturnTextureFunction(t);
                  }
               };
               var unloadLoaders:Function = function():void
               {
                  if(loader)
                  {
                     loader.contentLoaderInfo.removeEventListener(flash.events.Event.COMPLETE,completeHandler);
                     loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,IOLoadingError);
                     loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,securityLoadingError);
                     loader.unloadAndStop();
                     loader = null;
                  }
                  loaderContext = null;
               };
               if(urlPic == null || urlPic == "")
               {
                  if(onSuccessReturnTextureFunction != null)
                  {
                     t = Root.assets.getTexture("default_photo_portrait");
                     if(t)
                     {
                        onSuccessReturnTextureFunction(t);
                     }
                  }
                  return;
               }
               loader = new Loader();
               createLoader();
               loader.load(new URLRequest(urlPic),loaderContext);
            };
            InstanceMng.getServerConnection().getProfilePicByExtId(extId,onProfilePicturePathReceived);
         }
         else if(onSuccessReturnTextureFunction != null)
         {
            t = Root.assets.getTexture("default_photo_portrait");
            if(t)
            {
               onSuccessReturnTextureFunction(t);
            }
         }
      }
      
      public static function onGoToAppStoreTriggered() : void
      {
         var _loc3_:URLRequest = null;
         var _loc1_:UserData = Utils.getOwnerUserData();
         if(_loc1_ != null)
         {
            _loc1_.setRatePopupShown(true);
            InstanceMng.getUserDataMng().updateFlags();
         }
         var _loc2_:String = "";
         if(Utils.isIOS())
         {
            _loc2_ = PopupError.APP_STORE_BASE_URI + Config.getConfig().getiOSAppID() + "?mt=8";
         }
         else if(Utils.isAndroid())
         {
            _loc2_ = PopupError.PLAY_STORE_BASE_URI + Utils.getNameSpace();
         }
         else if(Utils.isDesktop())
         {
            _loc2_ = Constants.STEAM_APP_PAGE + Config.getConfig().getSteamAppId();
         }
         else if(Utils.isBrowser())
         {
            if(InstanceMng.getApplication().isFacebookBrowser())
            {
               _loc2_ = Config.getConfig().getFanPageURL();
            }
         }
         if(_loc2_ != "")
         {
            _loc3_ = new URLRequest(_loc2_);
            navigateToURL(_loc3_);
         }
      }
      
      public static function getDeckValue(param1:Dictionary) : int
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:CardDef = null;
         var _loc2_:int = 0;
         if(param1 != null)
         {
            _loc3_ = DictionaryUtils.getKeys(param1);
            if(_loc3_ != null)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc3_.length)
               {
                  _loc5_ = _loc3_[_loc4_];
                  if(_loc5_ != null && _loc5_ != "")
                  {
                     _loc6_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc5_));
                     _loc2_ += _loc6_ ? _loc6_.getCardValue() * param1[_loc5_] : 0;
                  }
                  _loc4_++;
               }
            }
         }
         return _loc2_;
      }
      
      public static function alignComponentAndFixPosition(param1:*) : void
      {
         if(param1)
         {
            param1.alignPivot();
            param1.x -= param1.width / 2;
            param1.y -= param1.height / 2;
         }
      }
      
      public static function setLogText(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Boolean = true, param5:Boolean = true, param6:Number = 0.999, param7:String = "center", param8:String = "top", param9:* = null, param10:Boolean = false, param11:Number = 3) : void
      {
         if(param1 != "" && param1 != null && Boolean(InstanceMng.getLogPanel()))
         {
            InstanceMng.getLogPanel().setLogText(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11);
         }
      }
      
      public static function removeLog() : void
      {
         if(InstanceMng.getLogPanel())
         {
            InstanceMng.getLogPanel().removeLog();
         }
      }
      
      public static function getOwnerUserData() : UserData
      {
         return InstanceMng.getUserDataMng() ? InstanceMng.getUserDataMng().getOwnerUserData() : null;
      }
      
      public static function createPvPOverEffect(param1:UserBattleInfo, param2:Number = 0, param3:String = null, param4:Boolean = false, param5:Boolean = false, param6:Boolean = false) : void
      {
         if(InstanceMng.getCurrentScreen() is FSBattleScreenPvP)
         {
            FSBattleScreenPvP(InstanceMng.getCurrentScreen()).createPvPOverEffect(param1,param2,param3,param4,param5,param6);
         }
      }
      
      public static function saveDataOnSharedObj(param1:String, param2:*) : void
      {
         var key:String = param1;
         var value:* = param2;
         try
         {
            Main.smSharedObject = SharedObject.getLocal("settingsInfo");
            Main.smSharedObject.data[key] = value;
            Main.smSharedObject.flush();
            Main.smSharedObject.close();
         }
         catch(error:Error)
         {
            return;
         }
      }
      
      public static function getSharedObjData(param1:String) : *
      {
         if(Boolean(Main.smSharedObject) && Boolean(Main.smSharedObject.data) && Main.smSharedObject.data.hasOwnProperty(param1))
         {
            return Main.smSharedObject.data[param1];
         }
         return null;
      }
      
      public static function getiOSVersion() : uint
      {
         var _loc1_:String = Capabilities.os.match(/([0-9]\.?){2,3}/)[0];
         return Number(_loc1_.substr(0,_loc1_.indexOf(".")));
      }
      
      public static function createExplosionEffect(param1:String, param2:int, param3:int, param4:Boolean = true, param5:int = 30, param6:Number = 1, param7:Number = 1, param8:Boolean = true, param9:Number = 0.5, param10:String = "explosions") : MovieClip
      {
         var _loc11_:MovieClip = createMovieClip(param1,param2,param3,param5,param6,param7);
         if(param8)
         {
            requestScreenShake(param9);
         }
         if(param4)
         {
            createExplosionLight(param2,param3);
         }
         Utils.playSound(param10,SoundManager.TYPE_SFX);
         return _loc11_;
      }
      
      private static function createMovieClip(param1:String, param2:int, param3:int, param4:int = 30, param5:Number = 1, param6:Number = 1) : MovieClip
      {
         var vanishMovieclip:Function;
         var mc:MovieClip = null;
         var movieCompletedHandler:Function = null;
         var unloadMovieclip:Function = null;
         var spriteSheetName:String = param1;
         var x:int = param2;
         var y:int = param3;
         var fps:int = param4;
         var scaleX:Number = param5;
         var scaleY:Number = param6;
         var textures:Vector.<Texture> = Root.assets.getTextures(spriteSheetName);
         if(Boolean(textures) && textures.length > 0)
         {
            mc = new MovieClip(textures,fps);
            mc.touchable = false;
            mc.currentFrame = 0;
            mc.scaleX = scaleX;
            mc.scaleY = scaleY;
            mc.alignPivot();
            mc.loop = false;
         }
         if(mc)
         {
            movieCompletedHandler = function(param1:starling.events.Event):void
            {
               vanishMovieclip(param1.currentTarget as MovieClip);
            };
            vanishMovieclip = function(param1:MovieClip):void
            {
               if(param1)
               {
                  SpecialFX.tweenToAlpha(param1,0.001,0.5,0,unloadMovieclip,[param1]);
               }
            };
            unloadMovieclip = function(param1:MovieClip):void
            {
               if(param1)
               {
                  param1.removeFromParent();
                  Starling.juggler.remove(param1);
                  param1.removeEventListener(flash.events.Event.COMPLETE,movieCompletedHandler);
                  param1 = null;
               }
            };
            mc.x = x;
            mc.y = y;
            Starling.juggler.add(mc);
            InstanceMng.getCurrentScreen().addChild(mc);
            mc.play();
            mc.addEventListener(starling.events.Event.COMPLETE,movieCompletedHandler);
         }
         return mc;
      }
      
      public static function createExplosionLight(param1:int, param2:int, param3:Number = 0.75) : LightSource
      {
         var turnLightsOff:Function;
         var light:LightSource = null;
         var topBrightness:Number = NaN;
         var removeLights:Function = null;
         var x:int = param1;
         var y:int = param2;
         var duration:Number = param3;
         var userData:UserData = Utils.getOwnerUserData();
         if(Boolean(userData) && userData.flagsGetShowLightFX())
         {
            turnLightsOff = function(param1:LightSource):void
            {
               if(param1)
               {
                  TweenMax.fromTo(param1,0.75,{"brightness":topBrightness},{
                     "brightness":0,
                     "onComplete":removeLights,
                     "onCompleteParams":[param1]
                  });
               }
            };
            removeLights = function(param1:LightSource):void
            {
               if(param1)
               {
                  param1.removeFromParent(true);
                  param1 = null;
               }
            };
            light = LightSource.createPointLight(16685614,0);
            light.z = -50;
            light.x = x;
            light.y = y;
            topBrightness = 1;
            TweenMax.fromTo(light,duration,{"brightness":0},{
               "brightness":topBrightness,
               "onComplete":turnLightsOff,
               "onCompleteParams":[light]
            });
            InstanceMng.getCurrentScreen().addChild(light);
         }
         return light;
      }
      
      public static function setupButton9Scale(param1:FSButton, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : void
      {
         if(Boolean(param1 && param2 > 0 && param3 > 0 && param4 > 0 && param5 > 0) && Boolean(param6 > 0) && param7 > 0)
         {
            if(Utils.isIOS())
            {
               param2 *= 2;
               param3 *= 2;
               param4 *= 2;
               param5 *= 2;
            }
            param1.scale9Grid = new flash.geom.Rectangle(param2,param3,param4,param5);
            if(isAndroid() || isDesktop())
            {
               param6 *= 0.9375;
               param7 *= 0.9375;
            }
            else
            {
               param6 *= 1.66668;
               param7 *= 1.66668;
            }
            param1.width = param6;
            param1.height = param7;
            param1.alignPivot();
            param1.textBounds = new flash.geom.Rectangle(0,0,param6,param7);
            param1.readjustSize();
         }
      }
      
      public static function removeButton9Scale(param1:FSButton, param2:Number, param3:Number) : void
      {
         if(Boolean(param1) && Boolean(param2 > 0) && param3 > 0)
         {
            param1.scale9Grid = null;
            if(isAndroid() || isDesktop())
            {
               param2 *= 0.9375;
               param3 *= 0.9375;
            }
            else
            {
               param2 *= 1.66668;
               param3 *= 1.66668;
            }
            param1.width = param2;
            param1.height = param3;
            param1.textBounds = new flash.geom.Rectangle(0,0,param2,param3);
            param1.readjustSize();
         }
      }
      
      public static function setupImage9Scale(param1:FSImage, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : void
      {
         if(Boolean(param1 && param2 > 0 && param3 > 0 && param4 > 0 && param5 > 0) && Boolean(param6 > 0) && param7 > 0)
         {
            if(Utils.isIOS())
            {
               param2 *= 2;
               param3 *= 2;
               param4 *= 2;
               param5 *= 2;
            }
            param1.scale9Grid = new flash.geom.Rectangle(param2,param3,param4,param5);
            if(isAndroid() || isDesktop())
            {
               param6 *= 0.9375;
               param7 *= 0.9375;
            }
            else
            {
               param6 *= 1.66668;
               param7 *= 1.66668;
            }
            param1.width = param6;
            param1.height = param7;
            param1.readjustSize();
         }
      }
      
      public static function handleButton9Scale(param1:FSButton, param2:String) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Boolean = true;
         switch(param2)
         {
            case "button_blue_large":
            case "button_green_large":
               _loc3_ = 15;
               _loc4_ = 15;
               _loc5_ = 2.5;
               _loc6_ = 5;
               _loc7_ = 130.5;
               _loc8_ = 33.75;
               break;
            case Constants.ACCEPT_GREEN_BUTTON_UP_NAME:
               _loc3_ = 7.5;
               _loc4_ = 15;
               _loc5_ = 10;
               _loc6_ = 5;
               _loc7_ = 85.5;
               _loc8_ = 31.75;
               break;
            case Constants.ACCEPT_BUTTON_XL_UP_NAME:
            case Constants.ACCEPT_BUTTON_XL_DOWN_NAME:
               _loc3_ = 8.75;
               _loc4_ = 10;
               _loc5_ = 6.25;
               _loc6_ = 7.5;
               _loc7_ = 105.75;
               _loc8_ = 28.5;
               break;
            case PopupSettingsConfirmation.ACCEPT_BUTTON_NAME:
               _loc3_ = 10;
               _loc4_ = 10;
               _loc5_ = 2.5;
               _loc6_ = 12.5;
               _loc7_ = 125.5;
               _loc8_ = 49;
               break;
            default:
               _loc9_ = false;
         }
         if(_loc9_)
         {
            Utils.setupButton9Scale(param1,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_);
         }
      }
      
      public static function getFormattedUTCServerTime(param1:Date = null) : String
      {
         param1 = param1 == null ? new Date() : param1;
         param1.setTime(ServerConnection.smServerTimeMS);
         var _loc2_:String = transformValueToString(param1.getUTCHours().toString(),2);
         var _loc3_:String = transformValueToString(param1.getUTCMinutes().toString(),2);
         var _loc4_:String = transformValueToString(param1.getUTCSeconds().toString(),2);
         return "[" + _loc2_ + ":" + _loc3_ + ":" + _loc4_ + "]";
      }
      
      public static function round2(param1:Number, param2:int) : Number
      {
         var _loc3_:int = Math.pow(10,param2);
         return Math.round(param1 * _loc3_) / _loc3_;
      }
   }
}

