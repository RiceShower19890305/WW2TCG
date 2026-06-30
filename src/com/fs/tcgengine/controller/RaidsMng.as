package com.fs.tcgengine.controller
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.rules.RaidDef;
   import com.fs.tcgengine.model.rules.RaidLevelDef;
   import com.fs.tcgengine.model.rules.RewardDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.screens.FSRaidsScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.TimerUtil;
   import com.fs.tcgengine.utils.Utils;
   import com.greensock.TweenMax;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import starling.utils.SystemUtil;
   
   public class RaidsMng
   {
      
      public static var smWeeklySeasonEndingTimeMS:Number;
      
      public static var smWeeklySeasonStartingTimeMS:Number;
      
      public static var smRaidScoresSP:Object;
      
      public static var smRaidScoresMP:Object;
      
      public static const RAID_DIFFICULTY_EASY:int = 0;
      
      public static const RAID_DIFFICULTY_MEDIUM:int = 1;
      
      public static const RAID_DIFFICULTY_HARD:int = 2;
      
      public static const RAID_DIFFICULTY_EXPERT:int = 3;
      
      public static const REWARD_TYPE_CARD:int = 0;
      
      public static const REWARD_TYPE_PACK:int = 1;
      
      public static const REWARD_TYPE_RAID_COINS:int = 2;
      
      public static const REWARD_TYPE_GOLD:int = 3;
      
      public static const REWARD_TYPE_SKIN:int = 4;
      
      public static const RESET_HOUR:int = 9;
      
      public static var smWeeklySeasonIndex:int = -1;
      
      private var mCurrentRaidDef:RaidDef;
      
      private var mCurrentRaidDifficulty:int;
      
      private var mCurrentRaidLevelSku:String;
      
      private var mBossHealCurrentRaid:int;
      
      private var mBossHitCurrentRaid:int;
      
      private var mCurrentRaidObj:Object;
      
      private var mCurrentRaidsBattlesObj:Object;
      
      private var mRaidsRotationMessageReceived:Boolean = false;
      
      private var mBossHPTemp:FSNumber;
      
      public function RaidsMng()
      {
         super();
      }
      
      public function setCurrentRaidDef(param1:RaidDef) : void
      {
         this.mCurrentRaidDef = param1;
      }
      
      public function setCurrentRaidDifficulty(param1:int) : void
      {
         this.mCurrentRaidDifficulty = param1;
      }
      
      public function getRaidsConfiguration() : void
      {
         this.mRaidsRotationMessageReceived = false;
         TweenMax.killDelayedCallsTo(this.checkRaidsInfoReceivedFromServer);
         TweenMax.delayedCall(3,this.checkRaidsInfoReceivedFromServer);
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            InstanceMng.getServerConnection().getServerConfig(false,this.onRaidsConfigInfoACK,null,false);
         }
      }
      
      private function checkRaidsInfoReceivedFromServer() : void
      {
         TweenMax.killDelayedCallsTo(this.checkRaidsInfoReceivedFromServer);
         FSDebug.debugTrace("Checking again the raids information on the server");
         this.getRaidsConfiguration();
      }
      
      private function onRaidsConfigInfoACK(param1:Object) : void
      {
         TweenMax.killDelayedCallsTo(this.checkRaidsInfoReceivedFromServer);
         if(InstanceMng.getCurrentScreen() is FSRaidsScreen)
         {
            FSRaidsScreen(InstanceMng.getCurrentScreen()).setRaidsConfigAsReceived(true);
         }
         if(ServerConnection.smServerRaidsMPRewardsDefs == null)
         {
            InstanceMng.getServerConnection().searchInCollection("RaidsMPAwards","{}",this.onRaidsMPReceived);
         }
         if(ServerConnection.smServerRaidsSPRewardsDefs == null)
         {
            InstanceMng.getServerConnection().searchInCollection("RaidsSPAwards","{}",this.onRaidsSPReceived);
         }
         this.checkRaidsTutorial();
      }
      
      private function onRaidsMPReceived(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         if(param1)
         {
            _loc2_ = param1 as Array;
            if(_loc2_ != null && _loc2_.length > 0)
            {
               if(ServerConnection.smServerRaidsMPRewardsDefs == null)
               {
                  ServerConnection.smServerRaidsMPRewardsDefs = new Dictionary(true);
               }
               _loc3_ = 0;
               while(_loc3_ < _loc2_.length)
               {
                  ServerConnection.smServerRaidsMPRewardsDefs[int(_loc2_[_loc3_]["RaidNumber"])] = _loc2_[_loc3_];
                  _loc3_++;
               }
            }
         }
      }
      
      private function checkRaidsTutorial() : void
      {
         var _loc5_:Boolean = false;
         var _loc1_:UserData = Utils.getOwnerUserData();
         var _loc2_:Screen = _loc1_ ? InstanceMng.getCurrentScreen() : null;
         var _loc3_:Boolean = ServerConnection.smServerRaidsMPRewardsDefs != null && ServerConnection.smServerRaidsSPRewardsDefs != null;
         var _loc4_:Boolean = _loc2_ != null && _loc2_ is FSRaidsScreen && FSRaidsScreen(_loc2_).mUICreated && _loc3_;
         if(_loc4_)
         {
            _loc5_ = _loc1_.flagsGetRaidsTutorialSeenON();
            if(!_loc5_)
            {
               _loc1_.setRaidsTutorialSeenON(true);
               InstanceMng.getUserDataMng().persistenceSaveData();
               InstanceMng.getPopupMng().openGetImageAndTextPopup(TextManager.getText("TID_RAID_TUTORIAL"),"raid_tutorial_image");
            }
         }
         else
         {
            setTimeout(this.checkRaidsTutorial,500);
         }
      }
      
      private function onRaidsSPReceived(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         if(param1)
         {
            _loc2_ = param1 as Array;
            if(_loc2_ != null && _loc2_.length > 0)
            {
               if(ServerConnection.smServerRaidsSPRewardsDefs == null)
               {
                  ServerConnection.smServerRaidsSPRewardsDefs = new Dictionary(true);
               }
               _loc3_ = 0;
               while(_loc3_ < _loc2_.length)
               {
                  ServerConnection.smServerRaidsSPRewardsDefs[int(_loc2_[_loc3_]["RaidNumber"])] = _loc2_[_loc3_];
                  _loc3_++;
               }
            }
         }
      }
      
      public function onRaidStart(param1:RaidDef, param2:int, param3:int) : void
      {
         var _loc4_:int = 0;
         this.mCurrentRaidDef = param1;
         this.mCurrentRaidDifficulty = param2;
         if(Boolean(this.mCurrentRaidDef) && Boolean(InstanceMng.getCurrentScreen()))
         {
            this.mCurrentRaidLevelSku = RaidLevelDef(InstanceMng.getRaidLevelsDefMng().getLevelDefByLevelIndex(this.mCurrentRaidDef.getLevelsByDifficultyIndex(this.mCurrentRaidDifficulty))).getSku();
            if(Config.getConfig().hasQuests())
            {
               if(param1.getIsMultiPlayer())
               {
                  InstanceMng.getQuestsMng().addActionPerformed(QuestsMng.TARGET_TYPE_START_RAID_MP,1,false,null,null,this.mCurrentRaidDef.getSku(),this.mCurrentRaidDifficulty);
               }
               else
               {
                  InstanceMng.getQuestsMng().addActionPerformed(QuestsMng.TARGET_TYPE_START_RAID_SP,1,false,null,null,this.mCurrentRaidDef.getSku(),this.mCurrentRaidDifficulty);
               }
               InstanceMng.getQuestsMng().addActionPerformed(QuestsMng.TARGET_USE_RAID_TICKET,1,true,[QuestsMng.TARGET_EXTRA_INFO_IS_MULTI + ":" + param1.getIsMultiPlayer()],null,this.mCurrentRaidDef.getSku(),this.mCurrentRaidDifficulty);
            }
            Utils.setStat(Constants.STAT_RAIDS_PLAYED,1);
            if(InstanceMng.getCurrentScreen() is FSRaidsScreen)
            {
               InstanceMng.getCurrentScreen().startBattle(this.mCurrentRaidLevelSku,false,false,true);
               FSTracker.trackFirebaseEvent("RAID_STARTED");
               FSTracker.trackMiscAction(FSTracker.CATEGORY_RAIDS,FSTracker.ACTION_RAID_STARTED,{
                  "raid":this.mCurrentRaidDef.getSku(),
                  "difficulty":this.mCurrentRaidDifficulty,
                  "bossHP":param3
               });
            }
            else
            {
               FSTracker.trackMiscAction(FSTracker.CATEGORY_RAIDS,FSTracker.ACTION_RAID_CONTINUED,{
                  "raid":this.mCurrentRaidDef.getSku(),
                  "difficulty":this.mCurrentRaidDifficulty,
                  "bossHP":param3
               });
            }
         }
      }
      
      public function getCurrentRaidDef() : RaidDef
      {
         return this.mCurrentRaidDef;
      }
      
      public function getRaidBossHP(param1:RaidDef, param2:int) : int
      {
         var _loc3_:RaidLevelDef = RaidLevelDef(InstanceMng.getRaidLevelsDefMng().getLevelDefByLevelIndex(param1.getLevelsByDifficultyIndex(param2)));
         var _loc4_:int = _loc3_.getIAHP();
         var _loc5_:int = this.getTotalRaidDamageDone(param1,param2);
         return _loc4_ - _loc5_ <= 0 ? 0 : int(_loc4_ - _loc5_);
      }
      
      public function getCurrentRaidDifficulty() : int
      {
         return this.mCurrentRaidDifficulty;
      }
      
      public function onRaidLevelFailed() : void
      {
         this.onRaidLevelEndedPerformOps(false);
         InstanceMng.getPopupMng().openRaidLevelFailedPopup();
      }
      
      public function onRaidLevelCompleted() : void
      {
         this.onRaidLevelEndedPerformOps(true);
         InstanceMng.getPopupMng().openRaidLevelCompletedPopup();
      }
      
      private function onRaidLevelEndedPerformOps(param1:Boolean) : void
      {
         var _loc2_:RaidDef = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:BattleEngine = null;
         var _loc7_:String = null;
         if(InstanceMng.getRaidsMng())
         {
            _loc2_ = this.getCurrentRaidDef();
            _loc3_ = this.getCurrentRaidDifficulty();
            _loc6_ = InstanceMng.getBattleEngine();
            if(_loc6_)
            {
               if(_loc6_.getOwnerBattleInfo())
               {
                  _loc4_ = _loc6_.getOwnerBattleInfo().getRaidCumulativeDamageCurrentBattle();
               }
               if(_loc6_.getOpponentBattleInfo())
               {
                  _loc5_ = _loc6_.getOpponentBattleInfo().getHP();
               }
            }
            if(_loc2_)
            {
               _loc7_ = param1 ? FSTracker.ACTION_RAID_FINISH_BOSS_DEFEATED : FSTracker.ACTION_RAID_FINISH_INCOMPLETE;
               FSTracker.trackMiscAction(FSTracker.CATEGORY_RAIDS,_loc7_,{
                  "raid":_loc2_.getSku(),
                  "difficulty":_loc3_,
                  "bossHP":_loc5_,
                  "cumulativeDamage":_loc4_
               });
               if(InstanceMng.getUserDataMng().getOwnerUserData())
               {
                  InstanceMng.getUserDataMng().getOwnerUserData().addGuildWeeklyRaidScore(_loc4_,_loc2_.getIsMultiPlayer());
               }
            }
         }
      }
      
      public function resetRaidsMng(param1:Boolean = true, param2:Boolean = true) : void
      {
         this.mCurrentRaidDef = null;
         this.mCurrentRaidDifficulty = -1;
         this.mCurrentRaidLevelSku = "";
         this.mCurrentRaidObj = null;
         this.mCurrentRaidsBattlesObj = null;
         this.mBossHealCurrentRaid = 0;
         this.mBossHitCurrentRaid = 0;
         if(Root.smBattleData)
         {
            Root.smBattleData.isRaid = false;
         }
         if(param2 && InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            FSBattleScreen(InstanceMng.getCurrentScreen()).showRaidsScreen();
         }
         if(param1)
         {
            Utils.stopSound(Constants.SOUND_VICTORY);
            Utils.stopSound(Constants.SOUND_DEFEAT);
            if(Utils.isMusicOn() && Config.getConfig().battleHasOwnMusic())
            {
               if(Config.smTracklistModeOn)
               {
                  Utils.loadNextTrack();
               }
               else
               {
                  Utils.resumeAllSounds();
               }
            }
         }
      }
      
      private function rollCards(param1:RewardDef) : Dictionary
      {
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:Dictionary = null;
         var _loc11_:Array = null;
         var _loc12_:Number = NaN;
         var _loc13_:String = null;
         var _loc14_:int = 0;
         var _loc21_:String = null;
         var _loc2_:Dictionary = new Dictionary(true);
         var _loc3_:Object = InstanceMng.getRewardsDefMng().getRewardCardRaritiesCatalogs(RewardDef(param1),1);
         var _loc4_:Dictionary = _loc3_.rarities;
         var _loc5_:Dictionary = _loc3_.mixedRarities;
         var _loc6_:Array = DictionaryUtils.getKeys(_loc4_);
         var _loc7_:Array = DictionaryUtils.getKeys(_loc5_);
         _loc6_.sort();
         _loc7_.sort();
         var _loc15_:int = 0;
         var _loc16_:String = null;
         var _loc17_:String = null;
         var _loc18_:String = param1.getEditionSku();
         var _loc19_:int = -1;
         _loc8_ = 0;
         while(_loc8_ < _loc6_.length)
         {
            _loc9_ = _loc6_[_loc8_];
            _loc10_ = InstanceMng.getCardsDefMng().getAllCardsDefs(_loc9_,1,_loc16_,_loc19_,_loc18_);
            _loc11_ = DictionaryUtils.getKeys(_loc10_);
            _loc14_ = 0;
            while(_loc14_ < _loc4_[_loc9_])
            {
               _loc13_ = Utils.getRandomItemFromArr(_loc11_);
               _loc2_[_loc15_] = _loc13_;
               _loc15_++;
               _loc14_++;
            }
            _loc8_++;
         }
         var _loc20_:int = _loc15_;
         _loc8_ = 0;
         while(_loc8_ < _loc7_.length)
         {
            _loc21_ = this.getRandomRarityByChance(_loc5_[_loc8_ + _loc20_ + 1]);
            if(_loc21_ != null)
            {
               _loc10_ = InstanceMng.getCardsDefMng().getAllCardsDefs(_loc21_,1,_loc16_,_loc19_,_loc18_);
               _loc11_ = DictionaryUtils.getKeys(_loc10_);
               _loc13_ = Utils.getRandomItemFromArr(_loc11_);
               _loc2_[_loc15_] = _loc13_;
               _loc15_++;
            }
            _loc8_++;
         }
         return DictionaryUtils.sortByCardValue(_loc2_);
      }
      
      private function getRandomRarityByChance(param1:Dictionary) : String
      {
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc2_:String = "";
         var _loc3_:Dictionary = new Dictionary(true);
         var _loc4_:Array = DictionaryUtils.getKeys(param1);
         var _loc9_:int = 0;
         _loc8_ = 0;
         while(_loc8_ < _loc4_.length)
         {
            _loc6_ = _loc4_[_loc8_];
            _loc5_ = int(param1[_loc6_]);
            _loc7_ = 0;
            while(_loc7_ < _loc5_)
            {
               _loc3_[_loc9_] = _loc6_;
               _loc9_++;
               _loc7_++;
            }
            _loc8_++;
         }
         var _loc10_:Number = Utils.randomInt(0,99);
         return _loc3_[_loc10_];
      }
      
      public function rollPacks(param1:RewardDef) : String
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc7_:int = 0;
         var _loc10_:int = 0;
         var _loc2_:String = "";
         var _loc3_:Dictionary = param1.getPackChances();
         var _loc6_:Dictionary = new Dictionary(true);
         var _loc8_:int = 0;
         var _loc9_:Array = DictionaryUtils.getKeys(_loc3_);
         var _loc11_:int = 0;
         _loc10_ = 0;
         while(_loc10_ < _loc9_.length)
         {
            _loc4_ = _loc9_[_loc10_];
            _loc7_ = int(_loc3_[_loc4_]);
            _loc5_ = 0;
            while(_loc5_ < _loc7_)
            {
               _loc6_[_loc8_] = _loc4_;
               _loc8_++;
               _loc5_++;
            }
            _loc11_ += _loc7_;
            _loc10_++;
         }
         if(_loc11_ != 100)
         {
            FSDebug.debugTrace("[CHEAT CONSOLE] - REWARD CHANCES > chance total:" + _loc11_ + " rewardDef=" + param1.getSku());
         }
         var _loc12_:Number = Utils.randomInt(0,99);
         return _loc6_[_loc12_];
      }
      
      public function getDifficultyTIDByDifficultyIndex(param1:int) : String
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case RAID_DIFFICULTY_EASY:
               _loc2_ = "TID_DUNGEON_DIFFICULTY_01";
               break;
            case RAID_DIFFICULTY_MEDIUM:
               _loc2_ = "TID_DUNGEON_DIFFICULTY_02";
               break;
            case RAID_DIFFICULTY_HARD:
               _loc2_ = "TID_DUNGEON_DIFFICULTY_03";
               break;
            case RAID_DIFFICULTY_EXPERT:
               _loc2_ = "TID_RAID_EXPERT";
         }
         return _loc2_;
      }
      
      public function getWeeklySeasonTimeLeft() : String
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc1_:String = "";
         var _loc2_:Number = -1;
         if(ServerConnection.smServerTimeMS != -1 && smWeeklySeasonStartingTimeMS != -1 && smWeeklySeasonEndingTimeMS != -1)
         {
            _loc2_ = ServerConnection.smServerTimeMS < smWeeklySeasonStartingTimeMS ? smWeeklySeasonStartingTimeMS - ServerConnection.smServerTimeMS : smWeeklySeasonEndingTimeMS - ServerConnection.smServerTimeMS;
         }
         if(_loc2_ != -1)
         {
            if(TimerUtil.msToHour(_loc2_) < 1)
            {
               if(TimerUtil.msToMin(_loc2_) < 1)
               {
                  _loc1_ = TimerUtil.getTimeTextFromMs(_loc2_,null,null,null,TextManager.getText("TID_GEN_TIME_SECONDS_ABR"));
               }
               else
               {
                  _loc1_ = TimerUtil.getTimeTextFromMs(_loc2_,null,null,TextManager.getText("TID_GEN_TIME_MINUTES_ABR"));
               }
            }
            else
            {
               _loc3_ = TimerUtil.msToDays(_loc2_) > 0 ? TextManager.getText("TID_GEN_TIME_DAYS_ABR") : null;
               _loc4_ = TimerUtil.msToDays(_loc2_) < 1 ? TextManager.getText("TID_GEN_TIME_HOURS_ABR") : null;
               _loc1_ = TimerUtil.getTimeTextFromMs(_loc2_,_loc3_,_loc4_,null,null);
            }
         }
         if(_loc2_ != -1 && _loc2_ > 0)
         {
            if(ServerConnection.smServerTimeMS < smWeeklySeasonStartingTimeMS)
            {
               _loc1_ = "-" + _loc1_;
            }
         }
         else
         {
            _loc1_ = "???";
         }
         return _loc1_;
      }
      
      public function getMonthlySeasonTimeLeft() : String
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc1_:String = "";
         var _loc2_:Number = -1;
         if(ServerConnection.smServerTimeMS != -1 && smWeeklySeasonStartingTimeMS != -1 && smWeeklySeasonEndingTimeMS != -1)
         {
            _loc2_ = ServerConnection.smServerTimeMS < smWeeklySeasonStartingTimeMS ? smWeeklySeasonStartingTimeMS - ServerConnection.smServerTimeMS : smWeeklySeasonEndingTimeMS - ServerConnection.smServerTimeMS;
         }
         if(_loc2_ != -1)
         {
            if(TimerUtil.msToHour(_loc2_) < 1)
            {
               if(TimerUtil.msToMin(_loc2_) < 1)
               {
                  _loc1_ = TimerUtil.getTimeTextFromMs(_loc2_,null,null,null,TextManager.getText("TID_GEN_TIME_SECONDS_ABR"));
               }
               else
               {
                  _loc1_ = TimerUtil.getTimeTextFromMs(_loc2_,null,null,TextManager.getText("TID_GEN_TIME_MINUTES_ABR"));
               }
            }
            else
            {
               _loc3_ = TimerUtil.msToDays(_loc2_) > 0 ? TextManager.getText("TID_GEN_TIME_DAYS_ABR") : null;
               _loc4_ = TimerUtil.msToDays(_loc2_) < 1 ? TextManager.getText("TID_GEN_TIME_HOURS_ABR") : null;
               _loc1_ = TimerUtil.getTimeTextFromMs(_loc2_,_loc3_,_loc4_,null,null);
            }
         }
         if(_loc2_ != -1 && _loc2_ > 0)
         {
            if(ServerConnection.smServerTimeMS < smWeeklySeasonStartingTimeMS)
            {
               _loc1_ = "-" + _loc1_;
            }
         }
         else
         {
            _loc1_ = "???";
         }
         return _loc1_;
      }
      
      public function onBattleInfoReceivedUpdateBossHP(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:String = null;
         var _loc8_:Boolean = false;
         var _loc9_:int = 0;
         if(param1)
         {
            this.onRaidDamageReceivedUpdateLogic(param1);
            _loc3_ = 0;
            _loc4_ = this.mCurrentRaidDef ? this.mCurrentRaidDef.getSku() : "";
            _loc5_ = _loc4_ != "" && _loc4_ == param1.raidSku && this.mCurrentRaidDifficulty == param1.difficulty;
            if(Boolean(InstanceMng.getCurrentScreen().isFullyLoaded() && InstanceMng.getBattleEngine()) && Boolean(InstanceMng.getBattleEngine().getBattleScreen()) && Boolean(InstanceMng.getBattleEngine().getBattleScreen().getOpponentPortrait()))
            {
               if(_loc5_)
               {
                  _loc6_ = Boolean(Root.smBattleData) && Boolean(Root.smBattleData.isRaid);
                  if(_loc6_)
                  {
                     _loc2_ = this.getRaidBossHP(this.mCurrentRaidDef,this.mCurrentRaidDifficulty);
                     _loc7_ = InstanceMng.getUserDataMng().getOwnerUserData().getAccountId();
                     _loc8_ = _loc7_ != param1.playerId || Boolean(param1.forceRepro);
                     if(_loc8_)
                     {
                        InstanceMng.getBattleEngine().getBattleScreen().getOpponentPortrait().getHPPlayerViewer().updateHP(_loc2_);
                        if(InstanceMng.getBattleEngine().getOpponentBattleInfo())
                        {
                           if(this.mBossHPTemp == null)
                           {
                              this.mBossHPTemp = new FSNumber();
                           }
                           this.mBossHPTemp.value = _loc2_;
                           InstanceMng.getBattleEngine().getOpponentBattleInfo().setHP(this.mBossHPTemp);
                        }
                        _loc9_ = int(param1.damage);
                        if(_loc9_ > 0)
                        {
                           InstanceMng.getTextParticlesMng().showTextParticle("- " + _loc9_.toString(),16711680,InstanceMng.getBattleEngine().getBattleScreen().getOpponentPortrait());
                        }
                        else
                        {
                           InstanceMng.getTextParticlesMng().showTextParticle("+ " + Math.abs(_loc9_).toString(),65280,InstanceMng.getBattleEngine().getBattleScreen().getOpponentPortrait());
                        }
                     }
                  }
               }
            }
            else if(InstanceMng.getCurrentScreen().isFullyLoaded() && InstanceMng.getCurrentScreen() is FSRaidsScreen)
            {
               if(_loc5_ && Boolean(FSRaidsScreen(InstanceMng.getCurrentScreen()).getRaidIncompleteInfo()))
               {
                  FSRaidsScreen(InstanceMng.getCurrentScreen()).getRaidIncompleteInfo().onUsersInfoSuccess(param1);
               }
            }
         }
      }
      
      public function isWeeklySeasonActive() : Boolean
      {
         var _loc1_:Boolean = false;
         if(ServerConnection.smServerTimeMS != -1 && smWeeklySeasonStartingTimeMS != -1 && smWeeklySeasonEndingTimeMS != -1)
         {
            _loc1_ = ServerConnection.smServerTimeMS > smWeeklySeasonStartingTimeMS && ServerConnection.smServerTimeMS < smWeeklySeasonEndingTimeMS;
         }
         return _loc1_;
      }
      
      public function getBossHealCurrentRaid() : int
      {
         return this.mBossHealCurrentRaid;
      }
      
      public function setBossHealCurrentRaid(param1:int) : void
      {
         this.mBossHealCurrentRaid = param1;
      }
      
      public function getBossHitCurrentRaid() : int
      {
         return this.mBossHitCurrentRaid;
      }
      
      public function setBossHitCurrentRaid(param1:int) : void
      {
         this.mBossHitCurrentRaid = param1;
      }
      
      public function setRaidsObj(param1:Object) : void
      {
         this.mCurrentRaidObj = param1;
      }
      
      public function getRaidsObj() : Object
      {
         return this.mCurrentRaidObj;
      }
      
      public function setRaidsBattlesObj(param1:Object) : void
      {
         this.mCurrentRaidsBattlesObj = param1;
      }
      
      public function getRaidsBattlesObj() : Object
      {
         return this.mCurrentRaidsBattlesObj;
      }
      
      public function onRaidsRotationMessageReceived() : void
      {
         this.mRaidsRotationMessageReceived = true;
      }
      
      public function isAllowedToRetry() : Boolean
      {
         return this.mRaidsRotationMessageReceived == false;
      }
      
      public function refreshRaidsScores(param1:RaidDef, param2:Function = null, param3:Array = null) : void
      {
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         var _loc6_:String = null;
         if(param1)
         {
            _loc4_ = Boolean(param1) && param1.getIsMultiPlayer();
            if(_loc4_)
            {
               _loc5_ = InstanceMng.getUserDataMng().getOwnerUserData().getGuildId();
               _loc6_ = InstanceMng.getUserDataMng().getOwnerUserData().getAccountId();
               InstanceMng.getServerConnection().getRaidsMPScoresLB(param1.getSku(),_loc5_,_loc6_,this.onRaidDamageReceived,[param1.getSku(),param2,param3]);
            }
            else
            {
               InstanceMng.getServerConnection().getRaidsSPScore(param1.getSku(),this.onRaidDamageReceived,[param1.getSku(),param2,param3]);
            }
         }
      }
      
      private function onRaidDamageReceived(param1:Object, param2:String, param3:Function = null, param4:Array = null) : void
      {
         var _loc5_:RaidDef = RaidDef(InstanceMng.getRaidsDefMng().getDefBySku(param2));
         if(_loc5_.getIsMultiPlayer())
         {
            if(smRaidScoresMP == null)
            {
               smRaidScoresMP = new Object();
            }
            smRaidScoresMP[param2] = param1;
         }
         else
         {
            if(smRaidScoresSP == null)
            {
               smRaidScoresSP = new Object();
            }
            smRaidScoresSP[param2] = param1;
         }
         if(param3 != null)
         {
            if(param4 != null)
            {
               if(!Utils.isIOS())
               {
                  param3.apply(null,param4);
               }
               else
               {
                  SystemUtil.executeWhenApplicationIsActive(param3.apply,null,param4);
               }
            }
            else if(!Utils.isIOS())
            {
               param3();
            }
            else
            {
               SystemUtil.executeWhenApplicationIsActive(param3);
            }
         }
      }
      
      public function getTotaMPRaidDamageDone(param1:RaidDef, param2:int) : Array
      {
         var _loc3_:Array = null;
         var _loc4_:Boolean = false;
         if(param1)
         {
            _loc4_ = Boolean(param1) && param1.getIsMultiPlayer();
            if((_loc4_) && Boolean(smRaidScoresMP))
            {
               if(smRaidScoresMP.hasOwnProperty(param1.getSku()))
               {
                  if(smRaidScoresMP[param1.getSku()].hasOwnProperty("DIFF_" + param2))
                  {
                     _loc3_ = smRaidScoresMP[param1.getSku()]["DIFF_" + param2];
                  }
               }
            }
         }
         return _loc3_;
      }
      
      public function getTotalRaidDamageDone(param1:RaidDef, param2:int) : int
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc3_:int = 0;
         if(param1)
         {
            _loc6_ = Boolean(param1) && param1.getIsMultiPlayer();
            if((_loc6_) && Boolean(smRaidScoresMP))
            {
               if(smRaidScoresMP.hasOwnProperty(param1.getSku()))
               {
                  if(smRaidScoresMP[param1.getSku()] != null && Boolean(smRaidScoresMP[param1.getSku()].hasOwnProperty("DIFF_" + param2)))
                  {
                     _loc4_ = smRaidScoresMP[param1.getSku()]["DIFF_" + param2];
                     if(_loc4_)
                     {
                        _loc5_ = 0;
                        while(_loc5_ < _loc4_.length)
                        {
                           if(Boolean(_loc4_[_loc5_]) && Boolean(_loc4_[_loc5_].hasOwnProperty("damage")))
                           {
                              _loc3_ += _loc4_[_loc5_]["damage"];
                           }
                           _loc5_++;
                        }
                     }
                  }
               }
            }
            else if(!_loc6_ && Boolean(smRaidScoresSP))
            {
               if(smRaidScoresSP.hasOwnProperty(param1.getSku()))
               {
                  if(Boolean(smRaidScoresSP[param1.getSku()]) && Boolean(smRaidScoresSP[param1.getSku()].hasOwnProperty("DIFF_" + param2)))
                  {
                     _loc3_ = int(smRaidScoresSP[param1.getSku()]["DIFF_" + param2]);
                  }
               }
            }
         }
         return _loc3_;
      }
      
      public function isBossDefeated(param1:RaidDef, param2:int) : Boolean
      {
         var _loc4_:RaidLevelDef = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Boolean = false;
         var _loc3_:Boolean = false;
         if(param1)
         {
            _loc4_ = RaidLevelDef(InstanceMng.getRaidLevelsDefMng().getLevelDefByLevelIndex(param1.getLevelsByDifficultyIndex(param2)));
            _loc5_ = _loc4_.getIAHP();
            _loc6_ = this.getTotalRaidDamageDone(param1,param2);
            _loc7_ = _loc5_ - _loc6_ <= 0 ? 0 : int(_loc5_ - _loc6_);
            _loc8_ = _loc6_ > 0;
            _loc3_ = _loc7_ <= 0;
         }
         return _loc3_;
      }
      
      public function onRaidDamageReceivedUpdateLogic(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:RaidDef = null;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         if(param1 != null)
         {
            _loc2_ = param1.raidSku;
            _loc3_ = int(param1.difficulty);
            _loc4_ = param1.playerId;
            _loc5_ = int(param1.damage);
            _loc6_ = RaidDef(InstanceMng.getRaidsDefMng().getDefBySku(_loc2_));
            _loc9_ = false;
            if(_loc6_)
            {
               _loc10_ = Boolean(_loc6_) && _loc6_.getIsMultiPlayer();
               if(_loc10_)
               {
                  if(smRaidScoresMP == null)
                  {
                     this.onRaidDamageReceived(param1,_loc2_);
                  }
                  else if(smRaidScoresMP.hasOwnProperty(_loc6_.getSku()))
                  {
                     if(smRaidScoresMP[_loc6_.getSku()].hasOwnProperty("DIFF_" + _loc3_))
                     {
                        _loc7_ = smRaidScoresMP[_loc6_.getSku()]["DIFF_" + _loc3_];
                        if(_loc7_)
                        {
                           _loc8_ = 0;
                           while(_loc8_ < _loc7_.length)
                           {
                              if(_loc7_[_loc8_].hasOwnProperty("playerId"))
                              {
                                 if(_loc7_[_loc8_]["playerId"] == _loc4_)
                                 {
                                    _loc7_[_loc8_]["damage"] += _loc5_;
                                    _loc9_ = true;
                                    break;
                                 }
                              }
                              _loc8_++;
                           }
                           if(!_loc9_)
                           {
                              _loc7_.push(param1);
                           }
                        }
                     }
                     else
                     {
                        smRaidScoresMP[_loc6_.getSku()] = param1;
                     }
                  }
               }
               else if(smRaidScoresSP == null)
               {
                  this.onRaidDamageReceived(param1,_loc2_);
               }
               else if(smRaidScoresSP.hasOwnProperty(_loc6_.getSku()))
               {
                  if(smRaidScoresSP[_loc6_.getSku()].hasOwnProperty("DIFF_" + _loc3_))
                  {
                     smRaidScoresSP[_loc6_.getSku()]["DIFF_" + _loc3_] = smRaidScoresSP[_loc6_.getSku()]["DIFF_" + _loc3_] + _loc5_;
                  }
                  else
                  {
                     smRaidScoresSP[_loc6_.getSku()]["DIFF_" + _loc3_] = _loc5_;
                  }
               }
            }
            if(InstanceMng.getCurrentScreen() is FSRaidsScreen)
            {
               FSRaidsScreen(InstanceMng.getCurrentScreen()).refreshBossHP();
            }
         }
      }
      
      public function getRaidPointsByPlayerRanking(param1:String, param2:int, param3:int) : int
      {
         var _loc4_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:Array = null;
         var _loc9_:Object = null;
         var _loc10_:Array = null;
         var _loc11_:Object = null;
         var _loc5_:int = -1;
         var _loc6_:int = int(param1.split("raid_")[1]);
         param3 = param3 > 10 ? 11 : param3;
         if(ServerConnection.smServerRaidsMPRewardsDefs != null)
         {
            _loc7_ = ServerConnection.smServerRaidsMPRewardsDefs[_loc6_];
            _loc8_ = _loc7_ != null && _loc7_.hasOwnProperty("Difficulty") ? _loc7_["Difficulty"] : null;
            if(_loc8_ != null && _loc8_.length > 0)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc8_.length)
               {
                  if(_loc8_[_loc4_]["difficulty"] == param2)
                  {
                     _loc9_ = _loc8_[_loc4_];
                     break;
                  }
                  _loc4_++;
               }
            }
            if(_loc9_ != null)
            {
               _loc10_ = _loc9_.hasOwnProperty("positions") ? _loc9_["positions"] : null;
               if((Boolean(_loc10_)) && _loc10_.length > 0)
               {
                  _loc4_ = 0;
                  while(_loc4_ < _loc10_.length)
                  {
                     if(_loc10_[_loc4_]["position"] == param3)
                     {
                        return _loc10_[_loc4_]["raidPoints"];
                     }
                     _loc4_++;
                  }
               }
            }
         }
         return _loc5_;
      }
   }
}

