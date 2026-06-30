package
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.AbilitiesMng;
   import com.fs.tcgengine.controller.AuctionsMng;
   import com.fs.tcgengine.controller.BoostsMng;
   import com.fs.tcgengine.controller.ComicMng;
   import com.fs.tcgengine.controller.ConversationsMng;
   import com.fs.tcgengine.controller.DungeonsMng;
   import com.fs.tcgengine.controller.ErrorsMng;
   import com.fs.tcgengine.controller.FSCardAnimsMng;
   import com.fs.tcgengine.controller.FSCardsMng;
   import com.fs.tcgengine.controller.FSFacebookPlugin;
   import com.fs.tcgengine.controller.FSInAppsManager;
   import com.fs.tcgengine.controller.FSSoundFXMng;
   import com.fs.tcgengine.controller.GuildsMng;
   import com.fs.tcgengine.controller.QuestsMng;
   import com.fs.tcgengine.controller.RaidsMng;
   import com.fs.tcgengine.controller.ScoreMng;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.SubCategoriesMng;
   import com.fs.tcgengine.controller.TargetMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.controller.TutorialDeckBuilderMng;
   import com.fs.tcgengine.controller.TutorialMapMng;
   import com.fs.tcgengine.controller.TutorialMng;
   import com.fs.tcgengine.controller.rules.RulesMng;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.userdata.FSUserDataMngOnline;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.particles.TextParticlesMng;
   import com.fs.tcgengine.resources.FSAssetManager;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSMapScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.Base64;
   import com.fs.tcgengine.utils.CheatConsole;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.Layout;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.guilds.GuildsPanel;
   import com.fs.tcgengine.view.meshes.LevelItemContainer;
   import com.google.analytics.GATracker;
   import com.google.analytics.core.TrackerMode;
   import com.junkbyte.console.Cc;
   import flash.desktop.NativeApplication;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.display.StageAlign;
   import flash.display.StageDisplayState;
   import flash.display.StageQuality;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.net.SharedObject;
   import flash.system.Capabilities;
   import flash.text.Font;
   import flash.utils.Dictionary;
   import starling.core.Starling;
   import starling.events.Event;
   import starling.textures.Texture;
   import starling.utils.Align;
   import starling.utils.RectangleUtil;
   import starling.utils.StringUtil;
   
   public class Main extends Sprite implements GameConfigInterface
   {
      
      public static var smTracker:GATracker;
      
      public static var smData:Object;
      
      public static var smScaleFactor:Number;
      
      protected static var mGameFont:Font;
      
      public static var smOfflineUserData:UserData;
      
      public static var smCrossPromotionInfo:String;
      
      public static var smPreviousLevelItem:LevelItemContainer;
      
      public static var smSharedObject:SharedObject;
      
      private static var GameFont:Class = Main_GameFont;
      
      public static var smDefaultCameraDistance:int = 500;
      
      public static var smFirebaseInitialized:Boolean = false;
      
      public static var smGamePlayable:Boolean = false;
      
      public static var smNextLoadingBGName:String = "";
      
      public static var smPreviousLoadingBGName:String = "";
      
      protected var mStarling:Starling;
      
      private var mCurrentScreen:Screen = null;
      
      private var mMapScreenVisited:Boolean = false;
      
      private var mDefaultManagersFullyInitializedStarted:Boolean = false;
      
      private var mDefaultManagersFullyInitialized:Boolean = false;
      
      private var mMainGameAddedToStage:Boolean = false;
      
      protected var mInstanceMng:InstanceMng;
      
      private var mTextManager:TextManager;
      
      private var mRuleMng:RulesMng;
      
      protected var mUserDataMng:UserDataMng;
      
      protected var mPopupMng:FSPopupMng;
      
      private var mTextParticlesMng:TextParticlesMng;
      
      protected var mCardAnimsMng:FSCardAnimsMng;
      
      private var mAbilitiesMng:AbilitiesMng;
      
      private var mDungeonsMng:DungeonsMng;
      
      private var mRaidsMng:RaidsMng;
      
      private var mGuildsMng:GuildsMng;
      
      private var mAuctionsMng:AuctionsMng;
      
      private var mScoreMng:ScoreMng;
      
      private var mTargetMng:TargetMng;
      
      protected var mResourcesMng:FSResourceMng;
      
      protected var mServerConnection:ServerConnection;
      
      protected var mFBPlugin:FSFacebookPlugin;
      
      private var mSubCategoriesMng:SubCategoriesMng;
      
      private var mBoostsMng:BoostsMng;
      
      private var mTutorialMng:TutorialMng;
      
      private var mTutorialDeckBuilderMng:TutorialDeckBuilderMng;
      
      private var mTutorialMapMng:TutorialMapMng;
      
      private var mConversationsMng:ConversationsMng;
      
      private var mComicsMng:ComicMng;
      
      protected var mSoundFXMng:FSSoundFXMng;
      
      protected var mCardsMng:FSCardsMng;
      
      private var mQuestsMng:QuestsMng;
      
      protected var mMainAssetManager:FSAssetManager;
      
      private var mOnDemandDefsInitialized:Boolean = false;
      
      protected var mServerEventListenersAdded:Boolean = false;
      
      protected var mGuildsPanel:GuildsPanel;
      
      protected var mGSBrowserNamespace:String;
      
      private var mIsKongregate:Boolean = false;
      
      private var mIsFacebook:Boolean = false;
      
      protected var mFullScreenInitialized:Boolean = false;
      
      protected var mInAppsManager:FSInAppsManager;
      
      private var mMapsIntroSeen:Dictionary;
      
      protected var mRewardedVideoNotifyPlayerCurrencyAdded:Boolean = false;
      
      public function Main()
      {
         super();
         this.handleSharedObject();
         this.mInstanceMng = new InstanceMng();
         InstanceMng.registerApplication(this);
         addEventListener(flash.events.Event.ADDED_TO_STAGE,this.onAddedToStage,false,0,true);
         this.checkInternetConnection();
      }
      
      public static function getGameFont() : Font
      {
         if(mGameFont == null)
         {
            mGameFont = new GameFont();
         }
         return mGameFont;
      }
      
      private function onAddedToStage(param1:flash.events.Event) : void
      {
         var _loc2_:Object = null;
         removeEventListener(flash.events.Event.ADDED_TO_STAGE,this.onAddedToStage);
         if(Boolean(loaderInfo) && Utils.isBrowser())
         {
            _loc2_ = loaderInfo.parameters;
            this.mIsKongregate = _loc2_.hasOwnProperty("kongregate") && _loc2_.kongregate == "true";
            this.mIsFacebook = !this.mIsKongregate;
         }
         this.mMainGameAddedToStage = true;
         FSDebug.debugTrace("Capabilities.version: " + Capabilities.version);
         FSDebug.debugTrace("Capabilities.cpuArchitecture: " + Capabilities.cpuArchitecture);
         FSDebug.debugTrace("App id: " + Utils.getBundleId());
         smData = new Object();
         if(stage)
         {
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = this.getDefaultScaleMode();
            stage.quality = StageQuality.HIGH;
            this.handleFullScreenSettings();
         }
         this.initStarling();
         this.initializeGATracker();
         if(loaderInfo)
         {
            ErrorsMng.startMonitoring();
         }
      }
      
      private function handleSharedObject() : void
      {
         try
         {
            smSharedObject = SharedObject.getLocal("settingsInfo");
         }
         catch(error:Error)
         {
            FSDebug.debugTrace("SharedObject Error:" + error.toString());
            return;
         }
      }
      
      private function handleFullScreenSettings() : void
      {
         var _loc1_:Boolean = !Utils.isBrowser() && (Utils.isMobile() || Utils.isDesktop() && Config.ENVIRONMENT_ACTIVE == Config.ENVIRONMENT_PROD);
         _loc1_ = Boolean(!Utils.isMobile() && !Utils.isBrowser() && smSharedObject) && Boolean(smSharedObject.data) && smSharedObject.data.hasOwnProperty("fullScreen") ? Boolean(smSharedObject.data.fullScreen) : _loc1_;
         if(_loc1_)
         {
            stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
         }
      }
      
      protected function initializeServer() : void
      {
      }
      
      public function getApiKey(param1:Boolean) : String
      {
         return "";
      }
      
      public function getSecretKey() : String
      {
         return "";
      }
      
      public function getDistriqtApiKey() : String
      {
         var _loc1_:String = "";
         if(Utils.isMobile())
         {
            return Utils.isIOS() ? Config.getConfig().getDistriqtApiKeyiOS() : Config.getConfig().getDistriqtApiKeyAndroid();
         }
         return _loc1_;
      }
      
      public function addServerEventListeners() : void
      {
         if(!this.mServerEventListenersAdded)
         {
            this.addExtensionsEventListeners();
            this.addFacebookEventListeners();
            this.mServerEventListenersAdded = true;
         }
         else
         {
            FSDebug.debugTrace("[addServerEventListeners] -> Server ev.listeners already added");
         }
      }
      
      protected function addExtensionsEventListeners() : void
      {
      }
      
      public function addFacebookEventListeners() : void
      {
      }
      
      protected function initStarling() : void
      {
         var stageWidth:int;
         var stageHeight:int;
         var isAndroidOrDesktop:Boolean;
         var maxFullScreenWidth:int;
         var maxFullScreenHeight:int;
         var viewPort:flash.geom.Rectangle;
         var background:Bitmap = null;
         var fb:FSFacebookPlugin = null;
         var fbId:String = null;
         var isBrowserLocal:Boolean = false;
         if(Starling.current == null)
         {
            Starling.multitouchEnabled = false;
         }
         stageWidth = this.getDefaultStageWidth();
         stageHeight = this.getDefaultStageHeight();
         isAndroidOrDesktop = Utils.isAndroidOrDesktop();
         maxFullScreenWidth = isAndroidOrDesktop ? int(stage.fullScreenWidth) : this.getFullScreenWidth();
         maxFullScreenHeight = isAndroidOrDesktop ? int(stage.fullScreenHeight) : this.getFullScreenHeight();
         viewPort = this.calculateViewport(maxFullScreenWidth,maxFullScreenHeight);
         smScaleFactor = this.calculateScaleFactor(maxFullScreenWidth);
         this.mMainAssetManager = new FSAssetManager(smScaleFactor);
         this.mMainAssetManager.verbose = Capabilities.isDebugger && Config.smLogsVerboseEnabled;
         this.loadDefaultAssets(this.mMainAssetManager,maxFullScreenWidth,maxFullScreenHeight);
         this.loadInitAssets(this.mMainAssetManager);
         background = this.createStartupBackground();
         background.x = viewPort.x;
         background.y = viewPort.y;
         background.width = viewPort.width;
         background.height = viewPort.height;
         background.smoothing = true;
         addChild(background);
         this.mStarling = new Starling(Root,stage,viewPort);
         Starling.current.skipUnchangedFrames = true;
         this.mStarling.stage.stageWidth = stageWidth;
         this.mStarling.stage.stageHeight = stageHeight;
         this.mStarling.simulateMultitouch = false;
         this.mStarling.enableErrorChecking = Capabilities.isDebugger;
         this.mStarling.addEventListener(starling.events.Event.ROOT_CREATED,function onRootCreated(param1:Object, param2:Root):void
         {
            var _loc4_:Number = NaN;
            mStarling.removeEventListener(starling.events.Event.ROOT_CREATED,onRootCreated);
            removeChild(background);
            var _loc3_:Texture = Texture.fromBitmap(background,false,false,smScaleFactor);
            param2.start(_loc3_,mMainAssetManager,initializeDefaultManagers);
            mStarling.start();
            if(Config.smShowStats)
            {
               _loc4_ = Utils.isIOS() || Utils.isBrowser() ? Math.max(2,smScaleFactor / 2) : Math.max(1,smScaleFactor / 2);
               _loc4_ = Utils.isDesktop() ? 1 : _loc4_;
               mStarling.showStatsAt(Align.LEFT,Align.BOTTOM,_loc4_);
            }
            if(Utils.isBrowser())
            {
               resizeViewport();
            }
         });
         Starling.current.stage.color = 0;
         Starling.current.nativeStage.color = 0;
         this.addNativeEventListeners();
         this.createConsole();
         if(this.isBrowserVersion())
         {
            fb = InstanceMng.getFacebookPlugin();
            fbId = fb != null ? fb.getFBId() : null;
            isBrowserLocal = this.isFacebookBrowser() && Config.ENVIRONMENT_ACTIVE == Config.ENVIRONMENT_DEV && fbId == null;
         }
         this.initListeners();
      }
      
      protected function createInitialViewport(param1:Number, param2:Number, param3:Number, param4:Number) : flash.geom.Rectangle
      {
         return RectangleUtil.fit(new flash.geom.Rectangle(0,0,param1,param2),new flash.geom.Rectangle(0,0,param3,param4));
      }
      
      protected function addNativeEventListeners() : void
      {
      }
      
      public function initializeANEs(param1:String) : void
      {
      }
      
      public function handleOnActivate() : void
      {
         if(this.mStarling)
         {
            if(Utils.isIOS())
            {
               NativeApplication.nativeApplication.executeInBackground = false;
               this.mStarling.start();
               if(stage)
               {
                  stage.quality = StageQuality.HIGH;
               }
            }
            else
            {
               NativeApplication.nativeApplication.executeInBackground = true;
            }
            Root.onActivate();
         }
      }
      
      public function handleOnDeactivate() : void
      {
         if(this.mStarling)
         {
            if(Utils.isIOS())
            {
               NativeApplication.nativeApplication.executeInBackground = false;
               this.mStarling.stop(true);
               if(stage)
               {
                  stage.quality = StageQuality.MEDIUM;
               }
            }
            else
            {
               NativeApplication.nativeApplication.executeInBackground = true;
            }
            Root.onDeactivate();
         }
      }
      
      protected function loadDefaultAssets(param1:FSAssetManager, param2:int, param3:int) : void
      {
         this.createResourcesMng();
      }
      
      public function loadInitAssets(param1:FSAssetManager) : void
      {
         var _loc2_:String = null;
         if(Utils.isMobile() || Utils.isDesktop())
         {
            if(!this.hasToCheckObbFiles() || !Utils.isAndroid() || Utils.isDesktop())
            {
               _loc2_ = Utils.isIOS() ? FSResourceMng.PREFIX_TEXTURE : FSResourceMng.PREFIX_TEXTURE_INIT;
               InstanceMng.getResourcesMng().addResourcesFolderByName(Root.INIT_SCREEN_NAME,null,param1,_loc2_);
               InstanceMng.getResourcesMng().addSpecialScreenResources(Root.INIT_SCREEN_NAME,param1,_loc2_);
               InstanceMng.getResourcesMng().addResourcesFolderByName("common",null,param1,_loc2_);
               InstanceMng.getResourcesMng().addResourcesFolderByName("misc",null,param1,_loc2_);
            }
            InstanceMng.getResourcesMng().addSpecialScreenResource("loading","bg_loading1.jpg",param1,FSResourceMng.PREFIX_TEXTURE);
            InstanceMng.getResourcesMng().addResourcesFolderByName("shared",null,param1,FSResourceMng.PREFIX_TEXTURE);
            InstanceMng.getResourcesMng().addResourcesFolderByName("packs2",null,param1,FSResourceMng.PREFIX_TEXTURE);
            if(Config.smPortraitFramesInAtlas)
            {
               InstanceMng.getResourcesMng().addResourcesFolderByName("portraitFrames",null,param1,FSResourceMng.PREFIX_TEXTURE);
            }
            InstanceMng.getResourcesMng().addResourcesFolderByName("particlesAssets",null,param1,"",true);
            InstanceMng.getResourcesMng().addDefinitionsFolderByName(StringUtil.format(InstanceMng.getResourcesMng().getAssetsOnDemandURL("fonts_on_demand/") + "{0}x" + Layout.getType(),Main.smScaleFactor),param1);
         }
         else if(Utils.isBrowser())
         {
            InstanceMng.getResourcesMng().addSpecialScreenResource("loading","bg_loading1.jpg",param1,FSResourceMng.PREFIX_TEXTURE);
         }
         else
         {
            InstanceMng.getResourcesMng().addResourceToLoad("loading/bg_loading1",FSResourceMng.TYPE_TEXTURE_JPG);
         }
      }
      
      private function calculateScaleFactor(param1:Number) : Number
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc2_:Number = 1;
         if(Config.FORCE_SCALE_1 && Utils.isIOS())
         {
            return 1;
         }
         if(Utils.isIOS())
         {
            _loc2_ = Utils.isIphone() || param1 < this.getDefaultStageWidth() * 1.5 ? 1 : 2;
         }
         else if(Utils.isAndroid())
         {
            _loc3_ = param1;
            _loc4_ = this.getDefaultStageWidth();
            if(_loc3_ >= _loc4_ * 3 * 0.9)
            {
               _loc2_ = 4;
            }
            else
            {
               _loc2_ = 2;
            }
         }
         else if(Utils.isDesktop() || this.isBrowserVersion())
         {
            return 4;
         }
         return _loc2_;
      }
      
      public function getFullScreenWidth() : int
      {
         if(this.isBrowserVersion())
         {
            return stage.stageWidth;
         }
         return stage.fullScreenWidth;
      }
      
      public function getFullScreenHeight() : int
      {
         if(this.isBrowserVersion())
         {
            return stage.stageHeight;
         }
         return stage.fullScreenHeight;
      }
      
      public function getDefaultStageWidth() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(Utils.isIOS())
         {
            _loc2_ = Layout.getAppleDevice(this.getFullScreenWidth(),this.getFullScreenHeight());
            switch(_loc2_)
            {
               case Layout.IPAD:
                  _loc1_ = 1024;
                  break;
               case Layout.IPHONE4:
                  _loc1_ = 960;
                  break;
               case Layout.IPHONE5:
                  _loc1_ = 1136;
            }
         }
         else if(Utils.isAndroidOrDesktop() || Utils.isBrowser())
         {
            _loc1_ = 640;
         }
         return _loc1_;
      }
      
      public function getDefaultStageHeight() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(Utils.isIOS())
         {
            _loc2_ = Layout.getAppleDevice(this.getFullScreenWidth(),this.getFullScreenHeight());
            switch(_loc2_)
            {
               case Layout.IPAD:
                  _loc1_ = 768;
                  break;
               case Layout.IPHONE4:
               case Layout.IPHONE5:
                  _loc1_ = 640;
            }
         }
         else if(Utils.isAndroidOrDesktop())
         {
            if(Utils.isTablet(stage))
            {
               _loc1_ = 400;
            }
            else
            {
               _loc1_ = 360;
            }
         }
         else if(Utils.isBrowser())
         {
            _loc1_ = 400;
         }
         return _loc1_;
      }
      
      protected function createStartupBackground() : Bitmap
      {
         return null;
      }
      
      protected function initListeners() : void
      {
         stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownHandler,false,0,true);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUpHandler,false,0,true);
         stage.addEventListener(MouseEvent.RIGHT_CLICK,this.doNothing,false,0,true);
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown,false,0,true);
         if(Utils.isBrowser() || Utils.isDesktop())
         {
            stage.addEventListener(flash.events.Event.RESIZE,this.onResize);
         }
      }
      
      private function onResize(param1:flash.events.Event) : void
      {
         this.resizeViewport();
      }
      
      protected function onKeyDown(param1:KeyboardEvent) : void
      {
         var _loc2_:UserData = Utils.getOwnerUserData();
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:Boolean = _loc2_.isDev();
         if(Config.ENVIRONMENT_ACTIVE != Config.ENVIRONMENT_PROD || _loc3_)
         {
            if(param1.keyCode == 112)
            {
               Config.smIsDebug = !Config.smIsDebug;
               FSDebug.debugTrace("smIsDebug: " + Config.smIsDebug);
               FSDebug.debugTrace("smShowConsole: " + Config.showConsole());
               this.createConsole(_loc3_);
               Config.smShowStats = !Config.smShowStats;
               Screen.resetStarlingStatsPos();
            }
            else if(param1.keyCode == 113)
            {
               Config.smTextfieldsBorder = !Config.smTextfieldsBorder;
            }
            else if(param1.keyCode == 114)
            {
               Config.smDebugTooltips = !Config.smDebugTooltips;
            }
         }
      }
      
      private function doNothing(param1:MouseEvent) : void
      {
      }
      
      private function onMouseDownHandler(param1:MouseEvent) : void
      {
         if(smData)
         {
            smData.mouseX = stage.mouseX;
            smData.mouseY = stage.mouseY;
            smData.mouseUp = false;
            smData.move = true;
         }
         stage.addEventListener(flash.events.Event.MOUSE_LEAVE,this.onStageMouseLeave,false,0,true);
         if(Root.smRootInitialized && Boolean(InstanceMng.getCurrentScreen()))
         {
            InstanceMng.getCurrentScreen().onMouseDownHandler(param1);
         }
      }
      
      private function onMouseUpHandler(param1:MouseEvent) : void
      {
         if(smData)
         {
            smData.mouseUp = true;
            smData.move = false;
         }
         stage.removeEventListener(flash.events.Event.MOUSE_LEAVE,this.onStageMouseLeave);
         if(Root.smRootInitialized && Boolean(InstanceMng.getCurrentScreen()))
         {
            InstanceMng.getCurrentScreen().onMouseUpHandler(param1);
         }
      }
      
      private function onStageMouseLeave(param1:flash.events.Event) : void
      {
         smData.move = false;
         stage.removeEventListener(flash.events.Event.MOUSE_LEAVE,this.onStageMouseLeave);
      }
      
      private function createConsole(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         if(Config.showConsole() || param1)
         {
            if(Utils.isAndroid())
            {
               Cc.config.style.traceFontSize = 25;
               Cc.config.style.controlSize = 40;
            }
            Cc.startOnStage(this);
            _loc2_ = smScaleFactor / 2;
            _loc2_ = Math.max(1,_loc2_);
            Cc.width = this.getFullScreenWidth() / 3 * _loc2_;
            Cc.height = Utils.isAndroid() && Config.PRODUCTION_BUILD ? 100 : 20;
            Cc.x = 0;
            Cc.y = 0;
            Cc.config.commandLineAllowed = true;
            Cc.commandLine = true;
            stage.addEventListener(KeyboardEvent.KEY_DOWN,CheatConsole.onTextKeyUp,false,0,true);
         }
         else if(Cc)
         {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,CheatConsole.onTextKeyUp);
            Cc.remove();
         }
      }
      
      public function getConsoleText() : String
      {
         return Cc.instance.logs.getLogsAsString("\n");
      }
      
      private function initializeDefaultManagers(param1:Function) : void
      {
         var locale:String;
         var onDefinitionManagersInitialized:Function = null;
         var onCompleteFunction:Function = param1;
         onDefinitionManagersInitialized = function():void
         {
            initializeANEs("");
            createPopupMng();
            createOfflineUserDataMng();
            mDefaultManagersFullyInitializedStarted = true;
            if(!Config.USE_OFFLINE_DB || Utils.isBrowser() || Utils.isDesktop() || Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().isOfflineDBReady()))
            {
               onOfflineDBReadyContinueInitializingManagers();
            }
            mTutorialMapMng = new TutorialMapMng();
            InstanceMng.registerTutorialMapMng(mTutorialMapMng);
            if(onCompleteFunction != null)
            {
               onCompleteFunction();
            }
         };
         Root(Starling.current.root).setLoadingTextfieldText("Initializing Managers..");
         locale = Capabilities.language.toUpperCase();
         FSResourceMng.smCurrentLocaleSelected = locale;
         TextManager.loadLang(locale);
         this.mRuleMng = new RulesMng(onDefinitionManagersInitialized);
      }
      
      public function onOfflineDBReadyContinueInitializingManagers() : void
      {
         if(!this.mDefaultManagersFullyInitialized && this.mDefaultManagersFullyInitializedStarted && (Boolean(!Config.USE_OFFLINE_DB || Utils.isBrowser() || Utils.isDesktop()) || Boolean(InstanceMng.getUserDataMng().getOwnerUserData())))
         {
            if(Config.HAS_GUILDS)
            {
               this.mGuildsMng = new GuildsMng();
               InstanceMng.registerGuildsMng(this.mGuildsMng);
            }
            if(InstanceMng.getUserDataMng() != null)
            {
               Utils.setMusicOn(InstanceMng.getUserDataMng().getOwnerUserData().flagsGetMusic());
               Utils.setSFXOn(InstanceMng.getUserDataMng().getOwnerUserData().flagsGetSound());
            }
            this.mQuestsMng = new QuestsMng();
            InstanceMng.registerQuestsMng(this.mQuestsMng);
            this.initializeServerVariables();
            this.mDefaultManagersFullyInitialized = true;
         }
      }
      
      protected function createPopupMng() : void
      {
         this.mPopupMng = new FSPopupMng();
         InstanceMng.registerPopupMng(this.mPopupMng);
      }
      
      protected function createResourcesMng() : void
      {
         this.mResourcesMng = new FSResourceMng();
         InstanceMng.registerResourcesMng(this.mResourcesMng);
      }
      
      public function initializeManagers() : void
      {
         this.mTextParticlesMng = new TextParticlesMng();
         InstanceMng.registerTextParticlesMng(this.mTextParticlesMng);
         this.createCardAnimsMng();
         this.mAbilitiesMng = new AbilitiesMng();
         InstanceMng.registerAbilitiesMng(this.mAbilitiesMng);
         this.mScoreMng = new ScoreMng();
         InstanceMng.registerScoreMng(this.mScoreMng);
         this.mSubCategoriesMng = new SubCategoriesMng();
         InstanceMng.registerSubCategoriesMng(this.mSubCategoriesMng);
         this.mTargetMng = new TargetMng();
         InstanceMng.registerTargetMng(this.mTargetMng);
         this.mBoostsMng = new BoostsMng();
         InstanceMng.registerBoostsMng(this.mBoostsMng);
         this.mTutorialMng = new TutorialMng();
         InstanceMng.registerTutorialMng(this.mTutorialMng);
         this.mTutorialDeckBuilderMng = new TutorialDeckBuilderMng();
         InstanceMng.registerTutorialDeckBuilderMng(this.mTutorialDeckBuilderMng);
         this.mConversationsMng = new ConversationsMng();
         InstanceMng.registerConversationsMng(this.mConversationsMng);
         this.mDungeonsMng = new DungeonsMng();
         InstanceMng.registerDungeonsMng(this.mDungeonsMng);
         this.mRaidsMng = new RaidsMng();
         InstanceMng.registerRaidsMng(this.mRaidsMng);
         this.mAuctionsMng = new AuctionsMng();
         InstanceMng.registerAuctionsMng(this.mAuctionsMng);
         if(Config.getConfig().gameHasComic())
         {
            this.mComicsMng = new ComicMng();
            InstanceMng.registerComicsMng(this.mComicsMng);
         }
         this.createCardsMng();
         this.mSoundFXMng = new FSSoundFXMng();
         InstanceMng.registerSoundFXMng(this.mSoundFXMng);
         this.mOnDemandDefsInitialized = true;
      }
      
      protected function createCardAnimsMng() : void
      {
         this.mCardAnimsMng = new FSCardAnimsMng();
         InstanceMng.registerCardAnimsMng(this.mCardAnimsMng);
      }
      
      protected function createCardsMng() : void
      {
         this.mCardsMng = new FSCardsMng();
         InstanceMng.registerCardsMng(this.mCardsMng);
      }
      
      public function initializeServerVariables() : void
      {
         this.initializeServer();
         if(this.mServerConnection == null)
         {
            this.mServerConnection = new ServerConnection();
            InstanceMng.registerServerConnection(this.mServerConnection);
         }
         this.createFacebookPlugin();
      }
      
      protected function createFacebookPlugin() : void
      {
         if(!this.isKongregateVersion() && !Utils.isDesktop())
         {
            if(this.mFBPlugin == null)
            {
               this.mFBPlugin = new FSFacebookPlugin();
               if(Utils.isBrowser())
               {
                  this.mFBPlugin.login();
               }
               InstanceMng.registerFacebookPlugin(this.mFBPlugin);
            }
         }
      }
      
      public function reCreateFacebookPlugin() : void
      {
         this.mFBPlugin = null;
         this.createFacebookPlugin();
      }
      
      protected function createOfflineUserDataMng() : void
      {
      }
      
      public function createOnlineUserDataMng() : void
      {
         if(this.mUserDataMng == null || !Utils.isBrowser())
         {
            this.mUserDataMng = new FSUserDataMngOnline();
         }
      }
      
      public function destroyOnlineUserDataMng() : void
      {
         if(this.mUserDataMng)
         {
            this.mUserDataMng.destroy();
            this.mUserDataMng = null;
         }
      }
      
      public function registerUserDataMng() : void
      {
         InstanceMng.registerUserDataMng(this.mUserDataMng);
      }
      
      public function areOnDemandDefinitionsInitialized() : Boolean
      {
         return this.mOnDemandDefsInitialized;
      }
      
      public function isGuildsPanelOpen() : Boolean
      {
         return Boolean(this.mGuildsPanel) && this.mGuildsPanel.isOpen();
      }
      
      public function openGuildsPanel() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Screen = null;
         var _loc3_:FSCoordinate = null;
         var _loc4_:Boolean = false;
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            if(!Screen.isScreenLocked())
            {
               this.createGuildsPanel();
               _loc1_ = this.mGuildsPanel.isOpen();
               if(_loc1_)
               {
                  this.hideGuildsPanel();
               }
               else
               {
                  if(!InstanceMng.getCurrentScreen().isTransparentBGShown())
                  {
                     InstanceMng.getCurrentScreen().createTranslucentBG(true);
                  }
                  _loc2_ = InstanceMng.getCurrentScreen();
                  FSResourceMng.addToStage(this.mGuildsPanel,FSResourceMng.LAYER_UI);
                  _loc3_ = new FSCoordinate(0,0);
                  SpecialFX.createTransition(this.mGuildsPanel,_loc3_,0.3,0);
                  this.mGuildsPanel.setItOpen(true);
                  this.mGuildsPanel.refreshCurrentSection();
                  _loc4_ = _loc2_ is FSMapScreen;
                  if(_loc4_)
                  {
                     FSMapScreen(_loc2_).make3DSceneVisible(false,0);
                  }
               }
            }
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true);
         }
      }
      
      public function createGuildsPanel() : void
      {
         if(this.mGuildsPanel == null)
         {
            this.mGuildsPanel = new GuildsPanel();
         }
         var _loc1_:Boolean = Boolean(InstanceMng.getTutorialMapMng()) && InstanceMng.getTutorialMapMng().isTutorialON();
         this.mGuildsPanel.x = _loc1_ ? 0 : -this.mGuildsPanel.width;
         this.mGuildsPanel.y = 0;
         if(_loc1_)
         {
            this.mGuildsPanel.alpha = 0;
            SpecialFX.tweenToAlpha(this.mGuildsPanel,1,0.5,0);
         }
      }
      
      public function hideGuildsPanel(param1:Number = 0.3, param2:Boolean = true) : void
      {
         var _loc3_:FSCoordinate = null;
         if(this.mGuildsPanel)
         {
            if(param2)
            {
               InstanceMng.getCurrentScreen().removeTranslucentBG(true);
            }
            this.mGuildsPanel.setItOpen(false);
            if(param1 > 0)
            {
               _loc3_ = new FSCoordinate(-this.mGuildsPanel.width,0);
               SpecialFX.createTransition(this.mGuildsPanel,_loc3_,0.3,0,this.removeGuildsPanelFromParent);
            }
            else
            {
               this.mGuildsPanel.x = -this.mGuildsPanel.width;
               this.mGuildsPanel.removeFromParent();
            }
         }
         if(InstanceMng.getCurrentScreen() is FSMapScreen)
         {
            FSMapScreen(InstanceMng.getCurrentScreen()).make3DSceneVisible(true,0);
         }
      }
      
      private function removeGuildsPanelFromParent() : void
      {
         if(this.mGuildsPanel)
         {
            this.mGuildsPanel.removeFromParent();
         }
      }
      
      public function getGuildsPanel() : GuildsPanel
      {
         return this.mGuildsPanel;
      }
      
      private function getDefaultScaleMode() : String
      {
         return StageScaleMode.NO_SCALE;
      }
      
      public function vibrate(param1:Number = 500) : void
      {
      }
      
      public function isGamePlayable() : Boolean
      {
         var _loc1_:Boolean = InstanceMng.getServerConnection().isUserLoggedIn();
         var _loc2_:Boolean = !Utils.isBrowser() || Utils.isBrowser() && _loc1_;
         var _loc3_:Boolean = !Utils.isDesktop() || Utils.isDesktop() && _loc1_;
         return Main.smGamePlayable && _loc2_ && _loc3_;
      }
      
      public function areExpansionFilesOK() : Boolean
      {
         return true;
      }
      
      public function resizeViewport() : void
      {
         FSDebug.debugTrace("--------------------------- RESIZING VIEWPORT!! ----------------------");
         FSDebug.debugTrace("stage.displayState: " + stage.displayState);
         var _loc1_:flash.geom.Rectangle = this.calculateViewport();
         if(Starling.current)
         {
            Starling.current.viewPort = _loc1_;
         }
         stage.stageWidth = _loc1_.width;
         stage.stageHeight = _loc1_.height;
      }
      
      private function calculateViewport(param1:int = 0, param2:int = 0) : flash.geom.Rectangle
      {
         var _loc7_:int = 0;
         var _loc3_:int = this.getDefaultStageWidth();
         var _loc4_:int = this.getDefaultStageHeight();
         var _loc5_:int = param1 == 0 ? this.getFullScreenWidth() : param1;
         var _loc6_:int = param2 == 0 ? this.getFullScreenHeight() : param2;
         if(_loc6_ > _loc5_)
         {
            _loc7_ = _loc6_;
            _loc6_ = _loc5_;
            _loc5_ = _loc7_;
         }
         return this.createInitialViewport(_loc3_,_loc4_,_loc5_,_loc6_);
      }
      
      public function exitApp() : void
      {
      }
      
      public function getStarling() : Starling
      {
         return this.mStarling;
      }
      
      public function setStarling(param1:Starling) : void
      {
         this.mStarling = param1;
      }
      
      public function isBrowserVersion() : Boolean
      {
         return false;
      }
      
      public function isFacebookBrowser() : Boolean
      {
         return this.mIsFacebook;
      }
      
      public function isKongregateVersion() : Boolean
      {
         return this.mIsKongregate;
      }
      
      public function hasPermanentBoosts() : Boolean
      {
         return true;
      }
      
      public function showCustomFontsForPacks() : Boolean
      {
         return false;
      }
      
      public function getKongregatePlugin() : *
      {
         return null;
      }
      
      public function getStage() : Stage
      {
         return stage;
      }
      
      public function loginViaKongregate() : void
      {
      }
      
      public function getKongAvatarURL(param1:Boolean = false) : String
      {
         return "";
      }
      
      public function sendInvitesViaKongregate(param1:String) : void
      {
      }
      
      public function kongShareCardReceived(param1:CardDef) : void
      {
      }
      
      public function kongSendLife(param1:String) : void
      {
      }
      
      public function kongRequestLife(param1:String = "") : void
      {
      }
      
      public function kongSendMapUnlock(param1:String) : void
      {
      }
      
      public function kongRequestMapUnlock() : void
      {
      }
      
      public function getKongName() : String
      {
         return "";
      }
      
      public function kongGetUserId() : String
      {
         return "";
      }
      
      public function kongRequestAPI(param1:String, param2:Object = null, param3:String = "GET", param4:Function = null) : void
      {
      }
      
      public function kongShowRegistrationBox() : void
      {
      }
      
      public function submitStat(param1:String, param2:Number) : void
      {
      }
      
      public function getCDNDomain() : String
      {
         return "https://d1qzmgnbw7y2pl.cloudfront.net/";
      }
      
      public function getZoomInViewMainFontName() : String
      {
         return FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_DESC);
      }
      
      public function getAbilitiesMainFontName() : String
      {
         return FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_DESC);
      }
      
      public function setMapScreenAsVisited() : void
      {
         this.mMapScreenVisited = true;
      }
      
      public function mapScreenHasBeenVisited() : Boolean
      {
         return this.mMapScreenVisited;
      }
      
      public function hasToCheckObbFiles() : Boolean
      {
         return Utils.isAndroid() && !Utils.isSimulator();
      }
      
      public function getFacebookPlugin() : *
      {
         return null;
      }
      
      public function isMainGameAddedToStage() : Boolean
      {
         return this.mMainGameAddedToStage;
      }
      
      public function getBase64() : Class
      {
         return Base64;
      }
      
      public function getDeviceID() : String
      {
         return "";
      }
      
      public function buyProduct(param1:String, param2:String) : void
      {
      }
      
      public function requestProducts(param1:Array) : void
      {
      }
      
      public function initializeGATracker(param1:String = "", param2:Boolean = false) : void
      {
         if(param1 == "" && !Utils.isDesktop())
         {
            if(Capabilities.isDebugger)
            {
               throw new Error("Google Analytics tracker accId empty");
            }
         }
         if(param1 != "")
         {
            smTracker = new GATracker(this.stage,param1,TrackerMode.AS3,false);
         }
      }
      
      public function getGSBrowserNamespace() : String
      {
         return this.mGSBrowserNamespace;
      }
      
      public function arePushNotificationsAuthorised() : Boolean
      {
         return false;
      }
      
      public function authorisationStatus() : void
      {
      }
      
      public function offlinePushauthorisationStatus() : void
      {
      }
      
      public function shareGame() : void
      {
      }
      
      public function arePushNotificationsRegistered() : Boolean
      {
         return false;
      }
      
      public function arePushAuthorisationStatusDenied() : Boolean
      {
         return false;
      }
      
      public function getAndroidDistriqtKey() : String
      {
         return "";
      }
      
      public function isExpansionFilesDowloading() : Boolean
      {
         return false;
      }
      
      public function isExpansionFilesRequestingAccess() : Boolean
      {
         return false;
      }
      
      public function getExpansionFileLastStateExplanation() : String
      {
         return "";
      }
      
      public function getInAppsManager() : FSInAppsManager
      {
         if(this.mInAppsManager == null)
         {
            this.mInAppsManager = new FSInAppsManager();
         }
         return this.mInAppsManager;
      }
      
      public function getDeviceExtraInfo(param1:Object) : Object
      {
         return null;
      }
      
      public function getOfflinePushNotificationsMng() : *
      {
         return null;
      }
      
      public function initializeOfflinePushNotifications() : void
      {
      }
      
      public function isMapIntroSeen(param1:String) : Boolean
      {
         return Boolean(this.mMapsIntroSeen) && this.mMapsIntroSeen[param1] == true;
      }
      
      public function setMapIntroAsSeen(param1:String) : void
      {
         if(this.mMapsIntroSeen == null)
         {
            this.mMapsIntroSeen = new Dictionary(true);
         }
         this.mMapsIntroSeen[param1] = true;
      }
      
      public function checkInternetConnection() : void
      {
      }
      
      public function getRuleMng() : RulesMng
      {
         return this.mRuleMng;
      }
      
      public function scheduleNotifications(param1:Number, param2:int) : void
      {
         if(Utils.isMobile())
         {
            if(this.getOfflinePushNotificationsMng())
            {
               this.getOfflinePushNotificationsMng().showNotification(param2,param1);
            }
            else
            {
               this.initializeOfflinePushNotifications();
               this.getOfflinePushNotificationsMng().showNotification(param2,param1);
            }
         }
      }
      
      public function androidTestBack() : void
      {
      }
      
      public function trackFirebaseEvent(param1:String, param2:Array = null, param3:Array = null) : void
      {
      }
      
      public function trackPurchaseFirebase(param1:Number, param2:String) : void
      {
      }
      
      public function trackCurrentScreen(param1:String) : void
      {
      }
      
      public function firebaseSetUserData(param1:String, param2:String) : void
      {
      }
      
      public function firebaseOnLogin() : void
      {
      }
      
      public function firebasePrintOptions() : void
      {
      }
      
      public function firebaseUpdateDisplayName() : void
      {
      }
      
      public function firebaseAddToDatabase(param1:int, param2:int, param3:Boolean, param4:Boolean, param5:Boolean) : void
      {
      }
      
      public function getMainAssetManager() : FSAssetManager
      {
         return this.mMainAssetManager;
      }
      
      public function steamGetSessionTicket() : String
      {
         return "";
      }
      
      public function steamGetSteamId() : String
      {
         return "";
      }
      
      public function steamRelogin() : void
      {
      }
      
      public function steamCheckAchievement(param1:String) : void
      {
      }
      
      public function steamCheckStat(param1:String) : void
      {
      }
      
      public function steamClearAchievement(param1:String) : void
      {
      }
      
      public function steamResetAllStats(param1:Boolean) : void
      {
      }
      
      public function hasUserSignedIntoApple() : Boolean
      {
         return false;
      }
      
      public function appleSignIn() : void
      {
      }
      
      public function loginViaAppleSignIn() : void
      {
      }
      
      public function appleSignInIsSupported() : Boolean
      {
         return false;
      }
      
      public function appleSignInRevokeAccess() : void
      {
      }
      
      public function appleGetUserId() : String
      {
         return "";
      }
   }
}

