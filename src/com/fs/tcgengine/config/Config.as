package com.fs.tcgengine.config
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.model.rules.ConfigDef;
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.TimerUtil;
   import com.fs.tcgengine.utils.Utils;
   import flash.system.Capabilities;
   
   public class Config
   {
      
      public static var smPvPBotsEnabled:Boolean;
      
      public static var smBattleSendCombatLog:Boolean;
      
      public static var smDayKey:FSNumber;
      
      public static var smWeekNumber:FSNumber;
      
      public static var smMonthNumber:FSNumber;
      
      public static var smYearNumber:FSNumber;
      
      public static var smDefaultDeckValueOffset:int;
      
      public static var smIncreaseDeckValueOffset:int;
      
      public static var smShopManualOffer:Object;
      
      public static var smDungeonsAvailables:String;
      
      public static var smRaidsAvailables:String;
      
      public static var smServerConfig:Object;
      
      public static var smReleaseNotesInfo:String;
      
      public static var smNews:Object;
      
      public static const ENVIRONMENT_DEV:int = 0;
      
      public static const ENVIRONMENT_PROD:int = 1;
      
      public static const ENVIRONMENT_ACTIVE:int = ENVIRONMENT_PROD;
      
      public static var smTextfieldsBorder:Boolean = smIsDebug && false;
      
      public static var smDebugTooltips:Boolean = smIsDebug;
      
      public static const ANIM_SCALE:Number = 2;
      
      public static const FRICTIONLESS_DECK_BUILDER:Boolean = true;
      
      public static const USE_ENCRYPTION:Boolean = true;
      
      public static const HAS_GUILDS:Boolean = true;
      
      public static const ONLY_SERVER_TRACES:Boolean = false;
      
      public static const ONLY_COMBAT_LOG_TRACES:Boolean = false;
      
      public static const IS_BROWSER_LOCAL:Boolean = ENVIRONMENT_ACTIVE == ENVIRONMENT_DEV;
      
      public static const PRODUCTION_BUILD:Boolean = ENVIRONMENT_ACTIVE != ENVIRONMENT_DEV || !Utils.isMobile();
      
      public static const KICKSTARTER_EDITION:Boolean = false;
      
      public static const BETA_EDITION:Boolean = false;
      
      public static const IN_GAME_MAX_ROWS:int = 2;
      
      public static const PVE_MIN_LEVEL_ATTEMPTS_TO_TRIGGER_EASY:int = 4;
      
      public static const PVE_MIN_EASY_RANDOM_CHANCE:int = 9;
      
      public static const PVP_ALLOW_CANCEL_WHILE_SEARCHING:Boolean = false;
      
      public static const HIT_TEST_ACTIVE:Boolean = false;
      
      public static const FORCE_SCALE_1:Boolean = true;
      
      public static const USE_DEATH_ANIM:Boolean = true;
      
      public static const BATTLE_HAS_INTRO:Boolean = true;
      
      public static const LOAD_ABILITIES_ANIMS_ON_DEMAND:Boolean = false;
      
      public static const TRACE_BATTLE_LOGS:Boolean = false;
      
      public static const GAME_NOTIFICATIONS_ENABLED:Boolean = false;
      
      public static const HAS_REFERRAL_ENGINE:Boolean = true;
      
      public static const DURABLE_CONNECTION:Boolean = false;
      
      public static const SKIP_DUPLICATED_RESPONSES:Boolean = true;
      
      public static const STORE_AUDIO_PATHS:Boolean = false;
      
      public static const ANDROID_LOOP_ENDLESS_SOUND:Boolean = false;
      
      public static const USE_CARD_POOLING:Boolean = false;
      
      public static var smDBIgnoreSeasonFilter:Boolean = false;
      
      public static const PVP_SHOW_DECK_VALUE:Boolean = false;
      
      public static const PVP_LEAGUES_ENABLED:Boolean = true;
      
      public static const USE_OFFLINE_DB:Boolean = true;
      
      public static var smRealTimePvP:Boolean = true;
      
      public static var smPvPTurnTime:int = -1;
      
      public static var smPvPWaitingOpponentMoveTime:int = -1;
      
      public static var smPvPPlatformsAvailable:Array = null;
      
      public static var smHackCheatAttemptAutoBan:Boolean = false;
      
      public static var smPvPHasFriendlyPvP:Boolean = true;
      
      public static var smGameSpeedMultiplier:Number = 1;
      
      public static const IDLE_TIME_RELOGIN:int = TimerUtil.secondToMs(45);
      
      public static const IDLE_TIME_DESYNC:int = 30;
      
      public static var smDefaultCombatSpeedFactor:Number = -1;
      
      public static var smIsDebug:Boolean = ENVIRONMENT_ACTIVE == ENVIRONMENT_DEV;
      
      public static var smShowStats:Boolean = false && (smIsDebug || smIsDebug && Capabilities.isDebugger);
      
      public static var smLogsVerboseEnabled:Boolean = !ONLY_SERVER_TRACES && !ONLY_COMBAT_LOG_TRACES;
      
      public static var smShowConsole:Boolean = smIsDebug;
      
      public static const PERFORM_TESTS:Boolean = smIsDebug;
      
      public static var smOfflineLevelRules:Boolean = smIsDebug && false;
      
      public static var smAbilitiesOn:Boolean = true;
      
      public static var smAIAbilitiesOn:Boolean = true;
      
      public static var smLivesSystemEnabled:Boolean = false;
      
      public static var smNotificationsSystemEnabled:Boolean = false;
      
      public static var smPostBoostsEnabled:Boolean = true;
      
      public static var smSilentLoginON:Boolean = true;
      
      public static var smFakeShopOffers:Boolean = KICKSTARTER_EDITION;
      
      public static var smTracklistModeOn:Boolean = true;
      
      public static var smDailyRewardExpires:Boolean = false;
      
      public static var smShowFirsTimeLinkToFBGift:Boolean = true;
      
      public static var smFrictionlessFirstUserXP:Boolean = true;
      
      public static var smEligibleToShowReleaseNotesButton:Boolean = true;
      
      public static var smReferralGoldPerRecruitment:int = 0;
      
      public static var smShowUserRealPortrait:Boolean = false;
      
      public static var smPortraitFramesInAtlas:Boolean = true;
      
      public static var smScreenShotMode:Boolean = false;
      
      public function Config()
      {
         super();
      }
      
      public static function isDebug() : Boolean
      {
         return smIsDebug;
      }
      
      public static function showConsole() : Boolean
      {
         return smShowConsole;
      }
      
      public static function showParticleSystems() : Boolean
      {
         return !Utils.isLowPerformanceDevice();
      }
      
      public static function getConfig() : ConfigDef
      {
         return ConfigDef(InstanceMng.getConfigDefMng().getDefBySku("config_01"));
      }
      
      public static function isSacrificeUnlockedByLevel(param1:int) : Boolean
      {
         var _loc2_:int = getConfig().getLevelToUnlockSacrifice();
         return param1 >= _loc2_;
      }
      
      public static function isPowerUnlockedByLevel(param1:int) : Boolean
      {
         var _loc2_:int = getConfig().getLevelToUnlockPower();
         return param1 >= _loc2_;
      }
      
      public static function isReshuffleUnlockedByLevel(param1:int) : Boolean
      {
         var _loc2_:int = getConfig().getLevelToUnlockReshuffle();
         return param1 >= _loc2_;
      }
      
      public static function isEncryptionOn() : Boolean
      {
         return USE_ENCRYPTION;
      }
      
      public static function allowKeepPlayingAfterDisconnection() : Boolean
      {
         var _loc1_:Boolean = Boolean(InstanceMng.getBattleEngine()) && !InstanceMng.getBattleEngine().isPvPMatch();
         return Boolean(InstanceMng.getBattleEngine()) && !InstanceMng.getServerConnection().wasDualConnectionDetected() && (Root.smBattleData.isDungeon || Root.smBattleData.isRaid || (InstanceMng.getBattleEngine().isPvPMatch() || _loc1_ && Utils.isDesktop()));
      }
   }
}

