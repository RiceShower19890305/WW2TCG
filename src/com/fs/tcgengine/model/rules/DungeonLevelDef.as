package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.utils.Utils;
   
   public class DungeonLevelDef extends LevelDef
   {
      
      private var mParentDungeonSku:String;
      
      private var mDungeonLevelIndex:int;
      
      private var mFirstDungeonLevel:Boolean;
      
      public function DungeonLevelDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         super.doFromJSON(param1);
         if("dungeonSku" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.dungeonSku);
            this.mParentDungeonSku = _loc3_;
         }
         if("dungeonLevelIndex" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.dungeonLevelIndex);
            this.mDungeonLevelIndex = int(_loc3_);
         }
         if("firstDungeonLevel" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.firstDungeonLevel);
            this.mFirstDungeonLevel = Utils.stringToBoolean(_loc3_);
         }
      }
      
      public function getParentDungeonSku() : String
      {
         return this.mParentDungeonSku;
      }
      
      public function getDungeonLevelIndex() : int
      {
         return this.mDungeonLevelIndex;
      }
      
      public function getDungeonRewardsSummary() : Object
      {
         var _loc1_:Object = null;
         var _loc3_:Number = NaN;
         var _loc4_:Boolean = false;
         var _loc5_:Number = NaN;
         var _loc6_:Boolean = false;
         var _loc7_:Number = NaN;
         var _loc8_:Boolean = false;
         var _loc9_:Number = NaN;
         var _loc10_:Boolean = false;
         var _loc11_:int = 0;
         var _loc2_:RewardDef = RewardDef(InstanceMng.getRewardsDefMng().getDefBySku(getRewardSku(UserData.WORLD_DEFAULT)));
         if(_loc2_)
         {
            _loc1_ = new Object();
            _loc1_.minGold = _loc2_.getMinGoldEncripted().value;
            _loc1_.maxGold = _loc2_.getMaxGoldEncripted().value;
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
            _loc9_ = _loc2_.chanceGetSkin();
            _loc10_ = Utils.randomInt(0,99) < _loc9_;
            _loc1_.minSkins = _loc2_.getMinSkins();
            _loc1_.maxSkins = _loc10_ ? _loc2_.getMaxSkins() : 0;
            _loc1_.hasGold = _loc1_.maxGold > 0;
            _loc1_.hasCards = _loc1_.maxCards > 0;
            _loc1_.hasPacks = _loc1_.maxPacks > 0;
            _loc1_.hasPortraits = _loc1_.maxPortraits > 0;
            _loc1_.hasSkins = _loc1_.maxSkins > 0;
            _loc11_ = _loc1_.hasGold ? 1 : 0;
            _loc11_ = _loc11_ + (_loc1_.hasCards ? 1 : 0);
            _loc11_ = _loc11_ + (_loc1_.hasPacks ? 1 : 0);
            _loc11_ = _loc11_ + (_loc1_.hasPortraits ? 1 : 0);
            _loc11_ = _loc11_ + (_loc1_.hasSkins ? 1 : 0);
            _loc1_.totalRewards = _loc11_;
         }
         return _loc1_;
      }
      
      public function isFirstDungeonLevel() : Boolean
      {
         return this.mFirstDungeonLevel;
      }
   }
}

