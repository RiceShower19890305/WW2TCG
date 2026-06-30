package com.fs.tcgengine.controller
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.model.auctions.Auction;
   import com.fs.tcgengine.model.auctions.Bid;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.RarityDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.screens.FSAuctionsScreen;
   import com.fs.tcgengine.utils.TimerUtil;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.auctions.FSAuctionSlot;
   import com.fs.tcgengine.view.auctions.FSBidSlot;
   import feathers.controls.ScrollContainer;
   import flash.utils.Dictionary;
   
   public class AuctionsMng
   {
      
      public static var smOwnerBestBids:Dictionary;
      
      public static const AUCTION_INFO_ACTIVE:int = 0;
      
      public static const AUCTION_INFO_AUCTION_LOST:int = 1;
      
      public static const AUCTION_INFO_AUCTION_SOLD:int = 2;
      
      public static const AUCTION_INFO_CARD_WON:int = 3;
      
      public static const AUCTION_INFO_CARD_NOT_SOLD:int = 4;
      
      public static const AUCTION_FILTER_ALL:int = -1;
      
      public static const AUCTION_FILTER_GOLD:int = 0;
      
      public static const AUCTION_FILTER_LOSS:int = 1;
      
      public static const AUCTION_FILTER_PLACED:int = 2;
      
      public static const AUCTION_FILTER_WON:int = 3;
      
      public static const TEST_BIDS_CREATOR_CAN_BID:Boolean = Config.smIsDebug && false;
      
      public static var smRecoveringFromError:Boolean = false;
      
      public function AuctionsMng()
      {
         super();
      }
      
      public static function getAuctionTime(param1:Auction) : String
      {
         var _loc2_:String = "";
         var _loc3_:Number = param1.getAuctionTime();
         if(_loc3_ != -1)
         {
            _loc2_ = TimerUtil.getTimeTextFromMs(_loc3_,null,":",":","");
         }
         return _loc2_;
      }
      
      public function createAuction(param1:String, param2:String, param3:int, param4:Function, param5:Function) : void
      {
         var ownerUserData:UserData = null;
         var onTokensPayedFailed:Function = null;
         var onTokensPayed:Function = null;
         var onCreateAuctionSuccess:Function = null;
         var onCreateAuctionFail:Function = null;
         var cardSku:String = param1;
         var price:String = param2;
         var tickets:int = param3;
         var onSuccessFunction:Function = param4;
         var onFailFunction:Function = param5;
         onTokensPayedFailed = function():void
         {
            Utils.setLogText(TextManager.getText("TID_GEN_SERVER_RETRY"),true);
            if(onFailFunction != null)
            {
               onFailFunction();
            }
         };
         onTokensPayed = function():void
         {
            InstanceMng.getServerConnection().createAuction(cardSku,int(price),TimerUtil.minToMs(Config.getConfig().getAuctionTimeFirstRound()),onCreateAuctionSuccess,onCreateAuctionFail);
         };
         onCreateAuctionSuccess = function(param1:Object):void
         {
            Utils.playSound("auctionCreated_fx",SoundManager.TYPE_SFX);
            if(onSuccessFunction != null)
            {
               onSuccessFunction();
            }
            InstanceMng.getUserDataMng().getOwnerUserData().addAuctionIdToAuctionIdCreatorArr(Utils.getDataId(param1));
            ownerUserData.removeCardFromCollection(cardSku,1);
            var _loc2_:String = CardDef(InstanceMng.getCardsDefMng().getDefBySku(cardSku)).getName();
            InstanceMng.getServerConnection().addUserAuctionCardInstance(cardSku,_loc2_,"",false);
            InstanceMng.getUserDataMng().persistenceSaveData();
            InstanceMng.getQuestsMng().addActionPerformed(QuestsMng.TARGET_TYPE_AUCTION_CREATED,1,true,["auctionId:" + Utils.getDataId(param1),"cardSku:" + param1.cardSku]);
         };
         onCreateAuctionFail = function():void
         {
            Utils.setLogText(TextManager.getText("TID_GUILD_TRY_AGAIN"));
            ownerUserData.addAuctionTickets(tickets);
         };
         ownerUserData = Utils.getOwnerUserData();
         if(Boolean(ownerUserData && cardSku && cardSku != "") && Boolean(price) && Number(price) > 0)
         {
            ownerUserData.substractAuctionTickets(-tickets,onTokensPayed,null,onTokensPayedFailed);
         }
         else
         {
            onTokensPayedFailed();
         }
      }
      
      public function makeBid(param1:Auction) : void
      {
         var ownerUserData:UserData = null;
         var price:int = 0;
         var goldToUpdate:int = 0;
         var bidAllowed:Boolean = false;
         var isFirstBidInAuction:Boolean = false;
         var isFirstBidInCurrentRound:Boolean = false;
         var auction:Auction = param1;
         var performBidOnServer:Function = function():void
         {
            var _loc2_:String = null;
            var _loc1_:int = isFirstBidInAuction ? price : goldToUpdate;
            if(ownerUserData.getGold() >= _loc1_)
            {
               if(InstanceMng.getCurrentScreen() is FSAuctionsScreen)
               {
                  if(bidAllowed)
                  {
                     FSAuctionsScreen(InstanceMng.getCurrentScreen()).setLastHighestBidSelectedAuction(price);
                     FSAuctionsScreen(InstanceMng.getCurrentScreen()).getSelectedAuction().setWaitingBidACK();
                     InstanceMng.getServerConnection().createBid(auction,price,auction.getRound(),isFirstBidInCurrentRound,auction.getBiddersAmount(),onCreateBidSuccess,[auction,_loc1_],onCreateBidFail,[auction]);
                  }
                  else
                  {
                     onMakeBidFinishedCheckBidButton();
                     _loc2_ = TextManager.getText("TID_GUILD_TRY_AGAIN");
                     Utils.setLogText(_loc2_);
                     if(InstanceMng.getCurrentScreen() is FSAuctionsScreen)
                     {
                        smRecoveringFromError = true;
                        FSAuctionsScreen(InstanceMng.getCurrentScreen()).getAuctionServerInfo();
                     }
                  }
               }
            }
            else
            {
               Utils.setLogText(TextManager.getText("TID_GOLD_NOT_ENOUGH"));
               onMakeBidFinishedCheckBidButton();
            }
         };
         var onMakeBidFinishedCheckBidButton:Function = function():void
         {
            if(InstanceMng.getCurrentScreen() is FSAuctionsScreen && FSAuctionsScreen(InstanceMng.getCurrentScreen()).getSelectedAuction().canOwnerBid())
            {
               FSAuctionsScreen(InstanceMng.getCurrentScreen()).enableBidButton(true);
               InstanceMng.getCurrentScreen().showLoadingIcon(false,true);
            }
         };
         var myBestBidCurrentRound:Bid = auction.getOwnerBestBid(auction.getRound());
         var myBestBid:Bid = auction.getOwnerBestBid();
         ownerUserData = Utils.getOwnerUserData();
         var rarityDef:RarityDef = RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(auction.getCardDef().getCardRarity()));
         var minGoldToPayByDef:int = rarityDef.getAuctionMinGold();
         bidAllowed = true;
         isFirstBidInAuction = false;
         isFirstBidInCurrentRound = true;
         if(ownerUserData)
         {
            if(myBestBidCurrentRound == null && auction.getBiddersAmount() == 0 && InstanceMng.getCurrentScreen() is FSAuctionsScreen && FSAuctionsScreen(InstanceMng.getCurrentScreen()).getLastHighestBidSelectedAuction() == -1)
            {
               isFirstBidInAuction = true;
               isFirstBidInCurrentRound = true;
               price = auction.getInitialPrice();
               if(price < minGoldToPayByDef || price <= FSAuctionsScreen(InstanceMng.getCurrentScreen()).getLastHighestBidSelectedAuction())
               {
                  bidAllowed = false;
               }
               performBidOnServer();
            }
            else if(myBestBidCurrentRound == null && auction.getBiddersAmount() >= 0)
            {
               isFirstBidInCurrentRound = true;
               if(myBestBid)
               {
                  goldToUpdate = auction.getHighestBid() - myBestBid.getBid() <= 0 ? rarityDef.getAuctionOffsetGold() : int(auction.getHighestBid() - myBestBid.getBid() + rarityDef.getAuctionOffsetGold());
               }
               else
               {
                  goldToUpdate = auction.getHighestBid() + rarityDef.getAuctionOffsetGold();
               }
               price = auction.getHighestBid() + rarityDef.getAuctionOffsetGold();
               if(price < minGoldToPayByDef)
               {
                  Utils.setLogText(TextManager.getText("TID_GEN_SERVER_RETRY"));
                  onMakeBidFinishedCheckBidButton();
                  return;
               }
               performBidOnServer();
            }
            else if(InstanceMng.getCurrentScreen() is FSAuctionsScreen && FSAuctionsScreen(InstanceMng.getCurrentScreen()).getLastHighestBidSelectedAuction() > 0 && Boolean(myBestBid))
            {
               isFirstBidInCurrentRound = false;
               goldToUpdate = auction.isOwnerHighestBidder() ? rarityDef.getAuctionOffsetGold() : int(auction.getHighestBid() - myBestBidCurrentRound.getBid() + rarityDef.getAuctionOffsetGold());
               price = auction.getHighestBid() + rarityDef.getAuctionOffsetGold();
               if(price <= FSAuctionsScreen(InstanceMng.getCurrentScreen()).getLastHighestBidSelectedAuction())
               {
                  bidAllowed = false;
               }
               performBidOnServer();
            }
            else
            {
               onMakeBidFinishedCheckBidButton();
            }
         }
      }
      
      private function onCreateBidFail(param1:Auction) : void
      {
         var _loc3_:Bid = null;
         var _loc2_:String = TextManager.getText("TID_GUILD_TRY_AGAIN");
         Utils.setLogText(_loc2_);
         InstanceMng.getCurrentScreen().enableBackButton(true);
         if(param1)
         {
            _loc3_ = param1.getOwnerBestBid(param1.getRound());
            if(InstanceMng.getCurrentScreen() is FSAuctionsScreen)
            {
               if(FSAuctionsScreen(InstanceMng.getCurrentScreen()).getSelectedAuction())
               {
                  FSAuctionsScreen(InstanceMng.getCurrentScreen()).getSelectedAuction().removeWaitingBidACK();
               }
               if(!(_loc3_ == null && param1.getNumBids() == 0))
               {
                  FSAuctionsScreen(InstanceMng.getCurrentScreen()).setLastHighestBidSelectedAuction(param1.getHighestBid());
               }
               if(Boolean(FSAuctionsScreen(InstanceMng.getCurrentScreen()).getSelectedAuction()) && FSAuctionsScreen(InstanceMng.getCurrentScreen()).getSelectedAuction().canOwnerBid())
               {
                  FSAuctionsScreen(InstanceMng.getCurrentScreen()).enableBidButton(true);
               }
               InstanceMng.getCurrentScreen().showLoadingIcon(false,true);
               smRecoveringFromError = true;
               FSAuctionsScreen(InstanceMng.getCurrentScreen()).getAuctionServerInfo();
            }
         }
      }
      
      private function onCreateBidSuccess(param1:Object, param2:Auction, param3:int) : void
      {
         var _loc4_:FSAuctionsScreen = null;
         var _loc5_:FSBidSlot = null;
         var _loc6_:Bid = null;
         var _loc7_:String = null;
         var _loc8_:UserData = null;
         InstanceMng.getCurrentScreen().showLoadingIcon(false,true);
         InstanceMng.getCurrentScreen().enableBackButton(true);
         if(InstanceMng.getCurrentScreen() is FSAuctionsScreen)
         {
            _loc4_ = FSAuctionsScreen(InstanceMng.getCurrentScreen());
            _loc6_ = new Bid(param1);
            this.addBestBid(_loc6_,param2.getAuctionId());
            _loc4_.substractTokens(param2);
            FSAuctionsScreen(InstanceMng.getCurrentScreen()).updateNextBidCost(_loc6_.getBid());
            _loc7_ = String(param1.auctionId) + ":" + _loc6_.getRound().toString() + ":" + _loc6_.getBid().toString();
            _loc8_ = Utils.getOwnerUserData();
            if(_loc8_)
            {
               _loc8_.substractGold(-param3);
               _loc8_.addAuctionIdToAuctionIdBiddedArr(_loc7_);
            }
            InstanceMng.getUserDataMng().persistenceSaveData();
            InstanceMng.getQuestsMng().addActionPerformed(QuestsMng.TARGET_TYPE_AUCTION_BID,1,true,["auctionId:" + param2.getAuctionId(),"bidId:" + _loc6_.getBidId()]);
            if(_loc4_.getSelectedAuction())
            {
               _loc4_.getSelectedAuction().removeWaitingBidACK();
               if(_loc4_.getSelectedAuction().canOwnerBid())
               {
                  _loc4_.enableBidButton(true);
               }
            }
         }
      }
      
      public function cleanAuctionsArrayByExistentInPlatform(param1:Array) : Array
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:CardDef = null;
         if(Boolean(param1) && param1.length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               _loc4_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(param1[_loc3_].cardSku));
               if(_loc4_)
               {
                  if(_loc2_ == null)
                  {
                     _loc2_ = new Array();
                  }
                  _loc2_.push(param1[_loc3_]);
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      public function onAuctionInfoEventReceived(param1:Object) : void
      {
         var _loc2_:ScrollContainer = null;
         var _loc3_:int = 0;
         var _loc4_:Auction = null;
         FSDebug.debugTrace("Updating auction: " + Utils.getDataId(param1));
         if(InstanceMng.getCurrentScreen() is FSAuctionsScreen)
         {
            _loc2_ = FSAuctionsScreen(InstanceMng.getCurrentScreen()).getAuctionScrollContainer();
            if(_loc2_)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc2_.numChildren)
               {
                  if(_loc2_.getChildAt(_loc3_) is FSAuctionSlot)
                  {
                     _loc4_ = FSAuctionSlot(_loc2_.getChildAt(_loc3_)).getAuction();
                     if((Boolean(_loc4_)) && _loc4_.getAuctionId() == Utils.getDataId(param1))
                     {
                        _loc4_.update(param1,false);
                        FSAuctionSlot(_loc2_.getChildAt(_loc3_)).refreshState();
                     }
                  }
                  _loc3_++;
               }
            }
            if(Boolean(FSAuctionsScreen(InstanceMng.getCurrentScreen()).getSelectedAuction()) && FSAuctionsScreen(InstanceMng.getCurrentScreen()).getSelectedAuction().getAuctionId() == Utils.getDataId(param1))
            {
               FSAuctionsScreen(InstanceMng.getCurrentScreen()).getSelectedAuction().update(param1,false);
            }
         }
      }
      
      public function getBidCost(param1:CardDef) : int
      {
         var _loc2_:int = 1;
         var _loc3_:RarityDef = RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(param1.getCardRarity()));
         if(_loc3_)
         {
            _loc2_ = _loc3_.getAuctionBidCost();
         }
         return _loc2_;
      }
      
      private function addBestBid(param1:Bid, param2:String) : void
      {
         if(param1 != null && param2 != null && param2 != "")
         {
            if(smOwnerBestBids == null)
            {
               smOwnerBestBids = new Dictionary(true);
            }
            if(smOwnerBestBids[param2] == null)
            {
               smOwnerBestBids[param2] = param1;
            }
            else if(Bid(smOwnerBestBids[param2]).getBid() < param1.getBid())
            {
               smOwnerBestBids[param2] = param1;
            }
         }
      }
   }
}

