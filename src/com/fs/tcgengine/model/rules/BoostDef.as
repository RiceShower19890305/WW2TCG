package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.Utils;
   
   public class BoostDef extends Def
   {
      
      private var mKeyName:String;
      
      private var mValue:int;
      
      private var mIsPermanent:Boolean;
      
      private var mBGBuy:String;
      
      public function BoostDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         super.doFromJSON(param1);
         if("keyName" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.keyName);
            this.setKeyName(_loc2_);
         }
         if("value" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.value);
            this.setValue(int(_loc2_));
         }
         if("isPermanent" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.isPermanent);
            this.setIsPermanent(Utils.stringToBoolean(_loc2_));
         }
         if("bgBuy" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.bgBuy);
            this.setBGBuy(_loc2_);
         }
      }
      
      public function getKeyName() : String
      {
         return this.mKeyName;
      }
      
      public function setKeyName(param1:String) : void
      {
         this.mKeyName = param1;
      }
      
      public function getValue() : int
      {
         return this.mValue;
      }
      
      public function setValue(param1:int) : void
      {
         this.mValue = param1;
      }
      
      public function isPermanent() : Boolean
      {
         return this.mIsPermanent;
      }
      
      public function setIsPermanent(param1:Boolean) : void
      {
         this.mIsPermanent = param1;
      }
      
      private function setBGBuy(param1:String) : void
      {
         this.mBGBuy = param1;
      }
      
      public function getBGBuy() : String
      {
         return this.mBGBuy;
      }
   }
}

