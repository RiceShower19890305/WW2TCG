package com.fs.tcgengine.utils
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.DungeonsMng;
   import com.fs.tcgengine.controller.FSFacebookPlugin;
   import com.fs.tcgengine.controller.GuildsMng;
   import com.fs.tcgengine.controller.JobsMng;
   import com.fs.tcgengine.controller.PvPConnectionMng;
   import com.fs.tcgengine.controller.RaidsMng;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.controller.rules.PacksDefMng;
   import com.fs.tcgengine.controller.rules.QuestsDefMng;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.boosts.BoostFillAP;
   import com.fs.tcgengine.model.quests.Quest;
   import com.fs.tcgengine.model.rules.BoostDef;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.GoldDef;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.model.rules.PackDef;
   import com.fs.tcgengine.model.rules.QuestDef;
   import com.fs.tcgengine.model.rules.RarityDef;
   import com.fs.tcgengine.model.rules.RewardDef;
   import com.fs.tcgengine.model.rules.WorldDef;
   import com.fs.tcgengine.model.userdata.UserBattleInfo;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.resources.AssetsParticles;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.screens.FSMapScreen;
   import com.fs.tcgengine.screens.FSRaidsScreen;
   import com.fs.tcgengine.screens.FSShopScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.components.popups.level.SocialScoresBar;
   import com.fs.tcgengine.view.components.popups.quests.QuestCompletePanelInfo;
   import com.fs.tcgengine.view.map.ChooseWorldEffect;
   import com.fs.tcgengine.view.popups.quests.PopupBattlePass;
   import com.fs.tcgengine.view.socket.FSCardSocket;
   import com.greensock.TweenMax;
   import flash.desktop.NativeApplication;
   import flash.events.KeyboardEvent;
   import flash.system.Security;
   import flash.system.SecurityPanel;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import mx.utils.ObjectUtil;
   import starling.core.Starling;
   import starling.display.Quad;
   import starling.display.Sprite3D;
   import starling.events.Event;
   import starling.extensions.ParticleSystem;
   import starling.extensions.lighting.LightSource;
   import starling.extensions.lighting.LightStyle;
   import starling.filters.BlurFilter;
   import starling.utils.Color;
   import starling.utils.deg2rad;
   
   public class CheatConsole
   {
      
      private static var mMemTextures:Dictionary;
      
      private static var mMemSounds:Dictionary;
      
      private static var mRadial:RadialProgressBar;
      
      private static const SAVE:String = "SAVE";
      
      private static const SET_LEVEL:String = "SETLEVEL";
      
      private static const WIN_LEVEL:String = "WIN";
      
      private static const LOSE_LEVEL:String = "LOSE";
      
      private static const ADD_GOLD:String = "ADDGOLD";
      
      private static const ADD_QUEST_COINS:String = "ADDQUESTCOINS";
      
      private static const ADD_RAID_COINS:String = "ADDRAIDCOINS";
      
      private static const ADD_RAID_TICKETS:String = "ADDRAIDTICKETS";
      
      private static const ADD_EXP:String = "ADDEXP";
      
      private static const DECODE:String = "DECODE";
      
      private static const OPPONENT_FOUND:String = "OPPONENTFOUND";
      
      private static const SET_ELO:String = "SETELO";
      
      private static const RESET_PVP:String = "RESET_PVP";
      
      private static const RESET_MATCHES:String = "RESET_MATCHES";
      
      private static const MAX_BOTS:String = "MAX_BOTS";
      
      private static const MAX_MATCHES:String = "MAX_MATCHES";
      
      private static const FORCE_OFFLINE:String = "FORCE_OFFLINE";
      
      private static const AP:String = "AP";
      
      private static const RANDOM:String = "RANDOM";
      
      private static const GOTOLEVEL:String = "GOTO";
      
      private static const GOTODECK:String = "DECK";
      
      private static const GOTOMENU:String = "MENU";
      
      private static const GOTOMAP:String = "MAP";
      
      private static const GOTOPVP:String = "PVP";
      
      private static const GOTODUNGEONS:String = "DUNGEONS";
      
      private static const GOTORAIDS:String = "RAIDS";
      
      private static const GOTOSHOP:String = "SHOP";
      
      private static const GOTOAH:String = "AH";
      
      private static const SOCIAL_BAR:String = "SOCIAL_BAR";
      
      private static const SORT:String = "SORT";
      
      private static const SHAKE:String = "SHAKE";
      
      private static const RATE_APP:String = "RATE";
      
      private static const CREATE_ERROR:String = "ERROR";
      
      private static const CURRENCY:String = "CURRENCY";
      
      private static const LOGOUT:String = "LOGOUT";
      
      private static const GET_FRIENDS_WHO_PLAY:String = "FRIENDS_PLAY";
      
      private static const PROD_ID_TEST:String = "PROD";
      
      private static const POPUP_UNLOCK:String = "POPUP_UNLOCK";
      
      private static const CHAT_MSG:String = "CHAT";
      
      private static const DAILY_REWARD_PACK_POPUP:String = "DAILY_UNFOLD_REWARD";
      
      private static const DAILY_REWARD_POPUP:String = "DAILY_REWARD";
      
      private static const OLD_PLAYER_COMING_BACK_DAILY_REWARD_POPUP:String = "OPCB_DAILY_REWARD";
      
      private static const RESTORE_PURCHASES:String = "RESTORE_PURCHASES";
      
      private static const PACK_TEST:String = "PACK_TEST";
      
      private static const MULTI_PACK_TEST:String = "MULTI_PACK_TEST";
      
      private static const VICTORY_ANIM:String = "V";
      
      private static const LOSE_ANIM:String = "L";
      
      private static const MIN_GOLD_GAINED:String = "30CARDS";
      
      private static const ADD_ALL_CARDS:String = "ADD_ALL_CARDS";
      
      private static const ADD_CARDS:String = "ADD_CARDS";
      
      private static const REMOVE_CARDS:String = "REMOVE_CARDS";
      
      private static const ADD_CARDS_TO_DECK:String = "ADD_CARDS_TO_DECK";
      
      private static const CHANGE_LOCALE:String = "LOCALE";
      
      private static const CHANGE_LANGUAGE_POPUP:String = "CHANGE_LANGUAGE";
      
      private static const CALC_REW:String = "REWARD";
      
      private static const GUILDS_POPUP:String = "GUILDS";
      
      private static const FAKE_WIN_PVP_COMMAND:String = "WIN_PVP";
      
      private static const FAKE_LOSE_PVP_COMMAND:String = "LOSE_PVP";
      
      private static const FAKE_WIN_DUN_EASY_COMMAND:String = "WIN_DUN_EASY";
      
      private static const FAKE_WIN_DUN_MED_COMMAND:String = "WIN_DUN_MED";
      
      private static const FAKE_WIN_DUN_HARD_COMMAND:String = "WIN_DUN_HARD";
      
      private static const OFFLINE:String = "OFFLINE";
      
      private static const ELO_WIN:String = "ELO_WIN";
      
      private static const ELO_LOST:String = "ELO_LOST";
      
      private static const GETME:String = "GETME";
      
      private static const USEDFREEBOOST:String = "USED_FREE_BOOST";
      
      private static const SHOW_ADD:String = "SHOW_AD";
      
      private static const SHOW_VIP_PACK_POPUP:String = "VIP_PACK";
      
      private static const ROLL_NON_PAYER_ACTION:String = "ROLL_NON_PAYER";
      
      private static const GET_UNLOCKED_QUESTS:String = "GETQUESTS";
      
      private static const RESET_QUESTS:String = "RESETQUESTS";
      
      private static const QUEST_COMPLETE_PANEL_INFO:String = "QUESTPANEL";
      
      private static const CONTEXT_LOSS:String = "CONTEXTLOSS";
      
      private static const COMPLETE_QUEST:String = "COMPLETEQ";
      
      private static const COMPLETE_ALLQUEST:String = "COMPLETEALLQ";
      
      private static const RESET_TICKETS_RAIDS:String = "RESETRAIDTICKETS";
      
      private static const RESET_TICKETS_RAIDS_SP:String = "RESETSPRAIDTICKETS";
      
      private static const RESET_TICKETS_RAIDS_MP:String = "RESETMPRAIDTICKETS";
      
      private static const RESET_PLAYER:String = "RESET";
      
      private static const MIGRATE_PLAYER_BROWSER:String = "MIGRATE_BROWSER";
      
      private static const MIGRATE_PLAYER_DESKTOP:String = "MIGRATE_DESKTOP";
      
      private static const PRINT_ID:String = "PRINT_ID";
      
      private static const RESET_3D_CAM:String = "RESET_3D_CAM";
      
      private static const CLEAN_DDBB:String = "CLEAN_DDBB";
      
      private static const HIT_RAID_BOSS:String = "HIT_BOSS";
      
      private static const HIT_MYSELF:String = "HIT_MYSELF";
      
      private static const CALCULATE_PVP_DECK_VALUE:String = "PVP_DECK_VALUE";
      
      private static const CALCULATE_DECK_VALUE:String = "DECK_VALUE";
      
      private static const ENQUEUE_IN_PVP:String = "ENQUEUE_IN_PVP";
      
      private static const ADD_GUILD_POINTS:String = "ADD_GUILD_POINTS";
      
      private static const GUILD_RAID_COMPLETED_EVENT:String = "GUILD_RAID_COMPLETED_EVENT";
      
      private static const GUILD_REWARD_GOLD:String = "GUILD_REWARD_GOLD";
      
      private static const TEST_RESTORE:String = "RESTORE";
      
      private static const ADD_AH_TOKENS:String = "ADDAHTOKENS";
      
      private static const SET_DECK_CARDS_AMOUNT:String = "SETCARDS";
      
      private static const TRIGGER_GC:String = "GC";
      
      private static const JOB_LEVEL_UP:String = "JOB";
      
      private static const JOB_RESET:String = "JOB_RESET";
      
      private static const TEST_LEADERBOARD:String = "ADD_LB_SCORE";
      
      private static const ADD_JOB_EXP:String = "ADD_JOB_EXP";
      
      private static const SHARE_CARD:String = "SHARE_CARD";
      
      private static const PUSH_TEST:String = "PUSH";
      
      private static const DEVICE:String = "DEVICE";
      
      private static const ADD_JOB_REWARD:String = "JOBREWARD";
      
      private static const TEST_INTRO:String = "INTRO";
      
      private static const BREAK_PVP:String = "BREAKPVP";
      
      private static const REAL_TIME_PVP_TEST:String = "Q";
      
      private static const SCORE:String = "SCORE";
      
      private static const FAKE_BATTLEPASS_PURCHASE:String = "FAKE_BP";
      
      private static const FAKE_BATTLEPASS_CLEAN:String = "CLEAN_BP";
      
      private static const STARS:String = "STARS";
      
      private static const RESHUFFLE:String = "SHUFFLE";
      
      private static const FILLAP:String = "FILLAP";
      
      private static const NEWCARDS:String = "NEWCARDS";
      
      private static const BLOOD:String = "BLOOD";
      
      private static const RESET_WORLD:String = "RESET_WORLD";
      
      private static const CHOOSE_WORLD:String = "CHOOSE_WORLD";
      
      private static const RAND:String = "RAND";
      
      private static const MEMORY:String = "MEM";
      
      private static const TEST_BACK:String = "BACK";
      
      private static const DRAG_MAP:String = "DRAG";
      
      private static const FAKE_DOUBLE_SESSION:String = "FAKE_DOUBLE_SESSION";
      
      private static const PENDING_PURCHASES:String = "PENDING";
      
      private static const BG_EXECUTION:String = "BG_EXEC";
      
      private static const TEST_SHOP_PURCHASE:String = "TEST_SHOP_PURCHASE";
      
      private static const PAYING_USER:String = "PAYING_USER";
      
      private static const RESET_DAILY:String = "RESET_DAILY";
      
      private static const PRINT_PVP_DATA:String = "PRINT_PVP";
      
      private static const PRINT_CARDS_DESC:String = "PRINT_CARDS_DESC";
      
      private static const TEST_LOCAL_PUSH:String = "LPUSH";
      
      private static const START_TEST:String = "START_TEST";
      
      private static const INVITE_FRIENDS_POPUP:String = "INVITE_FRIENDS";
      
      private static const FORCE_CONNECTION_KO:String = "KO";
      
      private static const UNZIP:String = "UNZIP";
      
      private static const FLASH:String = "FLASH";
      
      private static const FAKE_SEASON:String = "FAKE_SEASON";
      
      private static const GET_BP_REWARDS:String = "GET_BP_REWARDS";
      
      private static const DAY_RESET:String = "DAY_RESET";
      
      private static const DB_IGNORE_SEASON_FILTER:String = "DB_IGNORE_SEASON_FILTER";
      
      private static const FILL_AP:String = "FILL_AP";
      
      private static const RECOVER_ACCOUNT:String = "RECOVER_ACCOUNT";
      
      private static const CHECK_ACH:String = "CHECK_ACH";
      
      private static const CHECK_STAT:String = "CHECK_STAT";
      
      private static const CLEAR_ACH:String = "CLEAR_ACH";
      
      private static const SET_STAT:String = "SET_STAT";
      
      private static const RESET_STATS_AND_ACH:String = "RESET_STATS_AND_ACH";
      
      private static const RAID_READY:String = "RAID_READY";
      
      private static const PRINT_BOT_DV:String = "PRINT_BOTS";
      
      private static const ROT:String = "ROT";
      
      private static const TEST3D:String = "TEST3D";
      
      private static const NEWSEASON:String = "NEWSEASON";
      
      private static const TEST_PARTICLE:String = "TEST_PARTICLE";
      
      private static const REFRESH_OFFERS:String = "REFRESH_OFFERS";
      
      private static const LOAD_MAP:String = "LOAD_MAP";
      
      private static const MAP_SELECTOR:String = "MAP_SELECTOR";
      
      private static const CREATE_LIGHT:String = "CREATE_LIGHT";
      
      private static const LIGHTS:String = "LIGHTS";
      
      private static const LAUNCH_BOT:String = "LAUNCH_BOT";
      
      private static const CHECK_BOTS:String = "CHECK_BOTS";
      
      private static const RADIAL:String = "RADIAL";
      
      private static const SHOW_OPPONENT_CARDS_DECK:String = "SHOW_OPPONENT_CARDS_DECK";
      
      private static const MONTHLY:String = "MONTHLY";
      
      private static const INCR_DUNGEONS_PLAYED:String = "INCR_DUNGEONS_PLAYED";
      
      private static const TEST_FIREBASE_DB:String = "TEST_FIREBASE_DB";
      
      private static const TEST_FIREBASE_PWD:String = "TEST_FIREBASE_PWD";
      
      private static const FORCE_COMBAT_LOG:String = "FORCE_COMBAT_LOG";
      
      private static const SCREENSHOT_MODE:String = "SCREENSHOT_MODE";
      
      public function CheatConsole()
      {
         super();
      }
      
      private static function doAction(param1:String) : void
      {
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc7_:LevelDef = null;
         var _loc8_:PackDef = null;
         var _loc9_:UserData = null;
         var _loc10_:Number = NaN;
         var _loc11_:int = 0;
         var _loc12_:QuestDef = null;
         var _loc13_:Array = null;
         var _loc14_:int = 0;
         var _loc15_:String = null;
         var _loc16_:Object = null;
         var _loc17_:SocialScoresBar = null;
         var _loc18_:Dictionary = null;
         var _loc19_:Array = null;
         var _loc20_:FSCard = null;
         var _loc21_:Number = NaN;
         var _loc22_:uint = 0;
         var _loc23_:String = null;
         var _loc24_:Boolean = false;
         var _loc25_:String = null;
         var _loc26_:Array = null;
         var _loc27_:String = null;
         var _loc28_:int = 0;
         var _loc29_:String = null;
         var _loc30_:String = null;
         var _loc31_:int = 0;
         var _loc32_:String = null;
         var _loc33_:int = 0;
         var _loc34_:int = 0;
         var _loc35_:Boolean = false;
         var _loc36_:String = null;
         var _loc37_:String = null;
         var _loc38_:String = null;
         var _loc39_:Def = null;
         var _loc40_:QuestCompletePanelInfo = null;
         var _loc41_:Dictionary = null;
         var _loc42_:FSBattleScreen = null;
         var _loc43_:FSBattleScreen = null;
         var _loc44_:int = 0;
         var _loc45_:GoldDef = null;
         var _loc46_:int = 0;
         var _loc47_:int = 0;
         var _loc48_:int = 0;
         var _loc49_:String = null;
         var _loc50_:int = 0;
         var _loc51_:int = 0;
         var _loc52_:BoostFillAP = null;
         var _loc53_:WorldDef = null;
         var _loc54_:WorldDef = null;
         var _loc55_:ChooseWorldEffect = null;
         var _loc56_:Dictionary = null;
         var _loc57_:int = 0;
         var _loc58_:int = 0;
         var _loc59_:int = 0;
         var _loc60_:int = 0;
         var _loc61_:Array = null;
         var _loc62_:Array = null;
         var _loc63_:Dictionary = null;
         var _loc64_:int = 0;
         var _loc65_:int = 0;
         var _loc66_:String = null;
         var _loc67_:Vector.<QuestDef> = null;
         var _loc68_:UserBattleInfo = null;
         var _loc69_:BattleEngine = null;
         var _loc70_:Sprite3D = null;
         var _loc71_:Quad = null;
         var _loc72_:ParticleSystem = null;
         var _loc73_:int = 0;
         var _loc74_:int = 0;
         var _loc75_:LightStyle = null;
         var _loc76_:LightSource = null;
         var _loc77_:LightSource = null;
         var _loc78_:Boolean = false;
         var _loc79_:String = null;
         var _loc80_:int = 0;
         var _loc81_:int = 0;
         var _loc82_:Boolean = false;
         var _loc83_:Boolean = false;
         var _loc84_:Boolean = false;
         var _loc85_:String = null;
         var _loc86_:String = null;
         var _loc87_:FSFacebookPlugin = null;
         var _loc88_:Array = null;
         var _loc89_:int = 0;
         var _loc90_:Def = null;
         var _loc91_:String = null;
         var _loc92_:FSCardSocket = null;
         var _loc93_:FSCard = null;
         var _loc94_:Dictionary = null;
         var _loc2_:Array = param1.split(" ");
         var _loc3_:String = _loc2_[0].toUpperCase();
         _loc4_ = _loc2_[1];
         _loc5_ = _loc2_.slice(1);
         var _loc6_:Screen = InstanceMng.getCurrentScreen();
         _loc9_ = Utils.getOwnerUserData();
         if(_loc9_ == null)
         {
            return;
         }
         if(_loc6_ is FSBattleScreen)
         {
            _loc7_ = FSBattleScreen(_loc6_).getBattleEngine().getLevelDef();
         }
         else
         {
            _loc7_ = LevelDef(InstanceMng.getLevelsDefMng().getDefBySku("level_10"));
         }
         switch(_loc3_)
         {
            case SAVE:
               save();
               break;
            case SET_LEVEL:
               _loc14_ = _loc9_.getCurrentDifficulty();
               switch(_loc14_)
               {
                  case UserDataMng.DIFFICULTY_EASY:
                     _loc9_.setCurrentLevelSku("level_" + Utils.transformValueToString(_loc4_.toString(),2));
                     break;
                  case UserDataMng.DIFFICULTY_MEDIUM:
                     _loc9_.setCurrentLevelMediumSku("level_" + Utils.transformValueToString(_loc4_.toString(),2));
                     break;
                  case UserDataMng.DIFFICULTY_HARD:
                     _loc9_.setCurrentLevelHardSku("level_" + Utils.transformValueToString(_loc4_.toString(),2));
                     break;
                  default:
                     _loc9_.setCurrentLevelSku("level_" + Utils.transformValueToString(_loc4_.toString(),2));
               }
               InstanceMng.getQuestsMng().resetQuestsMng();
               save();
               if(InstanceMng.getCurrentScreen() is FSMapScreen)
               {
                  InstanceMng.getCurrentScreen().dispatchEventWith(Screen.GO_TO_MAP,true);
               }
               break;
            case VICTORY_ANIM:
               if(FSBattleScreen(_loc6_) != null)
               {
                  FSBattleScreen(_loc6_).createVictoryAnimation(int(_loc4_));
               }
               break;
            case LOSE_ANIM:
               if(FSBattleScreen(_loc6_) != null)
               {
                  FSBattleScreen(_loc6_).createDefeatAnimation(int(_loc4_));
               }
               break;
            case MIN_GOLD_GAINED:
               InstanceMng.getPopupMng().openMinimumGoldAchievedPopup();
               break;
            case WIN_LEVEL:
               if(_loc6_ is FSBattleScreen)
               {
                  InstanceMng.getBattleEngine().onBattleOver(true);
               }
               break;
            case LOSE_LEVEL:
               if(_loc6_ is FSBattleScreen)
               {
                  InstanceMng.getBattleEngine().onBattleOver(false,true);
               }
               break;
            case ADD_GOLD:
               if(Number(_loc4_) > 0)
               {
                  _loc9_.addGold(Number(_loc4_));
               }
               else
               {
                  _loc9_.substractGold(Number(_loc4_));
               }
               InstanceMng.getUserDataMng().updateGold();
               break;
            case ADD_QUEST_COINS:
               if(Number(_loc4_) > 0)
               {
                  _loc9_.addQuestsCoins(Number(_loc4_));
               }
               else
               {
                  _loc9_.substractQuestsCoins(Number(_loc4_));
               }
               InstanceMng.getUserDataMng().updateQuestsCoins();
               break;
            case ADD_RAID_COINS:
               if(Number(_loc4_) > 0)
               {
                  _loc9_.addRaidCoins(Number(_loc4_));
               }
               else
               {
                  _loc9_.substractRaidCoins(Number(_loc4_));
               }
               InstanceMng.getUserDataMng().updateRaidCoins();
               break;
            case ADD_EXP:
               _loc9_.addExp(Number(_loc4_));
               InstanceMng.getUserDataMng().updateExp();
               break;
            case DECODE:
               _loc15_ = "{\"_id\":\"520b69d4e4b0f9b62a19b312\",\"u2\":{\"uid\":\"51fbb531e4b09c8c81aa795c\",\"nick\":\"Christian\"},\"u1\":{\"uid\":\"520a40e7e4b09c8c81aa7c0d\",\"nick\":\"test12\"},\"a\":\"accept\",\"_acl\":{\"owner\":\"51fbb531e4b09c8c81aa795c\",\"mode\":0}}";
               _loc16_ = Utils.parseJSONData(_loc15_);
               break;
            case OPPONENT_FOUND:
               InstanceMng.getPopupMng().openOpponentFoundPopup("1",{},"");
               break;
            case AP:
               InstanceMng.getBattleEngine().getOwnerBattleInfo().setActionPointsLeft(3);
               break;
            case RANDOM:
               FSDebug.debugTrace("Random value: " + Utils.randomInt(0,2));
               break;
            case GOTOLEVEL:
               InstanceMng.getCurrentScreen().startBattle("level_" + String(_loc4_),false);
               break;
            case GOTODECK:
               InstanceMng.getCurrentScreen().dispatchEventWith(Screen.GO_TO_DECK_BUILDER,true);
               break;
            case GOTOMENU:
               InstanceMng.getCurrentScreen().dispatchEventWith(Screen.GO_TO_MENU,true);
               break;
            case GOTOMAP:
               InstanceMng.getCurrentScreen().dispatchEventWith(Screen.GO_TO_MAP,true);
               break;
            case GOTOPVP:
               InstanceMng.getCurrentScreen().dispatchEventWith(Screen.GO_TO_PVP,true);
               break;
            case GOTOSHOP:
               InstanceMng.getCurrentScreen().dispatchEventWith(Screen.GO_TO_SHOP,true);
               break;
            case GOTODUNGEONS:
               InstanceMng.getCurrentScreen().dispatchEventWith(Screen.GO_TO_DUNGEONS,true);
               break;
            case GOTORAIDS:
               InstanceMng.getCurrentScreen().dispatchEventWith(Screen.GO_TO_RAIDS,true);
               break;
            case GOTOAH:
               InstanceMng.getCurrentScreen().dispatchEventWith(Screen.GO_TO_AUCTIONS,true);
               break;
            case SOCIAL_BAR:
               _loc17_ = new SocialScoresBar(new LevelDef());
               InstanceMng.getCurrentScreen().addChild(_loc17_);
               break;
            case SORT:
               _loc18_ = new Dictionary(true);
               _loc18_["a"] = 3;
               _loc18_["b"] = 15;
               _loc18_["c"] = 2;
               _loc18_["d"] = 0;
               _loc18_["z"] = 1;
               _loc18_["h"] = 0;
               _loc19_ = DictionaryUtils.sortDictionaryByValue(_loc18_);
               break;
            case SHAKE:
               Utils.requestScreenShake(1,Number(_loc5_[0]));
               break;
            case RATE_APP:
               InstanceMng.getPopupMng().openRateAppPopup();
               break;
            case CREATE_ERROR:
               _loc20_ = null;
               _loc20_.addAbility(null);
               break;
            case CURRENCY:
               _loc21_ = Number(String("4,69").replace(",","."));
               _loc22_ = uint(_loc21_ * 100);
               FSDebug.debugTrace("c: " + _loc22_.toString());
               break;
            case LOGOUT:
               if(InstanceMng.getPopupMng().getPopupShown())
               {
                  InstanceMng.getPopupMng().getPopupShown().hideTemporarily(InstanceMng.getPopupMng().openLogoutFromFBPopup);
               }
               else
               {
                  _loc87_ = InstanceMng.getFacebookPlugin();
                  if(_loc87_ != null)
                  {
                     _loc87_.logout();
                  }
               }
               break;
            case PROD_ID_TEST:
               InstanceMng.getApplication().getInAppsManager().addProductByProdId(Config.getConfig().getAppNameSpace() + ".packs.PACK_VIP");
               break;
            case CHAT_MSG:
               _loc23_ = "This is a very long chat test, and stuff";
               _loc24_ = _loc9_.flagsChatOn();
               if((_loc24_) && InstanceMng.getBattleEngine() != null && InstanceMng.getBattleEngine().isOnlineMatch())
               {
                  Utils.playSound(Constants.SOUND_CHAT,SoundManager.TYPE_SFX);
                  InstanceMng.getBattleEngine().getOpponentBattleInfo().getUserBattlePortrait().showMessage(_loc23_);
               }
            case DAILY_REWARD_PACK_POPUP:
               _loc8_ = PackDef(InstanceMng.getPacksDefMng().getDefBySku("pack_24"));
               if(_loc8_)
               {
                  Utils.openPack(_loc8_,PacksDefMng.PACK_DAILY_REWARDS);
               }
               break;
            case DAILY_REWARD_POPUP:
               InstanceMng.getUserDataMng().openDailyRewardsPopup(false);
               break;
            case OLD_PLAYER_COMING_BACK_DAILY_REWARD_POPUP:
               InstanceMng.getUserDataMng().openDailyRewardsPopup(true);
               break;
            case MULTI_PACK_TEST:
               _loc25_ = "";
               _loc26_ = Boolean(_loc5_) && Boolean(_loc5_[0]) ? _loc5_[0].split(",") : null;
               if(_loc26_ != null && _loc26_.length > 0)
               {
                  _loc89_ = 0;
                  while(_loc89_ < _loc26_.length)
                  {
                     _loc88_ = _loc26_[_loc89_].split(":");
                     _loc25_ += "\n" + testPack(_loc88_[0],_loc88_[1]);
                     _loc89_++;
                  }
                  FSDebug.debugTrace(_loc25_);
               }
               break;
            case PACK_TEST:
               _loc27_ = Boolean(_loc5_) && Boolean(_loc5_[0]) ? _loc5_[0] : "";
               _loc28_ = Boolean(_loc5_) && Boolean(_loc5_[1]) ? int(_loc5_[1]) : 100;
               _loc29_ = testPack(_loc27_,_loc28_);
               FSDebug.debugTrace(_loc29_);
               break;
            case CALC_REW:
               InstanceMng.getDungeonsMng().testRewards();
               break;
            case ADD_ALL_CARDS:
               _loc30_ = String(_loc4_) != null && String(_loc4_) != "" ? String(_loc4_) : "";
               Utils.godModeAddAllCardsToCollection(_loc30_);
               break;
            case ADD_CARDS:
               Utils.godModeAddCardsToCollection(_loc4_);
               break;
            case REMOVE_CARDS:
               Utils.godModeRemoveCardsToCollection(_loc4_);
               break;
            case ADD_CARDS_TO_DECK:
               _loc31_ = Boolean(_loc5_) && Boolean(_loc5_[0]) ? int(_loc5_[0]) : -1;
               _loc32_ = Boolean(_loc5_) && Boolean(_loc5_[1]) ? _loc5_[1] : "";
               if(_loc31_ != -1 && _loc32_ != "")
               {
                  Utils.godModeAddCardsToDeck(_loc31_,_loc32_);
               }
               else
               {
                  FSDebug.debugTrace("Deck index and cards string must not be empty");
               }
               break;
            case CHANGE_LOCALE:
               TextManager.loadLang(_loc4_);
               break;
            case CHANGE_LANGUAGE_POPUP:
               InstanceMng.getPopupMng().openChangeLanguagePopup();
               break;
            case GUILDS_POPUP:
               InstanceMng.getPopupMng().openGuildsPopup();
               break;
            case FAKE_WIN_PVP_COMMAND:
            case FAKE_LOSE_PVP_COMMAND:
               PvPConnectionMng.smEloBeforeStartingMatch = _loc9_.getElo();
               _loc33_ = Utils.randomInt(_loc9_.getElo() - 200,_loc9_.getElo() + 200);
               _loc11_ = PvPConnectionMng.getEloIfMatchLost(_loc33_);
               PvPConnectionMng.smCurrentMatchEloLostIfMatchLost = _loc11_;
               PvPConnectionMng.smLeagueBeforeStartingMatch = _loc9_.getPvPCurrentLeague();
               _loc34_ = PvPConnectionMng.getLeagueByELO(_loc11_,PvPConnectionMng.smLeagueBeforeStartingMatch);
               if(_loc34_ != 0)
               {
                  _loc9_.setPvPCurrentLeague(_loc34_);
               }
               _loc9_.setElo(_loc11_);
               if(param1 == FAKE_WIN_PVP_COMMAND || param1 == FAKE_WIN_PVP_COMMAND.toLowerCase())
               {
                  PvPConnectionMng.onPvPMatchWon(_loc33_,"");
               }
               save();
               break;
            case FAKE_WIN_DUN_EASY_COMMAND:
               if(Config.HAS_GUILDS && _loc9_.hasGuild())
               {
                  _loc10_ = InstanceMng.getGuildsMng().getDungeonCompletedPointsWon(DungeonsMng.DUNGEON_DIFFICULTY_EASY);
                  _loc9_.addGuildWeeklyDungeonScore(_loc10_);
                  FSDebug.debugTrace("[FAKE DUN EASY WON] Guild points earned: " + _loc10_);
                  InstanceMng.getGuildsMng().createGuildDungeonCompletedEvent(DungeonsMng.DUNGEON_DIFFICULTY_EASY);
               }
               break;
            case FAKE_WIN_DUN_MED_COMMAND:
               if(Config.HAS_GUILDS && _loc9_.hasGuild())
               {
                  _loc10_ = InstanceMng.getGuildsMng().getDungeonCompletedPointsWon(DungeonsMng.DUNGEON_DIFFICULTY_MEDIUM);
                  _loc9_.addGuildWeeklyDungeonScore(_loc10_);
                  InstanceMng.getGuildsMng().createGuildDungeonCompletedEvent(DungeonsMng.DUNGEON_DIFFICULTY_MEDIUM);
                  FSDebug.debugTrace("[FAKE DUN MED WON] Guild points earned: " + _loc10_);
               }
               break;
            case FAKE_WIN_DUN_HARD_COMMAND:
               if(Config.HAS_GUILDS && _loc9_.hasGuild())
               {
                  _loc10_ = InstanceMng.getGuildsMng().getDungeonCompletedPointsWon(DungeonsMng.DUNGEON_DIFFICULTY_HARD);
                  _loc9_.addGuildWeeklyDungeonScore(_loc10_);
                  InstanceMng.getGuildsMng().createGuildDungeonCompletedEvent(DungeonsMng.DUNGEON_DIFFICULTY_HARD);
                  FSDebug.debugTrace("[FAKE DUN HARD WON] Guild points earned: " + _loc10_);
               }
               break;
            case OFFLINE:
               Main.smGamePlayable = true;
               if(InstanceMng.getCurrentScreen())
               {
                  InstanceMng.getCurrentScreen().onConnectionChange();
               }
               break;
            case ELO_WIN:
               _loc9_.setElo(1000,true);
               InstanceMng.getServerConnection().addScoreToLeaderboard("PLAYER_PVP",1000,_loc9_.getMatchesWon(),_loc9_.getPvPCurrentLeague(),_loc9_.getPvPBestLeague());
               break;
            case SET_ELO:
               _loc9_.setElo(int(_loc4_),true);
               InstanceMng.getServerConnection().addScoreToLeaderboard("PLAYER_PVP",int(_loc4_),_loc9_.getMatchesWon(),_loc9_.getPvPCurrentLeague(),_loc9_.getPvPBestLeague());
               save();
               InstanceMng.getCurrentScreen().dispatchEventWith(Screen.GO_TO_PVP,true);
               break;
            case RESET_PVP:
               _loc9_.setPvPCurrentLeague(3);
               _loc9_.setPvPBestLeague(3);
               _loc9_.setElo(1000);
               _loc9_.setBotsPlayedSession(0);
               _loc9_.setMatchesLost(0);
               _loc9_.setMatchesWon(0);
               _loc9_.setMatchesPlayed(0);
               save();
               InstanceMng.getCurrentScreen().dispatchEventWith(Screen.GO_TO_PVP,true);
               break;
            case RESET_MATCHES:
               _loc9_.setBotsPlayedSession(0);
               _loc9_.setMatchesLost(0);
               _loc9_.setMatchesWon(0);
               _loc9_.setMatchesPlayed(0);
               save();
               InstanceMng.getCurrentScreen().dispatchEventWith(Screen.GO_TO_PVP,true);
               break;
            case MAX_BOTS:
               _loc9_.setBotsPlayedSession(100);
               _loc9_.setMatchesLost(100);
               _loc9_.setMatchesWon(100);
               _loc9_.setMatchesPlayed(100);
               save();
               InstanceMng.getCurrentScreen().dispatchEventWith(Screen.GO_TO_PVP,true);
               break;
            case MAX_MATCHES:
               _loc9_.setMatchesLost(100);
               _loc9_.setMatchesWon(100);
               _loc9_.setMatchesPlayed(100);
               save();
               InstanceMng.getCurrentScreen().dispatchEventWith(Screen.GO_TO_PVP,true);
               break;
            case FORCE_OFFLINE:
               _loc9_.setMatchesLost(100);
               _loc9_.setMatchesWon(100);
               _loc9_.setMatchesPlayed(100);
               _loc9_.setBotsPlayedSession(0);
               _loc9_.setPvPCurrentLeague(2);
               _loc9_.setElo(1750);
               save();
               break;
            case ELO_LOST:
               _loc11_ = PvPConnectionMng.getEloIfMatchLost(Number(_loc4_));
               break;
            case GETME:
               InstanceMng.getServerConnection().createProfileObject(false);
               break;
            case USEDFREEBOOST:
               _loc35_ = _loc9_.flagsGetUsedFreeBoost();
               _loc9_.setUsedFreeBoost(!_loc35_);
               FSDebug.debugTrace("Used Free Boost set to: " + String(!_loc35_));
               break;
            case SHOW_ADD:
               break;
            case SHOW_VIP_PACK_POPUP:
               _loc36_ = !Utils.isBrowser() ? Config.getConfig().getAppNameSpace() : "";
               _loc37_ = !Utils.isBrowser() ? "." : "";
               _loc38_ = InstanceMng.getApplication().isKongregateVersion() ? "packs-PACK_VIP" : "packs.PACK_VIP";
               if(Config.getConfig().getGameVipOfferGold())
               {
                  _loc39_ = GoldDef(InstanceMng.getGoldDefMng().getDefByProdId(_loc36_ + _loc37_ + _loc38_));
               }
               else
               {
                  _loc39_ = PackDef(InstanceMng.getPacksDefMng().getDefByProdId(_loc36_ + _loc37_ + _loc38_));
               }
               InstanceMng.getPopupMng().openBuyVIPPackPopup(_loc39_);
               break;
            case ROLL_NON_PAYER_ACTION:
               InstanceMng.getApplication().getInAppsManager().rollNonPayerNextAction();
               break;
            case GET_UNLOCKED_QUESTS:
               InstanceMng.getQuestsMng().getQuestsUnlocked();
               break;
            case RESET_QUESTS:
               _loc9_.godModeResetQuests(true);
               break;
            case QUEST_COMPLETE_PANEL_INFO:
               _loc12_ = QuestDef(InstanceMng.getQuestsDefMng().getDefBySku("quest_01"));
               _loc40_ = new QuestCompletePanelInfo(new Quest(_loc12_));
               _loc40_.x = Starling.current.stage.stageWidth / 2;
               _loc40_.y = _loc40_.height / 2;
               InstanceMng.getCurrentScreen().addChild(_loc40_);
               _loc40_.showPanel();
               break;
            case CONTEXT_LOSS:
               Starling.context.dispose(false);
               setTimeout(makeTextField,1000);
               break;
            case COMPLETE_QUEST:
               _loc12_ = QuestDef(InstanceMng.getQuestsDefMng().getDefBySku(_loc4_));
               _loc13_ = _loc12_.getTargetExtraInfo() != "" && _loc12_.getTargetExtraInfo() != null ? _loc12_.getTargetExtraInfo().split(",") : null;
               if(!_loc12_.isBattlePassQuest() || _loc12_.isBattlePassQuest() && _loc12_.isBattlePassQuestEligibleBySeason())
               {
                  InstanceMng.getQuestsMng().addActionPerformed(_loc12_.getTargetType(),_loc12_.getTargetAmount(),true,[_loc12_.getTargetExtraInfo()],_loc12_.getTargetLevelSku(),_loc12_.getTargetSku(),_loc12_.getTargetDifficulty());
                  save();
               }
               break;
            case COMPLETE_ALLQUEST:
               _loc41_ = InstanceMng.getQuestsDefMng().getAllDefs();
               if(_loc41_)
               {
                  for each(_loc12_ in _loc41_)
                  {
                     if(_loc12_)
                     {
                        if(!_loc12_.isBattlePassQuest() || _loc12_.isBattlePassQuest() && _loc12_.isBattlePassQuestEligibleBySeason())
                        {
                           _loc13_ = _loc12_.getTargetExtraInfo() != "" && _loc12_.getTargetExtraInfo() != null ? _loc12_.getTargetExtraInfo().split(",") : null;
                           InstanceMng.getQuestsMng().addActionPerformed(_loc12_.getTargetType(),_loc12_.getTargetAmount(),false,_loc13_,_loc12_.getTargetLevelSku(),_loc12_.getTargetSku(),_loc12_.getTargetDifficulty());
                        }
                     }
                  }
               }
               save();
               break;
            case ADD_RAID_TICKETS:
               if(int(_loc4_) > 0)
               {
                  _loc9_.addRaidTicketsSP(int(_loc4_));
                  _loc9_.addRaidTicketsMP(int(_loc4_));
               }
               else
               {
                  _loc9_.substractRaidTicketsSP(int(_loc4_));
                  _loc9_.substractRaidTicketsMP(int(_loc4_));
               }
               break;
            case RESET_TICKETS_RAIDS:
               _loc9_.addRaidTicketsSP(4);
               _loc9_.addRaidTicketsMP(4);
               break;
            case RESET_TICKETS_RAIDS_SP:
               _loc9_.addRaidTicketsSP(Config.getConfig().getRaidTicketsSinglePlayer().value);
               _loc6_ = InstanceMng.getCurrentScreen() as FSRaidsScreen;
               if(_loc6_)
               {
                  FSRaidsScreen(_loc6_).updateTicketsRaidSingleplayerTextfield(true);
               }
               break;
            case RESET_TICKETS_RAIDS_MP:
               _loc9_.addRaidTicketsMP(Config.getConfig().getRaidTicketsMultiPlayer().value);
               _loc6_ = InstanceMng.getCurrentScreen() as FSRaidsScreen;
               if(_loc6_)
               {
                  FSRaidsScreen(_loc6_).updateTicketsRaidMultiplayerTextfield(true);
               }
               break;
            case RESET_PLAYER:
               InstanceMng.getUserDataMng().resetPlayer();
               break;
            case MIGRATE_PLAYER_BROWSER:
               InstanceMng.getPopupMng().openGetTansferCodePopup();
               break;
            case MIGRATE_PLAYER_DESKTOP:
               InstanceMng.getPopupMng().openRedeemTransferCodePopup();
               break;
            case PRINT_ID:
               FSDebug.debugTrace("User Id: " + InstanceMng.getServerConnection().getUserId());
               break;
            case RESET_3D_CAM:
               InstanceMng.getCurrentScreen().reset3DCameraPosition();
               break;
            case CLEAN_DDBB:
               if(Config.ENVIRONMENT_ACTIVE != Config.ENVIRONMENT_PROD)
               {
                  resetDDBB(_loc4_);
               }
               break;
            case HIT_RAID_BOSS:
               _loc42_ = InstanceMng.getCurrentScreen() as FSBattleScreen;
               if(_loc42_)
               {
                  _loc42_.getBattleEngine().getOpponentBattleInfo().modifyHP(new FSNumber(-int(_loc4_)),true);
               }
               break;
            case HIT_MYSELF:
               _loc43_ = InstanceMng.getCurrentScreen() as FSBattleScreen;
               if(_loc43_)
               {
                  _loc43_.getBattleEngine().getOwnerBattleInfo().modifyHP(new FSNumber(-int(_loc4_)),true);
               }
               break;
            case CALCULATE_PVP_DECK_VALUE:
               _loc9_.getPvPDeckValue();
               break;
            case CALCULATE_DECK_VALUE:
               _loc9_.getDeckValue(int(_loc4_));
               break;
            case ENQUEUE_IN_PVP:
               PvPConnectionMng.enqueueInPvP();
               Utils.setLogText(TextManager.getText("TID_PVP_SEARCHING") + "...",false,true,false);
               FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_ENQUEUED);
               break;
            case ADD_GUILD_POINTS:
               _loc44_ = _loc4_ != null ? int(_loc4_) : 0;
               _loc9_.addGuildWeeklyDungeonScore(_loc44_);
               break;
            case GUILD_REWARD_GOLD:
               _loc45_ = GoldDef(InstanceMng.getGoldDefMng().getDefBySku("gold_01"));
               InstanceMng.getServerConnection().shareGoldPurchasedWithGuild(_loc45_.getGold(),_loc45_);
               break;
            case TEST_RESTORE:
               Root(Starling.current.root).showLoadingScreenImage(Utils.stringToBoolean(_loc4_),true);
               break;
            case ADD_AH_TOKENS:
               if(int(_loc4_) > 0)
               {
                  _loc9_.addAuctionTickets(int(_loc4_));
               }
               else
               {
                  _loc9_.substractAuctionTickets(int(_loc4_));
               }
               InstanceMng.getUserDataMng().updateAuctionTickets();
               break;
            case SET_DECK_CARDS_AMOUNT:
               Config.getConfig().setDeckCardsAmount(int(_loc4_));
               break;
            case TRIGGER_GC:
               Utils.callGC();
               break;
            case JOB_LEVEL_UP:
               if(Config.getConfig().gameHasClassSystem())
               {
                  JobsMng.winJobExperience(Number(_loc5_[0]));
               }
               break;
            case JOB_RESET:
               _loc9_.setJobsExperience(InstanceMng.getJobsDefMng().getAllJobSkus());
               save();
               break;
            case TEST_LEADERBOARD:
               InstanceMng.getServerConnection().addScoreToLeaderboard.apply(null,_loc5_);
               break;
            case ADD_JOB_EXP:
               if(Config.getConfig().gameHasClassSystem())
               {
                  JobsMng.winJobExperience(Number(_loc5_[0]));
               }
               break;
            case SHARE_CARD:
               InstanceMng.getFacebookPlugin().shareCardReceived(CardDef(InstanceMng.getCardsDefMng().getDefBySku("unit_130")));
               break;
            case PUSH_TEST:
               InstanceMng.getApplication().authorisationStatus();
               break;
            case DEVICE:
               FSDebug.debugTrace(ObjectUtil.toString(Utils.getDeviceInfo()));
               break;
            case GET_FRIENDS_WHO_PLAY:
               InstanceMng.getServerConnection().getFriendsWhoPlay();
               break;
            case ADD_JOB_REWARD:
               JobsMng.addPack(RewardDef(InstanceMng.getRewardsDefMng().getDefBySku("reward_01")),1,"job_01","pack_01");
               break;
            case TEST_INTRO:
               InstanceMng.getBattleEngine().removeIntro();
               InstanceMng.getBattleEngine().playIntro();
               break;
            case BREAK_PVP:
               if(Boolean(InstanceMng.getBattleEngine()) && InstanceMng.getBattleEngine().isOnlineMatch())
               {
                  PvPConnectionMng.packageSaveObjForSending();
               }
               break;
            case REAL_TIME_PVP_TEST:
               Config.getConfig().setDeckCardsAmount(6);
               Utils.godModeAddCardsToDeck(0,"unit_482:1,unit_1897:2,unit_1870:1,unit_219:2");
               Utils.getOwnerUserData().setSelectedDeckIndexPvP(0);
               save();
               PvPConnectionMng.enqueueInPvP();
               break;
            case SCORE:
               _loc46_ = InstanceMng.getScoreMng().calculateFinalScore(true);
               _loc47_ = InstanceMng.getScoreMng().calculateFinalScore(false);
               FSDebug.debugTrace("Score WON: " + _loc46_);
               FSDebug.debugTrace("Score LOST: " + _loc47_);
               break;
            case STARS:
               _loc48_ = int(_loc5_[0]);
               _loc51_ = _loc9_.getCurrentDifficulty();
               _loc89_ = 1;
               while(_loc89_ < _loc48_)
               {
                  _loc49_ = "level_" + Utils.transformValueToString(_loc89_.toString(),2);
                  _loc7_ = LevelDef(InstanceMng.getLevelsDefMng().getDefBySku(_loc49_));
                  _loc50_ = _loc7_.getMaxScoreByDifficulty(UserDataMng.DIFFICULTY_HARD);
                  InstanceMng.getServerConnection().addLevelScore(_loc49_,_loc50_,ServerConnection.smServerTimeMS.toString(),-1,false,_loc51_);
                  _loc89_++;
               }
               break;
            case RESHUFFLE:
               InstanceMng.getBattleEngine().reshuffleHand();
               break;
            case FILLAP:
               _loc52_ = new BoostFillAP(BoostDef(InstanceMng.getBoostsDefMng().getDefBySku("boost_03")));
               _loc52_.execute();
               break;
            case NEWCARDS:
               FSDebug.debugTrace("New cards: " + DictionaryUtils.getCardsAmountPerCatalog(_loc9_.getNewCardsCollection()));
               break;
            case BLOOD:
               if(InstanceMng.getCurrentScreen() is FSBattleScreen)
               {
                  FSBattleScreen(InstanceMng.getCurrentScreen()).showBloodScreenEffect();
               }
               break;
            case RESET_WORLD:
               _loc9_.setMapWorldChoice(0,UserData.WORLD_DEFAULT);
               InstanceMng.getUserDataMng().updateMapWorldChoices();
               InstanceMng.getCurrentScreen().dispatchEventWith(Screen.GO_TO_MAP,true);
               break;
            case CHOOSE_WORLD:
               _loc53_ = WorldDef(InstanceMng.getWorldsDefMng().getDefBySku("world_01"));
               _loc54_ = WorldDef(InstanceMng.getWorldsDefMng().getDefBySku("world_02"));
               _loc55_ = new ChooseWorldEffect(_loc53_,_loc54_);
               InstanceMng.getCurrentScreen().addChild(_loc55_);
               break;
            case RAND:
               _loc56_ = new Dictionary(true);
               _loc58_ = 10000;
               _loc59_ = -6;
               _loc60_ = 4;
               _loc89_ = 0;
               while(_loc89_ < _loc58_)
               {
                  _loc57_ = Utils.randomInt(_loc59_,_loc60_);
                  if(_loc56_[_loc57_] == null)
                  {
                     _loc56_[_loc57_] = 1;
                  }
                  else
                  {
                     _loc56_[_loc57_] += 1;
                  }
                  _loc89_++;
               }
               _loc89_ = _loc59_;
               while(_loc89_ <= _loc60_)
               {
                  FSDebug.debugTrace("Value " + _loc89_ + ": " + _loc56_[_loc89_] + " (" + (_loc56_[_loc89_] / _loc28_ * 100).toFixed(2) + "%)");
                  _loc89_++;
               }
               break;
            case MEMORY:
               FSDebug.debugTrace("[ASSET MANAGER] TEXTURES: " + Root.assets.getTexturesLength());
               FSDebug.debugTrace("[ASSET MANAGER] SOUNDS: " + Root.assets.getSoundsLength());
               if(mMemTextures == null)
               {
                  mMemTextures = new Dictionary(true);
               }
               if(mMemSounds == null)
               {
                  mMemSounds = new Dictionary(true);
               }
               _loc61_ = Root.assets.getTexturesNames();
               _loc62_ = Root.assets.getSoundsNames();
               FSDebug.debugTrace("NEW TEXTURES:");
               _loc89_ = 0;
               while(_loc89_ < _loc61_.length)
               {
                  if(mMemTextures[_loc61_[_loc89_]] == null)
                  {
                     mMemTextures[_loc61_[_loc89_]] = true;
                     FSDebug.debugTrace(_loc61_[_loc89_]);
                  }
                  _loc89_++;
               }
               FSDebug.debugTrace("END OF NEW TEXTURES");
               FSDebug.debugTrace("NEW SOUNDS:");
               _loc89_ = 0;
               while(_loc89_ < _loc62_.length)
               {
                  if(mMemSounds[_loc62_[_loc89_]] == null)
                  {
                     mMemSounds[_loc62_[_loc89_]] = true;
                     FSDebug.debugTrace(_loc62_[_loc89_]);
                  }
                  _loc89_++;
               }
               FSDebug.debugTrace("END OF NEW SOUNDS");
               break;
            case TEST_BACK:
               InstanceMng.getApplication().androidTestBack();
               break;
            case DRAG_MAP:
               if(_loc6_ is FSMapScreen)
               {
                  FSMapScreen(_loc6_).dragMaps(Number(_loc5_[0]));
               }
               break;
            case FAKE_DOUBLE_SESSION:
               InstanceMng.getServerConnection().handleSessionTerminated(null,"ERR:#002");
               break;
            case PENDING_PURCHASES:
               InstanceMng.getApplication().getInAppsManager().getPendingPurchases();
               break;
            case BG_EXECUTION:
               NativeApplication.nativeApplication.executeInBackground = !NativeApplication.nativeApplication.executeInBackground;
               FSDebug.debugTrace("executeInBackground: " + NativeApplication.nativeApplication.executeInBackground);
               break;
            case TEST_SHOP_PURCHASE:
               if(InstanceMng.getCurrentScreen() is FSShopScreen)
               {
                  _loc9_.increasePurchasesAmount();
                  FSShopScreen(InstanceMng.getCurrentScreen()).reviewVisibilityOfCurrentSectionItems();
               }
               break;
            case PAYING_USER:
               _loc9_.setPurchasesAmount(1);
               break;
            case RESET_DAILY:
               _loc9_.setDailyRewardTimeMS(0);
               break;
            case PRINT_PVP_DATA:
               PvPConnectionMng.printCurrentSaveData();
               break;
            case PRINT_CARDS_DESC:
               _loc63_ = InstanceMng.getAbilitiesDefMng().getAllDefs();
               if(_loc63_)
               {
                  for each(_loc90_ in _loc63_)
                  {
                     _loc91_ = _loc90_.getDesc();
                     FSDebug.debugTrace("Def: " + _loc90_.getSku() + " - " + _loc91_);
                  }
               }
               break;
            case TEST_LOCAL_PUSH:
               InstanceMng.getApplication().scheduleNotifications(50,Constants.NOTIF_OFFERS_EXPIRING);
               break;
            case START_TEST:
               Tester.startTest();
               break;
            case INVITE_FRIENDS_POPUP:
               InstanceMng.getUserDataMng().checkOpenSocialPopups();
               break;
            case FORCE_CONNECTION_KO:
               InstanceMng.getServerConnection().onConnectionKO();
               break;
            case UNZIP:
               break;
            case FLASH:
               Security.showSettings(SecurityPanel.LOCAL_STORAGE);
               break;
            case FAKE_BATTLEPASS_PURCHASE:
               InstanceMng.getUserDataMng().handleBattlePassPurchased();
               break;
            case FAKE_BATTLEPASS_CLEAN:
               _loc9_.setBattlePass("2018-09");
               save();
               if(InstanceMng.getPopupMng().getPopupShown() is PopupBattlePass)
               {
                  PopupBattlePass(InstanceMng.getPopupMng().getPopupShown()).onBattlePassInvalidated();
               }
               break;
            case FAKE_SEASON:
               fakeNextSeason(int(_loc5_[0]));
               break;
            case GET_BP_REWARDS:
               if(_loc5_.length < 2)
               {
                  FSDebug.debugTrace("\n\n  ====> ERROR! <==== Missing month + year parameters e.g. GET_BP_REWARDS 10 2018");
               }
               _loc64_ = int(_loc5_[0]);
               _loc65_ = int(_loc5_[1]);
               _loc66_ = "\n\n[BATTLE PASS Rewards Summary]  (Season " + _loc64_ + "-" + _loc65_ + ")\n";
               _loc67_ = InstanceMng.getQuestsDefMng().getSeasonBattlePassQuests(_loc64_,_loc65_);
               if(_loc67_)
               {
                  _loc89_ = 0;
                  while(_loc89_ < _loc67_.length)
                  {
                     _loc12_ = _loc67_[_loc89_];
                     _loc66_ += "\n" + getBattlePassRewardToString(_loc12_);
                     _loc89_++;
                  }
               }
               _loc66_ += "\n\n  === End of Season rewards ===\n\n";
               FSDebug.debugTrace(_loc66_);
               break;
            case DAY_RESET:
               if(_loc9_)
               {
                  _loc9_.setDailyKeyTime(Number(_loc5_[0]));
                  save();
               }
               break;
            case DB_IGNORE_SEASON_FILTER:
               Config.smDBIgnoreSeasonFilter = !Config.smDBIgnoreSeasonFilter;
               FSDebug.debugTrace("Ignore Season filter? === > " + Config.smDBIgnoreSeasonFilter);
               break;
            case FILL_AP:
               _loc69_ = InstanceMng.getBattleEngine();
               if(_loc69_ != null)
               {
                  _loc68_ = _loc69_.getOwnerBattleInfo();
                  if(_loc68_ != null)
                  {
                     _loc68_.resetActionPoints();
                     if(InstanceMng.getCurrentScreen() is FSBattleScreen)
                     {
                        FSBattleScreen(InstanceMng.getCurrentScreen()).updateActionPointsLeft();
                     }
                     if(InstanceMng.getCurrentScreen() is FSBattleScreen)
                     {
                        if(_loc69_.isOwnerPowerActive())
                        {
                           FSBattleScreen(InstanceMng.getCurrentScreen()).hideCancelPower(true);
                        }
                        FSBattleScreen(InstanceMng.getCurrentScreen()).suggestPlayableCardON();
                     }
                  }
               }
               Utils.setLogText(TextManager.getText("TID_BOOST_ACTION_RESTORED"));
               break;
            case RECOVER_ACCOUNT:
               InstanceMng.getServerConnection().recoverFromFBAlterAccount();
               break;
            case CHECK_ACH:
               InstanceMng.getApplication().steamCheckAchievement(String(_loc5_[0]).toUpperCase());
               break;
            case CHECK_STAT:
               InstanceMng.getApplication().steamCheckStat(String(_loc5_[0]));
               break;
            case SET_STAT:
               InstanceMng.getApplication().submitStat(String(_loc5_[0]),Number(_loc5_[1]));
               break;
            case CLEAR_ACH:
               InstanceMng.getApplication().steamClearAchievement(String(_loc5_[0]).toUpperCase());
               break;
            case RESET_STATS_AND_ACH:
               InstanceMng.getApplication().steamResetAllStats(true);
               break;
            case RAID_READY:
               _loc9_.addGold(1000);
               _loc9_.setCurrentLevelSku("level_100");
               save();
               InstanceMng.getCurrentScreen().dispatchEventWith(Screen.GO_TO_MAP,true);
               break;
            case PRINT_BOT_DV:
               InstanceMng.getPvPBotDecksDefMng().printPvPBotDeckDefsDeckValues();
               break;
            case ROT:
               if(InstanceMng.getCurrentScreen() is FSBattleScreen)
               {
                  _loc94_ = FSBattleScreen(InstanceMng.getCurrentScreen()).getOwnerSideDeckSocketCatalog();
                  if(_loc94_)
                  {
                     for each(_loc92_ in _loc94_)
                     {
                        _loc93_ = _loc92_.getParentCard();
                        if(_loc93_ != null)
                        {
                           TweenMax.to(_loc93_,1,{
                              "rotationX":deg2rad(_loc5_[0]),
                              "rotationY":deg2rad(_loc5_[1]),
                              "rotationZ":deg2rad(_loc5_[2]),
                              "repeat":10
                           });
                        }
                     }
                  }
               }
               break;
            case TEST3D:
               _loc70_ = new Sprite3D();
               _loc71_ = new Quad(150,150,16711680);
               _loc70_.addChild(_loc71_);
               _loc70_.alignPivot();
               _loc70_.x = Starling.current.stage.stageWidth / 2;
               _loc70_.y = Starling.current.stage.stageHeight / 2;
               InstanceMng.getCurrentScreen().addChild(_loc70_);
               _loc70_.addEventListener(Event.ENTER_FRAME,onSpriteEnterFrame);
               break;
            case TEST_PARTICLE:
               _loc72_ = AssetsParticles.requestParticleSystem("gunshot");
               _loc72_.x = Starling.current.nativeStage.mouseX;
               _loc72_.y = Starling.current.nativeStage.mouseY;
               _loc72_.scale *= 0.75;
               InstanceMng.getCurrentScreen().addChild(_loc72_);
               Starling.juggler.add(_loc72_);
               _loc72_.start(0.15);
               break;
            case NEWSEASON:
               _loc73_ = _loc9_.getPvPSeason();
               InstanceMng.getPopupMng().openNewSeasonPopup(_loc73_,true,false);
               break;
            case REFRESH_OFFERS:
               if(InstanceMng.getCurrentScreen() is FSShopScreen)
               {
                  FSShopScreen(InstanceMng.getCurrentScreen()).forceRefreshOffers();
               }
               break;
            case LOAD_MAP:
               _loc74_ = int(_loc5_[0]);
               FSMapScreen(_loc6_).travelToMap(_loc74_);
               break;
            case MAP_SELECTOR:
               InstanceMng.getPopupMng().openMapSelectorPopup();
               break;
            case CREATE_LIGHT:
               _loc75_ = new LightStyle();
               _loc75_.ambientRatio = 1;
               _loc75_.diffuseRatio = 0.7;
               _loc75_.specularRatio = 0.5;
               _loc75_.shininess = 16;
               _loc76_ = LightSource.createAmbientLight(Color.WHITE,5);
               InstanceMng.getCurrentScreen().addChild(_loc76_);
               InstanceMng.getCurrentScreen().getBG().style = _loc75_;
               _loc77_ = LightSource.createPointLight(16777215,1);
               _loc77_.x = InstanceMng.getApplication().getFullScreenWidth() / 2;
               _loc77_.y = InstanceMng.getApplication().getFullScreenHeight() / 2;
               _loc77_.z = -50;
               InstanceMng.getCurrentScreen().addChild(_loc77_);
               _loc77_.showLightBulb = true;
               break;
            case LIGHTS:
               _loc78_ = true;
               if(_loc9_)
               {
                  _loc78_ = _loc9_.flagsGetShowLightFX();
                  _loc9_.setShowLightFX(!_loc78_);
               }
               break;
            case LAUNCH_BOT:
               _loc9_.setMatchesPlayed(0);
               _loc9_.setBotsPlayedSession(0);
               save();
               _loc79_ = Utils.transformValueToString(String(_loc5_[0]),2);
               PvPConnectionMng.enqueueInPvP("pvpBotsDeck_" + _loc79_);
               break;
            case CHECK_BOTS:
               InstanceMng.getPvPBotDecksDefMng().getRandomPvPBotDeckDefsByDeckValue(_loc5_[0]);
               break;
            case RADIAL:
               if(mRadial == null)
               {
                  mRadial = new RadialProgressBar();
                  mRadial.progressTexture = Root.assets.getTexture("pvp_league_circle_progress");
                  InstanceMng.getCurrentScreen().addChild(mRadial);
               }
               mRadial.tweenTo(_loc5_[0],1);
               break;
            case SHOW_OPPONENT_CARDS_DECK:
               BattleEngine.smShowOpponentCardsDeck = true;
               break;
            case MONTHLY:
               InstanceMng.getQuestsMng().resetBattlePassQuests();
               break;
            case INCR_DUNGEONS_PLAYED:
               _loc9_.increaseDungeonsPlayed();
               break;
            case TEST_FIREBASE_DB:
               _loc80_ = Utils.randomInt(1,100);
               _loc81_ = Utils.randomInt(1,3);
               _loc82_ = Utils.randomInt() == 1;
               _loc83_ = Utils.randomInt() == 1;
               _loc84_ = Utils.randomInt() == 1;
               InstanceMng.getApplication().firebaseAddToDatabase(_loc80_,_loc81_,_loc82_,_loc83_,_loc84_);
               break;
            case TEST_FIREBASE_PWD:
               _loc85_ = Utils.encodeBase64("#STOREDINSECURESERVER, ASKADMIN#");
               _loc86_ = Utils.encodeBase64("#STOREDINSECURESERVER, ASKADMIN#");
               FSDebug.debugTrace("username: " + _loc85_);
               FSDebug.debugTrace("pwd: " + _loc86_);
               FSDebug.debugTrace("username decoded: " + Utils.decodeBase64Str(_loc85_));
               FSDebug.debugTrace("pwd decoded: " + Utils.decodeBase64Str(_loc86_));
               break;
            case FORCE_COMBAT_LOG:
               PvPConnectionMng.trackCombatLog();
               break;
            case SCREENSHOT_MODE:
               Config.smScreenShotMode = !Config.smScreenShotMode;
               if(InstanceMng.getCurrentScreen() is FSBattleScreen)
               {
                  FSBattleScreen(InstanceMng.getCurrentScreen()).updateUIForScreenShots();
               }
         }
         FSDebug.debugTrace("[CHEAT CONSOLE] - code entered > " + param1);
      }
      
      private static function save() : void
      {
         InstanceMng.getUserDataMng().persistenceSaveData();
      }
      
      private static function onSpriteEnterFrame(param1:Event) : void
      {
         Sprite3D(param1.currentTarget).rotationY = Sprite3D(param1.currentTarget).rotationY + deg2rad(1);
      }
      
      private static function getBattlePassRewardToString(param1:QuestDef) : String
      {
         var questDef:QuestDef = param1;
         var getInfo:Function = function(param1:QuestDef, param2:Boolean):String
         {
            var _loc3_:int = param1.getRewardType(param2);
            var _loc4_:String = param2 ? " [PREMIUM] " : " [Standard] ";
            var _loc5_:String = "";
            var _loc6_:String = "";
            var _loc7_:String = "";
            var _loc8_:Boolean = true;
            switch(_loc3_)
            {
               case QuestsDefMng.REWARD_TYPE_QUEST_COINS:
                  _loc5_ += "Quest Coins";
                  _loc6_ = " (" + param1.getRewardPoints(param2) + ")";
                  break;
               case QuestsDefMng.REWARD_TYPE_RAID_COINS:
                  _loc5_ += "Raid Points";
                  _loc6_ = " (" + param1.getRewardRaidPoints(param2) + ")";
                  break;
               case QuestsDefMng.REWARD_TYPE_GOLD:
                  _loc5_ += "Gold";
                  _loc6_ = " (" + param1.getRewardGold(param2) + ")";
                  break;
               case QuestsDefMng.REWARD_TYPE_TOKENS:
                  _loc5_ += "A Tokens";
                  _loc6_ = " (" + param1.getRewardTokens(param2) + ")";
                  break;
               case QuestsDefMng.REWARD_TYPE_CARD:
                  _loc5_ += "Card";
                  _loc6_ = " (" + param1.getRewardCard(param2) + ")";
                  break;
               case QuestsDefMng.REWARD_TYPE_PORTRAIT_SKIN:
                  _loc5_ += "Portrait/Skin";
                  _loc6_ = " (" + param1.getRewardSkinSku(param2) + ")";
                  break;
               case QuestsDefMng.REWARD_TYPE_PACK:
                  _loc5_ += "Pack";
                  _loc6_ = " (" + param1.getRewardPackSku(param2) + ")";
                  break;
               case QuestsDefMng.REWARD_TYPE_UNLOCK_CRAFT:
                  _loc5_ += "Unlock Craft";
                  _loc6_ = "";
                  break;
               case QuestsDefMng.REWARD_TYPE_NONE:
                  _loc5_ += "";
                  _loc6_ = "";
                  _loc8_ = false;
            }
            return _loc7_ + (_loc8_ ? _loc4_ + _loc5_ + _loc6_ : "");
         };
         var questInfo:String = "BP #: " + questDef.getBattlePassIndex();
         var returnValue:String = questInfo;
         returnValue += getInfo(questDef,false);
         returnValue += getInfo(questDef,true);
         return returnValue;
      }
      
      private static function createRaidReward(param1:int, param2:String) : Object
      {
         var _loc5_:Object = null;
         var _loc3_:Object = new Object();
         var _loc4_:Array = new Array();
         switch(param1)
         {
            case RaidsMng.REWARD_TYPE_RAID_COINS:
               _loc5_ = new Object();
               _loc5_.type = param1;
               _loc5_.sku = "";
               _loc5_.amount = 200;
               _loc5_.claimed = false;
               _loc4_.push(_loc5_);
         }
         _loc3_.raidId = param2;
         _loc3_.reward = _loc4_;
         return _loc3_;
      }
      
      private static function createReward(param1:int) : Object
      {
         var _loc2_:Object = new Object();
         switch(param1)
         {
            case Constants.REWARDS_TYPE_PACK:
               _loc2_.type = 1;
               _loc2_.sku = "pack_01";
               _loc2_.amount = 1;
               _loc2_.seasonId = 12;
               _loc2_.timestampMS = ServerConnection.smServerTimeMS;
               break;
            case Constants.REWARDS_TYPE_GOLD:
               _loc2_.type = 3;
               _loc2_.sku = "";
               _loc2_.amount = 500;
               _loc2_.seasonId = 12;
               _loc2_.timestampMS = ServerConnection.smServerTimeMS;
         }
         return _loc2_;
      }
      
      private static function resetDDBB(param1:String, param2:String = "{}") : void
      {
         InstanceMng.getServerConnection().deleteAllInstancesOfDatabase(param1,param2);
      }
      
      public static function onTextKeyUp(param1:KeyboardEvent) : void
      {
         var _loc2_:String = null;
         if(param1.keyCode == 13)
         {
            if(param1.target != null && param1.target is TextField)
            {
               _loc2_ = TextField(param1.target).text;
               doAction(_loc2_);
            }
         }
      }
      
      private static function makeTextField() : void
      {
         var _loc1_:FSTextfield = new FSTextfield(100,50,"BOOM");
         InstanceMng.getCurrentScreen().addChild(_loc1_);
         var _loc2_:Number = _loc1_.textBounds.width;
         _loc1_.filter = new BlurFilter();
         setTimeout(recreate_context,1000);
      }
      
      private static function recreate_context() : void
      {
         Starling.current.nativeStage.stage3Ds[0].requestContext3D();
      }
      
      private static function fakeNextSeason(param1:int) : void
      {
         Config.smDayKey.value = 1541026800000;
         Config.smWeekNumber.value = 44;
         Config.smMonthNumber.value = param1;
         Config.smYearNumber.value = 2019;
         InstanceMng.getServerConnection().manageDailyKeyReceived();
         InstanceMng.getServerConnection().handleBattlePassValidation();
      }
      
      private static function testPack(param1:String, param2:int) : String
      {
         var _loc3_:Dictionary = null;
         var _loc5_:RarityDef = null;
         var _loc6_:String = null;
         var _loc7_:CardDef = null;
         var _loc12_:String = null;
         var _loc13_:Array = null;
         var _loc14_:String = null;
         var _loc15_:Number = NaN;
         var _loc16_:int = 0;
         var _loc4_:Dictionary = new Dictionary(true);
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:PackDef = PackDef(InstanceMng.getPacksDefMng().getDefBySku(param1));
         _loc9_ = 0;
         while(_loc9_ < param2)
         {
            _loc3_ = Utils.rollCardsPack(_loc10_,"TEST",null,true);
            if(_loc3_)
            {
               for each(_loc6_ in _loc3_)
               {
                  _loc7_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc6_));
                  _loc5_ = RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(_loc7_.getCardRarity()));
                  _loc4_[_loc5_.getSku()] = isNaN(_loc4_[_loc5_.getSku()]) ? 1 : _loc4_[_loc5_.getSku()] + 1;
                  _loc8_++;
               }
            }
            _loc9_++;
         }
         var _loc11_:String = "\n\n[" + _loc10_.getName() + "] results for " + param2 + " iterations (total cards generated: " + _loc8_ + ")";
         if(_loc4_)
         {
            _loc13_ = DictionaryUtils.getKeys(_loc4_);
            _loc14_ = "";
            _loc15_ = 0;
            _loc13_.sort(DictionaryUtils.sortAlphabetically);
            if(Boolean(_loc13_) && _loc13_.length > 0)
            {
               _loc16_ = 0;
               while(_loc16_ < _loc13_.length)
               {
                  _loc15_ = Number(_loc4_[_loc13_[_loc16_]]);
                  _loc14_ = RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(_loc13_[_loc16_])).getName() + ": " + _loc15_;
                  _loc11_ += "\n" + _loc14_;
                  _loc16_++;
               }
            }
         }
         return _loc11_;
      }
      
      private function createFakeGuildDungeonCompletedEvent(param1:int) : void
      {
         var _loc2_:UserData = Utils.getOwnerUserData();
         if(Config.HAS_GUILDS && _loc2_.hasGuild())
         {
            switch(param1)
            {
               case DungeonsMng.DUNGEON_DIFFICULTY_EASY:
                  InstanceMng.getServerConnection().createGuildEvent(_loc2_.getGuildId(),GuildsMng.GUILD_EVENT_DUNGEON_EASY,_loc2_.getAccountId(),_loc2_.getName(),_loc2_.getRankIndex(),_loc2_.getGuildRank());
                  break;
               case DungeonsMng.DUNGEON_DIFFICULTY_MEDIUM:
                  InstanceMng.getServerConnection().createGuildEvent(_loc2_.getGuildId(),GuildsMng.GUILD_EVENT_DUNGEON_MED,_loc2_.getAccountId(),_loc2_.getName(),_loc2_.getRankIndex(),_loc2_.getGuildRank());
                  break;
               case DungeonsMng.DUNGEON_DIFFICULTY_HARD:
                  InstanceMng.getServerConnection().createGuildEvent(_loc2_.getGuildId(),GuildsMng.GUILD_EVENT_DUNGEON_HARD,_loc2_.getAccountId(),_loc2_.getName(),_loc2_.getRankIndex(),_loc2_.getGuildRank());
            }
         }
      }
   }
}

