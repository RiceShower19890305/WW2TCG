package com.fs.tcgengine.view.popups.misc
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.FSFacebookPlugin;
   import com.fs.tcgengine.controller.PvPConnectionMng;
   import com.fs.tcgengine.controller.QuestsMng;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.battle.BattleEnginePvP;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.screens.FSMapScreen;
   import com.fs.tcgengine.screens.FSMenuScreen;
   import com.fs.tcgengine.screens.FSShopScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.CustomComponent;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.components.popups.misc.SettingBlock;
   import com.fs.tcgengine.view.misc.AbilitiesPanel;
   import com.fs.tcgengine.view.misc.FSCredits;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.popups.Popup;
   import com.greensock.TweenMax;
   import feathers.controls.LayoutGroup;
   import feathers.controls.ScrollContainer;
   import feathers.layout.VerticalAlign;
   import feathers.layout.VerticalLayout;
   import feathers.layout.WaterfallLayout;
   import flash.display.StageDisplayState;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.Capabilities;
   import flash.utils.setTimeout;
   import starling.core.Starling;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   
   public class PopupSettings extends PopupStandard
   {
      
      private const MODE_SETTINGS:int = 0;
      
      private const MODE_SETTINGS_ADVANCED:int = 1;
      
      private const ADV_MODE_GAME:int = 0;
      
      private const ADV_MODE_SUPPORT:int = 1;
      
      private const TITLE_ICON_IMG_NAME:String = "settings_icon";
      
      private const HOW_TO_PLAY_IMG_NAME:String = "howtoplay_icon";
      
      private const FX_IMG_NAME:String = "fx_button_on";
      
      private const MUSIC_IMG_NAME:String = "music_button_on";
      
      private const SIGNOUT_IMG_NAME:String = "connect_icon";
      
      private const CREDITS_IMG_NAME:String = "credits_icon";
      
      private const COMIC_READER_IMG_NAME:String = "comic_icon";
      
      private const RESTORE_PURCHASES_IMG_NAME:String = "restore_icon";
      
      private const DISCORD_IMG_NAME:String = "discord_icon";
      
      private const FAN_PAGE_IMG_NAME:String = "fanpage_icon";
      
      private const LANGUAGE_IMG_NAME:String = "language_icon";
      
      private const MUSIC_BUTTON_NAME:String = "music_button";
      
      private const FX_BUTTON_NAME:String = "fx_button";
      
      private const SURRENDER_BUTTON_NAME:String = "surrender_button";
      
      private const SPEED_BUTTON_NAME:String = "speed_icon";
      
      private const FULL_SCREEN_BUTTON_NAME:String = "fullscreen_button";
      
      private const SEPARATOR_BUTTON_NAME:String = "settings_separator";
      
      private const SHARE_GAME_IMG_NAME:String = "share_icon";
      
      private const AP_LEFT_NAME:String = "apleft_icon";
      
      private const RELEASE_NOTES_BUTTON_NAME:String = "howtoplay_icon";
      
      private const VIBRATION_BUTTON_NAME:String = "vibration_button";
      
      private const TEAM_NOTIFICATIONS_BUTTON_NAME:String = "guildnotifications_icon";
      
      private const SUPPORT_BUTTON_NAME:String = "support_icon";
      
      private const EXIT_BUTTON_NAME:String = "exit_icon";
      
      private const ON_NAME:String = "_on";
      
      private const OFF_NAME:String = "_off";
      
      private const SHOW_DEFAULT_AVATAR_NAME:String = "defaultAvatar_icon";
      
      private const SHOW_ADVANCED_SETTINGS_NAME:String = "speed_icon";
      
      private const RESET_ICON_NAME:String = "reset_icon";
      
      private const LIGHT_FX_ICON_NAME:String = "light_icon";
      
      private const TRANSFER_ICON_NAME:String = "transfer_icon";
      
      private const BACKGROUNDS_ICON_NAME:String = "new_bg_icon";
      
      private var mSettingsMode:int = 0;
      
      private var mTitleTextfield:FSTextfield;
      
      private var mBackToSimpleSettingsButton:FSButton;
      
      private var mContainer:ScrollContainer;
      
      private var mSettingFXVol:SettingBlock;
      
      private var mSettingMusicVol:SettingBlock;
      
      private var mSettingAPLeft:SettingBlock;
      
      private var mSettingHowToPlay:SettingBlock;
      
      private var mSettingFacebookConnect:SettingBlock;
      
      private var mSettingCredits:SettingBlock;
      
      private var mSettingsRestorePurchases:SettingBlock;
      
      private var mSettingsDiscord:SettingBlock;
      
      private var mSettingsFanPage:SettingBlock;
      
      private var mSettingsChangeLanguage:SettingBlock;
      
      private var mSettingsSurrender:SettingBlock;
      
      private var mSettingsSeparator:FSImage;
      
      private var mSettingFullScreen:SettingBlock;
      
      private var mSettingShareGame:SettingBlock;
      
      private var mSettingGameSpeed:SettingBlock;
      
      private var mSettingReleaseNotes:SettingBlock;
      
      private var mSettingVibration:SettingBlock;
      
      private var mSettingScreenShake:SettingBlock;
      
      private var mSettingUseNewBGs:SettingBlock;
      
      private var mSettingShareInfoToGuild:SettingBlock;
      
      private var mSettingsExit:SettingBlock;
      
      private var mSettingShowDefaultAvatar:SettingBlock;
      
      private var mSettingAdvancedSettings:SettingBlock;
      
      private var mSettingSupportRequest:SettingBlock;
      
      private var mSettingLightFX:SettingBlock;
      
      private var mGeneralSettingsTab:FSButton;
      
      private var mSupportSettingsTab:FSButton;
      
      private var mSettingSupportResetProgress:SettingBlock;
      
      private var mSettingSupportTransferProgress:SettingBlock;
      
      private var mAdvancedSettingsContainer:ScrollContainer;
      
      public function PopupSettings(param1:Boolean = true)
      {
         super(param1);
      }
      
      override protected function removeFromStage() : void
      {
         if(this.mTitleTextfield)
         {
            this.mTitleTextfield.removeFromParent(true);
            this.mTitleTextfield = null;
         }
         if(this.mBackToSimpleSettingsButton)
         {
            this.mBackToSimpleSettingsButton.removeFromParent(true);
            this.mBackToSimpleSettingsButton = null;
         }
         if(this.mContainer)
         {
            this.mContainer.removeFromParent(true);
            this.mContainer = null;
         }
         if(this.mSettingHowToPlay)
         {
            this.mSettingHowToPlay.removeFromParent(true);
            this.mSettingHowToPlay = null;
         }
         if(this.mSettingFullScreen)
         {
            this.mSettingFullScreen.removeFromParent(true);
            this.mSettingFullScreen = null;
         }
         if(this.mSettingShareGame)
         {
            this.mSettingShareGame.removeFromParent(true);
            this.mSettingShareGame = null;
         }
         if(this.mSettingFacebookConnect)
         {
            this.mSettingFacebookConnect.removeFromParent(true);
            this.mSettingFacebookConnect = null;
         }
         if(this.mSettingCredits)
         {
            this.mSettingCredits.removeFromParent(true);
            this.mSettingCredits = null;
         }
         if(this.mSettingsRestorePurchases)
         {
            this.mSettingsRestorePurchases.removeFromParent(true);
            this.mSettingsRestorePurchases = null;
         }
         if(this.mSettingsDiscord)
         {
            this.mSettingsDiscord.removeFromParent(true);
            this.mSettingsDiscord = null;
         }
         if(this.mSettingsFanPage)
         {
            this.mSettingsFanPage.removeFromParent(true);
            this.mSettingsFanPage = null;
         }
         if(this.mSettingsChangeLanguage)
         {
            this.mSettingsChangeLanguage.removeFromParent(true);
            this.mSettingsChangeLanguage = null;
         }
         if(this.mSettingsSurrender)
         {
            this.mSettingsSurrender.removeFromParent(true);
            this.mSettingsSurrender = null;
         }
         if(this.mSettingsSeparator)
         {
            this.mSettingsSeparator.removeFromParent(true);
            this.mSettingsSeparator = null;
         }
         if(this.mSettingAdvancedSettings)
         {
            this.mSettingAdvancedSettings.removeFromParent(true);
            this.mSettingAdvancedSettings = null;
         }
         if(this.mSettingSupportRequest)
         {
            this.mSettingSupportRequest.removeFromParent(true);
            this.mSettingSupportRequest = null;
         }
         if(this.mSettingSupportResetProgress)
         {
            this.mSettingSupportResetProgress.removeFromParent(true);
            this.mSettingSupportResetProgress = null;
         }
         if(this.mSettingSupportTransferProgress)
         {
            this.mSettingSupportTransferProgress.removeFromParent(true);
            this.mSettingSupportTransferProgress = null;
         }
         if(this.mSettingFXVol)
         {
            this.mSettingFXVol.removeFromParent(true);
            this.mSettingFXVol = null;
         }
         if(this.mSettingMusicVol)
         {
            this.mSettingMusicVol.removeFromParent(true);
            this.mSettingMusicVol = null;
         }
         if(this.mSettingAPLeft)
         {
            this.mSettingAPLeft.removeFromParent(true);
            this.mSettingAPLeft = null;
         }
         if(this.mSettingGameSpeed)
         {
            this.mSettingGameSpeed.removeFromParent(true);
            this.mSettingGameSpeed = null;
         }
         if(this.mSettingReleaseNotes)
         {
            this.mSettingReleaseNotes.removeFromParent(true);
            this.mSettingReleaseNotes = null;
         }
         if(this.mSettingVibration)
         {
            this.mSettingVibration.removeFromParent(true);
            this.mSettingVibration = null;
         }
         if(this.mSettingScreenShake)
         {
            this.mSettingScreenShake.removeFromParent(true);
            this.mSettingScreenShake = null;
         }
         if(this.mSettingUseNewBGs)
         {
            this.mSettingUseNewBGs.removeFromParent(true);
            this.mSettingUseNewBGs = null;
         }
         if(this.mSettingShareInfoToGuild)
         {
            this.mSettingShareInfoToGuild.removeFromParent(true);
            this.mSettingShareInfoToGuild = null;
         }
         if(this.mSettingsExit)
         {
            this.mSettingsExit.removeFromParent(true);
            this.mSettingsExit = null;
         }
         if(this.mSettingShowDefaultAvatar)
         {
            this.mSettingShowDefaultAvatar.removeFromParent(true);
            this.mSettingShowDefaultAvatar = null;
         }
         if(this.mGeneralSettingsTab)
         {
            this.mGeneralSettingsTab.removeFromParent(true);
            this.mGeneralSettingsTab = null;
         }
         if(this.mSupportSettingsTab)
         {
            this.mSupportSettingsTab.removeFromParent(true);
            this.mSupportSettingsTab = null;
         }
         if(this.mAdvancedSettingsContainer)
         {
            this.mAdvancedSettingsContainer.removeFromParent(true);
            this.mAdvancedSettingsContainer = null;
         }
         if(this.mSettingLightFX)
         {
            this.mSettingLightFX.removeFromParent(true);
            this.mSettingLightFX = null;
         }
         InstanceMng.getPopupMng().removePopup(FSPopupMng.SETTINGS_POPUP_NAME);
         super.removeFromStage();
      }
      
      private function manageSettingsBlocksFromPopup() : void
      {
         var _loc1_:Boolean = this.mSettingsMode == this.MODE_SETTINGS_ADVANCED;
         if(_loc1_)
         {
            if(this.mSettingHowToPlay)
            {
               this.mSettingHowToPlay.removeFromParent();
            }
            if(this.mSettingFullScreen)
            {
               this.mSettingFullScreen.removeFromParent();
            }
            if(this.mSettingShareGame)
            {
               this.mSettingShareGame.removeFromParent();
            }
            if(this.mSettingFacebookConnect)
            {
               this.mSettingFacebookConnect.removeFromParent();
            }
            if(this.mSettingCredits)
            {
               this.mSettingCredits.removeFromParent();
            }
            if(this.mSettingsRestorePurchases)
            {
               this.mSettingsRestorePurchases.removeFromParent();
            }
            if(this.mSettingsDiscord)
            {
               this.mSettingsDiscord.removeFromParent();
            }
            if(this.mSettingsFanPage)
            {
               this.mSettingsFanPage.removeFromParent();
            }
            if(this.mSettingsChangeLanguage)
            {
               this.mSettingsChangeLanguage.removeFromParent();
            }
            if(this.mSettingsSurrender)
            {
               this.mSettingsSurrender.removeFromParent();
            }
            if(this.mSettingsSeparator)
            {
               this.mSettingsSeparator.removeFromParent();
            }
            if(this.mSettingAdvancedSettings)
            {
               this.mSettingAdvancedSettings.removeFromParent();
            }
            if(this.mSettingSupportRequest)
            {
               this.mSettingSupportRequest.removeFromParent();
            }
            if(this.mSettingSupportResetProgress)
            {
               this.mSettingSupportResetProgress.removeFromParent();
            }
            if(this.mSettingSupportTransferProgress)
            {
               this.mSettingSupportTransferProgress.removeFromParent();
            }
            if(this.mSettingFXVol)
            {
               this.mSettingFXVol.removeFromParent();
            }
            if(this.mSettingMusicVol)
            {
               this.mSettingMusicVol.removeFromParent();
            }
            if(this.mSettingAPLeft)
            {
               this.mSettingAPLeft.removeFromParent();
            }
            if(this.mSettingGameSpeed)
            {
               this.mSettingGameSpeed.removeFromParent();
            }
            if(this.mSettingReleaseNotes)
            {
               this.mSettingReleaseNotes.removeFromParent();
            }
            if(this.mSettingVibration)
            {
               this.mSettingVibration.removeFromParent();
            }
            if(this.mSettingScreenShake)
            {
               this.mSettingScreenShake.removeFromParent();
            }
            if(this.mSettingUseNewBGs)
            {
               this.mSettingUseNewBGs.removeFromParent();
            }
            if(this.mSettingShareInfoToGuild)
            {
               this.mSettingShareInfoToGuild.removeFromParent();
            }
            if(this.mSettingsExit)
            {
               this.mSettingsExit.removeFromParent();
            }
            if(this.mSettingShowDefaultAvatar)
            {
               this.mSettingShowDefaultAvatar.removeFromParent();
            }
            if(this.mSettingLightFX)
            {
               this.mSettingLightFX.removeFromParent();
            }
         }
         else
         {
            this.createContainer();
         }
      }
      
      override protected function createUI() : void
      {
         super.createUI();
         mAcceptButton.visible = false;
         this.createSettingsTopBar();
         this.createSettingBlocks();
         this.createContainer();
         this.refreshButtonsStates();
         if(Boolean(this.mContainer) && Boolean(this.mContainer.numChildren == 1) && this.mContainer.getChildAt(0) == this.mSettingAdvancedSettings)
         {
            this.onShowAdvancedSettingsTriggered();
         }
         this.onSettingsModeChanged();
      }
      
      private function createSettingBlocks() : void
      {
         var _loc2_:String = null;
         var _loc3_:FSFacebookPlugin = null;
         var _loc4_:Function = null;
         var _loc5_:int = 0;
         if(this.mSettingAdvancedSettings == null)
         {
            this.mSettingAdvancedSettings = new SettingBlock(TextManager.getText("TID_SETTINGS"),this.SHOW_ADVANCED_SETTINGS_NAME,this.onShowAdvancedSettingsTriggered);
         }
         if(this.mSettingFXVol == null)
         {
            this.mSettingFXVol = new SettingBlock(TextManager.getText("TID_GEN_FX"),this.FX_IMG_NAME,null,SettingBlock.BG_NAME,true,0,1,1,this.onFXVolumeChanged);
         }
         if(this.mSettingMusicVol == null && (!Utils.isAndroid() || Utils.isAndroid() && !Config.STORE_AUDIO_PATHS))
         {
            this.mSettingMusicVol = new SettingBlock(TextManager.getText("TID_GEN_MUSIC"),this.MUSIC_IMG_NAME,null,SettingBlock.BG_NAME,true,0,1,1,this.onMusicVolChanged);
         }
         if(this.mSettingAPLeft == null)
         {
            this.mSettingAPLeft = new SettingBlock(TextManager.getText("TID_GEN_APLEFT"),this.AP_LEFT_NAME + this.ON_NAME,this.onAPLeftTriggered);
         }
         this.updateAudioButtonsStates();
         this.updateAPLeftButtonsStates();
         if(this.mSettingHowToPlay == null)
         {
            this.mSettingHowToPlay = new SettingBlock(TextManager.getText("TID_SETTINGS_HOWTOPLAY"),this.HOW_TO_PLAY_IMG_NAME,this.onHowToPlayTriggered);
         }
         var _loc1_:Boolean = InstanceMng.getApplication().appleSignInIsSupported() && !InstanceMng.getApplication().hasUserSignedIntoApple() || !InstanceMng.getApplication().appleSignInIsSupported();
         if(Boolean(this.mSettingFacebookConnect == null && InstanceMng.getFacebookPlugin() && Utils.isMobile()) && Boolean(!InstanceMng.getApplication().isKongregateVersion()) && _loc1_)
         {
            _loc2_ = _loc2_ = "TID_SETTINGS_SIGNIN";
            if(Utils.smInternetAvailable)
            {
               _loc3_ = InstanceMng.getFacebookPlugin();
               if(_loc3_ != null && _loc3_.isSessionOpen())
               {
                  _loc2_ = "TID_SETTINGS_SIGNOUT";
               }
               else
               {
                  _loc2_ = "TID_SETTINGS_SIGNIN";
               }
            }
            this.mSettingFacebookConnect = new SettingBlock(TextManager.getText(_loc2_),this.SIGNOUT_IMG_NAME,this.onFacebookConnectTriggered);
            this.mSettingFacebookConnect.setEnabled(!Config.KICKSTARTER_EDITION && Utils.smInternetAvailable && Utils.isMobile());
         }
         if(this.mSettingCredits == null)
         {
            this.mSettingCredits = new SettingBlock(TextManager.getText("TID_CREDITS"),this.CREDITS_IMG_NAME,this.onShowCredits);
         }
         if(this.mSettingsRestorePurchases == null && Utils.isMobile())
         {
            this.mSettingsRestorePurchases = new SettingBlock(TextManager.getText("TID_GEN_RESTORE_PURCHASES"),this.RESTORE_PURCHASES_IMG_NAME,this.onRestorePurchases);
         }
         if(this.mSettingsFanPage == null)
         {
            this.mSettingsFanPage = new SettingBlock(TextManager.getText("TID_SETTINGS_FANPAGE"),this.FAN_PAGE_IMG_NAME,this.onShowFanPage);
         }
         if(this.mSettingsDiscord == null)
         {
            this.mSettingsDiscord = new SettingBlock(TextManager.getText("TID_SETTINGS_DISCORD"),this.DISCORD_IMG_NAME,this.onShowDiscord);
         }
         if(this.mSettingsChangeLanguage == null)
         {
            this.mSettingsChangeLanguage = new SettingBlock(TextManager.getText("TID_SETTINGS_CHANGE_LANGUAGE"),this.LANGUAGE_IMG_NAME,this.onChangeLanguage);
         }
         if(this.mSettingSupportRequest == null)
         {
            this.mSettingSupportRequest = new SettingBlock(TextManager.getText("TID_GEN_SUPPORT_TICKET"),this.SUPPORT_BUTTON_NAME,this.onSendTicket);
         }
         if(this.hasToShowSurrender() && this.mSettingsSurrender == null)
         {
            this.mSettingsSurrender = new SettingBlock(TextManager.getText("TID_GEN_SURRENDER"),this.SURRENDER_BUTTON_NAME,this.onSurrender,SettingBlock.BG_RED_NAME);
         }
         if(this.mSettingFullScreen == null && (Utils.isBrowser() || Utils.isDesktop()))
         {
            _loc4_ = Utils.isDesktop() ? this.performFullScreen : null;
            this.mSettingFullScreen = new SettingBlock(TextManager.getText("TID_GEN_FULL_SCREEN") + " (OFF)",this.FULL_SCREEN_BUTTON_NAME + this.OFF_NAME,_loc4_);
            if(Utils.isBrowser())
            {
               this.mSettingFullScreen.addEventListener(TouchEvent.TOUCH,this.onFullScreenTouch);
            }
            this.updateFullScreenButtonsState();
         }
         if(this.mSettingShareGame == null)
         {
            this.mSettingShareGame = new SettingBlock(TextManager.getText("TID_GEN_BUTTON_SHARE"),this.SHARE_GAME_IMG_NAME,this.onShare);
         }
         if(this.hasToShowGameSpeed() && this.mSettingGameSpeed == null)
         {
            _loc5_ = Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) ? InstanceMng.getUserDataMng().getOwnerUserData().flagsGetGameSpeed() : 1;
            this.mSettingGameSpeed = new SettingBlock(TextManager.getText("TID_SETTINGS_SPEED") + " x" + _loc5_,this.SPEED_BUTTON_NAME,this.setGameSpeed);
         }
         if(this.mSettingReleaseNotes == null && Config.smReleaseNotesInfo != "" && Config.smReleaseNotesInfo != null)
         {
            this.mSettingReleaseNotes = new SettingBlock(TextManager.getText("TID_GEN_PATCH_NOTES"),this.RELEASE_NOTES_BUTTON_NAME,this.showReleaseNotes);
         }
         if(Utils.isMobile() && this.mSettingVibration == null)
         {
            this.mSettingVibration = new SettingBlock(TextManager.getText("TID_GEN_VIBRATION"),this.VIBRATION_BUTTON_NAME + this.ON_NAME,this.onVibrationTriggered);
            this.updateVibrationButtonState();
         }
         if(this.mSettingUseNewBGs == null && Config.getConfig().gameHasBackgroundsOptions())
         {
            this.mSettingUseNewBGs = new SettingBlock(TextManager.getText("TID_SETTINGS_NEW_BGS"),this.BACKGROUNDS_ICON_NAME + this.ON_NAME,this.onUseNewBGsTriggered);
            this.updateUseNewBGsButtonState();
         }
         if(this.mSettingShareInfoToGuild == null)
         {
            this.mSettingShareInfoToGuild = new SettingBlock(TextManager.getText("TID_GEN_GUILDNOTIFICATIONS"),this.TEAM_NOTIFICATIONS_BUTTON_NAME + this.ON_NAME,this.onShareInfoToGuildTriggered);
            this.updateShareInfoToGuildButtonState();
         }
         if(this.mSettingsExit == null && Utils.isDesktop())
         {
            this.mSettingsExit = new SettingBlock(TextManager.getText("TID_SETTINGS_EXIT_GAME"),this.EXIT_BUTTON_NAME,this.onExitGame);
         }
         if(this.mSettingShowDefaultAvatar == null && Config.smShowUserRealPortrait)
         {
            if(Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) && InstanceMng.getUserDataMng().getOwnerUserData().getExtId() != "")
            {
               this.mSettingShowDefaultAvatar = new SettingBlock(TextManager.getText("TID_SETTINGS_AVATAR"),this.SHOW_DEFAULT_AVATAR_NAME + this.ON_NAME,this.onShowDefaultAvatar);
               this.updateShowDefaultAvatarState();
            }
         }
         if(this.mSettingSupportResetProgress == null)
         {
            this.mSettingSupportResetProgress = new SettingBlock(TextManager.getText("TID_RESET_BUTTON"),this.RESET_ICON_NAME,this.onResetProgress);
         }
         if(this.mSettingSupportTransferProgress == null && Utils.isDesktop() || Utils.isBrowser() && Config.getConfig().getSteamAppId() > 0 && !isNaN(Config.getConfig().getSteamAppId()))
         {
            this.mSettingSupportTransferProgress = new SettingBlock(TextManager.getText("TID_MIGRATION_NAME"),this.TRANSFER_ICON_NAME,this.onTransferProgress);
         }
         if(this.mSettingLightFX == null)
         {
            this.mSettingLightFX = new SettingBlock(TextManager.getText("TID_GEN_LIGHTS"),this.LIGHT_FX_ICON_NAME + this.ON_NAME,this.onShowLightFX);
            this.updateLightFXButtonState();
         }
      }
      
      private function onResetProgress() : void
      {
         var _loc1_:UserData = null;
         if(Boolean(this.mContainer) && !this.mContainer.isScrolling)
         {
            _loc1_ = Utils.getOwnerUserData();
            if(_loc1_)
            {
               InstanceMng.getUserDataMng().resetPlayer();
            }
         }
      }
      
      private function onTransferProgress() : void
      {
         if(Boolean(this.mContainer) && !this.mContainer.isScrolling)
         {
            if(Utils.isBrowser())
            {
               closePopup(InstanceMng.getPopupMng().openGetTansferCodePopup);
            }
            else if(Utils.isDesktop())
            {
               closePopup(InstanceMng.getPopupMng().openRedeemTransferCodePopup);
            }
         }
      }
      
      private function onSendTicket() : void
      {
         var _loc1_:UserData = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:URLRequest = null;
         if(Boolean(this.mContainer) && !this.mContainer.isScrolling)
         {
            _loc1_ = Utils.getOwnerUserData();
            if(Boolean(_loc1_) && Boolean(InstanceMng.getServerConnection()))
            {
               Utils.setLogText(TextManager.getText("TID_GEN_SUPPORT_TICKET_WAIT"),false,false,false);
               _loc2_ = " Platform: " + InstanceMng.getServerConnection().getPlatformId() + " (v" + Utils.getAppVersion() + ")" + "\n" + " AIR Info: " + Capabilities.version.toString() + "\n" + " OS: " + Capabilities.os + "\n" + " Ticket Time: " + new Date(InstanceMng.getServerConnection().getRequestDateObject()).toString() + "\n" + " User ID: " + _loc1_.getAccountId();
               _loc3_ = "Support Ticket [" + Config.getConfig().gameCreditsGameName() + "] User Nick: " + _loc1_.getName() + " | User ID: " + _loc1_.getAccountId();
               _loc4_ = "Welcome to Frozenshard\'s ticketing system. \n\nPlease do NOT delete any of this pre-filled information," + " also in case you experienced an issue purchasing a product, do not forget to attach to this email the invoice/receipt.\n\nThank you and " + "please accept our apologies about the issue you experienced, we will try to work on it as soon as possible.\n\n" + " [Hardware Information]\n" + _loc2_ + "\n\n== Please explain here the issue you experienced, try to be as detailed as possible ==";
               _loc5_ = new URLRequest("mailto:support@frozenshard.com?subject=" + _loc3_ + "&body=" + _loc4_);
               navigateToURL(_loc5_,"_blank");
            }
            else
            {
               Utils.setLogText(TextManager.getText("TID_GEN_SERVER_RETRY"),true,false,false);
            }
         }
      }
      
      private function onShowDefaultAvatar() : void
      {
         var _loc1_:UserData = null;
         var _loc2_:Boolean = false;
         var _loc3_:Object = null;
         var _loc4_:String = null;
         if(Boolean(this.mContainer) && !this.mContainer.isScrolling)
         {
            _loc1_ = Utils.getOwnerUserData();
            _loc2_ = false;
            if(_loc1_)
            {
               _loc2_ = InstanceMng.getUserDataMng().getOwnerUserData().flagsShowDefaultAvatar();
               _loc1_.setShowDefaultAvatarFlag(!_loc2_);
               _loc1_.setPhotoTexture(null);
               _loc3_ = Boolean(ServerConnection.smServerUserObject) && ServerConnection.smServerUserObject.hasOwnProperty("profile") ? ServerConnection.smServerUserObject["profile"] : null;
               _loc4_ = !_loc1_.flagsShowDefaultAvatar() && _loc3_ != null && _loc3_.hasOwnProperty("extPhotoURL") ? _loc3_["extPhotoURL"] : "";
               _loc1_.setPhotoUrl(_loc4_);
               Utils.setLogText(TextManager.getText("TID_SETTINGS_CHANGE_RESTART"),false,false,false);
            }
            this.updateShowDefaultAvatarState();
         }
      }
      
      private function onShowLightFX() : void
      {
         var _loc1_:UserData = null;
         var _loc2_:Boolean = false;
         if(Boolean(this.mContainer) && !this.mContainer.isScrolling)
         {
            _loc1_ = Utils.getOwnerUserData();
            _loc2_ = true;
            if(_loc1_)
            {
               _loc2_ = InstanceMng.getUserDataMng().getOwnerUserData().flagsGetShowLightFX();
               _loc1_.setShowLightFX(!_loc2_);
               if(InstanceMng.getCurrentScreen())
               {
                  if(InstanceMng.getUserDataMng().getOwnerUserData().flagsGetShowLightFX())
                  {
                     InstanceMng.getCurrentScreen().addLights(false,true);
                  }
                  else
                  {
                     InstanceMng.getCurrentScreen().removeLights();
                  }
               }
               Utils.setLogText(TextManager.getText("TID_SETTINGS_CHANGE_RESTART"),false,false,false);
            }
            this.updateLightFXButtonState();
         }
      }
      
      private function onExitGame() : void
      {
         var _loc1_:Popup = null;
         if(Boolean(this.mContainer) && !this.mContainer.isScrolling)
         {
            _loc1_ = InstanceMng.getPopupMng().getPopupShown();
            if(_loc1_)
            {
               _loc1_.hideTemporarily(InstanceMng.getPopupMng().openConfirmationPopup,[TextManager.getText("TID_GEN_EXIT"),this.onExitConfirm,this.onExitCancel]);
            }
            else
            {
               InstanceMng.getPopupMng().openConfirmationPopup(TextManager.getText("TID_GEN_EXIT"),this.onExitConfirm,this.onExitCancel);
            }
         }
      }
      
      private function onExitCancel() : void
      {
      }
      
      private function onExitConfirm() : void
      {
         InstanceMng.getUserDataMng().persistenceSaveData();
         InstanceMng.getApplication().exitApp();
      }
      
      private function showReleaseNotes() : void
      {
         var _loc1_:Popup = null;
         if(Boolean(this.mContainer && !this.mContainer.isScrolling && InstanceMng.getApplication().isGamePlayable()) && Boolean(Config.smReleaseNotesInfo != "") && Config.smReleaseNotesInfo != null)
         {
            _loc1_ = InstanceMng.getPopupMng().getPopupShown();
            if(_loc1_)
            {
               _loc1_.hideTemporarily(InstanceMng.getPopupMng().openReleaseNotesPopup,[Config.smReleaseNotesInfo,false]);
            }
            else
            {
               InstanceMng.getPopupMng().openReleaseNotesPopup(Config.smReleaseNotesInfo,false);
            }
         }
      }
      
      private function onFullScreenTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1 ? param1.getTouch(this.mSettingFullScreen) : null;
         if(!_loc2_)
         {
            return;
         }
         if(_loc2_.phase == TouchPhase.BEGAN)
         {
            Starling.current.nativeStage.addEventListener(MouseEvent.MOUSE_UP,this.fullScreen);
         }
      }
      
      private function fullScreen(param1:MouseEvent) : void
      {
         Starling.current.nativeStage.removeEventListener(MouseEvent.MOUSE_UP,this.fullScreen);
         this.performFullScreen();
      }
      
      private function performFullScreen() : void
      {
         if(Starling.current.nativeStage.displayState == StageDisplayState.NORMAL)
         {
            Starling.current.nativeStage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
            Utils.saveDataOnSharedObj("fullScreen",true);
         }
         else
         {
            Starling.current.nativeStage.displayState = StageDisplayState.NORMAL;
            Utils.saveDataOnSharedObj("fullScreen",false);
         }
         this.updateFullScreenButtonsState();
      }
      
      private function refreshButtonsStates() : void
      {
         var _loc1_:Boolean = this.areMiscButtonsAvailable();
         if(this.mSettingHowToPlay)
         {
            this.mSettingHowToPlay.setEnabled(_loc1_);
         }
         if(Boolean(this.mSettingFacebookConnect != null) && Boolean(InstanceMng.getFacebookPlugin()) && Utils.isMobile())
         {
            this.mSettingFacebookConnect.setEnabled(Utils.smInternetAvailable && _loc1_);
         }
         if(this.mSettingCredits)
         {
            this.mSettingCredits.setEnabled(_loc1_);
         }
         if(this.mSettingsRestorePurchases != null && Utils.isMobile())
         {
            this.mSettingsRestorePurchases.setEnabled(_loc1_);
         }
         if(this.mSettingsChangeLanguage)
         {
            this.mSettingsChangeLanguage.setEnabled(_loc1_);
         }
         if(this.mSettingSupportRequest)
         {
            this.mSettingSupportRequest.setEnabled(_loc1_);
         }
         if(this.mSettingSupportResetProgress)
         {
            this.mSettingSupportResetProgress.setEnabled(_loc1_);
         }
         if(this.mSettingSupportTransferProgress)
         {
            this.mSettingSupportTransferProgress.setEnabled(_loc1_);
         }
      }
      
      private function onShare() : void
      {
         if(this.mSettingShareGame)
         {
            this.mSettingShareGame.setEnabled(false);
         }
         TweenMax.delayedCall(1,this.setSettingShareEnabled,[true]);
         Utils.shareGame(true);
      }
      
      private function setSettingShareEnabled(param1:Boolean) : void
      {
         if(this.mSettingShareGame)
         {
            this.mSettingShareGame.setEnabled(param1);
         }
      }
      
      private function setSettingEnabled(param1:SettingBlock, param2:Boolean) : void
      {
         if(param1)
         {
            param1.setEnabled(param2);
         }
      }
      
      private function hasToShowSurrender() : Boolean
      {
         return Boolean(InstanceMng.getCurrentScreen()) && InstanceMng.getCurrentScreen() is FSBattleScreen;
      }
      
      private function hasToShowGameSpeed() : Boolean
      {
         return InstanceMng.getBattleEngine() == null || Boolean(InstanceMng.getBattleEngine()) && !InstanceMng.getBattleEngine().isOnlineMatch();
      }
      
      private function onSurrender() : void
      {
         var surrender:Function = null;
         var turns:int = 0;
         surrender = function():void
         {
            setTimeout(closePopup,Popup.TRANSITION_TIME * 1000,onClosedSurrender);
         };
         this.disableSurrenderButtonTemporarily();
         if(Boolean(InstanceMng.getBattleEngine() && InstanceMng.getBattleEngine().isPvPMatch()) && Boolean(InstanceMng.getBattleEngine().isOnlineMatch()) && !PvPConnectionMng.smPlayingFriendlyMatch)
         {
            turns = PvPConnectionMng.smNotificationTurnId;
            if(turns <= PvPConnectionMng.smPvPMinTurnsToBanSurrender)
            {
               hideTemporarily(InstanceMng.getPopupMng().openConfirmationPopup,[TextManager.getText("TID_PVP_SURRENDER_EARLY"),surrender]);
            }
            else
            {
               surrender();
            }
         }
         else
         {
            surrender();
         }
      }
      
      private function setGameSpeed() : void
      {
         var _loc1_:UserData = Utils.getOwnerUserData();
         var _loc2_:int = _loc1_ ? _loc1_.flagsGetGameSpeed() : 1;
         var _loc3_:int = _loc2_ + 1 <= 3 ? int(_loc2_ + 1) : 1;
         if(_loc1_)
         {
            _loc1_.setGameSpeedFactor(_loc3_);
         }
         else
         {
            Config.smGameSpeedMultiplier = _loc3_;
         }
         if(this.mSettingGameSpeed)
         {
            this.mSettingGameSpeed.updateTitle(TextManager.getText("TID_SETTINGS_SPEED") + " x" + _loc3_);
         }
         if(Config.getConfig().hasQuests())
         {
            InstanceMng.getQuestsMng().addActionPerformed(QuestsMng.TARGET_TYPE_EDIT_SPEED,1);
         }
      }
      
      public function disableSurrenderButtonTemporarily() : void
      {
         if(this.mSettingsSurrender)
         {
            this.setSettingSurrenderEnabled(false);
         }
         TweenMax.delayedCall(2,this.setSettingSurrenderEnabled,[true]);
      }
      
      private function setSettingSurrenderEnabled(param1:Boolean) : void
      {
         if(this.mSettingsSurrender)
         {
            this.mSettingsSurrender.setEnabled(param1);
         }
         if(this.mSettingsExit)
         {
            this.mSettingsExit.setEnabled(param1);
         }
      }
      
      private function onClosedSurrender() : void
      {
         var _loc2_:LevelDef = null;
         var _loc3_:String = null;
         var _loc4_:AbilitiesPanel = null;
         var _loc1_:BattleEngine = InstanceMng.getBattleEngine();
         if(_loc1_ != null)
         {
            if(_loc1_.isPvPMatch())
            {
               if(_loc1_.isOnlineMatch())
               {
                  PvPConnectionMng.onSurrenderPvPMatch();
                  BattleEnginePvP(InstanceMng.getBattleEngine()).onBattleOver(false,true);
               }
               else
               {
                  Utils.createPvPOverEffect(null);
               }
            }
            else if(!_loc1_.isBattleOver())
            {
               _loc2_ = _loc1_.getLevelDef();
               _loc3_ = Boolean(Root) && Boolean(Root.smBattleData) && Boolean(Root.smBattleData.easyMode) ? FSTracker.ACTION_SURRENDER_EASY_MODE : FSTracker.ACTION_SURRENDER;
               if(_loc2_)
               {
                  FSTracker.trackMiscAction(FSTracker.getLevelCategoryByDifficulty(),_loc3_,{"level":_loc2_.getSku()});
               }
               _loc4_ = InstanceMng.getBattleEngine().getBattleScreen().getAbilitiesChooserPanel();
               if(_loc4_)
               {
                  _loc4_.forceClose();
               }
               InstanceMng.getBattleEngine().setBattleStateId(BattleEngine.BATTLE_STATE_BATTLE_OVER);
               InstanceMng.getBattleEngine().onBattleOver(false,true);
            }
         }
         InstanceMng.getUserDataMng().persistenceSaveData();
      }
      
      private function onMusicVolChanged(param1:Number) : void
      {
         if(Boolean(this.mContainer) && !this.mContainer.isScrolling)
         {
            if(Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
            {
               InstanceMng.getUserDataMng().getOwnerUserData().setMusicVol(param1);
            }
            this.updateAudioButtonsStates();
         }
      }
      
      private function onShareInfoToGuildTriggered() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:String = null;
         if(Boolean(this.mContainer) && !this.mContainer.isScrolling)
         {
            if(Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
            {
               _loc1_ = Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) ? InstanceMng.getUserDataMng().getOwnerUserData().flagsGetShareInfoToGuild() : false;
               _loc2_ = _loc1_ ? TextManager.getText("TID_GEN_GUILDNOTIFICATIONS_DESC_OFF") : TextManager.getText("TID_GEN_GUILDNOTIFICATIONS_DESC_ON");
               Utils.setLogText(_loc2_,false,false,false);
               InstanceMng.getUserDataMng().getOwnerUserData().setShareInfoToGuild(!_loc1_);
            }
            this.updateShareInfoToGuildButtonState();
         }
      }
      
      private function updateShareInfoToGuildButtonState() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
         {
            _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData().flagsGetShareInfoToGuild();
            if(this.mSettingShareInfoToGuild != null)
            {
               _loc2_ = _loc1_ ? " (ON)" : " (OFF)";
               this.mSettingShareInfoToGuild.switchName(TextManager.getText("TID_GEN_GUILDNOTIFICATIONS") + _loc2_);
               _loc3_ = _loc1_ ? this.TEAM_NOTIFICATIONS_BUTTON_NAME + this.ON_NAME : this.TEAM_NOTIFICATIONS_BUTTON_NAME + this.OFF_NAME;
               this.mSettingShareInfoToGuild.switchIconImage(_loc3_);
            }
         }
      }
      
      private function updateShowDefaultAvatarState() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
         {
            _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData().flagsShowDefaultAvatar();
            if(this.mSettingShowDefaultAvatar != null)
            {
               _loc2_ = _loc1_ ? " (ON)" : " (OFF)";
               this.mSettingShowDefaultAvatar.switchName(TextManager.getText("TID_SETTINGS_AVATAR") + _loc2_);
               _loc3_ = _loc1_ ? this.SHOW_DEFAULT_AVATAR_NAME + this.ON_NAME : this.SHOW_DEFAULT_AVATAR_NAME + this.OFF_NAME;
               this.mSettingShowDefaultAvatar.switchIconImage(_loc3_);
            }
         }
      }
      
      private function onVibrationTriggered() : void
      {
         var _loc1_:Boolean = false;
         if(Boolean(this.mContainer) && !this.mContainer.isScrolling)
         {
            if(Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
            {
               _loc1_ = Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) ? InstanceMng.getUserDataMng().getOwnerUserData().flagsGetVibrationON() : false;
               InstanceMng.getUserDataMng().getOwnerUserData().setVibrationON(!_loc1_);
               if(!_loc1_)
               {
                  InstanceMng.getApplication().vibrate();
               }
            }
            this.updateVibrationButtonState();
         }
      }
      
      private function updateVibrationButtonState() : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc1_:Boolean = InstanceMng.getUserDataMng().getOwnerUserData().flagsGetVibrationON();
         if(this.mSettingVibration != null)
         {
            _loc3_ = _loc1_ ? this.VIBRATION_BUTTON_NAME + this.ON_NAME : this.VIBRATION_BUTTON_NAME + this.OFF_NAME;
            this.mSettingVibration.switchIconImage(_loc3_);
            _loc2_ = _loc1_ ? " (ON)" : " (OFF)";
            this.mSettingVibration.switchName(TextManager.getText("TID_GEN_VIBRATION") + _loc2_);
         }
      }
      
      private function onUseNewBGsTriggered() : void
      {
         var _loc1_:UserData = null;
         var _loc2_:Boolean = false;
         if(Boolean(this.mContainer) && !this.mContainer.isScrolling)
         {
            _loc1_ = Utils.getOwnerUserData();
            if(_loc1_)
            {
               _loc2_ = _loc1_.flagsGetUseNewBGsON();
               _loc1_.setUseNewBGsON(!_loc2_);
            }
            this.updateUseNewBGsButtonState();
            Utils.setLogText(TextManager.getText("TID_SETTINGS_CHANGE_RESTART"),false,false,false);
         }
      }
      
      private function updateUseNewBGsButtonState() : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc1_:Boolean = InstanceMng.getUserDataMng().getOwnerUserData().flagsGetUseNewBGsON();
         if(this.mSettingUseNewBGs != null)
         {
            _loc3_ = _loc1_ ? this.BACKGROUNDS_ICON_NAME + this.ON_NAME : this.BACKGROUNDS_ICON_NAME + this.OFF_NAME;
            this.mSettingUseNewBGs.switchIconImage(_loc3_);
            _loc2_ = _loc1_ ? " (ON)" : " (OFF)";
            this.mSettingUseNewBGs.switchName(TextManager.getText("TID_SETTINGS_NEW_BGS") + _loc2_);
         }
      }
      
      private function onScreenShakeTriggered() : void
      {
         var _loc1_:Boolean = false;
         if(Boolean(this.mContainer) && !this.mContainer.isScrolling)
         {
            if(Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
            {
               _loc1_ = Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) ? InstanceMng.getUserDataMng().getOwnerUserData().flagsGetScreenShakeON() : false;
               InstanceMng.getUserDataMng().getOwnerUserData().setScreenShakeON(!_loc1_);
            }
            this.updateScreenShakeButtonState();
         }
      }
      
      private function updateScreenShakeButtonState() : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc1_:Boolean = InstanceMng.getUserDataMng().getOwnerUserData().flagsGetScreenShakeON();
         if(this.mSettingScreenShake != null)
         {
            _loc3_ = _loc1_ ? this.VIBRATION_BUTTON_NAME + this.ON_NAME : this.VIBRATION_BUTTON_NAME + this.OFF_NAME;
            this.mSettingScreenShake.switchIconImage(_loc3_);
            _loc2_ = _loc1_ ? " (ON)" : " (OFF)";
            this.mSettingScreenShake.switchName(TextManager.getText("TID_GEN_SCREENSHAKE") + _loc2_);
         }
      }
      
      private function updateLightFXButtonState() : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc1_:Boolean = InstanceMng.getUserDataMng().getOwnerUserData().flagsGetShowLightFX();
         if(this.mSettingLightFX != null)
         {
            _loc3_ = _loc1_ ? this.LIGHT_FX_ICON_NAME + this.ON_NAME : this.LIGHT_FX_ICON_NAME + this.OFF_NAME;
            this.mSettingLightFX.switchIconImage(_loc3_);
            _loc2_ = _loc1_ ? " (ON)" : " (OFF)";
            this.mSettingLightFX.switchName(TextManager.getText("TID_GEN_LIGHTS") + _loc2_);
         }
      }
      
      private function onAPLeftTriggered() : void
      {
         var _loc1_:UserData = null;
         var _loc2_:String = null;
         if(Boolean(this.mContainer) && !this.mContainer.isScrolling)
         {
            _loc1_ = Utils.getOwnerUserData();
            if(_loc1_)
            {
               _loc1_.setAPLeftWarning(!_loc1_.flagsGetAPLeftWarning());
               _loc2_ = TextManager.getText("TID_GEN_APLEFT_INFO");
               _loc2_ += _loc1_.flagsGetAPLeftWarning() ? " (ON)" : " (OFF)";
               Utils.setLogText(_loc2_,false,false,false);
            }
            this.updateAPLeftButtonsStates();
         }
      }
      
      private function onShowAdvancedSettingsTriggered() : void
      {
         if(Boolean(this.mContainer) && Boolean(!this.mContainer.isScrolling) && mBox is CustomComponent)
         {
            this.mSettingsMode = this.MODE_SETTINGS_ADVANCED;
            this.onSettingsModeChanged();
         }
      }
      
      private function onSettingsModeChanged() : void
      {
         var _loc1_:int = this.mSettingsMode == this.MODE_SETTINGS ? 740 : 1500;
         var _loc2_:String = this.mSettingsMode == this.MODE_SETTINGS ? Constants.POPUP_SETTINGS_NAME : Constants.POPUP_LARGE_NAME;
         mBox.scale = this.mSettingsMode == this.MODE_SETTINGS ? Constants.POPUP_SETTINGS_SCALE_FACTOR : Constants.POPUP_SETTINGS_ADV_SCALE_FACTOR;
         CustomComponent(mBox).updateTextures(_loc2_,_loc1_,false);
         var _loc3_:int = Starling.current.stage.stageWidth;
         var _loc4_:int = Starling.current.stage.stageHeight;
         setupCloseButton();
         this.createSettingsTopBar();
         this.manageBackToSimpleSettingsButton();
         this.manageSettingsBlocksFromPopup();
         this.manageAdvancedSettings();
         var _loc5_:FSCoordinate = new FSCoordinate((_loc3_ - width) / 2,(_loc4_ - height) / 2);
         x = _loc5_.getX();
         y = _loc5_.getY();
      }
      
      private function manageAdvancedSettings() : void
      {
         if(this.mSettingsMode == this.MODE_SETTINGS_ADVANCED)
         {
            if(this.mGeneralSettingsTab == null)
            {
               this.mGeneralSettingsTab = new FSButton(Root.assets.getTexture("button_settings_large_on"),TextManager.getText("TID_GEN_BUTTON_GENERAL"));
               Utils.setupButton9Scale(this.mGeneralSettingsTab,12.5,15,5,5,103.5,43);
               this.mGeneralSettingsTab.x = mBox.x + mBox.width * 0.33;
               this.mGeneralSettingsTab.y = this.mGeneralSettingsTab.height;
               this.mGeneralSettingsTab.addEventListener(Event.TRIGGERED,this.onGeneralAdvancedSettingsClicked);
            }
            addChild(this.mGeneralSettingsTab);
            if(this.mSupportSettingsTab == null)
            {
               this.mSupportSettingsTab = new FSButton(Root.assets.getTexture("button_settings_large_off"),TextManager.getText("TID_GEN_BUTTON_SUPPORT"));
               Utils.setupButton9Scale(this.mSupportSettingsTab,12.5,15,5,5,103.5,43);
               this.mSupportSettingsTab.x = mBox.x + mBox.width * 0.66;
               this.mSupportSettingsTab.y = this.mGeneralSettingsTab.y;
               this.mSupportSettingsTab.addEventListener(Event.TRIGGERED,this.onSupportAdvancedSettingsClicked);
            }
            addChild(this.mGeneralSettingsTab);
            addChild(this.mSupportSettingsTab);
            this.onGeneralAdvancedSettingsClicked(null);
         }
         else
         {
            if(this.mGeneralSettingsTab)
            {
               this.mGeneralSettingsTab.removeFromParent();
            }
            if(this.mSupportSettingsTab)
            {
               this.mSupportSettingsTab.removeFromParent();
            }
            if(this.mAdvancedSettingsContainer)
            {
               this.mAdvancedSettingsContainer.removeChildren();
               this.mAdvancedSettingsContainer.removeFromParent();
            }
         }
      }
      
      private function createAdvancedSettingsContainer() : void
      {
         var _loc1_:WaterfallLayout = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.mAdvancedSettingsContainer == null)
         {
            this.mAdvancedSettingsContainer = new ScrollContainer();
            _loc1_ = new WaterfallLayout();
            _loc1_.gap = 2;
            this.mAdvancedSettingsContainer.layout = _loc1_;
            _loc2_ = this.mSettingHowToPlay.width * 2.1;
            _loc3_ = this.mTitleTextfield.y + this.mTitleTextfield.height + this.mSettingHowToPlay.height / 2;
            this.mAdvancedSettingsContainer.width = _loc2_;
            this.mAdvancedSettingsContainer.height = mBox.height * 0.925 - _loc3_;
            this.mAdvancedSettingsContainer.x = (mBox.width - _loc2_) / 2;
            this.mAdvancedSettingsContainer.y = _loc3_;
         }
      }
      
      private function onSupportAdvancedSettingsClicked(param1:Event) : void
      {
         if(this.mGeneralSettingsTab)
         {
            this.mGeneralSettingsTab.upState = Root.assets.getTexture("button_settings_large_off");
         }
         if(this.mSupportSettingsTab)
         {
            this.mSupportSettingsTab.upState = Root.assets.getTexture("button_settings_large_on");
         }
         this.createAdvancedSettingsContainer();
         this.mAdvancedSettingsContainer.removeChildren();
         if(this.mSettingHowToPlay)
         {
            this.mAdvancedSettingsContainer.addChild(this.mSettingHowToPlay);
         }
         if(this.mSettingsFanPage)
         {
            this.mAdvancedSettingsContainer.addChild(this.mSettingsFanPage);
         }
         if(this.mSettingsDiscord)
         {
            this.mAdvancedSettingsContainer.addChild(this.mSettingsDiscord);
         }
         if(Utils.isMobile())
         {
            this.mAdvancedSettingsContainer.addChild(this.mSettingsRestorePurchases);
         }
         if(this.mSettingCredits)
         {
            this.mAdvancedSettingsContainer.addChild(this.mSettingCredits);
         }
         if(this.mSettingsChangeLanguage)
         {
            this.mAdvancedSettingsContainer.addChild(this.mSettingsChangeLanguage);
         }
         if(this.mSettingSupportRequest)
         {
            this.mAdvancedSettingsContainer.addChild(this.mSettingSupportRequest);
         }
         if(this.mSettingSupportResetProgress)
         {
            this.mAdvancedSettingsContainer.addChild(this.mSettingSupportResetProgress);
         }
         if(this.mSettingSupportTransferProgress)
         {
            this.mAdvancedSettingsContainer.addChild(this.mSettingSupportTransferProgress);
         }
      }
      
      private function onGeneralAdvancedSettingsClicked(param1:Event) : void
      {
         if(this.mGeneralSettingsTab)
         {
            this.mGeneralSettingsTab.upState = Root.assets.getTexture("button_settings_large_on");
         }
         if(this.mSupportSettingsTab)
         {
            this.mSupportSettingsTab.upState = Root.assets.getTexture("button_settings_large_off");
         }
         this.createAdvancedSettingsContainer();
         this.mAdvancedSettingsContainer.removeChildren();
         if(this.mSettingFXVol)
         {
            this.mAdvancedSettingsContainer.addChild(this.mSettingFXVol);
         }
         if(this.mSettingMusicVol)
         {
            this.mAdvancedSettingsContainer.addChild(this.mSettingMusicVol);
         }
         if(this.mSettingGameSpeed)
         {
            this.mAdvancedSettingsContainer.addChild(this.mSettingGameSpeed);
         }
         if(this.mSettingAPLeft)
         {
            this.mAdvancedSettingsContainer.addChild(this.mSettingAPLeft);
         }
         if(this.mSettingShareInfoToGuild)
         {
            this.mAdvancedSettingsContainer.addChild(this.mSettingShareInfoToGuild);
         }
         if(this.mSettingVibration)
         {
            this.mAdvancedSettingsContainer.addChild(this.mSettingVibration);
         }
         if(this.mSettingScreenShake)
         {
            this.mAdvancedSettingsContainer.addChild(this.mSettingScreenShake);
         }
         if(this.mSettingUseNewBGs)
         {
            this.mAdvancedSettingsContainer.addChild(this.mSettingUseNewBGs);
         }
         if(this.mSettingShareGame)
         {
            this.mAdvancedSettingsContainer.addChild(this.mSettingShareGame);
         }
         if(this.mSettingFacebookConnect)
         {
            this.mAdvancedSettingsContainer.addChild(this.mSettingFacebookConnect);
         }
         if(this.mSettingShowDefaultAvatar)
         {
            this.mAdvancedSettingsContainer.addChild(this.mSettingShowDefaultAvatar);
         }
         if(this.mSettingReleaseNotes)
         {
            this.mAdvancedSettingsContainer.addChild(this.mSettingReleaseNotes);
         }
         if(this.mSettingLightFX)
         {
            this.mAdvancedSettingsContainer.addChild(this.mSettingLightFX);
         }
         addChild(this.mAdvancedSettingsContainer);
      }
      
      private function createLayout() : LayoutGroup
      {
         return new LayoutGroup();
      }
      
      private function onFXVolumeChanged(param1:Number) : void
      {
         if(Boolean(this.mContainer) && !this.mContainer.isScrolling)
         {
            if(Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
            {
               InstanceMng.getUserDataMng().getOwnerUserData().setSoundVol(param1);
            }
            this.updateAudioButtonsStates();
         }
      }
      
      private function onHowToPlayTriggered() : void
      {
         var _loc1_:Popup = null;
         if(Boolean(this.mContainer) && Boolean(!this.mContainer.isScrolling) && InstanceMng.getApplication().isGamePlayable())
         {
            _loc1_ = InstanceMng.getPopupMng().getPopupShown();
            if(_loc1_)
            {
               _loc1_.hideTemporarily(InstanceMng.getPopupMng().openHowToPlayPopup);
            }
            else
            {
               InstanceMng.getPopupMng().openHowToPlayPopup();
            }
         }
      }
      
      private function onFacebookConnectTriggered() : void
      {
         var _loc1_:FSFacebookPlugin = null;
         var _loc2_:Screen = null;
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
         if(Boolean(this.mContainer) && Boolean(!this.mContainer.isScrolling) && InstanceMng.getApplication().isGamePlayable())
         {
            if(Utils.smInternetAvailable)
            {
               if(InstanceMng.getCurrentScreen() is FSMenuScreen || InstanceMng.getCurrentScreen() is FSMapScreen)
               {
                  _loc1_ = InstanceMng.getFacebookPlugin();
                  if(_loc1_ != null && _loc1_.isSessionOpen())
                  {
                     hideTemporarily(InstanceMng.getPopupMng().openLogoutFromFBPopup);
                  }
                  else
                  {
                     _loc2_ = InstanceMng.getCurrentScreen();
                     if(_loc2_)
                     {
                        _loc2_.lockUI(true);
                     }
                     this.mSettingFacebookConnect.setEnabled(false);
                     closePopup();
                     Utils.setLogText(TextManager.getText("TID_FACEBOOK_CONNECTING"),false,false,false);
                     TweenMax.delayedCall(1,this.performFBLogin,[_loc1_,this.onFBLoginSuccess,true]);
                  }
               }
               else
               {
                  Utils.setLogText(TextManager.getText("TID_LOGOUT_SCREEN"),false,false,false);
               }
            }
            else
            {
               Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true,false,false);
               InstanceMng.getCurrentScreen().onConnectionLost();
            }
         }
      }
      
      private function performFBLogin(param1:FSFacebookPlugin, param2:Function, param3:Boolean) : void
      {
         if(param1)
         {
            param1.login(param2,param3);
         }
      }
      
      public function updateSettingsText(param1:String) : void
      {
         if(this.mSettingFacebookConnect)
         {
            this.mSettingFacebookConnect.updateTitle(param1);
         }
      }
      
      private function onFBLoginSuccess() : void
      {
         Utils.setLogText(TextManager.getText("TID_FACEBOOK_SYNC"),false,false,false);
      }
      
      private function onShowCredits() : void
      {
         if(Boolean(this.mContainer && !this.mContainer.isScrolling) && Boolean(InstanceMng.getCurrentScreen().getOptionsPanel()) && !InstanceMng.getCurrentScreen().getOptionsPanel().areCreditsBeingShown())
         {
            InstanceMng.getCurrentScreen().getOptionsPanel().setCreditsBeingShown(true);
            closePopup(this.addCreditsToStage);
         }
      }
      
      private function addCreditsToStage() : void
      {
         var _loc1_:FSCredits = InstanceMng.getResourcesMng().createGameCredits();
         InstanceMng.getCurrentScreen().addChild(_loc1_);
      }
      
      private function onRestorePurchases() : void
      {
         if(Boolean(this.mContainer) && !this.mContainer.isScrolling)
         {
            if(InstanceMng.getCurrentScreen() is FSShopScreen)
            {
               Utils.setLogText(TextManager.getText("TID_GEN_RESTORE_PURCHASES") + " " + TextManager.getText("TID_GEN_WAIT"),false,false,false);
               InstanceMng.getApplication().getInAppsManager().backendRestorePurchases();
            }
            else
            {
               Utils.setLogText(TextManager.getText("TID_GEN_RESTORED_REQUIREMENT"),false,false,false);
            }
         }
      }
      
      private function onShowFanPage() : void
      {
         var _loc1_:URLRequest = null;
         if(Boolean(this.mContainer) && !this.mContainer.isScrolling)
         {
            if(InstanceMng.getServerConnection().isUserLoggedIn())
            {
               _loc1_ = new URLRequest(Config.getConfig().getFanPageURL());
               navigateToURL(_loc1_);
            }
            else
            {
               Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true,false,false);
            }
         }
      }
      
      private function onShowDiscord() : void
      {
         var _loc1_:URLRequest = null;
         if(Boolean(this.mContainer) && !this.mContainer.isScrolling)
         {
            if(InstanceMng.getServerConnection().isUserLoggedIn())
            {
               _loc1_ = new URLRequest(Config.getConfig().getDiscordURL());
               navigateToURL(_loc1_);
            }
            else
            {
               Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true,false,false);
            }
         }
      }
      
      private function onChangeLanguage() : void
      {
         var _loc1_:Popup = null;
         if(Boolean(this.mContainer) && !this.mContainer.isScrolling)
         {
            _loc1_ = InstanceMng.getPopupMng().getPopupShown();
            if(_loc1_)
            {
               _loc1_.hideTemporarily(InstanceMng.getPopupMng().openChangeLanguagePopup);
            }
            else
            {
               InstanceMng.getPopupMng().openChangeLanguagePopup();
            }
         }
      }
      
      private function createContainer() : void
      {
         if(this.mContainer == null)
         {
            this.mContainer = new ScrollContainer();
         }
         var _loc1_:int = this.mTitleTextfield.y + this.mTitleTextfield.height + 4;
         var _loc2_:VerticalLayout = new VerticalLayout();
         _loc2_.verticalAlign = VerticalAlign.TOP;
         this.mContainer.layout = _loc2_;
         this.mContainer.width = this.mSettingHowToPlay.width;
         this.mContainer.height = mBox.height * 0.925 - _loc1_;
         this.mContainer.x = (mBox.width - this.mSettingHowToPlay.width) / 2;
         this.mContainer.y = _loc1_;
         if(this.mSettingsExit)
         {
            this.mContainer.addChild(this.mSettingsExit);
         }
         this.addSettingsSurrender();
         if(this.mSettingFullScreen)
         {
            this.mContainer.addChild(this.mSettingFullScreen);
         }
         if(this.mSettingAdvancedSettings)
         {
            this.mContainer.addChild(this.mSettingAdvancedSettings);
         }
         addChild(this.mContainer);
      }
      
      private function addSettingsSurrender() : void
      {
         if(this.mContainer)
         {
            if(this.hasToShowSurrender())
            {
               if(Boolean(this.mSettingsSurrender) && !this.mContainer.contains(this.mSettingsSurrender))
               {
                  this.mContainer.addChild(this.mSettingsSurrender);
               }
               if(this.mSettingsSeparator == null)
               {
                  this.createSeparator();
               }
               if(Boolean(this.mSettingsSeparator) && !this.mContainer.contains(this.mSettingsSeparator))
               {
                  this.mContainer.addChildAt(this.mSettingsSeparator,1);
               }
            }
            else
            {
               if(Boolean(this.mSettingsSurrender) && this.mContainer.contains(this.mSettingsSurrender))
               {
                  this.mSettingsSurrender.removeFromParent();
               }
               if(Boolean(this.mSettingsSeparator) && this.mContainer.contains(this.mSettingsSeparator))
               {
                  this.mSettingsSeparator.removeFromParent();
               }
            }
         }
      }
      
      private function createSettingsTopBar() : void
      {
         if(this.mTitleTextfield == null)
         {
            this.mTitleTextfield = new FSTextfield(mBox.width * 0.75,mBox.height * 0.18,TextManager.getText("TID_GEN_GAME_MENU"),16777215,FSResourceMng.FONT_STD_TITLE_SIZE);
            this.mTitleTextfield.fontName = FSResourceMng.getFontByType();
         }
         this.mTitleTextfield.x = (mBox.width - this.mTitleTextfield.width) / 2;
         this.mTitleTextfield.y = mBox.height * 0.065;
         if(this.mSettingsMode == this.MODE_SETTINGS)
         {
            addChild(this.mTitleTextfield);
         }
         else if(this.mTitleTextfield)
         {
            this.mTitleTextfield.removeFromParent();
         }
      }
      
      private function manageBackToSimpleSettingsButton() : void
      {
         if(this.mSettingsMode == this.MODE_SETTINGS_ADVANCED)
         {
            if(Boolean(this.mContainer) && Boolean(this.mContainer.numChildren == 1) && this.mContainer.getChildAt(0) == this.mSettingAdvancedSettings)
            {
               return;
            }
            if(this.mBackToSimpleSettingsButton == null)
            {
               this.mBackToSimpleSettingsButton = new FSButton(Root.assets.getTexture("prev_button"));
               this.mBackToSimpleSettingsButton.addEventListener(Event.TRIGGERED,this.onBackToSimpleSettings);
            }
            this.mBackToSimpleSettingsButton.x = this.mBackToSimpleSettingsButton.width;
            this.mBackToSimpleSettingsButton.y = this.mBackToSimpleSettingsButton.height * 1.2;
            addChild(this.mBackToSimpleSettingsButton);
         }
         else if(this.mBackToSimpleSettingsButton)
         {
            this.mBackToSimpleSettingsButton.removeFromParent();
         }
      }
      
      private function onBackToSimpleSettings() : void
      {
         if(this.mBackToSimpleSettingsButton)
         {
            this.mBackToSimpleSettingsButton.removeFromParent();
         }
         if(this.mAdvancedSettingsContainer)
         {
            this.mAdvancedSettingsContainer.removeChildren();
            this.mAdvancedSettingsContainer.removeFromParent();
         }
         this.mSettingsMode = this.MODE_SETTINGS;
         this.onSettingsModeChanged();
      }
      
      override protected function getBackgroundName(param1:String) : void
      {
         mBGName = Constants.POPUP_SETTINGS_NAME;
      }
      
      override protected function createBackground(param1:String, param2:int = 740) : void
      {
         super.createBackground(param1,param2);
         if(Boolean(mBox) && Config.getConfig().gameHasCustomPopups())
         {
            mBox.scale = Constants.POPUP_SETTINGS_SCALE_FACTOR;
         }
      }
      
      override public function onConnectionChange() : void
      {
         super.onConnectionChange();
         if(this.mSettingFacebookConnect)
         {
            this.mSettingFacebookConnect.setEnabled(Utils.smInternetAvailable);
         }
      }
      
      private function updateAudioButtonsStates() : void
      {
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc1_:Boolean = Utils.isMusicOn();
         var _loc2_:Boolean = Utils.isSFXOn();
         var _loc3_:UserData = Utils.getOwnerUserData();
         var _loc4_:Number = _loc3_ ? _loc3_.flagsGetMusicVolume() : 1;
         var _loc5_:Number = _loc3_ ? _loc3_.flagsGetSoundVolume() : 1;
         var _loc6_:String = _loc3_ ? " " + _loc4_ * 100 + "%" : " (ON)";
         var _loc7_:String = _loc3_ ? " " + _loc5_ * 100 + "%" : " (ON)";
         if(this.mSettingMusicVol != null)
         {
            _loc9_ = _loc1_ ? this.MUSIC_BUTTON_NAME + this.ON_NAME : this.MUSIC_BUTTON_NAME + this.OFF_NAME;
            this.mSettingMusicVol.switchIconImage(_loc9_);
            this.mSettingMusicVol.updateSliderCurrValue(_loc4_);
            _loc8_ = _loc1_ ? _loc6_ : " (OFF)";
            this.mSettingMusicVol.switchName(TextManager.getText("TID_GEN_MUSIC") + _loc8_);
         }
         if(this.mSettingFXVol)
         {
            _loc9_ = _loc2_ ? this.FX_BUTTON_NAME + this.ON_NAME : this.FX_BUTTON_NAME + this.OFF_NAME;
            this.mSettingFXVol.switchIconImage(_loc9_);
            this.mSettingFXVol.updateSliderCurrValue(_loc5_);
            _loc8_ = _loc2_ ? _loc7_ : " (OFF)";
            this.mSettingFXVol.switchName(TextManager.getText("TID_GEN_FX") + _loc8_);
         }
      }
      
      private function updateAPLeftButtonsStates() : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc1_:UserData = Utils.getOwnerUserData();
         if(_loc1_)
         {
            _loc2_ = _loc1_.flagsGetAPLeftWarning();
            if(this.mSettingAPLeft != null)
            {
               _loc4_ = _loc2_ ? this.AP_LEFT_NAME + this.ON_NAME : this.AP_LEFT_NAME + this.OFF_NAME;
               this.mSettingAPLeft.switchIconImage(_loc4_);
               _loc3_ = _loc2_ ? " (ON)" : " (OFF)";
               this.mSettingAPLeft.switchName(TextManager.getText("TID_GEN_APLEFT") + _loc3_);
            }
         }
      }
      
      private function updateFullScreenButtonsState() : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc1_:Boolean = Starling.current.nativeStage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE;
         if(this.mSettingFullScreen != null)
         {
            _loc3_ = _loc1_ ? this.FULL_SCREEN_BUTTON_NAME + this.ON_NAME : this.FULL_SCREEN_BUTTON_NAME + this.OFF_NAME;
            this.mSettingFullScreen.switchIconImage(_loc3_);
            _loc2_ = !_loc1_ ? " (OFF)" : " (ON)";
            this.mSettingFullScreen.switchName(TextManager.getText("TID_GEN_FULL_SCREEN") + _loc2_);
         }
      }
      
      private function createSeparator() : void
      {
         if(this.mSettingsSeparator == null)
         {
            this.mSettingsSeparator = new FSImage(Root.assets.getTexture(this.SEPARATOR_BUTTON_NAME));
         }
      }
      
      private function areMiscButtonsAvailable() : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:BattleEngine = null;
         var _loc4_:Boolean = false;
         var _loc1_:Boolean = false;
         if(Boolean(InstanceMng.getBattleEngine()) && Boolean(InstanceMng.getCurrentScreen()) && InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            _loc2_ = InstanceMng.getBattleEngine().getPlayersStateId();
            _loc3_ = InstanceMng.getBattleEngine();
            if(_loc3_ != null)
            {
               _loc4_ = _loc3_.isPvPMatch() && !_loc3_.isOnlineMatch();
               if(!_loc4_)
               {
                  return _loc2_ == BattleEngine.BATTLE_STATE_PLAYER_MOVING_CARDS;
               }
               _loc1_ = _loc2_ == BattleEngine.BATTLE_STATE_PLAYER_MOVING_CARDS || _loc2_ == BattleEngine.STATE_OPPONENT_MOVING_CARDS;
            }
         }
         else
         {
            _loc1_ = true;
         }
         return _loc1_;
      }
      
      override public function onClose(param1:Event) : void
      {
         super.onClose(param1);
         if(InstanceMng.getUserDataMng())
         {
            InstanceMng.getUserDataMng().updateFlags();
         }
      }
   }
}

