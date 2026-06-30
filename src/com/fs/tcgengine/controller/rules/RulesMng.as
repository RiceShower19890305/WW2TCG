package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.resources.FSResourceMng;
   import flash.utils.setTimeout;
   
   public class RulesMng extends DefMng
   {
      
      private const DEFINITIONS_PREFIX:String = "definitions/";
      
      private var mDefaultDefsRead:Boolean = false;
      
      private var mOnDefaultDefsCompleteFunction:Function;
      
      public function RulesMng(param1:Function)
      {
         this.mOnDefaultDefsCompleteFunction = param1;
         super("");
      }
      
      override protected function readDefaultDefs() : void
      {
         var editionsDefMng:EditionsDefMng;
         var configDefMng:ConfigDefMng;
         var createCardsDefMng:Function = null;
         var createUnitsDefMng:Function = null;
         var createActionsDefMng:Function = null;
         var createAttachmentsDefMng:Function = null;
         var createPowersDefMng:Function = null;
         var createLevelsDefMng:Function = null;
         var createGameModesDefMng:Function = null;
         var createMapsDefMng:Function = null;
         var createBoostsDefMng:Function = null;
         var createRanksDefMng:Function = null;
         var createRewardsDefMng:Function = null;
         var createPacksDefMng:Function = null;
         var createBundlesDefMng:Function = null;
         var createQuestShopDefMng:Function = null;
         var createRaidShopDefMng:Function = null;
         var createTutorialDefMng:Function = null;
         var createTutorialDeckBuilderDefMng:Function = null;
         var createAbilitiesDefMng:Function = null;
         var createResourcesDefMng:Function = null;
         var createGoldDefMng:Function = null;
         var createAuctionTicketsDefMng:Function = null;
         var createPvPRewardsDefMng:Function = null;
         var createDungeonRewardsDefMng:Function = null;
         var createBadgesDefMng:Function = null;
         var createShopBoostsDefMng:Function = null;
         var createDeckSlotsDefMng:Function = null;
         var createDungeonsDefMng:Function = null;
         var createRaidsDefMng:Function = null;
         var createDungeonLevelsDefMng:Function = null;
         var createRaidLevelsDefMng:Function = null;
         var createEventBattlesDefMng:Function = null;
         var createPassiveAbilitiesDefMng:Function = null;
         var createTutorialMapDefMng:Function = null;
         var createQuestsDefMng:Function = null;
         var createPvPBotDecksDefMng:Function = null;
         var createJobsDefMng:Function = null;
         var createJobLevelsDefMng:Function = null;
         var createJobRewardsDefMng:Function = null;
         var createWorldsDefMng:Function = null;
         var createGroupIdsDefMng:Function = null;
         var createCategoriesDefMng:Function = null;
         var createFactionsDefMng:Function = null;
         var createSubcategoriesDefMng:Function = null;
         var createRestrictionsDefMng:Function = null;
         var createBackgroundsDefMng:Function = null;
         var createAIMovementsDefMng:Function = null;
         var createGameScoresDefMng:Function = null;
         var createTurnScoresDefMng:Function = null;
         var createHeroCharactersDefMng:Function = null;
         var createConversationsDefMng:Function = null;
         var createComicsDefMng:Function = null;
         var createPortraitsDefMng:Function = null;
         var createDailyRewardsDefMng:Function = null;
         var createKickstartedDefMng:Function = null;
         var createStarsRewardsDefMng:Function = null;
         createCardsDefMng = function():void
         {
            var _loc1_:CardDefMng = new CardDefMng("");
            InstanceMng.registerCardsDefMng(_loc1_);
            setTimeout(createUnitsDefMng,20);
         };
         createUnitsDefMng = function():void
         {
            var _loc1_:UnitsDefMng = new UnitsDefMng(FSResourceMng.ID_RULES_UNITS_DEFINITIONS);
            InstanceMng.registerUnitsDefMng(_loc1_);
            setTimeout(createActionsDefMng,20);
         };
         createActionsDefMng = function():void
         {
            var _loc1_:ActionsDefMng = new ActionsDefMng(FSResourceMng.ID_RULES_ACTIONS_DEFINITIONS);
            InstanceMng.registerActionsDefMng(_loc1_);
            setTimeout(createAttachmentsDefMng,20);
         };
         createAttachmentsDefMng = function():void
         {
            var _loc1_:AttachmentsDefMng = new AttachmentsDefMng(FSResourceMng.ID_RULES_ATTACHMENTS_DEFINITIONS);
            InstanceMng.registerAttachmentsDefMng(_loc1_);
            setTimeout(createPowersDefMng,20);
         };
         createPowersDefMng = function():void
         {
            var _loc1_:PowersDefMng = new PowersDefMng(FSResourceMng.ID_RULES_POWERS_DEFINITIONS);
            InstanceMng.registerPowersDefMng(_loc1_);
            setTimeout(createLevelsDefMng,20);
         };
         createLevelsDefMng = function():void
         {
            var _loc1_:LevelDefMng = new LevelDefMng(FSResourceMng.ID_RULES_LEVEL_DEFINITIONS);
            InstanceMng.registerLevelsDefMng(_loc1_);
            setTimeout(createGameModesDefMng,20);
         };
         createGameModesDefMng = function():void
         {
            var _loc1_:GameModesDefMng = new GameModesDefMng(FSResourceMng.ID_RULES_GAME_MODES_DEFINITIONS);
            InstanceMng.registerGameModesDefMng(_loc1_);
            setTimeout(createMapsDefMng,20);
         };
         createMapsDefMng = function():void
         {
            var _loc1_:MapsDefMng = new MapsDefMng(FSResourceMng.ID_RULES_MAPS_DEFINITIONS);
            InstanceMng.registerMapsDefMng(_loc1_);
            setTimeout(createBoostsDefMng,20);
         };
         createBoostsDefMng = function():void
         {
            var _loc1_:BoostsDefMng = new BoostsDefMng(FSResourceMng.ID_RULES_BOOSTS_DEFINITIONS);
            InstanceMng.registerBoostsDefMng(_loc1_);
            setTimeout(createRanksDefMng,20);
         };
         createRanksDefMng = function():void
         {
            var _loc1_:RanksDefMng = new RanksDefMng(FSResourceMng.ID_RULES_RANKS_DEFINITIONS);
            InstanceMng.registerRanksDefMng(_loc1_);
            setTimeout(createRewardsDefMng,20);
         };
         createRewardsDefMng = function():void
         {
            var _loc1_:RewardsDefMng = new RewardsDefMng(FSResourceMng.ID_RULES_REWARDS_DEFINITIONS);
            InstanceMng.registerRewardsDefMng(_loc1_);
            setTimeout(createPacksDefMng,20);
         };
         createPacksDefMng = function():void
         {
            var _loc1_:PacksDefMng = new PacksDefMng(FSResourceMng.ID_RULES_PACKS_DEFINITIONS);
            InstanceMng.registerPacksDefMng(_loc1_);
            setTimeout(createBundlesDefMng,20);
         };
         createBundlesDefMng = function():void
         {
            var _loc1_:BundlesDefMng = new BundlesDefMng(FSResourceMng.ID_RULES_BUNDLES_DEFINITIONS);
            InstanceMng.registerBundlesDefMng(_loc1_);
            setTimeout(createQuestShopDefMng,20);
         };
         createQuestShopDefMng = function():void
         {
            var _loc1_:QuestShopDefMng = new QuestShopDefMng(FSResourceMng.ID_RULES_QUEST_SHOP_DEFINITIONS);
            InstanceMng.registerQuestShopDefMng(_loc1_);
            setTimeout(createRaidShopDefMng,20);
         };
         createRaidShopDefMng = function():void
         {
            var _loc1_:RaidShopDefMng = new RaidShopDefMng(FSResourceMng.ID_RULES_RAID_SHOP_DEFINITIONS);
            InstanceMng.registerRaidShopDefMng(_loc1_);
            setTimeout(createTutorialDefMng,20);
         };
         createTutorialDefMng = function():void
         {
            var _loc1_:TutorialDefMng = new TutorialDefMng(FSResourceMng.ID_RULES_TUTORIAL_DEFINITIONS);
            InstanceMng.registerTutorialDefMng(_loc1_);
            setTimeout(createTutorialDeckBuilderDefMng,20);
         };
         createTutorialDeckBuilderDefMng = function():void
         {
            var _loc1_:TutorialDeckBuilderDefMng = new TutorialDeckBuilderDefMng(FSResourceMng.ID_RULES_TUTORIAL_DECK_BUILDER_DEFINITIONS);
            InstanceMng.registerTutorialDeckBuilderDefMng(_loc1_);
            setTimeout(createAbilitiesDefMng,20);
         };
         createAbilitiesDefMng = function():void
         {
            var _loc1_:AbilitiesDefMng = new AbilitiesDefMng(FSResourceMng.ID_RULES_ABILITIES_DEFINITIONS);
            InstanceMng.registerAbilitiesDefMng(_loc1_);
            setTimeout(createResourcesDefMng,20);
         };
         createResourcesDefMng = function():void
         {
            var _loc1_:ResourceDefMng = new ResourceDefMng(FSResourceMng.ID_RULES_RESOURCES_DEFINITIONS);
            InstanceMng.registerResourceDefMng(_loc1_);
            setTimeout(createGoldDefMng,20);
         };
         createGoldDefMng = function():void
         {
            var _loc1_:GoldDefMng = new GoldDefMng(FSResourceMng.ID_RULES_GOLD_DEFINITIONS);
            InstanceMng.registerGoldDefMng(_loc1_);
            setTimeout(createAuctionTicketsDefMng,20);
         };
         createAuctionTicketsDefMng = function():void
         {
            var _loc1_:AuctionTicketsDefMng = new AuctionTicketsDefMng(FSResourceMng.ID_RULES_AUCTION_TICKETS_DEFINITIONS);
            InstanceMng.registerAuctionTicketsDefMng(_loc1_);
            setTimeout(createPvPRewardsDefMng,20);
         };
         createPvPRewardsDefMng = function():void
         {
            var _loc1_:PvPRewardsDefMng = new PvPRewardsDefMng(FSResourceMng.ID_RULES_PVP_REWARDS_DEFINITIONS);
            InstanceMng.registerPvPRewardsDefMng(_loc1_);
            setTimeout(createDungeonRewardsDefMng,20);
         };
         createDungeonRewardsDefMng = function():void
         {
            var _loc1_:DungeonRewardsDefMng = new DungeonRewardsDefMng(FSResourceMng.ID_RULES_DUNGEON_REWARDS_DEFINITIONS);
            InstanceMng.registerDungeonRewardsDefMng(_loc1_);
            setTimeout(createBadgesDefMng,20);
         };
         createBadgesDefMng = function():void
         {
            var _loc1_:BadgesDefMng = new BadgesDefMng(FSResourceMng.ID_RULES_BADGES_DEFINITIONS);
            InstanceMng.registerBadgesDefMng(_loc1_);
            setTimeout(createShopBoostsDefMng,20);
         };
         createShopBoostsDefMng = function():void
         {
            var _loc1_:ShopBoostDefMng = new ShopBoostDefMng(FSResourceMng.ID_RULES_SHOP_BOOSTS_DEFINITIONS);
            InstanceMng.registerShopBoostsDefMng(_loc1_);
            setTimeout(createDeckSlotsDefMng,20);
         };
         createDeckSlotsDefMng = function():void
         {
            var _loc1_:DeckSlotDefMng = new DeckSlotDefMng(FSResourceMng.ID_DECK_SLOTS_DEFINITIONS);
            InstanceMng.registerDeckSlotsDefMng(_loc1_);
            setTimeout(createDungeonsDefMng,20);
         };
         createDungeonsDefMng = function():void
         {
            var _loc1_:DungeonsDefMng = new DungeonsDefMng(FSResourceMng.ID_RULES_DUNGEONS_DEFINITIONS);
            InstanceMng.registerDungeonsDefMng(_loc1_);
            setTimeout(createRaidsDefMng,20);
         };
         createRaidsDefMng = function():void
         {
            var _loc1_:RaidsDefMng = new RaidsDefMng(FSResourceMng.ID_RULES_RAIDS_DEFINITIONS);
            InstanceMng.registerRaidsDefMng(_loc1_);
            setTimeout(createDungeonLevelsDefMng,20);
         };
         createDungeonLevelsDefMng = function():void
         {
            var _loc1_:DungeonLevelsDefMng = new DungeonLevelsDefMng(FSResourceMng.ID_RULES_DUNGEON_LEVELS_DEFINITIONS);
            InstanceMng.registerDungeonLevelsDefMng(_loc1_);
            setTimeout(createRaidLevelsDefMng,20);
         };
         createRaidLevelsDefMng = function():void
         {
            var _loc1_:RaidLevelsDefMng = new RaidLevelsDefMng(FSResourceMng.ID_RULES_RAID_LEVELS_DEFINITIONS);
            InstanceMng.registerRaidLevelsDefMng(_loc1_);
            setTimeout(createEventBattlesDefMng,20);
         };
         createEventBattlesDefMng = function():void
         {
            var _loc1_:BattleEventDefMng = new BattleEventDefMng(FSResourceMng.ID_RULES_EVENT_BATTLES_DEFINITIONS);
            InstanceMng.registerBattleEventDefMng(_loc1_);
            setTimeout(createPassiveAbilitiesDefMng,20);
         };
         createPassiveAbilitiesDefMng = function():void
         {
            var _loc1_:PassiveAbilityDefMng = new PassiveAbilityDefMng(FSResourceMng.ID_RULES_PASSIVE_ABILITY_DEFINITIONS);
            InstanceMng.registerPassiveAbilityDefMng(_loc1_);
            setTimeout(createTutorialMapDefMng,20);
         };
         createTutorialMapDefMng = function():void
         {
            var _loc1_:TutorialMapDefMng = new TutorialMapDefMng(FSResourceMng.ID_RULES_TUTORIAL_MAP_DEFINITIONS);
            InstanceMng.registerTutorialMapDefMng(_loc1_);
            setTimeout(createQuestsDefMng,20);
         };
         createQuestsDefMng = function():void
         {
            var _loc1_:QuestsDefMng = new QuestsDefMng(FSResourceMng.ID_RULES_QUESTS_DEFINITIONS);
            InstanceMng.registerQuestsDefMng(_loc1_);
            setTimeout(createPvPBotDecksDefMng,20);
         };
         createPvPBotDecksDefMng = function():void
         {
            var _loc1_:PvPBotDecksDefMng = new PvPBotDecksDefMng(FSResourceMng.ID_RULES_PVP_BOT_DECKS_DEFINITIONS);
            InstanceMng.registerPvPBotDecksDefMng(_loc1_);
            setTimeout(createJobsDefMng,20);
         };
         createJobsDefMng = function():void
         {
            var _loc1_:JobsDefMng = new JobsDefMng(FSResourceMng.ID_RULES_JOBS_DEFINITIONS);
            InstanceMng.registerJobsDefMng(_loc1_);
            setTimeout(createJobLevelsDefMng,20);
         };
         createJobLevelsDefMng = function():void
         {
            var _loc1_:JobLevelsDefMng = new JobLevelsDefMng(FSResourceMng.ID_RULES_JOB_LEVELS_DEFINITIONS);
            InstanceMng.registerJobLevelsDefMng(_loc1_);
            setTimeout(createJobRewardsDefMng,20);
         };
         createJobRewardsDefMng = function():void
         {
            var _loc1_:JobRewardsDefMng = new JobRewardsDefMng(FSResourceMng.ID_RULES_JOB_REWARDS_DEFINITIONS);
            InstanceMng.registerJobRewardsDefMng(_loc1_);
            setTimeout(createWorldsDefMng,20);
         };
         createWorldsDefMng = function():void
         {
            var _loc1_:WorldsDefMng = new WorldsDefMng(FSResourceMng.ID_RULES_WORLDS_DEFINITIONS);
            InstanceMng.registerWorldsDefMng(_loc1_);
            mDefaultDefsRead = true;
            setTimeout(createGroupIdsDefMng,20);
         };
         createGroupIdsDefMng = function():void
         {
            var _loc1_:GroupIdsDefMng = new GroupIdsDefMng(FSResourceMng.ID_RULES_GROUP_IDS_DEFINITIONS);
            InstanceMng.registerGroupIdsDefMng(_loc1_);
            setTimeout(createCategoriesDefMng,20);
         };
         createCategoriesDefMng = function():void
         {
            var _loc1_:CategoriesDefMng = new CategoriesDefMng(FSResourceMng.ID_RULES_CATEGORIES_DEFINITION);
            InstanceMng.registerCategoriesDefMng(_loc1_);
            setTimeout(createFactionsDefMng,20);
         };
         createFactionsDefMng = function():void
         {
            var _loc1_:FactionsDefMng = new FactionsDefMng(FSResourceMng.ID_RULES_FACTIONS_DEFINITIONS);
            InstanceMng.registerFactionsDefMng(_loc1_);
            setTimeout(createSubcategoriesDefMng,20);
         };
         createSubcategoriesDefMng = function():void
         {
            var _loc1_:SubCategoriesDefMng = new SubCategoriesDefMng(FSResourceMng.ID_RULES_SUBCATEGORIES_DEFINITIONS);
            InstanceMng.registerSubCategoriesDefMng(_loc1_);
            setTimeout(createRestrictionsDefMng,20);
         };
         createRestrictionsDefMng = function():void
         {
            var _loc1_:RestrictionsDefMng = new RestrictionsDefMng(FSResourceMng.ID_RULES_RESTRICTIONS_DEFINITIONS);
            InstanceMng.registerRestrictionsDefMng(_loc1_);
            setTimeout(createBackgroundsDefMng,20);
         };
         createBackgroundsDefMng = function():void
         {
            var _loc1_:BackgroundDefMng = new BackgroundDefMng(FSResourceMng.ID_RULES_BACKGROUNDS_DEFINITIONS);
            InstanceMng.registerBackgroundDefMng(_loc1_);
            setTimeout(createAIMovementsDefMng,20);
         };
         createAIMovementsDefMng = function():void
         {
            var _loc1_:AIMovementsDefMng = new AIMovementsDefMng(FSResourceMng.ID_RULES_AIMOVEMENTS_DEFINITIONS);
            InstanceMng.registerAIMovementsDefMng(_loc1_);
            setTimeout(createGameScoresDefMng,20);
         };
         createGameScoresDefMng = function():void
         {
            var _loc1_:GameScoreDefMng = new GameScoreDefMng(FSResourceMng.ID_RULES_GAMESCORES_DEFINITIONS);
            InstanceMng.registerGameScoresDefMng(_loc1_);
            setTimeout(createTurnScoresDefMng,20);
         };
         createTurnScoresDefMng = function():void
         {
            var _loc1_:TurnScoresDefMng = new TurnScoresDefMng(FSResourceMng.ID_RULES_TURNSCORES_DEFINITIONS);
            InstanceMng.registerTurnScoresDefMng(_loc1_);
            setTimeout(createHeroCharactersDefMng,20);
         };
         createHeroCharactersDefMng = function():void
         {
            var _loc1_:HeroCharacterDefMng = new HeroCharacterDefMng(FSResourceMng.ID_RULES_HERO_CHARACTERS_DEFINITIONS);
            InstanceMng.registerHeroCharactersDefMng(_loc1_);
            setTimeout(createConversationsDefMng,20);
         };
         createConversationsDefMng = function():void
         {
            var _loc1_:ConversationsDefMng = new ConversationsDefMng(FSResourceMng.ID_RULES_CONVERSATIONS_DEFINITIONS);
            InstanceMng.registerConversationsDefMng(_loc1_);
            setTimeout(createComicsDefMng,20);
         };
         createComicsDefMng = function():void
         {
            var _loc1_:ComicStripsDefMng = null;
            if(Config.getConfig().gameHasComic())
            {
               _loc1_ = new ComicStripsDefMng(FSResourceMng.ID_RULES_COMIC_STRIPS_DEFINITIONS);
               InstanceMng.registerComicStripsDefMng(_loc1_);
            }
            setTimeout(createPortraitsDefMng,20);
         };
         createPortraitsDefMng = function():void
         {
            var _loc1_:PortraitsDefMng = new PortraitsDefMng(FSResourceMng.ID_RULES_PORTRAITS_DEFINITIONS);
            InstanceMng.registerPortraitsDefMng(_loc1_);
            setTimeout(createDailyRewardsDefMng,20);
         };
         createDailyRewardsDefMng = function():void
         {
            var _loc1_:DailyRewardsDefMng = new DailyRewardsDefMng(FSResourceMng.ID_DAILY_REWARDS_DEFINITIONS);
            InstanceMng.registerDailyRewardsDefMng(_loc1_);
            setTimeout(createKickstartedDefMng,20);
         };
         createKickstartedDefMng = function():void
         {
            var _loc1_:KickstarterBackerDefMng = null;
            if(Config.getConfig().gameCreditsHasKickstarter())
            {
               _loc1_ = new KickstarterBackerDefMng(FSResourceMng.ID_RULES_KICKSTARTER_BACKERS_DEFINITIONS);
               InstanceMng.registerKickstarterBackersDefMng(_loc1_);
            }
            setTimeout(createStarsRewardsDefMng,20);
         };
         createStarsRewardsDefMng = function():void
         {
            var _loc1_:StarsRewardsDefMng = new StarsRewardsDefMng(FSResourceMng.ID_RULES_STAR_REWARDS_DEFINITIONS);
            InstanceMng.registerStarsRewardsDefMng(_loc1_);
            if(mOnDefaultDefsCompleteFunction != null)
            {
               setTimeout(mOnDefaultDefsCompleteFunction,20);
            }
         };
         var raritiesDefMng:RaritiesDefMng = new RaritiesDefMng(FSResourceMng.ID_RULES_RARITIES_DEFINITIONS);
         InstanceMng.registerRaritiesDefMng(raritiesDefMng);
         editionsDefMng = new EditionsDefMng(FSResourceMng.ID_RULES_EDITIONS_DEFINITIONS);
         InstanceMng.registerEditionsDefMng(editionsDefMng);
         configDefMng = new ConfigDefMng(FSResourceMng.ID_RULES_CONFIG_DEFINITIONS);
         InstanceMng.registerConfigDefMng(configDefMng);
         setTimeout(createCardsDefMng,20);
      }
      
      public function areDefaultDefsRead() : Boolean
      {
         return this.mDefaultDefsRead;
      }
      
      override protected function readDefs() : void
      {
         if(!this.mDefaultDefsRead)
         {
            this.readDefaultDefs();
         }
      }
   }
}

