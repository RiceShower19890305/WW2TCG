package com.fs.tcgengine.model.auctions
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.controller.AuctionsMng;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.screens.FSAuctionsScreen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.Utils;
   import com.greensock.TweenMax;
   
   public class Auction implements FSModelUnloadableInterface
   {
      
      private var mAuctionId:String;
      
      private var mRound:FSNumber;
      
      private var mNextRound:FSNumber;
      
      private var mCardDef:CardDef;
      
      private var mSellerId:String;
      
      private var mSellerName:String;
      
      private var mSellerExtId:String;
      
      private var mBiddersAmount:FSNumber;
      
      private var mBidsVector:Vector.<Bid>;
      
      private var mNumBids:FSNumber;
      
      private var mRoundStartTime:FSNumber;
      
      private var mRoundEndTime:FSNumber;
      
      private var mNextRoundStartTime:FSNumber;
      
      private var mNextRoundEndTime:FSNumber;
      
      private var mHighestBidder:String;
      
      private var mHighestBid:FSNumber;
      
      private var mPrice:FSNumber;
      
      private var mIBidInThisAuction:Boolean;
      
      private var mIBidInThisAuctionCurrentRound:Boolean;
      
      private var mIndex:int;
      
      private var mTimeLastBid:FSNumber;
      
      private var mIsBidSend:Boolean;
      
      private var mTeamId:String;
      
      public function Auction(param1:Object, param2:int, param3:Boolean = true)
      {
         super();
         this.mAuctionId = Utils.getDataId(param1);
         this.mSellerId = param1.playerId;
         this.mSellerName = param1.name;
         this.mSellerExtId = param1.extId;
         this.mRound = new FSNumber(param1.round);
         this.mRoundStartTime = new FSNumber(param1.roundStartTime);
         this.mRoundEndTime = new FSNumber(param1.roundEndTime);
         this.mNextRound = new FSNumber(param1.nextRound);
         this.mNextRoundStartTime = new FSNumber(param1.nextRoundStartTime);
         this.mNextRoundEndTime = new FSNumber(param1.nextRoundEndTime);
         this.mHighestBidder = param1.roundHighestBidder;
         this.mHighestBid = new FSNumber(param1.highestBid);
         this.mBiddersAmount = new FSNumber(param1.biddersAmount);
         this.mTeamId = param1.teamId;
         this.mIndex = param2;
         this.mPrice = new FSNumber(param1.price);
         this.mIsBidSend = false;
         if(InstanceMng.getCardsDefMng())
         {
            this.mCardDef = CardDef(InstanceMng.getCardsDefMng().getDefBySku(param1.cardSku));
         }
         if(param3)
         {
            this.fillBidVector(param3,true);
         }
      }
      
      public function update(param1:Object, param2:Boolean = true) : void
      {
         this.mSellerName = param1.name;
         this.mSellerExtId = param1.extId;
         this.setRound(param1.round);
         this.setRoundStartTime(param1.roundStartTime);
         this.setRoundEndTime(param1.roundEndTime);
         this.setNextRound(param1.nextRound);
         this.mHighestBidder = param1.roundHighestBidder;
         this.setHighestBid(param1.highestBid);
         this.setNextRoundStartTime(param1.nextRoundStartTime);
         this.setNextRoundEndTime(param1.nextRoundEndTime);
         this.setBiddersAmount(param1.biddersAmount);
         if(InstanceMng.getCardsDefMng())
         {
            this.mCardDef = CardDef(InstanceMng.getCardsDefMng().getDefBySku(param1.cardSku));
         }
         this.fillBidVector(false,param2);
         this.onNewRoundRefreshUI();
      }
      
      public function fillBidVector(param1:Boolean = false, param2:Boolean = true) : void
      {
         if(param2)
         {
            InstanceMng.getServerConnection().getNewBidsByAuctionId(this.mAuctionId,this.getTimeLastBid(),this.onGetAllBidsSuccess,[param1],this.onGetAllBidsFail,[param1]);
         }
         else
         {
            this.onGetAllBidsSuccess(null,false);
         }
      }
      
      private function onGetAllBidsFail(param1:Boolean) : void
      {
         TweenMax.delayedCall(3,this.fillBidVector,[param1]);
      }
      
      private function onGetAllBidsSuccess(param1:Object, param2:Boolean) : void
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Bid = null;
         if(param1)
         {
            _loc3_ = param1 as Array;
            if(AuctionsMng.smRecoveringFromError && (Boolean(!param2) && (Boolean(_loc3_ == null || _loc3_ && _loc3_.length == 0))))
            {
               return;
            }
            if(this.mBidsVector == null)
            {
               this.mBidsVector = new Vector.<Bid>();
            }
            this.mBidsVector.length = 0;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc5_ = new Bid(_loc3_[_loc4_]);
               this.mBidsVector.push(_loc5_);
               if(_loc5_.getBid() > _loc3_[_loc4_].bid)
               {
                  this.setTimeLastBid(_loc3_[0].processedTime);
                  this.setHighestBid(_loc3_[0].bid);
                  this.mHighestBidder = _loc3_[0].playerId;
               }
               _loc4_++;
            }
            this.mIBidInThisAuction = this.getOwnerBestBid() != null;
            this.mIBidInThisAuctionCurrentRound = this.getOwnerBestBid(this.getRound()) != null;
            this.setNumBids(_loc3_.length);
         }
         if(param2)
         {
            this.createNextAuction();
         }
         else
         {
            if(AuctionsMng.smRecoveringFromError)
            {
               this.mTimeLastBid = null;
            }
            if(InstanceMng.getCurrentScreen() is FSAuctionsScreen)
            {
               FSAuctionsScreen(InstanceMng.getCurrentScreen()).createBidPage();
            }
         }
      }
      
      public function processNewBid(param1:Object) : void
      {
         var _loc2_:Bid = null;
         if(param1)
         {
            this.update(param1.auctionInfo,false);
            _loc2_ = new Bid(param1);
            if(this.mBidsVector == null)
            {
               this.mBidsVector = new Vector.<Bid>();
            }
            this.mBidsVector.push(_loc2_);
            this.setTimeLastBid(param1.processedTime);
            this.setHighestBid(param1.bid);
            this.mHighestBidder = param1.playerId;
            this.mIBidInThisAuction = this.getOwnerBestBid() != null;
            this.mIBidInThisAuctionCurrentRound = this.getOwnerBestBid(this.getRound()) != null;
            this.setNumBids(this.mBidsVector.length);
            if(InstanceMng.getCurrentScreen() is FSAuctionsScreen)
            {
               FSAuctionsScreen(InstanceMng.getCurrentScreen()).checkAuctionInfo(false);
            }
         }
      }
      
      private function createNextAuction() : void
      {
         if(InstanceMng.getCurrentScreen() is FSAuctionsScreen)
         {
            FSAuctionsScreen(InstanceMng.getCurrentScreen()).createAuction(this.mIndex + 1);
         }
      }
      
      public function getAuctionTime() : Number
      {
         return this.getRoundEndTime() - ServerConnection.smServerTimeMS;
      }
      
      public function getOwnerBestBid(param1:int = -1) : Bid
      {
         var _loc3_:int = 0;
         var _loc4_:Bid = null;
         var _loc6_:Vector.<Bid> = null;
         var _loc2_:Bid = null;
         var _loc5_:String = InstanceMng.getUserDataMng().getOwnerUserData().getAccountId();
         if(Boolean(this.mBidsVector) && this.mBidsVector.length > 0)
         {
            _loc6_ = this.mBidsVector.sort(DictionaryUtils.sortBidsByPrice);
            _loc3_ = 0;
            while(_loc3_ < this.mBidsVector.length)
            {
               _loc4_ = this.mBidsVector[_loc3_];
               if(_loc4_.getBidderId() == _loc5_)
               {
                  if(param1 == -1)
                  {
                     _loc2_ = _loc4_;
                     break;
                  }
                  if(_loc4_.getRound() == param1)
                  {
                     _loc2_ = _loc4_;
                     break;
                  }
               }
               _loc3_++;
            }
         }
         var _loc7_:Bid = this.getOwnerBestBidInThisSession(param1);
         if(_loc2_ == null && _loc7_ != null)
         {
            _loc2_ = _loc7_;
         }
         return _loc2_;
      }
      
      private function getOwnerBestBidInThisSession(param1:int = -1) : Bid
      {
         var _loc2_:Bid = AuctionsMng.smOwnerBestBids ? AuctionsMng.smOwnerBestBids[this.getAuctionId()] : null;
         if(_loc2_)
         {
            if(param1 != -1)
            {
               if(_loc2_.getRound() == param1)
               {
                  return _loc2_;
               }
               return null;
            }
         }
         return _loc2_;
      }
      
      public function getBidsOfRound(param1:int = -1) : Array
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:Bid = null;
         if(Boolean(this.mBidsVector) && this.mBidsVector.length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < this.mBidsVector.length)
            {
               _loc4_ = this.mBidsVector[_loc3_];
               if(_loc2_ == null)
               {
                  _loc2_ = new Array();
               }
               if(param1 == -1)
               {
                  _loc2_.push(_loc4_);
               }
               else if(_loc4_.getRound() == param1)
               {
                  _loc2_.push(_loc4_);
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      public function isAuctionActive() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:Number = ServerConnection.smServerTimeMS;
         var _loc3_:Number = this.getRoundStartTime();
         var _loc4_:Number = this.getRoundEndTime();
         if(ServerConnection.smServerTimeMS != -1 && this.getRoundStartTime() != -1 && this.getRoundEndTime() != -1)
         {
            _loc1_ = ServerConnection.smServerTimeMS >= this.getRoundStartTime() && ServerConnection.smServerTimeMS <= this.getRoundEndTime();
         }
         else
         {
            FSTracker.trackMiscAction(FSTracker.CATEGORY_AUCTION,FSTracker.ACTION_AUCTION_TIME_INCORRECT,{
               "smServerTimeMS":ServerConnection.smServerTimeMS,
               "RoundStartTime":this.getRoundStartTime(),
               "RoundEndTime":this.getRoundEndTime()
            });
         }
         return _loc1_;
      }
      
      private function onNewRoundRefreshUI() : void
      {
         if(InstanceMng.getCurrentScreen() is FSAuctionsScreen)
         {
            if(FSAuctionsScreen(InstanceMng.getCurrentScreen()).isBidPageSelected() && FSAuctionsScreen(InstanceMng.getCurrentScreen()).getSelectedAuction().getAuctionId() == this.mAuctionId)
            {
               FSAuctionsScreen(InstanceMng.getCurrentScreen()).onNewRoundRefreshUI();
            }
         }
      }
      
      public function isOwnerAuctionWinner() : Boolean
      {
         var _loc1_:Boolean = false;
         if(!this.isAuctionActive() && this.getNextRound() == -1)
         {
            _loc1_ = this.isOwnerHighestBidder();
         }
         return _loc1_;
      }
      
      public function isOwnerAuctionSuccessful() : Boolean
      {
         var _loc1_:Boolean = false;
         if(!this.isAuctionActive() && this.getNextRound() == -1 && this.isOwnerAuctionCreator())
         {
            _loc1_ = this.getBiddersAmount() > 0;
         }
         return _loc1_;
      }
      
      public function getAuctionInfo() : int
      {
         var _loc1_:int = 0;
         var _loc2_:String = InstanceMng.getUserDataMng().getOwnerUserData().getAccountId();
         if(this.isAuctionActive())
         {
            _loc1_ = AuctionsMng.AUCTION_INFO_ACTIVE;
         }
         else if(this.isOwnerAuctionCreator())
         {
            if(this.mHighestBidder != null && this.getHighestBid() != -1)
            {
               _loc1_ = AuctionsMng.AUCTION_INFO_AUCTION_SOLD;
            }
            else
            {
               _loc1_ = AuctionsMng.AUCTION_INFO_CARD_NOT_SOLD;
            }
         }
         else if(this.mHighestBidder == _loc2_)
         {
            _loc1_ = AuctionsMng.AUCTION_INFO_CARD_WON;
         }
         else
         {
            _loc1_ = AuctionsMng.AUCTION_INFO_AUCTION_LOST;
         }
         return _loc1_;
      }
      
      public function isOwnerAuctionCreator() : Boolean
      {
         return this.mSellerId == InstanceMng.getUserDataMng().getOwnerUserData().getAccountId();
      }
      
      public function isOwnerHighestBidder() : Boolean
      {
         return InstanceMng.getUserDataMng().getOwnerUserData().getAccountId() == this.mHighestBidder;
      }
      
      public function removeWaitingBidACK() : void
      {
         this.mIsBidSend = false;
      }
      
      public function isWaitingBidACK() : Boolean
      {
         return this.mIsBidSend;
      }
      
      public function canOwnerBid() : Boolean
      {
         var _loc1_:Bid = this.getOwnerBestBid();
         var _loc2_:int = this.getRound();
         var _loc3_:int = _loc1_ ? _loc1_.getRound() : 0;
         return (AuctionsMng.TEST_BIDS_CREATOR_CAN_BID || !this.isOwnerAuctionCreator()) && (_loc1_ && this.getRound() - _loc1_.getRound() <= 1 || _loc1_ == null && this.getRound() == 1);
      }
      
      private function setNumBids(param1:int) : void
      {
         if(this.mNumBids == null)
         {
            this.mNumBids = new FSNumber();
         }
         this.mNumBids.value = param1;
      }
      
      public function setWaitingBidACK() : void
      {
         this.mIsBidSend = true;
      }
      
      public function setRound(param1:int) : void
      {
         if(this.mRound == null)
         {
            this.mRound = new FSNumber();
         }
         this.mRound.value = param1;
      }
      
      public function setBiddersAmount(param1:int) : void
      {
         if(this.mBiddersAmount == null)
         {
            this.mBiddersAmount = new FSNumber();
         }
         this.mBiddersAmount.value = param1;
      }
      
      public function setRoundStartTime(param1:Number) : void
      {
         if(this.mRoundStartTime == null)
         {
            this.mRoundStartTime = new FSNumber();
         }
         this.mRoundStartTime.value = param1;
      }
      
      public function setRoundEndTime(param1:Number) : void
      {
         if(this.mRoundEndTime == null)
         {
            this.mRoundEndTime = new FSNumber();
         }
         this.mRoundEndTime.value = param1;
      }
      
      public function setNextRoundStartTime(param1:Number) : void
      {
         if(this.mNextRoundStartTime == null)
         {
            this.mNextRoundStartTime = new FSNumber();
         }
         this.mNextRoundStartTime.value = param1;
      }
      
      public function setNextRoundEndTime(param1:Number) : void
      {
         if(this.mNextRoundEndTime == null)
         {
            this.mNextRoundEndTime = new FSNumber();
         }
         this.mNextRoundEndTime.value = param1;
      }
      
      public function setHighestBid(param1:int) : void
      {
         if(this.mHighestBid == null)
         {
            this.mHighestBid = new FSNumber();
         }
         this.mHighestBid.value = param1;
      }
      
      public function setTimeLastBid(param1:Number) : void
      {
         if(this.mTimeLastBid == null)
         {
            this.mTimeLastBid = new FSNumber();
         }
         this.mTimeLastBid.value = param1;
      }
      
      public function setNextRound(param1:int) : void
      {
         if(this.mNextRound == null)
         {
            this.mNextRound = new FSNumber();
         }
         this.mNextRound.value = param1;
      }
      
      public function getRoundStartTime() : Number
      {
         return this.mRoundStartTime ? this.mRoundStartTime.value : 0;
      }
      
      public function getRoundEndTime() : Number
      {
         return this.mRoundEndTime ? this.mRoundEndTime.value : 0;
      }
      
      public function getNextRoundStartTime() : Number
      {
         return this.mNextRoundStartTime ? this.mNextRoundStartTime.value : 0;
      }
      
      public function getNextRoundEndTime() : Number
      {
         return this.mNextRoundEndTime ? this.mNextRoundEndTime.value : 0;
      }
      
      public function getAuctionId() : String
      {
         return this.mAuctionId;
      }
      
      public function getPlayerExtId() : String
      {
         return this.mSellerExtId;
      }
      
      public function getHighestBid() : int
      {
         return this.mHighestBid ? int(this.mHighestBid.value) : 0;
      }
      
      public function getInitialPrice() : int
      {
         return this.mPrice ? int(this.mPrice.value) : 0;
      }
      
      public function getNumBids() : int
      {
         return this.mNumBids ? int(this.mNumBids.value) : 0;
      }
      
      public function getBiddersAmount() : int
      {
         return this.mBiddersAmount ? int(this.mBiddersAmount.value) : 0;
      }
      
      public function getNumBidsInCurrentRound() : int
      {
         return this.getBidsOfRound(this.getRound()).length;
      }
      
      public function getNextRound() : int
      {
         return this.mNextRound ? int(this.mNextRound.value) : 0;
      }
      
      public function getRound() : int
      {
         return this.mRound ? int(this.mRound.value) : 0;
      }
      
      public function getIBidInThisAuctionInCurrentRound() : Boolean
      {
         return this.mIBidInThisAuctionCurrentRound;
      }
      
      public function getIBidInThisAuction() : Boolean
      {
         return this.mIBidInThisAuction;
      }
      
      public function getCardDef() : CardDef
      {
         return this.mCardDef;
      }
      
      private function getTimeLastBid() : Number
      {
         return this.mTimeLastBid ? this.mTimeLastBid.value : 0;
      }
      
      public function getTeamId() : String
      {
         return this.mTeamId;
      }
      
      public function getBidCost() : int
      {
         return this.mCardDef ? InstanceMng.getAuctionsMng().getBidCost(this.mCardDef) : 1;
      }
      
      public function destroy() : void
      {
         this.mRound = null;
         this.mNextRound = null;
         this.mCardDef = null;
         this.mBiddersAmount = null;
         this.mNumBids = null;
         this.mRoundStartTime = null;
         this.mRoundEndTime = null;
         this.mNextRoundStartTime = null;
         this.mNextRoundEndTime = null;
         this.mHighestBid = null;
         this.mPrice = null;
         this.mTimeLastBid = null;
         Utils.destroyArray(this.mBidsVector);
         this.mBidsVector = null;
      }
   }
}

