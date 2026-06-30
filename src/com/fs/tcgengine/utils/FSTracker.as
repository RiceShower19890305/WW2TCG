package com.fs.tcgengine.utils
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.controller.FSInAppsManager;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.rules.PacksDefMng;
   import com.fs.tcgengine.model.rules.DailyRewardDef;
   import com.fs.tcgengine.model.rules.StarsRewardsDef;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.view.components.popups.map.DailyReward;
   import com.greensock.TweenMax;
   
   public class FSTracker
   {
      
      private static var mInstance:FSTracker;
      
      private static var mAllowInstance:Boolean;
      
      public static var smUserActions:Array;
      
      public static const CATEGORY_USER:String = "USER";
      
      public static const CATEGORY_PURCHASE:String = "PURCHASE";
      
      public static const CATEGORY_LEVELS:String = "LEVELS";
      
      public static const CATEGORY_MEDIUM_LEVELS:String = "MEDIUM_LEVELS";
      
      public static const CATEGORY_HARD_LEVELS:String = "HARD_LEVELS";
      
      public static const CATEGORY_PVP:String = "PVP";
      
      public static const CATEGORY_SCRIPT_MESSAGE:String = "SCRIPT_MESSAGE";
      
      public static const CATEGORY_LIFES:String = "LIFES";
      
      public static const CATEGORY_LOOT:String = "LOOT";
      
      public static const CATEGORY_TUTORIAL:String = "TUTORIAL";
      
      public static const CATEGORY_DOWNLOADER:String = "DOWNLOADER";
      
      public static const CATEGORY_UNZIPPING:String = "UNZIPPING";
      
      public static const CATEGORY_DAILY_REWARD:String = "DAILY_REWARD";
      
      public static const CATEGORY_OLD_PLAYER_DAILY_REWARD:String = "OLD_PLAYER_DAILY_REWARD";
      
      public static const CATEGORY_STARS_REWARD:String = "STARS_REWARD";
      
      public static const CATEGORY_TEST:String = "TEST";
      
      public static const CATEGORY_BATTLE:String = "BATTLE";
      
      public static const CATEGORY_MISC:String = "MISC";
      
      public static const CATEGORY_DECK_BUILDER:String = "DECK_BUILDER";
      
      public static const CATEGORY_SHOP:String = "SHOP";
      
      public static const CATEGORY_3STAR_REWARD:String = "3STAR_REWARD";
      
      public static const CATEGORY_BADGE_REWARD:String = "BADGE_REWARD";
      
      public static const CATEGORY_ASSET_MANAGER:String = "ASSET_MANAGER";
      
      public static const CATEGORY_DUNGEONS:String = "DUNGEONS";
      
      public static const CATEGORY_RAIDS:String = "RAIDS";
      
      public static const CATEGORY_RAIDS_PURCHASE:String = "RAIDS_PURCHASE";
      
      public static const CATEGORY_DUNGEON_LEVELS:String = "DUNGEON_LEVELS";
      
      public static const CATEGORY_GUILDS:String = "GUILDS";
      
      public static const CATEGORY_ADS:String = "ADS";
      
      public static const CATEGORY_QUEST_PURCHASE:String = "QUEST_PURCHASE";
      
      public static const CATEGORY_QUESTS:String = "QUESTS";
      
      public static const CATEGORY_CRAFT:String = "CRAFT";
      
      public static const CATEGORY_ASPECT:String = "ASPECT";
      
      public static const CATEGORY_FUSION:String = "FUSION";
      
      public static const CATEGORY_SKINS:String = "SKINS";
      
      public static const CATEGORY_AUCTION:String = "AUCTION";
      
      public static const CATEGORY_CURRENCY:String = "CURRENCY";
      
      public static const CATEGORY_JOBS:String = "JOBS";
      
      public static const CATEGORY_FACEBOOK:String = "FACEBOOK";
      
      public static const CATEGORY_KONGREGATE:String = "KONGREGATE";
      
      public static const CATEGORY_SCREEN:String = "SCREEN";
      
      public static const CATEGORY_GIFTS:String = "GIFTS";
      
      public static const CATEGORY_REFERRALS:String = "REFERRALS";
      
      public static const CATEGORY_BATTLE_PASS:String = "BATTLE_PASS";
      
      public static const ACTION_DAILY_RESET:String = "DAILY_RESET";
      
      public static const ACTION_ERROR_DETECTED:String = "ERROR_DETECTED";
      
      public static const ACTION_VIDEO_COMPLETED:String = "VIDEO_COMPLETED";
      
      public static const ACTION_USER_CREATED:String = "ACTION_USER_CREATED";
      
      public static const ACTION_REQUESTING_NAME_CHANGE:String = "ACTION_REQUESTING_NAME_CHANGE";
      
      public static const ACTION_REQUESTING_NAME_CHANGE_DECLINED:String = "ACTION_REQUESTING_NAME_CHANGE_DECLINED";
      
      public static const ACTION_REQUESTING_NAME_CHANGE_APPROVED:String = "ACTION_REQUESTING_NAME_CHANGE_APPROVED";
      
      public static const ACTION_SKIN_GOLD_PURCHASE:String = "SKIN_GOLD_PURCHASED";
      
      public static const ACTION_SKIN_PURCHASE:String = "SKIN_PURCHASED";
      
      public static const ACTION_PURCHASE:String = "PROD_PURCHASED";
      
      public static const ACTION_POSTBOOST_PURCHASE:String = "POSTBOOST_PURCHASED";
      
      public static const ACTION_KO:String = "KO";
      
      public static const ACTION_CANCELLED:String = "CANCELLED";
      
      public static const ACTION_PENDING:String = "PENDING";
      
      public static const ACTION_STARTED:String = "STARTED";
      
      public static const ACTION_COMPLETED:String = "COMPLETED";
      
      public static const ACTION_FAILED:String = "FAILED";
      
      public static const ACTION_PVE_STARTED:String = "PVE_STARTED";
      
      public static const ACTION_PVE_RETRY:String = "PVE_RETRY";
      
      public static const ACTION_SURRENDER:String = "SURRENDER";
      
      public static const ACTION_COMPLETED_EASY_MODE:String = "COMPLETED_EASY_MODE";
      
      public static const ACTION_FAILED_EASY_MODE:String = "FAILED_EASY_MODE";
      
      public static const ACTION_PVE_STARTED_EASY_MODE:String = "PVE_STARTED_EASY_MODE";
      
      public static const ACTION_PVE_RETRY_EASY_MODE:String = "PVE_RETRY_EASY_MODE";
      
      public static const ACTION_SURRENDER_EASY_MODE:String = "SURRENDER_EASY_MODE";
      
      public static const ACTION_PVP_MATCH_CREATED:String = "MATCH_CREATED";
      
      public static const ACTION_PVP_MATCH_DESYNCHRONIZED:String = "MATCH_DESYNCHRONIZED";
      
      public static const ACTION_PVP_MATCH_DIFFERENT:String = "MATCH_DIFFERENT";
      
      public static const ACTION_PVP_MATCH_ROUND_RECEIVED:String = "MATCH_ROUND_RECEIVED";
      
      public static const ACTION_PVP_MATCH_MOVE_RECEIVED:String = "MATCH_MOVE_RECEIVED";
      
      public static const ACTION_PVP_MATCH_DEAD:String = "MATCH_DEAD";
      
      public static const ACTION_PVP_MATCH_FINISHED:String = "MATCH_FINISHED";
      
      public static const ACTION_PVP_MATCH_COULD_NOT_BEGIN_DESYNCH:String = "MATCH_COULD_NOT_BEGIN_DESYNCH";
      
      public static const ACTION_PVP_MATCH_DESYNCRONIZED_1:String = "MATCH_DESYNCRONIZED_1";
      
      public static const ACTION_PVP_MATCH_DESYNCRONIZED_2:String = "MATCH_DESYNCRONIZED_2";
      
      public static const ACTION_PVP_MATCH_DESYNCRONIZED_3:String = "MATCH_DESYNCRONIZED_3";
      
      public static const ACTION_PVP_MATCH_DESYNCRONIZED_4:String = "MATCH_DESYNCRONIZED_4";
      
      public static const ACTION_PVP_MATCH_DESYNCRONIZED_5:String = "MATCH_DESYNCRONIZED_5";
      
      public static const ACTION_PVP_MATCH_DESYNCRONIZED_6:String = "MATCH_DESYNCRONIZED_6";
      
      public static const ACTION_PVP_MATCH_DESYNCRONIZED_7:String = "MATCH_DESYNCRONIZED_7";
      
      public static const ACTION_PVP_MATCH_DESYNCRONIZED_8:String = "MATCH_DESYNCRONIZED_8";
      
      public static const ACTION_PVP_MATCH_DESYNCRONIZED_9:String = "MATCH_DESYNCRONIZED_9";
      
      public static const ACTION_PVP_MATCH_DESYNCRONIZED_10:String = "MATCH_DESYNCRONIZED_10";
      
      public static const ACTION_PVP_MATCH_DESYNCRONIZED_11:String = "MATCH_DESYNCRONIZED_11";
      
      public static const ACTION_PVP_SURRENDER:String = "PVP_SURRENDER";
      
      public static const ACTION_PVP_REWARD_READY_TO_CLAIM:String = "PVP_REWARD_READY_TO_CLAIM";
      
      public static const ACTION_PRE_CLAIM:String = "PRE_CLAIM";
      
      public static const ACTION_PVP_REWARD_CLAIMED:String = "PVP_REWARD_CLAIMED";
      
      public static const ACTION_OUT_OF_LIFES:String = "OUT_OF_LIFES";
      
      public static const ACTION_CLAIMED:String = "CLAIMED";
      
      public static const ACTION_SHARING_GAME:String = "SHARING_GAME";
      
      public static const ACTION_EXPIRED:String = "EXPIRED";
      
      public static const ACTION_RESTARTED:String = "RESTARTED";
      
      public static const ACTION_RESET:String = "DATA_RESET";
      
      public static const ACTION_MIGRATION:String = "DATA_MIGRATION";
      
      public static const ACTION_RESTORED:String = "RESTORED";
      
      public static const ACTION_CONSUMED:String = "CONSUMED";
      
      public static const ACTION_NOT_ENOUGH_FREE_SPACE:String = "NOT_ENOUGH_FREE_SPACE";
      
      public static const ACTION_CARD_DEFEATED:String = "CARD_DEFEATED";
      
      public static const ACTION_TURN:String = "TURN";
      
      public static const ACTION_NICK_CHANGED:String = "NICK_CHANGED";
      
      public static const ACTION_DECK_EDITED:String = "DECK_EDITED";
      
      public static const ACTION_DECK_SELECTED:String = "DECK_SELECTED";
      
      public static const ACTION_CARDS_DELETED:String = "CARDS_DELETED";
      
      public static const ACTION_WON:String = "WON";
      
      public static const ACTION_LOST:String = "LOST";
      
      public static const ACTION_DRAW:String = "DRAW";
      
      public static const ACTION_UPDATE_REQUIRED:String = "UPDATE_REQUIRED";
      
      public static const ACTION_ENQUEUED:String = "ENQUEUED";
      
      public static const ACTION_QUEUE_CANCELLED:String = "QUEUE_CANCELLED";
      
      public static const ACTION_REQUESTED_FB_MATCH:String = "REQUESTED_FB_MATCH";
      
      public static const ACTION_SENT_LIVES:String = "SENT_LIVES";
      
      public static const ACTION_SENT_INVITES:String = "SENT_INVITES";
      
      public static const ACTION_SENT_UNLOCKS:String = "SENT_UNLOCKS";
      
      public static const ACTION_GOLD_PACK_PURCHASED:String = "PROD_GOLD_PACK_PURCHASED";
      
      public static const ACTION_QUESTCOIN_PACK_PURCHASED:String = "PROD_QUESTCOINS_PACK_PURCHASED";
      
      public static const ACTION_RAIDCOINS_PACK_PURCHASED:String = "PROD_RAIDCOINS_PACK_PURCHASED";
      
      public static const ACTION_OFFER_GOLD_CARD_PURCHASED:String = "PROD_OFFER_GOLD_CARD_PURCHASED";
      
      public static const ACTION_BOOST_USED:String = "BOOST_USED";
      
      public static const ACTION_FB_LOGOUT:String = "FB_LOGOUT";
      
      public static const ACTION_FB_WRITE_OK:String = "FB_WRITE_OK";
      
      public static const ACTION_FB_READ_KO:String = "FB_READ_KO";
      
      public static const ACTION_FB_WRITE_KO:String = "FB_WRITE_KO";
      
      public static const ACTION_NO_SOCIAL_SCORES_BAR:String = "NO_SOCIAL_SCORES_BAR";
      
      public static const ACTION_FAILED_SAVE_PERSISTENCE:String = "FAILED_SAVE_PERSISTENCE";
      
      public static const ACTION_IO_ERROR:String = "IO_ERROR";
      
      public static const ACTION_SECURITY_ERROR:String = "SECURITY_ERROR";
      
      public static const ACTION_DUNGEON_REWARDS_SUMMARY:String = "DUNGEON_REWARDS_SUMMARY";
      
      public static const ACTION_DUNGEON_STARTED:String = "DUNGEON_STARTED";
      
      public static const ACTION_RAID_STARTED:String = "RAID_STARTED";
      
      public static const ACTION_RAID_CONTINUED:String = "ACTION_RAID_CONTINUED";
      
      public static const ACTION_RAID_FINISH_INCOMPLETE:String = "RAID_FINISH_INCOMPLETE";
      
      public static const ACTION_RAID_FINISH_BOSS_DEFEATED:String = "RAID_FINISH_BOSS_DEFEATED";
      
      public static const ACTION_DUNGEON_PAYED:String = "DUNGEON_PAYED";
      
      public static const ACTION_DUNGEON_FINISHED:String = "DUNGEON_FINISHED";
      
      public static const ACTION_DUNGEON_LEVEL_FINISHED:String = "DUNGEON_LEVEL_FINISHED";
      
      public static const ACTION_DUNGEON_LEVEL_STARTED:String = "DUNGEON_LEVEL_STARTED";
      
      public static const ACTION_DUNGEON_ABANDONED:String = "DUNGEON_ABANDONED";
      
      public static const ACTION_DUNGEON_LEVEL_GOLD_WON:String = "DUNGEON_LEVEL_GOLD_WON";
      
      public static const ACTION_DUNGEON_REWARD_READY_TO_CLAIM:String = "DUNGEON_REWARD_READY_TO_CLAIM";
      
      public static const ACTION_DUNGEON_REWARD_CLAIMED:String = "DUNGEON_REWARD_CLAIMED";
      
      public static const ACTION_ATTEMPTED_GOLD_HACK:String = "ATTEMPTED_GOLD_HACK";
      
      public static const ACTION_VISITED:String = "VISITED";
      
      public static const ACTION_WROTE:String = "WROTE";
      
      public static const ACTION_EV_RECEIVED:String = "EV_RECEIVED";
      
      public static const ACTION_GUILDS_GUILD_CREATED:String = "GUILDS_GUILD_CREATED";
      
      public static const ACTION_GUILDS_REWARD_CLAIMED:String = "GUILDS_GUILD_REWARD_CLAIMED";
      
      public static const GUILDS_JOBS_REWARD_CLAIMED:String = "GUILDS_JOBS_REWARD_CLAIMED";
      
      public static const ACTION_FB_LOGIN_REWARD_CLAIMED:String = "FB_LOGIN_REWARD_CLAIMED";
      
      public static const ACTION_KONG_RATE_REWARD_CLAIMED:String = "KONG_RATE_REWARD_CLAIMED";
      
      public static const ACTION_GUILDS_PLAYER_SCORES:String = "GUILDS_PLAYER_SCORES";
      
      public static const ACTION_GUILDS_REWARD_NOT_FOUND:String = "GUILDS_REWARD_NOT_FOUND";
      
      public static const ACTION_PLAYER_UPDATING_GUILD:String = "PLAYER_UPDATING_GUILD";
      
      public static const ACTION_PLAYER_ADVANCING_WEEK:String = "PLAYER_ADVANCING_WEEK";
      
      public static const ACTION_PLAYER_BEING_UPDATED:String = "PLAYER_BEING_UPDATED";
      
      public static const ACTION_COULD_NOT_GET_INFO:String = "COULD_NOT_GET_INFO";
      
      public static const ACTION_COULD_NOT_UPDATE:String = "COULD_NOT_UPDATE";
      
      public static const ACTION_PLAYER_BEING_UPDATED_GUILDS_MNG:String = "PLAYER_BEING_UPDATED-v2(guildsMng)";
      
      public static const ACTION_PLAYER_RESETED_WEEK_INDEX_TOO_OLD:String = "PLAYER_RESETED_WEEK_INDEX_TOO_OLD";
      
      public static const ACTION_PLAYER_WEEK_SEASON_ADVANCE:String = "PLAYER_WEEK_SEASON_ADVANCE";
      
      public static const PLAYER_BEING_RESETED_HAD_NO_GUILD:String = "PLAYER_BEING_RESETED_HAD_NO_GUILD";
      
      public static const ACTION_GUILD_JOINED:String = "ACTION_GUILD_JOINED";
      
      public static const ACTION_GUILD_UPDATED_VALUES_NO_SAVED:String = "ACTION_GUILD_UPDATED_VALUES_NO_SAVE!";
      
      public static const ACTION_GUILD_MEMBER_INFO_RESETED:String = "ACTION_GUILD_MEMBER_INFO_RESETED";
      
      public static const ACTION_SHOW_AD:String = "SHOW_AD";
      
      public static const ACTION_ADD_QUEST_COINS:String = "ADD_QUEST_COINS";
      
      public static const ACTION_ADD_SKIN:String = "ADD_SKIN";
      
      public static const ACTION_RAIDS_REWARD_CLAIMED:String = "RAIDS_RAID_REWARD_CLAIMED";
      
      public static const ACTION_AUCTION_CLAIM_CARD_WON:String = "AUCTION_CLAIM_CARD_WON";
      
      public static const ACTION_AUCTION_CLAIM_CARD_NOT_SOLD:String = "AUCTION_CLAIM_CARD_NOT_SOLD";
      
      public static const ACTION_AUCTION_INFO_AUCTION_SOLD:String = "AUCTION_INFO_AUCTION_SOLD";
      
      public static const ACTION_AUCTION_INFO_AUCTION_LOST:String = "AUCTION_INFO_AUCTION_LOST";
      
      public static const ACTION_AUCTION_TIME_INCORRECT:String = "AUCTION_TIME_INCORRECT";
      
      private var mCurrentPurchaseProdId:String;
      
      private var mProductExtraInformation:String;
      
      private var mUserReceivedItems:Boolean = false;
      
      private var mPriceLocale:String = "";
      
      public function FSTracker()
      {
         super();
         if(!FSTracker.mAllowInstance)
         {
            throw new Error("ERROR: SoundManager Error: Instantiation failed: Use SoundManager.getInstance() instead of new.");
         }
      }
      
      public static function getInstance() : FSTracker
      {
         if(FSTracker.mInstance == null)
         {
            FSTracker.mAllowInstance = true;
            FSTracker.mInstance = new FSTracker();
            FSTracker.mAllowInstance = false;
         }
         return FSTracker.mInstance;
      }
      
      public static function trackStarsRewardClaimed(param1:StarsRewardsDef) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.sku = param1.getSku();
         _loc2_.starsAmount = param1.getStarsAmount();
         _loc2_.packSku = param1.getPackSku();
         trackMiscAction(CATEGORY_STARS_REWARD,ACTION_CLAIMED,_loc2_);
      }
      
      public static function trackDailyRewardClaimed(param1:DailyRewardDef, param2:Boolean = false) : void
      {
         var _loc3_:Object = new Object();
         _loc3_.index = param1.getDay();
         _loc3_.type = param1.getType();
         _loc3_.raidPoints = param1.getRaidCoins();
         if(_loc3_.type == DailyReward.TYPE_GOLD)
         {
            _loc3_.gold = param1.getGold();
         }
         if(_loc3_.type == DailyReward.TYPE_QUEST_COINS)
         {
            _loc3_.questCoins = param1.getQuestCoins();
         }
         var _loc4_:String = param2 ? CATEGORY_OLD_PLAYER_DAILY_REWARD : CATEGORY_DAILY_REWARD;
         trackMiscAction(_loc4_,ACTION_CLAIMED,_loc3_);
      }
      
      public static function trackMiscAction(param1:String, param2:String, param3:Object = null) : void
      {
         var _loc4_:Object = null;
         if(smUserActions == null)
         {
            smUserActions = new Array();
         }
         if(smUserActions.length < 10)
         {
            _loc4_ = processMiscAction(param1,param2,param3,false);
            _loc4_.when = InstanceMng.getServerConnection() ? InstanceMng.getServerConnection().getRequestDateObject() : new Date().time;
            smUserActions.push(_loc4_);
         }
         else if(InstanceMng.getServerConnection())
         {
            InstanceMng.getServerConnection().addUserActionBlock();
         }
      }
      
      private static function processMiscAction(param1:String, param2:String, param3:Object, param4:Boolean = true) : Object
      {
         var _loc6_:String = null;
         var _loc5_:Object = new Object();
         _loc5_.category = param1;
         _loc5_.action = param2;
         var _loc7_:String = "";
         for(_loc6_ in param3)
         {
            _loc7_ += _loc7_ == "" ? _loc6_ + ":" + param3[_loc6_] : ", " + _loc6_ + ":" + param3[_loc6_];
         }
         _loc5_.data = _loc7_;
         if(Boolean(InstanceMng.getServerConnection()) && param4)
         {
            _loc5_ = InstanceMng.getServerConnection().addCommonEntityAttributes(_loc5_);
         }
         return _loc5_;
      }
      
      public static function getLevelCategoryByDifficulty() : String
      {
         var _loc1_:String = null;
         var _loc2_:int = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
         switch(_loc2_)
         {
            case UserDataMng.DIFFICULTY_EASY:
               _loc1_ = CATEGORY_LEVELS;
               break;
            case UserDataMng.DIFFICULTY_MEDIUM:
               _loc1_ = CATEGORY_MEDIUM_LEVELS;
               break;
            case UserDataMng.DIFFICULTY_HARD:
               _loc1_ = CATEGORY_HARD_LEVELS;
               break;
            default:
               _loc1_ = CATEGORY_LEVELS;
         }
         return _loc1_;
      }
      
      public static function trackFirebaseEvent(param1:String, param2:Array = null, param3:Array = null) : void
      {
         InstanceMng.getApplication().trackFirebaseEvent(param1,param2,param3);
      }
      
      public static function trackPurchaseFirebase(param1:Number, param2:String) : void
      {
         InstanceMng.getApplication().trackPurchaseFirebase(param1,param2);
      }
      
      public function trackPurchase(param1:String, param2:String = "", param3:Boolean = true, param4:String = "") : void
      {
         this.mCurrentPurchaseProdId = param1;
         this.mProductExtraInformation = param2;
         this.mUserReceivedItems = param3;
         this.mPriceLocale = param4;
         var _loc5_:String = this.mProductExtraInformation != null && this.mProductExtraInformation != "" ? this.mCurrentPurchaseProdId + " (" + this.mProductExtraInformation + ")" : this.mCurrentPurchaseProdId;
         this.trackPurchaseForAppsManager(_loc5_,this.mPriceLocale,ServerConnection.smServerTimeMS,this.mProductExtraInformation,this.mUserReceivedItems);
         var _loc6_:String = FSInAppsManager.smCurrencySymbol;
         var _loc7_:Number = Number(param4.replace(_loc6_,""));
         trackPurchaseFirebase(_loc7_,param1);
      }
      
      public function trackQuestItemPurchase(param1:String, param2:String = "", param3:String = "") : void
      {
         this.mCurrentPurchaseProdId = param1;
         this.mPriceLocale = param2;
         var _loc4_:String = this.mProductExtraInformation != null && this.mProductExtraInformation != "" ? this.mCurrentPurchaseProdId + " - " + this.mProductExtraInformation : this.mCurrentPurchaseProdId;
         this.trackQuestItemPurchaseForAppsManager(_loc4_,this.mPriceLocale,param3,ServerConnection.smServerTimeMS,this.mProductExtraInformation,this.mUserReceivedItems);
      }
      
      public function trackRaidsPackPurchase(param1:String, param2:String = "", param3:String = "") : void
      {
         this.mCurrentPurchaseProdId = param1;
         this.mPriceLocale = param2;
         var _loc4_:String = this.mProductExtraInformation != null && this.mProductExtraInformation != "" ? this.mCurrentPurchaseProdId + " - " + this.mProductExtraInformation : this.mCurrentPurchaseProdId;
         this.trackRaidsPackPurchaseForAppsManager(_loc4_,this.mPriceLocale,param3,ServerConnection.smServerTimeMS,this.mProductExtraInformation,this.mUserReceivedItems);
      }
      
      public function trackOfferGoldPurchase(param1:String, param2:int) : void
      {
         this.trackOfferGoldPurchaseForAppsManager(param1,param2);
      }
      
      private function trackPurchaseForAppsManager(param1:String, param2:String, param3:Number, param4:String, param5:Boolean) : void
      {
         if(Boolean(InstanceMng.getServerConnection()) && Boolean(InstanceMng.getServerConnection().isUserLoggedIn()) && Boolean(InstanceMng.getServerConnection().getBackendUserProfile()))
         {
            InstanceMng.getServerConnection().addUserPurchaseInstance(param1,param2,new Date(param3).toString(),param4,param5,param3);
         }
         else
         {
            if(InstanceMng.getServerConnection())
            {
               InstanceMng.getServerConnection().refreshServerTime();
            }
            TweenMax.delayedCall(3,this.trackPurchaseForAppsManager,[param1,param2,param3,param4,param5]);
         }
      }
      
      private function trackQuestItemPurchaseForAppsManager(param1:String, param2:String, param3:String, param4:Number, param5:String, param6:Boolean) : void
      {
         if(Boolean(InstanceMng.getServerConnection()) && Boolean(InstanceMng.getServerConnection().isUserLoggedIn()) && Boolean(InstanceMng.getServerConnection().getBackendUserProfile()))
         {
            InstanceMng.getServerConnection().addQuestShopPurchaseInstance(param1,param2,param3,new Date(param4).toString(),param6,param4);
         }
         else
         {
            if(InstanceMng.getServerConnection())
            {
               InstanceMng.getServerConnection().refreshServerTime();
            }
            TweenMax.delayedCall(3,this.trackQuestItemPurchaseForAppsManager,[param1,param2,param3,param4,param5,param6]);
         }
      }
      
      private function trackRaidsPackPurchaseForAppsManager(param1:String, param2:String, param3:String, param4:Number, param5:String, param6:Boolean) : void
      {
         if(Boolean(InstanceMng.getServerConnection()) && Boolean(InstanceMng.getServerConnection().isUserLoggedIn()) && Boolean(InstanceMng.getServerConnection().getBackendUserProfile()))
         {
            InstanceMng.getServerConnection().addRaidsShopPackPurchaseInstance(param1,param2,param3,new Date(param4).toString(),param6,param4);
         }
         else
         {
            if(InstanceMng.getServerConnection())
            {
               InstanceMng.getServerConnection().refreshServerTime();
            }
            TweenMax.delayedCall(3,this.trackRaidsPackPurchaseForAppsManager,[param1,param2,param3,param4,param5,param6]);
         }
      }
      
      private function trackOfferGoldPurchaseForAppsManager(param1:String, param2:int) : void
      {
         if(Boolean(InstanceMng.getServerConnection()) && Boolean(InstanceMng.getServerConnection().isUserLoggedIn()) && Boolean(InstanceMng.getServerConnection().getBackendUserProfile()))
         {
            InstanceMng.getServerConnection().addPackPurchasedInstance(param1,param2,param1,PacksDefMng.PACK_SHOP);
         }
         else
         {
            if(InstanceMng.getServerConnection())
            {
               InstanceMng.getServerConnection().refreshServerTime();
            }
            TweenMax.delayedCall(3,this.trackOfferGoldPurchaseForAppsManager,[param1,param2]);
         }
      }
   }
}

