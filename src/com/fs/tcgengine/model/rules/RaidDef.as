package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.RaidsMng;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.Utils;
   
   public class RaidDef extends Def
   {
      
      private var mUnlockCost:FSNumber;
      
      private var mKeyCostEasy:FSNumber;
      
      private var mKeyCostMedium:FSNumber;
      
      private var mKeyCostHard:FSNumber;
      
      private var mKeyCostExpert:FSNumber;
      
      private var mEasyLevels:FSNumber;
      
      private var mMediumLevels:FSNumber;
      
      private var mHardLevels:FSNumber;
      
      private var mExpertLevels:FSNumber;
      
      private var mEasyPackBG:String;
      
      private var mMediumPackBG:String;
      
      private var mHardPackBG:String;
      
      private var mExpertPackBG:String;
      
      private var mEasyPackInfo:String;
      
      private var mMediumPackInfo:String;
      
      private var mHardPackInfo:String;
      
      private var mExpertPackInfo:String;
      
      private var mEventBattleEasy:String;
      
      private var mEventBattleMedium:String;
      
      private var mEventBattleHard:String;
      
      private var mEventBattleExpert:String;
      
      private var mIsMultiPlayer:int;
      
      private var mBgLockName:String;
      
      public function RaidDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         super.doFromJSON(param1);
         if("unlockCost" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.unlockCost);
            if(this.mUnlockCost == null)
            {
               this.mUnlockCost = new FSNumber();
            }
            this.mUnlockCost.value = Number(_loc3_);
         }
         if("keyCostEasy" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.keyCostEasy);
            if(this.mKeyCostEasy == null)
            {
               this.mKeyCostEasy = new FSNumber();
            }
            this.mKeyCostEasy.value = Number(_loc3_);
         }
         if("keyCostMedium" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.keyCostMedium);
            if(this.mKeyCostMedium == null)
            {
               this.mKeyCostMedium = new FSNumber();
            }
            this.mKeyCostMedium.value = Number(_loc3_);
         }
         if("keyCostHard" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.keyCostHard);
            if(this.mKeyCostHard == null)
            {
               this.mKeyCostHard = new FSNumber();
            }
            this.mKeyCostHard.value = Number(_loc3_);
         }
         if("keyCostExpert" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.keyCostExpert);
            if(this.mKeyCostExpert == null)
            {
               this.mKeyCostExpert = new FSNumber();
            }
            this.mKeyCostExpert.value = Number(_loc3_);
         }
         if("easyLevels" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.easyLevels);
            if(this.mEasyLevels == null)
            {
               this.mEasyLevels = new FSNumber();
            }
            this.mEasyLevels.value = Number(_loc3_);
         }
         if("mediumLevels" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.mediumLevels);
            if(this.mMediumLevels == null)
            {
               this.mMediumLevels = new FSNumber();
            }
            this.mMediumLevels.value = Number(_loc3_);
         }
         if("hardLevels" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.hardLevels);
            if(this.mHardLevels == null)
            {
               this.mHardLevels = new FSNumber();
            }
            this.mHardLevels.value = Number(_loc3_);
         }
         if("expertLevels" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.expertLevels);
            if(this.mExpertLevels == null)
            {
               this.mExpertLevels = new FSNumber();
            }
            this.mExpertLevels.value = Number(_loc3_);
         }
         if("easyPackBG" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.easyPackBG);
            this.mEasyPackBG = _loc3_;
         }
         if("mediumPackBG" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.mediumPackBG);
            this.mMediumPackBG = _loc3_;
         }
         if("hardPackBG" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.hardPackBG);
            this.mHardPackBG = _loc3_;
         }
         if("expertPackBG" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.expertPackBG);
            this.mExpertPackBG = _loc3_;
         }
         if("easyPackInfo" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.easyPackInfo);
            this.mEasyPackInfo = _loc3_;
         }
         if("mediumPackInfo" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.mediumPackInfo);
            this.mMediumPackInfo = _loc3_;
         }
         if("hardPackInfo" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.hardPackInfo);
            this.mHardPackInfo = _loc3_;
         }
         if("expertPackInfo" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.expertPackInfo);
            this.mExpertPackInfo = _loc3_;
         }
         if("eventBattleEasy" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.eventBattleEasy);
            this.mEventBattleEasy = _loc3_;
         }
         if("eventBattleMedium" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.eventBattleMedium);
            this.mEventBattleMedium = _loc3_;
         }
         if("eventBattleHard" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.eventBattleHard);
            this.mEventBattleHard = _loc3_;
         }
         if("eventBattleExpert" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.eventBattleExpert);
            this.mEventBattleExpert = _loc3_;
         }
         if("isRaid" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.isRaid);
            this.mIsMultiPlayer = int(_loc3_);
         }
         if("bgLock" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.bgLock);
            this.mBgLockName = _loc3_;
         }
      }
      
      public function getPackBGByDifficultyIndex(param1:int) : String
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case RaidsMng.RAID_DIFFICULTY_EASY:
               _loc2_ = this.mEasyPackBG;
               break;
            case RaidsMng.RAID_DIFFICULTY_MEDIUM:
               _loc2_ = this.mMediumPackBG;
               break;
            case RaidsMng.RAID_DIFFICULTY_HARD:
               _loc2_ = this.mHardPackBG;
               break;
            case RaidsMng.RAID_DIFFICULTY_EXPERT:
               _loc2_ = this.mExpertPackBG;
               break;
            default:
               _loc2_ = "";
         }
         return _loc2_;
      }
      
      public function getSPVGoodPackRewardByDifficulty(param1:int) : String
      {
         if(Boolean(ServerConnection.smServerRaidsSPRewardsDefs) && ServerConnection.smServerRaidsSPRewardsDefs[getIndex() + 1]["Difficulty"][param1] != null)
         {
            return ServerConnection.smServerRaidsSPRewardsDefs[getIndex() + 1]["Difficulty"][param1]["vGood"];
         }
         return "";
      }
      
      public function getPackInfoByDifficultyIndex(param1:int) : String
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case RaidsMng.RAID_DIFFICULTY_EASY:
               _loc2_ = TextManager.getText(this.mEasyPackInfo);
               break;
            case RaidsMng.RAID_DIFFICULTY_MEDIUM:
               _loc2_ = TextManager.getText(this.mMediumPackInfo);
               break;
            case RaidsMng.RAID_DIFFICULTY_HARD:
               _loc2_ = TextManager.getText(this.mHardPackInfo);
               break;
            case RaidsMng.RAID_DIFFICULTY_EXPERT:
               _loc2_ = TextManager.getText(this.mExpertPackInfo);
               break;
            default:
               _loc2_ = "";
         }
         return _loc2_;
      }
      
      public function getLevelsByDifficultyIndex(param1:int) : int
      {
         var _loc2_:int = 0;
         switch(param1)
         {
            case RaidsMng.RAID_DIFFICULTY_EASY:
               _loc2_ = this.mEasyLevels.value;
               break;
            case RaidsMng.RAID_DIFFICULTY_MEDIUM:
               _loc2_ = this.mMediumLevels.value;
               break;
            case RaidsMng.RAID_DIFFICULTY_HARD:
               _loc2_ = this.mHardLevels.value;
               break;
            case RaidsMng.RAID_DIFFICULTY_EXPERT:
               _loc2_ = this.mExpertLevels.value;
         }
         return _loc2_;
      }
      
      public function getUnlockCost() : Number
      {
         if(this.mUnlockCost)
         {
            return this.mUnlockCost.value;
         }
         return 0;
      }
      
      public function getTotalRewardsByDifficultyIndex(param1:int) : Array
      {
         var _loc3_:RaidLevelDef = null;
         var _loc4_:RewardDef = null;
         var _loc2_:Array = null;
         var _loc5_:int = this.getLevelsByDifficultyIndex(param1);
         _loc3_ = RaidLevelDef(InstanceMng.getRaidLevelsDefMng().getLevelDefByLevelIndex(_loc5_));
         if(_loc3_)
         {
            _loc4_ = RewardDef(InstanceMng.getRewardsDefMng().getDefBySku(_loc3_.getRewardSkuByDifficulty()));
            if(_loc4_)
            {
               if(_loc2_ == null)
               {
                  _loc2_ = new Array();
               }
               _loc2_.push(_loc4_);
            }
         }
         return _loc2_;
      }
      
      private function getRewardsSummaryByDifficultyIndexViaServer(param1:Object) : Object
      {
         var _loc2_:Object = null;
         var _loc3_:Boolean = false;
         var _loc4_:Number = NaN;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         _loc2_ = param1;
         if(_loc2_)
         {
            _loc3_ = Config.getConfig().hasSkins();
            _loc4_ = _loc2_.hasOwnProperty("hasExtra") ? Number(_loc2_["hasExtra"]) : 0;
            _loc5_ = _loc2_.hasOwnProperty("extra") && _loc2_["extra"] != null && _loc2_["extra"] != "";
            _loc6_ = !_loc3_ && _loc4_ == 1 ? 1 : 0;
            _loc7_ = !_loc3_ && _loc5_ ? 1 : 0;
            _loc8_ = _loc3_ && _loc4_ == 1 ? 1 : 0;
            _loc9_ = _loc3_ && _loc5_ ? 1 : 0;
            _loc2_.minGold = _loc2_["goldFactor"];
            _loc2_.maxGold = _loc2_["goldFactor"] * 2;
            _loc2_.minCards = 0;
            _loc2_.maxCards = 0;
            _loc2_.minPacks = 1;
            _loc2_.maxPacks = 1;
            _loc2_.raidCoin = _loc2_["raidPoints"];
            _loc2_.minPortraits = _loc6_;
            _loc2_.maxPortraits = _loc7_;
            _loc2_.minSkins = _loc8_;
            _loc2_.maxSkins = _loc9_;
            _loc2_.hasGold = _loc2_.minGold > 0;
            _loc2_.hasCards = 0;
            _loc2_.hasPacks = 1;
            _loc2_.hasRaidCoin = _loc2_.raidCoin > 0;
            _loc2_.hasPortraits = _loc7_ > 0;
            _loc2_.hasSkins = _loc9_ > 0;
            _loc10_ = _loc2_.hasGold ? 1 : 0;
            _loc10_ = _loc10_ + (_loc2_.hasCards ? 1 : 0);
            _loc10_ = _loc10_ + (_loc2_.hasPacks ? 1 : 0);
            _loc10_ = _loc10_ + (_loc2_.hasRaidCoin ? 1 : 0);
            _loc10_ = _loc10_ + (_loc2_.hasPortraits ? 1 : 0);
            _loc10_ = _loc10_ + (_loc2_.hasSkins ? 1 : 0);
            _loc2_.totalRewards = _loc10_;
         }
         return _loc2_;
      }
      
      public function getRewardsSummaryByDifficultyIndex(param1:int) : Object
      {
         var _loc2_:Object = null;
         var _loc6_:FSNumber = null;
         var _loc7_:FSNumber = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc3_:Object = this.mIsMultiPlayer ? ServerConnection.smServerRaidsMPRewardsDefs : ServerConnection.smServerRaidsSPRewardsDefs;
         var _loc4_:int = getIndex();
         if(_loc3_ != null)
         {
            if(this.mIsMultiPlayer)
            {
               if(_loc3_[_loc4_ + 1]["Difficulty"][param1]["positions"][0] != null)
               {
                  return this.getRewardsSummaryByDifficultyIndexViaServer(_loc3_[_loc4_ + 1]["Difficulty"][param1]["positions"][0]);
               }
            }
            else if(_loc3_[_loc4_ + 1]["Difficulty"][param1] != null)
            {
               return this.getRewardsSummaryByDifficultyIndexViaServer(_loc3_[_loc4_ + 1]["Difficulty"][param1]);
            }
         }
         var _loc5_:Array = this.getTotalRewardsByDifficultyIndex(param1);
         if(_loc5_)
         {
            _loc6_ = new FSNumber();
            _loc7_ = new FSNumber();
            _loc17_ = 0;
            while(_loc17_ < _loc5_.length)
            {
               if(RewardDef(_loc5_[_loc17_]) != null)
               {
                  _loc6_.value += RewardDef(_loc5_[_loc17_]).getMinGoldEncripted().value;
                  _loc7_.value += RewardDef(_loc5_[_loc17_]).getMaxGoldEncripted().value;
                  _loc8_ += RewardDef(_loc5_[_loc17_]).getMinCards();
                  _loc9_ += RewardDef(_loc5_[_loc17_]).getMaxCards();
                  _loc10_ += RewardDef(_loc5_[_loc17_]).getMinPacks();
                  _loc11_ += RewardDef(_loc5_[_loc17_]).getMaxPacks();
                  _loc12_ += RewardDef(_loc5_[_loc17_]).getRaidCoins();
                  _loc13_ += RewardDef(_loc5_[_loc17_]).getMinPortraits();
                  _loc14_ += RewardDef(_loc5_[_loc17_]).getMaxPortraits();
                  _loc15_ += RewardDef(_loc5_[_loc17_]).getMinSkins();
                  _loc16_ += RewardDef(_loc5_[_loc17_]).getMaxSkins();
               }
               _loc17_++;
            }
            _loc2_ = new Object();
            _loc2_.minGold = _loc6_.value;
            _loc2_.maxGold = _loc7_.value;
            _loc2_.minCards = _loc8_;
            _loc2_.maxCards = _loc9_;
            _loc2_.minPacks = _loc10_;
            _loc2_.maxPacks = _loc11_;
            _loc2_.raidCoin = _loc12_;
            _loc2_.minPortraits = _loc13_;
            _loc2_.maxPortraits = _loc14_;
            _loc2_.minSkins = _loc15_;
            _loc2_.maxSkins = _loc16_;
            _loc2_.hasGold = _loc7_.value > 0;
            _loc2_.hasCards = _loc9_ > 0;
            _loc2_.hasPacks = _loc11_ > 0;
            _loc2_.hasRaidCoin = _loc12_ > 0;
            _loc2_.hasPortraits = _loc14_ > 0;
            _loc2_.hasSkins = _loc16_ > 0;
            _loc18_ = _loc2_.hasGold ? 1 : 0;
            _loc18_ = _loc18_ + (_loc2_.hasCards ? 1 : 0);
            _loc18_ = _loc18_ + (_loc2_.hasPacks ? 1 : 0);
            _loc18_ = _loc18_ + (_loc2_.hasRaidCoin ? 1 : 0);
            _loc18_ = _loc18_ + (_loc2_.hasPortraits ? 1 : 0);
            _loc18_ = _loc18_ + (_loc2_.hasSkins ? 1 : 0);
            _loc2_.totalRewards = _loc18_;
         }
         return _loc2_;
      }
      
      public function getIsMultiPlayer() : Boolean
      {
         if(this.mIsMultiPlayer == 1)
         {
            return true;
         }
         return false;
      }
      
      public function getBgLock() : String
      {
         return this.mBgLockName;
      }
      
      public function getKeyCostByDifficultyIndex(param1:int) : Number
      {
         var _loc2_:int = 0;
         switch(param1)
         {
            case RaidsMng.RAID_DIFFICULTY_EASY:
               _loc2_ = this.mKeyCostEasy.value;
               break;
            case RaidsMng.RAID_DIFFICULTY_MEDIUM:
               _loc2_ = this.mKeyCostMedium.value;
               break;
            case RaidsMng.RAID_DIFFICULTY_HARD:
               _loc2_ = this.mKeyCostHard.value;
               break;
            case RaidsMng.RAID_DIFFICULTY_EXPERT:
               _loc2_ = this.mKeyCostExpert.value;
         }
         return _loc2_;
      }
      
      public function getBattleEventByDifficultyIndex(param1:int) : BattleEventDef
      {
         var _loc2_:BattleEventDef = null;
         var _loc3_:RaidLevelDef = RaidLevelDef(InstanceMng.getRaidLevelsDefMng().getLevelDefByLevelIndex(this.getLevelsByDifficultyIndex(param1)));
         switch(param1)
         {
            case RaidsMng.RAID_DIFFICULTY_EASY:
               _loc2_ = BattleEventDef(InstanceMng.getBattleEventDefMng().getDefBySku(_loc3_.getBattleEventsSku(UserData.WORLD_DEFAULT)));
               break;
            case RaidsMng.RAID_DIFFICULTY_MEDIUM:
               _loc2_ = BattleEventDef(InstanceMng.getBattleEventDefMng().getDefBySku(_loc3_.getBattleEventsSku(UserData.WORLD_DEFAULT)));
               break;
            case RaidsMng.RAID_DIFFICULTY_HARD:
               _loc2_ = BattleEventDef(InstanceMng.getBattleEventDefMng().getDefBySku(_loc3_.getBattleEventsSku(UserData.WORLD_DEFAULT)));
               break;
            case RaidsMng.RAID_DIFFICULTY_EXPERT:
               _loc2_ = BattleEventDef(InstanceMng.getBattleEventDefMng().getDefBySku(_loc3_.getBattleEventsSku(UserData.WORLD_DEFAULT)));
               break;
            default:
               _loc2_ = BattleEventDef(InstanceMng.getBattleEventDefMng().getDefBySku(_loc3_.getBattleEventsSku(UserData.WORLD_DEFAULT)));
         }
         return _loc2_;
      }
      
      public function getDifficultyIndexByRaidLevelIndex(param1:int) : int
      {
         var _loc2_:int = 0;
         if(this.mEasyLevels.value == param1)
         {
            _loc2_ = 0;
         }
         else if(this.mMediumLevels.value == param1)
         {
            _loc2_ = 1;
         }
         else if(this.mHardLevels.value == param1)
         {
            _loc2_ = 2;
         }
         else if(this.mExpertLevels.value == param1)
         {
            _loc2_ = 3;
         }
         return _loc2_;
      }
   }
}

