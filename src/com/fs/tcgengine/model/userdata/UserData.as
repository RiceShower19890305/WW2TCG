package com.fs.tcgengine.model.userdata
{
   import com.adobe.utils.DictionaryUtil;
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.BoostsMng;
   import com.fs.tcgengine.controller.FSFacebookPlugin;
   import com.fs.tcgengine.controller.GuildsMng;
   import com.fs.tcgengine.controller.JobsMng;
   import com.fs.tcgengine.controller.QuestsMng;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.controller.rules.CategoriesDefMng;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.battle.BattleEnginePvP;
   import com.fs.tcgengine.model.boosts.Boost;
   import com.fs.tcgengine.model.quests.Quest;
   import com.fs.tcgengine.model.rules.AuctionTicketDef;
   import com.fs.tcgengine.model.rules.BoostDef;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.HeroCharacterDef;
   import com.fs.tcgengine.model.rules.JobDef;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.model.rules.PackDef;
   import com.fs.tcgengine.model.rules.PortraitDef;
   import com.fs.tcgengine.model.rules.PowerDef;
   import com.fs.tcgengine.model.rules.QuestDef;
   import com.fs.tcgengine.model.rules.RankDef;
   import com.fs.tcgengine.model.rules.RewardDef;
   import com.fs.tcgengine.model.rules.ShopBoostDef;
   import com.fs.tcgengine.model.rules.StarsRewardsDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.screens.FSMenuScreen;
   import com.fs.tcgengine.screens.FSPvPScreen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.TimerUtil;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.popups.player.PlayerPortrait;
   import com.fs.tcgengine.view.misc.DeckCardsPanel;
   import com.fs.tcgengine.view.misc.DeckJobConfigurator;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   import flash.utils.Dictionary;
   import starling.textures.Texture;
   
   public class UserData implements FSModelUnloadableInterface
   {
      
      private static const FLAGS_SOUND:String = "sound";
      
      private static const FLAGS_MUSIC:String = "music";
      
      private static const FLAGS_SOUND_VOL:String = "soundVolume";
      
      private static const FLAGS_MUSIC_VOL:String = "musicVolume";
      
      private static const FLAGS_FREE_BOOST:String = "freeboost";
      
      private static const FLAGS_30_CARDS_POPUP_SHOWN:String = "30CardsPopupShown";
      
      private static const FLAGS_DECK_BUILDER_TUTORIAL_SHOWN:String = "deckBuilderTutorialShown";
      
      private static const FLAGS_250_GOLD_POPUP_SHOWN:String = "250GoldPopupShown";
      
      private static const FLAGS_RATE_POPUP_SHOWN:String = "RatePopupShown";
      
      private static const FLAGS_CHAT:String = "chat";
      
      private static const FLAGS_POSTING_ON_FB:String = "fbPosting";
      
      private static const FLAGS_TUTORIAL_REWARD1:String = "tutorialReward1";
      
      private static const FLAGS_TUTORIAL_REWARD2:String = "tutorialReward2";
      
      private static const FLAGS_FIRST_CHANGE_NAME:String = "firstChangeName";
      
      private static const FLAGS_CHANGE_NICK_PROMPT:String = "changeNickPromptMS";
      
      private static const FLAGS_AUCTION_HOUSE_FIRST_TIME:String = "auctionHouseFirsTime";
      
      private static const FLAGS_OFFLINE_PUSH_NOTIFS:String = "offlinePushNotifs";
      
      private static const FLAGS_ONLINE_PUSH_NOTIFS:String = "onlinePushNotifs";
      
      private static const FLAGS_SPEED_FACTOR:String = "speedFactor";
      
      private static const FLAGS_AP_LEFT_WARNING:String = "apLeftWarning";
      
      private static const FLAGS_DIFFICULTY_MEDIUM_UNLOCKED:String = "diffMediumUnlocked";
      
      private static const FLAGS_DIFFICULTY_HARD_UNLOCKED:String = "diffHardUnlocked";
      
      private static const FLAGS_VIBRATION:String = "vibration";
      
      private static const FLAGS_REFERRAL_CODE_REDEEMED:String = "referralCodeRedeemed";
      
      private static const FLAGS_REFERRAL_POPUP_SHOWN:String = "referralPopupShown";
      
      private static const FLAGS_FB_FRIENDS_ALLOWED:String = "fbFriendsAllowed";
      
      private static const FLAGS_SHARE_INFO_TO_GUILD:String = "shareInfoToGuild";
      
      private static const FLAGS_SHOW_DEFAULT_AVATAR:String = "showDefaultAvatar";
      
      private static const FLAGS_SHOW_LIGHT_FX:String = "showLightFX";
      
      private static const FLAGS_MAP_SELECTOR_POPUP_SHOWN:String = "mapSelectorPopupShown";
      
      private static const FLAGS_SCREEN_SHAKE:String = "screenShake";
      
      private static const FLAGS_NEW_BGS:String = "useNewBGs";
      
      private static const FLAGS_RAIDS_TUTORIAL_SEEN:String = "raidsTutorialSeen";
      
      private static const FLAGS_CRAFT_TUTORIAL_SEEN:String = "craftTutorialSeen";
      
      public static const TUTORIAL_DECK_INDEX:int = Config.getConfig().getMaxDecksAmount();
      
      public static const WORLD_DEFAULT:int = 0;
      
      private var mAccountId:String;
      
      private var mAccountCreationTime:Number;
      
      private var mExtId:String;
      
      private var mExtPlatform:int;
      
      private var mName:String;
      
      private var mCityName:String;
      
      private var mLocale:String;
      
      private var mPhotoUrl:String;
      
      private var mPhoto:Texture;
      
      private var mDecks:Dictionary;
      
      private var mDecksArr:Array;
      
      private var mCardCollection:Dictionary;
      
      private var mCardCollectionArr:Array;
      
      private var mNewCardsCollection:Dictionary;
      
      private var mNewCardsCollectionArr:Array;
      
      private var mFavouritesCollection:Dictionary;
      
      private var mFavouritesCollectionArr:Array;
      
      private var mAuctionIdCreatedArr:Array;
      
      private var mAuctionIdBiddedArr:Array;
      
      private var mIsOwner:Boolean;
      
      private var mCurrentDifficulty:int;
      
      private var mCurrentLevelSku:String;
      
      private var mCurrentLevelIndex:int;
      
      private var mCurrentLevelMediumSku:String;
      
      private var mCurrentLevelMediumIndex:int;
      
      private var mCurrentLevelHardSku:String;
      
      private var mCurrentLevelHardIndex:int;
      
      private var mProgressResetDate:Number;
      
      private var mFlags:Dictionary;
      
      private var mTutorialsSeen:Dictionary;
      
      private var mLevelsFailedInfo:Dictionary;
      
      private var mLevelsFailedFirebase:Dictionary;
      
      private var mGold:FSNumber;
      
      private var mQuestsCoins:FSNumber;
      
      private var mRaidCoins:FSNumber;
      
      private var mExp:Number;
      
      private var mBoostsCatalog:Dictionary;
      
      private var mDeckNames:Dictionary;
      
      private var mSelectedDeckIndex:int;
      
      private var mSelectedDeckIndexPvP:int;
      
      private var mRankIndex:int;
      
      private var mPreBoostsCatalog:Dictionary;
      
      private var mPostBoost:Boost;
      
      private var mLives:int;
      
      private var mLostLiveTimeMS:Number;
      
      private var mCurrentDateMS:Number;
      
      private var mFinishedLastCampaignTimeMs:Number;
      
      private var mDecksPurchasedAmount:int;
      
      private var mElo:int;
      
      private var mMatchesLost:int;
      
      private var mMatchesWon:int;
      
      private var mMatchesPlayed:int;
      
      private var mPvPCurrentLeague:int;
      
      private var mPvPBestLeague:int;
      
      private var mDungeonsLost:int;
      
      private var mDungeonsWon:int;
      
      private var mDungeonsPlayed:int;
      
      private var mDungeonsSeason:int;
      
      private var mComicsRead:Dictionary;
      
      private var mHighestMapsUnlockedIndex:int;
      
      private var mAvailablePortraits:Dictionary;
      
      private var mCurrentPortraitSku:String;
      
      private var mAvailableSkins:Dictionary;
      
      private var mCurrentSkinSku:String;
      
      private var mPvPSeason:int;
      
      private var mDailyRewardsTimeMS:Number;
      
      private var mDailyRewardsClaimedIndex:Number;
      
      private var mOldPlayerComingBackDailyRewardsTimeMS:Number;
      
      private var mOldPlayerComingBackDailyRewardsClaimedIndex:Number;
      
      private var mLastLevelPlayed:String;
      
      private var mLastLevelMediumPlayed:String;
      
      private var mLastLevelHardPlayed:String;
      
      private var mPurchasesAmount:int = 0;
      
      private var mReferralCode:String;
      
      private var mTransferCode:String;
      
      private var mReferrals:Array;
      
      private var mIsInBlackList:Boolean;
      
      private var mIsInDuplicatedList:Boolean;
      
      private var mIsVIP:Boolean;
      
      private var mIsDev:Boolean;
      
      private var mIsOldPlayerComingBack:Boolean;
      
      protected var mNotificationsReceived:Array;
      
      private var mTopScoresCatalog:Dictionary;
      
      private var mBadgesCollection:Dictionary;
      
      private var mBadgesRewardsClaimed:Dictionary;
      
      private var mStarsRewardsClaimed:Dictionary;
      
      private var mLanguageLocale:String;
      
      private var mQuestsCompleted:Dictionary;
      
      private var mQuestsClaimed:Dictionary;
      
      private var mQuestsProgress:Dictionary;
      
      private var mQuestsNotifiedAsCompleted:Dictionary;
      
      private var mDailyKeyTime:FSNumber;
      
      private var mMonthNumber:FSNumber;
      
      private var mWeekNumber:FSNumber;
      
      private var mRaidTicketsSP:FSNumber;
      
      private var mRaidTicketsMP:FSNumber;
      
      private var mRaidsUnlockedArray:Array;
      
      private var mAuctionTickets:FSNumber;
      
      private var mUniquePacksArr:Array;
      
      private var mBotsPlayedSession:int;
      
      private var mExtraLivesBoostDef:BoostDef;
      
      private var mAvailableJobs:Dictionary;
      
      private var mCustomOfferShown:String = "";
      
      private var mCustomOfferShownArr:Array;
      
      private var mCustomOffersViewsCount:Dictionary;
      
      private var mCustomOfferNextVisibleDateMS:Number = 0;
      
      private var mCustomOffersPurchased:Dictionary;
      
      private var mCustomOfferNewBannerShown:Boolean = false;
      
      private var mMapWorldChoices:Dictionary;
      
      private var mBattlePass:String;
      
      private var mLevelAttempts:int;
      
      private var mFirstFirebaseDBTrack:Number;
      
      private var mGuildMemberId:String;
      
      private var mGuildId:String;
      
      private var mGuildRank:int;
      
      private var mGuildJoinDateMS:Number;
      
      private var mGuildLastActivityDateMS:Number;
      
      private var mGuildWeeklyPvPScore:FSNumber;
      
      private var mGuildWeeklyDungeonsScore:FSNumber;
      
      private var mGuildWeeklyRaidsScore:FSNumber;
      
      private var mGuildWeeklyTotalScore:FSNumber;
      
      private var mGuildGlobalPvPScore:FSNumber;
      
      private var mGuildGlobalDungeonsScore:FSNumber;
      
      private var mGuildGlobalRaidsScore:FSNumber;
      
      private var mGuildGlobalTotalScore:FSNumber;
      
      private var mGuildCurrentWeekSeasonIndex:int;
      
      private var mGuildLastWeekSeasonIndex:int;
      
      private var mGuildLastWeekTotalScore:FSNumber;
      
      private var mJobsExperience:Array;
      
      private var mDeckJobConfigurationArr:Array;
      
      private var mPlatformVersions:Array;
      
      public function UserData()
      {
         super();
         this.mAccountId = "";
         this.mExtId = "";
         this.mProgressResetDate = 0;
         this.mExtPlatform = -1;
         this.mName = TextManager.getText("TID_GEN_PLAYER");
         if(Config.getConfig().gameHasBuildingBadges())
         {
            this.mCityName = TextManager.getText("TID_CITY_NAME");
         }
         else
         {
            this.mCityName = "";
         }
         this.mLocale = "";
         this.mPhotoUrl = "";
         DictionaryUtils.clearDictionary(this.mDecks);
         this.mDecksArr = null;
         this.mCardCollection = null;
         this.mIsOwner = false;
         this.mCurrentDifficulty = UserDataMng.DIFFICULTY_EASY;
         this.mCurrentLevelSku = "level_01";
         this.mCurrentLevelMediumSku = "level_01";
         this.mCurrentLevelHardSku = "level_01";
         this.mCurrentLevelIndex = 1;
         this.mCurrentLevelMediumIndex = 1;
         this.mCurrentLevelHardIndex = 1;
         this.mFlags = null;
         this.mTutorialsSeen = null;
         this.mLevelsFailedInfo = null;
         this.mLevelsFailedFirebase = null;
         this.setGold(0);
         this.setQuestsCoins(0);
         this.setRaidCoins(0);
         this.mExp = 0;
         DictionaryUtils.clearDictionary(this.mBoostsCatalog);
         DictionaryUtils.clearDictionary(this.mDeckNames);
         this.mSelectedDeckIndex = 0;
         this.mSelectedDeckIndexPvP = 0;
         this.mRankIndex = 1;
         this.mPreBoostsCatalog = null;
         this.mLives = Config.getConfig() ? Config.getConfig().getDefaultLives() : 5;
         this.mLostLiveTimeMS = 0;
         this.mCurrentDateMS = 0;
         this.mDecksPurchasedAmount = 0;
         this.mElo = 1000;
         this.mMatchesLost = 0;
         this.mMatchesWon = 0;
         this.mMatchesPlayed = 0;
         this.mPvPCurrentLeague = 3;
         this.mPvPBestLeague = 3;
         this.mDungeonsLost = 0;
         this.mDungeonsWon = 0;
         this.mDungeonsPlayed = 0;
         this.mComicsRead = null;
         this.mHighestMapsUnlockedIndex = 1;
         this.mFinishedLastCampaignTimeMs = 0;
         DictionaryUtils.clearDictionary(this.mAvailablePortraits);
         this.mAvailablePortraits = null;
         this.mCurrentPortraitSku = "portrait_01";
         this.addPortraitToCatalog("portrait_01");
         DictionaryUtils.clearDictionary(this.mAvailableSkins);
         this.mAvailableSkins = null;
         this.mCurrentSkinSku = "hero_01";
         this.addSkinToCatalog("hero_01");
         this.mPvPSeason = 1;
         this.mDungeonsSeason = 0;
         this.mDailyRewardsTimeMS = 0;
         this.mDailyRewardsClaimedIndex = 0;
         this.mOldPlayerComingBackDailyRewardsTimeMS = 0;
         this.mOldPlayerComingBackDailyRewardsClaimedIndex = 0;
         this.mNewCardsCollection = null;
         this.mFavouritesCollection = null;
         this.mNewCardsCollectionArr = null;
         this.mLastLevelPlayed = "";
         this.mLastLevelMediumPlayed = "";
         this.mLastLevelHardPlayed = "";
         this.mPurchasesAmount = 0;
         this.mReferralCode = "";
         this.mTransferCode = "";
         this.mReferrals = null;
         this.mIsInBlackList = false;
         this.mIsInDuplicatedList = false;
         this.mIsVIP = false;
         this.mIsDev = false;
         this.mIsOldPlayerComingBack = false;
         this.mTopScoresCatalog = null;
         this.mBadgesCollection = null;
         this.mBadgesRewardsClaimed = null;
         this.mStarsRewardsClaimed = null;
         this.mLanguageLocale = "";
         this.mGuildId = "";
         this.mGuildMemberId = "";
         this.mGuildRank = -1;
         this.mGuildJoinDateMS = -1;
         this.mGuildLastActivityDateMS = 0;
         this.mGuildCurrentWeekSeasonIndex = -1;
         this.mGuildLastWeekSeasonIndex = -1;
         this.mGuildWeeklyPvPScore = new FSNumber();
         this.mGuildWeeklyDungeonsScore = new FSNumber();
         this.mGuildWeeklyRaidsScore = new FSNumber();
         this.mGuildWeeklyTotalScore = new FSNumber();
         this.mGuildGlobalPvPScore = new FSNumber();
         this.mGuildGlobalDungeonsScore = new FSNumber();
         this.mGuildGlobalRaidsScore = new FSNumber();
         this.mGuildGlobalTotalScore = new FSNumber();
         this.mGuildLastWeekTotalScore = new FSNumber();
         this.mGuildWeeklyPvPScore.value = 0;
         this.mGuildWeeklyDungeonsScore.value = 0;
         this.mGuildWeeklyRaidsScore.value = 0;
         this.mGuildWeeklyTotalScore.value = 0;
         this.mGuildGlobalPvPScore.value = 0;
         this.mGuildGlobalDungeonsScore.value = 0;
         this.mGuildGlobalRaidsScore.value = 0;
         this.mGuildGlobalTotalScore.value = 0;
         this.mGuildLastWeekTotalScore.value = 0;
         this.mQuestsCompleted = null;
         this.mQuestsProgress = null;
         this.mQuestsClaimed = null;
         this.mQuestsNotifiedAsCompleted = null;
         this.mRaidTicketsSP = new FSNumber();
         this.mRaidTicketsMP = new FSNumber();
         this.mRaidsUnlockedArray = null;
         this.mAuctionTickets = new FSNumber();
         this.mAuctionIdCreatedArr = null;
         this.mAuctionIdBiddedArr = null;
         this.mUniquePacksArr = null;
         this.mBotsPlayedSession = 0;
         this.mLevelAttempts = 0;
         this.mFirstFirebaseDBTrack = 0;
         this.mJobsExperience = InstanceMng.getJobsDefMng().getAllJobSkus();
         this.mDeckJobConfigurationArr = null;
         this.mAvailableJobs = null;
         this.addJobToCatalog("job_01",false);
         this.mCustomOfferShown = "";
         this.mCustomOfferShownArr = null;
         this.mCustomOfferNextVisibleDateMS = 0;
         this.mCustomOffersViewsCount = null;
         this.mCustomOffersPurchased = null;
         this.mCustomOfferNewBannerShown = false;
         this.mMapWorldChoices = null;
         this.mDailyKeyTime = new FSNumber(-1);
         this.mWeekNumber = new FSNumber(-1);
         this.mMonthNumber = new FSNumber(-1);
         this.mBattlePass = "";
      }
      
      public static function getTutorialDeckIndex() : int
      {
         return Config.getConfig().getMaxDecksAmount();
      }
      
      public function getMapWorldChoice(param1:int) : int
      {
         return Boolean(this.mMapWorldChoices) && this.mMapWorldChoices[param1] != null ? int(this.mMapWorldChoices[param1]) : WORLD_DEFAULT;
      }
      
      public function setMapWorldChoice(param1:int, param2:int) : void
      {
         if(this.mMapWorldChoices == null)
         {
            this.mMapWorldChoices = new Dictionary(true);
         }
         this.mMapWorldChoices[param1] = param2;
      }
      
      public function setMapWorldChoices(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         if(param1 != null && param1 != "")
         {
            _loc2_ = param1.split(",");
            if(Boolean(_loc2_) && _loc2_.length > 0)
            {
               _loc6_ = 0;
               while(_loc6_ < _loc2_.length)
               {
                  _loc5_ = String(_loc2_[_loc6_]).split(":");
                  _loc3_ = _loc5_[0];
                  _loc4_ = int(_loc5_[1]);
                  if(this.mMapWorldChoices == null)
                  {
                     this.mMapWorldChoices = new Dictionary(true);
                  }
                  this.mMapWorldChoices[_loc3_] = _loc4_;
                  _loc6_++;
               }
            }
         }
      }
      
      public function hasAlreadyChoosenWorld(param1:int) : Boolean
      {
         return Boolean(this.mMapWorldChoices) && this.mMapWorldChoices[param1] != null && this.mMapWorldChoices[param1] != WORLD_DEFAULT;
      }
      
      public function getMapWorldChoiceToString() : String
      {
         return this.getDictionaryAttributeToString(this.mMapWorldChoices,true);
      }
      
      public function getDictionaryAttributeToString(param1:Dictionary, param2:Boolean = false) : String
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc3_:String = "";
         if(param1 != null)
         {
            _loc4_ = DictionaryUtils.getKeys(param1);
            _loc4_.sort();
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               _loc3_ += param2 ? _loc4_[_loc5_] + ":" + param1[_loc4_[_loc5_]] : String(_loc4_[_loc5_]);
               if(_loc5_ < _loc4_.length - 1)
               {
                  _loc3_ += _loc3_ != "" ? "," : "";
               }
               _loc5_++;
            }
         }
         return _loc3_;
      }
      
      public function getCurrentDifficulty() : int
      {
         return this.mCurrentDifficulty;
      }
      
      public function getAccountId() : String
      {
         return this.mAccountId;
      }
      
      public function getExtId() : String
      {
         return this.mExtId;
      }
      
      public function getExtPlatformId() : int
      {
         return this.mExtPlatform;
      }
      
      public function getName() : String
      {
         return this.mName;
      }
      
      public function getCityName() : String
      {
         return this.mCityName;
      }
      
      public function getLocale() : String
      {
         return this.mLocale;
      }
      
      public function getLanguageLocale() : String
      {
         return this.mLanguageLocale;
      }
      
      public function getJobsExperience() : Array
      {
         return this.mJobsExperience;
      }
      
      public function getPlatformVersions() : Array
      {
         return this.mPlatformVersions;
      }
      
      public function getGuildId() : String
      {
         return this.mGuildId;
      }
      
      public function getGuildMemberId() : String
      {
         return this.mGuildMemberId;
      }
      
      public function getGuildRank() : int
      {
         return this.mGuildRank;
      }
      
      public function getGuildJoinDateMS() : Number
      {
         return this.mGuildJoinDateMS;
      }
      
      public function getGuildLastActivityDateMS() : Number
      {
         return this.mGuildLastActivityDateMS;
      }
      
      public function getGuildWeeklyPvPScore() : Number
      {
         return this.mGuildWeeklyPvPScore ? this.mGuildWeeklyPvPScore.value : 0;
      }
      
      public function getGuildWeeklyDungeonsScore() : Number
      {
         return this.mGuildWeeklyDungeonsScore ? this.mGuildWeeklyDungeonsScore.value : 0;
      }
      
      public function getGuildWeeklyRaidsScore() : Number
      {
         return this.mGuildWeeklyRaidsScore ? this.mGuildWeeklyRaidsScore.value : 0;
      }
      
      public function getGuildWeeklyTotalScore() : Number
      {
         return this.mGuildWeeklyTotalScore ? this.mGuildWeeklyTotalScore.value : 0;
      }
      
      public function getGuildGlobalPvPScore() : Number
      {
         return this.mGuildGlobalPvPScore ? this.mGuildGlobalPvPScore.value : 0;
      }
      
      public function getGuildGlobalDungeonsScore() : Number
      {
         return this.mGuildGlobalDungeonsScore ? this.mGuildGlobalDungeonsScore.value : 0;
      }
      
      public function getGuildGlobalRaidsScore() : Number
      {
         return this.mGuildGlobalRaidsScore ? this.mGuildGlobalRaidsScore.value : 0;
      }
      
      public function getGuildGlobalTotalScore() : Number
      {
         return this.mGuildGlobalTotalScore ? this.mGuildGlobalTotalScore.value : 0;
      }
      
      public function getGuildCurrentWeekSeasonIndex() : int
      {
         return this.mGuildCurrentWeekSeasonIndex;
      }
      
      public function getGuildLastWeekSeasonIndex() : int
      {
         return this.mGuildLastWeekSeasonIndex;
      }
      
      public function getGuildLastWeekTotalScore() : Number
      {
         return this.mGuildLastWeekTotalScore ? this.mGuildLastWeekTotalScore.value : 0;
      }
      
      public function setJobsExperience(param1:Array) : void
      {
         this.mJobsExperience = param1;
      }
      
      public function setPlatformVersions(param1:Array) : void
      {
         this.mPlatformVersions = param1;
      }
      
      public function setCurrentDifficulty(param1:int) : void
      {
         this.mCurrentDifficulty = param1;
      }
      
      public function setGuildId(param1:String) : void
      {
         this.mGuildId = param1;
      }
      
      public function setGuildMemberId(param1:String) : void
      {
         this.mGuildMemberId = param1;
      }
      
      public function setGuildRank(param1:int) : void
      {
         this.mGuildRank = param1;
      }
      
      public function setGuildJoinDateMS(param1:Number) : void
      {
         this.mGuildJoinDateMS = param1;
      }
      
      public function setGuildLastActivityDateMS(param1:Number) : void
      {
         this.mGuildLastActivityDateMS = param1;
      }
      
      public function setGuildWeeklyPvPScore(param1:Number) : void
      {
         if(this.mGuildWeeklyPvPScore == null)
         {
            this.mGuildWeeklyPvPScore = new FSNumber();
         }
         if(!isNaN(param1))
         {
            this.mGuildWeeklyPvPScore.value = param1;
         }
      }
      
      public function setGuildWeeklyDungeonsScore(param1:Number) : void
      {
         if(this.mGuildWeeklyDungeonsScore == null)
         {
            this.mGuildWeeklyDungeonsScore = new FSNumber();
         }
         if(!isNaN(param1))
         {
            this.mGuildWeeklyDungeonsScore.value = param1;
         }
      }
      
      public function setGuildWeeklyRaidsScore(param1:Number) : void
      {
         if(this.mGuildWeeklyRaidsScore == null)
         {
            this.mGuildWeeklyRaidsScore = new FSNumber();
         }
         if(!isNaN(param1))
         {
            this.mGuildWeeklyRaidsScore.value = param1;
         }
      }
      
      public function setGuildWeeklyTotalScore(param1:Number) : void
      {
         if(this.mGuildWeeklyTotalScore == null)
         {
            this.mGuildWeeklyTotalScore = new FSNumber();
         }
         if(!isNaN(param1))
         {
            this.mGuildWeeklyTotalScore.value = param1;
         }
      }
      
      public function setGuildGlobalPvPScore(param1:Number) : void
      {
         if(this.mGuildGlobalPvPScore == null)
         {
            this.mGuildGlobalPvPScore = new FSNumber();
         }
         if(!isNaN(param1))
         {
            this.mGuildGlobalPvPScore.value = param1;
         }
      }
      
      public function setGuildGlobalRaidsScore(param1:Number) : void
      {
         if(this.mGuildGlobalRaidsScore == null)
         {
            this.mGuildGlobalRaidsScore = new FSNumber();
         }
         if(!isNaN(param1))
         {
            this.mGuildGlobalRaidsScore.value = param1;
         }
      }
      
      public function setGuildGlobalDungeonsScore(param1:Number) : void
      {
         if(this.mGuildGlobalDungeonsScore == null)
         {
            this.mGuildGlobalDungeonsScore = new FSNumber();
         }
         if(!isNaN(param1))
         {
            this.mGuildGlobalDungeonsScore.value = param1;
         }
      }
      
      public function setGuildGlobalTotalScore(param1:Number) : void
      {
         if(this.mGuildGlobalTotalScore == null)
         {
            this.mGuildGlobalTotalScore = new FSNumber();
         }
         if(!isNaN(param1))
         {
            this.mGuildGlobalTotalScore.value = param1;
            if(this.mIsOwner)
            {
               Utils.setStat(Constants.STAT_GUILD_COINS,param1);
            }
         }
      }
      
      public function setGuildCurrentWeekSeasonIndex(param1:int) : void
      {
         this.mGuildCurrentWeekSeasonIndex = param1;
      }
      
      public function setGuildLastWeekSeasonIndex(param1:int) : void
      {
         this.mGuildLastWeekSeasonIndex = !isNaN(param1) ? param1 : -1;
      }
      
      public function setGuildLastWeekTotalScore(param1:Number) : void
      {
         if(this.mGuildLastWeekTotalScore == null)
         {
            this.mGuildLastWeekTotalScore = new FSNumber();
         }
         this.mGuildLastWeekTotalScore.value = !isNaN(param1) ? param1 : 0;
      }
      
      public function addGuildWeeklyRaidScore(param1:Number, param2:Boolean) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         if(!isNaN(param1))
         {
            if(!this.isInBlackList() && !this.isInDuplicatedList())
            {
               _loc3_ = param2 ? Math.floor(param1 * GuildsMng.smRaidMPFactor) : Math.floor(param1 * GuildsMng.smRaidSPFactor);
               InstanceMng.getServerConnection().addScoreToLeaderboard("GUILD_RAIDS",_loc3_);
               _loc4_ = 2;
               _loc5_ = _loc3_ * _loc4_;
               _loc5_ = _loc5_ * 1.5;
               if(Config.getConfig().gameHasClassSystem())
               {
                  JobsMng.winJobExperience(_loc5_);
               }
               if(Config.getConfig().hasQuests())
               {
                  InstanceMng.getQuestsMng().addActionPerformed(QuestsMng.TARGET_TYPE_OBTAIN,_loc3_,true,[QuestsMng.TARGET_CURRENCY + ":" + Constants.CURRENCY_GUILD_POINTS]);
               }
            }
         }
      }
      
      public function addGuildWeeklyDungeonScore(param1:Number) : void
      {
         if(!isNaN(param1))
         {
            if(!this.isInBlackList() && !this.isInDuplicatedList())
            {
               InstanceMng.getServerConnection().addScoreToLeaderboard("GUILD_DUNGEONS",param1);
               if(Config.getConfig().hasQuests())
               {
                  InstanceMng.getQuestsMng().addActionPerformed(QuestsMng.TARGET_TYPE_OBTAIN,param1,true,[QuestsMng.TARGET_CURRENCY + ":" + Constants.CURRENCY_GUILD_POINTS]);
               }
            }
         }
      }
      
      public function addGuildWeeklyPvPScore(param1:Number) : void
      {
         FSDebug.debugTrace("Adding guild weekly pvp score to user...");
         if(!isNaN(param1))
         {
            InstanceMng.getServerConnection().addScoreToLeaderboard("GUILD_PVP",param1);
            if(Config.getConfig().hasQuests())
            {
               InstanceMng.getQuestsMng().addActionPerformed(QuestsMng.TARGET_TYPE_OBTAIN,param1,true,[QuestsMng.TARGET_CURRENCY + ":" + Constants.CURRENCY_GUILD_POINTS]);
            }
         }
      }
      
      public function getLastLevelPlayedSku() : String
      {
         return this.mLastLevelPlayed;
      }
      
      public function setLastLevelPlayed(param1:String) : void
      {
         this.mLastLevelPlayed = param1;
      }
      
      public function getLastLevelMediumPlayedSku() : String
      {
         return this.mLastLevelMediumPlayed;
      }
      
      public function setLastLevelMediumPlayed(param1:String) : void
      {
         this.mLastLevelMediumPlayed = param1;
      }
      
      public function getLastLevelHardPlayedSku() : String
      {
         return this.mLastLevelHardPlayed;
      }
      
      public function setLastLevelHardPlayed(param1:String) : void
      {
         this.mLastLevelHardPlayed = param1;
      }
      
      public function getLastLevelPlayedSkuByDifficulty() : String
      {
         var _loc1_:String = null;
         switch(this.mCurrentDifficulty)
         {
            case UserDataMng.DIFFICULTY_EASY:
               _loc1_ = this.mLastLevelPlayed;
               break;
            case UserDataMng.DIFFICULTY_MEDIUM:
               _loc1_ = this.mLastLevelMediumPlayed;
               break;
            case UserDataMng.DIFFICULTY_HARD:
               _loc1_ = this.mLastLevelHardPlayed;
               break;
            default:
               _loc1_ = this.mLastLevelPlayed;
         }
         return _loc1_;
      }
      
      public function setLastLevelPlayedSkuByDifficulty(param1:String) : void
      {
         var _loc2_:String = null;
         switch(this.mCurrentDifficulty)
         {
            case UserDataMng.DIFFICULTY_EASY:
               this.mLastLevelPlayed = param1;
               break;
            case UserDataMng.DIFFICULTY_MEDIUM:
               this.mLastLevelMediumPlayed = param1;
               break;
            case UserDataMng.DIFFICULTY_HARD:
               this.mLastLevelHardPlayed = param1;
               break;
            default:
               this.mLastLevelPlayed = param1;
         }
      }
      
      public function resetBadgeCollection() : void
      {
         DictionaryUtils.clearDictionary(this.mBadgesCollection);
         this.mBadgesCollection = null;
      }
      
      public function addBadgeToCollection(param1:String, param2:int = 1) : void
      {
         if(this.mBadgesCollection == null)
         {
            this.mBadgesCollection = new Dictionary(true);
         }
         var _loc3_:int = InstanceMng.getRanksDefMng().getMaxAmountOfBadgesBySku(param1);
         var _loc4_:int = 0;
         if(this.mBadgesCollection[param1] != null)
         {
            _loc4_ = int(this.mBadgesCollection[param1]);
            if(_loc4_ + param2 <= _loc3_)
            {
               this.mBadgesCollection[param1] = _loc4_ + param2;
            }
            else
            {
               this.mBadgesCollection[param1] = _loc3_;
            }
         }
         else if(param2 <= _loc3_)
         {
            this.mBadgesCollection[param1] = param2;
         }
         else
         {
            this.mBadgesCollection[param1] = _loc3_;
         }
      }
      
      public function getBadgesCollection() : Dictionary
      {
         return this.mBadgesCollection;
      }
      
      public function getBadgesAmountByBadgeSku(param1:String) : int
      {
         var _loc2_:int = 0;
         if(this.mBadgesCollection)
         {
            _loc2_ = int(this.mBadgesCollection[param1]);
         }
         return _loc2_;
      }
      
      public function getBadgesCollectionToString() : String
      {
         return this.getDictionaryAttributeToString(this.mBadgesCollection,true);
      }
      
      public function getScoreByLevelSku(param1:String) : int
      {
         var _loc2_:int = 0;
         if(Boolean(param1 != null) && Boolean(this.mTopScoresCatalog) && this.mTopScoresCatalog[param1] != null)
         {
            _loc2_ = int(this.mTopScoresCatalog[param1]);
         }
         return _loc2_;
      }
      
      public function setTopScoreByLevelSku(param1:String, param2:int) : void
      {
         if(this.mTopScoresCatalog == null)
         {
            this.mTopScoresCatalog = new Dictionary(true);
         }
         this.mTopScoresCatalog[param1] = param2;
      }
      
      public function getTopScores() : Dictionary
      {
         return this.mTopScoresCatalog;
      }
      
      public function setTopScores(param1:Dictionary) : void
      {
         this.mTopScoresCatalog = param1;
      }
      
      public function resetTopScores() : void
      {
         DictionaryUtils.clearDictionary(this.mTopScoresCatalog);
         this.mTopScoresCatalog = null;
      }
      
      public function get3StarLevelsCompleted() : int
      {
         var _loc2_:LevelDef = null;
         var _loc3_:int = 0;
         var _loc1_:Dictionary = InstanceMng.getLevelsDefMng().getAllDefs();
         var _loc4_:int = 0;
         var _loc5_:UserData = Utils.getOwnerUserData();
         var _loc6_:int = _loc5_ ? _loc5_.getCurrentDifficulty() : 0;
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_)
            {
               _loc3_ = this.getScoreByLevelSku(_loc2_.getSku());
               _loc4_ += !_loc2_.isPvPLevel() && _loc3_ >= _loc2_.getMaxScoreByDifficulty(_loc6_) ? 1 : 0;
            }
         }
         return _loc4_;
      }
      
      public function getPhotoUrl() : String
      {
         var _loc1_:BattleEngine = null;
         var _loc2_:String = null;
         if(this.mIsOwner && this.flagsShowDefaultAvatar())
         {
            return "";
         }
         if(this.mIsOwner)
         {
            if(Utils.isDesktop())
            {
               return this.mPhotoUrl;
            }
            if(InstanceMng.getApplication().isKongregateVersion())
            {
               this.mPhotoUrl = InstanceMng.getApplication().getKongAvatarURL();
            }
            else if(InstanceMng.getFacebookPlugin())
            {
               this.mExtId = this.mExtId != null && this.mExtId != "" ? this.mExtId : "sample";
               this.mPhotoUrl = FSFacebookPlugin.FACEBOOK_GRAPH_PREFIX + this.mExtId + PlayerPortrait.FACEBOOK_PIC_SUFFIX;
            }
            return this.mPhotoUrl;
         }
         _loc1_ = InstanceMng.getBattleEngine();
         if(_loc1_ is BattleEnginePvP)
         {
            _loc2_ = this.mIsOwner ? "_portrait" : "";
            return "player_2_photo" + _loc2_;
         }
         return this.mPhotoUrl;
      }
      
      public function setAccountId(param1:String) : void
      {
         this.mAccountId = param1;
      }
      
      public function setExtId(param1:String) : void
      {
         this.mExtId = param1;
      }
      
      public function setExtPlatform(param1:int) : void
      {
         this.mExtPlatform = param1;
      }
      
      public function setName(param1:String) : void
      {
         this.mName = param1 ? param1 : Utils.generateRandomUserName();
      }
      
      public function setCityName(param1:String) : void
      {
         this.mCityName = param1;
      }
      
      public function setLocale(param1:String) : void
      {
         this.mLocale = param1;
      }
      
      public function setLanguageLocale(param1:String) : void
      {
         TextManager.loadLang(param1);
         this.mLanguageLocale = param1;
         FSResourceMng.smCurrentLocaleSelected = this.mLanguageLocale;
         if(InstanceMng.getApplication().mapScreenHasBeenVisited())
         {
            Root.onLocaleChangedRefreshStyles();
         }
         if(InstanceMng.getCurrentScreen() != null && InstanceMng.getCurrentScreen() is FSMenuScreen)
         {
            FSMenuScreen(InstanceMng.getCurrentScreen()).updateButtonsTexts();
         }
      }
      
      public function setPhotoUrl(param1:String) : void
      {
         if(param1 != null)
         {
            this.mPhotoUrl = param1;
         }
      }
      
      public function getRankIndex() : int
      {
         return this.mRankIndex;
      }
      
      public function getRankDef() : RankDef
      {
         return RankDef(InstanceMng.getRanksDefMng().getDefByIndex(this.mRankIndex));
      }
      
      public function getPreBoosts() : Dictionary
      {
         return this.mPreBoostsCatalog;
      }
      
      public function addPreBoost(param1:String) : void
      {
         if(this.mPreBoostsCatalog == null)
         {
            this.mPreBoostsCatalog = new Dictionary(true);
         }
         this.mPreBoostsCatalog[param1] = 1;
      }
      
      public function removePreBoost(param1:String) : void
      {
         var _loc2_:int = 0;
         if(this.mPreBoostsCatalog != null)
         {
            if(this.mPreBoostsCatalog[param1] != null)
            {
               delete this.mPreBoostsCatalog[param1];
            }
         }
      }
      
      public function getPostBoost() : Boost
      {
         return this.mPostBoost;
      }
      
      public function setPostBoost(param1:Boost) : void
      {
         this.mPostBoost = param1;
      }
      
      public function getDeck(param1:int) : Dictionary
      {
         var _loc2_:Dictionary = null;
         if(this.mDecks != null)
         {
            _loc2_ = this.mDecks[param1];
         }
         FSDebug.debugTrace("Getting the Deck with index: " + param1);
         return _loc2_;
      }
      
      public function getDefaultPowerSku(param1:int) : String
      {
         var _loc2_:String = null;
         var _loc3_:DeckJobConfigurator = null;
         var _loc4_:JobDef = null;
         var _loc5_:String = null;
         var _loc6_:PowerDef = null;
         if(Config.getConfig().gameHasPowers())
         {
            if(Config.getConfig().gameHasClassSystem())
            {
               _loc3_ = InstanceMng.getUserDataMng().getOwnerUserData().getDeckJobConfiguratorByDeck(param1);
               if(_loc3_)
               {
                  _loc4_ = JobDef(InstanceMng.getJobsDefMng().getDefBySku(_loc3_.getJobSku()));
                  _loc2_ = _loc4_.getActiveDefaultSku();
               }
            }
            else
            {
               _loc5_ = this.getPowerSkuByDeck(param1);
               if(_loc5_ != null && _loc5_ != "")
               {
                  return _loc5_;
               }
               _loc6_ = this.getBestPowerDefOnCollection();
               _loc2_ = _loc6_.getSku();
            }
         }
         return _loc2_;
      }
      
      public function setDeck(param1:Array, param2:int) : void
      {
         var _loc5_:String = null;
         var _loc6_:DeckJobConfigurator = null;
         if(this.mDecks == null)
         {
            this.mDecks = new Dictionary(true);
         }
         delete this.mDecks[param2];
         var _loc3_:Boolean = this.getIsOwner();
         this.mDecks[param2] = DictionaryUtils.addCards(param1,this.mDecks[param2],true,Config.getConfig().getDeckCardsAmount(),_loc3_,this.mCardCollection);
         if(this.mDecksArr == null)
         {
            this.mDecksArr = new Array();
         }
         if(Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
         {
            if(Config.getConfig().gameHasClassSystem())
            {
               _loc5_ = InstanceMng.getUserDataMng().getOwnerUserData().getPowerSkuByDeck(param2);
               _loc6_ = InstanceMng.getUserDataMng().getOwnerUserData().getDeckJobConfiguratorByDeck(param2);
               if(_loc6_)
               {
                  _loc6_.setActiveAbilitySku(_loc5_);
                  InstanceMng.getUserDataMng().getOwnerUserData().setDeckJobConfigurator(_loc6_);
               }
            }
         }
         var _loc4_:String = this.getOwnerDeckToString(param2);
         this.mDecksArr[param2] = _loc4_ != "" ? _loc4_.split(",") : null;
      }
      
      public function updateDeckPower(param1:String, param2:int) : void
      {
         var _loc5_:String = null;
         var _loc6_:int = 0;
         if(this.mDecks == null)
         {
            this.mDecks = new Dictionary(true);
         }
         var _loc3_:Dictionary = this.mDecks[param2];
         var _loc4_:Array = DictionaryUtil.getKeys(_loc3_);
         _loc6_ = 0;
         while(_loc6_ < _loc4_.length)
         {
            _loc5_ = _loc4_[_loc6_];
            if(_loc5_.indexOf("power") != -1)
            {
               delete this.mDecks[param2][_loc4_[_loc6_]];
               break;
            }
            _loc6_++;
         }
         this.mDecks[param2] = DictionaryUtils.addCards([param1 + ":1"],this.mDecks[param2],true,Config.getConfig().getDeckCardsAmount(),true,this.mCardCollection);
         if(this.mDecksArr == null)
         {
            this.mDecksArr = new Array();
         }
         var _loc7_:String = this.getOwnerDeckToString(param2);
         this.mDecksArr[param2] = _loc7_ != "" ? _loc7_.split(",") : null;
      }
      
      public function getPowerSkuByDeck(param1:int) : String
      {
         var _loc3_:Dictionary = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc2_:String = "";
         if(this.mDecks != null)
         {
            _loc3_ = this.mDecks[param1];
            _loc4_ = DictionaryUtil.getKeys(_loc3_);
            _loc6_ = 0;
            while(_loc6_ < _loc4_.length)
            {
               _loc5_ = _loc4_[_loc6_];
               if(_loc5_.indexOf("power") != -1)
               {
                  return _loc5_;
               }
               _loc6_++;
            }
         }
         return _loc2_;
      }
      
      public function importDeck(param1:Dictionary, param2:int) : void
      {
         if(this.mDecks == null)
         {
            this.mDecks = new Dictionary(true);
         }
         if(this.mDecks != null)
         {
            this.mDecks[param2] = param1;
         }
      }
      
      public function getAuctionIdCreatedArr() : Array
      {
         return this.mAuctionIdCreatedArr;
      }
      
      public function getAuctionIdBiddedArr() : Array
      {
         return this.mAuctionIdBiddedArr;
      }
      
      public function getUniquePacksArr() : Array
      {
         return this.mUniquePacksArr;
      }
      
      private function existPackSkuInUniquePacksArr(param1:String) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         if(Boolean(this.mUniquePacksArr) && this.mUniquePacksArr.length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < this.mUniquePacksArr.length)
            {
               if(this.mUniquePacksArr[_loc3_] == param1)
               {
                  _loc2_ = true;
                  break;
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      public function canActivatePack(param1:Def) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:Array = null;
         var _loc4_:Boolean = false;
         if(param1 is PackDef)
         {
            _loc4_ = PackDef(param1).isUniquePack();
         }
         else if(param1 is AuctionTicketDef)
         {
            _loc4_ = AuctionTicketDef(param1).getIsUniquePack();
         }
         if(_loc4_)
         {
            if(!this.existPackSkuInUniquePacksArr(param1.getSku()))
            {
               _loc2_ = true;
            }
         }
         else
         {
            _loc2_ = true;
         }
         return _loc2_;
      }
      
      public function setUniquePacksArr(param1:Array) : void
      {
         if(Boolean(param1) && param1.length > 0)
         {
            this.mUniquePacksArr = param1;
         }
         else
         {
            this.mUniquePacksArr = null;
         }
      }
      
      public function setAuctionIdCreatedArr(param1:Array) : void
      {
         if(Boolean(param1) && param1.length > 0)
         {
            this.mAuctionIdCreatedArr = param1;
         }
         else
         {
            this.mAuctionIdCreatedArr = null;
         }
      }
      
      public function setAuctionIdBiddedArr(param1:Array) : void
      {
         if(Boolean(param1) && param1.length > 0)
         {
            this.mAuctionIdBiddedArr = param1;
         }
         else
         {
            this.mAuctionIdBiddedArr = null;
         }
      }
      
      public function getNewCardsCollection() : Dictionary
      {
         return this.mNewCardsCollection;
      }
      
      public function setNewCardsCollection(param1:Array) : void
      {
         this.mNewCardsCollectionArr = param1;
         this.mNewCardsCollection = DictionaryUtils.addCards(param1,this.mNewCardsCollection,false);
      }
      
      public function resetNewCardsCollection() : void
      {
         DictionaryUtils.clearDictionary(this.mNewCardsCollection);
         this.mNewCardsCollection = null;
         this.mNewCardsCollectionArr = null;
      }
      
      public function getFavouritesCollection() : Dictionary
      {
         return this.mFavouritesCollection;
      }
      
      public function setFavouritesCollection(param1:Array) : void
      {
         this.mFavouritesCollectionArr = param1;
         this.mFavouritesCollection = DictionaryUtils.addCards(param1,this.mFavouritesCollection,false);
      }
      
      public function resetFavouritesCollection() : void
      {
         DictionaryUtils.clearDictionary(this.mFavouritesCollection);
         this.mFavouritesCollection = null;
         this.mFavouritesCollectionArr = null;
      }
      
      public function getCardCollection() : Dictionary
      {
         return this.mCardCollection;
      }
      
      public function getCollectionFilteredByCategory(param1:int) : Dictionary
      {
         return DictionaryUtils.getCatalogFilteredByCategory(this.mCardCollection,param1);
      }
      
      public function getDeckFilteredByCategory(param1:int, param2:int) : Dictionary
      {
         return DictionaryUtils.getCatalogFilteredByCategory(this.getDeck(param1),param2);
      }
      
      public function getDeckFilteredByFaction(param1:int, param2:String) : Dictionary
      {
         return DictionaryUtils.getCatalogFilteredByFaction(this.getDeck(param1),param2);
      }
      
      public function setCardCollection(param1:Array) : void
      {
         var _loc2_:int = 0;
         if(this.mCardCollectionArr == null)
         {
            this.mCardCollectionArr = new Array();
         }
         if(Boolean(param1) && param1.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               param1[_loc2_] = this.formatCardReplacement(param1[_loc2_]);
               this.mCardCollectionArr[this.mCardCollectionArr.length] = param1[_loc2_];
               _loc2_++;
            }
         }
         this.mCardCollection = DictionaryUtils.addCards(param1,this.mCardCollection,false);
      }
      
      private function formatCardReplacement(param1:String) : String
      {
         var _loc2_:Array = null;
         if(FSResourceMng.smCardsReplacements != null)
         {
            _loc2_ = param1 != "" && param1.length > 0 ? param1.split(":") : null;
            if(Boolean(_loc2_) && Boolean(_loc2_.length > 1) && FSResourceMng.smCardsReplacements[_loc2_[0]] != null)
            {
               return FSResourceMng.smCardsReplacements[_loc2_[0]] + ":" + _loc2_[1];
            }
         }
         return param1;
      }
      
      public function purgeCardsCollection() : void
      {
         this.mCardCollection = null;
         this.mCardCollectionArr = null;
      }
      
      public function addCardToCollection(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:CardDef = null;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc15_:String = null;
         var _loc16_:Array = null;
         var _loc17_:int = 0;
         if(param1 != null)
         {
            if(this.mCardCollectionArr == null)
            {
               this.mCardCollectionArr = new Array();
            }
            _loc2_ = param1.split(":");
            _loc5_ = false;
            _loc4_ = 0;
            while(_loc4_ < this.mCardCollectionArr.length)
            {
               _loc3_ = this.mCardCollectionArr[_loc4_];
               _loc6_ = _loc3_.split(":")[0];
               _loc7_ = int(_loc3_.split(":")[1]);
               if(_loc6_ == _loc2_[0])
               {
                  this.mCardCollectionArr[_loc4_] = _loc6_ + ":" + (_loc7_ + int(_loc2_[1]));
                  _loc5_ = true;
               }
               _loc4_++;
            }
            if(!_loc5_)
            {
               this.mCardCollectionArr[this.mCardCollectionArr.length] = param1;
            }
            _loc8_ = DictionaryUtils.getCatalogCardsAmountCheckingRestrictions(this.mCardCollection,true,Config.getConfig().getDeckCardsAmount());
            this.mCardCollection = DictionaryUtils.addCardSkuToCatalogs(_loc2_[0],int(_loc2_[1]),this.mCardCollection);
            if(!Config.FRICTIONLESS_DECK_BUILDER)
            {
               _loc9_ = DictionaryUtils.getCatalogCardsAmountCheckingRestrictions(this.mCardCollection,true,Config.getConfig().getDeckCardsAmount());
               if(_loc8_ < Config.getConfig().getDeckCardsAmount() && _loc9_ >= Config.getConfig().getDeckCardsAmount())
               {
                  this.setSelectedDeckIndex(0,true);
               }
            }
            if(Config.getConfig().hasQuests())
            {
               if(_loc2_[0] != "" && _loc2_[0] != null)
               {
                  if(CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc6_)))
                  {
                     _loc10_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc2_[0]));
                     _loc11_ = _loc10_.getCardRarity();
                     _loc12_ = _loc10_.getFactionSku();
                     _loc13_ = _loc10_.getCategorySku();
                     _loc14_ = _loc10_.getSubCategorySku() ? _loc10_.getSubCategorySku()[0] : "";
                     _loc15_ = _loc10_.getEditionSku();
                     _loc16_ = [QuestsMng.TARGET_CARD_RARITY + ":" + _loc11_,QuestsMng.TARGET_CARD_CATEGORY + ":" + _loc13_,QuestsMng.TARGET_CARD_SUBCATEGORY + ":" + _loc14_,QuestsMng.TARGET_CARD_FACTION + ":" + _loc12_,QuestsMng.TARGET_CARD_EDITION + ":" + _loc15_];
                     if(InstanceMng.getQuestsMng())
                     {
                        InstanceMng.getQuestsMng().addActionPerformed(QuestsMng.TARGET_TYPE_UNFOLD_CARD,int(_loc2_[1]),false,_loc16_,null,null,-1,_loc12_);
                     }
                  }
               }
            }
            if(this.mIsOwner)
            {
               _loc17_ = Utils.isDesktop() ? int(_loc2_[1]) : DictionaryUtils.getUniqueCardsAmountByCatalog(this.mCardCollection);
               Utils.setStat(Constants.STAT_CARDS_OWNED,_loc17_);
            }
         }
      }
      
      public function removeCardFromCollection(param1:String, param2:int) : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(this.mCardCollectionArr != null)
         {
            _loc4_ = 0;
            while(_loc4_ < this.mCardCollectionArr.length)
            {
               _loc3_ = this.mCardCollectionArr[_loc4_];
               _loc5_ = _loc3_.split(":")[0];
               _loc6_ = int(_loc3_.split(":")[1]);
               if(_loc5_ == param1)
               {
                  _loc7_ = _loc6_ - param2 >= 0 ? int(_loc6_ - param2) : 0;
                  if(_loc7_ > 0)
                  {
                     this.mCardCollectionArr[_loc4_] = _loc5_ + ":" + (_loc6_ - param2);
                  }
                  else
                  {
                     this.mCardCollectionArr.splice(_loc4_,1);
                  }
                  break;
               }
               _loc4_++;
            }
            this.mCardCollection = DictionaryUtils.removeCardSkuFromCatalogs(param1,param2,this.mCardCollection);
            this.refreshDecksAfterDeletingCollectionCards(param1,param2);
         }
      }
      
      private function refreshDecksAfterDeletingCollectionCards(param1:String, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Dictionary = null;
         _loc3_ = 0;
         while(_loc3_ <= Config.getConfig().getMaxDecksAmount())
         {
            _loc4_ = this.getDeck(_loc3_);
            _loc4_ = DictionaryUtils.removeCardSkuFromCatalogs(param1,param2,_loc4_,false);
            _loc3_++;
         }
      }
      
      public function cleanDeckByIndex(param1:int) : void
      {
         if(this.mDecks)
         {
            if(this.mDecks[param1] != null)
            {
               DictionaryUtils.clearDictionary(this.mDecks[param1]);
            }
         }
         if(this.mDecksArr)
         {
            if(this.mDecksArr[param1] != null)
            {
               this.mDecksArr[param1] = null;
               delete this.mDecksArr[param1];
            }
         }
      }
      
      public function addPackIdToUniquePacksArr(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         if(this.mUniquePacksArr == null)
         {
            this.mUniquePacksArr = new Array();
         }
         if(Boolean(this.mUniquePacksArr) && this.mUniquePacksArr.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mUniquePacksArr.length)
            {
               if(param1 == this.mUniquePacksArr[_loc2_])
               {
                  _loc3_ = true;
                  break;
               }
               _loc2_++;
            }
         }
         if(!_loc3_)
         {
            this.mUniquePacksArr.push(param1);
         }
      }
      
      public function addAuctionIdToAuctionIdBiddedArr(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc3_:Boolean = false;
         if(this.mAuctionIdBiddedArr == null)
         {
            this.mAuctionIdBiddedArr = new Array();
         }
         if(Boolean(this.mAuctionIdBiddedArr) && this.mAuctionIdBiddedArr.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mAuctionIdBiddedArr.length)
            {
               _loc4_ = param1.split(":")[0];
               _loc5_ = param1.split(":")[1];
               _loc6_ = param1.split(":")[2];
               _loc7_ = String(this.mAuctionIdBiddedArr[_loc2_]).split(":")[0];
               _loc8_ = String(this.mAuctionIdBiddedArr[_loc2_]).split(":")[1];
               _loc9_ = String(this.mAuctionIdBiddedArr[_loc2_]).split(":")[2];
               if(_loc4_ == _loc7_)
               {
                  if(_loc6_ > _loc9_)
                  {
                     this.mAuctionIdBiddedArr[_loc2_] = param1;
                  }
                  _loc3_ = true;
                  break;
               }
               _loc2_++;
            }
         }
         if(!_loc3_)
         {
            this.mAuctionIdBiddedArr.push(param1);
         }
      }
      
      public function addAuctionIdToAuctionIdCreatorArr(param1:String) : void
      {
         if(this.mAuctionIdCreatedArr == null)
         {
            this.mAuctionIdCreatedArr = new Array();
         }
         this.mAuctionIdCreatedArr.push(param1);
      }
      
      public function removeAuctionIdFromAuctionIdCreatorArr(param1:String) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         if(Boolean(this.mAuctionIdCreatedArr) && this.mAuctionIdCreatedArr.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mAuctionIdCreatedArr.length)
            {
               if(param1 == this.mAuctionIdCreatedArr[_loc2_])
               {
                  this.mAuctionIdCreatedArr.splice(_loc2_,1);
                  _loc3_ = true;
                  break;
               }
               _loc2_++;
            }
         }
         return _loc3_;
      }
      
      public function removeAuctionIdFromAuctionIdBiddedArr(param1:String) : Boolean
      {
         var _loc2_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc3_:Boolean = false;
         if(Boolean(this.mAuctionIdBiddedArr) && this.mAuctionIdBiddedArr.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mAuctionIdBiddedArr.length)
            {
               _loc4_ = param1.split(":")[0];
               _loc5_ = String(this.mAuctionIdBiddedArr[_loc2_]).split(":")[0];
               if(_loc4_ == _loc5_)
               {
                  this.mAuctionIdBiddedArr.splice(_loc2_,1);
                  _loc3_ = true;
                  break;
               }
               _loc2_++;
            }
         }
         return _loc3_;
      }
      
      public function addCardToFavouritesCollection(param1:String) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         if(this.mFavouritesCollectionArr == null)
         {
            this.mFavouritesCollectionArr = new Array();
         }
         var _loc4_:CardDef = CardDef(InstanceMng.getCardsDefMng().getDefBySku(param1));
         var _loc5_:Boolean = false;
         if(_loc4_.getIsVisible())
         {
            _loc3_ = 0;
            while(_loc3_ < this.mFavouritesCollectionArr.length)
            {
               _loc2_ = this.mFavouritesCollectionArr[_loc3_];
               if(_loc2_ == param1)
               {
                  _loc5_ = true;
                  break;
               }
               _loc3_++;
            }
            if(!_loc5_)
            {
               this.mFavouritesCollectionArr[this.mFavouritesCollectionArr.length] = param1;
            }
            this.mFavouritesCollection = DictionaryUtils.addCardSkuToCatalogs(param1,1,this.mFavouritesCollection);
         }
      }
      
      public function removeCardFromFavouritesCollection(param1:String, param2:Boolean = false) : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         if(this.mNewCardsCollectionArr != null)
         {
            _loc4_ = 0;
            while(_loc4_ < this.mNewCardsCollectionArr.length)
            {
               _loc3_ = this.mNewCardsCollectionArr[_loc4_];
               _loc5_ = _loc3_.split(":")[0];
               if(_loc5_ == param1)
               {
                  this.mNewCardsCollectionArr.splice(_loc4_,1);
                  break;
               }
               _loc4_++;
            }
            this.mFavouritesCollection = DictionaryUtils.removeCardSkuFromCatalogs(param1,1,this.mFavouritesCollection);
         }
      }
      
      public function addCardToNewCardsCollection(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:CardDef = null;
         if(param1 != null && param1 != "")
         {
            if(this.mNewCardsCollectionArr == null)
            {
               this.mNewCardsCollectionArr = new Array();
            }
            _loc2_ = param1.split(":");
            _loc5_ = false;
            _loc8_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc2_[0]));
            if((Boolean(_loc8_)) && _loc8_.getIsVisible())
            {
               _loc4_ = 0;
               while(_loc4_ < this.mNewCardsCollectionArr.length)
               {
                  _loc3_ = this.mNewCardsCollectionArr[_loc4_];
                  _loc6_ = _loc3_.split(":")[0];
                  _loc7_ = int(_loc3_.split(":")[1]);
                  if(_loc6_ == _loc2_[0])
                  {
                     this.mNewCardsCollectionArr[_loc4_] = _loc6_ + ":" + (_loc7_ + _loc2_[1]);
                     _loc5_ = true;
                  }
                  _loc4_++;
               }
               if(!_loc5_)
               {
                  this.mNewCardsCollectionArr[this.mNewCardsCollectionArr.length] = param1;
               }
               this.mNewCardsCollection = DictionaryUtils.addCardSkuToCatalogs(_loc2_[0],1,this.mNewCardsCollection);
            }
         }
      }
      
      public function removeCardFromNewCardsCollection(param1:String, param2:int, param3:Boolean = false) : void
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(this.mNewCardsCollectionArr != null)
         {
            _loc5_ = 0;
            while(_loc5_ < this.mNewCardsCollectionArr.length)
            {
               _loc4_ = this.mNewCardsCollectionArr[_loc5_];
               _loc6_ = _loc4_ != "" ? _loc4_.split(":")[0] : "";
               _loc7_ = _loc4_ != "" ? int(_loc4_.split(":")[1]) : 0;
               if(_loc6_ == param1)
               {
                  _loc8_ = _loc7_ - param2 >= 0 ? int(_loc7_ - param2) : 0;
                  if(_loc8_ > 0 && !param3)
                  {
                     this.mNewCardsCollectionArr[_loc5_] = _loc6_ + ":" + (_loc7_ + param2);
                  }
                  else
                  {
                     this.mNewCardsCollectionArr.splice(_loc5_,1);
                  }
               }
               _loc5_++;
            }
            this.mNewCardsCollection = DictionaryUtils.removeCardSkuFromCatalogs(param1,param2,this.mNewCardsCollection);
         }
      }
      
      public function getIsOwner() : Boolean
      {
         return this.mIsOwner;
      }
      
      public function setIsOwner(param1:Boolean) : void
      {
         this.mIsOwner = param1;
      }
      
      public function getCurrentLevelSku() : String
      {
         return this.mCurrentLevelSku;
      }
      
      public function getCurrentLevelMediumSku() : String
      {
         return this.mCurrentLevelMediumSku;
      }
      
      public function getCurrentLevelHardSku() : String
      {
         return this.mCurrentLevelHardSku;
      }
      
      public function getCurrentMapIndex(param1:int) : int
      {
         var _loc2_:int = UserDataMng.DIFFICULTY_EASY;
         switch(param1)
         {
            case UserDataMng.DIFFICULTY_EASY:
               _loc2_ = InstanceMng.getMapsDefMng().getMapIndexByLevelIndex(this.mCurrentLevelIndex);
               break;
            case UserDataMng.DIFFICULTY_MEDIUM:
               _loc2_ = InstanceMng.getMapsDefMng().getMapIndexByLevelIndex(this.mCurrentLevelMediumIndex);
               break;
            case UserDataMng.DIFFICULTY_HARD:
               _loc2_ = InstanceMng.getMapsDefMng().getMapIndexByLevelIndex(this.mCurrentLevelHardIndex);
               break;
            default:
               _loc2_ = InstanceMng.getMapsDefMng().getMapIndexByLevelIndex(this.mCurrentLevelIndex);
         }
         return _loc2_;
      }
      
      public function getLastLevelPlayedMapIndex() : int
      {
         var _loc1_:int = -1;
         switch(this.mCurrentDifficulty)
         {
            case UserDataMng.DIFFICULTY_EASY:
               if(this.mLastLevelPlayed != "")
               {
                  _loc1_ = InstanceMng.getMapsDefMng().getMapIndexByLevelIndex(int(this.mLastLevelPlayed.split("_")[1]));
               }
               break;
            case UserDataMng.DIFFICULTY_MEDIUM:
               if(this.mLastLevelMediumPlayed != "")
               {
                  _loc1_ = InstanceMng.getMapsDefMng().getMapIndexByLevelIndex(int(this.mLastLevelMediumPlayed.split("_")[1]));
               }
               break;
            case UserDataMng.DIFFICULTY_HARD:
               if(this.mLastLevelHardPlayed != "")
               {
                  _loc1_ = InstanceMng.getMapsDefMng().getMapIndexByLevelIndex(int(this.mLastLevelHardPlayed.split("_")[1]));
               }
               break;
            default:
               if(this.mLastLevelPlayed != "")
               {
                  _loc1_ = InstanceMng.getMapsDefMng().getMapIndexByLevelIndex(int(this.mLastLevelPlayed.split("_")[1]));
               }
         }
         return _loc1_;
      }
      
      public function setCurrentLevelSkuByDifficulty(param1:int, param2:String) : void
      {
         switch(param1)
         {
            case UserDataMng.DIFFICULTY_EASY:
               this.setCurrentLevelSku(param2);
               break;
            case UserDataMng.DIFFICULTY_MEDIUM:
               this.setCurrentLevelMediumSku(param2);
               break;
            case UserDataMng.DIFFICULTY_HARD:
               this.setCurrentLevelHardSku(param2);
               break;
            default:
               this.setCurrentLevelSku(param2);
         }
      }
      
      public function setCurrentLevelSku(param1:String) : void
      {
         if(param1 != null && param1 != "")
         {
            this.mCurrentLevelSku = param1;
            this.mCurrentLevelIndex = param1.split("_")[1];
            if(this.mCurrentLevelIndex)
            {
               this.mRankIndex = RankDef(InstanceMng.getRanksDefMng().getDefByCurrentLevel(this.mCurrentLevelIndex)).getIndex();
            }
         }
      }
      
      public function setCurrentLevelMediumSku(param1:String) : void
      {
         if(param1 != null && param1 != "")
         {
            this.mCurrentLevelMediumSku = param1;
            this.mCurrentLevelMediumIndex = param1.split("_")[1];
         }
      }
      
      public function setCurrentLevelHardSku(param1:String) : void
      {
         if(param1 != null && param1 != "")
         {
            this.mCurrentLevelHardSku = param1;
            this.mCurrentLevelHardIndex = param1.split("_")[1];
         }
      }
      
      public function setProgressResetDate(param1:Number) : void
      {
         this.mProgressResetDate = param1;
      }
      
      public function getProgressResetDate() : Number
      {
         return this.mProgressResetDate;
      }
      
      public function getDeckArr(param1:int = 0) : Array
      {
         var _loc2_:Array = null;
         if(this.mDecksArr != null)
         {
            _loc2_ = this.mDecksArr[param1];
         }
         return _loc2_;
      }
      
      public function getTotalDeckArr() : Array
      {
         return this.mDecksArr;
      }
      
      public function getGold() : Number
      {
         return this.mGold ? this.mGold.value : 0;
      }
      
      public function setGold(param1:Number) : void
      {
         if(this.mGold == null)
         {
            this.mGold = new FSNumber();
         }
         this.mGold.value = param1;
      }
      
      public function addGold(param1:Number, param2:Boolean = true) : void
      {
         if(param1 < 0)
         {
            throw new Error("Adding currency should receive a positive value");
         }
         if(this.mGold == null)
         {
            this.mGold = new FSNumber();
         }
         this.mGold.value += param1;
         InstanceMng.getServerConnection().addPlayerCurrency(param1,ServerConnection.CURRENCY_GOLD,param2);
      }
      
      public function substractCurrency(param1:String, param2:Number, param3:Function = null, param4:Array = null, param5:Function = null, param6:Array = null) : void
      {
         if(param2 > 0)
         {
            throw new Error("Substracting currency should receive a negative value");
         }
         InstanceMng.getServerConnection().addPlayerCurrency(param2,param1,true,param3,param4,param5,param6);
      }
      
      public function substractGold(param1:Number, param2:Function = null, param3:Array = null, param4:Function = null, param5:Array = null) : void
      {
         if(param1 > 0)
         {
            throw new Error("Substracting currency should receive a negative value");
         }
         InstanceMng.getServerConnection().addPlayerCurrency(param1,ServerConnection.CURRENCY_GOLD,true,param2,param3,param4,param5);
      }
      
      public function addAuctionTickets(param1:Number, param2:Boolean = true) : void
      {
         if(param1 < 0)
         {
            throw new Error("Adding currency should receive a positive value");
         }
         if(this.mAuctionTickets == null)
         {
            this.mAuctionTickets = new FSNumber();
         }
         this.mAuctionTickets.value += param1;
         InstanceMng.getServerConnection().addPlayerCurrency(param1,ServerConnection.CURRENCY_AH_TOKENS,param2);
      }
      
      public function substractAuctionTickets(param1:Number, param2:Function = null, param3:Array = null, param4:Function = null, param5:Array = null) : void
      {
         if(param1 > 0)
         {
            throw new Error("Substracting currency should receive a negative value");
         }
         InstanceMng.getServerConnection().addPlayerCurrency(param1,ServerConnection.CURRENCY_AH_TOKENS,true,param2,param3,param4,param5);
      }
      
      public function getQuestsCoins() : Number
      {
         return this.mQuestsCoins ? this.mQuestsCoins.value : 0;
      }
      
      public function getRaidCoins() : Number
      {
         return this.mRaidCoins ? this.mRaidCoins.value : 0;
      }
      
      public function setRaidCoins(param1:Number) : void
      {
         if(this.mRaidCoins == null)
         {
            this.mRaidCoins = new FSNumber();
         }
         this.mRaidCoins.value = param1;
      }
      
      public function setQuestsCoins(param1:Number) : void
      {
         if(this.mQuestsCoins == null)
         {
            this.mQuestsCoins = new FSNumber();
         }
         this.mQuestsCoins.value = param1;
      }
      
      public function addRaidCoins(param1:Number, param2:Boolean = true) : void
      {
         if(param1 < 0)
         {
            throw new Error("Adding currency should receive a positive value");
         }
         if(this.mRaidCoins == null)
         {
            this.mRaidCoins = new FSNumber();
         }
         if(!isNaN(param1))
         {
            this.mRaidCoins.value += param1;
            InstanceMng.getServerConnection().addPlayerCurrency(param1,ServerConnection.CURRENCY_RAID_COINS,param2);
         }
      }
      
      public function substractRaidCoins(param1:Number, param2:Function = null, param3:Array = null, param4:Function = null, param5:Array = null) : void
      {
         if(param1 > 0)
         {
            throw new Error("Substracting currency should receive a negative value");
         }
         InstanceMng.getServerConnection().addPlayerCurrency(param1,ServerConnection.CURRENCY_RAID_COINS,true,param2,param3,param4,param5);
      }
      
      public function addQuestsCoins(param1:Number, param2:Boolean = true) : void
      {
         if(param1 < 0)
         {
            throw new Error("Adding currency should receive a positive value");
         }
         if(this.mQuestsCoins == null)
         {
            this.mQuestsCoins = new FSNumber();
         }
         if(!isNaN(param1))
         {
            this.mQuestsCoins.value += param1;
            InstanceMng.getServerConnection().addPlayerCurrency(param1,ServerConnection.CURRENCY_QUEST_COINS,param2);
         }
      }
      
      public function substractQuestsCoins(param1:Number, param2:Function = null, param3:Array = null, param4:Function = null, param5:Array = null) : void
      {
         if(param1 > 0)
         {
            throw new Error("Substracting currency should receive a negative value");
         }
         InstanceMng.getServerConnection().addPlayerCurrency(param1,ServerConnection.CURRENCY_QUEST_COINS,true,param2,param3,param4,param5);
      }
      
      public function getExp() : Number
      {
         return this.mExp;
      }
      
      public function setExp(param1:Number) : void
      {
         this.mExp = param1;
      }
      
      public function addExp(param1:Number) : void
      {
         this.mExp += param1;
      }
      
      public function getCardCollectionArr() : Array
      {
         return this.mCardCollectionArr;
      }
      
      public function setCardCollectionArr(param1:Array) : void
      {
         this.mCardCollectionArr = param1;
      }
      
      public function getSelectedDeckIndex() : int
      {
         return this.mSelectedDeckIndex;
      }
      
      public function setSelectedDeckIndex(param1:int, param2:Boolean = false) : void
      {
         this.mSelectedDeckIndex = param1;
         if(this.mIsOwner && param2)
         {
            if(InstanceMng.getUserDataMng() != null)
            {
               InstanceMng.getUserDataMng().updateSelectedDeckIndex();
            }
         }
      }
      
      public function getSelectedDeck() : Dictionary
      {
         var _loc1_:Dictionary = null;
         if(this.mDecks != null)
         {
            _loc1_ = this.mDecks[this.mSelectedDeckIndex];
         }
         return _loc1_;
      }
      
      public function setSelectedDeckIndexPvP(param1:int, param2:Boolean = false) : void
      {
         this.mSelectedDeckIndexPvP = param1;
         if(this.mIsOwner && param2)
         {
            if(InstanceMng.getUserDataMng() != null)
            {
               InstanceMng.getUserDataMng().updateSelectedDeckIndex();
            }
         }
      }
      
      public function getSelectedDeckIndexPvP() : int
      {
         return this.mSelectedDeckIndexPvP;
      }
      
      public function getSelectedDeckPvP() : Dictionary
      {
         var _loc1_:Dictionary = null;
         if(this.mDecks != null)
         {
            _loc1_ = this.mDecks[this.mSelectedDeckIndexPvP];
         }
         return _loc1_;
      }
      
      public function getBoostsCatalog() : Dictionary
      {
         return this.mBoostsCatalog;
      }
      
      public function setBoostsCatalog(param1:Array) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         if(param1 != null && param1.length > 0)
         {
            _loc5_ = 0;
            _loc5_ = 0;
            while(_loc5_ < param1.length)
            {
               _loc4_ = String(param1[_loc5_]).split(":");
               _loc2_ = _loc4_[0];
               _loc3_ = int(_loc4_[1]);
               this.addBoostToCatalog(_loc2_,_loc3_);
               _loc5_++;
            }
         }
      }
      
      public function resetBoostsCatalog() : void
      {
         DictionaryUtils.clearDictionary(this.mBoostsCatalog);
         this.mBoostsCatalog = null;
         DictionaryUtils.clearDictionary(this.mPreBoostsCatalog);
         this.mPreBoostsCatalog = null;
         this.mPostBoost = null;
      }
      
      public function resetNotifications() : void
      {
         Utils.destroyArray(this.mNotificationsReceived);
         this.mNotificationsReceived = null;
      }
      
      public function resetMapWorldChoices() : void
      {
         DictionaryUtils.clearDictionary(this.mMapWorldChoices);
         this.mMapWorldChoices = null;
      }
      
      public function addBoostToCatalog(param1:String, param2:int, param3:Boolean = false) : void
      {
         var _loc4_:ShopBoostDef = ShopBoostDef(InstanceMng.getShopBoostsDefMng().getDefByRegularBoostSku(param1));
         if((Boolean(_loc4_)) && (_loc4_.getExecuteOnBuy() && _loc4_.isRepurchasable() || param3))
         {
            return;
         }
         if(this.mBoostsCatalog == null)
         {
            this.mBoostsCatalog = new Dictionary(true);
         }
         if(this.mBoostsCatalog[param1] != null)
         {
            this.mBoostsCatalog[param1] += param2;
         }
         else
         {
            this.mBoostsCatalog[param1] = param2;
         }
      }
      
      public function removeBoostFromCatalog(param1:String, param2:int) : void
      {
         if(this.mBoostsCatalog != null)
         {
            if(this.mBoostsCatalog[param1] != null)
            {
               this.mBoostsCatalog[param1] -= param2;
            }
            if(this.mBoostsCatalog[param1] == 0)
            {
               delete this.mBoostsCatalog[param1];
            }
         }
         InstanceMng.getUserDataMng().updateBoosts();
      }
      
      public function getBoostAmount(param1:String) : int
      {
         var _loc2_:int = 0;
         if(this.mBoostsCatalog != null)
         {
            if(this.mBoostsCatalog[param1] != null)
            {
               _loc2_ = int(this.mBoostsCatalog[param1]);
            }
         }
         return _loc2_;
      }
      
      public function getAvailableJobs() : Dictionary
      {
         return this.mAvailableJobs;
      }
      
      public function setAvailableJobs(param1:Array) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         if(param1 != null && param1.length > 0)
         {
            _loc3_ = 0;
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               _loc2_ = String(param1[_loc3_]);
               this.addJobToCatalog(_loc2_);
               _loc3_++;
            }
         }
      }
      
      public function addJobToCatalog(param1:String, param2:Boolean = true) : void
      {
         var _loc3_:JobDef = null;
         var _loc4_:Boolean = false;
         if(this.mAvailableJobs == null)
         {
            this.mAvailableJobs = new Dictionary(true);
         }
         this.mAvailableJobs[param1] = true;
         if(param2)
         {
            _loc3_ = JobDef(InstanceMng.getJobsDefMng().getDefBySku(param1));
            if(_loc3_)
            {
               if(this.mCardCollection)
               {
                  _loc4_ = this.mCardCollection[_loc3_.getActiveDefaultSku()] == null ? false : this.mCardCollection[_loc3_.getActiveDefaultSku()] > 0;
                  if(!_loc4_)
                  {
                     this.addCardToCollection(_loc3_.getActiveDefaultSku() + ":1");
                  }
                  _loc4_ = this.mCardCollection[_loc3_.getActiveSecondarySku()] == null ? false : this.mCardCollection[_loc3_.getActiveSecondarySku()] > 0;
                  if(!_loc4_)
                  {
                     this.addCardToCollection(_loc3_.getActiveSecondarySku() + ":1");
                  }
               }
               else
               {
                  this.addCardToCollection(_loc3_.getActiveDefaultSku() + ":1");
                  this.addCardToCollection(_loc3_.getActiveSecondarySku() + ":1");
               }
            }
         }
      }
      
      public function resetAvailableJobs() : void
      {
         DictionaryUtils.clearDictionary(this.mAvailableJobs);
         this.mAvailableJobs = null;
      }
      
      public function isJobAvailable(param1:String) : Boolean
      {
         var _loc2_:Boolean = false;
         if(this.mAvailableJobs != null)
         {
            if(this.mAvailableJobs[param1] != null)
            {
               _loc2_ = Boolean(this.mAvailableJobs[param1]);
            }
         }
         return _loc2_;
      }
      
      public function getCurrentSkinSku() : String
      {
         return this.mCurrentSkinSku;
      }
      
      public function getCurrentSkinDef(param1:Boolean = true) : HeroCharacterDef
      {
         var _loc2_:HeroCharacterDef = HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(this.mCurrentSkinSku));
         if(_loc2_ == null)
         {
            this.createDefaultSkinDef(param1);
         }
         return HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(this.mCurrentSkinSku));
      }
      
      private function createDefaultSkinDef(param1:Boolean = true) : void
      {
         var _loc2_:HeroCharacterDef = HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefByIndex(0));
         if(_loc2_)
         {
            this.setCurrentSkinSku(_loc2_.getSku());
            if(this.getAvailableSkins() == null)
            {
               this.setAvailableSkins(new Array(this.mCurrentSkinSku));
            }
            if(param1 && Boolean(InstanceMng.getUserDataMng()))
            {
               InstanceMng.getUserDataMng().persistenceSaveData();
            }
         }
      }
      
      public function setCurrentSkinSku(param1:String) : void
      {
         this.mCurrentSkinSku = param1;
      }
      
      public function getAvailableSkins() : Dictionary
      {
         return this.mAvailableSkins;
      }
      
      public function setAvailableSkins(param1:Array) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         if(param1 != null && param1.length > 0)
         {
            _loc3_ = 0;
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               _loc2_ = String(param1[_loc3_]);
               this.addSkinToCatalog(_loc2_);
               _loc3_++;
            }
         }
      }
      
      public function addSkinToCatalog(param1:String) : void
      {
         if(this.mAvailableSkins == null)
         {
            this.mAvailableSkins = new Dictionary(true);
         }
         this.mAvailableSkins[param1] = true;
      }
      
      public function resetAvailableSkins() : void
      {
         DictionaryUtils.clearDictionary(this.mAvailableSkins);
         this.mAvailableSkins = null;
      }
      
      public function isSkinAvailable(param1:String) : Boolean
      {
         var _loc2_:Boolean = false;
         if(this.mAvailableSkins != null)
         {
            if(this.mAvailableSkins[param1] != null)
            {
               _loc2_ = Boolean(this.mAvailableSkins[param1]);
            }
         }
         return _loc2_;
      }
      
      public function getCurrentPortraitSku() : String
      {
         return this.mCurrentPortraitSku;
      }
      
      public function getCurrentPortraitBGImageName(param1:Boolean = true) : String
      {
         var _loc2_:PortraitDef = PortraitDef(InstanceMng.getPortraitsDefMng().getDefBySku(this.mCurrentPortraitSku));
         if(_loc2_ == null)
         {
            this.createDefaultPortraitDef(param1);
         }
         _loc2_ = this.getCurrentPortraitDef(param1);
         return _loc2_.getBGImageName();
      }
      
      public function getCurrentRankFrameBGImageName(param1:Boolean = true) : String
      {
         var _loc2_:PortraitDef = PortraitDef(InstanceMng.getPortraitsDefMng().getDefBySku(this.mCurrentPortraitSku));
         if(_loc2_ == null)
         {
            this.createDefaultPortraitDef(param1);
         }
         _loc2_ = this.getCurrentPortraitDef(param1);
         return _loc2_.getRankFrameBG();
      }
      
      public function getCurrentPortraitDef(param1:Boolean = true) : PortraitDef
      {
         var _loc2_:PortraitDef = PortraitDef(InstanceMng.getPortraitsDefMng().getDefBySku(this.mCurrentPortraitSku));
         if(_loc2_ == null)
         {
            this.createDefaultPortraitDef(param1);
         }
         return PortraitDef(InstanceMng.getPortraitsDefMng().getDefBySku(this.mCurrentPortraitSku));
      }
      
      private function createDefaultPortraitDef(param1:Boolean = true) : void
      {
         var _loc2_:Def = InstanceMng.getPortraitsDefMng() ? InstanceMng.getPortraitsDefMng().getDefByIndex(0) : null;
         this.setCurrentPortraitSku(PortraitDef(_loc2_).getSku());
         if(this.getAvailablePortraits() == null)
         {
            this.setAvailablePortraits(new Array(this.mCurrentPortraitSku));
         }
         if(param1)
         {
            InstanceMng.getUserDataMng().persistenceSaveData();
         }
      }
      
      public function setCurrentPortraitSku(param1:String) : void
      {
         this.mCurrentPortraitSku = param1;
      }
      
      public function getAvailablePortraits() : Dictionary
      {
         return this.mAvailablePortraits;
      }
      
      public function setAvailablePortraits(param1:Array) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         if(param1 != null && param1.length > 0)
         {
            _loc3_ = 0;
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               _loc2_ = String(param1[_loc3_]);
               this.addPortraitToCatalog(_loc2_);
               _loc3_++;
            }
         }
      }
      
      public function resetAvailablePortraits() : void
      {
         DictionaryUtils.clearDictionary(this.mAvailablePortraits);
         this.mAvailablePortraits = null;
      }
      
      public function resetDeckJobConfigurator() : void
      {
         Utils.destroyArray(this.mDeckJobConfigurationArr);
         this.mDeckJobConfigurationArr = null;
      }
      
      public function addPortraitToCatalog(param1:String) : void
      {
         if(this.mAvailablePortraits == null)
         {
            this.mAvailablePortraits = new Dictionary(true);
         }
         this.mAvailablePortraits[param1] = true;
      }
      
      public function isPortraitAvailable(param1:String) : Boolean
      {
         var _loc2_:Boolean = false;
         if(this.mAvailablePortraits != null)
         {
            if(this.mAvailablePortraits[param1] != null)
            {
               _loc2_ = Boolean(this.mAvailablePortraits[param1]);
            }
         }
         return _loc2_;
      }
      
      public function getDeckNames() : Dictionary
      {
         return this.mDeckNames;
      }
      
      public function setDeckNames(param1:Array) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:String = null;
         if(param1 != null && param1.length > 0)
         {
            _loc5_ = 0;
            _loc5_ = 0;
            while(_loc5_ < param1.length)
            {
               _loc4_ = String(param1[_loc5_]).split(":");
               _loc2_ = _loc4_[0];
               _loc3_ = _loc4_[1];
               this.setDeckNameToCatalog(_loc2_,_loc3_);
               _loc5_++;
            }
            _loc6_ = Config.getConfig().getMaxDecksAmount();
            if(_loc5_ < _loc6_)
            {
               _loc7_ = "";
               _loc8_ = "deck_";
               _loc5_ = int(param1.length);
               while(_loc5_ < _loc6_)
               {
                  _loc2_ = _loc8_ + Utils.transformValueToString(_loc5_.toString(),2);
                  _loc3_ = TextManager.getText("TID_DECKBUILDER_DECK") + " " + (_loc5_ + 1).toString();
                  this.setDeckNameToCatalog(_loc2_,_loc3_);
                  _loc5_++;
               }
            }
         }
      }
      
      public function resetDeckNames() : void
      {
         var _loc2_:int = 0;
         DictionaryUtils.clearDictionary(this.mDeckNames);
         this.mDeckNames = null;
         var _loc1_:String = "";
         var _loc3_:String = "deck_";
         var _loc4_:int = Config.getConfig().getMaxDecksAmount();
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc1_ += _loc3_ + Utils.transformValueToString(_loc2_.toString(),2) + ":" + TextManager.getText("TID_DECKBUILDER_DECK") + " " + (_loc2_ + 1).toString();
            if(_loc2_ < _loc4_ - 1)
            {
               _loc1_ += ",";
            }
            _loc2_++;
         }
         this.setDeckNames(_loc1_.split(","));
      }
      
      public function setDeckNameToCatalog(param1:String, param2:String) : void
      {
         if(this.mDeckNames == null)
         {
            this.mDeckNames = new Dictionary(true);
         }
         this.mDeckNames[param1] = param2;
      }
      
      public function getDeckName(param1:int) : String
      {
         var _loc2_:String = null;
         var _loc3_:String = "deck_" + Utils.transformValueToString(param1.toString(),2);
         if(this.mDeckNames != null)
         {
            if(this.mDeckNames[_loc3_] != null)
            {
               _loc2_ = this.mDeckNames[_loc3_];
            }
         }
         return _loc2_;
      }
      
      public function getLives() : int
      {
         return this.mLives;
      }
      
      public function setLives(param1:int) : void
      {
         this.mLives = param1;
      }
      
      public function getElo() : int
      {
         return this.mElo;
      }
      
      public function getPvPCurrentLeague() : int
      {
         return this.mPvPCurrentLeague;
      }
      
      public function getPvPBestLeague() : int
      {
         return this.mPvPBestLeague;
      }
      
      public function setPvPCurrentLeague(param1:int, param2:Boolean = false) : void
      {
         if(param1 > 0)
         {
            this.mPvPCurrentLeague = param1;
            if(param2)
            {
               InstanceMng.getUserDataMng().updatePvPCurrentLeague();
            }
         }
      }
      
      public function setPvPBestLeague(param1:int, param2:Boolean = false) : void
      {
         if(param1 > 0)
         {
            this.mPvPBestLeague = param1;
            if(param2)
            {
               InstanceMng.getUserDataMng().updatePvPBestLeague();
            }
         }
      }
      
      public function setElo(param1:int, param2:Boolean = false) : void
      {
         this.mElo = param1;
         if(param2)
         {
            InstanceMng.getUserDataMng().updateElo();
         }
         if(this.mIsOwner)
         {
            Utils.setStat(Constants.STAT_PVP_RANKING_PUNCTUATION,this.mElo);
            if(InstanceMng.getCurrentScreen() is FSPvPScreen)
            {
               FSPvPScreen(InstanceMng.getCurrentScreen()).updateLeagueFrame();
            }
         }
      }
      
      public function getMatchesLost() : int
      {
         return this.mMatchesLost;
      }
      
      public function setMatchesLost(param1:int) : void
      {
         this.mMatchesLost = param1;
      }
      
      public function increaseMatchesLost(param1:Boolean = false) : void
      {
         ++this.mMatchesLost;
         if(param1)
         {
            InstanceMng.getUserDataMng().updateMatchesLost();
         }
      }
      
      public function decreaseMatchesLost(param1:Boolean = false) : void
      {
         this.mMatchesLost = this.mMatchesLost - 1 >= 0 ? int(this.mMatchesLost - 1) : 0;
         if(param1)
         {
            InstanceMng.getUserDataMng().updateMatchesLost();
         }
      }
      
      public function getMatchesWon() : int
      {
         return this.mMatchesWon;
      }
      
      public function setMatchesWon(param1:int) : void
      {
         this.mMatchesWon = param1;
      }
      
      public function increaseMatchesWon(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         ++this.mMatchesWon;
         if(param1)
         {
            InstanceMng.getUserDataMng().updateMatchesWon();
         }
         if(this.mIsOwner)
         {
            _loc2_ = Utils.isDesktop() ? 1 : this.mMatchesWon;
            Utils.setStat(Constants.STAT_PVP_MATCHES_WON,_loc2_);
         }
      }
      
      public function getMatchesPlayed() : int
      {
         return this.mMatchesPlayed;
      }
      
      public function setMatchesPlayed(param1:int) : void
      {
         this.mMatchesPlayed = param1;
      }
      
      public function increaseMatchesPlayed(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         ++this.mMatchesPlayed;
         if(param1)
         {
            InstanceMng.getUserDataMng().updateMatchesPlayed();
         }
         if(this.mIsOwner)
         {
            _loc2_ = Utils.isDesktop() ? 1 : this.mMatchesPlayed;
            Utils.setStat(Constants.STAT_PVP_MATCHES_PLAYED,_loc2_);
         }
      }
      
      public function getDungeonsLost() : int
      {
         return this.mDungeonsLost;
      }
      
      public function setDungeonsLost(param1:int) : void
      {
         this.mDungeonsLost = param1;
      }
      
      public function increaseDungeonsLost(param1:Boolean = false) : void
      {
         ++this.mDungeonsLost;
         if(param1)
         {
            InstanceMng.getUserDataMng().updateDungeonsLost();
         }
      }
      
      public function decreaseDungeonsLost(param1:Boolean = false) : void
      {
         this.mDungeonsLost = this.mDungeonsLost - 1 >= 0 ? int(this.mDungeonsLost - 1) : 0;
         if(param1)
         {
            InstanceMng.getUserDataMng().updateDungeonsLost();
         }
      }
      
      public function getDungeonsWon() : int
      {
         return this.mDungeonsWon;
      }
      
      public function setDungeonsWon(param1:int) : void
      {
         this.mDungeonsWon = param1;
      }
      
      public function increaseDungeonsWon() : void
      {
         var _loc1_:int = 0;
         ++this.mDungeonsWon;
         InstanceMng.getUserDataMng().updateDungeonsWon();
         if(this.mIsOwner)
         {
            _loc1_ = Utils.isDesktop() ? 1 : this.mDungeonsWon;
            Utils.setStat(Constants.STAT_DUNGEONS_COMPLETED,_loc1_);
         }
      }
      
      public function getDungeonsPlayed() : int
      {
         return this.mDungeonsPlayed;
      }
      
      public function setDungeonsPlayed(param1:int) : void
      {
         this.mDungeonsPlayed = param1;
      }
      
      public function increaseDungeonsPlayed(param1:Boolean = false) : void
      {
         ++this.mDungeonsPlayed;
         if(param1)
         {
            InstanceMng.getUserDataMng().updateDungeonsPlayed();
         }
         if(this.mIsOwner)
         {
            Utils.setStat(Constants.DUNGEONS_PLAYED,this.mDungeonsPlayed);
         }
      }
      
      public function getBadgesRewardsClaimed() : Dictionary
      {
         return this.mBadgesRewardsClaimed;
      }
      
      public function getBadgesRewardsClaimedBySku(param1:String) : Boolean
      {
         if(this.mBadgesRewardsClaimed == null)
         {
            return false;
         }
         return this.mBadgesRewardsClaimed[param1];
      }
      
      public function addBadgeRewardClaimed(param1:String, param2:Boolean = true) : void
      {
         if(this.mBadgesRewardsClaimed == null)
         {
            this.mBadgesRewardsClaimed = new Dictionary(true);
         }
         this.mBadgesRewardsClaimed[param1] = true;
         if(param2 && this.mIsOwner)
         {
            InstanceMng.getUserDataMng().updateBadgesRewardsClaimed();
         }
      }
      
      public function setBadgesRewardsClaimed(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         if(param1 != null && param1 != "")
         {
            _loc2_ = param1.split(",");
            _loc4_ = 0;
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc3_ = _loc2_[_loc4_];
               if(_loc3_.length > 0)
               {
                  this.addBadgeRewardClaimed(_loc3_,false);
               }
               _loc4_++;
            }
         }
      }
      
      public function resetBadgesRewardsClaimed() : void
      {
         DictionaryUtils.clearDictionary(this.mBadgesRewardsClaimed);
         this.mBadgesRewardsClaimed = null;
      }
      
      public function isBadgeRewardAlreadyClaimed(param1:String) : Boolean
      {
         var _loc2_:Boolean = false;
         if(this.mBadgesRewardsClaimed != null)
         {
            _loc2_ = this.mBadgesRewardsClaimed[param1] == true;
         }
         return _loc2_;
      }
      
      public function getStarsRewardsClaimed() : Dictionary
      {
         return this.mStarsRewardsClaimed;
      }
      
      public function getHighestStarsRewardClaimed() : StarsRewardsDef
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:StarsRewardsDef = null;
         var _loc1_:StarsRewardsDef = null;
         if(this.mStarsRewardsClaimed != null)
         {
            _loc2_ = DictionaryUtils.getKeys(this.mStarsRewardsClaimed);
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc4_ = StarsRewardsDef(InstanceMng.getStarsRewardsDefMng().getDefBySku(_loc2_[_loc3_]));
               if(_loc4_ != null)
               {
                  if(_loc1_ == null)
                  {
                     _loc1_ = _loc4_;
                  }
                  else
                  {
                     _loc1_ = _loc4_.getStarsAmount() > _loc1_.getStarsAmount() ? _loc4_ : _loc1_;
                  }
               }
               _loc3_++;
            }
         }
         return _loc1_;
      }
      
      public function resetStarsRewardsClaimed() : void
      {
         DictionaryUtils.clearDictionary(this.mStarsRewardsClaimed);
         this.mStarsRewardsClaimed = null;
      }
      
      public function addStarsRewardClaimed(param1:String, param2:Boolean = true) : void
      {
         if(this.mStarsRewardsClaimed == null)
         {
            this.mStarsRewardsClaimed = new Dictionary(true);
         }
         this.mStarsRewardsClaimed[param1] = true;
         if(param2 && this.mIsOwner)
         {
            InstanceMng.getUserDataMng().updateStarsRewardsClaimed();
         }
      }
      
      public function isStarsRewardAlreadyClaimed(param1:String) : Boolean
      {
         var _loc2_:Boolean = false;
         if(this.mStarsRewardsClaimed != null)
         {
            _loc2_ = this.mStarsRewardsClaimed[param1] == true;
         }
         return _loc2_;
      }
      
      public function getComicsRead() : Dictionary
      {
         return this.mComicsRead;
      }
      
      public function addComicRead(param1:String, param2:Boolean = true) : void
      {
         if(this.mComicsRead == null)
         {
            this.mComicsRead = new Dictionary(true);
         }
         this.mComicsRead[param1] = true;
         if(param2 && this.mIsOwner)
         {
            InstanceMng.getUserDataMng().updateComicsRead();
         }
      }
      
      public function removeComicRead(param1:String, param2:Boolean = true) : void
      {
         if(this.mComicsRead != null)
         {
            this.mComicsRead[param1] = false;
         }
         if(param2 && this.mIsOwner)
         {
            InstanceMng.getUserDataMng().updateComicsRead();
         }
      }
      
      public function setComicsRead(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         if(param1 != null && param1 != "")
         {
            _loc2_ = param1.split(",");
            _loc4_ = 0;
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc3_ = _loc2_[_loc4_];
               if(_loc3_.length > 0)
               {
                  this.addComicRead(_loc3_,false);
                  this.addComicRead(_loc3_,false);
                  this.addComicRead(_loc3_,false);
               }
               _loc4_++;
            }
         }
      }
      
      public function resetComicsRead() : void
      {
         DictionaryUtils.clearDictionary(this.mComicsRead);
         this.mComicsRead = null;
      }
      
      public function isComicRead(param1:String) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
         if(this.mComicsRead != null)
         {
            _loc2_ = this.mComicsRead[param1 + "_" + _loc3_.toString()] == true;
         }
         return _loc2_;
      }
      
      public function getHighestMapUnlockedIndex() : int
      {
         return this.mHighestMapsUnlockedIndex;
      }
      
      public function setHighestMapUnlockedIndex(param1:int, param2:Boolean = true) : void
      {
         this.mHighestMapsUnlockedIndex = param1;
         if(param2 && this.mIsOwner)
         {
            InstanceMng.getUserDataMng().updateHighestMapUnlockedIndex();
         }
      }
      
      public function isMapUnlocked(param1:int) : Boolean
      {
         return this.mHighestMapsUnlockedIndex >= param1;
      }
      
      public function onLevelFailed() : void
      {
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:Function = null;
         var _loc6_:Array = null;
         var _loc1_:LevelDef = InstanceMng.getBattleEngine().getLevelDef();
         if(InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            _loc3_ = this.getCurrentLevelIndex(UserDataMng.DIFFICULTY_EASY);
            _loc4_ = _loc3_ >= 20 || Root.smBattleData != null && (Root.smBattleData.isRaid || Root.smBattleData.isDungeon);
            _loc5_ = _loc4_ ? InstanceMng.getPopupMng().openPostBoostPopup : InstanceMng.getPopupMng().openLevelFailedPopup;
            _loc6_ = _loc4_ ? null : [_loc1_];
            FSBattleScreen(InstanceMng.getCurrentScreen()).createDefeatAnimation(3,_loc5_,_loc6_);
         }
         Utils.playSound(Constants.SOUND_DEFEAT,SoundManager.TYPE_SFX);
         var _loc2_:String = Boolean(Root) && Boolean(Root.smBattleData) && Boolean(Root.smBattleData.easyMode) ? FSTracker.ACTION_FAILED_EASY_MODE : FSTracker.ACTION_FAILED;
         if(_loc1_)
         {
            FSTracker.trackMiscAction(FSTracker.getLevelCategoryByDifficulty(),_loc2_,{"level":_loc1_.getSku()});
         }
         if(!InstanceMng.getBattleEngine().isPvPMatch())
         {
            InstanceMng.getQuestsMng().addActionPerformed(QuestsMng.TARGET_TYPE_LOSS,1,false,["bossHp:" + InstanceMng.getBattleEngine().getOpponentBattleInfo().getHP().toString()]);
         }
         InstanceMng.getUserDataMng().persistenceSaveData();
      }
      
      public function onLevelCompleted(param1:LevelDef) : int
      {
         var _loc10_:String = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:Array = null;
         var _loc14_:String = null;
         var _loc15_:String = null;
         var _loc16_:int = 0;
         var _loc17_:String = null;
         var _loc18_:JobDef = null;
         var _loc19_:Boolean = false;
         var _loc20_:PackDef = null;
         var _loc21_:Array = null;
         var _loc22_:int = 0;
         var _loc23_:Number = NaN;
         var _loc24_:Boolean = false;
         var _loc25_:LevelDef = null;
         var _loc26_:Boolean = false;
         var _loc2_:Boolean = false;
         if(!Root.smBattleData.isDungeon)
         {
            _loc2_ = this.isLevelCompleted(param1);
            this.playerGainLife(1,false,param1);
            if(_loc2_)
            {
               _loc10_ = InstanceMng.getLevelsDefMng().getNextLevelSku();
               InstanceMng.getServerConnection().notifyLevelUp(_loc10_,this.mCurrentDifficulty);
            }
         }
         var _loc3_:String = _loc2_ ? param1.getRewardSkuByDifficulty(this.mCurrentDifficulty,this.getMapWorldChoice(param1.getMapWorldParentIndex())) : param1.getReplayRewardSkuByDifficulty(this.mCurrentDifficulty);
         var _loc4_:RewardDef = RewardDef(InstanceMng.getRewardsDefMng().getDefBySku(_loc3_));
         if(_loc4_ != null)
         {
            _loc11_ = _loc4_.getGold();
            _loc12_ = _loc4_.getExp();
            _loc13_ = _loc4_.getCardsArr();
            _loc14_ = _loc4_.getPackSku();
            _loc15_ = "";
            FSDebug.debugTrace("Increasing gold in: " + _loc11_ + " points");
            FSDebug.debugTrace("Increasing exp in: " + _loc12_ + " points");
            if(_loc11_ > 0)
            {
               this.addGold(_loc11_);
            }
            this.mExp += _loc12_ > 0 ? _loc12_ : 0;
            if(_loc13_)
            {
               if(_loc13_ != null)
               {
                  _loc18_ = Config.getConfig().gameHasClassSystem() ? JobDef(InstanceMng.getJobsDefMng().getDefByIndex(0)) : null;
                  _loc19_ = true;
                  _loc16_ = 0;
                  while(_loc16_ < _loc13_.length)
                  {
                     _loc17_ = String(_loc13_[_loc16_]).split(":")[0];
                     if(_loc17_ != "" && Config.getConfig().gameHasClassSystem())
                     {
                        _loc19_ = Boolean(_loc18_) && _loc18_.getActiveDefaultSku() != _loc17_ && _loc18_.getActiveSecondarySku() != _loc17_;
                     }
                     if(_loc19_)
                     {
                        this.addCardToCollection(_loc13_[_loc16_]);
                     }
                     this.addCardToNewCardsCollection(_loc13_[_loc16_]);
                     _loc15_ += _loc15_ != "" ? "," + _loc13_[_loc16_] : _loc13_[_loc16_];
                     _loc16_++;
                  }
               }
            }
            if(_loc14_)
            {
               _loc20_ = PackDef(InstanceMng.getPacksDefMng().getDefBySku(_loc14_));
               if(_loc20_.areCardsPredefined())
               {
                  _loc21_ = _loc20_.getSpecialCardsArr();
                  if(_loc21_ != null)
                  {
                     _loc22_ = 0;
                     while(_loc22_ < _loc21_.length)
                     {
                        this.addCardToCollection(_loc21_[_loc22_]);
                        this.addCardToNewCardsCollection(_loc21_[_loc22_]);
                        _loc22_++;
                     }
                  }
               }
            }
            if(_loc2_ && param1.getLevelIndex() == InstanceMng.getTutorialMng().getFirstNonTutorialLevelIndex() - 1 && this.mCurrentDifficulty == UserDataMng.DIFFICULTY_EASY)
            {
               TweenMax.delayedCall(2.5,Utils.setLogText,[TextManager.getText("TID_TUTORIAL_COMPLETED"),false,false,false]);
            }
         }
         else
         {
            _loc23_ = param1.getExperience(!_loc2_);
            JobsMng.winJobExperience(_loc23_);
         }
         this.increaseCurrentLevelSku(param1,_loc2_);
         if(_loc2_)
         {
            _loc24_ = InstanceMng.getLevelsDefMng().isLastPlayableLevel(param1);
            if(!_loc24_)
            {
               _loc25_ = LevelDef(InstanceMng.getLevelsDefMng().getDefBySku(this.getCurrentLevelSkuByDifficulty(this.mCurrentDifficulty)));
               if(_loc25_ != null)
               {
                  _loc26_ = InstanceMng.getMapsDefMng().isFirstLevelOfMap(_loc25_.getLevelIndex());
                  if((_loc26_) && _loc2_)
                  {
                     this.updateFinishedLastCampaignTimestamp();
                  }
               }
            }
            else if(_loc2_)
            {
               this.updateFinishedLastCampaignTimestamp();
            }
         }
         InstanceMng.getUserDataMng().persistenceSaveData();
         var _loc5_:Number = ServerConnection.smServerTimeMS == 0 || ServerConnection.smServerTimeMS == -1 ? TimerUtil.currentTimeMillis() : ServerConnection.smServerTimeMS;
         var _loc6_:String = TimerUtil.dateFromMs(_loc5_).toString();
         var _loc7_:int = InstanceMng.getScoreMng().calculateFinalScore(true);
         Utils.setStat(Constants.STAT_LEVEL_MAX_SCORE,_loc7_);
         InstanceMng.getUserDataMng().updateLevelCompleted(param1.getSku(),_loc7_,_loc6_,_loc5_,this.mCurrentDifficulty);
         var _loc8_:String = Boolean(Root) && Boolean(Root.smBattleData) && Boolean(Root.smBattleData.easyMode) ? FSTracker.ACTION_COMPLETED_EASY_MODE : FSTracker.ACTION_COMPLETED;
         if(Config.PRODUCTION_BUILD)
         {
            if(this.mCurrentDifficulty == UserDataMng.DIFFICULTY_EASY && param1.getLevelIndex() <= 20)
            {
               FSTracker.trackFirebaseEvent("COMPLETED_LVL_" + param1.getLevelIndex());
            }
         }
         var _loc9_:Object = new Object();
         _loc9_.level = param1.getLevelIndex();
         _loc9_.gold = _loc11_ > 0 ? _loc11_ : 0;
         _loc9_.cardsRewarded = _loc15_ != "" && _loc15_ != null ? _loc15_ : "";
         _loc9_.packRewarded = _loc14_ != "" && _loc14_ != null ? _loc14_ : "";
         FSTracker.trackMiscAction(FSTracker.getLevelCategoryByDifficulty(),_loc8_,_loc9_);
         InstanceMng.getApplication().firebaseAddToDatabase(param1.getLevelIndex(),this.mCurrentDifficulty,true,FSBattleScreen.smUserPayedInThisLevel,_loc2_);
         return _loc7_;
      }
      
      public function increaseCurrentLevelSku(param1:LevelDef = null, param2:Boolean = false) : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:RankDef = null;
         var _loc11_:String = null;
         var _loc5_:int = this.getCurrentDifficulty();
         var _loc6_:String = this.getCurrentLevelSkuByDifficulty(_loc5_);
         var _loc7_:int = InstanceMng.getLevelsDefMng().getLevelIndexByLevelSku(_loc6_);
         if(param1 == null)
         {
            _loc3_ = InstanceMng.getLevelsDefMng().getNextLevelSku();
            _loc4_ = InstanceMng.getLevelsDefMng().getLevelIndexByLevelSku(_loc3_);
         }
         else if(param2)
         {
            _loc3_ = InstanceMng.getLevelsDefMng().getNextLevelSku();
            _loc4_ = InstanceMng.getLevelsDefMng().getLevelIndexByLevelSku(_loc3_);
         }
         if(param2)
         {
            switch(_loc5_)
            {
               case UserDataMng.DIFFICULTY_EASY:
                  Utils.setStat(Constants.STAT_USER_LEVEL,_loc4_);
                  break;
               case UserDataMng.DIFFICULTY_MEDIUM:
                  Utils.setStat(Constants.STAT_USER_LEVEL_HARD,_loc4_);
                  break;
               case UserDataMng.DIFFICULTY_HARD:
                  Utils.setStat(Constants.STAT_USER_LEVEL_MASTER,_loc4_);
            }
            _loc8_ = RankDef(InstanceMng.getRanksDefMng().getDefByCurrentLevel(_loc4_)).getIndex();
            _loc9_ = this.mRankIndex;
            this.setCurrentLevelSkuByDifficulty(_loc5_,_loc3_);
            if(_loc9_ < _loc8_ && _loc5_ == UserDataMng.DIFFICULTY_EASY)
            {
               Utils.setStat(Constants.STAT_USER_RANK,_loc8_);
               InstanceMng.getPopupMng().openRankPromotePopup(param1);
               _loc10_ = RankDef(InstanceMng.getRanksDefMng().getDefByCurrentLevel(_loc4_));
               _loc11_ = _loc10_ != null ? _loc10_.getBadgeSku() : "";
               if(_loc11_ != null && _loc11_ != "")
               {
                  this.addBadgeToCollection(_loc10_.getBadgeSku());
               }
            }
            else
            {
               InstanceMng.getPopupMng().openLevelCompletedPopup(param1,param2);
            }
         }
         else
         {
            InstanceMng.getPopupMng().openLevelCompletedPopup(param1,param2);
         }
         FSDebug.debugTrace("[UserData.increaseCurrentLevelSku] - CurrentLevelSku is now: " + this.getCurrentLevelSku());
      }
      
      public function getLastLevelCompletedIndexByDifficulty(param1:int) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         switch(param1)
         {
            case UserDataMng.DIFFICULTY_EASY:
               _loc3_ = this.mCurrentLevelIndex;
               break;
            case UserDataMng.DIFFICULTY_MEDIUM:
               _loc3_ = this.mCurrentLevelMediumIndex;
               break;
            case UserDataMng.DIFFICULTY_HARD:
               _loc3_ = this.mCurrentLevelHardIndex;
               break;
            default:
               _loc3_ = this.mCurrentLevelIndex;
         }
         return _loc3_ > 1 ? int(_loc3_ - 1) : _loc3_;
      }
      
      public function isLevelCompleted(param1:LevelDef) : Boolean
      {
         var _loc3_:String = null;
         var _loc4_:LevelDef = null;
         var _loc2_:Boolean = false;
         if(param1 != null)
         {
            _loc3_ = this.getCurrentLevelSkuByDifficulty(this.mCurrentDifficulty);
            _loc4_ = LevelDef(InstanceMng.getLevelsDefMng().getDefBySku(_loc3_));
            if(_loc4_ == null)
            {
               return false;
            }
            _loc2_ = param1.getLevelIndex() >= _loc4_.getLevelIndex();
         }
         return _loc2_;
      }
      
      public function isLastLevelCompleted(param1:LevelDef) : Boolean
      {
         var _loc3_:String = null;
         var _loc4_:LevelDef = null;
         var _loc2_:Boolean = false;
         if(param1 != null)
         {
            _loc3_ = this.getCurrentLevelSkuByDifficulty(this.mCurrentDifficulty);
            _loc4_ = LevelDef(InstanceMng.getLevelsDefMng().getDefBySku(_loc3_));
            if(_loc4_ == null)
            {
               return false;
            }
            _loc2_ = param1.getLevelIndex() == _loc4_.getLevelIndex() - 1;
         }
         return _loc2_;
      }
      
      public function getPhoto() : FSImage
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc1_:FSImage = null;
         var _loc2_:String = this.getPhotoUrl();
         var _loc3_:Texture = Root.assets.getTexture(_loc2_);
         if(_loc3_ == null)
         {
            _loc4_ = this.mIsOwner ? FSResourceMng.DEFAULT_PHOTO_NAME : FSResourceMng.DEFAULT_PHOTO_AI_NAME;
            _loc5_ = this.mIsOwner ? "_portrait" : "";
            _loc4_ += _loc5_;
            _loc3_ = Root.assets.getTexture(_loc4_);
         }
         if(_loc3_ != null)
         {
            _loc1_ = new FSImage(_loc3_);
         }
         if(_loc3_)
         {
            _loc1_.width = _loc1_.width > 1024 ? 1024 : _loc1_.width;
            _loc1_.height = _loc1_.height > 1024 ? 1024 : _loc1_.height;
         }
         return _loc1_;
      }
      
      private function getOwnerCardCatalogToString(param1:Dictionary) : String
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc2_:String = "";
         if(param1 != null)
         {
            _loc3_ = DictionaryUtils.getKeys(param1);
            _loc3_.sort();
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc2_ += _loc3_[_loc4_] + ":" + param1[_loc3_[_loc4_]];
               if(_loc4_ < _loc3_.length - 1)
               {
                  _loc2_ += _loc2_ != "" ? "," : "";
               }
               _loc4_++;
            }
         }
         return _loc2_;
      }
      
      public function getOwnerDeckToString(param1:int) : String
      {
         var _loc2_:String = "";
         if(this.mDecks != null)
         {
            _loc2_ = this.getOwnerCardCatalogToString(this.mDecks[param1]);
         }
         return _loc2_;
      }
      
      public function getBoostsToString() : String
      {
         return this.getDictionaryAttributeToString(this.mBoostsCatalog,true);
      }
      
      public function getDeckNamesToString() : String
      {
         return this.getDictionaryAttributeToString(this.mDeckNames,true);
      }
      
      public function getAvailableJobsToString() : String
      {
         return this.getDictionaryAttributeToString(this.mAvailableJobs);
      }
      
      public function getAvailableSkinsToString() : String
      {
         return this.getDictionaryAttributeToString(this.mAvailableSkins);
      }
      
      public function getAvailablePortraitsToString() : String
      {
         return this.getDictionaryAttributeToString(this.mAvailablePortraits);
      }
      
      public function getComicsReadToString() : String
      {
         return this.getDictionaryAttributeToString(this.mComicsRead);
      }
      
      private function getBadgesRewardsClaimedToString() : String
      {
         return this.getDictionaryAttributeToString(this.mBadgesRewardsClaimed);
      }
      
      private function getStarsRewardsClaimedToString() : String
      {
         return this.getDictionaryAttributeToString(this.mStarsRewardsClaimed);
      }
      
      public function getQuestsClaimedToString() : String
      {
         return this.getDictionaryAttributeToString(this.mQuestsClaimed);
      }
      
      public function getQuestsCompletedToString() : String
      {
         return this.getDictionaryAttributeToString(this.mQuestsCompleted);
      }
      
      public function getQuestsNotifiedAsCompletedToString() : String
      {
         return this.getDictionaryAttributeToString(this.mQuestsNotifiedAsCompleted);
      }
      
      public function getQuestsProgressToString() : String
      {
         return this.getDictionaryAttributeToString(this.mQuestsProgress,true);
      }
      
      public function getOwnerCollectionToString() : String
      {
         return this.getOwnerCardCatalogToString(this.mCardCollection);
      }
      
      public function getOwnerNewCardsCollectionToString() : String
      {
         return this.getOwnerCardCatalogToString(this.mNewCardsCollection);
      }
      
      public function isCardInNewCardsCollection(param1:String) : Boolean
      {
         return Boolean(this.mNewCardsCollection) && this.mNewCardsCollection[param1] != null && this.mNewCardsCollection[param1] > 0;
      }
      
      public function getOwnerFavouriteCardsCollectionToString() : String
      {
         return this.getOwnerCardCatalogToString(this.mFavouritesCollection);
      }
      
      public function isCardInFavouritesCollection(param1:String) : Boolean
      {
         return Boolean(this.mFavouritesCollection) && this.mFavouritesCollection[param1] != null;
      }
      
      public function getOwnerAuctionIdCreatedArrToString() : String
      {
         return this.getOwnerAuctionsIdCreatedArrToString(this.mAuctionIdCreatedArr);
      }
      
      public function getOwnerAuctionsIdCreatedArrToString(param1:Array) : String
      {
         var _loc3_:int = 0;
         var _loc2_:String = "";
         if(param1 != null)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               if(String(param1[_loc3_]) != "undefined" && String(param1[_loc3_]) != "")
               {
                  _loc2_ += param1[_loc3_];
               }
               if(_loc3_ < param1.length - 1)
               {
                  _loc2_ += _loc2_ != "" ? "," : "";
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      public function getOwnerUniquePacksArrToString() : String
      {
         return this.getUniquePacksArrToString(this.mUniquePacksArr);
      }
      
      public function getUniquePacksArrToString(param1:Array) : String
      {
         var _loc3_:int = 0;
         var _loc2_:String = "";
         if(param1 != null)
         {
            param1.sort();
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               _loc2_ += param1[_loc3_];
               if(_loc3_ < param1.length - 1)
               {
                  _loc2_ += _loc2_ != "" ? "," : "";
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      public function getOwnerAuctionIdBiddedArrToString() : String
      {
         return this.getOwnerAuctionsIdBiddedArrToString(this.mAuctionIdBiddedArr);
      }
      
      public function getOwnerAuctionsIdBiddedArrToString(param1:Array) : String
      {
         var _loc3_:int = 0;
         var _loc2_:String = "";
         if(param1 != null)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               if(String(param1[_loc3_]) != "undefined" && String(param1[_loc3_]) != "")
               {
                  _loc2_ += param1[_loc3_];
               }
               if(_loc3_ < param1.length - 1)
               {
                  _loc2_ += _loc2_ != "" ? "," : "";
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      public function setPhotoTexture(param1:Texture) : void
      {
         this.mPhoto = param1;
      }
      
      public function getPhotoTexture() : Texture
      {
         return this.mPhoto;
      }
      
      public function printUserData() : void
      {
         var _loc1_:String = "";
         _loc1_ += "********USER DATA*********";
         _loc1_ += "\n Name: " + this.mName;
         _loc1_ += "\n Current level: " + this.mCurrentLevelSku;
         _loc1_ += "\n Gold: " + this.mGold.value;
         _loc1_ += "\n**************************";
         FSDebug.debugTrace(_loc1_);
      }
      
      public function isSelectedDeckSizeCorrect(param1:LevelDef = null, param2:Boolean = false) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:int = param2 ? this.getSelectedDeckIndexPvP() : this.getSelectedDeckIndex();
         var _loc5_:Boolean = Boolean(param1) && param1.isTutorialLevel();
         if(_loc4_ == TUTORIAL_DECK_INDEX && _loc5_)
         {
            return true;
         }
         var _loc6_:Dictionary = this.getCardCollection();
         return DictionaryUtils.checkIfDeckSizeCorrect(this.getDeck(_loc4_),_loc6_,_loc4_);
      }
      
      public function flagsRead(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:Array = null;
         if(param1 != null)
         {
            _loc2_ = param1.split(",");
            if(this.mFlags == null)
            {
               this.mFlags = new Dictionary(true);
            }
            for each(_loc3_ in _loc2_)
            {
               if(_loc3_ != "")
               {
                  _loc4_ = _loc3_.split(":");
                  if(_loc4_.length == 1)
                  {
                     this.mFlags[_loc3_] = 1;
                  }
                  else
                  {
                     this.mFlags[_loc4_[0]] = _loc4_[1];
                  }
               }
            }
         }
      }
      
      public function resetFlags() : void
      {
         DictionaryUtils.clearDictionary(this.mFlags);
         this.mFlags = null;
      }
      
      private function flagsGetValue(param1:String) : Object
      {
         var _loc2_:Object = null;
         if(this.mFlags != null)
         {
            _loc2_ = this.mFlags[param1];
         }
         return _loc2_;
      }
      
      private function flagsSetValue(param1:String, param2:Object) : void
      {
         if(this.mFlags == null)
         {
            this.mFlags = new Dictionary(true);
         }
         this.mFlags[param1] = param2;
      }
      
      public function flagsGetValueAsInt(param1:String) : int
      {
         var _loc2_:int = 0;
         if(this.mFlags != null && this.mFlags[param1] != null)
         {
            _loc2_ = int(this.mFlags[param1]);
         }
         return _loc2_;
      }
      
      public function flagsGetValueAsNumber(param1:String) : Number
      {
         var _loc2_:Number = 0;
         if(this.mFlags != null && this.mFlags[param1] != null)
         {
            _loc2_ = Number(this.mFlags[param1]);
         }
         return _loc2_;
      }
      
      public function flagsToString() : String
      {
         return this.getDictionaryAttributeToString(this.mFlags,true);
      }
      
      public function tutorialsSeenRead(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:Array = null;
         if(param1 != null)
         {
            _loc2_ = param1.split(",");
            if(this.mTutorialsSeen == null)
            {
               this.mTutorialsSeen = new Dictionary(true);
            }
            for each(_loc3_ in _loc2_)
            {
               if(_loc3_ != "")
               {
                  _loc4_ = _loc3_.split(":");
                  if(_loc4_.length == 1)
                  {
                     this.mTutorialsSeen[_loc3_] = 1;
                  }
                  else
                  {
                     this.mTutorialsSeen[_loc4_[0]] = _loc4_[1];
                  }
               }
            }
         }
      }
      
      public function resetTutorialsSeen() : void
      {
         DictionaryUtils.clearDictionary(this.mTutorialsSeen);
         this.mTutorialsSeen = null;
      }
      
      public function tutorialsSeenGetValue(param1:String) : Object
      {
         var _loc2_:Object = null;
         if(this.mTutorialsSeen != null)
         {
            _loc2_ = this.mTutorialsSeen[param1];
         }
         return _loc2_;
      }
      
      public function tutorialsSeenSetValue(param1:String, param2:Object) : void
      {
         if(this.mTutorialsSeen == null)
         {
            this.mTutorialsSeen = new Dictionary(true);
         }
         this.mTutorialsSeen[param1] = param2;
      }
      
      public function tutorialsSeenGetValueAsInt(param1:String) : int
      {
         var _loc2_:int = 0;
         if(this.mTutorialsSeen != null && this.mTutorialsSeen[param1] != null)
         {
            _loc2_ = int(this.mTutorialsSeen[param1]);
         }
         return _loc2_;
      }
      
      public function tutorialsSeenToString() : String
      {
         return this.getDictionaryAttributeToString(this.mTutorialsSeen,true);
      }
      
      public function levelsFailedInfoRead(param1:String, param2:String, param3:Object) : void
      {
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         if(param1 != null)
         {
            _loc6_ = param1.split(",");
            if(this.mLevelsFailedInfo == null)
            {
               this.mLevelsFailedInfo = new Dictionary(true);
            }
            for each(_loc4_ in _loc6_)
            {
               if(_loc4_ != "")
               {
                  _loc5_ = _loc4_.split(":");
                  if(_loc5_.length == 1)
                  {
                     this.mLevelsFailedInfo[_loc4_] = 1;
                  }
                  else
                  {
                     this.mLevelsFailedInfo[_loc5_[0]] = _loc5_[1];
                  }
               }
            }
         }
         var _loc7_:String = param3 != null && Boolean(param3.levelsFailedFirebaseToString()) ? param3.levelsFailedFirebaseToString() : null;
         var _loc8_:Number = this.GetUpdateDateOfLevelsFailedFirebase(_loc7_);
         var _loc9_:Number = this.GetUpdateDateOfLevelsFailedFirebase(param2);
         if(_loc8_ > _loc9_)
         {
            if(_loc7_ != null)
            {
               _loc6_ = _loc7_.split(",");
               if(this.mLevelsFailedFirebase == null)
               {
                  this.mLevelsFailedFirebase = new Dictionary(true);
               }
               for each(_loc4_ in _loc6_)
               {
                  if(_loc4_ != "")
                  {
                     _loc5_ = _loc4_.split(":");
                     if(_loc5_.length == 1)
                     {
                        if(_loc4_ != "0" && _loc4_ != "-1")
                        {
                           this.mLevelsFailedFirebase[_loc4_] = 1;
                        }
                     }
                     else if(_loc5_[0] != "0" && _loc5_[0] != "-1")
                     {
                        this.mLevelsFailedFirebase[_loc5_[0]] = _loc5_[1];
                     }
                  }
               }
            }
         }
         else if(param2 != null)
         {
            _loc6_ = param2.split(",");
            if(this.mLevelsFailedFirebase == null)
            {
               this.mLevelsFailedFirebase = new Dictionary(true);
            }
            for each(_loc4_ in _loc6_)
            {
               if(_loc4_ != "")
               {
                  _loc5_ = _loc4_.split(":");
                  if(_loc5_.length == 1)
                  {
                     if(_loc4_ != "0" && _loc4_ != "-1")
                     {
                        this.mLevelsFailedFirebase[_loc4_] = 1;
                     }
                  }
                  else if(_loc5_[0] != "0" && _loc5_[0] != "-1")
                  {
                     this.mLevelsFailedFirebase[_loc5_[0]] = _loc5_[1];
                  }
               }
            }
         }
      }
      
      private function GetUpdateDateOfLevelsFailedFirebase(param1:String) : Number
      {
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc2_:Array = param1 != null ? param1.split(",") : null;
         for each(_loc4_ in _loc2_)
         {
            if(_loc4_ != "")
            {
               _loc3_ = _loc4_.split(":");
               if(_loc3_.length > 1)
               {
                  if(_loc3_[0] == "updated")
                  {
                     return _loc3_[1];
                  }
               }
            }
         }
         return 0;
      }
      
      public function resetFailedLevelsInfo() : void
      {
         DictionaryUtils.clearDictionary(this.mLevelsFailedInfo);
         this.mLevelsFailedInfo = null;
      }
      
      public function levelsFailedInfoSetValue(param1:String, param2:Object) : void
      {
         if(this.mLevelsFailedInfo == null)
         {
            this.mLevelsFailedInfo = new Dictionary(true);
         }
         this.mLevelsFailedInfo[param1] = param2;
      }
      
      public function levelsFailedFirebaseSetValue(param1:String, param2:Object) : void
      {
         var _loc3_:Number = NaN;
         if(this.mLevelsFailedFirebase == null)
         {
            this.mLevelsFailedFirebase = new Dictionary(true);
         }
         if(param1 != "-1" && param1 != "0")
         {
            this.mLevelsFailedFirebase[param1 + "_" + this.mCurrentDifficulty] = param2;
            _loc3_ = ServerConnection.smServerTimeMS > 0 ? ServerConnection.smServerTimeMS : TimerUtil.currentTimeMillis();
            this.mLevelsFailedFirebase["updated"] = _loc3_;
         }
      }
      
      public function deleteLevelFromFailedInfo(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         if(this.mLevelsFailedInfo)
         {
            delete this.mLevelsFailedInfo[param1];
         }
         if(this.mLevelsFailedFirebase)
         {
            _loc2_ = InstanceMng.getLevelsDefMng().getLevelIndexByLevelSku(param1);
            delete this.mLevelsFailedFirebase[_loc2_ + "_" + this.mCurrentDifficulty];
            _loc3_ = ServerConnection.smServerTimeMS > 0 ? ServerConnection.smServerTimeMS : TimerUtil.currentTimeMillis();
            this.mLevelsFailedFirebase["updated"] = _loc3_;
         }
      }
      
      public function increaseLevelFailedInfoByLevelSku(param1:String) : void
      {
         this.levelsFailedInfoSetValue(param1,this.getLevelsFailedInfoByLevelSku(param1) + 1);
      }
      
      public function increaseLevelFailedFirebaseByLevel(param1:int) : void
      {
         this.levelsFailedFirebaseSetValue(param1.toString(),this.getLevelsFailedFirebaseByLevel(param1) + 1);
      }
      
      public function getLevelsFailedInfoByLevelSku(param1:String) : int
      {
         var _loc2_:int = 0;
         if(this.mLevelsFailedInfo != null && this.mLevelsFailedInfo[param1] != null)
         {
            _loc2_ = int(this.mLevelsFailedInfo[param1]);
         }
         return _loc2_;
      }
      
      public function getLevelsFailedFirebaseByLevel(param1:int) : int
      {
         var _loc2_:int = 0;
         if(this.mLevelsFailedFirebase != null && this.mLevelsFailedFirebase[param1 + "_" + this.mCurrentDifficulty] != null)
         {
            _loc2_ = int(this.mLevelsFailedFirebase[param1 + "_" + this.mCurrentDifficulty]);
         }
         return _loc2_;
      }
      
      public function levelsFailedInfoToString() : String
      {
         var _loc2_:String = null;
         var _loc1_:String = "";
         for(_loc2_ in this.mLevelsFailedInfo)
         {
            _loc1_ += _loc2_ + ":" + this.mLevelsFailedInfo[_loc2_] + ",";
         }
         return _loc1_;
      }
      
      public function levelsFailedFirebaseToString() : String
      {
         var _loc2_:String = null;
         var _loc1_:String = "";
         for(_loc2_ in this.mLevelsFailedFirebase)
         {
            _loc1_ += _loc2_ + ":" + this.mLevelsFailedFirebase[_loc2_] + ",";
         }
         return _loc1_;
      }
      
      public function setGameSpeedFactor(param1:int) : void
      {
         this.flagsSetValue(FLAGS_SPEED_FACTOR,param1);
         Config.smGameSpeedMultiplier = param1;
      }
      
      public function setSound(param1:Boolean) : void
      {
         this.flagsSetValue(FLAGS_SOUND,param1 ? "1" : "0");
         Utils.setSFXOn(param1);
      }
      
      public function setSoundVol(param1:Number) : void
      {
         this.flagsSetValue(FLAGS_SOUND_VOL,param1);
         Utils.setSFXOn(param1 > 0);
         if(SoundManager.getInstance())
         {
            SoundManager.getInstance().onVolumeChanged();
         }
      }
      
      public function setUsedFreeBoost(param1:Boolean) : void
      {
         this.flagsSetValue(FLAGS_FREE_BOOST,param1 ? "1" : "0");
      }
      
      public function flagsGetUsedFreeBoost() : Boolean
      {
         var _loc1_:Boolean = false;
         if(this.flagsGetValue(FLAGS_FREE_BOOST) != null)
         {
            return this.flagsGetValueAsInt(FLAGS_FREE_BOOST) == 1;
         }
         this.setUsedFreeBoost(false);
         return false;
      }
      
      public function flagsGetGameSpeed() : int
      {
         var _loc2_:int = 0;
         var _loc1_:int = 1;
         if(this.mIsOwner)
         {
            if(this.flagsGetValue(FLAGS_SPEED_FACTOR) != null)
            {
               _loc2_ = this.flagsGetValueAsInt(FLAGS_SPEED_FACTOR);
               Config.smGameSpeedMultiplier = _loc2_;
               return _loc2_;
            }
            this.setGameSpeedFactor(1);
            return 1;
         }
         return _loc1_;
      }
      
      public function setAPLeftWarning(param1:Boolean) : void
      {
         this.flagsSetValue(FLAGS_AP_LEFT_WARNING,param1 ? "1" : "0");
      }
      
      public function flagsGetAPLeftWarning() : Boolean
      {
         if(this.flagsGetValue(FLAGS_AP_LEFT_WARNING) != null)
         {
            return this.flagsGetValueAsInt(FLAGS_AP_LEFT_WARNING) == 1;
         }
         return true;
      }
      
      public function setMediumDifficultyUnlockedTutorialSeen(param1:Boolean) : void
      {
         this.flagsSetValue(FLAGS_DIFFICULTY_MEDIUM_UNLOCKED,param1 ? "1" : "0");
      }
      
      public function flagsGetMediumDifficultyUnlockedTutorialSeen() : Boolean
      {
         if(this.flagsGetValue(FLAGS_DIFFICULTY_MEDIUM_UNLOCKED) != null)
         {
            return this.flagsGetValueAsInt(FLAGS_DIFFICULTY_MEDIUM_UNLOCKED) == 1;
         }
         return false;
      }
      
      public function setHardDifficultyUnlockedTutorialSeen(param1:Boolean) : void
      {
         this.flagsSetValue(FLAGS_DIFFICULTY_HARD_UNLOCKED,param1 ? "1" : "0");
      }
      
      public function flagsGetHardDifficultyUnlockedTutorialSeen() : Boolean
      {
         if(this.flagsGetValue(FLAGS_DIFFICULTY_HARD_UNLOCKED) != null)
         {
            return this.flagsGetValueAsInt(FLAGS_DIFFICULTY_HARD_UNLOCKED) == 1;
         }
         return false;
      }
      
      public function flagsGetSound() : Boolean
      {
         var _loc1_:Boolean = false;
         if(this.flagsGetValue(FLAGS_SOUND) != null)
         {
            _loc1_ = this.flagsGetValueAsInt(FLAGS_SOUND) == 1;
            if(_loc1_ != Utils.isSFXOn())
            {
               Utils.setSFXOn(_loc1_);
            }
            return _loc1_;
         }
         this.setSound(true);
         return true;
      }
      
      public function flagsGetSoundVolume() : Number
      {
         var _loc1_:Number = NaN;
         var _loc2_:Boolean = false;
         if(this.flagsGetValue(FLAGS_SOUND_VOL) != null)
         {
            _loc1_ = this.flagsGetValueAsNumber(FLAGS_SOUND_VOL);
            _loc2_ = _loc1_ > 0;
            if(_loc2_ != Utils.isSFXOn())
            {
               Utils.setSFXOn(_loc2_);
            }
            return _loc1_;
         }
         this.setSoundVol(1);
         this.setSound(true);
         return 1;
      }
      
      public function setMusic(param1:Boolean) : void
      {
         this.flagsSetValue(FLAGS_MUSIC,param1 ? "1" : "0");
         Utils.setMusicOn(param1);
      }
      
      public function setMusicVol(param1:Number) : void
      {
         this.flagsSetValue(FLAGS_MUSIC_VOL,param1);
         Utils.setMusicOn(param1 > 0);
         if(SoundManager.getInstance())
         {
            SoundManager.getInstance().onVolumeChanged();
         }
      }
      
      public function flagsGetMusic() : Boolean
      {
         var _loc1_:Boolean = false;
         if(this.flagsGetValue(FLAGS_MUSIC) != null)
         {
            _loc1_ = this.flagsGetValueAsInt(FLAGS_MUSIC) == 1;
            if(_loc1_ != Utils.isMusicOn())
            {
               Utils.setMusicOn(_loc1_);
            }
            return _loc1_;
         }
         this.setMusic(true);
         return true;
      }
      
      public function flagsGetMusicVolume() : Number
      {
         var _loc1_:Number = NaN;
         var _loc2_:Boolean = false;
         if(this.flagsGetValue(FLAGS_MUSIC_VOL) != null)
         {
            _loc1_ = this.flagsGetValueAsNumber(FLAGS_MUSIC_VOL);
            _loc2_ = _loc1_ > 0;
            if(_loc2_ != Utils.isMusicOn())
            {
               Utils.setMusicOn(_loc2_);
            }
            return _loc1_;
         }
         this.setMusicVol(1);
         this.setMusic(true);
         return 1;
      }
      
      public function set30CardsPopupShown(param1:Boolean) : void
      {
         this.flagsSetValue(FLAGS_30_CARDS_POPUP_SHOWN,param1 ? "1" : "0");
      }
      
      public function flagsGet30CardsPopupShown() : Boolean
      {
         if(this.flagsGetValue(FLAGS_30_CARDS_POPUP_SHOWN) != null)
         {
            return this.flagsGetValueAsInt(FLAGS_30_CARDS_POPUP_SHOWN) == 1;
         }
         return false;
      }
      
      public function setDeckBuilderTutorialShown(param1:Boolean) : void
      {
         this.flagsSetValue(FLAGS_DECK_BUILDER_TUTORIAL_SHOWN,param1 ? "1" : "0");
      }
      
      public function flagsGetDeckBuilderTutorialShown() : Boolean
      {
         if(this.flagsGetValue(FLAGS_DECK_BUILDER_TUTORIAL_SHOWN) != null)
         {
            return this.flagsGetValueAsInt(FLAGS_DECK_BUILDER_TUTORIAL_SHOWN) == 1;
         }
         return false;
      }
      
      public function setFBPostingOn(param1:Boolean) : void
      {
         this.flagsSetValue(FLAGS_POSTING_ON_FB,param1 ? "1" : "0");
      }
      
      public function setFirstChangeName(param1:Boolean) : void
      {
         this.flagsSetValue(FLAGS_FIRST_CHANGE_NAME,param1 ? "1" : "0");
      }
      
      public function updateNickChangePrompt() : void
      {
         var _loc1_:Number = !isNaN(ServerConnection.smServerTimeMS) ? ServerConnection.smServerTimeMS : -1;
         this.flagsSetValue(FLAGS_CHANGE_NICK_PROMPT,_loc1_);
      }
      
      public function flagsGetChangeNickPromptMS() : Number
      {
         if(this.flagsGetValue(FLAGS_CHANGE_NICK_PROMPT) != null)
         {
            return Number(this.flagsGetValue(FLAGS_CHANGE_NICK_PROMPT));
         }
         return -1;
      }
      
      public function flagsIsFirstChangeName() : Boolean
      {
         if(this.flagsGetValue(FLAGS_FIRST_CHANGE_NAME) != null)
         {
            return this.flagsGetValueAsInt(FLAGS_FIRST_CHANGE_NAME) == 1;
         }
         return false;
      }
      
      public function flagsIsFBPostingOn() : Boolean
      {
         if(this.flagsGetValue(FLAGS_POSTING_ON_FB) != null)
         {
            return this.flagsGetValueAsInt(FLAGS_POSTING_ON_FB) == 1;
         }
         return false;
      }
      
      public function setAuctionHouseFirstTime(param1:Boolean) : void
      {
         if(param1)
         {
            this.flagsSetValue(FLAGS_AUCTION_HOUSE_FIRST_TIME,"1");
         }
         else
         {
            this.flagsSetValue(FLAGS_AUCTION_HOUSE_FIRST_TIME,"0");
         }
      }
      
      public function flagsIsAuctionHouseFirstTimeVisited() : Boolean
      {
         if(this.flagsGetValue(FLAGS_AUCTION_HOUSE_FIRST_TIME) != null)
         {
            return this.flagsGetValueAsInt(FLAGS_AUCTION_HOUSE_FIRST_TIME) == 1;
         }
         return false;
      }
      
      public function setOfflinePushNotifsGranted(param1:Boolean) : void
      {
         if(param1)
         {
            this.flagsSetValue(FLAGS_OFFLINE_PUSH_NOTIFS,"1");
         }
         else
         {
            this.flagsSetValue(FLAGS_OFFLINE_PUSH_NOTIFS,"0");
         }
      }
      
      public function flagsOfflinePushNotifsGranted() : Boolean
      {
         if(this.flagsGetValue(FLAGS_OFFLINE_PUSH_NOTIFS) != null)
         {
            return this.flagsGetValueAsInt(FLAGS_OFFLINE_PUSH_NOTIFS) == 1;
         }
         return true;
      }
      
      public function setOnlinePushNotifsGranted(param1:Boolean) : void
      {
         if(param1)
         {
            this.flagsSetValue(FLAGS_ONLINE_PUSH_NOTIFS,"1");
         }
         else
         {
            this.flagsSetValue(FLAGS_ONLINE_PUSH_NOTIFS,"0");
         }
      }
      
      public function flagsOnlinePushNotifsGranted() : Boolean
      {
         if(this.flagsGetValue(FLAGS_ONLINE_PUSH_NOTIFS) != null)
         {
            return this.flagsGetValueAsInt(FLAGS_ONLINE_PUSH_NOTIFS) == 1;
         }
         return true;
      }
      
      public function setTutorialReward1(param1:Boolean) : void
      {
         if(param1)
         {
            this.flagsSetValue(FLAGS_TUTORIAL_REWARD1,"1");
         }
         else
         {
            this.flagsSetValue(FLAGS_TUTORIAL_REWARD1,"0");
         }
      }
      
      public function flagsIsTutorialReward1Claimed() : Boolean
      {
         if(this.flagsGetValue(FLAGS_TUTORIAL_REWARD1) != null)
         {
            return this.flagsGetValueAsInt(FLAGS_TUTORIAL_REWARD1) == 1;
         }
         return false;
      }
      
      public function setTutorialReward2(param1:Boolean) : void
      {
         if(param1)
         {
            this.flagsSetValue(FLAGS_TUTORIAL_REWARD2,"1");
         }
         else
         {
            this.flagsSetValue(FLAGS_TUTORIAL_REWARD2,"0");
         }
      }
      
      public function flagsIsTutorialReward2Claimed() : Boolean
      {
         if(this.flagsGetValue(FLAGS_TUTORIAL_REWARD2) != null)
         {
            return this.flagsGetValueAsInt(FLAGS_TUTORIAL_REWARD2) == 1;
         }
         return false;
      }
      
      public function setChat(param1:Boolean) : void
      {
         this.flagsSetValue(FLAGS_CHAT,param1 ? "1" : "0");
      }
      
      public function flagsChatOn() : Boolean
      {
         if(this.flagsGetValue(FLAGS_CHAT) != null)
         {
            return this.flagsGetValueAsInt(FLAGS_CHAT) == 1;
         }
         return true;
      }
      
      public function set250GoldPopupShown(param1:Boolean) : void
      {
         this.flagsSetValue(FLAGS_250_GOLD_POPUP_SHOWN,param1 ? "1" : "0");
      }
      
      public function flagsGet250GoldPopupShown() : Boolean
      {
         if(this.flagsGetValue(FLAGS_250_GOLD_POPUP_SHOWN) != null)
         {
            return this.flagsGetValueAsInt(FLAGS_250_GOLD_POPUP_SHOWN) == 1;
         }
         return false;
      }
      
      public function setRatePopupShown(param1:Boolean) : void
      {
         this.flagsSetValue(FLAGS_RATE_POPUP_SHOWN,param1 ? "1" : "0");
      }
      
      public function flagsGetRatePopupShown() : Boolean
      {
         if(this.flagsGetValue(FLAGS_RATE_POPUP_SHOWN) != null)
         {
            return this.flagsGetValueAsInt(FLAGS_RATE_POPUP_SHOWN) == 1;
         }
         return false;
      }
      
      public function setVibrationON(param1:Boolean) : void
      {
         this.flagsSetValue(FLAGS_VIBRATION,param1 ? "1" : "0");
      }
      
      public function flagsGetVibrationON() : Boolean
      {
         if(this.flagsGetValue(FLAGS_VIBRATION) != null)
         {
            return this.flagsGetValueAsInt(FLAGS_VIBRATION) == 1;
         }
         return true;
      }
      
      public function setScreenShakeON(param1:Boolean) : void
      {
         this.flagsSetValue(FLAGS_SCREEN_SHAKE,param1 ? "1" : "0");
      }
      
      public function flagsGetScreenShakeON() : Boolean
      {
         if(this.flagsGetValue(FLAGS_SCREEN_SHAKE) != null)
         {
            return this.flagsGetValueAsInt(FLAGS_SCREEN_SHAKE) == 1;
         }
         return true;
      }
      
      public function setUseNewBGsON(param1:Boolean) : void
      {
         this.flagsSetValue(FLAGS_NEW_BGS,param1 ? "1" : "0");
      }
      
      public function flagsGetUseNewBGsON() : Boolean
      {
         if(this.flagsGetValue(FLAGS_NEW_BGS) != null)
         {
            return this.flagsGetValueAsInt(FLAGS_NEW_BGS) == 1;
         }
         return true;
      }
      
      public function setRaidsTutorialSeenON(param1:Boolean) : void
      {
         this.flagsSetValue(FLAGS_RAIDS_TUTORIAL_SEEN,param1 ? "1" : "0");
      }
      
      public function flagsGetRaidsTutorialSeenON() : Boolean
      {
         if(this.flagsGetValue(FLAGS_RAIDS_TUTORIAL_SEEN) != null)
         {
            return this.flagsGetValueAsInt(FLAGS_RAIDS_TUTORIAL_SEEN) == 1;
         }
         return false;
      }
      
      public function setCraftTutorialSeenON(param1:Boolean) : void
      {
         this.flagsSetValue(FLAGS_CRAFT_TUTORIAL_SEEN,param1 ? "1" : "0");
      }
      
      public function flagsGetCraftTutorialSeenON() : Boolean
      {
         if(this.flagsGetValue(FLAGS_CRAFT_TUTORIAL_SEEN) != null)
         {
            return this.flagsGetValueAsInt(FLAGS_CRAFT_TUTORIAL_SEEN) == 1;
         }
         return false;
      }
      
      public function setShareInfoToGuild(param1:Boolean) : void
      {
         this.flagsSetValue(FLAGS_SHARE_INFO_TO_GUILD,param1 ? "1" : "0");
      }
      
      public function flagsGetShareInfoToGuild() : Boolean
      {
         if(this.flagsGetValue(FLAGS_SHARE_INFO_TO_GUILD) != null)
         {
            return this.flagsGetValueAsInt(FLAGS_SHARE_INFO_TO_GUILD) == 1;
         }
         return false;
      }
      
      public function setShowDefaultAvatarFlag(param1:Boolean) : void
      {
         this.flagsSetValue(FLAGS_SHOW_DEFAULT_AVATAR,param1 ? "1" : "0");
      }
      
      public function flagsShowDefaultAvatar() : Boolean
      {
         if(!Config.smShowUserRealPortrait)
         {
            return true;
         }
         if(this.flagsGetValue(FLAGS_SHOW_DEFAULT_AVATAR) != null)
         {
            return this.flagsGetValueAsInt(FLAGS_SHOW_DEFAULT_AVATAR) == 1;
         }
         return false;
      }
      
      public function setShowLightFX(param1:Boolean) : void
      {
         this.flagsSetValue(FLAGS_SHOW_LIGHT_FX,param1 ? "1" : "0");
      }
      
      public function flagsGetShowLightFX() : Boolean
      {
         if(this.flagsGetValue(FLAGS_SHOW_LIGHT_FX) != null)
         {
            return this.flagsGetValueAsInt(FLAGS_SHOW_LIGHT_FX) == 1;
         }
         return !Utils.isAndroid();
      }
      
      public function setReferralCodeRedeemed(param1:Boolean) : void
      {
         this.flagsSetValue(FLAGS_REFERRAL_CODE_REDEEMED,param1 ? "1" : "0");
      }
      
      public function flagsReferralCodeRedeemed() : Boolean
      {
         if(this.flagsGetValue(FLAGS_REFERRAL_CODE_REDEEMED) != null)
         {
            return this.flagsGetValueAsInt(FLAGS_REFERRAL_CODE_REDEEMED) == 1;
         }
         return false;
      }
      
      public function setReferralPopupShown(param1:Boolean) : void
      {
         this.flagsSetValue(FLAGS_REFERRAL_POPUP_SHOWN,param1 ? "1" : "0");
      }
      
      public function flagsReferralPopupShown() : Boolean
      {
         if(this.flagsGetValue(FLAGS_REFERRAL_POPUP_SHOWN) != null)
         {
            return this.flagsGetValueAsInt(FLAGS_REFERRAL_POPUP_SHOWN) == 1;
         }
         return false;
      }
      
      public function setMapSelectorPopupShown(param1:Boolean) : void
      {
         this.flagsSetValue(FLAGS_MAP_SELECTOR_POPUP_SHOWN,param1 ? "1" : "0");
      }
      
      public function flagsMapSelectorPopupShown() : Boolean
      {
         if(this.flagsGetValue(FLAGS_MAP_SELECTOR_POPUP_SHOWN) != null)
         {
            return this.flagsGetValueAsInt(FLAGS_MAP_SELECTOR_POPUP_SHOWN) == 1;
         }
         return false;
      }
      
      public function setFBFriendsAllowed(param1:Boolean) : void
      {
         this.flagsSetValue(FLAGS_FB_FRIENDS_ALLOWED,param1 ? "1" : "0");
      }
      
      public function flagsFBFriendsAllowed() : Boolean
      {
         if(this.flagsGetValue(FLAGS_FB_FRIENDS_ALLOWED) != null)
         {
            return this.flagsGetValueAsInt(FLAGS_FB_FRIENDS_ALLOWED) == 1;
         }
         return false;
      }
      
      public function persistenceBuildData(param1:Boolean = false) : Object
      {
         var _loc101_:int = 0;
         var _loc102_:Number = NaN;
         var _loc2_:Object = new Object();
         var _loc3_:Object = InstanceMng.getServerConnection().getBackendUserProfile() != null ? InstanceMng.getServerConnection().getBackendUserProfile().profile : null;
         var _loc4_:int = InstanceMng.getUserDataMng() ? this.getCurrentDifficulty() : this.mCurrentDifficulty;
         var _loc5_:String = InstanceMng.getUserDataMng() ? InstanceMng.getUserDataMng().getUpdatedCurrentLevelSku(UserDataMng.DIFFICULTY_EASY,_loc3_) : this.mCurrentLevelSku;
         var _loc6_:String = InstanceMng.getUserDataMng() ? InstanceMng.getUserDataMng().getUpdatedCurrentLevelSku(UserDataMng.DIFFICULTY_MEDIUM,_loc3_) : this.mCurrentLevelMediumSku;
         var _loc7_:String = InstanceMng.getUserDataMng() ? InstanceMng.getUserDataMng().getUpdatedCurrentLevelSku(UserDataMng.DIFFICULTY_HARD,_loc3_) : this.mCurrentLevelHardSku;
         var _loc8_:String = this.getAccountId();
         var _loc9_:String = this.getExtId();
         var _loc10_:int = this.getExtPlatformId();
         var _loc11_:String = this.getName() ? this.getName().toLowerCase() : "";
         var _loc12_:String = this.getCityName().toLowerCase();
         var _loc13_:String = ServerConnection.smServerTimeMS.toString();
         var _loc14_:String = this.flagsToString();
         var _loc15_:String = this.tutorialsSeenToString();
         var _loc16_:String = this.levelsFailedInfoToString();
         var _loc17_:String = this.levelsFailedFirebaseToString();
         var _loc18_:String = this.getOwnerDeckToString(0);
         var _loc19_:String = this.getOwnerDeckToString(1);
         var _loc20_:String = this.getOwnerDeckToString(2);
         var _loc21_:String = this.getOwnerDeckToString(3);
         var _loc22_:String = this.getOwnerDeckToString(4);
         var _loc23_:String = this.getOwnerDeckToString(5);
         var _loc24_:String = this.getOwnerDeckToString(6);
         var _loc25_:String = this.getOwnerDeckToString(7);
         var _loc26_:String = this.getOwnerDeckToString(8);
         var _loc27_:String = this.getOwnerDeckToString(9);
         var _loc28_:String = this.getOwnerCollectionToString();
         var _loc29_:String = this.getBadgesCollectionToString();
         var _loc30_:String = this.getOwnerNewCardsCollectionToString();
         var _loc31_:String = this.getOwnerFavouriteCardsCollectionToString();
         var _loc32_:Number = this.getExp();
         var _loc33_:String = this.getBoostsToString();
         var _loc34_:String = this.getDeckNamesToString();
         var _loc35_:int = this.getSelectedDeckIndex();
         var _loc36_:int = this.getSelectedDeckIndexPvP();
         var _loc37_:Boolean = this.isInBlackList();
         var _loc38_:Boolean = this.isInDuplicatedList();
         var _loc39_:String = this.mProgressResetDate.toString();
         if(Config.smLivesSystemEnabled)
         {
            _loc101_ = this.getLives();
            _loc102_ = this.getLostLifeTimeMS();
         }
         var _loc40_:int = this.getDecksPurchasedAmount();
         var _loc41_:String = this.getAvailablePortraitsToString();
         var _loc42_:String = this.getCurrentPortraitSku();
         var _loc43_:String = this.getAvailableSkinsToString();
         var _loc44_:String = this.getCurrentSkinSku();
         var _loc45_:int = this.getElo();
         var _loc46_:int = this.getMatchesLost();
         var _loc47_:int = this.getMatchesWon();
         var _loc48_:int = this.getMatchesPlayed();
         var _loc49_:int = this.getPvPCurrentLeague();
         var _loc50_:int = this.getPvPBestLeague();
         var _loc51_:int = this.getDungeonsLost();
         var _loc52_:int = this.getDungeonsWon();
         var _loc53_:int = this.getDungeonsPlayed();
         var _loc54_:int = this.getDungeonsSeason();
         var _loc55_:int = this.getPvPSeason();
         var _loc56_:String = this.getComicsReadToString();
         var _loc57_:String = this.getBadgesRewardsClaimedToString();
         var _loc58_:String = this.getStarsRewardsClaimedToString();
         var _loc59_:int = this.getHighestMapUnlockedIndex();
         var _loc60_:Number = this.getFinishedLastCampaignTimestamp();
         var _loc61_:Number = this.getDailyRewardTimeMS();
         var _loc62_:Number = this.getLastDailyRewardClaimedIndex();
         var _loc63_:Number = this.getOldPlayerComingBackDailyRewardTimeMS();
         var _loc64_:Number = this.getOldPlayerComingBackLastDailyRewardClaimedIndex();
         var _loc65_:int = this.getLevelAttempts();
         var _loc66_:Number = this.getFirstFirebaseDBTrack();
         var _loc67_:String = this.getLanguageLocale();
         var _loc68_:String = this.getGuildMemberId();
         var _loc69_:String = this.getGuildId();
         var _loc70_:String = this.getQuestsClaimedToString();
         var _loc71_:String = this.getQuestsCompletedToString();
         var _loc72_:String = this.getQuestsNotifiedAsCompletedToString();
         var _loc73_:String = this.getQuestsProgressToString();
         var _loc74_:String = this.getCustomOfferShown();
         var _loc75_:Number = this.getCustomOfferNextVisibleDateMS();
         var _loc76_:Boolean = this.getCustomOfferNewBannerShown();
         var _loc77_:String = this.getCustomOffersViewsCountToString();
         var _loc78_:String = this.getCustomOffersPurchasedToString();
         var _loc79_:String = this.getMapWorldChoiceToString();
         var _loc80_:String = this.getBattlePass();
         var _loc81_:String = this.getRaidsUnlocked();
         var _loc82_:String = this.getOwnerAuctionIdCreatedArrToString();
         var _loc83_:String = this.getOwnerAuctionIdBiddedArrToString();
         var _loc84_:String = this.getOwnerUniquePacksArrToString();
         var _loc85_:int = this.getBotsPlayedSession();
         var _loc86_:String = this.getJobsExperienceToString();
         var _loc87_:String = this.getDeckJobConfiguratorToString();
         var _loc88_:String = this.getAvailableJobsToString();
         var _loc89_:Number = this.getDailyKeyTime();
         var _loc90_:Number = this.getWeekNumber();
         var _loc91_:Number = this.getMonthNumber();
         var _loc92_:String = this.getPlatformVersionsToString();
         _loc2_.currentDifficulty = _loc4_;
         _loc2_.currentLevelSku = _loc5_;
         _loc2_.currentLevelMediumSku = _loc6_;
         _loc2_.currentLevelHardSku = _loc7_;
         _loc2_.accountId = _loc8_;
         _loc2_.extId = _loc9_;
         _loc2_.extPlatformId = _loc10_;
         _loc2_.playerName = _loc11_;
         if(Config.getConfig().gameHasBuildingBadges())
         {
            _loc2_.cityName = _loc12_;
         }
         _loc2_.currentDateMS = _loc13_;
         _loc2_.flags = _loc14_;
         _loc2_.tutorialsSeen = _loc15_;
         _loc2_.levelsFailedInfo = _loc16_;
         _loc2_.levelsFailedFirebase = _loc17_;
         var _loc93_:int = 0;
         var _loc94_:int = Config.getConfig().getMaxDecksAmount();
         _loc93_ = 0;
         while(_loc93_ < _loc94_)
         {
            _loc2_["deck_" + Utils.transformValueToString(_loc93_.toString(),2)] = this.getOwnerDeckToString(_loc93_);
            _loc93_++;
         }
         var _loc95_:Number = this.getGold();
         var _loc96_:Number = this.getRaidCoins();
         var _loc97_:Number = this.getQuestsCoins();
         var _loc98_:int = this.getAuctionTickets();
         var _loc99_:Number = this.getRaidTicketsSinglePlayer();
         var _loc100_:Number = this.getRaidTicketsMultiPlayer();
         _loc2_.gold = _loc95_;
         _loc2_.raidCoins = _loc96_;
         _loc2_.questsCoins = _loc97_;
         _loc2_.auctionTickets = _loc98_;
         _loc2_.raidTicketsSinglePlayer = _loc99_;
         _loc2_.raidTicketsMultiPlayer = _loc100_;
         _loc2_.exp = _loc32_;
         _loc2_.collection = _loc28_;
         _loc2_.badgesCollection = _loc29_;
         _loc2_.newCardsCollection = _loc30_;
         _loc2_.favouriteCardsCollection = _loc31_;
         _loc2_.boosts = _loc33_;
         _loc2_.deckNames = _loc34_;
         _loc2_.selectedDeckIndex = _loc35_;
         _loc2_.selectedDeckIndexPvP = _loc36_;
         if(Config.smLivesSystemEnabled)
         {
            _loc2_.lives = _loc101_;
            _loc2_.lostLiveTimeMS = _loc102_;
         }
         _loc2_.decksPurchasedAmount = _loc40_;
         _loc2_.availablePortraits = _loc41_;
         _loc2_.currentPortraitSku = _loc42_;
         _loc2_.availableSkins = _loc43_;
         _loc2_.currentSkinSku = _loc44_;
         _loc2_.elo = _loc45_;
         _loc2_.matchesLost = _loc46_;
         _loc2_.matchesWon = _loc47_;
         _loc2_.matchesPlayed = _loc48_;
         _loc2_.pvpCurrentLeague = _loc49_;
         _loc2_.pvpBestLeague = _loc50_;
         _loc2_.dungeonsLost = _loc51_;
         _loc2_.dungeonsWon = _loc52_;
         _loc2_.dungeonsPlayed = _loc53_;
         _loc2_.dungeonsSeason = _loc54_;
         _loc2_.pvpSeason = _loc55_;
         _loc2_.comicsRead = _loc56_;
         _loc2_.badgesRewardsClaimed = _loc57_;
         _loc2_.starsRewardsClaimed = _loc58_;
         _loc2_.highestMapUnlockedIndex = _loc59_;
         _loc2_.finishedLastCampaignTimeMs = _loc60_;
         _loc2_.dailyRewardTimeMS = _loc61_;
         _loc2_.lastDailyRewardClaimedIndex = _loc62_;
         _loc2_.oldPlayerComingBackDailyRewardTimeMS = _loc63_;
         _loc2_.oldPlayerComingBackLastDailyRewardClaimedIndex = _loc64_;
         _loc2_.levelAttempts = _loc65_;
         _loc2_.firstFirebaseDBTrack = _loc66_;
         _loc2_.languageLocale = _loc67_;
         _loc2_.guildMemberId = _loc68_;
         _loc2_.guildId = _loc69_;
         _loc2_.questsClaimed = _loc70_;
         _loc2_.questsCompleted = _loc71_;
         _loc2_.questsProgress = _loc73_;
         _loc2_.questsNotifiedAsCompleted = _loc72_;
         _loc2_.customOfferShown = _loc74_;
         _loc2_.customOfferNextVisibleDateMS = _loc75_;
         _loc2_.customOfferNewBannerShown = _loc76_;
         _loc2_.customOffersViewsCount = _loc77_;
         _loc2_.customOffersPurchased = _loc78_;
         _loc2_.raidsUnlocked = _loc81_;
         _loc2_.auctionIdCreatedArr = _loc82_;
         _loc2_.auctionIdBiddedArr = _loc83_;
         _loc2_.uniquePacksArr = _loc84_;
         _loc2_.botsPlayedSession = _loc85_;
         _loc2_.jobsExperience = _loc86_;
         _loc2_.deckJobConfigurator = _loc87_;
         _loc2_.availableJobs = _loc88_;
         _loc2_.mapWorldChoices = _loc79_;
         _loc2_.dailyKeyTime = _loc89_;
         _loc2_.weekNumber = _loc90_;
         _loc2_.monthNumber = _loc91_;
         _loc2_.platformVersions = _loc92_;
         _loc2_.isBlackListed = _loc37_;
         _loc2_.isDuplicated = _loc38_;
         _loc2_.battlePass = _loc80_;
         _loc2_.progressResetDate = _loc39_;
         return _loc2_;
      }
      
      public function getDeckJobConfiguratorToString() : String
      {
         var _loc2_:int = 0;
         var _loc1_:String = "";
         if(this.mDeckJobConfigurationArr != null)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mDeckJobConfigurationArr.length)
            {
               if(String(this.mDeckJobConfigurationArr[_loc2_]) != "undefined" && String(this.mDeckJobConfigurationArr[_loc2_]) != "")
               {
                  _loc1_ += this.mDeckJobConfigurationArr[_loc2_];
               }
               if(_loc2_ < this.mDeckJobConfigurationArr.length - 1)
               {
                  _loc1_ += _loc1_ != "" ? "," : "";
               }
               _loc2_++;
            }
         }
         return _loc1_;
      }
      
      public function getJobsExperienceToString() : String
      {
         var _loc2_:int = 0;
         var _loc1_:String = "";
         if(this.mJobsExperience != null)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mJobsExperience.length)
            {
               this.mJobsExperience.sort();
               if(String(this.mJobsExperience[_loc2_]).length > 0)
               {
                  _loc1_ += String(this.mJobsExperience[_loc2_]);
                  if(_loc2_ != this.mJobsExperience.length - 1)
                  {
                     _loc1_ += _loc1_ != "" ? "," : "";
                  }
               }
               _loc2_++;
            }
         }
         return _loc1_;
      }
      
      public function getPlatformVersionsToString() : String
      {
         var _loc2_:int = 0;
         var _loc1_:String = "";
         if(this.mPlatformVersions != null)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mPlatformVersions.length)
            {
               this.mPlatformVersions.sort();
               if(String(this.mPlatformVersions[_loc2_]).length > 0)
               {
                  _loc1_ += String(this.mPlatformVersions[_loc2_]);
                  if(_loc2_ != this.mPlatformVersions.length - 1)
                  {
                     _loc1_ += _loc1_ != "" ? "," : "";
                  }
               }
               _loc2_++;
            }
         }
         return _loc1_;
      }
      
      public function playerLostLive(param1:LevelDef) : void
      {
         var _loc2_:int = 0;
         if(Config.smLivesSystemEnabled)
         {
            if(this.mLives == InstanceMng.getUserDataMng().getDefaultLives())
            {
               this.mLostLiveTimeMS = ServerConnection.smServerTimeMS != -1 ? ServerConnection.smServerTimeMS : TimerUtil.currentTimeMillis();
               FSDebug.debugTrace("Lost live in time: " + TimerUtil.getTimeTextFromMs(this.mLostLiveTimeMS,"d","h","min","sec"));
            }
            this.mLives = this.mLives - 1 >= 0 ? int(this.mLives - 1) : 0;
            if(param1)
            {
               _loc2_ = this.getCurrentDifficulty();
               if(this.getCurrentLevelIndex(_loc2_) == param1.getLevelIndex())
               {
                  this.increaseLevelFailedInfoByLevelSku(param1.getSku());
               }
            }
            InstanceMng.getUserDataMng().persistenceSaveData();
         }
      }
      
      public function playerGainLife(param1:int, param2:Boolean = true, param3:LevelDef = null) : void
      {
         var _loc4_:int = 0;
         if(Config.smLivesSystemEnabled)
         {
            _loc4_ = InstanceMng.getUserDataMng().getDefaultLives();
            this.mLives = this.mLives + param1 <= _loc4_ ? int(this.mLives + param1) : _loc4_;
            if(param2)
            {
               InstanceMng.getUserDataMng().updateLives();
            }
         }
         if(param3)
         {
            this.deleteLevelFromFailedInfo(param3.getSku());
         }
      }
      
      public function getLostLifeTimeMS() : Number
      {
         return this.mLostLiveTimeMS;
      }
      
      public function setLostLifeTimeMS(param1:Number) : void
      {
         this.mLostLiveTimeMS = param1;
      }
      
      public function getCurrentDateMS() : Number
      {
         return this.mCurrentDateMS;
      }
      
      public function setCurrentDateMS(param1:Number) : void
      {
         this.mCurrentDateMS = param1;
      }
      
      public function getExtraLifesGainedByBoost() : int
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         if(this.mExtraLivesBoostDef == null)
         {
            this.mExtraLivesBoostDef = InstanceMng.getBoostsDefMng().getBoostDefByKeyname(BoostsMng.BOOST_ID_PERMANENT_LIVES);
         }
         if(this.mExtraLivesBoostDef != null)
         {
            _loc2_ = this.getBoostAmount(this.mExtraLivesBoostDef.getSku());
            if(_loc2_ > 0)
            {
               _loc1_ = this.mExtraLivesBoostDef.getValue();
            }
         }
         return _loc1_;
      }
      
      public function resetExtraLifesBoostDef() : void
      {
         this.mExtraLivesBoostDef = null;
      }
      
      public function getDecksPurchasedAmount() : int
      {
         return this.mDecksPurchasedAmount;
      }
      
      public function setDecksPurchasedAmount(param1:int) : void
      {
         this.mDecksPurchasedAmount = param1;
      }
      
      public function updateFinishedLastCampaignTimestamp(param1:Object = null) : void
      {
         var _loc2_:Object = null;
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            if(param1 == null)
            {
               InstanceMng.getServerConnection().getServerTime(this.updateFinishedLastCampaignTimestamp);
            }
            else
            {
               _loc2_ = Utils.parseJSONData(param1);
               this.mFinishedLastCampaignTimeMs = TimerUtil.convertServerUCTDateToDate(_loc2_.now).time;
               if(this.mFinishedLastCampaignTimeMs == 0)
               {
                  this.mFinishedLastCampaignTimeMs = ServerConnection.smServerTimeMS == 0 ? TimerUtil.currentTimeMillis() : ServerConnection.smServerTimeMS;
               }
               InstanceMng.getUserDataMng().updateFinishedLastCampaignTimestamp();
            }
         }
      }
      
      public function setFinishedLastcampaignTimestamp(param1:Number, param2:Boolean = true) : void
      {
         this.mFinishedLastCampaignTimeMs = param1;
         if(param2 && this.mIsOwner)
         {
            InstanceMng.getUserDataMng().updateFinishedLastCampaignTimestamp();
         }
      }
      
      public function getFinishedLastCampaignTimestamp() : Number
      {
         return this.mFinishedLastCampaignTimeMs;
      }
      
      public function isWaitingForMapToUnlock() : Boolean
      {
         var _loc1_:int = this.getCurrentDifficulty();
         return this.mHighestMapsUnlockedIndex < this.getCurrentMapIndex(_loc1_);
      }
      
      public function setPvPSeason(param1:int) : void
      {
         this.mPvPSeason = param1;
      }
      
      public function getPvPSeason() : int
      {
         return this.mPvPSeason;
      }
      
      public function setDungeonsSeason(param1:int) : void
      {
         this.mDungeonsSeason = param1;
      }
      
      public function getDungeonsSeason() : int
      {
         return this.mDungeonsSeason;
      }
      
      public function setDailyRewardTimeMS(param1:Number) : void
      {
         this.mDailyRewardsTimeMS = param1;
      }
      
      public function getDailyRewardTimeMS() : Number
      {
         return this.mDailyRewardsTimeMS;
      }
      
      public function setLastDailyRewardClaimedIndex(param1:Number) : void
      {
         this.mDailyRewardsClaimedIndex = param1;
      }
      
      public function getLastDailyRewardClaimedIndex() : Number
      {
         return this.mDailyRewardsClaimedIndex;
      }
      
      public function setOldPlayerComingBackDailyRewardTimeMS(param1:Number) : void
      {
         this.mOldPlayerComingBackDailyRewardsTimeMS = param1;
      }
      
      public function getOldPlayerComingBackDailyRewardTimeMS() : Number
      {
         return this.mOldPlayerComingBackDailyRewardsTimeMS;
      }
      
      public function setOldPlayerComingBackLastDailyRewardClaimedIndex(param1:Number) : void
      {
         this.mOldPlayerComingBackDailyRewardsClaimedIndex = param1;
      }
      
      public function getOldPlayerComingBackLastDailyRewardClaimedIndex() : Number
      {
         return this.mOldPlayerComingBackDailyRewardsClaimedIndex;
      }
      
      public function getUnitsAmount() : int
      {
         return DictionaryUtils.getDictionaryLength(this.getCollectionFilteredByCategory(CategoriesDefMng.CATEGORY_UNITS));
      }
      
      public function getAttachmentsAmount() : int
      {
         return DictionaryUtils.getDictionaryLength(this.getCollectionFilteredByCategory(CategoriesDefMng.CATEGORY_ATTACHMENTS));
      }
      
      public function getActionsAmount() : int
      {
         return DictionaryUtils.getDictionaryLength(this.getCollectionFilteredByCategory(CategoriesDefMng.CATEGORY_ACTIONS));
      }
      
      public function getPowersAmount() : int
      {
         return DictionaryUtils.getDictionaryLength(this.getCollectionFilteredByCategory(CategoriesDefMng.CATEGORY_POWERS));
      }
      
      public function setPurchasesAmount(param1:Number) : void
      {
         this.mPurchasesAmount = param1;
      }
      
      public function increasePurchasesAmount() : void
      {
         ++this.mPurchasesAmount;
      }
      
      public function setReferralCode(param1:String) : void
      {
         this.mReferralCode = param1;
      }
      
      public function getReferralCode() : String
      {
         return this.mReferralCode;
      }
      
      public function setTransferCode(param1:String) : void
      {
         this.mTransferCode = param1;
      }
      
      public function getTransferCode() : String
      {
         return this.mTransferCode;
      }
      
      public function setReferrals(param1:Array) : void
      {
         this.mReferrals = param1;
      }
      
      public function getReferrals() : Array
      {
         return this.mReferrals;
      }
      
      public function getReferralsAmount(param1:int, param2:Boolean = false) : int
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc3_:int = 0;
         if(this.mReferrals)
         {
            _loc4_ = 0;
            while(_loc4_ < this.mReferrals.length)
            {
               _loc5_ = this.mReferrals[_loc4_].hasOwnProperty("level") ? int(this.mReferrals[_loc4_]["level"]) : 0;
               _loc6_ = this.mReferrals[_loc4_].hasOwnProperty("matchesPlayed") ? int(this.mReferrals[_loc4_]["matchesPlayed"]) : 0;
               if(param2 || InstanceMng.getUserDataMng().referralCheckConditions(_loc5_,_loc6_,param1))
               {
                  _loc3_++;
               }
               _loc4_++;
            }
         }
         return _loc3_;
      }
      
      public function isPayingUser() : Boolean
      {
         return this.mPurchasesAmount > 0;
      }
      
      public function hasToWaitForMapUnlock() : Boolean
      {
         return !this.isPayingUser() && !this.isVIP();
      }
      
      public function isInBlackList() : Boolean
      {
         return this.mIsInBlackList;
      }
      
      public function setInBlackList(param1:Boolean) : void
      {
         this.mIsInBlackList = param1;
      }
      
      public function isInDuplicatedList() : Boolean
      {
         return this.mIsInDuplicatedList;
      }
      
      public function setInDuplicatedList(param1:Boolean) : void
      {
         this.mIsInDuplicatedList = param1;
      }
      
      public function isVIP() : Boolean
      {
         return this.mIsVIP;
      }
      
      public function setIsVIP(param1:Boolean) : void
      {
         this.mIsVIP = param1;
      }
      
      public function isDev() : Boolean
      {
         return this.mIsDev;
      }
      
      public function setIsDev(param1:Boolean) : void
      {
         this.mIsDev = param1;
      }
      
      public function isOldPlayerComingBack() : Boolean
      {
         return this.mIsOldPlayerComingBack;
      }
      
      public function setIsOldPlayerComingBack(param1:Boolean) : void
      {
         this.mIsOldPlayerComingBack = param1;
      }
      
      public function getNotificationsReceived() : Array
      {
         return this.mNotificationsReceived;
      }
      
      public function setNotificationsReceived(param1:Array) : void
      {
         this.mNotificationsReceived = param1;
      }
      
      public function removeNotification(param1:String) : void
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         if(this.mNotificationsReceived)
         {
            _loc3_ = 0;
            _loc3_ = 0;
            while(_loc3_ < this.mNotificationsReceived.length)
            {
               _loc2_ = Object(this.mNotificationsReceived[_loc3_]);
               if(Utils.getDataId(_loc2_) == param1)
               {
                  this.mNotificationsReceived.splice(_loc3_,1);
               }
               _loc3_++;
            }
         }
      }
      
      public function getCardsFromCollection(param1:String) : Vector.<String>
      {
         var _loc2_:Vector.<String> = null;
         var _loc3_:Array = null;
         var _loc4_:CardDef = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         if(this.mCardCollection != null)
         {
            _loc3_ = DictionaryUtils.getKeys(this.mCardCollection);
            _loc6_ = 0;
            while(_loc6_ < _loc3_.length)
            {
               _loc4_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc3_[_loc6_]));
               if(_loc4_ != null)
               {
                  if(_loc4_.getCardRarity() == param1)
                  {
                     if(_loc2_ == null)
                     {
                        _loc2_ = new Vector.<String>();
                     }
                     _loc2_.push(_loc4_.getSku());
                  }
               }
               _loc6_++;
            }
         }
         return _loc2_;
      }
      
      public function getDuplicatedsCardsFromCollection(param1:Boolean = false) : Vector.<String>
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc8_:CardDef = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:FSResourceMng = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:String = null;
         var _loc16_:Boolean = false;
         var _loc17_:Object = null;
         var _loc2_:Vector.<String> = new Vector.<String>();
         if(this.mCardCollectionArr != null)
         {
            _loc3_ = new Array();
            _loc11_ = 0;
            _loc12_ = InstanceMng.getResourcesMng();
            _loc13_ = 0;
            for(_loc17_ in this.mCardCollection)
            {
               if(_loc13_ < DeckCardsPanel.MAX_SLOTS_IN_DECK_PANEL)
               {
                  _loc15_ = _loc17_ as String;
                  _loc14_ = int(this.mCardCollection[_loc15_]);
                  _loc8_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc15_));
                  if(_loc8_)
                  {
                     _loc11_ = _loc8_.getGoldOnSell();
                     if(_loc11_ > 0)
                     {
                        if(!this.isCardInFavouritesCollection(_loc8_.getSku()))
                        {
                           if(!param1 || param1 && !_loc12_.isCraftingCardMaterial(_loc8_.getSku()))
                           {
                              _loc16_ = false;
                              _loc5_ = _loc9_ = _loc8_.getMaxAmountOndeck();
                              while(_loc5_ < _loc14_)
                              {
                                 if(!_loc16_)
                                 {
                                    _loc13_++;
                                    _loc16_ = true;
                                 }
                                 _loc3_[_loc10_] = _loc15_;
                                 _loc10_++;
                                 _loc5_++;
                              }
                           }
                        }
                     }
                  }
               }
            }
            _loc3_ = _loc3_.sort(DictionaryUtils.nonDeepSortCardsSkusByValue);
            _loc2_ = Vector.<String>(_loc3_);
         }
         return _loc2_;
      }
      
      public function getBestPowerDefOnCollection() : PowerDef
      {
         var _loc3_:PowerDef = null;
         var _loc5_:int = 0;
         var _loc1_:Dictionary = DictionaryUtils.getCatalogFilteredByCategory(this.mCardCollection,CategoriesDefMng.CATEGORY_POWERS);
         var _loc2_:Array = DictionaryUtils.getKeys(_loc1_);
         var _loc4_:PowerDef = InstanceMng.getPowerDefMng().getDefByIndex(0);
         _loc5_ = 0;
         while(_loc5_ < _loc2_.length)
         {
            _loc3_ = InstanceMng.getPowerDefMng().getDefBySku(_loc2_[_loc5_]) as PowerDef;
            if(_loc3_)
            {
               if(_loc3_.getCardValue() > _loc4_.getCardValue())
               {
                  _loc4_ = _loc3_;
               }
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public function createBestBasicDeckConfiguration(param1:JobDef) : Array
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:Array = null;
         var _loc9_:CardDef = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:Dictionary = null;
         var _loc13_:Boolean = false;
         var _loc14_:Boolean = false;
         var _loc15_:Array = null;
         var _loc16_:Array = null;
         var _loc17_:Array = null;
         var _loc18_:Array = null;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc25_:String = null;
         var _loc26_:PowerDef = null;
         var _loc27_:int = 0;
         var _loc28_:int = 0;
         var _loc29_:int = 0;
         var _loc30_:int = 0;
         var _loc31_:int = 0;
         var _loc32_:int = 0;
         var _loc33_:int = 0;
         var _loc34_:int = 0;
         var _loc35_:int = 0;
         var _loc36_:int = 0;
         var _loc37_:int = 0;
         var _loc38_:String = null;
         var _loc39_:String = null;
         var _loc40_:Object = null;
         _loc2_ = new Array();
         _loc3_ = JobsMng.getAllCardsForJob(param1);
         _loc4_ = new Array();
         _loc12_ = new Dictionary(true);
         _loc14_ = false;
         _loc5_ = 0;
         for(; _loc5_ < _loc3_.length; _loc5_++)
         {
            _loc7_ = _loc3_[_loc5_];
            _loc8_ = _loc7_.split(":");
            _loc9_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc8_[0]));
            if((Boolean(_loc9_)) && _loc9_.getIsVisible())
            {
               _loc10_ = _loc9_.getMaxAmountOndeck();
               _loc13_ = DictionaryUtils.getDeckFamilyIDMaxReached(_loc9_,_loc12_);
               if(int(_loc8_[1]) <= _loc10_ && !_loc13_)
               {
                  if(_loc9_.isLeader())
                  {
                     if(_loc14_)
                     {
                        continue;
                     }
                     _loc14_ = true;
                  }
                  _loc4_[_loc11_] = _loc3_[_loc5_];
                  _loc12_[_loc8_[0]] = int(_loc8_[1]);
                  _loc11_++;
               }
               else if(!_loc13_)
               {
                  if(_loc9_.isLeader())
                  {
                     if(_loc14_)
                     {
                        continue;
                     }
                     _loc14_ = true;
                  }
                  _loc3_[_loc5_] = _loc3_[_loc5_].split(":")[0] + ":" + _loc10_;
                  _loc4_[_loc11_] = _loc3_[_loc5_];
                  _loc12_[_loc8_[0]] = _loc10_;
                  _loc11_++;
               }
            }
         }
         _loc15_ = _loc4_.sort(DictionaryUtils.sortCardsByValueAndSubcategory);
         _loc16_ = new Array();
         _loc17_ = new Array();
         _loc18_ = new Array();
         _loc19_ = 0;
         _loc20_ = 0;
         _loc21_ = 0;
         _loc22_ = 0;
         _loc23_ = 0;
         _loc24_ = 0;
         _loc25_ = "";
         FSDebug.debugTrace("* CARDS BY CARD VALUE *\n");
         _loc5_ = 0;
         for(; _loc5_ < _loc15_.length; FSDebug.debugTrace(_loc15_[_loc5_] + " | " + _loc9_.getCardRarity() + " | " + _loc9_.getCardValue()),_loc5_++)
         {
            _loc9_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(String(_loc15_[_loc5_]).split(":")[0]));
            if(!_loc9_)
            {
               continue;
            }
            switch(_loc9_.getCategoryIndex())
            {
               case CategoriesDefMng.CATEGORY_UNITS:
                  _loc16_[_loc22_] = _loc15_[_loc5_];
                  _loc22_++;
                  _loc19_ += int(String(_loc15_[_loc5_]).split(":")[1]);
                  break;
               case CategoriesDefMng.CATEGORY_ATTACHMENTS:
                  _loc17_[_loc23_] = _loc15_[_loc5_];
                  _loc23_++;
                  _loc20_ += int(String(_loc15_[_loc5_]).split(":")[1]);
                  break;
               case CategoriesDefMng.CATEGORY_ACTIONS:
                  _loc18_[_loc24_] = _loc15_[_loc5_];
                  _loc24_++;
                  _loc21_ += int(String(_loc15_[_loc5_]).split(":")[1]);
                  break;
               case CategoriesDefMng.CATEGORY_POWERS:
                  _loc26_ = PowerDef(InstanceMng.getPowerDefMng().getDefBySku(String(_loc15_[_loc5_]).split(":")[0]));
                  if(_loc26_)
                  {
                     _loc38_ = param1.getActiveDefaultSku();
                     _loc39_ = param1.getActiveSecondarySku();
                     if(_loc26_.getSku() != _loc39_ || _loc26_.getSku() == _loc39_ && JobsMng.isActiveSecondaryAbilityUnlocked(param1))
                     {
                        _loc25_ = _loc25_ == "" ? _loc26_.getSku() : _loc25_;
                     }
                  }
            }
         }
         _loc27_ = _loc19_ + _loc20_ + _loc21_;
         _loc28_ = Config.getConfig().getDeckCardsAmount();
         _loc29_ = _loc28_ * 0.75;
         _loc30_ = Config.getConfig().gameHasAttachments() ? int(Math.ceil(_loc28_ * 0.15)) : 0;
         _loc31_ = Config.getConfig().gameHasAttachments() ? int(_loc28_ * 0.1) : int(_loc28_ * 0.25);
         _loc32_ = _loc29_ > _loc19_ ? int(_loc29_ - _loc19_) : 0;
         _loc33_ = _loc30_ > _loc20_ ? int(_loc30_ - _loc20_) : 0;
         _loc34_ = _loc31_ > _loc21_ ? int(_loc31_ - _loc21_) : 0;
         _loc35_ = _loc19_ > _loc29_ ? int(_loc19_ - _loc29_) : 0;
         _loc36_ = _loc20_ > _loc30_ ? int(_loc20_ - _loc30_) : 0;
         _loc37_ = _loc21_ > _loc31_ ? int(_loc21_ - _loc31_) : 0;
         if(_loc27_ >= Config.getConfig().getDeckCardsAmount())
         {
            _loc40_ = this.returnAmountsByCategory(_loc29_,_loc30_,_loc31_,_loc32_,_loc33_,_loc34_,_loc35_,_loc36_,_loc37_);
            _loc29_ = int(_loc40_.minUnits);
            _loc30_ = int(_loc40_.minAttachments);
            _loc31_ = int(_loc40_.minActions);
         }
         FSDebug.debugTrace("Total cards amount: " + _loc27_);
         _loc2_ = this.processCardsForBestConfiguration(_loc19_,_loc29_,_loc16_,_loc2_);
         _loc2_ = this.processCardsForBestConfiguration(_loc20_,_loc30_,_loc17_,_loc2_);
         _loc2_ = this.processCardsForBestConfiguration(_loc21_,_loc31_,_loc18_,_loc2_);
         if(_loc25_ != "" && Boolean(_loc2_))
         {
            _loc2_.push(_loc25_ + ":" + 1);
         }
         return _loc2_;
      }
      
      private function processCardsForBestConfiguration(param1:int, param2:int, param3:Array, param4:Array) : Array
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:CardDef = null;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:Boolean = false;
         _loc5_ = 0;
         _loc10_ = param1 > param2 ? _loc5_ < param2 : param3.length > 0;
         while(_loc10_)
         {
            _loc9_ = param3.shift();
            if(_loc9_ == null)
            {
               break;
            }
            _loc6_ = int(_loc9_.split(":")[1]);
            _loc7_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc9_.split(":")[0]));
            _loc8_ = _loc7_.getMaxAmountOndeck();
            if(_loc6_ > _loc8_)
            {
               _loc9_ = _loc9_.split(":")[0] + ":" + _loc8_;
               _loc6_ = _loc8_;
            }
            if(_loc5_ + _loc6_ <= param2)
            {
               param4.push(_loc9_);
            }
            else if(_loc6_ - 1 > 0 && _loc5_ + (_loc6_ - 1) <= param2)
            {
               _loc6_--;
               _loc9_ = _loc9_.split(":")[0] + ":" + _loc6_.toString();
               param4.push(_loc9_);
            }
            _loc5_ += int(_loc9_.split(":")[1]);
            _loc10_ = param1 > param2 ? _loc5_ < param2 : param3.length > 0;
         }
         return param4;
      }
      
      public function getCardCollectionCardDefs() : Vector.<CardDef>
      {
         var _loc1_:Vector.<CardDef> = null;
         var _loc2_:CardDef = null;
         var _loc3_:String = null;
         _loc1_ = null;
         if(this.mCardCollection != null)
         {
            _loc1_ = new Vector.<CardDef>();
            for(_loc3_ in this.mCardCollection)
            {
               _loc2_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc3_));
               _loc1_.push(_loc2_);
            }
         }
         if(Boolean(_loc1_) && _loc1_.length > 0)
         {
            _loc1_.sort(DictionaryUtils.sortCardsDefsByValue);
         }
         return _loc1_;
      }
      
      public function createBestDeckConfiguration() : Vector.<String>
      {
         var _loc1_:Vector.<String> = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:CardDef = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Dictionary = null;
         var _loc10_:int = 0;
         var _loc11_:Boolean = false;
         var _loc12_:Vector.<CardDef> = null;
         var _loc13_:Array = null;
         var _loc14_:Array = null;
         var _loc15_:Array = null;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:int = 0;
         var _loc28_:int = 0;
         var _loc29_:int = 0;
         var _loc30_:Object = null;
         var _loc31_:int = 0;
         var _loc32_:int = 0;
         var _loc33_:int = 0;
         _loc1_ = new Vector.<String>();
         if(this.mCardCollectionArr != null)
         {
            _loc2_ = new Array();
            _loc9_ = new Dictionary(true);
            _loc11_ = false;
            _loc12_ = this.getCardCollectionCardDefs();
            if((Boolean(_loc12_)) && _loc12_.length > 0)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc12_.length)
               {
                  _loc6_ = _loc12_[_loc3_];
                  if(_loc6_)
                  {
                     _loc7_ = _loc6_.getMaxAmountOndeck();
                     _loc10_ = this.getCardAmount(_loc6_.getSku());
                     _loc4_ = 0;
                     for(; _loc4_ < _loc10_; _loc4_++)
                     {
                        if(_loc4_ < _loc7_ && !DictionaryUtils.getDeckFamilyIDMaxReached(_loc6_,_loc9_))
                        {
                           if(_loc6_.isLeader())
                           {
                              if(_loc11_)
                              {
                                 continue;
                              }
                              _loc11_ = true;
                           }
                           _loc2_[_loc8_] = _loc6_.getSku();
                           _loc9_[_loc6_.getSku()] = int(_loc9_[_loc6_.getSku()]) + 1;
                           _loc8_++;
                        }
                     }
                  }
                  _loc3_++;
               }
            }
            _loc13_ = new Array();
            _loc14_ = new Array();
            _loc15_ = new Array();
            _loc16_ = 0;
            _loc17_ = 0;
            _loc18_ = 0;
            FSDebug.debugTrace("* CARDS BY CARD VALUE *\n");
            _loc3_ = 0;
            for(; _loc3_ < _loc2_.length; FSDebug.debugTrace(_loc2_[_loc3_] + " | " + _loc6_.getCardRarity() + " | " + _loc6_.getCardValue()),_loc3_++)
            {
               _loc6_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc2_[_loc3_]));
               if(!_loc6_)
               {
                  continue;
               }
               switch(_loc6_.getCategoryIndex())
               {
                  case CategoriesDefMng.CATEGORY_UNITS:
                     _loc13_[_loc16_] = _loc6_.getSku();
                     _loc16_++;
                     break;
                  case CategoriesDefMng.CATEGORY_ATTACHMENTS:
                     _loc14_[_loc17_] = _loc6_.getSku();
                     _loc17_++;
                     break;
                  case CategoriesDefMng.CATEGORY_ACTIONS:
                     _loc15_[_loc18_] = _loc6_.getSku();
                     _loc18_++;
               }
            }
            _loc19_ = _loc16_ + _loc17_ + _loc18_;
            _loc20_ = Config.getConfig().getDeckCardsAmount();
            _loc21_ = _loc20_ * 0.75;
            _loc22_ = Config.getConfig().gameHasAttachments() ? int(Math.ceil(_loc20_ * 0.15)) : 0;
            _loc23_ = Config.getConfig().gameHasAttachments() ? int(_loc20_ * 0.1) : int(_loc20_ * 0.25);
            _loc24_ = _loc21_ > _loc16_ ? int(_loc21_ - _loc16_) : 0;
            _loc25_ = _loc22_ > _loc17_ ? int(_loc22_ - _loc17_) : 0;
            _loc26_ = _loc23_ > _loc18_ ? int(_loc23_ - _loc18_) : 0;
            _loc27_ = _loc16_ > _loc21_ ? int(_loc16_ - _loc21_) : 0;
            _loc28_ = _loc17_ > _loc22_ ? int(_loc17_ - _loc22_) : 0;
            _loc29_ = _loc18_ > _loc23_ ? int(_loc18_ - _loc23_) : 0;
            _loc30_ = this.returnAmountsByCategory(_loc21_,_loc22_,_loc23_,_loc24_,_loc25_,_loc26_,_loc27_,_loc28_,_loc29_);
            _loc21_ = int(_loc30_.minUnits);
            _loc22_ = int(_loc30_.minAttachments);
            _loc23_ = int(_loc30_.minActions);
            FSDebug.debugTrace("Total cards amount: " + _loc19_);
            _loc31_ = 0;
            if(_loc16_ > _loc21_)
            {
               while(_loc31_ < _loc21_)
               {
                  _loc1_.push(_loc13_.shift());
                  _loc31_++;
               }
            }
            else
            {
               while(_loc13_.length > 0)
               {
                  _loc1_.push(_loc13_.shift());
                  _loc31_++;
               }
            }
            _loc32_ = 0;
            if(_loc17_ > _loc22_)
            {
               while(_loc32_ < _loc22_ && _loc1_.length < Config.getConfig().getDeckCardsAmount())
               {
                  _loc1_.push(_loc14_.shift());
                  _loc32_++;
               }
            }
            else
            {
               while(_loc14_.length > 0 && _loc1_.length < Config.getConfig().getDeckCardsAmount())
               {
                  _loc1_.push(_loc14_.shift());
                  _loc32_++;
               }
            }
            _loc33_ = 0;
            if(_loc18_ > _loc23_)
            {
               while(_loc33_ < _loc23_ && _loc1_.length < Config.getConfig().getDeckCardsAmount())
               {
                  _loc1_.push(_loc15_.shift());
                  _loc33_++;
               }
            }
            else
            {
               while(_loc15_.length > 0 && _loc1_.length < Config.getConfig().getDeckCardsAmount())
               {
                  _loc1_.push(_loc15_.shift());
                  _loc33_++;
               }
            }
         }
         return _loc1_;
      }
      
      public function getPvPDeckValue() : int
      {
         return this.getDeckValue(this.mSelectedDeckIndexPvP);
      }
      
      public function getDeckValue(param1:int) : int
      {
         var _loc2_:int = 0;
         var _loc3_:Dictionary = null;
         _loc2_ = 0;
         _loc3_ = this.getDeck(param1);
         _loc2_ = Utils.getDeckValue(_loc3_);
         FSDebug.debugTrace("DECK (" + param1 + ") VALUE: " + _loc2_);
         return _loc2_;
      }
      
      private function returnAmountsByCategory(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int, param9:int) : Object
      {
         var _loc10_:Object = null;
         if(param4 > 0 && param5 > 0)
         {
            param3 += Math.min(param4 + param5,param9);
         }
         else if(param4 > 0 && param6 > 0)
         {
            param2 += Math.min(param4 + param6,param8);
         }
         else if(param5 > 0 && param6 > 0)
         {
            param1 += Math.min(param5 + param6,param7);
         }
         if(param4 > 0)
         {
            if(param8 > 0)
            {
               if(param8 > param4)
               {
                  param2 += param4;
                  param1 -= param4;
                  param8 -= param4;
                  param4 = 0;
               }
               else
               {
                  param2 += param8;
                  param4 -= param8;
                  param8 = 0;
                  param1 -= param8;
               }
            }
            else if(param9 > 0)
            {
               if(param9 > param4)
               {
                  param3 += param4;
                  param1 -= param4;
                  param9 -= param4;
                  param4 = 0;
               }
               else
               {
                  param3 += param9;
                  param4 -= param9;
                  param1 -= param9;
                  param9 = 0;
               }
            }
         }
         if(param5)
         {
            if(param9 > 0)
            {
               if(param9 > param5)
               {
                  param3 += param5;
                  param2 -= param5;
                  param9 -= param5;
                  param5 = 0;
               }
               else
               {
                  param3 += param9;
                  param5 -= param9;
                  param2 -= param9;
                  param9 = 0;
               }
            }
            else if(param7 > 0)
            {
               if(param7 > param5)
               {
                  param1 += param5;
                  param2 -= param5;
                  param7 -= param5;
                  param5 = 0;
               }
               else
               {
                  param1 += param7;
                  param5 -= param7;
                  param2 -= param7;
                  param7 = 0;
               }
            }
         }
         if(param6)
         {
            if(param8 > 0)
            {
               if(param8 > param6)
               {
                  param2 += param6;
                  param3 -= param6;
                  param8 -= param6;
                  param6 = 0;
               }
               else
               {
                  param2 += param8;
                  param6 -= param8;
                  param3 -= param8;
                  param8 = 0;
               }
            }
            else if(param7 > 0)
            {
               if(param7 > param6)
               {
                  param1 += param6;
                  param3 -= param6;
                  param7 -= param6;
                  param6 = 0;
               }
               else
               {
                  param1 += param7;
                  param6 -= param7;
                  param3 -= param7;
                  param7 = 0;
               }
            }
         }
         if(param4 == 0 && param5 == 0 && param6 == 0)
         {
            _loc10_ = new Object();
            _loc10_.minUnits = param1;
            _loc10_.minAttachments = param2;
            _loc10_.minActions = param3;
         }
         else
         {
            _loc10_ = this.returnAmountsByCategory(param1,param2,param3,param4,param5,param6,param7,param8,param9);
         }
         return _loc10_;
      }
      
      public function hasGuild() : Boolean
      {
         return this.mGuildId != null && this.mGuildId != "";
      }
      
      public function getQuestsClaimed() : Dictionary
      {
         return this.mQuestsClaimed;
      }
      
      public function getBattlePassQuestsClaimed() : Vector.<QuestDef>
      {
         var _loc1_:Vector.<QuestDef> = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:QuestDef = null;
         _loc1_ = null;
         if(this.mQuestsClaimed != null)
         {
            _loc2_ = DictionaryUtils.getKeys(this.mQuestsClaimed);
            if(Boolean(_loc2_) && _loc2_.length > 0)
            {
               _loc3_ = 0;
               _loc3_ = 0;
               while(_loc3_ < _loc2_.length)
               {
                  _loc4_ = QuestDef(InstanceMng.getQuestsDefMng().getDefBySku(_loc2_[_loc3_]));
                  if(_loc4_ != null && _loc4_.isBattlePassQuest() && _loc4_.isBattlePassQuestEligibleBySeason())
                  {
                     if(_loc1_ == null)
                     {
                        _loc1_ = new Vector.<QuestDef>();
                     }
                     _loc1_.push(_loc4_);
                  }
                  _loc3_++;
               }
            }
         }
         return _loc1_;
      }
      
      public function addQuestClaimed(param1:String, param2:Boolean = true) : void
      {
         if(this.mQuestsClaimed == null)
         {
            this.mQuestsClaimed = new Dictionary(true);
         }
         this.mQuestsClaimed[param1] = true;
         this.removeQuestCompleted(param1,false);
         if(param2 && this.mIsOwner)
         {
            InstanceMng.getUserDataMng().updateQuestsClaimed();
         }
      }
      
      public function isQuestAlreadyClaimed(param1:String) : Boolean
      {
         var _loc2_:Boolean = false;
         _loc2_ = false;
         if(this.mQuestsClaimed != null)
         {
            _loc2_ = this.mQuestsClaimed[param1] == true;
         }
         return _loc2_;
      }
      
      public function getQuestsCompleted() : Dictionary
      {
         return this.mQuestsCompleted;
      }
      
      public function addQuestCompleted(param1:String, param2:Boolean = true) : void
      {
         if(this.mQuestsCompleted == null)
         {
            this.mQuestsCompleted = new Dictionary(true);
         }
         this.mQuestsCompleted[param1] = true;
         this.removeQuestProgress(param1,false);
         if(param2 && this.mIsOwner)
         {
            InstanceMng.getUserDataMng().updateQuestsCompleted();
         }
      }
      
      public function removeQuestCompleted(param1:String, param2:Boolean = true) : void
      {
         if(Boolean(this.mQuestsCompleted) && this.mQuestsCompleted[param1] != null)
         {
            this.mQuestsCompleted[param1] = null;
            delete this.mQuestsCompleted[param1];
         }
         if(param2 && this.mIsOwner)
         {
            InstanceMng.getUserDataMng().updateQuestsCompleted();
         }
      }
      
      public function getQuestsNotifiedAsCompleted() : Dictionary
      {
         return this.mQuestsNotifiedAsCompleted;
      }
      
      public function addQuestNotifiedAsCompleted(param1:String, param2:Boolean = true) : void
      {
         if(this.mQuestsNotifiedAsCompleted == null)
         {
            this.mQuestsNotifiedAsCompleted = new Dictionary(true);
         }
         this.mQuestsNotifiedAsCompleted[param1] = true;
         if(param2 && this.mIsOwner)
         {
            InstanceMng.getUserDataMng().updateQuestsNotifiedAsCompleted();
         }
      }
      
      public function removeQuestProgress(param1:String, param2:Boolean = true) : void
      {
         if(Boolean(this.mQuestsProgress) && this.mQuestsProgress[param1] != null)
         {
            this.mQuestsProgress[param1] = null;
            delete this.mQuestsProgress[param1];
         }
         if(param2 && this.mIsOwner)
         {
            if(InstanceMng.getUserDataMng())
            {
               InstanceMng.getUserDataMng().updateQuestsProgress();
            }
         }
      }
      
      public function removeBattlePassQuestsProgress(param1:Boolean = true) : void
      {
         var _loc2_:Array = null;
         var _loc3_:QuestDef = null;
         var _loc4_:int = 0;
         if(this.mQuestsProgress)
         {
            _loc2_ = DictionaryUtils.getKeys(this.mQuestsProgress);
            if(Boolean(_loc2_) && _loc2_.length > 0)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc2_.length)
               {
                  _loc3_ = QuestDef(InstanceMng.getQuestsDefMng().getDefBySku(_loc2_[_loc4_]));
                  if(Boolean(_loc3_) && _loc3_.isBattlePassQuest())
                  {
                     this.mQuestsProgress[_loc3_.getSku()] = null;
                     delete this.mQuestsProgress[_loc3_.getSku()];
                  }
                  _loc4_++;
               }
            }
            if(param1 && this.mIsOwner && Boolean(InstanceMng.getUserDataMng()))
            {
               InstanceMng.getUserDataMng().updateQuestsProgress();
            }
         }
      }
      
      public function removeBattlePassQuestsCompleted(param1:Boolean = true) : void
      {
         var _loc2_:Array = null;
         var _loc3_:QuestDef = null;
         var _loc4_:int = 0;
         if(this.mQuestsCompleted)
         {
            _loc2_ = DictionaryUtils.getKeys(this.mQuestsCompleted);
            if(Boolean(_loc2_) && _loc2_.length > 0)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc2_.length)
               {
                  _loc3_ = QuestDef(InstanceMng.getQuestsDefMng().getDefBySku(_loc2_[_loc4_]));
                  if(Boolean(_loc3_) && _loc3_.isBattlePassQuest())
                  {
                     this.mQuestsCompleted[_loc3_.getSku()] = null;
                     delete this.mQuestsCompleted[_loc3_.getSku()];
                  }
                  _loc4_++;
               }
            }
            if(param1 && this.mIsOwner && Boolean(InstanceMng.getUserDataMng()))
            {
               InstanceMng.getUserDataMng().updateQuestsCompleted();
            }
         }
      }
      
      public function removeQuestNotifiedAsCompleted(param1:String, param2:Boolean = true) : void
      {
         if(this.mQuestsNotifiedAsCompleted)
         {
            this.mQuestsNotifiedAsCompleted[param1] = null;
            delete this.mQuestsNotifiedAsCompleted[param1];
         }
         if(param2 && this.mIsOwner && Boolean(InstanceMng.getUserDataMng()))
         {
            InstanceMng.getUserDataMng().updateQuestsNotifiedAsCompleted();
         }
      }
      
      public function removeBattlePassQuestsNotifiedAsCompleted(param1:Boolean = true) : void
      {
         var _loc2_:Array = null;
         var _loc3_:QuestDef = null;
         var _loc4_:int = 0;
         if(this.mQuestsNotifiedAsCompleted)
         {
            _loc2_ = DictionaryUtils.getKeys(this.mQuestsNotifiedAsCompleted);
            if(Boolean(_loc2_) && _loc2_.length > 0)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc2_.length)
               {
                  _loc3_ = QuestDef(InstanceMng.getQuestsDefMng().getDefBySku(_loc2_[_loc4_]));
                  if(Boolean(_loc3_) && _loc3_.isBattlePassQuest())
                  {
                     this.mQuestsNotifiedAsCompleted[_loc3_.getSku()] = null;
                     delete this.mQuestsNotifiedAsCompleted[_loc3_.getSku()];
                  }
                  _loc4_++;
               }
            }
            if(param1 && this.mIsOwner && Boolean(InstanceMng.getUserDataMng()))
            {
               InstanceMng.getUserDataMng().updateQuestsNotifiedAsCompleted();
            }
         }
      }
      
      public function removeBattlePassQuestsClaimed(param1:Boolean = true) : void
      {
         var _loc2_:Array = null;
         var _loc3_:QuestDef = null;
         var _loc4_:int = 0;
         if(this.mQuestsClaimed)
         {
            _loc2_ = DictionaryUtils.getKeys(this.mQuestsClaimed);
            if(Boolean(_loc2_) && _loc2_.length > 0)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc2_.length)
               {
                  _loc3_ = QuestDef(InstanceMng.getQuestsDefMng().getDefBySku(_loc2_[_loc4_]));
                  if(Boolean(_loc3_) && _loc3_.isBattlePassQuest())
                  {
                     this.mQuestsClaimed[_loc3_.getSku()] = null;
                     delete this.mQuestsClaimed[_loc3_.getSku()];
                  }
                  _loc4_++;
               }
            }
            if(param1 && this.mIsOwner && Boolean(InstanceMng.getUserDataMng()))
            {
               InstanceMng.getUserDataMng().updateQuestsClaimed();
            }
         }
      }
      
      public function isQuestCompleted(param1:String) : Boolean
      {
         var _loc2_:Boolean = false;
         _loc2_ = false;
         if(this.mQuestsCompleted != null)
         {
            _loc2_ = this.mQuestsCompleted[param1] == true;
         }
         if(_loc2_ == false && Boolean(this.mQuestsNotifiedAsCompleted))
         {
            _loc2_ = this.mQuestsNotifiedAsCompleted[param1] == true;
         }
         return _loc2_;
      }
      
      public function isQuestNotifiedAsCompleted(param1:String) : Boolean
      {
         var _loc2_:Boolean = false;
         _loc2_ = false;
         if(this.mQuestsNotifiedAsCompleted != null)
         {
            _loc2_ = this.mQuestsNotifiedAsCompleted[param1] == true;
         }
         return _loc2_;
      }
      
      public function getQuestsProgress() : Dictionary
      {
         return this.mQuestsProgress;
      }
      
      public function setQuestProgress(param1:String, param2:int, param3:Boolean = true) : void
      {
         if(this.mQuestsProgress == null)
         {
            this.mQuestsProgress = new Dictionary(true);
         }
         this.mQuestsProgress[param1] = param2;
         if(param3 && this.mIsOwner)
         {
            InstanceMng.getUserDataMng().updateQuestsProgress();
         }
      }
      
      public function addQuestProgress(param1:String, param2:int, param3:Boolean = true) : void
      {
         if(this.mQuestsProgress == null)
         {
            this.mQuestsProgress = new Dictionary(true);
         }
         if(this.mQuestsProgress[param1] == null)
         {
            this.mQuestsProgress[param1] = 0;
         }
         this.mQuestsProgress[param1] += param2;
         if(param3 && this.mIsOwner)
         {
            InstanceMng.getUserDataMng().updateQuestsProgress();
         }
      }
      
      public function getQuestProgress(param1:String) : int
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         if(this.mQuestsProgress != null)
         {
            _loc2_ = int(this.mQuestsProgress[param1]);
         }
         return _loc2_;
      }
      
      public function resetDailyQuestsProgress(param1:Boolean = true, param2:Boolean = false) : void
      {
         var _loc3_:Quest = null;
         var _loc4_:QuestDef = null;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         if(this.mQuestsProgress)
         {
            _loc6_ = DictionaryUtils.getKeys(this.mQuestsProgress);
            if((Boolean(_loc6_)) && _loc6_.length > 0)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc6_.length)
               {
                  _loc4_ = QuestDef(InstanceMng.getQuestsDefMng().getDefBySku(_loc6_[_loc5_]));
                  if((Boolean(_loc4_)) && _loc4_.isDaily())
                  {
                     this.mQuestsProgress[_loc6_[_loc5_]] = null;
                     delete this.mQuestsProgress[_loc6_[_loc5_]];
                  }
                  _loc5_++;
               }
            }
         }
         if(this.mQuestsClaimed)
         {
            _loc6_ = DictionaryUtils.getKeys(this.mQuestsClaimed);
            if((Boolean(_loc6_)) && _loc6_.length > 0)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc6_.length)
               {
                  _loc4_ = QuestDef(InstanceMng.getQuestsDefMng().getDefBySku(_loc6_[_loc5_]));
                  if((Boolean(_loc4_)) && _loc4_.isDaily())
                  {
                     this.mQuestsClaimed[_loc6_[_loc5_]] = null;
                     delete this.mQuestsClaimed[_loc6_[_loc5_]];
                  }
                  _loc5_++;
               }
            }
         }
         if(this.mQuestsNotifiedAsCompleted)
         {
            _loc6_ = DictionaryUtils.getKeys(this.mQuestsNotifiedAsCompleted);
            if((Boolean(_loc6_)) && _loc6_.length > 0)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc6_.length)
               {
                  _loc4_ = QuestDef(InstanceMng.getQuestsDefMng().getDefBySku(_loc6_[_loc5_]));
                  if((Boolean(_loc4_)) && _loc4_.isDaily())
                  {
                     this.mQuestsNotifiedAsCompleted[_loc6_[_loc5_]] = null;
                     delete this.mQuestsNotifiedAsCompleted[_loc6_[_loc5_]];
                  }
                  _loc5_++;
               }
            }
         }
         if(param1)
         {
            InstanceMng.getUserDataMng().persistenceSaveData();
         }
         if(param2)
         {
            InstanceMng.getQuestsMng().resetQuestsMng();
         }
      }
      
      public function resetDailyRaidTickets() : void
      {
         this.addRaidTicketsSP(Config.getConfig().getRaidTicketsSinglePlayer().value);
         this.addRaidTicketsMP(Config.getConfig().getRaidTicketsMultiPlayer().value);
      }
      
      public function resetDailyBotsPlayedSession() : void
      {
         this.mBotsPlayedSession = 0;
      }
      
      public function canResetDailyQuests() : String
      {
         var _loc1_:String = null;
         var _loc2_:Quest = null;
         var _loc3_:QuestDef = null;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:Boolean = false;
         _loc1_ = "";
         _loc6_ = false;
         _loc5_ = DictionaryUtils.getKeys(this.mQuestsCompleted);
         if((Boolean(_loc5_)) && _loc5_.length > 0)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc5_.length)
            {
               _loc3_ = QuestDef(InstanceMng.getQuestsDefMng().getDefBySku(_loc5_[_loc4_]));
               if(Boolean(_loc3_) && _loc3_.isDaily())
               {
                  return TextManager.getText("TID_QUEST_CLAIM_FIRST");
               }
               _loc4_++;
            }
         }
         if(this.mQuestsProgress)
         {
            _loc5_ = DictionaryUtils.getKeys(this.mQuestsProgress);
            if((Boolean(_loc5_)) && _loc5_.length > 0)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc5_.length)
               {
                  _loc3_ = QuestDef(InstanceMng.getQuestsDefMng().getDefBySku(_loc5_[_loc4_]));
                  if(Boolean(_loc3_) && _loc3_.isDaily())
                  {
                     _loc6_ = true;
                  }
                  _loc4_++;
               }
            }
         }
         _loc5_ = DictionaryUtils.getKeys(this.mQuestsClaimed);
         if((Boolean(_loc5_)) && _loc5_.length > 0)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc5_.length)
            {
               _loc3_ = QuestDef(InstanceMng.getQuestsDefMng().getDefBySku(_loc5_[_loc4_]));
               if(Boolean(_loc3_) && _loc3_.isDaily())
               {
                  _loc6_ = true;
               }
               _loc4_++;
            }
         }
         if(!_loc6_)
         {
            return TextManager.getText("TID_QUEST_RESET_NOT_ELEGIBLE");
         }
         return _loc1_;
      }
      
      public function godModeResetQuests(param1:Boolean = true) : void
      {
         this.mQuestsClaimed = null;
         this.mQuestsCompleted = null;
         this.mQuestsProgress = null;
         this.mQuestsNotifiedAsCompleted = null;
         if(param1)
         {
            InstanceMng.getUserDataMng().persistenceSaveData();
         }
         InstanceMng.getQuestsMng().resetQuestsMng();
      }
      
      public function getDailyKeyTime() : Number
      {
         return this.mDailyKeyTime.value;
      }
      
      public function setDailyKeyTime(param1:Number) : void
      {
         if(this.mDailyKeyTime == null)
         {
            this.mDailyKeyTime = new FSNumber(param1);
         }
         else
         {
            this.mDailyKeyTime.value = param1;
         }
      }
      
      public function getMonthNumber() : Number
      {
         return this.mMonthNumber.value;
      }
      
      public function setMonthNumber(param1:Number) : void
      {
         if(this.mMonthNumber == null)
         {
            this.mMonthNumber = new FSNumber(param1);
         }
         else
         {
            this.mMonthNumber.value = param1;
         }
      }
      
      public function getWeekNumber() : Number
      {
         return this.mWeekNumber.value;
      }
      
      public function setWeekNumber(param1:Number) : void
      {
         if(this.mWeekNumber == null)
         {
            this.mWeekNumber = new FSNumber(param1);
         }
         else
         {
            this.mWeekNumber.value = param1;
         }
      }
      
      public function hasValidBattlePass() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc1_ = false;
         if(this.mBattlePass != "" && this.mBattlePass != null)
         {
            _loc2_ = Config.smYearNumber.value;
            _loc3_ = Config.smMonthNumber.value;
            _loc4_ = int(this.mBattlePass.split("-")[0]);
            _loc5_ = int(this.mBattlePass.split("-")[1]);
            _loc1_ = _loc2_ == _loc4_ && _loc3_ == _loc5_;
         }
         return _loc1_;
      }
      
      public function getBattlePass() : String
      {
         return this.mBattlePass;
      }
      
      public function setBattlePass(param1:String) : void
      {
         this.mBattlePass = param1;
      }
      
      public function getBotsPlayedSession() : int
      {
         return this.mBotsPlayedSession;
      }
      
      public function addBotsPlayedSession(param1:int = 1) : void
      {
         this.mBotsPlayedSession += param1;
      }
      
      public function setBotsPlayedSession(param1:int) : void
      {
         this.mBotsPlayedSession = param1;
      }
      
      public function getRaidTicketsSinglePlayer() : Number
      {
         return this.mRaidTicketsSP ? this.mRaidTicketsSP.value : 0;
      }
      
      public function getRaidTicketsMultiPlayer() : Number
      {
         return this.mRaidTicketsMP ? this.mRaidTicketsMP.value : 0;
      }
      
      public function setRaidTicketsSinglePlayer(param1:Number) : void
      {
         if(this.mRaidTicketsSP == null)
         {
            this.mRaidTicketsSP = new FSNumber();
         }
         this.mRaidTicketsSP.value = param1;
      }
      
      public function addRaidTicketsSP(param1:Number, param2:Boolean = true) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         if(param1 < 0)
         {
            throw new Error("Adding currency should receive a positive value");
         }
         if(this.mRaidTicketsSP == null)
         {
            this.mRaidTicketsSP = new FSNumber();
         }
         _loc3_ = Config.getConfig().getRaidTicketsSinglePlayer().value;
         _loc4_ = this.mRaidTicketsSP.value + param1 <= _loc3_ ? int(param1) : int(_loc3_ - this.mRaidTicketsSP.value);
         this.mRaidTicketsSP.value += _loc4_;
         InstanceMng.getServerConnection().addPlayerCurrency(_loc4_,ServerConnection.CURRENCY_RAID_TICKETS_SP,param2);
      }
      
      public function substractRaidTicketsSP(param1:Number, param2:Function = null, param3:Array = null, param4:Function = null, param5:Array = null) : void
      {
         if(param1 > 0)
         {
            throw new Error("Substracting currency should receive a negative value");
         }
         InstanceMng.getServerConnection().addPlayerCurrency(param1,ServerConnection.CURRENCY_RAID_TICKETS_SP,true,param2,param3,param4,param5);
      }
      
      public function addRaidTicketsMP(param1:Number, param2:Boolean = true) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         if(param1 < 0)
         {
            throw new Error("Adding currency should receive a positive value");
         }
         if(this.mRaidTicketsMP == null)
         {
            this.mRaidTicketsMP = new FSNumber();
         }
         _loc3_ = Config.getConfig().getRaidTicketsMultiPlayer().value;
         _loc4_ = this.mRaidTicketsMP.value + param1 <= _loc3_ ? int(param1) : int(_loc3_ - this.mRaidTicketsMP.value);
         this.mRaidTicketsMP.value += _loc4_;
         InstanceMng.getServerConnection().addPlayerCurrency(_loc4_,ServerConnection.CURRENCY_RAID_TICKETS_MP,param2);
      }
      
      public function substractRaidTicketsMP(param1:Number, param2:Function = null, param3:Array = null, param4:Function = null, param5:Array = null) : void
      {
         if(param1 > 0)
         {
            throw new Error("Substracting currency should receive a negative value");
         }
         InstanceMng.getServerConnection().addPlayerCurrency(param1,ServerConnection.CURRENCY_RAID_TICKETS_MP,true,param2,param3,param4,param5);
      }
      
      public function setRaidTicketsMultiPlayer(param1:Number) : void
      {
         if(this.mRaidTicketsMP == null)
         {
            this.mRaidTicketsMP = new FSNumber();
         }
         this.mRaidTicketsMP.value = param1;
      }
      
      public function getAuctionTickets() : Number
      {
         return this.mAuctionTickets ? this.mAuctionTickets.value : 0;
      }
      
      public function setAuctionTickets(param1:Number) : void
      {
         if(this.mAuctionTickets == null)
         {
            this.mAuctionTickets = new FSNumber();
         }
         this.mAuctionTickets.value = param1;
      }
      
      public function getRaidsUnlocked() : String
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         _loc1_ = "";
         if(this.mRaidsUnlockedArray)
         {
            this.mRaidsUnlockedArray.sort();
            _loc2_ = 0;
            while(_loc2_ < this.mRaidsUnlockedArray.length)
            {
               _loc1_ += this.mRaidsUnlockedArray[_loc2_];
               if(_loc2_ < this.mRaidsUnlockedArray.length - 1)
               {
                  _loc1_ += ",";
               }
               _loc2_++;
            }
         }
         return _loc1_;
      }
      
      public function setRaidsUnlocked(param1:Array) : void
      {
         this.mRaidsUnlockedArray = param1;
      }
      
      public function addRaidsUnlocked(param1:String) : void
      {
         if(this.mRaidsUnlockedArray == null)
         {
            this.mRaidsUnlockedArray = new Array();
         }
         this.mRaidsUnlockedArray[this.mRaidsUnlockedArray.length] = param1;
      }
      
      public function isUnlockedRaid(param1:String) : Boolean
      {
         var _loc2_:int = 0;
         if(this.mRaidsUnlockedArray != null)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mRaidsUnlockedArray.length)
            {
               if(this.mRaidsUnlockedArray[_loc2_] == param1)
               {
                  return true;
               }
               _loc2_++;
            }
         }
         return false;
      }
      
      public function getPassiveAbilitySku() : String
      {
         var _loc1_:String = null;
         var _loc2_:LevelDef = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:DeckJobConfigurator = null;
         var _loc8_:String = null;
         var _loc9_:JobDef = null;
         if(Config.getConfig().gameHasClassSystem())
         {
            _loc2_ = InstanceMng.getBattleEngine() ? InstanceMng.getBattleEngine().getLevelDef() : null;
            if(_loc2_)
            {
               _loc3_ = _loc2_.getMapWorldParentIndex();
               _loc4_ = this.getMapWorldChoice(_loc4_);
               _loc5_ = this.mIsOwner ? _loc2_.getPassiveAbilitySku() : _loc2_.getAIPassiveAbilitySku(_loc4_);
               if(_loc5_ != "" && _loc5_ != null)
               {
                  _loc1_ = _loc5_;
               }
               else
               {
                  _loc6_ = InstanceMng.getBattleEngine().isPvPMatch() ? this.getSelectedDeckIndexPvP() : this.getSelectedDeckIndex();
                  _loc7_ = this.getDeckJobConfiguratorByDeck(_loc6_);
                  if(_loc6_ >= Config.getConfig().getMaxDecksAmount())
                  {
                     _loc9_ = InstanceMng.getJobsDefMng().getBasicJobByDeck(_loc6_.toString());
                     if(_loc9_)
                     {
                        _loc1_ = _loc9_.getPassiveSku();
                     }
                  }
                  else if(_loc7_)
                  {
                     _loc8_ = _loc7_.getJobSku();
                     if(_loc8_)
                     {
                        _loc9_ = JobDef(InstanceMng.getJobsDefMng().getDefBySku(_loc8_));
                        if(_loc9_)
                        {
                           _loc1_ = _loc9_.getPassiveSku();
                        }
                     }
                  }
               }
            }
         }
         return _loc1_;
      }
      
      public function getCurrentLevelSkuByDifficulty(param1:int) : String
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case UserDataMng.DIFFICULTY_EASY:
               _loc2_ = this.mCurrentLevelSku;
               break;
            case UserDataMng.DIFFICULTY_MEDIUM:
               _loc2_ = this.mCurrentLevelMediumSku;
               break;
            case UserDataMng.DIFFICULTY_HARD:
               _loc2_ = this.mCurrentLevelHardSku;
               break;
            default:
               _loc2_ = this.mCurrentLevelSku;
         }
         return _loc2_;
      }
      
      public function getCurrentLevelIndex(param1:int) : int
      {
         var _loc2_:int = 0;
         switch(param1)
         {
            case UserDataMng.DIFFICULTY_EASY:
               _loc2_ = this.mCurrentLevelIndex;
               break;
            case UserDataMng.DIFFICULTY_MEDIUM:
               _loc2_ = this.mCurrentLevelMediumIndex;
               break;
            case UserDataMng.DIFFICULTY_HARD:
               _loc2_ = this.mCurrentLevelHardIndex;
               break;
            default:
               _loc2_ = this.mCurrentLevelIndex;
         }
         return _loc2_;
      }
      
      public function getLastBidRoundInBiddersArr(param1:String) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         _loc2_ = -1;
         _loc3_ = 0;
         if(Boolean(this.mAuctionIdBiddedArr) && this.mAuctionIdBiddedArr.length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < this.mAuctionIdBiddedArr.length)
            {
               _loc4_ = String(this.mAuctionIdBiddedArr[_loc3_]).split(":")[0];
               if(_loc4_ == param1)
               {
                  _loc2_ = int(String(this.mAuctionIdBiddedArr[_loc3_]).split(":")[1]);
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      public function getLastBidPriceInBiddersArr(param1:String) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         _loc2_ = -1;
         _loc3_ = 0;
         if(Boolean(this.mAuctionIdBiddedArr) && this.mAuctionIdBiddedArr.length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < this.mAuctionIdBiddedArr.length)
            {
               _loc4_ = String(this.mAuctionIdBiddedArr[_loc3_]).split(":")[0];
               if(_loc4_ == param1)
               {
                  _loc2_ = int(String(this.mAuctionIdBiddedArr[_loc3_]).split(":")[2]);
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      public function getJobExperienceByJobSku(param1:String) : Number
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         _loc2_ = 0;
         if(Boolean(this.mJobsExperience) && this.mJobsExperience.length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < this.mJobsExperience.length)
            {
               _loc4_ = String(this.mJobsExperience[_loc3_]).split(":")[0];
               if(_loc4_ == param1)
               {
                  _loc2_ = Number(String(this.mJobsExperience[_loc3_]).split(":")[1]);
                  break;
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      public function addJobExperienceByJobSku(param1:String, param2:Number) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Number = NaN;
         if(Boolean(this.mJobsExperience) && this.mJobsExperience.length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < this.mJobsExperience.length)
            {
               _loc4_ = String(this.mJobsExperience[_loc3_]).split(":")[0];
               _loc5_ = Number(String(this.mJobsExperience[_loc3_]).split(":")[1]);
               if(_loc4_ == param1)
               {
                  _loc5_ += param2;
                  this.mJobsExperience[_loc3_] = param1 + ":" + _loc5_.toString();
                  break;
               }
               _loc3_++;
            }
         }
      }
      
      public function getVersionByPlatform(param1:String) : String
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         _loc2_ = "";
         if(Boolean(this.mPlatformVersions) && this.mPlatformVersions.length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < this.mPlatformVersions.length)
            {
               _loc4_ = String(this.mPlatformVersions[_loc3_]).split(":")[0];
               if(_loc4_ == param1)
               {
                  _loc2_ = String(this.mPlatformVersions[_loc3_]).split(":")[1];
                  break;
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      public function addVersionByPlatform(param1:String, param2:String) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         var _loc6_:String = null;
         if(this.mPlatformVersions == null)
         {
            this.mPlatformVersions = new Array();
            this.mPlatformVersions.push(param1 + ":" + param2);
            if(this.mIsOwner)
            {
               Config.smEligibleToShowReleaseNotesButton = true;
            }
         }
         else
         {
            _loc4_ = false;
            _loc3_ = 0;
            while(_loc3_ < this.mPlatformVersions.length)
            {
               _loc5_ = String(this.mPlatformVersions[_loc3_]).split(":")[0];
               _loc6_ = String(this.mPlatformVersions[_loc3_]).split(":")[1];
               if(_loc5_ == param1)
               {
                  _loc4_ = true;
                  if(this.mIsOwner)
                  {
                     Config.smEligibleToShowReleaseNotesButton = this.mPlatformVersions[_loc3_] == "" || this.mPlatformVersions[_loc3_] == null || _loc6_ != null && _loc6_ != param2;
                  }
                  this.mPlatformVersions[_loc3_] = param1 + ":" + param2;
                  break;
               }
               _loc3_++;
            }
            if(!_loc4_)
            {
               this.mPlatformVersions.push(param1 + ":" + param2);
            }
         }
         if(this.mIsOwner && Config.smEligibleToShowReleaseNotesButton == true && InstanceMng.getCurrentScreen() is FSMenuScreen)
         {
            if(InstanceMng.getCurrentScreen().isFullyLoaded())
            {
               FSMenuScreen(InstanceMng.getCurrentScreen()).checkReleaseNotes();
            }
         }
      }
      
      public function setDeckJobConfiguratorArr(param1:Array) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:JobDef = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         if(Boolean(param1) && param1.length > 0)
         {
            _loc2_ = "";
            _loc3_ = "";
            _loc4_ = "";
            if(this.mDeckJobConfigurationArr == null)
            {
               this.mDeckJobConfigurationArr = new Array();
            }
            else
            {
               this.mDeckJobConfigurationArr.length = 0;
            }
            _loc7_ = 0;
            while(_loc7_ < param1.length)
            {
               _loc6_ = String(param1[_loc7_]).split("-");
               _loc2_ = _loc6_[1];
               _loc3_ = _loc6_[2];
               _loc4_ = _loc6_[3];
               _loc5_ = JobDef(InstanceMng.getJobsDefMng().getDefBySku(_loc2_));
               if(_loc5_)
               {
                  _loc3_ = _loc3_ != null && _loc3_ != "" && _loc3_ != "null" ? _loc3_ : _loc5_.getActiveDefaultSku();
                  _loc4_ = _loc4_ != null && _loc4_ != "" && _loc4_ != "null" ? _loc4_ : _loc5_.getDefaultSkinSku();
               }
               _loc8_ = _loc6_[0] != "" ? _loc6_[0] + "-" + _loc6_[1] + "-" + _loc3_ + "-" + _loc4_ : "";
               this.mDeckJobConfigurationArr.push(_loc8_);
               _loc7_++;
            }
         }
      }
      
      public function getDeckJobConfiguratorByDeck(param1:int) : DeckJobConfigurator
      {
         var _loc2_:DeckJobConfigurator = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:JobDef = null;
         var _loc8_:Array = null;
         var _loc9_:String = null;
         if(Boolean(this.mDeckJobConfigurationArr) && this.mDeckJobConfigurationArr.length > 0)
         {
            _loc4_ = "";
            _loc5_ = "";
            _loc6_ = "";
            _loc3_ = 0;
            while(_loc3_ < this.mDeckJobConfigurationArr.length)
            {
               _loc8_ = String(this.mDeckJobConfigurationArr[_loc3_]).split("-");
               _loc9_ = _loc8_[0];
               if(param1 == int(_loc9_))
               {
                  _loc4_ = _loc8_[1];
                  _loc5_ = _loc8_[2];
                  _loc6_ = _loc8_[3];
                  _loc7_ = JobDef(InstanceMng.getJobsDefMng().getDefBySku(_loc4_));
                  if(_loc7_)
                  {
                     _loc5_ = _loc5_ != null && _loc5_ != "" && _loc5_ != "null" ? _loc5_ : _loc7_.getActiveDefaultSku();
                     _loc6_ = _loc6_ != null && _loc6_ != "" && _loc6_ != "null" ? _loc6_ : _loc7_.getDefaultSkinSku();
                  }
                  _loc2_ = new DeckJobConfigurator(_loc8_[0],_loc8_[1],_loc5_,_loc6_);
                  break;
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      public function setDeckJobConfigurator(param1:DeckJobConfigurator) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:JobDef = null;
         var _loc8_:Array = null;
         var _loc9_:String = null;
         _loc3_ = false;
         if(param1)
         {
            if(this.mDeckJobConfigurationArr == null)
            {
               this.mDeckJobConfigurationArr = new Array();
            }
            if(Boolean(this.mDeckJobConfigurationArr) && this.mDeckJobConfigurationArr.length > 0)
            {
               _loc4_ = "";
               _loc5_ = "";
               _loc6_ = "";
               _loc2_ = 0;
               while(_loc2_ < this.mDeckJobConfigurationArr.length)
               {
                  _loc8_ = String(this.mDeckJobConfigurationArr[_loc2_]).split("-");
                  _loc9_ = _loc8_[0];
                  if(_loc9_ == param1.getDeckIndex())
                  {
                     _loc4_ = param1.getJobSku();
                     _loc5_ = param1.getActiveAbilitySku();
                     _loc6_ = param1.getSkinSku();
                     _loc7_ = JobDef(InstanceMng.getJobsDefMng().getDefBySku(_loc4_));
                     _loc5_ = _loc5_ != null && _loc5_ != "" && _loc5_ != "null" ? _loc5_ : _loc7_.getActiveDefaultSku();
                     _loc6_ = _loc6_ != null && _loc6_ != "" && _loc6_ != "null" ? _loc6_ : _loc7_.getDefaultSkinSku();
                     param1.setActiveAbilitySku(_loc5_);
                     param1.setSelectedSkinSku(_loc6_);
                     this.mDeckJobConfigurationArr[_loc2_] = param1.getString();
                     _loc3_ = true;
                     break;
                  }
                  _loc2_++;
               }
            }
            if(!_loc3_)
            {
               this.mDeckJobConfigurationArr.push(param1.getString());
            }
         }
      }
      
      public function addNewSkinsJobs() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         _loc1_ = InstanceMng.getJobsDefMng().getAllJobsDef();
         if(Boolean(_loc1_) && _loc1_.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc1_.length)
            {
               _loc3_ = JobDef(_loc1_[_loc2_]).getDefaultSkinSku();
               this.addSkinToCatalog(_loc3_);
               _loc2_++;
            }
         }
      }
      
      public function hasAnyCustomDeckAvailable() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Dictionary = null;
         var _loc5_:Dictionary = null;
         _loc1_ = false;
         if(this.mDecksArr)
         {
            _loc3_ = Config.getConfig().getMaxDecksAmount();
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               _loc4_ = InstanceMng.getUserDataMng().getOwnerUserData().getDeck(_loc2_);
               _loc5_ = InstanceMng.getUserDataMng().getOwnerUserData().getCardCollection();
               if(DictionaryUtils.checkIfDeckSizeCorrect(_loc4_,_loc5_))
               {
                  return true;
               }
               _loc2_++;
            }
         }
         return _loc1_;
      }
      
      public function getFirstCustomDeckIndexAvailable() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Dictionary = null;
         var _loc5_:Dictionary = null;
         _loc1_ = Config.getConfig().getMaxDecksAmount();
         if(this.mDecksArr)
         {
            _loc3_ = Config.getConfig().getMaxDecksAmount();
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               _loc4_ = InstanceMng.getUserDataMng().getOwnerUserData().getDeck(_loc2_);
               _loc5_ = InstanceMng.getUserDataMng().getOwnerUserData().getCardCollection();
               if(DictionaryUtils.checkIfDeckSizeCorrect(_loc4_,_loc5_))
               {
                  return _loc2_;
               }
               _loc2_++;
            }
         }
         return _loc1_;
      }
      
      public function isPlayerEligibleToSeeDeckSelector() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc1_ = true;
         _loc2_ = Config.getConfig().mapGetDeckSelectorDisplayAtLevel();
         _loc3_ = this.getCurrentLevelIndex(UserDataMng.DIFFICULTY_EASY);
         return _loc3_ >= _loc2_;
      }
      
      public function getCurrencyAmount(param1:String) : int
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         if(param1 != ServerConnection.CURRENCY_REAL)
         {
            switch(param1)
            {
               case ServerConnection.CURRENCY_GOLD:
                  return this.getGold();
               case ServerConnection.CURRENCY_QUEST_COINS:
                  return this.getQuestsCoins();
               case ServerConnection.CURRENCY_RAID_COINS:
                  return this.getRaidCoins();
            }
         }
         return _loc2_;
      }
      
      public function hasEnoughCurrency(param1:String, param2:int) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         _loc3_ = this.getCurrencyAmount(param1);
         return param1 == ServerConnection.CURRENCY_REAL || _loc3_ >= param2;
      }
      
      public function setCustomOfferShown(param1:String) : void
      {
         if(param1)
         {
            this.mCustomOfferShown = param1;
            this.mCustomOfferShownArr = Boolean(this.mCustomOfferShown) && this.mCustomOfferShown != "" ? this.mCustomOfferShown.split(":") : null;
         }
      }
      
      public function resetCustomOfferStuff() : void
      {
         this.mCustomOfferShown = "";
         this.mCustomOfferNewBannerShown = false;
         this.mCustomOfferNextVisibleDateMS = 0;
         DictionaryUtils.clearDictionary(this.mCustomOffersPurchased);
         this.mCustomOffersPurchased = null;
         DictionaryUtils.clearDictionary(this.mCustomOffersViewsCount);
         this.mCustomOffersViewsCount = null;
         this.mCustomOfferShownArr = null;
      }
      
      public function setCustomOffersViewsCount(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         if(param1 != null && param1 != "")
         {
            _loc2_ = param1.split(",");
            if(Boolean(_loc2_) && _loc2_.length > 0)
            {
               _loc6_ = 0;
               while(_loc6_ < _loc2_.length)
               {
                  _loc5_ = String(_loc2_[_loc6_]).split(":");
                  _loc3_ = _loc5_[0];
                  _loc4_ = int(_loc5_[1]);
                  if(this.mCustomOffersViewsCount == null)
                  {
                     this.mCustomOffersViewsCount = new Dictionary(true);
                  }
                  this.mCustomOffersViewsCount[_loc3_] = _loc4_;
                  _loc6_++;
               }
            }
         }
      }
      
      public function addCustomOfferView(param1:String) : void
      {
         if(this.mCustomOffersViewsCount == null)
         {
            this.mCustomOffersViewsCount = new Dictionary(true);
         }
         if(Boolean(this.mCustomOffersViewsCount[param1]) && this.mCustomOffersViewsCount[param1] > 0)
         {
            this.mCustomOffersViewsCount[param1] += 1;
         }
         else
         {
            this.mCustomOffersViewsCount[param1] = 1;
         }
      }
      
      public function setCustomOfferNextVisibleDateMS(param1:Number) : void
      {
         if(Boolean(param1) && !isNaN(param1))
         {
            this.mCustomOfferNextVisibleDateMS = param1;
         }
      }
      
      public function setCustomOfferNewBannerShown(param1:Boolean) : void
      {
         this.mCustomOfferNewBannerShown = param1;
      }
      
      public function setCustomOffersPurchased(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param1 != null && param1 != "")
         {
            _loc2_ = param1.split(",");
            if(Boolean(_loc2_) && _loc2_.length > 0)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc2_.length)
               {
                  _loc3_ = _loc2_[_loc5_];
                  if(this.mCustomOffersPurchased == null)
                  {
                     this.mCustomOffersPurchased = new Dictionary(true);
                  }
                  this.mCustomOffersPurchased[_loc3_] = 1;
                  _loc5_++;
               }
            }
         }
      }
      
      public function addCustomOfferPurchased(param1:String) : void
      {
         if(this.mCustomOffersPurchased == null)
         {
            this.mCustomOffersPurchased = new Dictionary(true);
         }
         this.mCustomOffersPurchased[param1] = 1;
      }
      
      public function getCustomOfferShown() : String
      {
         return this.mCustomOfferShown;
      }
      
      public function getCustomOfferShownSku() : String
      {
         return Boolean(this.mCustomOfferShownArr) && this.mCustomOfferShownArr.length > 0 ? String(this.mCustomOfferShown.split(":")[0]) : "";
      }
      
      public function getCustomOfferShownExpirationDate() : Number
      {
         return Boolean(this.mCustomOfferShownArr) && this.mCustomOfferShownArr.length > 0 ? Number(this.mCustomOfferShown.split(":")[1]) : 0;
      }
      
      public function getCustomOfferNextVisibleDateMS() : Number
      {
         return this.mCustomOfferNextVisibleDateMS;
      }
      
      public function getCustomOfferNewBannerShown() : Boolean
      {
         return this.mCustomOfferNewBannerShown;
      }
      
      public function getCustomOffersPurchased() : Dictionary
      {
         return this.mCustomOffersPurchased;
      }
      
      public function isCustomOfferPurchased(param1:String) : Boolean
      {
         return param1 && param1 != "" && Boolean(this.mCustomOffersPurchased) && this.mCustomOffersPurchased[param1] == 1;
      }
      
      public function getCustomOfferViewsCountBySku(param1:String) : int
      {
         return Boolean(param1 && param1 != "") && Boolean(this.mCustomOffersViewsCount) && Boolean(this.mCustomOffersViewsCount[param1]) ? int(this.mCustomOffersViewsCount[param1]) : 0;
      }
      
      public function getCustomOffersViewsCountToString() : String
      {
         return this.getDictionaryAttributeToString(this.mCustomOffersViewsCount,true);
      }
      
      public function getCustomOffersPurchasedToString() : String
      {
         return this.getDictionaryAttributeToString(this.mCustomOffersPurchased);
      }
      
      public function hasAnyCustomOfferActive() : Boolean
      {
         var _loc1_:Number = NaN;
         var _loc2_:Boolean = false;
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         _loc1_ = this.getCustomOfferShownExpirationDate();
         _loc2_ = !isNaN(_loc1_) && _loc1_ > ServerConnection.smServerTimeMS;
         _loc3_ = this.getCustomOfferShownSku();
         _loc4_ = _loc3_ == null || _loc3_ == "" || !this.isCustomOfferPurchased(_loc3_);
         return (_loc4_) && _loc3_ && _loc3_ != "" && _loc2_;
      }
      
      public function getCardAmount(param1:String) : int
      {
         return this.mCardCollection ? int(this.mCardCollection[param1]) : 0;
      }
      
      public function destroy() : void
      {
         DictionaryUtils.clearDictionary(this.mCardCollection);
         this.mCardCollection = null;
         DictionaryUtils.clearDictionary(this.mNewCardsCollection);
         this.mNewCardsCollection = null;
         DictionaryUtils.clearDictionary(this.mFavouritesCollection);
         this.mFavouritesCollection = null;
         DictionaryUtils.clearDictionary(this.mFlags);
         this.mFlags = null;
         DictionaryUtils.clearDictionary(this.mTutorialsSeen);
         this.mTutorialsSeen = null;
         DictionaryUtils.clearDictionary(this.mLevelsFailedInfo);
         this.mLevelsFailedInfo = null;
         DictionaryUtils.clearDictionary(this.mLevelsFailedFirebase);
         this.mLevelsFailedFirebase = null;
         DictionaryUtils.clearDictionary(this.mBoostsCatalog);
         this.mBoostsCatalog = null;
         DictionaryUtils.clearDictionary(this.mDeckNames);
         this.mDeckNames = null;
         DictionaryUtils.clearDictionary(this.mPreBoostsCatalog);
         this.mPreBoostsCatalog = null;
         DictionaryUtils.clearDictionary(this.mComicsRead);
         this.mComicsRead = null;
         DictionaryUtils.clearDictionary(this.mAvailableSkins);
         this.mAvailableSkins = null;
         DictionaryUtils.clearDictionary(this.mTopScoresCatalog);
         this.mTopScoresCatalog = null;
         DictionaryUtils.clearDictionary(this.mBadgesCollection);
         this.mBadgesCollection = null;
         DictionaryUtils.clearDictionary(this.mBadgesRewardsClaimed);
         this.mBadgesRewardsClaimed = null;
         DictionaryUtils.clearDictionary(this.mStarsRewardsClaimed);
         this.mStarsRewardsClaimed = null;
         DictionaryUtils.clearDictionary(this.mQuestsCompleted);
         this.mQuestsCompleted = null;
         DictionaryUtils.clearDictionary(this.mQuestsClaimed);
         this.mQuestsClaimed = null;
         DictionaryUtils.clearDictionary(this.mQuestsProgress);
         this.mQuestsProgress = null;
         DictionaryUtils.clearDictionary(this.mQuestsNotifiedAsCompleted);
         this.mQuestsNotifiedAsCompleted = null;
         DictionaryUtils.clearDictionary(this.mAvailableJobs);
         this.mAvailableJobs = null;
         DictionaryUtils.clearDictionary(this.mCustomOffersViewsCount);
         this.mCustomOffersViewsCount = null;
         DictionaryUtils.clearDictionary(this.mCustomOffersPurchased);
         this.mCustomOffersPurchased = null;
         DictionaryUtils.clearDictionary(this.mMapWorldChoices);
         this.mMapWorldChoices = null;
         DictionaryUtils.clearDictionary(this.mDecks);
         this.mDecks = null;
         Utils.destroyArray(this.mDecksArr);
         this.mDecksArr = null;
         Utils.destroyArray(this.mCardCollectionArr);
         this.mCardCollectionArr = null;
         Utils.destroyArray(this.mNewCardsCollectionArr);
         this.mNewCardsCollectionArr = null;
         Utils.destroyArray(this.mFavouritesCollectionArr);
         this.mFavouritesCollectionArr = null;
         Utils.destroyArray(this.mAuctionIdCreatedArr);
         this.mAuctionIdCreatedArr = null;
         Utils.destroyArray(this.mAuctionIdBiddedArr);
         this.mAuctionIdBiddedArr = null;
         Utils.destroyArray(this.mNotificationsReceived);
         this.mNotificationsReceived = null;
         Utils.destroyArray(this.mCustomOfferShownArr);
         this.mCustomOfferShownArr = null;
         Utils.destroyArray(this.mRaidsUnlockedArray);
         this.mRaidsUnlockedArray = null;
         Utils.destroyArray(this.mUniquePacksArr);
         this.mUniquePacksArr = null;
         Utils.destroyArray(this.mJobsExperience);
         this.mJobsExperience = null;
         Utils.destroyArray(this.mPlatformVersions);
         this.mPlatformVersions = null;
         Utils.destroyArray(this.mDeckJobConfigurationArr);
         this.mDeckJobConfigurationArr = null;
         Utils.destroyObject(this.mGold);
         this.mGold = null;
         Utils.destroyObject(this.mQuestsCoins);
         this.mQuestsCoins = null;
         Utils.destroyObject(this.mRaidCoins);
         this.mRaidCoins = null;
         Utils.destroyObject(this.mRaidTicketsSP);
         this.mRaidTicketsSP = null;
         Utils.destroyObject(this.mRaidTicketsMP);
         this.mRaidTicketsMP = null;
         Utils.destroyObject(this.mAuctionTickets);
         this.mAuctionTickets = null;
         Utils.destroyObject(this.mGuildWeeklyPvPScore);
         this.mGuildWeeklyPvPScore = null;
         Utils.destroyObject(this.mGuildWeeklyDungeonsScore);
         this.mGuildWeeklyDungeonsScore = null;
         Utils.destroyObject(this.mGuildWeeklyRaidsScore);
         this.mGuildWeeklyRaidsScore = null;
         Utils.destroyObject(this.mGuildWeeklyTotalScore);
         this.mGuildWeeklyTotalScore = null;
         Utils.destroyObject(this.mGuildGlobalPvPScore);
         this.mGuildGlobalPvPScore = null;
         Utils.destroyObject(this.mGuildGlobalDungeonsScore);
         this.mGuildGlobalDungeonsScore = null;
         Utils.destroyObject(this.mGuildGlobalRaidsScore);
         this.mGuildGlobalRaidsScore = null;
         Utils.destroyObject(this.mGuildGlobalTotalScore);
         this.mGuildGlobalTotalScore = null;
         Utils.destroyObject(this.mGuildLastWeekTotalScore);
         this.mGuildLastWeekTotalScore = null;
         this.mExtraLivesBoostDef = null;
         if(this.mPhoto)
         {
            this.mPhoto.dispose();
         }
         this.mPhoto = null;
         this.mPostBoost = null;
      }
      
      public function isBattlePassUnlocked() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:Boolean = false;
         _loc1_ = this.getCurrentLevelIndex(UserDataMng.DIFFICULTY_EASY);
         return _loc1_ >= Config.getConfig().getUnlockBattlePassLevel();
      }
      
      public function increaseLevelAttempts() : void
      {
         ++this.mLevelAttempts;
      }
      
      public function setLevelAttempts(param1:int) : void
      {
         this.mLevelAttempts = param1;
      }
      
      public function getLevelAttempts() : Number
      {
         return this.mLevelAttempts;
      }
      
      public function setFirstFirebaseDBTrack(param1:Number) : void
      {
         this.mFirstFirebaseDBTrack = param1;
      }
      
      public function getFirstFirebaseDBTrack() : Number
      {
         return this.mFirstFirebaseDBTrack;
      }
   }
}

