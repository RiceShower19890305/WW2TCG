package com.fs.tcgengine.screens
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.ErrorsMng;
   import com.fs.tcgengine.controller.PvPConnectionMng;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.particles.FSPDParticleSystem;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.FSCardXL;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.misc.FSAuctionTicketsVisor;
   import com.fs.tcgengine.view.components.misc.FSLoadingCardMC;
   import com.fs.tcgengine.view.components.misc.FSLoadingMC;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.misc.FSLogPanel;
   import com.fs.tcgengine.view.misc.FSVisualCounter;
   import com.fs.tcgengine.view.misc.OptionsPanel;
   import com.fs.tcgengine.view.misc.RewardsEffect;
   import com.fs.tcgengine.view.popups.Popup;
   import com.fs.tcgengine.view.popups.misc.PopupStandard;
   import com.greensock.TweenMax;
   import com.greensock.easing.Bounce;
   import com.greensock.easing.Circ;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.setTimeout;
   import starling.core.Starling;
   import starling.display.BlendMode;
   import starling.display.DisplayObject;
   import starling.display.Quad;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.extensions.lighting.LightSource;
   import starling.extensions.lighting.LightStyle;
   import starling.textures.RenderTexture;
   import starling.utils.Align;
   import starling.utils.Color;
   
   public class Screen extends Component
   {
      
      public static var smRewardEffect:RewardsEffect;
      
      public static var smCarrousselTransitionON:Boolean;
      
      public static const START_GAME:String = "startGame";
      
      public static const START_BATTLE:String = "startBattle";
      
      public static const GO_TO_MENU:String = "goToMenu";
      
      public static const GO_TO_MAP:String = "goToMap";
      
      public static const GO_TO_DECK_BUILDER:String = "goToDeckBuilder";
      
      public static const GO_TO_SHOP:String = "goToShop";
      
      public static const GO_TO_PVP:String = "goToPVP";
      
      public static const GO_TO_DUNGEONS:String = "goToDungeons";
      
      public static const GO_TO_RAIDS:String = "goToRaids";
      
      public static const GO_TO_AUCTIONS:String = "goToAuctions";
      
      public static const SCREEN_UNLOADED:String = "screenUnloaded";
      
      public static var smOpeningPack:Boolean = false;
      
      protected var mBGSprite:Component;
      
      protected var mBG:FSImage;
      
      protected var mBGName:String;
      
      protected var mParticleFX:FSPDParticleSystem;
      
      protected var mExtraParticleFX:FSPDParticleSystem;
      
      protected var mSnowParticleFX:FSPDParticleSystem;
      
      protected var mOptionsWheel:OptionsPanel;
      
      protected var mTouchableBG:Quad;
      
      private var mTouchableImage:FSImage;
      
      private var mTouchableRenderTexture:RenderTexture;
      
      protected var mTransparentBGShown:Boolean;
      
      protected var mScreenFullyLoaded:Boolean;
      
      protected var mNeedsLoadingBar:Boolean = true;
      
      private var mBrowserLoadingsSlow:FSTextfield;
      
      private var mLoadingInetDataIcon:FSLoadingMC;
      
      private var mLoadingResourcesIcon:FSLoadingMC;
      
      protected var mOnlineDataSynced:Boolean;
      
      private var mLogPanel:FSLogPanel;
      
      private var mZoomedCardXL:FSCardXL;
      
      protected var mScreenName:String;
      
      private var mComicContainer:Component;
      
      protected var mConnectionStatusImg:FSImage;
      
      protected var mBackButton:FSButton;
      
      protected var mGuildsButton:FSButton;
      
      protected var mGuildsButtonVisualCounter:FSVisualCounter;
      
      private var mGuildsButtonTweens:Array;
      
      private var mGuildsButtonCoordOrig:FSCoordinate;
      
      private var mGuildsAnimEffectDone:Boolean;
      
      private var mGuildsButtonCoordDest:FSCoordinate;
      
      private var mUILocked:Boolean = false;
      
      protected var mSelectedCard:FSCard;
      
      private var mBGLightStyle:LightStyle;
      
      private var mBGAmbientLight:LightSource;
      
      public function Screen()
      {
         name = this.mScreenName;
         InstanceMng.registerCurrentScreen(this);
         FSTracker.trackMiscAction(FSTracker.CATEGORY_SCREEN,FSTracker.ACTION_VISITED,{"Screen":this.mScreenName});
         this.mScreenFullyLoaded = false;
         super();
         this.init();
         this.setResourcesToLoad();
         resetStarlingStatsPos();
      }
      
      public static function resetStarlingStatsPos(param1:String = "left", param2:String = "bottom") : void
      {
         var _loc4_:Number = NaN;
         var _loc3_:Main = InstanceMng.getApplication();
         if(_loc3_ != null && _loc3_.getStarling() != null)
         {
            if(Config.smShowStats)
            {
               _loc4_ = Utils.isIOS() || Utils.isBrowser() ? Math.max(2,Main.smScaleFactor / 2) : Math.max(1,Main.smScaleFactor / 2);
               _loc4_ = Utils.isDesktop() ? 1 : _loc4_;
               _loc3_.getStarling().showStatsAt(param1,param2,_loc4_);
            }
            else
            {
               _loc3_.getStarling().showStats = false;
            }
         }
      }
      
      public static function isScreenLocked() : Boolean
      {
         return smOpeningPack || Root.assets.isLoading || InstanceMng.getPopupMng().isPopupLoading();
      }
      
      protected function init() : void
      {
         this.createConnectionImages();
         if(!this.mNeedsLoadingBar)
         {
            this.createBG();
         }
         this.setupOnlineDataSyncing();
         if(this.mLogPanel == null)
         {
            this.mLogPanel = InstanceMng.getResourcesMng().createLogPanel();
         }
         InstanceMng.registerLogPanel(this.mLogPanel);
      }
      
      protected function createBG() : void
      {
         if(this.mBG != null)
         {
            return;
         }
         if(this.mBGName != "" && this.mBGName != null)
         {
            if(Root.assets.getTexture(this.mBGName) != null)
            {
               this.mBG = new FSImage(Root.assets.getTexture(this.mBGName),false);
               this.mBG.touchable = false;
               this.mBG.blendMode = BlendMode.NONE;
               this.mBGSprite = new Component();
               this.mBGSprite.addChild(this.mBG);
            }
            else
            {
               if(this.mBGSprite != null)
               {
                  return;
               }
               this.mBGSprite = Utils.createCustomBox("bg_custom",InstanceMng.getApplication().getDefaultStageWidth(),true);
            }
            this.mBGSprite.touchable = false;
         }
         if(this.mBGSprite != null)
         {
            if(this.mNeedsLoadingBar)
            {
               addChildAt(this.mBGSprite,0);
            }
            else
            {
               addChild(this.mBGSprite);
            }
         }
         this.addLights();
      }
      
      public function addLights(param1:Boolean = false, param2:Boolean = false) : void
      {
         var _loc3_:UserData = null;
         var _loc4_:Boolean = false;
         if(param2)
         {
            if(Boolean(this.mBG) && param1)
            {
               this.mBGLightStyle = new LightStyle();
               this.mBGLightStyle.ambientRatio = 1;
               this.mBGLightStyle.diffuseRatio = 0.7;
               this.mBGLightStyle.specularRatio = 0.5;
               this.mBGLightStyle.shininess = 16;
            }
            _loc3_ = Utils.getOwnerUserData();
            _loc4_ = Boolean(_loc3_) && _loc3_.flagsGetShowLightFX();
            if(_loc4_)
            {
               if(this.mBGAmbientLight == null)
               {
                  this.mBGAmbientLight = LightSource.createAmbientLight(Color.WHITE,1);
               }
               addChild(this.mBGAmbientLight);
               if(this.mBG)
               {
                  this.mBG.style = this.mBGLightStyle;
               }
            }
            else
            {
               this.removeLights();
            }
         }
      }
      
      public function removeLights() : void
      {
         if(this.mBG)
         {
            this.mBG.style = null;
         }
         if(this.mBGAmbientLight)
         {
            this.mBGAmbientLight.removeFromParent();
         }
      }
      
      protected function setupOnlineDataSyncing() : void
      {
         if(!Utils.smInternetAvailable)
         {
            this.mOnlineDataSynced = false;
            this.showLoadingIcon(false,false);
         }
         else if(this.mOnlineDataSynced)
         {
            this.showLoadingIcon(false,false);
         }
      }
      
      public function checkIfLoadingScreenIsNeeded() : void
      {
         if(!this.mNeedsLoadingBar)
         {
            this.mScreenFullyLoaded = true;
         }
         if(this.mNeedsLoadingBar)
         {
            Root(Starling.current.root).showLoadingScreenImage(true);
         }
      }
      
      public function needsLoadingBar() : Boolean
      {
         return this.mNeedsLoadingBar;
      }
      
      protected function createBackButton() : void
      {
         if(this.showBackButton())
         {
            if(this.mBackButton == null)
            {
               this.mBackButton = new FSButton(Root.assets.getTexture(Constants.BACK_BUTTON_NAME));
               this.mBackButton.name = "back_button";
               this.mBackButton.fontName = FSResourceMng.getFontByType();
               this.mBackButton.fontColor = 16777215;
               this.setBackButtonPos();
               this.mBackButton.addEventListener(Event.TRIGGERED,this.onBack);
               addChild(this.mBackButton);
            }
            else
            {
               addChild(this.mBackButton);
            }
         }
      }
      
      protected function setBackButtonPos() : void
      {
         var _loc1_:int = this is FSMapScreen || this is FSDungeonsScreen ? int(Starling.current.stage.stageWidth - this.mBackButton.width / 2) : int(Starling.current.stage.stageWidth - this.mBackButton.width / 1.5);
         var _loc2_:int = this is FSDeckBuilderScreen || this is FSDungeonsScreen ? int(this.mBackButton.height / 1.85) : int(this.mBackButton.height / 2);
         if(this.mBackButton)
         {
            this.mBackButton.x = _loc1_;
            this.mBackButton.y = _loc2_;
         }
      }
      
      private function onBack(param1:Event) : void
      {
         var _loc2_:Screen = null;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         if(InstanceMng.getPopupMng().getPopupShown() == null)
         {
            this.disableBackButtonTemporarily(1);
            _loc2_ = InstanceMng.getCurrentScreen();
            if(_loc2_ is FSMapScreen)
            {
               _loc3_ = FSMapScreen(_loc2_).isSubMenuShown();
               if(_loc3_)
               {
                  FSMapScreen(_loc2_).closeSubMenu();
               }
               FSMapScreen(_loc2_).showMenu();
            }
            else if(_loc2_ is FSDeckBuilderScreen)
            {
               _loc4_ = FSDeckBuilderScreen(_loc2_).getDeckCardsPanel() ? !FSDeckBuilderScreen(_loc2_).getDeckCardsPanel().isMoving() : true;
               if(_loc4_)
               {
                  if(FSDeckBuilderScreen(_loc2_).getEdidionStatus() == FSDeckBuilderScreen.STATUS_EDITING)
                  {
                     FSDeckBuilderScreen(_loc2_).setExitRequested(true);
                     InstanceMng.getPopupMng().openUnsavedDataPopup();
                  }
                  else
                  {
                     if(InstanceMng.getTutorialDeckBuilderMng().isTutorialON())
                     {
                        InstanceMng.getTutorialDeckBuilderMng().increaseCurrentStep();
                     }
                     FSDeckBuilderScreen(_loc2_).showMap();
                  }
               }
            }
            else if(_loc2_ is FSShopScreen)
            {
               FSShopScreen(_loc2_).showMap();
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
            else if(_loc2_ is FSAuctionsScreen)
            {
               FSAuctionsScreen(_loc2_).killServerCalls();
               FSAuctionsScreen(_loc2_).showMap();
            }
         }
      }
      
      public function disableBackButtonTemporarily(param1:int = 3) : void
      {
         this.enableBackButton(false);
         setTimeout(this.enableBackButton,param1 * 1000,true);
      }
      
      public function enableBackButton(param1:Boolean) : void
      {
         if(this.mBackButton)
         {
            this.mBackButton.enabled = param1;
         }
      }
      
      private function showBackButton() : Boolean
      {
         return this is FSMapScreen || this is FSShopScreen || this is FSDeckBuilderScreen || this is FSPvPScreen || this is FSDungeonsScreen || this is FSRaidsScreen || this is FSAuctionsScreen;
      }
      
      private function setupOptionsPanel() : void
      {
         if(this.mOptionsWheel == null)
         {
            this.mOptionsWheel = new OptionsPanel(this);
            this.mOptionsWheel.x = Starling.current.stage.stageWidth - this.mOptionsWheel.width / 2;
            this.mOptionsWheel.y = Starling.current.stage.stageHeight - this.mOptionsWheel.height / 2;
         }
         this.refreshConnectionIconsPositions();
         addChild(this.mOptionsWheel);
      }
      
      private function refreshConnectionIconsPositions() : void
      {
         var _loc1_:FSButton = null;
         if(Boolean(this.mOptionsWheel) && Boolean(this.mConnectionStatusImg))
         {
            if(this.mConnectionStatusImg)
            {
               if(InstanceMng.getCurrentScreen() is FSMapScreen)
               {
                  _loc1_ = FSMapScreen(InstanceMng.getCurrentScreen()).getMapSelectorButton();
                  if(_loc1_ != null)
                  {
                     this.mConnectionStatusImg.x = _loc1_.x;
                     this.mConnectionStatusImg.y = _loc1_.y - _loc1_.height;
                  }
                  else
                  {
                     this.mConnectionStatusImg.x = this.mGuildsButton ? this.mGuildsButton.x : this.mOptionsWheel.x;
                     this.mConnectionStatusImg.y = this.mGuildsButton ? this.mGuildsButton.y - this.mGuildsButton.height : this.mOptionsWheel.y - this.mOptionsWheel.height;
                  }
               }
               else
               {
                  this.mConnectionStatusImg.x = this.mGuildsButton ? this.mGuildsButton.x : this.mOptionsWheel.x;
                  this.mConnectionStatusImg.y = this.mGuildsButton ? this.mGuildsButton.y - this.mGuildsButton.height : this.mOptionsWheel.y - this.mOptionsWheel.height;
               }
            }
         }
      }
      
      public function getBGName() : String
      {
         return this.mBGName;
      }
      
      protected function setupParticleFX() : void
      {
         if(Config.getConfig().getShowSpecialFX())
         {
            if(this.mParticleFX != null)
            {
               addChild(this.mParticleFX);
               Starling.juggler.add(this.mParticleFX);
               this.mParticleFX.start();
            }
         }
      }
      
      protected function setupExtraParticleFX() : void
      {
         if(Config.getConfig().getShowSpecialFX())
         {
            if(this.mExtraParticleFX)
            {
               addChild(this.mExtraParticleFX);
               Starling.juggler.add(this.mExtraParticleFX);
               this.mExtraParticleFX.start();
            }
         }
      }
      
      protected function setupSnowParticleFX() : void
      {
         if(Config.getConfig().getShowSpecialFX())
         {
            if(this.mSnowParticleFX)
            {
               addChild(this.mSnowParticleFX);
               Starling.juggler.add(this.mSnowParticleFX);
               this.mSnowParticleFX.start();
            }
         }
      }
      
      public function showLoadingIcon(param1:Boolean, param2:Boolean, param3:String = "center", param4:String = "center", param5:Number = 1, param6:FSCoordinate = null, param7:Component = null) : void
      {
         var _loc8_:FSLoadingMC = param2 ? this.mLoadingResourcesIcon : this.mLoadingInetDataIcon;
         if(param1)
         {
            if(_loc8_ == null)
            {
               _loc8_ = param2 ? new FSLoadingCardMC() : new FSLoadingMC();
            }
            if(param2)
            {
               this.mLoadingResourcesIcon = _loc8_;
            }
            else
            {
               this.mLoadingInetDataIcon = _loc8_;
            }
            switch(param3)
            {
               case Align.CENTER:
                  _loc8_.x = param7 ? param7.width / 2 : Starling.current.stage.stageWidth / 2;
                  break;
               case Align.LEFT:
                  _loc8_.x = _loc8_.width;
                  break;
               case Align.RIGHT:
                  _loc8_.x = param7 ? param7.width - _loc8_.width : Starling.current.stage.stageWidth - _loc8_.width;
            }
            switch(param4)
            {
               case Align.CENTER:
                  _loc8_.y = param7 ? param7.height / 2 : Starling.current.stage.stageHeight / 2;
                  break;
               case Align.TOP:
                  _loc8_.y = _loc8_.height;
                  break;
               case Align.BOTTOM:
                  _loc8_.y = param7 ? param7.height - _loc8_.height : Starling.current.stage.stageHeight - _loc8_.height;
            }
            if(param7 == null && param6 != null)
            {
               _loc8_.x = param6.getX();
               _loc8_.y = param6.getY();
            }
            if(param7 != null)
            {
               param7.addChildAt(_loc8_,param7.numChildren);
            }
            else
            {
               addChild(_loc8_);
            }
         }
         else if(_loc8_ != null)
         {
            _loc8_.removeFromParent();
         }
      }
      
      public function createTranslucentBG(param1:Boolean, param2:Number = 0.6, param3:Number = 0.5, param4:Boolean = false) : void
      {
         param4 &&= Config.getConfig().XLViewHasCustomBG();
         if(param1)
         {
            if(!param4)
            {
               if(this.mTouchableBG == null)
               {
                  this.mTouchableBG = new Quad(Starling.current.stage.stageWidth,Starling.current.stage.stageHeight,0);
               }
            }
            else if(this.mTouchableImage == null)
            {
               this.mTouchableImage = new FSImage(Root.assets.getTexture("card_zoom_in_bg"));
            }
         }
         var _loc5_:Popup = InstanceMng.getPopupMng().getPopupShown();
         if(param1)
         {
            if(!param4)
            {
               if(_loc5_ == null)
               {
                  if(this.mTouchableBG.parent == null)
                  {
                     this.mTouchableBG.alpha = 0.001;
                  }
               }
               if(!contains(this.mTouchableBG) || contains(this.mTouchableBG) && this.mTouchableBG.alpha != param2)
               {
                  addChild(this.mTouchableBG);
                  this.mTransparentBGShown = true;
                  SpecialFX.tweenToAlpha(this.mTouchableBG,param2,param3,0);
               }
            }
            else
            {
               if(_loc5_ == null)
               {
                  if(this.mTouchableImage.parent == null)
                  {
                     this.mTouchableImage.alpha = 0.001;
                  }
               }
               if(!contains(this.mTouchableImage) || contains(this.mTouchableImage) && this.mTouchableImage.alpha != param2)
               {
                  if(!contains(this.mTouchableImage))
                  {
                     addChild(this.mTouchableImage);
                  }
                  this.mTransparentBGShown = true;
                  SpecialFX.tweenToAlpha(this.mTouchableImage,0.999,param3,0);
               }
            }
         }
         else if(param3 != 0)
         {
            if(this.mTouchableImage)
            {
               SpecialFX.tweenToAlpha(this.mTouchableImage,param2,param3,0);
            }
            if(this.mTouchableBG)
            {
               SpecialFX.tweenToAlpha(this.mTouchableBG,param2,param3,0);
            }
         }
         else
         {
            if(this.mTouchableImage)
            {
               this.mTouchableImage.removeEventListener(TouchEvent.TOUCH,this.onBackgroundTouch);
               this.mTouchableImage.removeFromParent();
               this.mTouchableImage.destroy();
               this.mTouchableImage = null;
            }
            if(this.mTouchableBG)
            {
               this.mTouchableBG.removeEventListener(TouchEvent.TOUCH,this.onBackgroundTouch);
               this.mTouchableBG.removeFromParent();
               this.mTouchableBG.removeEventListeners();
            }
         }
         if(this.mTouchableImage != null && !this.mTouchableImage.hasEventListener(TouchEvent.TOUCH))
         {
            this.mTouchableImage.addEventListener(TouchEvent.TOUCH,this.onBackgroundTouch);
         }
         if(this.mTouchableBG != null && !this.mTouchableBG.hasEventListener(TouchEvent.TOUCH))
         {
            this.mTouchableBG.addEventListener(TouchEvent.TOUCH,this.onBackgroundTouch);
            this.mTouchableBG.useHandCursor = true;
         }
      }
      
      protected function onBackgroundTouch(param1:TouchEvent) : void
      {
         var _loc3_:Touch = null;
         var _loc4_:Popup = null;
         var _loc2_:Boolean = false;
         if(!Root.assets.isLoading)
         {
            if(this is FSDeckBuilderScreen)
            {
               _loc2_ = FSDeckBuilderScreen(this).getCraftingON();
            }
            _loc3_ = param1.getTouch(this,TouchPhase.ENDED);
            if(_loc3_)
            {
               if(!_loc2_ && !Screen.smCarrousselTransitionON)
               {
                  _loc4_ = InstanceMng.getPopupMng().getPopupShown();
                  if(Screen.smOpeningPack || _loc4_ == null)
                  {
                     this.removeTranslucentBG(true);
                  }
                  else
                  {
                     this.checkIfPopupsCanBeClosed();
                  }
               }
            }
         }
         else
         {
            FSDebug.debugTrace("NOT TOUCHABLE, LOADING STUFF");
         }
      }
      
      protected function checkIfPopupsCanBeClosed() : void
      {
         var _loc2_:Array = null;
         var _loc1_:Popup = InstanceMng.getPopupMng().getPopupShown();
         if(_loc1_ == null)
         {
            this.removeTranslucentBG(true);
         }
         else if(_loc1_ != null && _loc1_.canBeClosedTappingBG() && !_loc1_.isClosing())
         {
            _loc2_ = TweenMax.getTweensOf(_loc1_);
            if(_loc2_ == null || Boolean(_loc2_) && Boolean(_loc2_.length == 0))
            {
               if(_loc1_ is PopupStandard)
               {
                  FSDebug.debugTrace("calling on close");
                  PopupStandard(_loc1_).onClose(null);
               }
               else
               {
                  _loc1_.closePopup();
               }
            }
         }
      }
      
      public function removeTranslucentBG(param1:Boolean = false, param2:Boolean = false) : void
      {
         if(Config.TRACE_BATTLE_LOGS)
         {
            FSDebug.debugTrace("***********Removing translucent BG*********** - Instant remove? " + param1.toString());
         }
         var _loc3_:Popup = InstanceMng.getPopupMng().getPopupShown();
         if(_loc3_ != null)
         {
            if(Boolean(this.mSelectedCard) && !param2)
            {
               SpecialFX.zoomOut(this.mSelectedCard);
               this.mSelectedCard = null;
               if(_loc3_ != null)
               {
                  _loc3_.visible = true;
               }
            }
         }
         else if(InstanceMng.getPopupMng().getPopupInBackground() == null)
         {
            this.hideTouchableImage();
            this.hideTouchableBG();
            if(Boolean(InstanceMng.getApplication()) && Boolean(InstanceMng.getApplication().getGuildsPanel()) && InstanceMng.getApplication().getGuildsPanel().isOpen())
            {
               InstanceMng.getApplication().hideGuildsPanel(0.3,false);
            }
         }
      }
      
      public function hideTouchableImage() : void
      {
         if(this.mTouchableImage != null)
         {
            this.mTouchableImage.removeFromParent();
            this.mTransparentBGShown = false;
         }
      }
      
      public function hideTouchableBG() : void
      {
         if(this.mTouchableBG != null)
         {
            this.mTouchableBG.removeFromParent();
            this.mTransparentBGShown = false;
         }
      }
      
      public function isTransparentBGShown() : Boolean
      {
         return this.mTransparentBGShown;
      }
      
      public function onEnterFrame(param1:Event) : void
      {
         if(Boolean(this.mGuildsButtonVisualCounter) && Boolean(this.mGuildsButton))
         {
            this.mGuildsButtonVisualCounter.x = this.mGuildsButton.x;
            this.mGuildsButtonVisualCounter.y = this.mGuildsButton.y - this.mGuildsButton.height / 3;
         }
      }
      
      public function onMouseDownHandler(param1:MouseEvent) : void
      {
      }
      
      public function onMouseUpHandler(param1:MouseEvent) : void
      {
      }
      
      protected function setResourcesToLoad() : void
      {
         if(InstanceMng.getTextParticlesMng())
         {
            InstanceMng.getTextParticlesMng().cleanPools();
         }
         var _loc1_:String = Root(Starling.current.root).getNextLoadingBGName();
         if(_loc1_ != Main.smPreviousLoadingBGName)
         {
            InstanceMng.getResourcesMng().addSpecialScreenResource("loading",_loc1_ + ".jpg",Root.assets,FSResourceMng.PREFIX_TEXTURE);
         }
         this.addResourcesFolder();
         if(!FSPopupMng.areScreenPopupsResourcesLoaded(this.mScreenName))
         {
            this.addPopupsResources();
            this.addPopupAudioResources();
         }
         if(!Utils.isBrowser())
         {
            InstanceMng.getResourcesMng().addSpecialScreenResources(this.mScreenName);
         }
      }
      
      protected function setScreenPopupsResourcesLoaded() : void
      {
         FSPopupMng.setScreenPopupsResourcesLoaded(this.mScreenName,true);
      }
      
      public function notifyAssetsLoaded(param1:* = null) : void
      {
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         if(!Root.smRootInitialized)
         {
            Root(Starling.current.root).removeRootInitialLoadingScreenAndInitialize();
         }
         this.setupParticleFX();
         this.setupExtraParticleFX();
         this.setupSnowParticleFX();
         this.setMaxParticlesAmount(500);
         if(Main.smTracker == null)
         {
            if(InstanceMng.getApplication())
            {
               FSDebug.debugTrace("Initializing GA Tracker");
               InstanceMng.getApplication().initializeGATracker();
            }
         }
         this.trackPageView();
         this.mScreenFullyLoaded = true;
         FSDebug.debugTrace("\nAll assets loaded");
         this.createBG();
         Root(Starling.current.root).removeLoadingResources();
         InstanceMng.getPopupMng().showFirstQueuedPopup();
         this.setupOptionsPanel();
         this.createGuildsButton();
         this.createBackButton();
         var _loc2_:Vector.<String> = Utils.getTrackList();
         if(Config.getConfig().battleHasOwnMusic() && Utils.getLastMusic() == "" && Root.smRootInitialized && Config.smTracklistModeOn && Utils.isMusicOn() && (_loc2_ == null || _loc2_ != null && _loc2_.length == 0))
         {
            if(Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
            {
               _loc4_ = InstanceMng.getUserDataMng().getOwnerUserData().flagsGetMusic();
               if(_loc4_)
               {
                  Utils.addTrackList(InstanceMng.getResourcesMng().getSoundTrack());
                  Utils.loadNextTrack();
               }
            }
         }
         if(!Utils.smInternetAvailable)
         {
            this.onConnectionLost(false,false);
         }
         this.reset3DCameraPosition();
         var _loc3_:Boolean = Main.smPreviousLoadingBGName != Main.smNextLoadingBGName;
         if(_loc3_)
         {
            Root.assets.removeTexture(Main.smPreviousLoadingBGName);
         }
         if(Boolean(InstanceMng.getApplication().getGuildsPanel()) && this.mGuildsButton != null)
         {
            _loc5_ = InstanceMng.getApplication().getGuildsPanel().getGuildMessagesUnread();
            if(_loc5_ > 0)
            {
               this.notifyGuildMessageReceived(_loc5_.toString());
            }
         }
      }
      
      protected function trackPageView() : void
      {
         if(Config.PRODUCTION_BUILD)
         {
            InstanceMng.getApplication().trackCurrentScreen(this.mScreenName);
         }
      }
      
      public function addResourcesFolder() : void
      {
         if(this.mScreenName != "")
         {
            InstanceMng.getResourcesMng().addFolderResourcesToLoad(this.mScreenName);
         }
      }
      
      public function addPopupsResources() : void
      {
      }
      
      protected function addPopupAudioResources() : void
      {
      }
      
      public function removeResourcesFolder() : void
      {
         if(this.mScreenName != "")
         {
            InstanceMng.getResourcesMng().removeResourcesFromFolder(this.mScreenName);
         }
      }
      
      public function getScreenName() : String
      {
         return this.mScreenName;
      }
      
      public function unload() : void
      {
         Utils.stopShake();
         this.mScreenFullyLoaded = false;
         if(this.mGuildsButton)
         {
            this.mGuildsButton.removeEventListener(Event.TRIGGERED,this.onGuildsButtonTriggered);
            this.mGuildsButton.removeFromParent();
            this.mGuildsButton.destroy();
            this.mGuildsButton = null;
         }
         if(this.mGuildsButtonVisualCounter)
         {
            this.mGuildsButtonVisualCounter.removeFromParent();
            this.mGuildsButtonVisualCounter.destroy();
            this.mGuildsButtonVisualCounter = null;
         }
         Utils.destroyArray(this.mGuildsButtonTweens);
         this.mGuildsButtonTweens = null;
         if(Boolean(InstanceMng.getApplication()) && InstanceMng.getApplication().isGuildsPanelOpen())
         {
            InstanceMng.getApplication().hideGuildsPanel(0);
         }
         FSDebug.debugTrace("Unloading screen: " + this.mScreenName);
         if(this.mLogPanel != null)
         {
            this.mLogPanel.removeLog();
            this.mLogPanel.removeFromParent();
            this.mLogPanel.destroy();
            this.mLogPanel = null;
         }
         var _loc1_:Boolean = Main.smPreviousLoadingBGName != Main.smNextLoadingBGName;
         if(_loc1_)
         {
            Root.assets.removeTexture(Main.smPreviousLoadingBGName);
         }
         Utils.stopAllSounds(false,true);
         this.removeResourcesFolder();
         if(this.mBGSprite != null)
         {
            this.mBGSprite.removeFromParent(true);
            this.mBGSprite = null;
         }
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         if(this.mTouchableBG)
         {
            this.mTouchableBG.removeFromParent(true);
            this.mTouchableBG = null;
         }
         if(this.mLoadingInetDataIcon != null)
         {
            this.mLoadingInetDataIcon.removeFromParent(true);
            this.mLoadingInetDataIcon = null;
         }
         if(this.mLoadingResourcesIcon != null)
         {
            this.mLoadingResourcesIcon.removeFromParent(true);
            this.mLoadingResourcesIcon = null;
         }
         if(this.mConnectionStatusImg)
         {
            TweenMax.killTweensOf(this.mConnectionStatusImg);
            this.mConnectionStatusImg.removeFromParent();
            this.mConnectionStatusImg.destroy();
            this.mConnectionStatusImg = null;
         }
         if(this.mZoomedCardXL)
         {
            this.mZoomedCardXL.removeFromParent(true);
            this.mZoomedCardXL = null;
         }
         removeChildren(0,-1,true);
         InstanceMng.getPopupMng().purgeAllPopups();
         TweenMax.killAll();
         if(this.mComicContainer)
         {
            this.mComicContainer.removeFromParent(true);
            this.mComicContainer = null;
         }
         if(this.mOptionsWheel)
         {
            this.mOptionsWheel.removeFromParent();
            this.mOptionsWheel.destroy();
            this.mOptionsWheel = null;
         }
         if(this.mBackButton)
         {
            this.mBackButton.removeEventListener(Event.TRIGGERED,this.onBack);
            this.mBackButton.removeFromParent();
            this.mBackButton.destroy();
            this.mBackButton = null;
         }
         this.mBGLightStyle = null;
         if(this.mBGAmbientLight)
         {
            this.mBGAmbientLight.removeFromParent(true);
            this.mBGAmbientLight = null;
         }
         if(this.mParticleFX)
         {
            this.mParticleFX.removeFromParent();
            Starling.juggler.remove(this.mParticleFX);
            this.mParticleFX = null;
         }
         if(this.mExtraParticleFX)
         {
            this.mExtraParticleFX.removeFromParent();
            Starling.juggler.remove(this.mExtraParticleFX);
            this.mExtraParticleFX = null;
         }
         if(this.mSnowParticleFX)
         {
            this.mSnowParticleFX.removeFromParent();
            Starling.juggler.remove(this.mSnowParticleFX);
            this.mSnowParticleFX = null;
         }
         if(smRewardEffect)
         {
            smRewardEffect.removeFromParent(true);
            smRewardEffect = null;
         }
         this.mGuildsButtonCoordOrig = null;
         this.mGuildsButtonCoordDest = null;
         ErrorsMng.resetErrorsTrackedCatalog();
         Utils.callGC();
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("backsXL",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         this.mScreenName = null;
         dispatchEventWith(SCREEN_UNLOADED,true);
         removeFromParent(true);
      }
      
      public function isFullyLoaded() : Boolean
      {
         return this.mScreenFullyLoaded;
      }
      
      protected function setMaxParticlesAmount(param1:Number) : void
      {
      }
      
      public function getOptionsPanel() : OptionsPanel
      {
         return this.mOptionsWheel;
      }
      
      public function getGuildsButton() : FSButton
      {
         return this.mGuildsButton;
      }
      
      public function getTouchableBG() : Quad
      {
         return this.mTouchableBG;
      }
      
      public function isOnlineDataSynced() : Boolean
      {
         return this.mOnlineDataSynced;
      }
      
      public function setOnlineDataSynced(param1:Boolean) : void
      {
         this.mOnlineDataSynced = param1;
         var _loc2_:UserData = Utils.getOwnerUserData();
         if(_loc2_ != null)
         {
            Utils.setMusicOn(_loc2_.flagsGetMusic());
            Utils.setSFXOn(_loc2_.flagsGetSound());
         }
         this.setupOnlineDataSyncing();
      }
      
      public function getZoomedCardXL() : FSCardXL
      {
         return this.mZoomedCardXL;
      }
      
      public function setZoomedCardXL(param1:FSCardXL) : void
      {
         this.mZoomedCardXL = param1;
      }
      
      public function startBattle(param1:String, param2:Boolean, param3:Boolean = false, param4:Boolean = false) : void
      {
         dispatchEventWith(START_BATTLE,true,[param1,param2,param3,param4]);
      }
      
      public function getComicContainer() : Component
      {
         return this.mComicContainer;
      }
      
      public function setComicContainer(param1:Component) : void
      {
         this.mComicContainer = param1;
      }
      
      public function getBGSprite() : Component
      {
         return this.mBGSprite;
      }
      
      public function getBG() : FSImage
      {
         return this.mBG;
      }
      
      public function onConnectionChange(param1:Boolean = true) : void
      {
         if(Utils.smInternetAvailable)
         {
            this.onConnectionGained();
         }
         else
         {
            this.onConnectionLost();
         }
         var _loc2_:Popup = InstanceMng.getPopupMng().getPopupShown();
         if(_loc2_ != null)
         {
            _loc2_.onConnectionChange();
         }
         if(this.mOptionsWheel != null)
         {
            this.mOptionsWheel.setEnabled(InstanceMng.getApplication().isGamePlayable());
         }
         this.refreshConnectionIconsPositions();
         if(Boolean(param1 && Utils.smInternetAvailable && InstanceMng.getApplication().areOnDemandDefinitionsInitialized()) && Boolean(InstanceMng.getServerConnection()) && Utils.isMobile())
         {
            Utils.setLogText("CHECKING PURCHASES UNPROCESSED...",false,false,false,false);
            setTimeout(InstanceMng.getApplication().getInAppsManager().backendRestorePurchases,250);
         }
      }
      
      private function createConnectionImages() : void
      {
         if(Boolean(Root.assets.getTexture("internet_on")) && Boolean(Root.assets.getTexture("internet_off")))
         {
            if(this.mConnectionStatusImg == null)
            {
               this.mConnectionStatusImg = new FSImage(Root.assets.getTexture("internet_on"));
               this.mConnectionStatusImg.touchable = false;
               this.mConnectionStatusImg.alignPivot();
            }
         }
      }
      
      protected function tryToReloging() : void
      {
         InstanceMng.getServerConnection().loginUser();
      }
      
      public function onConnectionLost(param1:Boolean = true, param2:Boolean = true, param3:Boolean = false) : void
      {
         if(this.mConnectionStatusImg)
         {
            this.mConnectionStatusImg.texture = Root.assets.getTexture("internet_off");
            this.mConnectionStatusImg.alpha = 0.999;
            if(!PvPConnectionMng.smUserInPvPBattle && PvPConnectionMng.smUserInPvPQueue)
            {
               PvPConnectionMng.removeFromPvPQueue(true);
            }
            TweenMax.killTweensOf(this.mConnectionStatusImg);
            if(!contains(this.mConnectionStatusImg))
            {
               if(param3)
               {
                  Utils.setLogText(TextManager.getText("TID_GEN_CONNECTION_LOST") + ". " + TextManager.getText("TID_RECONNECT_TRY"));
                  TweenMax.delayedCall(3,this.tryToReloging);
               }
               if(param1 && !param3)
               {
                  Utils.setLogText(TextManager.getText("TID_GEN_CONNECTION_LOST"));
               }
               if(param2)
               {
                  SpecialFX.createYoYoZoomTransition(this.mConnectionStatusImg,1.3,1,5,this.onConnectionLostAnimEnd,null,false);
               }
            }
            addChild(this.mConnectionStatusImg);
         }
      }
      
      protected function onConnectionLostAnimEnd() : void
      {
         if(this.mConnectionStatusImg)
         {
            this.mConnectionStatusImg.scaleX = 1;
            this.mConnectionStatusImg.scaleY = 1;
         }
      }
      
      public function onConnectionGained() : void
      {
         if(this.mConnectionStatusImg)
         {
            this.mConnectionStatusImg.texture = Root.assets.getTexture("internet_on");
            TweenMax.killTweensOf(this.mConnectionStatusImg);
            this.mConnectionStatusImg.alpha = 0.999;
            addChild(this.mConnectionStatusImg);
            if(this.mConnectionStatusImg)
            {
               TweenMax.delayedCall(3,SpecialFX.tweenToAlpha,[this.mConnectionStatusImg,0,4,0.001,this.removeConnectionStatusImg]);
            }
            if(ServerConnection.smServerInfoReceived)
            {
               Utils.removeLog();
            }
         }
      }
      
      private function removeConnectionStatusImg() : void
      {
         if(this.mConnectionStatusImg)
         {
            this.mConnectionStatusImg.removeFromParent();
         }
      }
      
      protected function createGuildsButton() : void
      {
         var _loc1_:Boolean = this is FSMenuScreen;
         var _loc2_:Boolean = !_loc1_ || _loc1_ && InstanceMng.getApplication().areOnDemandDefinitionsInitialized();
         if(Config.HAS_GUILDS && _loc2_)
         {
            if(this.mGuildsButton == null)
            {
               this.mGuildsButton = new FSButton(Root.assets.getTexture("guild_button"));
               this.mGuildsButton.name = "guilds_button";
               this.mGuildsButton.setTooltipText(TextManager.getText("TID_GUILD_NAME"));
               this.mGuildsButton.addEventListener(Event.TRIGGERED,this.onGuildsButtonTriggered);
               this.mGuildsButton.x = this.mOptionsWheel.x;
               this.mGuildsButton.y = this.mOptionsWheel.y - this.mOptionsWheel.height / 2 - this.mGuildsButton.height / 2;
               addChild(this.mGuildsButton);
            }
            this.refreshConnectionIconsPositions();
         }
      }
      
      private function onGuildsButtonTriggered(param1:Event) : void
      {
         var _loc3_:String = null;
         if(InstanceMng.getTutorialMapMng() != null && InstanceMng.getTutorialMapMng().isTutorialON())
         {
            InstanceMng.getTutorialMapMng().increaseCurrentStep();
         }
         var _loc2_:int = Utils.getOwnerUserData() ? Utils.getOwnerUserData().getCurrentLevelIndex(UserDataMng.DIFFICULTY_EASY) : 0;
         if(_loc2_ >= Config.getConfig().getUnlockGuildsLevel())
         {
            if(!Screen.isScreenLocked())
            {
               if(InstanceMng.getApplication())
               {
                  InstanceMng.getApplication().openGuildsPanel();
               }
            }
         }
         else
         {
            _loc3_ = TextManager.replaceParameters(TextManager.getText("TID_GEN_FEATURE_LOCKED"),[Config.getConfig().getUnlockGuildsLevel()]);
            Utils.setLogText(_loc3_,true);
         }
      }
      
      public function reAddUIVisualsOptions() : void
      {
         if(this.mOptionsWheel)
         {
            addChild(this.mOptionsWheel);
         }
         if(this.mGuildsButton)
         {
            addChild(this.mGuildsButton);
         }
         if(this.mGuildsButtonVisualCounter)
         {
            addChild(this.mGuildsButtonVisualCounter);
         }
      }
      
      public function notifyGuildMessageReceived(param1:String) : void
      {
         var wasAnimated:Boolean = false;
         var text:String = param1;
         var onYoYoZoomTransitionEnd:Function = function():void
         {
            if(mGuildsButtonVisualCounter)
            {
               TweenMax.killTweensOf(mGuildsButtonVisualCounter);
               resetGuildsButtonPosition(false);
               createGuildButtonJumpTransition(mGuildsButton);
            }
         };
         if(InstanceMng.getCurrentScreen() is FSMapScreen)
         {
            if(FSMapScreen(InstanceMng.getCurrentScreen()).isMapUnlockedEffectActive())
            {
               setTimeout(this.notifyGuildMessageReceived,5000,text);
               return;
            }
         }
         if(!InstanceMng.getApplication().mapScreenHasBeenVisited())
         {
            return;
         }
         if(this.mGuildsButton)
         {
            if(this.mGuildsButtonVisualCounter == null)
            {
               this.mGuildsButtonVisualCounter = new FSVisualCounter(text,16711680);
               this.mGuildsButtonVisualCounter.x = this.mGuildsButton.x;
               this.mGuildsButtonVisualCounter.y = this.mGuildsButton.y - this.mGuildsButton.height / 3;
               if(this.mGuildsButton)
               {
                  addChild(this.mGuildsButton);
               }
               addChild(this.mGuildsButtonVisualCounter);
               onYoYoZoomTransitionEnd();
            }
            else
            {
               if(this.mGuildsButton)
               {
                  addChild(this.mGuildsButton);
               }
               addChild(this.mGuildsButtonVisualCounter);
               this.mGuildsButtonVisualCounter.updateText(text);
               this.mGuildsButtonTweens = TweenMax.getTweensOf(this.mGuildsButton);
               wasAnimated = this.mGuildsButtonVisualCounter.visible && Boolean(this.mGuildsButtonTweens) && this.mGuildsButtonTweens.length > 0;
               if(!wasAnimated)
               {
                  this.mGuildsButtonVisualCounter.visible = true;
                  TweenMax.killTweensOf(this.mGuildsButton);
                  TweenMax.killTweensOf(this.mGuildsButtonVisualCounter);
                  onYoYoZoomTransitionEnd();
               }
            }
         }
      }
      
      public function resetGuildsAnimEffectDone() : void
      {
         this.mGuildsAnimEffectDone = false;
      }
      
      private function createGuildButtonJumpTransition(param1:DisplayObject) : void
      {
         if(Boolean(!this.mGuildsAnimEffectDone) && Boolean(this.mGuildsButton) && Boolean(this.mGuildsButtonVisualCounter))
         {
            this.mGuildsAnimEffectDone = true;
            if(this.mGuildsButtonCoordOrig == null)
            {
               this.mGuildsButtonCoordOrig = new FSCoordinate(this.mOptionsWheel.x,this.mOptionsWheel.y - this.mOptionsWheel.height / 2 - this.mGuildsButton.height / 2);
            }
            if(this.mGuildsButtonCoordDest == null)
            {
               this.mGuildsButtonCoordDest = new FSCoordinate(this.mOptionsWheel.x - this.mOptionsWheel.width * 1.5,this.mGuildsButtonCoordOrig.getY());
            }
            if(param1)
            {
               SpecialFX.createTransition(param1,this.mGuildsButtonCoordDest,0.5,2,SpecialFX.createTransition,[param1,this.mGuildsButtonCoordOrig,1,0,null,null,Bounce.easeOut],Circ.easeOut);
            }
         }
      }
      
      public function removeGuildVisualCounter() : void
      {
         if(this.mGuildsButtonVisualCounter)
         {
            this.mGuildsButtonVisualCounter.updateText("");
            this.mGuildsButtonVisualCounter.visible = false;
            TweenMax.killTweensOf(this.mGuildsButtonVisualCounter);
         }
         this.resetGuildsButtonPosition(false);
      }
      
      public function resetGuildsButtonPosition(param1:Boolean = true) : void
      {
         if(this.mGuildsButton)
         {
            TweenMax.killTweensOf(this.mGuildsButton);
            if(this.mGuildsButtonCoordOrig)
            {
               this.mGuildsButton.x = this.mGuildsButtonCoordOrig.getX();
               this.mGuildsButton.y = this.mGuildsButtonCoordOrig.getY();
            }
         }
         if(param1)
         {
            this.checkUnreadGuildMessages();
         }
      }
      
      private function checkUnreadGuildMessages() : void
      {
         var _loc1_:int = 0;
         if(Boolean(InstanceMng.getApplication().getGuildsPanel()) && this.mGuildsButton != null)
         {
            _loc1_ = InstanceMng.getApplication().getGuildsPanel().getGuildMessagesUnread();
            if(_loc1_ > 0)
            {
               this.notifyGuildMessageReceived(_loc1_.toString());
            }
         }
      }
      
      public function lockUI(param1:Boolean) : void
      {
         this.mUILocked = param1;
         if(this.mOptionsWheel)
         {
            this.mOptionsWheel.setEnabled(!param1);
         }
         if(this.mBackButton)
         {
            this.mBackButton.setEnabled(!param1);
         }
         if(this.mGuildsButton)
         {
            this.mGuildsButton.setEnabled(!param1);
         }
      }
      
      public function isUILocked() : Boolean
      {
         return this.mUILocked;
      }
      
      public function getSelectedCard() : FSCard
      {
         return this.mSelectedCard;
      }
      
      public function setSelectedCard(param1:FSCard) : void
      {
         this.mSelectedCard = param1;
      }
      
      public function reset3DCameraPosition() : void
      {
         var _loc1_:Screen = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Point = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         if(Boolean(InstanceMng.getApplication()) && Boolean(InstanceMng.getCurrentScreen()))
         {
            if(InstanceMng.getApplication().getStarling())
            {
               if(InstanceMng.getApplication().getStarling().stage)
               {
                  _loc1_ = InstanceMng.getCurrentScreen();
                  _loc2_ = InstanceMng.getApplication().getStarling().stage.width;
                  _loc3_ = InstanceMng.getApplication().getStarling().stage.height;
                  _loc4_ = 0;
                  _loc5_ = 0;
                  if(!(_loc1_ is FSBattleScreen))
                  {
                     if(_loc1_ is FSDeckBuilderScreen)
                     {
                        _loc7_ = _loc2_ / 2;
                        _loc8_ = _loc3_ / 2;
                        _loc9_ = FSDeckBuilderScreen(_loc1_).getCollectionContainerPosX() + FSDeckBuilderScreen.COLLECTION_CONTAINER_WIDTH / 2;
                        _loc10_ = FSDeckBuilderScreen(_loc1_).getCollectionContainerPosY() + FSDeckBuilderScreen.COLLECTION_CONTAINER_HEIGHT / 2;
                        _loc4_ = _loc9_ - _loc7_;
                        _loc5_ = _loc10_ - _loc8_;
                     }
                     else
                     {
                        _loc4_ = 0;
                     }
                  }
                  _loc6_ = new Point(_loc4_,_loc5_);
                  InstanceMng.getApplication().getStarling().stage.projectionOffset = _loc6_;
               }
            }
         }
      }
      
      public function getGoldVisor() : *
      {
         return null;
      }
      
      public function getAuctionTicketsVisor() : FSAuctionTicketsVisor
      {
         return null;
      }
   }
}

