package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.Utils;
   import flash.utils.Dictionary;
   
   public class RewardDef extends Def
   {
      
      public static const SUFFIX_CARD:String = "Card";
      
      public static const SUFFIX_PACK:String = "Pack";
      
      public static const SUFFIX_PORTRAIT:String = "Portrait";
      
      public static const REWARD_TYPE_COMMON:int = 0;
      
      public static const REWARD_TYPE_RAID:int = 1;
      
      private var mCardsArr:Array;
      
      private var mCardsCatalog:Dictionary;
      
      private var mGold:FSNumber;
      
      private var mExp:FSNumber;
      
      private var mPackSku:String;
      
      private var mMinGold:FSNumber;
      
      private var mMaxGold:FSNumber;
      
      private var mMinCards:FSNumber;
      
      private var mMaxCards:FSNumber;
      
      private var mMinPacks:FSNumber;
      
      private var mMaxPacks:FSNumber;
      
      private var mMinPortraits:FSNumber;
      
      private var mMaxPortraits:FSNumber;
      
      private var mMinSkins:FSNumber;
      
      private var mMaxSkins:FSNumber;
      
      private var mChanceGetCard:FSNumber;
      
      private var mChanceGetPack:FSNumber;
      
      private var mChanceGetPortrait:FSNumber;
      
      private var mChancesCatalog:Dictionary;
      
      private var mEditionSku:String;
      
      private var mRewardType:FSNumber;
      
      private var mRaidSku:String;
      
      private var mRaidDifficulty:FSNumber;
      
      private var mPlayerRanking:FSNumber;
      
      private var mRaidCoin:FSNumber;
      
      private var mChanceGetSkin:FSNumber;
      
      private var mSkinSku:String;
      
      public function RewardDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         super.doFromJSON(param1);
         if("cardsSku" in param1)
         {
            if(String(param1.cardsSku) != "")
            {
               _loc2_ = Utils.cleanMasterString(param1.cardsSku);
               this.setCards(_loc2_.split(","));
            }
         }
         if("gold" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gold);
            this.setGold(int(_loc2_));
         }
         if("exp" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.exp);
            this.setExp(int(_loc2_));
         }
         if("packSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.packSku);
            this.setPackSku(_loc2_);
         }
         if("minGold" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.minGold);
            if(this.mMinGold == null)
            {
               this.mMinGold = new FSNumber();
            }
            this.mMinGold.value = int(_loc2_);
         }
         if("maxGold" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.maxGold);
            if(this.mMaxGold == null)
            {
               this.mMaxGold = new FSNumber();
            }
            this.mMaxGold.value = int(_loc2_);
         }
         if("minCards" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.minCards);
            if(this.mMinCards == null)
            {
               this.mMinCards = new FSNumber();
            }
            this.mMinCards.value = int(_loc2_);
         }
         if("maxCards" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.maxCards);
            if(this.mMaxCards == null)
            {
               this.mMaxCards = new FSNumber();
            }
            this.mMaxCards.value = int(_loc2_);
         }
         if("minPacks" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.minPacks);
            if(this.mMinPacks == null)
            {
               this.mMinPacks = new FSNumber();
            }
            this.mMinPacks.value = int(_loc2_);
         }
         if("maxPacks" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.maxPacks);
            if(this.mMaxPacks == null)
            {
               this.mMaxPacks = new FSNumber();
            }
            this.mMaxPacks.value = int(_loc2_);
         }
         if("minPortraits" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.minPortraits);
            if(this.mMinPortraits == null)
            {
               this.mMinPortraits = new FSNumber();
            }
            this.mMinPortraits.value = int(_loc2_);
         }
         if("maxPortraits" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.maxPortraits);
            if(this.mMaxPortraits == null)
            {
               this.mMaxPortraits = new FSNumber();
            }
            this.mMaxPortraits.value = int(_loc2_);
         }
         if("chanceGetCard" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.chanceGetCard);
            if(this.mChanceGetCard == null)
            {
               this.mChanceGetCard = new FSNumber();
            }
            this.mChanceGetCard.value = Number(_loc2_);
         }
         if("chanceGetPack" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.chanceGetPack);
            if(this.mChanceGetPack == null)
            {
               this.mChanceGetPack = new FSNumber();
            }
            this.mChanceGetPack.value = Number(_loc2_);
         }
         if("chanceGetPortrait" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.chanceGetPortrait);
            if(this.mChanceGetPortrait == null)
            {
               this.mChanceGetPortrait = new FSNumber();
            }
            this.mChanceGetPortrait.value = Number(_loc2_);
         }
         if("editionSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.editionSku);
            this.setEditionSku(_loc2_);
         }
         if("rewardType" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.rewardType);
            this.setRewardType(int(_loc2_));
         }
         if("raidSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.raidSku);
            this.setRaidSku(_loc2_);
         }
         if("raidDifficulty" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.raidDifficulty);
            this.setRaidDifficulty(int(_loc2_));
         }
         if("playerRanking" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.playerRanking);
            this.setPlayerRanking(int(_loc2_));
         }
         if("raidPoints" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.raidPoints);
            this.setRaidCoin(int(_loc2_));
         }
         if("chanceGetSkin" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.chanceGetSkin);
            if(this.mChanceGetSkin == null)
            {
               this.mChanceGetSkin = new FSNumber();
            }
            this.mChanceGetSkin.value = Number(_loc2_);
         }
         if("skinSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.skinSku);
            this.mSkinSku = _loc2_;
         }
         if("minSkins" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.minSkins);
            if(this.mMinSkins == null)
            {
               this.mMinSkins = new FSNumber();
            }
            this.mMinSkins.value = int(_loc2_);
         }
         if("maxSkins" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.maxSkins);
            if(this.mMaxSkins == null)
            {
               this.mMaxSkins = new FSNumber();
            }
            this.mMaxSkins.value = int(_loc2_);
         }
         this.readChancesJSON(param1);
      }
      
      private function readChancesJSON(param1:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc2_:String = "chance";
         _loc3_ = SUFFIX_CARD;
         _loc5_ = param1[_loc2_ + _loc3_];
         if(_loc5_ != null)
         {
            _loc6_ = Utils.cleanMasterString(_loc5_);
            _loc4_ = _loc6_.split(",");
            this.addChance(_loc3_,_loc4_);
         }
         _loc3_ = SUFFIX_PACK;
         _loc5_ = param1[_loc2_ + _loc3_];
         if(_loc5_ != null)
         {
            _loc6_ = Utils.cleanMasterString(_loc5_);
            _loc4_ = _loc6_.split(",");
            this.addChance(_loc3_,_loc4_);
         }
         _loc3_ = SUFFIX_PORTRAIT;
         _loc5_ = param1[_loc2_ + _loc3_];
         if(_loc5_ != null)
         {
            _loc6_ = Utils.cleanMasterString(_loc5_);
            _loc4_ = _loc6_.split(",");
            this.addChance(_loc3_,_loc4_);
         }
      }
      
      private function addChance(param1:String, param2:Array) : void
      {
         if(this.mChancesCatalog == null)
         {
            this.mChancesCatalog = new Dictionary(true);
         }
         if(this.mChancesCatalog[param1] == null)
         {
            this.mChancesCatalog[param1] = param2;
         }
      }
      
      public function getRarityChancesByIndex(param1:String) : Dictionary
      {
         var _loc2_:Dictionary = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         if(this.mChancesCatalog != null)
         {
            _loc3_ = this.mChancesCatalog[param1];
            if(_loc3_ != null)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc3_.length)
               {
                  _loc4_ = _loc3_[_loc5_].indexOf(":") != -1 ? String(_loc3_[_loc5_]).split(":") : null;
                  if(_loc4_)
                  {
                     if(_loc2_ == null)
                     {
                        _loc2_ = new Dictionary(true);
                     }
                     _loc2_[_loc4_[1]] = _loc4_[0];
                  }
                  _loc5_++;
               }
            }
         }
         return _loc2_;
      }
      
      public function getChanceByRaritySkuAndIndex(param1:String, param2:String) : int
      {
         var _loc3_:int = 0;
         var _loc4_:Dictionary = this.getRarityChancesByIndex(param1);
         if(_loc4_ != null)
         {
            if(_loc4_[param2] != null)
            {
               _loc3_ = int(_loc4_[param2]);
            }
         }
         return _loc3_;
      }
      
      public function getPackChances() : Dictionary
      {
         return this.getRarityChancesByIndex(SUFFIX_PACK);
      }
      
      public function getCardChances() : Dictionary
      {
         return this.getRarityChancesByIndex(SUFFIX_CARD);
      }
      
      public function getPortraitChances() : Dictionary
      {
         return this.getRarityChancesByIndex(SUFFIX_PORTRAIT);
      }
      
      public function setCards(param1:Array) : void
      {
         this.mCardsArr = param1;
         this.mCardsCatalog = DictionaryUtils.addCards(param1,this.mCardsCatalog);
      }
      
      public function getCards() : Dictionary
      {
         return this.mCardsCatalog;
      }
      
      public function getGold() : int
      {
         return this.mGold ? int(this.mGold.value) : 0;
      }
      
      public function setGold(param1:int) : void
      {
         if(this.mGold == null)
         {
            this.mGold = new FSNumber();
         }
         this.mGold.value = param1;
      }
      
      public function getExp() : int
      {
         return this.mExp ? int(this.mExp.value) : 0;
      }
      
      public function setExp(param1:int) : void
      {
         if(this.mExp == null)
         {
            this.mExp = new FSNumber();
         }
         this.mExp.value = param1;
      }
      
      public function getCardsArr() : Array
      {
         return this.mCardsArr;
      }
      
      public function getPackSku() : String
      {
         return this.mPackSku;
      }
      
      public function setPackSku(param1:String) : void
      {
         this.mPackSku = param1;
      }
      
      public function getMinGold() : int
      {
         return this.mMinGold ? int(this.mMinGold.value) : 0;
      }
      
      public function getMinGoldEncripted() : FSNumber
      {
         return this.mMinGold ? this.mMinGold : new FSNumber(0);
      }
      
      public function getMinCards() : int
      {
         return this.mMinCards ? int(this.mMinCards.value) : 0;
      }
      
      public function getMinPacks() : int
      {
         return this.mMinPacks ? int(this.mMinPacks.value) : 0;
      }
      
      public function getMinPortraits() : int
      {
         return this.mMinPortraits ? int(this.mMinPortraits.value) : 0;
      }
      
      public function getMinSkins() : int
      {
         return this.mMinSkins ? int(this.mMinSkins.value) : 0;
      }
      
      public function getMaxGold() : int
      {
         return this.mMaxGold ? int(this.mMaxGold.value) : 0;
      }
      
      public function getMaxGoldEncripted() : FSNumber
      {
         return this.mMaxGold ? this.mMaxGold : new FSNumber(0);
      }
      
      public function getMaxCards() : int
      {
         return this.mMaxCards ? int(this.mMaxCards.value) : 0;
      }
      
      public function getMaxPacks() : int
      {
         return this.mMaxPacks ? int(this.mMaxPacks.value) : 0;
      }
      
      public function getMaxPortraits() : int
      {
         return this.mMaxPortraits ? int(this.mMaxPortraits.value) : 0;
      }
      
      public function getMaxSkins() : int
      {
         return this.mMaxSkins ? int(this.mMaxSkins.value) : 0;
      }
      
      public function chanceGetCard() : Number
      {
         return this.mChanceGetCard ? this.mChanceGetCard.value : 0;
      }
      
      public function chanceGetPack() : Number
      {
         return this.mChanceGetPack ? this.mChanceGetPack.value : 0;
      }
      
      public function chanceGetPortrait() : Number
      {
         return this.mChanceGetPortrait ? this.mChanceGetPortrait.value : 0;
      }
      
      public function getEditionSku() : String
      {
         return this.mEditionSku;
      }
      
      public function setEditionSku(param1:String) : void
      {
         this.mEditionSku = param1;
      }
      
      public function setRewardType(param1:int) : void
      {
         if(this.mRewardType == null)
         {
            this.mRewardType = new FSNumber();
         }
         this.mRewardType.value = param1;
      }
      
      public function getRewardType() : int
      {
         return this.mRewardType ? int(this.mRewardType.value) : 0;
      }
      
      public function setRaidSku(param1:String) : void
      {
         this.mRaidSku = param1;
      }
      
      public function getRaidSku() : String
      {
         return this.mRaidSku;
      }
      
      public function setRaidDifficulty(param1:int) : void
      {
         if(this.mRaidDifficulty == null)
         {
            this.mRaidDifficulty = new FSNumber();
         }
         this.mRaidDifficulty.value = param1;
      }
      
      public function getRaidDifficulty() : int
      {
         return this.mRaidDifficulty ? int(this.mRaidDifficulty.value) : 0;
      }
      
      public function setPlayerRanking(param1:int) : void
      {
         if(this.mPlayerRanking == null)
         {
            this.mPlayerRanking = new FSNumber();
         }
         this.mPlayerRanking.value = param1;
      }
      
      public function getPlayerRanking() : int
      {
         return this.mPlayerRanking ? int(this.mPlayerRanking.value) : 0;
      }
      
      public function setRaidCoin(param1:int) : void
      {
         if(this.mRaidCoin == null)
         {
            this.mRaidCoin = new FSNumber();
         }
         this.mRaidCoin.value = param1;
      }
      
      public function getRaidCoins() : int
      {
         return this.mRaidCoin ? int(this.mRaidCoin.value) : 0;
      }
      
      public function chanceGetSkin() : int
      {
         return this.mChanceGetSkin ? int(this.mChanceGetSkin.value) : 0;
      }
      
      public function getSkinSku() : String
      {
         return this.mSkinSku;
      }
   }
}

