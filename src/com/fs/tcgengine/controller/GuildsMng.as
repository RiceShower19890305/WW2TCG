package com.fs.tcgengine.controller
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.model.guilds.Guild;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.GoldDef;
   import com.fs.tcgengine.model.rules.RaidDef;
   import com.fs.tcgengine.model.rules.RarityDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.screens.FSRaidsScreen;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.TimerUtil;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.popups.Popup;
   import com.fs.tcgengine.view.popups.guilds.PopupGuilds;
   import com.fs.tcgengine.view.popups.misc.PopupConfirmation;
   import com.gamesparks.api.types.Player;
   import com.greensock.TweenMax;
   import flash.utils.setTimeout;
   
   public class GuildsMng
   {
      
      public static var smWeeklyEventType:Number;
      
      public static var smWeeklyEventsEndingTimeMS:Number;
      
      public static var smWeeklyEventsStartingTimeMS:Number;
      
      public static var smWeeklySeasonEndingTimeMS:Number;
      
      public static var smWeeklySeasonStartingTimeMS:Number;
      
      public static var smRaidSPFactor:Number;
      
      public static var smRaidMPFactor:Number;
      
      public static var smMaxBoardMessages:int = 30;
      
      public static var smMaxMembers:int = 15;
      
      public static var smMaxGuildDescriptionLength:int = 200;
      
      public static var smMaxGuildNameLength:int = 15;
      
      public static var smGoldCost:int = 500;
      
      public static var smPvPWonPoints:int = 200;
      
      public static var smDungeonEasyCompletedPoints:int = 25;
      
      public static var smDungeonMedCompletedPoints:int = 200;
      
      public static var smDungeonHardCompletedPoints:int = 500;
      
      public static var smDungeonExpertCompletedPoints:int = 400;
      
      public static var smWeeklySeasonIndex:int = -1;
      
      public static var smGoldShareFactor:Number = 2;
      
      public static var smServerUserInfoReceived:Boolean = false;
      
      public static const RANK_LEADER:int = 0;
      
      public static const RANK_OFFICER:int = 1;
      
      public static const RANK_VETERAN:int = 2;
      
      public static const RANK_MEMBER:int = 3;
      
      public static const RANK_UNCONFIRMED:int = 4;
      
      public static const RANK_GUILD_MOTD:int = 5;
      
      public static const GUILD_JOIN_REQUEST_RECEIVED:int = 0;
      
      public static const GUILD_JOIN_REQUEST_ACCEPTED:int = 1;
      
      public static const GUILD_ACCESS_ANYONE_CAN_JOIN:int = 0;
      
      public static const GUILD_ACCESS_VIA_REQUEST:int = 1;
      
      public static const WEEKLY_EVENT_PVP:int = 0;
      
      public static const WEEKLY_EVENT_DUNGEONS:int = 1;
      
      public static const CHANGE_EMBLEM_GOLD_COST:int = 100;
      
      public static const GUILD_REQUESTS_EXPIRATION_DAYS:int = 30;
      
      public static const GUILD_EVENT_PVP_WON:int = 0;
      
      public static const GUILD_EVENT_DUNGEON_EASY:int = 1;
      
      public static const GUILD_EVENT_DUNGEON_MED:int = 2;
      
      public static const GUILD_EVENT_DUNGEON_HARD:int = 3;
      
      public static const GUILD_EVENT_DUNGEON_EXPERT:int = 21;
      
      public static const GUILD_EVENT_JOIN:int = 4;
      
      public static const GUILD_EVENT_PROMOTE:int = 5;
      
      public static const GUILD_EVENT_DEMOTE:int = 6;
      
      public static const GUILD_EVENT_KICK:int = 7;
      
      public static const GUILD_EVENT_LEFT:int = 8;
      
      public static const GUILD_EVENT_GOT_LEGENDARY:int = 9;
      
      public static const GUILD_WEEKLY_EVENT_STARTED:int = 10;
      
      public static const GUILD_WEEKLY_EVENT_ENDED:int = 11;
      
      public static const GUILD_WEEKLY_REWARDS_READY:int = 12;
      
      public static const GUILD_GRAL_CHAT_SYSTEM_MESSAGE:int = 13;
      
      public static const GUILD_EVENT_RAID_EASY_COMPLETED:int = 14;
      
      public static const GUILD_EVENT_RAID_MEDIUM_COMPLETED:int = 15;
      
      public static const GUILD_EVENT_RAID_HARD_COMPLETED:int = 16;
      
      public static const GUILD_EVENT_RAID_EXPERT_COMPLETED:int = 17;
      
      public static const GUILD_EVENT_RAID_REWARDS_READY:int = 18;
      
      public static const GUILD_EVENT_GOLD_BAG_PURCHASED:int = 19;
      
      public static const GUILD_EVENT_RECRUITED_FRIEND:int = 20;
      
      private var mGuild:Guild;
      
      public var mPlayerRequestsSent:Vector.<String>;
      
      private var mPushPermissionsAlreadyExplained:Boolean = false;
      
      public function GuildsMng()
      {
         super();
      }
      
      public function init() : void
      {
         this.resetGlobalVariables();
         this.refreshMyGuild();
      }
      
      public function onJoinRequestAccepted(param1:String, param2:String, param3:int, param4:String) : void
      {
         this.onGuildJoinedSuccess(param1,param2,param3,param4);
      }
      
      public function onOwnerRankModified(param1:int, param2:int) : void
      {
         var _loc5_:String = null;
         var _loc3_:UserData = Utils.getOwnerUserData();
         var _loc4_:String = this.getMemberTitleByRankId(param2);
         if(param1 > param2 || param2 == 0)
         {
            _loc5_ = TextManager.replaceParameters(TextManager.getText("TID_GUILD_PROMOTE_LOG"),[_loc4_]);
         }
         else
         {
            _loc5_ = TextManager.replaceParameters(TextManager.getText("TID_GUILD_DEMOTE_LOG"),[_loc4_]);
         }
         Utils.setLogText(_loc5_);
         _loc3_.setGuildRank(param2);
         var _loc6_:PopupGuilds = InstanceMng.getPopupMng().getPopupShown() is PopupGuilds ? PopupGuilds(InstanceMng.getPopupMng().getPopupShown()) : null;
         if(_loc6_)
         {
            _loc6_.onRankModifiedExternally();
         }
      }
      
      public function onOwnerKickedFromGuild() : void
      {
         Utils.setLogText(TextManager.getText("TID_GUILD_KICK_LOG"));
         this.onGuildLeftSuccessfuly(false);
      }
      
      public function refreshMyGuild() : void
      {
         var _loc1_:String = null;
         if(InstanceMng.getServerConnection().isUserLoggedIn() && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
         {
            _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData().getGuildId();
            if(_loc1_ != "" && _loc1_ != null)
            {
               InstanceMng.getServerConnection().getGuildInfo(_loc1_,this.onMyGuildInfoReceivedGS,this.onMyGuildInfoFailed,this.mGuild);
               if(InstanceMng.getApplication().areOnDemandDefinitionsInitialized())
               {
                  setTimeout(this.checkNotificationsForGuild,3000);
               }
               else
               {
                  setTimeout(this.checkNotificationsForGuild,5000);
               }
            }
         }
      }
      
      private function checkNotificationsForGuild() : void
      {
         var _loc1_:UserData = null;
         var _loc2_:String = null;
         var _loc3_:Popup = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         if(InstanceMng.getApplication().areOnDemandDefinitionsInitialized())
         {
            if(Utils.isMobile())
            {
               if(!InstanceMng.getApplication().arePushNotificationsRegistered())
               {
                  _loc1_ = Utils.getOwnerUserData();
                  if(Boolean(_loc1_) && _loc1_.flagsOnlinePushNotifsGranted())
                  {
                     _loc2_ = TextManager.getText("TID_PERMISSIONS_GUILD");
                     _loc3_ = InstanceMng.getPopupMng().getPopupShown();
                     _loc4_ = InstanceMng.getPopupMng().isPopupLoading();
                     if(!(_loc3_ is PopupConfirmation) && !_loc4_)
                     {
                        _loc5_ = InstanceMng.getApplication().arePushNotificationsAuthorised();
                        if(!_loc5_)
                        {
                           if(!this.mPushPermissionsAlreadyExplained && !Utils.isAndroid() && !Utils.isSimulator())
                           {
                              this.mPushPermissionsAlreadyExplained = true;
                              if(_loc3_ != null)
                              {
                                 _loc3_.hideTemporarily(InstanceMng.getPopupMng().openConfirmationPopup,[_loc2_,InstanceMng.getApplication().authorisationStatus,InstanceMng.getApplication().authorisationStatus]);
                              }
                              else
                              {
                                 InstanceMng.getPopupMng().openConfirmationPopup(_loc2_,InstanceMng.getApplication().authorisationStatus,InstanceMng.getApplication().authorisationStatus);
                              }
                           }
                           else
                           {
                              InstanceMng.getApplication().authorisationStatus();
                           }
                        }
                        else if(Utils.isAndroid())
                        {
                           InstanceMng.getApplication().authorisationStatus();
                        }
                     }
                  }
               }
            }
         }
         else
         {
            setTimeout(this.checkNotificationsForGuild,5000);
         }
      }
      
      private function onMyGuildInfoReceivedGS(param1:Guild) : void
      {
         var _loc2_:Vector.<Player> = null;
         var _loc3_:Player = null;
         var _loc4_:int = 0;
         this.mGuild = param1;
         if(Boolean(InstanceMng.getServerConnection().getBackendUserProfile()) && Boolean(this.mGuild))
         {
            _loc2_ = Vector.<Player>(this.mGuild.getActiveMembersData());
            if(_loc2_)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc2_.length)
               {
                  _loc3_ = _loc2_[_loc4_];
                  if(_loc3_)
                  {
                     this.mGuild.updateMemberRank(_loc3_.getId(),_loc3_.getScriptData().profile.guildRank);
                  }
                  _loc4_++;
               }
            }
            this.checkIfAnyMemberLeftGS(_loc2_);
            this.mGuild.refreshGuildMembersInfo();
            if(Boolean(InstanceMng.getApplication().getGuildsPanel()) && param1.getDescription() != null)
            {
               InstanceMng.getApplication().getGuildsPanel().updateGuildManageTooltipInfo(param1.getDescription());
            }
         }
      }
      
      private function onMyGuildInfoFailed() : void
      {
         TweenMax.killDelayedCallsTo(this.checkMyGuildInfoReceivedFromServer);
      }
      
      private function checkMyGuildInfoReceivedFromServer() : void
      {
         TweenMax.killDelayedCallsTo(this.checkMyGuildInfoReceivedFromServer);
         this.refreshMyGuild();
      }
      
      private function checkIfAnyMemberLeftGS(param1:Vector.<Player>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Player = null;
         var _loc5_:String = null;
         var _loc6_:Boolean = false;
         var _loc7_:Vector.<String> = null;
         if(this.mGuild)
         {
            _loc7_ = this.mGuild.getMemberIds();
            if(_loc7_)
            {
               _loc2_ = 0;
               while(_loc2_ < _loc7_.length)
               {
                  _loc5_ = _loc7_[_loc2_];
                  _loc6_ = false;
                  if(param1)
                  {
                     _loc3_ = 0;
                     while(_loc3_ < param1.length)
                     {
                        _loc4_ = param1[_loc3_];
                        if(_loc4_)
                        {
                           if(_loc4_.getId() == _loc5_)
                           {
                              _loc6_ = true;
                           }
                        }
                        _loc3_++;
                     }
                  }
                  if(!_loc6_)
                  {
                     this.mGuild.removeMemberById(_loc5_);
                  }
                  _loc2_++;
               }
            }
         }
      }
      
      public function createGuild(param1:String, param2:String, param3:String, param4:int, param5:Function) : void
      {
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            InstanceMng.getServerConnection().checkIfGuildNameAvailable(param1,this.onGuildNameCheckAvailability,[param2,param3,param4]);
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true);
            if(param5 != null)
            {
               param5();
            }
         }
      }
      
      private function onGuildNameCheckAvailability(param1:Boolean, param2:String, param3:String, param4:String, param5:int) : void
      {
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            if(param1)
            {
               if(this.mGuild == null)
               {
                  this.mGuild = new Guild(param2,param3,param4,InstanceMng.getServerConnection().getUserId());
                  this.mGuild.setCreationDateMS(ServerConnection.smServerTimeMS);
                  this.mGuild.setLastActivityDateMS(ServerConnection.smServerTimeMS);
                  this.mGuild.setAccessType(param5);
                  this.mGuild.setLastWeekSeasonIndex(smWeeklySeasonIndex - 1);
                  this.mGuild.setCurrentSeasonIndex(smWeeklySeasonIndex);
                  this.mGuild.setLastWeekTotalScore(0);
                  this.mGuild.setLastWeekGuildPosition(-1);
               }
               InstanceMng.getServerConnection().createGuildInstance(this.mGuild.getName(),ServerConnection.smServerTimeMS,this.mGuild.getEmblemBG(),this.mGuild.getEmblemFG(),this.onGuildCreatedACK,this.onGuildCreationError,this.mGuild.getDescription(),this.mGuild.getAccessType());
            }
            else
            {
               Utils.setLogText(TextManager.getText("TID_GUILD_NAME_TAKEN"),true);
               if(InstanceMng.getPopupMng().getPopupShown() is PopupGuilds)
               {
                  PopupGuilds(InstanceMng.getPopupMng().getPopupShown()).onGuildCreationFailed();
               }
            }
         }
      }
      
      private function onGuildCreationError() : void
      {
         this.mGuild = null;
         Utils.setLogText(TextManager.getText("TID_GUILD_CREATION_ERROR"),true);
      }
      
      private function onGuildCreatedACK(param1:String, param2:String = "") : void
      {
         if(this.mGuild)
         {
            this.mGuild.setId(param1);
         }
         var _loc3_:UserData = Utils.getOwnerUserData();
         _loc3_.substractGold(-smGoldCost);
         _loc3_.setGuildId(param1);
         _loc3_.setGuildRank(RANK_LEADER);
         _loc3_.setGuildJoinDateMS(this.mGuild.getCreationDateMS());
         _loc3_.setGuildLastActivityDateMS(this.mGuild.getCreationDateMS());
         var _loc4_:PopupGuilds = InstanceMng.getPopupMng().getPopupShown() is PopupGuilds ? PopupGuilds(InstanceMng.getPopupMng().getPopupShown()) : null;
         if(_loc4_)
         {
            _loc4_.onGuildCreatedPerformOps(this.mGuild);
         }
         this.checkNotificationsForGuild();
         FSTracker.trackMiscAction(FSTracker.CATEGORY_GUILDS,FSTracker.ACTION_GUILDS_GUILD_CREATED,{"name":this.mGuild.getName()});
      }
      
      public function onGuildEmblemChanged(param1:Object) : void
      {
         var _loc2_:UserData = Utils.getOwnerUserData();
         _loc2_.substractGold(-CHANGE_EMBLEM_GOLD_COST);
         var _loc3_:PopupGuilds = InstanceMng.getPopupMng().getPopupShown() is PopupGuilds ? PopupGuilds(InstanceMng.getPopupMng().getPopupShown()) : null;
         if(_loc3_)
         {
            _loc3_.onManageEmblemChanged();
         }
         this.refreshMyGuild();
         Utils.setLogText(TextManager.getText("TID_GUILD_EMBLEM_UPDATED"));
      }
      
      public function onGuildEmblemChangedError() : void
      {
         var _loc1_:PopupGuilds = InstanceMng.getPopupMng().getPopupShown() is PopupGuilds ? PopupGuilds(InstanceMng.getPopupMng().getPopupShown()) : null;
         if(_loc1_)
         {
            _loc1_.onManageEmblemChangedFailed();
         }
         Utils.setLogText(TextManager.getText("TID_GUILD_EMBLEM_UPDATE_ERROR"),true);
      }
      
      public function onGuildDescChanged(param1:Object = null) : void
      {
         this.refreshMyGuild();
         Utils.setLogText(TextManager.getText("TID_GUILD_DESC_CHANGE_SUCCESS"));
      }
      
      public function onDescChangeFailed(param1:Object = null) : void
      {
         this.refreshMyGuild();
         Utils.setLogText(TextManager.getText("TID_GUILD_DESC_CHANGE_FAILED"));
      }
      
      public function createFakeGuild() : Guild
      {
         var _loc1_:String = "Guild_" + Utils.generateRandomString(5);
         var _loc2_:Guild = new Guild(_loc1_,"","","0123456789");
         _loc2_.setGlobalTotalScore(Utils.randomNumber(20,2000));
         return _loc2_;
      }
      
      public function createGuildByServerInfo(param1:Object) : Guild
      {
         var _loc2_:Guild = new Guild(param1.name,param1.emblemBG,param1.emblemFG,param1.leaderId);
         _loc2_.setId(Utils.getDataId(param1));
         _loc2_.setDescription(param1.description);
         _loc2_.setCreationDateMS(param1.creationDateMS);
         _loc2_.setLastActivityDateMS(param1.lastActivityDateMS);
         var _loc3_:Vector.<String> = param1.hasOwnProperty("members") ? this.processMembersList(String(param1.members)) : null;
         _loc2_.setMembers(_loc3_);
         if((Boolean(_loc3_ == null || _loc3_ && _loc3_.length == 0)) && Boolean(param1.hasOwnProperty("membersAmount")) && param1.membersAmount > 0)
         {
            _loc2_.setForcedMembersAmount(param1.membersAmount);
         }
         _loc2_.setLeaderId(param1.leaderId);
         _loc2_.setLeaderTempId(param1.leaderTempId);
         _loc2_.setLeaderTempCreationTime(param1.leaderTempCreationTime);
         _loc2_.setAccessType(param1.accessType);
         _loc2_.setActiveMembersData(param1.activeMembersData);
         _loc2_.setLastWeekSeasonIndex(param1.lastWeekSeasonIndex);
         _loc2_.setLastWeekTotalScore(param1.lastWeekTotalScore);
         _loc2_.setLastWeekGuildPosition(param1.lastWeekGuildPosition);
         _loc2_.setCurrentSeasonIndex(param1.currentWeekSeasonIndex);
         _loc2_.setWeeklyPvPScore(param1.weeklyPvPScore);
         _loc2_.setWeeklyDungeonsScore(param1.weeklyDungeonsScore);
         _loc2_.setWeeklyRaidsScore(param1.weeklyRaidsScore);
         _loc2_.setWeeklyTotalScore(param1.weeklyTotalScore);
         _loc2_.setWeeklyHighestScore(param1.weeklyHighestScore);
         _loc2_.setGlobalPvPScore(param1.globalPvPScore);
         _loc2_.setGlobalDungeonsScore(param1.globalDungeonsScore);
         _loc2_.setGlobalRaidsScore(param1.globalRaidsScore);
         _loc2_.setGlobalTotalScore(param1.globalTotalScore);
         _loc2_.setGlobalHighestScore(param1.globalHighestScore);
         _loc2_.setHighestRankAchieved(param1.highestRankAchieved);
         _loc2_.setGuildInfoId(param1.guildObjId);
         return _loc2_;
      }
      
      public function processMembersList(param1:String) : Vector.<String>
      {
         var _loc2_:Vector.<String> = null;
         var _loc4_:int = 0;
         var _loc3_:Array = param1.split(",");
         if(_loc3_)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               if(_loc3_[_loc4_] != "")
               {
                  if(_loc2_ == null)
                  {
                     _loc2_ = new Vector.<String>();
                  }
                  _loc2_.push(_loc3_[_loc4_]);
               }
               _loc4_++;
            }
         }
         return _loc2_;
      }
      
      public function getMemberTitleByRankId(param1:int, param2:Boolean = true) : String
      {
         var _loc3_:String = "";
         switch(param1)
         {
            case RANK_LEADER:
               _loc3_ = TextManager.getText("TID_GUILD_RANK_01",!param2);
               if(this.mGuild)
               {
                  _loc3_ += this.mGuild.isOwnerLeaderTemp() ? " (" + TextManager.getText("TID_GUILD_TEMPORARY") + ")" : "";
               }
               break;
            case RANK_OFFICER:
               _loc3_ = TextManager.getText("TID_GUILD_RANK_02",!param2);
               break;
            case RANK_VETERAN:
               _loc3_ = TextManager.getText("TID_GUILD_RANK_03",!param2);
               break;
            case RANK_MEMBER:
               _loc3_ = TextManager.getText("TID_GUILD_RANK_04",!param2);
               break;
            case RANK_UNCONFIRMED:
               _loc3_ = TextManager.getText("TID_GUILD_RANK_05",!param2);
               break;
            case RANK_GUILD_MOTD:
               _loc3_ = TextManager.getText("TID_GUILD_NAME_SINGLE",!param2);
         }
         return _loc3_;
      }
      
      public function isWeeklyEventActive() : Boolean
      {
         var _loc1_:Boolean = false;
         if(ServerConnection.smServerTimeMS != -1 && smWeeklyEventType != -1 && smWeeklyEventsStartingTimeMS != -1 && smWeeklyEventsEndingTimeMS != -1)
         {
            _loc1_ = ServerConnection.smServerTimeMS > smWeeklyEventsStartingTimeMS && ServerConnection.smServerTimeMS < smWeeklyEventsEndingTimeMS;
         }
         return _loc1_;
      }
      
      public function isWeeklyEventExpired() : Boolean
      {
         var _loc1_:Boolean = false;
         if(ServerConnection.smServerTimeMS != -1 && smWeeklyEventType != -1 && smWeeklyEventsStartingTimeMS != -1 && smWeeklyEventsEndingTimeMS != -1)
         {
            _loc1_ = ServerConnection.smServerTimeMS > smWeeklyEventsEndingTimeMS;
         }
         return _loc1_;
      }
      
      public function getWeeklyEventTimeLeft() : String
      {
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc1_:String = "";
         var _loc2_:Number = -1;
         if(ServerConnection.smServerTimeMS != -1)
         {
            _loc2_ = ServerConnection.smServerTimeMS < smWeeklyEventsStartingTimeMS ? smWeeklyEventsStartingTimeMS - ServerConnection.smServerTimeMS : smWeeklyEventsEndingTimeMS - ServerConnection.smServerTimeMS;
         }
         var _loc3_:String = "";
         if(_loc2_ != -1 && _loc2_ > 0)
         {
            _loc4_ = TimerUtil.msToDays(_loc2_) > 0;
            _loc5_ = TimerUtil.msToHour(_loc2_) > 0;
            _loc6_ = TimerUtil.msToMin(_loc2_) > 0;
            _loc7_ = _loc4_ ? TextManager.getText("TID_GEN_TIME_DAYS",true) + " " : null;
            _loc8_ = !_loc4_ ? TextManager.getText("TID_GEN_TIME_HOURS",true) : null;
            _loc9_ = !_loc4_ && !_loc5_ ? TextManager.getText("TID_GEN_TIME_MINUTES",true) : null;
            _loc10_ = !_loc4_ && !_loc5_ && !_loc6_ ? TextManager.getText("TID_GEN_TIME_SECONDS",true) : null;
            _loc3_ = " " + TimerUtil.getTimeTextFromMs(_loc2_,_loc7_,_loc8_,_loc9_,_loc10_);
         }
         return _loc2_ != -1 && _loc2_ > 0 ? _loc3_ : " ???";
      }
      
      public function getWeeklySeasonTimeLeft() : String
      {
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc1_:String = "";
         var _loc2_:Number = -1;
         if(ServerConnection.smServerTimeMS != -1 && smWeeklySeasonStartingTimeMS != -1 && smWeeklySeasonEndingTimeMS != -1)
         {
            _loc2_ = ServerConnection.smServerTimeMS < smWeeklySeasonStartingTimeMS ? smWeeklySeasonStartingTimeMS - ServerConnection.smServerTimeMS : smWeeklySeasonEndingTimeMS - ServerConnection.smServerTimeMS;
         }
         var _loc3_:String = "";
         if(_loc2_ != -1 && _loc2_ > 0)
         {
            _loc4_ = TimerUtil.msToDays(_loc2_) > 0;
            _loc5_ = _loc4_ ? TextManager.getText("TID_GEN_TIME_DAYS_ABR",true) + " " : null;
            _loc6_ = _loc4_ ? TextManager.getText("TID_GEN_TIME_HOURS_ABR",true) + " " : ":";
            _loc7_ = _loc4_ ? TextManager.getText("TID_GEN_TIME_MINUTES_ABR",true) : ":";
            _loc8_ = _loc4_ ? null : "";
            _loc3_ = " " + TimerUtil.getTimeTextFromMs(_loc2_,_loc5_,_loc6_,_loc7_,_loc8_);
         }
         return _loc2_ != -1 && _loc2_ > 0 ? _loc3_ : " ???";
      }
      
      public function leaveGuild() : void
      {
         if(this.mGuild)
         {
            if(!this.mGuild.isOwnerLeaderTemp())
            {
               InstanceMng.getServerConnection().leaveGuild(this.mGuild.getId(),this.onGuildLeftSuccessfuly);
            }
            else
            {
               TweenMax.delayedCall(2,this.notifyPlayerIsTemporaryOwner);
            }
         }
         else
         {
            FSDebug.debugTrace("No guild found!");
         }
      }
      
      private function resetOwnerGuildInfo() : void
      {
         var _loc1_:UserData = Utils.getOwnerUserData();
         this.mGuild = null;
         if(_loc1_)
         {
            _loc1_.setGuildMemberId("");
            _loc1_.setGuildId("");
            _loc1_.setGuildRank(-1);
            _loc1_.setGuildJoinDateMS(-1);
            _loc1_.setGuildLastActivityDateMS(-1);
            _loc1_.setGuildWeeklyPvPScore(0);
            _loc1_.setGuildWeeklyDungeonsScore(0);
            _loc1_.setGuildWeeklyRaidsScore(0);
            _loc1_.setGuildWeeklyTotalScore(0);
            _loc1_.setGuildGlobalPvPScore(0);
            _loc1_.setGuildGlobalDungeonsScore(0);
            _loc1_.setGuildGlobalRaidsScore(0);
            _loc1_.setGuildGlobalTotalScore(0);
            _loc1_.setGuildCurrentWeekSeasonIndex(-1);
            _loc1_.setGuildLastWeekSeasonIndex(-1);
            _loc1_.setGuildLastWeekTotalScore(0);
         }
         InstanceMng.getUserDataMng().persistenceSaveData();
         FSTracker.trackMiscAction(FSTracker.CATEGORY_GUILDS,FSTracker.ACTION_GUILD_MEMBER_INFO_RESETED);
      }
      
      public function onGuildLeftSuccessfuly(param1:Boolean = true) : void
      {
         var _loc3_:UserData = null;
         var _loc4_:String = null;
         if(param1)
         {
            Utils.setLogText(TextManager.getText("TID_GUILD_LEAVE_COMPLETED"));
            _loc3_ = Utils.getOwnerUserData();
            _loc4_ = "";
            if(_loc3_.getGuildId() != "" && _loc3_.getGuildId() != null)
            {
               _loc4_ = _loc3_.getGuildId();
            }
            else if(this.mGuild != null && this.mGuild.getId() != null && this.mGuild.getId() != null)
            {
               _loc4_ = this.mGuild.getId();
            }
         }
         this.resetOwnerGuildInfo();
         var _loc2_:PopupGuilds = InstanceMng.getPopupMng().getPopupShown() is PopupGuilds ? PopupGuilds(InstanceMng.getPopupMng().getPopupShown()) : null;
         if(_loc2_ == null)
         {
            _loc2_ = InstanceMng.getPopupMng().getPopupInBackground() is PopupGuilds ? PopupGuilds(InstanceMng.getPopupMng().getPopupInBackground()) : null;
         }
         if(_loc2_)
         {
            _loc2_.onGuildLeft();
         }
         if(InstanceMng.getApplication().getGuildsPanel())
         {
            InstanceMng.getApplication().getGuildsPanel().onGuildLeft();
         }
         if(InstanceMng.getCurrentScreen() is FSRaidsScreen)
         {
            FSRaidsScreen(InstanceMng.getCurrentScreen()).cleanScrollContainer(FSRaidsScreen(InstanceMng.getCurrentScreen()).createRightSection);
         }
      }
      
      public function joinGuild(param1:String) : void
      {
         if(param1 != "" && param1 != null)
         {
            InstanceMng.getServerConnection().joinGuild(param1,null,this.onGuildJoinedFailed);
         }
      }
      
      public function onGuildJoinedSuccess(param1:String, param2:String, param3:int = 3, param4:String = null) : void
      {
         this.removePlayerRequestSentFromLogic(param1);
         var _loc5_:UserData = Utils.getOwnerUserData();
         _loc5_.setGuildMemberId(param2);
         _loc5_.setGuildId(param1);
         _loc5_.setGuildRank(param3);
         _loc5_.setGuildJoinDateMS(ServerConnection.smServerTimeMS);
         _loc5_.setGuildLastActivityDateMS(-1);
         _loc5_.setGuildWeeklyPvPScore(0);
         _loc5_.setGuildWeeklyDungeonsScore(0);
         _loc5_.setGuildWeeklyRaidsScore(0);
         _loc5_.setGuildWeeklyTotalScore(0);
         _loc5_.setGuildGlobalPvPScore(0);
         _loc5_.setGuildGlobalDungeonsScore(0);
         _loc5_.setGuildGlobalRaidsScore(0);
         _loc5_.setGuildGlobalTotalScore(0);
         InstanceMng.getUserDataMng().persistenceSaveData();
         this.refreshMyGuild();
         var _loc6_:PopupGuilds = InstanceMng.getPopupMng().getPopupShown() is PopupGuilds ? PopupGuilds(InstanceMng.getPopupMng().getPopupShown()) : null;
         if(_loc6_)
         {
            _loc6_.onGuildJoinedPerformOps();
         }
         this.checkNotificationsForGuild();
         if(Config.getConfig().hasQuests() && Boolean(InstanceMng.getQuestsMng()))
         {
            InstanceMng.getQuestsMng().checkIfAnyQuestIsCompleted(false);
         }
         if(InstanceMng.getCurrentScreen() is FSRaidsScreen)
         {
            FSRaidsScreen(InstanceMng.getCurrentScreen()).cleanScrollContainer(FSRaidsScreen(InstanceMng.getCurrentScreen()).createRightSection);
         }
         Utils.setLogText(TextManager.getText("TID_GUILD_JOIN_COMPLETED"));
         if(param4 != null && param4 != "")
         {
            InstanceMng.getServerConnection().createMessageOfTheDay(param4,true);
         }
         FSTracker.trackFirebaseEvent("GUILD_JOINED");
      }
      
      public function onGuildJoinedFailed() : void
      {
         Utils.setLogText(TextManager.getText("TID_GUILD_JOIN_ERROR"),true);
      }
      
      public function onPlayerGuildRequestsArrived(param1:Array) : void
      {
         var _loc2_:int = 0;
         if(param1 != null && param1.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               this.addPlayerGuildRequestSent(param1[_loc2_].guildId);
               _loc2_++;
            }
         }
      }
      
      public function addPlayerGuildRequestSent(param1:String) : void
      {
         if(this.mPlayerRequestsSent == null)
         {
            this.mPlayerRequestsSent = new Vector.<String>();
         }
         if(param1 != null && param1 != "")
         {
            this.mPlayerRequestsSent.push(param1);
         }
      }
      
      public function hasPlayerAlreadySentRequest(param1:String) : Boolean
      {
         var _loc3_:int = 0;
         var _loc2_:Boolean = false;
         if(Boolean(this.mPlayerRequestsSent) && this.mPlayerRequestsSent.length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < this.mPlayerRequestsSent.length)
            {
               _loc2_ = param1 == this.mPlayerRequestsSent[_loc3_];
               if(_loc2_)
               {
                  return true;
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      public function removePlayerRequestSentFromLogic(param1:String) : void
      {
         var _loc2_:int = 0;
         if(Boolean(this.mPlayerRequestsSent) && this.mPlayerRequestsSent.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mPlayerRequestsSent.length)
            {
               if(param1 == this.mPlayerRequestsSent[_loc2_])
               {
                  this.mPlayerRequestsSent.splice(_loc2_,1);
               }
               _loc2_++;
            }
         }
      }
      
      public function getMyGuild() : Guild
      {
         return this.mGuild;
      }
      
      public function setMyGuild(param1:Guild) : void
      {
         this.mGuild = param1;
      }
      
      public function getGuildEventTextByEvent(param1:Object) : String
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:RaidDef = null;
         var _loc9_:String = null;
         var _loc10_:GoldDef = null;
         var _loc2_:String = "";
         if(Boolean(param1) && Boolean(InstanceMng.getGuildsMng()))
         {
            _loc3_ = int(param1.eventType);
            _loc4_ = param1.playerInvolvedNick;
            _loc5_ = param1.data != null ? param1.data : null;
            _loc9_ = TextManager.getText("TID_GUILD_RAID_COMPLETED",true);
            switch(_loc3_)
            {
               case GUILD_EVENT_PVP_WON:
                  _loc2_ = TextManager.getText("TID_GUILD_PVP_VICTORY",true);
                  break;
               case GUILD_EVENT_DUNGEON_EASY:
                  _loc2_ = TextManager.getText("TID_GUILD_DUNGEON_EASY_COMPLETED",true);
                  break;
               case GUILD_EVENT_DUNGEON_MED:
                  _loc2_ = TextManager.getText("TID_GUILD_DUNGEON_MED_COMPLETED",true);
                  break;
               case GUILD_EVENT_DUNGEON_HARD:
                  _loc2_ = TextManager.getText("TID_GUILD_DUNGEON_HARD_COMPLETED",true);
                  break;
               case GUILD_EVENT_DUNGEON_EXPERT:
                  _loc2_ = TextManager.getText("TID_GUILD_DUNGEON_EXPERT_COMPLETED",true);
                  break;
               case GUILD_EVENT_JOIN:
                  _loc2_ = TextManager.getText("TID_GUILD_JOIN_TEXT",true);
                  break;
               case GUILD_EVENT_PROMOTE:
                  _loc6_ = this.getMemberTitleByRankId(int(_loc5_),false);
                  _loc2_ = TextManager.replaceParameters(TextManager.getText("TID_GUILD_PROMOTE_TEXT",true),[_loc6_]);
                  break;
               case GUILD_EVENT_DEMOTE:
                  _loc6_ = this.getMemberTitleByRankId(int(_loc5_),false);
                  _loc2_ = TextManager.replaceParameters(TextManager.getText("TID_GUILD_DEMOTE_TEXT",true),[_loc6_]);
                  break;
               case GUILD_EVENT_KICK:
                  _loc2_ = TextManager.getText("TID_GUILD_KICK_TEXT",true);
                  break;
               case GUILD_EVENT_LEFT:
                  _loc2_ = TextManager.getText("TID_GUILD_LEAVE_TEXT",true);
                  break;
               case GUILD_EVENT_GOT_LEGENDARY:
                  _loc7_ = InstanceMng.getCardsDefMng().getDefBySku(_loc5_) ? InstanceMng.getCardsDefMng().getDefBySku(_loc5_).getName() : "";
                  _loc2_ = TextManager.replaceParameters(TextManager.getText("TID_GUILD_LEGENDARY_TEXT",true),[_loc7_]);
                  break;
               case GUILD_WEEKLY_EVENT_STARTED:
                  _loc2_ = TextManager.getText("TID_GUILD_EVENT_STARTED",true);
                  break;
               case GUILD_WEEKLY_EVENT_ENDED:
                  _loc2_ = TextManager.getText("TID_GUILD_EVENT_ENDED",true);
                  break;
               case GUILD_EVENT_RAID_EASY_COMPLETED:
                  _loc8_ = RaidDef(InstanceMng.getRaidsDefMng().getDefBySku(_loc5_));
                  _loc2_ = TextManager.replaceParameters(_loc9_,[_loc8_.getName(),TextManager.getText("TID_DUNGEON_DIFFICULTY_01")]);
                  break;
               case GUILD_EVENT_RAID_MEDIUM_COMPLETED:
                  _loc8_ = RaidDef(InstanceMng.getRaidsDefMng().getDefBySku(_loc5_));
                  _loc2_ = TextManager.replaceParameters(_loc9_,[_loc8_.getName(),TextManager.getText("TID_DUNGEON_DIFFICULTY_02")]);
                  break;
               case GUILD_EVENT_RAID_HARD_COMPLETED:
                  _loc8_ = RaidDef(InstanceMng.getRaidsDefMng().getDefBySku(_loc5_));
                  _loc2_ = TextManager.replaceParameters(_loc9_,[_loc8_.getName(),TextManager.getText("TID_DUNGEON_DIFFICULTY_03")]);
                  break;
               case GUILD_EVENT_RAID_EXPERT_COMPLETED:
                  _loc8_ = RaidDef(InstanceMng.getRaidsDefMng().getDefBySku(_loc5_));
                  _loc2_ = TextManager.replaceParameters(_loc9_,[_loc8_.getName(),TextManager.getText("TID_RAID_EXPERT")]);
                  break;
               case GUILD_EVENT_RAID_REWARDS_READY:
                  _loc2_ = TextManager.getText("TID_RAID_GUILD_REWARDS_READY",true);
                  break;
               case GUILD_EVENT_GOLD_BAG_PURCHASED:
                  _loc10_ = GoldDef(InstanceMng.getGoldDefMng().getDefBySku(_loc5_));
                  _loc2_ = TextManager.replaceParameters(TextManager.getText("TID_SHOP_GUILD_SHARE",true),[_loc10_.getName()]);
                  break;
               case GUILD_EVENT_RECRUITED_FRIEND:
                  _loc2_ = TextManager.getText("TID_RECRUIT_GUILD_MESSAGE",true);
            }
         }
         return _loc2_;
      }
      
      public function getGuildEventMultiplier(param1:int) : Number
      {
         var _loc2_:Number = NaN;
         switch(param1)
         {
            case WEEKLY_EVENT_PVP:
               _loc2_ = 1.5;
               break;
            case WEEKLY_EVENT_DUNGEONS:
               _loc2_ = 1.5;
         }
         return _loc2_;
      }
      
      public function getPvPWonPointsWon() : Number
      {
         var _loc1_:Number = smPvPWonPoints;
         if(this.isWeeklyEventActive() && smWeeklyEventType == WEEKLY_EVENT_PVP)
         {
            _loc1_ *= this.getGuildEventMultiplier(smWeeklyEventType);
         }
         return Math.floor(_loc1_);
      }
      
      public function getDungeonCompletedPointsWon(param1:int) : Number
      {
         var _loc2_:Number = 0;
         switch(param1)
         {
            case DungeonsMng.DUNGEON_DIFFICULTY_EASY:
               _loc2_ = smDungeonEasyCompletedPoints;
               break;
            case DungeonsMng.DUNGEON_DIFFICULTY_MEDIUM:
               _loc2_ = smDungeonMedCompletedPoints;
               break;
            case DungeonsMng.DUNGEON_DIFFICULTY_HARD:
               _loc2_ = smDungeonHardCompletedPoints;
               break;
            case DungeonsMng.DUNGEON_DIFFICULTY_EXPERT:
               _loc2_ = smDungeonExpertCompletedPoints;
         }
         if(this.isWeeklyEventActive() && smWeeklyEventType == WEEKLY_EVENT_DUNGEONS)
         {
            _loc2_ *= this.getGuildEventMultiplier(smWeeklyEventType);
         }
         return Math.floor(_loc2_);
      }
      
      public function createGuildDungeonCompletedEvent(param1:int) : void
      {
         var _loc3_:int = 0;
         var _loc2_:UserData = Utils.getOwnerUserData();
         if(Config.HAS_GUILDS && _loc2_.hasGuild())
         {
            switch(param1)
            {
               case DungeonsMng.DUNGEON_DIFFICULTY_EASY:
                  _loc3_ = GUILD_EVENT_DUNGEON_EASY;
                  break;
               case DungeonsMng.DUNGEON_DIFFICULTY_MEDIUM:
                  _loc3_ = GUILD_EVENT_DUNGEON_MED;
                  break;
               case DungeonsMng.DUNGEON_DIFFICULTY_HARD:
                  _loc3_ = GUILD_EVENT_DUNGEON_HARD;
                  break;
               case DungeonsMng.DUNGEON_DIFFICULTY_EXPERT:
                  _loc3_ = GUILD_EVENT_DUNGEON_EXPERT;
            }
            InstanceMng.getServerConnection().createGuildEvent(_loc2_.getGuildId(),_loc3_,_loc2_.getAccountId(),_loc2_.getName(),_loc2_.getRankIndex(),_loc2_.getGuildRank());
         }
      }
      
      public function createGuildPvPWonEvent() : void
      {
         var _loc1_:UserData = Utils.getOwnerUserData();
         if(Config.HAS_GUILDS && _loc1_.hasGuild())
         {
            InstanceMng.getServerConnection().createGuildEvent(_loc1_.getGuildId(),GuildsMng.GUILD_EVENT_PVP_WON,_loc1_.getAccountId(),_loc1_.getName(),_loc1_.getRankIndex(),_loc1_.getGuildRank());
         }
      }
      
      public function resetGlobalVariables() : void
      {
         smServerUserInfoReceived = false;
      }
      
      public function notifyCardReceivedToGuild(param1:CardDef) : void
      {
         var _loc3_:RarityDef = null;
         var _loc2_:UserData = Utils.getOwnerUserData();
         if(Boolean(Config.HAS_GUILDS && _loc2_ && _loc2_.hasGuild()) && Boolean(param1) && _loc2_.flagsGetShareInfoToGuild())
         {
            _loc3_ = RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(param1.getCardRarity()));
            if(_loc3_.getIndex() == 4)
            {
               InstanceMng.getServerConnection().createGuildEvent(_loc2_.getGuildId(),GuildsMng.GUILD_EVENT_GOT_LEGENDARY,_loc2_.getAccountId(),_loc2_.getName(),_loc2_.getRankIndex(),_loc2_.getGuildRank(),param1.getSku());
            }
         }
      }
      
      public function isOwnerGuildMaster() : Boolean
      {
         return Boolean(this.mGuild) && this.mGuild.isOwnerGuildLeader();
      }
      
      public function notifyPlayerIsTemporaryOwner() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:Guild = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         if(!this.mGuild.hasPrivilegesForManaging())
         {
            _loc1_ = TextManager.getText("TID_GUILD_OPERATION_INCOMPLETE");
            _loc2_ = TextManager.getText("TID_GUILD_TEMP_OWNER");
            _loc3_ = InstanceMng.getGuildsMng().getMyGuild();
            _loc4_ = TimerUtil.daysToMs(15);
            _loc5_ = _loc3_.getLeaderTempCreationTime();
            _loc6_ = _loc5_ + _loc4_;
            _loc7_ = _loc6_ - ServerConnection.smServerTimeMS;
            _loc8_ = Math.ceil(TimerUtil.msToDays(_loc7_));
            _loc9_ = TextManager.replaceParameters(_loc2_,[_loc8_,TextManager.getText("TID_GEN_TIME_DAYS")]);
            Utils.setLogText(_loc9_,false,false);
         }
      }
   }
}

