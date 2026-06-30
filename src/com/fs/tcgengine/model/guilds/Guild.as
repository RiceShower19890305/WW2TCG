package com.fs.tcgengine.model.guilds
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.GuildsMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.guilds.GuildMemberSlot;
   import com.gamesparks.api.types.Player;
   import flash.utils.Dictionary;
   
   public class Guild implements FSModelUnloadableInterface
   {
      
      private var mId:String;
      
      private var mName:String;
      
      private var mDescription:String;
      
      private var mLeaderId:String;
      
      private var mLeaderTempId:String = null;
      
      private var mLeaderTempCreationTime:Number;
      
      private var mWeeklyPvPScore:FSNumber;
      
      private var mWeeklyDungeonsScore:FSNumber;
      
      private var mWeeklyRaidsScore:FSNumber;
      
      private var mWeeklyTotalScore:FSNumber;
      
      private var mWeeklyHighestScore:FSNumber;
      
      private var mGlobalPvPScore:FSNumber;
      
      private var mGlobalDungeonsScore:FSNumber;
      
      private var mGlobalRaidsScore:FSNumber;
      
      private var mGlobalTotalScore:FSNumber;
      
      private var mGlobalHighestScore:FSNumber;
      
      private var mHighestRankAchieved:FSNumber;
      
      private var mCreationDateMS:Number;
      
      private var mLastActivityDateMS:Number;
      
      private var mMembersIds:Vector.<String>;
      
      private var mAccessType:int;
      
      private var mEmblemBG:String;
      
      private var mEmblemFG:String;
      
      private var mMembersRanks:Dictionary;
      
      private var mActiveMembersData:*;
      
      private var mLastWeekSeasonIndex:int;
      
      private var mLastWeekGuildPosition:int;
      
      private var mCurrentWeekSeasonIndex:int;
      
      private var mLastWeekTotalScore:FSNumber;
      
      private var mGuildInfoMembersVector:Vector.<UserData>;
      
      private var mGSGuildInfoId:String;
      
      private var mForcedMembersAmount:int = -1;
      
      public function Guild(param1:String, param2:String, param3:String, param4:String)
      {
         super();
         this.mName = param1;
         this.mEmblemBG = param2;
         this.mEmblemFG = param3;
         this.mLeaderId = param4;
      }
      
      public function getId() : String
      {
         return this.mId;
      }
      
      public function getName() : String
      {
         return this.mName;
      }
      
      public function getLeaderId() : String
      {
         return this.mLeaderId;
      }
      
      public function getLeaderTempId() : String
      {
         return this.mLeaderTempId;
      }
      
      public function getLeaderTempCreationTime() : Number
      {
         return this.mLeaderTempCreationTime;
      }
      
      public function getDescription() : String
      {
         return this.mDescription;
      }
      
      public function getGuildInfoId() : String
      {
         return this.mGSGuildInfoId;
      }
      
      public function getWeeklyPvPScore() : Number
      {
         return this.mWeeklyPvPScore ? this.mWeeklyPvPScore.value : 0;
      }
      
      public function getWeeklyDungeonsScore() : Number
      {
         return this.mWeeklyDungeonsScore ? this.mWeeklyDungeonsScore.value : 0;
      }
      
      public function getWeeklyRaidsScore() : Number
      {
         return this.mWeeklyRaidsScore ? this.mWeeklyRaidsScore.value : 0;
      }
      
      public function getWeeklyTotalScore() : Number
      {
         return this.mWeeklyTotalScore ? this.mWeeklyTotalScore.value : 0;
      }
      
      public function getWeeklyHighestScore() : Number
      {
         return this.mWeeklyHighestScore ? this.mWeeklyHighestScore.value : 0;
      }
      
      public function getGlobalPvPScore() : Number
      {
         return this.mGlobalPvPScore ? this.mGlobalPvPScore.value : 0;
      }
      
      public function getGlobalDungeonsScore() : Number
      {
         return this.mGlobalDungeonsScore ? this.mGlobalDungeonsScore.value : 0;
      }
      
      public function getGlobalRaidsScore() : Number
      {
         return this.mGlobalRaidsScore ? this.mGlobalDungeonsScore.value : 0;
      }
      
      public function getGlobalTotalScore() : Number
      {
         return this.mGlobalTotalScore ? this.mGlobalTotalScore.value : 0;
      }
      
      public function getGlobalHighestScore() : Number
      {
         return this.mGlobalHighestScore ? this.mGlobalHighestScore.value : 0;
      }
      
      public function getHighestRankAchieved() : Number
      {
         return this.mHighestRankAchieved ? this.mHighestRankAchieved.value : 0;
      }
      
      public function getCreationDateMS() : Number
      {
         return this.mCreationDateMS;
      }
      
      public function getLastActivityDateMS() : Number
      {
         return this.mLastActivityDateMS;
      }
      
      public function getMemberIds() : Vector.<String>
      {
         return this.mMembersIds;
      }
      
      public function getMembersAmount() : int
      {
         if(this.mForcedMembersAmount > 0)
         {
            return this.mForcedMembersAmount;
         }
         return this.mMembersIds ? int(this.mMembersIds.length) : 0;
      }
      
      public function getAccessType() : int
      {
         return this.mAccessType;
      }
      
      public function getEmblemBG() : String
      {
         return this.mEmblemBG;
      }
      
      public function getEmblemFG() : String
      {
         return this.mEmblemFG;
      }
      
      public function getActiveMembersData() : *
      {
         return this.mActiveMembersData;
      }
      
      public function getLastWeekSeasonIndex() : int
      {
         return this.mLastWeekSeasonIndex;
      }
      
      public function getLastWeekTotalScore() : Number
      {
         return this.mLastWeekTotalScore ? this.mLastWeekTotalScore.value : 0;
      }
      
      public function getLastWeekGuildPosition() : int
      {
         return this.mLastWeekGuildPosition;
      }
      
      public function getCurrentSeasonIndex() : int
      {
         return this.mCurrentWeekSeasonIndex;
      }
      
      public function setId(param1:String) : void
      {
         this.mId = param1;
      }
      
      public function setDescription(param1:String) : void
      {
         this.mDescription = param1;
      }
      
      public function setLeaderId(param1:String) : void
      {
         this.mLeaderId = param1;
      }
      
      public function setLeaderTempId(param1:String) : void
      {
         this.mLeaderTempId = param1 == "" ? null : param1;
      }
      
      public function setLeaderTempCreationTime(param1:Number) : void
      {
         this.mLeaderTempCreationTime = param1;
      }
      
      public function setCreationDateMS(param1:Number) : void
      {
         this.mCreationDateMS = param1;
      }
      
      public function setLastActivityDateMS(param1:Number) : void
      {
         this.mLastActivityDateMS = param1;
      }
      
      public function setWeeklyPvPScore(param1:Number) : void
      {
         if(this.mWeeklyPvPScore == null)
         {
            this.mWeeklyPvPScore = new FSNumber();
         }
         this.mWeeklyPvPScore.value = param1;
      }
      
      public function setWeeklyDungeonsScore(param1:Number) : void
      {
         if(this.mWeeklyDungeonsScore == null)
         {
            this.mWeeklyDungeonsScore = new FSNumber();
         }
         this.mWeeklyDungeonsScore.value = param1;
      }
      
      public function setWeeklyRaidsScore(param1:Number) : void
      {
         if(this.mWeeklyRaidsScore == null)
         {
            this.mWeeklyRaidsScore = new FSNumber();
         }
         this.mWeeklyRaidsScore.value = param1;
      }
      
      public function setWeeklyTotalScore(param1:Number) : void
      {
         if(this.mWeeklyTotalScore == null)
         {
            this.mWeeklyTotalScore = new FSNumber();
         }
         this.mWeeklyTotalScore.value = param1;
      }
      
      public function setWeeklyHighestScore(param1:Number) : void
      {
         if(this.mWeeklyHighestScore == null)
         {
            this.mWeeklyHighestScore = new FSNumber();
         }
         this.mWeeklyHighestScore.value = param1;
      }
      
      public function setGlobalPvPScore(param1:Number) : void
      {
         if(this.mGlobalPvPScore == null)
         {
            this.mGlobalPvPScore = new FSNumber();
         }
         this.mGlobalPvPScore.value = param1;
      }
      
      public function setGlobalDungeonsScore(param1:Number) : void
      {
         if(this.mGlobalDungeonsScore == null)
         {
            this.mGlobalDungeonsScore = new FSNumber();
         }
         this.mGlobalDungeonsScore.value = param1;
      }
      
      public function setGlobalRaidsScore(param1:Number) : void
      {
         if(this.mGlobalRaidsScore == null)
         {
            this.mGlobalRaidsScore = new FSNumber();
         }
         this.mGlobalRaidsScore.value = param1;
      }
      
      public function setGlobalTotalScore(param1:Number) : void
      {
         if(this.mGlobalTotalScore == null)
         {
            this.mGlobalTotalScore = new FSNumber();
         }
         this.mGlobalTotalScore.value = param1;
      }
      
      public function setGlobalHighestScore(param1:Number) : void
      {
         if(this.mGlobalHighestScore == null)
         {
            this.mGlobalHighestScore = new FSNumber();
         }
         this.mGlobalHighestScore.value = param1;
      }
      
      public function setHighestRankAchieved(param1:Number) : void
      {
         if(this.mHighestRankAchieved == null)
         {
            this.mHighestRankAchieved = new FSNumber();
         }
         this.mHighestRankAchieved.value = param1;
      }
      
      public function setGuildInfoId(param1:String) : void
      {
         this.mGSGuildInfoId = param1;
      }
      
      public function setAccessType(param1:int) : void
      {
         this.mAccessType = param1;
      }
      
      public function setEmblemBG(param1:String) : void
      {
         this.mEmblemBG = param1;
      }
      
      public function setEmblemFG(param1:String) : void
      {
         this.mEmblemFG = param1;
      }
      
      public function setMembers(param1:Vector.<String>) : void
      {
         this.mMembersIds = param1;
      }
      
      public function setActiveMembersData(param1:*) : void
      {
         this.mActiveMembersData = param1;
      }
      
      public function setLastWeekSeasonIndex(param1:int) : void
      {
         this.mLastWeekSeasonIndex = param1;
      }
      
      public function setLastWeekTotalScore(param1:Number) : void
      {
         if(this.mLastWeekTotalScore == null)
         {
            this.mLastWeekTotalScore = new FSNumber();
         }
         this.mLastWeekTotalScore.value = param1;
      }
      
      public function setLastWeekGuildPosition(param1:int) : void
      {
         this.mLastWeekGuildPosition = param1;
      }
      
      public function setCurrentSeasonIndex(param1:int) : void
      {
         this.mCurrentWeekSeasonIndex = param1;
      }
      
      public function addMember(param1:String, param2:int) : void
      {
         if(!this.existsMemberByMemberId(param1))
         {
            if(this.mMembersIds == null)
            {
               this.mMembersIds = new Vector.<String>();
            }
            this.mMembersIds.push(param1);
            this.addMemberToMemberRanks(param1,param2);
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_GUILD_ALREADY_MEMBER"),true);
         }
      }
      
      public function refreshGuildMembersInfo() : void
      {
         if(this.mGuildInfoMembersVector)
         {
            this.mGuildInfoMembersVector.length = 0;
            this.mGuildInfoMembersVector = null;
         }
         this.mGuildInfoMembersVector = this.getMembersUserDataVector();
      }
      
      public function getMembersUserDataVector() : Vector.<UserData>
      {
         var _loc1_:int = 0;
         var _loc2_:UserData = null;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc7_:Object = null;
         var _loc6_:Vector.<UserData> = null;
         if(this.mActiveMembersData)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mActiveMembersData.length)
            {
               _loc2_ = InstanceMng.getServerConnection().getUserDataByUserProfile(this.mActiveMembersData[_loc1_]);
               if(_loc2_)
               {
                  _loc7_ = Player(this.mActiveMembersData[_loc1_]).getScriptData() ? Player(this.mActiveMembersData[_loc1_]).getScriptData().profile : null;
                  if(_loc7_)
                  {
                     _loc3_ = _loc7_.hasOwnProperty("guildRank") && _loc7_["guildRank"] != null ? int(_loc7_["guildRank"]) : GuildsMng.RANK_MEMBER;
                     _loc4_ = _loc7_.hasOwnProperty("weeklyTotalScore") && _loc7_["weeklyTotalScore"] != null ? Number(_loc7_["weeklyTotalScore"]) : 0;
                     _loc5_ = _loc7_.hasOwnProperty("globalTotalScore") && _loc7_["globalTotalScore"] != null ? Number(_loc7_["globalTotalScore"]) : 0;
                     _loc2_.setGuildRank(_loc3_);
                     _loc2_.setGuildWeeklyTotalScore(_loc4_);
                     _loc2_.setGuildGlobalTotalScore(_loc5_);
                     if(_loc6_ == null)
                     {
                        _loc6_ = new Vector.<UserData>();
                     }
                     _loc6_.push(_loc2_);
                  }
               }
               _loc1_++;
            }
         }
         return _loc6_;
      }
      
      private function onGuildMembersInfoReceived(param1:Vector.<UserData>) : void
      {
         var _loc2_:GuildMemberSlot = null;
         var _loc3_:int = 0;
         var _loc4_:UserData = null;
         var _loc5_:Object = null;
         var _loc6_:Vector.<UserData> = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         this.mGuildInfoMembersVector = param1;
         if(this.mGuildInfoMembersVector != null)
         {
            _loc7_ = 0;
            _loc8_ = 0;
            _loc9_ = 0;
            _loc10_ = 0;
            _loc3_ = 0;
            while(_loc3_ < this.mGuildInfoMembersVector.length)
            {
               if(_loc6_ == null)
               {
                  _loc6_ = new Vector.<UserData>();
               }
               _loc4_ = this.mGuildInfoMembersVector[_loc3_];
               _loc5_ = this.getActiveMemberDataByMemberId(_loc4_.getGuildMemberId());
               if(_loc5_)
               {
                  _loc4_.setGuildRank(_loc5_.rank);
                  _loc4_.setGuildJoinDateMS(_loc5_.joinDateMS);
                  _loc4_.setGuildLastActivityDateMS(_loc5_.lastActivityMS);
                  _loc7_ = _loc5_.currentWeekSeasonIndex == GuildsMng.smWeeklySeasonIndex ? Number(_loc5_.weeklyPvPScore) : 0;
                  _loc8_ = _loc5_.currentWeekSeasonIndex == GuildsMng.smWeeklySeasonIndex ? Number(_loc5_.weeklyDungeonsScore) : 0;
                  _loc9_ = _loc5_.currentWeekSeasonIndex == GuildsMng.smWeeklySeasonIndex ? Number(_loc5_.weeklyRaidsScore) : 0;
                  _loc10_ = _loc5_.currentWeekSeasonIndex == GuildsMng.smWeeklySeasonIndex ? Number(_loc5_.weeklyTotalScore) : 0;
                  _loc4_.setGuildWeeklyPvPScore(_loc7_);
                  _loc4_.setGuildWeeklyDungeonsScore(_loc8_);
                  _loc4_.setGuildWeeklyRaidsScore(_loc9_);
                  _loc4_.setGuildWeeklyTotalScore(_loc10_);
                  _loc4_.setGuildGlobalPvPScore(_loc5_.globalPvPScore);
                  _loc4_.setGuildGlobalDungeonsScore(_loc5_.globalDungeonsScore);
                  _loc4_.setGuildGlobalRaidsScore(_loc5_.globalRaidsScore);
                  _loc4_.setGuildGlobalTotalScore(_loc5_.globalTotalScore);
                  _loc4_.setGuildCurrentWeekSeasonIndex(_loc5_.currentWeekSeasonIndex);
                  _loc4_.setGuildLastWeekSeasonIndex(_loc5_.lastWeekSeasonIndex);
                  _loc4_.setGuildLastWeekTotalScore(_loc5_.lastWeekTotalScore);
               }
               _loc6_.push(_loc4_);
               _loc3_++;
            }
            _loc6_.sort(DictionaryUtils.sortGuildMembersWeeklyScore);
         }
      }
      
      public function getMemberUserDataById(param1:String) : UserData
      {
         var _loc3_:int = 0;
         var _loc2_:UserData = null;
         if(this.existsMemberByAccountId(param1) && Boolean(this.mGuildInfoMembersVector))
         {
            _loc3_ = 0;
            while(_loc3_ < this.mGuildInfoMembersVector.length)
            {
               if(this.mGuildInfoMembersVector[_loc3_].getAccountId() == param1)
               {
                  return this.mGuildInfoMembersVector[_loc3_];
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      public function getMembersString() : String
      {
         var _loc2_:int = 0;
         var _loc1_:String = "";
         if(Boolean(this.mMembersIds) && this.mMembersIds.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mMembersIds.length)
            {
               _loc1_ += this.mMembersIds[_loc2_];
               if(_loc2_ <= this.mMembersIds.length - 1)
               {
                  _loc1_ += ",";
               }
               _loc2_++;
            }
         }
         return _loc1_;
      }
      
      public function removeMemberById(param1:String) : void
      {
         if(this.existsMemberByMemberId(param1))
         {
            if(this.mMembersIds)
            {
               this.mMembersIds.splice(this.mMembersIds.indexOf(param1),1);
            }
            if(Boolean(this.mMembersRanks) && Boolean(this.mMembersRanks[param1]))
            {
               this.mMembersRanks[param1] = null;
               delete this.mMembersRanks[param1];
            }
         }
      }
      
      private function addMemberToMemberRanks(param1:String, param2:int) : Boolean
      {
         var _loc3_:Boolean = false;
         if(this.mMembersRanks == null)
         {
            this.mMembersRanks = new Dictionary(true);
         }
         if(this.mMembersRanks[param1] == null)
         {
            _loc3_ = true;
            this.mMembersRanks[param1] = param2;
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_GUILD_ALREADY_MEMBER"),true);
         }
         return _loc3_;
      }
      
      public function updateMemberRank(param1:String, param2:int) : void
      {
         FSDebug.debugTrace("Updating member Ranks");
         if(this.mMembersRanks)
         {
            if(this.mMembersRanks[param1] != null)
            {
               FSDebug.debugTrace("#1 Updating member " + param1 + " to rank: " + param2);
               this.mMembersRanks[param1] = param2;
            }
            else
            {
               FSDebug.debugTrace("#2 Updating member " + param1 + " to rank: " + param2);
               this.addMemberToMemberRanks(param1,param2);
            }
         }
         else
         {
            FSDebug.debugTrace("#3 Updating member " + param1 + " to rank: " + param2);
            this.addMemberToMemberRanks(param1,param2);
         }
      }
      
      public function existsMemberByMemberId(param1:String) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         if(Boolean(this.mMembersIds) && Boolean(param1 != "") && param1 != null)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mMembersIds.length)
            {
               if(this.mMembersIds[_loc2_] == param1)
               {
                  _loc3_ = true;
               }
               _loc2_++;
            }
         }
         return _loc3_;
      }
      
      public function getMemberIdsByRank(param1:int) : Vector.<String>
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc2_:Vector.<String> = null;
         if(Boolean(this.mMembersRanks) && Boolean(this.mMembersIds))
         {
            _loc3_ = 0;
            while(_loc3_ < this.mMembersIds.length)
            {
               if(this.mMembersRanks[this.mMembersIds[_loc3_]] == param1)
               {
                  if(_loc2_ == null)
                  {
                     _loc2_ = new Vector.<String>();
                  }
                  _loc2_.push(this.mMembersIds[_loc3_]);
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      public function getMemberRankById(param1:String) : int
      {
         var _loc2_:int = -1;
         if(this.existsMemberByMemberId(param1) && Boolean(this.mMembersRanks))
         {
            _loc2_ = !isNaN(this.mMembersRanks[param1]) ? int(this.mMembersRanks[param1]) : -1;
         }
         return _loc2_;
      }
      
      public function getActiveMemberDataByMemberId(param1:String) : Object
      {
         var _loc3_:int = 0;
         var _loc2_:Object = null;
         if(Boolean(this.mActiveMembersData) && this.mActiveMembersData.length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < this.mActiveMembersData.length)
            {
               if(Player(this.mActiveMembersData[_loc3_]).getScriptData().profile.guildMemberId == param1)
               {
                  return this.mActiveMembersData[_loc3_];
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      public function existsMemberByAccountId(param1:String) : Boolean
      {
         var _loc3_:int = 0;
         var _loc2_:Boolean = false;
         if(Boolean(this.mActiveMembersData) && this.mActiveMembersData.length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < this.mActiveMembersData.length)
            {
               if(Player(this.mActiveMembersData[_loc3_]).getId() == param1)
               {
                  return true;
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      public function isGuildInfoMemberOk() : Boolean
      {
         return this.mGuildInfoMembersVector != null && this.mGuildInfoMembersVector.length > 0;
      }
      
      public function isOwnerGuildLeader() : Boolean
      {
         return this.mLeaderId == InstanceMng.getServerConnection().getUserId();
      }
      
      public function isOwnerLeaderTemp() : Boolean
      {
         return this.mLeaderTempId != null && this.mLeaderTempId == InstanceMng.getServerConnection().getUserId();
      }
      
      public function hasPrivilegesForManaging() : Boolean
      {
         var _loc1_:Boolean = this.isOwnerGuildLeader();
         var _loc2_:Boolean = InstanceMng.getUserDataMng().getOwnerUserData().getGuildRank() == GuildsMng.RANK_OFFICER;
         return !this.isOwnerLeaderTemp() && (_loc1_ || _loc2_);
      }
      
      public function setForcedMembersAmount(param1:int) : void
      {
         if(param1 > 0)
         {
            this.mForcedMembersAmount = param1;
         }
      }
      
      public function destroy() : void
      {
         var _loc1_:int = 0;
         Utils.destroyObject(this.mWeeklyPvPScore);
         this.mWeeklyPvPScore = null;
         Utils.destroyObject(this.mWeeklyDungeonsScore);
         this.mWeeklyDungeonsScore = null;
         Utils.destroyObject(this.mWeeklyRaidsScore);
         this.mWeeklyRaidsScore = null;
         Utils.destroyObject(this.mWeeklyTotalScore);
         this.mWeeklyTotalScore = null;
         Utils.destroyObject(this.mWeeklyHighestScore);
         this.mWeeklyHighestScore = null;
         Utils.destroyObject(this.mGlobalPvPScore);
         this.mGlobalPvPScore = null;
         Utils.destroyObject(this.mGlobalDungeonsScore);
         this.mGlobalDungeonsScore = null;
         Utils.destroyObject(this.mGlobalRaidsScore);
         this.mGlobalRaidsScore = null;
         Utils.destroyObject(this.mGlobalTotalScore);
         this.mGlobalTotalScore = null;
         Utils.destroyObject(this.mGlobalHighestScore);
         this.mGlobalHighestScore = null;
         Utils.destroyObject(this.mHighestRankAchieved);
         this.mHighestRankAchieved = null;
         Utils.destroyObject(this.mLastWeekTotalScore);
         this.mLastWeekTotalScore = null;
         Utils.destroyArray(this.mMembersIds);
         this.mMembersIds = null;
         Utils.destroyArray(this.mGuildInfoMembersVector);
         this.mGuildInfoMembersVector = null;
         DictionaryUtils.clearDictionary(this.mMembersRanks);
         this.mMembersRanks = null;
         this.mActiveMembersData = null;
      }
   }
}

