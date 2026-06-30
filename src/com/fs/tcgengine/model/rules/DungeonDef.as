package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.controller.DungeonsMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.Utils;
   
   public class DungeonDef extends Def
   {
      
      private var mBGMap:String;
      
      private var mBGPlayerFactionFlag:String;
      
      private var mBGAIFactionFlag:String;
      
      private var mGoldCostEasy:FSNumber;
      
      private var mGoldCostMedium:FSNumber;
      
      private var mGoldCostHard:FSNumber;
      
      private var mGoldCostExpert:FSNumber;
      
      private var mEasyLevels:Array;
      
      private var mMediumLevels:Array;
      
      private var mHardLevels:Array;
      
      private var mExpertLevels:Array;
      
      private var mMediumPackBG:String;
      
      private var mHardPackBG:String;
      
      private var mExpertPackBG:String;
      
      private var mMediumPackInfo:String;
      
      private var mHardPackInfo:String;
      
      private var mExpertPackInfo:String;
      
      private var mDungeonHeroSku:String;
      
      public function DungeonDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         super.doFromJSON(param1);
         if("bgMap" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.bgMap);
            this.mBGMap = _loc3_;
         }
         if("bgPlayerFactionFlag" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.bgPlayerFactionFlag);
            this.mBGPlayerFactionFlag = _loc3_;
         }
         if("bgAIFactionFlag" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.bgAIFactionFlag);
            this.mBGAIFactionFlag = _loc3_;
         }
         if("goldCostEasy" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.goldCostEasy);
            if(this.mGoldCostEasy == null)
            {
               this.mGoldCostEasy = new FSNumber();
            }
            this.mGoldCostEasy.value = Number(_loc3_);
         }
         if("goldCostMedium" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.goldCostMedium);
            if(this.mGoldCostMedium == null)
            {
               this.mGoldCostMedium = new FSNumber();
            }
            this.mGoldCostMedium.value = Number(_loc3_);
         }
         if("goldCostHard" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.goldCostHard);
            if(this.mGoldCostHard == null)
            {
               this.mGoldCostHard = new FSNumber();
            }
            this.mGoldCostHard.value = Number(_loc3_);
         }
         if("goldCostExpert" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.goldCostExpert);
            if(this.mGoldCostExpert == null)
            {
               this.mGoldCostExpert = new FSNumber();
            }
            this.mGoldCostExpert.value = Number(_loc3_);
         }
         if("easyLevels" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.easyLevels);
            this.mEasyLevels = String(_loc3_).split(",");
         }
         if("mediumLevels" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.mediumLevels);
            this.mMediumLevels = String(_loc3_).split(",");
         }
         if("hardLevels" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.hardLevels);
            this.mHardLevels = String(_loc3_).split(",");
         }
         if("expertLevels" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.expertLevels);
            this.mExpertLevels = String(_loc3_).split(",");
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
         if("dungeonHeroSku" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.dungeonHeroSku);
            this.mDungeonHeroSku = _loc3_;
         }
      }
      
      public function getBGMap() : String
      {
         return this.mBGMap;
      }
      
      public function getBGPlayerFactionFlag() : String
      {
         return this.mBGPlayerFactionFlag;
      }
      
      public function getBGAIFactionFlag() : String
      {
         return this.mBGAIFactionFlag;
      }
      
      public function getPackBGByDifficultyIndex(param1:int) : String
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case DungeonsMng.DUNGEON_DIFFICULTY_EASY:
               _loc2_ = "";
               break;
            case DungeonsMng.DUNGEON_DIFFICULTY_MEDIUM:
               _loc2_ = this.mMediumPackBG;
               break;
            case DungeonsMng.DUNGEON_DIFFICULTY_HARD:
               _loc2_ = this.mHardPackBG;
               break;
            case DungeonsMng.DUNGEON_DIFFICULTY_EXPERT:
               _loc2_ = this.mExpertPackBG;
               break;
            default:
               _loc2_ = "";
         }
         return _loc2_;
      }
      
      public function getPackInfoByDifficultyIndex(param1:int) : String
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case DungeonsMng.DUNGEON_DIFFICULTY_EASY:
               _loc2_ = "";
               break;
            case DungeonsMng.DUNGEON_DIFFICULTY_MEDIUM:
               _loc2_ = TextManager.getText(this.mMediumPackInfo);
               break;
            case DungeonsMng.DUNGEON_DIFFICULTY_HARD:
               _loc2_ = TextManager.getText(this.mHardPackInfo);
               break;
            case DungeonsMng.DUNGEON_DIFFICULTY_EXPERT:
               _loc2_ = TextManager.getText(this.mExpertPackInfo);
               break;
            default:
               _loc2_ = "";
         }
         return _loc2_;
      }
      
      public function getGoldCostByDifficultyIndex(param1:int) : int
      {
         var _loc2_:int = -1;
         switch(param1)
         {
            case DungeonsMng.DUNGEON_DIFFICULTY_EASY:
               _loc2_ = this.mGoldCostEasy ? int(this.mGoldCostEasy.value) : -1;
               break;
            case DungeonsMng.DUNGEON_DIFFICULTY_MEDIUM:
               _loc2_ = this.mGoldCostMedium ? int(this.mGoldCostMedium.value) : -1;
               break;
            case DungeonsMng.DUNGEON_DIFFICULTY_HARD:
               _loc2_ = this.mGoldCostHard ? int(this.mGoldCostHard.value) : -1;
               break;
            case DungeonsMng.DUNGEON_DIFFICULTY_EXPERT:
               _loc2_ = this.mGoldCostExpert ? int(this.mGoldCostExpert.value) : -1;
               break;
            default:
               _loc2_ = -1;
         }
         return _loc2_;
      }
      
      public function getGoldCostByDifficultyIndexEncripted(param1:int) : FSNumber
      {
         var _loc2_:FSNumber = new FSNumber(-1);
         switch(param1)
         {
            case DungeonsMng.DUNGEON_DIFFICULTY_EASY:
               _loc2_ = this.mGoldCostEasy ? this.mGoldCostEasy : _loc2_;
               break;
            case DungeonsMng.DUNGEON_DIFFICULTY_MEDIUM:
               _loc2_ = this.mGoldCostMedium ? this.mGoldCostMedium : _loc2_;
               break;
            case DungeonsMng.DUNGEON_DIFFICULTY_HARD:
               _loc2_ = this.mGoldCostHard ? this.mGoldCostHard : _loc2_;
               break;
            case DungeonsMng.DUNGEON_DIFFICULTY_EXPERT:
               _loc2_ = this.mGoldCostExpert ? this.mGoldCostExpert : _loc2_;
         }
         return _loc2_;
      }
      
      public function getLevelsByDifficultyIndex(param1:int) : Array
      {
         var _loc2_:Array = null;
         switch(param1)
         {
            case DungeonsMng.DUNGEON_DIFFICULTY_EASY:
               _loc2_ = this.mEasyLevels;
               break;
            case DungeonsMng.DUNGEON_DIFFICULTY_MEDIUM:
               _loc2_ = this.mMediumLevels;
               break;
            case DungeonsMng.DUNGEON_DIFFICULTY_HARD:
               _loc2_ = this.mHardLevels;
               break;
            case DungeonsMng.DUNGEON_DIFFICULTY_EXPERT:
               _loc2_ = this.mExpertLevels;
         }
         return _loc2_;
      }
      
      public function getTotalRewardsByDifficultyIndex(param1:int) : Array
      {
         var _loc4_:int = 0;
         var _loc5_:DungeonLevelDef = null;
         var _loc6_:RewardDef = null;
         var _loc2_:Array = null;
         var _loc3_:Array = this.getLevelsByDifficultyIndex(param1);
         if(_loc3_)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc5_ = DungeonLevelDef(InstanceMng.getDungeonLevelsDefMng().getLevelDefByLevelIndex(_loc3_[_loc4_]));
               if(_loc5_)
               {
                  _loc6_ = RewardDef(InstanceMng.getRewardsDefMng().getDefBySku(_loc5_.getRewardSku(UserData.WORLD_DEFAULT)));
                  if(_loc6_)
                  {
                     if(_loc2_ == null)
                     {
                        _loc2_ = new Array();
                     }
                     _loc2_.push(_loc6_);
                  }
               }
               _loc4_++;
            }
         }
         return _loc2_;
      }
      
      public function getRewardsSummaryByDifficultyIndex(param1:int) : Object
      {
         var _loc2_:Object = null;
         var _loc4_:FSNumber = null;
         var _loc5_:FSNumber = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc3_:Array = this.getTotalRewardsByDifficultyIndex(param1);
         if(_loc3_)
         {
            _loc4_ = new FSNumber();
            _loc5_ = new FSNumber();
            _loc14_ = 0;
            while(_loc14_ < _loc3_.length)
            {
               if(RewardDef(_loc3_[_loc14_]) != null)
               {
                  _loc4_.value += RewardDef(_loc3_[_loc14_]).getMinGoldEncripted().value;
                  _loc5_.value += RewardDef(_loc3_[_loc14_]).getMaxGoldEncripted().value;
                  _loc6_ += RewardDef(_loc3_[_loc14_]).getMinCards();
                  _loc7_ += RewardDef(_loc3_[_loc14_]).getMaxCards();
                  _loc8_ += RewardDef(_loc3_[_loc14_]).getMinPacks();
                  _loc9_ += RewardDef(_loc3_[_loc14_]).getMaxPacks();
                  _loc10_ += RewardDef(_loc3_[_loc14_]).getMinPortraits();
                  _loc11_ += RewardDef(_loc3_[_loc14_]).getMaxPortraits();
                  _loc12_ += RewardDef(_loc3_[_loc14_]).getMinSkins();
                  _loc13_ += RewardDef(_loc3_[_loc14_]).getMaxSkins();
               }
               _loc14_++;
            }
            _loc2_ = new Object();
            _loc2_.minGold = _loc4_.value;
            _loc2_.maxGold = _loc5_.value;
            _loc2_.minCards = _loc6_;
            _loc2_.maxCards = _loc7_;
            _loc2_.minPacks = _loc8_;
            _loc2_.maxPacks = _loc9_;
            _loc2_.minPortraits = _loc10_;
            _loc2_.maxPortraits = _loc11_;
            _loc2_.minSkins = _loc12_;
            _loc2_.maxSkins = _loc13_;
            _loc2_.hasGold = _loc5_.value > 0;
            _loc2_.hasCards = _loc7_ > 0;
            _loc2_.hasPacks = _loc9_ > 0;
            _loc2_.hasPortraits = _loc11_ > 0;
            _loc2_.hasSkins = _loc13_ > 0;
            _loc15_ = _loc2_.hasGold ? 1 : 0;
            _loc15_ = _loc15_ + (_loc2_.hasCards ? 1 : 0);
            _loc15_ = _loc15_ + (_loc2_.hasPacks ? 1 : 0);
            _loc15_ = _loc15_ + (_loc2_.hasPortraits ? 1 : 0);
            _loc15_ = _loc15_ + (_loc2_.hasSkins ? 1 : 0);
            _loc2_.totalRewards = _loc15_;
         }
         return _loc2_;
      }
      
      private function setDungeonHeroSku(param1:String) : void
      {
         this.mDungeonHeroSku = param1;
      }
      
      public function getDungeonHeroSku() : String
      {
         return this.mDungeonHeroSku;
      }
   }
}

