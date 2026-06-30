package com.fs.tcgengine.view.auctions
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.AuctionsMng;
   import com.fs.tcgengine.controller.QuestsMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.auctions.Auction;
   import com.fs.tcgengine.model.auctions.Bid;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.RarityDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.screens.FSAuctionsScreen;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.TimerUtil;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.anims.misc.TimerAnimation;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Align;
   
   public class FSAuctionSlot extends Component
   {
      
      private var mAuction:Auction;
      
      private var mBG:FSImage;
      
      private var mAuctionLayerScategory:FSImage;
      
      private var mCardBGThumb:FSImage;
      
      private var mCardNameTextfield:FSTextfield;
      
      private var mRarityIcon:FSImage;
      
      private var mCardValueTextfield:FSTextfield;
      
      private var mLayerInProgress:FSImage;
      
      private var mAuctionTimeTextfield:FSTextfield;
      
      private var mCurrentTime:Number;
      
      private var mAuctionInfoTextfield:FSTextfield;
      
      private var mIsMyAuctionSlot:Boolean;
      
      private var mClaimButton:FSButton;
      
      private var mGoldImage:FSImage;
      
      private var mIsUpdatingRound:Boolean;
      
      private var mTimerAnimation:TimerAnimation;
      
      private var mTimeTimer:uint;
      
      public function FSAuctionSlot(param1:Auction, param2:Boolean = false)
      {
         super();
         this.mAuction = param1;
         this.mIsMyAuctionSlot = param2;
         if(this.mAuction)
         {
            this.createUI();
         }
         this.update();
      }
      
      private function update() : void
      {
         this.mTimeTimer = setTimeout(this.update,1000);
         if(Boolean(this.mAuction) && Boolean(this.mAuctionTimeTextfield) && this.mAuction.isAuctionActive())
         {
            this.mAuctionTimeTextfield.text = AuctionsMng.getAuctionTime(this.mAuction);
            this.createTimerAnimation();
         }
         else if(Boolean(this.mAuction && this.mAuctionTimeTextfield && !this.mAuction.isAuctionActive()) && Boolean(!this.mIsUpdatingRound) && this.mAuctionTimeTextfield.text != TextManager.getText("TID_AUCTIONS_AUCTION_FINISHED"))
         {
            this.mAuctionTimeTextfield.text = TextManager.getText("TID_AUCTIONS_AUCTION_FINISHED");
            this.removeTimerAnimation();
         }
      }
      
      public function removeTimerAnimation() : void
      {
         if(this.mTimerAnimation)
         {
            this.mTimerAnimation.stopTimerAnimation();
            this.mTimerAnimation.removeFromParent();
            this.mTimerAnimation.destroy();
            this.mTimerAnimation = null;
         }
      }
      
      private function createUI() : void
      {
         this.createBG();
         this.createBGScategory();
         this.createCardNameTextfield();
         this.createRarityIcon();
         if(!this.mIsMyAuctionSlot)
         {
            this.createValueTextfield();
            this.createTimerAnimation();
            this.createAuctionTimetextfield();
            this.createLayerInProgress();
         }
         else
         {
            this.createAuctionInfo();
            this.createClaimButton();
         }
      }
      
      private function createTimerAnimation() : void
      {
         var _loc1_:Number = NaN;
         if(this.mTimerAnimation == null && Boolean(this.mCardValueTextfield))
         {
            _loc1_ = Math.min(TimerUtil.minToMs(Config.getConfig().getMaxAuctionTimerTime()),Config.getConfig().getAuctionTimeByRound(this.mAuction.getRound()));
            this.mTimerAnimation = new TimerAnimation("time_icon_bg_stop","time_icon_bg","anim_time",this.mAuction.getAuctionTime(),_loc1_);
            this.mTimerAnimation.scaleTimer(0.7);
            this.mTimerAnimation.setUpdateTimeFunction(this.mAuction.getAuctionTime);
            this.mTimerAnimation.x = this.mCardValueTextfield.x + this.mCardValueTextfield.width * 0.6;
            this.mTimerAnimation.y = this.mCardValueTextfield.y;
            addChild(this.mTimerAnimation);
         }
      }
      
      private function createClaimButton() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(Boolean(this.mAuctionInfoTextfield) && Boolean(this.mClaimButton == null) && this.mGoldImage == null)
         {
            _loc1_ = "";
            _loc3_ = this.mAuction.getAuctionInfo();
            if(_loc3_ == AuctionsMng.AUCTION_INFO_AUCTION_SOLD)
            {
               _loc4_ = this.mAuction.getHighestBid();
               if(_loc4_ != -1)
               {
                  _loc1_ = _loc4_.toString();
               }
            }
            else if(_loc3_ == AuctionsMng.AUCTION_INFO_AUCTION_LOST)
            {
               _loc4_ = InstanceMng.getUserDataMng().getOwnerUserData().getLastBidPriceInBiddersArr(this.mAuction.getAuctionId());
               if(_loc4_ != -1)
               {
                  _loc1_ = _loc4_.toString();
               }
            }
            else if(_loc3_ != AuctionsMng.AUCTION_INFO_ACTIVE)
            {
               _loc1_ = TextManager.getText("TID_ACHIEVEMENT_CLAIM");
            }
            if(_loc1_ != "")
            {
               this.mClaimButton = new FSButton(Root.assets.getTexture("auction_button_claim"),_loc1_);
               this.mClaimButton.x = this.mAuctionInfoTextfield.x + this.mAuctionInfoTextfield.width;
               this.mClaimButton.y = this.mAuctionInfoTextfield.y;
               this.mClaimButton.addEventListener(Event.TRIGGERED,this.onClaimTouch);
               addChild(this.mClaimButton);
               if(_loc3_ == AuctionsMng.AUCTION_INFO_AUCTION_LOST || _loc3_ == AuctionsMng.AUCTION_INFO_AUCTION_SOLD)
               {
                  this.mGoldImage = new FSImage(Root.assets.getTexture("auction_gold_icon"));
                  this.mGoldImage.x = this.mClaimButton.x - this.mClaimButton.width / 2;
                  this.mGoldImage.y = this.mClaimButton.y - this.mClaimButton.height / 2;
                  addChild(this.mGoldImage);
                  this.mClaimButton.fontSize *= 2;
               }
            }
         }
      }
      
      private function onClaimTouch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Boolean = false;
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            _loc1_ = this.mAuction.getAuctionInfo();
            _loc2_ = false;
            switch(_loc1_)
            {
               case AuctionsMng.AUCTION_INFO_AUCTION_LOST:
                  _loc2_ = this.claimGold();
                  break;
               case AuctionsMng.AUCTION_INFO_AUCTION_SOLD:
                  _loc2_ = this.claimGold();
                  if(_loc2_)
                  {
                     InstanceMng.getQuestsMng().addActionPerformed(QuestsMng.TARGET_TYPE_AUCTION_SUCCESS,1,true,["auctionId:" + this.mAuction.getAuctionId()]);
                  }
                  break;
               case AuctionsMng.AUCTION_INFO_CARD_NOT_SOLD:
                  _loc2_ = this.claimCard();
                  break;
               case AuctionsMng.AUCTION_INFO_CARD_WON:
                  _loc2_ = this.claimCard();
                  if(_loc2_)
                  {
                     InstanceMng.getQuestsMng().addActionPerformed(QuestsMng.TARGET_TYPE_AUCTION_WON,1,true,["auctionId:" + this.mAuction.getAuctionId()]);
                  }
            }
            if(_loc2_)
            {
               if(InstanceMng.getCurrentScreen() is FSAuctionsScreen)
               {
                  FSAuctionsScreen(InstanceMng.getCurrentScreen()).removeAuctionFromVector(this.mAuction);
                  FSAuctionsScreen(InstanceMng.getCurrentScreen()).cleanScrollContainer(FSAuctionsScreen(InstanceMng.getCurrentScreen()).getAuctionScrollContainer(),FSAuctionsScreen(InstanceMng.getCurrentScreen()).createAuctionSlotUI);
               }
               removeFromParent();
            }
            else
            {
               Utils.setLogText(TextManager.getText("TID_GUILD_TRY_AGAIN"));
            }
         }
      }
      
      private function claimCard() : Boolean
      {
         var _loc2_:int = 0;
         var _loc1_:UserData = Utils.getOwnerUserData();
         var _loc3_:Boolean = false;
         if(_loc1_)
         {
            if(this.mAuction.getAuctionInfo() == AuctionsMng.AUCTION_INFO_CARD_NOT_SOLD)
            {
               _loc3_ = _loc1_.removeAuctionIdFromAuctionIdCreatorArr(this.mAuction.getAuctionId());
               if(_loc3_)
               {
                  FSTracker.trackMiscAction(FSTracker.CATEGORY_AUCTION,FSTracker.ACTION_AUCTION_CLAIM_CARD_NOT_SOLD,{
                     "auctionID":this.mAuction.getAuctionId(),
                     "gold":"-1",
                     "cardSku":this.mAuction.getCardDef().getSku()
                  });
               }
            }
            else if(this.mAuction.getAuctionInfo() == AuctionsMng.AUCTION_INFO_CARD_WON)
            {
               _loc3_ = _loc1_.removeAuctionIdFromAuctionIdBiddedArr(this.mAuction.getAuctionId());
               if(_loc3_)
               {
                  InstanceMng.getServerConnection().addUserAuctionCardInstance(this.mAuction.getCardDef().getSku(),this.mAuction.getCardDef().getName(),this.mAuction.getAuctionId(),true);
                  FSTracker.trackMiscAction(FSTracker.CATEGORY_AUCTION,FSTracker.ACTION_AUCTION_CLAIM_CARD_WON,{
                     "auctionId":this.mAuction.getAuctionId(),
                     "gold":"-1",
                     "cardSku":this.mAuction.getCardDef().getSku()
                  });
                  if(Config.HAS_GUILDS)
                  {
                     InstanceMng.getGuildsMng().notifyCardReceivedToGuild(this.mAuction.getCardDef());
                  }
               }
            }
            if(_loc3_)
            {
               _loc1_.addCardToCollection(this.mAuction.getCardDef().getSku() + ":1");
               InstanceMng.getUserDataMng().persistenceSaveData();
               Utils.setLogText(TextManager.getText("TID_CARD_RECEIVED"));
            }
         }
         return _loc3_;
      }
      
      private function claimGold() : Boolean
      {
         var _loc1_:Bid = null;
         var _loc3_:int = 0;
         var _loc2_:UserData = Utils.getOwnerUserData();
         var _loc4_:Boolean = false;
         if(_loc2_)
         {
            if(this.mAuction.getAuctionInfo() == AuctionsMng.AUCTION_INFO_AUCTION_LOST)
            {
               _loc3_ = InstanceMng.getUserDataMng().getOwnerUserData().getLastBidPriceInBiddersArr(this.mAuction.getAuctionId());
               _loc4_ = _loc2_.removeAuctionIdFromAuctionIdBiddedArr(this.mAuction.getAuctionId());
               if(_loc4_)
               {
                  FSTracker.trackMiscAction(FSTracker.CATEGORY_AUCTION,FSTracker.ACTION_AUCTION_INFO_AUCTION_LOST,{
                     "auctionId":this.mAuction.getAuctionId(),
                     "gold":_loc3_,
                     "cardSku":""
                  });
               }
            }
            else if(this.mAuction.getAuctionInfo() == AuctionsMng.AUCTION_INFO_AUCTION_SOLD)
            {
               _loc3_ = this.mAuction.getHighestBid();
               _loc4_ = _loc2_.removeAuctionIdFromAuctionIdCreatorArr(this.mAuction.getAuctionId());
               if(_loc4_)
               {
                  FSTracker.trackMiscAction(FSTracker.CATEGORY_AUCTION,FSTracker.ACTION_AUCTION_INFO_AUCTION_SOLD,{
                     "auctionId":this.mAuction.getAuctionId(),
                     "gold":_loc3_,
                     "cardSku":""
                  });
               }
            }
            if(_loc4_)
            {
               _loc2_.addGold(_loc3_);
               InstanceMng.getUserDataMng().persistenceSaveData();
            }
         }
         return _loc4_;
      }
      
      private function createAuctionInfo() : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         if(Boolean(this.mBG && this.mRarityIcon) && Boolean(this.mCardNameTextfield) && this.mAuctionInfoTextfield == null)
         {
            _loc2_ = this.mAuction.getAuctionInfo();
            switch(_loc2_)
            {
               case AuctionsMng.AUCTION_INFO_ACTIVE:
                  _loc1_ = TextManager.getText("TID_AUCTIONS_AUCTION_IN_PROGRESS");
                  break;
               case AuctionsMng.AUCTION_INFO_AUCTION_LOST:
                  _loc1_ = TextManager.getText("TID_AUCTIONS_AUCTION_LOST");
                  break;
               case AuctionsMng.AUCTION_INFO_AUCTION_SOLD:
                  _loc1_ = TextManager.getText("TID_AUCTIONS_CARD_SOLD");
                  break;
               case AuctionsMng.AUCTION_INFO_CARD_NOT_SOLD:
                  _loc1_ = TextManager.getText("TID_AUCTIONS_AUCTION_EXPIRED");
                  break;
               case AuctionsMng.AUCTION_INFO_CARD_WON:
                  _loc1_ = TextManager.getText("TID_AUCTIONS_AUCTION_WON");
            }
            this.mAuctionInfoTextfield = new FSTextfield(this.mBG.width / 4,this.mBG.height * 0.6,_loc1_);
            this.mAuctionInfoTextfield.alignPivot();
            this.mAuctionInfoTextfield.x = this.mRarityIcon.x + this.mRarityIcon.width * 1.5 + this.mAuctionInfoTextfield.width / 2;
            this.mAuctionInfoTextfield.y = this.mCardNameTextfield.y;
            addChild(this.mAuctionInfoTextfield);
         }
      }
      
      private function createAuctionTimetextfield() : void
      {
         if(Boolean(this.mBG) && Boolean(this.mCardValueTextfield) && this.mAuctionTimeTextfield == null)
         {
            this.mAuctionTimeTextfield = new FSTextfield(this.mBG.width / 7,this.mBG.height * 0.6,AuctionsMng.getAuctionTime(this.mAuction));
            this.mAuctionTimeTextfield.alignPivot();
            this.mAuctionTimeTextfield.format.horizontalAlign = Align.LEFT;
            this.mAuctionTimeTextfield.x = this.mTimerAnimation.x + this.mTimerAnimation.width * 2;
            this.mAuctionTimeTextfield.y = this.mCardValueTextfield.y;
            addChild(this.mAuctionTimeTextfield);
         }
      }
      
      private function createLayerInProgress() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:int = InstanceMng.getUserDataMng().getOwnerUserData().getLastBidRoundInBiddersArr(this.mAuction.getAuctionId());
         if(_loc3_ != -1)
         {
            if(this.mAuction.getRound() == _loc3_)
            {
               _loc1_ = "auction_layer_in_progress";
               this.mBG.setTooltipText(TextManager.getText("TID_AUCTIONS_CLASSIFIED"));
            }
            else if(this.mAuction.getRound() - 1 == _loc3_)
            {
               _loc1_ = "auction_layer_not_classified";
               this.mBG.setTooltipText(TextManager.getText("TID_AUCTIONS_NOT_CLASSIFIED"));
            }
            if(Boolean(this.mBG && _loc1_) && Boolean(_loc1_ != "") && this.mLayerInProgress == null)
            {
               this.mLayerInProgress = new FSImage(Root.assets.getTexture(_loc1_));
               this.mLayerInProgress.x = this.mBG.x + this.mBG.width - this.mLayerInProgress.width;
               addChild(this.mLayerInProgress);
            }
         }
      }
      
      private function createValueTextfield() : void
      {
         var _loc1_:RarityDef = null;
         if(Boolean(this.mBG && this.mRarityIcon) && Boolean(this.mCardNameTextfield) && this.mCardValueTextfield == null)
         {
            _loc1_ = RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(this.mAuction.getCardDef().getCardRarity()));
            if(_loc1_)
            {
               this.mCardValueTextfield = new FSTextfield(this.mBG.width / 4,this.mBG.height * 0.6,this.mAuction.getInitialPrice().toString());
               this.mCardValueTextfield.alignPivot();
               this.mCardValueTextfield.x = this.mRarityIcon.x + this.mRarityIcon.width * 1.5 + this.mCardValueTextfield.width / 2;
               this.mCardValueTextfield.y = this.mCardNameTextfield.y;
               addChild(this.mCardValueTextfield);
            }
         }
      }
      
      private function createRarityIcon() : void
      {
         var _loc1_:RarityDef = null;
         if(Boolean(this.mCardNameTextfield) && this.mRarityIcon == null)
         {
            _loc1_ = RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(this.mAuction.getCardDef().getCardRarity()));
            if(_loc1_)
            {
               this.mRarityIcon = new FSImage(Root.assets.getTexture(_loc1_.getBGPack()));
               this.mRarityIcon.scale = 0.75;
               this.mRarityIcon.touchable = false;
               this.mRarityIcon.alignPivot();
               this.mRarityIcon.x = this.mCardNameTextfield.x + this.mCardNameTextfield.width - this.mRarityIcon.width;
               this.mRarityIcon.y = this.mCardNameTextfield.y;
               addChild(this.mRarityIcon);
            }
         }
      }
      
      private function createCardNameTextfield() : void
      {
         if(Boolean(this.mBG) && Boolean(this.mAuctionLayerScategory) && this.mCardNameTextfield == null)
         {
            this.mCardNameTextfield = new FSTextfield(this.mBG.width / 4,this.mBG.height * 0.6,this.mAuction.getCardDef().getName());
            this.mCardNameTextfield.alignPivot();
            this.mCardNameTextfield.x = this.mAuctionLayerScategory.x + this.mAuctionLayerScategory.width + this.mCardNameTextfield.width / 2;
            this.mCardNameTextfield.y = this.mAuctionLayerScategory.y + this.mCardNameTextfield.height * 0.8;
            addChild(this.mCardNameTextfield);
         }
      }
      
      private function createBGScategory() : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc1_:CardDef = this.mAuction.getCardDef();
         if(_loc1_)
         {
            _loc2_ = _loc1_.getFactionSku();
            if(_loc2_)
            {
               if(Boolean(this.mBG) && this.mAuctionLayerScategory == null)
               {
                  this.mAuctionLayerScategory = new FSImage(Root.assets.getTexture("auction_layer_" + _loc2_));
                  this.mAuctionLayerScategory.touchable = false;
                  addChild(this.mAuctionLayerScategory);
               }
            }
            if(this.mAuctionLayerScategory)
            {
               _loc3_ = _loc1_.getBGImageName() + "_thumb";
               this.mCardBGThumb = new FSImage(Root.assets.getTexture(_loc3_));
               this.mCardBGThumb.touchable = false;
               this.mCardBGThumb.alignPivot();
               this.mCardBGThumb.x = this.mAuctionLayerScategory.x + this.mAuctionLayerScategory.width / 2;
               this.mCardBGThumb.y = this.mAuctionLayerScategory.y + this.mAuctionLayerScategory.height / 2;
               addChild(this.mCardBGThumb);
            }
         }
      }
      
      private function createBG() : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         if(this.mBG == null)
         {
            _loc1_ = "";
            _loc2_ = this.mAuction.getAuctionInfo();
            if(this.mIsMyAuctionSlot)
            {
               if(_loc2_ == AuctionsMng.AUCTION_INFO_AUCTION_LOST || _loc2_ == AuctionsMng.AUCTION_INFO_CARD_NOT_SOLD)
               {
                  _loc1_ = "auction_layer_loss";
               }
               else if(_loc2_ == AuctionsMng.AUCTION_INFO_AUCTION_SOLD || _loc2_ == AuctionsMng.AUCTION_INFO_CARD_WON)
               {
                  _loc1_ = "auction_layer_won";
               }
               else
               {
                  _loc1_ = "auction_layer_placed";
               }
            }
            else if(this.mAuction.isOwnerAuctionCreator())
            {
               _loc1_ = "auction_layer_loss";
               _loc3_ = TextManager.getText("TID_AUCTIONS_OWNER");
            }
            else
            {
               _loc1_ = "auction_layer";
            }
            if(_loc1_ != "")
            {
               this.mBG = new FSImage(Root.assets.getTexture(_loc1_));
               if(Boolean(_loc3_) && _loc3_ != "")
               {
                  this.mBG.setTooltipText(_loc3_);
               }
               if(!this.mIsMyAuctionSlot || this.mIsMyAuctionSlot && this.mAuction.getAuctionInfo() == AuctionsMng.AUCTION_INFO_ACTIVE)
               {
                  this.mBG.addEventListener(TouchEvent.TOUCH,this.onAuctionSlotTouch);
               }
               addChild(this.mBG);
            }
         }
      }
      
      private function onAuctionSlotTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this,TouchPhase.ENDED);
         if(_loc2_)
         {
            if(InstanceMng.getCurrentScreen() is FSAuctionsScreen)
            {
               if(this.mAuction.isAuctionActive())
               {
                  if(Boolean(FSAuctionsScreen(InstanceMng.getCurrentScreen()).getAuctionScrollContainer()) && !FSAuctionsScreen(InstanceMng.getCurrentScreen()).getAuctionScrollContainer().isScrolling)
                  {
                     FSAuctionsScreen(InstanceMng.getCurrentScreen()).lockUI(true);
                     FSAuctionsScreen(InstanceMng.getCurrentScreen()).setSelectedAuction(this.mAuction);
                     FSAuctionsScreen(InstanceMng.getCurrentScreen()).setLastHighestBidSelectedAuction(this.mAuction.getHighestBid());
                     FSAuctionsScreen(InstanceMng.getCurrentScreen()).goToBidPage();
                     FSAuctionsScreen(InstanceMng.getCurrentScreen()).updateAuctionListButton();
                     if(!this.mAuction.isOwnerAuctionCreator())
                     {
                        InstanceMng.getServerConnection().joinAHTeam(this.mAuction.getTeamId());
                     }
                  }
               }
            }
         }
         _loc2_ = param1.getTouch(this.mBG,TouchPhase.HOVER);
         if(_loc2_)
         {
            if(this.mBG)
            {
               this.mBG.showTooltip();
            }
         }
         else if(this.mBG)
         {
            this.mBG.closeTooltip();
         }
      }
      
      public function refreshState() : void
      {
         this.updateLayerInProgress();
         this.updateBG();
      }
      
      private function updateBG() : void
      {
         var _loc1_:Bid = null;
         if(this.mBG)
         {
            _loc1_ = this.mAuction.getOwnerBestBid();
            if(this.mAuction.isOwnerAuctionCreator())
            {
               if(this.mBG.texture != Root.assets.getTexture("auction_layer_loss"))
               {
                  this.mBG.texture = Root.assets.getTexture("auction_layer_loss");
               }
            }
         }
      }
      
      private function updateLayerInProgress() : void
      {
         var _loc1_:int = InstanceMng.getUserDataMng().getOwnerUserData().getLastBidRoundInBiddersArr(this.mAuction.getAuctionId());
         if(_loc1_ != -1 && Boolean(this.mLayerInProgress))
         {
            if(this.mAuction.getRound() == _loc1_)
            {
               if(this.mLayerInProgress.texture != Root.assets.getTexture("auction_layer_in_progress"))
               {
                  this.mLayerInProgress.texture = Root.assets.getTexture("auction_layer_in_progress");
                  this.mBG.setTooltipText(TextManager.getText("TID_AUCTIONS_CLASSIFIED"));
               }
            }
            else if(this.mAuction.getRound() - 1 == _loc1_)
            {
               if(this.mLayerInProgress.texture != Root.assets.getTexture("auction_layer_not_classified"))
               {
                  this.mLayerInProgress.texture = Root.assets.getTexture("auction_layer_not_classified");
                  this.mBG.setTooltipText(TextManager.getText("TID_AUCTIONS_NOT_CLASSIFIED"));
               }
            }
            else
            {
               this.mLayerInProgress.removeFromParent();
               this.mLayerInProgress.destroy();
               this.mLayerInProgress = null;
            }
         }
         else
         {
            this.createLayerInProgress();
         }
      }
      
      private function onGetAuctionSuccess(param1:Object) : void
      {
         if(param1)
         {
            this.mAuction.update(param1);
         }
      }
      
      private function removeComponentFromParent(param1:Component) : void
      {
         if(param1)
         {
            param1.removeFromParent();
         }
      }
      
      override public function dispose() : void
      {
         Utils.destroyObject(this.mAuction);
         this.mAuction = null;
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         if(this.mAuctionLayerScategory)
         {
            this.mAuctionLayerScategory.removeFromParent(true);
            this.mAuctionLayerScategory = null;
         }
         if(this.mCardBGThumb)
         {
            this.mCardBGThumb.removeFromParent(true);
            this.mCardBGThumb = null;
         }
         if(this.mCardNameTextfield)
         {
            this.mCardNameTextfield.removeFromParent(true);
            this.mCardNameTextfield = null;
         }
         if(this.mRarityIcon)
         {
            this.mRarityIcon.removeFromParent(true);
            this.mRarityIcon = null;
         }
         if(this.mCardValueTextfield)
         {
            this.mCardValueTextfield.removeFromParent(true);
            this.mCardValueTextfield = null;
         }
         if(this.mLayerInProgress)
         {
            this.mLayerInProgress.removeFromParent(true);
            this.mLayerInProgress = null;
         }
         if(this.mAuctionTimeTextfield)
         {
            this.mAuctionTimeTextfield.removeFromParent(true);
            this.mAuctionTimeTextfield = null;
         }
         if(this.mAuctionInfoTextfield)
         {
            this.mAuctionInfoTextfield.removeFromParent(true);
            this.mAuctionInfoTextfield = null;
         }
         if(this.mClaimButton)
         {
            this.mClaimButton.removeFromParent(true);
            this.mClaimButton = null;
         }
         if(this.mGoldImage)
         {
            this.mGoldImage.removeFromParent(true);
            this.mGoldImage = null;
         }
         if(this.mTimerAnimation)
         {
            this.mTimerAnimation.removeFromParent();
            this.mTimerAnimation.destroy();
            this.mTimerAnimation = null;
         }
         clearTimeout(this.mTimeTimer);
         super.dispose();
      }
      
      public function getAuction() : Auction
      {
         return this.mAuction;
      }
   }
}

