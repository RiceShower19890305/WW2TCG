package com.fs.tcgengine.model.quests
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.QuestsMng;
   import com.fs.tcgengine.controller.rules.QuestsDefMng;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.model.rules.QuestDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.screens.FSMapScreen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.popups.quests.QuestCompletePanelInfo;
   import com.fs.tcgengine.view.popups.quests.PopupBattlePass;
   import com.fs.tcgengine.view.popups.quests.PopupQuest;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import starling.core.Starling;
   
   public class Quest implements FSModelUnloadableInterface
   {
      
      private var mQuestDef:QuestDef;
      
      public function Quest(param1:QuestDef)
      {
         super();
         this.mQuestDef = param1;
      }
      
      private function getUpdatedOwnerUserData() : UserData
      {
         return InstanceMng.getUserDataMng().getOwnerUserData();
      }
      
      public function actionPerformed(param1:String, param2:int, param3:Array = null, param4:String = null, param5:String = null, param6:int = -1, param7:String = null) : Boolean
      {
         var _loc9_:Array = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:String = null;
         var _loc15_:Boolean = false;
         var _loc16_:Boolean = false;
         var _loc17_:Boolean = false;
         var _loc18_:Boolean = false;
         var _loc19_:Boolean = false;
         var _loc20_:Boolean = false;
         var _loc8_:Boolean = false;
         if(Boolean(this.mQuestDef) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
         {
            if(this.mQuestDef.isBattlePassQuest() && !this.mQuestDef.isBattlePassQuestEligibleBySeason())
            {
               return false;
            }
            _loc9_ = Boolean(this.mQuestDef.getTargetExtraInfo()) && this.mQuestDef.getTargetExtraInfo() != null ? this.mQuestDef.getTargetExtraInfo().split(",") : null;
            _loc10_ = this.mQuestDef.getTargetLevelSku();
            _loc11_ = this.mQuestDef.getTargetSku();
            _loc12_ = this.mQuestDef.getTargetDifficulty();
            _loc13_ = this.mQuestDef.getLevelDifficulty();
            _loc14_ = this.mQuestDef.getTargetFactionSku();
            _loc15_ = this.isExtraInfoOK(_loc9_,param3);
            _loc16_ = _loc10_ == null || _loc10_ != null && param4 == _loc10_;
            _loc17_ = _loc11_ == null || _loc11_ != null && param5 == _loc11_;
            _loc18_ = _loc12_ == -1 || _loc12_ != -1 && _loc12_ == param6;
            _loc19_ = _loc13_ == -1 || _loc13_ != -1 && _loc13_ == InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
            _loc20_ = _loc14_ == null || _loc14_ != null && _loc14_ == param7;
            if(this.getUpdatedOwnerUserData())
            {
               if(param1 == this.mQuestDef.getTargetType())
               {
                  switch(param1)
                  {
                     case QuestsMng.TARGET_TYPE_LOSS:
                        if(_loc15_ && _loc19_)
                        {
                           _loc8_ = true;
                           this.getUpdatedOwnerUserData().addQuestProgress(this.mQuestDef.getSku(),param2,false);
                        }
                        break;
                     case QuestsMng.TARGET_TYPE_WIN:
                     case QuestsMng.TARGET_TYPE_PLAY:
                        if(_loc15_)
                        {
                           if(_loc10_ != null)
                           {
                              if(_loc16_ && _loc19_ && _loc20_)
                              {
                                 _loc8_ = true;
                                 this.getUpdatedOwnerUserData().addQuestProgress(this.mQuestDef.getSku(),param2,false);
                              }
                           }
                           else if(_loc11_ != null)
                           {
                              if(_loc17_ && _loc18_ && _loc20_)
                              {
                                 _loc8_ = true;
                                 this.getUpdatedOwnerUserData().addQuestProgress(this.mQuestDef.getSku(),param2,false);
                              }
                           }
                           else if(_loc17_ && _loc18_ && _loc19_ && _loc20_)
                           {
                              _loc8_ = true;
                              this.getUpdatedOwnerUserData().addQuestProgress(this.mQuestDef.getSku(),param2,false);
                           }
                        }
                        break;
                     case QuestsMng.TARGET_TYPE_WIN_DUNGEON:
                     case QuestsMng.TARGET_TYPE_START_DUNGEON:
                     case QuestsMng.TARGET_TYPE_START_RAID:
                     case QuestsMng.TARGET_TYPE_WIN_RAID:
                     case QuestsMng.TARGET_TYPE_START_RAID_SP:
                     case QuestsMng.TARGET_TYPE_WIN_RAID_SP:
                     case QuestsMng.TARGET_TYPE_START_RAID_MP:
                     case QuestsMng.TARGET_TYPE_WIN_RAID_MP:
                        if(_loc15_)
                        {
                           if(_loc17_ && _loc18_)
                           {
                              _loc8_ = true;
                              this.getUpdatedOwnerUserData().addQuestProgress(this.mQuestDef.getSku(),param2,false);
                           }
                        }
                        break;
                     case QuestsMng.TARGET_TYPE_UNFOLD_PACK:
                     case QuestsMng.TARGET_TYPE_UNFOLD_CARD:
                     case QuestsMng.TARGET_TYPE_OBTAIN:
                     case QuestsMng.TARGET_CARD_CRAFT:
                     case QuestsMng.TARGET_CARD_FUSION:
                     case QuestsMng.TARGET_CARD_ASPECT:
                     case QuestsMng.TARGET_TYPE_SHARE_GAME_QUEST:
                     case QuestsMng.TARGET_TYPE_EDIT_SPEED:
                     case QuestsMng.TARGET_TYPE_USE_RESHUFFLE:
                        if(_loc15_ && _loc20_)
                        {
                           _loc8_ = true;
                           this.getUpdatedOwnerUserData().addQuestProgress(this.mQuestDef.getSku(),param2,false);
                        }
                        break;
                     case QuestsMng.TARGET_TYPE_DEAL_DAMAGE_TO_OPPONENT:
                     case QuestsMng.TARGET_TYPE_DEAL_DAMAGE_TO_DUNGEON_OPPONENT:
                     case QuestsMng.TARGET_TYPE_DEAL_DAMAGE_TO_RAID_OPPONENT:
                     case QuestsMng.TARGET_TYPE_AUCTION_CREATED:
                     case QuestsMng.TARGET_TYPE_AUCTION_BID:
                     case QuestsMng.TARGET_TYPE_AUCTION_SUCCESS:
                     case QuestsMng.TARGET_TYPE_AUCTION_WON:
                        if(_loc15_)
                        {
                           if(_loc17_ && _loc18_ && _loc16_)
                           {
                              _loc8_ = true;
                              this.getUpdatedOwnerUserData().addQuestProgress(this.mQuestDef.getSku(),param2,false);
                           }
                        }
                        break;
                     case QuestsMng.TARGET_TYPE_DEAL_DAMAGE_TO_OPPONENT_TURN:
                     case QuestsMng.TARGET_TYPE_DEAL_DAMAGE_TO_DUNGEON_OPPONENT_TURN:
                     case QuestsMng.TARGET_TYPE_DEAL_DAMAGE_TO_RAID_OPPONENT_TURN:
                        if(_loc15_)
                        {
                           if(_loc17_ && _loc18_ && _loc16_)
                           {
                              if(this.mQuestDef.getTargetAmount() <= param2)
                              {
                                 _loc8_ = true;
                                 this.getUpdatedOwnerUserData().addQuestProgress(this.mQuestDef.getSku(),param2,false);
                              }
                           }
                        }
                        break;
                     case QuestsMng.TARGET_DAILY_QUEST:
                        if(_loc15_)
                        {
                           _loc8_ = true;
                           this.getUpdatedOwnerUserData().addQuestProgress(this.mQuestDef.getSku(),param2,false);
                        }
                        break;
                     case QuestsMng.TARGET_PLAY_CARD:
                     case QuestsMng.TARGET_PLAY_CARD_DUNGEON:
                     case QuestsMng.TARGET_PLAY_CARD_RAID:
                     case QuestsMng.TARGET_PROMOTE_CARD:
                     case QuestsMng.TARGET_PROMOTE_CARD_DUNGEON:
                     case QuestsMng.TARGET_PROMOTE_CARD_RAID:
                     case QuestsMng.TARGET_DESTROY_CARD:
                     case QuestsMng.TARGET_DESTROY_CARD_DUNGEON:
                     case QuestsMng.TARGET_DESTROY_CARD_RAID:
                     case QuestsMng.TARGET_USE_RAID_TICKET:
                        if(_loc15_)
                        {
                           if(_loc17_ && _loc18_ && _loc16_ && _loc20_)
                           {
                              _loc8_ = true;
                              this.getUpdatedOwnerUserData().addQuestProgress(this.mQuestDef.getSku(),param2,false);
                           }
                        }
                  }
               }
            }
         }
         return _loc8_;
      }
      
      private function isExtraInfoOK(param1:Array, param2:Array) : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:Boolean = false;
         var _loc3_:Boolean = true;
         if(param1 != null && param1.length > 0 && param2 != null && param2.length > 0)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.length)
            {
               _loc6_ = String(param1[_loc4_]).split(":")[0];
               _loc7_ = String(param1[_loc4_]).split(":")[1];
               _loc5_ = 0;
               while(_loc5_ < param2.length)
               {
                  _loc8_ = String(param2[_loc5_]).split(":")[0];
                  _loc9_ = String(param2[_loc5_]).split(":")[1];
                  if(_loc6_ == _loc8_)
                  {
                     _loc10_ = true;
                     if(_loc6_ == QuestsMng.TARGET_EXTRA_INFO_HP_LEFT || _loc6_ == QuestsMng.TARGET_EXTRA_INFO_LEVEL_HIGHER)
                     {
                        if(int(_loc9_) < int(_loc7_))
                        {
                           return false;
                        }
                     }
                     else if(_loc6_ == QuestsMng.TARGET_EXTRA_INFO_BOSS_HP_LESSTHAN)
                     {
                        if(int(_loc9_) > int(_loc7_))
                        {
                           return false;
                        }
                     }
                     else if(_loc7_ != _loc9_)
                     {
                        return false;
                     }
                  }
                  _loc5_++;
               }
               if(!_loc10_)
               {
                  return false;
               }
               _loc4_++;
            }
         }
         else if(param1 != null && param1.length > 0 && param2 == null)
         {
            _loc3_ = false;
         }
         return _loc3_;
      }
      
      public function isCompleted(param1:int = 0) : Boolean
      {
         var _loc3_:UserData = null;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:int = 0;
         var _loc11_:Array = null;
         var _loc12_:int = 0;
         var _loc2_:Boolean = false;
         if(this.mQuestDef)
         {
            _loc3_ = Utils.getOwnerUserData();
            _loc2_ = _loc3_ ? _loc3_.isQuestCompleted(this.mQuestDef.getSku()) : false;
            if(!_loc2_)
            {
               _loc5_ = this.mQuestDef.getProgressType();
               _loc6_ = this.mQuestDef.getTargetType();
               _loc7_ = this.mQuestDef.getTargetAmount();
               _loc8_ = this.mQuestDef.getTargetLevelSku();
               _loc9_ = this.mQuestDef.getTargetSku();
               _loc10_ = this.mQuestDef.getTargetDifficulty();
               _loc11_ = Boolean(this.mQuestDef.getTargetExtraInfo()) && this.mQuestDef.getTargetExtraInfo() != null ? this.mQuestDef.getTargetExtraInfo().split(":") : null;
               _loc12_ = this.mQuestDef.getLevelDifficulty();
               if(_loc5_ == QuestsMng.PROGRESS_TYPE_LOCAL)
               {
                  _loc2_ = this.isTargetCompletedLocally();
               }
               else
               {
                  switch(_loc6_)
                  {
                     case QuestsMng.TARGET_TYPE_WIN:
                        _loc2_ = this.checkTargetWin(_loc7_,_loc8_,_loc12_);
                        break;
                     case QuestsMng.TARGET_TYPE_PLAY:
                        _loc2_ = this.checkTargetPlay(_loc7_,_loc8_);
                        break;
                     case QuestsMng.TARGET_TYPE_JOIN_GUILD:
                        _loc2_ = this.checkTargetJoinGuild();
                        break;
                     case QuestsMng.TARGET_TYPE_OBTAIN:
                        _loc2_ = this.checkTargetObtain(_loc7_,_loc11_);
                        break;
                     case QuestsMng.TARGET_DAILY_QUEST:
                        _loc2_ = this.checkCompletAllDailyQuests();
                        break;
                     case QuestsMng.TARGET_TYPE_COMMUNITY_QUEST:
                        _loc2_ = this.checkTargetCommunityQuest();
                  }
               }
            }
            _loc4_ = InstanceMng.getUserDataMng().getOwnerUserData().isQuestNotifiedAsCompleted(this.mQuestDef.getSku());
            if(_loc2_)
            {
               if(!_loc4_)
               {
                  FSDebug.debugTrace("QUEST: " + this.mQuestDef.getDesc() + " COMPLETED!!!!");
                  if(InstanceMng.getApplication().mapScreenHasBeenVisited())
                  {
                     setTimeout(this.showQuestCompletedPanel,param1 * 0.5,param1);
                  }
               }
               if(InstanceMng.getCurrentScreen() is FSMapScreen)
               {
                  if(!_loc3_.isQuestAlreadyClaimed(this.mQuestDef.getSku()))
                  {
                     if(this.mQuestDef.isBattlePassQuest())
                     {
                        FSMapScreen(InstanceMng.getCurrentScreen()).onBattlePassQuestClaimeableShowNotificationIcon();
                     }
                     else
                     {
                        FSMapScreen(InstanceMng.getCurrentScreen()).onQuestClaimeableShowNotificationIcon();
                     }
                  }
               }
            }
         }
         return _loc2_;
      }
      
      private function checkCompletAllDailyQuests() : Boolean
      {
         var _loc6_:QuestDef = null;
         var _loc7_:Boolean = false;
         var _loc1_:Dictionary = InstanceMng.getUserDataMng().getOwnerUserData().getQuestsCompleted();
         var _loc2_:Dictionary = InstanceMng.getUserDataMng().getOwnerUserData().getQuestsClaimed();
         var _loc3_:Dictionary = InstanceMng.getQuestsDefMng().getDailyQuests();
         var _loc4_:int = DictionaryUtils.getDictionaryLength(_loc3_);
         var _loc5_:int = 0;
         if(_loc1_)
         {
            for each(_loc6_ in _loc3_)
            {
               _loc7_ = Boolean(_loc1_[_loc6_.getSku()]);
               if(_loc7_)
               {
                  _loc5_++;
               }
            }
         }
         if(_loc2_)
         {
            for each(_loc6_ in _loc3_)
            {
               _loc7_ = Boolean(_loc2_[_loc6_.getSku()]);
               if(_loc7_)
               {
                  _loc5_++;
               }
            }
         }
         return _loc4_ - 1 == _loc5_;
      }
      
      private function checkTargetCommunityQuest() : Boolean
      {
         return this.getProgress() >= this.getProgressToComplete();
      }
      
      private function checkTargetWin(param1:int, param2:String, param3:int) : Boolean
      {
         var _loc5_:LevelDef = null;
         var _loc4_:Boolean = false;
         if(param2 != null)
         {
            _loc5_ = LevelDef(InstanceMng.getLevelsDefMng().getDefBySku(param2));
            _loc4_ = _loc5_ ? this.getUpdatedOwnerUserData().getCurrentLevelIndex(param3) > _loc5_.getLevelIndex() : false;
         }
         return _loc4_;
      }
      
      private function checkTargetPlay(param1:int, param2:String) : Boolean
      {
         var _loc4_:LevelDef = null;
         var _loc3_:Boolean = false;
         if(param2 != null)
         {
            _loc3_ = this.getUpdatedOwnerUserData().getMatchesPlayed() >= param1;
         }
         return _loc3_;
      }
      
      private function checkTargetJoinGuild() : Boolean
      {
         return this.getUpdatedOwnerUserData().hasGuild();
      }
      
      private function checkTargetObtain(param1:int, param2:Array) : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc3_:Boolean = false;
         switch(param2[1])
         {
            case Constants.CURRENCY_GOLD:
               _loc3_ = this.getUpdatedOwnerUserData().getGold() >= param1;
               break;
            case Constants.CURRENCY_GUILD_POINTS:
               _loc4_ = this.getUpdatedOwnerUserData().getGuildGlobalTotalScore();
               _loc5_ = this.getProgress();
               _loc3_ = _loc5_ >= param1 || _loc4_ >= param1;
         }
         return _loc3_;
      }
      
      public function initGlobalProgress() : void
      {
         var _loc1_:Array = null;
         if(Boolean(this.mQuestDef) && Boolean(this.mQuestDef.getProgressType() == QuestsMng.PROGRESS_TYPE_GLOBAL) && this.mQuestDef.getTargetType() == QuestsMng.TARGET_TYPE_OBTAIN)
         {
            if(this.getUpdatedOwnerUserData().getQuestProgress(this.mQuestDef.getSku()) <= 0)
            {
               _loc1_ = Boolean(this.mQuestDef.getTargetExtraInfo()) && this.mQuestDef.getTargetExtraInfo() != null ? this.mQuestDef.getTargetExtraInfo().split(":") : null;
               switch(_loc1_[1])
               {
                  case Constants.CURRENCY_GUILD_POINTS:
                     this.getUpdatedOwnerUserData().addQuestProgress(this.mQuestDef.getSku(),this.getUpdatedOwnerUserData().getGuildGlobalTotalScore());
               }
            }
         }
      }
      
      private function isTargetCompletedLocally() : Boolean
      {
         return this.getUpdatedOwnerUserData().getQuestProgress(this.mQuestDef.getSku()) >= this.mQuestDef.getTargetAmount();
      }
      
      public function isProgressQuest() : Boolean
      {
         return this.mQuestDef.getTargetAmount() > 0;
      }
      
      public function getProgress() : int
      {
         var _loc1_:int = 0;
         if(this.mQuestDef.isCommunityQuest())
         {
            return Boolean(Config.smServerConfig) && Config.smServerConfig.hasOwnProperty("misc_usersAmount") ? int(Config.smServerConfig["misc_usersAmount"]) : 0;
         }
         return this.getUpdatedOwnerUserData() ? this.getUpdatedOwnerUserData().getQuestProgress(this.mQuestDef.getSku()) : 0;
      }
      
      public function resetProgress() : void
      {
         if(this.getUpdatedOwnerUserData())
         {
            this.getUpdatedOwnerUserData().addQuestProgress(this.mQuestDef.getSku(),-this.getUpdatedOwnerUserData().getQuestProgress(this.mQuestDef.getSku()),false);
         }
      }
      
      public function getProgressToComplete() : int
      {
         return this.mQuestDef.getTargetAmount();
      }
      
      public function getRewardPoints(param1:Boolean = false) : int
      {
         return this.mQuestDef.getRewardPoints(param1);
      }
      
      public function getRewardGold(param1:Boolean = false) : int
      {
         return this.mQuestDef.getRewardGold(param1);
      }
      
      public function isDaily() : Boolean
      {
         return this.mQuestDef.isDaily();
      }
      
      public function getDef() : QuestDef
      {
         return this.mQuestDef;
      }
      
      public function claim() : void
      {
         this.mQuestDef.claimReward();
         InstanceMng.getQuestsMng().setQuestAsClaimed(this);
         if(InstanceMng.getCurrentScreen() is FSMapScreen)
         {
            if(this.mQuestDef.isBattlePassQuest())
            {
               FSMapScreen(InstanceMng.getCurrentScreen()).onBattlePassQuestClaimedHideNotificationIcon();
            }
            else
            {
               FSMapScreen(InstanceMng.getCurrentScreen()).onQuestClaimedHideNotificationIcon();
            }
         }
         if(InstanceMng.getPopupMng().getPopupShown() != null)
         {
            if(this.mQuestDef.getRewardType() != QuestsDefMng.REWARD_TYPE_PACK)
            {
               if(InstanceMng.getPopupMng().getPopupShown() is PopupQuest)
               {
                  PopupQuest(InstanceMng.getPopupMng().getPopupShown()).onQuestsMngResetedCleanPopup();
               }
               else if(InstanceMng.getPopupMng().getPopupShown() is PopupBattlePass)
               {
                  PopupBattlePass(InstanceMng.getPopupMng().getPopupShown()).refreshQuestsSection(false);
               }
            }
         }
         Utils.setStat(Constants.STAT_QUEST_CLAIMED,1);
      }
      
      public function showQuestCompletedPanel(param1:int = 0) : void
      {
         var _loc3_:QuestCompletePanelInfo = null;
         var _loc2_:Boolean = InstanceMng.getUserDataMng().getOwnerUserData().isQuestNotifiedAsCompleted(this.mQuestDef.getSku());
         if(!_loc2_ && InstanceMng.getApplication().areOnDemandDefinitionsInitialized())
         {
            FSDebug.debugTrace("About to show the SHOW QUEST COMPLETED on screen: " + InstanceMng.getCurrentScreen().getScreenName());
            _loc3_ = new QuestCompletePanelInfo(this);
            _loc3_.x = Starling.current.stage.stageWidth / 2;
            _loc3_.y = -_loc3_.height / 2;
            setTimeout(_loc3_.showPanel,500,[param1]);
            InstanceMng.getUserDataMng().getOwnerUserData().addQuestNotifiedAsCompleted(this.mQuestDef.getSku(),false);
         }
      }
      
      public function isCommunityQuest() : Boolean
      {
         return this.mQuestDef.isCommunityQuest();
      }
      
      public function destroy() : void
      {
         this.mQuestDef = null;
      }
      
      public function isQuestConsecutiveAndResetteable(param1:String, param2:String = null, param3:String = null, param4:int = -1) : Boolean
      {
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:String = null;
         var _loc11_:Boolean = false;
         var _loc12_:Boolean = false;
         var _loc13_:Boolean = false;
         var _loc14_:Boolean = false;
         var _loc5_:Boolean = false;
         if(Boolean(this.mQuestDef) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
         {
            _loc6_ = this.mQuestDef.getTargetLevelSku();
            _loc7_ = this.mQuestDef.getTargetSku();
            _loc8_ = this.mQuestDef.getTargetDifficulty();
            _loc9_ = this.mQuestDef.getLevelDifficulty();
            _loc10_ = this.mQuestDef.getTargetFactionSku();
            _loc11_ = _loc6_ == null || _loc6_ != null && param2 == _loc6_;
            _loc12_ = _loc7_ == null || _loc7_ != null && param3 == _loc7_;
            _loc13_ = _loc8_ == -1 || _loc8_ != -1 && _loc8_ == param4;
            _loc14_ = _loc9_ == -1 || _loc9_ != -1 && _loc9_ == InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
            if(this.getUpdatedOwnerUserData())
            {
               if(param1 == this.mQuestDef.getTargetType())
               {
                  switch(param1)
                  {
                     case QuestsMng.TARGET_TYPE_WIN:
                     case QuestsMng.TARGET_TYPE_PLAY:
                        if(_loc6_ != null)
                        {
                           return _loc11_ && _loc14_;
                        }
                        return _loc12_ && _loc13_;
                        break;
                     case QuestsMng.TARGET_TYPE_WIN_DUNGEON:
                     case QuestsMng.TARGET_TYPE_START_DUNGEON:
                     case QuestsMng.TARGET_TYPE_START_RAID:
                     case QuestsMng.TARGET_TYPE_WIN_RAID:
                     case QuestsMng.TARGET_TYPE_START_RAID_SP:
                     case QuestsMng.TARGET_TYPE_WIN_RAID_SP:
                     case QuestsMng.TARGET_TYPE_START_RAID_MP:
                     case QuestsMng.TARGET_TYPE_WIN_RAID_MP:
                        return _loc12_ && _loc13_;
                  }
               }
            }
         }
         return _loc5_;
      }
   }
}

