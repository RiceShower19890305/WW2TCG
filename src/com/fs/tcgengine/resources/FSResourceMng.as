package com.fs.tcgengine.resources
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.model.rules.AbilityDef;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.MapDef;
   import com.fs.tcgengine.model.rules.ResourceDef;
   import com.fs.tcgengine.model.rules.UnitDef;
   import com.fs.tcgengine.particles.FSPDParticleSystem;
   import com.fs.tcgengine.screens.FSAuctionsScreen;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.screens.FSBattleScreenPvP;
   import com.fs.tcgengine.screens.FSDeckBuilderScreen;
   import com.fs.tcgengine.screens.FSDungeonsScreen;
   import com.fs.tcgengine.screens.FSMapScreen;
   import com.fs.tcgengine.screens.FSMenuScreen;
   import com.fs.tcgengine.screens.FSPvPScreen;
   import com.fs.tcgengine.screens.FSRaidsScreen;
   import com.fs.tcgengine.screens.FSShopScreen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.Layout;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.board.FSCardDescInfoBlock;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.FSCardShadow;
   import com.fs.tcgengine.view.cards.FSShopInfoCard;
   import com.fs.tcgengine.view.components.battle.FSBattlefieldUserPortrait;
   import com.fs.tcgengine.view.components.battle.FSTimeLeftCounter;
   import com.fs.tcgengine.view.components.battle.FSTurnsCounter;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.map.FSMapUnlockedEffect;
   import com.fs.tcgengine.view.misc.DeckCardsPanel;
   import com.fs.tcgengine.view.misc.FSCardSlotInfo;
   import com.fs.tcgengine.view.misc.FSCredits;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.misc.FSLogPanel;
   import feathers.controls.ScrollContainer;
   import flash.display.Stage;
   import flash.filesystem.File;
   import flash.text.Font;
   import flash.utils.Dictionary;
   import starling.core.Starling;
   import starling.display.DisplayObjectContainer;
   import starling.display.Sprite3D;
   import starling.textures.TextureOptions;
   import starling.utils.AssetManager;
   import starling.utils.StringUtil;
   
   public class FSResourceMng
   {
      
      public static var smMapsSWFs:Dictionary;
      
      private static var smLayersContainers:Dictionary;
      
      public static var smAllFonts:Dictionary;
      
      public static var smAudioFilesPaths:Dictionary;
      
      public static var smAudioFilesIds:Dictionary;
      
      public static var smAudioFilesPlayers:Dictionary;
      
      public static var smAudioFilesNames:Dictionary;
      
      public static var smAudioFilesNamesByPlayer:Dictionary;
      
      public static var smTextfieldsPool:Vector.<FSTextfield>;
      
      public static var smCardsReplacements:Dictionary;
      
      private static var smDefaultOrientalFontName:String = "";
      
      public static const TYPE_TEXTURE_PNG:int = 0;
      
      public static const TYPE_TEXTURE_JPG:int = 1;
      
      public static const TYPE_AUDIO:int = 2;
      
      public static const TYPE_SWF:int = 3;
      
      public static const TYPE_XML:int = 4;
      
      public static const TYPE_TEXTURE_ATLAS:int = 5;
      
      public static const PREFIX_TEXTURE_INIT:String = "textures/";
      
      public static const PREFIX_TEXTURE:String = "textures_on_demand/";
      
      public static const PREFIX_AUDIO:String = "audio_on_demand/";
      
      public static const PREFIX_FONTS:String = "fonts_on_demand/";
      
      public static const LAYER_UI:String = "UI";
      
      public static const LAYER_GAME:String = "GAME";
      
      private static const LAYERS:Vector.<String> = new <String>[LAYER_GAME,LAYER_UI];
      
      public static const ID_RULES_UNITS_DEFINITIONS:String = "units";
      
      public static const ID_RULES_ABILITIES_DEFINITIONS:String = "abilities";
      
      public static const ID_RULES_ACTIONS_DEFINITIONS:String = "actions";
      
      public static const ID_RULES_ATTACHMENTS_DEFINITIONS:String = "attachments";
      
      public static const ID_RULES_EDITIONS_DEFINITIONS:String = "editions";
      
      public static const ID_RULES_RARITIES_DEFINITIONS:String = "rarities";
      
      public static const ID_RULES_PVP_BOT_DECKS_DEFINITIONS:String = "pvpBotDecks";
      
      public static const ID_RULES_CATEGORIES_DEFINITION:String = "categories";
      
      public static const ID_RULES_SUBCATEGORIES_DEFINITIONS:String = "subcategories";
      
      public static const ID_RULES_STAR_REWARDS_DEFINITIONS:String = "starRewards";
      
      public static const ID_RULES_FACTIONS_DEFINITIONS:String = "factions";
      
      public static const ID_RULES_BADGES_DEFINITIONS:String = "badges";
      
      public static const ID_RULES_LEVEL_DEFINITIONS:String = "levels";
      
      public static const ID_RULES_GAME_MODES_DEFINITIONS:String = "gameModes";
      
      public static const ID_RULES_RESTRICTIONS_DEFINITIONS:String = "restrictions";
      
      public static const ID_RULES_BACKGROUNDS_DEFINITIONS:String = "backgrounds";
      
      public static const ID_RULES_MAPS_DEFINITIONS:String = "maps";
      
      public static const ID_RULES_REWARDS_DEFINITIONS:String = "rewards";
      
      public static const ID_RULES_AIMOVEMENTS_DEFINITIONS:String = "AIMovements";
      
      public static const ID_RULES_GAMESCORES_DEFINITIONS:String = "gameScores";
      
      public static const ID_RULES_TURNSCORES_DEFINITIONS:String = "turnScores";
      
      public static const ID_RULES_BOOSTS_DEFINITIONS:String = "boosts";
      
      public static const ID_RULES_SHOP_BOOSTS_DEFINITIONS:String = "shopBoosts";
      
      public static const ID_RULES_RANKS_DEFINITIONS:String = "ranks";
      
      public static const ID_RULES_PACKS_DEFINITIONS:String = "packs";
      
      public static const ID_RULES_WORLDS_DEFINITIONS:String = "worlds";
      
      public static const ID_RULES_BUNDLES_DEFINITIONS:String = "bundles";
      
      public static const ID_RULES_QUEST_SHOP_DEFINITIONS:String = "questShop";
      
      public static const ID_RULES_RAID_SHOP_DEFINITIONS:String = "raidShop";
      
      public static const ID_RULES_TUTORIAL_DEFINITIONS:String = "tutorial";
      
      public static const ID_RULES_TUTORIAL_DECK_BUILDER_DEFINITIONS:String = "tutorialDeckBuilder";
      
      public static const ID_RULES_KICKSTARTER_BACKERS_DEFINITIONS:String = "kickstarterBackers";
      
      public static const ID_RULES_HERO_CHARACTERS_DEFINITIONS:String = "heroes";
      
      public static const ID_RULES_CONVERSATIONS_DEFINITIONS:String = "conversations";
      
      public static const ID_RULES_COMIC_STRIPS_DEFINITIONS:String = "comicStrips";
      
      public static const ID_DECK_SLOTS_DEFINITIONS:String = "deckSlots";
      
      public static const ID_RULES_PORTRAITS_DEFINITIONS:String = "portraits";
      
      public static const ID_DAILY_REWARDS_DEFINITIONS:String = "dailyRewards";
      
      public static const ID_RULES_RESOURCES_DEFINITIONS:String = "resources";
      
      public static const ID_RULES_CONFIG_DEFINITIONS:String = "config";
      
      public static const ID_RULES_GOLD_DEFINITIONS:String = "gold";
      
      public static const ID_RULES_DUNGEONS_DEFINITIONS:String = "dungeons";
      
      public static const ID_RULES_RAIDS_DEFINITIONS:String = "raids";
      
      public static const ID_RULES_DUNGEON_LEVELS_DEFINITIONS:String = "dungeonLevels";
      
      public static const ID_RULES_RAID_LEVELS_DEFINITIONS:String = "raidLevels";
      
      public static const ID_RULES_EVENT_BATTLES_DEFINITIONS:String = "battleEvent";
      
      public static const ID_RULES_PASSIVE_ABILITY_DEFINITIONS:String = "passiveAbilities";
      
      public static const ID_RULES_TUTORIAL_MAP_DEFINITIONS:String = "tutorialMap";
      
      public static const ID_RULES_POWERS_DEFINITIONS:String = "powers";
      
      public static const ID_RULES_QUESTS_DEFINITIONS:String = "quests";
      
      public static const ID_RULES_AUCTION_TICKETS_DEFINITIONS:String = "tokens";
      
      public static const ID_RULES_PVP_REWARDS_DEFINITIONS:String = "pvpRewards";
      
      public static const ID_RULES_DUNGEON_REWARDS_DEFINITIONS:String = "dungeonRewards";
      
      public static const ID_RULES_JOBS_DEFINITIONS:String = "jobs";
      
      public static const ID_RULES_JOB_LEVELS_DEFINITIONS:String = "jobLevels";
      
      public static const ID_RULES_JOB_REWARDS_DEFINITIONS:String = "jobRewards";
      
      public static const ID_RULES_GROUP_IDS_DEFINITIONS:String = "groupIds";
      
      public static const FONT_STD_BIG_XL_TITLE_SIZE:int = 65 * Layout.getFontReducedFactor();
      
      public static const FONT_STD_BIG_TITLE_SIZE:int = 50 * Layout.getFontReducedFactor();
      
      public static const FONT_STD_TITLE_SIZE:int = 40 * Layout.getFontReducedFactor();
      
      public static const FONT_STD_SUBTITLE_SIZE:int = 30 * Layout.getFontReducedFactor();
      
      public static const FONT_STD_DEFAULT_SIZE:int = 25 * Layout.getFontReducedFactor();
      
      public static const FONT_STD_SEMI_SMALL_SIZE:int = 22.5 * Layout.getFontReducedFactor();
      
      public static const FONT_STD_SMALL_SIZE:int = 20 * Layout.getFontReducedFactor();
      
      public static const FONT_STD_XSMALL_SIZE:int = 15 * Layout.getFontReducedFactor();
      
      public static var smCurrentLocaleSelected:String = "";
      
      public static const FONT_TYPE_STD:String = "std";
      
      public static const FONT_TYPE_STD_GREEN:String = "green";
      
      public static const FONT_TYPE_STD_GOLD:String = "gold";
      
      public static const FONT_TYPE_STD_BLUE:String = "blue";
      
      public static const FONT_TYPE_STD_RED:String = "red";
      
      public static const FONT_TYPE_STD_DESC:String = "desc";
      
      public static const FONT_TYPE_STD_NUM_GREEN:String = "green";
      
      public static const FONT_TYPE_STD_NUM_GOLD:String = "gold";
      
      public static const FONT_TYPE_STD_NUM_WHITE:String = "white";
      
      public static const DEFAULT_PHOTO_NAME:String = "default_photo";
      
      public static const DEFAULT_PHOTO_AI_NAME:String = "enemy_portrait_1";
      
      public static const DEFAULT_AI_PORTRAIT_FRAME_NAME:String = "portrait_frame_01";
      
      public static const DEFAULT_PORTRAIT_RANK_FRAME_NAME:String = "rank_frame_";
      
      private const PREFIX_SWF:String = "swf_on_demand/";
      
      private const SUFIX_TEXTURE_PNG:String = ".png";
      
      private const SUFIX_TEXTURE_JPG:String = ".jpg";
      
      private const SUFIX_AUDIO:String = ".mp3";
      
      private const SUFIX_SWF:String = ".swf";
      
      private const SUFIX_XML:String = ".xml";
      
      protected var mExpansionFilesPath:String;
      
      private var mResourcesToLoadCatalog:Dictionary;
      
      private var mOnCompleteHandlerFunction:Function = null;
      
      private var mCardValuesCatalog:Dictionary;
      
      private var mCardEditionsCatalog:Dictionary;
      
      private var mCraftingMaterialCardsCatalog:Dictionary;
      
      private var mRetryDownloadAttempts:int = 0;
      
      public function FSResourceMng()
      {
         super();
      }
      
      public static function isOrientalLocale() : Boolean
      {
         return smCurrentLocaleSelected != "" && (smCurrentLocaleSelected == "ZH" || smCurrentLocaleSelected == "JA");
      }
      
      public static function isOriental(param1:String = "") : Boolean
      {
         return isOrientalLocale() || Utils.textHasGlyphs(param1);
      }
      
      public static function getAllFonts() : Dictionary
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         if(smAllFonts == null)
         {
            smAllFonts = new Dictionary(true);
            _loc1_ = Font.enumerateFonts(true);
            if(_loc1_)
            {
               _loc2_ = 0;
               while(_loc2_ < _loc1_.length)
               {
                  smAllFonts[_loc1_[_loc2_].fontName] = _loc1_[_loc2_];
                  _loc2_++;
               }
            }
         }
         return smAllFonts;
      }
      
      public static function getFontByType(param1:String = "std") : String
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case FONT_TYPE_STD:
            case FONT_TYPE_STD_NUM_WHITE:
               _loc2_ = "game_font_white" + Main.smScaleFactor + "x";
               break;
            case FONT_TYPE_STD_BLUE:
               _loc2_ = "game_font_blue" + Main.smScaleFactor + "x";
               break;
            case FONT_TYPE_STD_GOLD:
            case FONT_TYPE_STD_NUM_GOLD:
               _loc2_ = "game_font_gold" + Main.smScaleFactor + "x";
               break;
            case FONT_TYPE_STD_GREEN:
            case FONT_TYPE_STD_NUM_GREEN:
               _loc2_ = "game_font_green" + Main.smScaleFactor + "x";
               break;
            case FONT_TYPE_STD_RED:
               _loc2_ = "game_font_red" + Main.smScaleFactor + "x";
               break;
            case FONT_TYPE_STD_DESC:
               _loc2_ = "game_font_desc" + Main.smScaleFactor + "x";
               break;
            default:
               _loc2_ = "game_font_white" + Main.smScaleFactor + "x";
         }
         return _loc2_;
      }
      
      public static function addToStage(param1:*, param2:String) : void
      {
         var _loc3_:int = 0;
         if(smLayersContainers == null)
         {
            smLayersContainers = new Dictionary(true);
            _loc3_ = 0;
            while(_loc3_ < LAYERS.length)
            {
               smLayersContainers[LAYERS[_loc3_]] = new Sprite3D();
               smLayersContainers[LAYERS[_loc3_]].name = LAYERS[_loc3_];
               Starling.current.stage.addChild(smLayersContainers[LAYERS[_loc3_]]);
               _loc3_++;
            }
         }
         if(param1)
         {
            DisplayObjectContainer(smLayersContainers[param2]).addChild(param1);
         }
      }
      
      public static function getTextfieldFromPool() : FSTextfield
      {
         var _loc1_:FSTextfield = null;
         printMemoryUsed();
         if(Boolean(smTextfieldsPool) && smTextfieldsPool.length > 0)
         {
            _loc1_ = smTextfieldsPool.pop();
            _loc1_.setInPool(false);
            return _loc1_;
         }
         return new FSTextfield(0,0);
      }
      
      public static function addTextfieldToPool(param1:FSTextfield) : void
      {
         if(Boolean(param1) && param1.isInPool())
         {
            return;
         }
         if(smTextfieldsPool == null)
         {
            smTextfieldsPool = new Vector.<FSTextfield>();
         }
         param1.setInPool(true);
         smTextfieldsPool.push(param1);
         printMemoryUsed();
      }
      
      public static function printMemoryUsed() : void
      {
      }
      
      public function getFileFromStorage(param1:String, param2:String = "main") : *
      {
         return null;
      }
      
      public function getSoundTrack() : Vector.<String>
      {
         return null;
      }
      
      public function getRandomSoundName(param1:FSCard, param2:String) : String
      {
         return "";
      }
      
      public function removeResourcesFromFolder(param1:String) : void
      {
         if(param1 != "")
         {
            Root.assets.removeAssetsFromFolder(this.getFileFromStorage(StringUtil.format(this.getAssetsOnDemandURL(PREFIX_TEXTURE_INIT) + param1,Main.smScaleFactor)));
            Root.assets.removeAssetsFromFolder(this.getFileFromStorage(StringUtil.format(this.getAssetsOnDemandURL(PREFIX_TEXTURE) + param1,Main.smScaleFactor)));
            Root.assets.removeAssetsFromFolder(this.getFileFromStorage(this.getAssetsOnDemandURL(PREFIX_AUDIO) + param1));
            if(Utils.isMobile() || Utils.isDesktop())
            {
               this.removeSpecialScreenResources(param1);
            }
         }
      }
      
      public function addFolderResourcesToLoad(param1:String, param2:AssetManager = null, param3:TextureOptions = null) : void
      {
         var _loc4_:String = StringUtil.format(this.getAssetsOnDemandURL(PREFIX_TEXTURE) + param1,Main.smScaleFactor);
         if(param2)
         {
            param2.enqueue(this.getFileFromStorage(_loc4_),param3);
         }
         else
         {
            Root.assets.enqueue(this.getFileFromStorage(_loc4_),param3);
         }
         _loc4_ = StringUtil.format(this.getAssetsOnDemandURL(PREFIX_AUDIO) + param1,Main.smScaleFactor);
         if(param2)
         {
            param2.enqueue(this.getFileFromStorage(_loc4_));
         }
         else
         {
            Root.assets.enqueue(this.getFileFromStorage(_loc4_));
         }
      }
      
      public function getScreenClassByName(param1:String) : Class
      {
         var _loc2_:Class = null;
         switch(param1)
         {
            case Constants.MENU_SCREEN_NAME:
               return FSMenuScreen;
            case Constants.DECK_BUILDER_SCREEN_NAME:
               return FSDeckBuilderScreen;
            case Constants.MAP_SCREEN_NAME:
               return FSMapScreen;
            case Constants.BATTLE_SCREEN_NAME:
               return FSBattleScreen;
            case Constants.BATTLE_SCREEN_PVP_NAME:
               return FSBattleScreenPvP;
            case Constants.SHOP_SCREEN_NAME:
               return FSShopScreen;
            case Constants.PVP_SCREEN_NAME:
               return FSPvPScreen;
            case Constants.DUNGEONS_SCREEN_NAME:
               return FSDungeonsScreen;
            case Constants.RAIDS_SCREEN_NAME:
               return FSRaidsScreen;
            case Constants.AUCTIONS_SCREEN_NAME:
               return FSAuctionsScreen;
            default:
               return _loc2_;
         }
      }
      
      public function loadCardImagesByCatalog(param1:Dictionary, param2:Boolean = true) : void
      {
         var _loc3_:String = null;
         var _loc4_:CardDef = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         if(param1 != null)
         {
            _loc7_ = DictionaryUtils.getKeys(param1);
            _loc8_ = 0;
            while(_loc8_ < _loc7_.length)
            {
               _loc4_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc7_[_loc8_]));
               this.loadCardImagesByCardDef(_loc4_,false,false,param2);
               _loc8_++;
            }
         }
      }
      
      public function loadCardImagesByArray(param1:Array, param2:Boolean = true, param3:Boolean = false) : void
      {
         var _loc4_:String = null;
         var _loc5_:CardDef = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         if(param1 != null)
         {
            _loc8_ = 0;
            while(_loc8_ < param1.length)
            {
               _loc5_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(String(param1[_loc8_]).split(":")[0]));
               this.loadCardImagesByCardDef(_loc5_,param3,false,param2);
               _loc8_++;
            }
         }
      }
      
      public function loadCardImagesByCardDef(param1:CardDef, param2:Boolean = false, param3:Boolean = false, param4:Boolean = true) : Boolean
      {
         var _loc9_:String = null;
         var _loc10_:Boolean = false;
         var _loc11_:CardDef = null;
         var _loc12_:CardDef = null;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:String = Config.getConfig().getCardBGType();
         var _loc8_:int = _loc7_ == "jpg" ? TYPE_TEXTURE_JPG : TYPE_TEXTURE_PNG;
         if(param1 != null)
         {
            _loc9_ = Config.getConfig().XLViewUsesXLTextures() && param1.getBGXLImageName() != "" && param1.getBGXLImageName() != null ? param1.getBGXLImageName() : param1.getBGImageName();
            if(param2)
            {
               _loc10_ = param1.hasAnimatedBG();
               if(_loc10_)
               {
                  if(Root.assets.getTextureAtlas(param1.getAnimatedBG()) == null)
                  {
                     _loc5_ = true;
                     this.addResourceToLoad("cardsAnimated/" + param1.getAnimatedBG(),TYPE_TEXTURE_ATLAS);
                  }
               }
               else if(Root.assets.getTexture(_loc9_) == null)
               {
                  _loc5_ = true;
                  this.addResourceToLoad("cards/" + _loc9_,_loc8_);
               }
            }
            _loc6_ = this.loadCardBGResource(param1);
            _loc5_ ||= _loc6_;
            if(Config.getConfig().cardBGChangesOnPromote())
            {
               if(param1.getUpgradeSku() != null)
               {
                  _loc11_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(param1.getUpgradeSku()));
                  if(_loc11_)
                  {
                     _loc6_ = this.loadCardBGResource(_loc11_);
                     _loc5_ ||= _loc6_;
                     if(_loc11_.getUpgradeSku() != null)
                     {
                        _loc11_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc11_.getUpgradeSku()));
                        _loc6_ = this.loadCardBGResource(_loc11_);
                        _loc5_ ||= _loc6_;
                     }
                  }
               }
               if(param1.getPreviousUpgradeSku() != null)
               {
                  _loc12_ = Utils.getPreviousTierCardDef(param1.getSku());
                  if(_loc12_)
                  {
                     _loc6_ = this.loadCardBGResource(_loc12_);
                     _loc5_ ||= _loc6_;
                     _loc12_ = Utils.getPreviousTierCardDef(_loc12_.getSku());
                     if(_loc12_)
                     {
                        _loc6_ = this.loadCardBGResource(_loc12_);
                        _loc5_ ||= _loc6_;
                     }
                  }
               }
            }
         }
         return _loc5_;
      }
      
      public function loadCardSoundsByCardDef(param1:CardDef) : Boolean
      {
         var _loc4_:CardDef = null;
         var _loc5_:CardDef = null;
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         if(param1 != null)
         {
            _loc3_ = this.loadCardAudioResources(param1);
            _loc2_ ||= _loc3_;
            if(Config.getConfig().cardBGChangesOnPromote())
            {
               if(param1.getUpgradeSku() != null)
               {
                  _loc4_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(param1.getUpgradeSku()));
                  if(_loc4_)
                  {
                     _loc3_ = this.loadCardAudioResources(_loc4_);
                     _loc2_ ||= _loc3_;
                     if(_loc4_.getUpgradeSku() != null)
                     {
                        _loc4_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc4_.getUpgradeSku()));
                        _loc3_ = this.loadCardAudioResources(_loc4_);
                        _loc2_ ||= _loc3_;
                     }
                  }
               }
               else if(param1.getPreviousUpgradeSku() != null)
               {
                  _loc5_ = Utils.getPreviousTierCardDef(param1.getSku());
                  if(_loc5_)
                  {
                     _loc3_ = this.loadCardAudioResources(_loc5_);
                     _loc2_ ||= _loc3_;
                     _loc5_ = Utils.getPreviousTierCardDef(_loc5_.getSku());
                     if(_loc5_)
                     {
                        _loc3_ = this.loadCardAudioResources(_loc5_);
                        _loc2_ ||= _loc3_;
                     }
                  }
               }
            }
         }
         return _loc2_;
      }
      
      private function getAbilitiesAnimsUsedByCard(param1:CardDef) : Vector.<String>
      {
         var returnValue:Vector.<String> = null;
         var catalog:Dictionary = null;
         var animName:String = null;
         var i:int = 0;
         var c:CardDef = param1;
         var addNameToVec:Function = function(param1:String):void
         {
            if(Boolean(param1) && param1 != "")
            {
               if(catalog == null)
               {
                  catalog = new Dictionary(true);
               }
               if(catalog[param1] == null)
               {
                  catalog[param1] = 1;
                  if(returnValue == null)
                  {
                     returnValue = new Vector.<String>();
                  }
                  returnValue.push(param1);
               }
            }
         };
         returnValue = null;
         catalog = new Dictionary(true);
         var abs:Array = c.getAbilities();
         if(Boolean(abs) && abs.length > 0)
         {
            i = 0;
            while(i < abs.length)
            {
               animName = AbilityDef(InstanceMng.getAbilitiesDefMng().getDefBySku(abs[i])).getAnimIconName();
               addNameToVec(animName);
               i++;
            }
         }
         return returnValue;
      }
      
      public function loadCardAnimsResources(param1:CardDef, param2:Dictionary) : Dictionary
      {
         var _loc3_:Vector.<String> = null;
         var _loc4_:int = 0;
         if(param1)
         {
            _loc3_ = this.getAbilitiesAnimsUsedByCard(param1);
            if(Boolean(_loc3_) && _loc3_.length > 0)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc3_.length)
               {
                  if(Boolean(param2) && param2["anims/" + _loc3_[_loc4_]] == null)
                  {
                     this.addResourcesFolderByName("anims/" + _loc3_[_loc4_]);
                     param2["anims/" + _loc3_[_loc4_]] = 1;
                  }
                  else
                  {
                     FSDebug.debugTrace("Skipping load of anims/" + _loc3_[_loc4_] + " already in queue");
                  }
                  _loc4_++;
               }
            }
         }
         return param2;
      }
      
      private function getSoundsUsedByCard(param1:CardDef) : Vector.<String>
      {
         var abs:Array;
         var returnValue:Vector.<String> = null;
         var catalog:Dictionary = null;
         var s:String = null;
         var i:int = 0;
         var c:CardDef = param1;
         var addSoundToVec:Function = function(param1:String):void
         {
            if(Boolean(param1) && param1 != "")
            {
               if(catalog == null)
               {
                  catalog = new Dictionary(true);
               }
               if(catalog[param1] == null)
               {
                  catalog[param1] = 1;
                  if(returnValue == null)
                  {
                     returnValue = new Vector.<String>();
                  }
                  returnValue.push(param1);
               }
            }
         };
         returnValue = null;
         catalog = new Dictionary(true);
         if(Boolean(c) && c.getType() == FSCard.TYPE_UNIT)
         {
            s = UnitDef(c).getDamageAudioName();
            if(s != null && s != "")
            {
               addSoundToVec(s);
            }
         }
         abs = c ? c.getAbilities() : null;
         if(Boolean(abs) && abs.length > 0)
         {
            i = 0;
            while(i < abs.length)
            {
               s = AbilityDef(InstanceMng.getAbilitiesDefMng().getDefBySku(abs[i])).getSoundName();
               if(s != null && s != "")
               {
                  addSoundToVec(s);
               }
               i++;
            }
         }
         return returnValue;
      }
      
      private function loadCardAudioResources(param1:CardDef) : Boolean
      {
         var _loc3_:Vector.<String> = null;
         var _loc4_:int = 0;
         var _loc2_:Boolean = false;
         if(param1)
         {
            _loc3_ = this.getSoundsUsedByCard(param1);
            if(Boolean(_loc3_) && _loc3_.length > 0)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc3_.length)
               {
                  if(Root.assets.getSound(_loc3_[_loc4_]) == null)
                  {
                     _loc2_ = true;
                     this.addResourceToLoad("battleFX/" + _loc3_[_loc4_],TYPE_AUDIO);
                  }
                  _loc4_++;
               }
            }
         }
         return _loc2_;
      }
      
      public function loadCardBGResource(param1:CardDef) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc2_:Boolean = false;
         if(param1)
         {
            _loc3_ = param1.hasAnimatedBG();
            if(_loc3_)
            {
               if(Root.assets.getTextureAtlas(param1.getAnimatedBG()) == null)
               {
                  _loc2_ = true;
                  this.addResourceToLoad("cardsAnimated/" + param1.getAnimatedBG(),TYPE_TEXTURE_ATLAS);
               }
            }
            else if(Root.assets.getTexture(param1.getBGImageName()) == null)
            {
               _loc2_ = true;
               _loc4_ = Config.getConfig().getCardBGType();
               _loc5_ = _loc4_ == "jpg" ? TYPE_TEXTURE_JPG : TYPE_TEXTURE_PNG;
               this.addResourceToLoad("cards/" + param1.getBGImageName(),_loc5_);
            }
         }
         return _loc2_;
      }
      
      public function getExternalSWFPath() : String
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         if(Utils.isMobile() || Utils.isDesktop())
         {
            _loc1_ = StringUtil.format("swf/{0}x" + Layout.getType(),Main.smScaleFactor) + "/";
         }
         else
         {
            _loc2_ = InstanceMng.getResourcesMng().getCDNInfix();
            _loc1_ = _loc2_ + StringUtil.format("swf/{0}x" + Layout.getType(),Main.smScaleFactor) + "/";
         }
         return _loc1_;
      }
      
      public function createCardShadow(param1:FSCard) : FSCardShadow
      {
         return new FSCardShadow(param1);
      }
      
      public function morphParticleSystemProps(param1:FSPDParticleSystem, param2:int) : void
      {
      }
      
      public function createUserBattlefieldPortrait(param1:Boolean, param2:String = "", param3:String = "", param4:Boolean = false) : FSBattlefieldUserPortrait
      {
         return new FSBattlefieldUserPortrait(param1,param2,param3,param4);
      }
      
      public function createTurnsCounter(param1:int) : FSTurnsCounter
      {
         return new FSTurnsCounter(param1);
      }
      
      public function createGameCredits() : FSCredits
      {
         return new FSCredits();
      }
      
      public function createCardDescriptionInfoBlock(param1:String, param2:String, param3:FSCard) : FSCardDescInfoBlock
      {
         return new FSCardDescInfoBlock(param1,param2,param3);
      }
      
      public function createTimeLeftCounter(param1:int) : FSTimeLeftCounter
      {
         return new FSTimeLeftCounter(param1);
      }
      
      public function createCardSlotInfoItem(param1:String, param2:int, param3:DeckCardsPanel, param4:ScrollContainer) : FSCardSlotInfo
      {
         return new FSCardSlotInfo(param1,param2,param3,param4);
      }
      
      public function createLogPanel() : FSLogPanel
      {
         return new FSLogPanel();
      }
      
      public function createShopInfoCard(param1:FSCard, param2:int, param3:Boolean = true, param4:Boolean = true, param5:Boolean = false) : FSShopInfoCard
      {
         return new FSShopInfoCard(param1,param2,param3,param4,param5);
      }
      
      public function getDefaultPopupTitlePercent() : Number
      {
         return Config.getConfig().getDefaultPopupTitlePercent();
      }
      
      public function getDefaultPopupAcceptButtonPercent(param1:FSImage, param2:FSButton) : Number
      {
         return param1.height - param2.height / 2;
      }
      
      public function getDefaultBuyButtonSize() : Number
      {
         return FSResourceMng.FONT_STD_DEFAULT_SIZE;
      }
      
      public function createMapUnlockedEffect(param1:MapDef) : FSMapUnlockedEffect
      {
         return new FSMapUnlockedEffect(param1);
      }
      
      public function disposeCardBGByCardDef(param1:CardDef) : void
      {
         var _loc2_:CardDef = null;
         var _loc3_:CardDef = null;
         if(param1)
         {
            if(param1.hasAnimatedBG())
            {
               Root.assets.removeTextureAtlas(param1.getAnimatedBG());
            }
            else
            {
               Root.assets.removeTexture(param1.getBGImageName());
            }
            if(Config.getConfig().cardBGChangesOnPromote())
            {
               if(param1.getPreviousUpgradeSku() != null && param1.getPreviousUpgradeSku() != "")
               {
                  _loc2_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(param1.getPreviousUpgradeSku()));
                  if(_loc2_)
                  {
                     if(_loc2_.hasAnimatedBG())
                     {
                        Root.assets.removeTextureAtlas(_loc2_.getAnimatedBG());
                     }
                     else
                     {
                        Root.assets.removeTexture(_loc2_.getBGImageName());
                     }
                     _loc2_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc2_.getPreviousUpgradeSku()));
                     if(_loc2_)
                     {
                        if(_loc2_.hasAnimatedBG())
                        {
                           Root.assets.removeTextureAtlas(_loc2_.getAnimatedBG());
                        }
                        else
                        {
                           Root.assets.removeTexture(_loc2_.getBGImageName());
                        }
                     }
                  }
               }
               if(param1.getUpgradeSku() != null && param1.getUpgradeSku() != "")
               {
                  _loc3_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(param1.getUpgradeSku()));
                  if(_loc3_)
                  {
                     if(_loc3_.hasAnimatedBG())
                     {
                        Root.assets.removeTextureAtlas(_loc3_.getAnimatedBG());
                     }
                     else
                     {
                        Root.assets.removeTexture(_loc3_.getBGImageName());
                     }
                     if(_loc3_.getUpgradeSku() != null)
                     {
                        _loc3_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc3_.getUpgradeSku()));
                        if(_loc3_)
                        {
                           if(_loc3_.hasAnimatedBG())
                           {
                              Root.assets.removeTextureAtlas(_loc3_.getAnimatedBG());
                           }
                           else
                           {
                              Root.assets.removeTexture(_loc3_.getBGImageName());
                           }
                        }
                     }
                  }
               }
            }
         }
      }
      
      public function getResourcesToLoadCatalog() : Dictionary
      {
         if(this.mResourcesToLoadCatalog == null)
         {
            this.mResourcesToLoadCatalog = new Dictionary(true);
         }
         return this.mResourcesToLoadCatalog;
      }
      
      public function addResourceToLoad(param1:String, param2:int) : Boolean
      {
         var _loc3_:Boolean = false;
         if(this.mResourcesToLoadCatalog == null)
         {
            this.mResourcesToLoadCatalog = new Dictionary(true);
         }
         if(this.mResourcesToLoadCatalog[param1] == null)
         {
            _loc3_ = true;
            this.mResourcesToLoadCatalog[param1] = param2;
            if(Config.smLogsVerboseEnabled)
            {
               FSDebug.debugTrace("Resource added to catalog: " + param1);
            }
         }
         return _loc3_;
      }
      
      public function enqueueSpecialResourceToLoad(param1:String, param2:String, param3:int) : void
      {
         var _loc5_:String = null;
         var _loc4_:String = "";
         if(this.isSpecialScreenResource())
         {
            if(Utils.isIOS())
            {
               if(Utils.isIphone())
               {
                  _loc5_ = Utils.isIphone4() ? "iPhone4/" : "iPhone5/";
               }
               else
               {
                  _loc5_ = "iPad/";
               }
               _loc4_ = PREFIX_TEXTURE + "{0}x/ios/specialScreens/" + _loc5_ + param2 + "/" + param1 + this.getPathSufixByType(param3);
            }
            else
            {
               _loc5_ = Utils.isTablet() ? "tablet/" : "mobile/";
               _loc4_ = PREFIX_TEXTURE + "{0}x/android/specialScreens/" + _loc5_ + param2 + "/" + param1 + this.getPathSufixByType(param3);
            }
            _loc4_ = StringUtil.format(_loc4_,Main.smScaleFactor);
            Root.assets.enqueue(this.getFileFromStorage(_loc4_));
            return;
         }
         this.addResourceToLoad(param2 + "/" + param1,param3);
      }
      
      private function enqeueAllAssets() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         if(this.mResourcesToLoadCatalog != null)
         {
            _loc4_ = DictionaryUtils.getKeys(this.mResourcesToLoadCatalog);
            if(_loc4_ != null)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc4_.length)
               {
                  _loc1_ = int(this.mResourcesToLoadCatalog[_loc4_[_loc3_]]);
                  _loc2_ = this.getPathPrefixByType(_loc1_);
                  _loc5_ = _loc2_ + _loc4_[_loc3_] + this.getPathSufixByType(_loc1_);
                  this.enqueueAsset(_loc5_);
                  if(_loc1_ == TYPE_TEXTURE_ATLAS)
                  {
                     _loc5_ = _loc2_ + _loc4_[_loc3_] + this.getPathSufixByType(TYPE_XML);
                     this.enqueueAsset(_loc5_);
                  }
                  _loc3_++;
               }
            }
         }
      }
      
      public function clearResourcesCatalog() : void
      {
         DictionaryUtils.clearDictionary(this.mResourcesToLoadCatalog);
      }
      
      public function addResourcesFolderByName(param1:String, param2:TextureOptions = null, param3:AssetManager = null, param4:String = "", param5:Boolean = false) : void
      {
         var _loc6_:String = null;
         if(param1 != "")
         {
            param4 = param4 != "" ? param4 : PREFIX_TEXTURE;
            _loc6_ = StringUtil.format(this.getAssetsOnDemandURL(param4) + param1,Main.smScaleFactor);
            if(param3 == null)
            {
               this.addFolderResourcesToLoad(param1,param3,param2);
            }
            else
            {
               _loc6_ = param5 ? param1 : _loc6_;
               if(Utils.isAndroidOrDesktop() && param5)
               {
                  param3.enqueue(File.applicationDirectory.resolvePath(_loc6_),param2);
               }
               else
               {
                  param3.enqueue(this.getFileFromStorage(_loc6_),param2);
               }
            }
         }
      }
      
      public function addDefinitionsFolderByName(param1:String, param2:AssetManager = null) : void
      {
         if(param1 != "")
         {
            if(param2 == null)
            {
               Root.assets.enqueue(this.getFileFromStorage(param1));
            }
            else
            {
               param2.enqueue(this.getFileFromStorage(param1));
            }
         }
      }
      
      public function addAudioResourcesFolderByName(param1:String) : void
      {
         if(param1 != "")
         {
            Root.assets.enqueue(this.getFileFromStorage(this.getAssetsOnDemandURL(PREFIX_AUDIO) + param1));
         }
      }
      
      public function addSpecialScreenResources(param1:String, param2:AssetManager = null, param3:String = "") : void
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Stage = null;
         var _loc4_:Boolean = Utils.isIphone();
         if(Utils.isIOS())
         {
            if(Utils.isIphone())
            {
               _loc5_ = Utils.isIphone4() ? "iPhone4/" : "iPhone5/";
            }
            else
            {
               _loc5_ = "iPad/";
            }
            param3 = param3 != "" ? param3 : PREFIX_TEXTURE;
            _loc6_ = param3 + "{0}x/ios/specialScreens/" + _loc5_ + param1;
            if(param2 == null)
            {
               Root.assets.enqueue(this.getFileFromStorage(StringUtil.format(_loc6_,Main.smScaleFactor)));
            }
            else
            {
               param2.enqueue(this.getFileFromStorage(StringUtil.format(_loc6_,Main.smScaleFactor)));
            }
         }
         else
         {
            _loc7_ = InstanceMng.getApplication().stage;
            _loc5_ = Utils.isTablet(_loc7_) ? "tablet/" : "mobile/";
            param3 = param3 != "" ? param3 : PREFIX_TEXTURE;
            _loc6_ = param3 + "{0}x/android/specialScreens/" + _loc5_ + param1;
            if(param2 == null)
            {
               Root.assets.enqueue(this.getFileFromStorage(StringUtil.format(_loc6_,Main.smScaleFactor)));
            }
            else
            {
               param2.enqueue(this.getFileFromStorage(StringUtil.format(_loc6_,Main.smScaleFactor)));
            }
         }
      }
      
      public function addSpecialScreenResource(param1:String, param2:String, param3:AssetManager = null, param4:String = "") : void
      {
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:Stage = null;
         var _loc5_:Boolean = Utils.isIphone();
         if(Utils.isIOS())
         {
            if(Utils.isIphone())
            {
               _loc6_ = Utils.isIphone4() ? "iPhone4/" : "iPhone5/";
            }
            else
            {
               _loc6_ = "iPad/";
            }
            param4 = param4 != "" ? param4 : PREFIX_TEXTURE;
            _loc7_ = param4 + "{0}x/ios/specialScreens/" + _loc6_ + param1 + "/" + param2;
            if(param3 == null)
            {
               Root.assets.enqueue(this.getFileFromStorage(StringUtil.format(_loc7_,Main.smScaleFactor)));
            }
            else
            {
               param3.enqueue(this.getFileFromStorage(StringUtil.format(_loc7_,Main.smScaleFactor)));
            }
         }
         else
         {
            _loc8_ = InstanceMng.getApplication().stage;
            _loc6_ = Utils.isTablet(_loc8_) ? "tablet/" : "mobile/";
            param4 = param4 != "" ? param4 : PREFIX_TEXTURE;
            _loc7_ = param4 + "{0}x/android/specialScreens/" + _loc6_ + param1 + "/" + param2;
            if(param3 == null)
            {
               Root.assets.enqueue(this.getFileFromStorage(StringUtil.format(_loc7_,Main.smScaleFactor)));
            }
            else
            {
               param3.enqueue(this.getFileFromStorage(StringUtil.format(_loc7_,Main.smScaleFactor)));
            }
         }
      }
      
      public function removeSpecialScreenResources(param1:String) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:Boolean = Utils.isIphone();
         if(Utils.isIOS())
         {
            if(Utils.isIphone())
            {
               _loc2_ = Utils.isIphone4() ? "iPhone4/" : "iPhone5/";
            }
            else
            {
               _loc2_ = "iPad/";
            }
            _loc3_ = PREFIX_TEXTURE + "{0}x/ios/specialScreens/" + _loc2_ + param1;
            Root.assets.removeAssetsFromFolder(this.getFileFromStorage(StringUtil.format(_loc3_,Main.smScaleFactor)));
         }
         else
         {
            _loc2_ = Utils.isTablet() ? "tablet/" : "mobile/";
            _loc3_ = PREFIX_TEXTURE + "{0}x/android/specialScreens/" + _loc2_ + param1;
            Root.assets.removeAssetsFromFolder(this.getFileFromStorage(StringUtil.format(_loc3_,Main.smScaleFactor)));
         }
      }
      
      public function removeResourcesFromSpecificFolder(param1:String, param2:String) : void
      {
         this.removeResourcesFromFolder(param1);
      }
      
      public function removeDefinitions() : void
      {
         this.removeDefinitionsByFolder("definitions");
      }
      
      private function removeDefinitionsByFolder(param1:String) : void
      {
         var _loc2_:Dictionary = null;
         var _loc3_:ResourceDef = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         if(Utils.isBrowser())
         {
            _loc2_ = InstanceMng.getResourceDefMng().getResourcesByFolderName(param1);
            _loc5_ = InstanceMng.getResourcesMng().getCDNInfix();
            for each(_loc3_ in _loc2_)
            {
               _loc6_ = Utils.isBrowser() && Config.PRODUCTION_BUILD ? _loc5_ : "";
               _loc7_ = _loc3_.getPath().split("/")[1];
               _loc7_ = _loc7_.split(".")[0];
               Root.assets.removeXml(_loc7_);
            }
         }
         else
         {
            Root.assets.removeDefinitions(this.getFileFromStorage(param1));
         }
      }
      
      private function getPathPrefixByType(param1:int) : String
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case TYPE_TEXTURE_PNG:
            case TYPE_TEXTURE_JPG:
            case TYPE_TEXTURE_ATLAS:
               _loc2_ = this.getAssetsOnDemandURL(PREFIX_TEXTURE);
               break;
            case TYPE_AUDIO:
               _loc2_ = this.getAssetsOnDemandURL(PREFIX_AUDIO);
               break;
            case TYPE_SWF:
               _loc2_ = this.PREFIX_SWF + "{0}x/";
         }
         return _loc2_;
      }
      
      protected function getPathSufixByType(param1:int) : String
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case TYPE_TEXTURE_PNG:
            case TYPE_TEXTURE_ATLAS:
               _loc2_ = this.SUFIX_TEXTURE_PNG;
               break;
            case TYPE_TEXTURE_JPG:
               _loc2_ = this.SUFIX_TEXTURE_JPG;
               break;
            case TYPE_AUDIO:
               _loc2_ = this.SUFIX_AUDIO;
               break;
            case TYPE_SWF:
               _loc2_ = this.SUFIX_SWF;
               break;
            case TYPE_XML:
               _loc2_ = this.SUFIX_XML;
         }
         return _loc2_;
      }
      
      private function enqueueAsset(param1:String) : void
      {
         var _loc2_:String = StringUtil.format(param1,Main.smScaleFactor);
         Root.assets.enqueue(this.getFileFromStorage(_loc2_));
      }
      
      public function resumeLoadedAssets() : void
      {
         this.loadAssets(this.mOnCompleteHandlerFunction,true);
      }
      
      public function loadAssets(param1:Function = null, param2:Boolean = false) : void
      {
         var onCompleteHandler:Function = param1;
         var isIOErrorRetry:Boolean = param2;
         var onCompleteFunction:Function = onCompleteHandler == null && Boolean(InstanceMng.getCurrentScreen()) ? InstanceMng.getCurrentScreen().notifyAssetsLoaded : onCompleteHandler;
         this.mOnCompleteHandlerFunction = onCompleteFunction;
         if(!isIOErrorRetry)
         {
            this.enqeueAllAssets();
         }
         if(!isIOErrorRetry && DictionaryUtils.getDictionaryLength(this.mResourcesToLoadCatalog) == 0 && Root.assets.numQueuedAssets == 0)
         {
            onCompleteFunction();
            return;
         }
         Root.assets.loadQueue(function(param1:Number):void
         {
            if(InstanceMng.getCurrentScreen())
            {
               Root(Starling.current.root).setLoadingScreenText(String(int(param1 * 100)) + "%");
            }
            if(param1 == 1)
            {
               if(isIOErrorRetry)
               {
                  Utils.removeLog();
                  if(InstanceMng.getCurrentScreen())
                  {
                     InstanceMng.getCurrentScreen().onConnectionGained();
                  }
               }
               clearResourcesCatalog();
               onCompleteFunction();
               mOnCompleteHandlerFunction = null;
               mRetryDownloadAttempts = 0;
            }
         });
      }
      
      public function getAssetsOnDemandURL(param1:String) : String
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:String = null;
         var _loc2_:String = Utils.isBrowser() ? InstanceMng.getResourcesMng().getCDNInfix() : "";
         var _loc3_:String = _loc2_ + param1;
         switch(param1)
         {
            case PREFIX_TEXTURE_INIT:
            case PREFIX_TEXTURE:
               if(InstanceMng.getApplication().isBrowserVersion())
               {
                  _loc3_ += Main.smScaleFactor + "x/android/";
               }
               else
               {
                  _loc4_ = InstanceMng.getApplication().getFullScreenWidth();
                  _loc5_ = InstanceMng.getApplication().getFullScreenHeight();
                  _loc6_ = Layout.getResourcesOnDemandPrefix(_loc4_,_loc5_);
                  _loc3_ += _loc6_;
               }
         }
         return _loc3_;
      }
      
      public function isSpecialScreenResource() : Boolean
      {
         return true;
      }
      
      public function getCDNInfix(param1:Boolean = false) : String
      {
         var _loc2_:String = "";
         var _loc3_:String = InstanceMng.getApplication().getCDNDomain();
         var _loc4_:Boolean = !param1 ? Config.PRODUCTION_BUILD && !Config.IS_BROWSER_LOCAL : true;
         var _loc5_:Boolean = InstanceMng.getApplication().isFacebookBrowser();
         var _loc6_:String = _loc3_ + InstanceMng.getApplication().getGSBrowserNamespace();
         var _loc7_:String = _loc5_ ? _loc6_ + "/fb-" : _loc6_ + "/kong";
         var _loc8_:String = _loc4_ && Config.ENVIRONMENT_ACTIVE != Config.ENVIRONMENT_DEV || !_loc5_ ? "prod" : "dev";
         _loc8_ = param1 && _loc5_ ? "products" : _loc8_;
         _loc2_ = _loc5_ ? _loc7_ + _loc8_ + "/" : _loc7_ + "/";
         return _loc4_ ? _loc2_ : "";
      }
      
      public function addCardValue(param1:String, param2:Number) : void
      {
         if(this.mCardValuesCatalog == null)
         {
            this.mCardValuesCatalog = new Dictionary(true);
         }
         this.mCardValuesCatalog[param1] = param2;
      }
      
      public function getCardValue(param1:String) : int
      {
         return Boolean(this.mCardValuesCatalog) && this.mCardValuesCatalog[param1] != null ? int(this.mCardValuesCatalog[param1]) : 0;
      }
      
      public function addCardEdition(param1:String, param2:int) : void
      {
         if(this.mCardEditionsCatalog == null)
         {
            this.mCardEditionsCatalog = new Dictionary(true);
         }
         this.mCardEditionsCatalog[param1] = param2;
      }
      
      public function getCardEdition(param1:String) : int
      {
         return Boolean(this.mCardEditionsCatalog) && this.mCardEditionsCatalog[param1] != null ? int(this.mCardEditionsCatalog[param1]) : 0;
      }
      
      public function addCraftingCardMaterial(param1:String) : void
      {
         if(param1 != null && param1 != "")
         {
            if(this.mCraftingMaterialCardsCatalog == null)
            {
               this.mCraftingMaterialCardsCatalog = new Dictionary(true);
            }
            this.mCraftingMaterialCardsCatalog[param1] = true;
         }
      }
      
      public function isCraftingCardMaterial(param1:String) : Boolean
      {
         return Boolean(this.mCraftingMaterialCardsCatalog) && this.mCraftingMaterialCardsCatalog[param1] != null ? this.mCraftingMaterialCardsCatalog[param1] > 0 : false;
      }
      
      public function checkIfFileExists(param1:String) : Boolean
      {
         return true;
      }
      
      public function addAudioRef(param1:String, param2:String, param3:*) : void
      {
         if(smAudioFilesPaths == null)
         {
            smAudioFilesPaths = new Dictionary(true);
         }
         if(smAudioFilesIds == null)
         {
            smAudioFilesIds = new Dictionary(true);
         }
         if(smAudioFilesPlayers == null)
         {
            smAudioFilesPlayers = new Dictionary(true);
         }
         if(smAudioFilesNames == null)
         {
            smAudioFilesNames = new Dictionary(true);
         }
         if(smAudioFilesNamesByPlayer == null)
         {
            smAudioFilesNamesByPlayer = new Dictionary(true);
         }
         FSDebug.debugTrace("[Adding audio ref] Name: " + param1 + " | PATH: " + param2);
         if(smAudioFilesPaths[param1] != null && smAudioFilesPaths[param1] != param2)
         {
            FSDebug.debugTrace("Overriding path for file " + param1 + " Going from " + smAudioFilesPaths[param1] + " to " + param2);
         }
         smAudioFilesPaths[param1] = param2;
         var _loc4_:Object = this.ANESoundsLoadSound(param3);
         var _loc5_:int = (Boolean(_loc4_)) && _loc4_.hasOwnProperty("id") ? int(_loc4_["id"]) : -1;
         smAudioFilesPlayers[param1] = Boolean(_loc4_) && _loc4_.hasOwnProperty("player") ? _loc4_["player"] : null;
         smAudioFilesIds[param1] = _loc5_;
         smAudioFilesNames[_loc5_] = param1;
         smAudioFilesNames[smAudioFilesPlayers[param1]] = param1;
      }
      
      public function playAndroidSound(param1:String) : void
      {
      }
      
      public function unloadAndroidSound(param1:String) : void
      {
      }
      
      public function stopAndroidSound(param1:String) : void
      {
      }
      
      public function ANESoundsLoadSound(param1:*) : Object
      {
         return null;
      }
      
      public function ANESoundsUnloadSound(param1:int, param2:String = "") : Boolean
      {
         return false;
      }
      
      public function ANESoundsPlaySound(param1:int, param2:String = "") : void
      {
      }
      
      public function ANESoundsstopAndroidSound(param1:int, param2:String = "") : void
      {
      }
   }
}

