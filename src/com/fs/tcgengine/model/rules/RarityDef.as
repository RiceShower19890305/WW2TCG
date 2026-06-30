package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.Utils;
   
   public class RarityDef extends Def
   {
      
      private var mBGPack:String;
      
      private var mMaxAmountPerDeck:FSNumber;
      
      private var mAuctionValueGold:FSNumber;
      
      private var mAuctionMinGold:FSNumber;
      
      private var mAuctionMaxGold:FSNumber;
      
      private var mAuctionOffsetGold:FSNumber;
      
      private var mSkinFrameColorsArray:Array;
      
      private var mSkinBGColorsArray:Array;
      
      private var mAuctionCreateCost:FSNumber;
      
      private var mAuctionBidCost:FSNumber;
      
      private var mHasAura:Boolean;
      
      private var mCardValue:FSNumber;
      
      public function RarityDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         super.doFromJSON(param1);
         if("bgPack" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.bgPack);
            this.setBGPack(_loc2_);
         }
         if("maxAmountPerDeck" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.maxAmountPerDeck);
            this.setMaxAmountPerDeck(int(_loc2_));
         }
         if("auctionValueGold" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.auctionValueGold);
            this.setAuctionValueGold(int(_loc2_));
         }
         if("auctionMinGold" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.auctionMinGold);
            this.setAuctionMinGold(int(_loc2_));
         }
         if("auctionMaxGold" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.auctionMaxGold);
            this.setAuctionMaxGold(int(_loc2_));
         }
         if("auctionOffSet" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.auctionOffSet);
            this.setAuctionOffsetGold(int(_loc2_));
         }
         if("skinFrameColors" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.skinFrameColors);
            this.mSkinFrameColorsArray = _loc2_.split(",");
         }
         if("skinBGColors" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.skinBGColors);
            this.mSkinBGColorsArray = _loc2_.split(",");
         }
         if("auctionCreateCost" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.auctionCreateCost);
            this.setAuctionCreateCost(int(_loc2_));
         }
         if("auctionBidCost" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.auctionBidCost);
            this.setAuctionBidCost(int(_loc2_));
         }
         if("hasAura" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.hasAura);
            this.mHasAura = Utils.stringToBoolean(_loc2_);
         }
         if("cardValue" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.cardValue);
            this.setCardValue(int(_loc2_));
         }
      }
      
      public function getBGPack() : String
      {
         return this.mBGPack;
      }
      
      public function setBGPack(param1:String) : void
      {
         this.mBGPack = param1;
      }
      
      public function getMaxAmountPerDeck() : int
      {
         return this.mMaxAmountPerDeck ? int(this.mMaxAmountPerDeck.value) : 0;
      }
      
      public function setMaxAmountPerDeck(param1:int) : void
      {
         if(this.mMaxAmountPerDeck == null)
         {
            this.mMaxAmountPerDeck = new FSNumber();
         }
         this.mMaxAmountPerDeck.value = Number(param1);
      }
      
      private function setAuctionValueGold(param1:int) : void
      {
         if(this.mAuctionValueGold == null)
         {
            this.mAuctionValueGold = new FSNumber();
         }
         this.mAuctionValueGold.value = Number(param1);
      }
      
      private function setAuctionMinGold(param1:int) : void
      {
         if(this.mAuctionMinGold == null)
         {
            this.mAuctionMinGold = new FSNumber();
         }
         this.mAuctionMinGold.value = Number(param1);
      }
      
      private function setAuctionMaxGold(param1:int) : void
      {
         if(this.mAuctionMaxGold == null)
         {
            this.mAuctionMaxGold = new FSNumber();
         }
         this.mAuctionMaxGold.value = Number(param1);
      }
      
      private function setAuctionOffsetGold(param1:int) : void
      {
         if(this.mAuctionOffsetGold == null)
         {
            this.mAuctionOffsetGold = new FSNumber();
         }
         this.mAuctionOffsetGold.value = Number(param1);
      }
      
      private function setAuctionCreateCost(param1:int) : void
      {
         if(this.mAuctionCreateCost == null)
         {
            this.mAuctionCreateCost = new FSNumber();
         }
         this.mAuctionCreateCost.value = Number(param1);
      }
      
      private function setAuctionBidCost(param1:int) : void
      {
         if(this.mAuctionBidCost == null)
         {
            this.mAuctionBidCost = new FSNumber();
         }
         this.mAuctionBidCost.value = Number(param1);
      }
      
      public function getAuctionValueGold() : int
      {
         return this.mAuctionValueGold ? int(this.mAuctionValueGold.value) : 0;
      }
      
      public function getAuctionMinGold() : int
      {
         return this.mAuctionMinGold ? int(this.mAuctionMinGold.value) : 0;
      }
      
      public function getAuctionMaxGold() : int
      {
         return this.mAuctionMaxGold ? int(this.mAuctionMaxGold.value) : 0;
      }
      
      public function getAuctionOffsetGold() : int
      {
         return this.mAuctionOffsetGold ? int(this.mAuctionOffsetGold.value) : 0;
      }
      
      public function getSkinFrameColors() : Array
      {
         return this.mSkinFrameColorsArray;
      }
      
      public function getSkinBGColors() : Array
      {
         return this.mSkinBGColorsArray;
      }
      
      public function getAuctionCreateCost() : int
      {
         return this.mAuctionCreateCost ? int(this.mAuctionCreateCost.value) : 0;
      }
      
      public function getAuctionBidCost() : int
      {
         return this.mAuctionBidCost ? int(this.mAuctionBidCost.value) : 0;
      }
      
      public function getHasAura() : Boolean
      {
         return this.mHasAura;
      }
      
      public function getCardValue() : int
      {
         return this.mCardValue ? int(this.mCardValue.value) : 0;
      }
      
      public function setCardValue(param1:int) : void
      {
         if(this.mCardValue == null)
         {
            this.mCardValue = new FSNumber();
         }
         this.mCardValue.value = param1;
      }
   }
}

