package com.fs.tcgengine.model.userdata
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.FSFacebookPlugin;
   import com.fs.tcgengine.controller.PvPConnectionMng;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.controller.rules.PacksDefMng;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.model.rules.BundleDef;
   import com.fs.tcgengine.model.rules.DailyRewardDef;
   import com.fs.tcgengine.model.rules.JobDef;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.model.rules.PvPBotDeckDef;
   import com.fs.tcgengine.model.rules.QuestDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSMapScreen;
   import com.fs.tcgengine.screens.FSMenuScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.TimerUtil;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.popups.misc.NotificationMessage;
   import com.fs.tcgengine.view.components.popups.player.PlayerPortrait;
   import com.fs.tcgengine.view.components.shop.FSShopItem;
   import com.fs.tcgengine.view.popups.Popup;
   import com.fs.tcgengine.view.popups.levels.FSPopupPlayLevel;
   import com.fs.tcgengine.view.popups.quests.PopupBattlePass;
   import com.gamesparks.api.types.Player;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import starling.events.Event;
   
   public class UserDataMng implements FSModelUnloadableInterface
   {
      
      public static const FRIEND_PLAYING:int = 0;
      
      public static const FRIEND_NOT_PLAYING:int = 1;
      
      public static const EXT_PLATFORM_FB:int = 0;
      
      public static const EXT_PLATFORM_KONGREGATE:int = 1;
      
      public static const EXT_PLATFORM_STEAM:int = 2;
      
      public static const EXT_PLATFORM_APPLE_SIGN_IN:int = 3;
      
      public static const DATABASE_TABLES_AMOUNT:int = 4;
      
      public static const RESET_HOUR:int = 9;
      
      public static const DIFFICULTY_EASY:int = 0;
      
      public static const DIFFICULTY_MEDIUM:int = 1;
      
      public static const DIFFICULTY_HARD:int = 2;
      
      public static const WEEK_DAY_WEDNESDAY:int = 3;
      
      public static var smRatePopupShownThisSession:Boolean = false;
      
      protected var mOwnerUserData:UserData;
      
      protected var mOpponentUserData:UserData;
      
      private var mOldLivesAmount:int;
      
      private var mTimeLeftToGainLife:Number;
      
      private var mFriendsList:Vector.<UserData>;
      
      private var mFriendsListLevelsCatalog:Dictionary;
      
      private var mFriendsListNotPlaying:Vector.<UserData>;
      
      private var mPotentialFriendsToSendLivesCatalog:Dictionary;
      
      private var mSocialPopupShown:Boolean = false;
      
      private var mServerTimeMS:Number = -1;
      
      private var mUnlockNextMapTimeLeft:Number = 0;
      
      private var mTimeAmountBetweenServerAndClientTime:Number;
      
      private var mLastTimeVIPOfferSeenMS:Number = -1;
      
      private var mMutedPlayersIds:Vector.<String>;
      
      private var mFriendsRequested:Boolean = false;
      
      public function UserDataMng()
      {
         super();
         this.load();
      }
      
      private static function createSQLCreationText(param1:String) : String
      {
         var _loc7_:int = 0;
         var _loc2_:String = "CREATE TABLE IF NOT EXISTS " + param1 + "(";
         var _loc3_:String = ");";
         var _loc4_:String = "";
         var _loc5_:String = "";
         var _loc6_:Vector.<String> = getColsVector(param1);
         _loc7_ = 0;
         while(_loc7_ < _loc6_.length)
         {
            _loc5_ = _loc6_[_loc7_];
            _loc4_ = _loc7_ == 0 ? "" : ",";
            _loc2_ += _loc4_ + _loc5_ + " TEXT";
            _loc7_++;
         }
         return _loc2_ + _loc3_;
      }
      
      public static function createSQLInsertionText(param1:String) : String
      {
         var _loc7_:int = 0;
         var _loc2_:String = "INSERT INTO " + param1 + " VALUES (";
         var _loc3_:String = ");";
         var _loc4_:String = "";
         var _loc5_:String = "";
         var _loc6_:Vector.<String> = getColsVector(param1);
         _loc7_ = 0;
         while(_loc7_ < _loc6_.length)
         {
            _loc5_ = _loc6_[_loc7_];
            _loc4_ = _loc7_ == 0 ? "" : ",";
            _loc2_ += _loc4_ + "\'\'";
            _loc7_++;
         }
         return _loc2_ + _loc3_;
      }
      
      private static function getColsVector(param1:String) : Vector.<String>
      {
         var _loc2_:Vector.<String> = new Vector.<String>();
         switch(param1)
         {
            case "main":
               _loc2_.push("accountId");
               _loc2_.push("auctionIdBiddedArr");
               _loc2_.push("auctionIdCreatedArr");
               _loc2_.push("auctionTickets");
               _loc2_.push("availableJobs");
               _loc2_.push("availablePortraits");
               _loc2_.push("availableSkins");
               _loc2_.push("badgesCollection");
               _loc2_.push("badgesRewardsClaimed");
               _loc2_.push("battlePass");
               _loc2_.push("boosts");
               _loc2_.push("botsPlayedSession");
               if(Config.getConfig().gameHasBuildingBadges())
               {
                  _loc2_.push("cityName");
               }
               _loc2_.push("collection");
               _loc2_.push("comicsRead");
               _loc2_.push("currentDateMS");
               _loc2_.push("currentDifficulty");
               _loc2_.push("currentLevelHardSku");
               _loc2_.push("currentLevelMediumSku");
               _loc2_.push("currentLevelSku");
               _loc2_.push("currentPortraitSku");
               _loc2_.push("currentSkinSku");
               _loc2_.push("customOfferNewBannerShown");
               _loc2_.push("customOfferNextVisibleDateMS");
               _loc2_.push("customOfferShown");
               _loc2_.push("customOffersPurchased");
               _loc2_.push("customOffersViewsCount");
               _loc2_.push("dailyKeyTime");
               _loc2_.push("dailyRewardTimeMS");
               _loc2_.push("deck_00");
               _loc2_.push("deck_01");
               _loc2_.push("deck_02");
               _loc2_.push("deck_03");
               _loc2_.push("deck_04");
               _loc2_.push("deck_05");
               _loc2_.push("deck_06");
               _loc2_.push("deck_07");
               _loc2_.push("deck_08");
               _loc2_.push("deck_09");
               _loc2_.push("deckJobConfigurator");
               _loc2_.push("deckNames");
               _loc2_.push("decksPurchasedAmount");
               _loc2_.push("dungeonsLost");
               _loc2_.push("dungeonsPlayed");
               _loc2_.push("dungeonsSeason");
               _loc2_.push("dungeonsWon");
               _loc2_.push("elo");
               _loc2_.push("exp");
               _loc2_.push("extId");
               _loc2_.push("favouriteCardsCollection");
               _loc2_.push("finishedLastCampaignTimeMs");
               _loc2_.push("firstFirebaseDBTrack");
               _loc2_.push("flags");
               _loc2_.push("gold");
               _loc2_.push("guildId");
               _loc2_.push("guildMemberId");
               _loc2_.push("highestMapUnlockedIndex");
               _loc2_.push("isBlackListed");
               _loc2_.push("isDuplicated");
               _loc2_.push("jobsExperience");
               _loc2_.push("languageLocale");
               _loc2_.push("lastDailyRewardClaimedIndex");
               _loc2_.push("oldPlayerComingBackLastDailyRewardClaimedIndex");
               _loc2_.push("levelsFailedInfo");
               _loc2_.push("levelAttempts");
               _loc2_.push("mapWorldChoices");
               _loc2_.push("matchesLost");
               _loc2_.push("matchesPlayed");
               _loc2_.push("matchesWon");
               _loc2_.push("monthNumber");
               _loc2_.push("newCardsCollection");
               _loc2_.push("oldPlayerComingBackDailyRewardTimeMS");
               _loc2_.push("platformVersions");
               _loc2_.push("playerName");
               _loc2_.push("pvpSeason");
               _loc2_.push("pvpCurrentLeague");
               _loc2_.push("pvpBestLeague");
               _loc2_.push("questsClaimed");
               _loc2_.push("questsCoins");
               _loc2_.push("questsCompleted");
               _loc2_.push("questsNotifiedAsCompleted");
               _loc2_.push("questsProgress");
               _loc2_.push("raidCoins");
               _loc2_.push("raidsUnlocked");
               _loc2_.push("raidTicketsMultiPlayer");
               _loc2_.push("raidTicketsSinglePlayer");
               _loc2_.push("selectedDeckIndex");
               _loc2_.push("selectedDeckIndexPvP");
               _loc2_.push("starsRewardsClaimed");
               _loc2_.push("tutorialsSeen");
               _loc2_.push("uniquePacksArr");
               _loc2_.push("weekNumber");
               break;
            case "levelsScore":
               _loc2_.push("difficulty");
               _loc2_.push("score");
               _loc2_.push("sku");
               _loc2_.push("timeStamp");
               break;
            case "livesRequested":
               _loc2_.push("extId");
               _loc2_.push("timeStamp");
               break;
            case "livesSent":
               _loc2_.push("extId");
               _loc2_.push("timeStamp");
         }
         _loc2_.sort(DictionaryUtils.sortAlphabetically);
         return _loc2_;
      }
      
      public static function getSQLStatement(param1:String) : String
      {
         return createSQLCreationText(param1);
      }
      
      public static function getSQLDefaultInsertStatement(param1:String) : String
      {
         return createSQLInsertionText(param1);
      }
      
      public static function isBasicDeck(param1:int) : Boolean
      {
         var _loc2_:Boolean = false;
         if(param1 >= Config.getConfig().getMaxDecksAmount())
         {
            _loc2_ = true;
         }
         return _loc2_;
      }
      
      protected function load() : void
      {
      }
      
      public function getOwnerUserData() : UserData
      {
         return this.mOwnerUserData;
      }
      
      public function getOpponentUserData(param1:Boolean = false) : UserData
      {
         if(!param1)
         {
            if(this.mOpponentUserData == null)
            {
               this.flushOwnerUserDataIntoOpponentUserData();
            }
         }
         else
         {
            this.mOpponentUserData = PvPConnectionMng.smOpponentUserData != null ? PvPConnectionMng.smOpponentUserData : null;
            if(PvPConnectionMng.smPlayingAgainstOfflineDeck && this.mOpponentUserData == null)
            {
               this.flushOwnerUserDataIntoOpponentUserData();
            }
         }
         return this.mOpponentUserData;
      }
      
      protected function initDatabase() : void
      {
      }
      
      public function getCurrentDBProfile() : Array
      {
         return null;
      }
      
      public function persistenceSaveData(param1:Boolean = false, param2:Function = null) : void
      {
         var _loc3_:Object = null;
         if(!param1)
         {
            this.initDatabase();
            if(this.mOwnerUserData)
            {
               _loc3_ = this.mOwnerUserData.persistenceBuildData();
               this.updateAllFieldsInARow(_loc3_);
            }
         }
      }
      
      private function createSQLUpdateText(param1:Object) : String
      {
         var _loc7_:int = 0;
         var _loc2_:String = "UPDATE main SET ";
         var _loc3_:String = "";
         var _loc4_:String = "";
         var _loc5_:String = "";
         var _loc6_:Array = DictionaryUtils.getKeys(param1);
         _loc7_ = 0;
         while(_loc7_ < _loc6_.length)
         {
            _loc4_ = _loc6_[_loc7_];
            _loc5_ = "\'" + param1[_loc4_] + "\'";
            _loc3_ = _loc7_ == 0 ? "" : ",";
            _loc2_ += _loc3_ + _loc4_ + "=" + _loc5_;
            _loc7_++;
         }
         return _loc2_;
      }
      
      protected function updateAllFieldsInARow(param1:Object = null) : void
      {
         var _loc2_:String = this.createSQLUpdateText(param1);
         var _loc3_:Array = DictionaryUtils.getKeys(param1);
         var _loc4_:Vector.<String> = Vector.<String>(_loc3_);
         this.performSQLStatementExecute("main",_loc4_,_loc2_);
      }
      
      public function isOfflineDBReady() : Boolean
      {
         return false;
      }
      
      protected function performSQLStatementExecute(param1:String, param2:Vector.<String>, param3:String) : void
      {
      }
      
      public function checkIfTableExists(param1:String, param2:Vector.<String>) : void
      {
      }
      
      protected function dbUpdateField(param1:String, param2:String, param3:String) : void
      {
         this.initDatabase();
         var _loc4_:String = "UPDATE " + param1 + " SET " + param2 + "=\'" + param3 + "\'";
         var _loc5_:Vector.<String> = new Vector.<String>();
         _loc5_.push(param2);
         this.performSQLStatementExecute(param1,_loc5_,_loc4_);
      }
      
      public function updatePlatformVersions(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","platformVersions",param1.platformVersions);
      }
      
      public function updateJobsExperience(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","jobsExperience",param1.jobsExperience);
      }
      
      public function updateDeckJobConfigurator(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","deckJobConfigurator",param1.deckJobConfigurator);
      }
      
      public function updatePlayerAccId(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","accountId",param1.accountId);
      }
      
      public function updatePlayerExtId(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","extId",param1.extId);
      }
      
      public function updatePlayerName(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","playerName",param1.playerName);
      }
      
      public function updateCityName(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","cityName",param1.cityName);
      }
      
      public function updateDate() : void
      {
      }
      
      public function updateCurrentDifficulty(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","currentDifficulty",param1.currentDifficulty);
      }
      
      public function updateMapWorldChoices(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","mapWorldChoices",param1.mapWorldChoices);
      }
      
      public function updateCurrentLevelSku(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","currentLevelSku",param1.currentLevelSku);
      }
      
      public function updateCurrentLevelMediumSku(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","currentLevelMediumSku",param1.currentLevelMediumSku);
      }
      
      public function updateCurrentLevelHardSku(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","currentLevelHardSku",param1.currentLevelHardSku);
      }
      
      public function updateGold(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","gold",param1.gold);
      }
      
      public function updateQuestsCoins(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","questsCoins",param1.questsCoins);
      }
      
      public function updateExp(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","exp",param1.exp);
      }
      
      public function updateBattlePass(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","battlePass",param1.battlePass);
      }
      
      public function updateCollection(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","collection",param1.collection);
      }
      
      public function updateBadgesCollection(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","badgesCollection",param1.badgesCollection);
      }
      
      public function updateAuctionIdCreatedArr(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","auctionIdCreatedArr",param1.auctionIdCreatedArr);
      }
      
      public function updateAuctionIdBiddedArr(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","auctionIdBIddedArr",param1.auctionIdBIddedArr);
      }
      
      public function updateNewCardsCollection(param1:Object = null) : void
      {
      }
      
      public function updateFavouriteCardsCollection(param1:Object = null) : void
      {
      }
      
      public function updateDeckConfigs(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","deck_00",param1.deck_00);
         this.dbUpdateField("main","deck_01",param1.deck_01);
         this.dbUpdateField("main","deck_02",param1.deck_02);
         this.dbUpdateField("main","deck_03",param1.deck_03);
         this.dbUpdateField("main","deck_04",param1.deck_04);
         this.dbUpdateField("main","deck_05",param1.deck_05);
         this.dbUpdateField("main","deck_06",param1.deck_06);
         this.dbUpdateField("main","deck_07",param1.deck_07);
         this.dbUpdateField("main","deck_08",param1.deck_08);
         this.dbUpdateField("main","deck_09",param1.deck_09);
      }
      
      public function updateSelectedDeckIndex(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","selectedDeckIndex",param1.selectedDeckIndex);
      }
      
      public function updateSelectedDeckIndexPvP(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","selectedDeckIndexPvP",param1.selectedDeckIndexPvP);
      }
      
      public function updateDeckNames(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","deckNames",param1.deckNames);
      }
      
      public function updateFlags(param1:Object = null) : void
      {
         if(param1 == null && Boolean(this.mOwnerUserData))
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","flags",param1.flags);
      }
      
      public function updateTutorialsSeen(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","tutorialsSeen",param1.tutorialsSeen);
      }
      
      public function updateLevelsFailedInfo(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","levelsFailedInfo",param1.levelsFailedInfo);
      }
      
      public function updateLevelsFailedFirebase(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","levelsFailedFirebase",param1.levelsFailedFirebase);
      }
      
      public function updateBoosts(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","boosts",param1.boosts);
      }
      
      public function updateLives(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","lives",param1.lives);
      }
      
      public function updateLostLiveTimeMS(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","lostLiveTimeMS",param1.lostLiveTimeMS);
      }
      
      public function updateDecksPurchasedAmount(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","decksPurchasedAmount",param1.decksPurchasedAmount);
      }
      
      public function updateElo(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","elo",param1.elo);
      }
      
      public function updatePvPCurrentLeague(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","pvpCurrentLeague",param1.pvpCurrentLeague);
      }
      
      public function updatePvPBestLeague(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","pvpBestLeague",param1.pvpBestLeague);
      }
      
      public function updateMatchesLost(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","matchesLost",param1.matchesLost);
      }
      
      public function updateMatchesWon(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","matchesWon",param1.matchesWon);
      }
      
      public function updateDungeonsLost(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","dungeonsLost",param1.dungeonsLost);
      }
      
      public function updateDungeonsWon(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","dungeonsWon",param1.dungeonsWon);
      }
      
      public function updateDungeonsPlayed(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","dungeonsPlayed",param1.dungeonsPlayed);
      }
      
      public function updateDungeonsSeason(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","dungeonsSeason",param1.dungeonsSeason);
      }
      
      public function updatePvPSeason(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","pvpSeason",param1.pvpSeason);
      }
      
      public function updateMatchesPlayed(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","matchesPlayed",param1.matchesPlayed);
      }
      
      public function updateComicsRead(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","comicsRead",param1.comicsRead);
      }
      
      public function updateIsBlacklisted(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","isBlackListed",param1.isBlackListed);
      }
      
      public function updateIsDuplicated(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","isDuplicated",param1.isDuplicated);
      }
      
      public function updateBadgesRewardsClaimed(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","badgesRewardsClaimed",param1.badgesRewardsClaimed);
      }
      
      public function updateStarsRewardsClaimed(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","starsRewardsClaimed",param1.starsRewardsClaimed);
      }
      
      public function updateQuestsClaimed(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","questsClaimed",param1.questsClaimed);
      }
      
      public function updateQuestsCompleted(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","questsCompleted",param1.questsCompleted);
      }
      
      public function updateQuestsNotifiedAsCompleted(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","questsNotifiedAsCompleted",param1.questsNotifiedAsCompleted);
      }
      
      public function updateQuestsProgress(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","questsProgress",param1.questsProgress);
      }
      
      public function updateDailyKeyTime(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","dailyKeyTime",param1.dailyKeyTime);
      }
      
      public function updateWeekNumber(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","weekNumber",param1.weekNumber);
      }
      
      public function updateMonthNumber(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","monthNumber",param1.monthNumber);
      }
      
      public function updateCustomOfferShown(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","customOfferShown",param1.customOfferShown);
      }
      
      public function updateCustomOfferNextVisibleDateMS(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","customOfferNextVisibleDateMS",param1.customOfferNextVisibleDateMS);
      }
      
      public function updateCustomOfferNewBannerShown(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","customOfferNewBannerShown",param1.customOfferNewBannerShown);
      }
      
      public function updateCustomOfferViewsCount(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","customOffersViewsCount",param1.customOffersViewsCount);
      }
      
      public function updateCustomOffersPurchased(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","customOffersPurchased",param1.customOffersPurchased);
      }
      
      public function updateHighestMapUnlockedIndex(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","highestMapUnlockedIndex",param1.highestMapUnlockedIndex);
      }
      
      public function updateLevelCompleted(param1:String, param2:int, param3:String, param4:Number = -1, param5:int = 0) : void
      {
         this.initDatabase();
         var _loc6_:String = "INSERT INTO levelsScore (\'sku\',\'score\',\'timestamp\',\'difficulty\') VALUES (\'" + param1 + "\', \'" + param2 + "\', \'" + param3 + "\', " + param5 + ")";
         var _loc7_:Vector.<String> = new Vector.<String>();
         _loc7_.push("sku");
         _loc7_.push("score");
         _loc7_.push("timestamp");
         _loc7_.push("difficulty");
         this.performSQLStatementExecute("levelsScore",_loc7_,_loc6_);
      }
      
      protected function executeSQLStatement(param1:String) : void
      {
      }
      
      public function updateAvailableJobs(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","availableJobs",param1.availableJobs);
      }
      
      public function updateAvailableSkins(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","availableSkins",param1.availableSkins);
      }
      
      public function updateCurrentSkinSku(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","currentSkinSku",param1.currentSkinSku);
      }
      
      public function updateAvailablePortraits(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","availablePortraits",param1.availablePortraits);
      }
      
      public function updateCurrentPortraitSku(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","currentPortraitSku",param1.currentPortraitSku);
      }
      
      public function updateLifeSent(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Vector.<String> = null;
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         if(param1 != null && param1 != "")
         {
            _loc2_ = param1.split(",");
            if(_loc2_ != null && _loc2_.length > 0)
            {
               this.initDatabase();
               _loc3_ = new Vector.<String>();
               _loc3_.push("extId");
               _loc3_.push("timestamp");
               _loc4_ = ServerConnection.smServerTimeMS <= 0 ? TimerUtil.currentTimeMillis() : ServerConnection.smServerTimeMS;
               _loc6_ = 0;
               while(_loc6_ < _loc2_.length)
               {
                  _loc5_ = _loc2_[_loc6_];
                  if(_loc5_ != null && _loc5_ != "")
                  {
                     _loc7_ = "INSERT INTO livesSent (\'extId\',\'timestamp\') VALUES (\'" + _loc5_ + "\', \'" + _loc4_ + "\')";
                     this.performSQLStatementExecute("livesSent",_loc3_,_loc7_);
                  }
                  _loc6_++;
               }
            }
         }
      }
      
      public function updateFinishedLastCampaignTimestamp(param1:Object = null) : void
      {
      }
      
      public function updateDailyRewardTimeMS() : void
      {
      }
      
      public function updateLastDailyRewardClaimedIndex() : void
      {
      }
      
      public function updateOldPlayerComingBackDailyRewardTimeMS() : void
      {
      }
      
      public function updateOldPlayerComingBackLastDailyRewardClaimedIndex() : void
      {
      }
      
      public function updateLevelAttempts(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","levelAttempts",param1.levelAttempts);
      }
      
      public function updateFirstFirebaseDBTrack(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","firstFirebaseDBTrack",param1.firstFirebaseDBTrack);
      }
      
      public function updateLanguageLocale(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","languageLocale",param1.languageLocale);
      }
      
      public function updateAuctionTickets(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","auctionTickets",param1.auctionTickets);
      }
      
      public function updateRaidTicketsSinglePlayer(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","raidTicketsSinglePlayer",param1.raidTicketsSinglePlayer);
      }
      
      public function updateRaidTicketsMultiPlayer(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","raidTicketsMultiPlayer",param1.raidTicketsMultiPlayer);
      }
      
      public function updateRaidsUnlocked(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","raidsUnlocked",param1.raidsUnlocked);
      }
      
      public function updateUniquePacksArr(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","uniquePacksArr",param1.uniquePacksArr);
      }
      
      public function getExtIdsThatReceivedLives() : Dictionary
      {
         return null;
      }
      
      public function getExtIdsThatReceivedLivesRequests() : String
      {
         return "";
      }
      
      public function updateLifeRequested(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Vector.<String> = null;
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         if(param1 != null && param1 != "")
         {
            _loc2_ = param1.split(",");
            if(_loc2_ != null && _loc2_.length > 0)
            {
               this.initDatabase();
               _loc3_ = new Vector.<String>();
               _loc3_.push("extId");
               _loc3_.push("timestamp");
               _loc4_ = ServerConnection.smServerTimeMS <= 0 ? TimerUtil.currentTimeMillis() : ServerConnection.smServerTimeMS;
               _loc6_ = 0;
               while(_loc6_ < _loc2_.length)
               {
                  _loc5_ = _loc2_[_loc6_];
                  if(_loc5_ != null && _loc5_ != "")
                  {
                     _loc7_ = "INSERT INTO livesRequested (\'extId\',\'timestamp\') VALUES (\'" + _loc5_ + "\', \'" + _loc4_ + "\')";
                     this.performSQLStatementExecute("livesRequested",_loc3_,_loc7_);
                  }
                  _loc6_++;
               }
            }
         }
      }
      
      public function getTopScoreByLevelSku(param1:String, param2:Function, param3:int = 0) : int
      {
         return -1;
      }
      
      protected function getTopScoreByLevelSkuFromOfflineDB(param1:String, param2:Function, param3:int = 0) : int
      {
         return -1;
      }
      
      public function getFriendsTopScoreByLevelSku(param1:String, param2:Function, param3:Array, param4:Boolean = false) : void
      {
      }
      
      public function getFriendsLastLevelCompletedTimestamp(param1:Function, param2:Array) : void
      {
      }
      
      public function getFriendsELOCatalog() : Dictionary
      {
         return null;
      }
      
      public function getUpdatedCurrentLevelSku(param1:int, param2:Object = null) : String
      {
         return null;
      }
      
      public function isDeckBought(param1:int) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = Config.getConfig().getDefaultAvailableDecksAmount() + this.mOwnerUserData.getDecksPurchasedAmount();
         return param1 < _loc3_;
      }
      
      public function userPurchasedDeck(param1:int = -1, param2:Boolean = true) : void
      {
         var _loc4_:int = 0;
         var _loc3_:int = this.mOwnerUserData.getDecksPurchasedAmount();
         if(_loc3_ < Config.getConfig().getMaxDecksAmount() - Config.getConfig().getDefaultAvailableDecksAmount())
         {
            if(param1 != -1)
            {
               _loc4_ = param1 + 1 - Config.getConfig().getDefaultAvailableDecksAmount();
               if(_loc3_ < _loc4_)
               {
                  this.mOwnerUserData.setDecksPurchasedAmount(_loc4_);
               }
            }
            else
            {
               this.mOwnerUserData.setDecksPurchasedAmount(_loc3_ + 1);
            }
            if(param2)
            {
               Utils.setLogText(TextManager.getText("TID_DECKBUILDER_DECK_EXTRA"));
            }
            this.updateDecksPurchasedAmount();
         }
      }
      
      public function userPurchasedBoost(param1:String, param2:int) : void
      {
         this.mOwnerUserData.addBoostToCatalog(param1,param2);
         Utils.setLogText(TextManager.getText("TID_SHOP_BOOST_SUCCESS"),false,false,false);
         this.updateBoosts();
      }
      
      public function onEnterFrame(param1:Event) : void
      {
         this.manageLivesSystem();
      }
      
      public function manageMapUnlockSystem(param1:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc2_:Boolean = false;
         if(InstanceMng.getServerConnection().isUserLoggedIn() && this.mUnlockNextMapTimeLeft >= 0)
         {
            if(this.mServerTimeMS == -1 || this.mServerTimeMS == 0)
            {
               if(this.mServerTimeMS != 0)
               {
                  this.mServerTimeMS = 0;
                  InstanceMng.getServerConnection().getServerTime(this.updateServerTime);
               }
               return;
            }
            param1 = _loc2_ ? TimerUtil.minToMs(1440) : TimerUtil.minToMs(param1);
            _loc3_ = _loc2_ ? 1389804478000 : this.mOwnerUserData.getFinishedLastCampaignTimestamp();
            this.mUnlockNextMapTimeLeft = _loc3_ + param1 - (TimerUtil.currentTimeMillis() + this.mTimeAmountBetweenServerAndClientTime);
         }
      }
      
      private function updateServerTime(param1:Object) : void
      {
         var _loc2_:Object = null;
         if(param1 != null)
         {
            _loc2_ = Utils.parseJSONData(param1);
            this.mServerTimeMS = TimerUtil.convertServerUCTDateToDate(_loc2_.now).time;
            this.mTimeAmountBetweenServerAndClientTime = this.mServerTimeMS - TimerUtil.currentTimeMillis();
         }
      }
      
      private function manageLivesSystem() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         if(Config.smLivesSystemEnabled && Boolean(this.mOwnerUserData))
         {
            _loc1_ = this.mOwnerUserData.getLives();
            _loc2_ = this.getDefaultLives();
            if(_loc1_ != _loc2_)
            {
               _loc3_ = ServerConnection.smServerTimeMS == 0 || ServerConnection.smServerTimeMS == -1 ? TimerUtil.currentTimeMillis() : ServerConnection.smServerTimeMS;
               _loc4_ = this.mOwnerUserData.getLostLifeTimeMS();
               _loc5_ = TimerUtil.minToMs(Config.getConfig().getLifeRegenTime());
               this.mTimeLeftToGainLife = _loc5_ - (_loc3_ - _loc4_);
               _loc6_ = TimerUtil.msToMin(_loc3_ - _loc4_);
               if(_loc6_ > Config.getConfig().getLifeRegenTime())
               {
                  _loc7_ = Math.floor(_loc6_ / Config.getConfig().getLifeRegenTime());
                  if(_loc7_ > 0)
                  {
                     FSDebug.debugTrace("Adding " + _loc7_ + " lives due to the time between last life lost and now");
                     this.mOwnerUserData.playerGainLife(_loc7_);
                     if(this.mOwnerUserData.getLives() != _loc2_)
                     {
                        this.mOwnerUserData.setLostLifeTimeMS(_loc3_);
                        this.updateLostLiveTimeMS();
                     }
                  }
               }
            }
         }
      }
      
      public function getTimeLeftToGainLifeText() : String
      {
         return TimerUtil.getTimeTextFromMs(this.mTimeLeftToGainLife,null,null,":","",true,false);
      }
      
      public function getDefaultLives() : int
      {
         var _loc1_:int = Config.getConfig().getDefaultLives();
         return int(_loc1_ + this.mOwnerUserData.getExtraLifesGainedByBoost());
      }
      
      public function flushOwnerUserDataIntoOpponentUserData() : void
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc9_:PvPBotDeckDef = null;
         var _loc10_:Object = null;
         var _loc11_:String = null;
         var _loc12_:int = 0;
         var _loc13_:Array = null;
         var _loc14_:Dictionary = null;
         var _loc15_:Dictionary = null;
         var _loc16_:Dictionary = null;
         var _loc17_:int = 0;
         var _loc18_:String = null;
         var _loc19_:String = null;
         var _loc20_:Array = null;
         if(this.mOwnerUserData != null)
         {
            this.mOpponentUserData = new UserData();
         }
         var _loc1_:String = PvPConnectionMng.smPlayingAgainstBOT ? PvPConnectionMng.MATCH_BOT_UID : "-1";
         this.mOpponentUserData.setAccountId(_loc1_);
         var _loc2_:String = PvPConnectionMng.smPlayingAgainstBOT ? Utils.generateRandomUserName() : "Player 2";
         this.mOpponentUserData.setName(_loc2_);
         if(PvPConnectionMng.smPlayingAgainstBOT)
         {
            _loc10_ = PvPConnectionMng.smPvPBattleData;
            _loc11_ = (Boolean(_loc10_)) && Boolean(_loc10_.hasOwnProperty("decks")) && Boolean(_loc10_["decks"].hasOwnProperty("opponentInfo")) ? _loc10_["decks"]["opponentInfo"]["botSku"] : null;
            if(_loc11_ != null && _loc11_ != "")
            {
               _loc9_ = PvPBotDeckDef(InstanceMng.getPvPBotDecksDefMng().getDefBySku(_loc11_));
            }
            if(_loc9_ == null)
            {
               _loc12_ = this.mOwnerUserData.getDeckValue(this.mOwnerUserData.getSelectedDeckIndexPvP());
               _loc9_ = InstanceMng.getPvPBotDecksDefMng().getRandomPvPBotDeckDefsByDeckValue(_loc12_);
            }
            if(_loc9_)
            {
               _loc14_ = _loc9_.getIAUnits();
               _loc15_ = _loc9_.getIAAttachments();
               _loc16_ = _loc9_.getIAActions();
               _loc3_ = new Array();
               _loc13_ = DictionaryUtils.getKeys(_loc14_);
               if(_loc13_)
               {
                  _loc17_ = 0;
                  while(_loc17_ < _loc13_.length)
                  {
                     _loc3_.push(_loc13_[_loc17_] + ":" + _loc14_[_loc13_[_loc17_]]);
                     _loc17_++;
                  }
               }
               _loc13_ = DictionaryUtils.getKeys(_loc15_);
               if(_loc13_)
               {
                  _loc17_ = 0;
                  while(_loc17_ < _loc13_.length)
                  {
                     _loc3_.push(_loc13_[_loc17_] + ":" + _loc15_[_loc13_[_loc17_]]);
                     _loc17_++;
                  }
               }
               _loc13_ = DictionaryUtils.getKeys(_loc16_);
               if(_loc13_)
               {
                  _loc17_ = 0;
                  while(_loc17_ < _loc13_.length)
                  {
                     _loc3_.push(_loc13_[_loc17_] + ":" + _loc16_[_loc13_[_loc17_]]);
                     _loc17_++;
                  }
               }
               if(Config.getConfig().gameHasPowers() && PvPConnectionMng.smPlayingAgainstBOT)
               {
                  if(_loc9_.getIAPowerSku() != null && _loc9_.getIAPowerSku() != "")
                  {
                     _loc3_.push(_loc9_.getIAPowerSku());
                  }
               }
               this.mOpponentUserData.setCurrentPortraitSku(_loc9_.getIAPortraitSku());
               this.mOpponentUserData.setAvailablePortraits([_loc9_.getIAPortraitSku()]);
               _loc18_ = _loc9_.getIACurrentLevelSku() != "" ? _loc9_.getIACurrentLevelSku() : this.mOwnerUserData.getCurrentLevelSku();
               this.mOpponentUserData.setCurrentLevelSku(_loc18_);
               this.mOpponentUserData.setPvPCurrentLeague(this.mOwnerUserData.getPvPCurrentLeague());
               this.mOpponentUserData.setPvPBestLeague(this.mOwnerUserData.getPvPBestLeague());
               this.mOpponentUserData.setElo(_loc9_.getIAElo());
               if(Config.getConfig().hasSkins())
               {
                  this.mOpponentUserData.setCurrentSkinSku(_loc9_.getIASkinSku());
               }
               if(Config.getConfig().gameHasClassSystem())
               {
                  _loc19_ = _loc9_.getAIJobSku();
                  this.mOpponentUserData.setDeckJobConfiguratorArr(["0-" + _loc19_ + "-" + _loc9_.getIAPowerSku() + "-" + _loc9_.getIASkinSku()]);
               }
            }
            else
            {
               FSDebug.debugTrace("ERROR! Couldn\'t find any pvp bot deck!");
            }
         }
         else
         {
            _loc3_ = this.mOwnerUserData.getCardCollectionArr();
            this.mOpponentUserData.setCurrentPortraitSku(this.mOwnerUserData.getCurrentPortraitSku());
            this.mOpponentUserData.setAvailablePortraits(this.mOwnerUserData.getAvailablePortraitsToString().split(","));
            this.mOpponentUserData.setCurrentSkinSku(this.mOwnerUserData.getCurrentSkinSku());
            this.mOpponentUserData.setAvailableSkins(this.mOwnerUserData.getAvailableSkinsToString().split(","));
            this.mOpponentUserData.setCurrentLevelSku(this.mOwnerUserData.getCurrentLevelSku());
            this.mOpponentUserData.setJobsExperience(this.mOwnerUserData.getJobsExperience());
            this.mOpponentUserData.setDeckJobConfiguratorArr(this.mOwnerUserData.getDeckJobConfiguratorToString().split(","));
         }
         this.mOpponentUserData.setCardCollection(_loc3_);
         if(PvPConnectionMng.smPlayingAgainstBOT)
         {
            this.mOpponentUserData.setDeck(_loc3_,0);
            _loc4_ = this.mOpponentUserData.getTotalDeckArr();
         }
         else
         {
            _loc4_ = this.mOwnerUserData.getTotalDeckArr();
         }
         this.importAuxDecksToOpponentUserData(_loc4_);
         var _loc5_:String = this.mOwnerUserData.getDeckNamesToString();
         if(_loc5_ != null && _loc5_ != "")
         {
            _loc20_ = _loc5_.split(",");
            this.mOpponentUserData.setDeckNames(_loc20_);
         }
         var _loc6_:int = PvPConnectionMng.smPlayingAgainstBOT ? 0 : this.mOwnerUserData.getSelectedDeckIndex();
         if(_loc6_ != -1)
         {
            this.mOpponentUserData.setSelectedDeckIndex(_loc6_);
         }
         var _loc7_:int = PvPConnectionMng.smPlayingAgainstBOT ? 0 : this.mOwnerUserData.getSelectedDeckIndexPvP();
         if(_loc7_ != -1)
         {
            this.mOpponentUserData.setSelectedDeckIndexPvP(_loc7_);
         }
         var _loc8_:int = this.mOwnerUserData.getDecksPurchasedAmount();
         if(_loc8_ != -1)
         {
            this.mOpponentUserData.setDecksPurchasedAmount(_loc8_);
         }
         this.mOpponentUserData.setPhotoUrl(FSResourceMng.DEFAULT_PHOTO_AI_NAME);
         this.mOpponentUserData.setIsOwner(false);
      }
      
      public function resetOpponentUserData() : void
      {
         this.mOpponentUserData = null;
      }
      
      private function importAuxDecksToOpponentUserData(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         if(param1 != null)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               _loc3_ = param1[_loc2_];
               if(_loc3_ != null)
               {
                  this.mOpponentUserData.setDeck(param1[_loc2_],_loc2_);
               }
               _loc2_++;
            }
         }
      }
      
      public function fillFriendsList(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:UserData = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         if(param1 != null)
         {
            _loc6_ = InstanceMng.getApplication().isKongregateVersion() ? EXT_PLATFORM_KONGREGATE : EXT_PLATFORM_FB;
            for each(_loc2_ in param1)
            {
               if(_loc2_.hasOwnProperty("installed") && _loc2_.installed == true)
               {
                  if(this.mFriendsList == null)
                  {
                     this.mFriendsList = new Vector.<UserData>();
                  }
                  _loc3_ = this.getFriendUserDataByExtId(_loc2_.id,FRIEND_PLAYING);
                  if(_loc3_ == null)
                  {
                     _loc3_ = new UserData();
                     _loc7_ = _loc2_.id;
                     _loc3_.setExtId(_loc7_);
                     _loc3_.setExtPlatform(_loc6_);
                     _loc3_.setName(_loc2_.first_name);
                     _loc5_ = _loc7_ != "" && _loc7_ != null ? _loc7_ : "sample";
                     if(InstanceMng.getFacebookPlugin() != null && InstanceMng.getFacebookPlugin().isSessionOpen())
                     {
                        this.loadProfilePic(_loc3_,_loc5_);
                     }
                     this.mFriendsList.push(_loc3_);
                  }
                  if(_loc4_ == null)
                  {
                     _loc4_ = new Array();
                  }
                  _loc4_.push(_loc2_.id);
               }
               else
               {
                  if(this.mFriendsListNotPlaying == null)
                  {
                     this.mFriendsListNotPlaying = new Vector.<UserData>();
                  }
                  _loc3_ = this.getFriendUserDataByExtId(_loc2_.id,FRIEND_NOT_PLAYING);
                  if(_loc3_ == null)
                  {
                     _loc3_ = new UserData();
                     _loc3_.setExtId(_loc2_.id);
                     _loc6_ = InstanceMng.getApplication().isKongregateVersion() ? EXT_PLATFORM_KONGREGATE : EXT_PLATFORM_FB;
                     _loc3_.setExtPlatform(_loc6_);
                     _loc3_.setName(_loc2_.first_name);
                     if(_loc2_.picture != null)
                     {
                        _loc3_.setPhotoUrl(_loc2_.picture.data.url);
                     }
                     else
                     {
                        _loc5_ = _loc2_.id != "" && _loc2_.id != null ? _loc2_.id : "sample";
                        if(Boolean(InstanceMng.getFacebookPlugin()) && InstanceMng.getFacebookPlugin().isSessionOpen())
                        {
                           this.loadProfilePic(_loc3_,_loc5_);
                        }
                     }
                     this.mFriendsListNotPlaying.push(_loc3_);
                  }
               }
            }
         }
         if(this.mFriendsList != null && this.mFriendsList.length > 0)
         {
            if(_loc4_)
            {
               this.updateFriendsInfo(_loc4_);
            }
         }
         else if(this.mFriendsListNotPlaying != null && this.mFriendsListNotPlaying.length > 0)
         {
            this.checkOpenSocialPopups();
         }
      }
      
      private function loadProfilePic(param1:UserData, param2:String) : void
      {
         param1.setPhotoUrl(FSFacebookPlugin.FACEBOOK_GRAPH_PREFIX + param2 + PlayerPortrait.FACEBOOK_PIC_SUFFIX);
      }
      
      public function fillFriendsWhoPlayListGS(param1:Vector.<Player>, param2:Object = null) : void
      {
         var _loc3_:Player = null;
         var _loc4_:UserData = null;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         if(param1 != null)
         {
            this.purgeFriendsLevelsInfo();
            for each(_loc3_ in param1)
            {
               if(_loc3_)
               {
                  if(this.mFriendsList == null)
                  {
                     this.mFriendsList = new Vector.<UserData>();
                  }
                  _loc4_ = this.getFriendUserDataByExtId(_loc3_.getId(),FRIEND_PLAYING);
                  if(_loc4_ == null)
                  {
                     _loc4_ = InstanceMng.getServerConnection().getUserDataByUserProfile(_loc3_);
                     if(_loc4_)
                     {
                        _loc8_ = _loc3_.getScriptData()["profile"]["extId"];
                        _loc7_ = int(_loc3_.getScriptData()["profile"]["extPlatform"]);
                        _loc4_.setExtId(_loc8_);
                        _loc4_.setExtPlatform(_loc7_);
                        if(Boolean(param2) && param2[_loc3_.getId()] != null)
                        {
                           _loc4_.setMatchesWon(param2[_loc3_.getId()].matchesWon);
                        }
                        this.addFriendToLevelCatalog(_loc4_,InstanceMng.getLevelsDefMng().getLevelIndexByLevelSku(_loc4_.getCurrentLevelSku()),DIFFICULTY_EASY);
                        this.addFriendToLevelCatalog(_loc4_,InstanceMng.getLevelsDefMng().getLevelIndexByLevelSku(_loc4_.getCurrentLevelMediumSku()),DIFFICULTY_MEDIUM);
                        this.addFriendToLevelCatalog(_loc4_,InstanceMng.getLevelsDefMng().getLevelIndexByLevelSku(_loc4_.getCurrentLevelHardSku()),DIFFICULTY_HARD);
                        _loc6_ = _loc8_ != "" && _loc8_ != null ? _loc8_ : "sample";
                        if(InstanceMng.getFacebookPlugin() != null && InstanceMng.getFacebookPlugin().isSessionOpen())
                        {
                           this.loadProfilePic(_loc4_,_loc6_);
                        }
                        if(_loc4_.getAccountId() != "")
                        {
                           this.mFriendsList.push(_loc4_);
                        }
                     }
                  }
                  if(_loc5_ == null)
                  {
                     _loc5_ = new Array();
                  }
                  _loc5_.push(_loc3_.getId());
               }
            }
         }
         if(this.mFriendsList != null && this.mFriendsList.length > 0)
         {
            this.refreshSocialInfoAfterFriendsReceived();
         }
         else if(this.mFriendsListNotPlaying != null && this.mFriendsListNotPlaying.length > 0)
         {
            this.checkOpenSocialPopups();
         }
      }
      
      public function getFriendsNotPlayingVector() : Vector.<UserData>
      {
         return this.mFriendsListNotPlaying;
      }
      
      public function updateFriendsInfo(param1:Array = null) : void
      {
         var _loc3_:UserData = null;
         var _loc4_:int = 0;
         var _loc2_:Array = param1 != null ? param1 : null;
         if(this.mFriendsList != null && this.mFriendsList.length > 0 && _loc2_ == null)
         {
            _loc4_ = 0;
            while(_loc4_ < this.mFriendsList.length)
            {
               _loc3_ = this.mFriendsList[_loc4_];
               if(_loc3_ != null)
               {
                  if(_loc2_ == null)
                  {
                     _loc2_ = new Array();
                  }
                  _loc2_.push(_loc3_.getExtId());
               }
               _loc4_++;
            }
         }
      }
      
      public function checkOpenSocialPopups(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc14_:String = null;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         if(this.mOwnerUserData)
         {
            _loc14_ = this.mOwnerUserData.getCurrentLevelSku();
            if(_loc14_ != null && _loc14_ != "" && _loc14_ == "level_01")
            {
               return;
            }
         }
         var _loc4_:Screen = InstanceMng.getCurrentScreen();
         FSDebug.debugTrace("[checkOpenSocialPopups]");
         var _loc5_:Boolean = Boolean(_loc4_) && _loc4_ is FSMapScreen;
         var _loc6_:Boolean = (_loc5_) && FSMapScreen(_loc4_).isShowingComic();
         var _loc7_:Boolean = InstanceMng.getTutorialMapMng() == null || InstanceMng.getTutorialMapMng() != null && !InstanceMng.getTutorialMapMng().isTutorialON();
         var _loc8_:Boolean = InstanceMng.getApplication() ? InstanceMng.getApplication().isGamePlayable() && FSPopupMng.areScreenPopupsResourcesLoaded(Constants.MAP_SCREEN_NAME) : false;
         var _loc9_:Boolean = InstanceMng.getBattleEngine() != null && InstanceMng.getBattleEngine().isBattleOver();
         var _loc10_:Boolean = Boolean(InstanceMng.getApplication()) && !InstanceMng.getApplication().isGuildsPanelOpen();
         var _loc11_:Boolean = _loc5_ ? !FSMapScreen(InstanceMng.getCurrentScreen()).isMapUnlockedEffectActive() : false;
         var _loc12_:Boolean = this.isEligibleToVIPPack();
         var _loc13_:Boolean = _loc5_ ? !FSMapScreen(InstanceMng.getCurrentScreen()).checkIfhasToShowWorldChooser() : true;
         if(_loc5_ && _loc13_ && _loc8_ && !_loc6_ && !this.mSocialPopupShown && _loc11_ && !_loc9_ && _loc10_ && _loc7_)
         {
            _loc15_ = _loc12_ ? 5 : 6;
            _loc16_ = _loc12_ ? 2 : 3;
            if(this.mFriendsList != null && this.mFriendsList.length > 0)
            {
               _loc2_ = int(this.mFriendsList.length);
               _loc3_ = _loc2_ <= 5 ? _loc15_ : _loc16_;
               if(Utils.randomInt(0,9) < _loc3_)
               {
                  this.mSocialPopupShown = true;
               }
            }
            if(this.mFriendsListNotPlaying != null && this.mFriendsListNotPlaying.length > 0 && (!this.mSocialPopupShown || param1))
            {
               _loc2_ = int(this.mFriendsListNotPlaying.length);
               _loc3_ = _loc2_ <= 5 ? _loc15_ : _loc16_;
               if(param1 || Utils.randomInt(0,9) < _loc3_)
               {
                  this.mSocialPopupShown = true;
               }
            }
         }
      }
      
      public function updateLastTimeVIPOfferSeenMS() : void
      {
         this.mLastTimeVIPOfferSeenMS = ServerConnection.smServerTimeMS != -1 && ServerConnection.smServerTimeMS != 0 ? ServerConnection.smServerTimeMS : TimerUtil.currentTimeMillis();
      }
      
      public function isEligibleToVIPPack() : Boolean
      {
         var _loc1_:Boolean = false;
         if(this.mOwnerUserData == null)
         {
            return false;
         }
         var _loc2_:Boolean = this.mOwnerUserData.getCurrentMapIndex(UserDataMng.DIFFICULTY_EASY) >= 2;
         var _loc3_:Number = ServerConnection.smServerTimeMS != -1 && ServerConnection.smServerTimeMS != 0 ? ServerConnection.smServerTimeMS : TimerUtil.currentTimeMillis();
         var _loc4_:Boolean = this.mLastTimeVIPOfferSeenMS == -1;
         var _loc5_:Boolean = InstanceMng.getTutorialMapMng() ? !InstanceMng.getTutorialMapMng().isTutorialON() : true;
         var _loc6_:Boolean = InstanceMng.getCurrentScreen() != null && InstanceMng.getCurrentScreen() is FSMapScreen ? !FSMapScreen(InstanceMng.getCurrentScreen()).isMapUnlockedEffectActive() : false;
         var _loc7_:Boolean = InstanceMng.getCurrentScreen() != null && InstanceMng.getCurrentScreen() is FSMapScreen ? !FSMapScreen(InstanceMng.getCurrentScreen()).checkIfhasToShowWorldChooser() : true;
         return InstanceMng.getServerConnection().isUserLoggedIn() && !this.mOwnerUserData.isPayingUser() && !this.mOwnerUserData.isVIP() && _loc4_ && _loc2_ && _loc5_ && _loc6_ && _loc7_;
      }
      
      private function createFriendsToSendLivesToVector() : Vector.<Object>
      {
         var _loc1_:Vector.<Object> = null;
         var _loc2_:Object = null;
         var _loc3_:UserData = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Dictionary = null;
         var _loc8_:Dictionary = null;
         var _loc9_:Array = null;
         var _loc10_:String = null;
         var _loc11_:Array = null;
         var _loc12_:Array = null;
         if(_loc1_ == null)
         {
            _loc5_ = 0;
            _loc6_ = Config.getConfig().getMaxAmountFriendsSocialPopups();
            _loc1_ = new Vector.<Object>();
            _loc7_ = this.getExtIdsThatReceivedLives();
            _loc8_ = this.getPotentialFriendsToSendLives();
            if(_loc8_)
            {
               _loc9_ = DictionaryUtils.getKeys(_loc8_);
               if((Boolean(_loc9_)) && _loc9_.length > 0)
               {
                  _loc4_ = 0;
                  while(_loc4_ < _loc9_.length)
                  {
                     if(_loc5_ < _loc6_)
                     {
                        _loc10_ = _loc9_[_loc4_];
                        if(_loc7_ == null || _loc7_ != null && _loc7_[_loc10_] == null)
                        {
                           _loc3_ = this.getFriendUserDataByExtId(_loc10_);
                           if(_loc3_)
                           {
                              _loc5_++;
                              _loc2_ = new Object();
                              _loc2_.requestId = "-1";
                              _loc2_.type = NotificationMessage.NOTIFICATION_TYPE_SEND_LIFE;
                              _loc2_.extra = TextManager.replaceParameters(TextManager.getText("TID_GEN_STUCK_DAYS",true),[_loc8_[_loc10_]]);
                              _loc2_.senderName = _loc3_.getName();
                              _loc2_.senderFBId = _loc3_.getExtId();
                              _loc1_.push(_loc2_);
                           }
                        }
                     }
                     _loc4_++;
                  }
               }
            }
            if(_loc5_ < Config.getConfig().getMaxAmountFriendsSocialPopups())
            {
               _loc11_ = [];
               _loc12_ = Utils.vectorToArray(this.getFriends());
               if(_loc12_)
               {
                  while(_loc12_.length > 0)
                  {
                     _loc11_.push(_loc12_.splice(Math.round(Math.random() * (_loc12_.length - 1)),1)[0]);
                  }
                  if(_loc11_)
                  {
                     _loc4_ = 0;
                     while(_loc4_ < _loc11_.length)
                     {
                        if(_loc5_ < _loc6_)
                        {
                           _loc3_ = _loc11_[_loc4_];
                           if(_loc3_ != null && (_loc8_ == null || _loc8_ != null && _loc8_[_loc3_.getExtId()] == null))
                           {
                              if(_loc7_ == null || _loc7_ != null && _loc7_[_loc3_.getExtId()] == null)
                              {
                                 _loc5_++;
                                 _loc2_ = new Object();
                                 _loc2_.requestId = "-1";
                                 _loc2_.type = NotificationMessage.NOTIFICATION_TYPE_SEND_LIFE;
                                 _loc2_.senderName = _loc3_.getName();
                                 _loc2_.senderFBId = _loc3_.getExtId();
                                 _loc1_.push(_loc2_);
                              }
                           }
                        }
                        _loc4_++;
                     }
                  }
               }
            }
         }
         return _loc1_;
      }
      
      private function refreshSocialInfoAfterFriendsReceived() : void
      {
         var _loc1_:Popup = null;
         if(this.mFriendsListLevelsCatalog != null && InstanceMng.getCurrentScreen() is FSMapScreen)
         {
            FSMapScreen(InstanceMng.getCurrentScreen()).requestAllMapsProfilePictures();
            _loc1_ = InstanceMng.getPopupMng().getPopupShown();
            if(_loc1_ is FSPopupPlayLevel)
            {
               FSPopupPlayLevel(_loc1_).requestSocialBarInfo();
            }
         }
         if(!this.mSocialPopupShown)
         {
            if(InstanceMng.getApplication().mapScreenHasBeenVisited())
            {
               this.requestFriendsLastCompletedLevelTimestamp();
            }
         }
      }
      
      private function addFriendToLevelCatalog(param1:UserData, param2:int, param3:int) : void
      {
         var _loc4_:Vector.<UserData> = null;
         var _loc5_:UserData = null;
         var _loc6_:* = 0;
         var _loc7_:int = 0;
         var _loc8_:Boolean = false;
         if(this.mFriendsListLevelsCatalog == null)
         {
            this.mFriendsListLevelsCatalog = new Dictionary(true);
         }
         if(this.mFriendsListLevelsCatalog[param2 + "_" + param3] == null)
         {
            this.mFriendsListLevelsCatalog[param2 + "_" + param3] = new Vector.<UserData>();
            Vector.<UserData>(this.mFriendsListLevelsCatalog[param2 + "_" + param3]).push(param1);
         }
         else
         {
            _loc4_ = Vector.<UserData>(this.mFriendsListLevelsCatalog[param2 + "_" + param3]);
            if((Boolean(_loc4_)) && _loc4_.length > 0)
            {
               _loc8_ = false;
               _loc6_ = 0;
               while(_loc6_ < _loc4_.length)
               {
                  _loc5_ = UserData(_loc4_[_loc6_]);
                  if(_loc5_ != null && _loc5_.getExtId() == param1.getExtId())
                  {
                     _loc8_ = true;
                  }
                  _loc6_++;
               }
               if(!_loc8_)
               {
                  Vector.<UserData>(this.mFriendsListLevelsCatalog[param2 + "_" + param3]).push(param1);
               }
            }
         }
         if(param2 > 1)
         {
            _loc6_ = int(param2 - 1);
            while(_loc6_ > 0)
            {
               if(this.mFriendsListLevelsCatalog[_loc6_ + "_" + param3] != null)
               {
                  _loc4_ = Vector.<UserData>(this.mFriendsListLevelsCatalog[_loc6_ + "_" + param3]);
                  if((Boolean(_loc4_)) && _loc4_.length > 0)
                  {
                     _loc7_ = 0;
                     while(_loc7_ < _loc4_.length)
                     {
                        _loc5_ = UserData(_loc4_[_loc7_]);
                        if(_loc5_ != null && _loc5_.getAccountId() == param1.getAccountId())
                        {
                           Vector.<UserData>(this.mFriendsListLevelsCatalog[_loc6_ + "_" + param3]).splice(_loc7_,1);
                        }
                        _loc7_++;
                     }
                  }
               }
               _loc6_--;
            }
         }
      }
      
      public function getAllFriendsUserDataByLevel(param1:int) : Vector.<UserData>
      {
         var _loc3_:int = 0;
         var _loc2_:Vector.<UserData> = null;
         if(this.mOwnerUserData)
         {
            _loc3_ = this.mOwnerUserData.getCurrentDifficulty();
            if(this.mFriendsListLevelsCatalog != null)
            {
               _loc2_ = this.mFriendsListLevelsCatalog[param1 + "_" + _loc3_];
            }
         }
         return _loc2_;
      }
      
      public function getAllFriendsUserDataOnAnyLevel() : Vector.<UserData>
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Vector.<UserData> = null;
         var _loc1_:Vector.<UserData> = null;
         if(this.mFriendsListLevelsCatalog != null)
         {
            _loc2_ = DictionaryUtils.getKeys(this.mFriendsListLevelsCatalog);
            if(_loc2_)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc2_.length)
               {
                  _loc5_ = this.mFriendsListLevelsCatalog[_loc2_[_loc3_]];
                  if(_loc5_ != null)
                  {
                     _loc4_ = 0;
                     while(_loc4_ < _loc5_.length)
                     {
                        if(_loc1_ == null)
                        {
                           _loc1_ = new Vector.<UserData>();
                        }
                        _loc1_.push(_loc5_[_loc4_]);
                        _loc4_++;
                     }
                  }
                  _loc3_++;
               }
            }
         }
         return _loc1_;
      }
      
      public function getFriendUserDataByExtId(param1:String, param2:int = 0) : UserData
      {
         var _loc4_:UserData = null;
         var _loc3_:UserData = null;
         var _loc5_:int = 0;
         var _loc6_:Vector.<UserData> = param2 == FRIEND_PLAYING ? this.mFriendsList : this.mFriendsListNotPlaying;
         if(_loc6_ != null)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc6_.length)
            {
               _loc4_ = _loc6_[_loc5_];
               if(_loc4_ != null)
               {
                  if(_loc4_.getExtId() == param1)
                  {
                     return _loc4_;
                  }
               }
               _loc5_++;
            }
         }
         return _loc3_;
      }
      
      public function purgeFriendsLevelsInfo() : void
      {
         this.mFriendsListLevelsCatalog = null;
      }
      
      public function getFriendUserDataByAccId(param1:String) : UserData
      {
         var _loc3_:UserData = null;
         var _loc2_:UserData = null;
         var _loc4_:int = 0;
         if(this.mFriendsList != null)
         {
            _loc4_ = 0;
            while(_loc4_ < this.mFriendsList.length)
            {
               _loc3_ = this.mFriendsList[_loc4_];
               if(_loc3_ != null)
               {
                  if(_loc3_.getAccountId() == param1)
                  {
                     return _loc3_;
                  }
               }
               _loc4_++;
            }
         }
         return _loc2_;
      }
      
      public function updateFriendLevel(param1:String, param2:String, param3:int) : void
      {
         var _loc4_:UserData = null;
         var _loc5_:int = 0;
         if(this.mFriendsList != null)
         {
            _loc5_ = 0;
            while(_loc5_ < this.mFriendsList.length)
            {
               _loc4_ = this.mFriendsList[_loc5_];
               if(_loc4_ != null)
               {
                  if(_loc4_.getAccountId() == param1)
                  {
                     switch(param3)
                     {
                        case DIFFICULTY_EASY:
                           _loc4_.setCurrentLevelSku(param2);
                           break;
                        case DIFFICULTY_MEDIUM:
                           _loc4_.setCurrentLevelMediumSku(param2);
                           break;
                        case DIFFICULTY_HARD:
                           _loc4_.setCurrentLevelHardSku(param2);
                     }
                     this.addFriendToLevelCatalog(_loc4_,_loc4_.getCurrentLevelIndex(param3),param3);
                  }
               }
               _loc5_++;
            }
         }
      }
      
      public function purgeFriendsData() : void
      {
         if(this.mFriendsList)
         {
            this.mFriendsList.length = 0;
            this.mFriendsList = null;
         }
         if(this.mFriendsListNotPlaying)
         {
            this.mFriendsListNotPlaying.length = 0;
            this.mFriendsListNotPlaying = null;
         }
         if(this.mFriendsListLevelsCatalog)
         {
            DictionaryUtils.clearDictionary(this.mFriendsListLevelsCatalog);
            this.mFriendsListLevelsCatalog = null;
         }
         if(this.mPotentialFriendsToSendLivesCatalog)
         {
            DictionaryUtils.clearDictionary(this.mPotentialFriendsToSendLivesCatalog);
            this.mPotentialFriendsToSendLivesCatalog = null;
         }
      }
      
      public function getFriends(param1:int = 0) : Vector.<UserData>
      {
         return param1 == FRIEND_PLAYING ? this.mFriendsList : this.mFriendsListNotPlaying;
      }
      
      public function getPotentialFriendsToSendLives() : Dictionary
      {
         return this.mPotentialFriendsToSendLivesCatalog;
      }
      
      private function requestFriendsLastCompletedLevelTimestamp() : void
      {
         var _loc1_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:UserData = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc2_:Vector.<UserData> = this.getFriends();
         if(_loc2_)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc4_ = _loc2_[_loc3_];
               if(_loc4_ != null)
               {
                  if(_loc1_ == null)
                  {
                     _loc1_ = new Array();
                  }
                  _loc6_ = _loc4_.getAccountId();
                  if(_loc6_ != null && _loc6_ != "")
                  {
                     _loc1_.push(_loc4_.getAccountId());
                  }
               }
               _loc3_++;
            }
         }
         if(_loc1_ != null)
         {
            this.getFriendsLastLevelCompletedTimestamp(this.onFriendsTimestampsReceived,_loc1_);
         }
      }
      
      private function onFriendsTimestampsReceived(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Dictionary = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         if(param1)
         {
            for each(_loc2_ in param1)
            {
               if(_loc2_.score != null && _loc2_.uid != null && _loc2_.timestampMs != null)
               {
                  if(_loc3_ == null)
                  {
                     _loc3_ = new Dictionary(true);
                  }
                  if(_loc3_[_loc2_.uid] != null)
                  {
                     _loc3_[_loc2_.uid] = _loc3_[_loc2_.uid] < _loc2_.timestampMs ? _loc2_.timestampMs : _loc3_[_loc2_.uid];
                  }
                  else
                  {
                     _loc3_[_loc2_.uid] = _loc2_.timestampMs;
                  }
               }
            }
         }
         if(_loc3_)
         {
            _loc4_ = DictionaryUtils.getKeys(_loc3_);
            if(_loc4_)
            {
               _loc5_ = int(_loc4_.length);
               if(_loc5_ > 0)
               {
                  _loc4_.sort(Utils.randomize);
                  _loc6_ = 0;
                  while(_loc6_ < _loc5_)
                  {
                     if(_loc6_ < Config.getConfig().getMaxAmountFriendsSocialPopups())
                     {
                        _loc7_ = Number(_loc3_[_loc4_[_loc6_]]);
                        _loc8_ = TimerUtil.msToDays(_loc7_);
                        if(_loc8_ >= 5)
                        {
                           if(this.mPotentialFriendsToSendLivesCatalog == null)
                           {
                              this.mPotentialFriendsToSendLivesCatalog = new Dictionary(true);
                           }
                           this.mPotentialFriendsToSendLivesCatalog[_loc4_[_loc6_]] = _loc8_;
                        }
                     }
                     _loc6_++;
                  }
               }
            }
            this.checkOpenSocialPopups();
         }
         else
         {
            this.checkOpenSocialPopups();
         }
      }
      
      public function onMapUnlockedPerformOperations() : void
      {
         var _loc1_:int = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
         var _loc2_:int = this.getOwnerUserData().getCurrentMapIndex(_loc1_);
         this.getOwnerUserData().setHighestMapUnlockedIndex(_loc2_,false);
         this.getOwnerUserData().setFinishedLastcampaignTimestamp(0,false);
         var _loc3_:String = InstanceMng.getMapsDefMng().getMapDefByIndex(_loc2_).getSku();
         this.getOwnerUserData().removeComicRead(_loc3_,false);
         InstanceMng.getServerConnection().removeMapUnlockHelps();
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            InstanceMng.getServerConnection().removeMapUnlockHelpNotifications(this.onUnlockNotificationsRemoved);
         }
         this.persistenceSaveData();
         this.mUnlockNextMapTimeLeft = 0;
      }
      
      private function onUnlockNotificationsRemoved(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         FSDebug.debugTrace("[removeMapUnlockHelpNotifications] OK");
         if(param1 != null)
         {
            _loc2_ = param1 as Array;
            if(_loc2_ != null && _loc2_.length > 0)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc2_.length)
               {
                  if(InstanceMng.getUserDataMng() != null && InstanceMng.getUserDataMng().getOwnerUserData() != null)
                  {
                     this.mOwnerUserData.removeNotification(Utils.getDataId(_loc2_[_loc3_]));
                  }
                  InstanceMng.getServerConnection().removeRequestInstance(Utils.getDataId(_loc2_[_loc3_]));
                  _loc3_++;
               }
            }
         }
      }
      
      public function purgeOfflineDB() : void
      {
      }
      
      public function hasToShowDailyRewards(param1:Number, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = param2 && param2 ? this.mOwnerUserData.isOldPlayerComingBack() : true;
         var _loc4_:Number = param2 ? this.mOwnerUserData.getOldPlayerComingBackDailyRewardTimeMS() : this.mOwnerUserData.getDailyRewardTimeMS();
         var _loc5_:int = param2 ? int(this.mOwnerUserData.getOldPlayerComingBackLastDailyRewardClaimedIndex()) : int(this.mOwnerUserData.getLastDailyRewardClaimedIndex());
         var _loc6_:Number = Config.getConfig().getDailyRewardTimeBetweenRewards();
         var _loc7_:Number = _loc4_ + _loc6_ * _loc5_;
         if(Config.smDailyRewardExpires)
         {
            _loc7_ = _loc4_ + _loc6_ * _loc5_;
         }
         else
         {
            _loc7_ = _loc4_ + _loc6_;
         }
         return _loc3_ && (_loc4_ == 0 || param1 > _loc7_);
      }
      
      public function getTodayRewardDef(param1:Boolean) : DailyRewardDef
      {
         var _loc2_:Number = param1 ? this.getOwnerUserData().getOldPlayerComingBackLastDailyRewardClaimedIndex() : this.getOwnerUserData().getLastDailyRewardClaimedIndex();
         var _loc3_:int = param1 ? 3 : 30;
         if(_loc2_ == _loc3_)
         {
            _loc2_ = 0;
         }
         return DailyRewardDef(InstanceMng.getDailyRewardsDefMng().getDefByDay(_loc2_ + 1,param1));
      }
      
      public function openDailyRewardsPopup(param1:Boolean = false) : void
      {
         var _loc2_:Function = null;
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            InstanceMng.getCurrentScreen().showLoadingIcon(true,false);
            _loc2_ = param1 ? this.onServerTimeACKCheckOldPlayerComingBackDailyRewards : this.onServerTimeACKCheckDailyRewards;
            InstanceMng.getServerConnection().getServerTime(_loc2_);
         }
      }
      
      protected function onServerTimeACKCheckStandardDailyRewards(param1:Object, param2:Boolean) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:Date = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:DailyRewardDef = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:Date = null;
         var _loc13_:Date = null;
         if(!Root.assets.isLoading)
         {
            InstanceMng.getCurrentScreen().showLoadingIcon(false,false);
            _loc3_ = param2 ? this.getOwnerUserData().getOldPlayerComingBackDailyRewardTimeMS() : this.getOwnerUserData().getDailyRewardTimeMS();
            _loc4_ = param2 ? int(this.getOwnerUserData().getOldPlayerComingBackLastDailyRewardClaimedIndex()) : int(this.getOwnerUserData().getLastDailyRewardClaimedIndex());
            _loc5_ = Utils.parseJSONData(param1);
            _loc6_ = TimerUtil.convertServerUCTDateToDate(_loc5_.now);
            _loc7_ = _loc6_.getTime();
            _loc8_ = Config.getConfig().getDailyRewardTimeBetweenRewards();
            _loc10_ = param2 ? 3 : 30;
            _loc11_ = _loc4_ == _loc10_ ? 0 : int(_loc4_ + 1);
            _loc12_ = new Date(_loc3_ + _loc8_ * _loc11_);
            _loc13_ = new Date(_loc7_);
            if(Config.smDailyRewardExpires)
            {
               if(_loc3_ == 0 || _loc13_.time > _loc12_.time)
               {
                  _loc9_ = DailyRewardDef(InstanceMng.getDailyRewardsDefMng().getDefByDay(1,param2));
                  if(_loc4_ != 0)
                  {
                     if(param2)
                     {
                        this.mOwnerUserData.setOldPlayerComingBackLastDailyRewardClaimedIndex(0);
                        this.updateOldPlayerComingBackLastDailyRewardClaimedIndex();
                     }
                     else
                     {
                        this.mOwnerUserData.setLastDailyRewardClaimedIndex(0);
                        this.updateLastDailyRewardClaimedIndex();
                     }
                  }
               }
               else if(_loc13_.time <= _loc12_.time)
               {
                  _loc4_ = _loc4_ == _loc10_ ? 0 : _loc4_;
                  _loc9_ = DailyRewardDef(InstanceMng.getDailyRewardsDefMng().getDefByDay(_loc4_ + 1,param2));
               }
            }
            else
            {
               _loc4_ = _loc4_ == _loc10_ ? 0 : _loc4_;
               _loc9_ = DailyRewardDef(InstanceMng.getDailyRewardsDefMng().getDefByDay(_loc4_ + 1,param2));
            }
            FSDebug.debugTrace("Opening daily reward popup");
            if(param2)
            {
               InstanceMng.getPopupMng().openOldPlayerComingBackDailyRewardsPopup(_loc9_);
            }
            else
            {
               InstanceMng.getPopupMng().openDailyRewardsPopup(_loc9_);
            }
         }
      }
      
      protected function onServerTimeACKCheckOldPlayerComingBackDailyRewards(param1:Object) : void
      {
         this.onServerTimeACKCheckStandardDailyRewards(param1,true);
      }
      
      protected function onServerTimeACKCheckDailyRewards(param1:Object) : void
      {
         this.onServerTimeACKCheckStandardDailyRewards(param1,false);
      }
      
      public function checkIfCardIsNewCard(param1:String) : Boolean
      {
         var _loc3_:Dictionary = null;
         var _loc2_:Boolean = false;
         if(this.mOwnerUserData != null)
         {
            _loc3_ = this.mOwnerUserData.getNewCardsCollection();
            if(_loc3_ != null)
            {
               if(_loc3_[param1] != null)
               {
                  if(_loc3_[param1] > 0)
                  {
                     _loc2_ = true;
                  }
               }
            }
         }
         return _loc2_;
      }
      
      public function updateRaidCoins(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","raidCoins",param1.raidCoins);
      }
      
      public function updateBotsPlayedSession(param1:Object = null) : void
      {
         if(param1 == null)
         {
            param1 = this.mOwnerUserData.persistenceBuildData();
         }
         this.dbUpdateField("main","botsPlayedSession",param1.botsPlayedSession);
      }
      
      public function addPlayerToMutedPlayersList(param1:String) : void
      {
         if(this.mMutedPlayersIds == null)
         {
            this.mMutedPlayersIds = new Vector.<String>();
         }
         this.mMutedPlayersIds.push(param1);
      }
      
      public function setMutedPlayersList(param1:Array) : void
      {
         var _loc2_:int = 0;
         if(Boolean(param1) && param1.length > 0)
         {
            if(this.mMutedPlayersIds == null)
            {
               this.mMutedPlayersIds = new Vector.<String>();
            }
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               this.mMutedPlayersIds.push(param1[_loc2_].mutedPlayerId);
               _loc2_++;
            }
         }
      }
      
      public function removeMutedPlayerFromList(param1:String) : Boolean
      {
         var _loc3_:int = 0;
         var _loc2_:Boolean = false;
         if(this.mMutedPlayersIds)
         {
            _loc3_ = 0;
            while(_loc3_ < this.mMutedPlayersIds.length)
            {
               if(this.mMutedPlayersIds[_loc3_] == param1)
               {
                  this.mMutedPlayersIds.splice(_loc3_,1);
                  return true;
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      public function getMutedPlayersList() : String
      {
         var _loc2_:int = 0;
         var _loc1_:String = "";
         if(this.mMutedPlayersIds)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mMutedPlayersIds.length)
            {
               _loc1_ += "\'" + this.mMutedPlayersIds[_loc2_] + "\'";
               if(_loc2_ != this.mMutedPlayersIds.length - 1)
               {
                  _loc1_ += ",";
               }
               _loc2_++;
            }
         }
         return _loc1_;
      }
      
      public function isPlayerInMutedList(param1:String) : Boolean
      {
         var _loc3_:int = 0;
         var _loc2_:Boolean = false;
         if(this.mMutedPlayersIds)
         {
            _loc3_ = 0;
            while(_loc3_ < this.mMutedPlayersIds.length)
            {
               if(this.mMutedPlayersIds[_loc3_] == param1)
               {
                  return true;
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      public function onFriendsReceivedGS(param1:Vector.<Player>, param2:Object = null) : void
      {
         FSDebug.debugTrace("Friends list received");
         if(param1 != null && param1.length > 0)
         {
            this.fillFriendsWhoPlayListGS(param1,param2);
         }
      }
      
      public function buildUserDataFromProfile(param1:Object, param2:Boolean, param3:Object = null) : UserData
      {
         return null;
      }
      
      public function hasRequestedFriends() : Boolean
      {
         return this.mFriendsRequested;
      }
      
      public function setHasRequestedFriends(param1:Boolean) : void
      {
         this.mFriendsRequested = param1;
      }
      
      public function destroy() : void
      {
         Utils.destroyArray(this.mFriendsList);
         this.mFriendsList = null;
         Utils.destroyArray(this.mFriendsListLevelsCatalog);
         this.mFriendsListLevelsCatalog = null;
         Utils.destroyArray(this.mFriendsListNotPlaying);
         this.mFriendsListNotPlaying = null;
         Utils.destroyArray(this.mMutedPlayersIds);
         this.mMutedPlayersIds = null;
         Utils.destroyObject(this.mOwnerUserData);
         this.mOwnerUserData = null;
         Utils.destroyObject(this.mOpponentUserData);
         this.mOpponentUserData = null;
         DictionaryUtils.clearDictionary(this.mPotentialFriendsToSendLivesCatalog);
         this.mPotentialFriendsToSendLivesCatalog = null;
      }
      
      public function referralCheckConditions(param1:int, param2:int, param3:int) : Boolean
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc4_:Boolean = false;
         if(Boolean(ServerConnection.smServerReferralsDefs) && ServerConnection.smServerReferralsDefs.hasOwnProperty(param3))
         {
            _loc5_ = int(ServerConnection.smServerReferralsDefs[param3]["conditionLevel"]);
            _loc6_ = int(ServerConnection.smServerReferralsDefs[param3]["conditionMatchesPlayed"]);
            _loc4_ = param1 >= _loc5_ && param2 >= _loc6_;
         }
         return _loc4_;
      }
      
      public function referralGetMaxByType(param1:int) : int
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         if(Boolean(ServerConnection.smServerReferralsDefs) && ServerConnection.smServerReferralsDefs.hasOwnProperty(param1))
         {
            _loc3_ = ServerConnection.smServerReferralsDefs[param1]["amounts"] as Array;
            if(_loc3_ != null && _loc3_.length > 0)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc3_.length)
               {
                  _loc2_ = _loc3_[_loc4_]["amount"] > _loc2_ ? int(_loc3_[_loc4_]["amount"]) : _loc2_;
                  _loc4_++;
               }
            }
         }
         return _loc2_;
      }
      
      public function resetOwnerUserData() : void
      {
         this.mOwnerUserData = null;
      }
      
      public function handleBundlePurchased(param1:BundleDef, param2:FSShopItem) : void
      {
         var _loc3_:BundleDef = BundleDef(param1);
         if(_loc3_.isUnique())
         {
            InstanceMng.getUserDataMng().getOwnerUserData().addPackIdToUniquePacksArr(_loc3_.getSku());
         }
         Utils.setLogText(TextManager.getText("TID_SHOP_BUNDLE_SUCCESS"));
         var _loc4_:String = _loc3_.isManualOffer() ? _loc3_.getManualId() : _loc3_.getSku();
         InstanceMng.getUserDataMng().getOwnerUserData().addCustomOfferPurchased(_loc4_);
         var _loc5_:String = param2 ? param2.getOrigin() : PacksDefMng.PACK_SHOP;
         Utils.openBundle(_loc3_,_loc5_,param2,false,_loc3_.getChestBG());
         if(Boolean(param2) && !_loc3_.isRepurchasable())
         {
            param2.removeFromParent();
         }
         if(param2)
         {
            InstanceMng.getServerConnection().addBundlePurchasedInstance(param2);
         }
      }
      
      public function handleBattlePassPurchased() : void
      {
         var notifyRewards:Function = null;
         var bpClaimedQuests:Vector.<QuestDef> = null;
         var i:int = 0;
         notifyRewards = function():void
         {
            Utils.removeLog();
            Utils.setLogText(TextManager.getText("TID_REWARDS_CLAIM"),false,false,false);
         };
         var currBattlePass:String = this.mOwnerUserData.getBattlePass();
         var currYear:int = Config.smYearNumber.value;
         var currMonth:int = Config.smMonthNumber.value;
         var futureBattlePass:String = currYear + "-" + currMonth;
         if(currYear != -1 && currMonth != -1)
         {
            if(currBattlePass != futureBattlePass)
            {
               this.mOwnerUserData.setBattlePass(futureBattlePass);
               bpClaimedQuests = this.mOwnerUserData.getBattlePassQuestsClaimed();
               if(bpClaimedQuests != null && bpClaimedQuests.length > 0)
               {
                  i = 0;
                  i = 0;
                  while(i < bpClaimedQuests.length)
                  {
                     bpClaimedQuests[i].claimBattlePassPremiumReward(false);
                     i++;
                  }
                  setTimeout(notifyRewards,3000);
                  if(InstanceMng.getCurrentScreen() is FSMapScreen)
                  {
                     FSMapScreen(InstanceMng.getCurrentScreen()).checkRewardsToClaim();
                  }
               }
               if(InstanceMng.getPopupMng().getPopupShown() is PopupBattlePass)
               {
                  PopupBattlePass(InstanceMng.getPopupMng().getPopupShown()).onBattlePassPurchased();
               }
               FSTracker.trackMiscAction(FSTracker.CATEGORY_BATTLE_PASS,FSTracker.ACTION_PURCHASE);
               this.persistenceSaveData();
            }
         }
      }
      
      public function frictionlessPlayLevel(param1:LevelDef) : void
      {
         var _loc2_:String = null;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Boolean = false;
         this.frictionlessAssignDeck();
         var _loc3_:UserData = Utils.getOwnerUserData();
         var _loc4_:Boolean = !Config.smLivesSystemEnabled ? true : _loc3_.getLives() > 0;
         if(_loc4_)
         {
            _loc3_.setLastLevelPlayedSkuByDifficulty(param1.getSku());
            _loc5_ = Boolean(Root) && Boolean(Root.smBattleData) && Boolean(Root.smBattleData.easyMode);
            _loc2_ = _loc5_ ? FSTracker.ACTION_PVE_STARTED_EASY_MODE : FSTracker.ACTION_PVE_STARTED;
            _loc6_ = _loc3_ ? _loc3_.getSelectedDeckIndex() : -1;
            _loc7_ = _loc3_ ? _loc3_.getCurrentDifficulty() : UserDataMng.DIFFICULTY_EASY;
            if(Config.PRODUCTION_BUILD)
            {
               if(_loc7_ == UserDataMng.DIFFICULTY_EASY)
               {
                  FSTracker.trackFirebaseEvent("PVE_STARTED_LVL_" + param1.getLevelIndex());
               }
            }
            _loc8_ = _loc3_ ? _loc3_.getCurrentLevelIndex(_loc7_) > param1.getLevelIndex() : false;
            InstanceMng.getServerConnection().sendPvELevelAttempt(param1.getLevelIndex(),_loc7_,_loc8_,_loc6_,_loc5_);
            InstanceMng.getCurrentScreen().startBattle(param1.getSku(),false);
         }
         if(InstanceMng.getTutorialMapMng().isTutorialON())
         {
            InstanceMng.getTutorialMapMng().increaseCurrentStep();
         }
      }
      
      private function frictionlessAssignDeck() : void
      {
         var _loc2_:Array = null;
         var _loc3_:JobDef = null;
         var _loc4_:int = 0;
         var _loc1_:UserData = Utils.getOwnerUserData();
         if(_loc1_ != null)
         {
            if(Config.getConfig().gameHasClassSystem())
            {
               _loc2_ = InstanceMng.getJobsDefMng().getBasicsJobDef();
               _loc3_ = _loc2_ ? _loc2_[0] : null;
               _loc4_ = Config.getConfig().getMaxDecksAmount();
               _loc1_.setSelectedDeckIndex(_loc4_);
               _loc1_.setDeck(InstanceMng.getUserDataMng().getOwnerUserData().createBestBasicDeckConfiguration(_loc3_),_loc4_);
            }
            else
            {
               _loc1_.setSelectedDeckIndex(Config.getConfig().getMaxDecksAmount());
            }
         }
      }
      
      public function resetPlayer(param1:Boolean = false) : void
      {
         var popupShown:Popup = null;
         var currScreen:Screen = null;
         var onPopupInBGClosed:Function = null;
         var onResetConfirm:Function = null;
         var resetLogicProgress:Function = null;
         var resetPlayerLevelsScores:Function = null;
         var onResetSuccess:Function = null;
         var onResetFailed:Function = null;
         var text:String = null;
         var fullReset:Boolean = param1;
         onPopupInBGClosed = function():void
         {
            InstanceMng.getPopupMng().openConfirmationPopup(text,onResetConfirm,null,true,TextManager.getText("TID_RESET_BUTTON"),16711680);
         };
         onResetConfirm = function():void
         {
            if(popupShown)
            {
               setTimeout(popupShown.closePopup,250,resetLogicProgress);
            }
            else
            {
               resetLogicProgress();
            }
         };
         resetLogicProgress = function():void
         {
            if(currScreen == null)
            {
               return;
            }
            Utils.setLogText(TextManager.getText("TID_RESET_PROGRESS"),false,false,false);
            currScreen.lockUI(true);
            Main.smOfflineUserData = null;
            purgeOfflineDB();
            if(currScreen != null && !(currScreen is FSMenuScreen))
            {
               currScreen.dispatchEventWith(Screen.GO_TO_MENU,true);
            }
            InstanceMng.getApplication().steamResetAllStats(true);
            FSTracker.trackMiscAction(FSTracker.CATEGORY_USER,FSTracker.ACTION_RESET);
            if(mOwnerUserData)
            {
               mOwnerUserData.setProgressResetDate(ServerConnection.smServerTimeMS);
               mOwnerUserData.setLastLevelPlayed("");
               mOwnerUserData.setLastLevelMediumPlayed("");
               mOwnerUserData.setLastLevelHardPlayed("");
               mOwnerUserData.setLastLevelPlayedSkuByDifficulty("");
               mOwnerUserData.setCurrentDifficulty(UserDataMng.DIFFICULTY_EASY);
               mOwnerUserData.setCurrentLevelSku("level_01");
               mOwnerUserData.setCurrentLevelMediumSku("level_01");
               mOwnerUserData.setCurrentLevelHardSku("level_01");
               InstanceMng.getServerConnection().getBackendUserProfile().profile.currentLevelSku = "level_01";
               InstanceMng.getServerConnection().getBackendUserProfile().profile.currentLevelMediumSku = "level_01";
               InstanceMng.getServerConnection().getBackendUserProfile().profile.currentLevelHardSku = "level_01";
               InstanceMng.getUserDataMng().updateCurrentLevelSku({"currentLevelSku":"level_01"});
               InstanceMng.getUserDataMng().updateCurrentLevelMediumSku({"currentLevelMediumSku":"level_01"});
               InstanceMng.getUserDataMng().updateCurrentLevelHardSku({"currentLevelHardSku":"level_01"});
               if(fullReset)
               {
                  mOwnerUserData.setName(Utils.generateRandomUserName());
                  if(Config.getConfig().gameHasBuildingBadges())
                  {
                     mOwnerUserData.setCityName(TextManager.getText("TID_CITY_NAME"));
                  }
               }
               mOwnerUserData.resetFlags();
               mOwnerUserData.resetTutorialsSeen();
               mOwnerUserData.resetFailedLevelsInfo();
               mOwnerUserData.setExp(0);
               mOwnerUserData.resetBoostsCatalog();
               mOwnerUserData.resetComicsRead();
               mOwnerUserData.resetStarsRewardsClaimed();
               mOwnerUserData.setFinishedLastcampaignTimestamp(0,false);
               mOwnerUserData.setHighestMapUnlockedIndex(0,false);
               mOwnerUserData.setDailyRewardTimeMS(0);
               mOwnerUserData.setLastDailyRewardClaimedIndex(0);
               mOwnerUserData.setOldPlayerComingBackDailyRewardTimeMS(0);
               mOwnerUserData.setOldPlayerComingBackLastDailyRewardClaimedIndex(0);
               mOwnerUserData.resetCustomOfferStuff();
               mOwnerUserData.resetMapWorldChoices();
               mOwnerUserData.setPurchasesAmount(0);
               mOwnerUserData.resetNotifications();
               mOwnerUserData.resetTopScores();
               mOwnerUserData.setLives(5);
               mOwnerUserData.setLostLifeTimeMS(0);
               mOwnerUserData.resetExtraLifesBoostDef();
               mOwnerUserData.purgeCardsCollection();
               mOwnerUserData.resetNewCardsCollection();
               mOwnerUserData.resetFavouritesCollection();
               mOwnerUserData.resetAvailablePortraits();
               mOwnerUserData.resetAvailableSkins();
               mOwnerUserData.resetAvailableJobs();
               mOwnerUserData.addPortraitToCatalog("portrait_01");
               mOwnerUserData.setCurrentPortraitSku("portrait_01");
               mOwnerUserData.addSkinToCatalog("hero_01");
               mOwnerUserData.setCurrentSkinSku("hero_01");
               mOwnerUserData.addJobToCatalog("job_01",true);
               mOwnerUserData.resetBadgeCollection();
               mOwnerUserData.resetBadgesRewardsClaimed();
               mOwnerUserData.setDeck(null,0);
               mOwnerUserData.setDeck(null,1);
               mOwnerUserData.setDeck(null,2);
               mOwnerUserData.setDeck(null,3);
               mOwnerUserData.setDeck(null,4);
               mOwnerUserData.setDeck(null,5);
               mOwnerUserData.setDeck(null,6);
               mOwnerUserData.setDeck(null,7);
               mOwnerUserData.setDeck(null,8);
               mOwnerUserData.setDeck(null,9);
               mOwnerUserData.resetDeckNames();
               mOwnerUserData.setSelectedDeckIndex(0);
               mOwnerUserData.setSelectedDeckIndexPvP(0);
               mOwnerUserData.setDecksPurchasedAmount(0);
               mOwnerUserData.setGold(0);
               mOwnerUserData.setQuestsCoins(0);
               mOwnerUserData.setAuctionTickets(0);
               mOwnerUserData.setRaidCoins(0);
               mOwnerUserData.setRaidTicketsSinglePlayer(0);
               mOwnerUserData.setRaidTicketsMultiPlayer(0);
               mOwnerUserData.setElo(1000);
               mOwnerUserData.setMatchesLost(0);
               mOwnerUserData.setMatchesWon(0);
               mOwnerUserData.setMatchesPlayed(0);
               mOwnerUserData.setPvPSeason(1);
               mOwnerUserData.setBotsPlayedSession(0);
               mOwnerUserData.setPvPCurrentLeague(3);
               mOwnerUserData.setPvPBestLeague(3);
               mOwnerUserData.setDungeonsLost(0);
               mOwnerUserData.setDungeonsWon(0);
               mOwnerUserData.setDungeonsPlayed(0);
               mOwnerUserData.setDungeonsSeason(0);
               mOwnerUserData.setBattlePass("");
               mOwnerUserData.godModeResetQuests(false);
               mOwnerUserData.setDailyKeyTime(-1);
               mOwnerUserData.setWeekNumber(-1);
               mOwnerUserData.setMonthNumber(-1);
               mOwnerUserData.setRaidsUnlocked(null);
               mOwnerUserData.setAuctionIdBiddedArr(null);
               mOwnerUserData.setAuctionIdCreatedArr(null);
               mOwnerUserData.setAuctionTickets(10);
               mOwnerUserData.setUniquePacksArr(null);
               mOwnerUserData.setJobsExperience(InstanceMng.getJobsDefMng().getAllJobSkus());
               mOwnerUserData.setDeckJobConfiguratorArr(null);
               mOwnerUserData.resetDeckJobConfigurator();
               mOwnerUserData.setPvPBestLeague(3);
               mOwnerUserData.setPvPCurrentLeague(3);
               if(fullReset)
               {
                  mOwnerUserData.setGuildMemberId("");
                  mOwnerUserData.setGuildId("");
                  InstanceMng.getGuildsMng().leaveGuild();
               }
            }
            InstanceMng.getUserDataMng().persistenceSaveData(false,resetPlayerLevelsScores);
         };
         resetPlayerLevelsScores = function():void
         {
            InstanceMng.getServerConnection().performPlayerResetOnServer(onResetSuccess,onResetFailed);
         };
         onResetSuccess = function():void
         {
            Utils.setLogText(TextManager.getText("TID_RESET_COMPLETED"));
            setTimeout(InstanceMng.getServerConnection().loginUser,1000);
         };
         onResetFailed = function():void
         {
            Utils.setLogText(TextManager.getText("TID_RESET_ERROR"));
         };
         popupShown = InstanceMng.getPopupMng().getPopupShown();
         currScreen = InstanceMng.getCurrentScreen();
         if(currScreen != null && currScreen.isFullyLoaded())
         {
            if(currScreen is FSMenuScreen)
            {
               if(!this.mOwnerUserData.isInBlackList())
               {
                  if(!this.mOwnerUserData.isInDuplicatedList())
                  {
                     if(InstanceMng.getServerConnection().isUserLoggedIn())
                     {
                        text = TextManager.getText("TID_RESET_INFORMATION",true);
                        if(Utils.isDesktop())
                        {
                           text += TextManager.getText("TID_RESET_INFORMATION_STEAM",true);
                        }
                        if(popupShown != null)
                        {
                           popupShown.hideTemporarily(onPopupInBGClosed);
                        }
                        else
                        {
                           onPopupInBGClosed();
                        }
                     }
                     else
                     {
                        Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true);
                        if(popupShown != null)
                        {
                           InstanceMng.getPopupMng().resumePopupInBackground();
                        }
                     }
                  }
                  else
                  {
                     InstanceMng.getPopupMng().openConfirmationPopup("Error: " + TextManager.getText("TID_MIGRATION_ERROR_MIGRATED"));
                     if(popupShown != null)
                     {
                        InstanceMng.getPopupMng().resumePopupInBackground();
                     }
                  }
               }
               else
               {
                  InstanceMng.getPopupMng().openConfirmationPopup("Error: " + TextManager.getText("TID_GEN_FRAUD_PURCHASE"));
                  if(popupShown != null)
                  {
                     InstanceMng.getPopupMng().resumePopupInBackground();
                  }
               }
            }
            else
            {
               Utils.setLogText(TextManager.getText("TID_RESET_MAIN_MENU"),true,false,false);
               if(popupShown != null)
               {
                  InstanceMng.getPopupMng().resumePopupInBackground();
               }
            }
         }
      }
   }
}

