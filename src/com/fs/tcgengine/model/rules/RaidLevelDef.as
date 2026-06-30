package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.utils.Utils;
   
   public class RaidLevelDef extends LevelDef
   {
      
      private var mParentRaidSku:String;
      
      private var mRaidLevelIndex:int;
      
      public function RaidLevelDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         super.doFromJSON(param1);
         if("raidSku" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.raidSku);
            this.mParentRaidSku = _loc3_;
         }
         if("raidLevelIndex" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.raidLevelIndex);
            this.mRaidLevelIndex = int(_loc3_);
         }
      }
      
      public function getParentRaidSku() : String
      {
         return this.mParentRaidSku;
      }
      
      public function getRaidLevelIndex() : int
      {
         return this.mRaidLevelIndex;
      }
      
      public function getRaidRewardsSummary() : Object
      {
         var _loc1_:Object = null;
         var _loc3_:Number = NaN;
         var _loc4_:Boolean = false;
         var _loc5_:Number = NaN;
         var _loc6_:Boolean = false;
         var _loc7_:Number = NaN;
         var _loc8_:Boolean = false;
         var _loc9_:int = 0;
         var _loc2_:RewardDef = RewardDef(InstanceMng.getRewardsDefMng().getDefBySku(getRewardSkuByDifficulty()));
         if(_loc2_)
         {
            _loc1_ = new Object();
            _loc3_ = _loc2_.chanceGetCard();
            _loc4_ = Utils.randomInt(0,99) < _loc3_;
            _loc1_.minCards = _loc2_.getMinCards();
            _loc1_.maxCards = _loc4_ ? _loc2_.getMaxCards() : 0;
            _loc5_ = _loc2_.chanceGetPack();
            _loc6_ = Utils.randomInt(0,99) < _loc5_;
            _loc1_.minPacks = _loc2_.getMinPacks();
            _loc1_.maxPacks = _loc6_ ? _loc2_.getMaxPacks() : 0;
            _loc7_ = _loc2_.chanceGetPortrait();
            _loc8_ = Utils.randomInt(0,99) < _loc7_;
            _loc1_.minPortraits = _loc2_.getMinPortraits();
            _loc1_.maxPortraits = _loc8_ ? _loc2_.getMaxPortraits() : 0;
            _loc1_.hasGold = _loc1_.maxGold > 0;
            _loc1_.hasCards = _loc1_.maxCards > 0;
            _loc1_.hasPacks = _loc1_.maxPacks > 0;
            _loc1_.hasPortraits = _loc1_.maxPortraits > 0;
            _loc9_ = _loc1_.hasGold ? 1 : 0;
            _loc9_ = _loc9_ + (_loc1_.hasCards ? 1 : 0);
            _loc9_ = _loc9_ + (_loc1_.hasPacks ? 1 : 0);
            _loc9_ = _loc9_ + (_loc1_.hasPortraits ? 1 : 0);
            _loc1_.totalRewards = _loc9_;
         }
         return _loc1_;
      }
      
      public function getDifficulty() : int
      {
         var _loc1_:int = -1;
         var _loc2_:RaidDef = RaidDef(InstanceMng.getRaidsDefMng().getDefBySku(this.mParentRaidSku));
         if(_loc2_)
         {
            _loc1_ = _loc2_.getDifficultyIndexByRaidLevelIndex(this.mRaidLevelIndex);
         }
         return _loc1_;
      }
      
      override public function hasBattleEvent() : Boolean
      {
         return getBattleEventSkuByDifficulty(UserDataMng.DIFFICULTY_EASY,UserData.WORLD_DEFAULT) != null && getBattleEventSkuByDifficulty(UserDataMng.DIFFICULTY_EASY,UserData.WORLD_DEFAULT) != "";
      }
   }
}

