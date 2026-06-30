package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.Utils;
   import flash.utils.Dictionary;
   
   public class PvPBotDeckDef extends Def
   {
      
      private var mAIUnits:Dictionary;
      
      private var mAIActions:Dictionary;
      
      private var mAIAttachments:Dictionary;
      
      private var mAIPowerSku:String;
      
      private var mAIPortraitSku:String;
      
      private var mAISkinSku:String;
      
      private var mAICurrentLevelSku:String;
      
      private var mAIElo:int;
      
      private var mIAPassiveAbilitySku:String;
      
      private var mIAJobSku:String;
      
      private var mAIDeck:Dictionary;
      
      public function PvPBotDeckDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         if("IAPowerSku" in param1)
         {
            if(String(param1.IAPowerSku) != "")
            {
               _loc3_ = Utils.cleanMasterString(param1.IAPowerSku);
               this.mAIPowerSku = _loc3_;
            }
         }
         if("IAPortraitSku" in param1)
         {
            if(String(param1.IAPortraitSku) != "")
            {
               _loc3_ = Utils.cleanMasterString(param1.IAPortraitSku);
               this.mAIPortraitSku = _loc3_;
            }
         }
         if("IASkinSku" in param1)
         {
            if(String(param1.IASkinSku) != "")
            {
               _loc3_ = Utils.cleanMasterString(param1.IASkinSku);
               this.mAISkinSku = _loc3_;
            }
         }
         if("IACurrentLevelSku" in param1)
         {
            if(String(param1.IACurrentLevelSku) != "")
            {
               _loc3_ = Utils.cleanMasterString(param1.IACurrentLevelSku);
               this.mAICurrentLevelSku = _loc3_;
            }
         }
         if("IAUnitsSku" in param1)
         {
            if(String(param1.IAUnitsSku) != "")
            {
               _loc3_ = Utils.cleanMasterString(param1.IAUnitsSku);
               this.setIAUnits(_loc3_.split(","));
            }
         }
         if("IAActionsSku" in param1)
         {
            if(String(param1.IAActionsSku) != "")
            {
               _loc3_ = Utils.cleanMasterString(param1.IAActionsSku);
               this.setIAActions(_loc3_.split(","));
            }
         }
         if("IAAttachmentsSku" in param1)
         {
            if(String(param1.IAAttachmentsSku) != "")
            {
               _loc3_ = Utils.cleanMasterString(param1.IAAttachmentsSku);
               this.setIAAttachments(_loc3_.split(","));
            }
         }
         if("IAElo" in param1)
         {
            if(String(param1.IAElo) != "")
            {
               _loc3_ = Utils.cleanMasterString(param1.IAElo);
               this.setIAElo(int(_loc3_));
            }
         }
         if("IApassiveAbilitySku" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.IApassiveAbilitySku);
            this.mIAPassiveAbilitySku = _loc3_;
         }
         if("jobSku" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.jobSku);
            this.mIAJobSku = _loc3_;
         }
      }
      
      public function getIAPowerSku() : String
      {
         return this.mAIPowerSku;
      }
      
      public function getIAPortraitSku() : String
      {
         return this.mAIPortraitSku;
      }
      
      public function getIASkinSku() : String
      {
         return this.mAISkinSku;
      }
      
      public function getIAElo() : int
      {
         return this.mAIElo;
      }
      
      public function setIAElo(param1:int) : void
      {
         this.mAIElo = param1;
      }
      
      public function getIACurrentLevelSku() : String
      {
         return this.mAICurrentLevelSku;
      }
      
      public function getIAUnits() : Dictionary
      {
         return this.mAIUnits;
      }
      
      public function setIAUnits(param1:Array) : void
      {
         this.mAIUnits = DictionaryUtils.addCards(param1,this.mAIUnits);
         this.mAIDeck = DictionaryUtils.addCards(param1,this.mAIDeck);
      }
      
      public function getIAActions() : Dictionary
      {
         return this.mAIActions;
      }
      
      public function setIAActions(param1:Array) : void
      {
         this.mAIActions = DictionaryUtils.addCards(param1,this.mAIActions);
         this.mAIDeck = DictionaryUtils.addCards(param1,this.mAIDeck);
      }
      
      public function getIAAttachments() : Dictionary
      {
         return this.mAIAttachments;
      }
      
      public function setIAAttachments(param1:Array) : void
      {
         this.mAIAttachments = DictionaryUtils.addCards(param1,this.mAIAttachments);
         this.mAIDeck = DictionaryUtils.addCards(param1,this.mAIDeck);
      }
      
      public function getAIPassiveAbilitySku() : String
      {
         return this.mIAPassiveAbilitySku;
      }
      
      public function getAIJobSku() : String
      {
         return this.mIAJobSku;
      }
      
      public function getDeckValue() : int
      {
         return Utils.getDeckValue(this.mAIDeck);
      }
   }
}

