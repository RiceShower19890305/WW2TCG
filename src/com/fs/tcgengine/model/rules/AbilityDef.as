package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.AbilitiesMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.controller.rules.AbilitiesDefMng;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.FSUnit;
   import flash.utils.Dictionary;
   
   public class AbilityDef extends Def
   {
      
      private var mTriggerIndex:int;
      
      private var mTargetIndex:int;
      
      private var mDuration:int;
      
      private var mHeal:int;
      
      private var mPoisonDamage:int;
      
      private var mCategorySku:String;
      
      private var mSubCategorySku:Array;
      
      private var mFactionSku:String;
      
      private var mDamage:int;
      
      private var mDefense:int;
      
      private var mDamageFactor:Number = 0;
      
      private var mDefenseFactor:Number = 0;
      
      private var mDestroy:Boolean;
      
      private var mTierIndex:int;
      
      private var mIsSpecial:Boolean;
      
      private var mKeyName:String;
      
      private var mHighlightOnExecute:Boolean;
      
      private var mTargetTierIndex:int;
      
      private var mAnimKey:String;
      
      private var mAnimIconName:String;
      
      private var mSoundName:String;
      
      private var mRandomDamageAmount:int;
      
      private var mRandomDefenseAmount:int;
      
      private var mRandomHealAmount:int;
      
      private var mVisible:Boolean;
      
      private var mVisibleXL:Boolean;
      
      private var mChancesArr:Array;
      
      private var mCostRange:int;
      
      private var mStopsResumedPvPActions:Boolean;
      
      private var mApValue:int;
      
      private var mZoomIconInCombat:Boolean;
      
      private var mAbilityTargetKeynames:Array;
      
      private var mMultiplierByCard:int;
      
      private var mExtraSummonCost:int;
      
      private var mIsPassive:Boolean;
      
      private var mAnimAsset:String;
      
      private var mEndAnimAsset:String;
      
      private var mAnimDuration:Number = 0;
      
      private var mAnimParticleName:String;
      
      private var mAnimParticleBezierCurves:int = 1;
      
      private var mBGAnimatedFPS:int;
      
      private var mGroupsIds:Array;
      
      private var mChildAbilities:Array;
      
      private var mShield:int;
      
      private var mPlayerHeal:int;
      
      private var mResetDamage:Boolean;
      
      private var mResetDefense:Boolean;
      
      private var mResetAbilities:Boolean;
      
      private var mForceDamage:int = -1;
      
      private var mForceDefense:int = -1;
      
      private var mForcedDesc:String;
      
      private var mApGenerated:int;
      
      private var mUnlockAbilitySku:String;
      
      private var mItemsEquipped:Boolean;
      
      public function AbilityDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         if("visible" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.visible);
            this.setIsVisible(Utils.stringToBoolean(_loc2_));
         }
         if("visibleXL" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.visibleXL);
            this.setIsVisibleInXLView(Utils.stringToBoolean(_loc2_));
         }
         if("triggerIndex" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.triggerIndex);
            this.setTriggerIndex(int(_loc2_));
         }
         if("targetIndex" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.targetIndex);
            this.setTargetIndex(int(_loc2_));
         }
         if("duration" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.duration);
            this.setDuration(int(_loc2_));
         }
         if("heal" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.heal);
            this.setHeal(int(_loc2_));
         }
         if("poisonDamage" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.poisonDamage);
            this.mPoisonDamage = int(_loc2_);
         }
         if("randomHealAmount" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.randomHealAmount);
            this.setRandomHealAmount(int(_loc2_));
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
               this.setSubCategorySku(String(_loc2_).split(","));
            }
         }
         if("factionSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.factionSku);
            this.setFactionSku(_loc2_);
         }
         if("damage" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.damage);
            this.setDamage(int(_loc2_));
         }
         if("damageFactor" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.damageFactor);
            this.mDamageFactor = Number(_loc2_);
         }
         if("randomDamageAmount" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.randomDamageAmount);
            this.setRandomDamageAmount(int(_loc2_));
         }
         if("defense" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.defense);
            this.setDefense(int(_loc2_));
         }
         if("defenseFactor" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.defenseFactor);
            this.mDefenseFactor = Number(_loc2_);
         }
         if("randomDefenseAmount" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.randomDefenseAmount);
            this.setRandomDefenseAmount(int(_loc2_));
         }
         if("destroy" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.destroy);
            this.setDestroy(Utils.stringToBoolean(_loc2_));
         }
         if("tierIndex" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.tierIndex);
            this.setTierIndex(int(_loc2_));
         }
         if("special" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.special);
            this.setIsSpecial(Utils.stringToBoolean(_loc2_));
         }
         if("keyName" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.keyName);
            this.setKeyName(_loc2_);
         }
         if("highlightOnExecute" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.highlightOnExecute);
            this.setHighlightOnExecute(Utils.stringToBoolean(_loc2_));
         }
         if("targetTierIndex" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.targetTierIndex);
            this.setTargetTierIndex(int(_loc2_));
         }
         if("anim" in param1)
         {
            if(param1.anim != "")
            {
               _loc2_ = Utils.cleanMasterString(param1.anim);
               this.setAnimKey(_loc2_);
            }
         }
         if("animIcon" in param1)
         {
            if(param1.animIcon != "")
            {
               _loc2_ = Utils.cleanMasterString(param1.animIcon);
               this.setAnimIconName(_loc2_);
            }
         }
         if("sound" in param1)
         {
            if(param1.sound != "")
            {
               _loc2_ = Utils.cleanMasterString(param1.sound);
               this.setSoundName(_loc2_);
            }
         }
         if("costRange" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.costRange);
            this.mCostRange = int(_loc2_);
         }
         if("stopResumedPvPActions" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.stopResumedPvPActions);
            this.mStopsResumedPvPActions = Utils.stringToBoolean(String(_loc2_));
         }
         if("apValue" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.apValue);
            this.mApValue = int(_loc2_);
         }
         if("zoomIconInCombat" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.zoomIconInCombat);
            this.mZoomIconInCombat = Utils.stringToBoolean(_loc2_);
         }
         if("abilityTargetKeynames" in param1)
         {
            if(param1.abilityTargetKeynames != "")
            {
               _loc2_ = Utils.cleanMasterString(param1.abilityTargetKeynames);
               this.setAbilityTargetKeynames(String(_loc2_).split(","));
            }
         }
         if("multiplierByCard" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.multiplierByCard);
            this.setMultiplierByCard(int(_loc2_));
         }
         if("extraSummonCost" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.extraSummonCost);
            this.setExtraSummonCost(int(_loc2_));
         }
         if("isPassive" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.isPassive);
            this.mIsPassive = Utils.stringToBoolean(_loc2_);
         }
         if("animAsset" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.animAsset);
            this.mAnimAsset = _loc2_;
         }
         if("endAnimAsset" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.endAnimAsset);
            this.mEndAnimAsset = _loc2_;
         }
         if("animDuration" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.animDuration);
            this.mAnimDuration = Number(_loc2_);
         }
         if("animParticleName" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.animParticleName);
            this.mAnimParticleName = _loc2_;
         }
         if("animParticleBezierCurves" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.animParticleBezierCurves);
            this.mAnimParticleBezierCurves = int(_loc2_);
         }
         if("bgAnimatedFPS" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.bgAnimatedFPS);
            this.mBGAnimatedFPS = int(_loc2_);
         }
         if("groupId" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.groupId);
            this.mGroupsIds = String(_loc2_).split(",");
         }
         if("childAbs" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.childAbs);
            this.mChildAbilities = String(_loc2_).split(",");
         }
         if("shield" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.shield);
            this.mShield = int(_loc2_);
         }
         if("playerHeal" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.playerHeal);
            this.mPlayerHeal = int(_loc2_);
         }
         if("resetDamage" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.resetDamage);
            this.mResetDamage = Utils.stringToBoolean(_loc2_);
         }
         if("resetDefense" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.resetDefense);
            this.mResetDefense = Utils.stringToBoolean(_loc2_);
         }
         if("resetAbilities" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.resetAbilities);
            this.mResetAbilities = Utils.stringToBoolean(_loc2_);
         }
         if("itemsEquipped" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.itemsEquipped);
            this.mItemsEquipped = Utils.stringToBoolean(_loc2_);
         }
         if("forceDamage" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.forceDamage);
            this.mForceDamage = int(_loc2_);
         }
         if("forceDefense" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.forceDefense);
            this.mForceDefense = int(_loc2_);
         }
         if("forcedDesc" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.forcedDesc);
            this.mForcedDesc = _loc2_;
         }
         if("apGenerated" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.apGenerated);
            this.mApGenerated = int(_loc2_);
         }
         if("unlockedAbilitySku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.unlockedAbilitySku);
            this.mUnlockAbilitySku = String(_loc2_);
         }
         this.readChancesJSON(param1);
      }
      
      public function isIconVisible() : Boolean
      {
         return this.mVisible;
      }
      
      public function setIsVisible(param1:Boolean) : void
      {
         this.mVisible = param1;
      }
      
      public function isIconVisibleInXLView() : Boolean
      {
         return this.mVisibleXL;
      }
      
      public function setIsVisibleInXLView(param1:Boolean) : void
      {
         this.mVisibleXL = param1;
      }
      
      public function getTriggerIndex() : int
      {
         return this.mTriggerIndex;
      }
      
      public function setTriggerIndex(param1:int) : void
      {
         this.mTriggerIndex = param1;
      }
      
      public function getTargetIndex() : int
      {
         return this.mTargetIndex;
      }
      
      public function setTargetIndex(param1:int) : void
      {
         this.mTargetIndex = param1;
      }
      
      public function getDuration() : int
      {
         return this.mDuration;
      }
      
      public function setDuration(param1:int) : void
      {
         this.mDuration = param1;
      }
      
      public function getRandomHealAmount() : int
      {
         return this.mRandomHealAmount;
      }
      
      public function setRandomHealAmount(param1:int) : void
      {
         this.mRandomHealAmount = param1;
      }
      
      public function getHeal() : int
      {
         var _loc1_:int = this.mRandomHealAmount > 0 ? Utils.randomInt(0,this.mRandomHealAmount) : Utils.randomInt(this.mRandomHealAmount,0);
         return this.mHeal + _loc1_;
      }
      
      public function getPoisonDamage() : int
      {
         return this.mPoisonDamage;
      }
      
      public function getDefaultHeal() : int
      {
         return this.mHeal;
      }
      
      public function setHeal(param1:int) : void
      {
         this.mHeal = param1;
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
      
      public function getRandomDamageAmount() : int
      {
         return this.mRandomDamageAmount;
      }
      
      public function setRandomDamageAmount(param1:int) : void
      {
         this.mRandomDamageAmount = param1;
      }
      
      public function getDamage() : int
      {
         var _loc1_:int = this.mRandomDamageAmount > 0 ? Utils.randomInt(0,this.mRandomDamageAmount) : Utils.randomInt(this.mRandomDamageAmount,0);
         return this.mDamage + _loc1_;
      }
      
      public function getDefaultDamage() : int
      {
         return this.mDamage;
      }
      
      public function setDamage(param1:int) : void
      {
         this.mDamage = param1;
      }
      
      public function getRandomDefenseAmount() : int
      {
         return this.mRandomDefenseAmount;
      }
      
      public function setRandomDefenseAmount(param1:int) : void
      {
         this.mRandomDefenseAmount = param1;
      }
      
      public function getDefaultDefense() : int
      {
         return this.mDefense;
      }
      
      public function getDefense() : int
      {
         var _loc1_:int = this.mRandomDefenseAmount > 0 ? Utils.randomInt(0,this.mRandomDefenseAmount) : Utils.randomInt(this.mRandomDefenseAmount,0);
         return this.mDefense + _loc1_;
      }
      
      public function setDefense(param1:int) : void
      {
         this.mDefense = param1;
      }
      
      public function getDestroy() : Boolean
      {
         return this.mDestroy;
      }
      
      public function setDestroy(param1:Boolean) : void
      {
         this.mDestroy = param1;
      }
      
      public function getTierIndex() : int
      {
         return this.mTierIndex;
      }
      
      public function setTierIndex(param1:int) : void
      {
         this.mTierIndex = param1;
      }
      
      public function isSpecial() : Boolean
      {
         return this.mIsSpecial;
      }
      
      public function setIsSpecial(param1:Boolean) : void
      {
         this.mIsSpecial = param1;
      }
      
      public function getKeyName() : String
      {
         return this.mKeyName;
      }
      
      public function setKeyName(param1:String) : void
      {
         this.mKeyName = param1;
      }
      
      public function getFactionSku() : String
      {
         return this.mFactionSku;
      }
      
      public function setFactionSku(param1:String) : void
      {
         this.mFactionSku = param1;
      }
      
      public function getHighlightOnExecute() : Boolean
      {
         return this.mHighlightOnExecute;
      }
      
      public function setHighlightOnExecute(param1:Boolean) : void
      {
         this.mHighlightOnExecute = param1;
      }
      
      public function getTargetTierIndex() : int
      {
         return this.mTargetTierIndex;
      }
      
      public function setTargetTierIndex(param1:int) : void
      {
         this.mTargetTierIndex = param1;
      }
      
      public function getAnimKey() : String
      {
         return this.mAnimKey;
      }
      
      private function setAnimKey(param1:String) : void
      {
         this.mAnimKey = param1;
      }
      
      public function getAnimIconName() : String
      {
         return this.mAnimIconName;
      }
      
      private function setAnimIconName(param1:String) : void
      {
         this.mAnimIconName = param1;
      }
      
      public function getSoundName() : String
      {
         return this.mSoundName;
      }
      
      private function setSoundName(param1:String) : void
      {
         this.mSoundName = param1;
      }
      
      public function hasAnimation() : Boolean
      {
         return this.getAnimKey() != null && this.getAnimKey() != "";
      }
      
      private function readChancesJSON(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         _loc3_ = param1["chancesMultiplier"];
         if(_loc3_ != null)
         {
            _loc4_ = Utils.cleanMasterString(_loc3_);
            this.mChancesArr = _loc4_ != "" ? _loc4_.split(",") : null;
         }
      }
      
      public function getChances() : Dictionary
      {
         var _loc1_:Dictionary = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         if(this.mChancesArr != null)
         {
            _loc3_ = 0;
            while(_loc3_ < this.mChancesArr.length)
            {
               _loc2_ = String(this.mChancesArr[_loc3_]).split(":");
               if(_loc1_ == null)
               {
                  _loc1_ = new Dictionary(true);
               }
               _loc1_[_loc2_[1]] = _loc2_[0];
               _loc3_++;
            }
         }
         return _loc1_;
      }
      
      public function getCostRange() : int
      {
         return this.mCostRange;
      }
      
      public function stopsResumedPvPActions() : Boolean
      {
         return this.mStopsResumedPvPActions;
      }
      
      public function getApValue() : int
      {
         return this.mApValue;
      }
      
      public function getZoomIconInCombat() : Boolean
      {
         return this.mZoomIconInCombat;
      }
      
      public function setAbilityTargetKeynames(param1:Array) : void
      {
         this.mAbilityTargetKeynames = param1;
      }
      
      public function getAbilityTargetKeynames() : Array
      {
         return this.mAbilityTargetKeynames;
      }
      
      private function setMultiplierByCard(param1:int) : void
      {
         this.mMultiplierByCard = param1;
      }
      
      public function getMultiplierByCard() : int
      {
         return this.mMultiplierByCard;
      }
      
      public function getExtraSummonCost() : int
      {
         return this.mExtraSummonCost;
      }
      
      private function setExtraSummonCost(param1:int) : void
      {
         this.mExtraSummonCost = param1;
      }
      
      public function isCardEligibleForAbility(param1:FSCard) : Boolean
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:CardDef = null;
         var _loc7_:int = 0;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         var _loc2_:Boolean = false;
         if(param1 != null)
         {
            _loc6_ = param1.getCardDef();
            if(_loc6_ != null)
            {
               _loc3_ = this.getCategorySku();
               _loc2_ = _loc3_ == null || _loc3_ == "" || _loc3_ == _loc6_.getCategorySku();
               if(this.isSpecial() && _loc2_)
               {
                  _loc2_ = InstanceMng.getAbilitiesMng().isCardEligibleForSpecialAbility(param1,this);
               }
               if(_loc2_)
               {
                  _loc2_ = Utils.isAnySubcategorySkuAllowed(this.getSubCategorySku(),_loc6_.getSubCategorySku());
               }
               if(_loc2_)
               {
                  _loc2_ = Utils.isAnyGroupIdAllowed(this.getGroupsIds(),_loc6_.getGroupsIds());
               }
               if(_loc2_)
               {
                  _loc5_ = this.getTierIndex();
                  _loc2_ = _loc5_ == 0 || _loc5_ >= _loc6_.getTier();
               }
               if(_loc2_)
               {
                  _loc4_ = this.getFactionSku();
                  _loc2_ = _loc4_ == null || _loc4_ == "" || _loc4_ == _loc6_.getFactionSku();
               }
               if(_loc2_)
               {
                  _loc8_ = param1 ? param1.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_UNTARGETABLE) != null : false;
                  _loc2_ = !_loc8_;
               }
               if(_loc2_)
               {
                  _loc9_ = this.getItemsEquipped();
                  _loc10_ = param1 is FSUnit && FSUnit(param1).hasAttachments();
                  _loc2_ = !_loc9_ || _loc9_ && _loc10_;
               }
            }
         }
         return _loc2_;
      }
      
      public function isPassive() : Boolean
      {
         return this.mIsPassive;
      }
      
      public function getAnimAsset() : String
      {
         return this.mAnimAsset;
      }
      
      public function getEndAnimAsset() : String
      {
         return this.mEndAnimAsset;
      }
      
      public function getAnimDuration() : Number
      {
         return this.mAnimDuration;
      }
      
      public function getParticleName() : String
      {
         return this.mAnimParticleName;
      }
      
      public function getParticleAnimBezierCurves() : int
      {
         return this.mAnimParticleBezierCurves;
      }
      
      public function getDamageFactor() : Number
      {
         return this.mDamageFactor;
      }
      
      public function getDefenseFactor() : Number
      {
         return this.mDefenseFactor;
      }
      
      public function getAnimatedBGFPS() : int
      {
         return this.mBGAnimatedFPS;
      }
      
      public function getGroupsIds() : Array
      {
         return this.mGroupsIds;
      }
      
      public function getChildAbs() : Array
      {
         return this.mChildAbilities;
      }
      
      public function isParentAbility() : Boolean
      {
         return this.mChildAbilities != null && this.mChildAbilities.length > 0;
      }
      
      public function getShield() : int
      {
         return this.mShield;
      }
      
      public function getPlayerHeal() : int
      {
         return this.mPlayerHeal;
      }
      
      public function resetsDamage() : Boolean
      {
         return this.mResetDamage;
      }
      
      public function resetsDefense() : Boolean
      {
         return this.mResetDefense;
      }
      
      public function resetsAbilities() : Boolean
      {
         return this.mResetAbilities;
      }
      
      public function getItemsEquipped() : Boolean
      {
         return this.mItemsEquipped;
      }
      
      public function getForcedDamage() : int
      {
         return this.mForceDamage;
      }
      
      public function getForcedDefense() : int
      {
         return this.mForceDefense;
      }
      
      public function getForcedDesc() : String
      {
         return this.mForcedDesc != null ? TextManager.getText(this.mForcedDesc,true) : "";
      }
      
      public function getAPGenerated() : int
      {
         return this.mApGenerated;
      }
      
      override public function getDesc() : String
      {
         var _loc1_:String = "";
         var _loc2_:String = this.getForcedDesc();
         if(_loc2_ != "" && _loc2_ != null)
         {
            return _loc2_;
         }
         var _loc3_:String = this.getSpecialAbilityDesc();
         var _loc4_:String = this.getTriggerDesc();
         var _loc5_:String = this.getTargetDesc();
         var _loc6_:String = this.getHealDesc();
         var _loc7_:String = this.getDamageDefenseDesc();
         var _loc8_:String = this.getDamageDefenseFactorDesc();
         var _loc9_:String = this.getShieldDesc();
         var _loc10_:String = this.getConditionalDesc();
         var _loc11_:String = this.getPlayerHealDesc();
         var _loc12_:String = this.getResetStatsDesc();
         var _loc13_:String = this.getForceStatsDesc();
         var _loc14_:String = this.getPoisonDesc();
         var _loc15_:String = this.getDestroyDesc();
         var _loc16_:String = this.getApValueDesc();
         var _loc17_:String = this.getMultiplierByCardDesc();
         var _loc18_:String = this.getExtraSummonCostDesc();
         var _loc19_:String = this.getAPGeneratedDesc();
         var _loc20_:String = this.getChancesMultiplierDesc();
         var _loc21_:String = this.getHasItemsEquippedDesc();
         _loc1_ += _loc4_ != "" ? _loc4_ + " " : "";
         _loc1_ += _loc3_ != "" ? _loc3_ + " " : "";
         _loc1_ += _loc14_ != "" ? _loc14_ + " " : "";
         _loc1_ += _loc6_ != "" ? _loc6_ + " " : "";
         _loc1_ += _loc7_ != "" ? _loc7_ + " " : "";
         _loc1_ += _loc8_ != "" ? _loc8_ + " " : "";
         _loc1_ += _loc9_ != "" ? _loc9_ + " " : "";
         _loc1_ += _loc12_ != "" ? _loc12_ + " " : "";
         _loc1_ += _loc13_ != "" ? _loc13_ + " " : "";
         _loc1_ += _loc10_ != "" ? _loc10_ + " " : "";
         _loc1_ += _loc15_ != "" ? _loc15_ + " " : "";
         _loc1_ += _loc16_ != "" ? _loc16_ + " " : "";
         _loc1_ += _loc19_ != "" ? _loc19_ + " " : "";
         _loc1_ += _loc18_ != "" ? _loc18_ + " " : "";
         _loc1_ += _loc5_ != "" ? _loc5_ + " " : "";
         _loc1_ += _loc11_ != "" ? _loc11_ + " " : "";
         _loc1_ += _loc17_ != "" ? _loc17_ + " " : "";
         _loc1_ += _loc20_ != "" ? _loc20_ + " " : "";
         _loc1_ += _loc21_ != "" ? _loc21_ + " " : "";
         _loc1_ = _loc1_.replace(/  +/g," ");
         return _loc1_.replace(" .",".");
      }
      
      private function getAPGeneratedDesc() : String
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc1_:String = "";
         var _loc4_:int = this.mApGenerated;
         if(this.mApGenerated != 0)
         {
            if(this.mApGenerated < 0)
            {
               if(this.mTargetIndex == AbilitiesMng.TARGET_FRIENDLY_PLAYER)
               {
                  if(this.mApGenerated < -1)
                  {
                     _loc4_ += 1;
                     _loc2_ = "TID_AB_REDUCE_AP";
                     _loc1_ = TextManager.replaceParameters(TextManager.getText(_loc2_,true),[Math.abs(_loc4_)]);
                  }
                  else if(this.mApGenerated == -1)
                  {
                     _loc1_ = TextManager.getText("TID_AB_NO_AP",true);
                  }
               }
               else
               {
                  _loc2_ = "TID_AB_REDUCE_AP";
                  _loc1_ = TextManager.replaceParameters(TextManager.getText(_loc2_,true),[Math.abs(_loc4_)]);
               }
            }
            else
            {
               _loc2_ = "TID_AB_ADDS_AP";
               _loc1_ = TextManager.replaceParameters(TextManager.getText(_loc2_,true),[_loc4_]);
            }
         }
         return _loc1_;
      }
      
      private function getTypeFilterDesc() : String
      {
         var _loc1_:String = "";
         var _loc2_:String = this.getTierIndexDesc();
         var _loc3_:String = this.getFactionDesc();
         var _loc4_:String = this.getSCategoryDesc();
         var _loc5_:String = this.getCategoryDesc();
         var _loc6_:String = this.getGroupIdsDesc();
         var _loc7_:String = "%U%U1%U2%U3%U4 ";
         var _loc8_:Boolean = _loc2_ != "" || _loc5_ != "" || _loc4_ != "" || _loc3_ != "" || _loc6_ != "";
         if(_loc8_)
         {
            _loc1_ = TextManager.replaceParameters(_loc7_,[_loc2_,_loc3_,_loc4_,_loc5_,_loc6_]);
         }
         return _loc1_;
      }
      
      private function getGroupIdsDesc() : String
      {
         var _loc2_:int = 0;
         var _loc3_:GroupIdDef = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc1_:String = "";
         if(this.mGroupsIds != null && this.mGroupsIds.length > 0)
         {
            _loc4_ = this.mGroupsIds.length > 1 ? " (" : " ";
            _loc5_ = this.mGroupsIds.length > 1 ? ")" : "";
            _loc2_ = 0;
            while(_loc2_ < this.mGroupsIds.length)
            {
               if(this.mGroupsIds[_loc2_])
               {
                  _loc3_ = GroupIdDef(InstanceMng.getGroupIdsDefMng().getDefByIndex(this.mGroupsIds[_loc2_]));
                  if(_loc3_)
                  {
                     _loc6_ = _loc3_.getName() ? _loc3_.getName() : "";
                     _loc1_ += _loc1_ == "" ? _loc4_ + _loc6_.toLowerCase() : ", " + _loc6_.toLowerCase();
                  }
               }
               _loc2_++;
            }
            _loc1_ += _loc5_;
         }
         return _loc1_;
      }
      
      private function getChancesMultiplierDesc() : String
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:String = "";
         if(this.mChancesArr != null)
         {
            _loc4_ = 0;
            _loc3_ = 0;
            while(_loc3_ < this.mChancesArr.length)
            {
               _loc2_ = String(this.mChancesArr[_loc3_]).split(":");
               _loc4_ = _loc2_[1] > _loc4_ ? int(_loc2_[1]) : _loc4_;
               _loc3_++;
            }
            _loc1_ = TextManager.replaceParameters(TextManager.getText("TID_AB_MULTICAST_CHANCE",true),[_loc4_]);
         }
         return _loc1_;
      }
      
      private function getTriggerDesc() : String
      {
         var _loc1_:String = "";
         switch(this.mTriggerIndex)
         {
            case AbilitiesMng.TRIGGERS_SPECIAL:
            case AbilitiesMng.TRIGGERS_ON_PLAY:
               _loc1_ = "";
               break;
            case AbilitiesMng.TRIGGERS_ON_START:
               _loc1_ = "TID_AB_TURN_START";
               break;
            case AbilitiesMng.TRIGGERS_ON_COMBAT:
            case AbilitiesMng.TRIGGERS_ON_ATTACK:
               _loc1_ = "TID_AB_IN_COMBAT";
               break;
            case AbilitiesMng.TRIGGERS_ON_DEFENSE:
               _loc1_ = "TID_AB_DEFENDING";
               break;
            case AbilitiesMng.TRIGGERS_ON_END:
               _loc1_ = "TID_AB_TURN_END";
               break;
            case AbilitiesMng.TRIGGERS_ON_PROMOTE:
               _loc1_ = "TID_AB_PROMOTING";
         }
         return _loc1_ != "" ? TextManager.getText(_loc1_,true) : _loc1_;
      }
      
      public function getTargetDesc() : String
      {
         var _loc2_:AbilityDef = null;
         if(this.mKeyName == AbilitiesMng.SPECIAL_CONDITIONAL)
         {
            return "";
         }
         var _loc1_:String = "";
         var _loc3_:AbilitiesDefMng = InstanceMng.getAbilitiesDefMng();
         var _loc4_:String = "";
         var _loc5_:int = 0;
         if(this.mAbilityTargetKeynames != null && this.mAbilityTargetKeynames.length > 0)
         {
            _loc5_ = 0;
            while(_loc5_ < this.mAbilityTargetKeynames.length)
            {
               _loc2_ = AbilityDef(_loc3_.getAbilityDefByKeyname(this.mAbilityTargetKeynames[_loc5_]));
               if(_loc2_)
               {
                  _loc4_ += _loc4_ == "" ? _loc2_.getName() : ", " + _loc2_.getName();
               }
               _loc5_++;
            }
         }
         var _loc6_:String = this.getTypeFilterDesc();
         var _loc7_:Array = null;
         switch(this.mTargetIndex)
         {
            case AbilitiesMng.TARGET_ALL:
               _loc1_ = "TID_AB_ALL_CARDS_PLAYERS";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_ALL_FRIENDLY:
               _loc1_ = "TID_AB_ALL_FRIENDLY_CARDS_PLAYER";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_ALL_ENEMY:
               _loc1_ = "TID_AB_ALL_ENEMY_CARDS_ENEMY_PLAYER";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_ALL_PLAYERS:
               _loc1_ = TextManager.getText("TID_AB_BOTH_PLAYERS",true);
               break;
            case AbilitiesMng.TARGET_ALL_CARDS:
               _loc1_ = "TID_AB_ALL_CARDS";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_ALL_FRIENDLY_CARDS:
               _loc1_ = "TID_AB_ALL_FRIENDLY_CARDS";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_ALL_ENEMY_CARDS:
               _loc1_ = "TID_AB_ALL_ENEMY_CARDS";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_FRIENDLY_PLAYER:
               _loc1_ = TextManager.getText("TID_AB_PLAYER",true);
               break;
            case AbilitiesMng.TARGET_ENEMY_PLAYER:
               _loc1_ = TextManager.getText("TID_AB_ENEMY_PLAYER",true);
               break;
            case AbilitiesMng.TARGET_FRIENDLY:
               _loc1_ = "TID_AB_FRIENDLY_CARD_OR_PLAYER";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_ENEMY:
               _loc1_ = "TID_AB_ENEMY_CARD_OR_PLAYER";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_FRIENDLY_CARD:
               _loc1_ = "TID_AB_FRIENDLY_CARD";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_ENEMY_CARD:
               _loc1_ = "TID_AB_ENEMY_CARD";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_SELF_CARD:
               _loc1_ = "TID_AB_THIS_CARD";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_FRIENDLY_ADJACENT_CARD:
               _loc1_ = "TID_AB_FRIENDLY_ADJ_CARDS";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_FRIENDLY_ATTACK_CARD:
               _loc1_ = "TID_AB_FRIENDLY_CARD_FRONT_LANE";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_ENEMY_OPPOSITE_CARD:
            case AbilitiesMng.TARGET_ENEMY_CARD_IN_FRONT:
            case AbilitiesMng.TARGET_CARD_IN_COMBAT:
               _loc1_ = "TID_AB_ENEMY_CARD_SAME_LANE";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_ENEMY_RANDOM_CARD:
               _loc1_ = "TID_AB_RANDOM_ENEMY_CARD";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_FRIENDLY_RANDOM_CARD:
               _loc1_ = "TID_AB_RANDOM_FRIENDLY_CARD";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_RANDOM_CARD:
               _loc1_ = "TID_AB_RANDOM_CARD";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_CARD:
               _loc1_ = "TID_AB_CARD";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_ENEMY_CARD_COST_LOWER_THAN:
               _loc1_ = "TID_AB_ENEMY_CARD_COST_LOWER";
               _loc7_ = [_loc6_,this.mCostRange - 1];
               break;
            case AbilitiesMng.TARGET_ENEMY_CARD_COST_HIGHER_THAN:
               _loc1_ = "TID_AB_ENEMY_CARD_COST_HIGHER";
               _loc7_ = [_loc6_,this.mCostRange + 1];
               break;
            case AbilitiesMng.TARGET_FRIENDLY_CARD_COST_LOWER_THAN:
               _loc1_ = "TID_AB_FRIENDLY_CARD_COST_LOWER";
               _loc7_ = [_loc6_,this.mCostRange - 1];
               break;
            case AbilitiesMng.TARGET_FRIENDLY_CARD_COST_HIGHER_THAN:
               _loc1_ = "TID_AB_FRIENDLY_CARD_COST_HIGHER";
               _loc7_ = [_loc6_,this.mCostRange + 1];
               break;
            case AbilitiesMng.TARGET_RANDOM_CARD_COST_LOWER_THAN:
               _loc1_ = "TID_AB_RANDOM_CARD_COST_LOWER";
               _loc7_ = [_loc6_,this.mCostRange - 1];
               break;
            case AbilitiesMng.TARGET_RANDOM_CARD_COST_HIGHER_THAN:
               _loc1_ = "TID_AB_RANDOM_CARD_COST_HIGHER";
               _loc7_ = [_loc6_,this.mCostRange + 1];
               break;
            case AbilitiesMng.TARGET_ALL_ENEMY_CARD_COST_LOWER_THAN:
               _loc1_ = "TID_AB_ALL_ENEMY_CARDS_COST_LOWER";
               _loc7_ = [_loc6_,this.mCostRange - 1];
               break;
            case AbilitiesMng.TARGET_ALL_ENEMY_CARD_COST_HIGHER_THAN:
               _loc1_ = "TID_AB_ALL_ENEMY_CARDS_COST_HIGHER";
               _loc7_ = [_loc6_,this.mCostRange + 1];
               break;
            case AbilitiesMng.TARGET_ALL_FRIENDLY_CARD_COST_LOWER_THAN:
               _loc1_ = "TID_AB_ALL_FRIENDLY_CARDS_COST_LOWER";
               _loc7_ = [_loc6_,this.mCostRange - 1];
               break;
            case AbilitiesMng.TARGET_ALL_FRIENDLY_CARD_COST_HIGHER_THAN:
               _loc1_ = "TID_AB_ALL_FRIENDLY_CARDS_COST_HIGHER";
               _loc7_ = [_loc6_,this.mCostRange + 1];
               break;
            case AbilitiesMng.TARGET_ALL_CARDS_COST_LOWER_THAN:
               _loc1_ = "TID_AB_ALL_CARDS_COST_LOWER";
               _loc7_ = [_loc6_,this.mCostRange - 1];
               break;
            case AbilitiesMng.TARGET_ALL_CARDS_COST_HIGHER_THAN:
               _loc1_ = "TID_AB_ALL_CARDS_COST_HIGHER";
               _loc7_ = [_loc6_,this.mCostRange + 1];
               break;
            case AbilitiesMng.TARGET_ENEMY_CARD_ATTACK_LOWER_THAN:
               _loc1_ = "TID_AB_ENEMY_CARD_DAMAGE_LOWER";
               _loc7_ = [_loc6_,this.mCostRange - 1];
               break;
            case AbilitiesMng.TARGET_ENEMY_CARD_ATTACK_HIGHER_THAN:
               _loc1_ = "TID_AB_ENEMY_CARD_DAMAGE_HIGHER";
               _loc7_ = [_loc6_,this.mCostRange + 1];
               break;
            case AbilitiesMng.TARGET_FRIENDLY_CARD_ATTACK_LOWER_THAN:
               _loc1_ = "TID_AB_FRIENDLY_CARD_DAMAGE_LOWER";
               _loc7_ = [_loc6_,this.mCostRange - 1];
               break;
            case AbilitiesMng.TARGET_FRIENDLY_CARD_ATTACK_HIGHER_THAN:
               _loc1_ = "TID_AB_FRIENDLY_CARD_DAMAGE_HIGHER";
               _loc7_ = [_loc6_,this.mCostRange + 1];
               break;
            case AbilitiesMng.TARGET_RANDOM_CARD_ATTACK_LOWER_THAN:
               _loc1_ = "TID_AB_RANDOM_CARD_DAMAGE_LOWER";
               _loc7_ = [_loc6_,this.mCostRange - 1];
               break;
            case AbilitiesMng.TARGET_RANDOM_CARD_ATTACK_HIGHER_THAN:
               _loc1_ = "TID_AB_RANDOM_CARD_DAMAGE_HIGHER";
               _loc7_ = [_loc6_,this.mCostRange + 1];
               break;
            case AbilitiesMng.TARGET_ALL_ENEMY_CARD_ATTACK_LOWER_THAN:
               _loc1_ = "TID_AB_ALL_ENEMY_CARDS_DAMAGE_LOWER";
               _loc7_ = [_loc6_,this.mCostRange - 1];
               break;
            case AbilitiesMng.TARGET_ALL_ENEMY_CARD_ATTACK_HIGHER_THAN:
               _loc1_ = "TID_AB_ALL_ENEMY_CARDS_DAMAGE_HIGHER";
               _loc7_ = [_loc6_,this.mCostRange + 1];
               break;
            case AbilitiesMng.TARGET_ALL_FRIENDLY_CARD_ATTACK_LOWER_THAN:
               _loc1_ = "TID_AB_ALL_FRIENDLY_CARDS_DAMAGE_LOWER";
               _loc7_ = [_loc6_,this.mCostRange - 1];
               break;
            case AbilitiesMng.TARGET_ALL_FRIENDLY_CARD_ATTACK_HIGHER_THAN:
               _loc1_ = "TID_AB_ALL_FRIENDLY_CARDS_DAMAGE_HIGHER";
               _loc7_ = [_loc6_,this.mCostRange + 1];
               break;
            case AbilitiesMng.TARGET_ALL_CARDS_ATTACK_LOWER_THAN:
               _loc1_ = "TID_AB_ALL_CARDS_DAMAGE_LOWER";
               _loc7_ = [_loc6_,this.mCostRange - 1];
               break;
            case AbilitiesMng.TARGET_ALL_CARDS_ATTACK_HIGHER_THAN:
               _loc1_ = "TID_AB_ALL_CARDS_DAMAGE_HIGHER";
               _loc7_ = [_loc6_,this.mCostRange + 1];
               break;
            case AbilitiesMng.TARGET_ENEMY_CARD_DEFENSE_LOWER_THAN:
               _loc1_ = "TID_AB_ENEMY_CARD_DEFENSE_LOWER";
               _loc7_ = [_loc6_,this.mCostRange - 1];
               break;
            case AbilitiesMng.TARGET_ENEMY_CARD_DEFENSE_HIGHER_THAN:
               _loc1_ = "TID_AB_ENEMY_CARD_DEFENSE_HIGHER";
               _loc7_ = [_loc6_,this.mCostRange + 1];
               break;
            case AbilitiesMng.TARGET_FRIENDLY_CARD_DEFENSE_LOWER_THAN:
               _loc1_ = "TID_AB_FRIENDLY_CARD_DEFENSE_LOWER";
               _loc7_ = [_loc6_,this.mCostRange - 1];
               break;
            case AbilitiesMng.TARGET_FRIENDLY_CARD_DEFENSE_HIGHER_THAN:
               _loc1_ = "TID_AB_FRIENDLY_CARD_DEFENSE_HIGHER";
               _loc7_ = [_loc6_,this.mCostRange + 1];
               break;
            case AbilitiesMng.TARGET_RANDOM_CARD_DEFENSE_LOWER_THAN:
               _loc1_ = "TID_AB_RANDOM_CARD_DEFENSE_LOWER";
               _loc7_ = [_loc6_,this.mCostRange - 1];
               break;
            case AbilitiesMng.TARGET_RANDOM_CARD_DEFENSE_HIGHER_THAN:
               _loc1_ = "TID_AB_RANDOM_CARD_DEFENSE_HIGHER";
               _loc7_ = [_loc6_,this.mCostRange + 1];
               break;
            case AbilitiesMng.TARGET_ALL_ENEMY_CARD_DEFENSE_LOWER_THAN:
               _loc1_ = "TID_AB_ALL_ENEMY_CARDS_DEFENSE_LOWER";
               _loc7_ = [_loc6_,this.mCostRange - 1];
               break;
            case AbilitiesMng.TARGET_ALL_ENEMY_CARD_DEFENSE_HIGHER_THAN:
               _loc1_ = "TID_AB_ALL_ENEMY_CARDS_DEFENSE_HIGHER";
               _loc7_ = [_loc6_,this.mCostRange + 1];
               break;
            case AbilitiesMng.TARGET_ALL_FRIENDLY_CARD_DEFENSE_LOWER_THAN:
               _loc1_ = "TID_AB_ALL_FRIENDLY_CARDS_DEFENSE_LOWER";
               _loc7_ = [_loc6_,this.mCostRange - 1];
               break;
            case AbilitiesMng.TARGET_ALL_FRIENDLY_CARD_DEFENSE_HIGHER_THAN:
               _loc1_ = "TID_AB_ALL_FRIENDLY_CARDS_DEFENSE_HIGHER";
               _loc7_ = [_loc6_,this.mCostRange + 1];
               break;
            case AbilitiesMng.TARGET_ALL_CARDS_DEFENSE_LOWER_THAN:
               _loc1_ = "TID_AB_ALL_CARDS_DEFENSE_LOWER";
               _loc7_ = [_loc6_,this.mCostRange - 1];
               break;
            case AbilitiesMng.TARGET_ALL_CARDS_DEFENSE_HIGHER_THAN:
               _loc1_ = "TID_AB_ALL_CARDS_DEFENSE_HIGHER";
               _loc7_ = [_loc6_,this.mCostRange + 1];
               break;
            case AbilitiesMng.TARGET_ALL_FRIENDLY_CARDS_EXCEPT_ITSELF:
               _loc1_ = "TID_AB_ALL_FRIENDLY_CARDS_EXCEPT_THIS";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_ALL_FRIENDLY_CARDS_BY_ABILITY:
               _loc1_ = "TID_AB_ALL_FRIENDLY_CARDS_WITH_AB";
               _loc7_ = [_loc6_,_loc4_];
               break;
            case AbilitiesMng.TARGET_ALL_ENEMY_CARDS_BY_ABILITY:
               _loc1_ = "TID_AB_ALL_ENEMY_CARDS_WITH_AB";
               _loc7_ = [_loc6_,_loc4_];
               break;
            case AbilitiesMng.TARGET_ALL_CARDS_BY_ABILITY:
               _loc1_ = "TID_AB_ALL_CARDS_WITH_AB";
               _loc7_ = [_loc6_,_loc4_];
               break;
            case AbilitiesMng.TARGET_FRIENDLY_CARDS_BY_ABILITY:
               _loc1_ = "TID_AB_FRIENDLY_CARD_WITH_AB";
               _loc7_ = [_loc6_,_loc4_];
               break;
            case AbilitiesMng.TARGET_ENEMY_CARDS_BY_ABILITY:
               _loc1_ = "TID_AB_ENEMY_CARD_WITH_AB";
               _loc7_ = [_loc6_,_loc4_];
               break;
            case AbilitiesMng.TARGET_CARDS_BY_ABILITY:
               _loc1_ = "TID_AB_CARD_WITH_AB";
               _loc7_ = [_loc6_,_loc4_];
               break;
            case AbilitiesMng.TARGET_ALL_CARDS_DECK:
               _loc1_ = "TID_AB_ALL_CARDS_IN_PLAYERS_HANDS";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_ALL_ENEMY_CARDS_DECK:
               _loc1_ = "TID_AB_ALL_CARDS_IN_OPPONENT_HAND";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_ALL_FRIENDLY_CARDS_DECK:
               _loc1_ = "TID_AB_ALL_CARDS_IN_OWNER_HAND";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_NEXT_CARD_DECK:
               _loc1_ = "TID_AB_NEXT_CARD_PLAYED";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_NEXT_ENEMY_CARD_DECK:
               _loc1_ = "TID_AB_NEXT_OPPONENT_CARD_PLAYED";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_NEXT_FRIENDLY_CARD_DECK:
               _loc1_ = "TID_AB_NEXT_FRIENDLY_CARD_PLAYED";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_FRIENDLY_CARDS_EXCEPT_ITSELF:
               _loc1_ = "TID_AB_FRIENDLY_CARD_IN_BF_EXCEPT_THIS";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_FRIENDLY_SUPPORT_LANE_CARDS:
               _loc1_ = "TID_AB_FRIENDLY_SUPPORT_CARDS";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_ENEMY_SUPPORT_LANE_CARDS:
               _loc1_ = "TID_AB_ENEMY_SUPPORT_CARDS";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_ALL_SUPPORT_LANE_CARDS:
               _loc1_ = "TID_AB_ALL_SUPPORT_CARDS";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_FRIENDLY_ATTACK_LANE_CARDS:
               _loc1_ = "TID_AB_FRIENDLY_ATTACK_CARDS";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_ENEMY_ATTACK_LANE_CARDS:
               _loc1_ = "TID_AB_ENEMY_ATTACK_CARDS";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_ALL_ATTACK_LANE_CARDS:
               _loc1_ = "TID_AB_ALL_ATTACK_CARDS";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_FRIENDLY_SUPPORT_LANE_CARD:
               _loc1_ = "TID_AB_FRIENDLY_SUPPORT_TARGET_CARD";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_ENEMY_SUPPORT_LANE_CARD:
               _loc1_ = "TID_AB_ENEMY_SUPPORT_TARGET_CARD";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_ALL_SUPPORT_LANE_CARD:
               _loc1_ = "TID_AB_ALL_SUPPORT_TARGET_CARD";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_FRIENDLY_ATTACK_LANE_CARD:
               _loc1_ = "TID_AB_FRIENDLY_ATTACK_TARGET_CARD";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_ENEMY_ATTACK_LANE_CARD:
               _loc1_ = "TID_AB_ENEMY_ATTACK_TARGET_CARD";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_ALL_ATTACK_LANE_CARD:
               _loc1_ = "TID_AB_ALL_ATTACK_TARGET_CARD";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_FRIENDLY_SUPPORT_LANE_CARDS_EXCEPT_ITSELF:
               _loc1_ = "TID_AB_FRIENDLY_SUPPORT_CARDS_EXCEPT_THIS";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_FRIENDLY_ATTACK_LANE_CARDS_EXCEPT_ITSELF:
               _loc1_ = "TID_AB_FRIENDLY_ATTACK_CARDS_EXCEPT_THIS";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_FRIENDLY_SUPPORT_LANE_CARD_EXCEPT_ITSELF:
               _loc1_ = "TID_AB_FRIENDLY_SUPPORT_TARGET_CARD_EXCEPT_THIS";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_FRIENDLY_ATTACK_LANE_CARD_EXCEPT_ITSELF:
               _loc1_ = "TID_AB_FRIENDLY_ATTACK_TARGET_CARD_EXCEPT_THIS";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_CARD_HIGHER_HEALTH_ALL_CARDS:
               _loc1_ = "TID_AB_CARD_HEALTH_HIGHEST";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_ENEMY_CARD_HIGHER_HEALTH:
               _loc1_ = "TID_AB_ENEMY_CARD_HEALTH_HIGHEST";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_ENEMY_CARD_HIGHER_HEALTH_SUPPORT_LANE:
               _loc1_ = "TID_AB_ENEMY_CARD_SUPPORT_HEALTH_HIGHEST";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_ENEMY_CARD_HIGHER_HEALTH_FRONT_LANE:
               _loc1_ = "TID_AB_ENEMY_CARD_FRONT_HEALTH_HIGHEST";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_FRIENDLY_CARD_HIGHER_HEALTH:
               _loc1_ = "TID_AB_FRIENDLY_CARD_HEALTH_HIGHEST";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_FRIENDLY_CARD_HIGHER_HEALTH_SUPPORT_LANE:
               _loc1_ = "TID_AB_FRIENDLY_CARD_SUPPORT_HEALTH_HIGHEST";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_FRIENDLY_CARD_HIGHER_HEALTH_FRONT_LANE:
               _loc1_ = "TID_AB_FRIENDLY_CARD_FRONT_HEALTH_HIGHEST";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_CARD_LOWER_HEALTH_ALL_CARDS:
               _loc1_ = "TID_AB_CARD_HEALTH_LOWEST";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_ENEMY_CARD_LOWER_HEALTH:
               _loc1_ = "TID_AB_ENEMY_CARD_HEALTH_LOWEST";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_ENEMY_CARD_LOWER_HEALTH_SUPPORT_LANE:
               _loc1_ = "TID_AB_ENEMY_CARD_SUPPORT_HEALTH_LOWEST";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_ENEMY_CARD_LOWER_HEALTH_FRONT_LANE:
               _loc1_ = "TID_AB_ENEMY_CARD_FRONT_HEALTH_LOWEST";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_FRIENDLY_CARD_LOWER_HEALTH:
               _loc1_ = "TID_AB_FRIENDLY_CARD_HEALTH_LOWEST";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_FRIENDLY_CARD_LOWER_HEALTH_SUPPORT_LANE:
               _loc1_ = "TID_AB_FRIENDLY_CARD_SUPPORT_HEALTH_LOWEST";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_FRIENDLY_CARD_LOWER_HEALTH_FRONT_LANE:
               _loc1_ = "TID_AB_FRIENDLY_CARD_FRONT_HEALTH_LOWEST";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_CARD_HIGHER_ATTACK_ALL_CARDS:
               _loc1_ = "TID_AB_CARD_ATTACK_HIGHEST";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_ENEMY_CARD_HIGHER_ATTACK:
               _loc1_ = "TID_AB_ENEMY_CARD_ATTACK_HIGHEST";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_ENEMY_CARD_HIGHER_ATTACK_SUPPORT_LANE:
               _loc1_ = "TID_AB_ENEMY_CARD_SUPPORT_ATTACK_HIGHEST";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_ENEMY_CARD_HIGHER_ATTACK_FRONT_LANE:
               _loc1_ = "TID_AB_ENEMY_CARD_FRONT_ATTACK_HIGHEST";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_FRIENDLY_CARD_HIGHER_ATTACK:
               _loc1_ = "TID_AB_FRIENDLY_CARD_ATTACK_HIGHEST";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_FRIENDLY_CARD_HIGHER_ATTACK_SUPPORT_LANE:
               _loc1_ = "TID_AB_FRIENDLY_CARD_SUPPORT_ATTACK_HIGHEST";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_FRIENDLY_CARD_HIGHER_ATTACK_FRONT_LANE:
               _loc1_ = "TID_AB_FRIENDLY_CARD_FRONT_ATTACK_HIGHEST";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_CARD_LOWER_ATTACK_ALL_CARDS:
               _loc1_ = "TID_AB_CARD_ATTACK_LOWEST";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_ENEMY_CARD_LOWER_ATTACK:
               _loc1_ = "TID_AB_ENEMY_CARD_ATTACK_LOWEST";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_ENEMY_CARD_LOWER_ATTACK_SUPPORT_LANE:
               _loc1_ = "TID_AB_ENEMY_CARD_SUPPORT_ATTACK_LOWEST";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_ENEMY_CARD_LOWER_ATTACK_FRONT_LANE:
               _loc1_ = "TID_AB_ENEMY_CARD_FRONT_ATTACK_LOWEST";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_FRIENDLY_CARD_LOWER_ATTACK:
               _loc1_ = "TID_AB_FRIENDLY_CARD_ATTACK_LOWEST";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_FRIENDLY_CARD_LOWER_ATTACK_SUPPORT_LANE:
               _loc1_ = "TID_AB_FRIENDLY_CARD_SUPPORT_ATTACK_LOWEST";
               _loc7_ = [_loc6_];
               break;
            case AbilitiesMng.TARGET_FRIENDLY_CARD_LOWER_ATTACK_FRONT_LANE:
               _loc1_ = "TID_AB_FRIENDLY_CARD_FRONT_ATTACK_LOWEST";
               _loc7_ = [_loc6_];
         }
         return _loc7_ != null ? TextManager.replaceParameters(TextManager.getText(_loc1_,true),_loc7_) : _loc1_;
      }
      
      private function getDurationDesc() : String
      {
         var _loc1_:String = "";
         if(this.mDuration > 0)
         {
            _loc1_ = TextManager.replaceParameters(TextManager.getText("TID_AB_LASTS_X_TURNS",true),[this.mDuration]);
         }
         return _loc1_;
      }
      
      private function getHealDesc() : String
      {
         var _loc1_:String = "";
         var _loc2_:int = this.mRandomHealAmount <= 0 ? int(this.mHeal + this.mRandomHealAmount) : this.mHeal;
         var _loc3_:int = this.mRandomHealAmount > 0 ? int(this.mHeal + this.mRandomHealAmount) : this.mHeal;
         var _loc4_:int = _loc2_;
         var _loc5_:int = _loc3_;
         if(this.mHeal != 0)
         {
            if(this.mRandomHealAmount != 0)
            {
               _loc2_ = Math.abs(_loc5_) < Math.abs(_loc4_) ? _loc5_ : _loc4_;
               _loc3_ = Math.abs(_loc5_) < Math.abs(_loc4_) ? _loc4_ : _loc5_;
               _loc1_ = _loc2_ < 0 ? TextManager.getText("TID_AB_DEALS_RANGE",true) : TextManager.getText("TID_AB_HEALS_RANGE",true);
               _loc1_ = TextManager.replaceParameters(_loc1_,[Math.abs(_loc2_),Math.abs(_loc3_)]);
            }
            else
            {
               _loc1_ = this.mHeal > 0 ? TextManager.getText("TID_AB_HEALS_HP",true) : TextManager.getText("TID_AB_DEALS_DMG",true);
               _loc1_ = TextManager.replaceParameters(_loc1_,[Math.abs(this.mHeal)]);
            }
         }
         return _loc1_;
      }
      
      private function getDamageDefenseDesc() : String
      {
         var _loc1_:String = "";
         var _loc2_:String = "";
         var _loc3_:int = this.mRandomDamageAmount <= 0 ? int(this.mDamage + this.mRandomDamageAmount) : this.mDamage;
         var _loc4_:int = this.mRandomDamageAmount > 0 ? int(this.mDamage + this.mRandomDamageAmount) : this.mDamage;
         var _loc5_:int = this.mRandomDefenseAmount <= 0 ? int(this.mDefense + this.mRandomDefenseAmount) : this.mDefense;
         var _loc6_:int = this.mRandomDefenseAmount > 0 ? int(this.mDefense + this.mRandomDefenseAmount) : this.mDefense;
         if(this.mDamage != 0 || this.mDefense != 0)
         {
            if(this.mDamage != 0 && this.mDefense != 0)
            {
               if(this.mRandomDamageAmount != 0 && this.mRandomDefenseAmount != 0)
               {
                  _loc1_ = TextManager.replaceParameters(TextManager.getText("TID_AB_GIVES_DMG_DEF_RANGE",true),[this.formatStatValueForDesc(_loc3_),this.formatStatValueForDesc(_loc4_),this.formatStatValueForDesc(_loc5_),this.formatStatValueForDesc(_loc6_)]);
               }
               else if(this.mRandomDamageAmount != 0)
               {
                  _loc1_ = TextManager.replaceParameters(TextManager.getText("TID_AB_GIVES_DMG_RANGE",true),[this.formatStatValueForDesc(_loc3_),this.formatStatValueForDesc(_loc4_)]);
               }
               else if(this.mRandomDefenseAmount != 0)
               {
                  _loc1_ = TextManager.replaceParameters(TextManager.getText("TID_AB_GIVES_DEF_RANGE",true),[this.formatStatValueForDesc(_loc5_),this.formatStatValueForDesc(_loc6_)]);
               }
               else
               {
                  _loc1_ = TextManager.replaceParameters(TextManager.getText("TID_AB_GIVES",true),[this.formatStatValueForDesc(this.mDamage),this.formatStatValueForDesc(this.mDefense)]);
               }
            }
            else if(this.mDamage != 0)
            {
               if(this.mRandomDamageAmount != 0)
               {
                  _loc1_ = TextManager.replaceParameters(TextManager.getText("TID_AB_GIVES_DMG_RANGE",true),[this.formatStatValueForDesc(_loc3_),this.formatStatValueForDesc(_loc4_)]);
               }
               else
               {
                  _loc2_ = this.mDamage > 0 ? TextManager.getText("TID_AB_INCR_DMG",true) : TextManager.getText("TID_AB_REDUCES_DMG",true);
                  _loc1_ = TextManager.replaceParameters(_loc2_,[Math.abs(this.mDamage)]);
               }
            }
            else if(this.mDefense != 0)
            {
               if(this.mRandomDefenseAmount != 0)
               {
                  _loc1_ = TextManager.replaceParameters(TextManager.getText("TID_AB_GIVES_DEF_RANGE",true),[this.formatStatValueForDesc(_loc5_),this.formatStatValueForDesc(_loc6_)]);
               }
               else
               {
                  _loc2_ = this.mDefense > 0 ? TextManager.getText("TID_AB_INCR_DEF",true) : TextManager.getText("TID_AB_DEALS_DMG",true);
                  _loc1_ = TextManager.replaceParameters(_loc2_,[Math.abs(this.mDefense)]);
               }
            }
         }
         return _loc1_;
      }
      
      private function getDamageDefenseFactorDesc() : String
      {
         var _loc3_:int = 0;
         var _loc1_:String = "";
         var _loc2_:String = "";
         if(this.mDamageFactor != 0 || this.mDefenseFactor != 0)
         {
            _loc3_ = Config.getConfig().battleGetMaxAddition();
            if(this.mDamageFactor != 0 && this.mDefenseFactor != 0)
            {
               _loc1_ = TextManager.replaceParameters(TextManager.getText("TID_AB_GIVES_DMG_DEF_PERCENT",true),[this.mDamageFactor * 100,this.mDefenseFactor * 100,_loc3_]);
            }
            else if(this.mDamageFactor != 0)
            {
               _loc2_ = this.mDamageFactor < 0 ? TextManager.getText("TID_AB_DECR_DMG_PERCENT",true) : TextManager.getText("TID_AB_GIVES_DMG_PERCENT",true);
               _loc1_ = this.mDamageFactor < 0 ? TextManager.replaceParameters(_loc2_,[Math.abs(this.mDamageFactor) * 100]) : TextManager.replaceParameters(_loc2_,[Math.abs(this.mDamageFactor) * 100,_loc3_]);
            }
            else if(this.mDefenseFactor != 0)
            {
               _loc2_ = this.mDefenseFactor < 0 ? TextManager.getText("TID_AB_DECR_DEF_PERCENT",true) : TextManager.getText("TID_AB_GIVES_DEF_PERCENT",true);
               _loc1_ = this.mDefenseFactor < 0 ? TextManager.replaceParameters(_loc2_,[Math.abs(this.mDefenseFactor) * 100]) : TextManager.replaceParameters(_loc2_,[Math.abs(this.mDefenseFactor) * 100,_loc3_]);
            }
         }
         return _loc1_;
      }
      
      private function getCategoryDesc() : String
      {
         var _loc1_:String = this.mCategorySku != null ? "(" + CategoryDef(InstanceMng.getCategoriesDefMng().getDefBySku(this.mCategorySku)).getNameForAbility().toLowerCase() + ")" : "";
         return " " + _loc1_;
      }
      
      private function getSCategoryDesc() : String
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc1_:String = "";
         var _loc2_:SubCategoryDef = null;
         var _loc3_:String = "";
         if(this.mSubCategorySku != null)
         {
            _loc4_ = this.mSubCategorySku.length > 1 ? " (" : "";
            _loc5_ = this.mSubCategorySku.length > 1 ? ")" : "";
            _loc6_ = 0;
            while(_loc6_ < this.mSubCategorySku.length)
            {
               _loc2_ = this.mSubCategorySku[_loc6_] != "" ? SubCategoryDef(InstanceMng.getSubCategoriesDefMng().getDefBySku(this.mSubCategorySku[_loc6_])) : null;
               if(_loc2_)
               {
                  _loc3_ += _loc3_ == "" ? _loc4_ + _loc2_.getNameForAbility().toLowerCase() : ", " + _loc2_.getNameForAbility().toLowerCase();
               }
               _loc6_++;
            }
            _loc3_ += _loc5_;
         }
         if(_loc3_ != "")
         {
            _loc1_ = " " + _loc3_;
         }
         return _loc1_;
      }
      
      private function getFactionDesc() : String
      {
         var _loc1_:String = "";
         var _loc2_:String = this.mFactionSku ? FactionDef(InstanceMng.getFactionsDefMng().getDefBySku(this.mFactionSku)).getNameForAbilityTID() : "";
         if(_loc2_ != "")
         {
            _loc1_ = " " + TextManager.getText(_loc2_,true);
         }
         return _loc1_;
      }
      
      private function getDestroyDesc() : String
      {
         return this.mDestroy ? TextManager.getText("TID_AB_DESTROYS",true) : "";
      }
      
      private function getTierIndexDesc() : String
      {
         var _loc2_:Boolean = false;
         var _loc1_:String = "";
         if(this.mTierIndex > 0)
         {
            _loc2_ = Config.getConfig().cardBGChangesOnPromote();
            if(_loc2_ && this.mTierIndex == 1)
            {
               _loc1_ = TextManager.getText("TID_GEN_RANK_SPECIAL",true);
            }
            else
            {
               _loc1_ = TextManager.replaceParameters(TextManager.getText("TID_AB_RANK",true),[this.mTierIndex]) + " ";
            }
         }
         return _loc1_;
      }
      
      private function getApValueDesc() : String
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc1_:String = "";
         if(this.mApValue != 0)
         {
            _loc2_ = this.mApValue < 0 ? TextManager.getText("TID_AB_REDUCE_AP",true) : TextManager.getText("TID_AB_EXTRA_AP",true);
            _loc3_ = this.mApValue < 0 ? Math.abs(this.mApValue).toString() : this.formatStatValueForDesc(this.mApValue);
            _loc1_ = TextManager.replaceParameters(_loc2_,[_loc3_]);
         }
         return _loc1_;
      }
      
      private function getMultiplierByCardDesc() : String
      {
         var _loc1_:String = "";
         var _loc2_:String = this.getTypeFilterDesc();
         if(this.mMultiplierByCard > 0)
         {
            if(this.mMultiplierByCard == 1)
            {
               _loc1_ = TextManager.getText("TID_AB_MULTIPLIER_BF",true);
            }
            else if(this.mMultiplierByCard == 2)
            {
               _loc1_ = TextManager.getText("TID_AB_MULTIPLIER_HAND",true);
            }
            _loc1_ = TextManager.replaceParameters(_loc1_,[_loc2_]);
         }
         return _loc1_;
      }
      
      private function getHasItemsEquippedDesc() : String
      {
         var _loc1_:String = "";
         if(this.mItemsEquipped)
         {
            _loc1_ = TextManager.getText("TID_AB_ITEMS_EQUIPPED",true);
         }
         return _loc1_;
      }
      
      private function getExtraSummonCostDesc() : String
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc1_:String = "";
         if(this.mKeyName == AbilitiesMng.SPECIAL_MODIFYCOST)
         {
            _loc2_ = this.mExtraSummonCost > 0 ? TextManager.getText("TID_AB_INCR_AP_COST",true) : TextManager.getText("TID_AB_DECR_AP_COST",true);
            _loc1_ = TextManager.replaceParameters(_loc2_,[Math.abs(this.mExtraSummonCost)]);
         }
         else if(this.mKeyName == AbilitiesMng.SPECIAL_FIXEDCOST)
         {
            _loc2_ = TextManager.getText("TID_AB_CHANGE_AP_COST",true);
            _loc1_ = TextManager.replaceParameters(_loc2_,[this.mExtraSummonCost]);
         }
         return _loc1_;
      }
      
      private function getPoisonDesc() : String
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc1_:String = "";
         if(this.mKeyName == AbilitiesMng.SPECIAL_POISON)
         {
            _loc1_ = TextManager.replaceParameters(TextManager.getText("TID_AB_POISON",true),[Math.abs(this.getPoisonDamage())]);
         }
         return _loc1_;
      }
      
      private function getSpecialAbilityDesc() : String
      {
         var _loc3_:String = null;
         var _loc1_:String = "";
         var _loc2_:String = "TID_SPEC_AB_";
         if(Boolean(this.mKeyName) && this.mKeyName != "")
         {
            _loc3_ = _loc2_ + this.mKeyName.toUpperCase();
            _loc1_ = TextManager.getText(_loc3_,true);
            _loc1_ = _loc1_ != null ? _loc1_ : "";
         }
         return _loc1_;
      }
      
      private function getShieldDesc() : String
      {
         var _loc2_:String = null;
         var _loc1_:String = "";
         if(this.mShield > 0)
         {
            if(this.mKeyName == AbilitiesMng.SPECIAL_EVASION)
            {
               _loc2_ = this.getTypeFilterDesc();
               _loc1_ = this.mShield >= 999 ? TextManager.replaceParameters(TextManager.getText("TID_AB_IMMUNE_EVASION",true),[_loc2_]) : TextManager.replaceParameters(TextManager.getText("TID_AB_EVASION",true),[_loc2_,this.mShield]);
            }
            else
            {
               _loc1_ = this.mShield >= 999 ? TextManager.getText("TID_AB_IMMUNE",true) : TextManager.replaceParameters(TextManager.getText("TID_AB_REINFORCE",true),[this.mShield]);
            }
         }
         return _loc1_;
      }
      
      private function getConditionalDesc() : String
      {
         var _loc2_:String = null;
         var _loc3_:AbilityDef = null;
         var _loc4_:String = null;
         var _loc1_:String = "";
         if(this.mKeyName == AbilitiesMng.SPECIAL_CONDITIONAL)
         {
            _loc2_ = this.getTypeFilterDesc();
            _loc3_ = AbilityDef(InstanceMng.getAbilitiesDefMng().getDefBySku(this.mUnlockAbilitySku));
            _loc4_ = _loc3_.getName();
            if(this.mTargetIndex == AbilitiesMng.TARGET_ALL_FRIENDLY_CARDS_EXCEPT_ITSELF)
            {
               _loc1_ = TextManager.replaceParameters(TextManager.getText("TID_AB_CONDITIONAL_FRIENDLY_CARDS",true),[_loc4_,_loc2_]);
            }
            else if(this.mTargetIndex == AbilitiesMng.TARGET_ALL_ENEMY_CARDS)
            {
               _loc1_ = TextManager.replaceParameters(TextManager.getText("TID_AB_CONDITIONAL_ENEMY_CARDS",true),[_loc4_,_loc2_]);
            }
         }
         return _loc1_;
      }
      
      private function getPlayerHealDesc() : String
      {
         var _loc1_:String = "";
         var _loc2_:String = "";
         if(this.mPlayerHeal != 0)
         {
            _loc2_ = this.mPlayerHeal > 0 ? TextManager.getText("TID_AB_HEALS_OWNER",true) : TextManager.getText("TID_AB_HARMS_OWNER",true);
            _loc1_ = TextManager.replaceParameters(_loc2_,[Math.abs(this.mPlayerHeal)]);
         }
         return _loc1_;
      }
      
      private function getResetStatsDesc() : String
      {
         var _loc1_:String = "";
         if(this.mResetDamage || this.mResetDefense || this.mResetAbilities)
         {
            if(this.mResetDamage && this.mResetDefense && this.mResetAbilities)
            {
               _loc1_ = TextManager.getText("TID_AB_RESTORE_DMG_DEF_AB",true);
            }
            else if(this.mResetDamage && this.mResetDefense)
            {
               _loc1_ = TextManager.getText("TID_AB_RESTORE_DMG_DEF",true);
            }
            else if(this.mResetDamage && this.mResetAbilities)
            {
               _loc1_ = TextManager.getText("TID_AB_RESTORE_DMG_AB",true);
            }
            else if(this.mResetDefense && this.mResetAbilities)
            {
               _loc1_ = TextManager.getText("TID_AB_RESTORE_DEF_AB",true);
            }
            else if(this.mResetDamage)
            {
               _loc1_ = TextManager.getText("TID_AB_RESTORE_DMG",true);
            }
            else if(this.mResetDefense)
            {
               _loc1_ = TextManager.getText("TID_AB_RESTORE_DEF",true);
            }
            else if(this.mResetAbilities)
            {
               _loc1_ = TextManager.getText("TID_AB_RESTORE_AB",true);
            }
         }
         return _loc1_;
      }
      
      private function getForceStatsDesc() : String
      {
         var _loc1_:String = "";
         if(this.mForceDamage != -1 || this.mForceDefense != -1)
         {
            if(this.mForceDamage != -1 && this.mForceDefense != -1)
            {
               _loc1_ = TextManager.replaceParameters(TextManager.getText("TID_AB_CHANGE_DMG_DEF",true),[this.mForceDamage,this.mForceDefense]);
            }
            else if(this.mForceDamage != -1)
            {
               _loc1_ = TextManager.replaceParameters(TextManager.getText("TID_AB_CHANGE_DMG",true),[this.mForceDamage]);
            }
            else if(this.mForceDefense != -1)
            {
               _loc1_ = TextManager.replaceParameters(TextManager.getText("TID_AB_CHANGE_DEF",true),[this.mForceDefense]);
            }
         }
         return _loc1_;
      }
      
      private function formatStatValueForDesc(param1:int) : String
      {
         return param1 > 0 ? "+" + param1 : param1.toString();
      }
      
      public function getCompositeName() : String
      {
         var _loc2_:AbilityDef = null;
         var _loc3_:int = 0;
         var _loc1_:String = "";
         if(this.isParentAbility())
         {
            _loc3_ = 0;
            while(_loc3_ < this.mChildAbilities.length)
            {
               _loc2_ = AbilityDef(InstanceMng.getAbilitiesDefMng().getDefBySku(this.mChildAbilities[_loc3_]));
               if(_loc2_)
               {
                  _loc1_ += _loc3_ > 0 ? ", " + _loc2_.getName() : _loc2_.getName();
               }
               _loc3_++;
            }
            return _loc1_;
         }
         return mDesc;
      }
      
      public function isRandomTargetAbility() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = this.getTargetIndex();
         switch(_loc2_)
         {
            case AbilitiesMng.TARGET_ENEMY_RANDOM_CARD:
            case AbilitiesMng.TARGET_FRIENDLY_RANDOM_CARD:
            case AbilitiesMng.TARGET_RANDOM_CARD:
               _loc1_ = true;
         }
         return _loc1_;
      }
      
      public function getUnlockAbilitySku() : String
      {
         return this.mUnlockAbilitySku;
      }
   }
}

