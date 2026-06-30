package com.fs.tcgengine.model.board.card
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.AbilitiesMng;
   import com.fs.tcgengine.controller.PvPConnectionMng;
   import com.fs.tcgengine.controller.rules.FactionsDefMng;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.battle.BattleEnginePvP;
   import com.fs.tcgengine.model.rules.AbilityDef;
   import com.fs.tcgengine.model.rules.FactionDef;
   import com.fs.tcgengine.model.userdata.UserBattleInfo;
   import com.fs.tcgengine.particles.TextParticlesMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSAttachment;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.FSUnit;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.socket.FSCardSocket;
   import com.greensock.TweenMax;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import starling.utils.Align;
   
   public class SpecialAbility extends Ability implements FSModelUnloadableInterface
   {
      
      public function SpecialAbility(param1:AbilityDef, param2:FSCard)
      {
         super(param1,param2);
      }
      
      override public function performAbilityOperations(param1:Array) : void
      {
         var _loc2_:String = null;
         if(mAbilityDef)
         {
            _loc2_ = mAbilityDef.getKeyName();
            switch(_loc2_)
            {
               case AbilitiesMng.SPECIAL_CONFUSION:
               case AbilitiesMng.SPECIAL_MEDICAL:
               case AbilitiesMng.SPECIAL_SABOTAGE:
               case AbilitiesMng.SPECIAL_AUTOSABOTAGE:
               case AbilitiesMng.SPECIAL_CAPTURED:
               case AbilitiesMng.SPECIAL_CODEINTERCEPTION:
               case AbilitiesMng.SPECIAL_BETTEREQUIP:
               case AbilitiesMng.SPECIAL_FULLPROMOTE:
               case AbilitiesMng.SPECIAL_KILL:
               case AbilitiesMng.SPECIAL_SCORCHED:
               case AbilitiesMng.SPECIAL_GREATSCORCHED:
               case AbilitiesMng.SPECIAL_RISING:
               case AbilitiesMng.SPECIAL_SELFRISING:
               case AbilitiesMng.SPECIAL_UNBLOCKABLE:
               case AbilitiesMng.SPECIAL_PERMANENTUNBLOCKABLE:
               case AbilitiesMng.SPECIAL_POLITICAL:
               case AbilitiesMng.SPECIAL_SPY:
               case AbilitiesMng.SPECIAL_TACTICALMASTER:
               case AbilitiesMng.SPECIAL_UNITSPY:
               case AbilitiesMng.SPECIAL_SWAPDAMAGEBYDEFENSE:
               case AbilitiesMng.SPECIAL_POLYMORPH:
               case AbilitiesMng.SPECIAL_POISON:
               case AbilitiesMng.SPECIAL_MULTICAST:
               case AbilitiesMng.SPECIAL_SACRIFICE:
               case AbilitiesMng.SPECIAL_DEMOTE:
               case AbilitiesMng.SPECIAL_TOTALDEMOTE:
               case AbilitiesMng.SPECIAL_MODIFYCOST:
               case AbilitiesMng.SPECIAL_FIXEDCOST:
               case AbilitiesMng.SPECIAL_RECRUIT:
               case AbilitiesMng.SPECIAL_SCOUTDIVISION:
               case AbilitiesMng.SPECIAL_APGENERATED:
                  this.performGeneralOps(param1);
                  break;
               case AbilitiesMng.SPECIAL_CONDITIONAL:
                  this.performConditional(param1);
                  break;
               case AbilitiesMng.SPECIAL_MASSCONFUSION:
               case AbilitiesMng.SPECIAL_MASSMEDICAL:
               case AbilitiesMng.SPECIAL_MILITARHONOR:
               case AbilitiesMng.SPECIAL_MASSCAPTURED:
               case AbilitiesMng.SPECIAL_MASSCODEINTERCEPTION:
               case AbilitiesMng.SPECIAL_MASSKILL:
               case AbilitiesMng.SPECIAL_MASSRISING:
               case AbilitiesMng.SPECIAL_MASSIVERISING:
               case AbilitiesMng.SPECIAL_MASSUNBLOCKABLE:
               case AbilitiesMng.SPECIAL_MASSPOLITICAL:
               case AbilitiesMng.SPECIAL_MASSSPY:
               case AbilitiesMng.SPECIAL_MASSTACTICALMASTER:
               case AbilitiesMng.SPECIAL_MASSPOISON:
                  this.performGeneralOps(param1,true);
                  break;
               default:
                  super.performAbilityOperations(param1);
            }
         }
      }
      
      private function performGeneralOps(param1:Array, param2:Boolean = false) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:FSCard = null;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:Array = null;
         var _loc9_:FSCard = null;
         var _loc10_:UserBattleInfo = null;
         increaseTurnsAlive();
         if(param1 != null)
         {
            _loc5_ = true;
            _loc6_ = -1;
            if(param2)
            {
               _loc8_ = InstanceMng.getAbilitiesMng().getEligibleTargetsByTargetIndex(mAbilityDef,mParentCard,mAbilityDef.getCostRange());
               if(_loc8_ != null)
               {
                  param1 = _loc8_;
               }
            }
            _loc7_ = mAbilityDef.getKeyName();
            if(param1 != null && (_loc7_ == AbilitiesMng.SPECIAL_BETTEREQUIP || _loc7_ == AbilitiesMng.SPECIAL_FULLPROMOTE))
            {
               param1 = param1.sort(DictionaryUtils.sortCardsArrByTriggerOnPromoteAbilities);
            }
            for each(_loc3_ in param1)
            {
               if(_loc3_ is FSCard)
               {
                  _loc4_ = FSCard(_loc3_);
                  _loc5_ = getAbilityDef().isCardEligibleForAbility(_loc4_);
                  if(_loc5_)
                  {
                     _loc4_.deactivateHighlightTween();
                     activateEligibleCardFX(_loc4_);
                     switch(_loc7_)
                     {
                        case AbilitiesMng.SPECIAL_SCOUTDIVISION:
                           this.performScoutDivision(_loc4_);
                           break;
                        case AbilitiesMng.SPECIAL_CONFUSION:
                        case AbilitiesMng.SPECIAL_MASSCONFUSION:
                           this.performConfusion(_loc4_);
                           break;
                        case AbilitiesMng.SPECIAL_MEDICAL:
                        case AbilitiesMng.SPECIAL_MASSMEDICAL:
                           this.performMedical(_loc4_);
                           break;
                        case AbilitiesMng.SPECIAL_SABOTAGE:
                           this.performSabotage(_loc4_);
                           break;
                        case AbilitiesMng.SPECIAL_AUTOSABOTAGE:
                           this.performAutoSabotage(_loc4_);
                           break;
                        case AbilitiesMng.SPECIAL_MILITARHONOR:
                           this.performMilitarHonor(_loc4_);
                           break;
                        case AbilitiesMng.SPECIAL_CAPTURED:
                        case AbilitiesMng.SPECIAL_MASSCAPTURED:
                           this.performCaptured(_loc4_);
                           break;
                        case AbilitiesMng.SPECIAL_CODEINTERCEPTION:
                        case AbilitiesMng.SPECIAL_MASSCODEINTERCEPTION:
                           this.performCodeInterception(_loc4_);
                           break;
                        case AbilitiesMng.SPECIAL_BETTEREQUIP:
                           this.performBetterEquip(_loc4_);
                           break;
                        case AbilitiesMng.SPECIAL_FULLPROMOTE:
                           this.performBetterEquip(_loc4_,true);
                           break;
                        case AbilitiesMng.SPECIAL_KILL:
                        case AbilitiesMng.SPECIAL_MASSKILL:
                           this.performKill(_loc4_);
                           break;
                        case AbilitiesMng.SPECIAL_RISING:
                        case AbilitiesMng.SPECIAL_MASSRISING:
                        case AbilitiesMng.SPECIAL_MASSIVERISING:
                        case AbilitiesMng.SPECIAL_SELFRISING:
                           this.performRising(_loc4_);
                           break;
                        case AbilitiesMng.SPECIAL_UNBLOCKABLE:
                        case AbilitiesMng.SPECIAL_MASSUNBLOCKABLE:
                           this.performUnblockable(_loc4_);
                           break;
                        case AbilitiesMng.SPECIAL_PERMANENTUNBLOCKABLE:
                           this.performUnblockable(_loc4_,-1);
                           break;
                        case AbilitiesMng.SPECIAL_POLITICAL:
                        case AbilitiesMng.SPECIAL_MASSPOLITICAL:
                           this.performPolitical(_loc4_);
                           break;
                        case AbilitiesMng.SPECIAL_SPY:
                        case AbilitiesMng.SPECIAL_MASSSPY:
                        case AbilitiesMng.SPECIAL_UNITSPY:
                           performSpy(_loc4_);
                           break;
                        case AbilitiesMng.SPECIAL_TACTICALMASTER:
                        case AbilitiesMng.SPECIAL_MASSTACTICALMASTER:
                           this.performTacticalMaster(_loc4_);
                           break;
                        case AbilitiesMng.SPECIAL_SWAPDAMAGEBYDEFENSE:
                           this.performSwapDamageByDefense(_loc4_);
                           break;
                        case AbilitiesMng.SPECIAL_POLYMORPH:
                           this.performPolymorph(_loc4_);
                           break;
                        case AbilitiesMng.SPECIAL_POISON:
                        case AbilitiesMng.SPECIAL_MASSPOISON:
                           this.performPoison(_loc4_);
                           break;
                        case AbilitiesMng.SPECIAL_MULTICAST:
                           if(_loc6_ == -1)
                           {
                              _loc6_ = this.performMultiCast(_loc4_);
                           }
                           else
                           {
                              this.performMultiCast(_loc4_,_loc6_);
                           }
                           break;
                        case AbilitiesMng.SPECIAL_SACRIFICE:
                           this.performSacrifice(_loc4_);
                           break;
                        case AbilitiesMng.SPECIAL_DEMOTE:
                           this.performDemote(_loc4_,Utils.getPreviousTierCardDef(_loc4_.getCardDef().getSku()).getSku());
                           break;
                        case AbilitiesMng.SPECIAL_TOTALDEMOTE:
                           this.performDemote(_loc4_,Utils.getBaseTierCardDef(_loc4_.getCardDef().getSku()).getSku());
                     }
                     _loc4_.updateStatsAfterAttack(_loc4_.getDefense());
                     if(_loc4_ is FSAttachment)
                     {
                        _loc9_ = getUnitFromAttachment(_loc4_);
                        if((Boolean(_loc9_)) && _loc9_.isUnit())
                        {
                           _loc9_.showAbilityBeingAppliedIcon(this);
                        }
                     }
                     else
                     {
                        _loc4_.showAbilityBeingAppliedIcon(this);
                     }
                  }
                  continue;
               }
               if(!(_loc3_ is UserBattleInfo))
               {
                  continue;
               }
               _loc10_ = UserBattleInfo(_loc3_);
               if(Config.getConfig().getShowAbilitiesAnimations())
               {
                  InstanceMng.getCardAnimsMng().requestCardAnimAbility(this,_loc10_.getUserBattlePortrait().getFrameContainer());
               }
               switch(_loc7_)
               {
                  case AbilitiesMng.SPECIAL_SCORCHED:
                  case AbilitiesMng.SPECIAL_GREATSCORCHED:
                     this.performScorched(_loc10_);
                     break;
                  case AbilitiesMng.SPECIAL_RISING:
                  case AbilitiesMng.SPECIAL_MASSIVERISING:
                     this.performRising(_loc10_);
                     _loc10_.showAbilityBeingAppliedIcon(this);
                     break;
                  case AbilitiesMng.SPECIAL_POISON:
                  case AbilitiesMng.SPECIAL_MASSPOISON:
                     this.performPoison(_loc10_);
                     _loc10_.showAbilityBeingAppliedIcon(this);
                     break;
                  case AbilitiesMng.SPECIAL_MULTICAST:
                     if(_loc6_ == -1)
                     {
                        _loc6_ = this.performMultiCast(_loc10_);
                     }
                     else
                     {
                        this.performMultiCast(_loc10_,_loc6_);
                     }
                     break;
                  case AbilitiesMng.SPECIAL_MODIFYCOST:
                     this.performExtraSummonCost(_loc10_);
                     break;
                  case AbilitiesMng.SPECIAL_FIXEDCOST:
                     this.performFixedCost(_loc10_);
                     break;
                  case AbilitiesMng.SPECIAL_RECRUIT:
                     this.performRecruit();
                     break;
                  case AbilitiesMng.SPECIAL_APGENERATED:
                     this.performApGenerated(_loc10_);
               }
            }
            onAbilitiesPerformed(param1);
         }
      }
      
      private function performConditional(param1:Array) : void
      {
         var _loc2_:FSImage = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:AbilityDef = null;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:FSImage = null;
         increaseTurnsAlive();
         if(param1 != null && param1.length > 0)
         {
            _loc2_ = mParentCard.getAbilityIconImage(getAbilityDef());
            _loc3_ = _loc2_.x;
            _loc4_ = _loc2_.y;
            mParentCard.removeAbility(this);
            _loc5_ = AbilityDef(InstanceMng.getAbilitiesDefMng().getDefBySku(getAbilityDef().getUnlockAbilitySku()));
            _loc6_ = mParentCard.addAbility(_loc5_);
            if(_loc6_)
            {
               _loc7_ = InstanceMng.getCardsMng().createAbilityIcon(mParentCard,_loc5_,0,false);
               _loc8_ = mParentCard.getAbilityIconImage(_loc5_);
               if(_loc8_)
               {
                  _loc8_.x = _loc3_;
                  _loc8_.y = _loc4_;
               }
            }
         }
      }
      
      private function performSacrifice(param1:FSCard) : void
      {
         if(param1)
         {
            param1.updateStatsAfterAttack(0);
         }
      }
      
      private function performMultiCast(param1:*, param2:int = -1) : int
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc10_:int = 0;
         var _loc12_:Object = null;
         var _loc13_:Boolean = false;
         var _loc14_:uint = 0;
         var _loc15_:int = 0;
         var _loc3_:Dictionary = mAbilityDef.getChances();
         var _loc4_:Array = new Array();
         var _loc8_:Array = DictionaryUtils.getKeys(_loc3_);
         var _loc9_:int = 0;
         _loc6_ = 0;
         while(_loc6_ < _loc8_.length)
         {
            _loc7_ = int(_loc3_[_loc8_[_loc6_]]);
            _loc5_ = 0;
            while(_loc5_ < _loc7_)
            {
               _loc4_[_loc9_] = _loc8_[_loc6_];
               _loc9_++;
               _loc5_++;
            }
            _loc6_++;
         }
         if(InstanceMng.getBattleEngine().isOnlineMatch() && !InstanceMng.getBattleEngine().isOwnerTurn() && !PvPConnectionMng.isPlayingVSAI())
         {
            _loc12_ = BattleEnginePvP(InstanceMng.getBattleEngine()).getPvPObjectByCardId(getParentCard().getId());
            if(_loc12_)
            {
               _loc10_ = param2 != -1 ? param2 : int(_loc12_["mMulticastFactor"]);
            }
         }
         else
         {
            _loc10_ = param2 != -1 ? param2 : int(_loc4_[Utils.randomInt(0,99)]);
         }
         if(param2 == -1)
         {
            this.updatePvMulticastFactor(_loc10_);
         }
         var _loc11_:FSNumber = new FSNumber(mAbilityDef.getHeal() * _loc10_);
         if(param1 is FSCard)
         {
            _loc13_ = param1 is FSUnit && FSUnit(param1).getInvulnerableTurns() > 0;
            if(!_loc13_)
            {
               _loc15_ = param1 is FSUnit ? FSUnit(param1).getUpdatedCompositeDefense() : int(param1.getDefense());
               if(_loc15_ < param1.getDefense() && _loc11_.value > 0)
               {
                  _loc11_.value = 0;
               }
               else if(_loc11_.value > 0)
               {
                  _loc11_.value = param1.getDefense() + _loc11_.value <= _loc15_ ? _loc11_.value : _loc15_ - param1.getDefense();
               }
               else
               {
                  _loc11_.value = param1.getDefense() + _loc11_.value <= 0 ? -param1.getDefense() : _loc11_.value;
               }
               FSCard(param1).addDefense(_loc11_.value);
               FSCard(param1).performDamageAndShieldAnim();
               if(_loc10_ > 1)
               {
                  InstanceMng.getTextParticlesMng().showTextParticleOnBattle("(x" + _loc10_ + "!!)",16777215,FSCard(param1),FSResourceMng.FONT_STD_TITLE_SIZE,Align.LEFT,Align.TOP,FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_BLUE),"damage_icon",true);
               }
            }
            else
            {
               _loc11_.value = 0;
            }
            _loc14_ = _loc11_.value >= 0 ? TextParticlesMng.COLOR_HEAL_RECEIVED : TextParticlesMng.COLOR_DAMAGE_RECEIVED_STD;
            _loc14_ = _loc13_ && _loc11_.value == 0 ? TextParticlesMng.COLOR_DAMAGE_RECEIVED_STD : _loc14_;
            InstanceMng.getTextParticlesMng().showTextParticle(_loc11_.value.toString(),_loc14_,FSCard(param1),-1,Align.RIGHT);
         }
         else if(param1 is UserBattleInfo)
         {
            if(_loc10_ > 1)
            {
               InstanceMng.getTextParticlesMng().showTextParticleOnBattle("(x" + _loc10_ + "!!)",16777215,UserBattleInfo(param1).getUserBattlePortrait(),FSResourceMng.FONT_STD_TITLE_SIZE,Align.LEFT,Align.TOP,FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_BLUE),"damage_icon",true);
            }
            UserBattleInfo(param1).modifyHP(_loc11_,true);
         }
         return _loc10_;
      }
      
      private function updatePvMulticastFactor(param1:int) : void
      {
         if(InstanceMng.getBattleEngine().isOnlineMatch() && InstanceMng.getBattleEngine().isOwnerTurn())
         {
            BattleEnginePvP(InstanceMng.getBattleEngine()).onMulticastAbilityPropertyTriggered(getParentCard(),param1);
         }
      }
      
      private function performSwapDamageByDefense(param1:FSCard) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Vector.<FSAttachment> = null;
         var _loc8_:FSAttachment = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc2_:Boolean = param1 is FSUnit && FSUnit(param1).getInvulnerableTurns() > 0;
         if(!_loc2_)
         {
            _loc5_ = param1.getDamage();
            _loc6_ = param1.getDefense();
            _loc7_ = param1.getAttachments();
            if(_loc7_ != null)
            {
               for each(_loc8_ in _loc7_)
               {
                  _loc3_ = _loc8_.getDamage();
                  _loc4_ = _loc8_.getDefense();
                  _loc9_ += _loc3_;
                  _loc10_ += _loc4_;
                  _loc8_.setDamage(_loc4_);
                  _loc8_.setDefense(_loc3_);
               }
            }
            _loc4_ = _loc6_ - _loc10_;
            param1.setDamage(_loc4_);
            param1.setDefense(_loc5_);
            param1.performDamageAndShieldAnim();
         }
      }
      
      private function performPolymorph(param1:FSCard) : void
      {
         if(param1 is FSAttachment)
         {
            param1 = getUnitFromAttachment(param1);
         }
         var _loc2_:int = mAbilityDef.getForcedDamage();
         var _loc3_:int = mAbilityDef.getForcedDefense();
         if(_loc2_ != -1)
         {
            param1.setDamage(_loc2_);
         }
         var _loc4_:Boolean = param1 is FSUnit && FSUnit(param1).getInvulnerableTurns() > 0;
         if(!_loc4_)
         {
            if(_loc3_ != -1)
            {
               param1.setDefense(_loc3_);
            }
         }
         param1.performDamageAndShieldAnim();
      }
      
      private function performFixedCost(param1:UserBattleInfo) : void
      {
         FSDebug.debugTrace("FIxed Summon Cost on next Card");
         param1.setFixedSummonCost(mAbilityDef.getExtraSummonCost());
         param1.setTurnsFixedSummonCost(mAbilityDef.getDuration());
         param1.setFixedSummonCostAbilityDef(mAbilityDef);
         param1.setFixedSummonCostParentCard(mParentCard);
         param1.performExtraCostUpdate(mAbilityDef,mParentCard);
         if(Boolean(getAbilityDef().getTargetIndex() == AbilitiesMng.TARGET_NEXT_CARD_DECK) || Boolean(AbilitiesMng.TARGET_NEXT_ENEMY_CARD_DECK) || Boolean(AbilitiesMng.TARGET_NEXT_FRIENDLY_CARD_DECK))
         {
            param1.setApplyCostModifierAbilityOnNextCard(true);
         }
         if(Boolean(InstanceMng.getBattleEngine()) && Boolean(InstanceMng.getBattleEngine().getBattleScreen()))
         {
            setTimeout(InstanceMng.getBattleEngine().getBattleScreen().suggestPlayableCardON,250);
         }
      }
      
      private function performExtraSummonCost(param1:UserBattleInfo) : void
      {
         FSDebug.debugTrace("Extra Summon Cost on Card");
         var _loc2_:int = param1.getExtraSummonCostTurns();
         if(_loc2_ != -1)
         {
            param1.setModifySummonCostTurns(mAbilityDef.getDuration());
            param1.setExtraSummonCost(mAbilityDef.getExtraSummonCost());
            param1.setModifySummonCostAbilityDef(mAbilityDef);
            param1.setModifySummonCostParentCard(mParentCard);
            param1.performExtraCostUpdate(mAbilityDef,mParentCard);
         }
         if(Boolean(getAbilityDef().getTargetIndex() == AbilitiesMng.TARGET_NEXT_CARD_DECK) || Boolean(AbilitiesMng.TARGET_NEXT_ENEMY_CARD_DECK) || Boolean(AbilitiesMng.TARGET_NEXT_FRIENDLY_CARD_DECK))
         {
            param1.setApplyCostModifierAbilityOnNextCard(true);
         }
         if(Boolean(InstanceMng.getBattleEngine()) && Boolean(InstanceMng.getBattleEngine().getBattleScreen()))
         {
            setTimeout(InstanceMng.getBattleEngine().getBattleScreen().suggestPlayableCardON,250);
         }
      }
      
      private function performPoison(param1:*) : void
      {
         var _loc2_:int = 0;
         var _loc3_:FSCard = null;
         var _loc4_:FSCardSocket = null;
         var _loc5_:FSCard = null;
         if(param1 is FSCard)
         {
            FSDebug.debugTrace("Poison on CARD");
            _loc3_ = FSCard(param1);
            if(_loc3_ is FSAttachment)
            {
               _loc4_ = FSAttachment(_loc3_).getAttachedToSocket();
               if(_loc4_)
               {
                  _loc5_ = _loc4_.getParentCard();
                  if(_loc5_)
                  {
                     _loc2_ = FSUnit(_loc5_).getPoisonTurns();
                     if(_loc2_ != -1)
                     {
                        FSUnit(_loc5_).setPoisonTurns(mAbilityDef.getDuration());
                        FSUnit(_loc5_).setPoisonDamage(mAbilityDef.getPoisonDamage());
                     }
                  }
               }
            }
            else
            {
               _loc2_ = FSUnit(_loc3_).getPoisonTurns();
               if(_loc2_ != -1)
               {
                  FSUnit(_loc3_).setPoisonTurns(mAbilityDef.getDuration());
                  FSUnit(_loc3_).setPoisonDamage(mAbilityDef.getPoisonDamage());
               }
            }
         }
         else if(param1 is UserBattleInfo)
         {
            FSDebug.debugTrace("Poison on User");
            UserBattleInfo(param1).setPoisonTurns(mAbilityDef.getDuration());
            UserBattleInfo(param1).setPoisonDamage(mAbilityDef.getPoisonDamage());
         }
      }
      
      private function performTacticalMaster(param1:FSCard) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         if(param1 is FSUnit)
         {
            _loc2_ = 1;
            _loc3_ = mAbilityDef.getKeyName();
            switch(_loc3_)
            {
               case AbilitiesMng.SPECIAL_TACTICALMASTER:
                  _loc2_ = 1;
                  break;
               case AbilitiesMng.SPECIAL_MASSTACTICALMASTER:
                  _loc2_ = 2;
            }
            FSUnit(param1).setTurnsAmountWithoutMovingToAttackLane(_loc2_);
         }
      }
      
      private function performPolitical(param1:FSCard) : void
      {
         var _loc4_:uint = 0;
         var _loc8_:uint = 0;
         var _loc2_:int = mAbilityDef.getDamage();
         var _loc3_:Boolean = param1.getDamage() + _loc2_ < 0;
         if(!_loc3_)
         {
            param1.addDamage(_loc2_);
         }
         else
         {
            param1.addDamage(-param1.getDamage());
         }
         if(param1.getDieOnEndTurn())
         {
            _loc4_ = TextParticlesMng.COLOR_INACTIVE;
         }
         else
         {
            _loc4_ = _loc2_ < 0 ? TextParticlesMng.COLOR_DAMAGE_RECEIVED_STD : TextParticlesMng.COLOR_HEAL_RECEIVED;
         }
         var _loc5_:String = _loc2_ > 0 ? "+" + _loc2_.toString() : _loc2_.toString();
         InstanceMng.getTextParticlesMng().showTextParticle(_loc5_,_loc4_,param1,-1,Align.LEFT);
         var _loc6_:int = mAbilityDef.getDefense();
         var _loc7_:int = param1 is FSUnit ? FSUnit(param1).getUpdatedCompositeDefense() : param1.getDefense();
         if(_loc7_ < param1.getDefense() && _loc6_ > 0)
         {
            _loc6_ = 0;
         }
         else if(_loc6_ < 0)
         {
            _loc6_ = param1.getDefense() + _loc6_ <= 0 ? int(-param1.getDefense()) : _loc6_;
         }
         param1.addDefense(_loc6_);
         if(param1.getDieOnEndTurn())
         {
            _loc8_ = TextParticlesMng.COLOR_INACTIVE;
         }
         else
         {
            _loc8_ = _loc6_ < 0 ? TextParticlesMng.COLOR_DAMAGE_RECEIVED_STD : TextParticlesMng.COLOR_HEAL_RECEIVED;
         }
         _loc5_ = _loc6_ > 0 ? "+" + _loc6_.toString() : _loc6_.toString();
         InstanceMng.getTextParticlesMng().showTextParticle(_loc5_,_loc8_,param1,-1,Align.RIGHT);
         InstanceMng.getCardAnimsMng().requestHealAnimation(param1);
         var _loc9_:UserBattleInfo = param1.getParentUserBattleInfo();
         if(_loc9_ != null)
         {
            _loc9_.modifyHP(new FSNumber(mAbilityDef.getPlayerHeal()),true);
         }
      }
      
      private function performUnblockable(param1:FSCard, param2:int = 1) : void
      {
         var _loc3_:int = 0;
         var _loc4_:FSCardSocket = null;
         var _loc5_:FSCard = null;
         if(param1 is FSAttachment)
         {
            _loc4_ = FSAttachment(param1).getAttachedToSocket();
            if(_loc4_)
            {
               _loc5_ = _loc4_.getParentCard();
               if(_loc5_)
               {
                  _loc3_ = FSUnit(_loc5_).getUnblockableTurns();
                  if(_loc3_ != -1)
                  {
                     FSUnit(_loc5_).setUnblockableTurns(param2);
                  }
               }
            }
         }
         else
         {
            _loc3_ = FSUnit(param1).getUnblockableTurns();
            if(_loc3_ != -1)
            {
               FSUnit(param1).setUnblockableTurns(param2);
            }
         }
      }
      
      private function performRising(param1:*) : void
      {
         var _loc2_:FSCard = null;
         if(param1 != null)
         {
            if(param1 is FSCard)
            {
               if(param1 is FSAttachment)
               {
                  _loc2_ = getUnitFromAttachment(param1);
                  if(_loc2_ != null && _loc2_ is FSUnit)
                  {
                     FSDebug.debugTrace("Massive on CARD");
                     FSUnit(_loc2_).setInvulnerableTurns(1);
                  }
               }
               else
               {
                  FSDebug.debugTrace("Massive on CARD");
                  FSUnit(param1).setInvulnerableTurns(1);
               }
            }
            else if(param1 is UserBattleInfo)
            {
               UserBattleInfo(param1).setInvulnerableTurns(1);
               FSDebug.debugTrace("Massive on User");
            }
         }
      }
      
      private function performScorched(param1:UserBattleInfo) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         if(param1 != null)
         {
            _loc2_ = mAbilityDef.getKeyName();
            _loc3_ = mAbilityDef.getApValue();
            switch(_loc2_)
            {
               case AbilitiesMng.SPECIAL_SCORCHED:
                  param1.addNextTurnExtraActionPoints(_loc3_);
                  break;
               case AbilitiesMng.SPECIAL_GREATSCORCHED:
                  param1.addNextTurnExtraActionPoints(-2);
            }
         }
      }
      
      private function performKill(param1:FSCard) : void
      {
         var _loc4_:int = 0;
         var _loc5_:UserBattleInfo = null;
         var _loc2_:Boolean = param1 is FSUnit && FSUnit(param1).getInvulnerableTurns() > 0;
         if(!_loc2_)
         {
            _loc4_ = param1.getDefense();
            param1.updateStatsAfterAttack(0);
            _loc5_ = param1.getParentUserBattleInfo();
            if(_loc5_ != null)
            {
               _loc5_.modifyHP(new FSNumber(getAbilityDef().getPlayerHeal()),true);
            }
         }
         var _loc3_:String = !_loc2_ ? "-" + _loc4_.toString() : "-0";
         InstanceMng.getTextParticlesMng().showTextParticleOnBattle(_loc3_,TextParticlesMng.COLOR_DAMAGE_RECEIVED_ABILITY,param1,-1,Align.RIGHT);
         InstanceMng.getCardAnimsMng().requestDebuffAnimation(param1);
      }
      
      private function performBetterEquip(param1:FSCard, param2:Boolean = false) : void
      {
         var _loc3_:FSCard = null;
         if(param1 != null)
         {
            if(param1 is FSAttachment)
            {
               _loc3_ = getUnitFromAttachment(param1);
               if(_loc3_ != null && _loc3_ is FSUnit)
               {
                  _loc3_.promoteCardFree(-1,param2);
               }
            }
            else
            {
               param1.promoteCardFree(-1,param2);
            }
         }
      }
      
      private function performDemote(param1:FSCard, param2:String) : void
      {
         var _loc3_:FSCard = null;
         if(param1 != null)
         {
            if(param1 is FSAttachment)
            {
               _loc3_ = getUnitFromAttachment(param1);
               if(_loc3_ != null && _loc3_ is FSUnit)
               {
                  _loc3_.demoteCard(param2);
               }
            }
            else
            {
               param1.demoteCard(param2);
            }
         }
      }
      
      private function performRecruit() : void
      {
         var battleEngine:BattleEngine = null;
         var onNextCardsHandResourcesLoadedCalledFromAbility:Function = null;
         var cardSku:String = null;
         var pvpObj:Object = null;
         var abilityTargetKeynames:Array = null;
         var categorySku:String = null;
         var subCategorySkus:Array = null;
         var factionSku:String = null;
         onNextCardsHandResourcesLoadedCalledFromAbility = function():void
         {
            if(Boolean(battleEngine) && Boolean(battleEngine.getBattleScreen()))
            {
               battleEngine.getBattleScreen().showLoadingIcon(false,true);
               battleEngine.getBattleScreen().dealOwnerCardsToDeck(null,cardSku);
            }
         };
         battleEngine = InstanceMng.getBattleEngine();
         if(battleEngine)
         {
            cardSku = "";
            if(battleEngine.isOnlineMatch() && !battleEngine.isOwnerTurn() && !PvPConnectionMng.isPlayingVSAI())
            {
               pvpObj = BattleEnginePvP(battleEngine).getPvPObjectByCardId(getParentCard().getId());
               if(pvpObj)
               {
                  cardSku = pvpObj["mRecruitCard"] != null ? pvpObj["mRecruitCard"] : "";
               }
            }
            else
            {
               abilityTargetKeynames = mAbilityDef.getAbilityTargetKeynames();
               categorySku = mAbilityDef.getCategorySku();
               subCategorySkus = mAbilityDef.getSubCategorySku();
               factionSku = mAbilityDef.getFactionSku();
               cardSku = mParentCard.getParentUserBattleInfo().getRandomCardSkuFromDeck(false,false,abilityTargetKeynames,categorySku,subCategorySkus,factionSku);
               cardSku = cardSku == null ? "" : cardSku;
               if(battleEngine.isOnlineMatch() && battleEngine.isOwnerTurn())
               {
                  PvPConnectionMng.updateStoredBFCardWithAbilityRecruitInfo(mParentCard,cardSku);
               }
            }
            if(cardSku != null && cardSku != "")
            {
               battleEngine.loadNextCardsHandResources(null,onNextCardsHandResourcesLoadedCalledFromAbility,null,cardSku);
            }
         }
      }
      
      private function performApGenerated(param1:UserBattleInfo) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         FSDebug.debugTrace("Performing AP Generated");
         var _loc2_:int = mAbilityDef.getAPGenerated();
         var _loc3_:Boolean = InstanceMng.getBattleEngine().isOwnerTurn();
         var _loc4_:Boolean = _loc3_ && param1.isOwnerBattleInfo() || !_loc3_ && !param1.isOwnerBattleInfo();
         if(mParentCard is FSUnit && _loc4_)
         {
            _loc5_ = param1.getMaxActionPoints();
            _loc6_ = param1.isOwnerBattleInfo() ? int(InstanceMng.getBattleEngine().getLevelDef().getMaxActionPoints()) : int(InstanceMng.getBattleEngine().getLevelDef().getMaxAIActionPoints());
            if(_loc5_ == _loc6_)
            {
               _loc2_ += 1;
            }
         }
         if(_loc2_ != 0)
         {
            param1.increaseAPGenerated(_loc2_);
         }
      }
      
      private function performMedical(param1:FSCard) : void
      {
         var _loc2_:int = FSUnit(param1).getUpdatedCompositeDefense();
         var _loc3_:int = param1.getDefense() <= _loc2_ ? int(_loc2_ - param1.getDefense()) : 0;
         param1.addDefense(_loc3_);
         var _loc4_:String = "+" + _loc3_.toString();
         var _loc5_:uint = param1.getDieOnEndTurn() ? TextParticlesMng.COLOR_INACTIVE : TextParticlesMng.COLOR_HEAL_RECEIVED;
         InstanceMng.getTextParticlesMng().showTextParticle(_loc4_,_loc5_,param1,-1,Align.RIGHT);
         InstanceMng.getCardAnimsMng().requestHealAnimation(param1);
         param1.removeBulletAnims();
      }
      
      private function performScoutDivision(param1:FSCard) : void
      {
         var _loc2_:Dictionary = param1.getScoutDivisionEligibleTargets(mAbilityDef);
         if(InstanceMng.getBattleEngine())
         {
            TweenMax.delayedCall(Config.getConfig().getDefaultZoomOutTime(),InstanceMng.getBattleEngine().performSupportToAttackMovement,[true,_loc2_]);
         }
      }
      
      private function performConfusion(param1:FSCard) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc2_:Boolean = param1 is FSUnit && FSUnit(param1).getInvulnerableTurns() > 0;
         if(!_loc2_)
         {
            _loc5_ = param1.getExtraDefenseGainedByAbilities(param1);
            _loc6_ = param1.getDamage();
            if(_loc5_ > 0)
            {
               _loc6_ = _loc6_ - _loc5_ > 0 ? int(_loc6_ - _loc5_) : 0;
            }
            _loc7_ = param1.getDefense() - _loc6_ > 0 ? int(param1.getDefense() - _loc6_) : 0;
            param1.updateStatsAfterAttack(_loc7_);
         }
         var _loc3_:String = !_loc2_ ? "-" + _loc6_.toString() : "-0";
         var _loc4_:String = _loc6_ >= Config.getConfig().battleGetActivateSFXAttackValue() ? "high_damage_icon" : "damage_icon";
         InstanceMng.getTextParticlesMng().showTextParticleOnBattle(_loc3_,TextParticlesMng.COLOR_DAMAGE_RECEIVED_ABILITY,param1,-1,Align.RIGHT,Align.CENTER,"",_loc4_);
         InstanceMng.getCardAnimsMng().requestDebuffAnimation(param1);
      }
      
      private function performSabotage(param1:FSCard) : void
      {
         FSUnit(param1).removeAllAttachments();
         TweenMax.delayedCall(Config.getConfig().getDefaultAbilityAnimDuration(),this.checkBattleEngineCardsKilledInCombat);
      }
      
      private function checkBattleEngineCardsKilledInCombat() : void
      {
         if(InstanceMng.getBattleEngine())
         {
            InstanceMng.getBattleEngine().checkCardsKilledInCombat();
         }
      }
      
      private function performAutoSabotage(param1:FSCard) : void
      {
         var _loc2_:FSCard = null;
         if(param1 != null && param1 is FSAttachment)
         {
            _loc2_ = getUnitFromAttachment(param1);
            if(_loc2_ != null && _loc2_ is FSUnit)
            {
               FSUnit(_loc2_).removeUniqueAttachment(FSAttachment(param1));
            }
         }
         TweenMax.delayedCall(Config.getConfig().getDefaultAbilityAnimDuration(),this.checkBattleEngineCardsKilledInCombat);
      }
      
      private function performMilitarHonor(param1:FSCard) : void
      {
         var _loc4_:FactionDef = null;
         var _loc5_:int = 0;
         var _loc2_:int = mAbilityDef.getDamage();
         var _loc3_:String = param1.getCardDef().getFactionSku();
         if(_loc3_ != "" && _loc3_ != null)
         {
            _loc4_ = FactionDef(InstanceMng.getFactionsDefMng().getDefBySku(_loc3_));
            if(_loc4_ != null)
            {
               _loc5_ = _loc4_.getIndex();
               _loc2_ = _loc5_ == FactionsDefMng.FACTION_JAPAN ? int(_loc2_ + 1) : _loc2_;
            }
         }
         FSUnit(param1).addDamage(_loc2_);
      }
      
      private function performCaptured(param1:FSCard) : void
      {
         FSUnit(param1).setTurnsToBeAbleToAttack(1);
      }
      
      private function performCodeInterception(param1:FSCard) : void
      {
         FSUnit(param1).performAttackToSupportMovement();
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
   }
}

