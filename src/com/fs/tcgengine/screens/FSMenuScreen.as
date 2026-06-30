package com.fs.tcgengine.screens
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.resources.AssetsParticles;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.components.misc.NewsPanel;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.popups.social.PopupRegisterKong;
   import com.greensock.TweenMax;
   import com.greensock.easing.Cubic;
   import com.greensock.easing.Quad;
   import flash.utils.setTimeout;
   import starling.core.Starling;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.text.TextFieldAutoSize;
   import starling.textures.Texture;
   import starling.utils.Align;
   
   public class FSMenuScreen extends Screen
   {
      
      private const MENU_PLATE_BUTTON:String = "menu_plate_button";
      
      private const MENU_PLATE_LIGHT_NAME:String = "yellow_light_menu_button";
      
      private const PLAY_BUTTON_V2:String = "menu_play_button";
      
      protected const GRASS_IMG_NAME:String = "grass";
      
      protected var mGameLogo:FSImage;
      
      protected var mFacebookConnectButton:FSButton;
      
      protected var mAppleSignInButton:FSButton;
      
      protected var mPlayButton:FSButton;
      
      private var mPlayButtonBG:Component;
      
      private var mPlayButtonLight:FSImage;
      
      private var mNewsPanel:NewsPanel;
      
      private var mAppVersionTextfield:FSTextfield;
      
      private var mXPromoButton:FSButton;
      
      private var mNewContentImage:FSImage;
      
      private var mMovingLogo:FSImage;
      
      protected var mVisualComp1:FSImage;
      
      protected var mVisualComp2:FSImage;
      
      protected var mVisualComp1RotateClockWise:Boolean = true;
      
      protected var mVisualComp1MaxReached:Boolean = false;
      
      protected const VISUALCOMP1_SKEW_ADDITION:Number = 0.0008;
      
      protected var mVisualComp2RotateClockWise:Boolean = true;
      
      protected var mVisualComp2MaxReached:Boolean = false;
      
      protected const VISUALCOMP2_SKEW_ADDITION:Number = 0.0005;
      
      protected const SKEW_MAX:Number = 0.1;
      
      protected var mFrictionConstant:Number = 0.0008;
      
      private var mLoggingInLogShown:Boolean = false;
      
      private var mKongRegistrationPopupAppeared:Boolean = false;
      
      private var mReleaseNotesButton:FSButton;
      
      public function FSMenuScreen()
      {
         mBGName = Constants.MENU_BG_NAME;
         mScreenName = Constants.MENU_SCREEN_NAME;
         mNeedsLoadingBar = InstanceMng.getApplication().areOnDemandDefinitionsInitialized();
         mOnlineDataSynced = false;
         super();
      }
      
      override protected function setResourcesToLoad() : void
      {
         if(Root.smRootInitialized)
         {
            super.setResourcesToLoad();
         }
         InstanceMng.getResourcesMng().loadAssets();
      }
      
      override public function notifyAssetsLoaded(param1:* = null) : void
      {
         super.notifyAssetsLoaded();
         this.createUI();
         this.checkNews();
         this.checkXPromo();
         this.checkReleaseNotes();
         this.checkNewContentImage();
      }
      
      override protected function createBG() : void
      {
         super.createBG();
         if(mParticleFX)
         {
            addChild(mParticleFX);
         }
      }
      
      private function checkNewContentImage() : void
      {
         if(this.mNewContentImage == null)
         {
            if(Root.assets.getTexture("event_popup") != null)
            {
               this.mNewContentImage = new FSImage(Root.assets.getTexture("event_popup"));
               this.mNewContentImage.y = Starling.current.stage.stageHeight - this.mNewContentImage.height;
               addChild(this.mNewContentImage);
            }
         }
      }
      
      private function checkXPromo() : void
      {
         var _loc1_:Vector.<String> = null;
         var _loc2_:String = null;
         var _loc3_:Number = NaN;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Texture = null;
         if(Main.smCrossPromotionInfo == null && InstanceMng.getServerConnection().isUserLoggedIn() && mScreenFullyLoaded && (Utils.isMobile() || Utils.isDesktop()))
         {
            _loc1_ = new Vector.<String>();
            _loc2_ = Config.getConfig().getAppNameSpace();
            if(_loc2_.indexOf("clashofarmies") == -1)
            {
               _loc1_.push("clashofarmies");
            }
            if(_loc2_.indexOf("monsterbattles") == -1)
            {
               _loc1_.push("monsterbattles");
            }
            if(_loc2_.indexOf("mythologies") == -1)
            {
               _loc1_.push("mythologies");
            }
            if(_loc2_.indexOf("fantasylegends") == -1)
            {
               _loc1_.push("fantasylegends");
            }
            if(_loc2_.indexOf("starquest") == -1)
            {
               _loc1_.push("starquest");
            }
            _loc3_ = Utils.randomInt(0,_loc1_.length - 1);
            _loc4_ = _loc1_[_loc3_];
            switch(_loc4_)
            {
               case "clashofarmies":
                  if(Utils.isIOS())
                  {
                     Main.smCrossPromotionInfo = "ww2,https://itunes.apple.com/us/app/world-war-ii-tcg/id627392801?mt=8";
                  }
                  else
                  {
                     Main.smCrossPromotionInfo = "ww2,https://play.google.com/store/apps/details?id=air.com.fs.clashofarmies.ClashofArmiesAndroid";
                  }
                  break;
               case "monsterbattles":
                  if(Utils.isIOS())
                  {
                     Main.smCrossPromotionInfo = "monsters,https://itunes.apple.com/us/app/monster-battles-tcg/id918520173";
                  }
                  else
                  {
                     Main.smCrossPromotionInfo = "monsters,https://play.google.com/store/apps/details?id=air.com.fs.monsterbattles";
                  }
                  break;
               case "mythologies":
                  if(Utils.isIOS())
                  {
                     Main.smCrossPromotionInfo = "mythologies,https://itunes.apple.com/us/app/heroes-empire-tcg/id990980891";
                  }
                  else
                  {
                     Main.smCrossPromotionInfo = "mythologies,https://play.google.com/store/apps/details?id=air.com.fs.mythologies";
                  }
                  break;
               case "fantasylegends":
                  if(Utils.isIOS())
                  {
                     Main.smCrossPromotionInfo = "fantasy,https://itunes.apple.com/us/app/magic-quest-tcg/id1073557601";
                  }
                  else
                  {
                     Main.smCrossPromotionInfo = "fantasy,https://play.google.com/store/apps/details?id=air.com.fs.magicquest";
                  }
                  break;
               case "starquest":
                  if(Utils.isIOS())
                  {
                     Main.smCrossPromotionInfo = "starquest,https://itunes.apple.com/us/app/star-quest-tcg/id1140168552";
                  }
                  else
                  {
                     Main.smCrossPromotionInfo = "starquest,https://play.google.com/store/apps/details?id=air.com.fs.starquest";
                  }
            }
            if(Utils.isDesktop())
            {
               return;
            }
            _loc5_ = Main.smCrossPromotionInfo.split(",")[0];
            _loc6_ = "cross_promotion_button_" + _loc5_;
            if(this.mXPromoButton == null)
            {
               _loc7_ = Root.assets.getTexture(_loc6_);
               if(_loc7_)
               {
                  this.mXPromoButton = new FSButton(_loc7_);
                  this.mXPromoButton.x = Starling.current.stage.stageWidth - this.mXPromoButton.width / 2;
                  this.mXPromoButton.y = this.mXPromoButton.height / 2;
                  this.mXPromoButton.addEventListener(Event.TRIGGERED,this.onXPromoButtonTriggered);
                  addChild(this.mXPromoButton);
               }
            }
         }
      }
      
      protected function makeSureXPromoIsOnTop() : void
      {
         if(this.mXPromoButton)
         {
            addChild(this.mXPromoButton);
         }
      }
      
      private function onXPromoButtonTriggered() : void
      {
         if(Main.smCrossPromotionInfo != null)
         {
            FSTracker.trackFirebaseEvent("XPROMO_CLICK");
            InstanceMng.getPopupMng().openXPromoPopup();
         }
      }
      
      private function checkNews() : void
      {
         if(Boolean(Config.smNews != null && InstanceMng.getServerConnection().isUserLoggedIn() && mScreenFullyLoaded && InstanceMng.getCurrentScreen() && InstanceMng.getCurrentScreen() is FSMenuScreen) && Boolean(Starling.current.root is Root) && Root(Starling.current.root).getLoadingScreenImage() == null)
         {
            this.onNewsACK();
         }
         else
         {
            setTimeout(this.checkNews,1000);
         }
      }
      
      private function onNewsACK() : void
      {
         var _loc1_:Object = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:String = null;
         var _loc8_:FSCoordinate = null;
         if(Boolean(mScreenFullyLoaded && InstanceMng.getCurrentScreen() && InstanceMng.getCurrentScreen() is FSMenuScreen) && Boolean(Starling.current.root is Root) && Root(Starling.current.root).getLoadingScreenImage() == null)
         {
            _loc1_ = Config.smNews != null ? Config.smNews : null;
            if(_loc1_ != null)
            {
               _loc2_ = _loc1_.newsTitle;
               _loc3_ = _loc1_.newsText;
               _loc4_ = _loc1_.visible;
               _loc5_ = int(_loc1_.type);
               _loc6_ = Number(_loc1_.expirationTimeMS);
               _loc7_ = _loc1_.url;
               if(_loc4_)
               {
                  if(this.mNewsPanel == null && ServerConnection.smServerTimeMS != 0 && ServerConnection.smServerTimeMS != -1 && _loc6_ > ServerConnection.smServerTimeMS)
                  {
                     this.mNewsPanel = new NewsPanel(_loc2_,_loc3_,_loc5_,_loc7_);
                     this.mNewsPanel.x = 0;
                     this.mNewsPanel.y = InstanceMng.getApplication().getDefaultStageHeight();
                     _loc8_ = new FSCoordinate(0,this.mNewsPanel.y - this.mNewsPanel.height);
                     SpecialFX.createTransition(this.mNewsPanel,_loc8_,1.5);
                     addChild(this.mNewsPanel);
                  }
               }
            }
         }
      }
      
      protected function createUI() : void
      {
         this.createVisualComps();
         this.createButtons();
         var _loc1_:String = "logo_XL";
         if(FSResourceMng.smCurrentLocaleSelected != "")
         {
            if(FSResourceMng.isOriental())
            {
               _loc1_ += "_" + FSResourceMng.smCurrentLocaleSelected.toLowerCase();
            }
         }
         if(Root.assets.getTexture(_loc1_) == null)
         {
            _loc1_ = "logo_XL";
         }
         this.mGameLogo = new FSImage(Root.assets.getTexture(_loc1_));
         this.mGameLogo.x = Starling.current.stage.stageWidth / 2 - this.mGameLogo.width / 2;
         this.mGameLogo.y = this.mPlayButton.y - this.mPlayButton.height - this.mGameLogo.height / 1.35;
         this.mGameLogo.touchable = false;
         addChild(this.mGameLogo);
         this.showAppVersionInfo();
         this.createMovingLogo();
         if(Config.getConfig().gameHasAnimatedMenuScreen())
         {
            if(this.mGameLogo)
            {
               this.mGameLogo.y = Starling.current.stage.stageHeight / 2.8;
            }
            reAddUIVisualsOptions();
         }
      }
      
      private function onLangChangedRefreshLogoName() : void
      {
         var _loc1_:String = null;
         if(this.mGameLogo)
         {
            _loc1_ = "logo_XL";
            if(FSResourceMng.smCurrentLocaleSelected != "")
            {
               if(FSResourceMng.isOriental())
               {
                  _loc1_ += "_" + FSResourceMng.smCurrentLocaleSelected.toLowerCase();
               }
            }
            if(Root.assets.getTexture(_loc1_) != this.mGameLogo.texture && Root.assets.getTexture(_loc1_) != null)
            {
               this.mGameLogo.texture = Root.assets.getTexture(_loc1_);
            }
         }
      }
      
      private function createMovingLogo() : void
      {
         var _loc1_:FSCoordinate = null;
         if(this.mMovingLogo == null && Config.getConfig().gameShowsMovingLogoOnMenuScreen())
         {
            this.mMovingLogo = new FSImage(Root.assets.getTexture("moving_menu_logo"));
            this.mMovingLogo.touchable = false;
            this.mMovingLogo.alignPivot();
            this.mMovingLogo.x = Starling.current.stage.stageWidth / 2;
            this.mMovingLogo.y = Starling.current.stage.stageHeight / 2.05;
            _loc1_ = new FSCoordinate(this.mMovingLogo.x,this.mMovingLogo.y - this.mMovingLogo.height / 15);
            addChild(this.mMovingLogo);
            SpecialFX.createYoYoTransition(this.mMovingLogo,_loc1_,5,-1,null,Quad.easeInOut);
         }
         if(this.mGameLogo)
         {
            addChild(this.mGameLogo);
         }
      }
      
      protected function createButtons() : void
      {
         this.mPlayButtonBG = new Component();
         var _loc1_:FSImage = new FSImage(Root.assets.getTexture(this.MENU_PLATE_BUTTON));
         this.mPlayButtonBG.addChild(_loc1_);
         this.mPlayButtonLight = new FSImage(Root.assets.getTexture(this.MENU_PLATE_LIGHT_NAME));
         this.mPlayButtonLight.x = this.mPlayButtonBG.width * 0.05;
         this.mPlayButtonLight.y = this.mPlayButtonBG.height - this.mPlayButtonLight.height * 0.9;
         this.mPlayButtonBG.addChild(this.mPlayButtonLight);
         var _loc2_:FSCoordinate = new FSCoordinate(this.mPlayButtonBG.width * 0.95 - this.mPlayButtonLight.width,this.mPlayButtonLight.y);
         SpecialFX.createYoYoTransition(this.mPlayButtonLight,_loc2_,2,-1,null,Cubic.easeInOut);
         this.mPlayButtonBG.x = (Starling.current.stage.stageWidth - this.mPlayButtonBG.width) / 2;
         this.mPlayButtonBG.y = Starling.current.stage.stageHeight - this.mPlayButtonBG.height;
         addChild(this.mPlayButtonBG);
         this.mPlayButton = new FSButton(Root.assets.getTexture(this.PLAY_BUTTON_V2),TextManager.getText("TID_GEN_PLAY"));
         this.mPlayButton.alignPivot();
         this.mPlayButton.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GOLD);
         this.mPlayButton.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
         this.mPlayButton.fontColor = 16777215;
         this.mPlayButton.x = Starling.current.stage.stageWidth / 2;
         this.mPlayButton.y = Starling.current.stage.stageHeight - this.mPlayButton.height / 1.5;
         this.mPlayButton.addEventListener(Event.TRIGGERED,this.onPlayTriggered);
         this.mPlayButton.enabled = InstanceMng.getApplication().isGamePlayable();
         addChild(this.mPlayButton);
         this.createFBButton();
         this.createAppleSignInButton();
         if(Utils.isBrowser())
         {
            this.mPlayButton.enabled = InstanceMng.getApplication().isGamePlayable();
         }
      }
      
      public function updateButtonsTexts() : void
      {
         if(this.mPlayButton)
         {
            this.mPlayButton.text = TextManager.getText("TID_GEN_PLAY");
         }
         this.onLangChangedRefreshLogoName();
      }
      
      protected function createAppleSignInButton() : void
      {
         var _loc1_:Boolean = false;
         if(Utils.isIOS())
         {
            _loc1_ = InstanceMng.getApplication().hasUserSignedIntoApple();
            if(!_loc1_)
            {
               if(this.mAppleSignInButton == null)
               {
                  this.mAppleSignInButton = new FSButton(Root.assets.getTexture("apple_sign_button"),"",Root.assets.getTexture("apple_sign_button"));
                  this.mAppleSignInButton.x = Starling.current.stage.stageWidth - this.mAppleSignInButton.width / 1.25;
                  this.mAppleSignInButton.y = Starling.current.stage.stageHeight - this.mAppleSignInButton.height * 2.5;
                  this.mAppleSignInButton.addEventListener(Event.TRIGGERED,this.onAppleSignInTriggered);
               }
               this.setAppleSignInButtonVisibility();
               addChild(this.mAppleSignInButton);
            }
         }
      }
      
      protected function createFBButton() : void
      {
         var _loc1_:Boolean = false;
         if(!InstanceMng.getApplication().isKongregateVersion())
         {
            _loc1_ = InstanceMng.getFacebookPlugin() != null ? InstanceMng.getFacebookPlugin().isSessionOpen() : false;
            if(!_loc1_ && Utils.isMobile())
            {
               if(this.mFacebookConnectButton == null)
               {
                  this.mFacebookConnectButton = new FSButton(Root.assets.getTexture("fb_button_up"),"",Root.assets.getTexture("fb_button_down"));
                  this.mFacebookConnectButton.fontName = FSResourceMng.getFontByType();
                  this.mFacebookConnectButton.fontColor = 16777215;
                  this.mFacebookConnectButton.fontSize = FSResourceMng.FONT_STD_DEFAULT_SIZE;
                  this.mFacebookConnectButton.x = Starling.current.stage.stageWidth - this.mFacebookConnectButton.width / 1.25;
                  this.mFacebookConnectButton.y = Starling.current.stage.stageHeight - this.mFacebookConnectButton.height * 3.75;
                  this.mFacebookConnectButton.addEventListener(Event.TRIGGERED,this.onFBTriggered);
               }
               this.setFBButtonVisibility();
               addChild(this.mFacebookConnectButton);
            }
         }
      }
      
      private function onFirstFBLoginPanelTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1 ? param1.getTouch(this,TouchPhase.ENDED) : null;
         if(_loc2_)
         {
            this.onFBTriggered(null);
         }
      }
      
      public function setFBButtonVisibility() : void
      {
         var _loc1_:Boolean = InstanceMng.getApplication().appleSignInIsSupported() && this.canAppleSignInBeVisible() || !InstanceMng.getApplication().appleSignInIsSupported();
         var _loc2_:Boolean = Utils.isMobile() && Utils.smInternetAvailable && InstanceMng.getApplication().isGamePlayable();
         var _loc3_:Boolean = Boolean(InstanceMng.getFacebookPlugin()) && !InstanceMng.getFacebookPlugin().isSessionOpen() && _loc1_;
         if(this.mFacebookConnectButton)
         {
            this.mFacebookConnectButton.enabled = _loc2_;
            this.mFacebookConnectButton.visible = _loc3_;
         }
      }
      
      public function setAppleSignInButtonVisibility() : void
      {
         var _loc1_:Boolean = Boolean(InstanceMng.getFacebookPlugin()) && InstanceMng.getFacebookPlugin().isSessionOpen();
         var _loc2_:Boolean = Utils.isMobile() && Utils.smInternetAvailable && InstanceMng.getApplication().isGamePlayable();
         var _loc3_:Boolean = !InstanceMng.getApplication().hasUserSignedIntoApple() && !_loc1_;
         if(this.mAppleSignInButton)
         {
            this.mAppleSignInButton.enabled = _loc2_;
            this.mAppleSignInButton.visible = _loc3_;
         }
      }
      
      private function canFBButtonBeVisible() : Boolean
      {
         var _loc1_:Boolean = Utils.isMobile() && Utils.smInternetAvailable && InstanceMng.getApplication().isGamePlayable();
         return Boolean(InstanceMng.getFacebookPlugin()) && !InstanceMng.getFacebookPlugin().isSessionOpen();
      }
      
      private function canAppleSignInBeVisible() : Boolean
      {
         var _loc1_:Boolean = InstanceMng.getApplication().appleSignInIsSupported();
         var _loc2_:Boolean = Utils.isMobile() && Utils.smInternetAvailable && InstanceMng.getApplication().isGamePlayable();
         return !InstanceMng.getApplication().hasUserSignedIntoApple();
      }
      
      public function refreshButtons() : void
      {
         if(this.mPlayButton)
         {
            this.mPlayButton.enabled = InstanceMng.getApplication().isGamePlayable();
            if(this.mPlayButton.enabled)
            {
               this.mPlayButton.showLoadingIcon(false);
            }
         }
         if(mOptionsWheel)
         {
            mOptionsWheel.setEnabled(InstanceMng.getApplication().isGamePlayable());
         }
         this.setFBButtonVisibility();
         this.setAppleSignInButtonVisibility();
      }
      
      override protected function setupParticleFX() : void
      {
         if(Config.getConfig().gameHasParticlesOnMenuScreen())
         {
            if(Config.getConfig().getShowSpecialFX())
            {
               mParticleFX = AssetsParticles.requestParticleSystem("waterfall1");
               if(mParticleFX != null)
               {
                  mParticleFX.touchable = false;
                  if(Utils.isIOS())
                  {
                     if(Utils.isIphone())
                     {
                        mParticleFX.lifespan -= 0.25;
                        if(Utils.isIphone4())
                        {
                           mParticleFX.x = Starling.current.stage.stageWidth * 0.185;
                           mParticleFX.y = Starling.current.stage.stageHeight * 0.21;
                        }
                        else if(Utils.isIphone5())
                        {
                           mParticleFX.x = Starling.current.stage.stageWidth * 0.235;
                           mParticleFX.y = Starling.current.stage.stageHeight * 0.21;
                        }
                     }
                     else
                     {
                        mParticleFX.x = Starling.current.stage.stageWidth * 0.13;
                        mParticleFX.y = Starling.current.stage.stageHeight * 0.18;
                     }
                  }
                  else if(Utils.isAndroidOrDesktop())
                  {
                     mParticleFX.x = Starling.current.stage.stageWidth * 0.21;
                     mParticleFX.y = Starling.current.stage.stageHeight * 0.2;
                     mParticleFX.lifespan *= Starling.current.contentScaleFactor / 2;
                     mParticleFX.lifespanVariance *= Starling.current.contentScaleFactor / 2;
                  }
                  else
                  {
                     mParticleFX.x = Starling.current.stage.stageWidth * 0.13;
                     mParticleFX.y = Starling.current.stage.stageHeight * 0.18;
                  }
                  this.onStartParticleFXPerformOps();
               }
            }
         }
      }
      
      override protected function setupExtraParticleFX() : void
      {
         if(Config.getConfig().getShowSpecialFX() && Config.getConfig().gameHasParticlesOnMenuScreen())
         {
            if(mExtraParticleFX == null)
            {
               mExtraParticleFX = AssetsParticles.requestParticleSystem("waterfall2");
            }
            if(mExtraParticleFX != null)
            {
               if(isFullyLoaded())
               {
                  if(Utils.isIOS())
                  {
                     if(Utils.isIphone())
                     {
                        if(Utils.isIphone4())
                        {
                           mExtraParticleFX.x = Starling.current.stage.stageWidth * 0.21;
                           mExtraParticleFX.y = Starling.current.stage.stageHeight * 0.54;
                        }
                        else if(Utils.isIphone5())
                        {
                           mExtraParticleFX.x = Starling.current.stage.stageWidth * 0.25;
                           mExtraParticleFX.y = Starling.current.stage.stageHeight * 0.52;
                        }
                     }
                     else
                     {
                        mExtraParticleFX.x = Starling.current.stage.stageWidth * 0.15;
                        mExtraParticleFX.y = Starling.current.stage.stageHeight * 0.52;
                     }
                  }
                  else if(Utils.isAndroidOrDesktop())
                  {
                     mExtraParticleFX.x = Starling.current.stage.stageWidth * 0.25;
                     mExtraParticleFX.y = Starling.current.stage.stageHeight * 0.54;
                  }
                  else
                  {
                     mExtraParticleFX.x = Starling.current.stage.stageWidth * 0.15;
                     mExtraParticleFX.y = Starling.current.stage.stageHeight * 0.52;
                  }
                  TweenMax.delayedCall(mExtraParticleFX.lifespan * 3,this.startExtraParticlesEffects);
               }
               else
               {
                  TweenMax.delayedCall(0.25,this.setupExtraParticleFX);
               }
            }
         }
      }
      
      private function startExtraParticlesEffects() : void
      {
         addChild(mExtraParticleFX);
         mExtraParticleFX.alpha = 0.001;
         Starling.juggler.add(mExtraParticleFX);
         mExtraParticleFX.start();
         SpecialFX.tweenToAlpha(mExtraParticleFX,0.999,1.5,0);
      }
      
      override protected function setupSnowParticleFX() : void
      {
         if(Config.getConfig().gameHasSnowParticlesOnMenuScreen())
         {
            if(Config.getConfig().getShowSpecialFX())
            {
               mSnowParticleFX = AssetsParticles.requestParticleSystem("menuSnow");
               if(mSnowParticleFX != null)
               {
                  mSnowParticleFX.x = Starling.current.stage.stageWidth / 2;
                  mSnowParticleFX.y = -20;
               }
            }
            super.setupSnowParticleFX();
         }
      }
      
      private function onStartParticleFXPerformOps() : void
      {
         if(isFullyLoaded())
         {
            addChild(mParticleFX);
            Starling.juggler.add(mParticleFX);
            mParticleFX.start();
         }
         else
         {
            TweenMax.delayedCall(0.25,this.onStartParticleFXPerformOps);
         }
      }
      
      private function onPlayTriggered(param1:Event) : void
      {
         this.showMap();
      }
      
      private function onAppleSignInTriggered(param1:Event) : void
      {
         if(!this.canFBButtonBeVisible())
         {
            InstanceMng.getPopupMng().openErrorPopup(TextManager.replaceParameters(TextManager.getText("TID_ACCOUNT_ALREADY_LINKED"),["Facebook","Apple Sign in"]),true);
            return;
         }
         if(ServerConnection.smServerPlayerBlacklisted)
         {
            InstanceMng.getPopupMng().closePopupShown();
            InstanceMng.getPopupMng().openErrorPopup(TextManager.getText("TID_GEN_FRAUD_PURCHASE"),false);
            return;
         }
         if(ServerConnection.smServerPlayerDuplicated)
         {
            InstanceMng.getPopupMng().closePopupShown();
            InstanceMng.getPopupMng().openErrorPopup(TextManager.getText("TID_MIGRATION_ERROR_MIGRATED"),false);
            return;
         }
         this.lockUI(true);
         var _loc2_:Boolean = InstanceMng.getApplication().hasUserSignedIntoApple();
         if(!_loc2_)
         {
            Utils.setLogText(TextManager.getText("TID_APPLE_CONNECTING"));
            InstanceMng.getApplication().appleSignIn();
         }
         else
         {
            this.refreshButtons();
         }
      }
      
      private function onFBTriggered(param1:Event) : void
      {
         if(InstanceMng.getApplication().appleSignInIsSupported() && !this.canAppleSignInBeVisible())
         {
            InstanceMng.getPopupMng().openErrorPopup(TextManager.replaceParameters(TextManager.getText("TID_ACCOUNT_ALREADY_LINKED"),["Apple Sign in","Facebook"]),true);
            return;
         }
         if(ServerConnection.smServerPlayerBlacklisted)
         {
            InstanceMng.getPopupMng().closePopupShown();
            InstanceMng.getPopupMng().openErrorPopup(TextManager.getText("TID_GEN_FRAUD_PURCHASE"),false);
            return;
         }
         if(ServerConnection.smServerPlayerDuplicated)
         {
            InstanceMng.getPopupMng().closePopupShown();
            InstanceMng.getPopupMng().openErrorPopup(TextManager.getText("TID_MIGRATION_ERROR_MIGRATED"),false);
            return;
         }
         this.lockUI(true);
         var _loc2_:Boolean = InstanceMng.getFacebookPlugin().isSessionOpen();
         if(!_loc2_)
         {
            Utils.setLogText(TextManager.getText("TID_FACEBOOK_CONNECTING"));
            InstanceMng.getFacebookPlugin().login();
         }
         else
         {
            this.refreshButtons();
         }
      }
      
      public function showMap() : void
      {
         dispatchEventWith(GO_TO_MAP,true);
      }
      
      private function showAppVersionInfo(param1:Number = 0.03) : void
      {
         var _loc5_:int = 0;
         param1 = Utils.isBrowser() || Utils.isDesktop() ? 0.025 : param1;
         var _loc2_:String = Utils.isBrowser() && Config.IS_BROWSER_LOCAL ? " ======= ENVIRONMENT -> LOCAL!!! ======" : "";
         var _loc3_:int = new Date().getFullYear();
         var _loc4_:String = "v " + Utils.getAppVersion() + " © " + _loc3_ + " FrozenShard" + _loc2_;
         if(this.mAppVersionTextfield == null)
         {
            _loc5_ = FSResourceMng.isOriental() ? 300 : 1;
            this.mAppVersionTextfield = new FSTextfield(_loc5_,InstanceMng.getApplication().getDefaultStageHeight() * param1,_loc4_);
            this.mAppVersionTextfield.format.horizontalAlign = Align.RIGHT;
            this.mAppVersionTextfield.format.verticalAlign = Align.BOTTOM;
            this.mAppVersionTextfield.autoSize = FSResourceMng.isOriental() ? TextFieldAutoSize.NONE : TextFieldAutoSize.HORIZONTAL;
            this.mAppVersionTextfield.x = Starling.current.stage.stageWidth - this.mAppVersionTextfield.width - mOptionsWheel.width;
            this.mAppVersionTextfield.y = InstanceMng.getApplication().getDefaultStageHeight() - this.mAppVersionTextfield.height;
            addChild(this.mAppVersionTextfield);
         }
         FSDebug.debugTrace("Starling.current.context.driverInfo: " + Starling.current.context.driverInfo);
      }
      
      override public function unload() : void
      {
         if(this.mGameLogo)
         {
            this.mGameLogo.removeFromParent(true);
            this.mGameLogo = null;
         }
         if(this.mFacebookConnectButton)
         {
            this.mFacebookConnectButton.removeFromParent(true);
            this.mFacebookConnectButton = null;
         }
         if(this.mAppleSignInButton)
         {
            this.mAppleSignInButton.removeFromParent(true);
            this.mAppleSignInButton = null;
         }
         if(this.mPlayButton)
         {
            this.mPlayButton.removeFromParent(true);
            this.mPlayButton = null;
         }
         if(this.mPlayButtonLight)
         {
            TweenMax.killTweensOf(this.mPlayButtonLight);
            this.mPlayButtonLight.removeFromParent(true);
            this.mPlayButtonLight = null;
         }
         if(this.mPlayButtonBG)
         {
            this.mPlayButtonBG.removeFromParent(true);
            this.mPlayButtonBG = null;
         }
         if(this.mNewsPanel)
         {
            this.mNewsPanel.removeFromParent(true);
            this.mNewsPanel = null;
         }
         if(this.mAppVersionTextfield)
         {
            this.mAppVersionTextfield.removeFromParent(true);
            this.mAppVersionTextfield = null;
         }
         if(this.mXPromoButton)
         {
            this.mXPromoButton.removeFromParent(true);
            this.mXPromoButton = null;
         }
         if(this.mNewContentImage)
         {
            this.mNewContentImage.removeFromParent(true);
            this.mNewContentImage = null;
         }
         if(this.mMovingLogo)
         {
            this.mMovingLogo.removeFromParent(true);
            this.mMovingLogo = null;
         }
         if(Config.getConfig().gameHasAnimatedMenuScreen())
         {
            if(this.mVisualComp1)
            {
               this.mVisualComp1.removeFromParent(true);
               this.mVisualComp1 = null;
            }
            if(this.mVisualComp2)
            {
               this.mVisualComp2.removeFromParent(true);
               this.mVisualComp2 = null;
            }
         }
         if(this.mReleaseNotesButton)
         {
            this.mReleaseNotesButton.removeFromParent(true);
            this.mReleaseNotesButton = null;
         }
         Main.smCrossPromotionInfo = null;
         super.unload();
      }
      
      override public function onConnectionChange(param1:Boolean = true) : void
      {
         super.onConnectionChange(param1);
         this.refreshButtons();
         this.checkNews();
         this.checkReleaseNotes();
         this.checkXPromo();
      }
      
      override public function lockUI(param1:Boolean) : void
      {
         if(this.mPlayButton)
         {
            this.mPlayButton.enabled = !param1 && InstanceMng.getApplication().isGamePlayable();
         }
         if(this.mFacebookConnectButton)
         {
            this.mFacebookConnectButton.enabled = !param1;
         }
         if(this.mAppleSignInButton)
         {
            this.mAppleSignInButton.enabled = !param1;
         }
         super.lockUI(param1);
      }
      
      override public function onEnterFrame(param1:Event) : void
      {
         super.onEnterFrame(param1);
         this.animateSpecialFX();
         if(InstanceMng.getApplication().isKongregateVersion())
         {
            if(!this.mKongRegistrationPopupAppeared)
            {
               if(!Root.assets.isLoading)
               {
                  if(InstanceMng.getApplication().getKongregatePlugin() != null)
                  {
                     if(InstanceMng.getApplication().getKongregatePlugin().isGuest())
                     {
                        this.mKongRegistrationPopupAppeared = true;
                        InstanceMng.getPopupMng().openRegisterKongPopup();
                     }
                     else if(InstanceMng.getPopupMng().getPopupShown() is PopupRegisterKong)
                     {
                        PopupRegisterKong(InstanceMng.getPopupMng().getPopupShown()).closePopup();
                     }
                  }
               }
            }
            else if(!InstanceMng.getApplication().getKongregatePlugin().isGuest())
            {
               if(InstanceMng.getPopupMng().getPopupShown() is PopupRegisterKong)
               {
                  if(!PopupRegisterKong(InstanceMng.getPopupMng().getPopupShown()).isClosing())
                  {
                     PopupRegisterKong(InstanceMng.getPopupMng().getPopupShown()).closePopup();
                  }
               }
            }
            if(!this.mLoggingInLogShown)
            {
               if(mScreenFullyLoaded && !InstanceMng.getServerConnection().isUserLoggedIn() && !InstanceMng.getApplication().areOnDemandDefinitionsInitialized())
               {
                  this.mLoggingInLogShown = true;
                  Utils.setLogText(TextManager.getText("TID_GEN_LOGGING"),false,true,false);
               }
            }
         }
      }
      
      protected function animateSpecialFX() : void
      {
         if(this.mVisualComp1)
         {
            this.mFrictionConstant = Math.abs(this.mVisualComp1.skewX) != 0 ? (1 - Math.abs(Number(this.mVisualComp1.skewX.toFixed(3))) / this.SKEW_MAX) * 5 : 0.0008;
            this.mFrictionConstant = this.mFrictionConstant == 0 ? 1 : this.mFrictionConstant;
            this.mFrictionConstant = this.mFrictionConstant > 3 ? 3 : this.mFrictionConstant;
            if(this.mVisualComp1RotateClockWise)
            {
               this.mVisualComp1.skewX += this.VISUALCOMP1_SKEW_ADDITION * this.mFrictionConstant;
            }
            else
            {
               this.mVisualComp1.skewX -= this.VISUALCOMP1_SKEW_ADDITION * this.mFrictionConstant;
            }
            if(this.mVisualComp1.skewX >= this.SKEW_MAX)
            {
               this.mVisualComp1MaxReached = true;
            }
            if(this.mVisualComp1.skewX <= -this.SKEW_MAX)
            {
               this.mVisualComp1MaxReached = false;
            }
            if(this.mVisualComp1.skewX >= this.SKEW_MAX)
            {
               this.mVisualComp1RotateClockWise = this.mVisualComp1MaxReached ? false : true;
            }
            if(this.mVisualComp1.skewX <= -this.SKEW_MAX)
            {
               this.mVisualComp1RotateClockWise = this.mVisualComp1MaxReached ? false : true;
            }
         }
         if(this.mVisualComp2)
         {
            if(this.mVisualComp2RotateClockWise)
            {
               this.mVisualComp2.skewX += this.VISUALCOMP2_SKEW_ADDITION;
            }
            else
            {
               this.mVisualComp2.skewX -= this.VISUALCOMP2_SKEW_ADDITION;
            }
            if(this.mVisualComp2.skewX >= this.SKEW_MAX)
            {
               this.mVisualComp2MaxReached = true;
            }
            if(this.mVisualComp2.skewX <= -this.SKEW_MAX)
            {
               this.mVisualComp2MaxReached = false;
            }
            if(this.mVisualComp2.skewX >= this.SKEW_MAX)
            {
               this.mVisualComp2RotateClockWise = this.mVisualComp2MaxReached ? false : true;
            }
            if(this.mVisualComp2.skewX <= -this.SKEW_MAX)
            {
               this.mVisualComp2RotateClockWise = this.mVisualComp2MaxReached ? false : true;
            }
         }
      }
      
      protected function createVisualComps() : void
      {
         if(Config.getConfig().gameHasAnimatedMenuScreen())
         {
            if(this.mVisualComp1 == null)
            {
               this.mVisualComp1 = new FSImage(Root.assets.getTexture(this.GRASS_IMG_NAME));
               this.mVisualComp1.touchable = false;
               this.mVisualComp1.scaleX *= 1.25;
               this.mVisualComp1.pivotX = this.mVisualComp1.width / 2;
               this.mVisualComp1.pivotY = this.mVisualComp1.height;
               this.mVisualComp1.x = this.mVisualComp1.width / 2;
               this.mVisualComp1.y = Starling.current.stage.stageHeight;
               addChild(this.mVisualComp1);
            }
            if(this.mVisualComp2 == null)
            {
               this.mVisualComp2 = new FSImage(Root.assets.getTexture(this.GRASS_IMG_NAME));
               this.mVisualComp2.touchable = false;
               this.mVisualComp2.scaleX *= -1.25;
               this.mVisualComp2.pivotX = this.mVisualComp2.width / 2;
               this.mVisualComp2.pivotY = this.mVisualComp2.height;
               this.mVisualComp2.x = this.mVisualComp2.width / 2 - this.mVisualComp2.width * 0.25;
               this.mVisualComp2.y = Starling.current.stage.stageHeight;
               addChild(this.mVisualComp2);
            }
         }
      }
      
      private function createReleaseNotesButton() : void
      {
         if(Config.smEligibleToShowReleaseNotesButton == true)
         {
            if(this.mReleaseNotesButton == null)
            {
               this.mReleaseNotesButton = new FSButton(Root.assets.getTexture(Constants.ACCEPT_BUTTON_UP_NAME),TextManager.getText("TID_GEN_PATCH_NOTES"));
               this.mReleaseNotesButton.addEventListener(Event.TRIGGERED,this.onReleaseNotesTriggered);
            }
            Config.smEligibleToShowReleaseNotesButton = false;
            this.mReleaseNotesButton.x = Starling.current.stage.stageWidth / 2;
            this.mReleaseNotesButton.y = this.mReleaseNotesButton.height / 2;
            addChild(this.mReleaseNotesButton);
         }
      }
      
      public function checkReleaseNotes() : void
      {
         if(Boolean(InstanceMng.getServerConnection()) && Boolean(InstanceMng.getServerConnection().isUserLoggedIn()) && mScreenFullyLoaded)
         {
            if(Config.smReleaseNotesInfo != null)
            {
               this.createReleaseNotesButton();
            }
         }
         else
         {
            setTimeout(this.checkReleaseNotes,10000);
         }
      }
      
      private function onReleaseNotesReceived(param1:Object) : void
      {
         var _loc2_:String = Boolean(param1) && param1.length > 0 ? param1[0].msg : null;
         if(_loc2_ != null && _loc2_ != "")
         {
            _loc2_ = "v" + param1[0].v + "\n\n" + _loc2_;
            Config.smReleaseNotesInfo = _loc2_;
            this.createReleaseNotesButton();
         }
      }
      
      private function onReleaseNotesTriggered() : void
      {
         InstanceMng.getPopupMng().openReleaseNotesPopup(Config.smReleaseNotesInfo);
         if(this.mReleaseNotesButton)
         {
            this.mReleaseNotesButton.removeFromParent();
         }
      }
   }
}

