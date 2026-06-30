package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.Utils;
   
   public class UnitDef extends CardDef
   {
      
      private var mSummonCooldown:int;
      
      private var mBeginsOnAttackLane:Boolean;
      
      private var mDealDamageAnimSku:String;
      
      private var mDamageAudio:String;
      
      private var mStrongSubcategorySku:String;
      
      private var mWeakSubcategorySku:String;
      
      private var mCombatSize:String = "";
      
      private var mOnPlaySound:String;
      
      private var mNoEquip:Boolean;
      
      private var mEmblemRequiredToPromote:FSNumber;
      
      public function UnitDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         super.doFromJSON(param1);
         if("summonCooldown" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.summonCooldown);
            this.setSummonCooldown(int(_loc2_));
         }
         if("beginsOnAttackLane" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.beginsOnAttackLane);
            this.setBeginsOnAttackLane(Utils.stringToBoolean(_loc2_));
         }
         if("dealDamageAnimSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.dealDamageAnimSku);
            this.setDealDamageAnimSku(_loc2_);
         }
         if("damageAudio" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.damageAudio);
            this.setDamageAudioName(_loc2_);
         }
         if("strong" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.strong);
            this.setStrongSubcategorySku(_loc2_);
         }
         if("weak" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.weak);
            this.setWeakSubcategorySku(_loc2_);
         }
         if("size" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.size);
            this.setCombatSize(_loc2_);
         }
         if("onPlaySound" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.onPlaySound);
            this.setOnPlaySound(_loc2_);
         }
         if("noEquip" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.noEquip);
            this.mNoEquip = Utils.stringToBoolean(_loc2_);
         }
         if("emblemRequiredToPromote" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.emblemRequiredToPromote);
            this.setEmblemRequiredToPromote(int(_loc2_));
         }
      }
      
      public function getSummonCooldown() : int
      {
         return this.mSummonCooldown;
      }
      
      public function setSummonCooldown(param1:int) : void
      {
         this.mSummonCooldown = param1;
      }
      
      public function getBeginsOnAttackLane() : Boolean
      {
         return this.mBeginsOnAttackLane;
      }
      
      public function setBeginsOnAttackLane(param1:Boolean) : void
      {
         this.mBeginsOnAttackLane = param1;
      }
      
      public function getDealDamageAnimSku() : String
      {
         return this.mDealDamageAnimSku;
      }
      
      public function setDealDamageAnimSku(param1:String) : void
      {
         this.mDealDamageAnimSku = param1;
      }
      
      public function setDamageAudioName(param1:String) : void
      {
         this.mDamageAudio = param1;
      }
      
      public function getDamageAudioName() : String
      {
         return this.mDamageAudio;
      }
      
      public function setStrongSubcategorySku(param1:String) : void
      {
         this.mStrongSubcategorySku = param1;
      }
      
      public function getStrongSubcategorySku() : String
      {
         return this.mStrongSubcategorySku;
      }
      
      public function setWeakSubcategorySku(param1:String) : void
      {
         this.mWeakSubcategorySku = param1;
      }
      
      public function getWeakSubcategorySku() : String
      {
         return this.mWeakSubcategorySku;
      }
      
      public function setCombatSize(param1:String) : void
      {
         this.mCombatSize = param1;
      }
      
      public function getCombatSize() : String
      {
         return this.mCombatSize;
      }
      
      public function setOnPlaySound(param1:String) : void
      {
         this.mOnPlaySound = param1;
      }
      
      public function getOnPlaySound() : String
      {
         return this.mOnPlaySound;
      }
      
      public function getCanEquipItems() : Boolean
      {
         return !this.mNoEquip;
      }
      
      private function setEmblemRequiredToPromote(param1:int) : void
      {
         if(this.mEmblemRequiredToPromote == null)
         {
            this.mEmblemRequiredToPromote = new FSNumber();
         }
         this.mEmblemRequiredToPromote.value = param1;
      }
      
      public function getEmblemRequiredToPromote() : int
      {
         return this.mEmblemRequiredToPromote ? int(this.mEmblemRequiredToPromote.value) : 0;
      }
   }
}

