package com.fs.tcgengine.model.auctions
{
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.Utils;
   
   public class Bid implements FSModelUnloadableInterface
   {
      
      private var mBidId:String;
      
      private var mBidderId:String;
      
      private var mBidderName:String;
      
      private var mBidderExtId:String;
      
      private var mAuctionId:String;
      
      private var mBid:FSNumber;
      
      private var mRound:FSNumber;
      
      private var mBidderGuildEmblemBG:String;
      
      private var mBidderGuildEmblemFG:String;
      
      private var mBidderGuildId:String;
      
      private var mBidderGuildName:String;
      
      public function Bid(param1:Object)
      {
         super();
         this.mBidId = Utils.getDataId(param1);
         this.mBidderId = param1.playerId;
         this.mAuctionId = param1.auctionId;
         this.mBid = new FSNumber(param1.bid);
         this.mRound = new FSNumber(param1.round);
         this.mBidderName = param1.name;
         this.mBidderExtId = param1.extId;
         this.mBidderGuildEmblemBG = param1.bidderGuildEmblemBG;
         this.mBidderGuildEmblemFG = param1.bidderGuildEmblemFG;
         this.mBidderGuildId = param1.guildId;
         this.mBidderGuildName = param1.guildName;
      }
      
      public function getBidderExtId() : String
      {
         return this.mBidderExtId;
      }
      
      public function getBidderName() : String
      {
         return this.mBidderName;
      }
      
      public function getBidderId() : String
      {
         return this.mBidderId;
      }
      
      public function getRound() : int
      {
         return this.mRound ? int(this.mRound.value) : 0;
      }
      
      public function getBid() : Number
      {
         return this.mBid ? this.mBid.value : 0;
      }
      
      public function getAuctionId() : String
      {
         return this.mAuctionId;
      }
      
      public function getBidId() : String
      {
         return this.mBidId;
      }
      
      public function getBidderGuildEmblemBG() : String
      {
         return this.mBidderGuildEmblemBG;
      }
      
      public function getBidderGuildEmblemFG() : String
      {
         return this.mBidderGuildEmblemFG;
      }
      
      public function getBidderGuildId() : String
      {
         return this.mBidderGuildId;
      }
      
      public function getBidderGuildName() : String
      {
         return this.mBidderGuildName;
      }
      
      public function destroy() : void
      {
         Utils.destroyObject(this.mBid);
         this.mBid = null;
         Utils.destroyObject(this.mRound);
         this.mRound = null;
      }
   }
}

