package com.fs.tcgengine.controller
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.battle.BattleEnginePvP;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.model.userdata.UserBattleInfo;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.screens.FSBattleScreenPvP;
   import com.fs.tcgengine.screens.FSMapScreen;
   import com.fs.tcgengine.screens.FSPvPScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.TimerUtil;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSAction;
   import com.fs.tcgengine.view.cards.FSAttachment;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.FSPower;
   import com.fs.tcgengine.view.cards.FSUnit;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.popups.Popup;
   import com.fs.tcgengine.view.popups.misc.PopupError;
   import com.fs.tcgengine.view.popups.pvp.PopupOpponentFound;
   import com.fs.tcgengine.view.popups.pvp.PopupSearchingPvPOpponent;
   import com.fs.tcgengine.view.popups.pvp.PopupWaitingForOpponent;
   import com.fs.tcgengine.view.socket.FSCardSocket;
   import com.greensock.TweenMax;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import mx.utils.ObjectUtil;
   import starling.display.Sprite;
   import starling.utils.Align;
   
   public class PvPConnectionMng extends Sprite
   {
      
      public static var smPvPBattleData:Object;
      
      public static var smBattleSyncData:Object;
      
      public static var smServerMatchData:Object;
      
      public static var smTimeLeftAcceptOpponentFound:int;
      
      public static var smPvPOpponentFoundTime:int;
      
      public static var smPvPWaitingForOpponentTime:int;
      
      public static var smPvPMinTurnsToBanSurrender:int;
      
      public static var smPvPBannedCards:String;
      
      public static var smPvPFriendlyUID:String;
      
      public static var smCurrentMatchId:String;
      
      public static var smOpponentUserData:UserData;
      
      public static var smCurrentMatchEloLostIfMatchLost:int;
      
      public static var smEloBeforeStartingMatch:int;
      
      public static var smLeagueBeforeStartingMatch:int;
      
      public static var smOpponentName:String;
      
      public static var smLeaguesInformation:Object;
      
      public static var smPvPRewardsInfo:Object;
      
      private static var smTargetSetWaitingForStatsToFill:Boolean;
      
      private static var smMovesPool:Dictionary;
      
      public static const MOVE_ID_PREFIX:String = "m";
      
      public static const ACTION_INVITE:String = "invite";
      
      public static const ACTION_FB_INVITE:String = "FBinvite";
      
      public static const ACTION_ACCEPT:String = "accept";
      
      public static const ACTION_SURRENDER:String = "surrender";
      
      public static const ACTION_UPDATE_ROUND:String = "update_round";
      
      public static const ACTION_UPDATE_MOVE:String = "update_move";
      
      public static const ACTION_USER_READY:String = "user_ready";
      
      public static const ACTION_SEND_MESSAGE:String = "send_message";
      
      public static const ACTION_FINALIZE:String = "finalize";
      
      public static const ACTION_SYNC_STEP_2:String = "sync_step_2";
      
      public static const TYPE_NEW_MATCH:String = "newMatch";
      
      public static const TYPE_NEW_FRIENDLY_MATCH:String = "newFBMatch";
      
      public static const TYPE_FRIENDLY_MATCH_DECLINED:String = "friendlyMatchDeclined";
      
      public static const TYPE_START_MATCH:String = "startMatch";
      
      public static const TYPE_ACCEPTED_MATCH:String = "acceptedMatch";
      
      public static const TYPE_FINISHED_MATCH:String = "finishedMatch";
      
      public static const TYPE_NEW_ROUND_AVAILABLE:String = "newRoundAvailable";
      
      public static const TYPE_NEW_MOVE_AVAILABLE:String = "newMoveAvailable";
      
      public static const TYPE_NEW_CHAT_MESSAGE:String = "newChatMessage";
      
      public static const TYPE_USER_READY:String = "userReady";
      
      public static const TYPE_OWNER_AWAY:String = "ownerAway";
      
      public static const TYPE_MATCH_DEAD:String = "SETMATCHDEAD";
      
      public static const TYPE_PLAYER_OK:String = "OK";
      
      public static const TYPE_PLAYER_OK_1:String = "OK_1";
      
      public static const TYPE_MATCH_EDITED:String = "matchEdited";
      
      public static const MATCH_STATUS_READY:String = "ready";
      
      public static const MATCH_STATUS_WAITING_FB_OPPONENT:String = "waitingFBOpponent";
      
      public static const MATCH_STATUS_USERS_ACCEPTING:String = "usersAccepting";
      
      public static const MATCH_STATUS_DEAD:String = "dead";
      
      public static const MATCH_STATUS_ACTIVE:String = "active";
      
      public static const MATCH_STATUS_FINISHED:String = "finished";
      
      public static const MATCH_BOT_UID:String = "BOT_UID";
      
      public static const REAL_TIME:Boolean = true;
      
      public static const REAL_TIME_RELEASED:Boolean = true;
      
      public static var smMoveId:int = 1;
      
      public static var smExpirationTimeLeft:Number = 0;
      
      public static var smExpirationTime:Number = 0;
      
      public static var smUserInPvPQueue:Boolean = false;
      
      public static var smRequestPvPTime:Boolean = false;
      
      public static var smUserInPvPBattle:Boolean = false;
      
      public static var smUserSettingUpForMatch:Boolean = false;
      
      public static var smNotificationTurnId:int = -1;
      
      public static var smPlayingFriendlyMatch:Boolean = false;
      
      public static var smPlayingAgainstBOT:Boolean = false;
      
      public static var smPlayingAgainstOfflineDeck:Boolean = false;
      
      public static var smPvPBotsActive:Boolean = false;
      
      public static var smInitMatchInfoReceived:Boolean = false;
      
      private static var smRoundReplayAttempts:int = 0;
      
      private static var smOwnerPvPMovesSentSuccesfully:Boolean = false;
      
      public static var smMatchActionId:int = -1;
      
      private static var smOpponentHasReshuffled:Boolean = false;
      
      private static var smOwnerHasReshuffled:Boolean = false;
      
      public function PvPConnectionMng()
      {
         super();
      }
      
      public static function init() : void
      {
         if(smPvPBattleData == null)
         {
            smPvPBattleData = new Object();
         }
      }
      
      public static function resetBattleDataAfterReshuffle() : void
      {
         smPvPBattleData = null;
      }
      
      public static function packageSaveObjForSending(param1:Boolean = false) : void
      {
         if(realTimeAllowed() || smPvPBattleData["dataReady"] == false)
         {
            FSDebug.debugTrace("TurnId: " + smNotificationTurnId + " | moveId: " + smMoveId);
            smPvPBattleData["dataReady"] = true;
            smPvPBattleData["ua"] = InstanceMng.getServerConnection().getUserId();
            if(!param1)
            {
               onTurnFinished();
            }
            else
            {
               onMoveFinished();
            }
            printCurrentSaveData();
         }
      }
      
      public static function prepareSaveObj(param1:String = "1", param2:String = "true") : void
      {
         var _loc4_:Array = null;
         if(smPvPBattleData == null)
         {
            init();
         }
         smPvPBattleData["save"] = new Object();
         smPvPBattleData["save"]["mOwnerMovesFirst"] = param2;
         smPvPBattleData["save"]["mCurrentTurnId"] = param1;
         smPvPBattleData["save"]["currentLevelSku"] = BattleEnginePvP.PVP_LEVEL_SKU;
         var _loc3_:UserBattleInfo = InstanceMng.getBattleEngine().getOwnerBattleInfo();
         smPvPBattleData["save"]["opponentBattleInfo"] = new Object();
         smPvPBattleData["dataReady"] = false;
      }
      
      public static function storePlayableCard(param1:String, param2:int, param3:int) : void
      {
         var _loc4_:String = null;
         if(smPvPBattleData != null && smPvPBattleData["save"] != null)
         {
            _loc4_ = "opponentBattleInfo";
            if(smPvPBattleData["save"][_loc4_] != null)
            {
               if(smPvPBattleData["save"][_loc4_].mPlayableCardsCatalog == null)
               {
                  smPvPBattleData["save"][_loc4_].mPlayableCardsCatalog = new Object();
               }
               smPvPBattleData["save"][_loc4_].mPlayableCardsCatalog["card" + param2] = new Object();
               smPvPBattleData["save"][_loc4_].mPlayableCardsCatalog["card" + param2].sku = param1;
               smPvPBattleData["save"][_loc4_].mPlayableCardsCatalog["card" + param2].mSummonCooldownTurnsLeft = param3;
               smPvPBattleData["save"][_loc4_].mPlayableCardsCatalog["card" + param2].mIsOnBattlefield = false.toString();
               smPvPBattleData["save"][_loc4_].mPlayableCardsCatalog["card" + param2].mId = "-1";
               smPvPBattleData["save"][_loc4_].mPlayableCardsCatalog["card" + param2].mPlayableCardId = param2.toString();
            }
         }
      }
      
      public static function storeBFCard(param1:Boolean, param2:String, param3:Boolean, param4:FSCard, param5:String, param6:int, param7:String = "", param8:String = "false", param9:String = "", param10:String = "", param11:String = "false", param12:String = "false", param13:String = "false") : void
      {
         var _loc14_:String = null;
         var _loc15_:String = null;
         var _loc16_:Boolean = false;
         if(smPvPBattleData != null && smPvPBattleData["save"] != null && isEditable())
         {
            param3 = param4.getParentUserBattleInfo().isOwnerBattleInfo();
            _loc14_ = param3 ? "opponentBattleInfo" : "ownerBattleInfo";
            _loc15_ = param4.getId().toString();
            _loc16_ = param4.abilityAllowsMovingToAttackLane();
            if(_loc16_)
            {
               smPvPBattleData["save"]["userUsedMoveToAttackLaneAb"] = true;
            }
            if(smPvPBattleData["save"][_loc14_] != null)
            {
               if(smPvPBattleData["save"][_loc14_]["mBFCards"] == null)
               {
                  smPvPBattleData["save"][_loc14_]["mBFCards"] = new Object();
               }
               param2 = param2 != "-1" ? MOVE_ID_PREFIX + smMoveId : MOVE_ID_PREFIX + param2;
               smPvPBattleData["save"][_loc14_]["mBFCards"][param2] = new Object();
               smPvPBattleData["save"][_loc14_]["mBFCards"][param2]["card" + _loc15_] = new Object();
               smPvPBattleData["save"][_loc14_]["mBFCards"][param2]["card" + _loc15_]["sku"] = param4.getCardDef().getSku();
               smPvPBattleData["save"][_loc14_]["mBFCards"][param2]["card" + _loc15_]["mSummonCooldownTurnsLeft"] = param4.getSummonCooldownTurnsLeft().toString();
               smPvPBattleData["save"][_loc14_]["mBFCards"][param2]["card" + _loc15_]["mIsOnBattlefield"] = true.toString();
               smPvPBattleData["save"][_loc14_]["mBFCards"][param2]["card" + _loc15_]["mId"] = _loc15_;
               smPvPBattleData["save"][_loc14_]["mBFCards"][param2]["card" + _loc15_]["mPlayableCardId"] = param4.getPlayableCardId().toString();
               smPvPBattleData["save"][_loc14_]["mBFCards"][param2]["card" + _loc15_]["mDamage"] = param4.getDamage().toString();
               smPvPBattleData["save"][_loc14_]["mBFCards"][param2]["card" + _loc15_]["mDefense"] = param4.getDefense().toString();
               smPvPBattleData["save"][_loc14_]["mBFCards"][param2]["card" + _loc15_]["mLastSocketAttached"] = lastSocketIndexAttachedToOpponentSyntax(param5).toString();
               smPvPBattleData["save"][_loc14_]["mBFCards"][param2]["card" + _loc15_]["mAttachedToSocketIndex"] = convertSocketIndexToOpponentSyntax(param6).toString();
               if(param4.isUnit())
               {
                  smPvPBattleData["save"][_loc14_]["mBFCards"][param2]["card" + _loc15_]["mTurnsToBeAbleToAttack"] = FSUnit(param4).getTurnsToBeAbleToAttack().toString();
                  smPvPBattleData["save"][_loc14_]["mBFCards"][param2]["card" + _loc15_]["mTurnsInvulnerable"] = FSUnit(param4).getInvulnerableTurns().toString();
                  smPvPBattleData["save"][_loc14_]["mBFCards"][param2]["card" + _loc15_]["mTurnsUnblockable"] = FSUnit(param4).getUnblockableTurns().toString();
                  smPvPBattleData["save"][_loc14_]["mBFCards"][param2]["card" + _loc15_]["mTurnsAmountWithoutMovingToAttackLane"] = FSUnit(param4).getTurnsAmountWithoutMovingToAttackLane().toString();
                  smPvPBattleData["save"][_loc14_]["mBFCards"][param2]["card" + _loc15_]["mPromote"] = param8;
                  smPvPBattleData["save"][_loc14_]["mBFCards"][param2]["card" + _loc15_]["mDemote"] = param10;
                  smPvPBattleData["save"][_loc14_]["mBFCards"][param2]["card" + _loc15_]["mNextCardSku"] = param9;
                  smPvPBattleData["save"][_loc14_]["mBFCards"][param2]["card" + _loc15_]["mPoisonTurns"] = FSUnit(param4).getPoisonTurns().toString();
                  smPvPBattleData["save"][_loc14_]["mBFCards"][param2]["card" + _loc15_]["mPoisonDamage"] = FSUnit(param4).getPoisonDamage().toString();
               }
               smPvPBattleData["save"][_loc14_]["mBFCards"][param2]["card" + _loc15_]["mAbilityLockTargetInfo"] = param7.toString();
               smPvPBattleData["save"][_loc14_]["mBFCards"][param2]["card" + _loc15_]["mCardRectification"] = param13.toString();
               smPvPBattleData["save"][_loc14_]["mBFCards"][param2]["card" + _loc15_]["usedFast"] = param11;
               smPvPBattleData["save"][_loc14_]["mBFCards"][param2]["card" + _loc15_]["usedMoveToAttackLaneAb"] = param12;
               smPvPBattleData["onlyPlayableCards"] = false;
               smPvPBattleData["reshuffle"] = false;
               if(param1)
               {
                  increaseMoveId();
               }
            }
         }
      }
      
      public static function sendPlayableCards(param1:Boolean = false) : void
      {
         smPvPBattleData["onlyPlayableCards"] = true;
         if(param1)
         {
            smOwnerHasReshuffled = true;
            smPvPBattleData["reshuffle"] = true;
            smPvPBattleData["reshuffleUsed"] = true;
         }
         if(realTimeAllowed())
         {
            increaseMoveId();
         }
      }
      
      private static function increaseMoveId() : void
      {
         smTargetSetWaitingForStatsToFill = false;
         if(smMoveId != -1)
         {
            if(realTimeAllowed() && smPvPBattleData != null)
            {
               smPvPBattleData["dataReady"] = false;
               smPvPBattleData["save"]["moveId"] = smMoveId;
               packageSaveObjForSending(true);
            }
            ++smMoveId;
         }
      }
      
      public static function storeSacrifice(param1:String, param2:String = "") : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:String = null;
         if(smPvPBattleData != null && smPvPBattleData["save"] != null && isEditable())
         {
            _loc3_ = true;
            _loc4_ = _loc3_ ? "opponentBattleInfo" : "ownerBattleInfo";
            if(smPvPBattleData["save"][_loc4_] != null)
            {
               if(smPvPBattleData["save"][_loc4_]["mBFCards"] == null)
               {
                  smPvPBattleData["save"][_loc4_]["mBFCards"] = new Object();
               }
               param1 = param1 != "-1" ? MOVE_ID_PREFIX + smMoveId : MOVE_ID_PREFIX + param1;
               smPvPBattleData["save"][_loc4_]["mBFCards"][param1] = new Object();
               smPvPBattleData["save"][_loc4_]["mBFCards"][param1]["sacrifice"] = param2.toString();
               smPvPBattleData["save"]["userUsedSacrifice"] = true;
               smPvPBattleData["onlyPlayableCards"] = false;
               smPvPBattleData["reshuffle"] = false;
               increaseMoveId();
            }
         }
      }
      
      public static function storePower(param1:Boolean, param2:FSCard, param3:String = "") : void
      {
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         if(smPvPBattleData != null && smPvPBattleData["save"] != null && isEditable())
         {
            _loc4_ = true;
            _loc5_ = _loc4_ ? "opponentBattleInfo" : "ownerBattleInfo";
            if(smPvPBattleData["save"][_loc5_] != null)
            {
               if(smPvPBattleData["save"][_loc5_]["mBFCards"] == null)
               {
                  smPvPBattleData["save"][_loc5_]["mBFCards"] = new Object();
               }
               _loc6_ = MOVE_ID_PREFIX + smMoveId;
               smPvPBattleData["save"][_loc5_]["mBFCards"][_loc6_] = new Object();
               smPvPBattleData["save"][_loc5_]["mBFCards"][_loc6_]["sacrifice"] = abilityTargetInfoToOpponentSyntax(param3);
               _loc7_ = param2.getId().toString();
               _loc8_ = param2.getAbilities()[0] ? param2.getAbilities()[0].getAbilityDef().getSku() : "";
               smPvPBattleData["save"][_loc5_]["mBFCards"][_loc6_]["card" + _loc7_] = new Object();
               smPvPBattleData["save"][_loc5_]["mBFCards"][_loc6_]["card" + _loc7_].sku = param2.getCardDef().getSku();
               smPvPBattleData["save"][_loc5_]["mBFCards"][_loc6_]["card" + _loc7_].mIsOnBattlefield = true.toString();
               smPvPBattleData["save"][_loc5_]["mBFCards"][_loc6_]["card" + _loc7_].mId = _loc7_;
               smPvPBattleData["save"][_loc5_]["mBFCards"][_loc6_]["card" + _loc7_].mPlayableCardId = param2.getPlayableCardId().toString();
               smPvPBattleData["save"][_loc5_]["mBFCards"][_loc6_]["card" + _loc7_].mAbilitySku = _loc8_;
               smPvPBattleData["save"]["userUsedSacrifice"] = true;
               smPvPBattleData["onlyPlayableCards"] = false;
               smPvPBattleData["reshuffle"] = false;
               if(param1)
               {
                  increaseMoveId();
               }
            }
         }
      }
      
      public static function storeStopResumedPvPActions(param1:String = "") : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:String = null;
         if(smPvPBattleData != null && smPvPBattleData["save"] != null && isEditable())
         {
            if(smPvPBattleData["save"]["stopResumedPvPActions"] == null || smPvPBattleData["save"]["stopResumedPvPActions"] == false)
            {
               _loc2_ = true;
               _loc3_ = _loc2_ ? "opponentBattleInfo" : "ownerBattleInfo";
               if(smPvPBattleData["save"][_loc3_] != null)
               {
                  if(smPvPBattleData["save"][_loc3_]["mBFCards"] == null)
                  {
                     smPvPBattleData["save"][_loc3_]["mBFCards"] = new Object();
                  }
                  param1 = param1 != "-1" ? MOVE_ID_PREFIX + smMoveId : MOVE_ID_PREFIX + param1;
                  smPvPBattleData["save"][_loc3_]["mBFCards"][param1] = new Object();
                  smPvPBattleData["save"][_loc3_]["mBFCards"][param1]["stopResumedPvPActions"] = true;
                  smPvPBattleData["save"]["stopResumedPvPActions"] = true;
                  smPvPBattleData["onlyPlayableCards"] = false;
                  smPvPBattleData["reshuffle"] = false;
                  increaseMoveId();
               }
            }
         }
      }
      
      public static function updateStoredBFCardWithNewPosition(param1:FSCard, param2:int, param3:int = -1) : void
      {
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc12_:Boolean = false;
         var _loc13_:Object = null;
         var _loc14_:Vector.<Object> = null;
         var _loc15_:FSAttachment = null;
         var _loc16_:Vector.<Object> = null;
         var _loc17_:String = null;
         var _loc18_:String = null;
         var _loc19_:Boolean = false;
         var _loc20_:int = 0;
         var _loc21_:Boolean = false;
         var _loc22_:Boolean = false;
         var _loc23_:String = null;
         if(Boolean(smPvPBattleData) && Boolean(smPvPBattleData["save"] != null) && isEditable())
         {
            _loc4_ = param1.getParentUserBattleInfo().isOwnerBattleInfo();
            _loc5_ = _loc4_ ? "opponentBattleInfo" : "ownerBattleInfo";
            _loc6_ = param1.isUnit() && param1.abilityAllowsMovement();
            _loc7_ = smPvPBattleData["save"]["userUsedFast"] ? smPvPBattleData["save"]["userUsedFast"] == true : false;
            _loc8_ = smPvPBattleData["save"]["userUsedSacrifice"] ? smPvPBattleData["save"]["userUsedSacrifice"] == true : false;
            _loc9_ = true;
            _loc10_ = _loc7_ || _loc8_ || _loc9_;
            _loc11_ = param1.abilityAllowsMovingToAttackLane();
            _loc12_ = smPvPBattleData["save"]["userUsedMoveToAttackLaneAb"] ? smPvPBattleData["save"]["userUsedMoveToAttackLaneAb"] == true : false;
            _loc13_ = getSavedObjectByCardId(!_loc4_,param1.getId());
            if(_loc13_ != null && param1.getTurnsAlive() == 0 && !_loc7_ && !_loc10_ && (!_loc12_ && !_loc11_))
            {
               _loc13_["mAttachedToSocketIndex"] = convertSocketIndexToOpponentSyntax(param2).toString();
            }
            else
            {
               if(_loc6_ && param3 != -1 || _loc7_)
               {
                  _loc20_ = getHighestMoveIdForSavedTurn(!_loc4_);
                  _loc13_ = getSavedObjectByMoveIdAndCardId(!_loc4_,param1.getId(),MOVE_ID_PREFIX + _loc20_);
                  _loc21_ = _loc13_ != null && _loc13_["usedFast"] != null ? _loc13_["usedFast"] == "true" : false;
                  if(!_loc21_)
                  {
                     storeBFCard(true,"",_loc4_,param1,"bf_" + param3,param2,"","false","true","","true");
                     smPvPBattleData["save"]["userUsedFast"] = true;
                  }
                  else
                  {
                     _loc13_ = getSavedObjectByMoveIdAndCardId(!_loc4_,param1.getId(),MOVE_ID_PREFIX + _loc20_);
                     _loc13_["mAttachedToSocketIndex"] = convertSocketIndexToOpponentSyntax(param2).toString();
                  }
                  return;
               }
               if(_loc10_)
               {
                  storeBFCard(true,"",_loc4_,param1,"bf_" + param3,param2,"","false","true","","true");
                  return;
               }
               if(_loc11_ || _loc12_)
               {
                  _loc20_ = getHighestMoveIdForSavedTurn(!_loc4_);
                  _loc13_ = getSavedObjectByMoveIdAndCardId(!_loc4_,param1.getId(),MOVE_ID_PREFIX + _loc20_);
                  _loc22_ = _loc13_ != null && _loc13_["usedMoveToAttackLaneAb"] != null ? _loc13_["usedMoveToAttackLaneAb"] == "true" : false;
                  if(!_loc22_)
                  {
                     storeBFCard(true,"",_loc4_,param1,"bf_" + param3,param2,"","false","","","false","true");
                  }
                  else
                  {
                     _loc13_ = getSavedObjectByMoveIdAndCardId(!_loc4_,param1.getId(),MOVE_ID_PREFIX + _loc20_);
                     _loc13_["mAttachedToSocketIndex"] = convertSocketIndexToOpponentSyntax(param2).toString();
                  }
                  return;
               }
            }
            _loc14_ = getObjectsByCardId(!_loc4_,param1.getId());
            _loc13_ = null;
            for each(_loc13_ in _loc14_)
            {
               if(_loc13_ != null && (_loc13_["mPromote"] == "true" || _loc13_["mDemote"] == "true"))
               {
                  _loc13_["mAttachedToSocketIndex"] = convertSocketIndexToOpponentSyntax(param2).toString();
                  _loc13_["mLastSocketAttached"] = "bf_" + convertSocketIndexToOpponentSyntax(param2).toString();
               }
            }
            for each(_loc15_ in FSUnit(param1).getAttachments())
            {
               if(_loc15_.getTurnsAlive() == 0)
               {
                  _loc13_ = getSavedObjectByCardId(!_loc4_,_loc15_.getId());
                  if(_loc13_ != null)
                  {
                     _loc13_["mAttachedToSocketIndex"] = convertSocketIndexToOpponentSyntax(param2).toString();
                  }
               }
            }
            _loc13_ = null;
            _loc16_ = getAllTurnObjects(!_loc4_);
            _loc17_ = "";
            _loc18_ = "";
            for each(_loc13_ in _loc16_)
            {
               _loc19_ = _loc13_ is String;
               if(_loc13_ != null && !_loc19_)
               {
                  if(_loc13_["mAbilityLockTargetInfo"] != "")
                  {
                     _loc17_ = _loc13_["mAbilityLockTargetInfo"];
                     _loc18_ = _loc4_ ? "owner_" : "opponent_";
                     _loc18_ = _loc18_ + ("card_" + param3);
                     _loc18_ = abilityTargetInfoToOpponentSyntax(_loc18_);
                     if(_loc18_ == _loc17_)
                     {
                        _loc23_ = _loc4_ ? "owner_" : "opponent_";
                        _loc23_ = _loc23_ + ("card_" + param2);
                        _loc13_["mAbilityLockTargetInfo"] = abilityTargetInfoToOpponentSyntax(_loc23_);
                     }
                  }
                  else if(_loc13_["mAbilityRandomTargetInfo"] != "")
                  {
                     _loc17_ = _loc13_["mAbilityRandomTargetInfo"];
                     _loc18_ = _loc4_ ? "owner_" : "opponent_";
                     _loc18_ = _loc18_ + ("card_" + param3);
                     _loc18_ = abilityTargetInfoToOpponentSyntax(_loc18_);
                     if(_loc18_ == _loc17_)
                     {
                        _loc23_ = _loc4_ ? "owner_" : "opponent_";
                        _loc23_ = _loc23_ + ("card_" + param2);
                        _loc13_["mAbilityRandomTargetInfo"] = abilityTargetInfoToOpponentSyntax(_loc23_);
                     }
                  }
               }
            }
         }
      }
      
      private static function stillNeedsInfoToFill(param1:FSCard) : Boolean
      {
         var _loc2_:Boolean = param1.hasRandomStatsAbilities();
         var _loc3_:Boolean = param1.hasMulticastAbilities();
         return _loc2_ || _loc3_;
      }
      
      public static function updateStoredBFCardWithAbilityLockTargetInfo(param1:FSCard, param2:String) : void
      {
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         if(param1 != null)
         {
            _loc3_ = abilityTargetInfoToOpponentSyntax(param2);
            if(realTimeAllowed())
            {
               _loc4_ = InstanceMng.getBattleEngine().isOwnerTurn();
               storeBFCard(false,"",_loc4_,param1,param1.getStoredOldSocketIndexCode(),param1.getAttachedToSocket().getSocketIndex());
            }
            if(smPvPBattleData != null && smPvPBattleData["save"] != null && isEditable() && param1.getParentUserBattleInfo() != null)
            {
               _loc5_ = param1.getParentUserBattleInfo().isOwnerBattleInfo();
               _loc6_ = param1.getId();
               _loc7_ = getSavedObjectByCardId(!_loc5_,_loc6_);
               if(_loc7_)
               {
                  _loc7_["mAbilityLockTargetInfo"] = _loc3_;
               }
            }
            smTargetSetWaitingForStatsToFill = stillNeedsInfoToFill(param1);
            if(realTimeAllowed() && !smTargetSetWaitingForStatsToFill)
            {
               increaseMoveId();
            }
         }
      }
      
      public static function updateStoredBFCardWithAbilityRandomTargetInfo(param1:FSCard, param2:String) : void
      {
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         if(param1 != null)
         {
            _loc3_ = abilityTargetInfoToOpponentSyntax(param2);
            if(realTimeAllowed())
            {
               _loc4_ = InstanceMng.getBattleEngine().isOwnerTurn();
               storeBFCard(false,"",_loc4_,param1,param1.getStoredOldSocketIndexCode(),param1.getAttachedToSocket().getSocketIndex());
            }
            if(smPvPBattleData != null && smPvPBattleData["save"] != null && isEditable())
            {
               _loc5_ = param1.getParentUserBattleInfo().isOwnerBattleInfo();
               _loc6_ = param1.getId();
               _loc7_ = getSavedObjectByCardId(!_loc5_,_loc6_);
               if(_loc7_)
               {
                  _loc7_["mAbilityRandomTargetInfo"] = _loc3_;
               }
            }
            smTargetSetWaitingForStatsToFill = stillNeedsInfoToFill(param1);
            if(realTimeAllowed() && !smTargetSetWaitingForStatsToFill)
            {
               increaseMoveId();
            }
         }
      }
      
      public static function updateStoredBFCardWithAbilityRandomValueInfo(param1:FSCard, param2:*, param3:int = 0, param4:int = 0, param5:int = 0, param6:int = 0, param7:int = 0) : void
      {
         var _loc8_:Boolean = false;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:int = 0;
         var _loc12_:Boolean = false;
         var _loc13_:String = null;
         var _loc14_:int = 0;
         var _loc15_:Object = null;
         var _loc16_:String = null;
         var _loc17_:int = 0;
         if(param1)
         {
            if(realTimeAllowed() && !smTargetSetWaitingForStatsToFill && param6 == 0)
            {
               _loc8_ = InstanceMng.getBattleEngine().isOwnerTurn();
               _loc9_ = param1.getStoredEligibleItemCode();
               _loc10_ = param1.getStoredAbilitySku();
               if(param1 is FSAction)
               {
                  storeBFAction(false,"",_loc8_,param1,param1.getStoredOldSocketIndexCode(),_loc9_,_loc10_);
               }
               else if(param1 is FSPower)
               {
                  storePower(false,param1,_loc9_);
               }
               else
               {
                  _loc11_ = param1 is FSPower ? -1 : param1.getAttachedToSocket().getSocketIndex();
                  storeBFCard(false,"",_loc8_,param1,param1.getStoredOldSocketIndexCode(),_loc11_);
               }
            }
            if(smPvPBattleData != null && smPvPBattleData["save"] != null && isEditable())
            {
               _loc12_ = param1.getParentUserBattleInfo().isOwnerBattleInfo();
               _loc13_ = _loc12_ ? "opponentBattleInfo" : "ownerBattleInfo";
               _loc14_ = param1.getId();
               _loc15_ = getSavedObjectByCardId(!_loc12_,_loc14_);
               if(_loc15_)
               {
                  _loc16_ = getAbilityLockInfoByTarget(param2);
                  if(_loc15_["targets"] == null)
                  {
                     _loc15_["targets"] = new Array();
                  }
                  _loc17_ = int((_loc15_["targets"] as Array).length);
                  _loc15_["targets"][_loc17_] = {};
                  _loc15_["targets"][_loc17_]["targetInfo"] = _loc16_;
                  _loc15_["targets"][_loc17_]["mRandomDamage"] = param3;
                  _loc15_["targets"][_loc17_]["mRandomDefense"] = param4;
                  _loc15_["targets"][_loc17_]["mRandomHeal"] = param5;
               }
            }
            if(realTimeAllowed() && param6 == param7 - 1)
            {
               increaseMoveId();
            }
         }
      }
      
      private static function getAbilityLockInfoByTarget(param1:*, param2:Boolean = true) : String
      {
         var _loc3_:String = null;
         var _loc5_:UserBattleInfo = null;
         var _loc6_:FSCardSocket = null;
         var _loc4_:String = "";
         if(param1 != null && param1 is FSCard)
         {
            _loc5_ = FSCard(param1).getParentUserBattleInfo();
            _loc6_ = FSCard(param1).getAttachedToSocket();
            if(!(Boolean(_loc5_) && Boolean(_loc6_)))
            {
               return "";
            }
            _loc3_ = _loc5_.isOwnerBattleInfo() ? "owner_" : "opponent_";
            _loc3_ += "card_" + _loc6_.getSocketIndex();
         }
         else
         {
            _loc3_ = UserBattleInfo(param1).isOwnerBattleInfo() ? "owner_portrait" : "opponent_portrait";
         }
         return param2 ? abilityTargetInfoToOpponentSyntax(_loc3_) : _loc3_;
      }
      
      public static function getRandomAttributeFromTarget(param1:*, param2:String, param3:Object) : int
      {
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc4_:int = 0;
         if(Boolean(param3) && Boolean(param1))
         {
            _loc5_ = getAbilityLockInfoByTarget(param1,false);
            _loc6_ = param3["targets"];
            if((Boolean(_loc6_)) && _loc6_.length > 0)
            {
               _loc7_ = 0;
               while(_loc7_ < _loc6_.length)
               {
                  if(param3["targets"][_loc7_]["targetInfo"] == _loc5_)
                  {
                     if(param3["targets"][_loc7_][param2] != null)
                     {
                        _loc4_ = int(param3["targets"][_loc7_][param2]);
                     }
                  }
                  _loc7_++;
               }
            }
         }
         return _loc4_;
      }
      
      public static function getRandomAttributeTargetPvPObject(param1:*, param2:Object) : Object
      {
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc3_:Object = null;
         if(Boolean(param2) && Boolean(param1))
         {
            _loc4_ = getAbilityLockInfoByTarget(param1,false);
            _loc5_ = param2["targets"];
            if(Boolean((_loc5_) && _loc5_.length > 0) && Boolean(_loc4_) && _loc4_ != "")
            {
               _loc6_ = 0;
               while(_loc6_ < _loc5_.length)
               {
                  if(param2["targets"][_loc6_]["targetInfo"] == _loc4_)
                  {
                     return param2["targets"][_loc6_];
                  }
                  _loc6_++;
               }
            }
         }
         return _loc3_;
      }
      
      public static function updateStoredBFCardWithAbilityRecruitInfo(param1:FSCard, param2:String) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         if(param1 != null)
         {
            if(realTimeAllowed())
            {
               _loc3_ = InstanceMng.getBattleEngine().isOwnerTurn();
               storeBFCard(false,"",_loc3_,param1,param1.getStoredOldSocketIndexCode(),param1.getAttachedToSocket().getSocketIndex());
            }
            if(smPvPBattleData != null && smPvPBattleData["save"] != null && isEditable())
            {
               _loc4_ = param1.getParentUserBattleInfo().isOwnerBattleInfo();
               _loc5_ = _loc4_ ? "opponentBattleInfo" : "ownerBattleInfo";
               _loc6_ = param1.getId();
               _loc7_ = getSavedObjectByCardId(!_loc4_,_loc6_);
               if(_loc7_)
               {
                  _loc7_["mRecruitCard"] = param2;
               }
            }
            if(realTimeAllowed())
            {
               increaseMoveId();
            }
         }
      }
      
      public static function updateStoredBFCardWithMulticastFactor(param1:FSCard, param2:int) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Boolean = false;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:Object = null;
         if(param1 != null)
         {
            if(realTimeAllowed() && !smTargetSetWaitingForStatsToFill)
            {
               _loc3_ = InstanceMng.getBattleEngine().isOwnerTurn();
               _loc4_ = param1.getStoredEligibleItemCode();
               _loc5_ = param1.getStoredAbilitySku();
               if(param1 is FSAction)
               {
                  storeBFAction(false,"",_loc3_,param1,param1.getStoredOldSocketIndexCode(),_loc4_,_loc5_);
               }
               else if(param1 is FSPower)
               {
                  storePower(false,param1,_loc4_);
               }
               else
               {
                  storeBFCard(false,"",_loc3_,param1,param1.getStoredOldSocketIndexCode(),param1.getAttachedToSocket().getSocketIndex());
               }
            }
            if(smPvPBattleData != null && smPvPBattleData["save"] != null && isEditable())
            {
               _loc6_ = param1.getParentUserBattleInfo().isOwnerBattleInfo();
               _loc7_ = _loc6_ ? "opponentBattleInfo" : "ownerBattleInfo";
               _loc8_ = param1.getId();
               _loc9_ = getSavedObjectByCardId(!_loc6_,_loc8_);
               if(_loc9_)
               {
                  _loc9_["mMulticastFactor"] = param2;
               }
            }
            if(realTimeAllowed())
            {
               increaseMoveId();
            }
         }
      }
      
      public static function revertLastMovement() : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         if(realTimeAllowed())
         {
            return;
         }
         if(smPvPBattleData != null && smPvPBattleData["save"] != null)
         {
            _loc1_ = "opponentBattleInfo";
            _loc2_ = getHighestMoveIdForSavedTurn(false);
            smPvPBattleData["save"][_loc1_]["mBFCards"][MOVE_ID_PREFIX + _loc2_] = null;
            delete smPvPBattleData["save"][_loc1_]["mBFCards"][MOVE_ID_PREFIX + _loc2_];
            if(_loc2_ == 1)
            {
               smPvPBattleData["save"][_loc1_]["mBFCards"] = null;
               delete smPvPBattleData["save"][_loc1_]["mBFCards"];
            }
         }
      }
      
      public static function getSavedObjectByCardId(param1:Boolean, param2:int, param3:Boolean = false) : Object
      {
         var _loc7_:int = 0;
         var _loc8_:* = 0;
         var _loc4_:Object = null;
         var _loc5_:Object = smPvPBattleData["save"];
         var _loc6_:String = param1 ? "ownerBattleInfo" : "opponentBattleInfo";
         if(_loc5_[_loc6_]["mBFCards"] != null)
         {
            _loc8_ = _loc7_ = getHighestMoveIdForSavedTurn(param1);
            while(_loc8_ >= -1)
            {
               if(_loc5_[_loc6_]["mBFCards"][MOVE_ID_PREFIX + _loc8_] != null)
               {
                  if(_loc5_[_loc6_]["mBFCards"][MOVE_ID_PREFIX + _loc8_]["card" + param2] != null)
                  {
                     if(!param3)
                     {
                        return _loc5_[_loc6_]["mBFCards"][MOVE_ID_PREFIX + _loc8_]["card" + param2];
                     }
                     if(_loc5_[_loc6_]["mBFCards"][MOVE_ID_PREFIX + _loc8_]["card" + param2]["usedFast"] == "true")
                     {
                        return _loc5_[_loc6_]["mBFCards"][MOVE_ID_PREFIX + _loc8_]["card" + param2];
                     }
                  }
               }
               _loc8_--;
            }
         }
         return _loc4_;
      }
      
      public static function getObjectsByCardId(param1:Boolean, param2:int) : Vector.<Object>
      {
         var _loc5_:FSCard = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc3_:Vector.<Object> = null;
         var _loc4_:Object = smPvPBattleData["save"];
         var _loc6_:String = param1 ? "ownerBattleInfo" : "opponentBattleInfo";
         if(_loc4_[_loc6_]["mBFCards"] != null)
         {
            _loc7_ = getHighestMoveIdForSavedTurn(param1);
            _loc8_ = -1;
            while(_loc8_ <= _loc7_)
            {
               if(_loc4_[_loc6_]["mBFCards"][MOVE_ID_PREFIX + _loc8_] != null)
               {
                  if(_loc4_[_loc6_]["mBFCards"][MOVE_ID_PREFIX + _loc8_]["card" + param2] != null)
                  {
                     if(_loc3_ == null)
                     {
                        _loc3_ = new Vector.<Object>();
                     }
                     _loc3_.push(_loc4_[_loc6_]["mBFCards"][MOVE_ID_PREFIX + _loc8_]["card" + param2]);
                  }
               }
               _loc8_++;
            }
         }
         return _loc3_;
      }
      
      private static function getAllTurnObjects(param1:Boolean) : Vector.<Object>
      {
         var _loc4_:FSCard = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Object = null;
         var _loc2_:Vector.<Object> = null;
         var _loc3_:Object = smPvPBattleData["save"];
         var _loc5_:String = param1 ? "ownerBattleInfo" : "opponentBattleInfo";
         if(_loc3_[_loc5_]["mBFCards"] != null)
         {
            _loc6_ = getHighestMoveIdForSavedTurn(param1);
            _loc7_ = -1;
            while(_loc7_ <= _loc6_)
            {
               if(_loc3_[_loc5_]["mBFCards"][MOVE_ID_PREFIX + _loc7_] != null)
               {
                  for each(_loc8_ in _loc3_[_loc5_]["mBFCards"][MOVE_ID_PREFIX + _loc7_])
                  {
                     if(_loc2_ == null)
                     {
                        _loc2_ = new Vector.<Object>();
                     }
                     _loc2_.push(_loc8_);
                  }
               }
               _loc7_++;
            }
         }
         return _loc2_;
      }
      
      public static function getSavedObjectByMoveIdAndCardId(param1:Boolean, param2:int, param3:String) : Object
      {
         var _loc6_:FSCard = null;
         var _loc4_:Object = null;
         var _loc5_:Object = smPvPBattleData["save"];
         var _loc7_:String = param1 ? "ownerBattleInfo" : "opponentBattleInfo";
         if(_loc5_[_loc7_]["mBFCards"] != null)
         {
            if(_loc5_[_loc7_]["mBFCards"][param3] != null)
            {
               if(_loc5_[_loc7_]["mBFCards"][param3]["card" + param2] != null)
               {
                  return _loc5_[_loc7_]["mBFCards"][param3]["card" + param2];
               }
            }
         }
         return _loc4_;
      }
      
      public static function getSavedSacrificeTargetByMoveId(param1:Boolean, param2:String) : String
      {
         var _loc5_:FSCard = null;
         var _loc3_:String = null;
         var _loc4_:Object = smPvPBattleData["save"];
         var _loc6_:String = param1 ? "ownerBattleInfo" : "opponentBattleInfo";
         if(_loc4_[_loc6_]["mBFCards"] != null)
         {
            if(_loc4_[_loc6_]["mBFCards"][param2] != null)
            {
               if(_loc4_[_loc6_]["mBFCards"][param2]["sacrifice"] != null)
               {
                  return _loc4_[_loc6_]["mBFCards"][param2]["sacrifice"];
               }
            }
         }
         return _loc3_;
      }
      
      public static function getHighestMoveIdForSavedTurn(param1:Boolean) : int
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Object = smPvPBattleData["save"];
         if(_loc3_ != null)
         {
            _loc4_ = param1 ? "ownerBattleInfo" : "opponentBattleInfo";
            if(_loc3_[_loc4_]["mBFCards"] != null)
            {
               _loc5_ = 0;
               _loc6_ = 100;
               _loc5_ = 0;
               while(_loc5_ <= _loc6_)
               {
                  _loc2_ = _loc3_[_loc4_]["mBFCards"][MOVE_ID_PREFIX + _loc5_] != null ? _loc5_ : _loc2_;
                  _loc5_++;
               }
            }
         }
         return _loc2_;
      }
      
      public static function turnEnded() : Boolean
      {
         return smPvPBattleData != null && smPvPBattleData["turnEnded"] == true;
      }
      
      public static function storeBFAction(param1:Boolean, param2:String, param3:Boolean, param4:FSCard, param5:String, param6:String, param7:String) : void
      {
         var _loc8_:String = null;
         var _loc9_:String = null;
         if(smPvPBattleData != null && smPvPBattleData["save"] != null && isEditable())
         {
            param3 = param4.getParentUserBattleInfo().isOwnerBattleInfo();
            _loc8_ = param3 ? "opponentBattleInfo" : "ownerBattleInfo";
            _loc9_ = param4.getId().toString();
            if(smPvPBattleData["save"][_loc8_] != null)
            {
               if(smPvPBattleData["save"][_loc8_]["mBFCards"] == null)
               {
                  smPvPBattleData["save"][_loc8_]["mBFCards"] = new Object();
               }
               param2 = MOVE_ID_PREFIX + smMoveId;
               if(smPvPBattleData["save"][_loc8_]["mBFCards"][param2] == null)
               {
                  smPvPBattleData["save"][_loc8_]["mBFCards"][param2] = new Object();
               }
               smPvPBattleData["save"][_loc8_]["mBFCards"][param2]["card" + _loc9_] = new Object();
               smPvPBattleData["save"][_loc8_]["mBFCards"][param2]["card" + _loc9_].sku = param4.getCardDef().getSku();
               smPvPBattleData["save"][_loc8_]["mBFCards"][param2]["card" + _loc9_].mIsOnBattlefield = true.toString();
               smPvPBattleData["save"][_loc8_]["mBFCards"][param2]["card" + _loc9_].mId = _loc9_;
               smPvPBattleData["save"][_loc8_]["mBFCards"][param2]["card" + _loc9_].mPlayableCardId = param4.getPlayableCardId().toString();
               smPvPBattleData["save"][_loc8_]["mBFCards"][param2]["card" + _loc9_].mLastSocketAttached = lastSocketIndexAttachedToOpponentSyntax(param5);
               smPvPBattleData["save"][_loc8_]["mBFCards"][param2]["card" + _loc9_].mAbilitySku = param7;
               smPvPBattleData["save"][_loc8_]["mBFCards"][param2]["card" + _loc9_].mAbilityLockTargetInfo = abilityTargetInfoToOpponentSyntax(param6);
               smPvPBattleData["onlyPlayableCards"] = false;
               smPvPBattleData["reshuffle"] = false;
               if(param1)
               {
                  increaseMoveId();
               }
            }
         }
      }
      
      private static function abilityTargetInfoToOpponentSyntax(param1:String) : String
      {
         var _loc4_:String = null;
         var _loc2_:String = "";
         var _loc3_:Array = param1.split("_");
         if(_loc3_ != null)
         {
            if(_loc3_.length > 0)
            {
               _loc4_ = _loc3_[0] == "opponent" ? "owner" : "opponent";
            }
            switch(_loc3_.length)
            {
               case 0:
                  _loc2_ = param1;
                  break;
               case 2:
                  _loc2_ = _loc4_ + "_" + _loc3_[1];
                  break;
               case 3:
                  _loc2_ = _loc4_ + "_" + _loc3_[1] + "_" + convertSocketIndexToOpponentSyntax(_loc3_[2]);
            }
         }
         return _loc2_;
      }
      
      private static function lastSocketIndexAttachedToOpponentSyntax(param1:String) : String
      {
         if(param1 == "" || param1 == null)
         {
            return "";
         }
         var _loc2_:String = "";
         var _loc3_:Array = param1.split("_");
         if(_loc3_ != null)
         {
            if(InstanceMng.getBattleEngine().getLevelDef().getRowsAmount() > 1)
            {
               _loc2_ = _loc3_[0] == "side" ? _loc3_[0] + "_" + _loc3_[1] : _loc3_[0] + "_" + convertSocketIndexToOpponentSyntax(_loc3_[1]);
            }
            else
            {
               _loc2_ = param1;
            }
         }
         return _loc2_;
      }
      
      public static function convertSocketIndexToOpponentSyntax(param1:int) : int
      {
         var _loc2_:int = 0;
         var _loc3_:Dictionary = null;
         if(InstanceMng.getBattleEngine().getLevelDef().getRowsAmount() > 1)
         {
            _loc3_ = new Dictionary(true);
            _loc3_[0] = 3;
            _loc3_[1] = 4;
            _loc3_[2] = 5;
            _loc3_[3] = 0;
            _loc3_[4] = 1;
            _loc3_[5] = 2;
            _loc2_ = int(_loc3_[param1]);
         }
         else
         {
            _loc2_ = param1;
         }
         return _loc2_;
      }
      
      public static function printCurrentSaveData() : void
      {
         var _loc1_:String = "** SAVE DATA:" + TimerUtil.dateFromMs(TimerUtil.currentTimeMillis()) + " **";
         if(Utils.isMobile() && smPvPBattleData != null && smPvPBattleData["save"] != null)
         {
            _loc1_ += "\n ";
            _loc1_ += ObjectUtil.toString(smPvPBattleData["save"]);
         }
         _loc1_ += "\n..**  END OF SAVE DATA **..";
         FSDebug.debugTrace(_loc1_);
      }
      
      public static function getTimeTextLeft(param1:Boolean = false, param2:int = 0) : String
      {
         refreshExpirationTimeLeft(param2);
         if(param1)
         {
            return TimerUtil.getTimeTextFromMs(smExpirationTimeLeft,null,null,null,"",true,false);
         }
         return TimerUtil.getTimeTextFromMs(smExpirationTimeLeft,null,null,":","",true,false);
      }
      
      public static function refreshExpirationTimeLeft(param1:int = 0) : void
      {
         smExpirationTimeLeft = smExpirationTime - (TimerUtil.currentTimeMillis() + param1);
      }
      
      public static function isEditable() : Boolean
      {
         var _loc1_:BattleEngine = InstanceMng.getBattleEngine();
         return _loc1_ && _loc1_.isOnlineMatch() && _loc1_.isOwnerTurn() && _loc1_.getPlayersStateId() == BattleEngine.STATE_OWNER_MOVING_CARDS;
      }
      
      public static function checkIfPopupShownStillOpenForPvPOpponentFound(param1:String) : void
      {
         if(smTimeLeftAcceptOpponentFound > 0)
         {
            FSDebug.debugTrace("[checkIfPopupShownStillOpenForPvPOpponentFound] - smTimeLeftAcceptOpponentFound");
            if(InstanceMng.getPopupMng().getPopupShown() is PopupOpponentFound)
            {
               Utils.removeLog();
            }
            else
            {
               smTimeLeftAcceptOpponentFound = smTimeLeftAcceptOpponentFound - 1;
               Utils.setLogText(TextManager.getText("TID_PVP_CLOSE_POPUP") + " " + smTimeLeftAcceptOpponentFound,false,false,false);
               TweenMax.delayedCall(1,checkIfPopupShownStillOpenForPvPOpponentFound,[param1]);
            }
         }
         else if(smTimeLeftAcceptOpponentFound <= 0)
         {
            Utils.setLogText(TextManager.getText("TID_PVP_CANCELLED"),true);
            InstanceMng.getPopupMng().cleanPopupInBackground();
            removeFromPvPQueue(true);
         }
      }
      
      public static function onOpponentFoundNotifReceived(param1:String, param2:Object, param3:Boolean = false, param4:Boolean = false) : void
      {
         if(!smUserInPvPBattle)
         {
            if(smUserInPvPQueue || param4 || !smUserInPvPQueue && param3)
            {
               smCurrentMatchId = param1;
               smMatchActionId = -1;
               smOpponentHasReshuffled = false;
               smOwnerHasReshuffled = false;
               smServerMatchData = null;
               DictionaryUtils.clearDictionary(smMovesPool);
               smMovesPool = null;
               smPlayingAgainstBOT = param2.hasOwnProperty("botMatch") ? Boolean(param2["botMatch"]) : false;
               smPlayingAgainstOfflineDeck = param2.hasOwnProperty("isOfflineMatch") ? Boolean(param2["isOfflineMatch"]) : false;
               if(Boolean(InstanceMng.getPopupMng().getPopupShown()) && InstanceMng.getPopupMng().getPopupShown() is PopupSearchingPvPOpponent)
               {
                  PopupSearchingPvPOpponent(InstanceMng.getPopupMng().getPopupShown()).enableCloseButton(false);
               }
               TweenMax.delayedCall(1,onGetMatchInfoDoubleCheckUsersOK,[param2]);
               Utils.playSound(Constants.SOUND_PVP_FOUND,SoundManager.TYPE_SFX);
               InstanceMng.getApplication().vibrate();
            }
         }
         else if(!param3)
         {
            enqueueInPvP();
         }
      }
      
      private static function onGetMatchInfoDoubleCheckUsersOK(param1:Object) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Popup = null;
         var _loc4_:Boolean = false;
         var _loc5_:Dictionary = null;
         var _loc6_:int = 0;
         if(param1 != null && param1.status != null && param1.status != MATCH_STATUS_DEAD)
         {
            _loc2_ = param1.u1 != null && param1.u1.uid == InstanceMng.getServerConnection().getUserId() || param1.u2 != null && param1.u2.uid == InstanceMng.getServerConnection().getUserId();
            if(_loc2_)
            {
               _loc3_ = InstanceMng.getPopupMng().getPopupShown();
               if(!smUserSettingUpForMatch && _loc3_ == null || _loc3_ != null && !(_loc3_ is PopupOpponentFound) && !(_loc3_ is PopupWaitingForOpponent))
               {
                  smUserSettingUpForMatch = true;
                  smTimeLeftAcceptOpponentFound = smPvPOpponentFoundTime;
                  _loc4_ = _loc3_ != null;
                  if((_loc4_) || Root.assets.isLoading)
                  {
                     FSDebug.debugTrace("[TYPE_NEW_MATCH] - POPUP SHOWN");
                     if(_loc3_ is PopupSearchingPvPOpponent)
                     {
                        InstanceMng.getPopupMng().closePopupShown();
                        InstanceMng.getPopupMng().openOpponentFoundPopup(Utils.getDataId(param1),param1,TextManager.getText("TID_PVP_OPPONENT_ACCEPTED"),param1);
                        return;
                     }
                     Utils.setLogText(TextManager.getText("TID_PVP_CLOSE_POPUP") + " " + smTimeLeftAcceptOpponentFound,false,false,false);
                     TweenMax.delayedCall(1,checkIfPopupShownStillOpenForPvPOpponentFound,[smCurrentMatchId]);
                  }
                  if(param1.matchType == "FRIENDLY")
                  {
                     if(param1.u1.uid == InstanceMng.getServerConnection().getUserId())
                     {
                        InstanceMng.getPopupMng().openOpponentFoundPopup(smCurrentMatchId,param1,TextManager.getText("TID_PVP_FB_REQUEST"),param1);
                     }
                     else
                     {
                        _loc5_ = InstanceMng.getUserDataMng().getOwnerUserData().getCardCollection();
                        _loc6_ = DictionaryUtils.getCatalogCardsAmountCheckingRestrictions(_loc5_,true,Config.getConfig().getDeckCardsAmount());
                        if(_loc6_ >= Config.getConfig().getDeckCardsAmount())
                        {
                           InstanceMng.getPopupMng().openOpponentFoundPopup(smCurrentMatchId,param1,TextManager.getText("TID_PVP_FB_REQUEST"),param1,true,true);
                        }
                        else
                        {
                           removeFromPvPQueue(true);
                           Utils.setLogText(TextManager.getText("TID_PVP_FB_REQUIREMENTS"),true);
                        }
                     }
                  }
                  else
                  {
                     InstanceMng.getPopupMng().openOpponentFoundPopup(smCurrentMatchId,param1,TextManager.getText("TID_PVP_OPPONENT_ACCEPTED"),param1);
                  }
               }
            }
            else if(Boolean(InstanceMng.getPopupMng().getPopupShown()) && InstanceMng.getPopupMng().getPopupShown() is PopupSearchingPvPOpponent)
            {
               PopupSearchingPvPOpponent(InstanceMng.getPopupMng().getPopupShown()).enableCloseButton(true);
            }
         }
         else if(Boolean(InstanceMng.getPopupMng().getPopupShown()) && InstanceMng.getPopupMng().getPopupShown() is PopupSearchingPvPOpponent)
         {
            PopupSearchingPvPOpponent(InstanceMng.getPopupMng().getPopupShown()).enableCloseButton(true);
         }
      }
      
      public static function onMatchFinished(param1:Number, param2:String = "", param3:String = "") : void
      {
         var _loc5_:FSCard = null;
         var _loc4_:BattleEngine = InstanceMng.getBattleEngine();
         if(_loc4_ != null && _loc4_.isOnlineMatch() && !_loc4_.isBattleOver())
         {
            _loc5_ = InstanceMng.getCurrentScreen() is FSBattleScreenPvP ? FSBattleScreenPvP(InstanceMng.getCurrentScreen()).getSelectedCard() : null;
            if(_loc5_ != null && _loc5_.isZoomedIn())
            {
               SpecialFX.zoomOut(_loc5_);
            }
            InstanceMng.getPopupMng().closePopupShown();
            InstanceMng.getBattleEngine().onBattleOverCommonOps();
            setMatchAsFinished("",true,false);
            onPvPMatchWon(int(param1),TextManager.getText("TID_PVP_PLAYER2_SURRENDER"),smPlayingFriendlyMatch,param2);
            param3 = param3 != "" && param3 != null ? param3 : "opponent surrendered";
            FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_WON,{"info":param3});
         }
      }
      
      public static function onGameInfoCheckAckCheckFBPvPMatch(param1:Object, param2:String, param3:Object) : void
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Boolean = false;
         var _loc4_:Boolean = Utils.stringToBoolean(String(Config.smServerConfig["pvp_available"]));
         if(!_loc4_)
         {
            removeFromPvPQueue(true);
            Utils.setLogText(TextManager.getText("TID_PVP_FB_REQUIREMENTS"),true);
         }
         else
         {
            _loc5_ = Config.smServerConfig["misc_v_" + InstanceMng.getServerConnection().getPlatformId()];
            _loc6_ = Utils.getAppVersion();
            if(_loc6_ >= _loc5_)
            {
               _loc7_ = !smUserInPvPBattle && !smUserInPvPQueue && !smUserSettingUpForMatch;
               if(!InstanceMng.getApplication().areOnDemandDefinitionsInitialized() || !_loc7_)
               {
                  removeFromPvPQueue(true);
                  Utils.setLogText(TextManager.getText("TID_PVP_FB_REQUIREMENTS"),true);
               }
               else
               {
                  FSDebug.debugTrace("Opening fb opponent found popup");
                  onOpponentFoundNotifReceived(param2,param3,smPlayingFriendlyMatch);
               }
            }
            else
            {
               removeFromPvPQueue(true);
               Utils.setLogText(TextManager.getText("TID_PVP_FB_REQUIREMENTS"),true);
            }
         }
      }
      
      public static function onPvPMatchDesynchronized() : void
      {
         var _loc1_:UserData = null;
         var _loc2_:int = 0;
         if(smCurrentMatchId != "")
         {
            _loc1_ = Utils.getOwnerUserData();
            if(!smPlayingFriendlyMatch && smEloBeforeStartingMatch != 0)
            {
               if(smLeagueBeforeStartingMatch != 0)
               {
                  _loc1_.setPvPCurrentLeague(smLeagueBeforeStartingMatch);
               }
               _loc1_.setElo(smEloBeforeStartingMatch);
               InstanceMng.getServerConnection().addScoreToLeaderboard("PLAYER_PVP",smEloBeforeStartingMatch,_loc1_.getMatchesWon(),_loc1_.getPvPCurrentLeague(),_loc1_.getPvPBestLeague());
               _loc1_.setMatchesPlayed(_loc1_.getMatchesPlayed() - 1);
               InstanceMng.getUserDataMng().persistenceSaveData();
            }
            if(InstanceMng.getBattleEngine() != null)
            {
               Utils.createPvPOverEffect(InstanceMng.getBattleEngine().getOwnerBattleInfo(),0,null,false,false,true);
            }
            smCurrentMatchId = "";
            smMatchActionId = -1;
            smOpponentHasReshuffled = false;
            smOwnerHasReshuffled = false;
            smOpponentUserData = null;
            smPlayingFriendlyMatch = false;
            smPvPFriendlyUID = "";
            smMoveId = 1;
            smServerMatchData = null;
            DictionaryUtils.clearDictionary(smMovesPool);
            smMovesPool = null;
            _loc2_ = _loc1_ ? _loc1_.getElo() : 0;
            FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_PVP_MATCH_DESYNCHRONIZED,{"elo":_loc2_});
         }
      }
      
      public static function onPvPMatchWon(param1:int, param2:String, param3:Boolean = false, param4:String = "") : void
      {
         var _loc5_:UserData = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Boolean = false;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:Boolean = false;
         var _loc13_:Number = NaN;
         var _loc14_:int = 0;
         var _loc15_:Boolean = false;
         var _loc16_:Boolean = false;
         var _loc17_:String = null;
         var _loc18_:String = null;
         var _loc19_:String = null;
         var _loc20_:String = null;
         var _loc21_:Array = null;
         if(!param3 && smEloBeforeStartingMatch != 0)
         {
            _loc5_ = Utils.getOwnerUserData();
            _loc5_.increaseMatchesWon();
            _loc5_.decreaseMatchesLost();
            _loc6_ = smEloBeforeStartingMatch;
            _loc7_ = getEloIfMatchWon(int(param1),smEloBeforeStartingMatch);
            _loc8_ = _loc7_ - _loc6_;
            if(smLeagueBeforeStartingMatch != 0)
            {
               _loc10_ = smLeagueBeforeStartingMatch;
               _loc11_ = getLeagueByELO(_loc7_,_loc10_);
               if(_loc11_ != 0)
               {
                  _loc12_ = _loc11_ < _loc10_;
                  if(_loc12_)
                  {
                     _loc5_.setPvPBestLeague(_loc11_);
                  }
                  _loc5_.setPvPCurrentLeague(_loc11_);
               }
            }
            _loc5_.setElo(_loc7_);
            InstanceMng.getServerConnection().addScoreToLeaderboard("PLAYER_PVP",_loc7_,_loc5_.getMatchesWon(),_loc5_.getPvPCurrentLeague(),_loc5_.getPvPBestLeague());
            calculateClassPointsWon(true);
            _loc5_.addGold(Config.getConfig().getGoldGainedPerPvPMatchWon());
            _loc9_ = param4 != null && param4 != "" && param4 != _loc5_.getGuildId() || param4 == null || param4 == "";
            if(Config.HAS_GUILDS && _loc5_.hasGuild() && _loc9_)
            {
               _loc13_ = InstanceMng.getGuildsMng().getPvPWonPointsWon();
               onMatchWonPerformServerCalls(_loc13_);
            }
            else
            {
               onMatchWonPersistenceSavedTrackAction();
            }
            if(Boolean(Config.getConfig().hasQuests()) && Boolean(InstanceMng.getBattleEngine()) && Boolean(InstanceMng.getBattleEngine().getOwnerBattleInfo()))
            {
               if(InstanceMng.getQuestsMng())
               {
                  _loc14_ = InstanceMng.getBattleEngine().getOwnerBattleInfo() ? InstanceMng.getBattleEngine().getOwnerBattleInfo().getHP() : -1;
                  _loc15_ = InstanceMng.getBattleEngine().getOwnCardsDefeatedAmount() == 0;
                  _loc16_ = InstanceMng.getBattleEngine().getPlayerGotHitAtLeastOnce() == false;
                  _loc17_ = InstanceMng.getBattleEngine().getFactionsPlayed();
                  _loc18_ = InstanceMng.getBattleEngine().getCategoriesPlayed();
                  _loc19_ = InstanceMng.getBattleEngine().getSubcategoriesPlayed();
                  _loc20_ = InstanceMng.getBattleEngine().getRaritiesPlayed();
                  _loc21_ = [QuestsMng.TARGET_EXTRA_INFO_CARDS_UNDEFEATED + ":" + _loc15_,QuestsMng.TARGET_EXTRA_INFO_HP_INTACT + ":" + _loc16_,QuestsMng.TARGET_CARD_ONLY_CATEGORY + ":" + _loc18_,QuestsMng.TARGET_CARD_ONLY_SUBCATEGORY + ":" + _loc19_,QuestsMng.TARGET_CARD_ONLY_FACTION + ":" + _loc17_,QuestsMng.TARGET_CARD_ONLY_RARITY + ":" + _loc20_];
                  if(_loc14_ != -1)
                  {
                     _loc21_.push(QuestsMng.TARGET_EXTRA_INFO_HP_LEFT + ":" + _loc14_);
                  }
                  InstanceMng.getQuestsMng().addActionPerformed(QuestsMng.TARGET_TYPE_WIN,1,false,_loc21_,"level_pvp");
               }
            }
            InstanceMng.getUserDataMng().persistenceSaveData();
         }
         if(InstanceMng.getBattleEngine() != null)
         {
            InstanceMng.getPopupMng().closePopupShown();
            InstanceMng.getPopupMng().cleanPopupInBackground();
            Utils.createPvPOverEffect(InstanceMng.getBattleEngine().getOwnerBattleInfo(),_loc8_,param2,param3);
         }
         smCurrentMatchId = "";
         smMatchActionId = -1;
         smOpponentHasReshuffled = false;
         smOwnerHasReshuffled = false;
         smOpponentUserData = null;
         smPlayingFriendlyMatch = false;
         smPlayingAgainstBOT = false;
         smPlayingAgainstOfflineDeck = false;
         smPvPFriendlyUID = "";
         smMoveId = 1;
         smServerMatchData = null;
         DictionaryUtils.clearDictionary(smMovesPool);
         smMovesPool = null;
      }
      
      public static function calculateClassPointsWon(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         if(Config.getConfig().gameHasClassSystem() && Boolean(InstanceMng.getBattleEngine()))
         {
            _loc2_ = InstanceMng.getScoreMng().getBattleScore();
            _loc3_ = param1 ? 400 : 50;
            _loc4_ = 0;
            _loc5_ = 0;
            _loc6_ = Math.round(InstanceMng.getBattleEngine().getCurrentTurnId() * 0.5);
            _loc7_ = param1 ? 5 : 2;
            _loc8_ = param1 ? 0.4 : 0.1;
            _loc5_ = _loc6_ * _loc7_ + _loc2_ / _loc6_ * _loc8_;
            _loc5_ = Math.max(_loc4_,_loc5_);
            _loc5_ = Math.min(_loc3_,_loc5_);
            _loc5_ = _loc5_ * 1.5;
            JobsMng.winJobExperience(_loc5_);
            FSDebug.debugTrace("POINTS WON PER PVP MATCH: " + _loc5_);
         }
      }
      
      private static function onMatchWonPersistenceSavedTrackAction() : void
      {
         var _loc1_:UserData = Utils.getOwnerUserData();
         var _loc2_:int = _loc1_ ? _loc1_.getElo() : 0;
         FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_WON,{"elo":_loc2_});
      }
      
      private static function onMatchWonPerformServerCalls(param1:Number) : void
      {
         FSDebug.debugTrace("onMatchWonPerformServerCalls");
         InstanceMng.getUserDataMng().getOwnerUserData().addGuildWeeklyPvPScore(param1);
         setTimeout(InstanceMng.getGuildsMng().createGuildPvPWonEvent,1000);
         var _loc2_:UserData = Utils.getOwnerUserData();
         var _loc3_:int = _loc2_ ? _loc2_.getElo() : 0;
         setTimeout(FSTracker.trackMiscAction,2000,FSTracker.CATEGORY_PVP,FSTracker.ACTION_WON,{"elo":_loc3_});
      }
      
      public static function onPvPMatchDraw() : void
      {
         var _loc1_:UserData = null;
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         if(smCurrentMatchId != "")
         {
            _loc1_ = Utils.getOwnerUserData();
            if(!smPlayingFriendlyMatch && smEloBeforeStartingMatch != 0)
            {
               _loc3_ = smEloBeforeStartingMatch;
               _loc1_.decreaseMatchesLost();
               if(smLeagueBeforeStartingMatch != 0)
               {
                  _loc1_.setPvPCurrentLeague(smLeagueBeforeStartingMatch);
               }
               _loc1_.setElo(_loc3_);
               InstanceMng.getServerConnection().addScoreToLeaderboard("PLAYER_PVP",_loc3_,_loc1_.getMatchesWon(),_loc1_.getPvPCurrentLeague(),_loc1_.getPvPBestLeague());
               _loc1_.addGold(Config.getConfig().getGoldGainedPerPvPMatchDraw());
               calculateClassPointsWon(false);
               InstanceMng.getUserDataMng().persistenceSaveData();
            }
            if(InstanceMng.getBattleEngine() != null)
            {
               Utils.createPvPOverEffect(null,0,null,false,true);
            }
            smCurrentMatchId = "";
            smServerMatchData = null;
            smMatchActionId = -1;
            smOpponentHasReshuffled = false;
            smOwnerHasReshuffled = false;
            smOpponentUserData = null;
            smPlayingFriendlyMatch = false;
            smPvPFriendlyUID = "";
            smMoveId = 1;
            DictionaryUtils.clearDictionary(smMovesPool);
            smMovesPool = null;
            _loc2_ = _loc1_ ? _loc1_.getElo() : 0;
            FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_DRAW,{"elo":_loc2_});
         }
      }
      
      public static function startPvPBattle(param1:int, param2:String, param3:Boolean = false, param4:Boolean = false) : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         smMoveId = 1;
         DictionaryUtils.clearDictionary(smMovesPool);
         smMovesPool = null;
         smUserInPvPQueue = false;
         smUserInPvPBattle = true;
         smUserSettingUpForMatch = false;
         smPlayingFriendlyMatch = param3;
         var _loc5_:UserData = Utils.getOwnerUserData();
         if(!param3)
         {
            smEloBeforeStartingMatch = _loc5_.getElo();
            _loc6_ = getEloIfMatchLost(param1);
            smCurrentMatchEloLostIfMatchLost = _loc6_;
            smLeagueBeforeStartingMatch = _loc5_.getPvPCurrentLeague();
            _loc7_ = getLeagueByELO(_loc6_,smLeagueBeforeStartingMatch);
            if(_loc7_ != 0)
            {
               _loc5_.setPvPCurrentLeague(_loc7_);
            }
            if(_loc6_ != 0)
            {
               _loc5_.setElo(_loc6_);
               InstanceMng.getServerConnection().addScoreToLeaderboard("PLAYER_PVP",_loc6_,_loc5_.getMatchesWon(),_loc5_.getPvPCurrentLeague(),_loc5_.getPvPBestLeague());
            }
            _loc5_.increaseMatchesPlayed();
            _loc5_.increaseMatchesLost();
            InstanceMng.getUserDataMng().persistenceSaveData();
            FSTracker.trackFirebaseEvent("PVP_MATCH_STARTED");
         }
         smOpponentName = param2 ? param2 : "";
         Utils.removeLog();
         InstanceMng.getCurrentScreen().startBattle(null,true);
      }
      
      private static function logEntityDataReceived(param1:Boolean, param2:int, param3:int, param4:int) : void
      {
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc5_:BattleEngine = InstanceMng.getBattleEngine();
         if(_loc5_ != null)
         {
            _loc6_ = _loc5_.getCurrentMoveId();
            _loc7_ = "ActionId " + param2 + " (" + smMatchActionId + ")";
            _loc8_ = "TurnId " + param3 + " (" + smNotificationTurnId + ")";
            _loc9_ = "MoveId " + param4 + " (" + _loc6_ + ")";
            _loc10_ = _loc8_ + " | " + _loc7_ + " | " + _loc9_;
            _loc11_ = param1 ? BattleEngine.COMBAT_LOG_TURN_RECEIVED : BattleEngine.COMBAT_LOG_MOVE_RECEIVED;
            FSDebug.debugTrace("[PVP REAL TIME] " + _loc11_ + " " + _loc10_);
            _loc5_.storeCombatLogAction(_loc11_,null,"",{"info":_loc10_});
         }
      }
      
      public static function onMatchDataACKPerformOpponentRound(param1:Object) : void
      {
         var _loc2_:BattleEngine = null;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         FSDebug.debugTrace("Match info received -> Reproducing TURN ID: " + param1.turnId + " | notif turn right now: " + smNotificationTurnId);
         if(param1.turnId == smNotificationTurnId + 1)
         {
            smServerMatchData = param1;
            _loc2_ = InstanceMng.getBattleEngine();
            _loc3_ = _loc2_.getCurrentMoveId();
            _loc4_ = param1["turnEnded"] == true;
            _loc5_ = param1["moveId"] != null ? int(param1["moveId"]) : -1;
            _loc6_ = _loc4_ && _loc5_ == _loc3_;
            _loc7_ = false;
            _loc8_ = int(param1["actionId"]);
            _loc9_ = smMatchActionId;
            logEntityDataReceived(true,_loc8_,param1.turnId,_loc5_);
            if(_loc8_ <= _loc9_)
            {
               _loc2_.storeCombatLogAction(BattleEngine.COMBAT_LOG_WARNING,null,"",{"info":"Entity ActionId " + _loc8_ + " | Real actionId: " + _loc9_});
               FSDebug.debugTrace("[PVP REAL TIME] Turn Received -> ActionId already processed, skipping");
               return;
            }
            smNotificationTurnId = param1.turnId + 1;
            if(realTimeAllowed())
            {
               onMatchDataACKPerformOpponentMove(param1);
               return;
            }
            onMatchBattleDataACKPerformOps(param1);
            _loc7_ = true;
         }
         else
         {
            FSDebug.debugTrace("Skipping round! We received twice the same ROUND from the opponent");
            FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_ERROR_DETECTED,{"error":"Owner received same ROUND twice, skipped (turnId: " + param1.turnId});
         }
         if(_loc7_)
         {
            if(_loc2_ is BattleEnginePvP)
            {
               BattleEnginePvP(_loc2_).onNewPvPRoundReceivedPerformCommonOps(true);
            }
         }
      }
      
      public static function onMatchDataACKPerformOpponentMove(param1:Object) : void
      {
         var _loc25_:Object = null;
         var _loc2_:BattleEngine = InstanceMng.getBattleEngine();
         if(_loc2_ == null)
         {
            return;
         }
         smServerMatchData = param1;
         var _loc3_:int = int(param1["moveId"]);
         var _loc4_:int = _loc2_.getCurrentMoveId();
         var _loc5_:Boolean = Boolean(param1["reshuffleUsed"]);
         if((_loc5_) && !smOpponentHasReshuffled)
         {
            FSDebug.debugTrace("Duplicating object to replay reshuffle");
            param1["reshuffleUsed"] = false;
            poolMove(param1);
            _loc25_ = ObjectUtil.clone(param1);
            _loc25_["reshuffle"] = true;
            _loc25_["onlyPlayableCards"] = true;
            _loc25_["actionId"] = smMatchActionId + 1;
            _loc25_["moveId"] = 1;
            _loc25_["battleData"]["moveId"] = 1;
            delete _loc25_["battleData"]["opponentBattleInfo"]["mBFCards"];
            onMatchDataACKPerformOpponentMove(_loc25_);
            return;
         }
         var _loc6_:Boolean = param1["turnEnded"] == true;
         var _loc7_:Boolean = param1["reshuffle"] == true;
         var _loc8_:Boolean = param1["wasReshuffled"] == true;
         var _loc9_:Boolean = param1["onlyPlayableCards"] == true;
         var _loc10_:int = _loc2_.getBattleStateId();
         var _loc11_:int = _loc2_.getPlayersStateId();
         var _loc12_:Boolean = _loc2_.getOpponentBattleInfo() ? _loc2_.getOpponentBattleInfo().isAnyCardBeingPromoted() : false;
         var _loc13_:Boolean = _loc10_ == BattleEngine.BATTLE_STATE_NOT_BEGUN || _loc11_ == BattleEngine.STATE_OPPONENT_MOVING_UP_FROM_SUPPORT;
         var _loc14_:Boolean = _loc9_ == false || _loc7_ || _loc9_ == true && _loc2_.canOpponentReceiveNextHand();
         var _loc15_:Boolean = _loc3_ > _loc4_ + 1;
         var _loc16_:Boolean = (_loc15_) || (_loc3_ == _loc4_ + 1 || _loc3_ == _loc4_ && _loc8_);
         var _loc17_:Boolean = _loc2_.isResumingPvPCard();
         var _loc18_:Boolean = (_loc17_) || !_loc16_ || _loc13_ || !_loc14_ || _loc12_;
         var _loc19_:Boolean = _loc6_ && _loc3_ == _loc4_;
         var _loc20_:int = int(param1.turnId);
         var _loc21_:int = smNotificationTurnId;
         var _loc22_:Boolean = _loc20_ == _loc21_ + 1;
         var _loc23_:int = int(param1["actionId"]);
         var _loc24_:int = smMatchActionId;
         logEntityDataReceived(false,_loc23_,_loc20_,_loc3_);
         if(_loc23_ <= _loc24_)
         {
            _loc2_.storeCombatLogAction(BattleEngine.COMBAT_LOG_WARNING,null,"",{"info":"Entity ActionId " + _loc23_ + " | Real actionId: " + _loc24_});
            FSDebug.debugTrace("[PVP REAL TIME] Move Received -> ActionId already processed, skipping");
            return;
         }
         if(_loc2_ is BattleEnginePvP)
         {
            BattleEnginePvP(_loc2_).onNewPvPRoundReceivedPerformCommonOps(_loc6_);
         }
         FSDebug.debugTrace("[PVP REAL TIME] Move Received");
         FSDebug.debugTrace("[PVP REAL TIME] entityMoveId: " + param1["moveId"] + " | Engine MoveId: " + _loc4_);
         FSDebug.debugTrace("[PVP REAL TIME] turnEnded: " + _loc6_);
         FSDebug.debugTrace("[PVP REAL TIME] isReshuffle: " + _loc7_);
         FSDebug.debugTrace("[PVP REAL TIME] wasReshuffled: " + _loc8_);
         FSDebug.debugTrace("[PVP REAL TIME] onlyPlayableCards: " + _loc9_);
         FSDebug.debugTrace("[PVP REAL TIME] moveOK: " + _loc16_);
         FSDebug.debugTrace("[PVP REAL TIME] isResumingCards: " + _loc17_);
         FSDebug.debugTrace("[PVP REAL TIME] pool: " + _loc18_);
         FSDebug.debugTrace("[PVP REAL TIME] handleEndOfTurn: " + _loc19_);
         FSDebug.debugTrace("[PVP REAL TIME] battleStateId: " + _loc10_);
         FSDebug.debugTrace("[PVP REAL TIME] wrongBattleState: " + _loc13_);
         FSDebug.debugTrace("[PVP REAL TIME] opponentCanReceiveHand: " + _loc14_);
         FSDebug.debugTrace("[PVP REAL TIME] playerStateId: " + _loc11_);
         FSDebug.debugTrace("[PVP REAL TIME] entityTurnId: " + _loc20_);
         FSDebug.debugTrace("[PVP REAL TIME] realTurnId: " + _loc21_);
         FSDebug.debugTrace("[PVP REAL TIME] turnIdOK: " + _loc22_);
         if(!_loc18_ && _loc16_ && !_loc17_)
         {
            FSDebug.debugTrace("[PVP REAL TIME] #1: !POOL & MOVE OK");
            _loc2_.setResumingPvPCard(true);
            onMatchBattleDataACKPerformOps(param1);
         }
         else if(_loc6_ && _loc3_ == _loc4_ && !_loc17_)
         {
            FSDebug.debugTrace("[PVP REAL TIME] #2: TURN ENDED");
            smMatchActionId = _loc23_;
            _loc2_.onPvPCardResumedTurnEnded(0);
         }
         else if(_loc3_ > _loc4_ + 1 || _loc3_ == _loc4_ + 1 && _loc17_ || _loc3_ == _loc4_ && _loc17_ && _loc6_ || _loc7_ || _loc13_ || !_loc14_ || _loc12_)
         {
            FSDebug.debugTrace("[PVP REAL TIME] #3: SPECIAL CASE");
            if(!_loc17_)
            {
               if(_loc13_ || !_loc14_)
               {
                  FSDebug.debugTrace("[PVP REAL TIME] #6: Battle state NOT OK, trying to get out of pool move in 1 second");
                  TweenMax.delayedCall(1,onMoveFinishedCheckPool);
               }
               else if(_loc12_)
               {
                  FSDebug.debugTrace("[PVP REAL TIME] #8: An opponent card is still being promoted, pool and check again in 1 sec");
                  TweenMax.delayedCall(1,onMoveFinishedCheckPool);
               }
               else if(_loc7_)
               {
                  FSDebug.debugTrace("[PVP REAL TIME] #4: Is Reshuffle");
                  _loc2_.setResumingPvPCard(true);
                  _loc2_.onPvPOpponentReshuffledPerformOps();
                  smOpponentHasReshuffled = true;
                  param1["reshuffle"] = false;
                  param1["wasReshuffled"] = true;
               }
               else if(_loc9_ && !_loc7_)
               {
                  if(!_loc6_)
                  {
                     FSDebug.debugTrace("[PVP REAL TIME] #5: onlyPlayableCards && is NOT Reshuffle");
                     return;
                  }
                  FSDebug.debugTrace("[PVP REAL TIME] #5: onlyPlayableCards && is NOT Reshuffle, BUT it\'s turn ended so, we will pool it");
               }
            }
            else
            {
               FSDebug.debugTrace("[PVP REAL TIME] #7: Still resuming cards, pool it");
            }
            poolMove(param1);
         }
         else
         {
            FSDebug.debugTrace("Skipping move! We received twice the same move from the opponent");
            FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_ERROR_DETECTED,{"error":"Owner received same movement twice, skipped (moveId: " + _loc3_});
         }
      }
      
      private static function poolMove(param1:Object) : void
      {
         var _loc2_:int = int(param1["actionId"]);
         FSDebug.debugTrace("[PVP REAL TIME] Pooling action " + _loc2_);
         if(InstanceMng.getBattleEngine() != null)
         {
            InstanceMng.getBattleEngine().storeCombatLogAction(BattleEngine.COMBAT_LOG_POOL_PUSH,null,"",{"info":"ActionId " + _loc2_});
         }
         if(smMovesPool == null)
         {
            smMovesPool = new Dictionary(true);
         }
         smMovesPool[_loc2_] = param1;
      }
      
      public static function onMoveFinishedCheckPool(param1:int = -1) : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc2_:Boolean = false;
         var _loc3_:BattleEngine = InstanceMng.getBattleEngine();
         if(_loc3_ != null && _loc3_.isOnlineMatch())
         {
            _loc4_ = smMatchActionId;
            _loc5_ = 15;
            _loc6_ = param1 != -1 ? param1 : int(_loc4_ + _loc5_);
            _loc7_ = smMovesPool != null ? smMovesPool[_loc6_] : null;
            FSDebug.debugTrace("[PVP REAL TIME] -onMoveFinishedCheckPool- Checking action " + _loc6_ + " from pool, exists? " + (_loc7_ != null).toString());
            if(_loc7_ != null)
            {
               _loc2_ = true;
               FSDebug.debugTrace("[PVP REAL TIME] Popping action " + _loc6_ + " out from the pool");
               if(InstanceMng.getBattleEngine() != null)
               {
                  InstanceMng.getBattleEngine().storeCombatLogAction(BattleEngine.COMBAT_LOG_POOL_POP,null,"",{"info":"ActionId " + _loc6_});
               }
               delete smMovesPool[_loc6_];
               onMatchDataACKPerformOpponentMove(_loc7_);
            }
            else if(_loc6_ >= 1)
            {
               onMoveFinishedCheckPool(_loc6_ - 1);
            }
         }
         return _loc2_;
      }
      
      public static function onMatchBattleDataACKPerformOps(param1:Object) : void
      {
         if(smPvPBattleData)
         {
            smPvPBattleData["save"] = param1 ? param1.battleData : null;
            smPvPBattleData["dataReady"] = isPlayingVSAI() ? false : true;
            smPvPBattleData["when"] = param1 ? param1["when"] : "";
            smPvPBattleData["ua"] = param1 ? param1["ua"] : "BOT_UID";
            smPvPBattleData["turnEnded"] = param1 ? param1["turnEnded"] : false;
            smPvPBattleData["onlyPlayableCards"] = param1 ? param1["onlyPlayableCards"] : false;
            smPvPBattleData["reshuffle"] = param1 ? param1["reshuffle"] : false;
            smPvPBattleData["reshuffleUsed"] = param1 ? param1["reshuffleUsed"] : false;
            smPvPBattleData["wasReshuffled"] = param1 ? param1["wasReshuffled"] : false;
            smMatchActionId = param1 ? int(param1["actionId"]) : 0;
            if(InstanceMng.getBattleEngine())
            {
               BattleEnginePvP(InstanceMng.getBattleEngine()).onOpponentTurnFinished();
            }
         }
      }
      
      public static function sendFriendlyPvPRequest() : void
      {
         if(!smUserInPvPBattle)
         {
            smUserInPvPQueue = true;
            smRequestPvPTime = true;
            InstanceMng.getServerConnection().findFriendlyPvP(smPvPFriendlyUID,null,null,onFriendlyPvPRequestFailed);
         }
      }
      
      private static function onFriendlyPvPRequestFailed(param1:Object) : void
      {
         InstanceMng.getPopupMng().closePopupShown();
         removeFromPvPQueue(true);
         if(param1 != null && param1.hasOwnProperty("error"))
         {
            Utils.setLogText(param1["error"]);
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_GUILD_TRY_AGAIN"));
         }
      }
      
      public static function enqueueInPvP(param1:String = "") : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(!smUserInPvPBattle)
         {
            smUserInPvPQueue = true;
            smRequestPvPTime = true;
            if(InstanceMng.getCurrentScreen() is FSPvPScreen)
            {
               InstanceMng.getCurrentScreen().lockUI(true);
            }
            _loc2_ = InstanceMng.getUserDataMng().getOwnerUserData().getElo();
            _loc3_ = InstanceMng.getUserDataMng().getOwnerUserData().getPvPDeckValue();
            InstanceMng.getServerConnection().findPvPMatch(_loc2_,_loc3_,param1);
         }
      }
      
      private static function isMatchEligibleByPlatform(param1:String) : Boolean
      {
         var _loc4_:int = 0;
         var _loc2_:Boolean = false;
         var _loc3_:Array = Config.smPvPPlatformsAvailable;
         if(_loc3_)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               if(_loc3_[_loc4_] == param1)
               {
                  _loc2_ = true;
               }
               _loc4_++;
            }
         }
         else
         {
            _loc2_ = true;
         }
         return _loc2_;
      }
      
      private static function checkPvPButtonsState() : void
      {
         if(InstanceMng.getCurrentScreen() is FSPvPScreen)
         {
            FSPvPScreen(InstanceMng.getCurrentScreen()).refreshPlayPvPButtons();
         }
      }
      
      public static function removeFromPvPQueue(param1:Boolean = false) : void
      {
         FSDebug.debugTrace("[removeFromPvPQueue] - Removing from PvP Queue");
         if(InstanceMng.getPopupMng().getPopupShown() is PopupSearchingPvPOpponent)
         {
            PopupSearchingPvPOpponent(InstanceMng.getPopupMng().getPopupShown()).closePopup();
         }
         if(param1 && Utils.smInternetAvailable)
         {
            if(smCurrentMatchId != null && smCurrentMatchId != "")
            {
               setMatchDead(null,smCurrentMatchId);
            }
         }
         smBattleSyncData = null;
         smUserInPvPBattle = false;
         smUserInPvPQueue = false;
         smRequestPvPTime = false;
         smUserSettingUpForMatch = false;
         smNotificationTurnId = -1;
         smMoveId = 1;
         DictionaryUtils.clearDictionary(smMovesPool);
         smMovesPool = null;
         smPlayingFriendlyMatch = false;
         smPvPFriendlyUID = "";
         smPlayingAgainstBOT = false;
         smPlayingAgainstOfflineDeck = false;
         if(InstanceMng.getCurrentScreen() is FSPvPScreen)
         {
            FSPvPScreen(InstanceMng.getCurrentScreen()).refreshPlayPvPButtons();
         }
         InstanceMng.getCurrentScreen().lockUI(false);
      }
      
      public static function updateBattleSyncData(param1:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc6_:int = 0;
         if(smBattleSyncData == null)
         {
            smBattleSyncData = new Object();
         }
         var _loc2_:int = 1;
         var _loc5_:String = InstanceMng.getServerConnection().getUserId();
         _loc2_ = 1;
         while(_loc2_ < 3)
         {
            if(param1["u" + _loc2_] != null)
            {
               _loc3_ = param1["u" + _loc2_]["uid"];
               if(smBattleSyncData[_loc3_] == null)
               {
                  smBattleSyncData[_loc3_] = new Object();
               }
               smBattleSyncData[_loc3_]["index"] = "u" + _loc2_;
               if(_loc3_ != _loc5_)
               {
                  _loc4_ = param1["u" + _loc2_]["status"];
                  if(_loc4_ != null)
                  {
                     smBattleSyncData[_loc3_][_loc4_] = true;
                     FSDebug.debugTrace("UPDATING USER " + _loc2_ + " status to: " + _loc4_);
                     _loc6_ = int(param1["u" + _loc2_]["deckIndex"]);
                     FSDebug.debugTrace("DECK INDEX: " + _loc6_);
                     if(Boolean(smOpponentUserData) && _loc6_ != -1)
                     {
                        smOpponentUserData.setSelectedDeckIndexPvP(_loc6_);
                     }
                  }
               }
            }
            _loc2_++;
         }
      }
      
      public static function updateOwnerSyncStatus(param1:String) : void
      {
         if(smBattleSyncData == null)
         {
            smBattleSyncData = new Object();
         }
         var _loc2_:String = InstanceMng.getServerConnection().getUserId();
         if(smBattleSyncData[_loc2_] == null)
         {
            smBattleSyncData[_loc2_] = new Object();
         }
         smBattleSyncData[_loc2_][param1] = true;
      }
      
      public static function checkUserStatus(param1:String, param2:String) : Boolean
      {
         return Boolean(smBattleSyncData) && Boolean(smBattleSyncData[param1]) && smBattleSyncData[param1][param2] == true;
      }
      
      public static function areUserStatusOK(param1:String) : Boolean
      {
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc5_:Boolean = false;
         var _loc2_:int = 0;
         if(smBattleSyncData != null)
         {
            for each(_loc3_ in smBattleSyncData)
            {
               _loc4_ = TYPE_PLAYER_OK_1;
               _loc5_ = Boolean(_loc3_) && _loc3_.hasOwnProperty(_loc4_) && _loc3_[_loc4_] == true;
               if(Boolean(_loc3_ && _loc3_.hasOwnProperty(param1)) && Boolean(_loc3_[param1] == true) || _loc5_)
               {
                  _loc2_++;
               }
            }
         }
         return _loc2_ == 2;
      }
      
      public static function onPlayPvPTriggered(param1:Boolean, param2:String, param3:FSButton, param4:Boolean = false, param5:Function = null) : void
      {
         var _loc6_:Dictionary = null;
         var _loc7_:int = 0;
         if(!Root.assets.isLoading)
         {
            if(InstanceMng.getServerConnection().isUserLoggedIn())
            {
               _loc6_ = InstanceMng.getUserDataMng().getOwnerUserData().getCardCollection();
               _loc7_ = DictionaryUtils.getCatalogCardsAmountCheckingRestrictions(_loc6_,true,Config.getConfig().getDeckCardsAmount());
               if(_loc7_ >= Config.getConfig().getDeckCardsAmount())
               {
                  if(!InstanceMng.getUserDataMng().getOwnerUserData().isInBlackList())
                  {
                     if(!InstanceMng.getUserDataMng().getOwnerUserData().isInDuplicatedList())
                     {
                        smPlayingFriendlyMatch = param1;
                        smPvPFriendlyUID = param2;
                        if(param3)
                        {
                           param3.enabled = false;
                        }
                        Utils.setLogText(TextManager.getText("TID_GEN_CHECKING_VERSION"),false,true);
                        InstanceMng.getCurrentScreen().showLoadingIcon(true,false,Align.RIGHT,Align.CENTER,1,null,InstanceMng.getLogPanel());
                        smPvPBattleData = null;
                        InstanceMng.getServerConnection().getServerConfig(false,onPvPInfoReceived,[null,param4,param5],false);
                     }
                     else
                     {
                        Utils.setLogText(TextManager.getText("TID_MIGRATION_ERROR_MIGRATED"),true,false,false);
                     }
                  }
                  else
                  {
                     Utils.setLogText(TextManager.getText("TID_GEN_FRAUD_PURCHASE"),true,false,false);
                  }
               }
               else
               {
                  Utils.setLogText(TextManager.getText("TID_DECKBUILDER_DECK_CRAFT"),true);
               }
            }
            else
            {
               Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true);
            }
         }
      }
      
      public static function onPvPInfoReceived(param1:Object = null, param2:FSButton = null, param3:Boolean = false, param4:Function = null) : void
      {
         var _loc5_:Boolean = false;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:Boolean = false;
         var _loc10_:UserData = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         if(InstanceMng.getCurrentScreen())
         {
            InstanceMng.getCurrentScreen().showLoadingIcon(false,false);
         }
         Utils.removeLog();
         if(Config.smServerConfig)
         {
            _loc5_ = Utils.stringToBoolean(String(Config.smServerConfig["pvp_available"]));
            if(!_loc5_)
            {
               if(param3)
               {
                  _loc6_ = Config.smServerConfig["pvp_unavailableReason"];
                  Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_PVP_NOT_AVAILABLE"),[_loc6_]),true);
               }
               removeFromPvPQueue();
               smPlayingFriendlyMatch = false;
               smPvPFriendlyUID = "";
               smPlayingAgainstBOT = false;
               smPlayingAgainstOfflineDeck = false;
               smUserInPvPBattle = false;
               smBattleSyncData = null;
               smInitMatchInfoReceived = false;
               if(param2)
               {
                  param2.enabled = true;
               }
            }
            else
            {
               _loc7_ = Config.smServerConfig["misc_v_" + InstanceMng.getServerConnection().getPlatformId()];
               _loc8_ = Utils.getAppVersion();
               if(_loc8_ >= _loc7_)
               {
                  _loc9_ = Boolean(Config.smServerConfig["pvp_checkPvPSeason"]);
                  if(!_loc9_)
                  {
                     if(param3)
                     {
                        InstanceMng.getPopupMng().openPlayPvPOnlinePopup();
                     }
                  }
                  else
                  {
                     _loc10_ = Utils.getOwnerUserData();
                     if(_loc10_)
                     {
                        _loc11_ = _loc10_.getPvPSeason();
                        _loc12_ = int(Config.smServerConfig["pvp_season"]);
                        if(_loc11_ < _loc12_)
                        {
                           InstanceMng.getPopupMng().openNewSeasonPopup(_loc12_,true,false);
                        }
                        else if(param3)
                        {
                           InstanceMng.getPopupMng().openPlayPvPOnlinePopup();
                        }
                     }
                     else
                     {
                        Utils.setLogText(TextManager.getText("TID_GEN_SERVER_RETRY"),true);
                     }
                  }
               }
               else
               {
                  Utils.setLogText(TextManager.getText("TID_GEN_UPDATE_PVP"),true);
                  if(param4 != null)
                  {
                     param4();
                  }
                  FSTracker.trackMiscAction(FSTracker.CATEGORY_MISC,FSTracker.ACTION_UPDATE_REQUIRED);
               }
            }
         }
      }
      
      public static function handlePvPEvent(param1:Object) : void
      {
         var matchId:String;
         var currScreen:Screen = null;
         var currScreenFullyLoaded:Boolean = false;
         var delay:int = 0;
         var execFinishedEv:Function = null;
         var matchOwnerId:String = null;
         var matchOwnerNick:String = null;
         var isOpponentMuted:Boolean = false;
         var screenOK:Boolean = false;
         var ownerUserData:UserData = null;
         var collection:Dictionary = null;
         var collectionSize:int = 0;
         var collectionOK:Boolean = false;
         var serverVersion:String = null;
         var clientVersion:String = null;
         var clientVersionOK:Boolean = false;
         var pvpOK:Boolean = false;
         var assetsOK:Boolean = false;
         var popupsOK:Boolean = false;
         var isDev:Boolean = false;
         var deviceOK:Boolean = false;
         var requirementsOK:Boolean = false;
         var declinerNick:String = null;
         var msg:String = null;
         var chatActivated:Boolean = false;
         var logText:String = null;
         var scriptData:Object = param1;
         execFinishedEv = function(param1:String, param2:Function, param3:Array):void
         {
            if(param1 == smCurrentMatchId)
            {
               currScreen = InstanceMng.getCurrentScreen();
               currScreenFullyLoaded = currScreen ? currScreen.isFullyLoaded() : true;
               if(currScreenFullyLoaded)
               {
                  if(param2 != null)
                  {
                     if(param3 != null)
                     {
                        param2.apply(null,param3);
                     }
                  }
               }
               else
               {
                  FSDebug.debugTrace("Trying again to exec function in 1.5 seconds...");
                  setTimeout(execFinishedEv,1500,param1,param2,param3);
               }
            }
         };
         var type:String = "";
         if(scriptData == null)
         {
            return;
         }
         type = scriptData.type;
         matchId = scriptData["matchId"];
         Utils.removeLog();
         currScreen = InstanceMng.getCurrentScreen();
         currScreenFullyLoaded = currScreen ? currScreen.isFullyLoaded() : true;
         FSDebug.debugTrace("Message received TYPE: " + type);
         switch(type)
         {
            case TYPE_NEW_MATCH:
               FSDebug.debugTrace("Opening opponent found popup");
               smPlayingFriendlyMatch = false;
               onOpponentFoundNotifReceived(Utils.getDataId(scriptData.match),scriptData.match);
               break;
            case TYPE_NEW_FRIENDLY_MATCH:
               matchOwnerId = scriptData.match.u1.uid;
               matchOwnerNick = scriptData.match.u1.nick;
               isOpponentMuted = Boolean(InstanceMng.getUserDataMng()) && InstanceMng.getUserDataMng().isPlayerInMutedList(matchOwnerId);
               screenOK = currScreen != null && currScreenFullyLoaded && currScreen is FSMapScreen || currScreen is FSPvPScreen;
               ownerUserData = Utils.getOwnerUserData();
               collection = ownerUserData ? ownerUserData.getCardCollection() : null;
               collectionSize = collection ? DictionaryUtils.getCatalogCardsAmountCheckingRestrictions(collection,true,Config.getConfig().getDeckCardsAmount()) : 0;
               collectionOK = collectionSize >= Config.getConfig().getDeckCardsAmount();
               serverVersion = Config.smServerConfig["misc_v_" + InstanceMng.getServerConnection().getPlatformId()];
               clientVersion = Utils.getAppVersion();
               clientVersionOK = clientVersion >= serverVersion;
               pvpOK = !smUserInPvPBattle && !smUserInPvPQueue && !smUserSettingUpForMatch;
               assetsOK = InstanceMng.getApplication().areOnDemandDefinitionsInitialized();
               popupsOK = InstanceMng.getPopupMng().isPopupLoading() == false;
               isDev = Config.ENVIRONMENT_ACTIVE == Config.ENVIRONMENT_DEV;
               deviceOK = !Utils.isMobile() || Utils.isMobile() && (!Root.smRootDeactivated || isDev);
               requirementsOK = collection && clientVersionOK && assetsOK && pvpOK && screenOK && !isOpponentMuted && popupsOK && deviceOK;
               if(requirementsOK)
               {
                  FSDebug.debugTrace("FB PvP match request arrived");
                  smPlayingFriendlyMatch = true;
                  InstanceMng.getServerConnection().getServerConfig(false,onGameInfoCheckAckCheckFBPvPMatch,[matchId,scriptData.match],false);
               }
               else
               {
                  logText = "";
                  if(isOpponentMuted)
                  {
                     logText = "";
                  }
                  if(!requirementsOK)
                  {
                     logText = matchOwnerNick + " " + TextManager.getText("TID_PVP_FB_SENT") + " " + TextManager.getText("TID_PVP_FB_REQUIREMENTS");
                     if(!screenOK || !assetsOK)
                     {
                        logText += " [Info: You must be on the Map or PvP screen]";
                     }
                     if(!collectionOK)
                     {
                        logText += " [Info: Not enough cards to play]";
                     }
                     if(!clientVersionOK)
                     {
                        logText += " [Info: Client version mismatch, please update]";
                     }
                     if(!pvpOK)
                     {
                        logText += " [Info: Already on PvP Queue]";
                     }
                  }
                  InstanceMng.getServerConnection().declineFriendlyPvP(1.5,matchOwnerId,matchOwnerNick,logText);
               }
               break;
            case TYPE_FRIENDLY_MATCH_DECLINED:
               declinerNick = scriptData.declinerNick;
               onFriendlyMatchDeclined(1.5,declinerNick);
               break;
            case TYPE_NEW_ROUND_AVAILABLE:
               if(matchId == smCurrentMatchId)
               {
                  if(InstanceMng.getCurrentScreen() is FSBattleScreenPvP && InstanceMng.getCurrentScreen().isFullyLoaded())
                  {
                     FSDebug.debugTrace("ALL GOOD -> Processing round");
                     smRoundReplayAttempts = 0;
                     onMatchDataACKPerformOpponentRound(scriptData.round);
                  }
                  else if(smRoundReplayAttempts < 7)
                  {
                     FSDebug.debugTrace("Owner screen not ready yet, trying again in 1.5 seconds");
                     setTimeout(handlePvPEvent,1500,scriptData);
                     ++smRoundReplayAttempts;
                     FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_PVP_MATCH_ROUND_RECEIVED,{"info":"Screen not fully loaded yet, trying again in 1.5 seconds"});
                  }
                  else
                  {
                     FSDebug.debugTrace("PVP EVENT -> not good -> roundreplayattempts >= 7");
                     FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_PVP_MATCH_ROUND_RECEIVED,{"info":"Screen not fully loaded - PVP MATCH OFF"});
                  }
               }
               else
               {
                  FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_PVP_MATCH_DIFFERENT,{"info":"currMatchId: " + smCurrentMatchId + " | matchReceivedId: " + matchId});
               }
               break;
            case TYPE_NEW_MOVE_AVAILABLE:
               if(matchId == smCurrentMatchId)
               {
                  if(InstanceMng.getCurrentScreen() is FSBattleScreenPvP && InstanceMng.getCurrentScreen().isFullyLoaded())
                  {
                     smRoundReplayAttempts = 0;
                     onMatchDataACKPerformOpponentMove(scriptData.round);
                  }
                  else if(smRoundReplayAttempts < 7)
                  {
                     FSDebug.debugTrace("Owner screen not ready yet, trying again in 1.5 seconds");
                     setTimeout(handlePvPEvent,1500,scriptData);
                     ++smRoundReplayAttempts;
                     FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_PVP_MATCH_MOVE_RECEIVED,{"info":"Screen not fully loaded yet, trying again in 1.5 seconds"});
                  }
                  else
                  {
                     FSDebug.debugTrace("PVP EVENT -> not good -> roundreplayattempts >= 7");
                     FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_PVP_MATCH_MOVE_RECEIVED,{"info":"Screen not fully loaded - PVP MATCH OFF"});
                  }
               }
               else
               {
                  FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_PVP_MATCH_DIFFERENT,{"info":"currMatchId: " + smCurrentMatchId + " | matchReceivedId: " + matchId});
               }
               break;
            case TYPE_USER_READY:
            case TYPE_MATCH_EDITED:
               if(scriptData["matchId"] == smCurrentMatchId)
               {
                  updateBattleSyncData(scriptData.match);
               }
               if(InstanceMng.getPopupMng().getPopupShown() is PopupWaitingForOpponent)
               {
                  PopupWaitingForOpponent(InstanceMng.getPopupMng().getPopupShown()).onMatchInfoACK();
               }
               break;
            case TYPE_FINISHED_MATCH:
               execFinishedEv(matchId,onMatchFinished,[scriptData.opponentElo,scriptData.opponentGuildId]);
               break;
            case TYPE_NEW_CHAT_MESSAGE:
               msg = scriptData.msg;
               chatActivated = Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) ? InstanceMng.getUserDataMng().getOwnerUserData().flagsChatOn() : false;
               if(chatActivated && InstanceMng.getBattleEngine() != null && InstanceMng.getBattleEngine().isOnlineMatch())
               {
                  Utils.playSound(Constants.SOUND_CHAT,SoundManager.TYPE_SFX);
                  InstanceMng.getBattleEngine().getOpponentBattleInfo().getUserBattlePortrait().showMessage(msg);
               }
               break;
            case TYPE_OWNER_AWAY:
               if(smUserInPvPBattle)
               {
                  Root.assets.purgeQueue();
                  Utils.setLogText(TextManager.getText("TID_GEN_DESYNC"),true);
                  if(InstanceMng.getPopupMng().getPopupShown())
                  {
                     if(InstanceMng.getPopupMng().getPopupShown() is PopupError)
                     {
                        InstanceMng.getPopupMng().getPopupShown().closePopup();
                     }
                  }
                  execFinishedEv(matchId,BattleEnginePvP.pvpDesyncPlayerForInactivity,[false]);
               }
               break;
            case TYPE_MATCH_DEAD:
               removeFromPvPQueue(true);
               Utils.setLogText(TextManager.getText("TID_PVP_OPPONENT_NOTFOUND"));
         }
      }
      
      private static function onFriendlyMatchDeclined(param1:Number, param2:String) : void
      {
         var decline:Function = null;
         var delay:Number = param1;
         var declinerNick:String = param2;
         decline = function():void
         {
            if(InstanceMng.getPopupMng().getPopupShown() is PopupWaitingForOpponent)
            {
               PopupWaitingForOpponent(InstanceMng.getPopupMng().getPopupShown()).disableRequestTimer();
            }
            InstanceMng.getPopupMng().closePopupShown();
            removeFromPvPQueue(true);
            Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_PVP_REQUEST_SENT_CANCELED"),[declinerNick]),false,false,false);
         };
         setTimeout(decline,delay * 1000);
      }
      
      public static function setMatchAsFinished(param1:String = "", param2:Boolean = false, param3:Boolean = false) : void
      {
         var _loc4_:Object = null;
         var _loc5_:String = null;
         if(smCurrentMatchId != "")
         {
            _loc4_ = new Object();
            _loc4_._id = new Object();
            _loc4_._id.$oid = smCurrentMatchId;
            _loc4_["ua"] = InstanceMng.getServerConnection().getUserId();
            _loc4_.a = MATCH_STATUS_FINISHED;
            _loc4_.status = MATCH_STATUS_FINISHED;
            _loc4_.matchFinishedTime = InstanceMng.getServerConnection().getRequestDateObject();
            if(param1 != "" && param1 != null)
            {
               _loc4_.matchResult = param1;
               if(param1 == "ROUND_TIMEOUT")
               {
                  if(Boolean(InstanceMng.getBattleEngine()) && Boolean(InstanceMng.getBattleEngine().getOpponentBattleInfo()) && Boolean(InstanceMng.getBattleEngine().getOpponentBattleInfo().getUserData()))
                  {
                     _loc5_ = InstanceMng.getBattleEngine().getOpponentBattleInfo().getUserData().getAccountId();
                     _loc4_.matchResultplayerInvolved = _loc5_;
                  }
               }
            }
            _loc4_ = fillWinnerInfo(_loc4_,param2,param3);
            InstanceMng.getServerConnection().updateEntityInCollection("matches",_loc4_);
         }
      }
      
      public static function updateMatchBattleLoadedOK() : void
      {
         if(smCurrentMatchId != "")
         {
            InstanceMng.getServerConnection().updatePvPMatchOwnerStatus(TYPE_PLAYER_OK_1,smCurrentMatchId,ACTION_SYNC_STEP_2);
         }
      }
      
      public static function updateOwnerAcceptedMatch(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         smOpponentUserData = null;
         if(param1)
         {
            _loc2_ = Boolean(param1.u1) && Boolean(param1.u1.uid) ? param1.u1.uid : null;
            _loc3_ = Boolean(param1.u2) && Boolean(param1.u2.uid) ? param1.u2.uid : null;
            _loc4_ = _loc2_ == InstanceMng.getServerConnection().getUserId() ? _loc3_ : _loc2_;
            if(_loc4_ != null)
            {
               if(_loc4_ != MATCH_BOT_UID)
               {
                  InstanceMng.getServerConnection().getUserProfileByUID(_loc4_,onPvPOpponentUserDataACK,null,param1);
               }
            }
            else
            {
               setMatchDead(param1);
               Utils.setLogText(TextManager.getText("TID_PVP_CANCELLED"),true);
               removeFromPvPQueue();
            }
         }
         else
         {
            setMatchDead(param1);
            Utils.setLogText(TextManager.getText("TID_PVP_CANCELLED"),true);
            removeFromPvPQueue();
         }
      }
      
      private static function onPvPOpponentUserDataACK(param1:UserData, param2:Object) : void
      {
         if(Utils.getDataId(param2) == "")
         {
            FSDebug.debugTrace("data $oid is empty, skipping op");
            return;
         }
         smOpponentUserData = param1;
         if(Boolean(Config.getConfig().gameHasClassSystem() && smOpponentUserData != null) && Boolean(param2) && param2.hasOwnProperty("isOfflineMatch"))
         {
            if(param2.hasOwnProperty("u2"))
            {
               if(param2["u2"].hasOwnProperty("deckIndexPvP"))
               {
                  smOpponentUserData.setSelectedDeckIndexPvP(param2["u2"]["deckIndexPvP"]);
               }
               if(param2["u2"].hasOwnProperty("nick"))
               {
                  smOpponentUserData.setName(param2["u2"]["nick"]);
               }
               if(param2["u2"].hasOwnProperty("offlineDeck"))
               {
                  smOpponentUserData.setDeck(String(param2["u2"]["offlineDeck"]).split(","),smOpponentUserData.getSelectedDeckIndexPvP());
               }
               if(param2["u2"].hasOwnProperty("offlineDeckJobConfigurator"))
               {
                  smOpponentUserData.setDeckJobConfiguratorArr(param2["u2"]["offlineDeckJobConfigurator"].split(","));
               }
            }
         }
         InstanceMng.getServerConnection().updatePvPMatchOwnerStatus(TYPE_PLAYER_OK,Utils.getDataId(param2),ACTION_USER_READY);
      }
      
      public static function setMatchDead(param1:Object, param2:String = "") : void
      {
         var _loc3_:Object = null;
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            _loc3_ = new Object();
            _loc3_._id = new Object();
            _loc3_._id.$oid = smCurrentMatchId != null && smCurrentMatchId != "" ? smCurrentMatchId : param2;
            if(smCurrentMatchId == "" || smCurrentMatchId == null)
            {
               FSDebug.debugTrace("data $oid is empty, skipping op");
               return;
            }
            _loc3_.status = MATCH_STATUS_DEAD;
            _loc3_.a = "SETMATCHDEAD";
            _loc3_.matchResult = "dead";
            _loc3_.matchFinishedTime = InstanceMng.getServerConnection().getRequestDateObject();
            InstanceMng.getServerConnection().updateEntityInCollection("matches",_loc3_);
         }
      }
      
      public static function startMatch() : void
      {
         var _loc1_:Object = new Object();
         _loc1_._id = new Object();
         _loc1_._id.$oid = smCurrentMatchId;
         _loc1_["ua"] = InstanceMng.getServerConnection().getUserId();
         _loc1_["a"] = "MATCH STARTING";
         _loc1_["status"] = MATCH_STATUS_ACTIVE;
         _loc1_["turnId"] = -1;
         _loc1_["when"] = InstanceMng.getServerConnection().getRequestDateObject();
         InstanceMng.getServerConnection().updateEntityInCollection("matches",_loc1_);
      }
      
      public static function prepareUserDecksInfo(param1:Object) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         if(Boolean(param1) && Boolean(InstanceMng.getServerConnection().getBackendUserProfile()) && Boolean(InstanceMng.getServerConnection().getUserId()))
         {
            if(Root.smBattleData == null)
            {
               Root.smBattleData = new Object();
            }
            Root.smBattleData.online = true;
            _loc2_ = param1.u1.uid == InstanceMng.getServerConnection().getUserId();
            Root.smBattleData["mOwnerMovesFirst"] = _loc2_ ? param1.u1.movesFirst : !param1.u1.movesFirst;
            smNotificationTurnId = Root.smBattleData["mOwnerMovesFirst"] ? 0 : -1;
            _loc3_ = param1.u1.uid == InstanceMng.getServerConnection().getUserId() ? param1.u2 : param1.u1;
            smPvPBattleData = new Object();
            smPvPBattleData["decks"] = new Object();
            smPvPBattleData["decks"]["opponentInfo"] = _loc3_;
            _loc4_ = param1.u1.uid == InstanceMng.getServerConnection().getUserId() ? param1.u1 : param1.u2;
            smPvPBattleData["decks"]["ownerInfo"] = _loc4_;
            InstanceMng.getPopupMng().closePopupShown();
            InstanceMng.getCurrentScreen().lockUI(true);
            _loc5_ = 1000;
            _loc6_ = Utils.getOwnerUserData().getPvPCurrentLeague();
            _loc7_ = getLeagueInfo(_loc6_);
            if(_loc7_ != null)
            {
               _loc5_ = _loc7_.minELO > 0 ? int(_loc7_.minELO) : 1000;
            }
            if(param1.botMatch)
            {
               _loc3_["elo"] = _loc5_;
            }
            _loc8_ = smPlayingAgainstOfflineDeck ? _loc5_ : int(_loc3_["elo"]);
            TweenMax.delayedCall(1,startPvPBattle,[_loc8_,_loc3_.nick,param1.matchType == "FRIENDLY",param1.botMatch]);
         }
      }
      
      public static function onTurnFinished(param1:Boolean = false) : void
      {
         FSDebug.debugTrace("ON TURN FINISHED; GETTING MATCH INFO IN ORDER TO SEND THE UPDATED MOVES");
         if(!param1)
         {
            smOwnerPvPMovesSentSuccesfully = false;
         }
         if(realTimeAllowed() && smServerMatchData != null)
         {
            onMatchInfoReceivedUpdateMatches(smServerMatchData,true);
         }
         else
         {
            getMatchInfo(smCurrentMatchId,onMatchInfoReceivedUpdateMatches,[true]);
         }
      }
      
      public static function onMoveFinished(param1:Boolean = false) : void
      {
         FSDebug.debugTrace("ON MOVE FINISHED; GETTING MATCH INFO IN ORDER TO SEND THE UPDATED MOVE");
         if(!param1)
         {
            smOwnerPvPMovesSentSuccesfully = false;
         }
         if(realTimeAllowed() && smServerMatchData != null)
         {
            onMatchInfoReceivedUpdateMatches(smServerMatchData,false);
         }
         else
         {
            getMatchInfo(smCurrentMatchId,onMatchInfoReceivedUpdateMatches,[false]);
         }
      }
      
      private static function onMatchInfoReceivedUpdateMatches(param1:Object, param2:Boolean) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Number = NaN;
         var _loc6_:String = null;
         if(!smOwnerPvPMovesSentSuccesfully)
         {
            smServerMatchData = param1;
            smOwnerPvPMovesSentSuccesfully = true;
            _loc3_ = param1 != null && param1.status == MATCH_STATUS_ACTIVE;
            _loc4_ = param1 != null && param1.a == ACTION_SURRENDER && param1["ua"] != InstanceMng.getServerConnection().getUserId();
            if(_loc4_)
            {
               _loc5_ = param1.u1.uid == InstanceMng.getServerConnection().getUserId() ? Number(param1.u2.elo) : Number(param1.u1.elo);
               _loc6_ = param1.u1.uid == InstanceMng.getServerConnection().getUserId() ? param1.u2.guildId : param1.u1.guildId;
               onMatchFinished(_loc5_,_loc6_);
            }
            else if(_loc3_)
            {
               if(param2)
               {
                  updateMatchWithOwnerRound(param1);
               }
               else
               {
                  updateMatchWithOwnerMove(param1);
               }
            }
            else
            {
               onUpdateMatchRoundMatchDead(param1);
            }
         }
      }
      
      private static function prepareMatchEntityData(param1:Object, param2:String) : Object
      {
         if(smCurrentMatchId == null || smCurrentMatchId == "")
         {
            FSDebug.debugTrace("matchId empty, skipping op");
            return null;
         }
         var _loc3_:Object = new Object();
         _loc3_._id = new Object();
         _loc3_._id.$oid = smCurrentMatchId;
         _loc3_.u1 = param1.u1;
         _loc3_.u2 = param1.u2;
         printCurrentSaveData();
         _loc3_.battleData = new Object();
         var _loc4_:Object = smPvPBattleData;
         _loc3_.battleData = smPvPBattleData ? smPvPBattleData["save"] : null;
         _loc3_.elo = param1.elo;
         _loc3_.eloOffset = param1.eloOffset;
         if(param1.hasOwnProperty("matchType"))
         {
            _loc3_.matchType = param1.matchType;
         }
         _loc3_.deckValue = param1.hasOwnProperty("deckValue") ? param1.deckValue : "???";
         _loc3_.deckValueOffset = param1.hasOwnProperty("deckValueOffset") ? param1.deckValueOffset : "???";
         _loc3_.creationDate = param1.hasOwnProperty("creationDate") ? param1.creationDate : NaN;
         _loc3_.matchFinishedTime = param1.hasOwnProperty("matchFinishedTime") ? param1.matchFinishedTime : NaN;
         _loc3_.opponentFoundTime = param1.hasOwnProperty("opponentFoundTime") ? param1.opponentFoundTime : NaN;
         _loc3_["ua"] = InstanceMng.getServerConnection().getUserId();
         _loc3_["turnId"] = smNotificationTurnId;
         _loc3_["moveId"] = Boolean(smPvPBattleData) && Boolean(smPvPBattleData["save"]) ? smPvPBattleData["save"]["moveId"] : null;
         _loc3_["onlyPlayableCards"] = smPvPBattleData ? smPvPBattleData["onlyPlayableCards"] : false;
         _loc3_["reshuffle"] = smPvPBattleData ? smPvPBattleData["reshuffle"] : false;
         _loc3_["reshuffleUsed"] = smOwnerHasReshuffled;
         ++smMatchActionId;
         _loc3_["actionId"] = smMatchActionId;
         _loc3_["status"] = MATCH_STATUS_ACTIVE;
         if(param2 == ACTION_UPDATE_ROUND)
         {
            _loc3_["turnEnded"] = true;
         }
         _loc3_["when"] = InstanceMng.getServerConnection().getRequestDateObject();
         _loc3_["a"] = param2;
         return _loc3_;
      }
      
      private static function updateMatchWithOwnerMove(param1:Object = null) : void
      {
         var _loc2_:Object = null;
         param1 = param1 == null ? smServerMatchData : param1;
         if(param1)
         {
            _loc2_ = prepareMatchEntityData(param1,ACTION_UPDATE_MOVE);
            if(_loc2_ != null)
            {
               FSDebug.debugTrace("ABOUT TO SEND THE BATTLE DATA");
               if(InstanceMng.getServerConnection().isUserLoggedIn())
               {
                  InstanceMng.getServerConnection().updateEntityInCollection("matches",_loc2_,true);
               }
               else
               {
                  onAttemptingToUpdatePvPMatchButPlayerOffline();
               }
            }
         }
      }
      
      private static function updateMatchWithOwnerRound(param1:Object = null) : void
      {
         var _loc2_:Object = null;
         param1 = param1 == null ? smServerMatchData : param1;
         FSDebug.debugTrace("Call update match with owner move");
         if(param1)
         {
            _loc2_ = prepareMatchEntityData(param1,ACTION_UPDATE_ROUND);
            if(smPvPBattleData != null)
            {
               smPvPBattleData["save"] = null;
            }
            if(InstanceMng.getBattleEngine())
            {
               InstanceMng.getBattleEngine().resetLastProcessedMoveId();
            }
            DictionaryUtils.clearDictionary(smMovesPool);
            FSDebug.debugTrace("ABOUT TO SEND THE BATTLE DATA");
            if(InstanceMng.getServerConnection().isUserLoggedIn())
            {
               InstanceMng.getServerConnection().updateEntityInCollection("matches",_loc2_,true);
            }
            else
            {
               onAttemptingToUpdatePvPMatchButPlayerOffline();
            }
         }
      }
      
      private static function onAttemptingToUpdatePvPMatchButPlayerOffline() : void
      {
         Utils.setLogText(TextManager.getText("TID_GEN_DESYNC"),true);
         if(InstanceMng.getBattleEngine())
         {
            BattleEnginePvP(InstanceMng.getBattleEngine()).onBattleOver(false,true);
         }
      }
      
      private static function onUpdateMatchRoundMatchDead(param1:Object) : void
      {
         if(Boolean(param1) && param1.status == MATCH_STATUS_DEAD)
         {
            FSDebug.debugTrace("[onUpdateMatchRoundMatchDead] - match dead");
            if(InstanceMng.getBattleEngine())
            {
               BattleEnginePvP(InstanceMng.getBattleEngine()).onMatchDesynchronizedPerformOps();
            }
            return;
         }
         FSDebug.debugTrace("[onUpdateMatchRoundMatchDead] - smNotificationTurnId: " + smNotificationTurnId);
         FSDebug.debugTrace("[onUpdateMatchRoundMatchDead] - entityData.ua != backenduser._id? " + (param1["ua"] != InstanceMng.getServerConnection().getUserId()).toString());
         if(Boolean(param1) && param1.status != "finished")
         {
            if(smNotificationTurnId > 0 || smNotificationTurnId == 0 && param1["ua"] != InstanceMng.getServerConnection().getUserId())
            {
               if(InstanceMng.getBattleEngine())
               {
                  BattleEnginePvP(InstanceMng.getBattleEngine()).onMatchDesynchronizedPerformOps(true);
               }
            }
            else if(InstanceMng.getBattleEngine())
            {
               BattleEnginePvP(InstanceMng.getBattleEngine()).onMatchDesynchronizedPerformOps();
            }
         }
         else if(Boolean(param1) && param1["ua"] != InstanceMng.getServerConnection().getUserId())
         {
            FSDebug.debugTrace("[onUpdateMatchRoundMatchDead] - match dead");
            if(InstanceMng.getBattleEngine())
            {
               BattleEnginePvP(InstanceMng.getBattleEngine()).onMatchDesynchronizedPerformOps(true);
            }
         }
      }
      
      public static function getMatchInfo(param1:String, param2:Function, param3:Array = null, param4:Function = null) : void
      {
         InstanceMng.getServerConnection().searchInCollectionById("matches",param1,param2,param3,param4);
      }
      
      public static function fillWinnerInfo(param1:Object, param2:Boolean, param3:Boolean) : Object
      {
         var _loc4_:UserData = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         if(param1 != null)
         {
            _loc4_ = Utils.getOwnerUserData();
            _loc5_ = _loc4_ ? _loc4_.getAccountId() : "???";
            _loc6_ = smOpponentUserData != null ? smOpponentUserData.getAccountId() : "???";
            _loc6_ = smPlayingAgainstBOT ? "BOT_UID" : _loc6_;
            param1["winner"] = param2 ? _loc5_ : _loc6_;
            param1["winner"] = param3 ? "***DRAW***" : param1["winner"];
            if(smServerMatchData != null)
            {
               _loc7_ = smServerMatchData.hasOwnProperty("u1") ? smServerMatchData["u1"] : null;
               _loc8_ = smServerMatchData.hasOwnProperty("u2") ? smServerMatchData["u2"] : null;
               if(Boolean(_loc7_) && Boolean(_loc8_))
               {
                  _loc9_ = _loc7_["uid"];
                  _loc10_ = _loc8_["uid"];
                  if(_loc9_ == _loc5_)
                  {
                     if(!param1.hasOwnProperty("u1"))
                     {
                        param1["u1"] = _loc7_;
                     }
                     param1["u1"]["winner"] = param1["winner"];
                  }
                  else
                  {
                     if(!param1.hasOwnProperty("u2"))
                     {
                        param1["u2"] = _loc8_;
                     }
                     param1["u2"]["winner"] = param1["winner"];
                  }
               }
            }
         }
         return param1;
      }
      
      public static function onSurrenderPvPMatch() : void
      {
         var _loc2_:UserData = null;
         var _loc3_:String = null;
         var _loc1_:Object = new Object();
         if(smCurrentMatchId != "")
         {
            _loc1_._id = new Object();
            _loc1_._id.$oid = smCurrentMatchId;
            _loc1_.a = ACTION_SURRENDER;
            _loc2_ = Utils.getOwnerUserData();
            _loc3_ = _loc2_ ? _loc2_.getName() : "";
            _loc1_.info = "[" + _loc3_ + "] surrendered";
            _loc1_.matchResult = "SURRENDER";
            _loc1_.matchResultplayerInvolved = InstanceMng.getServerConnection().getUserId();
            _loc1_ = fillWinnerInfo(_loc1_,false,false);
            _loc1_.matchFinishedTime = InstanceMng.getServerConnection().getRequestDateObject();
            if(smPlayingAgainstBOT || smPlayingAgainstOfflineDeck)
            {
               _loc1_.status = MATCH_STATUS_FINISHED;
            }
            _loc1_["ua"] = InstanceMng.getServerConnection().getUserId();
            InstanceMng.getServerConnection().updateEntityInCollection("matches",_loc1_);
            FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_PVP_SURRENDER);
         }
      }
      
      public static function onPvPMatchWonCheckOptions() : void
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         if(smPlayingAgainstBOT || smPlayingAgainstOfflineDeck)
         {
            InstanceMng.getCurrentScreen().showLoadingIcon(false,false);
            _loc1_ = getLeagueInfo(smLeagueBeforeStartingMatch);
            if(_loc1_ != null)
            {
               _loc2_ = _loc1_.minELO > 0 ? int(_loc1_.minELO) : 1000;
               onPvPMatchWon(_loc2_,"",false,"");
            }
            else
            {
               onPvPMatchWon(1000,"");
            }
         }
         else
         {
            getMatchInfo(smCurrentMatchId,onPvpMatchWonInfoReceived);
         }
      }
      
      private static function onGetMatchInfoPvPMatchWonFailed() : void
      {
         if(smCurrentMatchId != "" && smCurrentMatchId != null)
         {
            InstanceMng.getCurrentScreen().showLoadingIcon(true,false);
            Utils.setLogText(TextManager.getText("TID_GEN_WAIT"));
            TweenMax.delayedCall(5,getMatchInfo,[smCurrentMatchId,onPvpMatchWonInfoReceived]);
         }
      }
      
      private static function onPvpMatchWonInfoReceived(param1:Object) : void
      {
         InstanceMng.getCurrentScreen().showLoadingIcon(false,false);
         var _loc2_:Object = param1.u1.uid == InstanceMng.getServerConnection().getUserId() ? param1.u2 : param1.u1;
         onPvPMatchWon(_loc2_.elo,"",smPlayingFriendlyMatch,_loc2_.guildId);
      }
      
      public static function trackCombatLog(param1:Boolean = false) : void
      {
         var onEntityFound:Function = null;
         var ownerQuery:String = null;
         var matchQuery:String = null;
         var query:String = null;
         var forcedViaScript:Boolean = param1;
         onEntityFound = function(param1:Object):void
         {
            var _loc2_:Boolean = param1 == null || param1 is Array && (param1 as Array).length == 0;
            if(_loc2_)
            {
               param1 = new Object();
            }
            param1 = !_loc2_ && param1 is Array ? (param1 as Array)[0] : param1;
            param1 = InstanceMng.getServerConnection().addCommonEntityAttributes(param1);
            param1.combatLog = BattleEngine.smCombatLog;
            param1["matchId"] = smCurrentMatchId;
            if(!forcedViaScript && smCurrentMatchId != "" && smCurrentMatchId != null)
            {
               if(InstanceMng.getBattleEngine() != null && InstanceMng.getBattleEngine().isOnlineMatch() && !isPlayingVSAI())
               {
                  if(smOpponentUserData != null && smOpponentUserData.getAccountId() != "" && smOpponentUserData.getAccountId() != null)
                  {
                     param1.opponentId = smOpponentUserData.getAccountId();
                  }
               }
            }
            if(_loc2_)
            {
               InstanceMng.getServerConnection().createEntityInCollection("battlesCombatLogs",param1);
            }
            else
            {
               InstanceMng.getServerConnection().updateEntityInCollection("battlesCombatLogs",param1,true);
            }
         };
         if(BattleEngine.smCombatLog == "" || BattleEngine.smCombatLog == null)
         {
            return;
         }
         if(Boolean(InstanceMng.getBattleEngine()) && BattleEngine.smCombatLog != "")
         {
            ownerQuery = InstanceMng.getServerConnection().getOwnerUidQuery();
            matchQuery = "{\'matchId\':\'" + smCurrentMatchId + "\'}";
            query = "{\'$and\':[" + ownerQuery + "," + matchQuery + "]}";
            InstanceMng.getServerConnection().searchInCollection("battlesCombatLogs",query,onEntityFound);
         }
      }
      
      public static function getEloIfMatchLost(param1:int, param2:int = -1) : int
      {
         var _loc3_:UserData = Utils.getOwnerUserData();
         var _loc4_:int = getKFactor(param2);
         var _loc5_:Number = getMatchMakingValue(param1,param2,false);
         var _loc6_:int = param2 == -1 ? _loc3_.getElo() : param2;
         var _loc7_:Number = _loc6_ - _loc4_ * (_loc5_ - 1);
         return Math.ceil(_loc7_);
      }
      
      public static function getEloIfMatchWon(param1:int, param2:int = -1) : int
      {
         var _loc3_:UserData = Utils.getOwnerUserData();
         var _loc4_:int = getKFactor(param2);
         var _loc5_:Number = getMatchMakingValue(param1,param2,true);
         var _loc6_:int = param2 == -1 ? _loc3_.getElo() : param2;
         var _loc7_:Number = _loc6_ + _loc4_ * (_loc5_ - 1);
         return Math.ceil(_loc7_);
      }
      
      private static function getKFactor(param1:int = -1) : int
      {
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:UserData = Utils.getOwnerUserData();
         if(_loc3_.getMatchesPlayed() - 1 <= 15)
         {
            _loc2_ = smPlayingAgainstOfflineDeck ? 8 : 16;
         }
         else
         {
            _loc4_ = param1 == -1 ? _loc3_.getElo() : param1;
            if(_loc4_ <= 2000)
            {
               _loc2_ = smPlayingAgainstOfflineDeck ? 4 : 8;
            }
            else if(_loc4_ < 3000)
            {
               _loc2_ = smPlayingAgainstOfflineDeck ? 3 : 6;
            }
            else
            {
               _loc2_ = smPlayingAgainstOfflineDeck ? 2 : 4;
            }
         }
         return _loc2_;
      }
      
      private static function getMatchMakingValue(param1:int, param2:int = -1, param3:Boolean = true) : Number
      {
         var _loc6_:Number = NaN;
         var _loc4_:UserData = Utils.getOwnerUserData();
         var _loc5_:int = param2 == -1 ? _loc4_.getElo() : param2;
         if(param3)
         {
            _loc6_ = (_loc5_ + param1) / _loc5_;
         }
         else
         {
            _loc6_ = (_loc5_ + param1) / param1;
         }
         return _loc6_;
      }
      
      public static function getLeagueByELO(param1:int, param2:int) : int
      {
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc3_:int = 0;
         if(smLeaguesInformation != null)
         {
            _loc4_ = getLeagueInfo(param2);
            if(_loc4_ != null)
            {
               _loc5_ = int(_loc4_.minELO);
               _loc6_ = int(_loc4_.maxELO);
               if(param1 < _loc5_)
               {
                  return _loc4_.resetLeague;
               }
               if(param1 > _loc6_ && param2 != 1)
               {
                  return _loc4_.nextLeague;
               }
               return param2;
            }
         }
         return _loc3_;
      }
      
      public static function getLeagueInfo(param1:int) : Object
      {
         var _loc2_:Object = null;
         if(smLeaguesInformation != null)
         {
            return smLeaguesInformation[param1.toString()];
         }
         return _loc2_;
      }
      
      public static function onSeasonChangedResetParams(param1:int) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc2_:UserData = Utils.getOwnerUserData();
         var _loc3_:int = _loc2_.getPvPCurrentLeague();
         _loc2_.setPvPSeason(param1);
         _loc2_.setMatchesPlayed(0);
         _loc2_.setMatchesWon(0);
         _loc2_.setMatchesLost(0);
         var _loc4_:Object = getLeagueInfo(_loc3_);
         if(_loc4_ != null)
         {
            _loc5_ = _loc2_.getElo();
            _loc6_ = int(_loc4_["resetELO"]);
            _loc7_ = int(_loc4_["resetLeague"]);
            if(_loc3_ > 1 && _loc5_ >= _loc6_)
            {
               _loc8_ = _loc5_ - _loc6_;
               _loc6_ += _loc8_ / 2;
               _loc7_ = getLeagueByELO(_loc6_,_loc3_);
            }
            _loc2_.setPvPCurrentLeague(_loc7_);
            _loc2_.setPvPBestLeague(_loc7_);
            _loc2_.setElo(_loc6_);
         }
         else
         {
            _loc2_.setElo(1000);
         }
         if(InstanceMng.getCurrentScreen() is FSPvPScreen)
         {
            FSPvPScreen(InstanceMng.getCurrentScreen()).refreshPlayPvPButtons();
         }
      }
      
      public static function isPlayerCloseToSwitchLeague(param1:Boolean, param2:int = -1, param3:int = -1) : Boolean
      {
         var _loc5_:int = 0;
         var _loc4_:Boolean = false;
         if(smLeaguesInformation != null)
         {
            _loc5_ = getRatingForNextPromotion(param1,param2,param3);
            _loc4_ = _loc5_ <= 50;
         }
         return _loc4_;
      }
      
      public static function getRatingPercentForNextLeague(param1:Boolean, param2:int = -1, param3:int = -1) : Number
      {
         var _loc5_:UserData = null;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc4_:Number = 0;
         if(smLeaguesInformation != null)
         {
            _loc5_ = Utils.getOwnerUserData();
            param2 = param2 != -1 ? param2 : _loc5_.getElo();
            _loc6_ = param3 != -1 ? param3 : _loc5_.getPvPCurrentLeague();
            _loc7_ = smLeaguesInformation[_loc6_.toString()];
            if(_loc7_)
            {
               _loc8_ = _loc7_["minELO"] == 0 ? 1 : int(_loc7_["minELO"]);
               _loc9_ = int(_loc7_["maxELO"]);
               _loc10_ = param1 ? _loc9_ : _loc8_;
               _loc4_ = (param2 - _loc8_) / (_loc9_ - _loc8_);
            }
         }
         return _loc4_;
      }
      
      public static function getRatingForNextPromotion(param1:Boolean, param2:int = -1, param3:int = -1) : int
      {
         var _loc5_:UserData = null;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc4_:int = 0;
         if(smLeaguesInformation != null)
         {
            _loc5_ = Utils.getOwnerUserData();
            param2 = param2 != -1 ? param2 : _loc5_.getElo();
            _loc6_ = param3 != -1 ? param3 : _loc5_.getPvPCurrentLeague();
            _loc7_ = smLeaguesInformation[_loc6_.toString()];
            if(_loc7_)
            {
               _loc8_ = _loc7_["minELO"] == 0 ? 1 : int(_loc7_["minELO"]);
               _loc9_ = int(_loc7_["maxELO"]);
               _loc10_ = param1 ? int(_loc9_ + 1) : int(_loc8_ - 1);
               _loc4_ = Math.abs(param2 - _loc10_);
            }
         }
         return _loc4_;
      }
      
      public static function getHPForPvPMatch() : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:BattleEngine = null;
         var _loc7_:LevelDef = null;
         var _loc1_:int = 0;
         if(smLeaguesInformation != null)
         {
            _loc2_ = smLeagueBeforeStartingMatch;
            _loc3_ = smOpponentUserData ? smOpponentUserData.getPvPCurrentLeague() : _loc2_;
            _loc4_ = _loc2_ != -1 && _loc3_ != -1 ? int(Math.max(_loc2_,_loc3_)) : _loc2_;
            _loc4_ = _loc4_ == -1 ? 3 : _loc4_;
            _loc5_ = smLeaguesInformation[_loc4_.toString()];
            if(_loc5_ != null)
            {
               _loc1_ = _loc5_.hasOwnProperty("hp") ? int(_loc5_["hp"]) : -1;
            }
         }
         if(_loc1_ == -1 || _loc1_ == 0)
         {
            _loc6_ = InstanceMng.getBattleEngine();
            _loc7_ = LevelDef(InstanceMng.getLevelsDefMng().getDefBySku("level_pvp"));
            _loc1_ = _loc7_ ? _loc7_.getHP() : 85;
         }
         return _loc1_;
      }
      
      public static function isPlayingVSAI() : Boolean
      {
         return smPlayingAgainstBOT || smPlayingAgainstOfflineDeck;
      }
      
      public static function realTimeAllowed() : Boolean
      {
         return REAL_TIME && (REAL_TIME_RELEASED || !REAL_TIME_RELEASED && smPlayingFriendlyMatch);
      }
      
      public function getOwnerUserIndex() : String
      {
         var _loc2_:String = null;
         var _loc1_:String = "";
         if(smBattleSyncData)
         {
            _loc2_ = InstanceMng.getServerConnection().getUserId();
            if(smBattleSyncData[_loc2_] != null)
            {
               return smBattleSyncData[_loc2_]["index"];
            }
         }
         return _loc1_;
      }
   }
}

