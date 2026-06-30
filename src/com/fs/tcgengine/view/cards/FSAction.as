package com.fs.tcgengine.view.cards
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.AbilitiesMng;
   import com.fs.tcgengine.controller.ScoreMng;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.battle.BattleEnginePvP;
   import com.fs.tcgengine.model.board.card.Ability;
   import com.fs.tcgengine.model.rules.AbilityDef;
   import com.fs.tcgengine.model.rules.ActionDef;
   import com.fs.tcgengine.model.userdata.UserBattleInfo;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.socket.FSCardSocket;
   import com.greensock.TweenMax;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   public class FSAction extends FSCard
   {
      
      public function FSAction(param1:String)
      {
         super(param1);
      }
      
      override public function createTierFrame(param1:Boolean = false) : void
      {
      }
      
      override public function isCardAttachableToSocket(param1:FSCardSocket, param2:Boolean = false) : Boolean
      {
         var _loc4_:FSCard = null;
         var _loc3_:Boolean = false;
         if(!param1.isEmpty())
         {
            _loc4_ = param1.getParentCard();
            if(_loc4_ != null && _loc4_.isUnit())
            {
               return true;
            }
         }
         return _loc3_;
      }
      
      override protected function checkIntersection(param1:FSCardSocket) : void
      {
         var _loc2_:AbilityDef = null;
         var _loc6_:Boolean = false;
         var _loc3_:Boolean = Boolean(_loc2_) && _loc2_.isCardEligibleForAbility(this);
         if(Boolean(mParentUserBattleInfo) && mParentUserBattleInfo.isModifiedCostActive())
         {
            _loc2_ = mParentUserBattleInfo.getExtraSummonCostAbilityDef();
            _loc3_ = Boolean(_loc2_) && _loc2_.isCardEligibleForAbility(this);
         }
         if(Boolean(!_loc3_) && Boolean(mParentUserBattleInfo) && mParentUserBattleInfo.isFixedSummonCostActive())
         {
            _loc2_ = mParentUserBattleInfo.getFixedSummonCostAbilityDef();
            _loc3_ = Boolean(_loc2_) && _loc2_.isCardEligibleForAbility(this);
         }
         var _loc4_:int = getCardSummonCost();
         var _loc5_:Boolean = mBattleSceneParent.getBattleEngine().canPlayerDoMoreActions(_loc4_) || Config.getConfig().battleShowAbilitiesPanelOnActionUsed();
         if(_loc5_)
         {
            _loc6_ = this.onPlayerCanPerformOpsCheckIntersection(param1);
            if((_loc6_) && _loc3_)
            {
               if(!Config.getConfig().battleShowAbilitiesPanelOnActionUsed())
               {
                  mParentUserBattleInfo.removeSummonCostAbilities();
               }
            }
         }
         else
         {
            if(InstanceMng.getCurrentScreen() != null && InstanceMng.getCurrentScreen() is FSBattleScreen)
            {
               FSBattleScreen(InstanceMng.getCurrentScreen()).showNotEnoughAPEffect(this);
            }
            unHighlightAllPlayableItems(true);
         }
         SpecialFX.zoomOut(this);
      }
      
      protected function onPlayerCanPerformOpsCheckIntersection(param1:FSCardSocket) : Boolean
      {
         var _loc3_:AbilityDef = null;
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         var _loc2_:Boolean = true;
         if(this.isSocketInPlayableSocketsVector(param1))
         {
            _loc2_ = true;
            this.onIntersectionSuccessful(FSUnit(param1.getParentCard()));
         }
         else
         {
            _loc2_ = false;
            _loc3_ = Boolean(mAbilities) && mAbilities.length > 0 ? mAbilities[0].getAbilityDef() : null;
            if(_loc3_)
            {
               _loc4_ = Boolean(param1) && Boolean(param1.getParentCard()) && Boolean(param1.getParentCard().getAbilityDefByKeyName(AbilitiesMng.SPECIAL_UNTARGETABLE));
               _loc5_ = "";
               if(Boolean(param1) && Boolean(param1.getParentCard()))
               {
                  if(!param1.getParentCard().canBePromoted())
                  {
                     _loc5_ = _loc4_ ? "TID_SPEC_AB_UNTARGETABLE" : "TID_EVOLUTION_OFF";
                     Utils.setLogText(TextManager.getText(_loc5_),true);
                  }
                  else
                  {
                     _loc5_ = _loc4_ ? "TID_SPEC_AB_UNTARGETABLE" : "TID_TARGET_NOT_ELEGIBLE";
                     Utils.setLogText(TextManager.getText(_loc5_),true);
                  }
               }
               else
               {
                  _loc5_ = _loc4_ ? "TID_SPEC_AB_UNTARGETABLE" : "TID_TARGET_NOT_ELEGIBLE";
                  Utils.setLogText(TextManager.getText(_loc5_),true);
               }
            }
            unHighlightAllPlayableItems();
            if(mBattleSceneParent)
            {
               mBattleSceneParent.suggestPlayableCardON();
            }
         }
         return _loc2_;
      }
      
      protected function onIntersectionSuccessful(param1:FSUnit) : void
      {
         var _loc2_:int = 0;
         var _loc3_:FSBattleScreen = null;
         var _loc4_:Array = null;
         var _loc5_:Ability = null;
         if(Config.getConfig().battleShowAbilitiesPanelOnActionUsed())
         {
            mBattleSceneParent.openAbilitiesChooserPanel(this,param1);
         }
         else
         {
            Utils.removeLog();
            param1.unHighlightAllPlayableItems();
            if(InstanceMng.getBattleEngine())
            {
               _loc2_ = getCardSummonCost();
               InstanceMng.getBattleEngine().setActionUpgradeCostSelected(_loc2_);
               _loc3_ = InstanceMng.getBattleEngine().getBattleScreen();
               if(_loc3_ != null)
               {
                  touchable = false;
                  _loc4_ = new Array();
                  _loc5_ = getAbilities()[0];
                  if(!InstanceMng.getAbilitiesMng().isTargetSelectionAbility(_loc5_.getAbilityDef()))
                  {
                     _loc4_ = InstanceMng.getAbilitiesMng().getEligibleTargetsByTargetIndex(_loc5_.getAbilityDef(),this,_loc5_.getAbilityDef().getCostRange());
                  }
                  else if(param1 != null)
                  {
                     _loc4_.push(param1);
                  }
                  this.storeActionMovement(_loc4_,param1);
                  _loc5_.onTargetSelected(_loc4_);
                  if(InstanceMng.getCurrentScreen() is FSBattleScreen)
                  {
                     FSBattleScreen(InstanceMng.getCurrentScreen()).setSelectedCard(null);
                  }
               }
            }
         }
      }
      
      private function storeActionMovement(param1:Array, param2:FSCard) : void
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc3_:Boolean = checkIfNeedsToBeStoredInSaveObj(false,false);
         var _loc4_:String = "";
         if(_loc3_)
         {
            _loc4_ = getOldSocketIndexCode();
            if(param1 != null && param1.length > 1)
            {
               _loc5_ = "";
            }
            else if(param2 != null)
            {
               _loc6_ = param2.getParentUserBattleInfo().isOwnerBattleInfo() ? "owner_card_" : "opponent_card_";
               _loc5_ = _loc6_ + param2.getAttachedToSocket().getSocketIndex();
            }
            BattleEnginePvP(InstanceMng.getBattleEngine()).onActionUsed(this,_loc4_,_loc5_,getAbilities()[0].getAbilityDef().getSku());
         }
      }
      
      public function storeActionMovementFromAbilitiesPanel(param1:Array, param2:FSCard, param3:UserBattleInfo, param4:AbilityDef) : void
      {
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc5_:Boolean = checkIfNeedsToBeStoredInSaveObj(false,false);
         var _loc6_:String = "";
         if(_loc5_)
         {
            _loc6_ = getOldSocketIndexCode();
            if(param1 != null && param1.length > 1)
            {
               _loc7_ = "";
            }
            else if(param2 != null)
            {
               _loc8_ = param2.getParentUserBattleInfo().isOwnerBattleInfo() ? "owner_card_" : "opponent_card_";
               _loc7_ = _loc8_ + param2.getAttachedToSocket().getSocketIndex();
            }
            else if(param3 != null)
            {
               _loc7_ = param3.isOwnerBattleInfo() ? "owner_portrait" : "opponent_portrait";
            }
            BattleEnginePvP(InstanceMng.getBattleEngine()).onActionUsed(this,_loc6_,_loc7_,param4.getSku());
         }
      }
      
      public function isSocketInPlayableSocketsVector(param1:FSCardSocket) : Boolean
      {
         var _loc3_:int = 0;
         var _loc2_:Boolean = false;
         if(mPlayableSockets != null)
         {
            _loc3_ = 0;
            while(_loc3_ < mPlayableSockets.length)
            {
               if(param1 == mPlayableSockets[_loc3_])
               {
                  return true;
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      override protected function performIntersectionTest(param1:Boolean = false) : Boolean
      {
         var _loc3_:FSCardSocket = null;
         var _loc4_:Dictionary = null;
         var _loc8_:int = 0;
         var _loc9_:Boolean = false;
         var _loc10_:UserBattleInfo = null;
         var _loc11_:Dictionary = null;
         var _loc12_:Component = null;
         var _loc13_:UserBattleInfo = null;
         var _loc14_:int = 0;
         var _loc15_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = canCardBeMoved();
         var _loc7_:int = 0;
         if(mBattleSceneParent != null && _loc6_)
         {
            _loc4_ = mBattleSceneParent.getBattleEngine().isOwnerTurn() ? mBattleSceneParent.getOpponentBFSocketCatalog() : mBattleSceneParent.getOwnerBFSocketCatalog();
            if(_loc4_ != null)
            {
               if(hasAnimatedBG())
               {
                  smBGIntersectionRect = mBGAnimated ? mBGAnimated.getBounds(parent,smBGIntersectionRect) : null;
               }
               else
               {
                  smBGIntersectionRect = mBG ? mBG.getBounds(parent,smBGIntersectionRect) : null;
               }
               for each(_loc3_ in _loc4_)
               {
                  smSocketIntersectionRect = _loc3_.getBounds(parent,smSocketIntersectionRect);
                  _loc9_ = isSocketInPlayableSockets(_loc3_);
                  _loc7_ += _loc9_ ? 1 : 0;
                  if(Boolean(_loc3_ != null && _loc9_) && Boolean(smBGIntersectionRect) && smBGIntersectionRect.intersects(smSocketIntersectionRect))
                  {
                     if(!_loc2_)
                     {
                        if(!param1)
                        {
                           if(mBattleSceneParent.getBattleEngine().isCardAttachableToSocket(this,_loc3_))
                           {
                              if(!param1)
                              {
                                 this.checkIntersection(_loc3_);
                                 return true;
                              }
                              mIntersectionTopIndex = _loc3_.getSocketIndex();
                              _loc2_ = true;
                           }
                           else if(!param1)
                           {
                              this.showNotAbleToPlaceCardMessage();
                           }
                        }
                     }
                  }
               }
               if(!param1)
               {
                  _loc11_ = InstanceMng.getBattleEngine().getUserBattleInfoCatalog();
                  _loc13_ = null;
                  _loc14_ = 0;
                  for each(_loc10_ in _loc11_)
                  {
                     _loc12_ = _loc10_.getUserBattlePortrait().getFrameContainer();
                     if(Boolean(_loc10_.getUserBattlePortrait()) && _loc10_.getUserBattlePortrait().touchable)
                     {
                        _loc14_++;
                        _loc13_ = _loc10_;
                     }
                     if(Boolean(_loc12_ != null && smBGIntersectionRect) && Boolean(smBGIntersectionRect.intersects(_loc12_.parent.bounds)) && _loc10_.getUserBattlePortrait().touchable)
                     {
                        _loc5_ = this.onPortraitIntersectionFound(_loc10_);
                     }
                  }
               }
            }
         }
         if(!_loc5_)
         {
            _loc15_ = super.performIntersectionTest(param1);
            if(!_loc15_)
            {
               if(!this.intersectsWithAnyDeckSocket())
               {
                  if(!param1 && _loc7_ == 0 && _loc14_ == 1 && _loc13_ != null)
                  {
                     TweenMax.killTweensOf(this);
                     TweenMax.killDelayedCallsTo(SpecialFX.createShadowZoomTransition);
                     this.onPortraitIntersectionFound(_loc13_);
                     return true;
                  }
               }
            }
            if(Boolean(mBattleSceneParent) && !param1)
            {
               mBattleSceneParent.suggestPlayableCardON();
            }
         }
         if(param1 && _loc2_ == false)
         {
            mIntersectionTopIndex = -1;
         }
         if(param1 && Boolean(_loc4_))
         {
            processPostIntersection(_loc4_);
         }
         return _loc5_;
      }
      
      private function intersectsWithAnyDeckSocket() : Boolean
      {
         var _loc2_:Dictionary = null;
         var _loc3_:Dictionary = null;
         var _loc4_:FSCardSocket = null;
         var _loc1_:Boolean = false;
         if(mBattleSceneParent)
         {
            _loc2_ = mBattleSceneParent.getOwnerSideDeckSocketCatalog();
            _loc3_ = mBattleSceneParent.getOpponentSideDeckSocketCatalog();
            if(hasAnimatedBG())
            {
               smBGIntersectionRect = mBGAnimated ? mBGAnimated.getBounds(parent,smBGIntersectionRect) : null;
            }
            else
            {
               smBGIntersectionRect = mBG ? mBG.getBounds(parent,smBGIntersectionRect) : null;
            }
            if(_loc2_ != null)
            {
               for each(_loc4_ in _loc2_)
               {
                  if(_loc4_)
                  {
                     smSocketIntersectionRect = _loc4_.getBounds(parent,smSocketIntersectionRect);
                     if(Boolean(smBGIntersectionRect) && smBGIntersectionRect.intersects(smSocketIntersectionRect))
                     {
                        return true;
                     }
                  }
               }
            }
            if(_loc3_ != null)
            {
               for each(_loc4_ in _loc3_)
               {
                  if(_loc4_)
                  {
                     smSocketIntersectionRect = _loc4_.getBounds(parent,smSocketIntersectionRect);
                     if(Boolean(smBGIntersectionRect) && smBGIntersectionRect.intersects(smSocketIntersectionRect))
                     {
                        return true;
                     }
                  }
               }
            }
         }
         return _loc1_;
      }
      
      private function onPortraitIntersectionFound(param1:UserBattleInfo) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:FSBattleScreen = null;
         var _loc5_:Array = null;
         var _loc6_:Ability = null;
         var _loc2_:Boolean = false;
         if(Config.getConfig().battleShowAbilitiesPanelOnActionUsed())
         {
            mBattleSceneParent.openAbilitiesChooserPanel(this,param1);
            SpecialFX.zoomOut(this);
            _loc2_ = true;
         }
         else
         {
            Utils.removeLog();
            _loc2_ = true;
            if(InstanceMng.getBattleEngine())
            {
               _loc3_ = getCardSummonCost();
               if(InstanceMng.getBattleEngine().canPlayerDoMoreActions(_loc3_))
               {
                  InstanceMng.getBattleEngine().setActionUpgradeCostSelected(_loc3_);
                  _loc4_ = InstanceMng.getBattleEngine().getBattleScreen();
                  if(_loc4_ != null)
                  {
                     touchable = false;
                     _loc5_ = new Array();
                     _loc6_ = getAbilities()[0];
                     if(!InstanceMng.getAbilitiesMng().isTargetSelectionAbility(_loc6_.getAbilityDef()))
                     {
                        _loc5_ = InstanceMng.getAbilitiesMng().getEligibleTargetsByTargetIndex(_loc6_.getAbilityDef(),this,_loc6_.getAbilityDef().getCostRange());
                     }
                     else if(param1 != null)
                     {
                        _loc5_.push(param1);
                     }
                     this.storeActionMovementFromAbilitiesPanel(_loc5_,null,param1,_loc6_.getAbilityDef());
                     _loc6_.onTargetSelected(_loc5_);
                     if(InstanceMng.getCurrentScreen() is FSBattleScreen)
                     {
                        FSBattleScreen(InstanceMng.getCurrentScreen()).setSelectedCard(null);
                     }
                  }
               }
               else
               {
                  if(InstanceMng.getCurrentScreen() != null && InstanceMng.getCurrentScreen() is FSBattleScreen)
                  {
                     FSBattleScreen(InstanceMng.getCurrentScreen()).showNotEnoughAPEffect(this);
                  }
                  unHighlightAllPlayableItems(true);
                  SpecialFX.zoomOut(this);
               }
            }
         }
         return _loc2_;
      }
      
      override protected function showNotAbleToPlaceCardMessage() : void
      {
         Utils.setLogText(TextManager.getText("TID_LOG_SOCKET_ORDER"),true);
         if(Config.getConfig().battleGetVoiceOnError())
         {
            Utils.playSound(Constants.SOUND_INVALID_TARGET,SoundManager.TYPE_SFX);
         }
      }
      
      override public function setAttachedToSocket(param1:FSCardSocket, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false) : void
      {
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
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
               if(mParentUserBattleInfo)
               {
                  mParentUserBattleInfo.removeCardFromPlayableCardsCatalog(this);
               }
            }
            if(mAttachedToSocket != null)
            {
               mAttachedToSocket.setParentCard(null);
            }
         }
         if(!param2)
         {
            if(!param3 && !InstanceMng.getBattleEngine().isPvPMatch())
            {
               this.trackScoreOnActionUsed();
            }
            if(Config.getConfig().hasQuests() && !(this is FSEvent) && !param3)
            {
               InstanceMng.getQuestsMng().onCardPlayed(this);
            }
            this.detachCard();
         }
         mAttachedToSocket = param1;
         if(!param2 && !(this is FSEvent))
         {
            _loc5_ = InstanceMng.getBattleEngine().getActionUpgradeCostSelected();
            InstanceMng.getBattleEngine().notifyActionDone(_loc5_);
            _loc6_ = Config.getConfig().getDefaultDeathAnimDuration();
            TweenMax.delayedCall(_loc6_,SpecialFX.tweenToAlpha,[this,0.001,1,0,this.onActionActivate]);
            if(mShadow != null)
            {
               TweenMax.delayedCall(_loc6_,SpecialFX.tweenToAlpha,[mShadow,0.001,1,0]);
            }
         }
         InstanceMng.getBattleEngine().setActionUpgradeCostSelected(-1);
      }
      
      private function trackScoreOnActionUsed() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = InstanceMng.getBattleEngine().getActionUpgradeCostSelected();
         if(_loc1_ == 1)
         {
            _loc2_ = ScoreMng.PLAY_ORDER_COST_1;
         }
         else if(_loc1_ == 2)
         {
            _loc2_ = ScoreMng.PLAY_ORDER_COST_2;
         }
         else if(_loc1_ == 3)
         {
            _loc2_ = ScoreMng.PLAY_ORDER_COST_3;
         }
         InstanceMng.getScoreMng().trackAction(_loc2_);
         InstanceMng.getTargetMng().addCardPlayed(this);
      }
      
      override protected function isCardSocketRectification() : Boolean
      {
         return false;
      }
      
      private function onActionActivate() : void
      {
         removeCardElemsFromDisplayList();
         removeEventListeners();
      }
      
      override public function onCardDefeated() : void
      {
      }
      
      override public function detachCard(param1:Boolean = false) : void
      {
         if(mAttachedToSocket != null)
         {
            mAttachedToSocket.setParentCard(null);
         }
         if(mParentUserBattleInfo)
         {
            mParentUserBattleInfo.addCardToGraveyard(this);
         }
         mAttachedToSocket = null;
         var _loc2_:Boolean = false;
         if(mIsOnBattlefield)
         {
            _loc2_ = setIsOnBattlefield(false,isEnemyCard());
         }
         if(!param1 && !Config.getConfig().gameHasGraveyard())
         {
            if(mParentUserBattleInfo)
            {
               mParentUserBattleInfo.addCardSkuToCatalogs(getCardDef().getSku(),1);
               if(_loc2_)
               {
                  updateAbilitiesAppliedOnNextCard();
               }
            }
         }
      }
      
      override public function highlightPlayableSocketsVector(param1:Boolean = false, param2:Ability = null) : void
      {
         var _loc3_:Ability = null;
         super.highlightPlayableSocketsVector(param1,param2);
         var _loc4_:int = 0;
         for each(_loc3_ in mAbilities)
         {
            if(_loc4_ == 0)
            {
               _loc3_.highlightPossibleTargetsForAbility();
               _loc3_.showLogMessageForTargetSelectionAbility(false);
            }
            _loc4_++;
         }
         if(param1 && param2 != null)
         {
            param2.onPlayableItemsHighlighted();
         }
      }
      
      public function has0CostTargetSelectionAbsWithPlayableTargets() : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Ability = null;
         var _loc1_:Boolean = false;
         var _loc2_:Vector.<Ability> = getCompositeAbilitiesVector();
         if(_loc2_)
         {
            _loc3_ = int(_loc2_.length);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc5_ = _loc2_[_loc4_];
               if(_loc5_.canBeExecutedAndHasTargets())
               {
                  if(Boolean(mParentUserBattleInfo) && mParentUserBattleInfo.getActionCostForAbsPanel(this,ActionDef(mCardDef),_loc5_.getAbilityDef()) == 0)
                  {
                     return true;
                  }
               }
               _loc4_++;
            }
         }
         return _loc1_;
      }
      
      public function hasPlayableItems() : Boolean
      {
         var _loc1_:Boolean = false;
         this.highlightPlayableSocketsVector();
         return mPlayableBFPortraits != null && mPlayableBFPortraits.length > 0 || mPlayableSockets != null && mPlayableSockets.length > 0;
      }
      
      override public function setZoomedIn(param1:Boolean) : void
      {
         if(param1)
         {
            FSDebug.debugTrace("zooming in");
            InstanceMng.getBattleEngine().setActionUpgradeCostSelected(-1);
            InstanceMng.getBattleEngine().resetUILock();
         }
         else
         {
            FSDebug.debugTrace("zooming out");
         }
         mZoomedIn = param1;
      }
      
      override public function showDamageAndShield(param1:Boolean = false) : void
      {
      }
      
      override protected function showUpgradeCost(param1:int = -1) : void
      {
      }
   }
}

