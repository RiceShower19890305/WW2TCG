package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.Utils;
   import flash.utils.Dictionary;
   
   public class PackDef extends Def
   {
      
      private var mChancesCatalog:Dictionary;
      
      private var mGold:FSNumber;
      
      private var mShowInShop:Boolean;
      
      private var mFactionSku:String;
      
      private var mCategorySku:String;
      
      private var mEditionSku:String;
      
      private var mCostsGold:Boolean;
      
      private var mSpecialCardsArr:Array;
      
      private var mSpecialCardsCatalog:Dictionary;
      
      private var mSubCategoriesArr:Array;
      
      private var mShopInfoRaritiesInfo:Dictionary;
      
      private var mUniquePack:Boolean;
      
      private var mTokens:FSNumber;
      
      private var mRaidCoins:FSNumber;
      
      private var mLimitedWeeklyPack:Boolean;
      
      private var mLimitedWeeklyPacksMax:FSNumber;
      
      private var mChancesAmount:int;
      
      private var mChancesTooltipTID:String = "";
      
      private var mAnimBG:String = "";
      
      public function PackDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         super.doFromJSON(param1);
         if("gold" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gold);
            this.setGold(int(_loc2_));
         }
         if("showInShop" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.showInShop);
            this.setShowInShop(Utils.stringToBoolean(_loc2_));
         }
         if("factionSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.factionSku);
            this.setFactionSku(_loc2_);
         }
         if("editionSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.editionSku);
            this.setEditionSku(_loc2_);
         }
         if("categorySku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.categorySku);
            this.setCategorySku(_loc2_);
         }
         this.readRarityChancesJSON(param1);
         if("costsGold" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.costsGold);
            this.setCostsGold(Utils.stringToBoolean(_loc2_));
         }
         if("cardsSku" in param1)
         {
            if(String(param1.cardsSku) != "")
            {
               _loc2_ = Utils.cleanMasterString(param1.cardsSku);
               this.setSpecialCards(_loc2_.split(","));
            }
         }
         if("subCategoriesSku" in param1)
         {
            if(String(param1.subCategoriesSku) != "")
            {
               _loc2_ = Utils.cleanMasterString(param1.subCategoriesSku);
               this.setSubCategories(_loc2_.split(","));
            }
         }
         if("shopInfo" in param1)
         {
            if(String(param1.shopInfo) != "")
            {
               _loc2_ = Utils.cleanMasterString(param1.shopInfo);
               _loc3_ = _loc2_.split(",");
               _loc4_ = 0;
               while(_loc4_ < _loc3_.length)
               {
                  this.addShopInfoRarityInfo(_loc4_,_loc3_[_loc4_]);
                  _loc4_++;
               }
            }
         }
         if("uniquePack" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.uniquePack);
            this.setUniquePack(Utils.stringToBoolean(_loc2_));
         }
         if("tokens" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.tokens);
            this.setTokens(int(_loc2_));
         }
         if("raidPoints" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.raidPoints);
            this.setRaidCoins(int(_loc2_));
         }
         if("limitedWeeklyPack" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.limitedWeeklyPack);
            this.mLimitedWeeklyPack = Utils.stringToBoolean(_loc2_);
         }
         if("limitedWeeklyPacksMax" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.limitedWeeklyPacksMax);
            this.setLimitedWeeklyPacksMax(int(_loc2_));
         }
         if("chancesTooltipTID" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.chancesTooltipTID);
            this.mChancesTooltipTID = _loc2_;
         }
         if("animBG" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.animBG);
            this.mAnimBG = _loc2_;
         }
      }
      
      private function addShopInfoRarityInfo(param1:int, param2:String) : void
      {
         if(this.mShopInfoRaritiesInfo == null)
         {
            this.mShopInfoRaritiesInfo = new Dictionary(true);
         }
         if(this.mShopInfoRaritiesInfo[param1] == null)
         {
            this.mShopInfoRaritiesInfo[param1] = param2;
         }
      }
      
      public function getShopInfoRaritiesInfo() : Dictionary
      {
         return this.mShopInfoRaritiesInfo;
      }
      
      private function readRarityChancesJSON(param1:Object) : void
      {
         var _loc3_:int = 0;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc2_:String = "chance";
         var _loc4_:int = Config.getConfig().getShopMaxCardsPerPack();
         _loc3_ = 1;
         while(_loc3_ <= _loc4_)
         {
            _loc5_ = _loc3_.toString();
            _loc7_ = param1[_loc2_ + _loc5_];
            if(_loc7_ != null)
            {
               _loc8_ = Utils.cleanMasterString(_loc7_);
               _loc6_ = _loc8_.split(",");
               this.addRarityChance(_loc3_,_loc6_);
            }
            _loc3_++;
         }
      }
      
      private function addRarityChance(param1:int, param2:Array) : void
      {
         if(this.mChancesCatalog == null)
         {
            this.mChancesCatalog = new Dictionary(true);
         }
         if(this.mChancesCatalog[param1] == null)
         {
            this.mChancesCatalog[param1] = param2;
         }
         if(Boolean(param2) && param2[0] != "")
         {
            ++this.mChancesAmount;
         }
      }
      
      public function getChancesAmount() : int
      {
         return this.mChancesAmount;
      }
      
      public function getRarityChancesByIndex(param1:int) : Dictionary
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
                  _loc4_ = String(_loc3_[_loc5_]).split(":");
                  if(_loc2_ == null)
                  {
                     _loc2_ = new Dictionary(true);
                  }
                  _loc2_[_loc4_[1]] = _loc4_[0];
                  _loc5_++;
               }
            }
         }
         return _loc2_;
      }
      
      public function getChanceByRaritySkuAndIndex(param1:int, param2:String) : int
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
         this.mGold.value = Number(param1);
      }
      
      public function getShowInShop() : Boolean
      {
         return this.mShowInShop;
      }
      
      public function setShowInShop(param1:Boolean) : void
      {
         this.mShowInShop = param1;
      }
      
      public function getFactionSku() : String
      {
         return this.mFactionSku;
      }
      
      public function setFactionSku(param1:String) : void
      {
         this.mFactionSku = param1;
      }
      
      public function getCategorySku() : String
      {
         return this.mCategorySku;
      }
      
      public function setCategorySku(param1:String) : void
      {
         this.mCategorySku = param1;
      }
      
      public function getEditionSku() : String
      {
         return this.mEditionSku;
      }
      
      public function setEditionSku(param1:String) : void
      {
         this.mEditionSku = param1;
      }
      
      private function setCostsGold(param1:Boolean) : void
      {
         this.mCostsGold = param1;
      }
      
      public function costsGold() : Boolean
      {
         return this.mCostsGold;
      }
      
      public function setSpecialCards(param1:Array) : void
      {
         this.mSpecialCardsArr = param1;
         this.mSpecialCardsCatalog = DictionaryUtils.addCards(param1,this.mSpecialCardsCatalog);
      }
      
      public function getSpecialCards() : Dictionary
      {
         return this.mSpecialCardsCatalog;
      }
      
      public function getSpecialCardsArr() : Array
      {
         return this.mSpecialCardsArr;
      }
      
      public function areCardsPredefined() : Boolean
      {
         return this.mSpecialCardsArr != null && this.mSpecialCardsArr.length > 0;
      }
      
      public function setSubCategories(param1:Array) : void
      {
         this.mSubCategoriesArr = param1;
      }
      
      public function getSubCategoriesArr() : Array
      {
         return this.mSubCategoriesArr;
      }
      
      public function setUniquePack(param1:Boolean) : void
      {
         this.mUniquePack = param1;
      }
      
      public function isUniquePack() : Boolean
      {
         return this.mUniquePack;
      }
      
      public function setTokens(param1:int) : void
      {
         if(this.mTokens == null)
         {
            this.mTokens = new FSNumber();
         }
         this.mTokens.value = Number(param1);
      }
      
      public function getTokens() : int
      {
         return this.mTokens ? int(this.mTokens.value) : 0;
      }
      
      public function setRaidCoins(param1:int) : void
      {
         if(this.mRaidCoins == null)
         {
            this.mRaidCoins = new FSNumber();
         }
         this.mRaidCoins.value = Number(param1);
      }
      
      public function getRaidCoins() : int
      {
         return this.mRaidCoins ? int(this.mRaidCoins.value) : 0;
      }
      
      public function getIsLimitedWeeklyPack() : Boolean
      {
         return this.mLimitedWeeklyPack;
      }
      
      private function setLimitedWeeklyPacksMax(param1:int) : void
      {
         if(this.mLimitedWeeklyPacksMax == null)
         {
            this.mLimitedWeeklyPacksMax = new FSNumber();
         }
         this.mLimitedWeeklyPacksMax.value = param1;
      }
      
      public function getLimitedWeeklyPacksMax() : int
      {
         return this.mLimitedWeeklyPacksMax ? int(this.mLimitedWeeklyPacksMax.value) : 0;
      }
      
      public function getChancesTooltipText() : String
      {
         return this.mChancesTooltipTID != "" ? TextManager.getText(this.mChancesTooltipTID,true) : "";
      }
      
      public function getAnimBG() : String
      {
         return this.mAnimBG;
      }
   }
}

