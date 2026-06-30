package com.fs.tcgengine.view.cards
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.AbilitiesMng;
   import com.fs.tcgengine.controller.SubCategoriesMng;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.board.card.Ability;
   import com.fs.tcgengine.model.rules.AbilityDef;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.SubCategoryDef;
   import com.fs.tcgengine.model.rules.UnitDef;
   import com.fs.tcgengine.particles.TextParticlesMng;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.socket.FSCardSocket;
   import com.greensock.TweenMax;
   import flash.utils.Dictionary;
   import starling.core.Starling;
   import starling.display.MovieClip;
   import starling.utils.Align;
   
   public class FSUnit extends FSCard
   {
      
      private var mAttachments:Vector.<FSAttachment>;
      
      private var mTurnsToBeAbleToAttack:int = 0;
      
      private var mLockingAbilityIconOnCard:FSImage;
      
      private var mLockingAbilityMcOnCard:MovieClip;
      
      private var mTurnsInvulnerable:int = 0;
      
      private var mInvulnerableIcon:FSImage;
      
      private var mInvulnerableMC:MovieClip;
      
      private var mTurnsUnblockable:int = 0;
      
      private var mUnblockableImage:FSImage;
      
      private var mCodeInterceptionImage:FSImage;
      
      private var mTacticalMasterImage:FSImage;
      
      private var mTurnsAmountWithoutMovingToAttackLane:int = 0;
      
      private var mTurnsPoison:int = 0;
      
      private var mPoisonDamage:int = 0;
      
      private var mPoisonIcon:FSImage;
      
      public function FSUnit(param1:String)
      {
         super(param1);
      }
      
      override public function reset(param1:String = "") : void
      {
         super.reset(param1);
         if(Config.USE_CARD_POOLING)
         {
            this.mTurnsToBeAbleToAttack = 0;
            this.mTurnsInvulnerable = 0;
            this.mTurnsUnblockable = 0;
            this.mTurnsAmountWithoutMovingToAttackLane = 0;
            this.mTurnsPoison = 0;
            this.mPoisonDamage = 0;
            if(this.mLockingAbilityIconOnCard)
            {
               this.mLockingAbilityIconOnCard.reset();
            }
            if(this.mUnblockableImage)
            {
               this.mUnblockableImage.reset();
            }
            if(this.mCodeInterceptionImage)
            {
               this.mCodeInterceptionImage.reset();
            }
            if(this.mTacticalMasterImage)
            {
               this.mTacticalMasterImage.reset();
            }
            if(this.mPoisonIcon)
            {
               this.mPoisonIcon.reset();
            }
            if(this.mInvulnerableIcon)
            {
               this.mInvulnerableIcon.reset();
            }
            if(this.mInvulnerableMC)
            {
               this.mInvulnerableMC.stop();
               this.mInvulnerableMC.removeFromParent();
            }
            if(this.mLockingAbilityMcOnCard)
            {
               this.mLockingAbilityMcOnCard.stop();
               this.mLockingAbilityMcOnCard.removeFromParent();
            }
            if(this.mAttachments)
            {
               this.mAttachments.length = 0;
            }
         }
      }
      
      override protected function initializeCard(param1:CardDef, param2:Boolean = false) : void
      {
         super.initializeCard(param1,param2);
         if(param2 && this.mAttachments != null)
         {
            this.updateAttachmentsWithCurrentTier();
            this.setDefense(this.getUpdatedCompositeDefense());
            refreshUnitStatsAfterAttachment();
         }
      }
      
      public function addAttachment(param1:FSAttachment) : void
      {
         if(this.mAttachments == null)
         {
            this.mAttachments = new Vector.<FSAttachment>();
         }
         this.mAttachments.push(param1);
         this.onAttachmentAttached(param1);
      }
      
      public function removeAllAttachments() : void
      {
         var _loc1_:int = 0;
         var _loc2_:FSAttachment = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:FSAttachment = null;
         if(this.mAttachments != null)
         {
            _loc3_ = this.getDefenseGainedByAttachments();
            if(this.mAttachments != null)
            {
               for each(_loc5_ in this.mAttachments)
               {
                  this.removeAttachmentAbilitiesEffects(_loc5_);
                  _loc5_.detachCard();
               }
            }
            this.mAttachments.length = 0;
            _loc4_ = getDefense() - _loc3_ > 0 ? int(getDefense() - _loc3_) : 0;
            updateStatsAfterAttack(_loc4_);
            refreshUnitStatsAfterAttachment(false);
         }
      }
      
      private function removeAttachmentAbilitiesEffects(param1:FSAttachment) : void
      {
         var _loc2_:Vector.<Ability> = null;
         var _loc3_:Ability = null;
         var _loc4_:String = null;
         if(param1)
         {
            _loc2_ = param1.getCompositeAbilitiesVector();
            if(_loc2_)
            {
               for each(_loc3_ in _loc2_)
               {
                  if(!_loc3_)
                  {
                     continue;
                  }
                  _loc4_ = _loc3_.getAbilityDef().getKeyName();
                  switch(_loc4_)
                  {
                     case AbilitiesMng.SPECIAL_PERMANENTUNBLOCKABLE:
                        this.setUnblockableTurns(0);
                        break;
                     case AbilitiesMng.SPECIAL_RISING:
                        this.setInvulnerableTurns(0);
                        break;
                     case AbilitiesMng.SPECIAL_POISON:
                        this.setPoisonTurns(0);
                  }
               }
            }
         }
      }
      
      public function removeUniqueAttachment(param1:FSAttachment) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:FSAttachment = null;
         var _loc5_:int = 0;
         if(this.mAttachments != null)
         {
            _loc3_ = this.getDefenseGainedByAttachment(param1);
            _loc2_ = 0;
            while(_loc2_ < this.mAttachments.length)
            {
               _loc4_ = this.mAttachments[_loc2_];
               if(_loc4_ == param1)
               {
                  param1.detachCard();
                  this.mAttachments.splice(_loc2_,1);
               }
               _loc2_++;
            }
            _loc5_ = getDefense() - _loc3_ > 0 ? int(getDefense() - _loc3_) : 0;
            updateStatsAfterAttack(_loc5_);
            refreshUnitStatsAfterAttachment(false);
         }
      }
      
      private function updateAttachmentsWithCurrentTier() : void
      {
         var _loc1_:int = 0;
         var _loc2_:FSAttachment = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(this.mAttachments != null)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mAttachments.length)
            {
               _loc2_ = this.mAttachments[_loc1_];
               _loc3_ = mCardDef.getTier();
               _loc4_ = _loc2_.getCardDef().getTier();
               _loc5_ = _loc3_ - _loc4_;
               if(_loc5_ == 1)
               {
                  _loc2_.promoteCard(Utils.getNextTierCardDef(_loc2_.getCardDef().getSku()).getSku());
               }
               else if(_loc5_ == 2)
               {
                  _loc2_.promoteCard(Utils.getTopTierCardDef(_loc2_.getCardDef().getSku()).getSku());
               }
               else if(_loc5_ == -1)
               {
                  _loc2_.promoteCard(Utils.getPreviousTierCardDef(_loc2_.getCardDef().getSku()).getSku());
               }
               else if(_loc5_ == -2)
               {
                  _loc2_.promoteCard(Utils.getBaseTierCardDef(_loc2_.getCardDef().getSku()).getSku());
               }
               _loc1_++;
            }
         }
      }
      
      private function onAttachmentAttached(param1:FSAttachment) : void
      {
         this.setDefense(this.getUpdatedCompositeDefense(true,param1));
         refreshUnitStatsAfterAttachment();
      }
      
      override public function createAbilitiesIcons(param1:int = 0) : void
      {
         var _loc2_:AbilityDef = null;
         var _loc3_:FSImage = null;
         var _loc4_:Array = null;
         var _loc5_:Vector.<AbilityDef> = null;
         var _loc6_:String = null;
         var _loc7_:Boolean = false;
         if(mCardDef != null)
         {
            _loc4_ = mCardDef.getAbilities();
            _loc5_ = this.getUsableAbilitiesDefsFromAttachments();
            if(_loc5_ != null)
            {
               for each(_loc2_ in _loc5_)
               {
                  if(_loc2_.isIconVisible() && this.isAllowedToCreateAbilityIcon(_loc2_))
                  {
                     _loc7_ = InstanceMng.getCardsMng().createAbilityIcon(this,_loc2_,param1,true);
                     param1 += _loc7_ ? 1 : 0;
                  }
               }
            }
            super.createAbilitiesIcons(param1);
            if(isOnBF())
            {
               createZoomIconInCombat();
            }
         }
      }
      
      override protected function isAllowedToCreateAbilityIcon(param1:AbilityDef) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:FSAttachment = null;
         var _loc5_:Vector.<Ability> = null;
         var _loc2_:Boolean = false;
         if(checkIfAbilityIsAvailable(param1,mAbilities))
         {
            return true;
         }
         if(this.hasAttachments())
         {
            for each(_loc4_ in this.mAttachments)
            {
               _loc5_ = _loc4_.getAbilities();
               if(checkIfAbilityIsAvailable(param1,_loc5_))
               {
                  return true;
               }
            }
         }
         return _loc2_;
      }
      
      override public function getUsableAbilitiesFromAttachments() : Vector.<Ability>
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:Vector.<Ability> = null;
         var _loc2_:FSAttachment = null;
         var _loc3_:Vector.<Ability> = null;
         var _loc6_:Boolean = false;
         if(this.mAttachments != null)
         {
            _loc5_ = 0;
            while(_loc5_ < this.mAttachments.length)
            {
               _loc2_ = this.mAttachments[_loc5_];
               _loc3_ = _loc2_.getAbilities();
               if(_loc3_ != null)
               {
                  _loc4_ = 0;
                  while(_loc4_ < _loc3_.length)
                  {
                     _loc6_ = this.checkIfAbilityExistsInVector(Ability(_loc3_[_loc4_]),_loc1_);
                     if(mAbilities != null)
                     {
                        _loc6_ ||= this.checkIfAbilityExistsInVector(Ability(_loc3_[_loc4_]),mAbilities);
                     }
                     if(!_loc6_)
                     {
                        if(_loc1_ == null)
                        {
                           _loc1_ = new Vector.<Ability>();
                        }
                        _loc1_.push(_loc3_[_loc4_]);
                     }
                     _loc4_++;
                  }
               }
               _loc5_++;
            }
            return _loc1_;
         }
         return null;
      }
      
      override public function getUsableAbilitiesDefsFromAttachments() : Vector.<AbilityDef>
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc8_:Vector.<AbilityDef> = null;
         var _loc9_:AbilityDef = null;
         var _loc1_:Vector.<AbilityDef> = null;
         var _loc2_:FSAttachment = null;
         var _loc3_:Array = null;
         var _loc6_:Boolean = false;
         var _loc7_:Array = mCardDef.getAbilities();
         if((Boolean(_loc7_)) && _loc7_.length > 0)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc7_.length)
            {
               if(_loc8_ == null)
               {
                  _loc8_ = new Vector.<AbilityDef>();
               }
               _loc8_.push(InstanceMng.getAbilitiesDefMng().getDefBySku(_loc7_[_loc4_]));
               _loc4_++;
            }
         }
         if(this.mAttachments != null)
         {
            _loc5_ = 0;
            while(_loc5_ < this.mAttachments.length)
            {
               _loc2_ = this.mAttachments[_loc5_];
               _loc3_ = _loc2_.getCardDef().getAbilities();
               if(_loc3_ != null)
               {
                  _loc4_ = 0;
                  while(_loc4_ < _loc3_.length)
                  {
                     _loc9_ = AbilityDef(InstanceMng.getAbilitiesDefMng().getDefBySku(_loc3_[_loc4_]));
                     _loc6_ = this.checkIfAbilityDefExistsInVector(_loc9_,_loc1_);
                     if(_loc8_ != null)
                     {
                        _loc6_ ||= this.checkIfAbilityDefExistsInVector(_loc9_,_loc8_);
                     }
                     if(!_loc6_)
                     {
                        if(_loc1_ == null)
                        {
                           _loc1_ = new Vector.<AbilityDef>();
                        }
                        _loc1_.push(_loc9_);
                     }
                     _loc4_++;
                  }
               }
               _loc5_++;
            }
            return _loc1_;
         }
         return null;
      }
      
      private function checkIfAbilityExistsInVector(param1:Ability, param2:Vector.<Ability>) : Boolean
      {
         var _loc4_:int = 0;
         var _loc3_:Boolean = false;
         if(param1 != null && param2 != null)
         {
            _loc4_ = 0;
            while(_loc4_ < param2.length)
            {
               if(param1.getAbilityDef().getSku() == Ability(param2[_loc4_]).getAbilityDef().getSku())
               {
                  _loc3_ = true;
                  break;
               }
               _loc4_++;
            }
         }
         return _loc3_;
      }
      
      private function checkIfAbilityDefExistsInVector(param1:AbilityDef, param2:Vector.<AbilityDef>) : Boolean
      {
         var _loc4_:int = 0;
         var _loc3_:Boolean = false;
         if(param1 != null && param2 != null)
         {
            _loc4_ = 0;
            while(_loc4_ < param2.length)
            {
               if(param1.getSku() == AbilityDef(param2[_loc4_]).getSku())
               {
                  _loc3_ = true;
                  break;
               }
               _loc4_++;
            }
         }
         return _loc3_;
      }
      
      override public function isCardAttachableToSocket(param1:FSCardSocket, param2:Boolean = false) : Boolean
      {
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc3_:Boolean = false;
         if(param1.isEmpty())
         {
            _loc4_ = UnitDef(mCardDef).getBeginsOnAttackLane();
            _loc5_ = this.abilityAllowsMovement(param1);
            _loc6_ = mTurnsAlive == 0 && (param1.isSupportSocket() || _loc4_);
            _loc6_ = (_loc6_) || _loc5_;
            if(_loc6_)
            {
               return true;
            }
         }
         return _loc3_;
      }
      
      public function canAttackFromCurrentPosition() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = isOnSupportLane() && InstanceMng.getBattleEngine().getLevelDef().getRowsAmount() == 1;
         var _loc3_:Boolean = this.getTurnsToBeAbleToAttack() == 0;
         var _loc4_:Boolean = this.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_FORTIFICATION) != null;
         return (_loc2_ || !isOnSupportLane() || this.isArtillery()) && !isOnSummonCooldown() && _loc3_ && !_loc4_;
      }
      
      public function isArtillery() : Boolean
      {
         return this.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_ARTILLERY) != null;
      }
      
      override protected function isCardSocketRectification() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = this.abilityAllowsMovement();
         _loc1_ = mIsOnBattlefield && mTurnsAlive == 0;
         if(mIsOnBattlefield)
         {
            _loc1_ ||= _loc2_;
         }
         return _loc1_;
      }
      
      override public function setAttachedToSocket(param1:FSCardSocket, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false) : void
      {
         super.setAttachedToSocket(param1,param2,param3,param4);
         this.updateAttachmentsAttachedToSocketValue();
      }
      
      private function updateAttachmentsAttachedToSocketValue() : void
      {
         var _loc1_:FSAttachment = null;
         if(this.mAttachments != null)
         {
            for each(_loc1_ in this.mAttachments)
            {
               _loc1_.mAttachedToSocket = mAttachedToSocket;
            }
         }
      }
      
      public function performAttackToSupportMovement() : void
      {
         var _loc1_:FSCardSocket = null;
         var _loc2_:FSCoordinate = null;
         if(isMovableFromAttackLaneToSupportLane())
         {
            _loc1_ = getEmptySupportSocketForAttackCard();
            this.setAttachedToSocket(_loc1_,true,false,true);
            _loc2_ = _loc1_.getVisualComponentCoords();
            SpecialFX.createTransition(this,_loc2_);
            if(getCardDropShadow())
            {
               SpecialFX.createTransition(getCardDropShadow(),_loc2_,Config.getConfig().getDefaultZoomOutTime(),0);
            }
         }
         this.mTurnsAmountWithoutMovingToAttackLane += 1;
      }
      
      override public function getAttachments() : Vector.<FSAttachment>
      {
         return this.mAttachments;
      }
      
      public function getTurnsToBeAbleToAttack() : int
      {
         return this.mTurnsToBeAbleToAttack;
      }
      
      public function setTurnsToBeAbleToAttack(param1:int) : void
      {
         this.mTurnsToBeAbleToAttack = param1;
         if(this.mTurnsToBeAbleToAttack == 0)
         {
            if(this.mLockingAbilityIconOnCard != null)
            {
               SpecialFX.tweenToAlpha(this.mLockingAbilityIconOnCard,0.001,2.5,0,this.onLockingAbilityIconFaded);
            }
            removeCardAnimsByAbility(AbilitiesMng.SPECIAL_CAPTURED);
         }
      }
      
      private function onLockingAbilityIconFaded() : void
      {
         if(this.mLockingAbilityIconOnCard)
         {
            this.mLockingAbilityIconOnCard.removeFromParent();
            this.mLockingAbilityIconOnCard.destroy();
            TweenMax.killTweensOf(this.mLockingAbilityIconOnCard);
         }
         this.mLockingAbilityIconOnCard = null;
      }
      
      public function getLockingAbilityIconOnCard() : FSImage
      {
         return this.mLockingAbilityIconOnCard;
      }
      
      public function setLockingAbilityIconOnCard(param1:FSImage) : void
      {
         if(this.mLockingAbilityIconOnCard)
         {
            this.mLockingAbilityIconOnCard.removeFromParent();
            TweenMax.killTweensOf(this.mLockingAbilityIconOnCard);
         }
         this.mLockingAbilityIconOnCard = param1;
      }
      
      override public function setDefense(param1:int, param2:Boolean = false) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Vector.<Ability> = null;
         if(!isDefeated() || param2)
         {
            if(param1 == 0)
            {
               mDefeated = true;
               setDieOnEndTurn(true);
               if(isEnemyCard())
               {
                  InstanceMng.getTargetMng().addCardKilled(this);
                  InstanceMng.getBattleEngine().onOpponentCardDefeatedTrackScore(this);
                  if(Config.getConfig().hasQuests())
                  {
                     InstanceMng.getQuestsMng().onCardDefeated(this);
                  }
               }
               else
               {
                  InstanceMng.getBattleEngine().increaseOwnCardsDefeated();
               }
               _loc3_ = mFightingWithCard != null ? calculateTimeEllapsedForTriggeringAbilities() : 0;
               FSDebug.debugTrace("ON DEFEAT (Abs time remaining: " + _loc3_ + ")");
               TweenMax.delayedCall(Config.getConfig().getDefaultDeathAnimDuration() + _loc3_,this.onCardDefeated);
               _loc4_ = this.getAbilitiesWithPermanentEffect();
               if((Boolean(_loc4_)) && Boolean(InstanceMng.getBattleEngine()))
               {
                  InstanceMng.getBattleEngine().removePermanentEffectFromAbility(_loc4_);
               }
            }
         }
         super.setDefense(param1,param2);
      }
      
      private function getAbilitiesWithPermanentEffect() : Vector.<Ability>
      {
         var _loc3_:Ability = null;
         var _loc1_:Vector.<Ability> = getCompositeAbilitiesVector();
         var _loc2_:Vector.<Ability> = null;
         if(Boolean(_loc1_) && _loc1_.length > 0)
         {
            for each(_loc3_ in _loc1_)
            {
               if(_loc3_.getAbilityDef().getDuration() == -2)
               {
                  if(_loc2_ == null)
                  {
                     _loc2_ = new Vector.<Ability>();
                  }
                  _loc2_.push(_loc3_);
               }
            }
         }
         return _loc2_;
      }
      
      override public function isAlive() : Boolean
      {
         return Boolean(super.isAlive()) && !mDieOnEndTurn;
      }
      
      override public function increaseTurnsAlive() : void
      {
         var _loc1_:FSAttachment = null;
         super.increaseTurnsAlive();
         if(this.mAttachments != null)
         {
            for each(_loc1_ in this.mAttachments)
            {
               _loc1_.increaseTurnsAlive();
            }
         }
      }
      
      public function getInvulnerableTurns() : int
      {
         return this.mTurnsInvulnerable;
      }
      
      public function setInvulnerableTurns(param1:int) : void
      {
         this.mTurnsInvulnerable = param1;
         if(this.mTurnsInvulnerable == 0)
         {
            if(this.mInvulnerableIcon != null)
            {
               SpecialFX.tweenToAlpha(this.mInvulnerableIcon,0.001,2.5,0,this.onInvulnerabilityIconFaded);
            }
            removeCardAnimsByAbility(AbilitiesMng.SPECIAL_MASSRISING);
            removeCardAnimsByAbility(AbilitiesMng.SPECIAL_RISING);
         }
      }
      
      private function onInvulnerabilityIconFaded() : void
      {
         if(this.mInvulnerableIcon)
         {
            this.mInvulnerableIcon.removeFromParent();
            this.mInvulnerableIcon.destroy();
            TweenMax.killTweensOf(this.mInvulnerableIcon);
         }
         this.mInvulnerableIcon = null;
      }
      
      public function setInvulnerableIcon(param1:FSImage) : void
      {
         if(this.mInvulnerableIcon)
         {
            this.mInvulnerableIcon.removeFromParent();
            TweenMax.killTweensOf(this.mInvulnerableIcon);
         }
         this.mInvulnerableIcon = param1;
      }
      
      public function getUnblockableTurns() : int
      {
         return this.mTurnsUnblockable;
      }
      
      public function setUnblockableTurns(param1:int) : void
      {
         this.mTurnsUnblockable = param1;
         if(this.mTurnsUnblockable == 0 || this.mTurnsUnblockable == -1)
         {
            if(this.mUnblockableImage != null)
            {
               SpecialFX.tweenToAlpha(this.mUnblockableImage,0.001,2.5,0,this.onUnblockableIconFaded);
            }
         }
      }
      
      private function onUnblockableIconFaded() : void
      {
         if(this.mUnblockableImage)
         {
            this.mUnblockableImage.removeFromParent();
            this.mUnblockableImage.destroy();
            TweenMax.killTweensOf(this.mUnblockableImage);
         }
         this.mUnblockableImage = null;
      }
      
      public function setUnblockableIcon(param1:FSImage) : void
      {
         if(this.mUnblockableImage)
         {
            this.mUnblockableImage.removeFromParent();
            TweenMax.killTweensOf(this.mUnblockableImage);
         }
         this.mUnblockableImage = param1;
      }
      
      public function getUnblockableIcon() : FSImage
      {
         return this.mUnblockableImage;
      }
      
      public function setCodeInterceptionIcon(param1:FSImage) : void
      {
         if(this.mCodeInterceptionImage)
         {
            this.mCodeInterceptionImage.removeFromParent();
            TweenMax.killTweensOf(this.mCodeInterceptionImage);
         }
         this.mCodeInterceptionImage = param1;
      }
      
      public function setTacticalMasterIcon(param1:FSImage) : void
      {
         if(this.mTacticalMasterImage)
         {
            this.mTacticalMasterImage.removeFromParent();
            TweenMax.killTweensOf(this.mTacticalMasterImage);
         }
         this.mTacticalMasterImage = param1;
      }
      
      public function getPoisonTurns() : int
      {
         return this.mTurnsPoison;
      }
      
      public function setPoisonTurns(param1:int) : void
      {
         if(this.mTurnsPoison == 1 && param1 == 0)
         {
            removeCardAnimsByAbility(AbilitiesMng.SPECIAL_POISON,true);
         }
         this.mTurnsPoison = param1;
         if(this.mTurnsPoison == 0)
         {
            if(this.mPoisonIcon != null)
            {
               SpecialFX.tweenToAlpha(this.mPoisonIcon,0.001,2.5,0,this.onPoisonIconFaded);
            }
         }
      }
      
      public function updatePoisonTurns() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = this.getPoisonTurns();
         _loc2_ = _loc1_ > 0 ? int(_loc1_ - 1) : 0;
         this.setPoisonTurns(_loc2_);
      }
      
      public function setPoisonDamage(param1:int) : void
      {
         this.mPoisonDamage = param1;
      }
      
      public function getPoisonDamage() : int
      {
         return this.mPoisonDamage;
      }
      
      private function onPoisonIconFaded() : void
      {
         if(this.mPoisonIcon)
         {
            this.mPoisonIcon.removeFromParent();
            this.mPoisonIcon.destroy();
            TweenMax.killTweensOf(this.mPoisonIcon);
         }
         this.mPoisonIcon = null;
         this.mPoisonDamage = 0;
      }
      
      public function setPoisonIcon(param1:FSImage) : void
      {
         if(this.mPoisonIcon)
         {
            this.mPoisonIcon.removeFromParent();
            TweenMax.killTweensOf(this.mPoisonIcon);
         }
         this.mPoisonIcon = param1;
      }
      
      public function takeDOTDamage() : void
      {
         addDefense(this.mPoisonDamage);
         InstanceMng.getTextParticlesMng().showTextParticle(this.mPoisonDamage.toString(),TextParticlesMng.COLOR_DAMAGE_RECEIVED_ABILITY,this,-1,Align.RIGHT);
         InstanceMng.getCardAnimsMng().requestDebuffAnimation(this);
         updateStatsAfterAttack(getDefense());
      }
      
      public function getUpdatedCompositeDefense(param1:Boolean = false, param2:FSAttachment = null) : int
      {
         var _loc3_:int = 0;
         if(param1)
         {
            _loc3_ = getDefense() + param2.getDefense();
         }
         else
         {
            _loc3_ = this.getDefenseGainedByAttachments();
            _loc3_ += mCardDef.getDefense();
         }
         return _loc3_;
      }
      
      public function getDefenseGainedByAttachments() : int
      {
         var _loc2_:FSAttachment = null;
         var _loc1_:int = 0;
         if(this.mAttachments != null)
         {
            for each(_loc2_ in this.mAttachments)
            {
               _loc1_ += _loc2_.getDefense();
            }
         }
         return _loc1_;
      }
      
      public function getDefenseGainedByAttachment(param1:FSAttachment) : int
      {
         var _loc3_:FSAttachment = null;
         var _loc2_:int = 0;
         if(this.mAttachments != null)
         {
            for each(_loc3_ in this.mAttachments)
            {
               if(_loc3_ == param1)
               {
                  _loc2_ += _loc3_.getDefense();
               }
            }
         }
         return _loc2_;
      }
      
      override public function getDamage() : int
      {
         var _loc2_:FSAttachment = null;
         var _loc1_:FSNumber = new FSNumber();
         _loc1_.value = mDamage ? mDamage.value : 0;
         if(this.mAttachments != null)
         {
            for each(_loc2_ in this.mAttachments)
            {
               _loc1_.value += _loc2_.getDamage();
            }
         }
         return _loc1_.value;
      }
      
      override public function getAttachmentsAmount() : int
      {
         var _loc1_:int = 0;
         if(this.mAttachments != null)
         {
            _loc1_ = int(this.mAttachments.length);
         }
         return _loc1_;
      }
      
      override public function onCardDefeated() : void
      {
         var _loc1_:FSAttachment = null;
         super.onCardDefeated();
         if(this.mAttachments != null)
         {
            for each(_loc1_ in this.mAttachments)
            {
               _loc1_.detachCard();
            }
         }
      }
      
      override public function revertCardToActionDeck() : void
      {
         var _loc1_:FSAttachment = null;
         super.revertCardToActionDeck();
         if(this.mAttachments != null)
         {
            for each(_loc1_ in this.mAttachments)
            {
               _loc1_.revertCardToActionDeck();
            }
         }
         if(!Config.getConfig().gameHasTierFrames())
         {
            this.onCardReturnedToActionDeckEnableFramesBack();
         }
      }
      
      private function onCardReturnedToActionDeckEnableFramesBack() : void
      {
         if(mFrameBG)
         {
            mFrameBG.visible = true;
            mFrameBG.alpha = 0.999;
         }
         if(mFactionFrameBG)
         {
            mFactionFrameBG.visible = true;
            mFactionFrameBG.alpha = 0.999;
         }
         if(mBottomFrameBG)
         {
            mBottomFrameBG.visible = true;
            mBottomFrameBG.alpha = 0.999;
         }
         if(mTierFrame)
         {
            mTierFrame.visible = true;
            mTierFrame.alpha = 0.999;
         }
      }
      
      public function hasAttachment(param1:String) : Boolean
      {
         var _loc4_:FSAttachment = null;
         var _loc2_:Boolean = false;
         var _loc3_:CardDef = CardDef(InstanceMng.getCardsDefMng().getDefBySku(param1));
         if(this.mAttachments != null && _loc3_ != null)
         {
            for each(_loc4_ in this.mAttachments)
            {
               if(_loc4_.getCardDef().getSku() == param1 || _loc4_.getCardDef().getFamilyId() == _loc3_.getFamilyId())
               {
                  _loc2_ = true;
                  break;
               }
            }
         }
         return _loc2_;
      }
      
      public function hasAttachments() : Boolean
      {
         return this.mAttachments != null && this.mAttachments.length > 0;
      }
      
      override protected function canCardBeMoved() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = UnitDef(mCardDef).getBeginsOnAttackLane();
         var _loc3_:Boolean = this.abilityAllowsMovement();
         _loc1_ = !mIsOnBattlefield || mIsOnBattlefield && (isOnSupportLane() || _loc2_) && mTurnsAlive == 0;
         return _loc1_ || _loc3_;
      }
      
      override public function abilityAllowsMovement(param1:FSCardSocket = null) : Boolean
      {
         var _loc3_:FSAttachment = null;
         var _loc2_:Boolean = false;
         _loc2_ = super.abilityAllowsMovement(param1);
         if(!_loc2_)
         {
            for each(_loc3_ in this.mAttachments)
            {
               if(_loc3_.abilityAllowsMovement(param1))
               {
                  return true;
               }
            }
         }
         return _loc2_;
      }
      
      override public function abilityAllowsMovingToAttackLane() : Boolean
      {
         var _loc2_:FSAttachment = null;
         var _loc1_:Boolean = false;
         _loc1_ = super.abilityAllowsMovingToAttackLane();
         if(!_loc1_)
         {
            for each(_loc2_ in this.mAttachments)
            {
               if(_loc2_.abilityAllowsMovingToAttackLane())
               {
                  return true;
               }
            }
         }
         return _loc1_;
      }
      
      public function isAirUnit() : Boolean
      {
         var _loc2_:Array = null;
         var _loc3_:SubCategoryDef = null;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc1_:Boolean = false;
         if(mCardDef)
         {
            _loc2_ = mCardDef.getSubCategorySku();
            _loc5_ = false;
            _loc6_ = this.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_FLIGHT) != null;
            if(_loc2_)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc2_.length)
               {
                  _loc3_ = SubCategoryDef(InstanceMng.getSubCategoriesDefMng().getDefBySku(_loc2_[_loc4_]));
                  if(Boolean(_loc3_) && Boolean(_loc3_.getIndex() == SubCategoriesMng.SUBCATEGORY_03) && _loc6_)
                  {
                     _loc1_ = _loc5_ = true;
                     break;
                  }
                  _loc4_++;
               }
               if(!_loc5_)
               {
                  _loc1_ = _loc6_;
               }
            }
         }
         return _loc1_;
      }
      
      public function isSubmarineUnit() : Boolean
      {
         var _loc2_:Array = null;
         var _loc3_:SubCategoryDef = null;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc1_:Boolean = false;
         if(mCardDef)
         {
            _loc2_ = mCardDef.getSubCategorySku();
            _loc5_ = false;
            _loc6_ = this.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_SUBMARINE) != null;
            if(_loc2_)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc2_.length)
               {
                  _loc3_ = SubCategoryDef(InstanceMng.getSubCategoriesDefMng().getDefBySku(_loc2_[_loc4_]));
                  if(Boolean(_loc3_) && Boolean(_loc3_.getIndex() == SubCategoriesMng.SUBCATEGORY_04) && _loc6_)
                  {
                     _loc1_ = _loc5_ = true;
                     break;
                  }
                  _loc4_++;
               }
               if(!_loc5_)
               {
                  _loc1_ = _loc6_;
               }
            }
         }
         return _loc1_;
      }
      
      public function isUnblockable() : Boolean
      {
         var _loc1_:Boolean = this.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_PERMANENTUNBLOCKABLE) != null;
         return this.mTurnsUnblockable > 0 || this.mTurnsUnblockable == -1 || _loc1_;
      }
      
      override public function highlightPlayableSocketsVector(param1:Boolean = false, param2:Ability = null) : void
      {
         var _loc4_:Boolean = false;
         var _loc5_:Dictionary = null;
         var _loc6_:FSCardSocket = null;
         var _loc7_:Boolean = false;
         super.highlightPlayableSocketsVector(param1,param2);
         var _loc3_:BattleEngine = InstanceMng.getBattleEngine();
         if(Boolean(_loc3_) && Boolean(mBattleSceneParent))
         {
            _loc4_ = _loc3_.isOwnerTurn();
            _loc5_ = _loc4_ ? mBattleSceneParent.getOwnerBFSocketCatalog() : mBattleSceneParent.getOpponentBFSocketCatalog();
            _loc7_ = UnitDef(mCardDef).getBeginsOnAttackLane();
            if(_loc5_)
            {
               for each(_loc6_ in _loc5_)
               {
                  if(this.isCardAttachableToSocket(_loc6_))
                  {
                     addCardSocketToPlayableSocketsVector(_loc6_);
                  }
               }
               for each(_loc6_ in mPlayableSockets)
               {
                  _loc6_.activateHighlightTween();
               }
            }
         }
      }
      
      public function hasPlayableSockets() : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:Dictionary = null;
         var _loc5_:FSCardSocket = null;
         var _loc6_:Boolean = false;
         var _loc1_:Boolean = false;
         var _loc2_:BattleEngine = InstanceMng.getBattleEngine();
         if(Boolean(_loc2_) && Boolean(mBattleSceneParent))
         {
            _loc3_ = _loc2_.isOwnerTurn();
            _loc4_ = _loc3_ ? mBattleSceneParent.getOwnerBFSocketCatalog() : mBattleSceneParent.getOpponentBFSocketCatalog();
            _loc6_ = UnitDef(mCardDef).getBeginsOnAttackLane();
            if(_loc4_)
            {
               for each(_loc5_ in _loc4_)
               {
                  if(this.isCardAttachableToSocket(_loc5_))
                  {
                     return true;
                  }
               }
            }
         }
         return _loc1_;
      }
      
      override public function getAbilityDefByKeyName(param1:String) : AbilityDef
      {
         var _loc6_:FSAttachment = null;
         var _loc7_:Ability = null;
         var _loc8_:Vector.<Ability> = null;
         var _loc9_:AbilityDef = null;
         var _loc2_:AbilityDef = super.getAbilityDefByKeyName(param1);
         var _loc3_:Boolean = param1 == AbilitiesMng.SPECIAL_REINFORCED;
         var _loc4_:Array = new Array();
         if(_loc2_ != null)
         {
            _loc4_.push(_loc2_);
         }
         var _loc5_:AbilityDef = _loc2_;
         if(this.mAttachments != null)
         {
            for each(_loc6_ in this.mAttachments)
            {
               _loc8_ = _loc6_.getAbilities();
               for each(_loc7_ in _loc8_)
               {
                  _loc9_ = _loc7_.getAbilityDef();
                  if(_loc9_ != null)
                  {
                     if(_loc9_.isSpecial())
                     {
                        if(_loc9_.getKeyName() == param1)
                        {
                           if(!_loc3_)
                           {
                              return _loc9_;
                           }
                           if(_loc3_)
                           {
                              _loc4_.push(_loc9_);
                           }
                        }
                     }
                  }
               }
            }
         }
         if(Boolean(_loc4_) && _loc4_.length > 0)
         {
            _loc4_.sort(DictionaryUtils.sortAbilitiesDefsByShield);
            return AbilityDef(_loc4_[0]);
         }
         return _loc5_;
      }
      
      override public function setIsAttacking(param1:Boolean, param2:FSCard) : void
      {
         var _loc3_:FSAttachment = null;
         super.setIsAttacking(param1,param2);
         if(this.mAttachments != null)
         {
            for each(_loc3_ in this.mAttachments)
            {
               _loc3_.setIsAttacking(param1,param2);
            }
         }
      }
      
      public function getTurnsAmountWithoutMovingToAttackLane() : int
      {
         return this.mTurnsAmountWithoutMovingToAttackLane;
      }
      
      public function setTurnsAmountWithoutMovingToAttackLane(param1:int) : void
      {
         this.mTurnsAmountWithoutMovingToAttackLane = param1;
         if(this.mTurnsAmountWithoutMovingToAttackLane == 0)
         {
            if(this.mTacticalMasterImage != null)
            {
               SpecialFX.tweenToAlpha(this.mTacticalMasterImage,0.001,2.5,0,this.onTacticalMasterIconFaded);
            }
            if(this.mCodeInterceptionImage != null)
            {
               SpecialFX.tweenToAlpha(this.mCodeInterceptionImage,0.001,2.5,0,this.onTacticalMasterIconFaded);
            }
         }
      }
      
      private function onTacticalMasterIconFaded() : void
      {
         if(this.mTacticalMasterImage)
         {
            this.mTacticalMasterImage.removeFromParent();
            this.mTacticalMasterImage.destroy();
            TweenMax.killTweensOf(this.mTacticalMasterImage);
            this.mTacticalMasterImage = null;
         }
      }
      
      private function onCodeInterceptionIconFaded() : void
      {
         if(this.mCodeInterceptionImage)
         {
            this.mCodeInterceptionImage.removeFromParent();
            this.mCodeInterceptionImage.destroy();
            TweenMax.killTweensOf(this.mCodeInterceptionImage);
            this.mCodeInterceptionImage = null;
         }
      }
      
      override public function getAbilityByAbSku(param1:String, param2:Boolean = false) : Ability
      {
         var _loc4_:FSAttachment = null;
         var _loc5_:Ability = null;
         var _loc6_:Vector.<Ability> = null;
         var _loc3_:Ability = super.getAbilityByAbSku(param1,param2);
         if(_loc3_ == null && param2)
         {
            if(this.mAttachments != null)
            {
               for each(_loc4_ in this.mAttachments)
               {
                  _loc6_ = _loc4_.getAbilities();
                  for each(_loc5_ in _loc6_)
                  {
                     if(_loc5_.getAbilityDef().getSku() == param1)
                     {
                        return _loc5_;
                     }
                  }
               }
            }
         }
         return _loc3_;
      }
      
      override public function dispose() : void
      {
         Utils.destroyArray(this.mAttachments);
         this.mAttachments = null;
         if(this.mLockingAbilityIconOnCard != null)
         {
            this.mLockingAbilityIconOnCard.removeFromParent(true);
            this.mLockingAbilityIconOnCard = null;
         }
         if(this.mLockingAbilityMcOnCard)
         {
            Starling.juggler.remove(this.mLockingAbilityMcOnCard);
            this.mLockingAbilityMcOnCard.removeFromParent();
            this.mLockingAbilityMcOnCard = null;
         }
         if(this.mInvulnerableMC)
         {
            Starling.juggler.remove(this.mInvulnerableMC);
            this.mInvulnerableMC.removeFromParent();
            this.mInvulnerableMC = null;
         }
         if(this.mInvulnerableIcon != null)
         {
            this.mInvulnerableIcon.removeFromParent(true);
            this.mInvulnerableIcon = null;
         }
         if(this.mUnblockableImage)
         {
            this.mUnblockableImage.removeFromParent(true);
            this.mUnblockableImage = null;
         }
         if(this.mCodeInterceptionImage)
         {
            this.mCodeInterceptionImage.removeFromParent(true);
            this.mCodeInterceptionImage = null;
         }
         if(this.mTacticalMasterImage)
         {
            this.mTacticalMasterImage.removeFromParent(true);
            this.mTacticalMasterImage = null;
         }
         if(this.mPoisonIcon)
         {
            this.mPoisonIcon.removeFromParent();
            this.mPoisonIcon.destroy();
            this.mPoisonIcon = null;
         }
         super.dispose();
      }
      
      override public function removeCardElemsFromDisplayList(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         var _loc3_:FSAttachment = null;
         var _loc4_:Vector.<FSAttachment> = null;
         var _loc5_:int = 0;
         if(mType == TYPE_UNIT && !mZoomedIn)
         {
            if(this.hasAttachments())
            {
               _loc4_ = this.getAttachments();
               _loc5_ = _loc4_ ? int(_loc4_.length) : 0;
               _loc2_ = 0;
               while(_loc2_ < _loc5_)
               {
                  _loc3_ = _loc4_[_loc2_];
                  _loc3_.removeCardElemsFromDisplayList(param1);
                  _loc2_++;
               }
            }
         }
         super.removeCardElemsFromDisplayList(param1);
         this.checkIfAllTiersCanBeUnloadable();
      }
      
      private function checkIfAllTiersCanBeUnloadable() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:CardDef = null;
         var _loc5_:CardDef = null;
         var _loc6_:CardDef = null;
         if(Config.getConfig().cardBGChangesOnPromote())
         {
            _loc1_ = !mZoomedIn && InstanceMng.getBattleEngine() != null && mCardDef != null;
            if(_loc1_)
            {
               _loc3_ = true;
               _loc5_ = mCardDef;
               while(_loc3_)
               {
                  _loc4_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc5_.getPreviousUpgradeSku()));
                  _loc3_ = _loc4_ != null;
                  if(_loc4_ != null)
                  {
                     _loc2_ = _loc1_ && InstanceMng.getBattleEngine().isBGImageUnloadableByCardDef(_loc4_);
                     if(_loc2_)
                     {
                        InstanceMng.getBattleEngine().unloadCardBGResource(_loc4_.getBGImageName());
                     }
                     _loc5_ = _loc4_;
                  }
               }
               _loc3_ = true;
               _loc5_ = mCardDef;
               while(_loc3_)
               {
                  _loc6_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc5_.getUpgradeSku()));
                  _loc3_ = _loc6_ != null;
                  if(_loc6_ != null)
                  {
                     _loc2_ = _loc1_ && InstanceMng.getBattleEngine().isBGImageUnloadableByCardDef(_loc6_);
                     if(_loc2_)
                     {
                        InstanceMng.getBattleEngine().unloadCardBGResource(_loc6_.getBGImageName());
                     }
                     _loc5_ = _loc6_;
                  }
               }
            }
         }
      }
      
      public function setInvulnerableMC(param1:MovieClip) : void
      {
         if(this.mInvulnerableMC)
         {
            this.mInvulnerableMC.removeFromParent();
            TweenMax.killTweensOf(this.mInvulnerableMC);
         }
         this.mInvulnerableMC = param1;
      }
      
      public function setLockingAbilityMcOnCard(param1:MovieClip) : void
      {
         if(this.mLockingAbilityMcOnCard)
         {
            this.mLockingAbilityMcOnCard.removeFromParent();
            TweenMax.killTweensOf(this.mLockingAbilityMcOnCard);
         }
         this.mLockingAbilityMcOnCard = param1;
      }
   }
}

