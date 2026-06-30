package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.rules.RarityDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSDeckBuilderScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.TimerUtil;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.FSCardPreview;
   import com.fs.tcgengine.view.cards.FSCardXL;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.greensock.TweenMax;
   import starling.core.Starling;
   import starling.display.Quad;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Align;
   
   public class AuctionPanel extends Component implements FSModelUnloadableInterface
   {
      
      private var mParentCard:FSCardPreview;
      
      private var mMinAuctionGold:int;
      
      private var mMaxAuctionGold:int;
      
      private var mOffsetAuctionGold:int;
      
      private var mAuctionValueGold:int;
      
      private var mBG:Component;
      
      private var mQuad1:Quad;
      
      private var mQuad2:Quad;
      
      private var mCurrentAHTokensTextfield:FSTextfield;
      
      private var mClockImage:FSImage;
      
      private var mClockTextfield:FSTextfield;
      
      private var mGoldBagImg:FSImage;
      
      private var mAHTokensImg:FSImage;
      
      private var mGoldTextfield:FSTextfield;
      
      private var mIncreaseGoldButton:FSButton;
      
      private var mDecreaseGoldButton:FSButton;
      
      private var mCreateAuctionButton:FSButton;
      
      private var mAuctionCreatedAnimation:FSAuctionCreatedAnimation;
      
      private var mButtonHold:Boolean;
      
      private var mButtonHoldTime:Number;
      
      private var mCreateAuctionCost:int;
      
      private var mXLView:FSCardXL;
      
      public function AuctionPanel(param1:FSCard, param2:FSCardXL)
      {
         super();
         this.mXLView = param2;
         this.mParentCard = InstanceMng.getCardsMng().createCardPreview(param1.getCardDef().getSku());
         this.mParentCard.touchable = false;
         this.fillAuctionInformation();
         this.createUI();
         this.performOpeningFX();
         InstanceMng.getServerConnection().refreshServerTime();
      }
      
      private function fillAuctionInformation() : void
      {
         var _loc1_:RarityDef = null;
         if(this.mParentCard)
         {
            _loc1_ = RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(this.mParentCard.getCardDef().getCardRarity()));
            this.mAuctionValueGold = _loc1_.getAuctionValueGold();
            this.mMinAuctionGold = _loc1_.getAuctionMinGold();
            this.mMaxAuctionGold = _loc1_.getAuctionMaxGold();
            this.mOffsetAuctionGold = _loc1_.getAuctionOffsetGold();
            this.mCreateAuctionCost = _loc1_.getAuctionCreateCost();
         }
      }
      
      private function createClockTextfield() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(Boolean(this.mClockImage) && this.mClockTextfield == null)
         {
            _loc1_ = TimerUtil.minToHours(Config.getConfig().getAuctionTimeFirstRound());
            _loc2_ = this.mClockImage.width * 1.25;
            _loc3_ = this.mClockImage.height;
            this.mClockTextfield = new FSTextfield(_loc2_,_loc3_,_loc1_ + TextManager.getText("TID_GEN_TIME_HOURS_ABR"));
            this.mClockTextfield.format.horizontalAlign = Align.LEFT;
            this.mClockTextfield.x = this.mClockImage.x + this.mClockImage.width;
            this.mClockTextfield.y = this.mClockImage.y;
            this.mBG.addChild(this.mClockTextfield);
         }
      }
      
      private function performOpeningFX() : void
      {
         y = Starling.current.stage.stageHeight + this.mBG.height;
         var _loc1_:FSCoordinate = new FSCoordinate(0,Starling.current.stage.stageHeight - this.mBG.height);
         SpecialFX.createTransition(this,_loc1_,0.5,0);
      }
      
      private function createUI() : void
      {
         this.createBG();
         this.createClockImage();
         this.createClockTextfield();
         this.createGoldBagImage();
         this.createGoldTextfield();
         this.createIncDecGoldButtons();
         this.createCreateAuctionButton();
         this.createCurrentAHTokensTextfield();
      }
      
      private function createCreateAuctionButton() : void
      {
         if(Boolean(this.mBG) && this.mCreateAuctionButton == null)
         {
            this.mCreateAuctionButton = new FSButton(Root.assets.getTexture("auction_button_lit"),TextManager.getText("TID_GEN_CREATE") + " " + this.mCreateAuctionCost.toString(),null,false,null,Root.assets.getTexture("auction_button_unlit"));
            this.mCreateAuctionButton.alignPivot();
            this.mCreateAuctionButton.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
            this.mCreateAuctionButton.x = this.mBG.x + this.mBG.width - this.mCreateAuctionButton.width / 1.7;
            this.mCreateAuctionButton.y = this.mBG.height / 2;
            this.mCreateAuctionButton.addEventListener(Event.TRIGGERED,this.onCreateAuctionTriggered);
            this.mBG.addChild(this.mCreateAuctionButton);
         }
      }
      
      private function onCreateAuctionTriggered(param1:Event) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:UserData = null;
         var _loc5_:int = 0;
         var _loc2_:String = InstanceMng.getServerConnection().getPlatformId();
         if(Config.smServerConfig)
         {
            _loc3_ = Config.smServerConfig["misc_auctionHouseEnabled_" + _loc2_] ? Utils.stringToBoolean(String(Config.smServerConfig["misc_auctionHouseEnabled_" + _loc2_])) : false;
            if(_loc3_)
            {
               if(InstanceMng.getServerConnection().isUserLoggedIn())
               {
                  this.lockAuctionPanel(true);
                  _loc4_ = Utils.getOwnerUserData();
                  if(_loc4_)
                  {
                     _loc5_ = _loc4_.getAuctionTickets();
                     if(_loc5_ >= this.mCreateAuctionCost)
                     {
                        if(Boolean(_loc4_ && this.mParentCard) && Boolean(this.mParentCard.getCardDef()) && Boolean(this.mGoldTextfield))
                        {
                           if(!_loc4_.isInBlackList())
                           {
                              if(!_loc4_.isInDuplicatedList())
                              {
                                 if(Boolean(_loc4_) && _loc4_.isCardInFavouritesCollection(this.mParentCard.getCardDef().getSku()))
                                 {
                                    Utils.setLogText(TextManager.getText("TID_DB_FAVOURITE_DENIED"),true);
                                    this.onCreateAuctionFailed();
                                 }
                                 else
                                 {
                                    InstanceMng.getAuctionsMng().createAuction(this.mParentCard.getCardDef().getSku(),this.mGoldTextfield.text,this.mCreateAuctionCost,this.createAuctionCreatedAnimation,this.onCreateAuctionFailed);
                                 }
                              }
                              else
                              {
                                 Utils.setLogText(TextManager.getText("TID_MIGRATION_ERROR_MIGRATED"),true,false,false);
                                 this.onCreateAuctionFailed();
                              }
                           }
                           else
                           {
                              Utils.setLogText(TextManager.getText("TID_GEN_FRAUD_PURCHASE"),true,false,false);
                              this.onCreateAuctionFailed();
                           }
                        }
                        else
                        {
                           Utils.setLogText(TextManager.getText("TID_GEN_SERVER_RETRY"),true);
                           this.onCreateAuctionFailed();
                        }
                     }
                     else
                     {
                        Utils.setLogText(TextManager.getText("TID_AUCTIONS_NOT_ENOUGH_TICKETS"),true);
                        this.onCreateAuctionFailed();
                     }
                  }
               }
               else
               {
                  Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true);
               }
            }
            else
            {
               Utils.setLogText(TextManager.getText("TID_AUCTIONS_MAINTENANCE"),true);
            }
         }
      }
      
      private function onCreateAuctionFailed() : void
      {
         this.lockAuctionPanel(false);
      }
      
      private function updateAuctionTickets(param1:int) : void
      {
         var _loc2_:Number = NaN;
         if(this.mCurrentAHTokensTextfield)
         {
            InstanceMng.getTextParticlesMng().showTextParticle("- " + param1.toString(),16711680,this.mCurrentAHTokensTextfield);
            _loc2_ = InstanceMng.getUserDataMng().getOwnerUserData().getAuctionTickets();
            this.mCurrentAHTokensTextfield.text = TextManager.getText("TID_GEN_AMOUNT") + " " + _loc2_.toString();
         }
      }
      
      private function createIncDecGoldButtons() : void
      {
         this.createDecreaseGoldButton();
         this.createIncreaseGoldButton();
      }
      
      private function createIncreaseGoldButton() : void
      {
         if(Boolean(this.mGoldTextfield) && this.mIncreaseGoldButton == null)
         {
            this.mIncreaseGoldButton = new FSButton(Root.assets.getTexture("auction_gold_plus_on"),"",null,false,null,Root.assets.getTexture("auction_gold_plus_off"));
            this.mIncreaseGoldButton.x = this.mDecreaseGoldButton.x + this.mDecreaseGoldButton.width;
            this.mIncreaseGoldButton.y = this.mDecreaseGoldButton.y;
            this.mIncreaseGoldButton.addEventListener(TouchEvent.TOUCH,this.onIncreaseButtonTriggered);
            this.mBG.addChild(this.mIncreaseGoldButton);
         }
      }
      
      private function onIncreaseButtonTriggered(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this.mIncreaseGoldButton);
         if(Boolean(_loc2_) && _loc2_.phase == TouchPhase.BEGAN)
         {
            this.mButtonHold = true;
            this.mButtonHoldTime = -1;
            addEventListener(Event.ENTER_FRAME,this.onIncreaseButtonHold);
         }
         if(Boolean(_loc2_) && _loc2_.phase == TouchPhase.ENDED)
         {
            this.mButtonHold = false;
            removeEventListener(Event.ENTER_FRAME,this.onIncreaseButtonHold);
            if(this.mButtonHoldTime != -1)
            {
               this.increaseGold();
               this.mButtonHoldTime = -1;
            }
         }
      }
      
      private function onDecreaseButtonHold() : void
      {
         ++this.mButtonHoldTime;
         if(this.mButtonHold && this.mButtonHoldTime > 5)
         {
            this.decreaseGold();
            this.mButtonHoldTime = -1;
         }
      }
      
      private function onIncreaseButtonHold() : void
      {
         ++this.mButtonHoldTime;
         if(this.mButtonHold && this.mButtonHoldTime > 5)
         {
            this.increaseGold();
            this.mButtonHoldTime = -1;
         }
      }
      
      private function increaseGold() : void
      {
         var _loc1_:int = int(this.mGoldTextfield.text);
         if(this.mIncreaseGoldButton.enabled)
         {
            _loc1_ += this.mOffsetAuctionGold;
            this.mGoldTextfield.text = _loc1_.toString();
            if(_loc1_ >= this.mMaxAuctionGold)
            {
               this.mIncreaseGoldButton.enabled = false;
            }
            else if(_loc1_ > this.mMinAuctionGold && _loc1_ < this.mMaxAuctionGold)
            {
               this.mDecreaseGoldButton.enabled = true;
               this.mIncreaseGoldButton.enabled = true;
            }
         }
      }
      
      private function decreaseGold() : void
      {
         var _loc1_:int = int(this.mGoldTextfield.text);
         if(this.mDecreaseGoldButton.enabled)
         {
            _loc1_ -= this.mOffsetAuctionGold;
            this.mGoldTextfield.text = _loc1_.toString();
            if(_loc1_ == this.mMinAuctionGold)
            {
               this.mDecreaseGoldButton.enabled = false;
            }
            else if(_loc1_ > this.mMinAuctionGold && _loc1_ < this.mMaxAuctionGold)
            {
               this.mDecreaseGoldButton.enabled = true;
               this.mIncreaseGoldButton.enabled = true;
            }
         }
      }
      
      private function createDecreaseGoldButton() : void
      {
         if(Boolean(this.mGoldTextfield) && this.mDecreaseGoldButton == null)
         {
            this.mDecreaseGoldButton = new FSButton(Root.assets.getTexture("auction_gold_minus_on"),"",null,false,null,Root.assets.getTexture("auction_gold_minus_off"));
            this.mDecreaseGoldButton.x = this.mGoldTextfield.x + this.mGoldTextfield.width + this.mDecreaseGoldButton.width / 2;
            this.mDecreaseGoldButton.y = this.mGoldTextfield.y + this.mGoldTextfield.height / 2;
            this.mDecreaseGoldButton.addEventListener(TouchEvent.TOUCH,this.onDecreaseButtonTriggered);
            this.mBG.addChild(this.mDecreaseGoldButton);
         }
      }
      
      private function onDecreaseButtonTriggered(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this.mDecreaseGoldButton);
         if(Boolean(_loc2_) && _loc2_.phase == TouchPhase.BEGAN)
         {
            this.mButtonHold = true;
            this.mButtonHoldTime = -1;
            addEventListener(Event.ENTER_FRAME,this.onDecreaseButtonHold);
         }
         if(Boolean(_loc2_) && _loc2_.phase == TouchPhase.ENDED)
         {
            this.mButtonHold = false;
            removeEventListener(Event.ENTER_FRAME,this.onDecreaseButtonHold);
            if(this.mButtonHoldTime != -1)
            {
               this.decreaseGold();
               this.mButtonHoldTime = -1;
            }
         }
      }
      
      private function createGoldTextfield() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(Boolean(this.mGoldBagImg) && this.mGoldTextfield == null)
         {
            _loc1_ = this.mGoldBagImg.width * 1.5;
            _loc2_ = this.mClockTextfield.height;
            this.mGoldTextfield = new FSTextfield(_loc1_,_loc2_,this.mAuctionValueGold.toString());
            this.mGoldTextfield.format.horizontalAlign = Align.LEFT;
            this.mGoldTextfield.x = this.mGoldBagImg.x + this.mGoldBagImg.width;
            this.mGoldTextfield.y = this.mGoldBagImg.y;
            this.mBG.addChild(this.mGoldTextfield);
         }
      }
      
      private function createGoldBagImage() : void
      {
         if(this.mGoldBagImg == null)
         {
            this.mGoldBagImg = new FSImage(Root.assets.getTexture("rewards_gold_icon"));
            this.mGoldBagImg.x = this.mClockTextfield.x + this.mClockTextfield.width * 1.1;
            this.mGoldBagImg.y = this.mClockImage.y;
            this.mBG.addChild(this.mGoldBagImg);
         }
      }
      
      private function createClockImage() : void
      {
         if(this.mClockImage == null)
         {
            this.mClockImage = new FSImage(Root.assets.getTexture("auction_timer_icon"));
            this.mClockImage.x = 0;
            this.mClockImage.y = this.mBG.height / 2 - this.mClockImage.height / 2;
            this.mBG.addChild(this.mClockImage);
         }
      }
      
      private function createCurrentAHTokensTextfield() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.mAHTokensImg == null)
         {
            this.mAHTokensImg = new FSImage(Root.assets.getTexture("rewards_tokens_icon"));
            this.mAHTokensImg.scale = 0.75;
            this.mAHTokensImg.x = this.mCreateAuctionButton.x - this.mCreateAuctionButton.width / 2 - this.mAHTokensImg.width * 1.1;
            this.mAHTokensImg.y = this.mCreateAuctionButton.y - this.mAHTokensImg.height / 2;
            this.mBG.addChild(this.mAHTokensImg);
         }
         if(this.mCurrentAHTokensTextfield == null)
         {
            _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData().getAuctionTickets();
            _loc2_ = this.mGoldTextfield.width * 1.95;
            _loc3_ = this.mAHTokensImg.height;
            this.mCurrentAHTokensTextfield = new FSTextfield(_loc2_,_loc3_,TextManager.getText("TID_GEN_AMOUNT") + " " + _loc1_);
            this.mCurrentAHTokensTextfield.format.horizontalAlign = Align.RIGHT;
            this.mCurrentAHTokensTextfield.x = this.mAHTokensImg.x - this.mCurrentAHTokensTextfield.width;
            this.mCurrentAHTokensTextfield.y = this.mAHTokensImg.y;
            this.mBG.addChild(this.mCurrentAHTokensTextfield);
         }
      }
      
      private function createBG() : void
      {
         var _loc1_:Number = Starling.current.stage.stageHeight * 0.12;
         this.mBG = new Component();
         this.mBG.width = Starling.current.stage.stageWidth;
         this.mBG.height = _loc1_;
         addChild(this.mBG);
         if(this.mQuad1 == null)
         {
            this.mQuad1 = new Quad(Starling.current.stage.stageWidth,_loc1_ * 0.25,0);
            this.mQuad1.alpha = 1;
            this.mQuad1.setVertexAlpha(0,0);
            this.mQuad1.setVertexAlpha(1,0);
            this.mQuad1.setVertexAlpha(2,0.75);
            this.mQuad1.setVertexAlpha(3,0.75);
            this.mBG.addChild(this.mQuad1);
         }
         if(this.mQuad2 == null)
         {
            this.mQuad2 = new Quad(this.mQuad1.width,_loc1_ * 0.75,0);
            this.mQuad2.x = this.mQuad1.x;
            this.mQuad2.y = this.mQuad1.y + this.mQuad1.height;
            this.mQuad2.alpha = 1;
            this.mQuad2.setVertexAlpha(0,0.75);
            this.mQuad2.setVertexAlpha(1,0.75);
            this.mQuad2.setVertexAlpha(2,0.75);
            this.mQuad2.setVertexAlpha(3,0.75);
            this.mBG.addChild(this.mQuad2);
         }
      }
      
      public function createAuctionCreatedAnimation(param1:Number = 2, param2:Function = null, param3:Array = null) : void
      {
         this.updateAuctionTickets(this.mCreateAuctionCost);
         var _loc4_:Number = 0.6 * Utils.getDefaultSpeedTime();
         if(this.mAuctionCreatedAnimation == null)
         {
            InstanceMng.getCurrentScreen().createTranslucentBG(true);
            this.mAuctionCreatedAnimation = new FSAuctionCreatedAnimation(param2,param3);
         }
         InstanceMng.getCurrentScreen().addChild(this.mAuctionCreatedAnimation);
         this.mAuctionCreatedAnimation.x = Starling.current.stage.stageWidth / 2;
         this.mAuctionCreatedAnimation.y = Starling.current.stage.stageHeight / 2;
         this.mAuctionCreatedAnimation.performFadeIn();
         TweenMax.delayedCall(param1,this.removeAuctionCreatedAnimation);
      }
      
      public function removeAuctionCreatedAnimation(param1:Boolean = false) : void
      {
         var _loc2_:Number = NaN;
         TweenMax.killDelayedCallsTo(this.removeAuctionCreatedAnimation);
         if(this.mAuctionCreatedAnimation.isShown())
         {
            _loc2_ = 0.25 * Utils.getDefaultSpeedTime();
            this.mAuctionCreatedAnimation.performFadeOut(_loc2_);
            TweenMax.delayedCall(_loc2_,this.onAuctionCreatedAnimRemoved);
         }
      }
      
      public function onAuctionCreatedAnimRemoved() : void
      {
         var _loc1_:FSDeckBuilderScreen = InstanceMng.getCurrentScreen() as FSDeckBuilderScreen;
         if(_loc1_)
         {
            _loc1_.fillCollections(true);
            _loc1_.refreshUI();
            _loc1_.removeTranslucentBG(true);
            _loc1_.touchable = true;
            this.mAuctionCreatedAnimation = null;
            this.unload();
         }
      }
      
      public function unload(param1:Boolean = false) : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent(param1);
            this.mBG = null;
         }
         if(this.mCurrentAHTokensTextfield)
         {
            this.mCurrentAHTokensTextfield.removeFromParent(param1);
            this.mCurrentAHTokensTextfield = null;
         }
         if(this.mClockImage)
         {
            this.mClockImage.removeFromParent(param1);
            this.mClockImage = null;
         }
         if(this.mClockTextfield)
         {
            this.mClockTextfield.removeFromParent(param1);
            this.mClockTextfield = null;
         }
         if(this.mGoldBagImg)
         {
            this.mGoldBagImg.removeFromParent(param1);
            this.mGoldBagImg = null;
         }
         if(this.mGoldTextfield)
         {
            this.mGoldTextfield.removeFromParent(param1);
            this.mGoldTextfield = null;
         }
         if(this.mIncreaseGoldButton)
         {
            this.mIncreaseGoldButton.removeFromParent(param1);
            this.mIncreaseGoldButton = null;
         }
         if(this.mDecreaseGoldButton)
         {
            this.mDecreaseGoldButton.removeFromParent(param1);
            this.mDecreaseGoldButton = null;
         }
         if(this.mCreateAuctionButton)
         {
            this.mCreateAuctionButton.removeFromParent(param1);
            this.mCreateAuctionButton = null;
         }
         if(this.mAuctionCreatedAnimation)
         {
            this.mAuctionCreatedAnimation.removeFromParent(param1);
            this.mAuctionCreatedAnimation = null;
         }
      }
      
      public function lockAuctionPanel(param1:Boolean) : void
      {
         var _loc2_:Screen = InstanceMng.getCurrentScreen();
         if(_loc2_)
         {
            _loc2_.touchable = !param1;
         }
         if(this.mBG)
         {
            this.mBG.touchable = !param1;
         }
         if(this.mIncreaseGoldButton)
         {
            this.mIncreaseGoldButton.touchable = !param1;
         }
         if(this.mDecreaseGoldButton)
         {
            this.mDecreaseGoldButton.touchable = !param1;
         }
         if(this.mCreateAuctionButton)
         {
            this.mCreateAuctionButton.touchable = !param1;
         }
      }
      
      override public function dispose() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         if(this.mQuad1)
         {
            this.mQuad1.removeFromParent(true);
            this.mQuad1 = null;
         }
         if(this.mQuad2)
         {
            this.mQuad2.removeFromParent(true);
            this.mQuad2 = null;
         }
         if(this.mCurrentAHTokensTextfield)
         {
            this.mCurrentAHTokensTextfield.removeFromParent(true);
            this.mCurrentAHTokensTextfield = null;
         }
         if(this.mClockImage)
         {
            this.mClockImage.removeFromParent(true);
            this.mClockImage = null;
         }
         if(this.mClockTextfield)
         {
            this.mClockTextfield.removeFromParent(true);
            this.mClockTextfield = null;
         }
         if(this.mGoldBagImg)
         {
            this.mGoldBagImg.removeFromParent(true);
            this.mGoldBagImg = null;
         }
         if(this.mAHTokensImg)
         {
            this.mAHTokensImg.removeFromParent(true);
            this.mAHTokensImg = null;
         }
         if(this.mGoldTextfield)
         {
            this.mGoldTextfield.removeFromParent(true);
            this.mGoldTextfield = null;
         }
         if(this.mIncreaseGoldButton)
         {
            this.mIncreaseGoldButton.removeFromParent(true);
            this.mIncreaseGoldButton = null;
         }
         if(this.mDecreaseGoldButton)
         {
            this.mDecreaseGoldButton.removeFromParent(true);
            this.mDecreaseGoldButton = null;
         }
         if(this.mCreateAuctionButton)
         {
            this.mCreateAuctionButton.removeFromParent(true);
            this.mCreateAuctionButton = null;
         }
         if(this.mAuctionCreatedAnimation)
         {
            this.mAuctionCreatedAnimation.removeFromParent(true);
            this.mAuctionCreatedAnimation = null;
         }
         this.mXLView = null;
         this.mParentCard = null;
         removeEventListener(Event.ENTER_FRAME,this.onIncreaseButtonHold);
         removeEventListener(Event.ENTER_FRAME,this.onDecreaseButtonHold);
         super.dispose();
      }
      
      public function destroy() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent();
            this.mBG = null;
         }
         if(this.mQuad1)
         {
            this.mQuad1.removeFromParent();
            this.mQuad1 = null;
         }
         if(this.mQuad2)
         {
            this.mQuad2.removeFromParent();
            this.mQuad2 = null;
         }
         if(this.mCurrentAHTokensTextfield)
         {
            this.mCurrentAHTokensTextfield.removeFromParent();
            this.mCurrentAHTokensTextfield = null;
         }
         if(this.mClockImage)
         {
            this.mClockImage.removeFromParent();
            this.mClockImage.destroy();
            this.mClockImage = null;
         }
         if(this.mClockTextfield)
         {
            this.mClockTextfield.removeFromParent();
            this.mClockTextfield = null;
         }
         if(this.mGoldBagImg)
         {
            this.mGoldBagImg.removeFromParent();
            this.mGoldBagImg.destroy();
            this.mGoldBagImg = null;
         }
         if(this.mAHTokensImg)
         {
            this.mAHTokensImg.removeFromParent();
            this.mAHTokensImg.destroy();
            this.mAHTokensImg = null;
         }
         if(this.mGoldTextfield)
         {
            this.mGoldTextfield.removeFromParent();
            this.mGoldTextfield = null;
         }
         if(this.mIncreaseGoldButton)
         {
            this.mIncreaseGoldButton.removeFromParent();
            this.mIncreaseGoldButton.destroy();
            this.mIncreaseGoldButton = null;
         }
         if(this.mDecreaseGoldButton)
         {
            this.mDecreaseGoldButton.removeFromParent();
            this.mDecreaseGoldButton.destroy();
            this.mDecreaseGoldButton = null;
         }
         if(this.mCreateAuctionButton)
         {
            this.mCreateAuctionButton.removeFromParent();
            this.mCreateAuctionButton.destroy();
            this.mCreateAuctionButton = null;
         }
         if(this.mAuctionCreatedAnimation)
         {
            this.mAuctionCreatedAnimation.removeFromParent();
            this.mAuctionCreatedAnimation = null;
         }
         this.mXLView = null;
         this.mParentCard = null;
         removeEventListener(Event.ENTER_FRAME,this.onIncreaseButtonHold);
         removeEventListener(Event.ENTER_FRAME,this.onDecreaseButtonHold);
      }
   }
}

