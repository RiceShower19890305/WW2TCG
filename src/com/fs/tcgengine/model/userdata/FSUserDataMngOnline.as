package com.fs.tcgengine.model.userdata
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.FSFacebookPlugin;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.model.rules.MapDef;
   import com.fs.tcgengine.model.rules.TutorialMapDef;
   import com.fs.tcgengine.utils.Utils;
   import com.greensock.TweenMax;
   import flash.system.Capabilities;
   import flash.utils.Dictionary;
   import mx.utils.ObjectUtil;
   
   public class FSUserDataMngOnline extends UserDataMng
   {
      
      private var mPersistenceSaved:Boolean;
      
      public function FSUserDataMngOnline()
      {
         super();
      }
      
      override protected function load() : void
      {
         var _loc1_:Object = InstanceMng.getServerConnection().isUserLoggedIn() && Boolean(InstanceMng.getServerConnection().getBackendUserProfile()) ? InstanceMng.getServerConnection().getBackendUserProfile().profile : null;
         if(_loc1_ == null)
         {
            FSDebug.debugTrace("== ATTENTION -> Server profile null.. ==");
            return;
         }
         FSDebug.debugTrace("Server profile: " + ObjectUtil.toString(_loc1_));
         mOwnerUserData = this.buildUserDataFromProfile(_loc1_,true,Main.smOfflineUserData);
      }
      
      private function checkTutorialRewards(param1:Boolean, param2:Boolean, param3:UserData) : void
      {
         var _loc4_:TutorialMapDef = InstanceMng.getTutorialMapDefMng().getTutorialDefByTutorialReward("reward1");
         var _loc5_:TutorialMapDef = InstanceMng.getTutorialMapDefMng().getTutorialDefByTutorialReward("reward2");
         if(!param1 && _loc4_ != null)
         {
            if(param3.getCurrentLevelIndex(UserDataMng.DIFFICULTY_EASY) > _loc4_.getLevel())
            {
               FSDebug.debugTrace("Adding tutorial reward gift #1");
               this.addPackReward(_loc4_.getPackSku(),param3.getAccountId());
               param3.setTutorialReward1(true);
            }
            else
            {
               param3.setTutorialReward1(false);
            }
         }
         else
         {
            param3.setTutorialReward1(true);
         }
         if(!param2 && _loc5_ != null)
         {
            if(param3.getCurrentLevelIndex(UserDataMng.DIFFICULTY_EASY) > _loc5_.getLevel())
            {
               FSDebug.debugTrace("Adding tutorial reward gift #2");
               this.addPackReward(_loc5_.getPackSku(),param3.getAccountId());
               param3.setTutorialReward2(true);
            }
            else
            {
               param3.setTutorialReward2(false);
            }
         }
         else
         {
            param3.setTutorialReward2(true);
         }
      }
      
      public function addPackReward(param1:String, param2:String) : void
      {
         var _loc3_:Object = null;
         if(param2 != null && param2 != "")
         {
            _loc3_ = new Object();
            _loc3_.date = ServerConnection.smServerTimeMS;
            _loc3_.uid = param2;
            _loc3_.sku = param1;
            _loc3_.type = 1;
            _loc3_.amount = 1;
            _loc3_.origin = "GIFTS";
            _loc3_.from = "REWARDS";
            _loc3_.extraData = {};
            InstanceMng.getServerConnection().createEntityInCollection("rewards",_loc3_);
         }
      }
      
      private function syncBadgesCollection(param1:String, param2:String, param3:Boolean, param4:Object, param5:UserData) : void
      {
         var _loc6_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:int = 0;
         var _loc7_:int = InstanceMng.getLevelsDefMng().getLevelIndexByLevelSku(param1);
         param2 = param2 != null ? param2 : "level_01";
         if(!param3)
         {
            _loc8_ = InstanceMng.getBadgesDefMng().getRewardedBadgesForLevelRanks("level_01",param2);
            if(_loc8_ != null)
            {
               _loc9_ = 0;
               while(_loc9_ < _loc8_.length)
               {
                  if(_loc6_ == null)
                  {
                     _loc6_ = new Array();
                  }
                  _loc6_.push(_loc8_[_loc9_]);
                  _loc9_++;
               }
            }
         }
         else
         {
            _loc6_ = param4.badgesCollection != null && param4.badgesCollection != "" ? String(param4.badgesCollection).split(",") : null;
         }
         if(_loc6_)
         {
            this.addBadgesToCollection(_loc6_,param5);
         }
      }
      
      private function addBadgesToCollection(param1:Array, param2:UserData) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         if(param2)
         {
            param2.resetBadgeCollection();
         }
         if(param1 != null && param1.length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               _loc4_ = String(param1[_loc3_]).split(":")[0];
               _loc5_ = String(param1[_loc3_]).split(":")[1] > 0 ? int(String(param1[_loc3_]).split(":")[1]) : 1;
               if(_loc4_ != "")
               {
                  param2.addBadgeToCollection(_loc4_,_loc5_);
               }
               _loc3_++;
            }
         }
      }
      
      private function syncBadgesRewardsClaimed(param1:String, param2:UserData) : void
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         if(param1 != null && param1 != "")
         {
            _loc3_ = param1.split(",");
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc5_ = String(_loc3_[_loc4_]).split(":")[0];
               _loc6_ = int(String(_loc3_[_loc4_]).split(":")[1]);
               param2.addBadgeRewardClaimed(_loc5_,false);
               _loc4_++;
            }
         }
      }
      
      private function syncStarsRewardsClaimed(param1:String, param2:UserData) : void
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         if(param1 != null && param1 != "")
         {
            _loc3_ = param1.split(",");
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc5_ = String(_loc3_[_loc4_]).split(":")[0];
               param2.addStarsRewardClaimed(_loc5_,false);
               _loc4_++;
            }
         }
      }
      
      private function syncQuestsClaimed(param1:String, param2:UserData) : void
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         if(param1 != null && param1 != "")
         {
            _loc3_ = param1.split(",");
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc5_ = _loc3_[_loc4_];
               if(_loc5_ != "")
               {
                  param2.addQuestClaimed(_loc5_,false);
               }
               _loc4_++;
            }
         }
      }
      
      private function syncQuestsCompleted(param1:String, param2:UserData) : void
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         if(param1 != null && param1 != "")
         {
            _loc3_ = param1.split(",");
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc5_ = _loc3_[_loc4_];
               if(_loc5_ != "" && !param2.isQuestAlreadyClaimed(_loc5_))
               {
                  param2.addQuestCompleted(_loc5_,false);
               }
               _loc4_++;
            }
         }
      }
      
      private function syncQuestsNotifiedAsCompleted(param1:String, param2:UserData) : void
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         if(param1 != null && param1 != "")
         {
            _loc3_ = param1.split(",");
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc5_ = _loc3_[_loc4_];
               if(!param2.isQuestNotifiedAsCompleted(_loc5_))
               {
                  param2.addQuestNotifiedAsCompleted(_loc5_,false);
               }
               _loc4_++;
            }
         }
      }
      
      private function syncQuestsProgress(param1:String, param2:UserData) : void
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         if(param1 != null && param1 != "")
         {
            _loc3_ = param1.split(",");
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc5_ = String(_loc3_[_loc4_]).split(":")[0];
               if(_loc5_ != "")
               {
                  _loc6_ = int(String(_loc3_[_loc4_]).split(":")[1]);
                  param2.setQuestProgress(_loc5_,_loc6_,false);
               }
               _loc4_++;
            }
         }
      }
      
      public function syncComicsRead(param1:UserData) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:MapDef = null;
         var _loc5_:LevelDef = null;
         var _loc6_:int = 0;
         if(param1)
         {
            _loc2_ = param1.getCurrentDifficulty();
            if(_loc2_ != UserDataMng.DIFFICULTY_EASY)
            {
               _loc5_ = LevelDef(InstanceMng.getLevelsDefMng().getDefBySku(param1.getCurrentLevelSkuByDifficulty(UserDataMng.DIFFICULTY_EASY)));
               _loc6_ = param1.getCurrentMapIndex(UserDataMng.DIFFICULTY_EASY);
               _loc3_ = 1;
               while(_loc3_ <= _loc6_)
               {
                  if(_loc3_ <= _loc6_ && (Boolean(_loc5_ && _loc5_.getLevelIndex() != 1) || Boolean(_loc5_ == null)))
                  {
                     _loc4_ = MapDef(InstanceMng.getMapsDefMng().getMapDefByIndex(_loc3_));
                     param1.addComicRead(_loc4_.getSku(),false);
                  }
                  _loc3_++;
               }
            }
         }
      }
      
      private function syncCardCollection(param1:String, param2:String, param3:int, param4:Boolean, param5:Object, param6:UserData) : void
      {
         var _loc7_:Array = null;
         var _loc10_:String = null;
         var _loc11_:Array = null;
         var _loc12_:int = 0;
         var _loc8_:int = InstanceMng.getLevelsDefMng().getLevelIndexByLevelSku(param1);
         param2 = param2 != null ? param2 : "level_01";
         var _loc9_:int = InstanceMng.getLevelsDefMng().getLevelIndexByLevelSku(param2);
         if(_loc8_ > _loc9_ && !param4)
         {
            if(param3 == UserDataMng.DIFFICULTY_EASY)
            {
               _loc7_ = String(param5.collection).split(",");
            }
            _loc10_ = InstanceMng.getLevelsDefMng().getPreviousLevelSku(param1,param3);
            _loc11_ = InstanceMng.getRewardsDefMng().getRewardedCardsForLevelRanks(param2,_loc10_,param3);
            if(_loc11_)
            {
               _loc12_ = 0;
               while(_loc12_ < _loc11_.length)
               {
                  if(_loc7_ == null)
                  {
                     _loc7_ = new Array();
                  }
                  _loc7_.push(_loc11_[_loc12_]);
                  _loc12_++;
               }
            }
         }
         else if(param3 == UserDataMng.DIFFICULTY_EASY)
         {
            _loc7_ = param5.collection ? String(param5.collection).split(",") : new Array();
         }
         param6.setCardCollection(_loc7_);
      }
      
      private function syncGold(param1:Array, param2:Array, param3:Boolean, param4:UserData, param5:Boolean, param6:Number = 0) : void
      {
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:int = 0;
         var _loc7_:int = param6;
         var _loc10_:int = 0;
         if(!param3)
         {
            _loc14_ = 0;
            while(_loc14_ < param1.length)
            {
               _loc12_ = param1.length >= _loc14_ ? param1[_loc14_] : "level_01";
               _loc13_ = param2.length >= _loc14_ ? param2[_loc14_] : "level_01";
               _loc8_ = InstanceMng.getLevelsDefMng().getLevelIndexByLevelSku(_loc12_);
               _loc9_ = InstanceMng.getLevelsDefMng().getLevelIndexByLevelSku(_loc13_);
               if(_loc8_ > _loc9_)
               {
                  _loc11_ = InstanceMng.getLevelsDefMng().getPreviousLevelSku(_loc12_,_loc14_);
                  _loc10_ += InstanceMng.getRewardsDefMng().getRewardedGoldForLevelRanks(_loc13_,_loc11_,_loc14_);
               }
               _loc14_++;
            }
         }
         _loc7_ += _loc10_;
         if(param5)
         {
            Utils.setStat(Constants.STAT_GOLD,_loc7_);
            if(_loc10_ > 0)
            {
               InstanceMng.getServerConnection().addPlayerCurrency(_loc10_,ServerConnection.CURRENCY_GOLD);
            }
         }
         param4.setGold(_loc7_);
      }
      
      private function syncJobsExp(param1:Boolean, param2:Object, param3:UserData) : void
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc4_:Array = new Array();
         var _loc5_:Array = param2.jobsExperience != null && param2.jobsExperience != "" ? String(param2.jobsExperience).split(",") : null;
         var _loc6_:Array = InstanceMng.getJobsDefMng().getAllJobSkus();
         _loc8_ = 0;
         while(_loc8_ < _loc6_.length)
         {
            _loc9_ = Main.smOfflineUserData != null ? Main.smOfflineUserData.getJobExperienceByJobSku(String(_loc6_[_loc8_]).split(":")[0]) : 0;
            _loc10_ = 0;
            if(Boolean(_loc5_) && _loc5_.length > 0)
            {
               _loc7_ = 0;
               while(_loc7_ < _loc5_.length)
               {
                  _loc12_ = String(_loc5_[_loc7_]).split(":")[0];
                  if(_loc12_ == String(_loc6_[_loc8_]).split(":")[0])
                  {
                     _loc10_ = Number(String(_loc5_[_loc7_]).split(":")[1]);
                     break;
                  }
                  _loc7_++;
               }
            }
            _loc11_ = String(_loc6_[_loc8_]).split(":")[0];
            if(_loc9_ >= _loc10_ && !param1)
            {
               _loc4_.push(_loc11_ + ":" + _loc9_.toString());
            }
            else
            {
               _loc4_.push(_loc11_ + ":" + _loc10_.toString());
            }
            _loc8_++;
         }
         param3.setJobsExperience(_loc4_);
      }
      
      private function syncOnlineDecks(param1:Object, param2:UserData) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:int = Config.getConfig().getMaxDecksAmount();
         _loc3_ = 0;
         while(_loc3_ <= _loc6_)
         {
            _loc5_ = "deck_" + Utils.transformValueToString(_loc3_.toString(),2);
            _loc4_ = String(param1[_loc5_]).split(",");
            param2.setDeck(_loc4_,_loc3_);
            _loc3_++;
         }
      }
      
      override public function getUpdatedCurrentLevelSku(param1:int, param2:Object = null) : String
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(Main.smOfflineUserData != null)
         {
            _loc5_ = Main.smOfflineUserData.getCurrentLevelSkuByDifficulty(param1);
            if(Boolean(Main.smOfflineUserData.getCurrentLevelSkuByDifficulty(param1) != null) && Boolean(mOwnerUserData) && mOwnerUserData.getCurrentLevelSkuByDifficulty(param1) != null)
            {
               _loc4_ = int(Main.smOfflineUserData.getCurrentLevelSkuByDifficulty(param1).split("level_")[1]);
               _loc8_ = int(mOwnerUserData.getCurrentLevelSkuByDifficulty(param1).split("level_")[1]);
               if(_loc4_ > _loc8_)
               {
                  _loc5_ = Main.smOfflineUserData.getCurrentLevelSkuByDifficulty(param1);
               }
               else
               {
                  _loc5_ = mOwnerUserData.getCurrentLevelSkuByDifficulty(param1);
               }
            }
            switch(param1)
            {
               case UserDataMng.DIFFICULTY_EASY:
                  _loc6_ = param2 ? param2.currentLevelSku : null;
                  break;
               case UserDataMng.DIFFICULTY_MEDIUM:
                  _loc6_ = param2 ? param2.currentLevelMediumSku : null;
                  break;
               case UserDataMng.DIFFICULTY_HARD:
                  _loc6_ = param2 ? param2.currentLevelHardSku : null;
                  break;
               default:
                  _loc6_ = param2 ? param2.currentLevelSku : null;
            }
            if(_loc6_ == null || _loc6_ == "null")
            {
               return _loc5_ != null && _loc5_ != "null" ? _loc5_ : "level_01";
            }
            _loc7_ = this.isDifferentUser(Main.smOfflineUserData);
            if(_loc7_)
            {
               _loc3_ = _loc6_;
            }
            else
            {
               _loc4_ = int(String(_loc5_).split("_")[1]);
               _loc9_ = int(String(_loc6_).split("_")[1]);
               _loc3_ = Config.smOfflineLevelRules || _loc4_ > _loc9_ ? _loc5_ : _loc6_;
            }
         }
         else if(InstanceMng.getUserDataMng() == null || FSFacebookPlugin.smJustLoggedOutFromFB)
         {
            switch(param1)
            {
               case UserDataMng.DIFFICULTY_EASY:
                  _loc3_ = Boolean(param2) && Boolean(param2.currentLevelSku != "") && param2.currentLevelSku != null ? param2.currentLevelSku : "level_01";
                  break;
               case UserDataMng.DIFFICULTY_MEDIUM:
                  _loc3_ = Boolean(param2) && Boolean(param2.currentLevelMediumSku != "") && param2.currentLevelMediumSku != null ? param2.currentLevelMediumSku : "level_01";
                  break;
               case UserDataMng.DIFFICULTY_HARD:
                  _loc3_ = Boolean(param2) && Boolean(param2.currentLevelHardSku != "") && param2.currentLevelHardSku != null ? param2.currentLevelHardSku : "level_01";
                  break;
               default:
                  _loc3_ = Boolean(param2) && Boolean(param2.currentLevelSku != "") && param2.currentLevelSku != null ? param2.currentLevelSku : "level_01";
            }
         }
         else
         {
            _loc3_ = mOwnerUserData ? mOwnerUserData.getCurrentLevelSkuByDifficulty(param1) : "level_01";
         }
         return _loc3_;
      }
      
      override public function persistenceSaveData(param1:Boolean = false, param2:Function = null) : void
      {
         FSDebug.debugTrace("Saving PERSISTENCE");
         super.persistenceSaveData(param1);
         this.updateUserInfoOnServer(param2);
      }
      
      private function updateUserInfoOnServer(param1:Function = null) : void
      {
         var _loc2_:Object = mOwnerUserData ? mOwnerUserData.persistenceBuildData() : null;
         if(_loc2_)
         {
            if(_loc2_.hasOwnProperty("gold"))
            {
               delete _loc2_.gold;
            }
            if(_loc2_.hasOwnProperty("raidCoins"))
            {
               delete _loc2_.raidCoins;
            }
            if(_loc2_.hasOwnProperty("questsCoins"))
            {
               delete _loc2_.questsCoins;
            }
            if(_loc2_.hasOwnProperty("auctionTickets"))
            {
               delete _loc2_.auctionTickets;
            }
            if(_loc2_.hasOwnProperty("raidTicketsSinglePlayer"))
            {
               delete _loc2_.raidTicketsSinglePlayer;
            }
            if(_loc2_.hasOwnProperty("raidTicketsMultiPlayer"))
            {
               delete _loc2_.raidTicketsMultiPlayer;
            }
            this.mPersistenceSaved = false;
            this.onUserInfoReadyUpdateToServer(_loc2_,param1);
         }
         else
         {
            TweenMax.delayedCall(5,this.updateUserInfoOnServer,[param1]);
         }
      }
      
      private function onUserInfoReadyUpdateToServer(param1:Object, param2:Function = null) : void
      {
         var _loc3_:String = "";
         var _loc4_:int = -1;
         var _loc5_:String = "";
         if(InstanceMng.getApplication().isKongregateVersion())
         {
            _loc3_ = InstanceMng.getApplication().kongGetUserId();
            _loc4_ = UserDataMng.EXT_PLATFORM_KONGREGATE;
            _loc5_ = InstanceMng.getApplication().getKongName();
            InstanceMng.getServerConnection().getBackendUserProfile().profile.kongUsername = _loc5_;
         }
         else if(Utils.isIOS() && (InstanceMng.getApplication().appleGetUserId() != "" && InstanceMng.getApplication().appleGetUserId() != null))
         {
            _loc3_ = InstanceMng.getApplication().appleGetUserId();
            _loc4_ = UserDataMng.EXT_PLATFORM_APPLE_SIGN_IN;
         }
         else if(InstanceMng.getFacebookPlugin() != null)
         {
            _loc3_ = InstanceMng.getFacebookPlugin().getFBId();
            _loc4_ = UserDataMng.EXT_PLATFORM_FB;
         }
         else if(Utils.isDesktop())
         {
            _loc3_ = InstanceMng.getApplication().steamGetSteamId();
            _loc4_ = UserDataMng.EXT_PLATFORM_STEAM;
         }
         if(Boolean(InstanceMng.getServerConnection().getBackendUserProfile()) && Boolean(InstanceMng.getServerConnection().getBackendUserProfile().profile) && Boolean(param1))
         {
            if(param1.hasOwnProperty("accountId") && param1.accountId != null && param1.accountId != "" && InstanceMng.getServerConnection().getUserId() != null && InstanceMng.getServerConnection().getUserId() != "")
            {
               if(InstanceMng.getServerConnection().getUserId() != param1.accountId)
               {
                  return;
               }
            }
            InstanceMng.getServerConnection().fullyUpdateUserProfile(_loc3_,_loc4_,param1,this.onUserProfileFullyUpdatedSuccess,[param2]);
         }
      }
      
      private function onUserProfileFullyUpdatedSuccess(param1:Function = null) : void
      {
         FSDebug.debugTrace("Ok - User Updated");
         this.mPersistenceSaved = true;
         if(param1 != null)
         {
            FSDebug.debugTrace("OnCompleteFunction != null");
            param1();
         }
      }
      
      override public function updatePlayerExtId(param1:Object = null) : void
      {
         super.updatePlayerExtId(param1);
         this.updateProfileField("extId",mOwnerUserData.getExtId());
      }
      
      override public function updatePlayerName(param1:Object = null) : void
      {
         super.updatePlayerName(param1);
         this.updateProfileField("playerName",mOwnerUserData.getName());
      }
      
      override public function updateCityName(param1:Object = null) : void
      {
         super.updateCityName(param1);
         this.updateProfileField("cityName",mOwnerUserData.getCityName());
      }
      
      override public function updateDate() : void
      {
         var _loc2_:Number = NaN;
         super.updateDate();
         var _loc1_:Boolean = !isNaN(ServerConnection.smServerTimeMS) && ServerConnection.smServerTimeMS != -1 && ServerConnection.smServerTimeMS != 0;
         if(_loc1_)
         {
            _loc2_ = ServerConnection.smServerTimeMS;
            this.updateProfileField("currentDateMS",_loc2_.toString());
         }
         else if(InstanceMng.getServerConnection())
         {
            InstanceMng.getServerConnection().refreshServerTime();
         }
      }
      
      override public function updateCurrentDifficulty(param1:Object = null) : void
      {
         super.updateCurrentDifficulty(param1);
         this.updateProfileField("currentDifficulty",mOwnerUserData.getCurrentDifficulty().toString());
      }
      
      override public function updateMapWorldChoices(param1:Object = null) : void
      {
         super.updateMapWorldChoices(param1);
         this.updateProfileField("mapWorldChoices",mOwnerUserData.getMapWorldChoiceToString());
      }
      
      override public function updateCurrentLevelSku(param1:Object = null) : void
      {
         super.updateCurrentLevelSku(param1);
         this.updateProfileField("currentLevelSku",mOwnerUserData.getCurrentLevelSku());
      }
      
      override public function updateCurrentLevelMediumSku(param1:Object = null) : void
      {
         super.updateCurrentLevelMediumSku(param1);
         this.updateProfileField("currentLevelMediumSku",mOwnerUserData.getCurrentLevelMediumSku());
      }
      
      override public function updateCurrentLevelHardSku(param1:Object = null) : void
      {
         super.updateCurrentLevelHardSku(param1);
         this.updateProfileField("currentLevelHardSku",mOwnerUserData.getCurrentLevelHardSku());
      }
      
      override public function updateGold(param1:Object = null) : void
      {
         super.updateGold(param1);
         this.updateProfileField("gold",mOwnerUserData.getGold().toString());
      }
      
      override public function updateQuestsCoins(param1:Object = null) : void
      {
         super.updateQuestsCoins(param1);
         this.updateProfileField("questsCoins",mOwnerUserData.getQuestsCoins().toString());
      }
      
      override public function updateRaidCoins(param1:Object = null) : void
      {
         super.updateRaidCoins(param1);
         this.updateProfileField("raidCoins",mOwnerUserData.getRaidCoins().toString());
      }
      
      override public function updateExp(param1:Object = null) : void
      {
         super.updateExp(param1);
         this.updateProfileField("exp",mOwnerUserData.getExp().toString());
      }
      
      override public function updateBattlePass(param1:Object = null) : void
      {
         super.updateBattlePass(param1);
         this.updateProfileField("battlePass",mOwnerUserData.getBattlePass());
      }
      
      override public function updateCollection(param1:Object = null) : void
      {
         super.updateCollection(param1);
         this.updateProfileField("collection",mOwnerUserData.getOwnerCollectionToString());
      }
      
      override public function updateNewCardsCollection(param1:Object = null) : void
      {
         this.updateProfileField("newCardsCollection",mOwnerUserData.getOwnerNewCardsCollectionToString());
      }
      
      override public function updateFavouriteCardsCollection(param1:Object = null) : void
      {
         this.updateProfileField("favouriteCardsCollection",mOwnerUserData.getOwnerFavouriteCardsCollectionToString());
      }
      
      override public function updateAuctionIdCreatedArr(param1:Object = null) : void
      {
         this.updateProfileField("auctionIdCreatedArr",mOwnerUserData.getOwnerAuctionIdCreatedArrToString());
      }
      
      override public function updateAuctionIdBiddedArr(param1:Object = null) : void
      {
         this.updateProfileField("auctionIdBiddedArr",mOwnerUserData.getOwnerAuctionIdBiddedArrToString());
      }
      
      override public function updateUniquePacksArr(param1:Object = null) : void
      {
         this.updateProfileField("uniquePacksArr",mOwnerUserData.getOwnerUniquePacksArrToString());
      }
      
      override public function updateDeckConfigs(param1:Object = null) : void
      {
         super.updateDeckConfigs(param1);
         var _loc2_:String = mOwnerUserData.getOwnerDeckToString(0);
         var _loc3_:String = mOwnerUserData.getOwnerDeckToString(1);
         var _loc4_:String = mOwnerUserData.getOwnerDeckToString(2);
         var _loc5_:String = mOwnerUserData.getOwnerDeckToString(3);
         var _loc6_:String = mOwnerUserData.getOwnerDeckToString(4);
         var _loc7_:String = mOwnerUserData.getOwnerDeckToString(5);
         var _loc8_:String = mOwnerUserData.getOwnerDeckToString(6);
         var _loc9_:String = mOwnerUserData.getOwnerDeckToString(7);
         var _loc10_:String = mOwnerUserData.getOwnerDeckToString(8);
         var _loc11_:String = mOwnerUserData.getOwnerDeckToString(9);
         this.updateProfileField("deck_00",_loc2_);
         this.updateProfileField("deck_01",_loc3_);
         this.updateProfileField("deck_02",_loc4_);
         this.updateProfileField("deck_03",_loc5_);
         this.updateProfileField("deck_04",_loc6_);
         this.updateProfileField("deck_05",_loc7_);
         this.updateProfileField("deck_06",_loc8_);
         this.updateProfileField("deck_07",_loc9_);
         this.updateProfileField("deck_08",_loc10_);
         this.updateProfileField("deck_09",_loc11_);
      }
      
      override public function updateSelectedDeckIndex(param1:Object = null) : void
      {
         super.updateSelectedDeckIndex(param1);
         this.updateProfileField("selectedDeckIndex",mOwnerUserData.getSelectedDeckIndex().toString());
      }
      
      override public function updateSelectedDeckIndexPvP(param1:Object = null) : void
      {
         super.updateSelectedDeckIndexPvP(param1);
         this.updateProfileField("selectedDeckIndexPvP",mOwnerUserData.getSelectedDeckIndexPvP().toString());
      }
      
      override public function updateDeckNames(param1:Object = null) : void
      {
         super.updateDeckNames(param1);
         this.updateProfileField("deckNames",mOwnerUserData.getDeckNamesToString());
      }
      
      override public function updateBoosts(param1:Object = null) : void
      {
         super.updateBoosts(param1);
         this.updateProfileField("boosts",mOwnerUserData.getBoostsToString());
      }
      
      override public function updateFlags(param1:Object = null) : void
      {
         super.updateFlags();
         this.updateProfileField("flags",mOwnerUserData.flagsToString());
      }
      
      override public function updateTutorialsSeen(param1:Object = null) : void
      {
         super.updateTutorialsSeen();
         this.updateProfileField("tutorialsSeen",mOwnerUserData.tutorialsSeenToString());
      }
      
      override public function updateLevelsFailedInfo(param1:Object = null) : void
      {
         super.updateLevelsFailedInfo();
         this.updateProfileField("levelsFailedInfo",mOwnerUserData.levelsFailedInfoToString());
      }
      
      override public function updateLevelsFailedFirebase(param1:Object = null) : void
      {
         super.updateLevelsFailedFirebase();
         this.updateProfileField("levelsFailedFirebase",mOwnerUserData.levelsFailedFirebaseToString());
      }
      
      override public function updateLives(param1:Object = null) : void
      {
         super.updateLives(param1);
         this.updateProfileField("lives",mOwnerUserData.getLives().toString());
      }
      
      override public function updateLostLiveTimeMS(param1:Object = null) : void
      {
         super.updateLostLiveTimeMS(param1);
         this.updateProfileField("lostLiveTimeMS",mOwnerUserData.getLostLifeTimeMS().toString());
      }
      
      override public function updateDecksPurchasedAmount(param1:Object = null) : void
      {
         super.updateDecksPurchasedAmount(param1);
         this.updateProfileField("decksPurchasedAmount",mOwnerUserData.getDecksPurchasedAmount().toString());
      }
      
      override public function updateElo(param1:Object = null) : void
      {
         super.updateElo(param1);
         this.updateProfileField("elo",mOwnerUserData.getElo().toString());
      }
      
      override public function updatePvPCurrentLeague(param1:Object = null) : void
      {
         super.updatePvPCurrentLeague(param1);
         this.updateProfileField("pvpCurrentLeague",mOwnerUserData.getPvPCurrentLeague().toString());
      }
      
      override public function updatePvPBestLeague(param1:Object = null) : void
      {
         super.updatePvPBestLeague(param1);
         this.updateProfileField("pvpBestLeague",mOwnerUserData.getPvPBestLeague().toString());
      }
      
      override public function updateMatchesLost(param1:Object = null) : void
      {
         super.updateMatchesLost(param1);
         this.updateProfileField("matchesLost",mOwnerUserData.getMatchesLost().toString());
      }
      
      override public function updatePvPSeason(param1:Object = null) : void
      {
         super.updatePvPSeason(param1);
         this.updateProfileField("pvpSeason",mOwnerUserData.getPvPSeason().toString());
      }
      
      override public function updateMatchesWon(param1:Object = null) : void
      {
         super.updateMatchesWon(param1);
         this.updateProfileField("matchesWon",mOwnerUserData.getMatchesWon().toString());
      }
      
      override public function updateMatchesPlayed(param1:Object = null) : void
      {
         super.updateMatchesPlayed(param1);
         this.updateProfileField("matchesPlayed",mOwnerUserData.getMatchesPlayed().toString());
      }
      
      override public function updateDungeonsSeason(param1:Object = null) : void
      {
         super.updateDungeonsSeason(param1);
         this.updateProfileField("dungeonsSeason",mOwnerUserData.getDungeonsSeason().toString());
      }
      
      override public function updateDungeonsLost(param1:Object = null) : void
      {
         super.updateDungeonsLost(param1);
         this.updateProfileField("dungeonsLost",mOwnerUserData.getDungeonsLost().toString());
      }
      
      override public function updateDungeonsWon(param1:Object = null) : void
      {
         super.updateDungeonsWon(param1);
         this.updateProfileField("dungeonsWon",mOwnerUserData.getDungeonsWon().toString());
      }
      
      override public function updateDungeonsPlayed(param1:Object = null) : void
      {
         super.updateDungeonsPlayed(param1);
         this.updateProfileField("dungeonsPlayed",mOwnerUserData.getDungeonsPlayed().toString());
      }
      
      override public function updateComicsRead(param1:Object = null) : void
      {
         super.updateComicsRead(param1);
         this.updateProfileField("comicsRead",mOwnerUserData.getComicsReadToString());
      }
      
      override public function updateIsBlacklisted(param1:Object = null) : void
      {
         super.updateIsBlacklisted(param1);
         this.updateProfileField("isBlackListed",mOwnerUserData.isInBlackList().toString());
      }
      
      override public function updateIsDuplicated(param1:Object = null) : void
      {
         super.updateIsDuplicated(param1);
         this.updateProfileField("isDuplicated",mOwnerUserData.isInDuplicatedList().toString());
      }
      
      override public function updateHighestMapUnlockedIndex(param1:Object = null) : void
      {
         super.updateHighestMapUnlockedIndex(param1);
         this.updateProfileField("highestMapUnlockedIndex",mOwnerUserData.getHighestMapUnlockedIndex().toString());
      }
      
      override public function updateLevelCompleted(param1:String, param2:int, param3:String, param4:Number = -1, param5:int = 0) : void
      {
         super.updateLevelCompleted(param1,param2,param3,param4,param5);
         InstanceMng.getServerConnection().addLevelScore(param1,param2,param3,-1,false,param5);
      }
      
      override public function updateAvailableJobs(param1:Object = null) : void
      {
         super.updateAvailableJobs(param1);
         this.updateProfileField("availableJobs",mOwnerUserData.getAvailableJobsToString());
      }
      
      override public function updateAvailableSkins(param1:Object = null) : void
      {
         super.updateAvailableSkins(param1);
         this.updateProfileField("availableSkins",mOwnerUserData.getAvailableSkinsToString());
      }
      
      override public function updateCurrentSkinSku(param1:Object = null) : void
      {
         super.updateCurrentSkinSku(param1);
         this.updateProfileField("currentSkinSku",mOwnerUserData.getCurrentSkinSku());
      }
      
      override public function updateAvailablePortraits(param1:Object = null) : void
      {
         super.updateAvailablePortraits(param1);
         this.updateProfileField("availablePortraits",mOwnerUserData.getAvailablePortraitsToString());
      }
      
      override public function updateCurrentPortraitSku(param1:Object = null) : void
      {
         super.updateCurrentPortraitSku(param1);
         this.updateProfileField("currentPortraitSku",mOwnerUserData.getCurrentPortraitSku());
      }
      
      override public function updateFinishedLastCampaignTimestamp(param1:Object = null) : void
      {
         this.updateProfileField("finishedLastCampaignTimeMs",mOwnerUserData.getFinishedLastCampaignTimestamp().toString());
      }
      
      override public function updateDailyRewardTimeMS() : void
      {
         this.updateProfileField("dailyRewardTimeMS",mOwnerUserData.getDailyRewardTimeMS().toString());
      }
      
      override public function updateLastDailyRewardClaimedIndex() : void
      {
         this.updateProfileField("lastDailyRewardClaimedIndex",mOwnerUserData.getLastDailyRewardClaimedIndex().toString());
      }
      
      override public function updateOldPlayerComingBackDailyRewardTimeMS() : void
      {
         this.updateProfileField("oldPlayerComingBackDailyRewardTimeMS",mOwnerUserData.getOldPlayerComingBackDailyRewardTimeMS().toString());
      }
      
      override public function updateOldPlayerComingBackLastDailyRewardClaimedIndex() : void
      {
         this.updateProfileField("oldPlayerComingBackLastDailyRewardClaimedIndex",mOwnerUserData.getOldPlayerComingBackLastDailyRewardClaimedIndex().toString());
      }
      
      override public function updateLevelAttempts(param1:Object = null) : void
      {
         super.updateLevelAttempts(param1);
         this.updateProfileField("levelAttempts",mOwnerUserData.getLevelAttempts().toString());
      }
      
      override public function updateFirstFirebaseDBTrack(param1:Object = null) : void
      {
         super.updateFirstFirebaseDBTrack(param1);
         this.updateProfileField("firstFirebaseDBTrack",mOwnerUserData.getFirstFirebaseDBTrack().toString());
      }
      
      override public function updateLanguageLocale(param1:Object = null) : void
      {
         super.updateLanguageLocale(param1);
         this.updateProfileField("languageLocale",mOwnerUserData.getLanguageLocale());
      }
      
      override public function updateQuestsClaimed(param1:Object = null) : void
      {
         super.updateQuestsClaimed(param1);
         this.updateProfileField("questsClaimed",mOwnerUserData.getQuestsClaimedToString());
      }
      
      override public function updateQuestsCompleted(param1:Object = null) : void
      {
         super.updateQuestsCompleted(param1);
         this.updateProfileField("questsCompleted",mOwnerUserData.getQuestsCompletedToString());
      }
      
      override public function updateQuestsNotifiedAsCompleted(param1:Object = null) : void
      {
         super.updateQuestsNotifiedAsCompleted(param1);
         this.updateProfileField("questsNotifiedAsCompleted",mOwnerUserData.getQuestsNotifiedAsCompletedToString());
      }
      
      override public function updateQuestsProgress(param1:Object = null) : void
      {
         super.updateQuestsProgress(param1);
         this.updateProfileField("questsProgress",mOwnerUserData.getQuestsProgressToString());
      }
      
      override public function updateDailyKeyTime(param1:Object = null) : void
      {
         super.updateDailyKeyTime(param1);
         this.updateProfileField("dailyKeyTime",mOwnerUserData.getDailyKeyTime().toString());
      }
      
      override public function updateWeekNumber(param1:Object = null) : void
      {
         super.updateWeekNumber(param1);
         this.updateProfileField("weekNumber",mOwnerUserData.getWeekNumber().toString());
      }
      
      override public function updateMonthNumber(param1:Object = null) : void
      {
         super.updateMonthNumber(param1);
         this.updateProfileField("monthNumber",mOwnerUserData.getMonthNumber().toString());
      }
      
      override public function updateCustomOfferShown(param1:Object = null) : void
      {
         super.updateCustomOfferShown(param1);
         this.updateProfileField("customOfferShown",mOwnerUserData.getCustomOfferShown());
      }
      
      override public function updateCustomOfferNextVisibleDateMS(param1:Object = null) : void
      {
         super.updateCustomOfferNextVisibleDateMS(param1);
         this.updateProfileField("customOfferNextVisibleDateMS",mOwnerUserData.getCustomOfferNextVisibleDateMS().toString());
      }
      
      override public function updateCustomOfferNewBannerShown(param1:Object = null) : void
      {
         super.updateCustomOfferNewBannerShown(param1);
         this.updateProfileField("customOfferNewBannerShown",mOwnerUserData.getCustomOfferNewBannerShown().toString());
      }
      
      override public function updateCustomOfferViewsCount(param1:Object = null) : void
      {
         super.updateCustomOfferViewsCount(param1);
         this.updateProfileField("customOffersViewsCount",mOwnerUserData.getCustomOffersViewsCountToString());
      }
      
      override public function updateCustomOffersPurchased(param1:Object = null) : void
      {
         super.updateCustomOffersPurchased(param1);
         this.updateProfileField("customOffersPurchased",mOwnerUserData.getCustomOffersPurchasedToString());
      }
      
      override public function updateRaidTicketsMultiPlayer(param1:Object = null) : void
      {
         super.updateRaidTicketsMultiPlayer(param1);
         this.updateProfileField("raidTicketsMultiPlayer",mOwnerUserData.getRaidTicketsMultiPlayer().toString());
      }
      
      override public function updateRaidTicketsSinglePlayer(param1:Object = null) : void
      {
         super.updateRaidTicketsSinglePlayer(param1);
         this.updateProfileField("raidTicketsSinglePlayer",mOwnerUserData.getRaidTicketsSinglePlayer().toString());
      }
      
      override public function updateRaidsUnlocked(param1:Object = null) : void
      {
         super.updateRaidsUnlocked(param1);
         this.updateProfileField("raidsUnlocked",mOwnerUserData.getRaidsUnlocked().toString());
      }
      
      override public function updateAuctionTickets(param1:Object = null) : void
      {
         super.updateAuctionTickets(param1);
         this.updateProfileField("auctionTickets",mOwnerUserData.getAuctionTickets().toString());
      }
      
      override public function getTopScoreByLevelSku(param1:String, param2:Function, param3:int = 0) : int
      {
         var _loc4_:int = getTopScoreByLevelSkuFromOfflineDB(param1,param2,param3);
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            InstanceMng.getServerConnection().getOwnerScoreByLevelSku(param1,_loc4_,param2,true,param3);
         }
         else
         {
            param2(_loc4_);
         }
         return _loc4_;
      }
      
      override public function getFriendsTopScoreByLevelSku(param1:String, param2:Function, param3:Array, param4:Boolean = false) : void
      {
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            InstanceMng.getServerConnection().getFriendsScoreByLevelSku(param1,param2,param3,param4);
         }
      }
      
      override public function getFriendsLastLevelCompletedTimestamp(param1:Function, param2:Array) : void
      {
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            InstanceMng.getServerConnection().getFriendsLastLevelCompletedTimestamp(param1,param2);
         }
      }
      
      override public function getFriendsELOCatalog() : Dictionary
      {
         var _loc3_:UserData = null;
         var _loc4_:int = 0;
         var _loc1_:Dictionary = null;
         var _loc2_:Vector.<UserData> = InstanceMng.getApplication().isKongregateVersion() ? InstanceMng.getUserDataMng().getAllFriendsUserDataOnAnyLevel() : InstanceMng.getUserDataMng().getFriends();
         if(_loc2_ != null)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc3_ = _loc2_[_loc4_];
               if(_loc1_ == null)
               {
                  _loc1_ = new Dictionary(true);
               }
               _loc1_[_loc3_.getExtId()] = _loc3_.getElo();
               _loc4_++;
            }
         }
         return _loc1_;
      }
      
      private function updateProfileField(param1:String, param2:String) : void
      {
         InstanceMng.getServerConnection().updateProfileField(param1,param2);
      }
      
      override public function updateBotsPlayedSession(param1:Object = null) : void
      {
         super.updateBotsPlayedSession(param1);
         this.updateProfileField("botsPlayedSession",mOwnerUserData.getBotsPlayedSession().toString());
      }
      
      override public function updateJobsExperience(param1:Object = null) : void
      {
         this.updateProfileField("jobsExperience",mOwnerUserData.getJobsExperienceToString());
      }
      
      override public function updateDeckJobConfigurator(param1:Object = null) : void
      {
         this.updateProfileField("deckJobConfigurator",mOwnerUserData.getDeckJobConfiguratorToString());
      }
      
      override public function updatePlatformVersions(param1:Object = null) : void
      {
         this.updateProfileField("platformVersions",mOwnerUserData.getPlatformVersionsToString());
      }
      
      private function isDifferentUser(param1:Object) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:String = "";
         var _loc4_:int = -1;
         var _loc5_:Boolean = false;
         if(InstanceMng.getApplication().isKongregateVersion())
         {
            _loc3_ = InstanceMng.getApplication().kongGetUserId();
         }
         else if(Utils.isDesktop())
         {
            _loc3_ = InstanceMng.getApplication().steamGetSteamId();
         }
         else if(Utils.isIOS())
         {
            _loc3_ = InstanceMng.getApplication().appleGetUserId();
            _loc4_ = UserDataMng.EXT_PLATFORM_APPLE_SIGN_IN;
            _loc5_ = _loc3_ != "" && _loc3_ != null;
            if(!_loc5_)
            {
               _loc4_ = -1;
               if(InstanceMng.getFacebookPlugin() != null)
               {
                  _loc3_ = InstanceMng.getFacebookPlugin().getFBId();
                  _loc4_ = UserDataMng.EXT_PLATFORM_FB;
               }
            }
         }
         else if(InstanceMng.getFacebookPlugin() != null)
         {
            _loc3_ = InstanceMng.getFacebookPlugin().getFBId();
         }
         _loc3_ = _loc3_ == null ? "" : _loc3_;
         var _loc6_:String = param1 != null ? param1.getExtId() : "";
         var _loc7_:int = param1 != null ? int(param1.getExtPlatformId()) : -1;
         _loc6_ = _loc6_ == null ? "" : _loc6_;
         _loc2_ = param1 == null || _loc3_ != _loc6_ && (_loc6_ != "" && _loc6_ != "sample");
         _loc2_ = _loc2_ && Utils.isDesktop() ? false : _loc2_;
         if(Utils.isIOS())
         {
            if(!_loc5_ || _loc7_ == _loc4_)
            {
               return _loc2_;
            }
            return true;
         }
         return _loc2_;
      }
      
      override public function buildUserDataFromProfile(param1:Object, param2:Boolean, param3:Object = null) : UserData
      {
         var _loc4_:String = null;
         var _loc14_:String = null;
         var _loc15_:int = 0;
         var _loc16_:Boolean = false;
         var _loc17_:Boolean = false;
         var _loc18_:Boolean = false;
         var _loc19_:Boolean = false;
         var _loc20_:Boolean = false;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         var _loc23_:String = null;
         var _loc24_:String = null;
         var _loc25_:String = null;
         var _loc26_:String = null;
         var _loc27_:String = null;
         var _loc28_:String = null;
         var _loc29_:String = null;
         var _loc30_:String = null;
         var _loc31_:String = null;
         var _loc32_:String = null;
         var _loc33_:int = 0;
         var _loc34_:Number = NaN;
         var _loc35_:Number = NaN;
         var _loc36_:Number = NaN;
         var _loc37_:int = 0;
         var _loc38_:int = 0;
         var _loc39_:int = 0;
         var _loc40_:int = 0;
         var _loc41_:int = 0;
         var _loc42_:Array = null;
         var _loc43_:Array = null;
         var _loc44_:Array = null;
         var _loc45_:Array = null;
         var _loc46_:Array = null;
         var _loc47_:Number = NaN;
         var _loc48_:Number = NaN;
         var _loc49_:Number = NaN;
         var _loc50_:Number = NaN;
         var _loc51_:Number = NaN;
         var _loc52_:Number = NaN;
         var _loc53_:Number = NaN;
         var _loc54_:Number = NaN;
         var _loc55_:Number = NaN;
         var _loc56_:String = null;
         var _loc57_:String = null;
         var _loc58_:int = 0;
         var _loc59_:int = 0;
         var _loc60_:int = 0;
         var _loc61_:String = null;
         var _loc62_:String = null;
         var _loc63_:int = 0;
         var _loc64_:Boolean = false;
         var _loc65_:Boolean = false;
         var _loc66_:Boolean = false;
         var _loc67_:Boolean = false;
         var _loc68_:Number = NaN;
         var _loc69_:int = 0;
         var _loc70_:int = 0;
         var _loc71_:String = null;
         var _loc72_:Array = null;
         if(param1 == null)
         {
            FSDebug.debugTrace("== ATTENTION -> Server profile null.. ==");
            return null;
         }
         if(param2)
         {
            _loc4_ = InstanceMng.getServerConnection().isUserLoggedIn() ? InstanceMng.getServerConnection().getUserId() : "";
         }
         else
         {
            _loc4_ = param1._id ? String(param1._id.$oid) : param1.accountId;
         }
         var _loc5_:Boolean = this.isDifferentUser(Main.smOfflineUserData) || !param2;
         var _loc6_:int = int(param1.currentDifficulty);
         var _loc7_:String = param3 != null ? param3.getCurrentLevelSkuByDifficulty(UserDataMng.DIFFICULTY_EASY) : "";
         var _loc8_:String = param3 != null ? param3.getCurrentLevelSkuByDifficulty(UserDataMng.DIFFICULTY_MEDIUM) : "";
         var _loc9_:String = param3 != null ? param3.getCurrentLevelSkuByDifficulty(UserDataMng.DIFFICULTY_HARD) : "";
         var _loc10_:String = param2 ? this.getUpdatedCurrentLevelSku(UserDataMng.DIFFICULTY_EASY,param1) : param1.currentLevelSku;
         var _loc11_:String = param2 ? this.getUpdatedCurrentLevelSku(UserDataMng.DIFFICULTY_MEDIUM,param1) : param1.currentLevelMediumSku;
         var _loc12_:String = param2 ? this.getUpdatedCurrentLevelSku(UserDataMng.DIFFICULTY_HARD,param1) : param1.currentLevelHardSku;
         FSFacebookPlugin.smJustLoggedOutFromFB = false;
         var _loc13_:UserData = new UserData();
         if(param2)
         {
            mOwnerUserData = _loc13_;
         }
         if(param1 != null)
         {
            _loc14_ = "";
            _loc15_ = -1;
            if(param2)
            {
               if(InstanceMng.getApplication().isKongregateVersion())
               {
                  _loc14_ = InstanceMng.getApplication().kongGetUserId();
                  _loc15_ = UserDataMng.EXT_PLATFORM_KONGREGATE;
               }
               else if(Utils.isIOS())
               {
                  _loc61_ = InstanceMng.getApplication().appleGetUserId();
                  if(_loc61_ != null && _loc61_ != "")
                  {
                     _loc14_ = _loc61_;
                     _loc15_ = UserDataMng.EXT_PLATFORM_APPLE_SIGN_IN;
                  }
                  else if(InstanceMng.getFacebookPlugin() != null)
                  {
                     _loc14_ = InstanceMng.getFacebookPlugin().getFBId();
                     _loc15_ = UserDataMng.EXT_PLATFORM_FB;
                  }
               }
               else if(InstanceMng.getFacebookPlugin() != null)
               {
                  _loc14_ = InstanceMng.getFacebookPlugin().getFBId();
                  _loc15_ = UserDataMng.EXT_PLATFORM_FB;
               }
               else if(Utils.isDesktop())
               {
                  _loc14_ = InstanceMng.getApplication().steamGetSteamId();
                  _loc15_ = UserDataMng.EXT_PLATFORM_STEAM;
               }
            }
            else
            {
               _loc14_ = param1.extId;
               _loc15_ = int(param1.extPlatform);
            }
            if(!_loc5_ || !param2)
            {
               if(_loc14_ != null && _loc14_ != "")
               {
                  _loc13_.setExtId(_loc14_);
                  _loc13_.setExtPlatform(_loc15_);
               }
               else
               {
                  _loc62_ = param3 != null ? param3.getExtId() : "";
                  _loc63_ = param3 != null ? int(param3.getExtPlatformId()) : -1;
                  if(_loc62_ != null && _loc62_ != "")
                  {
                     _loc13_.setExtId(_loc62_);
                     _loc13_.setExtPlatform(_loc63_);
                  }
               }
            }
            else if(param2 && Config.USE_OFFLINE_DB)
            {
               if(!Utils.isBrowser() && !Utils.isDesktop())
               {
                  Utils.setLogText(TextManager.getText("TID_GEN_DATA_RESET"),true);
               }
            }
            _loc13_.setAccountId(_loc4_);
            _loc13_.setCurrentDifficulty(_loc6_);
            _loc10_ = _loc5_ ? param1.currentLevelSku : _loc10_;
            _loc11_ = _loc5_ ? param1.currentLevelMediumSku : _loc11_;
            _loc12_ = _loc5_ ? param1.currentLevelHardSku : _loc12_;
            _loc13_.setCurrentLevelSku(_loc10_);
            _loc13_.setCurrentLevelMediumSku(_loc11_);
            _loc13_.setCurrentLevelHardSku(_loc12_);
            _loc13_.setHighestMapUnlockedIndex(int(param1.highestMapUnlockedIndex),false);
            this.syncCardCollection(_loc7_,param1.currentLevelSku,UserDataMng.DIFFICULTY_EASY,_loc5_,param1,_loc13_);
            this.syncCardCollection(_loc8_,param1.currentLevelMediumSku,UserDataMng.DIFFICULTY_MEDIUM,_loc5_,param1,_loc13_);
            this.syncCardCollection(_loc9_,param1.currentLevelHardSku,UserDataMng.DIFFICULTY_HARD,_loc5_,param1,_loc13_);
            this.syncOnlineDecks(param1,_loc13_);
            _loc13_.flagsRead(param1.flags);
            _loc13_.tutorialsSeenRead(param1.tutorialsSeen);
            _loc13_.levelsFailedInfoRead(param1.levelsFailedInfo,param1.levelsFailedFirebase,param3);
            _loc16_ = _loc13_.flagsIsFBPostingOn();
            _loc17_ = _loc13_.flagsIsFirstChangeName();
            if(!_loc17_)
            {
               _loc13_.setFirstChangeName(_loc17_);
            }
            _loc18_ = _loc13_.flagsIsAuctionHouseFirstTimeVisited();
            if(!_loc18_)
            {
               _loc13_.setAuctionHouseFirstTime(_loc18_);
            }
            if(_loc5_)
            {
               _loc19_ = _loc13_.flagsIsTutorialReward1Claimed();
               _loc20_ = _loc13_.flagsIsTutorialReward2Claimed();
            }
            else
            {
               _loc64_ = _loc13_.flagsIsTutorialReward1Claimed();
               _loc65_ = _loc13_.flagsIsTutorialReward2Claimed();
               _loc66_ = param3 ? Boolean(param3.flagsIsTutorialReward1Claimed()) : false;
               _loc67_ = param3 ? Boolean(param3.flagsIsTutorialReward2Claimed()) : false;
               _loc19_ = _loc66_ || _loc64_;
               _loc20_ = _loc67_ || _loc65_;
            }
            if(param2)
            {
               this.checkTutorialRewards(_loc19_,_loc20_,_loc13_);
            }
            if(!_loc16_)
            {
               _loc13_.setFBPostingOn(_loc16_);
            }
            _loc21_ = param1.selectedDeckIndex != -1 ? int(param1.selectedDeckIndex) : int(param3.getSelectedDeckIndex());
            if(_loc21_ != -1)
            {
               _loc13_.setSelectedDeckIndex(_loc21_);
            }
            _loc22_ = param1.selectedDeckIndexPvP != -1 ? int(param1.selectedDeckIndexPvP) : int(param3.getSelectedDeckIndexPvP());
            if(_loc22_ != -1)
            {
               _loc13_.setSelectedDeckIndexPvP(_loc22_);
            }
            _loc23_ = param1.boosts;
            if(_loc23_ != null && _loc23_ != "")
            {
               _loc13_.setBoostsCatalog(_loc23_.split(","));
            }
            _loc13_.setName(param1.playerName);
            if(Config.getConfig().gameHasBuildingBadges() && param1.cityName != null)
            {
               _loc13_.setCityName(param1.cityName);
            }
            _loc24_ = param1.deckNames;
            if(_loc24_ != null && _loc24_ != "")
            {
               _loc13_.setDeckNames(_loc24_.split(","));
            }
            else
            {
               _loc13_.resetDeckNames();
            }
            _loc25_ = param1.availableJobs;
            _loc26_ = _loc25_ != "" && _loc25_ != null || _loc5_ || (Utils.isBrowser() || Utils.isDesktop()) ? _loc25_ : param3.getAvailableJobsToString();
            if(_loc26_ != null && _loc26_ != "")
            {
               _loc13_.setAvailableJobs(_loc26_.split(","));
            }
            _loc27_ = param1.availableSkins;
            _loc28_ = _loc27_ != "" && _loc27_ != null || _loc5_ || (Utils.isBrowser() || Utils.isDesktop()) ? _loc27_ : param3.getAvailableSkinsToString();
            if(_loc28_ != null && _loc28_ != "")
            {
               _loc13_.setAvailableSkins(_loc28_.split(","));
            }
            _loc29_ = !_loc5_ && Boolean(param3) ? param3.getCurrentSkinSku() : param1.currentSkinSku;
            if(_loc29_ != "")
            {
               _loc13_.setCurrentSkinSku(_loc29_);
            }
            _loc30_ = param1.availablePortraits;
            _loc31_ = _loc30_ != "" && _loc30_ != null || _loc5_ || (Utils.isBrowser() || Utils.isDesktop()) ? _loc30_ : param3.getAvailablePortraitsToString();
            if(_loc31_ != null && _loc31_ != "")
            {
               _loc13_.setAvailablePortraits(_loc31_.split(","));
            }
            _loc32_ = !_loc5_ && Boolean(param3) ? param3.getCurrentPortraitSku() : param1.currentPortraitSku;
            if(_loc32_ != "")
            {
               _loc13_.setCurrentPortraitSku(_loc32_);
            }
            _loc33_ = !_loc5_ && Boolean(param3) ? int(param3.getLives()) : int(param1.lives);
            if(_loc33_ != -1)
            {
               _loc13_.setLives(_loc33_);
            }
            _loc34_ = !_loc5_ && Boolean(param3) ? Number(param3.getLostLifeTimeMS()) : Number(param1.lostLiveTimeMS);
            _loc34_ = !isNaN(_loc34_) ? _loc34_ : 0;
            if(_loc34_ != -1)
            {
               _loc13_.setLostLifeTimeMS(_loc34_);
            }
            _loc35_ = !_loc5_ && Boolean(param3) ? Number(param3.getCurrentDateMS()) : Number(param1.currentDateMS);
            if(_loc35_ != -1)
            {
               _loc13_.setCurrentDateMS(_loc35_);
            }
            _loc36_ = !_loc5_ && Boolean(param3) ? Number(param3.getProgressResetDate()) : Number(param1.progressResetDate);
            if(_loc36_ != -1)
            {
               _loc13_.setProgressResetDate(_loc36_);
            }
            _loc37_ = int(param1.decksPurchasedAmount);
            if(_loc37_ != -1)
            {
               _loc13_.setDecksPurchasedAmount(_loc37_);
            }
            if(param2)
            {
               _loc68_ = Number(InstanceMng.getServerConnection().getBackendUserProfile().currencies[ServerConnection.CURRENCY_GOLD]);
               this.syncGold([_loc7_,_loc8_,_loc9_],[param1.currentLevelSku,param1.currentLevelMediumSku,param1.currentLevelHardSku],_loc5_,_loc13_,param2,_loc68_);
               _loc69_ = int(InstanceMng.getServerConnection().getBackendUserProfile().currencies[ServerConnection.CURRENCY_RAID_COINS]);
               _loc70_ = int(InstanceMng.getServerConnection().getBackendUserProfile().currencies[ServerConnection.CURRENCY_QUEST_COINS]);
               _loc13_.setQuestsCoins(_loc70_);
               _loc13_.setRaidCoins(_loc69_);
               _loc13_.setRaidTicketsSinglePlayer(InstanceMng.getServerConnection().getBackendUserProfile().currencies[ServerConnection.CURRENCY_RAID_TICKETS_SP]);
               _loc13_.setRaidTicketsMultiPlayer(InstanceMng.getServerConnection().getBackendUserProfile().currencies[ServerConnection.CURRENCY_RAID_TICKETS_MP]);
               _loc13_.setAuctionTickets(InstanceMng.getServerConnection().getBackendUserProfile().currencies[ServerConnection.CURRENCY_AH_TOKENS]);
            }
            else
            {
               _loc13_.setGold(0);
               _loc13_.setQuestsCoins(0);
               _loc13_.setRaidCoins(0);
               _loc13_.setRaidTicketsSinglePlayer(0);
               _loc13_.setRaidTicketsMultiPlayer(0);
               _loc13_.setAuctionTickets(0);
            }
            _loc38_ = param1.exp != null && param1.exp != 0 ? int(param1.exp) : 0;
            _loc39_ = param1.elo != null && param1.elo != 0 ? int(param1.elo) : 1000;
            _loc40_ = param1.pvpCurrentLeague != null && param1.pvpCurrentLeague != 0 ? int(param1.pvpCurrentLeague) : 3;
            _loc41_ = param1.pvpBestLeague != null && param1.pvpBestLeague != 0 ? int(param1.pvpBestLeague) : 3;
            _loc13_.setExp(_loc38_);
            _loc13_.setPvPCurrentLeague(_loc40_);
            _loc13_.setPvPBestLeague(_loc41_);
            if(_loc39_ != 0)
            {
               _loc13_.setElo(_loc39_);
            }
            if(param1.hasOwnProperty("battlePass"))
            {
               _loc13_.setBattlePass(param1.battlePass);
            }
            if(param1.uniquePacksArr != "")
            {
               _loc42_ = String(param1.uniquePacksArr).split(",");
            }
            if(Boolean(_loc42_) && _loc42_.length > 0)
            {
               _loc13_.setUniquePacksArr(_loc42_);
            }
            else
            {
               _loc13_.setUniquePacksArr(null);
            }
            _loc43_ = String(param1.newCardsCollection).split(",");
            _loc13_.setNewCardsCollection(_loc43_);
            _loc44_ = String(param1.favouriteCardsCollection).split(",");
            _loc13_.setFavouritesCollection(_loc44_);
            _loc45_ = param1.auctionIdCreatedArr ? String(param1.auctionIdCreatedArr).split(",") : null;
            if((Boolean(_loc45_)) && _loc45_.length > 0)
            {
               _loc13_.setAuctionIdCreatedArr(_loc45_);
            }
            else
            {
               _loc13_.setAuctionIdCreatedArr(null);
            }
            _loc46_ = param1.auctionIdBiddedArr ? String(param1.auctionIdBiddedArr).split(",") : null;
            if((Boolean(_loc46_)) && _loc46_.length > 0)
            {
               _loc13_.setAuctionIdBiddedArr(_loc46_);
            }
            else
            {
               _loc13_.setAuctionIdBiddedArr(null);
            }
            _loc13_.setMatchesLost(param1.matchesLost);
            _loc13_.setMatchesWon(param1.matchesWon);
            _loc13_.setMatchesPlayed(param1.matchesPlayed);
            _loc13_.setPvPSeason(param1.pvpSeason);
            _loc13_.setDungeonsSeason(param1.dungeonsSeason);
            _loc13_.setDungeonsLost(param1.dungeonsLost);
            _loc13_.setDungeonsWon(param1.dungeonsWon);
            _loc13_.setDungeonsPlayed(param1.dungeonsPlayed);
            if(param2)
            {
               _loc71_ = param1.languageLocale ? param1.languageLocale : Capabilities.language.toUpperCase();
               _loc13_.setLanguageLocale(_loc71_);
            }
            _loc47_ = param1.dailyRewardTimeMS ? Number(param1.dailyRewardTimeMS) : 0;
            _loc13_.setDailyRewardTimeMS(_loc47_);
            _loc48_ = param1.lastDailyRewardClaimedIndex ? Number(param1.lastDailyRewardClaimedIndex) : 0;
            _loc13_.setLastDailyRewardClaimedIndex(_loc48_);
            _loc49_ = param1.oldPlayerComingBackDailyRewardTimeMS ? Number(param1.oldPlayerComingBackDailyRewardTimeMS) : 0;
            _loc13_.setOldPlayerComingBackDailyRewardTimeMS(_loc49_);
            _loc50_ = param1.oldPlayerComingBackLastDailyRewardClaimedIndex ? Number(param1.oldPlayerComingBackLastDailyRewardClaimedIndex) : 0;
            _loc13_.setOldPlayerComingBackLastDailyRewardClaimedIndex(_loc50_);
            _loc51_ = param1.levelAttempts ? Number(param1.levelAttempts) : 0;
            _loc52_ = param3 != null && Boolean(param3.getLevelAttempts()) ? Number(param3.getLevelAttempts()) : 0;
            _loc51_ = Math.max(_loc51_,_loc52_);
            _loc13_.setLevelAttempts(_loc51_);
            _loc53_ = param1.firstFirebaseDBTrack ? Number(param1.firstFirebaseDBTrack) : 0;
            _loc54_ = param3 != null && Boolean(param3.getFirstFirebaseDBTrack()) ? Number(param3.getFirstFirebaseDBTrack()) : 0;
            _loc53_ = _loc53_ != 0 && _loc54_ != 0 ? Math.min(_loc53_,_loc54_) : _loc53_;
            _loc13_.setFirstFirebaseDBTrack(_loc53_);
            _loc55_ = param1.finishedLastCampaignTimeMs >= 0 ? Number(param1.finishedLastCampaignTimeMs) : 0;
            _loc13_.setFinishedLastcampaignTimestamp(_loc55_,false);
            this.syncBadgesCollection(_loc7_,param1.currentLevelSku,_loc5_,param1,_loc13_);
            this.syncBadgesRewardsClaimed(param1.badgesRewardsClaimed,_loc13_);
            this.syncStarsRewardsClaimed(param1.starsRewardsClaimed,_loc13_);
            this.syncQuestsClaimed(param1.questsClaimed,_loc13_);
            this.syncQuestsCompleted(param1.questsCompleted,_loc13_);
            this.syncQuestsNotifiedAsCompleted(param1.questsNotifiedAsCompleted,_loc13_);
            this.syncQuestsProgress(param1.questsProgress,_loc13_);
            if(!isNaN(param1.dailyKeyTime))
            {
               _loc13_.setDailyKeyTime(param1.dailyKeyTime);
            }
            if(!isNaN(param1.weekNumber))
            {
               _loc13_.setWeekNumber(param1.weekNumber);
            }
            if(!isNaN(param1.monthNumber))
            {
               _loc13_.setMonthNumber(param1.monthNumber);
            }
            _loc13_.setCustomOfferNextVisibleDateMS(param1.customOfferNextVisibleDateMS);
            _loc13_.setCustomOfferNewBannerShown(param1.customOfferNewBannerShown);
            _loc13_.setCustomOfferShown(param1.customOfferShown);
            _loc13_.setCustomOffersPurchased(param1.customOffersPurchased);
            _loc13_.setCustomOffersViewsCount(param1.customOffersViewsCount);
            this.syncComicsRead(_loc13_);
            this.syncJobsExp(_loc5_,param1,_loc13_);
            _loc13_.setMapWorldChoices(param1.mapWorldChoices);
            if(param1.deckJobConfigurator != null && param1.deckJobConfigurator != "")
            {
               _loc72_ = String(param1.deckJobConfigurator).split(",");
               if((Boolean(_loc72_)) && _loc72_.length > 0)
               {
                  _loc13_.setDeckJobConfiguratorArr(_loc72_);
               }
               else
               {
                  _loc13_.setDeckJobConfiguratorArr(null);
               }
            }
            else
            {
               _loc13_.setDeckJobConfiguratorArr(null);
            }
            _loc56_ = param1.guildMemberId != null ? param1.guildMemberId : "";
            _loc57_ = param1.guildId != null ? param1.guildId : "";
            _loc58_ = param1.guildRank != null ? int(param1.guildRank) : -1;
            _loc13_.setGuildMemberId(_loc56_);
            _loc13_.setGuildId(_loc57_);
            _loc13_.setIsOwner(param2);
            _loc59_ = param1.hasOwnProperty("globalTotalScore") ? int(param1.globalTotalScore) : 0;
            _loc60_ = param1.hasOwnProperty("weeklyTotalScore") ? int(param1.weeklyTotalScore) : 0;
            _loc13_.setGuildGlobalTotalScore(_loc59_);
            _loc13_.setGuildWeeklyTotalScore(_loc60_);
            _loc13_.setGuildRank(_loc58_);
            if(param1.hasOwnProperty("platformVersions") && param1.platformVersions != null)
            {
               _loc13_.setPlatformVersions(String(param1.platformVersions).split(","));
            }
            if(param1.hasOwnProperty("extPhotoURL") && param1["extPhotoURL"] != null)
            {
               if(!_loc13_.flagsShowDefaultAvatar())
               {
                  _loc13_.setPhotoUrl(param1["extPhotoURL"]);
               }
            }
            _loc13_.addVersionByPlatform(InstanceMng.getServerConnection().getPlatformId(),Utils.getAppVersion());
            if(param1.raidsUnlocked == null)
            {
               _loc13_.setRaidsUnlocked(null);
            }
            else
            {
               _loc13_.setRaidsUnlocked(String(param1.raidsUnlocked).split(","));
            }
            if(param1.botsPlayedSession == null)
            {
               _loc13_.setBotsPlayedSession(0);
            }
            else
            {
               _loc13_.setBotsPlayedSession(int(param1.botsPlayedSession));
            }
            _loc13_.addNewSkinsJobs();
         }
         else
         {
            FSDebug.debugTrace("UserDataMng Online crashed because the Backend server profile is NULL");
            _loc13_.setIsOwner(param2);
         }
         return _loc13_;
      }
   }
}

