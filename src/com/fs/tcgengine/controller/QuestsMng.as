package com.fs.tcgengine.controller
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.rules.QuestsDefMng;
   import com.fs.tcgengine.model.quests.Quest;
   import com.fs.tcgengine.model.rules.JobDef;
   import com.fs.tcgengine.model.rules.PackDef;
   import com.fs.tcgengine.model.rules.QuestDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.anims.misc.PackAnimation;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.components.popups.quests.QuestSlot;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.misc.RewardSlot;
   import com.fs.tcgengine.view.popups.quests.PopupBattlePass;
   import com.fs.tcgengine.view.popups.quests.PopupQuest;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   
   public class QuestsMng
   {
      
      public static const PROGRESS_TYPE_LOCAL:int = 0;
      
      public static const PROGRESS_TYPE_GLOBAL:int = 1;
      
      public static const TARGET_TYPE_WIN:String = "win";
      
      public static const TARGET_TYPE_PLAY:String = "play";
      
      public static const TARGET_TYPE_WIN_DUNGEON:String = "win_dungeon";
      
      public static const TARGET_TYPE_START_DUNGEON:String = "start_dungeon";
      
      public static const TARGET_TYPE_LOSS:String = "loss";
      
      public static const TARGET_TYPE_COMMUNITY_QUEST:String = "invite_global";
      
      public static const TARGET_TYPE_SHARE_GAME_QUEST:String = "invite_friend";
      
      public static const TARGET_TYPE_EDIT_SPEED:String = "edit_speed";
      
      public static const TARGET_TYPE_USE_RESHUFFLE:String = "use_reshuffle";
      
      public static const TARGET_TYPE_START_RAID:String = "start_raid";
      
      public static const TARGET_TYPE_WIN_RAID:String = "win_raid";
      
      public static const TARGET_TYPE_START_RAID_SP:String = "start_raid_single";
      
      public static const TARGET_TYPE_WIN_RAID_SP:String = "win_raid_single";
      
      public static const TARGET_TYPE_START_RAID_MP:String = "start_raid_multi";
      
      public static const TARGET_TYPE_WIN_RAID_MP:String = "win_raid_multi";
      
      public static const TARGET_TYPE_JOIN_GUILD:String = "join_guild";
      
      public static const TARGET_TYPE_UNFOLD_CARD:String = "unfold_card";
      
      public static const TARGET_TYPE_UNFOLD_PACK:String = "unfold_pack";
      
      public static const TARGET_TYPE_OBTAIN:String = "obtain";
      
      public static const TARGET_CARD_CRAFT:String = "craft";
      
      public static const TARGET_CARD_FUSION:String = "fusion";
      
      public static const TARGET_CARD_ASPECT:String = "aspect";
      
      public static const TARGET_USE_RAID_TICKET:String = "useRaidTicket";
      
      public static const TARGET_TYPE_DEAL_DAMAGE_TO_OPPONENT:String = "deal_damage_to_opponent";
      
      public static const TARGET_TYPE_DEAL_DAMAGE_TO_OPPONENT_TURN:String = "deal_damage_to_opponent_turn";
      
      public static const TARGET_TYPE_DEAL_DAMAGE_TO_DUNGEON_OPPONENT:String = "deal_damage_to_dungeon_opponent";
      
      public static const TARGET_TYPE_DEAL_DAMAGE_TO_DUNGEON_OPPONENT_TURN:String = "deal_damage_to_dungeon_opponent_turn";
      
      public static const TARGET_TYPE_DEAL_DAMAGE_TO_RAID_OPPONENT:String = "deal_damage_to_raid_opponent";
      
      public static const TARGET_TYPE_DEAL_DAMAGE_TO_RAID_OPPONENT_TURN:String = "deal_damage_to_raid_opponent_turn";
      
      public static const TARGET_PLAY_CARD:String = "play_card";
      
      public static const TARGET_PROMOTE_CARD:String = "promote_card";
      
      public static const TARGET_DESTROY_CARD:String = "destroy_card";
      
      public static const TARGET_PLAY_CARD_DUNGEON:String = "play_card_dungeon";
      
      public static const TARGET_PROMOTE_CARD_DUNGEON:String = "promote_card_dungeon";
      
      public static const TARGET_DESTROY_CARD_DUNGEON:String = "destroy_card_dungeon";
      
      public static const TARGET_PLAY_CARD_RAID:String = "play_card_raid";
      
      public static const TARGET_PROMOTE_CARD_RAID:String = "promote_card_raid";
      
      public static const TARGET_DESTROY_CARD_RAID:String = "destroy_card_raid";
      
      public static const TARGET_TYPE_AUCTION_CREATED:String = "auction_created";
      
      public static const TARGET_TYPE_AUCTION_BID:String = "auction_bid";
      
      public static const TARGET_TYPE_AUCTION_WON:String = "auction_won";
      
      public static const TARGET_TYPE_AUCTION_SUCCESS:String = "auction_success";
      
      public static const TARGET_EXTRA_INFO_HP_LEFT:String = "hpLeft";
      
      public static const TARGET_EXTRA_INFO_BOSS_HP_LESSTHAN:String = "bossHp";
      
      public static const TARGET_EXTRA_INFO_LEVEL_HIGHER:String = "levelHigher";
      
      public static const TARGET_CARD_RARITY:String = "rarity";
      
      public static const TARGET_CARD_CATEGORY:String = "category";
      
      public static const TARGET_CARD_FACTION:String = "faction";
      
      public static const TARGET_CARD_SUBCATEGORY:String = "subcategory";
      
      public static const TARGET_CARD_EDITION:String = "edition";
      
      public static const TARGET_CARD_ONLY_RARITY:String = "only_rarity";
      
      public static const TARGET_CARD_ONLY_CATEGORY:String = "only_category";
      
      public static const TARGET_CARD_ONLY_FACTION:String = "only_faction";
      
      public static const TARGET_CARD_ONLY_SUBCATEGORY:String = "only_subcategory";
      
      public static const TARGET_PACK_SKU:String = "sku";
      
      public static const TARGET_CURRENCY:String = "currency";
      
      public static const TARGET_PVP_LEVEL:String = "pvp";
      
      public static const TARGET_EXTRA_INFO_3STARS:String = "3stars";
      
      public static const TARGET_EXTRA_INFO_CARDS_UNDEFEATED:String = "cardsUndefeated";
      
      public static const TARGET_EXTRA_INFO_HP_INTACT:String = "hpIntact";
      
      public static const TARGET_EXTRA_INFO_IS_MULTI:String = "isMulti";
      
      public static const TARGET_DAILY_QUEST:String = "daily_quests";
      
      public static const RESET_HOUR:int = 9;
      
      private var mQuestsCompletedCatalog:Dictionary;
      
      private var mQuestsInProgressVector:Vector.<Quest>;
      
      private var mQuestsInitialized:Boolean = false;
      
      private var mConsecutiveQuestsTemporaryProgress:Array;
      
      public function QuestsMng()
      {
         super();
      }
      
      public function init(param1:Boolean = false) : void
      {
         if(!this.mQuestsInitialized)
         {
            if(InstanceMng.getUserDataMng().getOwnerUserData())
            {
               if(param1)
               {
                  InstanceMng.getUserDataMng().getOwnerUserData().godModeResetQuests(false);
               }
               this.refreshQuestsData();
            }
            this.getQuestsUnlocked();
            this.getQuestsUnlocked(true);
            this.checkIfAnyQuestIsCompleted(false,false);
            this.checkIfAnyQuestIsCompleted(true,false);
            this.mQuestsInitialized = true;
         }
      }
      
      private function refreshQuestsData() : void
      {
         var _loc1_:Quest = null;
         var _loc2_:QuestDef = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         this.mQuestsCompletedCatalog = InstanceMng.getUserDataMng().getOwnerUserData().getQuestsCompleted();
         var _loc5_:Dictionary = InstanceMng.getUserDataMng().getOwnerUserData().getQuestsProgress();
         if(_loc5_)
         {
            _loc3_ = DictionaryUtils.getKeys(_loc5_);
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc2_ = QuestDef(InstanceMng.getQuestsDefMng().getDefBySku(_loc3_[_loc4_]));
               this.initQuestInProgress(_loc3_[_loc4_]);
               _loc4_++;
            }
         }
      }
      
      private function getQuestsAvailable(param1:Boolean = false) : Vector.<Quest>
      {
         var _loc3_:int = 0;
         var _loc4_:Quest = null;
         var _loc5_:String = null;
         var _loc6_:QuestDef = null;
         var _loc7_:Array = null;
         var _loc2_:Vector.<Quest> = new Vector.<Quest>();
         if(this.mQuestsCompletedCatalog != null)
         {
            _loc7_ = DictionaryUtils.getKeys(this.mQuestsCompletedCatalog);
            if(_loc7_)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc7_.length)
               {
                  _loc6_ = QuestDef(InstanceMng.getQuestsDefMng().getDefBySku(_loc7_[_loc3_]));
                  if(_loc6_)
                  {
                     if(!Config.getConfig().hasBattlePass() || !param1 && !_loc6_.isBattlePassQuest() || param1 && _loc6_.isBattlePassQuest() && _loc6_.isBattlePassQuestEligibleBySeason())
                     {
                        _loc4_ = new Quest(_loc6_);
                        _loc2_.push(_loc4_);
                     }
                  }
                  _loc3_++;
               }
            }
         }
         if(this.mQuestsInProgressVector != null)
         {
            _loc3_ = 0;
            while(_loc3_ < this.mQuestsInProgressVector.length)
            {
               if(this.mQuestsInProgressVector[_loc3_].getDef())
               {
                  if(!Config.getConfig().hasBattlePass() || !param1 && !this.mQuestsInProgressVector[_loc3_].getDef().isBattlePassQuest() || param1 && this.mQuestsInProgressVector[_loc3_].getDef().isBattlePassQuest() && this.mQuestsInProgressVector[_loc3_].getDef().isBattlePassQuestEligibleBySeason())
                  {
                     _loc2_.push(this.mQuestsInProgressVector[_loc3_]);
                  }
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      public function getQuestsUnlocked(param1:Boolean = false) : Vector.<Quest>
      {
         var _loc6_:Quest = null;
         var _loc7_:QuestDef = null;
         var _loc8_:String = null;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         var _loc14_:int = 0;
         var _loc2_:Vector.<Quest> = new Vector.<Quest>();
         var _loc3_:Vector.<Quest> = new Vector.<Quest>();
         var _loc4_:Vector.<Quest> = new Vector.<Quest>();
         var _loc5_:UserData = Utils.getOwnerUserData();
         var _loc11_:Boolean = false;
         var _loc12_:Vector.<Quest> = this.getQuestsAvailable(param1);
         if(Boolean(_loc5_) && Boolean(_loc12_ != null) && _loc12_.length > 0)
         {
            _loc14_ = 0;
            while(_loc14_ < _loc12_.length)
            {
               if(_loc12_[_loc14_].getDef() != null)
               {
                  if(!_loc5_.isQuestAlreadyClaimed(_loc12_[_loc14_].getDef().getSku()))
                  {
                     if(_loc12_[_loc14_].isCompleted())
                     {
                        _loc2_.push(_loc12_[_loc14_]);
                     }
                     else if(_loc12_[_loc14_].isDaily())
                     {
                        _loc4_.push(_loc12_[_loc14_]);
                     }
                     else
                     {
                        _loc3_.push(_loc12_[_loc14_]);
                     }
                     _loc9_ = this.mQuestsCompletedCatalog == null || this.mQuestsCompletedCatalog != null && this.mQuestsCompletedCatalog[_loc12_[_loc14_].getDef().getSku()] == null;
                     if(_loc9_)
                     {
                        this.initQuestInProgress(_loc12_[_loc14_].getDef().getSku());
                     }
                  }
               }
               _loc14_++;
            }
         }
         var _loc13_:Dictionary = InstanceMng.getQuestsDefMng().getAllDefs();
         if(Boolean(_loc5_) && Boolean(_loc13_))
         {
            for each(_loc7_ in _loc13_)
            {
               if(_loc7_)
               {
                  _loc11_ = false;
                  _loc8_ = _loc7_.getSku();
                  _loc9_ = this.mQuestsCompletedCatalog == null || this.mQuestsCompletedCatalog != null && this.mQuestsCompletedCatalog[_loc8_] == null;
                  _loc10_ = !this.isQuestInProgress(_loc8_);
                  if(_loc9_ && _loc10_)
                  {
                     if(Boolean(_loc5_) && !_loc5_.isQuestAlreadyClaimed(_loc8_))
                     {
                        if(!Config.getConfig().hasBattlePass() || !param1 && !_loc7_.isBattlePassQuest() || param1 && _loc7_.isBattlePassQuest() && _loc7_.isBattlePassQuestEligibleBySeason())
                        {
                           _loc11_ = this.isQuestUnlocked(_loc8_);
                           if(_loc11_)
                           {
                              _loc6_ = new Quest(_loc7_);
                              if(_loc6_.isCompleted())
                              {
                                 _loc2_.push(_loc6_);
                                 this.setQuestAsCompleted(_loc6_);
                              }
                              else
                              {
                                 if(_loc6_.isDaily())
                                 {
                                    _loc4_.push(_loc6_);
                                 }
                                 else
                                 {
                                    _loc3_.push(_loc6_);
                                 }
                                 this.initQuestInProgress(_loc7_.getSku());
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
         if(_loc2_)
         {
            _loc2_.sort(DictionaryUtils.sortQuestsByDailyFirst);
         }
         if(_loc4_)
         {
            _loc4_.sort(DictionaryUtils.sortQuestsByReward);
            _loc14_ = 0;
            while(_loc14_ < _loc4_.length)
            {
               _loc2_.push(_loc4_[_loc14_]);
               _loc14_++;
            }
         }
         if(_loc3_)
         {
            _loc3_.sort(DictionaryUtils.sortQuestsByDailyFirst);
            _loc14_ = 0;
            while(_loc14_ < _loc3_.length)
            {
               _loc2_.push(_loc3_[_loc14_]);
               _loc14_++;
            }
         }
         return _loc2_;
      }
      
      public function getSeasonBPQuests() : Vector.<QuestDef>
      {
         var _loc2_:QuestDef = null;
         var _loc1_:Vector.<QuestDef> = new Vector.<QuestDef>();
         var _loc3_:Dictionary = InstanceMng.getQuestsDefMng().getAllDefs();
         if(_loc3_)
         {
            for each(_loc2_ in _loc3_)
            {
               if(_loc2_)
               {
                  if(Config.getConfig().hasBattlePass() && _loc2_.isBattlePassQuest() && _loc2_.isBattlePassQuestEligibleBySeason())
                  {
                     _loc1_.push(_loc2_);
                  }
               }
            }
         }
         return _loc1_;
      }
      
      private function isQuestUnlocked(param1:String) : Boolean
      {
         var _loc3_:Quest = null;
         var _loc4_:QuestDef = null;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc12_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc13_:UserData = Utils.getOwnerUserData();
         _loc5_ = this.mQuestsCompletedCatalog == null || this.mQuestsCompletedCatalog != null && this.mQuestsCompletedCatalog[param1] == null;
         _loc6_ = !this.isQuestInProgress(param1);
         _loc4_ = QuestDef(InstanceMng.getQuestsDefMng().getDefBySku(param1));
         _loc7_ = _loc4_.getUnlockedLevelSku();
         _loc8_ = _loc4_.getUnlockQuestSku();
         _loc9_ = _loc7_ != "";
         _loc10_ = _loc8_ != "";
         if(_loc5_ && _loc6_)
         {
            if(Boolean(_loc13_) && !_loc13_.isQuestAlreadyClaimed(param1))
            {
               if(_loc9_ && Boolean(_loc8_))
               {
                  _loc11_ = _loc13_.getCurrentLevelIndex(UserDataMng.DIFFICULTY_EASY) >= InstanceMng.getLevelsDefMng().getLevelIndexByLevelSku(_loc4_.getUnlockedLevelSku());
                  _loc12_ = _loc13_.isQuestAlreadyClaimed(_loc4_.getUnlockQuestSku());
                  _loc2_ = _loc11_ && _loc12_;
               }
               else if(_loc9_)
               {
                  _loc2_ = _loc11_ = _loc13_.getCurrentLevelIndex(UserDataMng.DIFFICULTY_EASY) >= InstanceMng.getLevelsDefMng().getLevelIndexByLevelSku(_loc4_.getUnlockedLevelSku());
               }
               else if(_loc10_)
               {
                  _loc2_ = _loc12_ = _loc13_.isQuestAlreadyClaimed(_loc4_.getUnlockQuestSku());
               }
               else
               {
                  _loc2_ = true;
               }
            }
         }
         return _loc2_;
      }
      
      public function isQuestInProgress(param1:String) : Boolean
      {
         var _loc3_:int = 0;
         var _loc2_:Boolean = false;
         if(Boolean(this.mQuestsInProgressVector) && this.mQuestsInProgressVector.length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < this.mQuestsInProgressVector.length)
            {
               if(Boolean(this.mQuestsInProgressVector && this.mQuestsInProgressVector[_loc3_]) && Boolean(this.mQuestsInProgressVector[_loc3_].getDef()) && this.mQuestsInProgressVector[_loc3_].getDef().getSku() == param1)
               {
                  _loc2_ = true;
                  break;
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      public function addActionPerformed(param1:String, param2:int, param3:Boolean = true, param4:Array = null, param5:String = null, param6:String = null, param7:int = -1, param8:String = null) : void
      {
         var _loc9_:Quest = null;
         var _loc10_:Boolean = false;
         var _loc11_:int = 0;
         var _loc12_:Vector.<Quest> = null;
         var _loc13_:UserData = null;
         var _loc14_:Boolean = false;
         var _loc15_:Boolean = false;
         if(this.mQuestsInProgressVector)
         {
            if(this.isPlayRelatedQuest(param1))
            {
               this.temporarylyStoreConsecutiveQuestsProgress(param1,param5,param6,param7,param8);
            }
            else if(this.isWinRelatedQuest(param1))
            {
               this.restoreTemporaryConsecutiveQuestsProgress();
            }
            _loc10_ = false;
            _loc11_ = 0;
            _loc12_ = Utils.createQuestsVectorCopy(this.mQuestsInProgressVector);
            _loc13_ = Utils.getOwnerUserData();
            _loc14_ = _loc13_ ? _loc13_.isBattlePassUnlocked() : false;
            _loc15_ = Config.getConfig().hasBattlePass();
            for each(_loc9_ in _loc12_)
            {
               if(!(Boolean(_loc15_ && _loc9_ && _loc9_.getDef()) && Boolean(_loc9_.getDef().isBattlePassQuest()) && !_loc14_))
               {
                  if(Boolean(_loc9_) && _loc9_.actionPerformed(param1,param2,param4,param5,param6,param7,param8))
                  {
                     FSDebug.debugTrace("Added progress in quest : " + _loc9_.getDef().getSku());
                     _loc10_ = true;
                     if(InstanceMng.getCurrentScreen() is FSBattleScreen)
                     {
                        FSBattleScreen.smFlaggedToUpdateQuestsProgress = true;
                     }
                     if(_loc9_.isCompleted(_loc11_))
                     {
                        this.setQuestAsCompleted(_loc9_);
                        setTimeout(_loc9_.showQuestCompletedPanel,_loc11_ * 0.5,_loc11_);
                        if(InstanceMng.getPopupMng().getPopupShown() != null && InstanceMng.getPopupMng().getPopupShown() is PopupQuest && param1 == TARGET_TYPE_SHARE_GAME_QUEST)
                        {
                           PopupQuest(InstanceMng.getPopupMng().getPopupShown()).onQuestsMngResetedCleanPopup();
                        }
                        _loc11_++;
                     }
                  }
               }
            }
            if(_loc10_ && param3)
            {
               InstanceMng.getUserDataMng().persistenceSaveData();
            }
         }
      }
      
      public function checkIfAnyQuestIsCompleted(param1:Boolean, param2:Boolean = false, param3:Boolean = false) : Boolean
      {
         var _loc5_:Vector.<Quest> = null;
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         var _loc9_:QuestDef = null;
         var _loc13_:Quest = null;
         var _loc4_:Boolean = false;
         var _loc6_:int = 0;
         var _loc10_:UserData = Utils.getOwnerUserData();
         if(this.mQuestsInProgressVector)
         {
            for each(_loc13_ in this.mQuestsInProgressVector)
            {
               _loc6_ = 0;
               if(_loc13_.isCompleted(_loc6_))
               {
                  _loc7_ = !param3 || param3 && !_loc10_.isQuestAlreadyClaimed(_loc13_.getDef().getSku());
                  if((_loc7_) && (!Config.getConfig().hasBattlePass() || !param1 && !_loc13_.getDef().isBattlePassQuest() || param1 && _loc13_.getDef().isBattlePassQuest()))
                  {
                     if(_loc5_ == null)
                     {
                        _loc5_ = new Vector.<Quest>();
                     }
                     _loc5_.push(_loc13_);
                     _loc6_++;
                  }
               }
            }
         }
         if(_loc5_ != null)
         {
            _loc4_ = true;
            _loc8_ = 0;
            while(_loc8_ < _loc5_.length)
            {
               this.setQuestAsCompleted(_loc5_[_loc8_]);
               _loc8_++;
            }
            if(param2)
            {
               InstanceMng.getUserDataMng().persistenceSaveData();
            }
         }
         var _loc11_:Boolean = false;
         var _loc12_:Array = this.mQuestsCompletedCatalog ? DictionaryUtils.getKeys(this.mQuestsCompletedCatalog) : null;
         if(_loc12_)
         {
            _loc8_ = 0;
            while(_loc8_ < _loc12_.length)
            {
               _loc6_ = 0;
               if(InstanceMng.getQuestsDefMng().getDefBySku(_loc12_[_loc8_]) != null)
               {
                  _loc7_ = !param3 || param3 && !_loc10_.isQuestAlreadyClaimed(_loc12_[_loc8_]);
                  _loc9_ = QuestDef(InstanceMng.getQuestsDefMng().getDefBySku(_loc12_[_loc8_]));
                  if(_loc7_ && (!Config.getConfig().hasBattlePass() || !param1 && !_loc9_.isBattlePassQuest() || param1 && _loc9_.isBattlePassQuest() && _loc9_.isBattlePassQuestEligibleBySeason()))
                  {
                     _loc11_ = true;
                  }
               }
               _loc8_++;
            }
         }
         return _loc4_ || _loc11_;
      }
      
      private function setQuestAsCompleted(param1:Quest) : void
      {
         if(param1)
         {
            if(this.mQuestsInProgressVector != null)
            {
               this.mQuestsInProgressVector.splice(this.mQuestsInProgressVector.indexOf(param1),1);
            }
            if(this.mQuestsCompletedCatalog == null)
            {
               this.mQuestsCompletedCatalog = new Dictionary(true);
            }
            if(this.mQuestsCompletedCatalog[param1.getDef().getSku()] == null)
            {
               this.mQuestsCompletedCatalog[param1.getDef().getSku()] = true;
            }
            InstanceMng.getUserDataMng().getOwnerUserData().addQuestCompleted(param1.getDef().getSku(),false);
         }
      }
      
      public function setQuestAsClaimed(param1:Quest) : void
      {
         if(param1)
         {
            if(this.mQuestsCompletedCatalog != null)
            {
               this.mQuestsCompletedCatalog[param1.getDef().getSku()] = null;
               delete this.mQuestsCompletedCatalog[param1.getDef().getSku()];
            }
            InstanceMng.getUserDataMng().getOwnerUserData().addQuestClaimed(param1.getDef().getSku(),false);
            InstanceMng.getUserDataMng().persistenceSaveData();
            FSTracker.trackMiscAction(FSTracker.CATEGORY_QUESTS,FSTracker.ACTION_CLAIMED,{"sku":param1.getDef().getSku()});
            this.refreshQuestsInProgress();
         }
      }
      
      private function initQuestInProgress(param1:String) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:QuestDef = null;
         var _loc6_:Quest = null;
         var _loc2_:UserData = Utils.getOwnerUserData();
         if(_loc2_)
         {
            _loc3_ = _loc2_.isQuestAlreadyClaimed(param1);
            _loc4_ = _loc2_.isQuestCompleted(param1);
            if(!this.isQuestInProgress(param1) && !_loc3_ && !_loc4_)
            {
               if(this.mQuestsInProgressVector == null)
               {
                  this.mQuestsInProgressVector = new Vector.<Quest>();
               }
               _loc5_ = QuestDef(InstanceMng.getQuestsDefMng().getDefBySku(param1));
               _loc6_ = new Quest(_loc5_);
               this.mQuestsInProgressVector.push(_loc6_);
               _loc6_.initGlobalProgress();
               if(_loc6_.isCompleted())
               {
                  this.setQuestAsCompleted(_loc6_);
               }
            }
         }
      }
      
      public function refreshQuestsInProgress() : void
      {
         var _loc2_:QuestDef = null;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         var _loc1_:Dictionary = InstanceMng.getQuestsDefMng().getAllDefs();
         if(_loc1_)
         {
            for each(_loc2_ in _loc1_)
            {
               _loc5_ = _loc2_.getSku();
               _loc3_ = InstanceMng.getUserDataMng().getOwnerUserData().isQuestAlreadyClaimed(_loc5_);
               _loc4_ = InstanceMng.getUserDataMng().getOwnerUserData().isQuestCompleted(_loc5_);
               if(!_loc3_ && !_loc4_)
               {
                  if(this.isQuestUnlocked(_loc5_))
                  {
                     this.initQuestInProgress(_loc5_);
                  }
               }
            }
         }
      }
      
      public function temporarylyStoreConsecutiveQuestsProgress(param1:String, param2:String = null, param3:String = null, param4:int = -1, param5:String = null) : void
      {
         var questInfo:String = null;
         var progress:int = 0;
         var questSku:String = null;
         var storableQuestFound:Boolean = false;
         var i:int = 0;
         var targetType:String = param1;
         var targetLevelSku:String = param2;
         var targetDungeonSku:String = param3;
         var targetDungeonDifficulty:int = param4;
         var targetFactionSku:String = param5;
         var isConsecutiveQuestReseteable:Function = function(param1:Quest, param2:String, param3:String = null, param4:String = null, param5:int = -1):Boolean
         {
            var _loc6_:String = getTargetTypeOpposite(param2);
            return param1 != null && param1.getDef() != null && param1.getDef().isConsecutive() && _loc6_ != "" && param1.isQuestConsecutiveAndResetteable(_loc6_,param3,param4,param5) && isPlayRelatedQuest(param2);
         };
         if(this.mQuestsInProgressVector != null && this.mConsecutiveQuestsTemporaryProgress == null)
         {
            questInfo = "";
            progress = 0;
            questSku = "";
            storableQuestFound = false;
            if(this.mConsecutiveQuestsTemporaryProgress == null)
            {
               this.mConsecutiveQuestsTemporaryProgress = new Array();
            }
            i = 0;
            while(i < this.mQuestsInProgressVector.length)
            {
               if(isConsecutiveQuestReseteable(this.mQuestsInProgressVector[i],targetType,targetLevelSku,targetDungeonSku,targetDungeonDifficulty))
               {
                  progress = this.mQuestsInProgressVector[i].getProgress();
                  questSku = this.mQuestsInProgressVector[i].getDef().getSku();
                  questInfo = questSku + ":" + progress;
                  this.mConsecutiveQuestsTemporaryProgress.push(questInfo);
                  if(progress != 0)
                  {
                     InstanceMng.getUserDataMng().getOwnerUserData().addQuestProgress(questSku,-progress,false);
                     storableQuestFound = true;
                  }
               }
               i++;
            }
            if(storableQuestFound)
            {
               InstanceMng.getUserDataMng().updateQuestsProgress();
            }
         }
      }
      
      public function restoreTemporaryConsecutiveQuestsProgress() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:UserData = null;
         if(Boolean(this.mConsecutiveQuestsTemporaryProgress) && this.mConsecutiveQuestsTemporaryProgress.length > 0)
         {
            _loc2_ = "";
            _loc3_ = 0;
            _loc5_ = Utils.getOwnerUserData();
            if(_loc5_)
            {
               _loc1_ = 0;
               while(_loc1_ < this.mConsecutiveQuestsTemporaryProgress.length)
               {
                  _loc4_ = this.mConsecutiveQuestsTemporaryProgress[_loc1_].split(":");
                  _loc2_ = _loc4_[0];
                  _loc3_ = int(_loc4_[1]);
                  if(_loc3_ > 0)
                  {
                     _loc5_.addQuestProgress(_loc2_,_loc3_,false);
                  }
                  _loc1_++;
               }
               InstanceMng.getUserDataMng().updateQuestsProgress();
            }
         }
         Utils.destroyArray(this.mConsecutiveQuestsTemporaryProgress);
         this.mConsecutiveQuestsTemporaryProgress = null;
      }
      
      public function onLevelFailed() : void
      {
         Utils.destroyArray(this.mConsecutiveQuestsTemporaryProgress);
         this.mConsecutiveQuestsTemporaryProgress = null;
      }
      
      public function resetQuestsMng() : void
      {
         if(this.mQuestsCompletedCatalog)
         {
            DictionaryUtils.clearDictionary(this.mQuestsCompletedCatalog);
            this.mQuestsCompletedCatalog = null;
         }
         if(this.mQuestsInProgressVector)
         {
            this.mQuestsInProgressVector.length = 0;
            this.mQuestsInProgressVector = null;
         }
         this.mQuestsInitialized = false;
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
      }
      
      public function flagQuestsAsNotInitialized() : void
      {
         this.mQuestsInitialized = false;
      }
      
      public function areQuestsInitialized() : Boolean
      {
         return this.mQuestsInitialized;
      }
      
      public function onCardPlayed(param1:FSCard) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:Array = null;
         if(Boolean(Config.getConfig().hasQuests() && param1) && Boolean(param1.getParentUserBattleInfo()) && param1.getParentUserBattleInfo().isOwnerBattleInfo())
         {
            _loc2_ = Boolean(Root.smBattleData.isDungeon);
            _loc3_ = Boolean(Root.smBattleData.isRaid);
            _loc4_ = InstanceMng.getBattleEngine().isPvPMatch();
            _loc5_ = param1.getCardDef().getFactionSku();
            _loc6_ = param1.getCardDef().getCardRarity();
            _loc7_ = param1.getCardDef().getCategorySku();
            _loc8_ = param1.getCardDef().getSubCategorySku() ? param1.getCardDef().getSubCategorySku()[0] : "";
            _loc9_ = param1.getCardDef().getEditionSku();
            _loc10_ = [QuestsMng.TARGET_CARD_RARITY + ":" + _loc6_,QuestsMng.TARGET_CARD_CATEGORY + ":" + _loc7_,QuestsMng.TARGET_CARD_SUBCATEGORY + ":" + _loc8_,QuestsMng.TARGET_CARD_FACTION + ":" + _loc5_,QuestsMng.TARGET_CARD_EDITION + ":" + _loc9_];
            if(_loc2_)
            {
               this.addActionPerformed(TARGET_PLAY_CARD_DUNGEON,1,false,_loc10_,"",InstanceMng.getDungeonsMng().getCurrentDungeonDef().getSku(),InstanceMng.getDungeonsMng().getCurrentDungeonDifficulty(),_loc5_);
            }
            else if(_loc3_)
            {
               this.addActionPerformed(TARGET_PLAY_CARD_RAID,1,false,_loc10_,null,InstanceMng.getRaidsMng().getCurrentRaidDef().getSku(),InstanceMng.getRaidsMng().getCurrentRaidDifficulty(),_loc5_);
            }
            if(!_loc4_ || _loc4_ && InstanceMng.getBattleEngine().isOnlineMatch() && !PvPConnectionMng.smPlayingFriendlyMatch)
            {
               if(Boolean(InstanceMng.getBattleEngine()) && Boolean(InstanceMng.getBattleEngine().getLevelDef()))
               {
                  this.addActionPerformed(TARGET_PLAY_CARD,1,false,_loc10_,InstanceMng.getBattleEngine().getLevelDef().getSku(),null,-1,_loc5_);
               }
            }
            InstanceMng.getBattleEngine().trackCardPlayed(param1.getCardDef());
         }
      }
      
      public function onCardDefeated(param1:FSCard) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:Array = null;
         if(Config.getConfig().hasQuests())
         {
            _loc2_ = Boolean(Root.smBattleData.isDungeon);
            _loc3_ = Boolean(Root.smBattleData.isRaid);
            _loc4_ = InstanceMng.getBattleEngine().isPvPMatch();
            _loc5_ = param1.getCardDef().getFactionSku();
            _loc6_ = param1.getCardDef().getCardRarity();
            _loc7_ = param1.getCardDef().getCategorySku();
            _loc8_ = param1.getCardDef().getSubCategorySku() ? param1.getCardDef().getSubCategorySku()[0] : "";
            _loc9_ = param1.getCardDef().getEditionSku();
            _loc10_ = [QuestsMng.TARGET_CARD_RARITY + ":" + _loc6_,QuestsMng.TARGET_CARD_CATEGORY + ":" + _loc7_,QuestsMng.TARGET_CARD_SUBCATEGORY + ":" + _loc8_,QuestsMng.TARGET_CARD_FACTION + ":" + _loc5_,QuestsMng.TARGET_CARD_EDITION + ":" + _loc9_];
            if(_loc2_)
            {
               this.addActionPerformed(TARGET_DESTROY_CARD_DUNGEON,1,false,_loc10_,"",InstanceMng.getDungeonsMng().getCurrentDungeonDef().getSku(),InstanceMng.getDungeonsMng().getCurrentDungeonDifficulty(),_loc5_);
            }
            else if(_loc3_)
            {
               this.addActionPerformed(TARGET_DESTROY_CARD_RAID,1,false,_loc10_,null,InstanceMng.getRaidsMng().getCurrentRaidDef().getSku(),InstanceMng.getRaidsMng().getCurrentRaidDifficulty(),_loc5_);
            }
            if(!_loc4_ || _loc4_ && InstanceMng.getBattleEngine().isOnlineMatch() && !PvPConnectionMng.smPlayingFriendlyMatch)
            {
               this.addActionPerformed(TARGET_DESTROY_CARD,1,false,_loc10_,InstanceMng.getBattleEngine().getLevelDef().getSku(),null,-1,_loc5_);
            }
         }
      }
      
      public function onCardPromoted(param1:FSCard) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:Array = null;
         if(Boolean(Config.getConfig().hasQuests() && param1) && Boolean(param1.getParentUserBattleInfo()) && param1.getParentUserBattleInfo().isOwnerBattleInfo())
         {
            _loc2_ = Boolean(Root.smBattleData.isDungeon);
            _loc3_ = Boolean(Root.smBattleData.isRaid);
            _loc4_ = InstanceMng.getBattleEngine() ? InstanceMng.getBattleEngine().isPvPMatch() : false;
            _loc5_ = param1.getCardDef().getFactionSku();
            _loc6_ = param1.getCardDef().getCardRarity();
            _loc7_ = param1.getCardDef().getCategorySku();
            _loc8_ = param1.getCardDef().getSubCategorySku() ? param1.getCardDef().getSubCategorySku()[0] : "";
            _loc9_ = param1.getCardDef().getEditionSku();
            _loc10_ = [QuestsMng.TARGET_CARD_RARITY + ":" + _loc6_,QuestsMng.TARGET_CARD_CATEGORY + ":" + _loc7_,QuestsMng.TARGET_CARD_SUBCATEGORY + ":" + _loc8_,QuestsMng.TARGET_CARD_FACTION + ":" + _loc5_,QuestsMng.TARGET_CARD_EDITION + ":" + _loc9_];
            if(_loc2_)
            {
               this.addActionPerformed(TARGET_PROMOTE_CARD_DUNGEON,1,false,_loc10_,"",InstanceMng.getDungeonsMng().getCurrentDungeonDef().getSku(),InstanceMng.getDungeonsMng().getCurrentDungeonDifficulty(),_loc5_);
            }
            else if(_loc3_)
            {
               this.addActionPerformed(TARGET_PROMOTE_CARD_RAID,1,false,_loc10_,null,InstanceMng.getRaidsMng().getCurrentRaidDef().getSku(),InstanceMng.getRaidsMng().getCurrentRaidDifficulty(),_loc5_);
            }
            if(!_loc4_ || _loc4_ && InstanceMng.getBattleEngine().isOnlineMatch() && !PvPConnectionMng.smPlayingFriendlyMatch)
            {
               this.addActionPerformed(TARGET_PROMOTE_CARD,1,false,_loc10_,InstanceMng.getBattleEngine().getLevelDef().getSku(),null,-1,_loc5_);
            }
         }
      }
      
      private function isPlayRelatedQuest(param1:String) : Boolean
      {
         var _loc2_:Boolean = true;
         switch(param1)
         {
            case TARGET_TYPE_PLAY:
            case TARGET_TYPE_START_DUNGEON:
            case TARGET_TYPE_START_RAID:
            case TARGET_TYPE_START_RAID_SP:
            case TARGET_TYPE_START_RAID_MP:
               return true;
            default:
               return false;
         }
      }
      
      private function isWinRelatedQuest(param1:String) : Boolean
      {
         var _loc2_:Boolean = true;
         switch(param1)
         {
            case TARGET_TYPE_WIN:
            case TARGET_TYPE_WIN_DUNGEON:
            case TARGET_TYPE_WIN_RAID:
            case TARGET_TYPE_WIN_RAID_SP:
            case TARGET_TYPE_WIN_RAID_MP:
               return true;
            default:
               return false;
         }
      }
      
      private function getTargetTypeOpposite(param1:String) : String
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case TARGET_TYPE_PLAY:
               return TARGET_TYPE_WIN;
            case TARGET_TYPE_START_DUNGEON:
               return TARGET_TYPE_WIN_DUNGEON;
            case TARGET_TYPE_START_RAID:
               return TARGET_TYPE_WIN_RAID;
            case TARGET_TYPE_START_RAID_SP:
               return TARGET_TYPE_WIN_RAID_SP;
            case TARGET_TYPE_START_RAID_MP:
               return TARGET_TYPE_WIN_RAID_MP;
            default:
               return "";
         }
      }
      
      public function resetTimedQuests(param1:String) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         if(Boolean(this.mQuestsInProgressVector) && Boolean(param1 != "") && param1 != null)
         {
            _loc2_ = false;
            _loc3_ = 0;
            for(; _loc3_ < this.mQuestsInProgressVector.length; _loc3_++)
            {
               if(!this.mQuestsInProgressVector[_loc3_].getDef())
               {
                  continue;
               }
               if(!this.mQuestsInProgressVector[_loc3_].getDef().hasTimedReset())
               {
                  continue;
               }
               switch(param1)
               {
                  case "weekly":
                     if(this.mQuestsInProgressVector[_loc3_].getDef().hasWeeklyReset())
                     {
                        this.mQuestsInProgressVector[_loc3_].resetProgress();
                        _loc2_ = true;
                     }
                     break;
                  case "daily":
                     if(this.mQuestsInProgressVector[_loc3_].getDef().hasDailyReset())
                     {
                        this.mQuestsInProgressVector[_loc3_].resetProgress();
                        _loc2_ = true;
                     }
               }
            }
            if(_loc2_)
            {
               InstanceMng.getUserDataMng().updateQuestsProgress();
            }
         }
      }
      
      public function resetBattlePassQuests() : void
      {
         var _loc2_:QuestDef = null;
         var _loc3_:Quest = null;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc1_:UserData = Utils.getOwnerUserData();
         if(this.mQuestsInProgressVector)
         {
            _loc4_ = 0;
            while(_loc4_ < this.mQuestsInProgressVector.length)
            {
               _loc3_ = this.mQuestsInProgressVector[_loc4_];
               _loc2_ = _loc3_ ? _loc3_.getDef() : null;
               if(Boolean(_loc2_) && _loc2_.isBattlePassQuest())
               {
                  _loc1_.removeQuestProgress(_loc2_.getSku(),false);
               }
               _loc4_++;
            }
         }
         if(this.mQuestsCompletedCatalog)
         {
            _loc5_ = DictionaryUtils.getKeys(this.mQuestsCompletedCatalog);
            if(_loc5_)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc5_.length)
               {
                  _loc2_ = QuestDef(InstanceMng.getQuestsDefMng().getDefBySku(_loc5_[_loc4_]));
                  if(_loc2_ != null && _loc2_.isBattlePassQuest())
                  {
                     if(_loc1_)
                     {
                        _loc1_.removeQuestCompleted(_loc2_.getSku(),false);
                     }
                     this.mQuestsCompletedCatalog[_loc2_.getSku()] = null;
                     delete this.mQuestsCompletedCatalog[_loc2_.getSku()];
                  }
                  _loc4_++;
               }
            }
         }
         Utils.destroyArray(this.mConsecutiveQuestsTemporaryProgress);
         this.mConsecutiveQuestsTemporaryProgress = null;
         if(_loc1_)
         {
            _loc1_.removeBattlePassQuestsProgress(false);
            _loc1_.removeBattlePassQuestsCompleted(false);
            _loc1_.removeBattlePassQuestsNotifiedAsCompleted(false);
            _loc1_.removeBattlePassQuestsClaimed(false);
         }
         InstanceMng.getUserDataMng().persistenceSaveData();
      }
      
      public function createCurrencyIcon(param1:QuestDef, param2:Boolean = false) : FSImage
      {
         var _loc3_:FSImage = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:JobDef = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         if(_loc3_ == null)
         {
            _loc5_ = param1.getRewardType(param2);
            switch(_loc5_)
            {
               case QuestsDefMng.REWARD_TYPE_QUEST_COINS:
               case QuestsDefMng.REWARD_TYPE_TOKENS:
                  _loc4_ = QuestSlot.QUESTSLOT_CURRENCY_ICON_BG;
                  break;
               case QuestsDefMng.REWARD_TYPE_GOLD:
                  _loc4_ = QuestSlot.QUESTSLOT_GOLD_ICON_BG;
                  break;
               case QuestsDefMng.REWARD_TYPE_RAID_COINS:
                  _loc4_ = QuestSlot.QUESTSLOT_RAID_COIN_ICON_BG;
                  break;
               case QuestsDefMng.REWARD_TYPE_CARD:
                  _loc4_ = RewardSlot.BG_CARDS;
                  break;
               case QuestsDefMng.REWARD_TYPE_CLASS_UNLOCK:
                  _loc7_ = param1.getTargetExtraInfo().split(":")[1];
                  _loc6_ = JobDef(InstanceMng.getJobsDefMng().getDefBySku(_loc7_));
                  _loc4_ = _loc6_.getBgIcon();
                  break;
               case QuestsDefMng.REWARD_TYPE_JOB_XP:
                  _loc8_ = param1.getRewardJobXP().split(":")[0];
                  _loc6_ = JobDef(InstanceMng.getJobsDefMng().getDefBySku(_loc8_));
                  _loc4_ = _loc6_.getBgIcon();
                  break;
               case QuestsDefMng.REWARD_TYPE_UNLOCK_CRAFT:
                  _loc4_ = QuestSlot.QUESTSLOT_CRAFT_UNLOCKED_BG;
            }
            _loc3_ = new FSImage(Root.assets.getTexture(_loc4_));
            _loc3_.scale = 1.25;
            _loc3_.touchable = false;
         }
         return _loc3_;
      }
      
      public function createSkinImage(param1:QuestDef) : FSImage
      {
         var _loc2_:FSImage = null;
         var _loc3_:String = null;
         if(_loc2_ == null)
         {
            _loc3_ = Config.getConfig().hasSkins() ? "rewards_skins_icon" : "rewards_portraits_icon";
            _loc2_ = new FSImage(Root.assets.getTexture(_loc3_));
            _loc2_.scale = 1.25;
            _loc2_.touchable = false;
         }
         return _loc2_;
      }
      
      public function createPackImage(param1:QuestDef, param2:Boolean = false) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:PackDef = null;
         if(_loc3_ == null && Boolean(param1))
         {
            _loc4_ = PackDef(InstanceMng.getPacksDefMng().getDefBySku(param1.getRewardPackSku(param2)));
            if(_loc4_)
            {
               _loc3_ = new PackAnimation(_loc4_.getAnimBG());
               _loc3_.scaleX *= 0.4;
               _loc3_.scaleY *= 0.4;
               _loc3_.touchable = false;
            }
         }
         return _loc3_;
      }
   }
}

