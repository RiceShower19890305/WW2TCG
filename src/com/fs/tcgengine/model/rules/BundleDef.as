package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.utils.Utils;
   
   public class BundleDef extends Def
   {
      
      private var mGold:int = 0;
      
      private var mQuestPoints:int = 0;
      
      private var mRaidPoints:int = 0;
      
      private var mAHTokens:int = 0;
      
      private var mCards:Array;
      
      private var mPacks:Array;
      
      private var mSkins:Array;
      
      private var mBoosts:Array;
      
      private var mDuration:Number = 1;
      
      private var mUnlockedByQuest:String = "";
      
      private var mDiscount:int = 0;
      
      private var mUnique:Boolean;
      
      private var mChestBG:String;
      
      private var mManualId:String;
      
      private var mManualExpirationTimeMS:Number;
      
      private var mIsRepurchasable:Boolean = false;
      
      private var mIsWelcomeBackBundle:Boolean = false;
      
      public function BundleDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         super.doFromJSON(param1);
         if("gold" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gold);
            this.mGold = int(_loc2_);
         }
         if("questPoints" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.questPoints);
            this.mQuestPoints = int(_loc2_);
         }
         if("raidPoints" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.raidPoints);
            this.mRaidPoints = int(_loc2_);
         }
         if("tokens" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.tokens);
            this.mAHTokens = int(_loc2_);
         }
         if("cards" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.cards);
            this.mCards = processAttributeArr(this.mCards,_loc2_,",");
         }
         if("packs" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.packs);
            this.mPacks = processAttributeArr(this.mPacks,_loc2_,",");
         }
         if("skins" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.skins);
            this.mSkins = processAttributeArr(this.mSkins,_loc2_,",");
         }
         if("boosts" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.boosts);
            this.mBoosts = processAttributeArr(this.mBoosts,_loc2_,",");
         }
         if("duration" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.duration);
            this.mDuration = Number(_loc2_);
         }
         if("unlockedByQuest" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.unlockedByQuest);
            this.mUnlockedByQuest = String(_loc2_);
         }
         if("discount" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.discount);
            this.mDiscount = int(_loc2_);
         }
         if("unique" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.unique);
            this.mUnique = Utils.stringToBoolean(_loc2_);
         }
         if("chestBG" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.chestBG);
            this.mChestBG = _loc2_;
         }
         if("isWelcomeBack" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.isWelcomeBack);
            this.mIsWelcomeBackBundle = Utils.stringToBoolean(_loc2_);
         }
      }
      
      public function getGold() : int
      {
         return this.mGold;
      }
      
      public function getQuestPoints() : int
      {
         return this.mQuestPoints;
      }
      
      public function getRaidPoints() : int
      {
         return this.mRaidPoints;
      }
      
      public function getAHTokens() : int
      {
         return this.mAHTokens;
      }
      
      public function getCards() : Array
      {
         return this.mCards;
      }
      
      public function getPacks() : Array
      {
         return this.mPacks;
      }
      
      public function getSkins() : Array
      {
         return this.mSkins;
      }
      
      public function getBoosts() : Array
      {
         return this.mBoosts;
      }
      
      public function getDuration() : Number
      {
         return this.mDuration;
      }
      
      public function getUnlockedByQuest() : String
      {
         return this.mUnlockedByQuest;
      }
      
      public function getDiscount() : int
      {
         return this.mDiscount;
      }
      
      public function isUnique() : Boolean
      {
         return this.mUnique;
      }
      
      public function getChestBG() : String
      {
         return this.mChestBG;
      }
      
      public function getBoostsAmount(param1:String) : int
      {
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         if(Boolean(this.mBoosts) && this.mBoosts.length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < this.mBoosts.length)
            {
               if(String(this.mBoosts[_loc3_]).split(":")[0] == param1)
               {
                  return String(this.mBoosts[_loc3_]).split(":")[1];
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      public function getManualId() : String
      {
         return this.mManualId;
      }
      
      public function getItemsList() : Array
      {
         var _loc2_:int = 0;
         var _loc1_:Array = new Array();
         if(Boolean(this.mPacks) && this.mPacks.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mPacks.length)
            {
               _loc1_.push(PackDef(InstanceMng.getPacksDefMng().getDefBySku(this.mPacks[_loc2_])));
               _loc2_++;
            }
         }
         if(Boolean(this.mCards) && this.mCards.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mCards.length)
            {
               _loc1_.push(CardDef(InstanceMng.getCardsDefMng().getDefBySku(this.mCards[_loc2_])));
               _loc2_++;
            }
         }
         if(Boolean(this.mSkins) && this.mSkins.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mSkins.length)
            {
               _loc1_.push(HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(this.mSkins[_loc2_])));
               _loc2_++;
            }
         }
         if(Boolean(this.mBoosts) && this.mBoosts.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mBoosts.length)
            {
               _loc1_.push(BoostDef(InstanceMng.getBoostsDefMng().getDefBySku(String(this.mBoosts[_loc2_]).split(":")[0])));
               _loc2_++;
            }
         }
         if(this.mGold > 0)
         {
            _loc1_.push({
               "currency":ServerConnection.CURRENCY_GOLD,
               "amount":this.mGold
            });
         }
         if(this.mRaidPoints > 0)
         {
            _loc1_.push({
               "currency":ServerConnection.CURRENCY_RAID_COINS,
               "amount":this.mRaidPoints
            });
         }
         if(this.mQuestPoints > 0)
         {
            _loc1_.push({
               "currency":ServerConnection.CURRENCY_QUEST_COINS,
               "amount":this.mQuestPoints
            });
         }
         if(this.mAHTokens > 0)
         {
            _loc1_.push({
               "currency":ServerConnection.CURRENCY_AH_TOKENS,
               "amount":this.mAHTokens
            });
         }
         return _loc1_;
      }
      
      public function setGold(param1:int) : void
      {
         this.mGold = param1;
      }
      
      public function setQuestPoints(param1:int) : void
      {
         this.mQuestPoints = param1;
      }
      
      public function setRaidPoints(param1:int) : void
      {
         this.mRaidPoints = param1;
      }
      
      public function setAHTokens(param1:int) : void
      {
         this.mAHTokens = param1;
      }
      
      public function setCards(param1:String) : void
      {
         if(this.mCards)
         {
            this.mCards.length = 0;
         }
         this.mCards = processAttributeArr(this.mCards,param1,",");
      }
      
      public function setPacks(param1:String) : void
      {
         if(this.mPacks)
         {
            this.mPacks.length = 0;
         }
         this.mPacks = processAttributeArr(this.mPacks,param1,",");
      }
      
      public function setSkins(param1:String) : void
      {
         if(this.mSkins)
         {
            this.mSkins.length = 0;
         }
         this.mSkins = processAttributeArr(this.mSkins,param1,",");
      }
      
      public function setBoosts(param1:String) : void
      {
         if(this.mBoosts)
         {
            this.mBoosts.length = 0;
         }
         this.mBoosts = processAttributeArr(this.mBoosts,param1,",");
      }
      
      public function setDiscount(param1:int) : void
      {
         this.mDiscount = param1;
      }
      
      public function setManualId(param1:String) : void
      {
         this.mManualId = param1;
      }
      
      public function setChestBG(param1:String) : void
      {
         this.mChestBG = param1;
      }
      
      public function setExpirationTimeMS(param1:Number) : void
      {
         this.mManualExpirationTimeMS = param1;
      }
      
      public function getExpirationTimeMS() : Number
      {
         return this.mManualExpirationTimeMS;
      }
      
      public function isManualOffer() : Boolean
      {
         return mSku.indexOf("bundle_manual") != -1;
      }
      
      public function setIsRepurchasable(param1:Boolean) : void
      {
         this.mIsRepurchasable = param1;
      }
      
      public function isRepurchasable() : Boolean
      {
         return this.mIsRepurchasable;
      }
      
      public function isWelcomeBackBundle() : Boolean
      {
         return this.mIsWelcomeBackBundle;
      }
      
      public function resetTemporaryData() : void
      {
         this.mGold = 0;
         this.mQuestPoints = 0;
         this.mRaidPoints = 0;
         this.mAHTokens = 0;
         if(this.mCards)
         {
            this.mCards.length = 0;
         }
         if(this.mPacks)
         {
            this.mPacks.length = 0;
         }
         if(this.mSkins)
         {
            this.mSkins.length = 0;
         }
         if(this.mBoosts)
         {
            this.mBoosts.length = 0;
         }
         this.mDuration = 1;
         this.mUnlockedByQuest = "";
         this.mDiscount = 0;
         this.mUnique = false;
         this.mChestBG = "";
         this.mManualId = "";
         this.mManualExpirationTimeMS = 0;
      }
   }
}

