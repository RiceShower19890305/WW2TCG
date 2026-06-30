package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.Utils;
   
   public class AIMovementDef extends Def
   {
      
      private var mAIUnitsBFAmount:int;
      
      private var mPlayerUnitsInBFAmount:int;
      
      private var mUnitChance:Number;
      
      private var mUpgradeChance:Number;
      
      private var mAttachmentChance:Number;
      
      private var mActionChance:Number;
      
      private var mPowerChance:Number;
      
      public function AIMovementDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         super.doFromJSON(param1);
         if("AIUnitsBFAmount" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.AIUnitsBFAmount);
            this.setAIUnitsBFAmount(int(_loc2_));
         }
         if("playerUnitsInBFAmount" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.playerUnitsInBFAmount);
            this.setPlayerUnitsInBFAmount(int(_loc2_));
         }
         if("unitChance" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.unitChance);
            this.setUnitChance(Number(_loc2_));
         }
         if("upgradeChance" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.upgradeChance);
            this.setUpgradeChance(Number(_loc2_));
         }
         if("attachmentChance" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.attachmentChance);
            this.setAttachmentChance(Number(_loc2_));
         }
         if("actionChance" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.actionChance);
            this.setActionChance(Number(_loc2_));
         }
         if("powerChance" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.powerChance);
            this.setPowerChance(Number(_loc2_));
         }
      }
      
      public function getAIUnitsBFAmount() : int
      {
         return this.mAIUnitsBFAmount;
      }
      
      public function setAIUnitsBFAmount(param1:int) : void
      {
         this.mAIUnitsBFAmount = param1;
      }
      
      public function getPlayerUnitsInBFAmount() : int
      {
         return this.mPlayerUnitsInBFAmount;
      }
      
      public function setPlayerUnitsInBFAmount(param1:int) : void
      {
         this.mPlayerUnitsInBFAmount = param1;
      }
      
      public function getUnitChance() : Number
      {
         return this.mUnitChance;
      }
      
      public function setUnitChance(param1:Number) : void
      {
         this.mUnitChance = param1;
      }
      
      public function getUpgradeChance() : Number
      {
         return this.mUpgradeChance;
      }
      
      public function setUpgradeChance(param1:Number) : void
      {
         this.mUpgradeChance = param1;
      }
      
      public function getAttachmentChance() : Number
      {
         return this.mAttachmentChance;
      }
      
      public function setAttachmentChance(param1:Number) : void
      {
         this.mAttachmentChance = param1;
      }
      
      public function getActionChance() : Number
      {
         return this.mActionChance;
      }
      
      public function setActionChance(param1:Number) : void
      {
         this.mActionChance = param1;
      }
      
      public function getPowerChance() : int
      {
         return this.mPowerChance;
      }
      
      public function setPowerChance(param1:Number) : void
      {
         this.mPowerChance = param1;
      }
   }
}

