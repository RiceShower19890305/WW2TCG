package com.fs.tcgengine.model.battle
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.AbilitiesMng;
   import com.fs.tcgengine.controller.PvPConnectionMng;
   import com.fs.tcgengine.controller.QuestsMng;
   import com.fs.tcgengine.controller.ScoreMng;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.board.card.Ability;
   import com.fs.tcgengine.model.boosts.Boost;
   import com.fs.tcgengine.model.rules.AbilityDef;
   import com.fs.tcgengine.model.rules.BattleEventDef;
   import com.fs.tcgengine.model.rules.BoostDef;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.DungeonLevelDef;
   import com.fs.tcgengine.model.rules.HeroCharacterDef;
   import com.fs.tcgengine.model.rules.JobDef;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.model.rules.PowerDef;
   import com.fs.tcgengine.model.rules.RaidDef;
   import com.fs.tcgengine.model.rules.RaidLevelDef;
   import com.fs.tcgengine.model.userdata.UserBattleInfo;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.particles.TextParticlesMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.screens.FSBattleScreenPvP;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.anims.cards.BulletsAnim;
   import com.fs.tcgengine.view.anims.cards.CardAnimation;
   import com.fs.tcgengine.view.board.BattleIntroCharacter;
   import com.fs.tcgengine.view.cards.FSAction;
   import com.fs.tcgengine.view.cards.FSAttachment;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.FSCardPreview;
   import com.fs.tcgengine.view.cards.FSEvent;
   import com.fs.tcgengine.view.cards.FSPower;
   import com.fs.tcgengine.view.cards.FSUnit;
   import com.fs.tcgengine.view.components.battle.FSAttackButton;
   import com.fs.tcgengine.view.components.battle.FSBattlefieldUserPortrait;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.socket.FSCardSocket;
   import com.greensock.TweenMax;
   import com.greensock.easing.Sine;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import starling.core.Starling;
   import starling.display.MovieClip;
   import starling.extensions.ColorArgb;
   import starling.textures.Texture;
   import starling.utils.Align;
   import starling.utils.deg2rad;
   
   public class BattleEngine implements FSModelUnloadableInterface
   {
      
      public static const BATTLE_STATE_NOT_BEGUN:int = 0;
      
      public static const BATTLE_STATE_DEALING_CARDS:int = 1;
      
      public static const BATTLE_STATE_PLAYER_MOVING_CARDS:int = 2;
      
      public static const BATTLE_STATE_ATTACKING:int = 3;
      
      public static const BATTLE_STATE_BATTLE_OVER:int = 4;
      
      public static const BATTLE_STATE_BATTLE_PAUSED:int = 5;
      
      public static const BATTLE_STATE_BATTLE_IDLE:int = 6;
      
      public static const BATTLE_STATE_TRIGGERING_ABILITIES:int = 7;
      
      public static const BATTLE_STATE_TRIGGERING_CURSES:int = 8;
      
      public static const BATTLE_STATE_DISCARDING:int = 9;
      
      public static const STATE_OWNER_BEGIN_BATTLE:int = -1;
      
      public static const STATE_OWNER_IDLE:int = 0;
      
      public static const STATE_OWNER_RECEIVING_CARDS_FROM_DECK:int = 1;
      
      public static const STATE_OWNER_MOVING_CARDS:int = 2;
      
      public static const STATE_OWNER_ATTACKING:int = 3;
      
      public static const STATE_OWNER_TRIGGER_ON_START_ABILITIES:int = 4;
      
      public static const STATE_OWNER_RETURNING_CARDS:int = 5;
      
      public static const STATE_OWNER_MOVING_UP_FROM_SUPPORT:int = 6;
      
      public static const STATE_OWNER_TRIGGER_ON_END_ABILITIES:int = 7;
      
      public static const STATE_OWNER_ADVANCE_TURN:int = 8;
      
      public static const STATE_OWNER_PRE_ATTACK:int = 20;
      
      public static const STATE_OWNER_TRIGGERING_CURSES:int = 22;
      
      public static const STATE_OWNER_DISCARDING:int = 24;
      
      public static const STATE_OPPONENT_BEGIN_BATTLE:int = 9;
      
      public static const STATE_OPPONENT_IDLE:int = 10;
      
      public static const STATE_OPPONENT_RECEIVING_CARDS_FROM_DECK:int = 11;
      
      public static const STATE_OPPONENT_MOVING_CARDS:int = 12;
      
      public static const STATE_OPPONENT_ATTACKING:int = 13;
      
      public static const STATE_OPPONENT_TRIGGER_ON_START_BATTLE_EVENT:int = 14;
      
      public static const STATE_OPPONENT_TRIGGER_ON_START_ABILITIES:int = 15;
      
      public static const STATE_OPPONENT_RETURNING_CARDS:int = 16;
      
      public static const STATE_OPPONENT_MOVING_UP_FROM_SUPPORT:int = 17;
      
      public static const STATE_OPPONENT_TRIGGER_ON_END_ABILITIES:int = 18;
      
      public static const STATE_OPPONENT_TRIGGER_ON_END_BATTLE_EVENT:int = 24;
      
      public static const STATE_OPPONENT_ADVANCE_TURN:int = 19;
      
      public static const STATE_OPPONENT_PRE_ATTACK:int = 21;
      
      public static const STATE_OPPONENT_TRIGGERING_CURSES:int = 23;
      
      public static const STATE_OPPONENT_DISCARDING:int = 25;
      
      public static const ATTACK_MOVEMENT_BOTH_SIDES_MOVE:int = 0;
      
      public static const ATTACK_MOVEMENT_ATTACKER_MOVES:int = 1;
      
      public static const BATTLE_EVENT_START_OF_TURN:int = 0;
      
      public static const BATTLE_EVENT_END_OF_TURN:int = 1;
      
      public static const COMBAT_LOG_ABILITY_EXECUTED:String = "AB_EXECUTED";
      
      public static const COMBAT_LOG_CARD_DEF_MODIFIED:String = "DEF_MODIFIED";
      
      public static const COMBAT_LOG_CARD_DMG_MODIFIED:String = "DMG_MODIFIED";
      
      public static const COMBAT_LOG_CARD_MOVED_TO_BF:String = "UNIT_PLAYED";
      
      public static const COMBAT_LOG_CARD_POS_MODIFIED:String = "POS_MODIFIED";
      
      public static const COMBAT_LOG_CARD_DEFEATED:String = "DEFEATED";
      
      public static const COMBAT_LOG_CARD_SACRIFIED:String = "SACRIFIED";
      
      public static const COMBAT_LOG_CARD_PROMOTED:String = "PROMOTED";
      
      public static const COMBAT_LOG_CARD_DEMOTED:String = "DEMOTED";
      
      public static const COMBAT_LOG_ATTACHMENT_USED:String = "ITEM_USED";
      
      public static const COMBAT_LOG_POWER_USED:String = "POWER_USED";
      
      public static const COMBAT_LOG_HP_MODIFIED:String = "HP_MODIFIED";
      
      public static const COMBAT_LOG_AP_MODIFIED:String = "AP_MODIFIED";
      
      public static const COMBAT_LOG_MAX_AP_MODIFIED:String = "MAX_AP_MODIFIED";
      
      public static const COMBAT_LOG_PASSIVE_EXECUTED:String = "PASSIVE_EXECUTED";
      
      public static const COMBAT_LOG_NEW_TURN:String = "NEW_TURN";
      
      public static const COMBAT_LOG_END_TURN:String = "END_TURN";
      
      public static const COMBAT_LOG_ATTACK:String = "ATTACKING";
      
      public static const COMBAT_LOG_POOL_PUSH:String = "POOL PUSH";
      
      public static const COMBAT_LOG_POOL_POP:String = "POOL POP";
      
      public static const COMBAT_LOG_CARD_ATTACK:String = "CARD_ATTACK";
      
      public static const COMBAT_LOG_CARD_ATTACK_PLAYER:String = "CARD_ATTACK_PLAYER";
      
      public static const COMBAT_LOG_RESHUFFLE:String = "RESHUFFLE";
      
      public static const COMBAT_LOG_CARD_TO_HAND:String = "CARD_TO_HAND";
      
      public static const COMBAT_LOG_CARD_REVERTED_TO_DECK:String = "REVERT_CARD_TO_HAND";
      
      public static const COMBAT_LOG_TURN_RECEIVED:String = "TURN_RECEIVED";
      
      public static const COMBAT_LOG_MOVE_RECEIVED:String = "MOVE_RECEIVED";
      
      public static const COMBAT_LOG_WARNING:String = "WARNING";
      
      private static const CARD_RECTIFICATIONS_MAX:int = 3;
      
      public static var smCombatLog:String = "";
      
      public static var smFillAPBoostRecentlyPurchased:Boolean = false;
      
      public static var smShowOpponentCardsDeck:Boolean = false;
      
      public static var smPlayerWon:Boolean = false;
      
      private var mOwnerCardsCount:int = 0;
      
      protected var mBattleStateId:FSNumber;
      
      protected var mPlayersStateId:int;
      
      protected var mOwnerBattleInfo:UserBattleInfo;
      
      protected var mOpponentBattleInfo:UserBattleInfo;
      
      protected var mCurrentTurnId:int = 0;
      
      protected var mBattleScreen:FSBattleScreen;
      
      protected var mLevelDef:LevelDef;
      
      protected var mIsOwnerTurn:Boolean;
      
      protected var mEngineInitialized:Boolean = false;
      
      protected var mOwnerMovesFirst:FSNumber;
      
      protected var mNextStateId:FSNumber;
      
      protected var mAIEngine:AIBattleEngine;
      
      protected var mWaitingForBannerAnimToIncreaseState:Boolean;
      
      protected var mUserBattleInfoCatalog:Dictionary;
      
      protected var mAbilityWaitingForTarget:Ability;
      
      private var mActionUpgradeCostSelected:int = -1;
      
      private var mTurnsWithoutTakingDamage:int = 0;
      
      private var mNextHandDealTopCards:Boolean;
      
      private var mNextHandIncreasesRank:int = -1;
      
      private var mExtraTurnsBought:int = 0;
      
      protected var mIsOnlineMatch:Boolean;
      
      private var mAbilityLockedUI:Boolean = false;
      
      private var mNextHand:Array;
      
      private var mBoostWaitingForResources:Boost;
      
      protected var mBattleOver:Boolean = false;
      
      private var mBoostersUsed:Dictionary;
      
      private var mSacrificeWaitingForTarget:Boolean = false;
      
      private var mPowerWaitingForTarget:Boolean = false;
      
      private var mRaidId:String;
      
      protected var mOpponentPowerIsActive:Boolean;
      
      protected var mOwnerPowerIsActive:Boolean;
      
      private var mGreetingVoicePlayed:Boolean;
      
      private var mBattleStarted:Boolean = false;
      
      private var mIntroOwnerPlayer:BattleIntroCharacter;
      
      private var mIntroOpponentPlayer:BattleIntroCharacter;
      
      private var mIntroVSImage:FSImage;
      
      private var mIntroVSMatchInfo:FSTextfield;
      
      private var mPlayingPlayersIntro:Boolean;
      
      private var mPlayersIntroVanished:Boolean;
      
      private var mCombatLogDate:Date;
      
      private var mOwnCardsDefeated:int;
      
      private var mPlayerGotHitAtLeastOnce:Boolean;
      
      private var mCategoriesPlayed:Dictionary;
      
      private var mSubcategoriesPlayed:Dictionary;
      
      private var mFactionsPlayed:Dictionary;
      
      private var mRaritiesPlayed:Dictionary;
      
      private var mCardsRectifications:Dictionary;
      
      private var mReshufflingHand:Boolean = false;
      
      protected var mResumingCards:Boolean = false;
      
      private var mCursesTriggered:Dictionary;
      
      public var mOpponentAllowedToReceiveHand:Boolean;
      
      public function BattleEngine(param1:FSBattleScreen)
      {
         super();
         this.setBattleScreen(param1);
      }
      
      public function init(param1:Boolean = false) : void
      {
         var _loc2_:Boolean = false;
         this.mIsOnlineMatch = param1;
         this.getOwnerMovesFirst();
         this.setBattleStateId(BATTLE_STATE_NOT_BEGUN);
         if(this.getOwnerMovesFirst().value == 1)
         {
            this.setPlayersStateId(STATE_OWNER_BEGIN_BATTLE);
         }
         else
         {
            this.setPlayersStateId(STATE_OPPONENT_BEGIN_BATTLE);
         }
         this.mCurrentTurnId = 0;
         this.setupLevel();
         this.setupUserInfos();
         this.setupAIEngine();
         if(Config.getConfig().hasQuests())
         {
            _loc2_ = Boolean(Root.smBattleData.isDungeon);
            if(!_loc2_)
            {
               InstanceMng.getQuestsMng().addActionPerformed(QuestsMng.TARGET_TYPE_PLAY,1,true,null,this.mLevelDef.getSku());
            }
         }
         this.mEngineInitialized = true;
      }
      
      protected function setupAIEngine() : void
      {
         if(!this.isPvPMatch() || PvPConnectionMng.isPlayingVSAI())
         {
            this.mAIEngine = new AIBattleEngine();
            this.mAIEngine.setupAI(this);
         }
      }
      
      protected function setupLevel() : void
      {
         var _loc2_:String = null;
         var _loc1_:UserDataMng = InstanceMng.getUserDataMng();
         var _loc3_:int = _loc1_.getOwnerUserData().getCurrentDifficulty();
         if(this.isPvPMatch())
         {
            _loc2_ = BattleEnginePvP.PVP_LEVEL_SKU;
         }
         else
         {
            _loc2_ = Root.smBattleData.levelSku != null ? Root.smBattleData.levelSku : _loc1_.getOwnerUserData().getCurrentLevelSkuByDifficulty(_loc3_);
         }
         var _loc4_:Boolean = Boolean(Root.smBattleData.isDungeon);
         var _loc5_:Boolean = Boolean(Root.smBattleData.isRaid);
         if(_loc4_)
         {
            this.mLevelDef = DungeonLevelDef(InstanceMng.getDungeonLevelsDefMng().getDefBySku(_loc2_));
         }
         else if(_loc5_)
         {
            this.mLevelDef = RaidLevelDef(InstanceMng.getRaidLevelsDefMng().getDefBySku(_loc2_));
         }
         else
         {
            this.mLevelDef = LevelDef(InstanceMng.getLevelsDefMng().getDefBySku(_loc2_));
         }
      }
      
      protected function setupUserInfos(param1:Boolean = false) : void
      {
         this.mOwnerBattleInfo = new UserBattleInfo(true,this.mLevelDef.getSku());
         this.mOwnerBattleInfo.setBattleEngine(this);
         this.mOpponentBattleInfo = new UserBattleInfo(false,this.mLevelDef.getSku());
         this.mOpponentBattleInfo.setBattleEngine(this);
         this.mUserBattleInfoCatalog = new Dictionary(true);
         this.mUserBattleInfoCatalog[0] = this.mOwnerBattleInfo;
         this.mUserBattleInfoCatalog[1] = this.mOpponentBattleInfo;
      }
      
      public function getOwnerMovesFirst() : FSNumber
      {
         this.mOwnerMovesFirst = this.mOwnerMovesFirst == null ? new FSNumber(1) : this.mOwnerMovesFirst;
         return this.mOwnerMovesFirst;
      }
      
      public function addCardRectification(param1:FSCard) : void
      {
         if(this.mCardsRectifications == null)
         {
            this.mCardsRectifications = new Dictionary(true);
         }
         if(this.mCardsRectifications[param1] == null)
         {
            this.mCardsRectifications[param1] = 1;
         }
         else
         {
            this.mCardsRectifications[param1] += 1;
         }
      }
      
      public function getCardRectificationsLeft(param1:FSCard) : int
      {
         if(Boolean(this.mCardsRectifications) && Boolean(this.mCardsRectifications[param1] != null) && !isNaN(this.mCardsRectifications[param1]))
         {
            return CARD_RECTIFICATIONS_MAX - this.mCardsRectifications[param1];
         }
         return CARD_RECTIFICATIONS_MAX;
      }
      
      public function canRectifyCard(param1:FSCard) : Boolean
      {
         return this.getCardRectificationsLeft(param1) > 0;
      }
      
      public function resetCardRectifications() : void
      {
         DictionaryUtils.clearDictionary(this.mCardsRectifications);
      }
      
      public function reset(param1:Boolean) : void
      {
         smFillAPBoostRecentlyPurchased = false;
         this.resetCombatLog();
         this.mBattleOver = false;
         this.mGreetingVoicePlayed = false;
         this.mEngineInitialized = false;
         this.mReshufflingHand = false;
         this.setBattleStateId(-1);
         this.setPlayersStateId(STATE_OWNER_BEGIN_BATTLE);
         this.mCurrentTurnId = -1;
         DictionaryUtils.clearDictionary(this.mCardsRectifications);
         this.mCardsRectifications = null;
         DictionaryUtils.clearDictionary(this.mCursesTriggered);
         this.mCursesTriggered = null;
         this.mBattleScreen = null;
         if(this.mAIEngine)
         {
            this.mAIEngine.unload();
            this.mAIEngine = null;
         }
         InstanceMng.getAbilitiesMng().unload();
         this.mLevelDef = null;
         this.mIsOwnerTurn = true;
         this.setNextStateId(0);
         this.mWaitingForBannerAnimToIncreaseState = false;
         DictionaryUtils.clearDictionary(this.mUserBattleInfoCatalog,!param1);
         this.mAbilityWaitingForTarget = null;
         this.mActionUpgradeCostSelected = -1;
         this.mTurnsWithoutTakingDamage = 0;
         this.mNextHandDealTopCards = false;
         this.mNextHandIncreasesRank = -1;
         this.mExtraTurnsBought = 0;
         this.mOwnerCardsCount = 0;
         this.mBoostersUsed = null;
         this.mCombatLogDate = null;
         this.mOwnCardsDefeated = 0;
         this.mPlayerGotHitAtLeastOnce = false;
         DictionaryUtils.clearDictionary(this.mCategoriesPlayed);
         DictionaryUtils.clearDictionary(this.mSubcategoriesPlayed);
         DictionaryUtils.clearDictionary(this.mFactionsPlayed);
         DictionaryUtils.clearDictionary(this.mRaritiesPlayed);
         if(!param1)
         {
            if(this.mOwnerBattleInfo)
            {
               this.mOwnerBattleInfo.unload();
            }
            if(this.mOpponentBattleInfo)
            {
               this.mOpponentBattleInfo.unload();
            }
            if(InstanceMng.getUserDataMng())
            {
               InstanceMng.getUserDataMng().resetOpponentUserData();
            }
         }
         else
         {
            if(this.mOwnerBattleInfo)
            {
               this.mOwnerBattleInfo.setInvulnerableTurns(0);
            }
            if(this.mOpponentBattleInfo)
            {
               this.mOpponentBattleInfo.setInvulnerableTurns(0);
            }
         }
         this.mOwnerBattleInfo = null;
         this.mOpponentBattleInfo = null;
         if(this.mIntroOwnerPlayer)
         {
            this.mIntroOwnerPlayer.removeFromParent();
            this.mIntroOwnerPlayer.destroy();
            this.mIntroOwnerPlayer = null;
         }
         if(this.mIntroOpponentPlayer)
         {
            this.mIntroOpponentPlayer.removeFromParent();
            this.mIntroOpponentPlayer.destroy();
            this.mIntroOpponentPlayer = null;
         }
         Utils.stopShake();
         InstanceMng.getTargetMng().reset();
      }
      
      public function addBoosterUsed(param1:String) : void
      {
         if(this.mBoostersUsed == null)
         {
            this.mBoostersUsed = new Dictionary(true);
         }
         this.mBoostersUsed[param1] = true;
      }
      
      public function canBoosterBeUsed(param1:String) : Boolean
      {
         var _loc2_:Boolean = true;
         return this.mBoostersUsed == null || (this.mBoostersUsed != null && this.mBoostersUsed[param1] == null || this.mBoostersUsed[param1] == false);
      }
      
      public function hasBattleStarted() : Boolean
      {
         return this.mBattleStarted;
      }
      
      public function startBattle() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:UserData = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this.mEngineInitialized && this.mOwnerBattleInfo != null && this.mOpponentBattleInfo != null)
         {
            smPlayerWon = false;
            this.mBattleStarted = true;
            if(this.mLevelDef != null)
            {
               _loc1_ = this.isPvPMatch();
               if(!_loc1_)
               {
                  if(Config.getConfig().getTutorialON())
                  {
                     InstanceMng.getTutorialMng().unload();
                  }
                  InstanceMng.getConversationsMng().unload();
                  if(!Root.smBattleData.isDungeon && !Root.smBattleData.isRaid)
                  {
                     this.mOwnerBattleInfo.getUserData().playerLostLive(this.mLevelDef);
                     _loc2_ = Utils.getOwnerUserData();
                     if(_loc2_)
                     {
                        _loc3_ = _loc2_.getCurrentDifficulty();
                        _loc4_ = _loc2_.getCurrentLevelIndex(_loc3_);
                        if(_loc4_ == this.mLevelDef.getLevelIndex())
                        {
                           _loc2_.increaseLevelFailedInfoByLevelSku(this.mLevelDef.getSku());
                           _loc2_.increaseLevelFailedFirebaseByLevel(this.mLevelDef.getLevelIndex());
                           _loc2_.increaseLevelAttempts();
                        }
                        InstanceMng.getUserDataMng().persistenceSaveData();
                     }
                  }
               }
               InstanceMng.getScoreMng().startTracking(this.mLevelDef);
               InstanceMng.getTargetMng().levelStart();
               this.mBattleScreen.createUI();
               this.updatePlayerTurn();
               InstanceMng.getCurrentScreen().createTranslucentBG(true,0.85,0);
               if(!_loc1_)
               {
                  this.checkPreBoosts();
               }
               else if(this.isOnlineMatch())
               {
                  PvPConnectionMng.updateMatchBattleLoadedOK();
                  InstanceMng.getPopupMng().openWaitingForOpponenToSyncBattlePopup(PvPConnectionMng.smCurrentMatchId,TextManager.getText("TID_PVP_SYNC"));
               }
               else if(Config.BATTLE_HAS_INTRO)
               {
                  this.playIntro();
               }
               else
               {
                  this.notifyPlayerTurnDone();
               }
            }
            return;
         }
         throw new Error("[startBattle] - The owner or the opponent battle info is NULL!");
      }
      
      private function checkPreBoosts() : void
      {
         var _loc2_:UserData = null;
         var _loc3_:Dictionary = null;
         var _loc4_:Boost = null;
         var _loc5_:BoostDef = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         var _loc1_:int = 0;
         if(this.mOwnerBattleInfo != null)
         {
            _loc2_ = this.mOwnerBattleInfo.getUserData();
            if(_loc2_ != null)
            {
               _loc3_ = _loc2_.getPreBoosts();
               if(_loc3_ != null)
               {
                  _loc6_ = DictionaryUtils.getKeys(_loc3_);
                  _loc8_ = 0;
                  _loc7_ = 0;
                  while(_loc7_ < _loc6_.length)
                  {
                     if(_loc3_[_loc6_[_loc7_]] != null && _loc3_[_loc6_[_loc7_]] > 0)
                     {
                        _loc5_ = BoostDef(InstanceMng.getBoostsDefMng().getDefBySku(_loc6_[_loc7_]));
                        if(_loc5_ != null)
                        {
                           _loc4_ = InstanceMng.getBoostsMng().getBoost(_loc5_);
                           _loc1_ += _loc1_ == 0 ? 0.5 : _loc4_.getWaitTime();
                           TweenMax.delayedCall(_loc1_,this.onPreBoostsCheckedExecuteBoost,[_loc4_]);
                           _loc2_.removePreBoost(_loc6_[_loc7_]);
                           _loc1_++;
                        }
                     }
                     _loc7_++;
                  }
               }
            }
         }
         _loc1_ += 0.5;
         if(Config.BATTLE_HAS_INTRO)
         {
            if(Boolean(this.mLevelDef) && (!(this.mLevelDef is DungeonLevelDef) || this.mLevelDef is DungeonLevelDef && DungeonLevelDef(this.mLevelDef).isFirstDungeonLevel()))
            {
               TweenMax.delayedCall(_loc1_,this.playIntro);
            }
            else
            {
               TweenMax.delayedCall(_loc1_,this.notifyPlayerTurnDone);
            }
         }
         else
         {
            TweenMax.delayedCall(_loc1_,this.notifyPlayerTurnDone);
         }
         TweenMax.delayedCall(_loc1_,this.refreshBoostsPanelsAmounts);
      }
      
      private function onPreBoostsCheckedExecuteBoost(param1:Boost) : void
      {
         if(param1)
         {
            param1.execute();
         }
      }
      
      private function refreshBoostsPanelsAmounts() : void
      {
         if(this.mBattleScreen)
         {
            this.mBattleScreen.refreshBoostsPanelAmounts();
         }
      }
      
      public function skipPlayersIntro() : void
      {
         if(this.mIntroVSImage)
         {
            this.mIntroVSImage.removeFromParent();
            this.mIntroVSImage.destroy();
         }
         if(this.mIntroVSMatchInfo)
         {
            this.mIntroVSMatchInfo.removeFromParent();
         }
         InstanceMng.getCurrentScreen().removeTranslucentBG(true);
         TweenMax.killDelayedCallsTo(this.createIntroOwner);
         TweenMax.killDelayedCallsTo(this.createIntroOpponent);
         TweenMax.killTweensOf(this.createIntroOwner);
         TweenMax.killTweensOf(this.createIntroOpponent);
         this.vanishIntroPlayers();
      }
      
      public function playIntro() : void
      {
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         if(!InstanceMng.getCurrentScreen().isTransparentBGShown() && this.isPvPMatch())
         {
            InstanceMng.getCurrentScreen().createTranslucentBG(true,0.85,0);
         }
         this.mPlayingPlayersIntro = true;
         var _loc1_:int = InstanceMng.getCurrentScreen().getBG().width;
         var _loc2_:int = InstanceMng.getCurrentScreen().getBG().height;
         if(this.mIntroVSImage == null)
         {
            this.mIntroVSImage = new FSImage(Root.assets.getTexture("vs_icon"));
            this.mIntroVSImage.touchable = false;
            this.mIntroVSImage.alignPivot();
            this.mIntroVSImage.x = _loc1_ / 2.05;
            this.mIntroVSImage.y = _loc2_ / 2;
         }
         if(this.isOnlineMatch())
         {
            if(this.mIntroVSMatchInfo == null)
            {
               _loc3_ = !PvPConnectionMng.smPlayingFriendlyMatch ? TextManager.getText("TID_PVP_MATCH_RANKED") : TextManager.getText("TID_PVP_MATCH_FRIENDLY");
               _loc4_ = !PvPConnectionMng.smPlayingFriendlyMatch ? 16711680 : 3026686;
               this.mIntroVSMatchInfo = new FSTextfield(this.mIntroVSImage.width * 4,FSResourceMng.FONT_STD_BIG_TITLE_SIZE,_loc3_,_loc4_,FSResourceMng.FONT_STD_TITLE_SIZE);
               this.mIntroVSMatchInfo.touchable = false;
               this.mIntroVSMatchInfo.alignPivot();
               this.mIntroVSMatchInfo.x = this.mIntroVSImage.x;
               this.mIntroVSMatchInfo.y = this.mIntroVSImage.y + this.mIntroVSImage.height * 1.1;
            }
         }
         TweenMax.delayedCall(0.75,this.createIntroOwner,[_loc1_]);
         TweenMax.delayedCall(1,this.createIntroOpponent,[_loc1_]);
      }
      
      private function createIntroOwner(param1:int) : void
      {
         var _loc2_:HeroCharacterDef = null;
         var _loc3_:JobDef = null;
         var _loc4_:FSCoordinate = null;
         var _loc5_:FSCoordinate = null;
         var _loc6_:FSCoordinate = null;
         if(Boolean(this.mIntroOwnerPlayer == null && this.mBattleScreen && this.mOwnerBattleInfo) && Boolean(this.mOwnerBattleInfo.getUserBattlePortrait()) && Boolean(this.mIntroVSImage))
         {
            Utils.playSound("move_portrait",SoundManager.TYPE_SFX);
            _loc2_ = this.mBattleScreen.getHeroCharacterDef(true,this.isPvPMatch());
            _loc3_ = Config.getConfig().gameHasClassSystem() && Boolean(_loc2_) ? JobDef(InstanceMng.getJobsDefMng().getDefBySku(_loc2_.getJobSku())) : null;
            this.mIntroOwnerPlayer = new BattleIntroCharacter(true,this.mOwnerBattleInfo.getUserBattlePortrait().getName().toUpperCase(),this.mOwnerBattleInfo.getUserBattlePortrait().getCharacterCurrentTexture(),_loc3_);
            _loc4_ = new FSCoordinate(-this.mIntroOwnerPlayer.width / 2,this.mIntroVSImage.y + this.mIntroOwnerPlayer.height / 2);
            _loc5_ = new FSCoordinate(-this.mIntroOwnerPlayer.width / 2 + this.mIntroOwnerPlayer.width,this.mIntroVSImage.y + this.mIntroOwnerPlayer.height / 2 + 60);
            _loc6_ = new FSCoordinate(param1 * 0.2,this.mIntroVSImage.y);
            SpecialFX.createIntroPlayer(this.mIntroOwnerPlayer,1.5,_loc4_,_loc5_,_loc6_);
            InstanceMng.getCurrentScreen().addChild(this.mIntroOwnerPlayer);
         }
      }
      
      private function createIntroOpponent(param1:int) : void
      {
         var _loc2_:HeroCharacterDef = null;
         var _loc3_:JobDef = null;
         var _loc4_:FSCoordinate = null;
         var _loc5_:FSCoordinate = null;
         var _loc6_:FSCoordinate = null;
         if(Boolean(this.mIntroOpponentPlayer == null) && Boolean(this.mBattleScreen) && Boolean(this.mOpponentBattleInfo))
         {
            Utils.playSound("move_portrait",SoundManager.TYPE_SFX);
            _loc2_ = this.mBattleScreen.getHeroCharacterDef(false,this.isPvPMatch());
            _loc3_ = Config.getConfig().gameHasClassSystem() && _loc2_ != null ? JobDef(InstanceMng.getJobsDefMng().getDefBySku(_loc2_.getJobSku())) : null;
            if(this.mOpponentBattleInfo.getUserBattlePortrait())
            {
               this.mIntroOpponentPlayer = new BattleIntroCharacter(false,this.mOpponentBattleInfo.getUserBattlePortrait().getName().toUpperCase(),this.mOpponentBattleInfo.getUserBattlePortrait().getCharacterCurrentTexture(),_loc3_);
            }
            if(this.mIntroOpponentPlayer)
            {
               _loc4_ = new FSCoordinate(param1 + this.mIntroOpponentPlayer.width / 2,this.mIntroVSImage.y - this.mIntroOpponentPlayer.height / 2);
               _loc5_ = new FSCoordinate(param1 - this.mIntroOpponentPlayer.width / 2,this.mIntroVSImage.y - this.mIntroOpponentPlayer.height / 2 - 60);
               _loc6_ = new FSCoordinate(param1 * 0.8,this.mIntroVSImage.y);
               SpecialFX.createIntroPlayer(this.mIntroOpponentPlayer,1.5,_loc4_,_loc5_,_loc6_,this.createIntroVS);
               InstanceMng.getCurrentScreen().addChild(this.mIntroOpponentPlayer);
            }
            else
            {
               this.createIntroVS();
            }
         }
      }
      
      private function createIntroVS() : void
      {
         var _loc1_:Number = 0.75;
         if(this.mIntroVSImage)
         {
            this.mIntroVSImage.alpha = 0;
            this.mPlayersIntroVanished = false;
            InstanceMng.getCurrentScreen().addChild(this.mIntroVSImage);
            if(this.mIntroVSMatchInfo)
            {
               this.mIntroVSMatchInfo.alpha = 0;
               InstanceMng.getCurrentScreen().addChild(this.mIntroVSMatchInfo);
               SpecialFX.createZoomAlphaTween(this.mIntroVSMatchInfo,_loc1_,0,1,4,1,Sine.easeIn);
            }
            TweenMax.delayedCall(_loc1_ / 2,Utils.playSound,["unfold_rare",SoundManager.TYPE_SFX]);
            SpecialFX.createZoomAlphaTween(this.mIntroVSImage,_loc1_,0,1,4,1,Sine.easeIn,TweenMax.delayedCall,[1,this.startMoveToPortraitPhase]);
         }
      }
      
      private function startMoveToPortraitPhase() : void
      {
         var _loc3_:Point = null;
         var _loc4_:FSCoordinate = null;
         var _loc5_:FSCoordinate = null;
         var _loc6_:Point = null;
         var _loc7_:FSCoordinate = null;
         var _loc8_:FSCoordinate = null;
         var _loc1_:Number = 0;
         var _loc2_:Number = 1;
         if(Boolean(this.mIntroOwnerPlayer) && Boolean(this.mIntroOpponentPlayer))
         {
            _loc1_ = this.mIntroOwnerPlayer.onMoveToPortraitPhase();
            _loc1_ = this.mIntroOpponentPlayer.onMoveToPortraitPhase();
            if(this.mIntroVSImage)
            {
               SpecialFX.tweenToAlpha(this.mIntroVSImage,0,_loc1_,0);
            }
            if(this.mIntroVSMatchInfo)
            {
               SpecialFX.tweenToAlpha(this.mIntroVSMatchInfo,0,_loc1_,0);
            }
            if(InstanceMng.getCurrentScreen())
            {
               TweenMax.delayedCall(_loc1_,SpecialFX.tweenToAlpha,[InstanceMng.getCurrentScreen().getTouchableBG(),0,_loc2_ * 1.5,0,InstanceMng.getCurrentScreen().removeTranslucentBG]);
            }
            TweenMax.killTweensOf(this.mIntroOwnerPlayer);
            if(Boolean(this.mOwnerBattleInfo && this.mOwnerBattleInfo.getUserBattlePortrait()) && Boolean(this.mOpponentBattleInfo) && Boolean(this.mOpponentBattleInfo.getUserBattlePortrait()))
            {
               _loc3_ = new Point(this.mOwnerBattleInfo.getUserBattlePortrait().x + this.mOwnerBattleInfo.getUserBattlePortrait().width / 2,this.mOwnerBattleInfo.getUserBattlePortrait().y + this.mOwnerBattleInfo.getUserBattlePortrait().height / 2);
               _loc4_ = new FSCoordinate(_loc3_.x,_loc3_.y - this.mIntroOwnerPlayer.height / 2);
               _loc5_ = new FSCoordinate(_loc3_.x,_loc3_.y);
               SpecialFX.createIntroPlayerPhase3(this.mIntroOwnerPlayer,_loc2_,_loc4_,_loc5_,null);
               TweenMax.delayedCall(_loc2_ * 0.5,SpecialFX.tweenToAlpha,[this.mIntroOwnerPlayer,0,_loc2_ * 0.5,0]);
               TweenMax.killTweensOf(this.mIntroOpponentPlayer);
               _loc6_ = new Point(this.mOpponentBattleInfo.getUserBattlePortrait().x + this.mOpponentBattleInfo.getUserBattlePortrait().width / 2,this.mOpponentBattleInfo.getUserBattlePortrait().y + this.mOpponentBattleInfo.getUserBattlePortrait().height / 2);
               _loc7_ = new FSCoordinate(_loc6_.x,_loc6_.y - this.mIntroOpponentPlayer.height / 2);
               _loc8_ = new FSCoordinate(_loc6_.x,_loc6_.y);
               SpecialFX.createIntroPlayerPhase3(this.mIntroOpponentPlayer,_loc2_,_loc7_,_loc8_,this.vanishIntroPlayers);
               TweenMax.delayedCall(_loc2_ * 0.5,SpecialFX.tweenToAlpha,[this.mIntroOpponentPlayer,0,_loc2_ * 0.5,0]);
            }
            else
            {
               this.vanishIntroPlayers();
            }
         }
         else
         {
            SpecialFX.tweenToAlpha(this.mIntroVSImage,0,0.5,0);
            if(this.mIntroVSMatchInfo)
            {
               SpecialFX.tweenToAlpha(this.mIntroVSMatchInfo,0,0.5,0);
            }
            this.vanishIntroPlayers();
         }
      }
      
      private function vanishIntroPlayers() : void
      {
         var _loc1_:Number = 0.15;
         if(this.mIntroOwnerPlayer)
         {
            this.mIntroOwnerPlayer.removeFromParent();
            this.mIntroOwnerPlayer.destroy();
            TweenMax.killTweensOf(this.mIntroOwnerPlayer);
         }
         if(this.mIntroOpponentPlayer)
         {
            this.mIntroOpponentPlayer.removeFromParent();
            this.mIntroOpponentPlayer.destroy();
            TweenMax.killTweensOf(this.mIntroOpponentPlayer);
         }
         this.mPlayingPlayersIntro = false;
         if(!this.mPlayersIntroVanished)
         {
            this.mPlayersIntroVanished = true;
            if(Boolean(this.mOwnerBattleInfo) && Boolean(this.mOwnerBattleInfo.getUserBattlePortrait()))
            {
               this.mOwnerBattleInfo.getUserBattlePortrait().setGuildEmblemTouchable();
            }
            if(Boolean(this.mOpponentBattleInfo) && Boolean(this.mOpponentBattleInfo.getUserBattlePortrait()))
            {
               this.mOpponentBattleInfo.getUserBattlePortrait().setGuildEmblemTouchable();
            }
            this.notifyPlayerTurnDone();
         }
      }
      
      public function removeIntro() : void
      {
         if(this.mIntroVSImage)
         {
            this.mIntroVSImage.removeFromParent();
            this.mIntroVSImage.destroy();
            this.mIntroVSImage = null;
         }
         if(this.mIntroOwnerPlayer)
         {
            this.mIntroOwnerPlayer.removeFromParent();
            this.mIntroOwnerPlayer.destroy();
            this.mIntroOwnerPlayer = null;
         }
         if(this.mIntroOpponentPlayer)
         {
            this.mIntroOpponentPlayer.removeFromParent();
            this.mIntroOpponentPlayer.destroy();
            this.mIntroOpponentPlayer = null;
         }
         InstanceMng.getCurrentScreen().removeTranslucentBG(true);
      }
      
      public function isPlayersIntroPlaying() : Boolean
      {
         return this.mPlayingPlayersIntro;
      }
      
      public function notifyPlayerTurnDone() : void
      {
         Utils.removeLog();
         var _loc1_:int = this.mIsOwnerTurn ? STATE_OWNER_ADVANCE_TURN : STATE_OPPONENT_ADVANCE_TURN;
         this.setPlayersStateId(_loc1_);
         this.setNextStateId(_loc1_);
         this.setWaitingForBannerAnimToIncreaseState(true);
         this.displayTurnMessage();
         this.storeCombatLogAction(COMBAT_LOG_END_TURN);
         this.resetCardRectifications();
      }
      
      protected function displayTurnMessage() : void
      {
         var _loc1_:String = null;
         if(this.mBattleScreen)
         {
            _loc1_ = this.mIsOwnerTurn ? "TID_GEN_YOUR_TURN" : "TID_GEN_OPPONENT_TURN";
            TweenMax.delayedCall(0.25,this.onDisplayTurnMessage,[_loc1_,16777215]);
         }
      }
      
      private function onDisplayTurnMessage(param1:String, param2:uint) : void
      {
         var _loc3_:Boolean = false;
         if(this.mBattleScreen)
         {
            this.mBattleScreen.displayTurnMessage(param1,param2);
         }
         if(Boolean(this.mBattleScreen) && Boolean(this.mCurrentTurnId == 0) && this.mGreetingVoicePlayed == false)
         {
            this.mGreetingVoicePlayed = true;
            _loc3_ = this.isOwnerTurn();
            setTimeout(this.mBattleScreen.playGreetingsVoice,1000,_loc3_);
            setTimeout(this.mBattleScreen.playGreetingsVoice,4000,!_loc3_);
         }
      }
      
      public function onUsePostBoostUsedOnBattleOver() : void
      {
         this.mBattleOver = false;
         this.checkCardsKilledInCombat(true);
         this.reviewAllCardsStateAfterUsingPostBoost();
         var _loc1_:Boost = this.mOwnerBattleInfo.getUserData().getPostBoost();
         if(_loc1_ != null)
         {
            _loc1_.execute();
            return;
         }
         throw new Error("[onUsePostBoostUsedOnBattleOver] - No post boost found");
      }
      
      private function reviewAllCardsStateAfterUsingPostBoost() : void
      {
         var _loc3_:FSCard = null;
         var _loc1_:Dictionary = this.mOwnerBattleInfo.getFightCards();
         var _loc2_:Dictionary = this.mOpponentBattleInfo.getFightCards();
         for each(_loc3_ in _loc1_)
         {
            if(!_loc3_.isAlive())
            {
               _loc3_.setDefense(0,true);
            }
         }
         for each(_loc3_ in _loc2_)
         {
            if(!_loc3_.isAlive())
            {
               _loc3_.setDefense(0,true);
            }
         }
      }
      
      public function isBattleOver() : Boolean
      {
         return this.mBattleOver;
      }
      
      public function onBattleOverCommonOps() : void
      {
         if(Config.smBattleSendCombatLog && smCombatLog != "" && this.isOnlineMatch() && !PvPConnectionMng.isPlayingVSAI())
         {
            PvPConnectionMng.trackCombatLog();
         }
         this.mBattleOver = true;
         if(this.mBattleScreen)
         {
            this.mBattleScreen.setSelectedCard(null);
         }
         if(Config.getConfig().battleHasOwnMusic())
         {
            Utils.stopAllSounds(true);
         }
         TweenMax.killAll(true,false,true);
         TweenMax.killAll(true);
         InstanceMng.getCurrentScreen().resetGuildsButtonPosition();
         Utils.stopShake();
         if(this.mBattleScreen)
         {
            this.disableAttackButton();
            this.mBattleScreen.enableBoostsPanel(false);
            this.mBattleScreen.disableFreeReshuffle(null);
         }
         if(InstanceMng.getApplication().isGuildsPanelOpen())
         {
            InstanceMng.getApplication().hideGuildsPanel();
         }
      }
      
      private function onDungeonLevelCompleted() : void
      {
         if(InstanceMng.getDungeonsMng())
         {
            InstanceMng.getDungeonsMng().onDungeonLevelCompleted();
         }
      }
      
      private function onRaidLevelCompleted() : void
      {
         if(InstanceMng.getRaidsMng())
         {
            InstanceMng.getRaidsMng().onRaidLevelCompleted();
         }
      }
      
      private function onDungeonLevelFailed(param1:LevelDef = null, param2:int = -1) : void
      {
         if(InstanceMng.getDungeonsMng())
         {
            InstanceMng.getDungeonsMng().onDungeonLevelFailed(param1,param2);
         }
      }
      
      private function onRaidLevelFailed() : void
      {
         if(InstanceMng.getRaidsMng())
         {
            InstanceMng.getRaidsMng().onRaidLevelFailed();
         }
      }
      
      private function onBattleOverLevelCompleted(param1:LevelDef) : void
      {
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc15_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:UserData = Utils.getOwnerUserData();
         if(Boolean(_loc3_) && Boolean(param1))
         {
            _loc2_ = _loc3_.onLevelCompleted(param1);
         }
         if(Config.getConfig().hasQuests())
         {
            _loc4_ = Boolean(Root.smBattleData.isDungeon);
            if(!_loc4_)
            {
               _loc6_ = _loc3_.getCurrentDifficulty();
               _loc7_ = param1.getMaxScoreByDifficulty(_loc6_);
               _loc8_ = _loc2_ >= _loc7_;
               _loc9_ = this.mOwnCardsDefeated == 0;
               _loc10_ = this.mPlayerGotHitAtLeastOnce == false;
               _loc11_ = this.getFactionsPlayed();
               _loc12_ = this.getCategoriesPlayed();
               _loc13_ = this.getSubcategoriesPlayed();
               _loc14_ = this.getRaritiesPlayed();
               _loc15_ = [QuestsMng.TARGET_EXTRA_INFO_HP_LEFT + ":" + this.mOwnerBattleInfo.getHP(),QuestsMng.TARGET_EXTRA_INFO_3STARS + ":" + _loc8_,QuestsMng.TARGET_EXTRA_INFO_LEVEL_HIGHER + ":" + param1.getLevelIndex(),QuestsMng.TARGET_EXTRA_INFO_CARDS_UNDEFEATED + ":" + _loc9_,QuestsMng.TARGET_EXTRA_INFO_HP_INTACT + ":" + _loc10_,QuestsMng.TARGET_CARD_ONLY_CATEGORY + ":" + _loc12_,QuestsMng.TARGET_CARD_ONLY_SUBCATEGORY + ":" + _loc13_,QuestsMng.TARGET_CARD_ONLY_FACTION + ":" + _loc11_,QuestsMng.TARGET_CARD_ONLY_RARITY + ":" + _loc14_];
               InstanceMng.getQuestsMng().addActionPerformed(QuestsMng.TARGET_TYPE_WIN,1,false,_loc15_,this.mLevelDef.getSku());
            }
            _loc5_ = InstanceMng.getUserDataMng().getOwnerUserData().isLastLevelCompleted(this.mLevelDef);
            if(_loc5_)
            {
               InstanceMng.getQuestsMng().flagQuestsAsNotInitialized();
            }
         }
      }
      
      public function onBattleOver(param1:Boolean = false, param2:Boolean = false, param3:Boolean = false, param4:String = "") : void
      {
         var _loc13_:Boolean = false;
         this.onBattleOverCommonOps();
         var _loc5_:Number = 0;
         var _loc6_:Function = null;
         var _loc7_:Array = null;
         var _loc8_:Boolean = Boolean(Root.smBattleData.isDungeon);
         var _loc9_:Boolean = Boolean(Root.smBattleData.isRaid);
         var _loc10_:Boolean = this.isPvPMatch();
         var _loc11_:UserData = this.mOwnerBattleInfo.getUserData();
         if(param1)
         {
            smPlayerWon = true;
            Utils.playSound(Constants.SOUND_VICTORY,SoundManager.TYPE_SFX);
            if(_loc8_)
            {
               _loc6_ = this.onDungeonLevelCompleted;
            }
            else if(_loc9_)
            {
               _loc6_ = this.onRaidLevelCompleted;
            }
            else
            {
               _loc6_ = this.onBattleOverLevelCompleted;
            }
            if(!Root.smBattleData.isRaid)
            {
               _loc7_ = Root.smBattleData.isDungeon ? null : [this.mLevelDef];
            }
            _loc5_ = this.mBattleScreen.performCardsLeavingFX(Config.getConfig().getDefaultDeathAnimDuration());
            _loc5_ = _loc5_ + 0.75;
            this.mBattleScreen.createVictoryAnimation(_loc5_,_loc6_,_loc7_);
            return;
         }
         if(param2)
         {
            smPlayerWon = false;
            if(_loc9_ || _loc10_)
            {
               InstanceMng.getQuestsMng().onLevelFailed();
            }
            Utils.playSound(Constants.SOUND_DEFEAT,SoundManager.TYPE_SFX);
            if(_loc8_)
            {
               _loc6_ = this.onDungeonLevelFailed;
            }
            else if(_loc9_)
            {
               _loc6_ = this.onRaidLevelFailed;
            }
            else
            {
               _loc6_ = this.onDefeatAnimOverPerformOps;
            }
            _loc7_ = Boolean(Root.smBattleData.isDungeon) || Boolean(Root.smBattleData.isRaid) ? null : [this.mLevelDef];
            this.mBattleScreen.createDefeatAnimation(3,_loc6_,_loc7_);
            return;
         }
         var _loc12_:Boolean = InstanceMng.getTargetMng().playerWon();
         if(!_loc12_)
         {
            smPlayerWon = false;
            if(_loc9_ || _loc10_)
            {
               InstanceMng.getQuestsMng().onLevelFailed();
            }
            _loc13_ = !this.getOpponentBattleInfo().isAlive();
            if(!this.mLevelDef.getObjectiveCompleteOnEnemyKilled() && _loc13_)
            {
               Utils.playSound(Constants.SOUND_DEFEAT,SoundManager.TYPE_SFX);
               if(_loc8_)
               {
                  _loc6_ = this.onDungeonLevelFailed;
               }
               else if(_loc9_)
               {
                  _loc6_ = this.onRaidLevelFailed;
               }
               else
               {
                  _loc6_ = this.onDefeatAnimOverPerformOps;
               }
               _loc7_ = Boolean(Root.smBattleData.isDungeon) || Boolean(Root.smBattleData.isRaid) ? null : [this.mLevelDef];
               this.mBattleScreen.createDefeatAnimation(3,_loc6_,_loc7_);
            }
            else if(_loc8_)
            {
               this.onDungeonLevelFailed();
            }
            else if(_loc9_)
            {
               this.onRaidLevelFailed();
            }
            else
            {
               _loc11_.onLevelFailed();
            }
         }
         else
         {
            smPlayerWon = true;
            if(this.mOwnerBattleInfo.getHP() > 0)
            {
               Utils.playSound(Constants.SOUND_VICTORY,SoundManager.TYPE_SFX);
               if(_loc8_)
               {
                  _loc6_ = this.onDungeonLevelCompleted;
               }
               else if(_loc9_)
               {
                  _loc6_ = this.onRaidLevelCompleted;
               }
               else
               {
                  _loc6_ = this.onBattleOverLevelCompleted;
               }
               if(!Root.smBattleData.isRaid)
               {
                  _loc7_ = Root.smBattleData.isDungeon ? null : [this.mLevelDef];
               }
               _loc5_ = this.mBattleScreen.performCardsLeavingFX(Config.getConfig().getDefaultDeathAnimDuration());
               _loc5_ = _loc5_ + 0.75;
               this.mBattleScreen.createVictoryAnimation(_loc5_,_loc6_,_loc7_);
            }
            else
            {
               if(_loc9_ || _loc10_)
               {
                  InstanceMng.getQuestsMng().onLevelFailed();
               }
               if(_loc8_)
               {
                  InstanceMng.getDungeonsMng().onDungeonLevelFailed();
               }
               else if(_loc9_)
               {
                  this.onRaidLevelFailed();
               }
               else
               {
                  _loc11_.onLevelFailed();
               }
            }
         }
      }
      
      private function onDefeatAnimOverPerformOps(param1:LevelDef = null) : void
      {
         if(InstanceMng.getPopupMng())
         {
            InstanceMng.getPopupMng().openLevelFailedPopup(param1);
         }
      }
      
      public function getNextHand(param1:Array = null, param2:String = "") : Array
      {
         var _loc3_:FSCardSocket = null;
         var _loc4_:UserBattleInfo = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         if(this.mNextHand == null)
         {
            FSDebug.debugTrace("[PVP REAL TIME] - getNextHand - onlineOpponentCardsArr > 0 " + (param1 != null && param1.length > 0) + " nextHandForcedCardSku: " + param2);
            if(param2 != "")
            {
               if(this.mNextHand == null)
               {
                  this.mNextHand = new Array();
               }
               this.mNextHand.push(param2);
               return this.mNextHand;
            }
            if(param1 == null)
            {
               _loc4_ = this.mIsOwnerTurn ? this.getOwnerBattleInfo() : this.getOpponentBattleInfo();
               _loc4_.updateGraveyard();
               _loc5_ = 0;
               if(_loc4_ != null)
               {
                  _loc7_ = 0;
                  _loc8_ = this.getLevelDef() ? this.getLevelDef().getDeckCards() : 0;
                  _loc9_ = _loc4_.getDeckLength();
                  _loc10_ = this.getNextHandDealTopCards();
                  _loc11_ = this.getNextHandIncreasesRank() != -1;
                  _loc7_ = 0;
                  while(_loc7_ < _loc9_)
                  {
                     if(_loc7_ < _loc8_)
                     {
                        _loc6_ = _loc4_.getRandomCardSkuFromDeck(_loc10_,_loc11_);
                        if(_loc6_ != null)
                        {
                           if(this.mNextHand == null)
                           {
                              this.mNextHand = new Array();
                           }
                           this.mNextHand.push(_loc6_);
                        }
                     }
                     _loc7_++;
                  }
               }
            }
            else
            {
               _loc13_ = int(param1.length);
               _loc12_ = 0;
               while(_loc12_ < _loc13_)
               {
                  _loc6_ = param1[_loc12_];
                  if(_loc6_ != null)
                  {
                     if(this.mNextHand == null)
                     {
                        this.mNextHand = new Array();
                     }
                     this.mNextHand.push(_loc6_);
                  }
                  _loc12_++;
               }
            }
         }
         return this.mNextHand;
      }
      
      public function isNextHandCalculated() : Boolean
      {
         return this.mNextHand != null;
      }
      
      public function resetNextHandArr() : void
      {
         if(this.mNextHand)
         {
            this.mNextHand.length = 0;
            this.mNextHand = null;
         }
      }
      
      public function changePlayersState() : void
      {
         try
         {
            if(this.getBattleStateId() == BATTLE_STATE_BATTLE_OVER)
            {
               if(!this.mBattleOver)
               {
                  this.onBattleOver();
               }
               return;
            }
            if(this.mBattleOver || this.mBattleScreen == null)
            {
               return;
            }
            this.setPlayersStateId(this.getNextStateId());
            this.updatePlayerTurn();
            if(Config.TRACE_BATTLE_LOGS)
            {
               FSDebug.debugTrace("[changePlayersState] - PLAYER STATE ID: " + this.getPlayersStateId());
            }
            switch(this.getPlayersStateId())
            {
               case STATE_OWNER_ADVANCE_TURN:
                  this.onStateOwnerAdvanceTurn();
                  break;
               case STATE_OWNER_RECEIVING_CARDS_FROM_DECK:
                  this.setNextStateId(STATE_OWNER_MOVING_UP_FROM_SUPPORT);
                  this.mBattleScreen.dealOwnerCardsToDeck();
                  this.setBattleStateId(BATTLE_STATE_DEALING_CARDS);
                  break;
               case STATE_OWNER_MOVING_UP_FROM_SUPPORT:
                  this.setNextStateId(STATE_OWNER_TRIGGERING_CURSES);
                  this.performSupportToAttackMovement();
                  this.setBattleStateId(BATTLE_STATE_PLAYER_MOVING_CARDS);
                  break;
               case STATE_OWNER_TRIGGERING_CURSES:
                  this.setNextStateId(STATE_OWNER_TRIGGER_ON_START_ABILITIES);
                  this.triggerCurses();
                  this.setBattleStateId(BATTLE_STATE_TRIGGERING_CURSES);
                  break;
               case STATE_OWNER_TRIGGER_ON_START_ABILITIES:
                  this.setNextStateId(STATE_OWNER_MOVING_CARDS);
                  this.triggerAbilities();
                  this.setBattleStateId(BATTLE_STATE_TRIGGERING_ABILITIES);
                  break;
               case STATE_OWNER_MOVING_CARDS:
                  this.onStateMovingCards();
                  break;
               case STATE_OWNER_PRE_ATTACK:
                  this.setBattleStateId(BATTLE_STATE_PLAYER_MOVING_CARDS);
                  this.onPreAttackState();
                  this.setNextStateId(STATE_OWNER_ATTACKING);
                  break;
               case STATE_OWNER_ATTACKING:
                  if(this.isOnlineMatch())
                  {
                     PvPConnectionMng.packageSaveObjForSending();
                     BattleEnginePvP(this).requestPvPTimer(false);
                  }
                  this.mBattleScreen.setSelectedCard(null);
                  this.checkCardsEventsListeners();
                  this.setNextStateId(STATE_OWNER_RETURNING_CARDS);
                  this.setBattleStateId(BATTLE_STATE_ATTACKING);
                  this.onAttackState();
                  break;
               case STATE_OWNER_RETURNING_CARDS:
                  this.setNextStateId(STATE_OWNER_TRIGGER_ON_END_ABILITIES);
                  this.onReturningCardsState();
                  this.setBattleStateId(BATTLE_STATE_DEALING_CARDS);
                  break;
               case STATE_OWNER_TRIGGER_ON_END_ABILITIES:
                  this.setNextStateId(STATE_OWNER_IDLE);
                  this.triggerAbilities();
                  this.setBattleStateId(BATTLE_STATE_TRIGGERING_ABILITIES);
                  break;
               case STATE_OPPONENT_ADVANCE_TURN:
                  this.onStateOpponentAdvanceTurn();
                  break;
               case STATE_OPPONENT_RECEIVING_CARDS_FROM_DECK:
                  this.setNextStateId(STATE_OPPONENT_MOVING_UP_FROM_SUPPORT);
                  this.mBattleScreen.dealOpponentCardsToDeck();
                  this.setBattleStateId(BATTLE_STATE_DEALING_CARDS);
                  break;
               case STATE_OPPONENT_MOVING_UP_FROM_SUPPORT:
                  this.setNextStateId(STATE_OPPONENT_TRIGGERING_CURSES);
                  this.performSupportToAttackMovement();
                  this.setBattleStateId(BATTLE_STATE_PLAYER_MOVING_CARDS);
                  break;
               case STATE_OPPONENT_TRIGGERING_CURSES:
                  this.setNextStateId(STATE_OPPONENT_TRIGGER_ON_START_BATTLE_EVENT);
                  this.triggerCurses();
                  this.setBattleStateId(BATTLE_STATE_TRIGGERING_CURSES);
                  break;
               case STATE_OPPONENT_TRIGGER_ON_START_BATTLE_EVENT:
                  this.setNextStateId(STATE_OPPONENT_TRIGGER_ON_START_ABILITIES);
                  this.triggerBattleEvents(BATTLE_EVENT_START_OF_TURN);
                  this.setBattleStateId(BATTLE_STATE_TRIGGERING_ABILITIES);
                  break;
               case STATE_OPPONENT_TRIGGER_ON_START_ABILITIES:
                  this.setNextStateId(STATE_OPPONENT_MOVING_CARDS);
                  this.triggerAbilities();
                  this.setBattleStateId(BATTLE_STATE_TRIGGERING_ABILITIES);
                  break;
               case STATE_OPPONENT_MOVING_CARDS:
                  this.onStateMovingCards();
                  break;
               case STATE_OPPONENT_PRE_ATTACK:
                  this.setBattleStateId(BATTLE_STATE_PLAYER_MOVING_CARDS);
                  this.onPreAttackState();
                  this.setNextStateId(STATE_OPPONENT_ATTACKING);
                  break;
               case STATE_OPPONENT_ATTACKING:
                  this.mBattleScreen.setSelectedCard(null);
                  this.setNextStateId(STATE_OPPONENT_RETURNING_CARDS);
                  this.setBattleStateId(BATTLE_STATE_ATTACKING);
                  this.onAttackState();
                  break;
               case STATE_OPPONENT_RETURNING_CARDS:
                  this.setNextStateId(STATE_OPPONENT_TRIGGER_ON_END_ABILITIES);
                  this.onReturningCardsState();
                  this.setBattleStateId(BATTLE_STATE_DEALING_CARDS);
                  break;
               case STATE_OPPONENT_TRIGGER_ON_END_ABILITIES:
                  this.setNextStateId(STATE_OPPONENT_TRIGGER_ON_END_BATTLE_EVENT);
                  this.triggerAbilities();
                  this.setBattleStateId(BATTLE_STATE_TRIGGERING_ABILITIES);
                  break;
               case STATE_OPPONENT_TRIGGER_ON_END_BATTLE_EVENT:
                  this.setNextStateId(STATE_OPPONENT_IDLE);
                  this.triggerBattleEvents(BATTLE_EVENT_END_OF_TURN);
                  this.setBattleStateId(BATTLE_STATE_TRIGGERING_ABILITIES);
                  break;
               case STATE_OWNER_IDLE:
               case STATE_OPPONENT_IDLE:
                  this.notifyPlayerTurnDone();
                  this.setBattleStateId(BATTLE_STATE_BATTLE_IDLE);
                  break;
               default:
                  FSDebug.debugTrace("Trying to advance to an unrecognized turnId");
            }
            if(this.mBattleScreen)
            {
               this.mBattleScreen.showObjectivesPanel();
               this.mBattleScreen.showAttackButton();
            }
         }
         catch(e:Error)
         {
            FSDebug.debugTrace("Error tracked " + e.toString());
            if(e != null && Boolean(e.hasOwnProperty("errorID")) && e["errorID"] == 1032)
            {
               FSDebug.debugTrace("Hack cheat attempt -> Auto ban");
               if(Config.smHackCheatAttemptAutoBan)
               {
                  InstanceMng.getServerConnection().addUserToBlackList(false,null,"Hack cheat attempt [AUTO]");
                  InstanceMng.getServerConnection().onConnectionKO();
               }
            }
         }
      }
      
      private function onPreAttackState() : void
      {
         var _loc3_:FSUnit = null;
         var _loc4_:FSCard = null;
         var _loc5_:FSCard = null;
         var _loc6_:Array = null;
         var _loc8_:Number = NaN;
         var _loc9_:Boolean = false;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc1_:UserBattleInfo = this.mIsOwnerTurn ? this.mOwnerBattleInfo : this.mOpponentBattleInfo;
         var _loc2_:Dictionary = _loc1_.getFightCards();
         var _loc7_:Boolean = false;
         for each(_loc3_ in _loc2_)
         {
            _loc5_ = null;
            _loc4_ = null;
            _loc6_ = _loc3_.getEligibleToAttackCards();
            if(_loc6_ != null)
            {
               _loc4_ = _loc3_.getAttackableCard(true,_loc6_);
               _loc5_ = _loc3_.getAttackableCard(false,_loc6_);
            }
            _loc9_ = _loc3_.canAttackFromCurrentPosition();
            _loc10_ = _loc3_.getTransitionCardTime(FSCard.DEFAULT_ELEVATE_CARD_FOR_ATTACK_TIME);
            _loc11_ = _loc3_.getTransitionCardTime(FSCard.DEFAULT_DELAY_BEFORE_ATTACK_TIME);
            if(_loc9_)
            {
               if(_loc4_ != null)
               {
                  _loc3_.requestShowShadow(FSCard.DEFAULT_SCALE_FACTOR_CARDS_ELEVATION,true,_loc10_);
                  _loc4_.requestShowShadow(FSCard.DEFAULT_SCALE_FACTOR_CARDS_ELEVATION,true,_loc10_);
                  _loc7_ = true;
               }
               if(_loc4_ == null)
               {
                  if(_loc5_ != null)
                  {
                     _loc3_.requestShowShadow(FSCard.DEFAULT_SCALE_FACTOR_CARDS_ELEVATION,true,_loc10_);
                     _loc5_.requestShowShadow(FSCard.DEFAULT_SCALE_FACTOR_CARDS_ELEVATION,true,_loc10_);
                     _loc7_ = true;
                  }
               }
               if(_loc4_ == null && _loc5_ == null)
               {
                  _loc3_.requestShowShadow(FSCard.DEFAULT_SCALE_FACTOR_CARDS_ELEVATION,true,_loc10_);
                  _loc7_ = true;
               }
            }
         }
         this.storeCombatLogAction(COMBAT_LOG_ATTACK);
         _loc8_ = _loc7_ ? _loc10_ + _loc11_ : 0;
         TweenMax.delayedCall(_loc8_,this.changePlayersState);
      }
      
      protected function managePortraitsRotation() : void
      {
         var _loc4_:FSBattlefieldUserPortrait = null;
         var _loc1_:Boolean = this.isOwnerTurn();
         var _loc2_:UserBattleInfo = _loc1_ ? this.mOpponentBattleInfo : this.mOwnerBattleInfo;
         var _loc3_:UserBattleInfo = _loc1_ ? this.mOwnerBattleInfo : this.mOpponentBattleInfo;
         if(_loc2_)
         {
            _loc4_ = _loc2_.getUserBattlePortrait();
            if(_loc4_ != null)
            {
               _loc4_.stopPortraitFrameRotation();
            }
         }
         if(_loc3_)
         {
            _loc4_ = _loc3_.getUserBattlePortrait();
            if(_loc4_ != null)
            {
               _loc4_.startPortraitFrameRotation();
            }
         }
      }
      
      protected function onStateOwnerAdvanceTurn() : void
      {
         this.managePortraitsRotation();
         this.setNextStateId(STATE_OWNER_RECEIVING_CARDS_FROM_DECK);
         this.loadNextCardsHandResources();
         this.setBattleStateId(BATTLE_STATE_BATTLE_IDLE);
      }
      
      protected function onStateOpponentAdvanceTurn() : void
      {
         this.managePortraitsRotation();
         this.setNextStateId(STATE_OPPONENT_RECEIVING_CARDS_FROM_DECK);
         this.loadNextCardsHandResources();
         this.setBattleStateId(BATTLE_STATE_BATTLE_IDLE);
      }
      
      public function loadNextCardsHandResources(param1:Boost = null, param2:Function = null, param3:Array = null, param4:String = "", param5:Array = null) : void
      {
         var _loc7_:CardDef = null;
         this.getNextHand(param3,param4);
         var _loc6_:int = 0;
         var _loc8_:Boolean = false;
         if(this.mNextHand != null)
         {
            _loc6_ = 0;
            while(_loc6_ < this.mNextHand.length)
            {
               _loc7_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(this.mNextHand[_loc6_]));
               if(_loc7_ != null)
               {
                  if(_loc7_.hasAnimatedBG())
                  {
                     if(Root.assets.getTextureAtlas(_loc7_.getAnimatedBG()) == null)
                     {
                        InstanceMng.getResourcesMng().loadCardImagesByCardDef(_loc7_);
                        _loc8_ = true;
                     }
                  }
                  else if(InstanceMng.getResourcesMng().loadCardImagesByCardDef(_loc7_))
                  {
                     _loc8_ = true;
                  }
                  if(InstanceMng.getResourcesMng().loadCardSoundsByCardDef(_loc7_))
                  {
                     _loc8_ = true;
                  }
               }
               _loc6_++;
            }
            if(param5 != null && param5.length > 0)
            {
               _loc6_ = 0;
               while(_loc6_ < param5.length)
               {
                  _loc7_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(param5[_loc6_]));
                  if(_loc7_ != null)
                  {
                     if(_loc7_.hasAnimatedBG())
                     {
                        if(Root.assets.getTextureAtlas(_loc7_.getAnimatedBG()) == null)
                        {
                           InstanceMng.getResourcesMng().loadCardImagesByCardDef(_loc7_);
                           _loc8_ = true;
                        }
                     }
                     else if(InstanceMng.getResourcesMng().loadCardImagesByCardDef(_loc7_))
                     {
                        _loc8_ = true;
                     }
                     if(InstanceMng.getResourcesMng().loadCardSoundsByCardDef(_loc7_))
                     {
                        _loc8_ = true;
                     }
                  }
                  _loc6_++;
               }
            }
         }
         if(Boolean(this.mNextHand != null && this.mNextHand.length > 0) && Boolean(this.mBattleScreen) && _loc8_)
         {
            this.mBattleScreen.showLoadingIcon(true,true);
         }
         if(param1)
         {
            this.mBoostWaitingForResources = param1;
         }
         var _loc9_:Function = param2 == null ? this.onNextCardsHandResourcesLoaded : param2;
         if(this.mNextHand == null)
         {
            FSDebug.debugTrace("Skipping owner step since there are no more cards to be moved.");
            _loc9_();
         }
         else if(this.mBattleScreen)
         {
            if(_loc8_)
            {
               if(!Root.assets.isLoading)
               {
                  InstanceMng.getResourcesMng().loadAssets(_loc9_);
               }
               else
               {
                  FSDebug.debugTrace("Delaying the load assets call for a few seconds since something is loading");
                  setTimeout(this.loadNextCardsHandResources,1000,param1,param2,param3,param4,param5);
               }
            }
            else
            {
               _loc9_();
            }
         }
      }
      
      public function getBoostWaitingForResource() : Boost
      {
         return this.mBoostWaitingForResources;
      }
      
      public function resetBoostWaitingForResource() : void
      {
         this.mBoostWaitingForResources = null;
      }
      
      protected function onNextCardsHandResourcesLoaded() : void
      {
         if(this.mBattleScreen)
         {
            this.mBattleScreen.showLoadingIcon(false,true);
         }
         this.notifyPlayersAdvanceTurn();
      }
      
      private function isBGImageUnloadableByCatalog(param1:FSCard, param2:Dictionary) : Boolean
      {
         var _loc3_:Boolean = true;
         if(param1.isZoomedIn())
         {
            return false;
         }
         return InstanceMng.getCardsMng().checkIfBGImageUnloadableByCardDef(param1.getCardDef(),param2,param1);
      }
      
      private function isSoundUnloadableByCatalog(param1:FSCard, param2:Dictionary, param3:String) : Boolean
      {
         var _loc4_:Boolean = true;
         if(param1.isZoomedIn())
         {
            return false;
         }
         return InstanceMng.getCardsMng().checkIfSoundUnloadableByCardDef(param1.getCardDef(),param2,param1,param3);
      }
      
      public function isSoundUnloadable(param1:FSCard, param2:String) : Boolean
      {
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc3_:Boolean = true;
         if(param1 != null)
         {
            _loc4_ = this.isSoundUnloadableOnStageCards(param1,param2);
            if(!_loc4_)
            {
               return false;
            }
            _loc5_ = this.isBattleEventWithSameSound(param1,param2);
            if(_loc5_)
            {
               return false;
            }
            _loc3_ = param1 is FSCardPreview ? false : _loc3_;
         }
         return _loc3_;
      }
      
      public function isBGImageUnloadable(param1:FSCard) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc2_:Boolean = true;
         if(param1 != null)
         {
            _loc3_ = this.isBGImageUnloadableByCatalog(param1,this.mOwnerBattleInfo.getFightCards());
            if(!_loc3_)
            {
               return false;
            }
            _loc4_ = this.isBGImageUnloadableByCatalog(param1,this.mOpponentBattleInfo.getFightCards());
            if(!_loc4_)
            {
               return false;
            }
            _loc5_ = this.isBGImageUnloadableByCatalog(param1,this.mOwnerBattleInfo.getPlayableCardsCatalog());
            if(!_loc5_)
            {
               return false;
            }
            _loc6_ = this.isBGImageUnloadableByCatalog(param1,this.mOpponentBattleInfo.getPlayableCardsCatalog());
            if(!_loc6_)
            {
               return false;
            }
            _loc7_ = this.isBGImageUnloadableOnStageCards(param1);
            if(!_loc7_)
            {
               return false;
            }
            _loc8_ = this.isBattleEventWithSameImage(param1);
            if(_loc8_)
            {
               return false;
            }
            _loc2_ = param1 is FSCardPreview ? false : _loc2_;
         }
         return _loc2_;
      }
      
      private function isBattleEventWithSameImage(param1:FSCard) : Boolean
      {
         var _loc3_:CardDef = null;
         var _loc4_:BattleEventDef = null;
         var _loc5_:RaidDef = null;
         var _loc6_:int = 0;
         var _loc7_:UserData = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc2_:Boolean = false;
         if(Boolean(Root) && Boolean(Root.smBattleData != null) && Boolean(Root.smBattleData.isRaid))
         {
            _loc5_ = InstanceMng.getRaidsMng().getCurrentRaidDef();
            if(_loc5_)
            {
               _loc6_ = InstanceMng.getRaidsMng().getCurrentRaidDifficulty();
               _loc4_ = _loc5_.getBattleEventByDifficultyIndex(_loc6_);
               if(_loc4_)
               {
                  _loc3_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc4_.getActionSku()));
                  if(Boolean(_loc3_ && param1) && Boolean(param1.getCardDef()) && _loc3_.getBGImageName() == param1.getCardDef().getBGImageName())
                  {
                     if(_loc3_.hasAnimatedBG())
                     {
                        if(_loc3_.getAnimatedBG() == param1.getCardDef().getAnimatedBG())
                        {
                           _loc2_ = true;
                        }
                     }
                     else if(_loc3_.getBGImageName() == param1.getCardDef().getBGImageName())
                     {
                        _loc2_ = true;
                     }
                  }
               }
            }
         }
         else if(Boolean(this.mLevelDef) && this.mLevelDef.hasBattleEvent())
         {
            _loc7_ = Utils.getOwnerUserData();
            if(_loc7_)
            {
               _loc8_ = _loc7_.getCurrentDifficulty();
               _loc9_ = this.mLevelDef.getMapWorldParentIndex();
               _loc10_ = _loc7_.getMapWorldChoice(_loc10_);
               _loc4_ = BattleEventDef(InstanceMng.getBattleEventDefMng().getDefBySku(this.mLevelDef.getBattleEventSkuByDifficulty(_loc8_,_loc10_)));
               if(_loc4_)
               {
                  _loc3_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc4_.getActionSku()));
                  if(Boolean(_loc3_ && param1) && Boolean(param1.getCardDef()) && _loc3_.getBGImageName() == param1.getCardDef().getBGImageName())
                  {
                     if(_loc3_.hasAnimatedBG())
                     {
                        if(_loc3_.getAnimatedBG() == param1.getCardDef().getAnimatedBG())
                        {
                           _loc2_ = true;
                        }
                     }
                     else if(_loc3_.getBGImageName() == param1.getCardDef().getBGImageName())
                     {
                        _loc2_ = true;
                     }
                  }
               }
            }
         }
         return _loc2_;
      }
      
      private function isBattleEventWithSameSound(param1:FSCard, param2:String) : Boolean
      {
         var _loc4_:CardDef = null;
         var _loc5_:BattleEventDef = null;
         var _loc6_:Vector.<String> = null;
         var _loc7_:int = 0;
         var _loc8_:RaidDef = null;
         var _loc9_:int = 0;
         var _loc10_:UserData = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc3_:Boolean = false;
         if(Boolean(Root) && Boolean(Root.smBattleData != null) && Boolean(Root.smBattleData.isRaid))
         {
            _loc8_ = InstanceMng.getRaidsMng().getCurrentRaidDef();
            if(_loc8_)
            {
               _loc9_ = InstanceMng.getRaidsMng().getCurrentRaidDifficulty();
               _loc5_ = _loc8_.getBattleEventByDifficultyIndex(_loc9_);
               if(_loc5_)
               {
                  _loc4_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc5_.getActionSku()));
                  if(Boolean((_loc4_) && param1) && Boolean(param1.getCardDef()) && _loc4_.getBGImageName() == param1.getCardDef().getBGImageName())
                  {
                     _loc6_ = InstanceMng.getCardsMng().getCardAllPossibleSounds(null,_loc4_);
                     if(_loc6_)
                     {
                        _loc7_ = 0;
                        while(_loc7_ < _loc6_.length)
                        {
                           if(_loc6_[_loc7_] == param2)
                           {
                              return true;
                           }
                           _loc7_++;
                        }
                     }
                  }
               }
            }
         }
         else if(Boolean(this.mLevelDef) && this.mLevelDef.hasBattleEvent())
         {
            _loc10_ = Utils.getOwnerUserData();
            if(_loc10_)
            {
               _loc11_ = _loc10_.getCurrentDifficulty();
               _loc12_ = this.mLevelDef.getMapWorldParentIndex();
               _loc13_ = _loc10_.getMapWorldChoice(_loc13_);
               _loc5_ = BattleEventDef(InstanceMng.getBattleEventDefMng().getDefBySku(this.mLevelDef.getBattleEventSkuByDifficulty(_loc11_,_loc13_)));
               if(_loc5_)
               {
                  _loc4_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc5_.getActionSku()));
                  if(Boolean((_loc4_) && param1) && Boolean(param1.getCardDef()) && _loc4_.getBGImageName() == param1.getCardDef().getBGImageName())
                  {
                     _loc6_ = InstanceMng.getCardsMng().getCardAllPossibleSounds(null,_loc4_);
                     if(_loc6_)
                     {
                        _loc7_ = 0;
                        while(_loc7_ < _loc6_.length)
                        {
                           if(_loc6_[_loc7_] == param2)
                           {
                              return true;
                           }
                           _loc7_++;
                        }
                     }
                  }
               }
            }
         }
         return _loc3_;
      }
      
      private function isBGImageUnloadableOnStageCards(param1:FSCard) : Boolean
      {
         var _loc2_:* = undefined;
         var _loc4_:Dictionary = null;
         var _loc5_:int = 0;
         var _loc8_:int = 0;
         var _loc3_:Screen = InstanceMng.getCurrentScreen();
         var _loc6_:Boolean = false;
         var _loc7_:int = _loc3_.numChildren;
         _loc8_ = 0;
         while(_loc8_ < _loc7_)
         {
            _loc2_ = _loc3_.getChildAt(_loc8_);
            if(_loc2_ != null && _loc2_ is FSCard)
            {
               if(!param1.isZoomedIn())
               {
                  if(_loc4_ == null)
                  {
                     _loc4_ = new Dictionary(true);
                  }
                  _loc4_[_loc5_] = _loc2_;
                  _loc5_++;
               }
            }
            _loc8_++;
         }
         return this.isBGImageUnloadableByCatalog(param1,_loc4_);
      }
      
      private function isSoundUnloadableOnStageCards(param1:FSCard, param2:String) : Boolean
      {
         var _loc3_:* = undefined;
         var _loc5_:Dictionary = null;
         var _loc6_:int = 0;
         var _loc9_:int = 0;
         var _loc4_:Screen = InstanceMng.getCurrentScreen();
         var _loc7_:Boolean = false;
         var _loc8_:int = _loc4_.numChildren;
         _loc9_ = 0;
         while(_loc9_ < _loc8_)
         {
            _loc3_ = _loc4_.getChildAt(_loc9_);
            if(_loc3_ != null && _loc3_ is FSCard)
            {
               if(!param1.isZoomedIn())
               {
                  if(_loc5_ == null)
                  {
                     _loc5_ = new Dictionary(true);
                  }
                  _loc5_[_loc6_] = _loc3_;
                  _loc6_++;
               }
            }
            _loc9_++;
         }
         return this.isSoundUnloadableByCatalog(param1,_loc5_,param2);
      }
      
      public function isBGImageUnloadableByCardDef(param1:CardDef) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc2_:Boolean = true;
         if(param1 != null)
         {
            _loc3_ = InstanceMng.getCardsMng().checkIfBGImageUnloadableByCardDef(param1,this.mOwnerBattleInfo.getFightCards());
            if(!_loc3_)
            {
               return false;
            }
            _loc4_ = InstanceMng.getCardsMng().checkIfBGImageUnloadableByCardDef(param1,this.mOpponentBattleInfo.getFightCards());
            if(!_loc4_)
            {
               return false;
            }
            _loc5_ = InstanceMng.getCardsMng().checkIfBGImageUnloadableByCardDef(param1,this.mOwnerBattleInfo.getPlayableCardsCatalog());
            if(!_loc5_)
            {
               return false;
            }
            _loc6_ = InstanceMng.getCardsMng().checkIfBGImageUnloadableByCardDef(param1,this.mOpponentBattleInfo.getPlayableCardsCatalog());
            if(!_loc6_)
            {
               return false;
            }
         }
         return _loc2_;
      }
      
      protected function onStateMovingCards() : void
      {
         switch(this.getPlayersStateId())
         {
            case STATE_OWNER_MOVING_CARDS:
               this.mBattleScreen.lockUI(false);
               this.setBattleStateId(BATTLE_STATE_PLAYER_MOVING_CARDS);
               this.checkCardsEventsListeners();
               if(this.mBattleScreen)
               {
                  this.mBattleScreen.suggestPlayableCardON();
               }
               if(InstanceMng.getConversationsMng())
               {
                  InstanceMng.getConversationsMng().checkIfCustomConversation();
               }
               this.setNextStateId(STATE_OWNER_PRE_ATTACK);
               break;
            case STATE_OPPONENT_MOVING_CARDS:
               this.setNextStateId(STATE_OPPONENT_PRE_ATTACK);
               this.mAIEngine.performNextStep();
               this.setBattleStateId(BATTLE_STATE_PLAYER_MOVING_CARDS);
         }
      }
      
      private function triggerCurses() : void
      {
         var _loc8_:int = 0;
         var _loc9_:FSCard = null;
         var _loc10_:int = 0;
         var _loc1_:UserBattleInfo = this.mIsOwnerTurn ? this.mOwnerBattleInfo : this.mOpponentBattleInfo;
         var _loc2_:Dictionary = _loc1_.getFightCards();
         var _loc3_:int = DictionaryUtils.getDictionaryLength(_loc2_);
         var _loc4_:int = _loc1_.getPoisonTurns();
         var _loc5_:Boolean = _loc4_ > 0 || _loc4_ == -1;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         if(!this.isOwnerTurn())
         {
            if(this.mCursesTriggered != null)
            {
               _loc7_ = this.mCursesTriggered[this.mCurrentTurnId] == 1;
            }
            if(this.mCursesTriggered == null)
            {
               this.mCursesTriggered = new Dictionary(true);
            }
            this.mCursesTriggered[this.mCurrentTurnId] = 1;
         }
         if(!_loc7_ && (_loc3_ > 0 || _loc5_))
         {
            _loc8_ = 0;
            for each(_loc9_ in _loc2_)
            {
               _loc10_ = FSUnit(_loc9_).getPoisonTurns();
               if(_loc10_ > 0 || _loc10_ == -1)
               {
                  FSUnit(_loc9_).takeDOTDamage();
                  _loc6_ = true;
               }
            }
            if(_loc5_)
            {
               _loc1_.takeDOTDamage();
            }
            _loc8_ = _loc6_ || _loc5_ ? 1 : 0;
            TweenMax.delayedCall(_loc8_ * Config.getConfig().getDefaultAbilityAnimDuration(),this.checkCardsKilledInCombat);
            TweenMax.delayedCall(_loc8_ * Config.getConfig().getDefaultAbilityAnimDuration(),this.checkIfBattleOver);
         }
         else
         {
            this.changePlayersState();
         }
      }
      
      private function triggerAbilities() : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:FSCard = null;
         var _loc7_:Ability = null;
         var _loc8_:Boolean = false;
         var _loc9_:uint = 0;
         var _loc10_:int = 0;
         var _loc11_:Vector.<Ability> = null;
         if(!Config.smAbilitiesOn || !this.mIsOwnerTurn && !Config.smAIAbilitiesOn)
         {
            this.changePlayersState();
            return;
         }
         if(this.isOwnerTurn())
         {
            this.mOwnerBattleInfo.executePassive();
         }
         else if(this.isPvPMatch())
         {
            this.mOpponentBattleInfo.executePassive();
         }
         var _loc1_:Dictionary = this.mIsOwnerTurn ? this.mOwnerBattleInfo.getFightCards() : this.mOpponentBattleInfo.getFightCards();
         var _loc2_:int = DictionaryUtils.getDictionaryLength(_loc1_);
         if(_loc2_ > 0)
         {
            _loc3_ = 0;
            _loc4_ = 0;
            _loc5_ = 0;
            for each(_loc6_ in _loc1_)
            {
               _loc4_ = this.triggerCardAbilities(_loc6_,_loc5_);
               _loc5_ += _loc4_;
               _loc8_ = _loc4_ > 0;
               if(_loc8_)
               {
                  _loc3_++;
               }
            }
            TweenMax.delayedCall(_loc5_ * Config.getConfig().getDefaultAbilityAnimDuration(),this.checkCardsKilledInCombat);
            TweenMax.delayedCall(_loc5_ * Config.getConfig().getDefaultAbilityAnimDuration(),this.checkIfBattleOver);
         }
         else
         {
            this.changePlayersState();
         }
      }
      
      public function triggerBattleEventAbilities(param1:FSCard) : Boolean
      {
         var _loc3_:Ability = null;
         var _loc4_:FSImage = null;
         var _loc5_:uint = 0;
         var _loc6_:FSCard = null;
         var _loc7_:FSCard = null;
         var _loc8_:Boolean = false;
         var _loc2_:Boolean = false;
         if(param1)
         {
            _loc6_ = param1.getFightingWithCard();
            _loc7_ = !param1.isAttacking() && _loc6_ != null ? _loc6_ : null;
            _loc8_ = _loc7_ != null && _loc7_.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_FORTIFICATION) != null;
            if(param1.getAbilities().length > 0)
            {
               _loc3_ = param1.getAbilities()[0];
            }
            if(_loc3_ != null)
            {
               if(_loc3_.canBeExecutedAndHasTargets())
               {
                  if(Config.TRACE_BATTLE_LOGS)
                  {
                     FSDebug.debugTrace("[triggerCardAbilities] ** - Triggering ab: " + _loc3_.getAbilityDef().getName() + " in : " + Config.getConfig().getDefaultAbilityAnimDuration() + " secs");
                  }
                  TweenMax.delayedCall(Config.getConfig().getDefaultAbilityAnimDuration(),this.executeAbility,[_loc3_]);
                  if(_loc3_.getAbilityDef().getHighlightOnExecute())
                  {
                     _loc4_ = param1.getAbilityIconImage(_loc3_.getAbilityDef());
                     if(_loc4_)
                     {
                        _loc5_ = _loc4_.color;
                        TweenMax.delayedCall(Config.getConfig().getDefaultAbilityAnimDuration(),SpecialFX.tweenToColor,[_loc4_,1,8388736,0]);
                        TweenMax.delayedCall(Config.getConfig().getDefaultAbilityAnimDuration() + 1,SpecialFX.tweenToColor,[_loc4_,1,_loc5_,0]);
                     }
                  }
                  _loc2_ = true;
               }
            }
         }
         return _loc2_;
      }
      
      public function triggerCardAbilities(param1:FSCard, param2:int = 0, param3:Boolean = false, param4:int = -1000) : int
      {
         var _loc6_:Ability = null;
         var _loc7_:FSImage = null;
         var _loc8_:uint = 0;
         var _loc9_:int = 0;
         var _loc10_:Vector.<Ability> = null;
         var _loc11_:Vector.<Ability> = null;
         var _loc12_:int = 0;
         var _loc13_:FSCard = null;
         var _loc14_:FSCard = null;
         var _loc15_:Boolean = false;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc5_:int = 0;
         if(Boolean(param1) && param1.isAlive())
         {
            _loc12_ = param2;
            _loc13_ = param1.getFightingWithCard();
            _loc14_ = !param1.isAttacking() && _loc13_ != null ? _loc13_ : null;
            _loc15_ = _loc14_ != null && _loc14_.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_FORTIFICATION) != null;
            if(!Config.smAbilitiesOn || _loc15_ || param1.getParentUserBattleInfo() != null && !param1.getParentUserBattleInfo().isOwnerBattleInfo() && !Config.smAIAbilitiesOn)
            {
               return -1;
            }
            _loc5_ = 0;
            _loc10_ = param1.getCompositeAbilitiesVector(param4);
            if(_loc10_ != null)
            {
               _loc9_ = int(_loc10_.length);
               _loc16_ = 0;
               _loc17_ = 0;
               _loc17_ = 0;
               while(_loc17_ < _loc10_.length)
               {
                  _loc6_ = _loc10_[_loc17_];
                  if((Boolean(_loc6_)) && _loc6_.canBeExecutedAndHasTargets())
                  {
                     _loc16_++;
                  }
                  _loc17_++;
               }
               _loc18_ = 0;
               _loc18_ = 0;
               while(_loc18_ < _loc10_.length)
               {
                  _loc6_ = _loc10_[_loc18_];
                  if((Boolean(_loc6_)) && _loc6_.canBeExecutedAndHasTargets())
                  {
                     if(Config.TRACE_BATTLE_LOGS)
                     {
                        FSDebug.debugTrace("[triggerCardAbilities] ** - Triggering ab: " + _loc6_.getAbilityDef().getName() + " in : " + _loc12_ * Config.getConfig().getDefaultAbilityAnimDuration() + " secs");
                     }
                     TweenMax.delayedCall(_loc12_ * Config.getConfig().getDefaultAbilityAnimDuration(),this.executeAbility,[_loc6_,_loc12_ == _loc16_ - 1]);
                     if(_loc6_.getAbilityDef() != null && _loc6_.getAbilityDef().getHighlightOnExecute())
                     {
                        _loc7_ = param1.getAbilityIconImage(_loc6_.getAbilityDef());
                        if(_loc7_)
                        {
                           _loc8_ = _loc7_.color;
                           TweenMax.delayedCall(_loc12_ * Config.getConfig().getDefaultAbilityAnimDuration(),SpecialFX.tweenToColor,[_loc7_,1,8388736,0]);
                           TweenMax.delayedCall(_loc12_ * Config.getConfig().getDefaultAbilityAnimDuration() + 1,SpecialFX.tweenToColor,[_loc7_,1,_loc8_,0]);
                        }
                     }
                     _loc5_++;
                     _loc12_++;
                  }
                  _loc18_++;
               }
            }
         }
         return _loc5_;
      }
      
      private function executeAbility(param1:Ability, param2:Boolean = true) : void
      {
         if(param1)
         {
            param1.execute(param2);
         }
      }
      
      public function highlightTriggeringAbilitiesCard(param1:FSCard, param2:Boolean) : void
      {
         if(param2)
         {
            param1.scaleX *= 1.05;
            param1.scaleY *= 1.05;
         }
         else
         {
            param1.width = param1.getAttachedToSocket().width;
            param1.height = param1.getAttachedToSocket().height;
            if(param1.getAttachedToSocket().filter)
            {
               param1.getAttachedToSocket().filter.dispose();
               param1.getAttachedToSocket().filter = null;
            }
            param1.getAttachedToSocket().getBGImage().color = 0;
            TweenMax.killTweensOf(param1);
            if(param1.getAttachedToSocket() != null)
            {
               TweenMax.killTweensOf(param1.getAttachedToSocket());
            }
         }
      }
      
      protected function checkCardsEventsListeners() : void
      {
         var _loc1_:Dictionary = null;
         _loc1_ = this.mOwnerBattleInfo.getFightCards();
         this.manageEventListenersByCatalog(_loc1_);
         _loc1_ = this.mOpponentBattleInfo.getFightCards();
         this.manageEventListenersByCatalog(_loc1_);
         _loc1_ = this.mOwnerBattleInfo.getPlayableCardsCatalog();
         this.manageEventListenersByCatalog(_loc1_);
         _loc1_ = this.mOpponentBattleInfo.getPlayableCardsCatalog();
         this.manageEventListenersByCatalog(_loc1_);
      }
      
      private function manageEventListenersByCatalog(param1:Dictionary) : void
      {
         var _loc2_:FSCard = null;
         var _loc3_:Boolean = this.getBattleStateId() == BATTLE_STATE_PLAYER_MOVING_CARDS;
         for each(_loc2_ in param1)
         {
            if(_loc3_)
            {
               if(_loc2_.isAlive())
               {
                  _loc2_.addEventListeners();
               }
            }
            else
            {
               _loc2_.removeEventListeners();
            }
         }
      }
      
      private function onReturningCardsState() : void
      {
         if(this.mIsOwnerTurn)
         {
            this.mBattleScreen.returnOwnerCardsToDeck();
         }
         else
         {
            this.mBattleScreen.returnOpponentCardsToDeck();
         }
      }
      
      public function onPvPOpponentReshuffledReceived(param1:Boolean = false) : void
      {
         this.setOpponentCanReceiveNextHand(true);
         this.mBattleScreen.returnOpponentCardsToDeck(param1);
      }
      
      protected function notifyPlayersAdvanceTurn() : void
      {
         var _loc1_:String = null;
         var _loc2_:Boolean = false;
         if(Config.TRACE_BATTLE_LOGS)
         {
            FSDebug.debugTrace("[notifyPlayersAdvanceTurn]");
         }
         if(Boolean(this.mBattleScreen) && Boolean(this.mOwnerBattleInfo) && Boolean(this.mOpponentBattleInfo))
         {
            _loc1_ = this.mIsOwnerTurn ? "Owner" : "Opponent";
            InstanceMng.getBattleEngine().storeCombatLogAction(COMBAT_LOG_NEW_TURN,null,"",{
               "TURN":this.mCurrentTurnId + 1,
               "TURN FOR":_loc1_
            });
            if(this.mIsOwnerTurn)
            {
               ++this.mCurrentTurnId;
               this.mBattleScreen.updateScoreStars();
               this.setTurnsWithoutTakingDamage(this.mTurnsWithoutTakingDamage - 1);
               this.mBattleScreen.enableBoostsPanel(true);
               this.mOwnerBattleInfo.resetActionPoints();
               this.mOpponentBattleInfo.updateCardsTurnsToAttack();
               this.mOwnerBattleInfo.updateInvulnerabilityTurns();
               this.mOwnerBattleInfo.updateUnblockableTurns();
               if(Config.getConfig().gameHasSacrifice())
               {
                  this.mOwnerBattleInfo.setSacrificeAvailable(true);
               }
               else if(Config.getConfig().gameHasPowers())
               {
                  this.mOwnerBattleInfo.setPowerAvailable(true,true);
               }
               this.mOpponentBattleInfo.updateUnableToMoveToAttackLaneTurns();
               this.mOpponentBattleInfo.updatePoisonTurns();
               this.mOpponentBattleInfo.updateExtraSummonCostTurns();
               this.mOpponentBattleInfo.updateFixedSummonCostTurns();
               this.mOpponentBattleInfo.resetPlayableCardsInTurn();
            }
            else
            {
               this.mBattleScreen.enableBoostsPanel(false);
               this.mOpponentBattleInfo.resetActionPoints();
               this.mOwnerBattleInfo.updateCardsTurnsToAttack();
               this.mOpponentBattleInfo.updateInvulnerabilityTurns();
               this.mOpponentBattleInfo.updateUnblockableTurns();
               if(Config.getConfig().gameHasSacrifice())
               {
                  this.mOpponentBattleInfo.setSacrificeAvailable(true);
               }
               else if(Config.getConfig().gameHasPowers())
               {
                  this.mOpponentBattleInfo.setPowerAvailable(true,true);
               }
               this.mOwnerBattleInfo.updateUnableToMoveToAttackLaneTurns();
               this.mOwnerBattleInfo.updatePoisonTurns();
               this.mOwnerBattleInfo.updateExtraSummonCostTurns();
               this.mOwnerBattleInfo.updateFixedSummonCostTurns();
               this.mOwnerBattleInfo.resetPlayableCardsInTurn();
            }
            this.checkBFSummonCooldown();
            this.mBattleScreen.updateCurrentTurnsTextfield();
            _loc2_ = InstanceMng.getTargetMng().canPlayerKeepPlaying();
            if(!_loc2_)
            {
               this.setBattleStateId(BATTLE_STATE_BATTLE_OVER);
            }
            this.changePlayersState();
         }
      }
      
      private function checkBFSummonCooldown() : void
      {
         var _loc2_:Dictionary = null;
         var _loc3_:FSCard = null;
         var _loc1_:UserBattleInfo = this.mIsOwnerTurn ? this.mOwnerBattleInfo : this.mOpponentBattleInfo;
         if(_loc1_ != null)
         {
            _loc2_ = _loc1_.getFightCards();
            if(_loc2_ != null)
            {
               for each(_loc3_ in _loc2_)
               {
                  _loc3_.updateSummonCooldown();
                  _loc3_.increaseTurnsAlive();
               }
            }
         }
      }
      
      public function updatePlayerTurn() : void
      {
         switch(this.getPlayersStateId())
         {
            case STATE_OWNER_BEGIN_BATTLE:
            case STATE_OPPONENT_IDLE:
            case STATE_OWNER_RECEIVING_CARDS_FROM_DECK:
            case STATE_OWNER_MOVING_UP_FROM_SUPPORT:
            case STATE_OWNER_MOVING_CARDS:
            case STATE_OWNER_ATTACKING:
               this.mIsOwnerTurn = true;
               break;
            case STATE_OPPONENT_BEGIN_BATTLE:
            case STATE_OWNER_IDLE:
            case STATE_OPPONENT_RECEIVING_CARDS_FROM_DECK:
            case STATE_OPPONENT_MOVING_UP_FROM_SUPPORT:
            case STATE_OPPONENT_MOVING_CARDS:
            case STATE_OPPONENT_ATTACKING:
               this.mIsOwnerTurn = false;
         }
      }
      
      public function notifyActionDone(param1:int = 1) : void
      {
         var _loc3_:FSAttackButton = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:Number = NaN;
         var _loc2_:UserBattleInfo = this.isOwnerTurn() ? this.getOwnerBattleInfo() : this.getOpponentBattleInfo();
         if(_loc2_ != null)
         {
            if(this.mBattleScreen)
            {
               this.mBattleScreen.disableFreeReshuffle(_loc2_);
            }
            _loc2_.spendActionPoints(param1);
         }
         this.mBattleScreen.updateActionPointsLeft();
         if(!_loc2_.hasActionPointsLeft(param1))
         {
            if(this.isPvPMatch() && !this.isOnlineMatch() || this.isOnlineMatch() && this.isOwnerTurn() || !this.isOnlineMatch() && this.isOwnerTurn())
            {
               if(_loc2_.getActionPointsLeft() == 0)
               {
                  this.mBattleScreen.suggestPlayableCardOFF();
               }
               else
               {
                  this.mBattleScreen.suggestPlayableCardON();
               }
            }
            _loc3_ = this.mBattleScreen.getAttackButton();
            if(_loc3_ != null)
            {
               _loc3_.updateVisualHighlights();
            }
            _loc4_ = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
            if(this.mLevelDef != null && this.mLevelDef.getSku() == "level_01" && _loc4_ == UserDataMng.DIFFICULTY_EASY && this.isOwnerTurn())
            {
               _loc5_ = InstanceMng.getApplication().isBrowserVersion() || Utils.isDesktop() ? TextManager.getText("TID_TUTORIAL_ATTACK_BUTTON_BROWSER") : TextManager.getText("TID_TUTORIAL_ATTACK_BUTTON");
               Utils.setLogText(_loc5_,false,true);
               if(Config.getConfig().hasToShowAttackButtonTransitionOnTutorial())
               {
                  _loc3_ = this.mBattleScreen.getAttackButton();
                  this.disableAttackButton();
                  _loc6_ = this.mAbilityWaitingForTarget ? 0 : Config.getConfig().getDefaultZoomOutTime();
                  TweenMax.delayedCall(_loc6_,this.performAttackButtonTutorialStep);
               }
            }
         }
      }
      
      private function performAttackButtonTutorialStep() : void
      {
         var _loc1_:FSAttackButton = null;
         var _loc2_:FSCoordinate = null;
         var _loc3_:int = 0;
         if(this.mBattleScreen)
         {
            _loc1_ = this.mBattleScreen.getAttackButton();
            if(_loc1_)
            {
               _loc2_ = new FSCoordinate(_loc1_.x,_loc1_.y);
               _loc3_ = this.mBattleScreen.getBFWidth();
               _loc1_.x = _loc3_ / 2;
               _loc1_.x += this.mBattleScreen.getBFExtraSpaceX();
               _loc1_.y = Starling.current.stage.stageHeight / 2;
               SpecialFX.createZoomAlphaTween(_loc1_,1,0.001,0.999,2,1,null,this.performAttackButtonTutorialStep2,[_loc2_]);
            }
         }
      }
      
      private function performAttackButtonTutorialStep2(param1:FSCoordinate) : void
      {
         var _loc2_:FSAttackButton = this.mBattleScreen.getAttackButton();
         SpecialFX.createTransition(_loc2_,param1,0.5,0,this.onAttackButtonTutorialStep3);
      }
      
      private function onAttackButtonTutorialStep3() : void
      {
         var _loc1_:FSAttackButton = this.mBattleScreen.getAttackButton();
         this.mBattleScreen.setObjectivesPanelonTop();
         if(_loc1_)
         {
            if(this.getPlayersStateId() != STATE_OWNER_PRE_ATTACK && this.getPlayersStateId() != STATE_OPPONENT_PRE_ATTACK)
            {
               this.enableAttackButton();
            }
         }
      }
      
      public function canPlayerDoMoreActions(param1:int = 1) : Boolean
      {
         var _loc2_:UserBattleInfo = this.isOwnerTurn() ? this.getOwnerBattleInfo() : this.getOpponentBattleInfo();
         return _loc2_.hasActionPointsLeft(param1);
      }
      
      private function sortAttackerCardsByAttackOrder(param1:Dictionary) : Array
      {
         var _loc2_:Array = null;
         var _loc3_:FSCard = null;
         var _loc4_:FSCardSocket = null;
         var _loc5_:int = 0;
         if(param1)
         {
            for each(_loc3_ in param1)
            {
               _loc4_ = _loc3_.getAttachedToSocket();
               if(_loc4_)
               {
                  if(_loc2_ == null)
                  {
                     _loc2_ = new Array();
                  }
                  _loc2_.push(_loc3_);
               }
            }
            _loc2_ = _loc2_ ? _loc2_.sort(DictionaryUtils.sortCardsArrByBattlefieldPosition) : null;
         }
         return _loc2_;
      }
      
      private function onAttackState() : void
      {
         var card:FSUnit = null;
         var defenderCardAttackLane:FSCard = null;
         var defenderCardSupportLane:FSCard = null;
         var eligibleToAttackCardsArr:Array = null;
         var attackCounter:Number = NaN;
         var cardsAttackingPlayerDirectly:Array = null;
         var lastAttackingCardColumnIndex:int = 0;
         var lastAtackingCardTimeElapsed:Number = NaN;
         var currentAttackingCardTimeElapsed:Number = NaN;
         var lastAttackingCardWasOnSameCol:Boolean = false;
         var i:int = 0;
         var allowedToAttackFromCurrPos:Boolean = false;
         var hasFortification:Boolean = false;
         var attackerHasMachineGun:Boolean = false;
         var attackerHasMachineGunPlus:Boolean = false;
         var attackerHasMachineGun4:Boolean = false;
         var handleAttackingLanes:Function = function(param1:FSCard, param2:FSCard, param3:Boolean):void
         {
            var _loc4_:Function = null;
            if(param2 != null)
            {
               param1.setIsAttacking(true,param2);
               param2.setIsAttacking(false,param1);
               currentAttackingCardTimeElapsed = Config.getConfig().getDefaultAttackAnimDuration() + param1.calculateTimeEllapsedForTriggeringAbilities();
               lastAttackingCardWasOnSameCol = lastAttackingCardColumnIndex != -1 && lastAttackingCardColumnIndex == param1.getAttachedToSocket().getColumnIndex();
               if(lastAttackingCardWasOnSameCol && !param1.isOnSupportLane())
               {
                  attackCounter -= lastAtackingCardTimeElapsed;
               }
               _loc4_ = param3 ? attackAttackLane : attackSupportLane;
               TweenMax.delayedCall(attackCounter,_loc4_,[param1,param2]);
               attackCounter += lastAttackingCardWasOnSameCol ? Math.max(currentAttackingCardTimeElapsed,lastAtackingCardTimeElapsed) : currentAttackingCardTimeElapsed;
               lastAtackingCardTimeElapsed = currentAttackingCardTimeElapsed;
               lastAttackingCardColumnIndex = param1.getAttachedToSocket().getColumnIndex();
               if(!param3)
               {
                  TweenMax.delayedCall(attackCounter - 1,attackAnimation,[param1]);
               }
            }
         };
         var attackerBattleInfo:UserBattleInfo = this.mIsOwnerTurn ? this.mOwnerBattleInfo : this.mOpponentBattleInfo;
         var attackerBFCards:Dictionary = attackerBattleInfo.getFightCards();
         var directDamageToPlayer:FSNumber = new FSNumber();
         attackCounter = 0;
         var cardDamageToPlayer:FSNumber = new FSNumber(0);
         lastAttackingCardColumnIndex = -1;
         lastAtackingCardTimeElapsed = 0;
         currentAttackingCardTimeElapsed = 0;
         lastAttackingCardWasOnSameCol = false;
         var sortedCardsArr:Array = this.sortAttackerCardsByAttackOrder(attackerBFCards);
         if(Boolean(sortedCardsArr) && sortedCardsArr.length > 0)
         {
            i = 0;
            while(i < sortedCardsArr.length)
            {
               card = sortedCardsArr[i];
               defenderCardSupportLane = null;
               defenderCardAttackLane = null;
               lastAttackingCardWasOnSameCol = false;
               eligibleToAttackCardsArr = card.getEligibleToAttackCards();
               if(eligibleToAttackCardsArr != null)
               {
                  defenderCardAttackLane = card.getAttackableCard(true,eligibleToAttackCardsArr);
                  defenderCardSupportLane = card.getAttackableCard(false,eligibleToAttackCardsArr);
               }
               allowedToAttackFromCurrPos = card.canAttackFromCurrentPosition();
               if(allowedToAttackFromCurrPos)
               {
                  if(defenderCardAttackLane != null)
                  {
                     handleAttackingLanes(card,defenderCardAttackLane,true);
                  }
                  if(defenderCardAttackLane == null && defenderCardSupportLane != null)
                  {
                     handleAttackingLanes(card,defenderCardSupportLane,false);
                  }
                  if(defenderCardAttackLane == null && defenderCardSupportLane == null)
                  {
                     if(cardsAttackingPlayerDirectly == null)
                     {
                        cardsAttackingPlayerDirectly = new Array();
                     }
                     card.setIsAttacking(true,null);
                     cardsAttackingPlayerDirectly.push(card);
                     hasFortification = card.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_FORTIFICATION) != null;
                     if(!hasFortification)
                     {
                        cardDamageToPlayer.value = card.getDamage();
                        cardDamageToPlayer.value += this.getExtraDamageIfHeroAbility(card);
                        attackerHasMachineGun = card.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_MACHINEGUN) != null;
                        attackerHasMachineGunPlus = card.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_MACHINEGUN_PLUS) != null;
                        attackerHasMachineGun4 = card.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_MACHINEGUN_4) != null;
                        if(attackerHasMachineGun)
                        {
                           cardDamageToPlayer.value *= 2;
                           FSDebug.debugTrace("MachineGun execute");
                        }
                        else if(attackerHasMachineGunPlus)
                        {
                           cardDamageToPlayer.value *= 3;
                           FSDebug.debugTrace("MachineGunPlus execute");
                        }
                        else if(attackerHasMachineGun4)
                        {
                           cardDamageToPlayer.value *= 4;
                           FSDebug.debugTrace("MachineGun_4 execute");
                        }
                        directDamageToPlayer.value += cardDamageToPlayer.value;
                     }
                  }
               }
               i++;
            }
         }
         if(Config.TRACE_BATTLE_LOGS)
         {
            FSDebug.debugTrace("Calling checkCardsKilledInCombat in: " + attackCounter + " seconds");
         }
         if(attackCounter != 0)
         {
            TweenMax.delayedCall(attackCounter,this.checkCardsKilledInCombat);
            if(Config.TRACE_BATTLE_LOGS)
            {
               FSDebug.debugTrace("Card dead extra secs?: " + Config.getConfig().getDefaultDeathAnimDuration() + " seconds");
            }
            attackCounter += Config.getConfig().getDefaultDeathAnimDuration();
         }
         attackCounter += Config.getConfig().getDefaultZoomOutTime();
         if(directDamageToPlayer.value > 0)
         {
            FSDebug.debugTrace("[onAttackState#6] directDamageToPlayer.value: " + directDamageToPlayer.value);
            TweenMax.delayedCall(attackCounter,this.attackPlayerDirectly,[cardsAttackingPlayerDirectly,directDamageToPlayer]);
         }
         else
         {
            FSDebug.debugTrace("Changing state in: " + attackCounter.toString() + " seconds, currentState: " + this.getBattleStateId());
            TweenMax.delayedCall(attackCounter,this.changePlayersState);
         }
      }
      
      private function attackAnimation(param1:FSUnit) : void
      {
         this.mBattleScreen.performAttackAnimation(param1);
      }
      
      public function isCardEligibleToBeZoomedOutAfterCombat(param1:FSCard) : Boolean
      {
         return param1 && param1.getShadow() != null && param1.getShadow().visible && param1.getDamage() <= 0 && !param1.isZoomingOut();
      }
      
      public function checkCardsKilledInCombat(param1:Boolean = false) : void
      {
         var _loc4_:FSCard = null;
         var _loc2_:Dictionary = this.mOwnerBattleInfo ? this.mOwnerBattleInfo.getFightCards() : null;
         var _loc3_:Dictionary = this.mOpponentBattleInfo ? this.mOpponentBattleInfo.getFightCards() : null;
         if(_loc2_)
         {
            for each(_loc4_ in _loc2_)
            {
               if(param1 || _loc4_.getFightingWithCard() != null || this.getBattleStateId() == BATTLE_STATE_DEALING_CARDS && _loc4_.isAttacking() || this.isCardEligibleToBeZoomedOutAfterCombat(_loc4_))
               {
                  FSDebug.debugTrace("Zooming out owner bf card");
                  SpecialFX.zoomOut(_loc4_,Config.getConfig().getDefaultZoomOutTime(),false);
               }
               _loc4_.setIsAttacking(false,null);
            }
         }
         if(_loc3_)
         {
            for each(_loc4_ in _loc3_)
            {
               if(param1 || _loc4_.getFightingWithCard() != null || this.getBattleStateId() == BATTLE_STATE_DEALING_CARDS && _loc4_.isAttacking() || this.isCardEligibleToBeZoomedOutAfterCombat(_loc4_))
               {
                  SpecialFX.zoomOut(_loc4_,Config.getConfig().getDefaultZoomOutTime(),false);
               }
               _loc4_.setIsAttacking(false,null);
            }
         }
      }
      
      public function isAnyCardDead() : Boolean
      {
         var _loc4_:FSCard = null;
         var _loc1_:Boolean = false;
         var _loc2_:Dictionary = this.mOwnerBattleInfo.getFightCards();
         var _loc3_:Dictionary = this.mOpponentBattleInfo.getFightCards();
         for each(_loc4_ in _loc2_)
         {
            if(!_loc4_.isAlive())
            {
               return true;
            }
         }
         for each(_loc4_ in _loc3_)
         {
            if(!_loc4_.isAlive())
            {
               return true;
            }
         }
         return _loc1_;
      }
      
      public function onOpponentCardDefeatedTrackScore(param1:FSUnit) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         if(param1 != null)
         {
            _loc3_ = param1.getCardDef().getTier();
            _loc4_ = param1.hasAttachments();
            switch(_loc3_)
            {
               case 1:
                  _loc2_ = _loc4_ ? ScoreMng.DESTROY_UNIT_TIER_1_WITH_ATTACHMENT : ScoreMng.DESTROY_UNIT_TIER_1;
                  break;
               case 2:
                  _loc2_ = _loc4_ ? ScoreMng.DESTROY_UNIT_TIER_2_WITH_ATTACHMENT : ScoreMng.DESTROY_UNIT_TIER_2;
                  break;
               case 3:
                  _loc2_ = _loc4_ ? ScoreMng.DESTROY_UNIT_TIER_3_WITH_ATTACHMENT : ScoreMng.DESTROY_UNIT_TIER_3;
            }
            InstanceMng.getScoreMng().trackAction(_loc2_);
         }
      }
      
      private function attackAttackLane(param1:FSCard, param2:FSCard) : void
      {
         if(param2 != null)
         {
            this.performAttackOnCard(param1,param2);
         }
      }
      
      private function attackSupportLane(param1:FSCard, param2:FSCard) : void
      {
         if(param2 != null)
         {
            this.performAttackOnCard(param1,param2);
         }
      }
      
      private function attackPlayerDirectly(param1:Array, param2:FSNumber, param3:Boolean = false, param4:Boolean = false, param5:FSCard = null) : void
      {
         var _loc7_:int = 0;
         var _loc8_:FSCard = null;
         var _loc9_:CardAnimation = null;
         var _loc6_:UserBattleInfo = !this.mIsOwnerTurn ? this.mOpponentBattleInfo : this.mOwnerBattleInfo;
         if(_loc6_ != null)
         {
            if(Config.getConfig().battlePerformAttackLogicOnTargetReached() && !param4)
            {
               if(param1 != null)
               {
                  _loc7_ = 0;
                  _loc7_ = 0;
                  while(_loc7_ < param1.length)
                  {
                     _loc8_ = param1[_loc7_];
                     if(_loc7_ == param1.length - 1)
                     {
                        FSDebug.debugTrace("[attackPlayerDirectly#1] Damage: " + param2.value);
                        _loc8_.performAttackMovement(true,this.onPlayerTargetReachedPerformLogicOps,[param1,param2,param3],this.takeCardsInBattleToTheGround);
                     }
                     else
                     {
                        _loc8_.performAttackMovement(true);
                     }
                     _loc7_++;
                  }
               }
            }
            else
            {
               FSDebug.debugTrace("[attackPlayerDirectly#2] Damage: " + param2.value);
               this.onPlayerTargetReachedPerformLogicOps(param1,param2,param3,true,param5);
            }
            _loc6_.executePassive();
         }
      }
      
      private function onPlayerTargetReachedPerformLogicOps(param1:Array, param2:FSNumber, param3:Boolean = false, param4:Boolean = false, param5:FSCard = null) : void
      {
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:int = 0;
         var _loc10_:FSNumber = null;
         var _loc11_:int = 0;
         var _loc12_:FSNumber = null;
         var _loc13_:FSCard = null;
         var _loc14_:Boolean = false;
         var _loc15_:Boolean = false;
         var _loc16_:Boolean = false;
         var _loc17_:Boolean = false;
         var _loc18_:Boolean = false;
         var _loc19_:String = null;
         var _loc20_:Number = NaN;
         var _loc21_:int = 0;
         var _loc22_:FSCard = null;
         var _loc23_:CardAnimation = null;
         FSDebug.debugTrace("[onPlayerTargetReachedPerformLogicOps] Damage: " + param2.value);
         var _loc6_:UserBattleInfo = this.mIsOwnerTurn ? this.mOpponentBattleInfo : this.mOwnerBattleInfo;
         if(_loc6_ != null)
         {
            _loc7_ = _loc6_.getInvulnerableTurns() > 0;
            _loc8_ = !this.mIsOwnerTurn && this.mTurnsWithoutTakingDamage > 0;
            if((_loc8_) || _loc7_)
            {
               if(Boolean(_loc8_) && Boolean(this.mBattleScreen) && Boolean(this.mBattleScreen.getOwnerPortrait()))
               {
                  this.mBattleScreen.getOwnerPortrait().performInvulnerableAnim();
               }
               TweenMax.delayedCall(Config.getConfig().getDefaultAttackPortraitAnimDuration(),this.checkIfBattleOver,[!param3]);
            }
            else
            {
               _loc9_ = _loc6_.getHP() - param2.value;
               _loc10_ = new FSNumber(param2.value * -1);
               _loc6_.modifyHP(_loc10_,param3);
               if(Boolean(this.mLevelDef && _loc9_ <= int(this.mLevelDef.getHP() * 0.5)) && Boolean(_loc6_.isOwnerBattleInfo()) && Boolean(this.mBattleScreen))
               {
                  this.mBattleScreen.showBloodScreenEffect();
               }
               if(param1)
               {
                  _loc12_ = new FSNumber();
                  _loc11_ = 0;
                  while(_loc11_ < param1.length)
                  {
                     _loc12_.value = 0;
                     _loc13_ = param1[_loc11_] as FSCard;
                     if(_loc13_)
                     {
                        this.storeCombatLogAction(COMBAT_LOG_CARD_ATTACK_PLAYER,_loc13_,"",{
                           "DMG":_loc13_.getDamage(),
                           "TOTAL DAMAGE":_loc10_.value * -1
                        });
                        if(_loc13_.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_LEECH) != null)
                        {
                           _loc12_.value = _loc13_.getDamage();
                           _loc14_ = false;
                           _loc15_ = _loc13_.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_MACHINEGUN) != null;
                           _loc16_ = _loc13_.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_MACHINEGUN_PLUS) != null;
                           _loc17_ = _loc13_.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_MACHINEGUN_4) != null;
                           if(_loc15_)
                           {
                              _loc14_ = true;
                              _loc12_.value *= 2;
                           }
                           else if(_loc16_)
                           {
                              _loc14_ = true;
                              _loc12_.value *= 3;
                           }
                           else if(_loc17_)
                           {
                              _loc14_ = true;
                              _loc12_.value *= 4;
                           }
                           this.storeCombatLogAction(COMBAT_LOG_CARD_ATTACK_PLAYER,null,"",{"[LEECH]":"(" + _loc12_ + ") " + _loc13_.getCardDef().getName(false,true) + " (" + _loc13_.getDamage() + "/" + _loc13_.getDefense() + ") | Has MachineGun? => " + _loc14_.toString()});
                           if(this.mIsOwnerTurn && Boolean(this.mOwnerBattleInfo))
                           {
                              this.mOwnerBattleInfo.modifyHP(_loc12_,true);
                           }
                           else if(this.mOpponentBattleInfo)
                           {
                              this.mOpponentBattleInfo.modifyHP(_loc12_,true);
                           }
                        }
                     }
                     _loc11_++;
                  }
               }
               else if(param1 == null && param3 && Boolean(param5))
               {
                  _loc18_ = param5.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_LEECH) != null;
                  _loc19_ = _loc18_ ? "[BRUTALITY+LEECH]" : "[BRUTALITY]";
                  this.storeCombatLogAction(COMBAT_LOG_CARD_ATTACK_PLAYER,null,"",{"preffix":" (" + param2.value + ") " + param5.getCardDef().getName(false,true) + " (" + param5.getDamage() + "/" + param5.getDefense() + ")"});
                  if(_loc18_)
                  {
                     if(this.mIsOwnerTurn && Boolean(this.mOwnerBattleInfo))
                     {
                        this.mOwnerBattleInfo.modifyHP(param2,true);
                     }
                     else if(this.mOpponentBattleInfo)
                     {
                        this.mOpponentBattleInfo.modifyHP(param2,true);
                     }
                  }
               }
            }
            if(Config.getConfig().battlePerformAttackLogicOnTargetReached())
            {
               _loc20_ = param2.value >= Config.getConfig().battleGetActivateSFXAttackValue() ? 5 : 1.5;
               Utils.requestScreenShake(0.5,_loc20_);
            }
            if(param1 != null)
            {
               _loc21_ = 0;
               _loc21_ = 0;
               while(_loc21_ < param1.length)
               {
                  _loc22_ = param1[_loc21_];
                  _loc23_ = InstanceMng.getCardAnimsMng().requestCardAnimDamageDealed(_loc22_);
                  if(param4)
                  {
                     _loc22_.performAttackMovement(true,null,null,this.takeCardsInBattleToTheGround);
                  }
                  if(_loc23_ != null)
                  {
                     if(_loc8_)
                     {
                        _loc23_.setup(_loc6_.getUserBattlePortrait().getInvulnerableSprite());
                     }
                     else
                     {
                        _loc23_.setup(_loc6_.getUserBattlePortrait().getFrameContainer());
                     }
                  }
                  _loc21_++;
               }
            }
         }
      }
      
      private function takeCardsInBattleToTheGround() : void
      {
         var _loc1_:Dictionary = null;
         var _loc2_:Dictionary = null;
         var _loc3_:FSCard = null;
         if(Boolean(this.mOwnerBattleInfo) && Boolean(this.mOpponentBattleInfo))
         {
            _loc1_ = this.mOwnerBattleInfo.getFightCards();
            _loc2_ = this.mOpponentBattleInfo.getFightCards();
            for each(_loc3_ in _loc1_)
            {
               if(_loc3_.getFightingWithCard() != null || this.getBattleStateId() == BATTLE_STATE_DEALING_CARDS && _loc3_.isAttacking() || _loc3_.getShadow() != null)
               {
                  SpecialFX.zoomOut(_loc3_);
               }
            }
            for each(_loc3_ in _loc2_)
            {
               if(_loc3_.getFightingWithCard() != null || this.getBattleStateId() == BATTLE_STATE_DEALING_CARDS && _loc3_.isAttacking() || _loc3_.getShadow() != null)
               {
                  SpecialFX.zoomOut(_loc3_);
               }
            }
         }
      }
      
      public function checkIfBattleOver(param1:Boolean = true) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         if(this.getBattleStateId() != BATTLE_STATE_BATTLE_OVER)
         {
            _loc2_ = false;
            _loc3_ = InstanceMng.getTargetMng().canPlayerKeepPlaying();
            if(!_loc3_)
            {
               this.setBattleStateId(BATTLE_STATE_BATTLE_OVER);
            }
            if(Boolean(this.mOwnerBattleInfo) && !this.mOwnerBattleInfo.isAlive())
            {
               _loc2_ = false;
               this.mOwnerBattleInfo.setHP(new FSNumber());
               this.setBattleStateId(BATTLE_STATE_BATTLE_OVER);
            }
            else if(Boolean(this.mOpponentBattleInfo) && !this.mOpponentBattleInfo.isAlive())
            {
               _loc2_ = true;
               this.mOpponentBattleInfo.setHP(new FSNumber());
               this.setBattleStateId(BATTLE_STATE_BATTLE_OVER);
               if(this.mBattleScreen)
               {
                  this.mBattleScreen.updateObjectivesProgress();
               }
            }
            if(param1 || this.getBattleStateId() == BATTLE_STATE_BATTLE_OVER)
            {
               if(this.getBattleStateId() == BATTLE_STATE_BATTLE_OVER && this.isOnlineMatch() && !PvPConnectionMng.isPlayingVSAI())
               {
                  if(!this.isOwnerTurn())
                  {
                     PvPConnectionMng.setMatchAsFinished("",_loc2_,false);
                  }
                  else
                  {
                     PvPConnectionMng.packageSaveObjForSending();
                  }
               }
               this.changePlayersState();
            }
         }
      }
      
      private function performAttackOnCard(param1:FSCard, param2:FSCard) : void
      {
         var _loc3_:Number = NaN;
         if(Config.getConfig().battlePerformAttackLogicOnTargetReached())
         {
            TweenMax.delayedCall(0,this.performAttackOnCardStep2,[param1,param2]);
            _loc3_ = Config.getConfig().getDefaultReachTargetTransitionTime();
            TweenMax.delayedCall(_loc3_,this.triggerCardAbilities,[param2]);
            TweenMax.delayedCall(_loc3_,this.triggerCardAbilities,[param1]);
         }
         else
         {
            this.triggerCardAbilities(param2);
            this.triggerCardAbilities(param1);
            this.performAttackOnCardStep2(param1,param2);
         }
         if(this.isOwnerTurn())
         {
            this.mOwnerBattleInfo.executePassive();
         }
         else if(this.isPvPMatch())
         {
            this.mOpponentBattleInfo.executePassive();
         }
      }
      
      private function performAttackOnCardStep2(param1:FSCard, param2:FSCard) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:Number = NaN;
         if(Boolean(param1) && Boolean(param2))
         {
            _loc3_ = FSUnit(param1).isArtillery() && param1.isOnSupportLane();
            _loc4_ = param1.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_SNIPER) != null;
            _loc5_ = param2.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_SNIPER) != null;
            _loc6_ = _loc4_ && !_loc5_ || !_loc4_ && _loc5_;
            if(_loc6_)
            {
               _loc7_ = Config.getConfig().getDefaultReachTargetTransitionTime();
               if(_loc4_)
               {
                  this.onAttackPerformOps(param1,param2,true);
                  if(Config.getConfig().battlePerformAttackLogicOnTargetReached())
                  {
                     TweenMax.delayedCall(_loc7_,this.checkIfAttackSniperHasToReceiveDamageBack,[param1,param2,_loc3_]);
                  }
                  else
                  {
                     this.checkIfAttackSniperHasToReceiveDamageBack(param1,param2,_loc3_);
                  }
               }
               else
               {
                  if(!_loc3_)
                  {
                     this.onAttackPerformOps(param2,param1,false);
                  }
                  if(Config.getConfig().battlePerformAttackLogicOnTargetReached())
                  {
                     TweenMax.delayedCall(_loc7_,this.checkIfDefenderSniperHasToReceiveDamageBack,[param1,param2,_loc3_]);
                  }
                  else
                  {
                     this.checkIfDefenderSniperHasToReceiveDamageBack(param1,param2,_loc3_);
                  }
               }
            }
            else
            {
               this.onAttackPerformOps(param1,param2,true);
               if(!_loc3_)
               {
                  this.onAttackPerformOps(param2,param1,false);
               }
            }
         }
      }
      
      private function checkIfAttackSniperHasToReceiveDamageBack(param1:FSCard, param2:FSCard, param3:Boolean) : void
      {
         if(Boolean(param2) && param2.getDefense() > 0)
         {
            if(!param3)
            {
               this.onAttackPerformOps(param2,param1,false,true);
            }
         }
      }
      
      private function checkIfDefenderSniperHasToReceiveDamageBack(param1:FSCard, param2:FSCard, param3:Boolean) : void
      {
         FSDebug.debugTrace("CHECKING IF DEFENDER SNIPER HAS TO RECEIVE DAMAGE BACK");
         if(Boolean(param1) && param1.getDefense() > 0)
         {
            this.onAttackPerformOps(param1,param2,true,true);
         }
      }
      
      private function onAttackPerformOps(param1:FSCard, param2:FSCard, param3:Boolean, param4:Boolean = false) : void
      {
         var _loc5_:Boolean = param1.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_FORTIFICATION) != null;
         var _loc6_:Boolean = param2.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_FORTIFICATION) != null;
         if(_loc5_ && param3 || _loc6_ && !param3)
         {
            return;
         }
         if(Config.getConfig().battlePerformAttackLogicOnTargetReached() && !param4)
         {
            param1.performAttackMovement(param3,this.performAttackLogic,[param1,param2,param3]);
         }
         else
         {
            this.performAttackLogic(param1,param2,param3);
            param1.performAttackMovement(param3);
         }
      }
      
      private function performAttackLogic(param1:FSCard, param2:FSCard, param3:Boolean) : void
      {
         var _loc7_:int = 0;
         var _loc13_:Boolean = false;
         var _loc14_:FSNumber = null;
         var _loc4_:int = this.calculateSpecialCardDamage(param1,param2);
         var _loc5_:int = param2.getDefense();
         var _loc6_:Boolean = FSUnit(param2).getInvulnerableTurns() > 0;
         if(_loc6_)
         {
            _loc7_ = param2.getDefense();
         }
         else
         {
            _loc7_ = _loc5_ - _loc4_ > 0 ? int(_loc5_ - _loc4_) : 0;
         }
         this.storeCombatLogAction(COMBAT_LOG_CARD_ATTACK,null,"",{
            "ATTACKER":"Card: (" + param1.getCardDef().getSku() + ") " + param1.getCardDef().getName(false,true) + " ***HITS*** [" + _loc4_ + "]",
            "DEFENDER":"Card: (" + param2.getCardDef().getSku() + ") " + param2.getCardDef().getName(false,true)
         });
         var _loc8_:String = _loc4_ != 0 && !_loc6_ ? "-" + _loc4_.toString() : "-0";
         var _loc9_:String = _loc4_ >= Config.getConfig().battleGetActivateSFXAttackValue() ? "high_damage_icon" : "damage_icon";
         InstanceMng.getTextParticlesMng().showTextParticleOnBattle(_loc8_,TextParticlesMng.COLOR_DAMAGE_RECEIVED_STD,param2,-1,Align.RIGHT,Align.CENTER,"",_loc9_);
         var _loc10_:CardAnimation = InstanceMng.getCardAnimsMng().requestCardAnimDamageDealed(param1);
         if(!_loc6_)
         {
            if(_loc10_)
            {
               _loc10_.setup(param2);
               param2.addCardAnim(_loc10_);
            }
         }
         var _loc11_:Boolean = param1.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_SNIPER) != null;
         var _loc12_:Number = _loc10_ != null && _loc10_ is BulletsAnim && !_loc11_ ? BulletsAnim(_loc10_).getAmmoSpeed() : 0;
         param2.updateStatsAfterAttack(_loc7_,_loc12_);
         if(_loc7_ == 0 && param3)
         {
            _loc13_ = param1.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_BRUTALITY) != null;
            if(_loc13_)
            {
               _loc14_ = new FSNumber(_loc4_ - _loc5_);
               if(_loc14_.value > 0)
               {
                  this.attackPlayerDirectly(null,_loc14_,true,true,param1);
               }
            }
         }
         if(_loc4_ >= Config.getConfig().battleGetActivateSFXAttackValue())
         {
            Utils.requestScreenShake(0.5,5);
         }
      }
      
      private function calculateSpecialCardDamage(param1:FSCard, param2:FSCard) : int
      {
         var _loc3_:int = param2.getExtraDefenseGainedByAbilities(param1);
         var _loc4_:int = param1.getDamage();
         if(_loc3_ > 0)
         {
            _loc4_ = _loc4_ - _loc3_ > 0 ? int(_loc4_ - _loc3_) : 0;
         }
         _loc4_ += this.getExtraDamageIfHeroAbility(param1);
         var _loc5_:Boolean = param1.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_MACHINEGUN) != null;
         var _loc6_:Boolean = param1.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_MACHINEGUN_PLUS) != null;
         var _loc7_:Boolean = param1.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_MACHINEGUN_4) != null;
         if(_loc5_ && param1.isAttacking())
         {
            _loc4_ *= 2;
            FSDebug.debugTrace("MachineGun execute");
         }
         else if(_loc6_ && param1.isAttacking())
         {
            _loc4_ *= 3;
            FSDebug.debugTrace("MachineGunPlus execute");
         }
         else if(_loc7_ && param1.isAttacking())
         {
            _loc4_ *= 4;
            FSDebug.debugTrace("MachineGun_4 execute");
         }
         return _loc4_;
      }
      
      private function getExtraDamageIfHeroAbility(param1:FSCard) : int
      {
         var _loc3_:Ability = null;
         var _loc4_:AbilityDef = null;
         var _loc2_:int = 0;
         _loc4_ = AbilityDef(param1.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_AMERICANHERO));
         _loc2_ += this.getDamageByHeroAbility(param1,_loc4_);
         _loc4_ = AbilityDef(param1.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_GERMANHERO));
         _loc2_ += this.getDamageByHeroAbility(param1,_loc4_);
         _loc4_ = AbilityDef(param1.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_RUSSIANHERO));
         _loc2_ += this.getDamageByHeroAbility(param1,_loc4_);
         _loc4_ = AbilityDef(param1.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_JAPANESEHERO));
         return int(_loc2_ + this.getDamageByHeroAbility(param1,_loc4_));
      }
      
      private function getDamageByHeroAbility(param1:FSCard, param2:AbilityDef) : int
      {
         var _loc4_:Ability = null;
         var _loc3_:int = 0;
         if(param2 != null)
         {
            _loc4_ = param1.getAbilityByAbSku(param2.getSku(),true);
            if(_loc4_ != null)
            {
               if(_loc4_.getAbilityDef().isCardEligibleForAbility(param1))
               {
                  _loc3_ = param2.getDamage();
               }
            }
         }
         return _loc3_;
      }
      
      public function getBFCardsByColumnIndex(param1:int, param2:Dictionary) : Array
      {
         var _loc3_:Array = null;
         var _loc4_:FSCard = null;
         if(param2 != null)
         {
            _loc3_ = new Array();
            for each(_loc4_ in param2)
            {
               if(Boolean(_loc4_) && Boolean(_loc4_.getAttachedToSocket()) && _loc4_.getAttachedToSocket().getBFCoords().getY() == param1)
               {
                  _loc3_.push(_loc4_);
               }
            }
         }
         return _loc3_;
      }
      
      public function performSupportToAttackMovement(param1:Boolean = false, param2:Dictionary = null) : void
      {
         var _loc3_:FSCardSocket = null;
         var _loc4_:FSCard = null;
         var _loc5_:Dictionary = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc9_:Function = null;
         var _loc11_:int = 0;
         var _loc12_:FSCoordinate = null;
         var _loc13_:Number = NaN;
         FSDebug.debugTrace("Performing support to attack movement");
         var _loc8_:Boolean = false;
         var _loc10_:UserBattleInfo = this.mIsOwnerTurn ? this.mOwnerBattleInfo : this.mOpponentBattleInfo;
         if(param2 == null)
         {
            _loc5_ = this.getMovableToAttackLaneCards(_loc10_,param1);
         }
         else
         {
            _loc11_ = 0;
            for each(_loc4_ in param2)
            {
               if(_loc4_.isMovableToAttackLane(param1))
               {
                  if(_loc5_ == null)
                  {
                     _loc5_ = new Dictionary(true);
                  }
                  _loc5_[_loc11_] = _loc4_;
                  _loc11_++;
               }
               _loc7_ = _loc11_;
            }
         }
         _loc6_ = DictionaryUtils.getDictionaryLength(_loc5_);
         for each(_loc4_ in _loc5_)
         {
            _loc8_ = true;
            _loc3_ = _loc4_.getEmptyAttackSocketForSupportCard();
            _loc4_.setAttachedToSocket(_loc3_,true,false,param1);
            if(_loc7_ == _loc6_ - 1)
            {
               if(!param1 && _loc7_ == _loc6_ - 1)
               {
                  _loc9_ = this.changePlayersState;
               }
               else
               {
                  _loc9_ = null;
               }
            }
            _loc12_ = _loc3_.getVisualComponentCoords();
            if(FSUnit(_loc4_).isAirUnit())
            {
               _loc4_.requestShowShadow();
               _loc13_ = _loc4_.getTransitionCardTime(FSCard.DEFAULT_ELEVATE_CARD_FOR_ATTACK_TIME);
               TweenMax.delayedCall(_loc13_,SpecialFX.zoomOut,[_loc4_]);
               if(_loc9_ != null)
               {
                  TweenMax.delayedCall(Config.getConfig().getDefaultZoomOutTime() + _loc13_,_loc9_);
               }
               _loc4_.activateDropShadow(false);
            }
            else
            {
               SpecialFX.createTransition(_loc4_,_loc12_,Config.getConfig().getDefaultZoomOutTime(),0,_loc9_);
               if(_loc4_.getCardDropShadow())
               {
                  SpecialFX.createTransition(_loc4_.getCardDropShadow(),_loc12_,Config.getConfig().getDefaultZoomOutTime(),0);
               }
            }
            _loc7_++;
         }
         if(_loc7_ > 0)
         {
            Utils.playSound(Constants.SOUND_SUPPORT_TO_ATTACK,SoundManager.TYPE_SFX);
         }
         if(_loc8_ == false && !param1)
         {
            this.changePlayersState();
         }
      }
      
      private function getMovableToAttackLaneCards(param1:UserBattleInfo, param2:Boolean = false) : Dictionary
      {
         var _loc3_:FSCard = null;
         var _loc6_:int = 0;
         var _loc4_:Dictionary = param1.getFightCards();
         var _loc5_:Dictionary = new Dictionary(true);
         for each(_loc3_ in _loc4_)
         {
            if(_loc3_.isMovableToAttackLane(param2))
            {
               _loc5_[_loc6_] = _loc3_;
               _loc6_++;
            }
         }
         return _loc5_;
      }
      
      private function getMovableFromAttackToSupportLaneCards(param1:UserBattleInfo) : Dictionary
      {
         var _loc2_:FSCard = null;
         var _loc5_:int = 0;
         var _loc3_:Dictionary = param1.getFightCards();
         var _loc4_:Dictionary = new Dictionary(true);
         for each(_loc2_ in _loc3_)
         {
            if(_loc2_.isMovableFromAttackLaneToSupportLane())
            {
               _loc4_[_loc5_] = _loc2_;
               _loc5_++;
            }
         }
         return _loc4_;
      }
      
      public function isCardAttachableToSocket(param1:FSCard, param2:FSCardSocket, param3:Boolean = false) : Boolean
      {
         return param1.isCardAttachableToSocket(param2,param3);
      }
      
      public function enableBFCards(param1:Boolean, param2:Vector.<FSCardSocket> = null) : void
      {
         var _loc3_:Dictionary = null;
         var _loc4_:FSCard = null;
         var _loc5_:FSCardSocket = null;
         _loc3_ = this.mOwnerBattleInfo.getFightCards();
         for each(_loc4_ in _loc3_)
         {
            _loc4_.touchable = param1;
         }
         _loc3_ = this.mOpponentBattleInfo.getFightCards();
         for each(_loc4_ in _loc3_)
         {
            _loc4_.touchable = param1;
         }
         if(param2 != null)
         {
            for each(_loc5_ in param2)
            {
               _loc5_.touchable = true;
               if(_loc5_.getParentCard() != null)
               {
                  _loc5_.getParentCard().touchable = true;
               }
            }
         }
      }
      
      public function enableSideDeck(param1:Boolean, param2:Dictionary = null, param3:Boolean = false) : void
      {
         var _loc4_:FSCardSocket = null;
         if(this.mBattleScreen != null)
         {
            param2 = param2 == null ? this.mBattleScreen.getOwnerSideDeckSocketCatalog() : param2;
            for each(_loc4_ in param2)
            {
               if(_loc4_.getParentCard() != null && _loc4_.getParentCard().isMoving() && !param1 && param3)
               {
                  _loc4_.getParentCard().setCardPressedAndMoving(false);
                  _loc4_.getParentCard().onNoIntersectionFound();
                  _loc4_.getParentCard().removeTouchEventListeners();
               }
               _loc4_.touchable = param1;
               if(_loc4_.getParentCard() != null)
               {
                  _loc4_.getParentCard().touchable = param1;
               }
            }
         }
      }
      
      public function enableSacrificeButton(param1:Boolean) : void
      {
         var _loc2_:FSImage = null;
         var _loc3_:FSImage = null;
         if(this.mBattleScreen != null)
         {
            _loc2_ = this.mBattleScreen.getOwnerSacrificeButton();
            if(_loc2_ != null)
            {
               _loc2_.touchable = param1;
            }
            _loc3_ = this.mBattleScreen.getOpponentSacrificeButton();
            if(_loc3_ != null)
            {
               _loc3_.touchable = param1;
            }
         }
      }
      
      public function enableOwnerPowerButton(param1:Boolean, param2:Boolean = false) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:FSImage = null;
         if(this.mBattleScreen != null)
         {
            if(Boolean(param1) && Boolean(this.mOwnerBattleInfo) && !this.mOwnerBattleInfo.isPowerAvailable())
            {
               return;
            }
            _loc3_ = this.mBattleScreen.getOwnerPowerButton();
            if(_loc3_ != null)
            {
               _loc3_.touchable = param1;
            }
            _loc4_ = this.mBattleScreen.getOwnerPowerImage();
            if(_loc4_)
            {
               if(!param2)
               {
                  _loc4_.texture = param1 ? Root.assets.getTexture("power_icon_on") : Root.assets.getTexture("power_icon_off");
               }
               this.mOwnerPowerIsActive = param1;
            }
            if(!param1)
            {
               this.mBattleScreen.suggestOwnerPower(param1);
            }
         }
      }
      
      public function enableOpponentPowerButton(param1:Boolean, param2:Boolean = false) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:FSImage = null;
         if(Boolean(param1) && Boolean(this.mOpponentBattleInfo) && !this.mOpponentBattleInfo.isPowerAvailable())
         {
            return;
         }
         if(this.mBattleScreen != null)
         {
            _loc3_ = this.mBattleScreen.getOpponentPowerButton();
            if(_loc3_ != null)
            {
               _loc3_.touchable = param1;
            }
            _loc4_ = this.mBattleScreen.getOpponentPowerImage();
            if(_loc4_)
            {
               if(!param2)
               {
                  _loc4_.texture = param1 ? Root.assets.getTexture("power_icon_on") : Root.assets.getTexture("power_icon_off");
               }
               this.mOpponentPowerIsActive = param1;
            }
            if(!param1)
            {
               this.mBattleScreen.suggestOpponentPower(param1);
            }
         }
      }
      
      public function resetUILock() : void
      {
         this.setAbilityWaitingForTarget(null,null,null);
         if(this.mIsOwnerTurn)
         {
            this.enableAttackButton();
         }
         this.enableSideDeck(true);
         this.enableBFCards(true);
         if(Config.getConfig().gameHasSacrifice())
         {
            this.enableSacrificeButton(true);
         }
         if(Config.getConfig().gameHasPowers())
         {
            this.enableOwnerPowerButton(true,true);
            this.enableOpponentPowerButton(true,true);
         }
         this.mAbilityLockedUI = false;
      }
      
      public function abilityPickingLockUI() : void
      {
         this.mAbilityLockedUI = true;
         this.enableBFCards(false);
         FSDebug.debugTrace("ability picking lock ui");
         this.enableSideDeck(false);
         this.disableAttackButton();
         if(Config.getConfig().gameHasSacrifice())
         {
            this.enableSacrificeButton(false);
         }
         if(Config.getConfig().gameHasPowers())
         {
            this.enableOwnerPowerButton(false);
            this.enableOpponentPowerButton(false);
         }
      }
      
      public function getBattleStateId() : int
      {
         return this.mBattleStateId ? int(this.mBattleStateId.value) : 0;
      }
      
      public function setBattleStateId(param1:int) : void
      {
         if(this.mBattleStateId == null)
         {
            this.mBattleStateId = new FSNumber();
         }
         this.mBattleStateId.value = param1;
      }
      
      public function getPlayersStateId() : int
      {
         return this.mPlayersStateId;
      }
      
      public function setPlayersStateId(param1:int) : void
      {
         this.mPlayersStateId = param1;
      }
      
      public function getOwnerBattleInfo() : UserBattleInfo
      {
         return this.mOwnerBattleInfo;
      }
      
      public function setOwnerBattleInfo(param1:UserBattleInfo) : void
      {
         this.mOwnerBattleInfo = param1;
      }
      
      public function getOpponentBattleInfo() : UserBattleInfo
      {
         return this.mOpponentBattleInfo;
      }
      
      public function setOpponentBattleInfo(param1:UserBattleInfo) : void
      {
         this.mOpponentBattleInfo = param1;
      }
      
      public function getBattleScreen() : FSBattleScreen
      {
         return this.mBattleScreen;
      }
      
      public function setBattleScreen(param1:FSBattleScreen) : void
      {
         this.mBattleScreen = param1;
      }
      
      public function getLevelDef() : LevelDef
      {
         return this.mLevelDef;
      }
      
      public function setLevelDef(param1:LevelDef) : void
      {
         this.mLevelDef = param1;
      }
      
      public function isOwnerTurn() : Boolean
      {
         return this.mIsOwnerTurn;
      }
      
      public function getAbilityLockedUI() : Boolean
      {
         return this.mAbilityLockedUI;
      }
      
      public function getCurrentTurnId(param1:Boolean = false) : int
      {
         return param1 ? this.mCurrentTurnId : int(this.mCurrentTurnId - this.mExtraTurnsBought);
      }
      
      public function getTurnsWithoutTakingDamage() : int
      {
         return this.mTurnsWithoutTakingDamage;
      }
      
      public function setTurnsWithoutTakingDamage(param1:int) : void
      {
         this.mTurnsWithoutTakingDamage = param1 > 0 ? param1 : 0;
         if(this.mBattleScreen)
         {
            this.mBattleScreen.showInvulnerableShield(this.mTurnsWithoutTakingDamage > 0);
         }
      }
      
      public function getNextHandDealTopCards() : Boolean
      {
         return this.mNextHandDealTopCards;
      }
      
      public function setNextHandDealTopCards(param1:Boolean) : void
      {
         if(param1)
         {
            Utils.setLogText(TextManager.getText("TID_BOOST_BEST_HAND"));
         }
         this.mNextHandDealTopCards = param1;
      }
      
      public function getNextHandIncreasesRank() : int
      {
         return this.mNextHandIncreasesRank;
      }
      
      public function setNextHandIncreasesRank(param1:int) : void
      {
         this.mNextHandIncreasesRank = param1;
      }
      
      public function getExtraTurnsBought() : int
      {
         return this.mExtraTurnsBought;
      }
      
      public function setExtraTurnsBought(param1:int) : void
      {
         this.mExtraTurnsBought += param1;
      }
      
      public function getNextStateId() : int
      {
         return this.mNextStateId ? int(this.mNextStateId.value) : 0;
      }
      
      public function setNextStateId(param1:int) : void
      {
         if(this.mNextStateId == null)
         {
            this.mNextStateId = new FSNumber();
         }
         this.mNextStateId.value = param1;
      }
      
      public function getWaitingForBannerAnimToIncreaseState() : Boolean
      {
         return this.mWaitingForBannerAnimToIncreaseState;
      }
      
      public function setWaitingForBannerAnimToIncreaseState(param1:Boolean) : void
      {
         this.mWaitingForBannerAnimToIncreaseState = param1;
      }
      
      public function getAIEngine() : AIBattleEngine
      {
         return this.mAIEngine;
      }
      
      public function canPerformUIActions() : Boolean
      {
         return this.getPlayersStateId() == STATE_OWNER_MOVING_CARDS && !this.mReshufflingHand;
      }
      
      public function getUserBattleInfoCatalog() : Dictionary
      {
         return this.mUserBattleInfoCatalog;
      }
      
      public function getAbilityWaitingForTarget() : Ability
      {
         return this.mAbilityWaitingForTarget;
      }
      
      public function setAbilityWaitingForTarget(param1:Ability, param2:Vector.<FSCardSocket>, param3:Vector.<UserBattleInfo>) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:Array = null;
         var _loc6_:ColorArgb = null;
         var _loc7_:ColorArgb = null;
         this.mAbilityWaitingForTarget = param1;
         if(this.mAbilityWaitingForTarget == null)
         {
            if(this.mBattleScreen)
            {
               this.mBattleScreen.showOwnerLockedDeckSocketsBG(false);
               if(this.isPvPMatch())
               {
                  if(this.mBattleScreen is FSBattleScreenPvP)
                  {
                     FSBattleScreenPvP(this.mBattleScreen).showOpponentLockedDeckSocketsBG(false);
                  }
               }
            }
         }
         else if(this.mAbilityWaitingForTarget.getParentCard().getParentUserBattleInfo())
         {
            this.mBattleScreen.disableFreeReshuffle(this.mAbilityWaitingForTarget.getParentCard().getParentUserBattleInfo());
         }
         if(!this.mIsOwnerTurn)
         {
            if(!this.isPvPMatch() || PvPConnectionMng.isPlayingVSAI())
            {
               if(this.mAIEngine)
               {
                  this.mAIEngine.setAbilityWaitingForTarget(this.mAbilityWaitingForTarget,param2,param3);
               }
            }
            else if(this.isOnlineMatch() && this.mAbilityWaitingForTarget != null && InstanceMng.getBattleEngine() is BattleEnginePvP)
            {
               if(InstanceMng.getBattleEngine() != null)
               {
                  if(this.isPowerWaitingForTarget())
                  {
                     _loc4_ = BattleEnginePvP(InstanceMng.getBattleEngine()).getPowerTargetBySaveObject(this.mIsOwnerTurn,param2,param3);
                     if(_loc4_ != null && Boolean(param1))
                     {
                        if(_loc4_ is Array)
                        {
                           param1.onTargetSelected(_loc4_);
                        }
                        else
                        {
                           _loc5_ = new Array();
                           _loc5_[0] = _loc4_;
                           param1.onTargetSelected(_loc5_);
                        }
                     }
                     else
                     {
                        param1.onTargetSelected(null);
                     }
                  }
                  else
                  {
                     BattleEnginePvP(InstanceMng.getBattleEngine()).getAbilityTargetBySaveObject(this.mIsOwnerTurn,param1.getParentCard().getId(),param1,param2,param3);
                  }
               }
            }
         }
         else if(InstanceMng.getLogPanel())
         {
            if(this.mAbilityWaitingForTarget != null)
            {
               _loc6_ = new ColorArgb(0.4,0.1,0.9,1);
               _loc7_ = new ColorArgb(0.4,0,0.9,0);
               InstanceMng.getLogPanel().activateSpecialHighlightParticle(_loc6_,_loc7_);
               if(Config.getConfig().battleGetVoiceOnError())
               {
                  Utils.playSound(Constants.SOUND_CHOOSE_TARGET,SoundManager.TYPE_SFX);
               }
            }
            else
            {
               InstanceMng.getLogPanel().deactivateSpecialHighlightParticle();
            }
         }
      }
      
      public function getActionUpgradeCostSelected() : int
      {
         return this.mActionUpgradeCostSelected;
      }
      
      public function setActionUpgradeCostSelected(param1:int) : void
      {
         this.mActionUpgradeCostSelected = param1;
      }
      
      public function hasToShowUpgradeCost() : Boolean
      {
         return this.mLevelDef.isUpgradeAllowed();
      }
      
      public function isPvPMatch() : Boolean
      {
         return false;
      }
      
      public function isOnlineMatch() : Boolean
      {
         return this.mIsOnlineMatch;
      }
      
      public function unloadCardBGResource(param1:String, param2:Boolean = false) : void
      {
         Root.assets.removeTexture(param1);
         if(param2)
         {
            Root.assets.removeTextureAtlas(param1,true);
         }
      }
      
      public function isMovingCardsFromSupportToAttack() : Boolean
      {
         return this.getPlayersStateId() == STATE_OWNER_MOVING_UP_FROM_SUPPORT || this.getPlayersStateId() == STATE_OPPONENT_MOVING_UP_FROM_SUPPORT;
      }
      
      public function getCardId() : int
      {
         return this.mOwnerCardsCount;
      }
      
      public function addCardsCount() : void
      {
         this.mOwnerCardsCount += 1;
         if(Config.TRACE_BATTLE_LOGS)
         {
            FSDebug.debugTrace("OWNER CARDS COUNT: " + this.mOwnerCardsCount);
         }
      }
      
      public function setSacrificeWaitingForTarget(param1:Boolean) : void
      {
         this.mSacrificeWaitingForTarget = param1;
         if(this.mSacrificeWaitingForTarget)
         {
            this.disableFreeReshuffleAfterUsingAbility();
         }
      }
      
      private function disableFreeReshuffleAfterUsingAbility() : void
      {
         if(this.mBattleScreen)
         {
            if(this.isOwnerTurn())
            {
               this.mBattleScreen.disableFreeReshuffle(this.mOwnerBattleInfo);
            }
            else
            {
               this.mBattleScreen.disableFreeReshuffle(this.mOpponentBattleInfo);
            }
         }
      }
      
      public function isPowerWaitingForTarget() : Boolean
      {
         return this.mPowerWaitingForTarget;
      }
      
      public function setPowerWaitingForTarget(param1:Boolean) : void
      {
         this.mPowerWaitingForTarget = param1;
         if(this.mPowerWaitingForTarget)
         {
            this.disableFreeReshuffleAfterUsingAbility();
         }
      }
      
      public function isSacrificeWaitingForTarget() : Boolean
      {
         return this.mSacrificeWaitingForTarget;
      }
      
      public function getReproductionDelayTimeForCard(param1:FSCard, param2:Boolean = false, param3:String = "") : Number
      {
         var _loc5_:AbilityDef = null;
         var _loc4_:Number = 0;
         if(param1 != null)
         {
            switch(param1.getType())
            {
               case FSCard.TYPE_UNIT:
                  if(param2)
                  {
                     _loc4_ = Config.getConfig().getDefaultPromoteAnimDuration();
                  }
                  else
                  {
                     _loc4_ = FSBattleScreenPvP.getResumeStdCardPlaybackTime() + param1.calculateTimeEllapsedForTriggeringAbilities();
                  }
                  break;
               case FSCard.TYPE_ATTACHMENT:
                  _loc4_ = FSBattleScreenPvP.getResumeStdCardPlaybackTime() + Config.getConfig().getDefaultTriggerAttachmentFadeOffDuration() + param1.calculateTimeEllapsedForTriggeringAbilities();
                  break;
               case FSCard.TYPE_ACTION:
               case FSCard.TYPE_POWER:
                  _loc4_ = Config.getConfig().getDefaultActionMoveToCenterAnimDuration() + Config.getConfig().getDefaultActionAnimDuration() + Config.getConfig().getDefaultDeathAnimDuration();
                  if(param3 != "")
                  {
                     _loc5_ = AbilityDef(InstanceMng.getAbilitiesDefMng().getDefBySku(param3));
                     if(_loc5_.hasAnimation() && Config.getConfig().getShowAbilitiesAnimations())
                     {
                        _loc4_ += CardAnimation.getMaxDuration();
                     }
                     _loc4_ += InstanceMng.getAbilitiesDefMng().getOnTargetSelectedExtraDelay(AbilityDef(InstanceMng.getAbilitiesDefMng().getDefBySku(param3)).getKeyName());
                  }
            }
         }
         _loc4_ += 0.75 * Utils.getDefaultSpeedTime();
         return _loc4_ + (Config.getConfig().gameHasPassive() ? 1 * Utils.getDefaultSpeedTime() : 0);
      }
      
      public function existCardWithSameName(param1:CardDef) : Boolean
      {
         var _loc4_:FSUnit = null;
         var _loc5_:int = 0;
         var _loc2_:Boolean = false;
         var _loc3_:UserBattleInfo = this.isOwnerTurn() ? this.mOwnerBattleInfo : this.mOpponentBattleInfo;
         if(_loc3_)
         {
            for each(_loc4_ in _loc3_.getFightCards())
            {
               _loc5_ = _loc4_.getCardDef().getFamilyId();
               if(param1.getFamilyId() != 0 && _loc5_ == param1.getFamilyId())
               {
                  _loc2_ = true;
                  break;
               }
            }
         }
         return _loc2_;
      }
      
      public function canCardBePlayedByFaction(param1:CardDef) : Boolean
      {
         var _loc4_:UserBattleInfo = null;
         var _loc5_:Dictionary = null;
         var _loc6_:String = null;
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         var _loc2_:Boolean = true;
         var _loc3_:Array = param1.getAllowedToPlayOnFactionDecks();
         if(_loc3_ != null && _loc3_.length > 0)
         {
            _loc4_ = this.isOwnerTurn() ? this.mOwnerBattleInfo : this.mOpponentBattleInfo;
            _loc5_ = _loc4_.getDeckFactions();
            _loc7_ = false;
            for each(_loc6_ in _loc5_)
            {
               _loc7_ = false;
               _loc8_ = 0;
               while(_loc8_ < _loc3_.length)
               {
                  if(_loc3_[_loc8_] == _loc6_)
                  {
                     _loc7_ = true;
                  }
                  _loc8_++;
               }
               if(!_loc7_)
               {
                  return false;
               }
            }
         }
         return _loc2_;
      }
      
      public function getOwnerPower() : FSPower
      {
         var _loc1_:UserData = null;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         if(this.mUserBattleInfoCatalog != null && this.mOwnerBattleInfo != null)
         {
            return this.mOwnerBattleInfo.getPowerCardFromDeck();
         }
         _loc1_ = Utils.getOwnerUserData();
         if(_loc1_)
         {
            _loc2_ = this.isPvPMatch() ? _loc1_.getSelectedDeckIndexPvP() : _loc1_.getSelectedDeckIndex();
            _loc3_ = _loc1_.getDefaultPowerSku(_loc2_);
            if(_loc3_ != null && _loc3_ != "")
            {
               return FSPower(_loc3_);
            }
         }
         return new FSPower(InstanceMng.getPowerDefMng().getDefByIndex(0).getSku());
      }
      
      public function getOpponentPower() : FSPower
      {
         if(this.mUserBattleInfoCatalog != null && this.mOpponentBattleInfo != null)
         {
            return this.mOpponentBattleInfo.getPowerCardFromDeck();
         }
         return new FSPower(InstanceMng.getPowerDefMng().getDefByIndex(0).getSku());
      }
      
      public function isPowerUsableAndHasTargets(param1:FSPower, param2:UserBattleInfo) : Boolean
      {
         var _loc4_:Ability = null;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc3_:Boolean = false;
         if(param1)
         {
            _loc4_ = Boolean(param1.getAbilities()) && param1.getAbilities().length > 0 ? param1.getAbilities()[0] : null;
            if(_loc4_ != null)
            {
               _loc5_ = _loc4_.highlightPossibleTargetsForAbility(true);
               _loc6_ = InstanceMng.getAbilitiesMng().isTargetSelectionAbility(_loc4_.getAbilityDef());
               if(Boolean(param2) && param2.isPowerAvailable())
               {
                  return _loc6_ && _loc5_ || !_loc6_;
               }
            }
         }
         return _loc3_;
      }
      
      public function executePowerAbility(param1:UserBattleInfo, param2:Boolean) : void
      {
         var _loc3_:FSPower = null;
         var _loc4_:Ability = null;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:BattleEngine = null;
         var _loc8_:Boolean = false;
         if(param1)
         {
            _loc3_ = param1.getPowerCardFromDeck();
            if(_loc3_)
            {
               if(param1.hasActionPointsLeft(_loc3_.getCardDef().getSummonCost()))
               {
                  _loc4_ = _loc3_.getAbilities()[0];
                  if(_loc4_ != null)
                  {
                     _loc5_ = _loc4_.highlightPossibleTargetsForAbility(true);
                     _loc6_ = InstanceMng.getAbilitiesMng().isTargetSelectionAbility(_loc4_.getAbilityDef());
                     if(param1.isPowerAvailable())
                     {
                        if(_loc6_ && _loc5_ || !_loc6_)
                        {
                           _loc7_ = InstanceMng.getBattleEngine();
                           if(_loc7_)
                           {
                              _loc8_ = this.isPowerWaitingForTarget();
                              if(!_loc8_)
                              {
                                 if(_loc6_)
                                 {
                                    this.setPowerWaitingForTarget(true);
                                 }
                                 _loc3_.executePower(param1,param2);
                              }
                              else
                              {
                                 this.setPowerWaitingForTarget(false);
                                 if(this.mBattleScreen)
                                 {
                                    this.mBattleScreen.highlightPowerTargets(false,_loc3_.getCardDef() as PowerDef);
                                    this.mBattleScreen.unHighlightPlayablePortraits(true);
                                    param1.setPowerAvailable(true,true);
                                    this.resetUILock();
                                    this.mBattleScreen.hideCancelPower(param2);
                                    this.mBattleScreen.suggestPlayableCardON();
                                 }
                              }
                           }
                        }
                        else
                        {
                           Utils.setLogText(TextManager.getText("TID_TARGET_NOT_ELEGIBLE"));
                        }
                     }
                     else
                     {
                        Utils.setLogText(TextManager.getText("TID_RETURN_ONCE"));
                        this.setPowerWaitingForTarget(false);
                     }
                  }
               }
               else
               {
                  Utils.setLogText(TextManager.getText("TID_LOG_ACTION"));
                  if(Config.getConfig().battleGetVoiceOnError())
                  {
                     Utils.playSound(Constants.SOUND_NOT_ENOUGH_MANA,SoundManager.TYPE_SFX);
                  }
               }
            }
         }
      }
      
      private function triggerBattleEvents(param1:int) : void
      {
         var _loc2_:LevelDef = null;
         var _loc3_:String = null;
         var _loc4_:BattleEventDef = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:FSEvent = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc9_:Boolean = false;
         _loc2_ = this.mOpponentBattleInfo.getLevelDef();
         if(_loc2_)
         {
            _loc10_ = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
            _loc11_ = _loc2_.getMapWorldParentIndex();
            _loc12_ = InstanceMng.getUserDataMng().getOwnerUserData().getMapWorldChoice(_loc12_);
            if(_loc2_ is RaidLevelDef)
            {
               _loc3_ = _loc2_.getBattleEventsSku(UserData.WORLD_DEFAULT);
            }
            else
            {
               _loc3_ = _loc2_.getBattleEventSkuByDifficulty(_loc10_,_loc12_);
            }
            if(_loc3_ != null && _loc3_ != "")
            {
               _loc4_ = BattleEventDef(InstanceMng.getBattleEventDefMng().getDefBySku(_loc3_));
               if(_loc4_)
               {
                  _loc7_ = _loc4_.getActionSku();
                  if(_loc7_)
                  {
                     switch(param1)
                     {
                        case BATTLE_EVENT_START_OF_TURN:
                           _loc5_ = this.mOpponentBattleInfo ? this.mOpponentBattleInfo.getActionPointsLeft() : 0;
                           _loc6_ = _loc2_.getAIActionPointsPerTurn();
                           if(_loc4_.getTriggerEvent() == BATTLE_EVENT_START_OF_TURN)
                           {
                              _loc8_ = this.mBattleScreen.createAIEvent(_loc7_);
                              if(_loc8_)
                              {
                                 _loc9_ = this.triggerBattleEventAbilities(_loc8_);
                                 if(_loc9_)
                                 {
                                    this.createBattleEventVisualEffect(_loc8_);
                                 }
                                 else
                                 {
                                    this.changePlayersState();
                                 }
                              }
                           }
                           else
                           {
                              this.changePlayersState();
                           }
                           break;
                        case BATTLE_EVENT_END_OF_TURN:
                           if(_loc4_.getTriggerEvent() == BATTLE_EVENT_END_OF_TURN)
                           {
                              _loc8_ = this.mBattleScreen.createAIEvent(_loc7_);
                              if(_loc8_)
                              {
                                 _loc9_ = this.triggerBattleEventAbilities(_loc8_);
                                 if(_loc9_)
                                 {
                                    this.createBattleEventVisualEffect(_loc8_);
                                 }
                                 else
                                 {
                                    this.changePlayersState();
                                 }
                              }
                           }
                           else
                           {
                              this.changePlayersState();
                           }
                     }
                  }
               }
               else
               {
                  this.changePlayersState();
               }
            }
            else
            {
               this.changePlayersState();
            }
         }
         else
         {
            this.changePlayersState();
         }
      }
      
      private function createBattleEventVisualEffect(param1:FSAction) : void
      {
         var containerWidth:int;
         var posX:int;
         var posY:int;
         var coord:FSCoordinate;
         var delay:Number = NaN;
         var startVanishFX:Function = null;
         var removeAssetFromParent:Function = null;
         var addCardToBattleScreen:Function = null;
         var actionEvent:FSAction = param1;
         startVanishFX = function():void
         {
            if(actionEvent)
            {
               SpecialFX.tweenToAlpha(actionEvent,0.001,1,0,removeAssetFromParent);
            }
            if(actionEvent.getShadow() != null)
            {
               SpecialFX.tweenToAlpha(actionEvent.getShadow(),0.001,1,0);
            }
         };
         removeAssetFromParent = function():void
         {
            if(actionEvent)
            {
               actionEvent.removeFromParent();
            }
            if(actionEvent.getShadow() != null)
            {
               actionEvent.getShadow().removeFromParent();
            }
         };
         addCardToBattleScreen = function(param1:FSCard):void
         {
            if(mBattleScreen)
            {
               mBattleScreen.addChild(param1);
            }
         };
         actionEvent.visible = true;
         actionEvent.alpha = 0.999;
         actionEvent.touchable = false;
         this.mBattleScreen.addChild(actionEvent);
         actionEvent.scaleX = 1.5;
         actionEvent.scaleY = 1.5;
         actionEvent.rotationX = deg2rad(30);
         actionEvent.rotationY = deg2rad(-180);
         SpecialFX.create3DRotation(actionEvent,Config.getConfig().getDefaultActionMoveToCenterAnimDuration() * 2,0,0);
         containerWidth = Starling.current.stage.stageWidth * 0.4;
         posX = containerWidth + this.mBattleScreen.getBFWidth() / 2;
         posY = this.mBattleScreen.getBFHeight();
         coord = new FSCoordinate(posX,posY);
         actionEvent.x = posX;
         actionEvent.y = -actionEvent.height;
         actionEvent.setAttachedToSocket(null,false,true);
         actionEvent.requestShowShadow(1.5,false);
         SpecialFX.createTransition(actionEvent,coord,Config.getConfig().getDefaultActionMoveToCenterAnimDuration(),0,addCardToBattleScreen,[actionEvent]);
         Utils.setLogText(actionEvent.getAbilities()[0].getAbilityDef().getDesc(),false,false,false);
         this.setActionUpgradeCostSelected(0);
         delay = this.getReproductionDelayTimeForCard(actionEvent,false,actionEvent.getAbilities()[0].getAbilityDef().getSku()) + Config.getConfig().getDefaultDeathAnimDuration();
         TweenMax.delayedCall(delay + Config.getConfig().getDefaultDeathAnimDuration(),this.checkCardsKilledInCombat);
         TweenMax.delayedCall(delay + Config.getConfig().getDefaultDeathAnimDuration(),this.checkIfBattleOver);
         TweenMax.delayedCall(delay,startVanishFX);
      }
      
      private function onActionSelectedPerformAbilityHighlights(param1:Ability) : void
      {
         if(param1)
         {
            param1.highlightPossibleTargetsForAbility();
            param1.onPlayableItemsHighlighted();
         }
      }
      
      public function isOwnerPowerActive() : Boolean
      {
         return this.mOwnerPowerIsActive;
      }
      
      public function isOpponentPowerActive() : Boolean
      {
         return this.mOpponentPowerIsActive;
      }
      
      public function removePermanentEffectFromAbility(param1:Vector.<Ability>) : void
      {
         var _loc2_:Ability = null;
         if(Boolean(param1) && param1.length > 0)
         {
            for each(_loc2_ in param1)
            {
               switch(_loc2_.getAbilityDef().getKeyName())
               {
                  case AbilitiesMng.SPECIAL_MODIFYCOST:
                     if(AbilitiesMng.getTargetType(_loc2_) == AbilitiesMng.TARGET_TYPE_FRIENDLY)
                     {
                        if(this.isPvPMatch() && this.isOwnerTurn() || !this.isPvPMatch())
                        {
                           this.mOpponentBattleInfo.setExtraSummonCost(0);
                           this.mOpponentBattleInfo.setModifySummonCostTurns(0);
                        }
                        else if(this.isPvPMatch() && !this.isOwnerTurn())
                        {
                           this.mOwnerBattleInfo.setExtraSummonCost(0);
                           this.mOwnerBattleInfo.setModifySummonCostTurns(0);
                        }
                     }
                     else if(AbilitiesMng.getTargetType(_loc2_) == AbilitiesMng.TARGET_TYPE_ENEMY)
                     {
                        if(this.isPvPMatch() && this.isOwnerTurn() || !this.isPvPMatch())
                        {
                           this.mOwnerBattleInfo.setExtraSummonCost(0);
                           this.mOwnerBattleInfo.setModifySummonCostTurns(0);
                        }
                        else if(this.isPvPMatch() && !this.isOwnerTurn())
                        {
                           this.mOpponentBattleInfo.setExtraSummonCost(0);
                           this.mOpponentBattleInfo.setModifySummonCostTurns(0);
                        }
                     }
                     else if(AbilitiesMng.getTargetType(_loc2_) == AbilitiesMng.TARGET_TYPE_ALL)
                     {
                        this.mOwnerBattleInfo.setExtraSummonCost(0);
                        this.mOwnerBattleInfo.setModifySummonCostTurns(0);
                        this.mOpponentBattleInfo.setExtraSummonCost(0);
                        this.mOpponentBattleInfo.setModifySummonCostTurns(0);
                     }
                     break;
                  case AbilitiesMng.SPECIAL_FIXEDCOST:
                     if(AbilitiesMng.getTargetType(_loc2_) == AbilitiesMng.TARGET_TYPE_FRIENDLY)
                     {
                        if(this.isPvPMatch() && this.isOwnerTurn() || !this.isPvPMatch())
                        {
                           this.mOpponentBattleInfo.setFixedSummonCost(0);
                           this.mOpponentBattleInfo.setTurnsFixedSummonCost(0);
                           this.mOpponentBattleInfo.setFixedSummonCostAbilityDef(null);
                           this.mOpponentBattleInfo.setModifySummonCostAbilityDef(null);
                           this.mOpponentBattleInfo.setModifySummonCostParentCard(null);
                           this.mOpponentBattleInfo.setFixedSummonCostParentCard(null);
                        }
                        else if(this.isPvPMatch() && !this.isOwnerTurn())
                        {
                           this.mOwnerBattleInfo.setFixedSummonCost(0);
                           this.mOwnerBattleInfo.setTurnsFixedSummonCost(0);
                           this.mOwnerBattleInfo.setFixedSummonCostAbilityDef(null);
                           this.mOwnerBattleInfo.setModifySummonCostAbilityDef(null);
                           this.mOwnerBattleInfo.setModifySummonCostParentCard(null);
                           this.mOwnerBattleInfo.setFixedSummonCostParentCard(null);
                        }
                     }
                     else if(AbilitiesMng.getTargetType(_loc2_) == AbilitiesMng.TARGET_TYPE_ENEMY)
                     {
                        if(this.isPvPMatch() && this.isOwnerTurn() || !this.isPvPMatch())
                        {
                           this.mOwnerBattleInfo.setFixedSummonCost(0);
                           this.mOwnerBattleInfo.setTurnsFixedSummonCost(0);
                           this.mOwnerBattleInfo.setFixedSummonCostAbilityDef(null);
                           this.mOwnerBattleInfo.setModifySummonCostAbilityDef(null);
                           this.mOwnerBattleInfo.setModifySummonCostParentCard(null);
                           this.mOwnerBattleInfo.setFixedSummonCostParentCard(null);
                        }
                        else if(this.isPvPMatch() && !this.isOwnerTurn())
                        {
                           this.mOpponentBattleInfo.setFixedSummonCost(0);
                           this.mOpponentBattleInfo.setTurnsFixedSummonCost(0);
                           this.mOpponentBattleInfo.setFixedSummonCostAbilityDef(null);
                           this.mOpponentBattleInfo.setModifySummonCostAbilityDef(null);
                           this.mOpponentBattleInfo.setModifySummonCostParentCard(null);
                           this.mOpponentBattleInfo.setFixedSummonCostParentCard(null);
                        }
                     }
                     else if(AbilitiesMng.getTargetType(_loc2_) == AbilitiesMng.TARGET_TYPE_ALL)
                     {
                        this.mOwnerBattleInfo.setExtraSummonCost(0);
                        this.mOwnerBattleInfo.setModifySummonCostTurns(0);
                        this.mOwnerBattleInfo.setFixedSummonCostAbilityDef(null);
                        this.mOwnerBattleInfo.setModifySummonCostAbilityDef(null);
                        this.mOwnerBattleInfo.setModifySummonCostParentCard(null);
                        this.mOwnerBattleInfo.setFixedSummonCostParentCard(null);
                        this.mOpponentBattleInfo.setExtraSummonCost(0);
                        this.mOpponentBattleInfo.setModifySummonCostTurns(0);
                        this.mOpponentBattleInfo.setFixedSummonCostAbilityDef(null);
                        this.mOpponentBattleInfo.setModifySummonCostAbilityDef(null);
                        this.mOpponentBattleInfo.setModifySummonCostParentCard(null);
                        this.mOpponentBattleInfo.setFixedSummonCostParentCard(null);
                     }
               }
            }
         }
      }
      
      public function ownerHasDiscarded() : Boolean
      {
         return this.mOwnerBattleInfo ? this.mOwnerBattleInfo.hasDiscarded() : false;
      }
      
      public function opponentHasDiscarded() : Boolean
      {
         return this.mOpponentBattleInfo ? this.mOpponentBattleInfo.hasDiscarded() : false;
      }
      
      public function isReshufflingHand() : Boolean
      {
         return this.mReshufflingHand;
      }
      
      public function flagAsReshuffling(param1:Boolean) : void
      {
         this.mReshufflingHand = param1;
      }
      
      public function reshuffleHand() : void
      {
         if(this.mBattleScreen)
         {
            this.storeCombatLogAction(COMBAT_LOG_RESHUFFLE);
            this.mReshufflingHand = true;
            this.mBattleScreen.enableBoostsPanel(false);
            this.mBattleScreen.lockUI(true);
            this.mBattleScreen.returnOwnerCardsToDeck(null,true);
            this.mBattleScreen.suggestPlayableCardOFF();
            this.mBattleScreen.lockUI(true);
            if(Config.getConfig().hasQuests())
            {
               InstanceMng.getQuestsMng().addActionPerformed(QuestsMng.TARGET_TYPE_USE_RESHUFFLE,1);
            }
         }
      }
      
      public function disableAttackButton(param1:Number = 0) : void
      {
         if(Boolean(this.mBattleScreen) && Boolean(this.mBattleScreen.getAttackButton()))
         {
            this.mBattleScreen.getAttackButton().disableAttackButton(param1);
         }
      }
      
      public function enableAttackButton() : void
      {
         if(Boolean(this.mBattleScreen) && Boolean(this.mBattleScreen.getAttackButton()))
         {
            this.mBattleScreen.getAttackButton().enableAttackButton();
         }
      }
      
      public function storeCombatLogAction(param1:String, param2:FSCard = null, param3:String = "", param4:Object = null) : void
      {
         var _loc5_:CardDef = null;
         var _loc6_:AbilityDef = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:* = undefined;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc15_:String = null;
         var _loc16_:String = null;
         var _loc17_:String = null;
         var _loc18_:Boolean = false;
         if(Boolean(this.mOwnerBattleInfo) && Boolean(this.mOpponentBattleInfo))
         {
            if(param2 != null && param1 != COMBAT_LOG_CARD_TO_HAND)
            {
               _loc18_ = param2.getAttachedToSocket() != null;
               if(!_loc18_ || param2 is FSAttachment && param2.getAttachedToSocket() != null && !param2.getAttachedToSocket().isBattlefieldSocket())
               {
                  return;
               }
            }
            _loc5_ = param2 ? param2.getCardDef() : null;
            _loc6_ = Boolean(param3) && param3 != "" ? AbilityDef(InstanceMng.getAbilitiesDefMng().getDefBySku(param3)) : null;
            _loc7_ = "";
            if(param2)
            {
               _loc7_ = param2.isEnemyCard() ? " [Opponent]" : " [Owner]";
            }
            _loc8_ = _loc5_ ? " | " + _loc5_.getSku() + " (" + _loc5_.getName(false,true) + ")" + _loc7_ : "";
            _loc9_ = _loc6_ ? " | " + param3 + " (" + _loc6_.getName(false,true) + ")" : "";
            _loc10_ = Boolean(param2) && param2.getAttachedToSocket() != null ? " Coords: " + param2.getAttachedToSocket().getCoordsString() : "";
            _loc11_ = "";
            if(param2)
            {
               if(param1 == COMBAT_LOG_ABILITY_EXECUTED && param2 is FSAction || param1 == COMBAT_LOG_CARD_MOVED_TO_BF || param1 == COMBAT_LOG_ATTACHMENT_USED || param1 == COMBAT_LOG_CARD_TO_HAND)
               {
                  _loc11_ = " | P_ID: " + param2.getPlayableCardId() + " | ID: " + param2.getId();
               }
            }
            _loc13_ = "";
            for(_loc12_ in param4)
            {
               _loc13_ += _loc13_ == "" ? " | " + _loc12_ + ":" + param4[_loc12_] : ", " + _loc12_ + ":" + param4[_loc12_];
            }
            _loc14_ = "";
            _loc15_ = "";
            _loc16_ = "";
            switch(param1)
            {
               case COMBAT_LOG_NEW_TURN:
               case COMBAT_LOG_ATTACK:
                  _loc14_ = "\n\n****************\n";
                  break;
               case COMBAT_LOG_END_TURN:
                  _loc16_ = "\n****************\n";
                  break;
               case COMBAT_LOG_MOVE_RECEIVED:
                  _loc15_ = "---";
                  break;
               case COMBAT_LOG_TURN_RECEIVED:
                  _loc15_ = "===";
                  break;
               case COMBAT_LOG_POOL_PUSH:
                  _loc15_ = "-->>";
                  break;
               case COMBAT_LOG_POOL_POP:
                  _loc15_ = "<<--";
                  break;
               default:
                  _loc14_ = "";
            }
            if(this.mCombatLogDate == null)
            {
               this.mCombatLogDate = new Date();
            }
            _loc17_ = _loc14_ + Utils.getFormattedUTCServerTime(this.mCombatLogDate) + " " + _loc15_ + param1 + _loc8_ + _loc10_ + _loc11_ + _loc9_ + _loc13_;
            smCombatLog += "\n" + _loc17_;
            FSDebug.debugTrace(_loc17_,"CL");
         }
      }
      
      private function resetCombatLog() : void
      {
         smCombatLog = "";
      }
      
      public function destroy() : void
      {
         FSDebug.debugTrace("[Destroying] " + this);
         Utils.destroyObject(this.mBattleStateId);
         this.mBattleStateId = null;
         Utils.destroyObject(this.mOwnerBattleInfo);
         this.mOwnerBattleInfo = null;
         Utils.destroyObject(this.mOpponentBattleInfo);
         this.mOpponentBattleInfo = null;
         this.mLevelDef = null;
         Utils.destroyObject(this.mNextStateId);
         this.mNextStateId = null;
         Utils.destroyObject(this.mAIEngine);
         this.mAIEngine = null;
         Utils.destroyObject(this.mAbilityWaitingForTarget);
         this.mAbilityWaitingForTarget = null;
         DictionaryUtils.clearDictionary(this.mUserBattleInfoCatalog);
         this.mUserBattleInfoCatalog = null;
         Utils.destroyArray(this.mNextHand);
         this.mNextHand = null;
         DictionaryUtils.clearDictionary(this.mBoostersUsed);
         this.mBoostersUsed = null;
         if(this.mIntroOwnerPlayer)
         {
            this.mIntroOwnerPlayer.removeFromParent(true);
         }
         this.mIntroOwnerPlayer = null;
         if(this.mIntroOpponentPlayer)
         {
            this.mIntroOpponentPlayer.removeFromParent(true);
         }
         this.mIntroOpponentPlayer = null;
         if(this.mIntroVSImage)
         {
            this.mIntroVSImage.removeFromParent(true);
         }
         if(this.mIntroVSMatchInfo)
         {
            this.mIntroVSMatchInfo.removeFromParent(true);
            this.mIntroVSMatchInfo = null;
         }
         this.mBoostWaitingForResources = null;
         this.mIntroVSImage = null;
         this.mBattleScreen = null;
      }
      
      public function increaseOwnCardsDefeated() : void
      {
         ++this.mOwnCardsDefeated;
      }
      
      public function flagOwnerAsHit() : void
      {
         this.mPlayerGotHitAtLeastOnce = true;
      }
      
      public function trackCardPlayed(param1:CardDef) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         if(param1)
         {
            if(this.mCategoriesPlayed == null)
            {
               this.mCategoriesPlayed = new Dictionary(true);
            }
            this.mCategoriesPlayed[param1.getCategorySku()] = 1;
            if(this.mSubcategoriesPlayed == null)
            {
               this.mSubcategoriesPlayed = new Dictionary(true);
            }
            if(param1.getSubCategorySku() != null)
            {
               _loc2_ = param1.getSubCategorySku();
               if(_loc2_)
               {
                  _loc3_ = 0;
                  while(_loc3_ < _loc2_.length)
                  {
                     this.mSubcategoriesPlayed[_loc2_[_loc3_]] = 1;
                     _loc3_++;
                  }
               }
            }
            if(this.mFactionsPlayed == null)
            {
               this.mFactionsPlayed = new Dictionary(true);
            }
            this.mFactionsPlayed[param1.getFactionSku()] = 1;
            if(this.mRaritiesPlayed == null)
            {
               this.mRaritiesPlayed = new Dictionary(true);
            }
            this.mRaritiesPlayed[param1.getCardRarity()] = 1;
         }
      }
      
      public function getCategoriesPlayed() : String
      {
         var _loc2_:Array = null;
         var _loc1_:String = "";
         if(this.mCategoriesPlayed)
         {
            _loc2_ = DictionaryUtils.dictionaryToArray(this.mCategoriesPlayed,true);
            _loc1_ = _loc2_ ? _loc2_.toString() : "";
         }
         return _loc1_;
      }
      
      public function getSubcategoriesPlayed() : String
      {
         var _loc2_:Array = null;
         var _loc1_:String = "";
         if(this.mSubcategoriesPlayed)
         {
            _loc2_ = DictionaryUtils.dictionaryToArray(this.mSubcategoriesPlayed,true);
            _loc1_ = _loc2_ ? _loc2_.toString() : "";
         }
         return _loc1_;
      }
      
      public function getFactionsPlayed() : String
      {
         var _loc2_:Array = null;
         var _loc1_:String = "";
         if(this.mFactionsPlayed)
         {
            _loc2_ = DictionaryUtils.dictionaryToArray(this.mFactionsPlayed,true);
            _loc1_ = _loc2_ ? _loc2_.toString() : "";
         }
         return _loc1_;
      }
      
      public function getRaritiesPlayed() : String
      {
         var _loc2_:Array = null;
         var _loc1_:String = "";
         if(this.mRaritiesPlayed)
         {
            _loc2_ = DictionaryUtils.dictionaryToArray(this.mRaritiesPlayed,true);
            _loc1_ = _loc2_ ? _loc2_.toString() : "";
         }
         return _loc1_;
      }
      
      public function getOwnCardsDefeatedAmount() : int
      {
         return this.mOwnCardsDefeated;
      }
      
      public function getPlayerGotHitAtLeastOnce() : Boolean
      {
         return this.mPlayerGotHitAtLeastOnce;
      }
      
      public function getCardBeingMoved() : FSCard
      {
         var _loc2_:FSCard = null;
         var _loc1_:Dictionary = this.mOwnerBattleInfo ? this.mOwnerBattleInfo.getPlayableCardsCatalog() : null;
         if(_loc1_)
         {
            for each(_loc2_ in _loc1_)
            {
               if(_loc2_.isCardBeingMoved())
               {
                  return _loc2_;
               }
            }
         }
         return null;
      }
      
      public function hasAnyPromoteableCards(param1:Boolean) : Boolean
      {
         var _loc3_:Vector.<FSCard> = null;
         var _loc4_:int = 0;
         var _loc2_:UserBattleInfo = param1 ? this.mOwnerBattleInfo : this.mOpponentBattleInfo;
         if(_loc2_)
         {
            _loc3_ = _loc2_.getFightCardsByType(FSCard.TYPE_UNIT);
            if(_loc3_)
            {
               _loc4_ = 0;
               _loc4_ = 0;
               while(_loc4_ < _loc3_.length)
               {
                  if(_loc3_[_loc4_].canBePromoted())
                  {
                     return true;
                  }
                  _loc4_++;
               }
            }
         }
         return false;
      }
      
      public function getCurrentMoveId() : int
      {
         return -1;
      }
      
      public function resetCurrentMoveId() : void
      {
      }
      
      public function resetLastProcessedMoveId() : void
      {
      }
      
      public function isResumingPvPCard() : Boolean
      {
         return this.mResumingCards;
      }
      
      public function setResumingPvPCard(param1:Boolean) : void
      {
         FSDebug.debugTrace("[PVP REAL TIME] ==== RESUMING CARDS: " + param1 + " ====");
         this.mResumingCards = param1;
      }
      
      public function onPvPCardResumedTurnEnded(param1:Number) : void
      {
      }
      
      public function onPvPOpponentReshuffledPerformOps() : void
      {
         this.onPvPOpponentReshuffledReceived(true);
         this.resetCurrentMoveId();
         this.resetLastProcessedMoveId();
         this.setBattleStateId(BATTLE_STATE_BATTLE_IDLE);
         this.setPlayersStateId(STATE_OPPONENT_RECEIVING_CARDS_FROM_DECK);
         this.setNextStateId(STATE_OPPONENT_MOVING_UP_FROM_SUPPORT);
      }
      
      public function replayCard(param1:FSCard, param2:FSCardSocket, param3:Boolean, param4:Boolean = false) : Number
      {
         var _loc5_:Number = !param3 ? this.bringUpPlayedCard(param1,1.5) : 0;
         var _loc6_:Number = !param3 ? _loc5_ + 3 * Utils.getDefaultSpeedTime() : 0;
         TweenMax.delayedCall(_loc6_,param1.setAttachedToSocket,[param2,param3,param4]);
         TweenMax.delayedCall(_loc6_ + 0.01,SpecialFX.zoomOut,[param1]);
         return _loc6_;
      }
      
      protected function bringUpPlayedCard(param1:FSCard, param2:Number = 1.5, param3:Number = 0.3) : Number
      {
         param1.touchable = false;
         param1.scaleX *= param2;
         param1.scaleY *= param2;
         SpecialFX.create3DRotation(param1,Config.getConfig().getDefaultActionMoveToCenterAnimDuration() * 2,0,0);
         var _loc4_:int = Starling.current.stage.stageWidth * 0.4;
         var _loc5_:int = _loc4_ + this.mBattleScreen.getBFWidth() / 2;
         var _loc6_:int = this.mBattleScreen.getBFHeight();
         var _loc7_:FSCoordinate = new FSCoordinate(_loc5_,_loc6_);
         param3 *= Utils.getDefaultSpeedTime();
         param1.requestShowShadow(param2,false);
         SpecialFX.createTransition(param1,_loc7_,param3);
         SpecialFX.createCardZoomTransition(param1,param2,param3);
         return param3;
      }
      
      public function setOpponentCanReceiveNextHand(param1:Boolean) : void
      {
         this.mOpponentAllowedToReceiveHand = param1;
      }
      
      public function canOpponentReceiveNextHand() : Boolean
      {
         return this.mOpponentAllowedToReceiveHand;
      }
   }
}

