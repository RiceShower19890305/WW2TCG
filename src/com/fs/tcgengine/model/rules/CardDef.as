package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSCard;
   
   public class CardDef extends Def
   {
      
      private var mFactionSku:String;
      
      private var mTier:FSNumber;
      
      private var mDamage:FSNumber;
      
      private var mDefense:FSNumber;
      
      protected var mAbilities:Array;
      
      private var mEditionSku:String;
      
      private var mGameEdition:int;
      
      private var mCardRarity:String;
      
      private var mCategorySku:String;
      
      private var mSubCategorySku:Array;
      
      private var mUpgradeCost:FSNumber;
      
      private var mUpgradeSku:String;
      
      private var mPreviousUpgradeSku:String;
      
      private var mGoldOnSell:FSNumber;
      
      private var mRaidCoinsOnSell:FSNumber;
      
      private var mSummonCost:FSNumber;
      
      private var mBGAnimated:String;
      
      private var mBGAnimatedFPS:int;
      
      private var mFamilyId:int;
      
      private var mCraftSku:String;
      
      private var mExtraCraftSku:String = "";
      
      private var mCardSkinSku:String;
      
      private var mCooldown:FSNumber;
      
      private var mCraftAbilities:Array;
      
      private var mVisible:Boolean = true;
      
      private var mDevCard:Boolean = false;
      
      private var mDeckFamilyID:int;
      
      private var mShowCraftUpdatePanel:int;
      
      private var mEmblemGeneratedOnPlay:FSNumber;
      
      private var mFusionSku:String;
      
      private var mExtraFusionSku:String = "";
      
      private var mIsFusion:int;
      
      private var mAPGeneratedOnPlay:FSNumber;
      
      private var mEnhanceLevel:int = 0;
      
      private var mIsCraftMaterial:Boolean = false;
      
      private var mCraftMaterialBG:String = "";
      
      private var mGroupsIds:Array;
      
      private var mCraftAmountCards:FSNumber;
      
      private var mExtraCraftAmountCards:FSNumber;
      
      private var mCardSkinAmountCards:FSNumber;
      
      private var mCraftCost:FSNumber;
      
      private var mCraftTypeCost:int;
      
      private var mCardSkinCost:FSNumber;
      
      private var mFusionAmountCards:FSNumber;
      
      private var mFusionAmountExtraCards:FSNumber;
      
      private var mFusionCost:FSNumber;
      
      private var mFusionTypeCost:int;
      
      private var mAttachedToSubcategorySku:Array;
      
      private var mIsChampion:Boolean = false;
      
      private var mCraftQuestSku:String = "";
      
      private var mAuraBGName:String;
      
      private var mBattlePassSeason:int;
      
      private var mBattlePassYear:int;
      
      private var mAllowedToPlayOnFactionDecks:Array;
      
      private var mLeaderIcon:String;
      
      public function CardDef()
      {
         super();
      }
      
      public function getFrameRarityBGName() : String
      {
         var _loc1_:String = "";
         var _loc2_:RarityDef = RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(this.getCardRarity()));
         if(_loc2_ != null)
         {
            _loc1_ = _loc2_.getBGImageName();
         }
         return _loc1_;
      }
      
      public function getFactionFrameBGName() : String
      {
         var _loc1_:String = "";
         var _loc2_:FactionDef = FactionDef(InstanceMng.getFactionsDefMng().getDefBySku(this.getFactionSku()));
         if(_loc2_ != null)
         {
            _loc1_ = Config.getConfig().gameHasFramesBySubcategory() ? _loc2_.getCategoryFrameBG(this.mCategorySku) : _loc2_.getBGImageName();
         }
         return _loc1_;
      }
      
      public function getBackBGName() : String
      {
         var _loc1_:String = "";
         var _loc2_:FactionDef = FactionDef(InstanceMng.getFactionsDefMng().getDefBySku(this.getFactionSku()));
         if(_loc2_ != null)
         {
            _loc1_ = _loc2_.getBackBGName();
         }
         return _loc1_;
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         if("factionSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.factionSku);
            this.setFactionSku(_loc2_);
         }
         if("tier" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.tier);
            this.setTier(int(_loc2_));
         }
         if("factionSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.factionSku);
            this.setFactionSku(_loc2_);
         }
         if("categorySku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.categorySku);
            this.setCategorySku(_loc2_);
         }
         if("subCategorySku" in param1)
         {
            if(param1.subCategorySku != "")
            {
               _loc2_ = Utils.cleanMasterString(param1.subCategorySku);
               this.setSubCategorySku(_loc2_.split(","));
            }
         }
         if("editionSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.editionSku);
            this.setEditionSku(_loc2_);
         }
         if("raritySku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.raritySku);
            this.setCardRarity(_loc2_);
         }
         if("upgradeCost" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.upgradeCost);
            this.setUpgradeCost(int(_loc2_));
         }
         if("damage" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.damage);
            this.setDamage(int(_loc2_));
         }
         if("defense" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.defense);
            this.setDefense(int(_loc2_));
         }
         if("abilitiesSku" in param1)
         {
            if(param1.abilitiesSku != "")
            {
               _loc2_ = Utils.cleanMasterString(param1.abilitiesSku);
               this.setAbilities(_loc2_.split(","));
            }
         }
         if("previousUpgradeSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.previousUpgradeSku);
            this.setPreviousUpgradeSku(_loc2_);
         }
         if("upgradeSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.upgradeSku);
            this.setUpgradeSku(_loc2_);
         }
         if("goldOnSell" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.goldOnSell);
            this.setGoldOnSell(int(_loc2_));
         }
         if("raidCoinsOnSell" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.raidCoinsOnSell);
            this.setRaidCoinsOnSell(int(_loc2_));
         }
         if("summonCost" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.summonCost);
            this.setSummonCost(int(_loc2_));
         }
         if("bgAnimated" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.bgAnimated);
            this.mBGAnimated = _loc2_;
         }
         if("bgAnimatedFPS" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.bgAnimatedFPS);
            this.mBGAnimatedFPS = int(_loc2_);
         }
         if("familyID" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.familyID);
            this.mFamilyId = int(_loc2_);
         }
         if("craftSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.craftSku);
            this.mCraftSku = String(_loc2_);
         }
         if("extraCraftSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.extraCraftSku);
            this.mExtraCraftSku = String(_loc2_);
         }
         if("cardSkinSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.cardSkinSku);
            this.mCardSkinSku = String(_loc2_);
         }
         if("graveyardCooldown" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.graveyardCooldown);
            if(this.mCooldown == null)
            {
               this.mCooldown = new FSNumber();
            }
            this.mCooldown.value = int(_loc2_);
         }
         if("craftAbility" in param1)
         {
            if(param1.abilitiesSku != "")
            {
               _loc2_ = Utils.cleanMasterString(param1.craftAbility);
               this.setCraftAbilities(_loc2_.split(","));
            }
         }
         if("visible" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.visible);
            this.mVisible = Utils.stringToBoolean(_loc2_);
         }
         if("devCard" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.devCard);
            this.mDevCard = Utils.stringToBoolean(_loc2_);
         }
         if("deckFamilyID" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.deckFamilyID);
            this.mDeckFamilyID = int(_loc2_);
         }
         if("showCraftUpdatePanel" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.showCraftUpdatePanel);
            this.setShowCraftUpdatePanel(int(_loc2_));
         }
         if("emblemGeneratedOnPlay" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.emblemGeneratedOnPlay);
            this.setEmblemGeneratedOnPlay(int(_loc2_));
         }
         if("fusionSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.fusionSku);
            this.mFusionSku = String(_loc2_);
         }
         if("extraFusionSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.extraFusionSku);
            this.mExtraFusionSku = String(_loc2_);
         }
         if("isFusion" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.isFusion);
            this.mIsFusion = int(_loc2_);
         }
         if("apGeneratedOnPlay" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.apGeneratedOnPlay);
            this.setAPGeneratedOnPlay(int(_loc2_));
         }
         if("enhance" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.enhance);
            this.mEnhanceLevel = int(_loc2_);
         }
         if("craftMaterial" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.craftMaterial);
            this.mIsCraftMaterial = Utils.stringToBoolean(_loc2_);
         }
         if("craftMaterialBG" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.craftMaterialBG);
            this.mCraftMaterialBG = String(_loc2_);
         }
         if("groupId" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.groupId);
            this.mGroupsIds = String(_loc2_).split(",");
         }
         if("cardSkinAmountCards" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.cardSkinAmountCards);
            this.setCardSkinAmountCards(int(_loc2_));
         }
         if("cardSkinCost" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.cardSkinCost);
            this.setCardSkinCost(int(_loc2_));
         }
         if("craftAmountCards" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.craftAmountCards);
            this.setCraftAmountCards(int(_loc2_));
         }
         if("craftAmountExtraCards" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.craftAmountExtraCards);
            this.setExtraCraftAmountCards(int(_loc2_));
         }
         if("craftCost" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.craftCost);
            this.setCraftCost(int(_loc2_));
         }
         if("craftTypeCost" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.craftTypeCost);
            this.mCraftTypeCost = int(_loc2_);
         }
         if("fusionAmountCards" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.fusionAmountCards);
            this.setCardFusionAmountCards(int(_loc2_));
         }
         if("fusionAmountExtraCards" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.fusionAmountExtraCards);
            this.setExtraCardFusionAmountCards(int(_loc2_));
         }
         if("fusionCost" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.fusionCost);
            this.setCardFusionCost(int(_loc2_));
         }
         if("fusionTypeCost" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.fusionTypeCost);
            this.mFusionTypeCost = int(_loc2_);
         }
         if("attachedToSubcategorySku" in param1)
         {
            if(param1.attachedToSubcategorySku != "")
            {
               _loc2_ = Utils.cleanMasterString(param1.attachedToSubcategorySku);
               this.setAttachedToSubcategorySku(_loc2_.split(","));
            }
         }
         if("isChampion" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.isChampion);
            this.mIsChampion = Utils.stringToBoolean(_loc2_);
         }
         if("craftQuestSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.craftQuestSku);
            this.mCraftQuestSku = _loc2_;
         }
         if("auraBGName" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.auraBGName);
            this.mAuraBGName = _loc2_;
         }
         if("battlePassSeason" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battlePassSeason);
            this.mBattlePassSeason = int(_loc2_);
         }
         if("battlePassYear" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battlePassYear);
            this.mBattlePassYear = int(_loc2_);
         }
         if("allowedToPlayOnFactionDecks" in param1)
         {
            if(param1.allowedToPlayOnFactionDecks != "")
            {
               _loc2_ = Utils.cleanMasterString(param1.allowedToPlayOnFactionDecks);
               this.setAllowedToPlayOnFactionDecks(_loc2_.split(","));
            }
         }
         if("leaderIcon" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.leaderIcon);
            this.mLeaderIcon = _loc2_;
         }
      }
      
      public function getDamage() : int
      {
         return this.mDamage ? int(this.mDamage.value) : 0;
      }
      
      public function setDamage(param1:int) : void
      {
         if(this.mDamage == null)
         {
            this.mDamage = new FSNumber();
         }
         this.mDamage.value = param1;
      }
      
      public function getDefense() : int
      {
         return this.mDefense ? int(this.mDefense.value) : 0;
      }
      
      public function setDefense(param1:int) : void
      {
         if(this.mDefense == null)
         {
            this.mDefense = new FSNumber();
         }
         this.mDefense.value = param1;
      }
      
      public function getAbilities() : Array
      {
         return this.mAbilities;
      }
      
      public function getAllAbilitiesDefsBreakdown() : Array
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:AbilityDef = null;
         var _loc4_:AbilityDef = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(this.mAbilities != null)
         {
            _loc1_ = new Array();
            while(_loc5_ < this.mAbilities.length)
            {
               _loc3_ = AbilityDef(InstanceMng.getAbilitiesDefMng().getDefBySku(this.mAbilities[_loc5_]));
               if(_loc3_)
               {
                  if(_loc3_.isParentAbility())
                  {
                     _loc1_.push(_loc3_);
                     _loc2_ = _loc3_.getChildAbs();
                     if(Boolean(_loc2_) && _loc2_.length > 0)
                     {
                        _loc6_ = 0;
                        while(_loc6_ < _loc2_.length)
                        {
                           _loc4_ = AbilityDef(InstanceMng.getAbilitiesDefMng().getDefBySku(_loc2_[_loc6_]));
                           if(_loc4_)
                           {
                              _loc1_.push(_loc4_);
                           }
                           _loc6_++;
                        }
                     }
                  }
                  else
                  {
                     _loc1_.push(_loc3_);
                  }
               }
               _loc5_++;
            }
         }
         return _loc1_;
      }
      
      public function getNullAbilities() : Array
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:AbilityDef = null;
         var _loc4_:AbilityDef = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(this.mAbilities != null)
         {
            _loc1_ = new Array();
            while(_loc5_ < this.mAbilities.length)
            {
               _loc3_ = AbilityDef(InstanceMng.getAbilitiesDefMng().getDefBySku(this.mAbilities[_loc5_]));
               if(_loc3_)
               {
                  if(_loc3_.isParentAbility())
                  {
                     _loc2_ = _loc3_.getChildAbs();
                     if(Boolean(_loc2_) && _loc2_.length > 0)
                     {
                        _loc6_ = 0;
                        while(_loc6_ < _loc2_.length)
                        {
                           _loc4_ = AbilityDef(InstanceMng.getAbilitiesDefMng().getDefBySku(_loc2_[_loc6_]));
                           if(_loc4_ == null)
                           {
                              _loc1_.push(this.mAbilities[_loc5_]);
                           }
                           _loc6_++;
                        }
                     }
                  }
               }
               else
               {
                  _loc1_.push(this.mAbilities[_loc5_]);
               }
               _loc5_++;
            }
         }
         return _loc1_;
      }
      
      public function setAbilities(param1:Array) : void
      {
         this.mAbilities = param1;
      }
      
      public function getCardRarity() : String
      {
         return this.mCardRarity;
      }
      
      public function setCardRarity(param1:String) : void
      {
         this.mCardRarity = param1;
         setProdId("cards." + this.mCardRarity);
      }
      
      public function getEditionSku() : String
      {
         return this.mEditionSku;
      }
      
      public function getGameEditionIndex() : int
      {
         return this.mGameEdition;
      }
      
      public function setEditionSku(param1:String) : void
      {
         this.mEditionSku = param1;
         var _loc2_:EditionDef = EditionDef(InstanceMng.getEditionsDefMng().getDefBySku(this.mEditionSku));
         this.mGameEdition = _loc2_ ? _loc2_.getGameIndex() : 0;
      }
      
      public function getCategorySku() : String
      {
         return this.mCategorySku;
      }
      
      public function setCategorySku(param1:String) : void
      {
         this.mCategorySku = param1;
      }
      
      public function getSubCategorySku() : Array
      {
         return this.mSubCategorySku;
      }
      
      public function setSubCategorySku(param1:Array) : void
      {
         this.mSubCategorySku = param1;
      }
      
      public function getUpgradeCost() : int
      {
         return this.mUpgradeCost ? int(this.mUpgradeCost.value) : 0;
      }
      
      public function setUpgradeCost(param1:int) : void
      {
         if(this.mUpgradeCost == null)
         {
            this.mUpgradeCost = new FSNumber();
         }
         this.mUpgradeCost.value = param1;
      }
      
      public function getUpgradeSku() : String
      {
         return this.mUpgradeSku;
      }
      
      public function setUpgradeSku(param1:String) : void
      {
         this.mUpgradeSku = param1;
      }
      
      public function getPreviousUpgradeSku() : String
      {
         return this.mPreviousUpgradeSku;
      }
      
      public function setPreviousUpgradeSku(param1:String) : void
      {
         this.mPreviousUpgradeSku = param1;
      }
      
      public function getFactionSku() : String
      {
         return this.mFactionSku;
      }
      
      public function setFactionSku(param1:String) : void
      {
         this.mFactionSku = param1;
      }
      
      public function getTier() : int
      {
         return this.mTier ? int(this.mTier.value) : 1;
      }
      
      public function setTier(param1:int) : void
      {
         if(this.mTier == null)
         {
            this.mTier = new FSNumber();
         }
         this.mTier.value = param1;
      }
      
      public function getCardValue() : int
      {
         var _loc1_:RarityDef = RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(this.getCardRarity()));
         return _loc1_ ? _loc1_.getCardValue() : 0;
      }
      
      public function getCategoryIndex() : int
      {
         var _loc1_:int = 0;
         var _loc2_:CategoryDef = CategoryDef(InstanceMng.getCategoriesDefMng().getDefBySku(this.mCategorySku));
         if(_loc2_ != null)
         {
            _loc1_ = _loc2_.getIndex();
         }
         return _loc1_;
      }
      
      public function getGoldOnSell() : int
      {
         return this.mGoldOnSell ? int(this.mGoldOnSell.value) : 0;
      }
      
      public function setGoldOnSell(param1:int) : void
      {
         if(this.mGoldOnSell == null)
         {
            this.mGoldOnSell = new FSNumber();
         }
         this.mGoldOnSell.value = param1;
      }
      
      public function getRaidCoinsOnSell() : int
      {
         return this.mRaidCoinsOnSell ? int(this.mRaidCoinsOnSell.value) : 0;
      }
      
      public function setRaidCoinsOnSell(param1:int) : void
      {
         if(this.mRaidCoinsOnSell == null)
         {
            this.mRaidCoinsOnSell = new FSNumber();
         }
         this.mRaidCoinsOnSell.value = param1;
      }
      
      public function isAllowedToSell() : Boolean
      {
         return this.mGoldOnSell ? this.mGoldOnSell.value != -1 : false;
      }
      
      public function getSummonCost() : int
      {
         return this.mSummonCost ? int(this.mSummonCost.value) : 0;
      }
      
      public function setSummonCost(param1:int) : void
      {
         if(this.mSummonCost == null)
         {
            this.mSummonCost = new FSNumber();
         }
         this.mSummonCost.value = param1;
      }
      
      public function getCompositeTierFrameName(param1:Boolean = false, param2:int = -1) : String
      {
         var _loc3_:String = this.getFrameRarityBGName();
         var _loc4_:String = param2 != -1 ? Utils.transformValueToString(param2.toString(),2) : Utils.transformValueToString(this.getTier().toString(),2);
         _loc3_ += "_tier_" + _loc4_;
         return _loc3_ + (param1 ? Constants.XL_PREFIX_NAME : "");
      }
      
      public function getMaxAmountOndeck() : int
      {
         var _loc1_:int = 0;
         var _loc2_:RarityDef = RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(this.getCardRarity()));
         if(_loc2_)
         {
            _loc1_ = _loc2_.getMaxAmountPerDeck();
         }
         return _loc1_;
      }
      
      public function getMaxAmountPowerOndeck() : int
      {
         return 1;
      }
      
      public function getAnimatedBG() : String
      {
         return this.mBGAnimated;
      }
      
      public function getAnimatedBGFPS() : int
      {
         return this.mBGAnimatedFPS;
      }
      
      public function hasAnimatedBG() : Boolean
      {
         return this.mBGAnimated != null && this.mBGAnimated != "";
      }
      
      public function getFamilyId() : int
      {
         return this.mFamilyId;
      }
      
      public function getCraftSku() : String
      {
         return this.mCraftSku;
      }
      
      public function getExtraCraftSku() : String
      {
         return this.mExtraCraftSku;
      }
      
      public function getCardSkinSku() : String
      {
         return this.mCardSkinSku;
      }
      
      public function getCooldown() : int
      {
         if(this.mCooldown)
         {
            return this.mCooldown.value;
         }
         return Config.getConfig().getGraveyardCardCooldown();
      }
      
      public function getType() : int
      {
         var _loc1_:int = -1;
         if(this is UnitDef)
         {
            return FSCard.TYPE_UNIT;
         }
         if(this is AttachmentDef)
         {
            return FSCard.TYPE_ATTACHMENT;
         }
         if(this is ActionDef)
         {
            return FSCard.TYPE_ACTION;
         }
         if(this is PowerDef)
         {
            return FSCard.TYPE_POWER;
         }
         return _loc1_;
      }
      
      public function getCraftAbilities() : Array
      {
         return this.mCraftAbilities;
      }
      
      public function setCraftAbilities(param1:Array) : void
      {
         this.mCraftAbilities = param1;
      }
      
      public function getIsVisible() : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:Boolean = this.mBattlePassSeason != 0 && this.mBattlePassYear != 0;
         var _loc2_:Boolean = _loc1_ ? false : true;
         if(Boolean(!_loc2_) && Boolean(Config.smMonthNumber) && Boolean(Config.smYearNumber))
         {
            _loc4_ = Config.smMonthNumber.value;
            _loc5_ = Config.smYearNumber.value;
            if(_loc4_ != -1 && _loc5_ != -1)
            {
               if(this.mBattlePassYear <= _loc5_)
               {
                  _loc2_ = this.mBattlePassYear == _loc5_ ? this.mBattlePassSeason <= _loc4_ : true;
               }
            }
         }
         _loc2_ = _loc1_ && Config.smDBIgnoreSeasonFilter ? true : _loc2_;
         var _loc3_:Boolean = !this.mDevCard || this.mDevCard && Config.ENVIRONMENT_ACTIVE == Config.ENVIRONMENT_DEV;
         return _loc2_ && this.mVisible && _loc3_;
      }
      
      public function isCraftSkuBGDifferentBG() : Boolean
      {
         var _loc3_:String = null;
         var _loc1_:String = getBGImageName();
         var _loc2_:CardDef = CardDef(InstanceMng.getCardsDefMng().getDefBySku(this.mCraftSku));
         var _loc4_:Boolean = false;
         if(_loc2_)
         {
            _loc3_ = _loc2_.getBGImageName();
            if(_loc1_ != _loc3_)
            {
               _loc4_ = true;
            }
         }
         return _loc4_;
      }
      
      public function isExtraCraftSkuBGDifferentBG() : Boolean
      {
         var _loc3_:String = null;
         var _loc1_:String = getBGImageName();
         var _loc2_:CardDef = CardDef(InstanceMng.getCardsDefMng().getDefBySku(this.mExtraCraftSku));
         var _loc4_:Boolean = false;
         if(_loc2_)
         {
            _loc3_ = _loc2_.getBGImageName();
            if(_loc1_ != _loc3_)
            {
               _loc4_ = true;
            }
         }
         return _loc4_;
      }
      
      public function getDeckFamilyID() : int
      {
         return this.mDeckFamilyID;
      }
      
      private function setShowCraftUpdatePanel(param1:int) : void
      {
         this.mShowCraftUpdatePanel = param1;
      }
      
      public function getShowCraftUpdatePanel() : Boolean
      {
         return this.mShowCraftUpdatePanel == 1;
      }
      
      private function setEmblemGeneratedOnPlay(param1:int) : void
      {
         if(this.mEmblemGeneratedOnPlay == null)
         {
            this.mEmblemGeneratedOnPlay = new FSNumber();
         }
         this.mEmblemGeneratedOnPlay.value = param1;
      }
      
      public function getEmblemGeneratedOnPlay() : int
      {
         return this.mEmblemGeneratedOnPlay ? int(this.mEmblemGeneratedOnPlay.value) : 0;
      }
      
      public function getFusionSku() : String
      {
         return this.mFusionSku;
      }
      
      public function getExtraFusionSku() : String
      {
         return this.mExtraFusionSku;
      }
      
      public function isFusion() : Boolean
      {
         return this.mIsFusion == 1;
      }
      
      private function setAPGeneratedOnPlay(param1:int) : void
      {
         if(this.mAPGeneratedOnPlay == null)
         {
            this.mAPGeneratedOnPlay = new FSNumber();
         }
         this.mAPGeneratedOnPlay.value = param1;
      }
      
      public function getAPGeneratedOnPlay() : int
      {
         return this.mAPGeneratedOnPlay ? int(this.mAPGeneratedOnPlay.value) : 0;
      }
      
      public function needsExtraCraftCard() : Boolean
      {
         return this.mExtraCraftSku != "";
      }
      
      public function needsExtraFusionCard() : Boolean
      {
         return this.mExtraFusionSku != "";
      }
      
      public function getEnhanceLevel() : int
      {
         return this.mEnhanceLevel;
      }
      
      public function isCraftMaterial() : Boolean
      {
         return this.mIsCraftMaterial;
      }
      
      public function getCraftMaterialBG() : String
      {
         return this.mCraftMaterialBG;
      }
      
      public function getGroupsIds() : Array
      {
         return this.mGroupsIds;
      }
      
      public function setCraftCost(param1:int) : void
      {
         if(this.mCraftCost == null)
         {
            this.mCraftCost = new FSNumber();
         }
         this.mCraftCost.value = Number(param1);
      }
      
      public function setCardSkinCost(param1:int) : void
      {
         if(this.mCardSkinCost == null)
         {
            this.mCardSkinCost = new FSNumber();
         }
         this.mCardSkinCost.value = Number(param1);
      }
      
      public function getCraftCost() : int
      {
         return this.mCraftCost ? int(this.mCraftCost.value) : 0;
      }
      
      public function getCardSkinCost() : int
      {
         return this.mCardSkinCost ? int(this.mCardSkinCost.value) : 0;
      }
      
      public function setCraftAmountCards(param1:int) : void
      {
         if(this.mCraftAmountCards == null)
         {
            this.mCraftAmountCards = new FSNumber();
         }
         this.mCraftAmountCards.value = Number(param1);
      }
      
      public function setExtraCraftAmountCards(param1:int) : void
      {
         if(this.mExtraCraftAmountCards == null)
         {
            this.mExtraCraftAmountCards = new FSNumber();
         }
         this.mExtraCraftAmountCards.value = Number(param1);
      }
      
      public function setCardSkinAmountCards(param1:int) : void
      {
         if(this.mCardSkinAmountCards == null)
         {
            this.mCardSkinAmountCards = new FSNumber();
         }
         this.mCardSkinAmountCards.value = Number(param1);
      }
      
      public function getCraftAmountCards() : int
      {
         return this.mCraftAmountCards ? int(this.mCraftAmountCards.value) : 0;
      }
      
      public function getExtraCraftAmountCards() : int
      {
         return this.mExtraCraftAmountCards ? int(this.mExtraCraftAmountCards.value) : 0;
      }
      
      private function setCardFusionCost(param1:int) : void
      {
         if(this.mFusionCost == null)
         {
            this.mFusionCost = new FSNumber();
         }
         this.mFusionCost.value = param1;
      }
      
      private function setCardFusionAmountCards(param1:int) : void
      {
         if(this.mFusionAmountCards == null)
         {
            this.mFusionAmountCards = new FSNumber();
         }
         this.mFusionAmountCards.value = param1;
      }
      
      public function getFusionCost() : int
      {
         return this.mFusionCost ? int(this.mFusionCost.value) : 0;
      }
      
      public function getFusionAmountCards() : int
      {
         return this.mFusionAmountCards ? int(this.mFusionAmountCards.value) : 0;
      }
      
      private function setExtraCardFusionAmountCards(param1:int) : void
      {
         if(this.mFusionAmountExtraCards == null)
         {
            this.mFusionAmountExtraCards = new FSNumber();
         }
         this.mFusionAmountExtraCards.value = param1;
      }
      
      public function getFusionAmountExtraCards() : int
      {
         return this.mFusionAmountExtraCards ? int(this.mFusionAmountExtraCards.value) : 0;
      }
      
      public function getFusionTypeCost() : int
      {
         return this.mFusionTypeCost;
      }
      
      public function getCraftTypeCost() : int
      {
         return this.mCraftTypeCost;
      }
      
      public function getCardSkinAmountCards() : int
      {
         return this.mCardSkinAmountCards ? int(this.mCardSkinAmountCards.value) : 0;
      }
      
      public function getAttachedToSubcategorySku() : Array
      {
         return this.mAttachedToSubcategorySku;
      }
      
      public function setAttachedToSubcategorySku(param1:Array) : void
      {
         this.mAttachedToSubcategorySku = param1;
      }
      
      public function getAllowedToPlayOnFactionDecks() : Array
      {
         return this.mAllowedToPlayOnFactionDecks;
      }
      
      public function setAllowedToPlayOnFactionDecks(param1:Array) : void
      {
         this.mAllowedToPlayOnFactionDecks = param1;
      }
      
      public function isCrafteable() : Boolean
      {
         return this.mCraftSku != "" && this.mCraftSku != null || this.mFusionSku != "" && this.mFusionSku != null || this.mCardSkinSku != "" && this.mCardSkinSku != null;
      }
      
      public function isChampion() : Boolean
      {
         return this.mIsChampion;
      }
      
      public function setIsChampion(param1:Boolean) : void
      {
         this.mIsChampion = param1;
      }
      
      public function getCraftQuestSku() : String
      {
         return this.mCraftQuestSku;
      }
      
      public function needsQuestToCraft() : Boolean
      {
         return this.isCrafteable() && this.mCraftQuestSku != "";
      }
      
      public function hasAura() : Boolean
      {
         return this.mAuraBGName != "" && this.mAuraBGName != null;
      }
      
      public function getAuraBGName() : String
      {
         return this.mAuraBGName;
      }
      
      public function getBattlePassSeason() : int
      {
         return this.mBattlePassSeason;
      }
      
      public function getBattlePassYear() : int
      {
         return this.mBattlePassYear;
      }
      
      public function isLeader() : Boolean
      {
         return this.mLeaderIcon != "" && this.mLeaderIcon != null;
      }
      
      public function getLeaderIcon() : String
      {
         return this.mLeaderIcon;
      }
   }
}

