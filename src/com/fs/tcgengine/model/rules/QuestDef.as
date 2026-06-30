package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.JobsMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.controller.rules.PacksDefMng;
   import com.fs.tcgengine.controller.rules.QuestsDefMng;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.screens.FSMapScreen;
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.misc.RewardSlot;
   
   public class QuestDef extends Def
   {
      
      private var mRewardType:int = -1;
      
      private var mRewardPoints:FSNumber;
      
      private var mRewardRaidPoints:FSNumber;
      
      private var mRewardCard:String;
      
      private var mRewardTokens:FSNumber;
      
      private var mRewardGold:FSNumber;
      
      private var mRewardSkinSku:String;
      
      private var mRewardPackSku:String;
      
      private var mRewardJobXP:String;
      
      private var mPremiumRewardType:int = -1;
      
      private var mPremiumRewardPoints:FSNumber;
      
      private var mPremiumRewardRaidPoints:FSNumber;
      
      private var mPremiumRewardCard:String;
      
      private var mPremiumRewardTokens:FSNumber;
      
      private var mPremiumRewardGold:FSNumber;
      
      private var mPremiumRewardSkinSku:String;
      
      private var mPremiumRewardPackSku:String;
      
      private var mPremiumRewardJobXP:String;
      
      private var mIsDaily:Boolean;
      
      private var mUnlockLevelSku:String;
      
      private var mUnlockQuestSku:String;
      
      private var mProgressType:int;
      
      private var mTargetType:String;
      
      private var mTargetAmount:FSNumber;
      
      private var mTargetLevelSku:String;
      
      private var mTargetDungeonSku:String;
      
      private var mTargetDungeonDifficulty:int = -1;
      
      private var mTargetExtraInfo:String;
      
      private var mLevelDifficulty:int;
      
      private var mIsSecretQuest:int;
      
      private var mIsCommunityQuest:Boolean;
      
      private var mTooltipText:String;
      
      private var mJobSku:String;
      
      private var mTargetFactionSku:String;
      
      private var mIsConsecutive:Boolean;
      
      private var mTimedReset:String;
      
      private var mIsBattlePassQuest:Boolean;
      
      private var mBattlePassIndex:int;
      
      private var mBattlePassChainIndex:int;
      
      private var mBattlePassChainFamilyId:int = -1;
      
      private var mBattlePassSeason:int;
      
      private var mBattlePassSeasonYear:int;
      
      public function QuestDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         super.doFromJSON(param1);
         if("isDaily" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.isDaily);
            this.mIsDaily = Utils.stringToBoolean(_loc2_);
         }
         if("unlockLevelSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.unlockLevelSku);
            this.mUnlockLevelSku = _loc2_;
         }
         if("unlockQuestSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.unlockQuestSku);
            this.mUnlockQuestSku = _loc2_;
         }
         if("progressType" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.progressType);
            this.mProgressType = int(_loc2_);
         }
         if("targetType" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.targetType);
            this.mTargetType = _loc2_;
         }
         if("targetAmount" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.targetAmount);
            this.setTargetAmount(int(_loc2_));
         }
         if("targetLevelSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.targetLevelSku);
            this.mTargetLevelSku = _loc2_;
         }
         if("targetDungeonSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.targetDungeonSku);
            this.mTargetDungeonSku = _loc2_;
         }
         if("targetDungeonDifficulty" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.targetDungeonDifficulty);
            this.mTargetDungeonDifficulty = int(_loc2_);
         }
         if("targetExtraInfo" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.targetExtraInfo);
            this.mTargetExtraInfo = _loc2_;
         }
         if("levelDifficulty" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.levelDifficulty);
            this.mLevelDifficulty = int(_loc2_);
         }
         if("isSecret" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.isSecret);
            this.mIsSecretQuest = int(_loc2_);
         }
         if("isCommunityQuest" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.isCommunityQuest);
            this.mIsCommunityQuest = Utils.stringToBoolean(_loc2_);
         }
         if("tooltipText" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.tooltipText);
            this.mTooltipText = _loc2_;
         }
         if("targetFactionSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.targetFactionSku);
            this.mTargetFactionSku = _loc2_;
         }
         if("isConsecutive" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.isConsecutive);
            this.mIsConsecutive = Utils.stringToBoolean(_loc2_);
         }
         if("timedReset" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.timedReset);
            this.mTimedReset = _loc2_;
         }
         if("isBattlePass" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.isBattlePass);
            this.mIsBattlePassQuest = Utils.stringToBoolean(_loc2_);
         }
         if("battlePassIndex" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battlePassIndex);
            this.mBattlePassIndex = int(_loc2_);
         }
         if("battlePassSeason" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battlePassSeason);
            this.mBattlePassSeason = int(_loc2_);
         }
         if("battlePassSeasonYear" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battlePassSeasonYear);
            this.mBattlePassSeasonYear = int(_loc2_);
         }
         if("battlePassChainIndex" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battlePassChainIndex);
            this.mBattlePassChainIndex = int(_loc2_);
         }
         if("battlePassChainFamilyId" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battlePassChainFamilyId);
            this.mBattlePassChainFamilyId = int(_loc2_);
         }
         if("rewardType" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.rewardType);
            this.mRewardType = int(_loc2_);
         }
         if("rewardPoints" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.rewardPoints);
            this.setRewardPoints(int(_loc2_));
         }
         if("rewardGold" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.rewardGold);
            this.setRewardGold(int(_loc2_));
         }
         if("rewardCard" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.rewardCard);
            this.mRewardCard = _loc2_;
         }
         if("rewardRaidPoints" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.rewardRaidPoints);
            this.setRewardRaidPoints(int(_loc2_));
         }
         if("rewardTokens" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.rewardTokens);
            this.setRewardTokens(int(_loc2_));
         }
         if("rewardSkinSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.rewardSkinSku);
            this.mRewardSkinSku = _loc2_;
         }
         if("rewardPackSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.rewardPackSku);
            this.mRewardPackSku = _loc2_;
         }
         if("rewardJobXP" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.rewardJobXP);
            this.mRewardJobXP = _loc2_;
         }
         if("premiumRewardType" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.premiumRewardType);
            this.mPremiumRewardType = int(_loc2_);
         }
         if("premiumRewardPoints" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.premiumRewardPoints);
            this.setPremiumRewardPoints(int(_loc2_));
         }
         if("premiumRewardGold" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.premiumRewardGold);
            this.setPremiumRewardGold(int(_loc2_));
         }
         if("premiumRewardRaidPoints" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.premiumRewardRaidPoints);
            this.setPremiumRewardRaidPoints(int(_loc2_));
         }
         if("premiumRewardTokens" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.premiumRewardTokens);
            this.setPremiumRewardTokens(int(_loc2_));
         }
         if("premiumRewardCard" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.premiumRewardCard);
            this.mPremiumRewardCard = _loc2_;
         }
         if("premiumRewardSkinSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.premiumRewardSkinSku);
            this.mPremiumRewardSkinSku = _loc2_;
         }
         if("premiumRewardPackSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.premiumRewardPackSku);
            this.mPremiumRewardPackSku = _loc2_;
         }
      }
      
      private function setTargetAmount(param1:int) : void
      {
         if(this.mTargetAmount == null)
         {
            this.mTargetAmount = new FSNumber();
         }
         this.mTargetAmount.value = Number(param1);
      }
      
      private function setRewardPoints(param1:int) : void
      {
         if(this.mRewardPoints == null)
         {
            this.mRewardPoints = new FSNumber();
         }
         this.mRewardPoints.value = Number(param1);
      }
      
      private function setRewardGold(param1:int) : void
      {
         if(this.mRewardGold == null)
         {
            this.mRewardGold = new FSNumber();
         }
         this.mRewardGold.value = Number(param1);
      }
      
      private function setRewardRaidPoints(param1:int) : void
      {
         if(this.mRewardRaidPoints == null)
         {
            this.mRewardRaidPoints = new FSNumber();
         }
         this.mRewardRaidPoints.value = Number(param1);
      }
      
      private function setRewardTokens(param1:int) : void
      {
         if(this.mRewardTokens == null)
         {
            this.mRewardTokens = new FSNumber();
         }
         this.mRewardTokens.value = Number(param1);
      }
      
      private function setPremiumRewardPoints(param1:int) : void
      {
         if(this.mPremiumRewardPoints == null)
         {
            this.mPremiumRewardPoints = new FSNumber();
         }
         this.mPremiumRewardPoints.value = Number(param1);
      }
      
      private function setPremiumRewardGold(param1:int) : void
      {
         if(this.mPremiumRewardGold == null)
         {
            this.mPremiumRewardGold = new FSNumber();
         }
         this.mPremiumRewardGold.value = Number(param1);
      }
      
      private function setPremiumRewardRaidPoints(param1:int) : void
      {
         if(this.mPremiumRewardRaidPoints == null)
         {
            this.mPremiumRewardRaidPoints = new FSNumber();
         }
         this.mPremiumRewardRaidPoints.value = Number(param1);
      }
      
      private function setPremiumRewardTokens(param1:int) : void
      {
         if(this.mPremiumRewardTokens == null)
         {
            this.mPremiumRewardTokens = new FSNumber();
         }
         this.mPremiumRewardTokens.value = Number(param1);
      }
      
      public function isDaily() : Boolean
      {
         return this.mIsDaily;
      }
      
      public function getUnlockedLevelSku() : String
      {
         return this.mUnlockLevelSku;
      }
      
      public function getUnlockQuestSku() : String
      {
         return this.mUnlockQuestSku;
      }
      
      public function getProgressType() : int
      {
         return this.mProgressType;
      }
      
      public function getTargetType() : String
      {
         return this.mTargetType;
      }
      
      public function getTargetAmount() : int
      {
         return this.mTargetAmount ? int(this.mTargetAmount.value) : 0;
      }
      
      public function getTargetLevelSku() : String
      {
         return this.mTargetLevelSku;
      }
      
      public function getTargetSku() : String
      {
         return this.mTargetDungeonSku;
      }
      
      public function getTargetDifficulty() : int
      {
         return this.mTargetDungeonDifficulty;
      }
      
      public function getTargetExtraInfo() : String
      {
         return this.mTargetExtraInfo;
      }
      
      override public function getDesc() : String
      {
         if(getDescTID().indexOf("%U") != -1)
         {
            return super.getDesc();
         }
         return TextManager.replaceParameters(TextManager.getText(mDesc,true),[this.mTargetAmount.value]);
      }
      
      public function getRewardType(param1:Boolean = false) : int
      {
         return param1 ? this.mPremiumRewardType : this.mRewardType;
      }
      
      public function getRewardSkinSku(param1:Boolean = false) : String
      {
         return param1 ? this.mPremiumRewardSkinSku : this.mRewardSkinSku;
      }
      
      public function getLevelDifficulty() : int
      {
         return this.mLevelDifficulty;
      }
      
      public function getIsSecretQuest() : Boolean
      {
         return this.mIsSecretQuest == 1;
      }
      
      public function getRewardPackSku(param1:Boolean = false) : String
      {
         return param1 ? this.mPremiumRewardPackSku : this.mRewardPackSku;
      }
      
      public function getRewardJobXP() : String
      {
         return this.mRewardJobXP;
      }
      
      public function getRewardCard(param1:Boolean = false) : String
      {
         return param1 ? this.mPremiumRewardCard : this.mRewardCard;
      }
      
      public function getRewardPoints(param1:Boolean = false) : int
      {
         var _loc2_:int = 0;
         if(param1)
         {
            return this.mPremiumRewardPoints ? int(this.mPremiumRewardPoints.value) : 0;
         }
         return this.mRewardPoints ? int(this.mRewardPoints.value) : 0;
      }
      
      public function getRewardGold(param1:Boolean = false) : int
      {
         var _loc2_:int = 0;
         if(param1)
         {
            return this.mPremiumRewardGold ? int(this.mPremiumRewardGold.value) : 0;
         }
         return this.mRewardGold ? int(this.mRewardGold.value) : 0;
      }
      
      public function getRewardRaidPoints(param1:Boolean = false) : int
      {
         var _loc2_:int = 0;
         if(param1)
         {
            return this.mPremiumRewardRaidPoints ? int(this.mPremiumRewardRaidPoints.value) : 0;
         }
         return this.mRewardRaidPoints ? int(this.mRewardRaidPoints.value) : 0;
      }
      
      public function getRewardTokens(param1:Boolean = false) : int
      {
         var _loc2_:int = 0;
         if(param1)
         {
            return this.mPremiumRewardTokens ? int(this.mPremiumRewardTokens.value) : 0;
         }
         return this.mRewardTokens ? int(this.mRewardTokens.value) : 0;
      }
      
      public function isCommunityQuest() : Boolean
      {
         return this.mIsCommunityQuest;
      }
      
      public function getTooltipText() : String
      {
         return this.mTooltipText;
      }
      
      public function getTargetFactionSku() : String
      {
         return this.mTargetFactionSku;
      }
      
      public function isConsecutive() : Boolean
      {
         return this.mIsConsecutive;
      }
      
      public function hasTimedReset() : Boolean
      {
         return this.mTimedReset != null && this.mTimedReset != "";
      }
      
      public function hasWeeklyReset() : Boolean
      {
         return this.mTimedReset == "weekly";
      }
      
      public function hasDailyReset() : Boolean
      {
         return this.mTimedReset == "daily";
      }
      
      public function isBattlePassQuest() : Boolean
      {
         return this.mIsBattlePassQuest;
      }
      
      public function isBattlePassQuestEligibleBySeason() : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc1_:Boolean = false;
         if(this.mBattlePassSeason != 0)
         {
            _loc2_ = Config.smMonthNumber ? int(Config.smMonthNumber.value) : -1;
            _loc3_ = Config.smYearNumber ? int(Config.smYearNumber.value) : -1;
            if(_loc2_ != -1 && _loc3_ != -1)
            {
               return this.mBattlePassSeason == _loc2_ && (this.mBattlePassSeasonYear == _loc3_ || this.mBattlePassSeasonYear == -1);
            }
         }
         return _loc1_;
      }
      
      public function getBattlePassIndex() : int
      {
         return this.mBattlePassIndex;
      }
      
      public function getBattlePassSeason() : int
      {
         return this.mBattlePassSeason;
      }
      
      public function getBattlePassSeasonYear() : int
      {
         return this.mBattlePassSeasonYear;
      }
      
      public function getBattlePassChainIndex() : int
      {
         return this.mBattlePassChainIndex;
      }
      
      public function getBattlePassChainFamilyId() : int
      {
         return this.mBattlePassChainFamilyId;
      }
      
      public function isChainQuest() : Boolean
      {
         return this.mBattlePassChainFamilyId != -1;
      }
      
      public function getBattlePassChainFamilyQuestsAmount() : int
      {
         return InstanceMng.getQuestsDefMng().getChainQuestsAmountByFamilyId(this.mBattlePassChainFamilyId,this.mBattlePassSeason,this.mBattlePassSeasonYear);
      }
      
      public function hasReward() : Boolean
      {
         return this.mRewardType != QuestsDefMng.REWARD_TYPE_NONE;
      }
      
      public function hasPremiumReward() : Boolean
      {
         return this.mPremiumRewardType != QuestsDefMng.REWARD_TYPE_NONE;
      }
      
      public function claimReward() : void
      {
         var _loc6_:Boolean = false;
         var _loc7_:PackDef = null;
         var _loc8_:Array = null;
         var _loc9_:String = null;
         var _loc10_:int = 0;
         var _loc11_:CardDef = null;
         var _loc12_:JobDef = null;
         var _loc13_:String = null;
         var _loc1_:int = this.getRewardType();
         var _loc2_:Boolean = _loc1_ != QuestsDefMng.REWARD_TYPE_NONE;
         var _loc3_:UserData = Utils.getOwnerUserData();
         var _loc4_:Boolean = this.isBattlePassQuest();
         var _loc5_:Object = {};
         if(_loc3_)
         {
            if(_loc4_)
            {
               _loc5_["season"] = this.getBattlePassSeason();
               _loc5_["seasonYear"] = this.getBattlePassSeasonYear();
               _loc5_["battlePassIndex"] = this.getBattlePassIndex();
               _loc5_["battlePassQuestSku"] = getSku();
               _loc5_["battlePassChainIndex"] = this.getBattlePassChainIndex();
               _loc5_["battlePassChainFamilyId"] = this.getBattlePassChainFamilyId();
               _loc5_["isPremiumReward"] = false;
            }
            switch(_loc1_)
            {
               case QuestsDefMng.REWARD_TYPE_QUEST_COINS:
                  if(_loc4_)
                  {
                     InstanceMng.getServerConnection().addReward("",this.getRewardPoints(),RewardSlot.REWARD_TYPE_QUEST_COINS,_loc5_,"BATTLE_PASS");
                  }
                  else
                  {
                     _loc3_.addQuestsCoins(this.getRewardPoints());
                  }
                  break;
               case QuestsDefMng.REWARD_TYPE_CARD:
                  if(_loc4_)
                  {
                     InstanceMng.getServerConnection().addReward(this.getRewardCard(),1,RewardSlot.REWARD_TYPE_CARD,_loc5_,"BATTLE_PASS");
                  }
                  else
                  {
                     _loc3_.addCardToCollection(this.getRewardCard() + ":1");
                     _loc3_.addCardToNewCardsCollection(this.getRewardCard() + ":1");
                  }
                  break;
               case QuestsDefMng.REWARD_TYPE_PORTRAIT_SKIN:
                  if(_loc4_)
                  {
                     InstanceMng.getServerConnection().addReward(this.getRewardSkinSku(),1,RewardSlot.REWARD_TYPE_PORTRAIT_SKIN,_loc5_,"BATTLE_PASS");
                  }
                  else
                  {
                     _loc3_.addSkinToCatalog(this.getRewardSkinSku());
                     FSTracker.trackMiscAction(FSTracker.CATEGORY_QUESTS,FSTracker.ACTION_ADD_SKIN,{"skin":this.getRewardSkinSku()});
                  }
                  break;
               case QuestsDefMng.REWARD_TYPE_PACK:
                  _loc7_ = PackDef(InstanceMng.getPacksDefMng().getDefBySku(this.getRewardPackSku()));
                  if(_loc7_)
                  {
                     if(_loc4_)
                     {
                        InstanceMng.getServerConnection().addReward(this.getRewardPackSku().toUpperCase(),1,RewardSlot.REWARD_TYPE_PACK,_loc5_,"BATTLE_PASS");
                     }
                     else
                     {
                        Utils.openPack(_loc7_,PacksDefMng.PACK_QUEST_REWARD);
                        Utils.setLogText(TextManager.getText("TID_PACK_RECEIVED"));
                     }
                  }
                  break;
               case QuestsDefMng.REWARD_TYPE_RAID_COINS:
                  if(_loc4_)
                  {
                     InstanceMng.getServerConnection().addReward("",this.getRewardRaidPoints(),RewardSlot.REWARD_TYPE_RAID_POINTS,_loc5_,"BATTLE_PASS");
                  }
                  else
                  {
                     _loc3_.addRaidCoins(this.getRewardRaidPoints());
                  }
                  break;
               case QuestsDefMng.REWARD_TYPE_GOLD:
                  if(_loc4_)
                  {
                     InstanceMng.getServerConnection().addReward("",this.getRewardGold(),RewardSlot.REWARD_TYPE_GOLD,_loc5_,"BATTLE_PASS");
                  }
                  else
                  {
                     _loc3_.addGold(this.getRewardGold());
                  }
                  break;
               case QuestsDefMng.REWARD_TYPE_JOB_XP:
                  _loc8_ = this.getRewardJobXP() ? this.getRewardJobXP().split(":") : null;
                  _loc9_ = _loc8_ ? _loc8_[0] : "";
                  _loc10_ = _loc8_ ? int(_loc8_[1]) : 0;
                  if(_loc9_ != "" && _loc10_ > 0)
                  {
                     _loc12_ = JobDef(InstanceMng.getJobsDefMng().getDefBySku(_loc9_));
                     if(_loc12_)
                     {
                        JobsMng.winXPByJob(_loc12_,_loc10_);
                     }
                  }
                  break;
               case QuestsDefMng.REWARD_TYPE_UNLOCK_CRAFT:
                  _loc11_ = this.getCraftCardUnlocked();
                  if(_loc11_)
                  {
                     Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_BP_CRAFT_CARD_UNLOCKED"),[_loc11_.getName()]));
                  }
            }
            _loc6_ = false;
            if(_loc4_)
            {
               _loc6_ = this.claimBattlePassPremiumReward();
               _loc13_ = this.getBattlePassRewardClaimedText();
               if(_loc13_ != "" && _loc13_ != null)
               {
                  Utils.setLogText(_loc13_,false,false,false);
               }
            }
            if(_loc4_ && InstanceMng.getCurrentScreen() is FSMapScreen && (_loc2_ || _loc6_))
            {
               FSMapScreen(InstanceMng.getCurrentScreen()).checkRewardsToClaim();
            }
         }
      }
      
      public function claimBattlePassPremiumReward(param1:Boolean = true) : Boolean
      {
         var _loc7_:PackDef = null;
         var _loc2_:Boolean = this.isBattlePassQuest();
         if(!_loc2_)
         {
            return false;
         }
         var _loc3_:Boolean = this.hasPremiumReward();
         if(!_loc3_)
         {
            return false;
         }
         var _loc4_:Boolean = InstanceMng.getUserDataMng().getOwnerUserData().hasValidBattlePass();
         if(!_loc4_)
         {
            return false;
         }
         var _loc5_:Object = {};
         if(_loc2_)
         {
            _loc5_["season"] = this.getBattlePassSeason();
            _loc5_["seasonYear"] = this.getBattlePassSeasonYear();
            _loc5_["battlePassIndex"] = this.getBattlePassIndex();
            _loc5_["battlePassQuestSku"] = getSku();
            _loc5_["battlePassChainIndex"] = this.getBattlePassChainIndex();
            _loc5_["battlePassChainFamilyId"] = this.getBattlePassChainFamilyId();
            _loc5_["isPremiumReward"] = true;
         }
         var _loc6_:int = this.getRewardType(true);
         switch(_loc6_)
         {
            case QuestsDefMng.REWARD_TYPE_QUEST_COINS:
               InstanceMng.getServerConnection().addReward("",this.getRewardPoints(true),RewardSlot.REWARD_TYPE_QUEST_COINS,_loc5_,"BATTLE_PASS");
               break;
            case QuestsDefMng.REWARD_TYPE_CARD:
               InstanceMng.getServerConnection().addReward(this.getRewardCard(true),1,RewardSlot.REWARD_TYPE_CARD,_loc5_,"BATTLE_PASS");
               break;
            case QuestsDefMng.REWARD_TYPE_PORTRAIT_SKIN:
               InstanceMng.getServerConnection().addReward(this.getRewardSkinSku(true),1,RewardSlot.REWARD_TYPE_PORTRAIT_SKIN,_loc5_,"BATTLE_PASS");
               break;
            case QuestsDefMng.REWARD_TYPE_PACK:
               _loc7_ = PackDef(InstanceMng.getPacksDefMng().getDefBySku(this.getRewardPackSku(true)));
               if(_loc7_)
               {
                  InstanceMng.getServerConnection().addReward(this.getRewardPackSku(true).toUpperCase(),1,RewardSlot.REWARD_TYPE_PACK,_loc5_,"BATTLE_PASS");
               }
               break;
            case QuestsDefMng.REWARD_TYPE_RAID_COINS:
               InstanceMng.getServerConnection().addReward("",this.getRewardRaidPoints(true),RewardSlot.REWARD_TYPE_RAID_POINTS,_loc5_,"BATTLE_PASS");
               break;
            case QuestsDefMng.REWARD_TYPE_GOLD:
               InstanceMng.getServerConnection().addReward("",this.getRewardGold(true),RewardSlot.REWARD_TYPE_GOLD,_loc5_,"BATTLE_PASS");
         }
         if(param1 && _loc2_ && _loc3_ && _loc4_ && InstanceMng.getCurrentScreen() is FSMapScreen)
         {
            FSMapScreen(InstanceMng.getCurrentScreen()).checkRewardsToClaim();
         }
         return _loc4_;
      }
      
      public function getBattlePassRewardClaimedText() : String
      {
         var _loc1_:String = "";
         var _loc2_:String = "";
         var _loc3_:String = "";
         var _loc4_:Boolean = this.isBattlePassQuest();
         var _loc5_:int = this.getRewardType();
         var _loc6_:Boolean = _loc5_ != QuestsDefMng.REWARD_TYPE_NONE;
         var _loc7_:Boolean = this.hasPremiumReward();
         var _loc8_:int = this.getRewardType(true);
         var _loc9_:Boolean = InstanceMng.getUserDataMng().getOwnerUserData().hasValidBattlePass();
         if(_loc6_ || _loc7_)
         {
            if(_loc6_ && _loc7_)
            {
               _loc1_ = TextManager.getText("TID_REWARDS_CLAIM");
               if(!_loc9_)
               {
                  _loc2_ = " " + TextManager.getText("TID_BP_UPGRADE_NEEDED_MULTI_REWARDS");
               }
               return _loc1_ + _loc2_;
            }
            if(_loc6_ && !_loc7_)
            {
               return TextManager.getText("TID_REWARDS_CLAIM");
            }
            if(!_loc6_ && _loc7_)
            {
               if(!_loc9_)
               {
                  _loc1_ = "";
                  _loc2_ = TextManager.getText("TID_BP_UPGRADE_NEEDED_MULTI_REWARDS");
               }
               else
               {
                  _loc1_ = TextManager.getText("TID_REWARDS_CLAIM");
               }
               return _loc1_ + _loc2_;
            }
         }
         return "";
      }
      
      public function getCraftCardUnlocked() : CardDef
      {
         var _loc3_:int = 0;
         var _loc1_:CardDef = null;
         var _loc2_:Vector.<CardDef> = InstanceMng.getCardsDefMng().getAllCardsNeedingQuestToCraft();
         if(_loc2_)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               if(_loc2_[_loc3_].getCraftQuestSku() == mSku)
               {
                  return _loc2_[_loc3_];
               }
               _loc3_++;
            }
         }
         return _loc1_;
      }
   }
}

