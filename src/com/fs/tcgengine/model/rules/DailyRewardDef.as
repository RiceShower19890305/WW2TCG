package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.Utils;
   
   public class DailyRewardDef extends Def
   {
      
      private var mGold:FSNumber;
      
      private var mDay:int;
      
      private var mPackSku:String = "";
      
      private var mType:int;
      
      private var mQuestCoins:FSNumber;
      
      private var mRaidPoints:FSNumber;
      
      private var mIsOldPlayerComingBackDef:Boolean;
      
      public function DailyRewardDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         super.doFromJSON(param1);
         if("day" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.day);
            this.setDay(int(_loc2_));
         }
         if("gold" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gold);
            this.setGold(int(_loc2_));
         }
         if("packSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.packSku);
            this.setPackSku(_loc2_);
         }
         if("type" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.type);
            this.setType(int(_loc2_));
         }
         if("questCoins" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.questCoins);
            this.setQuestCoins(int(_loc2_));
         }
         if("raidPoints" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.raidPoints);
            this.setRaidPoints(int(_loc2_));
         }
         if("oldPlayerComingBackDef" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.oldPlayerComingBackDef);
            this.mIsOldPlayerComingBackDef = Utils.stringToBoolean(_loc2_);
         }
      }
      
      private function setRaidPoints(param1:int) : void
      {
         if(this.mRaidPoints == null)
         {
            this.mRaidPoints = new FSNumber();
         }
         this.mRaidPoints.value = Number(param1);
      }
      
      public function getRaidCoins() : int
      {
         return this.mRaidPoints ? int(this.mRaidPoints.value) : 0;
      }
      
      public function getQuestCoins() : int
      {
         return this.mQuestCoins ? int(this.mQuestCoins.value) : 0;
      }
      
      private function setQuestCoins(param1:int) : void
      {
         if(this.mQuestCoins == null)
         {
            this.mQuestCoins = new FSNumber();
         }
         this.mQuestCoins.value = Number(param1);
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
      
      public function getDay() : int
      {
         return this.mDay;
      }
      
      public function setDay(param1:int) : void
      {
         this.mDay = param1;
      }
      
      public function getPackSku() : String
      {
         return this.mPackSku;
      }
      
      public function setPackSku(param1:String) : void
      {
         this.mPackSku = param1;
      }
      
      public function getType() : int
      {
         return this.mType;
      }
      
      public function setType(param1:int) : void
      {
         this.mType = param1;
      }
      
      public function isOldPlayerComingBackDef() : Boolean
      {
         return this.mIsOldPlayerComingBackDef;
      }
   }
}

