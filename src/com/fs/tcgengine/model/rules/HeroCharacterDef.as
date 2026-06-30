package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.Utils;
   
   public class HeroCharacterDef extends Def
   {
      
      private var mRankSku:String;
      
      private var mIsEnemy:Boolean;
      
      private var mPortraitSku:String;
      
      private var mIsSkin:Boolean;
      
      private var mSkinRarityIndex:int;
      
      private var mSkinParticlesSku:String;
      
      private var mUnlockType:int;
      
      private var mCostsGold:Boolean;
      
      private var mGold:FSNumber;
      
      private var mPvPSeasonReward:Array;
      
      private var mDungeonSeasonReward:Array;
      
      private var mJobSku:String;
      
      private var mGreetingsVoice:String = "";
      
      public function HeroCharacterDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         if("rankSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.rankSku);
            this.setRankSku(_loc2_);
         }
         if("isEnemy" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.isEnemy);
            this.setIsEnemy(Utils.stringToBoolean(_loc2_));
         }
         if("portraitSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.portraitSku);
            this.setPortraitSku(_loc2_);
         }
         if("isSkin" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.isSkin);
            this.mIsSkin = Utils.stringToBoolean(_loc2_);
         }
         if("skinRarity" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.skinRarity);
            this.mSkinRarityIndex = int(_loc2_);
         }
         if("skinParticlesSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.skinParticlesSku);
            this.mSkinParticlesSku = _loc2_;
         }
         if("unlockType" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.unlockType);
            this.mUnlockType = int(_loc2_);
         }
         if("costsGold" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.costsGold);
            this.mCostsGold = Utils.stringToBoolean(_loc2_);
         }
         if("gold" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gold);
            this.setGold(int(_loc2_));
         }
         if("pvpSeasonRewards" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.pvpSeasonRewards);
            this.setPvPSeasonRewards(_loc2_.split(","));
         }
         if("dungeonSeasonRewards" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.dungeonSeasonRewards);
            this.setDungeonSeasonRewards(_loc2_.split(","));
         }
         if("jobSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.jobSku);
            this.mJobSku = _loc2_;
         }
         if("voiceGreetings" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.voiceGreetings);
            this.mGreetingsVoice = _loc2_;
         }
      }
      
      private function setGold(param1:int) : void
      {
         if(this.mGold == null)
         {
            this.mGold = new FSNumber();
         }
         this.mGold.value = param1;
      }
      
      private function setRankSku(param1:String) : void
      {
         this.mRankSku = param1;
      }
      
      public function getRankSku() : String
      {
         return this.mRankSku;
      }
      
      private function setIsEnemy(param1:Boolean) : void
      {
         this.mIsEnemy = param1;
      }
      
      public function isEnemy() : Boolean
      {
         return this.mIsEnemy;
      }
      
      private function setPortraitSku(param1:String) : void
      {
         this.mPortraitSku = param1;
      }
      
      public function getPortraitSku() : String
      {
         return this.mPortraitSku;
      }
      
      public function isSkin() : Boolean
      {
         return this.mIsSkin;
      }
      
      public function getUnlockType() : int
      {
         return this.mUnlockType;
      }
      
      public function getCostsGold() : Boolean
      {
         return this.mCostsGold;
      }
      
      public function getGold() : int
      {
         return this.mGold ? int(this.mGold.value) : 0;
      }
      
      private function setPvPSeasonRewards(param1:Array) : void
      {
         this.mPvPSeasonReward = param1;
      }
      
      private function setDungeonSeasonRewards(param1:Array) : void
      {
         this.mDungeonSeasonReward = param1;
      }
      
      public function getPvPSeasonRewards() : Array
      {
         return this.mPvPSeasonReward;
      }
      
      public function getDungeonSeasonRewards() : Array
      {
         return this.mDungeonSeasonReward;
      }
      
      public function getSkinRarityIndex() : int
      {
         return this.mSkinRarityIndex;
      }
      
      public function getSkinParticlesSku() : String
      {
         return this.mSkinParticlesSku;
      }
      
      public function getJobSku() : String
      {
         return this.mJobSku;
      }
      
      public function getGreetingsVoice() : String
      {
         return this.mGreetingsVoice;
      }
   }
}

