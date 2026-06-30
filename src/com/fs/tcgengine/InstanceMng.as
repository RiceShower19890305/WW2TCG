package com.fs.tcgengine
{
   import com.fs.tcgengine.controller.AbilitiesMng;
   import com.fs.tcgengine.controller.AuctionsMng;
   import com.fs.tcgengine.controller.BoostsMng;
   import com.fs.tcgengine.controller.ComicMng;
   import com.fs.tcgengine.controller.ConversationsMng;
   import com.fs.tcgengine.controller.DungeonsMng;
   import com.fs.tcgengine.controller.FSCardAnimsMng;
   import com.fs.tcgengine.controller.FSCardsMng;
   import com.fs.tcgengine.controller.FSFacebookPlugin;
   import com.fs.tcgengine.controller.FSSoundFXMng;
   import com.fs.tcgengine.controller.GuildsMng;
   import com.fs.tcgengine.controller.QuestsMng;
   import com.fs.tcgengine.controller.RaidsMng;
   import com.fs.tcgengine.controller.ScoreMng;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.SubCategoriesMng;
   import com.fs.tcgengine.controller.TargetMng;
   import com.fs.tcgengine.controller.TutorialDeckBuilderMng;
   import com.fs.tcgengine.controller.TutorialMapMng;
   import com.fs.tcgengine.controller.TutorialMng;
   import com.fs.tcgengine.controller.rules.AIMovementsDefMng;
   import com.fs.tcgengine.controller.rules.AbilitiesDefMng;
   import com.fs.tcgengine.controller.rules.ActionsDefMng;
   import com.fs.tcgengine.controller.rules.AttachmentsDefMng;
   import com.fs.tcgengine.controller.rules.AuctionTicketsDefMng;
   import com.fs.tcgengine.controller.rules.BackgroundDefMng;
   import com.fs.tcgengine.controller.rules.BadgesDefMng;
   import com.fs.tcgengine.controller.rules.BattleEventDefMng;
   import com.fs.tcgengine.controller.rules.BoostsDefMng;
   import com.fs.tcgengine.controller.rules.BundlesDefMng;
   import com.fs.tcgengine.controller.rules.CardDefMng;
   import com.fs.tcgengine.controller.rules.CategoriesDefMng;
   import com.fs.tcgengine.controller.rules.ComicStripsDefMng;
   import com.fs.tcgengine.controller.rules.ConfigDefMng;
   import com.fs.tcgengine.controller.rules.ConversationsDefMng;
   import com.fs.tcgengine.controller.rules.DailyRewardsDefMng;
   import com.fs.tcgengine.controller.rules.DeckSlotDefMng;
   import com.fs.tcgengine.controller.rules.DungeonLevelsDefMng;
   import com.fs.tcgengine.controller.rules.DungeonRewardsDefMng;
   import com.fs.tcgengine.controller.rules.DungeonsDefMng;
   import com.fs.tcgengine.controller.rules.EditionsDefMng;
   import com.fs.tcgengine.controller.rules.FactionsDefMng;
   import com.fs.tcgengine.controller.rules.GameModesDefMng;
   import com.fs.tcgengine.controller.rules.GameScoreDefMng;
   import com.fs.tcgengine.controller.rules.GoldDefMng;
   import com.fs.tcgengine.controller.rules.GroupIdsDefMng;
   import com.fs.tcgengine.controller.rules.HeroCharacterDefMng;
   import com.fs.tcgengine.controller.rules.JobLevelsDefMng;
   import com.fs.tcgengine.controller.rules.JobRewardsDefMng;
   import com.fs.tcgengine.controller.rules.JobsDefMng;
   import com.fs.tcgengine.controller.rules.KickstarterBackerDefMng;
   import com.fs.tcgengine.controller.rules.LevelDefMng;
   import com.fs.tcgengine.controller.rules.MapsDefMng;
   import com.fs.tcgengine.controller.rules.PacksDefMng;
   import com.fs.tcgengine.controller.rules.PassiveAbilityDefMng;
   import com.fs.tcgengine.controller.rules.PortraitsDefMng;
   import com.fs.tcgengine.controller.rules.PowersDefMng;
   import com.fs.tcgengine.controller.rules.PvPBotDecksDefMng;
   import com.fs.tcgengine.controller.rules.PvPRewardsDefMng;
   import com.fs.tcgengine.controller.rules.QuestShopDefMng;
   import com.fs.tcgengine.controller.rules.QuestsDefMng;
   import com.fs.tcgengine.controller.rules.RaidLevelsDefMng;
   import com.fs.tcgengine.controller.rules.RaidShopDefMng;
   import com.fs.tcgengine.controller.rules.RaidsDefMng;
   import com.fs.tcgengine.controller.rules.RanksDefMng;
   import com.fs.tcgengine.controller.rules.RaritiesDefMng;
   import com.fs.tcgengine.controller.rules.ResourceDefMng;
   import com.fs.tcgengine.controller.rules.RestrictionsDefMng;
   import com.fs.tcgengine.controller.rules.RewardsDefMng;
   import com.fs.tcgengine.controller.rules.ShopBoostDefMng;
   import com.fs.tcgengine.controller.rules.StarsRewardsDefMng;
   import com.fs.tcgengine.controller.rules.SubCategoriesDefMng;
   import com.fs.tcgengine.controller.rules.TurnScoresDefMng;
   import com.fs.tcgengine.controller.rules.TutorialDeckBuilderDefMng;
   import com.fs.tcgengine.controller.rules.TutorialDefMng;
   import com.fs.tcgengine.controller.rules.TutorialMapDefMng;
   import com.fs.tcgengine.controller.rules.UnitsDefMng;
   import com.fs.tcgengine.controller.rules.WorldsDefMng;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.particles.TextParticlesMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.view.misc.FSLogPanel;
   import flash.utils.Dictionary;
   
   public class InstanceMng
   {
      
      protected static var mCatalog:Dictionary;
      
      protected static var smInstance:InstanceMng;
      
      private static const SKU_SERVER_CONNECTION:String = "ServerConnection";
      
      private static const SKU_ABILITIES_MNG:String = "abilities";
      
      private static const SKU_SUBCATEGORIES_MNG:String = "subcategories";
      
      private static const SKU_USERDATA_MNG:String = "userdata";
      
      private static const SKU_POPUP_MNG:String = "popups";
      
      private static const SKU_TEXT_PARTICLES_MNG:String = "textParticles";
      
      private static const SKU_CARD_ANIMS_MNG:String = "cardAnims";
      
      private static const SKU_SCORE_MNG:String = "score";
      
      private static const SKU_TARGET_MNG:String = "targets";
      
      private static const SKU_RESOURCES_MNG:String = "resources";
      
      private static const SKU_BOOSTS_MNG:String = "boosts";
      
      private static const SKU_TUTORIAL_MNG:String = "tutorial";
      
      private static const SKU_TUTORIAL_DECK_BUILDER_MNG:String = "tutorialDeckBuilder";
      
      private static const SKU_TUTORIAL_MAP_MNG:String = "tutorialMap";
      
      private static const SKU_CONVERSATIONS_MNG:String = "conversations";
      
      private static const SKU_COMICS_MNG:String = "comics";
      
      private static const SKU_SOUND_FX_MNG:String = "soundFX";
      
      private static const SKU_FACEBOOK_PLUGIN:String = "facebookplugin";
      
      private static const SKU_CARDS_MNG:String = "cards";
      
      private static const SKU_DUNGEONS_MNG:String = "dungeons";
      
      private static const SKU_RAIDS_MNG:String = "raids";
      
      private static const SKU_GUILDS_MNG:String = "guilds";
      
      private static const SKU_QUESTS_MNG:String = "quests";
      
      private static const SKU_AUCTIONS_MNG:String = "auctions";
      
      private static const SKU_ABILITIES_DEF_MNG:String = "abilitiesDefs";
      
      private static const SKU_ACTIONS_DEF_MNG:String = "actionsDefs";
      
      private static const SKU_ATTACHMENTS_DEF_MNG:String = "attachmentsDefs";
      
      private static const SKU_UNITS_DEF_MNG:String = "unitsDefs";
      
      private static const SKU_CATEGORIES_DEF_MNG:String = "categoriesDefs";
      
      private static const SKU_SUBCATEGORIES_DEF_MNG:String = "subcategoriesDefs";
      
      private static const SKU_EDITIONS_DEF_MNG:String = "editionsDefs";
      
      private static const SKU_FACTIONS_DEF_MNG:String = "factionsDefs";
      
      private static const SKU_RARITIES_DEF_MNG:String = "raritiesDefs";
      
      private static const SKU_LEVELS_DEF_MNG:String = "levelDefs";
      
      private static const SKU_GAME_MODES_DEF_MNG:String = "gameModesDefs";
      
      private static const SKU_CARDS_DEF_MNG:String = "cardsDefs";
      
      private static const SKU_RESTRICTIONS_DEF_MNG:String = "restrictionsDefs";
      
      private static const SKU_BACKGROUND_DEF_MNG:String = "backgroundDefs";
      
      private static const SKU_MAPS_DEF_MNG:String = "mapsDefs";
      
      private static const SKU_REWARDS_DEF_MNG:String = "rewardsDefs";
      
      private static const SKU_AIMOVEMENTS_DEF_MNG:String = "AIMovementsDefs";
      
      private static const SKU_GAMESCORES_DEF_MNG:String = "gameScoresDefs";
      
      private static const SKU_TURNCORES_DEF_MNG:String = "turnScoresDefs";
      
      private static const SKU_BOOSTS_DEF_MNG:String = "boostsDefs";
      
      private static const SKU_SHOP_BOOSTS_DEF_MNG:String = "shopBoostsDefs";
      
      private static const SKU_RANKS_DEF_MNG:String = "ranksDefs";
      
      private static const SKU_PACKS_DEF_MNG:String = "packsDefs";
      
      private static const SKU_WORLDS_DEF_MNG:String = "worldsDefs";
      
      private static const SKU_BUNDLES_DEF_MNG:String = "bundlesDefs";
      
      private static const SKU_TUTORIAL_DEF_MNG:String = "tutorialDefs";
      
      private static const SKU_TUTORIAL_DECK_BUILDER_DEF_MNG:String = "tutorialDeckBuilderDefs";
      
      private static const SKU_KICKSTARTER_BACKERS_DEF_MNG:String = "kickstarterBackersDefs";
      
      private static const SKU_HERO_CHARACTERS_DEF_MNG:String = "heroCharactersDefs";
      
      private static const SKU_CONVERSATIONS_DEF_MNG:String = "conversationsDefs";
      
      private static const SKU_COMIC_STRIPS_DEF_MNG:String = "comicStripsDefs";
      
      private static const SKU_DECK_SLOTS_DEF_MNG:String = "deckSlotsDefs";
      
      private static const SKU_PORTRAITS_DEF_MNG:String = "portraitsDefs";
      
      private static const SKU_DOWNLOADER_MNG:String = "downloader";
      
      private static const SKU_DAILY_REWARDS_MNG:String = "dailyRewards";
      
      private static const SKU_RESOURCES_DEF_MNG:String = "resourcesDefs";
      
      private static const SKU_CONFIG_DEF_MNG:String = "configDefs";
      
      private static const SKU_GOLD_DEF_MNG:String = "goldDefs";
      
      private static const SKU_BADGES_DEF_MNG:String = "badgesDefs";
      
      private static const SKU_STARS_REWARDS_DEF_MNG:String = "starsRewardsDefs";
      
      private static const SKU_DUNGEONS_DEF_MNG:String = "dungeonsDefs";
      
      private static const SKU_RAIDS_DEF_MNG:String = "raidsDefs";
      
      private static const SKU_DUNGEON_LEVELS_DEF_MNG:String = "dungeonLevelsDefs";
      
      private static const SKU_RAID_LEVELS_DEF_MNG:String = "raidLevelsDefs";
      
      private static const SKU_BATTLE_EVENT_DEF_MNG:String = "BattleEventDefs";
      
      private static const SKU_PASSIVE_ABILITY_DEF_MNG:String = "PassiveAbilityDefs";
      
      private static const SKU_GUILD_REWARDS_DEF_MNG:String = "guildRewardsDefs";
      
      private static const SKU_TUTORIAL_MAP_DEF_MNG:String = "tutorialMapDefs";
      
      private static const SKU_POWERS_DEF_MNG:String = "powersDefs";
      
      private static const SKU_QUESTS_DEF_MNG:String = "questsDefs";
      
      private static const SKU_QUEST_SHOP_DEF_MNG:String = "questsShopDefs";
      
      private static const SKU_RAID_SHOP_DEF_MNG:String = "raidsShopDefs";
      
      private static const SKU_PVP_BOT_DECKS_DEF_MNG:String = "pvpBotDecksDefs";
      
      private static const SKU_AUCTION_TICKETS_DEF_MNG:String = "auctionTicketsDefs";
      
      private static const SKU_PVP_REWARDS_DEF_MNG:String = "PvPRewardsDefs";
      
      private static const SKU_DUNGEON_REWARDS_DEF_MNG:String = "DungeonRewardsDefs";
      
      private static const SKU_JOBS_DEF_MNG:String = "JobsDefs";
      
      private static const SKU_JOB_LEVELS_DEF_MNG:String = "JobLevelsDefs";
      
      private static const SKU_JOB_REWARDS_DEF_MNG:String = "JobRewardsDefs";
      
      private static const SKU_GROUP_IDS_DEF_MNG:String = "groupIdsDefs";
      
      private static const SKU_LOG_PANEL:String = "logPanel";
      
      private static const SKU_CURRENT_SCREEN:String = "currentScreen";
      
      private static const SKU_APPLICATION:String = "application";
      
      public function InstanceMng()
      {
         super();
         if(smInstance == null)
         {
            mCatalog = new Dictionary(true);
            smInstance = this;
         }
      }
      
      public static function getInstance() : InstanceMng
      {
         return smInstance;
      }
      
      public static function registerServerConnection(param1:ServerConnection) : void
      {
         mCatalog[SKU_SERVER_CONNECTION] = param1;
      }
      
      public static function getServerConnection() : ServerConnection
      {
         return mCatalog[SKU_SERVER_CONNECTION];
      }
      
      public static function registerAbilitiesMng(param1:AbilitiesMng) : void
      {
         mCatalog[SKU_ABILITIES_MNG] = param1;
      }
      
      public static function getAbilitiesMng() : AbilitiesMng
      {
         return mCatalog[SKU_ABILITIES_MNG];
      }
      
      public static function registerSubCategoriesMng(param1:SubCategoriesMng) : void
      {
         mCatalog[SKU_SUBCATEGORIES_MNG] = param1;
      }
      
      public static function getSubCategoriesMng() : SubCategoriesMng
      {
         return mCatalog[SKU_SUBCATEGORIES_MNG];
      }
      
      public static function registerUserDataMng(param1:UserDataMng) : void
      {
         mCatalog[SKU_USERDATA_MNG] = param1;
      }
      
      public static function getUserDataMng() : UserDataMng
      {
         return mCatalog[SKU_USERDATA_MNG];
      }
      
      public static function deleteUserDataMng() : UserDataMng
      {
         return mCatalog[SKU_USERDATA_MNG] = null;
      }
      
      public static function registerPopupMng(param1:FSPopupMng) : void
      {
         mCatalog[SKU_POPUP_MNG] = param1;
      }
      
      public static function getPopupMng() : FSPopupMng
      {
         return mCatalog[SKU_POPUP_MNG];
      }
      
      public static function registerTextParticlesMng(param1:TextParticlesMng) : void
      {
         mCatalog[SKU_TEXT_PARTICLES_MNG] = param1;
      }
      
      public static function getTextParticlesMng() : TextParticlesMng
      {
         return mCatalog[SKU_TEXT_PARTICLES_MNG];
      }
      
      public static function registerCardAnimsMng(param1:FSCardAnimsMng) : void
      {
         mCatalog[SKU_CARD_ANIMS_MNG] = param1;
      }
      
      public static function getCardAnimsMng() : FSCardAnimsMng
      {
         return mCatalog[SKU_CARD_ANIMS_MNG];
      }
      
      public static function registerScoreMng(param1:ScoreMng) : void
      {
         mCatalog[SKU_SCORE_MNG] = param1;
      }
      
      public static function getScoreMng() : ScoreMng
      {
         return mCatalog[SKU_SCORE_MNG];
      }
      
      public static function registerCurrentScreen(param1:Screen) : void
      {
         mCatalog[SKU_CURRENT_SCREEN] = param1;
      }
      
      public static function getCurrentScreen() : Screen
      {
         return mCatalog[SKU_CURRENT_SCREEN];
      }
      
      public static function getBattleEngine() : BattleEngine
      {
         var _loc1_:BattleEngine = null;
         var _loc2_:Screen = getCurrentScreen();
         if(_loc2_ != null && _loc2_ is FSBattleScreen)
         {
            _loc1_ = FSBattleScreen(_loc2_).getBattleEngine();
         }
         return _loc1_;
      }
      
      public static function registerApplication(param1:Main) : void
      {
         mCatalog[SKU_APPLICATION] = param1;
      }
      
      public static function getApplication() : Main
      {
         return mCatalog[SKU_APPLICATION];
      }
      
      public static function registerLogPanel(param1:FSLogPanel) : void
      {
         mCatalog[SKU_LOG_PANEL] = param1;
      }
      
      public static function getLogPanel() : FSLogPanel
      {
         return mCatalog[SKU_LOG_PANEL];
      }
      
      public static function registerAbilitiesDefMng(param1:AbilitiesDefMng) : void
      {
         mCatalog[SKU_ABILITIES_DEF_MNG] = param1;
      }
      
      public static function getAbilitiesDefMng() : AbilitiesDefMng
      {
         return mCatalog[SKU_ABILITIES_DEF_MNG];
      }
      
      public static function registerActionsDefMng(param1:ActionsDefMng) : void
      {
         mCatalog[SKU_ACTIONS_DEF_MNG] = param1;
      }
      
      public static function getActionsDefMng() : ActionsDefMng
      {
         return mCatalog[SKU_ACTIONS_DEF_MNG];
      }
      
      public static function registerAttachmentsDefMng(param1:AttachmentsDefMng) : void
      {
         mCatalog[SKU_ATTACHMENTS_DEF_MNG] = param1;
      }
      
      public static function getAttachmentsDefMng() : AttachmentsDefMng
      {
         return mCatalog[SKU_ATTACHMENTS_DEF_MNG];
      }
      
      public static function registerUnitsDefMng(param1:UnitsDefMng) : void
      {
         mCatalog[SKU_UNITS_DEF_MNG] = param1;
      }
      
      public static function getUnitsDefMng() : UnitsDefMng
      {
         return mCatalog[SKU_UNITS_DEF_MNG];
      }
      
      public static function registerCategoriesDefMng(param1:CategoriesDefMng) : void
      {
         mCatalog[SKU_CATEGORIES_DEF_MNG] = param1;
      }
      
      public static function getCategoriesDefMng() : CategoriesDefMng
      {
         return mCatalog[SKU_CATEGORIES_DEF_MNG];
      }
      
      public static function registerEditionsDefMng(param1:EditionsDefMng) : void
      {
         mCatalog[SKU_EDITIONS_DEF_MNG] = param1;
      }
      
      public static function getEditionsDefMng() : EditionsDefMng
      {
         return mCatalog[SKU_EDITIONS_DEF_MNG];
      }
      
      public static function registerFactionsDefMng(param1:FactionsDefMng) : void
      {
         mCatalog[SKU_FACTIONS_DEF_MNG] = param1;
      }
      
      public static function getFactionsDefMng() : FactionsDefMng
      {
         return mCatalog[SKU_FACTIONS_DEF_MNG];
      }
      
      public static function registerRaritiesDefMng(param1:RaritiesDefMng) : void
      {
         mCatalog[SKU_RARITIES_DEF_MNG] = param1;
      }
      
      public static function getRaritiesDefMng() : RaritiesDefMng
      {
         return mCatalog[SKU_RARITIES_DEF_MNG];
      }
      
      public static function registerSubCategoriesDefMng(param1:SubCategoriesDefMng) : void
      {
         mCatalog[SKU_SUBCATEGORIES_DEF_MNG] = param1;
      }
      
      public static function getSubCategoriesDefMng() : SubCategoriesDefMng
      {
         return mCatalog[SKU_SUBCATEGORIES_DEF_MNG];
      }
      
      public static function registerLevelsDefMng(param1:LevelDefMng) : void
      {
         mCatalog[SKU_LEVELS_DEF_MNG] = param1;
      }
      
      public static function getLevelsDefMng() : LevelDefMng
      {
         return mCatalog[SKU_LEVELS_DEF_MNG];
      }
      
      public static function registerGameModesDefMng(param1:GameModesDefMng) : void
      {
         mCatalog[SKU_GAME_MODES_DEF_MNG] = param1;
      }
      
      public static function getGameModesDefMng() : GameModesDefMng
      {
         return mCatalog[SKU_GAME_MODES_DEF_MNG];
      }
      
      public static function registerCardsDefMng(param1:CardDefMng) : void
      {
         mCatalog[SKU_CARDS_DEF_MNG] = param1;
      }
      
      public static function getCardsDefMng() : CardDefMng
      {
         return mCatalog[SKU_CARDS_DEF_MNG];
      }
      
      public static function registerRestrictionsDefMng(param1:RestrictionsDefMng) : void
      {
         mCatalog[SKU_RESTRICTIONS_DEF_MNG] = param1;
      }
      
      public static function getRestrictionsDefMng() : RestrictionsDefMng
      {
         return mCatalog[SKU_RESTRICTIONS_DEF_MNG];
      }
      
      public static function registerBackgroundDefMng(param1:BackgroundDefMng) : void
      {
         mCatalog[SKU_BACKGROUND_DEF_MNG] = param1;
      }
      
      public static function getBackgroundDefMng() : BackgroundDefMng
      {
         return mCatalog[SKU_BACKGROUND_DEF_MNG];
      }
      
      public static function registerMapsDefMng(param1:MapsDefMng) : void
      {
         mCatalog[SKU_MAPS_DEF_MNG] = param1;
      }
      
      public static function getMapsDefMng() : MapsDefMng
      {
         return mCatalog[SKU_MAPS_DEF_MNG];
      }
      
      public static function registerRewardsDefMng(param1:RewardsDefMng) : void
      {
         mCatalog[SKU_REWARDS_DEF_MNG] = param1;
      }
      
      public static function getRewardsDefMng() : RewardsDefMng
      {
         return mCatalog[SKU_REWARDS_DEF_MNG];
      }
      
      public static function registerAIMovementsDefMng(param1:AIMovementsDefMng) : void
      {
         mCatalog[SKU_AIMOVEMENTS_DEF_MNG] = param1;
      }
      
      public static function getAIMovementsDefMng() : AIMovementsDefMng
      {
         return mCatalog[SKU_AIMOVEMENTS_DEF_MNG];
      }
      
      public static function registerGameScoresDefMng(param1:GameScoreDefMng) : void
      {
         mCatalog[SKU_GAMESCORES_DEF_MNG] = param1;
      }
      
      public static function getGameScoresDefMng() : GameScoreDefMng
      {
         return mCatalog[SKU_GAMESCORES_DEF_MNG];
      }
      
      public static function registerTurnScoresDefMng(param1:TurnScoresDefMng) : void
      {
         mCatalog[SKU_TURNCORES_DEF_MNG] = param1;
      }
      
      public static function getTurnScoresDefMng() : TurnScoresDefMng
      {
         return mCatalog[SKU_TURNCORES_DEF_MNG];
      }
      
      public static function registerBoostsDefMng(param1:BoostsDefMng) : void
      {
         mCatalog[SKU_BOOSTS_DEF_MNG] = param1;
      }
      
      public static function getBoostsDefMng() : BoostsDefMng
      {
         return mCatalog[SKU_BOOSTS_DEF_MNG];
      }
      
      public static function registerShopBoostsDefMng(param1:ShopBoostDefMng) : void
      {
         mCatalog[SKU_SHOP_BOOSTS_DEF_MNG] = param1;
      }
      
      public static function getShopBoostsDefMng() : ShopBoostDefMng
      {
         return mCatalog[SKU_SHOP_BOOSTS_DEF_MNG];
      }
      
      public static function registerRanksDefMng(param1:RanksDefMng) : void
      {
         mCatalog[SKU_RANKS_DEF_MNG] = param1;
      }
      
      public static function getRanksDefMng() : RanksDefMng
      {
         return mCatalog[SKU_RANKS_DEF_MNG];
      }
      
      public static function registerTargetMng(param1:TargetMng) : void
      {
         mCatalog[SKU_TARGET_MNG] = param1;
      }
      
      public static function getTargetMng() : TargetMng
      {
         return mCatalog[SKU_TARGET_MNG];
      }
      
      public static function registerResourcesMng(param1:FSResourceMng) : void
      {
         mCatalog[SKU_RESOURCES_MNG] = param1;
      }
      
      public static function getResourcesMng() : FSResourceMng
      {
         return mCatalog[SKU_RESOURCES_MNG];
      }
      
      public static function registerBoostsMng(param1:BoostsMng) : void
      {
         mCatalog[SKU_BOOSTS_MNG] = param1;
      }
      
      public static function getBoostsMng() : BoostsMng
      {
         return mCatalog[SKU_BOOSTS_MNG];
      }
      
      public static function registerTutorialMng(param1:TutorialMng) : void
      {
         mCatalog[SKU_TUTORIAL_MNG] = param1;
      }
      
      public static function getTutorialMng() : TutorialMng
      {
         return mCatalog[SKU_TUTORIAL_MNG];
      }
      
      public static function registerTutorialDeckBuilderMng(param1:TutorialDeckBuilderMng) : void
      {
         mCatalog[SKU_TUTORIAL_DECK_BUILDER_MNG] = param1;
      }
      
      public static function getTutorialDeckBuilderMng() : TutorialDeckBuilderMng
      {
         return mCatalog[SKU_TUTORIAL_DECK_BUILDER_MNG];
      }
      
      public static function registerTutorialMapMng(param1:TutorialMapMng) : void
      {
         mCatalog[SKU_TUTORIAL_MAP_MNG] = param1;
      }
      
      public static function getTutorialMapMng() : TutorialMapMng
      {
         return mCatalog[SKU_TUTORIAL_MAP_MNG];
      }
      
      public static function registerConversationsMng(param1:ConversationsMng) : void
      {
         mCatalog[SKU_CONVERSATIONS_MNG] = param1;
      }
      
      public static function getConversationsMng() : ConversationsMng
      {
         return mCatalog[SKU_CONVERSATIONS_MNG];
      }
      
      public static function registerComicsMng(param1:ComicMng) : void
      {
         mCatalog[SKU_COMICS_MNG] = param1;
      }
      
      public static function getComicsMng() : ComicMng
      {
         return mCatalog[SKU_COMICS_MNG];
      }
      
      public static function registerSoundFXMng(param1:FSSoundFXMng) : void
      {
         mCatalog[SKU_SOUND_FX_MNG] = param1;
      }
      
      public static function getSoundFXMng() : FSSoundFXMng
      {
         return mCatalog[SKU_SOUND_FX_MNG];
      }
      
      public static function registerCardsMng(param1:FSCardsMng) : void
      {
         mCatalog[SKU_CARDS_MNG] = param1;
      }
      
      public static function getCardsMng() : FSCardsMng
      {
         return mCatalog[SKU_CARDS_MNG];
      }
      
      public static function registerPacksDefMng(param1:PacksDefMng) : void
      {
         mCatalog[SKU_PACKS_DEF_MNG] = param1;
      }
      
      public static function getPacksDefMng() : PacksDefMng
      {
         return mCatalog[SKU_PACKS_DEF_MNG];
      }
      
      public static function registerWorldsDefMng(param1:WorldsDefMng) : void
      {
         mCatalog[SKU_WORLDS_DEF_MNG] = param1;
      }
      
      public static function getWorldsDefMng() : WorldsDefMng
      {
         return mCatalog[SKU_WORLDS_DEF_MNG];
      }
      
      public static function registerBundlesDefMng(param1:BundlesDefMng) : void
      {
         mCatalog[SKU_BUNDLES_DEF_MNG] = param1;
      }
      
      public static function getBundlesDefMng() : BundlesDefMng
      {
         return mCatalog[SKU_BUNDLES_DEF_MNG];
      }
      
      public static function registerTutorialDefMng(param1:TutorialDefMng) : void
      {
         mCatalog[SKU_TUTORIAL_DEF_MNG] = param1;
      }
      
      public static function getTutorialDefMng() : TutorialDefMng
      {
         return mCatalog[SKU_TUTORIAL_DEF_MNG];
      }
      
      public static function registerTutorialDeckBuilderDefMng(param1:TutorialDeckBuilderDefMng) : void
      {
         mCatalog[SKU_TUTORIAL_DECK_BUILDER_DEF_MNG] = param1;
      }
      
      public static function getTutorialDeckBuilderDefMng() : TutorialDeckBuilderDefMng
      {
         return mCatalog[SKU_TUTORIAL_DECK_BUILDER_DEF_MNG];
      }
      
      public static function registerTutorialMapDefMng(param1:TutorialMapDefMng) : void
      {
         mCatalog[SKU_TUTORIAL_MAP_DEF_MNG] = param1;
      }
      
      public static function getTutorialMapDefMng() : TutorialMapDefMng
      {
         return mCatalog[SKU_TUTORIAL_MAP_DEF_MNG];
      }
      
      public static function registerKickstarterBackersDefMng(param1:KickstarterBackerDefMng) : void
      {
         mCatalog[SKU_KICKSTARTER_BACKERS_DEF_MNG] = param1;
      }
      
      public static function getKickstarterBackersDefMng() : KickstarterBackerDefMng
      {
         return mCatalog[SKU_KICKSTARTER_BACKERS_DEF_MNG];
      }
      
      public static function registerHeroCharactersDefMng(param1:HeroCharacterDefMng) : void
      {
         mCatalog[SKU_HERO_CHARACTERS_DEF_MNG] = param1;
      }
      
      public static function getHeroCharactersDefMng() : HeroCharacterDefMng
      {
         return mCatalog[SKU_HERO_CHARACTERS_DEF_MNG];
      }
      
      public static function registerConversationsDefMng(param1:ConversationsDefMng) : void
      {
         mCatalog[SKU_CONVERSATIONS_DEF_MNG] = param1;
      }
      
      public static function getConversationsDefMng() : ConversationsDefMng
      {
         return mCatalog[SKU_CONVERSATIONS_DEF_MNG];
      }
      
      public static function registerComicStripsDefMng(param1:ComicStripsDefMng) : void
      {
         mCatalog[SKU_COMIC_STRIPS_DEF_MNG] = param1;
      }
      
      public static function getComicStripsDefMng() : ComicStripsDefMng
      {
         return mCatalog[SKU_COMIC_STRIPS_DEF_MNG];
      }
      
      public static function registerDeckSlotsDefMng(param1:DeckSlotDefMng) : void
      {
         mCatalog[SKU_DECK_SLOTS_DEF_MNG] = param1;
      }
      
      public static function getDeckSlotsDefMng() : DeckSlotDefMng
      {
         return mCatalog[SKU_DECK_SLOTS_DEF_MNG];
      }
      
      public static function registerPortraitsDefMng(param1:PortraitsDefMng) : void
      {
         mCatalog[SKU_PORTRAITS_DEF_MNG] = param1;
      }
      
      public static function getPortraitsDefMng() : PortraitsDefMng
      {
         return mCatalog[SKU_PORTRAITS_DEF_MNG];
      }
      
      public static function registerDailyRewardsDefMng(param1:DailyRewardsDefMng) : void
      {
         mCatalog[SKU_DAILY_REWARDS_MNG] = param1;
      }
      
      public static function getDailyRewardsDefMng() : DailyRewardsDefMng
      {
         return mCatalog[SKU_DAILY_REWARDS_MNG];
      }
      
      public static function registerFacebookPlugin(param1:FSFacebookPlugin) : void
      {
         mCatalog[SKU_FACEBOOK_PLUGIN] = param1;
      }
      
      public static function getFacebookPlugin() : FSFacebookPlugin
      {
         return mCatalog[SKU_FACEBOOK_PLUGIN];
      }
      
      public static function registerResourceDefMng(param1:ResourceDefMng) : void
      {
         mCatalog[SKU_RESOURCES_DEF_MNG] = param1;
      }
      
      public static function getResourceDefMng() : ResourceDefMng
      {
         return mCatalog[SKU_RESOURCES_DEF_MNG];
      }
      
      public static function registerConfigDefMng(param1:ConfigDefMng) : void
      {
         mCatalog[SKU_CONFIG_DEF_MNG] = param1;
      }
      
      public static function getConfigDefMng() : ConfigDefMng
      {
         return mCatalog[SKU_CONFIG_DEF_MNG];
      }
      
      public static function registerAuctionTicketsDefMng(param1:AuctionTicketsDefMng) : void
      {
         mCatalog[SKU_AUCTION_TICKETS_DEF_MNG] = param1;
      }
      
      public static function registerDungeonRewardsDefMng(param1:DungeonRewardsDefMng) : void
      {
         mCatalog[SKU_DUNGEON_REWARDS_DEF_MNG] = param1;
      }
      
      public static function getDungeonRewardsDefMng() : DungeonRewardsDefMng
      {
         return mCatalog[SKU_DUNGEON_REWARDS_DEF_MNG];
      }
      
      public static function registerPvPRewardsDefMng(param1:PvPRewardsDefMng) : void
      {
         mCatalog[SKU_PVP_REWARDS_DEF_MNG] = param1;
      }
      
      public static function getPvPRewardsDefMng() : PvPRewardsDefMng
      {
         return mCatalog[SKU_PVP_REWARDS_DEF_MNG];
      }
      
      public static function getAuctionTicketsDefMng() : AuctionTicketsDefMng
      {
         return mCatalog[SKU_AUCTION_TICKETS_DEF_MNG];
      }
      
      public static function registerGoldDefMng(param1:GoldDefMng) : void
      {
         mCatalog[SKU_GOLD_DEF_MNG] = param1;
      }
      
      public static function getGoldDefMng() : GoldDefMng
      {
         return mCatalog[SKU_GOLD_DEF_MNG];
      }
      
      public static function registerBadgesDefMng(param1:BadgesDefMng) : void
      {
         mCatalog[SKU_BADGES_DEF_MNG] = param1;
      }
      
      public static function getBadgesDefMng() : BadgesDefMng
      {
         return mCatalog[SKU_BADGES_DEF_MNG];
      }
      
      public static function registerStarsRewardsDefMng(param1:StarsRewardsDefMng) : void
      {
         mCatalog[SKU_STARS_REWARDS_DEF_MNG] = param1;
      }
      
      public static function getStarsRewardsDefMng() : StarsRewardsDefMng
      {
         return mCatalog[SKU_STARS_REWARDS_DEF_MNG];
      }
      
      public static function registerJobsDefMng(param1:JobsDefMng) : void
      {
         mCatalog[SKU_JOBS_DEF_MNG] = param1;
      }
      
      public static function getJobsDefMng() : JobsDefMng
      {
         return mCatalog[SKU_JOBS_DEF_MNG];
      }
      
      public static function registerJobLevelsDefMng(param1:JobLevelsDefMng) : void
      {
         mCatalog[SKU_JOB_LEVELS_DEF_MNG] = param1;
      }
      
      public static function getJobLevelsDefMng() : JobLevelsDefMng
      {
         return mCatalog[SKU_JOB_LEVELS_DEF_MNG];
      }
      
      public static function registerJobRewardsDefMng(param1:JobRewardsDefMng) : void
      {
         mCatalog[SKU_JOB_REWARDS_DEF_MNG] = param1;
      }
      
      public static function getJobRewardsDefMng() : JobRewardsDefMng
      {
         return mCatalog[SKU_JOB_REWARDS_DEF_MNG];
      }
      
      public static function registerDungeonsDefMng(param1:DungeonsDefMng) : void
      {
         mCatalog[SKU_DUNGEONS_DEF_MNG] = param1;
      }
      
      public static function registerRaidsDefMng(param1:RaidsDefMng) : void
      {
         mCatalog[SKU_RAIDS_DEF_MNG] = param1;
      }
      
      public static function getDungeonsDefMng() : DungeonsDefMng
      {
         return mCatalog[SKU_DUNGEONS_DEF_MNG];
      }
      
      public static function getRaidsDefMng() : RaidsDefMng
      {
         return mCatalog[SKU_RAIDS_DEF_MNG];
      }
      
      public static function registerDungeonLevelsDefMng(param1:DungeonLevelsDefMng) : void
      {
         mCatalog[SKU_DUNGEON_LEVELS_DEF_MNG] = param1;
      }
      
      public static function registerRaidLevelsDefMng(param1:RaidLevelsDefMng) : void
      {
         mCatalog[SKU_RAID_LEVELS_DEF_MNG] = param1;
      }
      
      public static function registerBattleEventDefMng(param1:BattleEventDefMng) : void
      {
         mCatalog[SKU_BATTLE_EVENT_DEF_MNG] = param1;
      }
      
      public static function getBattleEventDefMng() : BattleEventDefMng
      {
         return mCatalog[SKU_BATTLE_EVENT_DEF_MNG];
      }
      
      public static function registerPassiveAbilityDefMng(param1:PassiveAbilityDefMng) : void
      {
         mCatalog[SKU_PASSIVE_ABILITY_DEF_MNG] = param1;
      }
      
      public static function getPassiveAbilityDefMng() : PassiveAbilityDefMng
      {
         return mCatalog[SKU_PASSIVE_ABILITY_DEF_MNG];
      }
      
      public static function getDungeonLevelsDefMng() : DungeonLevelsDefMng
      {
         return mCatalog[SKU_DUNGEON_LEVELS_DEF_MNG];
      }
      
      public static function getRaidLevelsDefMng() : RaidLevelsDefMng
      {
         return mCatalog[SKU_RAID_LEVELS_DEF_MNG];
      }
      
      public static function registerRaidsMng(param1:RaidsMng) : void
      {
         mCatalog[SKU_RAIDS_MNG] = param1;
      }
      
      public static function getRaidsMng() : RaidsMng
      {
         return mCatalog[SKU_RAIDS_MNG];
      }
      
      public static function registerAuctionsMng(param1:AuctionsMng) : void
      {
         mCatalog[SKU_AUCTIONS_MNG] = param1;
      }
      
      public static function getAuctionsMng() : AuctionsMng
      {
         return mCatalog[SKU_AUCTIONS_MNG];
      }
      
      public static function registerDungeonsMng(param1:DungeonsMng) : void
      {
         mCatalog[SKU_DUNGEONS_MNG] = param1;
      }
      
      public static function getDungeonsMng() : DungeonsMng
      {
         return mCatalog[SKU_DUNGEONS_MNG];
      }
      
      public static function registerGuildsMng(param1:GuildsMng) : void
      {
         mCatalog[SKU_GUILDS_MNG] = param1;
      }
      
      public static function getGuildsMng() : GuildsMng
      {
         return mCatalog[SKU_GUILDS_MNG];
      }
      
      public static function registerPowersDefMng(param1:PowersDefMng) : void
      {
         mCatalog[SKU_POWERS_DEF_MNG] = param1;
      }
      
      public static function getPowerDefMng() : PowersDefMng
      {
         return mCatalog[SKU_POWERS_DEF_MNG];
      }
      
      public static function registerQuestShopDefMng(param1:QuestShopDefMng) : void
      {
         mCatalog[SKU_QUEST_SHOP_DEF_MNG] = param1;
      }
      
      public static function registerRaidShopDefMng(param1:RaidShopDefMng) : void
      {
         mCatalog[SKU_RAID_SHOP_DEF_MNG] = param1;
      }
      
      public static function getQuestShopDefMng() : QuestShopDefMng
      {
         return mCatalog[SKU_QUEST_SHOP_DEF_MNG];
      }
      
      public static function getRaidShopDefMng() : RaidShopDefMng
      {
         return mCatalog[SKU_RAID_SHOP_DEF_MNG];
      }
      
      public static function registerQuestsDefMng(param1:QuestsDefMng) : void
      {
         mCatalog[SKU_QUESTS_DEF_MNG] = param1;
      }
      
      public static function getQuestsDefMng() : QuestsDefMng
      {
         return mCatalog[SKU_QUESTS_DEF_MNG];
      }
      
      public static function registerQuestsMng(param1:QuestsMng) : void
      {
         mCatalog[SKU_QUESTS_MNG] = param1;
      }
      
      public static function getQuestsMng() : QuestsMng
      {
         return mCatalog[SKU_QUESTS_MNG];
      }
      
      public static function registerPvPBotDecksDefMng(param1:PvPBotDecksDefMng) : void
      {
         mCatalog[SKU_PVP_BOT_DECKS_DEF_MNG] = param1;
      }
      
      public static function getPvPBotDecksDefMng() : PvPBotDecksDefMng
      {
         return mCatalog[SKU_PVP_BOT_DECKS_DEF_MNG];
      }
      
      public static function registerGroupIdsDefMng(param1:GroupIdsDefMng) : void
      {
         mCatalog[SKU_GROUP_IDS_DEF_MNG] = param1;
      }
      
      public static function getGroupIdsDefMng() : GroupIdsDefMng
      {
         return mCatalog[SKU_GROUP_IDS_DEF_MNG];
      }
      
      public function registerInstance(param1:String, param2:*) : void
      {
         mCatalog[param1] = param2;
      }
      
      public function getInstance(param1:String) : *
      {
         return mCatalog[param1];
      }
   }
}

