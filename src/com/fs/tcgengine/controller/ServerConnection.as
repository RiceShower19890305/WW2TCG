package com.fs.tcgengine.controller
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.model.auctions.Auction;
   import com.fs.tcgengine.model.battle.BattleEnginePvP;
   import com.fs.tcgengine.model.guilds.Guild;
   import com.fs.tcgengine.model.rules.BundleDef;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.GoldDef;
   import com.fs.tcgengine.model.rules.PvPBotDeckDef;
   import com.fs.tcgengine.model.rules.RankDef;
   import com.fs.tcgengine.model.rules.RarityDef;
   import com.fs.tcgengine.model.userdata.UserBattleInfo;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.screens.FSAuctionsScreen;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.screens.FSDeckBuilderScreen;
   import com.fs.tcgengine.screens.FSMapScreen;
   import com.fs.tcgengine.screens.FSMenuScreen;
   import com.fs.tcgengine.screens.FSRaidsScreen;
   import com.fs.tcgengine.screens.FSShopScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.TimerUtil;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.misc.FSAuctionTicketsVisor;
   import com.fs.tcgengine.view.components.misc.FSCurrencyVisor;
   import com.fs.tcgengine.view.components.misc.FSGoldVisor;
   import com.fs.tcgengine.view.components.popups.misc.NotificationMessage;
   import com.fs.tcgengine.view.components.shop.FSShopItem;
   import com.fs.tcgengine.view.popups.Popup;
   import com.fs.tcgengine.view.popups.levels.FSPopupPlayLevel;
   import com.fs.tcgengine.view.popups.misc.PopupError;
   import com.fs.tcgengine.view.popups.quests.PopupBattlePass;
   import com.fs.tcgengine.view.popups.quests.PopupQuest;
   import com.gamesparks.GS;
   import com.gamesparks.api.messages.ScriptMessage;
   import com.gamesparks.api.messages.SessionTerminatedMessage;
   import com.gamesparks.api.messages.TeamChatMessage;
   import com.gamesparks.api.requests.AccountDetailsRequest;
   import com.gamesparks.api.requests.AppleConnectRequest;
   import com.gamesparks.api.requests.ChangeUserDetailsRequest;
   import com.gamesparks.api.requests.ConsumeVirtualGoodRequest;
   import com.gamesparks.api.requests.CreateTeamRequest;
   import com.gamesparks.api.requests.DeviceAuthenticationRequest;
   import com.gamesparks.api.requests.FacebookConnectRequest;
   import com.gamesparks.api.requests.GetLeaderboardEntriesRequest;
   import com.gamesparks.api.requests.GetTeamRequest;
   import com.gamesparks.api.requests.GooglePlayBuyGoodsRequest;
   import com.gamesparks.api.requests.IOSBuyGoodsRequest;
   import com.gamesparks.api.requests.JoinTeamRequest;
   import com.gamesparks.api.requests.KongregateConnectRequest;
   import com.gamesparks.api.requests.LeaderboardDataRequest;
   import com.gamesparks.api.requests.ListGameFriendsRequest;
   import com.gamesparks.api.requests.ListTeamChatRequest;
   import com.gamesparks.api.requests.ListVirtualGoodsRequest;
   import com.gamesparks.api.requests.LogEventRequest;
   import com.gamesparks.api.requests.PushRegistrationRequest;
   import com.gamesparks.api.requests.SendTeamChatMessageRequest;
   import com.gamesparks.api.requests.SocialLeaderboardDataRequest;
   import com.gamesparks.api.requests.SteamBuyGoodsRequest;
   import com.gamesparks.api.requests.SteamConnectRequest;
   import com.gamesparks.api.responses.AccountDetailsResponse;
   import com.gamesparks.api.responses.AuthenticationResponse;
   import com.gamesparks.api.responses.BuyVirtualGoodResponse;
   import com.gamesparks.api.responses.ChangeUserDetailsResponse;
   import com.gamesparks.api.responses.ConsumeVirtualGoodResponse;
   import com.gamesparks.api.responses.CreateTeamResponse;
   import com.gamesparks.api.responses.GetLeaderboardEntriesResponse;
   import com.gamesparks.api.responses.GetTeamResponse;
   import com.gamesparks.api.responses.JoinTeamResponse;
   import com.gamesparks.api.responses.LeaderboardDataResponse;
   import com.gamesparks.api.responses.ListGameFriendsResponse;
   import com.gamesparks.api.responses.ListTeamChatResponse;
   import com.gamesparks.api.responses.ListVirtualGoodsResponse;
   import com.gamesparks.api.responses.LogEventResponse;
   import com.gamesparks.api.responses.PushRegistrationResponse;
   import com.gamesparks.api.responses.SendTeamChatMessageResponse;
   import com.gamesparks.api.types.Boughtitem;
   import com.gamesparks.api.types.Player;
   import com.gamesparks.api.types.VirtualGood;
   import com.greensock.TweenMax;
   import flash.events.TimerEvent;
   import flash.system.Capabilities;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import mx.utils.ObjectUtil;
   import starling.utils.Align;
   import starling.utils.SystemUtil;
   
   public class ServerConnection
   {
      
      public static var smGameSparks:GS;
      
      public static var smGameSparksConnected:Boolean;
      
      private static var smPlayerLoggedIn:Boolean;
      
      private static var smPlayerDeviceLoginKey:String;
      
      public static var smPlayerCreationDate:Number;
      
      public static var smServerUserObject:Object;
      
      public static var smServerDate:Date;
      
      public static var smServerTimeTimer:Timer;
      
      public static var smServerPlayerBlacklisted:Boolean;
      
      public static var smServerPlayerDuplicated:Boolean;
      
      public static var smServerPlayerReferrals:Array;
      
      public static var smServerReferralsDefs:Dictionary;
      
      public static var smServerRaidsMPRewardsDefs:Dictionary;
      
      public static var smServerRaidsSPRewardsDefs:Dictionary;
      
      public static const PLAYER_SCORE_PVP_EV:String = "PLAYER_SCORE_PVP_EV";
      
      public static const PLAYER_SCORE_PVE_EV:String = "PLAYER_SCORE_PVE_EV";
      
      public static const PLAYER_SCORE_DUNGEONS_EV:String = "PLAYER_SCORE_DUNGEONS_EV";
      
      public static const GUILD_SCORE_PVP_EV:String = "GUILD_SCORE_PVP_EV";
      
      public static const GUILD_SCORE_RAID_EV:String = "GUILD_SCORE_RAID_EV";
      
      public static const GUILD_SCORE_DUNGEON_EV:String = "GUILD_SCORE_DUNGEON_EV";
      
      public static const RAIDS_SCORE_MP_EV:String = "MP_RAIDS_SCORE_EV";
      
      public static const RAIDS_SCORE_SP_EV:String = "SP_RAIDS_SCORE_EV";
      
      public static const CURRENCY_GOLD:String = "GOLD";
      
      public static const CURRENCY_RAID_COINS:String = "RAID_COINS";
      
      public static const CURRENCY_QUEST_COINS:String = "QUEST_COINS";
      
      public static const CURRENCY_AH_TOKENS:String = "AH_TOKENS";
      
      public static const CURRENCY_RAID_TICKETS_SP:String = "RAID_TICKETS_SP";
      
      public static const CURRENCY_RAID_TICKETS_MP:String = "RAID_TICKETS_MP";
      
      public static const CURRENCY_REAL:String = "REAL";
      
      public static const CURRENCY_CRAFT_MATERIAL:String = "CRAFT_MATERIAL";
      
      private static const GS_TIMEOUT_SEC:int = 20;
      
      private static const LOGIN_SILENT:int = 0;
      
      private static const LOGIN_FB:int = 1;
      
      private static const LOGIN_APPLE:int = 2;
      
      private static const LOGIN_KONG:int = 3;
      
      private static const LOGIN_STEAM:int = 4;
      
      public static var smServerTimeMS:Number = -1;
      
      public static var smServerInfoReceived:Boolean = false;
      
      public static var smChatMutedTimestamp:Number = -1;
      
      private var mRefreshedSessionsAttemtps:int = 0;
      
      private var mLoginRequested:Boolean = false;
      
      private var mLoginResponseReceived:Boolean = false;
      
      private var mAvailabilityCallbackReceived:Boolean;
      
      private var mBrowserLoggingTimer:uint;
      
      private var mServerEventHandlersAdded:Boolean = false;
      
      private var mPlayerWasOnlineOnce:Boolean;
      
      private var mDualLoginDetected:Boolean;
      
      private var mSteamDisconnected:Boolean;
      
      private var mCheckServerInfoTimer:uint;
      
      private var mLastOnlineLoginAttempt:Number;
      
      private var mTimeoutsCount:int = 0;
      
      private var mLoginErrorsCount:int;
      
      public var mRecoveringFromAlternativeAccount:Boolean = false;
      
      private var mGuildScoresCatalog:Dictionary;
      
      private var mServerPlayerVIP:Boolean;
      
      private var mServerPlayerDev:Boolean;
      
      private var smServerIsOldPlayerComingBack:Boolean;
      
      private var mServerPlayerPurchasesAmount:int;
      
      private var mServerPlayerReferralCode:String;
      
      public var mServerPlayerTransferCode:String;
      
      public var mFirstMusicAlreadyPlayed:Boolean = false;
      
      private var mLoginSystem:int = -1;
      
      private var mLastFullProfileSaved:Object = null;
      
      public function ServerConnection()
      {
         super();
         this.initializeBackEnd();
      }
      
      public function initializeBackEnd() : void
      {
         this.mTimeoutsCount = 0;
         this.mSteamDisconnected = false;
         if(smServerPlayerBlacklisted || smServerPlayerDuplicated)
         {
            return;
         }
         smPlayerLoggedIn = false;
         this.mServerEventHandlersAdded = false;
         FSDebug.debugTrace("Initializing Gamesparks");
         smGameSparks = new GS();
         GS.ignoreSecureSocket = true;
         var _loc1_:Boolean = Config.ENVIRONMENT_ACTIVE == Config.ENVIRONMENT_PROD;
         setTimeout(this.notifyCheckingConnection,1500);
         setTimeout(this.checkIfResponseReceived,15000);
         var _loc2_:Function = Config.ONLY_SERVER_TRACES ? trace : FSDebug.debugTrace;
         smGameSparks.setAvailabilityCallback(this.availabilityCallback).setLogger(_loc2_).setUseLiveServices(_loc1_).setApiSecret(InstanceMng.getApplication().getSecretKey()).setApiKey(InstanceMng.getApplication().getApiKey(Config.PRODUCTION_BUILD)).connect();
         smGameSparksConnected = true;
      }
      
      private function notifyCheckingConnection() : void
      {
         if(!this.isUserLoggedIn() && !this.mAvailabilityCallbackReceived)
         {
            Utils.setLogText(TextManager.getText("TID_GEN_CHECKING_CONNECTION"),false,true,false);
         }
      }
      
      private function checkIfResponseReceived() : void
      {
         if(!this.mAvailabilityCallbackReceived)
         {
            this.onConnectionKO();
            if(Utils.isMobile())
            {
               Utils.setLogText(TextManager.getText("TID_PLAYING_OFFLINE"),false,false,false);
            }
         }
      }
      
      private function availabilityCallback(param1:Boolean) : void
      {
         if(smServerPlayerBlacklisted || smServerPlayerDuplicated)
         {
            return;
         }
         FSDebug.debugTrace("[GS] - availabilityCallback, isAvailable: " + param1);
         this.mAvailabilityCallbackReceived = true;
         if(param1)
         {
            this.onConnectionOK();
         }
         else
         {
            this.onConnectionKO();
         }
      }
      
      public function addBackendEventHandlers() : void
      {
         if(this.isUserLoggedIn())
         {
            if(!this.mServerEventHandlersAdded)
            {
               smGameSparks.getMessageHandler().setHandler(".TeamChatMessage",this.handleReceivedMessages);
               smGameSparks.getMessageHandler().setHandler(".ScriptMessage",this.handleScriptMessages);
               smGameSparks.getMessageHandler().setSessionTerminatedMessageHandler(this.handleSessionTerminated);
               this.mServerEventHandlersAdded = true;
            }
         }
         else
         {
            setTimeout(this.addBackendEventHandlers,5000);
         }
      }
      
      public function areServerEventHandlersAdded() : Boolean
      {
         return this.mServerEventHandlersAdded;
      }
      
      public function handleSessionTerminated(param1:SessionTerminatedMessage, param2:String = "", param3:Boolean = true) : void
      {
         this.mDualLoginDetected = param3 == true ? param3 : this.mDualLoginDetected;
         this.onConnectionKO();
         if(Boolean(InstanceMng.getApplication()) && InstanceMng.getApplication().isGuildsPanelOpen())
         {
            InstanceMng.getApplication().hideGuildsPanel(0);
         }
         this.handlePopupsOnDisconnectionEvent();
      }
      
      public function handlePopupsOnDisconnectionEvent(param1:String = "") : void
      {
         var _loc2_:Popup = null;
         if(Config.allowKeepPlayingAfterDisconnection())
         {
            _loc2_ = InstanceMng.getPopupMng().getPopupShown();
            if(_loc2_ != null)
            {
               if(_loc2_ is FSPopupPlayLevel)
               {
                  FSPopupPlayLevel(_loc2_).hideCarrousels(false);
               }
               _loc2_.hideTemporarily(InstanceMng.getPopupMng().openErrorPopup,[param1 + " " + TextManager.getText("TID_CONNECTION_LOST"),true,true]);
            }
            else
            {
               InstanceMng.getPopupMng().openErrorPopup(param1 + " " + TextManager.getText("TID_CONNECTION_LOST"),true,true);
            }
         }
         else if(smPlayerLoggedIn)
         {
            InstanceMng.getPopupMng().closePopupShown();
            InstanceMng.getPopupMng().openErrorPopup(param1 + " " + TextManager.getText("TID_CONNECTION_LOST"),true,true);
         }
      }
      
      public function getChatMutedTimeLeft() : String
      {
         var _loc1_:Number = NaN;
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         if(smChatMutedTimestamp > smServerTimeMS)
         {
            _loc1_ = smChatMutedTimestamp - smServerTimeMS;
            _loc2_ = TimerUtil.msToDays(_loc1_) > 0;
            _loc3_ = TimerUtil.msToHour(_loc1_) > 0;
            _loc4_ = _loc2_ ? TextManager.getText("TID_GEN_TIME_DAYS_ABR",true) + " " : null;
            _loc5_ = _loc3_ ? TextManager.getText("TID_GEN_TIME_HOURS_ABR",true) + " " : null;
            _loc6_ = TextManager.getText("TID_GEN_TIME_MINUTES_ABR",true) + " ";
            _loc7_ = TextManager.getText("TID_GEN_TIME_SECONDS_ABR",true) + " ";
            return TimerUtil.getTimeTextFromMs(_loc1_,_loc4_,_loc5_,_loc6_,_loc7_);
         }
         return "";
      }
      
      private function handleScriptMessages(param1:ScriptMessage) : void
      {
         var _loc5_:Boolean = false;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:Boolean = false;
         var _loc9_:UserBattleInfo = null;
         var _loc10_:Object = null;
         var _loc11_:String = null;
         var _loc12_:int = 0;
         var _loc13_:String = null;
         var _loc14_:Boolean = false;
         var _loc15_:Boolean = false;
         var _loc16_:Boolean = false;
         var _loc17_:int = 0;
         var _loc18_:String = null;
         var _loc19_:Object = null;
         var _loc20_:Guild = null;
         var _loc21_:Auction = null;
         var _loc22_:Object = null;
         var _loc23_:String = null;
         var _loc2_:String = param1.getExtCode();
         var _loc3_:Array = new Array();
         var _loc4_:Object = param1.getData();
         switch(_loc2_)
         {
            case "LOG_PANEL_EV":
               if(_loc4_ != null)
               {
                  _loc5_ = _loc4_.hasTID == true;
                  _loc6_ = _loc4_.msg;
                  if(_loc5_)
                  {
                     Utils.setLogText(TextManager.getText(_loc6_));
                  }
                  else
                  {
                     Utils.setLogText(_loc6_);
                  }
               }
               else
               {
                  FSDebug.debugTrace("Script Message: " + _loc6_);
               }
               break;
            case "BATTLE_EMOTE":
               if(_loc4_ != null)
               {
                  _loc7_ = int(_loc4_["chatIndex"]);
                  if(InstanceMng.getBattleEngine())
                  {
                     _loc8_ = Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) ? InstanceMng.getUserDataMng().getOwnerUserData().flagsChatOn() : false;
                     if(_loc8_)
                     {
                        _loc9_ = InstanceMng.getBattleEngine().getOpponentBattleInfo();
                        if((Boolean(_loc9_)) && Boolean(_loc9_.getUserBattlePortrait()))
                        {
                           _loc9_.getUserBattlePortrait().showMessageBubble(_loc7_);
                        }
                     }
                  }
               }
               else
               {
                  FSDebug.debugTrace("Script Message: " + _loc6_);
               }
               break;
            case "CHAT_BAN":
               if(_loc4_ != null)
               {
                  smChatMutedTimestamp = _loc4_["chatMutedTimestamp"];
                  if(smChatMutedTimestamp > smServerTimeMS)
                  {
                     Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_CHAT_MUTE_BAN"),[this.getChatMutedTimeLeft()]));
                  }
               }
               break;
            case "GENERAL_CHAT_EVENT":
               if(Boolean(InstanceMng.getApplication().getGuildsPanel()) && _loc4_ != null)
               {
                  _loc10_ = _loc4_;
                  _loc10_._id = new Object();
                  _loc10_._id.$oid = param1.getMessageId();
                  _loc3_.push(_loc10_);
                  InstanceMng.getApplication().getGuildsPanel().onGeneralChatsReceived(_loc3_);
               }
               break;
            case "GUILD_EVENT":
               if(_loc4_ != null)
               {
                  _loc11_ = _loc4_.playerInvolvedId;
                  _loc12_ = int(_loc4_.eventType);
                  _loc13_ = Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) ? InstanceMng.getUserDataMng().getOwnerUserData().getAccountId() : "";
                  _loc14_ = _loc11_ != "" && _loc11_ != null && _loc11_ == _loc13_;
                  _loc15_ = _loc11_ != "" && _loc11_ != null && _loc14_;
                  _loc16_ = true;
                  _loc17_ = _loc4_.hasOwnProperty("playerInvolvedGuildRank") ? int(_loc4_.playerInvolvedGuildRank) : GuildsMng.RANK_MEMBER;
                  _loc18_ = Boolean(_loc4_ && _loc4_.hasOwnProperty("data")) && Boolean(_loc4_.data != null) && Boolean(_loc4_.data.hasOwnProperty("motd")) ? _loc4_.data.motd : null;
                  if(_loc15_)
                  {
                     switch(_loc12_)
                     {
                        case GuildsMng.GUILD_EVENT_KICK:
                           InstanceMng.getGuildsMng().onOwnerKickedFromGuild();
                           _loc16_ = false;
                           break;
                        case GuildsMng.GUILD_EVENT_JOIN:
                           InstanceMng.getGuildsMng().onJoinRequestAccepted(_loc4_.guildId,_loc4_.data,_loc17_,_loc18_);
                           break;
                        case GuildsMng.GUILD_EVENT_PROMOTE:
                        case GuildsMng.GUILD_EVENT_DEMOTE:
                           InstanceMng.getGuildsMng().onOwnerRankModified(_loc4_.playerInvolvedGuildRank,_loc4_.data);
                     }
                  }
                  else if(_loc12_ == GuildsMng.GUILD_EVENT_KICK || _loc12_ == GuildsMng.GUILD_EVENT_JOIN || _loc12_ == GuildsMng.GUILD_EVENT_PROMOTE || _loc12_ == GuildsMng.GUILD_EVENT_DEMOTE)
                  {
                     InstanceMng.getGuildsMng().refreshMyGuild();
                  }
                  if(_loc16_ && Boolean(InstanceMng.getApplication().getGuildsPanel()))
                  {
                     _loc3_.push(_loc4_);
                     InstanceMng.getApplication().getGuildsPanel().onGuildEventsReceived(_loc3_);
                  }
               }
               break;
            case "GUILD_MOTD_CHANGED":
               if(_loc4_ != null)
               {
                  _loc19_ = this.createMessageOfTheDay(_loc4_.motd);
                  if((Boolean(_loc19_)) && Boolean(InstanceMng.getApplication().getGuildsPanel()))
                  {
                     _loc20_ = InstanceMng.getGuildsMng().getMyGuild();
                     if(_loc20_)
                     {
                        Utils.setLogText(TextManager.getText("TID_GUILD_MOTD_CHANGED"));
                     }
                     InstanceMng.getApplication().getGuildsPanel().onGuildChatsReceived([_loc19_]);
                     _loc16_ = false;
                  }
               }
               break;
            case "BOSS_HIT":
               if(Boolean(InstanceMng.getRaidsMng()) && _loc4_ != null)
               {
                  _loc3_.push(_loc4_);
                  InstanceMng.getRaidsMng().onBattleInfoReceivedUpdateBossHP(_loc3_[0]);
               }
               break;
            case "AH_EVENT":
               if(InstanceMng.getAuctionsMng())
               {
                  if(InstanceMng.getCurrentScreen() is FSAuctionsScreen)
                  {
                     if(_loc4_)
                     {
                        if(_loc4_.isBidInfo)
                        {
                           _loc21_ = FSAuctionsScreen(InstanceMng.getCurrentScreen()).getSelectedAuction();
                           if(_loc21_)
                           {
                              _loc22_ = _loc4_.auctionInfo;
                              _loc23_ = Utils.getDataId(_loc22_);
                              if(_loc21_.getAuctionId() == _loc23_)
                              {
                                 _loc21_.processNewBid(_loc4_);
                              }
                           }
                        }
                        else if(_loc4_.isAuctionInfo)
                        {
                           smServerTimeMS = _loc4_.hasOwnProperty("serverTime") ? Number(_loc4_["serverTime"]) : smServerTimeMS;
                           if(InstanceMng.getAuctionsMng())
                           {
                              InstanceMng.getAuctionsMng().onAuctionInfoEventReceived(_loc4_);
                           }
                        }
                     }
                  }
               }
               break;
            case "PVP_EVENT":
               PvPConnectionMng.handlePvPEvent(_loc4_);
               break;
            case "FRIEND_LEVEL":
               this.handleFriendLevelEvent(param1);
               break;
            case "SYSTEM_DAILY":
               this.handleSystemDaily();
               if(_loc4_ != null)
               {
                  if(_loc4_.hasOwnProperty("isWeekly") && _loc4_["isWeekly"] == true)
                  {
                     this.handleSystemWeekly();
                  }
                  if(_loc4_.hasOwnProperty("isMonthly") && _loc4_["isMonthly"] == true)
                  {
                     this.handleSystemMonthly();
                  }
               }
               break;
            case "FORCE_SEND_COMBAT_LOG":
               PvPConnectionMng.trackCombatLog(true);
               break;
            case "GS_DISCONNECTION":
               FSDebug.debugTrace("GS Remote disconnection received");
         }
      }
      
      private function handleSystemWeekly() : void
      {
         this.resetTimedQuests("weekly");
      }
      
      private function handleSystemMonthly() : void
      {
         this.resetBattlePassQuests();
         if(InstanceMng.getPopupMng().getPopupShown() is PopupBattlePass)
         {
            PopupBattlePass(InstanceMng.getPopupMng().getPopupShown()).refreshQuestsSection(true);
         }
      }
      
      private function resetTimedQuests(param1:String) : void
      {
         if(InstanceMng.getQuestsMng())
         {
            InstanceMng.getQuestsMng().resetTimedQuests(param1);
         }
         else
         {
            setTimeout(this.resetTimedQuests,5000,param1);
         }
      }
      
      private function resetBattlePassQuests() : void
      {
         if(InstanceMng.getQuestsMng())
         {
            InstanceMng.getQuestsMng().resetBattlePassQuests();
         }
         else
         {
            setTimeout(this.resetBattlePassQuests,5000);
         }
      }
      
      private function handleSystemDaily() : void
      {
         var isRaid:Boolean;
         var isInBattleScreen:Boolean;
         var refreshDelay:int;
         var suffix:String;
         var text:String;
         var isInRaidsScreen:Boolean = false;
         var refreshRaidsScreen:Function = null;
         var goToRaidsScreen:Function = null;
         refreshRaidsScreen = function():void
         {
            var _loc1_:Popup = null;
            if(isInRaidsScreen && InstanceMng.getCurrentScreen().isFullyLoaded())
            {
               _loc1_ = InstanceMng.getPopupMng().getPopupShown();
               if(_loc1_)
               {
                  _loc1_.closePopup(goToRaidsScreen);
               }
               else
               {
                  goToRaidsScreen();
               }
            }
         };
         goToRaidsScreen = function():void
         {
            InstanceMng.getCurrentScreen().dispatchEventWith(Screen.GO_TO_RAIDS,true);
         };
         FSDebug.debugTrace("Handling daily message...");
         this.resetTimedQuests("daily");
         this.getServerConfig();
         isRaid = Root.smBattleData ? Boolean(Root.smBattleData.isRaid) : false;
         isInRaidsScreen = InstanceMng.getCurrentScreen() is FSRaidsScreen;
         isInBattleScreen = InstanceMng.getCurrentScreen() is FSBattleScreen;
         refreshDelay = 3;
         suffix = isInRaidsScreen ? TextManager.replaceParameters(TextManager.getText("TID_GEN_REFRESH_TIMER"),[refreshDelay]) : "";
         text = TextManager.getText("TID_RAID_RESET_COMPLETED") + suffix;
         if(isInRaidsScreen || isInBattleScreen && isRaid)
         {
            Utils.setLogText(text,false,false,false);
         }
         if(isInRaidsScreen)
         {
            TweenMax.delayedCall(refreshDelay,refreshRaidsScreen);
         }
         if(InstanceMng.getRaidsMng())
         {
            InstanceMng.getRaidsMng().onRaidsRotationMessageReceived();
         }
      }
      
      public function handleBattlePassValidation() : void
      {
         var _loc1_:UserData = null;
         var _loc2_:Boolean = false;
         if(InstanceMng.getPopupMng().getPopupShown() is PopupBattlePass)
         {
            _loc1_ = Utils.getOwnerUserData();
            _loc2_ = _loc1_ ? _loc1_.hasValidBattlePass() : false;
            if(!_loc2_)
            {
               PopupBattlePass(InstanceMng.getPopupMng().getPopupShown()).onBattlePassInvalidated();
            }
         }
      }
      
      public function manageDailyKeyReceived() : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc1_:UserData = Utils.getOwnerUserData();
         if(_loc1_)
         {
            _loc2_ = false;
            _loc3_ = _loc1_.getDailyKeyTime();
            if(_loc3_ < Config.smDayKey.value && Config.smDayKey.value != -1)
            {
               _loc2_ = true;
               _loc1_.resetDailyQuestsProgress(false,true);
               if(Boolean(InstanceMng.getQuestsMng()) && !InstanceMng.getQuestsMng().areQuestsInitialized())
               {
                  InstanceMng.getQuestsMng().init();
               }
               this.resetTimedQuests("daily");
               if(InstanceMng.getPopupMng().getPopupShown() != null)
               {
                  if(InstanceMng.getPopupMng().getPopupShown() is PopupQuest)
                  {
                     PopupQuest(InstanceMng.getPopupMng().getPopupShown()).onQuestsMngResetedCleanPopup();
                  }
                  else if(InstanceMng.getPopupMng().getPopupShown() is PopupBattlePass)
                  {
                     PopupBattlePass(InstanceMng.getPopupMng().getPopupShown()).refreshQuestsSection(true);
                  }
               }
               _loc1_.resetDailyRaidTickets();
               _loc1_.resetDailyBotsPlayedSession();
               _loc1_.setDailyKeyTime(Config.smDayKey.value);
               RaidsMng.smRaidScoresMP = null;
               RaidsMng.smRaidScoresSP = null;
               FSTracker.trackMiscAction(FSTracker.CATEGORY_USER,FSTracker.ACTION_DAILY_RESET);
            }
            _loc4_ = _loc1_.getWeekNumber();
            if(_loc4_ != Config.smWeekNumber.value && Config.smWeekNumber.value != -1)
            {
               _loc2_ = true;
               this.resetTimedQuests("weekly");
               _loc1_.setWeekNumber(Config.smWeekNumber.value);
            }
            _loc5_ = _loc1_.getMonthNumber();
            if(_loc5_ != -1 && _loc5_ != Config.smMonthNumber.value && Config.smMonthNumber.value != -1)
            {
               _loc2_ = true;
               this.handleSystemMonthly();
            }
            _loc1_.setMonthNumber(Config.smMonthNumber.value);
            if(_loc2_)
            {
               InstanceMng.getUserDataMng().persistenceSaveData();
            }
         }
      }
      
      private function handleFriendLevelEvent(param1:ScriptMessage) : void
      {
         var _loc2_:Object = param1.getData();
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:String = _loc2_.uid;
         var _loc4_:String = _loc2_.level;
         var _loc5_:int = int(_loc2_.difficulty);
         InstanceMng.getUserDataMng().updateFriendLevel(_loc3_,_loc4_,_loc5_);
      }
      
      private function handleReceivedMessages(param1:TeamChatMessage) : void
      {
         var _loc2_:String = param1.getTeamType();
         switch(_loc2_)
         {
            case "GENERAL_CHAT":
               if(Boolean(InstanceMng.getApplication()) && Boolean(InstanceMng.getApplication().getGuildsPanel()))
               {
                  InstanceMng.getApplication().getGuildsPanel().onGeneralChatsReceived(this.processChatMessage(param1));
               }
               break;
            case "FS_GUILD":
               if(Boolean(InstanceMng.getApplication()) && Boolean(InstanceMng.getApplication().getGuildsPanel()))
               {
                  if(param1.data.fromId != this.getUserId() && !InstanceMng.getApplication().getGuildsPanel().isOpen())
                  {
                     InstanceMng.getApplication().getGuildsPanel().increaseGuildMessagesUnread();
                  }
                  InstanceMng.getApplication().getGuildsPanel().onGuildChatsReceived(this.processChatMessage(param1));
               }
         }
      }
      
      private function processChatMessage(param1:TeamChatMessage) : Array
      {
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc2_:Object = param1.getScriptData();
         var _loc3_:Array = new Array();
         var _loc4_:Object = new Object();
         _loc4_.body = param1.getMessage();
         _loc4_._id = new Object();
         _loc4_._id.$oid = param1.getMessageId();
         _loc4_.nick = param1.getWho();
         _loc4_.uid = param1.getFromId();
         if(_loc2_ != null && _loc2_.data != null)
         {
            _loc4_.when = _loc2_.data.when;
            _loc4_.isCS = _loc2_.data.isCS;
            if(_loc2_.data.guildInfo != null)
            {
               _loc4_.guildId = _loc2_.data.guildInfo.guildId;
               _loc4_.guildEmblemBG = _loc2_.data.guildInfo.emblemBG;
               _loc4_.guildEmblemFG = _loc2_.data.guildInfo.emblemFG;
               _loc4_.guildName = _loc2_.data.guildInfo.guildName;
               _loc4_.guildMemberId = _loc2_.data.guildInfo.guildMemberId;
               _loc4_.guildRank = _loc2_.data.guildInfo.guildRank;
            }
            _loc5_ = _loc2_.data.currentLevelSku;
            _loc6_ = InstanceMng.getLevelsDefMng().getLevelIndexByLevelSku(_loc5_);
            if(_loc6_ != -1)
            {
               _loc4_.rankIndex = RankDef(InstanceMng.getRanksDefMng().getDefByCurrentLevel(_loc6_)).getIndex();
            }
         }
         _loc3_.push(_loc4_);
         return _loc3_;
      }
      
      public function retrieveLastChats(param1:String, param2:String, param3:int = 30) : void
      {
         var processedAlready:Boolean = false;
         var teamId:String = param1;
         var teamType:String = param2;
         var entryCount:int = param3;
         var req:ListTeamChatRequest = smGameSparks.getRequestBuilder().createListTeamChatRequest();
         req.setEntryCount(entryCount);
         req.setTeamId(teamId);
         req.setTeamType(teamType);
         req.setTimeoutSeconds(GS_TIMEOUT_SEC);
         req.setDurable(Config.DURABLE_CONNECTION);
         processedAlready = false;
         req.send(function onLastChatsReceived(param1:ListTeamChatResponse):void
         {
            var _loc2_:Array = null;
            var _loc3_:Array = null;
            var _loc4_:int = 0;
            var _loc5_:Object = null;
            var _loc6_:Object = null;
            var _loc7_:String = null;
            var _loc8_:int = 0;
            if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
            {
               onDuplicatedResponseReceived("lastChats");
               return;
            }
            processedAlready = true;
            if(!param1.HasErrors())
            {
               _loc2_ = param1.getAttribute("messages") as Array;
               if(param1 != null && _loc2_ != null && _loc2_.length > 0)
               {
                  _loc3_ = new Array();
                  _loc5_ = param1.getScriptData();
                  _loc4_ = 0;
                  while(_loc4_ < _loc2_.length)
                  {
                     _loc6_ = new Object();
                     _loc6_.body = _loc2_[_loc4_].message;
                     _loc6_._id = new Object();
                     _loc6_._id.$oid = _loc2_[_loc4_].id;
                     _loc6_.nick = _loc2_[_loc4_].who;
                     _loc6_.uid = _loc2_[_loc4_].fromId;
                     _loc6_.when = _loc2_[_loc4_].when;
                     _loc3_.push(_loc6_);
                     if(_loc5_ != null && _loc5_.extraInfo != null && _loc5_.extraInfo[_loc6_.uid] != null)
                     {
                        if(_loc5_.extraInfo[_loc6_.uid].guildInfo != null)
                        {
                           _loc6_.guildId = _loc5_.extraInfo[_loc6_.uid].guildInfo.guildId;
                           _loc6_.guildEmblemBG = _loc5_.extraInfo[_loc6_.uid].guildInfo.emblemBG;
                           _loc6_.guildEmblemFG = _loc5_.extraInfo[_loc6_.uid].guildInfo.emblemFG;
                           _loc6_.guildName = _loc5_.extraInfo[_loc6_.uid].guildInfo.guildName;
                           _loc6_.guildMemberId = _loc5_.extraInfo[_loc6_.uid].guildInfo.guildMemberId;
                           _loc6_.guildRank = _loc5_.extraInfo[_loc6_.uid].guildInfo.guildRank;
                        }
                        _loc7_ = _loc5_.extraInfo[_loc6_.uid].currentLevelSku;
                        _loc8_ = InstanceMng.getLevelsDefMng().getLevelIndexByLevelSku(_loc7_);
                        if(_loc8_ != -1)
                        {
                           _loc6_.rankIndex = RankDef(InstanceMng.getRanksDefMng().getDefByCurrentLevel(_loc8_)).getIndex();
                        }
                     }
                     _loc4_++;
                  }
                  if(InstanceMng.getApplication().getGuildsPanel())
                  {
                     if(teamType == "FS_GUILD")
                     {
                        InstanceMng.getApplication().getGuildsPanel().onGuildChatsReceived(_loc3_);
                     }
                     else
                     {
                        _loc3_.reverse();
                        InstanceMng.getApplication().getGuildsPanel().onGeneralChatsReceived(_loc3_);
                     }
                  }
                  createMessageOfTheDay(null,true);
               }
            }
         });
      }
      
      public function createMessageOfTheDay(param1:String = null, param2:Boolean = false) : Object
      {
         var _loc3_:Object = null;
         var _loc4_:String = "";
         var _loc5_:Guild = InstanceMng.getGuildsMng().getMyGuild();
         if(param1 != null && param1 != "")
         {
            _loc4_ = param1;
         }
         _loc4_ = Boolean(_loc4_ == "" && _loc5_) && Boolean(_loc5_.getDescription() != null) && _loc5_.getDescription() != "" ? _loc5_.getDescription() : _loc4_;
         if(_loc4_ != "")
         {
            _loc3_ = new Object();
            _loc3_.body = _loc4_;
            _loc3_._id = new Object();
            _loc3_._id.$oid = "motd_" + smServerTimeMS;
            _loc3_.nick = _loc5_ ? _loc5_.getName() : TextManager.getText("TID_GUILD_NAME_SINGLE");
            _loc3_.uid = "guild";
            _loc3_.when = smServerTimeMS;
         }
         if(param2 && Boolean(InstanceMng.getApplication().getGuildsPanel()))
         {
            InstanceMng.getApplication().getGuildsPanel().onGuildChatsReceived([_loc3_]);
            InstanceMng.getApplication().getGuildsPanel().updateGuildManageTooltipInfo(_loc4_);
         }
         return _loc3_;
      }
      
      public function createUser(param1:String) : void
      {
         FSDebug.debugTrace("CREATING USER");
         if(smServerUserObject == null)
         {
            smServerUserObject = new Object();
         }
         smServerUserObject._id = param1;
         FSTracker.trackMiscAction(FSTracker.CATEGORY_USER,FSTracker.ACTION_USER_CREATED);
         var _loc2_:Object = this.createProfileObject(false);
         smPlayerLoggedIn = true;
         this.onUserCreatedChangeName(_loc2_);
      }
      
      private function onUserCreatedChangeName(param1:Object) : void
      {
         var onNickAvailable:Function = null;
         var profile:Object = param1;
         onNickAvailable = function(param1:Object):void
         {
            updateProfileInDDBB(param1,"","",true,getMe);
            if(isUserLoggedIn())
            {
               FSTracker.trackMiscAction(FSTracker.CATEGORY_USER,FSTracker.ACTION_REQUESTING_NAME_CHANGE_APPROVED,{"newName":param1.playerName});
            }
         };
         if(this.isUserLoggedIn())
         {
            FSTracker.trackMiscAction(FSTracker.CATEGORY_USER,FSTracker.ACTION_REQUESTING_NAME_CHANGE);
         }
         this.checkIfNickAvailable(profile.playerName,onNickAvailable,[profile],this.onUserCreatedChangeNameFailed,[profile]);
      }
      
      private function onUserCreatedChangeNameFailed(param1:Object) : void
      {
         FSTracker.trackMiscAction(FSTracker.CATEGORY_USER,FSTracker.ACTION_REQUESTING_NAME_CHANGE_DECLINED,{"newName":param1.playerName});
         param1.playerName = Utils.generateRandomUserName();
         TweenMax.delayedCall(5,this.onUserCreatedChangeName,[param1]);
      }
      
      private function createUserObject(param1:Boolean = false) : *
      {
         var _loc2_:* = null;
         _loc2_ = new Object();
         _loc2_.profile = this.createProfileObject(param1);
         return _loc2_;
      }
      
      private function onUserCreationFailed() : void
      {
         if(!this.isUserLoggedIn())
         {
            if(Boolean(InstanceMng.getFacebookPlugin()) && InstanceMng.getFacebookPlugin().isSessionOpen())
            {
               FSDebug.debugTrace("[createUser] - Logout from facebook");
               InstanceMng.getFacebookPlugin().logout();
            }
            if(Boolean(InstanceMng.getApplication()) && !InstanceMng.getApplication().isBrowserVersion())
            {
               this.onLogin(false);
            }
            else if(Boolean(InstanceMng.getCurrentScreen()) && InstanceMng.getCurrentScreen() is FSMenuScreen)
            {
               Utils.setLogText(TextManager.getText("TID_GEN_SERVER_ISSUE"),true,true);
            }
         }
      }
      
      public function createProfileObject(param1:Boolean) : Object
      {
         var _loc7_:UserData = null;
         var _loc2_:UserData = Utils.getOwnerUserData();
         var _loc3_:Object = null;
         if(Utils.isMobile() && !param1)
         {
            _loc3_ = _loc2_ != null ? _loc2_.persistenceBuildData(true) : null;
         }
         else
         {
            _loc7_ = new UserData();
            _loc3_ = _loc7_.persistenceBuildData();
         }
         var _loc4_:Object = this.processProfileFromUserInfoObject(_loc3_,false,true);
         var _loc5_:String = "";
         var _loc6_:int = -1;
         if(Utils.isBrowser())
         {
            if(InstanceMng.getApplication().isFacebookBrowser())
            {
               _loc5_ = Boolean(InstanceMng.getFacebookPlugin()) && InstanceMng.getFacebookPlugin().isSessionOpen() ? InstanceMng.getFacebookPlugin().getFBId() : "";
               _loc6_ = UserDataMng.EXT_PLATFORM_FB;
            }
            else
            {
               _loc5_ = InstanceMng.getApplication().kongGetUserId();
               _loc6_ = UserDataMng.EXT_PLATFORM_KONGREGATE;
            }
         }
         else if(Utils.isDesktop())
         {
            _loc5_ = InstanceMng.getApplication().steamGetSteamId();
            _loc6_ = UserDataMng.EXT_PLATFORM_STEAM;
         }
         else
         {
            _loc5_ = Boolean(InstanceMng.getFacebookPlugin()) && Boolean(InstanceMng.getFacebookPlugin().isSessionOpen()) && Boolean(_loc3_) ? _loc3_.extId : "";
            if(_loc5_ != null && _loc5_ != "")
            {
               _loc6_ = UserDataMng.EXT_PLATFORM_FB;
            }
            if(Utils.isIOS() && _loc6_ != -1)
            {
               if(InstanceMng.getApplication().appleGetUserId() != "" && InstanceMng.getApplication().appleGetUserId() != null)
               {
                  _loc6_ = UserDataMng.EXT_PLATFORM_APPLE_SIGN_IN;
               }
            }
         }
         _loc5_ = param1 ? "" : _loc5_;
         _loc4_.extId = _loc5_;
         _loc4_.extPlatformId = _loc6_;
         _loc4_.playerCreationDate = ServerConnection.smServerTimeMS == 0 || ServerConnection.smServerTimeMS == -1 ? TimerUtil.currentTimeMillis() : ServerConnection.smServerTimeMS;
         _loc4_.playerCreationVersion = Utils.getAppVersion();
         _loc4_.playerName = Utils.generateRandomUserName();
         return _loc4_;
      }
      
      private function processProfileFromUserInfoObject(param1:Object, param2:Boolean = false, param3:Boolean = false) : Object
      {
         var _loc7_:int = 0;
         var _loc4_:Object = new Object();
         var _loc5_:Dictionary = new Dictionary(true);
         _loc5_["accountId"] = true;
         _loc5_["guildId"] = true;
         _loc5_["guildMemberId"] = true;
         _loc5_["guildRank"] = true;
         _loc5_["weeklyTotalScore"] = true;
         _loc5_["globalTotalScore"] = true;
         if(!param3)
         {
            _loc5_["gold"] = true;
            _loc5_["raidCoins"] = true;
            _loc5_["questCoins"] = true;
            _loc5_["auctionTickets"] = true;
            _loc5_["raidTicketsSinglePlayer"] = true;
            _loc5_["raidTicketsMultiPlayer"] = true;
         }
         var _loc6_:Array = DictionaryUtils.getKeys(param1);
         _loc6_.sort();
         if(_loc6_)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc6_.length)
            {
               if(!param2 && _loc5_[_loc6_[_loc7_]] == null || param2)
               {
                  _loc4_[_loc6_[_loc7_]] = param1[_loc6_[_loc7_]];
               }
               _loc7_++;
            }
         }
         return _loc4_;
      }
      
      public function loginViaFB() : void
      {
         this.mLoginSystem = LOGIN_FB;
         if(InstanceMng.getFacebookPlugin() == null)
         {
            FSDebug.debugTrace("No Facebook plugin found...");
            return;
         }
         FSDebug.debugTrace("Logging in Via Facebook");
         Utils.showSyncIcon(true);
         Utils.setLogText(TextManager.getText("TID_GEN_LOGGING"),false,true,false);
         if(InstanceMng.getApplication().isBrowserVersion())
         {
            InstanceMng.getServerConnection().startBrowserLoginCheck();
         }
         var _loc1_:String = InstanceMng.getFacebookPlugin().getAccessToken();
         if(_loc1_ == "" || _loc1_ == null)
         {
            throw new Error("Access token can not be null or empty");
         }
         var _loc2_:FacebookConnectRequest = smGameSparks.getRequestBuilder().createFacebookConnectRequest();
         _loc2_.setAccessToken(_loc1_);
         _loc2_.setTimeoutSeconds(GS_TIMEOUT_SEC);
         _loc2_.setScriptData({
            "v":Utils.getAppVersion(),
            "os":Capabilities.os,
            "platform":this.getPlatformId()
         });
         _loc2_.send(this.onGSLogin);
      }
      
      public function loginViaAppleSignIn(param1:String) : void
      {
         var _loc2_:String = null;
         var _loc3_:AppleConnectRequest = null;
         if(Utils.isIOS())
         {
            this.mLoginSystem = LOGIN_APPLE;
            FSDebug.debugTrace("Logging in Via Apple Sign in");
            Utils.showSyncIcon(true);
            _loc2_ = Utils.getBundleId();
            _loc3_ = smGameSparks.getRequestBuilder().createAppleConnectRequest();
            _loc3_.setClientId(_loc2_);
            _loc3_.setAuthorizationCode(param1);
            _loc3_.setTimeoutSeconds(GS_TIMEOUT_SEC);
            _loc3_.setScriptData({
               "v":Utils.getAppVersion(),
               "os":Capabilities.os,
               "platform":this.getPlatformId()
            });
            _loc3_.send(this.onGSLogin);
         }
      }
      
      public function loginViaKong(param1:String, param2:String) : void
      {
         this.mLoginSystem = LOGIN_KONG;
         var _loc3_:KongregateConnectRequest = smGameSparks.getRequestBuilder().createKongregateConnectRequest();
         _loc3_.setGameAuthToken(param2);
         _loc3_.setUserId(param1);
         _loc3_.setTimeoutSeconds(GS_TIMEOUT_SEC);
         _loc3_.setScriptData({
            "v":Utils.getAppVersion(),
            "os":Capabilities.os,
            "platform":this.getPlatformId()
         });
         _loc3_.send(this.onGSLogin);
      }
      
      public function loginViaSteam(param1:String) : void
      {
         this.mLoginSystem = LOGIN_STEAM;
         var _loc2_:SteamConnectRequest = smGameSparks.getRequestBuilder().createSteamConnectRequest();
         _loc2_.setTimeoutSeconds(GS_TIMEOUT_SEC);
         _loc2_.setScriptData({
            "v":Utils.getAppVersion(),
            "os":Capabilities.os,
            "platform":this.getPlatformId()
         });
         _loc2_.setSessionTicket(param1);
         _loc2_.send(this.onGSLogin);
      }
      
      public function checkIfLogInResponseReceived() : void
      {
         var _loc1_:int = 0;
         if(Boolean(InstanceMng.getApplication()) && InstanceMng.getApplication().isBrowserVersion())
         {
            FSDebug.debugTrace("Browser login timeout");
            if(this.mLoginRequested && !this.mLoginResponseReceived)
            {
               this.loginUser();
            }
            else
            {
               FSDebug.debugTrace("Checking if user is NOT logged in and inet is available");
               if(!this.isUserLoggedIn() && Utils.smInternetAvailable)
               {
                  FSDebug.debugTrace("User not logged in and internet is available, setting timeout to 10 seconds");
                  _loc1_ = Utils.isBrowser() ? 10 : 5;
                  setTimeout(this.checkIfLogInResponseReceived,_loc1_);
               }
            }
         }
      }
      
      public function updateLoginCheckerVariables(param1:Boolean = true, param2:Boolean = true) : void
      {
         if(Boolean(InstanceMng.getApplication()) && InstanceMng.getApplication().isBrowserVersion())
         {
            if(param2)
            {
               clearTimeout(this.mBrowserLoggingTimer);
            }
            this.mLoginRequested = param1;
            this.mLoginResponseReceived = param2;
         }
      }
      
      public function isAvailableToLoginViaFB() : Boolean
      {
         if(!Config.getConfig().getModeOnline())
         {
            return false;
         }
         var _loc1_:FSFacebookPlugin = InstanceMng.getFacebookPlugin();
         var _loc2_:String = _loc1_ != null ? _loc1_.getFBId() : null;
         var _loc3_:String = _loc1_ != null ? _loc1_.getAccessToken() : null;
         var _loc4_:Boolean = _loc1_ != null ? _loc1_.isSessionOpen() : Boolean(null);
         return _loc1_ != null && _loc4_ && Utils.smInternetAvailable && _loc3_ != null;
      }
      
      public function loginUser(param1:Boolean = false, param2:int = 0) : void
      {
         var _loc7_:String = null;
         var _loc8_:int = 0;
         FSDebug.debugTrace("LOGIN USER...");
         FSDebug.debugTrace("Utils.smInternetAvailable: " + Utils.smInternetAvailable);
         if(!Config.getConfig().getModeOnline())
         {
            this.onLogin(false);
            return;
         }
         Utils.showSyncIcon(true);
         var _loc3_:FSFacebookPlugin = InstanceMng.getFacebookPlugin();
         var _loc4_:String = _loc3_ != null ? _loc3_.getFBId() : null;
         var _loc5_:String = _loc3_ != null ? _loc3_.getAccessToken() : null;
         var _loc6_:Boolean = _loc3_ != null ? _loc3_.isSessionOpen() : Boolean(null);
         if(_loc3_ != null && _loc6_)
         {
            FSDebug.debugTrace("fbId: " + _loc4_);
            FSDebug.debugTrace("fbAccessToken: " + _loc5_);
            FSDebug.debugTrace("fbSessionOpen: " + _loc6_);
            if(Utils.smInternetAvailable)
            {
               if(_loc4_ != null && _loc5_ != null)
               {
                  FSDebug.debugTrace("[loginUser] - logging in via fb since we\'ve got the fb id and access token");
                  this.loginViaFB();
               }
               else
               {
                  FSDebug.debugTrace("[loginUser] - requesting info to FB when trying to login");
                  _loc3_.requestOwnerInfoToFB();
               }
            }
            else
            {
               FSDebug.debugTrace("==== Internet not available yet, skipping");
            }
         }
         else if(Utils.isDesktop())
         {
            Utils.setLogText("Logging in on Steam Servers...".toUpperCase(),false,false,false,false);
            _loc7_ = InstanceMng.getApplication().steamGetSessionTicket();
            if(_loc7_ != "")
            {
               this.loginViaSteam(_loc7_);
            }
            else if(Utils.isSimulator())
            {
               _loc8_ = 5;
               if(param2 < _loc8_)
               {
                  Utils.setLogText("Could not get Steam info, retrying in 3 seconds...\n(Attempt " + (param2 + 1) + "/" + _loc8_ + ")",false,false,false,false);
                  setTimeout(this.loginUser,3000,param1,param2 + 1);
               }
               else
               {
                  InstanceMng.getPopupMng().openErrorPopup("Steam app not launched or could not get a valid Steam ticket, please make sure the Steam Client is launched. \n Contact support@frozenshard.com for more info.",false);
               }
            }
         }
         else if(InstanceMng.getApplication().isKongregateVersion())
         {
            Utils.setLogText(TextManager.getText("TID_GEN_LOGGING"),false,true,false);
            InstanceMng.getApplication().loginViaKongregate();
         }
         else if(Config.smSilentLoginON && !Utils.isBrowser() && Utils.smInternetAvailable)
         {
            this.performSilentLogin(param1);
         }
         else if(InstanceMng.getApplication().isFacebookBrowser() && Config.ENVIRONMENT_ACTIVE == Config.ENVIRONMENT_DEV && Config.IS_BROWSER_LOCAL == true && _loc4_ == null)
         {
            this.performSilentLogin(param1,true);
         }
      }
      
      public function onGSLogin(param1:AuthenticationResponse) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Object = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:Object = null;
         if(!param1.HasErrors())
         {
            this.mLoginErrorsCount = 0;
            smPlayerDeviceLoginKey = param1.getScriptData() ? param1.getScriptData()["loginTracker"] : "";
            smPlayerCreationDate = param1.getScriptData() ? Number(param1.getScriptData()["creationDate"]) : 0;
            if(this.mLoginSystem == LOGIN_APPLE)
            {
               Utils.saveDataOnSharedObj("authToken",param1.getAuthToken());
               if(param1.getScriptData())
               {
                  Utils.saveDataOnSharedObj("accessToken",param1.getScriptData()["accessToken"]);
                  Utils.saveDataOnSharedObj("refreshToken",param1.getScriptData()["refreshToken"]);
               }
               InstanceMng.getUserDataMng().getOwnerUserData().setExtId(InstanceMng.getApplication().appleGetUserId());
               InstanceMng.getUserDataMng().getOwnerUserData().setExtPlatform(UserDataMng.EXT_PLATFORM_APPLE_SIGN_IN);
            }
            if(!param1.getNewPlayer())
            {
               this.onPlayerAuthenticatedGetInfo();
            }
            else
            {
               if(InstanceMng.getApplication().isFacebookBrowser())
               {
                  InstanceMng.getFacebookPlugin().setFirstName(param1.getDisplayName());
               }
               _loc2_ = this.isJustMigratedPlayer(param1.getScriptData());
               if(_loc2_)
               {
                  this.onPlayerAuthenticatedGetInfo();
               }
               else
               {
                  this.createUser(param1.getUserId());
               }
            }
         }
         else
         {
            if(param1.getScriptData() != null)
            {
               _loc3_ = param1.getErrors();
               _loc4_ = _loc3_.hasOwnProperty("accessToken") && _loc3_["accessToken"] == "ACCOUNT_ALREADY_LINKED";
               _loc5_ = _loc3_.hasOwnProperty("accessToken") && _loc3_["accessToken"] == "NOTAUTHENTICATED";
               if(_loc4_ || _loc5_)
               {
                  _loc6_ = param1.getScriptData().hasOwnProperty("isFBConnect") && param1.getScriptData()["isFBConnect"] == true;
                  if((_loc6_) && Boolean(InstanceMng.getFacebookPlugin()))
                  {
                     this.recoverFromFBAlterAccount();
                     return;
                  }
                  _loc7_ = InstanceMng.getApplication().appleGetUserId();
                  if(_loc7_ != "" && _loc7_ != null)
                  {
                     this.mRecoveringFromAlternativeAccount = true;
                     Utils.setLogText("Error: This device is already linked to a different Apple Id, recovering, please hold on...",false,true,false);
                     setTimeout(smGameSparks.reset,3500);
                     return;
                  }
               }
            }
            if(this.mLoginErrorsCount < 3)
            {
               ++this.mLoginErrorsCount;
               if(this.mLoginErrorsCount >= 2)
               {
                  smGameSparks.reset();
               }
               if(Utils.isDesktop())
               {
                  _loc8_ = param1["data"]["error"]["steamError"];
                  Utils.setLogText("Requesting valid Steam Ticket in 3s...",false,true);
                  InstanceMng.getApplication().steamRelogin();
                  setTimeout(this.loginUser,3000);
               }
            }
            else
            {
               this.mLoginErrorsCount = 0;
               _loc9_ = Boolean(param1.getErrors()) && param1.getErrors().hasOwnProperty("error") ? param1.getErrors()["error"] : null;
               if(_loc9_ == null)
               {
                  _loc9_ = param1.getAttribute("error");
               }
               if(_loc9_ != null)
               {
                  FSDebug.debugTrace("Error: " + Utils.objectToString(param1));
                  Utils.setLogText("[Error Logging in: " + Utils.objectToString(_loc9_) + "]",true,true,false);
               }
            }
         }
      }
      
      private function onPlayerAuthenticatedGetInfo() : void
      {
         smPlayerLoggedIn = true;
         Utils.smInternetAvailable = true;
         Utils.showSyncIcon(false);
         this.getMe();
      }
      
      public function recoverFromFBAlterAccount() : void
      {
         var resetGS:Function;
         this.mRecoveringFromAlternativeAccount = true;
         Utils.setLogText("Recovering from alternative account login, please hold on...",false,true,false);
         if(Utils.isBrowser())
         {
            smGameSparks.reset();
         }
         else
         {
            resetGS = function():void
            {
               if(smGameSparks)
               {
                  InstanceMng.getApplication().reCreateFacebookPlugin();
                  setTimeout(smGameSparks.reset,3500);
               }
            };
            if(InstanceMng.getFacebookPlugin() != null)
            {
               InstanceMng.getFacebookPlugin().closeSessionAndClearTokenInformation(resetGS);
            }
         }
      }
      
      private function isJustMigratedPlayer(param1:Object) : Boolean
      {
         return param1 ? param1.hasOwnProperty("justMigrated") : false;
      }
      
      private function performSilentLogin(param1:Boolean, param2:Boolean = false) : void
      {
         var deviceId:String;
         var deviceOS:String;
         var deviceName:String;
         var req:DeviceAuthenticationRequest;
         var isPopErrorTryRelogin:Boolean = param1;
         var isBrowserLocal:Boolean = param2;
         this.mLoginSystem = LOGIN_SILENT;
         Utils.setLogText(TextManager.getText("TID_GEN_LOGGING"),false,true,false);
         deviceId = InstanceMng.getApplication().getDeviceID();
         if(deviceId == "" && !isBrowserLocal)
         {
            throw new Error("Device ID can not be empty");
         }
         deviceOS = Utils.isIOS() ? "IOS" : "ANDROID";
         deviceOS = isBrowserLocal ? "FB" : deviceOS;
         deviceName = Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) ? InstanceMng.getUserDataMng().getOwnerUserData().getAccountId() : "";
         req = smGameSparks.getRequestBuilder().createDeviceAuthenticationRequest();
         req.setDeviceId(deviceId);
         req.setDeviceOS(deviceOS);
         req.setDeviceName(deviceName);
         req.setTimeoutSeconds(GS_TIMEOUT_SEC);
         req.setScriptData({
            "v":Utils.getAppVersion(),
            "os":Capabilities.os,
            "platform":this.getPlatformId()
         });
         FSDebug.debugTrace("Performing silent login...");
         req.send(function onSilentLoginResponseReceived(param1:AuthenticationResponse):void
         {
            var _loc2_:Boolean = false;
            var _loc3_:Popup = null;
            if(!param1.HasErrors())
            {
               smPlayerDeviceLoginKey = param1.getScriptData() ? param1.getScriptData()["loginTracker"] : "";
               smPlayerCreationDate = param1.getScriptData() ? Number(param1.getScriptData()["creationDate"]) : 0;
               if(!param1.getNewPlayer())
               {
                  smPlayerLoggedIn = true;
                  FSDebug.debugTrace("Ok - SILENT LOGIN");
                  Utils.showSyncIcon(false);
                  getMe();
               }
               else
               {
                  _loc2_ = isJustMigratedPlayer(param1.getScriptData());
                  if(_loc2_)
                  {
                     smPlayerLoggedIn = true;
                     FSDebug.debugTrace("Ok - SILENT LOGIN (Just Migrated)");
                     Utils.showSyncIcon(false);
                     getMe();
                  }
                  else
                  {
                     createUser(param1.getUserId());
                  }
               }
            }
            else
            {
               FSDebug.debugTrace("Fail - SILENT LOGIN");
               Utils.showSyncIcon(false);
               if(isPopErrorTryRelogin)
               {
                  _loc3_ = InstanceMng.getPopupMng().getPopupShown();
                  if(_loc3_ is PopupError)
                  {
                     PopupError(_loc3_).setEnableReloginButton(true);
                  }
               }
               else
               {
                  if(Boolean(param1.getErrors()) && param1.getErrors().hasOwnProperty("error"))
                  {
                     Utils.setLogText(param1.getErrors().error);
                     FSDebug.debugTrace("ERROR!!" + param1.getErrors().error);
                  }
                  FSDebug.debugTrace("ERROR!!");
               }
            }
         });
      }
      
      public function getMe() : void
      {
         var _loc1_:AccountDetailsRequest = null;
         Utils.showSyncIcon(true);
         FSDebug.debugTrace("[ServerConnection -> ME call]");
         Utils.setLogText(TextManager.getText("TID_SERVER_LOADING_DATA"),false,true,false,false);
         if(this.isUserLoggedIn())
         {
            _loc1_ = smGameSparks.getRequestBuilder().createAccountDetailsRequest();
            _loc1_.setTimeoutSeconds(GS_TIMEOUT_SEC);
            _loc1_.setDurable(Config.DURABLE_CONNECTION);
            _loc1_.send(this.onGSMeInfoReceived);
         }
         else
         {
            FSDebug.debugTrace("getMe -> NOT CONNECTED!");
            setTimeout(this.getMe,1500);
         }
      }
      
      private function onMeInformationReceivedSuccessfuly() : void
      {
         this.updateLoginCheckerVariables();
         FSDebug.debugTrace("getMe - Ok");
         Utils.showSyncIcon(false);
         this.onLogin(true);
         if(smServerPlayerBlacklisted)
         {
            InstanceMng.getPopupMng().closePopupShown();
            InstanceMng.getPopupMng().openErrorPopup(TextManager.getText("TID_GEN_FRAUD_PURCHASE"),false);
         }
         if(ServerConnection.smServerPlayerDuplicated)
         {
            InstanceMng.getPopupMng().closePopupShown();
            InstanceMng.getPopupMng().openErrorPopup(TextManager.getText("TID_MIGRATION_ERROR_MIGRATED"),false);
         }
      }
      
      private function onMeInformationFailed() : void
      {
         FSDebug.debugTrace("getMe - Fail");
         Utils.showSyncIcon(false);
         this.onLogin(false);
      }
      
      private function onGSMeInfoReceived(param1:AccountDetailsResponse) : void
      {
         var getDetails:Function = null;
         var scriptProfile:Object = null;
         var privateProfile:Object = null;
         var steamCurrency:String = null;
         var extPhotoURL:String = null;
         var privateKeys:Array = null;
         var i:int = 0;
         var response:AccountDetailsResponse = param1;
         getDetails = function():void
         {
            var _loc1_:AccountDetailsRequest = smGameSparks.getRequestBuilder().createAccountDetailsRequest();
            _loc1_.setTimeoutSeconds(GS_TIMEOUT_SEC);
            _loc1_.setDurable(Config.DURABLE_CONNECTION);
            _loc1_.send(onGSMeInfoReceived);
         };
         if(!response.HasErrors() && response.getScriptData() != null && response.getScriptData().profile != null)
         {
            if(smServerUserObject == null)
            {
               smServerUserObject = new Object();
            }
            scriptProfile = response.getScriptData() ? response.getScriptData().profile : null;
            privateProfile = response.getScriptData() ? response.getScriptData().privateData : null;
            steamCurrency = response.getScriptData().hasOwnProperty("steamCurrency") ? response.getScriptData()["steamCurrency"] : "";
            if(steamCurrency != "")
            {
               FSInAppsManager.smCurrencyCode = steamCurrency;
            }
            extPhotoURL = response.getScriptData().hasOwnProperty("extPhotoURL") ? response.getScriptData()["extPhotoURL"] : "";
            if(extPhotoURL != "")
            {
               scriptProfile["extPhotoURL"] = extPhotoURL;
            }
            privateKeys = DictionaryUtils.getKeys(privateProfile);
            i = 0;
            while(i < privateKeys.length)
            {
               scriptProfile[privateKeys[i]] = privateProfile[privateKeys[i]];
               i++;
            }
            smServerUserObject.profile = scriptProfile;
            smServerUserObject._id = response.getUserId();
            smServerUserObject.currencies = new Object();
            smServerUserObject.currencies[CURRENCY_GOLD] = response.getCurrency1();
            smServerUserObject.currencies[CURRENCY_RAID_COINS] = response.getCurrency2();
            smServerUserObject.currencies[CURRENCY_QUEST_COINS] = response.getCurrency3();
            smServerUserObject.currencies[CURRENCY_AH_TOKENS] = response.getCurrency4();
            smServerUserObject.currencies[CURRENCY_RAID_TICKETS_SP] = response.getCurrency5();
            smServerUserObject.currencies[CURRENCY_RAID_TICKETS_MP] = response.getCurrency6();
            smServerPlayerBlacklisted = response.getScriptData().isBlacklisted;
            smServerPlayerDuplicated = response.getScriptData().isDuplicated;
            this.mServerPlayerVIP = response.getScriptData().isVIP;
            this.mServerPlayerDev = response.getScriptData().isDev;
            this.smServerIsOldPlayerComingBack = response.getScriptData().isOldPlayerComingBack;
            smChatMutedTimestamp = response.getScriptData().hasOwnProperty("chatMutedTimestamp") && !isNaN(response.getScriptData().chatMutedTimestamp) ? Number(response.getScriptData().chatMutedTimestamp) : -1;
            this.mServerPlayerPurchasesAmount = response.getScriptData().purchasesAmount;
            this.mServerPlayerReferralCode = response.getScriptData().referralCode;
            this.mServerPlayerTransferCode = response.getScriptData().transferCode;
            smServerPlayerReferrals = response.getScriptData().referrals;
            FSInAppsManager.mPlayerVGoods = response.getVirtualGoods();
            this.onMeInformationReceivedSuccessfuly();
         }
         else if(Utils.isBrowser())
         {
            FSDebug.debugTrace("Failed on GS -> calling back in 2 seconds");
            TweenMax.delayedCall(2,getDetails);
         }
         else
         {
            this.onMeInformationFailed();
         }
      }
      
      public function addCommonEntityAttributes(param1:Object) : Object
      {
         if(param1)
         {
            param1.uid = this.getUserId();
            param1.nick = Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) ? InstanceMng.getUserDataMng().getOwnerUserData().getName() : "";
            param1.deviceInfo = Capabilities.version.toString();
            param1.isDebug = Capabilities.isDebugger;
            param1.os = Capabilities.os;
            param1.platform = this.getPlatformId();
            param1.v = Utils.getAppVersion();
            param1.when = this.getRequestDateObject();
         }
         return param1;
      }
      
      public function getOwnerUidQuery() : String
      {
         return "{\'uid\':\'" + this.getUserId() + "\'}";
      }
      
      public function getWeeklyOffersFromServer(param1:Function = null) : void
      {
         var _loc2_:String = "offersWeekly";
         this.searchInCollection(_loc2_,"{}",param1);
      }
      
      public function getHourlyOffersFromServer(param1:Function = null) : void
      {
         var _loc2_:String = "offersHourly";
         this.searchInCollection(_loc2_,"{}",param1);
      }
      
      public function getOffers(param1:Function = null) : void
      {
         this.searchInCollection("Offers","{}",param1);
      }
      
      private function onPurchasesUnprocessedReceived(param1:Array) : void
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         if(param1)
         {
            _loc5_ = "";
            _loc4_ = 0;
            while(_loc4_ < param1.length)
            {
               _loc5_ += Utils.getDataId(param1[_loc4_]);
               _loc5_ = _loc5_ + (_loc4_ < param1.length - 1 ? "," : "");
               _loc4_++;
            }
            if(this.isUserLoggedIn() && _loc5_ != "")
            {
               this.deleteMultipleEntitiesInCollection("purchasesUnprocessed",_loc5_);
            }
         }
      }
      
      public function getServerTime(param1:Function, param2:Array = null) : void
      {
         var _loc3_:String = "SERVER_TIME";
         this.runScript(_loc3_,null,param1,param2);
      }
      
      public function getProducts(param1:Function = null, param2:Boolean = false) : void
      {
         var req:ListVirtualGoodsRequest = null;
         var tags:Vector.<String> = null;
         var processedAlready:Boolean = false;
         var onSuccessFunction:Function = param1;
         var force:Boolean = param2;
         if(this.isUserLoggedIn() && (FSInAppsManager.mProductsArr == null || force))
         {
            req = new ListVirtualGoodsRequest(smGameSparks);
            tags = new <String>["STORE"];
            req.setTags(tags);
            req.setIncludeDisabled(false);
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:ListVirtualGoodsResponse):void
            {
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("products");
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  onPurchasableProductsReceivedGS(param1.getVirtualGoods());
                  if(onSuccessFunction != null)
                  {
                     onSuccessFunction();
                  }
               }
               else
               {
                  FSDebug.debugTrace("Error retrieving virtual goods");
               }
            });
         }
         else
         {
            FSDebug.debugTrace("[getProducts] - Products not being requested as they are already here.");
         }
      }
      
      private function onPurchasableProductsReceivedGS(param1:Vector.<VirtualGood>) : void
      {
         var _loc2_:Array = null;
         var _loc4_:String = null;
         FSDebug.debugTrace("[onPurchasableProductsReceivedGS] OK");
         var _loc3_:int = 0;
         if(_loc2_)
         {
            _loc2_.length = 0;
         }
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            if(Boolean(param1[_loc3_].getTags()) && param1[_loc3_].getTags().indexOf("STORE") != -1)
            {
               _loc4_ = param1[_loc3_].getPropertySet().PREFIX.type;
               if(_loc2_ == null)
               {
                  _loc2_ = new Array();
               }
               _loc2_.push(_loc4_ + param1[_loc3_].getShortCode());
            }
            if(FSInAppsManager.mVGoodsCatalog == null)
            {
               FSInAppsManager.mVGoodsCatalog = new Dictionary(true);
            }
            FSInAppsManager.mVGoodsCatalog[param1[_loc3_].getShortCode()] = param1[_loc3_];
            _loc3_++;
         }
         if(FSInAppsManager.mPlayerVGoods != null)
         {
            InstanceMng.getApplication().getInAppsManager().processVGoods();
         }
         InstanceMng.getApplication().getInAppsManager().processPurchasableProductsReceived(_loc2_);
      }
      
      public function processPurchaseReceipt(param1:String = "", param2:String = "", param3:String = "", param4:String = "", param5:String = "", param6:Function = null, param7:Array = null, param8:Function = null, param9:Array = null, param10:Boolean = false) : void
      {
         var opName:String = null;
         var request:* = undefined;
         var processedAlready:Boolean = false;
         var receipt:String = param1;
         var signature:String = param2;
         var signedData:String = param3;
         var origError:String = param4;
         var steamOrderId:String = param5;
         var onSuccessFunction:Function = param6;
         var onSuccessParams:Array = param7;
         var onFailFunction:Function = param8;
         var onFailParams:Array = param9;
         var returnDataOnSuccess:Boolean = param10;
         Utils.setLogText(TextManager.getText("TID_SHOP_RECEIPT_PENDING"),false,false,false,false);
         if(this.isUserLoggedIn())
         {
            opName = "";
            if(Utils.isIOS())
            {
               request = new IOSBuyGoodsRequest(smGameSparks);
               request.setReceipt(receipt);
               opName = "iosPurchase";
            }
            else if(Utils.isAndroid())
            {
               request = new GooglePlayBuyGoodsRequest(smGameSparks);
               GooglePlayBuyGoodsRequest(request).setSignature(signature);
               GooglePlayBuyGoodsRequest(request).setSignedData(signedData);
               opName = "androidPurchase";
            }
            else if(Utils.isDesktop())
            {
               request = new SteamBuyGoodsRequest(smGameSparks);
               SteamBuyGoodsRequest(request).setOrderId(steamOrderId);
               opName = "steamPurchase";
            }
            request.setTimeoutSeconds(GS_TIMEOUT_SEC);
            request.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            request.send(function(param1:BuyVirtualGoodResponse):void
            {
               var _loc2_:Vector.<Boughtitem> = null;
               var _loc3_:Object = null;
               var _loc4_:Object = null;
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("processPurchaseReceipt");
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  Utils.removeLog();
                  _loc2_ = param1.getBoughtItems();
                  onDDBBAccessedProcessResponse(opName,true,"processPurchaseReceipt","","",_loc2_,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
               }
               else
               {
                  _loc3_ = param1.getAttribute("error");
                  _loc4_ = new Object();
                  _loc4_.verificationError = _loc3_.hasOwnProperty("verificationError") ? _loc3_.verificationError : null;
                  _loc4_.origError = origError;
                  _loc4_.storeError = _loc3_.hasOwnProperty("storeError") ? _loc3_.storeError : null;
                  if(onFailParams)
                  {
                     onFailParams.unshift(_loc4_);
                  }
                  onDDBBAccessedProcessResponse(opName,false,"processPurchaseReceipt","","",_loc4_,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
               }
            });
         }
         else
         {
            setTimeout(this.processPurchaseReceipt,1000,receipt,signature,signedData,origError,steamOrderId,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
         }
      }
      
      public function updateNick(param1:String) : void
      {
         this.updateNickByCollectionName(param1,"userPurchases");
      }
      
      private function updateNickByCollectionName(param1:String, param2:String) : void
      {
         this.searchInCollection(param2,this.getOwnerUidQuery(),this.onUserInfoReceivedChangeNick,[param1,param2]);
      }
      
      private function onUserInfoReceivedChangeNick(param1:Object, param2:String, param3:String) : void
      {
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc4_:Array = param1 ? param1 as Array : null;
         if(_loc4_ != null && _loc4_.length > 0)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               _loc6_ = _loc4_[_loc5_];
               if(Boolean(_loc6_ != null) && Boolean(this.getBackendUserProfile()) && _loc6_.uid == this.getUserId())
               {
                  _loc6_.nick = param2.toLowerCase();
                  this.updateEntityInCollection(param3,_loc6_,false);
               }
               _loc5_++;
            }
         }
      }
      
      public function addCardsDeletedInstance(param1:String, param2:int, param3:int) : void
      {
         var _loc4_:Object = new Object();
         _loc4_ = this.addCommonEntityAttributes(_loc4_);
         _loc4_.cardsDeleted = param1;
         _loc4_.goldReceived = param2;
         _loc4_.cardsAmount = param3;
         var _loc5_:String = InstanceMng.getUserDataMng().getOwnerUserData() != null ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelSku() : null;
         if(_loc5_)
         {
            _loc4_.level = _loc5_;
         }
         this.createEntityInCollection("cardsDeleted",_loc4_);
      }
      
      public function addDungeonCompleted(param1:int, param2:String, param3:String, param4:String, param5:int, param6:int, param7:int, param8:Boolean) : void
      {
         var _loc9_:Object = new Object();
         _loc9_ = this.addCommonEntityAttributes(_loc9_);
         _loc9_.dungeonIndex = param5;
         _loc9_.gold = param1;
         _loc9_.cards = param2;
         _loc9_.difficulty = param6;
         _loc9_.cards = param2;
         _loc9_.packs = param3;
         _loc9_.portraits = param4;
         _loc9_.currentBattle = param7;
         _loc9_.isCompleted = param8;
         var _loc10_:String = InstanceMng.getUserDataMng().getOwnerUserData() != null ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelSku() : null;
         if(_loc10_)
         {
            _loc9_.userLevel = _loc10_;
         }
         this.createEntityInCollection("dungeons",_loc9_);
      }
      
      public function addPackPurchasedInstance(param1:String, param2:int, param3:String, param4:String) : void
      {
         var _loc5_:Object = new Object();
         _loc5_ = this.addCommonEntityAttributes(_loc5_);
         _loc5_.packSku = param1;
         _loc5_.goldCost = param2;
         _loc5_.cards = param3;
         _loc5_.origin = param4;
         var _loc6_:String = InstanceMng.getUserDataMng().getOwnerUserData() != null ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelSku() : null;
         if(_loc6_)
         {
            _loc5_.level = _loc6_;
         }
         this.createEntityInCollection("goldPacksPurchased",_loc5_);
      }
      
      public function addBundlePurchasedInstance(param1:FSShopItem) : void
      {
         var _loc2_:Object = new Object();
         _loc2_ = this.addCommonEntityAttributes(_loc2_);
         var _loc3_:BundleDef = BundleDef(param1.getDef());
         _loc2_.bundleSku = _loc3_.getSku();
         _loc2_.gold = _loc3_.getGold();
         _loc2_.raidPoints = _loc3_.getRaidPoints();
         _loc2_.questPoints = _loc3_.getQuestPoints();
         _loc2_.AHTokens = _loc3_.getAHTokens();
         _loc2_.cards = _loc3_.getCards() ? _loc3_.getCards().join(",") : "";
         _loc2_.packs = _loc3_.getPacks() ? _loc3_.getPacks().join(",") : "";
         _loc2_.skins = _loc3_.getSkins() ? _loc3_.getSkins().join(",") : "";
         _loc2_.boosts = _loc3_.getBoosts() ? _loc3_.getBoosts().join(",") : "";
         this.createEntityInCollection("bundlesPurchased",_loc2_);
      }
      
      public function trackCardCrafted(param1:int, param2:String, param3:String) : void
      {
         var _loc4_:Object = new Object();
         _loc4_ = this.addCommonEntityAttributes(_loc4_);
         _loc4_.goldCost = param1;
         _loc4_.cardsUsed = param2;
         _loc4_.cardCraftedSku = param3;
         var _loc5_:String = InstanceMng.getUserDataMng().getOwnerUserData() != null ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelSku() : null;
         if(_loc5_)
         {
            _loc4_.level = _loc5_;
         }
         this.createEntityInCollection("crafts",_loc4_);
      }
      
      public function addUserAction(param1:Object) : void
      {
         this.createEntityInCollection("userActions",param1);
      }
      
      public function addUserActionBlock() : void
      {
         var _loc1_:Object = null;
         if(FSTracker.smUserActions != null && FSTracker.smUserActions.length > 0)
         {
            _loc1_ = new Object();
            _loc1_ = this.addCommonEntityAttributes(_loc1_);
            _loc1_["actions"] = FSTracker.smUserActions;
            this.createEntityInCollection("userActions",_loc1_);
            if(FSTracker.smUserActions)
            {
               FSTracker.smUserActions.length = 0;
            }
         }
      }
      
      public function addUserPurchaseInstance(param1:String, param2:String, param3:String, param4:String, param5:Boolean, param6:Number) : void
      {
         var _loc7_:Object = new Object();
         _loc7_ = this.addCommonEntityAttributes(_loc7_);
         _loc7_.prodId = param1;
         _loc7_.priceLocale = param2;
         _loc7_.receivedItems = param5.toString();
         if(param4 != "" && param4 != null)
         {
            _loc7_.extraInfo = param4;
         }
         var _loc8_:String = InstanceMng.getUserDataMng().getOwnerUserData() != null ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelSku() : null;
         if(_loc8_)
         {
            _loc7_.level = _loc8_;
         }
         this.createEntityInCollection("userPurchases",_loc7_,FSTracker.trackMiscAction,[FSTracker.CATEGORY_PURCHASE,FSTracker.ACTION_PURCHASE,{"prodId":param1}]);
      }
      
      public function addQuestShopPurchaseInstance(param1:String, param2:String, param3:String, param4:String, param5:Boolean, param6:Number) : void
      {
         var _loc7_:Object = new Object();
         _loc7_ = this.addCommonEntityAttributes(_loc7_);
         _loc7_.prodId = param1;
         _loc7_.cards = param3;
         _loc7_.price = param2;
         var _loc8_:String = InstanceMng.getUserDataMng().getOwnerUserData() != null ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelSku() : null;
         if(_loc8_)
         {
            _loc7_.level = _loc8_;
         }
         this.createEntityInCollection("questShopPurchases",_loc7_,FSTracker.trackMiscAction,[FSTracker.CATEGORY_QUEST_PURCHASE,FSTracker.ACTION_PURCHASE,{"prodId":param1}]);
      }
      
      public function addRaidsShopPackPurchaseInstance(param1:String, param2:String, param3:String, param4:String, param5:Boolean, param6:Number) : void
      {
         var _loc7_:Object = new Object();
         _loc7_ = this.addCommonEntityAttributes(_loc7_);
         _loc7_.prodId = param1;
         _loc7_.cards = param3;
         _loc7_.price = param2;
         var _loc8_:String = InstanceMng.getUserDataMng().getOwnerUserData() != null ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelSku() : null;
         if(_loc8_)
         {
            _loc7_.level = _loc8_;
         }
         this.createEntityInCollection("raidsShopPurchases",_loc7_,FSTracker.trackMiscAction,[FSTracker.CATEGORY_RAIDS_PURCHASE,FSTracker.ACTION_PURCHASE,{"prodId":param1}]);
      }
      
      public function addUserCraftedInstance(param1:String, param2:String, param3:String) : void
      {
         var _loc4_:Object = new Object();
         _loc4_ = this.addCommonEntityAttributes(_loc4_);
         _loc4_.card = param1;
         _loc4_.cardName = param3;
         _loc4_.cardsUsedForCrafting = param2;
         this.createEntityInCollection("craftedCards",_loc4_);
      }
      
      public function addUserAuctionCardInstance(param1:String, param2:String, param3:String, param4:Boolean) : void
      {
         var _loc5_:Object = new Object();
         _loc5_ = this.addCommonEntityAttributes(_loc5_);
         _loc5_.card = param1;
         _loc5_.cardName = param2;
         _loc5_.addingToCollection = param4;
         _loc5_.auctionId = param3;
         this.createEntityInCollection("auctionCardsTrack",_loc5_);
      }
      
      public function addRaidsCardShopInstance(param1:String, param2:String, param3:int, param4:Boolean = false) : void
      {
         var _loc5_:Object = new Object();
         _loc5_ = this.addCommonEntityAttributes(_loc5_);
         _loc5_.card = param1;
         _loc5_.cardName = param4 ? param2 + " (x10)" : param2;
         _loc5_.price = param4 ? param3 * 10 : param3;
         this.createEntityInCollection("raidsShopPurchases",_loc5_);
      }
      
      public function getPlatformId(param1:Boolean = false) : String
      {
         var _loc2_:String = "";
         if(Utils.isIOS())
         {
            _loc2_ = !param1 ? "iOS" : "I";
         }
         else if(Utils.isAndroid())
         {
            _loc2_ = !param1 ? "Android" : "A";
         }
         else if(Utils.isDesktop())
         {
            _loc2_ = !param1 ? "Steam" : "S";
         }
         else if(Utils.isBrowser())
         {
            if(InstanceMng.getApplication())
            {
               if(InstanceMng.getApplication().isFacebookBrowser())
               {
                  _loc2_ = !param1 ? "Facebook" : "F";
               }
               else if(InstanceMng.getApplication().isKongregateVersion())
               {
                  _loc2_ = !param1 ? "Kongregate" : "K";
               }
            }
         }
         return _loc2_;
      }
      
      public function addLevelScore(param1:String, param2:int, param3:String, param4:Number = -1, param5:Boolean = false, param6:int = 0) : void
      {
         var onLevelScoreSubmittedFailed:Function = null;
         var level:String = null;
         var levelScore:int = 0;
         var levelSku:String = param1;
         var score:int = param2;
         var timeStamp:String = param3;
         var timeStampMs:Number = param4;
         var forceUpload:Boolean = param5;
         var difficulty:int = param6;
         onLevelScoreSubmittedFailed = function(param1:String, param2:int, param3:String, param4:Number = -1, param5:Boolean = false, param6:int = 0):void
         {
            setTimeout(addLevelScore,1500,param1,param2,param3,param4,param5,param6);
         };
         if(Boolean(!forceUpload) && Boolean(Root.smCurrentLevelScore) && Boolean(Root.smCurrentLevelScore.levelScore) && Boolean(Root.smCurrentLevelScore.levelScore.level))
         {
            level = Root.smCurrentLevelScore.levelScore.level;
            levelScore = int(Root.smCurrentLevelScore.levelScore.score);
            FSDebug.debugTrace("[AddLevelScore] " + "| Level: " + level + " | Score: " + levelScore + " || Score being sent: " + levelSku + " (" + score + ")");
            if(Root.smCurrentLevelScore.levelScore.level == levelSku && Root.smCurrentLevelScore.levelScore.score >= score)
            {
               return;
            }
         }
         if(this.isUserAllowedToMakeServerCalls() && Boolean(this.getBackendUserProfile()))
         {
            this.addScoreToLeaderboard("PLAYER_PVE",score,0,3,3,levelSku,difficulty,null,null,onLevelScoreSubmittedFailed,[levelSku,score,timeStamp,timeStampMs,forceUpload,difficulty]);
         }
         else
         {
            onLevelScoreSubmittedFailed(levelSku,score,timeStamp,timeStampMs,forceUpload,difficulty);
         }
      }
      
      public function getOwnerScoreByLevelSku(param1:String, param2:int, param3:Function, param4:Boolean = true, param5:int = 0) : void
      {
         if(this.isUserAllowedToMakeServerCalls() && Boolean(this.getBackendUserProfile()))
         {
            this.getSocialLeaderboardData(param1,param5,true,1,this.onOwnerScoresByLevelSkuSuccess,[param1,param2,param3,param4,param5],this.onOwnerScoresByLevelSkuFailed,[param1,param2,param3,param4,param5]);
         }
      }
      
      private function onOwnerScoresByLevelSkuSuccess(param1:Object, param2:String, param3:int, param4:Function, param5:Boolean = true, param6:int = 0) : void
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(param1 != null && param1[0] != null && param1[0].score != null)
         {
            _loc7_ = int(param1[0].score);
         }
         _loc8_ = Math.max(param3,_loc7_);
         if(InstanceMng.getUserDataMng().getOwnerUserData())
         {
            InstanceMng.getUserDataMng().getOwnerUserData().setTopScoreByLevelSku(param2,_loc8_);
         }
         param4(_loc8_);
         if(param5 && _loc7_ < param3)
         {
            this.addLevelScore(param2,param3,"offline",-1,true,param6);
         }
      }
      
      private function onOwnerScoresByLevelSkuFailed(param1:String, param2:int, param3:Function, param4:Boolean = true, param5:int = 0) : void
      {
         if(this.isUserLoggedIn())
         {
            TweenMax.delayedCall(0.5,this.getOwnerScoreByLevelSku,[param1,param2,param3,param4,param5]);
         }
      }
      
      public function getOwnerTopsScores(param1:Function, param2:int = 1, param3:Boolean = true) : void
      {
         var _loc5_:int = 0;
         var _loc6_:UserData = null;
         var _loc7_:int = 0;
         var _loc4_:String = this.getUserId();
         if(_loc4_ != "")
         {
            _loc5_ = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
            _loc6_ = Utils.getOwnerUserData();
            if(_loc6_)
            {
               _loc7_ = param3 ? _loc6_.getCurrentLevelIndex(_loc5_) : param2;
               this.getPlayerPvEScores(_loc4_,param2,_loc7_,_loc5_,param1);
            }
         }
      }
      
      public function getFriendsScoreByLevelSku(param1:String, param2:Function, param3:Array, param4:Boolean = false) : void
      {
         var _loc5_:int = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
         this.getSocialLeaderboardData(param1,_loc5_,false,20,param2);
      }
      
      public function getFriendsLastLevelCompletedTimestamp(param1:Function, param2:Array) : void
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc3_:UserData = Utils.getOwnerUserData();
         if(_loc3_)
         {
            _loc4_ = this.getUserId();
            _loc5_ = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
            this.getFriendsPvEScores(_loc4_,param1);
         }
      }
      
      public function checkIfNickAvailable(param1:String, param2:Function, param3:Array, param4:Function = null, param5:Array = null) : void
      {
         var processedAlready:Boolean = false;
         var nick:String = param1;
         var onSuccessFunction:Function = param2;
         var onSuccessParams:Array = param3;
         var onFailedFunction:Function = param4;
         var onFailedParams:Array = param5;
         var req:ChangeUserDetailsRequest = smGameSparks.getRequestBuilder().createChangeUserDetailsRequest();
         req.setDisplayName(nick);
         req.setTimeoutSeconds(GS_TIMEOUT_SEC);
         req.setDurable(Config.DURABLE_CONNECTION);
         processedAlready = false;
         req.send(function(param1:ChangeUserDetailsResponse):void
         {
            if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
            {
               onDuplicatedResponseReceived("checkIfNickAvailable");
               return;
            }
            processedAlready = true;
            if(!param1.HasErrors())
            {
               onDDBBAccessedProcessResponse("users",true,"checkIfNickAvailable","","",null,onSuccessFunction,onSuccessParams,onFailedFunction,onFailedParams);
            }
            else
            {
               if(Boolean(param1.getErrors()) && param1.getErrors().hasOwnProperty("error"))
               {
                  Utils.setLogText(param1.getErrors().error);
               }
               onDDBBAccessedProcessResponse("users",false,"checkIfNickAvailable","","",null,onSuccessFunction,onSuccessParams,onFailedFunction,onFailedParams);
            }
         });
      }
      
      public function checkIfGuildNameAvailable(param1:String, param2:Function, param3:Array) : void
      {
         var _loc4_:String = "{\'guildName\': {\'$regex\' : \'(?i).*" + param1.toLowerCase() + ".*\'}}";
         this.searchInCollection("guilds",_loc4_,this.onGuildAvailabilityResponse,[param1,param2,param3]);
      }
      
      private function onGuildAvailabilityResponse(param1:Object, param2:String, param3:Function, param4:Array) : void
      {
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc5_:Boolean = true;
         if(param1 != null)
         {
            if((param1 as Array).length > 0)
            {
               _loc6_ = 0;
               while(_loc6_ < (param1 as Array).length)
               {
                  _loc7_ = param1[_loc6_].guildName;
                  if(String(_loc7_).toLowerCase() == param2.toLowerCase())
                  {
                     _loc5_ = false;
                  }
                  _loc6_++;
               }
            }
         }
         param4.unshift(param2);
         param4.unshift(_loc5_);
         param3.apply(null,param4);
      }
      
      public function addNotificationReceived(param1:String, param2:int, param3:String, param4:String, param5:String = null, param6:Function = null, param7:String = "") : void
      {
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         if(Boolean(InstanceMng.getApplication()) && Boolean(this.isUserLoggedIn()) && Boolean(this.getBackendUserProfile()))
         {
            _loc8_ = new Object();
            _loc8_.reqId = param1;
            _loc8_.uid = InstanceMng.getApplication().isKongregateVersion() ? "" : this.getUserId();
            if(param7 != "")
            {
               _loc8_.extId = param7;
            }
            _loc8_.senderFBId = param3;
            _loc8_.senderName = param4;
            _loc8_.type = param2;
            _loc8_.when = this.getRequestDateObject();
            if(param5)
            {
               _loc8_.data = param5;
            }
            _loc9_ = new Object();
            _loc9_.entityData = _loc8_;
            _loc9_.successFunction = param6;
            if(InstanceMng.getApplication().isKongregateVersion())
            {
               this.addReqInstanceToDB(_loc9_);
            }
            else
            {
               this.checkIfRequestExists(param1,this.addReqInstanceToDB,_loc9_);
            }
         }
      }
      
      private function checkIfRequestExists(param1:String, param2:Function, param3:Object) : void
      {
         var _loc4_:String = InstanceMng.getApplication().isKongregateVersion() ? "externalNotifications" : "notifications";
         this.searchInCollection(_loc4_,"{\'reqId\':\'" + param1 + "\'}",this.onCheckIfRequestExistsResponse,[param2,param3]);
      }
      
      private function onCheckIfRequestExistsResponse(param1:Object, param2:Function, param3:Object) : void
      {
         if(param1 == null || param1 != null && (param1 as Array).length == 0)
         {
            if(param2 != null)
            {
               param2(param3);
            }
         }
      }
      
      private function addReqInstanceToDB(param1:Object) : void
      {
         var _loc2_:String = InstanceMng.getApplication().isKongregateVersion() ? "externalNotifications" : "notifications";
         if(Boolean(param1) && Boolean(param1.entityData))
         {
            param1.entityData.when = this.getRequestDateObject();
         }
         var _loc3_:Function = Boolean(param1) && param1.successFunction != null ? param1.successFunction : null;
         var _loc4_:Array = Boolean(_loc3_ != null) && Boolean(param1) && Boolean(param1.entityData) && Boolean(param1.entityData.reqId) ? [param1.entityData.reqId] : null;
         this.createEntityInCollection(_loc2_,param1.entityData,_loc3_,_loc4_);
      }
      
      public function getNotifications(param1:Function = null) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(Config.smNotificationsSystemEnabled)
         {
            TweenMax.killDelayedCallsTo(this.getNotifications);
            _loc2_ = InstanceMng.getApplication().isKongregateVersion() ? "{\'extId\':\'" + InstanceMng.getUserDataMng().getOwnerUserData().getExtId() + "\'}" : "{}";
            if(_loc2_ == "{}")
            {
               _loc2_ = this.getOwnerUidQuery();
            }
            _loc3_ = InstanceMng.getApplication().isKongregateVersion() ? "externalNotifications" : "notifications";
            this.searchInCollection(_loc3_,_loc2_,this.onNotificationsReceived,[param1],null,null,true,99);
         }
      }
      
      private function onNotificationsReceived(param1:Object, param2:Function = null) : void
      {
         var _loc4_:Array = null;
         var _loc5_:UserData = null;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         FSDebug.debugTrace("[getNotifications] OK");
         var _loc3_:Array = param1 ? param1 as Array : null;
         if(_loc3_ != null && _loc3_.length > 0)
         {
            _loc5_ = Utils.getOwnerUserData();
            _loc6_ = _loc5_.isWaitingForMapToUnlock();
            _loc7_ = 0;
            while(_loc7_ < _loc3_.length)
            {
               if(!_loc6_ && _loc3_[_loc7_].type == NotificationMessage.NOTIFICATION_TYPE_UNLOCK_HELP_RECEIVED)
               {
                  this.removeRequestInstance(Utils.getDataId(_loc3_[_loc7_]));
               }
               else
               {
                  if(_loc4_ == null)
                  {
                     _loc4_ = new Array();
                  }
                  _loc4_.push(_loc3_[_loc7_]);
               }
               _loc7_++;
            }
         }
         if(InstanceMng.getUserDataMng() != null && InstanceMng.getUserDataMng().getOwnerUserData() != null)
         {
            InstanceMng.getUserDataMng().getOwnerUserData().setNotificationsReceived(_loc4_);
         }
         if(param2 != null)
         {
            param2();
         }
      }
      
      public function removeMapUnlockHelpNotifications(param1:Function) : void
      {
         var _loc2_:String = InstanceMng.getApplication().isKongregateVersion() ? "externalNotifications" : "notifications";
         var _loc3_:String = "{\'type\':" + NotificationMessage.NOTIFICATION_TYPE_UNLOCK_HELP_RECEIVED + "}";
         this.searchInCollection(_loc2_,_loc3_,param1);
      }
      
      public function removeRequestInstance(param1:String) : void
      {
         var _loc2_:String = InstanceMng.getApplication().isKongregateVersion() ? "externalNotifications" : "notifications";
         if(param1 != "-1")
         {
            this.deleteEntityInCollection(_loc2_,param1);
         }
      }
      
      public function checkIfMapHelpNotifExists(param1:String, param2:Function, param3:Object) : void
      {
         this.searchInCollection("mapsProgress","{\'senderFBId\':\'" + param1 + "\'}",this.onMapHelpNotificationsResponseReceived,[param2,param3]);
      }
      
      private function onMapHelpNotificationsResponseReceived(param1:Object, param2:Function, param3:Object) : void
      {
         if(param1 == null || param1 != null && (param1 as Array).length == 0)
         {
            if(param2 != null)
            {
               param2(param3);
            }
         }
      }
      
      public function addMapUnlockHelpInstanceToDB(param1:Object) : void
      {
         param1.when = this.getRequestDateObject();
         this.createEntityInCollection("mapsProgress",param1);
      }
      
      public function getMapUnlockHelps(param1:Function) : void
      {
         var _loc2_:String = null;
         if(this.isUserLoggedIn())
         {
            _loc2_ = this.getOwnerUidQuery();
            this.searchInCollection("mapsProgress",_loc2_,param1,null,InstanceMng.getCurrentScreen().showLoadingIcon,[false,false]);
         }
         else
         {
            InstanceMng.getCurrentScreen().showLoadingIcon(false,false);
         }
      }
      
      public function removeMapUnlockHelps() : void
      {
         this.deleteMultipleEntitiesInCollection("mapsProgress","",this.getOwnerUidQuery());
      }
      
      private function onMapUnlockHelpsReceivedDelete(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         FSDebug.debugTrace("[getMapUnlockHelps] - OK");
         if(param1 != null && this.isUserLoggedIn())
         {
            if(param1 != null && param1.length > 0)
            {
               _loc3_ = "";
               _loc2_ = 0;
               while(_loc2_ < param1.length)
               {
                  _loc3_ += param1[_loc2_];
                  _loc3_ += _loc2_ < param1.length - 1 ? "," : "";
                  _loc2_++;
               }
               if(_loc3_)
               {
                  this.deleteMultipleEntitiesInCollection("mapsProgress",_loc3_);
               }
            }
         }
      }
      
      public function getServerConfig(param1:Boolean = false, param2:Function = null, param3:Array = null, param4:Boolean = true) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var isInitialCall:Boolean = param1;
         var onSuccessFunction:Function = param2;
         var onSuccessParams:Array = param3;
         var checkGamePlayable:Boolean = param4;
         if(this.isUserLoggedIn())
         {
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("FS_GET_SERVER_CONFIG");
            if(isInitialCall)
            {
               req.setAttribute("INIT_CALL",1);
               req.setAttribute("PLATFORM",this.getPlatformId());
               req.setAttribute("v",Utils.getAppVersion());
               req.setAttribute("OS",Capabilities.os);
               req.setAttribute("DEVICE_INFO",Utils.getDeviceInfo());
            }
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               var _loc2_:Object = null;
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("getServerConfig");
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  _loc2_ = param1.getScriptData() ? param1.getScriptData().data : null;
                  onServerConfigACK(_loc2_,checkGamePlayable);
                  onDDBBAccessedProcessResponse("config",true,"getServerConfig","","",_loc2_,onSuccessFunction,onSuccessParams,null,null,true);
               }
               else
               {
                  onDDBBAccessedProcessResponse("config",false,"getServerConfig","","",null,onSuccessFunction,onSuccessParams,null,null,true);
               }
            });
         }
      }
      
      public function getMapRequests(param1:Boolean = false) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var reqAlsoDefs:Boolean = false;
         var isInitialCall:Boolean = param1;
         if(this.isUserLoggedIn())
         {
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("FS_GET_MAP_REQUESTS");
            if(isInitialCall)
            {
               reqAlsoDefs = ServerConnection.smServerReferralsDefs == null;
               req.setAttribute("INIT_CALL",1);
               req.setAttribute("GET_REFERRALS_DEFS",reqAlsoDefs ? 1 : 0);
            }
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               var _loc2_:Object = null;
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("getMapRequests");
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  _loc2_ = param1.getScriptData() ? param1.getScriptData().data : null;
                  onMapRequestsACK(_loc2_);
                  onDDBBAccessedProcessResponse("mapRequests",true,"getMapRequests","","",_loc2_,null,null,null,null,true);
               }
               else
               {
                  onDDBBAccessedProcessResponse("mapRequests",false,"getMapRequests","","",null,null,null,null,null,true);
               }
            });
         }
      }
      
      private function onMapRequestsACK(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(param1 != null)
         {
            _loc2_ = param1.hasOwnProperty("chatMutedPlayers") ? param1["chatMutedPlayers"] : null;
            if(_loc2_ != null)
            {
               InstanceMng.getUserDataMng().setMutedPlayersList(_loc2_);
               if(InstanceMng.getApplication().getGuildsPanel() != null)
               {
                  _loc6_ = 0;
                  while(_loc6_ < _loc2_.length)
                  {
                     InstanceMng.getApplication().getGuildsPanel().removeChatsFromPlayerId(_loc2_[_loc6_]["mutedPlayerId"]);
                     _loc6_++;
                  }
               }
            }
            _loc3_ = param1.hasOwnProperty("guildRequestsSent") ? param1["guildRequestsSent"] : null;
            if(_loc3_ != null && Boolean(InstanceMng.getGuildsMng()))
            {
               InstanceMng.getGuildsMng().onPlayerGuildRequestsArrived(_loc3_);
            }
            _loc4_ = param1.hasOwnProperty("referrals") ? param1["referrals"] : null;
            if(_loc4_ != null)
            {
               this.onReferralsReceived(_loc4_);
            }
            _loc5_ = param1.hasOwnProperty("rewardsCount") ? int(param1["rewardsCount"]) : 0;
            if(InstanceMng.getCurrentScreen() is FSMapScreen)
            {
               FSMapScreen(InstanceMng.getCurrentScreen()).onRewardsCount(_loc5_);
            }
         }
      }
      
      public function onReferralsReceived(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         if(param1)
         {
            _loc2_ = param1.hasOwnProperty("referralsDefs") ? param1["referralsDefs"] : null;
            _loc3_ = param1.hasOwnProperty("referrals") ? param1["referrals"] : null;
            if(_loc2_ != null && _loc2_.length > 0)
            {
               if(ServerConnection.smServerReferralsDefs == null)
               {
                  ServerConnection.smServerReferralsDefs = new Dictionary(true);
               }
               _loc4_ = 0;
               while(_loc4_ < _loc2_.length)
               {
                  ServerConnection.smServerReferralsDefs[int(_loc2_[_loc4_]["type"])] = _loc2_[_loc4_];
                  _loc4_++;
               }
            }
            if(_loc3_ != null)
            {
               ServerConnection.smServerPlayerReferrals = _loc3_;
               InstanceMng.getUserDataMng().getOwnerUserData().setReferrals(ServerConnection.smServerPlayerReferrals);
            }
            if(InstanceMng.getCurrentScreen() is FSMapScreen && FSMapScreen(InstanceMng.getCurrentScreen()).isFullyLoaded())
            {
               FSMapScreen(InstanceMng.getCurrentScreen()).onReferralsInfoReceived();
            }
         }
      }
      
      public function getProfilePicByExtId(param1:String, param2:Function = null) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var extId:String = param1;
         var onSuccessFunction:Function = param2;
         if(this.isUserLoggedIn())
         {
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("GET_PROFILE_PIC");
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            req.setAttribute("EXT_ID",extId);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               var _loc2_:Object = null;
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("getProfilePicByExtId");
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  _loc2_ = param1.getScriptData() ? param1.getScriptData().data : null;
                  onDDBBAccessedProcessResponse("externalAuthentication",true,"getProfilePicByExtId","","",_loc2_,onSuccessFunction,null,null,null,true);
               }
               else
               {
                  onDDBBAccessedProcessResponse("externalAuthentication",false,"getProfilePicByExtId","","",null,onSuccessFunction,null,null,null,true);
               }
            });
         }
      }
      
      private function onServerConfigACK(param1:Object, param2:Boolean = true) : void
      {
         var readDungeonsAndRaidsConfig:Function;
         var clientVersion:String = null;
         var serverVersion:String = null;
         var isRequired:Boolean = false;
         var isGamePlayableByConfig:Boolean = false;
         var gameNotPlayableReason:String = null;
         var platformId:String = null;
         var platformsAvailable:String = null;
         var data:Object = param1;
         var checkGamePlayable:Boolean = param2;
         if(data != null)
         {
            readDungeonsAndRaidsConfig = function():void
            {
               if(Utils.isBrowser())
               {
                  if(InstanceMng.getApplication().isFacebookBrowser())
                  {
                     Config.smDungeonsAvailables = Config.smServerConfig["dungeons_available_Facebook"];
                     Config.smRaidsAvailables = Config.smServerConfig["raids_available_Facebook"];
                  }
                  else if(InstanceMng.getApplication().isKongregateVersion())
                  {
                     Config.smDungeonsAvailables = Config.smServerConfig["dungeons_available_Kongregate"];
                     Config.smRaidsAvailables = Config.smServerConfig["raids_available_Kongregate"];
                  }
               }
               else if(Utils.isMobile())
               {
                  if(Utils.isIOS())
                  {
                     Config.smDungeonsAvailables = Config.smServerConfig["dungeons_available_iOS"];
                     Config.smRaidsAvailables = Config.smServerConfig["raids_available_iOS"];
                  }
                  else if(Utils.isAndroid())
                  {
                     Config.smDungeonsAvailables = Config.smServerConfig["dungeons_available_Android"];
                     Config.smRaidsAvailables = Config.smServerConfig["raids_available_Android"];
                  }
               }
               else if(Utils.isDesktop())
               {
                  Config.smDungeonsAvailables = Config.smServerConfig["dungeons_available_Steam"];
                  Config.smRaidsAvailables = Config.smServerConfig["raids_available_Steam"];
               }
            };
            Config.smServerConfig = data;
            TweenMax.killDelayedCallsTo(this.gamePlayableTimeout);
            if(Config.smServerConfig != null)
            {
               if(Config.smDayKey == null)
               {
                  Config.smDayKey = new FSNumber();
               }
               if(Config.smWeekNumber == null)
               {
                  Config.smWeekNumber = new FSNumber();
               }
               if(Config.smMonthNumber == null)
               {
                  Config.smMonthNumber = new FSNumber();
               }
               if(Config.smYearNumber == null)
               {
                  Config.smYearNumber = new FSNumber();
               }
               Config.smPvPBotsEnabled = Config.smServerConfig["pvp_bots"];
               Config.smPvPHasFriendlyPvP = Config.smServerConfig["pvp_allowFriendlyPvP"];
               Config.smBattleSendCombatLog = Config.smServerConfig["misc_sendCombatLog"];
               Config.smDefaultDeckValueOffset = Config.smServerConfig["pvp_defaultCVOffset"];
               Config.smIncreaseDeckValueOffset = Config.smServerConfig["pvp_CVIncreaseOffset"];
               Config.smDayKey.value = Config.smServerConfig["misc_dayKey"];
               Config.smWeekNumber.value = Config.smServerConfig["misc_weekNumber"];
               Config.smMonthNumber.value = Config.smServerConfig["misc_month"];
               Config.smYearNumber.value = Config.smServerConfig["misc_year"];
               clientVersion = Utils.getAppVersion();
               serverVersion = Config.smServerConfig["misc_v_" + this.getPlatformId()];
               isRequired = Boolean(Config.smServerConfig["misc_updateRequired"]);
               isGamePlayableByConfig = Boolean(Config.smServerConfig["misc_gamePlayable"]);
               gameNotPlayableReason = Config.smServerConfig["misc_gameNotPlayableReason"];
               RaidsMng.smWeeklySeasonIndex = Config.smServerConfig["raids_weeklySeasonIndex"];
               RaidsMng.smWeeklySeasonStartingTimeMS = Config.smServerConfig["raids_weeklySeasonStartingTimeMS"];
               RaidsMng.smWeeklySeasonEndingTimeMS = Config.smServerConfig["raids_weeklySeasonEndingTimeMS"];
               Main.smGamePlayable = isGamePlayableByConfig && (clientVersion >= serverVersion || !isRequired);
               readDungeonsAndRaidsConfig();
               GuildsMng.smMaxBoardMessages = Config.smServerConfig["guilds_maxBoardMessages"];
               GuildsMng.smMaxMembers = Config.smServerConfig["guilds_maxMembers"];
               GuildsMng.smMaxGuildDescriptionLength = Config.smServerConfig["guilds_maxDescLength"];
               GuildsMng.smWeeklyEventType = Config.smServerConfig["guilds_weeklyEventType"];
               GuildsMng.smWeeklyEventsEndingTimeMS = Number(Config.smServerConfig["guilds_weeklyEventsEndingTimeMS"]);
               GuildsMng.smWeeklyEventsStartingTimeMS = Number(Config.smServerConfig["guilds_weeklyEventsStartingTimeMS"]);
               GuildsMng.smGoldCost = Config.smServerConfig["guilds_goldCost"];
               GuildsMng.smPvPWonPoints = Config.smServerConfig["guilds_PvPWonPoints"];
               GuildsMng.smDungeonEasyCompletedPoints = Config.smServerConfig["guilds_dungeonEasyCompletedPoints"];
               GuildsMng.smDungeonMedCompletedPoints = Config.smServerConfig["guilds_dungeonMedCompletedPoints"];
               GuildsMng.smDungeonHardCompletedPoints = Config.smServerConfig["guilds_dungeonHardCompletedPoints"];
               GuildsMng.smDungeonHardCompletedPoints = Config.smServerConfig["guilds_dungeonExpertCompletedPoints"];
               GuildsMng.smWeeklySeasonIndex = Config.smServerConfig["guilds_weeklySeasonIndex"];
               GuildsMng.smWeeklySeasonStartingTimeMS = Config.smServerConfig["guilds_weeklySeasonStartingTimeMS"];
               GuildsMng.smWeeklySeasonEndingTimeMS = Config.smServerConfig["guilds_weeklySeasonEndingTimeMS"];
               GuildsMng.smRaidSPFactor = Config.smServerConfig["raids_SPFactor"];
               GuildsMng.smRaidMPFactor = Config.smServerConfig["raids_MPFactor"];
               Config.smPvPTurnTime = Config.smServerConfig["pvp_turnTime"];
               Config.smPvPWaitingOpponentMoveTime = Config.smServerConfig["pvp_opponentWaitingTime"];
               PvPConnectionMng.smPvPOpponentFoundTime = Config.smServerConfig["pvp_opponentFoundTime"];
               PvPConnectionMng.smPvPWaitingForOpponentTime = Config.smServerConfig["pvp_waitingForOpponentFoundTime"];
               PvPConnectionMng.smPvPMinTurnsToBanSurrender = Config.smServerConfig["pvpMinTurnsToBanSurrender"];
               PvPConnectionMng.smPvPBannedCards = Config.smServerConfig["pvp_BannedCards"];
               PvPConnectionMng.smLeaguesInformation = Config.smServerConfig["pvp_leagues"];
               Config.smReferralGoldPerRecruitment = Config.smServerConfig["referral_gold"];
               Config.smHackCheatAttemptAutoBan = Config.smServerConfig.hasOwnProperty("misc_hackAttemptAutoBan") ? Config.smServerConfig["misc_hackAttemptAutoBan"] == 1 : false;
               Config.smShopManualOffer = Config.smServerConfig.hasOwnProperty("shop_manualOffer") ? Object(Config.smServerConfig["shop_manualOffer"]) : null;
               platformId = InstanceMng.getServerConnection().getPlatformId();
               platformsAvailable = Config.smServerConfig["pvp_platformsAvailable_" + platformId] ? String(Config.smServerConfig["pvp_platformsAvailable_" + platformId]) : "";
               Config.smPvPPlatformsAvailable = platformsAvailable != "" ? platformsAvailable.split(",") : null;
               if(Config.smServerConfig.hasOwnProperty("releaseNotes"))
               {
                  this.manageReleaseNotes(Config.smServerConfig["releaseNotes"]);
               }
               if(Config.smServerConfig.hasOwnProperty("news"))
               {
                  this.manageNews(Config.smServerConfig["news"]);
               }
               if(checkGamePlayable)
               {
                  this.onConfigACKCheckIfGamePlayable(serverVersion,clientVersion,isGamePlayableByConfig,gameNotPlayableReason);
               }
            }
            this.manageDailyKeyReceived();
            this.handleBattlePassValidation();
         }
      }
      
      private function manageReleaseNotes(param1:Object) : void
      {
         var _loc2_:String = param1 != null ? param1.msg : null;
         if(_loc2_ != null && _loc2_ != "")
         {
            _loc2_ = "v" + param1.v + "\n\n" + _loc2_;
            Config.smReleaseNotesInfo = _loc2_;
         }
      }
      
      private function manageNews(param1:Object) : void
      {
         param1 = param1 != null ? param1 : null;
         if(param1 != null)
         {
            Config.smNews = new Object();
            Config.smNews["newsTitle"] = param1.newsTitle;
            Config.smNews["newsText"] = param1.newsText;
            Config.smNews["visible"] = param1.visible;
            Config.smNews["type"] = param1.type;
            Config.smNews["expirationTimeMS"] = param1.expirationTimeMS;
            Config.smNews["url"] = param1.hasOwnProperty("url") ? param1.url : "";
         }
      }
      
      public function getReferralsServerInfo(param1:Boolean, param2:Function = null, param3:Array = null) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var reqAlsoDefs:Boolean = param1;
         var onSuccessFunction:Function = param2;
         var onSuccessParams:Array = param3;
         if(this.isUserLoggedIn())
         {
            req = new LogEventRequest(smGameSparks);
            req.setAttribute("REQUEST_DEFS",int(reqAlsoDefs));
            req.setEventKey("REFERRAL_REFRESH_PLAYERS");
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               var _loc2_:Object = null;
               var _loc3_:Object = null;
               var _loc4_:Object = null;
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("getReferralsServerInfo");
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  _loc2_ = param1.getScriptData() ? param1.getScriptData().referrals : null;
                  _loc3_ = param1.getScriptData() ? param1.getScriptData().referralsDefs : null;
                  _loc4_ = {
                     "referrals":_loc2_,
                     "referralsDefs":_loc3_
                  };
                  onDDBBAccessedProcessResponse("referralsDefs",true,"getReferralsServerInfo","","",_loc4_,onSuccessFunction,onSuccessParams,null,null,true);
               }
               else
               {
                  onDDBBAccessedProcessResponse("referralsDefs",false,"getReferralsServerInfo","","",null,onSuccessFunction,onSuccessParams,null,null,true);
               }
            });
         }
      }
      
      public function getReleaseNotes(param1:Function = null) : void
      {
         var _loc2_:String = "{\'$and\':[{\'platform\':\'" + this.getPlatformId() + "\'},{\'v\':\'" + Utils.getAppVersion() + "\'}]}";
         this.searchInCollection("releaseNotes",_loc2_,param1);
      }
      
      public function createGuildInstance(param1:String, param2:Number, param3:String, param4:String, param5:Function, param6:Function, param7:String = "", param8:int = 0) : void
      {
         var req:CreateTeamRequest;
         var processedAlready:Boolean = false;
         var name:String = param1;
         var createdTimeMs:Number = param2;
         var emblemBG:String = param3;
         var emblemFG:String = param4;
         var successFunction:Function = param5;
         var errorFunction:Function = param6;
         var guildDesc:String = param7;
         var accessType:int = param8;
         var entityData:Object = new Object();
         entityData.accessType = accessType;
         entityData.emblemBG = emblemBG;
         entityData.emblemFG = emblemFG;
         req = smGameSparks.getRequestBuilder().createCreateTeamRequest();
         req.setTeamName(name);
         req.setTeamType("FS_GUILD");
         req.setScriptData(entityData);
         req.setTimeoutSeconds(GS_TIMEOUT_SEC);
         req.setDurable(Config.DURABLE_CONNECTION);
         processedAlready = false;
         req.send(function(param1:CreateTeamResponse):void
         {
            var _loc2_:String = null;
            if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
            {
               onDuplicatedResponseReceived("createGuildInstance");
               return;
            }
            processedAlready = true;
            if(!param1.HasErrors())
            {
               _loc2_ = param1.getTeamId();
               successFunction(_loc2_);
            }
            else
            {
               errorFunction();
            }
         });
      }
      
      public function getGuildInfo(param1:String, param2:Function, param3:Function = null, param4:Object = null) : void
      {
         var gsOnGuildInfoReceived:Function;
         var req:GetTeamRequest;
         var obj:Object = null;
         var processedAlready:Boolean = false;
         var id:String = param1;
         var successFunction:Function = param2;
         var onFailedFunction:Function = param3;
         var guildObj:Object = param4;
         FSDebug.debugTrace("Getting Guild info");
         gsOnGuildInfoReceived = function gsOnGuildInfoReceived(param1:GetTeamResponse):void
         {
            var _loc2_:Object = null;
            var _loc3_:Array = null;
            var _loc4_:Vector.<Player> = null;
            var _loc5_:String = null;
            var _loc6_:String = null;
            var _loc7_:int = 0;
            var _loc8_:String = null;
            var _loc9_:String = null;
            var _loc10_:Number = NaN;
            var _loc11_:Number = NaN;
            var _loc12_:String = null;
            var _loc13_:Object = null;
            var _loc14_:int = 0;
            var _loc15_:Player = null;
            if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
            {
               onDuplicatedResponseReceived("getGuildInfo");
               return;
            }
            processedAlready = true;
            if(!param1.HasErrors())
            {
               if(param1.getScriptData())
               {
                  _loc2_ = param1.getScriptData().extraData;
                  _loc3_ = param1.getTeams()[0].getAttribute("members") as Array;
                  _loc4_ = new Vector.<Player>();
                  if(Boolean(_loc3_) && _loc3_.length > 0)
                  {
                     _loc14_ = 0;
                     while(_loc14_ < _loc3_.length)
                     {
                        obj = _loc3_[_loc14_].scriptData.profile;
                        if(obj)
                        {
                           if(!obj.hasOwnProperty("guildRank"))
                           {
                              obj["guildRank"] = GuildsMng.RANK_MEMBER;
                           }
                           if(!obj.hasOwnProperty("weeklyTotalScore"))
                           {
                              obj["weeklyTotalScore"] = 0;
                           }
                           if(!obj.hasOwnProperty("globalTotalScore"))
                           {
                              obj["globalTotalScore"] = 0;
                           }
                        }
                        _loc15_ = new Player(_loc3_[_loc14_]);
                        _loc4_.push(_loc15_);
                        _loc14_++;
                     }
                  }
                  _loc5_ = param1.getTeams()[0].getTeamId();
                  _loc6_ = String(param1.getTeams()[0].getAttribute("teamName"));
                  _loc7_ = int(_loc2_.accessType);
                  _loc8_ = _loc2_.emblemFG;
                  _loc9_ = _loc2_.emblemBG;
                  _loc10_ = Number(_loc2_.lastActivityDateMS);
                  _loc11_ = Number(_loc2_.creationDateMS);
                  _loc12_ = convertMembersListToString(_loc4_);
                  _loc13_ = new Object();
                  _loc13_._id = new Object();
                  _loc13_._id.$oid = _loc5_;
                  _loc13_.creationDateMS = _loc11_;
                  _loc13_.lastActivityDateMS = _loc10_;
                  _loc13_.members = _loc12_;
                  _loc13_.leaderId = param1.getTeams()[0].getOwner().getId();
                  _loc13_.accessType = _loc7_;
                  _loc13_.emblemFG = _loc8_;
                  _loc13_.emblemBG = _loc9_;
                  _loc13_.name = _loc6_;
                  _loc13_.activeMembersData = _loc4_;
                  _loc13_.weeklyPvPScore = _loc2_.weeklyPvPScore;
                  _loc13_.weeklyDungeonsScore = _loc2_.weeklyDungeonsScore;
                  _loc13_.weeklyRaidsScore = _loc2_.weeklyRaidsScore;
                  _loc13_.weeklyTotalScore = _loc2_.weeklyTotalScore;
                  _loc13_.globalPvPScore = _loc2_.globalPvPScore;
                  _loc13_.globalDungeonsScore = _loc2_.globalDungeonsScore;
                  _loc13_.globalRaidsScore = _loc2_.globalRaidsScore;
                  _loc13_.globalTotalScore = _loc2_.globalTotalScore;
                  _loc13_.guildObjId = _loc2_._id.$oid;
                  _loc13_.leaderTempId = _loc2_.leaderTempId;
                  _loc13_.leaderTempCreationTime = _loc2_.leaderTempCreationTime;
                  _loc13_.description = _loc2_.description;
                  guildObj = InstanceMng.getGuildsMng().createGuildByServerInfo(_loc13_);
                  successFunction(guildObj);
               }
            }
            else if(Boolean(param1.getErrors()) && Boolean(param1.getErrors().hasOwnProperty("error")) && param1.getErrors().error != "timeout")
            {
               FSTracker.trackMiscAction(FSTracker.CATEGORY_GUILDS,"ERROR_GETTING_GUILD_INFO_LEAVING",{"error":param1.getErrors().error});
            }
         };
         req = smGameSparks.getRequestBuilder().createGetTeamRequest();
         req.setTeamId(id);
         req.setTeamType("FS_GUILD");
         req.setTimeoutSeconds(GS_TIMEOUT_SEC);
         req.setDurable(Config.DURABLE_CONNECTION);
         processedAlready = false;
         req.send(gsOnGuildInfoReceived);
      }
      
      private function convertMembersListToString(param1:Vector.<Player>) : String
      {
         var _loc2_:String = "";
         var _loc3_:int = 0;
         if(param1)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               _loc2_ += param1[_loc3_].getId();
               _loc2_ += _loc3_ < param1.length - 1 ? "," : "";
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      public function getGuildMembers(param1:String, param2:Function, param3:Function = null) : void
      {
         var _loc4_:String = "{\'$and\':[{\'guildId\':\'" + param1 + "\'},{\'active\':1}]}";
         this.searchInCollection("guildMembers",_loc4_,param2,null,param3,null,true,0,"{\'rank\':1}");
      }
      
      public function getGuilds(param1:Function, param2:Function = null, param3:String = "", param4:Boolean = false, param5:String = "", param6:Boolean = false) : void
      {
         var _loc7_:String = param4 ? "{\'membersAmount\':{\'$lt\':" + GuildsMng.smMaxMembers + "}}" : "{}";
         var _loc8_:String = param5 == "" ? _loc7_ : "{\'guildName\': {\'$regex\' : \'(?i).*" + param5 + ".*\'}}";
         var _loc9_:int = param6 ? 15 : 15;
         this.searchInCollection("guilds",_loc8_,this.onGetGuildsInfoReceived,[param1,param2,param6,param4],param2,null,true,_loc9_,param3);
      }
      
      private function onGetGuildsInfoReceived(param1:Object, param2:Function, param3:Function = null, param4:Boolean = false, param5:Boolean = false) : void
      {
         var onGuildMembersInfoResponse:Function = null;
         var j:int = 0;
         var guildsArr:Array = null;
         var guildsAmount:int = 0;
         var globalCount:int = 0;
         var guildCurrentWeekSeason:int = 0;
         var query:String = null;
         var data:Object = param1;
         var successFunction:Function = param2;
         var onFailedFunction:Function = param3;
         var requestMembersData:Boolean = param4;
         var skipFullGuilds:Boolean = param5;
         onGuildMembersInfoResponse = function(param1:Object):void
         {
            var _loc7_:String = null;
            var _loc2_:Array = param1 as Array;
            var _loc3_:String = "";
            var _loc4_:String = "";
            var _loc5_:int = 0;
            var _loc6_:int = 0;
            ++globalCount;
            if(_loc2_)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc2_.length)
               {
                  _loc4_ = _loc2_[_loc5_].guildId;
                  _loc3_ += _loc2_[_loc5_].playerId + ",";
                  _loc5_++;
               }
            }
            _loc6_ = 0;
            while(_loc6_ < (data as Array).length)
            {
               _loc7_ = data[_loc6_].guildId;
               if(_loc7_ == _loc4_)
               {
                  data[_loc6_].members = _loc3_;
                  data[_loc6_].activeMembersData = param1;
               }
               _loc6_++;
            }
            if(skipFullGuilds)
            {
               _loc6_ = 0;
               while(_loc6_ < (data as Array).length)
               {
                  if(Boolean(String(data[_loc6_].members)) && String(data[_loc6_].members).split(",").length > GuildsMng.smMaxMembers)
                  {
                     data.splice(_loc6_,1);
                  }
                  _loc6_++;
               }
            }
            if(globalCount == guildsAmount)
            {
               successFunction(data);
            }
         };
         if(data != null && (data as Array).length > 0)
         {
            j = 0;
            guildsArr = data as Array;
            guildsAmount = guildsArr ? int(guildsArr.length) : 0;
            globalCount = 0;
            guildCurrentWeekSeason = -1;
            j = 0;
            while(j < guildsArr.length)
            {
               if(requestMembersData)
               {
                  query = "{\'guildId\':\'" + guildsArr[j].guildId + "\'}";
                  this.searchInCollection("guildMembers",query,onGuildMembersInfoResponse,null,onFailedFunction);
               }
               j++;
            }
            if(!requestMembersData)
            {
               successFunction(data);
            }
         }
         else
         {
            successFunction(null);
         }
      }
      
      public function deleteReward(param1:String, param2:Function = null, param3:Array = null, param4:Function = null, param5:Array = null) : void
      {
         this.deleteEntityInCollection("rewards",param1,param2,param3,param4,param5);
      }
      
      public function getGuildRequests(param1:String, param2:Function, param3:Function = null) : void
      {
         var _loc4_:String = "{\'guildId\':\'" + param1 + "\'}";
         this.searchInCollection("guildRequests",_loc4_,param2,null,param3,null,true,25);
      }
      
      public function getGuildRequestsCount(param1:String, param2:Function, param3:Function = null) : void
      {
         var _loc4_:String = "{\'guildId\':\'" + param1 + "\'}";
         this.countInCollection("guildRequests",_loc4_,param2,null,param3);
      }
      
      public function refreshPlayerGuildRequestsSent(param1:Function) : void
      {
         var _loc2_:String = "{\'playerId\':\'" + this.getUserId() + "\'}";
         this.searchInCollection("guildRequests",_loc2_,param1);
      }
      
      public function createGuildRequest(param1:String, param2:Number, param3:Function, param4:Function) : void
      {
         var _loc5_:Object = new Object();
         _loc5_.playerId = this.getUserId();
         _loc5_.guildId = param1;
         _loc5_.currentDateMS = param2;
         _loc5_.when = this.getRequestDateObject();
         this.createEntityInCollection("guildRequests",_loc5_,param3,null,param4,null,true);
      }
      
      public function deleteGuildRequest(param1:String) : void
      {
         this.deleteEntityInCollection("guildRequests",param1);
      }
      
      public function getGuildRequest(param1:String, param2:Function, param3:Function) : void
      {
         this.searchInCollectionById("guildRequests",param1,param2,null,param3,null,false);
      }
      
      public function createGuildEvent(param1:String, param2:int, param3:String, param4:String, param5:int, param6:int, param7:String = null) : void
      {
         FSDebug.debugTrace("Creating guild event...");
         var _loc8_:Object = new Object();
         _loc8_ = this.addCommonEntityAttributes(_loc8_);
         _loc8_.guildId = param1;
         _loc8_.eventType = param2;
         _loc8_.playerInvolvedId = param3;
         _loc8_.playerInvolvedNick = param4;
         _loc8_.playerInvolvedRank = param5;
         _loc8_.playerInvolvedGuildRank = param6;
         if(param7)
         {
            _loc8_.data = param7;
         }
         this.createEntityInCollection("guildsEvents",_loc8_);
      }
      
      public function refreshGuildEvents(param1:Function) : void
      {
         var _loc2_:String = null;
         if(!Root.assets.isLoading)
         {
            _loc2_ = "{\'guildId\':\'" + InstanceMng.getUserDataMng().getOwnerUserData().getGuildId() + "\'}";
            this.searchInCollection("guildsEvents",_loc2_,this.onGuildEventsReceived,[param1],null,null,true,GuildsMng.smMaxBoardMessages,"{\'when\':-1}");
         }
      }
      
      private function onGuildEventsReceived(param1:Object, param2:Function) : void
      {
         param2(param1 as Array);
      }
      
      public function deleteAllInstancesOfDatabase(param1:String, param2:String = "{}", param3:Function = null) : void
      {
         if(this.isUserLoggedIn())
         {
            if(param2 == "{}")
            {
               this.deleteMultipleEntitiesInCollection(param1,"","{}",true,param3);
            }
            else
            {
               this.searchInCollection(param1,param2,this.onCollectionQueriesResponse,[param1,param3]);
            }
         }
      }
      
      private function onCollectionQueriesResponse(param1:Object, param2:String, param3:Function = null) : void
      {
         var _loc5_:int = 0;
         var _loc4_:String = "";
         if(Boolean(param1) && param1.length > 0)
         {
            _loc5_ = 0;
            while(_loc5_ < param1.length)
            {
               _loc4_ += Utils.getDataId(param1[_loc5_]);
               _loc4_ = _loc4_ + (_loc5_ < param1.length - 1 ? "," : "");
               _loc5_++;
            }
         }
         this.deleteMultipleEntitiesInCollection(param2,_loc4_,"{}",false,param3);
      }
      
      public function deleteGuildEvent(param1:String, param2:Function = null, param3:Function = null) : void
      {
         this.deleteEntityInCollection("guildsEvents",param1,param2,null,param3);
      }
      
      public function createGuildChatInstance(param1:String) : void
      {
         var req:SendTeamChatMessageRequest = null;
         var processedAlready:Boolean = false;
         var message:String = param1;
         if(InstanceMng.getUserDataMng().getOwnerUserData().hasGuild())
         {
            req = smGameSparks.getRequestBuilder().createSendTeamChatMessageRequest();
            req.setMessage(message);
            req.setTeamId(InstanceMng.getUserDataMng().getOwnerUserData().getGuildId());
            req.setTeamType("FS_GUILD");
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:SendTeamChatMessageResponse):void
            {
               var _loc2_:String = null;
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("createGuildChatInstance");
                  return;
               }
               processedAlready = true;
               if(param1.HasErrors() && Boolean(param1))
               {
                  if(Boolean(param1.getErrors()) && param1.getErrors().hasOwnProperty("error"))
                  {
                     _loc2_ = Boolean(param1.getErrors()) && param1.getErrors() != null ? param1.getErrors().error : "";
                     Utils.setLogText(_loc2_);
                  }
               }
            });
         }
      }
      
      public function createGeneralChatInstance(param1:String) : void
      {
         var processedAlready:Boolean = false;
         var message:String = param1;
         var req:SendTeamChatMessageRequest = smGameSparks.getRequestBuilder().createSendTeamChatMessageRequest();
         req.setMessage(message);
         req.setTeamId("GENERAL_CHAT");
         req.setTeamType("GENERAL_CHAT");
         req.setTimeoutSeconds(GS_TIMEOUT_SEC);
         req.setDurable(Config.DURABLE_CONNECTION);
         processedAlready = false;
         req.send(function(param1:SendTeamChatMessageResponse):void
         {
            var _loc2_:String = null;
            if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
            {
               onDuplicatedResponseReceived("createGeneralChatInstance");
               return;
            }
            processedAlready = true;
            if(param1.HasErrors())
            {
               _loc2_ = Boolean(param1.getErrors()) && param1.getErrors() != null ? param1.getErrors().error : "";
               Utils.setLogText(_loc2_);
            }
         });
      }
      
      private function onGeneralChatsReceived(param1:Object, param2:Function, param3:Boolean = false) : void
      {
         if(param1)
         {
            (param1 as Array).reverse();
         }
         param2(param1 as Array);
      }
      
      public function muteGeneralPlayerChat(param1:String, param2:Function = null, param3:Function = null) : void
      {
         var _loc4_:Object = new Object();
         _loc4_ = this.addCommonEntityAttributes(_loc4_);
         _loc4_.mutedPlayerId = param1;
         this.createEntityInCollection("chatMutedPlayers",_loc4_,param2,null,param3);
      }
      
      public function unmuteGeneralPlayerChat(param1:String, param2:Function = null, param3:Function = null) : void
      {
         var onChatMutedPlayerFound:Function = null;
         var mutedPlayerId:String = param1;
         var onSuccessFunction:Function = param2;
         var onFailFunction:Function = param3;
         onChatMutedPlayerFound = function(param1:Object):void
         {
            var _loc2_:Array = null;
            var _loc3_:String = null;
            if(param1 != null)
            {
               _loc2_ = param1 as Array;
               _loc3_ = _loc2_[0]._id.$oid;
               deleteEntityInCollection("chatMutedPlayers",_loc3_,onSuccessFunction,null,onFailFunction);
            }
         };
         var ownerQuery:String = this.getOwnerUidQuery();
         var query:String = "{\'$and\':[{\'mutedPlayerId\':\'" + mutedPlayerId + "\'}," + ownerQuery + "]}";
         this.searchInCollection("chatMutedPlayers",query,onChatMutedPlayerFound);
      }
      
      public function getGeneralChatMutedPlayers(param1:Function) : void
      {
         this.searchInCollection("chatMutedPlayers",this.getOwnerUidQuery(),param1);
      }
      
      private function onGuildGlobalPosResponse(param1:Object, param2:String, param3:Function) : void
      {
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc4_:int = -1;
         if(param1)
         {
            _loc6_ = param1 as Array;
            _loc5_ = 0;
            while(_loc5_ < _loc6_.length)
            {
               if(_loc6_[_loc5_].guildId == param2)
               {
                  _loc4_ = _loc5_ + 1;
               }
               _loc5_++;
            }
         }
         param3(_loc4_);
      }
      
      private function onGuildsWeeklyPosResponse(param1:Object, param2:String, param3:Function) : void
      {
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc4_:int = -1;
         if(param1)
         {
            _loc6_ = param1 as Array;
            _loc5_ = 0;
            while(_loc5_ < _loc6_.length)
            {
               if(_loc6_[_loc5_].guildId == param2)
               {
                  _loc4_ = _loc5_ + 1;
               }
               _loc5_++;
            }
         }
         param3(_loc4_);
      }
      
      public function createRestorationHistoryInstance(param1:String) : void
      {
         var _loc2_:Object = null;
         if(this.isUserLoggedIn())
         {
            _loc2_ = new Object();
            _loc2_ = this.addCommonEntityAttributes(_loc2_);
            _loc2_.prodId = param1;
            this.createEntityInCollection("restoresHistory",_loc2_);
         }
      }
      
      public function createUncaughtErrInstance(param1:int, param2:String, param3:String, param4:Boolean, param5:Object = null) : void
      {
         if(param5 == null)
         {
            param5 = new Object();
            param5 = this.addCommonEntityAttributes(param5);
            param5.errId = param1 ? param1.toString() : "";
            param5.errStackTrace = param2;
            param5.screen = param3;
            param5.online = param4 ? param4.toString() : "";
            param5.difficulty = InstanceMng.getUserDataMng().getOwnerUserData() ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty() : UserDataMng.DIFFICULTY_EASY;
            param5.level = InstanceMng.getUserDataMng().getOwnerUserData() ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelIndex(int(param5.difficulty)) : 1;
         }
         if(this.isUserLoggedIn() && Boolean(this.getBackendUserProfile()))
         {
            this.createEntityInCollection("uncaughtErrors",param5);
         }
         else
         {
            FSDebug.debugTrace("Couldn\'t add uncaught error, trying in a few seconds");
            setTimeout(this.createUncaughtErrInstance,10000,param1,param2,param3,param4,param5);
         }
      }
      
      public function getUserProfilesByIdsVector(param1:Vector.<String>, param2:Function) : void
      {
         var onUserProfilesByIdsVectorResponse:Function = null;
         var i:int = 0;
         var membersAmount:int = 0;
         var returnValue:Vector.<UserData> = null;
         var members:Vector.<String> = param1;
         var successFunction:Function = param2;
         onUserProfilesByIdsVectorResponse = function(param1:UserData):void
         {
            if(returnValue == null)
            {
               returnValue = new Vector.<UserData>();
            }
            returnValue.push(param1);
            if(Boolean(returnValue) && returnValue.length == membersAmount)
            {
               returnValue.sort(DictionaryUtils.sortGuildMembersTotalScore);
               returnValue.sort(DictionaryUtils.sortGuildMembersWeeklyScore);
               successFunction(returnValue);
            }
         };
         if(members)
         {
            membersAmount = int(members.length);
            i = 0;
            while(i < membersAmount)
            {
               this.getUserProfileByUID(members[i],onUserProfilesByIdsVectorResponse,null);
               i++;
            }
         }
      }
      
      public function getUserProfileByUID(param1:String, param2:Function, param3:Object = null, param4:Object = null) : void
      {
         this.searchUser("",param1,this.getUserDataByUserProfile,[param2,param3,param4]);
      }
      
      public function getUserDataByUserProfile(param1:Object, param2:Function = null, param3:Object = null, param4:Object = null) : UserData
      {
         var _loc6_:Boolean = false;
         var _loc7_:Number = NaN;
         var _loc5_:UserData = null;
         if(param1 != null)
         {
            param1 = param1 is Player && Player(param1).getScriptData() != null ? Player(param1).getScriptData().profile : param1;
            if(Boolean(param1) && Boolean(InstanceMng.getUserDataMng()))
            {
               _loc5_ = InstanceMng.getUserDataMng().buildUserDataFromProfile(param1,false);
               if(_loc5_)
               {
                  if(!param1.hasOwnProperty("currentDateMS") || param1.hasOwnProperty("currentDateMS") && (isNaN(param1.currentDateMS) || param1.currentDateMS == 0))
                  {
                     _loc6_ = param1 is Player ? Player(param1).getOnline() : false;
                     _loc7_ = _loc6_ ? smServerTimeMS : NaN;
                     _loc5_.setCurrentDateMS(_loc7_);
                  }
                  if(param2 != null)
                  {
                     if(param4 != null)
                     {
                        param2(_loc5_,param4);
                     }
                     else
                     {
                        param2(_loc5_);
                     }
                  }
               }
            }
         }
         return _loc5_;
      }
      
      public function refreshSessionOnActivate() : void
      {
         FSDebug.debugTrace("refreshing session on activate");
         if(!this.isUserLoggedIn())
         {
            this.onRefreshSessionAfterActivateFails();
         }
         else
         {
            FSDebug.debugTrace("Running SERVER_TIME script (refresh handler)");
            this.runScript("SERVER_TIME",null,this.onRefreshSessionAfterActivateResponse,null,this.onRefreshSessionAfterActivateFails);
         }
      }
      
      private function onRefreshSessionAfterActivateResponse(param1:Object) : void
      {
         FSDebug.debugTrace("[refreshSessionOnActivate] - Ok USER ONLINE: " + param1);
         Utils.removeLog();
         this.mRefreshedSessionsAttemtps = 0;
         if(InstanceMng.getApplication())
         {
            this.onServerTimeACK(param1);
         }
      }
      
      private function onRefreshSessionAfterActivateFails() : void
      {
         var _loc1_:Popup = null;
         FSDebug.debugTrace("User not logged in, handling on activate refresh failed handler | refreshAttempts: " + this.mRefreshedSessionsAttemtps);
         ++this.mRefreshedSessionsAttemtps;
         if(this.mRefreshedSessionsAttemtps > 2)
         {
            _loc1_ = InstanceMng.getPopupMng().getPopupShown();
            if(_loc1_ == null || _loc1_ != null && !(_loc1_ is PopupError))
            {
               InstanceMng.getPopupMng().openErrorPopup(TextManager.getText("TID_CONNECTION_LOST"),true,true);
            }
         }
         else
         {
            this.refreshSessionOnActivate();
         }
      }
      
      public function addUserToBlackList(param1:Boolean = false, param2:Object = null, param3:String = null) : void
      {
         var _loc8_:String = null;
         var _loc9_:String = null;
         if(Boolean(InstanceMng.getUserDataMng() != null) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) && !param1)
         {
            InstanceMng.getUserDataMng().getOwnerUserData().setInBlackList(true);
         }
         var _loc4_:Object = new Object();
         _loc4_ = this.addCommonEntityAttributes(_loc4_);
         _loc4_.addedBy = "AUTO-BANNED";
         _loc4_.purchasesAmount = 1;
         if(param3 != null && param3 != "")
         {
            _loc4_.reason = param3;
         }
         if(param2 != null)
         {
            _loc9_ = "";
            for(_loc8_ in param2)
            {
               _loc9_ += _loc9_ == "" ? _loc8_ + ":" + param2[_loc8_] : ", " + _loc8_ + ":" + param2[_loc8_];
            }
            _loc4_.data = _loc9_;
         }
         var _loc5_:String = param1 ? "blacklistReview" : "blacklist";
         var _loc6_:Function = param1 ? null : Utils.setLogText;
         var _loc7_:Array = param1 ? null : [TextManager.getText("TID_GEN_FRAUD_PURCHASE"),true,false,false];
         this.createEntityInCollection(_loc5_,_loc4_,_loc6_,_loc7_);
      }
      
      public function getPvPRanking(param1:Function, param2:int = -1, param3:Boolean = false) : void
      {
         var _loc4_:String = Config.PVP_LEAGUES_ENABLED && param2 != -1 ? "PLAYER_PVP_LB_" + "L" + param2 + "_Display" : "PLAYER_PVP_LB_Display";
         this.getLeaderboardData(_loc4_,50,param1,[param3]);
      }
      
      public function getDungeonsRanking(param1:Function) : void
      {
         this.getLeaderboardData("PLAYER_DUNGEONS_LB_Display",50,param1);
      }
      
      public function isPlayerInBlackList() : void
      {
         this.searchInCollection("blacklist",this.getOwnerUidQuery(),this.onPlayerBlackListedResponse,null,setTimeout,[this.isPlayerInBlackList,1000]);
      }
      
      private function onPlayerBlackListedResponse(param1:Object) : void
      {
         if(param1 != null && (param1 as Array).length > 0)
         {
            if(InstanceMng.getUserDataMng() != null && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
            {
               InstanceMng.getUserDataMng().getOwnerUserData().setInBlackList(true);
            }
         }
      }
      
      public function getRequestDateObject(param1:Number = -1) : *
      {
         return smServerTimeMS != -1 ? smServerTimeMS : TimerUtil.currentTimeMillis();
      }
      
      public function sendKongStatsOnStart() : void
      {
         var _loc1_:UserData = Utils.getOwnerUserData();
         if(_loc1_)
         {
            Utils.setStat(Constants.STAT_INITIALIZED,1);
            Utils.setStat(Constants.STAT_CARDS_OWNED,DictionaryUtils.getUniqueCardsAmountByCatalog(_loc1_.getCardCollection()));
            Utils.setStat(Constants.STAT_GOLD_EARNED,0);
            Utils.setStat(Constants.STAT_QUEST_COINS,_loc1_.getQuestsCoins());
            Utils.setStat(Constants.STAT_RAID_COINS,_loc1_.getRaidCoins());
            Utils.setStat(Constants.STAT_QUEST_CLAIMED,DictionaryUtils.getDictionaryLength(_loc1_.getQuestsClaimed()));
            Utils.setStat(Constants.STAT_USER_LEVEL,_loc1_.getCurrentLevelIndex(UserDataMng.DIFFICULTY_EASY));
            Utils.setStat(Constants.DUNGEONS_PLAYED,_loc1_.getDungeonsPlayed());
            Utils.setStat(Constants.STAT_DUNGEONS_COMPLETED,_loc1_.getDungeonsWon());
            Utils.setStat(Constants.STAT_PVP_MATCHES_PLAYED,_loc1_.getMatchesPlayed());
            Utils.setStat(Constants.STAT_PVP_MATCHES_WON,_loc1_.getMatchesWon());
            Utils.setStat(Constants.STAT_CARDS_RECYCLED,0);
            Utils.setStat(Constants.STAT_CARDS_CRAFTED,0);
            Utils.setStat(Constants.STAT_PACKS_UNFOLDED,0);
            Utils.setStat(Constants.STAT_PVP_RANKING_PUNCTUATION,_loc1_.getElo());
            Utils.setStat(Constants.STAT_GOLD,_loc1_.getGold());
         }
      }
      
      public function createAuction(param1:String, param2:Number, param3:Number, param4:Function = null, param5:Function = null, param6:Array = null) : void
      {
         var _loc7_:Object = new Object();
         var _loc8_:UserData = Utils.getOwnerUserData();
         var _loc9_:String = _loc8_ ? _loc8_.getAccountId() : "";
         var _loc10_:String = _loc8_ ? _loc8_.getName() : "";
         var _loc11_:String = _loc8_ ? _loc8_.getExtId() : "";
         var _loc12_:CardDef = param1 != "" ? CardDef(InstanceMng.getCardsDefMng().getDefBySku(param1)) : null;
         var _loc13_:String = _loc12_ ? _loc12_.getName() : "";
         var _loc14_:int = _loc12_ ? RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(_loc12_.getCardRarity())).getIndex() : -1;
         _loc7_.playerId = _loc9_;
         _loc7_.creatorName = _loc10_;
         _loc7_.extId = _loc11_;
         _loc7_.cardSku = param1;
         _loc7_.cardName = _loc13_;
         _loc7_.broadcastMsg = _loc14_ > 3;
         _loc7_.cardRarity = _loc14_;
         _loc7_.price = param2;
         _loc7_.round = 1;
         _loc7_.roundStartTime = ServerConnection.smServerTimeMS;
         _loc7_.roundEndTime = ServerConnection.smServerTimeMS + param3;
         _loc7_.roundHighestBidder = null;
         _loc7_.highestBid = -1;
         _loc7_.biddersAmount = 0;
         _loc7_.nextRound = -1;
         _loc7_.nextRoundStartTime = -1;
         _loc7_.nextRoundEndTime = -1;
         _loc7_.when = this.getRequestDateObject();
         this.createEntityInCollection("auctions",_loc7_,param4,null,param5,param6,true);
      }
      
      public function getActiveAuctions(param1:int, param2:int, param3:Function = null, param4:Array = null, param5:Function = null, param6:Array = null) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var skip:int = param1;
         var limit:int = param2;
         var onSuccessFunction:Function = param3;
         var onSuccessParams:Array = param4;
         var onFailFunction:Function = param5;
         var onFailParams:Array = param6;
         if(this.isUserLoggedIn())
         {
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("AH_GET_ACTIVE_AUCTIONS");
            req.setAttribute("LIMIT",limit);
            req.setAttribute("SKIP",skip);
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               var _loc2_:Object = null;
               var _loc3_:int = 0;
               var _loc4_:Object = null;
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("getActiveAuctions");
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  _loc2_ = param1.getScriptData() ? param1.getScriptData().data : null;
                  _loc3_ = param1.getScriptData() ? int(param1.getScriptData().count) : 0;
                  _loc4_ = {
                     "data":_loc2_,
                     "count":_loc3_
                  };
                  onDDBBAccessedProcessResponse("auctions",true,"getActiveAuctions","","",_loc4_,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,true);
               }
               else
               {
                  onDDBBAccessedProcessResponse("auctions",false,"getActiveAuctions","","",null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,true);
               }
            });
         }
      }
      
      public function createBid(param1:Auction, param2:Number, param3:int, param4:Boolean, param5:int, param6:Function = null, param7:Array = null, param8:Function = null, param9:Array = null) : void
      {
         var _loc10_:Object = null;
         var _loc11_:UserData = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc15_:Number = NaN;
         var _loc16_:String = null;
         var _loc17_:String = null;
         var _loc18_:String = null;
         var _loc19_:String = null;
         if(!param1.isOwnerAuctionCreator() || AuctionsMng.TEST_BIDS_CREATOR_CAN_BID)
         {
            if(param2 == -1)
            {
               if(param8 != null)
               {
                  if(param9 != null)
                  {
                     param8.apply(null,param9);
                  }
                  else
                  {
                     param8();
                  }
               }
               return;
            }
            _loc10_ = new Object();
            _loc11_ = Utils.getOwnerUserData();
            _loc12_ = _loc11_ ? _loc11_.getAccountId() : "";
            _loc13_ = _loc11_ ? _loc11_.getName() : "";
            _loc14_ = _loc11_ ? _loc11_.getExtId() : "";
            _loc15_ = _loc11_ ? _loc11_.getAuctionTickets() : -1;
            _loc16_ = "";
            _loc17_ = "";
            _loc18_ = "";
            _loc19_ = "";
            if(InstanceMng.getGuildsMng().getMyGuild())
            {
               _loc16_ = InstanceMng.getGuildsMng().getMyGuild().getEmblemBG();
               _loc17_ = InstanceMng.getGuildsMng().getMyGuild().getEmblemFG();
               _loc18_ = InstanceMng.getGuildsMng().getMyGuild().getId();
               _loc19_ = InstanceMng.getGuildsMng().getMyGuild().getName();
            }
            _loc10_.playerId = _loc12_;
            _loc10_.name = _loc13_;
            _loc10_.extId = _loc14_;
            _loc10_.round = param3;
            _loc10_.auctionId = param1.getAuctionId();
            _loc10_.bid = param2;
            _loc10_.bidderGuildEmblemBG = _loc16_;
            _loc10_.bidderGuildEmblemFG = _loc17_;
            _loc10_.firstBidInCurrentRound = param4;
            _loc10_.biddersAmount = param5;
            _loc10_.nextRoundDuration = Config.getConfig().getAuctionTimeByRound(param3 + 1);
            _loc10_.guildId = _loc18_;
            _loc10_.guildName = _loc19_;
            _loc10_.auctionTickets = _loc15_;
            _loc10_.when = this.getRequestDateObject();
            InstanceMng.getCurrentScreen().disableBackButtonTemporarily();
            this.createEntityInCollection("bids",_loc10_,param6,param7,param8,param9,true);
         }
      }
      
      public function getNewBidsByAuctionId(param1:String, param2:Number, param3:Function = null, param4:Array = null, param5:Function = null, param6:Array = null) : void
      {
         var _loc7_:String = null;
         if(param2)
         {
            _loc7_ = "{\'$and\':[{\'auctionId\':\'" + param1 + "\'}," + "{\'processedTime\':{\'$gt\':" + param2 + "}}]}";
         }
         else
         {
            _loc7_ = "{\'auctionId\':\'" + param1 + "\'}";
         }
         this.searchInCollection("bids",_loc7_,param3,param4,param5,param6,true,0,"{\'bid\':-1}");
      }
      
      public function getAuctionInfoByAuctionId(param1:String, param2:Function, param3:Function = null) : void
      {
         this.searchInCollectionById("auctions",param1,param2,null,param3);
      }
      
      public function getAuctionInfoByAuctionIdArray(param1:Array, param2:Function, param3:Function = null) : void
      {
         var _loc4_:int = 0;
         var _loc8_:String = null;
         var _loc5_:String = "";
         var _loc6_:String = "]}}";
         var _loc7_:int = 0;
         if(param1 != null)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.length)
            {
               if(_loc4_ == 0)
               {
                  _loc5_ = "{\'_id\':{\'$in\':[";
               }
               _loc8_ = String(param1[_loc4_]).split(":")[0];
               if(_loc8_ != null && _loc8_ != "")
               {
                  _loc5_ += "{\'$oid\':\'" + _loc8_ + "\'}";
                  _loc5_ = _loc5_ + (_loc4_ < param1.length - 1 ? "," : _loc6_);
                  _loc7_++;
               }
               _loc4_++;
            }
         }
         if(_loc5_ != "" && _loc7_ > 0)
         {
            this.searchInCollection("auctions",_loc5_,param2,null,param3);
         }
      }
      
      public function fullyUpdateUserProfile(param1:String, param2:int, param3:Object, param4:Function, param5:Array) : void
      {
         var _loc6_:Object = this.processProfileFromUserInfoObject(param3,true);
         _loc6_.extId = param1;
         _loc6_.extPlatform = param2;
         if(_loc6_.hasOwnProperty("accountId") && _loc6_.accountId != null && _loc6_.accountId != "" && this.getUserId() != null && this.getUserId() != "")
         {
            if(this.getUserId() != _loc6_.accountId)
            {
               return;
            }
         }
         var _loc7_:Boolean = this.isSameProfile(_loc6_,this.mLastFullProfileSaved);
         if(!_loc7_)
         {
            this.updateProfileInDDBB(_loc6_,"","",true,param4,param5);
         }
         else
         {
            FSDebug.debugTrace("Skipping save, it\'s the same profile");
            this.onDDBBAccessedProcessResponse("users",true,"updateProfileInDDBB","","",null,param4,param5);
         }
      }
      
      private function isSameProfile(param1:Object, param2:Object) : Boolean
      {
         return this.compareProfiles(param1,param2) && this.compareProfiles(param2,param1);
      }
      
      private function compareProfiles(param1:Object, param2:Object) : Boolean
      {
         var _loc4_:String = null;
         if(param1 == null || param2 == null)
         {
            return false;
         }
         var _loc3_:int = 0;
         for(_loc4_ in param1)
         {
            _loc3_++;
            if(param2[_loc4_] == undefined)
            {
               return false;
            }
            if(_loc4_ != "currentDateMS" && !this.compareProfiles(param1[_loc4_],param2[_loc4_]))
            {
               return false;
            }
         }
         if(_loc3_ == 0 && param1 != param2)
         {
            return false;
         }
         return true;
      }
      
      public function searchUser(param1:String, param2:String = "", param3:Function = null, param4:Array = null, param5:Function = null, param6:Array = null, param7:Boolean = true, param8:int = 0, param9:String = "", param10:int = 0) : void
      {
         var JSONQuery:Object = null;
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var query:String = param1;
         var uid:String = param2;
         var onSuccessFunction:Function = param3;
         var onSuccessParams:Array = param4;
         var onFailFunction:Function = param5;
         var onFailParams:Array = param6;
         var returnDataOnSuccess:Boolean = param7;
         var limit:int = param8;
         var sort:String = param9;
         var skip:int = param10;
         if(this.isUserLoggedIn())
         {
            query = query == "" ? "{}" : query;
            JSONQuery = Utils.parseQueryToJSON(query);
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("GET_PLAYER");
            req.setAttribute("uid",uid);
            req.setAttribute("isCS",0);
            req.setJSONEventAttribute("query",JSONQuery);
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               var _loc2_:Object = null;
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("searchUser");
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  _loc2_ = param1.getScriptData() ? param1.getScriptData().data : null;
                  onDDBBAccessedProcessResponse("users",true,"searchUser","",uid,_loc2_,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
               }
               else
               {
                  onDDBBAccessedProcessResponse("users",false,"searchUser","",uid,null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
               }
            });
         }
         else if(onFailFunction != null)
         {
            if(onFailParams != null)
            {
               onFailFunction.apply(null,onFailParams);
            }
            else
            {
               onFailFunction();
            }
         }
      }
      
      public function searchInCollection(param1:String, param2:String = "{}", param3:Function = null, param4:Array = null, param5:Function = null, param6:Array = null, param7:Boolean = true, param8:int = 0, param9:String = "", param10:int = 0, param11:String = "{}") : void
      {
         var JSONQuery:Object = null;
         var JSONFields:Object = null;
         var JSONQuerySort:Object = null;
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var collection:String = param1;
         var query:String = param2;
         var onSuccessFunction:Function = param3;
         var onSuccessParams:Array = param4;
         var onFailFunction:Function = param5;
         var onFailParams:Array = param6;
         var returnDataOnSuccess:Boolean = param7;
         var limit:int = param8;
         var sort:String = param9;
         var skip:int = param10;
         var fields:String = param11;
         if(this.isUserLoggedIn())
         {
            query = query == "" ? "{}" : query;
            JSONQuery = Utils.parseQueryToJSON(query);
            JSONFields = Utils.parseQueryToJSON(fields);
            sort = sort == "" ? "{}" : sort;
            JSONQuerySort = Utils.parseQueryToJSON(sort);
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("SEARCH");
            req.setAttribute("collection",collection);
            req.setJSONEventAttribute("query",JSONQuery);
            req.setAttribute("searchId","");
            req.setJSONEventAttribute("queryLimit",limit);
            req.setJSONEventAttribute("fields",JSONFields);
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            if(sort != "{}")
            {
               req.setJSONEventAttribute("querySort",JSONQuerySort);
            }
            req.send(function(param1:LogEventResponse):void
            {
               var _loc2_:Object = null;
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("searchInCollection: " + collection);
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  _loc2_ = param1.getScriptData() ? param1.getScriptData().data : null;
                  processedAlready = true;
                  onDDBBAccessedProcessResponse(collection,true,"searchInCollection",query,"",_loc2_,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
               }
               else
               {
                  onDDBBAccessedProcessResponse(collection,false,"searchInCollection",query,"",_loc2_,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
                  handleErrorConnectingWithServer(collection,null,param1.getErrors());
               }
            });
         }
         else if(onFailFunction != null)
         {
            if(onFailParams != null)
            {
               onFailFunction.apply(null,onFailParams);
            }
            else
            {
               onFailFunction();
            }
         }
      }
      
      private function increaseTimeoutsCount() : void
      {
         var _loc1_:Popup = null;
         if(this.mTimeoutsCount == 5)
         {
            _loc1_ = InstanceMng.getPopupMng().getPopupShown();
            if(_loc1_ == null || Boolean(_loc1_) && Boolean(!(_loc1_ is PopupError)))
            {
               this.handleSessionTerminated(null,"[SESSION TIMED OUT]",false);
            }
            this.mTimeoutsCount = 0;
         }
         ++this.mTimeoutsCount;
         FSDebug.debugTrace("ATTENTION!! Timeout received, total count: " + this.mTimeoutsCount);
      }
      
      public function getTimeoutsAmount() : int
      {
         return this.mTimeoutsCount;
      }
      
      private function onDDBBAccessedProcessResponse(param1:String, param2:Boolean, param3:String, param4:String = "", param5:String = "", param6:Object = null, param7:Function = null, param8:Array = null, param9:Function = null, param10:Array = null, param11:Boolean = false) : void
      {
         var _loc12_:String = param2 ? "OK" : "FAIL";
         var _loc13_:String = " | COLLECTION: " + param1;
         var _loc14_:String = param4 != "" ? " | QUERY: " + param4 : "";
         var _loc15_:String = param5 != "" ? " | ID: " + param5 : "";
         FSDebug.debugTrace("[" + param3 + "] - " + _loc12_ + _loc13_ + _loc14_ + _loc15_);
         if(param2)
         {
            this.mTimeoutsCount = 0;
            if(param7 != null)
            {
               if(param8 != null)
               {
                  if(param11)
                  {
                     param8.unshift(param6);
                  }
                  if(!Utils.isIOS())
                  {
                     param7.apply(null,param8);
                  }
                  else
                  {
                     SystemUtil.executeWhenApplicationIsActive(param7.apply,null,param8);
                  }
               }
               else if(param11)
               {
                  if(!Utils.isIOS())
                  {
                     param7(param6);
                  }
                  else
                  {
                     SystemUtil.executeWhenApplicationIsActive(param7,param6);
                  }
               }
               else if(!Utils.isIOS())
               {
                  if(param7 != null)
                  {
                     param7();
                  }
               }
               else
               {
                  SystemUtil.executeWhenApplicationIsActive(param7);
               }
            }
         }
         else if(param9 != null)
         {
            if(param10 != null)
            {
               if(!Utils.isIOS())
               {
                  param9.apply(null,param10);
               }
               else
               {
                  SystemUtil.executeWhenApplicationIsActive(param9.apply,null,param10);
               }
            }
            else if(!Utils.isIOS())
            {
               if(param9 != null)
               {
                  param9();
               }
            }
            else
            {
               SystemUtil.executeWhenApplicationIsActive(param9);
            }
         }
      }
      
      public function searchInCollectionById(param1:String, param2:String, param3:Function = null, param4:Array = null, param5:Function = null, param6:Array = null, param7:Boolean = true) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var collection:String = param1;
         var id:String = param2;
         var onSuccessFunction:Function = param3;
         var onSuccessParams:Array = param4;
         var onFailFunction:Function = param5;
         var onFailParams:Array = param6;
         var returnDataOnSuccess:Boolean = param7;
         if(this.isUserLoggedIn())
         {
            if(id != "" && id != null)
            {
               req = new LogEventRequest(smGameSparks);
               req.setEventKey("SEARCH");
               req.setAttribute("collection",collection);
               req.setAttribute("searchId",id);
               req.setAttribute("query",{});
               req.setTimeoutSeconds(GS_TIMEOUT_SEC);
               req.setDurable(Config.DURABLE_CONNECTION);
               processedAlready = false;
               req.send(function(param1:LogEventResponse):void
               {
                  var _loc2_:Object = null;
                  if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
                  {
                     onDuplicatedResponseReceived("searchInCollectionById: " + collection);
                     return;
                  }
                  processedAlready = true;
                  if(!param1.HasErrors())
                  {
                     _loc2_ = param1.getScriptData() ? param1.getScriptData().data : null;
                     onDDBBAccessedProcessResponse(collection,true,"searchInCollectionById","",id,_loc2_,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
                  }
                  else
                  {
                     onDDBBAccessedProcessResponse(collection,false,"searchInCollectionById","",id,null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
                     handleErrorConnectingWithServer(collection,null,param1.getErrors());
                  }
               });
            }
         }
         else if(onFailFunction != null)
         {
            if(onFailParams != null)
            {
               onFailFunction.apply(null,onFailParams);
            }
            else
            {
               onFailFunction();
            }
         }
      }
      
      public function countInCollection(param1:String, param2:String, param3:Function = null, param4:Array = null, param5:Function = null, param6:Array = null, param7:Boolean = true) : void
      {
         var JSONQuery:Object = null;
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var collection:String = param1;
         var query:String = param2;
         var onSuccessFunction:Function = param3;
         var onSuccessParams:Array = param4;
         var onFailFunction:Function = param5;
         var onFailParams:Array = param6;
         var returnDataOnSuccess:Boolean = param7;
         if(this.isUserLoggedIn())
         {
            query = query == "" ? "{}" : query;
            JSONQuery = Utils.parseQueryToJSON(query);
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("COUNT");
            req.setAttribute("collection",collection);
            req.setJSONEventAttribute("query",JSONQuery);
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               var _loc2_:Object = null;
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("countInCollection: " + collection);
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  _loc2_ = param1.getScriptData() ? param1.getScriptData().data : null;
                  onDDBBAccessedProcessResponse(collection,true,"countInCollection",query,"",_loc2_,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
               }
               else
               {
                  onDDBBAccessedProcessResponse(collection,false,"countInCollection",query,"",null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
               }
            });
         }
         else if(onFailFunction != null)
         {
            if(onFailParams != null)
            {
               onFailFunction.apply(null,onFailParams);
            }
            else
            {
               onFailFunction();
            }
         }
      }
      
      public function notifyDeviceActivation(param1:String, param2:String) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var uid:String = param1;
         var status:String = param2;
         if(this.isUserLoggedIn())
         {
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("NOTIFY_DEVICE_ACTIVATION");
            req.setAttribute("uid",uid);
            req.setAttribute("status",status);
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               var _loc3_:Object = null;
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("notifyDeviceActivation");
                  return;
               }
               processedAlready = true;
               var _loc2_:String = "devicesStatus";
               if(!param1.HasErrors())
               {
                  _loc3_ = param1.getScriptData() ? param1.getScriptData().data : null;
                  onDDBBAccessedProcessResponse(_loc2_,true,"notifyDeviceActivation","",uid,_loc3_);
               }
               else
               {
                  onDDBBAccessedProcessResponse(_loc2_,false,"notifyDeviceActivation","",uid,_loc3_);
                  handleErrorConnectingWithServer(_loc2_,null,param1.getErrors());
               }
            });
         }
      }
      
      public function createEntityInCollection(param1:String, param2:Object, param3:Function = null, param4:Array = null, param5:Function = null, param6:Array = null, param7:Boolean = false) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var collection:String = param1;
         var entityData:Object = param2;
         var onSuccessFunction:Function = param3;
         var onSuccessParams:Array = param4;
         var onFailFunction:Function = param5;
         var onFailParams:Array = param6;
         var returnDataOnSuccess:Boolean = param7;
         if(this.isUserLoggedIn())
         {
            if(entityData != null)
            {
               req = new LogEventRequest(smGameSparks);
               req.setEventKey("CREATE");
               req.setAttribute("collection",collection);
               req.setJSONEventAttribute("entityData",entityData);
               req.setTimeoutSeconds(GS_TIMEOUT_SEC);
               req.setDurable(Config.DURABLE_CONNECTION);
               processedAlready = false;
               req.send(function(param1:LogEventResponse):void
               {
                  var _loc2_:Object = null;
                  if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
                  {
                     onDuplicatedResponseReceived("createEntityInCollection: " + collection);
                     return;
                  }
                  processedAlready = true;
                  if(!param1.HasErrors())
                  {
                     _loc2_ = param1.getScriptData() ? param1.getScriptData().data : null;
                     onDDBBAccessedProcessResponse(collection,true,"createEntityInCollection","","",_loc2_,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
                  }
                  else
                  {
                     onDDBBAccessedProcessResponse(collection,false,"createEntityInCollection","","",null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
                     handleErrorConnectingWithServer(collection,entityData,param1.getErrors());
                  }
               });
            }
            else
            {
               FSDebug.debugTrace("ERROR! Entity Data must not be null");
            }
         }
         else
         {
            FSDebug.debugTrace("ERROR! Player not logged in / not authorized");
         }
      }
      
      public function updateProfileInDDBB(param1:Object, param2:String = "", param3:String = "", param4:Boolean = true, param5:Function = null, param6:Array = null, param7:Boolean = false) : void
      {
         var overrideIndex:int;
         var fieldNameArr:Array;
         var req:LogEventRequest;
         var isFullProfile:Boolean = false;
         var processedAlready:Boolean = false;
         var fieldNames:String = null;
         var i:int = 0;
         var profile:Object = param1;
         var fieldName:String = param2;
         var fieldValue:String = param3;
         var overrideDDBB:Boolean = param4;
         var onSuccessFunction:Function = param5;
         var onSuccessParams:Array = param6;
         var returnDataOnSuccess:Boolean = param7;
         if(profile == null && fieldName == "")
         {
            FSDebug.debugTrace("ERROR! Entity Data must not be null");
         }
         overrideIndex = overrideDDBB ? 1 : 0;
         isFullProfile = profile != null && fieldName == "";
         if(profile == null && fieldName != "")
         {
            profile = new Object();
            profile[fieldName] = fieldValue;
            overrideIndex = 0;
            overrideDDBB = false;
            profile = this.processProfileFromUserInfoObject(profile);
         }
         fieldNameArr = DictionaryUtils.getKeys(profile);
         if(fieldNameArr != null)
         {
            fieldNames = "";
            i = 0;
            i = 0;
            while(i < fieldNameArr.length)
            {
               fieldNames += i < fieldNameArr.length - 1 ? fieldNameArr[i] + "," : fieldNameArr[i];
               i++;
            }
         }
         req = new LogEventRequest(smGameSparks);
         req.setEventKey("SAVE_PERSISTENCE");
         req.setAttribute("override",overrideIndex);
         req.setAttribute("fieldName",fieldName);
         req.setAttribute("uid","");
         req.setJSONEventAttribute("profile",profile);
         req.setTimeoutSeconds(GS_TIMEOUT_SEC);
         req.setDurable(Config.DURABLE_CONNECTION);
         processedAlready = false;
         req.send(function(param1:LogEventResponse):void
         {
            var _loc2_:Object = null;
            if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
            {
               onDuplicatedResponseReceived("updateProfileInDDBB");
               return;
            }
            processedAlready = true;
            if(isFullProfile)
            {
               mLastFullProfileSaved = profile;
            }
            if(!param1.HasErrors())
            {
               _loc2_ = param1.getScriptData() ? param1.getScriptData().data : null;
               onDDBBAccessedProcessResponse("users",true,"updateProfileInDDBB","","",_loc2_,onSuccessFunction,onSuccessParams,null,null,returnDataOnSuccess);
            }
            else
            {
               onDDBBAccessedProcessResponse("users",false,"updateProfileInDDBB","","",null,onSuccessFunction,onSuccessParams,null,null,returnDataOnSuccess);
            }
         });
      }
      
      public function updateEntityInCollection(param1:String, param2:Object, param3:Boolean = false, param4:Function = null, param5:Array = null, param6:Function = null, param7:Array = null, param8:Boolean = false) : void
      {
         var overrideIndex:int = 0;
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var collection:String = param1;
         var entityData:Object = param2;
         var overrideData:Boolean = param3;
         var onSuccessFunction:Function = param4;
         var onSuccessParams:Array = param5;
         var onFailFunction:Function = param6;
         var onFailParams:Array = param7;
         var returnDataOnSuccess:Boolean = param8;
         if(this.isUserLoggedIn())
         {
            if(entityData != null)
            {
               overrideIndex = overrideData ? 1 : 0;
               req = new LogEventRequest(smGameSparks);
               req.setEventKey("UPDATE");
               req.setAttribute("collection",collection);
               req.setJSONEventAttribute("entityData",entityData);
               req.setJSONEventAttribute("override",overrideIndex);
               req.setTimeoutSeconds(GS_TIMEOUT_SEC);
               req.setDurable(Config.DURABLE_CONNECTION);
               processedAlready = false;
               req.send(function(param1:LogEventResponse):void
               {
                  var _loc2_:Object = null;
                  if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
                  {
                     onDuplicatedResponseReceived("updateEntityInCollection: " + collection);
                     return;
                  }
                  processedAlready = true;
                  if(!param1.HasErrors())
                  {
                     _loc2_ = param1.getScriptData() ? param1.getScriptData().data : null;
                     onDDBBAccessedProcessResponse(collection,true,"updateEntityInCollection","","",_loc2_,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
                  }
                  else
                  {
                     onDDBBAccessedProcessResponse(collection,false,"updateEntityInCollection","","",param1.getErrors(),onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
                     handleErrorConnectingWithServer(collection,entityData,param1.getErrors());
                  }
               });
            }
            else
            {
               FSDebug.debugTrace("[updateEntityInCollection] - ERROR! Entity Data must not be null");
            }
         }
         else
         {
            FSDebug.debugTrace("[updateEntityInCollection] - ERROR! Player not logged in / not authorized");
         }
      }
      
      private function handleErrorConnectingWithServer(param1:String, param2:Object, param3:Object) : void
      {
         var _loc4_:String = null;
         if(Boolean(param3) && param3.hasOwnProperty("error"))
         {
            _loc4_ = param3.error;
            if(_loc4_ == "timeout")
            {
               if(param1 == "matches")
               {
                  Utils.setLogText(TextManager.getText("TID_PVP_MATCH_INFO"),true,false,false);
                  if(param2 != null && param2["turnEnded"] == true)
                  {
                     Utils.setLogText(TextManager.getText("TID_GEN_DESYNC"),true,true);
                     BattleEnginePvP.pvpDesyncPlayerForInactivity(true);
                  }
                  else
                  {
                     this.increaseTimeoutsCount();
                  }
               }
               else
               {
                  this.increaseTimeoutsCount();
               }
            }
            FSDebug.debugTrace("Error: " + _loc4_);
         }
      }
      
      public function deleteEntityInCollection(param1:String, param2:String, param3:Function = null, param4:Array = null, param5:Function = null, param6:Array = null) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var collection:String = param1;
         var id:String = param2;
         var onSuccessFunction:Function = param3;
         var onSuccessParams:Array = param4;
         var onFailFunction:Function = param5;
         var onFailParams:Array = param6;
         if(this.isUserLoggedIn())
         {
            if(id != null && id != "")
            {
               req = new LogEventRequest(smGameSparks);
               req.setEventKey("DELETE");
               req.setAttribute("collection",collection);
               req.setAttribute("idToRemove",id);
               req.setTimeoutSeconds(GS_TIMEOUT_SEC);
               req.setDurable(Config.DURABLE_CONNECTION);
               processedAlready = false;
               req.send(function(param1:LogEventResponse):void
               {
                  var _loc2_:Object = null;
                  if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
                  {
                     onDuplicatedResponseReceived("deleteEntityInCollection: " + collection);
                     return;
                  }
                  processedAlready = true;
                  if(!param1.HasErrors())
                  {
                     _loc2_ = param1.getScriptData() ? param1.getScriptData().data : null;
                     onDDBBAccessedProcessResponse(collection,true,"deleteEntityInCollection","",id,_loc2_,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams);
                  }
                  else
                  {
                     onDDBBAccessedProcessResponse(collection,false,"deleteEntityInCollection","",id,null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams);
                     handleErrorConnectingWithServer(collection,null,param1.getErrors());
                  }
               });
            }
            else
            {
               FSDebug.debugTrace("ERROR! Entity id must not be null");
            }
         }
         else
         {
            FSDebug.debugTrace("ERROR! Player not logged in / not authorized");
         }
      }
      
      public function deleteMultipleEntitiesInCollection(param1:String, param2:String = "", param3:String = "{}", param4:Boolean = false, param5:Function = null, param6:Array = null, param7:Function = null, param8:Array = null) : void
      {
         var purgeCollIndex:int = 0;
         var JSONQuery:Object = null;
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var collection:String = param1;
         var ids:String = param2;
         var query:String = param3;
         var purgeCollection:Boolean = param4;
         var onSuccessFunction:Function = param5;
         var onSuccessParams:Array = param6;
         var onFailFunction:Function = param7;
         var onFailParams:Array = param8;
         if(this.isUserLoggedIn())
         {
            purgeCollIndex = purgeCollection ? 1 : 0;
            JSONQuery = query != "" ? Utils.parseQueryToJSON(query) : {};
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("DELETE");
            req.setAttribute("collection",collection);
            req.setJSONEventAttribute("query",JSONQuery);
            req.setAttribute("idToRemove","");
            req.setAttribute("multipleDeletion",1);
            req.setAttribute("purgeCollection",purgeCollIndex);
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               var _loc2_:Object = null;
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("deleteMultipleEntitiesInCollection: " + collection);
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  _loc2_ = param1.getScriptData() ? param1.getScriptData().data : null;
                  onDDBBAccessedProcessResponse(collection,true,"deleteMultipleEntitiesInCollection","","",_loc2_,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams);
               }
               else
               {
                  onDDBBAccessedProcessResponse(collection,false,"deleteMultipleEntitiesInCollection","","",null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams);
               }
            });
         }
         else
         {
            FSDebug.debugTrace("ERROR! Player not logged in / not authorized");
         }
      }
      
      private function runScript(param1:String, param2:Object, param3:Function = null, param4:Array = null, param5:Function = null, param6:Array = null, param7:Boolean = true) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var key:String = null;
         var value:String = null;
         var scriptName:String = param1;
         var params:Object = param2;
         var onSuccessFunction:Function = param3;
         var onSuccessParams:Array = param4;
         var onFailFunction:Function = param5;
         var onFailParams:Array = param6;
         var returnDataOnSuccess:Boolean = param7;
         if(this.isUserLoggedIn())
         {
            req = new LogEventRequest(smGameSparks);
            req.setEventKey(scriptName);
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            for each(key in params)
            {
               req.setAttribute(key,params.key);
            }
            req.send(function(param1:LogEventResponse):void
            {
               var _loc2_:Object = null;
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("runScript: " + scriptName);
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  _loc2_ = param1.getScriptData() ? param1.getScriptData().data : null;
                  if(scriptName == "SERVER_TIME")
                  {
                     refreshTimeVars(_loc2_);
                  }
                  onDDBBAccessedProcessResponse(scriptName,true,"runScript","","",_loc2_,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
               }
               else
               {
                  onDDBBAccessedProcessResponse(scriptName,false,"runScript","","",_loc2_,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
               }
            });
         }
         else if(onFailFunction != null)
         {
            if(onFailParams != null)
            {
               onFailFunction.apply(null,onFailParams);
            }
            else
            {
               onFailFunction();
            }
         }
      }
      
      private function isUserAllowedToMakeServerCalls() : Boolean
      {
         return !Config.DURABLE_CONNECTION && this.isUserLoggedIn() || Config.DURABLE_CONNECTION;
      }
      
      public function addScoreToLeaderboard(param1:String, param2:Number, param3:Number = 0, param4:int = 3, param5:int = 3, param6:String = "level_01", param7:int = 0, param8:Function = null, param9:Array = null, param10:Function = null, param11:Array = null, param12:Boolean = false) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var codename:String = param1;
         var score:Number = param2;
         var pvpVictories:Number = param3;
         var pvpCurrentLeague:int = param4;
         var pvpBestLeague:int = param5;
         var levelSku:String = param6;
         var difficulty:int = param7;
         var onSuccessFunction:Function = param8;
         var onSuccessParams:Array = param9;
         var onFailFunction:Function = param10;
         var onFailParams:Array = param11;
         var returnDataOnSuccess:Boolean = param12;
         if(this.isUserAllowedToMakeServerCalls())
         {
            req = new LogEventRequest(smGameSparks);
            req.setEventKey(this.getEventKeyByCodename(codename));
            req.setAttribute("SCORE",score);
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            switch(codename)
            {
               case "PLAYER_PVP":
                  req.setAttribute("victories",pvpVictories);
                  if(Config.PVP_LEAGUES_ENABLED)
                  {
                     req.setAttribute("CURRENT_LEAGUE",pvpCurrentLeague);
                     req.setAttribute("BEST_LEAGUE",pvpBestLeague);
                  }
                  break;
               case "PLAYER_PVE":
                  req.setAttribute("LEVEL",levelSku);
                  req.setAttribute("DIFFICULTY",difficulty);
                  break;
               case "PLAYER_DUNGEONS":
               case "GUILD_PVP":
               case "GUILD_DUNGEONS":
               case "GUILD_RAIDS":
            }
            req.send(function(param1:LogEventResponse):void
            {
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("addScoreToLeaderboard: " + codename);
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  onDDBBAccessedProcessResponse(codename,true,"addScoreToLeaderboard","score:" + score,"",null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
               }
               else
               {
                  onDDBBAccessedProcessResponse(codename,false,"addScoreToLeaderboard","score:" + score,"",null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
               }
            });
         }
         else
         {
            this.onDDBBAccessedProcessResponse(codename,false,"addScoreToLeaderboard","score:" + score,"",null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
         }
      }
      
      private function getEventKeyByCodename(param1:String) : String
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case "PLAYER_DUNGEONS":
               _loc2_ = PLAYER_SCORE_DUNGEONS_EV;
               break;
            case "PLAYER_PVP":
               _loc2_ = PLAYER_SCORE_PVP_EV;
               break;
            case "PLAYER_PVE":
               _loc2_ = PLAYER_SCORE_PVE_EV;
               break;
            case "GUILD_PVP":
               _loc2_ = GUILD_SCORE_PVP_EV;
               break;
            case "GUILD_DUNGEONS":
               _loc2_ = GUILD_SCORE_DUNGEON_EV;
               break;
            case "GUILD_RAIDS":
               _loc2_ = GUILD_SCORE_RAID_EV;
               break;
            case "RAIDS_MP":
               _loc2_ = RAIDS_SCORE_MP_EV;
               break;
            case "RAIDS_SP":
               _loc2_ = RAIDS_SCORE_SP_EV;
         }
         return _loc2_;
      }
      
      private function getLeaderboardFullShortCodeByName(param1:String, param2:Function, param3:Function) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var leaderBoard:String = param1;
         var onSuccessFunction:Function = param2;
         var onFailFunction:Function = param3;
         if(this.isUserLoggedIn())
         {
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("FS_GET_LB_SHORT_CODE");
            req.setAttribute("LEADERBOARD",leaderBoard);
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               var _loc2_:String = null;
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("getLeaderboardFullShortCodeByName: " + leaderBoard);
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  _loc2_ = param1.getScriptData().data;
                  onDDBBAccessedProcessResponse("Leaderboards",true,"getLeaderboardFullShortCodeByName",leaderBoard,"",_loc2_,onSuccessFunction,null,onFailFunction,null,true);
               }
               else
               {
                  onDDBBAccessedProcessResponse("Leaderboards",false,"getLeaderboardFullShortCodeByName",leaderBoard,"",null,onSuccessFunction,null,onFailFunction);
               }
            });
         }
      }
      
      public function getLeaderboardData(param1:String, param2:int, param3:Function = null, param4:Array = null, param5:Function = null, param6:Array = null, param7:Boolean = true) : void
      {
         var getLBData:Function;
         var leaderBoard:String = param1;
         var entryCount:int = param2;
         var onSuccessFunction:Function = param3;
         var onSuccessParams:Array = param4;
         var onFailFunction:Function = param5;
         var onFailParams:Array = param6;
         var returnDataOnSuccess:Boolean = param7;
         if(this.isUserLoggedIn())
         {
            getLBData = function(param1:String):void
            {
               var processedAlready:Boolean = false;
               var lbShortCode:String = param1;
               var req:LeaderboardDataRequest = new LeaderboardDataRequest(smGameSparks);
               req.setLeaderboardShortCode(lbShortCode);
               req.setEntryCount(entryCount);
               req.setTimeoutSeconds(GS_TIMEOUT_SEC);
               req.setDurable(Config.DURABLE_CONNECTION);
               processedAlready = false;
               req.send(function(param1:LeaderboardDataResponse):void
               {
                  var _loc2_:Object = null;
                  var _loc3_:int = 0;
                  var _loc4_:String = null;
                  if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
                  {
                     onDuplicatedResponseReceived("getLeaderboardData: " + leaderBoard);
                     return;
                  }
                  processedAlready = true;
                  if(!param1.HasErrors())
                  {
                     _loc2_ = processLeaderboardData(param1,leaderBoard);
                     _loc3_ = param1.getScriptData()["playerRank"] != null ? int(param1.getScriptData()["playerRank"]) : -1;
                     _loc3_ = !isNaN(_loc3_) ? _loc3_ : -1;
                     if(_loc2_)
                     {
                        _loc2_["ownerRank"] = _loc3_;
                        _loc4_ = param1.getLeaderboardShortCode();
                        if(lbShortCode.indexOf("PLAYER_PVP_LB_L") != -1)
                        {
                           _loc2_["league"] = String(_loc4_.split("PLAYER_PVP_LB_L")[1]).charAt(0);
                        }
                     }
                     onDDBBAccessedProcessResponse(leaderBoard,true,"getLeaderboardData","entryCount: " + entryCount,"",_loc2_,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
                  }
                  else
                  {
                     InstanceMng.getCurrentScreen().showLoadingIcon(false,false);
                     onDDBBAccessedProcessResponse(leaderBoard,false,"getLeaderboardData","entryCount: " + entryCount,"",null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
                  }
               });
            };
            this.getLeaderboardFullShortCodeByName(leaderBoard,getLBData,onFailFunction);
         }
         else
         {
            FSDebug.debugTrace("ERROR! Player not logged in / not authorized");
         }
      }
      
      public function getSocialLeaderboardData(param1:String, param2:int, param3:Boolean = false, param4:int = 20, param5:Function = null, param6:Array = null, param7:Function = null, param8:Array = null, param9:Boolean = true) : void
      {
         var leaderBoard:String = null;
         var req:* = undefined;
         var processedAlready:Boolean = false;
         var v:Vector.<String> = null;
         var levelSku:String = param1;
         var difficulty:int = param2;
         var getOnlyOwner:Boolean = param3;
         var entryCount:int = param4;
         var onSuccessFunction:Function = param5;
         var onSuccessParams:Array = param6;
         var onFailFunction:Function = param7;
         var onFailParams:Array = param8;
         var returnDataOnSuccess:Boolean = param9;
         if(this.isUserLoggedIn())
         {
            leaderBoard = "PLAYER_PVE_LB_Display.DIFFICULTY." + difficulty + ".LEVEL." + levelSku;
            if(getOnlyOwner)
            {
               v = new Vector.<String>();
               v.push(leaderBoard);
               req = new GetLeaderboardEntriesRequest(smGameSparks);
               req.setLeaderboards(v);
               req.setPlayer(this.getUserId());
            }
            else
            {
               req = new SocialLeaderboardDataRequest(smGameSparks);
               req.setSocial(true);
               req.setAttribute("dontErrorOnNotSocial",true);
               req.setLeaderboardShortCode(leaderBoard);
               req.setEntryCount(20);
            }
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:*):void
            {
               var _loc2_:Object = null;
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("getSocialLeaderboardData");
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  _loc2_ = processLeaderboardData(param1,"PLAYER_PVE_LB_Display",leaderBoard,getOnlyOwner);
                  onDDBBAccessedProcessResponse(leaderBoard,true,"getLeaderboardData","entryCount: " + entryCount,"",_loc2_,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
               }
               else
               {
                  onDDBBAccessedProcessResponse(leaderBoard,false,"getLeaderboardData","entryCount: " + entryCount,"",null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
               }
            });
         }
         else
         {
            FSDebug.debugTrace("ERROR! Player not logged in / not authorized");
         }
      }
      
      private function processLeaderboardData(param1:*, param2:String, param3:String = "", param4:Boolean = false) : Array
      {
         var _loc5_:Object = null;
         var _loc9_:int = 0;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         if(param1 is GetLeaderboardEntriesResponse)
         {
            _loc5_ = GetLeaderboardEntriesResponse(param1).getAttribute(param3) ? GetLeaderboardEntriesResponse(param1).getAttribute(param3) : null;
         }
         else if(param1 is LeaderboardDataResponse)
         {
            _loc5_ = LeaderboardDataResponse(param1).getData() ? LeaderboardDataResponse(param1).getData() : null;
            _loc6_ = LeaderboardDataResponse(param1).getScriptData().guildEmblems ? LeaderboardDataResponse(param1).getScriptData().guildEmblems : null;
            _loc7_ = LeaderboardDataResponse(param1).getScriptData().guilds ? LeaderboardDataResponse(param1).getScriptData().guilds : null;
         }
         var _loc8_:Array = _loc5_ != null && (param4 || !param4 && _loc5_.length > 0) ? new Array() : null;
         if(_loc8_ != null)
         {
            if(param4 && Boolean(_loc5_.userId))
            {
               _loc8_[_loc9_] = new Object();
               _loc8_[_loc9_]._id = _loc5_.userId;
               _loc8_[_loc9_].playerName = _loc5_.userName;
               _loc8_[_loc9_].score = _loc5_.SCORE;
               _loc8_[_loc9_].level = _loc5_.LEVEL;
               _loc8_[_loc9_].difficulty = _loc5_.DIFFICULTY;
               _loc8_[_loc9_].rank = _loc5_.rank;
            }
            else
            {
               _loc9_ = 0;
               _loc9_ = 0;
               while(_loc9_ < _loc5_.length)
               {
                  _loc8_[_loc9_] = new Object();
                  switch(param2)
                  {
                     case "PLAYER_PVP_LB_Display":
                     case "PLAYER_PVP_LB_L1_Display":
                     case "PLAYER_PVP_LB_L2_Display":
                     case "PLAYER_PVP_LB_L3_Display":
                        _loc8_[_loc9_]._id = new Object();
                        _loc8_[_loc9_]._id.$oid = _loc5_[_loc9_].getUserId();
                        _loc8_[_loc9_].playerName = _loc5_[_loc9_].getUserName();
                        _loc8_[_loc9_].elo = _loc5_[_loc9_].getAttribute("SCORE");
                        _loc8_[_loc9_].matchesWon = _loc5_[_loc9_].getAttribute("victories");
                        if(_loc5_[_loc9_].getAttribute("GUILD_ID") != null)
                        {
                           _loc8_[_loc9_].guildId = _loc5_[_loc9_].getAttribute("GUILD_ID");
                        }
                        else if(Boolean(_loc7_) && _loc7_[_loc8_[_loc9_]._id.$oid] != null)
                        {
                           _loc8_[_loc9_].guildId = _loc7_[_loc8_[_loc9_]._id.$oid];
                        }
                        break;
                     case "PLAYER_PVE_LB_Display":
                        _loc8_[_loc9_]._id = new Object();
                        _loc8_[_loc9_]._id.$oid = _loc5_[_loc9_].getUserId();
                        _loc8_[_loc9_].uid = _loc5_[_loc9_].getUserId();
                        _loc8_[_loc9_].playerName = _loc5_[_loc9_].getUserName();
                        _loc8_[_loc9_].score = _loc5_[_loc9_].getAttribute("SCORE");
                        _loc8_[_loc9_].level = _loc5_[_loc9_].getAttribute("LEVEL");
                        _loc8_[_loc9_].difficulty = _loc5_[_loc9_].getAttribute("DIFFICULTY");
                        _loc8_[_loc9_].rank = _loc5_[_loc9_].getAttribute("rank");
                        break;
                     case "PLAYER_DUNGEONS_LB_Display":
                        _loc8_[_loc9_]._id = new Object();
                        _loc8_[_loc9_]._id.$oid = _loc5_[_loc9_].getUserId();
                        _loc8_[_loc9_].playerName = _loc5_[_loc9_].getUserName();
                        _loc8_[_loc9_].dungeonsWon = _loc5_[_loc9_].getAttribute("SCORE");
                        break;
                     case "GUILD_GLOBAL_PVP_LB":
                        _loc8_[_loc9_]._id = new Object();
                        _loc8_[_loc9_]._id.$oid = _loc5_[_loc9_].getUserId();
                        _loc8_[_loc9_].name = _loc5_[_loc9_].getAttribute("teamName");
                        break;
                     case "GUILD_PVE_LB":
                        _loc8_[_loc9_]._id = new Object();
                        _loc8_[_loc9_]._id.$oid = _loc5_[_loc9_].getUserId();
                        _loc8_[_loc9_].name = _loc5_[_loc9_].getAttribute("teamName");
                        break;
                     case "GUILD_WEEKLY_TOTAL_LB_Display":
                        _loc8_[_loc9_].name = _loc5_[_loc9_].getAttribute("teamName");
                        _loc8_[_loc9_].weeklyTotalScore = _loc5_[_loc9_].getAttribute("SUM-SCORE");
                        _loc8_[_loc9_]._id = new Object();
                        _loc8_[_loc9_]._id.$oid = _loc5_[_loc9_].getAttribute("teamId");
                        if(Boolean(_loc6_) && _loc6_[_loc5_[_loc9_].getAttribute("teamId")] != null)
                        {
                           _loc8_[_loc9_].emblemFG = _loc6_[_loc5_[_loc9_].getAttribute("teamId")].emblemFG;
                           _loc8_[_loc9_].emblemBG = _loc6_[_loc5_[_loc9_].getAttribute("teamId")].emblemBG;
                        }
                        break;
                     case "GUILD_GLOBAL_TOTAL_MEMBERS_LB":
                        _loc8_[_loc9_]._id = new Object();
                        _loc8_[_loc9_]._id.$oid = _loc5_[_loc9_].getUserId();
                        _loc8_[_loc9_].playerName = _loc5_[_loc9_].getUserName();
                        _loc8_[_loc9_].playerId = _loc5_[_loc9_].getUserId();
                        _loc8_[_loc9_].score = _loc5_[_loc9_].getAttribute("SUM-SCORE");
                        break;
                     case "GUILD_GLOBAL_TOTAL_LB":
                        _loc8_[_loc9_].name = _loc5_[_loc9_].getAttribute("teamName");
                        _loc8_[_loc9_].globalTotalScore = _loc5_[_loc9_].getAttribute("SUM-SCORE");
                        _loc8_[_loc9_]._id = new Object();
                        _loc8_[_loc9_]._id.$oid = _loc5_[_loc9_].getAttribute("teamId");
                        if(Boolean(_loc6_) && _loc6_[_loc5_[_loc9_].getAttribute("teamId")] != null)
                        {
                           _loc8_[_loc9_].emblemFG = _loc6_[_loc5_[_loc9_].getAttribute("teamId")].emblemFG;
                           _loc8_[_loc9_].emblemBG = _loc6_[_loc5_[_loc9_].getAttribute("teamId")].emblemBG;
                        }
                        break;
                     case "GUILD_GLOBAL_DUNGEONS_LB":
                        _loc8_[_loc9_].name = _loc5_[_loc9_].getAttribute("teamName");
                        _loc8_[_loc9_]._id = new Object();
                        _loc8_[_loc9_]._id.$oid = _loc5_[_loc9_].getAttribute("teamId");
                  }
                  _loc9_++;
               }
            }
         }
         return _loc8_;
      }
      
      private function refreshTimeVars(param1:Object) : void
      {
         if(param1)
         {
            ServerConnection.smServerTimeMS = Number(param1);
         }
      }
      
      public function updateProfileField(param1:String, param2:String) : void
      {
         this.updateProfileInDDBB(null,param1,param2,false);
      }
      
      public function shareGoldPurchasedWithGuild(param1:int, param2:GoldDef) : void
      {
         if(Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) && InstanceMng.getUserDataMng().getOwnerUserData().flagsGetShareInfoToGuild())
         {
            this.giveGoldToGuildMembers(param1);
         }
      }
      
      public function consumeProductInGS(param1:String, param2:String = "", param3:Boolean = false, param4:Function = null, param5:Array = null, param6:Function = null, param7:Array = null) : void
      {
         var shortCode:String = null;
         var isKong:Boolean = false;
         var prodIdFormatted:String = null;
         var req:ConsumeVirtualGoodRequest = null;
         var processedAlready1:Boolean = false;
         var kongUseItemReq:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var prodId:String = param1;
         var sku:String = param2;
         var isGift:Boolean = param3;
         var onSuccessFunction:Function = param4;
         var onSuccessParams:Array = param5;
         var onFailFunction:Function = param6;
         var onFailParams:Array = param7;
         shortCode = prodId != "" ? prodId : sku;
         if(shortCode != "")
         {
            isKong = InstanceMng.getApplication().isKongregateVersion();
            prodIdFormatted = isKong && shortCode.indexOf("-") != -1 ? String(shortCode.replace("-",".")).split(".")[1].toUpperCase() : String(shortCode.split(".")[1]).toUpperCase();
            prodIdFormatted = isGift ? shortCode : prodIdFormatted;
            prodIdFormatted = shortCode.indexOf("cards.") != -1 ? prodIdFormatted.toLowerCase() : prodIdFormatted;
            if(prodIdFormatted != "" && prodIdFormatted != null)
            {
               if(this.isUserLoggedIn())
               {
                  if(isKong && isGift)
                  {
                     req = new ConsumeVirtualGoodRequest(smGameSparks);
                     req.setQuantity(1);
                     req.setShortCode(prodIdFormatted);
                     req.setTimeoutSeconds(GS_TIMEOUT_SEC);
                     req.setDurable(Config.DURABLE_CONNECTION);
                     processedAlready1 = false;
                     req.send(function(param1:ConsumeVirtualGoodResponse):void
                     {
                        if(processedAlready1 && Config.SKIP_DUPLICATED_RESPONSES)
                        {
                           onDuplicatedResponseReceived("consumeProductInGS: " + prodId);
                           return;
                        }
                        processedAlready1 = true;
                        if(!param1.HasErrors())
                        {
                           onDDBBAccessedProcessResponse(prodId,true,"consumeProductInGS",shortCode,"",null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams);
                        }
                        else
                        {
                           onDDBBAccessedProcessResponse(prodId,false,"consumeProductInGS",shortCode,"",null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams);
                        }
                     });
                  }
                  else
                  {
                     kongUseItemReq = new LogEventRequest(smGameSparks);
                     kongUseItemReq.setEventKey("USE_ITEM");
                     kongUseItemReq.setAttribute("vGood",prodIdFormatted);
                     kongUseItemReq.setTimeoutSeconds(GS_TIMEOUT_SEC);
                     kongUseItemReq.setDurable(Config.DURABLE_CONNECTION);
                     processedAlready = false;
                     kongUseItemReq.send(function(param1:LogEventResponse):void
                     {
                        if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
                        {
                           onDuplicatedResponseReceived("consumeProductInGS: " + prodIdFormatted);
                           return;
                        }
                        processedAlready = true;
                        if(!param1.HasErrors())
                        {
                           onDDBBAccessedProcessResponse(prodId,true,"consumeProductInGS",shortCode,"",null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams);
                        }
                        else
                        {
                           onDDBBAccessedProcessResponse(prodId,false,"consumeProductInGS",shortCode,"",null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams);
                        }
                     });
                  }
               }
               else
               {
                  this.onDDBBAccessedProcessResponse(prodId,false,"consumeProductInGS",shortCode,"",null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams);
               }
            }
            else
            {
               this.onDDBBAccessedProcessResponse(prodId,false,"consumeProductInGS",shortCode,"",null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams);
            }
         }
      }
      
      public function isUserLoggedIn() : Boolean
      {
         var _loc1_:Boolean = false;
         _loc1_ = smGameSparks.isAuthenticated();
         return Utils.smInternetAvailable && (_loc1_ || smPlayerLoggedIn);
      }
      
      public function getBackendUserProfile() : *
      {
         return smServerUserObject;
      }
      
      public function getUserId() : String
      {
         return this.getBackendUserProfile() ? this.getBackendUserProfile()._id : "";
      }
      
      public function refreshServerTime() : void
      {
         if(this.isUserLoggedIn() && Boolean(this.getBackendUserProfile()))
         {
            this.getServerTime(this.onServerTimeACK);
         }
         else
         {
            FSDebug.debugTrace("Couldn\'t get server time");
            FSDebug.debugTrace("Utils.smInternetAvailable => " + Utils.smInternetAvailable.toString());
            FSDebug.debugTrace("isUserLoggedIn() => " + this.isUserLoggedIn().toString());
            FSDebug.debugTrace("getBackendUserProfile() != null? => " + (this.getBackendUserProfile() != null).toString());
         }
      }
      
      public function onServerTimeACK(param1:Object) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:String = null;
         var _loc4_:Number = NaN;
         if(param1)
         {
            _loc2_ = Number(param1);
            _loc3_ = "";
            if(_loc2_ != -1 && _loc3_ != "" || _loc2_ == -1 && _loc3_ != "" || _loc2_ != -1)
            {
               smServerDate = TimerUtil.dateFromMs(_loc2_);
               if(smServerDate)
               {
                  _loc4_ = smServerDate.getTime();
                  smServerTimeMS = _loc4_;
                  if(smServerTimeTimer)
                  {
                     smServerTimeTimer.stop();
                  }
                  if(smServerTimeTimer == null)
                  {
                     smServerTimeTimer = new Timer(1000,1);
                     smServerTimeTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete,false,0,true);
                  }
                  smServerTimeTimer.start();
               }
            }
         }
      }
      
      public function onTimerComplete(param1:TimerEvent) : void
      {
         if(smServerTimeMS != -1)
         {
            smServerTimeMS += TimerUtil.secondToMs(1);
            Utils.getFormattedUTCServerTime();
            if(smServerTimeTimer)
            {
               smServerTimeTimer.start();
            }
         }
      }
      
      public function onLogin(param1:Boolean) : void
      {
         var _loc2_:Popup = null;
         var _loc3_:Boolean = false;
         var _loc4_:Function = null;
         var _loc5_:Boolean = false;
         FSDebug.debugTrace("ON LOGIN -> online? : " + param1);
         Utils.smInternetAvailable = param1;
         if(param1 && Config.getConfig().getModeOnline())
         {
            this.mPlayerWasOnlineOnce = true;
            this.mDualLoginDetected = false;
            this.mRefreshedSessionsAttemtps = 0;
            this.refreshServerTime();
            Main.smOfflineUserData = InstanceMng.getUserDataMng() ? InstanceMng.getUserDataMng().getOwnerUserData() : null;
            InstanceMng.getApplication().createOnlineUserDataMng();
            InstanceMng.getApplication().addServerEventListeners();
            InstanceMng.getApplication().registerUserDataMng();
            InstanceMng.getUserDataMng().getOwnerUserData().setPurchasesAmount(this.mServerPlayerPurchasesAmount);
            InstanceMng.getUserDataMng().getOwnerUserData().setInBlackList(smServerPlayerBlacklisted);
            InstanceMng.getUserDataMng().getOwnerUserData().setInDuplicatedList(smServerPlayerDuplicated);
            InstanceMng.getUserDataMng().getOwnerUserData().setIsVIP(this.mServerPlayerVIP);
            InstanceMng.getUserDataMng().getOwnerUserData().setIsDev(this.mServerPlayerDev);
            InstanceMng.getUserDataMng().getOwnerUserData().setIsOldPlayerComingBack(this.smServerIsOldPlayerComingBack);
            InstanceMng.getUserDataMng().getOwnerUserData().setReferralCode(this.mServerPlayerReferralCode);
            InstanceMng.getUserDataMng().getOwnerUserData().setTransferCode(this.mServerPlayerTransferCode);
            InstanceMng.getUserDataMng().getOwnerUserData().setReferrals(smServerPlayerReferrals);
            if(Config.getConfig().hasQuests() && Boolean(InstanceMng.getQuestsMng()))
            {
               InstanceMng.getQuestsMng().getQuestsUnlocked();
               InstanceMng.getQuestsMng().getQuestsUnlocked(true);
            }
            _loc3_ = InstanceMng.getFacebookPlugin() ? InstanceMng.getFacebookPlugin().isSessionOpen() : false;
            if(_loc3_)
            {
               this.onFBLoginSuccessful();
            }
            else if(InstanceMng.getApplication().isKongregateVersion())
            {
               this.onKongLoginSuccessful();
            }
            this.onLoginRequestServerInfo();
            InstanceMng.getApplication().firebaseSetUserData(InstanceMng.getUserDataMng().getOwnerUserData().getName(),InstanceMng.getUserDataMng().getOwnerUserData().getAccountId());
            InstanceMng.getApplication().firebaseOnLogin();
         }
         else
         {
            this.checkGameVersion();
         }
         if(Utils.isIOS() && InstanceMng.getApplication().hasUserSignedIntoApple())
         {
            this.refreshAppleTokens();
         }
         Utils.setLogText(TextManager.getText("TID_SERVER_LOADING_INFO"),false,true,false,false);
         _loc2_ = InstanceMng.getPopupMng().getPopupShown();
         if(_loc2_ is PopupError)
         {
            _loc4_ = null;
            if(Config.allowKeepPlayingAfterDisconnection())
            {
               if(InstanceMng.getPopupMng().getPopupInBackground())
               {
                  _loc4_ = InstanceMng.getPopupMng().getPopupInBackground().openPopup;
               }
            }
            _loc2_.closePopup(_loc4_);
         }
         if(!this.mFirstMusicAlreadyPlayed && Config.smTracklistModeOn && Utils.isMusicOn() && Utils.getLastMusic() == "")
         {
            if(Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
            {
               _loc5_ = InstanceMng.getUserDataMng().getOwnerUserData().flagsGetMusic();
               if(_loc5_)
               {
                  this.mFirstMusicAlreadyPlayed = true;
                  Utils.addTrackList(InstanceMng.getResourcesMng().getSoundTrack());
                  Utils.loadNextTrack();
               }
            }
         }
      }
      
      private function refreshAppleTokens() : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         if(this.isUserLoggedIn())
         {
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("APPLE_REFRESH_TOKENS");
            req.setAttribute("CLIENT_ID",Utils.getBundleId());
            req.setAttribute("REFRESH_TOKEN",Utils.getSharedObjData("refreshToken"));
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               var _loc2_:String = null;
               var _loc3_:Object = null;
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  return;
               }
               processedAlready = true;
               _loc2_ = "appleSignIn";
               if(!param1.HasErrors())
               {
                  _loc3_ = param1.getScriptData() ? param1.getScriptData().data : null;
                  onDDBBAccessedProcessResponse(_loc2_,true,"refreshAppleTokens","","",_loc3_);
               }
               else
               {
                  onDDBBAccessedProcessResponse(_loc2_,false,"refreshAppleTokens","","",null);
                  InstanceMng.getApplication().appleSignInRevokeAccess();
                  handleErrorConnectingWithServer(_loc2_,null,param1.getErrors());
               }
            });
         }
         else
         {
            FSDebug.debugTrace("ERROR! Player not logged in / not authorized");
         }
      }
      
      private function onLoginRequestServerInfo() : void
      {
         var onProductsReceived:Function = null;
         var onGameVersionChecked:Function = null;
         var checkServerInfoReceived:Function = null;
         onProductsReceived = function():void
         {
            checkGameVersion(true,true,onGameVersionChecked);
         };
         onGameVersionChecked = function():void
         {
            smServerInfoReceived = true;
            clearTimeout(mCheckServerInfoTimer);
            if(InstanceMng.getUserDataMng())
            {
               InstanceMng.getUserDataMng().persistenceSaveData();
            }
            Utils.setLogText(TextManager.getText("TID_GEN_LOGGED_IN"),false,false,false,false,1,Align.CENTER,Align.TOP,null,false,0.5);
            if(InstanceMng.getCurrentScreen())
            {
               InstanceMng.getCurrentScreen().setOnlineDataSynced(true);
            }
            if(InstanceMng.getCurrentScreen() is FSMenuScreen)
            {
               FSMenuScreen(InstanceMng.getCurrentScreen()).refreshButtons();
            }
            scheduleAwayNotifications();
            getProductPricesInUSD();
         };
         checkServerInfoReceived = function():void
         {
            if(!smServerInfoReceived)
            {
               Utils.setLogText("Issues detected gathering server information, trying again in 3 seconds",false,true,false,false);
               setTimeout(onLoginRequestServerInfo,3000);
            }
         };
         smServerInfoReceived = false;
         clearTimeout(this.mCheckServerInfoTimer);
         this.mCheckServerInfoTimer = setTimeout(checkServerInfoReceived,10000);
         if(!InstanceMng.getApplication().getInAppsManager().areProductsRequested())
         {
            this.getProducts(onProductsReceived);
         }
         else
         {
            onProductsReceived();
         }
         this.addBackendEventHandlers();
      }
      
      private function scheduleAwayNotifications() : void
      {
         InstanceMng.getApplication().scheduleNotifications(TimerUtil.msToSec(TimerUtil.daysToMs(3)),Constants.NOTIF_3_DAYS);
         InstanceMng.getApplication().scheduleNotifications(TimerUtil.msToSec(TimerUtil.daysToMs(10)),Constants.NOTIF_10_DAYS);
         InstanceMng.getApplication().scheduleNotifications(TimerUtil.msToSec(TimerUtil.daysToMs(100)),Constants.NOTIF_100_DAYS);
      }
      
      private function checkPvP() : void
      {
         var onMatchInfoACK:Function = null;
         var onMatchInfoError:Function = null;
         onMatchInfoACK = function(param1:Object):void
         {
            var _loc2_:Boolean = false;
            _loc2_ = param1 != null && param1.a == PvPConnectionMng.ACTION_SURRENDER && param1["ua"] == getUserId();
            if(_loc2_)
            {
               FSDebug.debugTrace("Owner was offline too long");
               Root.assets.purgeQueue();
               Utils.setLogText(TextManager.getText("TID_GEN_DESYNC"),true,true);
               BattleEnginePvP.pvpDesyncPlayerForInactivity(false);
            }
            else
            {
               BattleEnginePvP(InstanceMng.getBattleEngine()).onMatchInfoACK(param1);
            }
         };
         onMatchInfoError = function():void
         {
            if(PvPConnectionMng.smExpirationTimeLeft < 0)
            {
               FSDebug.debugTrace("Owner was offline too long (ERROR RETURNED WHEN ATTEMPTING TO UPDATE MATCH!");
               Root.assets.purgeQueue();
               Utils.setLogText(TextManager.getText("TID_GEN_DESYNC"),true,true);
               BattleEnginePvP.pvpDesyncPlayerForInactivity(false);
            }
         };
         if(Boolean(InstanceMng.getBattleEngine()) && InstanceMng.getBattleEngine().isOnlineMatch())
         {
            if(PvPConnectionMng.smCurrentMatchId != "" && PvPConnectionMng.smCurrentMatchId != null)
            {
               this.searchInCollectionById("matches",PvPConnectionMng.smCurrentMatchId,onMatchInfoACK,null,onMatchInfoError);
            }
         }
      }
      
      public function onFBLoginSuccessful() : void
      {
         var _loc1_:UserDataMng = null;
         _loc1_ = InstanceMng.getUserDataMng();
         if(Boolean(_loc1_) && Boolean(_loc1_.getOwnerUserData()))
         {
            _loc1_.getOwnerUserData().setExtId(InstanceMng.getFacebookPlugin().getFBId());
            _loc1_.getOwnerUserData().setExtPlatform(UserDataMng.EXT_PLATFORM_FB);
            _loc1_.updatePlayerExtId();
            if(_loc1_.getOwnerUserData() != null)
            {
               _loc1_.getOwnerUserData().setPhotoTexture(null);
            }
            if(InstanceMng.getApplication().mapScreenHasBeenVisited())
            {
               _loc1_.purgeFriendsData();
               InstanceMng.getUserDataMng().setHasRequestedFriends(true);
               this.getFriendsWhoPlay();
               InstanceMng.getFacebookPlugin().getInvitableFriendsList();
            }
            if(InstanceMng.getCurrentScreen() is FSMenuScreen)
            {
               FSMenuScreen(InstanceMng.getCurrentScreen()).refreshButtons();
            }
            else if(InstanceMng.getCurrentScreen() is FSMapScreen)
            {
               FSMapScreen(InstanceMng.getCurrentScreen()).refreshMap();
            }
            if(Config.GAME_NOTIFICATIONS_ENABLED)
            {
               setTimeout(this.syncFBNotifications,5000);
            }
         }
      }
      
      public function syncFBNotifications() : void
      {
         if(InstanceMng.getFacebookPlugin())
         {
            InstanceMng.getFacebookPlugin().getFBNotificationsFromFB();
         }
      }
      
      public function onConnectionOK() : void
      {
         var doLogin:Function = null;
         var minSeconds:int = 0;
         var currentTimeMS:Number = NaN;
         doLogin = function():void
         {
            var _loc1_:* = undefined;
            if(Root.smRootInitialized)
            {
               FSDebug.debugTrace("[onConnection] - Attempting to login");
               _loc1_ = InstanceMng.getApplication().getKongregatePlugin();
               if(Boolean(InstanceMng.getApplication().isKongregateVersion()) && Boolean(_loc1_) && !_loc1_.isInitialized())
               {
                  _loc1_.initialize();
               }
               else
               {
                  loginUser();
               }
            }
            else
            {
               FSDebug.debugTrace("[onConnection] - Root not initialized yet, trying again in 1s");
               setTimeout(doLogin,1000);
            }
         };
         var onGameVersionACK:Function = function(param1:Object):void
         {
            if(param1)
            {
               if(smPlayerDeviceLoginKey != null && smPlayerDeviceLoginKey != "" && param1["loginTracker"] != null && param1["loginTracker"] != "")
               {
                  if(param1["loginTracker"] != smPlayerDeviceLoginKey)
                  {
                     handleSessionTerminated(null,"ERR:#002");
                  }
                  else if(isUserLoggedIn() && Boolean(InstanceMng.getUserDataMng()))
                  {
                     FSDebug.debugTrace("[onConnection] - User logged in, saving data");
                     InstanceMng.getUserDataMng().persistenceSaveData();
                  }
               }
               else if(isUserLoggedIn() && Boolean(InstanceMng.getUserDataMng()))
               {
                  FSDebug.debugTrace("[onConnection] - User logged in, saving data");
                  InstanceMng.getUserDataMng().persistenceSaveData();
               }
            }
         };
         if(!this.mSteamDisconnected && (!Utils.smInternetAvailable || !this.wasPlayerEverOnline()))
         {
            minSeconds = 5;
            currentTimeMS = TimerUtil.currentTimeMillis();
            if(this.mLastOnlineLoginAttempt > currentTimeMS - TimerUtil.secondToMs(minSeconds) && !this.mRecoveringFromAlternativeAccount)
            {
               FSDebug.debugTrace("Less than " + minSeconds + " seconds since disconnection");
               return;
            }
            this.mLastOnlineLoginAttempt = TimerUtil.currentTimeMillis();
            if(!smGameSparksConnected)
            {
               this.initializeBackEnd();
            }
            smGameSparks.getMessageHandler().setSessionTerminatedMessageHandler(this.handleSessionTerminated);
            FSDebug.debugTrace("[onConnection] - Internet connection AVAILABLE");
            Utils.smInternetAvailable = true;
            if(!this.isUserLoggedIn() || !Utils.isIOS())
            {
               doLogin();
            }
            else
            {
               this.onPlayerAuthenticatedGetInfo();
            }
            this.checkPvP();
         }
         else if(InstanceMng.getCurrentScreen())
         {
            InstanceMng.getCurrentScreen().onConnectionChange();
         }
      }
      
      public function onConnectionKO() : void
      {
         var _loc1_:Popup = null;
         FSDebug.debugTrace("[onConnection] - Internet connection NOT available (KO)");
         Utils.smInternetAvailable = false;
         if((!Config.USE_OFFLINE_DB || Utils.isDesktop()) && !this.wasDualConnectionDetected())
         {
            this.mSteamDisconnected = true;
            _loc1_ = InstanceMng.getPopupMng().getPopupShown();
            if(_loc1_ == null || _loc1_ != null && !(_loc1_ is PopupError))
            {
               this.handlePopupsOnDisconnectionEvent();
            }
         }
         if(smGameSparksConnected && Utils.isMobile() && !Config.DURABLE_CONNECTION)
         {
            smGameSparksConnected = false;
            smGameSparks.disconnect();
         }
         this.checkGameVersion();
         InstanceMng.getApplication().checkInternetConnection();
      }
      
      public function checkGameVersion(param1:Boolean = true, param2:Boolean = false, param3:Function = null) : void
      {
         if(this.isUserLoggedIn())
         {
            TweenMax.delayedCall(3,this.gamePlayableTimeout,[param1,param3]);
            this.getServerConfig(param2,param3,null,param1);
            if(InstanceMng.getCurrentScreen())
            {
               InstanceMng.getCurrentScreen().onConnectionChange();
            }
         }
         else
         {
            Main.smGamePlayable = true;
            if(InstanceMng.getCurrentScreen())
            {
               InstanceMng.getCurrentScreen().onConnectionChange();
            }
            if(this.mLoginErrorsCount > 3)
            {
               if(Utils.isBrowser())
               {
                  Utils.setLogText("Issues login-in detected. Make sure no Ad-Blockers addons are running. If the issue persists try refreshing the browser",true,false,false);
               }
            }
         }
      }
      
      private function onConfigACKCheckIfGamePlayable(param1:String, param2:String, param3:Boolean, param4:String) : void
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Boolean = false;
         _loc7_ = false;
         if(!InstanceMng.getApplication().isGamePlayable())
         {
            if(Utils.isBrowser())
            {
               _loc5_ = "TID_GEN_UPDATE_NEEDED_BROWSER";
               _loc6_ = TextManager.replaceParameters(_loc5_,[param1]);
            }
            else if(InstanceMng.getApplication().areExpansionFilesOK())
            {
               _loc5_ = "TID_GEN_UPDATE_NEEDED";
               _loc6_ = TextManager.replaceParameters(_loc5_,[param1]);
               _loc6_ = _loc6_ + (Utils.isDesktop() ? " (" + TextManager.getText("TID_GEN_UPDATE_STEAM") + ")" : "");
               _loc7_ = true;
            }
            else if(InstanceMng.getApplication().isExpansionFilesDowloading())
            {
               _loc6_ = "Downloading assets, please hold";
            }
            else if(InstanceMng.getApplication().isExpansionFilesRequestingAccess())
            {
               _loc6_ = "Requesting permissions";
            }
            else
            {
               _loc6_ = InstanceMng.getApplication().getExpansionFileLastStateExplanation() + " " + TextManager.getText("TID_GEN_SDCARD_ERROR");
            }
            if(!param3)
            {
               _loc6_ = param4;
               _loc7_ = false;
            }
            if(InstanceMng.getPopupMng().getPopupShown())
            {
               if(!InstanceMng.getPopupMng().getPopupShown() is PopupError)
               {
                  InstanceMng.getPopupMng().getPopupShown().closePopup();
               }
            }
            InstanceMng.getPopupMng().openErrorPopup(_loc6_,false,_loc7_,_loc7_);
         }
         else if(param2 < param1)
         {
            Utils.setLogText(TextManager.getText("TID_GEN_UPDATE_AVAILABLE"));
         }
         InstanceMng.getCurrentScreen().onConnectionChange();
         Utils.removeLog();
      }
      
      public function onKongLoginSuccessful() : void
      {
         if(InstanceMng.getApplication().isKongregateVersion())
         {
            if(Config.GAME_NOTIFICATIONS_ENABLED)
            {
               setTimeout(this.getNotifications,5000);
            }
            this.sendKongStatsOnStart();
         }
      }
      
      public function gamePlayableTimeout(param1:Boolean = true, param2:Function = null) : void
      {
         var _loc3_:Boolean = false;
         if(Utils.isBrowser())
         {
            Utils.setLogText("Issues login-in detected. Make sure no Ad-Blockers addons are running. If the issue persists try refreshing the browser",true,false,false);
            TweenMax.killDelayedCallsTo(this.checkGameVersion);
            this.checkGameVersion(param1,false,param2);
         }
         else
         {
            _loc3_ = true;
            if(Utils.isAndroid())
            {
               _loc3_ = InstanceMng.getApplication().hasToCheckObbFiles() ? InstanceMng.getApplication().areExpansionFilesOK() : true;
            }
            else if(Utils.isDesktop())
            {
               if(InstanceMng.getApplication().steamGetSessionTicket() == "")
               {
                  _loc3_ = InstanceMng.getApplication().steamGetSessionTicket() != "";
               }
            }
            Main.smGamePlayable = _loc3_;
            if(InstanceMng.getCurrentScreen())
            {
               InstanceMng.getCurrentScreen().onConnectionChange(false);
            }
         }
      }
      
      public function getFriendsWhoPlay(param1:Function = null) : void
      {
         var req:ListGameFriendsRequest = null;
         var processedAlready:Boolean = false;
         var onFriendsWhoPlayResponse:Function = null;
         var callback:Function = param1;
         onFriendsWhoPlayResponse = function(param1:ListGameFriendsResponse):void
         {
            if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
            {
               onDuplicatedResponseReceived("getFriendsWhoPlay");
               return;
            }
            processedAlready = true;
            if(!param1.HasErrors())
            {
               FSDebug.debugTrace("OK onFriendsWhoPlayResponse");
               if(InstanceMng.getUserDataMng())
               {
                  InstanceMng.getUserDataMng().onFriendsReceivedGS(param1.getFriends(),param1.getScriptData().friendsExtraPrivateData);
                  if(callback != null)
                  {
                     callback.apply();
                  }
               }
            }
            else if(Boolean(param1.getErrors()) && param1.getErrors().hasOwnProperty("error"))
            {
               FSDebug.debugTrace("Error: " + param1.getErrors().error);
            }
         };
         req = smGameSparks.getRequestBuilder().createListGameFriendsRequest();
         req.setTimeoutSeconds(GS_TIMEOUT_SEC);
         req.setDurable(Config.DURABLE_CONNECTION);
         processedAlready = false;
         req.send(onFriendsWhoPlayResponse);
      }
      
      public function leaveGuild(param1:String, param2:Function) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var guildId:String = param1;
         var onSuccessFunction:Function = param2;
         req = smGameSparks.getRequestBuilder().createLogEventRequest();
         req.setEventKey("GUILDS_LEAVE");
         req.setTimeoutSeconds(GS_TIMEOUT_SEC);
         req.setDurable(Config.DURABLE_CONNECTION);
         processedAlready = false;
         req.send(function onGuildLeft(param1:LogEventResponse):void
         {
            if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
            {
               onDuplicatedResponseReceived("leaveGuild");
               return;
            }
            processedAlready = true;
            if(!param1.HasErrors())
            {
               if(onSuccessFunction != null)
               {
                  onSuccessFunction();
               }
            }
            else
            {
               FSDebug.debugTrace("There was an issue leaving the current guild");
            }
         });
      }
      
      public function replaceGuildMaster(param1:String, param2:String, param3:Function = null, param4:Function = null) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var guildId:String = param1;
         var playerId:String = param2;
         var onSuccessFunction:Function = param3;
         var onFailFunction:Function = param4;
         if(this.isUserLoggedIn() && InstanceMng.getGuildsMng().getMyGuild().hasPrivilegesForManaging())
         {
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("GUILDS_REPLACE_LEADER");
            req.setAttribute("GUILD_ID",guildId);
            req.setAttribute("UID",playerId);
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("replaceGuildMaster");
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  onDDBBAccessedProcessResponse("guildMembers",true,"replaceGuildMaster","",guildId,null,onSuccessFunction,null,onFailFunction);
               }
               else
               {
                  onDDBBAccessedProcessResponse("guildMembers",false,"replaceGuildMaster","",guildId,null,onSuccessFunction,null,onFailFunction);
               }
            });
         }
         else
         {
            this.onDDBBAccessedProcessResponse("guildMembers",false,"replaceGuildMaster","",guildId,null,onSuccessFunction,null,onFailFunction);
         }
      }
      
      public function joinGuild(param1:String, param2:Function = null, param3:Function = null, param4:Boolean = false) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var guildId:String = param1;
         var onSuccessFunction:Function = param2;
         var onFailFunction:Function = param3;
         var isAccessViaRequest:Boolean = param4;
         if(this.isUserLoggedIn())
         {
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("GUILDS_JOIN");
            req.setAttribute("GUILD_ID",guildId);
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               var _loc2_:Array = null;
               var _loc3_:String = null;
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("joinGuild");
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  if(isAccessViaRequest)
                  {
                     _loc2_ = [{"guildId":guildId}];
                  }
                  else
                  {
                     _loc3_ = param1.getScriptData() ? param1.getScriptData().guildMemberId : "";
                     _loc2_ = [guildId,_loc3_];
                  }
                  onDDBBAccessedProcessResponse("guilds",true,"joinGuild","",guildId,null,onSuccessFunction,_loc2_,onFailFunction);
               }
               else
               {
                  onDDBBAccessedProcessResponse("guilds",false,"joinGuild","",guildId,null,onSuccessFunction,null,onFailFunction);
               }
            });
         }
         else
         {
            this.onDDBBAccessedProcessResponse("guilds",false,"joinGuild","",guildId,null,onSuccessFunction,null,onFailFunction);
         }
      }
      
      public function editGuildMemberRank(param1:String, param2:int, param3:String, param4:Function = null, param5:Function = null) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var guildId:String = param1;
         var rank:int = param2;
         var playerId:String = param3;
         var onSuccessFunction:Function = param4;
         var onFailFunction:Function = param5;
         if(Boolean(this.isUserLoggedIn() && InstanceMng.getGuildsMng()) && Boolean(InstanceMng.getGuildsMng().getMyGuild()) && InstanceMng.getGuildsMng().getMyGuild().hasPrivilegesForManaging())
         {
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("EDIT_GUILD_MEMBER_RANK");
            req.setAttribute("GUILD_ID",guildId);
            req.setAttribute("RANK",rank);
            req.setAttribute("UID",playerId);
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("editGuildMemberRank");
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  onDDBBAccessedProcessResponse("guildMembers",true,"editGuildMemberRank","",guildId,null,onSuccessFunction,null,onFailFunction);
               }
               else
               {
                  onDDBBAccessedProcessResponse("guildMembers",false,"editGuildMemberRank","",guildId,null,onSuccessFunction,null,onFailFunction);
               }
            });
         }
         else
         {
            this.onDDBBAccessedProcessResponse("guildMembers",false,"editGuildMemberRank","",guildId,null,onSuccessFunction,null,onFailFunction);
         }
      }
      
      public function acceptJoinGuildRequest(param1:String, param2:String, param3:Function = null, param4:Function = null) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var guildId:String = param1;
         var playerId:String = param2;
         var onSuccessFunction:Function = param3;
         var onFailFunction:Function = param4;
         if(this.isUserLoggedIn() && InstanceMng.getGuildsMng().getMyGuild().hasPrivilegesForManaging())
         {
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("GUILDS_ACCEPT_JOIN_REQ");
            req.setAttribute("GUILD_ID",guildId);
            req.setAttribute("UID",playerId);
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               var _loc2_:String = null;
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("acceptJoinGuildRequest");
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  _loc2_ = param1.getScriptData() ? param1.getScriptData().guildMemberId : "";
                  onDDBBAccessedProcessResponse("guilds",true,"acceptJoinGuildRequest","",guildId,null,onSuccessFunction,[guildId,_loc2_],onFailFunction);
               }
               else if(Boolean(param1.getErrors()) && param1.getErrors().hasOwnProperty("error"))
               {
                  onDDBBAccessedProcessResponse("guilds",false,"acceptJoinGuildRequest","",guildId,null,onSuccessFunction,null,onFailFunction,[param1.getErrors().error]);
               }
               else
               {
                  onDDBBAccessedProcessResponse("guilds",false,"acceptJoinGuildRequest","",guildId,null,onSuccessFunction,null,onFailFunction);
               }
            });
         }
         else
         {
            this.onDDBBAccessedProcessResponse("guilds",false,"acceptJoinGuildRequest","",guildId,null,onSuccessFunction,null,onFailFunction);
         }
      }
      
      public function addPlayerCurrency(param1:Number, param2:String, param3:Boolean = true, param4:Function = null, param5:Array = null, param6:Function = null, param7:Array = null) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var amount:Number = param1;
         var type:String = param2;
         var playSound:Boolean = param3;
         var onSuccessFunction:Function = param4;
         var onSuccessParams:Array = param5;
         var onFailFunction:Function = param6;
         var onFailParams:Array = param7;
         if(this.isUserAllowedToMakeServerCalls())
         {
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("EDIT_CURRENCY");
            req.setAttribute("TYPE",type);
            req.setAttribute("AMOUNT",amount);
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               var info:String = null;
               var balanceLeft:Number = NaN;
               var response:LogEventResponse = param1;
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("addPlayerCurrency");
                  return;
               }
               processedAlready = true;
               info = "[" + type + "] " + amount;
               if(!response.HasErrors())
               {
                  onDDBBAccessedProcessResponse("CURRENCIES",true,"editPlayerCurrency",info,"",balanceLeft,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams);
                  try
                  {
                     balanceLeft = Number(response.getScriptData().balance);
                     updatePlayerBalanceInClient(type,amount,balanceLeft,playSound);
                  }
                  catch(e:Error)
                  {
                     FSDebug.debugTrace("Error updating player balance in client: " + e.message);
                     FSTracker.trackMiscAction(FSTracker.CATEGORY_CRAFT,FSTracker.ACTION_ERROR_DETECTED,{"error: ":e.message});
                  }
               }
               else
               {
                  onDDBBAccessedProcessResponse("CURRENCIES",false,"editPlayerCurrency",info,"",null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams);
               }
            });
         }
         else
         {
            this.onDDBBAccessedProcessResponse("CURRENCIES",false,"editPlayerCurrency",null,"",null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams);
         }
      }
      
      public function updatePlayerBalanceInClient(param1:String, param2:Number, param3:Number, param4:Boolean = true) : void
      {
         var _loc5_:UserData = null;
         var _loc6_:Screen = null;
         var _loc7_:uint = 0;
         var _loc8_:String = null;
         var _loc9_:Boolean = false;
         var _loc10_:* = undefined;
         var _loc11_:FSAuctionTicketsVisor = null;
         var _loc12_:FSCurrencyVisor = null;
         _loc5_ = Utils.getOwnerUserData();
         if(_loc5_)
         {
            if(param2 != 0 && param4 && InstanceMng.getApplication().mapScreenHasBeenVisited())
            {
               Utils.playSound(Constants.SOUND_GOLD_SPENT,SoundManager.TYPE_SFX);
            }
            _loc6_ = InstanceMng.getCurrentScreen();
            _loc7_ = param2 > 0 ? 65280 : 16711680;
            _loc8_ = param2 > 0 ? "+ " : "";
            switch(param1)
            {
               case CURRENCY_GOLD:
                  _loc5_.setGold(param3);
                  _loc9_ = Boolean(InstanceMng.getBattleEngine()) && InstanceMng.getBattleEngine().isOnlineMatch();
                  if(Config.getConfig().hasQuests() && param2 > 0)
                  {
                     InstanceMng.getQuestsMng().addActionPerformed(QuestsMng.TARGET_TYPE_OBTAIN,param2,true,[QuestsMng.TARGET_CURRENCY + ":" + Constants.CURRENCY_GOLD,QuestsMng.TARGET_PVP_LEVEL + ":" + _loc9_]);
                  }
                  if(param2 > 0)
                  {
                     Utils.setStat(Constants.STAT_GOLD_EARNED,param2);
                  }
                  _loc10_ = InstanceMng.getCurrentScreen() ? InstanceMng.getCurrentScreen().getGoldVisor() : null;
                  if(_loc10_)
                  {
                     if(_loc10_ is FSGoldVisor)
                     {
                        InstanceMng.getTextParticlesMng().showTextParticle(_loc8_ + param2,_loc7_,_loc10_);
                        FSGoldVisor(_loc10_).updateAmount();
                     }
                     else if(_loc10_ is FSCurrencyVisor && InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
                     {
                        InstanceMng.getTextParticlesMng().showTextParticle(_loc8_ + param2,_loc7_,_loc10_);
                        _loc10_.refreshCurrencyAmount(true);
                     }
                  }
                  break;
               case CURRENCY_RAID_COINS:
                  Utils.setStat(Constants.STAT_RAID_COINS,param3);
                  _loc5_.setRaidCoins(param3);
                  break;
               case CURRENCY_QUEST_COINS:
                  Utils.setStat(Constants.STAT_QUEST_COINS,param3);
                  _loc5_.setQuestsCoins(param3);
                  break;
               case CURRENCY_AH_TOKENS:
                  _loc5_.setAuctionTickets(param3);
                  _loc11_ = InstanceMng.getCurrentScreen().getAuctionTicketsVisor();
                  if(_loc11_)
                  {
                     InstanceMng.getTextParticlesMng().showTextParticle(_loc8_ + param2,_loc7_,_loc11_);
                     _loc11_.updateAmount();
                  }
                  break;
               case CURRENCY_RAID_TICKETS_SP:
                  _loc5_.setRaidTicketsSinglePlayer(param3);
                  if(_loc6_ is FSRaidsScreen)
                  {
                     FSRaidsScreen(_loc6_).updateRaidTicketVisors();
                  }
                  break;
               case CURRENCY_RAID_TICKETS_MP:
                  _loc5_.setRaidTicketsMultiPlayer(param3);
                  if(_loc6_ is FSRaidsScreen)
                  {
                     FSRaidsScreen(_loc6_).updateRaidTicketVisors();
                  }
            }
         }
         if(InstanceMng.getCurrentScreen() is FSShopScreen)
         {
            _loc12_ = FSShopScreen(InstanceMng.getCurrentScreen()).getCurrencyVisor(param1);
            if(_loc12_)
            {
               InstanceMng.getTextParticlesMng().showTextParticle(_loc8_ + param2,_loc7_,_loc12_);
               _loc12_.refreshCurrencyAmount(true);
            }
         }
         if(_loc6_ is FSShopScreen)
         {
            FSShopScreen(_loc6_).refreshPricesColors();
         }
      }
      
      public function getRaidsMPScoresLB(param1:String, param2:String, param3:String = "", param4:Function = null, param5:Array = null, param6:Function = null, param7:Array = null, param8:Boolean = true) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var raidSku:String = param1;
         var guildId:String = param2;
         var uid:String = param3;
         var onSuccessFunction:Function = param4;
         var onSuccessParams:Array = param5;
         var onFailFunction:Function = param6;
         var onFailParams:Array = param7;
         var returnDataOnSuccess:Boolean = param8;
         if(this.isUserLoggedIn())
         {
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("FS_RETRIEVE_ALL_RAIDS_MP_RANKING");
            req.setAttribute("RAID_SKU",raidSku);
            req.setAttribute("GUILD_ID",guildId);
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               var _loc2_:Object = null;
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("getRaidsMPScoresLB");
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  _loc2_ = param1.getScriptData() ? param1.getScriptData().data : null;
                  onDDBBAccessedProcessResponse("RAIDS-MP",true,"retrieveScoresFromMPRaidLeaderboard","",uid,_loc2_,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
               }
               else
               {
                  onDDBBAccessedProcessResponse("RAIDS-MP",false,"retrieveScoresFromMPRaidLeaderboard","",uid,null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
               }
            });
         }
         else
         {
            this.onDDBBAccessedProcessResponse("RAIDS-MP",false,"retrieveScoresFromMPRaidLeaderboard","",uid,null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
         }
      }
      
      public function getRaidsSPScore(param1:String, param2:Function = null, param3:Array = null, param4:Function = null, param5:Array = null, param6:Boolean = true) : void
      {
         var req:LogEventRequest = null;
         var ownerUserData:UserData = null;
         var processedAlready:Boolean = false;
         var raidSku:String = param1;
         var onSuccessFunction:Function = param2;
         var onSuccessParams:Array = param3;
         var onFailFunction:Function = param4;
         var onFailParams:Array = param5;
         var returnDataOnSuccess:Boolean = param6;
         if(this.isUserLoggedIn())
         {
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("FS_RETRIEVE_ALL_RAIDS_SP_SCORE");
            req.setAttribute("RAID_SKU",raidSku);
            ownerUserData = Utils.getOwnerUserData();
            if(ownerUserData)
            {
               req.setAttribute("UID",ownerUserData.getAccountId());
            }
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               var _loc2_:Object = null;
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("getRaidsSPScore");
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  _loc2_ = param1.getScriptData() ? param1.getScriptData().data : 0;
                  onDDBBAccessedProcessResponse("RAIDS-SP",true,"retrieveScoresFromSPRaidLeaderboard","","",_loc2_,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
               }
               else
               {
                  onDDBBAccessedProcessResponse("RAIDS-SP",false,"retrieveScoresFromSPRaidLeaderboard","","",null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
               }
            });
         }
         else
         {
            this.onDDBBAccessedProcessResponse("RAIDS-SP",false,"retrieveScoresFromSPRaidLeaderboard","","",null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
         }
      }
      
      public function addScoreToRaid(param1:Number, param2:String, param3:Number, param4:Boolean, param5:String = "", param6:String = "", param7:Function = null, param8:Array = null, param9:Function = null, param10:Array = null, param11:Boolean = false) : void
      {
         var req:LogEventRequest = null;
         var evName:String = null;
         var processedAlready:Boolean = false;
         var score:Number = param1;
         var raidSku:String = param2;
         var difficulty:Number = param3;
         var isMulti:Boolean = param4;
         var guildId:String = param5;
         var uid:String = param6;
         var onSuccessFunction:Function = param7;
         var onSuccessParams:Array = param8;
         var onFailFunction:Function = param9;
         var onFailParams:Array = param10;
         var returnDataOnSuccess:Boolean = param11;
         if(this.isUserLoggedIn())
         {
            req = new LogEventRequest(smGameSparks);
            evName = isMulti ? "RAIDS_MP" : "RAIDS_SP";
            req.setEventKey(this.getEventKeyByCodename(evName));
            req.setAttribute("SCORE",score);
            req.setAttribute("RAID_SKU",raidSku);
            req.setAttribute("DIFFICULTY",difficulty);
            if(evName == "RAIDS_MP")
            {
               req.setAttribute("GUILD",guildId);
            }
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("addScoreToRaid");
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  onDDBBAccessedProcessResponse("RAIDS-SCORE",true,"addScoreToRaid","score:" + score,"",null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
               }
               else
               {
                  onDDBBAccessedProcessResponse("RAIDS-SCORE",false,"addScoreToRaid","score:" + score,"",null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
               }
            });
         }
         else
         {
            FSDebug.debugTrace("ERROR! Player not logged in / not authorized");
            this.onDDBBAccessedProcessResponse("RAIDS-SCORE",false,"addScoreToRaid","score:" + score,"",null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
         }
      }
      
      public function joinAHTeam(param1:String) : void
      {
         var req:JoinTeamRequest = null;
         var processedAlready:Boolean = false;
         var auctionId:String = param1;
         req = new JoinTeamRequest(smGameSparks);
         req.setTeamId(auctionId);
         req.setTeamType("AH");
         req.setTimeoutSeconds(GS_TIMEOUT_SEC);
         req.setDurable(Config.DURABLE_CONNECTION);
         processedAlready = false;
         req.send(function(param1:JoinTeamResponse):void
         {
            if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
            {
               onDuplicatedResponseReceived("joinAHTeam");
               return;
            }
            processedAlready = true;
            if(!param1.HasErrors())
            {
               onDDBBAccessedProcessResponse("auctions",true,"joinAHTeam");
            }
            else
            {
               onDDBBAccessedProcessResponse("auctions",false,"joinAHTeam");
            }
         });
      }
      
      public function giveGoldToGuildMembers(param1:Number, param2:Function = null, param3:Array = null, param4:Function = null, param5:Array = null, param6:Boolean = true) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var amount:Number = param1;
         var onSuccessFunction:Function = param2;
         var onSuccessParams:Array = param3;
         var onFailFunction:Function = param4;
         var onFailParams:Array = param5;
         var returnDataOnSuccess:Boolean = param6;
         if(this.isUserLoggedIn())
         {
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("FS_GIFT_GOLD_MEMBERS");
            req.setAttribute("AMOUNT",amount);
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               var _loc2_:Number = NaN;
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("giveGoldToGuildMembers");
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  _loc2_ = param1.getScriptData() ? Number(param1.getScriptData().data) : 0;
                  onDDBBAccessedProcessResponse("giveGoldToGuildMembers",true,"","","",null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
               }
               else
               {
                  onDDBBAccessedProcessResponse("giveGoldToGuildMembers",false,"","","",null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
               }
            });
         }
         else
         {
            this.onDDBBAccessedProcessResponse("giveGoldToGuildMembers",false,"","","",null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
         }
      }
      
      public function sendRegistrationIdToBackend(param1:String) : void
      {
         var deviceOS:String = null;
         var req:PushRegistrationRequest = null;
         var processedAlready:Boolean = false;
         var pushId:String = param1;
         deviceOS = "FCM";
         if(this.isUserAllowedToMakeServerCalls())
         {
            req = smGameSparks.getRequestBuilder().createPushRegistrationRequest();
            req.setDeviceOS(deviceOS);
            req.setPushId(pushId);
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:PushRegistrationResponse):void
            {
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("sendRegistrationIdToBackend");
                  return;
               }
               processedAlready = true;
               FSDebug.debugTrace("PushId: " + pushId);
            });
         }
         else
         {
            setTimeout(this.sendRegistrationIdToBackend,3000,pushId);
         }
      }
      
      public function trackBrowserVerifiedPurchase(param1:Object) : void
      {
         if(param1)
         {
            param1 = this.addCommonEntityAttributes(param1);
            this.createEntityInCollection("verifiedPurchaseBrowser",param1);
         }
      }
      
      public function getPlayerPvEScores(param1:String, param2:int, param3:int, param4:int, param5:Function = null, param6:Function = null) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var uid:String = param1;
         var levelMin:int = param2;
         var levelMax:int = param3;
         var difficulty:int = param4;
         var onSuccessFunction:Function = param5;
         var onFailFunction:Function = param6;
         if(this.isUserLoggedIn() && !Root.smRootDeactivated)
         {
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("GET_PVE_SCORES");
            req.setAttribute("UID",uid);
            req.setAttribute("LEVEL_MIN",levelMin);
            req.setAttribute("LEVEL_MAX",levelMax);
            req.setAttribute("DIFFICULTY",difficulty);
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               var _loc2_:Object = null;
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("getPlayerPvEScores");
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  _loc2_ = param1.getScriptData() ? param1.getScriptData().data : null;
                  onDDBBAccessedProcessResponse("levelsScore",true,"getPlayerPvEScores","",uid,_loc2_,onSuccessFunction,null,onFailFunction,null,true);
               }
               else
               {
                  onDDBBAccessedProcessResponse("levelsScore",false,"getPlayerPvEScores","",uid,null,onSuccessFunction,null,onFailFunction,null,true);
               }
            });
         }
         else
         {
            this.onDDBBAccessedProcessResponse("levelsScore",false,"getPlayerPvEScores","",uid,null,onSuccessFunction,null,onFailFunction,null,true);
         }
      }
      
      public function getFriendsPvEScores(param1:String, param2:Function = null, param3:Function = null) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var uid:String = param1;
         var onSuccessFunction:Function = param2;
         var onFailFunction:Function = param3;
         if(this.isUserLoggedIn())
         {
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("GET_FRIENDS_PVE_SCORE");
            req.setAttribute("UID",uid);
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               var _loc2_:Object = null;
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("getFriendsPvEScores");
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  _loc2_ = param1.getScriptData() ? param1.getScriptData().data : null;
                  onDDBBAccessedProcessResponse("levelsScore",true,"getFriendsPvEScore","",uid,_loc2_,onSuccessFunction,null,onFailFunction,null,true);
               }
               else
               {
                  onDDBBAccessedProcessResponse("levelsScore",false,"getFriendsPvEScore","",uid,null,onSuccessFunction,null,onFailFunction,null,true);
               }
            });
         }
         else
         {
            this.onDDBBAccessedProcessResponse("levelsScore",false,"getFriendsPvEScore","",uid,null,onSuccessFunction,null,onFailFunction,null,true);
         }
      }
      
      public function guildsEditInfo(param1:String, param2:String = "-1", param3:String = "-1", param4:int = -1, param5:String = "", param6:Function = null, param7:Array = null, param8:Function = null, param9:Array = null, param10:Boolean = false) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var guildId:String = param1;
         var emblemFG:String = param2;
         var emblemBG:String = param3;
         var accessType:int = param4;
         var desc:String = param5;
         var onSuccessFunction:Function = param6;
         var onSuccessParams:Array = param7;
         var onFailFunction:Function = param8;
         var onFailParams:Array = param9;
         var returnDataOnSuccess:Boolean = param10;
         if(this.isUserLoggedIn())
         {
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("EDIT_GUILD_INFO");
            req.setAttribute("GUILD_ID",guildId);
            req.setAttribute("EMBLEM_FG",emblemFG);
            req.setAttribute("EMBLEM_BG",emblemBG);
            req.setAttribute("ACCESS_TYPE",accessType);
            req.setAttribute("DESC",desc);
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               var _loc2_:Object = null;
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("guildsEditInfo");
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  _loc2_ = param1.getScriptData() ? param1.getScriptData().data : null;
                  onDDBBAccessedProcessResponse("guilds",true,"guildsEditInfo","",guildId,_loc2_,onSuccessFunction,null,onFailFunction,null,true);
               }
               else
               {
                  onDDBBAccessedProcessResponse("guilds",false,"guildsEditInfo","",guildId,null,onSuccessFunction,null,onFailFunction,null,true);
               }
            });
         }
         else
         {
            this.onDDBBAccessedProcessResponse("guilds",false,"guildsEditInfo","",guildId,null,onSuccessFunction,null,onFailFunction,null,true);
         }
      }
      
      public function notifyLevelUp(param1:String, param2:int) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var level:String = param1;
         var difficulty:int = param2;
         if(this.isUserLoggedIn())
         {
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("NOTIFY_LEVEL_UP");
            req.setAttribute("LEVEL",level);
            req.setAttribute("DIFFICULTY",difficulty);
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("notifyLevelUp");
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  onDDBBAccessedProcessResponse("levels",true,"notifyLevelUp","",level);
               }
               else
               {
                  onDDBBAccessedProcessResponse("levels",false,"notifyLevelUp","",level);
               }
            });
         }
         else
         {
            this.onDDBBAccessedProcessResponse("levels",false,"notifyLevelUp","",level);
         }
      }
      
      public function getJoinableGuilds(param1:Function = null, param2:Array = null, param3:Function = null, param4:Boolean = false) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var onSuccessFunction:Function = param1;
         var onSuccessParams:Array = param2;
         var onFailFunction:Function = param3;
         var returnDataOnSuccess:Boolean = param4;
         if(this.isUserLoggedIn())
         {
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("GUILDS_GET_JOINABLE_GUILDS");
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               var _loc2_:Object = null;
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("getJoinableGuilds");
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  _loc2_ = param1.getScriptData() ? param1.getScriptData().data : null;
                  onDDBBAccessedProcessResponse("guilds",true,"getJoinableGuilds","","",_loc2_,onSuccessFunction,null,onFailFunction,null,true);
               }
               else
               {
                  onDDBBAccessedProcessResponse("guilds",false,"getJoinableGuilds","","",null,onSuccessFunction,null,onFailFunction,null,true);
               }
            });
         }
         else
         {
            this.onDDBBAccessedProcessResponse("guilds",false,"getJoinableGuilds","","",null,onSuccessFunction,null,onFailFunction,null,true);
         }
      }
      
      public function getGuildsTopScores(param1:Boolean, param2:Boolean, param3:Boolean, param4:Function = null, param5:Array = null, param6:Function = null, param7:Array = null, param8:Boolean = true) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var topPvE:Boolean = param1;
         var topPvP:Boolean = param2;
         var topContributor:Boolean = param3;
         var onSuccessFunction:Function = param4;
         var onSuccessParams:Array = param5;
         var onFailFunction:Function = param6;
         var onFailParams:Array = param7;
         var returnDataOnSuccess:Boolean = param8;
         if(this.isUserLoggedIn())
         {
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("GUILDS_GET_TOP_SCORES_DATA");
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               var _loc2_:Object = null;
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("getGuildsTopScores");
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  _loc2_ = param1.getScriptData() ? param1.getScriptData().data : null;
                  onDDBBAccessedProcessResponse("guilds",true,"getGuildsTopScores","","",_loc2_,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
               }
               else
               {
                  onDDBBAccessedProcessResponse("guilds",false,"getGuildsTopScores","","",null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
               }
            });
         }
      }
      
      public function getGuildPositionByGuildId(param1:String, param2:Function = null, param3:Array = null, param4:Function = null, param5:Array = null, param6:Boolean = true) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var guildId:String = param1;
         var onSuccessFunction:Function = param2;
         var onSuccessParams:Array = param3;
         var onFailFunction:Function = param4;
         var onFailParams:Array = param5;
         var returnDataOnSuccess:Boolean = param6;
         if(this.isUserLoggedIn())
         {
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("GUILDS_GET_POS_GUILD");
            req.setAttribute("GUILD_ID",guildId);
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               var _loc2_:Object = null;
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("getGuildPositionByGuildId");
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  _loc2_ = param1.getScriptData() ? param1.getScriptData().data : null;
                  onDDBBAccessedProcessResponse("guilds",true,"getGuildPositionByGuildId","",guildId,_loc2_,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
               }
               else
               {
                  onDDBBAccessedProcessResponse("guilds",false,"getGuildPositionByGuildId","",guildId,null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
               }
            });
         }
      }
      
      public function findFriendlyPvP(param1:String, param2:Function = null, param3:Array = null, param4:Function = null, param5:Array = null, param6:Boolean = true) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var uid:String = param1;
         var onSuccessFunction:Function = param2;
         var onSuccessParams:Array = param3;
         var onFailFunction:Function = param4;
         var onFailParams:Array = param5;
         var returnDataOnSuccess:Boolean = param6;
         if(this.isUserLoggedIn())
         {
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("PVP_FRIEND_DUEL");
            req.setAttribute("UID",uid);
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               var _loc2_:Object = null;
               var _loc3_:Boolean = false;
               var _loc4_:Boolean = false;
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("sendFriendlyPvPRequest");
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  Utils.setLogText(TextManager.getText("TID_PVP_SEARCHING") + "...",false,false,true,false);
                  _loc2_ = param1.getScriptData() ? param1.getScriptData().data : null;
                  PvPConnectionMng.updateBattleSyncData(_loc2_);
                  PvPConnectionMng.smCurrentMatchId = Utils.getDataId(_loc2_);
                  _loc3_ = _loc2_.u1.uid == InstanceMng.getServerConnection().getUserId();
                  _loc4_ = _loc2_.u1.uid == InstanceMng.getServerConnection().getUserId() || _loc2_.u2.uid == InstanceMng.getServerConnection().getUserId();
                  if(_loc4_)
                  {
                     PvPConnectionMng.updateOwnerAcceptedMatch(_loc2_);
                     InstanceMng.getPopupMng().openWaitingForOpponentPopup(PvPConnectionMng.smCurrentMatchId,TextManager.getText("TID_PVP_SYNC"),_loc3_,true);
                  }
                  FSTracker.trackFirebaseEvent("PVP_FRIENDLY_QUEUE");
                  onDDBBAccessedProcessResponse("pvp",true,"sendFriendlyPvPRequest","","",_loc2_,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
               }
               else
               {
                  onDDBBAccessedProcessResponse("pvp",false,"sendFriendlyPvPRequest","","",null,onSuccessFunction,onSuccessParams,onFailFunction,[param1.getErrors()]);
               }
            });
         }
      }
      
      public function declineFriendlyPvP(param1:Number, param2:String, param3:String, param4:String, param5:Function = null, param6:Array = null, param7:Function = null, param8:Array = null, param9:Boolean = true) : void
      {
         var decline:Function = null;
         var delay:Number = param1;
         var uid:String = param2;
         var matchOwnerNick:String = param3;
         var logText:String = param4;
         var onSuccessFunction:Function = param5;
         var onSuccessParams:Array = param6;
         var onFailFunction:Function = param7;
         var onFailParams:Array = param8;
         var returnDataOnSuccess:Boolean = param9;
         decline = function():void
         {
            var req:LogEventRequest = null;
            var processedAlready:Boolean = false;
            if(isUserLoggedIn())
            {
               req = new LogEventRequest(smGameSparks);
               req.setEventKey("PVP_FRIEND_DECLINE_DUEL");
               req.setAttribute("UID",uid);
               req.setTimeoutSeconds(GS_TIMEOUT_SEC);
               req.setDurable(Config.DURABLE_CONNECTION);
               processedAlready = false;
               req.send(function(param1:LogEventResponse):void
               {
                  var _loc2_:Object = null;
                  if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
                  {
                     onDuplicatedResponseReceived("declineFriendlyPvP");
                     return;
                  }
                  processedAlready = true;
                  if(!param1.HasErrors())
                  {
                     FSTracker.trackFirebaseEvent("PVP_DECLINE_FRIENDLY");
                     _loc2_ = param1.getScriptData() ? param1.getScriptData().data : null;
                     Utils.setLogText(logText,false,false,false,true,1,Align.CENTER,Align.TOP,null,false,5);
                     onDDBBAccessedProcessResponse("pvp",true,"declineFriendlyPvP","","",_loc2_,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
                  }
                  else
                  {
                     onDDBBAccessedProcessResponse("pvp",false,"declineFriendlyPvP","","",null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
                  }
               });
            }
         };
         setTimeout(decline,delay * 1000);
      }
      
      public function findPvPMatch(param1:int, param2:int, param3:String = "", param4:Function = null, param5:Array = null, param6:Function = null, param7:Array = null, param8:Boolean = true) : void
      {
         var req:LogEventRequest = null;
         var ownerUserData:UserData = null;
         var processedAlready:Boolean = false;
         var pvpBotDeckDef:PvPBotDeckDef = null;
         var elo:int = param1;
         var deckValue:int = param2;
         var forcePvPBotSku:String = param3;
         var onSuccessFunction:Function = param4;
         var onSuccessParams:Array = param5;
         var onFailFunction:Function = param6;
         var onFailParams:Array = param7;
         var returnDataOnSuccess:Boolean = param8;
         if(this.isUserLoggedIn())
         {
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("PVP_FIND_MATCH");
            req.setAttribute("ELO",elo);
            req.setAttribute("DECK_VALUE",deckValue);
            req.setAttribute("PLATFORM",this.getPlatformId());
            ownerUserData = Utils.getOwnerUserData();
            if(ownerUserData)
            {
               pvpBotDeckDef = forcePvPBotSku != "" ? PvPBotDeckDef(InstanceMng.getPvPBotDecksDefMng().getDefBySku(forcePvPBotSku)) : InstanceMng.getPvPBotDecksDefMng().getRandomPvPBotDeckDefsByDeckValue(deckValue);
               req.setAttribute("FUTURE_BOT_DV",pvpBotDeckDef.getDeckValue());
               req.setAttribute("FUTURE_BOT_SKU",pvpBotDeckDef.getSku());
            }
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               var _loc2_:Object = null;
               var _loc3_:Object = null;
               var _loc4_:Number = NaN;
               var _loc5_:Boolean = false;
               var _loc6_:Boolean = false;
               var _loc7_:String = null;
               var _loc8_:String = null;
               var _loc9_:String = null;
               var _loc10_:String = null;
               var _loc11_:String = null;
               var _loc12_:String = null;
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("findPvPMatch");
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  Utils.setLogText(TextManager.getText("TID_PVP_SEARCHING") + "...",false,false,true,false);
                  InstanceMng.getPopupMng().openSearchingPvPopponentPopup();
                  FSTracker.trackFirebaseEvent("PVP_QUEUE");
                  _loc2_ = param1.getScriptData() ? param1.getScriptData().data : null;
                  PvPConnectionMng.updateBattleSyncData(_loc2_);
                  PvPConnectionMng.smCurrentMatchId = Utils.getDataId(_loc2_);
                  onDDBBAccessedProcessResponse("pvp",true,"findPvPMatch","","",_loc2_,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
               }
               else
               {
                  InstanceMng.getCurrentScreen().lockUI(false);
                  _loc3_ = param1.getErrors()["error"];
                  if(Boolean(_loc3_) && _loc3_.hasOwnProperty("banEndingTime"))
                  {
                     PvPConnectionMng.removeFromPvPQueue();
                     _loc4_ = Number(_loc3_["banEndingTime"]) - smServerTimeMS;
                     _loc5_ = TimerUtil.msToDays(_loc4_) > 0;
                     _loc6_ = TimerUtil.msToHour(_loc4_) > 0;
                     _loc7_ = _loc5_ ? TextManager.getText("TID_GEN_TIME_DAYS_ABR",true) + " " : null;
                     _loc8_ = _loc6_ ? TextManager.getText("TID_GEN_TIME_HOURS_ABR",true) + " " : null;
                     _loc9_ = TextManager.getText("TID_GEN_TIME_MINUTES_ABR",true) + " ";
                     _loc10_ = TextManager.getText("TID_GEN_TIME_SECONDS_ABR",true) + " ";
                     _loc11_ = TimerUtil.getTimeTextFromMs(_loc4_,_loc7_,_loc8_,_loc9_,_loc10_);
                     _loc12_ = TextManager.replaceParameters(TextManager.getText("TID_PVP_SURRENDER_TIME"),[_loc11_]);
                     InstanceMng.getPopupMng().openErrorPopup(_loc12_,false,true);
                  }
                  onDDBBAccessedProcessResponse("pvp",false,"findPvPMatch","","",null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
               }
            });
         }
      }
      
      public function updatePvPMatchOwnerStatus(param1:String, param2:String, param3:String, param4:Function = null, param5:Array = null, param6:Function = null, param7:Array = null, param8:Boolean = true) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var status:String = param1;
         var matchId:String = param2;
         var action:String = param3;
         var onSuccessFunction:Function = param4;
         var onSuccessParams:Array = param5;
         var onFailFunction:Function = param6;
         var onFailParams:Array = param7;
         var returnDataOnSuccess:Boolean = param8;
         if(this.isUserLoggedIn())
         {
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("PVP_UPDATE_OWNER_STATUS");
            req.setAttribute("STATUS",status);
            req.setAttribute("ACTION",action);
            req.setAttribute("MATCH_ID",matchId);
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("updatePvPMatchOwnerStatus");
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  PvPConnectionMng.updateOwnerSyncStatus(status);
                  onDDBBAccessedProcessResponse("pvp",true,"updatePvPMatchOwnerStatus","",matchId,"",onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
               }
               else
               {
                  onDDBBAccessedProcessResponse("pvp",false,"updatePvPMatchOwnerStatus","",matchId,null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
               }
            });
         }
      }
      
      public function sendPvELevelAttempt(param1:int, param2:int, param3:Boolean, param4:int, param5:Boolean) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var level:int = param1;
         var diff:int = param2;
         var isRepeat:Boolean = param3;
         var selDeckIndex:int = param4;
         var easyModeON:Boolean = param5;
         if(this.isUserLoggedIn())
         {
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("PVE_SEND_ATTEMPT");
            req.setAttribute("LEVEL",level);
            req.setAttribute("DIFF",diff);
            req.setAttribute("IS_REPEAT",int(isRepeat));
            req.setAttribute("EASY_MODE",int(easyModeON));
            req.setAttribute("DECK",selDeckIndex);
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("sendPvELevelAttempt");
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  onDDBBAccessedProcessResponse("pve",true,"sendPvELevelAttempt","","level " + level);
               }
               else
               {
                  onDDBBAccessedProcessResponse("pve",false,"sendPvELevelAttempt","","level " + level);
               }
            });
         }
      }
      
      public function sendDungeonLevelAttempt(param1:String, param2:String, param3:int, param4:Boolean, param5:Boolean, param6:Boolean) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var dungeonLevelSku:String = param1;
         var dungeonSku:String = param2;
         var difficulty:int = param3;
         var finished:Boolean = param4;
         var isFirst:Boolean = param5;
         var isLast:Boolean = param6;
         if(this.isUserLoggedIn())
         {
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("DUNGEON_SEND_ATTEMPT");
            req.setAttribute("DUNGEON_LEVEL_SKU",dungeonLevelSku);
            req.setAttribute("DUNGEON_SKU",dungeonSku);
            req.setAttribute("DIFF",difficulty);
            req.setAttribute("FINISHED",int(finished));
            req.setAttribute("IS_FIRST",int(isFirst));
            req.setAttribute("IS_LAST",int(isLast));
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("sendDungeonLevelAttempt");
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  onDDBBAccessedProcessResponse("dungeons",true,"sendDungeonLevelAttempt","","level " + dungeonLevelSku);
               }
               else
               {
                  onDDBBAccessedProcessResponse("dungeons",false,"sendDungeonLevelAttempt","","level " + dungeonLevelSku);
               }
            });
         }
      }
      
      public function startBrowserLoginCheck() : void
      {
         if(InstanceMng.getApplication().isBrowserVersion())
         {
            this.mBrowserLoggingTimer = setTimeout(this.checkIfLogInResponseReceived,10000);
            this.updateLoginCheckerVariables(true,false);
         }
      }
      
      public function wasPlayerEverOnline() : Boolean
      {
         return this.mPlayerWasOnlineOnce;
      }
      
      public function wasDualConnectionDetected() : Boolean
      {
         return this.mDualLoginDetected;
      }
      
      public function consumeVGood(param1:String, param2:int = 1, param3:Function = null, param4:Array = null, param5:Function = null, param6:Array = null) : void
      {
         var kongUseItemReq:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var consumeVGoodReq:ConsumeVirtualGoodRequest = null;
         var processedAlready1:Boolean = false;
         var shortCode:String = param1;
         var amount:int = param2;
         var onSuccessFunction:Function = param3;
         var onSuccessParams:Array = param4;
         var onFailFunction:Function = param5;
         var onFailParams:Array = param6;
         if(InstanceMng.getApplication().isKongregateVersion())
         {
            kongUseItemReq = new LogEventRequest(smGameSparks);
            kongUseItemReq.setEventKey("USE_ITEM");
            kongUseItemReq.setAttribute("vGood",shortCode);
            kongUseItemReq.setTimeoutSeconds(GS_TIMEOUT_SEC);
            kongUseItemReq.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            kongUseItemReq.send(function(param1:LogEventResponse):void
            {
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("consumeVGood: " + shortCode);
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  onDDBBAccessedProcessResponse(shortCode,true,"shortCode",shortCode,"",null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams);
               }
               else
               {
                  onDDBBAccessedProcessResponse(shortCode,false,"shortCode",shortCode,"",null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams);
               }
            });
         }
         else
         {
            consumeVGoodReq = new ConsumeVirtualGoodRequest(smGameSparks);
            consumeVGoodReq.setQuantity(amount);
            consumeVGoodReq.setShortCode(shortCode);
            consumeVGoodReq.setTimeoutSeconds(GS_TIMEOUT_SEC);
            consumeVGoodReq.setDurable(Config.DURABLE_CONNECTION);
            processedAlready1 = false;
            consumeVGoodReq.send(function(param1:ConsumeVirtualGoodResponse):void
            {
               if(processedAlready1 && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("consumeVGood: " + shortCode);
                  return;
               }
               processedAlready1 = true;
               if(!param1.HasErrors())
               {
                  onDDBBAccessedProcessResponse(shortCode,true,"consumeVGood",shortCode,"",null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams);
               }
               else
               {
                  onDDBBAccessedProcessResponse(shortCode,false,"consumeVGood",shortCode,"",null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams);
               }
            });
         }
      }
      
      public function redeemReferralCode(param1:String, param2:Function = null, param3:Function = null) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var code:String = param1;
         var onSuccessFunction:Function = param2;
         var onFailFunction:Function = param3;
         if(this.isUserLoggedIn())
         {
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("REFERRAL_REDEEM_CODE");
            req.setAttribute("CODE",code);
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("redeemReferralCode");
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  onDDBBAccessedProcessResponse("referrals",true,"REFERRAL_REDEEM_CODE","",code,null,onSuccessFunction,null,onFailFunction);
               }
               else
               {
                  onDDBBAccessedProcessResponse("referrals",false,"REFERRAL_REDEEM_CODE","",code,null,onSuccessFunction,null,onFailFunction,[param1.getErrors()]);
               }
            });
         }
      }
      
      public function checkBattlePassChallengeClaimeable(param1:String, param2:int, param3:int, param4:Function = null, param5:Function = null) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var sku:String = param1;
         var season:int = param2;
         var year:int = param3;
         var onSuccessFunction:Function = param4;
         var onFailFunction:Function = param5;
         if(this.isUserLoggedIn())
         {
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("BATTLE_PASS_CLAIM_CHALLENGE");
            req.setAttribute("SKU",sku);
            req.setAttribute("SEASON",season);
            req.setAttribute("YEAR",year);
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("checkBattlePassChallengeClaimeable");
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  onDDBBAccessedProcessResponse("bpChallengesClaimed",true,"BATTLE_PASS_CLAIM_CHALLENGE","",sku,null,onSuccessFunction,null,onFailFunction);
               }
               else
               {
                  onDDBBAccessedProcessResponse("bpChallengesClaimed",false,"BATTLE_PASS_CLAIM_CHALLENGE","",sku,null,onSuccessFunction,null,onFailFunction,[param1.getErrors()]);
               }
            });
         }
      }
      
      public function forcePlayerDisconnection(param1:Function = null, param2:Function = null) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var onSuccessFunction:Function = param1;
         var onFailFunction:Function = param2;
         req = new LogEventRequest(smGameSparks);
         req.setEventKey("CS_PLAYER_FORCE_DISCONNECT");
         req.setAttribute("UID",this.getUserId());
         req.setTimeoutSeconds(20);
         req.setDurable(Config.DURABLE_CONNECTION);
         processedAlready = false;
         req.send(function(param1:LogEventResponse):void
         {
            if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
            {
               onDuplicatedResponseReceived("forcePlayerDisconnection");
               return;
            }
            processedAlready = true;
            if(!param1.HasErrors())
            {
               onDDBBAccessedProcessResponse("forcePlayerDisconnection",true,"","","",null,onSuccessFunction,null,onFailFunction);
            }
            else
            {
               onDDBBAccessedProcessResponse("forcePlayerDisconnection",false,"","","",null,onSuccessFunction,null,onFailFunction);
            }
         });
      }
      
      private function onDuplicatedResponseReceived(param1:String) : void
      {
         FSDebug.debugTrace("===== Skipping already processed request. Info: [" + param1 + "] =====");
      }
      
      public function addReward(param1:String, param2:int, param3:int, param4:Object, param5:String = "GIFTS", param6:Function = null, param7:Array = null, param8:Function = null, param9:Array = null, param10:Boolean = true) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var sku:String = param1;
         var amount:int = param2;
         var type:int = param3;
         var data:Object = param4;
         var origin:String = param5;
         var onSuccessFunction:Function = param6;
         var onSuccessParams:Array = param7;
         var onFailFunction:Function = param8;
         var onFailParams:Array = param9;
         var returnDataOnSuccess:Boolean = param10;
         if(amount > 0)
         {
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("CS_ADD_REWARD");
            req.setAttribute("UID",this.getUserId());
            req.setAttribute("TYPE",type);
            req.setAttribute("SKU",sku);
            req.setAttribute("AMOUNT",amount);
            req.setAttribute("ORIGIN",origin);
            req.setJSONEventAttribute("DATA",data);
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               var _loc2_:Object = null;
               if(processedAlready)
               {
                  onDuplicatedResponseReceived("addReward");
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  _loc2_ = param1.getScriptData() ? param1.getScriptData().data : null;
                  onDDBBAccessedProcessResponse("rewards",true,"addReward","","",_loc2_,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
               }
               else
               {
                  onDDBBAccessedProcessResponse("rewards",false,"addReward","","",null,onSuccessFunction,onSuccessParams,onFailFunction,onFailParams,returnDataOnSuccess);
               }
            });
         }
         else
         {
            FSDebug.debugTrace("You need to provide an amount > 0");
         }
      }
      
      public function steamBuyProduct(param1:String, param2:Function = null, param3:Function = null) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var prodId:String = param1;
         var onSuccessFunction:Function = param2;
         var onFailedFunction:Function = param3;
         if(this.isUserLoggedIn())
         {
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("STEAM_BUY_PRODUCT");
            req.setAttribute("PROD_ID",prodId);
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               var _loc2_:Object = null;
               var _loc3_:Object = null;
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("steamBuyProduct");
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  _loc2_ = param1.getScriptData() ? param1.getScriptData().data : null;
                  onDDBBAccessedProcessResponse("steamProducts",true,"steamBuyProduct","","",_loc2_,onSuccessFunction,null,onFailedFunction,null,true);
               }
               else
               {
                  _loc3_ = Boolean(param1.getErrors()) && param1.getErrors().hasOwnProperty("error") ? param1.getErrors()["error"] : null;
                  if(_loc3_ == null)
                  {
                     _loc3_ = param1.getAttribute("error");
                  }
                  if(_loc3_ != null)
                  {
                     Utils.setLogText("Error buying on Steam: " + ObjectUtil.toString(_loc3_));
                  }
                  onDDBBAccessedProcessResponse("steamProducts",false,"steamBuyProduct","","",_loc3_,onSuccessFunction,null,onFailedFunction,null,true);
               }
            });
         }
      }
      
      public function getSteamProducts(param1:Function = null) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var onSuccessFunction:Function = param1;
         if(this.isUserLoggedIn())
         {
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("STEAM_GET_PRODUCTS");
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               var _loc2_:Object = null;
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("getSteamProducts");
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  _loc2_ = param1.getScriptData() ? param1.getScriptData().data : null;
                  onDDBBAccessedProcessResponse("steamProducts",true,"getSteamProducts","","",_loc2_,onSuccessFunction,null,null,null,true);
               }
               else
               {
                  onDDBBAccessedProcessResponse("steamProducts",false,"getSteamProducts","","",null,onSuccessFunction,null,null,null,true);
               }
            });
         }
      }
      
      public function getProductPricesInUSD() : void
      {
         var collection:String = null;
         var onPrices:Function = null;
         onPrices = function(param1:Object):void
         {
            var _loc2_:Array = null;
            var _loc3_:String = null;
            var _loc4_:Number = NaN;
            var _loc5_:int = 0;
            _loc2_ = param1 ? param1 as Array : null;
            if(_loc2_ != null && _loc2_.length > 0)
            {
               if(FSInAppsManager.smProductsPriceInUSD == null)
               {
                  FSInAppsManager.smProductsPriceInUSD = new Dictionary(true);
               }
               _loc5_ = 0;
               while(_loc5_ < _loc2_.length)
               {
                  _loc3_ = _loc2_[_loc5_]["prodId"];
                  _loc4_ = Number(_loc2_[_loc5_]["price"]);
                  FSInAppsManager.smProductsPriceInUSD[_loc3_] = _loc4_ / 100;
                  _loc5_++;
               }
            }
         };
         collection = "steamProducts";
         this.searchInCollection(collection,"{}",onPrices,null,null,null,true,0,"",0,"{\'prodId\':1,\'price\':1}");
      }
      
      public function pvpSendBattleEmote(param1:String, param2:int = -1) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var uid:String = param1;
         var chatIndex:int = param2;
         if(this.isUserLoggedIn())
         {
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("PVP_SEND_BATTLE_EMOTE");
            req.setAttribute("UID",uid);
            req.setAttribute("CHAT_INDEX",chatIndex);
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               var _loc2_:Object = null;
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("pvpSendBattleEmote");
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  _loc2_ = param1.getScriptData() ? param1.getScriptData().data : null;
                  onDDBBAccessedProcessResponse("pvpEmote",true,"pvpSendBattleEmote","","",_loc2_,null,null,null,null,true);
               }
               else
               {
                  onDDBBAccessedProcessResponse("pvpEmote",false,"pvpSendBattleEmote","","",null,null,null,null,null,true);
               }
            });
         }
      }
      
      public function performPlayerResetOnServer(param1:Function, param2:Function) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var onSuccessFunction:Function = param1;
         var onFailedFunction:Function = param2;
         if(this.isUserLoggedIn())
         {
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("RESET_PLAYER");
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("performPlayerResetOnServer");
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  onDDBBAccessedProcessResponse("resetPlayer",true,"performPlayerResetOnServer","","",null,onSuccessFunction,null,onFailedFunction);
               }
               else
               {
                  onDDBBAccessedProcessResponse("resetPlayer",false,"performPlayerResetOnServer","","",null,onSuccessFunction,null,onFailedFunction);
               }
            });
         }
      }
      
      public function performPlayerMigrationOnServer(param1:String, param2:Function, param3:Function) : void
      {
         var req:LogEventRequest = null;
         var processedAlready:Boolean = false;
         var transferCode:String = param1;
         var onSuccessFunction:Function = param2;
         var onFailedFunction:Function = param3;
         if(this.isUserLoggedIn())
         {
            req = new LogEventRequest(smGameSparks);
            req.setEventKey("DUPLICATE_PLAYER");
            req.setAttribute("UID_NEW",this.getUserId());
            req.setAttribute("UID_OLD","");
            req.setAttribute("TRANSFER_CODE",transferCode);
            req.setAttribute("IS_MIGRATION",1);
            req.setTimeoutSeconds(GS_TIMEOUT_SEC);
            req.setDurable(Config.DURABLE_CONNECTION);
            processedAlready = false;
            req.send(function(param1:LogEventResponse):void
            {
               if(processedAlready && Config.SKIP_DUPLICATED_RESPONSES)
               {
                  onDuplicatedResponseReceived("performPlayerMigrationOnServer");
                  return;
               }
               processedAlready = true;
               if(!param1.HasErrors())
               {
                  onDDBBAccessedProcessResponse("transferPlayer",true,"performPlayerMigrationOnServer","","",null,onSuccessFunction,null,onFailedFunction);
               }
               else
               {
                  onDDBBAccessedProcessResponse("transferPlayer",false,"performPlayerMigrationOnServer","","",null,onSuccessFunction,null,onFailedFunction);
                  Utils.setLogText("Error transfering player: " + param1.getErrors()["error"]);
               }
            });
         }
      }
      
      public function generateTransferCode(param1:Function) : void
      {
         var _loc2_:String = null;
         _loc2_ = "GENERATE_TRANSFER_CODE";
         this.runScript(_loc2_,null,param1,null);
      }
   }
}

