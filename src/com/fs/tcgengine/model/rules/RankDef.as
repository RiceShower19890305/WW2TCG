package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.Utils;
   
   public class RankDef extends Def
   {
      
      private var mGainedOnLevel:FSNumber;
      
      private var mBadgeSku:String;
      
      private var mMessage:String;
      
      private var mComplementaryName:String;
      
      public function RankDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         super.doFromJSON(param1);
         if("gainedOnLevel" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gainedOnLevel);
            this.setGainedOnLevel(int(_loc2_));
         }
         if("badgeSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.badgeSku);
            this.setBadgeSku(_loc2_);
         }
         if("message" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.message);
            this.setMessage(_loc2_);
         }
         if("complementaryName" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.complementaryName);
            this.mComplementaryName = _loc2_;
         }
      }
      
      public function getGainedOnLevel() : int
      {
         return this.mGainedOnLevel ? int(this.mGainedOnLevel.value) : 0;
      }
      
      public function setGainedOnLevel(param1:int) : void
      {
         if(this.mGainedOnLevel == null)
         {
            this.mGainedOnLevel = new FSNumber();
         }
         this.mGainedOnLevel.value = Number(param1);
      }
      
      public function getBadgeSku() : String
      {
         return this.mBadgeSku;
      }
      
      public function setBadgeSku(param1:String) : void
      {
         this.mBadgeSku = param1;
      }
      
      public function getMessage() : String
      {
         return TextManager.getText(this.mMessage);
      }
      
      public function setMessage(param1:String) : void
      {
         this.mMessage = param1;
      }
      
      public function getComplementaryName() : String
      {
         return this.mComplementaryName;
      }
   }
}

