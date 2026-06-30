package com.fs.tcgengine.model.popups
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.PvPConnectionMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.rules.AuctionTicketDef;
   import com.fs.tcgengine.model.rules.BoostDef;
   import com.fs.tcgengine.model.rules.DailyRewardDef;
   import com.fs.tcgengine.model.rules.DeckSlotDef;
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.GoldDef;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.model.rules.TutorialDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.screens.FSMapScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.shop.FSShopItem;
   import com.fs.tcgengine.view.meshes.LevelItemContainer;
   import com.fs.tcgengine.view.misc.BoostItem;
   import com.fs.tcgengine.view.popups.Popup;
   import com.fs.tcgengine.view.popups.deckbuilder.PopupDeleteCards;
   import com.fs.tcgengine.view.popups.deckbuilder.PopupUnsavedData;
   import com.fs.tcgengine.view.popups.dungeons.PopupDungeonLevelCompleted;
   import com.fs.tcgengine.view.popups.dungeons.PopupDungeonLevelFailed;
   import com.fs.tcgengine.view.popups.dungeons.PopupDungeonPaymentConfirmation;
   import com.fs.tcgengine.view.popups.dungeons.PopupDungeonRewardsInfo;
   import com.fs.tcgengine.view.popups.dungeons.PopupRaidPaymentConfirmation;
   import com.fs.tcgengine.view.popups.guilds.PopupGuilds;
   import com.fs.tcgengine.view.popups.levels.FSPopupPlayLevel;
   import com.fs.tcgengine.view.popups.levels.PopupActionPointsLeft;
   import com.fs.tcgengine.view.popups.levels.PopupPostBoost;
   import com.fs.tcgengine.view.popups.levels.PopupRankPromote;
   import com.fs.tcgengine.view.popups.misc.PopupAchievements;
   import com.fs.tcgengine.view.popups.misc.PopupAppRating;
   import com.fs.tcgengine.view.popups.misc.PopupAuctionHouseNewUser;
   import com.fs.tcgengine.view.popups.misc.PopupChangeLanguage;
   import com.fs.tcgengine.view.popups.misc.PopupChangeNickPaymentConfirmation;
   import com.fs.tcgengine.view.popups.misc.PopupConfirmLeaveDungeonScreen;
   import com.fs.tcgengine.view.popups.misc.PopupConfirmLeavePvPQueue;
   import com.fs.tcgengine.view.popups.misc.PopupConfirmResetDeck;
   import com.fs.tcgengine.view.popups.misc.PopupConfirmation;
   import com.fs.tcgengine.view.popups.misc.PopupDailyRewards;
   import com.fs.tcgengine.view.popups.misc.PopupEditProfile;
   import com.fs.tcgengine.view.popups.misc.PopupError;
   import com.fs.tcgengine.view.popups.misc.PopupExit;
   import com.fs.tcgengine.view.popups.misc.PopupGetTransferCode;
   import com.fs.tcgengine.view.popups.misc.PopupHowToPlay;
   import com.fs.tcgengine.view.popups.misc.PopupImageAndText;
   import com.fs.tcgengine.view.popups.misc.PopupLogoutFromFB;
   import com.fs.tcgengine.view.popups.misc.PopupMapSelector;
   import com.fs.tcgengine.view.popups.misc.PopupMinimumGoldGained;
   import com.fs.tcgengine.view.popups.misc.PopupNewSeason;
   import com.fs.tcgengine.view.popups.misc.PopupOldPlayerComingBackDailyRewards;
   import com.fs.tcgengine.view.popups.misc.PopupRedeemReferralCode;
   import com.fs.tcgengine.view.popups.misc.PopupRedeemTransferCode;
   import com.fs.tcgengine.view.popups.misc.PopupReferral;
   import com.fs.tcgengine.view.popups.misc.PopupReleaseNotes;
   import com.fs.tcgengine.view.popups.misc.PopupRewards;
   import com.fs.tcgengine.view.popups.misc.PopupSettings;
   import com.fs.tcgengine.view.popups.misc.PopupSettingsConfirmation;
   import com.fs.tcgengine.view.popups.misc.PopupStandard;
   import com.fs.tcgengine.view.popups.misc.PopupTutorial;
   import com.fs.tcgengine.view.popups.misc.PopupXPromo;
   import com.fs.tcgengine.view.popups.purchases.PopupBuyAuctionTicketsBag;
   import com.fs.tcgengine.view.popups.purchases.PopupBuyBoost;
   import com.fs.tcgengine.view.popups.purchases.PopupBuyDeckSlot;
   import com.fs.tcgengine.view.popups.purchases.PopupBuyGoldBag;
   import com.fs.tcgengine.view.popups.purchases.PopupBuyPostBoost;
   import com.fs.tcgengine.view.popups.purchases.PopupBuyVIPPack;
   import com.fs.tcgengine.view.popups.purchases.PopupProductDetail;
   import com.fs.tcgengine.view.popups.purchases.PopupShopItem;
   import com.fs.tcgengine.view.popups.pvp.PopupOpponentFound;
   import com.fs.tcgengine.view.popups.pvp.PopupPlayPvPOffline;
   import com.fs.tcgengine.view.popups.pvp.PopupPlayPvPOnline;
   import com.fs.tcgengine.view.popups.pvp.PopupPvPRewardsInfo;
   import com.fs.tcgengine.view.popups.pvp.PopupSearchingPvPOpponent;
   import com.fs.tcgengine.view.popups.pvp.PopupWaitingForOpponent;
   import com.fs.tcgengine.view.popups.pvp.PopupWaitingForOpponentToSyncBattle;
   import com.fs.tcgengine.view.popups.quests.PopupBattlePass;
   import com.fs.tcgengine.view.popups.quests.PopupQuest;
   import com.fs.tcgengine.view.popups.raids.PopupRaidLevelCompleted;
   import com.fs.tcgengine.view.popups.raids.PopupRaidLevelFailed;
   import com.fs.tcgengine.view.popups.social.PopupRegisterKong;
   import com.greensock.TweenMax;
   import flash.utils.Dictionary;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class FSPopupMng extends Component
   {
      
      public static var smPopupsResourcesLoaded:Dictionary;
      
      public static const STANDARD_POPUP_NAME:String = "standardPopup";
      
      public static const LEVEL_COMPLETED_POPUP_NAME:String = "levelCompletedPopup";
      
      public static const LEVEL_FAILED_POPUP_NAME:String = "levelFailedPopup";
      
      public static const PLAY_LEVEL_POPUP_NAME:String = "playLevelPopup";
      
      public static const RAID_PLAY_LEVEL_POPUP_NAME:String = "raidPlayLevelPopup";
      
      public static const RANK_PROMOTE_POPUP_NAME:String = "rankPromotePopup";
      
      public static const POST_BOOST_POPUP_NAME:String = "postBoostPopup";
      
      public static const SHOP_ITEM_POPUP_NAME:String = "shopItemPopup";
      
      public static const TUTORIAL_POPUP_NAME:String = "tutorialPopup";
      
      public static const PVP_MATCH_OVER_POPUP_NAME:String = "pvpMatchOverPopup";
      
      public static const PVP_MATCH_DESYNCHRONIZED_POPUP_NAME:String = "pvpMatchDesynchronizedPopup";
      
      public static const PVP_MATCH_DRAW_POPUP_NAME:String = "pvpMatchDrawPopup";
      
      public static const SEARCHING_PVP_OPPONENT_POPUP_NAME:String = "searchingPvPOpponentPopup";
      
      public static const OPPONENT_FOUND_POPUP_NAME:String = "opponentFoundPopup";
      
      public static const WAITING_FOR_OPPONENT_POPUP_NAME:String = "waitingForOpponentPopup";
      
      public static const WAITING_FOR_OPPONENT_TO_SYNC_BATTLE_POPUP_NAME:String = "waitingForOpponentPopupToSyncBattle";
      
      public static const ALREADY_IN_PVP_QUEUE_POPUP_NAME:String = "alreadyInPvPQueuePopup";
      
      public static const SETTINGS_POPUP_NAME:String = "settingsPopup";
      
      public static const SETTINGS_CONFIRMATION_POPUP_NAME:String = "settingConfirmationPopup";
      
      public static const HOW_TO_PLAY_POPUP_NAME:String = "howToPlayPopup";
      
      public static const BUY_BOOST_POPUP_NAME:String = "buyBoostPopup";
      
      public static const BUY_POST_BOOST_POPUP_NAME:String = "buyPostBoostPopup";
      
      public static const BUY_DECK_SLOT_POPUP_NAME:String = "buyDeckSlotPopup";
      
      public static const BUY_GOLD_BAG_POPUP_NAME:String = "buyGoldBagPopup";
      
      public static const PLAY_PVP_OFFLINE_POPUP_NAME:String = "playPvPOfflinePopup";
      
      public static const PLAY_PVP_ONLINE_POPUP_NAME:String = "playPvPOnlinePopup";
      
      public static const EDIT_PROFILE_POPUP_NAME:String = "editProfilePopup";
      
      public static const GOLD_MIN_ACHIEVED_POPUP_NAME:String = "250GoldAchievedPopup";
      
      public static const DAILY_REWARDS_POPUP_NAME:String = "dailyRewardsPopup";
      
      public static const OLD_PLAYER_COMING_BACK_DAILY_REWARDS_POPUP_NAME:String = "oldPlayerComingBackdailyRewardsPopup";
      
      public static const ACHIEVEMENTS_POPUP_NAME:String = "achievementsPopup";
      
      public static const QUEST_POPUP_NAME:String = "questPopup";
      
      public static const LEAVE_PVP_QUEUE_POPUP_NAME:String = "leavePvPQueuePopup";
      
      public static const ERROR_POPUP_NAME:String = "errorPopup";
      
      public static const NEW_SEASON_POPUP_NAME:String = "newPvPSeasonPopup";
      
      public static const REGISTER_KONG_POPUP_NAME:String = "registerKongPopup";
      
      public static const RESET_DECK_POPUP_NAME:String = "resetDeckPopup";
      
      public static const RATE_APP_POPUP_NAME:String = "rateAppPopup";
      
      public static const CHANGE_LANGUAGE_POPUP_NAME:String = "changeLanguagePopup";
      
      public static const DUNGEON_LEVEL_COMPLETED_POPUP_NAME:String = "dungeonLevelCompleted";
      
      public static const DUNGEON_LEVEL_FAILED_POPUP_NAME:String = "dungeonLevelFailed";
      
      public static const RAID_LEVEL_COMPLETED_POPUP_NAME:String = "raidLevelCompleted";
      
      public static const RAID_LEVEL_FAILED_POPUP_NAME:String = "raidLevelFailed";
      
      public static const RAID_REWARDS_POPUP_NAME:String = "raidRewardPopup";
      
      public static const RAID_PAYMENT_CONFIRMATION:String = "raidPaymentConfirmation";
      
      public static const GUILDS_POPUP_NAME:String = "guildsPopup";
      
      public static const BATTLE_PASS_POPUP_NAME:String = "battlePassPopup";
      
      public static const BUY_VIP_PACK_NAME:String = "vipPack";
      
      public static const BUY_AUCTION_TICKETS_BAG_POPUP_NAME:String = "buyAuctionTicketsBagPopup";
      
      public static const PVP_SEASON_REWARD_POPUP_NAME:String = "pvpSeasonRewardPopup";
      
      public static const DUNGEON_REWARD_POPUP_NAME:String = "dungeonRewardPopup";
      
      public static const AUCTION_HOUSE_NEW_USER_POPUP_NAME:String = "AUNewUserPopup";
      
      public static const AUCTION_TICKET_BUY:String = "auctionTicketBuy";
      
      public static const REWARDS_POPUP_NAME:String = "popupRewards";
      
      public static const RELEASE_NOTES_POPUP_NAME:String = "releaseNotesPopup";
      
      public static const X_PROMO_POPUP_NAME:String = "xpromoPopup";
      
      public static const REFERRAL_POPUP_NAME:String = "referralPopup";
      
      public static const REDEEM_REFERRAL_CODE_POPUP_NAME:String = "redeemRefferalCodePopup";
      
      public static const PRODUCT_DETAIL_POPUP_NAME:String = "productDetailPopup";
      
      public static const MAP_SELECTOR_POPUP_NAME:String = "mapSelectorPopup";
      
      public static const REDEEM_TRANSFER_CODE_POPUP_NAME:String = "redeemTransferCodePopup";
      
      public static const GET_TRANSFER_CODE_POPUP_NAME:String = "getTransferCodePopup";
      
      public static const IMAGE_AND_TEXT_POPUP_NAME:String = "imageAndTextPopup";
      
      protected var mPopupsCatalog:Dictionary;
      
      private var mPopupShown:Popup;
      
      private var mPopupLoading:Boolean;
      
      private var mPopupOnBackground:Popup;
      
      private var mPopupsQueue:Vector.<Object>;
      
      private var mQueuedPopupTimerId:int;
      
      public function FSPopupMng()
      {
         super();
         this.mPopupsCatalog = new Dictionary(true);
      }
      
      public static function areScreenPopupsResourcesLoaded(param1:String) : Boolean
      {
         var _loc2_:Boolean = false;
         if(smPopupsResourcesLoaded)
         {
            _loc2_ = Boolean(smPopupsResourcesLoaded[param1]);
         }
         return _loc2_;
      }
      
      public static function setScreenPopupsResourcesLoaded(param1:String, param2:Boolean) : void
      {
         if(smPopupsResourcesLoaded == null)
         {
            smPopupsResourcesLoaded = new Dictionary(true);
         }
         smPopupsResourcesLoaded[param1] = param2;
      }
      
      public function purgeAllPopups() : void
      {
         DictionaryUtils.clearDictionary(this.mPopupsCatalog);
      }
      
      protected function getPopup(param1:String, param2:Class) : *
      {
         var _loc3_:* = undefined;
         FSDebug.debugTrace("Attempting to open: " + param1);
         if(Screen.smOpeningPack || Root.assets.isLoading || this.mPopupShown != null && this.mPopupOnBackground != this.mPopupShown || this.mPopupLoading)
         {
            FSDebug.debugTrace("Setting interval to \'x\' seconds, couldn\'t open the popup");
            if(this.mQueuedPopupTimerId == 0)
            {
               this.mQueuedPopupTimerId = setInterval(this.showFirstQueuedPopup,1500);
            }
            if(this.mPopupLoading)
            {
               TweenMax.delayedCall(4,this.setPopupIsLoading,[false]);
            }
            return null;
         }
         if(this.mPopupsCatalog == null)
         {
            this.mPopupsCatalog = new Dictionary(true);
         }
         _loc3_ = this.mPopupsCatalog[param1];
         if(_loc3_ == null)
         {
            _loc3_ = new param2();
            _loc3_.name = param1;
            this.mPopupsCatalog[param1] = _loc3_;
         }
         return _loc3_;
      }
      
      public function removePopup(param1:String) : void
      {
         if(this.mPopupsCatalog)
         {
            if(this.mPopupsCatalog[param1] != null)
            {
               this.mPopupsCatalog[param1] = null;
               delete this.mPopupsCatalog[param1];
            }
         }
      }
      
      private function getStandardPopup() : PopupStandard
      {
         var _loc1_:PopupStandard = null;
         var _loc2_:PopupStandard = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(STANDARD_POPUP_NAME,PopupStandard) as PopupStandard;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openStandardPopup(param1:String) : void
      {
         var _loc2_:PopupStandard = this.getStandardPopup();
         if(_loc2_ != null)
         {
            _loc2_.openPopup();
            _loc2_.setMainFieldText(param1);
         }
         else
         {
            this.addPopupToQueue(this.openStandardPopup,[param1]);
         }
      }
      
      private function getUnsavedDataPopup() : PopupUnsavedData
      {
         var _loc1_:PopupUnsavedData = null;
         var _loc2_:PopupUnsavedData = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(STANDARD_POPUP_NAME,PopupUnsavedData) as PopupUnsavedData;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openUnsavedDataPopup() : void
      {
         var _loc1_:PopupUnsavedData = this.getUnsavedDataPopup();
         if(_loc1_ != null)
         {
            _loc1_.setMainFieldText(TextManager.getText("TID_DECKBUILDER_EXIT_UNSAVED"));
            _loc1_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openUnsavedDataPopup);
         }
      }
      
      private function getLogoutFromFBPopup() : PopupLogoutFromFB
      {
         var _loc1_:PopupLogoutFromFB = null;
         var _loc2_:PopupLogoutFromFB = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(STANDARD_POPUP_NAME,PopupLogoutFromFB) as PopupLogoutFromFB;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openLogoutFromFBPopup() : void
      {
         var _loc1_:PopupLogoutFromFB = this.getLogoutFromFBPopup();
         if(_loc1_ != null)
         {
            _loc1_.setMainFieldText(TextManager.getText("TID_FACEBOOK_LOGOUT_CONFIRMATION"));
            _loc1_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openLogoutFromFBPopup);
         }
      }
      
      private function getActionPointsLeftPopup() : PopupActionPointsLeft
      {
         var _loc1_:PopupActionPointsLeft = null;
         var _loc2_:PopupActionPointsLeft = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(STANDARD_POPUP_NAME,PopupActionPointsLeft) as PopupActionPointsLeft;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openActionPointsLeftPopup(param1:String, param2:BattleEngine, param3:Boolean = true) : void
      {
         var _loc4_:PopupActionPointsLeft = null;
         if(InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            _loc4_ = this.getActionPointsLeftPopup();
            if(_loc4_ != null)
            {
               _loc4_.setup(param2,param3);
               _loc4_.setMainFieldText(param1);
               _loc4_.openPopup();
            }
            else
            {
               this.addPopupToQueue(this.openActionPointsLeftPopup,[param1,param2,param3]);
            }
         }
      }
      
      private function getRaidPaymentConfirmationPopup() : PopupRaidPaymentConfirmation
      {
         var _loc1_:PopupRaidPaymentConfirmation = null;
         var _loc2_:PopupRaidPaymentConfirmation = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(RAID_PAYMENT_CONFIRMATION,PopupRaidPaymentConfirmation) as PopupRaidPaymentConfirmation;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      private function getChangeNickPaymentConfirmationPopup() : PopupChangeNickPaymentConfirmation
      {
         var _loc1_:PopupChangeNickPaymentConfirmation = null;
         var _loc2_:PopupChangeNickPaymentConfirmation = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(STANDARD_POPUP_NAME,PopupChangeNickPaymentConfirmation) as PopupChangeNickPaymentConfirmation;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      private function getDungeonPaymentConfirmationPopup() : PopupDungeonPaymentConfirmation
      {
         var _loc1_:PopupDungeonPaymentConfirmation = null;
         var _loc2_:PopupDungeonPaymentConfirmation = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(STANDARD_POPUP_NAME,PopupDungeonPaymentConfirmation) as PopupDungeonPaymentConfirmation;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openDungeonPaymentConfirmationPopup(param1:String, param2:FSNumber) : void
      {
         var _loc3_:PopupDungeonPaymentConfirmation = this.getDungeonPaymentConfirmationPopup();
         if(_loc3_ != null)
         {
            _loc3_.setGoldCost(param2);
            _loc3_.setMainFieldText(param1);
            _loc3_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openDungeonPaymentConfirmationPopup,[param1,param2]);
         }
      }
      
      public function openRaidPaymentConfirmationPopup(param1:String, param2:int = 0) : void
      {
         var _loc3_:PopupRaidPaymentConfirmation = this.getRaidPaymentConfirmationPopup();
         if(_loc3_ != null)
         {
            _loc3_.setGoldCost(param2);
            _loc3_.setMainFieldText(param1);
            _loc3_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openRaidPaymentConfirmationPopup,[param1,param2]);
         }
      }
      
      public function openChangeNickConfirmationPopup(param1:String, param2:Popup, param3:int = 0, param4:String = "") : void
      {
         var _loc5_:PopupChangeNickPaymentConfirmation = this.getChangeNickPaymentConfirmationPopup();
         if(_loc5_ != null)
         {
            _loc5_.setGoldCost(param3);
            _loc5_.setNewName(param4);
            _loc5_.setParentPopup(param2);
            _loc5_.setMainFieldText(param1);
            _loc5_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openChangeNickConfirmationPopup,[param1,param2,param3,param4]);
         }
      }
      
      private function getRateAppPopup() : PopupAppRating
      {
         var _loc1_:PopupAppRating = null;
         var _loc2_:PopupAppRating = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(RATE_APP_POPUP_NAME,PopupAppRating) as PopupAppRating;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openRateAppPopup() : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc1_:PopupAppRating = this.getRateAppPopup();
         if(_loc1_ != null)
         {
            _loc2_ = TextManager.getText("TID_LOVE_WW2TCG",true);
            _loc3_ = "";
            if(Utils.isIOS())
            {
               _loc3_ = TextManager.getText("TID_RATE_APPSTORE",true);
            }
            else if(Utils.isAndroid())
            {
               _loc3_ = TextManager.getText("TID_RATE_PLAYSTORE",true);
            }
            else if(Utils.isDesktop())
            {
               _loc3_ = TextManager.getText("TID_RATE_STEAM",true);
            }
            else if(Utils.isBrowser())
            {
               if(InstanceMng.getApplication().isFacebookBrowser())
               {
                  _loc3_ = TextManager.getText("TID_LIKE_FB_PAGE",true);
               }
               else
               {
                  _loc3_ = TextManager.replaceParameters(TextManager.getText("TID_REWARDS_KONG_RATE"),[Config.getConfig().gameGetGoldGiftKongRate()]);
               }
            }
            _loc4_ = _loc2_ + "\n" + _loc3_;
            _loc1_.setMainFieldText(_loc4_);
            _loc1_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openRateAppPopup);
         }
      }
      
      private function getChangeLanguagePopup() : PopupChangeLanguage
      {
         var _loc1_:PopupChangeLanguage = null;
         var _loc2_:PopupChangeLanguage = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(CHANGE_LANGUAGE_POPUP_NAME,PopupChangeLanguage) as PopupChangeLanguage;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openChangeLanguagePopup() : void
      {
         var _loc1_:PopupChangeLanguage = this.getChangeLanguagePopup();
         if(_loc1_ != null)
         {
            _loc1_.setMainFieldText(TextManager.getText("TID_SETTINGS_CHANGE_LANGUAGE"));
            _loc1_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openChangeLanguagePopup);
         }
      }
      
      private function getExitPopup() : PopupExit
      {
         var _loc1_:PopupExit = null;
         var _loc2_:PopupExit = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(STANDARD_POPUP_NAME,PopupExit) as PopupExit;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openExitPopup() : void
      {
         var _loc1_:PopupExit = this.getExitPopup();
         if(_loc1_ != null)
         {
            _loc1_.setMainFieldText(TextManager.getText("TID_GEN_EXIT"));
            _loc1_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openExitPopup);
         }
      }
      
      public function openLevelCompletedPopup(param1:LevelDef = null, param2:Boolean = true) : void
      {
         if(InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            this.openEndLevelPopup(param1.getSku(),true,param2);
         }
      }
      
      public function openLevelFailedPopup(param1:LevelDef = null) : void
      {
         var _loc2_:int = 0;
         if(InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            _loc2_ = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
            InstanceMng.getApplication().firebaseAddToDatabase(param1.getLevelIndex(),_loc2_,false,FSBattleScreen.smUserPayedInThisLevel,false);
            this.openEndLevelPopup(param1.getSku(),false);
         }
      }
      
      public function openPlayLevelPopup(param1:String, param2:Boolean = false, param3:LevelItemContainer = null) : void
      {
         var _loc4_:FSPopupPlayLevel = this.getPlayLevelPopup();
         if(_loc4_ != null)
         {
            _loc4_.setupPopup(param1,false,false,param2,false,true,false,false,param3);
            _loc4_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openPlayLevelPopup,[param1,param2,param3]);
         }
      }
      
      protected function getPlayLevelPopup() : FSPopupPlayLevel
      {
         var _loc1_:FSPopupPlayLevel = null;
         var _loc2_:FSPopupPlayLevel = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(PLAY_LEVEL_POPUP_NAME,FSPopupPlayLevel) as FSPopupPlayLevel;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openEndLevelPopup(param1:String, param2:Boolean, param3:Boolean = false) : void
      {
         var _loc4_:FSPopupPlayLevel = this.getPlayLevelPopup();
         if(_loc4_ != null)
         {
            _loc4_.setupPopup(param1,true,param2,false,false,true,false,param3);
            _loc4_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openEndLevelPopup,[param1,param2,param3]);
         }
      }
      
      public function openPlayRaidLevelPopup(param1:String) : void
      {
         this.openPlayLevelPopup(param1,true);
      }
      
      private function getPlayPvPPopupOnline() : PopupPlayPvPOnline
      {
         var _loc1_:PopupPlayPvPOnline = null;
         var _loc2_:PopupPlayPvPOnline = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(PLAY_PVP_ONLINE_POPUP_NAME,PopupPlayPvPOnline) as PopupPlayPvPOnline;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openPlayPvPOnlinePopup(param1:Boolean = false) : void
      {
         var _loc2_:PopupPlayPvPOnline = this.getPlayPvPPopupOnline();
         if(_loc2_ != null)
         {
            _loc2_.goToSyncPlayersOnAccept(param1);
            _loc2_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openPlayPvPOnlinePopup,[param1]);
         }
      }
      
      private function getPlayPvPOfflinePopup() : PopupPlayPvPOffline
      {
         var _loc1_:PopupPlayPvPOffline = null;
         var _loc2_:PopupPlayPvPOffline = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(PLAY_PVP_OFFLINE_POPUP_NAME,PopupPlayPvPOffline) as PopupPlayPvPOffline;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openPlayPvPOfflinePopup() : void
      {
         var _loc1_:PopupPlayPvPOffline = this.getPlayPvPOfflinePopup();
         if(_loc1_ != null)
         {
            _loc1_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openPlayPvPOfflinePopup);
         }
      }
      
      private function getRankPromotePopup() : PopupRankPromote
      {
         var _loc1_:PopupRankPromote = null;
         var _loc2_:PopupRankPromote = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(RANK_PROMOTE_POPUP_NAME,PopupRankPromote) as PopupRankPromote;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openRankPromotePopup(param1:LevelDef, param2:Boolean = false) : void
      {
         var _loc3_:PopupRankPromote = null;
         if(Config.getConfig().gameHasBuildingBadges())
         {
            _loc3_ = this.getRankPromotePopup();
            if(_loc3_ != null)
            {
               _loc3_.setRankIndex(InstanceMng.getUserDataMng().getOwnerUserData().getRankIndex());
               _loc3_.setLevelDef(param1);
               _loc3_.setIsOpenFromProgress(param2);
               _loc3_.openPopup();
            }
            else
            {
               this.addPopupToQueue(this.openRankPromotePopup,[param1,param2]);
            }
         }
         else if(InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            _loc3_ = this.getRankPromotePopup();
            if(_loc3_ != null)
            {
               _loc3_.setRankIndex(InstanceMng.getUserDataMng().getOwnerUserData().getRankIndex());
               _loc3_.setLevelDef(param1);
               _loc3_.openPopup();
            }
            else
            {
               this.addPopupToQueue(this.openRankPromotePopup,[param1,param2]);
            }
         }
      }
      
      private function getPostBoostPopup() : PopupPostBoost
      {
         var _loc1_:PopupPostBoost = null;
         var _loc2_:PopupPostBoost = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(POST_BOOST_POPUP_NAME,PopupPostBoost) as PopupPostBoost;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openPostBoostPopup() : void
      {
         var _loc1_:PopupPostBoost = this.getPostBoostPopup();
         if(_loc1_ != null)
         {
            _loc1_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openPostBoostPopup);
         }
      }
      
      private function getShopItemPopup() : PopupShopItem
      {
         var _loc1_:PopupShopItem = null;
         var _loc2_:PopupShopItem = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(SHOP_ITEM_POPUP_NAME,PopupShopItem) as PopupShopItem;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openShopItemPopup(param1:FSShopItem) : void
      {
         var _loc2_:PopupShopItem = this.getShopItemPopup();
         if(_loc2_ != null)
         {
            _loc2_.setupPopup(param1);
            _loc2_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openShopItemPopup,[param1]);
         }
      }
      
      private function getBuyBoostPopup() : PopupBuyBoost
      {
         var _loc1_:PopupBuyBoost = null;
         var _loc2_:PopupBuyBoost = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(BUY_BOOST_POPUP_NAME,PopupBuyBoost) as PopupBuyBoost;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openBuyBoostPopup(param1:BoostItem, param2:BoostDef = null) : void
      {
         var _loc3_:PopupBuyBoost = this.getBuyBoostPopup();
         if(_loc3_ != null)
         {
            if(param1 != null || param2 != null)
            {
               if(param1)
               {
                  _loc3_.setupPopup(param1.getBoostDef());
               }
               else if(param2)
               {
                  _loc3_.setupPopup(param2);
               }
            }
            _loc3_.setBoostItem(param1);
            if(param2 != null)
            {
               _loc3_.setBoostDef(param2);
            }
            _loc3_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openBuyBoostPopup,[param1,param2]);
         }
      }
      
      private function getBuyPostBoostPopup() : PopupBuyPostBoost
      {
         var _loc1_:PopupBuyPostBoost = null;
         var _loc2_:PopupBuyPostBoost = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(BUY_POST_BOOST_POPUP_NAME,PopupBuyPostBoost) as PopupBuyPostBoost;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openBuyPostBoostPopup(param1:BoostDef = null) : void
      {
         var _loc2_:PopupBuyPostBoost = this.getBuyPostBoostPopup();
         if(_loc2_ != null)
         {
            if(param1)
            {
               _loc2_.setupPopup(param1);
               _loc2_.setBoostDef(param1);
            }
            _loc2_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openBuyPostBoostPopup,[param1]);
         }
      }
      
      private function getBuyDeckSlotPopup() : PopupBuyDeckSlot
      {
         var _loc1_:PopupBuyDeckSlot = null;
         var _loc2_:PopupBuyDeckSlot = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(BUY_DECK_SLOT_POPUP_NAME,PopupBuyDeckSlot) as PopupBuyDeckSlot;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openDeckSlotPopup(param1:DeckSlotDef) : void
      {
         var _loc2_:PopupBuyDeckSlot = this.getBuyDeckSlotPopup();
         if(_loc2_ != null)
         {
            _loc2_.setupPopup(param1);
            _loc2_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openDeckSlotPopup,[param1]);
         }
      }
      
      private function getBuyGoldBagPopup() : PopupBuyGoldBag
      {
         var _loc1_:PopupBuyGoldBag = null;
         var _loc2_:PopupBuyGoldBag = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(BUY_GOLD_BAG_POPUP_NAME,PopupBuyGoldBag) as PopupBuyGoldBag;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openBuyGoldBagPopup(param1:GoldDef) : void
      {
         var _loc2_:PopupBuyGoldBag = this.getBuyGoldBagPopup();
         if(_loc2_ != null)
         {
            _loc2_.setupPopup(param1);
            _loc2_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openBuyGoldBagPopup,[param1]);
         }
      }
      
      public function openBuyAuctionTicketsBagPopup(param1:AuctionTicketDef) : void
      {
         var _loc2_:PopupBuyAuctionTicketsBag = this.getBuyAuctionTicketsBagPopup();
         if(_loc2_ != null)
         {
            _loc2_.setupPopup(param1);
            _loc2_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openBuyAuctionTicketsBagPopup,[param1]);
         }
      }
      
      private function getBuyAuctionTicketsBagPopup() : PopupBuyAuctionTicketsBag
      {
         var _loc1_:PopupBuyAuctionTicketsBag = null;
         var _loc2_:PopupBuyAuctionTicketsBag = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(AUCTION_TICKET_BUY,PopupBuyAuctionTicketsBag) as PopupBuyAuctionTicketsBag;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      private function getBuyVIPPackPopup() : PopupBuyVIPPack
      {
         var _loc1_:PopupBuyVIPPack = null;
         var _loc2_:PopupBuyVIPPack = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(BUY_VIP_PACK_NAME,PopupBuyVIPPack) as PopupBuyVIPPack;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openBuyVIPPackPopup(param1:Def) : void
      {
         var _loc2_:PopupBuyVIPPack = this.getBuyVIPPackPopup();
         if(_loc2_ != null)
         {
            _loc2_.setupPopup(param1);
            _loc2_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openBuyVIPPackPopup,[param1]);
         }
      }
      
      private function getDeleteCardsPopup() : PopupDeleteCards
      {
         var _loc1_:PopupDeleteCards = null;
         var _loc2_:PopupDeleteCards = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(STANDARD_POPUP_NAME,PopupDeleteCards) as PopupDeleteCards;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openDeleteCardsPopup(param1:String) : void
      {
         var _loc2_:PopupDeleteCards = this.getDeleteCardsPopup();
         if(_loc2_ != null)
         {
            _loc2_.setMainFieldText(param1);
            _loc2_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openDeleteCardsPopup,[param1]);
         }
      }
      
      private function getTutorialPopup() : PopupTutorial
      {
         var _loc1_:PopupTutorial = null;
         var _loc2_:PopupTutorial = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(TUTORIAL_POPUP_NAME,PopupTutorial) as PopupTutorial;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openTutorialPopup(param1:TutorialDef) : void
      {
         var _loc2_:PopupTutorial = null;
         if(InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            _loc2_ = this.getTutorialPopup();
            if(_loc2_ != null)
            {
               _loc2_.setupPopup(param1);
               _loc2_.openPopup();
            }
            else
            {
               this.addPopupToQueue(this.openTutorialPopup,[param1]);
            }
         }
      }
      
      private function getSearchingPvPOpponentPopup() : PopupSearchingPvPOpponent
      {
         var _loc1_:PopupSearchingPvPOpponent = null;
         var _loc2_:PopupSearchingPvPOpponent = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(SEARCHING_PVP_OPPONENT_POPUP_NAME,PopupSearchingPvPOpponent) as PopupSearchingPvPOpponent;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openSearchingPvPopponentPopup() : void
      {
         var _loc1_:PopupSearchingPvPOpponent = this.getSearchingPvPOpponentPopup();
         if(_loc1_ != null)
         {
            _loc1_.setMainFieldText(TextManager.getText("TID_PVP_SEARCHING",true));
            _loc1_.setupPopup();
            _loc1_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openSearchingPvPopponentPopup);
         }
      }
      
      private function getOpponentFoundPopup() : PopupOpponentFound
      {
         var _loc1_:PopupOpponentFound = null;
         var _loc2_:PopupOpponentFound = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(OPPONENT_FOUND_POPUP_NAME,PopupOpponentFound) as PopupOpponentFound;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openOpponentFoundPopup(param1:String, param2:Object, param3:String, param4:Object = null, param5:Boolean = false, param6:Boolean = false) : void
      {
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:Object = null;
         var _loc11_:String = null;
         var _loc7_:PopupOpponentFound = this.getOpponentFoundPopup();
         if(_loc7_ != null)
         {
            _loc8_ = param3;
            if(param4 != null && (PvPConnectionMng.smPlayingFriendlyMatch || param6))
            {
               _loc10_ = param4.u1 != null && param4.u1.uid == InstanceMng.getServerConnection().getUserId() ? param4.u2 : param4.u1;
               if(_loc10_ != null && _loc10_.nick != "" && _loc10_.nick != null)
               {
                  _loc11_ = param5 ? TextManager.getText("TID_PVP_WANT_PLAY") : TextManager.getText("TID_PVP_FB_ACCEPTED");
                  if(PvPConnectionMng.smPlayingFriendlyMatch && !param5)
                  {
                     _loc11_ = TextManager.getText("TID_PVP_FB_RECEIVED");
                  }
                  _loc8_ = String(_loc10_.nick).toUpperCase() + " " + _loc11_;
               }
            }
            _loc9_ = Boolean(_loc10_) && (PvPConnectionMng.smPlayingFriendlyMatch || param6) ? _loc10_.extId : "";
            _loc7_.setMainFieldText(_loc8_);
            _loc7_.setup(param1,param2,_loc8_,_loc9_);
            _loc7_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openOpponentFoundPopup,[param1,param2,param3,param4,param5,param6]);
         }
      }
      
      private function getWaitingForOpponentPopup() : PopupWaitingForOpponent
      {
         var _loc1_:PopupWaitingForOpponent = null;
         var _loc2_:PopupWaitingForOpponent = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(WAITING_FOR_OPPONENT_POPUP_NAME,PopupWaitingForOpponent) as PopupWaitingForOpponent;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openWaitingForOpponentPopup(param1:String, param2:String, param3:Boolean, param4:Boolean = false) : void
      {
         var _loc5_:PopupWaitingForOpponent = this.getWaitingForOpponentPopup();
         if(_loc5_ != null)
         {
            _loc5_.setMainFieldText(param2);
            _loc5_.setup(param1,param2,param3,param4);
            _loc5_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openWaitingForOpponentPopup,[param1,param2,param3,param4]);
         }
      }
      
      private function getWaitingForOpponentToSyncBattlePopup() : PopupWaitingForOpponentToSyncBattle
      {
         var _loc1_:PopupWaitingForOpponentToSyncBattle = null;
         var _loc2_:PopupWaitingForOpponentToSyncBattle = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(WAITING_FOR_OPPONENT_TO_SYNC_BATTLE_POPUP_NAME,PopupWaitingForOpponentToSyncBattle) as PopupWaitingForOpponentToSyncBattle;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openWaitingForOpponenToSyncBattlePopup(param1:String, param2:String) : void
      {
         var _loc3_:PopupWaitingForOpponentToSyncBattle = this.getWaitingForOpponentToSyncBattlePopup();
         if(_loc3_ != null)
         {
            _loc3_.setMainFieldText(param2);
            _loc3_.setup(param1,param2,false);
            _loc3_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openWaitingForOpponenToSyncBattlePopup,[param1,param2]);
         }
      }
      
      private function getSettingsPopup() : PopupSettings
      {
         var _loc1_:PopupSettings = null;
         var _loc2_:PopupSettings = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(SETTINGS_POPUP_NAME,PopupSettings) as PopupSettings;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openSettingsPopup() : void
      {
         var _loc1_:PopupSettings = this.getSettingsPopup();
         if(_loc1_ != null)
         {
            _loc1_.openPopup();
         }
      }
      
      private function getSettingsConfirmationPopup() : PopupSettingsConfirmation
      {
         var _loc1_:PopupSettingsConfirmation = null;
         var _loc2_:PopupSettingsConfirmation = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(SETTINGS_CONFIRMATION_POPUP_NAME,PopupSettingsConfirmation) as PopupSettingsConfirmation;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openSettingsConfirmationPopup(param1:String, param2:String, param3:String, param4:String, param5:Function) : void
      {
         var _loc6_:PopupSettingsConfirmation = this.getSettingsConfirmationPopup();
         if(_loc6_ != null)
         {
            _loc6_.setup(param1,param2,param3,param4,param5);
            _loc6_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openSettingsConfirmationPopup,[param1,param2,param3,param4,param5]);
         }
      }
      
      private function getHowToPlayPopup() : PopupHowToPlay
      {
         var _loc1_:PopupHowToPlay = null;
         var _loc2_:PopupHowToPlay = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(HOW_TO_PLAY_POPUP_NAME,PopupHowToPlay) as PopupHowToPlay;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openHowToPlayPopup() : void
      {
         var _loc1_:PopupHowToPlay = this.getHowToPlayPopup();
         if(_loc1_ != null)
         {
            _loc1_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openHowToPlayPopup);
         }
      }
      
      private function getEditProfilePopup() : PopupEditProfile
      {
         var _loc1_:PopupEditProfile = null;
         var _loc2_:PopupEditProfile = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(EDIT_PROFILE_POPUP_NAME,PopupEditProfile) as PopupEditProfile;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openEditProfilePopup() : void
      {
         var _loc1_:PopupEditProfile = this.getEditProfilePopup();
         if(_loc1_ != null)
         {
            _loc1_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openEditProfilePopup);
         }
      }
      
      private function getMinimumGoldAchievedPopup() : PopupMinimumGoldGained
      {
         var _loc1_:PopupMinimumGoldGained = null;
         var _loc2_:PopupMinimumGoldGained = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(GOLD_MIN_ACHIEVED_POPUP_NAME,PopupMinimumGoldGained) as PopupMinimumGoldGained;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openMinimumGoldAchievedPopup() : void
      {
         var _loc1_:PopupMinimumGoldGained = this.getMinimumGoldAchievedPopup();
         if(_loc1_ != null)
         {
            _loc1_.setMainFieldText(TextManager.getText("TID_GEN_250_GOLDS"));
            _loc1_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openMinimumGoldAchievedPopup);
         }
      }
      
      private function getDailyRewardsPopup() : PopupDailyRewards
      {
         var _loc1_:PopupDailyRewards = null;
         var _loc2_:PopupDailyRewards = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(DAILY_REWARDS_POPUP_NAME,PopupDailyRewards) as PopupDailyRewards;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openDailyRewardsPopup(param1:DailyRewardDef) : void
      {
         var _loc2_:PopupDailyRewards = this.getDailyRewardsPopup();
         if(_loc2_ != null)
         {
            _loc2_.setupPopup(param1);
            _loc2_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openDailyRewardsPopup,[param1]);
         }
      }
      
      private function getOldPlayerComingBackDailyRewardsPopup() : PopupOldPlayerComingBackDailyRewards
      {
         var _loc1_:PopupOldPlayerComingBackDailyRewards = null;
         var _loc2_:PopupOldPlayerComingBackDailyRewards = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(OLD_PLAYER_COMING_BACK_DAILY_REWARDS_POPUP_NAME,PopupOldPlayerComingBackDailyRewards) as PopupOldPlayerComingBackDailyRewards;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openOldPlayerComingBackDailyRewardsPopup(param1:DailyRewardDef) : void
      {
         var _loc2_:PopupOldPlayerComingBackDailyRewards = this.getOldPlayerComingBackDailyRewardsPopup();
         if(_loc2_ != null)
         {
            _loc2_.setupPopup(param1);
            _loc2_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openOldPlayerComingBackDailyRewardsPopup,[param1]);
         }
      }
      
      private function getGuildsPopup() : PopupGuilds
      {
         var _loc1_:PopupGuilds = null;
         var _loc2_:PopupGuilds = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(GUILDS_POPUP_NAME,PopupGuilds) as PopupGuilds;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openGuildsPopup(param1:String = "") : void
      {
         var _loc3_:UserData = null;
         var _loc4_:Boolean = false;
         var _loc2_:PopupGuilds = this.getGuildsPopup();
         if(_loc2_ != null)
         {
            _loc2_.openPopup();
            _loc3_ = Utils.getOwnerUserData();
            _loc4_ = _loc3_.hasGuild();
            if(param1 != null && param1 != "")
            {
               _loc2_.refreshGuildInfo(param1);
            }
            else if(_loc4_)
            {
               _loc2_.refreshGuildInfo(_loc3_.getGuildId());
            }
            else
            {
               _loc2_.updateSelectedSection(PopupGuilds.JOIN_SECTION);
            }
         }
         else
         {
            this.addPopupToQueue(this.openGuildsPopup,[param1]);
         }
      }
      
      private function getBattlePassPopup() : PopupBattlePass
      {
         var _loc1_:PopupBattlePass = null;
         var _loc2_:PopupBattlePass = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(BATTLE_PASS_POPUP_NAME,PopupBattlePass) as PopupBattlePass;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openBattlePassPopup() : void
      {
         var _loc1_:PopupBattlePass = this.getBattlePassPopup();
         if(_loc1_ != null)
         {
            _loc1_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openBattlePassPopup);
         }
      }
      
      private function getAuctionHouseNewUserPopup() : PopupAuctionHouseNewUser
      {
         var _loc1_:PopupAuctionHouseNewUser = null;
         var _loc2_:PopupAuctionHouseNewUser = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(AUCTION_HOUSE_NEW_USER_POPUP_NAME,PopupAuctionHouseNewUser) as PopupAuctionHouseNewUser;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openAuctionHouseNewUserPopup() : void
      {
         var _loc1_:PopupAuctionHouseNewUser = this.getAuctionHouseNewUserPopup();
         if(_loc1_ != null)
         {
            _loc1_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openAuctionHouseNewUserPopup);
         }
      }
      
      private function getAchievementsPopup() : PopupAchievements
      {
         var _loc1_:PopupAchievements = null;
         var _loc2_:PopupAchievements = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(ACHIEVEMENTS_POPUP_NAME,PopupAchievements) as PopupAchievements;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openAchievementsPopup() : void
      {
         var _loc1_:PopupAchievements = this.getAchievementsPopup();
         if(_loc1_ != null)
         {
            _loc1_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openAchievementsPopup);
         }
      }
      
      private function getLeavePvPQueuePopup() : PopupConfirmLeavePvPQueue
      {
         var _loc1_:PopupConfirmLeavePvPQueue = null;
         var _loc2_:PopupConfirmLeavePvPQueue = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(LEAVE_PVP_QUEUE_POPUP_NAME,PopupConfirmLeavePvPQueue) as PopupConfirmLeavePvPQueue;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openLeavePvPQueuePopup() : void
      {
         var _loc1_:PopupConfirmLeavePvPQueue = this.getLeavePvPQueuePopup();
         if(_loc1_ != null)
         {
            _loc1_.setMainFieldText(TextManager.getText("TID_PVP_QUEUE_EXIT"));
            _loc1_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openLeavePvPQueuePopup);
         }
      }
      
      private function getConfirmResetDeckPopup() : PopupConfirmResetDeck
      {
         var _loc1_:PopupConfirmResetDeck = null;
         var _loc2_:PopupConfirmResetDeck = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(RESET_DECK_POPUP_NAME,PopupConfirmResetDeck) as PopupConfirmResetDeck;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openConfirmResetDeckPopup() : void
      {
         var _loc1_:PopupConfirmResetDeck = this.getConfirmResetDeckPopup();
         if(_loc1_ != null)
         {
            _loc1_.setMainFieldText(TextManager.getText("TID_DB_RESET_CONFIRM"));
            _loc1_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openConfirmResetDeckPopup);
         }
      }
      
      private function getErrorPopup() : PopupError
      {
         var _loc1_:PopupError = null;
         var _loc2_:PopupError = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(ERROR_POPUP_NAME,PopupError) as PopupError;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openErrorPopup(param1:String, param2:Boolean, param3:Boolean = false, param4:Boolean = false) : void
      {
         var _loc5_:PopupError = this.getErrorPopup();
         if(_loc5_ != null)
         {
            _loc5_.setMainFieldText(param1);
            _loc5_.setupPopup(param2,param3,param4);
            _loc5_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openErrorPopup,[param1,param2,param3,param4]);
         }
      }
      
      private function getNewSeasonPopup() : PopupNewSeason
      {
         var _loc1_:PopupNewSeason = null;
         var _loc2_:PopupNewSeason = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(NEW_SEASON_POPUP_NAME,PopupNewSeason) as PopupNewSeason;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openNewSeasonPopup(param1:int, param2:Boolean, param3:Boolean) : void
      {
         var _loc4_:PopupNewSeason = this.getNewSeasonPopup();
         if(_loc4_ != null)
         {
            _loc4_.setupNewSeason(param1,param2,param3);
            _loc4_.setMainFieldText(TextManager.getText("TID_NEW_SEASON") + param1);
            _loc4_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openNewSeasonPopup,[param1,param2,param3]);
         }
      }
      
      private function getRegisterKongPopup() : PopupRegisterKong
      {
         var _loc1_:PopupRegisterKong = null;
         var _loc2_:PopupRegisterKong = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(REGISTER_KONG_POPUP_NAME,PopupRegisterKong) as PopupRegisterKong;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openRegisterKongPopup() : void
      {
         var _loc1_:PopupRegisterKong = this.getRegisterKongPopup();
         if(_loc1_ != null)
         {
            _loc1_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openRegisterKongPopup);
         }
      }
      
      private function getDungeonLevelCompletedPopup() : PopupDungeonLevelCompleted
      {
         var _loc1_:PopupDungeonLevelCompleted = null;
         var _loc2_:PopupDungeonLevelCompleted = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(DUNGEON_LEVEL_COMPLETED_POPUP_NAME,PopupDungeonLevelCompleted) as PopupDungeonLevelCompleted;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openDungeonLevelCompletedPopup(param1:Object) : void
      {
         var _loc2_:PopupDungeonLevelCompleted = null;
         if(InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            _loc2_ = this.getDungeonLevelCompletedPopup();
            if(_loc2_ != null)
            {
               _loc2_.setupRewards(param1);
               _loc2_.openPopup();
            }
            else
            {
               this.addPopupToQueue(this.openDungeonLevelCompletedPopup,[param1]);
            }
         }
      }
      
      private function getRaidLevelCompletedPopup() : PopupRaidLevelCompleted
      {
         var _loc1_:PopupRaidLevelCompleted = null;
         var _loc2_:PopupRaidLevelCompleted = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(RAID_LEVEL_COMPLETED_POPUP_NAME,PopupRaidLevelCompleted) as PopupRaidLevelCompleted;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openRaidLevelCompletedPopup() : void
      {
         var _loc1_:PopupRaidLevelCompleted = null;
         if(InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            _loc1_ = this.getRaidLevelCompletedPopup();
            if(_loc1_ != null)
            {
               _loc1_.openPopup();
            }
            else
            {
               this.addPopupToQueue(this.openRaidLevelCompletedPopup);
            }
         }
      }
      
      private function getDungeonLevelFailedPopup() : PopupDungeonLevelFailed
      {
         var _loc1_:PopupDungeonLevelFailed = null;
         var _loc2_:PopupDungeonLevelFailed = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(DUNGEON_LEVEL_FAILED_POPUP_NAME,PopupDungeonLevelFailed) as PopupDungeonLevelFailed;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      private function getRaidLevelFailedPopup() : PopupRaidLevelFailed
      {
         var _loc1_:PopupRaidLevelFailed = null;
         var _loc2_:PopupRaidLevelFailed = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(RAID_LEVEL_FAILED_POPUP_NAME,PopupRaidLevelFailed) as PopupRaidLevelFailed;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openDungeonLevelFailedPopup() : void
      {
         var _loc1_:PopupDungeonLevelFailed = null;
         if(InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            _loc1_ = this.getDungeonLevelFailedPopup();
            if(_loc1_ != null)
            {
               _loc1_.openPopup();
            }
            else
            {
               this.addPopupToQueue(this.openDungeonLevelFailedPopup);
            }
         }
      }
      
      public function openRaidLevelFailedPopup() : void
      {
         var _loc1_:PopupRaidLevelFailed = null;
         if(InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            _loc1_ = this.getRaidLevelFailedPopup();
            if(_loc1_ != null)
            {
               _loc1_.openPopup();
            }
            else
            {
               this.addPopupToQueue(this.openRaidLevelFailedPopup);
            }
         }
      }
      
      private function getConfirmLeaveDungeonScreenPopup() : PopupConfirmLeaveDungeonScreen
      {
         var _loc1_:PopupConfirmLeaveDungeonScreen = null;
         var _loc2_:PopupConfirmLeaveDungeonScreen = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(STANDARD_POPUP_NAME,PopupConfirmLeaveDungeonScreen) as PopupConfirmLeaveDungeonScreen;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openConfirmLeaveDungeonScreenPopup() : void
      {
         var _loc1_:PopupConfirmLeaveDungeonScreen = this.getConfirmLeaveDungeonScreenPopup();
         if(_loc1_ != null)
         {
            _loc1_.setMainFieldText(TextManager.getText("TID_DUNGEON_EXIT_WARNING"));
            _loc1_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openConfirmLeaveDungeonScreenPopup);
         }
      }
      
      private function getConfirmationPopup() : PopupConfirmation
      {
         var _loc1_:PopupConfirmation = null;
         var _loc2_:PopupConfirmation = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(STANDARD_POPUP_NAME,PopupConfirmation) as PopupConfirmation;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openConfirmationPopup(param1:String, param2:Function = null, param3:Function = null, param4:Boolean = false, param5:String = "", param6:uint = 16777215) : void
      {
         var _loc7_:PopupConfirmation = this.getConfirmationPopup();
         if(_loc7_ != null)
         {
            _loc7_.setMainFieldText(param1);
            _loc7_.setAcceptFunction(param2);
            _loc7_.setCancelFunction(param3);
            _loc7_.setup(param4,param5,param6);
            _loc7_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openConfirmationPopup,[param1,param2,param3,param4,param5,param6]);
         }
      }
      
      public function getPopupShown() : Popup
      {
         return this.mPopupShown;
      }
      
      public function setPopupShown(param1:Popup) : void
      {
         this.mPopupShown = param1;
      }
      
      public function updatePopupInBackground() : void
      {
         this.mPopupOnBackground = this.mPopupShown;
      }
      
      public function getPopupInBackground() : Popup
      {
         return this.mPopupOnBackground;
      }
      
      public function setPopupInBackground(param1:Popup) : void
      {
         this.mPopupOnBackground = param1;
      }
      
      public function resumePopupInBackground() : void
      {
         if(this.mPopupOnBackground)
         {
            this.mPopupOnBackground.openPopup();
         }
      }
      
      public function cleanPopupInBackground() : void
      {
         if(this.mPopupOnBackground)
         {
            this.mPopupOnBackground.closePopup();
            this.mPopupOnBackground = null;
         }
      }
      
      public function closePopupShown() : void
      {
         if(this.mPopupShown != null)
         {
            this.mPopupShown.closePopup();
         }
      }
      
      public function addPopupToQueue(param1:Function, param2:Array = null) : void
      {
         var _loc3_:Object = null;
         if(this.isFunctionEligibleToQueue(param1))
         {
            if(this.mPopupsQueue == null)
            {
               this.mPopupsQueue = new Vector.<Object>();
            }
            _loc3_ = new Object();
            _loc3_.functionToCall = param1;
            _loc3_.params = param2;
            FSDebug.debugTrace("adding popup into queue");
            this.mPopupsQueue.push(_loc3_);
         }
      }
      
      private function isFunctionEligibleToQueue(param1:Function) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:Function = null;
         var _loc2_:Boolean = true;
         if(Boolean(this.mPopupsQueue) && this.mPopupsQueue.length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < this.mPopupsQueue.length)
            {
               if(this.mPopupsQueue[_loc3_] != null)
               {
                  if(this.mPopupsQueue[_loc3_].functionToCall == param1)
                  {
                     return false;
                  }
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      public function showFirstQueuedPopup() : void
      {
         var _loc1_:Screen = null;
         var _loc2_:Boolean = false;
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         if(Boolean(this.mPopupsQueue) && Boolean(!Root.assets.isLoading) && !this.mPopupShown)
         {
            _loc1_ = InstanceMng.getCurrentScreen();
            _loc2_ = !(_loc1_ is FSMapScreen) || _loc1_ is FSMapScreen && !FSMapScreen(_loc1_).isShowingComic();
            if(_loc1_ != null && _loc2_)
            {
               FSDebug.debugTrace("Clear to open a new popup");
               _loc3_ = this.mPopupsQueue.pop();
               if(_loc3_ != null)
               {
                  FSDebug.debugTrace("There are somethings to be checked");
                  _loc4_ = _loc3_.params;
                  TweenMax.delayedCall(0,_loc3_.functionToCall,_loc3_.params);
               }
               else
               {
                  clearInterval(this.mQueuedPopupTimerId);
                  this.mQueuedPopupTimerId = 0;
               }
            }
            else
            {
               clearInterval(this.mQueuedPopupTimerId);
               this.mQueuedPopupTimerId = 0;
            }
         }
         else
         {
            clearInterval(this.mQueuedPopupTimerId);
            this.mQueuedPopupTimerId = 0;
         }
         if(!this.mPopupLoading)
         {
            this.setPopupIsLoading(false);
         }
      }
      
      public function isPopupLoading() : Boolean
      {
         return this.mPopupLoading;
      }
      
      public function setPopupIsLoading(param1:Boolean) : void
      {
         this.mPopupLoading = param1;
      }
      
      public function openQuestPopup() : void
      {
         var _loc1_:PopupQuest = this.getQuestPopup();
         if(_loc1_ != null)
         {
            _loc1_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openQuestPopup);
         }
      }
      
      public function openDungeonRewardsInfoPopup() : void
      {
         var _loc1_:PopupDungeonRewardsInfo = this.getDungeonRewardsInfoPopup();
         if(_loc1_ != null)
         {
            _loc1_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openDungeonRewardsInfoPopup);
         }
      }
      
      public function openPvPSeasonRewardPopup() : void
      {
         var _loc1_:PopupPvPRewardsInfo = this.getPvPSeasonRewardPopup();
         if(_loc1_ != null)
         {
            _loc1_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openPvPSeasonRewardPopup);
         }
      }
      
      public function getQuestPopup() : PopupQuest
      {
         var _loc1_:PopupQuest = null;
         var _loc2_:PopupQuest = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(QUEST_POPUP_NAME,PopupQuest) as PopupQuest;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function getPvPSeasonRewardPopup() : PopupPvPRewardsInfo
      {
         var _loc1_:PopupPvPRewardsInfo = null;
         var _loc2_:PopupPvPRewardsInfo = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(PVP_SEASON_REWARD_POPUP_NAME,PopupPvPRewardsInfo) as PopupPvPRewardsInfo;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function getDungeonRewardsInfoPopup() : PopupDungeonRewardsInfo
      {
         var _loc1_:PopupDungeonRewardsInfo = null;
         var _loc2_:PopupDungeonRewardsInfo = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(DUNGEON_REWARD_POPUP_NAME,PopupDungeonRewardsInfo) as PopupDungeonRewardsInfo;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      private function getRewardsPopup() : PopupRewards
      {
         var _loc1_:PopupRewards = null;
         var _loc2_:PopupRewards = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(REWARDS_POPUP_NAME,PopupRewards) as PopupRewards;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openRewardsPopup() : void
      {
         var _loc1_:PopupRewards = this.getRewardsPopup();
         if(_loc1_ != null)
         {
            _loc1_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openRewardsPopup);
         }
      }
      
      private function getReleaseNotesPopup() : PopupReleaseNotes
      {
         var _loc1_:PopupReleaseNotes = null;
         var _loc2_:PopupReleaseNotes = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(RELEASE_NOTES_POPUP_NAME,PopupReleaseNotes) as PopupReleaseNotes;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openReleaseNotesPopup(param1:String, param2:Boolean = true) : void
      {
         var _loc3_:PopupReleaseNotes = this.getReleaseNotesPopup();
         if(_loc3_ != null)
         {
            param1 += param2 ? "\n\n\nInfo: Remember that you can check out the Patch Notes anytime by finding them in the Settings Popup" : "";
            _loc3_.setup(param1);
            _loc3_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openReleaseNotesPopup,[param1,param2]);
         }
      }
      
      private function getXPromoPopup() : PopupXPromo
      {
         var _loc1_:PopupXPromo = null;
         var _loc2_:PopupXPromo = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(X_PROMO_POPUP_NAME,PopupXPromo) as PopupXPromo;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openXPromoPopup() : void
      {
         var _loc1_:PopupXPromo = this.getXPromoPopup();
         if(_loc1_ != null)
         {
            _loc1_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openXPromoPopup);
         }
      }
      
      private function getReferralPopup() : PopupReferral
      {
         var _loc1_:PopupReferral = null;
         var _loc2_:PopupReferral = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(REFERRAL_POPUP_NAME,PopupReferral) as PopupReferral;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openReferralPopup() : void
      {
         var _loc1_:PopupReferral = this.getReferralPopup();
         if(_loc1_ != null)
         {
            _loc1_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openReferralPopup);
         }
      }
      
      private function getRedeemReferralPopup() : PopupRedeemReferralCode
      {
         var _loc1_:PopupRedeemReferralCode = null;
         var _loc2_:PopupRedeemReferralCode = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(REDEEM_REFERRAL_CODE_POPUP_NAME,PopupRedeemReferralCode) as PopupRedeemReferralCode;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openRedeemReferralCodePopup() : void
      {
         var _loc1_:PopupRedeemReferralCode = this.getRedeemReferralPopup();
         if(_loc1_ != null)
         {
            _loc1_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openRedeemReferralCodePopup);
         }
      }
      
      private function getProductDetailPopup() : PopupProductDetail
      {
         var _loc1_:PopupProductDetail = null;
         var _loc2_:PopupProductDetail = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(PRODUCT_DETAIL_POPUP_NAME,PopupProductDetail) as PopupProductDetail;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openProductDetailPopup(param1:int, param2:String, param3:int, param4:String) : void
      {
         var _loc5_:PopupProductDetail = this.getProductDetailPopup();
         if(_loc5_ != null)
         {
            _loc5_.setupProduct(param1,param2,param3,param4);
            _loc5_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openProductDetailPopup,[param1,param2,param3,param4]);
         }
      }
      
      private function getMapSelectorPopup() : PopupMapSelector
      {
         var _loc1_:PopupMapSelector = null;
         var _loc2_:PopupMapSelector = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(MAP_SELECTOR_POPUP_NAME,PopupMapSelector) as PopupMapSelector;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openMapSelectorPopup() : void
      {
         var _loc1_:PopupMapSelector = this.getMapSelectorPopup();
         if(_loc1_ != null)
         {
            _loc1_.setMainFieldText(TextManager.getText("TID_GEN_MAP_CHOOSE",true));
            _loc1_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openMapSelectorPopup);
         }
      }
      
      private function getRedeemTransferCodePopup() : PopupRedeemTransferCode
      {
         var _loc1_:PopupRedeemTransferCode = null;
         var _loc2_:PopupRedeemTransferCode = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(REDEEM_TRANSFER_CODE_POPUP_NAME,PopupRedeemTransferCode) as PopupRedeemTransferCode;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openRedeemTransferCodePopup() : void
      {
         var _loc1_:PopupRedeemTransferCode = this.getRedeemTransferCodePopup();
         if(_loc1_ != null)
         {
            _loc1_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openRedeemTransferCodePopup);
         }
      }
      
      private function getGetTransferCodePopup() : PopupGetTransferCode
      {
         var _loc1_:PopupGetTransferCode = null;
         var _loc2_:PopupGetTransferCode = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(GET_TRANSFER_CODE_POPUP_NAME,PopupGetTransferCode) as PopupGetTransferCode;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openGetTansferCodePopup() : void
      {
         var _loc1_:PopupGetTransferCode = this.getGetTransferCodePopup();
         if(_loc1_ != null)
         {
            _loc1_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openGetTansferCodePopup);
         }
      }
      
      private function getGetImageAndTextPopup() : PopupImageAndText
      {
         var _loc1_:PopupImageAndText = null;
         var _loc2_:PopupImageAndText = null;
         if(this.mPopupsCatalog != null)
         {
            _loc2_ = this.getPopup(IMAGE_AND_TEXT_POPUP_NAME,PopupImageAndText) as PopupImageAndText;
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function openGetImageAndTextPopup(param1:String, param2:String) : void
      {
         var _loc3_:PopupImageAndText = this.getGetImageAndTextPopup();
         if(_loc3_ != null)
         {
            _loc3_.setup(param1,param2);
            _loc3_.openPopup();
         }
         else
         {
            this.addPopupToQueue(this.openGetImageAndTextPopup,[param1,param2]);
         }
      }
   }
}

