package com.fs.tcgengine.controller
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.rules.PacksDefMng;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.DungeonDef;
   import com.fs.tcgengine.model.rules.DungeonLevelDef;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.model.rules.RewardDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.screens.FSDungeonsScreen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.misc.RewardsEffect;
   import flash.utils.Dictionary;
   import mx.utils.ObjectUtil;
   
   public class DungeonsMng
   {
      
      public static const DUNGEON_DIFFICULTY_EASY:int = 0;
      
      public static const DUNGEON_DIFFICULTY_MEDIUM:int = 1;
      
      public static const DUNGEON_DIFFICULTY_HARD:int = 2;
      
      public static const DUNGEON_DIFFICULTY_EXPERT:int = 3;
      
      private var mCurrentDungeonDef:DungeonDef;
      
      private var mCurrentDungeonDifficulty:int;
      
      private var mCurrentDungeonLevelSku:String;
      
      private var mCurrentLevelIndex:int;
      
      private var mLevels:Dictionary;
      
      private var mRewardsToClaim:Dictionary;
      
      private var mLastPlayerHP:int;
      
      private var mTestObjectRarities:Dictionary;
      
      public function DungeonsMng()
      {
         super();
      }
      
      public function setCurrentDungeonDef(param1:DungeonDef) : void
      {
         this.mCurrentDungeonDef = param1;
      }
      
      public function setCurrentDungeonDifficulty(param1:int) : void
      {
         this.mCurrentDungeonDifficulty = param1;
      }
      
      public function onDungeonStart(param1:DungeonDef, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:LevelDef = null;
         var _loc5_:int = 0;
         var _loc6_:UserData = null;
         this.mTestObjectRarities = null;
         this.mRewardsToClaim = null;
         this.mLevels = null;
         this.mLastPlayerHP = -1;
         this.mCurrentDungeonDef = param1;
         this.mCurrentDungeonDifficulty = param2;
         if(Boolean(this.mCurrentDungeonDef) && Boolean(InstanceMng.getCurrentScreen()))
         {
            if(Config.getConfig().hasQuests())
            {
               InstanceMng.getQuestsMng().addActionPerformed(QuestsMng.TARGET_TYPE_START_DUNGEON,1,true,null,null,this.mCurrentDungeonDef.getSku(),this.mCurrentDungeonDifficulty);
            }
            this.initLevelsToComplete();
            this.mCurrentLevelIndex = this.mCurrentDungeonDef.getLevelsByDifficultyIndex(this.mCurrentDungeonDifficulty) ? int(this.mCurrentDungeonDef.getLevelsByDifficultyIndex(this.mCurrentDungeonDifficulty)[0]) : -1;
            this.updateCurrentDungeonLevelSku();
            InstanceMng.getCurrentScreen().startBattle(this.mCurrentDungeonLevelSku,false,true);
            FSTracker.trackMiscAction(FSTracker.CATEGORY_DUNGEONS,FSTracker.ACTION_DUNGEON_STARTED,{
               "dungeon":this.mCurrentDungeonDef.getIndex(),
               "difficulty":this.mCurrentDungeonDifficulty
            });
            _loc4_ = DungeonLevelDef(InstanceMng.getDungeonLevelsDefMng().getDefBySku(this.mCurrentDungeonLevelSku));
            _loc5_ = _loc4_ ? _loc4_.getHP() : -1;
            InstanceMng.getServerConnection().sendDungeonLevelAttempt(this.mCurrentDungeonLevelSku,this.mCurrentDungeonDef.getSku(),this.mCurrentDungeonDifficulty,false,true,false);
            FSTracker.trackMiscAction(FSTracker.CATEGORY_DUNGEON_LEVELS,FSTracker.ACTION_DUNGEON_LEVEL_STARTED,{
               "level":this.mCurrentLevelIndex,
               "hp":_loc5_
            });
            FSTracker.trackFirebaseEvent("DUNGEON_STARTED");
            if(this.mCurrentDungeonDifficulty == DUNGEON_DIFFICULTY_HARD)
            {
               _loc6_ = Utils.getOwnerUserData();
               if(_loc6_)
               {
                  _loc6_.increaseDungeonsPlayed();
                  _loc6_.increaseDungeonsLost();
                  if(InstanceMng.getUserDataMng())
                  {
                     InstanceMng.getUserDataMng().persistenceSaveData();
                  }
               }
            }
         }
      }
      
      private function initLevelsToComplete() : void
      {
         var _loc2_:int = 0;
         if(this.mLevels == null)
         {
            this.mLevels = new Dictionary(true);
         }
         var _loc1_:Array = this.mCurrentDungeonDef.getLevelsByDifficultyIndex(this.mCurrentDungeonDifficulty);
         if(_loc1_)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc1_.length)
            {
               this.mLevels[_loc1_[_loc2_]] = 0;
               _loc2_++;
            }
         }
      }
      
      private function updateCurrentDungeonLevelSku() : void
      {
         var _loc1_:Array = DictionaryUtils.getKeys(this.mLevels);
         if(_loc1_)
         {
            _loc1_.sort();
         }
         var _loc2_:DungeonLevelDef = DungeonLevelDef(InstanceMng.getDungeonLevelsDefMng().getLevelDefByLevelIndex(this.mCurrentLevelIndex));
         this.mCurrentDungeonLevelSku = _loc2_ != null ? _loc2_.getSku() : null;
      }
      
      public function getCurrentDungeonDef() : DungeonDef
      {
         return this.mCurrentDungeonDef;
      }
      
      public function getCurrentDungeonDifficulty() : int
      {
         return this.mCurrentDungeonDifficulty;
      }
      
      public function getRewardsForCurrentDungeonDifficulty() : Array
      {
         var _loc1_:Array = null;
         var _loc2_:Array = this.mCurrentDungeonDef.getLevelsByDifficultyIndex(this.mCurrentDungeonDifficulty);
         if(_loc2_)
         {
            _loc1_ = _loc2_[this.mCurrentLevelIndex];
         }
         return _loc1_;
      }
      
      public function ownerHasToReadHP() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:Array = this.mCurrentDungeonDef.getLevelsByDifficultyIndex(this.mCurrentDungeonDifficulty);
         if(_loc2_)
         {
            _loc1_ = this.mCurrentLevelIndex == _loc2_[0];
         }
         return _loc1_;
      }
      
      public function getCurrentDungeonLevelCards() : Dictionary
      {
         var _loc1_:Dictionary = null;
         var _loc2_:DungeonLevelDef = null;
         var _loc3_:Array = this.mCurrentDungeonDef.getLevelsByDifficultyIndex(this.mCurrentDungeonDifficulty);
         if(_loc3_)
         {
            _loc2_ = DungeonLevelDef(InstanceMng.getDungeonLevelsDefMng().getLevelDefByLevelIndex(this.mCurrentLevelIndex));
            _loc1_ = _loc2_.getPlayerCards();
         }
         return _loc1_;
      }
      
      public function getCurrentLevelsStatus() : Dictionary
      {
         return this.mLevels;
      }
      
      public function onDungeonLevelFailed(param1:LevelDef = null, param2:int = -1) : void
      {
         if(this.mLevels)
         {
            this.mLastPlayerHP = InstanceMng.getBattleEngine().getOwnerBattleInfo().getHP();
            this.mLevels[this.mCurrentLevelIndex] = -1;
            FSTracker.trackMiscAction(FSTracker.CATEGORY_DUNGEON_LEVELS,FSTracker.ACTION_FAILED,{
               "level":this.mCurrentLevelIndex,
               "hp":this.mLastPlayerHP
            });
            InstanceMng.getPopupMng().openDungeonLevelFailedPopup();
         }
      }
      
      public function onDungeonLevelCompleted() : void
      {
         var _loc1_:Object = null;
         var _loc2_:DungeonLevelDef = null;
         var _loc3_:Boolean = false;
         var _loc4_:Array = null;
         this.mLastPlayerHP = Boolean(InstanceMng.getBattleEngine()) && Boolean(InstanceMng.getBattleEngine().getOwnerBattleInfo()) ? InstanceMng.getBattleEngine().getOwnerBattleInfo().getHP() : -1;
         FSTracker.trackMiscAction(FSTracker.CATEGORY_DUNGEON_LEVELS,FSTracker.ACTION_DUNGEON_LEVEL_FINISHED,{
            "level":this.mCurrentLevelIndex,
            "hp":this.mLastPlayerHP
         });
         if(this.mLevels)
         {
            this.mLastPlayerHP = InstanceMng.getBattleEngine().getOwnerBattleInfo().getHP();
            this.mLevels[this.mCurrentLevelIndex] = 1;
            _loc1_ = this.updateRewardsToClaimOnLevelCompleted();
            _loc2_ = DungeonLevelDef(InstanceMng.getDungeonLevelsDefMng().getDefBySku(this.mCurrentDungeonLevelSku));
            _loc3_ = _loc2_ ? _loc2_.isFirstDungeonLevel() : false;
            _loc4_ = this.mCurrentDungeonDef.getLevelsByDifficultyIndex(this.mCurrentDungeonDifficulty);
            if(_loc4_)
            {
               if(this.mCurrentLevelIndex < _loc4_[_loc4_.length - 1])
               {
                  InstanceMng.getPopupMng().openDungeonLevelCompletedPopup(_loc1_);
                  InstanceMng.getServerConnection().sendDungeonLevelAttempt(this.mCurrentDungeonLevelSku,this.mCurrentDungeonDef.getSku(),this.mCurrentDungeonDifficulty,true,_loc3_,false);
               }
               else
               {
                  this.onAllDungeonLevelsCompleted();
                  InstanceMng.getServerConnection().sendDungeonLevelAttempt(this.mCurrentDungeonLevelSku,this.mCurrentDungeonDef.getSku(),this.mCurrentDungeonDifficulty,true,_loc3_,true);
               }
            }
         }
      }
      
      public function isPlayingLastDungeonLevel() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:Array = this.mCurrentDungeonDef.getLevelsByDifficultyIndex(this.mCurrentDungeonDifficulty);
         if(_loc2_)
         {
            return this.mCurrentLevelIndex == _loc2_[_loc2_.length - 1];
         }
         return _loc1_;
      }
      
      public function hasFinishedAllLevels() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:Array = this.mCurrentDungeonDef.getLevelsByDifficultyIndex(this.mCurrentDungeonDifficulty);
         if(_loc2_)
         {
            if(this.mCurrentLevelIndex < _loc2_[_loc2_.length - 1])
            {
               _loc1_ = false;
            }
            else
            {
               _loc1_ = this.mLevels[this.mCurrentLevelIndex] == 1;
            }
         }
         return _loc1_;
      }
      
      public function getVirtualLevelIndex() : int
      {
         var _loc3_:int = 0;
         var _loc1_:int = 1;
         var _loc2_:Array = this.mCurrentDungeonDef.getLevelsByDifficultyIndex(this.mCurrentDungeonDifficulty);
         if(_loc2_)
         {
            _loc3_ = int(_loc2_[0]);
            _loc1_ = this.mCurrentLevelIndex - _loc3_ + 1;
         }
         return _loc1_;
      }
      
      public function getCurrentLevelIndex() : int
      {
         return this.mCurrentLevelIndex;
      }
      
      private function updateRewardsToClaimOnLevelCompleted(param1:Boolean = false) : Object
      {
         var _loc2_:Object = this.calculateRewardsOnLevelCompleted(param1);
         if(this.mRewardsToClaim == null)
         {
            this.mRewardsToClaim = new Dictionary(true);
         }
         this.mRewardsToClaim[this.mCurrentLevelIndex] = _loc2_;
         return _loc2_;
      }
      
      public function loadNextDungeonLevel() : void
      {
         var _loc2_:Boolean = false;
         var _loc1_:Array = this.mCurrentDungeonDef.getLevelsByDifficultyIndex(this.mCurrentDungeonDifficulty);
         if(Boolean(_loc1_) && InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            if(this.mCurrentLevelIndex < _loc1_[_loc1_.length - 1])
            {
               ++this.mCurrentLevelIndex;
               _loc2_ = this.mCurrentLevelIndex == _loc1_[_loc1_.length - 1];
               this.updateCurrentDungeonLevelSku();
               FSBattleScreen(InstanceMng.getCurrentScreen()).loadNextDungeonLevel(this.mCurrentDungeonLevelSku);
               InstanceMng.getServerConnection().sendDungeonLevelAttempt(this.mCurrentDungeonLevelSku,this.mCurrentDungeonDef.getSku(),this.mCurrentDungeonDifficulty,false,false,_loc2_);
               FSTracker.trackMiscAction(FSTracker.CATEGORY_DUNGEON_LEVELS,FSTracker.ACTION_DUNGEON_LEVEL_STARTED,{
                  "level":this.mCurrentLevelIndex,
                  "hp":this.mLastPlayerHP
               });
            }
         }
      }
      
      private function onAllDungeonLevelsCompleted() : void
      {
         var _loc5_:Number = NaN;
         var _loc1_:UserData = Utils.getOwnerUserData();
         if(Config.HAS_GUILDS && _loc1_.hasGuild())
         {
            _loc5_ = InstanceMng.getGuildsMng().getDungeonCompletedPointsWon(this.mCurrentDungeonDifficulty);
            _loc1_.addGuildWeeklyDungeonScore(_loc5_);
         }
         if(this.mCurrentDungeonDifficulty == DUNGEON_DIFFICULTY_HARD)
         {
            _loc1_.increaseDungeonsWon();
            _loc1_.decreaseDungeonsLost();
            InstanceMng.getServerConnection().addScoreToLeaderboard("PLAYER_DUNGEONS",1);
         }
         if(Config.getConfig().hasQuests())
         {
            InstanceMng.getQuestsMng().addActionPerformed(QuestsMng.TARGET_TYPE_WIN_DUNGEON,1,false,[QuestsMng.TARGET_EXTRA_INFO_HP_LEFT + ":" + this.mLastPlayerHP],"",this.mCurrentDungeonDef.getSku(),this.mCurrentDungeonDifficulty);
         }
         InstanceMng.getUserDataMng().persistenceSaveData();
         FSTracker.trackMiscAction(FSTracker.CATEGORY_DUNGEONS,FSTracker.ACTION_DUNGEON_FINISHED,{"dungeon":this.mCurrentDungeonDef.getIndex()});
         var _loc2_:Object = InstanceMng.getDungeonsMng().getDungeonRewardsToClaimSummary();
         var _loc3_:DungeonLevelDef = Boolean(InstanceMng.getBattleEngine()) && Boolean(InstanceMng.getBattleEngine().getLevelDef()) ? DungeonLevelDef(InstanceMng.getBattleEngine().getLevelDef()) : null;
         var _loc4_:RewardsEffect = new RewardsEffect(PacksDefMng.PACK_DUNGEONS,_loc2_,true,_loc3_.getChestBG());
         _loc4_.alpha = 0;
         SpecialFX.tweenToAlpha(_loc4_,1,0.3,0);
         InstanceMng.getCurrentScreen().addChild(_loc4_);
         InstanceMng.getGuildsMng().createGuildDungeonCompletedEvent(this.mCurrentDungeonDifficulty);
      }
      
      private function calculateRewardsOnLevelCompleted(param1:Boolean = false) : Object
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:FSNumber = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         if(this.mCurrentDungeonDef)
         {
            _loc3_ = DungeonLevelDef(InstanceMng.getDungeonLevelsDefMng().getDefBySku(this.mCurrentDungeonLevelSku)).getDungeonRewardsSummary();
            if(_loc3_)
            {
               _loc4_ = int(_loc3_.totalRewards);
               _loc5_ = 0;
               if(_loc4_ > 0)
               {
                  _loc2_ = new Object();
                  if(_loc3_.hasGold)
                  {
                     _loc2_.hasGold = true;
                     _loc6_ = new FSNumber(Utils.randomInt(_loc3_.minGold,_loc3_.maxGold));
                     _loc2_.gold = _loc6_.value;
                     if(!param1)
                     {
                        InstanceMng.getUserDataMng().getOwnerUserData().addGold(_loc6_.value);
                     }
                     _loc5_++;
                     if(!param1)
                     {
                        FSTracker.trackMiscAction(FSTracker.CATEGORY_DUNGEON_LEVELS,FSTracker.ACTION_DUNGEON_LEVEL_GOLD_WON,{"gold":_loc6_.value});
                     }
                  }
                  if(_loc3_.hasCards)
                  {
                     _loc7_ = int(_loc3_.maxCards);
                     _loc2_.cards = _loc7_;
                     _loc2_.hasCards = _loc7_ > 0;
                     _loc5_ += _loc7_;
                  }
                  if(_loc3_.hasPacks)
                  {
                     _loc8_ = int(_loc3_.maxPacks);
                     _loc2_.packs = _loc8_;
                     _loc2_.hasPacks = _loc8_ > 0;
                     _loc5_ += _loc8_;
                  }
                  if(_loc3_.hasPortraits)
                  {
                     _loc9_ = int(_loc3_.maxPortraits);
                     _loc2_.portraits = _loc9_;
                     _loc2_.hasPortraits = _loc9_ > 0;
                     _loc5_ += _loc9_;
                  }
                  if(_loc3_.hasSkins)
                  {
                     _loc10_ = int(_loc3_.maxSkins);
                     _loc2_.skins = _loc10_;
                     _loc2_.hasSkins = _loc10_ > 0;
                     _loc5_ += _loc10_;
                  }
                  _loc2_.totalRewards = _loc5_;
               }
            }
         }
         return _loc2_;
      }
      
      public function getLastPlayerHP() : int
      {
         return this.mLastPlayerHP;
      }
      
      public function getAllRewardsAchieved() : Dictionary
      {
         return this.mRewardsToClaim;
      }
      
      public function testRewards() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc5_:CardDef = null;
         var _loc6_:String = null;
         var _loc7_:Array = null;
         this.mTestObjectRarities = null;
         this.mRewardsToClaim = null;
         this.mLevels = null;
         if(InstanceMng.getCurrentScreen() is FSDungeonsScreen)
         {
            this.mCurrentDungeonDef = FSDungeonsScreen(InstanceMng.getCurrentScreen()).getSelectedDungeonDef();
            this.mCurrentDungeonDifficulty = FSDungeonsScreen(InstanceMng.getCurrentScreen()).getSelectedDifficulty();
            _loc1_ = 0;
            while(_loc1_ < 100)
            {
               this.initLevelsToComplete();
               this.mCurrentLevelIndex = this.mCurrentDungeonDef.getLevelsByDifficultyIndex(this.mCurrentDungeonDifficulty)[0];
               this.updateCurrentDungeonLevelSku();
               FSDebug.debugTrace("j: " + _loc1_);
               _loc3_ = this.mCurrentDungeonDef.getLevelsByDifficultyIndex(this.mCurrentDungeonDifficulty);
               if(_loc3_)
               {
                  _loc2_ = 0;
                  while(_loc2_ < _loc3_.length)
                  {
                     if(this.mCurrentLevelIndex < _loc3_[_loc3_.length - 1])
                     {
                        this.mLevels[this.mCurrentLevelIndex] = 1;
                        this.mCurrentLevelIndex += 1;
                        this.updateCurrentDungeonLevelSku();
                        this.updateRewardsToClaimOnLevelCompleted(true);
                     }
                     _loc2_++;
                  }
               }
               _loc4_ = this.getDungeonRewardsToClaimSummary();
               if(this.mTestObjectRarities == null)
               {
                  this.mTestObjectRarities = new Dictionary(true);
               }
               _loc7_ = _loc4_.hasCards ? String(_loc4_.cards).split(",") : null;
               if(_loc7_)
               {
                  for each(_loc6_ in _loc7_)
                  {
                     _loc5_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc6_));
                     if(this.mTestObjectRarities[_loc5_.getCardRarity()] == null)
                     {
                        this.mTestObjectRarities[_loc5_.getCardRarity()] = 1;
                     }
                     else
                     {
                        this.mTestObjectRarities[_loc5_.getCardRarity()] = this.mTestObjectRarities[_loc5_.getCardRarity()] + 1;
                     }
                  }
               }
               _loc1_++;
            }
            FSDebug.debugTrace("\n Rarities \n " + ObjectUtil.toString(this.mTestObjectRarities));
         }
      }
      
      public function getDungeonRewardsToClaimSummary() : Object
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:DungeonLevelDef = null;
         var _loc9_:RewardDef = null;
         var _loc10_:Dictionary = null;
         var _loc1_:Object = null;
         if(this.mRewardsToClaim)
         {
            _loc2_ = DictionaryUtils.getKeys(this.mLevels);
            if(_loc2_)
            {
               _loc2_.sort();
               _loc5_ = 0;
               _loc3_ = 0;
               while(_loc3_ < _loc2_.length)
               {
                  if(this.mLevels[_loc2_[_loc3_]] == 1)
                  {
                     _loc8_ = DungeonLevelDef(InstanceMng.getDungeonLevelsDefMng().getLevelDefByLevelIndex(_loc2_[_loc3_]));
                     _loc9_ = _loc8_ ? RewardDef(InstanceMng.getRewardsDefMng().getDefBySku(_loc8_.getRewardSku(UserData.WORLD_DEFAULT))) : null;
                     if(_loc9_)
                     {
                        _loc4_ = this.mRewardsToClaim[_loc2_[_loc3_]];
                        if(_loc4_)
                        {
                           if(_loc4_.hasGold)
                           {
                              if(_loc1_ == null)
                              {
                                 _loc1_ = new Object();
                              }
                              _loc1_.hasGold = true;
                              _loc1_.gold = _loc1_.gold ? _loc1_.gold + _loc4_.gold : _loc4_.gold;
                           }
                           if(_loc4_.hasCards)
                           {
                              _loc7_ = "";
                              if(_loc1_ == null)
                              {
                                 _loc1_ = new Object();
                              }
                              _loc1_.hasCards = true;
                              _loc6_ = 0;
                              while(_loc6_ < _loc4_.cards)
                              {
                                 _loc10_ = this.rollCards(_loc9_);
                                 if(_loc10_)
                                 {
                                    for each(_loc7_ in _loc10_)
                                    {
                                       _loc1_.cards = _loc1_.cards ? _loc1_.cards + "," + _loc7_ : _loc7_;
                                    }
                                 }
                                 _loc6_++;
                              }
                           }
                           if(_loc4_.hasPacks)
                           {
                              if(_loc1_ == null)
                              {
                                 _loc1_ = new Object();
                              }
                              if(_loc4_.packs != null)
                              {
                                 _loc1_.hasPacks = true;
                                 _loc6_ = 0;
                                 while(_loc6_ < _loc4_.packs)
                                 {
                                    _loc1_.packs = _loc1_.packs ? _loc1_.packs + "," + this.rollPacks(_loc9_) : this.rollPacks(_loc9_);
                                    _loc6_++;
                                 }
                              }
                           }
                           if(_loc4_.hasPortraits)
                           {
                              if(_loc1_ == null)
                              {
                                 _loc1_ = new Object();
                              }
                              if(_loc4_.portraits != null)
                              {
                                 _loc1_.hasPortraits = true;
                                 _loc6_ = 0;
                                 while(_loc6_ < _loc4_.portraits)
                                 {
                                    _loc1_.portraits = _loc1_.portraits ? _loc1_.portraits + "," + this.rollPortraits(_loc9_) : this.rollPortraits(_loc9_);
                                    _loc6_++;
                                 }
                              }
                           }
                           if(_loc4_.hasSkins)
                           {
                              if(_loc1_ == null)
                              {
                                 _loc1_ = new Object();
                              }
                              if(_loc4_.skins != null)
                              {
                                 _loc1_.hasSkins = true;
                                 _loc6_ = 0;
                                 while(_loc6_ < _loc4_.skins)
                                 {
                                    _loc1_.skins = _loc1_.skins ? _loc1_.skins + "," + _loc9_.getSkinSku() : _loc9_.getSkinSku();
                                    _loc6_++;
                                 }
                              }
                           }
                        }
                     }
                  }
                  _loc3_++;
               }
               if(Boolean(_loc1_ != null) && Boolean(_loc1_.hasCards) && Boolean(_loc1_.cards))
               {
                  _loc1_.cards = DictionaryUtils.sortCardArrByCardValue(String(_loc1_.cards).split(","));
               }
            }
         }
         else
         {
            FSDebug.debugTrace("There are no rewards to claim");
         }
         return _loc1_;
      }
      
      public function hasCompletedAllDungeonLevels() : Boolean
      {
         var _loc2_:Array = null;
         var _loc1_:Boolean = false;
         if(Boolean(this.mCurrentDungeonDef) && this.mCurrentDungeonDifficulty != -1)
         {
            _loc2_ = this.mCurrentDungeonDef.getLevelsByDifficultyIndex(this.mCurrentDungeonDifficulty);
            if(_loc2_)
            {
               _loc1_ = this.mCurrentLevelIndex == _loc2_[_loc2_.length - 1];
            }
         }
         return _loc1_;
      }
      
      public function resetDungeonsMng(param1:Boolean = true, param2:Boolean = true) : void
      {
         this.mCurrentDungeonDef = null;
         this.mCurrentDungeonDifficulty = -1;
         this.mCurrentDungeonLevelSku = "";
         this.mCurrentLevelIndex = -1;
         this.mLevels = null;
         this.mRewardsToClaim = null;
         this.mLastPlayerHP = -1;
         if(Root.smBattleData)
         {
            Root.smBattleData.isDungeon = false;
         }
         if(param2 && InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            FSBattleScreen(InstanceMng.getCurrentScreen()).showDungeonsScreen();
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
      
      private function rollPacks(param1:RewardDef) : String
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
            _loc10_++;
         }
         var _loc11_:Number = Utils.randomInt(0,99);
         return _loc6_[_loc11_];
      }
      
      private function rollPortraits(param1:RewardDef) : String
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc7_:int = 0;
         var _loc10_:int = 0;
         var _loc2_:String = "";
         var _loc3_:Dictionary = param1.getPortraitChances();
         var _loc6_:Dictionary = new Dictionary(true);
         var _loc8_:int = 0;
         var _loc9_:Array = DictionaryUtils.getKeys(_loc3_);
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
            _loc10_++;
         }
         var _loc11_:Number = Utils.randomInt(0,99);
         return _loc6_[_loc11_];
      }
   }
}

