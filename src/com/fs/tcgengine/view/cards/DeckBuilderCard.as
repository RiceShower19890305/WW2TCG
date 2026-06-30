package com.fs.tcgengine.view.cards
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.board.card.Ability;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSDeckBuilderScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.DeckCardsPanel;
   import com.fs.tcgengine.view.misc.FSCardSlotInfo;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   import com.greensock.easing.Expo;
   import com.greensock.easing.Sine;
   import flash.geom.Point;
   import flash.system.Capabilities;
   import flash.ui.Mouse;
   import flash.utils.setTimeout;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   
   public class DeckBuilderCard extends InfoCard
   {
      
      private const AMOUNT_SOCKET_LIMITED_BG_NAME:String = "amount_socket_limited";
      
      private var mMaxAmountSocket:FSImage;
      
      private var mScrollableCard:FSCard;
      
      private var mOrigPos:FSCoordinate;
      
      private var mIsHovered:Boolean = false;
      
      private var mRelativePoint:Point;
      
      private var mSelectedPowerTextfield:FSTextfield;
      
      private var mTouches:Vector.<Touch>;
      
      private var mCurrentPosPoint:Point;
      
      private var mGlobalPosPoint:Point;
      
      private var mStartTouchPosX:Number;
      
      private var mStartTouchPosY:Number;
      
      private var mIsPressed:Boolean;
      
      private var mOriginalDropShadowScale:Number = -1;
      
      private var mOriginalAlphaValue:Number = -1;
      
      public function DeckBuilderCard(param1:FSCard, param2:int, param3:Boolean = true, param4:Boolean = false)
      {
         super(param1,param2,param3);
         this.setTooltipsForAbilities();
         if(param4)
         {
            if(param1.getType() != FSCard.TYPE_POWER)
            {
               this.createMaxAmountSocket();
            }
         }
         checkIfNewCard();
         checkIfCraftAvailable();
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         var _loc5_:Number = Utils.isIOS() && !Utils.isIphone() ? 1.16 : 1;
         scale = _loc5_;
      }
      
      private function setTooltipsForAbilities() : void
      {
         var _loc2_:Ability = null;
         var _loc3_:FSImage = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc1_:Vector.<Ability> = mCard.getAbilities();
         for each(_loc2_ in _loc1_)
         {
            _loc3_ = mCard.getAbilityIconImage(_loc2_.getAbilityDef());
            if(_loc3_)
            {
               _loc4_ = Config.smDebugTooltips ? "[" + _loc2_.getAbilityDef().getSku() + "] " : "";
               _loc5_ = _loc2_.getAbilityDef().getName();
               _loc6_ = _loc2_.getAbilityDef().isParentAbility() ? _loc4_ + _loc2_.getAbilityDef().getCompositeName() : _loc4_ + _loc2_.getAbilityDef().getDesc();
               _loc6_ = _loc5_ + "\n" + _loc6_;
               _loc3_.setTooltipText(_loc6_);
               _loc3_.touchable = true;
               _loc3_.addEventListener(TouchEvent.TOUCH,this.onAbilityIconImageTouch);
               mCard.getBattleSubcomponentsContainer().addChild(_loc3_);
            }
         }
      }
      
      override protected function onTouch(param1:TouchEvent) : void
      {
         var _loc3_:FSDeckBuilderScreen = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Boolean = false;
         var _loc15_:Boolean = false;
         var _loc16_:int = 0;
         var _loc17_:String = null;
         var _loc18_:Screen = null;
         var _loc19_:Point = null;
         var _loc20_:Boolean = false;
         var _loc2_:Boolean = this.isMovable();
         var _loc4_:Touch = param1.getTouch(this,TouchPhase.BEGAN);
         if(_loc4_)
         {
            if(this.isMovable())
            {
               if(!mIsMoving)
               {
                  this.mStartTouchPosX = _loc4_.globalX;
                  this.mStartTouchPosY = _loc4_.globalY;
               }
               Utils.playSound(Constants.SOUND_CARD_TO_ACTION_DECK,SoundManager.TYPE_SFX);
            }
            this.mIsPressed = true;
            this.handleOnUnpressed();
         }
         if(_loc2_)
         {
            this.getCardsPanel();
            this.mTouches = param1.getTouches(this,TouchPhase.MOVED);
            if(Boolean(this.mTouches) && this.mTouches.length >= 1)
            {
               _loc8_ = this.mStartTouchPosX - this.mTouches[0].globalX;
               _loc9_ = this.mStartTouchPosY - this.mTouches[0].globalY;
               _loc10_ = 0.04;
               _loc11_ = Capabilities.screenDPI / Starling.current.contentScaleFactor;
               _loc12_ = Math.abs(_loc8_) / _loc11_;
               _loc13_ = Math.abs(_loc9_) / _loc11_;
               _loc14_ = Utils.isBrowser() || _loc12_ > _loc10_;
               _loc15_ = Utils.isBrowser() || _loc13_ > _loc10_;
               if(!mIsMoving && (_loc14_ || _loc15_) || mIsMoving)
               {
                  this.createScrollableCard();
                  mIsMoving = true;
                  if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
                  {
                     _loc3_ = FSDeckBuilderScreen(InstanceMng.getCurrentScreen());
                     _loc3_.setCollectionContainerScrollable(false);
                     if(!_loc3_.isLocked())
                     {
                        _loc3_.lockUI(true);
                        this.checkIfNewCardGlowNeedsToBeRemoved();
                     }
                  }
               }
            }
         }
         else if(!_loc2_ && this.mMaxAmountSocket != null)
         {
            this.mTouches = param1.getTouches(this,TouchPhase.MOVED);
            if(this.mTouches.length == 1)
            {
               if(mAmount != 0)
               {
                  _loc16_ = mCard.getCardDef().getMaxAmountOndeck();
                  _loc17_ = TextManager.replaceParameters(TextManager.getText("TID_DECKBUILDER_CARD_AMOUNT"),[_loc16_]);
                  if(InstanceMng.getLogPanel().getCurrentText() != _loc17_)
                  {
                     Utils.setLogText(_loc17_);
                  }
               }
               this.performLockedAnimation();
            }
         }
         _loc4_ = param1.getTouch(this,TouchPhase.ENDED);
         if(_loc4_)
         {
            this.mIsPressed = false;
            FSDebug.debugTrace("touches length " + _loc4_.tapCount);
            if(_loc4_.tapCount > 0)
            {
               _loc18_ = InstanceMng.getCurrentScreen();
               if(_loc18_ is FSDeckBuilderScreen)
               {
                  _loc3_ = FSDeckBuilderScreen(InstanceMng.getCurrentScreen());
                  if(_loc3_.isLocked())
                  {
                     _loc3_.lockUI(false);
                  }
                  if(_loc2_ && mIsMoving)
                  {
                     mIsMoving = false;
                     this.checkIntersection();
                  }
                  else if(!Root.assets.isLoading && !mIsMoving)
                  {
                     _loc4_ = param1.getTouch(stage);
                     _loc19_ = localToGlobal(new Point(mCard.x,mCard.y));
                     _loc20_ = Boolean(_loc4_) && (_loc4_.globalX >= _loc19_.x - mCard.width / 2 && _loc4_.globalX <= _loc19_.x + mCard.width / 2) && (_loc4_.globalY >= _loc19_.y - mCard.height / 2 && _loc4_.globalY <= _loc19_.y + mCard.height / 2);
                     if(_loc20_)
                     {
                        _loc3_.setSelectedCard(mCard);
                        SpecialFX.zoomIn(mCard);
                        this.checkIfNewCardGlowNeedsToBeRemoved();
                     }
                  }
               }
            }
         }
         var _loc5_:Boolean = FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).getEdidionStatus() == FSDeckBuilderScreen.STATUS_EDITING;
         var _loc6_:Boolean = FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).isViewAllCardsModeON();
         var _loc7_:Boolean = false;
         _loc4_ = param1.getTouch(this,TouchPhase.HOVER);
         if(_loc4_)
         {
            this.checkIfNewCardGlowNeedsToBeRemoved();
            if(!this.mIsPressed && (Utils.isDesktop() || Utils.isBrowser()) && (!_loc5_ || _loc6_))
            {
               TweenMax.killTweensOf(mCard);
               if(mCard.getCardDropShadow())
               {
                  TweenMax.killTweensOf(mCard.getCardDropShadow());
                  this.mOriginalDropShadowScale = this.mOriginalDropShadowScale == -1 ? mCard.getCardDropShadow().scale : this.mOriginalDropShadowScale;
                  mCard.getCardDropShadow().scale = this.mOriginalDropShadowScale;
               }
               if(mCard.scale != 1.3)
               {
                  SpecialFX.createCardZoomTransition(mCard,1.3,0.75,true,false);
               }
            }
            if(!this.mIsPressed && (!_loc5_ || _loc6_))
            {
               this.mOriginalAlphaValue = this.mOriginalAlphaValue == -1 ? alpha : this.mOriginalAlphaValue;
            }
            SpecialFX.handle3DEffect(mCard,_loc4_,this.mRelativePoint,3);
         }
         else
         {
            if(!this.mIsPressed && (Utils.isDesktop() || Utils.isBrowser()) && (!_loc5_ || _loc6_))
            {
               _loc7_ = true;
               this.handleOnUnpressed();
            }
            if(!this.mIsPressed && (!_loc5_ || _loc6_))
            {
               this.mOriginalAlphaValue = this.mOriginalAlphaValue == -1 ? alpha : this.mOriginalAlphaValue;
               alpha = this.mOriginalAlphaValue;
            }
         }
         this.mIsHovered = param1.interactsWith(this);
         if(Utils.isBrowser())
         {
            Mouse.cursor = _loc4_ ? "hand" : "auto";
         }
         super.onTouch(param1);
         if(!_loc5_ || _loc6_)
         {
            alpha = this.mIsHovered && !_loc7_ ? 1 : this.mOriginalAlphaValue;
         }
      }
      
      private function handleOnUnpressed() : void
      {
         SpecialFX.createCardZoomTransition(mCard,1,0.1);
         setTimeout(mCard.addSpecialFX,120);
         if(mCard.getCardDropShadow())
         {
            this.mOriginalDropShadowScale = this.mOriginalDropShadowScale == -1 ? mCard.getCardDropShadow().scale : this.mOriginalDropShadowScale;
            mCard.getCardDropShadow().scale = this.mOriginalDropShadowScale;
         }
      }
      
      private function onEnterFrame() : void
      {
         if(!this.mIsHovered || this.mScrollableCard != null)
         {
            TweenMax.to(mCard,0.5,{
               "rotationX":0,
               "rotationY":0,
               "ease":Sine.easeOut
            });
         }
         if(Boolean(this.mScrollableCard && this.mTouches) && Boolean(this.mTouches.length > 0) && Boolean(this.mTouches[0]))
         {
            this.mScrollableCard.handleCardMovement(true,this.mTouches[0].globalX,this.mTouches[0].globalY);
            this.mScrollableCard.handleDragEffect(true,this.mTouches[0].globalX,this.mTouches[0].globalY);
         }
      }
      
      private function onAbilityIconImageTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(DisplayObject(param1.currentTarget),TouchPhase.HOVER);
         var _loc3_:FSImage = FSImage(param1.target);
         if(_loc2_)
         {
            if(_loc3_)
            {
               _loc3_.showTooltip();
            }
         }
         else if(_loc3_)
         {
            _loc3_.closeTooltip();
         }
      }
      
      private function performLockedAnimation(param1:int = 5) : void
      {
         if(this.mMaxAmountSocket)
         {
            TweenMax.killTweensOf(this.mMaxAmountSocket);
            TweenMax.to(this.mMaxAmountSocket,0.1,{
               "repeat":param1 - 1,
               "y":this.mMaxAmountSocket.y + (1 + Math.random() * 5),
               "x":this.mMaxAmountSocket.x + (1 + Math.random() * 5),
               "delay":0.1,
               "ease":Expo.easeInOut
            });
            TweenMax.to(this.mMaxAmountSocket,0.1,{
               "y":this.mMaxAmountSocket.y,
               "x":this.mMaxAmountSocket.x,
               "delay":(param1 + 1) * 0.1,
               "ease":Expo.easeInOut
            });
         }
      }
      
      private function getCardsPanel() : void
      {
         var _loc1_:FSDeckBuilderScreen = null;
         if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            _loc1_ = FSDeckBuilderScreen(InstanceMng.getCurrentScreen());
            if(_loc1_ != null)
            {
               mDeckCardsPanel = _loc1_.getCurrentCardsPanel();
            }
         }
      }
      
      override protected function checkIfNewCardGlowNeedsToBeRemoved(param1:Boolean = false) : void
      {
         super.checkIfNewCardGlowNeedsToBeRemoved(true);
      }
      
      private function createScrollableCard() : void
      {
         var _loc1_:Number = NaN;
         if(!mIsMoving)
         {
            if(this.mCurrentPosPoint == null)
            {
               this.mCurrentPosPoint = new Point();
            }
            this.mCurrentPosPoint.x = mCard.x;
            this.mCurrentPosPoint.y = mCard.y;
            if(this.mGlobalPosPoint == null)
            {
               this.mGlobalPosPoint = new Point();
            }
            this.mGlobalPosPoint = localToGlobal(this.mCurrentPosPoint);
            if(this.mScrollableCard == null)
            {
               this.mScrollableCard = InstanceMng.getCardsMng().createCard(mCard.getCardDef().getSku());
               this.mScrollableCard.setIsInfoCard(true);
               this.mScrollableCard.touchable = false;
               _loc1_ = Utils.isIOS() && !Utils.isIphone() ? 1.16 : 1;
               this.mScrollableCard.scale = _loc1_ * 0.9;
            }
            this.mScrollableCard.x = this.mGlobalPosPoint.x;
            this.mScrollableCard.y = this.mGlobalPosPoint.y;
            if(this.mOrigPos == null)
            {
               this.mOrigPos = new FSCoordinate(this.mGlobalPosPoint.x,this.mGlobalPosPoint.y);
            }
            else
            {
               this.mOrigPos.setX(this.mGlobalPosPoint.x);
               this.mOrigPos.setY(this.mGlobalPosPoint.y);
            }
            InstanceMng.getCurrentScreen().addChild(this.mScrollableCard);
         }
      }
      
      public function isMoving() : Boolean
      {
         var _loc1_:Boolean = this.mScrollableCard != null && (this.mScrollableCard.x != this.mOrigPos.mX || this.mScrollableCard.y != this.mOrigPos.mY);
         return mIsMoving || _loc1_;
      }
      
      private function checkIntersection(param1:Boolean = false) : void
      {
         var _loc2_:FSDeckBuilderScreen = null;
         var _loc3_:Boolean = false;
         this.getCardsPanel();
         if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            _loc2_ = FSDeckBuilderScreen(InstanceMng.getCurrentScreen());
            _loc3_ = _loc2_.isRecyclingMode();
            if(this.mScrollableCard.bounds.intersects(mDeckCardsPanel.bounds))
            {
               if(_loc3_)
               {
                  this.onRecyclingCheckIntersection();
               }
               else
               {
                  this.onEditingDeckCheckIntersection();
               }
            }
            else
            {
               this.mScrollableCard.rotationX = 0;
               this.mScrollableCard.rotationY = 0;
               this.mScrollableCard.rotationZ = 0;
               SpecialFX.createTransition(this.mScrollableCard,this.mOrigPos,0.2,0,this.onScrollableCardBackToCollection);
            }
            TweenMax.delayedCall(Config.getConfig().getDefaultZoomOutTime(),this.setCollectionContainerScrollable,[true]);
         }
      }
      
      private function setCollectionContainerScrollable(param1:Boolean) : void
      {
         if(Boolean(InstanceMng.getCurrentScreen()) && InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).setCollectionContainerScrollable(param1);
         }
      }
      
      private function onRecyclingCheckIntersection() : void
      {
         var _loc1_:int = 0;
         if(Boolean(InstanceMng.getCurrentScreen()) && InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            if(Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) && InstanceMng.getUserDataMng().getOwnerUserData().isCardInFavouritesCollection(this.mScrollableCard.getCardDef().getSku()))
            {
               Utils.setLogText(TextManager.getText("TID_DB_FAVOURITE_DENIED"),true);
               SpecialFX.createTransition(this.mScrollableCard,this.mOrigPos,0.2,0,this.onScrollableCardBackToCollection);
               return;
            }
            _loc1_ = FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).getRecyclePanel().getSlotsAmount();
            if(_loc1_ >= DeckCardsPanel.MAX_SLOTS_IN_DECK_PANEL)
            {
               Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_DECKBUILDER_RECYCLE_MAX_AMOUNT"),[DeckCardsPanel.MAX_SLOTS_IN_DECK_PANEL]),true,false,false);
               SpecialFX.createTransition(this.mScrollableCard,this.mOrigPos,0.2,0,this.onScrollableCardBackToCollection);
               return;
            }
            if(mCard.getCardDef().getGoldOnSell() > 0)
            {
               touchable = false;
               if(this.mScrollableCard)
               {
                  Utils.playSound(Constants.SOUND_CARD_TO_BF,SoundManager.TYPE_SFX);
               }
               SpecialFX.tweenToAlpha(this.mScrollableCard,0.001,0.3,0,this.onRemovedFromDeck);
               FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).getRecyclePanel().onDeckModified(true);
            }
            else
            {
               Utils.setLogText(TextManager.getText("TID_DECKBUILDER_STARTER_NOT_SOLD"),true);
               SpecialFX.createTransition(this.mScrollableCard,this.mOrigPos,0.2,0,this.onScrollableCardBackToCollection);
            }
         }
      }
      
      private function onEditingDeckCheckIntersection() : void
      {
         var _loc8_:String = null;
         var _loc1_:FSCardSlotInfo = mDeckCardsPanel.getSlotByCardSku(mCard.getCardDef().getSku());
         var _loc2_:Boolean = mDeckCardsPanel.getDeckCardsAmount().getAmount() == Config.getConfig().getDeckCardsAmount();
         var _loc3_:Boolean = DictionaryUtils.getDeckFamilyIDMaxReached(mCard.getCardDef(),mDeckCardsPanel.getDeckCardsLoaded());
         var _loc4_:int = mCard.getCardDef().getMaxAmountOndeck();
         var _loc5_:Boolean = !_loc2_ && (_loc1_ != null && _loc1_.getCardAmount() < _loc4_ || _loc1_ == null);
         var _loc6_:Boolean = mCard.getCardDef().isLeader();
         var _loc7_:Boolean = DictionaryUtils.catalogHasLeader(mDeckCardsPanel.getDeckCardsLoaded());
         if(_loc5_ && !_loc3_ && (!_loc6_ || _loc6_ && !_loc7_))
         {
            touchable = false;
            if(this.mScrollableCard)
            {
               Utils.playSound(Constants.SOUND_CARD_TO_BF,SoundManager.TYPE_SFX);
            }
            SpecialFX.tweenToAlpha(this.mScrollableCard,0.001,0.3,0,this.onRemovedFromDeck);
            if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
            {
               FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).getDeckCardsPanel().onDeckModified(true);
            }
         }
         else
         {
            SpecialFX.createTransition(this.mScrollableCard,this.mOrigPos,0.2,0,this.onScrollableCardBackToCollection);
            _loc8_ = "";
            if(_loc2_)
            {
               _loc8_ = TextManager.replaceParameters(TextManager.getText("TID_DECKBUILDER_DECK_AMOUNT"),[Config.getConfig().getDeckCardsAmount()]);
            }
            else
            {
               _loc4_ = mCard.getCardDef().getMaxAmountOndeck();
               _loc8_ = TextManager.replaceParameters(TextManager.getText("TID_DECKBUILDER_CARD_AMOUNT"),[_loc4_]);
            }
            Utils.setLogText(_loc8_);
         }
      }
      
      private function onScrollableCardBackToCollection() : void
      {
         this.mScrollableCard.removeFromParent();
         Utils.playSound(Constants.SOUND_CARD_TO_ACTION_DECK,SoundManager.TYPE_SFX);
      }
      
      private function onRemovedFromDeck() : void
      {
         Utils.playSound(Constants.SOUND_CARD_TO_BF,SoundManager.TYPE_SFX);
         mDeckCardsPanel.addCardSlotInfo(mCard.getCardDef().getSku(),1,0);
         this.onRemovedFromDeckUpdateInfo();
         this.mScrollableCard.x = this.mOrigPos.getX();
         this.mScrollableCard.y = this.mOrigPos.getY();
         this.mScrollableCard.alpha = 0.999;
         touchable = true;
         this.mScrollableCard.removeFromParent();
         this.onRemoveFromCollectionUpdateInfo();
      }
      
      public function onRemovedFromDeckUpdateInfo() : void
      {
         var _loc1_:FSDeckBuilderScreen = null;
         var _loc2_:Boolean = false;
         mAmount = mAmount - 1;
         updateAmountTextfield();
         if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            _loc1_ = FSDeckBuilderScreen(InstanceMng.getCurrentScreen());
            _loc2_ = _loc1_.cardNeedsToShowMaxAmountSocket(this.getCardDef());
            if(mAmount == 0 || _loc2_)
            {
               this.createMaxAmountSocket();
               _loc1_.refreshUI();
            }
         }
      }
      
      public function updateDeckCardInfoAfterCraft() : void
      {
         checkIfNewCard();
         setAmount(getAmount() + 1);
         updateAmountTextfield();
      }
      
      public function showPowerSelectedText(param1:Boolean = true) : void
      {
         if(param1)
         {
            updateAmountTextfield();
         }
         this.createSelectedPowerText();
         if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).refreshUI();
         }
      }
      
      public function hidePowerSelectedText(param1:Boolean = true) : void
      {
         if(param1)
         {
            updateAmountTextfield();
         }
         this.removeSelectedPowerText();
         if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).refreshUI();
         }
      }
      
      private function onRemoveFromCollectionUpdateInfo() : void
      {
         var _loc1_:FSDeckBuilderScreen = null;
         if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            _loc1_ = FSDeckBuilderScreen(InstanceMng.getCurrentScreen());
            _loc1_.updateCollectionFilteredWithDeck();
            _loc1_.refreshTabsAmount();
         }
      }
      
      public function checkIfNeedsToShowMaxAmountSocket() : void
      {
         var _loc1_:FSDeckBuilderScreen = null;
         var _loc2_:Boolean = false;
         if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            _loc1_ = FSDeckBuilderScreen(InstanceMng.getCurrentScreen());
            if(_loc1_)
            {
               _loc2_ = _loc1_.cardNeedsToShowMaxAmountSocket(this.getCardDef());
               if(_loc2_)
               {
                  this.createMaxAmountSocket();
               }
               else
               {
                  this.removeMaxAmountSocket();
               }
            }
         }
      }
      
      private function createSelectedPowerText() : void
      {
         if(this.mSelectedPowerTextfield == null)
         {
            this.mSelectedPowerTextfield = new FSTextfield(mCard.width,mCard.height / 2,TextManager.getText("TID_GEN_SELECTED"));
            this.mSelectedPowerTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GREEN);
            this.mSelectedPowerTextfield.touchable = false;
            this.mSelectedPowerTextfield.width = mCard.width * 1.1;
            this.mSelectedPowerTextfield.height = mCard.height;
            this.mSelectedPowerTextfield.x = 0;
            this.mSelectedPowerTextfield.y = mCard.y * 0.2;
            addChild(this.mSelectedPowerTextfield);
            updateAmountTextfield();
         }
      }
      
      private function createLockedPowerText() : void
      {
         if(this.mSelectedPowerTextfield == null)
         {
            this.mSelectedPowerTextfield = new FSTextfield(mCard.width,mCard.height / 2,TextManager.getText("TID_GEN_SELECTED"));
            this.mSelectedPowerTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_RED);
            this.mSelectedPowerTextfield.touchable = false;
            this.mSelectedPowerTextfield.width = mCard.width * 1.1;
            this.mSelectedPowerTextfield.height = mCard.height;
            this.mSelectedPowerTextfield.x = 0;
            this.mSelectedPowerTextfield.y = mCard.y * 0.2;
            addChild(this.mSelectedPowerTextfield);
            updateAmountTextfield();
         }
      }
      
      private function removeSelectedPowerText() : void
      {
         if(this.mSelectedPowerTextfield)
         {
            this.mSelectedPowerTextfield.removeFromParent();
            this.mSelectedPowerTextfield = null;
         }
      }
      
      public function createMaxAmountSocket() : void
      {
         if(this.mMaxAmountSocket == null)
         {
            this.mMaxAmountSocket = new FSImage(Root.assets.getTexture(this.AMOUNT_SOCKET_LIMITED_BG_NAME));
            this.mMaxAmountSocket.touchable = false;
            this.mMaxAmountSocket.width = mCard.width * 1.1;
            this.mMaxAmountSocket.height = mCard.height;
            this.mMaxAmountSocket.x = mCard.x - (this.mMaxAmountSocket.width - mCard.width) / 2 - mCard.width / 2;
            this.mMaxAmountSocket.y = mCard.y - mCard.height / 2;
            addChild(this.mMaxAmountSocket);
            updateAmountTextfield();
         }
      }
      
      public function getCardDef() : CardDef
      {
         return mCard.getCardDef();
      }
      
      public function removeMaxAmountSocket() : void
      {
         if(this.mMaxAmountSocket)
         {
            this.mMaxAmountSocket.removeFromParent();
            this.mMaxAmountSocket.destroy();
            this.mMaxAmountSocket = null;
         }
      }
      
      override protected function isMovable() : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc1_:Boolean = false;
         if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            _loc2_ = FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).getEdidionStatus() == FSDeckBuilderScreen.STATUS_EDITING;
            _loc3_ = FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).isRecyclingMode();
            _loc4_ = FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).isViewAllCardsModeON();
            _loc1_ = !_loc4_ && _loc2_ && this.mMaxAmountSocket == null && (mCard.getType() != FSCard.TYPE_POWER || mCard.getType() == FSCard.TYPE_POWER && _loc3_);
         }
         else
         {
            _loc1_ = false;
         }
         return _loc1_;
      }
      
      override public function dispose() : void
      {
         if(this.mMaxAmountSocket)
         {
            this.mMaxAmountSocket.removeFromParent();
            this.mMaxAmountSocket.destroy();
            this.mMaxAmountSocket = null;
         }
         if(this.mScrollableCard)
         {
            DictionaryUtils.disposeCard(this.mScrollableCard);
            this.mScrollableCard = null;
         }
         if(mNewCardBG)
         {
            mNewCardBG.removeFromParent(true);
            mNewCardBG = null;
         }
         if(mNewCardTextfield)
         {
            mNewCardTextfield.removeFromParent(true);
            mNewCardTextfield = null;
         }
         if(mCraftAvailableProgressBar)
         {
            mCraftAvailableProgressBar.removeFromParent(true);
            mCraftAvailableProgressBar = null;
         }
         if(mCraftAvailableTextfield)
         {
            mCraftAvailableTextfield.removeFromParent(true);
            mCraftAvailableTextfield = null;
         }
         if(this.mSelectedPowerTextfield)
         {
            this.mSelectedPowerTextfield.removeFromParent(true);
            this.mSelectedPowerTextfield = null;
         }
         Utils.destroyArray(this.mTouches);
         this.mTouches = null;
         this.mOrigPos = null;
         this.mCurrentPosPoint = null;
         this.mGlobalPosPoint = null;
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         super.dispose();
      }
   }
}

