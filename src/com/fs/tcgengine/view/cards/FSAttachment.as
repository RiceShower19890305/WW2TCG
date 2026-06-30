package com.fs.tcgengine.view.cards
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.AbilitiesMng;
   import com.fs.tcgengine.controller.PvPConnectionMng;
   import com.fs.tcgengine.controller.ScoreMng;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.battle.BattleEnginePvP;
   import com.fs.tcgengine.model.board.card.Ability;
   import com.fs.tcgengine.model.rules.AbilityDef;
   import com.fs.tcgengine.model.rules.AttachmentDef;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.FactionDef;
   import com.fs.tcgengine.model.rules.UnitDef;
   import com.fs.tcgengine.model.userdata.UserBattleInfo;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.board.AttachmentsInfoBlock;
   import com.fs.tcgengine.view.socket.FSCardSocket;
   import com.greensock.TweenMax;
   import flash.utils.Dictionary;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.extensions.ColorArgb;
   
   public class FSAttachment extends FSCard
   {
      
      public static const MAX_ATTACHMENTS_AMOUNT:int = 2;
      
      private var mTiers:Vector.<AttachmentDef>;
      
      private var mCurrentHoveredSocket:FSCardSocket;
      
      public function FSAttachment(param1:String)
      {
         super(param1);
      }
      
      override public function reset(param1:String = "") : void
      {
         super.reset(param1);
         if(this.mTiers)
         {
            this.mTiers.length = 0;
         }
         this.mCurrentHoveredSocket = null;
         this.fillTierCardsVector();
      }
      
      private function fillTierCardsVector() : void
      {
         var _loc1_:String = null;
         var _loc2_:AttachmentDef = null;
         if(mCardDef)
         {
            this.mTiers = new Vector.<AttachmentDef>();
            this.mTiers.push(mCardDef);
            _loc1_ = mCardDef.getUpgradeSku();
            while(_loc1_ != null)
            {
               _loc2_ = AttachmentDef(InstanceMng.getCardsDefMng().getDefBySku(_loc1_));
               this.mTiers.push(_loc2_);
               _loc1_ = _loc2_.getUpgradeSku();
            }
         }
      }
      
      override public function showDamageAndShield(param1:Boolean = false) : void
      {
         super.showDamageAndShield(param1);
         mDamageTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_GREEN);
         mDefenseTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_GREEN);
      }
      
      override public function isCardAttachableToSocket(param1:FSCardSocket, param2:Boolean = false) : Boolean
      {
         var _loc4_:FSCard = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:AbilityDef = null;
         var _loc13_:String = null;
         var _loc14_:FactionDef = null;
         var _loc3_:Boolean = false;
         if(!param1.isEmpty())
         {
            _loc4_ = param1.getParentCard();
            if(_loc4_ != null && _loc4_.isUnit() && UnitDef(_loc4_.getCardDef()).getCanEquipItems())
            {
               _loc5_ = _loc4_.getAttachmentsAmount();
               if(_loc5_ < MAX_ATTACHMENTS_AMOUNT)
               {
                  if(!FSUnit(_loc4_).hasAttachment(mCardDef.getSku()))
                  {
                     _loc6_ = this.getAttachmentCost(param1);
                     _loc7_ = mParentUserBattleInfo.getActionPointsLeft();
                     if(_loc6_ <= _loc7_)
                     {
                        _loc8_ = mCardDef.getAttachedToSubcategorySku();
                        _loc9_ = _loc4_.getCardDef().getSubCategorySku();
                        _loc3_ = Utils.isAnySubcategorySkuAllowed(_loc8_,_loc9_);
                        if(!_loc3_)
                        {
                           if(param2)
                           {
                              _loc11_ = InstanceMng.getSubCategoriesMng().getSubcategoriesNamesByDefSku(_loc8_);
                              _loc10_ = TextManager.replaceParameters(TextManager.getText("TID_LOG_ATTACH_SCATEGORY"),[_loc11_]);
                              Utils.setLogText(_loc10_,true);
                           }
                        }
                        else
                        {
                           _loc12_ = getAbilityDefByKeyName(AbilitiesMng.SPECIAL_EQUIP);
                           if(_loc12_ != null)
                           {
                              if(_loc12_.getFactionSku() == _loc4_.getCardDef().getFactionSku())
                              {
                                 return true;
                              }
                              if(param2)
                              {
                                 _loc13_ = "xxx";
                                 _loc14_ = FactionDef(InstanceMng.getFactionsDefMng().getDefBySku(_loc12_.getFactionSku()));
                                 if(_loc14_ != null)
                                 {
                                    _loc13_ = _loc14_.getName();
                                 }
                                 _loc10_ = TextManager.replaceParameters(TextManager.getText("TID_LOG_ATTACH_FACTION"),[_loc13_]);
                                 Utils.setLogText(_loc10_,true);
                              }
                              _loc3_ = false;
                           }
                        }
                     }
                     else if(param2)
                     {
                        FSBattleScreen(InstanceMng.getCurrentScreen()).showNotEnoughAPEffect(this);
                     }
                  }
                  else if(param2)
                  {
                     Utils.setLogText(TextManager.getText("TID_LOG_ATTACH_DUPLICATE"),true);
                  }
               }
               else if(param2)
               {
                  Utils.setLogText(TextManager.getText("TID_LOG_ATTACH_NOSLOT"),true);
               }
            }
         }
         else if(param2 && (mAttachedToSocket != null && !mAttachedToSocket.isBattlefieldSocket()) && (!mIsMoving && !mCardPressedAndMoving))
         {
            Utils.setLogText(TextManager.getText("TID_LOG_SOCKET_ATTACH"),true);
         }
         return _loc3_;
      }
      
      override protected function showNotAbleToPlaceCardMessage() : void
      {
      }
      
      override protected function onTouch(param1:TouchEvent) : void
      {
         var _loc2_:FSCardSocket = null;
         var _loc3_:Dictionary = null;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         var _loc9_:Boolean = false;
         if(parent != null && parent is AttachmentsInfoBlock)
         {
            mCardTouch = param1.getTouch(this,TouchPhase.ENDED);
            if(mCardTouch)
            {
               if(!Root.assets.isLoading && !mZoomedIn && (mBattleSceneParent.getSelectedCard() != null && mBattleSceneParent.getSelectedCard().isZoomedIn()))
               {
                  SpecialFX.zoomOut(mBattleSceneParent.getSelectedCard());
                  notifyCardSelected();
                  SpecialFX.zoomIn(this);
               }
            }
         }
         else
         {
            super.onTouch(param1);
            _loc4_ = false;
            _loc6_ = mAttachedToSocket != null && !mAttachedToSocket.isBattlefieldSocket();
            _loc7_ = !mDisableIntersections && _loc6_;
            if(mBattleSceneParent != null && _loc7_)
            {
               _loc3_ = mBattleSceneParent.getBattleEngine().isOwnerTurn() ? mBattleSceneParent.getOwnerBFSocketCatalog() : mBattleSceneParent.getOpponentBFSocketCatalog();
               if(_loc3_ != null)
               {
                  _loc9_ = false;
                  _loc9_ = false;
                  for each(_loc2_ in _loc3_)
                  {
                     if(bounds.intersects(_loc2_.bounds))
                     {
                        _loc9_ = true;
                        if(this.mCurrentHoveredSocket != _loc2_)
                        {
                           this.mCurrentHoveredSocket = _loc2_;
                           if(this.isCardAttachableToSocket(_loc2_))
                           {
                              _loc5_ = _loc2_.getParentCard().getCardDef().getTier();
                              this.changeCardDefTemporarily(_loc5_);
                           }
                        }
                     }
                  }
                  if(this.mCurrentHoveredSocket != null && _loc9_ == false)
                  {
                     this.changeCardDefTemporarily(1);
                     this.mCurrentHoveredSocket = null;
                  }
               }
            }
         }
      }
      
      override public function onNoIntersectionFound() : void
      {
         this.changeCardDefTemporarily(1);
         this.mCurrentHoveredSocket = null;
         super.onNoIntersectionFound();
      }
      
      override protected function checkIntersection(param1:FSCardSocket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = this.getAttachmentCost(param1);
         if(mBattleSceneParent.getBattleEngine().canPlayerDoMoreActions(_loc2_))
         {
            _loc3_ = param1.getParentCard().getCardDef().getTier();
            this.changeCardDefTemporarily(_loc3_);
            this.setAttachedToSocket(param1);
            Utils.removeLog();
         }
         else
         {
            if(param1 != null && param1.getParentCard() != null && param1.getParentCard() is FSUnit && param1.getParentCard().getAttachmentsAmount() > 0)
            {
               Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_LOG_ATTACH_COST_2"),[_loc2_]),true);
            }
            else if(InstanceMng.getCurrentScreen() != null && InstanceMng.getCurrentScreen() is FSBattleScreen)
            {
               FSBattleScreen(InstanceMng.getCurrentScreen()).showNotEnoughAPEffect(this);
            }
            unHighlightAllPlayableItems(true);
            this.changeCardDefTemporarily(1);
            this.mCurrentHoveredSocket = null;
            if(mBattleSceneParent)
            {
               mBattleSceneParent.suggestPlayableCardON();
            }
         }
         SpecialFX.zoomOut(this);
      }
      
      override public function setAttachedToSocket(param1:FSCardSocket, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false) : void
      {
         var _loc5_:Boolean = false;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         _loc5_ = checkIfNeedsToBeStoredInSaveObj(param2,param3);
         var _loc6_:String = "";
         if(_loc5_)
         {
            _loc6_ = getOldSocketIndexCode();
         }
         if(param2)
         {
            if(param1 != null && !param1.isBattlefieldSocket())
            {
               param1.setParentCard(this);
            }
         }
         if(param3 || mAttachedToSocket != null)
         {
            if(param3 || mAttachedToSocket != null && !mAttachedToSocket.isBattlefieldSocket())
            {
               mParentUserBattleInfo.removeCardFromPlayableCardsCatalog(this);
            }
            if(mAttachedToSocket != null)
            {
               mAttachedToSocket.setParentCard(null);
            }
         }
         mAttachedToSocket = param1;
         if(mBattleSceneParent != null && !param2)
         {
            if(!param3)
            {
               InstanceMng.getScoreMng().trackAction(ScoreMng.PLAY_ATTACHMENT);
               if(!mBattleSceneParent.getBattleEngine().isPvPMatch())
               {
                  InstanceMng.getTargetMng().addCardPlayed(this);
               }
               if(Config.getConfig().hasQuests())
               {
                  InstanceMng.getQuestsMng().onCardPlayed(this);
               }
            }
            _loc7_ = this.getAttachmentCost(mAttachedToSocket);
            mBattleSceneParent.getBattleEngine().notifyActionDone(_loc7_);
            if(InstanceMng.getBattleEngine().isPvPMatch() || InstanceMng.getBattleEngine().isOwnerTurn())
            {
               if(mBattleSceneParent)
               {
                  mBattleSceneParent.suggestPlayableCardON();
               }
            }
         }
         if(!param2)
         {
            mBattleSceneParent.setCardAnimsON(true);
            _loc8_ = Config.getConfig().getDefaultTriggerOnAttachedAbilitiesDuration();
            FSDebug.debugTrace("Attachment -> tween to alpha on setAttachedToSocket");
            touchable = false;
            TweenMax.delayedCall(_loc8_,SpecialFX.tweenToAlpha,[this,0.001,Config.getConfig().getDefaultTriggerAttachmentFadeOffDuration(),0,this.onAttachmentActivate,[_loc5_,_loc6_]]);
         }
         if(mAttachedToSocket != null && mAttachedToSocket.isBattlefieldSocket())
         {
            Utils.playSound(Constants.SOUND_ITEM_ATTACHED,SoundManager.TYPE_SFX);
         }
      }
      
      public function getAttachmentCost(param1:FSCardSocket, param2:Boolean = false) : int
      {
         var _loc4_:int = 0;
         var _loc5_:FSCard = null;
         var _loc6_:Array = null;
         var _loc7_:Boolean = false;
         var _loc8_:UserBattleInfo = null;
         var _loc9_:AbilityDef = null;
         var _loc10_:Boolean = false;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc3_:int = 1;
         if(param1)
         {
            _loc4_ = 0;
            _loc5_ = param1.getParentCard();
            if(!param2)
            {
               _loc4_ = _loc5_ ? _loc5_.getAttachmentsAmount() : 0;
            }
            _loc6_ = AttachmentDef(mCardDef).getAttachmentCost();
            _loc3_ = _loc6_ != null && _loc6_.length > 0 && _loc6_.length > _loc4_ ? int(_loc6_[_loc4_]) : int(_loc6_[_loc6_.length - 1]);
            if(InstanceMng.getBattleEngine())
            {
               _loc7_ = InstanceMng.getBattleEngine().isOwnerTurn();
               _loc8_ = _loc7_ ? InstanceMng.getBattleEngine().getOwnerBattleInfo() : InstanceMng.getBattleEngine().getOpponentBattleInfo();
               _loc10_ = _loc5_ ? _loc5_.hasWellEquipped(this) : false;
               if(Boolean(_loc5_) && _loc10_)
               {
                  _loc3_ = _loc3_ - 1 >= 0 ? int(_loc3_ - 1) : 0;
               }
               if(_loc8_)
               {
                  if(_loc8_.isModifiedCostActive())
                  {
                     _loc9_ = _loc8_.getExtraSummonCostAbilityDef();
                     _loc11_ = _loc8_.getExtraSummonCostTurns();
                     if(_loc11_ > 0 || _loc11_ == -1 || _loc11_ == -2)
                     {
                        if(Boolean(_loc9_) && _loc9_.isCardEligibleForAbility(this))
                        {
                           return _loc3_ + _loc8_.getExtraSummonCost() >= 0 ? int(_loc3_ + _loc8_.getExtraSummonCost()) : 0;
                        }
                     }
                  }
                  if(_loc8_.isFixedSummonCostActive())
                  {
                     _loc9_ = _loc8_.getFixedSummonCostAbilityDef();
                     _loc12_ = _loc8_.getTurnsFixedSummonCost();
                     if(_loc12_ > 0 || _loc12_ == -1 || _loc12_ == -2)
                     {
                        if(Boolean(_loc9_) && _loc9_.isCardEligibleForAbility(this))
                        {
                           return _loc8_.getFixedSummonCost();
                        }
                     }
                  }
               }
            }
         }
         return _loc3_;
      }
      
      override protected function isCardSocketRectification() : Boolean
      {
         return false;
      }
      
      public function onAttachmentActivate(param1:Boolean = false, param2:String = "") : void
      {
         var _loc4_:FSCard = null;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         FSDebug.debugTrace("[onAttachmentActivate]");
         if(mAttachedToSocket != null)
         {
            _loc4_ = mAttachedToSocket.getParentCard();
            if(_loc4_ != null)
            {
               FSUnit(_loc4_).addAttachment(this);
            }
         }
         var _loc3_:Boolean = setIsOnBattlefield(true,isEnemyCard());
         if(_loc3_)
         {
            updateAbilitiesAppliedOnNextCard();
         }
         if(getBattleSceneParent())
         {
            getBattleSceneParent().setSelectedCard(null);
         }
         unHighlightAllPlayableItems();
         removeFromParent();
         removeDropShadow();
         removeEventListeners();
         mOldSocketIndexCode = param2;
         if(param1)
         {
            if(Boolean(InstanceMng.getBattleEngine()) && InstanceMng.getBattleEngine() is BattleEnginePvP)
            {
               _loc5_ = this.hasRandomTargetAbilities();
               _loc6_ = this.hasRandomStatsAbilities();
               _loc7_ = this.hasMulticastAbilities();
               _loc8_ = this.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_RECRUIT) != null;
               if(PvPConnectionMng.realTimeAllowed() && !_loc6_ && !_loc7_ && !_loc5_ && !_loc8_ || !PvPConnectionMng.realTimeAllowed())
               {
                  BattleEnginePvP(InstanceMng.getBattleEngine()).onCardMoved(this,param2,mAttachedToSocket.getSocketIndex());
               }
            }
         }
         InstanceMng.getBattleEngine().storeCombatLogAction(BattleEngine.COMBAT_LOG_ATTACHMENT_USED,this);
         this.triggerOnAttachedAbilities();
         if(mBattleSceneParent)
         {
            mBattleSceneParent.setCardAnimsON(false);
            mBattleSceneParent.suggestPlayableCardON();
         }
      }
      
      public function changeCardDefTemporarily(param1:int) : void
      {
         var _loc2_:AttachmentDef = null;
         if(param1 == 1)
         {
            FSDebug.debugTrace("");
         }
         if(this.mTiers != null && (this.mTiers.length > 0 && this.mTiers.length > param1 - 1))
         {
            _loc2_ = this.mTiers[param1 - 1];
            if(_loc2_ != mCardDef)
            {
               FSDebug.debugTrace("Changing card def temporarily to tier " + param1);
               removeAbilityIcons();
               initializeCard(_loc2_,true);
            }
         }
      }
      
      override public function promoteCard(param1:String) : void
      {
         var _loc2_:CardDef = CardDef(InstanceMng.getCardsDefMng().getDefBySku(param1));
         if(_loc2_ != null)
         {
            onCardPromote(_loc2_);
            initializeCard(_loc2_,true);
         }
      }
      
      override public function detachCard(param1:Boolean = false) : void
      {
         var _loc4_:String = null;
         var _loc2_:Boolean = isEnemyCard();
         mAttachedToSocket = null;
         if(mParentUserBattleInfo)
         {
            mParentUserBattleInfo.addCardToGraveyard(this);
         }
         var _loc3_:Boolean = false;
         if(mIsOnBattlefield)
         {
            _loc3_ = setIsOnBattlefield(false,_loc2_);
         }
         if(!param1 && Boolean(mCardDef))
         {
            _loc4_ = mCardDef.getSku();
            if(mCardDef.getTier() > 1)
            {
               _loc4_ = this.mTiers ? this.mTiers[0].getSku() : null;
            }
            if(!Config.getConfig().gameHasGraveyard() && _loc4_ != null && Boolean(mParentUserBattleInfo))
            {
               mParentUserBattleInfo.addCardSkuToCatalogs(_loc4_,1);
               if(_loc3_)
               {
                  updateAbilitiesAppliedOnNextCard();
               }
            }
         }
      }
      
      override public function triggerOnAttachedAbilities() : void
      {
         var _loc2_:Dictionary = null;
         var _loc3_:FSCard = null;
         super.triggerOnAttachedAbilities();
         var _loc1_:Boolean = getAbilityDefByKeyName(AbilitiesMng.SPECIAL_DEPLOY) != null;
         if(_loc1_)
         {
            _loc2_ = new Dictionary(true);
            _loc3_ = getAttachedToSocket().getParentCard();
            _loc2_[0] = _loc3_;
            InstanceMng.getBattleEngine().performSupportToAttackMovement(true,_loc2_);
            _loc3_.updateSummonCooldown(0);
            FSUnit(_loc3_).setTurnsAmountWithoutMovingToAttackLane(0);
         }
      }
      
      override public function removeCardElemsFromDisplayList(param1:Boolean = false) : void
      {
         Utils.destroyArray(this.mTiers);
         this.mTiers = null;
         this.mCurrentHoveredSocket = null;
         super.removeCardElemsFromDisplayList(param1);
      }
      
      override public function destroy() : void
      {
         Utils.destroyArray(this.mTiers);
         this.mTiers = null;
         this.mCurrentHoveredSocket = null;
         super.destroy();
      }
      
      public function hasCardsToBeAttachedAvailable() : Boolean
      {
         var _loc2_:FSCardSocket = null;
         var _loc1_:Dictionary = mBattleSceneParent.getBattleEngine().isOwnerTurn() ? mBattleSceneParent.getOwnerBFSocketCatalog() : mBattleSceneParent.getOpponentBFSocketCatalog();
         for each(_loc2_ in _loc1_)
         {
            if(this.isCardAttachableToSocket(_loc2_))
            {
               return true;
            }
         }
         return false;
      }
      
      public function has0CostTargetsToBeAttachedTo() : Boolean
      {
         var _loc2_:FSCardSocket = null;
         var _loc1_:Dictionary = mBattleSceneParent.getBattleEngine().isOwnerTurn() ? mBattleSceneParent.getOwnerBFSocketCatalog() : mBattleSceneParent.getOpponentBFSocketCatalog();
         var _loc3_:int = mParentUserBattleInfo.getActionPointsLeft();
         if(_loc3_ == 0)
         {
            for each(_loc2_ in _loc1_)
            {
               if(this.isCardAttachableToSocket(_loc2_))
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      override public function highlightPlayableSocketsVector(param1:Boolean = false, param2:Ability = null) : void
      {
         var _loc4_:FSCardSocket = null;
         var _loc5_:ColorArgb = null;
         var _loc6_:ColorArgb = null;
         super.highlightPlayableSocketsVector(param1,param2);
         var _loc3_:Dictionary = mBattleSceneParent.getBattleEngine().isOwnerTurn() ? mBattleSceneParent.getOwnerBFSocketCatalog() : mBattleSceneParent.getOpponentBFSocketCatalog();
         for each(_loc4_ in _loc3_)
         {
            if(this.isCardAttachableToSocket(_loc4_))
            {
               addCardSocketToPlayableSocketsVector(_loc4_);
            }
         }
         for each(_loc4_ in mPlayableSockets)
         {
            _loc5_ = new ColorArgb(0,1,0,1);
            _loc6_ = new ColorArgb(0,1,0,0);
            _loc4_.activateHighlightTween(65280,true,1,_loc5_,_loc6_);
         }
      }
      
      override protected function showUpgradeCost(param1:int = -1) : void
      {
      }
   }
}

