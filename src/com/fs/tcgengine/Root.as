package com.fs.tcgengine
{
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.FSLoadingAnimMng;
   import com.fs.tcgengine.controller.PvPConnectionMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.battle.BattleEnginePvP;
   import com.fs.tcgengine.resources.FSAssetManager;
   import com.fs.tcgengine.screens.FSAuctionsScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.TimerUtil;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.anims.misc.FSCircularPreloader;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import feathers.themes.MetalWorksMobileTheme;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   import starling.core.Starling;
   import starling.display.BlendMode;
   import starling.display.Sprite;
   import starling.events.EnterFrameEvent;
   import starling.events.Event;
   import starling.textures.Texture;
   import starling.utils.Align;
   import starling.utils.SystemUtil;
   
   public class Root extends Sprite
   {
      
      private static var sAssets:FSAssetManager;
      
      public static var smBattleData:Object;
      
      public static var smCurrentLevelScore:Object;
      
      private static var smDeactivatedTimer:uint;
      
      private static var smNeedsToCheckPvPTimer:Boolean;
      
      public static var smTheme:MetalWorksMobileTheme;
      
      public static const INIT_SCREEN_NAME:String = Constants.MENU_SCREEN_NAME;
      
      public static var smRootInitialized:Boolean = false;
      
      public static var smIdleTimeMs:Number = -1;
      
      public static var smPvPIdleTimeMs:Number = -1;
      
      public static var smRootDeactivated:Boolean = false;
      
      public static var smCraftsAvailable:Boolean = false;
      
      private var mActiveScene:Screen;
      
      private var mNextScene:Class;
      
      private var mBG:FSImage;
      
      protected var mLoadingTextfield:FSTextfield;
      
      private var mCircularPreloader:FSCircularPreloader;
      
      public var mInitializerTextfield:FSTextfield;
      
      public var mErrorTextfield:FSTextfield;
      
      protected var mLoadingScreenImage:FSImage;
      
      protected var mLoadingAnimMng:FSLoadingAnimMng;
      
      private var mTimer:Timer;
      
      public function Root()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler);
         addEventListener(Screen.START_BATTLE,this.onStartBattle);
         addEventListener(Screen.GO_TO_MENU,this.onGoToMenu);
         addEventListener(Screen.GO_TO_MAP,this.onGoToMap);
         addEventListener(Screen.GO_TO_DECK_BUILDER,this.onGoToDeckBuilder);
         addEventListener(Screen.GO_TO_SHOP,this.onGoToShop);
         addEventListener(Screen.GO_TO_PVP,this.onGoToPvP);
         addEventListener(Screen.GO_TO_DUNGEONS,this.onGoToDungeons);
         addEventListener(Screen.GO_TO_RAIDS,this.onGoToRaids);
         addEventListener(Screen.GO_TO_AUCTIONS,this.onGoToAuctions);
         addEventListener(Screen.SCREEN_UNLOADED,this.onScreenUnloaded);
         addEventListener(EnterFrameEvent.ENTER_FRAME,this.onEnterFrame);
         alpha = 0.999;
      }
      
      public static function onLocaleChangedRefreshStyles() : void
      {
         if(smTheme == null)
         {
            smTheme = new MetalWorksMobileTheme();
            Starling.current.stage.color = 0;
            Starling.current.nativeStage.color = 0;
         }
      }
      
      public static function get assets() : FSAssetManager
      {
         return sAssets;
      }
      
      public static function onActivate() : void
      {
         var _loc1_:String = null;
         var _loc2_:Number = NaN;
         FSDebug.debugTrace("handle Activate");
         smRootDeactivated = false;
         if(smPvPIdleTimeMs != -1)
         {
            Utils.removeLog();
         }
         if(InstanceMng.getServerConnection())
         {
            _loc1_ = InstanceMng.getServerConnection().getUserId();
            if(!Config.ONLY_SERVER_TRACES)
            {
               InstanceMng.getServerConnection().notifyDeviceActivation(_loc1_,"ACTIVATED");
            }
         }
         if(Utils.isMobile() && smIdleTimeMs != -1 && smRootInitialized)
         {
            _loc2_ = TimerUtil.currentTimeMillis();
            if(smIdleTimeMs < _loc2_ - Config.IDLE_TIME_RELOGIN)
            {
               if(InstanceMng.getServerConnection() != null)
               {
                  InstanceMng.getServerConnection().refreshSessionOnActivate();
               }
            }
         }
         smIdleTimeMs = -1;
         smPvPIdleTimeMs = -1;
         if(InstanceMng.getCurrentScreen() is FSAuctionsScreen)
         {
            FSAuctionsScreen(InstanceMng.getCurrentScreen()).refreshServerTime();
         }
         Utils.resumeAllSounds();
      }
      
      private static function onTimerCheckPvP() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         smNeedsToCheckPvPTimer = needsToCheckPvPTimer();
         var _loc1_:Number = TimerUtil.currentTimeMillis();
         if(smPvPIdleTimeMs != -1 && smNeedsToCheckPvPTimer)
         {
            _loc2_ = TimerUtil.msToSec(_loc1_ - smPvPIdleTimeMs);
            _loc3_ = Config.IDLE_TIME_DESYNC;
            _loc4_ = _loc3_ - _loc2_;
            FSDebug.debugTrace("Idle Time: " + _loc2_);
            if(_loc2_ > _loc3_)
            {
               FSDebug.debugTrace("PvPExpirationTime: " + PvPConnectionMng.smExpirationTimeLeft);
               Utils.setLogText(TextManager.getText("TID_GEN_DESYNC"),true);
               BattleEnginePvP.pvpDesyncPlayerForInactivity(true);
            }
            else if(_loc2_ >= _loc3_ / 2 && PvPConnectionMng.smExpirationTimeLeft > 0)
            {
               _loc5_ = _loc4_ > 10 && _loc4_ % 2 != 0 || _loc4_ <= 10;
               Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_PVP_INACTIVE"),[_loc2_,_loc4_]),false,false,false,_loc5_);
            }
         }
         else
         {
            smPvPIdleTimeMs = smPvPIdleTimeMs == -1 && smNeedsToCheckPvPTimer ? _loc1_ : -1;
         }
         smDeactivatedTimer = setTimeout(onTimerCheckPvP,1000);
      }
      
      private static function onDeactivateCheckPvP() : void
      {
         if(Utils.isMobile() && smRootInitialized && Config.ENVIRONMENT_ACTIVE == Config.ENVIRONMENT_PROD)
         {
            if(PvPConnectionMng.smUserInPvPQueue)
            {
               PvPConnectionMng.removeFromPvPQueue(true);
               InstanceMng.getPopupMng().openErrorPopup(TextManager.getText("TID_PVP_QUEUE_REMOVED"),false,true);
            }
         }
      }
      
      private static function needsToCheckPvPTimer() : Boolean
      {
         if(PvPConnectionMng.smPlayingAgainstOfflineDeck || SystemUtil.isApplicationActive)
         {
            return false;
         }
         var _loc1_:BattleEngine = InstanceMng.getBattleEngine();
         return _loc1_ != null && _loc1_.isOnlineMatch() && !_loc1_.isPlayersIntroPlaying() && _loc1_.isOwnerTurn() && !_loc1_.isBattleOver();
      }
      
      public static function onDeactivate() : void
      {
         var _loc1_:String = null;
         smRootDeactivated = true;
         smIdleTimeMs = TimerUtil.currentTimeMillis();
         smNeedsToCheckPvPTimer = needsToCheckPvPTimer();
         smPvPIdleTimeMs = smNeedsToCheckPvPTimer ? smIdleTimeMs : -1;
         Utils.pauseAllSounds();
         if(InstanceMng.getServerConnection())
         {
            _loc1_ = InstanceMng.getServerConnection().getUserId();
            if(!Config.ONLY_SERVER_TRACES)
            {
               InstanceMng.getServerConnection().notifyDeviceActivation(_loc1_,"DEACTIVATED");
            }
         }
         if(InstanceMng.getServerConnection())
         {
            InstanceMng.getServerConnection().addUserActionBlock();
         }
         if(!Config.ONLY_SERVER_TRACES)
         {
            onDeactivateCheckPvP();
         }
         if(InstanceMng.getCurrentScreen() is FSAuctionsScreen)
         {
            FSAuctionsScreen(InstanceMng.getCurrentScreen()).refreshServerTime();
         }
         FSDebug.debugTrace("handle deActivate");
      }
      
      private function handleInactivityTimer() : void
      {
         FSDebug.debugTrace("[INACTIVITY TIMER] Creating TIMER");
         this.mTimer = new Timer(TimerUtil.minToMs(30));
         this.mTimer.start();
         this.mTimer.addEventListener(TimerEvent.TIMER,this.onUserInactive);
         InstanceMng.getApplication().getStage().addEventListener(MouseEvent.MOUSE_MOVE,this.stopTimer);
         InstanceMng.getApplication().getStage().addEventListener(MouseEvent.MOUSE_DOWN,this.stopTimer);
         InstanceMng.getApplication().getStage().addEventListener(MouseEvent.MOUSE_UP,this.stopTimer);
      }
      
      private function onUserInactive(param1:TimerEvent) : void
      {
         FSDebug.debugTrace("[INACTIVITY TIMER] User inactive");
         if(InstanceMng.getServerConnection())
         {
            InstanceMng.getServerConnection().onConnectionKO();
         }
         this.mTimer.removeEventListener(TimerEvent.TIMER,this.onUserInactive);
      }
      
      private function stopTimer(param1:MouseEvent) : void
      {
         this.mTimer.stop();
         this.mTimer.start();
         if(!this.mTimer.hasEventListener(TimerEvent.TIMER))
         {
            FSDebug.debugTrace("[INACTIVITY TIMER] Adding ev. listener");
            this.mTimer.addEventListener(TimerEvent.TIMER,this.onUserInactive);
         }
      }
      
      private function onEnterFrame(param1:EnterFrameEvent) : void
      {
         if(smRootDeactivated && Utils.isIOS())
         {
            return;
         }
         if(smRootInitialized)
         {
            if(InstanceMng.getCurrentScreen() != null)
            {
               InstanceMng.getCurrentScreen().onEnterFrame(param1);
            }
            if(Config.smLivesSystemEnabled && Boolean(InstanceMng.getUserDataMng()))
            {
               InstanceMng.getUserDataMng().onEnterFrame(param1);
            }
            if(Boolean(InstanceMng.getBattleEngine()) && InstanceMng.getBattleEngine().isOnlineMatch())
            {
               BattleEnginePvP(InstanceMng.getBattleEngine()).onEnterFrame(param1);
            }
         }
         if(Utils.smShakeRequested)
         {
            Utils.shakeScreen();
         }
         if(this.mLoadingAnimMng)
         {
            this.mLoadingAnimMng.onEnterFrame(param1);
         }
      }
      
      protected function addedToStageHandler(param1:Event) : void
      {
         smTheme = new MetalWorksMobileTheme();
         Starling.current.stage.color = 0;
         Starling.current.nativeStage.color = 0;
         this.handleInactivityTimer();
         smDeactivatedTimer = setTimeout(onTimerCheckPvP,1000);
      }
      
      public function start(param1:Texture, param2:FSAssetManager, param3:Function) : void
      {
         var background:Texture = param1;
         var assets:FSAssetManager = param2;
         var onComplete:Function = param3;
         sAssets = assets;
         this.mBG = new FSImage(background);
         addChild(this.mBG);
         this.mCircularPreloader = new FSCircularPreloader();
         this.mCircularPreloader.x = Starling.current.stage.stageWidth - this.mCircularPreloader.width / 2;
         this.mCircularPreloader.y = this.mCircularPreloader.height / 2;
         addChild(this.mCircularPreloader);
         this.createLoadingTextfield();
         this.setLoadingTextfieldText("Loading resources...");
         assets.loadQueue(function onProgress(param1:Number):void
         {
            var ratio:Number = param1;
            mLoadingTextfield.text = int(ratio * 100).toString();
            if(ratio == 1)
            {
               Starling.juggler.delayCall(function():void
               {
                  onComplete(onManagersInitialized);
               },0.35);
            }
         });
      }
      
      public function setLoadingTextfieldText(param1:String) : void
      {
         if(this.mInitializerTextfield == null)
         {
            this.createInitializerTextfield();
         }
         if(this.mInitializerTextfield)
         {
            this.mInitializerTextfield.text = param1;
         }
      }
      
      public function onManagersInitialized() : void
      {
         this.showScene(InstanceMng.getResourcesMng().getScreenClassByName(Constants.MENU_SCREEN_NAME));
      }
      
      public function removeRootInitialLoadingScreenAndInitialize() : void
      {
         smRootInitialized = true;
         if(this.mInitializerTextfield)
         {
            this.mInitializerTextfield.removeFromParent(true);
            this.mInitializerTextfield = null;
         }
         if(this.mErrorTextfield)
         {
            this.mErrorTextfield.removeFromParent(true);
            this.mErrorTextfield = null;
         }
         if(this.mLoadingTextfield)
         {
            this.mLoadingTextfield.removeFromParent(true);
            this.mLoadingTextfield = null;
         }
         if(this.mCircularPreloader)
         {
            this.mCircularPreloader.removeFromParent(true);
            this.mCircularPreloader = null;
         }
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         InstanceMng.getResourcesMng().removeDefinitions();
      }
      
      private function onStartBattle(param1:Event) : void
      {
         FSDebug.debugTrace("The user is starting now a battle!");
         var _loc2_:String = "";
         var _loc3_:Boolean = false;
         if(param1.data != null)
         {
            if(smBattleData == null)
            {
               smBattleData = new Object();
            }
            smBattleData.pvp = param1.data[1];
            _loc3_ = smBattleData.pvp != null && smBattleData.pvp == true;
            if(!_loc3_)
            {
               smBattleData.levelSku = param1.data[0];
               smBattleData.isDungeon = param1.data[2];
               smBattleData.isRaid = param1.data[3];
            }
         }
         if(_loc3_)
         {
            PvPConnectionMng.init();
            this.showScene(InstanceMng.getResourcesMng().getScreenClassByName(Constants.BATTLE_SCREEN_PVP_NAME));
         }
         else
         {
            this.showScene(InstanceMng.getResourcesMng().getScreenClassByName(Constants.BATTLE_SCREEN_NAME));
         }
      }
      
      protected function onGoToMenu(param1:Event) : void
      {
         FSDebug.debugTrace("The user is going back to the menu!");
         this.showScene(InstanceMng.getResourcesMng().getScreenClassByName(Constants.MENU_SCREEN_NAME));
      }
      
      private function onGoToMap(param1:Event) : void
      {
         FSDebug.debugTrace("The user is going to the map!");
         this.showScene(InstanceMng.getResourcesMng().getScreenClassByName(Constants.MAP_SCREEN_NAME));
      }
      
      private function onGoToDeckBuilder(param1:Event) : void
      {
         FSDebug.debugTrace("The user is going to the DeckBuider!");
         this.showScene(InstanceMng.getResourcesMng().getScreenClassByName(Constants.DECK_BUILDER_SCREEN_NAME));
      }
      
      private function onGoToShop(param1:Event) : void
      {
         FSDebug.debugTrace("The user is going to the Shop!");
         this.showScene(InstanceMng.getResourcesMng().getScreenClassByName(Constants.SHOP_SCREEN_NAME));
      }
      
      private function onGoToPvP(param1:Event) : void
      {
         FSDebug.debugTrace("The user is going to the PvP!");
         this.showScene(InstanceMng.getResourcesMng().getScreenClassByName(Constants.PVP_SCREEN_NAME));
      }
      
      private function onGoToDungeons(param1:Event) : void
      {
         FSDebug.debugTrace("The user is going to the Dungeons system!");
         this.showScene(InstanceMng.getResourcesMng().getScreenClassByName(Constants.DUNGEONS_SCREEN_NAME));
      }
      
      private function onGoToRaids(param1:Event) : void
      {
         FSDebug.debugTrace("The user is going to the Raids system!");
         this.showScene(InstanceMng.getResourcesMng().getScreenClassByName(Constants.RAIDS_SCREEN_NAME));
      }
      
      private function onGoToAuctions(param1:Event) : void
      {
         FSDebug.debugTrace("The user is going to the Auctions system!");
         this.showScene(InstanceMng.getResourcesMng().getScreenClassByName(Constants.AUCTIONS_SCREEN_NAME));
      }
      
      private function onScreenUnloaded(param1:Event) : void
      {
         FSDebug.debugTrace("Screen succesfully unloaded");
         this.mActiveScene = null;
         this.loadNewScreen();
      }
      
      private function loadNewScreen() : void
      {
         FSDebug.debugTrace("Loading new screen");
         if(this.mNextScene)
         {
            this.mActiveScene = new this.mNextScene();
            addChild(this.mActiveScene);
         }
         this.mNextScene = null;
      }
      
      private function showScene(param1:Class) : void
      {
         if((InstanceMng.getCurrentScreen() == null || InstanceMng.getCurrentScreen() != null && InstanceMng.getCurrentScreen().isFullyLoaded()) && !Root.assets.isLoading && (InstanceMng.getPopupMng() != null && InstanceMng.getPopupMng().getPopupShown() == null) && this.mNextScene != param1)
         {
            this.mNextScene = param1;
            if(this.mActiveScene)
            {
               this.mActiveScene.checkIfLoadingScreenIsNeeded();
               setTimeout(this.mActiveScene.unload,20);
            }
            else
            {
               this.loadNewScreen();
            }
         }
      }
      
      protected function createLoadingTextfield() : void
      {
         this.mLoadingTextfield = new FSTextfield(this.mCircularPreloader.width * 0.8,this.mCircularPreloader.height * 0.8);
         this.mLoadingTextfield.alignPivot();
         this.mLoadingTextfield.fontName = Main.getGameFont().fontName;
         this.mLoadingTextfield.fontSize = Utils.isDesktop() && !Utils.isBrowser() ? 13 : 30;
         this.mLoadingTextfield.x = this.mCircularPreloader.x;
         this.mLoadingTextfield.y = this.mCircularPreloader.y;
         this.mLoadingTextfield.format.horizontalAlign = Align.CENTER;
         addChild(this.mLoadingTextfield);
      }
      
      private function createInitializerTextfield() : void
      {
         this.mInitializerTextfield = new FSTextfield(Starling.current.stage.stageWidth / 2,Starling.current.stage.stageHeight / 10);
         this.mInitializerTextfield.alignPivot();
         this.mInitializerTextfield.fontName = Main.getGameFont().fontName;
         this.mInitializerTextfield.fontSize = Utils.isDesktop() || Utils.isBrowser() ? 10 : 20;
         this.mInitializerTextfield.x = Starling.current.stage.stageWidth / 2;
         this.mInitializerTextfield.y = Starling.current.stage.stageHeight - this.mInitializerTextfield.height / 2;
         this.mInitializerTextfield.format.horizontalAlign = Align.CENTER;
         addChild(this.mInitializerTextfield);
      }
      
      public function showErrorTextfield(param1:String) : void
      {
         this.mErrorTextfield = new FSTextfield(Starling.current.stage.stageWidth / 2,Starling.current.stage.stageHeight / 10,param1,16711680);
         this.mErrorTextfield.alignPivot();
         this.mErrorTextfield.fontName = Main.getGameFont().fontName;
         this.mErrorTextfield.fontSize = 35;
         this.mErrorTextfield.x = Starling.current.stage.stageWidth / 2;
         this.mErrorTextfield.y = Starling.current.stage.stageHeight * 0.1;
         this.mErrorTextfield.format.horizontalAlign = Align.CENTER;
         addChild(this.mErrorTextfield);
      }
      
      public function showLoadingScreenImage(param1:Boolean, param2:Boolean = false) : void
      {
         if(param1)
         {
            if(this.mLoadingScreenImage == null)
            {
               this.mLoadingScreenImage = this.getLoadingBG();
               if(this.mLoadingScreenImage)
               {
                  this.mLoadingScreenImage.blendMode = BlendMode.NONE;
                  this.mLoadingScreenImage.touchable = false;
               }
            }
            if(this.mLoadingScreenImage)
            {
               addChild(this.mLoadingScreenImage);
               if(this.mLoadingAnimMng == null)
               {
                  this.mLoadingAnimMng = new FSLoadingAnimMng(this.mLoadingScreenImage);
               }
               else
               {
                  this.mLoadingAnimMng.setRandomTip();
               }
            }
         }
         else if(this.mLoadingScreenImage)
         {
            this.mLoadingScreenImage.removeFromParent();
            this.mLoadingScreenImage.destroy();
            this.mLoadingScreenImage = null;
         }
      }
      
      private function getLoadingBG() : FSImage
      {
         Main.smNextLoadingBGName = Main.smNextLoadingBGName == "" ? "bg_loading1" : Main.smNextLoadingBGName;
         Main.smPreviousLoadingBGName = Main.smNextLoadingBGName;
         return new FSImage(Root.assets.getTexture(Main.smNextLoadingBGName));
      }
      
      public function getNextLoadingBGName() : String
      {
         var _loc1_:int = Config.getConfig().getGameBGLoadingNumber();
         var _loc2_:int = Utils.randomInt(1,_loc1_);
         var _loc3_:String = _loc1_ > 1 ? Constants.LOADING_BG_NAME + _loc2_ : Constants.LOADING_BG_NAME + "1";
         Main.smNextLoadingBGName = Main.smNextLoadingBGName == "" ? "bg_loading1" : _loc3_;
         return Main.smNextLoadingBGName;
      }
      
      public function removeLoadingResources() : void
      {
         if(this.mLoadingTextfield)
         {
            this.mLoadingTextfield.removeFromParent(true);
            this.mLoadingTextfield = null;
         }
         if(this.mLoadingScreenImage)
         {
            this.mLoadingScreenImage.removeFromParent();
            this.mLoadingScreenImage.destroy();
            this.mLoadingScreenImage = null;
         }
         if(this.mLoadingAnimMng)
         {
            this.mLoadingAnimMng.dispose();
            this.mLoadingAnimMng = null;
         }
      }
      
      public function setLoadingScreenText(param1:String) : void
      {
         if(this.mLoadingAnimMng)
         {
            this.mLoadingAnimMng.setLoadingText(param1);
         }
      }
      
      public function getLoadingScreenImage() : FSImage
      {
         return this.mLoadingScreenImage;
      }
   }
}

