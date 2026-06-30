package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.Utils;
   
   public class JobDef extends Def
   {
      
      private var mBasicDeckSku:String;
      
      private var mBgIcon:String;
      
      private var mIsBasic:int;
      
      private var mUnlockLevel:int;
      
      private var mPassiveSku:String;
      
      private var mActiveSkuArr:Array;
      
      private var mDefaultSkinSku:String;
      
      private var mRestrictionFactionSkuArr:Array;
      
      private var mUnlockSecondaryAbiliyLevel:FSNumber;
      
      private var mUnlockCost:FSNumber;
      
      private var mLockedByQuest:String;
      
      private var mJobLevelUpFrame:String;
      
      public function JobDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         super.doFromJSON(param1);
         if("basicDeckSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.basicDeckSku);
            this.mBasicDeckSku = String(_loc2_);
         }
         if("bgIcon" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.bgIcon);
            this.mBgIcon = String(_loc2_);
         }
         if("isBasic" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.isBasic);
            this.mIsBasic = int(_loc2_);
         }
         if("unlockLevel" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.unlockLevel);
            this.mUnlockLevel = int(_loc2_);
         }
         if("passiveSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.passiveSku);
            this.mPassiveSku = String(_loc2_);
         }
         if("powersSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.powersSku);
            this.mActiveSkuArr = String(_loc2_).split(",");
         }
         if("defaultSkinSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.defaultSkinSku);
            this.mDefaultSkinSku = String(_loc2_);
         }
         if("restrictionFactionSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.restrictionFactionSku);
            this.mRestrictionFactionSkuArr = String(_loc2_).split(",");
         }
         if("unlockSecondaryAbiliyLevel" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.unlockSecondaryAbiliyLevel);
            this.setUnlockSecondaryAbiliyLevel(int(_loc2_));
         }
         if("unlockCost" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.unlockCost);
            this.setUnlockCost(int(_loc2_));
         }
         if("lockedByQuest" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.lockedByQuest);
            this.mLockedByQuest = _loc2_;
         }
         if("jobLevelUpFrame" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.jobLevelUpFrame);
            this.mJobLevelUpFrame = _loc2_;
         }
      }
      
      private function setUnlockCost(param1:int) : void
      {
         if(this.mUnlockCost == null)
         {
            this.mUnlockCost = new FSNumber();
         }
         this.mUnlockCost.value = param1;
      }
      
      private function setUnlockSecondaryAbiliyLevel(param1:int) : void
      {
         if(this.mUnlockSecondaryAbiliyLevel == null)
         {
            this.mUnlockSecondaryAbiliyLevel = new FSNumber();
         }
         this.mUnlockSecondaryAbiliyLevel.value = param1;
      }
      
      public function getBasicDeckSku() : String
      {
         return this.mBasicDeckSku;
      }
      
      public function getBgIcon() : String
      {
         return this.mBgIcon;
      }
      
      public function isBasicDeck() : Boolean
      {
         return this.mIsBasic == 1;
      }
      
      public function getUnlockLevel() : int
      {
         return this.mUnlockLevel;
      }
      
      public function getPassiveSku() : String
      {
         return this.mPassiveSku;
      }
      
      public function getActiveDefaultSku() : String
      {
         return this.mActiveSkuArr[0];
      }
      
      public function getActiveSecondarySku() : String
      {
         return this.mActiveSkuArr[1];
      }
      
      public function getDefaultSkinSku() : String
      {
         return this.mDefaultSkinSku;
      }
      
      public function getRestrictionFactionSkuArr() : Array
      {
         return this.mRestrictionFactionSkuArr;
      }
      
      public function getUnlockSecondaryAbiliyLevel() : int
      {
         return this.mUnlockSecondaryAbiliyLevel ? int(this.mUnlockSecondaryAbiliyLevel.value) : 0;
      }
      
      public function getUnlockCost() : int
      {
         return this.mUnlockCost ? int(this.mUnlockCost.value) : 0;
      }
      
      public function isLockedByQuest() : Boolean
      {
         return this.mLockedByQuest != "" && this.mLockedByQuest != null;
      }
      
      public function getLockedByQuestSku() : String
      {
         return this.mLockedByQuest;
      }
      
      public function getLevelUpFrame() : String
      {
         return this.mJobLevelUpFrame;
      }
   }
}

