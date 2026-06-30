package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.Utils;
   
   public class ShopBoostDef extends Def
   {
      
      private var mShowInShop:Boolean;
      
      private var mBoostSku:String;
      
      private var mExecuteOnBuy:Boolean;
      
      private var mRepurchasable:Boolean;
      
      private var mKeyName:String;
      
      public function ShopBoostDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         super.doFromJSON(param1);
         if("showInShop" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.showInShop);
            this.setShowInShop(Utils.stringToBoolean(_loc2_));
         }
         if("boostSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.boostSku);
            this.setBoostSku(_loc2_);
         }
         if("executeOnBuy" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.executeOnBuy);
            this.setExecuteOnBuy(Utils.stringToBoolean(_loc2_));
         }
         if("rePurchasable" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.rePurchasable);
            this.setRepurchasable(Utils.stringToBoolean(_loc2_));
         }
         if("keyName" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.keyName);
            this.setKeyName(_loc2_);
         }
      }
      
      public function getShowInShop() : Boolean
      {
         return this.mShowInShop;
      }
      
      public function setShowInShop(param1:Boolean) : void
      {
         this.mShowInShop = param1;
      }
      
      public function getBoostSku() : String
      {
         return this.mBoostSku;
      }
      
      public function setBoostSku(param1:String) : void
      {
         this.mBoostSku = param1;
      }
      
      public function getExecuteOnBuy() : Boolean
      {
         return this.mExecuteOnBuy;
      }
      
      public function setExecuteOnBuy(param1:Boolean) : void
      {
         this.mExecuteOnBuy = param1;
      }
      
      public function isRepurchasable() : Boolean
      {
         return this.mRepurchasable;
      }
      
      public function setRepurchasable(param1:Boolean) : void
      {
         this.mRepurchasable = param1;
      }
      
      public function getKeyName() : String
      {
         return this.mKeyName;
      }
      
      public function setKeyName(param1:String) : void
      {
         this.mKeyName = param1;
      }
   }
}

