package com.fs.tcgengine.model.battle
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.PvPConnectionMng;
   import com.fs.tcgengine.controller.QuestsMng;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.board.card.Ability;
   import com.fs.tcgengine.model.rules.AbilityDef;
   import com.fs.tcgengine.model.rules.ActionDef;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.model.rules.PowerDef;
   import com.fs.tcgengine.model.userdata.UserBattleInfo;
   import com.fs.tcgengine.model.userdata.UserBattleInfoPvP;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.screens.FSBattleScreenPvP;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.TimerUtil;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSAction;
   import com.fs.tcgengine.view.cards.FSAttachment;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.FSPower;
   import com.fs.tcgengine.view.components.battle.FSTimeLeftCounter;
   import com.fs.tcgengine.view.popups.pvp.PopupPvPMatchDesynchronized;
   import com.fs.tcgengine.view.popups.pvp.PopupPvPMatchOver;
   import com.fs.tcgengine.view.socket.FSCardSocket;
   import com.greensock.TweenMax;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import starling.core.Starling;
   import starling.events.Event;
   import starling.utils.deg2rad;
   
   public class BattleEnginePvP extends BattleEngine implements FSModelUnloadableInterface
   {
      
      public static const PVP_LEVEL_SKU:String = "level_pvp";
      
      private static const CLOCK_TICKING_TIME:Number = TimerUtil.secondToMs(10);
      
      public var mAttackEnabled:Boolean = true;
      
      private var mRequestPvPTimer:Boolean = false;
      
      private var mRequestOpponentPvPTimer:Boolean = false;
      
      private var mCurrentMoveId:int;
      
      private var mLastProcessedMoveId:int;
      
      private var mOnTimeoutAttempts:int;
      
      private var mPreTimeoutCheckDone:Boolean;
      
      private var mTimeoutCheckDone:Boolean;
      
      private var mPostTimeoutCheckDone:Boolean;
      
      private var mLastTimeoutCheckDone:Boolean;
      
      private var mLastRoundProcessedTime:Number;
      
      private var mPlayingClockTickingSound:Boolean = false;
      
      public function BattleEnginePvP(param1:FSBattleScreen)
      {
         super(param1);
      }
      
      public static function pvpDesyncPlayerForInactivity(param1:Boolean = true) : void
      {
         FSDebug.debugTrace("[Too long deactivated, desyncing match");
         if(InstanceMng.getPopupMng().getPopupShown() == null || InstanceMng.getPopupMng().getPopupShown() != null && !(InstanceMng.getPopupMng().getPopupShown() is PopupPvPMatchOver))
         {
            if(Boolean(InstanceMng.getBattleEngine()) && InstanceMng.getBattleEngine() is BattleEnginePvP)
            {
               BattleEnginePvP(InstanceMng.getBattleEngine()).onMatchDesynchronizedPerformOps(true);
               if(Utils.smInternetAvailable && param1)
               {
                  if(PvPConnectionMng.smCurrentMatchId != "")
                  {
                     PvPConnectionMng.onSurrenderPvPMatch();
                  }
               }
            }
         }
      }
      
      private function prepareBotMove() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         if(PvPConnectionMng.isPlayingVSAI())
         {
            _loc1_ = PvPConnectionMng.smPlayingAgainstOfflineDeck || PvPConnectionMng.REAL_TIME_RELEASED;
            _loc4_ = mCurrentTurnId;
            switch(_loc4_)
            {
               case 0:
               case 1:
                  _loc2_ = _loc1_ ? 0.25 : 7;
                  _loc3_ = _loc1_ ? 0.25 : 10;
                  break;
               case 2:
                  _loc2_ = _loc1_ ? 0.25 : 10;
                  _loc3_ = _loc1_ ? 0.25 : 15;
                  break;
               case 3:
               case 4:
                  _loc2_ = _loc1_ ? 0.25 : 15;
                  _loc3_ = _loc1_ ? 0.25 : 22;
                  break;
               default:
                  _loc2_ = _loc1_ ? 0.25 : 15;
                  _loc3_ = _loc1_ ? 0.25 : 22;
            }
            _loc5_ = Utils.randomNumber(_loc2_,_loc3_);
            TweenMax.delayedCall(_loc5_,this.onPvPBotTurnReady);
         }
      }
      
      private function onPvPBotTurnReady() : void
      {
         if(!mBattleOver)
         {
            this.onNewPvPRoundReceivedPerformCommonOps(true);
            PvPConnectionMng.smNotificationTurnId += 1;
            PvPConnectionMng.onMatchBattleDataACKPerformOps(null);
         }
      }
      
      override public function init(param1:Boolean = false) : void
      {
         if(Root.smBattleData)
         {
            Root.smBattleData.isDungeon = false;
            Root.smBattleData.isRaid = false;
         }
         mIsOnlineMatch = param1;
         this.getOwnerMovesFirst();
         setBattleStateId(this.resumeInitialBattleStateId());
         setPlayersStateId(this.resumeInitialPlayersStateId());
         setNextStateId(this.resumeInitialNextStateId());
         mCurrentTurnId = this.resumeCurrentTurnId();
         this.setupLevel();
         this.setupUserInfos(param1);
         if(PvPConnectionMng.isPlayingVSAI())
         {
            InstanceMng.getUserDataMng().getOwnerUserData().addBotsPlayedSession();
            InstanceMng.getUserDataMng().updateBotsPlayedSession();
            setupAIEngine();
         }
         if(Config.getConfig().hasQuests() && param1 && !PvPConnectionMng.smPlayingFriendlyMatch)
         {
            InstanceMng.getQuestsMng().addActionPerformed(QuestsMng.TARGET_TYPE_PLAY,1,true,null,mLevelDef.getSku());
         }
         mEngineInitialized = true;
      }
      
      private function resumeInitialBattleStateId() : int
      {
         return PvPConnectionMng.smPvPBattleData != null && PvPConnectionMng.smPvPBattleData["save"] != null && PvPConnectionMng.smPvPBattleData["save"]["mBattleStateId"] != null ? int(PvPConnectionMng.smPvPBattleData["save"]["mBattleStateId"]) : BATTLE_STATE_NOT_BEGUN;
      }
      
      private function resumeInitialNextStateId() : int
      {
         if(PvPConnectionMng.smPvPBattleData["save"] != null && PvPConnectionMng.smPvPBattleData["save"]["mNextStateId"] != null)
         {
            return PvPConnectionMng.smPvPBattleData["save"]["mNextStateId"];
         }
         return 0;
      }
      
      private function resumeInitialPlayersStateId() : int
      {
         if(PvPConnectionMng.smPvPBattleData["save"] != null && PvPConnectionMng.smPvPBattleData["save"]["mPlayersStateId"] != null)
         {
            return PvPConnectionMng.smPvPBattleData["save"]["mPlayersStateId"];
         }
         return this.getOwnerMovesFirst().value == 1 ? STATE_OWNER_BEGIN_BATTLE : STATE_OPPONENT_BEGIN_BATTLE;
      }
      
      private function resumeCurrentTurnId() : int
      {
         return PvPConnectionMng.smPvPBattleData["save"] != null && PvPConnectionMng.smPvPBattleData["save"]["mCurrentTurnId"] != null ? int(PvPConnectionMng.smPvPBattleData["save"]["mCurrentTurnId"]) : 0;
      }
      
      override protected function setupLevel() : void
      {
         if(PvPConnectionMng.smPvPBattleData["save"] != null && PvPConnectionMng.smPvPBattleData["save"]["currentLevelSku"] != null)
         {
            mLevelDef = LevelDef(InstanceMng.getLevelsDefMng().getDefBySku(PvPConnectionMng.smPvPBattleData["save"]["currentLevelSku"]));
         }
         else
         {
            super.setupLevel();
         }
      }
      
      override public function getOwnerMovesFirst() : FSNumber
      {
         var _loc1_:Object = null;
         if(mOwnerMovesFirst == null)
         {
            mOwnerMovesFirst = new FSNumber();
            if(Root.smBattleData != null && Root.smBattleData["mOwnerMovesFirst"] != null)
            {
               _loc1_ = Root.smBattleData;
               mOwnerMovesFirst.value = Root.smBattleData["mOwnerMovesFirst"] == true ? 1 : 0;
               return mOwnerMovesFirst;
            }
            mOwnerMovesFirst.value = Utils.randomInt(0,1);
            return mOwnerMovesFirst;
         }
         return mOwnerMovesFirst;
      }
      
      override protected function setupUserInfos(param1:Boolean = false) : void
      {
         mOwnerBattleInfo = new UserBattleInfoPvP(true,mLevelDef.getSku(),param1);
         mOwnerBattleInfo.setBattleEngine(this);
         if(PvPConnectionMng.smPlayingAgainstBOT)
         {
            mOpponentBattleInfo = new UserBattleInfoPvP(false,mLevelDef.getSku());
         }
         else
         {
            mOpponentBattleInfo = new UserBattleInfoPvP(false,mLevelDef.getSku(),param1);
         }
         mOpponentBattleInfo.setBattleEngine(this);
         mUserBattleInfoCatalog = new Dictionary(true);
         mUserBattleInfoCatalog[0] = mOwnerBattleInfo;
         mUserBattleInfoCatalog[1] = mOpponentBattleInfo;
      }
      
      override public function isPvPMatch() : Boolean
      {
         return true;
      }
      
      override protected function onStateMovingCards() : void
      {
         var _loc1_:Boolean = false;
         setBattleStateId(BATTLE_STATE_PLAYER_MOVING_CARDS);
         switch(getPlayersStateId())
         {
            case STATE_OWNER_MOVING_CARDS:
               mBattleScreen.lockUI(false);
               if(InstanceMng.getCurrentScreen() != null && isOnlineMatch())
               {
                  PvPConnectionMng.smExpirationTime = TimerUtil.currentTimeMillis() + TimerUtil.secondToMs(Config.smPvPTurnTime);
                  this.requestPvPTimer(true);
                  this.enableAttack(true);
               }
               checkCardsEventsListeners();
               setNextStateId(STATE_OWNER_PRE_ATTACK);
               break;
            case STATE_OPPONENT_MOVING_CARDS:
               setNextStateId(STATE_OPPONENT_PRE_ATTACK);
               if(isOnlineMatch() && (PvPConnectionMng.isPlayingVSAI() || PvPConnectionMng.smPvPBattleData["save"] != null))
               {
                  _loc1_ = PvPConnectionMng.turnEnded();
                  if(!PvPConnectionMng.realTimeAllowed() || _loc1_)
                  {
                     this.requestPvPTimer(false);
                  }
                  else if(InstanceMng.getCurrentScreen() != null && isOnlineMatch())
                  {
                     PvPConnectionMng.smExpirationTime = TimerUtil.currentTimeMillis() + TimerUtil.secondToMs(Config.smPvPWaitingOpponentMoveTime);
                     this.requestPvPTimer(true);
                  }
                  if(PvPConnectionMng.isPlayingVSAI())
                  {
                     mAIEngine.performNextStep();
                  }
                  else
                  {
                     this.resumeBFCards(false,1);
                  }
               }
               else
               {
                  mBattleScreen.lockUI(false);
                  checkCardsEventsListeners();
               }
         }
         if(mBattleScreen)
         {
            mBattleScreen.suggestPlayableCardON();
         }
      }
      
      override protected function onStateOwnerAdvanceTurn() : void
      {
         if(PvPConnectionMng.smPvPBattleData)
         {
            PvPConnectionMng.smPvPBattleData["save"] = null;
         }
         super.onStateOwnerAdvanceTurn();
      }
      
      override protected function onStateOpponentAdvanceTurn() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         setOpponentCanReceiveNextHand(true);
         managePortraitsRotation();
         setNextStateId(STATE_OPPONENT_RECEIVING_CARDS_FROM_DECK);
         if(this.checkSavedCardsForResume())
         {
            FSDebug.debugTrace("[onStateOpponentAdvanceTurn] - check saved cards for resume -> OK");
            this.resumeOldBFCards();
            _loc1_ = this.loadPlayableEnemyCards();
            _loc2_ = this.loadRecruitEnemyCards();
            loadNextCardsHandResources(null,null,_loc1_,"",_loc2_);
         }
         else if(isOnlineMatch())
         {
            FSDebug.debugTrace("[onStateOpponentAdvanceTurn] - onStateOpponentAdvanceTurn -> OK");
            notifyPlayersAdvanceTurn();
         }
         else
         {
            loadNextCardsHandResources();
         }
         setBattleStateId(BATTLE_STATE_BATTLE_IDLE);
      }
      
      public function loadPlayableEnemyCards() : Array
      {
         var _loc1_:Array = null;
         var _loc3_:FSCard = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc7_:FSCardSocket = null;
         var _loc2_:Object = PvPConnectionMng.smPvPBattleData["save"];
         if(_loc2_ != null && _loc2_["opponentBattleInfo"].mPlayableCardsCatalog != null)
         {
            _loc4_ = 0;
            _loc5_ = mLevelDef.getDeckCards();
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc6_ = _loc2_["opponentBattleInfo"].mPlayableCardsCatalog["card" + _loc4_];
               if(_loc6_ != null)
               {
                  _loc7_ = this.getOldSocketBySaveObject(false,-1,-1,_loc4_);
                  if(_loc7_ != null)
                  {
                     _loc3_ = _loc7_.getParentCard();
                  }
                  if(_loc3_ == null)
                  {
                     if(_loc1_ == null)
                     {
                        _loc1_ = new Array();
                     }
                     _loc1_.push(_loc6_.sku);
                  }
               }
               _loc4_++;
            }
         }
         return _loc1_;
      }
      
      public function loadRecruitEnemyCards() : Array
      {
         var _loc3_:FSCard = null;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:* = 0;
         var _loc7_:int = 0;
         var _loc1_:Array = null;
         var _loc2_:Object = PvPConnectionMng.smPvPBattleData["save"];
         if(Boolean(_loc2_ != null) && Boolean(_loc2_["opponentBattleInfo"]) && Boolean(_loc2_["opponentBattleInfo"].hasOwnProperty("mBFCards")) && _loc2_["opponentBattleInfo"]["mBFCards"] != null)
         {
            _loc6_ = _loc5_ = PvPConnectionMng.getHighestMoveIdForSavedTurn(false);
            while(_loc6_ >= -1)
            {
               if(_loc2_["opponentBattleInfo"]["mBFCards"][PvPConnectionMng.MOVE_ID_PREFIX + _loc6_] != null)
               {
                  _loc7_ = -1;
                  while(_loc7_ < 10)
                  {
                     _loc4_ = _loc2_["opponentBattleInfo"]["mBFCards"][PvPConnectionMng.MOVE_ID_PREFIX + _loc6_]["card" + _loc7_];
                     if(_loc4_ != null)
                     {
                        if(_loc4_.hasOwnProperty("mRecruitCard") && _loc4_["mRecruitCard"] != null && _loc4_["mRecruitCard"] != "")
                        {
                           if(_loc1_ == null)
                           {
                              _loc1_ = new Array();
                           }
                           _loc1_.push(_loc4_["mRecruitCard"]);
                        }
                     }
                     _loc7_++;
                  }
               }
               _loc6_--;
            }
         }
         return _loc1_;
      }
      
      public function onOpponentTurnFinished() : void
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         if(mBattleScreen != null)
         {
            if(isOnlineMatch() && !PvPConnectionMng.realTimeAllowed())
            {
               InstanceMng.getApplication().vibrate();
            }
            _loc1_ = PvPConnectionMng.smPvPBattleData["save"];
            _loc2_ = this.getMoveIdStored();
            _loc3_ = !PvPConnectionMng.realTimeAllowed() || PvPConnectionMng.realTimeAllowed() && this.mLastProcessedMoveId == 0;
            if(PvPConnectionMng.realTimeAllowed() || getPlayersStateId() == BattleEngine.STATE_OPPONENT_RECEIVING_CARDS_FROM_DECK)
            {
               setOpponentCanReceiveNextHand(false);
               if(PvPConnectionMng.isPlayingVSAI())
               {
                  loadNextCardsHandResources(null,mBattleScreen.dealOpponentCardsToDeck);
               }
               else if(this.checkSavedCardsForResume())
               {
                  if(_loc3_)
                  {
                     FSDebug.debugTrace("[needsToLoadResources] - TRUE");
                     _loc4_ = this.loadPlayableEnemyCards();
                     _loc5_ = this.loadRecruitEnemyCards();
                     loadNextCardsHandResources(null,mBattleScreen.dealOpponentCardsToDeck,_loc4_,"",_loc5_);
                  }
                  else
                  {
                     _loc2_ = this.mLastProcessedMoveId == _loc2_ - 1 ? _loc2_ : int(this.mLastProcessedMoveId + 1);
                     this.resumeBFCards(false,_loc2_);
                  }
               }
               else
               {
                  FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_ERROR_DETECTED,{"error":"DEAD END #1"});
               }
            }
            else
            {
               FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_ERROR_DETECTED,{"error":"Attempted to reproduce opponent move but not on OPP RECEIVING CARDS STATE"});
            }
         }
      }
      
      public function checkSavedCardsForResume() : Boolean
      {
         if(isOnlineMatch())
         {
            return PvPConnectionMng.smPvPBattleData["save"] != null && PvPConnectionMng.smPvPBattleData["dataReady"] == true && PvPConnectionMng.smPvPBattleData["ua"] != InstanceMng.getServerConnection().getUserId();
         }
         return false;
      }
      
      public function getMoveIdStored() : int
      {
         var _loc1_:Object = PvPConnectionMng.smPvPBattleData["save"];
         return _loc1_ != null ? int(_loc1_["moveId"]) : -1;
      }
      
      private function resumeOldBFCards() : void
      {
         this.resumeBFCards(true,-1,true);
         this.resumeBFCards(false,-1,true);
      }
      
      override public function resetUILock() : void
      {
         setAbilityWaitingForTarget(null,null,null);
         if(isOnlineMatch() && mIsOwnerTurn || !isOnlineMatch())
         {
            enableAttackButton();
         }
         if(mIsOwnerTurn)
         {
            this.enableSideDeck(true,mBattleScreen.getOwnerSideDeckSocketCatalog());
            if(mBattleScreen is FSBattleScreenPvP && FSBattleScreenPvP(mBattleScreen).getOpponentSideDeckSocketCatalog() != null)
            {
               this.enableSideDeck(false,FSBattleScreenPvP(mBattleScreen).getOpponentSideDeckSocketCatalog(),true);
            }
         }
         else
         {
            this.enableSideDeck(false,mBattleScreen.getOwnerSideDeckSocketCatalog(),true);
            if(!isOnlineMatch())
            {
               if(mBattleScreen is FSBattleScreenPvP && FSBattleScreenPvP(mBattleScreen).getOpponentSideDeckSocketCatalog() != null)
               {
                  this.enableSideDeck(true,FSBattleScreenPvP(mBattleScreen).getOpponentSideDeckSocketCatalog());
               }
            }
         }
         enableBFCards(true);
         enableSacrificeButton(true);
      }
      
      override public function enableSideDeck(param1:Boolean, param2:Dictionary = null, param3:Boolean = false) : void
      {
         if(param2 == null)
         {
            super.enableSideDeck(param1,mBattleScreen.getOwnerSideDeckSocketCatalog(),param3);
            if(mBattleScreen is FSBattleScreenPvP)
            {
               super.enableSideDeck(param1,FSBattleScreenPvP(mBattleScreen).getOpponentSideDeckSocketCatalog(),param3);
            }
         }
         else
         {
            super.enableSideDeck(param1,param2,param3);
         }
      }
      
      override public function canPerformUIActions() : Boolean
      {
         return mIsOwnerTurn ? getPlayersStateId() == STATE_OWNER_MOVING_CARDS : getPlayersStateId() == STATE_OPPONENT_MOVING_CARDS && !isOnlineMatch();
      }
      
      override public function onBattleOverCommonOps() : void
      {
         super.onBattleOverCommonOps();
         this.requestPvPTimer(false);
         this.requestOpponentPvPTimer(false);
         PvPConnectionMng.smUserInPvPBattle = false;
         PvPConnectionMng.smBattleSyncData = null;
         PvPConnectionMng.smInitMatchInfoReceived = false;
         PvPConnectionMng.smUserSettingUpForMatch = false;
      }
      
      override public function onBattleOver(param1:Boolean = false, param2:Boolean = false, param3:Boolean = false, param4:String = "") : void
      {
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:UserData = null;
         var _loc9_:int = 0;
         if(!mBattleOver)
         {
            this.onBattleOverCommonOps();
            _loc5_ = Config.getConfig().battleLoopEndOfLevelMusic() ? -1 : 0;
            if(param1)
            {
               Utils.playSound(Constants.SOUND_VICTORY,SoundManager.TYPE_SFX);
               if(isOnlineMatch())
               {
                  PvPConnectionMng.setMatchAsFinished(param4,true,false);
                  PvPConnectionMng.onPvPMatchWonCheckOptions();
               }
               else
               {
                  Utils.createPvPOverEffect(mOwnerBattleInfo);
               }
               return;
            }
            if(param2)
            {
               Utils.playSound(Constants.SOUND_DEFEAT,SoundManager.TYPE_SFX);
               if(isOnlineMatch())
               {
                  Utils.createPvPOverEffect(mOpponentBattleInfo,PvPConnectionMng.smCurrentMatchEloLostIfMatchLost - PvPConnectionMng.smEloBeforeStartingMatch,null,PvPConnectionMng.smPlayingFriendlyMatch);
               }
               else
               {
                  Utils.createPvPOverEffect(mOpponentBattleInfo);
               }
               if(!PvPConnectionMng.smPlayingFriendlyMatch)
               {
                  PvPConnectionMng.calculateClassPointsWon(false);
               }
               return;
            }
            if(param3)
            {
               if(isOnlineMatch())
               {
                  PvPConnectionMng.onPvPMatchDesynchronized();
               }
               return;
            }
            _loc6_ = mOwnerBattleInfo.getHP() > 0;
            _loc7_ = mOwnerBattleInfo.getHP() <= 0 && mOpponentBattleInfo.getHP() <= 0;
            if(_loc7_)
            {
               Utils.playSound(Constants.SOUND_DEFEAT,SoundManager.TYPE_SFX);
               if(isOnlineMatch() && !isOwnerTurn())
               {
                  PvPConnectionMng.setMatchAsFinished("",false,true);
               }
               PvPConnectionMng.onPvPMatchDraw();
            }
            else if(_loc6_)
            {
               Utils.playSound(Constants.SOUND_VICTORY,SoundManager.TYPE_SFX);
               if(isOnlineMatch())
               {
                  if(!isOwnerTurn() || PvPConnectionMng.isPlayingVSAI())
                  {
                     PvPConnectionMng.setMatchAsFinished("",true,false);
                  }
                  PvPConnectionMng.onPvPMatchWonCheckOptions();
               }
               else
               {
                  Utils.createPvPOverEffect(mOwnerBattleInfo);
               }
            }
            else
            {
               Utils.playSound(Constants.SOUND_DEFEAT,SoundManager.TYPE_SFX);
               if(isOnlineMatch())
               {
                  if(!isOwnerTurn() || PvPConnectionMng.isPlayingVSAI())
                  {
                     PvPConnectionMng.setMatchAsFinished("",false,false);
                  }
                  Utils.createPvPOverEffect(mOpponentBattleInfo,PvPConnectionMng.smCurrentMatchEloLostIfMatchLost - PvPConnectionMng.smEloBeforeStartingMatch,null,PvPConnectionMng.smPlayingFriendlyMatch);
                  _loc8_ = Utils.getOwnerUserData();
                  _loc9_ = _loc8_ ? _loc8_.getElo() : 0;
                  FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_LOST,{"elo":_loc9_});
                  if(!PvPConnectionMng.smPlayingFriendlyMatch)
                  {
                     PvPConnectionMng.calculateClassPointsWon(false);
                  }
               }
               else
               {
                  Utils.createPvPOverEffect(mOpponentBattleInfo);
               }
            }
         }
      }
      
      public function onCardMoved(param1:FSCard, param2:String, param3:int, param4:String = "") : void
      {
         if(param1 != null)
         {
            PvPConnectionMng.storeBFCard(true,"",mIsOwnerTurn,param1,param2,param3,param4);
         }
      }
      
      public function onCardRectification(param1:FSCard, param2:int, param3:int = -1) : void
      {
         var _loc4_:String = null;
         if(param1 != null)
         {
            if(PvPConnectionMng.realTimeAllowed())
            {
               _loc4_ = param1.getOldSocketIndexCode(param3);
               PvPConnectionMng.storeBFCard(true,"",mIsOwnerTurn,param1,_loc4_,param2,"","false","","","false","false","true");
            }
            else
            {
               PvPConnectionMng.updateStoredBFCardWithNewPosition(param1,param2,param3);
            }
         }
      }
      
      public function onCardPromoted(param1:FSCard, param2:String, param3:Boolean = false) : void
      {
         var _loc4_:String = "bf_" + param1.getAttachedToSocket().getSocketIndex();
         if(!param3)
         {
            PvPConnectionMng.storeBFCard(true,"",mIsOwnerTurn,param1,_loc4_,param1.getAttachedToSocket().getSocketIndex(),"","true",param2);
         }
         else
         {
            PvPConnectionMng.storeBFCard(true,"",mIsOwnerTurn,param1,_loc4_,param1.getAttachedToSocket().getSocketIndex(),"","false",param2,"true");
         }
      }
      
      public function onUnitTargetSelected(param1:FSCard, param2:String) : void
      {
         if(param1 != null)
         {
            PvPConnectionMng.updateStoredBFCardWithAbilityLockTargetInfo(param1,param2);
         }
      }
      
      public function onSacrificeUnitTargetSelected(param1:String) : void
      {
         PvPConnectionMng.storeSacrifice("",param1);
      }
      
      public function onPowerUnitTargetSelected(param1:String) : void
      {
         var _loc2_:FSPower = isOwnerTurn() ? getOwnerBattleInfo().getPowerCardFromDeck() : getOpponentBattleInfo().getPowerCardFromDeck();
         var _loc3_:Boolean = _loc2_.hasRandomStatsAbilities();
         var _loc4_:Boolean = _loc2_.hasMulticastAbilities();
         _loc2_.setStoredEligibleItemCode(param1);
         if(PvPConnectionMng.realTimeAllowed() && !_loc3_ && !_loc4_ || !PvPConnectionMng.realTimeAllowed())
         {
            PvPConnectionMng.storePower(true,_loc2_,param1);
         }
      }
      
      public function onRandomUnitTargetSelected(param1:FSCard, param2:String) : void
      {
         if(param1 != null)
         {
            PvPConnectionMng.updateStoredBFCardWithAbilityRandomTargetInfo(param1,param2);
         }
      }
      
      public function onRandomUnitAbilityPropertyTriggered(param1:FSCard, param2:*, param3:int = 0, param4:int = 0, param5:int = 0, param6:int = 0, param7:int = 0) : void
      {
         if(param1 != null)
         {
            PvPConnectionMng.updateStoredBFCardWithAbilityRandomValueInfo(param1,param2,param3,param4,param5,param6,param7);
         }
      }
      
      public function onMulticastAbilityPropertyTriggered(param1:FSCard, param2:int) : void
      {
         if(param1 != null)
         {
            PvPConnectionMng.updateStoredBFCardWithMulticastFactor(param1,param2);
         }
      }
      
      public function onActionUsed(param1:FSCard, param2:String, param3:String, param4:String) : void
      {
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         if(param1 != null)
         {
            param1.setStoredOldSocketIndexCode(param2);
            _loc5_ = param1.hasRandomStatsAbilities();
            _loc6_ = param1.hasMulticastAbilities();
            FSAction(param1).setStoredEligibleItemCode(param3);
            FSAction(param1).setStoredAbilitySku(param4);
            if(PvPConnectionMng.realTimeAllowed() && !_loc5_ && !_loc6_ || !PvPConnectionMng.realTimeAllowed())
            {
               PvPConnectionMng.storeBFAction(true,"",mIsOwnerTurn,param1,param2,param3,param4);
            }
         }
      }
      
      public function onOwnerCardsDealt(param1:Boolean = false) : void
      {
         var _loc2_:Dictionary = null;
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:FSCard = null;
         var _loc6_:int = 0;
         PvPConnectionMng.smMoveId = 1;
         if(isOnlineMatch() && mOwnerBattleInfo != null)
         {
            _loc2_ = mOwnerBattleInfo.getPlayableCardsCatalog();
            _loc3_ = getCurrentTurnId().toString();
            PvPConnectionMng.prepareSaveObj(_loc3_,Root.smBattleData["mOwnerMovesFirst"]);
            _loc4_ = Utils.vectorToArray(_loc2_);
            if(_loc4_ != null)
            {
               _loc4_.sort(DictionaryUtils.sortCardsCatalogByPlayableCardId);
               _loc6_ = 0;
               while(_loc6_ < _loc4_.length)
               {
                  _loc5_ = _loc4_[_loc6_];
                  if(_loc5_ != null)
                  {
                     PvPConnectionMng.storePlayableCard(_loc5_.getCardDef().getSku(),_loc5_.getPlayableCardId(),_loc5_.getSummonCooldownTurnsLeft());
                     InstanceMng.getBattleEngine().storeCombatLogAction(BattleEngine.COMBAT_LOG_CARD_TO_HAND,_loc5_);
                  }
                  _loc6_++;
               }
               TweenMax.delayedCall(1,PvPConnectionMng.sendPlayableCards,[param1]);
            }
         }
      }
      
      public function onMatchDesynchronizedPerformOps(param1:Boolean = false, param2:Boolean = false) : void
      {
         if(Boolean(InstanceMng.getBattleEngine()) && InstanceMng.getBattleEngine() is BattleEnginePvP)
         {
            BattleEnginePvP(InstanceMng.getBattleEngine()).onBattleOver(false,param1,!param1);
         }
         var _loc3_:String = param2 ? "TID_PVP_MATCH_CANCELLED" : "TID_GEN_DESYNC";
         Utils.setLogText(TextManager.getText(_loc3_),true);
      }
      
      public function isAttackaAllowed() : Boolean
      {
         return this.mAttackEnabled;
      }
      
      public function enableAttack(param1:Boolean) : void
      {
         this.mAttackEnabled = param1;
      }
      
      private function getBattleScreenPvP() : FSBattleScreenPvP
      {
         return FSBattleScreenPvP(mBattleScreen);
      }
      
      public function requestPvPTimer(param1:Boolean) : void
      {
         var _loc2_:FSTimeLeftCounter = null;
         if(mBattleScreen)
         {
            _loc2_ = this.getBattleScreenPvP().getTimeLeftCounter();
            if(Boolean(_loc2_) && !param1)
            {
               _loc2_.updateCounterAmount("--");
            }
            this.mRequestPvPTimer = param1;
            if(this.mRequestPvPTimer)
            {
               this.updateTimeLeftCounter();
            }
         }
         this.mPlayingClockTickingSound = false;
         Utils.stopSound("clock_ticking");
      }
      
      public function requestOpponentPvPTimer(param1:Boolean) : void
      {
         if(this.mRequestOpponentPvPTimer == false && param1 == true)
         {
            this.mPreTimeoutCheckDone = false;
            this.mTimeoutCheckDone = false;
            this.mPostTimeoutCheckDone = false;
            this.mLastTimeoutCheckDone = false;
         }
         this.mRequestOpponentPvPTimer = param1;
         if(this.mRequestOpponentPvPTimer == true)
         {
            enableBFCards(true);
            if(PvPConnectionMng.isPlayingVSAI())
            {
               this.prepareBotMove();
            }
         }
      }
      
      private function updateTimeLeftCounter() : void
      {
         var _loc1_:FSTimeLeftCounter = null;
         if(this.mRequestPvPTimer)
         {
            _loc1_ = this.getBattleScreenPvP().getTimeLeftCounter();
            if(_loc1_)
            {
               _loc1_.updateCounterAmount(PvPConnectionMng.getTimeTextLeft(true));
               TweenMax.killDelayedCallsTo(this.updateTimeLeftCounter);
               TweenMax.delayedCall(1,this.updateTimeLeftCounter);
            }
         }
      }
      
      public function isRequestOpponentPvPTimerActive() : Boolean
      {
         return this.mRequestOpponentPvPTimer;
      }
      
      public function onEnterFrame(param1:Event) : void
      {
         var _loc2_:FSCard = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         if(this.mRequestPvPTimer)
         {
            PvPConnectionMng.refreshExpirationTimeLeft();
            if(PvPConnectionMng.smExpirationTimeLeft <= CLOCK_TICKING_TIME && (!isOnlineMatch() || isOnlineMatch() && this.isAttackaAllowed()))
            {
               if(!this.mPlayingClockTickingSound)
               {
                  this.mPlayingClockTickingSound = true;
                  Utils.playSound("clock_ticking",SoundManager.TYPE_SFX);
               }
            }
            if(PvPConnectionMng.smExpirationTimeLeft <= 0 && (!isOnlineMatch() || isOnlineMatch() && this.isAttackaAllowed()))
            {
               this.mPlayingClockTickingSound = false;
               Utils.stopSound("clock_ticking");
               this.requestPvPTimer(false);
               disableAttackButton();
               _loc2_ = getCardBeingMoved();
               if(_loc2_)
               {
                  _loc2_.touchable = false;
                  _loc2_.moveCardBackToItsOriginalDeckSlot();
               }
               if(mBattleScreen.getSelectedCard() != null && mBattleScreen.getSelectedCard().isZoomedIn())
               {
                  SpecialFX.zoomOut(mBattleScreen.getSelectedCard());
               }
               this.checkCardsWaitingToChooseTarget();
               this.getBattleScreenPvP().lockUI(true);
               this.handleSacrificeTargets();
               this.handlePowerTargets();
               this.getBattleScreenPvP().unHighlightAllSockets();
               this.getBattleScreenPvP().closeAbilitiesChooserPanel();
               if(InstanceMng.getPopupMng().getPopupShown() == null || InstanceMng.getPopupMng().getPopupShown() != null && !(InstanceMng.getPopupMng().getPopupShown() is PopupPvPMatchDesynchronized))
               {
                  InstanceMng.getPopupMng().closePopupShown();
                  Utils.setLogText(TextManager.getText("TID_PVP_AUTOATTACK"));
                  this.getBattleScreenPvP().suggestPlayableCardOFF();
                  TweenMax.delayedCall(3,this.onPvPTurnTimeout);
               }
            }
         }
         if(this.mRequestOpponentPvPTimer)
         {
            if(Boolean(mBattleScreen) && (Boolean(mBattleScreen.getSelectedCard() == null) || Boolean(mBattleScreen.getSelectedCard() && !mBattleScreen.getSelectedCard().isZoomedIn())))
            {
               if(PvPConnectionMng.realTimeAllowed())
               {
                  PvPConnectionMng.refreshExpirationTimeLeft();
                  if(PvPConnectionMng.smExpirationTimeLeft > TimerUtil.secondToMs(30) && !isResumingPvPCard() && InstanceMng.getServerConnection().getTimeoutsAmount() == 0)
                  {
                     Utils.setLogText(TextManager.getText("TID_PVP_WAITING"),false,true,true,false);
                  }
               }
               else
               {
                  _loc3_ = PvPConnectionMng.getTimeTextLeft();
                  _loc4_ = PvPConnectionMng.smExpirationTimeLeft < TimerUtil.secondToMs(60) ? TextManager.getText("TID_PVP_WAITING") + " " + _loc3_ : TextManager.getText("TID_PVP_WAITING");
                  Utils.setLogText(_loc4_,false,true,true,false);
                  this.updateTimeLeftCounter();
               }
            }
            if(!PvPConnectionMng.isPlayingVSAI())
            {
               _loc5_ = Config.smPvPWaitingOpponentMoveTime;
               _loc6_ = _loc5_ / 4;
               if(!this.mPreTimeoutCheckDone && PvPConnectionMng.smExpirationTimeLeft < TimerUtil.secondToMs(_loc6_ * 3))
               {
                  this.mPreTimeoutCheckDone = true;
                  PvPConnectionMng.getMatchInfo(PvPConnectionMng.smCurrentMatchId,this.onMatchInfoACK,null,this.onMatchInfoError);
               }
               if(!this.mTimeoutCheckDone && PvPConnectionMng.smExpirationTimeLeft < TimerUtil.secondToMs(_loc6_ * 2))
               {
                  this.mTimeoutCheckDone = true;
                  PvPConnectionMng.getMatchInfo(PvPConnectionMng.smCurrentMatchId,this.onMatchInfoACK,null,this.onMatchInfoError);
               }
               if(!this.mPostTimeoutCheckDone && PvPConnectionMng.smExpirationTimeLeft < TimerUtil.secondToMs(_loc6_ * 1))
               {
                  this.mPostTimeoutCheckDone = true;
                  PvPConnectionMng.getMatchInfo(PvPConnectionMng.smCurrentMatchId,this.onMatchInfoACK,null,this.onMatchInfoError);
               }
               if(!this.mLastTimeoutCheckDone && PvPConnectionMng.smExpirationTimeLeft <= 0)
               {
                  this.mLastTimeoutCheckDone = true;
                  PvPConnectionMng.getMatchInfo(PvPConnectionMng.smCurrentMatchId,this.onMatchInfoACK,null,this.onMatchInfoError);
               }
            }
            if(PvPConnectionMng.smExpirationTimeLeft <= 0)
            {
               this.onOpponentTimeEndedPerformCommonOps();
               this.onTimerEndCheckDesync();
            }
         }
      }
      
      public function onMatchInfoACK(param1:Object) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:String = null;
         PvPConnectionMng.smServerMatchData = param1;
         var _loc2_:String = InstanceMng.getServerConnection().getUserId();
         if(param1.status == PvPConnectionMng.MATCH_STATUS_DEAD)
         {
            this.onOpponentTimeEndedPerformCommonOps();
            this.onMatchDesynchronizedPerformOps(false,true);
            FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_PVP_MATCH_DEAD);
         }
         else if(param1.status == PvPConnectionMng.MATCH_STATUS_FINISHED)
         {
            this.onOpponentTimeEndedPerformCommonOps();
            if(param1.matchResultplayerInvolved == _loc2_)
            {
               FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_PVP_MATCH_FINISHED,{"info":"Player involved -> OWNER"});
               this.onMatchDesynchronizedPerformOps(true);
            }
            else
            {
               FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_PVP_MATCH_FINISHED,{"info":"Player involved -> OPPONENT"});
               this.onOpponentAwayPerformOps();
            }
         }
         else if(param1.status == PvPConnectionMng.MATCH_STATUS_ACTIVE)
         {
            if(param1.turnId != -1)
            {
               _loc3_ = PvPConnectionMng.onMoveFinishedCheckPool();
               if(_loc3_)
               {
                  return;
               }
               _loc4_ = param1["ua"] != _loc2_;
               _loc5_ = param1["turnEnded"] == true;
               if(_loc4_)
               {
                  if(this.mLastTimeoutCheckDone && !_loc5_)
                  {
                     this.onOpponentTimeEndedPerformCommonOps();
                     FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_PVP_MATCH_DESYNCHRONIZED,{"info":"Time expired, opponent turn NOT FINISHED"});
                     this.onOpponentAwayPerformOps();
                  }
                  else if(PvPConnectionMng.realTimeAllowed())
                  {
                     if(_loc5_)
                     {
                        PvPConnectionMng.onMatchDataACKPerformOpponentRound(param1);
                     }
                     else
                     {
                        PvPConnectionMng.onMatchDataACKPerformOpponentMove(param1);
                     }
                  }
                  else
                  {
                     PvPConnectionMng.onMatchDataACKPerformOpponentRound(param1);
                  }
               }
               else
               {
                  this.onOpponentTimeEndedPerformCommonOps();
                  FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_PVP_MATCH_DESYNCHRONIZED,{"info":"Time expired, opponent turn NOT STARTED"});
                  this.onOpponentAwayPerformOps();
               }
            }
            else
            {
               this.onOpponentTimeEndedPerformCommonOps();
               _loc6_ = param1["u1"]["movesFirst"] ? param1["u1"]["uid"] : param1["u2"]["uid"];
               if(_loc6_ != "BOT_UID" && param1["matchType"] != "OFFLINE" && _loc6_ != _loc2_)
               {
                  FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_PVP_MATCH_DESYNCHRONIZED,{"info":"Turn -1 && UA -> OPPONENT"});
                  this.onOpponentAwayPerformOps();
               }
               else
               {
                  FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_PVP_MATCH_DESYNCHRONIZED,{"info":"Turn -1 && UA -> OWNER"});
                  this.onMatchDesynchronizedPerformOps(true);
               }
            }
         }
         else
         {
            this.onOpponentTimeEndedPerformCommonOps();
            FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_PVP_MATCH_DESYNCHRONIZED,{"info":"Status is not normal"});
            this.onMatchDesynchronizedPerformOps(false,true);
         }
      }
      
      private function onMatchInfoError() : void
      {
         if(PvPConnectionMng.smExpirationTimeLeft < 0)
         {
            FSDebug.debugTrace("Owner was offline too long (ERROR RETURNED WHEN ATTEMPTING TO UPDATE MATCH!");
            FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_PVP_MATCH_FINISHED,{"info":"OWNER too many errors attempting to access match"});
            this.onMatchDesynchronizedPerformOps(true);
         }
      }
      
      public function onOpponentTimeEndedPerformCommonOps() : void
      {
         this.requestOpponentPvPTimer(false);
         if(mBattleScreen != null && mBattleScreen.getSelectedCard() != null && mBattleScreen.getSelectedCard().isZoomedIn())
         {
            SpecialFX.zoomOut(mBattleScreen.getSelectedCard());
         }
         if(this.getBattleScreenPvP())
         {
            this.getBattleScreenPvP().lockUI(true);
         }
      }
      
      private function onTimerEndCheckDesync(param1:int = 0) : void
      {
         Utils.setLogText(TextManager.getText("TID_PVP_MATCH_INFO"),true,true,false);
         if(Boolean(InstanceMng.getServerConnection().isUserLoggedIn()) && Boolean(InstanceMng.getCurrentScreen()) && InstanceMng.getCurrentScreen().isFullyLoaded())
         {
            PvPConnectionMng.getMatchInfo(PvPConnectionMng.smCurrentMatchId,this.onMatchInfoACK);
         }
         else if(param1 < 10)
         {
            param1++;
            setTimeout(this.onTimerEndCheckDesync,3000,param1);
         }
         else
         {
            this.onMatchDesynchronizedPerformOps(true);
         }
      }
      
      private function handleSacrificeTargets() : void
      {
         var _loc1_:FSBattleScreen = null;
         if(Config.getConfig().gameHasSacrifice())
         {
            _loc1_ = InstanceMng.getCurrentScreen() as FSBattleScreen;
            enableSacrificeButton(false);
            setSacrificeWaitingForTarget(false);
            if(_loc1_)
            {
               _loc1_.enableSacrificeButton(isOwnerTurn(),false);
               _loc1_.highlightSacrificeTargets(false);
            }
         }
      }
      
      private function handlePowerTargets() : void
      {
         var _loc1_:FSBattleScreen = null;
         if(Config.getConfig().gameHasPowers())
         {
            _loc1_ = InstanceMng.getCurrentScreen() as FSBattleScreen;
            if(isOwnerTurn())
            {
               getOwnerBattleInfo().setPowerAvailable(false,true);
            }
            else
            {
               getOpponentBattleInfo().setPowerAvailable(false,true);
            }
            setPowerWaitingForTarget(false);
            if(_loc1_)
            {
               _loc1_.highlightPowerTargets(false,PowerDef(mOwnerBattleInfo.getPowerCardFromDeck().getCardDef()));
               _loc1_.unHighlightPlayablePortraits(true);
            }
         }
      }
      
      private function checkCardsWaitingToChooseTarget() : void
      {
         var _loc2_:FSCard = null;
         var _loc1_:Ability = getAbilityWaitingForTarget();
         if(_loc1_)
         {
            _loc2_ = _loc1_.getParentCard();
            if(_loc2_)
            {
               _loc2_.revertCardToActionDeck();
            }
            setAbilityWaitingForTarget(null,null,null);
         }
      }
      
      public function onNewPvPRoundReceivedPerformCommonOps(param1:Boolean = false) : void
      {
         var _loc2_:Object = PvPConnectionMng.smPvPBattleData["save"];
         if(!PvPConnectionMng.realTimeAllowed() || PvPConnectionMng.realTimeAllowed() && param1)
         {
            this.requestOpponentPvPTimer(false);
         }
         if(this.getBattleScreenPvP().getSelectedCard() != null && this.getBattleScreenPvP().getSelectedCard().isZoomedIn())
         {
            SpecialFX.zoomOut(this.getBattleScreenPvP().getSelectedCard());
         }
         this.getBattleScreenPvP().lockUI(true);
         Utils.removeLog();
         if(!PvPConnectionMng.realTimeAllowed())
         {
            Utils.playSound(Constants.SOUND_HELP,SoundManager.TYPE_SFX);
         }
      }
      
      private function onOpponentAwayPerformOps() : void
      {
         FSDebug.debugTrace("[onPlayerDesyncrhonizedPerformOps] - Desynchronized");
         this.onBattleOver(true,false,false,"ROUND_TIMEOUT");
         FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_WON,{"info":"opponent away -> win"});
         Utils.setLogText(TextManager.getText("TID_PVP_ENEMY_DISCONNECTED"));
      }
      
      public function onPvPTurnTimeout() : void
      {
         if(isOnlineMatch() && !Utils.smInternetAvailable)
         {
            this.onMatchDesynchronizedPerformOps(true);
            return;
         }
         if(Boolean(this.getBattleScreenPvP()) && Boolean(this.getBattleScreenPvP().getAttackButton()))
         {
            this.getBattleScreenPvP().getAttackButton().performCommonOpsBeforeAttacking();
            this.getBattleScreenPvP().getAttackButton().updateVisualHighlights(true);
         }
      }
      
      private function getPlayableCardBySaveObject(param1:Boolean, param2:int) : FSCard
      {
         var _loc4_:FSCard = null;
         var _loc6_:Object = null;
         var _loc7_:FSCardSocket = null;
         var _loc3_:Object = PvPConnectionMng.smPvPBattleData["save"];
         var _loc5_:String = param1 ? "ownerBattleInfo" : "opponentBattleInfo";
         if(_loc3_[_loc5_].mPlayableCardsCatalog != null)
         {
            _loc6_ = _loc3_[_loc5_].mPlayableCardsCatalog["card" + param2];
            if(_loc6_ != null)
            {
               _loc7_ = this.getOldSocketBySaveObject(param1,-1,-1,param2);
               if(_loc7_ != null)
               {
                  _loc4_ = _loc7_.getParentCard();
               }
               if(_loc4_ == null)
               {
                  _loc4_ = InstanceMng.getCardsMng().createCard(_loc6_.sku);
               }
               _loc4_.updateSummonCooldown(_loc6_.mSummonCooldownTurnsLeft);
               if(_loc6_.mId != null && _loc6_.mId != -1)
               {
                  _loc4_.setId(_loc6_.mId);
               }
            }
         }
         return _loc4_;
      }
      
      public function getAbilityTargetBySaveObject(param1:Boolean, param2:int, param3:Ability, param4:Vector.<FSCardSocket>, param5:Vector.<UserBattleInfo>) : void
      {
         var _loc6_:* = undefined;
         var _loc8_:FSCard = null;
         var _loc10_:Object = null;
         var _loc11_:String = null;
         var _loc12_:Dictionary = null;
         var _loc13_:Array = null;
         var _loc14_:FSCardSocket = null;
         var _loc15_:int = 0;
         var _loc16_:Array = null;
         var _loc7_:Object = PvPConnectionMng.smPvPBattleData["save"];
         var _loc9_:String = param1 ? "ownerBattleInfo" : "opponentBattleInfo";
         if(_loc7_[_loc9_].mBFCards != null)
         {
            _loc10_ = PvPConnectionMng.getSavedObjectByMoveIdAndCardId(param1,param2,PvPConnectionMng.MOVE_ID_PREFIX + this.mCurrentMoveId);
            if(_loc10_ != null)
            {
               _loc11_ = _loc10_["mAbilityLockTargetInfo"];
               if(_loc11_ != null)
               {
                  _loc13_ = _loc11_.split("_");
                  if(_loc13_ != null)
                  {
                     switch(_loc13_[0])
                     {
                        case "owner":
                           if(_loc13_[1] != null)
                           {
                              switch(_loc13_[1])
                              {
                                 case "card":
                                    _loc12_ = param1 ? mBattleScreen.getOpponentBFSocketCatalog() : mBattleScreen.getOwnerBFSocketCatalog();
                                    if(_loc13_[2] != null)
                                    {
                                       _loc14_ = mBattleScreen.getCardSocketByIndex(_loc13_[2],_loc12_);
                                       if(_loc14_ != null)
                                       {
                                          _loc6_ = _loc14_.getParentCard();
                                       }
                                    }
                                    break;
                                 case "portrait":
                                    _loc6_ = param1 ? mOpponentBattleInfo : mOwnerBattleInfo;
                              }
                           }
                           break;
                        case "opponent":
                           if(_loc13_[1] != null)
                           {
                              switch(_loc13_[1])
                              {
                                 case "card":
                                    _loc12_ = param1 ? mBattleScreen.getOwnerBFSocketCatalog() : mBattleScreen.getOpponentBFSocketCatalog();
                                    if(_loc13_[2] != null)
                                    {
                                       _loc14_ = mBattleScreen.getCardSocketByIndex(_loc13_[2],_loc12_);
                                       if(_loc14_ != null)
                                       {
                                          _loc6_ = _loc14_.getParentCard();
                                       }
                                    }
                                    break;
                                 case "portrait":
                                    _loc6_ = param1 ? mOwnerBattleInfo : mOpponentBattleInfo;
                              }
                           }
                           break;
                        case "":
                           if(param4 != null)
                           {
                              if(_loc6_ == null)
                              {
                                 _loc6_ = new Array();
                              }
                              _loc15_ = 0;
                              while(_loc15_ < param4.length)
                              {
                                 _loc6_.push(FSCardSocket(param4[_loc15_]).getParentCard());
                                 _loc15_++;
                              }
                           }
                           if(param5 != null)
                           {
                              if(_loc6_ == null)
                              {
                                 _loc6_ = new Array();
                              }
                              _loc15_ = 0;
                              while(_loc15_ < param5.length)
                              {
                                 _loc6_.push(param5[_loc15_]);
                                 _loc15_++;
                              }
                           }
                           if(_loc6_ != null)
                           {
                              param3.onTargetSelected(_loc6_ as Array);
                              return;
                           }
                     }
                  }
               }
            }
         }
         if(param3 != null && _loc6_ != null)
         {
            _loc16_ = new Array();
            _loc16_[0] = _loc6_;
            param3.onTargetSelected(_loc16_);
         }
         else
         {
            param3.onTargetSelected(null);
         }
      }
      
      public function getPowerTargetBySaveObject(param1:Boolean, param2:Vector.<FSCardSocket> = null, param3:Vector.<UserBattleInfo> = null) : *
      {
         var _loc4_:* = undefined;
         var _loc6_:FSCard = null;
         var _loc8_:String = null;
         var _loc9_:Dictionary = null;
         var _loc10_:Array = null;
         var _loc11_:FSCardSocket = null;
         var _loc12_:int = 0;
         var _loc5_:Object = PvPConnectionMng.smPvPBattleData["save"];
         var _loc7_:String = param1 ? "ownerBattleInfo" : "opponentBattleInfo";
         if(_loc5_[_loc7_].mBFCards != null)
         {
            _loc8_ = PvPConnectionMng.getSavedSacrificeTargetByMoveId(param1,PvPConnectionMng.MOVE_ID_PREFIX + this.mCurrentMoveId);
            if(_loc8_ != null)
            {
               _loc10_ = _loc8_.split("_");
               if(_loc10_ != null)
               {
                  switch(_loc10_[0])
                  {
                     case "owner":
                        if(_loc10_[1] != null)
                        {
                           switch(_loc10_[1])
                           {
                              case "card":
                                 _loc9_ = param1 ? mBattleScreen.getOpponentBFSocketCatalog() : mBattleScreen.getOwnerBFSocketCatalog();
                                 if(_loc10_[2] != null)
                                 {
                                    _loc11_ = mBattleScreen.getCardSocketByIndex(_loc10_[2],_loc9_);
                                    if(_loc11_ != null)
                                    {
                                       _loc4_ = _loc11_.getParentCard();
                                    }
                                 }
                                 break;
                              case "portrait":
                                 _loc4_ = param1 ? getOpponentBattleInfo() : getOwnerBattleInfo();
                           }
                        }
                        break;
                     case "opponent":
                        if(_loc10_[1] != null)
                        {
                           switch(_loc10_[1])
                           {
                              case "card":
                                 _loc9_ = param1 ? mBattleScreen.getOwnerBFSocketCatalog() : mBattleScreen.getOpponentBFSocketCatalog();
                                 if(_loc10_[2] != null)
                                 {
                                    _loc11_ = mBattleScreen.getCardSocketByIndex(_loc10_[2],_loc9_);
                                    if(_loc11_ != null)
                                    {
                                       _loc4_ = _loc11_.getParentCard();
                                    }
                                 }
                                 break;
                              case "portrait":
                                 _loc4_ = param1 ? getOwnerBattleInfo() : getOpponentBattleInfo();
                           }
                        }
                        break;
                     case "":
                        if(param2 != null)
                        {
                           if(_loc4_ == null)
                           {
                              _loc4_ = new Array();
                           }
                           _loc12_ = 0;
                           while(_loc12_ < param2.length)
                           {
                              _loc4_.push(FSCardSocket(param2[_loc12_]).getParentCard());
                              _loc12_++;
                           }
                        }
                        if(param3 != null)
                        {
                           if(_loc4_ == null)
                           {
                              _loc4_ = new Array();
                           }
                           _loc12_ = 0;
                           while(_loc12_ < param3.length)
                           {
                              _loc4_.push(param3[_loc12_]);
                              _loc12_++;
                           }
                        }
                  }
               }
            }
         }
         return _loc4_;
      }
      
      private function getSacrificeTargetBySaveObject(param1:Boolean) : FSCard
      {
         var _loc2_:FSCard = null;
         var _loc4_:FSCard = null;
         var _loc6_:String = null;
         var _loc7_:Dictionary = null;
         var _loc8_:Array = null;
         var _loc9_:FSCardSocket = null;
         var _loc3_:Object = PvPConnectionMng.smPvPBattleData["save"];
         var _loc5_:String = param1 ? "ownerBattleInfo" : "opponentBattleInfo";
         if(_loc3_[_loc5_].mBFCards != null)
         {
            _loc6_ = PvPConnectionMng.getSavedSacrificeTargetByMoveId(param1,PvPConnectionMng.MOVE_ID_PREFIX + this.mCurrentMoveId);
            if(_loc6_ != null)
            {
               _loc8_ = _loc6_.split("_");
               if(_loc8_ != null)
               {
                  switch(_loc8_[0])
                  {
                     case "owner":
                        if(_loc8_[1] != null)
                        {
                           switch(_loc8_[1])
                           {
                              case "card":
                                 _loc7_ = param1 ? mBattleScreen.getOwnerBFSocketCatalog() : mBattleScreen.getOpponentBFSocketCatalog();
                                 if(_loc8_[2] != null)
                                 {
                                    _loc9_ = mBattleScreen.getCardSocketByIndex(_loc8_[2],_loc7_);
                                    if(_loc9_ != null)
                                    {
                                       _loc2_ = _loc9_.getParentCard();
                                    }
                                 }
                           }
                        }
                        break;
                     case "opponent":
                        if(_loc8_[1] != null)
                        {
                           switch(_loc8_[1])
                           {
                              case "card":
                                 _loc7_ = param1 ? mBattleScreen.getOpponentBFSocketCatalog() : mBattleScreen.getOwnerBFSocketCatalog();
                                 if(_loc8_[2] != null)
                                 {
                                    _loc9_ = mBattleScreen.getCardSocketByIndex(_loc8_[2],_loc7_);
                                    if(_loc9_ != null)
                                    {
                                       _loc2_ = _loc9_.getParentCard();
                                    }
                                 }
                           }
                        }
                  }
               }
            }
         }
         return _loc2_;
      }
      
      public function getAbilityRandomTargetBySaveObject(param1:Boolean, param2:int, param3:Ability) : *
      {
         var _loc4_:* = undefined;
         var _loc6_:FSCard = null;
         var _loc8_:Object = null;
         var _loc9_:String = null;
         var _loc10_:Dictionary = null;
         var _loc11_:Array = null;
         var _loc12_:FSCardSocket = null;
         var _loc5_:Object = PvPConnectionMng.smPvPBattleData["save"];
         var _loc7_:String = param1 ? "ownerBattleInfo" : "opponentBattleInfo";
         if(_loc5_[_loc7_].mBFCards != null)
         {
            _loc8_ = PvPConnectionMng.getSavedObjectByMoveIdAndCardId(param1,param2,PvPConnectionMng.MOVE_ID_PREFIX + this.mCurrentMoveId);
            if(_loc8_ != null)
            {
               _loc9_ = _loc8_["mAbilityRandomTargetInfo"];
               if(_loc9_ != null)
               {
                  _loc11_ = _loc9_.split("_");
                  if(_loc11_ != null)
                  {
                     switch(_loc11_[0])
                     {
                        case "owner":
                           if(_loc11_[1] != null)
                           {
                              switch(_loc11_[1])
                              {
                                 case "card":
                                    _loc10_ = param1 ? mBattleScreen.getOpponentBFSocketCatalog() : mBattleScreen.getOwnerBFSocketCatalog();
                                    if(_loc11_[2] != null)
                                    {
                                       _loc12_ = mBattleScreen.getCardSocketByIndex(_loc11_[2],_loc10_);
                                       if(_loc12_ != null)
                                       {
                                          _loc4_ = _loc12_.getParentCard();
                                       }
                                    }
                                    break;
                                 case "portrait":
                                    _loc4_ = param1 ? mOpponentBattleInfo : mOwnerBattleInfo;
                              }
                           }
                           break;
                        case "opponent":
                           if(_loc11_[1] != null)
                           {
                              switch(_loc11_[1])
                              {
                                 case "card":
                                    _loc10_ = param1 ? mBattleScreen.getOwnerBFSocketCatalog() : mBattleScreen.getOpponentBFSocketCatalog();
                                    if(_loc11_[2] != null)
                                    {
                                       _loc12_ = mBattleScreen.getCardSocketByIndex(_loc11_[2],_loc10_);
                                       if(_loc12_ != null)
                                       {
                                          _loc4_ = _loc12_.getParentCard();
                                       }
                                    }
                                    break;
                                 case "portrait":
                                    _loc4_ = param1 ? mOwnerBattleInfo : mOpponentBattleInfo;
                              }
                           }
                     }
                  }
               }
            }
         }
         return _loc4_;
      }
      
      public function getOldSocketBySaveObject(param1:Boolean, param2:int = -1, param3:int = -1, param4:int = -1) : FSCardSocket
      {
         var _loc5_:FSCardSocket = null;
         var _loc7_:FSCard = null;
         var _loc9_:Object = null;
         var _loc10_:String = null;
         var _loc11_:Dictionary = null;
         var _loc12_:Array = null;
         var _loc6_:Object = PvPConnectionMng.smPvPBattleData["save"];
         var _loc8_:String = param1 ? "ownerBattleInfo" : "opponentBattleInfo";
         if(_loc6_[_loc8_].mBFCards != null || _loc6_[_loc8_].mPlayableCardsCatalog != null)
         {
            if(_loc6_[_loc8_].mBFCards != null && _loc6_[_loc8_].mBFCards[PvPConnectionMng.MOVE_ID_PREFIX + param2] != null)
            {
               _loc9_ = _loc6_[_loc8_].mBFCards[PvPConnectionMng.MOVE_ID_PREFIX + param2]["card" + param3];
            }
            else
            {
               if(_loc6_[_loc8_].mPlayableCardsCatalog == null)
               {
                  return null;
               }
               _loc9_ = _loc6_[_loc8_].mPlayableCardsCatalog["card" + param4];
            }
            if(_loc9_ != null)
            {
               _loc10_ = _loc9_["mLastSocketAttached"];
               if(_loc10_ != null)
               {
                  _loc12_ = _loc10_.split("_");
                  if(_loc12_ != null)
                  {
                     switch(_loc12_[0])
                     {
                        case "side":
                           _loc11_ = param1 ? this.getBattleScreenPvP().getOwnerSideDeckSocketCatalog() : this.getBattleScreenPvP().getOpponentSideDeckSocketCatalog();
                           break;
                        case "bf":
                           _loc11_ = param1 ? mBattleScreen.getOwnerBFSocketCatalog() : mBattleScreen.getOpponentBFSocketCatalog();
                     }
                  }
                  _loc5_ = mBattleScreen.getCardSocketByIndex(_loc12_[1],_loc11_);
               }
            }
         }
         return _loc5_;
      }
      
      public function getPvPObjectByCardId(param1:int) : Object
      {
         var _loc2_:Object = null;
         var _loc5_:FSCard = null;
         var _loc3_:Boolean = isOwnerTurn();
         var _loc4_:Object = PvPConnectionMng.smPvPBattleData["save"];
         var _loc6_:String = _loc3_ ? "ownerBattleInfo" : "opponentBattleInfo";
         if(_loc4_ != null && _loc4_[_loc6_].mBFCards != null)
         {
            _loc2_ = PvPConnectionMng.getSavedObjectByMoveIdAndCardId(_loc3_,param1,PvPConnectionMng.MOVE_ID_PREFIX + this.mCurrentMoveId);
         }
         return _loc2_;
      }
      
      private function getBFCardBySaveObject(param1:Boolean, param2:int, param3:int) : FSCard
      {
         var _loc5_:FSCard = null;
         var _loc8_:Object = null;
         var _loc9_:FSCardSocket = null;
         var _loc4_:Object = PvPConnectionMng.smPvPBattleData["save"];
         var _loc6_:String = param1 ? "ownerBattleInfo" : "opponentBattleInfo";
         var _loc7_:String = PvPConnectionMng.MOVE_ID_PREFIX + param3;
         if(_loc4_ != null && _loc4_[_loc6_] != null && _loc4_[_loc6_].mBFCards != null)
         {
            if(_loc4_[_loc6_].mBFCards[_loc7_] != null)
            {
               if(_loc4_[_loc6_].mBFCards[_loc7_]["card" + param2] != null)
               {
                  _loc8_ = _loc4_[_loc6_].mBFCards[_loc7_]["card" + param2];
                  _loc9_ = this.getOldSocketBySaveObject(param1,param3,param2);
                  if(_loc9_ != null)
                  {
                     _loc5_ = _loc9_.getParentCard();
                  }
                  else
                  {
                     FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_ERROR_DETECTED,{"error":"getBFCardBySaveObject error (card socket null) moveId: " + param3 + " | cardId: " + param2});
                  }
                  if(_loc5_ == null)
                  {
                     _loc5_ = InstanceMng.getCardsMng().createCard(_loc8_.sku);
                  }
                  if(_loc8_.mId != null && _loc8_.mId != -1)
                  {
                     _loc5_.setId(_loc8_.mId);
                  }
               }
            }
         }
         return _loc5_;
      }
      
      private function getSacrificeTarget(param1:Boolean, param2:int) : String
      {
         var _loc4_:String = null;
         var _loc3_:Object = PvPConnectionMng.smPvPBattleData["save"];
         var _loc5_:String = param1 ? "ownerBattleInfo" : "opponentBattleInfo";
         var _loc6_:String = PvPConnectionMng.MOVE_ID_PREFIX + param2;
         if(_loc3_ != null && _loc3_[_loc5_] != null && _loc3_[_loc5_].mBFCards != null)
         {
            if(_loc3_[_loc5_].mBFCards[_loc6_] != null)
            {
               _loc4_ = _loc3_[_loc5_].mBFCards[_loc6_]["sacrifice"];
            }
         }
         return _loc4_;
      }
      
      private function willStopResumingPvPActions(param1:Boolean, param2:int) : Boolean
      {
         var _loc4_:Boolean = false;
         var _loc3_:Object = PvPConnectionMng.smPvPBattleData["save"];
         var _loc5_:String = param1 ? "ownerBattleInfo" : "opponentBattleInfo";
         var _loc6_:String = PvPConnectionMng.MOVE_ID_PREFIX + param2;
         if(_loc3_ != null && _loc3_[_loc5_] != null && _loc3_[_loc5_].mBFCards != null)
         {
            if(_loc3_[_loc5_].mBFCards[_loc6_] != null)
            {
               _loc4_ = Boolean(_loc3_[_loc5_].mBFCards[_loc6_]["stopResumedPvPActions"]);
            }
         }
         return _loc4_;
      }
      
      private function getBFCardAttachedToSocketIndexByCardId(param1:Boolean, param2:int, param3:int) : int
      {
         var _loc4_:int = 0;
         var _loc5_:Object = PvPConnectionMng.smPvPBattleData["save"];
         var _loc6_:String = param1 ? "ownerBattleInfo" : "opponentBattleInfo";
         var _loc7_:String = PvPConnectionMng.MOVE_ID_PREFIX + param2;
         if(_loc5_[_loc6_].mBFCards != null)
         {
            if(_loc5_[_loc6_].mBFCards[_loc7_] != null)
            {
               if(_loc5_[_loc6_].mBFCards[_loc7_]["card" + param3] != null)
               {
                  _loc4_ = int(_loc5_[_loc6_].mBFCards[_loc7_]["card" + param3].mAttachedToSocketIndex);
               }
            }
         }
         return _loc4_;
      }
      
      private function getBFCardAttribute(param1:Boolean, param2:int, param3:int, param4:String) : *
      {
         var _loc5_:* = undefined;
         var _loc6_:Object = PvPConnectionMng.smPvPBattleData["save"];
         var _loc7_:String = param1 ? "ownerBattleInfo" : "opponentBattleInfo";
         var _loc8_:String = PvPConnectionMng.MOVE_ID_PREFIX + param2;
         if(_loc6_[_loc7_].mBFCards != null)
         {
            if(_loc6_[_loc7_].mBFCards[_loc8_] != null)
            {
               if(_loc6_[_loc7_].mBFCards[_loc8_]["card" + param3] != null)
               {
                  _loc5_ = _loc6_[_loc7_].mBFCards[_loc8_]["card" + param3][param4];
               }
            }
         }
         return _loc5_;
      }
      
      private function getBFResumedCardsArr(param1:Boolean, param2:int, param3:Boolean = false) : Array
      {
         var _loc4_:Array = null;
         var _loc5_:FSCard = null;
         var _loc8_:String = null;
         var _loc11_:String = null;
         var _loc12_:Object = null;
         var _loc6_:int = -1;
         var _loc7_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         if(PvPConnectionMng.smPvPBattleData["save"] != null)
         {
            _loc11_ = param1 ? "ownerBattleInfo" : "opponentBattleInfo";
            _loc12_ = PvPConnectionMng.smPvPBattleData["save"][_loc11_];
            if(_loc12_ != null && _loc12_.mBFCards != null)
            {
               while(!_loc7_ && param2 != -1 && _loc6_ < 1000)
               {
                  _loc8_ = this.getSacrificeTarget(param1,param2);
                  if(_loc8_ != null)
                  {
                     if(_loc4_ == null)
                     {
                        _loc4_ = new Array();
                     }
                     _loc4_[_loc4_.length] = _loc8_;
                     _loc7_ = true;
                     _loc9_ = true;
                  }
                  else
                  {
                     _loc10_ = this.willStopResumingPvPActions(param1,param2);
                     if(_loc10_)
                     {
                        if(_loc4_ == null)
                        {
                           _loc4_ = new Array();
                        }
                        _loc4_[_loc4_.length] = "stopResumedPvPActions";
                        _loc7_ = true;
                     }
                     else
                     {
                        _loc5_ = this.getBFCardBySaveObject(param1,_loc6_,param2);
                        if(_loc5_ != null)
                        {
                           if(_loc4_ == null)
                           {
                              _loc4_ = new Array();
                           }
                           _loc4_[_loc4_.length] = _loc5_;
                           _loc7_ = true;
                        }
                     }
                  }
                  _loc6_++;
               }
            }
         }
         if(!_loc9_ && _loc4_ != null && _loc4_.length > 0)
         {
            _loc4_.sort(DictionaryUtils.sortCardsByType);
         }
         return _loc4_;
      }
      
      public function resumePlayableCards(param1:Boolean) : void
      {
         var _loc4_:FSCardSocket = null;
         var _loc5_:Number = NaN;
         var _loc6_:FSCard = null;
         var _loc7_:int = 0;
         var _loc8_:Dictionary = null;
         var _loc9_:AbilityDef = null;
         var _loc10_:Array = null;
         var _loc11_:FSCoordinate = null;
         var _loc12_:Boolean = false;
         var _loc13_:Number = NaN;
         var _loc2_:UserBattleInfo = param1 ? mOwnerBattleInfo : mOpponentBattleInfo;
         var _loc3_:int = 0;
         if(_loc2_ != null)
         {
            _loc7_ = 0;
            _loc8_ = param1 ? this.getBattleScreenPvP().getOwnerSideDeckSocketCatalog() : this.getBattleScreenPvP().getOpponentSideDeckSocketCatalog();
            _loc10_ = getNextHand();
            _loc7_ = 0;
            while(_loc7_ < _loc10_.length)
            {
               _loc6_ = this.getPlayableCardBySaveObject(param1,_loc7_);
               if(_loc6_ != null)
               {
                  _loc6_.setParentUserBattleInfo(_loc2_);
                  _loc9_ = _loc6_.getCostModifierAbilityDef();
                  if(_loc9_)
                  {
                     _loc6_.updateSummonCost(_loc9_);
                  }
                  mBattleScreen.addChild(_loc6_);
                  _loc6_.setPlayableCardId(_loc7_);
                  _loc2_.addPlayableCard(_loc6_);
                  _loc4_ = mBattleScreen.getCardSocketByIndex(_loc7_,_loc8_);
                  if(_loc4_ == null)
                  {
                     FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_ERROR_DETECTED,{"error":"resumePlayableCards - (cardSocket null) i: " + _loc7_ + " | cardSku: " + _loc6_.getCardDef().getSku()});
                  }
                  _loc6_.setAttachedToSocket(_loc4_,true);
                  storeCombatLogAction(COMBAT_LOG_CARD_TO_HAND,_loc6_);
                  _loc6_.setBattleSceneParent(this.getBattleScreenPvP());
                  _loc11_ = mBattleScreen.getSocketWorldCoordsByIndex(_loc7_,_loc8_);
                  _loc11_.setX(_loc11_.getX());
                  _loc11_.setY(_loc11_.getY());
                  _loc6_.touchable = false;
                  _loc5_ = mBattleScreen.getDealCardSpeed(true,_loc7_);
                  _loc12_ = false;
                  if(_loc12_)
                  {
                     _loc6_.width = _loc4_.width;
                     _loc6_.height = _loc4_.height;
                     _loc6_.x = -_loc6_.width;
                     _loc6_.y = param1 ? Starling.current.stage.stageHeight * 0.66 : Starling.current.stage.stageHeight * 0.33;
                     if(BattleEngine.smShowOpponentCardsDeck == false)
                     {
                        _loc6_.rotationY = deg2rad(-180);
                     }
                     _loc13_ = 0.3 * Utils.getDefaultSpeedTime();
                     SpecialFX.createTransition(_loc6_,_loc11_,_loc13_,_loc5_);
                     TweenMax.delayedCall(_loc5_,Utils.playSound,[Constants.SOUND_CARD_TO_ACTION_DECK,SoundManager.TYPE_SFX]);
                  }
                  else
                  {
                     mBattleScreen.performCardDealFX(_loc6_,_loc11_,_loc5_,_loc4_,null);
                  }
                  _loc3_++;
               }
               _loc7_++;
            }
            TweenMax.delayedCall(_loc3_ * 0.5,changePlayersState);
         }
         resetNextHandArr();
      }
      
      public function resumeBFCards(param1:Boolean, param2:int, param3:Boolean = false, param4:Number = 0) : void
      {
         var _loc7_:FSCardSocket = null;
         var _loc9_:Array = null;
         var _loc10_:Dictionary = null;
         var _loc11_:Boolean = false;
         var _loc12_:FSCard = null;
         var _loc13_:int = 0;
         var _loc14_:Boolean = false;
         var _loc15_:Boolean = false;
         var _loc16_:String = null;
         var _loc17_:Boolean = false;
         var _loc18_:AbilityDef = null;
         var _loc19_:UserBattleInfo = null;
         var _loc20_:FSPower = null;
         var _loc21_:String = null;
         var _loc22_:Boolean = false;
         var _loc23_:Boolean = false;
         var _loc24_:Boolean = false;
         var _loc25_:String = null;
         var _loc26_:FSCardSocket = null;
         var _loc27_:Boolean = false;
         var _loc28_:Boolean = false;
         var _loc29_:Boolean = false;
         var _loc30_:Boolean = false;
         var _loc31_:Boolean = false;
         var _loc32_:int = 0;
         var _loc33_:Boolean = false;
         var _loc34_:int = 0;
         var _loc35_:Number = NaN;
         var _loc36_:Number = NaN;
         var _loc37_:int = 0;
         var _loc38_:Object = null;
         var _loc39_:Number = NaN;
         var _loc40_:Boolean = false;
         var _loc41_:Object = null;
         if(isBattleOver())
         {
            return;
         }
         if(Root.assets.isLoading)
         {
            FSDebug.debugTrace("Assets loading, resuming bf cards in 1 second");
            setTimeout(this.resumeBFCards,250,param1,param2,param3,param4);
            return;
         }
         var _loc5_:Number = Boolean(PvPConnectionMng.smPvPBattleData) && PvPConnectionMng.smPvPBattleData.hasOwnProperty("when") ? Number(PvPConnectionMng.smPvPBattleData["when"]) : -1;
         FSDebug.debugTrace("Round processed time: " + _loc5_ + " | moveId: " + param2 + " | mCurrentMoveId: " + this.mCurrentMoveId);
         if(this.mLastRoundProcessedTime == _loc5_)
         {
            if(this.mCurrentMoveId >= param2)
            {
               FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_ERROR_DETECTED,{"error":"resumeBFCards received twice same round at time " + _loc5_ + " -> Skipped"});
               return;
            }
         }
         this.mLastRoundProcessedTime = _loc5_;
         var _loc6_:UserBattleInfo = param1 ? mOwnerBattleInfo : mOpponentBattleInfo;
         var _loc8_:Number = 0;
         if(_loc6_ != null && Boolean(mBattleScreen))
         {
            if(this.mLastProcessedMoveId < param2)
            {
               this.mLastProcessedMoveId = param2;
               FSDebug.debugTrace("[PVP REAL TIME] Setting mCurrentMoveId to " + param2);
               this.mCurrentMoveId = param2;
               _loc9_ = this.getBFResumedCardsArr(param1,param2,param3);
               if(_loc9_ != null && _loc9_.length > 0)
               {
                  _loc10_ = param1 ? mBattleScreen.getOwnerBFSocketCatalog() : mBattleScreen.getOpponentBFSocketCatalog();
                  _loc13_ = 0;
                  _loc13_ = 0;
                  while(_loc13_ < _loc9_.length)
                  {
                     _loc11_ = false;
                     if(_loc9_[_loc13_] is FSCard)
                     {
                        _loc12_ = _loc9_[_loc13_];
                        if(_loc12_ == null)
                        {
                           FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_ERROR_DETECTED,{
                              "error":"card received is null (begining)",
                              "matchId":PvPConnectionMng.smCurrentMatchId
                           });
                        }
                     }
                     else if(_loc9_[_loc13_] is String)
                     {
                        if(_loc9_[_loc13_] == "stopResumedPvPActions")
                        {
                           _loc17_ = true;
                        }
                        else
                        {
                           _loc15_ = true;
                           _loc16_ = _loc9_[_loc13_];
                        }
                     }
                     if(!_loc17_)
                     {
                        if(_loc15_)
                        {
                           if(Config.getConfig().gameHasSacrifice())
                           {
                              mBattleScreen.createLightning();
                              _loc12_ = this.getSacrificeTargetBySaveObject(param1);
                              if(_loc12_ == null)
                              {
                                 FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_ERROR_DETECTED,{
                                    "error":"card received is null (sacrifice)",
                                    "matchId":PvPConnectionMng.smCurrentMatchId
                                 });
                              }
                              _loc12_.onSacrificeTargetSelected();
                              _loc8_ = Config.getConfig().getSacrificeDuration() + Config.getConfig().getDefaultDeathAnimDuration() * 2;
                           }
                           else
                           {
                              _loc19_ = param1 ? mOwnerBattleInfo : mOpponentBattleInfo;
                              _loc20_ = _loc19_.getPowerCardFromDeck();
                              _loc20_.setParentUserBattleInfo(_loc19_);
                              this.resumeBFPower(_loc20_);
                              _loc8_ = getReproductionDelayTimeForCard(_loc20_,false,_loc20_.getAbilities()[0].getAbilityDef().getSku()) + Config.getConfig().getSacrificeDuration() + Config.getConfig().getDefaultDeathAnimDuration() * 2;
                           }
                           param4 += _loc8_;
                        }
                        else
                        {
                           _loc14_ = _loc12_.getType() == FSCard.TYPE_ACTION;
                           if(_loc14_)
                           {
                              _loc21_ = this.getBFCardAttribute(param1,param2,_loc12_.getId(),"mAbilitySku");
                              _loc12_.setParentUserBattleInfo(_loc6_);
                              _loc18_ = _loc12_.getCostModifierAbilityDef();
                              if(_loc18_)
                              {
                                 _loc12_.updateSummonCost(_loc18_);
                              }
                              this.resumeBFAction(FSAction(_loc12_),_loc21_);
                              _loc8_ = getReproductionDelayTimeForCard(_loc12_,false,_loc21_);
                              param4 += _loc8_;
                           }
                           else
                           {
                              _loc22_ = Utils.stringToBoolean(this.getBFCardAttribute(param1,param2,_loc12_.getId(),"mPromote"));
                              _loc23_ = Utils.stringToBoolean(this.getBFCardAttribute(param1,param2,_loc12_.getId(),"mDemote"));
                              _loc24_ = PvPConnectionMng.realTimeAllowed() ? _loc12_.getTurnsAlive() == 0 && Utils.stringToBoolean(this.getBFCardAttribute(param1,param2,_loc12_.getId(),"mCardRectification")) : false;
                              _loc25_ = this.getBFCardAttribute(param1,param2,_loc12_.getId(),"mNextCardSku");
                              _loc26_ = this.getOldSocketBySaveObject(param1,param2,_loc12_.getId());
                              _loc27_ = _loc26_ != null && _loc26_.isBattlefieldSocket();
                              _loc28_ = Utils.stringToBoolean(this.getBFCardAttribute(param1,param2,_loc12_.getId(),"usedFast"));
                              _loc29_ = Utils.stringToBoolean(this.getBFCardAttribute(param1,param2,_loc12_.getId(),"usedMoveToAttackLaneAb"));
                              _loc30_ = _loc12_.isUnit() && _loc12_.abilityAllowsMovement() || _loc28_;
                              _loc31_ = _loc29_;
                              if(_loc24_ || _loc22_ || _loc23_ || !param3 && !_loc27_ || param3 && _loc27_ || _loc30_ || _loc31_)
                              {
                                 _loc12_.setParentUserBattleInfo(_loc6_);
                                 _loc18_ = _loc12_.getCostModifierAbilityDef();
                                 if(_loc18_)
                                 {
                                    _loc12_.updateSummonCost(_loc18_);
                                 }
                                 _loc12_.setBattleSceneParent(this.getBattleScreenPvP());
                                 if(_loc22_)
                                 {
                                    _loc12_.promoteCard(_loc25_);
                                    _loc8_ = getReproductionDelayTimeForCard(_loc12_,true);
                                    param4 += _loc8_;
                                 }
                                 else if(_loc23_)
                                 {
                                    _loc12_.demoteCard(_loc25_);
                                    _loc8_ = getReproductionDelayTimeForCard(_loc12_,true);
                                    param4 += _loc8_;
                                 }
                                 else
                                 {
                                    _loc32_ = this.getBFCardAttachedToSocketIndexByCardId(param1,param2,_loc12_.getId());
                                    mBattleScreen.addChild(_loc12_);
                                    _loc7_ = mBattleScreen.getCardSocketByIndex(_loc32_,_loc10_);
                                    if(_loc7_ == null)
                                    {
                                       FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_ERROR_DETECTED,{"error":"resumeBFCards - (cardSocket = null) moveId: " + param2 + " | cardSku: " + _loc12_.getCardDef().getSku()} + " | socketIndex: " + _loc32_);
                                    }
                                    _loc33_ = _loc24_ || _loc30_ && _loc12_.getTurnsAlive() > 0 || _loc30_ && _loc27_ || _loc31_ && _loc12_.getTurnsAlive() == 0;
                                    if(_loc12_.getType() == FSCard.TYPE_ATTACHMENT)
                                    {
                                       FSAttachment(_loc12_).changeCardDefTemporarily(_loc7_.getParentCard().getCardDef().getTier());
                                    }
                                    if(_loc12_.getAttachedToSocket() == null)
                                    {
                                       FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_ERROR_DETECTED,{"error":"resumeBFCards - (getAttachedToSocket = null) moveId: " + param2 + " | cardSku: " + _loc12_.getCardDef().getSku()});
                                    }
                                    _loc34_ = _loc12_.getAttachedToSocket().getSocketIndex();
                                    if(!(_loc12_ is FSAction) && _loc33_ && _loc34_ == _loc7_.getSocketIndex())
                                    {
                                       _loc11_ = true;
                                       _loc8_ = getReproductionDelayTimeForCard(_loc12_);
                                       param4 -= _loc8_;
                                    }
                                    _loc35_ = Utils.getDefaultSpeedTime();
                                    SpecialFX.create3DRotation(_loc12_,_loc35_,0,0);
                                    _loc36_ = 0;
                                    if(!_loc11_)
                                    {
                                       _loc36_ = replayCard(_loc12_,_loc7_,_loc33_,true);
                                    }
                                    _loc8_ = _loc36_ + getReproductionDelayTimeForCard(_loc12_);
                                    param4 += _loc8_;
                                 }
                              }
                           }
                        }
                     }
                     _loc13_++;
                  }
               }
            }
            if(!param1 && !param3)
            {
               _loc37_ = PvPConnectionMng.getHighestMoveIdForSavedTurn(param1);
               _loc38_ = PvPConnectionMng.smPvPBattleData["save"];
               if(!PvPConnectionMng.realTimeAllowed())
               {
                  if(_loc37_ == 0 || param2 == _loc37_)
                  {
                     TweenMax.delayedCall(_loc8_,changePlayersState);
                  }
                  else
                  {
                     TweenMax.delayedCall(_loc8_,this.resumeBFCards,[param1,param2 + 1,param3,param4]);
                  }
               }
               else
               {
                  _loc39_ = _loc8_ == 0 ? 0 : _loc8_ + Utils.randomNumber(1,1.5);
                  if(param2 < _loc37_)
                  {
                     TweenMax.delayedCall(_loc8_,this.resumeBFCards,[param1,param2 + 1,param3,param4]);
                  }
                  else
                  {
                     _loc40_ = PvPConnectionMng.turnEnded();
                     if(_loc40_)
                     {
                        TweenMax.delayedCall(_loc39_,this.onPvPCardResumedTurnEnded,[0]);
                     }
                     else
                     {
                        _loc41_ = PvPConnectionMng.smPvPBattleData;
                        if(PvPConnectionMng.smPvPBattleData["reshuffle"] == true || PvPConnectionMng.smPvPBattleData["wasReshuffled"] == true)
                        {
                           _loc39_ += 1;
                        }
                        _loc39_ = _loc39_ == 0 ? 0 : _loc39_ - 0.1;
                        TweenMax.delayedCall(_loc39_,setResumingPvPCard,[false]);
                        FSDebug.debugTrace("[PVP REAL TIME] Checking pool in " + _loc39_);
                        TweenMax.delayedCall(_loc39_,PvPConnectionMng.onMoveFinishedCheckPool);
                     }
                  }
               }
            }
         }
      }
      
      override public function onPvPCardResumedTurnEnded(param1:Number) : void
      {
         TweenMax.delayedCall(param1,setResumingPvPCard,[false]);
         FSDebug.debugTrace("[PVP REAL TIME] Resetting mCurrentMoveId and mLastProcessedMoveId to 0");
         this.mCurrentMoveId = 0;
         this.mLastProcessedMoveId = 0;
         TweenMax.delayedCall(param1,changePlayersState);
      }
      
      private function resumeBFAction(param1:FSAction, param2:String) : void
      {
         if(param1 == null)
         {
            FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_ERROR_DETECTED,{
               "error":"card received is null",
               "matchId":PvPConnectionMng.smCurrentMatchId
            });
         }
         var _loc3_:Ability = param1.getAbilityByAbSku(param2);
         var _loc4_:int = ActionDef(param1.getCardDef()).getUpgradeCostByAbilitySku(param2);
         if(Config.getConfig().battleShowAbilitiesPanelOnActionUsed())
         {
            if(_loc3_ == null)
            {
               FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_ERROR_DETECTED,{
                  "error":"Ability received not found in card " + param2,
                  "matchId":PvPConnectionMng.smCurrentMatchId
               });
            }
            if(getOpponentBattleInfo() == null)
            {
               FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_ERROR_DETECTED,{
                  "error":"Opponent battle info not found",
                  "matchId":PvPConnectionMng.smCurrentMatchId
               });
            }
            _loc4_ = getOpponentBattleInfo().getActionCostForAbsPanel(param1,ActionDef(param1.getCardDef()),_loc3_.getAbilityDef());
         }
         else
         {
            _loc4_ = param1.getCardSummonCost();
         }
         bringUpPlayedCard(param1,1.5);
         if(this.getBattleScreenPvP() == null)
         {
            FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_ERROR_DETECTED,{
               "error":"Battle Screen not found!",
               "matchId":PvPConnectionMng.smCurrentMatchId
            });
         }
         this.getBattleScreenPvP().setEnemyActionBeingTriggered(param1);
         if(_loc3_ != null && (Boolean(_loc3_.getAbilityDef() == null) || Boolean(_loc3_.getAbilityDef() && _loc3_.getAbilityDef().getDesc() == null)))
         {
            FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_ERROR_DETECTED,{
               "error":"Ability def is null or the description does not exist",
               "matchId":PvPConnectionMng.smCurrentMatchId
            });
         }
         if(_loc3_ != null && _loc3_.getAbilityDef() != null && _loc3_.getAbilityDef().getDesc() != null)
         {
            Utils.setLogText(_loc3_.getAbilityDef().getDesc(),false,false,false);
         }
         setActionUpgradeCostSelected(_loc4_);
         var _loc5_:Number = getReproductionDelayTimeForCard(param1,false);
         TweenMax.delayedCall(_loc5_,this.onActionSelectedPerformAbilityHighlights,[_loc3_]);
      }
      
      private function onActionSelectedPerformAbilityHighlights(param1:Ability) : void
      {
         if(param1)
         {
            param1.highlightPossibleTargetsForAbility();
            param1.onPlayableItemsHighlighted();
         }
      }
      
      private function resumeBFPower(param1:FSPower) : void
      {
         var containerWidth:int;
         var posX:int;
         var posY:int;
         var coord:FSCoordinate;
         var speed:Number;
         var delay:Number;
         var hasTargets:Boolean;
         var isTargetSelectionAb:Boolean;
         var performDeathAnimation:Function = null;
         var card:FSPower = param1;
         performDeathAnimation = function():void
         {
            if(card)
            {
               card.createDeathAnimation();
            }
         };
         var ab:Ability = card.getAbilities()[0];
         var abCost:int = card.getCardDef().getSummonCost();
         card.touchable = false;
         card.scaleX = 1.5;
         card.scaleY = 1.5;
         card.rotationX = deg2rad(30);
         card.rotationY = deg2rad(-180);
         card.alpha = 0.999;
         if(card.getShadow())
         {
            card.getShadow().alpha = 0.999;
         }
         SpecialFX.create3DRotation(card,Config.getConfig().getDefaultActionMoveToCenterAnimDuration() * 2,0,0);
         containerWidth = Starling.current.stage.stageWidth * 0.4;
         posX = containerWidth + mBattleScreen.getBFWidth() / 2;
         posY = mBattleScreen.getBFHeight();
         coord = new FSCoordinate(posX,posY);
         card.x = posX;
         card.y = -card.height;
         this.getBattleScreenPvP().addChild(card);
         this.getBattleScreenPvP().setEnemyActionBeingTriggered(card);
         speed = 0.3 * Utils.getDefaultSpeedTime();
         card.requestShowShadow(1.5,false);
         SpecialFX.createTransition(card,coord,speed);
         Utils.setLogText(ab.getAbilityDef().getDesc(),false,false,false);
         setActionUpgradeCostSelected(abCost);
         delay = getReproductionDelayTimeForCard(card,false,ab.getAbilityDef().getSku());
         hasTargets = ab.highlightPossibleTargetsForAbility(true);
         isTargetSelectionAb = InstanceMng.getAbilitiesMng().isTargetSelectionAbility(ab.getAbilityDef());
         if(isTargetSelectionAb)
         {
            setPowerWaitingForTarget(true);
            TweenMax.delayedCall(delay,this.onActionSelectedPerformAbilityHighlights,[ab]);
         }
         else
         {
            card.executePower(getOpponentBattleInfo(),false);
         }
         TweenMax.delayedCall(delay,performDeathAnimation);
         TweenMax.delayedCall(delay + 0.2,SpecialFX.tweenToAlpha,[card,0.001,1,0]);
         if(card.getShadow() != null)
         {
            TweenMax.delayedCall(delay + 0.2,SpecialFX.tweenToAlpha,[card.getShadow(),0.001,1,0]);
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
      
      override public function getCurrentMoveId() : int
      {
         return this.mCurrentMoveId;
      }
      
      override public function resetCurrentMoveId() : void
      {
         FSDebug.debugTrace("[PVP REAL TIME] Resetting mCurrentMoveId to 0");
         this.mCurrentMoveId = 0;
      }
      
      override public function resetLastProcessedMoveId() : void
      {
         FSDebug.debugTrace("[PVP REAL TIME] Resetting mLastProcessedMoveId to 0");
         this.mLastProcessedMoveId = 0;
      }
   }
}

