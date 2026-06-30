package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.Utils;
   
   public class GoldDef extends Def
   {
      
      private var mGold:FSNumber;
      
      private var mShowInShop:Boolean;
      
      private var mTokens:FSNumber;
      
      public function GoldDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         super.doFromJSON(param1);
         if("gold" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gold);
            this.setGold(int(_loc2_));
         }
         if("showInShop" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.showInShop);
            this.setShowInShop(Utils.stringToBoolean(_loc2_));
         }
         if("tokens" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.tokens);
            this.setTokens(int(_loc2_));
         }
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
      
      public function getShowInShop() : Boolean
      {
         return this.mShowInShop;
      }
      
      public function setShowInShop(param1:Boolean) : void
      {
         this.mShowInShop = param1;
      }
      
      public function setTokens(param1:int) : void
      {
         if(this.mTokens == null)
         {
            this.mTokens = new FSNumber();
         }
         this.mTokens.value = Number(param1);
      }
      
      public function getTokens() : int
      {
         return this.mTokens ? int(this.mTokens.value) : 0;
      }
   }
}

