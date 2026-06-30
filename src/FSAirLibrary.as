package
{
   import air.net.URLMonitor;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSAssetManager;
   import com.fs.tcgengine.screens.FSAuctionsScreen;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.screens.FSDeckBuilderScreen;
   import com.fs.tcgengine.screens.FSDungeonsScreen;
   import com.fs.tcgengine.screens.FSMapScreen;
   import com.fs.tcgengine.screens.FSMenuScreen;
   import com.fs.tcgengine.screens.FSPvPScreen;
   import com.fs.tcgengine.screens.FSRaidsScreen;
   import com.fs.tcgengine.screens.FSShopScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.Layout;
   import com.fs.tcgengine.utils.Utils;
   import flash.desktop.NativeApplication;
   import flash.desktop.SystemIdleMode;
   import flash.display.Bitmap;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.StatusEvent;
   import flash.filesystem.File;
   import flash.net.URLRequest;
   import flash.ui.Keyboard;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import starling.core.Starling;
   import starling.utils.StringUtil;
   
   public class FSAirLibrary
   {
      
      private static var smInternetMonitor:URLMonitor;
      
      private static var Background:Class = FSAirLibrary_Background;
      
      private static var Background2x:Class = FSAirLibrary_Background2x;
      
      private static var Background1x960:Class = FSAirLibrary_Background1x960;
      
      private static var Background1x1136:Class = FSAirLibrary_Background1x1136;
      
      private static var Background2xAndroid:Class = FSAirLibrary_Background2xAndroid;
      
      private static var Background4xAndroid:Class = FSAirLibrary_Background4xAndroid;
      
      private static var Background2xTabletAndroid:Class = FSAirLibrary_Background2xTabletAndroid;
      
      private static var Background4xTabletAndroid:Class = FSAirLibrary_Background4xTabletAndroid;
      
      private static var Background4xDesktop:Class = FSAirLibrary_Background4xDesktop;
      
      private static var Background4xDesktop1920:Class = FSAirLibrary_Background4xDesktop1920;
      
      private static var smFixANRTimeout:uint = uint.MIN_VALUE;
      
      public static var mSteamAccessRaidsGranted:Boolean = false;
      
      public function FSAirLibrary()
      {
         super();
      }
      
      public static function getFullScreenWidth() : int
      {
         return Utils.isMobile() ? int(InstanceMng.getApplication().stage.fullScreenWidth) : InstanceMng.getApplication().stage.stageWidth;
      }
      
      public static function getFullScreenHeight() : int
      {
         return Utils.isMobile() ? int(InstanceMng.getApplication().stage.fullScreenHeight) : InstanceMng.getApplication().stage.stageHeight;
      }
      
      public static function loadDefaultAssets(param1:FSAssetManager, param2:int, param3:int, param4:Class) : void
      {
         var _loc6_:Stage = null;
         var _loc7_:String = null;
         var _loc5_:String = Layout.getResourcesSuffix(param2,param3);
         if(Utils.isIOS() || Utils.isDesktop() || Utils.isAndroid() && !InstanceMng.getApplication().hasToCheckObbFiles())
         {
            param1.enqueue(File.applicationDirectory.resolvePath("audio"),File.applicationDirectory.resolvePath(StringUtil.format("gameFonts/{0}x" + Layout.getType(),Main.smScaleFactor)),File.applicationDirectory.resolvePath("texts"));
         }
         else
         {
            _loc6_ = Starling.current ? Starling.current.nativeStage : InstanceMng.getApplication().stage;
            _loc7_ = Utils.isTablet(_loc6_) ? "tablet/" : "mobile/";
            param1.enqueue(File.applicationDirectory.resolvePath("audio"),File.applicationDirectory.resolvePath(StringUtil.format("gameFonts/{0}x" + Layout.getType(),Main.smScaleFactor)),File.applicationDirectory.resolvePath("texts"),File.applicationDirectory.resolvePath(StringUtil.format("textures/{0}x" + _loc5_ + "common/",Main.smScaleFactor)),File.applicationDirectory.resolvePath(StringUtil.format("textures/{0}x" + _loc5_ + "misc/",Main.smScaleFactor)),File.applicationDirectory.resolvePath(StringUtil.format("textures/{0}x" + _loc5_ + "menuScreen/",Main.smScaleFactor)),File.applicationDirectory.resolvePath(StringUtil.format("textures/{0}x" + _loc5_ + "specialScreens/" + _loc7_,Main.smScaleFactor)));
         }
         param1.enqueue(param4);
      }
      
      public static function addNativeEventListeners() : void
      {
         InstanceMng.getApplication().stage.addEventListener(Event.ACTIVATE,fl_Activate);
         InstanceMng.getApplication().stage.addEventListener(Event.DEACTIVATE,fl_Deactivate);
         NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE,function(param1:*):void
         {
            if(Utils.isAndroid())
            {
               clearTimeout(smFixANRTimeout);
            }
            InstanceMng.getApplication().handleOnActivate();
         });
         NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE,function(param1:*):void
         {
            var e:* = param1;
            if(Utils.isAndroid())
            {
               smFixANRTimeout = setTimeout(function():void
               {
                  NativeApplication.nativeApplication.exit();
               },60000);
            }
            InstanceMng.getApplication().handleOnDeactivate();
         });
         if(!Utils.isSimulator() || Utils.isDesktop())
         {
            NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN,handleKeys,false,0,true);
         }
      }
      
      private static function trackFirebaseLeaveOnExit() : void
      {
         var _loc1_:LevelDef = null;
         var _loc2_:UserData = null;
         FSDebug.debugTrace("EXITING");
         if(InstanceMng.getBattleEngine() != null && !InstanceMng.getBattleEngine().isBattleOver())
         {
            FSDebug.debugTrace("EXITING #2");
            if(!BattleEngine.smPlayerWon)
            {
               FSDebug.debugTrace("EXITING #3");
               _loc1_ = InstanceMng.getBattleEngine().getLevelDef();
               _loc2_ = Utils.getOwnerUserData();
               if(_loc2_ != null)
               {
                  FSDebug.debugTrace("EXITING #4");
                  InstanceMng.getApplication().firebaseAddToDatabase(_loc1_.getLevelIndex(),_loc2_.getCurrentDifficulty(),false,FSBattleScreen.smUserPayedInThisLevel,false);
               }
            }
         }
      }
      
      private static function fl_Activate(param1:Event = null) : void
      {
         NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
      }
      
      private static function fl_Deactivate(param1:Event) : void
      {
         if(Utils.isIOS())
         {
            NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
         }
      }
      
      public static function handleKeys(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.BACK)
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            handleAndroidBackButton();
         }
         if(param1.keyCode == Keyboard.ESCAPE)
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            if(canPopupSettingsBeShown())
            {
               InstanceMng.getPopupMng().openSettingsPopup();
            }
         }
      }
      
      private static function canPopupSettingsBeShown() : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc1_:Screen = InstanceMng.getCurrentScreen();
         if(_loc1_)
         {
            _loc2_ = Utils.isDesktop();
            _loc3_ = Boolean(InstanceMng.getPopupMng()) && !InstanceMng.getPopupMng().isPopupLoading() && InstanceMng.getPopupMng().getPopupShown() == null;
            _loc4_ = !(_loc1_ is FSMapScreen) || _loc1_ is FSMapScreen && !FSMapScreen(_loc1_).isShowingComic();
            _loc5_ = Boolean(_loc1_.getOptionsPanel()) && !_loc1_.getOptionsPanel().areCreditsBeingShown();
            _loc6_ = Boolean(_loc1_) && !_loc1_.isTransparentBGShown();
            _loc7_ = !(_loc1_ is FSBattleScreen) || _loc1_ is FSBattleScreen && InstanceMng.getBattleEngine() && InstanceMng.getBattleEngine().getAbilityWaitingForTarget() == null;
            _loc8_ = _loc1_.isFullyLoaded() && _loc4_ && _loc5_ && _loc6_ && _loc7_;
            _loc9_ = (_loc8_) && _loc1_.getOptionsPanel() != null && _loc1_.getOptionsPanel().isEnabled();
            if(_loc2_ && _loc3_ && _loc8_ && _loc9_)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function handleAndroidBackButton() : void
      {
         var _loc2_:Screen = null;
         var _loc1_:Screen = InstanceMng.getCurrentScreen();
         if(_loc1_ != null && _loc1_.isFullyLoaded() && !Root.assets.isLoading)
         {
            if(InstanceMng.getPopupMng() != null && InstanceMng.getPopupMng().getPopupShown() == null)
            {
               if(InstanceMng.getPopupMng().getPopupShown() == null)
               {
                  _loc2_ = InstanceMng.getCurrentScreen();
                  if(_loc2_ is FSMenuScreen)
                  {
                     exitApp();
                  }
                  else if(_loc2_ is FSMapScreen)
                  {
                     FSMapScreen(_loc2_).showMenu();
                  }
                  else if(_loc2_ is FSDeckBuilderScreen)
                  {
                     if(FSDeckBuilderScreen(_loc2_).getEdidionStatus() == FSDeckBuilderScreen.STATUS_EDITING)
                     {
                        FSDeckBuilderScreen(_loc2_).setExitRequested(true);
                        InstanceMng.getPopupMng().openUnsavedDataPopup();
                     }
                     else
                     {
                        FSDeckBuilderScreen(_loc2_).showMap();
                     }
                  }
                  else if(_loc2_ is FSShopScreen)
                  {
                     FSShopScreen(_loc2_).showMap();
                  }
                  else if(_loc2_ is FSAuctionsScreen)
                  {
                     FSAuctionsScreen(_loc2_).showMap();
                  }
                  else if(_loc2_ is FSPvPScreen)
                  {
                     FSPvPScreen(_loc2_).showMap();
                  }
                  else if(_loc2_ is FSDungeonsScreen)
                  {
                     if(FSDungeonsScreen(_loc2_).isDungeonPayed())
                     {
                        InstanceMng.getPopupMng().openConfirmLeaveDungeonScreenPopup();
                     }
                     else
                     {
                        FSDungeonsScreen(_loc2_).showMap();
                     }
                  }
                  else if(_loc2_ is FSRaidsScreen)
                  {
                     FSRaidsScreen(_loc2_).showMap();
                  }
                  else if(_loc2_ is FSBattleScreen)
                  {
                     if(InstanceMng.getBattleEngine() == null || Boolean(InstanceMng.getBattleEngine()) && Boolean(!InstanceMng.getBattleEngine().isBattleOver()))
                     {
                        InstanceMng.getPopupMng().openExitPopup();
                     }
                  }
                  else
                  {
                     InstanceMng.getPopupMng().openExitPopup();
                  }
               }
            }
         }
      }
      
      public static function exitApp() : void
      {
         NativeApplication.nativeApplication.exit();
      }
      
      public static function checkInternetConnection() : void
      {
         startMonitoring();
      }
      
      private static function startMonitoring() : void
      {
         if(smInternetMonitor == null)
         {
            smInternetMonitor = new URLMonitor(new URLRequest("http://www.google.com"));
            smInternetMonitor.addEventListener(StatusEvent.STATUS,netConnectivity);
            smInternetMonitor.pollInterval = 5000;
            smInternetMonitor.start();
         }
         else if(smInternetMonitor.available && !Config.DURABLE_CONNECTION)
         {
            attemptToReconnect();
         }
      }
      
      private static function netConnectivity(param1:StatusEvent) : void
      {
         Utils.smRawInternetAvailable = smInternetMonitor.available;
         if(smInternetMonitor.available)
         {
            FSDebug.debugTrace("[URLMonitor ALERT] Status change. You are connected to the internet");
            attemptToReconnect();
         }
         else
         {
            FSDebug.debugTrace("[URLMonitor ALERT] Status change. You are NOT connected to the internet");
            if(InstanceMng.getServerConnection())
            {
               InstanceMng.getServerConnection().onConnectionKO();
            }
         }
      }
      
      private static function attemptToReconnect() : void
      {
         FSDebug.debugTrace("Attempting to reconnect");
         var _loc1_:Boolean = Boolean(InstanceMng.getServerConnection()) && !InstanceMng.getServerConnection().wasDualConnectionDetected();
         if(_loc1_)
         {
            InstanceMng.getServerConnection().onConnectionOK();
         }
      }
      
      public static function createStartupBackground() : Bitmap
      {
         var _loc1_:Bitmap = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Boolean = false;
         var _loc2_:Boolean = Utils.isTablet(InstanceMng.getApplication().getStage());
         if(Utils.isIOS())
         {
            _loc3_ = FSAirLibrary.getFullScreenWidth();
            _loc4_ = FSAirLibrary.getFullScreenHeight();
            _loc5_ = Utils.isIphone(_loc3_,_loc4_);
            if(_loc5_)
            {
               _loc1_ = Utils.isIphone4(_loc3_,_loc4_) ? new Background1x960() : new Background1x1136();
            }
            else
            {
               _loc1_ = Main.smScaleFactor == 1 ? new Background() : new Background2x();
            }
         }
         else if(Utils.isDesktop())
         {
            _loc1_ = _loc2_ ? new Background4xDesktop() : new Background4xDesktop1920();
         }
         else
         {
            switch(Main.smScaleFactor)
            {
               case 2:
                  _loc1_ = _loc2_ ? new Background2xTabletAndroid() : new Background2xAndroid();
                  break;
               case 4:
                  _loc1_ = _loc2_ ? new Background4xTabletAndroid() : new Background4xAndroid();
            }
         }
         Background = Background2x = Background1x960 = Background1x1136 = Background2xAndroid = Background2xTabletAndroid = Background4xAndroid = Background4xTabletAndroid = Background4xDesktop = Background4xDesktop1920 = null;
         return _loc1_;
      }
   }
}

